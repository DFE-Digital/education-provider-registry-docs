function Import-DevelopmentEstablishmentSeed {
    # The entry point owns the run. SQL files explicitly define workspaces and
    # the batch body; no loader sections or column types are parsed at runtime.
    param([Parameter(Mandatory)]$Source,[Parameter(Mandatory)]$Target,
          [Parameter(Mandatory)][string]$WorkingDirectory,
          [int[]]$Urn=@(),[ValidateRange(1,10000)][int]$BatchSize=1000,
          [guid]$MigrationRunId=[guid]::Empty,
          [string]$KnownBadFile=(Get-SchemaPath 'seed/known-bad-establishments.json'))
    foreach ($selectedUrn in $Urn) {
        if ($selectedUrn -lt 1 -or $selectedUrn -gt 999999) { throw "Selected URN is outside the valid range: $selectedUrn" }
    }
    if ($MigrationRunId -eq [guid]::Empty) {throw 'The entry point must supply the development migration run.'}
    $known=@(Read-KnownBadEstablishments -Path $KnownBadFile)
    $ignored=@($known | Where-Object {$_.source_database -eq $Source.Database} | ForEach-Object {[int]$_.urn} | Sort-Object -Unique)
    $variables=@{URN='NULL';SELECTED_URNS=($Urn -join ',');EXCLUDED_URNS=($ignored -join ',')}
    $connection=$null; $command=$null; $reader=$null
    try {
        $connection=Open-BauConnection -Source $Source
        $command=$connection.CreateCommand()
        $command.CommandTimeout=600
        $command.CommandText=Get-SqlWithVariables -SqlFile (Get-SchemaPath 'establishment/transforms/development-establishment-counts-from-bau.sql') -Variables $variables
        $reader=$command.ExecuteReader()
        if (-not $reader.Read()) {throw 'BAU source count returned no result.'}
        $candidates=[int]$reader['candidates']; $excluded=[int]$reader['excluded']
    } finally {
        if ($reader) {$reader.Dispose()}
        if ($command) {$command.Dispose()}
        if ($connection) {$connection.Dispose()}
    }
    Write-Host "Source candidates: $candidates; cached exclusions: $excluded."
    $csv=Join-Path $WorkingDirectory 'development-establishments.csv'
    $count=Export-BauQueryToCsv -Source $Source -SqlFile (Get-SchemaPath 'establishment/transforms/establishment-from-bau.sql') `
        -Variables $variables -CsvPath $csv -Columns $script:EstablishmentFixtureColumns -RowCount Any -Description 'development establishments'
    Write-Step "Loading $count establishments in batches of $BatchSize; failed establishments will be logged and skipped"
    $body=Get-Content -LiteralPath (Get-SchemaPath 'migration/apply-development-establishment-batch.sql') -Raw
    $runner=(Get-Content -LiteralPath (Get-SchemaPath 'migration/load-development-establishment-seed.sql') -Raw).
        Replace('__BATCH_SIZE__',[string]$BatchSize).Replace('__RUN_ID__',[string]$MigrationRunId).
        Replace('__KNOWN_BAD_COUNT__',[string]$excluded).Replace('__CANDIDATES__',[string]$candidates).
        Replace('__LOAD_SQL__',$body.Replace("'","''"))
    $prepare=(Get-Content -LiteralPath (Get-SchemaPath 'migration/prepare-development-establishments.sql') -Raw).
        Replace('__FIXTURE_PATH__',$csv.Replace('\','/').Replace("'","''"))
    $path=Join-Path $WorkingDirectory 'load-development-establishments.sql'
    [IO.File]::WriteAllText($path,"SET synchronous_commit=off;`n"+$prepare+"`n"+$runner,[Text.UTF8Encoding]::new($false))
    $cacheState=@{Entries=[Collections.Generic.List[object]]::new()}
    foreach ($entry in $known) {$cacheState.Entries.Add($entry)}
    $onLine={
        param($line)
        $marker='EPR_REJECTIONS '
        $position=$line.IndexOf($marker)
        if ($position -ge 0) {
            $records=ConvertFrom-Json $line.Substring($position+$marker.Length)
            foreach ($record in $records) {
                $record | Add-Member NoteProperty source_database $Source.Database -Force
                $cacheState.Entries.Add($record)
            }
            Save-KnownBadEstablishments -Path $KnownBadFile -Entries $cacheState.Entries.ToArray()
        } elseif ($line -match 'INFO:\s*(Establishments processed:.*)$') {Write-Host $Matches[1]}
        elseif ($line.Trim()) {Write-Host $line}
    }
    Invoke-Psql -Target $Target -File $path -Quiet -OnOutputLine $onLine -FailureMessage 'Development establishment seed failed'
    return (ConvertFrom-Json (Invoke-Psql -Target $Target -Output Scalar -Command "SELECT notes FROM migration.migration_run WHERE migration_run_id='$MigrationRunId';" -FailureMessage 'Dev seed summary failed'))
}
