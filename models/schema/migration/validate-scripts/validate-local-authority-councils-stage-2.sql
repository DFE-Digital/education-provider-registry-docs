-- Stage 2b council identities and effective area periods. PostgreSQL, read-only.
-- Run the whole file in your target SQL editor. Counts describe the reviewed
-- complete 206-area council backfill; unknown dates remain null.
BEGIN ISOLATION LEVEL REPEATABLE READ READ ONLY;
DO $$
DECLARE
    require_complete_backfill boolean := true; -- Full-population completion gate.
    expected_periods integer := 207;
    expected_councils integer := 188;
    expected_mapped_areas integer := 206;
    missing bigint;
    kent uuid;
    expected_current integer:=175;
    event_periods integer;
BEGIN
    event_periods:=(SELECT count(*) FROM migration.council_reorganisation_lineage l
        JOIN migration.council_reorganisation e USING(event_id) WHERE e.status='applied' AND l.entity_kind='council_period' AND l.action='created');
    expected_periods:=expected_periods+event_periods;
    expected_mapped_areas:=expected_mapped_areas+(SELECT count(DISTINCT l.entity_id) FROM migration.council_reorganisation_lineage l
        JOIN migration.council_reorganisation e USING(event_id) WHERE e.status='applied' AND l.entity_kind='local_authority_area' AND l.action='created');
    expected_councils:=expected_councils+(SELECT count(DISTINCT l.entity_id) FROM migration.council_reorganisation_lineage l
        JOIN migration.council_reorganisation e USING(event_id) WHERE e.status='applied' AND l.entity_kind='legal_entity' AND l.action='council_added');
    expected_current:=expected_current+event_periods-(SELECT count(*) FROM migration.council_reorganisation_lineage l
        JOIN migration.council_reorganisation e USING(event_id) WHERE e.status='applied' AND l.entity_kind='council_period'
          AND l.action='changed' AND (l.before_row->>'is_current')::boolean);
    IF to_regclass('establishment.local_authority_area_council_period') IS NULL THEN
        RAISE EXCEPTION 'Stage 2: council-area periods table is missing';
    END IF;
    IF (SELECT count(*) FROM establishment.local_authority_area_council_period) <> expected_periods
       OR (SELECT count(DISTINCT legal_entity_id) FROM establishment.local_authority_area_council_period) <> expected_councils
       OR (SELECT count(DISTINCT local_authority_area_id) FROM establishment.local_authority_area_council_period) <> expected_mapped_areas THEN
        RAISE EXCEPTION 'Stage 2: council, period or mapped-area counts differ from the reviewed fixture';
    END IF;
    IF EXISTS (
        SELECT 1 FROM establishment.local_authority_area_council_period p
        JOIN establishment.legal_entity c USING(legal_entity_id)
        WHERE c.legal_entity_type_id IS DISTINCT FROM 9
    ) THEN RAISE EXCEPTION 'Stage 2: a council holder is not a Public body'; END IF;
    IF EXISTS (
        SELECT 1 FROM establishment.local_authority_area_council_period p
        JOIN establishment.local_authority_area_council_period q
        ON p.local_authority_area_id=q.local_authority_area_id
           AND p.local_authority_area_council_period_id<q.local_authority_area_council_period_id
        WHERE p.start_date IS NOT NULL AND p.end_date IS NOT NULL
          AND q.start_date IS NOT NULL AND q.end_date IS NOT NULL
          AND daterange(p.start_date,p.end_date,'[)') && daterange(q.start_date,q.end_date,'[)')
    ) THEN RAISE EXCEPTION 'Stage 2: fully known council periods overlap'; END IF;
    IF EXISTS (SELECT local_authority_area_id FROM establishment.local_authority_area_council_period
               WHERE is_current GROUP BY 1 HAVING count(*)>1) THEN
        RAISE EXCEPTION 'Stage 2: multiple current councils for one area';
    END IF;
    -- Baseline examples apply before reviewed events change their effective facts.
    IF NOT EXISTS(SELECT 1 FROM migration.council_reorganisation WHERE status='applied') THEN
    SELECT p.legal_entity_id INTO STRICT kent FROM establishment.local_authority_area_council_period p
    JOIN establishment.local_authority_area a USING(local_authority_area_id)
    WHERE a.code=886 AND p.is_current AND p.start_date=DATE '1998-04-01';
    IF NOT EXISTS (SELECT 1 FROM establishment.local_authority_area_council_period p
                   JOIN establishment.local_authority_area a USING(local_authority_area_id)
                   WHERE a.code=922 AND p.legal_entity_id=kent AND NOT p.is_current
                     AND p.start_date IS NULL AND p.end_date=DATE '1998-04-01') THEN
        RAISE EXCEPTION 'Stage 2: Kent identity was not reused across both area codes';
    END IF;
    IF (SELECT count(DISTINCT p.legal_entity_id) FROM establishment.local_authority_area_council_period p
         JOIN establishment.local_authority_area a USING(local_authority_area_id) WHERE a.code=825)<>2
       OR NOT EXISTS (SELECT 1 FROM establishment.local_authority_area_council_period p
                      JOIN establishment.local_authority_area a USING(local_authority_area_id)
                      WHERE a.code=825 AND p.is_current AND p.start_date=DATE '2020-04-01') THEN
        RAISE EXCEPTION 'Stage 2: Buckinghamshire succession was not preserved';
    END IF;
    IF NOT EXISTS (SELECT 1 FROM establishment.local_authority_area_council_period p
                   JOIN establishment.local_authority_area a USING(local_authority_area_id)
                   WHERE a.code=681 AND p.is_current AND p.start_date IS NULL AND p.end_date IS NULL)
       OR (SELECT count(*) FROM establishment.local_authority_area_council_period p
            JOIN establishment.local_authority_area a USING(local_authority_area_id)
            WHERE a.code IN (940,941) AND p.is_current AND p.start_date=DATE '2021-04-01')<>2 THEN
        RAISE EXCEPTION 'Stage 2: Welsh unknown dates or Northants effective dates are incorrect';
    END IF;
    END IF;
    SELECT count(*) INTO missing FROM establishment.local_authority_area a
    WHERE NOT EXISTS (SELECT 1 FROM establishment.local_authority_area_council_period p
                       WHERE p.local_authority_area_id=a.local_authority_area_id);
    IF require_complete_backfill AND missing>0 THEN
        RAISE EXCEPTION 'Council backfill incomplete: % areas need review',missing;
    END IF;
    IF (SELECT count(*) FROM establishment.local_authority_area_council_period WHERE is_current)<>expected_current
       OR EXISTS (SELECT 1 FROM establishment.local_authority_area a
                  LEFT JOIN establishment.local_authority_area_council_period p USING(local_authority_area_id)
                  WHERE NOT EXISTS(SELECT 1 FROM migration.council_reorganisation_lineage line
                                   JOIN migration.council_reorganisation ce USING(event_id)
                                   WHERE ce.status='applied' AND line.entity_kind='council_period'
                                     AND (line.after_row->>'local_authority_area_id')::uuid=a.local_authority_area_id)
                  GROUP BY a.local_authority_area_id,a.name
                  HAVING count(*) FILTER (WHERE p.is_current)<>
                      CASE WHEN a.name ~ '^Pre[- ]LGR' THEN 0 ELSE 1 END)
    THEN RAISE EXCEPTION 'Stage 2b: current versus historical area coverage is incorrect'; END IF;
    IF NOT EXISTS(SELECT 1 FROM migration.council_reorganisation WHERE status='applied') AND EXISTS (SELECT 1 FROM (VALUES (927,815),(912,835),(906,875)) AS expected(old_code,current_code)
               JOIN establishment.local_authority_area a ON a.code=expected.old_code
               JOIN establishment.local_authority_area b ON b.code=expected.current_code
               JOIN establishment.local_authority_area_council_period p ON p.local_authority_area_id=a.local_authority_area_id
               JOIN establishment.local_authority_area_council_period q ON q.local_authority_area_id=b.local_authority_area_id
               WHERE p.legal_entity_id<>q.legal_entity_id)
    THEN RAISE EXCEPTION 'Stage 2b: historical council identity reuse failed'; END IF;
