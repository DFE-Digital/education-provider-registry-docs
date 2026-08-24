-- PostgreSQL target load for the controlled local migration fixture.
-- The PowerShell runner substitutes __FIXTURE_PATH__ with a local path before
-- invoking psql. This avoids Windows drive-letter parsing in psql variables.
-- The source extract is pipe-delimited CSV and has a header row.

BEGIN;

CREATE TEMP TABLE source_establishment_fixture (
    urn integer,
    ukprn numeric,
    local_authority_code text,
    establishment_number integer,
    name text,
    type_code text,
    education_phase_code text,
    school_capacity integer,
    pupil_count integer,
    free_school_meal_measure integer,
    resourced_provision_capacity integer,
    resourced_provision_pupil_count integer,
    sen_unit_capacity integer,
    sen_unit_pupil_count integer,
    lower_statutory_age integer,
    upper_statutory_age integer,
    gender_code text,
    admissions_policy_code text,
    boarders_code text,
    nursery_provision_code text,
    sixth_form_code text,
    reserved_provision_code text,
    main_site_name text,
    address_line_1 text,
    address_line_2 text,
    address_line_3 text,
    address_town text,
    address_county text,
    address_postcode text,
    address_uprn text
) ON COMMIT DROP;

\copy source_establishment_fixture FROM '__FIXTURE_PATH__' WITH (FORMAT csv, HEADER true, DELIMITER '|', NULL 'NULL')

-- Reference data is normally loaded by seed/seed-reference-data.sql. The
-- upserts make this fixture independently rerunnable without changing IDs.
INSERT INTO establishment.establishment_type (establishment_type_id, name) VALUES
    (1, 'Community school'), (4, 'Mainstream academy')
ON CONFLICT (establishment_type_id) DO UPDATE SET name = EXCLUDED.name;

INSERT INTO establishment.education_phase (education_phase_id, name) VALUES
    (2, 'Primary'), (5, 'Secondary')
ON CONFLICT (education_phase_id) DO UPDATE SET name = EXCLUDED.name;

INSERT INTO establishment.gender_of_entry_type (gender_of_entry_type_id, name) VALUES
    (1, 'Mixed'), (2, 'Boys'), (3, 'Girls'),
    (4, 'Not applicable (gender of entry)')
ON CONFLICT (gender_of_entry_type_id) DO UPDATE SET name = EXCLUDED.name;

INSERT INTO establishment.admissions_policy (admissions_policy_id, name) VALUES
    (1, 'Non-selective'), (3, 'Not applicable (admissions policy)')
ON CONFLICT (admissions_policy_id) DO UPDATE SET name = EXCLUDED.name;

INSERT INTO establishment.boarding_provision (boarding_provision_id, name) VALUES
    (1, 'No boarders'), (2, 'Has boarders'), (3, 'Boarding school')
ON CONFLICT (boarding_provision_id) DO UPDATE SET name = EXCLUDED.name;

INSERT INTO establishment.nursery_provision (nursery_provision_id, name) VALUES
    (1, 'Nursery classes'), (2, 'No nursery classes'),
    (3, 'Not applicable (nursery provision)')
ON CONFLICT (nursery_provision_id) DO UPDATE SET name = EXCLUDED.name;

INSERT INTO establishment.sixth_form_provision (sixth_form_provision_id, name) VALUES
    (2, 'No sixth form'), (3, 'Not applicable (sixth-form provision)')
ON CONFLICT (sixth_form_provision_id) DO UPDATE SET name = EXCLUDED.name;

INSERT INTO establishment.specialist_provision_type (specialist_provision_type_id, name)
VALUES (3, 'Resourced provision and SEN unit')
ON CONFLICT (specialist_provision_type_id) DO UPDATE SET name = EXCLUDED.name;

