--
-- PostgreSQL database dump
--

\restrict FYqhfj4RPPInYySngIE9ZvEl5B0ZQWdf6tGYCzFvr4ZlfV7J8dTvyfBN5K4KGum

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
	('ebcebffe-2323-45b3-98b3-32579cba2ed3', 'THE CO-OPERATIVE ACADEMIES TRUST', NULL, NULL, '2011-08-19', NULL);


--
-- Data for Name: establishment_party_role; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_party_role (establishment_party_role_id, establishment_party_role_type_id, legal_entity_id, person_id, start_date, end_date) VALUES
	('72ae27b3-7348-48e5-95cb-41511933ae9e', 1, 'ebcebffe-2323-45b3-98b3-32579cba2ed3', NULL, NULL, NULL),
	('a449ab36-1a30-436d-87c5-23840ab58383', 4, 'ebcebffe-2323-45b3-98b3-32579cba2ed3', NULL, NULL, NULL);


--
-- Data for Name: academy_trust_classification; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.academy_trust_classification (academy_trust_classification_id, establishment_party_role_id, academy_trust_type_id, start_date, end_date) VALUES
	('d6bda026-1692-4e35-9afe-3e13ec6f48ef', '72ae27b3-7348-48e5-95cb-41511933ae9e', 2, NULL, NULL);


--
-- Data for Name: address; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.address (address_id, address_line_1, address_line_2, address_line_3, town, county, postcode) VALUES
	('eeb7d222-6578-4465-876a-ff9694920b73', 'obfuscated', NULL, 'obfuscated', 'obfuscated', '032', 'ST6 4LD');


--
-- Data for Name: establishment; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment (establishment_id, urn, ukprn, establishment_number, name, establishment_type_id, education_phase_id) VALUES
	('9660e373-15cd-4d65-8955-0d7065d6a9a0', 136102, 10030216, 6905, 'The Co-Operative Academy of Stoke-On-Trent', 4, 5);


--
-- Data for Name: capacity_and_pupil_measures; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.capacity_and_pupil_measures (capacity_and_pupil_measures_id, establishment_id, school_capacity, pupil_count, free_school_meal_measure, census_date) VALUES
	('b7156d3c-729f-46a3-80c8-a993dd9d3000', '9660e373-15cd-4d65-8955-0d7065d6a9a0', 1050, 1300, 735, NULL);


--
-- Data for Name: education_admissions_and_provision; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.education_admissions_and_provision (education_admissions_and_provision_id, establishment_id, gender_of_entry_type_id, admissions_policy_id, boarding_provision_id, nursery_provision_id, sixth_form_provision_id) VALUES
	('4ca62827-fcfe-4262-9273-ee053995906e', '9660e373-15cd-4d65-8955-0d7065d6a9a0', 1, 1, 1, 3, 3);


--
-- Data for Name: establishment_contact; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_contact (establishment_contact_id, establishment_id, website, telephone_number) VALUES
	('1a9b8eac-c742-4529-a5fa-7a7648dc8d18', '9660e373-15cd-4d65-8955-0d7065d6a9a0', 'http://www.cas.coop', '111111');


--
-- Data for Name: establishment_geography; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_geography (establishment_geography_id, establishment_id, local_authority_id, government_office_region_id, district_administrative_id, administrative_ward_id, parliamentary_constituency_id, lsoa_id, msoa_id, urban_rural_id) VALUES
	('1f6b1fe9-884a-402b-920c-04f6b8642e15', '9660e373-15cd-4d65-8955-0d7065d6a9a0', '3332ea83-bcbe-48d1-970d-a3650d9bcf10', '7ca695f4-dfcd-4f78-bdaf-17861eafbf97', '6ef1f577-d0bc-4698-951c-f202f9eaada6', 'e73f0fc2-114a-4772-a84e-5363b02ba34b', '714fb4a2-4d2e-4875-9853-1d7d6696559e', 'cec78739-d3a7-4831-9934-8dec5c5bdcd1', '5ed6445f-c41a-4778-9a5c-55ba74a2155b', '8826f875-fade-4b0b-a4b1-f8536505ecd1');


