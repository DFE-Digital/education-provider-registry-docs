/*
    Transform one BAU establishment source record into the current target
    Establishment model projection.

    Target engine: SQL Server

     It reads
    from dbo.Establishment and BAU lookup tables, then returns target-shaped
    values for the PostgreSQL model. It does not load the target database.

    Change @URN to transform another establishment.
*/

DECLARE @URN numeric(19, 0) = 106431;

WITH source_establishment AS (
    SELECT
        e.URN,
        e.UKPRN,
        e.LA_code,
        e.EstablishmentNumber,
        e.EstablishmentName,
        e.type_code,
        et.name AS type_name,
        e.educationPhase_code,
        ep.name AS education_phase_name,
        e.gender_code,
        g.name AS gender_name,
        e.StatutoryLowAge,
        e.StatutoryHighAge
    FROM dbo.Establishment AS e
    LEFT JOIN dbo.EstablishmentType AS et
      ON et.code = e.type_code
    LEFT JOIN dbo.EducationPhase AS ep
      ON ep.code = e.educationPhase_code
    LEFT JOIN dbo.Gender AS g
      ON g.code = e.gender_code
    WHERE e.URN = @URN
)
SELECT
    s.URN AS urn,
    s.UKPRN AS ukprn,
    s.LA_code AS local_authority_code,
    s.EstablishmentNumber AS establishment_number,
    CASE
        WHEN s.LA_code IS NULL OR s.EstablishmentNumber IS NULL THEN NULL
        ELSE CONCAT(s.LA_code, '/', RIGHT(CONCAT('0000', CAST(s.EstablishmentNumber AS varchar(4))), 4))
    END AS dfe_number,
    s.EstablishmentName AS name,
    s.type_code AS source_establishment_type_code,
    s.type_name AS source_establishment_type,
    CASE
        WHEN s.type_name = 'Community school' THEN 1
        WHEN s.type_name IN ('Academy sponsor led', 'Academy converter') THEN 4
        WHEN s.type_name IN ('Academy special sponsor led', 'Academy special converter') THEN 5
        WHEN s.type_name IN ('Academy alternative provision sponsor led', 'Academy alternative provision converter') THEN 6
        WHEN s.type_name IN ('Academy 16-19 sponsor led', 'Academy 16 to 19 converter') THEN 7
        WHEN s.type_name = 'Academy secure 16 to 19' THEN 8
        ELSE NULL
    END AS establishment_type_id,
    CASE
        WHEN s.type_name IN ('Academy sponsor led', 'Academy converter') THEN 'Mainstream academy'
        WHEN s.type_name IN ('Academy special sponsor led', 'Academy special converter') THEN 'Academy special school'
        WHEN s.type_name IN ('Academy alternative provision sponsor led', 'Academy alternative provision converter') THEN 'Academy alternative provision'
        WHEN s.type_name IN ('Academy 16-19 sponsor led', 'Academy 16 to 19 converter') THEN 'Academy 16 to 19'
        ELSE s.type_name
    END AS establishment_type,
    s.educationPhase_code AS source_education_phase_code,
    s.education_phase_name AS source_education_phase,
    CASE s.education_phase_name
        WHEN 'Nursery' THEN 1
        WHEN 'Primary' THEN 2
        WHEN 'Middle deemed primary' THEN 3
        WHEN 'Middle deemed secondary' THEN 4
        WHEN 'Secondary' THEN 5
        WHEN 'All-through' THEN 6
        WHEN '16 to 19' THEN 7
        WHEN 'Not applicable' THEN 8
        WHEN 'Not applicable (education phase)' THEN 8
        ELSE NULL
    END AS education_phase_id,
    CASE
        WHEN s.education_phase_name = 'Not applicable' THEN 'Not applicable (education phase)'
        ELSE s.education_phase_name
    END AS education_phase,
    s.gender_code AS source_gender_code,
    s.gender_name AS source_gender,
    CASE s.gender_name
        WHEN 'Mixed' THEN 1
        WHEN 'Boys' THEN 2
        WHEN 'Girls' THEN 3
        WHEN 'Not applicable' THEN 4
        WHEN 'Not applicable (gender of entry)' THEN 4
        ELSE NULL
    END AS gender_of_entry_type_id,
    CASE
        WHEN s.gender_name = 'Not applicable' THEN 'Not applicable (gender of entry)'
        ELSE s.gender_name
    END AS gender_of_entry,
    s.StatutoryLowAge AS lower_statutory_age,
    s.StatutoryHighAge AS upper_statutory_age
FROM source_establishment AS s;
