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
    is_current boolean NOT NULL,
    establishment_urn integer NOT NULL,
    responsibility_start_date date NOT NULL,
    responsibility_end_date date,
    end_date_basis text,
    consolidation_evidence text,
    responsibility_is_current boolean NOT NULL
) ON COMMIT DROP;

\copy establishment_party_role_fixture FROM '__FIXTURE_PATH__' WITH (FORMAT csv, HEADER true, DELIMITER '|', NULL 'NULL')

-- Resolve once per source row; subsequent writes use the resolved UUID,
-- never a name join. A source UID identifies an already-mapped party.
ALTER TABLE establishment_party_role_fixture
    ADD COLUMN resolved_legal_entity_id uuid,
    ADD COLUMN identity_resolution_method text;

DO $$
DECLARE
    fixture record;
    resolved_id uuid;
    identifier_current boolean;
    uid_owner uuid;
    ukprn_owner uuid;
    method text;
BEGIN
    FOR fixture IN SELECT * FROM establishment_party_role_fixture LOOP
        resolved_id := NULL;
        method := NULL;
        IF fixture.companies_house_number IS NOT NULL THEN
            SELECT identifier.legal_entity_id, identifier.is_current
            INTO resolved_id, identifier_current
            FROM establishment.organisation_identifier AS identifier
            JOIN establishment.organisation_identifier_type AS identifier_type USING (organisation_identifier_type_id)
            WHERE identifier_type.name = 'Companies House number'
              AND identifier.value = fixture.companies_house_number;
            IF resolved_id IS NOT NULL AND NOT identifier_current THEN
                RAISE EXCEPTION 'Source group % supplies a retired company identifier; identity review required', fixture.group_uid;
            END IF;
            method := 'companies-house-number';
        END IF;

        IF resolved_id IS NULL AND fixture.companies_house_number IS NULL AND fixture.ukprn IS NOT NULL THEN
            SELECT identifier.legal_entity_id, identifier.is_current INTO resolved_id, identifier_current
            FROM establishment.organisation_identifier AS identifier
            JOIN establishment.organisation_identifier_type AS identifier_type USING (organisation_identifier_type_id)
            WHERE identifier_type.name = 'UKPRN' AND identifier.value = fixture.ukprn;
            IF resolved_id IS NOT NULL AND NOT identifier_current THEN
                RAISE EXCEPTION 'Source group % supplies a retired UKPRN; identity review required', fixture.group_uid;
            END IF;
            IF resolved_id IS NOT NULL THEN method := 'ukprn'; END IF;
        END IF;

        IF fixture.ukprn IS NOT NULL THEN
            SELECT identifier.legal_entity_id, identifier.is_current INTO ukprn_owner, identifier_current
            FROM establishment.organisation_identifier AS identifier
            JOIN establishment.organisation_identifier_type AS identifier_type USING (organisation_identifier_type_id)
            WHERE identifier_type.name = 'UKPRN' AND identifier.value = fixture.ukprn;
            IF ukprn_owner IS NOT NULL AND NOT identifier_current THEN
                RAISE EXCEPTION 'Source group % supplies a retired UKPRN; identity review required', fixture.group_uid;
            END IF;
            IF resolved_id IS NOT NULL AND ukprn_owner IS NOT NULL AND resolved_id <> ukprn_owner THEN
                RAISE EXCEPTION 'Source group % has conflicting company and UKPRN owners; identity review required', fixture.group_uid;
            END IF;
        END IF;

        SELECT role.legal_entity_id INTO uid_owner
        FROM establishment.group_identifier AS identifier
        JOIN establishment.group_identifier_type AS identifier_type USING (group_identifier_type_id)
        JOIN establishment.group_identifier_issuer AS issuer USING (group_identifier_issuer_id)
        JOIN establishment.establishment_party_role AS role USING (establishment_party_role_id)
        WHERE issuer.name = 'GIAS' AND identifier_type.name = 'Group UID'
          AND identifier.value = fixture.group_uid;
        IF resolved_id IS NOT NULL AND uid_owner IS NOT NULL AND resolved_id <> uid_owner THEN
            RAISE EXCEPTION 'Source group % conflicts with its existing identifier owner; identity review required', fixture.group_uid;
        END IF;

        IF resolved_id IS NULL THEN
            SELECT role.legal_entity_id INTO resolved_id
            FROM establishment.group_identifier AS identifier
            JOIN establishment.group_identifier_type AS identifier_type USING (group_identifier_type_id)
            JOIN establishment.group_identifier_issuer AS issuer USING (group_identifier_issuer_id)
            JOIN establishment.establishment_party_role AS role USING (establishment_party_role_id)
            WHERE issuer.name = 'GIAS' AND identifier_type.name = 'Group UID'
              AND identifier.value = fixture.group_uid;
            IF resolved_id IS NOT NULL THEN method := 'existing-source-group-uid'; END IF;
        END IF;

        IF resolved_id IS NULL THEN
            IF fixture.companies_house_number IS NULL AND EXISTS (
                SELECT 1 FROM establishment.legal_entity
                WHERE upper(btrim(name)) = upper(btrim(fixture.legal_entity_name))
            ) THEN
                RAISE EXCEPTION 'Source group % has only a name match; identity review required before loading', fixture.group_uid;
            END IF;
            INSERT INTO establishment.legal_entity (name, incorporation_date)
            VALUES (fixture.legal_entity_name, fixture.legal_entity_incorporation_date)
            RETURNING legal_entity_id INTO resolved_id;
            method := CASE WHEN fixture.companies_house_number IS NULL
                           THEN 'new-separate-source-party' ELSE 'companies-house-number' END;
        END IF;
        UPDATE establishment_party_role_fixture
        SET resolved_legal_entity_id = resolved_id, identity_resolution_method = method
        WHERE group_uid = fixture.group_uid AND establishment_urn = fixture.establishment_urn;
    END LOOP;
