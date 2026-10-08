-- Additive local upgrade. Preserve existing membership and party identities.
BEGIN;
\ir organisation-group-member-lead-period-schema.sql
INSERT INTO establishment.organisation_group_member_lead_period
    (organisation_group_member_id,organisation_group_id,is_current)
SELECT m.organisation_group_member_id,m.organisation_group_id,true
FROM establishment.organisation_group_member m
WHERE m.is_lead_member AND NOT EXISTS (
    SELECT 1 FROM establishment.organisation_group_member_lead_period p
    WHERE p.organisation_group_member_id=m.organisation_group_member_id AND p.is_current);
-- No start or end is inferred from membership or observation dates.
COMMIT;
