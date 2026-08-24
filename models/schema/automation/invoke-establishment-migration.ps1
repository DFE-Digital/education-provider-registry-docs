<#
.SYNOPSIS
Extracts one selected establishment from the local BAU SQL Server copy and
loads it into PostgreSQL establishment_local.
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
    [ValidateRange(100000, 999999)][int]$Urn,
    [string]$FixturePath = (Join-Path $env:TEMP 'epr-registry-establishment-fixture.csv')
)

$ErrorActionPreference = 'Stop'
$automationRoot = $PSScriptRoot
$schemaRoot = Split-Path -Parent $automationRoot
. (Join-Path $automationRoot 'common\local-database-guards.ps1')
. (Join-Path $automationRoot 'common\sql-client-functions.ps1')
Assert-LocalBauSource -SqlServer $SqlServer -SourceDatabase $SourceDatabase
Assert-LocalPostgresTarget -PostgresHost $PostgresHost -PostgresDatabase $PostgresDatabase
if (-not $SqlPassword) { throw 'Supply -SqlPassword or set EPR_BAU_SQL_PASSWORD.' }

$transformSql = Join-Path $schemaRoot 'establishment\transforms\establishment-from-bau.sql'
$loadSql = Join-Path $schemaRoot 'establishment\load\load-establishment-fixture.sql'
$psql = Get-LocalPostgresClientPath
foreach ($path in @($transformSql, $loadSql)) { if (-not (Test-Path -LiteralPath $path)) { throw "Required migration file not found: $path" } }

$header = 'urn|ukprn|local_authority_code|establishment_number|name|type_code|education_phase_code|school_capacity|pupil_count|free_school_meal_measure|resourced_provision_capacity|resourced_provision_pupil_count|sen_unit_capacity|sen_unit_pupil_count|lower_statutory_age|upper_statutory_age|gender_code|admissions_policy_code|boarders_code|nursery_provision_code|sixth_form_code|reserved_provision_code|main_site_name|address_line_1|address_line_2|address_line_3|address_town|address_county|address_postcode|address_uprn'
$transformHeader = @('urn','ukprn','local_authority_code','establishment_number','dfe_number','name','source_establishment_type_code','source_establishment_type','establishment_type_id','establishment_type','source_education_phase_code','source_education_phase','education_phase_id','education_phase','source_gender_code','source_gender','gender_of_entry_type_id','gender_of_entry','source_admissions_policy_code','source_admissions_policy','admissions_policy_id','admissions_policy','source_boarding_provision_code','source_boarding_provision','boarding_provision_id','boarding_provision','source_nursery_provision_code','source_nursery_provision','nursery_provision_id','nursery_provision','source_sixth_form_provision_code','source_sixth_form_provision','sixth_form_provision_id','sixth_form_provision','school_capacity','pupil_count','free_school_meal_measure','source_free_school_meal_percentage','census_date','source_specialist_provision_type_code','source_specialist_provision_type','specialist_provision_type_id','specialist_provision_type','resourced_provision_capacity','resourced_provision_pupil_count','sen_unit_capacity','sen_unit_pupil_count','lower_statutory_age','upper_statutory_age','main_site_name','address_line_1','address_line_2','address_line_3','address_town','address_county','address_postcode','address_uprn')

$fixtureDirectory = Split-Path -Parent $FixturePath
New-Item -ItemType Directory -Path $fixtureDirectory -Force | Out-Null
[System.IO.File]::WriteAllText($FixturePath, $header + [Environment]::NewLine, [System.Text.UTF8Encoding]::new($false))

$reader = $null; $command = $null; $connection = $null
try {
    $sourceSql = (Get-Content -LiteralPath $transformSql -Raw).Replace('$(URN)', [string]$Urn)
    $connection = New-LocalBauSqlConnection -SqlServer $SqlServer -SourceDatabase $SourceDatabase -SqlUser $SqlUser -SqlPassword $SqlPassword
    $connection.Open(); $command = $connection.CreateCommand(); $command.CommandText = $sourceSql; $reader = $command.ExecuteReader()
    if (-not $reader.Read()) { throw "No transformed row returned for URN $Urn" }
    $values = for ($i = 0; $i -lt $reader.FieldCount; $i++) { if ($reader.IsDBNull($i)) { 'NULL' } else { $reader.GetValue($i).ToString().Replace('|', ' ') } }
    $row = ($values -join '|') | ConvertFrom-Csv -Delimiter '|' -Header $transformHeader
}
catch { throw "Source transform failed for URN ${Urn}: $($_.Exception.Message)" }
finally { if ($reader) { $reader.Dispose() }; if ($command) { $command.Dispose() }; if ($connection) { $connection.Dispose() } }

@(
    $row.urn, $row.ukprn, $row.local_authority_code, $row.establishment_number,
    $row.name, $row.source_establishment_type_code, $row.source_education_phase_code,
    $row.school_capacity, $row.pupil_count, $row.free_school_meal_measure,
    $row.resourced_provision_capacity, $row.resourced_provision_pupil_count,
    $row.sen_unit_capacity, $row.sen_unit_pupil_count, $row.lower_statutory_age,
    $row.upper_statutory_age, $row.source_gender_code, $row.source_admissions_policy_code,
    $row.source_boarding_provision_code, $row.source_nursery_provision_code,
    $row.source_sixth_form_provision_code, $row.source_specialist_provision_type_code,
    $row.main_site_name, $row.address_line_1, $row.address_line_2, $row.address_line_3,
    $row.address_town, $row.address_county, $row.address_postcode, $row.address_uprn
) -join '|' | ForEach-Object { [System.IO.File]::AppendAllText($FixturePath, $_ + [Environment]::NewLine, [System.Text.UTF8Encoding]::new($false)) }

$loadSqlTemp = Join-Path $env:TEMP 'epr-load-establishment-fixture.sql'
try {
    $loadSqlText = (Get-Content -LiteralPath $loadSql -Raw).Replace('__FIXTURE_PATH__', ($FixturePath -replace '\\', '/'))
    [System.IO.File]::WriteAllText($loadSqlTemp, $loadSqlText, [System.Text.UTF8Encoding]::new($false))
    & $psql -h $PostgresHost -p $PostgresPort -U $PostgresUser -d $PostgresDatabase -w -v ON_ERROR_STOP=1 -f $loadSqlTemp
    if ($LASTEXITCODE -ne 0) { throw "PostgreSQL establishment load failed with exit code $LASTEXITCODE" }
}
finally { Remove-Item -LiteralPath $loadSqlTemp -Force -ErrorAction SilentlyContinue }
Write-Host "Establishment migration completed. Fixture: $FixturePath"
