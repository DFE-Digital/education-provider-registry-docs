-- Upgrade the five reviewed code lists in an existing local target.
-- UUIDs are internal identities; all business codes match BAU unchanged.
-- Run with psql -v ON_ERROR_STOP=1. Changes commit atomically.
BEGIN;
SET LOCAL lock_timeout = '10s';
CREATE TEMP TABLE code_list_before ON COMMIT DROP AS
SELECT e.urn,e.establishment_id,e.establishment_type_id,t.establishment_type_category_id,
       st.code AS status_code,
       CASE ep.name WHEN '16 to 19' THEN '16 plus' ELSE ep.name END AS phase,
       reo.name AS opened_reason,rec.name AS closed_reason,l.open_date,l.close_date,l.last_changed_date
FROM establishment.establishment e
JOIN establishment.establishment_type t USING(establishment_type_id)
LEFT JOIN establishment.establishment_lifecycle l USING(establishment_id)
LEFT JOIN establishment.establishment_status st USING(establishment_status_id)
LEFT JOIN establishment.education_phase ep USING(education_phase_id)
LEFT JOIN establishment.reason_establishment_opened reo USING(reason_establishment_opened_id)
LEFT JOIN establishment.reason_establishment_closed rec USING(reason_establishment_closed_id);


DO $$
BEGIN
    IF EXISTS(SELECT 1 FROM information_schema.columns WHERE table_schema='establishment' AND table_name='establishment_status' AND column_name='establishment_status_id' AND data_type='integer') THEN
        IF EXISTS(SELECT 1 FROM establishment.establishment_status WHERE NOT ((establishment_status_id=1 AND name='Open') OR (establishment_status_id=2 AND name='Closed') OR (establishment_status_id=3 AND name='Open, but proposed to close') OR (establishment_status_id=4 AND name='Proposed to open'))) THEN
            RAISE EXCEPTION 'Unexpected legacy establishment_status mapping; reconcile before upgrade';
        END IF;
        ALTER TABLE establishment.establishment_lifecycle DROP CONSTRAINT establishment_lifecycle_establishment_status_id_fkey;
        ALTER TABLE establishment.establishment_lifecycle ALTER COLUMN establishment_status_id TYPE uuid USING (CASE establishment_status_id WHEN 1 THEN 'e18c2218-d3b6-5da0-8154-058ce8d71477'::uuid WHEN 2 THEN '43ca04bf-013b-5ac7-8cad-5b0de19c396c'::uuid WHEN 3 THEN '6e9e3c88-3606-504d-ab0c-02ceb54d6261'::uuid WHEN 4 THEN '12e1a571-87af-5d0f-9008-cad0a06f1c8c'::uuid END);
        ALTER TABLE establishment.establishment_status ALTER COLUMN establishment_status_id TYPE uuid USING (CASE establishment_status_id WHEN 1 THEN 'e18c2218-d3b6-5da0-8154-058ce8d71477'::uuid WHEN 2 THEN '43ca04bf-013b-5ac7-8cad-5b0de19c396c'::uuid WHEN 3 THEN '6e9e3c88-3606-504d-ab0c-02ceb54d6261'::uuid WHEN 4 THEN '12e1a571-87af-5d0f-9008-cad0a06f1c8c'::uuid END);
        ALTER TABLE establishment.establishment_status ALTER COLUMN establishment_status_id SET DEFAULT gen_random_uuid();
        ALTER TABLE establishment.establishment_lifecycle ADD FOREIGN KEY(establishment_status_id) REFERENCES establishment.establishment_status(establishment_status_id);
    END IF;
END $$;
ALTER TABLE establishment.establishment_status ADD COLUMN IF NOT EXISTS code integer;
UPDATE establishment.establishment_status SET code=1, name='Open' WHERE establishment_status_id='e18c2218-d3b6-5da0-8154-058ce8d71477'::uuid;
UPDATE establishment.establishment_status SET code=2, name='Closed' WHERE establishment_status_id='43ca04bf-013b-5ac7-8cad-5b0de19c396c'::uuid;
UPDATE establishment.establishment_status SET code=3, name='Open, but proposed to close' WHERE establishment_status_id='6e9e3c88-3606-504d-ab0c-02ceb54d6261'::uuid;
UPDATE establishment.establishment_status SET code=4, name='Proposed to open' WHERE establishment_status_id='12e1a571-87af-5d0f-9008-cad0a06f1c8c'::uuid;
ALTER TABLE establishment.establishment_status ALTER COLUMN code SET NOT NULL;
DO $$ BEGIN
    IF NOT EXISTS(SELECT 1 FROM pg_constraint WHERE conrelid='establishment.establishment_status'::regclass AND conname='establishment_status_code_key') THEN
        ALTER TABLE establishment.establishment_status ADD CONSTRAINT establishment_status_code_key UNIQUE(code);
    END IF;
END $$;

DO $$
BEGIN
    IF EXISTS(SELECT 1 FROM information_schema.columns WHERE table_schema='establishment' AND table_name='education_phase' AND column_name='education_phase_id' AND data_type='integer') THEN
        IF EXISTS(SELECT 1 FROM establishment.education_phase WHERE NOT ((education_phase_id=1 AND name='Nursery') OR (education_phase_id=3 AND name='Middle deemed primary') OR (education_phase_id=4 AND name='Middle deemed secondary') OR (education_phase_id=6 AND name='All-through') OR (education_phase_id=7 AND name='16 to 19') OR (education_phase_id=2 AND name='Primary') OR (education_phase_id=5 AND name='Secondary'))) THEN
            RAISE EXCEPTION 'Unexpected legacy education_phase mapping; reconcile before upgrade';
        END IF;
        ALTER TABLE establishment.establishment DROP CONSTRAINT establishment_education_phase_id_fkey;
        ALTER TABLE establishment.establishment ALTER COLUMN education_phase_id TYPE uuid USING (CASE education_phase_id WHEN 1 THEN '1bfe602b-1108-576a-80fa-b894e3a70f75'::uuid WHEN 3 THEN '90f418ac-d2c3-54cc-9840-fdba45b29f0d'::uuid WHEN 4 THEN 'aacc62a7-5722-5969-8ae9-8ebd1a9987bd'::uuid WHEN 6 THEN '32ffef42-5cf3-5017-b16e-36ce6e57a18d'::uuid WHEN 7 THEN 'eea7e021-7467-54fb-a51b-6aeb73ff2253'::uuid WHEN 2 THEN 'ba9b1c76-422f-515b-8f27-626e8002e3d3'::uuid WHEN 5 THEN '5e26d3f6-9f94-5cb4-a93a-292ef31d822b'::uuid END);
        ALTER TABLE establishment.education_phase ALTER COLUMN education_phase_id TYPE uuid USING (CASE education_phase_id WHEN 1 THEN '1bfe602b-1108-576a-80fa-b894e3a70f75'::uuid WHEN 3 THEN '90f418ac-d2c3-54cc-9840-fdba45b29f0d'::uuid WHEN 4 THEN 'aacc62a7-5722-5969-8ae9-8ebd1a9987bd'::uuid WHEN 6 THEN '32ffef42-5cf3-5017-b16e-36ce6e57a18d'::uuid WHEN 7 THEN 'eea7e021-7467-54fb-a51b-6aeb73ff2253'::uuid WHEN 2 THEN 'ba9b1c76-422f-515b-8f27-626e8002e3d3'::uuid WHEN 5 THEN '5e26d3f6-9f94-5cb4-a93a-292ef31d822b'::uuid END);
        ALTER TABLE establishment.education_phase ALTER COLUMN education_phase_id SET DEFAULT gen_random_uuid();
        ALTER TABLE establishment.establishment ADD FOREIGN KEY(education_phase_id) REFERENCES establishment.education_phase(education_phase_id);
    END IF;
END $$;
ALTER TABLE establishment.education_phase ADD COLUMN IF NOT EXISTS code integer;
UPDATE establishment.education_phase SET code=1, name='Nursery' WHERE education_phase_id='1bfe602b-1108-576a-80fa-b894e3a70f75'::uuid;
UPDATE establishment.education_phase SET code=3, name='Middle deemed primary' WHERE education_phase_id='90f418ac-d2c3-54cc-9840-fdba45b29f0d'::uuid;
UPDATE establishment.education_phase SET code=5, name='Middle deemed secondary' WHERE education_phase_id='aacc62a7-5722-5969-8ae9-8ebd1a9987bd'::uuid;
UPDATE establishment.education_phase SET code=7, name='All-through' WHERE education_phase_id='32ffef42-5cf3-5017-b16e-36ce6e57a18d'::uuid;
UPDATE establishment.education_phase SET code=6, name='16 plus' WHERE education_phase_id='eea7e021-7467-54fb-a51b-6aeb73ff2253'::uuid;
UPDATE establishment.education_phase SET code=2, name='Primary' WHERE education_phase_id='ba9b1c76-422f-515b-8f27-626e8002e3d3'::uuid;
UPDATE establishment.education_phase SET code=4, name='Secondary' WHERE education_phase_id='5e26d3f6-9f94-5cb4-a93a-292ef31d822b'::uuid;
ALTER TABLE establishment.education_phase ALTER COLUMN code SET NOT NULL;
DO $$ BEGIN
    IF NOT EXISTS(SELECT 1 FROM pg_constraint WHERE conrelid='establishment.education_phase'::regclass AND conname='education_phase_code_key') THEN
        ALTER TABLE establishment.education_phase ADD CONSTRAINT education_phase_code_key UNIQUE(code);
    END IF;
END $$;
DO $$ BEGIN IF NOT EXISTS(SELECT 1 FROM pg_constraint WHERE conrelid='establishment.education_phase'::regclass AND conname='education_phase_name_key') THEN ALTER TABLE establishment.education_phase ADD CONSTRAINT education_phase_name_key UNIQUE(name); END IF; END $$;

