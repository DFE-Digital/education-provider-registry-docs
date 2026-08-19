-- Seed The Outdoors School (URN 146200), including its primary site and
-- four additional sites from dbo.EstablishmentAdditionalAddresses.
-- Target: PostgreSQL database establishment_local, schema establishment.

BEGIN;

INSERT INTO establishment.establishment_type (establishment_type_id, name)
VALUES (15, 'Other independent special school')
ON CONFLICT (establishment_type_id) DO UPDATE SET name = EXCLUDED.name;
INSERT INTO establishment.education_phase (education_phase_id, name)
VALUES (8, 'Not applicable (education phase)')
ON CONFLICT (education_phase_id) DO UPDATE SET name = EXCLUDED.name;
INSERT INTO establishment.gender_of_entry_type (gender_of_entry_type_id, name)
VALUES (1, 'Mixed')
ON CONFLICT (gender_of_entry_type_id) DO UPDATE SET name = EXCLUDED.name;
INSERT INTO establishment.admissions_policy (admissions_policy_id, name)
VALUES (3, 'Not applicable (admissions policy)')
ON CONFLICT (admissions_policy_id) DO UPDATE SET name = EXCLUDED.name;
INSERT INTO establishment.boarding_provision (boarding_provision_id, name)
VALUES (1, 'No boarders')
ON CONFLICT (boarding_provision_id) DO UPDATE SET name = EXCLUDED.name;
INSERT INTO establishment.nursery_provision (nursery_provision_id, name)
VALUES (3, 'Not applicable (nursery provision)')
ON CONFLICT (nursery_provision_id) DO UPDATE SET name = EXCLUDED.name;
INSERT INTO establishment.sixth_form_provision (sixth_form_provision_id, name)
VALUES (3, 'Not applicable (sixth-form provision)')
ON CONFLICT (sixth_form_provision_id) DO UPDATE SET name = EXCLUDED.name;

INSERT INTO establishment.establishment (
    urn, local_authority_code, establishment_number, ukprn, name,
    establishment_type_id, education_phase_id
)
VALUES (146200, '878', 6075, 10095651, 'The Outdoors School', 15, 8)
ON CONFLICT (urn) DO UPDATE SET
    local_authority_code = EXCLUDED.local_authority_code,
    establishment_number = EXCLUDED.establishment_number,
    ukprn = EXCLUDED.ukprn,
    name = EXCLUDED.name,
    establishment_type_id = EXCLUDED.establishment_type_id,
    education_phase_id = EXCLUDED.education_phase_id;

INSERT INTO establishment.address (address_line_1,address_line_2,address_line_3,town,county,postcode)
SELECT 'Straw Barn','Barton Lane','Shillingford Abbot','Exeter','008','EX2 9QQ'
WHERE NOT EXISTS (SELECT 1 FROM establishment.site WHERE uprn = 10032960599);
INSERT INTO establishment.address (address_line_1,address_line_2,address_line_3,town,county,postcode)
SELECT 'Exeter Forest School','Shillingford Road','Shillingford St George','Exeter','008','EX2 9QL'
WHERE NOT EXISTS (SELECT 1 FROM establishment.site WHERE uprn = 10032969652);
INSERT INTO establishment.address (address_line_1,address_line_2,address_line_3,town,county,postcode)
SELECT 'Cowleymoor Road','Cowleymore',NULL,'Tiverton','008','EX16 6HH'
WHERE NOT EXISTS (SELECT 1 FROM establishment.site WHERE uprn = 100041034852);
INSERT INTO establishment.address (address_line_1,address_line_2,address_line_3,town,county,postcode)
SELECT 'Okehampton Forest School','Moyses Lane',NULL,'Okehampton','008','EX20 1JS'
WHERE NOT EXISTS (SELECT 1 FROM establishment.site WHERE uprn = 100040393137);
INSERT INTO establishment.address (address_line_1,address_line_2,address_line_3,town,county,postcode)
SELECT 'Exmouth Forest School','Knowle Hill','Leeford Woods','Exmouth','008','EX9 7AL'
WHERE NOT EXISTS (SELECT 1 FROM establishment.site WHERE uprn = 10000250317);

INSERT INTO establishment.establishment_location (establishment_id)
SELECT establishment_id FROM establishment.establishment WHERE urn = 146200
ON CONFLICT (establishment_id) DO NOTHING;

