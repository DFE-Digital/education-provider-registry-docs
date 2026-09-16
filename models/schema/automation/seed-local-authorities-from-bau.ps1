<#
.SYNOPSIS
Extracts all local authorities from the local BAU SQL Server copy and loads
the target PostgreSQL reference data, including ten clearly labelled fake
contact records for development and test use.
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
    [string]$FixturePath = (Join-Path $env:TEMP 'epr-local-authority-fixture.csv')
)

$ErrorActionPreference = 'Stop'
$automationRoot = $PSScriptRoot
$schemaRoot = Split-Path -Parent $automationRoot
. (Join-Path $automationRoot 'common\local-database-guards.ps1')
. (Join-Path $automationRoot 'common\sql-client-functions.ps1')
Assert-LocalBauSource -SqlServer $SqlServer -SourceDatabase $SourceDatabase
Assert-LocalPostgresTarget -PostgresHost $PostgresHost -PostgresDatabase $PostgresDatabase
if (-not $SqlPassword) { throw 'Supply -SqlPassword or set EPR_BAU_SQL_PASSWORD.' }

$transformSql = Join-Path $schemaRoot 'establishment\transforms\local-authorities-from-bau.sql'
$loadSql = Join-Path $schemaRoot 'establishment\load\load-local-authority-fixture.sql'
$psql = Get-LocalPostgresClientPath
$fixtureDirectory = Split-Path -Parent $FixturePath
New-Item -ItemType Directory -Path $fixtureDirectory -Force | Out-Null
[System.IO.File]::WriteAllText($FixturePath, "code|name|jurisdiction_name$([Environment]::NewLine)", [System.Text.UTF8Encoding]::new($false))

$connection = $null; $command = $null; $reader = $null
try {
    $connection = New-LocalBauSqlConnection -SqlServer $SqlServer -SourceDatabase $SourceDatabase -SqlUser $SqlUser -SqlPassword $SqlPassword
    $connection.Open(); $command = $connection.CreateCommand(); $command.CommandText = (Get-Content -LiteralPath $transformSql -Raw); $reader = $command.ExecuteReader()
    while ($reader.Read()) {
        $values = for ($i = 0; $i -lt $reader.FieldCount; $i++) {
            if ($reader.IsDBNull($i)) { 'NULL' } else { $reader.GetValue($i).ToString().Replace('|', ' ') }
        }
        [System.IO.File]::AppendAllText($FixturePath, (($values -join '|') + [Environment]::NewLine), [System.Text.UTF8Encoding]::new($false))
    }
}
finally {
    if ($reader) { $reader.Dispose() }; if ($command) { $command.Dispose() }; if ($connection) { $connection.Dispose() }
}

$loadSqlTemp = Join-Path $env:TEMP 'epr-load-local-authority-fixture.sql'
try {
    $loadSqlText = (Get-Content -LiteralPath $loadSql -Raw).Replace('__FIXTURE_PATH__', ($FixturePath -replace '\\', '/'))
    [System.IO.File]::WriteAllText($loadSqlTemp, $loadSqlText, [System.Text.UTF8Encoding]::new($false))
    & $psql -h $PostgresHost -p $PostgresPort -U $PostgresUser -d $PostgresDatabase -w -v ON_ERROR_STOP=1 -f $loadSqlTemp
    if ($LASTEXITCODE -ne 0) { throw "PostgreSQL local-authority load failed with exit code $LASTEXITCODE" }
}
finally { Remove-Item -LiteralPath $loadSqlTemp -Force -ErrorAction SilentlyContinue }
Write-Host "Local authorities loaded with ten clearly labelled FAKE contact records. Fixture: $FixturePath"