INSERT INTO establishment.establishment (
    urn, local_authority_code, establishment_number, ukprn, name,
    establishment_type_id, education_phase_id
)
SELECT
    s.urn,
    s.local_authority_code,
    s.establishment_number,
    s.ukprn,
    s.name,
    CASE WHEN s.type_code = '28' THEN 4 ELSE 1 END,
    CASE WHEN s.education_phase_code = '4' THEN 5 ELSE 2 END
FROM source_establishment_fixture AS s
ON CONFLICT (urn) DO UPDATE SET
    local_authority_code = EXCLUDED.local_authority_code,
    establishment_number = EXCLUDED.establishment_number,
    ukprn = EXCLUDED.ukprn,
    name = EXCLUDED.name,
    establishment_type_id = EXCLUDED.establishment_type_id,
    education_phase_id = EXCLUDED.education_phase_id;

INSERT INTO establishment.establishment_location (establishment_id)
SELECT e.establishment_id
FROM source_establishment_fixture AS s
JOIN establishment.establishment AS e ON e.urn = s.urn
ON CONFLICT (establishment_id) DO NOTHING;

CREATE TEMP TABLE source_main_site_fixture AS
SELECT el.establishment_location_id,
       COALESCE(ms.site_id, gen_random_uuid()) AS site_id,
       COALESCE(ms.address_id, gen_random_uuid()) AS address_id,
       s.main_site_name,
       s.address_line_1,
       s.address_line_2,
       s.address_line_3,
       s.address_town,
       s.address_county,
       s.address_postcode,
       s.address_uprn
FROM source_establishment_fixture AS s
JOIN establishment.establishment AS e ON e.urn = s.urn
JOIN establishment.establishment_location AS el
  ON el.establishment_id = e.establishment_id
LEFT JOIN establishment.site AS ms
  ON ms.establishment_location_id = el.establishment_location_id;

INSERT INTO establishment.address (
    address_id, address_line_1, address_line_2, address_line_3,
    town, county, postcode
)
SELECT address_id, address_line_1, address_line_2, address_line_3,
       address_town, address_county, address_postcode
FROM source_main_site_fixture
ON CONFLICT (address_id) DO UPDATE SET
    address_line_1 = EXCLUDED.address_line_1,
    address_line_2 = EXCLUDED.address_line_2,
    address_line_3 = EXCLUDED.address_line_3,
    town = EXCLUDED.town,
    county = EXCLUDED.county,
    postcode = EXCLUDED.postcode;

-- Keep the address reusable: Site owns the reference to Address.
INSERT INTO establishment.site (
    site_id, establishment_location_id, address_id, site_name, uprn
)
SELECT site_id, establishment_location_id, address_id, main_site_name,
       NULLIF(address_uprn, '')::bigint
FROM source_main_site_fixture
ON CONFLICT (site_id) DO UPDATE SET
    establishment_location_id = EXCLUDED.establishment_location_id,
    address_id = EXCLUDED.address_id,
    site_name = EXCLUDED.site_name,
    uprn = EXCLUDED.uprn;

UPDATE establishment.establishment_location AS el
SET main_site_id = s.site_id
FROM source_main_site_fixture AS s
WHERE el.establishment_location_id = s.establishment_location_id;

INSERT INTO establishment.capacity_and_pupil_measures (
    establishment_id, school_capacity, pupil_count, free_school_meal_measure, census_date
)
SELECT e.establishment_id, s.school_capacity, s.pupil_count,
       s.free_school_meal_measure, NULL::date
FROM source_establishment_fixture AS s
JOIN establishment.establishment AS e ON e.urn = s.urn
ON CONFLICT (establishment_id) DO UPDATE SET
    school_capacity = EXCLUDED.school_capacity,
    pupil_count = EXCLUDED.pupil_count,
    free_school_meal_measure = EXCLUDED.free_school_meal_measure,
    census_date = EXCLUDED.census_date;

