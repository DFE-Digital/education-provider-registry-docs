--
-- PostgreSQL database dump
--

\restrict fZLY0SKFMjfMMVd5VlCrekSHBE4sA4SwZDBNaRSRQiLFzVSOlAASiIfWFeY4c5a

-- Dumped from database version 18.6
-- Dumped by pg_dump version 18.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Data for Name: legal_entity; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.legal_entity (legal_entity_id, name, legal_entity_type_id, charity_status_id, incorporation_date, dissolution_date) VALUES
	('8777a5a5-b34f-4732-9ade-cf670eff0709', 'MARCH 2016 LIMITED', NULL, NULL, '2009-04-27', NULL);


--
-- Data for Name: establishment_party_role; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_party_role (establishment_party_role_id, establishment_party_role_type_id, legal_entity_id, person_id, start_date, end_date) VALUES
	('cd129711-2f9a-4177-91ef-d046b032013c', 1, '8777a5a5-b34f-4732-9ade-cf670eff0709', NULL, NULL, '2016-02-29');


--
-- Data for Name: academy_trust_classification; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.academy_trust_classification (academy_trust_classification_id, establishment_party_role_id, academy_trust_type_id, start_date, end_date) VALUES
	('0636cff6-d0e2-4966-b79c-5e5757e2425f', 'cd129711-2f9a-4177-91ef-d046b032013c', 2, NULL, '2016-02-29');


--
-- Data for Name: address; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.address (address_id, address_line_1, address_line_2, address_line_3, town, county, postcode) VALUES
	('43987ae9-26da-4a20-aae9-87775b85afe9', 'obfuscated', NULL, NULL, 'obfuscated', '099', 'NW1 3EX'),
	('074ed567-a830-4432-bb45-6e583bfd9ec7', 'obfuscated', NULL, NULL, 'obfuscated', '019', 'WN7 3PQ'),
	('78de305d-f327-43f9-8f83-9462172fe315', 'obfuscated', NULL, 'obfuscated', 'obfuscated', '032', 'ST6 4LD'),
	('7a31de5c-2ee5-46d8-9118-e2fbaf065bf9', 'obfuscated', 'Blackley', NULL, 'obfuscated', '099', 'M9 7SS');


--
-- Data for Name: establishment; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment (establishment_id, urn, ukprn, establishment_number, name, establishment_type_id, education_phase_id) VALUES
	('64f385b3-2cca-4883-889f-8d8b4ee8dc31', 100018, 10069172, 2436, 'Netley Primary School & Centre for Autism', 1, 2),
	('88a4d361-4e0a-457b-a031-6192a87d2cdf', 106431, 10072615, 2053, 'Gilded Hollins Community School', 1, 2),
	('19a00e2f-0e1b-48d5-b360-f559f0e18f36', 136102, 10030216, 6905, 'The Co-Operative Academy of Stoke-On-Trent', 4, 5),
	('942c642a-018c-4e01-a03d-10e579877e52', 135905, NULL, 6910, 'Manchester Creative and Media Academy', 4, 5);


--
-- Data for Name: capacity_and_pupil_measures; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.capacity_and_pupil_measures (capacity_and_pupil_measures_id, establishment_id, school_capacity, pupil_count, free_school_meal_measure, census_date) VALUES
	('125a4781-483e-4abc-ab2e-ac625877a6a7', '64f385b3-2cca-4883-889f-8d8b4ee8dc31', 65801, 383, 224, NULL),
	('4ef4d9b5-71e5-4daf-bfd2-4e9ed695fdf1', '88a4d361-4e0a-457b-a031-6192a87d2cdf', 22286, 209, 15, NULL),
	('3d2280b7-29d9-4c97-ba37-c6841a652972', '19a00e2f-0e1b-48d5-b360-f559f0e18f36', 1050, 1300, 735, NULL),
	('d54c5844-bb88-4f51-b38c-c4adee255816', '942c642a-018c-4e01-a03d-10e579877e52', 660, NULL, NULL, NULL);


--
-- Data for Name: education_admissions_and_provision; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.education_admissions_and_provision (education_admissions_and_provision_id, establishment_id, gender_of_entry_type_id, admissions_policy_id, boarding_provision_id, nursery_provision_id, sixth_form_provision_id) VALUES
	('b08e2584-1781-4460-a103-47932facccfb', '64f385b3-2cca-4883-889f-8d8b4ee8dc31', 1, 3, 1, 1, 2),
	('84980b21-f7c5-4852-9339-3ffc98f693cf', '88a4d361-4e0a-457b-a031-6192a87d2cdf', 1, 3, 1, 2, 2),
	('8f4ff7cb-0198-418b-8b3f-ac26c2bca999', '19a00e2f-0e1b-48d5-b360-f559f0e18f36', 1, 1, 1, 3, 3),
	('11d706ba-542f-4843-8d88-1fe7df617a02', '942c642a-018c-4e01-a03d-10e579877e52', 1, 1, 1, 3, 1);


