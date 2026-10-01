--
-- PostgreSQL database dump
--

\restrict 0uS6MgX1WGwv19AgosPTTTCRFKNd1OufyAMf2G57DceN9wBoce7VGZPG3q7Kr2S

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
	('f321b395-ad81-4d1f-af49-1b675cc8d635', 'THE CO-OPERATIVE ACADEMIES TRUST', NULL, NULL, '2011-08-19', NULL),
	('eb2dff29-1480-4dd9-9cf5-00623d72c8aa', 'HIVE EDUCATION TRUST', NULL, NULL, '2005-04-04', NULL),
	('91cd1c7c-7048-48c5-9263-60359880687b', 'Diocese of London', NULL, NULL, NULL, NULL);


--
-- Data for Name: academy_trust_classification; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.academy_trust_classification (academy_trust_classification_id, legal_entity_id, academy_trust_type_id, start_date, end_date, is_current) VALUES
	('b154099a-9a6a-4caa-8320-516ac0c3cd48', 'f321b395-ad81-4d1f-af49-1b675cc8d635', 2, NULL, NULL, true),
	('5c9352bd-bf57-4cc8-b23d-07d47ce56a12', 'f321b395-ad81-4d1f-af49-1b675cc8d635', 1, NULL, NULL, false),
	('74d65a19-d7ea-41cd-a513-daf391d414fb', 'eb2dff29-1480-4dd9-9cf5-00623d72c8aa', 2, NULL, NULL, true),
	('64274bba-8885-4c18-bcd0-44053bfe197a', 'eb2dff29-1480-4dd9-9cf5-00623d72c8aa', 1, NULL, NULL, false);


--
-- Data for Name: address; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.address (address_id, address_line_1, address_line_2, address_line_3, town, county, postcode) VALUES
	('2823583b-7151-414d-b586-ed93d4ab116e', 'obfuscated', NULL, 'obfuscated', 'obfuscated', '032', 'ST6 4LD'),
	('e00463e7-9084-4f4e-b387-120d656a00ff', 'obfuscated', 'Islington', NULL, 'obfuscated', '099', 'N7 8PG');


--
-- Data for Name: establishment; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment (establishment_id, urn, ukprn, establishment_number, name, establishment_type_id, education_phase_id) VALUES
	('fe5d7077-116b-44dc-bd51-aad3e54a03ee', 136102, 10030216, 6905, 'The Co-Operative Academy of Stoke-On-Trent', 4, 5),
	('02d917f5-edf6-4e72-96a1-c09680395c72', 134314, 10024207, 6905, 'St Mary Magdalene Academy', 4,6);


--
-- Data for Name: capacity_and_pupil_measures; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.capacity_and_pupil_measures (capacity_and_pupil_measures_id, establishment_id, school_capacity, pupil_count, free_school_meal_measure, census_date) VALUES
	('d7182295-b99a-4ec8-89b7-98639bf1bd18', 'fe5d7077-116b-44dc-bd51-aad3e54a03ee', 1050, 1300, 735, NULL),
	('394b9bc3-5c08-4018-88af-d8ee99b5f0b8', '02d917f5-edf6-4e72-96a1-c09680395c72', 1310, 1561, 465, NULL);


--
-- Data for Name: education_admissions_and_provision; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.education_admissions_and_provision (education_admissions_and_provision_id, establishment_id, gender_of_entry_type_id, admissions_policy_id, boarding_provision_id, nursery_provision_id, sixth_form_provision_id) VALUES
	('d5f19928-49d7-442c-ba21-2f9c9e16b928', 'fe5d7077-116b-44dc-bd51-aad3e54a03ee', 1, 1, 1, 3, 3),
	('19c54e8c-d351-4b2a-906f-6448c89226b6', '02d917f5-edf6-4e72-96a1-c09680395c72', 1, 1, 1, 2, 1);


--
-- Data for Name: establishment_contact; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_contact (establishment_contact_id, establishment_id, website, telephone_number) VALUES
	('1a023103-4c14-4b35-a719-c3befd89f0a3', 'fe5d7077-116b-44dc-bd51-aad3e54a03ee', 'http://www.cas.coop', '111111'),
	('ebbded62-4b53-4d42-a826-9c71427da36a', '02d917f5-edf6-4e72-96a1-c09680395c72', 'www.smmacademy.org', '111111');


