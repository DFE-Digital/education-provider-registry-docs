# Building the local databases: schemas and reference seed data.

function Assert-EstablishmentBuildInputs {
    # Resolve and check every requested input before any destructive reset.
    param([switch]$IncludeReferenceSeed, [string[]]$FixtureSeedFile = @())

    $paths = @(
        (Get-SchemaPath 'establishment/establishment-schema.sql'),
        (Get-SchemaPath 'migration/migration-schema.sql'),
        (Get-SchemaPath 'migration/group-address-evidence-schema.sql')
    )
    if ($IncludeReferenceSeed) {
        $paths += @(
            (Get-SchemaPath 'seed/seed-reference-data.sql'),
            (Get-SchemaPath 'seed/seed-academy-trust-reference-data.sql'),
            (Get-SchemaPath 'seed/seed-address-purposes.sql')
        )
    }
    if ($FixtureSeedFile.Count -gt 0) {
        foreach ($file in $FixtureSeedFile) {
            $paths += if ([System.IO.Path]::IsPathRooted($file)) { $file } else { Get-SchemaPath "seed/$file" }
        }
        $paths += Get-SchemaPath 'seed/seed-migration-evidence.sql'
    }
    Assert-FileExists -Path $paths
}

function Reset-EstablishmentSchema {
    <#
    .SYNOPSIS
    Drops and recreates the establishment and migration schemas. All data in
    them is lost.
    #>
    param([Parameter(Mandatory)]$Target)

    Assert-EstablishmentBuildInputs
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
    param([Parameter(Mandatory)]$Target)

    Write-Step 'Loading the checked-in reference seed'
    Invoke-Psql -Target $Target -File (Get-SchemaPath 'seed/seed-reference-data.sql') -FailureMessage 'Reference-data seed failed'

    Write-Step 'Loading the academy-trust reference seed'
    Invoke-Psql -Target $Target -File (Get-SchemaPath 'seed/seed-academy-trust-reference-data.sql') -FailureMessage 'Academy-trust reference-data seed failed'
    Invoke-Psql -Target $Target -File (Get-SchemaPath 'seed/seed-address-purposes.sql') -FailureMessage 'Address-purpose seed failed'
}

function Initialize-EstablishmentDatabase {
    <#
    .SYNOPSIS
    Recreates the establishment and migration schemas and loads reference data,
    ready for establishment data to be loaded.
    #>
    param([Parameter(Mandatory)]$Target)

    Assert-EstablishmentBuildInputs -IncludeReferenceSeed
    Reset-EstablishmentSchema -Target $Target
    Import-ReferenceSeed -Target $Target
}

function Initialize-GovernanceDatabase {
    <#
    .SYNOPSIS
    Drops and recreates the governance schema in governance_local.
    #>
    param([Parameter(Mandatory)]$Target)

    if ($Target.Database -ne 'governance_local') {
        throw "The governance schema must be built in governance_local. Received: $($Target.Database)"
    }
    Write-Step 'Recreating the governance schema'
    Invoke-Psql -Target $Target -File (Get-SchemaPath 'governance/governance-schema.sql') -FailureMessage 'Governance schema rebuild failed'
}
