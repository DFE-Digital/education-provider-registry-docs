<#
.SYNOPSIS
Atomically migrates the user-approved T10 shared Outwood responsibilities.
.DESCRIPTION
Reader preflight and June extract checks precede target writes. Uses the approved
minimal Eston core fixture, not the rejected-opening BAU school projection.
Tests both sponsor/trust import orders and stable reverse reimport. BAU unchanged.
#>
[CmdletBinding()]
param([string]$SqlServer='SL646104', $BauSource, $PostgresTarget)
$ErrorActionPreference='Stop'
Import-Module (Join-Path $PSScriptRoot 'EprLocalAutomation/EprLocalAutomation.psm1')
if(-not $env:EPR_BAU_SQL_PASSWORD){$env:EPR_BAU_SQL_PASSWORD=[Environment]::GetEnvironmentVariable('EPR_BAU_SQL_PASSWORD','User')}
if (-not $BauSource -and -not $env:EPR_BAU_SQL_PASSWORD) { throw 'EPR_BAU_SQL_PASSWORD is required.' }
$source=if($BauSource){$BauSource}else{New-BauSource -SqlServer $SqlServer -SqlUser reader}
$target=if($PostgresTarget){$PostgresTarget}else{New-PostgresTarget -PostgresHost localhost}
$workspace=New-RunWorkspace
try {
 & (Get-Module EprLocalAutomation) {
  param($source,$target,$workspace)
  $fixture=Get-Content (Get-SchemaPath 'seed/t10-controlled-decision.json') -Raw -Encoding UTF8 | ConvertFrom-Json
  $root=Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $script:SchemaRoot))
  $rows=@(Import-Csv (Join-Path $root $fixture.extractPath) | Where-Object {$_.URN -in @('148341','135961')})
  $eston=@($rows | Where-Object URN -eq '148341')
  $academy=@($rows | Where-Object URN -eq '135961')
  if($eston.Count -ne 1 -or $academy.Count -ne 1 -or $eston[0].EstablishmentName -cne $fixture.school.name -or $eston[0].PropsName -cne $fixture.propsName -or $eston[0].UKPRN -ne '10092329' -or $eston[0].'LA (code)' -ne '807' -or $eston[0].'EstablishmentStatus (code)' -ne '1' -or $eston[0].'TypeOfEstablishment (code)' -ne '11' -or $eston[0].EstablishmentNumber -ne '6003' -or $eston[0].'PhaseOfEducation (code)' -ne '0' -or $eston[0].OpenDate -ne '18-02-2021' -or $eston[0].CloseDate -ne '' -or $academy[0].EstablishmentName -cne 'Outwood Grange Academy' -or $academy[0].UKPRN -ne '10028145' -or $academy[0].'LA (code)' -ne '384' -or $academy[0].'EstablishmentStatus (code)' -ne '1' -or $academy[0].OpenDate -ne '01-09-2009' -or $academy[0].CloseDate -ne ''){throw 'T10 approved extract assertions changed; review required.'}
  $partyLoads=@{}
  foreach($uid in @(4118,4119)){
   $csv=Join-Path $workspace "t10-party-$uid.csv"
   $null=Export-BauQueryToCsv -Source $source -SqlFile (Get-SchemaPath 'establishment/transforms/academy-trust-responsibility-from-bau.sql') -Variables @{URN=135961;GROUP_ID=$uid;INCLUDE_ARCHIVED=0} -CsvPath $csv -RowCount ExactlyOne -Description "T10 group $uid preflight"
   $sql=(Get-Content (Get-SchemaPath 'establishment/load/load-academy-trust-responsibility-fixture.sql') -Raw -Encoding UTF8).Replace('__FIXTURE_PATH__',($csv -replace '\\','/'))
   $partyLoads[$uid]=[regex]::Replace($sql,'(?m)^(BEGIN|COMMIT);\r?$','')+"`nDROP TABLE pg_temp.migration_context,pg_temp.establishment_party_role_fixture;`n"
  }
  $contextCsv=Join-Path $workspace 't10-context.csv'
  $null=Export-BauQueryToCsv -Source $source -SqlFile (Get-SchemaPath 'establishment/transforms/t10-local-context-from-bau.sql') -CsvPath $contextCsv -RowCount ExactlyOne -Description 'T10 raw local context'
  $academyCsv=Join-Path $workspace 't10-academy.csv'
  $null=Export-BauQueryToCsv -Source $source -SqlFile (Get-SchemaPath 'establishment/transforms/establishment-from-bau.sql') -Variables @{URN=135961} -Columns $script:EstablishmentFixtureColumns -CsvPath $academyCsv -RowCount ExactlyOne -Description 'T10 academy preflight'
  # Minimal reviewed extract projection. No conflicting BAU geography, contact,
  # address or other unreviewed local school fields leak into the approved core.
  $controlled=@{urn=148341;ukprn=10092329;local_authority_code='807';establishment_number=6003;name=$fixture.school.name;source_establishment_status_code='1';open_date='2021-02-18';establishment_type_id=17;education_phase_id=8}
  $values=foreach($column in $script:EstablishmentFixtureColumns){if($controlled.ContainsKey($column)){ConvertTo-FixtureValue $controlled[$column]}else{'NULL'}}
  $mergedCsv=Join-Path $workspace 't10-schools.csv'
  $lines=[System.Collections.Generic.List[string]]::new()
  foreach($line in [System.IO.File]::ReadAllLines($academyCsv)){$lines.Add($line)}
  $lines.Add(($values -join '|'))
  [System.IO.File]::WriteAllLines($mergedCsv,$lines,[System.Text.UTF8Encoding]::new($false))
  $schoolSql=(Get-Content (Get-SchemaPath 'establishment/load/load-establishment-fixture.sql') -Raw -Encoding UTF8).Replace('__FIXTURE_PATH__',($mergedCsv -replace '\\','/'))
  $schoolSql=[regex]::Replace($schoolSql,'(?m)^(BEGIN|COMMIT);\r?$','')
  $proprietorSql=(Get-Content (Get-SchemaPath 'establishment/load/load-t10-approved-proprietor.sql') -Raw -Encoding UTF8).Replace('__FIXTURE_PATH__',($contextCsv -replace '\\','/')).Replace('__T10_DECISION_JSON__',($fixture | ConvertTo-Json -Depth 8 -Compress).Replace("'","''"))
  $validation=Get-Content (Get-SchemaPath 'establishment/validate-t10-shared-responsibilities.sql') -Raw -Encoding UTF8
  $runId=[guid]::NewGuid()
  $runSql="INSERT INTO migration.migration_run(migration_run_id,run_type,source_system,source_database,source_snapshot_date,status,transform_version,notes) VALUES('$runId','t10-additive','GIAS BAU','gias_bau_test_local','2026-10-09','running','t10-approved-v1','User-approved controlled Eston fixture and shared Outwood party; raw BAU context preserved.') ON CONFLICT(migration_run_id) DO UPDATE SET status='running';`nSET LOCAL epr.migration_run_id='$runId';`n"
  $finishSql="UPDATE migration.migration_run SET status='completed',completed_at=now() WHERE migration_run_id='$runId';`n"
  $preservedSql="SELECT coalesce(string_agg(urn::text || ':' || establishment_id::text,',' ORDER BY urn),'') FROM establishment.establishment WHERE urn NOT IN(148341,135961);"
  $before=Invoke-Psql -Target $target -Command $preservedSql -Output Scalar -FailureMessage 'T10 scope check failed'
  $path=Join-Path $workspace 't10-load.sql'
  foreach($order in @(@(4118,4119),@(4119,4118))){
   $batch="BEGIN;`n"+$runSql+$schoolSql+$partyLoads[$order[0]]+$partyLoads[$order[1]]+$proprietorSql+$finishSql+$validation+"`nROLLBACK;"
   [System.IO.File]::WriteAllText($path,$batch,[System.Text.UTF8Encoding]::new($false))
   Invoke-Psql -Target $target -File $path -FailureMessage 'T10 atomic import-order probe failed'
  }
  $batch="BEGIN;`n"+$runSql+$schoolSql+$partyLoads[4118]+$partyLoads[4119]+$proprietorSql+$finishSql+$validation+"`nCOMMIT;"
  [System.IO.File]::WriteAllText($path,$batch,[System.Text.UTF8Encoding]::new($false))
  Invoke-Psql -Target $target -File $path -FailureMessage 'T10 atomic migration failed'
  $stateSql=@'
