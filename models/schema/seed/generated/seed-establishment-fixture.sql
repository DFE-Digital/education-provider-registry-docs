--
-- PostgreSQL database dump
--

\restrict 5WXoBZrgoPTHVdg5lokfX8vZzTxUwBTqokBlm2MkCEn1RbRuBRB6b6uMywU0ywj

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

INSERT INTO establishment.address (address_id, address_line_1, address_line_2, address_line_3, town, county, postcode) VALUES ('f4ac7ac4-e95d-47d6-9582-bfd41591ef86', 'obfuscated', NULL, NULL, 'obfuscated', '099', 'NW1 3EX');
INSERT INTO establishment.address (address_id, address_line_1, address_line_2, address_line_3, town, county, postcode) VALUES ('5b208a4f-a7fa-44bb-85cb-5e8ee0c9826e', 'obfuscated', NULL, NULL, 'obfuscated', '019', 'WN7 3PQ');
INSERT INTO establishment.address (address_id, address_line_1, address_line_2, address_line_3, town, county, postcode) VALUES ('d1aee40a-6444-41a3-ad27-6996e61b10d4', 'obfuscated', NULL, 'obfuscated', 'obfuscated', '032', 'ST6 4LD');


--
-- Data for Name: establishment; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment (establishment_id, urn, ukprn, establishment_number, name, establishment_type_id, education_phase_id) VALUES ('70e62d3c-1d55-494f-841d-ee9a193847bb', 100018, 10069172, 2436, 'Netley Primary School & Centre for Autism', 1, 2);
INSERT INTO establishment.establishment (establishment_id, urn, ukprn, establishment_number, name, establishment_type_id, education_phase_id) VALUES ('c29a39c0-84ff-4364-b142-e45df437c55b', 106431, 10072615, 2053, 'Gilded Hollins Community School', 1, 2);
INSERT INTO establishment.establishment (establishment_id, urn, ukprn, establishment_number, name, establishment_type_id, education_phase_id) VALUES ('ffcf8ee7-47e8-4bbf-83a2-c70ea93c89ba', 136102, 10030216, 6905, 'The Co-Operative Academy of Stoke-On-Trent', 4, 5);


--
-- Data for Name: capacity_and_pupil_measures; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.capacity_and_pupil_measures (capacity_and_pupil_measures_id, establishment_id, school_capacity, pupil_count, free_school_meal_measure, census_date) VALUES ('c32fdc29-ac3e-43b4-aa1c-e1d8d936733a', '70e62d3c-1d55-494f-841d-ee9a193847bb', 65801, 383, 224, NULL);
INSERT INTO establishment.capacity_and_pupil_measures (capacity_and_pupil_measures_id, establishment_id, school_capacity, pupil_count, free_school_meal_measure, census_date) VALUES ('5adb30b0-aff8-4f7e-b336-e7755f8be439', 'c29a39c0-84ff-4364-b142-e45df437c55b', 22286, 209, 15, NULL);
INSERT INTO establishment.capacity_and_pupil_measures (capacity_and_pupil_measures_id, establishment_id, school_capacity, pupil_count, free_school_meal_measure, census_date) VALUES ('fbec34ee-4e06-4dad-b83b-2498835666c9', 'ffcf8ee7-47e8-4bbf-83a2-c70ea93c89ba', 1050, 1300, 735, NULL);


--
-- Data for Name: education_admissions_and_provision; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.education_admissions_and_provision (education_admissions_and_provision_id, establishment_id, gender_of_entry_type_id, admissions_policy_id, boarding_provision_id, nursery_provision_id, sixth_form_provision_id) VALUES ('ce70a8bc-099c-4653-acce-9acf1391ea1d', '70e62d3c-1d55-494f-841d-ee9a193847bb', 1, 3, 1, 1, 2);
INSERT INTO establishment.education_admissions_and_provision (education_admissions_and_provision_id, establishment_id, gender_of_entry_type_id, admissions_policy_id, boarding_provision_id, nursery_provision_id, sixth_form_provision_id) VALUES ('70c398e9-6086-42db-af7f-25a085a18a63', 'c29a39c0-84ff-4364-b142-e45df437c55b', 1, 3, 1, 2, 2);
INSERT INTO establishment.education_admissions_and_provision (education_admissions_and_provision_id, establishment_id, gender_of_entry_type_id, admissions_policy_id, boarding_provision_id, nursery_provision_id, sixth_form_provision_id) VALUES ('50eeff36-cc0f-4dee-8290-f88d5e0d2cc5', 'ffcf8ee7-47e8-4bbf-83a2-c70ea93c89ba', 1, 1, 1, 3, 3);


