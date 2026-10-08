-- General invariants, followed by synthetic histories rolled back inside the DO block.
DO $$
DECLARE
    group_id uuid := gen_random_uuid();
    federation_id uuid := gen_random_uuid();
    member_a uuid := gen_random_uuid();
    member_b uuid := gen_random_uuid();
    federation_member uuid := gen_random_uuid();
    period_a uuid := gen_random_uuid();
    current_period uuid := gen_random_uuid();
    centre_id uuid;
    rejected boolean;
BEGIN
    IF EXISTS (
        SELECT 1 FROM establishment.organisation_group_member m
        JOIN establishment.organisation_group g USING (organisation_group_id)
        JOIN establishment.organisation_group_type t USING (organisation_group_type_id)
        WHERE (t.name='Children''s-centre group' AND
            ((m.is_lead_member IS TRUE) IS DISTINCT FROM EXISTS (
                SELECT 1 FROM establishment.organisation_group_member_lead_period p
                WHERE p.organisation_group_member_id=m.organisation_group_member_id AND p.is_current)))
           OR (t.name<>'Children''s-centre group' AND m.is_lead_member IS NOT NULL)
    ) THEN RAISE EXCEPTION 'Membership lead flags disagree with current lead periods or group type'; END IF;

    -- This subtransaction rolls back even when all assertions pass.
    BEGIN
        SELECT e.establishment_id INTO STRICT centre_id
        FROM establishment.establishment e JOIN establishment.establishment_type t USING (establishment_type_id)
        WHERE t.name='Children''s centre' ORDER BY e.urn LIMIT 1;
        INSERT INTO establishment.organisation_group (organisation_group_id,name,organisation_group_type_id,local_authority_id)
        SELECT group_id,'Lead-period regression group',t.organisation_group_type_id,la.local_authority_id
        FROM establishment.organisation_group_type t CROSS JOIN establishment.local_authority la
        WHERE t.name='Children''s-centre group' ORDER BY la.code LIMIT 1;
        INSERT INTO establishment.organisation_group (organisation_group_id,name,organisation_group_type_id)
        SELECT federation_id,'Lead-period regression federation',organisation_group_type_id
        FROM establishment.organisation_group_type WHERE name='Federation';
        INSERT INTO establishment.organisation_group_member
            (organisation_group_member_id,organisation_group_id,establishment_id,joined_date,left_date,is_lead_member)
        VALUES (member_a,group_id,centre_id,'2016-10-01','2030-01-01',false);
        INSERT INTO establishment.organisation_group_member
            (organisation_group_member_id,organisation_group_id,establishment_id,joined_date,left_date,is_lead_member)
        SELECT member_b,group_id,e.establishment_id,'2016-10-01','2030-01-01',false
        FROM establishment.establishment e JOIN establishment.establishment_type t USING (establishment_type_id)
        WHERE t.name='Children''s centre' AND e.establishment_id<>centre_id ORDER BY e.urn LIMIT 1;
        IF NOT FOUND THEN RAISE EXCEPTION 'Lead regression requires two childrens centres'; END IF;
        INSERT INTO establishment.organisation_group_member
            (organisation_group_member_id,organisation_group_id,establishment_id,joined_date,is_lead_member)
        VALUES (federation_member,federation_id,centre_id,'2016-10-01',NULL);

        INSERT INTO establishment.organisation_group_member_lead_period
            (organisation_group_member_lead_period_id,organisation_group_member_id,organisation_group_id,start_date,end_date,is_current)
        VALUES (period_a,member_a,group_id,'2018-04-01','2022-04-01',false),
               (gen_random_uuid(),member_b,group_id,'2022-04-01','2024-04-01',false),
               (current_period,member_a,group_id,'2024-04-01','2028-04-01',true);
        IF (SELECT count(*) FROM establishment.organisation_group_member_lead_period
            WHERE organisation_group_member_id=member_a)<>2
           OR NOT EXISTS (SELECT 1 FROM establishment.organisation_group_member
                          WHERE organisation_group_member_id=member_a AND is_lead_member AND joined_date='2016-10-01')
           OR NOT EXISTS (SELECT 1 FROM establishment.organisation_group_member
                          WHERE organisation_group_member_id=member_b AND NOT is_lead_member AND joined_date='2016-10-01') THEN
            RAISE EXCEPTION 'Returning as lead must retain separate periods without changing membership';
        END IF;
        IF EXISTS (
            SELECT 1 FROM (VALUES (DATE '2018-03-31',NULL::uuid),(DATE '2022-03-31',member_a),
                                 (DATE '2022-04-01',member_b),(DATE '2024-04-01',member_a),
                                 (DATE '2028-04-01',NULL::uuid)) expected(on_date,member_id)
            WHERE expected.member_id IS DISTINCT FROM (
                SELECT p.organisation_group_member_id FROM establishment.organisation_group_member_lead_period p
                WHERE p.organisation_group_id=group_id AND p.start_date<=expected.on_date AND p.end_date>expected.on_date)
        ) THEN RAISE EXCEPTION 'Historical queries or inclusive-start/exclusive-end handovers are incorrect'; END IF;

        rejected:=false;
        BEGIN
            INSERT INTO establishment.organisation_group_member_lead_period
                (organisation_group_member_id,organisation_group_id,start_date,end_date,is_current)
            VALUES (member_b,group_id,'2021-04-01','2023-04-01',false);
        EXCEPTION WHEN exclusion_violation THEN rejected:=true; END;
        IF NOT rejected THEN RAISE EXCEPTION 'Overlapping historical leads were accepted'; END IF;
        rejected:=false;
        BEGIN
            INSERT INTO establishment.organisation_group_member_lead_period
                (organisation_group_member_id,organisation_group_id,is_current) VALUES (member_b,group_id,true);
        EXCEPTION WHEN unique_violation THEN rejected:=true; END;
        IF NOT rejected THEN RAISE EXCEPTION 'Two current leads were accepted'; END IF;
        rejected:=false;
        BEGIN
            INSERT INTO establishment.organisation_group_member_lead_period
                (organisation_group_member_id,organisation_group_id,start_date,end_date,is_current)
            VALUES (member_a,group_id,'2015-01-01','2016-01-01',false);
        EXCEPTION WHEN check_violation THEN rejected:=true; END;
        IF NOT rejected THEN RAISE EXCEPTION 'Lead period outside membership was accepted'; END IF;
        rejected:=false;
        BEGIN
            INSERT INTO establishment.organisation_group_member_lead_period
                (organisation_group_member_id,organisation_group_id,start_date,end_date,is_current)
            VALUES (member_a,group_id,'2029-01-01','2029-01-01',false);
        EXCEPTION WHEN check_violation THEN rejected:=true; END;
        IF NOT rejected THEN RAISE EXCEPTION 'Empty lead period was accepted'; END IF;
        rejected:=false;
        BEGIN
            INSERT INTO establishment.organisation_group_member_lead_period
                (organisation_group_member_id,organisation_group_id,is_current) VALUES (federation_member,federation_id,false);
        EXCEPTION WHEN check_violation THEN rejected:=true; END;
        IF NOT rejected THEN RAISE EXCEPTION 'Federation lead period was accepted'; END IF;
        rejected:=false;
        BEGIN
            UPDATE establishment.organisation_group SET organisation_group_type_id=
                (SELECT organisation_group_type_id FROM establishment.organisation_group_type WHERE name='Federation')
            WHERE organisation_group_id=group_id;
        EXCEPTION WHEN check_violation THEN rejected:=true; END;
        IF NOT rejected THEN RAISE EXCEPTION 'Changing the type of a group with lead periods was accepted'; END IF;
        rejected:=false;
        BEGIN
            UPDATE establishment.organisation_group_member SET joined_date='2019-01-01'
            WHERE organisation_group_member_id=member_a;
        EXCEPTION WHEN check_violation THEN rejected:=true; END;
        IF NOT rejected THEN RAISE EXCEPTION 'Membership update invalidating historical lead periods was accepted'; END IF;

        -- Ending the current assertion updates the flag, not the unknown business date.
        UPDATE establishment.organisation_group_member_lead_period SET is_current=false WHERE organisation_group_member_lead_period_id=current_period;
        INSERT INTO establishment.organisation_group_member_lead_period
            (organisation_group_member_id,organisation_group_id,is_current) VALUES (member_b,group_id,true);
        IF EXISTS (SELECT 1 FROM establishment.organisation_group_member WHERE organisation_group_member_id=member_a AND is_lead_member)
           OR NOT EXISTS (SELECT 1 FROM establishment.organisation_group_member_lead_period
                          WHERE organisation_group_member_id=member_b AND is_current AND start_date IS NULL AND end_date IS NULL) THEN
            RAISE EXCEPTION 'Current-only lead assertions invented dates or failed to update flags';
        END IF;
        rejected:=false;
        BEGIN
            UPDATE establishment.organisation_group_member SET left_date=CURRENT_DATE WHERE organisation_group_member_id=member_b;
        EXCEPTION WHEN check_violation THEN rejected:=true; END;
        IF NOT rejected THEN RAISE EXCEPTION 'Ending membership while retaining a current lead was accepted'; END IF;
        DELETE FROM establishment.organisation_group_member_lead_period WHERE organisation_group_member_id=member_b AND is_current;
        UPDATE establishment.organisation_group_member SET left_date=CURRENT_DATE WHERE organisation_group_member_id=member_b;
        rejected:=false;
        BEGIN
            INSERT INTO establishment.organisation_group_member_lead_period
                (organisation_group_member_id,organisation_group_id,is_current) VALUES (member_b,group_id,true);
        EXCEPTION WHEN check_violation THEN rejected:=true; END;
        IF NOT rejected THEN RAISE EXCEPTION 'Current lead on an ended membership was accepted'; END IF;
        RAISE EXCEPTION USING ERRCODE='ZX001', MESSAGE='Rollback synthetic lead histories';
    EXCEPTION WHEN SQLSTATE 'ZX001' THEN NULL;
    END;
END $$;

-- Incomplete dates are retained for review, never interpreted as infinity.
SELECT count(*) AS lead_assertions_with_unknown_boundaries
FROM establishment.organisation_group_member_lead_period
WHERE start_date IS NULL OR end_date IS NULL;