INSERT INTO establishment.site (establishment_location_id,address_id,site_name,uprn)
SELECT l.establishment_location_id,a.address_id,NULL,10032960599
FROM establishment.establishment_location l
JOIN establishment.establishment e ON e.establishment_id=l.establishment_id
JOIN establishment.address a ON a.postcode='EX2 9QQ'
WHERE e.urn=146200 AND NOT EXISTS (SELECT 1 FROM establishment.site s WHERE s.uprn=10032960599);
INSERT INTO establishment.site (establishment_location_id,address_id,site_name,uprn)
SELECT l.establishment_location_id,a.address_id,NULL,10032969652
FROM establishment.establishment_location l JOIN establishment.establishment e ON e.establishment_id=l.establishment_id
JOIN establishment.address a ON a.postcode='EX2 9QL'
WHERE e.urn=146200 AND NOT EXISTS (SELECT 1 FROM establishment.site s WHERE s.uprn=10032969652);
INSERT INTO establishment.site (establishment_location_id,address_id,site_name,uprn)
SELECT l.establishment_location_id,a.address_id,NULL,100041034852
FROM establishment.establishment_location l JOIN establishment.establishment e ON e.establishment_id=l.establishment_id
JOIN establishment.address a ON a.postcode='EX16 6HH'
WHERE e.urn=146200 AND NOT EXISTS (SELECT 1 FROM establishment.site s WHERE s.uprn=100041034852);
INSERT INTO establishment.site (establishment_location_id,address_id,site_name,uprn)
SELECT l.establishment_location_id,a.address_id,NULL,100040393137
FROM establishment.establishment_location l JOIN establishment.establishment e ON e.establishment_id=l.establishment_id
JOIN establishment.address a ON a.postcode='EX20 1JS'
WHERE e.urn=146200 AND NOT EXISTS (SELECT 1 FROM establishment.site s WHERE s.uprn=100040393137);
INSERT INTO establishment.site (establishment_location_id,address_id,site_name,uprn)
SELECT l.establishment_location_id,a.address_id,NULL,10000250317
FROM establishment.establishment_location l JOIN establishment.establishment e ON e.establishment_id=l.establishment_id
JOIN establishment.address a ON a.postcode='EX9 7AL'
WHERE e.urn=146200 AND NOT EXISTS (SELECT 1 FROM establishment.site s WHERE s.uprn=10000250317);

UPDATE establishment.establishment_location l
SET main_site_id=s.site_id
FROM establishment.site s, establishment.establishment e
WHERE e.establishment_id=l.establishment_id AND e.urn=146200 AND s.uprn=10032960599;

INSERT INTO establishment.capacity_and_pupil_measures (establishment_id,school_capacity,pupil_count)
SELECT establishment_id,150,112 FROM establishment.establishment WHERE urn=146200
ON CONFLICT (establishment_id) DO UPDATE SET school_capacity=EXCLUDED.school_capacity,pupil_count=EXCLUDED.pupil_count;

INSERT INTO establishment.education_admissions_and_provision (establishment_id,gender_of_entry_type_id,admissions_policy_id,boarding_provision_id,nursery_provision_id,sixth_form_provision_id)
SELECT establishment_id,1,3,1,3,3 FROM establishment.establishment WHERE urn=146200
ON CONFLICT (establishment_id) DO UPDATE SET gender_of_entry_type_id=EXCLUDED.gender_of_entry_type_id,admissions_policy_id=EXCLUDED.admissions_policy_id,boarding_provision_id=EXCLUDED.boarding_provision_id,nursery_provision_id=EXCLUDED.nursery_provision_id,sixth_form_provision_id=EXCLUDED.sixth_form_provision_id;

INSERT INTO establishment.statutory_age_range (education_admissions_and_provision_id,lower_statutory_age,upper_statutory_age)
SELECT eap.education_admissions_and_provision_id,5,16 FROM establishment.education_admissions_and_provision eap JOIN establishment.establishment e ON e.establishment_id=eap.establishment_id WHERE e.urn=146200
ON CONFLICT (education_admissions_and_provision_id) DO UPDATE SET lower_statutory_age=EXCLUDED.lower_statutory_age,upper_statutory_age=EXCLUDED.upper_statutory_age;

COMMIT;
