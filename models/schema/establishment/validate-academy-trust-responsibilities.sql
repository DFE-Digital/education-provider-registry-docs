-- T20: MARCH 2016 LIMITED, source group 3839, remains linked to the closed
-- Manchester Creative and Media Academy (URN 135905). It becomes one academy-
-- trust role, one MAT classification and one run-by responsibility.
DO $$
DECLARE
    actual_count integer;
BEGIN
    SELECT count(*) INTO actual_count
    FROM establishment.establishment_responsibility AS er
    JOIN establishment.establishment AS e
      ON e.establishment_id = er.establishment_id
    JOIN establishment.legal_entity AS le
      ON le.legal_entity_id = er.legal_entity_id
    JOIN establishment.establishment_party_role AS role
      ON role.legal_entity_id = le.legal_entity_id
    JOIN establishment.establishment_party_role_type AS role_type
      ON role_type.establishment_party_role_type_id = role.establishment_party_role_type_id
    JOIN establishment.academy_trust_classification AS classification
      ON classification.establishment_party_role_id = role.establishment_party_role_id
    JOIN establishment.academy_trust_type AS academy_type
      ON academy_type.academy_trust_type_id = classification.academy_trust_type_id
    JOIN establishment.responsibility_type AS rt
      ON rt.responsibility_type_id = er.responsibility_type_id
    JOIN establishment.organisation_identifier AS oi
      ON oi.legal_entity_id = le.legal_entity_id
    JOIN establishment.organisation_identifier_type AS oit
      ON oit.organisation_identifier_type_id = oi.organisation_identifier_type_id
    WHERE e.urn = 135905
      AND le.name = 'MARCH 2016 LIMITED'
      AND le.incorporation_date = DATE '2009-04-27'
      AND oit.name = 'Companies House number'
      AND oi.value = '06888873'
      AND oi.is_current
      AND role_type.name = 'Academy trust'
      AND role.start_date IS NULL
      AND role.end_date = DATE '2016-02-29'
      AND role.end_date_basis = 'evidenced'
      AND academy_type.name = 'Multi-academy trust'
      AND classification.start_date IS NULL
      AND classification.end_date = DATE '2016-02-29'
      AND rt.name = 'Run by academy trust'
      AND er.start_date = DATE '2009-09-01'
      AND er.end_date = DATE '2016-02-29'
      AND er.end_date_basis = 'inferred';

    IF actual_count <> 1 THEN
        RAISE EXCEPTION 'T20 validation expected one role, MAT classification and responsibility but found %', actual_count;
    END IF;
END
$$;

SELECT e.urn,
       le.name AS legal_entity_name,
       oi.value AS companies_house_number,
       role_type.name AS establishment_party_role_type,
       academy_type.name AS academy_trust_type,
       role.start_date AS role_start_date,
       role.end_date AS role_end_date,
       er.start_date AS responsibility_start_date,
       er.end_date AS responsibility_end_date,
       er.end_date_basis
FROM establishment.establishment_responsibility AS er
JOIN establishment.establishment AS e
  ON e.establishment_id = er.establishment_id
JOIN establishment.legal_entity AS le
  ON le.legal_entity_id = er.legal_entity_id
JOIN establishment.organisation_identifier AS oi
  ON oi.legal_entity_id = le.legal_entity_id
JOIN establishment.organisation_identifier_type AS oit
  ON oit.organisation_identifier_type_id = oi.organisation_identifier_type_id
JOIN establishment.establishment_party_role AS role
  ON role.legal_entity_id = le.legal_entity_id
JOIN establishment.establishment_party_role_type AS role_type
  ON role_type.establishment_party_role_type_id = role.establishment_party_role_type_id
JOIN establishment.academy_trust_classification AS classification
  ON classification.establishment_party_role_id = role.establishment_party_role_id
JOIN establishment.academy_trust_type AS academy_type
  ON academy_type.academy_trust_type_id = classification.academy_trust_type_id
WHERE e.urn = 135905
  AND oit.name = 'Companies House number'
  AND oi.is_current
  AND role_type.name = 'Academy trust';

-- Blocking logical-model invariants for all migrated establishment-party roles.
DO $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM establishment.academy_trust_classification AS classification
        JOIN establishment.establishment_party_role AS role
          ON role.establishment_party_role_id = classification.establishment_party_role_id
        JOIN establishment.establishment_party_role_type AS role_type
          ON role_type.establishment_party_role_type_id = role.establishment_party_role_type_id
        WHERE role_type.name <> 'Academy trust'
    ) THEN
        RAISE EXCEPTION 'Academy-trust classifications may exist only for academy-trust roles';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM establishment.establishment_party_role AS role
        JOIN establishment.establishment_party_role_type AS role_type
          ON role_type.establishment_party_role_type_id = role.establishment_party_role_type_id
        WHERE role_type.name = 'Academy trust'
          AND NOT EXISTS (
              SELECT 1
              FROM establishment.academy_trust_classification AS classification
              WHERE classification.establishment_party_role_id = role.establishment_party_role_id
          )
    ) THEN
        RAISE EXCEPTION 'Every academy-trust role must have at least one classification';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM establishment.establishment_party_role AS first_role
        JOIN establishment.establishment_party_role AS second_role
          ON second_role.establishment_party_role_id > first_role.establishment_party_role_id
         AND second_role.establishment_party_role_type_id = first_role.establishment_party_role_type_id
         AND second_role.legal_entity_id IS NOT DISTINCT FROM first_role.legal_entity_id
         AND second_role.person_id IS NOT DISTINCT FROM first_role.person_id
         AND daterange(first_role.start_date, first_role.end_date, '[)')
             && daterange(second_role.start_date, second_role.end_date, '[)')
    ) THEN
        RAISE EXCEPTION 'Role periods for the same party and role type must not overlap';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM establishment.academy_trust_classification AS first_classification
        JOIN establishment.academy_trust_classification AS second_classification
          ON second_classification.academy_trust_classification_id > first_classification.academy_trust_classification_id
         AND second_classification.establishment_party_role_id = first_classification.establishment_party_role_id
         AND daterange(first_classification.start_date, first_classification.end_date, '[)')
             && daterange(second_classification.start_date, second_classification.end_date, '[)')
    ) THEN
        RAISE EXCEPTION 'Academy-trust classification periods for one role must not overlap';
    END IF;
END
$$;
