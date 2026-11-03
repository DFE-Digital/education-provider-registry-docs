-- Stage 4 target validation: read-only, suitable for a target SQL editor.
BEGIN ISOLATION LEVEL REPEATABLE READ READ ONLY;
DO $$
BEGIN
    IF EXISTS(SELECT 1 FROM establishment.legal_entity_sole_trader s JOIN establishment.legal_entity e USING(legal_entity_id)
              WHERE e.legal_entity_type_id IS DISTINCT FROM 11)
       OR EXISTS(SELECT 1 FROM establishment.legal_entity_partner p JOIN establishment.legal_entity e
                  ON e.legal_entity_id=p.partnership_legal_entity_id LEFT JOIN establishment.legal_entity b
                  ON b.legal_entity_id=p.partner_legal_entity_id
                  WHERE e.legal_entity_type_id IS DISTINCT FROM 12
                     OR (p.partner_legal_entity_id IS NOT NULL AND (b.legal_entity_type_id IS NULL OR b.legal_entity_type_id NOT IN (1,2,3,4,5,6,7))))
       OR EXISTS(SELECT 1 FROM establishment.establishment_responsibility WHERE responsibility_type_id=4 AND person_id IS NOT NULL) THEN
        RAISE EXCEPTION 'Stage 4: invalid sole-trader, partner or proprietor endpoint';
    END IF;
    IF EXISTS(SELECT 1 FROM migration.proprietor_review r LEFT JOIN establishment.legal_entity e
              ON e.legal_entity_id=(r.payload->>'legalEntityId')::uuid
              WHERE r.review_status='accepted' AND r.payload->>'proprietorKind'='Individual'
                AND e.legal_entity_type_id IS DISTINCT FROM 11) THEN
        RAISE EXCEPTION 'Stage 4: accepted individual proprietor is not a sole trader';
    END IF;
END $$;
SELECT 'PASS: Stage 4 legal-entity target shape' AS result;
SELECT decision_id,review_status,review_note FROM migration.proprietor_review ORDER BY decision_id;
SELECT e.name,'Fewer than two evidenced current partners: people remain deferred' AS warning
FROM establishment.legal_entity e WHERE e.legal_entity_type_id=12 AND
    (SELECT count(DISTINCT CASE WHEN p.partner_person_id IS NOT NULL THEN 'person/'||p.partner_person_id::text
                               ELSE 'body/'||p.partner_legal_entity_id::text END)
     FROM establishment.legal_entity_partner p WHERE p.partnership_legal_entity_id=e.legal_entity_id AND p.is_current)<2;
SELECT (SELECT count(*) FROM establishment.legal_entity_sole_trader) AS known_trader_links,
       (SELECT count(*) FROM establishment.legal_entity_partner) AS evidenced_partner_links;
COMMIT;
