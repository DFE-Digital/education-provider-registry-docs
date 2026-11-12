-- Reviewed council events govern their effective periods across source replay.
CREATE TABLE migration.council_reorganisation (
    council_reorganisation_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    event_id text NOT NULL UNIQUE,
    payload jsonb NOT NULL,
    payload_sha256 text NOT NULL,
    effective_date date NOT NULL,
    observed_date date NOT NULL,
    status text NOT NULL CHECK(status IN ('pending','review','applied')),
    evidence text NOT NULL,
    source_record_id uuid REFERENCES migration.source_record(source_record_id),
    applied_at timestamptz,
    note text
);
CREATE TABLE migration.council_reorganisation_lineage (
    council_reorganisation_lineage_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    event_id text NOT NULL REFERENCES migration.council_reorganisation(event_id),
    entity_kind text NOT NULL,
    entity_id uuid NOT NULL,
    action text NOT NULL,
    before_row jsonb,
    after_row jsonb NOT NULL,
    UNIQUE(event_id,entity_kind,entity_id,action)
);
CREATE TABLE migration.council_replay_observation (
    council_replay_observation_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    event_id text NOT NULL REFERENCES migration.council_reorganisation(event_id),
    establishment_id uuid NOT NULL REFERENCES establishment.establishment(establishment_id),
    observed_date date,
    payload jsonb NOT NULL,
    payload_hash text NOT NULL,
    disposition text NOT NULL CHECK(disposition IN ('retained','review')),
    UNIQUE(event_id,establishment_id,payload_hash)
);

CREATE FUNCTION migration.apply_council_reorganisation(reviewed_payload jsonb)
RETURNS text LANGUAGE plpgsql AS $$
DECLARE event_key text:=reviewed_payload->>'eventId'; effective_on date:=(reviewed_payload->>'effectiveDate')::date;
    observed_on date:=(reviewed_payload->'source'->>'observedDate')::date;
    payload_hash text:=encode(public.digest(reviewed_payload::text,'sha256'),'hex');
    old record; successor record; mapped record; row_before jsonb; fact jsonb;
    run_id uuid; source_id uuid; responsibility_id uuid; current_row record; eligibility boolean; previous_area uuid;
