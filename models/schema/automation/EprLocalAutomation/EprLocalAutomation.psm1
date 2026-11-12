<#
.SYNOPSIS
Shared functions for rebuilding, loading, testing and exporting the local
Education Provider Registry databases.

.DESCRIPTION
Import this module to run any single step on its own, for example only the
tests. The entry-point scripts in the parent folder import it and run the steps
in order.

    Import-Module ./models/schema/automation/EprLocalAutomation/EprLocalAutomation.psm1
    $target = New-PostgresTarget
    Invoke-EstablishmentTests -Target $target -Selection (Get-FixtureSelection)

Private/ holds internal helpers. Public/ holds the exported functions, one file
per area. See ../README.md for the full list.
#>

$ErrorActionPreference = 'Stop'

# The schema folder (models/schema) is two levels above this module folder.
$script:SchemaRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)

foreach ($folder in @('Private', 'Public')) {
    $folderPath = Join-Path $PSScriptRoot $folder
    foreach ($file in (Get-ChildItem -LiteralPath $folderPath -Filter '*.ps1' | Sort-Object Name)) {
        . $file.FullName
    }
}

Export-ModuleMember -Function @(
    # Connections and run settings
    'New-BauSource'
    'New-PostgresTarget'
    'Get-FixtureSelection'
    'Test-CodeListsAgainstBau'
    'Find-EstablishmentGroupsFromBau'
    'New-RunWorkspace'
    'Remove-RunWorkspace'

    # Database build
    'Assert-EstablishmentBuildInputs'
    'Reset-EstablishmentSchema'
    'Import-ReferenceSeed'
    'Initialize-EstablishmentDatabase'
    'Initialize-GovernanceDatabase'

    # Loading from the local BAU copy
    'Import-GeographicReferenceData'
    'Export-BauReferenceData'
    'Import-BauReferenceData'
    'Import-SenReferenceData'
    'Import-EstablishmentSenFromBau'
    'Update-EstablishmentSenFromBau'
    'Import-LocalAuthorityCouncilFixture'
    'Import-MaintenanceFromBau'
    'Import-MaintenanceObservationFixture'
    'Import-ProprietorReviewQueue'
    'Import-EstablishmentFromBau'
    'Import-EstablishmentPartyRoleFromBau'
    'Import-OrganisationGroupFromBau'
    'Import-GovernanceFromBau'

    # Checked-in fixtures
    'Import-CheckedInEstablishmentFixture'
    'Export-EstablishmentFixture'
    'Update-CheckedInSeed'

    # Tests and reports
    'Test-EstablishmentUrnValidation'
    'Test-EstablishmentGroupDiscovery'
    'Test-EstablishmentCoreValidation'
    'Test-SenMigration'
    'Test-BauReferenceData'
    'Test-EstablishmentMigrationEvidence'
    'Test-EstablishmentApproval'
    'Test-EstablishmentScope'
    'Invoke-EstablishmentTests'
    'Show-EstablishmentSummary'
    'Show-GovernanceSummary'
    'Get-GovernanceSourceCoverage'
)
