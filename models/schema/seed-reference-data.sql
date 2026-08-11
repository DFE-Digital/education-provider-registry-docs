-- Seed reference data for the EPR model.
-- Target: PostgreSQL database establishment_local, schema establishment.
--
-- This file is the shared reference-data seed entry point. Add further
-- reference-table inserts here as the physical model grows.
--
-- establishment_type_id values are explicitly assigned here. They are stable
-- target identifiers, not serial/identity values and not BAU type codes. Once
-- this baseline is adopted, do not renumber or reuse an ID used by data.
--
-- This is reference data, so rerunning the script updates labels without
-- creating duplicate IDs.

BEGIN;

INSERT INTO establishment.establishment_type (establishment_type_id, name)
VALUES
    -- Core community-school and academy concepts
    (1, 'Community school'),
    (2, 'Community special school'),
    (3, 'Foundation special school'),
    (4, 'Mainstream academy'),
    (5, 'Academy special school'),
    (6, 'Academy alternative provision'),
    (7, 'Academy 16 to 19'),
    (8, 'Academy secure 16 to 19'),
    (9, 'Voluntary aided school'),
    (10, 'Voluntary controlled school'),
    (11, 'Foundation school'),
    (12, 'Pupil referral unit'),
    (13, 'Maintained nursery school'),
    (14, 'Non-maintained special school'),
    (15, 'Other independent special school'),
    (16, 'City technology college'),
    (17, 'Other independent school'),
    (18, 'Further education'),
    (19, 'Sixth form centre'),
    (20, 'Higher education institution'),
    (21, 'University technical college'),
    (22, 'Welsh establishment'),
    (23, 'Secure units'),
    (24, 'Offshore schools'),
    (25, 'Service children''s education'),
    (26, 'Miscellaneous'),
    (27, 'Special post 16 institution'),
    (28, 'British schools overseas'),
    (29, 'Institution funded by other government department'),
    (30, 'Free schools'),
    (31, 'Free schools special'),
    (32, 'Free schools alternative provision'),
    (33, 'Free schools 16 to 19'),
    (34, 'Studio schools'),
    (35, 'Children''s centre'),
    (36, 'Children''s centre linked site'),
    (37, 'Online provider')
ON CONFLICT (establishment_type_id) DO UPDATE
SET name = EXCLUDED.name;

-- Education-phase concepts from establishment-taxonomy.ttl.
--
-- education_phase_id values are explicitly assigned here. They are stable
-- target identifiers, not serial/identity values and not BAU phase codes.
INSERT INTO establishment.education_phase (education_phase_id, name)
VALUES
    (1, 'Nursery'),
    (2, 'Primary'),
    (3, 'Middle deemed primary'),
    (4, 'Middle deemed secondary'),
    (5, 'Secondary'),
    (6, 'All-through'),
    (7, '16 to 19'),
    (8, 'Not applicable (education phase)')
ON CONFLICT (education_phase_id) DO UPDATE
SET name = EXCLUDED.name;

-- Gender-of-entry concepts from establishment-taxonomy.ttl.
--
-- gender_of_entry_type_id values are explicitly assigned here. They are stable
-- target identifiers, not serial/identity values and not BAU gender codes.
INSERT INTO establishment.gender_of_entry_type (gender_of_entry_type_id, name)
VALUES
    (1, 'Mixed'),
    (2, 'Boys'),
    (3, 'Girls'),
    (4, 'Not applicable (gender of entry)')
ON CONFLICT (gender_of_entry_type_id) DO UPDATE
SET name = EXCLUDED.name;

COMMIT;
