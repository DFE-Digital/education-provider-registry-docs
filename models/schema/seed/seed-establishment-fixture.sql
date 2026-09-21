--
-- PostgreSQL database dump
--

\restrict 6R4FrN2TOIhRGj4NPMPc9SxaEijTgLRgdZJDD4pDZl6OogUgxPMMdXH0gggnMIT

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
	('f5ebc337-9d02-4aa6-8216-0020c3f966ac', 'obfuscated', NULL, NULL, 'obfuscated', '099', 'NW1 3EX'),
	('5918666d-9300-4fe5-b79f-3e4dc01f111a', 'obfuscated', NULL, NULL, 'obfuscated', '019', 'WN7 3PQ'),
	('89a626cc-20db-4a10-82d2-cb53bb18e040', 'obfuscated', NULL, 'obfuscated', 'obfuscated', '032', 'ST6 4LD');


--
-- Data for Name: establishment; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment (establishment_id, urn, ukprn, establishment_number, name, establishment_type_id, education_phase_id) VALUES
	('ceebed3c-39c7-4aa1-b068-95cc377b6a25', 100018, 10069172, 2436, 'Netley Primary School & Centre for Autism', 1, 2),
	('3c03e901-f57e-4969-8f7e-2b6924d2f0f8', 106431, 10072615, 2053, 'Gilded Hollins Community School', 1, 2),
	('ba8cb667-1f41-4633-a0ac-0721f074ebe4', 136102, 10030216, 6905, 'The Co-Operative Academy of Stoke-On-Trent', 4, 5);


--
-- Data for Name: capacity_and_pupil_measures; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.capacity_and_pupil_measures (capacity_and_pupil_measures_id, establishment_id, school_capacity, pupil_count, free_school_meal_measure, census_date) VALUES
	('3c98cc5c-77d2-4fbd-b5be-536bb5def3bc', 'ceebed3c-39c7-4aa1-b068-95cc377b6a25', 65801, 383, 224, NULL),
	('fc5d0897-a69d-4186-99d2-822904da80f1', '3c03e901-f57e-4969-8f7e-2b6924d2f0f8', 22286, 209, 15, NULL),
	('100144b2-0f94-4f21-b274-b39fc2c976a7', 'ba8cb667-1f41-4633-a0ac-0721f074ebe4', 1050, 1300, 735, NULL);


--
-- Data for Name: education_admissions_and_provision; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.education_admissions_and_provision (education_admissions_and_provision_id, establishment_id, gender_of_entry_type_id, admissions_policy_id, boarding_provision_id, nursery_provision_id, sixth_form_provision_id) VALUES
	('6a5f8267-88ba-4ee0-8524-5927ad7fb4f7', 'ceebed3c-39c7-4aa1-b068-95cc377b6a25', 1, 3, 1, 1, 2),
	('f866690a-cafc-46ff-992b-7536fbbcf4ea', '3c03e901-f57e-4969-8f7e-2b6924d2f0f8', 1, 3, 1, 2, 2),
	('af9eb04d-4d62-4644-989d-d704d80a6ca1', 'ba8cb667-1f41-4633-a0ac-0721f074ebe4', 1, 1, 1, 3, 3);


--
-- Data for Name: establishment_contact; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_contact (establishment_contact_id, establishment_id, website, telephone_number) VALUES
	('aad49687-675e-41fa-a527-b7d30d22dd8c', 'ceebed3c-39c7-4aa1-b068-95cc377b6a25', 'www.netley.camden.sch.uk/', '111111'),
	('cb3b45ab-46ba-4104-8d8b-31be238cb569', '3c03e901-f57e-4969-8f7e-2b6924d2f0f8', 'www.gildedhollins.wigan.sch.uk/', '111111'),
	('07ad6fc7-0208-498f-9eb2-ea6a29cce6dd', 'ba8cb667-1f41-4633-a0ac-0721f074ebe4', 'http://www.cas.coop', '111111');


--
-- Data for Name: establishment_geography; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_geography (establishment_geography_id, establishment_id, local_authority_id, government_office_region_id, district_administrative_id, administrative_ward_id) VALUES
	('bbdf0cb3-acb6-4dcd-aeea-de665784923b', 'ceebed3c-39c7-4aa1-b068-95cc377b6a25', '0956c9af-2de2-4dea-94ed-b5c432eae45f', '1375841f-e6ba-4cda-9fac-753ff9df93a2', 'f2665403-6621-493d-8a2d-8de9ae1f1c4a', '2aebb958-956d-4800-a776-00aac3556316'),
	('2cc534e6-a69a-406d-bee0-d839394fa3a3', '3c03e901-f57e-4969-8f7e-2b6924d2f0f8', '2601da0a-6f35-4c15-984e-f4482d1df384', '489dce3e-58d7-44c5-b9ef-2f7d7cbdb592', '412eea43-d307-464e-a929-62cfd4b5028d', '43acd11d-82cc-4391-8965-d45a61e5cd71'),
	('4d48419a-a920-4f27-b779-e2784abfe71a', 'ba8cb667-1f41-4633-a0ac-0721f074ebe4', '3332ea83-bcbe-48d1-970d-a3650d9bcf10', '7ca695f4-dfcd-4f78-bdaf-17861eafbf97', '6ef1f577-d0bc-4698-951c-f202f9eaada6', 'e73f0fc2-114a-4772-a84e-5363b02ba34b');


