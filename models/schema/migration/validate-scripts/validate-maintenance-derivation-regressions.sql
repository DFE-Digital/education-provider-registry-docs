-- Behavioural regressions. Synthetic schools and changes always roll back.
BEGIN;
CREATE FUNCTION pg_temp.maintenance_observation(test_urn integer,test_area integer,test_type integer,
    test_status integer,opened date,closed date,observed date)
RETURNS uuid LANGUAGE plpgsql AS $$
DECLARE school uuid;run_id uuid;snapshot_id uuid;record_id uuid;type_name text;
BEGIN
    INSERT INTO establishment.establishment(urn,name,establishment_type_id)
    VALUES(test_urn,'TEST ONLY maintenance',test_type)
    ON CONFLICT(urn) DO UPDATE SET establishment_type_id=EXCLUDED.establishment_type_id
    RETURNING establishment_id INTO school;
    INSERT INTO establishment.establishment_lifecycle(establishment_id,establishment_status_id,open_date,close_date)
    VALUES(school,test_status,opened,closed) ON CONFLICT(establishment_id)
    DO UPDATE SET establishment_status_id=EXCLUDED.establishment_status_id,open_date=EXCLUDED.open_date,close_date=EXCLUDED.close_date;
    INSERT INTO establishment.establishment_geography(establishment_id,local_authority_area_id)
    SELECT school,local_authority_area_id FROM establishment.local_authority_area WHERE code=test_area
    ON CONFLICT(establishment_id) DO UPDATE SET local_authority_area_id=EXCLUDED.local_authority_area_id;
    SELECT name INTO type_name FROM establishment.establishment_type WHERE establishment_type_id=test_type;
    INSERT INTO migration.migration_run(run_type,source_system,status) VALUES('TEST ONLY','TEST ONLY','completed')
    RETURNING migration_run_id INTO run_id;
    INSERT INTO migration.source_snapshot(migration_run_id,source_system,snapshot_date)
    VALUES(run_id,'TEST ONLY',observed) RETURNING source_snapshot_id INTO snapshot_id;
    INSERT INTO migration.source_record(source_snapshot_id,source_table,source_key,source_urn)
    VALUES(snapshot_id,'Establishment',test_urn::text,test_urn) RETURNING source_record_id INTO record_id;
    INSERT INTO migration.maintenance_source_observation(source_record_id,establishment_id,area_code,
        source_type_name,source_status_code,open_date,close_date)
    VALUES(record_id,school,test_area,type_name,test_status,opened,closed);
    PERFORM migration.derive_maintenance(snapshot_id);
    RETURN snapshot_id;
END $$;

