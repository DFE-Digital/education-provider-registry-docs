<#
.SYNOPSIS
Adds T13 to the existing local Establishment database without rebuilding it.
.DESCRIPTION
Uses reader and EPR_BAU_SQL_PASSWORD. Retains the accepted separate-party
assumption, probes both import orders inside rollback transactions, then
loads the two schools and validates stable reverse-order reimport.
Leaves the default fixture selection and checked-in SQL seeds unchanged.
#>
[CmdletBinding()]
param([string]$SqlServer='SL646104')
$ErrorActionPreference='Stop'
Import-Module (Join-Path $PSScriptRoot 'EprLocalAutomation/EprLocalAutomation.psm1') -Force
if (-not $env:EPR_BAU_SQL_PASSWORD) {
    $env:EPR_BAU_SQL_PASSWORD=[Environment]::GetEnvironmentVariable('EPR_BAU_SQL_PASSWORD','User')
}
if (-not $env:EPR_BAU_SQL_PASSWORD) { throw 'EPR_BAU_SQL_PASSWORD is required.' }
$source=New-BauSource -SqlServer $SqlServer -SqlUser reader
$target=New-PostgresTarget -PostgresHost localhost
$workspace=New-RunWorkspace
try {
    & (Get-Module EprLocalAutomation) {
        param($source,$target,$workspace)
        $fixture=Get-Content -LiteralPath (Get-SchemaPath 'seed/t13-controlled-proprietor.json') -Raw | ConvertFrom-Json
        $trustCsv=Join-Path $workspace 't13-trust.csv'
        $null=Export-BauQueryToCsv -Source $source `
            -SqlFile (Get-SchemaPath 'establishment/transforms/academy-trust-responsibility-from-bau.sql') `
            -Variables @{URN=137166;GROUP_ID=3641;INCLUDE_ARCHIVED=0} `
            -CsvPath $trustCsv -RowCount ExactlyOne -Description 'T13 source preflight'
        # Check the public proprietor assertion before any target writes.
        $workspaceRoot=Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $script:SchemaRoot))
        $extractRows=@(Import-Csv -LiteralPath (Join-Path $workspaceRoot $fixture.extractPath) |
            Where-Object { $_.URN -eq '115780' })
        if ($extractRows.Count -ne 1 -or $extractRows[0].PropsName -cne $fixture.name -or
            $extractRows[0].EstablishmentName -cne $fixture.schools[0].name -or
            $extractRows[0].'TypeOfEstablishment (name)' -ne 'Other independent school' -or
            $extractRows[0].'EstablishmentStatus (name)' -ne 'Open') {
            throw 'T13 public proprietor assertion changed; review required.'
        }
        $preservedSql="SELECT coalesce(string_agg(urn::text, ',' ORDER BY urn),'') FROM establishment.establishment WHERE urn NOT IN (115780,137166);"
        $before=Invoke-Psql -Target $target -Command $preservedSql -Output Scalar -FailureMessage 'Existing scope check failed'
        foreach ($urn in @(115780,137166)) {
            Import-EstablishmentFromBau -Source $source -Target $target -Urn $urn -WorkingDirectory $workspace
        }
        $runId=[guid]::NewGuid()
        $null=Invoke-Psql -Target $target -Command "INSERT INTO migration.migration_run (migration_run_id,run_type,source_system,source_database,source_snapshot_date,status,transform_version,notes) VALUES ('$runId','t13-additive','GIAS BAU','gias_bau_test_local',CURRENT_DATE,'running','t13-distinct-parties-v1','Accepted controlled separate-party assumption, not independently verified legal identity.');" -FailureMessage 'T13 run creation failed'
        try {
            # Render the existing loaders for rollback-only import-order probes.
            $contextCsv=Join-Path $workspace 't13-context.csv'
            $null=Export-BauQueryToCsv -Source $source `
                -SqlFile (Get-SchemaPath 'establishment/transforms/controlled-proprietor-context-from-bau.sql') `
                -Variables @{URNS=115780} -CsvPath $contextCsv -RowCount ExactlyOne -Description 'T13 proprietor context'
            $proprietorSql=(Get-Content -LiteralPath (Get-SchemaPath 'establishment/load/load-controlled-proprietor-fixture.sql') -Raw).
                Replace('__FIXTURE_PATH__',($contextCsv -replace '\\','/')).
                Replace('__CONTROLLED_PROPRIETOR_JSON__',($fixture | ConvertTo-Json -Depth 6 -Compress).Replace("'","''"))
            $trustSql=(Get-Content -LiteralPath (Get-SchemaPath 'establishment/load/load-academy-trust-responsibility-fixture.sql') -Raw).
                Replace('__FIXTURE_PATH__',($trustCsv -replace '\\','/'))
            $proprietorSql=[regex]::Replace($proprietorSql,'(?m)^(BEGIN|COMMIT);\r?$','')
            $trustSql=[regex]::Replace($trustSql,'(?m)^(BEGIN|COMMIT);\r?$','')
            $validation=Get-SchemaPath 'establishment/validate-t13-distinct-parties.sql'
            foreach ($order in @('trust-first','proprietor-first')) {
                $parts=@($trustSql,$proprietorSql)
                if ($order -eq 'proprietor-first') { $parts=@($proprietorSql,$trustSql) }
                $probe="BEGIN;`nSELECT set_config('epr.migration_run_id','$runId',false);`n" +
                    ($parts -join "`n") + "`n" + (Get-Content -LiteralPath $validation -Raw) + "`nROLLBACK;"
                $probePath=Join-Path $workspace "t13-$order.sql"
                [System.IO.File]::WriteAllText($probePath,$probe,[System.Text.UTF8Encoding]::new($false))
                Invoke-Psql -Target $target -File $probePath -FailureMessage "T13 $order probe failed"
            }
            Import-ControlledProprietorFromBau -Source $source -Target $target -Fixture $fixture `
                -WorkingDirectory $workspace -MigrationRunId $runId
            Import-EstablishmentPartyRoleFromBau -Source $source -Target $target -Urn 137166 `
                -SourceGroupId 3641 -WorkingDirectory $workspace -MigrationRunId $runId
            Invoke-Psql -Target $target -File $validation -FailureMessage 'T13 validation failed'
            $stateSql=@'
SELECT json_build_object(
 'parties',(SELECT string_agg(legal_entity_id::text,',' ORDER BY legal_entity_id) FROM establishment.legal_entity),
 'roles',(SELECT string_agg(establishment_party_role_id::text,',' ORDER BY establishment_party_role_id) FROM establishment.establishment_party_role),
 'responsibilities',(SELECT string_agg(establishment_responsibility_id::text,',' ORDER BY establishment_responsibility_id) FROM establishment.establishment_responsibility),
 'identifiers',(SELECT count(*) FROM establishment.organisation_identifier)+(SELECT count(*) FROM establishment.group_identifier),
 'classifications',(SELECT count(*) FROM establishment.academy_trust_classification))::text;
'@
            $first=Invoke-Psql -Target $target -Command $stateSql -Output Scalar -FailureMessage 'T13 state check failed'
            Import-EstablishmentPartyRoleFromBau -Source $source -Target $target -Urn 137166 `
                -SourceGroupId 3641 -WorkingDirectory $workspace -MigrationRunId $runId
            Import-ControlledProprietorFromBau -Source $source -Target $target -Fixture $fixture `
                -WorkingDirectory $workspace -MigrationRunId $runId
            foreach ($urn in @(137166,115780)) {
                Import-EstablishmentFromBau -Source $source -Target $target -Urn $urn -WorkingDirectory $workspace
            }
            Invoke-Psql -Target $target -File $validation -FailureMessage 'T13 reimport validation failed'
            $second=Invoke-Psql -Target $target -Command $stateSql -Output Scalar -FailureMessage 'T13 repeated state check failed'
            if ($first -cne $second) { throw 'T13 reimport changed business identities or counts.' }
            # The accepted fixture must not enable general name-only resolution.
            $collisionInsert=@'
INSERT INTO establishment_party_role_fixture (
 legal_entity_name,group_uid,establishment_party_role_type,responsibility_type,
 is_current,establishment_urn,responsibility_start_date,responsibility_is_current
) VALUES ('THE KING''S SCHOOL','T13_UNREVIEWED','School sponsor','Sponsored by',
          true,137166,DATE '2011-08-01',true);
'@
            $collisionSql=[regex]::Replace($trustSql,'(?m)^\\copy[^\r\n]*',
                [System.Text.RegularExpressions.MatchEvaluator]{param($match) $collisionInsert})
            $badFixture=$fixture | ConvertTo-Json -Depth 6 | ConvertFrom-Json
            $badFixture.separatePartyCompanyNumber='00000000'
            $badDecisionSql=(Get-Content -LiteralPath (Get-SchemaPath 'establishment/load/load-controlled-proprietor-fixture.sql') -Raw).
                Replace('__FIXTURE_PATH__',($contextCsv -replace '\\','/')).
                Replace('__CONTROLLED_PROPRIETOR_JSON__',($badFixture | ConvertTo-Json -Depth 6 -Compress).Replace("'","''"))
            $badDecisionSql=[regex]::Replace($badDecisionSql,'(?m)^(BEGIN|COMMIT);\r?$','')
            foreach ($test in @(
                @{Name='unreviewed-name';Sql=$collisionSql;Expected='*only a name match; identity review required*'},
                @{Name='changed-decision';Sql=$badDecisionSql;Expected='*differs from the accepted bounded fixture*'}
            )) {
                $testPath=Join-Path $workspace "t13-$($test.Name).sql"
                $testSql="BEGIN;`nSELECT set_config('epr.migration_run_id','$runId',false);`n" + $test.Sql + "`nROLLBACK;"
                [System.IO.File]::WriteAllText($testPath,$testSql,[System.Text.UTF8Encoding]::new($false))
                $psql=Get-PostgresClientPath -Tool psql
                $arguments=Get-PsqlArgumentList -Target $target -File $testPath -Output Scalar
                $result=Invoke-WithPostgresPassword -Target $target -ScriptBlock {
                    $previousPreference=$ErrorActionPreference
                    try {
                        $ErrorActionPreference='Continue'
                        $messages=(& $psql @arguments 2>&1 | ForEach-Object { $_.ToString() } | Out-String)
                        [pscustomobject]@{ExitCode=$LASTEXITCODE;Messages=$messages}
                    }
                    finally { $ErrorActionPreference=$previousPreference }
                }
                if ($result.ExitCode -eq 0 -or $result.Messages -notlike $test.Expected) {
                    throw "T13 $($test.Name) was not rejected as expected: $($result.Messages)"
                }
            }
            Invoke-Psql -Target $target -File $validation -FailureMessage 'T13 validation after rejection tests failed'
            $after=Invoke-Psql -Target $target -Command $preservedSql -Output Scalar -FailureMessage 'Preserved scope check failed'
            if ($before -cne $after) { throw 'T13 changed unrelated establishment scope.' }
            $null=Invoke-Psql -Target $target -Command "UPDATE migration.migration_run SET status='completed',completed_at=now() WHERE migration_run_id='$runId';" -FailureMessage 'T13 run completion failed'
            Write-Host 'T13 migrated and validated; both import orders retain separate parties and reimport is stable.'
        }
        catch {
            $null=Invoke-Psql -Target $target -Command "UPDATE migration.migration_run SET status='failed',completed_at=now() WHERE migration_run_id='$runId';" -FailureMessage 'T13 failed-run update failed'
            throw
        }
    } $source $target $workspace
}
finally {
    $resolvedWorkspace=[System.IO.Path]::GetFullPath($workspace)
    $tempRoot=[System.IO.Path]::GetFullPath([System.IO.Path]::GetTempPath())
    if (-not $resolvedWorkspace.StartsWith($tempRoot,[StringComparison]::OrdinalIgnoreCase) -or
        (Split-Path -Leaf $resolvedWorkspace) -notlike 'epr-local-run-*') {
        throw 'Refusing cleanup outside the migration temporary directory.'
    }
    Remove-RunWorkspace -Path $resolvedWorkspace
}
