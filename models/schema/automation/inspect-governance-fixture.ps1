<#
.SYNOPSIS
Reports how many governance appointments the local BAU copy holds for the given
establishments, and their role codes.

.DESCRIPTION
Read-only. Reads only dbo.StaffRecord and dbo.StaffRole in gias_bau_test_local,
and returns counts and role labels, never names or other personal data.
#>
[CmdletBinding()]
param(
    [string]$SqlServer = 'localhost',
    [string]$SourceDatabase = 'gias_bau_test_local',
    [string]$SqlUser = 'reader',
    [switch]$UseWindowsAuthentication,
    [int[]]$Urn = @(136102)
)

$ErrorActionPreference = 'Stop'
Import-Module (Join-Path (Join-Path $PSScriptRoot 'EprLocalAutomation') 'EprLocalAutomation.psm1') -Force

$source = New-BauSource -SqlServer $SqlServer -Database $SourceDatabase -SqlUser $SqlUser -UseWindowsAuthentication:$UseWindowsAuthentication
Get-GovernanceSourceCoverage -Source $source -Urn $Urn
