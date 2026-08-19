<#
.SYNOPSIS
  Extracts three controlled rows from the local BAU SQL Server copy and loads
  them into PostgreSQL establishment_local.

.NOTES
  This is intentionally a small, rerunnable local migration. It does not
  connect to a shared environment and it does not store credentials.
  PostgreSQL authentication is expected through the user's pgpass file.
#>
[CmdletBinding()]
param(
    [string]$SqlServer = 'localhost',
    [string]$SourceDatabase = 'gias_bau_test_local',
    [string]$SqlUser = 'reader',
    [string]$SqlPassword = $env:EPR_BAU_SQL_PASSWORD,
    [string]$PostgresHost = 'localhost',
    [int]$PostgresPort = 5432,
    [string]$PostgresDatabase = 'establishment_local',
    [string]$PostgresUser = 'postgres',
    [string]$FixturePath = (Join-Path $env:TEMP 'epr-basic-establishment-fixture.csv')
)

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$schemaRoot = Split-Path -Parent $root
$transformSql = Join-Path $schemaRoot 'transforms\establishment-from-bau.sql'
$loadSql = Join-Path $root 'load-basic-establishment-fixture.sql'
$psql = (Get-Command psql.exe -ErrorAction SilentlyContinue).Source
if (-not $psql) { $psql = 'C:\Program Files\PostgreSQL\18\bin\psql.exe' }

if (-not (Test-Path -LiteralPath $psql)) { throw "psql not found: $psql" }
if (-not $SqlPassword) { throw 'Supply -SqlPassword or set EPR_BAU_SQL_PASSWORD.' }

$header = 'urn|ukprn|local_authority_code|establishment_number|name|type_code|education_phase_code|school_capacity|pupil_count|free_school_meal_measure|resourced_provision_capacity|resourced_provision_pupil_count|sen_unit_capacity|sen_unit_pupil_count|lower_statutory_age|upper_statutory_age|gender_code|admissions_policy_code|boarders_code|nursery_provision_code|sixth_form_code|reserved_provision_code|main_site_name|address_line_1|address_line_2|address_line_3|address_town|address_county|address_postcode|address_uprn'
$fixtureDirectory = Split-Path -Parent $FixturePath
New-Item -ItemType Directory -Path $fixtureDirectory -Force | Out-Null
[System.IO.File]::WriteAllText($FixturePath, $header + [Environment]::NewLine, [System.Text.UTF8Encoding]::new($false))

# The reusable transform emits the complete target-shaped projection. Select
# the fields needed by the PostgreSQL loader, preserving the source codes that
# drive reference-data mappings.
$transformHeader = @('urn','ukprn','local_authority_code','establishment_number','dfe_number','name','source_establishment_type_code','source_establishment_type','establishment_type_id','establishment_type','source_education_phase_code','source_education_phase','education_phase_id','education_phase','source_gender_code','source_gender','gender_of_entry_type_id','gender_of_entry','source_admissions_policy_code','source_admissions_policy','admissions_policy_id','admissions_policy','source_boarding_provision_code','source_boarding_provision','boarding_provision_id','boarding_provision','source_nursery_provision_code','source_nursery_provision','nursery_provision_id','nursery_provision','source_sixth_form_provision_code','source_sixth_form_provision','sixth_form_provision_id','sixth_form_provision','school_capacity','pupil_count','free_school_meal_measure','source_free_school_meal_percentage','census_date','source_specialist_provision_type_code','source_specialist_provision_type','specialist_provision_type_id','specialist_provision_type','resourced_provision_capacity','resourced_provision_pupil_count','sen_unit_capacity','sen_unit_pupil_count','lower_statutory_age','upper_statutory_age','main_site_name','address_line_1','address_line_2','address_line_3','address_town','address_county','address_postcode','address_uprn')
foreach ($urn in 100018, 106431, 136102) {
    $sourceSql = (Get-Content -LiteralPath $transformSql -Raw).Replace('$(URN)', [string]$urn)
    $connectionString = "Server=$SqlServer;Database=$SourceDatabase;User ID=$SqlUser;Password=$SqlPassword;Encrypt=False;TrustServerCertificate=True;Connection Timeout=10"
    $connection = New-Object System.Data.SqlClient.SqlConnection $connectionString
    try {
        $connection.Open()
        $command = $connection.CreateCommand()
        $command.CommandText = $sourceSql
        $reader = $command.ExecuteReader()
        if (-not $reader.Read()) { throw "No transformed row returned for URN $urn" }
        $values = for ($i = 0; $i -lt $reader.FieldCount; $i++) {
            if ($reader.IsDBNull($i)) { 'NULL' }
            else { $reader.GetValue($i).ToString().Replace('|', ' ') }
        }
        $row = ($values -join '|') | ConvertFrom-Csv -Delimiter '|' -Header $transformHeader
    }
    catch {
        throw "Source transform failed for URN ${urn}: $($_.Exception.Message)"
    }
    finally {
        if ($reader) { $reader.Dispose() }
        if ($command) { $command.Dispose() }
        $connection.Dispose()
        $reader = $null
        $command = $null
    }
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
}

$loadSqlTemp = Join-Path $env:TEMP 'epr-load-basic-establishment-fixture.sql'
$loadSqlText = (Get-Content -LiteralPath $loadSql -Raw).Replace('__FIXTURE_PATH__', ($FixturePath -replace '\\', '/'))
[System.IO.File]::WriteAllText($loadSqlTemp, $loadSqlText, [System.Text.UTF8Encoding]::new($false))
& $psql -h $PostgresHost -p $PostgresPort -U $PostgresUser -d $PostgresDatabase -v ON_ERROR_STOP=1 -f $loadSqlTemp
if ($LASTEXITCODE -ne 0) { throw "PostgreSQL load failed with exit code $LASTEXITCODE" }

Write-Host "Migration completed. Fixture: $FixturePath"
