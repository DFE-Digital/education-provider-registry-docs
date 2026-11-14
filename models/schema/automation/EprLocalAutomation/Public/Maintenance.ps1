function Import-MaintenanceObservationFixture {
    param([Parameter(Mandatory)]$Target,[Parameter(Mandatory)][string]$CsvPath,
          [Parameter(Mandatory)][string]$SourceDatabase,[Parameter(Mandatory)][string]$WorkingDirectory,
          [switch]$SkipDerivation)
    $loadFile=if ($SkipDerivation) { Get-SchemaPath 'migration/load-development-maintenance-observations.sql' }
        else { Get-SchemaPath 'establishment/load/load-maintenance-responsibility-fixture.sql' }
    Invoke-FixtureLoad -Target $Target -LoadSqlFile $loadFile -CsvPath $CsvPath -WorkingDirectory $WorkingDirectory `
        -Description 'maintenance source observations' -Quiet:$SkipDerivation `
        -TemplateValues @{ SOURCE_DATABASE=$SourceDatabase;EXTRACT_SHA256=(Get-FileHash -LiteralPath $CsvPath -Algorithm SHA256).Hash.ToLowerInvariant() }
}
