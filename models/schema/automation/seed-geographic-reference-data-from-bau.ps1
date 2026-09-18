<#
.SYNOPSIS
Extracts and loads geographic reference data from the approved local BAU copy.

.DESCRIPTION
Loads Local Authorities (including the deterministic local contacts fixture)
and Government Office Regions through one geographic-reference-data entry
point. Additional geographic reference datasets can be added to the list in
this script without creating another top-level PowerShell command.
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
    [string]$FixtureDirectory = (Join-Path $env:TEMP 'epr-geographic-reference-data')
)

$ErrorActionPreference = 'Stop'
$automationRoot = $PSScriptRoot
$schemaRoot = Split-Path -Parent $automationRoot
. (Join-Path $automationRoot 'common\local-database-guards.ps1')
. (Join-Path $automationRoot 'common\sql-client-functions.ps1')
Assert-LocalBauSource -SqlServer $SqlServer -SourceDatabase $SourceDatabase
Assert-LocalPostgresTarget -PostgresHost $PostgresHost -PostgresDatabase $PostgresDatabase
if (-not $SqlPassword) { throw 'Supply -SqlPassword or set EPR_BAU_SQL_PASSWORD.' }

$psql = Get-LocalPostgresClientPath
New-Item -ItemType Directory -Path $FixtureDirectory -Force | Out-Null

$datasets = @(
    [pscustomobject]@{
        Name = 'local-authority'
        Transform = Join-Path $schemaRoot 'establishment\transforms\local-authorities-from-bau.sql'
        Load = Join-Path $schemaRoot 'establishment\load\load-local-authority-fixture.sql'
        Fixture = Join-Path $FixtureDirectory 'epr-local-authority-fixture.csv'
        Header = 'code|name|jurisdiction_name'
        RequireRows = $true
    },
    [pscustomobject]@{
        Name = 'government-office-region'
        Transform = Join-Path $schemaRoot 'establishment\transforms\government-office-regions-from-bau.sql'
        Load = Join-Path $schemaRoot 'establishment\load\load-government-office-region-fixture.sql'
        Fixture = Join-Path $FixtureDirectory 'epr-government-office-region-fixture.csv'
        Header = 'code'
        RequireRows = $true
    },
    [pscustomobject]@{
        Name = 'gss-local-authority-code'
        Transform = Join-Path $schemaRoot 'establishment\transforms\gss-local-authority-codes-from-bau.sql'
        Load = Join-Path $schemaRoot 'establishment\load\load-gss-local-authority-code-fixture.sql'
        Fixture = Join-Path $FixtureDirectory 'epr-gss-local-authority-code-fixture.csv'
        Header = 'code|name'
        RequireRows = $true
    },
    [pscustomobject]@{
        Name = 'local-authority-gss-mapping'
        Transform = Join-Path $schemaRoot 'establishment\transforms\local-authority-gss-mappings-from-bau.sql'
        Load = Join-Path $schemaRoot 'establishment\load\load-local-authority-gss-mapping-fixture.sql'
        Fixture = Join-Path $FixtureDirectory 'epr-local-authority-gss-mapping-fixture.csv'
        Header = 'local_authority_code|gss_code'
        RequireRows = $true
    },
    [pscustomobject]@{
        Name = 'local-authority-gor-mapping'
        Transform = Join-Path $schemaRoot 'establishment\transforms\local-authority-gor-mappings-from-bau.sql'
        Load = Join-Path $schemaRoot 'establishment\load\load-local-authority-gor-mapping-fixture.sql'
        Fixture = Join-Path $FixtureDirectory 'epr-local-authority-gor-mapping-fixture.csv'
        Header = 'local_authority_code|region_code'
        RequireRows = $true
    }
)

$connection = $null
try {
    foreach ($dataset in $datasets) {
        foreach ($path in @($dataset.Transform, $dataset.Load)) {
            if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { throw "Required geographic reference file not found: $path" }
        }

        [System.IO.File]::WriteAllText($dataset.Fixture, $dataset.Header + [Environment]::NewLine, [System.Text.UTF8Encoding]::new($false))
        $command = $null
        $reader = $null
        $count = 0
        try {
            if (-not $connection) {
                $connection = New-LocalBauSqlConnection -SqlServer $SqlServer -SourceDatabase $SourceDatabase -SqlUser $SqlUser -SqlPassword $SqlPassword
                $connection.Open()
            }
            $command = $connection.CreateCommand()
            $command.CommandText = Get-Content -LiteralPath $dataset.Transform -Raw
            $reader = $command.ExecuteReader()
            while ($reader.Read()) {
                $values = for ($i = 0; $i -lt $reader.FieldCount; $i++) {
                    if ($reader.IsDBNull($i)) { 'NULL' } else { $reader.GetValue($i).ToString().Replace('|', ' ') }
                }
                [System.IO.File]::AppendAllText($dataset.Fixture, (($values -join '|') + [Environment]::NewLine), [System.Text.UTF8Encoding]::new($false))
                $count++
            }
            if ($dataset.RequireRows -and $count -eq 0) { throw "No $($dataset.Name) rows were returned from local BAU." }
        }
        finally {
            if ($reader) { $reader.Dispose() }
            if ($command) { $command.Dispose() }
        }

        $loadSqlTemp = Join-Path $env:TEMP "epr-load-$($dataset.Name)-fixture.sql"
        try {
            $loadSqlText = (Get-Content -LiteralPath $dataset.Load -Raw).Replace('__FIXTURE_PATH__', ($dataset.Fixture -replace '\\', '/'))
            [System.IO.File]::WriteAllText($loadSqlTemp, $loadSqlText, [System.Text.UTF8Encoding]::new($false))
            & $psql -h $PostgresHost -p $PostgresPort -U $PostgresUser -d $PostgresDatabase -w -v ON_ERROR_STOP=1 -f $loadSqlTemp
            if ($LASTEXITCODE -ne 0) { throw "PostgreSQL $($dataset.Name) load failed with exit code $LASTEXITCODE" }
        }
        finally { Remove-Item -LiteralPath $loadSqlTemp -Force -ErrorAction SilentlyContinue }

        Write-Host "$($dataset.Name) geographic reference data loaded: $count rows."
    }
}
finally {
    if ($connection) { $connection.Dispose() }
}
