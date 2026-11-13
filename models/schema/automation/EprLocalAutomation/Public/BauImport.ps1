# Loading data from the local BAU SQL Server copy. Each import follows the same
# two steps: a transform SQL file reads BAU into a CSV fixture, then a load SQL
# file loads the fixture into PostgreSQL.

# Geographic reference datasets, loaded in this order. Each dataset has a
# transform in establishment/transforms and a load in establishment/load.
$script:GeographicDatasets = @(
    [pscustomobject]@{ Name = 'local-authority';             Transform = 'local-authority-areas-from-bau.sql';             Load = 'load-local-authority-area-fixture.sql' }
    [pscustomobject]@{ Name = 'government-office-region';    Transform = 'government-office-regions-from-bau.sql';     Load = 'load-government-office-region-fixture.sql' }
    [pscustomobject]@{ Name = 'district-administrative';     Transform = 'district-administratives-from-bau.sql';      Load = 'load-district-administrative-fixture.sql' }
    [pscustomobject]@{ Name = 'administrative-ward';         Transform = 'administrative-wards-from-bau.sql';          Load = 'load-administrative-ward-fixture.sql' }
    [pscustomobject]@{ Name = 'parliamentary-constituency';  Transform = 'parliamentary-constituencies-from-bau.sql';  Load = 'load-parliamentary-constituency-fixture.sql' }
    [pscustomobject]@{ Name = 'lsoa';                        Transform = 'lsoas-from-bau.sql';                         Load = 'load-lsoa-fixture.sql' }
    [pscustomobject]@{ Name = 'msoa';                        Transform = 'msoas-from-bau.sql';                         Load = 'load-msoa-fixture.sql' }
    [pscustomobject]@{ Name = 'urban-rural';                 Transform = 'urban-rurals-from-bau.sql';                  Load = 'load-urban-rural-fixture.sql' }
    [pscustomobject]@{ Name = 'gss-local-authority-code';    Transform = 'gss-local-authority-codes-from-bau.sql';     Load = 'load-gss-local-authority-code-fixture.sql' }
    [pscustomobject]@{ Name = 'local-authority-gss-mapping'; Transform = 'local-authority-area-gss-mappings-from-bau.sql';  Load = 'load-local-authority-area-gss-mapping-fixture.sql' }
    [pscustomobject]@{ Name = 'local-authority-gor-mapping'; Transform = 'local-authority-area-gor-mappings-from-bau.sql';  Load = 'load-local-authority-area-gor-mapping-fixture.sql' }
)

# The establishment transform returns more columns than the load uses. These
# are the transform's column names, in the column order of the load SQL's
# source_establishment_fixture table. Reference values are resolved in PostgreSQL
# from the imported dictionaries and original source business codes.
$script:EstablishmentFixtureColumns = @(
    'urn', 'ukprn', 'local_authority_code', 'government_office_region_code',
    'district_administrative_code', 'administrative_ward_code',
    'parliamentary_constituency_code', 'lsoa_code', 'msoa_code', 'urban_rural_code',
    'establishment_number', 'name', 'website', 'telephone_number',
    'source_establishment_status_code', 'open_date', 'close_date',
    'source_reason_establishment_opened_code', 'reason_establishment_opened',
    'source_reason_establishment_closed_code', 'reason_establishment_closed',
    'last_changed_date', 'source_establishment_type_code', 'source_education_phase_code',
    'school_capacity', 'pupil_count', 'free_school_meal_measure', 'census_date',
    'resourced_provision_capacity', 'resourced_provision_pupil_count',
    'sen_unit_capacity', 'sen_unit_pupil_count',
    'lower_statutory_age', 'upper_statutory_age',
    'gender_of_entry_type_id', 'admissions_policy_id', 'boarding_provision_id',
    'nursery_provision_id', 'sixth_form_provision_id',
    'specialist_provision_type_id',
    'main_site_name', 'address_line_1', 'address_line_2', 'address_line_3',
    'address_town', 'address_county', 'address_postcode', 'site_uprn',
    'source_further_education_type_code', 'further_education_type_id',
    'source_section_41_approval_status_code', 'section_41_approval_status_id',
    'source_religious_character_code', 'religious_character_id',
    'source_religious_ethos_code', 'religious_ethos_id',
    'source_diocese_code', 'source_diocese_id', 'source_education_phase', 'ofsted_link',
    'source_specialist_provision_type_code', 'source_special_classes_code', 'has_special_classes', 'source_observed_date',
    'source_establishment_type_category_code',
    'source_admissions_policy_code','source_boarding_provision_code',
    'source_nursery_provision_code','source_sixth_form_provision_code'
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
        [Parameter(Mandatory)][string]$WorkingDirectory,
        [switch]$EstablishmentsOnly
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
    if (-not $EstablishmentsOnly) { Import-LocalAuthorityCouncilFixture -Target $Target }
}

function Import-OrganisationGroupFromBau {
    # Uses the ordinary group-membership fixture loader, but is called only for
    # successfully seeded establishment URNs by the development relationship path.
    param(
        [Parameter(Mandatory)]$Source,[Parameter(Mandatory)]$Target,
        [Parameter(Mandatory)][ValidateRange(1,999999999)][int]$SourceGroupId,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][ValidateRange(1,999999)][int[]]$ExpectedMemberUrns,
        [switch]$SelectedMembersOnly,[Parameter(Mandatory)][string]$WorkingDirectory,
        [guid]$MigrationRunId=[guid]::Empty
    )
    $csvPath=Join-Path $WorkingDirectory "development-organisation-group-$SourceGroupId.csv"
    Export-BauQueryToCsv -Source $Source -SqlFile (Get-SchemaPath 'establishment/transforms/organisation-group-membership-from-bau.sql') `
        -Variables @{ GROUP_ID=$SourceGroupId; SELECTED_MEMBERS_ONLY=[int][bool]$SelectedMembersOnly
            MEMBER_URN_VALUES=(($ExpectedMemberUrns | ForEach-Object {'('+[string][int]$_+')'}) -join ',') } `
        -CsvPath $csvPath -RowCount AtLeastOne -Description "development organisation group $SourceGroupId" | Out-Null
    Invoke-FixtureLoad -Target $Target -LoadSqlFile (Get-SchemaPath 'establishment/load/load-organisation-group-membership-fixture.sql') `
        -CsvPath $csvPath -WorkingDirectory $WorkingDirectory -Description "development organisation group $SourceGroupId" -MigrationRunId $MigrationRunId `
        -TemplateValues @{ MEMBERSHIP_SCOPE='selected-urns' }
}
