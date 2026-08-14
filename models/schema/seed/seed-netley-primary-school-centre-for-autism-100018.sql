-- Seed the basic Establishment model with:
--   Netley Primary School & Centre for Autism
--   URN 100018
--
-- Target: PostgreSQL database establishment_local, schema establishment.
-- Source evidence: local GIAS BAU test copy for URN 100018.
-- This worked example exercises both resourced provision and SEN unit measures.
--
-- The target model uses seeded establishment_type_id 1 for Community school.
-- The target model uses seeded education_phase_id 2 for Primary.
-- The target model uses seeded gender_of_entry_type_id 1 for Mixed.
-- The target model uses seeded admissions_policy_id 3 for Not applicable.
-- The target model uses seeded boarding_provision_id 1 for No boarders.
-- The target model uses seeded nursery_provision_id 1 for Nursery classes.
-- The target model uses seeded sixth_form_provision_id 2 for No sixth form.
-- The source school capacity in the local BAU copy is 65801.
-- The source pupil count in the local BAU copy is 383.
-- The source typeOfReservedProvision_code is 3, mapped to seeded
-- specialist_provision_type_id 3 for Resourced provision and SEN unit.
-- The DfE number is represented by its components: LA code 202 and
-- establishment number 2436. The frontend can render these as 202/2436.

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

INSERT INTO establishment.admissions_policy (admissions_policy_id, name)
VALUES (3, 'Not applicable (admissions policy)')
ON CONFLICT (admissions_policy_id) DO UPDATE
SET name = EXCLUDED.name;

INSERT INTO establishment.boarding_provision (boarding_provision_id, name)
VALUES (1, 'No boarders')
ON CONFLICT (boarding_provision_id) DO UPDATE
SET name = EXCLUDED.name;

INSERT INTO establishment.nursery_provision (nursery_provision_id, name)
VALUES (1, 'Nursery classes')
ON CONFLICT (nursery_provision_id) DO UPDATE
SET name = EXCLUDED.name;

INSERT INTO establishment.sixth_form_provision (sixth_form_provision_id, name)
VALUES (2, 'No sixth form')
ON CONFLICT (sixth_form_provision_id) DO UPDATE
SET name = EXCLUDED.name;

INSERT INTO establishment.specialist_provision_type (
    specialist_provision_type_id,
    name
)
VALUES (3, 'Resourced provision and SEN unit')
ON CONFLICT (specialist_provision_type_id) DO UPDATE
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
    100018,
    '202',
    2436,
    10069172,
    'Netley Primary School & Centre for Autism',
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

-- Capacity and pupil measures for this establishment.
INSERT INTO establishment.capacity_and_pupil_measures (
    establishment_id,
    school_capacity,
    pupil_count
)
SELECT e.establishment_id,
       65801,
       383
FROM establishment.establishment AS e
WHERE e.urn = 100018
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
       3,
       1,
       1,
       2
FROM establishment.establishment AS e
WHERE e.urn = 100018
ON CONFLICT (establishment_id) DO UPDATE
SET gender_of_entry_type_id = EXCLUDED.gender_of_entry_type_id,
    admissions_policy_id = EXCLUDED.admissions_policy_id,
    boarding_provision_id = EXCLUDED.boarding_provision_id,
    nursery_provision_id = EXCLUDED.nursery_provision_id,
    sixth_form_provision_id = EXCLUDED.sixth_form_provision_id;

-- The establishment's statutory age range is 2 to 11.
INSERT INTO establishment.statutory_age_range (
    education_admissions_and_provision_id,
    lower_statutory_age,
    upper_statutory_age
)
SELECT eap.education_admissions_and_provision_id,
       2,
       11
FROM establishment.education_admissions_and_provision AS eap
JOIN establishment.establishment AS e
  ON e.establishment_id = eap.establishment_id
WHERE e.urn = 100018
ON CONFLICT (education_admissions_and_provision_id) DO UPDATE
SET lower_statutory_age = EXCLUDED.lower_statutory_age,
    upper_statutory_age = EXCLUDED.upper_statutory_age;

-- Specialist provision parent. This worked example has both a
-- resourced-provision unit and a SEN unit.
INSERT INTO establishment.specialist_provision (
    establishment_id,
    specialist_provision_type_id
)
SELECT e.establishment_id,
       3
FROM establishment.establishment AS e
WHERE e.urn = 100018
ON CONFLICT (establishment_id) DO UPDATE
SET specialist_provision_type_id = EXCLUDED.specialist_provision_type_id;

INSERT INTO establishment.resourced_provision (
    specialist_provision_id,
    capacity,
    pupil_count
)
SELECT sp.specialist_provision_id,
       24,
       24
FROM establishment.specialist_provision AS sp
JOIN establishment.establishment AS e
  ON e.establishment_id = sp.establishment_id
WHERE e.urn = 100018
ON CONFLICT (specialist_provision_id) DO UPDATE
SET capacity = EXCLUDED.capacity,
    pupil_count = EXCLUDED.pupil_count;

INSERT INTO establishment.sen_unit_provision (
    specialist_provision_id,
    capacity,
    pupil_count
)
SELECT sp.specialist_provision_id,
       24,
       24
FROM establishment.specialist_provision AS sp
JOIN establishment.establishment AS e
  ON e.establishment_id = sp.establishment_id
WHERE e.urn = 100018
ON CONFLICT (specialist_provision_id) DO UPDATE
SET capacity = EXCLUDED.capacity,
    pupil_count = EXCLUDED.pupil_count;

COMMIT;
