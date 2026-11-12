-- Current lookup inventory, key types and relationship constraints.
DO $$
DECLARE owner_id uuid; first_id uuid; test_sen_id integer;
BEGIN
    IF (SELECT count(*) FROM information_schema.columns
        WHERE table_schema='establishment' AND table_name='sen') <> 3
       OR NOT EXISTS (SELECT 1 FROM information_schema.columns
          WHERE table_schema='establishment' AND table_name='sen'
            AND column_name='sen_id' AND data_type='integer')
       OR NOT EXISTS (SELECT 1 FROM information_schema.columns
          WHERE table_schema='establishment' AND table_name='establishment_sen'
            AND column_name='establishment_sen_id' AND data_type='uuid') THEN
        RAISE EXCEPTION 'SEN lookup must have integer identity/code/name only; associations need UUID identity';
    END IF;
    IF (SELECT count(*) FROM establishment.sen) <> 12
       OR EXISTS (SELECT 1 FROM establishment.sen
          WHERE code <> lpad(sen_id::text, 2, '0') OR sen_id NOT BETWEEN 1 AND 12)
       OR EXISTS (SELECT 1 FROM establishment.sen WHERE code='00') THEN
        RAISE EXCEPTION 'Expected 12 substantive SEN values with stable integer IDs and leading-zero codes';
    END IF;
    SELECT sen_id INTO STRICT test_sen_id FROM establishment.sen WHERE code='04';
    BEGIN
        SELECT establishment_id INTO STRICT owner_id FROM establishment.establishment ORDER BY urn LIMIT 1;
        INSERT INTO establishment.establishment_sen (establishment_id, sen_id)
        VALUES (owner_id, test_sen_id) ON CONFLICT (establishment_id, sen_id) DO NOTHING;
        SELECT establishment_sen_id INTO STRICT first_id
        FROM establishment.establishment_sen WHERE establishment_id=owner_id AND sen_id=test_sen_id;
        INSERT INTO establishment.establishment_sen (establishment_id, sen_id)
        VALUES (owner_id, test_sen_id) ON CONFLICT (establishment_id, sen_id) DO NOTHING;
        IF first_id IS DISTINCT FROM (SELECT establishment_sen_id FROM establishment.establishment_sen
            WHERE establishment_id=owner_id AND sen_id=test_sen_id) THEN
            RAISE EXCEPTION 'SEN replay changed association identity';
        END IF;
        BEGIN
            INSERT INTO establishment.establishment_sen (establishment_id, sen_id) VALUES (owner_id, test_sen_id);
            RAISE EXCEPTION 'Duplicate establishment/SEN pair accepted';
        EXCEPTION WHEN unique_violation THEN NULL; END;
        BEGIN
            INSERT INTO establishment.establishment_sen (establishment_id, sen_id) VALUES (owner_id, 999);
            RAISE EXCEPTION 'Missing SEN reference accepted';
        EXCEPTION WHEN foreign_key_violation THEN NULL; END;
        BEGIN
            INSERT INTO establishment.establishment_sen (establishment_id, sen_id) VALUES (gen_random_uuid(), test_sen_id);
            RAISE EXCEPTION 'Missing establishment accepted';
        EXCEPTION WHEN foreign_key_violation THEN NULL; END;
        RAISE EXCEPTION USING ERRCODE='ZX001', MESSAGE='Roll back SEN constraint checks';
    EXCEPTION WHEN SQLSTATE 'ZX001' THEN NULL; END;
END $$;
