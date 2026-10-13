# Shared migration workflow; case-specific scope and evidence live in JSON.
function Invoke-ReviewedGroupAddressMigration {
 param([Parameter(Mandatory)]$Source,[Parameter(Mandatory)]$Target,
       [Parameter(Mandatory)][string]$Workspace,[Parameter(Mandatory)][string]$FixtureFile)
 $fixturePath=Get-SchemaPath $FixtureFile
 Assert-FileExists $fixturePath
 $fixtureJson=Get-Content $fixturePath -Raw -Encoding UTF8
 $fixture=$fixtureJson | ConvertFrom-Json
 $caseLabel=$fixture.fixture
 $groupIds=(@($fixture.sourceGroups | ForEach-Object {
     $id=[int]$_.uid
     if($id -le 0){throw 'Reviewed address group UIDs must be positive integers.'}
     $id
 }) -join ',')
 Assert-FileExists (Get-SchemaPath ("migration/validate-scripts/"+$fixture.validator))
  $csv=Join-Path $workspace 'group-addresses.csv'
  $count=Export-BauQueryToCsv -Source $source -SqlFile (Get-SchemaPath 'establishment/transforms/group-addresses-from-bau.sql') -Variables @{GROUP_IDS=$groupIds} -CsvPath $csv -RowCount AtLeastOne -Description 'Reviewed address group address preflight'
  if($count -ne @($fixture.blockMappings).Count){throw 'Address extract does not match the reviewed fixture scope.'}
  Invoke-Psql -Target $target -Command "DO `$`$ BEGIN IF to_regclass('establishment.legal_entity_address') IS NULL OR to_regclass('establishment.organisation_group_address') IS NULL OR to_regclass('migration.group_address_evidence') IS NULL OR to_regclass('migration.organisation_group_address_evidence') IS NULL OR to_regclass('migration.person_address_evidence') IS NULL THEN RAISE EXCEPTION 'Build the current Establishment and migration schemas before migrating addresses'; END IF; END `$`$;" -FailureMessage 'Address migration schema preflight failed'
  $template=Get-Content (Get-SchemaPath 'establishment/load/load-reviewed-group-addresses.sql') -Raw -Encoding UTF8
  $load=(ConvertTo-ReviewedFixtureSql -Template $template -FixtureJson $fixtureJson).Replace('__FIXTURE_PATH__',($csv -replace '\\','/'))
  $validation=Get-Content (Get-SchemaPath ("migration/validate-scripts/"+$fixture.validator)) -Raw -Encoding UTF8
  $runId=[guid]::NewGuid()
  $databaseSql=$source.Database.Replace("'","''")
  $runType=$fixture.runType.Replace("'","''")
  $version=$fixture.transformVersion.Replace("'","''")
  $review=$fixture.reviewEvidence.Replace("'","''")
  $runSql="INSERT INTO migration.migration_run(migration_run_id,run_type,source_system,source_database,source_snapshot_date,status,transform_version,notes) VALUES('$runId','$runType','GIAS BAU','$databaseSql',CURRENT_DATE,'running','$version','$review') ON CONFLICT(migration_run_id) DO UPDATE SET status='running';`nSET LOCAL epr.migration_run_id='$runId';`n"
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
  $before=Invoke-Psql -Target $target -Command $preservedSql -Output Scalar -FailureMessage 'Reviewed address preserved business-state check failed'
  $stateSql=@'
SELECT json_build_object(
'addresses',(SELECT md5(string_agg(to_jsonb(x)::text,',' ORDER BY address_id)) FROM establishment.address x),
'associations',(SELECT md5(string_agg(to_jsonb(x)::text,',' ORDER BY legal_entity_address_id)) FROM establishment.legal_entity_address x),
'group_associations',(SELECT md5(string_agg(to_jsonb(x)::text,',' ORDER BY organisation_group_address_id)) FROM establishment.organisation_group_address x),
'snapshots',(SELECT count(*) FROM migration.source_snapshot),
'records',(SELECT count(*) FROM migration.source_record),
'evidence',(SELECT md5(string_agg(to_jsonb(x)::text,',' ORDER BY group_address_evidence_id)) FROM migration.group_address_evidence x),
'group_evidence',(SELECT md5(string_agg(to_jsonb(x)::text,',' ORDER BY organisation_group_address_evidence_id)) FROM migration.organisation_group_address_evidence x),
'person_evidence',(SELECT md5(string_agg(to_jsonb(x)::text,',' ORDER BY person_address_evidence_id)) FROM migration.person_address_evidence x))::text;
'@
  $path=Join-Path $workspace 'address-load.sql'
  # Exercise first-import branches without changing the retained target history.
  # Only associations for the fixture's resolved owners are removed, then restored
  # by the literal ROLLBACK ending below. Unreferenced postal rows are trial-only.
  $groupUidSql=($groupIds.Split(',') | ForEach-Object {"'$_'"}) -join ','
  $freshPrefix=@"
CREATE TEMP TABLE address_trial_links ON COMMIT DROP AS
SELECT link.* FROM establishment.legal_entity_address link WHERE legal_entity_id IN(
 SELECT r.legal_entity_id FROM establishment.group_identifier i
 JOIN establishment.group_identifier_type t USING(group_identifier_type_id)
 JOIN establishment.establishment_party_role r USING(establishment_party_role_id)
 WHERE t.name='Group UID' AND i.value IN($groupUidSql));
CREATE TEMP TABLE group_address_trial_links ON COMMIT DROP AS
SELECT link.* FROM establishment.organisation_group_address link WHERE organisation_group_id IN(
 SELECT i.organisation_group_id FROM establishment.group_identifier i
 JOIN establishment.group_identifier_type t USING(group_identifier_type_id)
 WHERE t.name='Group UID' AND i.value IN($groupUidSql) AND i.organisation_group_id IS NOT NULL);
DELETE FROM migration.group_address_evidence WHERE legal_entity_address_id IN(SELECT legal_entity_address_id FROM address_trial_links);
DELETE FROM migration.organisation_group_address_evidence WHERE organisation_group_address_id IN(SELECT organisation_group_address_id FROM group_address_trial_links);
DELETE FROM establishment.legal_entity_address WHERE legal_entity_address_id IN(SELECT legal_entity_address_id FROM address_trial_links);
DELETE FROM establishment.organisation_group_address WHERE organisation_group_address_id IN(SELECT organisation_group_address_id FROM group_address_trial_links);
DELETE FROM establishment.address a WHERE address_id IN(
 SELECT address_id FROM address_trial_links UNION SELECT address_id FROM group_address_trial_links)
 AND NOT EXISTS(SELECT 1 FROM establishment.site s WHERE s.address_id=a.address_id)
 AND NOT EXISTS(SELECT 1 FROM establishment.legal_entity_address l WHERE l.address_id=a.address_id)
 AND NOT EXISTS(SELECT 1 FROM establishment.organisation_group_address l WHERE l.address_id=a.address_id);
"@
  [IO.File]::WriteAllText($path,"BEGIN;`n"+$runSql+$freshPrefix+$load+$finish+$validation+"`nROLLBACK;",[Text.UTF8Encoding]::new($false))
  Invoke-Psql -Target $target -File $path -FailureMessage 'Reviewed address first-import rollback probe failed'
  foreach($ending in @('ROLLBACK','COMMIT')){
   [System.IO.File]::WriteAllText($path,"BEGIN;`n"+$runSql+$load+$finish+$validation+"`n$ending;",[System.Text.UTF8Encoding]::new($false))
   Invoke-Psql -Target $target -File $path -FailureMessage "Reviewed address address $ending probe failed"
  }
  $first=Invoke-Psql -Target $target -Command $stateSql -Output Scalar -FailureMessage 'Reviewed address address state check failed'
  Invoke-Psql -Target $target -File $path -FailureMessage 'Reviewed address address repeat import failed'
  $second=Invoke-Psql -Target $target -Command $stateSql -Output Scalar -FailureMessage 'Reviewed address repeated address state check failed'
  if($first -cne $second){throw 'Reviewed address repeated address import changed address/association identities or source evidence.'}
  # A changed source assertion must require review, not silently overwrite.
  $badCsv=Join-Path $workspace 'conflicting-address.csv'
  $lines=Get-Content $csv -Encoding UTF8
  $changed=$false
  $probe=@($fixture.sourceGroups | Where-Object uid -eq $fixture.conflictProbeGroupUid)
  if($probe.Count -ne 1){throw 'Invalid conflict-probe group in reviewed fixture.'}
  $probePrefix="$($probe[0].uid)|$($probe[0].typeCode)|primary|"
  $badLines=foreach($line in $lines){
   if($line.StartsWith($probePrefix)){
    $parts=$line.Split('|');$parts[3]='Reviewed address_TEST_UNREVIEWED_ADDRESS';$changed=$true;$parts -join '|'
   }else{$line}
  }
  if(-not $changed){throw 'Reviewed address rejection fixture was not changed.'}
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
  if($exitCode -eq 0 -or $messages -notlike '*manual migration decision required*'){throw 'Reviewed address unreviewed address conflict was not rejected as expected.'}
  $afterRejection=Invoke-Psql -Target $target -Command $stateSql -Output Scalar -FailureMessage 'Reviewed address rejection state recheck failed'
  if($first -cne $afterRejection){throw 'Reviewed address rejected import changed addresses or evidence.'}
  Invoke-Psql -Target $target -File (Get-SchemaPath ("migration/validate-scripts/"+$fixture.validator)) -FailureMessage 'Reviewed address final address validation failed'
  $after=Invoke-Psql -Target $target -Command $preservedSql -Output Scalar -FailureMessage 'Reviewed address preserved state recheck failed'
  if($before -cne $after){throw 'Reviewed address address migration changed existing establishments, parties, responsibilities or site addresses.'}
  Write-Host "$caseLabel reviewed addresses migrated; business dates unknown; all $count source blocks retained; repeat import stable."
}
