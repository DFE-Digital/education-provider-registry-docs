-- Stage 3 target validation. Run the whole file; it is read-only.
BEGIN ISOLATION LEVEL REPEATABLE READ READ ONLY;
DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM establishment.establishment e
        JOIN establishment.establishment_lifecycle l USING(establishment_id)
        JOIN establishment.establishment_geography g USING(establishment_id)
        JOIN establishment.local_authority_area a USING(local_authority_area_id)
        JOIN establishment.local_authority_jurisdiction j USING(local_authority_jurisdiction_id)
        WHERE j.name='English' AND e.establishment_type_id IN (1,2,3,9,10,11,12,13)
          AND l.establishment_status_id IN (1,3)
          AND ((SELECT count(*) FROM establishment.establishment_responsibility r
                WHERE r.establishment_id=e.establishment_id AND responsibility_type_id=5 AND is_current)<>1
               OR NOT EXISTS(SELECT 1 FROM migration.maintenance_source_observation o
                             WHERE o.establishment_id=e.establishment_id AND processing_status='accepted'))
    ) THEN RAISE EXCEPTION 'Stage 3: open eligible English schools lack one evidenced current maintainer; inspect source observations'; END IF;
    IF EXISTS (
        SELECT 1 FROM establishment.establishment_responsibility r
        JOIN establishment.establishment e USING(establishment_id)
        JOIN establishment.establishment_lifecycle l USING(establishment_id)
        JOIN establishment.establishment_geography g USING(establishment_id)
        JOIN establishment.local_authority_area a USING(local_authority_area_id)
        JOIN establishment.local_authority_jurisdiction j USING(local_authority_jurisdiction_id)
        WHERE r.responsibility_type_id=5 AND r.is_current AND
          (l.establishment_status_id NOT IN (1,3) OR e.establishment_type_id NOT IN (1,2,3,9,10,11,12,13)
           OR j.name<>'English' OR r.end_date IS NOT NULL)
    ) THEN RAISE EXCEPTION 'Stage 3: current maintenance on a closed, ineligible or Welsh school'; END IF;
    IF EXISTS (
        SELECT 1 FROM establishment.establishment_responsibility r
        JOIN establishment.legal_entity c USING(legal_entity_id)
        WHERE r.responsibility_type_id=5 AND (
          c.legal_entity_type_id IS DISTINCT FROM 9 OR r.person_id IS NOT NULL
          OR NOT EXISTS(SELECT 1 FROM establishment.local_authority_area_council_period p WHERE p.legal_entity_id=c.legal_entity_id)
          OR r.first_observed_date IS NULL
          OR (r.end_date IS NOT NULL AND r.start_date IS NOT NULL AND r.end_date<=r.start_date)
          OR (c.incorporation_date IS NOT NULL AND (r.start_date IS NULL OR r.start_date<c.incorporation_date))
          OR (c.dissolution_date IS NOT NULL AND (r.end_date IS NULL OR r.end_date>c.dissolution_date))
          OR NOT EXISTS(SELECT 1 FROM migration.maintenance_derivation d WHERE d.establishment_responsibility_id=r.establishment_responsibility_id)
          OR NOT EXISTS(SELECT 1 FROM migration.establishment_responsibility_evidence ev
                        JOIN migration.source_record sr USING(source_record_id)
                        JOIN migration.source_snapshot ss USING(source_snapshot_id)
                        LEFT JOIN migration.maintenance_source_observation o USING(source_record_id)
                        WHERE ev.establishment_responsibility_id=r.establishment_responsibility_id
                          AND ev.inference_rule IN ('maintenance-v1','council-reorganisation','reviewed-event-replay') AND ev.review_status='accepted'
                          AND ss.snapshot_date IS NOT NULL
                          AND (o.source_type_name IN ('Community school','Community special school','Foundation special school',
                          'Voluntary aided school','Voluntary controlled school','Foundation school','Pupil referral unit','Maintained nursery school')
                          OR EXISTS(SELECT 1 FROM migration.council_reorganisation ce
                              JOIN migration.council_reorganisation_lineage line USING(event_id)
                              WHERE ce.status='applied' AND ce.source_record_id=ev.source_record_id
                                AND line.entity_kind='establishment_responsibility' AND line.entity_id=r.establishment_responsibility_id)))
          OR r.first_observed_date IS DISTINCT FROM (
              SELECT coalesce(min(ev.first_observed_date) FILTER(WHERE ev.inference_rule='maintenance-v1'),
                              min(ev.first_observed_date) FILTER(WHERE ev.inference_rule='reviewed-event-replay' OR EXISTS(
                                  SELECT 1 FROM migration.council_reorganisation ce
                                  JOIN migration.council_reorganisation_lineage line USING(event_id)
                                  WHERE ce.status='applied' AND ce.source_record_id=ev.source_record_id AND line.action='created'
                                    AND line.entity_kind='establishment_responsibility' AND line.entity_id=r.establishment_responsibility_id)))
              FROM migration.establishment_responsibility_evidence ev
              WHERE ev.establishment_responsibility_id=r.establishment_responsibility_id)
        )
    ) THEN RAISE EXCEPTION 'Stage 3: maintenance holder, lifetime, period or derivation evidence is invalid'; END IF;
    IF EXISTS(SELECT 1 FROM establishment.establishment e WHERE NOT EXISTS (
              SELECT 1 FROM migration.maintenance_source_observation o WHERE o.establishment_id=e.establishment_id)) THEN
        RAISE EXCEPTION 'Stage 3: maintenance source coverage is incomplete';
    END IF;
    IF EXISTS(SELECT 1 FROM migration.maintenance_source_observation o
              JOIN establishment.establishment e USING(establishment_id)
              JOIN establishment.establishment_geography g USING(establishment_id)
              JOIN establishment.local_authority_area a USING(local_authority_area_id)
              JOIN establishment.local_authority_jurisdiction j USING(local_authority_jurisdiction_id)
              WHERE o.processing_status='review' AND j.name='English'
                AND (e.establishment_type_id IN (1,2,3,9,10,11,12,13)
                     OR o.source_type_name IN ('Community school','Community special school','Foundation special school',
                       'Voluntary aided school','Voluntary controlled school','Foundation school','Pupil referral unit','Maintained nursery school')))
    THEN RAISE EXCEPTION 'Stage 3: eligible maintenance source assertions remain staged for review'; END IF;
