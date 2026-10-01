-- T1: The Co-Operative Academy of Stoke-On-Trent (URN 136102) is linked to two GIAS group
-- records for the same real-world trust. Group 2777 is the academy-trust
-- role and group 4949 is the school-sponsor role.
DO $$
DECLARE
    actual_count integer;
BEGIN
    SELECT count(DISTINCT er.establishment_responsibility_id) INTO actual_count
    FROM establishment.establishment_responsibility AS er
    JOIN establishment.establishment AS e ON e.establishment_id = er.establishment_id
    WHERE e.urn = 136102;

    IF actual_count <> 3 THEN
        RAISE EXCEPTION 'T1 validation expected three responsibilities for URN 136102 but found %', actual_count;
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM establishment.establishment_responsibility AS er
        JOIN establishment.establishment AS e ON e.establishment_id = er.establishment_id
        JOIN establishment.legal_entity AS le ON le.legal_entity_id = er.legal_entity_id
        JOIN establishment.establishment_party_role AS role ON role.legal_entity_id = le.legal_entity_id
        JOIN establishment.establishment_party_role_type AS role_type ON role_type.establishment_party_role_type_id = role.establishment_party_role_type_id
        JOIN establishment.academy_trust_classification AS classification ON classification.establishment_party_role_id = role.establishment_party_role_id
        JOIN establishment.academy_trust_type AS academy_type ON academy_type.academy_trust_type_id = classification.academy_trust_type_id
        JOIN establishment.responsibility_type AS rt ON rt.responsibility_type_id = er.responsibility_type_id
        JOIN establishment.group_identifier AS gi ON gi.establishment_party_role_id = role.establishment_party_role_id
        JOIN establishment.group_identifier_type AS git ON git.group_identifier_type_id = gi.group_identifier_type_id
        WHERE e.urn = 136102
          AND role_type.name = 'Academy trust'
          AND academy_type.name = 'Multi-academy trust'
          AND rt.name = 'Run by academy trust'
          AND git.name = 'Group UID'
          AND gi.value = '2777'
          AND gi.is_current
    ) THEN
        RAISE EXCEPTION 'T1 validation expected the MAT role, classification, responsibility and Group UID 2777';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM establishment.establishment_responsibility AS er
        JOIN establishment.establishment AS e ON e.establishment_id = er.establishment_id
        JOIN establishment.legal_entity AS le ON le.legal_entity_id = er.legal_entity_id
        JOIN establishment.establishment_party_role AS role ON role.legal_entity_id = le.legal_entity_id
        JOIN establishment.establishment_party_role_type AS role_type ON role_type.establishment_party_role_type_id = role.establishment_party_role_type_id
        JOIN establishment.responsibility_type AS rt ON rt.responsibility_type_id = er.responsibility_type_id
        JOIN establishment.group_identifier AS gi ON gi.establishment_party_role_id = role.establishment_party_role_id
        JOIN establishment.group_identifier_type AS git ON git.group_identifier_type_id = gi.group_identifier_type_id
        WHERE e.urn = 136102
          AND role_type.name = 'School sponsor'
          AND rt.name = 'Sponsored by'
          AND git.name = 'Group UID'
          AND gi.value = '4949'
          AND gi.is_current
    ) THEN
        RAISE EXCEPTION 'T1 validation expected the school-sponsor role, responsibility and Group UID 4949';
    END IF;
END
$$;

-- T2: URN 134314 has a different party for academy-trust and school-sponsor
-- responsibilities. The sponsor has no Companies House identifier in source.
DO $$
DECLARE
    actual_count integer;
