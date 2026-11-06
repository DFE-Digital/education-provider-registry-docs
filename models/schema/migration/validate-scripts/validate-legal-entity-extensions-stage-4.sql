-- Stage 4 legal-entity subtype and partnership-link regressions.
BEGIN;
DO $$
DECLARE sole uuid:=gen_random_uuid(); partnership uuid:=gen_random_uuid(); company uuid:=gen_random_uuid();
       other_partnership uuid:=gen_random_uuid(); person uuid; member uuid; link uuid;
BEGIN
    INSERT INTO establishment.person DEFAULT VALUES RETURNING person_id INTO person;
    INSERT INTO establishment.legal_entity(legal_entity_id,name,legal_entity_type_id)
    VALUES(sole,'TEST ONLY sole trader',11),(partnership,'TEST ONLY partnership',12),
          (company,'TEST ONLY incorporated partner',3),(other_partnership,'TEST ONLY other partnership',12);
    INSERT INTO establishment.legal_entity_sole_trader(legal_entity_id,person_id) VALUES(sole,person);
    BEGIN
        INSERT INTO establishment.legal_entity_sole_trader(legal_entity_id,person_id) VALUES(company,person);
        RAISE EXCEPTION 'Company acquired a sole-trader subtype';
    EXCEPTION WHEN check_violation THEN NULL; END;
    BEGIN
        INSERT INTO establishment.legal_entity(name,legal_entity_type_id)
        VALUES('TEST ONLY another sole trader',11) RETURNING legal_entity_id INTO member;
        INSERT INTO establishment.legal_entity_sole_trader(legal_entity_id,person_id) VALUES(member,person);
        RAISE EXCEPTION 'A person was linked to two sole traders';
    EXCEPTION WHEN unique_violation THEN NULL; END;
    BEGIN
        UPDATE establishment.legal_entity SET legal_entity_type_id=3 WHERE legal_entity_id=sole;
        RAISE EXCEPTION 'Sole trader type was changed underneath subtype';
    EXCEPTION WHEN check_violation THEN NULL; END;
    INSERT INTO establishment.legal_entity_partner(partnership_legal_entity_id,partner_legal_entity_id,is_current)
    VALUES(partnership,company,true) RETURNING legal_entity_partner_id INTO link;
    BEGIN
        INSERT INTO establishment.legal_entity_partner(partnership_legal_entity_id,partner_legal_entity_id,is_current)
        VALUES(partnership,company,true);
        RAISE EXCEPTION 'Duplicate current body partner was accepted';
    EXCEPTION WHEN unique_violation THEN NULL; END;
    BEGIN
        INSERT INTO establishment.legal_entity_partner(partnership_legal_entity_id,partner_legal_entity_id,start_date,end_date)
        VALUES(partnership,company,'2020-01-01','2021-01-01');
        INSERT INTO establishment.legal_entity_partner(partnership_legal_entity_id,partner_legal_entity_id,start_date,end_date)
        VALUES(partnership,company,'2020-06-01','2022-01-01');
        RAISE EXCEPTION 'Overlapping known partner periods were accepted';
    EXCEPTION WHEN exclusion_violation THEN NULL; END;
    BEGIN
        INSERT INTO establishment.legal_entity_partner(partnership_legal_entity_id,partner_legal_entity_id)
        VALUES(partnership,partnership);
        RAISE EXCEPTION 'Self partnership was accepted';
    EXCEPTION WHEN check_violation THEN NULL; END;
    BEGIN
        INSERT INTO establishment.legal_entity_partner(partnership_legal_entity_id,partner_legal_entity_id)
        VALUES(other_partnership,sole);
        RAISE EXCEPTION 'Sole trader body was accepted as a partner';
    EXCEPTION WHEN check_violation THEN NULL; END;
    BEGIN
        INSERT INTO establishment.legal_entity_partner(partnership_legal_entity_id,partner_legal_entity_id)
        VALUES(company,partnership);
        RAISE EXCEPTION 'Non-partnership parent was accepted';
    EXCEPTION WHEN check_violation THEN NULL; END;
    BEGIN
        UPDATE establishment.legal_entity SET legal_entity_type_id=11 WHERE legal_entity_id=company;
        RAISE EXCEPTION 'Partner body was changed to an ineligible form';
    EXCEPTION WHEN check_violation THEN NULL; END;
    INSERT INTO establishment.legal_entity_partner(partnership_legal_entity_id,partner_person_id,is_current)
    VALUES(partnership,person,true);
    BEGIN
        INSERT INTO establishment.legal_entity_partner(partnership_legal_entity_id,partner_legal_entity_id,partner_person_id)
        VALUES(partnership,company,person);
        RAISE EXCEPTION 'Partner row with both endpoints was accepted';
    EXCEPTION WHEN check_violation THEN NULL; END;
    BEGIN
        UPDATE establishment.legal_entity SET legal_entity_type_id=NULL WHERE legal_entity_id=partnership;
        RAISE EXCEPTION 'Partnership parent form was changed beneath its links';
    EXCEPTION WHEN check_violation THEN NULL; END;
    BEGIN
        UPDATE establishment.legal_entity SET legal_entity_type_id=NULL WHERE legal_entity_id=company;
        RAISE EXCEPTION 'Partner body legal form was changed to null';
    EXCEPTION WHEN check_violation THEN NULL; END;
    UPDATE establishment.legal_entity SET legal_entity_type_id=5 WHERE legal_entity_id=company;
    UPDATE establishment.legal_entity SET legal_entity_type_id=3 WHERE legal_entity_id=company;
    BEGIN
        INSERT INTO establishment.legal_entity_partner(partnership_legal_entity_id,partner_person_id,is_current)
        VALUES(partnership,person,true);
        RAISE EXCEPTION 'Duplicate current person partner was accepted';
    EXCEPTION WHEN unique_violation THEN NULL; END;
    INSERT INTO establishment.person(person_id) VALUES(company);
    INSERT INTO establishment.legal_entity_partner(partnership_legal_entity_id,partner_person_id,start_date,end_date)
    VALUES(other_partnership,company,'2020-01-01','2021-01-01');
    INSERT INTO establishment.legal_entity_partner(partnership_legal_entity_id,partner_legal_entity_id,start_date,end_date)
    VALUES(other_partnership,company,'2020-01-01','2021-01-01');
