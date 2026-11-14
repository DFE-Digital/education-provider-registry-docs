-- Explicit development batch body, executed inside the runner's rollback scope.
-- __BATCH_URNS__ is the only per-attempt substitution. Keep casts here so
-- invalid source values are isolated along with constraint failures.


SET LOCAL synchronous_commit = off;

INSERT INTO source_establishment_fixture (urn,ukprn,local_authority_code,government_office_region_code,district_administrative_code,administrative_ward_code,parliamentary_constituency_code,lsoa_code,msoa_code,urban_rural_code,establishment_number,name,website,telephone_number,status_code,open_date,close_date,reason_opened_code,reason_opened_name,reason_closed_code,reason_closed_name,last_changed_date,source_establishment_type_code,source_education_phase_code,school_capacity,pupil_count,free_school_meal_measure,census_date,resourced_provision_capacity,resourced_provision_pupil_count,sen_unit_capacity,sen_unit_pupil_count,lower_statutory_age,upper_statutory_age,gender_of_entry_type_id,admissions_policy_id,boarding_provision_id,nursery_provision_id,sixth_form_provision_id,specialist_provision_type_id,main_site_name,address_line_1,address_line_2,address_line_3,address_town,address_county,address_postcode,address_uprn,source_further_education_type_code,further_education_type_id,source_section_41_approval_status_code,section_41_approval_status_id,source_religious_character_code,religious_character_id,source_religious_ethos_code,religious_ethos_id,source_diocese_code,source_diocese_id,source_education_phase,ofsted_link,source_specialist_provision_type_code,source_special_classes_code,has_special_classes,source_observed_date,source_establishment_type_category_code,source_admissions_policy_code,source_boarding_provision_code,source_nursery_provision_code,source_sixth_form_provision_code) SELECT s.urn::integer,s.ukprn::numeric,s.local_authority_code::text,s.government_office_region_code::text,s.district_administrative_code::text,s.administrative_ward_code::text,s.parliamentary_constituency_code::text,s.lsoa_code::text,s.msoa_code::text,s.urban_rural_code::text,s.establishment_number::integer,s.name::text,s.website::text,s.telephone_number::text,s.status_code::text,s.open_date::date,s.close_date::date,s.reason_opened_code::text,s.reason_opened_name::text,s.reason_closed_code::text,s.reason_closed_name::text,s.last_changed_date::date,s.source_establishment_type_code::text,s.source_education_phase_code::text,s.school_capacity::integer,s.pupil_count::integer,s.free_school_meal_measure::integer,s.census_date::date,s.resourced_provision_capacity::integer,s.resourced_provision_pupil_count::integer,s.sen_unit_capacity::integer,s.sen_unit_pupil_count::integer,s.lower_statutory_age::integer,s.upper_statutory_age::integer,s.gender_of_entry_type_id::integer,s.admissions_policy_id::integer,s.boarding_provision_id::integer,s.nursery_provision_id::integer,s.sixth_form_provision_id::integer,s.specialist_provision_type_id::integer,s.main_site_name::text,s.address_line_1::text,s.address_line_2::text,s.address_line_3::text,s.address_town::text,s.address_county::text,s.address_postcode::text,s.address_uprn::text,s.source_further_education_type_code::text,s.further_education_type_id::integer,s.source_section_41_approval_status_code::text,s.section_41_approval_status_id::integer,s.source_religious_character_code::text,s.religious_character_id::integer,s.source_religious_ethos_code::text,s.religious_ethos_id::integer,s.source_diocese_code::text,s.source_diocese_id::integer,s.source_education_phase::text,s.ofsted_link::text,s.source_specialist_provision_type_code::text,s.source_special_classes_code::text,s.has_special_classes::boolean,s.source_observed_date::date,s.source_establishment_type_category_code::text,s.source_admissions_policy_code::text,s.source_boarding_provision_code::text,s.source_nursery_provision_code::text,s.source_sixth_form_provision_code::text FROM establishment_seed_stage s WHERE s.urn IN (__BATCH_URNS__);
ANALYZE source_establishment_fixture;


UPDATE source_establishment_fixture s
SET establishment_type_id = t.establishment_type_id
FROM establishment.establishment_type t
WHERE t.code = NULLIF(BTRIM(s.source_establishment_type_code), '');

