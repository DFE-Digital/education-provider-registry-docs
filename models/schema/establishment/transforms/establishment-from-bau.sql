/*
    Transform one BAU establishment source record into the current target
    Establishment model projection.

    Target engine: SQL Server

     It reads
    from dbo.Establishment and BAU lookup tables, then returns target-shaped
    values for the PostgreSQL model. It does not load the target database.

    Change @URN to transform another establishment.
*/

-- Supply URN with sqlcmd, for example: -v URN=136102
DECLARE @URN numeric(19, 0) = $(URN);

WITH source_establishment AS (
    SELECT
        e.URN,
        e.UKPRN,
        e.LA_code,
        e.GOR_code,
        e.districtAdministrative_code,
        e.administrativeWard_code,
        e.parliamentaryConstituency_code,
        e.lsoa_code,
        e.msoa_code,
        e.UrbanRural_code,
        e.EstablishmentNumber,
        e.EstablishmentName,
        e.WebsiteAddress,
        e.TelephoneNumber,
        e.status_code,
        es.name AS establishment_status_name,
        e.OpenDate,
        e.CloseDate,
        e.reasonEstablishmentOpened_code,
        reo.name AS reason_establishment_opened_name,
        e.reasonEstablishmentClosed_code,
        rec.name AS reason_establishment_closed_name,
        e.lastChangedDate,
        NULLIF(LTRIM(RTRIM(e.type_code)), '') AS type_code,
        et.name AS type_name,
        et.group_code AS type_group_code,
        e.educationPhase_code,
        NULLIF(LTRIM(RTRIM(e.furtherEducationType_code)), '') AS furtherEducationType_code,
        NULLIF(LTRIM(RTRIM(e.section41Approved_code)), '') AS section41Approved_code,
        NULLIF(LTRIM(RTRIM(e.religiousCharacter_code)), '') AS religiousCharacter_code,
        NULLIF(LTRIM(RTRIM(e.religiousEthos_code)), '') AS religiousEthos_code,
        NULLIF(LTRIM(RTRIM(e.diocese_code)), '') AS diocese_code,
        ep.name AS education_phase_name,
        e.gender_code,
        g.name AS gender_name,
        e.admissionsPolicy_code,
        e.boarders_code,
        e.nurseryProvision_code,
        e.officialSixthForm_code,
        ap.name AS admissions_policy_name,
        b.name AS boarding_provision_name,
        np.name AS nursery_provision_name,
        sf.name AS sixth_form_provision_name,
        sp.name AS specialist_provision_type_name,
        e.SchoolCapacity,
        e.NumberOfPupils,
        e.freeSchoolMeals,
        e.percentageOfPupilsReceivingFsm,
        independent_school.CensusDate AS census_date,
        NULLIF(LTRIM(RTRIM(e.typeOfReservedProvision_code)), '') AS typeOfReservedProvision_code,
        NULLIF(LTRIM(RTRIM(e.specialClasses_code)), '') AS specialClasses_code,
        e.resourcedProvisionCapacity,
        e.resourcedProvisionOnRoll,
        e.senUnitCapacity,
        e.senUnitOnRoll,
        e.StatutoryLowAge,
        e.StatutoryHighAge,
        e.siteName,
        e.Street,
        e.Locality,
        e.Address3,
        e.Town,
        e.County_code,
        e.Postcode,
        e.UPRN
    FROM dbo.Establishment AS e
    -- BAU stores the census date here for academies and maintained schools too.
    -- Keep establishments with no corresponding row or no recorded date.
    LEFT JOIN dbo.IndependentSchools AS independent_school
      ON independent_school.URN = e.URN
    LEFT JOIN dbo.EstablishmentType AS et
      ON et.code = e.type_code
    LEFT JOIN dbo.EducationPhase AS ep
      ON ep.code = e.educationPhase_code
    LEFT JOIN dbo.Gender AS g
      ON g.code = e.gender_code
    LEFT JOIN dbo.EstablishmentStatus AS es
      ON es.code = e.status_code
    LEFT JOIN dbo.ReasonEstablishmentOpened AS reo
      ON reo.code = e.reasonEstablishmentOpened_code
    LEFT JOIN dbo.ReasonEstablishmentClosed AS rec
      ON rec.code = e.reasonEstablishmentClosed_code
    LEFT JOIN dbo.AdmissionsPolicy ap ON ap.code=e.admissionsPolicy_code
    LEFT JOIN dbo.Boarders b ON b.code=e.boarders_code
    LEFT JOIN dbo.NurseryProvision np ON np.code=e.nurseryProvision_code
    LEFT JOIN dbo.OfficialSixthForm sf ON sf.code=e.officialSixthForm_code
    LEFT JOIN dbo.TypeOfReservedProvision sp ON sp.code=e.typeOfReservedProvision_code
    WHERE e.status_code IN ('1','2','3') AND (@URN IS NULL OR e.URN = @URN)
)
SELECT
    s.URN AS urn,
    s.UKPRN AS ukprn,
    s.LA_code AS local_authority_code,
    CASE WHEN s.GOR_code IN ('N','Z') THEN NULL ELSE s.GOR_code END AS government_office_region_code,
    CASE WHEN s.districtAdministrative_code IN ('9999') THEN NULL ELSE s.districtAdministrative_code END AS district_administrative_code,
    CASE WHEN s.administrativeWard_code IN ('999999') THEN NULL ELSE s.administrativeWard_code END AS administrative_ward_code,
    CASE WHEN s.parliamentaryConstituency_code IN ('999') THEN NULL ELSE s.parliamentaryConstituency_code END AS parliamentary_constituency_code,
    CASE WHEN s.lsoa_code IN ('999999999','N99999999','S99999999') THEN NULL ELSE s.lsoa_code END AS lsoa_code,
    CASE WHEN s.msoa_code IN ('999999999','S99999999') THEN NULL ELSE s.msoa_code END AS msoa_code,
    CASE WHEN s.UrbanRural_code IN ('99') THEN NULL ELSE s.UrbanRural_code END AS urban_rural_code,
    s.EstablishmentNumber AS establishment_number,
    CASE
        WHEN s.LA_code IS NULL OR s.EstablishmentNumber IS NULL THEN NULL
        ELSE CONCAT(s.LA_code, '/', RIGHT(CONCAT('0000', CAST(s.EstablishmentNumber AS varchar(4))), 4))
    END AS dfe_number,
    s.EstablishmentName AS name,
    NULLIF(LTRIM(RTRIM(s.WebsiteAddress)), '') AS website,
    NULLIF(LTRIM(RTRIM(s.TelephoneNumber)), '') AS telephone_number,
    s.status_code AS source_establishment_status_code,
    s.establishment_status_name AS establishment_status,
    CONVERT(varchar(10), s.OpenDate, 23) AS open_date,
    CONVERT(varchar(10), s.CloseDate, 23) AS close_date,
    s.reasonEstablishmentOpened_code AS source_reason_establishment_opened_code,
    s.reason_establishment_opened_name AS reason_establishment_opened,
    s.reasonEstablishmentClosed_code AS source_reason_establishment_closed_code,
    s.reason_establishment_closed_name AS reason_establishment_closed,
    CONVERT(varchar(10), s.lastChangedDate, 23) AS last_changed_date,
    s.type_code AS source_establishment_type_code,
    s.type_group_code AS source_establishment_type_category_code,
    s.type_name AS source_establishment_type,
    -- Target type identities are resolved by code in the PostgreSQL loader.
    s.type_name AS establishment_type,
    s.educationPhase_code AS source_education_phase_code,
    s.education_phase_name AS source_education_phase,

    CASE
        WHEN s.education_phase_name IN ('Not applicable','Not applicable (education phase)','Unknown') THEN NULL
        ELSE s.education_phase_name
    END AS education_phase,
    s.gender_code AS source_gender_code,
    s.gender_name AS source_gender,
    CASE WHEN s.gender_code IN ('1','2','3') THEN CONVERT(integer, s.gender_code) END
        AS gender_of_entry_type_id,
    CASE
        WHEN s.gender_name IN ('Not applicable','Not applicable (gender of entry)','Unknown') THEN NULL
        ELSE s.gender_name
    END AS gender_of_entry,
    s.admissionsPolicy_code AS source_admissions_policy_code,
    s.admissions_policy_name AS source_admissions_policy,
    TRY_CONVERT(integer,s.admissionsPolicy_code) AS admissions_policy_id,
    s.admissions_policy_name AS admissions_policy,
    s.boarders_code AS source_boarding_provision_code,
    s.boarding_provision_name AS source_boarding_provision,
    TRY_CONVERT(integer,s.boarders_code) AS boarding_provision_id,
    s.boarding_provision_name AS boarding_provision,
    s.nurseryProvision_code AS source_nursery_provision_code,
    s.nursery_provision_name AS source_nursery_provision,
    TRY_CONVERT(integer,s.nurseryProvision_code) AS nursery_provision_id,
    s.nursery_provision_name AS nursery_provision,
    s.officialSixthForm_code AS source_sixth_form_provision_code,
    s.sixth_form_provision_name AS source_sixth_form_provision,
    TRY_CONVERT(integer,s.officialSixthForm_code) AS sixth_form_provision_id,
    s.sixth_form_provision_name AS sixth_form_provision,
    s.SchoolCapacity AS school_capacity,
    TRY_CONVERT(integer, NULLIF(REPLACE(LTRIM(RTRIM(s.NumberOfPupils)), ',', ''), '')) AS pupil_count,
    TRY_CONVERT(integer, NULLIF(REPLACE(LTRIM(RTRIM(s.freeSchoolMeals)), ',', ''), '')) AS free_school_meal_measure,
    TRY_CONVERT(decimal(5, 2), NULLIF(REPLACE(LTRIM(RTRIM(s.percentageOfPupilsReceivingFsm)), ',', ''), ''))
        AS source_free_school_meal_percentage,
    CONVERT(varchar(10), s.census_date, 23) AS census_date,
    s.typeOfReservedProvision_code AS source_specialist_provision_type_code,
    s.specialist_provision_type_name AS source_specialist_provision_type,
    TRY_CONVERT(integer,s.typeOfReservedProvision_code) AS specialist_provision_type_id,
    s.specialist_provision_type_name AS specialist_provision_type,
    s.resourcedProvisionCapacity AS resourced_provision_capacity,
    s.resourcedProvisionOnRoll AS resourced_provision_pupil_count,
    s.senUnitCapacity AS sen_unit_capacity,
    s.senUnitOnRoll AS sen_unit_pupil_count,
    s.StatutoryLowAge AS lower_statutory_age,
    s.StatutoryHighAge AS upper_statutory_age,
    s.siteName AS main_site_name,
    s.Street AS address_line_1,
    s.Locality AS address_line_2,
    s.Address3 AS address_line_3,
    s.Town AS address_town,
    s.County_code AS address_county,
    s.Postcode AS address_postcode,
    s.UPRN AS site_uprn,
    s.furtherEducationType_code AS source_further_education_type_code,
    TRY_CONVERT(integer,s.furtherEducationType_code) AS further_education_type_id,
    s.section41Approved_code AS source_section_41_approval_status_code,
    TRY_CONVERT(integer,s.section41Approved_code) AS section_41_approval_status_id,
    s.religiousCharacter_code AS source_religious_character_code,
    TRY_CONVERT(integer,s.religiousCharacter_code) AS religious_character_id,
    s.religiousEthos_code AS source_religious_ethos_code,
    TRY_CONVERT(integer,s.religiousEthos_code) AS religious_ethos_id,
    s.diocese_code AS source_diocese_code,
    CAST(NULL AS integer) AS source_diocese_id,
    -- A derived navigation link, not a copied inspection record or a claim
    -- that Ofsted has published a report for this URN.
    CONCAT('https://reports.ofsted.gov.uk/search?q=', CONVERT(varchar(6), s.URN)) AS ofsted_link,
    s.specialClasses_code AS source_special_classes_code,
    CASE s.specialClasses_code WHEN '1' THEN 'true' WHEN '2' THEN 'false'
         ELSE NULL END AS has_special_classes,
    CAST(SYSUTCDATETIME() AS date) AS source_observed_date
FROM source_establishment AS s;

/*
    Second result set: additional physical sites for the same establishment.
    The first result set is the establishment and main-site projection above;
    this result set is one row per dbo.EstablishmentAdditionalAddresses row.
*/
SELECT
    a.urn,
    a.record_number,
    a.siteName AS site_name,
    a.street AS address_line_1,
    a.locality AS address_line_2,
    a.address3 AS address_line_3,
    a.town AS address_town,
    a.county_code AS address_county,
    a.postcode AS address_postcode,
    a.uprn AS site_uprn,
    a.country_code,
    a.easting,
    a.northing
FROM dbo.EstablishmentAdditionalAddresses AS a
WHERE (@URN IS NULL OR a.URN = @URN)
  AND EXISTS (SELECT 1 FROM dbo.Establishment e WHERE e.URN=a.URN AND e.status_code IN ('1','2','3'))
ORDER BY a.record_number;