DO $$
BEGIN
    IF EXISTS(SELECT 1 FROM information_schema.columns WHERE table_schema='establishment' AND table_name='reason_establishment_opened' AND column_name='reason_establishment_opened_id' AND data_type='integer') THEN
        IF EXISTS(SELECT 1 FROM establishment.reason_establishment_opened WHERE NOT ((reason_establishment_opened_id=1 AND name='Academy Converter') OR (reason_establishment_opened_id=2 AND name='New Provision') OR (reason_establishment_opened_id=3 AND name='Result of Amalgamation') OR (reason_establishment_opened_id=4 AND name='Fresh Start') OR (reason_establishment_opened_id=5 AND name='Academy Free School') OR (reason_establishment_opened_id=6 AND name='Result of Closure') OR (reason_establishment_opened_id=7 AND name='Change Religious Character') OR (reason_establishment_opened_id=8 AND name='Change in status') OR (reason_establishment_opened_id=9 AND name='Former Independent') OR (reason_establishment_opened_id=10 AND name='Split school') OR (reason_establishment_opened_id=11 AND name='New Nursery School') OR (reason_establishment_opened_id=12 AND name='Meets accreditation standards') OR (reason_establishment_opened_id=13 AND name='Free Special School'))) THEN
            RAISE EXCEPTION 'Unexpected legacy reason_establishment_opened mapping; reconcile before upgrade';
        END IF;
        ALTER TABLE establishment.establishment_lifecycle DROP CONSTRAINT establishment_lifecycle_reason_establishment_opened_id_fkey;
        ALTER TABLE establishment.establishment_lifecycle ALTER COLUMN reason_establishment_opened_id TYPE uuid USING (CASE reason_establishment_opened_id WHEN 1 THEN '64a8397b-14c5-59f9-8b2c-8b5d1d961829'::uuid WHEN 2 THEN 'b781f186-c04a-57f4-8d57-5ded6a10a07a'::uuid WHEN 3 THEN '7796db72-e9c1-5c02-98b2-0ea8da003978'::uuid WHEN 4 THEN '4ff89cb8-ec56-5be8-987f-d1d59541c88d'::uuid WHEN 5 THEN 'bfa9158f-1bd6-51bf-bb11-db2684ec415a'::uuid WHEN 6 THEN '78f30168-073c-5a43-90dd-56477611f31e'::uuid WHEN 7 THEN '281cb230-62ba-5631-8ee9-6e0b1d76061a'::uuid WHEN 8 THEN '5964f112-199a-5712-9d32-a9931d5cac6e'::uuid WHEN 9 THEN '55f3fa54-4ffc-5a49-8898-db47d5ae3721'::uuid WHEN 10 THEN '85e532cc-d5b0-5861-816d-90835592d82a'::uuid WHEN 11 THEN 'd6586fa2-9394-50b8-a73e-90087db8cc44'::uuid WHEN 12 THEN '84ee4e5e-b934-55d6-8e4c-35e04afc5290'::uuid WHEN 13 THEN '9a695343-a73a-5fe9-a45c-3c45584f16a0'::uuid END);
        ALTER TABLE establishment.reason_establishment_opened ALTER COLUMN reason_establishment_opened_id TYPE uuid USING (CASE reason_establishment_opened_id WHEN 1 THEN '64a8397b-14c5-59f9-8b2c-8b5d1d961829'::uuid WHEN 2 THEN 'b781f186-c04a-57f4-8d57-5ded6a10a07a'::uuid WHEN 3 THEN '7796db72-e9c1-5c02-98b2-0ea8da003978'::uuid WHEN 4 THEN '4ff89cb8-ec56-5be8-987f-d1d59541c88d'::uuid WHEN 5 THEN 'bfa9158f-1bd6-51bf-bb11-db2684ec415a'::uuid WHEN 6 THEN '78f30168-073c-5a43-90dd-56477611f31e'::uuid WHEN 7 THEN '281cb230-62ba-5631-8ee9-6e0b1d76061a'::uuid WHEN 8 THEN '5964f112-199a-5712-9d32-a9931d5cac6e'::uuid WHEN 9 THEN '55f3fa54-4ffc-5a49-8898-db47d5ae3721'::uuid WHEN 10 THEN '85e532cc-d5b0-5861-816d-90835592d82a'::uuid WHEN 11 THEN 'd6586fa2-9394-50b8-a73e-90087db8cc44'::uuid WHEN 12 THEN '84ee4e5e-b934-55d6-8e4c-35e04afc5290'::uuid WHEN 13 THEN '9a695343-a73a-5fe9-a45c-3c45584f16a0'::uuid END);
        ALTER TABLE establishment.reason_establishment_opened ALTER COLUMN reason_establishment_opened_id SET DEFAULT gen_random_uuid();
        ALTER TABLE establishment.establishment_lifecycle ADD FOREIGN KEY(reason_establishment_opened_id) REFERENCES establishment.reason_establishment_opened(reason_establishment_opened_id);
    END IF;
END $$;
ALTER TABLE establishment.reason_establishment_opened ADD COLUMN IF NOT EXISTS code text;
UPDATE establishment.reason_establishment_opened SET code='10', name='Academy Converter' WHERE reason_establishment_opened_id='64a8397b-14c5-59f9-8b2c-8b5d1d961829'::uuid;
UPDATE establishment.reason_establishment_opened SET code='06', name='New Provision' WHERE reason_establishment_opened_id='b781f186-c04a-57f4-8d57-5ded6a10a07a'::uuid;
UPDATE establishment.reason_establishment_opened SET code='01', name='Result of Amalgamation' WHERE reason_establishment_opened_id='7796db72-e9c1-5c02-98b2-0ea8da003978'::uuid;
UPDATE establishment.reason_establishment_opened SET code='04', name='Fresh Start' WHERE reason_establishment_opened_id='4ff89cb8-ec56-5be8-987f-d1d59541c88d'::uuid;
UPDATE establishment.reason_establishment_opened SET code='11', name='Academy Free School' WHERE reason_establishment_opened_id='bfa9158f-1bd6-51bf-bb11-db2684ec415a'::uuid;
UPDATE establishment.reason_establishment_opened SET code='02', name='Result of Closure' WHERE reason_establishment_opened_id='78f30168-073c-5a43-90dd-56477611f31e'::uuid;
UPDATE establishment.reason_establishment_opened SET code='03', name='Change Religious Character' WHERE reason_establishment_opened_id='281cb230-62ba-5631-8ee9-6e0b1d76061a'::uuid;
UPDATE establishment.reason_establishment_opened SET code='09', name='Change in status' WHERE reason_establishment_opened_id='5964f112-199a-5712-9d32-a9931d5cac6e'::uuid;
UPDATE establishment.reason_establishment_opened SET code='07', name='Former Independent' WHERE reason_establishment_opened_id='55f3fa54-4ffc-5a49-8898-db47d5ae3721'::uuid;
UPDATE establishment.reason_establishment_opened SET code='08', name='Split school' WHERE reason_establishment_opened_id='85e532cc-d5b0-5861-816d-90835592d82a'::uuid;
UPDATE establishment.reason_establishment_opened SET code='05', name='New Nursery School' WHERE reason_establishment_opened_id='d6586fa2-9394-50b8-a73e-90087db8cc44'::uuid;
UPDATE establishment.reason_establishment_opened SET code='14', name='Meets accreditation standards' WHERE reason_establishment_opened_id='84ee4e5e-b934-55d6-8e4c-35e04afc5290'::uuid;
UPDATE establishment.reason_establishment_opened SET code='12', name='Free Special School' WHERE reason_establishment_opened_id='9a695343-a73a-5fe9-a45c-3c45584f16a0'::uuid;
ALTER TABLE establishment.reason_establishment_opened ALTER COLUMN code SET NOT NULL;
DO $$ BEGIN
    IF NOT EXISTS(SELECT 1 FROM pg_constraint WHERE conrelid='establishment.reason_establishment_opened'::regclass AND conname='reason_establishment_opened_code_key') THEN
        ALTER TABLE establishment.reason_establishment_opened ADD CONSTRAINT reason_establishment_opened_code_key UNIQUE(code);
    END IF;
END $$;