INSERT INTO establishment.education_admissions_and_provision (
    establishment_id, gender_of_entry_type_id, admissions_policy_id,
    boarding_provision_id, nursery_provision_id, sixth_form_provision_id
)
SELECT e.establishment_id,
       CASE s.gender_code
           WHEN '3' THEN 1 -- Mixed
           WHEN '1' THEN 2 -- Boys
           WHEN '2' THEN 3 -- Girls
           WHEN '0' THEN 4 -- Not applicable
           ELSE NULL
       END,
       CASE WHEN s.admissions_policy_code = '1' THEN 1 ELSE 3 END,
       CASE s.boarders_code
           WHEN '1' THEN 1 -- No boarders
           WHEN '4' THEN 2 -- Has boarders / FE residential accommodation
           WHEN '2' THEN 3 -- Children's home / boarding school
           WHEN '3' THEN 3 -- Boarding school
           ELSE NULL
       END,
       CASE WHEN s.nursery_provision_code = '1' THEN 1
            WHEN s.nursery_provision_code = '2' THEN 2 ELSE 3 END,
       CASE WHEN s.sixth_form_code = '1' THEN 1
            WHEN s.sixth_form_code = '2' THEN 2 ELSE 3 END
FROM source_establishment_fixture AS s
JOIN establishment.establishment AS e ON e.urn = s.urn
ON CONFLICT (establishment_id) DO UPDATE SET
    gender_of_entry_type_id = EXCLUDED.gender_of_entry_type_id,
    admissions_policy_id = EXCLUDED.admissions_policy_id,
    boarding_provision_id = EXCLUDED.boarding_provision_id,
    nursery_provision_id = EXCLUDED.nursery_provision_id,
    sixth_form_provision_id = EXCLUDED.sixth_form_provision_id;

INSERT INTO establishment.statutory_age_range (
    education_admissions_and_provision_id, lower_statutory_age, upper_statutory_age
)
SELECT eap.education_admissions_and_provision_id,
       s.lower_statutory_age, s.upper_statutory_age
FROM source_establishment_fixture AS s
JOIN establishment.establishment AS e ON e.urn = s.urn
JOIN establishment.education_admissions_and_provision AS eap
  ON eap.establishment_id = e.establishment_id
ON CONFLICT (education_admissions_and_provision_id) DO UPDATE SET
    lower_statutory_age = EXCLUDED.lower_statutory_age,
    upper_statutory_age = EXCLUDED.upper_statutory_age;

INSERT INTO establishment.specialist_provision (establishment_id, specialist_provision_type_id)
SELECT e.establishment_id, 3
FROM source_establishment_fixture AS s
JOIN establishment.establishment AS e ON e.urn = s.urn
WHERE s.reserved_provision_code = '3'
ON CONFLICT (establishment_id) DO UPDATE SET specialist_provision_type_id = EXCLUDED.specialist_provision_type_id;

INSERT INTO establishment.resourced_provision (specialist_provision_id, capacity, pupil_count)
SELECT sp.specialist_provision_id, s.resourced_provision_capacity, s.resourced_provision_pupil_count
FROM source_establishment_fixture AS s
JOIN establishment.establishment AS e ON e.urn = s.urn
JOIN establishment.specialist_provision AS sp ON sp.establishment_id = e.establishment_id
WHERE s.reserved_provision_code = '3'
ON CONFLICT (specialist_provision_id) DO UPDATE SET
    capacity = EXCLUDED.capacity, pupil_count = EXCLUDED.pupil_count;

INSERT INTO establishment.sen_unit_provision (specialist_provision_id, capacity, pupil_count)
SELECT sp.specialist_provision_id, s.sen_unit_capacity, s.sen_unit_pupil_count
FROM source_establishment_fixture AS s
JOIN establishment.establishment AS e ON e.urn = s.urn
JOIN establishment.specialist_provision AS sp ON sp.establishment_id = e.establishment_id
WHERE s.reserved_provision_code = '3'
ON CONFLICT (specialist_provision_id) DO UPDATE SET
    capacity = EXCLUDED.capacity, pupil_count = EXCLUDED.pupil_count;

COMMIT;
