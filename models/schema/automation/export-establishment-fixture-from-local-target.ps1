<#
.SYNOPSIS
Exports the populated local Establishment target into checked-in SQL inputs.

.DESCRIPTION
Run this after the BAU-source rebuild has completed successfully. The target contains the
selected establishment-centric slice and the BAU-derived reference data.
pg_dump writes dependency-ordered, column-labelled batched INSERT statements so the
checked-in-fixture rebuild
can replay the result without SQL Server.
#>
[CmdletBinding()]
param(
    [string]$PostgresHost = '127.0.0.1',
    [int]$PostgresPort = 5432,
    [string]$PostgresDatabase = 'establishment_local',
    [string]$PostgresUser = 'postgres',
    [string]$PostgresPassword = $env:PGPASSWORD,
    [Parameter(Mandatory)][string]$OutputDirectory
)

$ErrorActionPreference = 'Stop'
$automationRoot = $PSScriptRoot
. (Join-Path $automationRoot 'common\local-database-guards.ps1')
. (Join-Path $automationRoot 'common\sql-client-functions.ps1')
Assert-LocalPostgresTarget -PostgresHost $PostgresHost -PostgresDatabase $PostgresDatabase

$pgDump = (Get-Command pg_dump.exe -ErrorAction SilentlyContinue).Source
if (-not $pgDump) { $pgDump = 'C:\Program Files\PostgreSQL\18\bin\pg_dump.exe' }
if (-not (Test-Path -LiteralPath $pgDump)) { throw \"pg_dump not found: $pgDump\" }
New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null

$referenceTables = @(
    'local_authority_jurisdiction', 'establishment_type', 'education_phase',
    'gender_of_entry_type', 'admissions_policy', 'boarding_provision',
    'nursery_provision', 'sixth_form_provision', 'specialist_provision_type',
    'establishment_status', 'reason_establishment_opened',
    'reason_establishment_closed', 'local_authority', 'government_office_region',
    'gss_local_authority_code', 'district_administrative', 'administrative_ward', 'parliamentary_constituency', 'lsoa', 'msoa', 'urban_rural', 'local_authority_contact',
    'local_authority_government_office_region'
)
$ownedTables = @(
    'establishment', 'establishment_geography', 'establishment_contact',
    'establishment_lifecycle', 'address', 'site', 'establishment_to_site',
    'capacity_and_pupil_measures', 'education_admissions_and_provision',
    'statutory_age_range', 'specialist_provision', 'resourced_provision',
    'sen_unit_provision'
)

$envPasswordBefore = $env:PGPASSWORD
if ($PostgresPassword) { $env:PGPASSWORD = $PostgresPassword }
try {
    $referenceFile = Join-Path $OutputDirectory 'seed-reference-data.sql'
    $ownedFile = Join-Path $OutputDirectory 'seed-establishment-fixture.sql'
    $common = @('-h', $PostgresHost, '-p', $PostgresPort, '-U', $PostgresUser, '-d', $PostgresDatabase, '--data-only', '--column-inserts', '--rows-per-insert=1000', '--no-owner', '--no-privileges', '--no-comments')
    $referenceArgs = @($common + @('--file', $referenceFile))
    foreach ($table in $referenceTables) { $referenceArgs += @('--table', "establishment.$table") }
    & $pgDump @referenceArgs
    if ($LASTEXITCODE -ne 0) { throw 'Reference-data export failed.' }
    $ownedArgs = @($common + @('--file', $ownedFile))
    foreach ($table in $ownedTables) { $ownedArgs += @('--table', "establishment.$table") }
    & $pgDump @ownedArgs
    if ($LASTEXITCODE -ne 0) { throw 'Establishment fixture export failed.' }
    Write-Host "Exported BAU-derived reference and Establishment SQL to $OutputDirectory"
}
finally { $env:PGPASSWORD = $envPasswordBefore }
