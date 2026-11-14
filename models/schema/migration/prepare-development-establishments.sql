-- Explicit development workspaces; retain these across batch commits.
CREATE TEMP TABLE establishment_seed_stage (urn integer,ukprn text,local_authority_code text,government_office_region_code text,district_administrative_code text,administrative_ward_code text,parliamentary_constituency_code text,lsoa_code text,msoa_code text,urban_rural_code text,establishment_number text,name text,website text,telephone_number text,status_code text,open_date text,close_date text,reason_opened_code text,reason_opened_name text,reason_closed_code text,reason_closed_name text,last_changed_date text,source_establishment_type_code text,source_education_phase_code text,school_capacity text,pupil_count text,free_school_meal_measure text,census_date text,resourced_provision_capacity text,resourced_provision_pupil_count text,sen_unit_capacity text,sen_unit_pupil_count text,lower_statutory_age text,upper_statutory_age text,gender_of_entry_type_id text,admissions_policy_id text,boarding_provision_id text,nursery_provision_id text,sixth_form_provision_id text,specialist_provision_type_id text,main_site_name text,address_line_1 text,address_line_2 text,address_line_3 text,address_town text,address_county text,address_postcode text,address_uprn text,source_further_education_type_code text,further_education_type_id text,source_section_41_approval_status_code text,section_41_approval_status_id text,source_religious_character_code text,religious_character_id text,source_religious_ethos_code text,religious_ethos_id text,source_diocese_code text,source_diocese_id text,source_education_phase text,ofsted_link text,source_specialist_provision_type_code text,source_special_classes_code text,has_special_classes text,source_observed_date text,source_establishment_type_category_code text,source_admissions_policy_code text,source_boarding_provision_code text,source_nursery_provision_code text,source_sixth_form_provision_code text) ON COMMIT PRESERVE ROWS;
\copy establishment_seed_stage FROM '__FIXTURE_PATH__' WITH (FORMAT csv, HEADER true, DELIMITER '|', NULL 'NULL')
CREATE UNIQUE INDEX ON establishment_seed_stage(urn); ANALYZE establishment_seed_stage;
CREATE TEMP TABLE source_establishment_fixture (
    urn integer,
    ukprn numeric,
    local_authority_code text,
    government_office_region_code text,
    district_administrative_code text,
    administrative_ward_code text,
    parliamentary_constituency_code text,
    lsoa_code text,
    msoa_code text,
    urban_rural_code text,
    establishment_number integer,
    name text,
    website text,
    telephone_number text,
    status_code text,
    open_date date,
    close_date date,
    reason_opened_code text,
    reason_opened_name text,
    reason_closed_code text,
    reason_closed_name text,
    last_changed_date date,
    source_establishment_type_code text,
    source_education_phase_code text,
    school_capacity integer,
    pupil_count integer,
    free_school_meal_measure integer,
    census_date date,
    resourced_provision_capacity integer,
    resourced_provision_pupil_count integer,
    sen_unit_capacity integer,
    sen_unit_pupil_count integer,
    lower_statutory_age integer,
    upper_statutory_age integer,
    gender_of_entry_type_id integer,
    admissions_policy_id integer,
    boarding_provision_id integer,
    nursery_provision_id integer,
    sixth_form_provision_id integer,
    specialist_provision_type_id integer,
    main_site_name text,
    address_line_1 text,
    address_line_2 text,
    address_line_3 text,
    address_town text,
    address_county text,
    address_postcode text,
    address_uprn text,
    source_further_education_type_code text,
    further_education_type_id integer,
    source_section_41_approval_status_code text,
    section_41_approval_status_id integer,
    source_religious_character_code text,
    religious_character_id integer,
    source_religious_ethos_code text,
    religious_ethos_id integer,
    source_diocese_code text,
    source_diocese_id integer,
    source_education_phase text,
    ofsted_link text,
    source_specialist_provision_type_code text,
    source_special_classes_code text,
    has_special_classes boolean,
    source_observed_date date,
    source_establishment_type_category_code text,
    source_admissions_policy_code text,
    source_boarding_provision_code text,
    source_nursery_provision_code text,
    source_sixth_form_provision_code text
) ON COMMIT PRESERVE ROWS;


CREATE UNIQUE INDEX ON source_establishment_fixture(urn);
ALTER TABLE source_establishment_fixture
    ADD COLUMN establishment_type_id integer,
    ADD COLUMN diocese_id uuid;
ALTER TABLE source_establishment_fixture
    ADD COLUMN establishment_status_id integer,
    ADD COLUMN education_phase_id integer,
    ADD COLUMN reason_establishment_opened_id integer,
    ADD COLUMN reason_establishment_closed_id integer;
CREATE TEMP TABLE imported_reference_mapping ON COMMIT PRESERVE ROWS AS
SELECT j->>'reference_list' AS reference_list,j->>'code' AS code,
       (j->>'included')::boolean AS included
FROM (SELECT notes::jsonb AS payload FROM migration.migration_run
      WHERE run_type='reference-data' AND status='completed'
      ORDER BY completed_at DESC LIMIT 1) r,
     LATERAL jsonb_array_elements(r.payload->'source_rows') j;
CREATE UNIQUE INDEX ON imported_reference_mapping (reference_list, code);
ANALYZE imported_reference_mapping;
CREATE TEMP TABLE source_main_site_fixture AS
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
