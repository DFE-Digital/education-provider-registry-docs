-- Load one configured reorganisation atomically after all core rows.
-- Case data and source assertions are supplied as JSON, not embedded here.
BEGIN;
SELECT pg_advisory_xact_lock(189,27112026);
CREATE TEMP TABLE reorganisation_case_participant (
    urn integer PRIMARY KEY CHECK(urn BETWEEN 1 AND 999999), outcome text NOT NULL,
    establishment_id uuid, outcome_id integer, status_code text, open_date date, close_date date
) ON COMMIT DROP;
CREATE TEMP TABLE reorganisation_case_pair (
    pair_kind text NOT NULL CHECK(pair_kind IN ('succession','transfer')),
    predecessor_urn integer REFERENCES reorganisation_case_participant(urn),
    successor_urn integer REFERENCES reorganisation_case_participant(urn),
    forward_link_type text NOT NULL, reverse_link_type text NOT NULL,
    PRIMARY KEY(predecessor_urn,successor_urn), CHECK(predecessor_urn<>successor_urn)
) ON COMMIT DROP;
DO $migration$
DECLARE
    payload jsonb := '__PAYLOAD__'::jsonb;
    case_key text := payload->>'case_id';
    pattern_id integer; cause_id integer; event_id uuid; existing_events uuid[];
    missing_urns text; boundary_start date; boundary_end date; result jsonb;
