<#
.SYNOPSIS
Adds SEN to the existing local target without rebuilding other model slices.
The current target URNs are read automatically. A full pre-migration database
backup and the extracted source fixtures remain in the reported working folder.
#>
[CmdletBinding()]
param(
    [string]$SqlServer='localhost',
    [string]$SourceDatabase='gias_bau_test_local',
    [switch]$UseWindowsAuthentication,
    [string]$PostgresHost='127.0.0.1',
    [string]$PostgresDatabase='establishment_local',
    [string]$FixtureDirectory=[System.IO.Path]::GetTempPath()
)
$ErrorActionPreference='Stop'
Import-Module (Join-Path $PSScriptRoot 'EprLocalAutomation/EprLocalAutomation.psm1') -Force
$source=New-BauSource -SqlServer $SqlServer -Database $SourceDatabase -UseWindowsAuthentication:$UseWindowsAuthentication
$target=New-PostgresTarget -PostgresHost $PostgresHost -Database $PostgresDatabase
$workspace=New-RunWorkspace -ParentDirectory $FixtureDirectory
try {
    Update-EstablishmentSenFromBau -Source $source -Target $target -WorkingDirectory $workspace
    Test-SenMigration -Target $target
} finally { Write-Host "Migration working files retained: $workspace" }