SELECT json_build_object(
'schools',(SELECT string_agg(establishment_id::text,',' ORDER BY establishment_id) FROM establishment.establishment),
'parties',(SELECT string_agg(legal_entity_id::text,',' ORDER BY legal_entity_id) FROM establishment.legal_entity),
'roles',(SELECT string_agg(establishment_party_role_id::text,',' ORDER BY establishment_party_role_id) FROM establishment.establishment_party_role),
'responsibilities',(SELECT string_agg(establishment_responsibility_id::text,',' ORDER BY establishment_responsibility_id) FROM establishment.establishment_responsibility),
'classifications',(SELECT string_agg(academy_trust_classification_id::text,',' ORDER BY academy_trust_classification_id) FROM establishment.academy_trust_classification),
'organisation_identifiers',(SELECT string_agg(organisation_identifier_id::text,',' ORDER BY organisation_identifier_id) FROM establishment.organisation_identifier),
'group_identifiers',(SELECT string_agg(group_identifier_id::text,',' ORDER BY group_identifier_id) FROM establishment.group_identifier))::text;
'@
  $first=Invoke-Psql -Target $target -Command $stateSql -Output Scalar -FailureMessage 'T10 state check failed'
  $batch="BEGIN;`n"+$runSql+$schoolSql+$partyLoads[4119]+$partyLoads[4118]+$proprietorSql+$finishSql+$validation+"`nCOMMIT;"
  [System.IO.File]::WriteAllText($path,$batch,[System.Text.UTF8Encoding]::new($false))
  Invoke-Psql -Target $target -File $path -FailureMessage 'T10 reverse reimport failed'
  $second=Invoke-Psql -Target $target -Command $stateSql -Output Scalar -FailureMessage 'T10 repeated state check failed'
  if($first -cne $second){throw 'T10 reimport changed business identities or counts.'}
  $approvedJson=($fixture | ConvertTo-Json -Depth 8 -Compress).Replace("'","''")
  foreach($badJson in @($approvedJson.Replace('"ukprn":10092329','"ukprn":10000000'),$approvedJson.Replace('T10 user-approved controlled establishment and shared-party assertion','Unreviewed assertion'))){
   $badSql=$proprietorSql.Replace($approvedJson,$badJson)
   if($badSql -ceq $proprietorSql){throw 'T10 rejection probe did not alter the decision.'}
   [System.IO.File]::WriteAllText($path,"BEGIN;`n"+$runSql+$badSql+"`nROLLBACK;",[System.Text.UTF8Encoding]::new($false))
   $psql=Get-PostgresClientPath -Tool psql
   $arguments=Get-PsqlArgumentList -Target $target -File $path -Output Scalar
   $previousPreference=$ErrorActionPreference
   $passwordBefore=$env:PGPASSWORD
   try {
    if($target.Password){$env:PGPASSWORD=$target.Password}
    $ErrorActionPreference='Continue'
    $messages=(& $psql @arguments 2>&1 | ForEach-Object { $_.ToString() } | Out-String)
    $result=[pscustomobject]@{ExitCode=$LASTEXITCODE;Messages=$messages}
   } finally {$ErrorActionPreference=$previousPreference;$env:PGPASSWORD=$passwordBefore}
   if($result.ExitCode -eq 0 -or $result.Messages -notlike '*T10 approved decision changed; manual review required*'){throw "T10 unreviewed decision was not rejected: $($result.Messages)"}
  }
  Invoke-Psql -Target $target -File (Get-SchemaPath 'establishment/validate-t10-shared-responsibilities.sql') -FailureMessage 'T10 validation after rejection probes failed'
  $after=Invoke-Psql -Target $target -Command $preservedSql -Output Scalar -FailureMessage 'T10 preserved scope check failed'
  if($before -cne $after){throw 'T10 changed unrelated school scope or identities.'}
  Write-Host 'T10 migrated: two schools, one Outwood entity, two roles, three responsibilities; approved extract and conflicting BAU context retained; reverse reimport stable.'
 } $source $target $workspace
}
finally {
 $resolvedWorkspace=[System.IO.Path]::GetFullPath($workspace)
 $tempRoot=[System.IO.Path]::GetFullPath([System.IO.Path]::GetTempPath())
 if(-not $resolvedWorkspace.StartsWith($tempRoot,[StringComparison]::OrdinalIgnoreCase) -or (Split-Path -Leaf $resolvedWorkspace) -notlike 'epr-local-run-*'){throw 'Refusing cleanup outside the migration temporary directory.'}
 Remove-RunWorkspace -Path $resolvedWorkspace
}
