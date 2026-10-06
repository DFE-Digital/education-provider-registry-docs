--
-- PostgreSQL database dump
--

\restrict VVKBnC7KrOA91T0ESfwK2H9iKFH6FcAQ0LUqwDQMAZlIGry8nY2SNQ3NdkuretD

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
	('afd36da5-3292-421f-af78-73e0d6d42405', 'THE CO-OPERATIVE ACADEMIES TRUST', 1, NULL, '2011-08-19', NULL),
	('41ff8d1d-d0ba-415e-ae39-3fdce680e460', 'THE CO-OPERATIVE ACADEMY OF STOKE ON TRENT', 1, NULL, '2010-02-16', NULL),
	('c4573ea5-4946-4971-85f9-cb73896bff75', 'The Co-operative Group', NULL, NULL, NULL, NULL),
	('26e99bb7-1198-4943-85ab-5404a0e9481b', 'HIVE EDUCATION TRUST', 1, NULL, '2005-04-04', NULL),
	('e2c14078-1d3b-444d-b6ff-1479b1394992', 'Diocese of London', NULL, NULL, NULL, NULL),
	('e19062e6-f475-4e3c-8aab-d08a91aedc6b', 'MARCH 2016 LIMITED', 1, NULL, '2009-04-27', NULL),
	('ea91f652-ad88-4ae8-b02b-71778ee480da', 'THE ACADEMY @ RIDGEWOOD TRUST', 1, NULL, '2011-10-03', NULL);


--
-- Data for Name: academy_trust_classification; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.academy_trust_classification (academy_trust_classification_id, legal_entity_id, academy_trust_type_id, start_date, end_date, is_current) VALUES
	('e44022e0-e02c-452a-92fe-9625b763d607', 'afd36da5-3292-421f-af78-73e0d6d42405', 2, NULL, NULL, true),
	('4f474282-9c7b-4967-88ae-2a9b5e4333f5', '41ff8d1d-d0ba-415e-ae39-3fdce680e460', 1, NULL, NULL, false),
	('1b62624f-b75b-4a85-9be3-b268f4c6546a', '26e99bb7-1198-4943-85ab-5404a0e9481b', 2, NULL, NULL, true),
	('305aca6d-eaae-4b0b-8b0b-2de6b7e77042', '26e99bb7-1198-4943-85ab-5404a0e9481b', 1, NULL, NULL, false),
	('6d966336-6dba-4f13-8f11-042326da2828', 'e19062e6-f475-4e3c-8aab-d08a91aedc6b', 2, NULL, '2016-02-29', false),
	('9b2fc01f-2fe6-49b4-b6e2-d2bb688996e6', 'ea91f652-ad88-4ae8-b02b-71778ee480da', 1, NULL, '2021-03-30', false),
	('9abe6b5b-1b89-47ce-8037-514e7eb90516', 'ea91f652-ad88-4ae8-b02b-71778ee480da', 2, '2021-03-30', NULL, true);


--
-- Data for Name: address; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.address (address_id, address_line_1, address_line_2, address_line_3, town, county, postcode) VALUES
	('fcc7cf14-dc7e-46b3-8658-a754b28555db', 'obfuscated', NULL, 'obfuscated', 'obfuscated', '032', 'ST6 4LD'),
	('0fdce0e3-4650-4f62-9845-969731f0b089', 'obfuscated', 'Islington', NULL, 'obfuscated', '099', 'N7 8PG'),
	('6d5f9d0e-57c0-4018-8240-6100a6e43f29', 'obfuscated', 'Blackley', NULL, 'obfuscated', '099', 'M9 7SS'),
	('5c2491b8-75d4-4c13-9639-1ca98fa3b1d0', 'obfuscated', 'Scawsby', NULL, 'obfuscated', '031', 'DN5 7UB'),
	('ff345e76-c62b-4c52-a860-4778621a2583', 'obfuscated', 'Upper Dean', NULL, 'obfuscated', '003', 'PE28 0ND'),
	('b39af57d-8be6-4138-a510-4be0d9109a60', 'obfuscated', 'Milton Ernest', NULL, 'obfuscated', '001', 'MK44 1RF'),
	('9d8ad5fc-40c4-4c59-bd78-8673bf4c68f0', 'obfuscated', 'School Way', 'obfuscated', 'obfuscated', '012', 'SS9 4HX'),
	('54a8c3f7-693c-458b-823e-16b7218c6509', 'obfuscated', NULL, NULL, 'obfuscated', '012', 'SS1 1ES'),
	('239ba1c0-851c-4df2-8af6-91e4010526ef', NULL, 'Centre Place', 'obfuscated', 'obfuscated', '012', 'SS1 2JD'),
	('6211039c-83ed-4756-b132-3122ac6ffb6c', 'obfuscated', 'Hamstel Road', NULL, 'obfuscated', '012', 'SS2 4PQ'),
	('df88d20c-c184-42a1-96af-5c11d3ca4359', 'obfuscated', NULL, NULL, 'obfuscated', '012', 'SS0 0LG'),
	('c71057d8-8c57-48b0-96c0-dbe2aa012179', 'obfuscated', 'Constable Way', NULL, 'obfuscated', '012', 'SS3 9XX'),
	('d28b3cfe-c86e-431e-a685-e427c6141f67', 'obfuscated', NULL, NULL, 'obfuscated', '012', 'SS0 7AU'),
	('ffde81ca-060d-4db1-83be-7e04ec7161dd', 'obfuscated', 'Rayleigh Road', 'obfuscated', 'obfuscated', '012', 'SS9 5UT'),
	('c4ecf380-2555-4f98-a218-1ede3ae78d3f', 'obfuscated', 'Eastern Avenue', NULL, 'obfuscated', '012', 'SS2 4BA');


