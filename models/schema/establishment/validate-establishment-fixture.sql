-- Shared target validation for both local rebuild paths.
-- The local fixture contract requires every physical table to contain data.
DO $$
DECLARE
    r record;
    n bigint;
BEGIN
    FOR r IN
        SELECT table_name
        FROM information_schema.tables
        WHERE table_schema = 'establishment'
          AND table_type = 'BASE TABLE'
        ORDER BY table_name
    LOOP
        EXECUTE format('SELECT count(*) FROM establishment.%I', r.table_name) INTO n;
        IF n = 0 THEN
            RAISE EXCEPTION 'Required establishment table is empty: %', r.table_name;
        END IF;
    END LOOP;
END
$$;

SELECT table_name,
       ((xpath('/table/row/c/text()', query_to_xml(
           format('SELECT count(*) AS c FROM establishment.%I', table_name),
           true, false, '')))[1]::text)::bigint AS row_count
FROM information_schema.tables
WHERE table_schema = 'establishment'
  AND table_type = 'BASE TABLE'
ORDER BY table_name;
