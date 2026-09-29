--
-- PostgreSQL database dump
--

\restrict sxcHHaeVenYqc3ycEAHenxL7d3OALuh7JGRLaAlrv2xkjJ6DmYa5dcLPQKDbmGA

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

INSERT INTO establishment.legal_entity (legal_entity_id, name, incorporation_date, dissolution_date) VALUES
	('a8d9fbcf-7e26-4b50-a432-397cabb1b651', 'MARCH 2016 LIMITED', '2009-04-27', NULL);


--
-- Data for Name: establishment_party_role; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_party_role (establishment_party_role_id, establishment_party_role_type_id, legal_entity_id, person_id, start_date, end_date, end_date_basis, observed_date) VALUES
	('a35080a0-2845-4212-9822-ada79ad943f6', 1, 'a8d9fbcf-7e26-4b50-a432-397cabb1b651', NULL, NULL, '2016-02-29', 'evidenced', NULL);


--
-- Data for Name: academy_trust_classification; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.academy_trust_classification (academy_trust_classification_id, establishment_party_role_id, academy_trust_type_id, start_date, end_date) VALUES
	('ce0f6e9c-f40c-4098-b3af-22ba777d449f', 'a35080a0-2845-4212-9822-ada79ad943f6', 2, NULL, '2016-02-29');


--
-- Data for Name: address; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.address (address_id, address_line_1, address_line_2, address_line_3, town, county, postcode) VALUES
	('1d0649d5-3e8b-49fa-8ba1-36f55b8c2519', 'obfuscated', NULL, NULL, 'obfuscated', '099', 'NW1 3EX'),
	('660f2d6f-c4f7-4865-825d-7a57192726cb', 'obfuscated', NULL, NULL, 'obfuscated', '019', 'WN7 3PQ'),
	('f7da9aec-c659-460a-aeb9-bf787e47810e', 'obfuscated', NULL, 'obfuscated', 'obfuscated', '032', 'ST6 4LD'),
	('5b8f48a7-83ba-4b30-a4e7-8b7730c5658f', 'obfuscated', 'Blackley', NULL, 'obfuscated', '099', 'M9 7SS');


--
-- Data for Name: establishment; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment (establishment_id, urn, ukprn, establishment_number, name, establishment_type_id, education_phase_id) VALUES
	('2d0d064a-8d54-48b3-9451-008f68bccb10', 100018, 10069172, 2436, 'Netley Primary School & Centre for Autism', 1, 2),
	('30ba075d-d376-46a3-94ef-d0db8bab5d70', 106431, 10072615, 2053, 'Gilded Hollins Community School', 1, 2),
	('5a25ba22-65ce-4106-b82a-2d709672d273', 136102, 10030216, 6905, 'The Co-Operative Academy of Stoke-On-Trent', 4, 5),
	('cfcf18ac-39d2-436f-9c3a-5e7d3e810851', 135905, NULL, 6910, 'Manchester Creative and Media Academy', 4, 5);


--
-- Data for Name: capacity_and_pupil_measures; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.capacity_and_pupil_measures (capacity_and_pupil_measures_id, establishment_id, school_capacity, pupil_count, free_school_meal_measure, census_date) VALUES
	('2c789481-9609-474a-8710-f443b614f407', '2d0d064a-8d54-48b3-9451-008f68bccb10', 65801, 383, 224, NULL),
	('7f92ca72-d4b5-4145-8a37-6d63b81d1735', '30ba075d-d376-46a3-94ef-d0db8bab5d70', 22286, 209, 15, NULL),
	('eea1928f-011f-482d-8278-bcc65590949b', '5a25ba22-65ce-4106-b82a-2d709672d273', 1050, 1300, 735, NULL),
	('6f22ec55-c99f-48be-a511-48b419bcda95', 'cfcf18ac-39d2-436f-9c3a-5e7d3e810851', 660, NULL, NULL, NULL);


--
-- Data for Name: education_admissions_and_provision; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.education_admissions_and_provision (education_admissions_and_provision_id, establishment_id, gender_of_entry_type_id, admissions_policy_id, boarding_provision_id, nursery_provision_id, sixth_form_provision_id) VALUES
	('06266efc-157c-4a85-ad93-c31dbbd8a513', '2d0d064a-8d54-48b3-9451-008f68bccb10', 1, 3, 1, 1, 2),
	('fd47dd8f-5f78-4f2a-9fce-df218efe1711', '30ba075d-d376-46a3-94ef-d0db8bab5d70', 1, 3, 1, 2, 2),
	('e8bfde1f-4dfc-4918-b71b-c62430cf4cfb', '5a25ba22-65ce-4106-b82a-2d709672d273', 1, 1, 1, 3, 3),
	('c48ccba2-c3d9-478b-9cf1-83e25ee2d77a', 'cfcf18ac-39d2-436f-9c3a-5e7d3e810851', 1, 1, 1, 3, 1);


