-- Validate the T1 and T2 responsibility history, the T3 consolidated
-- SAT-to-MAT classification transition, and the T16
-- closed-lifecycle responsibility with an inferred end date.
-- T1/T2 classification dates remain null because BAU supplies relationship
-- dates rather than independently evidenced legal-entity classification
-- boundaries. T16 has an evidenced closed group boundary.

DO $$
DECLARE
    actual_count integer;
    sat_entity_id uuid;
    mat_entity_id uuid;
    sponsor_entity_id uuid;
BEGIN
    SELECT identifier.legal_entity_id INTO STRICT sat_entity_id
    FROM establishment.organisation_identifier AS identifier
    JOIN establishment.organisation_identifier_type AS identifier_type
      USING (organisation_identifier_type_id)
    WHERE identifier_type.name = 'Companies House number'
      AND identifier.value = '07158839' AND identifier.is_current;

    SELECT identifier.legal_entity_id INTO STRICT mat_entity_id
    FROM establishment.organisation_identifier AS identifier
    JOIN establishment.organisation_identifier_type AS identifier_type
      USING (organisation_identifier_type_id)
    WHERE identifier_type.name = 'Companies House number'
      AND identifier.value = '07747126' AND identifier.is_current;

    IF sat_entity_id = mat_entity_id THEN
        RAISE EXCEPTION 'T1 SAT 2779 and MAT 2777 must be separate legal entities';
    END IF;

    SELECT role.legal_entity_id INTO STRICT sponsor_entity_id
    FROM establishment.group_identifier AS identifier
    JOIN establishment.group_identifier_type AS identifier_type USING (group_identifier_type_id)
    JOIN establishment.group_identifier_issuer AS issuer USING (group_identifier_issuer_id)
    JOIN establishment.establishment_party_role AS role USING (establishment_party_role_id)
    JOIN establishment.establishment_party_role_type AS role_type USING (establishment_party_role_type_id)
    WHERE issuer.name = 'GIAS' AND identifier_type.name = 'Group UID'
      AND identifier.value = '4949' AND identifier.is_current
      AND role_type.name = 'School sponsor';

    IF sponsor_entity_id IN (sat_entity_id, mat_entity_id) THEN
        RAISE EXCEPTION 'T1 sponsor 4949 must be separate from both academy-trust legal entities';
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM establishment.legal_entity
        WHERE legal_entity_id = sponsor_entity_id AND name = 'The Co-operative Group'
          AND incorporation_date IS NULL
    ) OR EXISTS (
        SELECT 1 FROM establishment.organisation_identifier AS identifier
        JOIN establishment.organisation_identifier_type AS identifier_type USING (organisation_identifier_type_id)
        WHERE identifier.legal_entity_id = sponsor_entity_id
          AND identifier_type.name IN ('Companies House number', 'UKPRN')
    ) OR EXISTS (
        SELECT 1 FROM establishment.academy_trust_classification
        WHERE legal_entity_id = sponsor_entity_id
    ) THEN
        RAISE EXCEPTION 'T1 sponsor must retain its source name without invented incorporation, company, UKPRN or trust classification';
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM establishment.establishment_responsibility AS responsibility
        JOIN establishment.establishment AS establishment USING (establishment_id)
        JOIN establishment.establishment_responsibility_type AS responsibility_type USING (responsibility_type_id)
        WHERE establishment.urn = 136102 AND responsibility.legal_entity_id = sponsor_entity_id
          AND responsibility_type.name = 'Sponsored by'
          AND responsibility.start_date = DATE '2010-09-01'
          AND responsibility.end_date IS NULL AND responsibility.is_current
    ) OR NOT EXISTS (
        SELECT 1 FROM establishment.group_identifier AS identifier
        JOIN establishment.group_identifier_type AS identifier_type USING (group_identifier_type_id)
        JOIN establishment.establishment_party_role AS role USING (establishment_party_role_id)
        WHERE role.legal_entity_id = sponsor_entity_id
          AND identifier_type.name = 'Group ID' AND identifier.value = 'SP00125'
          AND identifier.is_current
    ) THEN
        RAISE EXCEPTION 'T1 expected sponsor responsibility from 2010-09-01 and sponsor Group ID SP00125';
    END IF;

    SELECT count(*) INTO actual_count
    FROM establishment.establishment_responsibility AS responsibility
    JOIN establishment.establishment AS establishment
      ON establishment.establishment_id = responsibility.establishment_id
    WHERE establishment.urn = 136102;

    IF actual_count <> 3 THEN
        RAISE EXCEPTION 'T1 expected three responsibilities for URN 136102 but found %', actual_count;
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM establishment.establishment_responsibility AS responsibility
        JOIN establishment.establishment AS establishment
          ON establishment.establishment_id = responsibility.establishment_id
        JOIN establishment.academy_trust_type AS trust_type
          ON trust_type.academy_trust_type_id = responsibility.academy_trust_type_id
        WHERE establishment.urn = 136102
          AND responsibility.legal_entity_id = mat_entity_id
          AND responsibility.responsibility_type_id = 1
          AND trust_type.name = 'Multi-academy trust'
          AND responsibility.start_date = DATE '2015-07-01'
          AND responsibility.is_current
    ) THEN
        RAISE EXCEPTION 'T1 expected the current MAT responsibility from 2015-07-01';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM establishment.establishment_responsibility AS responsibility
        JOIN establishment.establishment AS establishment
          ON establishment.establishment_id = responsibility.establishment_id
        JOIN establishment.academy_trust_type AS trust_type
          ON trust_type.academy_trust_type_id = responsibility.academy_trust_type_id
        WHERE establishment.urn = 136102
          AND responsibility.legal_entity_id = sat_entity_id
          AND responsibility.responsibility_type_id = 1
          AND trust_type.name = 'Single-academy trust'
          AND responsibility.start_date = DATE '2010-09-01'
          AND responsibility.end_date IS NULL
          AND NOT responsibility.is_current
    ) THEN
        RAISE EXCEPTION 'T1 expected the historical SAT responsibility from 2010-09-01';
    END IF;

    IF (SELECT count(*) FROM establishment.academy_trust_classification
        WHERE legal_entity_id = sat_entity_id) <> 1
       OR (SELECT count(*) FROM establishment.academy_trust_classification
        WHERE legal_entity_id = mat_entity_id) <> 1
       OR EXISTS (
           SELECT 1 FROM establishment.academy_trust_classification AS classification
           JOIN establishment.academy_trust_type AS trust_type USING (academy_trust_type_id)
           WHERE (classification.legal_entity_id = sat_entity_id AND trust_type.name <> 'Single-academy trust')
              OR (classification.legal_entity_id = mat_entity_id AND trust_type.name <> 'Multi-academy trust')
       ) THEN
        RAISE EXCEPTION 'T1 requires one SAT classification on the former company and one MAT classification on the current company';
    END IF;

    IF (SELECT count(*) FROM establishment.organisation_identifier AS identifier
        JOIN establishment.organisation_identifier_type AS identifier_type USING (organisation_identifier_type_id)
        WHERE identifier_type.name = 'UKPRN' AND identifier.is_current
          AND ((identifier.legal_entity_id = sat_entity_id AND identifier.value = '10061289')
            OR (identifier.legal_entity_id = mat_entity_id AND identifier.value = '10059286'))) <> 2 THEN
        RAISE EXCEPTION 'T1 must preserve the distinct SAT and MAT UKPRNs';
    END IF;

    IF (SELECT count(*) FROM establishment.group_identifier AS identifier
        JOIN establishment.group_identifier_type AS identifier_type USING (group_identifier_type_id)
        JOIN establishment.establishment_party_role AS role USING (establishment_party_role_id)
        JOIN establishment.establishment_party_role_type AS role_type USING (establishment_party_role_type_id)
        WHERE role_type.name = 'Academy trust' AND (
            (role.legal_entity_id = sat_entity_id AND identifier_type.name = 'Group UID' AND identifier.value = '2779' AND NOT identifier.is_current)
            OR (role.legal_entity_id = sat_entity_id AND identifier_type.name = 'Group ID' AND identifier.value = 'TR00569' AND NOT identifier.is_current)
            OR (role.legal_entity_id = mat_entity_id AND identifier_type.name = 'Group UID' AND identifier.value = '2777' AND identifier.is_current)
            OR (role.legal_entity_id = mat_entity_id AND identifier_type.name = 'Group ID' AND identifier.value = 'TR00567' AND identifier.is_current)
        )) <> 4 THEN
        RAISE EXCEPTION 'T1 group identifiers must belong to their respective SAT and MAT roles';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM establishment.establishment_responsibility AS responsibility
        JOIN establishment.establishment AS establishment
          ON establishment.establishment_id = responsibility.establishment_id
        WHERE establishment.urn = 136102
          AND responsibility.responsibility_type_id <> 1
          AND responsibility.academy_trust_type_id IS NOT NULL
    ) THEN
        RAISE EXCEPTION 'T1 non-academy-trust responsibilities must not have an academy-trust type';
    END IF;
