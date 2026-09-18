--
-- PostgreSQL database dump
--

\restrict wWdGCEpcWoAMJSL8tVHL42dVWgpP9FqYfA8v4T2gsFTdrUfZgQoJNmfG6V6D5um

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

INSERT INTO establishment.address (address_id, address_line_1, address_line_2, address_line_3, town, county, postcode) VALUES ('6f5b9f44-ccf4-49f3-8777-75fec3357435', 'obfuscated', NULL, NULL, 'obfuscated', '099', 'NW1 3EX');
INSERT INTO establishment.address (address_id, address_line_1, address_line_2, address_line_3, town, county, postcode) VALUES ('d5d5caba-0d5e-4b7e-acec-d3d4a589e34f', 'obfuscated', NULL, NULL, 'obfuscated', '019', 'WN7 3PQ');
INSERT INTO establishment.address (address_id, address_line_1, address_line_2, address_line_3, town, county, postcode) VALUES ('5e5ebd20-77d0-4858-ba46-5524a8e61908', 'obfuscated', NULL, 'obfuscated', 'obfuscated', '032', 'ST6 4LD');


--
-- Data for Name: establishment; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment (establishment_id, urn, ukprn, establishment_number, name, establishment_type_id, education_phase_id) VALUES ('1b75af57-0346-4f99-8224-19f81f9adc5b', 100018, 10069172, 2436, 'Netley Primary School & Centre for Autism', 1, 2);
INSERT INTO establishment.establishment (establishment_id, urn, ukprn, establishment_number, name, establishment_type_id, education_phase_id) VALUES ('11b2a847-2d8d-432e-a514-588e42d42d76', 106431, 10072615, 2053, 'Gilded Hollins Community School', 1, 2);
INSERT INTO establishment.establishment (establishment_id, urn, ukprn, establishment_number, name, establishment_type_id, education_phase_id) VALUES ('1286ad42-4ddc-408d-a2d8-fa5aa48d5bcb', 136102, 10030216, 6905, 'The Co-Operative Academy of Stoke-On-Trent', 4, 5);


--
-- Data for Name: capacity_and_pupil_measures; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.capacity_and_pupil_measures (capacity_and_pupil_measures_id, establishment_id, school_capacity, pupil_count, free_school_meal_measure, census_date) VALUES ('f3476aa2-ea4a-4435-9d85-d2c4a564191e', '1b75af57-0346-4f99-8224-19f81f9adc5b', 65801, 383, 224, NULL);
INSERT INTO establishment.capacity_and_pupil_measures (capacity_and_pupil_measures_id, establishment_id, school_capacity, pupil_count, free_school_meal_measure, census_date) VALUES ('b2885c6f-a554-4f3a-bda3-8d3abe43aaa9', '11b2a847-2d8d-432e-a514-588e42d42d76', 22286, 209, 15, NULL);
INSERT INTO establishment.capacity_and_pupil_measures (capacity_and_pupil_measures_id, establishment_id, school_capacity, pupil_count, free_school_meal_measure, census_date) VALUES ('de52cd5f-25b9-4b5f-85ad-51ce3a83f5fd', '1286ad42-4ddc-408d-a2d8-fa5aa48d5bcb', 1050, 1300, 735, NULL);


--
-- Data for Name: education_admissions_and_provision; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.education_admissions_and_provision (education_admissions_and_provision_id, establishment_id, gender_of_entry_type_id, admissions_policy_id, boarding_provision_id, nursery_provision_id, sixth_form_provision_id) VALUES ('248cc22b-d94c-4348-8a2d-42f134776175', '1b75af57-0346-4f99-8224-19f81f9adc5b', 1, 3, 1, 1, 2);
INSERT INTO establishment.education_admissions_and_provision (education_admissions_and_provision_id, establishment_id, gender_of_entry_type_id, admissions_policy_id, boarding_provision_id, nursery_provision_id, sixth_form_provision_id) VALUES ('b7c9e0bb-863e-4633-957b-640a59fa9783', '11b2a847-2d8d-432e-a514-588e42d42d76', 1, 3, 1, 2, 2);
INSERT INTO establishment.education_admissions_and_provision (education_admissions_and_provision_id, establishment_id, gender_of_entry_type_id, admissions_policy_id, boarding_provision_id, nursery_provision_id, sixth_form_provision_id) VALUES ('b8352586-c57a-4980-87c9-cdfe0ae0a993', '1286ad42-4ddc-408d-a2d8-fa5aa48d5bcb', 1, 1, 1, 3, 3);


