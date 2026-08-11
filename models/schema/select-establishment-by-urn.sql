-- Select the complete current Establishment model slice for one school.
-- Target: PostgreSQL database establishment_local, schema establishment.
--
-- Change the URN in the params CTE to inspect another establishment.

WITH params AS (
    SELECT 106431::numeric AS urn
)
SELECT
    e.establishment_id,
    e.urn,
    e.ukprn,
    e.local_authority_code,
    e.establishment_number,
    e.local_authority_code || '/' || lpad(e.establishment_number::text, 4, '0') AS dfe_number,
    e.name,
    e.establishment_type_id,
    et.name AS establishment_type,
    e.education_phase_id,
    ep.name AS education_phase,
    eap.education_admissions_and_provision_id,
    eap.gender_of_entry_type_id,
    goet.name AS gender_of_entry,
    sar.statutory_age_range_id,
    sar.lower_statutory_age,
    sar.upper_statutory_age
FROM params AS p
JOIN establishment.establishment AS e
  ON e.urn = p.urn
JOIN establishment.establishment_type AS et
  ON et.establishment_type_id = e.establishment_type_id
LEFT JOIN establishment.education_phase AS ep
  ON ep.education_phase_id = e.education_phase_id
LEFT JOIN establishment.education_admissions_and_provision AS eap
  ON eap.establishment_id = e.establishment_id
LEFT JOIN establishment.gender_of_entry_type AS goet
  ON goet.gender_of_entry_type_id = eap.gender_of_entry_type_id
LEFT JOIN establishment.statutory_age_range AS sar
  ON sar.education_admissions_and_provision_id = eap.education_admissions_and_provision_id;
