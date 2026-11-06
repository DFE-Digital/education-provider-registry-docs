-- Complete WIP Establishment schema: tables, keys, indexes, constraints and lead/council guards.
-- Run in an existing PostgreSQL database with permission to install the extensions.
-- Creation only: an existing establishment schema causes failure, not data deletion.
-- No seeds, migration-evidence schema, permissions policy or external SQL includes.
BEGIN;
CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS btree_gist;
CREATE SCHEMA establishment;

CREATE TABLE establishment.establishment_type_category (
    establishment_type_category_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    name text NOT NULL UNIQUE
);

CREATE TABLE establishment.academy_route (
    academy_route_id integer PRIMARY KEY,
    name text NOT NULL UNIQUE,
    canonical_identifier text NOT NULL UNIQUE,
    CONSTRAINT academy_route_values CHECK (
        (academy_route_id, name, canonical_identifier) IN (
            (1, 'Converter', 'est:ConverterRoute'),
            (2, 'Sponsor led', 'est:SponsorLedRoute')
        )
    )
);

CREATE TABLE establishment.establishment_type (
    establishment_type_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    code text NOT NULL UNIQUE,
    name text NOT NULL,
    establishment_type_category_id uuid NOT NULL
        REFERENCES establishment.establishment_type_category (establishment_type_category_id),
    academy_route_id integer REFERENCES establishment.academy_route (academy_route_id),
    -- All nine academy types use BAU's Academies category. Its seeded UUID
    -- is independent of BAU group codes and internal source row IDs.
    CONSTRAINT establishment_type_academy_mapping CHECK (
        CASE code
            WHEN '34' THEN establishment_type_category_id = 'f2b9ca2a-74a4-4cb5-b3d5-3bb2bf2a2a10' AND academy_route_id IS NOT DISTINCT FROM 1
            WHEN '28' THEN establishment_type_category_id = 'f2b9ca2a-74a4-4cb5-b3d5-3bb2bf2a2a10' AND academy_route_id IS NOT DISTINCT FROM 2
            WHEN '44' THEN establishment_type_category_id = 'f2b9ca2a-74a4-4cb5-b3d5-3bb2bf2a2a10' AND academy_route_id IS NOT DISTINCT FROM 1
            WHEN '33' THEN establishment_type_category_id = 'f2b9ca2a-74a4-4cb5-b3d5-3bb2bf2a2a10' AND academy_route_id IS NOT DISTINCT FROM 2
            WHEN '42' THEN establishment_type_category_id = 'f2b9ca2a-74a4-4cb5-b3d5-3bb2bf2a2a10' AND academy_route_id IS NOT DISTINCT FROM 1
            WHEN '43' THEN establishment_type_category_id = 'f2b9ca2a-74a4-4cb5-b3d5-3bb2bf2a2a10' AND academy_route_id IS NOT DISTINCT FROM 2
            WHEN '45' THEN establishment_type_category_id = 'f2b9ca2a-74a4-4cb5-b3d5-3bb2bf2a2a10' AND academy_route_id IS NOT DISTINCT FROM 1
            WHEN '46' THEN establishment_type_category_id = 'f2b9ca2a-74a4-4cb5-b3d5-3bb2bf2a2a10' AND academy_route_id IS NOT DISTINCT FROM 2
            WHEN '57' THEN establishment_type_category_id = 'f2b9ca2a-74a4-4cb5-b3d5-3bb2bf2a2a10' AND academy_route_id IS NULL
            ELSE establishment_type_category_id <> 'f2b9ca2a-74a4-4cb5-b3d5-3bb2bf2a2a10' AND academy_route_id IS NULL
        END
    )
);

COMMENT ON TABLE establishment.establishment_type IS
    'Detailed administrative establishment types with published DfE codes. Category and academy route are obtained through this reference data, not stored on each establishment.';

CREATE TABLE establishment.education_phase (
    education_phase_id integer PRIMARY KEY,
    name text NOT NULL CHECK (name !~* '^(unknown|not applicable( \(.*\))?|does not apply|not known)$')
);

CREATE TABLE establishment.further_education_type (
    further_education_type_id integer PRIMARY KEY,
    code text NOT NULL UNIQUE,
    name text NOT NULL CHECK (name !~* '^(unknown|not applicable( \(.*\))?|does not apply|not known)$')
);

CREATE TABLE establishment.section_41_approval_status (
    section_41_approval_status_id integer PRIMARY KEY,
    code text NOT NULL UNIQUE,
    name text NOT NULL CHECK (name !~* '^(unknown|not applicable( \(.*\))?|does not apply|not known)$')
);

CREATE TABLE establishment.gender_of_entry_type (
    gender_of_entry_type_id integer PRIMARY KEY,
    name text NOT NULL CHECK (name !~* '^(unknown|not applicable( \(.*\))?|does not apply|not known)$')
);

CREATE TABLE establishment.religious_character (
    religious_character_id integer PRIMARY KEY,
    code text NOT NULL UNIQUE,
    name text NOT NULL CHECK (name !~* '^(unknown|not applicable( \(.*\))?|does not apply|not known)$')
);

CREATE TABLE establishment.religious_ethos (
    religious_ethos_id integer PRIMARY KEY,
    code text NOT NULL UNIQUE,
    name text NOT NULL CHECK (name !~* '^(unknown|not applicable( \(.*\))?|does not apply|not known)$')
);

CREATE TABLE establishment.diocese (
    diocese_id integer PRIMARY KEY,
    code text NOT NULL UNIQUE,
    name text NOT NULL CHECK (name !~* '^(unknown|not applicable( \(.*\))?|does not apply|not known)$')
);

