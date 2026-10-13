<#
.SYNOPSIS
Adds T8, Teign School and its two separate MAT operators.
.DESCRIPTION
Uses reader and EPR_BAU_SQL_PASSWORD. Extracts all source projections before
target writes, validates an atomic rollback probe, then commits the school and
two source trust records together. Tests stable reimport without changing
the default fixture selection or checked-in SQL seeds. Does not rebuild schemas.
#>
[CmdletBinding()]
param([string]$SqlServer='SL646104', $BauSource, $PostgresTarget)
$ErrorActionPreference='Stop'
Import-Module (Join-Path $PSScriptRoot 'EprLocalAutomation/EprLocalAutomation.psm1')
if (-not $env:EPR_BAU_SQL_PASSWORD) {
    $env:EPR_BAU_SQL_PASSWORD=[Environment]::GetEnvironmentVariable('EPR_BAU_SQL_PASSWORD','User')
}
if (-not $BauSource -and -not $env:EPR_BAU_SQL_PASSWORD) { throw 'EPR_BAU_SQL_PASSWORD is required.' }
$source=if($BauSource){$BauSource}else{New-BauSource -SqlServer $SqlServer -SqlUser reader}
$target=if($PostgresTarget){$PostgresTarget}else{New-PostgresTarget -PostgresHost localhost}
$workspace=New-RunWorkspace
try {
    & (Get-Module EprLocalAutomation) {
        param($source,$target,$workspace)
        $establishmentCsv=Join-Path $workspace 't8-establishment.csv'
        $partyLoads=@()
        foreach ($uid in @(4920,3643)) {
            $partyCsv=Join-Path $workspace "t8-party-$uid.csv"
            $null=Export-BauQueryToCsv -Source $source -SqlFile (Get-SchemaPath 'establishment/transforms/academy-trust-responsibility-from-bau.sql') `
                -Variables @{URN=136494;GROUP_ID=$uid;INCLUDE_ARCHIVED=1} -CsvPath $partyCsv `
                -RowCount ExactlyOne -Description "T8 trust $uid source preflight"
            $sql=(Get-Content -LiteralPath (Get-SchemaPath 'establishment/load/load-academy-trust-responsibility-fixture.sql') -Raw -Encoding UTF8).Replace('__FIXTURE_PATH__',($partyCsv -replace '\\','/'))
            $partyLoads += [regex]::Replace($sql,'(?m)^(BEGIN|COMMIT);\r?$','') + "`nDROP TABLE migration_context, establishment_party_role_fixture;`n"
        }
        $null=Export-BauQueryToCsv -Source $source -SqlFile (Get-SchemaPath 'establishment/transforms/establishment-from-bau.sql') `
            -Variables @{URN=136494} -Columns $script:EstablishmentFixtureColumns -CsvPath $establishmentCsv `
            -RowCount ExactlyOne -Description 'T8 establishment source preflight'
        $sql=(Get-Content -LiteralPath (Get-SchemaPath 'establishment/load/load-establishment-fixture.sql') -Raw -Encoding UTF8).Replace('__FIXTURE_PATH__',($establishmentCsv -replace '\\','/'))
        $schoolLoad=[regex]::Replace($sql,'(?m)^(BEGIN|COMMIT);\r?$','') + "`n"
        $loadSql=$schoolLoad+($partyLoads -join "`n")
        $validation=Get-SchemaPath 'migration/validate-scripts/validate-t8-operator-transfer.sql'
        $validationSql=Get-Content -LiteralPath $validation -Raw
        $preservedSql="SELECT coalesce(string_agg(urn::text || ':' || establishment_id::text,',' ORDER BY urn),'') FROM establishment.establishment WHERE urn<>136494;"
        $before=Invoke-Psql -Target $target -Command $preservedSql -Output Scalar -FailureMessage 'Existing scope check failed'
        $path=Join-Path $workspace 't8-load.sql'
        foreach ($ending in @('ROLLBACK','COMMIT')) {
            $batch="BEGIN;`n"+$loadSql+$validationSql+"`n$ending;"
            [System.IO.File]::WriteAllText($path,$batch,[System.Text.UTF8Encoding]::new($false))
            Invoke-Psql -Target $target -File $path -FailureMessage "T8 atomic $ending load failed"
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
        $first=Invoke-Psql -Target $target -Command $stateSql -Output Scalar -FailureMessage 'T8 state check failed'
        # Reverse the import order to prove identity and chronology are not order-dependent.
        [array]::Reverse($partyLoads)
        $batch="BEGIN;`n"+$schoolLoad+($partyLoads -join "`n")+$validationSql+"`nCOMMIT;"
        [System.IO.File]::WriteAllText($path,$batch,[System.Text.UTF8Encoding]::new($false))
        Invoke-Psql -Target $target -File $path -FailureMessage 'T8 repeat import failed'
        $second=Invoke-Psql -Target $target -Command $stateSql -Output Scalar -FailureMessage 'T8 repeated state check failed'
        if ($first -cne $second) { throw 'T8 reimport changed business identities or counts.' }
        $after=Invoke-Psql -Target $target -Command $preservedSql -Output Scalar -FailureMessage 'Preserved scope check failed'
        if ($before -cne $after) { throw 'T8 changed unrelated establishment scope or identities.' }
        Write-Host 'T8 migrated and validated; separate MAT operators, two responsibilities and both trusts source-current and reverse-order reimport stable.'
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
