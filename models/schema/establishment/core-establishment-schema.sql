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

CREATE TABLE establishment.local_authority_jurisdiction (
    local_authority_jurisdiction_id integer PRIMARY KEY,
    name text NOT NULL UNIQUE
);

CREATE TABLE establishment.local_authority (
    local_authority_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    code integer NOT NULL UNIQUE,
    name text NOT NULL,
    local_authority_jurisdiction_id integer NOT NULL
        REFERENCES establishment.local_authority_jurisdiction (local_authority_jurisdiction_id)
);

CREATE TABLE establishment.gss_local_authority_code (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    code text NOT NULL UNIQUE
);

ALTER TABLE establishment.local_authority
    ADD COLUMN gss_local_authority_code_id uuid
        REFERENCES establishment.gss_local_authority_code (id);

CREATE TABLE establishment.local_authority_contact (
    local_authority_contact_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    local_authority_id uuid NOT NULL
        REFERENCES establishment.local_authority (local_authority_id),
    contact_email text,
    contact_first_name text,
    contact_last_name text,
    contact_title text,
    contact_phone text,
    contact_role text,
    is_current boolean NOT NULL DEFAULT true,
    CHECK (
        contact_email IS NOT NULL
        OR contact_phone IS NOT NULL
        OR contact_first_name IS NOT NULL
        OR contact_last_name IS NOT NULL
        OR contact_title IS NOT NULL
    )
);

CREATE TABLE establishment.government_office_region (
    government_office_region_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    -- BAU dbo.GovernmentOfficeRegion.code is an nvarchar code set (A, B, ...,
    -- W and Z), not a numeric identifier. Preserve it as text at the target.
    code text NOT NULL UNIQUE,
    name text NOT NULL UNIQUE
);

CREATE TABLE establishment.local_authority_government_office_region (
    local_authority_id uuid PRIMARY KEY
        REFERENCES establishment.local_authority (local_authority_id),
    government_office_region_id uuid NOT NULL
        REFERENCES establishment.government_office_region (government_office_region_id)
);

CREATE TABLE establishment.district_administrative (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    code text NOT NULL UNIQUE,
    name text NOT NULL,
    archived boolean NOT NULL DEFAULT false
);

CREATE TABLE establishment.administrative_ward (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    code text NOT NULL UNIQUE,
    name text NOT NULL
);

CREATE TABLE establishment.parliamentary_constituency (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    code text NOT NULL UNIQUE,
    name text NOT NULL
);

CREATE TABLE establishment.lsoa (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    code text NOT NULL UNIQUE,
    name text NOT NULL
);

CREATE TABLE establishment.msoa (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    code text NOT NULL UNIQUE,
    name text NOT NULL
);

CREATE TABLE establishment.urban_rural (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    code text NOT NULL UNIQUE,
    name text NOT NULL
);

CREATE TABLE establishment.establishment (
    establishment_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    urn integer NOT NULL UNIQUE CHECK (urn BETWEEN 100000 AND 999999),
    ukprn numeric CHECK (ukprn BETWEEN 10000000 AND 99999999),
    establishment_number integer CHECK (establishment_number BETWEEN 1 AND 9999),
    name text NOT NULL,
    establishment_type_id integer NOT NULL REFERENCES establishment.establishment_type (establishment_type_id),
    education_phase_id integer REFERENCES establishment.education_phase (education_phase_id)
);

CREATE TABLE establishment.establishment_geography (
    establishment_geography_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    establishment_id uuid NOT NULL UNIQUE
        REFERENCES establishment.establishment (establishment_id),
    local_authority_id uuid
        REFERENCES establishment.local_authority (local_authority_id),
    government_office_region_id uuid
        REFERENCES establishment.government_office_region (government_office_region_id),
    district_administrative_id uuid
        REFERENCES establishment.district_administrative (id),
    administrative_ward_id uuid
        REFERENCES establishment.administrative_ward (id),
    parliamentary_constituency_id uuid
        REFERENCES establishment.parliamentary_constituency (id),
    lsoa_id uuid
        REFERENCES establishment.lsoa (id),
    msoa_id uuid
        REFERENCES establishment.msoa (id),
    urban_rural_id uuid
        REFERENCES establishment.urban_rural (id)
);

CREATE TABLE establishment.establishment_contact (
    establishment_contact_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    establishment_id uuid NOT NULL UNIQUE REFERENCES establishment.establishment (establishment_id),
    website text,
    telephone_number text,
    CHECK (website IS NOT NULL OR telephone_number IS NOT NULL)
);

CREATE TABLE establishment.establishment_status (
    establishment_status_id integer PRIMARY KEY,
    code integer NOT NULL UNIQUE,
    name text NOT NULL UNIQUE
);

CREATE TABLE establishment.reason_establishment_opened (
    reason_establishment_opened_id integer PRIMARY KEY,
    name text NOT NULL UNIQUE
);

CREATE TABLE establishment.reason_establishment_closed (
    reason_establishment_closed_id integer PRIMARY KEY,
    name text NOT NULL UNIQUE
);

CREATE TABLE establishment.establishment_lifecycle (
    establishment_lifecycle_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    establishment_id uuid NOT NULL UNIQUE REFERENCES establishment.establishment (establishment_id),
    establishment_status_id integer NOT NULL REFERENCES establishment.establishment_status (establishment_status_id),
    open_date date,
    close_date date,
    reason_establishment_opened_id integer
        REFERENCES establishment.reason_establishment_opened (reason_establishment_opened_id),
    reason_establishment_closed_id integer
        REFERENCES establishment.reason_establishment_closed (reason_establishment_closed_id),
    last_changed_date date,
    CHECK (close_date IS NULL OR open_date IS NULL OR close_date >= open_date)
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

CREATE TABLE establishment.site (
    site_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    address_id uuid NOT NULL REFERENCES establishment.address (address_id),
    site_name text,
    uprn bigint
);

CREATE TABLE establishment.establishment_to_site (
    establishment_id uuid NOT NULL
        REFERENCES establishment.establishment (establishment_id),
    site_id uuid NOT NULL
        REFERENCES establishment.site (site_id),
    is_main_site boolean NOT NULL DEFAULT false,
    PRIMARY KEY (establishment_id, site_id)
);

CREATE UNIQUE INDEX ux_establishment_to_site_one_main
    ON establishment.establishment_to_site (establishment_id)
    WHERE is_main_site;

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