DO $$
DECLARE snapshot_id uuid;school uuid;responsibility uuid;council uuid;company uuid;unlinked uuid;person uuid;type_id integer;
BEGIN
    FOR type_id IN SELECT unnest(ARRAY[1,2,3,9,10,11,12,13]) LOOP
        PERFORM pg_temp.maintenance_observation(999100+type_id,202,type_id,1,NULL,NULL,'2026-11-02');
        IF (SELECT count(*) FROM establishment.establishment_responsibility r
            JOIN establishment.establishment e USING(establishment_id)
            WHERE e.urn=999100+type_id AND r.is_current AND r.responsibility_type_id=5)<>1 THEN
            RAISE EXCEPTION 'Maintained-school type % was omitted',type_id;
        END IF;
    END LOOP;
    PERFORM pg_temp.maintenance_observation(999011,202,1,3,NULL,'2027-01-01','2026-11-02');
    IF NOT EXISTS(SELECT 1 FROM establishment.establishment_responsibility r
                  JOIN establishment.establishment e USING(establishment_id)
                  WHERE e.urn=999011 AND r.is_current AND r.end_date IS NULL) THEN
        RAISE EXCEPTION 'Unexecuted proposed closure changed current maintenance early';
    END IF;
    snapshot_id:=pg_temp.maintenance_observation(999001,940,1,1,'1990-01-01',NULL,'2026-11-02');
    SELECT r.establishment_responsibility_id INTO STRICT responsibility
    FROM establishment.establishment_responsibility r JOIN establishment.establishment e USING(establishment_id)
    WHERE e.urn=999001 AND r.start_date='2021-04-01' AND r.is_current;
    PERFORM migration.derive_maintenance(snapshot_id);
    PERFORM pg_temp.maintenance_observation(999001,940,1,1,'1990-01-01',NULL,'2026-11-03');
    PERFORM pg_temp.maintenance_observation(999001,940,1,1,'1990-01-01',NULL,'2026-10-01');
    IF (SELECT count(*) FROM establishment.establishment_responsibility r JOIN establishment.establishment e USING(establishment_id)
        WHERE e.urn=999001)<>1 OR NOT EXISTS(SELECT 1 FROM establishment.establishment_responsibility
        WHERE establishment_responsibility_id=responsibility AND first_observed_date='2026-10-01') THEN
        RAISE EXCEPTION 'Shadow effective date, identity reuse or earliest observation regression';
    END IF;
    PERFORM pg_temp.maintenance_observation(999002,202,1,1,NULL,NULL,'2026-11-02');
    IF NOT EXISTS(SELECT 1 FROM establishment.establishment_responsibility r JOIN establishment.establishment e USING(establishment_id)
                   WHERE e.urn=999002 AND r.start_date IS NULL AND r.is_current) THEN
        RAISE EXCEPTION 'Unknown start was invented';
    END IF;
    PERFORM pg_temp.maintenance_observation(999003,901,1,2,NULL,'1995-06-01','2026-11-02');
    IF NOT EXISTS(SELECT 1 FROM establishment.establishment_responsibility r JOIN establishment.establishment e USING(establishment_id)
                   JOIN establishment.legal_entity c USING(legal_entity_id)
                   WHERE e.urn=999003 AND NOT r.is_current AND r.end_date='1995-06-01' AND r.end_date_basis='inferred'
                     AND c.dissolution_date='1996-04-01' AND r.first_observed_date>r.end_date) THEN
        RAISE EXCEPTION 'Reconstructed closed-school maintenance was lost or observation time was confused with effective time';
    END IF;
    PERFORM pg_temp.maintenance_observation(999004,681,1,1,NULL,NULL,'2026-11-02');
    IF EXISTS(SELECT 1 FROM establishment.establishment_responsibility r JOIN establishment.establishment e USING(establishment_id)
              WHERE e.urn=999004) OR NOT EXISTS(SELECT 1 FROM migration.maintenance_source_observation o
              JOIN establishment.establishment e USING(establishment_id) WHERE e.urn=999004 AND processing_status='welsh_excluded') THEN
        RAISE EXCEPTION 'Welsh English-type exception was not excluded and staged';
    END IF;
    PERFORM pg_temp.maintenance_observation(999005,825,1,2,'1990-01-01','2022-01-01','2026-11-02');
    IF (SELECT count(*) FROM establishment.establishment_responsibility r JOIN establishment.establishment e USING(establishment_id)
        WHERE e.urn=999005 AND NOT r.is_current)<>2 THEN RAISE EXCEPTION 'Retained-code council history was not reconstructed'; END IF;
    PERFORM pg_temp.maintenance_observation(999005,825,4,2,'1990-01-01','2022-01-01','2026-11-03');
    IF (SELECT count(*) FROM establishment.establishment_responsibility r JOIN establishment.establishment e USING(establishment_id)
        WHERE e.urn=999005 AND NOT r.is_current)<>2 THEN RAISE EXCEPTION 'Current academy classification erased supported maintenance history'; END IF;
    PERFORM pg_temp.maintenance_observation(999006,940,1,2,'1990-01-01','2020-01-01','2026-11-02');
    IF EXISTS(SELECT 1 FROM establishment.establishment_responsibility r JOIN establishment.establishment e USING(establishment_id)
              WHERE e.urn=999006) THEN RAISE EXCEPTION 'Empty council-school intersection became maintenance'; END IF;
    PERFORM pg_temp.maintenance_observation(999007,940,1,1,'2030-01-01',NULL,'2026-11-02');
    IF NOT EXISTS(SELECT 1 FROM migration.maintenance_source_observation o JOIN establishment.establishment e USING(establishment_id)
                   WHERE e.urn=999007 AND processing_status='review') THEN RAISE EXCEPTION 'Contradictory future opening was accepted'; END IF;
    PERFORM pg_temp.maintenance_observation(999008,825,1,2,'1990-01-01','2020-04-01','2026-11-02');
    IF NOT EXISTS(SELECT 1 FROM establishment.establishment_responsibility r JOIN establishment.establishment e USING(establishment_id)
                   JOIN migration.maintenance_derivation d USING(establishment_responsibility_id)
                   WHERE e.urn=999008 AND r.end_date_basis='inferred'
                     AND d.accepted_inputs->>'school_close'='2020-04-01'
                     AND d.accepted_inputs->>'council_effective_end'='2020-04-01') THEN
        RAISE EXCEPTION 'Tied closure and council-transfer evidence was lost';
    END IF;
    PERFORM pg_temp.maintenance_observation(999009,940,1,1,NULL,NULL,NULL);
    IF NOT EXISTS(SELECT 1 FROM migration.maintenance_source_observation o JOIN establishment.establishment e USING(establishment_id)
                   WHERE e.urn=999009 AND processing_status='review') THEN RAISE EXCEPTION 'Missing observation date was replaced by a load date'; END IF;
    INSERT INTO establishment.local_authority_area(code,name,local_authority_jurisdiction_id)
    VALUES(998,'TEST ONLY formed council area',1);
    INSERT INTO establishment.legal_entity(name,legal_entity_type_id,incorporation_date)
    VALUES('TEST ONLY formed council',9,'2020-01-01') RETURNING legal_entity_id INTO council;
    INSERT INTO establishment.local_authority_area_council_period(local_authority_area_id,legal_entity_id,is_current)
    SELECT local_authority_area_id,council,true FROM establishment.local_authority_area WHERE code=998;
    PERFORM pg_temp.maintenance_observation(999010,998,1,1,'1990-01-01',NULL,'2026-11-02');
    IF NOT EXISTS(SELECT 1 FROM migration.maintenance_source_observation o JOIN establishment.establishment e USING(establishment_id)
                   WHERE e.urn=999010 AND processing_status='review') THEN RAISE EXCEPTION 'Period before council formation was accepted'; END IF;
    PERFORM pg_temp.maintenance_observation(999001,940,1,1,'2022-01-01',NULL,'2026-11-04');
    IF NOT EXISTS(SELECT 1 FROM migration.maintenance_source_observation o JOIN establishment.establishment e USING(establishment_id)
                   WHERE e.urn=999001 AND processing_status='review') OR NOT EXISTS(
                   SELECT 1 FROM establishment.establishment_responsibility WHERE establishment_responsibility_id=responsibility AND start_date='2021-04-01') THEN
        RAISE EXCEPTION 'Changed boundary silently rewrote an accepted derivation';
    END IF;
    SELECT establishment_id INTO school FROM establishment.establishment WHERE urn=999001;
    SELECT legal_entity_id INTO council FROM establishment.local_authority_area_council_period p
    JOIN establishment.local_authority_area a USING(local_authority_area_id) WHERE a.code=886 AND p.is_current;
    BEGIN
        INSERT INTO establishment.establishment_responsibility(establishment_id,legal_entity_id,responsibility_type_id,is_current)
        VALUES(school,council,5,true);
        RAISE EXCEPTION 'Duplicate current maintenance accepted';
    EXCEPTION WHEN unique_violation THEN NULL; END;
    SELECT establishment_id INTO school FROM establishment.establishment WHERE urn=999005;
    BEGIN
        INSERT INTO establishment.establishment_responsibility(establishment_id,legal_entity_id,responsibility_type_id,start_date,end_date)
        VALUES(school,council,5,'1991-01-01','1992-01-01');
        RAISE EXCEPTION 'Overlapping known maintenance accepted';
    EXCEPTION WHEN exclusion_violation THEN NULL; END;
    INSERT INTO establishment.legal_entity(name,legal_entity_type_id) VALUES('TEST ONLY invalid maintainer',3) RETURNING legal_entity_id INTO company;
    BEGIN
        INSERT INTO establishment.establishment_responsibility(establishment_id,legal_entity_id,responsibility_type_id)
        VALUES(school,company,5);
        RAISE EXCEPTION 'Company maintenance holder accepted';
    EXCEPTION WHEN check_violation THEN NULL; END;
    INSERT INTO establishment.legal_entity(name,legal_entity_type_id) VALUES('TEST ONLY unlinked council',9) RETURNING legal_entity_id INTO unlinked;
    BEGIN
        INSERT INTO establishment.establishment_responsibility(establishment_id,legal_entity_id,responsibility_type_id)
        VALUES(school,unlinked,5);
        SET CONSTRAINTS establishment.check_maintenance_area_link IMMEDIATE;
        RAISE EXCEPTION 'Unlinked Public body maintenance holder accepted';
    EXCEPTION WHEN check_violation THEN NULL; END;
    INSERT INTO establishment.person DEFAULT VALUES RETURNING person_id INTO person;
    BEGIN
        INSERT INTO establishment.establishment_responsibility(establishment_id,person_id,responsibility_type_id)
        VALUES(school,person,4);
        RAISE EXCEPTION 'Person-held proprietor accepted';
    EXCEPTION WHEN check_violation THEN NULL; END;
END $$;
ROLLBACK;
SELECT 'PASS: maintenance history, dates, provenance, repeat imports, Welsh exclusions and holder/period guards' AS result;
