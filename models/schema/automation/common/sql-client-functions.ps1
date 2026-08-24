function Get-LocalPostgresClientPath {
    $psql = (Get-Command psql.exe -ErrorAction SilentlyContinue).Source
    if (-not $psql) { $psql = 'C:\Program Files\PostgreSQL\18\bin\psql.exe' }
    if (-not (Test-Path -LiteralPath $psql)) { throw "psql not found: $psql" }
    return $psql
}

function New-LocalBauSqlConnection {
    param([Parameter(Mandatory)][string]$SqlServer, [Parameter(Mandatory)][string]$SourceDatabase, [Parameter(Mandatory)][string]$SqlUser, [Parameter(Mandatory)][string]$SqlPassword)
    $connectionString = "Server=$SqlServer;Database=$SourceDatabase;User ID=$SqlUser;Password=$SqlPassword;Encrypt=False;TrustServerCertificate=True;Connection Timeout=10"
    return [System.Data.SqlClient.SqlConnection]::new($connectionString)
}
