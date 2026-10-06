# Loading data from the local BAU SQL Server copy. Each import follows the same
# two steps: a transform SQL file reads BAU into a CSV fixture, then a load SQL
# file loads the fixture into PostgreSQL.

# Geographic reference datasets, loaded in this order. Each dataset has a
# transform in establishment/transforms and a load in establishment/load.
$script:GeographicDatasets = @(
    [pscustomobject]@{ Name = 'local-authority';             Transform = 'local-authorities-from-bau.sql';             Load = 'load-local-authority-fixture.sql' }
    [pscustomobject]@{ Name = 'government-office-region';    Transform = 'government-office-regions-from-bau.sql';     Load = 'load-government-office-region-fixture.sql' }
    [pscustomobject]@{ Name = 'district-administrative';     Transform = 'district-administratives-from-bau.sql';      Load = 'load-district-administrative-fixture.sql' }
    [pscustomobject]@{ Name = 'administrative-ward';         Transform = 'administrative-wards-from-bau.sql';          Load = 'load-administrative-ward-fixture.sql' }
    [pscustomobject]@{ Name = 'parliamentary-constituency';  Transform = 'parliamentary-constituencies-from-bau.sql';  Load = 'load-parliamentary-constituency-fixture.sql' }
    [pscustomobject]@{ Name = 'lsoa';                        Transform = 'lsoas-from-bau.sql';                         Load = 'load-lsoa-fixture.sql' }
    [pscustomobject]@{ Name = 'msoa';                        Transform = 'msoas-from-bau.sql';                         Load = 'load-msoa-fixture.sql' }
    [pscustomobject]@{ Name = 'urban-rural';                 Transform = 'urban-rurals-from-bau.sql';                  Load = 'load-urban-rural-fixture.sql' }
    [pscustomobject]@{ Name = 'gss-local-authority-code';    Transform = 'gss-local-authority-codes-from-bau.sql';     Load = 'load-gss-local-authority-code-fixture.sql' }
    [pscustomobject]@{ Name = 'local-authority-gss-mapping'; Transform = 'local-authority-gss-mappings-from-bau.sql';  Load = 'load-local-authority-gss-mapping-fixture.sql' }
    [pscustomobject]@{ Name = 'local-authority-gor-mapping'; Transform = 'local-authority-gor-mappings-from-bau.sql';  Load = 'load-local-authority-gor-mapping-fixture.sql' }
)

# The establishment transform returns more columns than the load uses. These
# are the transform's column names, in the column order of the load SQL's
# source_establishment_fixture table. Reference values are passed as the target
# IDs the transform has already mapped, so the mapping lives only in the
# transform SQL.
$script:EstablishmentFixtureColumns = @(
    'urn', 'ukprn', 'local_authority_code', 'government_office_region_code',
    'district_administrative_code', 'administrative_ward_code',
    'parliamentary_constituency_code', 'lsoa_code', 'msoa_code', 'urban_rural_code',
    'establishment_number', 'name', 'website', 'telephone_number',
    'source_establishment_status_code', 'open_date', 'close_date',
    'source_reason_establishment_opened_code', 'reason_establishment_opened',
    'source_reason_establishment_closed_code', 'reason_establishment_closed',
    'last_changed_date', 'establishment_type_id', 'education_phase_id',
    'school_capacity', 'pupil_count', 'free_school_meal_measure',
    'resourced_provision_capacity', 'resourced_provision_pupil_count',
    'sen_unit_capacity', 'sen_unit_pupil_count',
    'lower_statutory_age', 'upper_statutory_age',
    'gender_of_entry_type_id', 'admissions_policy_id', 'boarding_provision_id',
    'nursery_provision_id', 'sixth_form_provision_id',
    'specialist_provision_type_id',
    'main_site_name', 'address_line_1', 'address_line_2', 'address_line_3',
    'address_town', 'address_county', 'address_postcode', 'site_uprn'
)

