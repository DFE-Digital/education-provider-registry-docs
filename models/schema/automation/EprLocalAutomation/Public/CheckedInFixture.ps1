# The checked-in SQL fixtures in seed/: loading them without a BAU copy, and
# exporting a fresh set from a validated local database.

# Tables exported to each checked-in file. The order is the pg_dump selection;
# pg_dump itself writes rows in dependency order.
$script:ReferenceSeedTables = @(
    'local_authority_jurisdiction', 'establishment_type_category', 'academy_route',
    'establishment_type', 'education_phase',
    'further_education_type', 'section_41_approval_status',
    'religious_character', 'religious_ethos', 'diocese',
    'gender_of_entry_type', 'admissions_policy', 'boarding_provision',
    'nursery_provision', 'sixth_form_provision', 'specialist_provision_type', 'sen',
    'establishment_status', 'reason_establishment_opened',
    'reason_establishment_closed', 'local_authority_area', 'government_office_region',
    'gss_local_authority_code', 'district_administrative', 'administrative_ward',
    'parliamentary_constituency', 'lsoa', 'msoa', 'urban_rural',
    'local_authority_area_contact', 'local_authority_area_government_office_region', 'address_purpose'
)
$script:EstablishmentSeedTables = @(
    'establishment', 'establishment_geography', 'establishment_contact',
    'establishment_lifecycle', 'address', 'site', 'establishment_to_site',
    'capacity_and_pupil_measures', 'education_admissions_and_provision',
    'statutory_age_range', 'specialist_provision', 'resourced_provision',
    'sen_unit_provision', 'establishment_sen', 'legal_entity', 'person', 'organisation_identifier',
    'legal_entity_sole_trader', 'legal_entity_partner',
    'establishment_party_role', 'academy_trust_classification',
    'establishment_responsibility', 'organisation_group',
    'organisation_group_member', 'organisation_group_member_lead_period', 'group_identifier',
    'legal_entity_address', 'organisation_group_address', 'local_authority_area_council_period'
)
$script:MigrationSeedTables = @(
    'migration_run', 'source_snapshot', 'source_record',
    'establishment_party_role_evidence', 'establishment_responsibility_evidence',
    'academy_trust_classification_evidence', 'organisation_group_member_evidence',
    'identity_resolution', 'group_address_evidence', 'organisation_group_address_evidence',
    'person_address_evidence', 'maintenance_source_observation', 'maintenance_derivation',
    'proprietor_review','proprietor_fact_evidence',
    'council_reorganisation','council_reorganisation_lineage','council_replay_observation'
)

# File names in seed/.
$script:ReferenceSeedFile = 'seed-reference-data.sql'
$script:EstablishmentSeedFile = 'seed-establishment-fixture.sql'
$script:MigrationSeedFile = 'seed-migration-evidence.sql'

