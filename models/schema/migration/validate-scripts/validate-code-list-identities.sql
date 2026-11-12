-- Reference-key and BAU-code regressions. Test writes roll back.
BEGIN;
DO $$
DECLARE expected record;
BEGIN
IF EXISTS (
    SELECT 1 FROM (VALUES
        ('establishment_status','establishment_status_id'),
        ('education_phase','education_phase_id'),
        ('establishment_type_category','establishment_type_category_id'),
        ('establishment_type','establishment_type_id'),
        ('reason_establishment_opened','reason_establishment_opened_id'),
        ('reason_establishment_closed','reason_establishment_closed_id'),
        ('urban_rural','id')) expected_column(table_name,column_name)
    LEFT JOIN information_schema.columns c ON c.table_schema='establishment'
      AND c.table_name=expected_column.table_name AND c.column_name=expected_column.column_name
    WHERE c.data_type IS DISTINCT FROM 'integer' OR c.ordinal_position<>1
) THEN RAISE EXCEPTION 'A bounded reference table lacks its first-column integer key'; END IF;

FOR expected IN SELECT * FROM (VALUES
    (1,'Open'),(2,'Closed'),(3,'Open, but proposed to close'),(4,'Proposed to open')) v(code,name)
LOOP
    IF NOT EXISTS (SELECT 1 FROM establishment.establishment_status
                   WHERE establishment_status_id=expected.code AND name=expected.name)
    THEN RAISE EXCEPTION 'Missing establishment status %',expected; END IF;
END LOOP;

FOR expected IN SELECT * FROM (VALUES
    (1,'Nursery'),(2,'Primary'),(3,'Middle deemed primary'),(4,'Secondary'),
    (5,'Middle deemed secondary'),(6,'16 plus'),(7,'All-through')) v(code,name)
LOOP
    IF NOT EXISTS (SELECT 1 FROM establishment.education_phase
                   WHERE education_phase_id=expected.code AND name=expected.name)
    THEN RAISE EXCEPTION 'Missing education phase %',expected; END IF;
END LOOP;

IF EXISTS (SELECT 1 FROM establishment.reason_establishment_opened
           WHERE reason_establishment_opened_id<>code::integer)
   OR EXISTS (SELECT 1 FROM establishment.reason_establishment_closed
              WHERE reason_establishment_closed_id<>code::integer)
THEN RAISE EXCEPTION 'Reason integer keys and leading-zero BAU codes disagree'; END IF;

IF EXISTS (SELECT 1 FROM establishment.establishment_type
           WHERE establishment_type_id<>code::integer)
THEN RAISE EXCEPTION 'Establishment type integer keys and BAU codes disagree'; END IF;

FOR expected IN SELECT * FROM (VALUES
    (1,'Colleges'),(2,'Universities'),(3,'Independent schools'),
    (4,'Local authority maintained schools'),(5,'Special schools'),(6,'Welsh schools'),
    (9,'Other types'),(10,'Academies'),(11,'Free Schools'),
    (12,'Children''s Centres'),(13,'Online provider')) v(code,name)
LOOP
    IF NOT EXISTS (SELECT 1 FROM establishment.establishment_type_category
                   WHERE establishment_type_category_id=expected.code AND name=expected.name)
    THEN RAISE EXCEPTION 'Missing establishment type category %',expected; END IF;
END LOOP;

IF (SELECT jsonb_object_agg(gender_of_entry_type_id,name) FROM establishment.gender_of_entry_type)
   IS DISTINCT FROM '{"1":"Boys","2":"Girls","3":"Mixed"}'::jsonb
THEN RAISE EXCEPTION 'Gender keys do not match BAU codes'; END IF;
IF (SELECT jsonb_object_agg(admissions_policy_id,name) FROM establishment.admissions_policy)
   IS DISTINCT FROM '{"2":"Selective","4":"Non-selective"}'::jsonb
THEN RAISE EXCEPTION 'Admissions-policy keys do not match BAU codes'; END IF;
IF (SELECT count(*) FROM establishment.boarding_provision)<>4
THEN RAISE EXCEPTION 'Boarding-provision BAU code list is incomplete'; END IF;

BEGIN UPDATE establishment.establishment SET education_phase_id=-1;
    RAISE EXCEPTION 'Invalid education phase accepted'; EXCEPTION WHEN foreign_key_violation THEN NULL; END;
BEGIN UPDATE establishment.establishment_lifecycle SET establishment_status_id=-1;
    RAISE EXCEPTION 'Invalid status accepted'; EXCEPTION WHEN foreign_key_violation THEN NULL; END;
END $$;
ROLLBACK;
SELECT 'PASS: reference keys preserve BAU values and foreign keys' AS result;
