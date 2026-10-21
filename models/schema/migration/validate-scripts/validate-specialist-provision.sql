-- Read-only E09 field coverage. Count false and zero as populated values.
SELECT count(*) AS establishments,
       count(sp.specialist_provision_type_id) AS provision_type_populated,
       count(r.capacity) AS resourced_capacity_populated,
       count(r.pupil_count) AS resourced_pupil_count_populated,
       count(u.capacity) AS sen_unit_capacity_populated,
       count(u.pupil_count) AS sen_unit_pupil_count_populated,
       count(p.has_special_classes) AS special_classes_populated,
       count(sp.specialist_provision_type_id)>0
         AND count(r.capacity)>0 AND count(r.pupil_count)>0
         AND count(u.capacity)>0 AND count(u.pupil_count)>0
         AND count(p.has_special_classes)>0 AS e09_has_data_for_every_field
FROM establishment.establishment e
LEFT JOIN establishment.education_admissions_and_provision p USING(establishment_id)
LEFT JOIN establishment.specialist_provision sp USING(establishment_id)
LEFT JOIN establishment.resourced_provision r USING(specialist_provision_id)
LEFT JOIN establishment.sen_unit_provision u USING(specialist_provision_id);

SELECT e.urn,e.name,t.name AS specialist_provision_type,
       r.capacity AS resourced_capacity,r.pupil_count AS resourced_pupil_count,
       u.capacity AS sen_unit_capacity,u.pupil_count AS sen_unit_pupil_count,
       p.has_special_classes
FROM establishment.establishment e
LEFT JOIN establishment.education_admissions_and_provision p USING(establishment_id)
LEFT JOIN establishment.specialist_provision sp USING(establishment_id)
LEFT JOIN establishment.specialist_provision_type t USING(specialist_provision_type_id)
LEFT JOIN establishment.resourced_provision r USING(specialist_provision_id)
LEFT JOIN establishment.sen_unit_provision u USING(specialist_provision_id)
WHERE sp.specialist_provision_type_id IS NOT NULL OR p.has_special_classes IS NOT NULL
ORDER BY e.urn;
