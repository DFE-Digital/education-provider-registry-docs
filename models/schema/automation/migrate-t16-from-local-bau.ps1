<#
.SYNOPSIS
Adds T16, Manchester Creative and Media Academy and its closed MAT, to the existing local database.
.DESCRIPTION
Uses reader and EPR_BAU_SQL_PASSWORD. Extracts both source projections before
target writes, validates an atomic rollback probe, then commits the academy and
historical trust relationship together. Tests stable reimport without changing
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
        $establishmentCsv=Join-Path $workspace 't16-establishment.csv'
        $partyCsv=Join-Path $workspace 't16-party.csv'
        $null=Export-BauQueryToCsv -Source $source -SqlFile (Get-SchemaPath 'establishment/transforms/academy-trust-responsibility-from-bau.sql') `
            -Variables @{URN=135905;GROUP_ID=3839;INCLUDE_ARCHIVED=0} -CsvPath $partyCsv `
            -RowCount ExactlyOne -Description 'T16 closed-MAT source preflight'
        $null=Export-BauQueryToCsv -Source $source -SqlFile (Get-SchemaPath 'establishment/transforms/establishment-from-bau.sql') `
            -Variables @{URN=135905} -Columns $script:EstablishmentFixtureColumns -CsvPath $establishmentCsv `
            -RowCount ExactlyOne -Description 'T16 establishment source preflight'
        $loadSql=''
        foreach ($load in @(
            @{Path='establishment/load/load-establishment-fixture.sql';Csv=$establishmentCsv},
            @{Path='establishment/load/load-academy-trust-responsibility-fixture.sql';Csv=$partyCsv}
        )) {
            $sql=(Get-Content -LiteralPath (Get-SchemaPath $load.Path) -Raw).Replace('__FIXTURE_PATH__',($load.Csv -replace '\\','/'))
            $loadSql += [regex]::Replace($sql,'(?m)^(BEGIN|COMMIT);\r?$','') + "`n"
        }
        $validation=Get-SchemaPath 'establishment/validate-t16-closed-mat.sql'
        $validationSql=Get-Content -LiteralPath $validation -Raw
        $preservedSql="SELECT coalesce(string_agg(urn::text || ':' || establishment_id::text,',' ORDER BY urn),'') FROM establishment.establishment WHERE urn<>135905;"
        $before=Invoke-Psql -Target $target -Command $preservedSql -Output Scalar -FailureMessage 'Existing scope check failed'
        $path=Join-Path $workspace 't16-load.sql'
        foreach ($ending in @('ROLLBACK','COMMIT')) {
            $batch="BEGIN;`n"+$loadSql+$validationSql+"`n$ending;"
            [System.IO.File]::WriteAllText($path,$batch,[System.Text.UTF8Encoding]::new($false))
            Invoke-Psql -Target $target -File $path -FailureMessage "T16 atomic $ending load failed"
        }
        $stateSql=@'
SELECT json_build_object(
 'establishments',(SELECT string_agg(establishment_id::text,',' ORDER BY establishment_id) FROM establishment.establishment),
 'parties',(SELECT string_agg(legal_entity_id::text,',' ORDER BY legal_entity_id) FROM establishment.legal_entity),
 'roles',(SELECT string_agg(establishment_party_role_id::text,',' ORDER BY establishment_party_role_id) FROM establishment.establishment_party_role),
 'responsibilities',(SELECT string_agg(establishment_responsibility_id::text,',' ORDER BY establishment_responsibility_id) FROM establishment.establishment_responsibility),
 'classifications',(SELECT string_agg(academy_trust_classification_id::text,',' ORDER BY academy_trust_classification_id) FROM establishment.academy_trust_classification),
 'organisation_identifiers',(SELECT string_agg(organisation_identifier_id::text,',' ORDER BY organisation_identifier_id) FROM establishment.organisation_identifier),
 'group_identifiers',(SELECT string_agg(group_identifier_id::text,',' ORDER BY group_identifier_id) FROM establishment.group_identifier))::text;
'@
        $first=Invoke-Psql -Target $target -Command $stateSql -Output Scalar -FailureMessage 'T16 state check failed'
        # Reuse the preflighted source assertions through the real loaders.
        Invoke-Psql -Target $target -File $path -FailureMessage 'T16 repeat import failed'
        $second=Invoke-Psql -Target $target -Command $stateSql -Output Scalar -FailureMessage 'T16 repeated state check failed'
        if ($first -cne $second) { throw 'T16 reimport changed business identities or counts.' }
        $after=Invoke-Psql -Target $target -Command $preservedSql -Output Scalar -FailureMessage 'Preserved scope check failed'
        if ($before -cne $after) { throw 'T16 changed unrelated establishment scope or identities.' }
        Write-Host 'T16 migrated and validated; closed MAT retained, stale link not current, inferred end recorded and reimport stable.'
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
