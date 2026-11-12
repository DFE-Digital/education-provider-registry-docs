-- Align reference keys with the agreed BAU-code rule and give unbounded rows
-- internal UUID identities. Run once against the existing local PostgreSQL target.
BEGIN;

-- Preserve every existing relationship before replacing lookup identities.
ALTER TABLE establishment.establishment
    ADD COLUMN _new_establishment_type_id integer,
    ADD COLUMN _new_education_phase_id integer,
    ADD COLUMN _new_diocese_id uuid;
ALTER TABLE establishment.establishment_type ADD COLUMN _new_category_id integer;
ALTER TABLE establishment.establishment_lifecycle
    ADD COLUMN _new_status_id integer,
    ADD COLUMN _new_open_reason_id integer,
    ADD COLUMN _new_close_reason_id integer;
ALTER TABLE establishment.establishment_geography ADD COLUMN _new_urban_rural_id integer;
ALTER TABLE establishment.education_admissions_and_provision
    ADD COLUMN _new_gender_id integer,
    ADD COLUMN _new_admissions_id integer,
    ADD COLUMN _new_boarding_id integer;

UPDATE establishment.establishment_type_category
SET establishment_type_category_id = establishment_type_category_id;
ALTER TABLE establishment.establishment_type_category ADD COLUMN _new_id integer;
UPDATE establishment.establishment_type_category SET _new_id = code;
ALTER TABLE establishment.establishment_type ADD COLUMN _new_id integer;
UPDATE establishment.establishment_type SET _new_id = code::integer;
UPDATE establishment.establishment_type t SET _new_category_id = c._new_id
FROM establishment.establishment_type_category c
WHERE t.establishment_type_category_id = c.establishment_type_category_id;
UPDATE establishment.establishment e SET _new_establishment_type_id = t._new_id
FROM establishment.establishment_type t WHERE e.establishment_type_id = t.establishment_type_id;

ALTER TABLE establishment.education_phase ADD COLUMN _new_id integer;
UPDATE establishment.education_phase SET _new_id = code;
UPDATE establishment.establishment e SET _new_education_phase_id = p._new_id
FROM establishment.education_phase p WHERE e.education_phase_id = p.education_phase_id;

ALTER TABLE establishment.establishment_status ADD COLUMN _new_id integer;
UPDATE establishment.establishment_status SET _new_id = code;
UPDATE establishment.establishment_lifecycle l SET _new_status_id = s._new_id
FROM establishment.establishment_status s WHERE l.establishment_status_id = s.establishment_status_id;

ALTER TABLE establishment.reason_establishment_opened ADD COLUMN _new_id integer;
UPDATE establishment.reason_establishment_opened SET _new_id = code::integer;
UPDATE establishment.establishment_lifecycle l SET _new_open_reason_id = r._new_id
FROM establishment.reason_establishment_opened r WHERE l.reason_establishment_opened_id = r.reason_establishment_opened_id;
ALTER TABLE establishment.reason_establishment_closed ADD COLUMN _new_id integer;
UPDATE establishment.reason_establishment_closed SET _new_id = code::integer;
UPDATE establishment.establishment_lifecycle l SET _new_close_reason_id = r._new_id
FROM establishment.reason_establishment_closed r WHERE l.reason_establishment_closed_id = r.reason_establishment_closed_id;

ALTER TABLE establishment.diocese ADD COLUMN _new_id uuid DEFAULT gen_random_uuid();
UPDATE establishment.establishment e SET _new_diocese_id = d._new_id
FROM establishment.diocese d WHERE e.diocese_id = d.diocese_id;

ALTER TABLE establishment.urban_rural ADD COLUMN _new_id integer;
UPDATE establishment.urban_rural SET _new_id = x.new_id
FROM (SELECT id, row_number() OVER (ORDER BY code)::integer AS new_id FROM establishment.urban_rural) x
WHERE urban_rural.id = x.id;
UPDATE establishment.establishment_geography g SET _new_urban_rural_id = u._new_id
FROM establishment.urban_rural u WHERE g.urban_rural_id = u.id;

-- The old model's reference IDs were not BAU values. Resolve each retained fact
-- by its current meaning before re-keying the lookup rows.
UPDATE establishment.education_admissions_and_provision e SET _new_gender_id =
    CASE g.name WHEN 'Boys' THEN 1 WHEN 'Girls' THEN 2 WHEN 'Mixed' THEN 3 END