--
-- Data for Name: establishment_contact; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_contact (establishment_contact_id, establishment_id, website, telephone_number) VALUES ('55ebf653-1d58-4f3b-822e-12a99786b69f', '70e62d3c-1d55-494f-841d-ee9a193847bb', 'www.netley.camden.sch.uk/', '111111');
INSERT INTO establishment.establishment_contact (establishment_contact_id, establishment_id, website, telephone_number) VALUES ('6725a22e-ff52-4f87-a5a2-91c26a95ac65', 'c29a39c0-84ff-4364-b142-e45df437c55b', 'www.gildedhollins.wigan.sch.uk/', '111111');
INSERT INTO establishment.establishment_contact (establishment_contact_id, establishment_id, website, telephone_number) VALUES ('a3c0dade-e185-4e3a-bb16-9b5ebb5daedd', 'ffcf8ee7-47e8-4bbf-83a2-c70ea93c89ba', 'http://www.cas.coop', '111111');


--
-- Data for Name: establishment_geography; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_geography (establishment_geography_id, establishment_id, local_authority_id, government_office_region_id, district_administrative_id) VALUES ('9ed9a153-0db7-477f-911f-1389532a8bc2', '70e62d3c-1d55-494f-841d-ee9a193847bb', '0956c9af-2de2-4dea-94ed-b5c432eae45f', '1375841f-e6ba-4cda-9fac-753ff9df93a2', 'f2665403-6621-493d-8a2d-8de9ae1f1c4a');
INSERT INTO establishment.establishment_geography (establishment_geography_id, establishment_id, local_authority_id, government_office_region_id, district_administrative_id) VALUES ('3dd92b36-6de0-4791-bed4-45f0ce23798d', 'c29a39c0-84ff-4364-b142-e45df437c55b', '2601da0a-6f35-4c15-984e-f4482d1df384', '489dce3e-58d7-44c5-b9ef-2f7d7cbdb592', '412eea43-d307-464e-a929-62cfd4b5028d');
INSERT INTO establishment.establishment_geography (establishment_geography_id, establishment_id, local_authority_id, government_office_region_id, district_administrative_id) VALUES ('18fd6fc0-2e89-4f17-9bad-aa892c2577c8', 'ffcf8ee7-47e8-4bbf-83a2-c70ea93c89ba', '3332ea83-bcbe-48d1-970d-a3650d9bcf10', '7ca695f4-dfcd-4f78-bdaf-17861eafbf97', '6ef1f577-d0bc-4698-951c-f202f9eaada6');


--
-- Data for Name: establishment_lifecycle; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_lifecycle (establishment_lifecycle_id, establishment_id, establishment_status_id, open_date, close_date, reason_establishment_opened_id, reason_establishment_closed_id, last_changed_date) VALUES ('f3184c4f-6ade-4725-b9c9-b9167cf35906', '70e62d3c-1d55-494f-841d-ee9a193847bb', 1, NULL, NULL, NULL, NULL, '2026-06-23');
INSERT INTO establishment.establishment_lifecycle (establishment_lifecycle_id, establishment_id, establishment_status_id, open_date, close_date, reason_establishment_opened_id, reason_establishment_closed_id, last_changed_date) VALUES ('b8866652-684d-4bcd-93fa-638826095f61', 'c29a39c0-84ff-4364-b142-e45df437c55b', 1, NULL, NULL, NULL, NULL, '2026-06-23');
INSERT INTO establishment.establishment_lifecycle (establishment_lifecycle_id, establishment_id, establishment_status_id, open_date, close_date, reason_establishment_opened_id, reason_establishment_closed_id, last_changed_date) VALUES ('116c1525-c867-4518-bfc1-eab771ccac64', 'ffcf8ee7-47e8-4bbf-83a2-c70ea93c89ba', 1, '2010-09-01', NULL, 2, NULL, '2026-06-23');