END
$$;

DO $$
DECLARE
    actual_count integer;
BEGIN
    SELECT count(*) INTO actual_count
    FROM establishment.establishment_responsibility AS responsibility
    JOIN establishment.establishment AS establishment
      ON establishment.establishment_id = responsibility.establishment_id
    WHERE establishment.urn = 135905;

    IF actual_count <> 1 THEN
        RAISE EXCEPTION 'T16 expected one responsibility for URN 135905 but found %', actual_count;
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM establishment.establishment_responsibility AS responsibility
        JOIN establishment.establishment AS establishment
          ON establishment.establishment_id = responsibility.establishment_id
        JOIN establishment.academy_trust_type AS trust_type
          ON trust_type.academy_trust_type_id = responsibility.academy_trust_type_id
        WHERE establishment.urn = 135905
          AND responsibility.responsibility_type_id = 1
          AND trust_type.name = 'Multi-academy trust'
          AND responsibility.start_date = DATE '2009-09-01'
          AND responsibility.end_date = DATE '2016-02-29'
          AND NOT responsibility.is_current
    ) THEN
        RAISE EXCEPTION 'T16 expected an inferred closed MAT responsibility from 2009-09-01 to 2016-02-29';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM establishment.establishment_responsibility AS responsibility
        JOIN establishment.establishment AS establishment
          ON establishment.establishment_id = responsibility.establishment_id
        JOIN migration.establishment_responsibility_evidence AS evidence
          ON evidence.establishment_responsibility_id = responsibility.establishment_responsibility_id
        WHERE establishment.urn = 135905
          AND responsibility.start_date = DATE '2009-09-01'
          AND responsibility.end_date = DATE '2016-02-29'
          AND evidence.end_date_basis = 'inferred'
    ) THEN
        RAISE EXCEPTION 'T16 expected migration evidence for an inferred responsibility end date';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM establishment.establishment_party_role AS role
        JOIN establishment.establishment_party_role_type AS role_type
          ON role_type.establishment_party_role_type_id = role.establishment_party_role_type_id
        JOIN establishment.legal_entity AS legal_entity
          ON legal_entity.legal_entity_id = role.legal_entity_id
        JOIN establishment.organisation_identifier AS identifier
          ON identifier.legal_entity_id = legal_entity.legal_entity_id
        JOIN establishment.organisation_identifier_type AS identifier_type
          ON identifier_type.organisation_identifier_type_id = identifier.organisation_identifier_type_id
        WHERE legal_entity.name = 'MARCH 2016 LIMITED'
          AND role_type.name = 'Academy trust'
          AND identifier_type.name = 'Companies House number'
          AND identifier.value = '06888873'
          AND role.end_date = DATE '2016-02-29'
    ) THEN
        RAISE EXCEPTION 'T16 expected the closed MARCH 2016 LIMITED academy-trust role';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM establishment.academy_trust_classification AS classification
        JOIN establishment.legal_entity AS legal_entity
          ON legal_entity.legal_entity_id = classification.legal_entity_id
        JOIN establishment.academy_trust_type AS trust_type
          ON trust_type.academy_trust_type_id = classification.academy_trust_type_id
        WHERE legal_entity.name = 'MARCH 2016 LIMITED'
          AND trust_type.name = 'Multi-academy trust'
          AND NOT classification.is_current
          AND classification.start_date IS NULL
          AND classification.end_date = DATE '2016-02-29'
    ) THEN
        RAISE EXCEPTION 'T16 expected a non-current MAT classification ending 2016-02-29';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM establishment.legal_entity AS legal_entity
        JOIN establishment.legal_entity_type AS entity_type
          ON entity_type.legal_entity_type_id = legal_entity.legal_entity_type_id
        WHERE legal_entity.name = 'MARCH 2016 LIMITED'
          AND entity_type.name = 'Charitable company limited by guarantee'
    ) THEN
        RAISE EXCEPTION 'T16 expected MR011 legal-entity type classification';
    END IF;
