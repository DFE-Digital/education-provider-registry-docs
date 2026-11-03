-- Synthetic integrity probes. All test rows and changes are rolled back.
BEGIN;
DO $$
DECLARE
    area uuid := gen_random_uuid();
    body uuid := gen_random_uuid();
    other_body uuid := gen_random_uuid();
    company uuid := gen_random_uuid();
    unknown_body uuid := gen_random_uuid();
    period uuid := gen_random_uuid();
    replacement uuid := gen_random_uuid();
    school uuid;
BEGIN
    INSERT INTO establishment.local_authority_area(local_authority_area_id,code,name,local_authority_jurisdiction_id)
    VALUES(area,999,'TEST ONLY council constraints',1);
    INSERT INTO establishment.legal_entity(legal_entity_id,name,legal_entity_type_id)
    VALUES(body,'TEST ONLY council A',9),(other_body,'TEST ONLY council B',9),
          (company,'TEST ONLY company',3),(unknown_body,'TEST ONLY unknown',NULL);
    BEGIN
        INSERT INTO establishment.local_authority_area_council_period(local_authority_area_id,legal_entity_id)
        VALUES(area,company);
        RAISE EXCEPTION 'Company holder was accepted';
    EXCEPTION WHEN check_violation THEN NULL; END;
    BEGIN
        INSERT INTO establishment.local_authority_area_council_period(local_authority_area_id,legal_entity_id)
        VALUES(area,unknown_body);
        RAISE EXCEPTION 'Unknown form was accepted';
    EXCEPTION WHEN check_violation THEN NULL; END;
    INSERT INTO establishment.local_authority_area_council_period
        (local_authority_area_council_period_id,local_authority_area_id,legal_entity_id,start_date,end_date,is_current)
    VALUES(period,area,body,'2000-01-01','2010-01-01',true);
    BEGIN
        INSERT INTO establishment.local_authority_area_council_period(local_authority_area_id,legal_entity_id,is_current)
        VALUES(area,other_body,true);
        RAISE EXCEPTION 'Two current councils were accepted';
    EXCEPTION WHEN unique_violation THEN NULL; END;
    BEGIN
        INSERT INTO establishment.local_authority_area_council_period(local_authority_area_id,legal_entity_id,start_date,end_date)
        VALUES(area,other_body,'2005-01-01','2015-01-01');
        RAISE EXCEPTION 'Overlapping known council periods were accepted';
    EXCEPTION WHEN exclusion_violation THEN NULL; END;
    BEGIN
        UPDATE establishment.legal_entity SET legal_entity_type_id=NULL WHERE legal_entity_id=body;
        RAISE EXCEPTION 'Referenced council type was invalidated';
    EXCEPTION WHEN check_violation THEN NULL; END;
    UPDATE establishment.legal_entity SET legal_entity_type_id=9 WHERE legal_entity_id=body;
    -- Future maintenance type exists only inside this rolled-back test.
    INSERT INTO establishment.establishment_responsibility_type VALUES(5,'TEST ONLY maintenance') ON CONFLICT DO NOTHING;
    SELECT establishment_id INTO STRICT school FROM establishment.establishment ORDER BY urn LIMIT 1;
    INSERT INTO establishment.establishment_responsibility(establishment_id,legal_entity_id,responsibility_type_id)
    VALUES(school,body,5);
    BEGIN
        DELETE FROM establishment.local_authority_area_council_period WHERE local_authority_area_council_period_id=period;
        SET CONSTRAINTS establishment.check_council_retains_area_link IMMEDIATE;
        RAISE EXCEPTION 'Last council link deletion was accepted';
    EXCEPTION WHEN check_violation THEN NULL; END;
    BEGIN
        UPDATE establishment.local_authority_area_council_period SET legal_entity_id=other_body
        WHERE local_authority_area_council_period_id=period;
        SET CONSTRAINTS establishment.check_council_retains_area_link IMMEDIATE;
        RAISE EXCEPTION 'Last council link reassignment was accepted';
    EXCEPTION WHEN check_violation THEN NULL; END;
    DELETE FROM establishment.local_authority_area_council_period WHERE local_authority_area_council_period_id=period;
    INSERT INTO establishment.local_authority_area_council_period
        (local_authority_area_council_period_id,local_authority_area_id,legal_entity_id)
    VALUES(replacement,area,body);
    SET CONSTRAINTS establishment.check_council_retains_area_link IMMEDIATE;
END $$;
ROLLBACK;
SELECT 'PASS: council holder, type, period, current and atomic-link-replacement guards' AS result;
