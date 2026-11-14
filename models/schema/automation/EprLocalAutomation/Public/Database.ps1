# Building the local databases: schemas and reference seed data.

function Assert-EstablishmentBuildInputs {
    # Resolve and check every requested input before any destructive reset.
    param([switch]$IncludeReferenceSeed, [string[]]$FixtureSeedFile = @(),[switch]$EstablishmentsOnly)

    $paths = @(
        (Get-SchemaPath 'establishment/establishment-schema.sql'),
        (Get-SchemaPath 'establishment/sen-schema.sql'),
        (Get-SchemaPath 'establishment/transforms/reference-data-from-bau.sql'),
        (Get-SchemaPath 'establishment/load/load-reference-data-fixture.sql'),
        (Get-SchemaPath 'seed/seed-target-reference-data.sql'),
        (Get-SchemaPath 'seed/seed-academy-trust-reference-data.sql'),
        (Get-SchemaPath 'seed/seed-address-purposes.sql'),
        (Get-SchemaPath 'migration/migration-schema.sql'),
        (Get-SchemaPath 'migration/load-development-establishment-seed.sql'),
        (Get-SchemaPath 'migration/load-development-party-relationships.sql'),
        (Get-SchemaPath 'migration/load-development-maintenance-observations.sql'),
        (Get-SchemaPath 'migration/maintenance-derivation.sql'),
        (Get-SchemaPath 'migration/proprietor-extensions.sql'),
        (Get-SchemaPath 'migration/council-reorganisation.sql'),
        (Get-SchemaPath 'migration/group-address-evidence-schema.sql')
    )
    if (-not $EstablishmentsOnly) {
        $paths+=@((Get-SchemaPath 'seed/seed-stage-4-proprietor-review.sql'),
            (Get-SchemaPath 'establishment/load/load-maintenance-responsibility-fixture.sql'),
            (Get-SchemaPath 'establishment/transforms/maintenance-responsibility-from-bau.sql'))
    }
    if ($IncludeReferenceSeed) {
        $paths += @(
            (Get-SchemaPath 'seed/seed-reference-data.sql'),
            (Get-SchemaPath 'seed/seed-sen-reference-data.sql')
        )
    }
    if ($FixtureSeedFile.Count -gt 0) {
        foreach ($file in $FixtureSeedFile) {
            $paths += if ([System.IO.Path]::IsPathRooted($file)) { $file } else { Get-SchemaPath "seed/$file" }
        }
        $paths += Get-SchemaPath 'seed/seed-migration-evidence.sql'
        $paths += Get-SchemaPath 'seed/fixtures/maintenance-source-observations.csv'
    }
    Assert-FileExists -Path $paths
    if (-not $EstablishmentsOnly) { Assert-LocalAuthorityCouncilSeed }
}

function Reset-EstablishmentSchema {
    <#
    .SYNOPSIS
    Drops and recreates the establishment and migration schemas. All data in
    them is lost.
    #>
    param([Parameter(Mandatory)]$Target,
          [switch]$IncludeReferenceSeed, [string[]]$FixtureSeedFile = @(),[switch]$EstablishmentsOnly)

    Assert-EstablishmentBuildInputs -IncludeReferenceSeed:$IncludeReferenceSeed -FixtureSeedFile $FixtureSeedFile -EstablishmentsOnly:$EstablishmentsOnly
    if (-not $EstablishmentsOnly) { Assert-CouncilEventResetAllowed -Target $Target }
    Write-Step 'Recreating the establishment schema'
    Invoke-Psql -Target $Target -Command 'DROP SCHEMA IF EXISTS establishment CASCADE;' -FailureMessage 'Establishment schema reset failed'
    Invoke-Psql -Target $Target -File (Get-SchemaPath 'establishment/establishment-schema.sql') -FailureMessage 'Establishment schema creation failed'

    Write-Step 'Recreating the migration schema'
    Invoke-Psql -Target $Target -File (Get-SchemaPath 'migration/migration-schema.sql') -FailureMessage 'Migration schema rebuild failed'
}

function Import-ReferenceSeed {
    <#
    .SYNOPSIS
    Loads the checked-in reference data: the shared reference seed and the
    academy-trust controlled values.
    #>
    param([Parameter(Mandatory)]$Target,[switch]$TargetOwnedOnly)

    if ($TargetOwnedOnly) {
        Write-Step 'Loading target-owned reference values'
        Invoke-Psql -Target $Target -File (Get-SchemaPath 'seed/seed-target-reference-data.sql') -FailureMessage 'Target-owned reference seed failed'
    } else {
        Write-Step 'Loading the checked-in reference seed'
        Invoke-Psql -Target $Target -File (Get-SchemaPath 'seed/seed-reference-data.sql') -FailureMessage 'Reference-data seed failed'
        Invoke-Psql -Target $Target -File (Get-SchemaPath 'seed/seed-sen-reference-data.sql') -FailureMessage 'SEN reference-data seed failed'
    }

    Write-Step 'Loading the academy-trust reference seed'
    Invoke-Psql -Target $Target -File (Get-SchemaPath 'seed/seed-academy-trust-reference-data.sql') -FailureMessage 'Academy-trust reference-data seed failed'
    Invoke-Psql -Target $Target -File (Get-SchemaPath 'seed/seed-address-purposes.sql') -FailureMessage 'Address-purpose seed failed'
    Invoke-Psql -Target $Target -File (Get-SchemaPath 'migration/sync-reference-sequences.sql') -FailureMessage 'Reference sequence synchronisation failed'
}

function Initialize-EstablishmentDatabase {
    <#
    .SYNOPSIS
    Recreates the establishment and migration schemas and loads reference data,
    ready for establishment data to be loaded.
    #>
    param([Parameter(Mandatory)]$Target,[switch]$FromBau,
          [string[]]$FixtureSeedFile = @(),[switch]$EstablishmentsOnly)

    Reset-EstablishmentSchema -Target $Target -IncludeReferenceSeed:(-not $FromBau) -FixtureSeedFile $FixtureSeedFile -EstablishmentsOnly:$EstablishmentsOnly
    Import-ReferenceSeed -Target $Target -TargetOwnedOnly:$FromBau
}