BEGIN
    SELECT count(DISTINCT er.establishment_responsibility_id) INTO actual_count
    FROM establishment.establishment_responsibility AS er
    JOIN establishment.establishment AS e ON e.establishment_id = er.establishment_id
    WHERE e.urn = 134314;

    IF actual_count <> 3 THEN
        RAISE EXCEPTION 'T2 validation expected three responsibilities for URN 134314 but found %', actual_count;
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM establishment.establishment_responsibility AS er
        JOIN establishment.establishment AS e ON e.establishment_id = er.establishment_id
        JOIN establishment.legal_entity AS le ON le.legal_entity_id = er.legal_entity_id
        JOIN establishment.establishment_party_role AS role ON role.legal_entity_id = le.legal_entity_id
        JOIN establishment.establishment_party_role_type AS role_type ON role_type.establishment_party_role_type_id = role.establishment_party_role_type_id
        JOIN establishment.responsibility_type AS rt ON rt.responsibility_type_id = er.responsibility_type_id
        JOIN establishment.group_identifier AS gi ON gi.establishment_party_role_id = role.establishment_party_role_id
        WHERE e.urn = 134314
          AND le.name = 'HIVE EDUCATION TRUST'
          AND role_type.name = 'Academy trust'
          AND rt.name = 'Run by academy trust'
          AND gi.value = '23869'
          AND er.start_date = DATE '2021-10-04'
    ) THEN
        RAISE EXCEPTION 'T2 validation expected Hive Education Trust as the academy trust for URN 134314';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM establishment.establishment_responsibility AS er
        JOIN establishment.establishment AS e ON e.establishment_id = er.establishment_id
        JOIN establishment.legal_entity AS le ON le.legal_entity_id = er.legal_entity_id
        JOIN establishment.establishment_party_role AS role ON role.legal_entity_id = le.legal_entity_id
        JOIN establishment.establishment_party_role_type AS role_type ON role_type.establishment_party_role_type_id = role.establishment_party_role_type_id
        JOIN establishment.responsibility_type AS rt ON rt.responsibility_type_id = er.responsibility_type_id
        JOIN establishment.group_identifier AS gi ON gi.establishment_party_role_id = role.establishment_party_role_id
        WHERE e.urn = 134314
          AND le.name = 'Diocese of London'
          AND role_type.name = 'School sponsor'
          AND rt.name = 'Sponsored by'
          AND gi.value = '2914'
          AND er.start_date = DATE '2007-09-01'
    ) THEN
        RAISE EXCEPTION 'T2 validation expected Diocese of London as the external sponsor for URN 134314';
    END IF;
END
$$;

SELECT e.urn,
       le.name AS legal_entity_name,
       oi.value AS companies_house_number,
       role_type.name AS establishment_party_role_type,
       academy_type.name AS academy_trust_type,
       uid.value AS group_uid,
       group_id.value AS group_id,
       rt.name AS responsibility_type,
       er.start_date AS responsibility_start_date,
       er.end_date AS responsibility_end_date
FROM establishment.establishment_responsibility AS er
JOIN establishment.establishment AS e ON e.establishment_id = er.establishment_id
JOIN establishment.legal_entity AS le ON le.legal_entity_id = er.legal_entity_id
LEFT JOIN establishment.organisation_identifier AS oi ON oi.legal_entity_id = le.legal_entity_id
LEFT JOIN establishment.organisation_identifier_type AS oit ON oit.organisation_identifier_type_id = oi.organisation_identifier_type_id
JOIN establishment.establishment_party_role AS role ON role.legal_entity_id = le.legal_entity_id
JOIN establishment.establishment_party_role_type AS role_type ON role_type.establishment_party_role_type_id = role.establishment_party_role_type_id
JOIN establishment.responsibility_type AS rt ON rt.responsibility_type_id = er.responsibility_type_id
LEFT JOIN establishment.academy_trust_classification AS classification ON classification.establishment_party_role_id = role.establishment_party_role_id
LEFT JOIN establishment.academy_trust_type AS academy_type ON academy_type.academy_trust_type_id = classification.academy_trust_type_id
LEFT JOIN establishment.group_identifier AS uid ON uid.establishment_party_role_id = role.establishment_party_role_id
    AND uid.group_identifier_type_id = (SELECT group_identifier_type_id FROM establishment.group_identifier_type WHERE name = 'Group UID')
    AND uid.is_current
LEFT JOIN establishment.group_identifier AS group_id ON group_id.establishment_party_role_id = role.establishment_party_role_id
    AND group_id.group_identifier_type_id = (SELECT group_identifier_type_id FROM establishment.group_identifier_type WHERE name = 'Group ID')
    AND group_id.is_current
WHERE e.urn IN (136102, 134314)
  AND (oit.name = 'Companies House number' OR oit.name IS NULL)
  AND (oi.is_current OR oi.is_current IS NULL)
ORDER BY role_type.name;

DO $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM establishment.academy_trust_classification AS classification
        JOIN establishment.establishment_party_role AS role ON role.establishment_party_role_id = classification.establishment_party_role_id
        JOIN establishment.establishment_party_role_type AS role_type ON role_type.establishment_party_role_type_id = role.establishment_party_role_type_id
        WHERE role_type.name <> 'Academy trust'
    ) THEN
        RAISE EXCEPTION 'Academy-trust classifications may exist only for academy-trust roles';
    END IF;
END
$$;
