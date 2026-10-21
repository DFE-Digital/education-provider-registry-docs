<#
.SYNOPSIS
Loads the checked-in Companies House registered-office observation for Outwood.
.DESCRIPTION
Uses the existing company-number identity. Run after the T10 parties and BAU
administrative addresses exist. No live web request or SQL Server is required.
#>
[CmdletBinding()]
param($PostgresTarget)
$ErrorActionPreference='Stop'
Import-Module (Join-Path $PSScriptRoot 'EprLocalAutomation/EprLocalAutomation.psm1')
$target=if($PostgresTarget){$PostgresTarget}else{New-PostgresTarget}
$workspace=New-RunWorkspace
try {
    & (Get-Module EprLocalAutomation) {
        param($target,$workspace)
        $json=[IO.File]::ReadAllText((Get-SchemaPath 'seed/fixtures/t10-registered-office.json'))
        $template=[IO.File]::ReadAllText((Get-SchemaPath 'establishment/load/load-registered-office-fixture.sql'))
        $load=ConvertTo-ReviewedFixtureSql -Template $template -FixtureJson $json
        $validation=[IO.File]::ReadAllText((Get-SchemaPath 'migration/validate-scripts/validate-t10-registered-office.sql'))
        $path=Join-Path $workspace 'registered-office.sql'
        $fingerprint=@'
SELECT md5(jsonb_build_object(
 'addresses',(SELECT jsonb_agg(to_jsonb(x) ORDER BY address_id) FROM establishment.address x),
 'associations',(SELECT jsonb_agg(to_jsonb(x) ORDER BY legal_entity_address_id) FROM establishment.legal_entity_address x),
 'runs',(SELECT jsonb_agg(to_jsonb(x) ORDER BY migration_run_id) FROM migration.migration_run x),
 'snapshots',(SELECT jsonb_agg(to_jsonb(x) ORDER BY source_snapshot_id) FROM migration.source_snapshot x),
 'records',(SELECT jsonb_agg(to_jsonb(x) ORDER BY source_record_id) FROM migration.source_record x),
 'evidence',(SELECT jsonb_agg(to_jsonb(x) ORDER BY group_address_evidence_id) FROM migration.group_address_evidence x)
)::text);
'@
        foreach($ending in @('ROLLBACK','COMMIT')) {
            [IO.File]::WriteAllText($path,"BEGIN;`n"+$load+"`n"+$validation+"`n$ending;",[Text.UTF8Encoding]::new($false))
            Invoke-Psql -Target $target -File $path -FailureMessage "Registered-office $ending import failed"
        }
        $first=Invoke-Psql -Target $target -Command $fingerprint -Output Scalar -FailureMessage 'Registered-office fingerprint failed'
        Invoke-Psql -Target $target -File $path -FailureMessage 'Registered-office repeated import failed'
        $second=Invoke-Psql -Target $target -Command $fingerprint -Output Scalar -FailureMessage 'Registered-office fingerprint failed'
        if($first -cne $second){throw 'Registered-office reimport changed target or evidence identities'}
        Write-Host 'Outwood registered office migrated with Companies House provenance; reimport stable.'
    } $target $workspace
} finally {Remove-RunWorkspace -Path $workspace}
