--
-- PostgreSQL database dump
--

\restrict bH0jFR5Et4ARWzcbEOsPN2QUTAIdwoYORh1MXzQEliTlwHmgpQ09ROnPcQXgVie

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
	('63eb52e2-5191-4ffc-9743-d34b0be8a1dd', 'THE CO-OPERATIVE ACADEMIES TRUST', NULL, NULL, '2011-08-19', NULL),
	('edacdfc8-9638-419b-ac17-0b03b2bd7526', 'HIVE EDUCATION TRUST', NULL, NULL, '2005-04-04', NULL),
	('fe43499f-ff6d-49eb-93db-5c5df27ace16', 'Diocese of London', NULL, NULL, NULL, NULL);


--
-- Data for Name: establishment_party_role; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_party_role (establishment_party_role_id, establishment_party_role_type_id, legal_entity_id, person_id, start_date, end_date) VALUES
	('766717db-7aaa-4c54-938b-298c903e8fb1', 1, '63eb52e2-5191-4ffc-9743-d34b0be8a1dd', NULL, NULL, NULL),
	('f97ea03c-c053-4ec5-914d-90e6d7e7f0a5', 4, '63eb52e2-5191-4ffc-9743-d34b0be8a1dd', NULL, NULL, NULL),
	('023fa782-aa07-40c1-8100-8761c28a3e9c', 1, 'edacdfc8-9638-419b-ac17-0b03b2bd7526', NULL, NULL, NULL),
	('e1012ff4-7c1a-4c12-a2a1-1e1f0ede5c21', 4, 'fe43499f-ff6d-49eb-93db-5c5df27ace16', NULL, NULL, NULL);


--
-- Data for Name: academy_trust_classification; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.academy_trust_classification (academy_trust_classification_id, establishment_party_role_id, academy_trust_type_id, start_date, end_date) VALUES
	('f4e7d2f2-117f-4fdf-8a94-2e3088f08320', '766717db-7aaa-4c54-938b-298c903e8fb1', 2, '2015-07-01', NULL),
	('83ff0160-7699-447a-a19a-ebc70232ed9d', '766717db-7aaa-4c54-938b-298c903e8fb1', 1, '2010-09-01', NULL),
	('90d0938f-e013-495f-ae18-24cf1a76fcbc', '023fa782-aa07-40c1-8100-8761c28a3e9c', 2, '2021-10-04', NULL);


--
-- Data for Name: address; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.address (address_id, address_line_1, address_line_2, address_line_3, town, county, postcode) VALUES
	('acdbb9e8-a45e-4abc-be71-02d81758f109', 'obfuscated', NULL, 'obfuscated', 'obfuscated', '032', 'ST6 4LD'),
	('a3a7ebee-866d-42bb-93b3-c75a71d62fb5', 'obfuscated', 'Islington', NULL, 'obfuscated', '099', 'N7 8PG');


--
-- Data for Name: establishment; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment (establishment_id, urn, ukprn, establishment_number, name, establishment_type_id, education_phase_id) VALUES
	('a5a7aa9d-b040-41fc-9e34-5b1f4dc20a90', 136102, 10030216, 6905, 'The Co-Operative Academy of Stoke-On-Trent', 4, 5),
	('a386c401-ac40-43fd-9296-fa1711605c5c', 134314, 10024207, 6905, 'St Mary Magdalene Academy', 4, 2);


--
-- Data for Name: capacity_and_pupil_measures; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.capacity_and_pupil_measures (capacity_and_pupil_measures_id, establishment_id, school_capacity, pupil_count, free_school_meal_measure, census_date) VALUES
	('d7c59398-3070-414d-9008-8b55dd414308', 'a5a7aa9d-b040-41fc-9e34-5b1f4dc20a90', 1050, 1300, 735, NULL),
	('ca1f6404-9a7e-4768-ba2d-ed6c806a5771', 'a386c401-ac40-43fd-9296-fa1711605c5c', 1310, 1561, 465, NULL);


--
-- Data for Name: education_admissions_and_provision; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.education_admissions_and_provision (education_admissions_and_provision_id, establishment_id, gender_of_entry_type_id, admissions_policy_id, boarding_provision_id, nursery_provision_id, sixth_form_provision_id) VALUES
	('93591bce-3416-4c0f-b8a2-322931c89f4c', 'a5a7aa9d-b040-41fc-9e34-5b1f4dc20a90', 1, 1, 1, 3, 3),
	('f1dcc061-ecf8-4453-896c-70bfd47db9b4', 'a386c401-ac40-43fd-9296-fa1711605c5c', 1, 1, 1, 2, 1);


