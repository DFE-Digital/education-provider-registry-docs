BEGIN;
CREATE TEMP TABLE group_membership_fixture (
    group_uid text NOT NULL, group_id text, group_name text NOT NULL,
    group_type text NOT NULL, local_authority_code integer,
    group_open_date date, group_close_date date, establishment_urn integer NOT NULL,
    joined_date date, source_link_id text NOT NULL, source_archived integer NOT NULL,
    source_link_type text, is_lead_member boolean
) ON COMMIT DROP;
\copy group_membership_fixture FROM '__FIXTURE_PATH__' WITH (FORMAT csv, HEADER true, DELIMITER '|', NULL 'NULL')

CREATE TEMP TABLE group_membership_context (
    organisation_group_id uuid NOT NULL, migration_run_id uuid NOT NULL, source_snapshot_id uuid NOT NULL
) ON COMMIT DROP;
DO $$
DECLARE
    group_id uuid;
    authority_id uuid;
    run_id uuid := NULLIF(current_setting('epr.migration_run_id', true), '')::uuid;
    snapshot_id uuid;
    source_database_name text;
    fixture record;
BEGIN
    IF (SELECT count(DISTINCT group_uid) FROM group_membership_fixture) <> 1
       OR (SELECT count(*) FROM group_membership_fixture) < 1
       OR (SELECT count(DISTINCT establishment_urn) FROM group_membership_fixture) <> (SELECT count(*) FROM group_membership_fixture)
       OR EXISTS (SELECT 1 FROM group_membership_fixture f LEFT JOIN establishment.establishment e ON e.urn=f.establishment_urn
                  WHERE e.establishment_id IS NULL OR f.source_archived <> 0 OR f.group_close_date IS NOT NULL) THEN
        RAISE EXCEPTION 'Group fixture must contain one open group and distinct loaded active members';
    END IF;
    SELECT * INTO STRICT fixture FROM group_membership_fixture LIMIT 1;
    IF fixture.group_type NOT IN ('Federation', 'Children''s-centre group')
       OR EXISTS (SELECT 1 FROM group_membership_fixture f
                  WHERE f.group_type IS DISTINCT FROM fixture.group_type
                    OR f.local_authority_code IS DISTINCT FROM fixture.local_authority_code
                    OR f.group_name IS DISTINCT FROM fixture.group_name
                    OR f.group_open_date IS DISTINCT FROM fixture.group_open_date) THEN
        RAISE EXCEPTION 'Group type, authority, name and dates must agree across the extract';
    END IF;
    IF fixture.group_type='Federation' AND (
        (SELECT count(*) FROM group_membership_fixture)<2 OR fixture.local_authority_code IS NOT NULL
        OR EXISTS (SELECT 1 FROM group_membership_fixture WHERE is_lead_member IS NOT NULL)
    ) THEN RAISE EXCEPTION 'Federation requires at least two members, no group authority and no lead flag'; END IF;
    IF fixture.group_type='Children''s-centre group' THEN
        SELECT local_authority_id INTO authority_id FROM establishment.local_authority WHERE code=fixture.local_authority_code;
        IF authority_id IS NULL OR EXISTS (
            SELECT 1 FROM group_membership_fixture WHERE source_link_type IS NULL
              OR source_link_type NOT IN ('LEAD','STANDARD')
              OR is_lead_member IS DISTINCT FROM (source_link_type='LEAD')
        ) OR (SELECT count(*) FROM group_membership_fixture WHERE is_lead_member)>1 THEN
            RAISE EXCEPTION 'Childrens-centre group requires a mapped authority and valid single-lead membership flags';
        END IF;
    END IF;
    SELECT i.organisation_group_id INTO group_id
    FROM establishment.group_identifier i
    JOIN establishment.group_identifier_type t USING (group_identifier_type_id)
    JOIN establishment.group_identifier_issuer issuer USING (group_identifier_issuer_id)
    WHERE t.name='Group UID' AND issuer.name='GIAS' AND i.value=fixture.group_uid;
    IF group_id IS NULL AND EXISTS (
        SELECT 1 FROM establishment.group_identifier i
        JOIN establishment.group_identifier_type t USING (group_identifier_type_id)
        WHERE t.name='Group UID' AND i.value=fixture.group_uid
    ) THEN RAISE EXCEPTION 'Group UID already belongs to a party role'; END IF;
    IF group_id IS NULL THEN
        INSERT INTO establishment.organisation_group (name, organisation_group_type_id, local_authority_id, open_date, close_date)
        SELECT fixture.group_name, organisation_group_type_id, authority_id, fixture.group_open_date, fixture.group_close_date
        FROM establishment.organisation_group_type WHERE name=fixture.group_type
        RETURNING organisation_group_id INTO group_id;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM establishment.organisation_group g JOIN establishment.organisation_group_type t USING (organisation_group_type_id)
                   WHERE g.organisation_group_id=group_id AND t.name=fixture.group_type
                     AND g.local_authority_id IS NOT DISTINCT FROM authority_id) THEN
        RAISE EXCEPTION 'Existing group UID has a conflicting group type or authority';
    END IF;
    IF run_id IS NULL THEN
        INSERT INTO migration.migration_run (run_type, source_system, source_database, status, transform_version)
        VALUES ('mini-migration', 'GIAS BAU', 'local BAU SQL Server', 'running', 'organisation-group-membership-v1')
        RETURNING migration_run_id INTO run_id;
    ELSIF NOT EXISTS (SELECT 1 FROM migration.migration_run WHERE migration_run_id=run_id
                      AND run_type='establishment-rebuild' AND status='running' AND source_system='GIAS BAU') THEN
        RAISE EXCEPTION 'Shared group migration run is missing or not running';
    END IF;
    SELECT source_database INTO source_database_name FROM migration.migration_run WHERE migration_run_id=run_id;
    INSERT INTO migration.source_snapshot (migration_run_id, source_system, source_database, snapshot_date, extract_name)
    VALUES (run_id, 'GIAS BAU', source_database_name, CURRENT_DATE, 'organisation-group-' || fixture.group_uid)
    RETURNING source_snapshot_id INTO snapshot_id;
    INSERT INTO group_membership_context VALUES (group_id, run_id, snapshot_id);
