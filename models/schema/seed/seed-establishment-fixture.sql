--
-- PostgreSQL database dump
--

\restrict NwTHeLkmWjrbVf0lw2Q284UddyEWkQ1Q5IJhMjMSFzAezkMEjB6C3rew1ldjjPl

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
	('3eb97255-0902-4f2d-89ae-40b2f65f4ab1', 'obfuscated', NULL, NULL, 'obfuscated', '099', 'NW1 3EX'),
	('48d6af7f-696e-45b0-b984-216e2d822657', 'obfuscated', NULL, NULL, 'obfuscated', '019', 'WN7 3PQ'),
	('d9a4cc5a-48a3-4cf5-b207-9d70547ed3a5', 'obfuscated', NULL, 'obfuscated', 'obfuscated', '032', 'ST6 4LD');


--
-- Data for Name: establishment; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment (establishment_id, urn, ukprn, establishment_number, name, establishment_type_id, education_phase_id) VALUES
	('31119dd0-95f6-4a82-bd7d-b5281aba4549', 100018, 10069172, 2436, 'Netley Primary School & Centre for Autism', 1, 2),
	('ed9db0ba-2bd6-47a0-bc47-4e7f65b35402', 106431, 10072615, 2053, 'Gilded Hollins Community School', 1, 2),
	('9fcbf8a3-a8d0-4f42-bac3-8bf701e7cf25', 136102, 10030216, 6905, 'The Co-Operative Academy of Stoke-On-Trent', 4, 5);


--
-- Data for Name: capacity_and_pupil_measures; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.capacity_and_pupil_measures (capacity_and_pupil_measures_id, establishment_id, school_capacity, pupil_count, free_school_meal_measure, census_date) VALUES
	('e97b3875-6e96-40de-8868-2afdaa87196f', '31119dd0-95f6-4a82-bd7d-b5281aba4549', 65801, 383, 224, NULL),
	('e7f87178-19ef-4ab6-a8ed-7aacc612cfa0', 'ed9db0ba-2bd6-47a0-bc47-4e7f65b35402', 22286, 209, 15, NULL),
	('7595779f-5efd-4e81-9172-4808f956f4e2', '9fcbf8a3-a8d0-4f42-bac3-8bf701e7cf25', 1050, 1300, 735, NULL);


--
-- Data for Name: education_admissions_and_provision; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.education_admissions_and_provision (education_admissions_and_provision_id, establishment_id, gender_of_entry_type_id, admissions_policy_id, boarding_provision_id, nursery_provision_id, sixth_form_provision_id) VALUES
	('1ced0c57-b92b-48f1-8e4a-2a805a6c4b68', '31119dd0-95f6-4a82-bd7d-b5281aba4549', 1, 3, 1, 1, 2),
	('b52a3bad-db1a-463c-83b2-9aaa31c178f5', 'ed9db0ba-2bd6-47a0-bc47-4e7f65b35402', 1, 3, 1, 2, 2),
	('c4dc1f49-c657-438b-8c30-cfd1a52d2fab', '9fcbf8a3-a8d0-4f42-bac3-8bf701e7cf25', 1, 1, 1, 3, 3);


--
-- Data for Name: establishment_contact; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_contact (establishment_contact_id, establishment_id, website, telephone_number) VALUES
	('36d517b4-aad2-4b3b-b33b-cf74ccb8fbf4', '31119dd0-95f6-4a82-bd7d-b5281aba4549', 'www.netley.camden.sch.uk/', '111111'),
	('135382ca-0c97-45d8-a3f5-03d336964456', 'ed9db0ba-2bd6-47a0-bc47-4e7f65b35402', 'www.gildedhollins.wigan.sch.uk/', '111111'),
	('917f7a51-c277-4e7c-a3fc-8778b2cd341d', '9fcbf8a3-a8d0-4f42-bac3-8bf701e7cf25', 'http://www.cas.coop', '111111');


