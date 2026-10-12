-- Actual SET ROLE probes; synthetic data and audit entries all roll back.
BEGIN;
DO $$
DECLARE owner_a uuid; owner_b uuid; identifier uuid; group_id uuid; school uuid;
        scheme integer; federation integer; centres integer; audit_id uuid; command text;
BEGIN
    IF (SELECT count(*) FROM pg_trigger t JOIN pg_class c ON c.oid=t.tgrelid
        JOIN pg_namespace n ON n.oid=c.relnamespace WHERE n.nspname='establishment' AND NOT t.tgisinternal)<>2
       OR EXISTS(SELECT 1 FROM pg_trigger t JOIN pg_class c ON c.oid=t.tgrelid JOIN pg_namespace n ON n.oid=c.relnamespace
                 WHERE n.nspname='establishment' AND NOT t.tgisinternal
                   AND (t.tgname NOT IN ('check_group_member_lead_period','check_membership_lead_boundaries') OR t.tgenabled<>'O')) THEN
        RAISE EXCEPTION 'Exactly the two enabled membership/lead boundary triggers are required';
    END IF;
    SELECT organisation_identifier_type_id INTO STRICT scheme FROM establishment.organisation_identifier_type WHERE name='Companies House number';
    SELECT organisation_group_type_id INTO STRICT federation FROM establishment.organisation_group_type WHERE name='Federation';
    SELECT organisation_group_type_id INTO STRICT centres FROM establishment.organisation_group_type WHERE name='Children''s-centre group';
    SET LOCAL ROLE epr_establishment_writer;
    INSERT INTO establishment.legal_entity(name) VALUES('Permission test owner A') RETURNING legal_entity_id INTO owner_a;
    INSERT INTO establishment.legal_entity(name) VALUES('Permission test owner B') RETURNING legal_entity_id INTO owner_b;
    INSERT INTO establishment.organisation_identifier(legal_entity_id,organisation_identifier_type_id,value)
    VALUES(owner_a,scheme,'PERMISSION_TEST_ID') RETURNING organisation_identifier_id INTO identifier;
    UPDATE establishment.organisation_identifier SET is_current=false WHERE organisation_identifier_id=identifier;
    INSERT INTO establishment.organisation_group(name,organisation_group_type_id)
    VALUES('Permission test group',federation) RETURNING organisation_group_id INTO group_id;
    UPDATE establishment.organisation_group SET name='Permission test renamed group' WHERE organisation_group_id=group_id;
    FOREACH command IN ARRAY ARRAY[
        format('UPDATE establishment.organisation_identifier SET legal_entity_id=%L WHERE organisation_identifier_id=%L',owner_b,identifier),
        format('UPDATE establishment.organisation_identifier SET value=%L WHERE organisation_identifier_id=%L','REWRITTEN',identifier),
        format('UPDATE establishment.organisation_identifier SET organisation_identifier_type_id=organisation_identifier_type_id WHERE organisation_identifier_id=%L',identifier),
        format('UPDATE establishment.organisation_identifier SET organisation_identifier_id=organisation_identifier_id WHERE organisation_identifier_id=%L',identifier),
        format('DELETE FROM establishment.organisation_identifier WHERE organisation_identifier_id=%L',identifier),
        'TRUNCATE establishment.organisation_identifier',
        format('UPDATE establishment.organisation_group SET organisation_group_type_id=%s WHERE organisation_group_id=%L',centres,group_id),
        'UPDATE establishment.organisation_group_type SET name=name',
        'DELETE FROM establishment.data_correction_audit',
        'TRUNCATE establishment.data_correction_audit',
        format('SELECT establishment.correct_protected_data(%L,%L,%L::jsonb,%L)','organisation_identifier',identifier,'{"value":"WRITER_CHANGE"}','Unapproved writer')
    ] LOOP
        BEGIN
            EXECUTE command;
            RAISE EXCEPTION 'Writer accepted forbidden operation: %',command;
        EXCEPTION WHEN insufficient_privilege THEN NULL;
        END;
    END LOOP;
    RESET ROLE;
    SET LOCAL ROLE epr_establishment_corrector;
    BEGIN
        PERFORM establishment.correct_protected_data('organisation_identifier',identifier,'{"value":"NO_REASON"}',NULL);
        RAISE EXCEPTION 'Correction without reason was accepted';
    EXCEPTION WHEN check_violation THEN NULL; END;
    audit_id:=establishment.correct_protected_data('organisation_identifier',identifier,jsonb_build_object('legal_entity_id',owner_b),'Reviewed synthetic identity correction');
    IF NOT EXISTS(SELECT 1 FROM establishment.data_correction_audit WHERE data_correction_audit_id=audit_id
        AND before_value->>'legal_entity_id'=owner_a::text AND after_value->>'legal_entity_id'=owner_b::text
        AND performed_by=session_user AND active_role='epr_establishment_corrector'
        AND reason='Reviewed synthetic identity correction') THEN
        RAISE EXCEPTION 'Correction audit did not preserve actor, reason and before/after values';
    END IF;
    PERFORM establishment.correct_protected_data('organisation_group',group_id,jsonb_build_object('organisation_group_type_id',centres),'Reviewed synthetic group correction');
    BEGIN
        UPDATE establishment.organisation_identifier SET value='DIRECT_ADMIN' WHERE organisation_identifier_id=identifier;
        RAISE EXCEPTION 'Correction operator had direct write access';
    EXCEPTION WHEN insufficient_privilege THEN NULL; END;
    BEGIN
        DELETE FROM establishment.data_correction_audit WHERE data_correction_audit_id=audit_id;
        RAISE EXCEPTION 'Correction operator deleted audit';
    EXCEPTION WHEN insufficient_privilege THEN NULL; END;
    RESET ROLE;
    SELECT establishment_id INTO school FROM establishment.establishment ORDER BY urn LIMIT 1;
    INSERT INTO establishment.organisation_group_member(organisation_group_id,establishment_id)
    VALUES(group_id,school);
    INSERT INTO establishment.organisation_group_member_lead_period(organisation_group_member_id,organisation_group_id,is_current)
    SELECT organisation_group_member_id,group_id,true FROM establishment.organisation_group_member WHERE organisation_group_id=group_id;
    SET LOCAL ROLE epr_establishment_corrector;
    BEGIN
        PERFORM establishment.correct_protected_data('organisation_group',group_id,jsonb_build_object('organisation_group_type_id',federation),'Would invalidate lead');
        RAISE EXCEPTION 'Correction invalidated lead group type';
    EXCEPTION WHEN check_violation THEN NULL; END;
    RESET ROLE;
END $$;
ROLLBACK;
SELECT 'Two-trigger permission and audited-correction checks passed' AS result;