--
-- Data for Name: establishment_lifecycle; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_lifecycle (establishment_lifecycle_id, establishment_id, establishment_status_id, open_date, close_date, reason_establishment_opened_id, reason_establishment_closed_id, last_changed_date) VALUES
	('083a4384-071b-43cf-b950-5193efbff209', '9660e373-15cd-4d65-8955-0d7065d6a9a0', 1, '2010-09-01', NULL, 2, NULL, '2026-06-23');


--
-- Data for Name: establishment_responsibility; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_responsibility (establishment_responsibility_id, establishment_id, legal_entity_id, person_id, responsibility_type_id, start_date, end_date) VALUES
	('4ad44a7e-fde9-43dc-ad39-cc0a93c4140e', '9660e373-15cd-4d65-8955-0d7065d6a9a0', 'ebcebffe-2323-45b3-98b3-32579cba2ed3', NULL, 1, '2015-07-01', NULL),
	('f29945d6-05c5-49f7-a507-b5eb293282b2', '9660e373-15cd-4d65-8955-0d7065d6a9a0', 'ebcebffe-2323-45b3-98b3-32579cba2ed3', NULL, 3, '2010-09-01', NULL);


--
-- Data for Name: site; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.site (site_id, address_id, site_name, uprn) VALUES
	('cc7cab93-c9ea-446a-b165-04ebfb059b38', 'eeb7d222-6578-4465-876a-ff9694920b73', NULL, 3455015782);


--
-- Data for Name: establishment_to_site; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_to_site (establishment_id, site_id, is_main_site) VALUES
	('9660e373-15cd-4d65-8955-0d7065d6a9a0', 'cc7cab93-c9ea-446a-b165-04ebfb059b38', true);


--
-- Data for Name: organisation_group; Type: TABLE DATA; Schema: establishment; Owner: -
--



--
-- Data for Name: group_identifier; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.group_identifier (group_identifier_id, establishment_party_role_id, organisation_group_id, group_identifier_type_id, identifier_issuer_id, value, is_current) VALUES
	('eb7bdf39-6dc8-4c0a-98d3-70b5819d83e9', '72ae27b3-7348-48e5-95cb-41511933ae9e', NULL, 1, 1, '2777', true),
	('4b4b94d2-786c-4b2e-bf07-dda2e83f42be', '72ae27b3-7348-48e5-95cb-41511933ae9e', NULL, 2, 1, 'TR00567', true),
	('8c14caeb-1bfd-4f7a-8f69-0934f24ad45d', 'a449ab36-1a30-436d-87c5-23840ab58383', NULL, 1, 1, '4949', true),
	('0b94c16e-996e-42ce-b3dc-5d75c584c7b3', 'a449ab36-1a30-436d-87c5-23840ab58383', NULL, 2, 1, 'SP00125', true);


--
-- Data for Name: organisation_group_member; Type: TABLE DATA; Schema: establishment; Owner: -
--



--
-- Data for Name: organisation_identifier; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.organisation_identifier (organisation_identifier_id, legal_entity_id, organisation_identifier_type_id, value, is_current) VALUES
	('2ae3f3d0-ee36-4263-b2cf-77f15fe808d8', 'ebcebffe-2323-45b3-98b3-32579cba2ed3', 1, '07747126', true),
	('952c8151-6283-49fa-8bdd-e4358749aa09', 'ebcebffe-2323-45b3-98b3-32579cba2ed3', 2, '10059286', true);


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
	('7e0cdac3-b6f8-444f-8a74-8d12413a5433', '4ca62827-fcfe-4262-9273-ee053995906e', 11, 16);


--
-- PostgreSQL database dump complete
--

\unrestrict FYqhfj4RPPInYySngIE9ZvEl5B0ZQWdf6tGYCzFvr4ZlfV7J8dTvyfBN5K4KGum

