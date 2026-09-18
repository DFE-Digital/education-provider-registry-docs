<#
.SYNOPSIS
Loads the complete Government Office Region reference set from local BAU into
PostgreSQL establishment_local.
#>
[CmdletBinding()]
param(
    [string]$SqlServer = 'localhost',
    [string]$SourceDatabase = 'gias_bau_test_local',
    [string]$SqlUser = 'reader',
    [string]$SqlPassword = $env:EPR_BAU_SQL_PASSWORD,
    [string]$PostgresHost = '127.0.0.1',
    [int]$PostgresPort = 5432,
    [string]$PostgresDatabase = 'establishment_local',
    [string]$PostgresUser = 'postgres',
    [string]$FixturePath = (Join-Path $env:TEMP 'epr-government-office-region-fixture.csv')
)

$ErrorActionPreference = 'Stop'
$automationRoot = $PSScriptRoot
$schemaRoot = Split-Path -Parent $automationRoot
. (Join-Path $automationRoot 'common\local-database-guards.ps1')
. (Join-Path $automationRoot 'common\sql-client-functions.ps1')
# This runner is deliberately separate from establishment extraction: the
# complete reference set must be present before Establishment geography rows
# are loaded, and BAU GOR codes are text integration values (not integers).
Assert-LocalBauSource -SqlServer $SqlServer -SourceDatabase $SourceDatabase
Assert-LocalPostgresTarget -PostgresHost $PostgresHost -PostgresDatabase $PostgresDatabase
if (-not $SqlPassword) { throw 'Supply -SqlPassword or set EPR_BAU_SQL_PASSWORD.' }

$transformSql = Join-Path $schemaRoot 'establishment\transforms\government-office-regions-from-bau.sql'
$loadSql = Join-Path $schemaRoot 'establishment\load\load-government-office-region-fixture.sql'
$psql = Get-LocalPostgresClientPath
foreach ($path in @($transformSql, $loadSql)) { if (-not (Test-Path -LiteralPath $path)) { throw "Required migration file not found: $path" } }

New-Item -ItemType Directory -Path (Split-Path -Parent $FixturePath) -Force | Out-Null
[System.IO.File]::WriteAllText($FixturePath, "code|name$([Environment]::NewLine)", [System.Text.UTF8Encoding]::new($false))

$reader = $null; $command = $null; $connection = $null; $count = 0
try {
    $connection = New-LocalBauSqlConnection -SqlServer $SqlServer -SourceDatabase $SourceDatabase -SqlUser $SqlUser -SqlPassword $SqlPassword
    $connection.Open(); $command = $connection.CreateCommand(); $command.CommandText = Get-Content -LiteralPath $transformSql -Raw; $reader = $command.ExecuteReader()
    while ($reader.Read()) {
        $values = for ($i = 0; $i -lt $reader.FieldCount; $i++) { if ($reader.IsDBNull($i)) { 'NULL' } else { $reader.GetValue($i).ToString().Replace('|', ' ') } }
        [System.IO.File]::AppendAllText($FixturePath, (($values -join '|') + [Environment]::NewLine), [System.Text.UTF8Encoding]::new($false)); $count++
    }
    if ($count -eq 0) { throw 'No Government Office Region rows were returned from local BAU.' }
}
finally { if ($reader) { $reader.Dispose() }; if ($command) { $command.Dispose() }; if ($connection) { $connection.Dispose() } }

$loadSqlTemp = Join-Path $env:TEMP 'epr-load-government-office-region-fixture.sql'
try {
    $loadSqlText = (Get-Content -LiteralPath $loadSql -Raw).Replace('__FIXTURE_PATH__', ($FixturePath -replace '\\', '/'))
    [System.IO.File]::WriteAllText($loadSqlTemp, $loadSqlText, [System.Text.UTF8Encoding]::new($false))
    & $psql -h $PostgresHost -p $PostgresPort -U $PostgresUser -d $PostgresDatabase -w -v ON_ERROR_STOP=1 -f $loadSqlTemp
    if ($LASTEXITCODE -ne 0) { throw "PostgreSQL Government Office Region load failed with exit code $LASTEXITCODE" }
}
finally { Remove-Item -LiteralPath $loadSqlTemp -Force -ErrorAction SilentlyContinue }
Write-Host "Government Office Regions loaded: $count. Fixture: $FixturePath"
