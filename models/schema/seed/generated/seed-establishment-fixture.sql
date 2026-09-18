--
-- PostgreSQL database dump
--

\restrict 2Uddyireeu6arSxbXVvHwojCNpPkIOmudjGXFd4LPdL77gvLDdyGAYe9Di6erdM

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

INSERT INTO establishment.address (address_id, address_line_1, address_line_2, address_line_3, town, county, postcode) VALUES ('29032302-c2c3-4fe7-b583-5326d17f8b76', 'obfuscated', NULL, NULL, 'obfuscated', '099', 'NW1 3EX');
INSERT INTO establishment.address (address_id, address_line_1, address_line_2, address_line_3, town, county, postcode) VALUES ('0a3e66a7-ff67-4f2c-8eba-52afa2a51ace', 'obfuscated', NULL, NULL, 'obfuscated', '019', 'WN7 3PQ');
INSERT INTO establishment.address (address_id, address_line_1, address_line_2, address_line_3, town, county, postcode) VALUES ('cb3e3875-1b0e-4eac-ae76-6a30369f471b', 'obfuscated', NULL, 'obfuscated', 'obfuscated', '032', 'ST6 4LD');


--
-- Data for Name: establishment; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment (establishment_id, urn, ukprn, establishment_number, name, establishment_type_id, education_phase_id) VALUES ('7adfc3ac-cd8c-4183-99c1-f1eb9c123a8f', 100018, 10069172, 2436, 'Netley Primary School & Centre for Autism', 1, 2);
INSERT INTO establishment.establishment (establishment_id, urn, ukprn, establishment_number, name, establishment_type_id, education_phase_id) VALUES ('f8b8f308-4fca-4558-8a1a-950b327bf734', 106431, 10072615, 2053, 'Gilded Hollins Community School', 1, 2);
INSERT INTO establishment.establishment (establishment_id, urn, ukprn, establishment_number, name, establishment_type_id, education_phase_id) VALUES ('bcf3a3a7-7ebe-4e94-95c2-142c6aee5c32', 136102, 10030216, 6905, 'The Co-Operative Academy of Stoke-On-Trent', 4, 5);


--
-- Data for Name: capacity_and_pupil_measures; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.capacity_and_pupil_measures (capacity_and_pupil_measures_id, establishment_id, school_capacity, pupil_count, free_school_meal_measure, census_date) VALUES ('9280ad50-c73c-4741-bc4a-2f87882b3e89', '7adfc3ac-cd8c-4183-99c1-f1eb9c123a8f', 65801, 383, 224, NULL);
INSERT INTO establishment.capacity_and_pupil_measures (capacity_and_pupil_measures_id, establishment_id, school_capacity, pupil_count, free_school_meal_measure, census_date) VALUES ('7b3ed55c-6b19-4ede-9333-7f103562e5b3', 'f8b8f308-4fca-4558-8a1a-950b327bf734', 22286, 209, 15, NULL);
INSERT INTO establishment.capacity_and_pupil_measures (capacity_and_pupil_measures_id, establishment_id, school_capacity, pupil_count, free_school_meal_measure, census_date) VALUES ('bbc409fc-7c48-48f8-8dce-8fbc46154b19', 'bcf3a3a7-7ebe-4e94-95c2-142c6aee5c32', 1050, 1300, 735, NULL);


--
-- Data for Name: education_admissions_and_provision; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.education_admissions_and_provision (education_admissions_and_provision_id, establishment_id, gender_of_entry_type_id, admissions_policy_id, boarding_provision_id, nursery_provision_id, sixth_form_provision_id) VALUES ('e779e33a-5249-43f0-acc0-86704568c6a7', '7adfc3ac-cd8c-4183-99c1-f1eb9c123a8f', 1, 3, 1, 1, 2);
INSERT INTO establishment.education_admissions_and_provision (education_admissions_and_provision_id, establishment_id, gender_of_entry_type_id, admissions_policy_id, boarding_provision_id, nursery_provision_id, sixth_form_provision_id) VALUES ('a4e58925-cf40-431d-ae1e-c9105a83344c', 'f8b8f308-4fca-4558-8a1a-950b327bf734', 1, 3, 1, 2, 2);
INSERT INTO establishment.education_admissions_and_provision (education_admissions_and_provision_id, establishment_id, gender_of_entry_type_id, admissions_policy_id, boarding_provision_id, nursery_provision_id, sixth_form_provision_id) VALUES ('3e984dd9-78e2-4bf0-8bb1-1cb911c21721', 'bcf3a3a7-7ebe-4e94-95c2-142c6aee5c32', 1, 1, 1, 3, 3);