END $$;

SELECT 'PASS: Stage 2b council migration; all areas mapped, including reviewed event additions' AS validation_result,
       count(*) FILTER (WHERE p.local_authority_area_id IS NOT NULL) AS mapped_areas,
       count(*) FILTER (WHERE p.local_authority_area_id IS NULL) AS areas_needing_review
FROM establishment.local_authority_area a
LEFT JOIN (SELECT DISTINCT local_authority_area_id FROM establishment.local_authority_area_council_period) p
USING(local_authority_area_id);

SELECT a.code,a.name AS area,c.name AS council,t.name AS legal_form,
       p.start_date,p.end_date,p.is_current
FROM establishment.local_authority_area_council_period p
JOIN establishment.local_authority_area a USING(local_authority_area_id)
JOIN establishment.legal_entity c USING(legal_entity_id)
JOIN establishment.legal_entity_type t USING(legal_entity_type_id)
ORDER BY a.code,p.start_date NULLS FIRST;

-- A school's current geographic area does not prove its historical council.
SELECT e.urn,e.name,a.code AS area_code,c.name AS current_area_council
FROM establishment.establishment e
JOIN establishment.establishment_geography g USING(establishment_id)
JOIN establishment.local_authority_area a USING(local_authority_area_id)
LEFT JOIN establishment.local_authority_area_council_period p
  ON p.local_authority_area_id=a.local_authority_area_id AND p.is_current
LEFT JOIN establishment.legal_entity c ON c.legal_entity_id=p.legal_entity_id
ORDER BY e.urn;

SELECT a.code,a.name,'Pending council identity and effective-period review' AS review_action
FROM establishment.local_authority_area a WHERE NOT EXISTS (
    SELECT 1 FROM establishment.local_authority_area_council_period p
    WHERE p.local_authority_area_id=a.local_authority_area_id)
ORDER BY a.code;
COMMIT;
