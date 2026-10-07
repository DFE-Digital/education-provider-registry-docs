<#
.SYNOPSIS
Rebuilds establishment_local from a local BAU SQL Server copy. By default it
tests the repository selection and refreshes the checked-in SQL fixtures.

.DESCRIPTION
Steps:
  1. Discover groups for a URN-only selection, before changing the target.
     Recreate the establishment and migration schemas and load reference seeds.
  2. Load geographic reference data from BAU.
  3. Load each selected establishment, then each selected establishment-party link.
  4. Print a summary and run all establishment tests, unless -SkipTests is used.
  5. For the default tested selection, export and refresh the checked-in
     fixtures in seed/. Use -ExportDirectory for a separate export; custom
     selections and skipped-test runs otherwise leave seed/ unchanged.
  6. With -IncludeGovernance, also rebuild governance_local and load governance.

The selection defaults to seed/fixture-selection.json. Use -SelectionFile for
your own curated URNs and links, and -SkipTests when the checked-in tests do not
apply to your data. Custom selections and skipped-test runs never automatically
refresh seed/; use -ExportDirectory for a separate export if needed. SQL load
checks and database constraints still apply when tests are skipped.

Use -Urn for a comma-separated list, or a URN-only selection file, to discover
current groups automatically. Organisation memberships are restricted to the
supplied URNs. -IncludeArchivedLinks additionally discovers archived party links.

.EXAMPLE
.\rebuild-establishment-from-local-bau.ps1 -SqlServer localhost -UseWindowsAuthentication

.EXAMPLE
.\rebuild-establishment-from-local-bau.ps1 -SqlServer localhost -SelectionFile .\my-fixture-selection.json -SkipTests

.EXAMPLE
.\rebuild-establishment-from-local-bau.ps1 -SqlServer localhost -Urn '109443,20338' -SkipTests
#>
[CmdletBinding()]
param(
    [string]$SqlServer = 'localhost',
    [string]$SourceDatabase = 'gias_bau_test_local',
    [string]$SqlUser = 'reader',
    [switch]$UseWindowsAuthentication,
    [string]$SelectionFile,
    [ValidateNotNullOrEmpty()][Alias('Urns')][string[]]$Urn,
    [switch]$IncludeArchivedLinks,
    [switch]$SkipTests,
    [string]$PostgresHost = '127.0.0.1',
    [int]$PostgresPort = 5432,
    [string]$PostgresDatabase = 'establishment_local',
    [string]$PostgresUser = 'postgres',
    [string]$PostgresPassword = $env:PGPASSWORD,
    # Parent folder for this run's working files.
    [string]$FixtureDirectory = [System.IO.Path]::GetTempPath(),
    # Export here for review. Only the default tested selection automatically
    # exports to the run's working folder and refreshes seed/.
    [string]$ExportDirectory,
    [switch]$IncludeGovernance,
    [switch]$KeepFixture
)

$ErrorActionPreference = 'Stop'
Import-Module (Join-Path (Join-Path $PSScriptRoot 'EprLocalAutomation') 'EprLocalAutomation.psm1') -Force

if ($PSBoundParameters.ContainsKey('Urn') -and $SelectionFile) {
    throw 'Supply either -Urn or -SelectionFile, not both.'
}
if ($PSBoundParameters.ContainsKey('Urn')) {
    $requestedUrns = @($Urn | ForEach-Object {
        foreach ($urnPart in ($_ -split ',')) {
            if ($urnPart.Trim() -notmatch '^[0-9]+$') { throw 'Supply URNs as integers or a comma-separated list of integers.' }
            [int]$urnPart.Trim()
        }
    })
    $selection = Get-FixtureSelection -Urn $requestedUrns
}
elseif ($SelectionFile) {
    $selection = Get-FixtureSelection -Path $SelectionFile
}
else {
    $selection = Get-FixtureSelection
}
$defaultSelectionPath = [System.IO.Path]::GetFullPath((Join-Path (Split-Path -Parent $PSScriptRoot) 'seed/fixture-selection.json'))
$isCustomSelection = -not $selection.Path -or $selection.DiscoverGroups -or [System.IO.Path]::GetFullPath($selection.Path) -ne $defaultSelectionPath
if ($IncludeArchivedLinks -and -not $selection.DiscoverGroups) {
    throw '-IncludeArchivedLinks applies to URN-only discovery, not an explicit group-selection manifest.'
}
if ($SkipTests) {
    Write-Warning 'Establishment tests will be skipped. This run will not be approval-validated.'
}
$source = New-BauSource -SqlServer $SqlServer -Database $SourceDatabase -SqlUser $SqlUser -UseWindowsAuthentication:$UseWindowsAuthentication
$target = New-PostgresTarget -PostgresHost $PostgresHost -Port $PostgresPort -Database $PostgresDatabase -User $PostgresUser -Password $PostgresPassword
$workspace = New-RunWorkspace -ParentDirectory $FixtureDirectory
$migrationRunId = $null

