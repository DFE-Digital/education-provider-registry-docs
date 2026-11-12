-- Reference-data checks; requires the current schema and reference seed only.
BEGIN;
DO $$
DECLARE expected record;
BEGIN
    IF (SELECT count(*) FROM establishment.establishment_type) <> 41
       OR (SELECT count(*) FROM establishment.establishment_type_category) <> 11
       OR (SELECT count(*) FROM establishment.academy_route) <> 2 THEN
        RAISE EXCEPTION 'Expected 41 detailed types, eleven BAU categories and two routes';
    END IF;
    IF (SELECT count(*) FROM information_schema.columns WHERE table_schema='establishment'
        AND table_name='establishment_type_category') <> 3
       OR NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='establishment'
        AND table_name='establishment_type_category' AND column_name='establishment_type_category_id' AND data_type='uuid')
       OR NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='establishment'
        AND table_name='establishment_type' AND column_name='establishment_type_id' AND data_type='uuid')
       OR NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='establishment'
        AND table_name='establishment' AND column_name='establishment_type_id' AND data_type='uuid') THEN
        RAISE EXCEPTION 'Type keys must be UUIDs; categories contain UUID, published code and name';
    END IF;
    IF (SELECT count(*) FROM information_schema.columns WHERE table_schema='establishment'
        AND table_name='academy_route') <> 2 THEN
        RAISE EXCEPTION 'Academy route contains only its ID and name';
    END IF;
    FOR expected IN SELECT * FROM (VALUES
        ('Colleges'),('Academies'),('Free Schools'),('Children''s Centres'),('Online provider'),
        ('Universities'),('Independent schools'),('Local authority maintained schools'),
        ('Special schools'),('Welsh schools'),('Other types')
    ) v(name) LOOP
        IF NOT EXISTS (SELECT 1 FROM establishment.establishment_type_category WHERE name=expected.name) THEN
            RAISE EXCEPTION 'Missing BAU category %',expected.name;
        END IF;
    END LOOP;
    FOR expected IN SELECT * FROM (VALUES
        ('34','Academy converter','Converter'),
        ('28','Academy sponsor led','Sponsor led'),
        ('44','Academy special converter','Converter'),
        ('33','Academy special sponsor led','Sponsor led'),
        ('42','Academy alternative provision converter','Converter'),
        ('43','Academy alternative provision sponsor led','Sponsor led'),
        ('45','Academy 16-19 converter','Converter'),
        ('46','Academy 16 to 19 sponsor led','Sponsor led'),
        ('57','Academy secure 16 to 19',NULL)
    ) v(code,name,route) LOOP
        IF NOT EXISTS (SELECT 1 FROM establishment.establishment_type t
            JOIN establishment.establishment_type_category c USING(establishment_type_category_id)
            LEFT JOIN establishment.academy_route r USING(academy_route_id)
            WHERE t.code=expected.code AND t.name=expected.name AND c.name='Academies'
              AND r.name IS NOT DISTINCT FROM expected.route) THEN
            RAISE EXCEPTION 'Incorrect academy category or route for code %',expected.code;
        END IF;
    END LOOP;
    IF NOT EXISTS (SELECT 1 FROM establishment.establishment_type WHERE code='01')
       OR EXISTS (SELECT 1 FROM establishment.establishment_type
            WHERE code NOT IN ('28','33','34','42','43','44','45','46','57') AND academy_route_id IS NOT NULL) THEN
        RAISE EXCEPTION 'Leading-zero type code lost or route recorded on a non-academy';
    END IF;
    BEGIN
        UPDATE establishment.establishment_type SET academy_route_id=2 WHERE code='34';
        RAISE EXCEPTION 'Converter accepted sponsor-led route';
    EXCEPTION WHEN check_violation THEN NULL; END;
    BEGIN
        UPDATE establishment.establishment_type SET academy_route_id=NULL WHERE code='34';
        RAISE EXCEPTION 'Converter accepted missing route';
    EXCEPTION WHEN check_violation THEN NULL; END;
    BEGIN
        UPDATE establishment.establishment_type SET establishment_type_category_id=
            (SELECT establishment_type_category_id FROM establishment.establishment_type_category WHERE name='Special schools') WHERE code='34';
        RAISE EXCEPTION 'Academy accepted a non-academy category';
    EXCEPTION WHEN check_violation THEN NULL; END;
    BEGIN
        UPDATE establishment.establishment_type SET academy_route_id=1 WHERE code='57';
        RAISE EXCEPTION 'Secure academy accepted route';
    EXCEPTION WHEN check_violation THEN NULL; END;
    BEGIN
        UPDATE establishment.establishment_type SET academy_route_id=1 WHERE code='01';
        RAISE EXCEPTION 'Non-academy accepted route';
    EXCEPTION WHEN check_violation THEN NULL; END;
    BEGIN
        UPDATE establishment.establishment_type SET code='01' WHERE code='02';
        RAISE EXCEPTION 'Duplicate type code accepted';
    EXCEPTION WHEN unique_violation THEN NULL; END;
    BEGIN
        UPDATE establishment.establishment_type SET establishment_type_category_id=NULL WHERE code='01';
        RAISE EXCEPTION 'Missing category accepted';
    EXCEPTION WHEN not_null_violation THEN NULL; END;
    BEGIN
        UPDATE establishment.establishment_type SET establishment_type_category_id=-1 WHERE code='01';
        RAISE EXCEPTION 'Nonexistent category accepted';
    EXCEPTION WHEN foreign_key_violation THEN NULL; END;
END $$;
ROLLBACK;
SELECT 'PASS: UUID type keys, eleven BAU categories and academy routes' AS result;