--
-- Data for Name: establishment_contact; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_contact (establishment_contact_id, establishment_id, website, telephone_number) VALUES
	('f8af6906-3070-496e-9b4a-174d5038c243', '64f385b3-2cca-4883-889f-8d8b4ee8dc31', 'www.netley.camden.sch.uk/', '111111'),
	('d33e618c-23a5-4ea0-8197-647742c0a73a', '88a4d361-4e0a-457b-a031-6192a87d2cdf', 'www.gildedhollins.wigan.sch.uk/', '111111'),
	('7eb91d48-611f-4a7c-9056-3a4e88a9952d', '19a00e2f-0e1b-48d5-b360-f559f0e18f36', 'http://www.cas.coop', '111111');


--
-- Data for Name: establishment_geography; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_geography (establishment_geography_id, establishment_id, local_authority_id, government_office_region_id, district_administrative_id, administrative_ward_id, parliamentary_constituency_id, lsoa_id, msoa_id, urban_rural_id) VALUES
	('54ec530b-4aca-4cad-a8c9-8a44ece3e099', '64f385b3-2cca-4883-889f-8d8b4ee8dc31', '0956c9af-2de2-4dea-94ed-b5c432eae45f', '1375841f-e6ba-4cda-9fac-753ff9df93a2', 'f2665403-6621-493d-8a2d-8de9ae1f1c4a', '2aebb958-956d-4800-a776-00aac3556316', '90dee41f-c934-4b2d-9d52-b42e83fdfe88', '94fb01a9-81ec-4a90-88a6-4ad2a8db4ba9', '4cdb54e5-d81b-45d9-b218-65030aab6d87', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('e83b19bc-6983-4ac0-893f-43347b4da8a3', '88a4d361-4e0a-457b-a031-6192a87d2cdf', '2601da0a-6f35-4c15-984e-f4482d1df384', '489dce3e-58d7-44c5-b9ef-2f7d7cbdb592', '412eea43-d307-464e-a929-62cfd4b5028d', '43acd11d-82cc-4391-8965-d45a61e5cd71', '2a9b46ea-4d43-474f-acbf-05444acfa1d1', '9cc4ab4f-4e19-465d-80a4-87b97b425244', '136005b3-68ff-4fa7-b439-2b4a1d626b24', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('7f16b269-6abf-4c6a-8f85-d258ce3bc113', '19a00e2f-0e1b-48d5-b360-f559f0e18f36', '3332ea83-bcbe-48d1-970d-a3650d9bcf10', '7ca695f4-dfcd-4f78-bdaf-17861eafbf97', '6ef1f577-d0bc-4698-951c-f202f9eaada6', 'e73f0fc2-114a-4772-a84e-5363b02ba34b', '714fb4a2-4d2e-4875-9853-1d7d6696559e', 'cec78739-d3a7-4831-9934-8dec5c5bdcd1', '5ed6445f-c41a-4778-9a5c-55ba74a2155b', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('8c9aab68-a100-469e-b2d4-6ec8da1d5401', '942c642a-018c-4e01-a03d-10e579877e52', '0a78f87e-d71b-44c3-b598-2cc2b8038e95', '489dce3e-58d7-44c5-b9ef-2f7d7cbdb592', 'c8efb411-9c6d-492e-af1e-624ed743712f', 'f22dfd05-c647-403a-bebd-69fb3a62cca6', '93b33a64-95d1-4d7f-9142-4acc73221e9a', '22d38930-6da2-4b70-9bca-6208cbb43ba5', 'cddc19f9-9b91-4e98-a4c8-656753fd673c', 'fba31373-6bf1-4ad2-9d63-a2c783849aad');


--
-- Data for Name: establishment_lifecycle; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_lifecycle (establishment_lifecycle_id, establishment_id, establishment_status_id, open_date, close_date, reason_establishment_opened_id, reason_establishment_closed_id, last_changed_date) VALUES
	('63dd4d77-2d0d-49ff-a4de-20ff85c430dd', '64f385b3-2cca-4883-889f-8d8b4ee8dc31', 1, NULL, NULL, NULL, NULL, '2026-06-23'),
	('378cd894-92d4-4c0a-ac3d-fa1d74d1fe0f', '88a4d361-4e0a-457b-a031-6192a87d2cdf', 1, NULL, NULL, NULL, NULL, '2026-06-23'),
	('6fbd5bcd-8f4e-41e8-8577-226cc990b939', '19a00e2f-0e1b-48d5-b360-f559f0e18f36', 1, '2010-09-01', NULL, 2, NULL, '2026-06-23'),
	('0504e766-077c-4dd8-9bc1-d8b638322530', '942c642a-018c-4e01-a03d-10e579877e52', 2, '2009-09-01', '2016-02-29', 2, 12, '2018-07-02');


--
-- Data for Name: establishment_responsibility; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_responsibility (establishment_responsibility_id, establishment_id, legal_entity_id, person_id, responsibility_type_id, start_date, end_date) VALUES
	('7e12aa3f-f165-44ac-bb79-a59e79e8c89b', '942c642a-018c-4e01-a03d-10e579877e52', '8777a5a5-b34f-4732-9ade-cf670eff0709', NULL, 1, '2009-09-01', '2016-02-29');

INSERT INTO establishment.group_identifier (establishment_party_role_id, group_identifier_type_id, identifier_issuer_id, value, is_current)
VALUES
    ('cd129711-2f9a-4177-91ef-d046b032013c', 1, 1, '3839', true),
    ('cd129711-2f9a-4177-91ef-d046b032013c', 2, 1, 'TR01385', true);


--
-- Data for Name: site; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.site (site_id, address_id, site_name, uprn) VALUES
	('d22d2274-f74c-44ed-9ed4-cc8b1e46aad9', '43987ae9-26da-4a20-aae9-87775b85afe9', NULL, 5172210),
	('5751510c-fca4-4650-88f9-c07ed506f877', '074ed567-a830-4432-bb45-6e583bfd9ec7', NULL, 100012855917),
	('9320b8b3-fc3e-4f9b-93ba-8336f0f416af', '78de305d-f327-43f9-8f83-9462172fe315', NULL, 3455015782),
	('c41e224a-9d1a-4ee0-8c9d-fe8d0c20cc73', '7a31de5c-2ee5-46d8-9118-e2fbaf065bf9', NULL, 10090666596);


--
-- Data for Name: establishment_to_site; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_to_site (establishment_id, site_id, is_main_site) VALUES
	('64f385b3-2cca-4883-889f-8d8b4ee8dc31', 'd22d2274-f74c-44ed-9ed4-cc8b1e46aad9', true),
	('88a4d361-4e0a-457b-a031-6192a87d2cdf', '5751510c-fca4-4650-88f9-c07ed506f877', true),
	('19a00e2f-0e1b-48d5-b360-f559f0e18f36', '9320b8b3-fc3e-4f9b-93ba-8336f0f416af', true),
	('942c642a-018c-4e01-a03d-10e579877e52', 'c41e224a-9d1a-4ee0-8c9d-fe8d0c20cc73', true);


--
-- Data for Name: organisation_identifier; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.organisation_identifier (organisation_identifier_id, legal_entity_id, organisation_identifier_type_id, value, is_current) VALUES
	('f70abdb5-a361-4407-85f7-346054f3e0c3', '8777a5a5-b34f-4732-9ade-cf670eff0709', 1, '06888873', true);


--
-- Data for Name: specialist_provision; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.specialist_provision (specialist_provision_id, establishment_id, specialist_provision_type_id) VALUES
	('7dd6e6e3-fa0a-4d71-b839-914e1246c389', '64f385b3-2cca-4883-889f-8d8b4ee8dc31', 3);


--
-- Data for Name: resourced_provision; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.resourced_provision (resourced_provision_id, specialist_provision_id, capacity, pupil_count) VALUES
	('06f4142e-229e-47c8-b9ec-ab645973bc1e', '7dd6e6e3-fa0a-4d71-b839-914e1246c389', 24, 24);


--
-- Data for Name: sen_unit_provision; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.sen_unit_provision (sen_unit_provision_id, specialist_provision_id, capacity, pupil_count) VALUES
	('8bccfa21-de68-4457-b6de-9532f8ff8f33', '7dd6e6e3-fa0a-4d71-b839-914e1246c389', 24, 24);


--
-- Data for Name: statutory_age_range; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.statutory_age_range (statutory_age_range_id, education_admissions_and_provision_id, lower_statutory_age, upper_statutory_age) VALUES
	('9f93e870-be73-4dba-a99d-e3746e323ab8', 'b08e2584-1781-4460-a103-47932facccfb', 2, 11),
	('fcf2c499-0aab-4f6f-9e7d-eac250e6b111', '84980b21-f7c5-4852-9339-3ffc98f693cf', 4, 11),
	('eef4fbe5-71b7-4f47-b196-6ceb3bd18f60', '8f4ff7cb-0198-418b-8b3f-ac26c2bca999', 11, 16),
	('8d78f0ad-f225-43d4-a6f3-5331cc28378b', '11d706ba-542f-4843-8d88-1fe7df617a02', 11, 19);


--
-- PostgreSQL database dump complete
--

\unrestrict fZLY0SKFMjfMMVd5VlCrekSHBE4sA4SwZDBNaRSRQiLFzVSOlAASiIfWFeY4c5a

