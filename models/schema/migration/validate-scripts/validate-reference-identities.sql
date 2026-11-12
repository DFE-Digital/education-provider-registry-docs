-- Read-only checks for the independently generated integer lookup identities.
DO $$ DECLARE r record; n bigint; first_id bigint; last_id bigint; seq record; BEGIN
FOR r IN SELECT c.table_name,c.column_name FROM information_schema.columns c
 WHERE c.table_schema='establishment' AND c.is_identity='YES' LOOP
    EXECUTE format('SELECT count(*),min(%I),max(%I) FROM establishment.%I',r.column_name,r.column_name,r.table_name)
      INTO n,first_id,last_id;
    IF n>0 AND (first_id<>1 OR last_id<>n) THEN RAISE EXCEPTION '% initial IDs must be consecutive from 1',r.table_name; END IF;
    SELECT * INTO seq FROM pg_sequences WHERE schemaname='establishment'
      AND sequencename=split_part(pg_get_serial_sequence('establishment.'||r.table_name,r.column_name),'.',2);
    IF seq.start_value<>1 OR seq.increment_by<>1 OR (seq.last_value IS NOT NULL AND seq.last_value<last_id) THEN
      RAISE EXCEPTION '% identity sequence is missing, misconfigured or behind its data',r.table_name;
    END IF;
END LOOP;
IF (SELECT count(*) FROM information_schema.columns WHERE table_schema='establishment' AND is_identity='YES')<>19 THEN
    RAISE EXCEPTION 'Expected 19 independent integer lookup identity sequences';
END IF;
IF NOT EXISTS(SELECT 1 FROM establishment.establishment_type_category WHERE establishment_type_category_id=8 AND code=10 AND name='Academies') THEN
    RAISE EXCEPTION 'Academies must resolve via BAU code 10, independently of internal ID 8';
END IF;
END $$;