END
$$;

DO $$
DECLARE
    actual_count integer;
BEGIN
    SELECT count(*) INTO actual_count
    FROM establishment.establishment_responsibility AS responsibility
    JOIN establishment.establishment AS establishment
      ON establishment.establishment_id = responsibility.establishment_id
    WHERE establishment.urn = 134314;

    IF actual_count <> 3 THEN
        RAISE EXCEPTION 'T2 expected three responsibilities for URN 134314 but found %', actual_count;
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM establishment.establishment_responsibility AS responsibility
        JOIN establishment.establishment AS establishment
          ON establishment.establishment_id = responsibility.establishment_id
        JOIN establishment.academy_trust_type AS trust_type
          ON trust_type.academy_trust_type_id = responsibility.academy_trust_type_id
        WHERE establishment.urn = 134314
          AND responsibility.responsibility_type_id = 1
          AND trust_type.name = 'Multi-academy trust'
          AND responsibility.start_date = DATE '2021-10-04'
          AND responsibility.is_current
    ) THEN
        RAISE EXCEPTION 'T2 expected the current MAT responsibility from 2021-10-04';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM establishment.establishment_responsibility AS responsibility
        JOIN establishment.establishment AS establishment
          ON establishment.establishment_id = responsibility.establishment_id
        JOIN establishment.academy_trust_type AS trust_type
          ON trust_type.academy_trust_type_id = responsibility.academy_trust_type_id
        WHERE establishment.urn = 134314
          AND responsibility.responsibility_type_id = 1
          AND trust_type.name = 'Single-academy trust'
          AND responsibility.start_date = DATE '2007-09-01'
          AND NOT responsibility.is_current
    ) THEN
        RAISE EXCEPTION 'T2 expected the historical SAT responsibility from 2007-09-01';
    END IF;
