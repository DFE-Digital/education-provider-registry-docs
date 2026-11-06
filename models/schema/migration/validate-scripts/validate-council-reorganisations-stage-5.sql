-- Stage 5 event ledger and resulting target shape. Read-only.
BEGIN ISOLATION LEVEL REPEATABLE READ READ ONLY;
DO $$
DECLARE line record; actual jsonb;
BEGIN
    IF EXISTS(SELECT 1 FROM migration.council_reorganisation e
              WHERE e.payload_sha256<>encode(public.digest(e.payload::text,'sha256'),'hex')
                 OR (e.status='applied' AND (e.effective_date>CURRENT_DATE OR e.applied_at IS NULL OR e.source_record_id IS NULL))) THEN
        RAISE EXCEPTION 'Stage 5: event hash, chronology or source evidence is invalid';
    END IF;
    IF EXISTS(SELECT 1 FROM migration.council_reorganisation e JOIN migration.council_reorganisation_lineage l USING(event_id)
              WHERE e.status<>'applied') THEN RAISE EXCEPTION 'Stage 5: pending or staged event has business lineage'; END IF;
    FOR line IN SELECT DISTINCT ON(l.entity_kind,l.entity_id) l.* FROM migration.council_reorganisation_lineage l
                JOIN migration.council_reorganisation e USING(event_id) WHERE e.status='applied'
                ORDER BY l.entity_kind,l.entity_id,e.effective_date DESC,e.applied_at DESC LOOP
        IF line.entity_kind='council_period' THEN
            SELECT to_jsonb(p) INTO actual FROM establishment.local_authority_area_council_period p
            WHERE p.local_authority_area_council_period_id=line.entity_id;
            IF actual IS DISTINCT FROM line.after_row THEN RAISE EXCEPTION 'Stage 5: council period differs from its governing event'; END IF;
        ELSIF line.entity_kind='establishment_responsibility' THEN
            SELECT to_jsonb(r)-'first_observed_date' INTO actual FROM establishment.establishment_responsibility r
            WHERE r.establishment_responsibility_id=line.entity_id;
            IF actual IS DISTINCT FROM (line.after_row-'first_observed_date') THEN RAISE EXCEPTION 'Stage 5: maintenance differs from its governing event'; END IF;
        ELSIF line.entity_kind='establishment_geography' THEN
            SELECT to_jsonb(g.local_authority_area_id) INTO actual FROM establishment.establishment_geography g
            WHERE g.establishment_id=line.entity_id;
            IF actual IS DISTINCT FROM line.after_row->'local_authority_area_id' THEN RAISE EXCEPTION 'Stage 5: geography differs from its governing event'; END IF;
        END IF;
    END LOOP;
END $$;
SELECT 'PASS: Stage 5 reviewed council ledger and target shape' AS result;
SELECT event_id,effective_date,observed_date,status,note FROM migration.council_reorganisation ORDER BY effective_date,event_id;
SELECT event_id,entity_kind,action,count(*) FROM migration.council_reorganisation_lineage GROUP BY 1,2,3 ORDER BY 1,2,3;
SELECT event_id,establishment_id,observed_date,disposition FROM migration.council_replay_observation WHERE disposition='review' ORDER BY 1,2,3;
COMMIT;
