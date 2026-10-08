<#
.SYNOPSIS
Adds T17, Langley School, historical federation membership and foundation support, to the existing local database.
.DESCRIPTION
Uses reader and EPR_BAU_SQL_PASSWORD. Extracts all three source projections before
target writes, validates an atomic rollback probe, then commits the school,
historical federation membership and foundation support together. Tests stable reimport without changing
the default fixture selection or checked-in SQL seeds. Does not rebuild schemas.
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
        $establishmentCsv=Join-Path $workspace 't17-establishment.csv'
        $partyCsv=Join-Path $workspace 't17-party.csv'
        $federationCsv=Join-Path $workspace 't17-federation.csv'
        $null=Export-BauQueryToCsv -Source $source -SqlFile (Get-SchemaPath 'establishment/transforms/t17-historical-federation-from-bau.sql') `
            -CsvPath $federationCsv -RowCount ExactlyOne -Description 'T17 historical federation preflight'
        $null=Export-BauQueryToCsv -Source $source -SqlFile (Get-SchemaPath 'establishment/transforms/academy-trust-responsibility-from-bau.sql') `
            -Variables @{URN=103630;GROUP_ID=1650;INCLUDE_ARCHIVED=0} -CsvPath $partyCsv `
            -RowCount ExactlyOne -Description 'T17 foundation-support source preflight'
        $null=Export-BauQueryToCsv -Source $source -SqlFile (Get-SchemaPath 'establishment/transforms/establishment-from-bau.sql') `
            -Variables @{URN=103630} -Columns $script:EstablishmentFixtureColumns -CsvPath $establishmentCsv `
            -RowCount ExactlyOne -Description 'T17 establishment source preflight'
        $loadSql=''
        foreach ($load in @(
            @{Path='establishment/load/load-establishment-fixture.sql';Csv=$establishmentCsv},
            @{Path='establishment/load/load-academy-trust-responsibility-fixture.sql';Csv=$partyCsv},
            @{Path='establishment/load/load-t17-historical-federation.sql';Csv=$federationCsv}
        )) {
            $sql=(Get-Content -LiteralPath (Get-SchemaPath $load.Path) -Raw).Replace('__FIXTURE_PATH__',($load.Csv -replace '\\','/'))
            $loadSql += [regex]::Replace($sql,'(?m)^(BEGIN|COMMIT);\r?$','') + "`n"
        }
        $validation=Get-SchemaPath 'establishment/validate-t17-dual-relationships.sql'
        $validationSql=Get-Content -LiteralPath $validation -Raw
        $preservedSql="SELECT coalesce(string_agg(urn::text || ':' || establishment_id::text,',' ORDER BY urn),'') FROM establishment.establishment WHERE urn<>103630;"
        $before=Invoke-Psql -Target $target -Command $preservedSql -Output Scalar -FailureMessage 'Existing scope check failed'
        $path=Join-Path $workspace 't17-load.sql'
        foreach ($ending in @('ROLLBACK','COMMIT')) {
            $batch="BEGIN;`n"+$loadSql+$validationSql+"`n$ending;"
            [System.IO.File]::WriteAllText($path,$batch,[System.Text.UTF8Encoding]::new($false))
            Invoke-Psql -Target $target -File $path -FailureMessage "T17 atomic $ending load failed"
        }
        $stateSql=@'
SELECT json_build_object(
 'establishments',(SELECT string_agg(establishment_id::text,',' ORDER BY establishment_id) FROM establishment.establishment),
 'parties',(SELECT string_agg(legal_entity_id::text,',' ORDER BY legal_entity_id) FROM establishment.legal_entity),
 'roles',(SELECT string_agg(establishment_party_role_id::text,',' ORDER BY establishment_party_role_id) FROM establishment.establishment_party_role),
 'responsibilities',(SELECT string_agg(establishment_responsibility_id::text,',' ORDER BY establishment_responsibility_id) FROM establishment.establishment_responsibility),
 'classifications',(SELECT string_agg(academy_trust_classification_id::text,',' ORDER BY academy_trust_classification_id) FROM establishment.academy_trust_classification),
 'organisation_identifiers',(SELECT string_agg(organisation_identifier_id::text,',' ORDER BY organisation_identifier_id) FROM establishment.organisation_identifier),
 'groups',(SELECT string_agg(organisation_group_id::text,',' ORDER BY organisation_group_id) FROM establishment.organisation_group),
 'memberships',(SELECT string_agg(organisation_group_member_id::text,',' ORDER BY organisation_group_member_id) FROM establishment.organisation_group_member),
 'group_identifiers',(SELECT string_agg(group_identifier_id::text,',' ORDER BY group_identifier_id) FROM establishment.group_identifier))::text;
'@
        $first=Invoke-Psql -Target $target -Command $stateSql -Output Scalar -FailureMessage 'T17 state check failed'
        # Reuse the preflighted source assertions through the real loaders.
        Invoke-Psql -Target $target -File $path -FailureMessage 'T17 repeat import failed'
        $second=Invoke-Psql -Target $target -Command $stateSql -Output Scalar -FailureMessage 'T17 repeated state check failed'
        if ($first -cne $second) { throw 'T17 reimport changed business identities or counts.' }
        $after=Invoke-Psql -Target $target -Command $preservedSql -Output Scalar -FailureMessage 'Preserved scope check failed'
        if ($before -cne $after) { throw 'T17 changed unrelated establishment scope or identities.' }
        Write-Host 'T17 migrated and validated; historical membership and foundation support retained, stale link not current, inferred end recorded and reimport stable.'
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
