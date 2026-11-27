<# Test the full establishment DDL in a unique transaction-local schema.
Uses pgpass.conf / PGPASSWORD. Never resets the existing establishment schema. #>
[CmdletBinding()]
param(
    [string]$Psql = 'C:\Program Files\PostgreSQL\18\bin\psql.exe',
    [string]$Database = 'establishment_local',
    [ValidateRange(1,65535)][int]$Port = 5432,
    [string]$User = 'postgres'
)
$ErrorActionPreference = 'Stop'
if ($Database -notin @('establishment_local','epr_establishment','establishment')) {
    throw 'Choose a disposable local modelling database.'
}
$schemaRoot = Split-Path (Split-Path $PSScriptRoot)
$ddl = [IO.File]::ReadAllText((Join-Path $schemaRoot 'establishment/establishment-schema.sql'))
$seed = [IO.File]::ReadAllText((Join-Path $schemaRoot 'seed/seed-reorganisation-reference-data.sql'))
$tests = [IO.File]::ReadAllText((Join-Path $PSScriptRoot 'reorganisation-schema-tests.sql'))
$ddl = [regex]::Replace($ddl, '(?m)^COMMIT;\s*$', '')
$tests = [regex]::Replace($tests, '(?m)^BEGIN;\r?\n', '')
$testSchema = 'epr_reorg_check_' + [guid]::NewGuid().ToString('N')
$sql = ($ddl + "`n" + $seed + "`n" + $tests).
    Replace('CREATE SCHEMA establishment;', "CREATE SCHEMA $testSchema;").
    Replace('establishment.', "$testSchema.")
$temporaryFile = Join-Path ([IO.Path]::GetTempPath()) ($testSchema + '.sql')
try {
    [IO.File]::WriteAllText($temporaryFile, $sql, (New-Object Text.UTF8Encoding($false)))
    & $Psql -X -w -h 127.0.0.1 -p $Port -U $User -d $Database -v ON_ERROR_STOP=1 -f $temporaryFile
    if ($LASTEXITCODE -ne 0) { throw 'Reorganisation schema tests failed; the connection transaction was rolled back.' }
} finally {
    if (Test-Path -LiteralPath $temporaryFile) { Remove-Item -LiteralPath $temporaryFile }
}
