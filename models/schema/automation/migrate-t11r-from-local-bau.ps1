<#
.SYNOPSIS
Adds the bounded T11R case to the existing local Establishment database.
.DESCRIPTION
Uses the reader login and EPR_BAU_SQL_PASSWORD. Does not rebuild schemas or
replace the checked-in fixture set. Loads the sponsor first, then the trust,
and reimports in reverse order to verify stable identity and business rows.
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
        # Validate both selected source projections before target writes.
        foreach ($group in @(4075,4076)) {
            $null=Export-BauQueryToCsv -Source $source `
                -SqlFile (Get-SchemaPath 'establishment/transforms/academy-trust-responsibility-from-bau.sql') `
                -Variables @{URN=134311;GROUP_ID=$group;INCLUDE_ARCHIVED=0} `
                -CsvPath (Join-Path $workspace "preflight-$group.csv") -RowCount ExactlyOne -Description 'T11R preflight'
        }
        $before=Invoke-Psql -Target $target -Output Scalar -FailureMessage 'Existing URN check failed' `
            -Command "SELECT coalesce(string_agg(urn::text, ',' ORDER BY urn),'') FROM establishment.establishment WHERE urn<>134311;"
        Import-EstablishmentFromBau -Source $source -Target $target -Urn 134311 -WorkingDirectory $workspace
        foreach ($group in @(4075,4076)) {
            Import-EstablishmentPartyRoleFromBau -Source $source -Target $target -Urn 134311 -SourceGroupId $group -WorkingDirectory $workspace
        }
        $validation=Get-SchemaPath 'establishment/validate-oasis-identity-assumption.sql'
        Invoke-Psql -Target $target -File $validation -FailureMessage 'T11R validation failed'
        $stateSql=@'
SELECT json_build_object(
 'party', (SELECT legal_entity_id FROM establishment.legal_entity WHERE name='OASIS COMMUNITY LEARNING'),
 'roles', (SELECT string_agg(establishment_party_role_id::text, ',' ORDER BY establishment_party_role_id) FROM establishment.establishment_party_role),
 'responsibilities', (SELECT string_agg(establishment_responsibility_id::text, ',' ORDER BY establishment_responsibility_id) FROM establishment.establishment_responsibility),
 'identifiers', (SELECT count(*) FROM establishment.organisation_identifier)+(SELECT count(*) FROM establishment.group_identifier),
 'classifications', (SELECT count(*) FROM establishment.academy_trust_classification))::text;
'@
        $first=Invoke-Psql -Target $target -Command $stateSql -Output Scalar -FailureMessage 'T11R state check failed'
        Import-EstablishmentFromBau -Source $source -Target $target -Urn 134311 -WorkingDirectory $workspace
        foreach ($group in @(4076,4075)) {
            Import-EstablishmentPartyRoleFromBau -Source $source -Target $target -Urn 134311 -SourceGroupId $group -WorkingDirectory $workspace
        }
        Invoke-Psql -Target $target -File $validation -FailureMessage 'T11R reimport validation failed'
        $second=Invoke-Psql -Target $target -Command $stateSql -Output Scalar -FailureMessage 'T11R repeated state check failed'
        if ($first -cne $second) { throw 'T11R reimport changed business identities or counts.' }
        $after=Invoke-Psql -Target $target -Output Scalar -FailureMessage 'Preserved URN check failed' `
            -Command "SELECT coalesce(string_agg(urn::text, ',' ORDER BY urn),'') FROM establishment.establishment WHERE urn<>134311;"
        if ($before -cne $after) { throw 'T11R import changed unrelated establishment scope.' }
        Write-Host 'T11R migrated and validated; reverse-order reimport retained business identities and counts.'
    } $source $target $workspace
}
finally {
    # Resolve and check the temporary target before the shared cleanup helper.
    $resolvedWorkspace=[System.IO.Path]::GetFullPath($workspace)
    $tempRoot=[System.IO.Path]::GetFullPath([System.IO.Path]::GetTempPath())
    if (-not $resolvedWorkspace.StartsWith($tempRoot,[StringComparison]::OrdinalIgnoreCase) -or
        (Split-Path -Leaf $resolvedWorkspace) -notlike 'epr-local-run-*') {
        throw 'Refusing cleanup outside the migration temporary directory.'
    }
    Remove-RunWorkspace -Path $resolvedWorkspace
}
