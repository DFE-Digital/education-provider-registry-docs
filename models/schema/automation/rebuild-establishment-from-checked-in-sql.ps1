<#
.SYNOPSIS
Rebuilds the local Establishment PostgreSQL schema and runs the checked-in SQL
seed files. This path does not require access to BAU SQL Server.
#>
[CmdletBinding()]
param(
    [string]$PostgresHost = '127.0.0.1',
    [int]$PostgresPort = 5432,
    [string]$PostgresDatabase = 'establishment_local',
    [string]$PostgresUser = 'postgres',
    [string]$PostgresPassword = $env:PGPASSWORD,
    [string[]]$SeedFile = @('seed-establishment-fixture.sql')
)

$ErrorActionPreference = 'Stop'
$automationRoot = $PSScriptRoot
$schemaRoot = Split-Path -Parent $automationRoot
$seedRoot = Join-Path $schemaRoot 'seed'
. (Join-Path $automationRoot 'common\local-database-guards.ps1')
. (Join-Path $automationRoot 'common\sql-client-functions.ps1')
Assert-LocalPostgresTarget -PostgresHost $PostgresHost -PostgresDatabase $PostgresDatabase

$schemaSql = Join-Path $schemaRoot 'establishment\core-establishment-schema.sql'
$migrationSchemaSql = Join-Path $schemaRoot 'migration\migration-schema.sql'
$validationSql = Join-Path $schemaRoot 'establishment\validate-establishment-fixture.sql'
$groupsValidationSql = Join-Path $schemaRoot 'establishment\validate-academy-trust-responsibilities.sql'
$referenceDataSql = Join-Path $seedRoot 'seed-reference-data.sql'
$academyTrustReferenceDataSql = Join-Path $seedRoot 'seed-academy-trust-reference-data.sql'
$migrationEvidenceSql = Join-Path $seedRoot 'seed-migration-evidence.sql'
$approvalTest = Join-Path $schemaRoot 'tests\assert-establishment-approval.ps1'
$rowCountTest = Join-Path $schemaRoot 'tests\assert-establishment-row-counts.ps1'
$approvalUrns = @(100018, 106431, 136102)
$seedPaths = @($SeedFile | ForEach-Object {
    if ([System.IO.Path]::IsPathRooted($_)) { $_ } else { Join-Path $seedRoot $_ }
})
foreach ($path in @($schemaSql, $migrationSchemaSql, $validationSql, $groupsValidationSql, $referenceDataSql, $academyTrustReferenceDataSql, $migrationEvidenceSql, $approvalTest, $rowCountTest) + $seedPaths) {
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { throw "Required file not found: $path" }
}

$psql = Get-LocalPostgresClientPath
$envPasswordBefore = $env:PGPASSWORD
if ($PostgresPassword) { $env:PGPASSWORD = $PostgresPassword }
try {
    & $psql -h $PostgresHost -p $PostgresPort -U $PostgresUser -d $PostgresDatabase -w -v ON_ERROR_STOP=1 -f $schemaSql
    if ($LASTEXITCODE -ne 0) { throw "PostgreSQL schema rebuild failed with exit code $LASTEXITCODE" }

    & $psql -h $PostgresHost -p $PostgresPort -U $PostgresUser -d $PostgresDatabase -w -v ON_ERROR_STOP=1 -f $migrationSchemaSql
    if ($LASTEXITCODE -ne 0) { throw "Migration schema rebuild failed with exit code $LASTEXITCODE" }

    & $psql -h $PostgresHost -p $PostgresPort -U $PostgresUser -d $PostgresDatabase -w -v ON_ERROR_STOP=1 -f $referenceDataSql
    if ($LASTEXITCODE -ne 0) { throw "Reference-data seed failed with exit code $LASTEXITCODE" }
    & $psql -h $PostgresHost -p $PostgresPort -U $PostgresUser -d $PostgresDatabase -w -v ON_ERROR_STOP=1 -f $academyTrustReferenceDataSql
    if ($LASTEXITCODE -ne 0) { throw "Academy-trust reference-data seed failed with exit code $LASTEXITCODE" }

    foreach ($path in $seedPaths) {
        Write-Host "Running seed: $([System.IO.Path]::GetFileName($path))"
        & $psql -h $PostgresHost -p $PostgresPort -U $PostgresUser -d $PostgresDatabase -w -v ON_ERROR_STOP=1 -f $path
        if ($LASTEXITCODE -ne 0) { throw "Seed failed with exit code ${LASTEXITCODE}: $path" }
    }
    & $psql -h $PostgresHost -p $PostgresPort -U $PostgresUser -d $PostgresDatabase -w -v ON_ERROR_STOP=1 -f $migrationEvidenceSql
    if ($LASTEXITCODE -ne 0) { throw "Migration evidence seed failed with exit code $LASTEXITCODE" }
    & $psql -h $PostgresHost -p $PostgresPort -U $PostgresUser -d $PostgresDatabase -w -v ON_ERROR_STOP=1 -f $validationSql
    if ($LASTEXITCODE -ne 0) { throw 'Checked-in Establishment fixture validation failed.' }
    & $psql -h $PostgresHost -p $PostgresPort -U $PostgresUser -d $PostgresDatabase -w -v ON_ERROR_STOP=1 -f $groupsValidationSql
    if ($LASTEXITCODE -ne 0) { throw 'Checked-in establishment-groups fixture validation failed.' }
    foreach ($approvalUrn in $approvalUrns) {
        & $approvalTest -Urn $approvalUrn -PostgresHost $PostgresHost -PostgresPort $PostgresPort -PostgresDatabase $PostgresDatabase -PostgresUser $PostgresUser -PostgresPassword $PostgresPassword
        if ($LASTEXITCODE -ne 0) { throw "Establishment approval test failed for URN $approvalUrn." }
    }
    & $rowCountTest -PostgresHost $PostgresHost -PostgresPort $PostgresPort -PostgresDatabase $PostgresDatabase -PostgresUser $PostgresUser -PostgresPassword $PostgresPassword
    if ($LASTEXITCODE -ne 0) { throw 'Establishment row-count approval test failed.' }
    Write-Host "Establishment schema rebuilt and SQL seed files loaded."
}
finally {
    $env:PGPASSWORD = $envPasswordBefore
}