END
$$;

-- MR011: a Companies House-identified academy trust is migrated as a
-- charitable company limited by guarantee. BAU does not provide a verified
-- Charity Commission status, so this sets the legal-entity type only.
UPDATE establishment.legal_entity AS le
SET legal_entity_type_id = entity_type.legal_entity_type_id
FROM establishment_party_role_fixture AS f
JOIN establishment.legal_entity_type AS entity_type
  ON entity_type.name = 'Charitable company limited by guarantee'
WHERE le.legal_entity_id = f.resolved_legal_entity_id
  AND f.companies_house_number IS NOT NULL
  AND f.academy_trust_type IS NOT NULL;

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
  ON le.legal_entity_id = f.resolved_legal_entity_id
LEFT JOIN establishment.organisation_identifier AS existing
  ON existing.organisation_identifier_type_id = oit.organisation_identifier_type_id
 AND existing.value = f.companies_house_number
 AND existing.is_current
WHERE f.companies_house_number IS NOT NULL
  AND existing.organisation_identifier_id IS NULL;

-- Some source parties, such as the Diocese of London in T2, have no
-- Companies House number. Do not invent an identifier. Resolve their legal
-- entity by a supplied UKPRN or existing source group UID, or create a new
-- separate provisional party. A name-only collision requires identity review.
INSERT INTO establishment.organisation_identifier (
    legal_entity_id,
    organisation_identifier_type_id,
    value,
    is_current
)
SELECT f.resolved_legal_entity_id,
       ukprn_type.organisation_identifier_type_id,
       f.ukprn,
       true
FROM establishment_party_role_fixture AS f
JOIN establishment.organisation_identifier_type AS ukprn_type
  ON ukprn_type.name = 'UKPRN'
LEFT JOIN establishment.organisation_identifier AS existing
  ON existing.organisation_identifier_type_id = ukprn_type.organisation_identifier_type_id
 AND existing.value = f.ukprn
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
    legal_entity_id,
    academy_trust_type_id,
    start_date,
    end_date,
    is_current
)
SELECT company_identifier.legal_entity_id,
       academy_type.academy_trust_type_id,
       f.classification_start_date,
       f.classification_end_date,
       f.is_current
FROM establishment_party_role_fixture AS f
JOIN establishment.organisation_identifier_type AS company_type
  ON company_type.name = 'Companies House number'
JOIN establishment.organisation_identifier AS company_identifier
  ON company_identifier.organisation_identifier_type_id = company_type.organisation_identifier_type_id
 AND company_identifier.value = f.companies_house_number
 AND company_identifier.is_current
JOIN establishment.academy_trust_type AS academy_type
  ON academy_type.name = f.academy_trust_type
WHERE f.academy_trust_type IS NOT NULL
ON CONFLICT (
    legal_entity_id,
    academy_trust_type_id,
    COALESCE(start_date, DATE '-infinity')
) DO UPDATE SET end_date = EXCLUDED.end_date, is_current = EXCLUDED.is_current;

