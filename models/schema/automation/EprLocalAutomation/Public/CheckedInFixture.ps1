# The checked-in SQL fixtures in seed/: loading them without a BAU copy, and
# exporting a fresh set from a validated local database.

# Tables exported to each checked-in file. The order is the pg_dump selection;
# pg_dump itself writes rows in dependency order.
$script:ReferenceSeedTables = @(
    'local_authority_jurisdiction', 'establishment_type', 'education_phase',
    'gender_of_entry_type', 'admissions_policy', 'boarding_provision',
    'nursery_provision', 'sixth_form_provision', 'specialist_provision_type',
    'establishment_status', 'reason_establishment_opened',
    'reason_establishment_closed', 'local_authority', 'government_office_region',
    'gss_local_authority_code', 'district_administrative', 'administrative_ward',
    'parliamentary_constituency', 'lsoa', 'msoa', 'urban_rural',
    'local_authority_contact', 'local_authority_government_office_region'
)
$script:EstablishmentSeedTables = @(
    'establishment', 'establishment_geography', 'establishment_contact',
    'establishment_lifecycle', 'address', 'site', 'establishment_to_site',
    'capacity_and_pupil_measures', 'education_admissions_and_provision',
    'statutory_age_range', 'specialist_provision', 'resourced_provision',
    'sen_unit_provision', 'legal_entity', 'organisation_identifier',
    'establishment_party_role', 'academy_trust_classification',
    'establishment_responsibility', 'organisation_group',
    'organisation_group_member', 'group_identifier'
)
$script:MigrationSeedTables = @(
    'migration_run', 'source_snapshot', 'source_record',
    'establishment_party_role_evidence', 'establishment_responsibility_evidence',
    'academy_trust_classification_evidence', 'organisation_group_member_evidence',
    'identity_resolution'
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
        Invoke-Psql -Target $Target -File $path -FailureMessage "Seed failed: $path"
    }

    Write-Step 'Loading checked-in migration evidence'
    Invoke-Psql -Target $Target -File (Get-SchemaPath "seed/$script:MigrationSeedFile") -FailureMessage 'Migration evidence seed failed'
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