DO $$
BEGIN
    IF EXISTS(SELECT 1 FROM information_schema.columns WHERE table_schema='establishment' AND table_name='reason_establishment_closed' AND column_name='reason_establishment_closed_id' AND data_type='integer') THEN
        IF EXISTS(SELECT 1 FROM establishment.reason_establishment_closed WHERE NOT ((reason_establishment_closed_id=1 AND name='Academy Converter') OR (reason_establishment_closed_id=2 AND name='Result of Amalgamation/Merger') OR (reason_establishment_closed_id=3 AND name='Closure') OR (reason_establishment_closed_id=4 AND name='For Academy') OR (reason_establishment_closed_id=5 AND name='Fresh Start') OR (reason_establishment_closed_id=6 AND name='Close Nursery School') OR (reason_establishment_closed_id=7 AND name='Change Religious Character') OR (reason_establishment_closed_id=8 AND name='Does not meet criteria for registration') OR (reason_establishment_closed_id=9 AND name='De-registered') OR (reason_establishment_closed_id=10 AND name='Academy Free School') OR (reason_establishment_closed_id=11 AND name='Change in status') OR (reason_establishment_closed_id=12 AND name='Transferred to new sponsor') OR (reason_establishment_closed_id=13 AND name='Created in Error - application rejected'))) THEN
            RAISE EXCEPTION 'Unexpected legacy reason_establishment_closed mapping; reconcile before upgrade';
        END IF;
        ALTER TABLE establishment.establishment_lifecycle DROP CONSTRAINT establishment_lifecycle_reason_establishment_closed_id_fkey;
        ALTER TABLE establishment.establishment_lifecycle ALTER COLUMN reason_establishment_closed_id TYPE uuid USING (CASE reason_establishment_closed_id WHEN 1 THEN '21cb9ddd-8de2-5939-81fc-50bb1ae23808'::uuid WHEN 2 THEN '0def3cbd-742c-5365-82b2-7c73ecadeca9'::uuid WHEN 3 THEN 'ab833d5c-be45-5d29-b2bb-498031e89fa9'::uuid WHEN 4 THEN 'd6688417-2736-5364-92e3-35ffe211f1de'::uuid WHEN 5 THEN '15336aef-36b9-5eb2-837d-4e9f07ebb837'::uuid WHEN 6 THEN '5c1dfddc-3670-5684-b126-3aa345ee2635'::uuid WHEN 7 THEN '4e6983a2-89a5-5636-b171-cef4aa44a503'::uuid WHEN 8 THEN '829c3dbf-2ddc-5b86-a7b8-16e2501bef38'::uuid WHEN 9 THEN 'a4df3b2c-b439-5a85-ae84-e260b513fe6e'::uuid WHEN 10 THEN '0efa2be1-d848-5f94-9456-af99b08c3de8'::uuid WHEN 11 THEN '36e94a27-e7d5-5d39-9875-fbccbc55a807'::uuid WHEN 12 THEN '6e02dbdc-c247-5ac9-9776-95b5e40ca875'::uuid WHEN 13 THEN 'fd802575-d656-5651-a955-8d9c4da99b92'::uuid END);
        ALTER TABLE establishment.reason_establishment_closed ALTER COLUMN reason_establishment_closed_id TYPE uuid USING (CASE reason_establishment_closed_id WHEN 1 THEN '21cb9ddd-8de2-5939-81fc-50bb1ae23808'::uuid WHEN 2 THEN '0def3cbd-742c-5365-82b2-7c73ecadeca9'::uuid WHEN 3 THEN 'ab833d5c-be45-5d29-b2bb-498031e89fa9'::uuid WHEN 4 THEN 'd6688417-2736-5364-92e3-35ffe211f1de'::uuid WHEN 5 THEN '15336aef-36b9-5eb2-837d-4e9f07ebb837'::uuid WHEN 6 THEN '5c1dfddc-3670-5684-b126-3aa345ee2635'::uuid WHEN 7 THEN '4e6983a2-89a5-5636-b171-cef4aa44a503'::uuid WHEN 8 THEN '829c3dbf-2ddc-5b86-a7b8-16e2501bef38'::uuid WHEN 9 THEN 'a4df3b2c-b439-5a85-ae84-e260b513fe6e'::uuid WHEN 10 THEN '0efa2be1-d848-5f94-9456-af99b08c3de8'::uuid WHEN 11 THEN '36e94a27-e7d5-5d39-9875-fbccbc55a807'::uuid WHEN 12 THEN '6e02dbdc-c247-5ac9-9776-95b5e40ca875'::uuid WHEN 13 THEN 'fd802575-d656-5651-a955-8d9c4da99b92'::uuid END);
        ALTER TABLE establishment.reason_establishment_closed ALTER COLUMN reason_establishment_closed_id SET DEFAULT gen_random_uuid();
        ALTER TABLE establishment.establishment_lifecycle ADD FOREIGN KEY(reason_establishment_closed_id) REFERENCES establishment.reason_establishment_closed(reason_establishment_closed_id);
    END IF;
END $$;
ALTER TABLE establishment.reason_establishment_closed ADD COLUMN IF NOT EXISTS code text;
UPDATE establishment.reason_establishment_closed SET code='10', name='Academy Converter' WHERE reason_establishment_closed_id='21cb9ddd-8de2-5939-81fc-50bb1ae23808'::uuid;
UPDATE establishment.reason_establishment_closed SET code='01', name='Result of Amalgamation/Merger' WHERE reason_establishment_closed_id='0def3cbd-742c-5365-82b2-7c73ecadeca9'::uuid;
UPDATE establishment.reason_establishment_closed SET code='02', name='Closure' WHERE reason_establishment_closed_id='ab833d5c-be45-5d29-b2bb-498031e89fa9'::uuid;
UPDATE establishment.reason_establishment_closed SET code='06', name='For Academy' WHERE reason_establishment_closed_id='d6688417-2736-5364-92e3-35ffe211f1de'::uuid;
UPDATE establishment.reason_establishment_closed SET code='04', name='Fresh Start' WHERE reason_establishment_closed_id='15336aef-36b9-5eb2-837d-4e9f07ebb837'::uuid;
UPDATE establishment.reason_establishment_closed SET code='05', name='Close Nursery School' WHERE reason_establishment_closed_id='5c1dfddc-3670-5684-b126-3aa345ee2635'::uuid;
UPDATE establishment.reason_establishment_closed SET code='03', name='Change Religious Character' WHERE reason_establishment_closed_id='4e6983a2-89a5-5636-b171-cef4aa44a503'::uuid;
UPDATE establishment.reason_establishment_closed SET code='08', name='Does not meet criteria for registration' WHERE reason_establishment_closed_id='829c3dbf-2ddc-5b86-a7b8-16e2501bef38'::uuid;
UPDATE establishment.reason_establishment_closed SET code='07', name='De-registered' WHERE reason_establishment_closed_id='a4df3b2c-b439-5a85-ae84-e260b513fe6e'::uuid;
UPDATE establishment.reason_establishment_closed SET code='11', name='Academy Free School' WHERE reason_establishment_closed_id='0efa2be1-d848-5f94-9456-af99b08c3de8'::uuid;
UPDATE establishment.reason_establishment_closed SET code='09', name='Change in status' WHERE reason_establishment_closed_id='36e94a27-e7d5-5d39-9875-fbccbc55a807'::uuid;
UPDATE establishment.reason_establishment_closed SET code='12', name='Transferred to new sponsor' WHERE reason_establishment_closed_id='6e02dbdc-c247-5ac9-9776-95b5e40ca875'::uuid;
UPDATE establishment.reason_establishment_closed SET code='14', name='Created in Error - application rejected' WHERE reason_establishment_closed_id='fd802575-d656-5651-a955-8d9c4da99b92'::uuid;
ALTER TABLE establishment.reason_establishment_closed ALTER COLUMN code SET NOT NULL;
DO $$ BEGIN
    IF NOT EXISTS(SELECT 1 FROM pg_constraint WHERE conrelid='establishment.reason_establishment_closed'::regclass AND conname='reason_establishment_closed_code_key') THEN
        ALTER TABLE establishment.reason_establishment_closed ADD CONSTRAINT reason_establishment_closed_code_key UNIQUE(code);
    END IF;
END $$;

ALTER TABLE establishment.establishment_type_category ADD COLUMN IF NOT EXISTS code integer;

UPDATE establishment.establishment_type_category SET code=1 WHERE establishment_type_category_id='b6ae60fa-20ba-44be-a9aa-d4b65ff2758f'::uuid AND name='Colleges';

UPDATE establishment.establishment_type_category SET code=10 WHERE establishment_type_category_id='f2b9ca2a-74a4-4cb5-b3d5-3bb2bf2a2a10'::uuid AND name='Academies';

UPDATE establishment.establishment_type_category SET code=11 WHERE establishment_type_category_id='252e2e23-edb1-40f1-9a54-573a35890014'::uuid AND name='Free Schools';

UPDATE establishment.establishment_type_category SET code=12 WHERE establishment_type_category_id='5eb9f935-c70f-4bf3-9e8e-a2e7cf45c7f0'::uuid AND name='Children''s Centres';

UPDATE establishment.establishment_type_category SET code=13 WHERE establishment_type_category_id='4cc699d1-8989-4d9a-8336-64d918025c16'::uuid AND name='Online provider';

UPDATE establishment.establishment_type_category SET code=2 WHERE establishment_type_category_id='590dcec2-3609-42a8-93d4-41f08c2547da'::uuid AND name='Universities';

UPDATE establishment.establishment_type_category SET code=3 WHERE establishment_type_category_id='9f720d42-98f0-46d3-9018-2da96efe2bff'::uuid AND name='Independent schools';

UPDATE establishment.establishment_type_category SET code=4 WHERE establishment_type_category_id='56327e79-0424-4ce4-bf16-296a43eccf5a'::uuid AND name='Local authority maintained schools';

UPDATE establishment.establishment_type_category SET code=5 WHERE establishment_type_category_id='13d814fd-b7b9-44f0-b18f-b735f0653a9f'::uuid AND name='Special schools';

UPDATE establishment.establishment_type_category SET code=6 WHERE establishment_type_category_id='2e95cd30-3e73-4445-b65a-d7c509927c17'::uuid AND name='Welsh schools';

UPDATE establishment.establishment_type_category SET code=9 WHERE establishment_type_category_id='d5a9d656-6f60-4b05-8bf0-9f6084277b47'::uuid AND name='Other types';

ALTER TABLE establishment.establishment_type_category ALTER COLUMN code SET NOT NULL;
DO $$ BEGIN IF NOT EXISTS(SELECT 1 FROM pg_constraint WHERE conrelid='establishment.establishment_type_category'::regclass AND conname='establishment_type_category_code_key') THEN ALTER TABLE establishment.establishment_type_category ADD CONSTRAINT establishment_type_category_code_key UNIQUE(code); END IF; END $$;


-- Refresh dependent functions from maintenance-derivation.sql

CREATE OR REPLACE FUNCTION migration.derive_maintenance(snapshot_id uuid)
RETURNS void LANGUAGE plpgsql AS $$
DECLARE
    o record; p record; school record; existing record;
    start_on date; end_on date; basis text; current_flag boolean;
    responsibility_id uuid; inputs jsonb; eligible boolean; observed_on date;
    matched integer; current_count integer; current_matched integer;
