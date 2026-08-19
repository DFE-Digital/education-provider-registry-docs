-- Seed the basic Establishment model with:
--   The Co-Operative Academy of Stoke-On-Trent
--   URN 136102
--
-- Target: PostgreSQL database establishment_local, schema establishment.
-- Source evidence: local GIAS BAU test copy for URN 136102.
-- This is a deliberately small migration fixture.
--
-- GIAS shows the school type as "Academy sponsor led". The current target
-- establishment-type taxonomy groups this under seeded establishment_type_id 4
-- for Mainstream academy.
-- The target model uses seeded education_phase_id 5 for Secondary.
-- The target model uses seeded gender_of_entry_type_id 1 for Mixed.
-- The target model uses seeded admissions_policy_id 1 for Non-selective.
-- The target model uses seeded boarding_provision_id 1 for No boarders.
-- The target model uses seeded nursery_provision_id 3 for Not applicable.
-- The target model uses seeded sixth_form_provision_id 3 for Not applicable.
-- The source school capacity in the local BAU copy is 1050.
-- The source pupil count in the local BAU copy is 1300.
-- The source SEN/resourced provision fields are not applicable for this
-- worked example, so no SEN/resourced provision child rows are inserted.
-- The DfE number is represented by its components: LA code 861 and
-- establishment number 6905. The frontend can render these as 861/6905.

BEGIN;

-- Reference data required by the foreign keys in establishment.establishment.
INSERT INTO establishment.establishment_type (establishment_type_id, name)
VALUES (4, 'Mainstream academy')
ON CONFLICT (establishment_type_id) DO UPDATE
SET name = EXCLUDED.name;

INSERT INTO establishment.education_phase (education_phase_id, name)
VALUES (5, 'Secondary')
ON CONFLICT (education_phase_id) DO UPDATE
SET name = EXCLUDED.name;

INSERT INTO establishment.gender_of_entry_type (gender_of_entry_type_id, name)
VALUES (1, 'Mixed')
ON CONFLICT (gender_of_entry_type_id) DO UPDATE
SET name = EXCLUDED.name;

INSERT INTO establishment.admissions_policy (admissions_policy_id, name)
VALUES (1, 'Non-selective')
ON CONFLICT (admissions_policy_id) DO UPDATE
SET name = EXCLUDED.name;

INSERT INTO establishment.boarding_provision (boarding_provision_id, name)
VALUES (1, 'No boarders')
ON CONFLICT (boarding_provision_id) DO UPDATE
SET name = EXCLUDED.name;

INSERT INTO establishment.nursery_provision (nursery_provision_id, name)
VALUES (3, 'Not applicable (nursery provision)')
ON CONFLICT (nursery_provision_id) DO UPDATE
SET name = EXCLUDED.name;

INSERT INTO establishment.sixth_form_provision (sixth_form_provision_id, name)
VALUES (3, 'Not applicable (sixth-form provision)')
ON CONFLICT (sixth_form_provision_id) DO UPDATE
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
    136102,
    '861',
    6905,
    10030216,
    'The Co-Operative Academy of Stoke-On-Trent',
    4,
    5
)
ON CONFLICT (urn) DO UPDATE
SET local_authority_code = EXCLUDED.local_authority_code,
    establishment_number = EXCLUDED.establishment_number,
    ukprn = EXCLUDED.ukprn,
    name = EXCLUDED.name,
    establishment_type_id = EXCLUDED.establishment_type_id,
    education_phase_id = EXCLUDED.education_phase_id;

-- Main physical site and its postal address. UPRN belongs to Site, not Address.
INSERT INTO establishment.address (address_line_1, address_line_2, address_line_3, town, county, postcode)
SELECT 'obfuscated', NULL, 'obfuscated', 'obfuscated', '032', 'ST6 4LD'
WHERE NOT EXISTS (SELECT 1 FROM establishment.address WHERE postcode = 'ST6 4LD' AND address_line_1 = 'obfuscated');
INSERT INTO establishment.establishment_location (establishment_id)
SELECT establishment_id FROM establishment.establishment WHERE urn = 136102
ON CONFLICT (establishment_id) DO NOTHING;
INSERT INTO establishment.site (establishment_location_id, address_id, site_name, uprn)
SELECT l.establishment_location_id, a.address_id, NULL, 3455015782
FROM establishment.establishment_location l
JOIN establishment.establishment e ON e.establishment_id = l.establishment_id
JOIN establishment.address a ON a.postcode = 'ST6 4LD' AND a.address_line_1 = 'obfuscated'
WHERE e.urn = 136102
  AND NOT EXISTS (SELECT 1 FROM establishment.site s WHERE s.uprn = 3455015782);
