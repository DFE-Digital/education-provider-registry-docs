-- Controlled values for the establishment-party-role physical slice.
-- These are target-owned values, not BAU type codes.

INSERT INTO establishment.legal_entity_type (legal_entity_type_id, name) VALUES
    (1, 'Charitable company limited by guarantee'),
    (2, 'Company limited by guarantee'),
    (3, 'Private limited company'),
    (4, 'Public limited company'),
    (5, 'Limited liability partnership'),
    (6, 'Charitable incorporated organisation'),
    (7, 'Body incorporated by Royal Charter'),
    (8, 'Unincorporated charitable trust'),
    (9, 'Public body'),
    (10, 'Overseas entity'),
    (11, 'Sole trader'),
    (12, 'Traditional partnership')
ON CONFLICT (legal_entity_type_id) DO UPDATE
SET name = EXCLUDED.name;

INSERT INTO establishment.charity_status (charity_status_id, name) VALUES
    (1, 'Registered'),
    (2, 'Exempt'),
    (3, 'Excepted'),
    (4, 'Not a charity')
ON CONFLICT (charity_status_id) DO UPDATE
SET name = EXCLUDED.name;

INSERT INTO establishment.organisation_identifier_type (organisation_identifier_type_id, name) VALUES
    (1, 'Companies House number'),
    (2, 'UKPRN')
ON CONFLICT (organisation_identifier_type_id) DO UPDATE
SET name = EXCLUDED.name;

INSERT INTO establishment.academy_trust_type (academy_trust_type_id, name) VALUES
    (1, 'Single-academy trust'),
    (2, 'Multi-academy trust'),
    (3, 'Secure single-academy trust')
ON CONFLICT (academy_trust_type_id) DO UPDATE
SET name = EXCLUDED.name;

INSERT INTO establishment.establishment_party_role_type (establishment_party_role_type_id, name) VALUES
    (1, 'Academy trust'),
    (2, 'Foundation trust'),
    (3, 'Umbrella trust'),
    (4, 'School sponsor')
ON CONFLICT (establishment_party_role_type_id) DO UPDATE
SET name = EXCLUDED.name;

INSERT INTO establishment.responsibility_type (responsibility_type_id, name) VALUES
    (1, 'Run by academy trust'),
    (2, 'Supported by foundation trust'),
    (3, 'Sponsored by'),
    (4, 'Proprietor')
ON CONFLICT (responsibility_type_id) DO UPDATE
SET name = EXCLUDED.name;

INSERT INTO establishment.organisation_group_type (organisation_group_type_id, name) VALUES
    (1, 'Federation'),
    (2, 'Children''s-centre group'),
    (3, 'Children''s-centre collaboration')
ON CONFLICT (organisation_group_type_id) DO UPDATE
SET name = EXCLUDED.name;

INSERT INTO establishment.group_identifier_type (group_identifier_type_id, name) VALUES
    (1, 'Group UID'),
    (2, 'Group ID')
ON CONFLICT (group_identifier_type_id) DO UPDATE
SET name = EXCLUDED.name;

INSERT INTO establishment.identifier_issuer (identifier_issuer_id, name) VALUES
    (1, 'GIAS'),
    (2, 'Establishment Registry')
ON CONFLICT (identifier_issuer_id) DO UPDATE
SET name = EXCLUDED.name;
