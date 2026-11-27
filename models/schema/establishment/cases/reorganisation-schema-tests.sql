-- Run only in a disposable schema with the establishment DDL and reorganisation
-- reference seed loaded. All synthetic data and test helpers roll back.
BEGIN;
INSERT INTO establishment.establishment_type_category(code,name) VALUES (990001,'Reorganisation test category');
INSERT INTO establishment.establishment_type(code,name,establishment_type_category_id)
SELECT '__reorg_test__','Reorganisation test type',establishment_type_category_id
FROM establishment.establishment_type_category WHERE code=990001;
INSERT INTO establishment.establishment_status(code,name) VALUES(2,'Closed'),(1,'Open') ON CONFLICT DO NOTHING;
DO $$
DECLARE pattern integer; k integer; eid uuid; a uuid; b uuid; c uuid; d uuid;
BEGIN
    FOR pattern IN 1..7 LOOP
        eid:=md5('reorganisation-test-event-'||pattern)::uuid;
        FOR k IN 1..4 LOOP
            INSERT INTO establishment.establishment(establishment_id,urn,name,establishment_type_id)
            SELECT md5('reorganisation-test-'||pattern||'-'||k)::uuid,980000+pattern*10+k,
                   'Controlled reorganisation test '||pattern||'/'||k,establishment_type_id
            FROM establishment.establishment_type WHERE code='__reorg_test__';
            INSERT INTO establishment.establishment_lifecycle(establishment_id,establishment_status_id)
            SELECT md5('reorganisation-test-'||pattern||'-'||k)::uuid,establishment_status_id
            FROM establishment.establishment_status WHERE code=CASE WHEN k<=2 THEN 2 ELSE 1 END;
        END LOOP;
        a:=md5('reorganisation-test-'||pattern||'-1')::uuid;
        b:=md5('reorganisation-test-'||pattern||'-2')::uuid;
        c:=md5('reorganisation-test-'||pattern||'-3')::uuid;
        d:=md5('reorganisation-test-'||pattern||'-4')::uuid;
        INSERT INTO establishment.establishment_reorganisation VALUES(eid,pattern,NULL,NULL,'Controlled shape test');
        IF pattern IN (1,2,3,4,7) THEN
            INSERT INTO establishment.reorganisation_participant(establishment_reorganisation_id,establishment_id,reorganisation_outcome_id)
            VALUES(eid,a,1);
        END IF;
        IF pattern IN (3,7) THEN
            INSERT INTO establishment.reorganisation_participant(establishment_reorganisation_id,establishment_id,reorganisation_outcome_id)
            VALUES(eid,b,1);
        END IF;
        INSERT INTO establishment.reorganisation_participant(establishment_reorganisation_id,establishment_id,reorganisation_outcome_id)
        VALUES(eid,c,CASE WHEN pattern IN(1,3,4) THEN 2 ELSE 3 END);
        IF pattern IN(4,5,6,7) THEN
            INSERT INTO establishment.reorganisation_participant(establishment_reorganisation_id,establishment_id,reorganisation_outcome_id)
            VALUES(eid,d,CASE WHEN pattern IN(4,5) THEN 2 ELSE 3 END);
        END IF;
        IF pattern IN(1,2,3,4,7) THEN
            INSERT INTO establishment.establishment_succession(predecessor_establishment_id,successor_establishment_id,establishment_reorganisation_id)
            VALUES(a,c,eid);
        END IF;
        IF pattern IN(3,7) THEN
            INSERT INTO establishment.establishment_succession(predecessor_establishment_id,successor_establishment_id,establishment_reorganisation_id)
            VALUES(b,c,eid);
        END IF;
        IF pattern IN(4,7) THEN
            INSERT INTO establishment.establishment_succession(predecessor_establishment_id,successor_establishment_id,establishment_reorganisation_id)
            VALUES(a,d,eid);
        END IF;
        IF pattern IN(5,6) THEN
            INSERT INTO establishment.establishment_provision_transfer(origin_establishment_id,recipient_establishment_id,establishment_reorganisation_id)
            VALUES(c,d,eid);
        END IF;
    END LOOP;
END $$;
SET CONSTRAINTS ALL IMMEDIATE;

-- Effects remain optional changes accompanying a multi-establishment event.
INSERT INTO establishment.reorganisation_effect(reorganisation_participant_id,reorganisation_effect_type_id)
SELECT reorganisation_participant_id,1 FROM establishment.reorganisation_participant
WHERE establishment_reorganisation_id=md5('reorganisation-test-event-2')::uuid AND reorganisation_outcome_id=3;
DELETE FROM establishment.reorganisation_effect;

CREATE FUNCTION pg_temp.expect_reorganisation_failure(statement text, expected_state text)
RETURNS void LANGUAGE plpgsql AS $$
DECLARE actual text;
BEGIN
    BEGIN
        EXECUTE statement;
        SET CONSTRAINTS ALL IMMEDIATE;
    EXCEPTION WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS actual=RETURNED_SQLSTATE;
        IF actual<>expected_state THEN RAISE EXCEPTION 'Expected %, got % for %',expected_state,actual,statement; END IF;
        RETURN;
    END;
    RAISE EXCEPTION 'Invalid reorganisation mutation unexpectedly succeeded: %',statement;