FROM establishment.gender_of_entry_type g WHERE e.gender_of_entry_type_id = g.gender_of_entry_type_id;
UPDATE establishment.education_admissions_and_provision e SET _new_admissions_id =
    CASE a.name WHEN 'Selective' THEN 2 WHEN 'Non-selective' THEN 4 END
FROM establishment.admissions_policy a WHERE e.admissions_policy_id = a.admissions_policy_id;
UPDATE establishment.education_admissions_and_provision e SET _new_boarding_id =
    CASE b.name WHEN 'No boarders' THEN 1 WHEN 'Children''s home (Boarding school)' THEN 2
                WHEN 'Boarding school' THEN 3 WHEN 'College / FE residential accommodation' THEN 4 END
FROM establishment.boarding_provision b WHERE e.boarding_provision_id = b.boarding_provision_id;

ALTER TABLE establishment.establishment DROP CONSTRAINT establishment_establishment_type_id_fkey,
    DROP CONSTRAINT establishment_education_phase_id_fkey, DROP CONSTRAINT establishment_diocese_id_fkey;
ALTER TABLE establishment.establishment_type DROP CONSTRAINT establishment_type_establishment_type_category_id_fkey,
    DROP CONSTRAINT establishment_type_academy_mapping;
ALTER TABLE establishment.establishment_lifecycle DROP CONSTRAINT establishment_lifecycle_establishment_status_id_fkey,
    DROP CONSTRAINT establishment_lifecycle_reason_establishment_opened_id_fkey,
    DROP CONSTRAINT establishment_lifecycle_reason_establishment_closed_id_fkey;
ALTER TABLE establishment.establishment_geography DROP CONSTRAINT establishment_geography_urban_rural_id_fkey;
ALTER TABLE establishment.education_admissions_and_provision
    DROP CONSTRAINT education_admissions_and_provision_gender_of_entry_type_id_fkey,
    DROP CONSTRAINT education_admissions_and_provision_admissions_policy_id_fkey,
    DROP CONSTRAINT education_admissions_and_provision_boarding_provision_id_fkey;

ALTER TABLE establishment.establishment_type_category DROP CONSTRAINT establishment_type_category_pkey;
ALTER TABLE establishment.establishment_type DROP CONSTRAINT establishment_type_pkey;
ALTER TABLE establishment.education_phase DROP CONSTRAINT education_phase_pkey;
ALTER TABLE establishment.establishment_status DROP CONSTRAINT establishment_status_pkey;
ALTER TABLE establishment.reason_establishment_opened DROP CONSTRAINT reason_establishment_opened_pkey;
ALTER TABLE establishment.reason_establishment_closed DROP CONSTRAINT reason_establishment_closed_pkey;
ALTER TABLE establishment.diocese DROP CONSTRAINT diocese_pkey;
ALTER TABLE establishment.urban_rural DROP CONSTRAINT urban_rural_pkey;

ALTER TABLE establishment.establishment_type_category DROP COLUMN establishment_type_category_id;
ALTER TABLE establishment.establishment_type_category RENAME COLUMN _new_id TO establishment_type_category_id;
ALTER TABLE establishment.establishment_type_category ADD PRIMARY KEY (establishment_type_category_id);
ALTER TABLE establishment.establishment_type DROP COLUMN establishment_type_id;
ALTER TABLE establishment.establishment_type DROP COLUMN establishment_type_category_id;
ALTER TABLE establishment.establishment_type RENAME COLUMN _new_id TO establishment_type_id;
ALTER TABLE establishment.establishment_type RENAME COLUMN _new_category_id TO establishment_type_category_id;
ALTER TABLE establishment.establishment_type ADD PRIMARY KEY (establishment_type_id);
ALTER TABLE establishment.education_phase DROP COLUMN education_phase_id, DROP COLUMN code;
ALTER TABLE establishment.education_phase RENAME COLUMN _new_id TO education_phase_id;
ALTER TABLE establishment.education_phase ADD PRIMARY KEY (education_phase_id);
ALTER TABLE establishment.establishment_status DROP COLUMN establishment_status_id, DROP COLUMN code;
ALTER TABLE establishment.establishment_status RENAME COLUMN _new_id TO establishment_status_id;
ALTER TABLE establishment.establishment_status ADD PRIMARY KEY (establishment_status_id);
ALTER TABLE establishment.reason_establishment_opened DROP COLUMN reason_establishment_opened_id;
ALTER TABLE establishment.reason_establishment_opened RENAME COLUMN _new_id TO reason_establishment_opened_id;
ALTER TABLE establishment.reason_establishment_opened ADD PRIMARY KEY (reason_establishment_opened_id);
ALTER TABLE establishment.reason_establishment_closed DROP COLUMN reason_establishment_closed_id;
ALTER TABLE establishment.reason_establishment_closed RENAME COLUMN _new_id TO reason_establishment_closed_id;
ALTER TABLE establishment.reason_establishment_closed ADD PRIMARY KEY (reason_establishment_closed_id);
ALTER TABLE establishment.diocese DROP COLUMN diocese_id;
ALTER TABLE establishment.diocese RENAME COLUMN _new_id TO diocese_id;
ALTER TABLE establishment.diocese ADD PRIMARY KEY (diocese_id);
ALTER TABLE establishment.urban_rural DROP COLUMN id;
ALTER TABLE establishment.urban_rural RENAME COLUMN _new_id TO id;
ALTER TABLE establishment.urban_rural ADD PRIMARY KEY (id);