BEGIN
    PERFORM pg_advisory_xact_lock(hashtextextended('council-maintenance-transition',0));
    IF nullif(event_key,'') IS NULL OR effective_on IS NULL OR observed_on IS NULL
       OR observed_on>CURRENT_DATE OR nullif(reviewed_payload->>'evidence','') IS NULL
       OR nullif(reviewed_payload->'source'->>'system','') IS NULL
       OR nullif(reviewed_payload->'source'->>'table','') IS NULL
       OR nullif(reviewed_payload->'source'->>'key','') IS NULL
       OR NOT ((reviewed_payload->'source') ? 'observedValues') THEN
        RAISE EXCEPTION 'Council event requires its ID, effective date, evidence, source fields and a non-future observation date';
    END IF;
    IF EXISTS(SELECT 1 FROM migration.council_reorganisation e WHERE e.event_id=event_key AND e.payload_sha256<>payload_hash) THEN
        RAISE EXCEPTION 'Council event ID already has a different payload';
    END IF;
    IF EXISTS(SELECT 1 FROM migration.council_reorganisation WHERE event_id=event_key AND status='applied') THEN RETURN 'applied'; END IF;
    INSERT INTO migration.council_reorganisation(event_id,payload,payload_sha256,effective_date,observed_date,status,evidence)
    VALUES(event_key,reviewed_payload,payload_hash,effective_on,observed_on,'pending',reviewed_payload->>'evidence') ON CONFLICT DO NOTHING;
    IF reviewed_payload->>'reviewStatus' IS DISTINCT FROM 'accepted' THEN
        UPDATE migration.council_reorganisation SET status='review',note='Explicit accepted review is required' WHERE event_id=event_key;
        RETURN 'review';
    END IF;
    IF effective_on>CURRENT_DATE THEN RETURN 'pending'; END IF;
    CREATE TEMP TABLE IF NOT EXISTS reorg_old_periods(period_id uuid PRIMARY KEY,council_id uuid,area_id uuid) ON COMMIT DROP;
    CREATE TEMP TABLE IF NOT EXISTS reorg_successors(period_id uuid PRIMARY KEY,area_id uuid UNIQUE,council_id uuid) ON COMMIT DROP;
    CREATE TEMP TABLE IF NOT EXISTS reorg_school_map(establishment_id uuid PRIMARY KEY,area_id uuid,period_id uuid,council_id uuid) ON COMMIT DROP;
    TRUNCATE reorg_old_periods,reorg_successors,reorg_school_map;
    INSERT INTO reorg_old_periods(period_id,council_id,area_id)
    SELECT (x->>'periodId')::uuid,(x->>'expectedCouncilId')::uuid,p.local_authority_area_id
    FROM jsonb_array_elements(reviewed_payload->'oldPeriods') x
    LEFT JOIN establishment.local_authority_area_council_period p ON p.local_authority_area_council_period_id=(x->>'periodId')::uuid;
    INSERT INTO reorg_successors SELECT (x->>'periodId')::uuid,(x->>'areaId')::uuid,(x->>'councilId')::uuid
    FROM jsonb_array_elements(reviewed_payload->'successors') x;
    IF NOT EXISTS(SELECT 1 FROM reorg_old_periods) OR NOT EXISTS(SELECT 1 FROM reorg_successors)
       OR EXISTS(SELECT 1 FROM reorg_old_periods WHERE area_id IS NULL OR council_id IS NULL)
       OR EXISTS(SELECT 1 FROM reorg_successors WHERE area_id IS NULL OR council_id IS NULL) THEN
        RAISE EXCEPTION 'Council event requires resolved previous periods and explicit successor mappings';
    END IF;
    IF EXISTS(SELECT 1 FROM jsonb_array_elements(coalesce(reviewed_payload->'newCouncils','[]')) x
              WHERE NOT EXISTS(SELECT 1 FROM reorg_successors s WHERE s.council_id=(x->>'legalEntityId')::uuid))
       OR EXISTS(SELECT 1 FROM jsonb_array_elements(coalesce(reviewed_payload->'newAreas','[]')) x
                   WHERE NOT EXISTS(SELECT 1 FROM reorg_successors s WHERE s.area_id=(x->>'areaId')::uuid)) THEN
        RAISE EXCEPTION 'Every supplied new council and area must be used by a reviewed successor mapping';
    END IF;
    PERFORM 1 FROM establishment.local_authority_area WHERE local_authority_area_id IN
        (SELECT area_id FROM reorg_old_periods UNION SELECT area_id FROM reorg_successors) ORDER BY local_authority_area_id FOR UPDATE;
    IF EXISTS(SELECT 1 FROM reorg_old_periods o JOIN establishment.local_authority_area_council_period p
              ON p.local_authority_area_council_period_id=o.period_id
              WHERE p.legal_entity_id<>o.council_id OR NOT p.is_current OR p.start_date>=effective_on
                 OR (p.end_date IS NOT NULL AND p.end_date<>effective_on))
       OR EXISTS(SELECT 1 FROM migration.council_reorganisation e
                  JOIN migration.council_reorganisation_lineage l USING(event_id)
                  WHERE e.status='applied' AND e.effective_date>=effective_on
                    AND l.entity_kind='council_period' AND (l.after_row->>'local_authority_area_id')::uuid IN
                         (SELECT area_id FROM reorg_old_periods)) THEN
        UPDATE migration.council_reorganisation SET status='review',note='Previous period mismatch or out-of-order effective date; explicit correction required' WHERE event_id=event_key;
        RETURN 'review';
    END IF;
    IF EXISTS(SELECT 1 FROM establishment.establishment_responsibility r
              JOIN establishment.establishment_geography g USING(establishment_id)
              JOIN establishment.establishment_lifecycle life USING(establishment_id)
              WHERE r.responsibility_type_id=5 AND g.local_authority_area_id IN(SELECT area_id FROM reorg_old_periods)
                AND (r.start_date>=effective_on OR (r.is_current AND life.open_date>effective_on)
                     OR (NOT r.is_current AND (r.end_date IS NULL OR r.end_date>effective_on)))) THEN
        UPDATE migration.council_reorganisation SET status='review',note='Backdated transition intersects existing responsibility history; explicit correction required' WHERE event_id=event_key;
        RETURN 'review';
    END IF;
    IF EXISTS(SELECT 1 FROM reorg_old_periods p JOIN establishment.legal_entity c ON c.legal_entity_id=p.council_id
              WHERE c.incorporation_date>effective_on OR c.dissolution_date<effective_on) THEN
        UPDATE migration.council_reorganisation SET status='review',note='Previous council lifetime contradicts the effective date' WHERE event_id=event_key;
        RETURN 'review';
    END IF;
    FOR fact IN SELECT value FROM jsonb_array_elements(coalesce(reviewed_payload->'newCouncils','[]')) LOOP
        IF EXISTS(SELECT 1 FROM establishment.legal_entity c WHERE c.legal_entity_id=(fact->>'legalEntityId')::uuid
                   AND (c.name IS DISTINCT FROM fact->>'name' OR c.legal_entity_type_id IS DISTINCT FROM 9)) THEN
            RAISE EXCEPTION 'Reviewed council identity collision';
        END IF;
        INSERT INTO establishment.legal_entity(legal_entity_id,name,legal_entity_type_id,incorporation_date,dissolution_date)
        VALUES((fact->>'legalEntityId')::uuid,fact->>'name',9,(fact->>'incorporationDate')::date,(fact->>'dissolutionDate')::date)
        ON CONFLICT DO NOTHING;
    END LOOP;
    PERFORM 1 FROM establishment.legal_entity WHERE legal_entity_id IN
        (SELECT council_id FROM reorg_old_periods UNION SELECT council_id FROM reorg_successors) ORDER BY legal_entity_id FOR UPDATE;
    IF EXISTS(SELECT 1 FROM reorg_successors s LEFT JOIN establishment.legal_entity c ON c.legal_entity_id=s.council_id
              WHERE c.legal_entity_type_id IS DISTINCT FROM 9 OR c.incorporation_date>effective_on OR c.dissolution_date<=effective_on) THEN
        RAISE EXCEPTION 'Successor must be an existing or explicitly supplied Public body within its legal lifetime';
    END IF;
    FOR fact IN SELECT value FROM jsonb_array_elements(coalesce(reviewed_payload->'newAreas','[]')) LOOP
        IF EXISTS(SELECT 1 FROM establishment.local_authority_area a WHERE a.local_authority_area_id=(fact->>'areaId')::uuid OR a.code=(fact->>'code')::integer) THEN
            RAISE EXCEPTION 'New area ID or code already exists; retained codes must use their existing identity';
        END IF;
        INSERT INTO establishment.local_authority_area(local_authority_area_id,code,name,local_authority_jurisdiction_id)
        VALUES((fact->>'areaId')::uuid,(fact->>'code')::integer,fact->>'name',(fact->>'jurisdictionId')::integer);
        INSERT INTO migration.council_reorganisation_lineage(event_id,entity_kind,entity_id,action,before_row,after_row)
        SELECT event_key,'local_authority_area',a.local_authority_area_id,'created',NULL,to_jsonb(a)
        FROM establishment.local_authority_area a WHERE a.local_authority_area_id=(fact->>'areaId')::uuid;
    END LOOP;
    IF EXISTS(SELECT 1 FROM reorg_successors s LEFT JOIN establishment.local_authority_area a ON a.local_authority_area_id=s.area_id
              WHERE a.local_authority_area_id IS NULL) THEN RAISE EXCEPTION 'Successor area is missing'; END IF;
    IF jsonb_array_length(coalesce(reviewed_payload->'schoolMappings','[]'))>0 THEN
        INSERT INTO reorg_school_map
        SELECT e.establishment_id,s.area_id,s.period_id,s.council_id
        FROM jsonb_array_elements(reviewed_payload->'schoolMappings') x
        LEFT JOIN establishment.establishment e ON e.urn=(x->>'urn')::integer
        LEFT JOIN reorg_successors s ON s.area_id=(x->>'areaId')::uuid;
    ELSE
        IF EXISTS(SELECT 1 FROM reorg_successors s WHERE NOT EXISTS(SELECT 1 FROM reorg_old_periods o WHERE o.area_id=s.area_id))
           OR EXISTS(SELECT 1 FROM reorg_old_periods o WHERE NOT EXISTS(SELECT 1 FROM reorg_successors s WHERE s.area_id=o.area_id)) THEN
            RAISE EXCEPTION 'New-code splits and mergers require complete reviewed school mappings';
        END IF;
        INSERT INTO reorg_school_map SELECT g.establishment_id,s.area_id,s.period_id,s.council_id
        FROM establishment.establishment_geography g JOIN reorg_old_periods o ON o.area_id=g.local_authority_area_id
        JOIN reorg_successors s ON s.area_id=o.area_id;
    END IF;
    IF EXISTS(SELECT 1 FROM reorg_school_map m LEFT JOIN establishment.establishment_geography g USING(establishment_id)
              LEFT JOIN establishment.establishment_lifecycle life USING(establishment_id)
              WHERE m.area_id IS NULL OR m.period_id IS NULL OR g.establishment_id IS NULL OR life.establishment_id IS NULL
                 OR g.local_authority_area_id NOT IN(SELECT area_id FROM reorg_old_periods))
       OR EXISTS(SELECT 1 FROM establishment.establishment_geography g WHERE g.local_authority_area_id IN(SELECT area_id FROM reorg_old_periods)
                  AND NOT EXISTS(SELECT 1 FROM reorg_school_map m WHERE m.establishment_id=g.establishment_id)) THEN
        RAISE EXCEPTION 'Reviewed school mapping must cover exactly the affected establishments';
    END IF;
    IF EXISTS(SELECT 1 FROM reorg_school_map m JOIN establishment.establishment_geography g USING(establishment_id)
              JOIN establishment.local_authority_area a ON a.local_authority_area_id=g.local_authority_area_id
              JOIN establishment.local_authority_area b ON b.local_authority_area_id=m.area_id
              WHERE a.local_authority_jurisdiction_id<>b.local_authority_jurisdiction_id) THEN
        RAISE EXCEPTION 'Cross-jurisdiction transitions require a separate reviewed policy decision';
    END IF;
    PERFORM 1 FROM establishment.establishment WHERE establishment_id IN(SELECT establishment_id FROM reorg_school_map)
    ORDER BY establishment_id FOR UPDATE;
    INSERT INTO migration.migration_run(run_type,source_system,source_snapshot_date,status,transform_version,notes)
    VALUES('reviewed-council-reorganisation','Reviewed council event',observed_on,'completed','council-event-v1',reviewed_payload->>'evidence')
    RETURNING migration_run_id INTO run_id;
    source_id:=migration.proprietor_source(run_id,'council-event/'||event_key,reviewed_payload->'source');
    UPDATE migration.council_reorganisation SET source_record_id=source_id WHERE event_id=event_key;
    FOR old IN SELECT p.* FROM reorg_old_periods o JOIN establishment.local_authority_area_council_period p
               ON p.local_authority_area_council_period_id=o.period_id ORDER BY p.local_authority_area_council_period_id LOOP
        row_before:=to_jsonb(old);
        UPDATE establishment.local_authority_area_council_period SET end_date=effective_on,is_current=false
        WHERE local_authority_area_council_period_id=old.local_authority_area_council_period_id;
        INSERT INTO migration.council_reorganisation_lineage(event_id,entity_kind,entity_id,action,before_row,after_row)
        SELECT event_key,'council_period',p.local_authority_area_council_period_id,'changed',row_before,to_jsonb(p)
        FROM establishment.local_authority_area_council_period p WHERE p.local_authority_area_council_period_id=old.local_authority_area_council_period_id;
    END LOOP;
    FOR successor IN SELECT * FROM reorg_successors ORDER BY period_id LOOP
        IF NOT EXISTS(SELECT 1 FROM establishment.local_authority_area_council_period WHERE legal_entity_id=successor.council_id) THEN
            INSERT INTO migration.council_reorganisation_lineage(event_id,entity_kind,entity_id,action,before_row,after_row)
            SELECT event_key,'legal_entity',c.legal_entity_id,'council_added',to_jsonb(c),to_jsonb(c)
            FROM establishment.legal_entity c WHERE c.legal_entity_id=successor.council_id ON CONFLICT DO NOTHING;
        END IF;
        INSERT INTO establishment.local_authority_area_council_period(local_authority_area_council_period_id,
            local_authority_area_id,legal_entity_id,start_date,is_current)
        VALUES(successor.period_id,successor.area_id,successor.council_id,effective_on,true);
        INSERT INTO migration.council_reorganisation_lineage(event_id,entity_kind,entity_id,action,before_row,after_row)
        SELECT event_key,'council_period',p.local_authority_area_council_period_id,'created',NULL,to_jsonb(p)
        FROM establishment.local_authority_area_council_period p WHERE p.local_authority_area_council_period_id=successor.period_id;
    END LOOP;
    FOR mapped IN SELECT m.*,e.establishment_type_id,t.code AS type_code,status.establishment_status_id AS establishment_status_code,l.open_date,l.close_date,j.name AS jurisdiction
                  FROM reorg_school_map m JOIN establishment.establishment e USING(establishment_id) JOIN establishment.establishment_type t USING(establishment_type_id)
                  JOIN establishment.establishment_lifecycle l USING(establishment_id)
    JOIN establishment.establishment_status status USING(establishment_status_id)
                  JOIN establishment.local_authority_area a ON a.local_authority_area_id=m.area_id
                  JOIN establishment.local_authority_jurisdiction j USING(local_authority_jurisdiction_id)
                  ORDER BY m.establishment_id LOOP
        SELECT to_jsonb(g) INTO row_before FROM establishment.establishment_geography g WHERE g.establishment_id=mapped.establishment_id;
        previous_area:=(row_before->>'local_authority_area_id')::uuid;
        UPDATE establishment.establishment_geography SET local_authority_area_id=mapped.area_id WHERE establishment_id=mapped.establishment_id;
        INSERT INTO migration.council_reorganisation_lineage(event_id,entity_kind,entity_id,action,before_row,after_row)
        SELECT event_key,'establishment_geography',g.establishment_id,'changed',row_before,to_jsonb(g)
        FROM establishment.establishment_geography g WHERE g.establishment_id=mapped.establishment_id;
        eligibility:=mapped.jurisdiction='English' AND mapped.type_code IN ('01','02','03','05','07','12','14','15')
                     AND mapped.establishment_status_code IN(1,3) AND (mapped.open_date IS NULL OR mapped.open_date<=effective_on)
                     AND (mapped.close_date IS NULL OR mapped.close_date>effective_on);
        IF NOT eligibility THEN CONTINUE; END IF;
        SELECT r.* INTO current_row FROM establishment.establishment_responsibility r
        WHERE r.establishment_id=mapped.establishment_id AND r.responsibility_type_id=5 AND r.is_current;
        IF NOT FOUND THEN RAISE EXCEPTION 'Eligible school lacks a resolved current maintainer for this transition'; END IF;
        IF NOT EXISTS(SELECT 1 FROM reorg_old_periods WHERE council_id=current_row.legal_entity_id AND area_id=previous_area)
           OR current_row.start_date>=effective_on OR current_row.end_date IS NOT NULL THEN
            RAISE EXCEPTION 'Active maintenance does not match the expected previous council and period';
        END IF;
        row_before:=to_jsonb(current_row);
        UPDATE establishment.establishment_responsibility SET end_date=effective_on,end_date_basis='evidenced',is_current=false
        WHERE establishment_responsibility_id=current_row.establishment_responsibility_id;
        INSERT INTO migration.council_reorganisation_lineage(event_id,entity_kind,entity_id,action,before_row,after_row)
        SELECT event_key,'establishment_responsibility',r.establishment_responsibility_id,'changed',row_before,to_jsonb(r)
        FROM establishment.establishment_responsibility r WHERE r.establishment_responsibility_id=current_row.establishment_responsibility_id;
        INSERT INTO migration.establishment_responsibility_evidence(establishment_responsibility_id,source_record_id,
            first_observed_date,end_date_basis,inference_rule,notes)
        VALUES(current_row.establishment_responsibility_id,source_id,observed_on,'evidenced','council-reorganisation',reviewed_payload::text);
        INSERT INTO establishment.establishment_responsibility(establishment_id,legal_entity_id,responsibility_type_id,
            start_date,is_current,first_observed_date)
        VALUES(mapped.establishment_id,mapped.council_id,5,effective_on,true,observed_on) RETURNING establishment_responsibility_id INTO responsibility_id;
        INSERT INTO migration.maintenance_derivation(establishment_id,council_period_id,derivation_version,
            establishment_responsibility_id,accepted_inputs)
        VALUES(mapped.establishment_id,mapped.period_id,'reviewed-event/'||event_key,responsibility_id,reviewed_payload);
        INSERT INTO migration.establishment_responsibility_evidence(establishment_responsibility_id,source_record_id,
            first_observed_date,inference_rule,notes)
        VALUES(responsibility_id,source_id,observed_on,'council-reorganisation',reviewed_payload::text);
        INSERT INTO migration.council_reorganisation_lineage(event_id,entity_kind,entity_id,action,before_row,after_row)
        SELECT event_key,'establishment_responsibility',r.establishment_responsibility_id,'created',NULL,to_jsonb(r)
        FROM establishment.establishment_responsibility r WHERE r.establishment_responsibility_id=responsibility_id;
    END LOOP;
    UPDATE migration.council_reorganisation SET status='applied',applied_at=now(),note='Atomic reviewed transition completed' WHERE event_id=event_key;
    RETURN 'applied';
