-- Load one or more resolved establishment-party roles and responsibilities
-- from a controlled
-- local fixture. Source group IDs are intentionally absent: they belong in
-- migration lineage/staging, not in the target schema.

BEGIN;

CREATE TEMP TABLE establishment_party_role_fixture (
    legal_entity_name text NOT NULL,
    companies_house_number text NOT NULL,
    ukprn text,
    legal_entity_incorporation_date date,
    establishment_party_role_type text NOT NULL,
    academy_trust_type text,
    responsibility_type text NOT NULL,
    role_start_date date,
    role_end_date date,
    role_end_date_basis text,
    classification_start_date date,
    classification_end_date date,
    establishment_urn integer NOT NULL,
    responsibility_start_date date NOT NULL,
    responsibility_end_date date,
    end_date_basis text
) ON COMMIT DROP;

\copy establishment_party_role_fixture FROM '__FIXTURE_PATH__' WITH (FORMAT csv, HEADER true, DELIMITER '|', NULL 'NULL')

-- Companies House number is the authoritative target identifier used by this
-- first slice to resolve the legal entity. Name is not treated as unique.
INSERT INTO establishment.legal_entity (name, incorporation_date)
SELECT DISTINCT f.legal_entity_name,
       f.legal_entity_incorporation_date
FROM establishment_party_role_fixture AS f
WHERE NOT EXISTS (
    SELECT 1
    FROM establishment.organisation_identifier AS oi
    JOIN establishment.organisation_identifier_type AS oit
      ON oit.organisation_identifier_type_id = oi.organisation_identifier_type_id
    WHERE oit.name = 'Companies House number'
      AND oi.value = f.companies_house_number
      AND oi.is_current
);

INSERT INTO establishment.organisation_identifier (
    legal_entity_id,
    organisation_identifier_type_id,
    value,
    is_current
)
SELECT le.legal_entity_id,
       oit.organisation_identifier_type_id,
       f.companies_house_number,
       true
FROM establishment_party_role_fixture AS f
JOIN establishment.organisation_identifier_type AS oit
  ON oit.name = 'Companies House number'
JOIN establishment.legal_entity AS le
  ON le.name = f.legal_entity_name
LEFT JOIN establishment.organisation_identifier AS existing
  ON existing.organisation_identifier_type_id = oit.organisation_identifier_type_id
 AND existing.value = f.companies_house_number
 AND existing.is_current
WHERE existing.organisation_identifier_id IS NULL;

INSERT INTO establishment.organisation_identifier (
    legal_entity_id,
    organisation_identifier_type_id,
    value,
    is_current
)
SELECT company_identifier.legal_entity_id,
       ukprn_type.organisation_identifier_type_id,
       f.ukprn,
       true
FROM establishment_party_role_fixture AS f
JOIN establishment.organisation_identifier_type AS company_type
  ON company_type.name = 'Companies House number'
JOIN establishment.organisation_identifier AS company_identifier
  ON company_identifier.organisation_identifier_type_id = company_type.organisation_identifier_type_id
 AND company_identifier.value = f.companies_house_number
 AND company_identifier.is_current
JOIN establishment.organisation_identifier_type AS ukprn_type
  ON ukprn_type.name = 'UKPRN'
LEFT JOIN establishment.organisation_identifier AS existing
  ON existing.organisation_identifier_type_id = ukprn_type.organisation_identifier_type_id
 AND existing.value = f.ukprn
 AND existing.is_current
WHERE f.ukprn IS NOT NULL
  AND existing.organisation_identifier_id IS NULL;

UPDATE establishment.legal_entity AS le
SET incorporation_date = COALESCE(le.incorporation_date, f.legal_entity_incorporation_date)
FROM establishment_party_role_fixture AS f
JOIN establishment.organisation_identifier_type AS company_type
  ON company_type.name = 'Companies House number'
JOIN establishment.organisation_identifier AS company_identifier
  ON company_identifier.organisation_identifier_type_id = company_type.organisation_identifier_type_id
 AND company_identifier.value = f.companies_house_number
 AND company_identifier.is_current
