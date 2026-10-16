-- Read-only E15 report: at least one migrated value for each named field.
SELECT
    count(*) AS establishments,
    count(further_education_type_id) AS further_education_type_populated,
    count(section_41_approval_status_id) AS section_41_approval_status_populated,
    count(further_education_type_id) > 0
        AND count(section_41_approval_status_id) > 0 AS e15_has_data_for_both_fields
FROM establishment.establishment;

SELECT
    e.urn,
    e.name,
    fet.code AS source_further_education_type_code,
    fet.name AS further_education_type,
    s41.code AS source_section_41_approval_status_code,
    s41.name AS section_41_approval_status
FROM establishment.establishment e
LEFT JOIN establishment.further_education_type fet USING (further_education_type_id)
LEFT JOIN establishment.section_41_approval_status s41 USING (section_41_approval_status_id)
WHERE e.further_education_type_id IS NOT NULL OR e.section_41_approval_status_id IS NOT NULL
ORDER BY e.urn;
