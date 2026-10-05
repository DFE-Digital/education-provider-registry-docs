--
-- PostgreSQL database dump
--

\restrict G75ylQYF7TCieD1lShC8yRyLzXfZShrWpQxAK3qlvDkHfdiLmwleu0BuFnwMHzg

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
	('55f4b685-633e-443e-acc0-34a0a4c8d4db', 'THE CO-OPERATIVE ACADEMIES TRUST', 1, NULL, '2011-08-19', NULL),
	('ce981241-d054-40fe-a0b5-96115c7400db', 'HIVE EDUCATION TRUST', 1, NULL, '2005-04-04', NULL),
	('d4ede9dd-7b90-493b-b401-1a534fa704e4', 'Diocese of London', NULL, NULL, NULL, NULL),
	('b47a870c-ef45-4431-a306-23854718a4bb', 'MARCH 2016 LIMITED', 1, NULL, '2009-04-27', NULL);


--
-- Data for Name: academy_trust_classification; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.academy_trust_classification (academy_trust_classification_id, legal_entity_id, academy_trust_type_id, start_date, end_date, is_current) VALUES
	('3320d7bb-6312-455c-bd31-516d9c708661', '55f4b685-633e-443e-acc0-34a0a4c8d4db', 2, NULL, NULL, true),
	('d1de10e1-e520-42ee-953d-e1d456d4ffbf', '55f4b685-633e-443e-acc0-34a0a4c8d4db', 1, NULL, NULL, false),
	('7eb38e53-f6b2-4a0e-8f42-d7ebd305310a', 'ce981241-d054-40fe-a0b5-96115c7400db', 2, NULL, NULL, true),
	('0c678562-127a-4997-bfd1-532a3ef30232', 'ce981241-d054-40fe-a0b5-96115c7400db', 1, NULL, NULL, false),
	('a5ac8751-5965-4d5c-a725-8704daaf43dd', 'b47a870c-ef45-4431-a306-23854718a4bb', 2, NULL, '2016-02-29', false);


--
-- Data for Name: address; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.address (address_id, address_line_1, address_line_2, address_line_3, town, county, postcode) VALUES
	('06883ef6-2a21-4aff-a0ba-12f2f4d17ab3', 'obfuscated', NULL, 'obfuscated', 'obfuscated', '032', 'ST6 4LD'),
	('b8556543-8018-4ae7-bebb-be901809035d', 'obfuscated', 'Islington', NULL, 'obfuscated', '099', 'N7 8PG'),
	('6a967154-9263-4b71-abf2-27cc859ba101', 'obfuscated', 'Blackley', NULL, 'obfuscated', '099', 'M9 7SS');


--
-- Data for Name: establishment; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment (establishment_id, urn, ukprn, establishment_number, name, establishment_type_id, education_phase_id) VALUES
	('b393833d-d8e4-4081-9ef8-e5faa9db9d28', 136102, 10030216, 6905, 'The Co-Operative Academy of Stoke-On-Trent', 4, 5),
	('3ec506af-362d-47c3-ada1-25956a686235', 134314, 10024207, 6905, 'St Mary Magdalene Academy', 4, 6),
	('728659aa-4d06-4685-9d16-c2c38504c618', 135905, NULL, 6910, 'Manchester Creative and Media Academy', 4, 5);


--
-- Data for Name: capacity_and_pupil_measures; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.capacity_and_pupil_measures (capacity_and_pupil_measures_id, establishment_id, school_capacity, pupil_count, free_school_meal_measure, census_date) VALUES
	('c3276c34-d242-4888-93c1-102cc7e44ed8', 'b393833d-d8e4-4081-9ef8-e5faa9db9d28', 1050, 1300, 735, NULL),
	('767d9ec1-b4fe-4ef1-a64d-6e1eb47a7091', '3ec506af-362d-47c3-ada1-25956a686235', 1310, 1561, 465, NULL),
	('53c7ce3b-7fb5-4fd0-899b-546d599835c9', '728659aa-4d06-4685-9d16-c2c38504c618', 660, NULL, NULL, NULL);


--
-- Data for Name: education_admissions_and_provision; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.education_admissions_and_provision (education_admissions_and_provision_id, establishment_id, gender_of_entry_type_id, admissions_policy_id, boarding_provision_id, nursery_provision_id, sixth_form_provision_id) VALUES
	('e1db4be0-0f37-46df-924f-7472d526edeb', 'b393833d-d8e4-4081-9ef8-e5faa9db9d28', 1, 1, 1, 3, 3),
	('f995da2b-0be0-427f-a04e-a62e5dbd24c5', '3ec506af-362d-47c3-ada1-25956a686235', 1, 1, 1, 2, 1),
	('03831c3c-9a2e-4e91-85f1-600108f0984d', '728659aa-4d06-4685-9d16-c2c38504c618', 1, 1, 1, 3, 1);