--
-- Data for Name: establishment; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment (establishment_id, urn, ukprn, establishment_number, name, establishment_type_id, education_phase_id) VALUES
	('1d6a7191-daee-43b7-a04e-4dbfb404c551', 136102, 10030216, 6905, 'The Co-Operative Academy of Stoke-On-Trent', 4, 5),
	('e8e757a7-7d0d-417e-919f-954050e393e2', 134314, 10024207, 6905, 'St Mary Magdalene Academy', 4, 6),
	('fa40eca3-efee-439a-b959-e82d43bb3e50', 135905, NULL, 6910, 'Manchester Creative and Media Academy', 4, 5),
	('6bc7d160-b44a-49b2-b06e-1ed1d9d13a46', 137603, 10035482, 4033, 'Ridgewood School', 4, 5),
	('b0d8d0b5-8169-45c9-865f-5dd79610c4d0', 109443, 10077509, 2036, 'Eileen Wade Primary School', 11, 2),
	('1f01a51f-f95c-4d5e-85df-40d1e0ed23b8', 109613, 10075753, 3023, 'Milton Ernest CofE Primary School', 10, 2),
	('cdb7bbac-3497-4eda-b51e-44c5731fd8fc', 20338, NULL, NULL, 'Blenheim Children''s Centre', 35, 8),
	('8f067d47-0d42-431e-8091-cccbe8b71f13', 20549, NULL, NULL, 'Cambridge Road Children''s Centre', 35, 8),
	('3180bc58-f0ce-4268-81b8-3500b63238aa', 20614, NULL, NULL, 'Centre Place Family Centre', 35, 8),
	('1546722a-7f22-48a6-b453-5e37ffe07b0b', 21363, NULL, NULL, 'Hamstel Children and Family Centre', 35, 8),
	('f96da737-9826-45f9-8f0f-9927cad6a23f', 22422, NULL, NULL, 'Prince Avenue Children and Family Centre', 35, 8),
	('477f2d54-eece-4ecc-b7d2-086bcf7a183c', 22459, NULL, NULL, 'Friars Children''s Centre', 35, 8),
	('ade83951-36cd-4cb5-9d8e-640de93dac8f', 22975, NULL, NULL, 'Summercourt Children''s Centre', 35, 8),
	('ed328976-8197-4c78-82fd-b5166a3af632', 23004, NULL, NULL, 'Eastwood Children''s Centre', 35, 8),
	('d7a1353e-1b26-43ca-ae70-ea5d2803611e', 23122, NULL, NULL, 'Temple Sutton Children''s Centre', 35, 8);


--
-- Data for Name: capacity_and_pupil_measures; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.capacity_and_pupil_measures (capacity_and_pupil_measures_id, establishment_id, school_capacity, pupil_count, free_school_meal_measure, census_date) VALUES
	('7d2813e1-b0d3-4b63-bdce-71708cdabff8', '1d6a7191-daee-43b7-a04e-4dbfb404c551', 1050, 1300, 735, NULL),
	('4cf36a53-21cd-4155-b564-9fd60a106211', 'e8e757a7-7d0d-417e-919f-954050e393e2', 1310, 1561, 465, NULL),
	('ed83ee2b-1c02-4ac1-a937-0ea214eaca28', 'fa40eca3-efee-439a-b959-e82d43bb3e50', 660, NULL, NULL, NULL),
	('bbfa2ff6-a33a-494f-8353-3e3eec0aecc9', '6bc7d160-b44a-49b2-b06e-1ed1d9d13a46', 1512, 1425, 250, NULL),
	('d514ff9e-b8bd-4990-88ce-f5242e32e1cf', 'b0d8d0b5-8169-45c9-865f-5dd79610c4d0', 23610, 70, 10, NULL),
	('b39d85a1-60fb-4ab5-9ecf-f0fa6073f72e', '1f01a51f-f95c-4d5e-85df-40d1e0ed23b8', 63964, 67, 5, NULL);


--
-- Data for Name: education_admissions_and_provision; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.education_admissions_and_provision (education_admissions_and_provision_id, establishment_id, gender_of_entry_type_id, admissions_policy_id, boarding_provision_id, nursery_provision_id, sixth_form_provision_id) VALUES
	('3fac1c89-9b7c-4e6f-b98d-ecbc0a1f1496', '1d6a7191-daee-43b7-a04e-4dbfb404c551', 1, 1, 1, 3, 3),
	('39aa9579-4da7-4ecd-871d-3f0e15f5e502', 'e8e757a7-7d0d-417e-919f-954050e393e2', 1, 1, 1, 2, 1),
	('2aaf5087-cee9-43a3-9d40-dedfe621def2', 'fa40eca3-efee-439a-b959-e82d43bb3e50', 1, 1, 1, 3, 1),
	('2ee73c4c-86e1-4dae-9715-babc2097281e', '6bc7d160-b44a-49b2-b06e-1ed1d9d13a46', 1, 1, 1, 3, 1),
	('2aeebba8-8630-469e-95f2-31db5e200c31', 'b0d8d0b5-8169-45c9-865f-5dd79610c4d0', 1, 3, 1, 2, 2),
	('5d70c5c1-82a1-40df-8d85-8c43bc62c9ab', '1f01a51f-f95c-4d5e-85df-40d1e0ed23b8', 1, 3, 1, 2, 2),
	('c1bc9737-6b08-4755-9139-50658282aa3f', 'cdb7bbac-3497-4eda-b51e-44c5731fd8fc', NULL, 3, NULL, 3, 3),
	('2382514c-b63d-4147-afeb-f0edc4a7bae8', '8f067d47-0d42-431e-8091-cccbe8b71f13', NULL, 3, NULL, 3, 3),
	('5586959f-2dc0-4058-8ae3-ed513bc2273b', '3180bc58-f0ce-4268-81b8-3500b63238aa', NULL, 3, NULL, 3, 3),
	('8fdfda0e-72b4-4f9e-a4d8-5f365d616bc3', '1546722a-7f22-48a6-b453-5e37ffe07b0b', NULL, 3, NULL, 3, 3),
	('b54ccd83-d7c2-45c6-86a1-fba771878b14', 'f96da737-9826-45f9-8f0f-9927cad6a23f', NULL, 3, NULL, 3, 3),
	('2e23cc6f-8b8d-4715-93f0-2e8ee4842587', '477f2d54-eece-4ecc-b7d2-086bcf7a183c', NULL, 3, NULL, 3, 3),
	('0d84358a-71f5-4129-9938-d148236e2fa9', 'ade83951-36cd-4cb5-9d8e-640de93dac8f', NULL, 3, NULL, 3, 3),
	('1599db2f-9a39-426e-8fe4-b4c380e25d97', 'ed328976-8197-4c78-82fd-b5166a3af632', NULL, 3, NULL, 3, 3),
	('3503c214-a2bb-4fa2-a82e-e4bb6b878c3f', 'd7a1353e-1b26-43ca-ae70-ea5d2803611e', NULL, 3, NULL, 3, 3);


