-- Controlled values for the establishment-party-role physical slice.
-- These are target-owned values, not BAU type codes.

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