function Import-CheckedInEstablishmentFixture {
    <#
    .SYNOPSIS
    Loads the checked-in establishment SQL fixture and its migration evidence.
    Run Initialize-EstablishmentDatabase first.
    .PARAMETER SeedFile
    Establishment seed files to load, by name in seed/ or by full path.
    #>
    param(
        [Parameter(Mandatory)]$Target,
        [string[]]$SeedFile = @($script:EstablishmentSeedFile)
    )

    foreach ($file in $SeedFile) {
        $path = $file
        if (-not [System.IO.Path]::IsPathRooted($file)) { $path = Get-SchemaPath "seed/$file" }
        Write-Step "Loading checked-in establishment fixture: $([System.IO.Path]::GetFileName($path))"
        # Council links and maintenance rows in an export may be ordered
        # independently by pg_dump. Check their final state at commit.
        Invoke-Psql -Target $Target -File $path -SingleTransaction -FailureMessage "Seed failed: $path"
    }

    Write-Step 'Loading checked-in migration evidence'
    Invoke-Psql -Target $Target -File (Get-SchemaPath "seed/$script:MigrationSeedFile") -FailureMessage 'Migration evidence seed failed'
    Import-LocalAuthorityCouncilFixture -Target $Target
    Import-ProprietorReviewQueue -Target $Target
    $maintenanceWorkspace = New-RunWorkspace
    try {
        # The stored observation set can cover more URNs than the current seed.
        # Keep this replay within the actual target selection and require coverage.
        $targetUrns = (Invoke-Psql -Target $Target -Command 'SELECT urn FROM establishment.establishment ORDER BY urn' `
            -Output Scalar -FailureMessage 'Cannot read checked-in maintenance scope') -split '\s+'
        $maintenanceRows = @(Import-Csv -LiteralPath (Get-SchemaPath 'seed/fixtures/maintenance-source-observations.csv') -Delimiter '|' |
            Where-Object { $_.urn -in $targetUrns })
        if ($maintenanceRows.Count -ne $targetUrns.Count -or
            @($maintenanceRows.urn | Select-Object -Unique).Count -ne $targetUrns.Count) {
            throw 'Checked-in maintenance observations must cover each selected establishment exactly once.'
        }
        $maintenanceCsv = Join-Path $maintenanceWorkspace 'selected-maintenance-source-observations.csv'
        $maintenanceLines = @(Get-Content -LiteralPath (Get-SchemaPath 'seed/fixtures/maintenance-source-observations.csv'))
        $selectedLines = @($maintenanceLines[0]) + @($maintenanceLines | Select-Object -Skip 1 |
            Where-Object { ($_ -split '\|',2)[0] -in $targetUrns })
        [System.IO.File]::WriteAllLines($maintenanceCsv, [string[]]$selectedLines, [System.Text.UTF8Encoding]::new($false))
        Import-MaintenanceObservationFixture -Target $Target -CsvPath $maintenanceCsv `
            -SourceDatabase 'gias_bau_test_local' -WorkingDirectory $maintenanceWorkspace
    } finally { Remove-RunWorkspace -Path $maintenanceWorkspace }
}

function Export-EstablishmentFixture {
    <#
    .SYNOPSIS
    Exports the reference data, establishment data and migration evidence from
    the local database as SQL files, with pg_dump.
    #>
    param(
        [Parameter(Mandatory)]$Target,
        [Parameter(Mandatory)][string]$OutputDirectory
    )

    New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null
    $common = @('--data-only', '--column-inserts', '--rows-per-insert=1000', '--no-owner', '--no-privileges', '--no-comments')

    $exports = @(
        @{ File = $script:ReferenceSeedFile;     Schema = 'establishment'; Tables = $script:ReferenceSeedTables;     Label = 'reference data' }
        @{ File = $script:EstablishmentSeedFile; Schema = 'establishment'; Tables = $script:EstablishmentSeedTables; Label = 'establishment data' }
        @{ File = $script:MigrationSeedFile;     Schema = 'migration';     Tables = $script:MigrationSeedTables;     Label = 'migration evidence' }
    )
    foreach ($export in $exports) {
        Write-Step "Exporting $($export.Label) to $($export.File)"
        $arguments = $common + @('--file', (Join-Path $OutputDirectory $export.File))
        foreach ($table in $export.Tables) { $arguments += @('--table', "$($export.Schema).$table") }
        Invoke-PgDump -Target $Target -Arguments $arguments -FailureMessage "Export of $($export.Label) failed"
    }
}

function Update-CheckedInSeed {
    <#
    .SYNOPSIS
    Copies exported reference, establishment and migration evidence SQL into
    seed/ as one consistent fixture. Review the change with git diff before committing.
    #>
    param([Parameter(Mandatory)][string]$FromDirectory)

    $seedRoot = Get-SchemaPath 'seed'
    foreach ($file in @($script:ReferenceSeedFile, $script:EstablishmentSeedFile, $script:MigrationSeedFile)) {
        Copy-Item -LiteralPath (Join-Path $FromDirectory $file) -Destination (Join-Path $seedRoot $file) -Force
    }
}