END $$;
DO $$
DECLARE d jsonb; source jsonb; run uuid; party uuid:=gen_random_uuid(); address uuid:=gen_random_uuid(); link uuid:=gen_random_uuid();
        people_before integer; subtype_before integer; n integer; closed_school uuid; partner_parent uuid;
BEGIN
    SELECT count(*) INTO people_before FROM establishment.person;
    SELECT count(*) INTO subtype_before FROM establishment.legal_entity_sole_trader;
    INSERT INTO migration.migration_run(run_type,source_system,status) VALUES('TEST ONLY','TEST ONLY','running') RETURNING migration_run_id INTO run;
    source:=jsonb_build_object('system','TEST ONLY','table','reviewed fixture','key','individual-1',
        'observedDate','2026-06-16','observedValues',jsonb_build_object('ProprietorType','Individual Proprietor','name','Test trader'));
    d:=jsonb_build_object('decisionId','TEST ONLY individual','reviewStatus','accepted','proprietorKind','Individual',
        'legalEntityId',party,'legalEntityTypeId',11,'name','TEST ONLY reviewed trader','individualIdentityKey','TEST ONLY individual 1',
        'acceptedNameKind','trading_name','reviewEvidence','TEST ONLY explicitly reviewed synthetic fixture','source',source,
        'schools',jsonb_build_array(jsonb_build_object('urn',112461,'responsibilityId',gen_random_uuid(),'isCurrent',true),
                                   jsonb_build_object('urn',119009,'responsibilityId',gen_random_uuid(),'isCurrent',true)),
        'addresses',jsonb_build_array(jsonb_build_object('factKey','contact','addressId',address,'linkId',link,
            'purpose','Contact','line1','TEST ONLY business address','reviewEvidence','TEST ONLY selected contact purpose','source',source),
             jsonb_build_object('factKey','unknown-purpose','line1','TEST ONLY unclassified address','source',source)),
        'contactObservations',jsonb_build_object('telephone','TEST ONLY deferred contact'),
        'identifiers',jsonb_build_array(jsonb_build_object('type','Companies House number','value','UNVERIFIED',
            'verified',false,'source',source||jsonb_build_object('key','unverified-number',
                'observedValues',jsonb_build_object('observedNumber','UNVERIFIED')))));
    PERFORM migration.apply_reviewed_proprietor(d,run);
    PERFORM migration.apply_reviewed_proprietor(d,run);
    IF (SELECT count(*) FROM establishment.establishment_responsibility WHERE legal_entity_id=party)<>2
       OR (SELECT count(*) FROM establishment.legal_entity_address WHERE legal_entity_id=party)<>1
       OR (SELECT count(*) FROM migration.proprietor_fact_evidence WHERE decision_id=d->>'decisionId' AND review_status='pending')<>3
       OR (SELECT count(*) FROM establishment.person)<>people_before
       OR (SELECT count(*) FROM establishment.legal_entity_sole_trader)<>subtype_before THEN
        RAISE EXCEPTION 'Reviewed sole trader identity/address/repeat import or people deferral failed';
    END IF;
    BEGIN
        PERFORM migration.apply_reviewed_proprietor(jsonb_set(d,'{name}','"changed name"'),run);
        RAISE EXCEPTION 'Changed accepted proprietor decision was accepted';
    EXCEPTION WHEN raise_exception THEN
        IF SQLERRM NOT LIKE 'Accepted proprietor decision changed%' THEN RAISE; END IF;
    END;
    INSERT INTO establishment.establishment(urn,name,establishment_type_id)
    VALUES(999980,'TEST ONLY closed LLP school',(SELECT establishment_type_id FROM establishment.establishment_type WHERE code='11')) RETURNING establishment_id INTO closed_school;
    INSERT INTO establishment.establishment_lifecycle(establishment_id,establishment_status_id,close_date)
    VALUES(closed_school,2,'2020-01-01');
    d:=jsonb_build_object('decisionId','TEST ONLY LLP','reviewStatus','accepted','proprietorKind','Body',
        'legalEntityId',gen_random_uuid(),'legalEntityTypeId',5,'name','TEST ONLY reviewed LLP',
        'reviewEvidence','TEST ONLY accepted controlled LLP identity','source',source,
        'schools',jsonb_build_array(jsonb_build_object('urn',999980,'responsibilityId',gen_random_uuid(),'isCurrent',true)));
    BEGIN
        PERFORM migration.apply_reviewed_proprietor(d,run);
        RAISE EXCEPTION 'Closed LLP case acquired a current proprietor';
    EXCEPTION WHEN raise_exception THEN
        IF SQLERRM NOT LIKE 'Closed school cannot%' THEN RAISE; END IF;
    END;
    d:=jsonb_set(d,'{schools,0,isCurrent}','false');
    d:=d||jsonb_build_object('identifiers',jsonb_build_array(jsonb_build_object('type','Companies House number',
        'value','NC123456','verified',true,'verificationEvidence','TEST ONLY synthetic registration proof','source',source)));
    party:=migration.apply_reviewed_proprietor(d,run);
    SELECT legal_entity_id INTO STRICT partner_parent FROM establishment.legal_entity WHERE name='TEST ONLY partnership';
    INSERT INTO establishment.legal_entity_partner(partnership_legal_entity_id,partner_legal_entity_id,is_current)
    VALUES(partner_parent,party,true);
    BEGIN
        INSERT INTO establishment.legal_entity_partner(partnership_legal_entity_id,partner_legal_entity_id)
        VALUES(party,partner_parent);
        RAISE EXCEPTION 'LLP acquired its own member links';
    EXCEPTION WHEN check_violation THEN NULL; END;
    IF NOT EXISTS(SELECT 1 FROM establishment.organisation_identifier WHERE legal_entity_id=party AND value='NC123456')
       OR EXISTS(SELECT 1 FROM establishment.legal_entity_partner WHERE partnership_legal_entity_id=party)
       OR EXISTS(SELECT 1 FROM establishment.establishment_responsibility WHERE legal_entity_id=party AND is_current) THEN
        RAISE EXCEPTION 'LLP prefix, member deferral or closed-school history failed';
    END IF;
END $$;
ROLLBACK;
SELECT 'PASS: Stage 4 sole-trader, partnership, partner eligibility, uniqueness and form-change guards' AS result;
