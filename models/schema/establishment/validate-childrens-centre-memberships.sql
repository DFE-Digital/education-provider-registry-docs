-- T5: all nine Southend children's centres, including one explicit lead member.
DO $$
DECLARE
    group_id uuid;
BEGIN
    SELECT i.organisation_group_id INTO STRICT group_id
    FROM establishment.group_identifier i
    JOIN establishment.group_identifier_type t USING (group_identifier_type_id)
    JOIN establishment.group_identifier_issuer issuer USING (group_identifier_issuer_id)
    WHERE t.name='Group UID' AND issuer.name='GIAS' AND i.value='86052'
      AND i.is_current AND i.establishment_party_role_id IS NULL;
    IF NOT EXISTS (
        SELECT 1 FROM establishment.organisation_group g
        JOIN establishment.organisation_group_type t USING (organisation_group_type_id)
        JOIN establishment.local_authority la USING (local_authority_id)
        WHERE g.organisation_group_id=group_id AND t.name='Children''s-centre group'
          AND g.name='Southend Children''s Centres' AND la.code=882
          AND g.open_date=DATE '2016-10-01' AND g.close_date IS NULL
    ) THEN RAISE EXCEPTION 'T5 group identity, type, authority or lifecycle dates incorrect'; END IF;
    IF (SELECT count(*) FROM establishment.organisation_group_member WHERE organisation_group_id=group_id) <> 9
       OR (SELECT count(*) FROM establishment.organisation_group_member m
           JOIN establishment.establishment e USING (establishment_id)
           JOIN establishment.establishment_type t USING (establishment_type_id)
           WHERE m.organisation_group_id=group_id
             AND e.urn IN (20338,20549,20614,21363,22422,22459,22975,23004,23122)
             AND t.name='Children''s centre' AND m.joined_date=DATE '2016-10-01'
             AND m.left_date IS NULL AND m.is_lead_member IS NOT DISTINCT FROM (e.urn=20549)) <> 9 THEN
        RAISE EXCEPTION 'T5 requires exactly nine centres with only Cambridge Road marked as lead';
    END IF;
    IF (SELECT count(*) FROM establishment.group_identifier WHERE organisation_group_id=group_id) <> 1
       OR EXISTS (SELECT 1 FROM establishment.establishment_responsibility r
                  JOIN establishment.establishment e USING (establishment_id)
                  WHERE e.urn IN (20338,20549,20614,21363,22422,22459,22975,23004,23122)) THEN
        RAISE EXCEPTION 'T5 must not invent Group ID or establishment responsibilities';
    END IF;
    IF (SELECT count(*) FROM migration.organisation_group_member_evidence evidence
        JOIN establishment.organisation_group_member m USING (organisation_group_member_id)
        JOIN establishment.establishment e USING (establishment_id)
        JOIN migration.source_record s USING (source_record_id)
        JOIN migration.source_snapshot snapshot USING (source_snapshot_id)
        JOIN migration.migration_run run USING (migration_run_id)
        JOIN (VALUES (20338,'25390'),(20549,'25391'),(20614,'25392'),(21363,'25395'),
                     (22422,'25396'),(22459,'25394'),(22975,'25397'),(23004,'25393'),(23122,'25398'))
             expected(urn,source_key) ON expected.urn=e.urn AND expected.source_key=s.source_key
        WHERE m.organisation_group_id=group_id AND s.source_group_id='86052' AND s.source_urn=e.urn
          AND evidence.left_date_basis IS NULL AND evidence.notes LIKE '%archived=0%'
          AND evidence.notes LIKE CASE WHEN e.urn=20549 THEN '%ccLinkType=LEAD;%' ELSE '%ccLinkType=STANDARD;%' END
          AND run.run_type='establishment-rebuild') <> 9 THEN
        RAISE EXCEPTION 'T5 requires the correct source-link and lead-code evidence under the rebuild run';
    END IF;
END $$;
