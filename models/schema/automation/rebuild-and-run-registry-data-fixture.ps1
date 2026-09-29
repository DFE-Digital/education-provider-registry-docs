<#
.SYNOPSIS
Rebuilds the local Establishment and Governance schemas, then migrates the one
organisation selected in models/schema/seed/one-organisation.json.
#>
[CmdletBinding()]
param(
    [string]$FixtureDirectory = $env:TEMP,
    [switch]$KeepFixture
)

$ErrorActionPreference = 'Stop'
$automationRoot = $PSScriptRoot
$schemaRoot = Split-Path -Parent $automationRoot
. (Join-Path $automationRoot 'common\local-database-guards.ps1')
. (Join-Path $automationRoot 'common\sql-client-functions.ps1')

$selectionPath = Join-Path $schemaRoot 'seed\one-organisation.json'
$establishmentSchemaSql = Join-Path $schemaRoot 'establishment\core-establishment-schema.sql'
$governanceSchemaSql = Join-Path $schemaRoot 'governance\governance-schema.sql'
$referenceDataSql = Join-Path $schemaRoot 'seed\seed-reference-data.sql'
$academyTrustReferenceDataSql = Join-Path $schemaRoot 'seed\seed-academy-trust-reference-data.sql'
$establishmentRunner = Join-Path $automationRoot 'invoke-establishment-migration.ps1'
$academyTrustRunner = Join-Path $automationRoot 'invoke-academy-trust-responsibility-migration.ps1'
$academyTrustValidationSql = Join-Path $schemaRoot 'establishment\validate-academy-trust-responsibilities.sql'
$geographicReferenceRunner = Join-Path $automationRoot 'seed-geographic-reference-data-from-bau.ps1'
$governanceRunner = Join-Path $automationRoot 'invoke-governance-migration.ps1'
$psql = Get-LocalPostgresClientPath
foreach ($path in @($selectionPath, $establishmentSchemaSql, $governanceSchemaSql, $referenceDataSql, $academyTrustReferenceDataSql, $establishmentRunner, $academyTrustRunner, $academyTrustValidationSql, $geographicReferenceRunner, $governanceRunner)) {
    if (-not (Test-Path -LiteralPath $path)) { throw "Required registry migration file not found: $path" }
}

$selection = Get-Content -LiteralPath $selectionPath -Raw | ConvertFrom-Json
if ($selection.organisationType -ne 'establishment-fixture-set') { throw "The first registry slice supports organisationType 'establishment-fixture-set' only." }
$urns = @($selection.urns | ForEach-Object {
    try { [int]$_ } catch { throw 'Every selected organisation URN must be an integer.' }
})
if ($urns.Count -eq 0) { throw 'The shared fixture selection must contain at least one URN.' }
if (($urns | Select-Object -Unique).Count -ne $urns.Count) { throw 'The shared fixture selection must not contain duplicate URNs.' }
foreach ($urn in $urns) { if ($urn -lt 100000 -or $urn -gt 999999) { throw "The selected organisation URN is outside the valid range: $urn" } }
$establishmentPartyRoleResponsibilities = @($selection.establishmentPartyRoleResponsibilities)
foreach ($responsibility in $establishmentPartyRoleResponsibilities) {
    $responsibilityUrn = [int]$responsibility.urn
    $sourceGroupId = [int]$responsibility.sourceGroupId
    if ($responsibilityUrn -notin $urns) { throw "Establishment-party-role fixture URN must also be in urns: $responsibilityUrn" }
    if ($sourceGroupId -lt 1) { throw "Establishment-party-role source group ID must be positive: $sourceGroupId" }
}
$urnList = $urns -join ', '
New-Item -ItemType Directory -Path $FixtureDirectory -Force | Out-Null

Assert-LocalPostgresTarget -PostgresHost '127.0.0.1' -PostgresDatabase 'establishment_local'
Assert-LocalPostgresTarget -PostgresHost '127.0.0.1' -PostgresDatabase 'governance_local'

