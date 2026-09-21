/*
    Transform one BAU establishment source record into the current target
    Establishment model projection.

    Target engine: SQL Server

     It reads
    from dbo.Establishment and BAU lookup tables, then returns target-shaped
    values for the PostgreSQL model. It does not load the target database.

    Change @URN to transform another establishment.
*/

-- Supply URN with sqlcmd, for example: -v URN=106431
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
        e.type_code,
        et.name AS type_name,
        e.educationPhase_code,
        ep.name AS education_phase_name,
        e.gender_code,
        g.name AS gender_name,
        e.admissionsPolicy_code,
        e.boarders_code,
        e.nurseryProvision_code,
        e.officialSixthForm_code,
        e.SchoolCapacity,
        e.NumberOfPupils,
        e.freeSchoolMeals,
        e.percentageOfPupilsReceivingFsm,
        e.typeOfReservedProvision_code,
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
    WHERE e.URN = @URN
)
SELECT
    s.URN AS urn,
    s.UKPRN AS ukprn,
    s.LA_code AS local_authority_code,
    s.GOR_code AS government_office_region_code,
    s.districtAdministrative_code AS district_administrative_code,
    s.administrativeWard_code AS administrative_ward_code,
    s.parliamentaryConstituency_code AS parliamentary_constituency_code,
    s.lsoa_code AS lsoa_code,
    s.msoa_code AS msoa_code,
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
    s.type_name AS source_establishment_type,
    CASE
        WHEN s.type_name = 'Community school' THEN 1
        WHEN s.type_name IN ('Academy sponsor led', 'Academy converter') THEN 4
        WHEN s.type_name IN ('Academy special sponsor led', 'Academy special converter') THEN 5
        WHEN s.type_name IN ('Academy alternative provision sponsor led', 'Academy alternative provision converter') THEN 6
        WHEN s.type_name IN ('Academy 16-19 sponsor led', 'Academy 16 to 19 converter') THEN 7
        WHEN s.type_name = 'Academy secure 16 to 19' THEN 8
        ELSE NULL
    END AS establishment_type_id,
    CASE
        WHEN s.type_name IN ('Academy sponsor led', 'Academy converter') THEN 'Mainstream academy'
        WHEN s.type_name IN ('Academy special sponsor led', 'Academy special converter') THEN 'Academy special school'
        WHEN s.type_name IN ('Academy alternative provision sponsor led', 'Academy alternative provision converter') THEN 'Academy alternative provision'
        WHEN s.type_name IN ('Academy 16-19 sponsor led', 'Academy 16 to 19 converter') THEN 'Academy 16 to 19'
        ELSE s.type_name
    END AS establishment_type,
    s.educationPhase_code AS source_education_phase_code,
    s.education_phase_name AS source_education_phase,
    CASE s.education_phase_name
        WHEN 'Nursery' THEN 1
        WHEN 'Primary' THEN 2
        WHEN 'Middle deemed primary' THEN 3
        WHEN 'Middle deemed secondary' THEN 4
        WHEN 'Secondary' THEN 5
        WHEN 'All-through' THEN 6
        WHEN '16 to 19' THEN 7
        WHEN 'Not applicable' THEN 8
        WHEN 'Not applicable (education phase)' THEN 8
        ELSE NULL
    END AS education_phase_id,
    CASE
        WHEN s.education_phase_name = 'Not applicable' THEN 'Not applicable (education phase)'
        ELSE s.education_phase_name
    END AS education_phase,
    s.gender_code AS source_gender_code,
    s.gender_name AS source_gender,
    CASE s.gender_name
        WHEN 'Mixed' THEN 1
        WHEN 'Boys' THEN 2
        WHEN 'Girls' THEN 3
        WHEN 'Not applicable' THEN 4
        WHEN 'Not applicable (gender of entry)' THEN 4
        ELSE NULL
    END AS gender_of_entry_type_id,
    CASE
        WHEN s.gender_name = 'Not applicable' THEN 'Not applicable (gender of entry)'
        ELSE s.gender_name
    END AS gender_of_entry,
    s.admissionsPolicy_code AS source_admissions_policy_code,
    CASE
        WHEN s.admissionsPolicy_code = '1' THEN 'Comprehensive (secondary)'
        WHEN s.admissionsPolicy_code = '2' THEN 'Selective (grammar)'
        WHEN s.admissionsPolicy_code = '4' THEN 'Non-selective'
        WHEN s.admissionsPolicy_code IN ('0', '9') THEN 'Not applicable'
        ELSE NULL
    END AS source_admissions_policy,
    CASE
        WHEN s.admissionsPolicy_code IN ('1', '4') THEN 1
        WHEN s.admissionsPolicy_code = '2' THEN 2
        WHEN s.admissionsPolicy_code IN ('0', '9') THEN 3
        ELSE NULL
    END AS admissions_policy_id,
    CASE
        WHEN s.admissionsPolicy_code IN ('1', '4') THEN 'Non-selective'
        WHEN s.admissionsPolicy_code = '2' THEN 'Selective'
        WHEN s.admissionsPolicy_code IN ('0', '9') THEN 'Not applicable (admissions policy)'
        ELSE NULL
    END AS admissions_policy,
    s.boarders_code AS source_boarding_provision_code,
    CASE
        WHEN s.boarders_code = '0' THEN 'Not applicable'
        WHEN s.boarders_code = '1' THEN 'No boarders'
        WHEN s.boarders_code = '2' THEN 'Children''s home (Boarding school)'
        WHEN s.boarders_code = '3' THEN 'Boarding school'
        WHEN s.boarders_code = '4' THEN 'College / FE residential accommodation'
        WHEN s.boarders_code = '9' THEN 'Not recorded'
        ELSE NULL
    END AS source_boarding_provision,
    CASE
        WHEN s.boarders_code = '1' THEN 1
        WHEN s.boarders_code = '4' THEN 2
        WHEN s.boarders_code IN ('2', '3') THEN 3
        ELSE NULL
    END AS boarding_provision_id,
    CASE
        WHEN s.boarders_code = '1' THEN 'No boarders'
        WHEN s.boarders_code = '4' THEN 'Has boarders'
        WHEN s.boarders_code IN ('2', '3') THEN 'Boarding school'
        ELSE NULL
    END AS boarding_provision,
    s.nurseryProvision_code AS source_nursery_provision_code,
    CASE
        WHEN s.nurseryProvision_code = '0' THEN 'Not applicable'
        WHEN s.nurseryProvision_code = '1' THEN 'Has Nursery Classes'
        WHEN s.nurseryProvision_code = '2' THEN 'No Nursery Classes'
        WHEN s.nurseryProvision_code = '9' THEN 'Not recorded'
        ELSE NULL
    END AS source_nursery_provision,
    CASE
        WHEN s.nurseryProvision_code = '1' THEN 1
        WHEN s.nurseryProvision_code = '2' THEN 2
        WHEN s.nurseryProvision_code = '0' THEN 3
        ELSE NULL
    END AS nursery_provision_id,
    CASE
        WHEN s.nurseryProvision_code = '1' THEN 'Nursery classes'
        WHEN s.nurseryProvision_code = '2' THEN 'No nursery classes'
        WHEN s.nurseryProvision_code = '0' THEN 'Not applicable (nursery provision)'
        ELSE NULL
    END AS nursery_provision,
    s.officialSixthForm_code AS source_sixth_form_provision_code,
    CASE
        WHEN s.officialSixthForm_code = '0' THEN 'Not applicable'
        WHEN s.officialSixthForm_code = '1' THEN 'Has a sixth form'
        WHEN s.officialSixthForm_code = '2' THEN 'Does not have a sixth form'
        WHEN s.officialSixthForm_code = '9' THEN 'Not recorded'
        ELSE NULL
    END AS source_sixth_form_provision,
    CASE
        WHEN s.officialSixthForm_code = '1' THEN 1
        WHEN s.officialSixthForm_code = '2' THEN 2
        WHEN s.officialSixthForm_code = '0' THEN 3
        ELSE NULL
    END AS sixth_form_provision_id,
    CASE
        WHEN s.officialSixthForm_code = '1' THEN 'Sixth form'
        WHEN s.officialSixthForm_code = '2' THEN 'No sixth form'
        WHEN s.officialSixthForm_code = '0' THEN 'Not applicable (sixth-form provision)'
        ELSE NULL
    END AS sixth_form_provision,
    s.SchoolCapacity AS school_capacity,
    TRY_CONVERT(integer, NULLIF(REPLACE(LTRIM(RTRIM(s.NumberOfPupils)), ',', ''), '')) AS pupil_count,
    TRY_CONVERT(integer, NULLIF(REPLACE(LTRIM(RTRIM(s.freeSchoolMeals)), ',', ''), '')) AS free_school_meal_measure,
    TRY_CONVERT(decimal(5, 2), NULLIF(REPLACE(LTRIM(RTRIM(s.percentageOfPupilsReceivingFsm)), ',', ''), ''))
        AS source_free_school_meal_percentage,
    CAST(NULL AS date) AS census_date,
    s.typeOfReservedProvision_code AS source_specialist_provision_type_code,
    CASE
        WHEN s.typeOfReservedProvision_code = '0' THEN 'Not applicable'
        WHEN s.typeOfReservedProvision_code = '1' THEN 'Resource Provision'
        WHEN s.typeOfReservedProvision_code = '2' THEN 'SEN Unit'
        WHEN s.typeOfReservedProvision_code = '3' THEN 'Resource Provision and SEN Unit'
        WHEN s.typeOfReservedProvision_code = '9' THEN 'Not recorded'
        ELSE NULL
    END AS source_specialist_provision_type,
    CASE
        WHEN s.typeOfReservedProvision_code = '1' THEN 1
        WHEN s.typeOfReservedProvision_code = '2' THEN 2
        WHEN s.typeOfReservedProvision_code = '3' THEN 3
        ELSE NULL
    END AS specialist_provision_type_id,
    CASE
        WHEN s.typeOfReservedProvision_code = '1' THEN 'Resourced provision'
        WHEN s.typeOfReservedProvision_code = '2' THEN 'SEN unit'
        WHEN s.typeOfReservedProvision_code = '3' THEN 'Resourced provision and SEN unit'
        ELSE NULL
    END AS specialist_provision_type,
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
    s.UPRN AS site_uprn
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
WHERE a.URN = @URN
ORDER BY a.record_number;
