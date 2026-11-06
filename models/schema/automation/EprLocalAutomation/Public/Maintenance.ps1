function Import-MaintenanceObservationFixture {
    param([Parameter(Mandatory)]$Target,[Parameter(Mandatory)][string]$CsvPath,
          [Parameter(Mandatory)][string]$SourceDatabase,[Parameter(Mandatory)][string]$WorkingDirectory)
    Invoke-FixtureLoad -Target $Target -LoadSqlFile (Get-SchemaPath 'establishment/load/load-maintenance-responsibility-fixture.sql') `
        -CsvPath $CsvPath -WorkingDirectory $WorkingDirectory -Description 'maintenance source observations' `
        -TemplateValues @{ SOURCE_DATABASE=$SourceDatabase;EXTRACT_SHA256=(Get-FileHash -LiteralPath $CsvPath -Algorithm SHA256).Hash.ToLowerInvariant() }
}

function Import-MaintenanceFromBau {
    param([Parameter(Mandatory)]$Source,[Parameter(Mandatory)]$Target,
          [Parameter(Mandatory)][string]$WorkingDirectory)
    $urns=Invoke-Psql -Target $Target -Output Scalar -Command 'SELECT string_agg(urn::text,'','' ORDER BY urn) FROM establishment.establishment;' -FailureMessage 'Maintenance scope query failed'
    if ($urns -notmatch '^\d+(,\d+)*$') { throw 'Maintenance scope must contain target URNs.' }
    $csvPath=Join-Path $WorkingDirectory 'maintenance-source-observations.csv'
    $null=Export-BauQueryToCsv -Source $Source -SqlFile (Get-SchemaPath 'establishment/transforms/maintenance-responsibility-from-bau.sql') `
        -Variables @{URNS=$urns} -CsvPath $csvPath -RowCount AtLeastOne -Description 'maintenance source observations'
    $rows=Import-Csv -LiteralPath $csvPath -Delimiter '|'
    if (@($rows).Count -ne @($urns.Split(',')).Count) { throw 'Maintenance source extract did not cover every target establishment.' }
    Import-MaintenanceObservationFixture -Target $Target -CsvPath $csvPath -SourceDatabase $Source.Database -WorkingDirectory $WorkingDirectory
}
