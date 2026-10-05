-- Checked-in migration evidence for the T1, T2 and T20 fixtures.

INSERT INTO migration.migration_run (migration_run_id, run_type, source_system, source_database, status, transform_version)
VALUES ('ccf4f5a3-becd-4c3f-8d5e-111111111111', 'checked-in-fixture', 'GIAS BAU', 'checked-in seed', 'completed', 'academy-trust-responsibility-v1');

INSERT INTO migration.source_snapshot (source_snapshot_id, migration_run_id, source_system, source_database, extract_name)
VALUES ('ccf4f5a3-becd-4c3f-8d5e-222222222222', 'ccf4f5a3-becd-4c3f-8d5e-111111111111', 'GIAS BAU', 'checked-in seed', 'T1-T2-T20');

INSERT INTO migration.source_record (source_record_id, source_snapshot_id, source_table, source_key, source_group_id, source_urn)
VALUES
    ('ccf4f5a3-becd-4c3f-8d5e-333333333333', 'ccf4f5a3-becd-4c3f-8d5e-222222222222', 'dbo.EstablishmentGroup/GroupLink', '2777:136102', '2777', 136102),
    ('ccf4f5a3-becd-4c3f-8d5e-444444444444', 'ccf4f5a3-becd-4c3f-8d5e-222222222222', 'dbo.EstablishmentGroup/GroupLink', '4949:136102', '4949', 136102),
    ('ccf4f5a3-becd-4c3f-8d5e-777777777777', 'ccf4f5a3-becd-4c3f-8d5e-222222222222', 'dbo.EstablishmentGroup/GroupLink', '2779:136102', '2779', 136102),
    ('ccf4f5a3-becd-4c3f-8d5e-555555555555', 'ccf4f5a3-becd-4c3f-8d5e-222222222222', 'dbo.EstablishmentGroup/GroupLink', '23869:134314', '23869', 134314),
    ('ccf4f5a3-becd-4c3f-8d5e-666666666666', 'ccf4f5a3-becd-4c3f-8d5e-222222222222', 'dbo.EstablishmentGroup/GroupLink', '2914:134314', '2914', 134314),
    ('ccf4f5a3-becd-4c3f-8d5e-888888888888', 'ccf4f5a3-becd-4c3f-8d5e-222222222222', 'dbo.EstablishmentGroup/GroupLink', '4737:134314', '4737', 134314),
    ('ccf4f5a3-becd-4c3f-8d5e-aaaaaaaaaaaa', 'ccf4f5a3-becd-4c3f-8d5e-222222222222', 'dbo.EstablishmentGroup/GroupLink', '3839:135905', '3839', 135905);

-- Resolve classifications through Companies House number and trust type rather
-- than a generated UUID. A local BAU refresh deliberately regenerates UUIDs.
WITH evidence_input (
    evidence_id,
    companies_house_number,
    academy_trust_type,
    source_record_id,
    assertion_rule
) AS (
    VALUES
        ('ccf4f5a3-becd-4c3f-8d5e-999999999991'::uuid, '07747126', 'Multi-academy trust', 'ccf4f5a3-becd-4c3f-8d5e-333333333333'::uuid, 'MR001'),
        ('ccf4f5a3-becd-4c3f-8d5e-999999999992'::uuid, '07747126', 'Single-academy trust', 'ccf4f5a3-becd-4c3f-8d5e-777777777777'::uuid, 'MR005'),
        ('ccf4f5a3-becd-4c3f-8d5e-999999999993'::uuid, '05412502', 'Multi-academy trust', 'ccf4f5a3-becd-4c3f-8d5e-555555555555'::uuid, 'MR001'),
        ('ccf4f5a3-becd-4c3f-8d5e-999999999994'::uuid, '05412502', 'Single-academy trust', 'ccf4f5a3-becd-4c3f-8d5e-888888888888'::uuid, 'MR005'),
        ('ccf4f5a3-becd-4c3f-8d5e-999999999995'::uuid, '06888873', 'Multi-academy trust', 'ccf4f5a3-becd-4c3f-8d5e-aaaaaaaaaaaa'::uuid, 'MR005')
)
INSERT INTO migration.academy_trust_classification_evidence
    (evidence_id, academy_trust_classification_id, source_record_id, assertion_rule, review_status)
SELECT input.evidence_id,
       classification.academy_trust_classification_id,
       input.source_record_id,
       input.assertion_rule,
       'accepted'
FROM evidence_input AS input
JOIN establishment.organisation_identifier_type AS identifier_type
  ON identifier_type.name = 'Companies House number'
JOIN establishment.organisation_identifier AS identifier
  ON identifier.organisation_identifier_type_id = identifier_type.organisation_identifier_type_id
 AND identifier.value = input.companies_house_number
 AND identifier.is_current
JOIN establishment.academy_trust_type AS trust_type
  ON trust_type.name = input.academy_trust_type
JOIN establishment.academy_trust_classification AS classification
  ON classification.legal_entity_id = identifier.legal_entity_id
 AND classification.academy_trust_type_id = trust_type.academy_trust_type_id;

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
       'inferred',
       'M1',
       'accepted',
       'Responsibility end inferred from the local BAU establishment closure because GroupLink has no relationship end date.'
FROM establishment.establishment_responsibility AS responsibility
JOIN establishment.establishment AS establishment
  ON establishment.establishment_id = responsibility.establishment_id
JOIN migration.source_record AS source_record
  ON source_record.source_key = '3839:135905'
JOIN establishment.establishment_responsibility_type AS responsibility_type
  ON responsibility_type.responsibility_type_id = responsibility.responsibility_type_id
WHERE establishment.urn = 135905
  AND responsibility_type.name = 'Run by academy trust'
  AND responsibility.start_date = DATE '2009-09-01'
  AND responsibility.end_date = DATE '2016-02-29'
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
       'evidenced',
       NULL,
       'accepted',
       'Role end supplied by the closed academy-trust group record in the local BAU copy.'
FROM establishment.establishment_party_role AS role
JOIN establishment.establishment_party_role_type AS role_type
  ON role_type.establishment_party_role_type_id = role.establishment_party_role_type_id
JOIN establishment.legal_entity AS legal_entity
  ON legal_entity.legal_entity_id = role.legal_entity_id
JOIN migration.source_record AS source_record
  ON source_record.source_key = '3839:135905'
WHERE role_type.name = 'Academy trust'
  AND legal_entity.name = 'MARCH 2016 LIMITED'
  AND role.end_date = DATE '2016-02-29'
ON CONFLICT DO NOTHING;