ALTER TABLE establishment.establishment DROP COLUMN establishment_type_id, DROP COLUMN education_phase_id, DROP COLUMN diocese_id;
ALTER TABLE establishment.establishment RENAME COLUMN _new_establishment_type_id TO establishment_type_id;
ALTER TABLE establishment.establishment RENAME COLUMN _new_education_phase_id TO education_phase_id;
ALTER TABLE establishment.establishment RENAME COLUMN _new_diocese_id TO diocese_id;
ALTER TABLE establishment.establishment_type ADD CONSTRAINT establishment_type_establishment_type_category_id_fkey FOREIGN KEY (establishment_type_category_id) REFERENCES establishment.establishment_type_category(establishment_type_category_id);
ALTER TABLE establishment.establishment ADD CONSTRAINT establishment_establishment_type_id_fkey FOREIGN KEY (establishment_type_id) REFERENCES establishment.establishment_type(establishment_type_id),
    ADD CONSTRAINT establishment_education_phase_id_fkey FOREIGN KEY (education_phase_id) REFERENCES establishment.education_phase(education_phase_id),
    ADD CONSTRAINT establishment_diocese_id_fkey FOREIGN KEY (diocese_id) REFERENCES establishment.diocese(diocese_id);

ALTER TABLE establishment.establishment_lifecycle DROP COLUMN establishment_status_id, DROP COLUMN reason_establishment_opened_id, DROP COLUMN reason_establishment_closed_id;
ALTER TABLE establishment.establishment_lifecycle RENAME COLUMN _new_status_id TO establishment_status_id;
ALTER TABLE establishment.establishment_lifecycle RENAME COLUMN _new_open_reason_id TO reason_establishment_opened_id;
ALTER TABLE establishment.establishment_lifecycle RENAME COLUMN _new_close_reason_id TO reason_establishment_closed_id;
ALTER TABLE establishment.establishment_lifecycle ADD CONSTRAINT establishment_lifecycle_establishment_status_id_fkey FOREIGN KEY (establishment_status_id) REFERENCES establishment.establishment_status(establishment_status_id),
    ADD CONSTRAINT establishment_lifecycle_reason_establishment_opened_id_fkey FOREIGN KEY (reason_establishment_opened_id) REFERENCES establishment.reason_establishment_opened(reason_establishment_opened_id),
    ADD CONSTRAINT establishment_lifecycle_reason_establishment_closed_id_fkey FOREIGN KEY (reason_establishment_closed_id) REFERENCES establishment.reason_establishment_closed(reason_establishment_closed_id);

ALTER TABLE establishment.establishment_geography DROP COLUMN urban_rural_id;
ALTER TABLE establishment.establishment_geography RENAME COLUMN _new_urban_rural_id TO urban_rural_id;
ALTER TABLE establishment.establishment_geography ADD CONSTRAINT establishment_geography_urban_rural_id_fkey FOREIGN KEY (urban_rural_id) REFERENCES establishment.urban_rural(id);

