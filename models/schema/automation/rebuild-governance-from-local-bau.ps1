<#
.SYNOPSIS
Rebuilds the disposable local Governance database from BAU appointments.
.DESCRIPTION
Loads role types, appointments, optional terms and Chair assignments.
The schema reset and load commit together; invalid data rolls both back.
Person and contact data are not extracted. This is a development seed.
#>
[CmdletBinding()]
param(
    [string]$SqlServer = 'localhost',
    [string]$SourceDatabase = 'gias_bau_test_local',
    [string]$SqlUser = 'reader',
    [securestring]$SqlPassword,
    [switch]$UseWindowsAuthentication,
    [ValidateRange(1,999999)][int]$Urn,
    [string]$PostgresHost = '127.0.0.1',
    [ValidateRange(1,65535)][int]$PostgresPort = 5434,
    [ValidateSet('governance_local','epr_governance','governance')][string]$PostgresDatabase = 'epr_governance',
    [string]$PostgresUser = 'postgres',
    [string]$PostgresPassword = $env:PGPASSWORD,
    [string]$FixtureDirectory = [IO.Path]::GetTempPath(),
    [switch]$KeepFixture
)
$ErrorActionPreference = 'Stop'
Import-Module (Join-Path $PSScriptRoot 'EprLocalAutomation/EprLocalAutomation.psm1') -Force
$target = New-PostgresTarget -PostgresHost $PostgresHost -Port $PostgresPort -Database $PostgresDatabase -User $PostgresUser -Password $PostgresPassword
$source = New-BauSource -SqlServer $SqlServer -Database $SourceDatabase -SqlUser $SqlUser -SqlPassword $SqlPassword -UseWindowsAuthentication:$UseWindowsAuthentication
$workspace = New-RunWorkspace -ParentDirectory $FixtureDirectory
$retainWorkspace = [bool]$KeepFixture
try {
    $seedArguments = @{ Source=$source; Target=$target; WorkingDirectory=$workspace }
    if ($PSBoundParameters.ContainsKey('Urn')) { $seedArguments.Urn = $Urn }
    Import-BauGovernanceSeed @seedArguments
} catch {
    $retainWorkspace = $true
    throw
} finally {
    Remove-RunWorkspace -Path $workspace -Keep:$retainWorkspace
}
