# Current SEN reference meanings and complete establishment association sets.
function Import-SenReferenceData {
    param([Parameter(Mandatory)]$Source, [Parameter(Mandatory)]$Target,
          [Parameter(Mandatory)][string]$WorkingDirectory)
    Write-Step 'Reconciling current SEN reference data'
    $csvPath = Join-Path $WorkingDirectory 'sen-reference.csv'
    Export-BauQueryToCsv -Source $Source -SqlFile (Get-SchemaPath 'establishment/transforms/sen-reference-from-bau.sql') `
        -CsvPath $csvPath -RowCount AtLeastOne -Description 'SEN reference data' | Out-Null
    Invoke-FixtureLoad -Target $Target -LoadSqlFile (Get-SchemaPath 'establishment/load/load-sen-reference-fixture.sql') `
        -CsvPath $csvPath -WorkingDirectory $WorkingDirectory -Description 'SEN reference data'
}