BEGIN
    SELECT reorganisation_pattern_id INTO pattern_id FROM establishment.reorganisation_pattern WHERE name=payload->>'pattern';
    IF pattern_id IS NULL OR pattern_id NOT BETWEEN 1 AND 7 THEN
        RAISE EXCEPTION 'Unsupported reorganisation pattern for case %',case_key;
    END IF;
    IF payload->>'cause' IS NOT NULL THEN
        SELECT reorganisation_cause_id INTO cause_id FROM establishment.reorganisation_cause WHERE name=payload->>'cause';
        IF cause_id IS NULL THEN RAISE EXCEPTION 'Unknown cause for case %',case_key; END IF;
    END IF;
    INSERT INTO reorganisation_case_participant(urn,outcome)
    SELECT urn,outcome FROM jsonb_to_recordset(payload->'participants') AS p(urn integer,outcome text);
    UPDATE reorganisation_case_participant p SET outcome_id=o.reorganisation_outcome_id
    FROM establishment.reorganisation_outcome o WHERE o.name=p.outcome;
    IF (SELECT count(*) FROM reorganisation_case_participant)<2
       OR EXISTS(SELECT 1 FROM reorganisation_case_participant WHERE outcome_id IS NULL) THEN
        RAISE EXCEPTION 'Invalid participants or outcomes for case %',case_key;
    END IF;
    INSERT INTO reorganisation_case_pair
    SELECT 'succession',predecessor_urn,successor_urn,forward_link_type,reverse_link_type
    FROM jsonb_to_recordset(payload->'succession_pairs')
        AS p(predecessor_urn integer,successor_urn integer,forward_link_type text,reverse_link_type text);
    INSERT INTO reorganisation_case_pair
    SELECT 'transfer',origin_urn,recipient_urn,forward_link_type,reverse_link_type
    FROM jsonb_to_recordset(coalesce(payload->'provision_transfer_pairs','[]'))
        AS p(origin_urn integer,recipient_urn integer,forward_link_type text,reverse_link_type text);
    IF NOT EXISTS(SELECT 1 FROM reorganisation_case_pair)
       OR EXISTS(SELECT 1 FROM reorganisation_case_pair p
           JOIN reorganisation_case_participant a ON a.urn=p.predecessor_urn
           JOIN reorganisation_case_participant b ON b.urn=p.successor_urn
           WHERE (p.pair_kind='succession' AND a.outcome<>'Closed')
              OR (p.pair_kind='transfer' AND a.outcome<>'Continued') OR b.outcome NOT IN ('Opened','Continued')) THEN
        RAISE EXCEPTION 'Invalid pair directions for case %',case_key;
    END IF;
    -- Validate both source directions independently; their codes are scenario-specific.
    IF EXISTS(SELECT 1 FROM reorganisation_case_pair p WHERE
        NOT EXISTS(SELECT 1 FROM jsonb_to_recordset(payload->'source_links') AS l(urn integer,linked_urn integer,link_type text)
            WHERE l.urn=p.predecessor_urn AND l.linked_urn=p.successor_urn AND l.link_type=p.forward_link_type)
        OR NOT EXISTS(SELECT 1 FROM jsonb_to_recordset(payload->'source_links') AS l(urn integer,linked_urn integer,link_type text)
            WHERE l.urn=p.successor_urn AND l.linked_urn=p.predecessor_urn AND l.link_type=p.reverse_link_type)) THEN
        RAISE EXCEPTION 'BAU reciprocal link assertions no longer match case %',case_key;
    END IF;
    UPDATE reorganisation_case_participant p SET status_code=s.status_code,
        open_date=nullif(s.open_date,'NULL')::date,close_date=nullif(s.close_date,'NULL')::date
    FROM jsonb_to_recordset(payload->'source_participants') AS s(urn integer,status_code text,open_date text,close_date text)
    WHERE s.urn=p.urn;
    IF EXISTS(SELECT 1 FROM reorganisation_case_participant
        WHERE status_code IS NULL OR (outcome='Closed' AND (status_code<>'2' OR close_date IS NULL))
            OR (outcome IN ('Opened','Continued') AND open_date IS NULL)) THEN
        RAISE EXCEPTION 'BAU lifecycle does not support case % outcomes',case_key;
    END IF;
    SELECT min(close_date),max(close_date) INTO boundary_start,boundary_end
    FROM reorganisation_case_participant WHERE outcome='Closed';
    boundary_start:=coalesce(boundary_start,(payload->>'validation_date')::date);
    boundary_end:=coalesce(boundary_end,(payload->>'validation_date')::date);
    IF EXISTS(SELECT 1 FROM reorganisation_case_participant
        WHERE (outcome='Continued' AND (open_date>=boundary_start OR close_date<=boundary_end))
           OR (outcome='Opened' AND open_date<boundary_end)) THEN
        RAISE EXCEPTION 'BAU opening/closure chronology conflicts with case % outcomes',case_key;
    END IF;
    UPDATE reorganisation_case_participant p SET establishment_id=e.establishment_id
    FROM establishment.establishment e WHERE e.urn=p.urn;
    SELECT string_agg(urn::text,', ' ORDER BY urn) INTO missing_urns FROM reorganisation_case_participant WHERE establishment_id IS NULL;
    IF missing_urns IS NOT NULL THEN
        INSERT INTO migration.relationship_load_error(migration_run_id,urn,relationship_kind,error_message,source_row)
        VALUES('__RUN_ID__',__SELECTED_URN__,'reorganisation-dependency',
            format('Case %s missing target URNs: %s',case_key,missing_urns),payload);
        RAISE NOTICE 'Case % pending: missing target URNs %',case_key,missing_urns;
        result:=jsonb_build_object('status','pending','missing_urns',missing_urns,'evidence',payload);
    ELSE
        IF EXISTS(SELECT 1 FROM reorganisation_case_participant p
            LEFT JOIN establishment.establishment_lifecycle l USING(establishment_id)
            LEFT JOIN establishment.establishment_status s USING(establishment_status_id)
            WHERE s.code::text IS DISTINCT FROM p.status_code OR l.open_date IS DISTINCT FROM p.open_date
                OR l.close_date IS DISTINCT FROM p.close_date) THEN
            RAISE EXCEPTION 'Target lifecycle differs from BAU for case %; reload its establishments',case_key;
        END IF;
        SELECT array_agg(DISTINCT s.establishment_reorganisation_id) FILTER(WHERE s.establishment_reorganisation_id IS NOT NULL)
        INTO existing_events FROM (
            SELECT 'succession' AS pair_kind,predecessor_establishment_id,successor_establishment_id,establishment_reorganisation_id
            FROM establishment.establishment_succession
            UNION ALL
            SELECT 'transfer',origin_establishment_id,recipient_establishment_id,establishment_reorganisation_id
            FROM establishment.establishment_provision_transfer
        ) s
        JOIN reorganisation_case_participant a ON a.establishment_id=s.predecessor_establishment_id
        JOIN reorganisation_case_participant b ON b.establishment_id=s.successor_establishment_id
        JOIN reorganisation_case_pair p ON p.predecessor_urn=a.urn AND p.successor_urn=b.urn AND p.pair_kind=s.pair_kind;
        IF cardinality(existing_events)>1 THEN RAISE EXCEPTION 'Case % pairs already belong to different events',case_key; END IF;
        event_id:=coalesce(existing_events[1],md5('gias-reviewed-reorganisation:'||case_key)::uuid);
        IF EXISTS(SELECT 1 FROM establishment.establishment_reorganisation e WHERE e.establishment_reorganisation_id=event_id
            AND (e.reorganisation_pattern_id<>pattern_id OR e.reorganisation_cause_id IS DISTINCT FROM cause_id
                 OR e.effective_date IS DISTINCT FROM nullif(payload->>'effective_date','')::date)) THEN
            RAISE EXCEPTION 'Existing event conflicts with case % classification or date',case_key;
        END IF;
        IF EXISTS(SELECT 1 FROM establishment.reorganisation_participant p
            WHERE p.establishment_reorganisation_id=event_id AND NOT EXISTS
                (SELECT 1 FROM reorganisation_case_participant c WHERE c.establishment_id=p.establishment_id AND c.outcome_id=p.reorganisation_outcome_id)) THEN
            RAISE EXCEPTION 'Existing event has participants conflicting with case %',case_key;
        END IF;
        -- Never silently erase a standalone pair's known date.
        IF EXISTS(SELECT 1 FROM (
            SELECT 'succession' AS pair_kind,predecessor_establishment_id,successor_establishment_id,effective_date
            FROM establishment.establishment_succession
            UNION ALL SELECT 'transfer',origin_establishment_id,recipient_establishment_id,effective_date
            FROM establishment.establishment_provision_transfer
        ) s
            JOIN reorganisation_case_participant a ON a.establishment_id=s.predecessor_establishment_id
            JOIN reorganisation_case_participant b ON b.establishment_id=s.successor_establishment_id
            JOIN reorganisation_case_pair p ON p.predecessor_urn=a.urn AND p.successor_urn=b.urn AND p.pair_kind=s.pair_kind WHERE s.effective_date IS NOT NULL) THEN
            RAISE EXCEPTION 'Dated standalone succession requires a date decision before grouping case %',case_key;
        END IF;
        INSERT INTO establishment.establishment_reorganisation
            (establishment_reorganisation_id,reorganisation_pattern_id,reorganisation_cause_id,effective_date,description)
        VALUES(event_id,pattern_id,cause_id,nullif(payload->>'effective_date','')::date,payload->>'description') ON CONFLICT DO NOTHING;
        INSERT INTO establishment.reorganisation_participant(establishment_reorganisation_id,establishment_id,reorganisation_outcome_id)
        SELECT event_id,establishment_id,outcome_id FROM reorganisation_case_participant
        ON CONFLICT(establishment_reorganisation_id,establishment_id) DO NOTHING;
        INSERT INTO establishment.establishment_succession(predecessor_establishment_id,successor_establishment_id,establishment_reorganisation_id)
        SELECT a.establishment_id,b.establishment_id,event_id FROM reorganisation_case_pair p
        JOIN reorganisation_case_participant a ON a.urn=p.predecessor_urn JOIN reorganisation_case_participant b ON b.urn=p.successor_urn
        WHERE p.pair_kind='succession'
        ON CONFLICT(predecessor_establishment_id,successor_establishment_id) DO UPDATE
        SET establishment_reorganisation_id=excluded.establishment_reorganisation_id,effective_date=NULL;
        IF EXISTS(SELECT 1 FROM reorganisation_case_pair p
            JOIN reorganisation_case_participant a ON a.urn=p.predecessor_urn
            JOIN reorganisation_case_participant b ON b.urn=p.successor_urn
            JOIN establishment.establishment_provision_transfer t ON t.origin_establishment_id=a.establishment_id AND t.recipient_establishment_id=b.establishment_id
            WHERE p.pair_kind='transfer' AND t.establishment_reorganisation_id IS NOT NULL AND t.establishment_reorganisation_id<>event_id) THEN
            RAISE EXCEPTION 'Transfer already belongs to another event for case %',case_key;
        END IF;
        INSERT INTO establishment.establishment_provision_transfer(origin_establishment_id,recipient_establishment_id,establishment_reorganisation_id)
        SELECT a.establishment_id,b.establishment_id,event_id FROM reorganisation_case_pair p
        JOIN reorganisation_case_participant a ON a.urn=p.predecessor_urn JOIN reorganisation_case_participant b ON b.urn=p.successor_urn
        WHERE p.pair_kind='transfer'
        ON CONFLICT(origin_establishment_id,recipient_establishment_id) DO UPDATE
        SET establishment_reorganisation_id=excluded.establishment_reorganisation_id,effective_date=NULL;
        IF EXISTS(SELECT 1 FROM jsonb_to_recordset(coalesce(payload->'effects','[]')) x(urn integer,effect text)
            LEFT JOIN reorganisation_case_participant p USING(urn)
            LEFT JOIN establishment.reorganisation_effect_type t ON t.name=x.effect
            WHERE p.urn IS NULL OR t.reorganisation_effect_type_id IS NULL) THEN
            RAISE EXCEPTION 'Invalid effect for case %',case_key;
        END IF;
        INSERT INTO establishment.reorganisation_effect(reorganisation_participant_id,reorganisation_effect_type_id)
        SELECT r.reorganisation_participant_id,t.reorganisation_effect_type_id
        FROM jsonb_to_recordset(coalesce(payload->'effects','[]')) x(urn integer,effect text)
        JOIN reorganisation_case_participant p USING(urn)
        JOIN establishment.reorganisation_participant r ON r.establishment_id=p.establishment_id AND r.establishment_reorganisation_id=event_id
        JOIN establishment.reorganisation_effect_type t ON t.name=x.effect
        ON CONFLICT(reorganisation_participant_id,reorganisation_effect_type_id) DO NOTHING;
        SET CONSTRAINTS ALL IMMEDIATE;
        result:=jsonb_build_object('status','loaded','event_id',event_id,
            'participants',(SELECT count(*) FROM reorganisation_case_participant),
            'succession_pairs',(SELECT count(*) FROM reorganisation_case_pair WHERE pair_kind='succession'),
            'provision_transfers',(SELECT count(*) FROM reorganisation_case_pair WHERE pair_kind='transfer'),'evidence',payload);
        RAISE NOTICE 'Case % loaded: % participants, % pairs',case_key,
            (SELECT count(*) FROM reorganisation_case_participant),(SELECT count(*) FROM reorganisation_case_pair);
    END IF;
    UPDATE migration.migration_run SET notes=jsonb_set(coalesce(notes::jsonb,'{}'),'{reorganisations}',
        coalesce(notes::jsonb->'reorganisations','{}')||jsonb_build_object(case_key,result))::text
    WHERE migration_run_id='__RUN_ID__';
END $migration$;
DROP TABLE reorganisation_case_pair,reorganisation_case_participant;
COMMIT;
