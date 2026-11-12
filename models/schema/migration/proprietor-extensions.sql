-- Reviewed Stage 4 decisions. Personal attributes and partner people are deferred.
CREATE TABLE migration.proprietor_review (
    proprietor_review_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    decision_id text NOT NULL UNIQUE,
    payload jsonb NOT NULL,
    review_status text NOT NULL CHECK(review_status IN ('pending','accepted')),
    review_note text NOT NULL
);
CREATE TABLE migration.proprietor_fact_evidence (
    proprietor_fact_evidence_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    decision_id text NOT NULL REFERENCES migration.proprietor_review(decision_id),
    fact_key text NOT NULL,
    source_record_id uuid NOT NULL REFERENCES migration.source_record(source_record_id),
    target_kind text NOT NULL,
    target_id uuid,
    payload jsonb NOT NULL,
    review_status text NOT NULL CHECK(review_status IN ('pending','accepted')),
    UNIQUE(decision_id,fact_key)
);

CREATE FUNCTION migration.proprietor_source(run_id uuid,extract_key text,s jsonb)
RETURNS uuid LANGUAGE plpgsql AS $$
DECLARE snapshot_id uuid; record_id uuid;
BEGIN
    IF nullif(s->>'system','') IS NULL OR nullif(s->>'table','') IS NULL
       OR nullif(s->>'key','') IS NULL OR NOT s ? 'observedValues' THEN
        RAISE EXCEPTION 'Reviewed proprietor fact requires its source system, table, key and observed values';
    END IF;
    SELECT source_snapshot_id INTO snapshot_id FROM migration.source_snapshot WHERE extract_name=extract_key;
    IF snapshot_id IS NULL THEN
        INSERT INTO migration.source_snapshot(migration_run_id,source_system,source_database,snapshot_date,extract_name)
        VALUES(run_id,s->>'system',s->>'database',(s->>'observedDate')::date,extract_key)
        RETURNING source_snapshot_id INTO snapshot_id;
    END IF;
    INSERT INTO migration.source_record(source_snapshot_id,source_table,source_key,source_row_hash)
    VALUES(snapshot_id,s->>'table',s->>'key',md5(s::text)) ON CONFLICT DO NOTHING;
    SELECT source_record_id INTO STRICT record_id FROM migration.source_record WHERE source_snapshot_id=snapshot_id
      AND source_table=s->>'table' AND source_key=s->>'key' AND source_row_hash=md5(s::text);
    RETURN record_id;
END $$;

CREATE FUNCTION migration.apply_reviewed_proprietor(d jsonb,run_id uuid)
RETURNS uuid LANGUAGE plpgsql AS $$
DECLARE key text:=d->>'decisionId'; party uuid; form integer; source_id uuid;
    fact jsonb; fact_id uuid; school_id uuid; purpose integer; accepted_address uuid; link_id uuid;
