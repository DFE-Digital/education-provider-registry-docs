<#
.SYNOPSIS
Adds T12 to the existing local Establishment database and validates reimport.
.DESCRIPTION
Reads the local BAU copy as reader using EPR_BAU_SQL_PASSWORD. Loads only
New Fosseway School and foundation-trust link 595. Does not rebuild schemas
or replace the default fixture selection or checked-in seeds.
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
        $null=Export-BauQueryToCsv -Source $source `
            -SqlFile (Get-SchemaPath 'establishment/transforms/academy-trust-responsibility-from-bau.sql') `
            -Variables @{URN=109393;GROUP_ID=1193;INCLUDE_ARCHIVED=0} `
            -CsvPath (Join-Path $workspace 't12-preflight.csv') -RowCount ExactlyOne -Description 'T12 preflight'
        $preservedUrnsSql="SELECT coalesce(string_agg(urn::text, ',' ORDER BY urn),'') FROM establishment.establishment WHERE urn<>109393;"
        $before=Invoke-Psql -Target $target -Command $preservedUrnsSql -Output Scalar -FailureMessage 'Existing URN check failed'
        Import-EstablishmentFromBau -Source $source -Target $target -Urn 109393 -WorkingDirectory $workspace
        Import-EstablishmentPartyRoleFromBau -Source $source -Target $target -Urn 109393 -SourceGroupId 1193 -WorkingDirectory $workspace
        $validation=Get-SchemaPath 'establishment/validate-t12-foundation-trust.sql'
        Invoke-Psql -Target $target -File $validation -FailureMessage 'T12 validation failed'
        $stateSql=@'
SELECT json_build_object(
 'parties', (SELECT string_agg(legal_entity_id::text, ',' ORDER BY legal_entity_id) FROM establishment.legal_entity),
 'roles', (SELECT string_agg(establishment_party_role_id::text, ',' ORDER BY establishment_party_role_id) FROM establishment.establishment_party_role),
 'responsibilities', (SELECT string_agg(establishment_responsibility_id::text, ',' ORDER BY establishment_responsibility_id) FROM establishment.establishment_responsibility),
 'identifiers', (SELECT count(*) FROM establishment.organisation_identifier)+(SELECT count(*) FROM establishment.group_identifier),
 'classifications', (SELECT count(*) FROM establishment.academy_trust_classification))::text;
'@
        $first=Invoke-Psql -Target $target -Command $stateSql -Output Scalar -FailureMessage 'T12 state check failed'
        Import-EstablishmentFromBau -Source $source -Target $target -Urn 109393 -WorkingDirectory $workspace
        Import-EstablishmentPartyRoleFromBau -Source $source -Target $target -Urn 109393 -SourceGroupId 1193 -WorkingDirectory $workspace
        Invoke-Psql -Target $target -File $validation -FailureMessage 'T12 reimport validation failed'
        $second=Invoke-Psql -Target $target -Command $stateSql -Output Scalar -FailureMessage 'T12 repeated state check failed'
        if ($first -cne $second) { throw 'T12 reimport changed business identities or counts.' }

        # Exercise the actual loader with an unreviewed same-name party.
        # The expected failure rolls back its transaction. Also replace COMMIT
        # with ROLLBACK so even an unexpected successful load cannot persist.
        $loader=Get-Content -LiteralPath (Get-SchemaPath 'establishment/load/load-academy-trust-responsibility-fixture.sql') -Raw
        $collisionInsert=@'
INSERT INTO establishment_party_role_fixture (
 legal_entity_name,group_uid,establishment_party_role_type,responsibility_type,
 is_current,establishment_urn,responsibility_start_date,responsibility_is_current
) VALUES ('Trust in Learning','T12_UNREVIEWED_NAME_COLLISION','Foundation trust',
          'Supported by foundation trust',true,109393,DATE '2010-09-01',true);
'@
        $collisionSql=[regex]::Replace($loader,'(?m)^\\copy[^\r\n]*',
            [System.Text.RegularExpressions.MatchEvaluator]{param($match) $collisionInsert})
        $collisionSql=[regex]::Replace($collisionSql,'(?m)^COMMIT;','ROLLBACK;')
        $collisionPath=Join-Path $workspace 't12-name-collision.sql'
        [System.IO.File]::WriteAllText($collisionPath,$collisionSql,[System.Text.UTF8Encoding]::new($false))
        $preCollisionErrorAction=$ErrorActionPreference
        try {
            $ErrorActionPreference='Continue'
            $collisionOutput=(& (Get-PostgresClientPath -Tool psql) -X -w -h localhost -p 5432 -U postgres `
                -d establishment_local -v ON_ERROR_STOP=1 -f $collisionPath 2>&1 | Out-String)
            $collisionExit=$LASTEXITCODE
        }
        finally { $ErrorActionPreference=$preCollisionErrorAction }
        if ($collisionExit -eq 0 -or $collisionOutput -notlike '*only a name match; identity review required*') {
            throw "T12 name-collision rejection did not produce the expected review requirement: $collisionOutput"
        }
        $after=Invoke-Psql -Target $target -Command $preservedUrnsSql -Output Scalar -FailureMessage 'Preserved URN check failed'
        if ($before -cne $after) { throw 'T12 import changed unrelated establishment scope.' }
        Invoke-Psql -Target $target -File $validation -FailureMessage 'Final T12 validation failed'
        Write-Host 'T12 migrated and validated; reimport is stable and unreviewed name collisions require review.'
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
