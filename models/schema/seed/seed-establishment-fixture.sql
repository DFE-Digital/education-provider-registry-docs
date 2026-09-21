--
-- PostgreSQL database dump
--

\restrict D6IR19QLBAHPKIbsvz0kSZkxN5rPpxb5YVNoOIQBeTXY05g9ZLT76Qqqea0at3l

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
-- Data for Name: address; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.address (address_id, address_line_1, address_line_2, address_line_3, town, county, postcode) VALUES
	('22919a2b-8567-4e7e-8b3b-29f495759c1b', 'obfuscated', NULL, NULL, 'obfuscated', '099', 'NW1 3EX'),
	('8e0ff4d6-bcd3-4641-929d-78f37192303f', 'obfuscated', NULL, NULL, 'obfuscated', '019', 'WN7 3PQ'),
	('5e6a28cd-f305-44bb-a9af-25c3dcc57904', 'obfuscated', NULL, 'obfuscated', 'obfuscated', '032', 'ST6 4LD');


--
-- Data for Name: establishment; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment (establishment_id, urn, ukprn, establishment_number, name, establishment_type_id, education_phase_id) VALUES
	('dcb2dde3-6290-4ada-ab01-b43f05ec670f', 100018, 10069172, 2436, 'Netley Primary School & Centre for Autism', 1, 2),
	('88b684af-e8bf-4e39-9f13-30737eeeffe8', 106431, 10072615, 2053, 'Gilded Hollins Community School', 1, 2),
	('0621b34c-781c-4643-b3e0-6fc7e02acf7d', 136102, 10030216, 6905, 'The Co-Operative Academy of Stoke-On-Trent', 4, 5);


--
-- Data for Name: capacity_and_pupil_measures; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.capacity_and_pupil_measures (capacity_and_pupil_measures_id, establishment_id, school_capacity, pupil_count, free_school_meal_measure, census_date) VALUES
	('8d08d87d-accf-4481-b91e-f098c8b2f18e', 'dcb2dde3-6290-4ada-ab01-b43f05ec670f', 65801, 383, 224, NULL),
	('4b70853a-260d-4bd8-b82a-7df79699da63', '88b684af-e8bf-4e39-9f13-30737eeeffe8', 22286, 209, 15, NULL),
	('41a0f830-cb0e-41c7-afff-b61dc32b1d32', '0621b34c-781c-4643-b3e0-6fc7e02acf7d', 1050, 1300, 735, NULL);


--
-- Data for Name: education_admissions_and_provision; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.education_admissions_and_provision (education_admissions_and_provision_id, establishment_id, gender_of_entry_type_id, admissions_policy_id, boarding_provision_id, nursery_provision_id, sixth_form_provision_id) VALUES
	('1a0c030a-7335-41e5-8769-9f079ce37fce', 'dcb2dde3-6290-4ada-ab01-b43f05ec670f', 1, 3, 1, 1, 2),
	('8c4c49f5-5ef3-4bf0-a8f9-632611f80087', '88b684af-e8bf-4e39-9f13-30737eeeffe8', 1, 3, 1, 2, 2),
	('7f428c69-92f5-4885-b765-a6de3270b30c', '0621b34c-781c-4643-b3e0-6fc7e02acf7d', 1, 1, 1, 3, 3);


--
-- Data for Name: establishment_contact; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_contact (establishment_contact_id, establishment_id, website, telephone_number) VALUES
	('6e500df5-329a-4a4c-8c89-82beea8540b6', 'dcb2dde3-6290-4ada-ab01-b43f05ec670f', 'www.netley.camden.sch.uk/', '111111'),
	('940a86e1-eb1e-4d49-841f-8a6ac5d675cb', '88b684af-e8bf-4e39-9f13-30737eeeffe8', 'www.gildedhollins.wigan.sch.uk/', '111111'),
	('2fcf56f9-e94e-4ba6-8f9f-7b47f00d34a8', '0621b34c-781c-4643-b3e0-6fc7e02acf7d', 'http://www.cas.coop', '111111');


