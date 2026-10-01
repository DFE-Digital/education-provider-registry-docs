<#!
.SYNOPSIS
Runs all Establishment and establishment-groups tests against the current
local PostgreSQL target without rebuilding or migrating data.
#>
[CmdletBinding()]
param(
    [string]$PostgresHost = '127.0.0.1',
    [int]$PostgresPort = 5432,
    [string]$PostgresDatabase = 'establishment_local',
    [string]$PostgresUser = 'postgres',
    [string]$PostgresPassword = $env:PGPASSWORD
)

$ErrorActionPreference = 'Stop'
$automationRoot = $PSScriptRoot
$schemaRoot = Split-Path -Parent $automationRoot
. (Join-Path $automationRoot 'common\local-database-guards.ps1')
. (Join-Path $automationRoot 'common\sql-client-functions.ps1')
Assert-LocalPostgresTarget -PostgresHost $PostgresHost -PostgresDatabase $PostgresDatabase

$rowCountTest = Join-Path $schemaRoot 'tests\assert-establishment-row-counts.ps1'
$approvalTest = Join-Path $schemaRoot 'tests\assert-establishment-approval.ps1'
$coreValidationSql = Join-Path $schemaRoot 'establishment\validate-establishment-fixture.sql'
$groupsValidationSql = Join-Path $schemaRoot 'establishment\validate-academy-trust-responsibilities.sql'
$psql = Get-LocalPostgresClientPath

foreach ($path in @($rowCountTest, $approvalTest, $coreValidationSql, $groupsValidationSql)) {
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { throw "Required test file not found: $path" }
}

$oldPassword = $env:PGPASSWORD
if ($PostgresPassword) { $env:PGPASSWORD = $PostgresPassword }
try {
    & $rowCountTest -PostgresHost $PostgresHost -PostgresPort $PostgresPort -PostgresDatabase $PostgresDatabase -PostgresUser $PostgresUser -PostgresPassword $PostgresPassword
    if ($LASTEXITCODE -ne 0) { throw 'Establishment row-count approval test failed.' }

    foreach ($urn in @(136102)) {
        & $approvalTest -Urn $urn -PostgresHost $PostgresHost -PostgresPort $PostgresPort -PostgresDatabase $PostgresDatabase -PostgresUser $PostgresUser -PostgresPassword $PostgresPassword
        if ($LASTEXITCODE -ne 0) { throw "Establishment approval test failed for URN $urn." }
    }

    & $psql -X -h $PostgresHost -p $PostgresPort -U $PostgresUser -d $PostgresDatabase -w -v ON_ERROR_STOP=1 -f $coreValidationSql
    if ($LASTEXITCODE -ne 0) { throw 'Core establishment fixture validation failed.' }

    & $psql -X -h $PostgresHost -p $PostgresPort -U $PostgresUser -d $PostgresDatabase -w -v ON_ERROR_STOP=1 -f $groupsValidationSql
    if ($LASTEXITCODE -ne 0) { throw 'Academy-trust responsibility validation failed.' }

    Write-Host 'All current Establishment and establishment-groups tests passed.'
}
finally {
    $env:PGPASSWORD = $oldPassword
}
