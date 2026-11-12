<#
.SYNOPSIS
Applies the one-time reference-key, unbounded-identity and column-order migrations.
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
Import-Module (Join-Path $PSScriptRoot 'EprLocalAutomation/EprLocalAutomation.psm1') -Force
$target = New-PostgresTarget -PostgresHost $PostgresHost -Port $PostgresPort -Database $PostgresDatabase -User $PostgresUser -Password $PostgresPassword

& (Get-Module EprLocalAutomation) {
    param($target)
    Invoke-Psql -Target $target -File (Get-SchemaPath 'migration/upgrade-code-list-identities.sql') -FailureMessage 'Initial code-list identity migration failed'
    Invoke-Psql -Target $target -File (Get-SchemaPath 'migration/realign-reference-and-unbounded-identities.sql') -FailureMessage 'Reference-key and identity migration failed'
    Invoke-Psql -Target $target -File (Get-SchemaPath 'migration/reorder-identity-columns.sql') -FailureMessage 'Identity-column ordering migration failed'
} $target

Write-Host 'Reference-key and identity migration completed.' -ForegroundColor Green