BEGIN
    PERFORM pg_advisory_xact_lock(hashtextextended('council-maintenance-transition',0));
    SELECT snapshot_date INTO observed_on FROM migration.source_snapshot WHERE source_snapshot_id=snapshot_id;
    FOR o IN SELECT obs.*,sr.source_urn
             FROM migration.maintenance_source_observation obs
             JOIN migration.source_record sr USING(source_record_id)
             WHERE sr.source_snapshot_id=snapshot_id ORDER BY obs.establishment_id
    LOOP
        -- A source assertion and its derived business rows succeed together.
        -- Contradictions are retained for review, without partial derivation.
        BEGIN
            IF migration.retain_reviewed_maintenance(o.source_record_id,observed_on) THEN CONTINUE; END IF;
            PERFORM 1 FROM establishment.establishment WHERE establishment_id=o.establishment_id FOR UPDATE;
            SELECT e.establishment_type_id,t.code AS type_code,status.code AS establishment_status_code,l.open_date,l.close_date,
                   a.local_authority_area_id,a.code,j.name AS jurisdiction,t.name AS type_name
            INTO STRICT school FROM establishment.establishment e
            JOIN establishment.establishment_lifecycle l USING(establishment_id)
    JOIN establishment.establishment_status status USING(establishment_status_id)
            JOIN establishment.establishment_geography g USING(establishment_id)
            JOIN establishment.local_authority_area a USING(local_authority_area_id)
            JOIN establishment.local_authority_jurisdiction j USING(local_authority_jurisdiction_id)
            JOIN establishment.establishment_type t USING(establishment_type_id)
            WHERE e.establishment_id=o.establishment_id;
            eligible:=school.type_code IN ('01','02','03','05','07','12','14','15');
            IF school.code IS DISTINCT FROM o.area_code
               OR school.establishment_status_code IS DISTINCT FROM o.source_status_code
               OR school.open_date IS DISTINCT FROM o.open_date
               OR school.close_date IS DISTINCT FROM o.close_date
               OR eligible IS DISTINCT FROM (o.source_type_name IN (
                   'Community school','Community special school','Foundation special school',
                   'Voluntary aided school','Voluntary controlled school','Foundation school',
                   'Pupil referral unit','Maintained nursery school'))
               OR (eligible AND school.type_name IS DISTINCT FROM o.source_type_name) THEN
                RAISE EXCEPTION 'Source inputs disagree with the loaded establishment; reconcile before deriving maintenance';
            END IF;
            IF school.jurisdiction='Welsh' THEN
                UPDATE migration.maintenance_source_observation SET processing_status='welsh_excluded',
                processing_note=CASE WHEN eligible THEN 'Review: Welsh-coded school has an English maintained type; no automatic maintenance'
                                     ELSE 'Welsh maintenance enrichment is out of scope' END
                WHERE source_record_id=o.source_record_id;
                CONTINUE;
            END IF;
            IF school.jurisdiction<>'English' OR NOT eligible OR o.source_status_code=4 THEN
                IF EXISTS (SELECT 1 FROM establishment.establishment_responsibility
                           WHERE establishment_id=o.establishment_id AND responsibility_type_id=5 AND is_current) THEN
                    RAISE EXCEPTION 'Current maintenance conflicts with the source type or status; reviewed transition required';
                END IF;
                UPDATE migration.maintenance_source_observation SET processing_status='ineligible',
                processing_note='No current English maintained-school assertion; supported history is retained'
                WHERE source_record_id=o.source_record_id;
                CONTINUE;
            END IF;
            IF observed_on IS NULL THEN RAISE EXCEPTION 'Source observation date is unknown'; END IF;
            IF o.source_status_code NOT IN (1,2,3)
               OR o.open_date>observed_on
               OR (o.source_status_code=2 AND (o.close_date IS NULL OR o.close_date>observed_on))
               OR (o.source_status_code IN (1,3) AND o.close_date<=observed_on)
               OR o.close_date<o.open_date THEN
                RAISE EXCEPTION 'Contradictory school operating dates or source status';
            END IF;
            matched:=0; current_matched:=0;
            FOR p IN SELECT cp.*,c.incorporation_date,c.dissolution_date
                     FROM establishment.local_authority_area_council_period cp
                     JOIN establishment.legal_entity c USING(legal_entity_id)
                     WHERE cp.local_authority_area_id=school.local_authority_area_id
                     ORDER BY cp.start_date NULLS FIRST,cp.local_authority_area_council_period_id
            LOOP
                -- A current code cannot establish membership of an earlier code.
                -- Ignore wholly disjoint periods and unexecuted future changes.
                IF p.start_date>observed_on OR (o.close_date IS NOT NULL AND p.start_date>=o.close_date)
                   OR (o.open_date IS NOT NULL AND p.end_date<=o.open_date) THEN CONTINUE; END IF;
                IF NOT p.is_current AND (p.end_date IS NULL OR p.end_date>observed_on) THEN
                    RAISE EXCEPTION 'Council period cannot be resolved at the source observation date';
                END IF;
                start_on:=greatest(o.open_date,p.start_date);
                end_on:=least(CASE WHEN o.close_date<=observed_on THEN o.close_date END,
                              CASE WHEN p.end_date<=observed_on THEN p.end_date END);
                IF start_on IS NOT NULL AND end_on IS NOT NULL AND end_on<=start_on THEN CONTINUE; END IF;
                IF (p.incorporation_date IS NOT NULL AND (start_on IS NULL OR start_on<p.incorporation_date))
                   OR (p.dissolution_date IS NOT NULL AND (end_on IS NULL OR end_on>p.dissolution_date)) THEN
                    RAISE EXCEPTION 'Derived period cannot be established within the council legal lifetime';
                END IF;
                current_flag:=o.source_status_code IN (1,3) AND p.is_current
                              AND (p.start_date IS NULL OR p.start_date<=observed_on)
                              AND (p.end_date IS NULL OR p.end_date>observed_on);
                basis:=CASE WHEN end_on IS NULL THEN NULL WHEN end_on=o.close_date THEN 'inferred' ELSE 'evidenced' END;
                inputs:=jsonb_build_object('area_code',o.area_code,'source_type_name',o.source_type_name,
                    'school_open',o.open_date,'school_close',o.close_date,
                    'council_effective_start',p.start_date,'council_effective_end',p.end_date,
                    'derived_start',start_on,'derived_end',end_on,'end_date_basis',basis,
                    'start_inferred',start_on IS NOT NULL,'closure_inferred',end_on=o.close_date,
                    'rule','maintenance-v1');
                SELECT d.*,r.legal_entity_id,r.start_date,r.end_date,r.end_date_basis,r.is_current
                INTO existing FROM migration.maintenance_derivation d
                JOIN establishment.establishment_responsibility r USING(establishment_responsibility_id)
                WHERE d.establishment_id=o.establishment_id
                  AND d.council_period_id=p.local_authority_area_council_period_id AND d.derivation_version='maintenance-v1';
                IF FOUND THEN
                    IF existing.legal_entity_id IS DISTINCT FROM p.legal_entity_id
                       OR existing.start_date IS DISTINCT FROM start_on OR existing.end_date IS DISTINCT FROM end_on
                       OR existing.end_date_basis IS DISTINCT FROM basis OR existing.is_current IS DISTINCT FROM current_flag THEN
                        RAISE EXCEPTION 'Existing maintenance boundary or holder differs; explicit reviewed update required';
                    END IF;
                    responsibility_id:=existing.establishment_responsibility_id;
                    UPDATE establishment.establishment_responsibility
                    SET first_observed_date=least(first_observed_date,observed_on)
                    WHERE establishment_responsibility_id=responsibility_id;
                ELSE
                    responsibility_id:=gen_random_uuid();
                    INSERT INTO establishment.establishment_responsibility(
                        establishment_responsibility_id,establishment_id,legal_entity_id,responsibility_type_id,
                        start_date,end_date,is_current,end_date_basis,first_observed_date)
                    VALUES(responsibility_id,o.establishment_id,p.legal_entity_id,5,
                           start_on,end_on,current_flag,basis,observed_on);
                    INSERT INTO migration.maintenance_derivation(establishment_id,council_period_id,
                        derivation_version,establishment_responsibility_id,accepted_inputs)
                    VALUES(o.establishment_id,p.local_authority_area_council_period_id,'maintenance-v1',responsibility_id,inputs);
                END IF;
                INSERT INTO migration.establishment_responsibility_evidence(
                    establishment_responsibility_id,source_record_id,first_observed_date,end_date_basis,inference_rule,notes)
                VALUES(responsibility_id,o.source_record_id,observed_on,basis,'maintenance-v1',inputs::text)
                ON CONFLICT DO NOTHING;
                matched:=matched+1;
                IF current_flag THEN current_matched:=current_matched+1; END IF;
            END LOOP;
            SELECT count(*) INTO current_count FROM establishment.establishment_responsibility
            WHERE establishment_id=o.establishment_id AND responsibility_type_id=5 AND is_current;
            IF o.source_status_code IN (1,3) AND (current_count<>1 OR current_matched<>1) THEN
                RAISE EXCEPTION 'Open eligible school has no resolved current council';
            END IF;
            IF o.source_status_code=2 AND current_count<>0 THEN
                RAISE EXCEPTION 'Closed school still has current maintenance';
            END IF;
            UPDATE migration.maintenance_source_observation SET processing_status='accepted',
            processing_note=format('%s supported council periods; unknown boundaries remain null',matched)
            WHERE source_record_id=o.source_record_id;
        EXCEPTION WHEN raise_exception OR check_violation OR unique_violation OR exclusion_violation OR no_data_found THEN
            UPDATE migration.maintenance_source_observation SET processing_status='review',processing_note=SQLERRM
            WHERE source_record_id=o.source_record_id;
        END;
    END LOOP;
END $$;


-- Refresh dependent functions from proprietor-extensions.sql

CREATE OR REPLACE FUNCTION migration.proprietor_source(run_id uuid,extract_key text,s jsonb)
RETURNS uuid LANGUAGE plpgsql AS $$
DECLARE snapshot_id uuid; record_id uuid;
BEGIN
    IF nullif(s->>'system','') IS NULL OR nullif(s->>'table','') IS NULL
       OR nullif(s->>'key','') IS NULL OR NOT s ? 'observedValues' THEN
        RAISE EXCEPTION 'Reviewed proprietor fact requires its source system, table, key and observed values';
    END IF;
    SELECT source_snapshot_id INTO snapshot_id FROM migration.source_snapshot WHERE extract_name=extract_key;
    IF snapshot_id IS NULL THEN
        INSERT INTO migration.source_snapshot(migration_run_id,source_system,source_database,snapshot_date,extract_name)
        VALUES(run_id,s->>'system',s->>'database',(s->>'observedDate')::date,extract_key)
        RETURNING source_snapshot_id INTO snapshot_id;
    END IF;
    INSERT INTO migration.source_record(source_snapshot_id,source_table,source_key,source_row_hash)
    VALUES(snapshot_id,s->>'table',s->>'key',md5(s::text)) ON CONFLICT DO NOTHING;
    SELECT source_record_id INTO STRICT record_id FROM migration.source_record WHERE source_snapshot_id=snapshot_id
      AND source_table=s->>'table' AND source_key=s->>'key' AND source_row_hash=md5(s::text);
    RETURN record_id;