--
-- Data for Name: establishment_lifecycle; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_lifecycle (establishment_lifecycle_id, establishment_id, establishment_status_id, open_date, close_date, reason_establishment_opened_id, reason_establishment_closed_id, last_changed_date) VALUES
	('238a1030-00c5-497f-85ac-3d3c37afe3f3', 'ceebed3c-39c7-4aa1-b068-95cc377b6a25', 1, NULL, NULL, NULL, NULL, '2026-06-23'),
	('1d413824-ca0e-4c9c-8824-a97603fe214a', '3c03e901-f57e-4969-8f7e-2b6924d2f0f8', 1, NULL, NULL, NULL, NULL, '2026-06-23'),
	('0139b63c-9f15-40ec-bc66-39024fcb87ec', 'ba8cb667-1f41-4633-a0ac-0721f074ebe4', 1, '2010-09-01', NULL, 2, NULL, '2026-06-23');


--
-- Data for Name: site; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.site (site_id, address_id, site_name, uprn) VALUES
	('732dbb22-eec7-4783-8870-4b298407d17d', 'f5ebc337-9d02-4aa6-8216-0020c3f966ac', NULL, 5172210),
	('d53b9c60-faa5-4c77-8cbe-0a7f1688620d', '5918666d-9300-4fe5-b79f-3e4dc01f111a', NULL, 100012855917),
	('e0048319-47f0-4eae-a1a4-5d052c25fa15', '89a626cc-20db-4a10-82d2-cb53bb18e040', NULL, 3455015782);


--
-- Data for Name: establishment_to_site; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_to_site (establishment_id, site_id, is_main_site) VALUES
	('ceebed3c-39c7-4aa1-b068-95cc377b6a25', '732dbb22-eec7-4783-8870-4b298407d17d', true),
	('3c03e901-f57e-4969-8f7e-2b6924d2f0f8', 'd53b9c60-faa5-4c77-8cbe-0a7f1688620d', true),
	('ba8cb667-1f41-4633-a0ac-0721f074ebe4', 'e0048319-47f0-4eae-a1a4-5d052c25fa15', true);


--
-- Data for Name: specialist_provision; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.specialist_provision (specialist_provision_id, establishment_id, specialist_provision_type_id) VALUES
	('8dac4774-67dc-4e76-ae9c-b5faba3831f3', 'ceebed3c-39c7-4aa1-b068-95cc377b6a25', 3);


--
-- Data for Name: resourced_provision; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.resourced_provision (resourced_provision_id, specialist_provision_id, capacity, pupil_count) VALUES
	('f45b8e6f-fd7f-4bee-90b0-9d6f15906758', '8dac4774-67dc-4e76-ae9c-b5faba3831f3', 24, 24);


--
-- Data for Name: sen_unit_provision; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.sen_unit_provision (sen_unit_provision_id, specialist_provision_id, capacity, pupil_count) VALUES
	('b9680fce-4ae1-4e20-9fa3-a0fdd66a9b4a', '8dac4774-67dc-4e76-ae9c-b5faba3831f3', 24, 24);


--
-- Data for Name: statutory_age_range; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.statutory_age_range (statutory_age_range_id, education_admissions_and_provision_id, lower_statutory_age, upper_statutory_age) VALUES
	('bf7098a4-1523-46cf-bacc-110a11967491', '6a5f8267-88ba-4ee0-8524-5927ad7fb4f7', 2, 11),
	('9c2e39a7-9e8b-4635-bbdd-3669b21bfdf6', 'f866690a-cafc-46ff-992b-7536fbbcf4ea', 4, 11),
	('a0ec6aee-4911-47fd-a43c-cdd935337f95', 'af9eb04d-4d62-4644-989d-d704d80a6ca1', 11, 16);


--
-- PostgreSQL database dump complete
--

\unrestrict 6R4FrN2TOIhRGj4NPMPc9SxaEijTgLRgdZJDD4pDZl6OogUgxPMMdXH0gggnMIT