--
-- Data for Name: establishment_geography; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_geography (establishment_geography_id, establishment_id, local_authority_id, government_office_region_id, district_administrative_id, administrative_ward_id, parliamentary_constituency_id, lsoa_id, msoa_id, urban_rural_id) VALUES
	('7cf6f695-d999-41d5-ab33-18f8dcd31ab1', '31119dd0-95f6-4a82-bd7d-b5281aba4549', '0956c9af-2de2-4dea-94ed-b5c432eae45f', '1375841f-e6ba-4cda-9fac-753ff9df93a2', 'f2665403-6621-493d-8a2d-8de9ae1f1c4a', '2aebb958-956d-4800-a776-00aac3556316', '90dee41f-c934-4b2d-9d52-b42e83fdfe88', '94fb01a9-81ec-4a90-88a6-4ad2a8db4ba9', '4cdb54e5-d81b-45d9-b218-65030aab6d87', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('51bb80cb-e002-41f1-a69f-c1820893a960', 'ed9db0ba-2bd6-47a0-bc47-4e7f65b35402', '2601da0a-6f35-4c15-984e-f4482d1df384', '489dce3e-58d7-44c5-b9ef-2f7d7cbdb592', '412eea43-d307-464e-a929-62cfd4b5028d', '43acd11d-82cc-4391-8965-d45a61e5cd71', '2a9b46ea-4d43-474f-acbf-05444acfa1d1', '9cc4ab4f-4e19-465d-80a4-87b97b425244', '136005b3-68ff-4fa7-b439-2b4a1d626b24', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('4859cb79-c7be-402d-bed1-97f42d995363', '9fcbf8a3-a8d0-4f42-bac3-8bf701e7cf25', '3332ea83-bcbe-48d1-970d-a3650d9bcf10', '7ca695f4-dfcd-4f78-bdaf-17861eafbf97', '6ef1f577-d0bc-4698-951c-f202f9eaada6', 'e73f0fc2-114a-4772-a84e-5363b02ba34b', '714fb4a2-4d2e-4875-9853-1d7d6696559e', 'cec78739-d3a7-4831-9934-8dec5c5bdcd1', '5ed6445f-c41a-4778-9a5c-55ba74a2155b', '8826f875-fade-4b0b-a4b1-f8536505ecd1');


--
-- Data for Name: establishment_lifecycle; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_lifecycle (establishment_lifecycle_id, establishment_id, establishment_status_id, open_date, close_date, reason_establishment_opened_id, reason_establishment_closed_id, last_changed_date) VALUES
	('91d82699-0f6c-4a4b-a76f-4d33c4c030f1', '31119dd0-95f6-4a82-bd7d-b5281aba4549', 1, NULL, NULL, NULL, NULL, '2026-06-23'),
	('4c7dc301-7f4b-44aa-b810-287e3d27476d', 'ed9db0ba-2bd6-47a0-bc47-4e7f65b35402', 1, NULL, NULL, NULL, NULL, '2026-06-23'),
	('d649c1b3-840f-4b80-b88b-8676ee12c0c6', '9fcbf8a3-a8d0-4f42-bac3-8bf701e7cf25', 1, '2010-09-01', NULL, 2, NULL, '2026-06-23');


--
-- Data for Name: site; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.site (site_id, address_id, site_name, uprn) VALUES
	('92b82194-aa9f-4d58-9269-7d948b2bf457', '3eb97255-0902-4f2d-89ae-40b2f65f4ab1', NULL, 5172210),
	('dff65f9b-66c8-46ce-9367-ba86d386ba7d', '48d6af7f-696e-45b0-b984-216e2d822657', NULL, 100012855917),
	('9e73aefb-bd81-4826-b9d7-c51536b28034', 'd9a4cc5a-48a3-4cf5-b207-9d70547ed3a5', NULL, 3455015782);


--
-- Data for Name: establishment_to_site; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_to_site (establishment_id, site_id, is_main_site) VALUES
	('31119dd0-95f6-4a82-bd7d-b5281aba4549', '92b82194-aa9f-4d58-9269-7d948b2bf457', true),
	('ed9db0ba-2bd6-47a0-bc47-4e7f65b35402', 'dff65f9b-66c8-46ce-9367-ba86d386ba7d', true),
	('9fcbf8a3-a8d0-4f42-bac3-8bf701e7cf25', '9e73aefb-bd81-4826-b9d7-c51536b28034', true);


--
-- Data for Name: specialist_provision; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.specialist_provision (specialist_provision_id, establishment_id, specialist_provision_type_id) VALUES
	('0c91dc53-a898-456b-8891-9b4e9fd3bfac', '31119dd0-95f6-4a82-bd7d-b5281aba4549', 3);


--
-- Data for Name: resourced_provision; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.resourced_provision (resourced_provision_id, specialist_provision_id, capacity, pupil_count) VALUES
	('429c2bbb-d031-40d5-b28f-08455bd9a407', '0c91dc53-a898-456b-8891-9b4e9fd3bfac', 24, 24);


--
-- Data for Name: sen_unit_provision; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.sen_unit_provision (sen_unit_provision_id, specialist_provision_id, capacity, pupil_count) VALUES
	('f440633e-af8c-4723-8c3a-ee3ac4ed5827', '0c91dc53-a898-456b-8891-9b4e9fd3bfac', 24, 24);


--
-- Data for Name: statutory_age_range; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.statutory_age_range (statutory_age_range_id, education_admissions_and_provision_id, lower_statutory_age, upper_statutory_age) VALUES
	('291f86f9-b64b-4056-93b9-86588a629505', '1ced0c57-b92b-48f1-8e4a-2a805a6c4b68', 2, 11),
	('4aa8e9b9-b962-4677-a5d5-fdd3301ba2dc', 'b52a3bad-db1a-463c-83b2-9aaa31c178f5', 4, 11),
	('97174a6d-6e38-4520-83d8-366be4681fc2', 'c4dc1f49-c657-438b-8c30-cfd1a52d2fab', 11, 16);


--
-- PostgreSQL database dump complete
--

\unrestrict NwTHeLkmWjrbVf0lw2Q284UddyEWkQ1Q5IJhMjMSFzAezkMEjB6C3rew1ldjjPl

