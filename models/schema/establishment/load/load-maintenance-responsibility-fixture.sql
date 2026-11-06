BEGIN;
CREATE TEMP TABLE source_maintenance_fixture (
    urn integer PRIMARY KEY,area_code integer,source_type_name text,source_status_code integer,
    open_date date,close_date date,observed_date date
) ON COMMIT DROP;
\copy source_maintenance_fixture FROM '__FIXTURE_PATH__' WITH (FORMAT csv,HEADER true,DELIMITER '|',NULL 'NULL',ENCODING 'UTF8')

SELECT pg_advisory_xact_lock(hashtextextended('maintenance-import/__SOURCE_DATABASE__/__EXTRACT_SHA256__',0));
DO $$
DECLARE snapshot_id uuid;run_id uuid;observed_on date;
BEGIN
    IF (SELECT count(DISTINCT observed_date) FROM source_maintenance_fixture)<>1
       OR EXISTS(SELECT 1 FROM source_maintenance_fixture WHERE observed_date IS NULL)
       OR EXISTS(SELECT 1 FROM source_maintenance_fixture s LEFT JOIN establishment.establishment e USING(urn)
                 WHERE e.establishment_id IS NULL) THEN
        RAISE EXCEPTION 'Maintenance extract has unknown observations or establishments';
    END IF;
    SELECT min(observed_date) INTO observed_on FROM source_maintenance_fixture;
    SELECT source_snapshot_id INTO snapshot_id FROM migration.source_snapshot
    WHERE source_system='GIAS BAU local observation' AND source_database='__SOURCE_DATABASE__'
      AND extract_name='maintenance/__EXTRACT_SHA256__' AND snapshot_date=observed_on;
    IF snapshot_id IS NULL THEN
        INSERT INTO migration.migration_run(run_type,source_system,source_database,source_snapshot_date,status,transform_version,notes)
        VALUES('maintenance-derivation','GIAS BAU local observation','__SOURCE_DATABASE__',observed_on,'completed','maintenance-v1',
               'Observation date captured by the source query; original restored-data publication date is unknown')
        RETURNING migration_run_id INTO run_id;
        INSERT INTO migration.source_snapshot(migration_run_id,source_system,source_database,snapshot_date,extract_name)
        VALUES(run_id,'GIAS BAU local observation','__SOURCE_DATABASE__',observed_on,'maintenance/__EXTRACT_SHA256__')
        RETURNING source_snapshot_id INTO snapshot_id;
    END IF;
    INSERT INTO migration.source_record(source_snapshot_id,source_table,source_key,source_urn,source_row_hash)
    SELECT snapshot_id,'Establishment',urn::text,urn,encode(public.digest(to_jsonb(s)::text,'sha256'),'hex')
    FROM source_maintenance_fixture s ON CONFLICT DO NOTHING;
    IF EXISTS(SELECT 1 FROM source_maintenance_fixture s JOIN migration.source_record sr
              ON sr.source_snapshot_id=snapshot_id AND sr.source_table='Establishment' AND sr.source_key=s.urn::text
              WHERE sr.source_row_hash IS DISTINCT FROM encode(public.digest(to_jsonb(s)::text,'sha256'),'hex')) THEN
        RAISE EXCEPTION 'Maintenance source identity reused with different inputs';
    END IF;
    INSERT INTO migration.maintenance_source_observation(source_record_id,establishment_id,area_code,
        source_type_name,source_status_code,open_date,close_date)
    SELECT sr.source_record_id,e.establishment_id,s.area_code,s.source_type_name,s.source_status_code,s.open_date,s.close_date
    FROM source_maintenance_fixture s JOIN establishment.establishment e USING(urn)
    JOIN migration.source_record sr ON sr.source_snapshot_id=snapshot_id
      AND sr.source_table='Establishment' AND sr.source_key=s.urn::text
    ON CONFLICT DO NOTHING;
    PERFORM migration.derive_maintenance(snapshot_id);
END $$;
SELECT processing_status,count(*) FROM migration.maintenance_source_observation GROUP BY 1 ORDER BY 1;
COMMIT;