--
-- Data for Name: establishment_contact; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_contact (establishment_contact_id, establishment_id, website, telephone_number) VALUES ('ef8e13e4-8b41-4969-be0a-a748b4c41eef', '1b75af57-0346-4f99-8224-19f81f9adc5b', 'www.netley.camden.sch.uk/', '111111');
INSERT INTO establishment.establishment_contact (establishment_contact_id, establishment_id, website, telephone_number) VALUES ('4a4ba46e-835e-4afc-b27f-8b7a6ef26c41', '11b2a847-2d8d-432e-a514-588e42d42d76', 'www.gildedhollins.wigan.sch.uk/', '111111');
INSERT INTO establishment.establishment_contact (establishment_contact_id, establishment_id, website, telephone_number) VALUES ('84271e0d-72fc-44ce-9f00-606fc07f7c5b', '1286ad42-4ddc-408d-a2d8-fa5aa48d5bcb', 'http://www.cas.coop', '111111');


--
-- Data for Name: establishment_geography; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_geography (establishment_geography_id, establishment_id, local_authority_id, government_office_region_id) VALUES ('abc63ed0-91dc-4a45-ae35-64b85f2b6777', '1b75af57-0346-4f99-8224-19f81f9adc5b', '0956c9af-2de2-4dea-94ed-b5c432eae45f', '1375841f-e6ba-4cda-9fac-753ff9df93a2');
INSERT INTO establishment.establishment_geography (establishment_geography_id, establishment_id, local_authority_id, government_office_region_id) VALUES ('d91c4746-2263-4c8f-b2b6-7685f541b8c5', '11b2a847-2d8d-432e-a514-588e42d42d76', '2601da0a-6f35-4c15-984e-f4482d1df384', '489dce3e-58d7-44c5-b9ef-2f7d7cbdb592');
INSERT INTO establishment.establishment_geography (establishment_geography_id, establishment_id, local_authority_id, government_office_region_id) VALUES ('ed5d9aed-ef52-4b45-aeb7-85d33bb7b39e', '1286ad42-4ddc-408d-a2d8-fa5aa48d5bcb', '3332ea83-bcbe-48d1-970d-a3650d9bcf10', '7ca695f4-dfcd-4f78-bdaf-17861eafbf97');


--
-- Data for Name: establishment_lifecycle; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_lifecycle (establishment_lifecycle_id, establishment_id, establishment_status_id, open_date, close_date, reason_establishment_opened_id, reason_establishment_closed_id, last_changed_date) VALUES ('556ab379-5918-4b41-a8ec-415135c9e9eb', '1b75af57-0346-4f99-8224-19f81f9adc5b', 1, NULL, NULL, NULL, NULL, '2026-06-23');
INSERT INTO establishment.establishment_lifecycle (establishment_lifecycle_id, establishment_id, establishment_status_id, open_date, close_date, reason_establishment_opened_id, reason_establishment_closed_id, last_changed_date) VALUES ('ac8f1e6a-9bf5-4746-a32d-61d74ab3d820', '11b2a847-2d8d-432e-a514-588e42d42d76', 1, NULL, NULL, NULL, NULL, '2026-06-23');
INSERT INTO establishment.establishment_lifecycle (establishment_lifecycle_id, establishment_id, establishment_status_id, open_date, close_date, reason_establishment_opened_id, reason_establishment_closed_id, last_changed_date) VALUES ('5d64aea8-66e0-4639-92bb-6939c2283b93', '1286ad42-4ddc-408d-a2d8-fa5aa48d5bcb', 1, '2010-09-01', NULL, 2, NULL, '2026-06-23');