CREATE TABLE establishment.admissions_policy (
    admissions_policy_id integer PRIMARY KEY,
    name text NOT NULL CHECK (name !~* '^(unknown|not applicable( \(.*\))?|does not apply|not known)$')
);

CREATE TABLE establishment.boarding_provision (
    boarding_provision_id integer PRIMARY KEY,
    name text NOT NULL
);

CREATE TABLE establishment.nursery_provision (
    nursery_provision_id integer PRIMARY KEY,
    name text NOT NULL CHECK (name !~* '^(unknown|not applicable( \(.*\))?|does not apply|not known)$')
);

CREATE TABLE establishment.sixth_form_provision (
    sixth_form_provision_id integer PRIMARY KEY,
    name text NOT NULL CHECK (name !~* '^(unknown|not applicable( \(.*\))?|does not apply|not known)$')
);

CREATE TABLE establishment.specialist_provision_type (
    specialist_provision_type_id integer PRIMARY KEY,
    name text NOT NULL
);

CREATE TABLE establishment.local_authority_jurisdiction (
    local_authority_jurisdiction_id integer PRIMARY KEY,
    name text NOT NULL UNIQUE
);

CREATE TABLE establishment.local_authority_area (
    local_authority_area_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    code integer NOT NULL UNIQUE,
    name text NOT NULL,
    local_authority_jurisdiction_id integer NOT NULL
        REFERENCES establishment.local_authority_jurisdiction (local_authority_jurisdiction_id)
);

COMMENT ON TABLE establishment.local_authority_area IS
    'The DfE LA-code area used by establishment geography and LAESTAB. This is not the council legal entity and does not imply maintenance.';

CREATE TABLE establishment.gss_local_authority_code (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    code text NOT NULL UNIQUE
);

ALTER TABLE establishment.local_authority_area
    ADD COLUMN gss_local_authority_code_id uuid
        REFERENCES establishment.gss_local_authority_code (id);

