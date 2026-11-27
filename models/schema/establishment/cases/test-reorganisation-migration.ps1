# Test the real case selection, payload rendering and SQL loader in isolated schemas.
# Controlled BAU assertions live in fixtures/. All database changes roll back.
[CmdletBinding()]
param([int]$Port=5432,[string]$Database='establishment_local',
      [string]$FixtureDirectory,
      [string]$Psql='C:\Program Files\PostgreSQL\18\bin\psql.exe')
$ErrorActionPreference='Stop'
if (-not $FixtureDirectory) {$FixtureDirectory=Join-Path $PSScriptRoot 'fixtures'}
$root=Split-Path (Split-Path $PSScriptRoot)
Import-Module (Join-Path $root 'automation/EprLocalAutomation/EprLocalAutomation.psm1') -Force
$module=Get-Module EprLocalAutomation
$workspace=New-RunWorkspace
$schema='epr_migration_check_'+[guid]::NewGuid().ToString('N')
$evidenceSchema=$schema+'_evidence'
try {
    & $module {
        param($fixtureRoot)
        $script:MigrationTestFixtures=$fixtureRoot
        $script:MigrationTestSql=[Text.StringBuilder]::new()
        $script:MigrationTestMode='valid'
        function script:Export-BauQueryToCsv {
            param($Source,$SqlFile,$Variables,$CsvPath,$RowCount,$Description)
            $dataset=if($SqlFile.EndsWith('reorganisation-links-from-bau.sql')){'links'}else{'participants'}
            $selected=@($Variables.URNS -split ',' | ForEach-Object {[int]$_})
            $rows=@(Import-Csv -LiteralPath (Join-Path $script:MigrationTestFixtures ("reorganisation-"+$dataset+".csv")) -Delimiter '|' |
                Where-Object {[int]$_.urn -in $selected})
            if($dataset -eq 'links'){
                if($script:MigrationTestMode -eq 'missing-link'){$rows=@($rows | Where-Object {$_.source_link_id -ne '19544'})}
                # Repeated source assertions must never create duplicate target pairs.
                $rows=@($rows)+@($rows)
            }
            $rows | ConvertTo-Csv -NoTypeInformation -Delimiter '|' | Set-Content -LiteralPath $CsvPath -Encoding UTF8
            return $rows.Count
        }
        function script:Invoke-Psql {
            param($Target,$File,$FailureMessage)
            $sql=Get-Content -LiteralPath $File -Raw
            $sql=[regex]::Replace($sql,'(?m)^BEGIN;\s*$','')
            $sql=[regex]::Replace($sql,'(?m)^COMMIT;\s*$','SET CONSTRAINTS ALL IMMEDIATE; SET CONSTRAINTS ALL DEFERRED;')
            $expected=$null
            if($script:MigrationTestMode -eq 'missing-link'){$expected='BAU reciprocal link assertions'}
            if($script:MigrationTestMode -eq 'target-conflict'){
                $sql="UPDATE establishment.establishment_lifecycle SET open_date='2012-01-01' WHERE establishment_id=md5('fixture:136494')::uuid;"+$sql
                $expected='Target lifecycle differs'
            }
            if($script:MigrationTestMode -eq 'event-conflict'){
                $sql="UPDATE establishment.establishment_reorganisation SET reorganisation_cause_id=2 WHERE reorganisation_pattern_id=1;"+$sql
                $expected='Existing event conflicts'
            }
            if($expected){$sql="SELECT pg_temp.expect_reorganisation_rejection('"+$sql.Replace("'","''")+"','"+$expected+"');"}
            [void]$script:MigrationTestSql.AppendLine($sql)
        }
    } $FixtureDirectory
    $run=[guid]::NewGuid()
    $ddl=Get-Content -LiteralPath (Join-Path $root 'establishment/establishment-schema.sql') -Raw
    $ddl=[regex]::Replace($ddl,'(?m)^COMMIT;\s*$','')
    $seed=Get-Content -LiteralPath (Join-Path $root 'seed/seed-reorganisation-reference-data.sql') -Raw
    $lifecycle=@(Import-Csv -LiteralPath (Join-Path $FixtureDirectory 'reorganisation-participants.csv') -Delimiter '|')
    $fixtureJson=(ConvertTo-Json -InputObject $lifecycle -Compress).Replace("'","''")
    $setup=@'
CREATE SCHEMA migration;
CREATE TABLE migration.migration_run(migration_run_id uuid PRIMARY KEY,notes text);
INSERT INTO migration.migration_run VALUES('__RUN_ID__','{}');
CREATE TABLE migration.relationship_load_error(migration_run_id uuid,urn integer,relationship_kind text,error_message text,source_row jsonb);
INSERT INTO establishment.establishment_type_category(code,name) VALUES(990001,'Migration test category');
INSERT INTO establishment.establishment_type(code,name,establishment_type_category_id)
SELECT '__migration_test__','Migration test type',establishment_type_category_id FROM establishment.establishment_type_category WHERE code=990001;
INSERT INTO establishment.establishment_status(code,name) VALUES(1,'Open'),(2,'Closed');
CREATE TEMP TABLE fixture_lifecycle AS SELECT * FROM jsonb_to_recordset('__FIXTURE__'::jsonb)
AS f(urn integer,status_code text,open_date text,close_date text);
INSERT INTO establishment.establishment(establishment_id,urn,name,establishment_type_id)
SELECT md5('fixture:'||urn)::uuid,urn,'Controlled establishment '||urn,establishment_type_id
FROM fixture_lifecycle CROSS JOIN establishment.establishment_type
WHERE code='__migration_test__' AND urn NOT IN (136494,130544);
INSERT INTO establishment.establishment_lifecycle(establishment_id,establishment_status_id,open_date,close_date)
SELECT e.establishment_id,s.establishment_status_id,nullif(f.open_date,'NULL')::date,nullif(f.close_date,'NULL')::date
FROM fixture_lifecycle f JOIN establishment.establishment e USING(urn)
JOIN establishment.establishment_status s ON s.code::text=f.status_code;
CREATE FUNCTION pg_temp.expect_reorganisation_rejection(statement text,expected text)
RETURNS void LANGUAGE plpgsql AS $test$
BEGIN
 BEGIN
  EXECUTE statement;
 EXCEPTION WHEN SQLSTATE 'P0001' THEN
  IF position(expected in SQLERRM)=0 THEN RAISE; END IF;
  RETURN;
 END;
 RAISE EXCEPTION 'Expected rejection did not occur: %',expected;
END $test$;
'@
    $setup=$setup.Replace('__RUN_ID__',"$run").Replace('__FIXTURE__',$fixtureJson)
    foreach($urn in @(113557,130540)){
        Import-EstablishmentReorganisations -Source @{Database='controlled-fixture'} -Target @{} -WorkingDirectory $workspace -Urn $urn -MigrationRunId $run
    }
    & $module {
        [void]$script:MigrationTestSql.AppendLine(@'
DO $$ BEGIN
 IF (SELECT count(*) FROM migration.relationship_load_error)<>2 OR EXISTS(SELECT 1 FROM establishment.establishment_reorganisation) THEN
 RAISE EXCEPTION 'Missing endpoints must not create partial replacement or amalgamation events'; END IF;
END $$;
INSERT INTO establishment.establishment(establishment_id,urn,name,establishment_type_id)
SELECT md5('fixture:'||urn)::uuid,urn,'Previously migrated establishment '||urn,establishment_type_id
FROM fixture_lifecycle CROSS JOIN establishment.establishment_type WHERE code='__migration_test__' AND urn IN (136494,130544);
INSERT INTO establishment.establishment_lifecycle(establishment_id,establishment_status_id,open_date,close_date)
SELECT e.establishment_id,s.establishment_status_id,nullif(f.open_date,'NULL')::date,nullif(f.close_date,'NULL')::date
FROM fixture_lifecycle f JOIN establishment.establishment e USING(urn)
JOIN establishment.establishment_status s ON s.code::text=f.status_code WHERE f.urn IN (136494,130544);
'@)
    }
    # No URN filter: equivalent to the final phase of a full rebuild.
    Import-EstablishmentReorganisations -Source @{Database='controlled-fixture'} -Target @{} -WorkingDirectory $workspace -MigrationRunId $run
    & $module {
        [void]$script:MigrationTestSql.AppendLine('CREATE TEMP TABLE first_events AS SELECT * FROM establishment.establishment_reorganisation; CREATE TEMP TABLE first_pairs AS SELECT * FROM establishment.establishment_succession; CREATE TEMP TABLE first_transfers AS SELECT * FROM establishment.establishment_provision_transfer; CREATE TEMP TABLE first_effects AS SELECT * FROM establishment.reorganisation_effect; CREATE TEMP TABLE first_participants AS SELECT * FROM establishment.reorganisation_participant;')
    }
    foreach($urn in @(136494,113557,135771,130546,130540,130541,130544,141384,141385,139979,137077,141561,112445,112451,121739)){
        Import-EstablishmentReorganisations -Source @{Database='controlled-fixture'} -Target @{} -WorkingDirectory $workspace -Urn $urn -MigrationRunId $run
    }
    foreach($negative in @(@('missing-link',139979),@('target-conflict',113557),@('event-conflict',113557))){
        & $module {param($mode) $script:MigrationTestMode=$mode} $negative[0]
        Import-EstablishmentReorganisations -Source @{Database='controlled-fixture'} -Target @{} -WorkingDirectory $workspace -Urn ([int]$negative[1]) -MigrationRunId $run
    }
    $assert=@'
DO $$ BEGIN
 IF (SELECT count(*) FROM establishment.establishment_reorganisation)<>7
 OR (SELECT count(*) FROM establishment.reorganisation_participant)<>18
 OR (SELECT count(*) FROM establishment.establishment_succession)<>9
 OR (SELECT count(*) FROM establishment.establishment_provision_transfer)<>3
 OR (SELECT count(*) FROM establishment.reorganisation_effect)<>2
 OR EXISTS(SELECT * FROM first_transfers EXCEPT SELECT * FROM establishment.establishment_provision_transfer)
 OR EXISTS(SELECT * FROM first_effects EXCEPT SELECT * FROM establishment.reorganisation_effect)
 OR EXISTS(SELECT * FROM first_events EXCEPT SELECT * FROM establishment.establishment_reorganisation)
 OR EXISTS(SELECT * FROM first_pairs EXCEPT SELECT * FROM establishment.establishment_succession)
 OR EXISTS(SELECT * FROM first_participants EXCEPT SELECT * FROM establishment.reorganisation_participant)
 THEN RAISE EXCEPTION 'Reruns changed identities or counts'; END IF;
 IF EXISTS(SELECT 1 FROM establishment.establishment WHERE establishment_id<>md5('fixture:'||urn)::uuid)
 THEN RAISE EXCEPTION 'Existing establishment identities were not reused'; END IF;
 IF EXISTS(SELECT 1 FROM establishment.establishment_reorganisation WHERE effective_date IS NOT NULL)
 THEN RAISE EXCEPTION 'An unagreed event date was inferred'; END IF;
 IF (SELECT count(DISTINCT p.reorganisation_outcome_id) FROM establishment.reorganisation_participant p
 JOIN establishment.establishment e USING(establishment_id) WHERE e.urn=135771)<>2
 THEN RAISE EXCEPTION 'Leeds absorption and amalgamation were conflated'; END IF;
 IF EXISTS(SELECT 1 FROM migration.migration_run
 WHERE (SELECT count(*) FROM jsonb_each(notes::jsonb->'reorganisations') c WHERE c.value->>'status'='loaded')<>7)
 THEN RAISE EXCEPTION 'Expected seven loaded case outcomes in the migration evidence'; END IF;
END $$;
SELECT 'PASS: R01-R07; seven events, eighteen participants, nine successions, three transfers, two effects; missing endpoints; all endpoint selections; shared Leeds identity; duplicate assertions; stable UUIDs; three atomic rejections' AS result;
ROLLBACK;
'@
    $body=& $module {$script:MigrationTestSql.ToString()}
    $sql=($ddl+[Environment]::NewLine+$seed+[Environment]::NewLine+$setup+[Environment]::NewLine+$body+[Environment]::NewLine+$assert).
        Replace('CREATE SCHEMA establishment;',"CREATE SCHEMA $schema;").Replace('establishment.',"$schema.").
        Replace('CREATE SCHEMA migration;',"CREATE SCHEMA $evidenceSchema;").Replace('migration.',"$evidenceSchema.")
    $file=Join-Path $workspace 'test-migration.sql'
    [IO.File]::WriteAllText($file,$sql,[Text.UTF8Encoding]::new($false))
    & $Psql -X -w -q -h 127.0.0.1 -p $Port -U postgres -d $Database -v ON_ERROR_STOP=1 -f $file
    if($LASTEXITCODE -ne 0){throw 'Reorganisation migration tests failed.'}
} finally {Remove-RunWorkspace -Path $workspace}