--
-- Data for Name: site; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.site (site_id, address_id, site_name, uprn) VALUES ('b562bc10-a30a-4eb8-8dfd-eb9e4d905b50', '6f5b9f44-ccf4-49f3-8777-75fec3357435', NULL, 5172210);
INSERT INTO establishment.site (site_id, address_id, site_name, uprn) VALUES ('d180c897-2304-4099-a253-65b784d35814', 'd5d5caba-0d5e-4b7e-acec-d3d4a589e34f', NULL, 100012855917);
INSERT INTO establishment.site (site_id, address_id, site_name, uprn) VALUES ('a3022b1d-f12b-4200-9fd0-337d4d6e38f7', '5e5ebd20-77d0-4858-ba46-5524a8e61908', NULL, 3455015782);


--
-- Data for Name: establishment_to_site; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_to_site (establishment_id, site_id, is_main_site) VALUES ('1b75af57-0346-4f99-8224-19f81f9adc5b', 'b562bc10-a30a-4eb8-8dfd-eb9e4d905b50', true);
INSERT INTO establishment.establishment_to_site (establishment_id, site_id, is_main_site) VALUES ('11b2a847-2d8d-432e-a514-588e42d42d76', 'd180c897-2304-4099-a253-65b784d35814', true);
INSERT INTO establishment.establishment_to_site (establishment_id, site_id, is_main_site) VALUES ('1286ad42-4ddc-408d-a2d8-fa5aa48d5bcb', 'a3022b1d-f12b-4200-9fd0-337d4d6e38f7', true);


--
-- Data for Name: specialist_provision; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.specialist_provision (specialist_provision_id, establishment_id, specialist_provision_type_id) VALUES ('1b05463c-93eb-42e2-ad51-8a7ce4555645', '1b75af57-0346-4f99-8224-19f81f9adc5b', 3);


--
-- Data for Name: resourced_provision; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.resourced_provision (resourced_provision_id, specialist_provision_id, capacity, pupil_count) VALUES ('1c8c8d03-7224-43a4-a9a4-168c524eb602', '1b05463c-93eb-42e2-ad51-8a7ce4555645', 24, 24);


--
-- Data for Name: sen_unit_provision; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.sen_unit_provision (sen_unit_provision_id, specialist_provision_id, capacity, pupil_count) VALUES ('e25ce3a2-a27c-4e30-acba-539f08eda9cc', '1b05463c-93eb-42e2-ad51-8a7ce4555645', 24, 24);


--
-- Data for Name: statutory_age_range; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.statutory_age_range (statutory_age_range_id, education_admissions_and_provision_id, lower_statutory_age, upper_statutory_age) VALUES ('eb4385d0-9a0e-41f3-b941-06d20ccdec64', '248cc22b-d94c-4348-8a2d-42f134776175', 2, 11);
INSERT INTO establishment.statutory_age_range (statutory_age_range_id, education_admissions_and_provision_id, lower_statutory_age, upper_statutory_age) VALUES ('f4e473fc-46b8-4df8-8a9b-d1310d49bc10', 'b7c9e0bb-863e-4633-957b-640a59fa9783', 4, 11);
INSERT INTO establishment.statutory_age_range (statutory_age_range_id, education_admissions_and_provision_id, lower_statutory_age, upper_statutory_age) VALUES ('6a5dcf89-ca3d-4047-b0ee-2bec9b990bba', 'b8352586-c57a-4980-87c9-cdfe0ae0a993', 11, 16);


--
-- PostgreSQL database dump complete
--

\unrestrict wWdGCEpcWoAMJSL8tVHL42dVWgpP9FqYfA8v4T2gsFTdrUfZgQoJNmfG6V6D5um