$securePassword = Read-Host 'Local SQL Server reader password' -AsSecureString
try {
    & $psql -h 127.0.0.1 -p 5432 -U postgres -d establishment_local -w -v ON_ERROR_STOP=1 -f $establishmentSchemaSql
    if ($LASTEXITCODE -ne 0) { throw 'Establishment schema rebuild failed.' }

    & $psql -h 127.0.0.1 -p 5432 -U postgres -d establishment_local -w -v ON_ERROR_STOP=1 -f $referenceDataSql
    if ($LASTEXITCODE -ne 0) { throw 'Establishment reference-data seed failed.' }

    & $psql -h 127.0.0.1 -p 5432 -U postgres -d establishment_local -w -v ON_ERROR_STOP=1 -f $academyTrustReferenceDataSql
    if ($LASTEXITCODE -ne 0) { throw 'Academy-trust reference-data seed failed.' }

    & $psql -h 127.0.0.1 -p 5432 -U postgres -d governance_local -w -v ON_ERROR_STOP=1 -f $governanceSchemaSql
    if ($LASTEXITCODE -ne 0) { throw 'Governance schema rebuild failed.' }

    $env:EPR_BAU_SQL_PASSWORD = [System.Net.NetworkCredential]::new('', $securePassword).Password
    & $geographicReferenceRunner -FixtureDirectory $FixtureDirectory
    & $psql -h 127.0.0.1 -p 5432 -U postgres -d establishment_local -w -v ON_ERROR_STOP=1 -c "DO `$`$ BEGIN IF NOT EXISTS (SELECT 1 FROM establishment.government_office_region) THEN RAISE EXCEPTION 'No Government Office Region rows loaded'; END IF; END `$`$;"
    if ($LASTEXITCODE -ne 0) { throw 'Government Office Region validation failed.' }
    foreach ($urn in $urns) {
        & $establishmentRunner -Urn $urn -FixturePath (Join-Path $FixtureDirectory "epr-registry-establishment-$urn-fixture.csv")
    }
    foreach ($responsibility in $establishmentPartyRoleResponsibilities) {
        & $academyTrustRunner -Urn ([int]$responsibility.urn) -SourceGroupId ([int]$responsibility.sourceGroupId) -FixturePath (Join-Path $FixtureDirectory "epr-academy-trust-$($responsibility.fixture)-$($responsibility.urn)-fixture.csv")
        if ($LASTEXITCODE -ne 0) { throw "Establishment-party-role migration failed for fixture $($responsibility.fixture)." }
    }
    foreach ($urn in $urns) {
        & $governanceRunner -Urn $urn -FixturePath (Join-Path $FixtureDirectory "epr-registry-governance-appointment-$urn-fixture.csv")
    }

    & $psql -h 127.0.0.1 -p 5432 -U postgres -d establishment_local -w -v ON_ERROR_STOP=1 -c "SELECT e.urn, e.name, m.pupil_count, m.free_school_meal_measure FROM establishment.establishment AS e LEFT JOIN establishment.capacity_and_pupil_measures AS m ON m.establishment_id = e.establishment_id WHERE e.urn IN ($urnList) ORDER BY e.urn;"
    if ($LASTEXITCODE -ne 0) { throw 'Establishment validation query failed.' }

    if ($establishmentPartyRoleResponsibilities.Count -gt 0) {
        & $psql -h 127.0.0.1 -p 5432 -U postgres -d establishment_local -w -v ON_ERROR_STOP=1 -f $academyTrustValidationSql
        if ($LASTEXITCODE -ne 0) { throw 'Academy-trust fixture validation failed.' }
    }

    & $psql -h 127.0.0.1 -p 5432 -U postgres -d governance_local -w -v ON_ERROR_STOP=1 -c "SELECT appointment.establishment_urn, COUNT(*) AS governance_appointment_count, COUNT(appointment.governance_role_type_id) AS mapped_role_type_count, COUNT(term.term_of_office_id) AS term_of_office_count, COUNT(term.start_date) AS term_start_date_count, COUNT(term.end_date) AS term_end_date_count, COUNT(office.office_holder_assignment_id) AS office_holder_assignment_count FROM governance.governance_appointment AS appointment LEFT JOIN governance.term_of_office AS term ON term.governance_appointment_id = appointment.governance_appointment_id LEFT JOIN governance.office_holder_assignment AS office ON office.governance_appointment_id = appointment.governance_appointment_id WHERE appointment.establishment_urn IN ($urnList) GROUP BY appointment.establishment_urn ORDER BY appointment.establishment_urn;"
    if ($LASTEXITCODE -ne 0) { throw 'Governance validation query failed.' }

    Write-Host "Registry data fixture migration completed and validated for URNs: $urnList."
    if ($KeepFixture) {
        Write-Host "Fixtures retained in: $FixtureDirectory"
    }
}
finally {
    Remove-Item Env:EPR_BAU_SQL_PASSWORD -ErrorAction SilentlyContinue
    Remove-Variable securePassword -ErrorAction SilentlyContinue
    if (-not $KeepFixture) {
        Remove-Item -LiteralPath (Join-Path $FixtureDirectory 'epr-local-authority-fixture.csv') -Force -ErrorAction SilentlyContinue
        Remove-Item -LiteralPath (Join-Path $FixtureDirectory 'epr-government-office-region-fixture.csv') -Force -ErrorAction SilentlyContinue
        Remove-Item -LiteralPath (Join-Path $FixtureDirectory 'epr-district-administrative-fixture.csv') -Force -ErrorAction SilentlyContinue
        Remove-Item -LiteralPath (Join-Path $FixtureDirectory 'epr-administrative-ward-fixture.csv') -Force -ErrorAction SilentlyContinue
        Remove-Item -LiteralPath (Join-Path $FixtureDirectory 'epr-parliamentary-constituency-fixture.csv') -Force -ErrorAction SilentlyContinue
        Remove-Item -LiteralPath (Join-Path $FixtureDirectory 'epr-lsoa-fixture.csv') -Force -ErrorAction SilentlyContinue
        Remove-Item -LiteralPath (Join-Path $FixtureDirectory 'epr-msoa-fixture.csv') -Force -ErrorAction SilentlyContinue
        Remove-Item -LiteralPath (Join-Path $FixtureDirectory 'epr-urban-rural-fixture.csv') -Force -ErrorAction SilentlyContinue
        Remove-Item -LiteralPath (Join-Path $FixtureDirectory 'epr-gss-local-authority-code-fixture.csv') -Force -ErrorAction SilentlyContinue
        Remove-Item -LiteralPath (Join-Path $FixtureDirectory 'epr-local-authority-gss-mapping-fixture.csv') -Force -ErrorAction SilentlyContinue
        Remove-Item -LiteralPath (Join-Path $FixtureDirectory 'epr-local-authority-gor-mapping-fixture.csv') -Force -ErrorAction SilentlyContinue
        foreach ($urn in $urns) {
            Remove-Item -LiteralPath (Join-Path $FixtureDirectory "epr-registry-establishment-$urn-fixture.csv") -Force -ErrorAction SilentlyContinue
            Remove-Item -LiteralPath (Join-Path $FixtureDirectory "epr-registry-governance-appointment-$urn-fixture.csv") -Force -ErrorAction SilentlyContinue
        }
        foreach ($responsibility in $establishmentPartyRoleResponsibilities) {
            Remove-Item -LiteralPath (Join-Path $FixtureDirectory "epr-academy-trust-$($responsibility.fixture)-$($responsibility.urn)-fixture.csv") -Force -ErrorAction SilentlyContinue
        }
    }
}
