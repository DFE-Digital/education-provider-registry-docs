-- E17: one optional text link. Expected fixture: 41 links, 1 controlled null.
SELECT
    count(*) AS establishments,
    count(NULLIF(BTRIM(ofsted_link), '')) AS ofsted_links_populated,
    count(NULLIF(BTRIM(ofsted_link), '')) > 0 AS e17_has_migrated_data,
    count(*) FILTER (
        WHERE ofsted_link IS NOT NULL
          AND ofsted_link <> 'https://reports.ofsted.gov.uk/search?q=' || urn::text
    ) AS links_differing_from_migration_rule
FROM establishment.establishment;

SELECT urn, name, ofsted_link
FROM establishment.establishment
ORDER BY urn;
