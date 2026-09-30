-- Checked-in migration evidence for the T20 fixture.

INSERT INTO migration.migration_run (migration_run_id, run_type, source_system, source_database, status, transform_version)
VALUES ('ccf4f5a3-becd-4c3f-8d5e-111111111111', 'checked-in-fixture', 'GIAS BAU', 'checked-in seed', 'completed', 'academy-trust-responsibility-v1');

INSERT INTO migration.source_snapshot (source_snapshot_id, migration_run_id, source_system, source_database, extract_name)
VALUES ('ccf4f5a3-becd-4c3f-8d5e-222222222222', 'ccf4f5a3-becd-4c3f-8d5e-111111111111', 'GIAS BAU', 'checked-in seed', 'T20');

INSERT INTO migration.source_record (source_record_id, source_snapshot_id, source_table, source_key, source_group_id, source_urn)
VALUES ('ccf4f5a3-becd-4c3f-8d5e-333333333333', 'ccf4f5a3-becd-4c3f-8d5e-222222222222', 'dbo.EstablishmentGroup/GroupLink', '3839:135905', '3839', 135905);

INSERT INTO migration.establishment_party_role_evidence (establishment_party_role_id, source_record_id, end_date_basis, review_status)
VALUES ('cd129711-2f9a-4177-91ef-d046b032013c', 'ccf4f5a3-becd-4c3f-8d5e-333333333333', 'evidenced', 'accepted');

INSERT INTO migration.establishment_responsibility_evidence (establishment_responsibility_id, source_record_id, end_date_basis, inference_rule, review_status)
VALUES ('7e12aa3f-f165-44ac-bb79-a59e79e8c89b', 'ccf4f5a3-becd-4c3f-8d5e-333333333333', 'inferred', 'Responsibility end date inferred from the source establishment closure date.', 'accepted');