CREATE TABLE establishment.local_authority_area_contact (
    local_authority_area_contact_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    local_authority_area_id uuid NOT NULL
        REFERENCES establishment.local_authority_area (local_authority_area_id),
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

COMMENT ON TABLE establishment.local_authority_area_contact IS
    'Council contacts temporarily associated with their DfE LA-code area. Move to the council when the legal-entity contact slice is implemented.';

CREATE TABLE establishment.government_office_region (
    government_office_region_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    -- BAU dbo.GovernmentOfficeRegion.code is an nvarchar code set (A, B, ...,
    -- W and Z), not a numeric identifier. Preserve it as text at the target.
    code text NOT NULL UNIQUE,
    name text NOT NULL CHECK (name !~* '^(unknown|not applicable( \(.*\))?|does not apply|not known)$') UNIQUE
);

CREATE TABLE establishment.local_authority_area_government_office_region (
    local_authority_area_id uuid PRIMARY KEY
        REFERENCES establishment.local_authority_area (local_authority_area_id),
    government_office_region_id uuid NOT NULL
        REFERENCES establishment.government_office_region (government_office_region_id)
);

CREATE TABLE establishment.district_administrative (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    code text NOT NULL UNIQUE,
    name text NOT NULL CHECK (name !~* '^(unknown|not applicable( \(.*\))?|does not apply|not known)$'),
    archived boolean NOT NULL DEFAULT false
);

CREATE TABLE establishment.administrative_ward (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    code text NOT NULL UNIQUE,
    name text NOT NULL CHECK (name !~* '^(unknown|not applicable( \(.*\))?|does not apply|not known)$')
);

CREATE TABLE establishment.parliamentary_constituency (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    code text NOT NULL UNIQUE,
    name text NOT NULL CHECK (name !~* '^(unknown|not applicable( \(.*\))?|does not apply|not known)$')
);

CREATE TABLE establishment.lsoa (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    code text NOT NULL UNIQUE,
    name text NOT NULL CHECK (name !~* '^(unknown|not applicable( \(.*\))?|does not apply|not known)$')
);

CREATE TABLE establishment.msoa (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    code text NOT NULL UNIQUE,
    name text NOT NULL CHECK (name !~* '^(unknown|not applicable( \(.*\))?|does not apply|not known)$')
);

CREATE TABLE establishment.urban_rural (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    code text NOT NULL UNIQUE,
    name text NOT NULL CHECK (name !~* '^(unknown|not applicable( \(.*\))?|does not apply|not known)$')
);

CREATE TABLE establishment.establishment (
    establishment_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    urn integer NOT NULL UNIQUE CHECK (urn BETWEEN 1 AND 999999),
    ukprn numeric CHECK (ukprn BETWEEN 10000000 AND 99999999),
    establishment_number integer CHECK (establishment_number BETWEEN 1 AND 9999),
    name text NOT NULL,
    establishment_type_id uuid NOT NULL REFERENCES establishment.establishment_type (establishment_type_id),
    ofsted_link text,
    education_phase_id integer REFERENCES establishment.education_phase (education_phase_id),
    further_education_type_id integer REFERENCES establishment.further_education_type (further_education_type_id),
    section_41_approval_status_id integer REFERENCES establishment.section_41_approval_status (section_41_approval_status_id),
    religious_character_id integer REFERENCES establishment.religious_character (religious_character_id),
    religious_ethos_id integer REFERENCES establishment.religious_ethos (religious_ethos_id),
    diocese_id integer REFERENCES establishment.diocese (diocese_id)
);

CREATE TABLE establishment.establishment_geography (
    establishment_geography_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    establishment_id uuid NOT NULL UNIQUE
        REFERENCES establishment.establishment (establishment_id),
    local_authority_area_id uuid
        REFERENCES establishment.local_authority_area (local_authority_area_id),
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
    sixth_form_provision_id integer REFERENCES establishment.sixth_form_provision (sixth_form_provision_id),
    has_special_classes boolean
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

-- Establishment-groups slice: legal entities and people can hold dated roles,
-- responsibilities and group identifiers. Organisation groups are modelled
-- separately from legal entities.
CREATE TABLE establishment.legal_entity_type (
    legal_entity_type_id integer PRIMARY KEY,
    name text NOT NULL UNIQUE
);

CREATE TABLE establishment.charity_status (
    charity_status_id integer PRIMARY KEY,
    name text NOT NULL UNIQUE
);

CREATE TABLE establishment.legal_entity (
    legal_entity_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    name text NOT NULL CHECK (btrim(name) <> ''),
    legal_entity_type_id integer
        REFERENCES establishment.legal_entity_type (legal_entity_type_id),
    charity_status_id integer
        REFERENCES establishment.charity_status (charity_status_id),
    incorporation_date date,
    dissolution_date date,
    CHECK (dissolution_date IS NULL OR incorporation_date IS NULL OR dissolution_date >= incorporation_date)
);

CREATE TABLE establishment.organisation_identifier_type (
    organisation_identifier_type_id integer PRIMARY KEY,
    name text NOT NULL UNIQUE
);

CREATE TABLE establishment.organisation_identifier (
    organisation_identifier_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    legal_entity_id uuid NOT NULL
        REFERENCES establishment.legal_entity (legal_entity_id),
    organisation_identifier_type_id integer NOT NULL
        REFERENCES establishment.organisation_identifier_type (organisation_identifier_type_id),
    value text NOT NULL CHECK (btrim(value) <> ''),
    is_current boolean NOT NULL DEFAULT true
);

CREATE UNIQUE INDEX organisation_identifier_value_unique
    ON establishment.organisation_identifier (organisation_identifier_type_id, value);

CREATE UNIQUE INDEX organisation_identifier_current_owner_type_unique
    ON establishment.organisation_identifier (legal_entity_id, organisation_identifier_type_id)
    WHERE is_current;


-- Minimal relationship endpoint for roles and responsibilities held by a
-- person. Person identity and descriptive attributes belong to the people
-- slice and are not introduced here.
CREATE TABLE establishment.person (
    person_id uuid PRIMARY KEY DEFAULT gen_random_uuid()
);

CREATE TABLE establishment.establishment_party_role_type (
    establishment_party_role_type_id integer PRIMARY KEY,
    name text NOT NULL UNIQUE
);

CREATE TABLE establishment.establishment_party_role (
    establishment_party_role_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    establishment_party_role_type_id integer NOT NULL
        REFERENCES establishment.establishment_party_role_type (establishment_party_role_type_id),
    legal_entity_id uuid
        REFERENCES establishment.legal_entity (legal_entity_id),
    person_id uuid
        REFERENCES establishment.person (person_id),
    start_date date,
    end_date date,
    CHECK ((legal_entity_id IS NOT NULL) <> (person_id IS NOT NULL)),
    CHECK (person_id IS NULL OR establishment_party_role_type_id = 4),
    CHECK (end_date IS NULL OR start_date IS NULL OR end_date >= start_date)
);

CREATE UNIQUE INDEX establishment_party_role_legal_entity_period_unique
    ON establishment.establishment_party_role (
        legal_entity_id,
        establishment_party_role_type_id,
        COALESCE(start_date, DATE '-infinity')
    )
    WHERE legal_entity_id IS NOT NULL;

CREATE UNIQUE INDEX establishment_party_role_person_period_unique
    ON establishment.establishment_party_role (
        person_id,
        establishment_party_role_type_id,
        COALESCE(start_date, DATE '-infinity')
    )
    WHERE person_id IS NOT NULL;

CREATE TABLE establishment.academy_trust_type (
    academy_trust_type_id integer PRIMARY KEY,
    name text NOT NULL UNIQUE
);

CREATE TABLE establishment.academy_trust_classification (
    academy_trust_classification_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    legal_entity_id uuid NOT NULL
        REFERENCES establishment.legal_entity (legal_entity_id),
    academy_trust_type_id integer NOT NULL
        REFERENCES establishment.academy_trust_type (academy_trust_type_id),
    start_date date,
    end_date date,
    is_current boolean NOT NULL DEFAULT false,
    CHECK (end_date IS NULL OR start_date IS NULL OR end_date >= start_date)
);

CREATE UNIQUE INDEX academy_trust_classification_period_unique
    ON establishment.academy_trust_classification (
        legal_entity_id,
        academy_trust_type_id,
        COALESCE(start_date, DATE '-infinity')
    );

CREATE UNIQUE INDEX academy_trust_classification_current_legal_entity_unique
    ON establishment.academy_trust_classification (legal_entity_id)
    WHERE is_current;

CREATE TABLE establishment.establishment_responsibility_type (
    responsibility_type_id integer PRIMARY KEY,
    name text NOT NULL UNIQUE
);

CREATE TABLE establishment.establishment_responsibility (
    establishment_responsibility_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    establishment_id uuid NOT NULL
        REFERENCES establishment.establishment (establishment_id),
    legal_entity_id uuid
        REFERENCES establishment.legal_entity (legal_entity_id),
    person_id uuid
        REFERENCES establishment.person (person_id),
    responsibility_type_id integer NOT NULL
        REFERENCES establishment.establishment_responsibility_type (responsibility_type_id),
    academy_trust_type_id integer
        REFERENCES establishment.academy_trust_type (academy_trust_type_id),
    start_date date,
    end_date date,
    is_current boolean NOT NULL DEFAULT false,
    CHECK ((legal_entity_id IS NOT NULL) <> (person_id IS NOT NULL)),
    end_date_basis text CHECK (end_date_basis IN ('evidenced', 'inferred')),
    first_observed_date date,
    CHECK (end_date IS NOT NULL OR end_date_basis IS NULL),
    CHECK (person_id IS NULL OR responsibility_type_id = 3),
    CHECK ((responsibility_type_id = 1) = (academy_trust_type_id IS NOT NULL)),
    CHECK (end_date IS NULL OR start_date IS NULL OR end_date >= start_date)
);

CREATE UNIQUE INDEX establishment_responsibility_legal_entity_period_unique
    ON establishment.establishment_responsibility (
        establishment_id,
        legal_entity_id,
        responsibility_type_id,
        COALESCE(start_date, DATE '-infinity')
    )
    WHERE legal_entity_id IS NOT NULL;

CREATE UNIQUE INDEX establishment_responsibility_person_period_unique
    ON establishment.establishment_responsibility (
        establishment_id,
        person_id,
        responsibility_type_id,
        COALESCE(start_date, DATE '-infinity')
    )
    WHERE person_id IS NOT NULL;

CREATE UNIQUE INDEX establishment_responsibility_current_academy_trust_unique
    ON establishment.establishment_responsibility (establishment_id)
    WHERE is_current AND responsibility_type_id = 1;

CREATE TABLE establishment.organisation_group_type (
    organisation_group_type_id integer PRIMARY KEY,
    name text NOT NULL UNIQUE
);

CREATE TABLE establishment.organisation_group (
    organisation_group_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    name text NOT NULL CHECK (btrim(name) <> ''),
    organisation_group_type_id integer NOT NULL
        REFERENCES establishment.organisation_group_type (organisation_group_type_id),
    local_authority_area_id uuid
        REFERENCES establishment.local_authority_area (local_authority_area_id),
    open_date date,
    close_date date,
    CHECK (close_date IS NULL OR open_date IS NULL OR close_date >= open_date)
);

COMMENT ON COLUMN establishment.organisation_group.local_authority_area_id IS
    'The DfE LA-code area recorded by GIAS for a children''s-centre group. Council identity is resolved through local_authority_area_council_period periods where the mapping is known.';

CREATE TABLE establishment.organisation_group_member (
    organisation_group_member_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    organisation_group_id uuid NOT NULL
        REFERENCES establishment.organisation_group (organisation_group_id),
    establishment_id uuid NOT NULL
        REFERENCES establishment.establishment (establishment_id),
    joined_date date,
    left_date date,
    CHECK (left_date IS NULL OR joined_date IS NULL OR left_date >= joined_date)
);

CREATE TABLE establishment.group_identifier_type (
    group_identifier_type_id integer PRIMARY KEY,
    name text NOT NULL UNIQUE
);

CREATE TABLE establishment.group_identifier_issuer (
    group_identifier_issuer_id integer PRIMARY KEY,
    name text NOT NULL UNIQUE
);

CREATE TABLE establishment.group_identifier (
    group_identifier_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    establishment_party_role_id uuid
        REFERENCES establishment.establishment_party_role (establishment_party_role_id),
    organisation_group_id uuid
        REFERENCES establishment.organisation_group (organisation_group_id),
    group_identifier_type_id integer NOT NULL
        REFERENCES establishment.group_identifier_type (group_identifier_type_id),
    group_identifier_issuer_id integer NOT NULL
        REFERENCES establishment.group_identifier_issuer (group_identifier_issuer_id),
    value text NOT NULL CHECK (btrim(value) <> ''),
    is_current boolean NOT NULL DEFAULT true,
    CHECK ((establishment_party_role_id IS NOT NULL) <> (organisation_group_id IS NOT NULL)
)
);

CREATE UNIQUE INDEX group_identifier_value_unique
    ON establishment.group_identifier (group_identifier_type_id, value);

CREATE UNIQUE INDEX group_identifier_role_current_type_unique
    ON establishment.group_identifier (establishment_party_role_id, group_identifier_type_id)
    WHERE establishment_party_role_id IS NOT NULL AND is_current;

CREATE UNIQUE INDEX group_identifier_group_current_type_unique
    ON establishment.group_identifier (organisation_group_id, group_identifier_type_id)
    WHERE organisation_group_id IS NOT NULL AND is_current;

-- Dated lead designation, independent of membership.
CREATE UNIQUE INDEX organisation_group_member_group_key
    ON establishment.organisation_group_member (organisation_group_member_id, organisation_group_id);

CREATE TABLE establishment.organisation_group_member_lead_period (
    organisation_group_member_lead_period_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    organisation_group_member_id uuid NOT NULL,
    organisation_group_id uuid NOT NULL,
    start_date date,
    end_date date,
    is_current boolean NOT NULL,
    FOREIGN KEY (organisation_group_member_id, organisation_group_id)
        REFERENCES establishment.organisation_group_member (organisation_group_member_id, organisation_group_id),
    CHECK (start_date IS NULL OR end_date IS NULL OR end_date > start_date),
    -- Only fully evidenced periods participate. NULL is unknown, not infinity.
    EXCLUDE USING gist (organisation_group_id WITH =, daterange(start_date,end_date,'[)') WITH &&)
        WHERE (start_date IS NOT NULL AND end_date IS NOT NULL)
);
CREATE UNIQUE INDEX organisation_group_lead_current_unique
    ON establishment.organisation_group_member_lead_period (organisation_group_id) WHERE is_current;
CREATE INDEX organisation_group_lead_member_index
    ON establishment.organisation_group_member_lead_period (organisation_group_member_id);

CREATE FUNCTION establishment.check_group_member_lead_period()
RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE member_record record;
BEGIN
    SELECT m.joined_date,m.left_date,t.name AS group_type INTO STRICT member_record
    FROM establishment.organisation_group_member m
    JOIN establishment.organisation_group g USING (organisation_group_id)
    JOIN establishment.organisation_group_type t USING (organisation_group_type_id)
    WHERE m.organisation_group_member_id=NEW.organisation_group_member_id
      AND m.organisation_group_id=NEW.organisation_group_id
    FOR SHARE OF m,g;
    IF member_record.group_type<>'Children''s-centre group' THEN
        RAISE EXCEPTION 'Lead periods apply only to childrens-centre group memberships' USING ERRCODE='23514';
    END IF;
    IF (NEW.start_date IS NOT NULL AND member_record.joined_date IS NOT NULL AND NEW.start_date<member_record.joined_date)
       OR (NEW.end_date IS NOT NULL AND member_record.left_date IS NOT NULL AND NEW.end_date>member_record.left_date)
       OR (NEW.start_date IS NOT NULL AND member_record.left_date IS NOT NULL AND NEW.start_date>=member_record.left_date)
       OR (NEW.end_date IS NOT NULL AND member_record.joined_date IS NOT NULL AND NEW.end_date<=member_record.joined_date) THEN
        RAISE EXCEPTION 'Lead period falls outside known membership boundaries' USING ERRCODE='23514';
    END IF;
    IF NEW.is_current AND member_record.left_date IS NOT NULL AND member_record.left_date<=CURRENT_DATE THEN
        RAISE EXCEPTION 'An ended membership cannot hold a current lead assertion' USING ERRCODE='23514';
    END IF;
    RETURN NEW;
END $$;
CREATE TRIGGER check_group_member_lead_period BEFORE INSERT OR UPDATE
    ON establishment.organisation_group_member_lead_period
    FOR EACH ROW EXECUTE FUNCTION establishment.check_group_member_lead_period();

CREATE FUNCTION establishment.check_membership_lead_boundaries()
RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM establishment.organisation_group_member_lead_period p
        WHERE p.organisation_group_member_id=NEW.organisation_group_member_id
          AND ((p.start_date IS NOT NULL AND NEW.joined_date IS NOT NULL AND p.start_date<NEW.joined_date)
            OR (p.end_date IS NOT NULL AND NEW.left_date IS NOT NULL AND p.end_date>NEW.left_date)
            OR (p.start_date IS NOT NULL AND NEW.left_date IS NOT NULL AND p.start_date>=NEW.left_date)
            OR (p.end_date IS NOT NULL AND NEW.joined_date IS NOT NULL AND p.end_date<=NEW.joined_date))) THEN
        RAISE EXCEPTION 'Membership change would exclude an existing lead period' USING ERRCODE='23514';
    END IF;
    IF NEW.left_date IS NOT NULL AND NEW.left_date<=CURRENT_DATE AND EXISTS (
        SELECT 1 FROM establishment.organisation_group_member_lead_period p
        WHERE p.organisation_group_member_id=NEW.organisation_group_member_id AND p.is_current) THEN
        RAISE EXCEPTION 'End the current lead assertion before ending membership' USING ERRCODE='23514';
    END IF;
    RETURN NEW;
END $$;
CREATE TRIGGER check_membership_lead_boundaries BEFORE UPDATE OF joined_date,left_date
    ON establishment.organisation_group_member
    FOR EACH ROW EXECUTE FUNCTION establishment.check_membership_lead_boundaries();

-- Group/legal-entity address periods; business boundaries may be unknown.
CREATE TABLE establishment.address_purpose (
    address_purpose_id integer PRIMARY KEY,
    code text NOT NULL UNIQUE,
    name text NOT NULL UNIQUE,
    CHECK ((address_purpose_id=1 AND code='registered') OR
           (address_purpose_id=2 AND code='contact') OR
           (address_purpose_id=3 AND code='administrative'))
);

CREATE TABLE establishment.legal_entity_address (
    legal_entity_address_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    legal_entity_id uuid NOT NULL REFERENCES establishment.legal_entity(legal_entity_id),
    address_id uuid NOT NULL REFERENCES establishment.address(address_id),
    address_purpose_id integer NOT NULL REFERENCES establishment.address_purpose(address_purpose_id),
    start_date date,
    end_date date,
    is_current boolean NOT NULL DEFAULT true,
    CONSTRAINT legal_entity_address_dates_check
        CHECK (start_date IS NULL OR end_date IS NULL OR end_date>start_date),
    CONSTRAINT legal_entity_address_known_periods_excl
        EXCLUDE USING gist (legal_entity_id WITH =, address_purpose_id WITH =,
                            daterange(start_date,end_date,'[)') WITH &&)
        WHERE (start_date IS NOT NULL AND end_date IS NOT NULL)
);

CREATE TABLE establishment.organisation_group_address (
    organisation_group_address_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    organisation_group_id uuid NOT NULL REFERENCES establishment.organisation_group(organisation_group_id),
    address_id uuid NOT NULL REFERENCES establishment.address(address_id),
    address_purpose_id integer NOT NULL REFERENCES establishment.address_purpose(address_purpose_id),
    CHECK (address_purpose_id IN (2,3)),
    start_date date,
    end_date date,
    is_current boolean NOT NULL DEFAULT true,
    CONSTRAINT organisation_group_address_dates_check
        CHECK (start_date IS NULL OR end_date IS NULL OR end_date>start_date),
    CONSTRAINT organisation_group_address_known_periods_excl
        EXCLUDE USING gist (organisation_group_id WITH =, address_purpose_id WITH =,
                            daterange(start_date,end_date,'[)') WITH &&)
        WHERE (start_date IS NOT NULL AND end_date IS NOT NULL)
);

CREATE UNIQUE INDEX legal_entity_address_one_current
    ON establishment.legal_entity_address(legal_entity_id,address_purpose_id) WHERE is_current;
CREATE UNIQUE INDEX organisation_group_address_one_current
    ON establishment.organisation_group_address(organisation_group_id,address_purpose_id) WHERE is_current;

-- A DfE LA-code area and its council are distinct identities. The same council
-- can cover several areas; one area can have successive councils over time.
CREATE TABLE establishment.local_authority_area_council_period (
    local_authority_area_council_period_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    local_authority_area_id uuid NOT NULL
        REFERENCES establishment.local_authority_area (local_authority_area_id),
    legal_entity_id uuid NOT NULL
        REFERENCES establishment.legal_entity (legal_entity_id),
    start_date date,
    end_date date,
    is_current boolean NOT NULL DEFAULT false,
    CHECK (end_date IS NULL OR start_date IS NULL OR end_date >= start_date),
    CONSTRAINT local_authority_area_council_period_known_periods_excl
        EXCLUDE USING gist (local_authority_area_id WITH =,
                            daterange(start_date, end_date, '[)') WITH &&)
        WHERE (start_date IS NOT NULL AND end_date IS NOT NULL)
);

CREATE UNIQUE INDEX local_authority_area_council_period_one_current
    ON establishment.local_authority_area_council_period (local_authority_area_id)
    WHERE is_current;
CREATE INDEX local_authority_area_council_period_holder
    ON establishment.local_authority_area_council_period (legal_entity_id);

COMMENT ON TABLE establishment.local_authority_area_council_period IS
    'Effective council responsibility for a DfE LA-code area. Formation and source observation dates are separate facts. Incomplete council backfill is reported by validation.';

CREATE FUNCTION establishment.check_local_authority_council_holder()
RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE
    holder_ids uuid[];
    holder_type integer;
BEGIN
    IF TG_OP = 'INSERT' THEN
        holder_ids := ARRAY[NEW.legal_entity_id];
    ELSIF TG_OP = 'UPDATE' THEN
        holder_ids := ARRAY[OLD.legal_entity_id, NEW.legal_entity_id];
    ELSE
        holder_ids := ARRAY[OLD.legal_entity_id];
    END IF;
    PERFORM 1 FROM establishment.legal_entity
    WHERE legal_entity_id = ANY(holder_ids) ORDER BY legal_entity_id FOR UPDATE;
    -- Version the already locked parent rows, without changing business values.
    -- A concurrent legal-form update at repeatable-read isolation must then
    -- serialize or fail, rather than validating against a stale child snapshot.
    UPDATE establishment.legal_entity AS c
    SET legal_entity_type_id = c.legal_entity_type_id
    WHERE c.legal_entity_id = ANY(holder_ids);
    IF TG_OP = 'DELETE' THEN RETURN OLD; END IF;
    SELECT legal_entity_type_id INTO holder_type FROM establishment.legal_entity
    WHERE legal_entity_id = NEW.legal_entity_id;
    IF holder_type IS DISTINCT FROM 9 THEN
        RAISE EXCEPTION 'A council-area holder must be a Public body (legal type 9)'
            USING ERRCODE = '23514';
    END IF;
    RETURN NEW;
END $$;

CREATE TRIGGER check_local_authority_council_holder
BEFORE INSERT OR UPDATE OR DELETE ON establishment.local_authority_area_council_period
FOR EACH ROW EXECUTE FUNCTION establishment.check_local_authority_council_holder();

CREATE FUNCTION establishment.check_council_legal_form()
RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
    IF NEW.legal_entity_type_id IS NOT DISTINCT FROM OLD.legal_entity_type_id THEN
        RETURN NEW;
    END IF;
    IF NEW.legal_entity_type_id IS DISTINCT FROM 9 AND (
        EXISTS (SELECT 1 FROM establishment.local_authority_area_council_period
                WHERE legal_entity_id = OLD.legal_entity_id)
        OR EXISTS (SELECT 1 FROM establishment.establishment_responsibility
                   WHERE legal_entity_id = OLD.legal_entity_id AND responsibility_type_id = 5)
    ) THEN
        RAISE EXCEPTION 'A referenced council must retain Public body legal type 9'
            USING ERRCODE = '23514';
    END IF;
    IF NEW.legal_entity_type_id IS DISTINCT FROM 11
       AND EXISTS (SELECT 1 FROM establishment.legal_entity_sole_trader
                   WHERE legal_entity_id=OLD.legal_entity_id) THEN
        RAISE EXCEPTION 'A sole-trader subtype must retain legal type 11' USING ERRCODE='23514';
    END IF;
    IF NEW.legal_entity_type_id IS DISTINCT FROM 12
       AND EXISTS (SELECT 1 FROM establishment.legal_entity_partner
                   WHERE partnership_legal_entity_id=OLD.legal_entity_id) THEN
        RAISE EXCEPTION 'A partnership with partner links must retain legal type 12' USING ERRCODE='23514';
    END IF;
    IF (NEW.legal_entity_type_id IS NULL OR NEW.legal_entity_type_id NOT IN (1,2,3,4,5,6,7))
       AND EXISTS (SELECT 1 FROM establishment.legal_entity_partner
                   WHERE partner_legal_entity_id=OLD.legal_entity_id) THEN
        RAISE EXCEPTION 'A partner body must retain an eligible incorporated legal type' USING ERRCODE='23514';
    END IF;
    RETURN NEW;
END $$;

CREATE TRIGGER check_council_legal_form
BEFORE UPDATE OF legal_entity_type_id ON establishment.legal_entity
FOR EACH ROW EXECUTE FUNCTION establishment.check_council_legal_form();

CREATE FUNCTION establishment.check_council_retains_area_link()
RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
    -- Check the final transaction state so an atomic replacement is allowed.
    PERFORM 1 FROM establishment.legal_entity
    WHERE legal_entity_id = OLD.legal_entity_id FOR UPDATE;
    IF EXISTS (SELECT 1 FROM establishment.establishment_responsibility
               WHERE legal_entity_id = OLD.legal_entity_id AND responsibility_type_id = 5)
       AND NOT EXISTS (SELECT 1 FROM establishment.local_authority_area_council_period
                       WHERE legal_entity_id = OLD.legal_entity_id) THEN
        RAISE EXCEPTION 'A council holding maintenance must retain an area link'
            USING ERRCODE = '23514';
    END IF;
    RETURN NULL;
END $$;

CREATE CONSTRAINT TRIGGER check_council_retains_area_link
AFTER DELETE OR UPDATE ON establishment.local_authority_area_council_period
DEFERRABLE INITIALLY DEFERRED
FOR EACH ROW EXECUTE FUNCTION establishment.check_council_retains_area_link();

CREATE UNIQUE INDEX establishment_responsibility_current_maintenance_unique
    ON establishment.establishment_responsibility (establishment_id)
    WHERE is_current AND responsibility_type_id = 5;

ALTER TABLE establishment.establishment_responsibility
    ADD CONSTRAINT establishment_responsibility_maintenance_known_periods_excl
    EXCLUDE USING gist (establishment_id WITH =, daterange(start_date,end_date,'[)') WITH &&)
    WHERE (responsibility_type_id=5 AND start_date IS NOT NULL AND end_date IS NOT NULL);

CREATE FUNCTION establishment.check_maintenance_council_holder()
RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE holder_ids uuid[];
BEGIN
    IF TG_OP='INSERT' AND NEW.responsibility_type_id<>5 THEN RETURN NEW; END IF;
    IF TG_OP='DELETE' AND OLD.responsibility_type_id<>5 THEN RETURN OLD; END IF;
    IF TG_OP='UPDATE' AND OLD.responsibility_type_id<>5 AND NEW.responsibility_type_id<>5 THEN RETURN NEW; END IF;
    IF TG_OP='DELETE' THEN holder_ids:=ARRAY[OLD.legal_entity_id];
    ELSIF TG_OP='UPDATE' THEN holder_ids:=ARRAY[OLD.legal_entity_id,NEW.legal_entity_id];
    ELSE holder_ids:=ARRAY[NEW.legal_entity_id]; END IF;
    PERFORM 1 FROM establishment.legal_entity WHERE legal_entity_id=ANY(holder_ids)
    ORDER BY legal_entity_id FOR UPDATE;
    -- Version the parents, as the council-period guard does, to protect
    -- repeatable-read writers against stale dependent-table snapshots.
    UPDATE establishment.legal_entity SET legal_entity_type_id=legal_entity_type_id
    WHERE legal_entity_id=ANY(holder_ids);
    IF TG_OP='DELETE' THEN RETURN OLD; END IF;
    IF NEW.responsibility_type_id=5 AND (
        NOT EXISTS (SELECT 1 FROM establishment.legal_entity
                    WHERE legal_entity_id=NEW.legal_entity_id AND legal_entity_type_id=9)) THEN
        RAISE EXCEPTION 'Maintenance holder must be a Public body council with an area link'
            USING ERRCODE='23514';
    END IF;
    RETURN NEW;
END $$;

CREATE TRIGGER check_maintenance_council_holder
BEFORE INSERT OR UPDATE OR DELETE ON establishment.establishment_responsibility
FOR EACH ROW EXECUTE FUNCTION establishment.check_maintenance_council_holder();

CREATE FUNCTION establishment.check_maintenance_area_link()
RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM establishment.establishment_responsibility r
               WHERE r.establishment_responsibility_id=NEW.establishment_responsibility_id
                 AND r.responsibility_type_id=5 AND NOT EXISTS (
                     SELECT 1 FROM establishment.local_authority_area_council_period p
                     WHERE p.legal_entity_id=r.legal_entity_id)) THEN
        RAISE EXCEPTION 'Maintenance council must retain an area link' USING ERRCODE='23514';
    END IF;
    RETURN NULL;