END
$$;

DO $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM establishment.academy_trust_classification AS classification
        JOIN establishment.establishment_responsibility AS responsibility
          ON responsibility.legal_entity_id = classification.legal_entity_id
        JOIN establishment.establishment AS establishment
          ON establishment.establishment_id = responsibility.establishment_id
        WHERE establishment.urn IN (136102, 134314)
          AND (classification.start_date IS NOT NULL
           OR classification.end_date IS NOT NULL)
    ) THEN
        RAISE EXCEPTION 'T1/T2 academy-trust classification dates must remain null';
    END IF;

    IF EXISTS (
        SELECT legal_entity_id
        FROM establishment.academy_trust_classification
        WHERE legal_entity_id IN (
            SELECT DISTINCT responsibility.legal_entity_id
            FROM establishment.establishment_responsibility AS responsibility
            JOIN establishment.establishment AS establishment
              ON establishment.establishment_id = responsibility.establishment_id
            WHERE establishment.urn IN (136102, 134314)
              AND responsibility.responsibility_type_id = 1
              AND responsibility.is_current
        )
        GROUP BY legal_entity_id
        HAVING count(*) FILTER (WHERE is_current) <> 1
    ) THEN
        RAISE EXCEPTION 'Each T1/T2 academy-trust legal entity must have exactly one current classification';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM establishment.establishment_responsibility AS responsibility
        JOIN establishment.academy_trust_classification AS classification
          ON classification.legal_entity_id = responsibility.legal_entity_id
         AND classification.academy_trust_type_id = responsibility.academy_trust_type_id
        WHERE responsibility.responsibility_type_id = 1
          AND responsibility.is_current <> classification.is_current
    ) THEN
        RAISE EXCEPTION 'Current academy responsibilities must agree with their legal entity current classification';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM establishment.academy_trust_classification AS classification
        WHERE classification.is_current
          AND NOT EXISTS (
              SELECT 1
              FROM migration.academy_trust_classification_evidence AS evidence
              WHERE evidence.academy_trust_classification_id = classification.academy_trust_classification_id
                AND evidence.assertion_rule = 'MR001'
          )
    ) THEN
        RAISE EXCEPTION 'Each current academy-trust classification requires MR001 migration evidence';
    END IF;
