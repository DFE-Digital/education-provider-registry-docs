# Reading from the local BAU SQL Server copy and writing pipe-delimited CSV
# fixtures, then loading those fixtures into PostgreSQL.
#
# Fixture format, shared by every load SQL file: pipe-delimited, one header
# line, the text NULL for a missing value, UTF-8 without a byte-order mark.

function Open-BauConnection {
    param([Parameter(Mandatory)]$Source)

    $common = "Server=$($Source.SqlServer);Database=$($Source.Database);Encrypt=False;TrustServerCertificate=True;Connection Timeout=10"
    if ($Source.UseWindowsAuthentication) {
        $connectionString = "$common;Integrated Security=SSPI"
    }
    else {
        $password = [System.Net.NetworkCredential]::new('', $Source.SqlPassword).Password
        $connectionString = "$common;User ID=$($Source.SqlUser);Password=$password"
    }
    $connection = [System.Data.SqlClient.SqlConnection]::new($connectionString)
    $connection.Open()
    return $connection
}

function ConvertTo-FixtureValue {
    <#
    .SYNOPSIS
    Formats one source value for a fixture: NULL for missing values, ISO dates,
    invariant-culture numbers, and no pipe characters inside a value.
    #>
    param($Value)

    if ($null -eq $Value -or $Value -is [System.DBNull]) { return 'NULL' }
    if ($Value -is [datetime]) { return $Value.ToString('yyyy-MM-dd', [System.Globalization.CultureInfo]::InvariantCulture) }
    if ($Value -is [System.IFormattable]) {
        $text = $Value.ToString($null, [System.Globalization.CultureInfo]::InvariantCulture)
    }
    else {
        $text = $Value.ToString()
    }
    return $text.Replace('|', ' ')
}

function Get-SqlWithVariables {
    <#
    .SYNOPSIS
    Reads a transform SQL file and replaces each $(NAME) placeholder.
    #>
    param(
        [Parameter(Mandatory)][string]$SqlFile,
        [hashtable]$Variables
    )

    Assert-FileExists -Path $SqlFile
    $sql = Get-Content -LiteralPath $SqlFile -Raw
    if ($Variables) {
        foreach ($name in $Variables.Keys) {
            $sql = $sql.Replace("`$($name)", [string]$Variables[$name])
        }
    }
    return $sql
}

function Export-BauQueryToCsv {
    <#
    .SYNOPSIS
    Runs a transform SQL file against the local BAU copy and writes the first
    result set to a fixture CSV. Returns the number of rows written.
    .PARAMETER Columns
    Source column names to write, in the order the load SQL expects. All columns
    are written when omitted.
    .PARAMETER RowCount
    Any, AtLeastOne or ExactlyOne. The run fails if the result does not match.
    #>
    param(
        [Parameter(Mandatory)]$Source,
        [Parameter(Mandatory)][string]$SqlFile,
        [hashtable]$Variables,
        [Parameter(Mandatory)][string]$CsvPath,
        [string[]]$Columns,
        [ValidateSet('Any', 'AtLeastOne', 'ExactlyOne')][string]$RowCount = 'Any',
        [Parameter(Mandatory)][string]$Description
    )

    $sql = Get-SqlWithVariables -SqlFile $SqlFile -Variables $Variables
    $connection = $null; $command = $null; $reader = $null; $writer = $null
    $rows = 0
    try {
        $connection = Open-BauConnection -Source $Source
        $command = $connection.CreateCommand()
        $command.CommandText = $sql
        $reader = $command.ExecuteReader()

        if ($Columns) {
            $ordinals = foreach ($column in $Columns) {
                try { $reader.GetOrdinal($column) }
                catch { throw "The transform for $Description does not return column '$column'." }
            }
            $header = $Columns
        }
        else {
            $ordinals = 0..($reader.FieldCount - 1)
            $header = foreach ($ordinal in $ordinals) { $reader.GetName($ordinal) }
        }

        $writer = [System.IO.StreamWriter]::new($CsvPath, $false, [System.Text.UTF8Encoding]::new($false))
        $writer.WriteLine(($header -join '|'))
        while ($reader.Read()) {
            $rows++
            if ($RowCount -eq 'ExactlyOne' -and $rows -gt 1) {
                throw "Expected exactly one row for $Description, but more than one was returned."
            }
            $values = foreach ($ordinal in $ordinals) { ConvertTo-FixtureValue -Value $reader.GetValue($ordinal) }
            $writer.WriteLine(($values -join '|'))
        }
    }
    catch {
        throw "BAU extract failed for ${Description}: $($_.Exception.Message)"
    }
    finally {
        if ($writer) { $writer.Dispose() }
        if ($reader) { $reader.Dispose() }
        if ($command) { $command.Dispose() }
        if ($connection) { $connection.Dispose() }
    }

    if ($rows -eq 0 -and $RowCount -ne 'Any') {
        throw "No rows were returned from the local BAU copy for $Description."
    }
    return $rows
}

function Invoke-FixtureLoad {
    <#
    .SYNOPSIS
    Loads a fixture CSV with a load SQL file. The load SQL refers to the CSV as
    __FIXTURE_PATH__, which is replaced in a working copy of the SQL.
    #>
    param(
        [Parameter(Mandatory)]$Target,
        [Parameter(Mandatory)][string]$LoadSqlFile,
        [Parameter(Mandatory)][string]$CsvPath,
        [Parameter(Mandatory)][string]$WorkingDirectory,
        [Parameter(Mandatory)][string]$Description,
        [guid]$MigrationRunId = [guid]::Empty
    )

    Assert-FileExists -Path $LoadSqlFile
    $loadSql = (Get-Content -LiteralPath $LoadSqlFile -Raw).Replace('__FIXTURE_PATH__', ($CsvPath -replace '\\', '/'))
    if ($MigrationRunId -ne [guid]::Empty) {
        $loadSql = "SELECT set_config('epr.migration_run_id', '$MigrationRunId', false);`n" + $loadSql
    }
    $workingCopy = Join-Path $WorkingDirectory ('load-' + [System.IO.Path]::GetFileNameWithoutExtension($CsvPath) + '.sql')
    [System.IO.File]::WriteAllText($workingCopy, $loadSql, [System.Text.UTF8Encoding]::new($false))
    Invoke-Psql -Target $Target -File $workingCopy -FailureMessage "PostgreSQL load failed for $Description"
}
