<#
.SYNOPSIS
Rebuilds establishment_local from the approved local BAU SQL Server copy, tests
it, and refreshes the checked-in SQL fixtures.

.DESCRIPTION
Steps:
  1. Recreate the establishment and migration schemas and load reference seeds.
  2. Load geographic reference data from BAU.
  3. Load each selected establishment, then each selected establishment-party link.
  4. Print a summary and run all establishment tests.
  5. Export the database and refresh the checked-in fixtures in seed/, unless
     -ExportDirectory sends the export somewhere else for review.
  6. With -IncludeGovernance, also rebuild governance_local and load governance.

The selection is read from seed/fixture-selection.json. To run one step on its
own, import EprLocalAutomation and call that step's function (see README.md).

.EXAMPLE
.\rebuild-establishment-from-local-bau.ps1 -SqlServer SL646104 -UseWindowsAuthentication
#>
[CmdletBinding()]
param(
    [string]$SqlServer = 'localhost',
    [string]$SourceDatabase = 'gias_bau_test_local',
    [string]$SqlUser = 'reader',
    [switch]$UseWindowsAuthentication,
    [string]$PostgresHost = '127.0.0.1',
    [int]$PostgresPort = 5432,
    [string]$PostgresDatabase = 'establishment_local',
    [string]$PostgresUser = 'postgres',
    [string]$PostgresPassword = $env:PGPASSWORD,
    # Parent folder for this run's working files.
    [string]$FixtureDirectory = [System.IO.Path]::GetTempPath(),
    # Export to this folder for review instead of refreshing seed/. By default the
    # export goes to the run's working folder and is copied into seed/.
    [string]$ExportDirectory,
    [switch]$IncludeGovernance,
    [switch]$KeepFixture
)

$ErrorActionPreference = 'Stop'
Import-Module (Join-Path (Join-Path $PSScriptRoot 'EprLocalAutomation') 'EprLocalAutomation.psm1') -Force

$source = New-BauSource -SqlServer $SqlServer -Database $SourceDatabase -SqlUser $SqlUser -UseWindowsAuthentication:$UseWindowsAuthentication
$target = New-PostgresTarget -PostgresHost $PostgresHost -Port $PostgresPort -Database $PostgresDatabase -User $PostgresUser -Password $PostgresPassword
$selection = Get-FixtureSelection
$workspace = New-RunWorkspace -ParentDirectory $FixtureDirectory

try {
    Initialize-EstablishmentDatabase -Target $target
    Import-GeographicReferenceData -Source $source -Target $target -WorkingDirectory $workspace

    foreach ($urn in $selection.Urns) {
        Import-EstablishmentFromBau -Source $source -Target $target -Urn $urn -WorkingDirectory $workspace
    }
    foreach ($link in $selection.PartyRoleLinks) {
        Import-EstablishmentPartyRoleFromBau -Source $source -Target $target -Urn $link.Urn `
            -SourceGroupId $link.SourceGroupId -IncludeArchived:$link.IncludeArchived -WorkingDirectory $workspace
    }

    Show-EstablishmentSummary -Target $target -Urn $selection.Urns
    Invoke-EstablishmentTests -Target $target -Selection $selection

    if ($ExportDirectory) {
        Export-EstablishmentFixture -Target $target -OutputDirectory $ExportDirectory
    }
    else {
        $exportDirectory = Join-Path $workspace 'export'
        Export-EstablishmentFixture -Target $target -OutputDirectory $exportDirectory
        Update-CheckedInSeed -FromDirectory $exportDirectory
    }

    if ($IncludeGovernance) {
        $governanceTarget = New-PostgresTarget -PostgresHost $PostgresHost -Port $PostgresPort -Database 'governance_local' -User $PostgresUser -Password $PostgresPassword
        Initialize-GovernanceDatabase -Target $governanceTarget
        foreach ($urn in $selection.Urns) {
            Import-GovernanceFromBau -Source $source -Target $governanceTarget -Urn $urn -WorkingDirectory $workspace
        }
        Show-GovernanceSummary -Target $governanceTarget -Urn $selection.Urns
    }

    Write-Host "BAU-source rebuild completed for URNs: $($selection.Urns -join ', ')." -ForegroundColor Green
}
finally {
    Remove-RunWorkspace -Path $workspace -Keep:$KeepFixture
}
