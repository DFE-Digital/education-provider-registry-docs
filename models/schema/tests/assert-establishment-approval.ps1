<#
.SYNOPSIS
Compares the loaded record for one establishment with its approved snapshot in
tests/approval, or updates the snapshot with -UpdateApproval.
#>
[CmdletBinding()]
param(
    [ValidateRange(1, 999999)][int]$Urn = 136102,
    [string]$PostgresHost = '127.0.0.1',
    [int]$PostgresPort = 5432,
    [string]$PostgresDatabase = 'establishment_local',
    [string]$PostgresUser = 'postgres',
    [string]$PostgresPassword = $env:PGPASSWORD,
    [switch]$UpdateApproval
)

$ErrorActionPreference = 'Stop'
$modulePath = Join-Path (Join-Path (Join-Path (Split-Path -Parent $PSScriptRoot) 'automation') 'EprLocalAutomation') 'EprLocalAutomation.psm1'
Import-Module $modulePath -Force

$target = New-PostgresTarget -PostgresHost $PostgresHost -Port $PostgresPort -Database $PostgresDatabase -User $PostgresUser -Password $PostgresPassword
Test-EstablishmentApproval -Target $target -Urn $Urn -UpdateApproval:$UpdateApproval