END $$;

CREATE FUNCTION migration.retain_reviewed_maintenance(source_id uuid,source_date date)
RETURNS boolean LANGUAGE plpgsql AS $$
DECLARE governing record; observed record; normalized jsonb; school record; allowed boolean; disposition text;
BEGIN
    SELECT o.*,e.urn INTO STRICT observed FROM migration.maintenance_source_observation o
    JOIN establishment.establishment e USING(establishment_id) WHERE o.source_record_id=source_id;
    SELECT ev.* INTO governing FROM migration.council_reorganisation ev
    JOIN migration.council_reorganisation_lineage l USING(event_id)
    WHERE l.entity_id=observed.establishment_id AND l.entity_kind='establishment_geography' AND ev.status='applied'
    ORDER BY ev.effective_date DESC LIMIT 1;
    IF NOT FOUND THEN RETURN false; END IF;
    SELECT e.establishment_type_id,t.name,t.code AS type_code INTO STRICT school FROM establishment.establishment e
    JOIN establishment.establishment_type t USING(establishment_type_id) WHERE e.establishment_id=observed.establishment_id;
    normalized:=to_jsonb(observed)||jsonb_build_object('local_authority_code',observed.area_code,
        'status_code',observed.source_status_code,'establishment_type_id',
        CASE WHEN observed.source_type_name=school.name OR (school.type_code NOT IN ('01','02','03','05','07','12','14','15')
             AND observed.source_type_name NOT IN('Community school','Community special school','Foundation special school',
                 'Voluntary aided school','Voluntary controlled school','Foundation school','Pupil referral unit','Maintained nursery school'))
        THEN school.establishment_type_id ELSE (SELECT establishment_type_id FROM establishment.establishment_type WHERE name=observed.source_type_name) END);
    allowed:=migration.allow_establishment_replay(observed.urn,source_date,normalized);
    disposition:=CASE WHEN NOT allowed AND (source_date IS NULL OR source_date>governing.effective_date) THEN 'review' ELSE 'retained' END;
    INSERT INTO migration.council_replay_observation(event_id,establishment_id,observed_date,payload,payload_hash,disposition)
    VALUES(governing.event_id,observed.establishment_id,source_date,
        normalized,md5(jsonb_build_object('observed_date',source_date,'payload',normalized)::text),disposition) ON CONFLICT DO NOTHING;
    IF allowed THEN
        UPDATE establishment.establishment_responsibility SET first_observed_date=least(first_observed_date,source_date)
        WHERE establishment_id=observed.establishment_id AND responsibility_type_id=5 AND is_current;
        INSERT INTO migration.establishment_responsibility_evidence(establishment_responsibility_id,source_record_id,
            first_observed_date,inference_rule,notes)
        SELECT r.establishment_responsibility_id,source_id,source_date,'reviewed-event-replay',governing.event_id
        FROM establishment.establishment_responsibility r WHERE r.establishment_id=observed.establishment_id
          AND r.responsibility_type_id=5 AND r.is_current AND NOT EXISTS(
              SELECT 1 FROM migration.establishment_responsibility_evidence ev
              WHERE ev.establishment_responsibility_id=r.establishment_responsibility_id AND ev.source_record_id=source_id
                AND ev.inference_rule='reviewed-event-replay');
    END IF;
    UPDATE migration.maintenance_source_observation SET processing_status=CASE WHEN disposition='review' THEN 'review' ELSE 'accepted' END,
        processing_note=CASE WHEN disposition='review' THEN 'Newer snapshot conflicts with the reviewed council event; correction requires review'
                             ELSE 'Reviewed council event retained; ordinary source assertion preserved as replay evidence' END
    WHERE source_record_id=source_id;
    RETURN true;
