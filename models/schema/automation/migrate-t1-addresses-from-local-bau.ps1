<#
.SYNOPSIS
Migrates T1's available SAT/MAT administrative addresses, not registered offices.
.DESCRIPTION
Reader preflight precedes an additive schema upgrade. Six primary/contact source
blocks retain evidence; current associations have unknown business dates.
Atomic rollback/load and same-run reimport checks run without a schema rebuild.
#>
[CmdletBinding()]
param([string]$SqlServer='SL646104',$BauSource,$PostgresTarget)
$ErrorActionPreference='Stop'
Import-Module (Join-Path $PSScriptRoot 'EprLocalAutomation/EprLocalAutomation.psm1')
if(-not $env:EPR_BAU_SQL_PASSWORD){$env:EPR_BAU_SQL_PASSWORD=[Environment]::GetEnvironmentVariable('EPR_BAU_SQL_PASSWORD','User')}
if(-not $BauSource -and -not $env:EPR_BAU_SQL_PASSWORD){throw 'EPR_BAU_SQL_PASSWORD is required.'}
$source=if($BauSource){$BauSource}else{New-BauSource -SqlServer $SqlServer -SqlUser reader}
$target=if($PostgresTarget){$PostgresTarget}else{New-PostgresTarget -PostgresHost localhost}
$workspace=New-RunWorkspace
try {
 & (Get-Module EprLocalAutomation) {
  param($source,$target,$workspace)
  $csv=Join-Path $workspace 't1-group-addresses.csv'
  $count=Export-BauQueryToCsv -Source $source -SqlFile (Get-SchemaPath 'establishment/transforms/t1-group-addresses-from-bau.sql') -CsvPath $csv -RowCount AtLeastOne -Description 'T1 group address preflight'
  if($count -ne 6){throw 'T1 address extract must retain six source blocks.'}
  Invoke-Psql -Target $target -File (Get-SchemaPath 'establishment/upgrade-group-addresses.sql') -FailureMessage 'Group-address schema upgrade failed'
  $load=(Get-Content (Get-SchemaPath 'establishment/load/load-t1-group-addresses.sql') -Raw -Encoding UTF8).Replace('__FIXTURE_PATH__',($csv -replace '\\','/'))
  $validation=Get-Content (Get-SchemaPath 'establishment/validate-t1-group-addresses.sql') -Raw -Encoding UTF8
  $runId=[guid]::NewGuid()
  $databaseSql=$source.Database.Replace("'","''")
  $runSql="INSERT INTO migration.migration_run(migration_run_id,run_type,source_system,source_database,source_snapshot_date,status,transform_version,notes) VALUES('$runId','group-addresses-t1','GIAS BAU','$databaseSql',CURRENT_DATE,'running','t1-addresses-v1','Primary administrative addresses only; no registered-office assertion; blank contact/sponsor blocks retained; unresolved county codes preserved.') ON CONFLICT(migration_run_id) DO UPDATE SET status='running';`nSET LOCAL epr.migration_run_id='$runId';`n"
  $finish="UPDATE migration.migration_run SET status='completed',completed_at=now() WHERE migration_run_id='$runId';`n"
  $preservedSql=@'
SELECT json_build_object(
'schools',(SELECT md5(string_agg(to_jsonb(x)::text,',' ORDER BY urn)) FROM establishment.establishment x),
'roles',(SELECT md5(string_agg(to_jsonb(x)::text,',' ORDER BY establishment_party_role_id)) FROM establishment.establishment_party_role x),
'identifiers',(SELECT md5(string_agg(to_jsonb(x)::text,',' ORDER BY organisation_identifier_id)) FROM establishment.organisation_identifier x),
'responsibilities',(SELECT md5(string_agg(to_jsonb(x)::text,',' ORDER BY establishment_responsibility_id)) FROM establishment.establishment_responsibility x),
'memberships',(SELECT md5(string_agg(to_jsonb(x)::text,',' ORDER BY organisation_group_member_id)) FROM establishment.organisation_group_member x),
'sites',(SELECT md5(string_agg(to_jsonb(x)::text,',' ORDER BY site_id)) FROM establishment.site x),
'site_addresses',(SELECT md5(string_agg(to_jsonb(x)::text,',' ORDER BY x.address_id)) FROM establishment.address x WHERE EXISTS(SELECT 1 FROM establishment.site s WHERE s.address_id=x.address_id)))::text;
'@
  $before=Invoke-Psql -Target $target -Command $preservedSql -Output Scalar -FailureMessage 'T1 preserved business-state check failed'
  $stateSql=@'
SELECT json_build_object(
'addresses',(SELECT md5(string_agg(to_jsonb(x)::text,',' ORDER BY address_id)) FROM establishment.address x),
'associations',(SELECT md5(string_agg(to_jsonb(x)::text,',' ORDER BY legal_entity_address_id)) FROM establishment.legal_entity_address x),
'snapshots',(SELECT count(*) FROM migration.source_snapshot),
'records',(SELECT count(*) FROM migration.source_record),
'evidence',(SELECT md5(string_agg(to_jsonb(x)::text,',' ORDER BY group_address_evidence_id)) FROM migration.group_address_evidence x))::text;
'@
  $path=Join-Path $workspace 't1-address-load.sql'
  foreach($ending in @('ROLLBACK','COMMIT')){
   [System.IO.File]::WriteAllText($path,"BEGIN;`n"+$runSql+$load+$finish+$validation+"`n$ending;",[System.Text.UTF8Encoding]::new($false))
   Invoke-Psql -Target $target -File $path -FailureMessage "T1 address $ending probe failed"
  }
  $first=Invoke-Psql -Target $target -Command $stateSql -Output Scalar -FailureMessage 'T1 address state check failed'
  Invoke-Psql -Target $target -File $path -FailureMessage 'T1 address repeat import failed'
  $second=Invoke-Psql -Target $target -Command $stateSql -Output Scalar -FailureMessage 'T1 repeated address state check failed'
  if($first -cne $second){throw 'T1 repeated address import changed address/association identities or source evidence.'}
  # A changed source assertion must require review, not silently overwrite.
  $badCsv=Join-Path $workspace 't1-conflicting-address.csv'
  $lines=Get-Content $csv -Encoding UTF8
  $changed=$false
  $badLines=foreach($line in $lines){
   if($line.StartsWith('2777|06|primary|')){
    $parts=$line.Split('|');$parts[3]='T1_TEST_UNREVIEWED_ADDRESS';$changed=$true;$parts -join '|'
   }else{$line}
  }
  if(-not $changed){throw 'T1 rejection fixture was not changed.'}
  [System.IO.File]::WriteAllLines($badCsv,[string[]]$badLines,[System.Text.UTF8Encoding]::new($false))
  $badLoad=$load.Replace(($csv -replace '\\','/'),($badCsv -replace '\\','/'))
  [System.IO.File]::WriteAllText($path,"BEGIN;`n"+$runSql+$badLoad+"`nROLLBACK;",[System.Text.UTF8Encoding]::new($false))
  $psql=Get-PostgresClientPath -Tool psql
  $arguments=Get-PsqlArgumentList -Target $target -File $path -Output Scalar
  $previousPreference=$ErrorActionPreference;$passwordBefore=$env:PGPASSWORD
  try{
   if($target.Password){$env:PGPASSWORD=$target.Password}
   $ErrorActionPreference='Continue'
   $messages=(& $psql @arguments 2>&1 | ForEach-Object {$_.ToString()} | Out-String)
   $exitCode=$LASTEXITCODE
  }finally{$ErrorActionPreference=$previousPreference;$env:PGPASSWORD=$passwordBefore}
  if($exitCode -eq 0 -or $messages -notlike '*manual migration decision required*'){throw 'T1 unreviewed address conflict was not rejected as expected.'}
  $afterRejection=Invoke-Psql -Target $target -Command $stateSql -Output Scalar -FailureMessage 'T1 rejection state recheck failed'
  if($first -cne $afterRejection){throw 'T1 rejected import changed addresses or evidence.'}
  Invoke-Psql -Target $target -File (Get-SchemaPath 'establishment/validate-t1-group-addresses.sql') -FailureMessage 'T1 final address validation failed'
  $after=Invoke-Psql -Target $target -Command $preservedSql -Output Scalar -FailureMessage 'T1 preserved state recheck failed'
  if($before -cne $after){throw 'T1 address migration changed existing establishments, parties, responsibilities or site addresses.'}
  Write-Host 'T1 addresses migrated: two current administrative associations with unknown business dates; all six source blocks retain evidence; repeat import stable.'
 } $source $target $workspace
} finally {
 $resolved=[System.IO.Path]::GetFullPath($workspace)
 $tempRoot=[System.IO.Path]::GetFullPath([System.IO.Path]::GetTempPath())
 if(-not $resolved.StartsWith($tempRoot,[StringComparison]::OrdinalIgnoreCase) -or (Split-Path -Leaf $resolved) -notlike 'epr-local-run-*'){throw 'Refusing cleanup outside the migration temporary directory.'}
 Remove-RunWorkspace -Path $resolved
}
