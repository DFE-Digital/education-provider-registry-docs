<#[CmdletBinding()]
Validates the expected row count for every physical Establishment table.
#>
[CmdletBinding()]
param(
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
$approval = Join-Path $PSScriptRoot 'approval\establishment-row-counts.approved.json'
if (-not $UpdateApproval -and -not (Test-Path -LiteralPath $approval -PathType Leaf)) { throw "Approval file not found: $approval" }

$sql = @'
SELECT jsonb_agg(
    jsonb_build_object('table_name', table_name, 'row_count', row_count)
    ORDER BY table_name
)
FROM (
    SELECT t.table_name,
           (xpath('/table/row/c/text()', query_to_xml(
               format('SELECT count(*) AS c FROM establishment.%I', t.table_name),
               true, false, ''
           )))[1]::text::bigint AS row_count
    FROM information_schema.tables AS t
    WHERE t.table_schema = 'establishment'
      AND t.table_type = 'BASE TABLE'
) AS counts;
'@
$tempSql = Join-Path $env:TEMP "epr-establishment-row-counts-$PID.sql"
Set-Content -LiteralPath $tempSql -Value $sql -Encoding utf8
$psql = Get-LocalPostgresClientPath
$oldPassword = $env:PGPASSWORD
if ($PostgresPassword) { $env:PGPASSWORD = $PostgresPassword }
try {
    $actual = (& $psql -X -A -t -q -h $PostgresHost -p $PostgresPort -U $PostgresUser -d $PostgresDatabase -w -v ON_ERROR_STOP=1 -f $tempSql | Out-String).Trim()
    if ($LASTEXITCODE -ne 0) { throw "Row-count approval query failed with exit code $LASTEXITCODE" }
    if ($UpdateApproval) {
        Set-Content -LiteralPath $approval -Value $actual -Encoding utf8
        Write-Host "Updated approval snapshot: $approval"
        return
    }
    $expected = (Get-Content -LiteralPath $approval -Raw).Trim()
    if ($actual -cne $expected) {
        Write-Host "$([char]::ConvertFromUtf32(0x1F926)) Establishment row-count approval test failed." -ForegroundColor Red
        Write-Host 'Expected approval:'
        Write-Host $expected
        Write-Host 'Actual result:'
        Write-Host $actual
        throw 'Establishment row-count approval test failed.'
    }
    Write-Host "$([char]::ConvertFromUtf32(0x1F642)) Establishment row-count approval test passed." -ForegroundColor Green
}
finally {
    $env:PGPASSWORD = $oldPassword
    Remove-Item -LiteralPath $tempSql -Force -ErrorAction SilentlyContinue
}