--
-- Data for Name: establishment_contact; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_contact (establishment_contact_id, establishment_id, website, telephone_number) VALUES ('b9c01734-d7a2-453c-96b3-84b239f48eef', '7adfc3ac-cd8c-4183-99c1-f1eb9c123a8f', 'www.netley.camden.sch.uk/', '111111');
INSERT INTO establishment.establishment_contact (establishment_contact_id, establishment_id, website, telephone_number) VALUES ('632b6f9b-4830-481e-8248-f4b07467d1cd', 'f8b8f308-4fca-4558-8a1a-950b327bf734', 'www.gildedhollins.wigan.sch.uk/', '111111');
INSERT INTO establishment.establishment_contact (establishment_contact_id, establishment_id, website, telephone_number) VALUES ('af8b275c-c854-4404-b453-7d665fb425a2', 'bcf3a3a7-7ebe-4e94-95c2-142c6aee5c32', 'http://www.cas.coop', '111111');


--
-- Data for Name: establishment_geography; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_geography (establishment_geography_id, establishment_id, local_authority_id, government_office_region_id) VALUES ('eb2c34cf-4027-47c9-9424-34e88465bb13', '7adfc3ac-cd8c-4183-99c1-f1eb9c123a8f', '62ab8205-c94e-43eb-92ee-c66f767d50ad', '83a2bdc1-f953-4fd4-b171-7236e1e72f5a');
INSERT INTO establishment.establishment_geography (establishment_geography_id, establishment_id, local_authority_id, government_office_region_id) VALUES ('26081956-d9f7-438e-954b-99a567ea4849', 'f8b8f308-4fca-4558-8a1a-950b327bf734', '9209d19b-f883-4784-8b40-635c3afa0e9a', 'bcd24826-f4c1-42fd-b10f-a1c9f8dfdab9');
INSERT INTO establishment.establishment_geography (establishment_geography_id, establishment_id, local_authority_id, government_office_region_id) VALUES ('b325fef8-b750-464b-a093-ae5be5ffd98d', 'bcf3a3a7-7ebe-4e94-95c2-142c6aee5c32', 'c8f863e8-88a1-4105-895f-7229c914423e', '0f439fe1-5bb7-4246-b856-67b30114e097');


--
-- Data for Name: establishment_lifecycle; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_lifecycle (establishment_lifecycle_id, establishment_id, establishment_status_id, open_date, close_date, reason_establishment_opened_id, reason_establishment_closed_id, last_changed_date) VALUES ('2c4a3112-1b6f-4e66-a823-e78d6212f2bb', '7adfc3ac-cd8c-4183-99c1-f1eb9c123a8f', 1, NULL, NULL, NULL, NULL, '2026-06-23');
INSERT INTO establishment.establishment_lifecycle (establishment_lifecycle_id, establishment_id, establishment_status_id, open_date, close_date, reason_establishment_opened_id, reason_establishment_closed_id, last_changed_date) VALUES ('15df6ffe-a25b-43b5-bc85-3c5a95ec28d1', 'f8b8f308-4fca-4558-8a1a-950b327bf734', 1, NULL, NULL, NULL, NULL, '2026-06-23');
INSERT INTO establishment.establishment_lifecycle (establishment_lifecycle_id, establishment_id, establishment_status_id, open_date, close_date, reason_establishment_opened_id, reason_establishment_closed_id, last_changed_date) VALUES ('58d8757d-bfd2-4bd9-964e-742edcd213cf', 'bcf3a3a7-7ebe-4e94-95c2-142c6aee5c32', 1, '2010-09-01', NULL, 2, NULL, '2026-06-23');


