--
-- PostgreSQL database dump
--

\restrict 9BYWyPWlshdjwAT9VqyVP9tyaUZ13kfSaqvX6PfRVIPDeldUAUwmrbHHzaZLro3

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
	('b8acf386-983b-4b31-8280-49ade48fdc17', 'THE CO-OPERATIVE ACADEMIES TRUST', NULL, NULL, '2011-08-19', NULL),
	('5d0ae101-79e8-4fbb-a027-79e75b109c70', 'HIVE EDUCATION TRUST', NULL, NULL, '2005-04-04', NULL),
	('c40fe86e-0930-4731-bf46-55cf70d5e6ab', 'Diocese of London', NULL, NULL, NULL, NULL);


--
-- Data for Name: academy_trust_classification; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.academy_trust_classification (academy_trust_classification_id, legal_entity_id, academy_trust_type_id, start_date, end_date, is_current) VALUES
	('dbdaa589-2bd6-45c7-96be-b100fc40559f', 'b8acf386-983b-4b31-8280-49ade48fdc17', 2, NULL, NULL, true),
	('4bb328e7-84c3-465d-a5d9-4d865e77b44e', 'b8acf386-983b-4b31-8280-49ade48fdc17', 1, NULL, NULL, false),
	('a034401f-d810-41fe-9433-4adf4a12fd05', '5d0ae101-79e8-4fbb-a027-79e75b109c70', 2, NULL, NULL, true),
	('6f006ea5-ccd1-4340-8893-116487492b11', '5d0ae101-79e8-4fbb-a027-79e75b109c70', 1, NULL, NULL, false);


--
-- Data for Name: address; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.address (address_id, address_line_1, address_line_2, address_line_3, town, county, postcode) VALUES
	('749c8830-603c-4ba8-a596-1e6cd9187cce', 'obfuscated', NULL, 'obfuscated', 'obfuscated', '032', 'ST6 4LD'),
	('d9aa33dc-2049-47f9-9bc8-788c0bcd70f8', 'obfuscated', 'Islington', NULL, 'obfuscated', '099', 'N7 8PG');


--
-- Data for Name: establishment; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment (establishment_id, urn, ukprn, establishment_number, name, establishment_type_id, education_phase_id) VALUES
	('a68d87c7-19f0-4b49-93e6-266d7200586e', 136102, 10030216, 6905, 'The Co-Operative Academy of Stoke-On-Trent', 4, 5),
	('bbcb3a27-438e-4c84-84be-8c9c550b111d', 134314, 10024207, 6905, 'St Mary Magdalene Academy', 4, 6);


--
-- Data for Name: capacity_and_pupil_measures; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.capacity_and_pupil_measures (capacity_and_pupil_measures_id, establishment_id, school_capacity, pupil_count, free_school_meal_measure, census_date) VALUES
	('c0cea8eb-93ba-4ee6-9ec8-5ce37684ff32', 'a68d87c7-19f0-4b49-93e6-266d7200586e', 1050, 1300, 735, NULL),
	('f9de8329-d723-4364-bcfb-49f583968996', 'bbcb3a27-438e-4c84-84be-8c9c550b111d', 1310, 1561, 465, NULL);


--
-- Data for Name: education_admissions_and_provision; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.education_admissions_and_provision (education_admissions_and_provision_id, establishment_id, gender_of_entry_type_id, admissions_policy_id, boarding_provision_id, nursery_provision_id, sixth_form_provision_id) VALUES
	('debbd541-b707-4ae2-9ca3-363cf9cf57cb', 'a68d87c7-19f0-4b49-93e6-266d7200586e', 1, 1, 1, 3, 3),
	('7ae1f1b8-a653-40e6-b995-fa08d7aa56ec', 'bbcb3a27-438e-4c84-84be-8c9c550b111d', 1, 1, 1, 2, 1);


--
-- Data for Name: establishment_contact; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_contact (establishment_contact_id, establishment_id, website, telephone_number) VALUES
	('843b048a-bd0e-42ff-9bd5-3af65f389604', 'a68d87c7-19f0-4b49-93e6-266d7200586e', 'http://www.cas.coop', '111111'),
	('8094a57c-576d-40a1-918f-7c0053f3ed15', 'bbcb3a27-438e-4c84-84be-8c9c550b111d', 'www.smmacademy.org', '111111');