END $$;

INSERT INTO establishment.group_identifier (organisation_group_id, group_identifier_type_id, group_identifier_issuer_id, value, is_current)
SELECT DISTINCT c.organisation_group_id, t.group_identifier_type_id, issuer.group_identifier_issuer_id,
       CASE WHEN t.name='Group UID' THEN f.group_uid ELSE f.group_id END, true
FROM group_membership_fixture f CROSS JOIN group_membership_context c
CROSS JOIN establishment.group_identifier_type t CROSS JOIN establishment.group_identifier_issuer issuer
WHERE issuer.name='GIAS' AND t.name IN ('Group UID', 'Group ID')
  AND (t.name='Group UID' OR f.group_id IS NOT NULL)
ON CONFLICT (group_identifier_type_id, value) DO NOTHING;

INSERT INTO establishment.organisation_group_member (organisation_group_id, establishment_id, joined_date, left_date, is_lead_member)
SELECT c.organisation_group_id, e.establishment_id, f.joined_date, NULL, f.is_lead_member
FROM group_membership_fixture f CROSS JOIN group_membership_context c
JOIN establishment.establishment e ON e.urn=f.establishment_urn
WHERE NOT EXISTS (SELECT 1 FROM establishment.organisation_group_member m
                  WHERE m.organisation_group_id=c.organisation_group_id AND m.establishment_id=e.establishment_id
                    AND m.joined_date IS NOT DISTINCT FROM f.joined_date);

UPDATE establishment.organisation_group_member m
SET is_lead_member=f.is_lead_member
FROM group_membership_fixture f CROSS JOIN group_membership_context c
JOIN establishment.establishment e ON e.urn=f.establishment_urn
WHERE m.organisation_group_id=c.organisation_group_id AND m.establishment_id=e.establishment_id
  AND m.joined_date IS NOT DISTINCT FROM f.joined_date;

INSERT INTO migration.source_record (source_snapshot_id, source_table, source_key, source_group_id, source_urn)
SELECT c.source_snapshot_id, 'dbo.EstablishmentGroup/GroupLink', f.source_link_id, f.group_uid, f.establishment_urn
FROM group_membership_fixture f CROSS JOIN group_membership_context c;

INSERT INTO migration.organisation_group_member_evidence (organisation_group_member_id, source_record_id, review_status, notes)
SELECT m.organisation_group_member_id, s.source_record_id, 'accepted',
       'Source GroupLink ' || f.source_link_id || ': archived=' || f.source_archived ||
       '; ' || CASE WHEN f.group_type='Children''s-centre group' THEN 'ccLinkType=' ELSE 'linkType=' END || COALESCE(f.source_link_type, 'NULL') || '; joined date from effectiveDate; leaving date unknown.'
FROM group_membership_fixture f CROSS JOIN group_membership_context c
JOIN establishment.establishment e ON e.urn=f.establishment_urn
JOIN establishment.organisation_group_member m ON m.organisation_group_id=c.organisation_group_id
  AND m.establishment_id=e.establishment_id AND m.joined_date IS NOT DISTINCT FROM f.joined_date
JOIN migration.source_record s ON s.source_snapshot_id=c.source_snapshot_id AND s.source_key=f.source_link_id;

UPDATE migration.migration_run r SET status='completed', completed_at=now()
FROM group_membership_context c WHERE r.migration_run_id=c.migration_run_id AND r.run_type='mini-migration';
COMMIT;
