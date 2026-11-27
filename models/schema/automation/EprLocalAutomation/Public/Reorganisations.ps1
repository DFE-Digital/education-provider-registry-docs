# A subset rebuild loads the entire linked set before any reorganisation rows.
function Resolve-LinkedEstablishmentSelection {
    param([Parameter(Mandatory)]$Source,[Parameter(Mandatory)][string]$WorkingDirectory,[int[]]$Urn=@())
    if ($Urn.Count -eq 0) { return }
    foreach ($selectedUrn in $Urn) {
        if ($selectedUrn -lt 1 -or $selectedUrn -gt 999999) { throw "Invalid selected URN: $selectedUrn" }
    }
    $csv=Join-Path $WorkingDirectory 'resolved-establishment-selection.csv'
    Export-BauQueryToCsv -Source $Source -SqlFile (Get-SchemaPath 'establishment/transforms/linked-establishment-selection-from-bau.sql') `
        -Variables @{URNS=($Urn -join ',')} -CsvPath $csv -RowCount AtLeastOne -Description 'linked establishment selection' | Out-Null
    $resolved=@(Import-Csv -LiteralPath $csv -Delimiter '|' | ForEach-Object {[int]$_.urn} | Sort-Object -Unique)
    Write-Host "Selected URNs: $($Urn -join ', '); resolved linked set: $($resolved -join ', ')."
    return $resolved
}
function Import-EstablishmentReorganisations {
    param([Parameter(Mandatory)]$Source,[Parameter(Mandatory)]$Target,
          [Parameter(Mandatory)][string]$WorkingDirectory,[int[]]$Urn=@(),
          [Parameter(Mandatory)][guid]$MigrationRunId)
    $cases=(Get-Content -LiteralPath (Get-SchemaPath 'establishment/cases/reorganisation-migration-cases.json') -Raw | ConvertFrom-Json).cases
    foreach ($case in $cases) {
        if (-not $case.migration_enabled) { continue }
        $caseUrns=@($case.urns | ForEach-Object {[int]$_} | Sort-Object -Unique)
        if ($caseUrns.Count -lt 2 -or @($caseUrns | Where-Object {$_ -lt 1 -or $_ -gt 999999}).Count -gt 0) {
            throw "Invalid URNs for reorganisation case $($case.case_id)."
        }
        $selected=@($caseUrns | Where-Object {$_ -in $Urn})
        if ($Urn.Count -gt 0 -and $selected.Count -eq 0) { continue }
        if (($caseUrns -join ',') -ne ((@($case.participants.urn) | Sort-Object -Unique) -join ',')) {
            throw "Participant URNs do not match the selection for case $($case.case_id)."
        }
        $sourceRows=@{}
        foreach ($dataset in @('links','participants')) {
            $csv=Join-Path $WorkingDirectory ('reorganisation-'+$case.case_id+'-'+$dataset+'.csv')
            Export-BauQueryToCsv -Source $Source -SqlFile (Get-SchemaPath ("establishment/transforms/reorganisation-"+$dataset+"-from-bau.sql")) `
                -Variables @{URNS=($caseUrns -join ',')} -CsvPath $csv -RowCount Any -Description ("reorganisation "+$case.case_id+" "+$dataset) | Out-Null
            $sourceRows[$dataset]=@(Import-Csv -LiteralPath $csv -Delimiter '|')
        }
        $payload=[ordered]@{
            case_id=$case.case_id; pattern=$case.pattern; cause=$case.cause
            description=$case.description; effective_date=$case.effective_date
            participants=@($case.participants); succession_pairs=@($case.succession_pairs)
            provision_transfer_pairs=@($case.provision_transfer_pairs | Where-Object {$null -ne $_})
            effects=@($case.effects | Where-Object {$null -ne $_})
            validation_date=$case.validation_date; review_status=$case.review_status
            assumption_note=$case.review_note; assumption_accepted_on=$case.assumption_accepted_on
            source_database=$Source.Database
            source_links=$sourceRows.links; source_participants=$sourceRows.participants
        }
        $json=(ConvertTo-Json -InputObject $payload -Depth 12 -Compress).Replace("'","''")
        $selectedUrn=if ($selected.Count -gt 0) {$selected[0]} else {$caseUrns[0]}
        $sql=(Get-Content -LiteralPath (Get-SchemaPath 'migration/load-reviewed-reorganisation.sql') -Raw).
            Replace('__SELECTED_URN__',"$selectedUrn").Replace('__RUN_ID__',"$MigrationRunId").Replace('__PAYLOAD__',$json)
        $path=Join-Path $WorkingDirectory ('load-reorganisation-'+$case.case_id+'.sql')
        [IO.File]::WriteAllText($path,$sql,[Text.UTF8Encoding]::new($false))
        Invoke-Psql -Target $Target -File $path -FailureMessage ('Reorganisation migration failed: '+$case.case_id)
    }
}
