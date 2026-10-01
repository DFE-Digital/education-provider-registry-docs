-- Load one or more resolved establishment-party roles and responsibilities
-- from a controlled
-- local fixture. GIAS group identifiers are loaded as target identifiers on
-- the resolved establishment-party role; unresolved source evidence remains
-- outside the target schema.

BEGIN;

CREATE TEMP TABLE establishment_party_role_fixture (
    legal_entity_name text NOT NULL,
    companies_house_number text,
    ukprn text,
    legal_entity_incorporation_date date,
    group_uid text NOT NULL,
    group_id text,
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
WHERE (
    f.companies_house_number IS NOT NULL
    AND NOT EXISTS (
        SELECT 1
        FROM establishment.organisation_identifier AS oi
        JOIN establishment.organisation_identifier_type AS oit
          ON oit.organisation_identifier_type_id = oi.organisation_identifier_type_id
        WHERE oit.name = 'Companies House number'
          AND oi.value = f.companies_house_number
          AND oi.is_current
    )
)
OR (
    f.companies_house_number IS NULL
    AND NOT EXISTS (
        SELECT 1
        FROM establishment.legal_entity AS existing
        WHERE upper(btrim(existing.name)) = upper(btrim(f.legal_entity_name))
    )
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
WHERE f.companies_house_number IS NOT NULL
  AND existing.organisation_identifier_id IS NULL;

-- Some source parties, such as the Diocese of London in T2, have no
-- Companies House number. Do not invent an identifier. Their legal entity,
-- role, group identifiers and responsibility are resolved by the source name
-- and group UID instead.
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
    end_date
)
SELECT role_type.establishment_party_role_type_id,
       company_identifier.legal_entity_id,
       f.role_start_date,
       f.role_end_date
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

INSERT INTO establishment.group_identifier (
    establishment_party_role_id,
    group_identifier_type_id,
    identifier_issuer_id,
    value,
    is_current
)
SELECT role.establishment_party_role_id,
       git.group_identifier_type_id,
       issuer.identifier_issuer_id,
       f.group_uid,
       (f.academy_trust_type IS NULL OR f.academy_trust_type <> 'Single-academy trust')
FROM establishment_party_role_fixture AS f
JOIN establishment.organisation_identifier_type AS company_type
  ON company_type.name = 'Companies House number'
JOIN establishment.organisation_identifier AS company_identifier
  ON company_identifier.organisation_identifier_type_id = company_type.organisation_identifier_type_id
 AND company_identifier.value = f.companies_house_number
 AND company_identifier.is_current
JOIN establishment.establishment_party_role_type AS role_type
  ON role_type.name = f.establishment_party_role_type
JOIN establishment.establishment_party_role AS role
  ON role.legal_entity_id = company_identifier.legal_entity_id
 AND role.establishment_party_role_type_id = role_type.establishment_party_role_type_id
 AND role.start_date IS NOT DISTINCT FROM f.role_start_date
JOIN establishment.group_identifier_type AS git
  ON git.name = 'Group UID'
JOIN establishment.identifier_issuer AS issuer
  ON issuer.name = 'GIAS'
WHERE NOT EXISTS (
    SELECT 1
    FROM establishment.group_identifier AS existing
    WHERE existing.group_identifier_type_id = git.group_identifier_type_id
      AND existing.value = f.group_uid
)
ON CONFLICT (group_identifier_type_id, value) DO NOTHING;

INSERT INTO establishment.group_identifier (
    establishment_party_role_id,
    group_identifier_type_id,
    identifier_issuer_id,
    value,
    is_current
)
SELECT role.establishment_party_role_id,
       git.group_identifier_type_id,
       issuer.identifier_issuer_id,
       f.group_id,
       (f.academy_trust_type IS NULL OR f.academy_trust_type <> 'Single-academy trust')
FROM establishment_party_role_fixture AS f
JOIN establishment.organisation_identifier_type AS company_type
  ON company_type.name = 'Companies House number'
JOIN establishment.organisation_identifier AS company_identifier
  ON company_identifier.organisation_identifier_type_id = company_type.organisation_identifier_type_id
 AND company_identifier.value = f.companies_house_number
 AND company_identifier.is_current
JOIN establishment.establishment_party_role_type AS role_type
  ON role_type.name = f.establishment_party_role_type
JOIN establishment.establishment_party_role AS role
  ON role.legal_entity_id = company_identifier.legal_entity_id
 AND role.establishment_party_role_type_id = role_type.establishment_party_role_type_id
 AND role.start_date IS NOT DISTINCT FROM f.role_start_date
JOIN establishment.group_identifier_type AS git
  ON git.name = 'Group ID'
JOIN establishment.identifier_issuer AS issuer
  ON issuer.name = 'GIAS'
WHERE f.group_id IS NOT NULL
  AND NOT EXISTS (
      SELECT 1
      FROM establishment.group_identifier AS existing
      WHERE existing.group_identifier_type_id = git.group_identifier_type_id
        AND existing.value = f.group_id
  )
ON CONFLICT (group_identifier_type_id, value) DO NOTHING;

INSERT INTO establishment.establishment_responsibility (
    establishment_id,
    legal_entity_id,
    responsibility_type_id,
    start_date,
    end_date
)
SELECT e.establishment_id,
       company_identifier.legal_entity_id,
       rt.responsibility_type_id,
       f.responsibility_start_date,
       f.responsibility_end_date
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

INSERT INTO establishment.establishment_party_role (
    establishment_party_role_type_id, legal_entity_id, start_date, end_date
)
SELECT role_type.establishment_party_role_type_id,
       le.legal_entity_id,
       f.role_start_date,
       f.role_end_date
FROM establishment_party_role_fixture AS f
JOIN establishment.legal_entity AS le
  ON le.name = f.legal_entity_name
JOIN establishment.establishment_party_role_type AS role_type
  ON role_type.name = f.establishment_party_role_type
WHERE f.companies_house_number IS NULL
  AND NOT EXISTS (
      SELECT 1
      FROM establishment.establishment_party_role AS existing
      WHERE existing.legal_entity_id = le.legal_entity_id
        AND existing.establishment_party_role_type_id = role_type.establishment_party_role_type_id
  );

INSERT INTO establishment.group_identifier (
    establishment_party_role_id, group_identifier_type_id,
    identifier_issuer_id, value, is_current
)
SELECT role.establishment_party_role_id,
       git.group_identifier_type_id,
       issuer.identifier_issuer_id,
       f.group_uid,
       (f.academy_trust_type IS NULL OR f.academy_trust_type <> 'Single-academy trust')
FROM establishment_party_role_fixture AS f
JOIN establishment.legal_entity AS le ON le.name = f.legal_entity_name
JOIN establishment.establishment_party_role AS role ON role.legal_entity_id = le.legal_entity_id
JOIN establishment.establishment_party_role_type AS role_type
  ON role_type.establishment_party_role_type_id = role.establishment_party_role_type_id
 AND role_type.name = f.establishment_party_role_type
JOIN establishment.group_identifier_type AS git ON git.name = 'Group UID'
JOIN establishment.identifier_issuer AS issuer ON issuer.name = 'GIAS'
WHERE f.companies_house_number IS NULL
  AND NOT EXISTS (
      SELECT 1 FROM establishment.group_identifier AS existing
      WHERE existing.group_identifier_type_id = git.group_identifier_type_id
        AND existing.value = f.group_uid
  )
ON CONFLICT (group_identifier_type_id, value) DO NOTHING;

INSERT INTO establishment.group_identifier (
    establishment_party_role_id, group_identifier_type_id,
    identifier_issuer_id, value, is_current
)
SELECT role.establishment_party_role_id,
       git.group_identifier_type_id,
       issuer.identifier_issuer_id,
       f.group_id,
       (f.academy_trust_type IS NULL OR f.academy_trust_type <> 'Single-academy trust')
FROM establishment_party_role_fixture AS f
JOIN establishment.legal_entity AS le ON le.name = f.legal_entity_name
JOIN establishment.establishment_party_role AS role ON role.legal_entity_id = le.legal_entity_id
JOIN establishment.establishment_party_role_type AS role_type
  ON role_type.establishment_party_role_type_id = role.establishment_party_role_type_id
 AND role_type.name = f.establishment_party_role_type
JOIN establishment.group_identifier_type AS git ON git.name = 'Group ID'
JOIN establishment.identifier_issuer AS issuer ON issuer.name = 'GIAS'
WHERE f.companies_house_number IS NULL
  AND f.group_id IS NOT NULL
  AND NOT EXISTS (
      SELECT 1 FROM establishment.group_identifier AS existing
      WHERE existing.group_identifier_type_id = git.group_identifier_type_id
        AND existing.value = f.group_id
  )
ON CONFLICT (group_identifier_type_id, value) DO NOTHING;

INSERT INTO establishment.establishment_responsibility (
    establishment_id, legal_entity_id, responsibility_type_id,
    start_date, end_date
)
SELECT e.establishment_id,
       le.legal_entity_id,
       rt.responsibility_type_id,
       f.responsibility_start_date,
       f.responsibility_end_date
FROM establishment_party_role_fixture AS f
JOIN establishment.establishment AS e ON e.urn = f.establishment_urn
JOIN establishment.legal_entity AS le ON le.name = f.legal_entity_name
JOIN establishment.responsibility_type AS rt ON rt.name = f.responsibility_type
WHERE f.companies_house_number IS NULL
ON CONFLICT DO NOTHING;

-- Keep source-derived dates and inference decisions outside the live model.
CREATE TEMP TABLE migration_context (
    migration_run_id uuid NOT NULL,
    source_snapshot_id uuid NOT NULL
) ON COMMIT DROP;

WITH new_run AS (
    INSERT INTO migration.migration_run (
        run_type, source_system, source_database, status, transform_version
    )
    VALUES ('mini-migration', 'GIAS BAU', 'local BAU SQL Server', 'completed', 'academy-trust-responsibility-v1')
    RETURNING migration_run_id
), new_snapshot AS (
    INSERT INTO migration.source_snapshot (
        migration_run_id, source_system, source_database, extract_name
    )
    SELECT migration_run_id, 'GIAS BAU', 'local BAU SQL Server', 'academy-trust-responsibility-fixture'
    FROM new_run
    RETURNING migration_run_id, source_snapshot_id
)
INSERT INTO migration_context (migration_run_id, source_snapshot_id)
SELECT migration_run_id, source_snapshot_id
FROM new_snapshot;

INSERT INTO migration.source_record (
    source_snapshot_id, source_table, source_key, source_group_id, source_urn
)
SELECT context.source_snapshot_id,
       'dbo.EstablishmentGroup/GroupLink',
       fixture.group_uid || ':' || fixture.establishment_urn,
       fixture.group_uid,
       fixture.establishment_urn
FROM establishment_party_role_fixture AS fixture
CROSS JOIN migration_context AS context
ON CONFLICT DO NOTHING;

INSERT INTO migration.establishment_party_role_evidence (
    establishment_party_role_id,
    source_record_id,
    end_date_basis,
    inference_rule,
    review_status
)
SELECT role.establishment_party_role_id,
       source_record.source_record_id,
       fixture.role_end_date_basis,
       CASE WHEN fixture.role_end_date_basis = 'inferred'
            THEN 'Role end date inferred from the source establishment/group closure date.'
       END,
       'accepted'
FROM establishment_party_role_fixture AS fixture
JOIN establishment.organisation_identifier AS company_identifier
  ON company_identifier.value = fixture.companies_house_number
 AND company_identifier.is_current
JOIN establishment.organisation_identifier_type AS company_type
  ON company_type.organisation_identifier_type_id = company_identifier.organisation_identifier_type_id
 AND company_type.name = 'Companies House number'
JOIN establishment.establishment_party_role_type AS role_type
  ON role_type.name = fixture.establishment_party_role_type
JOIN establishment.establishment_party_role AS role
  ON role.legal_entity_id = company_identifier.legal_entity_id
 AND role.establishment_party_role_type_id = role_type.establishment_party_role_type_id
 AND role.start_date IS NOT DISTINCT FROM fixture.role_start_date
JOIN migration_context AS context ON true
JOIN migration.source_record AS source_record
  ON source_record.source_snapshot_id = context.source_snapshot_id
 AND source_record.source_key = fixture.group_uid || ':' || fixture.establishment_urn
WHERE NOT EXISTS (
    SELECT 1 FROM migration.establishment_party_role_evidence AS existing
    WHERE existing.establishment_party_role_id = role.establishment_party_role_id
      AND existing.source_record_id = source_record.source_record_id
);

INSERT INTO migration.establishment_responsibility_evidence (
    establishment_responsibility_id,
    source_record_id,
    end_date_basis,
    inference_rule,
    review_status
)
SELECT responsibility.establishment_responsibility_id,
       source_record.source_record_id,
       fixture.end_date_basis,
       CASE WHEN fixture.end_date_basis = 'inferred'
            THEN 'Responsibility end date inferred from the source establishment closure date.'
       END,
       'accepted'
FROM establishment_party_role_fixture AS fixture
JOIN establishment.establishment AS establishment
  ON establishment.urn = fixture.establishment_urn
JOIN establishment.organisation_identifier AS company_identifier
  ON company_identifier.value = fixture.companies_house_number
 AND company_identifier.is_current
JOIN establishment.organisation_identifier_type AS company_type
  ON company_type.organisation_identifier_type_id = company_identifier.organisation_identifier_type_id
 AND company_type.name = 'Companies House number'
JOIN establishment.responsibility_type AS responsibility_type
  ON responsibility_type.name = fixture.responsibility_type
JOIN establishment.establishment_responsibility AS responsibility
  ON responsibility.establishment_id = establishment.establishment_id
 AND responsibility.legal_entity_id = company_identifier.legal_entity_id
 AND responsibility.responsibility_type_id = responsibility_type.responsibility_type_id
 AND responsibility.start_date IS NOT DISTINCT FROM fixture.responsibility_start_date
JOIN migration_context AS context ON true
JOIN migration.source_record AS source_record
  ON source_record.source_snapshot_id = context.source_snapshot_id
 AND source_record.source_key = fixture.group_uid || ':' || fixture.establishment_urn
WHERE NOT EXISTS (
    SELECT 1 FROM migration.establishment_responsibility_evidence AS existing
    WHERE existing.establishment_responsibility_id = responsibility.establishment_responsibility_id
      AND existing.source_record_id = source_record.source_record_id
);

UPDATE migration.migration_run AS run
SET completed_at = now()
FROM migration_context AS context
WHERE run.migration_run_id = context.migration_run_id;

COMMIT;
