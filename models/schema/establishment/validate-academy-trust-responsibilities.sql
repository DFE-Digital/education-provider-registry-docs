-- Validate the T1 and T2 SAT-to-MAT responsibility history.
-- Classification dates remain null because BAU supplies relationship dates,
-- rather than independently evidenced legal-entity classification boundaries.

DO $$
DECLARE
    actual_count integer;
BEGIN
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
          AND responsibility.responsibility_type_id = 1
          AND trust_type.name = 'Single-academy trust'
          AND responsibility.start_date = DATE '2010-09-01'
          AND NOT responsibility.is_current
    ) THEN
        RAISE EXCEPTION 'T1 expected the historical SAT responsibility from 2010-09-01';
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
        WHERE classification.start_date IS NOT NULL
           OR classification.end_date IS NOT NULL
    ) THEN
        RAISE EXCEPTION 'T1/T2 academy-trust classification dates must remain null';
    END IF;

    IF EXISTS (
        SELECT legal_entity_id
        FROM establishment.academy_trust_classification
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
JOIN establishment.responsibility_type AS responsibility_type
  ON responsibility_type.responsibility_type_id = responsibility.responsibility_type_id
LEFT JOIN establishment.academy_trust_type AS academy_trust_type
  ON academy_trust_type.academy_trust_type_id = responsibility.academy_trust_type_id
WHERE establishment.urn IN (136102, 134314)
ORDER BY establishment.urn, responsibility.start_date;