--
-- Data for Name: establishment_contact; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_contact (establishment_contact_id, establishment_id, website, telephone_number) VALUES
	('149d8754-bc17-4de5-bf7c-2a0a8c705057', 'a5a7aa9d-b040-41fc-9e34-5b1f4dc20a90', 'http://www.cas.coop', '111111'),
	('b8d3edcc-64f0-431f-a64d-a60d6265e680', 'a386c401-ac40-43fd-9296-fa1711605c5c', 'www.smmacademy.org', '111111');


--
-- Data for Name: establishment_geography; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_geography (establishment_geography_id, establishment_id, local_authority_id, government_office_region_id, district_administrative_id, administrative_ward_id, parliamentary_constituency_id, lsoa_id, msoa_id, urban_rural_id) VALUES
	('24d51846-57b1-46de-8a26-e7b45f185ab5', 'a5a7aa9d-b040-41fc-9e34-5b1f4dc20a90', '3332ea83-bcbe-48d1-970d-a3650d9bcf10', '7ca695f4-dfcd-4f78-bdaf-17861eafbf97', '6ef1f577-d0bc-4698-951c-f202f9eaada6', 'e73f0fc2-114a-4772-a84e-5363b02ba34b', '714fb4a2-4d2e-4875-9853-1d7d6696559e', 'cec78739-d3a7-4831-9934-8dec5c5bdcd1', '5ed6445f-c41a-4778-9a5c-55ba74a2155b', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('63f8dc34-8e4b-43ab-8576-30e8d37c414c', 'a386c401-ac40-43fd-9296-fa1711605c5c', '3574e75c-8870-449a-82e7-1b083e2efc42', '1375841f-e6ba-4cda-9fac-753ff9df93a2', '9a5cfcfa-3605-4253-8e1c-fc081510a4ea', '9a2f2163-03c6-45b8-84e0-b34cc7a3450c', '6c7acd08-ad7f-406e-85e4-0bade3e57de6', '05aa5060-26b4-4edf-ad40-5e4640903d5a', '0d87ce8f-019d-4403-9527-975bbabd10e1', '8826f875-fade-4b0b-a4b1-f8536505ecd1');


--
-- Data for Name: establishment_lifecycle; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_lifecycle (establishment_lifecycle_id, establishment_id, establishment_status_id, open_date, close_date, reason_establishment_opened_id, reason_establishment_closed_id, last_changed_date) VALUES
	('27c84e88-1aef-43f7-9989-5dd78c8a307b', 'a5a7aa9d-b040-41fc-9e34-5b1f4dc20a90', 1, '2010-09-01', NULL, 2, NULL, '2026-06-23'),
	('11b57139-ed6a-499a-b4f9-9bee00f45e0d', 'a386c401-ac40-43fd-9296-fa1711605c5c', 1, '2007-09-01', NULL, 2, NULL, '2026-06-23');


--
-- Data for Name: establishment_responsibility; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_responsibility (establishment_responsibility_id, establishment_id, legal_entity_id, person_id, responsibility_type_id, start_date, end_date) VALUES
	('3f158594-5513-459b-91a1-4334f53236e1', 'a5a7aa9d-b040-41fc-9e34-5b1f4dc20a90', '63eb52e2-5191-4ffc-9743-d34b0be8a1dd', NULL, 1, '2015-07-01', NULL),
	('bb8ed067-4cbd-4d95-914f-4c420503e3a4', 'a5a7aa9d-b040-41fc-9e34-5b1f4dc20a90', '63eb52e2-5191-4ffc-9743-d34b0be8a1dd', NULL, 1, '2010-09-01', NULL),
	('85817847-84ff-4d2f-aeb0-4e18a7b74a8d', 'a5a7aa9d-b040-41fc-9e34-5b1f4dc20a90', '63eb52e2-5191-4ffc-9743-d34b0be8a1dd', NULL, 3, '2010-09-01', NULL),
	('4de808bc-9be4-45f1-ad79-a58c8fbe5bba', 'a386c401-ac40-43fd-9296-fa1711605c5c', 'edacdfc8-9638-419b-ac17-0b03b2bd7526', NULL, 1, '2021-10-04', NULL),
	('e09e15fb-0c71-4800-8358-6fb7a707409e', 'a386c401-ac40-43fd-9296-fa1711605c5c', 'edacdfc8-9638-419b-ac17-0b03b2bd7526', NULL, 1, '2007-09-01', NULL),
	('2e66c95f-20fa-4b7a-89e2-78b27889d19e', 'a386c401-ac40-43fd-9296-fa1711605c5c', 'fe43499f-ff6d-49eb-93db-5c5df27ace16', NULL, 3, '2007-09-01', NULL);


--
-- Data for Name: site; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.site (site_id, address_id, site_name, uprn) VALUES
	('b13928fc-6e1a-4333-ac8a-97087063c579', 'acdbb9e8-a45e-4abc-be71-02d81758f109', NULL, 3455015782),
	('32ee84c1-ff48-4ba5-858a-4d180f724959', 'a3a7ebee-866d-42bb-93b3-c75a71d62fb5', NULL, 5300060053);


--
-- Data for Name: establishment_to_site; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_to_site (establishment_id, site_id, is_main_site) VALUES
	('a5a7aa9d-b040-41fc-9e34-5b1f4dc20a90', 'b13928fc-6e1a-4333-ac8a-97087063c579', true),
	('a386c401-ac40-43fd-9296-fa1711605c5c', '32ee84c1-ff48-4ba5-858a-4d180f724959', true);


--
-- Data for Name: organisation_group; Type: TABLE DATA; Schema: establishment; Owner: -
--



--
-- Data for Name: group_identifier; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.group_identifier (group_identifier_id, establishment_party_role_id, organisation_group_id, group_identifier_type_id, identifier_issuer_id, value, is_current) VALUES
	('90ff647b-b8cd-4eaa-b4c6-b9a31704ee8d', '766717db-7aaa-4c54-938b-298c903e8fb1', NULL, 1, 1, '2777', true),
	('e83174a6-93ed-4b15-8aef-300f3140081c', '766717db-7aaa-4c54-938b-298c903e8fb1', NULL, 2, 1, 'TR00567', true),
	('4b9ea513-65fa-436c-a745-28fe489c448d', '766717db-7aaa-4c54-938b-298c903e8fb1', NULL, 1, 1, '2779', false),
	('865abba7-68b0-49e0-abbc-1d8fe4c87b20', '766717db-7aaa-4c54-938b-298c903e8fb1', NULL, 2, 1, 'TR00569', false),
	('6b1e4056-a2a3-4e0c-bb8b-e3eb61a42e32', 'f97ea03c-c053-4ec5-914d-90e6d7e7f0a5', NULL, 1, 1, '4949', true),
	('f0c8b599-8cf9-4b9c-8b3e-98160fe0fc94', 'f97ea03c-c053-4ec5-914d-90e6d7e7f0a5', NULL, 2, 1, 'SP00125', true),
	('ab6b47ed-a6c2-4a67-a62e-096821c8f89b', '023fa782-aa07-40c1-8100-8761c28a3e9c', NULL, 1, 1, '23869', true),
	('3b625fa2-5baf-49a1-90e1-209613c10659', '023fa782-aa07-40c1-8100-8761c28a3e9c', NULL, 2, 1, 'TR02103', true),
	('6e28f486-c354-46a5-a356-6272e5327338', '023fa782-aa07-40c1-8100-8761c28a3e9c', NULL, 1, 1, '4737', false),
	('2bc6de20-5952-477b-b3a8-2b6be4187a21', 'e1012ff4-7c1a-4c12-a2a1-1e1f0ede5c21', NULL, 1, 1, '2914', true),
	('e264f855-aa92-4ae3-8393-f3713bc65e03', 'e1012ff4-7c1a-4c12-a2a1-1e1f0ede5c21', NULL, 2, 1, 'SP00172', true);


--
-- Data for Name: organisation_group_member; Type: TABLE DATA; Schema: establishment; Owner: -
--



--
-- Data for Name: organisation_identifier; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.organisation_identifier (organisation_identifier_id, legal_entity_id, organisation_identifier_type_id, value, is_current) VALUES
	('9a4636d4-2215-43e0-9b40-0b8daa542551', '63eb52e2-5191-4ffc-9743-d34b0be8a1dd', 1, '07747126', true),
	('b0f4f8b0-a42c-47bd-94b2-8d8f4c8327b7', '63eb52e2-5191-4ffc-9743-d34b0be8a1dd', 2, '10059286', true),
	('0d8ad996-40b9-47c7-a40a-658bf6a275d5', 'edacdfc8-9638-419b-ac17-0b03b2bd7526', 1, '05412502', true),
	('d429c903-3ad7-4efa-8c79-b5a43d1ddf54', 'edacdfc8-9638-419b-ac17-0b03b2bd7526', 2, '10058191', true);


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
	('ce4bd8a8-12eb-45f1-ae6e-834c58468d55', '93591bce-3416-4c0f-b8a2-322931c89f4c', 11, 16),
	('3e097a87-b7f1-40a2-8f9f-bbf0187cc162', 'f1dcc061-ecf8-4453-896c-70bfd47db9b4', 4, 19);


--
-- PostgreSQL database dump complete
--

\unrestrict bH0jFR5Et4ARWzcbEOsPN2QUTAIdwoYORh1MXzQEliTlwHmgpQ09ROnPcQXgVie

