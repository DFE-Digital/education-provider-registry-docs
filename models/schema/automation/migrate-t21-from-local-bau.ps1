# Adds the bounded T21 partnership proprietor without rebuilding or changing seeds.
[CmdletBinding()]
param([string]$SqlServer='SL646104', $BauSource, $PostgresTarget)
$ErrorActionPreference='Stop'
Import-Module (Join-Path $PSScriptRoot 'EprLocalAutomation/EprLocalAutomation.psm1')
if (-not $env:EPR_BAU_SQL_PASSWORD) {
    $env:EPR_BAU_SQL_PASSWORD=[Environment]::GetEnvironmentVariable('EPR_BAU_SQL_PASSWORD','User')
}
if (-not $BauSource -and -not $env:EPR_BAU_SQL_PASSWORD) { throw 'EPR_BAU_SQL_PASSWORD is required.' }
$source=if($BauSource){$BauSource}else{New-BauSource -SqlServer $SqlServer -SqlUser reader}
$target=if($PostgresTarget){$PostgresTarget}else{New-PostgresTarget -PostgresHost localhost}
$workspace=New-RunWorkspace
try {
    & (Get-Module EprLocalAutomation) {
        param($source,$target,$workspace)
        $fixture=Get-Content -LiteralPath (Get-SchemaPath 'seed/t21-controlled-proprietor.json') -Raw -Encoding UTF8 | ConvertFrom-Json
        $workspaceRoot=Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $script:SchemaRoot))
        $rows=@(Import-Csv -LiteralPath (Join-Path $workspaceRoot $fixture.extractPath) | Where-Object {$_.URN -eq '124870'})
        if($rows.Count -ne 1 -or $rows[0].PropsName -cne $fixture.name -or
           $rows[0].EstablishmentName -cne 'Summerhill School' -or
           $rows[0].'TypeOfEstablishment (name)' -ne 'Other independent school' -or
           $rows[0].'EstablishmentStatus (name)' -ne 'Open') {throw 'T21 public extract assertion changed; review required.'}
        $null=Export-BauQueryToCsv -Source $source -SqlFile (Get-SchemaPath 'establishment/transforms/t21-source-preflight.sql') `
            -CsvPath (Join-Path $workspace 'preflight.csv') -RowCount ExactlyOne -Description 'T21 source preflight'
        $schoolCsv=Join-Path $workspace 'school.csv'
        $contextCsv=Join-Path $workspace 'context.csv'
        $null=Export-BauQueryToCsv -Source $source -SqlFile (Get-SchemaPath 'establishment/transforms/establishment-from-bau.sql') `
            -Variables @{URN=124870} -Columns $script:EstablishmentFixtureColumns -CsvPath $schoolCsv -RowCount ExactlyOne -Description 'T21 school'
        $null=Export-BauQueryToCsv -Source $source -SqlFile (Get-SchemaPath 'establishment/transforms/controlled-proprietor-context-from-bau.sql') `
            -Variables @{URNS=124870} -CsvPath $contextCsv -RowCount ExactlyOne -Description 'T21 obfuscated proprietor context'
        $loadSql=''
        foreach($load in @(
          @{Path='establishment/load/load-establishment-fixture.sql';Csv=$schoolCsv},
          @{Path='establishment/load/load-controlled-proprietor-fixture.sql';Csv=$contextCsv}
        )) {
          $sql=(Get-Content -LiteralPath (Get-SchemaPath $load.Path) -Raw -Encoding UTF8).Replace('__FIXTURE_PATH__',($load.Csv -replace '\\','/')).
            Replace('__CONTROLLED_PROPRIETOR_JSON__',($fixture | ConvertTo-Json -Depth 6 -Compress).Replace("'","''"))
          $loadSql += [regex]::Replace($sql,'(?m)^(BEGIN|COMMIT);\r?$','') + "`n"
        }
        $validation=Get-Content -LiteralPath (Get-SchemaPath 'establishment/validate-t21-partnership-proprietor.sql') -Raw
        $runId=[guid]::NewGuid()
        $runSql="INSERT INTO migration.migration_run(migration_run_id,run_type,source_system,source_database,source_snapshot_date,status,transform_version,notes) VALUES('$runId','t21-additive','GIAS BAU','gias_bau_test_local',CURRENT_DATE,'running','t21-v1','Controlled traditional partnership assumption, not verified registered identity.') ON CONFLICT DO NOTHING; SELECT set_config('epr.migration_run_id','$runId',true);"
        $preservedSql="SELECT coalesce(string_agg(urn::text || ':' || establishment_id::text,',' ORDER BY urn),'') FROM establishment.establishment WHERE urn<>124870;"
        $before=Invoke-Psql -Target $target -Command $preservedSql -Output Scalar -FailureMessage 'T21 scope check failed'
        $path=Join-Path $workspace 'load.sql'
        foreach($ending in @('ROLLBACK','COMMIT')) {
          $batch="BEGIN;`n"+$runSql+$loadSql+$validation+"`nUPDATE migration.migration_run SET status='completed',completed_at=now() WHERE migration_run_id='$runId';`n$ending;"
          [IO.File]::WriteAllText($path,$batch,[Text.UTF8Encoding]::new($false))
          Invoke-Psql -Target $target -File $path -FailureMessage "T21 atomic $ending load failed"
        }
        $stateSql=@'
SELECT json_build_object(
 'schools',(SELECT string_agg(establishment_id::text,',' ORDER BY establishment_id) FROM establishment.establishment),
 'parties',(SELECT string_agg(legal_entity_id::text,',' ORDER BY legal_entity_id) FROM establishment.legal_entity),
 'people',(SELECT count(*) FROM establishment.person),
 'roles',(SELECT string_agg(establishment_party_role_id::text,',' ORDER BY establishment_party_role_id) FROM establishment.establishment_party_role),
 'responsibilities',(SELECT string_agg(establishment_responsibility_id::text,',' ORDER BY establishment_responsibility_id) FROM establishment.establishment_responsibility),
 'identifiers',(SELECT count(*) FROM establishment.organisation_identifier)+(SELECT count(*) FROM establishment.group_identifier))::text;
'@
        $first=Invoke-Psql -Target $target -Command $stateSql -Output Scalar -FailureMessage 'T21 identity check failed'
        Invoke-Psql -Target $target -File $path -FailureMessage 'T21 repeat import failed'
        $second=Invoke-Psql -Target $target -Command $stateSql -Output Scalar -FailureMessage 'T21 repeated identity check failed'
        if($first -cne $second){throw 'T21 repeat import changed business identities or counts.'}
        $after=Invoke-Psql -Target $target -Command $preservedSql -Output Scalar -FailureMessage 'T21 preserved scope check failed'
        if($before -cne $after){throw 'T21 changed unrelated establishment scope or identities.'}
        Write-Host 'T21 migrated and validated; one controlled partnership proprietor, unknown responsibility dates and stable reimport.'
    } $source $target $workspace
}

finally {
    $resolvedWorkspace=[System.IO.Path]::GetFullPath($workspace)
    $tempRoot=[System.IO.Path]::GetFullPath([System.IO.Path]::GetTempPath())
    if (-not $resolvedWorkspace.StartsWith($tempRoot,[StringComparison]::OrdinalIgnoreCase) -or
        (Split-Path -Leaf $resolvedWorkspace) -notlike 'epr-local-run-*') {
        throw 'Refusing cleanup outside the migration temporary directory.'
    }
    Remove-RunWorkspace -Path $resolvedWorkspace
}