--
-- Data for Name: establishment_geography; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_geography (establishment_geography_id, establishment_id, local_authority_id, government_office_region_id, district_administrative_id, administrative_ward_id, parliamentary_constituency_id, lsoa_id, msoa_id, urban_rural_id) VALUES
	('6d5f0c5a-c39b-4509-b2f8-59d1e9f7a336', 'fe5d7077-116b-44dc-bd51-aad3e54a03ee', '3332ea83-bcbe-48d1-970d-a3650d9bcf10', '7ca695f4-dfcd-4f78-bdaf-17861eafbf97', '6ef1f577-d0bc-4698-951c-f202f9eaada6', 'e73f0fc2-114a-4772-a84e-5363b02ba34b', '714fb4a2-4d2e-4875-9853-1d7d6696559e', 'cec78739-d3a7-4831-9934-8dec5c5bdcd1', '5ed6445f-c41a-4778-9a5c-55ba74a2155b', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('d1e8ce79-e148-4e71-ad40-af0d445fe408', '02d917f5-edf6-4e72-96a1-c09680395c72', '3574e75c-8870-449a-82e7-1b083e2efc42', '1375841f-e6ba-4cda-9fac-753ff9df93a2', '9a5cfcfa-3605-4253-8e1c-fc081510a4ea', '9a2f2163-03c6-45b8-84e0-b34cc7a3450c', '6c7acd08-ad7f-406e-85e4-0bade3e57de6', '05aa5060-26b4-4edf-ad40-5e4640903d5a', '0d87ce8f-019d-4403-9527-975bbabd10e1', '8826f875-fade-4b0b-a4b1-f8536505ecd1');


--
-- Data for Name: establishment_lifecycle; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_lifecycle (establishment_lifecycle_id, establishment_id, establishment_status_id, open_date, close_date, reason_establishment_opened_id, reason_establishment_closed_id, last_changed_date) VALUES
	('cc7418e0-5583-4d07-b33e-eef3a6d2a689', 'fe5d7077-116b-44dc-bd51-aad3e54a03ee', 1, '2010-09-01', NULL, 2, NULL, '2026-06-23'),
	('a398a26a-29ea-4b78-98b5-b9ab53e3bc1a', '02d917f5-edf6-4e72-96a1-c09680395c72', 1, '2007-09-01', NULL, 2, NULL, '2026-06-23');


--
-- Data for Name: establishment_party_role; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_party_role (establishment_party_role_id, establishment_party_role_type_id, legal_entity_id, person_id, start_date, end_date) VALUES
	('f34b48f4-0210-44c2-a313-74586ede811a', 1, 'f321b395-ad81-4d1f-af49-1b675cc8d635', NULL, NULL, NULL),
	('d1ad4a5a-5824-4011-bf02-25ebcee020e7', 4, 'f321b395-ad81-4d1f-af49-1b675cc8d635', NULL, NULL, NULL),
	('a377f958-4a33-4851-9fc5-349e29872091', 1, 'eb2dff29-1480-4dd9-9cf5-00623d72c8aa', NULL, NULL, NULL),
	('0e89796f-a5fd-4b2b-8674-3d6d3796384a', 4, '91cd1c7c-7048-48c5-9263-60359880687b', NULL, NULL, NULL);


--
-- Data for Name: establishment_responsibility; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_responsibility (establishment_responsibility_id, establishment_id, legal_entity_id, person_id, responsibility_type_id, academy_trust_type_id, start_date, end_date, is_current) VALUES
	('81fafaee-c861-47fa-8cca-70801b2088cb', 'fe5d7077-116b-44dc-bd51-aad3e54a03ee', 'f321b395-ad81-4d1f-af49-1b675cc8d635', NULL, 1, 2, '2015-07-01', NULL, true),
	('df579ae4-451b-4329-b6e8-50df5a8ff40e', 'fe5d7077-116b-44dc-bd51-aad3e54a03ee', 'f321b395-ad81-4d1f-af49-1b675cc8d635', NULL, 1, 1, '2010-09-01', NULL, false),
	('24738d17-a285-484e-ac3d-c041c333354b', 'fe5d7077-116b-44dc-bd51-aad3e54a03ee', 'f321b395-ad81-4d1f-af49-1b675cc8d635', NULL, 3, NULL, '2010-09-01', NULL, true),
	('9d82949d-c7ff-4db0-ad6f-ac47f4356b67', '02d917f5-edf6-4e72-96a1-c09680395c72', 'eb2dff29-1480-4dd9-9cf5-00623d72c8aa', NULL, 1, 2, '2021-10-04', NULL, true),
	('d46d6aea-ebf7-4a4a-9db6-b3303d23d9b5', '02d917f5-edf6-4e72-96a1-c09680395c72', 'eb2dff29-1480-4dd9-9cf5-00623d72c8aa', NULL, 1, 1, '2007-09-01', NULL, false),
	('b0e4c535-4263-4732-b69b-b1e68d2b16cb', '02d917f5-edf6-4e72-96a1-c09680395c72', '91cd1c7c-7048-48c5-9263-60359880687b', NULL, 3, NULL, '2007-09-01', NULL, true);


--
-- Data for Name: site; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.site (site_id, address_id, site_name, uprn) VALUES
	('294c6e5a-b96f-46bb-acbb-eb12a158296b', '2823583b-7151-414d-b586-ed93d4ab116e', NULL, 3455015782),
	('8a1b3e70-e667-4ba5-be3b-43c7a3373628', 'e00463e7-9084-4f4e-b387-120d656a00ff', NULL, 5300060053);


--
-- Data for Name: establishment_to_site; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_to_site (establishment_id, site_id, is_main_site) VALUES
	('fe5d7077-116b-44dc-bd51-aad3e54a03ee', '294c6e5a-b96f-46bb-acbb-eb12a158296b', true),
	('02d917f5-edf6-4e72-96a1-c09680395c72', '8a1b3e70-e667-4ba5-be3b-43c7a3373628', true);


--
-- Data for Name: organisation_group; Type: TABLE DATA; Schema: establishment; Owner: -
--



--
-- Data for Name: group_identifier; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.group_identifier (group_identifier_id, establishment_party_role_id, organisation_group_id, group_identifier_type_id, identifier_issuer_id, value, is_current) VALUES
	('2cd14526-862a-4cb5-b6b5-f47a23576cac', 'f34b48f4-0210-44c2-a313-74586ede811a', NULL, 1, 1, '2777', true),
	('ab3ecb79-b141-4f58-a3c3-0b6cdc685fdd', 'f34b48f4-0210-44c2-a313-74586ede811a', NULL, 2, 1, 'TR00567', true),
	('38e157a0-2956-4cd3-a762-1cde959c9a25', 'f34b48f4-0210-44c2-a313-74586ede811a', NULL, 1, 1, '2779', false),
	('c3fb3398-05d9-4321-bb7f-edfb476c2f47', 'f34b48f4-0210-44c2-a313-74586ede811a', NULL, 2, 1, 'TR00569', false),
	('db4b0fa8-a5ee-4096-a3d6-249eed74217a', 'd1ad4a5a-5824-4011-bf02-25ebcee020e7', NULL, 1, 1, '4949', true),
	('df1d2acb-eccd-4b13-b057-0e8b99156e83', 'd1ad4a5a-5824-4011-bf02-25ebcee020e7', NULL, 2, 1, 'SP00125', true),
	('4cea8366-c2c6-4a62-b8a5-e71043ab311f', 'a377f958-4a33-4851-9fc5-349e29872091', NULL, 1, 1, '23869', true),
	('a5f00dad-ce4a-49d6-a32d-d130ccfeab14', 'a377f958-4a33-4851-9fc5-349e29872091', NULL, 2, 1, 'TR02103', true),
	('4e1a6cb2-3389-497e-b582-a38cb4cf23a9', 'a377f958-4a33-4851-9fc5-349e29872091', NULL, 1, 1, '4737', false),
	('85a369b7-7556-4018-98b6-3f671e4ed6ea', '0e89796f-a5fd-4b2b-8674-3d6d3796384a', NULL, 1, 1, '2914', true),
	('37767b22-5f29-4598-9314-16545a854dec', '0e89796f-a5fd-4b2b-8674-3d6d3796384a', NULL, 2, 1, 'SP00172', true);


--
-- Data for Name: organisation_group_member; Type: TABLE DATA; Schema: establishment; Owner: -
--



--
-- Data for Name: organisation_identifier; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.organisation_identifier (organisation_identifier_id, legal_entity_id, organisation_identifier_type_id, value, is_current) VALUES
	('bc66eac4-c784-4102-9a07-21b05f27dbc1', 'f321b395-ad81-4d1f-af49-1b675cc8d635', 1, '07747126', true),
	('eb1250dc-0eb1-45ec-8f24-561eba27fd4e', 'f321b395-ad81-4d1f-af49-1b675cc8d635', 2, '10059286', true),
	('0dfde1fb-0dda-40a3-abe4-8331d6574dcf', 'eb2dff29-1480-4dd9-9cf5-00623d72c8aa', 1, '05412502', true),
	('90faa0d4-dad2-4751-b238-40b4bd41a89b', 'eb2dff29-1480-4dd9-9cf5-00623d72c8aa', 2, '10058191', true);


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
	('ad1f9fd2-31c8-4c65-b642-0fc665167e46', 'd5f19928-49d7-442c-ba21-2f9c9e16b928', 11, 16),
	('eb489641-c361-42bd-a7b1-618b0bbf449e', '19c54e8c-d351-4b2a-906f-6448c89226b6', 4, 19);


--
-- PostgreSQL database dump complete
--

\unrestrict 0uS6MgX1WGwv19AgosPTTTCRFKNd1OufyAMf2G57DceN9wBoce7VGZPG3q7Kr2S

