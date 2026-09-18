<#
.SYNOPSIS
Rebuilds establishment_local and migrates the selected Establishment slice from
the approved local BAU SQL Server copy.

.DESCRIPTION
This is the BAU-source Establishment workflow. It is deliberately a separate
entry point from rebuild-establishment-from-checked-in-sql.ps1 so the
developer's source-data choice is visible in the command name.
##>
[CmdletBinding()]
param(
    [string]$SqlServer = 'localhost',
    [string]$SourceDatabase = 'gias_bau_test_local',
    [string]$SqlUser = 'reader',
    [string]$PostgresHost = '127.0.0.1',
    [int]$PostgresPort = 5432,
    [string]$PostgresDatabase = 'establishment_local',
    [string]$PostgresUser = 'postgres',
    [string]$PostgresPassword = $env:PGPASSWORD,
    [string]$FixtureDirectory = $env:TEMP,
    [string]$ExportDirectory,
    [switch]$KeepFixture
)

$ErrorActionPreference = 'Stop'
$automationRoot = $PSScriptRoot
$schemaRoot = Split-Path -Parent $automationRoot
. (Join-Path $automationRoot 'common\local-database-guards.ps1')
. (Join-Path $automationRoot 'common\sql-client-functions.ps1')

Assert-LocalBauSource -SqlServer $SqlServer -SourceDatabase $SourceDatabase
Assert-LocalPostgresTarget -PostgresHost $PostgresHost -PostgresDatabase $PostgresDatabase

$selectionPath = Join-Path $schemaRoot 'seed\one-organisation.json'
$schemaSql = Join-Path $schemaRoot 'establishment\core-establishment-schema.sql'
$validationSql = Join-Path $schemaRoot 'establishment\validate-establishment-fixture.sql'
$referenceDataSql = Join-Path $schemaRoot 'seed\seed-reference-data.sql'
$establishmentRunner = Join-Path $automationRoot 'invoke-establishment-migration.ps1'
$geographicReferenceRunner = Join-Path $automationRoot 'seed-geographic-reference-data-from-bau.ps1'
$exporter = Join-Path $automationRoot 'export-establishment-fixture-from-local-target.ps1'
$approvalTest = Join-Path $schemaRoot 'tests\assert-establishment-approval.ps1'
$rowCountTest = Join-Path $schemaRoot 'tests\assert-establishment-row-counts.ps1'
$approvalUrns = @(100018, 106431, 136102)
$psql = Get-LocalPostgresClientPath

foreach ($path in @($selectionPath, $schemaSql, $validationSql, $referenceDataSql, $establishmentRunner, $geographicReferenceRunner, $exporter, $approvalTest, $rowCountTest)) {
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { throw "Required migration file not found: $path" }
}

$selection = Get-Content -LiteralPath $selectionPath -Raw | ConvertFrom-Json
if ($selection.organisationType -ne 'establishment-fixture-set') { throw "The selection must have organisationType 'establishment-fixture-set'." }
$urns = @($selection.urns | ForEach-Object { try { [int]$_ } catch { throw 'Every selected organisation URN must be an integer.' } })
if ($urns.Count -eq 0) { throw 'The selection must contain at least one URN.' }
if (($urns | Select-Object -Unique).Count -ne $urns.Count) { throw 'The selection must not contain duplicate URNs.' }
foreach ($urn in $urns) { if ($urn -lt 100000 -or $urn -gt 999999) { throw "The selected URN is outside the valid range: $urn" } }