END $$;

CREATE OR REPLACE FUNCTION migration.apply_reviewed_proprietor(d jsonb,run_id uuid)
RETURNS uuid LANGUAGE plpgsql AS $$
DECLARE key text:=d->>'decisionId'; party uuid; form integer; source_id uuid;
    fact jsonb; fact_id uuid; school_id uuid; purpose integer; accepted_address uuid; link_id uuid;
BEGIN
    IF nullif(key,'') IS NULL THEN RAISE EXCEPTION 'Proprietor decision needs a stable decisionId'; END IF;
    PERFORM pg_advisory_xact_lock(hashtextextended('proprietor/'||key,0));
    IF EXISTS(SELECT 1 FROM migration.proprietor_review WHERE decision_id=key
              AND review_status='accepted' AND payload IS DISTINCT FROM d) THEN
        RAISE EXCEPTION 'Accepted proprietor decision changed; explicit correction required';
    END IF;
    INSERT INTO migration.proprietor_review VALUES(key,d,
        CASE WHEN d->>'reviewStatus'='accepted' THEN 'accepted' ELSE 'pending' END,
        coalesce(nullif(d->>'reviewEvidence',''),'Identity, classification or registration evidence requires review'))
    ON CONFLICT(decision_id) DO NOTHING;
    IF d->>'reviewStatus' IS DISTINCT FROM 'accepted' THEN RETURN NULL; END IF;
    party:=(d->>'legalEntityId')::uuid; form:=(d->>'legalEntityTypeId')::integer;
    IF party IS NULL OR form IS NULL OR NOT EXISTS(SELECT 1 FROM establishment.legal_entity_type WHERE legal_entity_type_id=form)
       OR nullif(btrim(d->>'name'),'') IS NULL OR nullif(btrim(d->>'reviewEvidence'),'') IS NULL
       OR coalesce(d->>'proprietorKind','') NOT IN ('Individual','Body','Partnership') THEN
        RAISE EXCEPTION 'Incomplete reviewed proprietor identity or classification';
    END IF;
    IF coalesce(jsonb_array_length(d->'schools'),0)=0 THEN RAISE EXCEPTION 'Reviewed proprietor requires its establishment assertions'; END IF;
    IF d->>'proprietorKind'='Individual' AND (form<>11 OR nullif(d->>'individualIdentityKey','') IS NULL
       OR coalesce(d->>'acceptedNameKind','') NOT IN ('trading_name','personal_name')) THEN
        RAISE EXCEPTION 'Individual proprietor requires one reviewed sole-trader identity and selected name evidence';
    END IF;
    IF (form=11 AND d->>'proprietorKind'<>'Individual')
       OR (form=12 AND d->>'proprietorKind'<>'Partnership')
       OR (d->>'proprietorKind'='Partnership' AND form<>12) THEN
        RAISE EXCEPTION 'Proprietor kind and legal form disagree';
    END IF;
    IF form=11 THEN
        PERFORM pg_advisory_xact_lock(hashtextextended('individual-proprietor/'||(d->>'individualIdentityKey'),0));
    END IF;
    IF form=11 AND EXISTS(SELECT 1 FROM migration.proprietor_review r WHERE r.decision_id<>key
       AND r.review_status='accepted' AND r.payload->>'individualIdentityKey'=d->>'individualIdentityKey'
       AND r.payload->>'legalEntityId'<>d->>'legalEntityId') THEN
        RAISE EXCEPTION 'One reviewed individual cannot acquire a second sole-trader identity';
    END IF;
    PERFORM pg_advisory_xact_lock(hashtextextended('proprietor-identity/'||party::text,0));
    IF EXISTS(SELECT 1 FROM establishment.legal_entity WHERE legal_entity_id=party
              AND (name IS DISTINCT FROM d->>'name' OR legal_entity_type_id IS DISTINCT FROM form))
       OR EXISTS(SELECT 1 FROM establishment.legal_entity WHERE legal_entity_id<>party
                 AND lower(btrim(name))=lower(btrim(d->>'name'))) THEN
        RAISE EXCEPTION 'Reviewed proprietor identity collision';
    END IF;
    source_id:=migration.proprietor_source(run_id,'proprietor/'||key||'/identity',d->'source');
    INSERT INTO establishment.legal_entity(legal_entity_id,name,legal_entity_type_id)
    VALUES(party,d->>'name',form) ON CONFLICT DO NOTHING;
    INSERT INTO migration.identity_resolution(source_record_id,target_entity_type,target_entity_id,resolution_method,
        confidence,decision_status,rationale)
    SELECT source_id,'legal_entity',party,'reviewed-proprietor-entity','reviewed','accepted',d->>'reviewEvidence'
    WHERE NOT EXISTS(SELECT 1 FROM migration.identity_resolution WHERE source_record_id=source_id AND target_entity_id=party);
    INSERT INTO migration.proprietor_fact_evidence VALUES(key,'identity',source_id,'legal_entity',party,d,'accepted') ON CONFLICT DO NOTHING;
    FOR fact IN SELECT value FROM jsonb_array_elements(coalesce(d->'schools','[]')) LOOP
        SELECT e.establishment_id INTO STRICT school_id FROM establishment.establishment e WHERE urn=(fact->>'urn')::integer;
        fact_id:=(fact->>'responsibilityId')::uuid;
        IF fact_id IS NULL OR NOT fact ? 'isCurrent' THEN RAISE EXCEPTION 'Reviewed responsibility needs a stable ID and current assertion'; END IF;
        IF (fact->>'isCurrent')::boolean AND NOT EXISTS(SELECT 1 FROM establishment.establishment_lifecycle l
             JOIN establishment.establishment_status s USING(establishment_status_id)
             WHERE l.establishment_id=school_id AND s.code IN (1,3)) THEN
            RAISE EXCEPTION 'Closed school cannot acquire a current reviewed proprietor';
        END IF;
        IF (fact->>'isCurrent')::boolean AND NOT EXISTS(SELECT 1 FROM establishment.establishment
             WHERE establishment_id=school_id AND establishment_type_id IN (SELECT establishment_type_id FROM establishment.establishment_type WHERE code IN ('06','08','10','11'))) THEN
            RAISE EXCEPTION 'Current proprietor requires an eligible school type';
        END IF;
        IF EXISTS(SELECT 1 FROM establishment.establishment_responsibility r WHERE establishment_responsibility_id=fact_id
           AND ROW(r.establishment_id,r.legal_entity_id,r.responsibility_type_id,r.start_date,r.end_date,r.is_current)
             IS DISTINCT FROM ROW(school_id,party,4,(fact->>'startDate')::date,(fact->>'endDate')::date,(fact->>'isCurrent')::boolean)) THEN
            RAISE EXCEPTION 'Reviewed proprietor responsibility ID collision';
        END IF;
        INSERT INTO establishment.establishment_responsibility(establishment_responsibility_id,establishment_id,legal_entity_id,
            responsibility_type_id,start_date,end_date,is_current,first_observed_date)
        VALUES(fact_id,school_id,party,4,(fact->>'startDate')::date,(fact->>'endDate')::date,
               (fact->>'isCurrent')::boolean,(d->'source'->>'observedDate')::date) ON CONFLICT DO NOTHING;
        INSERT INTO migration.establishment_responsibility_evidence(establishment_responsibility_id,source_record_id,
            first_observed_date,inference_rule,notes)
        SELECT fact_id,source_id,(d->'source'->>'observedDate')::date,'reviewed-proprietor-v1',d::text
        WHERE NOT EXISTS(SELECT 1 FROM migration.establishment_responsibility_evidence
                         WHERE establishment_responsibility_id=fact_id AND source_record_id=source_id);
        INSERT INTO migration.proprietor_fact_evidence VALUES(key,'responsibility/'||fact_id,source_id,
            'establishment_responsibility',fact_id,fact,'accepted') ON CONFLICT DO NOTHING;
    END LOOP;
    FOR fact IN SELECT value FROM jsonb_array_elements(coalesce(d->'identifiers','[]')) LOOP
        IF fact->>'verified' IS DISTINCT FROM 'true' OR nullif(fact->>'verificationEvidence','') IS NULL THEN
            source_id:=migration.proprietor_source(run_id,'proprietor/'||key||'/identifier/'||(fact->>'value'),fact->'source');
            INSERT INTO migration.proprietor_fact_evidence VALUES(key,'identifier/'||(fact->>'value'),source_id,
                'organisation_identifier',NULL,fact,'pending') ON CONFLICT DO NOTHING;
            CONTINUE;
        END IF;
        IF coalesce(fact->>'type','') NOT IN ('Companies House number','UKPRN')
           OR nullif(fact->>'value','') IS NULL
           OR (form=5 AND fact->>'type'='Companies House number' AND fact->>'value' !~ '^(OC|SO|NC)[0-9]{6}$') THEN
            RAISE EXCEPTION 'Organisation identifiers require verified registration evidence and preserved prefixes';
        END IF;
        IF EXISTS(SELECT 1 FROM establishment.organisation_identifier i JOIN establishment.organisation_identifier_type t USING(organisation_identifier_type_id)
                   WHERE t.name=fact->>'type' AND i.value=fact->>'value' AND i.legal_entity_id<>party) THEN
            RAISE EXCEPTION 'Verified organisation identifier belongs to another identity';
        END IF;
        INSERT INTO establishment.organisation_identifier(legal_entity_id,organisation_identifier_type_id,value,is_current)
        SELECT party,organisation_identifier_type_id,fact->>'value',true FROM establishment.organisation_identifier_type WHERE name=fact->>'type'
        ON CONFLICT DO NOTHING;
        SELECT i.organisation_identifier_id INTO STRICT fact_id FROM establishment.organisation_identifier i
        JOIN establishment.organisation_identifier_type t USING(organisation_identifier_type_id)
        WHERE i.legal_entity_id=party AND t.name=fact->>'type' AND i.value=fact->>'value' AND i.is_current;
        source_id:=migration.proprietor_source(run_id,'proprietor/'||key||'/identifier/'||(fact->>'value'),fact->'source');
        INSERT INTO migration.proprietor_fact_evidence VALUES(key,'identifier/'||(fact->>'value'),source_id,
            'organisation_identifier',fact_id,fact,'accepted') ON CONFLICT DO NOTHING;
    END LOOP;
    FOR fact IN SELECT value FROM jsonb_array_elements(coalesce(d->'addresses','[]')) LOOP
        source_id:=migration.proprietor_source(run_id,'proprietor/'||key||'/address/'||(fact->>'factKey'),fact->'source');
        SELECT address_purpose_id INTO purpose FROM establishment.address_purpose WHERE name=fact->>'purpose';
        IF purpose IS NULL OR nullif(fact->>'reviewEvidence','') IS NULL THEN
            INSERT INTO migration.proprietor_fact_evidence VALUES(key,'address/'||(fact->>'factKey'),source_id,
                'address',NULL,fact,'pending') ON CONFLICT DO NOTHING;
            CONTINUE;
        END IF;
        accepted_address:=(fact->>'addressId')::uuid; link_id:=(fact->>'linkId')::uuid;
        IF accepted_address IS NULL OR link_id IS NULL THEN RAISE EXCEPTION 'Reviewed address needs stable address and link IDs'; END IF;
        IF EXISTS(SELECT 1 FROM establishment.address a WHERE a.address_id=accepted_address
           AND ROW(a.address_line_1,a.address_line_2,a.address_line_3,a.town,a.county,a.postcode) IS DISTINCT FROM
               ROW(fact->>'line1',fact->>'line2',fact->>'line3',fact->>'town',fact->>'county',fact->>'postcode')) THEN
            RAISE EXCEPTION 'Reviewed address ID collision';
        END IF;
        INSERT INTO establishment.address(address_id,address_line_1,address_line_2,address_line_3,town,county,postcode)
        VALUES(accepted_address,fact->>'line1',fact->>'line2',fact->>'line3',fact->>'town',fact->>'county',fact->>'postcode') ON CONFLICT DO NOTHING;
        IF EXISTS(SELECT 1 FROM establishment.legal_entity_address a WHERE legal_entity_address_id=link_id
                   AND ROW(a.legal_entity_id,a.address_id,a.address_purpose_id) IS DISTINCT FROM ROW(party,accepted_address,purpose)) THEN
            RAISE EXCEPTION 'Reviewed address-owner ID collision';
        END IF;
        INSERT INTO establishment.legal_entity_address(legal_entity_address_id,legal_entity_id,address_id,address_purpose_id)
        VALUES(link_id,party,accepted_address,purpose) ON CONFLICT DO NOTHING;
        IF NOT EXISTS(SELECT 1 FROM establishment.legal_entity_address WHERE legal_entity_address_id=link_id
                       AND legal_entity_id=party AND address_id=accepted_address
                       AND address_purpose_id=purpose AND is_current) THEN
            RAISE EXCEPTION 'Reviewed address conflicts with an existing current use';
        END IF;
        INSERT INTO migration.proprietor_fact_evidence VALUES(key,'address/'||(fact->>'factKey'),source_id,
            'legal_entity_address',link_id,fact,'accepted') ON CONFLICT DO NOTHING;
    END LOOP;
    IF d ? 'contactObservations' THEN
        INSERT INTO migration.proprietor_fact_evidence VALUES(key,'contacts',
            migration.proprietor_source(run_id,'proprietor/'||key||'/contacts',d->'source'),
            'deferred_legal_entity_contacts',NULL,d->'contactObservations','pending') ON CONFLICT DO NOTHING;
    END IF;
    RETURN party;