END $$;

CREATE CONSTRAINT TRIGGER check_maintenance_area_link
AFTER INSERT OR UPDATE ON establishment.establishment_responsibility
DEFERRABLE INITIALLY DEFERRED
FOR EACH ROW EXECUTE FUNCTION establishment.check_maintenance_area_link();

CREATE TABLE establishment.legal_entity_sole_trader (
    legal_entity_id uuid PRIMARY KEY REFERENCES establishment.legal_entity(legal_entity_id),
    person_id uuid NOT NULL UNIQUE REFERENCES establishment.person(person_id)
);

CREATE FUNCTION establishment.check_sole_trader_type()
RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE holder_ids uuid[];
BEGIN
    IF TG_OP='INSERT' THEN holder_ids:=ARRAY[NEW.legal_entity_id];
    ELSIF TG_OP='UPDATE' THEN holder_ids:=ARRAY[OLD.legal_entity_id,NEW.legal_entity_id];
    ELSE holder_ids:=ARRAY[OLD.legal_entity_id]; END IF;
    PERFORM 1 FROM establishment.legal_entity WHERE legal_entity_id=ANY(holder_ids)
    ORDER BY legal_entity_id FOR UPDATE;
    UPDATE establishment.legal_entity c SET legal_entity_type_id=c.legal_entity_type_id
    WHERE c.legal_entity_id=ANY(holder_ids);
    IF TG_OP='DELETE' THEN RETURN OLD; END IF;
    IF NOT EXISTS (SELECT 1 FROM establishment.legal_entity
                   WHERE legal_entity_id=NEW.legal_entity_id AND legal_entity_type_id=11) THEN
        RAISE EXCEPTION 'A sole-trader subtype requires legal type 11' USING ERRCODE='23514';
    END IF;
    RETURN NEW;