INSERT INTO establishment.academy_trust_classification (
    legal_entity_id, academy_trust_type_id, start_date, end_date, is_current
)
SELECT le.legal_entity_id,
       academy_type.academy_trust_type_id,
       f.classification_start_date,
       f.classification_end_date,
       f.is_current
FROM establishment_party_role_fixture AS f
JOIN establishment.legal_entity AS le
  ON le.legal_entity_id = f.resolved_legal_entity_id
JOIN establishment.academy_trust_type AS academy_type
  ON academy_type.name = f.academy_trust_type
WHERE f.companies_house_number IS NULL
  AND f.academy_trust_type IS NOT NULL
ON CONFLICT (
    legal_entity_id,
    academy_trust_type_id,
    COALESCE(start_date, DATE '-infinity')
) DO UPDATE SET end_date = EXCLUDED.end_date, is_current = EXCLUDED.is_current;

INSERT INTO establishment.group_identifier (
    establishment_party_role_id,
    group_identifier_type_id,
    group_identifier_issuer_id,
    value,
    is_current
)
SELECT role.establishment_party_role_id,
       git.group_identifier_type_id,
       issuer.group_identifier_issuer_id,
       f.group_uid,
       f.is_current
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
JOIN establishment.group_identifier_issuer AS issuer
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
    group_identifier_issuer_id,
    value,
    is_current
)
SELECT role.establishment_party_role_id,
       git.group_identifier_type_id,
       issuer.group_identifier_issuer_id,
       f.group_id,
       f.is_current
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
JOIN establishment.group_identifier_issuer AS issuer
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
    academy_trust_type_id,
    start_date,
    end_date,
    is_current
)
SELECT e.establishment_id,
       company_identifier.legal_entity_id,
       rt.responsibility_type_id,
       academy_type.academy_trust_type_id,
       f.responsibility_start_date,
       f.responsibility_end_date,
       f.responsibility_is_current
FROM establishment_party_role_fixture AS f
JOIN establishment.establishment AS e
  ON e.urn = f.establishment_urn
JOIN establishment.organisation_identifier_type AS company_type
  ON company_type.name = 'Companies House number'
JOIN establishment.organisation_identifier AS company_identifier
  ON company_identifier.organisation_identifier_type_id = company_type.organisation_identifier_type_id
 AND company_identifier.value = f.companies_house_number
 AND company_identifier.is_current
JOIN establishment.establishment_responsibility_type AS rt
  ON rt.name = f.responsibility_type
LEFT JOIN establishment.academy_trust_type AS academy_type
  ON academy_type.name = f.academy_trust_type
ON CONFLICT (
    establishment_id,
    legal_entity_id,
    responsibility_type_id,
    COALESCE(start_date, DATE '-infinity')
) WHERE legal_entity_id IS NOT NULL DO UPDATE SET
    academy_trust_type_id = EXCLUDED.academy_trust_type_id,
    end_date = EXCLUDED.end_date,
    is_current = EXCLUDED.is_current;

INSERT INTO establishment.establishment_party_role (
    establishment_party_role_type_id, legal_entity_id, start_date, end_date
)
SELECT role_type.establishment_party_role_type_id,
       le.legal_entity_id,
       f.role_start_date,
       f.role_end_date
FROM establishment_party_role_fixture AS f
JOIN establishment.legal_entity AS le
  ON le.legal_entity_id = f.resolved_legal_entity_id
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
    group_identifier_issuer_id, value, is_current
)
SELECT role.establishment_party_role_id,
       git.group_identifier_type_id,
       issuer.group_identifier_issuer_id,
       f.group_uid,
       f.is_current
FROM establishment_party_role_fixture AS f
JOIN establishment.legal_entity AS le ON le.legal_entity_id = f.resolved_legal_entity_id
JOIN establishment.establishment_party_role AS role ON role.legal_entity_id = le.legal_entity_id
JOIN establishment.establishment_party_role_type AS role_type
  ON role_type.establishment_party_role_type_id = role.establishment_party_role_type_id
 AND role_type.name = f.establishment_party_role_type
JOIN establishment.group_identifier_type AS git ON git.name = 'Group UID'
JOIN establishment.group_identifier_issuer AS issuer ON issuer.name = 'GIAS'
WHERE f.companies_house_number IS NULL
  AND NOT EXISTS (
      SELECT 1 FROM establishment.group_identifier AS existing
      WHERE existing.group_identifier_type_id = git.group_identifier_type_id
        AND existing.value = f.group_uid
  )
