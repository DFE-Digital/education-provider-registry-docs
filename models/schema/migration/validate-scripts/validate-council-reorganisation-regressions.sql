-- Synthetic reviewed events and source replays. No changes survive rollback.
BEGIN;
DO $$
DECLARE area uuid:=gen_random_uuid(); welsh_area uuid:=gen_random_uuid(); old_council uuid:=gen_random_uuid(); new_council uuid:=gen_random_uuid();
    old_period uuid:=gen_random_uuid(); old_welsh_period uuid:=gen_random_uuid(); new_period uuid:=gen_random_uuid(); new_welsh_period uuid:=gen_random_uuid();
    area_x uuid:=gen_random_uuid();area_y uuid:=gen_random_uuid();period_x uuid:=gen_random_uuid();period_y uuid:=gen_random_uuid();
    council_x uuid:=gen_random_uuid(); council_y uuid:=gen_random_uuid(); run uuid; snapshot uuid; replay_snapshot uuid;
    event jsonb; split jsonb; source jsonb; raw jsonb; result text; school uuid; previous_observation date; before_count integer;
BEGIN
    INSERT INTO establishment.local_authority_area(local_authority_area_id,code,name,local_authority_jurisdiction_id)
    VALUES(area,999,'TEST ONLY old English area',1),(welsh_area,995,'TEST ONLY Welsh area',2);
    INSERT INTO establishment.legal_entity(legal_entity_id,name,legal_entity_type_id)
    VALUES(old_council,'TEST ONLY old council',9),(new_council,'TEST ONLY successor council',9);
    INSERT INTO establishment.local_authority_area_council_period(local_authority_area_council_period_id,
        local_authority_area_id,legal_entity_id,start_date,is_current)
    VALUES(old_period,area,old_council,'2010-01-01',true),(old_welsh_period,welsh_area,old_council,'2010-01-01',true);
    INSERT INTO establishment.establishment(urn,name,establishment_type_id)
    VALUES(999901,'TEST ONLY maintained',(SELECT establishment_type_id FROM establishment.establishment_type WHERE code='01')),(999902,'TEST ONLY academy',(SELECT establishment_type_id FROM establishment.establishment_type WHERE code='28')),(999903,'TEST ONLY closed',(SELECT establishment_type_id FROM establishment.establishment_type WHERE code='01')),
          (999904,'TEST ONLY independent',(SELECT establishment_type_id FROM establishment.establishment_type WHERE code='11')),(999905,'TEST ONLY Welsh maintained type',(SELECT establishment_type_id FROM establishment.establishment_type WHERE code='01'));
    INSERT INTO establishment.establishment_geography(establishment_id,local_authority_area_id)
    SELECT establishment_id,CASE WHEN urn=999905 THEN welsh_area ELSE area END
    FROM establishment.establishment WHERE urn BETWEEN 999901 AND 999905;
    INSERT INTO establishment.establishment_lifecycle(establishment_id,establishment_status_id,open_date,close_date)
    SELECT establishment_id,CASE WHEN urn=999903 THEN 2 ELSE 1 END,DATE '2010-01-01',
        CASE WHEN urn=999903 THEN DATE '2020-01-01' END FROM establishment.establishment WHERE urn BETWEEN 999901 AND 999905;
    INSERT INTO migration.migration_run(run_type,source_system,status) VALUES('TEST ONLY','TEST ONLY','running') RETURNING migration_run_id INTO run;
    INSERT INTO migration.source_snapshot(migration_run_id,source_system,snapshot_date)
    VALUES(run,'TEST ONLY','2026-06-16') RETURNING source_snapshot_id INTO snapshot;
    INSERT INTO migration.source_record(source_snapshot_id,source_table,source_key,source_urn)
    SELECT snapshot,'Establishment',urn::text,urn FROM establishment.establishment WHERE urn BETWEEN 999901 AND 999905;
    INSERT INTO migration.maintenance_source_observation(source_record_id,establishment_id,area_code,source_type_name,source_status_code,open_date,close_date)
    SELECT sr.source_record_id,e.establishment_id,CASE WHEN e.urn=999905 THEN 995 ELSE 999 END,t.name,status.establishment_status_id,l.open_date,l.close_date
    FROM migration.source_record sr JOIN establishment.establishment e ON e.urn=sr.source_urn
    JOIN establishment.establishment_type t USING(establishment_type_id) JOIN establishment.establishment_lifecycle l USING(establishment_id) JOIN establishment.establishment_status status USING(establishment_status_id)
    WHERE sr.source_snapshot_id=snapshot;
    PERFORM migration.derive_maintenance(snapshot);
    source:=jsonb_build_object('system','TEST ONLY reviewed source','table','TEST ONLY order','key','retained-event',
        'observedDate','2026-06-16','observedValues',jsonb_build_object('effectiveDate','2021-04-01'));
    event:=jsonb_build_object('eventId','TEST ONLY retained','reviewStatus','accepted','effectiveDate','2021-04-01',
        'evidence','TEST ONLY accepted synthetic transition','source',source,
        'oldPeriods',jsonb_build_array(jsonb_build_object('periodId',old_period,'expectedCouncilId',old_council),
                                    jsonb_build_object('periodId',old_welsh_period,'expectedCouncilId',old_council)),
        'successors',jsonb_build_array(jsonb_build_object('periodId',new_period,'areaId',area,'councilId',new_council),
                                     jsonb_build_object('periodId',new_welsh_period,'areaId',welsh_area,'councilId',new_council)));
    UPDATE establishment.legal_entity SET dissolution_date='2020-01-01' WHERE legal_entity_id=old_council;
    result:=migration.apply_council_reorganisation(event||'{"eventId":"TEST ONLY inconsistent lifetime"}'::jsonb);
    IF result<>'review' THEN RAISE EXCEPTION 'Contradictory previous-council lifetime was accepted'; END IF;
    UPDATE establishment.legal_entity SET dissolution_date=NULL WHERE legal_entity_id=old_council;
    result:=migration.apply_council_reorganisation(event);
    IF result<>'applied' THEN RAISE EXCEPTION 'Retained-code event was not applied: %',result; END IF;
    SELECT count(*) INTO before_count FROM migration.council_reorganisation_lineage;
    PERFORM migration.apply_council_reorganisation(event);
    IF (SELECT count(*) FROM migration.council_reorganisation_lineage)<>before_count THEN RAISE EXCEPTION 'Duplicate event changed its lineage'; END IF;
    BEGIN
        PERFORM migration.apply_council_reorganisation(event||'{"evidence":"different"}'::jsonb);
        RAISE EXCEPTION 'Conflicting event ID was accepted';
    EXCEPTION WHEN raise_exception THEN IF SQLERRM NOT LIKE 'Council event ID already%' THEN RAISE; END IF; END;
    IF EXISTS(SELECT 1 FROM establishment.establishment_responsibility r JOIN establishment.establishment e USING(establishment_id)
              WHERE e.urn IN(999902,999904,999905) AND r.responsibility_type_id=5) THEN
        RAISE EXCEPTION 'Academy, independent or Welsh school acquired maintenance';
    END IF;
    IF NOT EXISTS(SELECT 1 FROM establishment.establishment_responsibility r JOIN establishment.establishment e USING(establishment_id)
                   WHERE e.urn=999903 AND NOT r.is_current AND r.end_date='2020-01-01') THEN RAISE EXCEPTION 'Closed-school history was changed'; END IF;
    result:=migration.apply_council_reorganisation(event||jsonb_build_object('eventId','TEST ONLY future','effectiveDate',CURRENT_DATE+30));
    IF result<>'pending' THEN RAISE EXCEPTION 'Future event was applied early'; END IF;
    result:=migration.apply_council_reorganisation(event||'{"eventId":"TEST ONLY out-of-order","effectiveDate":"2020-01-01"}'::jsonb);
    IF result<>'review' THEN RAISE EXCEPTION 'Out-of-order transition was not staged'; END IF;
    split:=jsonb_build_object('eventId','TEST ONLY split','reviewStatus','accepted','effectiveDate','2024-04-01',
        'evidence','TEST ONLY accepted synthetic split','source',source,
        'oldPeriods',jsonb_build_array(jsonb_build_object('periodId',new_period,'expectedCouncilId',new_council)),
        'newCouncils',jsonb_build_array(jsonb_build_object('legalEntityId',council_x,'name','TEST ONLY split council X'),
                                     jsonb_build_object('legalEntityId',council_y,'name','TEST ONLY split council Y')),
        'newAreas',jsonb_build_array(jsonb_build_object('areaId',area_x,'code',997,'name','TEST ONLY new area X','jurisdictionId',1),
                                  jsonb_build_object('areaId',area_y,'code',996,'name','TEST ONLY new area Y','jurisdictionId',1)),
        'successors',jsonb_build_array(jsonb_build_object('periodId',period_x,'areaId',area_x,'councilId',council_x),
                                     jsonb_build_object('periodId',period_y,'areaId',area_y,'councilId',council_y)),
        'schoolMappings',jsonb_build_array(jsonb_build_object('urn',999901,'areaId',area_x),jsonb_build_object('urn',999902,'areaId',area_y),
            jsonb_build_object('urn',999903,'areaId',area_y),jsonb_build_object('urn',999904,'areaId',area_x)));
    BEGIN
        PERFORM migration.apply_council_reorganisation((split-'schoolMappings')||'{"eventId":"TEST ONLY missing mapping"}'::jsonb);
        RAISE EXCEPTION 'Split without reviewed school allocation was accepted';
    EXCEPTION WHEN raise_exception THEN IF SQLERRM NOT LIKE 'New-code splits%' THEN RAISE; END IF; END;
    BEGIN
        PERFORM migration.apply_council_reorganisation(jsonb_set(split||'{"eventId":"TEST ONLY atomic failure"}'::jsonb,'{successors,0,periodId}',to_jsonb(old_period)));
        RAISE EXCEPTION 'Duplicate target period ID was accepted';
    EXCEPTION WHEN unique_violation THEN NULL; END;
    IF EXISTS(SELECT 1 FROM migration.council_reorganisation WHERE event_id='TEST ONLY atomic failure')
       OR EXISTS(SELECT 1 FROM establishment.local_authority_area WHERE local_authority_area_id=area_x)
       OR NOT EXISTS(SELECT 1 FROM establishment.local_authority_area_council_period WHERE local_authority_area_council_period_id=new_period AND is_current) THEN
        RAISE EXCEPTION 'Failed split left partial ledger, area or period changes';
    END IF;
    result:=migration.apply_council_reorganisation(split);
    IF result<>'applied' THEN RAISE EXCEPTION 'Reviewed split was not applied'; END IF;
    IF NOT EXISTS(SELECT 1 FROM establishment.establishment_responsibility r JOIN establishment.establishment e USING(establishment_id)
                   JOIN establishment.establishment_geography g USING(establishment_id)
                   WHERE e.urn=999901 AND g.local_authority_area_id=area_x AND r.is_current AND r.legal_entity_id=council_x AND r.start_date='2024-04-01')
       OR (SELECT count(*) FROM establishment.establishment_responsibility r JOIN establishment.establishment e USING(establishment_id)
           WHERE e.urn=999901 AND r.responsibility_type_id=5)<>3 THEN
        RAISE EXCEPTION 'Split geography or maintenance history is incorrect';
    END IF;
    raw:=jsonb_build_object('local_authority_code',999,'establishment_type_id',(SELECT establishment_type_id FROM establishment.establishment_type WHERE code='01'),'status_code',1,'open_date','2010-01-01','close_date',NULL);
    IF migration.allow_establishment_replay(999901,'2020-01-01',raw)
       OR migration.allow_establishment_replay(999901,'2024-04-01',raw)
       OR migration.allow_establishment_replay(999901,'2026-06-16',raw) THEN RAISE EXCEPTION 'Source replay could undo event geography'; END IF;
    IF NOT EXISTS(SELECT 1 FROM migration.council_replay_observation WHERE event_id='TEST ONLY split' AND disposition='review')
       OR NOT EXISTS(SELECT 1 FROM migration.council_replay_observation WHERE event_id='TEST ONLY split' AND disposition='retained') THEN
        RAISE EXCEPTION 'Replay evidence or newer-conflict review is missing';
    END IF;
    INSERT INTO migration.source_snapshot(migration_run_id,source_system,snapshot_date)
    VALUES(run,'TEST ONLY older replay','2020-01-01') RETURNING source_snapshot_id INTO replay_snapshot;
    INSERT INTO migration.source_record(source_snapshot_id,source_table,source_key,source_urn)
    VALUES(replay_snapshot,'Establishment','999901',999901);
    INSERT INTO migration.maintenance_source_observation(source_record_id,establishment_id,area_code,source_type_name,source_status_code,open_date)
    SELECT sr.source_record_id,e.establishment_id,999,'Community school',1,'2010-01-01'
    FROM migration.source_record sr JOIN establishment.establishment e ON e.urn=sr.source_urn WHERE sr.source_snapshot_id=replay_snapshot;
    PERFORM migration.derive_maintenance(replay_snapshot);
    IF (SELECT count(*) FROM establishment.establishment_responsibility r JOIN establishment.establishment e USING(establishment_id) WHERE e.urn=999901)<>3
       OR NOT EXISTS(SELECT 1 FROM migration.maintenance_source_observation o JOIN migration.source_record sr USING(source_record_id)
                      WHERE sr.source_snapshot_id=replay_snapshot AND o.processing_status='accepted') THEN
        RAISE EXCEPTION 'Older maintenance replay duplicated or invalidated reviewed history';
    END IF;
    INSERT INTO migration.source_snapshot(migration_run_id,source_system,snapshot_date)
    VALUES(run,'TEST ONLY matching replay','2025-01-01') RETURNING source_snapshot_id INTO replay_snapshot;
    INSERT INTO migration.source_record(source_snapshot_id,source_table,source_key,source_urn) VALUES(replay_snapshot,'Establishment','999901',999901);
    INSERT INTO migration.maintenance_source_observation(source_record_id,establishment_id,area_code,source_type_name,source_status_code,open_date)
    SELECT sr.source_record_id,e.establishment_id,997,'Community school',1,'2010-01-01'
    FROM migration.source_record sr JOIN establishment.establishment e ON e.urn=sr.source_urn WHERE sr.source_snapshot_id=replay_snapshot;
    PERFORM migration.derive_maintenance(replay_snapshot);
    PERFORM migration.derive_maintenance(replay_snapshot);
    IF NOT EXISTS(SELECT 1 FROM establishment.establishment_responsibility r JOIN establishment.establishment e USING(establishment_id)
                   WHERE e.urn=999901 AND r.is_current AND r.first_observed_date='2025-01-01') THEN
        RAISE EXCEPTION 'Matching event replay failed to preserve the earliest supporting observation';
    END IF;
    INSERT INTO migration.source_snapshot(migration_run_id,source_system,snapshot_date)
    VALUES(run,'TEST ONLY newer conflicting replay','2026-06-16') RETURNING source_snapshot_id INTO replay_snapshot;
    INSERT INTO migration.source_record(source_snapshot_id,source_table,source_key,source_urn) VALUES(replay_snapshot,'Establishment','999901',999901);
    INSERT INTO migration.maintenance_source_observation(source_record_id,establishment_id,area_code,source_type_name,source_status_code,open_date)
    SELECT sr.source_record_id,e.establishment_id,999,'Community school',1,'2010-01-01'
    FROM migration.source_record sr JOIN establishment.establishment e ON e.urn=sr.source_urn WHERE sr.source_snapshot_id=replay_snapshot;
    PERFORM migration.derive_maintenance(replay_snapshot);
    IF NOT EXISTS(SELECT 1 FROM migration.maintenance_source_observation o JOIN migration.source_record sr USING(source_record_id)
                   WHERE sr.source_snapshot_id=replay_snapshot AND o.processing_status='review') THEN
        RAISE EXCEPTION 'Newer conflicting maintenance snapshot was not staged';
    END IF;
    SET CONSTRAINTS ALL IMMEDIATE;
END $$;
ROLLBACK;
SELECT 'PASS: retained-code succession, reviewed split, event identity, chronology, atomic rollback and source replay' AS result;
