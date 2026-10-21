-- Read-only E14 coverage. Synthetic constraint-test rows are rolled back
-- and therefore do not contribute to these migrated-data counts.
WITH address_use AS (
    SELECT 'legal_entity' AS owner_kind, address_id, address_purpose_id,
           start_date, end_date, is_current
    FROM establishment.legal_entity_address
    UNION ALL
    SELECT 'organisation_group', address_id, address_purpose_id,
           start_date, end_date, is_current
    FROM establishment.organisation_group_address
)
SELECT count(*) AS address_associations,
       count(*) FILTER (WHERE u.owner_kind='legal_entity') AS legal_entity_addresses,
       count(*) FILTER (WHERE u.owner_kind='organisation_group') AS organisation_group_addresses,
       count(*) FILTER (WHERE p.code='registered') AS registered_office_addresses,
       count(*) FILTER (WHERE p.code='contact') AS contact_addresses,
       count(*) FILTER (WHERE p.code='administrative') AS administrative_addresses,
       count(NULLIF(BTRIM(a.address_line_1),'')) AS address_line_1_populated,
       count(NULLIF(BTRIM(a.address_line_2),'')) AS address_line_2_populated,
       count(NULLIF(BTRIM(a.address_line_3),'')) AS address_line_3_populated,
       count(NULLIF(BTRIM(a.town),'')) AS town_populated,
       count(NULLIF(BTRIM(a.county),'')) AS county_populated,
       count(NULLIF(BTRIM(a.postcode),'')) AS postcode_populated,
       count(u.start_date) AS start_date_populated,
       count(u.end_date) AS end_date_populated,
       count(u.is_current) AS current_flag_populated
FROM address_use u
JOIN establishment.address a USING(address_id)
JOIN establishment.address_purpose p USING(address_purpose_id);

WITH address_use AS (
    SELECT 'legal_entity' AS owner_kind, e.name AS owner_name,
           u.address_id, u.address_purpose_id, u.start_date, u.end_date, u.is_current
    FROM establishment.legal_entity_address u
    JOIN establishment.legal_entity e USING(legal_entity_id)
    UNION ALL
    SELECT 'organisation_group', g.name,
           u.address_id, u.address_purpose_id, u.start_date, u.end_date, u.is_current
    FROM establishment.organisation_group_address u
    JOIN establishment.organisation_group g USING(organisation_group_id)
)
SELECT u.owner_kind, u.owner_name, p.name AS purpose,
       a.address_line_1, a.address_line_2, a.address_line_3,
       a.town, a.county, a.postcode,
       u.start_date, u.end_date, u.is_current
FROM address_use u
JOIN establishment.address a USING(address_id)
JOIN establishment.address_purpose p USING(address_purpose_id)
ORDER BY u.owner_kind,u.owner_name,p.code,u.start_date NULLS FIRST;
