<#
.SYNOPSIS
Upgrades the five reviewed code lists in the existing local PostgreSQL target
and checks their published codes and labels against the local BAU dictionaries.
#>
[CmdletBinding()]
param(
    [string]$SqlServer = 'localhost',
    [string]$SourceDatabase = 'gias_bau_test_local',
    [string]$SqlUser = 'reader',
    [switch]$UseWindowsAuthentication,
    [string]$PostgresHost = '127.0.0.1',
    [int]$PostgresPort = 5432,
    [string]$PostgresDatabase = 'establishment_local',
    [string]$PostgresUser = 'postgres',
    [string]$PostgresPassword = $env:PGPASSWORD
)
$ErrorActionPreference = 'Stop'
Import-Module (Join-Path $PSScriptRoot 'EprLocalAutomation/EprLocalAutomation.psm1') -Force
$source = New-BauSource -SqlServer $SqlServer -Database $SourceDatabase -SqlUser $SqlUser -UseWindowsAuthentication:$UseWindowsAuthentication
$target = New-PostgresTarget -PostgresHost $PostgresHost -Port $PostgresPort -Database $PostgresDatabase -User $PostgresUser -Password $PostgresPassword
& (Get-Module EprLocalAutomation) {
    param($target)
    Invoke-Psql -Target $target -File (Get-SchemaPath 'migration/upgrade-code-list-identities.sql') -FailureMessage 'Code-list upgrade failed'
    Invoke-Psql -Target $target -File (Get-SchemaPath 'migration/validate-scripts/validate-code-list-identities.sql') -FailureMessage 'Code-list constraints failed'
} $target
Test-CodeListsAgainstBau -Source $source -Target $target
Write-Host 'Code-list UUID migration and exact BAU code reconciliation passed.' -ForegroundColor Green
