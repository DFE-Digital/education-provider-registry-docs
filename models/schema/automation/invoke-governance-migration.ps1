<#
.SYNOPSIS
Extracts the minimal governance appointment-and-term slice for one selected
establishment from the local BAU SQL Server copy and loads it into governance_local.
#>
[CmdletBinding()]
param(
    [string]$SqlServer = 'localhost',
    [string]$SourceDatabase = 'gias_bau_test_local',
    [string]$SqlUser = 'reader',
    [string]$SqlPassword = $env:EPR_BAU_SQL_PASSWORD,
    [string]$PostgresHost = '127.0.0.1',
    [int]$PostgresPort = 5432,
    [string]$PostgresDatabase = 'governance_local',
    [string]$PostgresUser = 'postgres',
    [ValidateRange(100000, 999999)][int]$Urn,
    [string]$FixturePath = (Join-Path $env:TEMP 'epr-registry-governance-appointment-fixture.csv')
)

$ErrorActionPreference = 'Stop'
$automationRoot = $PSScriptRoot
$schemaRoot = Split-Path -Parent $automationRoot
. (Join-Path $automationRoot 'common\local-database-guards.ps1')
. (Join-Path $automationRoot 'common\sql-client-functions.ps1')
Assert-LocalBauSource -SqlServer $SqlServer -SourceDatabase $SourceDatabase
Assert-LocalPostgresTarget -PostgresHost $PostgresHost -PostgresDatabase $PostgresDatabase
if (-not $SqlPassword) { throw 'Supply -SqlPassword or set EPR_BAU_SQL_PASSWORD.' }

$transformSql = Join-Path $schemaRoot 'governance\transforms\governance-appointment-from-bau.sql'
$loadSql = Join-Path $schemaRoot 'governance\load\load-governance-appointment-fixture.sql'
$psql = Get-LocalPostgresClientPath
foreach ($path in @($transformSql, $loadSql)) { if (-not (Test-Path -LiteralPath $path)) { throw "Required migration file not found: $path" } }

$fixtureDirectory = Split-Path -Parent $FixturePath
New-Item -ItemType Directory -Path $fixtureDirectory -Force | Out-Null
[System.IO.File]::WriteAllText($FixturePath, "source_governance_appointment_id|establishment_urn|governance_role_type_id|office_holder_role_type_id|term_start_date|term_end_date$([Environment]::NewLine)", [System.Text.UTF8Encoding]::new($false))

$reader = $null; $command = $null; $connection = $null; $count = 0; $termCount = 0
try {
    $sourceSql = (Get-Content -LiteralPath $transformSql -Raw).Replace('$(URN)', [string]$Urn)
    $connection = New-LocalBauSqlConnection -SqlServer $SqlServer -SourceDatabase $SourceDatabase -SqlUser $SqlUser -SqlPassword $SqlPassword
    $connection.Open(); $command = $connection.CreateCommand(); $command.CommandText = $sourceSql; $reader = $command.ExecuteReader()
    while ($reader.Read()) {
        $sourceId = $reader.GetValue(0).ToString(); $establishmentUrn = $reader.GetValue(1).ToString()
        $roleTypeId = if ($reader.IsDBNull(2)) { 'NULL' } else { $reader.GetValue(2).ToString().Replace('|', ' ') }
        $officeHolderRoleTypeId = if ($reader.IsDBNull(3)) { 'NULL' } else { $reader.GetValue(3).ToString().Replace('|', ' ') }
        $termStartDate = if ($reader.IsDBNull(4)) { 'NULL' } else { $reader.GetDateTime(4).ToString('yyyy-MM-dd') }
        $termEndDate = if ($reader.IsDBNull(5)) { 'NULL' } else { $reader.GetDateTime(5).ToString('yyyy-MM-dd') }
        [System.IO.File]::AppendAllText($FixturePath, "$sourceId|$establishmentUrn|$roleTypeId|$officeHolderRoleTypeId|$termStartDate|$termEndDate$([Environment]::NewLine)", [System.Text.UTF8Encoding]::new($false)); $count++
        if (-not $reader.IsDBNull(4) -or -not $reader.IsDBNull(5)) { $termCount++ }
    }
}
catch { throw "Governance source transform failed for URN ${Urn}: $($_.Exception.Message)" }
finally { if ($reader) { $reader.Dispose() }; if ($command) { $command.Dispose() }; if ($connection) { $connection.Dispose() } }
if ($count -eq 0) { Write-Host "No current governance appointments were returned for URN $Urn. Loading an empty fixture for this URN." }

$loadSqlTemp = Join-Path $env:TEMP 'epr-load-governance-appointment-fixture.sql'
try {
    $loadSqlText = (Get-Content -LiteralPath $loadSql -Raw).Replace('__FIXTURE_PATH__', ($FixturePath -replace '\\', '/'))
    [System.IO.File]::WriteAllText($loadSqlTemp, $loadSqlText, [System.Text.UTF8Encoding]::new($false))
    & $psql -h $PostgresHost -p $PostgresPort -U $PostgresUser -d $PostgresDatabase -w -v ON_ERROR_STOP=1 -f $loadSqlTemp
    if ($LASTEXITCODE -ne 0) { throw "PostgreSQL governance load failed with exit code $LASTEXITCODE" }
}
finally { Remove-Item -LiteralPath $loadSqlTemp -Force -ErrorAction SilentlyContinue }
Write-Host "Governance migration completed. Appointments loaded: $count. Terms loaded: $termCount. Fixture: $FixturePath"