function Invoke-PsqlForRebuild {
    param($Target, [string]$Command)
    & (Get-Module EprLocalAutomation) {
        param($runTarget, $runCommand)
        Invoke-Psql -Target $runTarget -Command $runCommand -Output Scalar -FailureMessage 'Migration run update failed'
    } $Target $Command
}

try {
    if ($selection.DiscoverGroups) {
        $selection = Find-EstablishmentGroupsFromBau -Source $source -Selection $selection `
            -WorkingDirectory $workspace -IncludeArchivedLinks:$IncludeArchivedLinks
    }
    Initialize-EstablishmentDatabase -Target $target
    $sourceDatabaseSql = $source.Database.Replace("'", "''")
    $runNotes = @()
    if ($SkipTests) { $runNotes += 'Establishment tests skipped with -SkipTests; this run is not approval-validated.' }
    if (@($selection.OrganisationGroups | Where-Object { $_.SelectedMembersOnly }).Count -gt 0) {
        $runNotes += 'Discovered organisation-group memberships cover supplied URNs only, not complete source groups.'
    }
    $testNotesSql = 'NULL'
    if ($runNotes.Count -gt 0) { $testNotesSql = "'" + ($runNotes -join ' ').Replace("'", "''") + "'" }
    $migrationRunId = [guid](Invoke-PsqlForRebuild -Target $target -Command "INSERT INTO migration.migration_run (run_type, source_system, source_database, source_snapshot_date, status, transform_version, notes) VALUES ('establishment-rebuild', 'GIAS BAU', '$sourceDatabaseSql', CURRENT_DATE, 'running', 'establishment-party-responsibility-v2', $testNotesSql) RETURNING migration_run_id;")
    Import-GeographicReferenceData -Source $source -Target $target -WorkingDirectory $workspace

    foreach ($selectedUrn in $selection.Urns) {
        Import-EstablishmentFromBau -Source $source -Target $target -Urn $selectedUrn -WorkingDirectory $workspace
    }
    foreach ($link in $selection.PartyRoleLinks) {
        Import-EstablishmentPartyRoleFromBau -Source $source -Target $target -Urn $link.Urn `
            -SourceGroupId $link.SourceGroupId -IncludeArchived:$link.IncludeArchived -WorkingDirectory $workspace -MigrationRunId $migrationRunId
    }

    foreach ($group in $selection.OrganisationGroups) {
        Import-OrganisationGroupFromBau -Source $source -Target $target -SourceGroupId $group.SourceGroupId `
            -ExpectedMemberUrns $group.MemberUrns -SelectedMembersOnly:([bool]$group.SelectedMembersOnly) `
            -WorkingDirectory $workspace -MigrationRunId $migrationRunId
    }

    foreach ($proprietor in $selection.ControlledProprietors) {
        Import-ControlledProprietorFromBau -Source $source -Target $target -Fixture $proprietor `
            -WorkingDirectory $workspace -MigrationRunId $migrationRunId
    }

    Show-EstablishmentSummary -Target $target -Urn $selection.Urns
    if (-not $SkipTests) {
        Invoke-EstablishmentTests -Target $target -Selection $selection
    }
    $null = Invoke-PsqlForRebuild -Target $target -Command "UPDATE migration.migration_run SET status = 'completed', completed_at = now() WHERE migration_run_id = '$migrationRunId';"

    if ($ExportDirectory) {
        Export-EstablishmentFixture -Target $target -OutputDirectory $ExportDirectory
    }
    elseif ($SkipTests -or $isCustomSelection) {
        Write-Host 'Checked-in seed files left unchanged. Use -ExportDirectory for a separate export.'
    }
    else {
        $exportDirectory = Join-Path $workspace 'export'
        Export-EstablishmentFixture -Target $target -OutputDirectory $exportDirectory
        Update-CheckedInSeed -FromDirectory $exportDirectory
    }

    if ($IncludeGovernance) {
        $governanceTarget = New-PostgresTarget -PostgresHost $PostgresHost -Port $PostgresPort -Database 'governance_local' -User $PostgresUser -Password $PostgresPassword
        Initialize-GovernanceDatabase -Target $governanceTarget
        foreach ($selectedUrn in $selection.Urns) {
            Import-GovernanceFromBau -Source $source -Target $governanceTarget -Urn $selectedUrn -WorkingDirectory $workspace
        }
        Show-GovernanceSummary -Target $governanceTarget -Urn $selection.Urns
    }

    Write-Host "BAU-source rebuild completed for URNs: $($selection.Urns -join ', ')." -ForegroundColor Green
    if ($SkipTests) { Write-Warning 'Data loaded, but establishment tests were not run.' }
}
catch {
    if ($migrationRunId) {
        try {
            $null = Invoke-PsqlForRebuild -Target $target -Command "UPDATE migration.migration_run SET status = 'failed', completed_at = now() WHERE migration_run_id = '$migrationRunId';"
        } catch { Write-Warning 'Could not record the failed migration run.' }
    }
    throw
}
finally {
    Remove-RunWorkspace -Path $workspace -Keep:$KeepFixture
}