ALTER TABLE establishment.education_admissions_and_provision DROP COLUMN gender_of_entry_type_id, DROP COLUMN admissions_policy_id, DROP COLUMN boarding_provision_id;
ALTER TABLE establishment.education_admissions_and_provision RENAME COLUMN _new_gender_id TO gender_of_entry_type_id;
ALTER TABLE establishment.education_admissions_and_provision RENAME COLUMN _new_admissions_id TO admissions_policy_id;
ALTER TABLE establishment.education_admissions_and_provision RENAME COLUMN _new_boarding_id TO boarding_provision_id;
DELETE FROM establishment.gender_of_entry_type;
INSERT INTO establishment.gender_of_entry_type VALUES (1,'Boys'),(2,'Girls'),(3,'Mixed');
DELETE FROM establishment.admissions_policy;
INSERT INTO establishment.admissions_policy VALUES (2,'Selective'),(4,'Non-selective');
DELETE FROM establishment.boarding_provision;
INSERT INTO establishment.boarding_provision VALUES (1,'No boarders'),(2,'Children''s home (Boarding school)'),(3,'Boarding school'),(4,'College / FE residential accommodation');
ALTER TABLE establishment.education_admissions_and_provision
    ADD CONSTRAINT education_admissions_and_provision_gender_of_entry_type_id_fkey FOREIGN KEY (gender_of_entry_type_id) REFERENCES establishment.gender_of_entry_type(gender_of_entry_type_id),
    ADD CONSTRAINT education_admissions_and_provision_admissions_policy_id_fkey FOREIGN KEY (admissions_policy_id) REFERENCES establishment.admissions_policy(admissions_policy_id),
    ADD CONSTRAINT education_admissions_and_provision_boarding_provision_id_fkey FOREIGN KEY (boarding_provision_id) REFERENCES establishment.boarding_provision(boarding_provision_id);

ALTER TABLE establishment.establishment_to_site ADD COLUMN IF NOT EXISTS establishment_to_site_id uuid DEFAULT gen_random_uuid();
ALTER TABLE establishment.establishment_to_site DROP CONSTRAINT establishment_to_site_pkey, ADD PRIMARY KEY(establishment_to_site_id), ADD UNIQUE(establishment_id,site_id);

ALTER TABLE migration.council_reorganisation_lineage DROP CONSTRAINT council_reorganisation_lineage_event_id_fkey;
ALTER TABLE migration.council_replay_observation DROP CONSTRAINT council_replay_observation_event_id_fkey;
ALTER TABLE migration.council_reorganisation ADD COLUMN IF NOT EXISTS council_reorganisation_id uuid DEFAULT gen_random_uuid();
ALTER TABLE migration.council_reorganisation DROP CONSTRAINT council_reorganisation_pkey, ADD PRIMARY KEY(council_reorganisation_id), ADD UNIQUE(event_id);
ALTER TABLE migration.council_reorganisation_lineage ADD COLUMN IF NOT EXISTS council_reorganisation_lineage_id uuid DEFAULT gen_random_uuid();
ALTER TABLE migration.council_reorganisation_lineage DROP CONSTRAINT council_reorganisation_lineage_pkey, ADD PRIMARY KEY(council_reorganisation_lineage_id), ADD UNIQUE(event_id,entity_kind,entity_id,action);
ALTER TABLE migration.council_replay_observation ADD COLUMN IF NOT EXISTS council_replay_observation_id uuid DEFAULT gen_random_uuid();
ALTER TABLE migration.council_replay_observation DROP CONSTRAINT council_replay_observation_pkey, ADD PRIMARY KEY(council_replay_observation_id), ADD UNIQUE(event_id,establishment_id,payload_hash);
ALTER TABLE migration.council_reorganisation_lineage ADD CONSTRAINT council_reorganisation_lineage_event_id_fkey FOREIGN KEY(event_id) REFERENCES migration.council_reorganisation(event_id);
ALTER TABLE migration.council_replay_observation ADD CONSTRAINT council_replay_observation_event_id_fkey FOREIGN KEY(event_id) REFERENCES migration.council_reorganisation(event_id);
ALTER TABLE migration.proprietor_fact_evidence DROP CONSTRAINT proprietor_fact_evidence_decision_id_fkey;
ALTER TABLE migration.proprietor_review ADD COLUMN IF NOT EXISTS proprietor_review_id uuid DEFAULT gen_random_uuid();
ALTER TABLE migration.proprietor_review DROP CONSTRAINT proprietor_review_pkey, ADD PRIMARY KEY(proprietor_review_id), ADD UNIQUE(decision_id);
ALTER TABLE migration.proprietor_fact_evidence ADD COLUMN IF NOT EXISTS proprietor_fact_evidence_id uuid DEFAULT gen_random_uuid();
ALTER TABLE migration.proprietor_fact_evidence DROP CONSTRAINT proprietor_fact_evidence_pkey, ADD PRIMARY KEY(proprietor_fact_evidence_id), ADD UNIQUE(decision_id,fact_key);
ALTER TABLE migration.proprietor_fact_evidence ADD CONSTRAINT proprietor_fact_evidence_decision_id_fkey FOREIGN KEY(decision_id) REFERENCES migration.proprietor_review(decision_id);

COMMIT;
