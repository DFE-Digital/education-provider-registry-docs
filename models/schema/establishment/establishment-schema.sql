-- Complete WIP Establishment schema: tables, keys, indexes, constraints and two triggers.
-- Run in an existing PostgreSQL database with permission to install the extensions.
-- Creation only: an existing establishment schema causes failure, not data deletion.
-- No seeds, migration-evidence schema, permissions policy or external SQL includes.
BEGIN;
CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS btree_gist;
CREATE SCHEMA establishment;

CREATE TABLE establishment.establishment_type (
    establishment_type_id integer PRIMARY KEY,
    name text NOT NULL
);

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
    name text NOT NULL CHECK (name !~* '^(unknown|not applicable( \(.*\))?|does not apply|not known)$') UNIQUE
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
    establishment_type_id integer NOT NULL REFERENCES establishment.establishment_type (establishment_type_id),
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
    CHECK (person_id IS NULL OR responsibility_type_id IN (3, 4)),
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
    local_authority_id uuid
        REFERENCES establishment.local_authority (local_authority_id),
    open_date date,
    close_date date,
    CHECK (close_date IS NULL OR open_date IS NULL OR close_date >= open_date)
);

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

COMMIT;