UPDATE establishment.establishment_location l
SET main_site_id = s.site_id
FROM establishment.site s, establishment.establishment e
WHERE e.establishment_id = l.establishment_id
  AND s.uprn = 3455015782
  AND e.urn = 136102;

-- Capacity and pupil measures for this establishment.
INSERT INTO establishment.capacity_and_pupil_measures (
    establishment_id,
    school_capacity,
    pupil_count
)
SELECT e.establishment_id,
       1050,
       1300
FROM establishment.establishment AS e
WHERE e.urn = 136102
ON CONFLICT (establishment_id) DO UPDATE
SET school_capacity = EXCLUDED.school_capacity,
    pupil_count = EXCLUDED.pupil_count;

-- The establishment's education, admissions and provision parent record.
-- Gender of entry, admissions policy, boarding provision, nursery provision and
-- sixth-form provision are carried directly on this row.
INSERT INTO establishment.education_admissions_and_provision (
    establishment_id,
    gender_of_entry_type_id,
    admissions_policy_id,
    boarding_provision_id,
    nursery_provision_id,
    sixth_form_provision_id
)
SELECT e.establishment_id,
       1,
       1,
       1,
       3,
       3
FROM establishment.establishment AS e
WHERE e.urn = 136102
ON CONFLICT (establishment_id) DO UPDATE
SET gender_of_entry_type_id = EXCLUDED.gender_of_entry_type_id,
    admissions_policy_id = EXCLUDED.admissions_policy_id,
    boarding_provision_id = EXCLUDED.boarding_provision_id,
    nursery_provision_id = EXCLUDED.nursery_provision_id,
    sixth_form_provision_id = EXCLUDED.sixth_form_provision_id;

-- The establishment's statutory age range is 11 to 16.
INSERT INTO establishment.statutory_age_range (
    education_admissions_and_provision_id,
    lower_statutory_age,
    upper_statutory_age
)
SELECT eap.education_admissions_and_provision_id,
       11,
       16
FROM establishment.education_admissions_and_provision AS eap
JOIN establishment.establishment AS e
  ON e.establishment_id = eap.establishment_id
WHERE e.urn = 136102
ON CONFLICT (education_admissions_and_provision_id) DO UPDATE
SET lower_statutory_age = EXCLUDED.lower_statutory_age,
    upper_statutory_age = EXCLUDED.upper_statutory_age;

COMMIT;

-- Validation query:
-- SELECT e.urn, e.local_authority_code, e.establishment_number, e.ukprn, e.name,
--        e.establishment_type_id, et.name AS establishment_type,
--        e.education_phase_id, ep.name AS education_phase,
--        capm.school_capacity, capm.pupil_count,
--        eap.gender_of_entry_type_id, goet.name AS gender_of_entry,
--        eap.admissions_policy_id, ap.name AS admissions_policy,
--        eap.boarding_provision_id, bp.name AS boarding_provision,
--        eap.nursery_provision_id, np.name AS nursery_provision,
--        eap.sixth_form_provision_id, sfp.name AS sixth_form_provision,
--        sar.lower_statutory_age, sar.upper_statutory_age
-- FROM establishment.establishment AS e
-- JOIN establishment.establishment_type AS et
--   ON et.establishment_type_id = e.establishment_type_id
-- LEFT JOIN establishment.education_phase AS ep
--   ON ep.education_phase_id = e.education_phase_id
-- LEFT JOIN establishment.capacity_and_pupil_measures AS capm
--   ON capm.establishment_id = e.establishment_id
-- LEFT JOIN establishment.education_admissions_and_provision AS eap
--   ON eap.establishment_id = e.establishment_id
-- LEFT JOIN establishment.gender_of_entry_type AS goet
--   ON goet.gender_of_entry_type_id = eap.gender_of_entry_type_id
-- LEFT JOIN establishment.admissions_policy AS ap
--   ON ap.admissions_policy_id = eap.admissions_policy_id
-- LEFT JOIN establishment.boarding_provision AS bp
--   ON bp.boarding_provision_id = eap.boarding_provision_id
-- LEFT JOIN establishment.nursery_provision AS np
--   ON np.nursery_provision_id = eap.nursery_provision_id
-- LEFT JOIN establishment.sixth_form_provision AS sfp
--   ON sfp.sixth_form_provision_id = eap.sixth_form_provision_id
-- LEFT JOIN establishment.statutory_age_range AS sar
--   ON sar.education_admissions_and_provision_id = eap.education_admissions_and_provision_id
-- WHERE e.urn = 136102;
