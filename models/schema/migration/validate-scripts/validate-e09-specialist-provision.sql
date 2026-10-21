-- Regression evidence: real source values for all five specialist fields
-- plus the independently recorded special-classes boolean.
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM establishment.establishment e
        JOIN establishment.education_admissions_and_provision p USING(establishment_id)
        JOIN establishment.specialist_provision sp USING(establishment_id)
        JOIN establishment.resourced_provision r USING(specialist_provision_id)
        JOIN establishment.sen_unit_provision u USING(specialist_provision_id)
        WHERE e.urn=100018
          AND sp.specialist_provision_type_id=3
          AND r.capacity=24 AND r.pupil_count=24
          AND u.capacity=24 AND u.pupil_count=24
          AND p.has_special_classes IS TRUE
    ) THEN
        RAISE EXCEPTION 'E09 source-derived Netley provision fields differ from the fixture';
    END IF;
END $$;

SELECT 'E09 specialist provision checks passed' AS result;
