<#[CmdletBinding()]
Validates the complete target Establishment slice for one URN against its
checked-in approval snapshot.
#>
[CmdletBinding()]
param(
    [int]$Urn = 136102,
    [string]$PostgresHost = '127.0.0.1',
    [int]$PostgresPort = 5432,
    [string]$PostgresDatabase = 'establishment_local',
    [string]$PostgresUser = 'postgres',
    [string]$PostgresPassword = $env:PGPASSWORD,
    [switch]$UpdateApproval
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot '..\automation\common\local-database-guards.ps1')
. (Join-Path $PSScriptRoot '..\automation\common\sql-client-functions.ps1')
Assert-LocalPostgresTarget -PostgresHost $PostgresHost -PostgresDatabase $PostgresDatabase
if ($Urn -lt 100000 -or $Urn -gt 999999) { throw "URN must be a six-digit value: $Urn" }

$query = Join-Path $PSScriptRoot '..\establishment\transforms\select-establishment-by-urn.sql'
$approval = Join-Path $PSScriptRoot "approval\establishment-$Urn.approved.json"
if (-not (Test-Path -LiteralPath $query -PathType Leaf)) { throw "Query not found: $query" }
if (-not $UpdateApproval -and -not (Test-Path -LiteralPath $approval -PathType Leaf)) { throw "Approval file not found: $approval" }

$psql = Get-LocalPostgresClientPath
$oldPassword = $env:PGPASSWORD
if ($PostgresPassword) { $env:PGPASSWORD = $PostgresPassword }
try {
    $actual = (& $psql -X -q -P format=csv -h $PostgresHost -p $PostgresPort -U $PostgresUser -d $PostgresDatabase -w -v ON_ERROR_STOP=1 -v "urn=$Urn" -f $query | Out-String).Trim()
    if ($LASTEXITCODE -ne 0) { throw "Establishment approval query failed with exit code $LASTEXITCODE" }
    if ($UpdateApproval) {
        Set-Content -LiteralPath $approval -Value $actual -Encoding utf8
        Write-Host "Updated approval snapshot: $approval"
        return
    }
    $expected = (Get-Content -LiteralPath $approval -Raw).Trim()
    if ($actual -cne $expected) {
        Write-Host "$([char]::ConvertFromUtf32(0x1F926)) Establishment approval test failed for URN $Urn." -ForegroundColor Red
        Write-Host 'Expected approval:'
        Write-Host $expected
        Write-Host 'Actual result:'
        Write-Host $actual
        throw "Establishment approval test failed for URN $Urn."
    }
    Write-Host "$([char]::ConvertFromUtf32(0x1F642)) Establishment approval test passed for URN $Urn." -ForegroundColor Green
}
finally { $env:PGPASSWORD = $oldPassword }