ON CONFLICT (group_identifier_type_id, value) DO NOTHING;

INSERT INTO establishment.group_identifier (
    establishment_party_role_id, group_identifier_type_id,
    group_identifier_issuer_id, value, is_current
)
SELECT role.establishment_party_role_id,
       git.group_identifier_type_id,
       issuer.group_identifier_issuer_id,
       f.group_id,
       f.is_current
FROM establishment_party_role_fixture AS f
JOIN establishment.legal_entity AS le ON le.legal_entity_id = f.resolved_legal_entity_id
JOIN establishment.establishment_party_role AS role ON role.legal_entity_id = le.legal_entity_id
JOIN establishment.establishment_party_role_type AS role_type
  ON role_type.establishment_party_role_type_id = role.establishment_party_role_type_id
 AND role_type.name = f.establishment_party_role_type
JOIN establishment.group_identifier_type AS git ON git.name = 'Group ID'
JOIN establishment.group_identifier_issuer AS issuer ON issuer.name = 'GIAS'
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
    academy_trust_type_id, start_date, end_date, is_current
)
SELECT e.establishment_id,
       le.legal_entity_id,
       rt.responsibility_type_id,
       academy_type.academy_trust_type_id,
       f.responsibility_start_date,
       f.responsibility_end_date,
       f.responsibility_is_current
FROM establishment_party_role_fixture AS f
JOIN establishment.establishment AS e ON e.urn = f.establishment_urn
JOIN establishment.legal_entity AS le ON le.legal_entity_id = f.resolved_legal_entity_id
JOIN establishment.establishment_responsibility_type AS rt ON rt.name = f.responsibility_type
LEFT JOIN establishment.academy_trust_type AS academy_type
  ON academy_type.name = f.academy_trust_type
WHERE f.companies_house_number IS NULL
ON CONFLICT (
    establishment_id,
    legal_entity_id,
    responsibility_type_id,
    COALESCE(start_date, DATE '-infinity')
) WHERE legal_entity_id IS NOT NULL DO UPDATE SET
    academy_trust_type_id = EXCLUDED.academy_trust_type_id,
    end_date = EXCLUDED.end_date,
    is_current = EXCLUDED.is_current;

-- Keep source-derived dates and inference decisions outside the live model.
CREATE TEMP TABLE migration_context (
    migration_run_id uuid NOT NULL,
    source_snapshot_id uuid NOT NULL
) ON COMMIT DROP;

-- A full rebuild supplies its run ID through the connection setting.
-- An independently invoked loader still gets its own bounded mini-migration.
DO $$
DECLARE
    run_id uuid := NULLIF(current_setting('epr.migration_run_id', true), '')::uuid;
    snapshot_id uuid;
    source_database_name text;
BEGIN
    IF run_id IS NULL THEN
        INSERT INTO migration.migration_run (
            run_type, source_system, source_database, status, transform_version
        ) VALUES ('mini-migration', 'GIAS BAU', 'local BAU SQL Server', 'running', 'academy-trust-responsibility-v2')
        RETURNING migration_run_id INTO run_id;
    ELSE
        IF NOT EXISTS (
            SELECT 1 FROM migration.migration_run
            WHERE migration_run_id = run_id AND run_type = 'establishment-rebuild'
              AND source_system = 'GIAS BAU' AND status = 'running'
        ) THEN
            RAISE EXCEPTION 'Shared migration run is missing, incompatible or not running: %', run_id;
        END IF;
    END IF;
    SELECT source_database INTO source_database_name
    FROM migration.migration_run WHERE migration_run_id = run_id;
    INSERT INTO migration.source_snapshot (
        migration_run_id, source_system, source_database, snapshot_date, extract_name
    )
    SELECT run_id, 'GIAS BAU', source_database_name, CURRENT_DATE,
           'establishment-party-' || establishment_urn || '-' || group_uid
    FROM establishment_party_role_fixture LIMIT 1
    RETURNING source_snapshot_id INTO snapshot_id;
    INSERT INTO migration_context VALUES (run_id, snapshot_id);
END
$$;

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

INSERT INTO migration.academy_trust_classification_evidence (
    academy_trust_classification_id,
    source_record_id,
    assertion_rule,
    review_status,
    notes
)
SELECT classification.academy_trust_classification_id,
       source_record.source_record_id,
       CASE WHEN fixture.is_current THEN 'MR001' ELSE 'MR005' END,
       'accepted',
       fixture.consolidation_evidence