END $$;
CREATE TRIGGER check_sole_trader_type
BEFORE INSERT OR UPDATE OR DELETE ON establishment.legal_entity_sole_trader
FOR EACH ROW EXECUTE FUNCTION establishment.check_sole_trader_type();

CREATE TABLE establishment.legal_entity_partner (
    legal_entity_partner_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    partnership_legal_entity_id uuid NOT NULL REFERENCES establishment.legal_entity(legal_entity_id),
    partner_legal_entity_id uuid REFERENCES establishment.legal_entity(legal_entity_id),
    partner_person_id uuid REFERENCES establishment.person(person_id),
    start_date date,
    end_date date,
    is_current boolean NOT NULL DEFAULT false,
    CHECK ((partner_legal_entity_id IS NOT NULL) <> (partner_person_id IS NOT NULL)),
    CHECK (partner_legal_entity_id IS NULL OR partner_legal_entity_id <> partnership_legal_entity_id),
    CHECK (end_date IS NULL OR start_date IS NULL OR end_date >= start_date)
);
CREATE UNIQUE INDEX legal_entity_partner_current_person_unique
    ON establishment.legal_entity_partner(partnership_legal_entity_id,partner_person_id)
    WHERE is_current AND partner_person_id IS NOT NULL;
CREATE UNIQUE INDEX legal_entity_partner_current_body_unique
    ON establishment.legal_entity_partner(partnership_legal_entity_id,partner_legal_entity_id)
    WHERE is_current AND partner_legal_entity_id IS NOT NULL;
