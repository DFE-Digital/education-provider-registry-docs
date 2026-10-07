--
-- PostgreSQL database dump
--

\restrict 7ycW4tSOH4crXIWorglsWHgKdozOPtxa6YmgqAebt4pV50EfqcOukkU0Oqvtp24

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
	('dfe2042e-da1c-4767-aea0-8fce23d37527', 'THE CO-OPERATIVE ACADEMIES TRUST', 1, NULL, '2011-08-19', NULL),
	('9859a07f-61c0-4845-a976-9adda9fdf604', 'THE CO-OPERATIVE ACADEMY OF STOKE ON TRENT', 1, NULL, '2010-02-16', NULL),
	('a2dcd133-77fc-40d6-8b7f-6f9655aceb7e', 'The Co-operative Group', NULL, NULL, NULL, NULL),
	('bc20aa22-6e2b-4c8e-b8ae-484a6e55067b', 'HIVE EDUCATION TRUST', 1, NULL, '2005-04-04', NULL),
	('993b8053-8d32-4351-b6b0-49f343e58883', 'Diocese of London', NULL, NULL, NULL, NULL),
	('776a7bee-cbf4-48e8-ad8b-c2e1e3d79302', 'MARCH 2016 LIMITED', 1, NULL, '2009-04-27', NULL),
	('e1f70fda-02c0-4fab-92be-ff514f767637', 'THE ACADEMY @ RIDGEWOOD TRUST', 1, NULL, '2011-10-03', NULL),
	('43e519c2-8b3e-473e-990d-583f4a500402', 'The North Tyneside Learning Trust', NULL, NULL, NULL, NULL),
	('7eadb097-76e1-48da-aeb2-9268c1dbb859', 'DUNSTONE EDUCATION TRUST', 1, NULL, '2009-07-13', NULL),
	('5be037f1-12fc-4b40-829c-4135c96fc783', 'Acorn Care and Education Ltd', NULL, NULL, NULL, NULL);


--
-- Data for Name: academy_trust_classification; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.academy_trust_classification (academy_trust_classification_id, legal_entity_id, academy_trust_type_id, start_date, end_date, is_current) VALUES
	('105c06f2-f48c-424c-a873-26d753df4790', 'dfe2042e-da1c-4767-aea0-8fce23d37527', 2, NULL, NULL, true),
	('f0974324-e383-407e-94d1-590a805b042c', '9859a07f-61c0-4845-a976-9adda9fdf604', 1, NULL, NULL, false),
	('801578ea-60cc-423e-aba3-5fd253cdaf96', 'bc20aa22-6e2b-4c8e-b8ae-484a6e55067b', 2, NULL, NULL, true),
	('f50bc361-dd2c-4c65-aeb7-08c8b2d8f8a5', 'bc20aa22-6e2b-4c8e-b8ae-484a6e55067b', 1, NULL, NULL, false),
	('98d9f377-c578-4846-a65d-c9610aa6022d', '776a7bee-cbf4-48e8-ad8b-c2e1e3d79302', 2, NULL, '2016-02-29', false),
	('d1f41d8c-cbdf-4d66-a74b-149b416ca049', 'e1f70fda-02c0-4fab-92be-ff514f767637', 1, NULL, '2021-03-30', false),
	('6bb2d26f-b952-49aa-a449-4a8255c3b9f3', 'e1f70fda-02c0-4fab-92be-ff514f767637', 2, '2021-03-30', NULL, true),
	('f5b3493b-78bc-4aa7-a239-967fba6ffa54', '7eadb097-76e1-48da-aeb2-9268c1dbb859', 2, NULL, NULL, true);


--
-- Data for Name: address; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.address (address_id, address_line_1, address_line_2, address_line_3, town, county, postcode) VALUES
	('a5daa9c7-7af9-4828-b010-07934548b583', 'obfuscated', NULL, 'obfuscated', 'obfuscated', '032', 'ST6 4LD'),
	('91004993-f6de-48f7-b423-bc3286126ce9', 'obfuscated', 'Islington', NULL, 'obfuscated', '099', 'N7 8PG'),
	('9939ff34-0583-4419-9bfd-fd73fc03bc58', 'obfuscated', 'Blackley', NULL, 'obfuscated', '099', 'M9 7SS'),
	('aa3b6198-4149-4bc1-aac8-1f2908403616', 'obfuscated', 'Scawsby', NULL, 'obfuscated', '031', 'DN5 7UB'),
	('475012a9-27af-484f-b7a4-c5055c77acce', 'obfuscated', 'Upper Dean', NULL, 'obfuscated', '003', 'PE28 0ND'),
	('b6f4b0a2-cd61-422e-b714-eb1e77dd8184', 'obfuscated', 'Milton Ernest', NULL, 'obfuscated', '001', 'MK44 1RF'),
	('aab35982-d47d-4273-b8d1-36f7fb0523c7', 'obfuscated', 'School Way', 'obfuscated', 'obfuscated', '012', 'SS9 4HX'),
	('3220aecd-7511-4446-86b4-d0bef01cf62c', 'obfuscated', NULL, NULL, 'obfuscated', '012', 'SS1 1ES'),
	('3409b380-132c-4efd-b5f5-91a9b58e4783', NULL, 'Centre Place', 'obfuscated', 'obfuscated', '012', 'SS1 2JD'),
	('6110a1eb-f1fb-4365-b767-6e87567804ef', 'obfuscated', 'Hamstel Road', NULL, 'obfuscated', '012', 'SS2 4PQ'),
	('f05c95b6-6083-46fc-9281-c75733cde636', 'obfuscated', NULL, NULL, 'obfuscated', '012', 'SS0 0LG'),
	('fe39e4fc-e2ea-404b-b1ba-64f96052a477', 'obfuscated', 'Constable Way', NULL, 'obfuscated', '012', 'SS3 9XX'),
	('0b13c33d-5e57-4a4a-a395-04372c0f921e', 'obfuscated', NULL, NULL, 'obfuscated', '012', 'SS0 7AU'),
	('ff363e38-ca3a-41ad-a093-c9ba3755436b', 'obfuscated', 'Rayleigh Road', 'obfuscated', 'obfuscated', '012', 'SS9 5UT'),
	('cd62ef0a-225d-4e21-8838-103236b0b625', 'obfuscated', 'Eastern Avenue', NULL, 'obfuscated', '012', 'SS2 4BA'),
	('1b2b950d-5efe-4074-90d0-937e7f1ffc29', 'obfuscated', NULL, NULL, 'obfuscated', '035', 'NE28 9RT'),
	('00950ccf-c7eb-4a71-b236-5bab0691e717', 'obfuscated', NULL, 'obfuscated', 'obfuscated', '019', 'PR2 9YR'),
	('cff76d2a-8cc0-4da2-8dbb-6e84dec839d4', 'Kirkby Lonsdale', NULL, NULL, 'Carnforth', '019', 'LA6 2DZ'),
	('9929ab31-b89d-475d-b2b4-8dc59176152e', 'Egerton Road', 'Charing Heath', NULL, 'Ashford', '018', 'TN27 0AX');


