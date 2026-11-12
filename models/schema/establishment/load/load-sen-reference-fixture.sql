BEGIN;
CREATE TEMP TABLE source_sen_reference (
    code text PRIMARY KEY,
    name text NOT NULL,
    archived integer
) ON COMMIT DROP;
\copy source_sen_reference FROM '__FIXTURE_PATH__' WITH (FORMAT csv, HEADER true, DELIMITER '|', NULL 'NULL')

DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM source_sen_reference WHERE archived NOT IN (0, 1)) THEN
        RAISE EXCEPTION 'Unexpected SEN source archive flag';
    END IF;
    IF EXISTS(SELECT 1 FROM source_sen_reference WHERE code !~ '^[0-9]{2}$') THEN
        RAISE EXCEPTION 'Unexpected SEN source code format';
    END IF;
END $$;
INSERT INTO establishment.sen(code,name)
SELECT code,name FROM source_sen_reference s WHERE (archived IS NULL OR archived=0) AND code<>'00'
AND NOT EXISTS(SELECT 1 FROM establishment.sen t WHERE t.code=s.code) ORDER BY code
ON CONFLICT(code) DO UPDATE SET name=excluded.name;
UPDATE establishment.sen t SET name=s.name FROM source_sen_reference s
WHERE t.code=s.code AND (s.archived IS NULL OR s.archived=0) AND s.code<>'00';
DELETE FROM establishment.establishment_sen WHERE sen_id IN(SELECT sen_id FROM establishment.sen WHERE code='00');
DELETE FROM establishment.sen t WHERE NOT EXISTS(SELECT 1 FROM source_sen_reference s
    WHERE s.code=t.code AND (s.archived IS NULL OR s.archived=0) AND s.code<>'00');
DO $$ BEGIN
    IF EXISTS (
        (SELECT code, name FROM source_sen_reference WHERE (archived IS NULL OR archived = 0) AND code<>'00'
         EXCEPT SELECT code, name FROM establishment.sen)
        UNION ALL
        (SELECT code, name FROM establishment.sen
         EXCEPT SELECT code, name FROM source_sen_reference WHERE (archived IS NULL OR archived = 0) AND code<>'00')
    ) THEN
        RAISE EXCEPTION 'Current SEN source dictionary differs from the imported target mapping';
    END IF;
END $$;
SELECT count(*) FILTER (WHERE (archived IS NULL OR archived = 0) AND code<>'00') AS included_sen_values,
       count(*) FILTER (WHERE archived = 1) AS excluded_archived_sen_values
FROM source_sen_reference;
DROP TABLE source_sen_reference;
COMMIT;