WHERE le.legal_entity_id = company_identifier.legal_entity_id
  AND f.legal_entity_incorporation_date IS NOT NULL;

INSERT INTO establishment.establishment_party_role (
    establishment_party_role_type_id,
    legal_entity_id,
    start_date,
    end_date,
    end_date_basis,
    observed_date
)
SELECT role_type.establishment_party_role_type_id,
       company_identifier.legal_entity_id,
       f.role_start_date,
       f.role_end_date,
       f.role_end_date_basis,
       NULL
FROM establishment_party_role_fixture AS f
JOIN establishment.organisation_identifier_type AS company_type
  ON company_type.name = 'Companies House number'
JOIN establishment.organisation_identifier AS company_identifier
  ON company_identifier.organisation_identifier_type_id = company_type.organisation_identifier_type_id
 AND company_identifier.value = f.companies_house_number
 AND company_identifier.is_current
JOIN establishment.establishment_party_role_type AS role_type
  ON role_type.name = f.establishment_party_role_type
WHERE NOT EXISTS (
    SELECT 1
    FROM establishment.establishment_party_role AS existing
    WHERE existing.legal_entity_id = company_identifier.legal_entity_id
      AND existing.establishment_party_role_type_id = role_type.establishment_party_role_type_id
      AND existing.start_date IS NOT DISTINCT FROM f.role_start_date
);

INSERT INTO establishment.academy_trust_classification (
    establishment_party_role_id,
    academy_trust_type_id,
    start_date,
    end_date
)
SELECT role.establishment_party_role_id,
       academy_type.academy_trust_type_id,
       f.classification_start_date,
       f.classification_end_date
FROM establishment_party_role_fixture AS f
JOIN establishment.organisation_identifier_type AS company_type
  ON company_type.name = 'Companies House number'
JOIN establishment.organisation_identifier AS company_identifier
  ON company_identifier.organisation_identifier_type_id = company_type.organisation_identifier_type_id
 AND company_identifier.value = f.companies_house_number
 AND company_identifier.is_current
JOIN establishment.establishment_party_role_type AS role_type
  ON role_type.name = 'Academy trust'
JOIN establishment.establishment_party_role AS role
  ON role.legal_entity_id = company_identifier.legal_entity_id
 AND role.establishment_party_role_type_id = role_type.establishment_party_role_type_id
 AND role.start_date IS NOT DISTINCT FROM f.role_start_date
JOIN establishment.academy_trust_type AS academy_type
  ON academy_type.name = f.academy_trust_type
WHERE f.academy_trust_type IS NOT NULL
  AND NOT EXISTS (
      SELECT 1
      FROM establishment.academy_trust_classification AS existing
      WHERE existing.establishment_party_role_id = role.establishment_party_role_id
        AND existing.academy_trust_type_id = academy_type.academy_trust_type_id
        AND existing.start_date IS NOT DISTINCT FROM f.classification_start_date
  );

INSERT INTO establishment.establishment_responsibility (
    establishment_id,
    legal_entity_id,
    responsibility_type_id,
    start_date,
    end_date,
    end_date_basis,
    observed_date
)
SELECT e.establishment_id,
       company_identifier.legal_entity_id,
       rt.responsibility_type_id,
       f.responsibility_start_date,
       f.responsibility_end_date,
       f.end_date_basis,
       NULL
FROM establishment_party_role_fixture AS f
JOIN establishment.establishment AS e
  ON e.urn = f.establishment_urn
JOIN establishment.organisation_identifier_type AS company_type
  ON company_type.name = 'Companies House number'
JOIN establishment.organisation_identifier AS company_identifier
  ON company_identifier.organisation_identifier_type_id = company_type.organisation_identifier_type_id
 AND company_identifier.value = f.companies_house_number
 AND company_identifier.is_current
JOIN establishment.responsibility_type AS rt
  ON rt.name = f.responsibility_type
ON CONFLICT DO NOTHING;

COMMIT;
