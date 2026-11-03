-- Maintenance provenance and derivation. Included by migration-schema.sql.
CREATE TABLE migration.maintenance_source_observation (
    source_record_id uuid PRIMARY KEY REFERENCES migration.source_record(source_record_id),
    establishment_id uuid NOT NULL REFERENCES establishment.establishment(establishment_id),
    area_code integer,
    source_type_name text,
    source_status_code integer,
    open_date date,
    close_date date,
    processing_status text NOT NULL DEFAULT 'review'
        CHECK (processing_status IN ('accepted','ineligible','welsh_excluded','review')),
    processing_note text
);

CREATE TABLE migration.maintenance_derivation (
    maintenance_derivation_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    establishment_id uuid NOT NULL REFERENCES establishment.establishment(establishment_id),
    council_period_id uuid NOT NULL REFERENCES establishment.local_authority_area_council_period(local_authority_area_council_period_id),
    derivation_version text NOT NULL,
    establishment_responsibility_id uuid NOT NULL UNIQUE
        REFERENCES establishment.establishment_responsibility(establishment_responsibility_id),
    accepted_inputs jsonb NOT NULL,
    UNIQUE(establishment_id,council_period_id,derivation_version)
);

CREATE UNIQUE INDEX maintenance_evidence_source_unique
ON migration.establishment_responsibility_evidence
    (establishment_responsibility_id,source_record_id,inference_rule)
WHERE inference_rule='maintenance-v1';

CREATE FUNCTION migration.derive_maintenance(snapshot_id uuid)
RETURNS void LANGUAGE plpgsql AS $$
DECLARE
    o record; p record; school record; existing record;
    start_on date; end_on date; basis text; current_flag boolean;
    responsibility_id uuid; inputs jsonb; eligible boolean; observed_on date;
    matched integer; current_count integer; current_matched integer;