--
-- Data for Name: establishment_geography; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_geography (establishment_geography_id, establishment_id, local_authority_id, government_office_region_id, district_administrative_id, administrative_ward_id, parliamentary_constituency_id, lsoa_id, msoa_id, urban_rural_id) VALUES
	('57d8bfca-bdf1-4bdd-977f-cd3241e23b6a', 'a68d87c7-19f0-4b49-93e6-266d7200586e', '3332ea83-bcbe-48d1-970d-a3650d9bcf10', '7ca695f4-dfcd-4f78-bdaf-17861eafbf97', '6ef1f577-d0bc-4698-951c-f202f9eaada6', 'e73f0fc2-114a-4772-a84e-5363b02ba34b', '714fb4a2-4d2e-4875-9853-1d7d6696559e', 'cec78739-d3a7-4831-9934-8dec5c5bdcd1', '5ed6445f-c41a-4778-9a5c-55ba74a2155b', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('5b6dd4cd-a48c-408b-8089-d9f1c4b2537b', 'bbcb3a27-438e-4c84-84be-8c9c550b111d', '3574e75c-8870-449a-82e7-1b083e2efc42', '1375841f-e6ba-4cda-9fac-753ff9df93a2', '9a5cfcfa-3605-4253-8e1c-fc081510a4ea', '9a2f2163-03c6-45b8-84e0-b34cc7a3450c', '6c7acd08-ad7f-406e-85e4-0bade3e57de6', '05aa5060-26b4-4edf-ad40-5e4640903d5a', '0d87ce8f-019d-4403-9527-975bbabd10e1', '8826f875-fade-4b0b-a4b1-f8536505ecd1');


--
-- Data for Name: establishment_lifecycle; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_lifecycle (establishment_lifecycle_id, establishment_id, establishment_status_id, open_date, close_date, reason_establishment_opened_id, reason_establishment_closed_id, last_changed_date) VALUES
	('2c81738e-0d32-40d1-bbab-db2e6f9614e4', 'a68d87c7-19f0-4b49-93e6-266d7200586e', 1, '2010-09-01', NULL, 2, NULL, '2026-06-23'),
	('a452975a-b6b8-40ce-99bb-599bdab22720', 'bbcb3a27-438e-4c84-84be-8c9c550b111d', 1, '2007-09-01', NULL, 2, NULL, '2026-06-23');


--
-- Data for Name: establishment_party_role; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_party_role (establishment_party_role_id, establishment_party_role_type_id, legal_entity_id, person_id, start_date, end_date) VALUES
	('16137ac3-531b-490c-a373-80db44912966', 1, 'b8acf386-983b-4b31-8280-49ade48fdc17', NULL, NULL, NULL),
	('9c2a6778-4ee9-4e3c-bfc4-f0090d204a45', 4, 'b8acf386-983b-4b31-8280-49ade48fdc17', NULL, NULL, NULL),
	('fd3ad2c8-e76c-4c57-bf77-63a982d7720d', 1, '5d0ae101-79e8-4fbb-a027-79e75b109c70', NULL, NULL, NULL),
	('b4afc2d2-71f5-42d5-b1f1-60f28aebfdec', 4, 'c40fe86e-0930-4731-bf46-55cf70d5e6ab', NULL, NULL, NULL);


--
-- Data for Name: establishment_responsibility; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_responsibility (establishment_responsibility_id, establishment_id, legal_entity_id, person_id, responsibility_type_id, academy_trust_type_id, start_date, end_date, is_current) VALUES
	('79cb4999-c44b-4d35-890f-a93f4079348e', 'a68d87c7-19f0-4b49-93e6-266d7200586e', 'b8acf386-983b-4b31-8280-49ade48fdc17', NULL, 1, 2, '2015-07-01', NULL, true),
	('7f2f8afc-7585-4658-bbf5-80cf40ec6a96', 'a68d87c7-19f0-4b49-93e6-266d7200586e', 'b8acf386-983b-4b31-8280-49ade48fdc17', NULL, 1, 1, '2010-09-01', NULL, false),
	('7a913d8e-b5da-4d85-ba10-92984079d233', 'a68d87c7-19f0-4b49-93e6-266d7200586e', 'b8acf386-983b-4b31-8280-49ade48fdc17', NULL, 3, NULL, '2010-09-01', NULL, true),
	('5edbff7d-748a-448b-a3bb-25f8ac881d32', 'bbcb3a27-438e-4c84-84be-8c9c550b111d', '5d0ae101-79e8-4fbb-a027-79e75b109c70', NULL, 1, 2, '2021-10-04', NULL, true),
	('a5a13358-e996-40b5-95b9-3b5454906a6d', 'bbcb3a27-438e-4c84-84be-8c9c550b111d', '5d0ae101-79e8-4fbb-a027-79e75b109c70', NULL, 1, 1, '2007-09-01', NULL, false),
	('dd90b993-72f4-4664-9e18-99f1495134f1', 'bbcb3a27-438e-4c84-84be-8c9c550b111d', 'c40fe86e-0930-4731-bf46-55cf70d5e6ab', NULL, 3, NULL, '2007-09-01', NULL, true);


--
-- Data for Name: site; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.site (site_id, address_id, site_name, uprn) VALUES
	('ba1b55e7-1540-4596-b715-4e255c55d11e', '749c8830-603c-4ba8-a596-1e6cd9187cce', NULL, 3455015782),
	('f9f2c4c2-00b6-4aff-8eb9-4acda275818b', 'd9aa33dc-2049-47f9-9bc8-788c0bcd70f8', NULL, 5300060053);


--
-- Data for Name: establishment_to_site; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_to_site (establishment_id, site_id, is_main_site) VALUES
	('a68d87c7-19f0-4b49-93e6-266d7200586e', 'ba1b55e7-1540-4596-b715-4e255c55d11e', true),
	('bbcb3a27-438e-4c84-84be-8c9c550b111d', 'f9f2c4c2-00b6-4aff-8eb9-4acda275818b', true);


--
-- Data for Name: organisation_group; Type: TABLE DATA; Schema: establishment; Owner: -
--



--
-- Data for Name: group_identifier; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.group_identifier (group_identifier_id, establishment_party_role_id, organisation_group_id, group_identifier_type_id, identifier_issuer_id, value, is_current) VALUES
	('8f691d24-9b90-4203-9000-d97033d2e0bd', '16137ac3-531b-490c-a373-80db44912966', NULL, 1, 1, '2777', true),
	('fc42806b-e99d-48e1-a843-1a96df64cf78', '16137ac3-531b-490c-a373-80db44912966', NULL, 2, 1, 'TR00567', true),
	('6741e078-956f-4d41-8417-70129d5981ca', '16137ac3-531b-490c-a373-80db44912966', NULL, 1, 1, '2779', false),
	('b32b2d24-70fc-4367-8be7-886ff4cc7754', '16137ac3-531b-490c-a373-80db44912966', NULL, 2, 1, 'TR00569', false),
	('8b355461-31d7-4c8f-b01e-5c8b6baae417', '9c2a6778-4ee9-4e3c-bfc4-f0090d204a45', NULL, 1, 1, '4949', true),
	('c10e70e8-45fc-4471-b7ee-cfc41b9333c0', '9c2a6778-4ee9-4e3c-bfc4-f0090d204a45', NULL, 2, 1, 'SP00125', true),
	('8553a06b-82bf-4390-a192-09ecbad80174', 'fd3ad2c8-e76c-4c57-bf77-63a982d7720d', NULL, 1, 1, '23869', true),
	('ec2375de-1162-4f45-99e3-fbb029f9b447', 'fd3ad2c8-e76c-4c57-bf77-63a982d7720d', NULL, 2, 1, 'TR02103', true),
	('4d5bf259-40c8-4ee1-bcaa-802ff2c7942d', 'fd3ad2c8-e76c-4c57-bf77-63a982d7720d', NULL, 1, 1, '4737', false),
	('3c268c38-c9d0-48b9-93f6-dba2d3197a56', 'b4afc2d2-71f5-42d5-b1f1-60f28aebfdec', NULL, 1, 1, '2914', true),
	('ec02a7c6-1cb8-405b-906c-f3ef754b7120', 'b4afc2d2-71f5-42d5-b1f1-60f28aebfdec', NULL, 2, 1, 'SP00172', true);


--
-- Data for Name: organisation_group_member; Type: TABLE DATA; Schema: establishment; Owner: -
--



--
-- Data for Name: organisation_identifier; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.organisation_identifier (organisation_identifier_id, legal_entity_id, organisation_identifier_type_id, value, is_current) VALUES
	('96f081ff-5c6c-4e10-9ca1-19f8ccec0f12', 'b8acf386-983b-4b31-8280-49ade48fdc17', 1, '07747126', true),
	('dec9d1b2-e10a-45f5-8c36-461fc0963c65', 'b8acf386-983b-4b31-8280-49ade48fdc17', 2, '10059286', true),
	('6d95a761-ea14-4d9c-b8de-7543fd98eaa9', '5d0ae101-79e8-4fbb-a027-79e75b109c70', 1, '05412502', true),
	('b93cc26a-1c26-4a19-8ba6-f6a6119f8786', '5d0ae101-79e8-4fbb-a027-79e75b109c70', 2, '10058191', true);


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
	('3e86cff0-631a-4ad6-bd1b-35a9ca7eb07c', 'debbd541-b707-4ae2-9ca3-363cf9cf57cb', 11, 16),
	('72608cf6-90f5-489c-b278-6a69433d839d', '7ae1f1b8-a653-40e6-b995-fa08d7aa56ec', 4, 19);


--
-- PostgreSQL database dump complete
--

\unrestrict 9BYWyPWlshdjwAT9VqyVP9tyaUZ13kfSaqvX6PfRVIPDeldUAUwmrbHHzaZLro3