END $$;

-- Deferred validation must also protect later edits and deletions.
SELECT pg_temp.expect_reorganisation_failure(
 $$UPDATE establishment.establishment_reorganisation SET reorganisation_pattern_id=3 WHERE reorganisation_pattern_id=1$$,'23514');
SELECT pg_temp.expect_reorganisation_failure(
 $$DELETE FROM establishment.establishment_succession WHERE establishment_reorganisation_id=md5('reorganisation-test-event-1')::uuid$$,'23514');
SELECT pg_temp.expect_reorganisation_failure(
 $$INSERT INTO establishment.reorganisation_pattern VALUES (8,'Change to one establishment')$$,'23514');
SELECT pg_temp.expect_reorganisation_failure(
 $$DO $single$ BEGIN
 SET CONSTRAINTS ALL DEFERRED;
 INSERT INTO establishment.establishment_reorganisation(establishment_reorganisation_id,reorganisation_pattern_id)
 VALUES(md5('single-establishment-change')::uuid,6);
 INSERT INTO establishment.reorganisation_participant(establishment_reorganisation_id,establishment_id,reorganisation_outcome_id)
 VALUES(md5('single-establishment-change')::uuid,md5('reorganisation-test-6-3')::uuid,3);
 INSERT INTO establishment.reorganisation_effect(reorganisation_participant_id,reorganisation_effect_type_id)
 SELECT reorganisation_participant_id,1 FROM establishment.reorganisation_participant
 WHERE establishment_reorganisation_id=md5('single-establishment-change')::uuid;
 SET CONSTRAINTS ALL IMMEDIATE;
 END $single$;$$,'23514');
SELECT pg_temp.expect_reorganisation_failure(
 $$INSERT INTO establishment.reorganisation_effect(reorganisation_participant_id,reorganisation_effect_type_id)
 SELECT reorganisation_participant_id,1 FROM establishment.reorganisation_participant WHERE reorganisation_outcome_id=1 LIMIT 1$$,'23514');
SELECT pg_temp.expect_reorganisation_failure(
 $$UPDATE establishment.establishment_succession SET effective_date='2026-01-01'$$,'23514');
SELECT pg_temp.expect_reorganisation_failure(
 $$INSERT INTO establishment.establishment_succession(predecessor_establishment_id,successor_establishment_id)
 SELECT establishment_id,establishment_id FROM establishment.establishment LIMIT 1$$,'23514');
SELECT pg_temp.expect_reorganisation_failure(
 $$INSERT INTO establishment.establishment_succession(predecessor_establishment_id,successor_establishment_id)
 SELECT predecessor_establishment_id,successor_establishment_id FROM establishment.establishment_succession LIMIT 1$$,'23505');
SELECT pg_temp.expect_reorganisation_failure(
 $$INSERT INTO establishment.establishment_provision_transfer(origin_establishment_id,recipient_establishment_id,establishment_reorganisation_id)
 VALUES(md5('reorganisation-test-5-3')::uuid,md5('reorganisation-test-6-4')::uuid,md5('reorganisation-test-event-5')::uuid)$$,'23503');
SELECT pg_temp.expect_reorganisation_failure(
 $$UPDATE establishment.reorganisation_participant SET reorganisation_outcome_id=2
 WHERE establishment_reorganisation_id=md5('reorganisation-test-event-6')::uuid$$,'23514');
SELECT pg_temp.expect_reorganisation_failure(
 $$UPDATE establishment.establishment_lifecycle SET establishment_status_id=(SELECT establishment_status_id FROM establishment.establishment_status WHERE code=1)
 WHERE establishment_id=md5('reorganisation-test-1-1')::uuid$$,'23514');
SELECT pg_temp.expect_reorganisation_failure(
 $$INSERT INTO establishment.establishment_succession(predecessor_establishment_id,successor_establishment_id)
 VALUES(md5('reorganisation-test-1-1')::uuid,md5('reorganisation-test-2-1')::uuid),
 (md5('reorganisation-test-2-1')::uuid,md5('reorganisation-test-1-1')::uuid)$$,'23514');

-- Standalone pairs may have a date; provision-transfer graphs need not be acyclic.
INSERT INTO establishment.establishment_succession(predecessor_establishment_id,successor_establishment_id,effective_date)
VALUES(md5('reorganisation-test-1-1')::uuid,md5('reorganisation-test-2-1')::uuid,'2026-01-01');
INSERT INTO establishment.establishment_provision_transfer(origin_establishment_id,recipient_establishment_id,establishment_reorganisation_id)
VALUES(md5('reorganisation-test-6-4')::uuid,md5('reorganisation-test-6-3')::uuid,md5('reorganisation-test-event-6')::uuid);
SET CONSTRAINTS ALL IMMEDIATE;
SELECT 'PASS: seven patterns, optional effects, standalone date, reciprocal transfers and twelve rejected mutations' AS reorganisation_test_result;
ROLLBACK;