END $$;


-- Refresh dependent functions from council-reorganisation.sql

CREATE OR REPLACE FUNCTION migration.apply_council_reorganisation(reviewed_payload jsonb)
RETURNS text LANGUAGE plpgsql AS $$
DECLARE event_key text:=reviewed_payload->>'eventId'; effective_on date:=(reviewed_payload->>'effectiveDate')::date;
    observed_on date:=(reviewed_payload->'source'->>'observedDate')::date;
    payload_hash text:=encode(public.digest(reviewed_payload::text,'sha256'),'hex');
    old record; successor record; mapped record; row_before jsonb; fact jsonb;
    run_id uuid; source_id uuid; responsibility_id uuid; current_row record; eligibility boolean; previous_area uuid;
BEGIN
    PERFORM pg_advisory_xact_lock(hashtextextended('council-maintenance-transition',0));
    IF nullif(event_key,'') IS NULL OR effective_on IS NULL OR observed_on IS NULL
       OR observed_on>CURRENT_DATE OR nullif(reviewed_payload->>'evidence','') IS NULL
       OR nullif(reviewed_payload->'source'->>'system','') IS NULL
       OR nullif(reviewed_payload->'source'->>'table','') IS NULL
       OR nullif(reviewed_payload->'source'->>'key','') IS NULL
       OR NOT ((reviewed_payload->'source') ? 'observedValues') THEN
        RAISE EXCEPTION 'Council event requires its ID, effective date, evidence, source fields and a non-future observation date';
    END IF;
    IF EXISTS(SELECT 1 FROM migration.council_reorganisation e WHERE e.event_id=event_key AND e.payload_sha256<>payload_hash) THEN
        RAISE EXCEPTION 'Council event ID already has a different payload';
    END IF;
    IF EXISTS(SELECT 1 FROM migration.council_reorganisation WHERE event_id=event_key AND status='applied') THEN RETURN 'applied'; END IF;
    INSERT INTO migration.council_reorganisation(event_id,payload,payload_sha256,effective_date,observed_date,status,evidence)
    VALUES(event_key,reviewed_payload,payload_hash,effective_on,observed_on,'pending',reviewed_payload->>'evidence') ON CONFLICT DO NOTHING;
    IF reviewed_payload->>'reviewStatus' IS DISTINCT FROM 'accepted' THEN
        UPDATE migration.council_reorganisation SET status='review',note='Explicit accepted review is required' WHERE event_id=event_key;
        RETURN 'review';
    END IF;
    IF effective_on>CURRENT_DATE THEN RETURN 'pending'; END IF;
    CREATE TEMP TABLE IF NOT EXISTS reorg_old_periods(period_id uuid PRIMARY KEY,council_id uuid,area_id uuid) ON COMMIT DROP;
    CREATE TEMP TABLE IF NOT EXISTS reorg_successors(period_id uuid PRIMARY KEY,area_id uuid UNIQUE,council_id uuid) ON COMMIT DROP;
    CREATE TEMP TABLE IF NOT EXISTS reorg_school_map(establishment_id uuid PRIMARY KEY,area_id uuid,period_id uuid,council_id uuid) ON COMMIT DROP;
    TRUNCATE reorg_old_periods,reorg_successors,reorg_school_map;
    INSERT INTO reorg_old_periods(period_id,council_id,area_id)
    SELECT (x->>'periodId')::uuid,(x->>'expectedCouncilId')::uuid,p.local_authority_area_id
    FROM jsonb_array_elements(reviewed_payload->'oldPeriods') x
    LEFT JOIN establishment.local_authority_area_council_period p ON p.local_authority_area_council_period_id=(x->>'periodId')::uuid;
    INSERT INTO reorg_successors SELECT (x->>'periodId')::uuid,(x->>'areaId')::uuid,(x->>'councilId')::uuid
    FROM jsonb_array_elements(reviewed_payload->'successors') x;
    IF NOT EXISTS(SELECT 1 FROM reorg_old_periods) OR NOT EXISTS(SELECT 1 FROM reorg_successors)
       OR EXISTS(SELECT 1 FROM reorg_old_periods WHERE area_id IS NULL OR council_id IS NULL)
       OR EXISTS(SELECT 1 FROM reorg_successors WHERE area_id IS NULL OR council_id IS NULL) THEN
        RAISE EXCEPTION 'Council event requires resolved previous periods and explicit successor mappings';
    END IF;
    IF EXISTS(SELECT 1 FROM jsonb_array_elements(coalesce(reviewed_payload->'newCouncils','[]')) x
              WHERE NOT EXISTS(SELECT 1 FROM reorg_successors s WHERE s.council_id=(x->>'legalEntityId')::uuid))
       OR EXISTS(SELECT 1 FROM jsonb_array_elements(coalesce(reviewed_payload->'newAreas','[]')) x
                   WHERE NOT EXISTS(SELECT 1 FROM reorg_successors s WHERE s.area_id=(x->>'areaId')::uuid)) THEN
        RAISE EXCEPTION 'Every supplied new council and area must be used by a reviewed successor mapping';
    END IF;
    PERFORM 1 FROM establishment.local_authority_area WHERE local_authority_area_id IN
        (SELECT area_id FROM reorg_old_periods UNION SELECT area_id FROM reorg_successors) ORDER BY local_authority_area_id FOR UPDATE;
    IF EXISTS(SELECT 1 FROM reorg_old_periods o JOIN establishment.local_authority_area_council_period p
              ON p.local_authority_area_council_period_id=o.period_id
              WHERE p.legal_entity_id<>o.council_id OR NOT p.is_current OR p.start_date>=effective_on
                 OR (p.end_date IS NOT NULL AND p.end_date<>effective_on))
       OR EXISTS(SELECT 1 FROM migration.council_reorganisation e
                  JOIN migration.council_reorganisation_lineage l USING(event_id)
                  WHERE e.status='applied' AND e.effective_date>=effective_on
                    AND l.entity_kind='council_period' AND (l.after_row->>'local_authority_area_id')::uuid IN
                         (SELECT area_id FROM reorg_old_periods)) THEN
        UPDATE migration.council_reorganisation SET status='review',note='Previous period mismatch or out-of-order effective date; explicit correction required' WHERE event_id=event_key;
        RETURN 'review';
    END IF;
    IF EXISTS(SELECT 1 FROM establishment.establishment_responsibility r
              JOIN establishment.establishment_geography g USING(establishment_id)
              JOIN establishment.establishment_lifecycle life USING(establishment_id)
              WHERE r.responsibility_type_id=5 AND g.local_authority_area_id IN(SELECT area_id FROM reorg_old_periods)
                AND (r.start_date>=effective_on OR (r.is_current AND life.open_date>effective_on)
                     OR (NOT r.is_current AND (r.end_date IS NULL OR r.end_date>effective_on)))) THEN
        UPDATE migration.council_reorganisation SET status='review',note='Backdated transition intersects existing responsibility history; explicit correction required' WHERE event_id=event_key;
        RETURN 'review';
    END IF;
    IF EXISTS(SELECT 1 FROM reorg_old_periods p JOIN establishment.legal_entity c ON c.legal_entity_id=p.council_id
              WHERE c.incorporation_date>effective_on OR c.dissolution_date<effective_on) THEN
        UPDATE migration.council_reorganisation SET status='review',note='Previous council lifetime contradicts the effective date' WHERE event_id=event_key;
        RETURN 'review';
    END IF;
    FOR fact IN SELECT value FROM jsonb_array_elements(coalesce(reviewed_payload->'newCouncils','[]')) LOOP
        IF EXISTS(SELECT 1 FROM establishment.legal_entity c WHERE c.legal_entity_id=(fact->>'legalEntityId')::uuid
                   AND (c.name IS DISTINCT FROM fact->>'name' OR c.legal_entity_type_id IS DISTINCT FROM 9)) THEN
            RAISE EXCEPTION 'Reviewed council identity collision';
        END IF;
        INSERT INTO establishment.legal_entity(legal_entity_id,name,legal_entity_type_id,incorporation_date,dissolution_date)
        VALUES((fact->>'legalEntityId')::uuid,fact->>'name',9,(fact->>'incorporationDate')::date,(fact->>'dissolutionDate')::date)
        ON CONFLICT DO NOTHING;
    END LOOP;
    PERFORM 1 FROM establishment.legal_entity WHERE legal_entity_id IN
        (SELECT council_id FROM reorg_old_periods UNION SELECT council_id FROM reorg_successors) ORDER BY legal_entity_id FOR UPDATE;
    IF EXISTS(SELECT 1 FROM reorg_successors s LEFT JOIN establishment.legal_entity c ON c.legal_entity_id=s.council_id
              WHERE c.legal_entity_type_id IS DISTINCT FROM 9 OR c.incorporation_date>effective_on OR c.dissolution_date<=effective_on) THEN
        RAISE EXCEPTION 'Successor must be an existing or explicitly supplied Public body within its legal lifetime';
    END IF;
    FOR fact IN SELECT value FROM jsonb_array_elements(coalesce(reviewed_payload->'newAreas','[]')) LOOP
        IF EXISTS(SELECT 1 FROM establishment.local_authority_area a WHERE a.local_authority_area_id=(fact->>'areaId')::uuid OR a.code=(fact->>'code')::integer) THEN
            RAISE EXCEPTION 'New area ID or code already exists; retained codes must use their existing identity';
        END IF;
        INSERT INTO establishment.local_authority_area(local_authority_area_id,code,name,local_authority_jurisdiction_id)
        VALUES((fact->>'areaId')::uuid,(fact->>'code')::integer,fact->>'name',(fact->>'jurisdictionId')::integer);
        INSERT INTO migration.council_reorganisation_lineage
        SELECT event_key,'local_authority_area',a.local_authority_area_id,'created',NULL,to_jsonb(a)
        FROM establishment.local_authority_area a WHERE a.local_authority_area_id=(fact->>'areaId')::uuid;
    END LOOP;
    IF EXISTS(SELECT 1 FROM reorg_successors s LEFT JOIN establishment.local_authority_area a ON a.local_authority_area_id=s.area_id
              WHERE a.local_authority_area_id IS NULL) THEN RAISE EXCEPTION 'Successor area is missing'; END IF;
    IF jsonb_array_length(coalesce(reviewed_payload->'schoolMappings','[]'))>0 THEN
        INSERT INTO reorg_school_map
        SELECT e.establishment_id,s.area_id,s.period_id,s.council_id
        FROM jsonb_array_elements(reviewed_payload->'schoolMappings') x
        LEFT JOIN establishment.establishment e ON e.urn=(x->>'urn')::integer
        LEFT JOIN reorg_successors s ON s.area_id=(x->>'areaId')::uuid;
    ELSE
        IF EXISTS(SELECT 1 FROM reorg_successors s WHERE NOT EXISTS(SELECT 1 FROM reorg_old_periods o WHERE o.area_id=s.area_id))
           OR EXISTS(SELECT 1 FROM reorg_old_periods o WHERE NOT EXISTS(SELECT 1 FROM reorg_successors s WHERE s.area_id=o.area_id)) THEN
            RAISE EXCEPTION 'New-code splits and mergers require complete reviewed school mappings';
        END IF;
        INSERT INTO reorg_school_map SELECT g.establishment_id,s.area_id,s.period_id,s.council_id
        FROM establishment.establishment_geography g JOIN reorg_old_periods o ON o.area_id=g.local_authority_area_id
        JOIN reorg_successors s ON s.area_id=o.area_id;
    END IF;
    IF EXISTS(SELECT 1 FROM reorg_school_map m LEFT JOIN establishment.establishment_geography g USING(establishment_id)
              LEFT JOIN establishment.establishment_lifecycle life USING(establishment_id)
              WHERE m.area_id IS NULL OR m.period_id IS NULL OR g.establishment_id IS NULL OR life.establishment_id IS NULL
                 OR g.local_authority_area_id NOT IN(SELECT area_id FROM reorg_old_periods))
       OR EXISTS(SELECT 1 FROM establishment.establishment_geography g WHERE g.local_authority_area_id IN(SELECT area_id FROM reorg_old_periods)
                  AND NOT EXISTS(SELECT 1 FROM reorg_school_map m WHERE m.establishment_id=g.establishment_id)) THEN
        RAISE EXCEPTION 'Reviewed school mapping must cover exactly the affected establishments';
    END IF;
    IF EXISTS(SELECT 1 FROM reorg_school_map m JOIN establishment.establishment_geography g USING(establishment_id)
              JOIN establishment.local_authority_area a ON a.local_authority_area_id=g.local_authority_area_id
              JOIN establishment.local_authority_area b ON b.local_authority_area_id=m.area_id
              WHERE a.local_authority_jurisdiction_id<>b.local_authority_jurisdiction_id) THEN
        RAISE EXCEPTION 'Cross-jurisdiction transitions require a separate reviewed policy decision';
    END IF;
    PERFORM 1 FROM establishment.establishment WHERE establishment_id IN(SELECT establishment_id FROM reorg_school_map)
    ORDER BY establishment_id FOR UPDATE;
    INSERT INTO migration.migration_run(run_type,source_system,source_snapshot_date,status,transform_version,notes)
    VALUES('reviewed-council-reorganisation','Reviewed council event',observed_on,'completed','council-event-v1',reviewed_payload->>'evidence')
    RETURNING migration_run_id INTO run_id;
    source_id:=migration.proprietor_source(run_id,'council-event/'||event_key,reviewed_payload->'source');
    UPDATE migration.council_reorganisation SET source_record_id=source_id WHERE event_id=event_key;
    FOR old IN SELECT p.* FROM reorg_old_periods o JOIN establishment.local_authority_area_council_period p
               ON p.local_authority_area_council_period_id=o.period_id ORDER BY p.local_authority_area_council_period_id LOOP
        row_before:=to_jsonb(old);
        UPDATE establishment.local_authority_area_council_period SET end_date=effective_on,is_current=false
        WHERE local_authority_area_council_period_id=old.local_authority_area_council_period_id;
        INSERT INTO migration.council_reorganisation_lineage
        SELECT event_key,'council_period',p.local_authority_area_council_period_id,'changed',row_before,to_jsonb(p)
        FROM establishment.local_authority_area_council_period p WHERE p.local_authority_area_council_period_id=old.local_authority_area_council_period_id;
    END LOOP;
    FOR successor IN SELECT * FROM reorg_successors ORDER BY period_id LOOP
        IF NOT EXISTS(SELECT 1 FROM establishment.local_authority_area_council_period WHERE legal_entity_id=successor.council_id) THEN
            INSERT INTO migration.council_reorganisation_lineage
            SELECT event_key,'legal_entity',c.legal_entity_id,'council_added',to_jsonb(c),to_jsonb(c)
            FROM establishment.legal_entity c WHERE c.legal_entity_id=successor.council_id ON CONFLICT DO NOTHING;
        END IF;
        INSERT INTO establishment.local_authority_area_council_period(local_authority_area_council_period_id,
            local_authority_area_id,legal_entity_id,start_date,is_current)
        VALUES(successor.period_id,successor.area_id,successor.council_id,effective_on,true);
        INSERT INTO migration.council_reorganisation_lineage
        SELECT event_key,'council_period',p.local_authority_area_council_period_id,'created',NULL,to_jsonb(p)
        FROM establishment.local_authority_area_council_period p WHERE p.local_authority_area_council_period_id=successor.period_id;
    END LOOP;
    FOR mapped IN SELECT m.*,e.establishment_type_id,t.code AS type_code,status.code AS establishment_status_code,l.open_date,l.close_date,j.name AS jurisdiction
                  FROM reorg_school_map m JOIN establishment.establishment e USING(establishment_id) JOIN establishment.establishment_type t USING(establishment_type_id)
                  JOIN establishment.establishment_lifecycle l USING(establishment_id)
    JOIN establishment.establishment_status status USING(establishment_status_id)
                  JOIN establishment.local_authority_area a ON a.local_authority_area_id=m.area_id
                  JOIN establishment.local_authority_jurisdiction j USING(local_authority_jurisdiction_id)
                  ORDER BY m.establishment_id LOOP
        SELECT to_jsonb(g) INTO row_before FROM establishment.establishment_geography g WHERE g.establishment_id=mapped.establishment_id;
        previous_area:=(row_before->>'local_authority_area_id')::uuid;
        UPDATE establishment.establishment_geography SET local_authority_area_id=mapped.area_id WHERE establishment_id=mapped.establishment_id;
        INSERT INTO migration.council_reorganisation_lineage
        SELECT event_key,'establishment_geography',g.establishment_id,'changed',row_before,to_jsonb(g)
        FROM establishment.establishment_geography g WHERE g.establishment_id=mapped.establishment_id;
        eligibility:=mapped.jurisdiction='English' AND mapped.type_code IN ('01','02','03','05','07','12','14','15')
                     AND mapped.establishment_status_code IN(1,3) AND (mapped.open_date IS NULL OR mapped.open_date<=effective_on)
                     AND (mapped.close_date IS NULL OR mapped.close_date>effective_on);
        IF NOT eligibility THEN CONTINUE; END IF;
        SELECT r.* INTO current_row FROM establishment.establishment_responsibility r
        WHERE r.establishment_id=mapped.establishment_id AND r.responsibility_type_id=5 AND r.is_current;
        IF NOT FOUND THEN RAISE EXCEPTION 'Eligible school lacks a resolved current maintainer for this transition'; END IF;
        IF NOT EXISTS(SELECT 1 FROM reorg_old_periods WHERE council_id=current_row.legal_entity_id AND area_id=previous_area)
           OR current_row.start_date>=effective_on OR current_row.end_date IS NOT NULL THEN
            RAISE EXCEPTION 'Active maintenance does not match the expected previous council and period';
        END IF;
        row_before:=to_jsonb(current_row);
        UPDATE establishment.establishment_responsibility SET end_date=effective_on,end_date_basis='evidenced',is_current=false
        WHERE establishment_responsibility_id=current_row.establishment_responsibility_id;
        INSERT INTO migration.council_reorganisation_lineage
        SELECT event_key,'establishment_responsibility',r.establishment_responsibility_id,'changed',row_before,to_jsonb(r)
        FROM establishment.establishment_responsibility r WHERE r.establishment_responsibility_id=current_row.establishment_responsibility_id;
        INSERT INTO migration.establishment_responsibility_evidence(establishment_responsibility_id,source_record_id,
            first_observed_date,end_date_basis,inference_rule,notes)
        VALUES(current_row.establishment_responsibility_id,source_id,observed_on,'evidenced','council-reorganisation',reviewed_payload::text);
        INSERT INTO establishment.establishment_responsibility(establishment_id,legal_entity_id,responsibility_type_id,
            start_date,is_current,first_observed_date)
        VALUES(mapped.establishment_id,mapped.council_id,5,effective_on,true,observed_on) RETURNING establishment_responsibility_id INTO responsibility_id;
        INSERT INTO migration.maintenance_derivation(establishment_id,council_period_id,derivation_version,
            establishment_responsibility_id,accepted_inputs)
        VALUES(mapped.establishment_id,mapped.period_id,'reviewed-event/'||event_key,responsibility_id,reviewed_payload);
        INSERT INTO migration.establishment_responsibility_evidence(establishment_responsibility_id,source_record_id,
            first_observed_date,inference_rule,notes)
        VALUES(responsibility_id,source_id,observed_on,'council-reorganisation',reviewed_payload::text);
        INSERT INTO migration.council_reorganisation_lineage
        SELECT event_key,'establishment_responsibility',r.establishment_responsibility_id,'created',NULL,to_jsonb(r)
        FROM establishment.establishment_responsibility r WHERE r.establishment_responsibility_id=responsibility_id;
    END LOOP;
    UPDATE migration.council_reorganisation SET status='applied',applied_at=now(),note='Atomic reviewed transition completed' WHERE event_id=event_key;
    RETURN 'applied';