ALTER TABLE establishment.legal_entity_partner
    ADD CONSTRAINT legal_entity_partner_known_periods_excl
    EXCLUDE USING gist (partnership_legal_entity_id WITH =,
                        (partner_person_id IS NOT NULL) WITH =,
                        (COALESCE(partner_legal_entity_id,partner_person_id)) WITH =,
                        daterange(start_date,end_date,'[)') WITH &&)
    WHERE (start_date IS NOT NULL AND end_date IS NOT NULL);

CREATE FUNCTION establishment.check_partner_relationship()
RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE parent_type integer; partner_type integer; holder_ids uuid[];
BEGIN
    IF TG_OP='INSERT' THEN holder_ids:=ARRAY[NEW.partnership_legal_entity_id,NEW.partner_legal_entity_id];
    ELSIF TG_OP='UPDATE' THEN holder_ids:=ARRAY[OLD.partnership_legal_entity_id,OLD.partner_legal_entity_id,
                                              NEW.partnership_legal_entity_id,NEW.partner_legal_entity_id];
    ELSE holder_ids:=ARRAY[OLD.partnership_legal_entity_id,OLD.partner_legal_entity_id]; END IF;
    PERFORM 1 FROM establishment.legal_entity WHERE legal_entity_id=ANY(holder_ids)
    ORDER BY legal_entity_id FOR UPDATE;
    UPDATE establishment.legal_entity c SET legal_entity_type_id=c.legal_entity_type_id
    WHERE c.legal_entity_id=ANY(holder_ids);
    IF TG_OP='DELETE' THEN RETURN OLD; END IF;
    SELECT legal_entity_type_id INTO parent_type FROM establishment.legal_entity
    WHERE legal_entity_id=NEW.partnership_legal_entity_id FOR UPDATE;
    IF parent_type IS DISTINCT FROM 12 THEN
        RAISE EXCEPTION 'Partner links require a Traditional partnership parent' USING ERRCODE='23514';
    END IF;
    IF NEW.partner_legal_entity_id IS NOT NULL THEN
        SELECT legal_entity_type_id INTO partner_type FROM establishment.legal_entity
        WHERE legal_entity_id=NEW.partner_legal_entity_id FOR UPDATE;
        IF partner_type IS NULL OR partner_type NOT IN (1,2,3,4,5,6,7) THEN
            RAISE EXCEPTION 'Partner body must have an eligible incorporated legal type' USING ERRCODE='23514';
        END IF;
    END IF;
    RETURN NEW;
END $$;
CREATE TRIGGER check_partner_relationship
BEFORE INSERT OR UPDATE OR DELETE ON establishment.legal_entity_partner
FOR EACH ROW EXECUTE FUNCTION establishment.check_partner_relationship();

COMMIT;
