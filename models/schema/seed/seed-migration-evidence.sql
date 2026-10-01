-- Checked-in migration evidence for the T1 fixture.

INSERT INTO migration.migration_run (migration_run_id, run_type, source_system, source_database, status, transform_version)
VALUES ('ccf4f5a3-becd-4c3f-8d5e-111111111111', 'checked-in-fixture', 'GIAS BAU', 'checked-in seed', 'completed', 'academy-trust-responsibility-v1');

INSERT INTO migration.source_snapshot (source_snapshot_id, migration_run_id, source_system, source_database, extract_name)
VALUES ('ccf4f5a3-becd-4c3f-8d5e-222222222222', 'ccf4f5a3-becd-4c3f-8d5e-111111111111', 'GIAS BAU', 'checked-in seed', 'T1');

INSERT INTO migration.source_record (source_record_id, source_snapshot_id, source_table, source_key, source_group_id, source_urn)
VALUES
    ('ccf4f5a3-becd-4c3f-8d5e-333333333333', 'ccf4f5a3-becd-4c3f-8d5e-222222222222', 'dbo.EstablishmentGroup/GroupLink', '2777:136102', '2777', 136102),
    ('ccf4f5a3-becd-4c3f-8d5e-444444444444', 'ccf4f5a3-becd-4c3f-8d5e-222222222222', 'dbo.EstablishmentGroup/GroupLink', '4949:136102', '4949', 136102);
