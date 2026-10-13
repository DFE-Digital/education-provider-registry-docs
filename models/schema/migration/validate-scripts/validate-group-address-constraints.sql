-- Synthetic structural-constraint tests all roll back; no permissions policy.
BEGIN;
DO $$
DECLARE party uuid; postal uuid; new_postal uuid; group_id uuid; federation integer;
BEGIN
    SELECT organisation_group_type_id INTO STRICT federation FROM establishment.organisation_group_type WHERE name='Federation';
    INSERT INTO establishment.legal_entity(name) VALUES('Group-address constraint test') RETURNING legal_entity_id INTO party;
    INSERT INTO establishment.address(address_line_1) VALUES('Synthetic group-address constraint fixture') RETURNING address_id INTO postal;
    INSERT INTO establishment.organisation_group(name,organisation_group_type_id)
    VALUES('Group-address constraint federation',federation) RETURNING organisation_group_id INTO group_id;
    INSERT INTO establishment.legal_entity_address(legal_entity_id,address_id,address_purpose_id)
    VALUES(party,postal,3),(party,postal,2);
    BEGIN
        INSERT INTO establishment.legal_entity_address(legal_entity_id,address_id,address_purpose_id) VALUES(party,postal,3);
        RAISE EXCEPTION 'Duplicate owner/purpose was accepted';
    EXCEPTION WHEN unique_violation THEN NULL; END;
    BEGIN
        INSERT INTO establishment.legal_entity_address(legal_entity_id,address_id,address_purpose_id) VALUES(party,gen_random_uuid(),1);
        RAISE EXCEPTION 'Orphan address was accepted';
    EXCEPTION WHEN foreign_key_violation THEN NULL; END;
    INSERT INTO establishment.organisation_group_address(organisation_group_id,address_id,address_purpose_id)
    VALUES(group_id,postal,3),(group_id,postal,2);
    BEGIN
        INSERT INTO establishment.organisation_group_address(organisation_group_id,address_id,address_purpose_id) VALUES(group_id,postal,3);
        RAISE EXCEPTION 'Duplicate current group address accepted';
    EXCEPTION WHEN unique_violation THEN NULL; END;
    BEGIN
        INSERT INTO establishment.organisation_group_address(organisation_group_id,address_id,address_purpose_id) VALUES(group_id,postal,1);
        RAISE EXCEPTION 'Federation registered-office purpose was accepted';
    EXCEPTION WHEN check_violation THEN NULL; END;
    -- Purpose code semantics are protected by a structural CHECK, not permissions.
    BEGIN
        UPDATE establishment.address_purpose SET code='registered' WHERE address_purpose_id=3;
        RAISE EXCEPTION 'Invalid address-purpose code mapping accepted';
    EXCEPTION WHEN check_violation THEN NULL; END;
    -- A real move ends the old assertion and creates a new one atomically.
    INSERT INTO establishment.address(address_line_1) VALUES('Synthetic moved address') RETURNING address_id INTO new_postal;
    UPDATE establishment.legal_entity_address SET is_current=false,end_date=DATE '2021-01-01'
    WHERE legal_entity_id=party AND address_purpose_id=3;
    INSERT INTO establishment.legal_entity_address(legal_entity_id,address_id,address_purpose_id,start_date,end_date,is_current)
    VALUES(party,postal,3,DATE '2021-01-01',DATE '2022-01-01',false),
          (party,new_postal,3,DATE '2022-01-01',NULL,true);
    UPDATE establishment.organisation_group_address SET is_current=false,end_date=DATE '2021-01-01'
    WHERE organisation_group_id=group_id AND address_purpose_id=3;
    INSERT INTO establishment.organisation_group_address(organisation_group_id,address_id,address_purpose_id,start_date,end_date,is_current)
    VALUES(group_id,postal,3,DATE '2021-01-01',DATE '2022-01-01',false),
          (group_id,new_postal,3,DATE '2022-01-01',NULL,true);
    IF NOT EXISTS(SELECT 1 FROM establishment.legal_entity_address WHERE legal_entity_id=party AND address_purpose_id=2 AND is_current AND address_id=postal)
       OR NOT EXISTS(SELECT 1 FROM establishment.address WHERE address_id=postal AND address_line_1='Synthetic group-address constraint fixture') THEN
        RAISE EXCEPTION 'Move changed another purpose or old postal values';
    END IF;
    BEGIN
        INSERT INTO establishment.legal_entity_address(legal_entity_id,address_id,address_purpose_id,start_date,end_date,is_current)
        VALUES(party,postal,3,DATE '2021-06-01',DATE '2022-06-01',false);
        RAISE EXCEPTION 'Overlapping legal-entity periods accepted';
    EXCEPTION WHEN exclusion_violation THEN NULL; END;
    BEGIN
        INSERT INTO establishment.organisation_group_address(organisation_group_id,address_id,address_purpose_id,start_date,end_date,is_current)
        VALUES(group_id,postal,3,DATE '2021-06-01',DATE '2022-06-01',false);
        RAISE EXCEPTION 'Overlapping group periods accepted';
    EXCEPTION WHEN exclusion_violation THEN NULL; END;
    BEGIN
        INSERT INTO establishment.legal_entity_address(legal_entity_id,address_id,address_purpose_id,start_date,end_date,is_current)
        VALUES(party,postal,3,DATE '2022-01-01',DATE '2022-01-01',false);
        RAISE EXCEPTION 'Zero-length period accepted';
    EXCEPTION WHEN check_violation THEN NULL; END;
    BEGIN
        INSERT INTO establishment.organisation_group_address(organisation_group_id,address_id,address_purpose_id,start_date,end_date,is_current)
        VALUES(group_id,postal,3,DATE '2022-01-01',DATE '2021-01-01',false);
        RAISE EXCEPTION 'Reversed group period accepted';
    EXCEPTION WHEN check_violation THEN NULL; END;
    IF (SELECT count(*) FROM establishment.legal_entity_address WHERE legal_entity_id=party AND address_purpose_id=3)<>3
       OR (SELECT count(*) FROM establishment.organisation_group_address WHERE organisation_group_id=group_id AND address_purpose_id=3)<>3 THEN
        RAISE EXCEPTION 'Address history was not retained';
    END IF;
END $$;
ROLLBACK;
SELECT 'Group address history, FK, purpose and uniqueness checks passed' AS result;
