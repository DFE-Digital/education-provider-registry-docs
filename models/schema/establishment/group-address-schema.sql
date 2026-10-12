-- Explicit business periods. Unknown dates stay null; no maintenance triggers.
CREATE EXTENSION IF NOT EXISTS btree_gist;
CREATE TABLE IF NOT EXISTS establishment.address_purpose (
    address_purpose_id integer PRIMARY KEY,
    code text NOT NULL UNIQUE,
    name text NOT NULL UNIQUE,
    CHECK ((address_purpose_id=1 AND code='registered') OR
           (address_purpose_id=2 AND code='contact') OR
           (address_purpose_id=3 AND code='administrative'))
);
CREATE TABLE IF NOT EXISTS establishment.legal_entity_address (
    legal_entity_address_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    legal_entity_id uuid NOT NULL REFERENCES establishment.legal_entity(legal_entity_id),
    address_id uuid NOT NULL REFERENCES establishment.address(address_id),
    address_purpose_id integer NOT NULL REFERENCES establishment.address_purpose(address_purpose_id),
    start_date date,
    end_date date,
    is_current boolean NOT NULL DEFAULT true
);
CREATE TABLE IF NOT EXISTS establishment.organisation_group_address (
    organisation_group_address_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    organisation_group_id uuid NOT NULL REFERENCES establishment.organisation_group(organisation_group_id),
    address_id uuid NOT NULL REFERENCES establishment.address(address_id),
    address_purpose_id integer NOT NULL REFERENCES establishment.address_purpose(address_purpose_id),
    CHECK(address_purpose_id IN (2,3)),
    start_date date,
    end_date date,
    is_current boolean NOT NULL DEFAULT true
);
-- Additive upgrade preserves existing association IDs and unknown boundaries.
ALTER TABLE establishment.legal_entity_address
    ADD COLUMN IF NOT EXISTS start_date date,
    ADD COLUMN IF NOT EXISTS end_date date,
    ADD COLUMN IF NOT EXISTS is_current boolean NOT NULL DEFAULT true;
ALTER TABLE establishment.organisation_group_address
    ADD COLUMN IF NOT EXISTS start_date date,
    ADD COLUMN IF NOT EXISTS end_date date,
    ADD COLUMN IF NOT EXISTS is_current boolean NOT NULL DEFAULT true;
DO $$
DECLARE table_name text; owner_column text; old_constraint record;
BEGIN
    FOREACH table_name IN ARRAY ARRAY['legal_entity_address','organisation_group_address'] LOOP
        owner_column:=CASE table_name WHEN 'legal_entity_address' THEN 'legal_entity_id' ELSE 'organisation_group_id' END;
        FOR old_constraint IN
            SELECT c.conname FROM pg_constraint c
            WHERE c.conrelid=format('establishment.%I',table_name)::regclass AND c.contype='u'
              AND (SELECT array_agg(a.attname::text ORDER BY a.attname) FROM pg_attribute a
                   WHERE a.attrelid=c.conrelid AND a.attnum=ANY(c.conkey))
                  = ARRAY['address_purpose_id',owner_column]
        LOOP
            EXECUTE format('ALTER TABLE establishment.%I DROP CONSTRAINT %I',table_name,old_constraint.conname);
        END LOOP;
        IF NOT EXISTS(SELECT 1 FROM pg_constraint WHERE conrelid=format('establishment.%I',table_name)::regclass AND conname=table_name||'_dates_check') THEN
            EXECUTE format('ALTER TABLE establishment.%I ADD CONSTRAINT %I CHECK(start_date IS NULL OR end_date IS NULL OR end_date>start_date)',table_name,table_name||'_dates_check');
        END IF;
        IF NOT EXISTS(SELECT 1 FROM pg_constraint WHERE conrelid=format('establishment.%I',table_name)::regclass AND conname=table_name||'_known_periods_excl') THEN
            EXECUTE format('ALTER TABLE establishment.%I ADD CONSTRAINT %I EXCLUDE USING gist (%I WITH =, address_purpose_id WITH =, daterange(start_date,end_date,''[)'') WITH &&) WHERE (start_date IS NOT NULL AND end_date IS NOT NULL)',table_name,table_name||'_known_periods_excl',owner_column);
        END IF;
    END LOOP;
END $$;
CREATE UNIQUE INDEX IF NOT EXISTS legal_entity_address_one_current
    ON establishment.legal_entity_address(legal_entity_id,address_purpose_id) WHERE is_current;
CREATE UNIQUE INDEX IF NOT EXISTS organisation_group_address_one_current
    ON establishment.organisation_group_address(organisation_group_id,address_purpose_id) WHERE is_current;
