-- PostgreSQL DDL for models/logical/core-establishment-data-logical-model.md
-- Target: database establishment_local, schema establishment
--
-- Disposable local baseline: this script intentionally drops and recreates the
-- establishment schema. Do not run it against shared, Test, staging or
-- production databases.

DROP SCHEMA IF EXISTS establishment CASCADE;
CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE SCHEMA IF NOT EXISTS establishment;

CREATE TABLE establishment.establishment_type (
    establishment_type_id integer PRIMARY KEY,
    name text NOT NULL
);

CREATE TABLE establishment.education_phase (
    education_phase_id integer PRIMARY KEY,
    name text NOT NULL
);

CREATE TABLE establishment.gender_of_entry_type (
    gender_of_entry_type_id integer PRIMARY KEY,
    name text NOT NULL
);

CREATE TABLE establishment.admissions_policy (
    admissions_policy_id integer PRIMARY KEY,
    name text NOT NULL
);

CREATE TABLE establishment.boarding_provision (
    boarding_provision_id integer PRIMARY KEY,
    name text NOT NULL
);

CREATE TABLE establishment.nursery_provision (
    nursery_provision_id integer PRIMARY KEY,
    name text NOT NULL
);

CREATE TABLE establishment.sixth_form_provision (
    sixth_form_provision_id integer PRIMARY KEY,
    name text NOT NULL
);

CREATE TABLE establishment.specialist_provision_type (
    specialist_provision_type_id integer PRIMARY KEY,
    name text NOT NULL
);

CREATE TABLE establishment.establishment (
    establishment_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    urn integer NOT NULL UNIQUE CHECK (urn BETWEEN 100000 AND 999999),
    ukprn numeric CHECK (ukprn BETWEEN 10000000 AND 99999999),
    local_authority_code text,
    establishment_number integer CHECK (establishment_number BETWEEN 1 AND 9999),
    name text NOT NULL,
    establishment_type_id integer NOT NULL REFERENCES establishment.establishment_type (establishment_type_id),
    education_phase_id integer REFERENCES establishment.education_phase (education_phase_id),
    CHECK ((local_authority_code IS NULL) = (establishment_number IS NULL))
);

CREATE TABLE establishment.address (
    address_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    address_line_1 text,
    address_line_2 text,
    address_line_3 text,
    town text,
    county text,
    postcode text
);

CREATE TABLE establishment.establishment_location (
    establishment_location_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    establishment_id uuid NOT NULL UNIQUE REFERENCES establishment.establishment (establishment_id),
    main_site_id uuid
);

CREATE TABLE establishment.site (
    site_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    establishment_location_id uuid NOT NULL
        REFERENCES establishment.establishment_location (establishment_location_id),
    address_id uuid NOT NULL REFERENCES establishment.address (address_id),
    site_name text,
    uprn bigint UNIQUE
);

ALTER TABLE establishment.establishment_location
    ADD CONSTRAINT fk_establishment_location_main_site
    FOREIGN KEY (main_site_id) REFERENCES establishment.site (site_id);

CREATE TABLE establishment.capacity_and_pupil_measures (
    capacity_and_pupil_measures_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    establishment_id uuid NOT NULL UNIQUE REFERENCES establishment.establishment (establishment_id),
    school_capacity integer CHECK (school_capacity >= 0),
    pupil_count integer CHECK (pupil_count >= 0),
    free_school_meal_measure integer CHECK (free_school_meal_measure >= 0),
    census_date date,
    CHECK (school_capacity IS NOT NULL OR pupil_count IS NOT NULL OR free_school_meal_measure IS NOT NULL)
);

CREATE TABLE establishment.education_admissions_and_provision (
    education_admissions_and_provision_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    establishment_id uuid NOT NULL UNIQUE REFERENCES establishment.establishment (establishment_id),
    gender_of_entry_type_id integer REFERENCES establishment.gender_of_entry_type (gender_of_entry_type_id),
    admissions_policy_id integer REFERENCES establishment.admissions_policy (admissions_policy_id),
    boarding_provision_id integer REFERENCES establishment.boarding_provision (boarding_provision_id),
    nursery_provision_id integer REFERENCES establishment.nursery_provision (nursery_provision_id),
    sixth_form_provision_id integer REFERENCES establishment.sixth_form_provision (sixth_form_provision_id)
);

CREATE TABLE establishment.statutory_age_range (
    statutory_age_range_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    education_admissions_and_provision_id uuid NOT NULL UNIQUE
        REFERENCES establishment.education_admissions_and_provision (education_admissions_and_provision_id),
    lower_statutory_age integer NOT NULL CHECK (lower_statutory_age BETWEEN 0 AND 19),
    upper_statutory_age integer NOT NULL CHECK (upper_statutory_age BETWEEN 0 AND 25),
    CHECK (upper_statutory_age >= lower_statutory_age)
);

CREATE TABLE establishment.specialist_provision (
    specialist_provision_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    establishment_id uuid NOT NULL UNIQUE REFERENCES establishment.establishment (establishment_id),
    specialist_provision_type_id integer
        REFERENCES establishment.specialist_provision_type (specialist_provision_type_id)
);

CREATE TABLE establishment.resourced_provision (
    resourced_provision_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    specialist_provision_id uuid NOT NULL UNIQUE
        REFERENCES establishment.specialist_provision (specialist_provision_id),
    capacity integer CHECK (capacity >= 0),
    pupil_count integer CHECK (pupil_count >= 0),
    CHECK (capacity IS NOT NULL OR pupil_count IS NOT NULL),
    CHECK (capacity IS NULL OR pupil_count IS NULL OR pupil_count <= capacity)
);

CREATE TABLE establishment.sen_unit_provision (
    sen_unit_provision_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    specialist_provision_id uuid NOT NULL UNIQUE
        REFERENCES establishment.specialist_provision (specialist_provision_id),
    capacity integer CHECK (capacity >= 0),
    pupil_count integer CHECK (pupil_count >= 0),
    CHECK (capacity IS NOT NULL OR pupil_count IS NOT NULL)
);
