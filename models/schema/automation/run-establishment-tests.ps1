<#
.SYNOPSIS
Runs every establishment test against the current establishment_local database,
without rebuilding or loading anything.

.DESCRIPTION
Runs URN boundary tests, core validation, establishment-groups validation, one approval snapshot
per selected URN, and the scope test. To run a single test, import
EprLocalAutomation and call it directly, for example Test-EstablishmentApproval.
#>
[CmdletBinding()]
param(
    [string]$PostgresHost = '127.0.0.1',
    [int]$PostgresPort = 5432,
    [string]$PostgresDatabase = 'establishment_local',
    [string]$PostgresUser = 'postgres',
    [string]$PostgresPassword = $env:PGPASSWORD
)

$ErrorActionPreference = 'Stop'
Import-Module (Join-Path (Join-Path $PSScriptRoot 'EprLocalAutomation') 'EprLocalAutomation.psm1') -Force

$target = New-PostgresTarget -PostgresHost $PostgresHost -Port $PostgresPort -Database $PostgresDatabase -User $PostgresUser -Password $PostgresPassword
Invoke-EstablishmentTests -Target $target -Selection (Get-FixtureSelection)
