<#
.SYNOPSIS
Rebuilds establishment_local from the checked-in SQL fixtures and tests it. No
SQL Server or BAU copy is needed.

.DESCRIPTION
Steps:
  1. Recreate the establishment and migration schemas and load reference seeds.
  2. Load the checked-in establishment fixture and migration evidence.
  3. Run all establishment tests.

To run one step on its own, import EprLocalAutomation and call that step's
function (see README.md).
#>
[CmdletBinding()]
param(
    [string]$PostgresHost = '127.0.0.1',
    [int]$PostgresPort = 5432,
    [string]$PostgresDatabase = 'establishment_local',
    [string]$PostgresUser = 'postgres',
    [string]$PostgresPassword = $env:PGPASSWORD,
    # The checked-in establishment fixture, holding every selected establishment.
    [string[]]$SeedFile = @('seed-establishment-fixture.sql')
)

$ErrorActionPreference = 'Stop'
Import-Module (Join-Path (Join-Path $PSScriptRoot 'EprLocalAutomation') 'EprLocalAutomation.psm1') -Force

$target = New-PostgresTarget -PostgresHost $PostgresHost -Port $PostgresPort -Database $PostgresDatabase -User $PostgresUser -Password $PostgresPassword
$selection = Get-FixtureSelection

Initialize-EstablishmentDatabase -Target $target
Import-CheckedInEstablishmentFixture -Target $target -SeedFile $SeedFile
Invoke-EstablishmentTests -Target $target -Selection $selection

Write-Host 'Establishment schema rebuilt from checked-in SQL and tested.' -ForegroundColor Green