--
-- Data for Name: establishment; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment (establishment_id, urn, ukprn, establishment_number, name, establishment_type_id, education_phase_id) VALUES
	('9b21ef6f-c85d-4ac0-825d-edad0330cbc1', 136102, 10030216, 6905, 'The Co-Operative Academy of Stoke-On-Trent', 4, 5),
	('dcd8fd8b-4641-45d3-adb7-e06a6ecc9737', 134314, 10024207, 6905, 'St Mary Magdalene Academy', 4, 6),
	('57cc0fc6-757f-4b8b-a5c7-08652eb70e36', 135905, NULL, 6910, 'Manchester Creative and Media Academy', 4, 5),
	('c15013fe-be17-47e1-b47b-cd4c044b5f4f', 137603, 10035482, 4033, 'Ridgewood School', 4, 5),
	('a17562ec-7130-4510-b7cb-64ab66bacb72', 109443, 10077509, 2036, 'Eileen Wade Primary School', 11, 2),
	('9177ea85-b756-4b21-bc78-9f21e00e3492', 109613, 10075753, 3023, 'Milton Ernest CofE Primary School', 10, 2),
	('d24aa603-aa93-4b5f-85c5-550ec43d7023', 20338, NULL, NULL, 'Blenheim Children''s Centre', 35, 8),
	('2e38ad9e-6a0f-4ac9-a922-489c591f6be2', 20549, NULL, NULL, 'Cambridge Road Children''s Centre', 35, 8),
	('f6f736ac-d890-4d30-9df3-a2bae1aac7b7', 20614, NULL, NULL, 'Centre Place Family Centre', 35, 8),
	('4edcc202-50c4-497b-a3b0-7e39b0235eba', 21363, NULL, NULL, 'Hamstel Children and Family Centre', 35, 8),
	('3ad703d3-5dc8-4c9f-b029-f4f28aa98bde', 22422, NULL, NULL, 'Prince Avenue Children and Family Centre', 35, 8),
	('ea1816ff-8f2e-4111-a8d2-03b9822e8a72', 22459, NULL, NULL, 'Friars Children''s Centre', 35, 8),
	('ef51e563-54e8-42f9-ae12-4d641d476916', 22975, NULL, NULL, 'Summercourt Children''s Centre', 35, 8),
	('eb5da956-27ec-4390-8000-5b6d994fdd6d', 23004, NULL, NULL, 'Eastwood Children''s Centre', 35, 8),
	('816961d9-c8e1-45cb-a5fe-c630adb65efb', 23122, NULL, NULL, 'Temple Sutton Children''s Centre', 35, 8),
	('9e0c0107-9b95-43a7-81dc-bf7d63c9e0ca', 132141, 10073628, 2087, 'Hadrian Park Primary School', 11, 2),
	('58208db3-bd61-462b-9fcd-05aca4cd1938', 135936, 10027711, 6906, 'Fulwood Academy', 4, 5),
	('de42f1f7-e41f-4929-a4b8-5e18c042b02f', 112461, 10015990, 6044, 'Underley Garden School', 15, 8),
	('8d1b2f6d-f447-4965-ad13-40f6a091d66a', 119009, 10015772, 6060, 'Heath Farm School', 15, 8);


--
-- Data for Name: capacity_and_pupil_measures; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.capacity_and_pupil_measures (capacity_and_pupil_measures_id, establishment_id, school_capacity, pupil_count, free_school_meal_measure, census_date) VALUES
	('80229a0a-88d3-41e1-b337-763a54d3413d', '9b21ef6f-c85d-4ac0-825d-edad0330cbc1', 1050, 1300, 735, NULL),
	('59896eee-6e37-42e0-b25c-e20244881c63', 'dcd8fd8b-4641-45d3-adb7-e06a6ecc9737', 1310, 1561, 465, NULL),
	('24095bdf-f3fb-4307-a595-8bc1fa8bb7b5', '57cc0fc6-757f-4b8b-a5c7-08652eb70e36', 660, NULL, NULL, NULL),
	('b96f5ca5-fda9-47ff-9020-5b49a467ed21', 'c15013fe-be17-47e1-b47b-cd4c044b5f4f', 1512, 1425, 250, NULL),
	('b5fea46f-5d5d-4158-909d-d09e5cde6eee', 'a17562ec-7130-4510-b7cb-64ab66bacb72', 23610, 70, 10, NULL),
	('4391273b-30f3-44f8-bec6-ec0146a37e1b', '9177ea85-b756-4b21-bc78-9f21e00e3492', 63964, 67, 5, NULL),
	('9d6e225b-87de-435f-9b6a-104654aebe79', '9e0c0107-9b95-43a7-81dc-bf7d63c9e0ca', 965, 422, 114, NULL),
	('eaa6bb2b-4cfb-4028-801e-4cf047fbf95f', '58208db3-bd61-462b-9fcd-05aca4cd1938', 1000, 973, 418, NULL),
	('0c2fefd5-0466-4f01-a72e-cca3ffcb5382', 'de42f1f7-e41f-4929-a4b8-5e18c042b02f', 84881, 101, NULL, NULL),
	('8615a773-7046-48f4-bdc4-7775ec1136d8', '8d1b2f6d-f447-4965-ad13-40f6a091d66a', 20643, 141, NULL, NULL);


--
-- Data for Name: education_admissions_and_provision; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.education_admissions_and_provision (education_admissions_and_provision_id, establishment_id, gender_of_entry_type_id, admissions_policy_id, boarding_provision_id, nursery_provision_id, sixth_form_provision_id) VALUES
	('7cd6d559-b290-4d44-bcf6-551ebe6aa04f', '9b21ef6f-c85d-4ac0-825d-edad0330cbc1', 1, 1, 1, 3, 3),
	('62a38374-77f6-4e71-885d-cfe8be75ba14', 'dcd8fd8b-4641-45d3-adb7-e06a6ecc9737', 1, 1, 1, 2, 1),
	('e8aa83f7-6f7c-4b31-b138-051e61da562c', '57cc0fc6-757f-4b8b-a5c7-08652eb70e36', 1, 1, 1, 3, 1),
	('f87b18cc-d1a0-41f8-af57-25dfc4c8538b', 'c15013fe-be17-47e1-b47b-cd4c044b5f4f', 1, 1, 1, 3, 1),
	('4cfde20f-cf16-4f28-914d-fb097a7435f5', 'a17562ec-7130-4510-b7cb-64ab66bacb72', 1, 3, 1, 2, 2),
	('67a0d9f9-2ac5-4cf0-8f43-27255996a989', '9177ea85-b756-4b21-bc78-9f21e00e3492', 1, 3, 1, 2, 2),
	('9c8d28f9-9a6a-4792-909e-575343dbb31d', 'd24aa603-aa93-4b5f-85c5-550ec43d7023', NULL, 3, NULL, 3, 3),
	('6ca36058-d34b-46ac-872b-9242f0e42fd7', '2e38ad9e-6a0f-4ac9-a922-489c591f6be2', NULL, 3, NULL, 3, 3),
	('581c5db1-6c91-4824-92dd-fcaad43c8be7', 'f6f736ac-d890-4d30-9df3-a2bae1aac7b7', NULL, 3, NULL, 3, 3),
	('a5f7ee5c-4a79-4cf1-b4e3-10ce9ba66aad', '4edcc202-50c4-497b-a3b0-7e39b0235eba', NULL, 3, NULL, 3, 3),
	('a33c822f-68cb-43ae-83fd-0b1f2e3d4dce', '3ad703d3-5dc8-4c9f-b029-f4f28aa98bde', NULL, 3, NULL, 3, 3),
	('67098356-5bf7-45c3-948d-18ca53d8c9d8', 'ea1816ff-8f2e-4111-a8d2-03b9822e8a72', NULL, 3, NULL, 3, 3),
	('df21cf3c-f7da-434e-be72-b1b84611a16a', 'ef51e563-54e8-42f9-ae12-4d641d476916', NULL, 3, NULL, 3, 3),
	('deee308c-ddf1-40e5-8c5c-7838ce0d03cd', 'eb5da956-27ec-4390-8000-5b6d994fdd6d', NULL, 3, NULL, 3, 3),
	('775c4ad7-8e4c-4e05-8b1f-be293370a67a', '816961d9-c8e1-45cb-a5fe-c630adb65efb', NULL, 3, NULL, 3, 3),
	('f707b656-22ec-49ea-92c3-a572fe31cb5e', '9e0c0107-9b95-43a7-81dc-bf7d63c9e0ca', 1, 3, 1, 1, 2),
	('d5c2a85a-5538-4546-b87f-694f5705ef0c', '58208db3-bd61-462b-9fcd-05aca4cd1938', 1, 1, 1, 3, 2),
	('98146712-d7a6-4f23-8787-88eda991f6da', 'de42f1f7-e41f-4929-a4b8-5e18c042b02f', 1, 2, 3, 3, 1),
	('9161d6fa-b724-4d6f-9566-675c70a969b4', '8d1b2f6d-f447-4965-ad13-40f6a091d66a', 1, NULL, 1, 2, 1);


