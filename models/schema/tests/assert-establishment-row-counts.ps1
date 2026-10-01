<#!
Validates that the current local Establishment target contains only the
establishments selected for T1 and T2.
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
. (Join-Path $PSScriptRoot '..\automation\common\local-database-guards.ps1')
. (Join-Path $PSScriptRoot '..\automation\common\sql-client-functions.ps1')
Assert-LocalPostgresTarget -PostgresHost $PostgresHost -PostgresDatabase $PostgresDatabase

$psql = Get-LocalPostgresClientPath
$oldPassword = $env:PGPASSWORD
if ($PostgresPassword) { $env:PGPASSWORD = $PostgresPassword }
try {
    $count = (& $psql -X -A -t -q -h $PostgresHost -p $PostgresPort -U $PostgresUser -d $PostgresDatabase -w -v ON_ERROR_STOP=1 -c "SELECT count(*) FROM establishment.establishment;" | Out-String).Trim()
    if ($LASTEXITCODE -ne 0) { throw "Establishment count query failed with exit code $LASTEXITCODE" }
    if ([int]$count -ne 2) { throw "T1/T2 fixture expected exactly two establishments, but found $count." }

    $unexpected = (& $psql -X -A -t -q -h $PostgresHost -p $PostgresPort -U $PostgresUser -d $PostgresDatabase -w -v ON_ERROR_STOP=1 -c "SELECT count(*) FROM establishment.establishment WHERE urn NOT IN (136102, 134314);" | Out-String).Trim()
    if ($LASTEXITCODE -ne 0) { throw "T1/T2 URN scope query failed with exit code $LASTEXITCODE" }
    if ([int]$unexpected -ne 0) { throw "T1/T2 fixture contains establishments outside URNs 136102 and 134314." }

    Write-Host 'T1/T2 establishment scope test passed.'
}
finally { $env:PGPASSWORD = $oldPassword }
