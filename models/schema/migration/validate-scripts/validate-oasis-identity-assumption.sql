-- T11R: selected Oasis slice only. No target writes.
DO $$
DECLARE
    party uuid;
    school uuid;
BEGIN
    SELECT establishment_id INTO STRICT school FROM establishment.establishment
    WHERE urn=134311 AND name='Oasis Academy Enfield' AND ukprn=10021087;
    SELECT i.legal_entity_id INTO STRICT party
    FROM establishment.organisation_identifier i
    JOIN establishment.organisation_identifier_type t USING (organisation_identifier_type_id)
    WHERE t.name='Companies House number' AND i.value='05398529' AND i.is_current;
    IF NOT EXISTS (SELECT 1 FROM establishment.legal_entity
                   WHERE legal_entity_id=party AND name='OASIS COMMUNITY LEARNING'
                     AND incorporation_date=DATE '2005-03-18' AND dissolution_date IS NULL)
       OR NOT EXISTS (
           SELECT 1 FROM establishment.organisation_identifier i
           JOIN establishment.organisation_identifier_type t USING (organisation_identifier_type_id)
           WHERE i.legal_entity_id=party AND t.name='UKPRN' AND i.value='10058190' AND i.is_current
       ) THEN RAISE EXCEPTION 'T11R legal entity or identifier ownership is incorrect'; END IF;
    IF (SELECT count(*) FROM establishment.establishment_party_role WHERE legal_entity_id=party)<>2
       OR (SELECT count(*) FROM establishment.establishment_responsibility WHERE establishment_id=school)<>2
    THEN RAISE EXCEPTION 'T11R requires exactly two roles and two responsibilities'; END IF;
    IF EXISTS (
        SELECT 1 FROM (VALUES ('4076','TR01553','Academy trust','Run by academy trust','Multi-academy trust'),
                              ('4075','SP00392','School sponsor','Sponsored by',NULL))
             expected(uid,gid,role_name,responsibility_name,trust_name)
        WHERE NOT EXISTS (
            SELECT 1 FROM establishment.establishment_party_role role
            JOIN establishment.establishment_party_role_type role_type USING (establishment_party_role_type_id)
            JOIN establishment.establishment_responsibility r ON r.legal_entity_id=role.legal_entity_id
            JOIN establishment.establishment_responsibility_type rt USING (responsibility_type_id)
            LEFT JOIN establishment.academy_trust_type tt USING (academy_trust_type_id)
            WHERE role.legal_entity_id=party AND role_type.name=expected.role_name
              AND role.start_date IS NULL AND role.end_date IS NULL
              AND r.establishment_id=school AND rt.name=expected.responsibility_name
              AND tt.name IS NOT DISTINCT FROM expected.trust_name
              AND r.start_date=DATE '2007-09-01' AND r.end_date IS NULL AND r.is_current
              AND (SELECT count(*) FROM establishment.group_identifier i
                   JOIN establishment.group_identifier_type t USING (group_identifier_type_id)
                   JOIN establishment.group_identifier_issuer issuer USING (group_identifier_issuer_id)
                   WHERE i.establishment_party_role_id=role.establishment_party_role_id AND i.is_current
                     AND issuer.name='GIAS' AND ((t.name='Group UID' AND i.value=expected.uid)
                                            OR (t.name='Group ID' AND i.value=expected.gid)))=2
        )
    ) THEN RAISE EXCEPTION 'T11R roles, responsibility dates/types or GIAS identifiers differ'; END IF;
    IF (SELECT count(*) FROM establishment.academy_trust_classification WHERE legal_entity_id=party)<>1
       OR NOT EXISTS (
          SELECT 1 FROM establishment.academy_trust_classification c
          JOIN establishment.academy_trust_type t USING (academy_trust_type_id)
          WHERE c.legal_entity_id=party AND t.name='Multi-academy trust'
            AND c.is_current AND c.start_date IS NULL AND c.end_date IS NULL
       ) THEN RAISE EXCEPTION 'T11R MAT classification boundaries differ'; END IF;
    IF (SELECT count(DISTINCT sr.source_group_id)
        FROM migration.identity_resolution ir
        JOIN migration.source_record sr USING (source_record_id)
        WHERE sr.source_urn=134311 AND sr.source_group_id IN ('4075','4076')
          AND ir.target_entity_id=party AND ir.decision_status='accepted'
          AND ir.resolution_method='accepted-test-case-identity-assumption' AND ir.confidence='assumed'
          AND ir.rationale LIKE 'T11R accepted test-case identity assumption:%')<>2
    THEN RAISE EXCEPTION 'T11R must retain the accepted assumption for both source records'; END IF;
END $$;
SELECT 'T11R Oasis identity assumption checks passed' AS result;
