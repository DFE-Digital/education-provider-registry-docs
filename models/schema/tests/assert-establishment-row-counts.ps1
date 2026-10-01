<#
.SYNOPSIS
Checks that the database holds exactly the establishments in the fixture
selection (seed/fixture-selection.json).
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
$modulePath = Join-Path (Join-Path (Join-Path (Split-Path -Parent $PSScriptRoot) 'automation') 'EprLocalAutomation') 'EprLocalAutomation.psm1'
Import-Module $modulePath -Force

$target = New-PostgresTarget -PostgresHost $PostgresHost -Port $PostgresPort -Database $PostgresDatabase -User $PostgresUser -Password $PostgresPassword
Test-EstablishmentScope -Target $target -ExpectedUrn (Get-FixtureSelection).Urns