--
-- Data for Name: site; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.site (site_id, address_id, site_name, uprn) VALUES ('53ccedb4-f76a-4736-bf85-d0d659eda351', '29032302-c2c3-4fe7-b583-5326d17f8b76', NULL, 5172210);
INSERT INTO establishment.site (site_id, address_id, site_name, uprn) VALUES ('9d531ab9-7143-4ce2-9f4c-10c4b03e9f7d', '0a3e66a7-ff67-4f2c-8eba-52afa2a51ace', NULL, 100012855917);
INSERT INTO establishment.site (site_id, address_id, site_name, uprn) VALUES ('14d4275a-2c93-4a8f-8850-02b9be1f8217', 'cb3e3875-1b0e-4eac-ae76-6a30369f471b', NULL, 3455015782);


--
-- Data for Name: establishment_to_site; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_to_site (establishment_id, site_id, is_main_site) VALUES ('7adfc3ac-cd8c-4183-99c1-f1eb9c123a8f', '53ccedb4-f76a-4736-bf85-d0d659eda351', true);
INSERT INTO establishment.establishment_to_site (establishment_id, site_id, is_main_site) VALUES ('f8b8f308-4fca-4558-8a1a-950b327bf734', '9d531ab9-7143-4ce2-9f4c-10c4b03e9f7d', true);
INSERT INTO establishment.establishment_to_site (establishment_id, site_id, is_main_site) VALUES ('bcf3a3a7-7ebe-4e94-95c2-142c6aee5c32', '14d4275a-2c93-4a8f-8850-02b9be1f8217', true);


--
-- Data for Name: specialist_provision; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.specialist_provision (specialist_provision_id, establishment_id, specialist_provision_type_id) VALUES ('c3e41e45-7eb6-4dac-9463-81f4c67bb9fd', '7adfc3ac-cd8c-4183-99c1-f1eb9c123a8f', 3);


--
-- Data for Name: resourced_provision; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.resourced_provision (resourced_provision_id, specialist_provision_id, capacity, pupil_count) VALUES ('7f6b3633-fc42-4857-92bf-b32a8e662f2e', 'c3e41e45-7eb6-4dac-9463-81f4c67bb9fd', 24, 24);


--
-- Data for Name: sen_unit_provision; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.sen_unit_provision (sen_unit_provision_id, specialist_provision_id, capacity, pupil_count) VALUES ('88eb748d-e78e-47c5-9663-a4fc6282b0df', 'c3e41e45-7eb6-4dac-9463-81f4c67bb9fd', 24, 24);


--
-- Data for Name: statutory_age_range; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.statutory_age_range (statutory_age_range_id, education_admissions_and_provision_id, lower_statutory_age, upper_statutory_age) VALUES ('634a3921-5944-4f76-a77f-02fbf71cc657', 'e779e33a-5249-43f0-acc0-86704568c6a7', 2, 11);
INSERT INTO establishment.statutory_age_range (statutory_age_range_id, education_admissions_and_provision_id, lower_statutory_age, upper_statutory_age) VALUES ('392ddad4-b207-4418-88d8-338bcdd6ea1e', 'a4e58925-cf40-431d-ae1e-c9105a83344c', 4, 11);
INSERT INTO establishment.statutory_age_range (statutory_age_range_id, education_admissions_and_provision_id, lower_statutory_age, upper_statutory_age) VALUES ('0e2b984d-61fe-4581-b25e-3ecc1f2d017e', '3e984dd9-78e2-4bf0-8bb1-1cb911c21721', 11, 16);


--
-- PostgreSQL database dump complete
--

\unrestrict 2Uddyireeu6arSxbXVvHwojCNpPkIOmudjGXFd4LPdL77gvLDdyGAYe9Di6erdM

