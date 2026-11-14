<#
.SYNOPSIS
Seeds the disposable local target with BAU establishments for development.
.DESCRIPTION
Imports Open, Closed and Open-but-proposed-to-close establishments and their
core geography, contact, lifecycle, site, measure and provision rows, followed
by lossy current party, maintenance and SEN relationships.
Failed batches are rolled back and split. Failed individual establishments
are skipped and recorded in migration.establishment_load_error.
It does not migrate governance. Relationship rows that do not fit the model are
logged and skipped; this is a development seed, not an identity migration.
#>
[CmdletBinding()]
param(
    [string]$SqlServer='localhost',
    [string]$SourceDatabase='gias_bau_test_local',
    [string]$SqlUser='reader',
    [switch]$UseWindowsAuthentication,
    [string]$SelectionFile,
    [ValidateNotNullOrEmpty()][Alias('Urns')][string[]]$Urn,
    [string]$PostgresHost='127.0.0.1',
    [int]$PostgresPort=5432,
    [string]$PostgresDatabase='establishment_local',
    [string]$PostgresUser='postgres',
    [string]$PostgresPassword=$env:PGPASSWORD,
    [ValidateRange(1,10000)][int]$BatchSize=1000,
    [string]$FixtureDirectory=[IO.Path]::GetTempPath(),
    [string]$ExportDirectory,
    [switch]$KeepFixture
)
$ErrorActionPreference='Stop'
Import-Module (Join-Path $PSScriptRoot 'EprLocalAutomation/EprLocalAutomation.psm1') -Force
if ($PSBoundParameters.ContainsKey('Urn') -and $SelectionFile) { throw 'Supply either -Urn or -SelectionFile, not both.' }
$requestedUrns=@()
if ($PSBoundParameters.ContainsKey('Urn')) {
    $requestedUrns=@($Urn | ForEach-Object {
        foreach ($part in ($_ -split ',')) {
            if ($part.Trim() -notmatch '^[0-9]+$') { throw 'Supply URNs as integers or a comma-separated list of integers.' }
            [int]$part.Trim()
        }
    })
    $requestedUrns=(Get-FixtureSelection -Urn $requestedUrns).Urns
} elseif ($SelectionFile) {
    $manifest=Get-Content -LiteralPath $SelectionFile -Raw | ConvertFrom-Json
    $requestedUrns=(Get-FixtureSelection -Urn @($manifest.urns)).Urns
}
$source=New-BauSource -SqlServer $SqlServer -Database $SourceDatabase -SqlUser $SqlUser -UseWindowsAuthentication:$UseWindowsAuthentication
$target=New-PostgresTarget -PostgresHost $PostgresHost -Port $PostgresPort -Database $PostgresDatabase -User $PostgresUser -Password $PostgresPassword
$workspace=New-RunWorkspace -ParentDirectory $FixtureDirectory
$migrationRunId=[guid]::Empty
try {
    $referenceCsv=Export-BauReferenceData -Source $source -WorkingDirectory $workspace
    Initialize-EstablishmentDatabase -Target $target -FromBau
    Import-BauReferenceData -Target $target -CsvPath $referenceCsv -SourceDatabase $source.Database -WorkingDirectory $workspace
    Import-GeographicReferenceData -Source $source -Target $target -WorkingDirectory $workspace
    $migrationRunId=Start-DevelopmentSeedRun -Source $source -Target $target
    $result=Import-DevelopmentEstablishmentSeed -Source $source -Target $target -WorkingDirectory $workspace -Urn $requestedUrns -BatchSize $BatchSize -MigrationRunId $migrationRunId
    Import-DevelopmentRelationships -Source $source -Target $target -WorkingDirectory $workspace -MigrationRunId $migrationRunId
    Complete-DevelopmentSeedRun -Target $target -MigrationRunId $migrationRunId
    Write-Host "Development seed completed: $($result.source_candidates) source candidates, $($result.known_bad_excluded) cached exclusions, $($result.loaded) loaded, $($result.skipped) new rejections, $($result.attempted) attempted."
    Write-Host 'Skipped establishments: SELECT urn, sqlstate, error_message FROM migration.establishment_load_error ORDER BY urn;'
    if ($ExportDirectory) { Export-EstablishmentFixture -Target $target -OutputDirectory $ExportDirectory }
} catch {
    if ($migrationRunId -ne [guid]::Empty) {
        try {Complete-DevelopmentSeedRun -Target $target -MigrationRunId $migrationRunId -Failed}
        catch {Write-Warning 'Could not record migration failure status.'}
    }
    throw
} finally {
    Remove-RunWorkspace -Path $workspace -Keep:$KeepFixture
}