--
-- Data for Name: site; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.site (site_id, address_id, site_name, uprn) VALUES ('49ab3a9f-a4d5-4810-b649-c276726e8e4d', 'f4ac7ac4-e95d-47d6-9582-bfd41591ef86', NULL, 5172210);
INSERT INTO establishment.site (site_id, address_id, site_name, uprn) VALUES ('effbbcac-fa06-4dc5-823e-6d17da128ba8', '5b208a4f-a7fa-44bb-85cb-5e8ee0c9826e', NULL, 100012855917);
INSERT INTO establishment.site (site_id, address_id, site_name, uprn) VALUES ('2d4324fb-7c76-43ab-8594-a22c9047a620', 'd1aee40a-6444-41a3-ad27-6996e61b10d4', NULL, 3455015782);


--
-- Data for Name: establishment_to_site; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_to_site (establishment_id, site_id, is_main_site) VALUES ('70e62d3c-1d55-494f-841d-ee9a193847bb', '49ab3a9f-a4d5-4810-b649-c276726e8e4d', true);
INSERT INTO establishment.establishment_to_site (establishment_id, site_id, is_main_site) VALUES ('c29a39c0-84ff-4364-b142-e45df437c55b', 'effbbcac-fa06-4dc5-823e-6d17da128ba8', true);
INSERT INTO establishment.establishment_to_site (establishment_id, site_id, is_main_site) VALUES ('ffcf8ee7-47e8-4bbf-83a2-c70ea93c89ba', '2d4324fb-7c76-43ab-8594-a22c9047a620', true);


--
-- Data for Name: specialist_provision; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.specialist_provision (specialist_provision_id, establishment_id, specialist_provision_type_id) VALUES ('7245542c-fd08-4012-9223-dd407f4a8bbe', '70e62d3c-1d55-494f-841d-ee9a193847bb', 3);


--
-- Data for Name: resourced_provision; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.resourced_provision (resourced_provision_id, specialist_provision_id, capacity, pupil_count) VALUES ('3fdc5d53-384d-4417-9fff-db00bca733d1', '7245542c-fd08-4012-9223-dd407f4a8bbe', 24, 24);


--
-- Data for Name: sen_unit_provision; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.sen_unit_provision (sen_unit_provision_id, specialist_provision_id, capacity, pupil_count) VALUES ('c8c7cdaa-7175-4347-ba04-09a4d45aa5d8', '7245542c-fd08-4012-9223-dd407f4a8bbe', 24, 24);


--
-- Data for Name: statutory_age_range; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.statutory_age_range (statutory_age_range_id, education_admissions_and_provision_id, lower_statutory_age, upper_statutory_age) VALUES ('7e88237c-f982-4bbc-9952-068d8fd678d9', 'ce70a8bc-099c-4653-acce-9acf1391ea1d', 2, 11);
INSERT INTO establishment.statutory_age_range (statutory_age_range_id, education_admissions_and_provision_id, lower_statutory_age, upper_statutory_age) VALUES ('d41877d7-a177-40d3-8c89-535bf693d508', '70c398e9-6086-42db-af7f-25a085a18a63', 4, 11);
INSERT INTO establishment.statutory_age_range (statutory_age_range_id, education_admissions_and_provision_id, lower_statutory_age, upper_statutory_age) VALUES ('4efb84c8-1eb4-476f-a80b-d15d73121f67', '50eeff36-cc0f-4dee-8290-f88d5e0d2cc5', 11, 16);


--
-- PostgreSQL database dump complete
--

\unrestrict 5WXoBZrgoPTHVdg5lokfX8vZzTxUwBTqokBlm2MkCEn1RbRuBRB6b6uMywU0ywj