--
-- Data for Name: establishment_contact; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_contact (establishment_contact_id, establishment_id, website, telephone_number) VALUES
	('532db1eb-b0a7-447d-a0d8-b5a3a639fa8c', '9b21ef6f-c85d-4ac0-825d-edad0330cbc1', 'http://www.cas.coop', '111111'),
	('c3f7d3a1-4b60-48b5-ac62-bcae6e30b7fa', 'dcd8fd8b-4641-45d3-adb7-e06a6ecc9737', 'www.smmacademy.org', '111111'),
	('b1ca2bbc-7bcb-4391-b0ec-22d80bce7408', 'c15013fe-be17-47e1-b47b-cd4c044b5f4f', 'http://www.ridgewoodschool.co.uk', '111111'),
	('625dfc22-dab9-4dab-8259-0bc07e515223', 'a17562ec-7130-4510-b7cb-64ab66bacb72', 'www.ewmeschools.org.uk', '111111'),
	('dca0999c-0b63-427b-b5d7-bc866dd0991d', '9177ea85-b756-4b21-bc78-9f21e00e3492', 'www.ewmeschools.org.uk', '111111'),
	('60a354a0-1a4b-49e7-868f-60b21acab2bd', 'd24aa603-aa93-4b5f-85c5-550ec43d7023', NULL, '111111'),
	('f623970d-ff3c-4214-90c0-8cf691df399e', '2e38ad9e-6a0f-4ac9-a922-489c591f6be2', NULL, '111111'),
	('4d19734a-da45-4213-bc98-54738fc2ff88', 'f6f736ac-d890-4d30-9df3-a2bae1aac7b7', NULL, '111111'),
	('d5290cb1-101c-48cc-9997-451142105b92', '4edcc202-50c4-497b-a3b0-7e39b0235eba', NULL, '111111'),
	('10853ab8-b000-4e75-890f-39405279b948', '3ad703d3-5dc8-4c9f-b029-f4f28aa98bde', NULL, '111111'),
	('a78df191-e22f-400e-be46-c9421405cb46', 'ea1816ff-8f2e-4111-a8d2-03b9822e8a72', NULL, '111111'),
	('20a1923b-40bf-4ec6-b165-6133faa4cfa1', 'ef51e563-54e8-42f9-ae12-4d641d476916', NULL, '111111'),
	('970805a2-51f1-4b6e-a4c1-34717f77b826', 'eb5da956-27ec-4390-8000-5b6d994fdd6d', NULL, '111111'),
	('7dae740f-2037-401c-bae5-a16ffedb48f9', '816961d9-c8e1-45cb-a5fe-c630adb65efb', NULL, '111111'),
	('717a1324-5b09-4c7a-bc96-127c698c9ad6', '9e0c0107-9b95-43a7-81dc-bf7d63c9e0ca', 'www.hadrianparkprimary.org.uk/', '111111'),
	('82b488cb-71c8-4a1a-8e40-39258dd8c435', '58208db3-bd61-462b-9fcd-05aca4cd1938', 'http://www.fulwoodacademy.co.uk/', '111111'),
	('323382a0-12a6-428f-b6e6-12fd9d6fb8e9', 'de42f1f7-e41f-4929-a4b8-5e18c042b02f', 'www.underleygarden.org', '111111'),
	('e1e74366-c77f-49bc-8024-732edd6b7d18', '8d1b2f6d-f447-4965-ad13-40f6a091d66a', NULL, '111111');