END $$;

CREATE OR REPLACE FUNCTION migration.retain_reviewed_maintenance(source_id uuid,source_date date)
RETURNS boolean LANGUAGE plpgsql AS $$
DECLARE governing record; observed record; normalized jsonb; school record; allowed boolean; disposition text;
BEGIN
    SELECT o.*,e.urn INTO STRICT observed FROM migration.maintenance_source_observation o
    JOIN establishment.establishment e USING(establishment_id) WHERE o.source_record_id=source_id;
    SELECT ev.* INTO governing FROM migration.council_reorganisation ev
    JOIN migration.council_reorganisation_lineage l USING(event_id)
    WHERE l.entity_id=observed.establishment_id AND l.entity_kind='establishment_geography' AND ev.status='applied'
    ORDER BY ev.effective_date DESC LIMIT 1;
    IF NOT FOUND THEN RETURN false; END IF;
    SELECT e.establishment_type_id,t.name,t.code AS type_code INTO STRICT school FROM establishment.establishment e
    JOIN establishment.establishment_type t USING(establishment_type_id) WHERE e.establishment_id=observed.establishment_id;
    normalized:=to_jsonb(observed)||jsonb_build_object('local_authority_code',observed.area_code,
        'status_code',observed.source_status_code,'establishment_type_id',
        CASE WHEN observed.source_type_name=school.name OR (school.type_code NOT IN ('01','02','03','05','07','12','14','15')
             AND observed.source_type_name NOT IN('Community school','Community special school','Foundation special school',
                 'Voluntary aided school','Voluntary controlled school','Foundation school','Pupil referral unit','Maintained nursery school'))
        THEN school.establishment_type_id ELSE (SELECT establishment_type_id FROM establishment.establishment_type WHERE name=observed.source_type_name) END);
    allowed:=migration.allow_establishment_replay(observed.urn,source_date,normalized);
    disposition:=CASE WHEN NOT allowed AND (source_date IS NULL OR source_date>governing.effective_date) THEN 'review' ELSE 'retained' END;
    INSERT INTO migration.council_replay_observation VALUES(governing.event_id,observed.establishment_id,source_date,
        normalized,md5(jsonb_build_object('observed_date',source_date,'payload',normalized)::text),disposition) ON CONFLICT DO NOTHING;
    IF allowed THEN
        UPDATE establishment.establishment_responsibility SET first_observed_date=least(first_observed_date,source_date)
        WHERE establishment_id=observed.establishment_id AND responsibility_type_id=5 AND is_current;
        INSERT INTO migration.establishment_responsibility_evidence(establishment_responsibility_id,source_record_id,
            first_observed_date,inference_rule,notes)
        SELECT r.establishment_responsibility_id,source_id,source_date,'reviewed-event-replay',governing.event_id
        FROM establishment.establishment_responsibility r WHERE r.establishment_id=observed.establishment_id
          AND r.responsibility_type_id=5 AND r.is_current AND NOT EXISTS(
              SELECT 1 FROM migration.establishment_responsibility_evidence ev
              WHERE ev.establishment_responsibility_id=r.establishment_responsibility_id AND ev.source_record_id=source_id
                AND ev.inference_rule='reviewed-event-replay');
    END IF;
    UPDATE migration.maintenance_source_observation SET processing_status=CASE WHEN disposition='review' THEN 'review' ELSE 'accepted' END,
        processing_note=CASE WHEN disposition='review' THEN 'Newer snapshot conflicts with the reviewed council event; correction requires review'
                             ELSE 'Reviewed council event retained; ordinary source assertion preserved as replay evidence' END
    WHERE source_record_id=source_id;
    RETURN true;
