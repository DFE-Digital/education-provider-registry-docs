<#
.SYNOPSIS
Runs the independent Establishment and/or Governance local development seeds.
.DESCRIPTION
Choose -Establishment, -Governance, or both. Establishment runs first when both
are selected. Each domain owns its schema, SQL and transaction boundaries.
#>
[CmdletBinding()]
param(
    [switch]$Establishment,
    [switch]$Governance,
    [string]$SqlServer = 'localhost',
    [string]$SourceDatabase = 'gias_bau_test_local',
    [string]$SqlUser = 'reader',
    [securestring]$SqlPassword,
    [switch]$UseWindowsAuthentication,
    [string]$PostgresHost = '127.0.0.1',
    [string]$PostgresUser = 'postgres',
    [ValidateRange(1,65535)][int]$EstablishmentPort = 5433,
    [ValidateSet('establishment_local','epr_establishment','establishment')][string]$EstablishmentDatabase = 'epr_establishment',
    [string]$EstablishmentPassword = $env:PGPASSWORD,
    [ValidateRange(1,65535)][int]$GovernancePort = 5434,
    [ValidateSet('governance_local','epr_governance','governance')][string]$GovernanceDatabase = 'epr_governance',
    [string]$GovernancePassword = $env:PGPASSWORD,
    [ValidateRange(1,999999)][int]$Urn,
    [string]$FixtureDirectory = [IO.Path]::GetTempPath(),
    [switch]$KeepFixture
)
$ErrorActionPreference = 'Stop'
if (-not $Establishment -and -not $Governance) {
    throw 'Choose -Establishment, -Governance, or both switches.'
}
Import-Module (Join-Path $PSScriptRoot 'EprLocalAutomation/EprLocalAutomation.psm1') -Force
# Resolve the shared source credential once. Domain scripts retain their own
# connection guards and can also be called independently.
$source = New-BauSource -SqlServer $SqlServer -Database $SourceDatabase -SqlUser $SqlUser `
    -SqlPassword $SqlPassword -UseWindowsAuthentication:$UseWindowsAuthentication
$common = @{
    SqlServer=$SqlServer; SourceDatabase=$SourceDatabase; SqlUser=$SqlUser
    SqlPassword=$source.SqlPassword; UseWindowsAuthentication=$UseWindowsAuthentication
    PostgresHost=$PostgresHost; PostgresUser=$PostgresUser
    FixtureDirectory=$FixtureDirectory; KeepFixture=$KeepFixture
}
if ($PSBoundParameters.ContainsKey('Urn')) { $common.Urn = $Urn }

if ($Establishment) {
    Write-Host '==> Establishment migration'
    & (Join-Path $PSScriptRoot 'rebuild-establishment-from-local-bau.ps1') @common `
        -PostgresPort $EstablishmentPort -PostgresDatabase $EstablishmentDatabase -PostgresPassword $EstablishmentPassword
}

if ($Governance) {
    Write-Host '==> Governance migration'
    & (Join-Path $PSScriptRoot 'rebuild-governance-from-local-bau.ps1') @common `
        -PostgresPort $GovernancePort -PostgresDatabase $GovernanceDatabase -PostgresPassword $GovernancePassword
}