--
-- Data for Name: establishment_geography; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_geography (establishment_geography_id, establishment_id, local_authority_id, government_office_region_id, district_administrative_id, administrative_ward_id, parliamentary_constituency_id, lsoa_id, msoa_id, urban_rural_id) VALUES
	('b2a5ea3b-bef1-443d-99ce-4dbe68caf277', '9b21ef6f-c85d-4ac0-825d-edad0330cbc1', '3332ea83-bcbe-48d1-970d-a3650d9bcf10', '7ca695f4-dfcd-4f78-bdaf-17861eafbf97', '6ef1f577-d0bc-4698-951c-f202f9eaada6', 'e73f0fc2-114a-4772-a84e-5363b02ba34b', '714fb4a2-4d2e-4875-9853-1d7d6696559e', 'cec78739-d3a7-4831-9934-8dec5c5bdcd1', '5ed6445f-c41a-4778-9a5c-55ba74a2155b', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('0ce12430-6039-44de-aa43-b7214ba286b0', 'dcd8fd8b-4641-45d3-adb7-e06a6ecc9737', '3574e75c-8870-449a-82e7-1b083e2efc42', '1375841f-e6ba-4cda-9fac-753ff9df93a2', '9a5cfcfa-3605-4253-8e1c-fc081510a4ea', '9a2f2163-03c6-45b8-84e0-b34cc7a3450c', '6c7acd08-ad7f-406e-85e4-0bade3e57de6', '05aa5060-26b4-4edf-ad40-5e4640903d5a', '0d87ce8f-019d-4403-9527-975bbabd10e1', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('3f1b5ee9-0e11-4b41-81af-b2f3135c2856', '57cc0fc6-757f-4b8b-a5c7-08652eb70e36', '0a78f87e-d71b-44c3-b598-2cc2b8038e95', '489dce3e-58d7-44c5-b9ef-2f7d7cbdb592', 'c8efb411-9c6d-492e-af1e-624ed743712f', 'f22dfd05-c647-403a-bebd-69fb3a62cca6', '93b33a64-95d1-4d7f-9142-4acc73221e9a', '22d38930-6da2-4b70-9bca-6208cbb43ba5', 'cddc19f9-9b91-4e98-a4c8-656753fd673c', 'fba31373-6bf1-4ad2-9d63-a2c783849aad'),
	('9df3b26c-135f-4849-964e-a6dd07745c38', 'c15013fe-be17-47e1-b47b-cd4c044b5f4f', '77b9cfe6-842e-41c8-9be4-410cac32719a', 'f5cdf1f1-5f75-4420-b597-862614e13549', '05471fcf-d815-4c82-a7f6-6a9ff75cdaa2', 'cf41c2bc-c0cc-4394-992e-1db6d9f032dd', '8d116d07-483e-41bc-83ea-00c89c3f3a6d', 'c4402a6f-a614-4961-a889-554ef686642a', '011465c5-0d85-498d-8b85-14ea8833c9d5', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('5da42c5a-9cb6-421e-80b2-9ab032dd462e', 'a17562ec-7130-4510-b7cb-64ab66bacb72', '942f0927-84a7-43b6-8be9-68f88917b043', '32e46d74-0ebf-495b-8261-2c508cd2c2bb', '1146af1e-822e-49f1-a51e-da31f849045c', 'f08ea39d-20ae-4f5e-8274-15207e7b5eec', 'd180f323-3f6f-44dc-a1de-d1cac6e11c0c', '84494da7-5525-4dc5-a454-83a2b9b7bdc0', 'bc444798-7011-43c1-a1e2-269efd7885ef', '1c041cb3-373a-4dd5-9af4-2950293776bc'),
	('5915024a-4ec2-44bc-a7cb-495d633f9052', '9177ea85-b756-4b21-bc78-9f21e00e3492', '942f0927-84a7-43b6-8be9-68f88917b043', '32e46d74-0ebf-495b-8261-2c508cd2c2bb', '1146af1e-822e-49f1-a51e-da31f849045c', 'f08ea39d-20ae-4f5e-8274-15207e7b5eec', 'd180f323-3f6f-44dc-a1de-d1cac6e11c0c', '534b5a89-c075-4962-8367-8c8ffc158b9e', 'edc1ad99-4391-4d91-8717-6c10929ae180', '1c041cb3-373a-4dd5-9af4-2950293776bc'),
	('f83743ae-15ac-4502-9ac5-3606989e4103', 'd24aa603-aa93-4b5f-85c5-550ec43d7023', 'dc9f9e86-8d80-46b7-87bc-e998cafca819', '32e46d74-0ebf-495b-8261-2c508cd2c2bb', '38ab2b8e-4373-4176-8944-4c6d8cffa7d8', 'c21f6874-6733-4b9b-bc1a-b54fbb495ac9', 'c487eba0-9903-4df2-b999-20f1cca784fb', '84badc4c-a7f2-4af6-8532-8ebf665e5686', '0d9136b3-d6e1-4143-bc20-59738dffb35b', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('73e38304-0ade-4ab3-9ce3-a933044adc18', '2e38ad9e-6a0f-4ac9-a922-489c591f6be2', 'dc9f9e86-8d80-46b7-87bc-e998cafca819', '32e46d74-0ebf-495b-8261-2c508cd2c2bb', '38ab2b8e-4373-4176-8944-4c6d8cffa7d8', '0af643ac-6840-48a4-8ed7-dc98ad8626a9', '485e8a03-6bd3-4c3b-95d6-baf2f9b44cad', 'd7b13e80-761e-4cb2-b40f-0dfb91095689', '6c891a27-897f-41ec-ac35-7e207d4fead3', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('66daea34-fb0f-41a6-92cb-6cd7c3c6bcac', 'f6f736ac-d890-4d30-9df3-a2bae1aac7b7', 'dc9f9e86-8d80-46b7-87bc-e998cafca819', '32e46d74-0ebf-495b-8261-2c508cd2c2bb', '38ab2b8e-4373-4176-8944-4c6d8cffa7d8', '28286c17-e7ea-4022-b909-1a6b60808185', '485e8a03-6bd3-4c3b-95d6-baf2f9b44cad', '56a40580-3dbd-4d1f-bdaa-54370f39b26d', 'd40b3466-6329-406a-93f7-a4978722af70', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('b37548ea-c753-4310-a0b1-6da90042627d', '4edcc202-50c4-497b-a3b0-7e39b0235eba', 'dc9f9e86-8d80-46b7-87bc-e998cafca819', '32e46d74-0ebf-495b-8261-2c508cd2c2bb', '38ab2b8e-4373-4176-8944-4c6d8cffa7d8', 'bdd0a9a0-8af5-4232-b7ce-30a76be572ca', '485e8a03-6bd3-4c3b-95d6-baf2f9b44cad', 'e8b85e8f-e837-4dd2-9ac3-b3f22e6f83a6', '5a9caa00-1c9c-49c6-ba30-dd3df2b2599f', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('307ad360-8caf-45a0-b906-2f6cb2c18090', '3ad703d3-5dc8-4c9f-b029-f4f28aa98bde', 'dc9f9e86-8d80-46b7-87bc-e998cafca819', '32e46d74-0ebf-495b-8261-2c508cd2c2bb', '38ab2b8e-4373-4176-8944-4c6d8cffa7d8', '1bcfab2c-6971-4998-9c38-55c1e039be68', 'c487eba0-9903-4df2-b999-20f1cca784fb', '52692e65-37ae-4851-9b83-d318448b8a15', '35b2356d-cad3-415a-af7d-dc32bd148ae2', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('1c4086ab-eb55-4798-9242-419a6e4bd9df', 'ea1816ff-8f2e-4111-a8d2-03b9822e8a72', 'dc9f9e86-8d80-46b7-87bc-e998cafca819', '32e46d74-0ebf-495b-8261-2c508cd2c2bb', '38ab2b8e-4373-4176-8944-4c6d8cffa7d8', 'b40c3129-d1f9-4ee7-9b6f-a4ed111c7109', '485e8a03-6bd3-4c3b-95d6-baf2f9b44cad', '1e9505f2-4f09-47be-82fe-648e59412d31', 'c5197681-247e-481b-b496-b4503db81187', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('3b850360-541b-4d99-abc4-4d9b831a70ce', 'ef51e563-54e8-42f9-ae12-4d641d476916', 'dc9f9e86-8d80-46b7-87bc-e998cafca819', '32e46d74-0ebf-495b-8261-2c508cd2c2bb', '38ab2b8e-4373-4176-8944-4c6d8cffa7d8', '9fdf9c47-28c6-4d2f-ba6f-906b588206c3', '485e8a03-6bd3-4c3b-95d6-baf2f9b44cad', 'e8a5b83c-e982-454d-a84a-3bb3b76806f3', '5577ba9a-318d-4440-8baa-7abf3925e7f0', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('e13042fa-b25f-4b63-b9a4-5430e70f14c2', 'eb5da956-27ec-4390-8000-5b6d994fdd6d', 'dc9f9e86-8d80-46b7-87bc-e998cafca819', '32e46d74-0ebf-495b-8261-2c508cd2c2bb', '38ab2b8e-4373-4176-8944-4c6d8cffa7d8', '1bcfab2c-6971-4998-9c38-55c1e039be68', 'c487eba0-9903-4df2-b999-20f1cca784fb', '34a90645-b540-4351-8d4b-356bec2a4c76', '35b2356d-cad3-415a-af7d-dc32bd148ae2', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('bbfa884c-81bd-4798-96a9-9efb3b26d6d5', '816961d9-c8e1-45cb-a5fe-c630adb65efb', 'dc9f9e86-8d80-46b7-87bc-e998cafca819', '32e46d74-0ebf-495b-8261-2c508cd2c2bb', '38ab2b8e-4373-4176-8944-4c6d8cffa7d8', 'e8e39ac5-cd31-4312-8f42-063aed530c47', 'c487eba0-9903-4df2-b999-20f1cca784fb', 'e43873e2-e36a-4f91-876b-b62ee15b6a55', '15cd7b16-0306-42b8-8208-9cca5b9deda3', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('f641406e-842f-458a-bdb0-a4f91ef783d5', '9e0c0107-9b95-43a7-81dc-bf7d63c9e0ca', 'cf117bdb-0226-42f0-9f40-e11aa3369b61', '6cc3324b-91cb-4ea6-a0db-2cd327ce7941', '7272229e-d4b1-419e-849b-531e45200032', 'ec46bd78-eaea-4593-b5de-9d07bb169875', '68489e77-9d60-498a-840c-712d1fb7ae01', 'bb066056-57d6-44aa-ae8f-b9ecc2d16c15', '07789943-52cc-4a00-a811-7656fbdc20f4', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('eff63a52-7538-4d72-82fe-5d527e3a0cef', '58208db3-bd61-462b-9fcd-05aca4cd1938', 'a4572037-9765-42e9-890c-0a4c47a49abd', '489dce3e-58d7-44c5-b9ef-2f7d7cbdb592', '50c00d93-da6b-4df1-87ad-ebe1b4af26d0', 'a92333cd-38a8-4b10-9822-3d66ade87507', 'd0b01b14-129d-452c-aba9-32a10da493ab', '87cd11b8-7e94-47cd-9996-0ecc21f1ca54', '7dd76107-3e1d-40a1-b89b-e801475b55b9', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('52cb147f-0ebf-464d-989b-cf246c08b5c0', 'de42f1f7-e41f-4929-a4b8-5e18c042b02f', 'c3481033-0753-4614-b00b-677ccc85d1ee', '489dce3e-58d7-44c5-b9ef-2f7d7cbdb592', '3f0b99bb-4666-463d-b373-6f096c6c032c', '1e6798c9-c8d2-4cec-acfa-c60a17acc802', 'ce572531-777d-4112-b07a-99c827d21bb7', '48507344-3f4b-475c-9b60-b913b01b5d27', '0254b351-1c59-4e0e-822d-b99b185b22f4', 'f755a09b-bf99-4ac1-a3cc-266ad9a9c32b'),
	('3d9b78fb-c828-4c6a-91d9-88a4c6776757', '8d1b2f6d-f447-4965-ad13-40f6a091d66a', '893121c9-05e6-4e35-bfef-ea76e40c012e', 'f85647db-e5d1-41a6-befb-bfbf6420f5c4', '17fc3b24-6e02-44e2-8efc-2c47da891a27', '530f3047-08df-4892-b9ab-16df2a2a39be', '530f1da7-9067-43a1-b515-e93f9199b65e', 'cda69748-98b0-4ee6-a025-27833304c743', '7100b4af-5ca3-4746-a8ef-4c5f46714353', '1c041cb3-373a-4dd5-9af4-2950293776bc');


--
-- Data for Name: establishment_lifecycle; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_lifecycle (establishment_lifecycle_id, establishment_id, establishment_status_id, open_date, close_date, reason_establishment_opened_id, reason_establishment_closed_id, last_changed_date) VALUES
	('c032c011-1e25-4358-b369-84a0ca1b4d5e', '9b21ef6f-c85d-4ac0-825d-edad0330cbc1', 1, '2010-09-01', NULL, 2, NULL, '2026-06-23'),
	('f3b7bc36-44b3-4f39-8a64-596e91d7f548', 'dcd8fd8b-4641-45d3-adb7-e06a6ecc9737', 1, '2007-09-01', NULL, 2, NULL, '2026-06-23'),
	('56fb58be-96ac-487b-a1cc-3231844b78f8', '57cc0fc6-757f-4b8b-a5c7-08652eb70e36', 2, '2009-09-01', '2016-02-29', 2, 12, '2018-07-02'),
	('de6a0523-b88c-4386-a453-4d7e022c1c87', 'c15013fe-be17-47e1-b47b-cd4c044b5f4f', 1, '2011-11-01', NULL, 1, NULL, '2026-06-23'),
	('7c8e7bf7-cb1c-487d-8dc4-d9dd08f1eb04', 'a17562ec-7130-4510-b7cb-64ab66bacb72', 1, NULL, NULL, NULL, NULL, '2026-06-23'),
	('bdd9dde5-9bf1-478e-8333-1a5a0d05d144', '9177ea85-b756-4b21-bc78-9f21e00e3492', 1, NULL, NULL, NULL, NULL, '2026-06-23'),
	('46aba4e3-0a59-4253-a34b-7a470f427fee', 'd24aa603-aa93-4b5f-85c5-550ec43d7023', 1, '2008-02-07', NULL, NULL, NULL, '2025-06-20'),
	('1b40ceba-7322-4b2d-9f64-6bb62ec3ad02', '2e38ad9e-6a0f-4ac9-a922-489c591f6be2', 1, '2006-03-14', NULL, NULL, NULL, '2025-06-20'),
	('91fd5934-4b52-49cb-bd88-d5a668218881', 'f6f736ac-d890-4d30-9df3-a2bae1aac7b7', 1, '2008-03-03', NULL, NULL, NULL, '2025-06-20'),
	('8d54db10-6c01-4987-93f4-abf1932c507f', '4edcc202-50c4-497b-a3b0-7e39b0235eba', 1, '2009-12-14', NULL, NULL, NULL, '2025-06-20'),
	('0f42cffd-fd26-46b6-88ae-6057aa292fa1', '3ad703d3-5dc8-4c9f-b029-f4f28aa98bde', 1, '2009-12-14', NULL, NULL, NULL, '2025-06-20'),
	('f750ca09-ce6f-4f68-9db4-f2a008fd0f17', 'ea1816ff-8f2e-4111-a8d2-03b9822e8a72', 1, '2008-01-16', NULL, NULL, NULL, '2025-06-20'),
	('0c84a899-c8a5-4e80-bf71-41b3dcb21704', 'ef51e563-54e8-42f9-ae12-4d641d476916', 1, '2008-01-16', NULL, NULL, NULL, '2025-06-20'),
	('352da895-9420-4905-bf16-127a509522d7', 'eb5da956-27ec-4390-8000-5b6d994fdd6d', 1, '2008-02-07', NULL, NULL, NULL, '2025-06-20'),
	('deab7369-31f9-4109-8095-0c01a5b5ac11', '816961d9-c8e1-45cb-a5fe-c630adb65efb', 1, '2006-09-28', NULL, NULL, NULL, '2025-06-20'),
	('3911a202-5b20-4039-b7cb-28e2b80a7bcc', '9e0c0107-9b95-43a7-81dc-bf7d63c9e0ca', 1, '2001-09-01', NULL, 6, NULL, '2025-06-20'),
	('aeba5e3c-d7ee-430d-a8f4-41c4d8721922', '58208db3-bd61-462b-9fcd-05aca4cd1938', 1, '2009-09-01', NULL, 2, NULL, '2026-06-23'),
	('f805b2b5-06f9-49a4-b7e9-f32e3c632071', 'de42f1f7-e41f-4929-a4b8-5e18c042b02f', 1, '1990-03-28', NULL, NULL, NULL, '2026-07-20'),
	('5ac43eb8-e1d2-45d8-ac22-faaaf12645be', '8d1b2f6d-f447-4965-ad13-40f6a091d66a', 1, '1988-12-12', NULL, NULL, NULL, '2026-07-20');


--
-- Data for Name: person; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.person (person_id) VALUES
	('c11a6d35-1f58-413f-8339-150314652533');


--
-- Data for Name: establishment_party_role; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_party_role (establishment_party_role_id, establishment_party_role_type_id, legal_entity_id, person_id, start_date, end_date) VALUES
	('59057f8a-b8fd-4188-b16c-674dbd564859', 1, 'dfe2042e-da1c-4767-aea0-8fce23d37527', NULL, NULL, NULL),
	('f2e33c0e-37d0-4489-9ef0-5fdd75869582', 1, '9859a07f-61c0-4845-a976-9adda9fdf604', NULL, NULL, NULL),
	('b73aa8bf-21f0-47c1-b574-84492b96c10b', 4, 'a2dcd133-77fc-40d6-8b7f-6f9655aceb7e', NULL, NULL, NULL),
	('01846c62-6790-470b-bdff-d112deca07c6', 1, 'bc20aa22-6e2b-4c8e-b8ae-484a6e55067b', NULL, NULL, NULL),
	('07780fd9-3c18-410e-98b5-270436a1604f', 4, '993b8053-8d32-4351-b6b0-49f343e58883', NULL, NULL, NULL),
	('2ccee160-350e-42be-a1b5-c2fd8fe9fcbb', 1, '776a7bee-cbf4-48e8-ad8b-c2e1e3d79302', NULL, NULL, '2016-02-29'),
	('2d4b2846-723c-4570-9de6-0fab60468ecb', 1, 'e1f70fda-02c0-4fab-92be-ff514f767637', NULL, NULL, NULL),
	('1004e4f3-c976-4af7-9221-c73503db5eb3', 2, '43e519c2-8b3e-473e-990d-583f4a500402', NULL, NULL, NULL),
	('1b9e9d8c-d891-4fea-9e30-96840f69abbf', 4, NULL, 'c11a6d35-1f58-413f-8339-150314652533', NULL, NULL),
	('4d2110d0-5eb4-45e0-bae6-906df6f01ebd', 1, '7eadb097-76e1-48da-aeb2-9268c1dbb859', NULL, NULL, NULL);


--
-- Data for Name: establishment_responsibility; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_responsibility (establishment_responsibility_id, establishment_id, legal_entity_id, person_id, responsibility_type_id, academy_trust_type_id, start_date, end_date, is_current) VALUES
	('e2c7c2ce-8998-4a65-bc7d-4d67170042b6', '9b21ef6f-c85d-4ac0-825d-edad0330cbc1', 'dfe2042e-da1c-4767-aea0-8fce23d37527', NULL, 1, 2, '2015-07-01', NULL, true),
	('b8ba4e6a-c93b-4771-8003-7d0472cc5ff3', '9b21ef6f-c85d-4ac0-825d-edad0330cbc1', '9859a07f-61c0-4845-a976-9adda9fdf604', NULL, 1, 1, '2010-09-01', NULL, false),
	('f1ff56fe-d50b-492b-9cde-a1a60746a4bd', '9b21ef6f-c85d-4ac0-825d-edad0330cbc1', 'a2dcd133-77fc-40d6-8b7f-6f9655aceb7e', NULL, 3, NULL, '2010-09-01', NULL, true),
	('7a5adc1e-e402-4ad9-9585-897a45efde49', 'dcd8fd8b-4641-45d3-adb7-e06a6ecc9737', 'bc20aa22-6e2b-4c8e-b8ae-484a6e55067b', NULL, 1, 2, '2021-10-04', NULL, true),
	('7f59de00-5378-4d1a-94de-7d94305f6478', 'dcd8fd8b-4641-45d3-adb7-e06a6ecc9737', 'bc20aa22-6e2b-4c8e-b8ae-484a6e55067b', NULL, 1, 1, '2007-09-01', NULL, false),
	('7813914d-0855-46b4-ac73-4b51ea7b69d6', 'dcd8fd8b-4641-45d3-adb7-e06a6ecc9737', '993b8053-8d32-4351-b6b0-49f343e58883', NULL, 3, NULL, '2007-09-01', NULL, true),
	('0a0be5af-65bb-4a4d-bbf3-c74a12772a5c', '57cc0fc6-757f-4b8b-a5c7-08652eb70e36', '776a7bee-cbf4-48e8-ad8b-c2e1e3d79302', NULL, 1, 2, '2009-09-01', '2016-02-29', false),
	('b61e41fc-7d8b-4b19-8011-b665e74f8aa3', 'c15013fe-be17-47e1-b47b-cd4c044b5f4f', 'e1f70fda-02c0-4fab-92be-ff514f767637', NULL, 1, 1, '2011-11-01', NULL, false),
	('940e03a9-a2e6-47c7-a324-11ac4626d239', 'c15013fe-be17-47e1-b47b-cd4c044b5f4f', 'e1f70fda-02c0-4fab-92be-ff514f767637', NULL, 1, 2, '2021-03-30', NULL, true),
	('60d84a78-172f-4b98-a012-e90acb07c4fe', '9e0c0107-9b95-43a7-81dc-bf7d63c9e0ca', '43e519c2-8b3e-473e-990d-583f4a500402', NULL, 2, NULL, '2011-09-01', NULL, true),
	('ff32f07d-44ef-479c-af5a-d6e631ae39c5', '58208db3-bd61-462b-9fcd-05aca4cd1938', NULL, 'c11a6d35-1f58-413f-8339-150314652533', 3, NULL, '2009-09-01', NULL, true),
	('3f803c73-cc86-4270-8358-57f4b8e80cb7', '58208db3-bd61-462b-9fcd-05aca4cd1938', '7eadb097-76e1-48da-aeb2-9268c1dbb859', NULL, 1, 2, '2009-09-01', NULL, true),
	('63765484-67fe-4f86-a1d4-993210744f23', 'de42f1f7-e41f-4929-a4b8-5e18c042b02f', '5be037f1-12fc-4b40-829c-4135c96fc783', NULL, 4, NULL, NULL, NULL, true),
	('b7747702-79a3-44ff-9ee3-0e353728631e', '8d1b2f6d-f447-4965-ad13-40f6a091d66a', '5be037f1-12fc-4b40-829c-4135c96fc783', NULL, 4, NULL, NULL, NULL, true);


--
-- Data for Name: site; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.site (site_id, address_id, site_name, uprn) VALUES
	('d3040837-346e-440c-af48-4c92663a1230', 'a5daa9c7-7af9-4828-b010-07934548b583', NULL, 3455015782),
	('e89a12ae-c15e-4cc5-9c3e-9beae656c61c', '91004993-f6de-48f7-b423-bc3286126ce9', NULL, 5300060053),
	('14ed5916-88af-45a4-828d-e46bda55e9c7', '9939ff34-0583-4419-9bfd-fd73fc03bc58', NULL, 10090666596),
	('0f058d6a-c769-4d9d-8ca2-d2e58bf5d34f', 'aa3b6198-4149-4bc1-aac8-1f2908403616', NULL, 10006581609),
	('73f0bc46-54bc-4d9f-a02f-3505468f73de', '475012a9-27af-484f-b7a4-c5055c77acce', NULL, 100081218005),
	('f505a35c-13e7-4ee2-ba1f-f68e9d479315', 'b6f4b0a2-cd61-422e-b714-eb1e77dd8184', NULL, 100081212588),
	('691fa426-a3b4-48fc-83b2-189f0e0eb16c', 'aab35982-d47d-4273-b8d1-36f7fb0523c7', NULL, 100091605340),
	('22c1b00b-0463-4935-a3fd-afc06d83401e', '3220aecd-7511-4446-86b4-d0bef01cf62c', NULL, NULL),
	('4dceb2e6-86b7-4177-8790-bbb525c6d847', '3409b380-132c-4efd-b5f5-91a9b58e4783', NULL, 10024158444),
	('5950b7a0-4b44-49f6-b049-c30b8c26cbd7', '6110a1eb-f1fb-4365-b767-6e87567804ef', NULL, 100091593148),
	('2d468de8-a726-452f-923f-fc9bb4f5d712', 'f05c95b6-6083-46fc-9281-c75733cde636', NULL, 10012151948),
	('a009576c-edb2-4f88-98fe-32de2857419b', 'fe39e4fc-e2ea-404b-b1ba-64f96052a477', NULL, 100091595925),
	('4f5de409-9bae-4309-9835-f4cc3e62441f', '0b13c33d-5e57-4a4a-a395-04372c0f921e', NULL, 10012152076),
	('fe0a3037-0697-4337-8dfa-7edca0e37c69', 'ff363e38-ca3a-41ad-a093-c9ba3755436b', NULL, 100091656436),
	('f78a8595-88be-4e1d-adfe-2dc1a69da734', 'cd62ef0a-225d-4e21-8838-103236b0b625', NULL, 200001258935),
	('d92f9f40-691b-424b-932d-555b7ad000fd', '1b2b950d-5efe-4074-90d0-937e7f1ffc29', NULL, 47000575),
	('3f8fb50b-5b96-4762-846a-f5fe4870f0c9', '00950ccf-c7eb-4a71-b236-5bab0691e717', NULL, 100012750549),
	('0c08683a-ff49-400e-b945-720addca8bde', 'cff76d2a-8cc0-4da2-8dbb-6e84dec839d4', NULL, NULL),
	('08b125bf-5ac7-493d-99e8-7906782526fd', '9929ab31-b89d-475d-b2b4-8dc59176152e', NULL, 200004392318);


--
-- Data for Name: establishment_to_site; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_to_site (establishment_id, site_id, is_main_site) VALUES
	('9b21ef6f-c85d-4ac0-825d-edad0330cbc1', 'd3040837-346e-440c-af48-4c92663a1230', true),
	('dcd8fd8b-4641-45d3-adb7-e06a6ecc9737', 'e89a12ae-c15e-4cc5-9c3e-9beae656c61c', true),
	('57cc0fc6-757f-4b8b-a5c7-08652eb70e36', '14ed5916-88af-45a4-828d-e46bda55e9c7', true),
	('c15013fe-be17-47e1-b47b-cd4c044b5f4f', '0f058d6a-c769-4d9d-8ca2-d2e58bf5d34f', true),
	('a17562ec-7130-4510-b7cb-64ab66bacb72', '73f0bc46-54bc-4d9f-a02f-3505468f73de', true),
	('9177ea85-b756-4b21-bc78-9f21e00e3492', 'f505a35c-13e7-4ee2-ba1f-f68e9d479315', true),
	('d24aa603-aa93-4b5f-85c5-550ec43d7023', '691fa426-a3b4-48fc-83b2-189f0e0eb16c', true),
	('2e38ad9e-6a0f-4ac9-a922-489c591f6be2', '22c1b00b-0463-4935-a3fd-afc06d83401e', true),
	('f6f736ac-d890-4d30-9df3-a2bae1aac7b7', '4dceb2e6-86b7-4177-8790-bbb525c6d847', true),
	('4edcc202-50c4-497b-a3b0-7e39b0235eba', '5950b7a0-4b44-49f6-b049-c30b8c26cbd7', true),
	('3ad703d3-5dc8-4c9f-b029-f4f28aa98bde', '2d468de8-a726-452f-923f-fc9bb4f5d712', true),
	('ea1816ff-8f2e-4111-a8d2-03b9822e8a72', 'a009576c-edb2-4f88-98fe-32de2857419b', true),
	('ef51e563-54e8-42f9-ae12-4d641d476916', '4f5de409-9bae-4309-9835-f4cc3e62441f', true),
	('eb5da956-27ec-4390-8000-5b6d994fdd6d', 'fe0a3037-0697-4337-8dfa-7edca0e37c69', true),
	('816961d9-c8e1-45cb-a5fe-c630adb65efb', 'f78a8595-88be-4e1d-adfe-2dc1a69da734', true),
	('9e0c0107-9b95-43a7-81dc-bf7d63c9e0ca', 'd92f9f40-691b-424b-932d-555b7ad000fd', true),
	('58208db3-bd61-462b-9fcd-05aca4cd1938', '3f8fb50b-5b96-4762-846a-f5fe4870f0c9', true),
	('de42f1f7-e41f-4929-a4b8-5e18c042b02f', '0c08683a-ff49-400e-b945-720addca8bde', true),
	('8d1b2f6d-f447-4965-ad13-40f6a091d66a', '08b125bf-5ac7-493d-99e8-7906782526fd', true);


--
-- Data for Name: organisation_group; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.organisation_group (organisation_group_id, name, organisation_group_type_id, local_authority_id, open_date, close_date) VALUES
	('fc819ba0-c2a2-406f-bfe0-ac0fb90af4de', 'Federation of Eileen Wade and Milton Ernest VC lower schools', 1, NULL, '2011-01-13', NULL),
	('a62f38a1-438b-4513-b6ef-654b66446d7f', 'Southend Children''s Centres', 2, 'dc9f9e86-8d80-46b7-87bc-e998cafca819', '2016-10-01', NULL);


--
-- Data for Name: group_identifier; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.group_identifier (group_identifier_id, establishment_party_role_id, organisation_group_id, group_identifier_type_id, group_identifier_issuer_id, value, is_current) VALUES
	('91d82744-e049-46b3-b54d-835d409ed0a8', '59057f8a-b8fd-4188-b16c-674dbd564859', NULL, 1, 1, '2777', true),
	('946b4cf4-019a-4cf1-8576-a9da4b55a315', '59057f8a-b8fd-4188-b16c-674dbd564859', NULL, 2, 1, 'TR00567', true),
	('1a9898d7-9d5f-4438-a7df-fa8364c6de33', 'f2e33c0e-37d0-4489-9ef0-5fdd75869582', NULL, 1, 1, '2779', false),
	('688cf3e2-b82d-428d-839d-c1303e9916ff', 'f2e33c0e-37d0-4489-9ef0-5fdd75869582', NULL, 2, 1, 'TR00569', false),
	('f5220a56-a65c-4afd-9e21-7fbfc39f78d0', 'b73aa8bf-21f0-47c1-b574-84492b96c10b', NULL, 1, 1, '4949', true),
	('79355d5b-de5e-4451-85bc-77521a02e031', 'b73aa8bf-21f0-47c1-b574-84492b96c10b', NULL, 2, 1, 'SP00125', true),
	('924ad606-32a4-4467-a5e3-37a13ce4835e', '01846c62-6790-470b-bdff-d112deca07c6', NULL, 1, 1, '23869', true),
	('0a4fa4c5-8d53-4953-9f3c-5035c9758362', '01846c62-6790-470b-bdff-d112deca07c6', NULL, 2, 1, 'TR02103', true),
	('1da4f558-4f74-4376-9ccd-6fa3dd43c218', '01846c62-6790-470b-bdff-d112deca07c6', NULL, 1, 1, '4737', false),
	('e2f5c391-eb45-48c7-a462-eca2554ac7d0', '07780fd9-3c18-410e-98b5-270436a1604f', NULL, 1, 1, '2914', true),
	('f147f269-5beb-4694-92d6-16347bda42ce', '07780fd9-3c18-410e-98b5-270436a1604f', NULL, 2, 1, 'SP00172', true),
	('8dbc7401-8ea9-41e2-852b-598df0871a58', '2ccee160-350e-42be-a1b5-c2fd8fe9fcbb', NULL, 1, 1, '3839', false),
	('6f35f5ae-3777-435a-b2b0-2d066c9b15e2', '2ccee160-350e-42be-a1b5-c2fd8fe9fcbb', NULL, 2, 1, 'TR01385', false),
	('a0e08904-abbc-42dc-89ef-c9b0d4f0ed8c', '2d4b2846-723c-4570-9de6-0fab60468ecb', NULL, 1, 1, '2055', false),
	('c132eea8-b1c9-4266-b508-4335ee2ccf39', '2d4b2846-723c-4570-9de6-0fab60468ecb', NULL, 1, 1, '20364', true),
	('5fa91c15-b051-46db-8b9b-8e3317ed13ee', '2d4b2846-723c-4570-9de6-0fab60468ecb', NULL, 2, 1, 'TR00009', true),
	('55133496-00a2-461e-a23b-288485b481fe', '1004e4f3-c976-4af7-9221-c73503db5eb3', NULL, 1, 1, '1337', true),
	('6d7794ce-33d5-4ca7-bc27-757c4f0f725e', '1b9e9d8c-d891-4fea-9e30-96840f69abbf', NULL, 1, 1, '2613', true),
	('152d3298-a3a6-4380-a198-cf1a174a5846', '1b9e9d8c-d891-4fea-9e30-96840f69abbf', NULL, 2, 1, 'SP00099', true),
	('5030c000-7b2e-4883-868b-b9a2a87acecd', '4d2110d0-5eb4-45e0-bae6-906df6f01ebd', NULL, 1, 1, '3147', true),
	('dd4422fc-10b5-40a8-bb6b-7a73bd0560b1', '4d2110d0-5eb4-45e0-bae6-906df6f01ebd', NULL, 2, 1, 'TR00830', true),
	('aae686de-1210-4a2a-ac36-87218ce974a0', NULL, 'fc819ba0-c2a2-406f-bfe0-ac0fb90af4de', 1, 1, '1809', true),
	('17ee48c8-a47c-4194-9dea-2056d09dc45e', NULL, 'a62f38a1-438b-4513-b6ef-654b66446d7f', 1, 1, '86052', true);


--
-- Data for Name: organisation_group_member; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.organisation_group_member (organisation_group_member_id, organisation_group_id, establishment_id, joined_date, left_date, is_lead_member) VALUES
	('5c1b435c-3a71-47a8-9a38-6be29554263f', 'fc819ba0-c2a2-406f-bfe0-ac0fb90af4de', '9177ea85-b756-4b21-bc78-9f21e00e3492', '2011-01-13', NULL, NULL),
	('d87ed95a-1b98-46b3-a053-a308d9638e24', 'fc819ba0-c2a2-406f-bfe0-ac0fb90af4de', 'a17562ec-7130-4510-b7cb-64ab66bacb72', '2011-01-13', NULL, NULL),
	('9ba31e58-b922-4748-a393-52fcd64447be', 'a62f38a1-438b-4513-b6ef-654b66446d7f', '816961d9-c8e1-45cb-a5fe-c630adb65efb', '2016-10-01', NULL, false),
	('362f5d75-f2b2-477b-95f0-5f899529ac82', 'a62f38a1-438b-4513-b6ef-654b66446d7f', '3ad703d3-5dc8-4c9f-b029-f4f28aa98bde', '2016-10-01', NULL, false),
	('86f7550b-4c7b-45b4-a76e-1a2285936bed', 'a62f38a1-438b-4513-b6ef-654b66446d7f', '2e38ad9e-6a0f-4ac9-a922-489c591f6be2', '2016-10-01', NULL, true),
	('2e21c189-8c08-4de7-abe0-73fe304c6b40', 'a62f38a1-438b-4513-b6ef-654b66446d7f', 'eb5da956-27ec-4390-8000-5b6d994fdd6d', '2016-10-01', NULL, false),
	('23511f8c-2411-4de2-a520-d3ec8079831f', 'a62f38a1-438b-4513-b6ef-654b66446d7f', '4edcc202-50c4-497b-a3b0-7e39b0235eba', '2016-10-01', NULL, false),
	('fbbfcc89-c668-4836-8f29-2c925259d4b5', 'a62f38a1-438b-4513-b6ef-654b66446d7f', 'ea1816ff-8f2e-4111-a8d2-03b9822e8a72', '2016-10-01', NULL, false),
	('53a879ae-59cd-4112-9010-31073581c9f8', 'a62f38a1-438b-4513-b6ef-654b66446d7f', 'f6f736ac-d890-4d30-9df3-a2bae1aac7b7', '2016-10-01', NULL, false),
	('4cd9d932-cc5b-49c5-aeec-409d34e4babe', 'a62f38a1-438b-4513-b6ef-654b66446d7f', 'ef51e563-54e8-42f9-ae12-4d641d476916', '2016-10-01', NULL, false),
	('477a867d-afd6-43b2-9455-d1c1915a30ca', 'a62f38a1-438b-4513-b6ef-654b66446d7f', 'd24aa603-aa93-4b5f-85c5-550ec43d7023', '2016-10-01', NULL, false);


--
-- Data for Name: organisation_identifier; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.organisation_identifier (organisation_identifier_id, legal_entity_id, organisation_identifier_type_id, value, is_current) VALUES
	('ed2cbbe7-dd60-4b75-9a69-2bab0e6ad3f4', 'dfe2042e-da1c-4767-aea0-8fce23d37527', 1, '07747126', true),
	('6333606a-9221-4180-8c3c-03d46bbca362', 'dfe2042e-da1c-4767-aea0-8fce23d37527', 2, '10059286', true),
	('010b3809-23dd-4abd-a755-fc0dd0e5726c', '9859a07f-61c0-4845-a976-9adda9fdf604', 1, '07158839', true),
	('50a9b9da-b27e-44c0-afa3-de4d5cce405c', '9859a07f-61c0-4845-a976-9adda9fdf604', 2, '10061289', true),
	('6e35914d-ac1d-41b9-b878-8dbbaee268cb', 'bc20aa22-6e2b-4c8e-b8ae-484a6e55067b', 1, '05412502', true),
	('afd1849d-96e8-4d6d-b955-90cc0d5cf562', 'bc20aa22-6e2b-4c8e-b8ae-484a6e55067b', 2, '10058191', true),
	('fd4a206a-7d47-4d8c-80ce-3d77c563f9db', '776a7bee-cbf4-48e8-ad8b-c2e1e3d79302', 1, '06888873', true),
	('61575607-c692-4aa6-bc23-5919f0e1fcc5', 'e1f70fda-02c0-4fab-92be-ff514f767637', 1, '07795736', true),
	('2198bdec-e9b9-4689-8222-bd7bd95ed77a', 'e1f70fda-02c0-4fab-92be-ff514f767637', 2, '10059335', true),
	('9b163bfb-e372-4f12-ac64-e52188f8fc30', '7eadb097-76e1-48da-aeb2-9268c1dbb859', 1, '06960253', true),
	('4d14b130-1579-4620-bde3-ff05697da9e4', '7eadb097-76e1-48da-aeb2-9268c1dbb859', 2, '10058269', true);


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
	('acb6dda3-d3e0-4f1d-a369-ac0afc1a763c', '7cd6d559-b290-4d44-bcf6-551ebe6aa04f', 11, 16),
	('9701e274-e1a7-482d-82eb-13ac6eab126d', '62a38374-77f6-4e71-885d-cfe8be75ba14', 4, 19),
	('59fc8124-8739-4c01-9f3d-7caaf596222d', 'e8aa83f7-6f7c-4b31-b138-051e61da562c', 11, 19),
	('67034e13-cb7d-4a92-9d6a-91e459c9eac4', 'f87b18cc-d1a0-41f8-af57-25dfc4c8538b', 11, 19),
	('c945f51a-4fa4-4f57-90dc-e45cef4fdda9', '4cfde20f-cf16-4f28-914d-fb097a7435f5', 5, 11),
	('4bdba470-e8b7-41a5-8ed0-02c834616e90', '67a0d9f9-2ac5-4cf0-8f43-27255996a989', 4, 11),
	('e8b14314-97f6-4749-ae8d-e704b798d2c2', 'f707b656-22ec-49ea-92c3-a572fe31cb5e', 3, 11),
	('1159aca5-80ba-48e9-8969-67d37496f7ff', 'd5c2a85a-5538-4546-b87f-694f5705ef0c', 11, 16),
	('7afb5e0f-8839-469c-b8e8-dea528a75af1', '98146712-d7a6-4f23-8787-88eda991f6da', 5, 19),
	('10dc2bae-81c3-41df-b4af-0ef2b40aebc4', '9161d6fa-b724-4d6f-9566-675c70a969b4', 5, 18);


--
-- PostgreSQL database dump complete
--

\unrestrict 7ycW4tSOH4crXIWorglsWHgKdozOPtxa6YmgqAebt4pV50EfqcOukkU0Oqvtp24