--
-- Data for Name: establishment_contact; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_contact (establishment_contact_id, establishment_id, website, telephone_number) VALUES
	('60265630-3843-4f56-a425-88077c59398e', 'b393833d-d8e4-4081-9ef8-e5faa9db9d28', 'http://www.cas.coop', '111111'),
	('87680568-0469-40c4-9a54-53d560681118', '3ec506af-362d-47c3-ada1-25956a686235', 'www.smmacademy.org', '111111');


--
-- Data for Name: establishment_geography; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_geography (establishment_geography_id, establishment_id, local_authority_id, government_office_region_id, district_administrative_id, administrative_ward_id, parliamentary_constituency_id, lsoa_id, msoa_id, urban_rural_id) VALUES
	('5d06f90a-4f40-47fc-8749-dc643987a16c', 'b393833d-d8e4-4081-9ef8-e5faa9db9d28', '3332ea83-bcbe-48d1-970d-a3650d9bcf10', '7ca695f4-dfcd-4f78-bdaf-17861eafbf97', '6ef1f577-d0bc-4698-951c-f202f9eaada6', 'e73f0fc2-114a-4772-a84e-5363b02ba34b', '714fb4a2-4d2e-4875-9853-1d7d6696559e', 'cec78739-d3a7-4831-9934-8dec5c5bdcd1', '5ed6445f-c41a-4778-9a5c-55ba74a2155b', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('abb3dd12-8c19-4040-837f-06e845519146', '3ec506af-362d-47c3-ada1-25956a686235', '3574e75c-8870-449a-82e7-1b083e2efc42', '1375841f-e6ba-4cda-9fac-753ff9df93a2', '9a5cfcfa-3605-4253-8e1c-fc081510a4ea', '9a2f2163-03c6-45b8-84e0-b34cc7a3450c', '6c7acd08-ad7f-406e-85e4-0bade3e57de6', '05aa5060-26b4-4edf-ad40-5e4640903d5a', '0d87ce8f-019d-4403-9527-975bbabd10e1', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('8c32d059-0ab4-41d5-8353-446e1c2e1301', '728659aa-4d06-4685-9d16-c2c38504c618', '0a78f87e-d71b-44c3-b598-2cc2b8038e95', '489dce3e-58d7-44c5-b9ef-2f7d7cbdb592', 'c8efb411-9c6d-492e-af1e-624ed743712f', 'f22dfd05-c647-403a-bebd-69fb3a62cca6', '93b33a64-95d1-4d7f-9142-4acc73221e9a', '22d38930-6da2-4b70-9bca-6208cbb43ba5', 'cddc19f9-9b91-4e98-a4c8-656753fd673c', 'fba31373-6bf1-4ad2-9d63-a2c783849aad');


--
-- Data for Name: establishment_lifecycle; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_lifecycle (establishment_lifecycle_id, establishment_id, establishment_status_id, open_date, close_date, reason_establishment_opened_id, reason_establishment_closed_id, last_changed_date) VALUES
	('bb7a3b5d-3dea-46a0-b0af-59f585eac77e', 'b393833d-d8e4-4081-9ef8-e5faa9db9d28', 1, '2010-09-01', NULL, 2, NULL, '2026-06-23'),
	('d09abe45-f660-4c5a-9318-a8d854d2c3bc', '3ec506af-362d-47c3-ada1-25956a686235', 1, '2007-09-01', NULL, 2, NULL, '2026-06-23'),
	('086dd33d-f4d3-4660-b25a-cc612fc5afc3', '728659aa-4d06-4685-9d16-c2c38504c618', 2, '2009-09-01', '2016-02-29', 2, 12, '2018-07-02');


--
-- Data for Name: establishment_party_role; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_party_role (establishment_party_role_id, establishment_party_role_type_id, legal_entity_id, person_id, start_date, end_date) VALUES
	('28cd9930-f0dd-4e8b-ba68-8754fb7c3a0b', 1, '55f4b685-633e-443e-acc0-34a0a4c8d4db', NULL, NULL, NULL),
	('0058ad96-a108-4a8d-9d21-1a5d2822b679', 4, '55f4b685-633e-443e-acc0-34a0a4c8d4db', NULL, NULL, NULL),
	('2b5c7046-359b-4684-86e6-335a3e70e6a0', 1, 'ce981241-d054-40fe-a0b5-96115c7400db', NULL, NULL, NULL),
	('e612dc20-b957-482a-aada-4aa61fbe9b72', 4, 'd4ede9dd-7b90-493b-b401-1a534fa704e4', NULL, NULL, NULL),
	('a70d4424-33e2-4c07-9604-81402959552e', 1, 'b47a870c-ef45-4431-a306-23854718a4bb', NULL, NULL, '2016-02-29');


--
-- Data for Name: establishment_responsibility; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_responsibility (establishment_responsibility_id, establishment_id, legal_entity_id, person_id, responsibility_type_id, academy_trust_type_id, start_date, end_date, is_current) VALUES
	('2e5d7ac9-182e-4aae-b96b-3f9dbf6bf386', 'b393833d-d8e4-4081-9ef8-e5faa9db9d28', '55f4b685-633e-443e-acc0-34a0a4c8d4db', NULL, 1, 2, '2015-07-01', NULL, true),
	('ee649ca7-a369-4911-b90d-248cc8840c42', 'b393833d-d8e4-4081-9ef8-e5faa9db9d28', '55f4b685-633e-443e-acc0-34a0a4c8d4db', NULL, 1, 1, '2010-09-01', NULL, false),
	('f3b2d85f-c838-4638-b160-fcc8da84e0ab', 'b393833d-d8e4-4081-9ef8-e5faa9db9d28', '55f4b685-633e-443e-acc0-34a0a4c8d4db', NULL, 3, NULL, '2010-09-01', NULL, true),
	('ea5a90d8-156d-4b1b-827b-5ddd5c6e62a2', '3ec506af-362d-47c3-ada1-25956a686235', 'ce981241-d054-40fe-a0b5-96115c7400db', NULL, 1, 2, '2021-10-04', NULL, true),
	('3419fff6-8dd5-491a-8bc9-e32483baad0e', '3ec506af-362d-47c3-ada1-25956a686235', 'ce981241-d054-40fe-a0b5-96115c7400db', NULL, 1, 1, '2007-09-01', NULL, false),
	('1762713c-2f68-4004-859b-7db9795b9eb7', '3ec506af-362d-47c3-ada1-25956a686235', 'd4ede9dd-7b90-493b-b401-1a534fa704e4', NULL, 3, NULL, '2007-09-01', NULL, true),
	('b8b39526-92d3-4106-9104-bf01ebee3d3d', '728659aa-4d06-4685-9d16-c2c38504c618', 'b47a870c-ef45-4431-a306-23854718a4bb', NULL, 1, 2, '2009-09-01', '2016-02-29', false);


--
-- Data for Name: site; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.site (site_id, address_id, site_name, uprn) VALUES
	('6a1048bb-5b6a-4fba-8e72-75b1b272c24e', '06883ef6-2a21-4aff-a0ba-12f2f4d17ab3', NULL, 3455015782),
	('f5b66e30-fe46-4f78-93b6-e07ec105a6a8', 'b8556543-8018-4ae7-bebb-be901809035d', NULL, 5300060053),
	('80892023-2a35-4f7e-9672-43314e5ff33c', '6a967154-9263-4b71-abf2-27cc859ba101', NULL, 10090666596);


--
-- Data for Name: establishment_to_site; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_to_site (establishment_id, site_id, is_main_site) VALUES
	('b393833d-d8e4-4081-9ef8-e5faa9db9d28', '6a1048bb-5b6a-4fba-8e72-75b1b272c24e', true),
	('3ec506af-362d-47c3-ada1-25956a686235', 'f5b66e30-fe46-4f78-93b6-e07ec105a6a8', true),
	('728659aa-4d06-4685-9d16-c2c38504c618', '80892023-2a35-4f7e-9672-43314e5ff33c', true);


--
-- Data for Name: organisation_group; Type: TABLE DATA; Schema: establishment; Owner: -
--



--
-- Data for Name: group_identifier; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.group_identifier (group_identifier_id, establishment_party_role_id, organisation_group_id, group_identifier_type_id, identifier_issuer_id, value, is_current) VALUES
	('f718e205-5f3d-4802-970b-3c3bfbb1c777', '28cd9930-f0dd-4e8b-ba68-8754fb7c3a0b', NULL, 1, 1, '2777', true),
	('71ad00c5-294c-4397-a5e3-8bdbd2a25eda', '28cd9930-f0dd-4e8b-ba68-8754fb7c3a0b', NULL, 2, 1, 'TR00567', true),
	('3689ab1f-f1a2-4007-90c7-907cc167a16d', '28cd9930-f0dd-4e8b-ba68-8754fb7c3a0b', NULL, 1, 1, '2779', false),
	('f04707b9-9b14-46b5-bf99-d6e93cd272fc', '28cd9930-f0dd-4e8b-ba68-8754fb7c3a0b', NULL, 2, 1, 'TR00569', false),
	('979504ef-109d-4959-8294-aaf3a424f857', '0058ad96-a108-4a8d-9d21-1a5d2822b679', NULL, 1, 1, '4949', true),
	('f7afdc4d-f236-4178-8dd0-c797d36bee22', '0058ad96-a108-4a8d-9d21-1a5d2822b679', NULL, 2, 1, 'SP00125', true),
	('2e353aa0-0033-496a-b787-057de675307a', '2b5c7046-359b-4684-86e6-335a3e70e6a0', NULL, 1, 1, '23869', true),
	('fa51a3de-b5b1-4962-b077-ffafe5fc494a', '2b5c7046-359b-4684-86e6-335a3e70e6a0', NULL, 2, 1, 'TR02103', true),
	('f8e714cd-47e3-4406-9f74-65aafa9016ce', '2b5c7046-359b-4684-86e6-335a3e70e6a0', NULL, 1, 1, '4737', false),
	('c23d5c88-702a-46b2-b783-856a4d5efe37', 'e612dc20-b957-482a-aada-4aa61fbe9b72', NULL, 1, 1, '2914', true),
	('cd753595-333d-4f02-99ac-1a1ab3505a7d', 'e612dc20-b957-482a-aada-4aa61fbe9b72', NULL, 2, 1, 'SP00172', true),
	('2a6a8c34-a49e-4cd8-a016-ce9296d8c61d', 'a70d4424-33e2-4c07-9604-81402959552e', NULL, 1, 1, '3839', false),
	('a3676a99-a0ef-49f1-bd68-1ca7cca1636c', 'a70d4424-33e2-4c07-9604-81402959552e', NULL, 2, 1, 'TR01385', false);


--
-- Data for Name: organisation_group_member; Type: TABLE DATA; Schema: establishment; Owner: -
--



--
-- Data for Name: organisation_identifier; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.organisation_identifier (organisation_identifier_id, legal_entity_id, organisation_identifier_type_id, value, is_current) VALUES
	('c62771db-7543-45ab-b1a3-9dbffeb84ba8', '55f4b685-633e-443e-acc0-34a0a4c8d4db', 1, '07747126', true),
	('edf9a71d-2a3f-4bcf-bf05-b066a9d04665', '55f4b685-633e-443e-acc0-34a0a4c8d4db', 2, '10059286', true),
	('11265fa5-f6f5-4d82-b1d0-8ca911c062eb', 'ce981241-d054-40fe-a0b5-96115c7400db', 1, '05412502', true),
	('6e6acfd8-d564-49dc-834c-b78434905d07', 'ce981241-d054-40fe-a0b5-96115c7400db', 2, '10058191', true),
	('8f78d8ac-63b5-47c2-8f6f-e03b69e22e16', 'b47a870c-ef45-4431-a306-23854718a4bb', 1, '06888873', true);


--
-- Data for Name: specialist_provision; Type: TABLE DATA; Schema: establishment; Owner: -
--



--
-- Data for Name: resourced_provision; Type: TABLE DATA; Schema: establishment; Owner: -
--



--
-- Data for Name: sen_unit_provision; Type: TABLE DATA; Schema: establishment; Owner: -
--



--
-- Data for Name: statutory_age_range; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.statutory_age_range (statutory_age_range_id, education_admissions_and_provision_id, lower_statutory_age, upper_statutory_age) VALUES
	('8681c8b1-77dc-4abf-9e8d-9d5ea9491fda', 'e1db4be0-0f37-46df-924f-7472d526edeb', 11, 16),
	('2ce00a04-9990-4f8d-8e45-c69b15417857', 'f995da2b-0be0-427f-a04e-a62e5dbd24c5', 4, 19),
	('51ebc75d-9abf-4b0b-96bc-06a4495247a1', '03831c3c-9a2e-4e91-85f1-600108f0984d', 11, 19);


--
-- PostgreSQL database dump complete
--

\unrestrict G75ylQYF7TCieD1lShC8yRyLzXfZShrWpQxAK3qlvDkHfdiLmwleu0BuFnwMHzg

