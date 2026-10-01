-- T2 checked-in Establishment fixture: St Mary Magdalene Academy, URN 134314.
-- The academy trust and external sponsor are deliberately separate parties.

INSERT INTO establishment.legal_entity
    (legal_entity_id, name, incorporation_date)
VALUES
    ('13431400-0000-4000-8000-000000000001', 'HIVE EDUCATION TRUST', '2005-04-04'),
    ('13431400-0000-4000-8000-000000000002', 'Diocese of London', NULL);

INSERT INTO establishment.establishment
    (establishment_id, urn, ukprn, establishment_number, name, establishment_type_id, education_phase_id)
VALUES
    ('13431400-0000-4000-8000-000000000010', 134314, 10024207, 6905,
     'St Mary Magdalene Academy', 4, 7);

INSERT INTO establishment.capacity_and_pupil_measures
    (capacity_and_pupil_measures_id, establishment_id, school_capacity, pupil_count,
     free_school_meal_measure, census_date)
VALUES
    ('13431400-0000-4000-8000-000000000011',
     '13431400-0000-4000-8000-000000000010', NULL, NULL, NULL, NULL);

INSERT INTO establishment.education_admissions_and_provision
    (education_admissions_and_provision_id, establishment_id,
     gender_of_entry_type_id, admissions_policy_id, boarding_provision_id,
     nursery_provision_id, sixth_form_provision_id)
VALUES
    ('13431400-0000-4000-8000-000000000012',
     '13431400-0000-4000-8000-000000000010', 1, 1, 1, 3, 1);

INSERT INTO establishment.establishment_contact
    (establishment_contact_id, establishment_id, website, telephone_number)
VALUES
    ('13431400-0000-4000-8000-000000000013',
     '13431400-0000-4000-8000-000000000010',
     'www.smmacademy.org', '02076970123');

INSERT INTO establishment.address
    (address_id, address_line_1, town, county, postcode)
VALUES
    ('13431400-0000-4000-8000-000000000014',
     'Liverpool Road', 'London', 'Islington', 'N7 8PG');

INSERT INTO establishment.site (site_id, address_id, site_name, uprn)
VALUES
    ('13431400-0000-4000-8000-000000000015',
     '13431400-0000-4000-8000-000000000014', NULL, NULL);

INSERT INTO establishment.establishment_to_site
    (establishment_id, site_id, is_main_site)
VALUES
    ('13431400-0000-4000-8000-000000000010',
     '13431400-0000-4000-8000-000000000015', true);

INSERT INTO establishment.establishment_geography
    (establishment_geography_id, establishment_id, local_authority_id)
SELECT '13431400-0000-4000-8000-000000000016',
       '13431400-0000-4000-8000-000000000010',
       la.local_authority_id
FROM establishment.local_authority AS la
WHERE la.code = 206;

INSERT INTO establishment.establishment_lifecycle
    (establishment_lifecycle_id, establishment_id, establishment_status_id,
     open_date, close_date, reason_establishment_opened_id, last_changed_date)
VALUES
    ('13431400-0000-4000-8000-000000000017',
     '13431400-0000-4000-8000-000000000010', 1,
     '2007-09-01', NULL, 2, '2026-06-23');

INSERT INTO establishment.statutory_age_range
    (statutory_age_range_id, education_admissions_and_provision_id,
     lower_statutory_age, upper_statutory_age)
VALUES
    ('13431400-0000-4000-8000-000000000018',
     '13431400-0000-4000-8000-000000000012', 3, 19);

INSERT INTO establishment.establishment_party_role
    (establishment_party_role_id, establishment_party_role_type_id,
     legal_entity_id, start_date, end_date)
VALUES
    ('13431400-0000-4000-8000-000000000020', 1,
     '13431400-0000-4000-8000-000000000001', NULL, NULL),
    ('13431400-0000-4000-8000-000000000021', 4,
     '13431400-0000-4000-8000-000000000002', NULL, NULL);

INSERT INTO establishment.academy_trust_classification
    (academy_trust_classification_id, establishment_party_role_id,
     academy_trust_type_id, start_date, end_date)
VALUES
    ('13431400-0000-4000-8000-000000000022',
     '13431400-0000-4000-8000-000000000020', 1, '2007-09-01', '2021-10-03'),
    ('13431400-0000-4000-8000-000000000030',
     '13431400-0000-4000-8000-000000000020', 2, '2021-10-04', NULL);

INSERT INTO establishment.establishment_responsibility
    (establishment_responsibility_id, establishment_id, legal_entity_id,
     responsibility_type_id, start_date, end_date)
VALUES
    ('13431400-0000-4000-8000-000000000023',
     '13431400-0000-4000-8000-000000000010',
     '13431400-0000-4000-8000-000000000001', 1, '2007-09-01', '2021-10-03'),
    ('13431400-0000-4000-8000-000000000031',
     '13431400-0000-4000-8000-000000000010',
     '13431400-0000-4000-8000-000000000001', 1, '2021-10-04', NULL),
    ('13431400-0000-4000-8000-000000000024',
     '13431400-0000-4000-8000-000000000010',
     '13431400-0000-4000-8000-000000000002', 3, '2007-09-01', NULL);

INSERT INTO establishment.group_identifier
    (group_identifier_id, establishment_party_role_id, group_identifier_type_id,
     identifier_issuer_id, value, is_current)
VALUES
    ('13431400-0000-4000-8000-000000000025',
     '13431400-0000-4000-8000-000000000020', 1, 1, '23869', true),
    ('13431400-0000-4000-8000-000000000026',
     '13431400-0000-4000-8000-000000000020', 2, 1, 'TR02103', true),
    ('13431400-0000-4000-8000-000000000032',
     '13431400-0000-4000-8000-000000000020', 1, 1, '4737', false),
    ('13431400-0000-4000-8000-000000000027',
     '13431400-0000-4000-8000-000000000021', 1, 1, '2914', true),
    ('13431400-0000-4000-8000-000000000028',
     '13431400-0000-4000-8000-000000000021', 2, 1, 'SP00172', true);

INSERT INTO establishment.organisation_identifier
    (organisation_identifier_id, legal_entity_id, organisation_identifier_type_id,
     value, is_current)
VALUES
    ('13431400-0000-4000-8000-000000000029',
     '13431400-0000-4000-8000-000000000001', 1, '05412502', true);
