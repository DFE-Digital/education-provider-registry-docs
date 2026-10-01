<#!
.SYNOPSIS
Extracts one establishment-party role and responsibility from the local BAU
SQL Server copy and loads them into PostgreSQL establishment_local.

.DESCRIPTION
This runner implements the first establishment-groups physical slice. It
writes a temporary target-shaped fixture and persists resolved GIAS group
identifiers on the target role; unresolved migration-lineage records remain
outside the target schema.
#>
[CmdletBinding()]
param(
    [string]$SqlServer = 'localhost',
    [string]$SourceDatabase = 'gias_bau_test_local',
    [string]$SqlUser = 'reader',
    [string]$SqlPassword = $env:EPR_BAU_SQL_PASSWORD,
    [switch]$UseWindowsAuthentication,
    [switch]$IncludeArchived,
    [string]$PostgresHost = '127.0.0.1',
    [int]$PostgresPort = 5432,
    [string]$PostgresDatabase = 'establishment_local',
    [string]$PostgresUser = 'postgres',
    [ValidateRange(100000, 999999)][int]$Urn,
    [ValidateRange(1, 999999999)][int]$SourceGroupId,
    [string]$FixturePath = (Join-Path $env:TEMP 'epr-academy-trust-responsibility-fixture.csv')
)

$ErrorActionPreference = 'Stop'
$automationRoot = $PSScriptRoot
$schemaRoot = Split-Path -Parent $automationRoot
. (Join-Path $automationRoot 'common\local-database-guards.ps1')
. (Join-Path $automationRoot 'common\sql-client-functions.ps1')
Assert-LocalBauSource -SqlServer $SqlServer -SourceDatabase $SourceDatabase
Assert-LocalPostgresTarget -PostgresHost $PostgresHost -PostgresDatabase $PostgresDatabase
if (-not $UseWindowsAuthentication -and -not $SqlPassword) { throw 'Supply -SqlPassword, set EPR_BAU_SQL_PASSWORD, or use -UseWindowsAuthentication.' }

$transformSql = Join-Path $schemaRoot 'establishment\transforms\academy-trust-responsibility-from-bau.sql'
$loadSql = Join-Path $schemaRoot 'establishment\load\load-academy-trust-responsibility-fixture.sql'
$migrationSchemaSql = Join-Path $schemaRoot 'migration\migration-schema.sql'
$psql = Get-LocalPostgresClientPath
foreach ($path in @($transformSql, $loadSql, $migrationSchemaSql)) {
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { throw "Required migration file not found: $path" }
}

$fixtureDirectory = Split-Path -Parent $FixturePath
New-Item -ItemType Directory -Path $fixtureDirectory -Force | Out-Null
$header = 'legal_entity_name|companies_house_number|ukprn|legal_entity_incorporation_date|group_uid|group_id|establishment_party_role_type|academy_trust_type|responsibility_type|role_start_date|role_end_date|role_end_date_basis|classification_start_date|classification_end_date|establishment_urn|responsibility_start_date|responsibility_end_date|end_date_basis'
[System.IO.File]::WriteAllText($FixturePath, $header + [Environment]::NewLine, [System.Text.UTF8Encoding]::new($false))

$reader = $null; $command = $null; $connection = $null
try {
    $sourceSql = (Get-Content -LiteralPath $transformSql -Raw).Replace('$(URN)', [string]$Urn).Replace('$(GROUP_ID)', [string]$SourceGroupId).Replace('$(INCLUDE_ARCHIVED)', $(if ($IncludeArchived) { '1' } else { '0' }))
    $connection = New-LocalBauSqlConnection -SqlServer $SqlServer -SourceDatabase $SourceDatabase -SqlUser $SqlUser -SqlPassword $SqlPassword -UseWindowsAuthentication:$UseWindowsAuthentication
    $connection.Open()
    $command = $connection.CreateCommand()
    $command.CommandText = $sourceSql
    $reader = $command.ExecuteReader()
    if (-not $reader.Read()) { throw "No active establishment-party link was returned for URN $Urn and source group $SourceGroupId." }
    $values = for ($i = 0; $i -lt $reader.FieldCount; $i++) {
        if ($reader.IsDBNull($i)) { 'NULL' } else { $reader.GetValue($i).ToString().Replace('|', ' ') }
    }
    if ($reader.Read()) { throw "Expected one establishment-party link for URN $Urn and source group $SourceGroupId, but more than one was returned." }
    [System.IO.File]::AppendAllText($FixturePath, ($values -join '|') + [Environment]::NewLine, [System.Text.UTF8Encoding]::new($false))
}
catch {
    throw "Establishment-party source transform failed for URN ${Urn}, source group ${SourceGroupId}: $($_.Exception.Message)"
}
finally {
    if ($reader) { $reader.Dispose() }
    if ($command) { $command.Dispose() }
    if ($connection) { $connection.Dispose() }
}

$loadSqlTemp = Join-Path $env:TEMP 'epr-load-academy-trust-responsibility-fixture.sql'
try {
    $loadSqlText = (Get-Content -LiteralPath $loadSql -Raw).Replace('__FIXTURE_PATH__', ($FixturePath -replace '\\', '/'))
    [System.IO.File]::WriteAllText($loadSqlTemp, $loadSqlText, [System.Text.UTF8Encoding]::new($false))
    & $psql -h $PostgresHost -p $PostgresPort -U $PostgresUser -d $PostgresDatabase -w -v ON_ERROR_STOP=1 -f $loadSqlTemp
    if ($LASTEXITCODE -ne 0) { throw "PostgreSQL establishment-party-role load failed with exit code $LASTEXITCODE" }
}
finally {
    Remove-Item -LiteralPath $loadSqlTemp -Force -ErrorAction SilentlyContinue
}

Write-Host "Establishment-party role and responsibility migration completed for URN $Urn and source group $SourceGroupId. Fixture: $FixturePath"
