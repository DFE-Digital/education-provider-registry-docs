[CmdletBinding()]
param(
    [string]$FixturePath = (Join-Path $env:TEMP 'epr-basic-establishment-fixture.csv'),
    [switch]$KeepFixture
)

$ErrorActionPreference = 'Stop'
$automationRoot = $PSScriptRoot
$schemaRoot = Split-Path -Parent $automationRoot
$psql = 'C:\Program Files\PostgreSQL\18\bin\psql.exe'
$targetDatabase = 'establishment_local'
$schemaSql = Join-Path $schemaRoot 'basic-establishment-data-schema.sql'
$referenceDataSql = Join-Path $schemaRoot 'seed\seed-reference-data.sql'
$runner = Join-Path $automationRoot 'migrate-basic-establishment-fixture.ps1'

if (-not (Test-Path -LiteralPath $psql)) { throw "PostgreSQL client not found: $psql" }
foreach ($path in @($schemaSql, $referenceDataSql, $runner)) {
    if (-not (Test-Path -LiteralPath $path)) { throw "Required migration file not found: $path" }
}

$securePassword = Read-Host 'Local SQL Server reader password' -AsSecureString
try {
    & $psql -h 127.0.0.1 -p 5432 -U postgres -d $targetDatabase -v ON_ERROR_STOP=1 -f $schemaSql
    if ($LASTEXITCODE -ne 0) { throw 'Target schema rebuild failed.' }

    & $psql -h 127.0.0.1 -p 5432 -U postgres -d $targetDatabase -v ON_ERROR_STOP=1 -f $referenceDataSql
    if ($LASTEXITCODE -ne 0) { throw 'Reference-data seed failed.' }

    $env:EPR_BAU_SQL_PASSWORD = [System.Net.NetworkCredential]::new('', $securePassword).Password
    powershell.exe -NoProfile -ExecutionPolicy Bypass -File $runner -FixturePath $FixturePath
    if ($LASTEXITCODE -ne 0) { throw 'Fixture migration failed.' }

    & $psql -h 127.0.0.1 -p 5432 -U postgres -d $targetDatabase -v ON_ERROR_STOP=1 -c "SELECT e.urn, e.name, m.pupil_count, m.free_school_meal_measure FROM establishment.establishment AS e JOIN establishment.capacity_and_pupil_measures AS m ON m.establishment_id = e.establishment_id WHERE e.urn IN (100018, 106431, 136102) ORDER BY e.urn;"
    if ($LASTEXITCODE -ne 0) { throw 'Validation query failed.' }

    Write-Host 'Basic-establishment migration completed and validated.'
    if ($KeepFixture) { Write-Host "Fixture retained at: $FixturePath" }
}
finally {
    Remove-Item Env:EPR_BAU_SQL_PASSWORD -ErrorAction SilentlyContinue
    Remove-Variable securePassword -ErrorAction SilentlyContinue
    if (-not $KeepFixture) { Remove-Item -LiteralPath $FixturePath -Force -ErrorAction SilentlyContinue }
}
