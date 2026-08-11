-- Seed the basic Establishment model with:
--   Gilded Hollins Community School
--   URN 106431
--
-- Target: PostgreSQL database establishment_local, schema establishment.
-- Source evidence: BAU/Test establishment record and the public GIAS establishment
-- details for URN 106431. This is a deliberately small migration fixture.
--
-- The target model uses seeded establishment_type_id 1 for Community school.
-- The target model uses seeded education_phase_id 2 for Primary.
-- The target model uses seeded gender_of_entry_type_id 1 for Mixed.
-- The DfE number is represented by its components: LA code 359 and
-- establishment number 2053. The frontend can render these as 359/2053.

BEGIN;

-- Reference data required by the foreign keys in establishment.establishment.
INSERT INTO establishment.establishment_type (establishment_type_id, name)
VALUES (1, 'Community school')
ON CONFLICT (establishment_type_id) DO UPDATE
SET name = EXCLUDED.name;

INSERT INTO establishment.education_phase (education_phase_id, name)
VALUES (2, 'Primary')
ON CONFLICT (education_phase_id) DO UPDATE
SET name = EXCLUDED.name;

INSERT INTO establishment.gender_of_entry_type (gender_of_entry_type_id, name)
VALUES (1, 'Mixed')
ON CONFLICT (gender_of_entry_type_id) DO UPDATE
SET name = EXCLUDED.name;

-- Core establishment row. The URN is the natural reconciliation key for this
-- fixture; rerunning the script updates the existing row rather than inserting
-- a duplicate.
INSERT INTO establishment.establishment (
    urn,
    local_authority_code,
    establishment_number,
    ukprn,
    name,
    establishment_type_id,
    education_phase_id
)
VALUES (
    106431,
    '359',
    2053,
    10072615,
    'Gilded Hollins Community School',
    1,
    2
)
ON CONFLICT (urn) DO UPDATE
SET local_authority_code = EXCLUDED.local_authority_code,
    establishment_number = EXCLUDED.establishment_number,
    ukprn = EXCLUDED.ukprn,
    name = EXCLUDED.name,
    establishment_type_id = EXCLUDED.establishment_type_id,
    education_phase_id = EXCLUDED.education_phase_id;

-- The establishment's education, admissions and provision parent record.
-- Gender of entry (Mixed) is carried directly on this row.
INSERT INTO establishment.education_admissions_and_provision (
    establishment_id,
    gender_of_entry_type_id
)
SELECT e.establishment_id,
       1
FROM establishment.establishment AS e
WHERE e.urn = 106431
ON CONFLICT (establishment_id) DO UPDATE
SET gender_of_entry_type_id = EXCLUDED.gender_of_entry_type_id;

-- The establishment's statutory age range is 4 to 11.

INSERT INTO establishment.statutory_age_range (
    education_admissions_and_provision_id,
    lower_statutory_age,
    upper_statutory_age
)
SELECT eap.education_admissions_and_provision_id,
       4,
       11
FROM establishment.education_admissions_and_provision AS eap
JOIN establishment.establishment AS e
  ON e.establishment_id = eap.establishment_id
WHERE e.urn = 106431
ON CONFLICT (education_admissions_and_provision_id) DO UPDATE
SET lower_statutory_age = EXCLUDED.lower_statutory_age,
    upper_statutory_age = EXCLUDED.upper_statutory_age;

COMMIT;

-- Validation query:
-- SELECT e.urn, e.local_authority_code, e.establishment_number, e.ukprn, e.name,
--        e.establishment_type_id, et.name AS establishment_type,
--        e.education_phase_id, ep.name AS education_phase,
--        eap.gender_of_entry_type_id, goet.name AS gender_of_entry,
--        sar.lower_statutory_age, sar.upper_statutory_age
-- FROM establishment.establishment AS e
-- JOIN establishment.establishment_type AS et
--   ON et.establishment_type_id = e.establishment_type_id
-- LEFT JOIN establishment.education_phase AS ep
--   ON ep.education_phase_id = e.education_phase_id
-- LEFT JOIN establishment.education_admissions_and_provision AS eap
--   ON eap.establishment_id = e.establishment_id
-- LEFT JOIN establishment.gender_of_entry_type AS goet
--   ON goet.gender_of_entry_type_id = eap.gender_of_entry_type_id
-- LEFT JOIN establishment.statutory_age_range AS sar
--   ON sar.education_admissions_and_provision_id = eap.education_admissions_and_provision_id
-- WHERE e.urn = 106431;