--
-- Data for Name: establishment_geography; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_geography (establishment_geography_id, establishment_id, local_authority_id, government_office_region_id, district_administrative_id, administrative_ward_id, parliamentary_constituency_id, lsoa_id, msoa_id) VALUES
	('d8a41d66-9380-4451-bc28-792a1a18f64e', 'dcb2dde3-6290-4ada-ab01-b43f05ec670f', '0956c9af-2de2-4dea-94ed-b5c432eae45f', '1375841f-e6ba-4cda-9fac-753ff9df93a2', 'f2665403-6621-493d-8a2d-8de9ae1f1c4a', '2aebb958-956d-4800-a776-00aac3556316', '90dee41f-c934-4b2d-9d52-b42e83fdfe88', '94fb01a9-81ec-4a90-88a6-4ad2a8db4ba9', '4cdb54e5-d81b-45d9-b218-65030aab6d87'),
	('d512a2fb-9bb6-48dc-93f7-26cf2b75278e', '88b684af-e8bf-4e39-9f13-30737eeeffe8', '2601da0a-6f35-4c15-984e-f4482d1df384', '489dce3e-58d7-44c5-b9ef-2f7d7cbdb592', '412eea43-d307-464e-a929-62cfd4b5028d', '43acd11d-82cc-4391-8965-d45a61e5cd71', '2a9b46ea-4d43-474f-acbf-05444acfa1d1', '9cc4ab4f-4e19-465d-80a4-87b97b425244', '136005b3-68ff-4fa7-b439-2b4a1d626b24'),
	('0178048b-ad69-4835-9a99-bd8f18725ce2', '0621b34c-781c-4643-b3e0-6fc7e02acf7d', '3332ea83-bcbe-48d1-970d-a3650d9bcf10', '7ca695f4-dfcd-4f78-bdaf-17861eafbf97', '6ef1f577-d0bc-4698-951c-f202f9eaada6', 'e73f0fc2-114a-4772-a84e-5363b02ba34b', '714fb4a2-4d2e-4875-9853-1d7d6696559e', 'cec78739-d3a7-4831-9934-8dec5c5bdcd1', '5ed6445f-c41a-4778-9a5c-55ba74a2155b');


--
-- Data for Name: establishment_lifecycle; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_lifecycle (establishment_lifecycle_id, establishment_id, establishment_status_id, open_date, close_date, reason_establishment_opened_id, reason_establishment_closed_id, last_changed_date) VALUES
	('cf93da69-5f5a-4944-9cb6-389429d97d79', 'dcb2dde3-6290-4ada-ab01-b43f05ec670f', 1, NULL, NULL, NULL, NULL, '2026-06-23'),
	('cf14ae4e-bfa5-49ff-987b-81a6a1df723d', '88b684af-e8bf-4e39-9f13-30737eeeffe8', 1, NULL, NULL, NULL, NULL, '2026-06-23'),
	('374d4c96-1406-4099-9c93-d5dd1526d1f6', '0621b34c-781c-4643-b3e0-6fc7e02acf7d', 1, '2010-09-01', NULL, 2, NULL, '2026-06-23');


--
-- Data for Name: site; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.site (site_id, address_id, site_name, uprn) VALUES
	('5509b17d-d257-4e99-9e8a-3d295b229f59', '22919a2b-8567-4e7e-8b3b-29f495759c1b', NULL, 5172210),
	('6fd33f97-5ecf-4ce9-9c7d-687e3464a28b', '8e0ff4d6-bcd3-4641-929d-78f37192303f', NULL, 100012855917),
	('de3d3215-8bfd-4647-a54f-68c2b14f0449', '5e6a28cd-f305-44bb-a9af-25c3dcc57904', NULL, 3455015782);


--
-- Data for Name: establishment_to_site; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_to_site (establishment_id, site_id, is_main_site) VALUES
	('dcb2dde3-6290-4ada-ab01-b43f05ec670f', '5509b17d-d257-4e99-9e8a-3d295b229f59', true),
	('88b684af-e8bf-4e39-9f13-30737eeeffe8', '6fd33f97-5ecf-4ce9-9c7d-687e3464a28b', true),
	('0621b34c-781c-4643-b3e0-6fc7e02acf7d', 'de3d3215-8bfd-4647-a54f-68c2b14f0449', true);


--
-- Data for Name: specialist_provision; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.specialist_provision (specialist_provision_id, establishment_id, specialist_provision_type_id) VALUES
	('389fa3b6-a430-44ac-bbf5-993f644347ed', 'dcb2dde3-6290-4ada-ab01-b43f05ec670f', 3);


--
-- Data for Name: resourced_provision; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.resourced_provision (resourced_provision_id, specialist_provision_id, capacity, pupil_count) VALUES
	('78ec0a6b-6c4c-4cc8-a71f-08bd2536afcf', '389fa3b6-a430-44ac-bbf5-993f644347ed', 24, 24);


--
-- Data for Name: sen_unit_provision; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.sen_unit_provision (sen_unit_provision_id, specialist_provision_id, capacity, pupil_count) VALUES
	('0bab752e-1ee5-461c-a197-e28bb771951f', '389fa3b6-a430-44ac-bbf5-993f644347ed', 24, 24);


--
-- Data for Name: statutory_age_range; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.statutory_age_range (statutory_age_range_id, education_admissions_and_provision_id, lower_statutory_age, upper_statutory_age) VALUES
	('c15f4d2f-0df7-49c6-8c0a-9d351f524464', '1a0c030a-7335-41e5-8769-9f079ce37fce', 2, 11),
	('b9d603f2-1194-4311-b8c6-542b59ab9180', '8c4c49f5-5ef3-4bf0-a8f9-632611f80087', 4, 11),
	('20e58d26-b704-4fbb-a6a4-fcfb77c1ae47', '7f428c69-92f5-4885-b765-a6de3270b30c', 11, 16);


--
-- PostgreSQL database dump complete
--

\unrestrict D6IR19QLBAHPKIbsvz0kSZkxN5rPpxb5YVNoOIQBeTXY05g9ZLT76Qqqea0at3l

