-- Read-only E16 validation. Unknown and Not applicable map to NULL;
-- None remains a meaningful religious-character or ethos value.
SELECT
    count(*) AS establishments,
    count(religious_character_id) AS religious_character_populated,
    count(religious_ethos_id) AS religious_ethos_populated,
    count(diocese_id) AS diocese_populated,
    count(religious_character_id) > 0 AND count(religious_ethos_id) > 0
        AND count(diocese_id) > 0 AS e16_has_data_for_every_field
FROM establishment.establishment;

SELECT e.urn, e.name,
       rc.code AS religious_character_code, rc.name AS religious_character,
       re.code AS religious_ethos_code, re.name AS religious_ethos,
       d.code AS diocese_code, d.name AS diocese
FROM establishment.establishment e
LEFT JOIN establishment.religious_character rc USING(religious_character_id)
LEFT JOIN establishment.religious_ethos re USING(religious_ethos_id)
LEFT JOIN establishment.diocese d USING(diocese_id)
ORDER BY e.urn;
