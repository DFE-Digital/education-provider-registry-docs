<#
.SYNOPSIS
  Reports aggregate governance-appointment coverage for controlled local BAU
  establishment fixtures.

.DESCRIPTION
  Reads only dbo.StaffRecord and dbo.StaffRole in the laptop-hosted
  gias_bau_test_local database. It returns counts and role codes or labels,
  never appointment-holder names or other person data.
#>
[CmdletBinding()]
param(
    [string]$SqlServer = 'localhost',
    [string]$SourceDatabase = 'gias_bau_test_local',
    [string]$SqlUser = 'reader',
    [string]$SqlPassword = $env:EPR_BAU_SQL_PASSWORD,
    [int[]]$Urn = @(100018, 106431, 136102)
)

$allowedServers = @('localhost', '127.0.0.1', 'SL646104')
$allowedDatabases = @('gias_bau_test_local')

if ($SqlServer -notin $allowedServers) {
    throw "Only a laptop-local SQL Server is permitted. Received: $SqlServer"
}

if ($SourceDatabase -notin $allowedDatabases) {
    throw "Only an approved local source database is permitted. Received: $SourceDatabase"
}

if (-not $SqlPassword) {
    $securePassword = Read-Host -Prompt 'Local SQL Server reader password' -AsSecureString
    $SqlPassword = [System.Net.NetworkCredential]::new('', $securePassword).Password
}

if (-not $Urn -or $Urn.Count -eq 0) {
    throw 'Supply at least one establishment URN.'
}

$urnValues = ($Urn | ForEach-Object {
    if ($_ -le 0) { throw "URN must be positive: $_" }
    [string]$_
}) -join ', '

$query = @"
DECLARE @today date = CAST(GETDATE() AS date);

SELECT
    sr.establishment_URN AS urn,
    COUNT(*) AS source_appointment_count,
    SUM(CASE
        WHEN sr.status = 1
         AND ISNULL(sr.deleted, 0) = 0
         AND ISNULL(sr.forcedArchived, 0) = 0
         AND (sr.stepdownDate IS NULL OR CAST(sr.stepdownDate AS date) >= @today)
        THEN 1 ELSE 0
    END) AS current_appointment_count,
    COUNT(DISTINCT CASE
        WHEN sr.status = 1
         AND ISNULL(sr.deleted, 0) = 0
         AND ISNULL(sr.forcedArchived, 0) = 0
         AND (sr.stepdownDate IS NULL OR CAST(sr.stepdownDate AS date) >= @today)
        THEN sr.staffRole_code
    END) AS current_role_type_count
FROM dbo.StaffRecord sr
WHERE sr.establishment_URN IN ($urnValues)
GROUP BY sr.establishment_URN
ORDER BY sr.establishment_URN;

SELECT
    sr.establishment_URN AS urn,
    sr.staffRole_code AS source_role_code,
    role.name AS source_role_name,
    COUNT(*) AS current_appointment_count
FROM dbo.StaffRecord sr
LEFT JOIN dbo.StaffRole role ON role.code = sr.staffRole_code
WHERE sr.establishment_URN IN ($urnValues)
  AND sr.status = 1
  AND ISNULL(sr.deleted, 0) = 0
  AND ISNULL(sr.forcedArchived, 0) = 0
  AND (sr.stepdownDate IS NULL OR CAST(sr.stepdownDate AS date) >= @today)
GROUP BY sr.establishment_URN, sr.staffRole_code, role.name
ORDER BY sr.establishment_URN, sr.staffRole_code;
"@

$connectionString = "Server=$SqlServer;Database=$SourceDatabase;User ID=$SqlUser;Password=$SqlPassword;Encrypt=False;TrustServerCertificate=True;Connection Timeout=10"
$connection = [System.Data.SqlClient.SqlConnection]::new($connectionString)

try {
    $connection.Open()

    $preflightCommand = $connection.CreateCommand()
    $preflightCommand.CommandText = @'
SELECT required_table.table_name
FROM (VALUES
    (N'dbo.StaffRecord', OBJECT_ID(N'dbo.StaffRecord', N'U')),
    (N'dbo.StaffRole', OBJECT_ID(N'dbo.StaffRole', N'U'))
) AS required_table(table_name, object_id)
WHERE required_table.object_id IS NULL;
'@
    $preflightReader = $preflightCommand.ExecuteReader()
    $missingTables = @()
    while ($preflightReader.Read()) { $missingTables += $preflightReader.GetString(0) }
    $preflightReader.Dispose()
    $preflightCommand.Dispose()

    if ($missingTables.Count -gt 0) {
        throw "The local source copy is missing: $($missingTables -join ', '). Manually copy the selected StaffRecord rows and StaffRole lookup from BAU Test into gias_bau_test_local, then rerun this read-only check. Automation must not connect directly to BAU Test."
    }

    $command = $connection.CreateCommand()
    $command.CommandText = $query
    $reader = $command.ExecuteReader()

    $summary = [System.Data.DataTable]::new()
    $summary.Load($reader)
    $roleDistribution = [System.Data.DataTable]::new()
    $roleDistribution.Load($reader)

    Write-Output 'Governance appointment coverage'
    $summary | Format-Table -AutoSize | Out-String | Write-Output
    Write-Output 'Current appointment role distribution'
    $roleDistribution | Format-Table -AutoSize | Out-String | Write-Output
}
finally {
    if ($preflightReader) { $preflightReader.Dispose() }
    if ($preflightCommand) { $preflightCommand.Dispose() }
    if ($reader) { $reader.Dispose() }
    if ($command) { $command.Dispose() }
    $connection.Dispose()
    Remove-Variable SqlPassword -ErrorAction SilentlyContinue
}