--
-- Data for Name: establishment_contact; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_contact (establishment_contact_id, establishment_id, website, telephone_number) VALUES
	('98941623-73a0-43f6-8e0b-9be607420447', '2d0d064a-8d54-48b3-9451-008f68bccb10', 'www.netley.camden.sch.uk/', '111111'),
	('581e58d4-e90c-4355-a9de-721081e9f12f', '30ba075d-d376-46a3-94ef-d0db8bab5d70', 'www.gildedhollins.wigan.sch.uk/', '111111'),
	('1e9bc840-f48c-4fc2-9f94-83decafc41c1', '5a25ba22-65ce-4106-b82a-2d709672d273', 'http://www.cas.coop', '111111');


--
-- Data for Name: establishment_geography; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_geography (establishment_geography_id, establishment_id, local_authority_id, government_office_region_id, district_administrative_id, administrative_ward_id, parliamentary_constituency_id, lsoa_id, msoa_id, urban_rural_id) VALUES
	('4ad71b7f-2e59-4686-b59f-58107fce5895', '2d0d064a-8d54-48b3-9451-008f68bccb10', '0956c9af-2de2-4dea-94ed-b5c432eae45f', '1375841f-e6ba-4cda-9fac-753ff9df93a2', 'f2665403-6621-493d-8a2d-8de9ae1f1c4a', '2aebb958-956d-4800-a776-00aac3556316', '90dee41f-c934-4b2d-9d52-b42e83fdfe88', '94fb01a9-81ec-4a90-88a6-4ad2a8db4ba9', '4cdb54e5-d81b-45d9-b218-65030aab6d87', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('c5e132c7-8604-490d-bcc9-f8eb22c13b92', '30ba075d-d376-46a3-94ef-d0db8bab5d70', '2601da0a-6f35-4c15-984e-f4482d1df384', '489dce3e-58d7-44c5-b9ef-2f7d7cbdb592', '412eea43-d307-464e-a929-62cfd4b5028d', '43acd11d-82cc-4391-8965-d45a61e5cd71', '2a9b46ea-4d43-474f-acbf-05444acfa1d1', '9cc4ab4f-4e19-465d-80a4-87b97b425244', '136005b3-68ff-4fa7-b439-2b4a1d626b24', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('e5b7d5c1-e11d-46f6-9ffd-83277896bd04', '5a25ba22-65ce-4106-b82a-2d709672d273', '3332ea83-bcbe-48d1-970d-a3650d9bcf10', '7ca695f4-dfcd-4f78-bdaf-17861eafbf97', '6ef1f577-d0bc-4698-951c-f202f9eaada6', 'e73f0fc2-114a-4772-a84e-5363b02ba34b', '714fb4a2-4d2e-4875-9853-1d7d6696559e', 'cec78739-d3a7-4831-9934-8dec5c5bdcd1', '5ed6445f-c41a-4778-9a5c-55ba74a2155b', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('2d7a8746-2590-4b11-8b9c-3ead8eb5a146', 'cfcf18ac-39d2-436f-9c3a-5e7d3e810851', '0a78f87e-d71b-44c3-b598-2cc2b8038e95', '489dce3e-58d7-44c5-b9ef-2f7d7cbdb592', 'c8efb411-9c6d-492e-af1e-624ed743712f', 'f22dfd05-c647-403a-bebd-69fb3a62cca6', '93b33a64-95d1-4d7f-9142-4acc73221e9a', '22d38930-6da2-4b70-9bca-6208cbb43ba5', 'cddc19f9-9b91-4e98-a4c8-656753fd673c', 'fba31373-6bf1-4ad2-9d63-a2c783849aad');


--
-- Data for Name: establishment_lifecycle; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_lifecycle (establishment_lifecycle_id, establishment_id, establishment_status_id, open_date, close_date, reason_establishment_opened_id, reason_establishment_closed_id, last_changed_date) VALUES
	('7825d761-1b39-4b09-bba6-0dbfcf1a133c', '2d0d064a-8d54-48b3-9451-008f68bccb10', 1, NULL, NULL, NULL, NULL, '2026-06-23'),
	('dd705987-a5d0-49df-ab8a-117a1f4cb724', '30ba075d-d376-46a3-94ef-d0db8bab5d70', 1, NULL, NULL, NULL, NULL, '2026-06-23'),
	('0c933f08-e68b-4646-b655-47195652d175', '5a25ba22-65ce-4106-b82a-2d709672d273', 1, '2010-09-01', NULL, 2, NULL, '2026-06-23'),
	('529ce229-d040-4c1b-9244-9c336d43f7a2', 'cfcf18ac-39d2-436f-9c3a-5e7d3e810851', 2, '2009-09-01', '2016-02-29', 2, 12, '2018-07-02');


--
-- Data for Name: establishment_responsibility; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_responsibility (establishment_responsibility_id, establishment_id, legal_entity_id, person_id, responsibility_type_id, start_date, end_date, end_date_basis, observed_date) VALUES
	('7d44d287-6a8f-40c0-8064-58d0d69b062f', 'cfcf18ac-39d2-436f-9c3a-5e7d3e810851', 'a8d9fbcf-7e26-4b50-a432-397cabb1b651', NULL, 1, '2009-09-01', '2016-02-29', 'inferred', NULL);


--
-- Data for Name: site; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.site (site_id, address_id, site_name, uprn) VALUES
	('0200d131-f656-4d54-9bb9-d916c5d92e18', '1d0649d5-3e8b-49fa-8ba1-36f55b8c2519', NULL, 5172210),
	('604db450-5774-41d0-a23f-c8cca41fd899', '660f2d6f-c4f7-4865-825d-7a57192726cb', NULL, 100012855917),
	('4e9c0790-a240-4ea2-9c71-2abf88e3ef5e', 'f7da9aec-c659-460a-aeb9-bf787e47810e', NULL, 3455015782),
	('7a3d0b44-80d7-4092-a0d2-09a5a65f210b', '5b8f48a7-83ba-4b30-a4e7-8b7730c5658f', NULL, 10090666596);


--
-- Data for Name: establishment_to_site; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_to_site (establishment_id, site_id, is_main_site) VALUES
	('2d0d064a-8d54-48b3-9451-008f68bccb10', '0200d131-f656-4d54-9bb9-d916c5d92e18', true),
	('30ba075d-d376-46a3-94ef-d0db8bab5d70', '604db450-5774-41d0-a23f-c8cca41fd899', true),
	('5a25ba22-65ce-4106-b82a-2d709672d273', '4e9c0790-a240-4ea2-9c71-2abf88e3ef5e', true),
	('cfcf18ac-39d2-436f-9c3a-5e7d3e810851', '7a3d0b44-80d7-4092-a0d2-09a5a65f210b', true);


--
-- Data for Name: organisation_identifier; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.organisation_identifier (organisation_identifier_id, legal_entity_id, organisation_identifier_type_id, value, is_current) VALUES
	('51e83fbf-7cfa-49ff-9b1f-d7eeed606aa1', 'a8d9fbcf-7e26-4b50-a432-397cabb1b651', 1, '06888873', true);


--
-- Data for Name: specialist_provision; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.specialist_provision (specialist_provision_id, establishment_id, specialist_provision_type_id) VALUES
	('05bfe930-021d-4d5a-a34e-c8620cc387d8', '2d0d064a-8d54-48b3-9451-008f68bccb10', 3);


--
-- Data for Name: resourced_provision; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.resourced_provision (resourced_provision_id, specialist_provision_id, capacity, pupil_count) VALUES
	('4a0de149-fc8c-4927-a5e1-134ef2927e3e', '05bfe930-021d-4d5a-a34e-c8620cc387d8', 24, 24);


--
-- Data for Name: sen_unit_provision; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.sen_unit_provision (sen_unit_provision_id, specialist_provision_id, capacity, pupil_count) VALUES
	('fcbdcbbc-7158-4862-af2c-2771ce385cd5', '05bfe930-021d-4d5a-a34e-c8620cc387d8', 24, 24);


--
-- Data for Name: statutory_age_range; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.statutory_age_range (statutory_age_range_id, education_admissions_and_provision_id, lower_statutory_age, upper_statutory_age) VALUES
	('6594879a-440b-451e-aec4-a5057ce3e182', '06266efc-157c-4a85-ad93-c31dbbd8a513', 2, 11),
	('4de3d2af-1911-4307-b20b-c9bcf54b9272', 'fd47dd8f-5f78-4f2a-9fce-df218efe1711', 4, 11),
	('9eb400bd-3b3a-43c2-ada6-e0f617f4b2ca', 'e8bfde1f-4dfc-4918-b71b-c62430cf4cfb', 11, 16),
	('2e9612cb-f95b-4512-ada2-da092c00c6d1', 'c48ccba2-c3d9-478b-9cf1-83e25ee2d77a', 11, 19);


--
-- PostgreSQL database dump complete
--

\unrestrict sxcHHaeVenYqc3ycEAHenxL7d3OALuh7JGRLaAlrv2xkjJ6DmYa5dcLPQKDbmGA

