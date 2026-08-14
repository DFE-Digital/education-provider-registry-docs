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
    capm.capacity_and_pupil_measures_id,
    capm.school_capacity,
    capm.pupil_count,
    capm.free_school_meal_measure,
    capm.census_date,
    eap.education_admissions_and_provision_id,
    eap.gender_of_entry_type_id,
    goet.name AS gender_of_entry,
    eap.admissions_policy_id,
    ap.name AS admissions_policy,
    eap.boarding_provision_id,
    bp.name AS boarding_provision,
    eap.nursery_provision_id,
    np.name AS nursery_provision,
    eap.sixth_form_provision_id,
    sfp.name AS sixth_form_provision,
    sar.statutory_age_range_id,
    sar.lower_statutory_age,
    sar.upper_statutory_age,
    sp.specialist_provision_id,
    sp.specialist_provision_type_id,
    spt.name AS specialist_provision_type,
    rp.resourced_provision_id,
    rp.capacity AS resourced_provision_capacity,
    rp.pupil_count AS resourced_provision_pupil_count,
    sup.sen_unit_provision_id,
    sup.capacity AS sen_unit_capacity,
    sup.pupil_count AS sen_unit_pupil_count
FROM params AS p
JOIN establishment.establishment AS e
  ON e.urn = p.urn
JOIN establishment.establishment_type AS et
  ON et.establishment_type_id = e.establishment_type_id
LEFT JOIN establishment.education_phase AS ep
  ON ep.education_phase_id = e.education_phase_id
LEFT JOIN establishment.capacity_and_pupil_measures AS capm
  ON capm.establishment_id = e.establishment_id
LEFT JOIN establishment.education_admissions_and_provision AS eap
  ON eap.establishment_id = e.establishment_id
LEFT JOIN establishment.gender_of_entry_type AS goet
  ON goet.gender_of_entry_type_id = eap.gender_of_entry_type_id
LEFT JOIN establishment.admissions_policy AS ap
  ON ap.admissions_policy_id = eap.admissions_policy_id
LEFT JOIN establishment.boarding_provision AS bp
  ON bp.boarding_provision_id = eap.boarding_provision_id
LEFT JOIN establishment.nursery_provision AS np
  ON np.nursery_provision_id = eap.nursery_provision_id
LEFT JOIN establishment.sixth_form_provision AS sfp
  ON sfp.sixth_form_provision_id = eap.sixth_form_provision_id
LEFT JOIN establishment.statutory_age_range AS sar
  ON sar.education_admissions_and_provision_id = eap.education_admissions_and_provision_id
LEFT JOIN establishment.specialist_provision AS sp
  ON sp.establishment_id = e.establishment_id
LEFT JOIN establishment.specialist_provision_type AS spt
  ON spt.specialist_provision_type_id = sp.specialist_provision_type_id
LEFT JOIN establishment.resourced_provision AS rp
  ON rp.specialist_provision_id = sp.specialist_provision_id
LEFT JOIN establishment.sen_unit_provision AS sup
  ON sup.specialist_provision_id = sp.specialist_provision_id;
