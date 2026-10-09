<#
.SYNOPSIS
Adds T19R's complete seven-centre Hazelbury children's-centre group without rebuilding.
.DESCRIPTION
Reader-authenticated source preflight precedes target writes. The real loaders
run in one rollback probe and then one committed transaction. Repeat import
checks business identities. Default fixture selection and seeds are unchanged.
#>
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
        $null=Export-BauQueryToCsv -Source $source -SqlFile (Get-SchemaPath 'establishment/transforms/t19r-source-preflight.sql') `
            -CsvPath (Join-Path $workspace 'preflight.csv') -RowCount AtLeastOne -Description 'T19R reviewed source assertions'
        $schoolCsv=Join-Path $workspace 't19r-schools.csv'
        $groupCsv=Join-Path $workspace 't19r-group.csv'
        $lines=[System.Collections.Generic.List[string]]::new()
        foreach($urn in @(20048,20575,21240,21423,21425,21547,22423)) {
            $csv=Join-Path $workspace "$urn.csv"
            $null=Export-BauQueryToCsv -Source $source -SqlFile (Get-SchemaPath 'establishment/transforms/establishment-from-bau.sql') `
                -Variables @{URN=$urn} -Columns $script:EstablishmentFixtureColumns -CsvPath $csv `
                -RowCount ExactlyOne -Description "T19R school $urn"
            $sourceLines=[System.IO.File]::ReadAllLines($csv)
            if($lines.Count -eq 0){$lines.Add($sourceLines[0])}
            else {if($sourceLines[0] -cne $lines[0]){throw 'T19R school extract headers differ.'}}
            foreach($line in $sourceLines | Select-Object -Skip 1){$lines.Add($line)}
        }
        [System.IO.File]::WriteAllLines($schoolCsv,$lines,[System.Text.UTF8Encoding]::new($false))
        $rows=Export-BauQueryToCsv -Source $source -SqlFile (Get-SchemaPath 'establishment/transforms/organisation-group-membership-from-bau.sql') `
            -Variables @{GROUP_ID=86008;SELECTED_MEMBERS_ONLY=0;MEMBER_URN_VALUES='(20048),(20575),(21240),(21423),(21425),(21547),(22423)'} `
            -CsvPath $groupCsv -RowCount AtLeastOne -Description 'T19R complete childrens-centre group'
        if($rows -ne 7){throw 'T19R requires exactly seven source members.'}
        $loadSql=''
        foreach($load in @(
            @{Path='establishment/load/load-establishment-fixture.sql';Csv=$schoolCsv},
            @{Path='establishment/load/load-organisation-group-membership-fixture.sql';Csv=$groupCsv}
        )) {
            $sql=(Get-Content -LiteralPath (Get-SchemaPath $load.Path) -Raw).Replace('__FIXTURE_PATH__',($load.Csv -replace '\\','/'))
            $sql=$sql.Replace('__MEMBERSHIP_SCOPE__','all-current-source-members')
            $loadSql += [regex]::Replace($sql,'(?m)^(BEGIN|COMMIT);\r?$','') + "`n"
        }
        $validationSql=Get-Content -LiteralPath (Get-SchemaPath 'establishment/validate-t19r-hazelbury.sql') -Raw
        $preservedSql="SELECT coalesce(string_agg(urn::text || ':' || establishment_id::text,',' ORDER BY urn),'') FROM establishment.establishment WHERE urn NOT IN(20048,20575,21240,21423,21425,21547,22423);"
        $before=Invoke-Psql -Target $target -Command $preservedSql -Output Scalar -FailureMessage 'T19R existing scope check failed'
        $path=Join-Path $workspace 't19r-load.sql'
        foreach($ending in @('ROLLBACK','COMMIT')) {
            [System.IO.File]::WriteAllText($path,"BEGIN;`n"+$loadSql+$validationSql+"`n$ending;",[System.Text.UTF8Encoding]::new($false))
            Invoke-Psql -Target $target -File $path -FailureMessage "T19R atomic $ending load failed"
        }
        $stateSql=@'
SELECT json_build_object(
 'schools',(SELECT string_agg(establishment_id::text,',' ORDER BY establishment_id) FROM establishment.establishment),
 'groups',(SELECT string_agg(organisation_group_id::text,',' ORDER BY organisation_group_id) FROM establishment.organisation_group),
 'members',(SELECT string_agg(organisation_group_member_id::text,',' ORDER BY organisation_group_member_id) FROM establishment.organisation_group_member),
 'identifiers',(SELECT string_agg(group_identifier_id::text,',' ORDER BY group_identifier_id) FROM establishment.group_identifier),
 'parties',(SELECT string_agg(legal_entity_id::text,',' ORDER BY legal_entity_id) FROM establishment.legal_entity),
 'roles',(SELECT string_agg(establishment_party_role_id::text,',' ORDER BY establishment_party_role_id) FROM establishment.establishment_party_role),
 'lead_periods',(SELECT string_agg(organisation_group_member_lead_period_id::text,',' ORDER BY organisation_group_member_lead_period_id) FROM establishment.organisation_group_member_lead_period),
 'responsibilities',(SELECT string_agg(establishment_responsibility_id::text,',' ORDER BY establishment_responsibility_id) FROM establishment.establishment_responsibility))::text;
'@
        $first=Invoke-Psql -Target $target -Command $stateSql -Output Scalar -FailureMessage 'T19R identity check failed'
        Invoke-Psql -Target $target -File $path -FailureMessage 'T19R repeat import failed'
        $second=Invoke-Psql -Target $target -Command $stateSql -Output Scalar -FailureMessage 'T19R repeated identity check failed'
        if($first -cne $second){throw 'T19R repeat import changed business identities or counts.'}
        $after=Invoke-Psql -Target $target -Command $preservedSql -Output Scalar -FailureMessage 'T19R preserved scope check failed'
        if($before -cne $after){throw 'T19R changed unrelated establishment scope or identities.'}
        Write-Host 'T19R migrated and validated; seven members and Enfield authority retained, one current lead with unknown business dates, stable reimport.'
    } $source $target $workspace
}
finally {
    $resolvedWorkspace=[System.IO.Path]::GetFullPath($workspace)
    $tempRoot=[System.IO.Path]::GetFullPath([System.IO.Path]::GetTempPath())
    if(-not $resolvedWorkspace.StartsWith($tempRoot,[StringComparison]::OrdinalIgnoreCase) -or
       (Split-Path -Leaf $resolvedWorkspace) -notlike 'epr-local-run-*'){
        throw 'Refusing cleanup outside the migration temporary directory.'
    }
    Remove-RunWorkspace -Path $resolvedWorkspace
}