END $$;

SELECT 'PASS: Stage 3 maintenance responsibilities' AS result,
       count(*) AS maintenance_periods,count(*) FILTER(WHERE is_current) AS current_periods
FROM establishment.establishment_responsibility WHERE responsibility_type_id=5;

SELECT e.urn,e.name,c.name AS council,r.start_date,r.end_date,r.end_date_basis,r.is_current,r.first_observed_date
FROM establishment.establishment_responsibility r JOIN establishment.establishment e USING(establishment_id)
JOIN establishment.legal_entity c USING(legal_entity_id) WHERE responsibility_type_id=5 ORDER BY e.urn,r.start_date;

-- Warnings are visible. An ineligible controlled-fixture mismatch is not
-- silently promoted to an accepted maintenance assertion.
SELECT e.urn,o.processing_status,o.processing_note
FROM migration.maintenance_source_observation o JOIN establishment.establishment e USING(establishment_id)
WHERE o.processing_status IN ('review','welsh_excluded') ORDER BY e.urn;

SELECT e.urn,'Current maintainer differs from geographic-area council: review' AS warning
FROM establishment.establishment_responsibility r JOIN establishment.establishment e USING(establishment_id)
JOIN establishment.establishment_geography g USING(establishment_id)
WHERE r.responsibility_type_id=5 AND r.is_current AND NOT EXISTS (
    SELECT 1 FROM establishment.local_authority_area_council_period p
    WHERE p.local_authority_area_id=g.local_authority_area_id AND p.is_current AND p.legal_entity_id=r.legal_entity_id);
COMMIT;