END
$$;

-- T3: an explicit SAT-to-MAT transition within one continuing legal entity.
DO $$
DECLARE
    entity_id uuid;
    role_id uuid;
    sat_responsibility_id uuid;
    mat_responsibility_id uuid;
BEGIN
    SELECT identifier.legal_entity_id INTO STRICT entity_id
    FROM establishment.organisation_identifier AS identifier
    JOIN establishment.organisation_identifier_type AS identifier_type
      ON identifier_type.organisation_identifier_type_id = identifier.organisation_identifier_type_id
    WHERE identifier_type.name = 'Companies House number'
      AND identifier.value = '07795736' AND identifier.is_current;

    SELECT role.establishment_party_role_id INTO STRICT role_id
    FROM establishment.establishment_party_role AS role
    JOIN establishment.establishment_party_role_type AS role_type
      ON role_type.establishment_party_role_type_id = role.establishment_party_role_type_id
    WHERE role.legal_entity_id = entity_id AND role_type.name = 'Academy trust'
      AND role.start_date IS NULL AND role.end_date IS NULL;

    IF (SELECT count(*) FROM establishment.establishment_responsibility AS r
        JOIN establishment.establishment AS e ON e.establishment_id = r.establishment_id
        WHERE e.urn = 137603) <> 2 THEN
        RAISE EXCEPTION 'T3 requires separate SAT and MAT responsibilities for Ridgewood School';
    END IF;

    SELECT r.establishment_responsibility_id INTO STRICT sat_responsibility_id
    FROM establishment.establishment_responsibility AS r
    JOIN establishment.establishment AS e ON e.establishment_id = r.establishment_id
    JOIN establishment.academy_trust_type AS trust_type ON trust_type.academy_trust_type_id = r.academy_trust_type_id
    WHERE e.urn = 137603 AND r.legal_entity_id = entity_id
      AND r.responsibility_type_id = 1 AND trust_type.name = 'Single-academy trust'
      AND r.start_date = DATE '2011-11-01' AND r.end_date IS NULL AND NOT r.is_current;

    SELECT r.establishment_responsibility_id INTO STRICT mat_responsibility_id
    FROM establishment.establishment_responsibility AS r
    JOIN establishment.establishment AS e ON e.establishment_id = r.establishment_id
    JOIN establishment.academy_trust_type AS trust_type ON trust_type.academy_trust_type_id = r.academy_trust_type_id
    WHERE e.urn = 137603 AND r.legal_entity_id = entity_id
      AND r.responsibility_type_id = 1 AND trust_type.name = 'Multi-academy trust'
      AND r.start_date = DATE '2021-03-30' AND r.end_date IS NULL AND r.is_current;

    IF (SELECT count(*) FROM establishment.academy_trust_classification
        WHERE legal_entity_id = entity_id) <> 2 OR NOT EXISTS (
        SELECT 1 FROM establishment.academy_trust_classification AS c
        JOIN establishment.academy_trust_type AS t ON t.academy_trust_type_id = c.academy_trust_type_id
        WHERE c.legal_entity_id = entity_id AND t.name = 'Single-academy trust'
          AND c.start_date IS NULL AND c.end_date = DATE '2021-03-30' AND NOT c.is_current
    ) OR NOT EXISTS (
        SELECT 1 FROM establishment.academy_trust_classification AS c
        JOIN establishment.academy_trust_type AS t ON t.academy_trust_type_id = c.academy_trust_type_id
        WHERE c.legal_entity_id = entity_id AND t.name = 'Multi-academy trust'
          AND c.start_date = DATE '2021-03-30' AND c.end_date IS NULL AND c.is_current
    ) THEN
        RAISE EXCEPTION 'T3 requires historical SAT and current MAT classifications meeting at 2021-03-30';
    END IF;

    IF (SELECT count(*) FROM establishment.group_identifier AS i
        JOIN establishment.group_identifier_type AS t ON t.group_identifier_type_id = i.group_identifier_type_id
        WHERE i.establishment_party_role_id = role_id AND (
            (t.name = 'Group UID' AND i.value = '2055' AND NOT i.is_current)
            OR (t.name = 'Group UID' AND i.value = '20364' AND i.is_current)
            OR (t.name = 'Group ID' AND i.value = 'TR00009' AND i.is_current)
        )) <> 3 THEN
        RAISE EXCEPTION 'T3 requires both UIDs and the current shared Group ID on the same role';
    END IF;

    IF (SELECT count(DISTINCT source.source_group_id)
        FROM migration.establishment_responsibility_evidence AS evidence
        JOIN migration.source_record AS source ON source.source_record_id = evidence.source_record_id
        WHERE ((evidence.establishment_responsibility_id = sat_responsibility_id AND source.source_group_id = '2055')
            OR (evidence.establishment_responsibility_id = mat_responsibility_id AND source.source_group_id = '20364'))
          AND evidence.end_date_basis IS NULL
          AND evidence.notes LIKE '%GroupRelationsLink 547%') <> 2
       OR (SELECT count(DISTINCT source.source_group_id)
        FROM migration.identity_resolution AS resolution
        JOIN migration.source_record AS source ON source.source_record_id = resolution.source_record_id
        WHERE resolution.target_entity_id = entity_id AND resolution.target_entity_type = 'legal_entity'
          AND source.source_group_id IN ('2055', '20364') AND resolution.decision_status = 'accepted') <> 2 THEN
        RAISE EXCEPTION 'T3 requires source and identity-resolution evidence from both group records';
    END IF;
END
$$;

SELECT establishment.urn,
       legal_entity.name AS legal_entity_name,
       responsibility_type.name AS responsibility_type,
       academy_trust_type.name AS academy_trust_type,
       responsibility.start_date,
       responsibility.end_date,
       responsibility.is_current
FROM establishment.establishment_responsibility AS responsibility
JOIN establishment.establishment AS establishment
  ON establishment.establishment_id = responsibility.establishment_id
LEFT JOIN establishment.legal_entity AS legal_entity
  ON legal_entity.legal_entity_id = responsibility.legal_entity_id
JOIN establishment.establishment_responsibility_type AS responsibility_type
  ON responsibility_type.responsibility_type_id = responsibility.responsibility_type_id
LEFT JOIN establishment.academy_trust_type AS academy_trust_type
  ON academy_trust_type.academy_trust_type_id = responsibility.academy_trust_type_id
WHERE establishment.urn IN (136102, 134314, 135905, 137603)
ORDER BY establishment.urn, responsibility.start_date;