END $$;

-- False means retain the existing event-governed establishment snapshot.
CREATE FUNCTION migration.allow_establishment_replay(source_urn integer,source_date date,source_payload jsonb)
RETURNS boolean LANGUAGE plpgsql AS $$
DECLARE governing record; school record; disposition text;
BEGIN
    SELECT ev.* INTO governing FROM migration.council_reorganisation ev
    JOIN migration.council_reorganisation_lineage line USING(event_id)
    JOIN establishment.establishment e ON e.establishment_id=line.entity_id
    WHERE e.urn=source_urn AND line.entity_kind='establishment_geography' AND ev.status='applied'
    ORDER BY ev.effective_date DESC LIMIT 1;
    IF NOT FOUND THEN RETURN true; END IF;
    SELECT e.establishment_id,e.establishment_type_id,status.establishment_status_id AS establishment_status_code,l.open_date,l.close_date,a.code
    INTO STRICT school FROM establishment.establishment e JOIN establishment.establishment_lifecycle l USING(establishment_id)
    JOIN establishment.establishment_status status USING(establishment_status_id)
    JOIN establishment.establishment_geography g USING(establishment_id)
    JOIN establishment.local_authority_area a USING(local_authority_area_id) WHERE e.urn=source_urn;
    IF source_date>governing.effective_date AND
       ROW((source_payload->>'local_authority_code')::integer,(source_payload->>'establishment_type_id')::uuid,
           (source_payload->>'status_code')::integer,(source_payload->>'open_date')::date,(source_payload->>'close_date')::date)
       IS NOT DISTINCT FROM ROW(school.code,school.establishment_type_id,school.establishment_status_code,school.open_date,school.close_date) THEN
        RETURN true;
    END IF;
    disposition:=CASE WHEN source_date IS NULL OR source_date>governing.effective_date THEN 'review' ELSE 'retained' END;
    INSERT INTO migration.council_replay_observation(event_id,establishment_id,observed_date,payload,payload_hash,disposition)
    VALUES(governing.event_id,school.establishment_id,source_date,
        source_payload,md5(jsonb_build_object('observed_date',source_date,'payload',source_payload)::text),disposition) ON CONFLICT DO NOTHING;
    RETURN false;
END $$;