New-Item -ItemType Directory -Path $FixtureDirectory -Force | Out-Null
$securePassword = Read-Host 'Local SQL Server reader password' -AsSecureString
$envPasswordBefore = $env:PGPASSWORD
if ($PostgresPassword) { $env:PGPASSWORD = $PostgresPassword }
$env:EPR_BAU_SQL_PASSWORD = [System.Net.NetworkCredential]::new('', $securePassword).Password
try {
    & $psql -h $PostgresHost -p $PostgresPort -U $PostgresUser -d $PostgresDatabase -w -v ON_ERROR_STOP=1 -f $schemaSql
    if ($LASTEXITCODE -ne 0) { throw 'Establishment schema rebuild failed.' }
    & $psql -h $PostgresHost -p $PostgresPort -U $PostgresUser -d $PostgresDatabase -w -v ON_ERROR_STOP=1 -f $referenceDataSql
    if ($LASTEXITCODE -ne 0) { throw 'Establishment reference-data seed failed.' }

    & $geographicReferenceRunner -SqlServer $SqlServer -SourceDatabase $SourceDatabase -SqlUser $SqlUser -FixtureDirectory $FixtureDirectory
    if ($LASTEXITCODE -ne 0) { throw 'Geographic reference-data seed failed.' }

    foreach ($urn in $urns) {
        & $establishmentRunner -SqlServer $SqlServer -SourceDatabase $SourceDatabase -SqlUser $SqlUser -PostgresHost $PostgresHost -PostgresPort $PostgresPort -PostgresDatabase $PostgresDatabase -PostgresUser $PostgresUser -Urn $urn -FixturePath (Join-Path $FixtureDirectory "epr-registry-establishment-$urn-fixture.csv")
        if ($LASTEXITCODE -ne 0) { throw "Establishment migration failed for URN $urn." }
    }

    $urnList = $urns -join ', '
    & $psql -h $PostgresHost -p $PostgresPort -U $PostgresUser -d $PostgresDatabase -w -v ON_ERROR_STOP=1 -c "SELECT e.urn, e.name, m.pupil_count, m.free_school_meal_measure FROM establishment.establishment AS e LEFT JOIN establishment.capacity_and_pupil_measures AS m ON m.establishment_id = e.establishment_id WHERE e.urn IN ($urnList) ORDER BY e.urn;"
    if ($LASTEXITCODE -ne 0) { throw 'Establishment validation query failed.' }
    & $psql -h $PostgresHost -p $PostgresPort -U $PostgresUser -d $PostgresDatabase -w -v ON_ERROR_STOP=1 -f $validationSql
    if ($LASTEXITCODE -ne 0) { throw 'Establishment fixture validation failed.' }
    foreach ($approvalUrn in $approvalUrns) {
        if ($urns -contains $approvalUrn) {
            & $approvalTest -Urn $approvalUrn -PostgresHost $PostgresHost -PostgresPort $PostgresPort -PostgresDatabase $PostgresDatabase -PostgresUser $PostgresUser -PostgresPassword $PostgresPassword
            if ($LASTEXITCODE -ne 0) { throw "Establishment approval test failed for URN $approvalUrn." }
        }
    }
    & $rowCountTest -PostgresHost $PostgresHost -PostgresPort $PostgresPort -PostgresDatabase $PostgresDatabase -PostgresUser $PostgresUser -PostgresPassword $PostgresPassword
    if ($LASTEXITCODE -ne 0) { throw 'Establishment row-count approval test failed.' }
    if ($ExportDirectory) {
        & $exporter -PostgresHost $PostgresHost -PostgresPort $PostgresPort -PostgresDatabase $PostgresDatabase -PostgresUser $PostgresUser -OutputDirectory $ExportDirectory
        if ($LASTEXITCODE -ne 0) { throw 'Checked-in fixture export failed.' }
    }
    Write-Host "BAU-source Establishment rebuild completed for URNs: $urnList."
    if ($KeepFixture) { Write-Host "Fixtures retained in: $FixtureDirectory" }
}
finally {
    Remove-Item Env:EPR_BAU_SQL_PASSWORD -ErrorAction SilentlyContinue
    Remove-Variable securePassword -ErrorAction SilentlyContinue
    $env:PGPASSWORD = $envPasswordBefore
    if (-not $KeepFixture) {
        Remove-Item -LiteralPath (Join-Path $FixtureDirectory 'epr-local-authority-fixture.csv') -Force -ErrorAction SilentlyContinue
        Remove-Item -LiteralPath (Join-Path $FixtureDirectory 'epr-government-office-region-fixture.csv') -Force -ErrorAction SilentlyContinue
        Remove-Item -LiteralPath (Join-Path $FixtureDirectory 'epr-district-administrative-fixture.csv') -Force -ErrorAction SilentlyContinue
        Remove-Item -LiteralPath (Join-Path $FixtureDirectory 'epr-gss-local-authority-code-fixture.csv') -Force -ErrorAction SilentlyContinue
        Remove-Item -LiteralPath (Join-Path $FixtureDirectory 'epr-local-authority-gss-mapping-fixture.csv') -Force -ErrorAction SilentlyContinue
        Remove-Item -LiteralPath (Join-Path $FixtureDirectory 'epr-local-authority-gor-mapping-fixture.csv') -Force -ErrorAction SilentlyContinue
        foreach ($urn in $urns) { Remove-Item -LiteralPath (Join-Path $FixtureDirectory "epr-registry-establishment-$urn-fixture.csv") -Force -ErrorAction SilentlyContinue }
    }
}
