-- Additive local upgrade. Preserve existing membership and party identities.
BEGIN;
\ir organisation-group-member-lead-period-schema.sql
-- Older targets may still have the compatibility flag. Preserve true assertions
-- before removing it; explicit STANDARD/LEAD source values remain in evidence.
DO $$ BEGIN
 IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='establishment'
            AND table_name='organisation_group_member' AND column_name='is_lead_member') THEN
  EXECUTE 'INSERT INTO establishment.organisation_group_member_lead_period
    (organisation_group_member_id,organisation_group_id,is_current)
   SELECT m.organisation_group_member_id,m.organisation_group_id,true
   FROM establishment.organisation_group_member m
   WHERE m.is_lead_member AND NOT EXISTS (
     SELECT 1 FROM establishment.organisation_group_member_lead_period p
     WHERE p.organisation_group_member_id=m.organisation_group_member_id AND p.is_current)';
 END IF;
END $$;
ALTER TABLE establishment.organisation_group_member DROP COLUMN IF EXISTS is_lead_member;
-- No start or end is inferred from membership or observation dates.
COMMIT;
