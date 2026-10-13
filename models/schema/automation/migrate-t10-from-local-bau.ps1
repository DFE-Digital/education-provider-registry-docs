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
  $extractUrns=@($fixture.extractAssertions | ForEach-Object { $_.URN })
  $rows=@(Import-Csv (Join-Path $root $fixture.extractPath) | Where-Object { $_.URN -in $extractUrns })
  foreach($expected in $fixture.extractAssertions){
   $matches=@($rows | Where-Object URN -eq $expected.URN)
   if($matches.Count -ne 1){throw 'Approved extract row scope changed; review required.'}
   foreach($field in $expected.PSObject.Properties){
    if([string]$matches[0].($field.Name) -cne [string]$field.Value){throw "Approved extract assertion changed: $($field.Name); review required."}
   }
  }
  $groupUids=@($fixture.associatedGroupUids)
  if($groupUids.Count -ne 2){throw 'The import-order probe requires two reviewed party groups.'}
  $partyLoads=@{}
  foreach($uid in $groupUids){
   $csv=Join-Path $workspace "t10-party-$uid.csv"
   $null=Export-BauQueryToCsv -Source $source -SqlFile (Get-SchemaPath 'establishment/transforms/academy-trust-responsibility-from-bau.sql') -Variables @{URN=$fixture.associatedEstablishmentUrn;GROUP_ID=$uid;INCLUDE_ARCHIVED=0} -CsvPath $csv -RowCount ExactlyOne -Description "T10 group $uid preflight"
   $sql=(Get-Content (Get-SchemaPath 'establishment/load/load-academy-trust-responsibility-fixture.sql') -Raw -Encoding UTF8).Replace('__FIXTURE_PATH__',($csv -replace '\\','/'))
   $partyLoads[$uid]=[regex]::Replace($sql,'(?m)^(BEGIN|COMMIT);\r?$','')+"`nDROP TABLE pg_temp.migration_context,pg_temp.establishment_party_role_fixture;`n"
  }
  $contextCsv=Join-Path $workspace 't10-context.csv'
  $null=Export-BauQueryToCsv -Source $source -SqlFile (Get-SchemaPath 'establishment/transforms/reviewed-proprietor-context-from-bau.sql') -Variables @{URN=$fixture.school.urn} -CsvPath $contextCsv -RowCount ExactlyOne -Description 'T10 raw local context'
  $academyCsv=Join-Path $workspace 't10-academy.csv'
  $null=Export-BauQueryToCsv -Source $source -SqlFile (Get-SchemaPath 'establishment/transforms/establishment-from-bau.sql') -Variables @{URN=$fixture.associatedEstablishmentUrn} -Columns $script:EstablishmentFixtureColumns -CsvPath $academyCsv -RowCount ExactlyOne -Description 'T10 academy preflight'
  # Minimal reviewed extract projection. No conflicting BAU geography, contact,
  # address or other unreviewed local school fields leak into the approved core.
  $controlled=@{urn=$fixture.school.urn;ukprn=$fixture.school.ukprn;local_authority_code=$fixture.school.localAuthorityCode;establishment_number=$fixture.school.establishmentNumber;name=$fixture.school.name;source_establishment_status_code=$fixture.school.statusCode;open_date=$fixture.school.openDate;close_date=$fixture.school.closeDate;establishment_type_id=$fixture.school.establishmentTypeId;education_phase_id=$fixture.school.educationPhaseId}
  $values=foreach($column in $script:EstablishmentFixtureColumns){if($controlled.ContainsKey($column)){ConvertTo-FixtureValue $controlled[$column]}else{'NULL'}}
  $mergedCsv=Join-Path $workspace 't10-schools.csv'
  $lines=[System.Collections.Generic.List[string]]::new()
  foreach($line in [System.IO.File]::ReadAllLines($academyCsv)){$lines.Add($line)}
  $lines.Add(($values -join '|'))
  [System.IO.File]::WriteAllLines($mergedCsv,$lines,[System.Text.UTF8Encoding]::new($false))
  $schoolSql=(Get-Content (Get-SchemaPath 'establishment/load/load-establishment-fixture.sql') -Raw -Encoding UTF8).Replace('__FIXTURE_PATH__',($mergedCsv -replace '\\','/'))
  $schoolSql=[regex]::Replace($schoolSql,'(?m)^(BEGIN|COMMIT);\r?$','')
  $decisionJson=$fixture | ConvertTo-Json -Depth 12 -Compress
  $proprietorTemplate=Get-Content (Get-SchemaPath 'establishment/load/load-reviewed-proprietor.sql') -Raw -Encoding UTF8
  $proprietorSql=(ConvertTo-ReviewedFixtureSql -Template $proprietorTemplate -FixtureJson $decisionJson).Replace('__FIXTURE_PATH__',($contextCsv -replace '\\','/'))
  $validation=Get-Content (Get-SchemaPath 'migration/validate-scripts/validate-t10-shared-responsibilities.sql') -Raw -Encoding UTF8
  $runId=[guid]::NewGuid()
  $runType=$fixture.runType.Replace("'","''");$version=$fixture.transformVersion.Replace("'","''")
  $sourceDatabase=$source.Database.Replace("'","''");$observed=$fixture.contextObservationDate
  $review=$fixture.reviewEvidence.Replace("'","''")
  $runSql="INSERT INTO migration.migration_run(migration_run_id,run_type,source_system,source_database,source_snapshot_date,status,transform_version,notes) VALUES('$runId','$runType','GIAS BAU','$sourceDatabase','$observed','running','$version','$review') ON CONFLICT(migration_run_id) DO UPDATE SET status='running';`nSET LOCAL epr.migration_run_id='$runId';`n"
  $finishSql="UPDATE migration.migration_run SET status='completed',completed_at=now() WHERE migration_run_id='$runId';`n"
  $preservedSql="SELECT coalesce(string_agg(urn::text || ':' || establishment_id::text,',' ORDER BY urn),'') FROM establishment.establishment WHERE urn NOT IN($($fixture.school.urn),$($fixture.associatedEstablishmentUrn));"
  $before=Invoke-Psql -Target $target -Command $preservedSql -Output Scalar -FailureMessage 'T10 scope check failed'
  $path=Join-Path $workspace 't10-load.sql'
  foreach($order in @(@($groupUids[0],$groupUids[1]),@($groupUids[1],$groupUids[0]))){
   $batch="BEGIN;`n"+$runSql+$schoolSql+$partyLoads[$order[0]]+$partyLoads[$order[1]]+$proprietorSql+$finishSql+$validation+"`nROLLBACK;"
   [System.IO.File]::WriteAllText($path,$batch,[System.Text.UTF8Encoding]::new($false))
   Invoke-Psql -Target $target -File $path -FailureMessage 'T10 atomic import-order probe failed'
  }
  $batch="BEGIN;`n"+$runSql+$schoolSql+$partyLoads[$groupUids[0]]+$partyLoads[$groupUids[1]]+$proprietorSql+$finishSql+$validation+"`nCOMMIT;"
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
  $batch="BEGIN;`n"+$runSql+$schoolSql+$partyLoads[$groupUids[1]]+$partyLoads[$groupUids[0]]+$proprietorSql+$finishSql+$validation+"`nCOMMIT;"
  [System.IO.File]::WriteAllText($path,$batch,[System.Text.UTF8Encoding]::new($false))
  Invoke-Psql -Target $target -File $path -FailureMessage 'T10 reverse reimport failed'
  $second=Invoke-Psql -Target $target -Command $stateSql -Output Scalar -FailureMessage 'T10 repeated state check failed'
  if($first -cne $second){throw 'T10 reimport changed business identities or counts.'}
  $approvedJson=$decisionJson.Replace("'","''")
  $badDecisions=@()
  $changed=$decisionJson | ConvertFrom-Json
  $changed.school.ukprn=[long]$changed.school.ukprn+1
  $badDecisions+=($changed | ConvertTo-Json -Depth 12 -Compress).Replace("'","''")
  $changed=$decisionJson | ConvertFrom-Json
  $changed.reviewEvidence='Unreviewed assertion'
  $badDecisions+=($changed | ConvertTo-Json -Depth 12 -Compress).Replace("'","''")
  foreach($badJson in $badDecisions){
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
   if($result.ExitCode -eq 0 -or $result.Messages -notlike '*approved decision changed; manual review required*'){throw "T10 unreviewed decision was not rejected: $($result.Messages)"}
  }
  Invoke-Psql -Target $target -File (Get-SchemaPath 'migration/validate-scripts/validate-t10-shared-responsibilities.sql') -FailureMessage 'T10 validation after rejection probes failed'
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