--
-- Data for Name: establishment_contact; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_contact (establishment_contact_id, establishment_id, website, telephone_number) VALUES
	('b87eeb3b-e773-4391-b639-4deb764a7ffc', '1d6a7191-daee-43b7-a04e-4dbfb404c551', 'http://www.cas.coop', '111111'),
	('7b87e837-7e16-472d-a6b9-a11c7af7141f', 'e8e757a7-7d0d-417e-919f-954050e393e2', 'www.smmacademy.org', '111111'),
	('ca5e3597-8f61-44a4-85a4-8592f01afd89', '6bc7d160-b44a-49b2-b06e-1ed1d9d13a46', 'http://www.ridgewoodschool.co.uk', '111111'),
	('b25f8d1f-104f-49a8-a763-1c4c4b20dc39', 'b0d8d0b5-8169-45c9-865f-5dd79610c4d0', 'www.ewmeschools.org.uk', '111111'),
	('111563d4-46bb-4839-bcbf-f8ed56d5a42f', '1f01a51f-f95c-4d5e-85df-40d1e0ed23b8', 'www.ewmeschools.org.uk', '111111'),
	('ea387f46-89d2-483a-ab69-17f10a0bbe48', 'cdb7bbac-3497-4eda-b51e-44c5731fd8fc', NULL, '111111'),
	('e3eee9af-c01a-4238-a374-34bd9fec0f60', '8f067d47-0d42-431e-8091-cccbe8b71f13', NULL, '111111'),
	('bad2abfc-6b8e-4113-991c-a4078ef26d9b', '3180bc58-f0ce-4268-81b8-3500b63238aa', NULL, '111111'),
	('a4a227fb-697c-464e-9b55-8a225d0e2366', '1546722a-7f22-48a6-b453-5e37ffe07b0b', NULL, '111111'),
	('c9559b8e-afa9-4352-99eb-ab59d8caf483', 'f96da737-9826-45f9-8f0f-9927cad6a23f', NULL, '111111'),
	('044455ac-34a7-4bf2-874a-236f8402d1f3', '477f2d54-eece-4ecc-b7d2-086bcf7a183c', NULL, '111111'),
	('7eb07e38-8188-404a-9d58-c278264ca345', 'ade83951-36cd-4cb5-9d8e-640de93dac8f', NULL, '111111'),
	('bfc0b3bf-1440-4cc6-ad13-7cb632bcfbee', 'ed328976-8197-4c78-82fd-b5166a3af632', NULL, '111111'),
	('a184f52c-b7b0-4191-b3ef-89062e162f5d', 'd7a1353e-1b26-43ca-ae70-ea5d2803611e', NULL, '111111');


