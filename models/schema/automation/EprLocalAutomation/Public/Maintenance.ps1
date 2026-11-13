function Import-MaintenanceObservationFixture {
    param([Parameter(Mandatory)]$Target,[Parameter(Mandatory)][string]$CsvPath,
          [Parameter(Mandatory)][string]$SourceDatabase,[Parameter(Mandatory)][string]$WorkingDirectory,
          [switch]$SkipDerivation)
    $loadFile=Get-SchemaPath 'establishment/load/load-maintenance-responsibility-fixture.sql'
    if (-not $SkipDerivation) {
        Invoke-FixtureLoad -Target $Target -LoadSqlFile $loadFile -CsvPath $CsvPath -WorkingDirectory $WorkingDirectory -Description 'maintenance source observations' `
            -TemplateValues @{ SOURCE_DATABASE=$SourceDatabase;EXTRACT_SHA256=(Get-FileHash -LiteralPath $CsvPath -Algorithm SHA256).Hash.ToLowerInvariant() }
        return
    }
    $sql=(Get-Content -LiteralPath $loadFile -Raw).Replace('__FIXTURE_PATH__',$CsvPath.Replace('\','/')).
        Replace('__SOURCE_DATABASE__',$SourceDatabase).Replace('__EXTRACT_SHA256__',(Get-FileHash -LiteralPath $CsvPath -Algorithm SHA256).Hash.ToLowerInvariant())
    $sql=$sql.Replace("SELECT pg_advisory_xact_lock(hashtextextended('maintenance-import/__SOURCE_DATABASE__/__EXTRACT_SHA256__',0));",'')
    $sql=$sql.Replace('    PERFORM migration.derive_maintenance(snapshot_id);','    -- Development seed retains observations but does not run reviewed derivation.')
    $path=Join-Path $WorkingDirectory 'load-development-maintenance.sql'
    [IO.File]::WriteAllText($path,$sql,[Text.UTF8Encoding]::new($false))
    Invoke-Psql -Target $Target -File $path -Quiet -FailureMessage 'Development maintenance observation load failed'
}

function Import-MaintenanceFromBau {
    param([Parameter(Mandatory)]$Source,[Parameter(Mandatory)]$Target,
          [Parameter(Mandatory)][string]$WorkingDirectory,[switch]$AllSource)
    if ($AllSource) {
        $urns='0'
        $expectedCount=[int](Invoke-Psql -Target $Target -Output Scalar -Command 'SELECT count(*) FROM establishment.establishment;' -FailureMessage 'Maintenance scope query failed')
    } else {
        $urns=Invoke-Psql -Target $Target -Output Scalar -Command 'SELECT string_agg(urn::text,'','' ORDER BY urn) FROM establishment.establishment;' -FailureMessage 'Maintenance scope query failed'
        if ($urns -notmatch '^\d+(,\d+)*$') { throw 'Maintenance scope must contain target URNs.' }
        $expectedCount=$urns.Split(',').Count
    }
    $csvPath=Join-Path $WorkingDirectory 'maintenance-source-observations.csv'
    $count=Export-BauQueryToCsv -Source $Source -SqlFile (Get-SchemaPath 'establishment/transforms/maintenance-responsibility-from-bau.sql') `
        -Variables @{URNS=$urns;ALL_SOURCE=[int][bool]$AllSource} -CsvPath $csvPath -RowCount AtLeastOne -Description 'maintenance source observations'
    if ($count -ne $expectedCount) { throw 'Maintenance source extract did not cover every target establishment.' }
    Import-MaintenanceObservationFixture -Target $Target -CsvPath $csvPath -SourceDatabase $Source.Database -WorkingDirectory $WorkingDirectory
}