function Import-GeographicReferenceData {
    <#
    .SYNOPSIS
    Loads the complete geographic reference data from the local BAU copy: local
    authorities, regions, districts, wards, constituencies, LSOAs, MSOAs,
    urban/rural classes, GSS codes and the local-authority mappings.
    #>
    param(
        [Parameter(Mandatory)]$Source,
        [Parameter(Mandatory)]$Target,
        [Parameter(Mandatory)][string]$WorkingDirectory
    )

    foreach ($dataset in $script:GeographicDatasets) {
        Write-Step "Loading geographic reference data: $($dataset.Name)"
        $csvPath = Join-Path $WorkingDirectory "$($dataset.Name).csv"
        $rows = Export-BauQueryToCsv -Source $Source `
            -SqlFile (Get-SchemaPath "establishment/transforms/$($dataset.Transform)") `
            -CsvPath $csvPath -RowCount 'AtLeastOne' -Description "geographic dataset $($dataset.Name)"
        Invoke-FixtureLoad -Target $Target -LoadSqlFile (Get-SchemaPath "establishment/load/$($dataset.Load)") `
            -CsvPath $csvPath -WorkingDirectory $WorkingDirectory -Description "geographic dataset $($dataset.Name)"
        Write-Host "    $rows rows loaded."
    }
}

function Import-EstablishmentFromBau {
    <#
    .SYNOPSIS
    Loads one establishment, with its geography, contact, lifecycle, main site,
    measures and provision, from the local BAU copy.
    #>
    param(
        [Parameter(Mandatory)]$Source,
        [Parameter(Mandatory)]$Target,
        [Parameter(Mandatory)][ValidateRange(1, 999999)][int]$Urn,
        [Parameter(Mandatory)][string]$WorkingDirectory
    )

    Write-Step "Loading establishment URN $Urn"
    $csvPath = Join-Path $WorkingDirectory "establishment-$Urn.csv"
    Export-BauQueryToCsv -Source $Source `
        -SqlFile (Get-SchemaPath 'establishment/transforms/establishment-from-bau.sql') `
        -Variables @{ URN = $Urn } -CsvPath $csvPath -Columns $script:EstablishmentFixtureColumns `
        -RowCount 'ExactlyOne' -Description "establishment URN $Urn" | Out-Null
    Invoke-FixtureLoad -Target $Target -LoadSqlFile (Get-SchemaPath 'establishment/load/load-establishment-fixture.sql') `
        -CsvPath $csvPath -WorkingDirectory $WorkingDirectory -Description "establishment URN $Urn"
}

function Import-EstablishmentPartyRoleFromBau {
    <#
    .SYNOPSIS
    Loads one BAU group link for an establishment as a legal entity, its
    establishment-party role and classification, its group identifiers and the
    establishment responsibility.
    .PARAMETER IncludeArchived
    Also accept an archived link, for historical links such as a former SAT.
    #>
    param(
        [Parameter(Mandatory)]$Source,
        [Parameter(Mandatory)]$Target,
        [Parameter(Mandatory)][ValidateRange(1, 999999)][int]$Urn,
        [Parameter(Mandatory)][ValidateRange(1, 999999999)][int]$SourceGroupId,
        [switch]$IncludeArchived,
        [Parameter(Mandatory)][string]$WorkingDirectory,
        [guid]$MigrationRunId = [guid]::Empty
    )

    Write-Step "Loading establishment-party link: URN $Urn, source group $SourceGroupId"
    $description = "URN $Urn and source group $SourceGroupId"
    $includeArchivedFlag = 0
    if ($IncludeArchived) { $includeArchivedFlag = 1 }
    $csvPath = Join-Path $WorkingDirectory "establishment-party-$Urn-$SourceGroupId.csv"
    Export-BauQueryToCsv -Source $Source `
        -SqlFile (Get-SchemaPath 'establishment/transforms/academy-trust-responsibility-from-bau.sql') `
        -Variables @{ URN = $Urn; GROUP_ID = $SourceGroupId; INCLUDE_ARCHIVED = $includeArchivedFlag } `
        -CsvPath $csvPath -RowCount 'ExactlyOne' -Description $description | Out-Null
    Invoke-FixtureLoad -Target $Target -LoadSqlFile (Get-SchemaPath 'establishment/load/load-academy-trust-responsibility-fixture.sql') `
        -CsvPath $csvPath -WorkingDirectory $WorkingDirectory -Description $description -MigrationRunId $MigrationRunId
}

function Import-OrganisationGroupFromBau {
    <#
    .SYNOPSIS
    Loads a current federation or children's-centre group and its complete
    selected membership, including recorded authority and lead designation.
    #>
    param(
        [Parameter(Mandatory)]$Source,
        [Parameter(Mandatory)]$Target,
        [Parameter(Mandatory)][ValidateRange(1, 999999999)][int]$SourceGroupId,
        [Parameter(Mandatory)][int[]]$ExpectedMemberUrns,
        [Parameter(Mandatory)][string]$WorkingDirectory,
        [guid]$MigrationRunId = [guid]::Empty
    )
    Write-Step "Loading organisation group $SourceGroupId"
    $csvPath = Join-Path $WorkingDirectory "organisation-group-$SourceGroupId.csv"
    Export-BauQueryToCsv -Source $Source -SqlFile (Get-SchemaPath 'establishment/transforms/organisation-group-membership-from-bau.sql') `
        -Variables @{ GROUP_ID = $SourceGroupId } -CsvPath $csvPath -RowCount AtLeastOne -Description "organisation group $SourceGroupId" | Out-Null
    $memberUrns = @(Import-Csv -LiteralPath $csvPath -Delimiter '|' | ForEach-Object { [int]$_.establishment_urn })
    if ($memberUrns.Count -ne $ExpectedMemberUrns.Count -or
        (Compare-Object ($ExpectedMemberUrns | Sort-Object) ($memberUrns | Sort-Object))) {
        throw "Organisation group $SourceGroupId members differ from the approved selection."
    }
    Invoke-FixtureLoad -Target $Target -LoadSqlFile (Get-SchemaPath 'establishment/load/load-organisation-group-membership-fixture.sql') `
        -CsvPath $csvPath -WorkingDirectory $WorkingDirectory -Description "organisation group $SourceGroupId" -MigrationRunId $MigrationRunId
}

function Import-GovernanceFromBau {
    <#
    .SYNOPSIS
    Loads the current governance appointments and terms for one establishment
    into governance_local.
    #>
    param(
        [Parameter(Mandatory)]$Source,
        [Parameter(Mandatory)]$Target,
        [Parameter(Mandatory)][ValidateRange(1, 999999)][int]$Urn,
        [Parameter(Mandatory)][string]$WorkingDirectory
    )

    Write-Step "Loading governance appointments for URN $Urn"
    $csvPath = Join-Path $WorkingDirectory "governance-$Urn.csv"
    $rows = Export-BauQueryToCsv -Source $Source `
        -SqlFile (Get-SchemaPath 'governance/transforms/governance-appointment-from-bau.sql') `
        -Variables @{ URN = $Urn } -CsvPath $csvPath -RowCount 'Any' -Description "governance for URN $Urn"
    if ($rows -eq 0) { Write-Host "    No current governance appointments for URN $Urn; loading an empty fixture." }
    Invoke-FixtureLoad -Target $Target -LoadSqlFile (Get-SchemaPath 'governance/load/load-governance-appointment-fixture.sql') `
        -CsvPath $csvPath -WorkingDirectory $WorkingDirectory -Description "governance for URN $Urn"
    Write-Host "    $rows appointments loaded."
}
