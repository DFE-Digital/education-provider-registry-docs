DO $$ DECLARE r record; last_id bigint; BEGIN
FOR r IN SELECT table_name,column_name FROM information_schema.columns
    WHERE table_schema='establishment' AND is_identity='YES' LOOP
    EXECUTE format('SELECT max(%I) FROM establishment.%I',r.column_name,r.table_name) INTO last_id;
    PERFORM setval(pg_get_serial_sequence('establishment.'||r.table_name,r.column_name),coalesce(last_id,1),last_id IS NOT NULL);
END LOOP; END $$;