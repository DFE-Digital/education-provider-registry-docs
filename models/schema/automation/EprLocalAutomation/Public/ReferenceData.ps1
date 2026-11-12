function Export-BauReferenceData {
    param([Parameter(Mandatory)]$Source,[Parameter(Mandatory)][string]$WorkingDirectory)
    $csv=Join-Path $WorkingDirectory 'source-reference-data.csv'
    Export-BauQueryToCsv -Source $Source -SqlFile (Get-SchemaPath 'establishment/transforms/reference-data-from-bau.sql') `
        -CsvPath $csv -RowCount AtLeastOne -Description 'complete BAU reference dictionaries' | Out-Null
    return $csv
}

function Import-BauReferenceData {
    param([Parameter(Mandatory)]$Target,[Parameter(Mandatory)][string]$CsvPath,
          [Parameter(Mandatory)][string]$SourceDatabase,[Parameter(Mandatory)][string]$WorkingDirectory)
    Write-Step 'Loading and reconciling source-owned reference dictionaries'
    Invoke-FixtureLoad -Target $Target -LoadSqlFile (Get-SchemaPath 'establishment/load/load-reference-data-fixture.sql') `
        -CsvPath $CsvPath -WorkingDirectory $WorkingDirectory -Description 'BAU reference dictionaries' `
        -TemplateValues @{SOURCE_DATABASE=$SourceDatabase}
}
