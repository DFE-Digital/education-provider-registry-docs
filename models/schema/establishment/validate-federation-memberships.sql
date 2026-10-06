-- T4: two maintained schools in one federation, not a legal entity.
DO $$
DECLARE
    federation_id uuid;
BEGIN
    SELECT i.organisation_group_id INTO STRICT federation_id
    FROM establishment.group_identifier i
    JOIN establishment.group_identifier_type t USING (group_identifier_type_id)
    JOIN establishment.group_identifier_issuer issuer USING (group_identifier_issuer_id)
    WHERE t.name='Group UID' AND issuer.name='GIAS' AND i.value='1809'
      AND i.is_current AND i.establishment_party_role_id IS NULL;
    IF NOT EXISTS (SELECT 1 FROM establishment.organisation_group g
                   JOIN establishment.organisation_group_type t USING (organisation_group_type_id)
                   WHERE g.organisation_group_id=federation_id AND t.name='Federation'
                     AND g.name='Federation of Eileen Wade and Milton Ernest VC lower schools'
                     AND g.open_date=DATE '2011-01-13' AND g.close_date IS NULL) THEN
        RAISE EXCEPTION 'T4 federation identity, type or dates incorrect';
    END IF;
    IF (SELECT count(*) FROM establishment.organisation_group_member WHERE organisation_group_id=federation_id) <> 2
       OR (SELECT count(*) FROM establishment.organisation_group_member m
           JOIN establishment.establishment e USING (establishment_id)
           WHERE m.organisation_group_id=federation_id AND e.urn IN (109443,109613)
             AND m.joined_date=DATE '2011-01-13' AND m.left_date IS NULL AND m.is_lead_member IS NULL) <> 2 THEN
        RAISE EXCEPTION 'T4 requires exactly the two selected schools with independently evidenced joined dates';
    END IF;
    IF (SELECT count(*) FROM establishment.group_identifier WHERE organisation_group_id=federation_id) <> 1
       OR EXISTS (SELECT 1 FROM establishment.establishment_responsibility r
                  JOIN establishment.establishment e USING (establishment_id) WHERE e.urn IN (109443,109613)) THEN
        RAISE EXCEPTION 'T4 must not invent Group ID or load trust responsibilities';
    END IF;
    IF (SELECT count(*) FROM migration.organisation_group_member_evidence evidence
        JOIN establishment.organisation_group_member m USING (organisation_group_member_id)
        JOIN establishment.establishment e USING (establishment_id)
        JOIN migration.source_record s USING (source_record_id)
        JOIN migration.source_snapshot snapshot USING (source_snapshot_id)
        JOIN migration.migration_run run USING (migration_run_id)
        WHERE m.organisation_group_id=federation_id AND s.source_group_id='1809'
          AND ((e.urn=109443 AND s.source_key='1928') OR (e.urn=109613 AND s.source_key='1929'))
          AND s.source_urn=e.urn AND evidence.left_date_basis IS NULL
          AND evidence.notes LIKE '%archived=0%' AND run.run_type='establishment-rebuild') <> 2 THEN
        RAISE EXCEPTION 'T4 requires source-link evidence for each member beneath the rebuild run';
    END IF;
END $$;