BEGIN
    IF nullif(key,'') IS NULL THEN RAISE EXCEPTION 'Proprietor decision needs a stable decisionId'; END IF;
    PERFORM pg_advisory_xact_lock(hashtextextended('proprietor/'||key,0));
    IF EXISTS(SELECT 1 FROM migration.proprietor_review WHERE decision_id=key
              AND review_status='accepted' AND payload IS DISTINCT FROM d) THEN
        RAISE EXCEPTION 'Accepted proprietor decision changed; explicit correction required';
    END IF;
    INSERT INTO migration.proprietor_review(decision_id,payload,review_status,review_note) VALUES(key,d,
        CASE WHEN d->>'reviewStatus'='accepted' THEN 'accepted' ELSE 'pending' END,
        coalesce(nullif(d->>'reviewEvidence',''),'Identity, classification or registration evidence requires review'))
    ON CONFLICT(decision_id) DO NOTHING;
    IF d->>'reviewStatus' IS DISTINCT FROM 'accepted' THEN RETURN NULL; END IF;
    party:=(d->>'legalEntityId')::uuid; form:=(d->>'legalEntityTypeId')::integer;
    IF party IS NULL OR form IS NULL OR NOT EXISTS(SELECT 1 FROM establishment.legal_entity_type WHERE legal_entity_type_id=form)
       OR nullif(btrim(d->>'name'),'') IS NULL OR nullif(btrim(d->>'reviewEvidence'),'') IS NULL
       OR coalesce(d->>'proprietorKind','') NOT IN ('Individual','Body','Partnership') THEN
        RAISE EXCEPTION 'Incomplete reviewed proprietor identity or classification';
    END IF;
    IF coalesce(jsonb_array_length(d->'schools'),0)=0 THEN RAISE EXCEPTION 'Reviewed proprietor requires its establishment assertions'; END IF;
    IF d->>'proprietorKind'='Individual' AND (form<>11 OR nullif(d->>'individualIdentityKey','') IS NULL
       OR coalesce(d->>'acceptedNameKind','') NOT IN ('trading_name','personal_name')) THEN
        RAISE EXCEPTION 'Individual proprietor requires one reviewed sole-trader identity and selected name evidence';
    END IF;
    IF (form=11 AND d->>'proprietorKind'<>'Individual')
       OR (form=12 AND d->>'proprietorKind'<>'Partnership')
       OR (d->>'proprietorKind'='Partnership' AND form<>12) THEN
        RAISE EXCEPTION 'Proprietor kind and legal form disagree';
    END IF;
    IF form=11 THEN
        PERFORM pg_advisory_xact_lock(hashtextextended('individual-proprietor/'||(d->>'individualIdentityKey'),0));
    END IF;
    IF form=11 AND EXISTS(SELECT 1 FROM migration.proprietor_review r WHERE r.decision_id<>key
       AND r.review_status='accepted' AND r.payload->>'individualIdentityKey'=d->>'individualIdentityKey'
       AND r.payload->>'legalEntityId'<>d->>'legalEntityId') THEN
        RAISE EXCEPTION 'One reviewed individual cannot acquire a second sole-trader identity';
    END IF;
    PERFORM pg_advisory_xact_lock(hashtextextended('proprietor-identity/'||party::text,0));
    IF EXISTS(SELECT 1 FROM establishment.legal_entity WHERE legal_entity_id=party
              AND (name IS DISTINCT FROM d->>'name' OR legal_entity_type_id IS DISTINCT FROM form))
       OR EXISTS(SELECT 1 FROM establishment.legal_entity WHERE legal_entity_id<>party
                 AND lower(btrim(name))=lower(btrim(d->>'name'))) THEN
        RAISE EXCEPTION 'Reviewed proprietor identity collision';
    END IF;
    source_id:=migration.proprietor_source(run_id,'proprietor/'||key||'/identity',d->'source');
    INSERT INTO establishment.legal_entity(legal_entity_id,name,legal_entity_type_id)
    VALUES(party,d->>'name',form) ON CONFLICT DO NOTHING;
    INSERT INTO migration.identity_resolution(source_record_id,target_entity_type,target_entity_id,resolution_method,
        confidence,decision_status,rationale)
    SELECT source_id,'legal_entity',party,'reviewed-proprietor-entity','reviewed','accepted',d->>'reviewEvidence'
    WHERE NOT EXISTS(SELECT 1 FROM migration.identity_resolution WHERE source_record_id=source_id AND target_entity_id=party);
    INSERT INTO migration.proprietor_fact_evidence(decision_id,fact_key,source_record_id,target_kind,target_id,payload,review_status)
    VALUES(key,'identity',source_id,'legal_entity',party,d,'accepted') ON CONFLICT DO NOTHING;
    FOR fact IN SELECT value FROM jsonb_array_elements(coalesce(d->'schools','[]')) LOOP
        SELECT e.establishment_id INTO STRICT school_id FROM establishment.establishment e WHERE urn=(fact->>'urn')::integer;
        fact_id:=(fact->>'responsibilityId')::uuid;
        IF fact_id IS NULL OR NOT fact ? 'isCurrent' THEN RAISE EXCEPTION 'Reviewed responsibility needs a stable ID and current assertion'; END IF;
        IF (fact->>'isCurrent')::boolean AND NOT EXISTS(SELECT 1 FROM establishment.establishment_lifecycle l
             JOIN establishment.establishment_status s USING(establishment_status_id)
             WHERE l.establishment_id=school_id AND s.code IN (1,3)) THEN
            RAISE EXCEPTION 'Closed school cannot acquire a current reviewed proprietor';
        END IF;
        IF (fact->>'isCurrent')::boolean AND NOT EXISTS(SELECT 1 FROM establishment.establishment
             WHERE establishment_id=school_id AND establishment_type_id IN (SELECT establishment_type_id FROM establishment.establishment_type WHERE code IN ('06','08','10','11'))) THEN
            RAISE EXCEPTION 'Current proprietor requires an eligible school type';
        END IF;
        IF EXISTS(SELECT 1 FROM establishment.establishment_responsibility r WHERE establishment_responsibility_id=fact_id
           AND ROW(r.establishment_id,r.legal_entity_id,r.responsibility_type_id,r.start_date,r.end_date,r.is_current)
             IS DISTINCT FROM ROW(school_id,party,4,(fact->>'startDate')::date,(fact->>'endDate')::date,(fact->>'isCurrent')::boolean)) THEN
            RAISE EXCEPTION 'Reviewed proprietor responsibility ID collision';
        END IF;
        INSERT INTO establishment.establishment_responsibility(establishment_responsibility_id,establishment_id,legal_entity_id,
            responsibility_type_id,start_date,end_date,is_current,first_observed_date)
        VALUES(fact_id,school_id,party,4,(fact->>'startDate')::date,(fact->>'endDate')::date,
               (fact->>'isCurrent')::boolean,(d->'source'->>'observedDate')::date) ON CONFLICT DO NOTHING;
        INSERT INTO migration.establishment_responsibility_evidence(establishment_responsibility_id,source_record_id,
            first_observed_date,inference_rule,notes)
        SELECT fact_id,source_id,(d->'source'->>'observedDate')::date,'reviewed-proprietor-v1',d::text
        WHERE NOT EXISTS(SELECT 1 FROM migration.establishment_responsibility_evidence
                         WHERE establishment_responsibility_id=fact_id AND source_record_id=source_id);
        INSERT INTO migration.proprietor_fact_evidence(decision_id,fact_key,source_record_id,target_kind,target_id,payload,review_status)
        VALUES(key,'responsibility/'||fact_id,source_id,
            'establishment_responsibility',fact_id,fact,'accepted') ON CONFLICT DO NOTHING;
    END LOOP;
    FOR fact IN SELECT value FROM jsonb_array_elements(coalesce(d->'identifiers','[]')) LOOP
        IF fact->>'verified' IS DISTINCT FROM 'true' OR nullif(fact->>'verificationEvidence','') IS NULL THEN
            source_id:=migration.proprietor_source(run_id,'proprietor/'||key||'/identifier/'||(fact->>'value'),fact->'source');
            INSERT INTO migration.proprietor_fact_evidence(decision_id,fact_key,source_record_id,target_kind,target_id,payload,review_status)
            VALUES(key,'identifier/'||(fact->>'value'),source_id,
                'organisation_identifier',NULL,fact,'pending') ON CONFLICT DO NOTHING;
            CONTINUE;
        END IF;
        IF coalesce(fact->>'type','') NOT IN ('Companies House number','UKPRN')
           OR nullif(fact->>'value','') IS NULL
           OR (form=5 AND fact->>'type'='Companies House number' AND fact->>'value' !~ '^(OC|SO|NC)[0-9]{6}$') THEN
            RAISE EXCEPTION 'Organisation identifiers require verified registration evidence and preserved prefixes';
        END IF;
        IF EXISTS(SELECT 1 FROM establishment.organisation_identifier i JOIN establishment.organisation_identifier_type t USING(organisation_identifier_type_id)
                   WHERE t.name=fact->>'type' AND i.value=fact->>'value' AND i.legal_entity_id<>party) THEN
            RAISE EXCEPTION 'Verified organisation identifier belongs to another identity';
        END IF;
        INSERT INTO establishment.organisation_identifier(legal_entity_id,organisation_identifier_type_id,value,is_current)
        SELECT party,organisation_identifier_type_id,fact->>'value',true FROM establishment.organisation_identifier_type WHERE name=fact->>'type'
        ON CONFLICT DO NOTHING;
        SELECT i.organisation_identifier_id INTO STRICT fact_id FROM establishment.organisation_identifier i
        JOIN establishment.organisation_identifier_type t USING(organisation_identifier_type_id)
        WHERE i.legal_entity_id=party AND t.name=fact->>'type' AND i.value=fact->>'value' AND i.is_current;
        source_id:=migration.proprietor_source(run_id,'proprietor/'||key||'/identifier/'||(fact->>'value'),fact->'source');
        INSERT INTO migration.proprietor_fact_evidence(decision_id,fact_key,source_record_id,target_kind,target_id,payload,review_status)
        VALUES(key,'identifier/'||(fact->>'value'),source_id,
            'organisation_identifier',fact_id,fact,'accepted') ON CONFLICT DO NOTHING;
    END LOOP;
    FOR fact IN SELECT value FROM jsonb_array_elements(coalesce(d->'addresses','[]')) LOOP
        source_id:=migration.proprietor_source(run_id,'proprietor/'||key||'/address/'||(fact->>'factKey'),fact->'source');
        SELECT address_purpose_id INTO purpose FROM establishment.address_purpose WHERE name=fact->>'purpose';
        IF purpose IS NULL OR nullif(fact->>'reviewEvidence','') IS NULL THEN
            INSERT INTO migration.proprietor_fact_evidence(decision_id,fact_key,source_record_id,target_kind,target_id,payload,review_status)
            VALUES(key,'address/'||(fact->>'factKey'),source_id,
                'address',NULL,fact,'pending') ON CONFLICT DO NOTHING;
            CONTINUE;
        END IF;
        accepted_address:=(fact->>'addressId')::uuid; link_id:=(fact->>'linkId')::uuid;
        IF accepted_address IS NULL OR link_id IS NULL THEN RAISE EXCEPTION 'Reviewed address needs stable address and link IDs'; END IF;
        IF EXISTS(SELECT 1 FROM establishment.address a WHERE a.address_id=accepted_address
           AND ROW(a.address_line_1,a.address_line_2,a.address_line_3,a.town,a.county,a.postcode) IS DISTINCT FROM
               ROW(fact->>'line1',fact->>'line2',fact->>'line3',fact->>'town',fact->>'county',fact->>'postcode')) THEN
            RAISE EXCEPTION 'Reviewed address ID collision';
        END IF;
        INSERT INTO establishment.address(address_id,address_line_1,address_line_2,address_line_3,town,county,postcode)
        VALUES(accepted_address,fact->>'line1',fact->>'line2',fact->>'line3',fact->>'town',fact->>'county',fact->>'postcode') ON CONFLICT DO NOTHING;
        IF EXISTS(SELECT 1 FROM establishment.legal_entity_address a WHERE legal_entity_address_id=link_id
                   AND ROW(a.legal_entity_id,a.address_id,a.address_purpose_id) IS DISTINCT FROM ROW(party,accepted_address,purpose)) THEN
            RAISE EXCEPTION 'Reviewed address-owner ID collision';
        END IF;
        INSERT INTO establishment.legal_entity_address(legal_entity_address_id,legal_entity_id,address_id,address_purpose_id)
        VALUES(link_id,party,accepted_address,purpose) ON CONFLICT DO NOTHING;
        IF NOT EXISTS(SELECT 1 FROM establishment.legal_entity_address WHERE legal_entity_address_id=link_id
                       AND legal_entity_id=party AND address_id=accepted_address
                       AND address_purpose_id=purpose AND is_current) THEN
            RAISE EXCEPTION 'Reviewed address conflicts with an existing current use';
        END IF;
        INSERT INTO migration.proprietor_fact_evidence(decision_id,fact_key,source_record_id,target_kind,target_id,payload,review_status)
        VALUES(key,'address/'||(fact->>'factKey'),source_id,
            'legal_entity_address',link_id,fact,'accepted') ON CONFLICT DO NOTHING;
    END LOOP;
    IF d ? 'contactObservations' THEN
        INSERT INTO migration.proprietor_fact_evidence(decision_id,fact_key,source_record_id,target_kind,target_id,payload,review_status)
        VALUES(key,'contacts',
            migration.proprietor_source(run_id,'proprietor/'||key||'/contacts',d->'source'),
            'deferred_legal_entity_contacts',NULL,d->'contactObservations','pending') ON CONFLICT DO NOTHING;
    END IF;
    RETURN party;
END $$;
