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
    # Used by source-reference regression fixtures; bulk exports use the reader loop.
    param($Value)
    if ($null -eq $Value -or $Value -is [DBNull]) { return 'NULL' }
    if ($Value -is [datetime]) { return $Value.ToString('yyyy-MM-dd',[Globalization.CultureInfo]::InvariantCulture) }
    $text=if ($Value -is [IFormattable]) { $Value.ToString($null,[Globalization.CultureInfo]::InvariantCulture) } else { $Value.ToString() }
    return $text.Replace('|',' ')
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

function Write-BauReaderToCsv {
    # Stream the result with PowerShell loops, without a pipeline per cell.
    param([Parameter(Mandatory)]$Reader,[Parameter(Mandatory)][string]$CsvPath,
          [string[]]$Columns,[string]$RowCount='Any',[string]$Description='source extract')
    $width=if ($Columns) { $Columns.Length } else { $Reader.FieldCount }
    $ordinals=[int[]]::new($width)
    $names=[string[]]::new($width)
    $values=[string[]]::new($width)
    $quotedCharacters=[char[]]@('"',"`r","`n")
    $culture=[Globalization.CultureInfo]::InvariantCulture
    for ($index=0;$index -lt $width;$index++) {
        $names[$index]=if ($Columns) { $Columns[$index] } else { $Reader.GetName($index) }
        $ordinals[$index]=$Reader.GetOrdinal($names[$index])
    }
    $writer=[IO.StreamWriter]::new($CsvPath,$false,[Text.UTF8Encoding]::new($false),65536)
    $rows=0
    try {
        $writer.WriteLine([string]::Join('|',$names))
        while ($Reader.Read()) {
            $rows++
            if ($RowCount -eq 'ExactlyOne' -and $rows -gt 1) { throw 'Expected exactly one row, but more than one was returned.' }
            for ($index=0;$index -lt $width;$index++) {
                $value=$Reader.GetValue($ordinals[$index])
                if ($null -eq $value -or $value -is [DBNull]) { $values[$index]='NULL'; continue }
                $cell=if ($value -is [datetime]) { $value.ToString('yyyy-MM-dd',$culture) }
                    elseif ($value -is [IFormattable]) { $value.ToString($null,$culture) }
                    else { $value.ToString() }
                $cell=$cell.Replace('|',' ')
                if ($cell.IndexOfAny($quotedCharacters) -ge 0) { $cell='"'+$cell.Replace('"','""')+'"' }
                $values[$index]=$cell
            }
            $writer.WriteLine([string]::Join('|',$values))
            if ($rows % 10000 -eq 0) { Write-Host "    $Description`: $rows rows extracted." }
        }
    } finally { $writer.Dispose() }
    if ($rows -eq 0 -and $RowCount -ne 'Any') { throw 'No rows were returned from the local BAU copy.' }
    return $rows
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
    Write-Host "    Extracting $Description from $($Source.SqlServer)/$($Source.Database)..."
    $elapsed = [System.Diagnostics.Stopwatch]::StartNew()
    $connection = $null; $command = $null; $reader = $null; $writer = $null
    $rows = 0
    try {
        $connection = Open-BauConnection -Source $Source
        $command = $connection.CreateCommand()
        $command.CommandText = $sql
        $command.CommandTimeout = 600
        $reader = $command.ExecuteReader()

        $rows = Write-BauReaderToCsv -Reader $reader -CsvPath $CsvPath -Columns $Columns -RowCount $RowCount -Description $Description
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
    Write-Host "    Extracted $rows rows for $Description ($([int]$elapsed.Elapsed.TotalSeconds)s)."
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
        [guid]$MigrationRunId = [guid]::Empty,
        [hashtable]$TemplateValues,
        [switch]$Quiet
    )

    Assert-FileExists -Path $LoadSqlFile
    $loadSql = (Get-Content -LiteralPath $LoadSqlFile -Raw).Replace('__FIXTURE_PATH__', ($CsvPath -replace '\\', '/'))
    if ($TemplateValues) {
        foreach ($key in $TemplateValues.Keys) {
            # Values are escaped SQL-literal contents, not executable SQL.
            $loadSql = $loadSql.Replace("__$($key)__", ([string]$TemplateValues[$key]).Replace("'", "''"))
        }
    }
    if ($MigrationRunId -ne [guid]::Empty) {
        $loadSql = "SELECT set_config('epr.migration_run_id', '$MigrationRunId', false);`n" + $loadSql
    }
    $workingCopy = Join-Path $WorkingDirectory ('load-' + [System.IO.Path]::GetFileNameWithoutExtension($CsvPath) + '.sql')
    [System.IO.File]::WriteAllText($workingCopy, $loadSql, [System.Text.UTF8Encoding]::new($false))
    Invoke-Psql -Target $Target -File $workingCopy -Quiet:$Quiet -FailureMessage "PostgreSQL load failed for $Description"
}