BEGIN
    PERFORM pg_advisory_xact_lock(hashtextextended('council-maintenance-transition',0));
    SELECT snapshot_date INTO observed_on FROM migration.source_snapshot WHERE source_snapshot_id=snapshot_id;
    FOR o IN SELECT obs.*,sr.source_urn
             FROM migration.maintenance_source_observation obs
             JOIN migration.source_record sr USING(source_record_id)
             WHERE sr.source_snapshot_id=snapshot_id ORDER BY obs.establishment_id
    LOOP
        -- A source assertion and its derived business rows succeed together.
        -- Contradictions are retained for review, without partial derivation.
        BEGIN
            IF migration.retain_reviewed_maintenance(o.source_record_id,observed_on) THEN CONTINUE; END IF;
            PERFORM 1 FROM establishment.establishment WHERE establishment_id=o.establishment_id FOR UPDATE;
            SELECT e.establishment_type_id,l.establishment_status_id,l.open_date,l.close_date,
                   a.local_authority_area_id,a.code,j.name AS jurisdiction,t.name AS type_name
            INTO STRICT school FROM establishment.establishment e
            JOIN establishment.establishment_lifecycle l USING(establishment_id)
            JOIN establishment.establishment_geography g USING(establishment_id)
            JOIN establishment.local_authority_area a USING(local_authority_area_id)
            JOIN establishment.local_authority_jurisdiction j USING(local_authority_jurisdiction_id)
            JOIN establishment.establishment_type t USING(establishment_type_id)
            WHERE e.establishment_id=o.establishment_id;
            eligible:=school.establishment_type_id IN (1,2,3,9,10,11,12,13);
            IF school.code IS DISTINCT FROM o.area_code
               OR school.establishment_status_id IS DISTINCT FROM o.source_status_code
               OR school.open_date IS DISTINCT FROM o.open_date
               OR school.close_date IS DISTINCT FROM o.close_date
               OR eligible IS DISTINCT FROM (o.source_type_name IN (
                   'Community school','Community special school','Foundation special school',
                   'Voluntary aided school','Voluntary controlled school','Foundation school',
                   'Pupil referral unit','Maintained nursery school'))
               OR (eligible AND school.type_name IS DISTINCT FROM o.source_type_name) THEN
                RAISE EXCEPTION 'Source inputs disagree with the loaded establishment; reconcile before deriving maintenance';
            END IF;
            IF school.jurisdiction='Welsh' THEN
                UPDATE migration.maintenance_source_observation SET processing_status='welsh_excluded',
                processing_note=CASE WHEN eligible THEN 'Review: Welsh-coded school has an English maintained type; no automatic maintenance'
                                     ELSE 'Welsh maintenance enrichment is out of scope' END
                WHERE source_record_id=o.source_record_id;
                CONTINUE;
            END IF;
            IF school.jurisdiction<>'English' OR NOT eligible OR o.source_status_code=4 THEN
                IF EXISTS (SELECT 1 FROM establishment.establishment_responsibility
                           WHERE establishment_id=o.establishment_id AND responsibility_type_id=5 AND is_current) THEN
                    RAISE EXCEPTION 'Current maintenance conflicts with the source type or status; reviewed transition required';
                END IF;
                UPDATE migration.maintenance_source_observation SET processing_status='ineligible',
                processing_note='No current English maintained-school assertion; supported history is retained'
                WHERE source_record_id=o.source_record_id;
                CONTINUE;
            END IF;
            IF observed_on IS NULL THEN RAISE EXCEPTION 'Source observation date is unknown'; END IF;
            IF o.source_status_code NOT IN (1,2,3)
               OR o.open_date>observed_on
               OR (o.source_status_code=2 AND (o.close_date IS NULL OR o.close_date>observed_on))
               OR (o.source_status_code IN (1,3) AND o.close_date<=observed_on)
               OR o.close_date<o.open_date THEN
                RAISE EXCEPTION 'Contradictory school operating dates or source status';
            END IF;
            matched:=0; current_matched:=0;
            FOR p IN SELECT cp.*,c.incorporation_date,c.dissolution_date
                     FROM establishment.local_authority_area_council_period cp
                     JOIN establishment.legal_entity c USING(legal_entity_id)
                     WHERE cp.local_authority_area_id=school.local_authority_area_id
                     ORDER BY cp.start_date NULLS FIRST,cp.local_authority_area_council_period_id
            LOOP
                -- A current code cannot establish membership of an earlier code.
                -- Ignore wholly disjoint periods and unexecuted future changes.
                IF p.start_date>observed_on OR (o.close_date IS NOT NULL AND p.start_date>=o.close_date)
                   OR (o.open_date IS NOT NULL AND p.end_date<=o.open_date) THEN CONTINUE; END IF;
                IF NOT p.is_current AND (p.end_date IS NULL OR p.end_date>observed_on) THEN
                    RAISE EXCEPTION 'Council period cannot be resolved at the source observation date';
                END IF;
                start_on:=greatest(o.open_date,p.start_date);
                end_on:=least(CASE WHEN o.close_date<=observed_on THEN o.close_date END,
                              CASE WHEN p.end_date<=observed_on THEN p.end_date END);
                IF start_on IS NOT NULL AND end_on IS NOT NULL AND end_on<=start_on THEN CONTINUE; END IF;
                IF (p.incorporation_date IS NOT NULL AND (start_on IS NULL OR start_on<p.incorporation_date))
                   OR (p.dissolution_date IS NOT NULL AND (end_on IS NULL OR end_on>p.dissolution_date)) THEN
                    RAISE EXCEPTION 'Derived period cannot be established within the council legal lifetime';
                END IF;
                current_flag:=o.source_status_code IN (1,3) AND p.is_current
                              AND (p.start_date IS NULL OR p.start_date<=observed_on)
                              AND (p.end_date IS NULL OR p.end_date>observed_on);
                basis:=CASE WHEN end_on IS NULL THEN NULL WHEN end_on=o.close_date THEN 'inferred' ELSE 'evidenced' END;
                inputs:=jsonb_build_object('area_code',o.area_code,'source_type_name',o.source_type_name,
                    'school_open',o.open_date,'school_close',o.close_date,
                    'council_effective_start',p.start_date,'council_effective_end',p.end_date,
                    'derived_start',start_on,'derived_end',end_on,'end_date_basis',basis,
                    'start_inferred',start_on IS NOT NULL,'closure_inferred',end_on=o.close_date,
                    'rule','maintenance-v1');
                SELECT d.*,r.legal_entity_id,r.start_date,r.end_date,r.end_date_basis,r.is_current
                INTO existing FROM migration.maintenance_derivation d
                JOIN establishment.establishment_responsibility r USING(establishment_responsibility_id)
                WHERE d.establishment_id=o.establishment_id
                  AND d.council_period_id=p.local_authority_area_council_period_id AND d.derivation_version='maintenance-v1';
                IF FOUND THEN
                    IF existing.legal_entity_id IS DISTINCT FROM p.legal_entity_id
                       OR existing.start_date IS DISTINCT FROM start_on OR existing.end_date IS DISTINCT FROM end_on
                       OR existing.end_date_basis IS DISTINCT FROM basis OR existing.is_current IS DISTINCT FROM current_flag THEN
                        RAISE EXCEPTION 'Existing maintenance boundary or holder differs; explicit reviewed update required';
                    END IF;
                    responsibility_id:=existing.establishment_responsibility_id;
                    UPDATE establishment.establishment_responsibility
                    SET first_observed_date=least(first_observed_date,observed_on)
                    WHERE establishment_responsibility_id=responsibility_id;
                ELSE
                    responsibility_id:=gen_random_uuid();
                    INSERT INTO establishment.establishment_responsibility(
                        establishment_responsibility_id,establishment_id,legal_entity_id,responsibility_type_id,
                        start_date,end_date,is_current,end_date_basis,first_observed_date)
                    VALUES(responsibility_id,o.establishment_id,p.legal_entity_id,5,
                           start_on,end_on,current_flag,basis,observed_on);
                    INSERT INTO migration.maintenance_derivation(establishment_id,council_period_id,
                        derivation_version,establishment_responsibility_id,accepted_inputs)
                    VALUES(o.establishment_id,p.local_authority_area_council_period_id,'maintenance-v1',responsibility_id,inputs);
                END IF;
                INSERT INTO migration.establishment_responsibility_evidence(
                    establishment_responsibility_id,source_record_id,first_observed_date,end_date_basis,inference_rule,notes)
                VALUES(responsibility_id,o.source_record_id,observed_on,basis,'maintenance-v1',inputs::text)
                ON CONFLICT DO NOTHING;
                matched:=matched+1;
                IF current_flag THEN current_matched:=current_matched+1; END IF;
            END LOOP;
            SELECT count(*) INTO current_count FROM establishment.establishment_responsibility
            WHERE establishment_id=o.establishment_id AND responsibility_type_id=5 AND is_current;
            IF o.source_status_code IN (1,3) AND (current_count<>1 OR current_matched<>1) THEN
                RAISE EXCEPTION 'Open eligible school has no resolved current council';
            END IF;
            IF o.source_status_code=2 AND current_count<>0 THEN
                RAISE EXCEPTION 'Closed school still has current maintenance';
            END IF;
            UPDATE migration.maintenance_source_observation SET processing_status='accepted',
            processing_note=format('%s supported council periods; unknown boundaries remain null',matched)
            WHERE source_record_id=o.source_record_id;
        EXCEPTION WHEN raise_exception OR check_violation OR unique_violation OR exclusion_violation OR no_data_found THEN
            UPDATE migration.maintenance_source_observation SET processing_status='review',processing_note=SQLERRM
            WHERE source_record_id=o.source_record_id;
        END;
    END LOOP;
END $$;