FROM establishment_party_role_fixture AS fixture
JOIN establishment.organisation_identifier_type AS company_type
  ON company_type.name = 'Companies House number'
JOIN establishment.organisation_identifier AS company_identifier
  ON company_identifier.organisation_identifier_type_id = company_type.organisation_identifier_type_id
 AND company_identifier.value = fixture.companies_house_number
 AND company_identifier.is_current
JOIN establishment.academy_trust_type AS academy_type
  ON academy_type.name = fixture.academy_trust_type
JOIN establishment.academy_trust_classification AS classification
  ON classification.legal_entity_id = company_identifier.legal_entity_id
 AND classification.academy_trust_type_id = academy_type.academy_trust_type_id
 AND classification.start_date IS NOT DISTINCT FROM fixture.classification_start_date
JOIN migration_context AS context ON true
JOIN migration.source_record AS source_record
  ON source_record.source_snapshot_id = context.source_snapshot_id
 AND source_record.source_key = fixture.group_uid || ':' || fixture.establishment_urn
WHERE fixture.academy_trust_type IS NOT NULL
ON CONFLICT DO NOTHING;

INSERT INTO migration.establishment_party_role_evidence (
    establishment_party_role_id,
    source_record_id,
    end_date_basis,
    inference_rule,
    review_status,
    notes
)
SELECT role.establishment_party_role_id,
       source_record.source_record_id,
       fixture.role_end_date_basis,
       CASE WHEN fixture.role_end_date_basis = 'inferred'
            THEN 'Role end date inferred from the source establishment/group closure date.'
       END,
       'accepted',
       fixture.consolidation_evidence
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
    review_status,
    notes
)
SELECT responsibility.establishment_responsibility_id,
       source_record.source_record_id,
       fixture.end_date_basis,
       CASE WHEN fixture.end_date_basis = 'inferred'
            THEN 'Responsibility end date inferred from the source establishment closure date.'
       END,
       'accepted',
       fixture.consolidation_evidence
FROM establishment_party_role_fixture AS fixture
JOIN establishment.establishment AS establishment
  ON establishment.urn = fixture.establishment_urn
JOIN establishment.organisation_identifier AS company_identifier
  ON company_identifier.value = fixture.companies_house_number
 AND company_identifier.is_current
JOIN establishment.organisation_identifier_type AS company_type
  ON company_type.organisation_identifier_type_id = company_identifier.organisation_identifier_type_id
 AND company_type.name = 'Companies House number'
JOIN establishment.establishment_responsibility_type AS responsibility_type
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

-- Record identity resolution for every source party, including provisional
-- separate parties without verified external identifiers.
INSERT INTO migration.identity_resolution (
    source_record_id, target_entity_type, target_entity_id,
    resolution_method, confidence, decision_status, rationale
)
SELECT source_record.source_record_id, 'legal_entity', fixture.resolved_legal_entity_id,
       CASE WHEN fixture.consolidation_evidence IS NOT NULL
            THEN 'shared-identifiers-and-explicit-sat-mat-transition'
            ELSE fixture.identity_resolution_method END,
       CASE WHEN fixture.companies_house_number IS NOT NULL OR fixture.identity_resolution_method = 'ukprn'
            THEN 'high' ELSE 'provisional' END,
       'accepted',
       COALESCE(fixture.consolidation_evidence,
           'Resolved by ' || fixture.identity_resolution_method ||
           '. A new separate source party is not a verification of its registered legal identity; names do not authorise consolidation.')
FROM establishment_party_role_fixture AS fixture
JOIN migration_context AS context ON true
JOIN migration.source_record AS source_record
  ON source_record.source_snapshot_id = context.source_snapshot_id
 AND source_record.source_key = fixture.group_uid || ':' || fixture.establishment_urn;

-- A shared Group ID stays current when its successor UID is current. The
-- archived UID itself retains its historical status.
UPDATE establishment.group_identifier AS identifier
SET is_current = true
FROM establishment_party_role_fixture AS fixture
JOIN establishment.group_identifier_type AS identifier_type
  ON identifier_type.name = 'Group ID'
WHERE fixture.consolidation_evidence IS NOT NULL AND fixture.is_current
  AND identifier.group_identifier_type_id = identifier_type.group_identifier_type_id
  AND identifier.value = fixture.group_id;

UPDATE migration.migration_run AS run
SET status = 'completed', completed_at = now()
FROM migration_context AS context
WHERE run.migration_run_id = context.migration_run_id
  AND run.run_type = 'mini-migration';

COMMIT;