--
-- Data for Name: establishment_geography; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_geography (establishment_geography_id, establishment_id, local_authority_id, government_office_region_id, district_administrative_id, administrative_ward_id, parliamentary_constituency_id, lsoa_id, msoa_id, urban_rural_id) VALUES
	('f01403ce-f4dd-43cf-a408-d66671b7eb0a', '1d6a7191-daee-43b7-a04e-4dbfb404c551', '3332ea83-bcbe-48d1-970d-a3650d9bcf10', '7ca695f4-dfcd-4f78-bdaf-17861eafbf97', '6ef1f577-d0bc-4698-951c-f202f9eaada6', 'e73f0fc2-114a-4772-a84e-5363b02ba34b', '714fb4a2-4d2e-4875-9853-1d7d6696559e', 'cec78739-d3a7-4831-9934-8dec5c5bdcd1', '5ed6445f-c41a-4778-9a5c-55ba74a2155b', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('59956e1a-cdb3-4177-8cd7-f888af1c13b8', 'e8e757a7-7d0d-417e-919f-954050e393e2', '3574e75c-8870-449a-82e7-1b083e2efc42', '1375841f-e6ba-4cda-9fac-753ff9df93a2', '9a5cfcfa-3605-4253-8e1c-fc081510a4ea', '9a2f2163-03c6-45b8-84e0-b34cc7a3450c', '6c7acd08-ad7f-406e-85e4-0bade3e57de6', '05aa5060-26b4-4edf-ad40-5e4640903d5a', '0d87ce8f-019d-4403-9527-975bbabd10e1', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('c0dd6e33-5e1e-49ea-a9f3-cb992b42fb96', 'fa40eca3-efee-439a-b959-e82d43bb3e50', '0a78f87e-d71b-44c3-b598-2cc2b8038e95', '489dce3e-58d7-44c5-b9ef-2f7d7cbdb592', 'c8efb411-9c6d-492e-af1e-624ed743712f', 'f22dfd05-c647-403a-bebd-69fb3a62cca6', '93b33a64-95d1-4d7f-9142-4acc73221e9a', '22d38930-6da2-4b70-9bca-6208cbb43ba5', 'cddc19f9-9b91-4e98-a4c8-656753fd673c', 'fba31373-6bf1-4ad2-9d63-a2c783849aad'),
	('354ffde3-7a70-46ef-aa27-28a86bc69b59', '6bc7d160-b44a-49b2-b06e-1ed1d9d13a46', '77b9cfe6-842e-41c8-9be4-410cac32719a', 'f5cdf1f1-5f75-4420-b597-862614e13549', '05471fcf-d815-4c82-a7f6-6a9ff75cdaa2', 'cf41c2bc-c0cc-4394-992e-1db6d9f032dd', '8d116d07-483e-41bc-83ea-00c89c3f3a6d', 'c4402a6f-a614-4961-a889-554ef686642a', '011465c5-0d85-498d-8b85-14ea8833c9d5', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('3efd06ad-e063-4f9d-9833-a3dcae29c0fc', 'b0d8d0b5-8169-45c9-865f-5dd79610c4d0', '942f0927-84a7-43b6-8be9-68f88917b043', '32e46d74-0ebf-495b-8261-2c508cd2c2bb', '1146af1e-822e-49f1-a51e-da31f849045c', 'f08ea39d-20ae-4f5e-8274-15207e7b5eec', 'd180f323-3f6f-44dc-a1de-d1cac6e11c0c', '84494da7-5525-4dc5-a454-83a2b9b7bdc0', 'bc444798-7011-43c1-a1e2-269efd7885ef', '1c041cb3-373a-4dd5-9af4-2950293776bc'),
	('0f8b5356-174f-4e41-875b-ce71a226f01a', '1f01a51f-f95c-4d5e-85df-40d1e0ed23b8', '942f0927-84a7-43b6-8be9-68f88917b043', '32e46d74-0ebf-495b-8261-2c508cd2c2bb', '1146af1e-822e-49f1-a51e-da31f849045c', 'f08ea39d-20ae-4f5e-8274-15207e7b5eec', 'd180f323-3f6f-44dc-a1de-d1cac6e11c0c', '534b5a89-c075-4962-8367-8c8ffc158b9e', 'edc1ad99-4391-4d91-8717-6c10929ae180', '1c041cb3-373a-4dd5-9af4-2950293776bc'),
	('339a86d1-c536-4d03-89b4-c4caf688c37a', 'cdb7bbac-3497-4eda-b51e-44c5731fd8fc', 'dc9f9e86-8d80-46b7-87bc-e998cafca819', '32e46d74-0ebf-495b-8261-2c508cd2c2bb', '38ab2b8e-4373-4176-8944-4c6d8cffa7d8', 'c21f6874-6733-4b9b-bc1a-b54fbb495ac9', 'c487eba0-9903-4df2-b999-20f1cca784fb', '84badc4c-a7f2-4af6-8532-8ebf665e5686', '0d9136b3-d6e1-4143-bc20-59738dffb35b', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('a55077e4-4e14-4c86-9ae9-da25695c183d', '8f067d47-0d42-431e-8091-cccbe8b71f13', 'dc9f9e86-8d80-46b7-87bc-e998cafca819', '32e46d74-0ebf-495b-8261-2c508cd2c2bb', '38ab2b8e-4373-4176-8944-4c6d8cffa7d8', '0af643ac-6840-48a4-8ed7-dc98ad8626a9', '485e8a03-6bd3-4c3b-95d6-baf2f9b44cad', 'd7b13e80-761e-4cb2-b40f-0dfb91095689', '6c891a27-897f-41ec-ac35-7e207d4fead3', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('5c00c952-80f2-4e12-9a07-f5d923bc8bf9', '3180bc58-f0ce-4268-81b8-3500b63238aa', 'dc9f9e86-8d80-46b7-87bc-e998cafca819', '32e46d74-0ebf-495b-8261-2c508cd2c2bb', '38ab2b8e-4373-4176-8944-4c6d8cffa7d8', '28286c17-e7ea-4022-b909-1a6b60808185', '485e8a03-6bd3-4c3b-95d6-baf2f9b44cad', '56a40580-3dbd-4d1f-bdaa-54370f39b26d', 'd40b3466-6329-406a-93f7-a4978722af70', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('ae9c603b-31d8-43d6-9f74-0df95cb48dcd', '1546722a-7f22-48a6-b453-5e37ffe07b0b', 'dc9f9e86-8d80-46b7-87bc-e998cafca819', '32e46d74-0ebf-495b-8261-2c508cd2c2bb', '38ab2b8e-4373-4176-8944-4c6d8cffa7d8', 'bdd0a9a0-8af5-4232-b7ce-30a76be572ca', '485e8a03-6bd3-4c3b-95d6-baf2f9b44cad', 'e8b85e8f-e837-4dd2-9ac3-b3f22e6f83a6', '5a9caa00-1c9c-49c6-ba30-dd3df2b2599f', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('13788a36-4b91-4129-bd19-eb386dcda708', 'f96da737-9826-45f9-8f0f-9927cad6a23f', 'dc9f9e86-8d80-46b7-87bc-e998cafca819', '32e46d74-0ebf-495b-8261-2c508cd2c2bb', '38ab2b8e-4373-4176-8944-4c6d8cffa7d8', '1bcfab2c-6971-4998-9c38-55c1e039be68', 'c487eba0-9903-4df2-b999-20f1cca784fb', '52692e65-37ae-4851-9b83-d318448b8a15', '35b2356d-cad3-415a-af7d-dc32bd148ae2', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('dbbee3cc-5ce5-4b29-ad53-6396c46d97cc', '477f2d54-eece-4ecc-b7d2-086bcf7a183c', 'dc9f9e86-8d80-46b7-87bc-e998cafca819', '32e46d74-0ebf-495b-8261-2c508cd2c2bb', '38ab2b8e-4373-4176-8944-4c6d8cffa7d8', 'b40c3129-d1f9-4ee7-9b6f-a4ed111c7109', '485e8a03-6bd3-4c3b-95d6-baf2f9b44cad', '1e9505f2-4f09-47be-82fe-648e59412d31', 'c5197681-247e-481b-b496-b4503db81187', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('946fe1e4-1fc3-4ead-be81-a0e3338aee83', 'ade83951-36cd-4cb5-9d8e-640de93dac8f', 'dc9f9e86-8d80-46b7-87bc-e998cafca819', '32e46d74-0ebf-495b-8261-2c508cd2c2bb', '38ab2b8e-4373-4176-8944-4c6d8cffa7d8', '9fdf9c47-28c6-4d2f-ba6f-906b588206c3', '485e8a03-6bd3-4c3b-95d6-baf2f9b44cad', 'e8a5b83c-e982-454d-a84a-3bb3b76806f3', '5577ba9a-318d-4440-8baa-7abf3925e7f0', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('6e0b174a-a6da-424a-b60e-fd13f52d2e47', 'ed328976-8197-4c78-82fd-b5166a3af632', 'dc9f9e86-8d80-46b7-87bc-e998cafca819', '32e46d74-0ebf-495b-8261-2c508cd2c2bb', '38ab2b8e-4373-4176-8944-4c6d8cffa7d8', '1bcfab2c-6971-4998-9c38-55c1e039be68', 'c487eba0-9903-4df2-b999-20f1cca784fb', '34a90645-b540-4351-8d4b-356bec2a4c76', '35b2356d-cad3-415a-af7d-dc32bd148ae2', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('e77e8e78-6655-4e67-847a-697ca8f94ebf', 'd7a1353e-1b26-43ca-ae70-ea5d2803611e', 'dc9f9e86-8d80-46b7-87bc-e998cafca819', '32e46d74-0ebf-495b-8261-2c508cd2c2bb', '38ab2b8e-4373-4176-8944-4c6d8cffa7d8', 'e8e39ac5-cd31-4312-8f42-063aed530c47', 'c487eba0-9903-4df2-b999-20f1cca784fb', 'e43873e2-e36a-4f91-876b-b62ee15b6a55', '15cd7b16-0306-42b8-8208-9cca5b9deda3', '8826f875-fade-4b0b-a4b1-f8536505ecd1');


--
-- Data for Name: establishment_lifecycle; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_lifecycle (establishment_lifecycle_id, establishment_id, establishment_status_id, open_date, close_date, reason_establishment_opened_id, reason_establishment_closed_id, last_changed_date) VALUES
	('59477c35-efd3-466f-84f4-80f76671d996', '1d6a7191-daee-43b7-a04e-4dbfb404c551', 1, '2010-09-01', NULL, 2, NULL, '2026-06-23'),
	('b2a67ad1-d5e3-407f-9482-44b19471bd11', 'e8e757a7-7d0d-417e-919f-954050e393e2', 1, '2007-09-01', NULL, 2, NULL, '2026-06-23'),
	('22114396-59e5-4cda-9d25-3855cfc5246d', 'fa40eca3-efee-439a-b959-e82d43bb3e50', 2, '2009-09-01', '2016-02-29', 2, 12, '2018-07-02'),
	('92b704f8-a684-4cd5-a11a-347401518b46', '6bc7d160-b44a-49b2-b06e-1ed1d9d13a46', 1, '2011-11-01', NULL, 1, NULL, '2026-06-23'),
	('d03885de-e4ab-436d-bf7d-014aaff9e5c4', 'b0d8d0b5-8169-45c9-865f-5dd79610c4d0', 1, NULL, NULL, NULL, NULL, '2026-06-23'),
	('180e1bab-1b9d-4aab-8380-92357b5c51fc', '1f01a51f-f95c-4d5e-85df-40d1e0ed23b8', 1, NULL, NULL, NULL, NULL, '2026-06-23'),
	('aee916b0-b56f-48ca-80a5-7c39776dd1fa', 'cdb7bbac-3497-4eda-b51e-44c5731fd8fc', 1, '2008-02-07', NULL, NULL, NULL, '2025-06-20'),
	('cea71cf5-c1ac-45ae-a824-ba2fb53b968d', '8f067d47-0d42-431e-8091-cccbe8b71f13', 1, '2006-03-14', NULL, NULL, NULL, '2025-06-20'),
	('714ce3b4-ad15-4b5e-ab5e-e92387d4f967', '3180bc58-f0ce-4268-81b8-3500b63238aa', 1, '2008-03-03', NULL, NULL, NULL, '2025-06-20'),
	('c547d071-d872-4879-9261-06a5d1df477a', '1546722a-7f22-48a6-b453-5e37ffe07b0b', 1, '2009-12-14', NULL, NULL, NULL, '2025-06-20'),
	('4a00476f-4521-474e-9516-2e6452425dbb', 'f96da737-9826-45f9-8f0f-9927cad6a23f', 1, '2009-12-14', NULL, NULL, NULL, '2025-06-20'),
	('88d9576c-c0d0-4454-b475-237c26c9424a', '477f2d54-eece-4ecc-b7d2-086bcf7a183c', 1, '2008-01-16', NULL, NULL, NULL, '2025-06-20'),
	('a3219543-4ca6-4b1d-895d-8382c905a930', 'ade83951-36cd-4cb5-9d8e-640de93dac8f', 1, '2008-01-16', NULL, NULL, NULL, '2025-06-20'),
	('81736a82-64a5-4af7-a51f-6b7ba8bcfcd7', 'ed328976-8197-4c78-82fd-b5166a3af632', 1, '2008-02-07', NULL, NULL, NULL, '2025-06-20'),
	('0441e01a-90ab-42ec-a9c6-a9b3e77cc53b', 'd7a1353e-1b26-43ca-ae70-ea5d2803611e', 1, '2006-09-28', NULL, NULL, NULL, '2025-06-20');


--
-- Data for Name: establishment_party_role; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_party_role (establishment_party_role_id, establishment_party_role_type_id, legal_entity_id, person_id, start_date, end_date) VALUES
	('d5d273e6-adea-4a3b-886c-3c1632ac9e4b', 1, 'afd36da5-3292-421f-af78-73e0d6d42405', NULL, NULL, NULL),
	('39d8bd36-73f0-4f10-a92d-33d055192a0e', 1, '41ff8d1d-d0ba-415e-ae39-3fdce680e460', NULL, NULL, NULL),
	('4ddfc076-c7a7-45bf-8782-5bfa6a4b4614', 4, 'c4573ea5-4946-4971-85f9-cb73896bff75', NULL, NULL, NULL),
	('65211b18-24c0-4605-b69b-476183c5b6ed', 1, '26e99bb7-1198-4943-85ab-5404a0e9481b', NULL, NULL, NULL),
	('11521ce6-13fe-4a0d-aead-7494c4777fba', 4, 'e2c14078-1d3b-444d-b6ff-1479b1394992', NULL, NULL, NULL),
	('76e4976d-0c24-4fd6-9a1c-895a4ca2c818', 1, 'e19062e6-f475-4e3c-8aab-d08a91aedc6b', NULL, NULL, '2016-02-29'),
	('b026f18a-b3c8-4425-9e56-622c6a7c5d8f', 1, 'ea91f652-ad88-4ae8-b02b-71778ee480da', NULL, NULL, NULL);


--
-- Data for Name: establishment_responsibility; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_responsibility (establishment_responsibility_id, establishment_id, legal_entity_id, person_id, responsibility_type_id, academy_trust_type_id, start_date, end_date, is_current) VALUES
	('74c3455c-a8c6-456d-8cfd-3f30d0661afb', '1d6a7191-daee-43b7-a04e-4dbfb404c551', 'afd36da5-3292-421f-af78-73e0d6d42405', NULL, 1, 2, '2015-07-01', NULL, true),
	('04f342d3-94fe-40df-86e2-99437d0e4e36', '1d6a7191-daee-43b7-a04e-4dbfb404c551', '41ff8d1d-d0ba-415e-ae39-3fdce680e460', NULL, 1, 1, '2010-09-01', NULL, false),
	('f09d3678-252a-4eb5-901a-f2f3166309e9', '1d6a7191-daee-43b7-a04e-4dbfb404c551', 'c4573ea5-4946-4971-85f9-cb73896bff75', NULL, 3, NULL, '2010-09-01', NULL, true),
	('82c694d4-949b-4ede-9cb2-e38bcf9b9366', 'e8e757a7-7d0d-417e-919f-954050e393e2', '26e99bb7-1198-4943-85ab-5404a0e9481b', NULL, 1, 2, '2021-10-04', NULL, true),
	('4c343540-864c-4fd5-a314-ba45a8d0d10b', 'e8e757a7-7d0d-417e-919f-954050e393e2', '26e99bb7-1198-4943-85ab-5404a0e9481b', NULL, 1, 1, '2007-09-01', NULL, false),
	('ea1f243c-a587-4914-a80e-225a95f5c0a9', 'e8e757a7-7d0d-417e-919f-954050e393e2', 'e2c14078-1d3b-444d-b6ff-1479b1394992', NULL, 3, NULL, '2007-09-01', NULL, true),
	('a6b5a447-9c19-4934-b81b-f78e5dbc790b', 'fa40eca3-efee-439a-b959-e82d43bb3e50', 'e19062e6-f475-4e3c-8aab-d08a91aedc6b', NULL, 1, 2, '2009-09-01', '2016-02-29', false),
	('426b11a3-d21b-4cb2-9680-917ff267a032', '6bc7d160-b44a-49b2-b06e-1ed1d9d13a46', 'ea91f652-ad88-4ae8-b02b-71778ee480da', NULL, 1, 1, '2011-11-01', NULL, false),
	('47711d2c-49f5-4d92-919e-5a996cd04c60', '6bc7d160-b44a-49b2-b06e-1ed1d9d13a46', 'ea91f652-ad88-4ae8-b02b-71778ee480da', NULL, 1, 2, '2021-03-30', NULL, true);


--
-- Data for Name: site; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.site (site_id, address_id, site_name, uprn) VALUES
	('e04ce9c7-4538-480b-a64d-0e1e070a89ba', 'fcc7cf14-dc7e-46b3-8658-a754b28555db', NULL, 3455015782),
	('9c0b7d34-0657-4f6a-9ab9-f01c066a48c0', '0fdce0e3-4650-4f62-9845-969731f0b089', NULL, 5300060053),
	('88521023-05aa-4999-848c-2a00003ea0ca', '6d5f9d0e-57c0-4018-8240-6100a6e43f29', NULL, 10090666596),
	('c03ddea1-3d72-47f2-af45-18353ea919dc', '5c2491b8-75d4-4c13-9639-1ca98fa3b1d0', NULL, 10006581609),
	('bfcd287f-ddcb-4420-8395-4bd545945c82', 'ff345e76-c62b-4c52-a860-4778621a2583', NULL, 100081218005),
	('7d2966da-6df3-443a-8bea-340b62785064', 'b39af57d-8be6-4138-a510-4be0d9109a60', NULL, 100081212588),
	('c3dc5dc3-e160-42c5-97f9-ee24d5fd58f9', '9d8ad5fc-40c4-4c59-bd78-8673bf4c68f0', NULL, 100091605340),
	('ce9b2306-6638-4554-a17c-1712f61ae2ab', '54a8c3f7-693c-458b-823e-16b7218c6509', NULL, NULL),
	('3b605c5d-27ad-4db3-9f60-7b4c3025d157', '239ba1c0-851c-4df2-8af6-91e4010526ef', NULL, 10024158444),
	('6d6e41ad-b38e-4585-a080-2ad5dcbc7ca8', '6211039c-83ed-4756-b132-3122ac6ffb6c', NULL, 100091593148),
	('95abe1b8-64e0-44c3-9574-3b6b386d3de5', 'df88d20c-c184-42a1-96af-5c11d3ca4359', NULL, 10012151948),
	('bc5cfca4-23d9-4d55-843f-dd85152d189d', 'c71057d8-8c57-48b0-96c0-dbe2aa012179', NULL, 100091595925),
	('cbc839b5-87d2-4a0e-8744-cba53ba048c8', 'd28b3cfe-c86e-431e-a685-e427c6141f67', NULL, 10012152076),
	('6f9535ca-66b8-46b2-a950-95b2beb53c5a', 'ffde81ca-060d-4db1-83be-7e04ec7161dd', NULL, 100091656436),
	('70c06167-aef4-4131-ae23-b889447004f7', 'c4ecf380-2555-4f98-a218-1ede3ae78d3f', NULL, 200001258935);


--
-- Data for Name: establishment_to_site; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_to_site (establishment_id, site_id, is_main_site) VALUES
	('1d6a7191-daee-43b7-a04e-4dbfb404c551', 'e04ce9c7-4538-480b-a64d-0e1e070a89ba', true),
	('e8e757a7-7d0d-417e-919f-954050e393e2', '9c0b7d34-0657-4f6a-9ab9-f01c066a48c0', true),
	('fa40eca3-efee-439a-b959-e82d43bb3e50', '88521023-05aa-4999-848c-2a00003ea0ca', true),
	('6bc7d160-b44a-49b2-b06e-1ed1d9d13a46', 'c03ddea1-3d72-47f2-af45-18353ea919dc', true),
	('b0d8d0b5-8169-45c9-865f-5dd79610c4d0', 'bfcd287f-ddcb-4420-8395-4bd545945c82', true),
	('1f01a51f-f95c-4d5e-85df-40d1e0ed23b8', '7d2966da-6df3-443a-8bea-340b62785064', true),
	('cdb7bbac-3497-4eda-b51e-44c5731fd8fc', 'c3dc5dc3-e160-42c5-97f9-ee24d5fd58f9', true),
	('8f067d47-0d42-431e-8091-cccbe8b71f13', 'ce9b2306-6638-4554-a17c-1712f61ae2ab', true),
	('3180bc58-f0ce-4268-81b8-3500b63238aa', '3b605c5d-27ad-4db3-9f60-7b4c3025d157', true),
	('1546722a-7f22-48a6-b453-5e37ffe07b0b', '6d6e41ad-b38e-4585-a080-2ad5dcbc7ca8', true),
	('f96da737-9826-45f9-8f0f-9927cad6a23f', '95abe1b8-64e0-44c3-9574-3b6b386d3de5', true),
	('477f2d54-eece-4ecc-b7d2-086bcf7a183c', 'bc5cfca4-23d9-4d55-843f-dd85152d189d', true),
	('ade83951-36cd-4cb5-9d8e-640de93dac8f', 'cbc839b5-87d2-4a0e-8744-cba53ba048c8', true),
	('ed328976-8197-4c78-82fd-b5166a3af632', '6f9535ca-66b8-46b2-a950-95b2beb53c5a', true),
	('d7a1353e-1b26-43ca-ae70-ea5d2803611e', '70c06167-aef4-4131-ae23-b889447004f7', true);


--
-- Data for Name: organisation_group; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.organisation_group (organisation_group_id, name, organisation_group_type_id, local_authority_id, open_date, close_date) VALUES
	('3d91a426-a959-4f7f-bf9e-d71757812d0b', 'Federation of Eileen Wade and Milton Ernest VC lower schools', 1, NULL, '2011-01-13', NULL),
	('4246b141-b5b8-45d0-b301-9f0de14655a2', 'Southend Children''s Centres', 2, 'dc9f9e86-8d80-46b7-87bc-e998cafca819', '2016-10-01', NULL);


--
-- Data for Name: group_identifier; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.group_identifier (group_identifier_id, establishment_party_role_id, organisation_group_id, group_identifier_type_id, group_identifier_issuer_id, value, is_current) VALUES
	('61616f5c-75dc-4434-aeec-4a2a900ab174', 'd5d273e6-adea-4a3b-886c-3c1632ac9e4b', NULL, 1, 1, '2777', true),
	('701c4dd0-ee30-428a-bca0-b8b778f1ad95', 'd5d273e6-adea-4a3b-886c-3c1632ac9e4b', NULL, 2, 1, 'TR00567', true),
	('7bf09182-ea67-47b6-9a62-206b06324e7b', '39d8bd36-73f0-4f10-a92d-33d055192a0e', NULL, 1, 1, '2779', false),
	('80de87ba-5ffc-4f98-b3f6-b2e02e62d9ff', '39d8bd36-73f0-4f10-a92d-33d055192a0e', NULL, 2, 1, 'TR00569', false),
	('1f62f845-ac76-4515-8a28-d14d0e81ca4c', '4ddfc076-c7a7-45bf-8782-5bfa6a4b4614', NULL, 1, 1, '4949', true),
	('024957a9-305d-47a2-b3c5-1c46aac4e445', '4ddfc076-c7a7-45bf-8782-5bfa6a4b4614', NULL, 2, 1, 'SP00125', true),
	('a4ca1cc4-24ad-4ba6-90a5-7c81812fbf7b', '65211b18-24c0-4605-b69b-476183c5b6ed', NULL, 1, 1, '23869', true),
	('80bf620c-372e-4995-a4e7-cbd88e4b8a4c', '65211b18-24c0-4605-b69b-476183c5b6ed', NULL, 2, 1, 'TR02103', true),
	('c20e1792-811d-4b64-b7f7-b7ddd8c5830b', '65211b18-24c0-4605-b69b-476183c5b6ed', NULL, 1, 1, '4737', false),
	('23c66f7e-931a-45f5-93ec-784b4798e248', '11521ce6-13fe-4a0d-aead-7494c4777fba', NULL, 1, 1, '2914', true),
	('038580b9-6f16-45f5-b8d1-af73d8ea0ad0', '11521ce6-13fe-4a0d-aead-7494c4777fba', NULL, 2, 1, 'SP00172', true),
	('1f99867c-e0ad-48e0-b7fe-c34e983d9583', '76e4976d-0c24-4fd6-9a1c-895a4ca2c818', NULL, 1, 1, '3839', false),
	('6c31c797-4041-420c-99f7-5f7b7f1e416d', '76e4976d-0c24-4fd6-9a1c-895a4ca2c818', NULL, 2, 1, 'TR01385', false),
	('ad266125-e142-4019-ac9a-35db15d57548', 'b026f18a-b3c8-4425-9e56-622c6a7c5d8f', NULL, 1, 1, '2055', false),
	('2a53f1e2-8efc-4ff6-a311-bcc1e19a72c3', 'b026f18a-b3c8-4425-9e56-622c6a7c5d8f', NULL, 1, 1, '20364', true),
	('02bd4823-8d2f-4f1c-bf21-0154ac4b3a3b', 'b026f18a-b3c8-4425-9e56-622c6a7c5d8f', NULL, 2, 1, 'TR00009', true),
	('aa442da4-b5ee-4100-bcfe-c0814a4bf7dd', NULL, '3d91a426-a959-4f7f-bf9e-d71757812d0b', 1, 1, '1809', true),
	('6f75edee-a7cb-481d-bcbf-2548a680215c', NULL, '4246b141-b5b8-45d0-b301-9f0de14655a2', 1, 1, '86052', true);


--
-- Data for Name: organisation_group_member; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.organisation_group_member (organisation_group_member_id, organisation_group_id, establishment_id, joined_date, left_date, is_lead_member) VALUES
	('73684d04-092f-4aba-b3d7-3341a61d356d', '3d91a426-a959-4f7f-bf9e-d71757812d0b', '1f01a51f-f95c-4d5e-85df-40d1e0ed23b8', '2011-01-13', NULL, NULL),
	('3c86ab87-d56c-492e-8e59-02e5d50fd917', '3d91a426-a959-4f7f-bf9e-d71757812d0b', 'b0d8d0b5-8169-45c9-865f-5dd79610c4d0', '2011-01-13', NULL, NULL),
	('2ebeb552-2cf0-46e6-af50-21f4c8abebce', '4246b141-b5b8-45d0-b301-9f0de14655a2', '1546722a-7f22-48a6-b453-5e37ffe07b0b', '2016-10-01', NULL, false),
	('65c9e5bd-8d00-4837-a2df-d7e8c610ced4', '4246b141-b5b8-45d0-b301-9f0de14655a2', 'cdb7bbac-3497-4eda-b51e-44c5731fd8fc', '2016-10-01', NULL, false),
	('4922e356-7495-4d7c-a18c-a77783e64ea1', '4246b141-b5b8-45d0-b301-9f0de14655a2', 'd7a1353e-1b26-43ca-ae70-ea5d2803611e', '2016-10-01', NULL, false),
	('61c11ff5-2ccb-4eda-ab68-86f3bd432ac5', '4246b141-b5b8-45d0-b301-9f0de14655a2', '3180bc58-f0ce-4268-81b8-3500b63238aa', '2016-10-01', NULL, false),
	('38512300-2773-49ad-8acd-a22a951eb53d', '4246b141-b5b8-45d0-b301-9f0de14655a2', '477f2d54-eece-4ecc-b7d2-086bcf7a183c', '2016-10-01', NULL, false),
	('f0b783a4-b735-4f1c-b57c-c0c675594588', '4246b141-b5b8-45d0-b301-9f0de14655a2', 'ade83951-36cd-4cb5-9d8e-640de93dac8f', '2016-10-01', NULL, false),
	('759c57e4-9a8e-41be-aa76-90a7f22561c0', '4246b141-b5b8-45d0-b301-9f0de14655a2', 'ed328976-8197-4c78-82fd-b5166a3af632', '2016-10-01', NULL, false),
	('c017b6ce-b1dc-47cc-bb04-52ab84203c0b', '4246b141-b5b8-45d0-b301-9f0de14655a2', 'f96da737-9826-45f9-8f0f-9927cad6a23f', '2016-10-01', NULL, false),
	('b94191f1-0b27-4a00-a174-d12932223c20', '4246b141-b5b8-45d0-b301-9f0de14655a2', '8f067d47-0d42-431e-8091-cccbe8b71f13', '2016-10-01', NULL, true);


--
-- Data for Name: organisation_identifier; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.organisation_identifier (organisation_identifier_id, legal_entity_id, organisation_identifier_type_id, value, is_current) VALUES
	('73392f16-1df7-4079-9941-920197b42da5', 'afd36da5-3292-421f-af78-73e0d6d42405', 1, '07747126', true),
	('86325570-6fcc-4b32-b8b4-89bde9d13eee', 'afd36da5-3292-421f-af78-73e0d6d42405', 2, '10059286', true),
	('e9cd8a38-1db4-416a-93ba-7ccec199f3b3', '41ff8d1d-d0ba-415e-ae39-3fdce680e460', 1, '07158839', true),
	('b649a4f7-35ea-4e05-9a2d-a1eff31a0da0', '41ff8d1d-d0ba-415e-ae39-3fdce680e460', 2, '10061289', true),
	('3bf70429-98c0-4b0f-bfd3-2eed7e24f982', '26e99bb7-1198-4943-85ab-5404a0e9481b', 1, '05412502', true),
	('8cef718b-7c30-4c5a-b858-a3b6cb16ee7c', '26e99bb7-1198-4943-85ab-5404a0e9481b', 2, '10058191', true),
	('453a9c7f-2690-4c85-9c35-4a2e96059f20', 'e19062e6-f475-4e3c-8aab-d08a91aedc6b', 1, '06888873', true),
	('54127ada-9eab-45e6-b20e-ad9c4bbbf65c', 'ea91f652-ad88-4ae8-b02b-71778ee480da', 1, '07795736', true),
	('56f34bc7-b3bc-4a1b-9400-c8792ce1f849', 'ea91f652-ad88-4ae8-b02b-71778ee480da', 2, '10059335', true);


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
	('3d4695eb-581c-41a7-9bba-5bfffc5a5ee7', '3fac1c89-9b7c-4e6f-b98d-ecbc0a1f1496', 11, 16),
	('6b2e9dab-8dd5-4258-b2f3-e39f5cfa5df8', '39aa9579-4da7-4ecd-871d-3f0e15f5e502', 4, 19),
	('38320af6-8c49-4089-9c89-b321c03f4e73', '2aaf5087-cee9-43a3-9d40-dedfe621def2', 11, 19),
	('2032f134-1809-4a9b-a53a-8a0bf5c61cc4', '2ee73c4c-86e1-4dae-9715-babc2097281e', 11, 19),
	('f21e9299-1b31-463b-afa3-946923639530', '2aeebba8-8630-469e-95f2-31db5e200c31', 5, 11),
	('f01300e8-c487-4c2c-9f29-2fd7802fee9e', '5d70c5c1-82a1-40df-8d85-8c43bc62c9ab', 4, 11);


--
-- PostgreSQL database dump complete
--

\unrestrict VVKBnC7KrOA91T0ESfwK2H9iKFH6FcAQ0LUqwDQMAZlIGry8nY2SNQ3NdkuretD

