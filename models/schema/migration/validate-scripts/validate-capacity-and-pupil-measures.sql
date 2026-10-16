-- Read-only E08 validation for the migrated PostgreSQL target.
-- Each of the four business fields needs at least one populated data point.
SELECT
    count(*) AS measure_records,
    count(school_capacity) AS school_capacity_populated,
    count(pupil_count) AS pupil_count_populated,
    count(free_school_meal_measure) AS free_school_meal_count_populated,
    count(census_date) AS census_date_populated,
    count(school_capacity) > 0
        AND count(pupil_count) > 0
        AND count(free_school_meal_measure) > 0
        AND count(census_date) > 0 AS e08_has_data_for_every_field
FROM establishment.capacity_and_pupil_measures;

-- Census dates are source dates. Missing source dates remain NULL.
SELECT
    e.urn,
    e.name,
    m.school_capacity,
    m.pupil_count,
    m.free_school_meal_measure,
    m.census_date
FROM establishment.establishment AS e
JOIN establishment.capacity_and_pupil_measures AS m
  ON m.establishment_id = e.establishment_id
ORDER BY e.urn;
