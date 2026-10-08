-- Dated lead designation, independent of membership. Also used by the additive
-- local upgrade; do not drop existing groups or memberships.
CREATE EXTENSION IF NOT EXISTS btree_gist;
CREATE UNIQUE INDEX IF NOT EXISTS organisation_group_member_group_key
    ON establishment.organisation_group_member (organisation_group_member_id, organisation_group_id);

CREATE TABLE IF NOT EXISTS establishment.organisation_group_member_lead_period (
    organisation_group_member_lead_period_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    organisation_group_member_id uuid NOT NULL,
    organisation_group_id uuid NOT NULL,
    start_date date,
    end_date date,
    is_current boolean NOT NULL,
    FOREIGN KEY (organisation_group_member_id, organisation_group_id)
        REFERENCES establishment.organisation_group_member (organisation_group_member_id, organisation_group_id),
    CHECK (start_date IS NULL OR end_date IS NULL OR end_date > start_date),
    -- Only fully evidenced periods participate. NULL is unknown, not infinity.
    EXCLUDE USING gist (organisation_group_id WITH =, daterange(start_date,end_date,'[)') WITH &&)
        WHERE (start_date IS NOT NULL AND end_date IS NOT NULL)
);
CREATE UNIQUE INDEX IF NOT EXISTS organisation_group_lead_current_unique
    ON establishment.organisation_group_member_lead_period (organisation_group_id) WHERE is_current;
CREATE INDEX IF NOT EXISTS organisation_group_lead_member_index
    ON establishment.organisation_group_member_lead_period (organisation_group_member_id);

CREATE OR REPLACE FUNCTION establishment.check_group_member_lead_period()
RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE member_record record;
BEGIN
    SELECT m.joined_date,m.left_date,t.name AS group_type INTO STRICT member_record
    FROM establishment.organisation_group_member m
    JOIN establishment.organisation_group g USING (organisation_group_id)
    JOIN establishment.organisation_group_type t USING (organisation_group_type_id)
    WHERE m.organisation_group_member_id=NEW.organisation_group_member_id
      AND m.organisation_group_id=NEW.organisation_group_id
    FOR SHARE OF m,g;
    IF member_record.group_type<>'Children''s-centre group' THEN
        RAISE EXCEPTION 'Lead periods apply only to childrens-centre group memberships' USING ERRCODE='23514';
    END IF;
    IF (NEW.start_date IS NOT NULL AND member_record.joined_date IS NOT NULL AND NEW.start_date<member_record.joined_date)
       OR (NEW.end_date IS NOT NULL AND member_record.left_date IS NOT NULL AND NEW.end_date>member_record.left_date)
       OR (NEW.start_date IS NOT NULL AND member_record.left_date IS NOT NULL AND NEW.start_date>=member_record.left_date)
       OR (NEW.end_date IS NOT NULL AND member_record.joined_date IS NOT NULL AND NEW.end_date<=member_record.joined_date) THEN
        RAISE EXCEPTION 'Lead period falls outside known membership boundaries' USING ERRCODE='23514';
    END IF;
    IF NEW.is_current AND member_record.left_date IS NOT NULL AND member_record.left_date<=CURRENT_DATE THEN
        RAISE EXCEPTION 'An ended membership cannot hold a current lead assertion' USING ERRCODE='23514';
    END IF;
    RETURN NEW;
END $$;
DROP TRIGGER IF EXISTS check_group_member_lead_period ON establishment.organisation_group_member_lead_period;
CREATE TRIGGER check_group_member_lead_period BEFORE INSERT OR UPDATE
    ON establishment.organisation_group_member_lead_period
    FOR EACH ROW EXECUTE FUNCTION establishment.check_group_member_lead_period();

CREATE OR REPLACE FUNCTION establishment.check_membership_lead_boundaries()
RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM establishment.organisation_group_member_lead_period p
        WHERE p.organisation_group_member_id=NEW.organisation_group_member_id
          AND ((p.start_date IS NOT NULL AND NEW.joined_date IS NOT NULL AND p.start_date<NEW.joined_date)
            OR (p.end_date IS NOT NULL AND NEW.left_date IS NOT NULL AND p.end_date>NEW.left_date)
            OR (p.start_date IS NOT NULL AND NEW.left_date IS NOT NULL AND p.start_date>=NEW.left_date)
            OR (p.end_date IS NOT NULL AND NEW.joined_date IS NOT NULL AND p.end_date<=NEW.joined_date))) THEN
        RAISE EXCEPTION 'Membership change would exclude an existing lead period' USING ERRCODE='23514';
    END IF;
    IF NEW.left_date IS NOT NULL AND NEW.left_date<=CURRENT_DATE AND EXISTS (
        SELECT 1 FROM establishment.organisation_group_member_lead_period p
        WHERE p.organisation_group_member_id=NEW.organisation_group_member_id AND p.is_current) THEN
        RAISE EXCEPTION 'End the current lead assertion before ending membership' USING ERRCODE='23514';
    END IF;
    RETURN NEW;
END $$;
DROP TRIGGER IF EXISTS check_membership_lead_boundaries ON establishment.organisation_group_member;
CREATE TRIGGER check_membership_lead_boundaries BEFORE UPDATE OF joined_date,left_date
    ON establishment.organisation_group_member
    FOR EACH ROW EXECUTE FUNCTION establishment.check_membership_lead_boundaries();

CREATE OR REPLACE FUNCTION establishment.check_group_lead_type()
RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM establishment.organisation_group_member_lead_period p
               WHERE p.organisation_group_id=NEW.organisation_group_id)
       AND NOT EXISTS (SELECT 1 FROM establishment.organisation_group_type t
                       WHERE t.organisation_group_type_id=NEW.organisation_group_type_id
                         AND t.name='Children''s-centre group') THEN
        RAISE EXCEPTION 'A group with lead periods must remain a childrens-centre group' USING ERRCODE='23514';
    END IF;
    RETURN NEW;
END $$;
DROP TRIGGER IF EXISTS check_group_lead_type ON establishment.organisation_group;
CREATE TRIGGER check_group_lead_type BEFORE UPDATE OF organisation_group_type_id
    ON establishment.organisation_group
    FOR EACH ROW EXECUTE FUNCTION establishment.check_group_lead_type();

CREATE OR REPLACE FUNCTION establishment.refresh_member_lead_flag()
RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
    IF TG_OP<>'INSERT' THEN
        UPDATE establishment.organisation_group_member m SET is_lead_member=EXISTS (
            SELECT 1 FROM establishment.organisation_group_member_lead_period p
            WHERE p.organisation_group_member_id=m.organisation_group_member_id AND p.is_current)
        WHERE m.organisation_group_member_id=OLD.organisation_group_member_id;
    END IF;
    IF TG_OP<>'DELETE' THEN
        UPDATE establishment.organisation_group_member m SET is_lead_member=EXISTS (
            SELECT 1 FROM establishment.organisation_group_member_lead_period p
            WHERE p.organisation_group_member_id=m.organisation_group_member_id AND p.is_current)
        WHERE m.organisation_group_member_id=NEW.organisation_group_member_id;
    END IF;
    RETURN NULL;
END $$;
DROP TRIGGER IF EXISTS refresh_member_lead_flag ON establishment.organisation_group_member_lead_period;
CREATE TRIGGER refresh_member_lead_flag AFTER INSERT OR UPDATE OR DELETE
    ON establishment.organisation_group_member_lead_period
    FOR EACH ROW EXECUTE FUNCTION establishment.refresh_member_lead_flag();
