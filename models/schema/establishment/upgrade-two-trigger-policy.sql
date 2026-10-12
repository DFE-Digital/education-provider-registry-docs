-- Additive upgrade: preserve existing establishments, identities and evidence.
BEGIN;
\ir establishment-write-permissions.sql
DROP TRIGGER IF EXISTS organisation_identifier_ownership_protected ON establishment.organisation_identifier;
DROP FUNCTION IF EXISTS establishment.protect_organisation_identifier_ownership();
DROP TRIGGER IF EXISTS check_group_lead_type ON establishment.organisation_group;
DROP FUNCTION IF EXISTS establishment.check_group_lead_type();
COMMIT;