END $$;

CREATE OR REPLACE FUNCTION migration.allow_establishment_replay(source_urn integer,source_date date,source_payload jsonb)
RETURNS boolean LANGUAGE plpgsql AS $$
DECLARE governing record; school record; disposition text;
BEGIN
    SELECT ev.* INTO governing FROM migration.council_reorganisation ev
    JOIN migration.council_reorganisation_lineage line USING(event_id)
    JOIN establishment.establishment e ON e.establishment_id=line.entity_id
    WHERE e.urn=source_urn AND line.entity_kind='establishment_geography' AND ev.status='applied'
    ORDER BY ev.effective_date DESC LIMIT 1;
    IF NOT FOUND THEN RETURN true; END IF;
    SELECT e.establishment_id,e.establishment_type_id,status.code AS establishment_status_code,l.open_date,l.close_date,a.code
    INTO STRICT school FROM establishment.establishment e JOIN establishment.establishment_lifecycle l USING(establishment_id)
    JOIN establishment.establishment_status status USING(establishment_status_id)
    JOIN establishment.establishment_geography g USING(establishment_id)
    JOIN establishment.local_authority_area a USING(local_authority_area_id) WHERE e.urn=source_urn;
    IF source_date>governing.effective_date AND
       ROW((source_payload->>'local_authority_code')::integer,(source_payload->>'establishment_type_id')::uuid,
           (source_payload->>'status_code')::integer,(source_payload->>'open_date')::date,(source_payload->>'close_date')::date)
       IS NOT DISTINCT FROM ROW(school.code,school.establishment_type_id,school.establishment_status_code,school.open_date,school.close_date) THEN
        RETURN true;
    END IF;
    disposition:=CASE WHEN source_date IS NULL OR source_date>governing.effective_date THEN 'review' ELSE 'retained' END;
    INSERT INTO migration.council_replay_observation VALUES(governing.event_id,school.establishment_id,source_date,
        source_payload,md5(jsonb_build_object('observed_date',source_date,'payload',source_payload)::text),disposition) ON CONFLICT DO NOTHING;
    RETURN false;
END $$;

CREATE TEMP TABLE code_list_after ON COMMIT DROP AS
SELECT e.urn,e.establishment_id,e.establishment_type_id,t.establishment_type_category_id,
       st.code AS status_code,
       ep.name AS phase,
       reo.name AS opened_reason,rec.name AS closed_reason,l.open_date,l.close_date,l.last_changed_date
FROM establishment.establishment e
JOIN establishment.establishment_type t USING(establishment_type_id)
LEFT JOIN establishment.establishment_lifecycle l USING(establishment_id)
LEFT JOIN establishment.establishment_status st USING(establishment_status_id)
LEFT JOIN establishment.education_phase ep USING(education_phase_id)
LEFT JOIN establishment.reason_establishment_opened reo USING(reason_establishment_opened_id)
LEFT JOIN establishment.reason_establishment_closed rec USING(reason_establishment_closed_id);

DO $$ BEGIN
    IF EXISTS((SELECT * FROM code_list_before EXCEPT ALL SELECT * FROM code_list_after)
              UNION ALL (SELECT * FROM code_list_after EXCEPT ALL SELECT * FROM code_list_before)) THEN
        RAISE EXCEPTION 'Code-list upgrade changed establishment membership or business facts';
    END IF;
END $$;

COMMIT;