UPDATE source_establishment_fixture s
SET diocese_id = d.diocese_id
FROM establishment.diocese d
WHERE d.code = NULLIF(BTRIM(s.source_diocese_code), '');

-- Resolve source-owned classifications from the actual imported dictionaries.
-- Retained source metadata distinguishes an intentional exclusion from a broken
-- source reference. Transform-generated integer hints are never authoritative.
DO $$
DECLARE
    r record;
    invalid boolean;
    resolved_map jsonb;
    known_map jsonb;
    missing_map jsonb;
    key_type text;
    value_expression text;
    assignments text := '';
    changes text := '';
BEGIN
    IF NOT EXISTS(SELECT 1 FROM imported_reference_mapping) THEN
        RAISE EXCEPTION 'Load source-owned reference dictionaries before importing establishments';
    END IF;
    FOR r IN SELECT * FROM (VALUES
        ('admissions_policy','admissions_policy_id','source_admissions_policy_code',false),
        ('boarding_provision','boarding_provision_id','source_boarding_provision_code',false),
        ('nursery_provision','nursery_provision_id','source_nursery_provision_code',false),
        ('sixth_form_provision','sixth_form_provision_id','source_sixth_form_provision_code',false),
        ('specialist_provision_type','specialist_provision_type_id','source_specialist_provision_type_code',false),
        ('further_education_type','further_education_type_id','source_further_education_type_code',true),
        ('section_41_approval_status','section_41_approval_status_id','source_section_41_approval_status_code',true),
        ('religious_character','religious_character_id','source_religious_character_code',true),
        ('religious_ethos','religious_ethos_id','source_religious_ethos_code',true),
        ('diocese','diocese_id','source_diocese_code',true)
    ) v(reference_list,key_column,source_column,has_code) LOOP
        -- Resolve each small dictionary once. JSON key lookup avoids a source
        -- self-join and correlated dictionary scans for every establishment.
        EXECUTE format('SELECT
            coalesce(jsonb_object_agg(m.code,to_jsonb(t.%I)),''{}''::jsonb),
            coalesce(jsonb_object_agg(m.code,true),''{}''::jsonb),
            coalesce(jsonb_object_agg(m.code,true) FILTER (WHERE m.included AND t.%I IS NULL),''{}''::jsonb)
            FROM imported_reference_mapping m
            LEFT JOIN establishment.%I t ON t.code::text=m.code AND m.included
            WHERE m.reference_list=$1',r.key_column,r.key_column,r.reference_list)
            INTO resolved_map,known_map,missing_map USING r.reference_list;
        EXECUTE format('SELECT EXISTS(SELECT 1 FROM source_establishment_fixture s
            WHERE nullif(btrim(s.%I),'''') IS NOT NULL AND NOT ($1 ? s.%I))',
            r.source_column,r.source_column) INTO invalid USING known_map;
        IF invalid THEN RAISE EXCEPTION 'Source establishment has a missing dictionary reference: %',r.reference_list; END IF;
        IF missing_map <> '{}'::jsonb THEN
            EXECUTE format('SELECT EXISTS(SELECT 1 FROM source_establishment_fixture s WHERE $1 ? s.%I)',r.source_column)
                INTO invalid USING missing_map;
            IF invalid THEN RAISE EXCEPTION 'Included source reference is missing from target: %',r.reference_list; END IF;
        END IF;
        SELECT format_type(atttypid,atttypmod) INTO key_type
        FROM pg_attribute WHERE attrelid='source_establishment_fixture'::regclass
          AND attname=r.key_column AND NOT attisdropped;
        value_expression := format('(%L::jsonb ->> s.%I)::%s',resolved_map::text,r.source_column,key_type);
        IF assignments <> '' THEN
            assignments := assignments || ', ';
            changes := changes || ' OR ';
        END IF;
        assignments := assignments || format('%I=%s',r.key_column,value_expression);
        changes := changes || format('s.%I IS DISTINCT FROM %s',r.key_column,value_expression);
    END LOOP;
    EXECUTE 'UPDATE source_establishment_fixture s SET ' || assignments || ' WHERE ' || changes;
END $$;

ANALYZE source_establishment_fixture;

-- Resolve the type before replay filtering so an unsupported code cannot be
-- silently discarded as an older source observation.
DO $$
DECLARE
    invalid_types text;
BEGIN
    SELECT string_agg(format('%s (code %s)', s.urn,
               coalesce(NULLIF(BTRIM(s.source_establishment_type_code), ''), 'missing')), ', ' ORDER BY s.urn)
    INTO invalid_types
    FROM source_establishment_fixture s
    WHERE s.establishment_type_id IS NULL;
    IF invalid_types IS NOT NULL THEN
        RAISE EXCEPTION 'Establishment type code is missing or unsupported for %. Review the source code and seeded type mapping.', invalid_types;
    END IF;
END;
$$;

-- Reference identities resolve by business code, independently of source row IDs.

UPDATE source_establishment_fixture s SET establishment_status_id=r.establishment_status_id
FROM establishment.establishment_status r WHERE r.code::text=NULLIF(BTRIM(s.status_code),'');
UPDATE source_establishment_fixture s SET education_phase_id=r.education_phase_id
FROM establishment.education_phase r WHERE r.code::text=NULLIF(BTRIM(s.source_education_phase_code),'');
UPDATE source_establishment_fixture s SET reason_establishment_opened_id=r.reason_establishment_opened_id
FROM establishment.reason_establishment_opened r WHERE r.code=NULLIF(BTRIM(s.reason_opened_code),'');
UPDATE source_establishment_fixture s SET reason_establishment_closed_id=r.reason_establishment_closed_id
FROM establishment.reason_establishment_closed r WHERE r.code=NULLIF(BTRIM(s.reason_closed_code),'');
DO $$
DECLARE invalid_codes text;
BEGIN
    SELECT string_agg(urn::text, ', ' ORDER BY urn) INTO invalid_codes
    FROM source_establishment_fixture s
    JOIN establishment.establishment_type t USING(establishment_type_id)
    JOIN establishment.establishment_type_category c USING(establishment_type_category_id)
    WHERE s.establishment_status_id IS NULL
       OR (NULLIF(BTRIM(s.source_education_phase_code),'') IS NOT NULL
           AND BTRIM(s.source_education_phase_code) NOT IN ('0','9') AND s.education_phase_id IS NULL)
       OR (NULLIF(BTRIM(s.reason_opened_code),'') IS NOT NULL
           AND BTRIM(s.reason_opened_code) NOT IN ('00','13','99') AND s.reason_establishment_opened_id IS NULL)
       OR (NULLIF(BTRIM(s.reason_closed_code),'') IS NOT NULL
           AND BTRIM(s.reason_closed_code) NOT IN ('00','99') AND s.reason_establishment_closed_id IS NULL)
       OR NULLIF(BTRIM(s.source_establishment_type_category_code),'') IS DISTINCT FROM c.code::text;
    IF invalid_codes IS NOT NULL THEN
        RAISE EXCEPTION 'Missing, unsupported or conflicting status, education phase, lifecycle reason or type-group code for URN %.',invalid_codes;
    END IF;
END $$;




-- Geography reference data must be loaded before establishment geography. Do
-- not silently turn a supplied BAU GOR code into a missing target relation.
DO $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM source_establishment_fixture AS s
        LEFT JOIN establishment.government_office_region AS gor
          ON gor.code = NULLIF(BTRIM(s.government_office_region_code), '')
        WHERE NULLIF(BTRIM(s.government_office_region_code), '') IS NOT NULL
          AND BTRIM(s.government_office_region_code) <> '0'
          AND gor.government_office_region_id IS NULL
    ) THEN
        RAISE EXCEPTION 'Establishment fixture contains a GOR code absent from establishment.government_office_region';
    END IF;
    IF EXISTS (
        SELECT 1
        FROM source_establishment_fixture AS s
        LEFT JOIN establishment.district_administrative AS d
          ON d.code = NULLIF(BTRIM(s.district_administrative_code), '')
        WHERE NULLIF(BTRIM(s.district_administrative_code), '') IS NOT NULL
          AND BTRIM(s.district_administrative_code) <> '0'
          AND d.id IS NULL
    ) THEN
        RAISE EXCEPTION 'Establishment fixture contains a District Administrative code absent from establishment.district_administrative';
    END IF;
    IF EXISTS (
        SELECT 1
        FROM source_establishment_fixture AS s
        LEFT JOIN establishment.administrative_ward AS w
          ON w.code = NULLIF(BTRIM(s.administrative_ward_code), '')
        WHERE NULLIF(BTRIM(s.administrative_ward_code), '') IS NOT NULL
          AND BTRIM(s.administrative_ward_code) <> '0'
          AND w.id IS NULL
    ) THEN
        RAISE EXCEPTION 'Establishment fixture contains an Administrative Ward code absent from establishment.administrative_ward';
    END IF;
    IF EXISTS (
        SELECT 1
        FROM source_establishment_fixture AS s
        LEFT JOIN establishment.parliamentary_constituency AS pc
          ON pc.code = NULLIF(BTRIM(s.parliamentary_constituency_code), '')
        WHERE NULLIF(BTRIM(s.parliamentary_constituency_code), '') IS NOT NULL
          AND BTRIM(s.parliamentary_constituency_code) <> '0'
          AND pc.id IS NULL
    ) THEN
        RAISE EXCEPTION 'Establishment fixture contains a Parliamentary Constituency code absent from establishment.parliamentary_constituency';
    END IF;
    IF EXISTS (SELECT 1 FROM source_establishment_fixture AS s LEFT JOIN establishment.lsoa AS l ON l.code = NULLIF(BTRIM(s.lsoa_code), '') WHERE NULLIF(BTRIM(s.lsoa_code), '') IS NOT NULL AND BTRIM(s.lsoa_code) <> '0' AND l.id IS NULL) THEN
        RAISE EXCEPTION 'Establishment fixture contains an LSOA code absent from establishment.lsoa';
    END IF;
    IF EXISTS (SELECT 1 FROM source_establishment_fixture AS s LEFT JOIN establishment.msoa AS m ON m.code = NULLIF(BTRIM(s.msoa_code), '') WHERE NULLIF(BTRIM(s.msoa_code), '') IS NOT NULL AND BTRIM(s.msoa_code) <> '0' AND m.id IS NULL) THEN
        RAISE EXCEPTION 'Establishment fixture contains an MSOA code absent from establishment.msoa';
    END IF;
    IF EXISTS (SELECT 1 FROM source_establishment_fixture AS s LEFT JOIN establishment.urban_rural AS ur ON ur.code = NULLIF(BTRIM(s.urban_rural_code), '') WHERE NULLIF(BTRIM(s.urban_rural_code), '') IS NOT NULL AND BTRIM(s.urban_rural_code) <> '0' AND ur.id IS NULL) THEN
        RAISE EXCEPTION 'Establishment fixture contains an urban/rural code absent from establishment.urban_rural';
    END IF;
END;
$$;

-- Fail on any value the transform could not map, rather than loading a
-- default. Establishment type code/ID consistency was checked above.
DO $$
DECLARE
    unmapped text;
BEGIN
    SELECT string_agg(urn::text, ', ' ORDER BY urn) INTO unmapped
    FROM source_establishment_fixture
    WHERE source_special_classes_code IS NOT NULL
      AND source_special_classes_code NOT IN ('0','9') AND has_special_classes IS NULL;
    IF unmapped IS NOT NULL THEN
        RAISE EXCEPTION 'Specialist provision or special classes could not be mapped for URN %.', unmapped;
    END IF;
END;
$$;

INSERT INTO establishment.establishment (
    urn, establishment_number, ukprn, name,
    establishment_type_id, education_phase_id,
    further_education_type_id, section_41_approval_status_id,
    religious_character_id, religious_ethos_id, diocese_id, ofsted_link
)
SELECT
    s.urn,
    s.establishment_number,
    s.ukprn,
    s.name,
    s.establishment_type_id,
    s.education_phase_id,
    s.further_education_type_id,
    s.section_41_approval_status_id,
    s.religious_character_id,
    s.religious_ethos_id,
    s.diocese_id,
    NULLIF(BTRIM(s.ofsted_link), '')
FROM source_establishment_fixture AS s
ON CONFLICT (urn) DO UPDATE SET
    establishment_number = EXCLUDED.establishment_number,
    ukprn = EXCLUDED.ukprn,
    name = EXCLUDED.name,
    establishment_type_id = EXCLUDED.establishment_type_id,
    education_phase_id = EXCLUDED.education_phase_id,
    further_education_type_id = EXCLUDED.further_education_type_id,
    section_41_approval_status_id = EXCLUDED.section_41_approval_status_id,
    religious_character_id = EXCLUDED.religious_character_id,
    religious_ethos_id = EXCLUDED.religious_ethos_id,
    diocese_id = EXCLUDED.diocese_id,
    ofsted_link = EXCLUDED.ofsted_link;

-- Geography is an optional owned substructure. A missing, blank or zero
-- source local-authority code means that no local-authority relationship is
-- recorded, rather than creating a sentinel authority record.
DELETE FROM establishment.establishment_geography AS eg
USING source_establishment_fixture AS s
JOIN establishment.establishment AS e ON e.urn = s.urn
WHERE eg.establishment_id = e.establishment_id;

INSERT INTO establishment.establishment_geography (
    establishment_id, local_authority_area_id, government_office_region_id,
    district_administrative_id, administrative_ward_id,
    parliamentary_constituency_id, lsoa_id, msoa_id, urban_rural_id
)
SELECT e.establishment_id,
       la.local_authority_area_id,
       gor.government_office_region_id,
       d.id,
       w.id,
       pc.id, l.id, m.id, ur.id
FROM source_establishment_fixture AS s
JOIN establishment.establishment AS e ON e.urn = s.urn
LEFT JOIN establishment.local_authority_area AS la
  ON la.code = NULLIF(BTRIM(s.local_authority_code), '')::integer
LEFT JOIN establishment.government_office_region AS gor
  ON gor.code = NULLIF(BTRIM(s.government_office_region_code), '')
LEFT JOIN establishment.district_administrative AS d
  ON d.code = NULLIF(BTRIM(s.district_administrative_code), '')
LEFT JOIN establishment.administrative_ward AS w
  ON w.code = NULLIF(BTRIM(s.administrative_ward_code), '')
LEFT JOIN establishment.parliamentary_constituency AS pc
  ON pc.code = NULLIF(BTRIM(s.parliamentary_constituency_code), '')
LEFT JOIN establishment.lsoa AS l
  ON l.code = NULLIF(BTRIM(s.lsoa_code), '')
LEFT JOIN establishment.msoa AS m
  ON m.code = NULLIF(BTRIM(s.msoa_code), '')
LEFT JOIN establishment.urban_rural AS ur
  ON ur.code = NULLIF(BTRIM(s.urban_rural_code), '')
WHERE (NULLIF(BTRIM(s.local_authority_code), '') IS NOT NULL
       AND NULLIF(BTRIM(s.local_authority_code), '')::integer <> 0)
   OR (NULLIF(BTRIM(s.government_office_region_code), '') IS NOT NULL
       AND BTRIM(s.government_office_region_code) <> '0')
   OR (NULLIF(BTRIM(s.district_administrative_code), '') IS NOT NULL
       AND BTRIM(s.district_administrative_code) <> '0')
   OR (NULLIF(BTRIM(s.administrative_ward_code), '') IS NOT NULL
       AND BTRIM(s.administrative_ward_code) <> '0')
   OR (NULLIF(BTRIM(s.parliamentary_constituency_code), '') IS NOT NULL
       AND BTRIM(s.parliamentary_constituency_code) <> '0')
   OR (NULLIF(BTRIM(s.lsoa_code), '') IS NOT NULL AND BTRIM(s.lsoa_code) <> '0')
   OR (NULLIF(BTRIM(s.msoa_code), '') IS NOT NULL AND BTRIM(s.msoa_code) <> '0')
   OR (NULLIF(BTRIM(s.urban_rural_code), '') IS NOT NULL AND BTRIM(s.urban_rural_code) <> '0')
ON CONFLICT (establishment_id) DO UPDATE SET
    local_authority_area_id = EXCLUDED.local_authority_area_id,
    government_office_region_id = EXCLUDED.government_office_region_id,
    district_administrative_id = EXCLUDED.district_administrative_id,
    administrative_ward_id = EXCLUDED.administrative_ward_id,
    parliamentary_constituency_id = EXCLUDED.parliamentary_constituency_id,
    lsoa_id = EXCLUDED.lsoa_id,
    msoa_id = EXCLUDED.msoa_id,
    urban_rural_id = EXCLUDED.urban_rural_id;

INSERT INTO establishment.establishment_contact (establishment_id, website, telephone_number)
SELECT e.establishment_id,
       NULLIF(BTRIM(s.website), ''),
       NULLIF(BTRIM(s.telephone_number), '')
FROM source_establishment_fixture AS s
JOIN establishment.establishment AS e ON e.urn = s.urn
WHERE NULLIF(BTRIM(s.website), '') IS NOT NULL
   OR NULLIF(BTRIM(s.telephone_number), '') IS NOT NULL
ON CONFLICT (establishment_id) DO UPDATE SET
    website = EXCLUDED.website,
   telephone_number = EXCLUDED.telephone_number;

INSERT INTO establishment.establishment_lifecycle (
    establishment_id, establishment_status_id, open_date, close_date,
    reason_establishment_opened_id, reason_establishment_closed_id, last_changed_date
)
SELECT e.establishment_id,
       s.establishment_status_id,
       s.open_date,
       s.close_date,
       s.reason_establishment_opened_id,
       s.reason_establishment_closed_id,
       s.last_changed_date
FROM source_establishment_fixture AS s
JOIN establishment.establishment AS e ON e.urn = s.urn
ON CONFLICT (establishment_id) DO UPDATE SET
    establishment_status_id = EXCLUDED.establishment_status_id,
    open_date = EXCLUDED.open_date,
    close_date = EXCLUDED.close_date,
    reason_establishment_opened_id = EXCLUDED.reason_establishment_opened_id,
    reason_establishment_closed_id = EXCLUDED.reason_establishment_closed_id,
    last_changed_date = EXCLUDED.last_changed_date;

INSERT INTO source_main_site_fixture
SELECT e.establishment_id,
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
LEFT JOIN establishment.establishment_to_site AS ets
  ON ets.establishment_id=e.establishment_id AND ets.is_main_site
LEFT JOIN establishment.site AS ms ON ms.site_id=ets.site_id;

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
    site_id, address_id, site_name, uprn
)
SELECT site_id, address_id, main_site_name,
       NULLIF(address_uprn, '')::bigint
FROM source_main_site_fixture
ON CONFLICT (site_id) DO UPDATE SET
    address_id = EXCLUDED.address_id,
    site_name = EXCLUDED.site_name,
    uprn = EXCLUDED.uprn;

INSERT INTO establishment.establishment_to_site (
    establishment_id, site_id, is_main_site
)
SELECT establishment_id, site_id, true
FROM source_main_site_fixture
ON CONFLICT (establishment_id, site_id) DO UPDATE SET
    is_main_site = EXCLUDED.is_main_site;

INSERT INTO establishment.capacity_and_pupil_measures (
    establishment_id, school_capacity, pupil_count, free_school_meal_measure, census_date
)
SELECT e.establishment_id, s.school_capacity, s.pupil_count,
       s.free_school_meal_measure, s.census_date
FROM source_establishment_fixture AS s
JOIN establishment.establishment AS e ON e.urn = s.urn
WHERE s.school_capacity IS NOT NULL OR s.pupil_count IS NOT NULL OR s.free_school_meal_measure IS NOT NULL
ON CONFLICT (establishment_id) DO UPDATE SET
    school_capacity = EXCLUDED.school_capacity,
    pupil_count = EXCLUDED.pupil_count,
    free_school_meal_measure = EXCLUDED.free_school_meal_measure,
    census_date = EXCLUDED.census_date;

INSERT INTO establishment.education_admissions_and_provision (
    establishment_id, gender_of_entry_type_id, admissions_policy_id,
    boarding_provision_id, nursery_provision_id, sixth_form_provision_id, has_special_classes
)
SELECT e.establishment_id,
       s.gender_of_entry_type_id,
       s.admissions_policy_id,
       s.boarding_provision_id,
       s.nursery_provision_id,
       s.sixth_form_provision_id,
       s.has_special_classes
FROM source_establishment_fixture AS s
JOIN establishment.establishment AS e ON e.urn = s.urn
ON CONFLICT (establishment_id) DO UPDATE SET
    gender_of_entry_type_id = EXCLUDED.gender_of_entry_type_id,
    admissions_policy_id = EXCLUDED.admissions_policy_id,
    boarding_provision_id = EXCLUDED.boarding_provision_id,
    nursery_provision_id = EXCLUDED.nursery_provision_id,
    sixth_form_provision_id = EXCLUDED.sixth_form_provision_id,
    has_special_classes = EXCLUDED.has_special_classes;

INSERT INTO establishment.statutory_age_range (
    education_admissions_and_provision_id, lower_statutory_age, upper_statutory_age
)
SELECT eap.education_admissions_and_provision_id,
       s.lower_statutory_age, s.upper_statutory_age
FROM source_establishment_fixture AS s
JOIN establishment.establishment AS e ON e.urn = s.urn
JOIN establishment.education_admissions_and_provision AS eap
  ON eap.establishment_id = e.establishment_id
WHERE s.lower_statutory_age IS NOT NULL OR s.upper_statutory_age IS NOT NULL
ON CONFLICT (education_admissions_and_provision_id) DO UPDATE SET
    lower_statutory_age = EXCLUDED.lower_statutory_age,
    upper_statutory_age = EXCLUDED.upper_statutory_age;

-- Specialist provision type: 1 resourced provision, 2 SEN unit, 3 both.
-- Clear the previous classification and remove obsolete measure blocks on
-- replay. The existing parent ID remains stable when provision changes.
UPDATE establishment.specialist_provision sp
SET specialist_provision_type_id=s.specialist_provision_type_id
FROM source_establishment_fixture s
JOIN establishment.establishment e ON e.urn=s.urn
WHERE sp.establishment_id=e.establishment_id;

DELETE FROM establishment.resourced_provision r
USING establishment.specialist_provision sp, establishment.establishment e,
      source_establishment_fixture s
WHERE r.specialist_provision_id=sp.specialist_provision_id
  AND sp.establishment_id=e.establishment_id AND e.urn=s.urn
  AND (s.specialist_provision_type_id IS NULL
       OR s.specialist_provision_type_id NOT IN (1,3)
       OR (s.resourced_provision_capacity IS NULL AND s.resourced_provision_pupil_count IS NULL));

DELETE FROM establishment.sen_unit_provision u
USING establishment.specialist_provision sp, establishment.establishment e,
      source_establishment_fixture s
WHERE u.specialist_provision_id=sp.specialist_provision_id
  AND sp.establishment_id=e.establishment_id AND e.urn=s.urn
  AND (s.specialist_provision_type_id IS NULL
       OR s.specialist_provision_type_id NOT IN (2,3)
       OR (s.sen_unit_capacity IS NULL AND s.sen_unit_pupil_count IS NULL));

INSERT INTO establishment.specialist_provision (establishment_id, specialist_provision_type_id)
SELECT e.establishment_id, s.specialist_provision_type_id
FROM source_establishment_fixture AS s
JOIN establishment.establishment AS e ON e.urn = s.urn
WHERE s.specialist_provision_type_id IS NOT NULL
ON CONFLICT (establishment_id) DO UPDATE SET specialist_provision_type_id = EXCLUDED.specialist_provision_type_id;

INSERT INTO establishment.resourced_provision (specialist_provision_id, capacity, pupil_count)
SELECT sp.specialist_provision_id, s.resourced_provision_capacity, s.resourced_provision_pupil_count
FROM source_establishment_fixture AS s
JOIN establishment.establishment AS e ON e.urn = s.urn
JOIN establishment.specialist_provision AS sp ON sp.establishment_id = e.establishment_id
WHERE s.specialist_provision_type_id IN (1, 3)
  AND (s.resourced_provision_capacity IS NOT NULL OR s.resourced_provision_pupil_count IS NOT NULL)
ON CONFLICT (specialist_provision_id) DO UPDATE SET
    capacity = EXCLUDED.capacity, pupil_count = EXCLUDED.pupil_count;

INSERT INTO establishment.sen_unit_provision (specialist_provision_id, capacity, pupil_count)
SELECT sp.specialist_provision_id, s.sen_unit_capacity, s.sen_unit_pupil_count
FROM source_establishment_fixture AS s
JOIN establishment.establishment AS e ON e.urn = s.urn
JOIN establishment.specialist_provision AS sp ON sp.establishment_id = e.establishment_id
WHERE s.specialist_provision_type_id IN (2, 3)
  AND (s.sen_unit_capacity IS NOT NULL OR s.sen_unit_pupil_count IS NOT NULL)
ON CONFLICT (specialist_provision_id) DO UPDATE SET
    capacity = EXCLUDED.capacity, pupil_count = EXCLUDED.pupil_count;



DELETE FROM source_main_site_fixture; DELETE FROM source_establishment_fixture;
