<#
.SYNOPSIS
Exports the current establishment_local database as SQL fixtures: reference
data, establishment data and migration evidence.

.DESCRIPTION
Run after a successful BAU-source rebuild. The output can be replayed by
rebuild-establishment-from-checked-in-sql.ps1 without SQL Server. This script
only exports; it does not change the checked-in files in seed/.
#>
[CmdletBinding()]
param(
    [string]$PostgresHost = '127.0.0.1',
    [int]$PostgresPort = 5432,
    [string]$PostgresDatabase = 'establishment_local',
    [string]$PostgresUser = 'postgres',
    [string]$PostgresPassword = $env:PGPASSWORD,
    [Parameter(Mandatory)][string]$OutputDirectory
)

$ErrorActionPreference = 'Stop'
Import-Module (Join-Path (Join-Path $PSScriptRoot 'EprLocalAutomation') 'EprLocalAutomation.psm1') -Force

$target = New-PostgresTarget -PostgresHost $PostgresHost -Port $PostgresPort -Database $PostgresDatabase -User $PostgresUser -Password $PostgresPassword
Export-EstablishmentFixture -Target $target -OutputDirectory $OutputDirectory
Write-Host "Exported reference, establishment and migration SQL to $OutputDirectory"
