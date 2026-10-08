--
-- PostgreSQL database dump
--

\restrict e93lnUNAKdAdBH0TCxP2NrCyKfjd74NPFLjPmqY5wjSxAG57bfd9amwhU2lwY3X

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
	('6c6334c4-3ae9-4cbd-87e8-03bc47f3458f', 'THE CO-OPERATIVE ACADEMIES TRUST', 1, NULL, '2011-08-19', NULL),
	('b8a3c074-9870-4b43-b3e1-3ba90017f1a2', 'THE CO-OPERATIVE ACADEMY OF STOKE ON TRENT', 1, NULL, '2010-02-16', NULL),
	('5355748e-57d2-460c-a10f-6cd9c01d188e', 'The Co-operative Group', NULL, NULL, NULL, NULL),
	('9c5c38c8-c175-4313-9e0b-96d909bd10c7', 'HIVE EDUCATION TRUST', 1, NULL, '2005-04-04', NULL),
	('55f19c2d-eab1-4a54-a154-4c5d7752f2cb', 'Diocese of London', NULL, NULL, NULL, NULL),
	('d261dcca-92e3-46a0-a927-c871901d84cd', 'MARCH 2016 LIMITED', 1, NULL, '2009-04-27', NULL),
	('4f28bece-75ed-4e30-a04e-f963e3e13ce9', 'THE ACADEMY @ RIDGEWOOD TRUST', 1, NULL, '2011-10-03', NULL),
	('560bdb6e-dd12-4b6a-bd25-2a1b7acf8209', 'The North Tyneside Learning Trust', NULL, NULL, NULL, NULL),
	('d63c950d-8f31-4540-8933-415fd3e0ddfe', 'DUNSTONE EDUCATION TRUST', 1, NULL, '2009-07-13', NULL),
	('5be037f1-12fc-4b40-829c-4135c96fc783', 'Acorn Care and Education Ltd', NULL, NULL, NULL, NULL);


--
-- Data for Name: academy_trust_classification; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.academy_trust_classification (academy_trust_classification_id, legal_entity_id, academy_trust_type_id, start_date, end_date, is_current) VALUES
	('b2491a5b-c338-4a42-afba-101da4c44772', '6c6334c4-3ae9-4cbd-87e8-03bc47f3458f', 2, NULL, NULL, true),
	('38e41c55-9024-49b4-851f-732aee5d6d7c', 'b8a3c074-9870-4b43-b3e1-3ba90017f1a2', 1, NULL, NULL, false),
	('3f473cee-c5f6-46f0-9b35-139a7e4e5122', '9c5c38c8-c175-4313-9e0b-96d909bd10c7', 2, NULL, NULL, true),
	('80829a16-0be1-41d9-9443-90c7378bbcf3', '9c5c38c8-c175-4313-9e0b-96d909bd10c7', 1, NULL, NULL, false),
	('1327f1ea-4b85-4844-848f-b0497ad058ca', 'd261dcca-92e3-46a0-a927-c871901d84cd', 2, NULL, '2016-02-29', false),
	('2ccae914-79b2-44aa-ba92-1ae14963fffe', '4f28bece-75ed-4e30-a04e-f963e3e13ce9', 1, NULL, '2021-03-30', false),
	('b3848bf5-c4ee-4dde-bd16-faf11e556301', '4f28bece-75ed-4e30-a04e-f963e3e13ce9', 2, '2021-03-30', NULL, true),
	('53cc3ed2-ef3a-44b3-94c2-d9940c668d75', 'd63c950d-8f31-4540-8933-415fd3e0ddfe', 2, NULL, NULL, true);


--
-- Data for Name: address; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.address (address_id, address_line_1, address_line_2, address_line_3, town, county, postcode) VALUES
	('f7935d14-72da-4201-84ae-586148bf9d04', 'obfuscated', NULL, 'obfuscated', 'obfuscated', '032', 'ST6 4LD'),
	('4c117266-f803-4e60-a82f-1ccfb137d54a', 'obfuscated', 'Islington', NULL, 'obfuscated', '099', 'N7 8PG'),
	('e3cedd96-0c12-43f7-95cc-77b135880eba', 'obfuscated', 'Blackley', NULL, 'obfuscated', '099', 'M9 7SS'),
	('72f88564-cec8-4d81-8b13-93a11a644e48', 'obfuscated', 'Scawsby', NULL, 'obfuscated', '031', 'DN5 7UB'),
	('5bdc830e-e644-47e1-b3bb-60b6e4e35a05', 'obfuscated', 'Upper Dean', NULL, 'obfuscated', '003', 'PE28 0ND'),
	('bc5185cf-f37a-4d3c-b4e5-c5237e64cee5', 'obfuscated', 'Milton Ernest', NULL, 'obfuscated', '001', 'MK44 1RF'),
	('58f583c0-1780-4e52-81d3-e6b517d679a4', 'obfuscated', 'School Way', 'obfuscated', 'obfuscated', '012', 'SS9 4HX'),
	('1460a89e-3815-41fc-bb91-4a3b735adb3c', 'obfuscated', NULL, NULL, 'obfuscated', '012', 'SS1 1ES'),
	('e85c3f67-4aac-4469-b819-94e760637d41', NULL, 'Centre Place', 'obfuscated', 'obfuscated', '012', 'SS1 2JD'),
	('d81ea02f-563d-4025-9a15-63c936c0ca61', 'obfuscated', 'Hamstel Road', NULL, 'obfuscated', '012', 'SS2 4PQ'),
	('b13ffafd-55d8-41ba-967c-cfa29f968674', 'obfuscated', NULL, NULL, 'obfuscated', '012', 'SS0 0LG'),
	('dca75547-8ada-4832-b1be-d008dbe452a5', 'obfuscated', 'Constable Way', NULL, 'obfuscated', '012', 'SS3 9XX'),
	('b5a61d64-daa5-4180-9040-25c649b795c3', 'obfuscated', NULL, NULL, 'obfuscated', '012', 'SS0 7AU'),
	('04155ac8-afe6-4201-8416-9bb912e8ffe5', 'obfuscated', 'Rayleigh Road', 'obfuscated', 'obfuscated', '012', 'SS9 5UT'),
	('4b9d8479-a5da-490f-926f-c4aa07c75db9', 'obfuscated', 'Eastern Avenue', NULL, 'obfuscated', '012', 'SS2 4BA'),
	('d8fc9c5f-3d29-4d70-836d-0889be1cdd02', 'obfuscated', NULL, NULL, 'obfuscated', '035', 'NE28 9RT'),
	('7e3e18d9-b095-4cf5-96ec-a5112d12aeff', 'obfuscated', NULL, 'obfuscated', 'obfuscated', '019', 'PR2 9YR'),
	('cadae19e-1740-4a75-8bc3-0222ff85b298', 'Kirkby Lonsdale', NULL, NULL, 'Carnforth', '019', 'LA6 2DZ'),
	('074f8293-73f6-490a-8828-39a87016f6e7', 'Egerton Road', 'Charing Heath', NULL, 'Ashford', '018', 'TN27 0AX');


--
-- Data for Name: establishment; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment (establishment_id, urn, ukprn, establishment_number, name, establishment_type_id, education_phase_id) VALUES
	('fafcee68-8981-4f97-928a-5c1f82f94e87', 136102, 10030216, 6905, 'The Co-Operative Academy of Stoke-On-Trent', 4, 5),
	('c1620b5b-a8b7-48ec-a75b-837a17a981f6', 134314, 10024207, 6905, 'St Mary Magdalene Academy', 4, 6),
	('d1041d15-364e-4898-9a35-3d60e8002f85', 135905, NULL, 6910, 'Manchester Creative and Media Academy', 4, 5),
	('06549b72-8a27-4e4e-8e0e-476a56362b93', 137603, 10035482, 4033, 'Ridgewood School', 4, 5),
	('6f838be9-6e95-4a4b-8b56-8197e3eb3f97', 109443, 10077509, 2036, 'Eileen Wade Primary School', 11, 2),
	('b07175a2-a1ca-428d-a085-37fee5a6d098', 109613, 10075753, 3023, 'Milton Ernest CofE Primary School', 10, 2),
	('76ce4bac-644a-4abd-adb8-c1c8e330c6fa', 20338, NULL, NULL, 'Blenheim Children''s Centre', 35, 8),
	('2d334f07-e06d-4c20-9086-5631946fd19f', 20549, NULL, NULL, 'Cambridge Road Children''s Centre', 35, 8),
	('f9f541d9-c2d1-44f4-9d22-2880a46d1b78', 20614, NULL, NULL, 'Centre Place Family Centre', 35, 8),
	('aeb24dea-3777-4a18-82ce-9d7d1ffab595', 21363, NULL, NULL, 'Hamstel Children and Family Centre', 35, 8),
	('5c862086-8457-4014-916c-e1fc75dc52e5', 22422, NULL, NULL, 'Prince Avenue Children and Family Centre', 35, 8),
	('7c396d2d-3485-4455-af63-178bb3416ab9', 22459, NULL, NULL, 'Friars Children''s Centre', 35, 8),
	('5ec8d7e2-76b6-4227-87e5-00175b72e889', 22975, NULL, NULL, 'Summercourt Children''s Centre', 35, 8),
	('2a43ecb5-6cc9-400b-a5de-95a008fb3d1f', 23004, NULL, NULL, 'Eastwood Children''s Centre', 35, 8),
	('451eac75-37a5-45e6-a7f3-a6af4f43d600', 23122, NULL, NULL, 'Temple Sutton Children''s Centre', 35, 8),
	('8eb0a5da-adf1-4513-939d-da19cf86fc26', 132141, 10073628, 2087, 'Hadrian Park Primary School', 11, 2),
	('04e56b86-ffa3-4dff-aa8d-50375323269b', 135936, 10027711, 6906, 'Fulwood Academy', 4, 5),
	('07d2c257-bb12-459f-b418-92f3010ecff3', 112461, 10015990, 6044, 'Underley Garden School', 15, 8),
	('acf43a60-bea2-4e4f-9986-ca83f17d8c37', 119009, 10015772, 6060, 'Heath Farm School', 15, 8);


--
-- Data for Name: capacity_and_pupil_measures; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.capacity_and_pupil_measures (capacity_and_pupil_measures_id, establishment_id, school_capacity, pupil_count, free_school_meal_measure, census_date) VALUES
	('cf533081-e86d-43da-b1b4-83882553247c', 'fafcee68-8981-4f97-928a-5c1f82f94e87', 1050, 1300, 735, NULL),
	('59bec8e2-d11a-4f41-a3b6-ce6f571c9084', 'c1620b5b-a8b7-48ec-a75b-837a17a981f6', 1310, 1561, 465, NULL),
	('80983271-07a4-4876-8b5f-ee18bb8d6392', 'd1041d15-364e-4898-9a35-3d60e8002f85', 660, NULL, NULL, NULL),
	('58a60eb1-15b1-49a3-8ca7-c6c4a85b6c68', '06549b72-8a27-4e4e-8e0e-476a56362b93', 1512, 1425, 250, NULL),
	('bccafb94-0b4d-4f49-872e-63ea9bc6d4fc', '6f838be9-6e95-4a4b-8b56-8197e3eb3f97', 23610, 70, 10, NULL),
	('9a295281-6367-4861-a4d9-9cc507b94322', 'b07175a2-a1ca-428d-a085-37fee5a6d098', 63964, 67, 5, NULL),
	('d634b2c0-bfaf-4c72-bb33-2ed059b4f26b', '8eb0a5da-adf1-4513-939d-da19cf86fc26', 965, 422, 114, NULL),
	('63f4bb00-20af-47cc-bb88-f0596540f950', '04e56b86-ffa3-4dff-aa8d-50375323269b', 1000, 973, 418, NULL),
	('d42c0817-dd93-4839-a62b-e01e253b8c1d', '07d2c257-bb12-459f-b418-92f3010ecff3', 84881, 101, NULL, NULL),
	('3422b688-499a-4edd-8ad1-eb049b7d8152', 'acf43a60-bea2-4e4f-9986-ca83f17d8c37', 20643, 141, NULL, NULL);


--
-- Data for Name: education_admissions_and_provision; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.education_admissions_and_provision (education_admissions_and_provision_id, establishment_id, gender_of_entry_type_id, admissions_policy_id, boarding_provision_id, nursery_provision_id, sixth_form_provision_id) VALUES
	('18907f4b-19a1-41f8-9273-2d20d5a1bb9d', 'fafcee68-8981-4f97-928a-5c1f82f94e87', 1, 1, 1, 3, 3),
	('10c2071b-6aaf-4be4-8309-c8aebc113370', 'c1620b5b-a8b7-48ec-a75b-837a17a981f6', 1, 1, 1, 2, 1),
	('fada3eec-4304-4eb6-8f6e-7960c663a24a', 'd1041d15-364e-4898-9a35-3d60e8002f85', 1, 1, 1, 3, 1),
	('50e10142-ddc6-4b83-a271-6868b1d22ef0', '06549b72-8a27-4e4e-8e0e-476a56362b93', 1, 1, 1, 3, 1),
	('8176ab38-28f0-4311-add0-293f875acf8e', '6f838be9-6e95-4a4b-8b56-8197e3eb3f97', 1, 3, 1, 2, 2),
	('488366c4-763c-40d6-b811-8364170050fb', 'b07175a2-a1ca-428d-a085-37fee5a6d098', 1, 3, 1, 2, 2),
	('bc971844-b1f5-40fb-b031-20c2832e82a1', '76ce4bac-644a-4abd-adb8-c1c8e330c6fa', NULL, 3, NULL, 3, 3),
	('169dc08d-8ca9-4b1e-be9b-470dff162e5c', '2d334f07-e06d-4c20-9086-5631946fd19f', NULL, 3, NULL, 3, 3),
	('5cd8a081-c57e-4c7e-b78e-a6494f57217a', 'f9f541d9-c2d1-44f4-9d22-2880a46d1b78', NULL, 3, NULL, 3, 3),
	('22a2d14f-aeb1-4caf-b006-dcfef32798b1', 'aeb24dea-3777-4a18-82ce-9d7d1ffab595', NULL, 3, NULL, 3, 3),
	('7c97ca77-8724-4cc6-a67c-918c0c473a1a', '5c862086-8457-4014-916c-e1fc75dc52e5', NULL, 3, NULL, 3, 3),
	('638fed2c-154a-463e-8921-19f323bfaa04', '7c396d2d-3485-4455-af63-178bb3416ab9', NULL, 3, NULL, 3, 3),
	('fd7723e1-580d-422e-9329-bfdea33393e6', '5ec8d7e2-76b6-4227-87e5-00175b72e889', NULL, 3, NULL, 3, 3),
	('7126169b-76b9-43df-9452-851cde3dc045', '2a43ecb5-6cc9-400b-a5de-95a008fb3d1f', NULL, 3, NULL, 3, 3),
	('36233dc6-6a70-4ad3-9510-f369dd83eefe', '451eac75-37a5-45e6-a7f3-a6af4f43d600', NULL, 3, NULL, 3, 3),
	('c0194490-ca56-4198-9a00-ed2012168de7', '8eb0a5da-adf1-4513-939d-da19cf86fc26', 1, 3, 1, 1, 2),
	('fb3f7c31-9cc0-48d3-8794-4ae08055e7bc', '04e56b86-ffa3-4dff-aa8d-50375323269b', 1, 1, 1, 3, 2),
	('91eefaeb-e598-48e7-bab7-da6f0c6e2a1b', '07d2c257-bb12-459f-b418-92f3010ecff3', 1, 2, 3, 3, 1),
	('9b2bb42b-6fc8-497f-b82d-5fe8e7212567', 'acf43a60-bea2-4e4f-9986-ca83f17d8c37', 1, NULL, 1, 2, 1);


--
-- Data for Name: establishment_contact; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_contact (establishment_contact_id, establishment_id, website, telephone_number) VALUES
	('6656c6d9-22dd-4935-a6e4-cdd97286cad0', 'fafcee68-8981-4f97-928a-5c1f82f94e87', 'http://www.cas.coop', '111111'),
	('b9910658-2eb4-4f84-bf94-aa278b0788f2', 'c1620b5b-a8b7-48ec-a75b-837a17a981f6', 'www.smmacademy.org', '111111'),
	('75ba4e35-045f-4028-905e-5ca80b8aafc4', '06549b72-8a27-4e4e-8e0e-476a56362b93', 'http://www.ridgewoodschool.co.uk', '111111'),
	('6b4d4b37-3e26-4699-be55-6a46d023ee03', '6f838be9-6e95-4a4b-8b56-8197e3eb3f97', 'www.ewmeschools.org.uk', '111111'),
	('807056c6-47d4-48c5-9a27-f915c2afb9db', 'b07175a2-a1ca-428d-a085-37fee5a6d098', 'www.ewmeschools.org.uk', '111111'),
	('18dde922-dde7-4389-80dc-f9151971aa1c', '76ce4bac-644a-4abd-adb8-c1c8e330c6fa', NULL, '111111'),
	('2ceaa333-43d3-4cc3-9206-51413c78c722', '2d334f07-e06d-4c20-9086-5631946fd19f', NULL, '111111'),
	('cf7da44b-1078-4183-a207-59bc4251be70', 'f9f541d9-c2d1-44f4-9d22-2880a46d1b78', NULL, '111111'),
	('c84a2320-0dc6-485f-9ec7-5991e3148f1d', 'aeb24dea-3777-4a18-82ce-9d7d1ffab595', NULL, '111111'),
	('081bed28-69ca-43b0-bcce-46c0a3205369', '5c862086-8457-4014-916c-e1fc75dc52e5', NULL, '111111'),
	('af3a39a5-1d6a-47ea-bc7b-42e9f73fe5dd', '7c396d2d-3485-4455-af63-178bb3416ab9', NULL, '111111'),
	('fb66f915-ad35-4bee-81cb-99a80ab6470d', '5ec8d7e2-76b6-4227-87e5-00175b72e889', NULL, '111111'),
	('db0b5f70-d6fc-44fd-bb2d-780a18acb43f', '2a43ecb5-6cc9-400b-a5de-95a008fb3d1f', NULL, '111111'),
	('471f685c-0180-4255-a5ea-5ad2c76aa316', '451eac75-37a5-45e6-a7f3-a6af4f43d600', NULL, '111111'),
	('fe6048dd-ec71-422e-a586-9ab5cb875e2d', '8eb0a5da-adf1-4513-939d-da19cf86fc26', 'www.hadrianparkprimary.org.uk/', '111111'),
	('3bad3d71-c37a-4612-bfdc-bfa94349f1ba', '04e56b86-ffa3-4dff-aa8d-50375323269b', 'http://www.fulwoodacademy.co.uk/', '111111'),
	('3696e8f0-e865-41b9-91c4-db222821b45f', '07d2c257-bb12-459f-b418-92f3010ecff3', 'www.underleygarden.org', '111111'),
	('6b96b38c-cf41-4112-b236-df5bdf62e243', 'acf43a60-bea2-4e4f-9986-ca83f17d8c37', NULL, '111111');


--
-- Data for Name: establishment_geography; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_geography (establishment_geography_id, establishment_id, local_authority_id, government_office_region_id, district_administrative_id, administrative_ward_id, parliamentary_constituency_id, lsoa_id, msoa_id, urban_rural_id) VALUES
	('86e84b4f-65f6-4f0b-a4a4-afe059af3e75', 'fafcee68-8981-4f97-928a-5c1f82f94e87', '3332ea83-bcbe-48d1-970d-a3650d9bcf10', '7ca695f4-dfcd-4f78-bdaf-17861eafbf97', '6ef1f577-d0bc-4698-951c-f202f9eaada6', 'e73f0fc2-114a-4772-a84e-5363b02ba34b', '714fb4a2-4d2e-4875-9853-1d7d6696559e', 'cec78739-d3a7-4831-9934-8dec5c5bdcd1', '5ed6445f-c41a-4778-9a5c-55ba74a2155b', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('89af1d7c-3378-4699-985f-95eeafec45b4', 'c1620b5b-a8b7-48ec-a75b-837a17a981f6', '3574e75c-8870-449a-82e7-1b083e2efc42', '1375841f-e6ba-4cda-9fac-753ff9df93a2', '9a5cfcfa-3605-4253-8e1c-fc081510a4ea', '9a2f2163-03c6-45b8-84e0-b34cc7a3450c', '6c7acd08-ad7f-406e-85e4-0bade3e57de6', '05aa5060-26b4-4edf-ad40-5e4640903d5a', '0d87ce8f-019d-4403-9527-975bbabd10e1', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('238d6e2a-d0f9-481b-a985-07ad32707c9a', 'd1041d15-364e-4898-9a35-3d60e8002f85', '0a78f87e-d71b-44c3-b598-2cc2b8038e95', '489dce3e-58d7-44c5-b9ef-2f7d7cbdb592', 'c8efb411-9c6d-492e-af1e-624ed743712f', 'f22dfd05-c647-403a-bebd-69fb3a62cca6', '93b33a64-95d1-4d7f-9142-4acc73221e9a', '22d38930-6da2-4b70-9bca-6208cbb43ba5', 'cddc19f9-9b91-4e98-a4c8-656753fd673c', 'fba31373-6bf1-4ad2-9d63-a2c783849aad'),
	('dbcbc299-0af6-4e39-8810-141dde4f54cf', '06549b72-8a27-4e4e-8e0e-476a56362b93', '77b9cfe6-842e-41c8-9be4-410cac32719a', 'f5cdf1f1-5f75-4420-b597-862614e13549', '05471fcf-d815-4c82-a7f6-6a9ff75cdaa2', 'cf41c2bc-c0cc-4394-992e-1db6d9f032dd', '8d116d07-483e-41bc-83ea-00c89c3f3a6d', 'c4402a6f-a614-4961-a889-554ef686642a', '011465c5-0d85-498d-8b85-14ea8833c9d5', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('238e6e45-ce1d-401f-b539-d9afc0e8458b', '6f838be9-6e95-4a4b-8b56-8197e3eb3f97', '942f0927-84a7-43b6-8be9-68f88917b043', '32e46d74-0ebf-495b-8261-2c508cd2c2bb', '1146af1e-822e-49f1-a51e-da31f849045c', 'f08ea39d-20ae-4f5e-8274-15207e7b5eec', 'd180f323-3f6f-44dc-a1de-d1cac6e11c0c', '84494da7-5525-4dc5-a454-83a2b9b7bdc0', 'bc444798-7011-43c1-a1e2-269efd7885ef', '1c041cb3-373a-4dd5-9af4-2950293776bc'),
	('973f62cd-cdc1-4d6d-b2fc-a160476070b5', 'b07175a2-a1ca-428d-a085-37fee5a6d098', '942f0927-84a7-43b6-8be9-68f88917b043', '32e46d74-0ebf-495b-8261-2c508cd2c2bb', '1146af1e-822e-49f1-a51e-da31f849045c', 'f08ea39d-20ae-4f5e-8274-15207e7b5eec', 'd180f323-3f6f-44dc-a1de-d1cac6e11c0c', '534b5a89-c075-4962-8367-8c8ffc158b9e', 'edc1ad99-4391-4d91-8717-6c10929ae180', '1c041cb3-373a-4dd5-9af4-2950293776bc'),
	('1f6e57dc-d8aa-4f29-840e-825e121240a3', '76ce4bac-644a-4abd-adb8-c1c8e330c6fa', 'dc9f9e86-8d80-46b7-87bc-e998cafca819', '32e46d74-0ebf-495b-8261-2c508cd2c2bb', '38ab2b8e-4373-4176-8944-4c6d8cffa7d8', 'c21f6874-6733-4b9b-bc1a-b54fbb495ac9', 'c487eba0-9903-4df2-b999-20f1cca784fb', '84badc4c-a7f2-4af6-8532-8ebf665e5686', '0d9136b3-d6e1-4143-bc20-59738dffb35b', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('33c88d6c-7fbf-4630-8c5e-c7d846775ed6', '2d334f07-e06d-4c20-9086-5631946fd19f', 'dc9f9e86-8d80-46b7-87bc-e998cafca819', '32e46d74-0ebf-495b-8261-2c508cd2c2bb', '38ab2b8e-4373-4176-8944-4c6d8cffa7d8', '0af643ac-6840-48a4-8ed7-dc98ad8626a9', '485e8a03-6bd3-4c3b-95d6-baf2f9b44cad', 'd7b13e80-761e-4cb2-b40f-0dfb91095689', '6c891a27-897f-41ec-ac35-7e207d4fead3', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('5087658e-f2a1-4208-97fb-aa4c61e0c210', 'f9f541d9-c2d1-44f4-9d22-2880a46d1b78', 'dc9f9e86-8d80-46b7-87bc-e998cafca819', '32e46d74-0ebf-495b-8261-2c508cd2c2bb', '38ab2b8e-4373-4176-8944-4c6d8cffa7d8', '28286c17-e7ea-4022-b909-1a6b60808185', '485e8a03-6bd3-4c3b-95d6-baf2f9b44cad', '56a40580-3dbd-4d1f-bdaa-54370f39b26d', 'd40b3466-6329-406a-93f7-a4978722af70', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('9f3be588-ac01-415e-ac33-eccea9f5391d', 'aeb24dea-3777-4a18-82ce-9d7d1ffab595', 'dc9f9e86-8d80-46b7-87bc-e998cafca819', '32e46d74-0ebf-495b-8261-2c508cd2c2bb', '38ab2b8e-4373-4176-8944-4c6d8cffa7d8', 'bdd0a9a0-8af5-4232-b7ce-30a76be572ca', '485e8a03-6bd3-4c3b-95d6-baf2f9b44cad', 'e8b85e8f-e837-4dd2-9ac3-b3f22e6f83a6', '5a9caa00-1c9c-49c6-ba30-dd3df2b2599f', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('c1658058-6df3-475a-9d4e-f8e8f244ddc5', '5c862086-8457-4014-916c-e1fc75dc52e5', 'dc9f9e86-8d80-46b7-87bc-e998cafca819', '32e46d74-0ebf-495b-8261-2c508cd2c2bb', '38ab2b8e-4373-4176-8944-4c6d8cffa7d8', '1bcfab2c-6971-4998-9c38-55c1e039be68', 'c487eba0-9903-4df2-b999-20f1cca784fb', '52692e65-37ae-4851-9b83-d318448b8a15', '35b2356d-cad3-415a-af7d-dc32bd148ae2', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('1b39a81c-0b7b-48e2-ac68-27749b65b65f', '7c396d2d-3485-4455-af63-178bb3416ab9', 'dc9f9e86-8d80-46b7-87bc-e998cafca819', '32e46d74-0ebf-495b-8261-2c508cd2c2bb', '38ab2b8e-4373-4176-8944-4c6d8cffa7d8', 'b40c3129-d1f9-4ee7-9b6f-a4ed111c7109', '485e8a03-6bd3-4c3b-95d6-baf2f9b44cad', '1e9505f2-4f09-47be-82fe-648e59412d31', 'c5197681-247e-481b-b496-b4503db81187', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('0993103b-87cb-485e-9a5c-58f172c9b499', '5ec8d7e2-76b6-4227-87e5-00175b72e889', 'dc9f9e86-8d80-46b7-87bc-e998cafca819', '32e46d74-0ebf-495b-8261-2c508cd2c2bb', '38ab2b8e-4373-4176-8944-4c6d8cffa7d8', '9fdf9c47-28c6-4d2f-ba6f-906b588206c3', '485e8a03-6bd3-4c3b-95d6-baf2f9b44cad', 'e8a5b83c-e982-454d-a84a-3bb3b76806f3', '5577ba9a-318d-4440-8baa-7abf3925e7f0', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('86cbb61b-8f45-482e-8061-69a67ba0ff0a', '2a43ecb5-6cc9-400b-a5de-95a008fb3d1f', 'dc9f9e86-8d80-46b7-87bc-e998cafca819', '32e46d74-0ebf-495b-8261-2c508cd2c2bb', '38ab2b8e-4373-4176-8944-4c6d8cffa7d8', '1bcfab2c-6971-4998-9c38-55c1e039be68', 'c487eba0-9903-4df2-b999-20f1cca784fb', '34a90645-b540-4351-8d4b-356bec2a4c76', '35b2356d-cad3-415a-af7d-dc32bd148ae2', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('e3814cf8-b4af-45f2-a5da-9123d275f7d3', '451eac75-37a5-45e6-a7f3-a6af4f43d600', 'dc9f9e86-8d80-46b7-87bc-e998cafca819', '32e46d74-0ebf-495b-8261-2c508cd2c2bb', '38ab2b8e-4373-4176-8944-4c6d8cffa7d8', 'e8e39ac5-cd31-4312-8f42-063aed530c47', 'c487eba0-9903-4df2-b999-20f1cca784fb', 'e43873e2-e36a-4f91-876b-b62ee15b6a55', '15cd7b16-0306-42b8-8208-9cca5b9deda3', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('d01f2892-016a-435e-96e3-3a266ac3346f', '8eb0a5da-adf1-4513-939d-da19cf86fc26', 'cf117bdb-0226-42f0-9f40-e11aa3369b61', '6cc3324b-91cb-4ea6-a0db-2cd327ce7941', '7272229e-d4b1-419e-849b-531e45200032', 'ec46bd78-eaea-4593-b5de-9d07bb169875', '68489e77-9d60-498a-840c-712d1fb7ae01', 'bb066056-57d6-44aa-ae8f-b9ecc2d16c15', '07789943-52cc-4a00-a811-7656fbdc20f4', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('6a949cde-697f-43ad-86c1-6db330f4b823', '04e56b86-ffa3-4dff-aa8d-50375323269b', 'a4572037-9765-42e9-890c-0a4c47a49abd', '489dce3e-58d7-44c5-b9ef-2f7d7cbdb592', '50c00d93-da6b-4df1-87ad-ebe1b4af26d0', 'a92333cd-38a8-4b10-9822-3d66ade87507', 'd0b01b14-129d-452c-aba9-32a10da493ab', '87cd11b8-7e94-47cd-9996-0ecc21f1ca54', '7dd76107-3e1d-40a1-b89b-e801475b55b9', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('fc16001c-168f-4663-8ca0-56678f50bdd1', '07d2c257-bb12-459f-b418-92f3010ecff3', 'c3481033-0753-4614-b00b-677ccc85d1ee', '489dce3e-58d7-44c5-b9ef-2f7d7cbdb592', '3f0b99bb-4666-463d-b373-6f096c6c032c', '1e6798c9-c8d2-4cec-acfa-c60a17acc802', 'ce572531-777d-4112-b07a-99c827d21bb7', '48507344-3f4b-475c-9b60-b913b01b5d27', '0254b351-1c59-4e0e-822d-b99b185b22f4', 'f755a09b-bf99-4ac1-a3cc-266ad9a9c32b'),
	('b30aee68-9ddd-44e5-96e0-a5b93b50c7f6', 'acf43a60-bea2-4e4f-9986-ca83f17d8c37', '893121c9-05e6-4e35-bfef-ea76e40c012e', 'f85647db-e5d1-41a6-befb-bfbf6420f5c4', '17fc3b24-6e02-44e2-8efc-2c47da891a27', '530f3047-08df-4892-b9ab-16df2a2a39be', '530f1da7-9067-43a1-b515-e93f9199b65e', 'cda69748-98b0-4ee6-a025-27833304c743', '7100b4af-5ca3-4746-a8ef-4c5f46714353', '1c041cb3-373a-4dd5-9af4-2950293776bc');


--
-- Data for Name: establishment_lifecycle; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_lifecycle (establishment_lifecycle_id, establishment_id, establishment_status_id, open_date, close_date, reason_establishment_opened_id, reason_establishment_closed_id, last_changed_date) VALUES
	('dee56d77-8330-4ccf-add9-b6f7cae7a8be', 'fafcee68-8981-4f97-928a-5c1f82f94e87', 1, '2010-09-01', NULL, 2, NULL, '2026-06-23'),
	('e7a59c71-c54c-4b9e-9aa5-5c7581e52643', 'c1620b5b-a8b7-48ec-a75b-837a17a981f6', 1, '2007-09-01', NULL, 2, NULL, '2026-06-23'),
	('e2c3af7b-2514-49c1-b497-1376ab55af3a', 'd1041d15-364e-4898-9a35-3d60e8002f85', 2, '2009-09-01', '2016-02-29', 2, 12, '2018-07-02'),
	('aef000c3-9c84-4f53-9a76-ecf0ce7540b1', '06549b72-8a27-4e4e-8e0e-476a56362b93', 1, '2011-11-01', NULL, 1, NULL, '2026-06-23'),
	('da86440c-5998-46c4-afe8-2db3709398bf', '6f838be9-6e95-4a4b-8b56-8197e3eb3f97', 1, NULL, NULL, NULL, NULL, '2026-06-23'),
	('a53ac146-05d6-42ec-ad84-530ec85cd9ee', 'b07175a2-a1ca-428d-a085-37fee5a6d098', 1, NULL, NULL, NULL, NULL, '2026-06-23'),
	('43ebff26-a427-4809-b66a-f218330b1147', '76ce4bac-644a-4abd-adb8-c1c8e330c6fa', 1, '2008-02-07', NULL, NULL, NULL, '2025-06-20'),
	('d694c7f6-f738-4311-bfe9-7fc223535365', '2d334f07-e06d-4c20-9086-5631946fd19f', 1, '2006-03-14', NULL, NULL, NULL, '2025-06-20'),
	('8cb74c26-d46e-46e5-a262-59e9e1719cf9', 'f9f541d9-c2d1-44f4-9d22-2880a46d1b78', 1, '2008-03-03', NULL, NULL, NULL, '2025-06-20'),
	('322230c5-0ff2-411c-b716-4d2f2406a62a', 'aeb24dea-3777-4a18-82ce-9d7d1ffab595', 1, '2009-12-14', NULL, NULL, NULL, '2025-06-20'),
	('b6bf8965-f16e-4c90-aa1a-3cab773d7d39', '5c862086-8457-4014-916c-e1fc75dc52e5', 1, '2009-12-14', NULL, NULL, NULL, '2025-06-20'),
	('f7acc714-43ba-4628-abf7-4f3e68cf9592', '7c396d2d-3485-4455-af63-178bb3416ab9', 1, '2008-01-16', NULL, NULL, NULL, '2025-06-20'),
	('f1bdcd9c-e732-41c3-875a-d928ef623226', '5ec8d7e2-76b6-4227-87e5-00175b72e889', 1, '2008-01-16', NULL, NULL, NULL, '2025-06-20'),
	('8e9fb662-4b03-4371-bae8-cb6e65368f6a', '2a43ecb5-6cc9-400b-a5de-95a008fb3d1f', 1, '2008-02-07', NULL, NULL, NULL, '2025-06-20'),
	('72e9d7a3-8cb2-4818-8858-5faf0ff415d8', '451eac75-37a5-45e6-a7f3-a6af4f43d600', 1, '2006-09-28', NULL, NULL, NULL, '2025-06-20'),
	('7d1188b7-04e8-47d7-a1c8-ee1461cb2040', '8eb0a5da-adf1-4513-939d-da19cf86fc26', 1, '2001-09-01', NULL, 6, NULL, '2025-06-20'),
	('eaf0ad29-2c18-4452-aea5-794082d9b4d4', '04e56b86-ffa3-4dff-aa8d-50375323269b', 1, '2009-09-01', NULL, 2, NULL, '2026-06-23'),
	('19a8af54-702d-466a-b006-aecfc4f32a09', '07d2c257-bb12-459f-b418-92f3010ecff3', 1, '1990-03-28', NULL, NULL, NULL, '2026-07-20'),
	('3b35c57c-dce6-43a1-b118-96d6385b2726', 'acf43a60-bea2-4e4f-9986-ca83f17d8c37', 1, '1988-12-12', NULL, NULL, NULL, '2026-07-20');


--
-- Data for Name: person; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.person (person_id) VALUES
	('1af49f62-5f3e-419d-8f6b-51189a6e8515');


--
-- Data for Name: establishment_party_role; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_party_role (establishment_party_role_id, establishment_party_role_type_id, legal_entity_id, person_id, start_date, end_date) VALUES
	('47b1c284-e194-4860-be2a-5edcd2b97378', 1, '6c6334c4-3ae9-4cbd-87e8-03bc47f3458f', NULL, NULL, NULL),
	('31b01e1c-0e81-4700-bc07-d283ea55f57b', 1, 'b8a3c074-9870-4b43-b3e1-3ba90017f1a2', NULL, NULL, NULL),
	('83ba124e-cebd-43dd-8d15-6fa978dce414', 4, '5355748e-57d2-460c-a10f-6cd9c01d188e', NULL, NULL, NULL),
	('cde2c1df-2e9d-45c5-80e5-76e088687325', 1, '9c5c38c8-c175-4313-9e0b-96d909bd10c7', NULL, NULL, NULL),
	('79c093ac-2395-4575-bbaf-c330cfb2321c', 4, '55f19c2d-eab1-4a54-a154-4c5d7752f2cb', NULL, NULL, NULL),
	('6951b746-42ff-4ce0-99f0-00b62a043400', 1, 'd261dcca-92e3-46a0-a927-c871901d84cd', NULL, NULL, '2016-02-29'),
	('35bbd698-da03-4404-967a-3beace540afe', 1, '4f28bece-75ed-4e30-a04e-f963e3e13ce9', NULL, NULL, NULL),
	('530d5251-739b-4b7d-b5d0-8d6ea8d72b41', 2, '560bdb6e-dd12-4b6a-bd25-2a1b7acf8209', NULL, NULL, NULL),
	('86096d21-1611-42fc-8ef9-6c98e4de894e', 4, NULL, '1af49f62-5f3e-419d-8f6b-51189a6e8515', NULL, NULL),
	('436e1160-f46f-4598-9ea1-95d51299e0ee', 1, 'd63c950d-8f31-4540-8933-415fd3e0ddfe', NULL, NULL, NULL);


--
-- Data for Name: establishment_responsibility; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_responsibility (establishment_responsibility_id, establishment_id, legal_entity_id, person_id, responsibility_type_id, academy_trust_type_id, start_date, end_date, is_current) VALUES
	('1c991917-4026-4c1b-84b1-477930097f5d', 'fafcee68-8981-4f97-928a-5c1f82f94e87', '6c6334c4-3ae9-4cbd-87e8-03bc47f3458f', NULL, 1, 2, '2015-07-01', NULL, true),
	('6512a851-c19f-46a1-ac1c-5c771a8de817', 'fafcee68-8981-4f97-928a-5c1f82f94e87', 'b8a3c074-9870-4b43-b3e1-3ba90017f1a2', NULL, 1, 1, '2010-09-01', NULL, false),
	('4a0465b7-2b13-4b00-81e1-098430dda624', 'fafcee68-8981-4f97-928a-5c1f82f94e87', '5355748e-57d2-460c-a10f-6cd9c01d188e', NULL, 3, NULL, '2010-09-01', NULL, true),
	('2a4843bf-2164-4afa-942a-c0f0bf8bcaaf', 'c1620b5b-a8b7-48ec-a75b-837a17a981f6', '9c5c38c8-c175-4313-9e0b-96d909bd10c7', NULL, 1, 2, '2021-10-04', NULL, true),
	('d8f4a4df-64ca-410f-90e0-b7f34f3e0b23', 'c1620b5b-a8b7-48ec-a75b-837a17a981f6', '9c5c38c8-c175-4313-9e0b-96d909bd10c7', NULL, 1, 1, '2007-09-01', NULL, false),
	('bb36455a-bedb-4ac4-ac14-7f4681178aea', 'c1620b5b-a8b7-48ec-a75b-837a17a981f6', '55f19c2d-eab1-4a54-a154-4c5d7752f2cb', NULL, 3, NULL, '2007-09-01', NULL, true),
	('f2b8fc67-addd-4a55-8a30-119f0108fae4', 'd1041d15-364e-4898-9a35-3d60e8002f85', 'd261dcca-92e3-46a0-a927-c871901d84cd', NULL, 1, 2, '2009-09-01', '2016-02-29', false),
	('0409cd84-38c3-4da1-8604-d5e5affba433', '06549b72-8a27-4e4e-8e0e-476a56362b93', '4f28bece-75ed-4e30-a04e-f963e3e13ce9', NULL, 1, 1, '2011-11-01', NULL, false),
	('c5b72834-ddee-49d9-9bec-b7f062659c68', '06549b72-8a27-4e4e-8e0e-476a56362b93', '4f28bece-75ed-4e30-a04e-f963e3e13ce9', NULL, 1, 2, '2021-03-30', NULL, true),
	('e1bb39c9-9fcd-4746-a16d-5b202b69d6b4', '8eb0a5da-adf1-4513-939d-da19cf86fc26', '560bdb6e-dd12-4b6a-bd25-2a1b7acf8209', NULL, 2, NULL, '2011-09-01', NULL, true),
	('c637d49d-85b0-4cb7-96f5-ee9378fc53dd', '04e56b86-ffa3-4dff-aa8d-50375323269b', NULL, '1af49f62-5f3e-419d-8f6b-51189a6e8515', 3, NULL, '2009-09-01', NULL, true),
	('0c73b959-8a5f-4783-9f49-4497e860f85d', '04e56b86-ffa3-4dff-aa8d-50375323269b', 'd63c950d-8f31-4540-8933-415fd3e0ddfe', NULL, 1, 2, '2009-09-01', NULL, true),
	('e0e23d24-5fe8-4330-a181-373c9e7ed21f', '07d2c257-bb12-459f-b418-92f3010ecff3', '5be037f1-12fc-4b40-829c-4135c96fc783', NULL, 4, NULL, NULL, NULL, true),
	('00d4e6df-99b0-4c61-b2f3-c04b96d35268', 'acf43a60-bea2-4e4f-9986-ca83f17d8c37', '5be037f1-12fc-4b40-829c-4135c96fc783', NULL, 4, NULL, NULL, NULL, true);


--
-- Data for Name: site; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.site (site_id, address_id, site_name, uprn) VALUES
	('1542d48e-da47-4a8d-aabb-069ab5219df4', 'f7935d14-72da-4201-84ae-586148bf9d04', NULL, 3455015782),
	('e8d0d603-a8a4-4313-930c-95738f0c6e5b', '4c117266-f803-4e60-a82f-1ccfb137d54a', NULL, 5300060053),
	('a0019d98-613c-467b-8950-2108f06363df', 'e3cedd96-0c12-43f7-95cc-77b135880eba', NULL, 10090666596),
	('3f3f9e79-e7fd-4d48-851b-438597773669', '72f88564-cec8-4d81-8b13-93a11a644e48', NULL, 10006581609),
	('b705d7cf-0649-4467-84ea-1a8174cc7718', '5bdc830e-e644-47e1-b3bb-60b6e4e35a05', NULL, 100081218005),
	('7049799f-b2c5-4124-9100-ad284df1535a', 'bc5185cf-f37a-4d3c-b4e5-c5237e64cee5', NULL, 100081212588),
	('96f7e0f5-1f5c-4649-91dc-bfd94859a467', '58f583c0-1780-4e52-81d3-e6b517d679a4', NULL, 100091605340),
	('954a6c08-9265-4446-a2a1-ae2dd53c01ef', '1460a89e-3815-41fc-bb91-4a3b735adb3c', NULL, NULL),
	('58e8d340-8932-4056-bba0-419df162ef47', 'e85c3f67-4aac-4469-b819-94e760637d41', NULL, 10024158444),
	('10a22531-8091-4239-888f-4858ad86d8fe', 'd81ea02f-563d-4025-9a15-63c936c0ca61', NULL, 100091593148),
	('7ca8d50d-02db-43f0-bbc5-aa8e25c1bc43', 'b13ffafd-55d8-41ba-967c-cfa29f968674', NULL, 10012151948),
	('38c77668-1228-4dd7-b393-b55f324db539', 'dca75547-8ada-4832-b1be-d008dbe452a5', NULL, 100091595925),
	('23274028-b382-46e5-a070-e4f9c4cd5c35', 'b5a61d64-daa5-4180-9040-25c649b795c3', NULL, 10012152076),
	('0ad212e4-2098-4788-9415-72f253011fdf', '04155ac8-afe6-4201-8416-9bb912e8ffe5', NULL, 100091656436),
	('4393075d-9cde-42f4-8ef9-4f04328bce8c', '4b9d8479-a5da-490f-926f-c4aa07c75db9', NULL, 200001258935),
	('21c24d83-dc58-45a3-a21d-246921f2f97a', 'd8fc9c5f-3d29-4d70-836d-0889be1cdd02', NULL, 47000575),
	('40d8ac34-bf86-4804-ba55-55e6d024f007', '7e3e18d9-b095-4cf5-96ec-a5112d12aeff', NULL, 100012750549),
	('a855db4c-1b82-49fc-9485-b86dcbe6bbcc', 'cadae19e-1740-4a75-8bc3-0222ff85b298', NULL, NULL),
	('843a74ce-e188-44f8-bef0-311ff033326f', '074f8293-73f6-490a-8828-39a87016f6e7', NULL, 200004392318);


--
-- Data for Name: establishment_to_site; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_to_site (establishment_id, site_id, is_main_site) VALUES
	('fafcee68-8981-4f97-928a-5c1f82f94e87', '1542d48e-da47-4a8d-aabb-069ab5219df4', true),
	('c1620b5b-a8b7-48ec-a75b-837a17a981f6', 'e8d0d603-a8a4-4313-930c-95738f0c6e5b', true),
	('d1041d15-364e-4898-9a35-3d60e8002f85', 'a0019d98-613c-467b-8950-2108f06363df', true),
	('06549b72-8a27-4e4e-8e0e-476a56362b93', '3f3f9e79-e7fd-4d48-851b-438597773669', true),
	('6f838be9-6e95-4a4b-8b56-8197e3eb3f97', 'b705d7cf-0649-4467-84ea-1a8174cc7718', true),
	('b07175a2-a1ca-428d-a085-37fee5a6d098', '7049799f-b2c5-4124-9100-ad284df1535a', true),
	('76ce4bac-644a-4abd-adb8-c1c8e330c6fa', '96f7e0f5-1f5c-4649-91dc-bfd94859a467', true),
	('2d334f07-e06d-4c20-9086-5631946fd19f', '954a6c08-9265-4446-a2a1-ae2dd53c01ef', true),
	('f9f541d9-c2d1-44f4-9d22-2880a46d1b78', '58e8d340-8932-4056-bba0-419df162ef47', true),
	('aeb24dea-3777-4a18-82ce-9d7d1ffab595', '10a22531-8091-4239-888f-4858ad86d8fe', true),
	('5c862086-8457-4014-916c-e1fc75dc52e5', '7ca8d50d-02db-43f0-bbc5-aa8e25c1bc43', true),
	('7c396d2d-3485-4455-af63-178bb3416ab9', '38c77668-1228-4dd7-b393-b55f324db539', true),
	('5ec8d7e2-76b6-4227-87e5-00175b72e889', '23274028-b382-46e5-a070-e4f9c4cd5c35', true),
	('2a43ecb5-6cc9-400b-a5de-95a008fb3d1f', '0ad212e4-2098-4788-9415-72f253011fdf', true),
	('451eac75-37a5-45e6-a7f3-a6af4f43d600', '4393075d-9cde-42f4-8ef9-4f04328bce8c', true),
	('8eb0a5da-adf1-4513-939d-da19cf86fc26', '21c24d83-dc58-45a3-a21d-246921f2f97a', true),
	('04e56b86-ffa3-4dff-aa8d-50375323269b', '40d8ac34-bf86-4804-ba55-55e6d024f007', true),
	('07d2c257-bb12-459f-b418-92f3010ecff3', 'a855db4c-1b82-49fc-9485-b86dcbe6bbcc', true),
	('acf43a60-bea2-4e4f-9986-ca83f17d8c37', '843a74ce-e188-44f8-bef0-311ff033326f', true);


--
-- Data for Name: organisation_group; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.organisation_group (organisation_group_id, name, organisation_group_type_id, local_authority_id, open_date, close_date) VALUES
	('477d00e2-25de-4d36-ad5a-2f8bab8d7ba4', 'Federation of Eileen Wade and Milton Ernest VC lower schools', 1, NULL, '2011-01-13', NULL),
	('01c8bc59-6ad1-45bb-93d2-d08ce48d7620', 'Southend Children''s Centres', 2, 'dc9f9e86-8d80-46b7-87bc-e998cafca819', '2016-10-01', NULL);


--
-- Data for Name: group_identifier; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.group_identifier (group_identifier_id, establishment_party_role_id, organisation_group_id, group_identifier_type_id, group_identifier_issuer_id, value, is_current) VALUES
	('a4adf118-90e2-4da9-9a69-5408e72b8131', '47b1c284-e194-4860-be2a-5edcd2b97378', NULL, 1, 1, '2777', true),
	('4022a3e4-695c-4cfe-9759-c40a38c7c6e3', '47b1c284-e194-4860-be2a-5edcd2b97378', NULL, 2, 1, 'TR00567', true),
	('e2fda667-a445-4de9-b822-04f056f541e7', '31b01e1c-0e81-4700-bc07-d283ea55f57b', NULL, 1, 1, '2779', false),
	('55eb5d4d-ebf6-4fcf-bb21-83c9343d09fc', '31b01e1c-0e81-4700-bc07-d283ea55f57b', NULL, 2, 1, 'TR00569', false),
	('7e40f7f9-c3bd-4232-af04-56918b80b84b', '83ba124e-cebd-43dd-8d15-6fa978dce414', NULL, 1, 1, '4949', true),
	('c5783710-6ffd-4c27-a6a2-5641fcc03dbe', '83ba124e-cebd-43dd-8d15-6fa978dce414', NULL, 2, 1, 'SP00125', true),
	('f649d390-7be2-4617-a363-e5e140ca933a', 'cde2c1df-2e9d-45c5-80e5-76e088687325', NULL, 1, 1, '23869', true),
	('5420e8cd-3ffc-4a19-9951-131c3d789627', 'cde2c1df-2e9d-45c5-80e5-76e088687325', NULL, 2, 1, 'TR02103', true),
	('6d1308cb-14c4-4b10-807d-4b4fa3b81bd6', 'cde2c1df-2e9d-45c5-80e5-76e088687325', NULL, 1, 1, '4737', false),
	('5564bd2f-0e58-4468-9fad-08d6ec74ccb1', '79c093ac-2395-4575-bbaf-c330cfb2321c', NULL, 1, 1, '2914', true),
	('c2bcf625-67bd-4f5a-ac7a-9ad29f29b3f0', '79c093ac-2395-4575-bbaf-c330cfb2321c', NULL, 2, 1, 'SP00172', true),
	('a176b8d2-69c9-4bc2-985a-cc744f5c8aa0', '6951b746-42ff-4ce0-99f0-00b62a043400', NULL, 1, 1, '3839', false),
	('c1a6e43e-5259-4cf9-9a7f-8840edbf39ea', '6951b746-42ff-4ce0-99f0-00b62a043400', NULL, 2, 1, 'TR01385', false),
	('e105377d-682d-4a34-9c5d-2a62c7f883fd', '35bbd698-da03-4404-967a-3beace540afe', NULL, 1, 1, '2055', false),
	('a0f36577-b9d3-4440-a3d6-e39619093cfe', '35bbd698-da03-4404-967a-3beace540afe', NULL, 1, 1, '20364', true),
	('8569a830-4fc6-4939-8abf-e3377d90d611', '35bbd698-da03-4404-967a-3beace540afe', NULL, 2, 1, 'TR00009', true),
	('f30e648e-68a2-4524-b8b8-989ba0d2dc84', '530d5251-739b-4b7d-b5d0-8d6ea8d72b41', NULL, 1, 1, '1337', true),
	('ae36a007-9a06-49c4-9b5c-3ddc89ca4b31', '86096d21-1611-42fc-8ef9-6c98e4de894e', NULL, 1, 1, '2613', true),
	('c421deb9-40e0-49ac-940c-f1b68b92b4a8', '86096d21-1611-42fc-8ef9-6c98e4de894e', NULL, 2, 1, 'SP00099', true),
	('8d8703e1-8ab5-4920-b265-1dbc6db7f686', '436e1160-f46f-4598-9ea1-95d51299e0ee', NULL, 1, 1, '3147', true),
	('9fc40039-9630-46cd-9ad3-516f76ba4770', '436e1160-f46f-4598-9ea1-95d51299e0ee', NULL, 2, 1, 'TR00830', true),
	('4f47ab49-52ed-4630-94e3-3eb878bf8704', NULL, '477d00e2-25de-4d36-ad5a-2f8bab8d7ba4', 1, 1, '1809', true),
	('6a053a0a-dc3b-4516-bd09-6de124c81384', NULL, '01c8bc59-6ad1-45bb-93d2-d08ce48d7620', 1, 1, '86052', true);


--
-- Data for Name: organisation_group_member; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.organisation_group_member (organisation_group_member_id, organisation_group_id, establishment_id, joined_date, left_date, is_lead_member) VALUES
	('7d3b281d-f779-4209-b164-2b444fc47c9a', '477d00e2-25de-4d36-ad5a-2f8bab8d7ba4', '6f838be9-6e95-4a4b-8b56-8197e3eb3f97', '2011-01-13', NULL, NULL),
	('15f7e109-803d-41fb-a27a-a9370fada8a3', '477d00e2-25de-4d36-ad5a-2f8bab8d7ba4', 'b07175a2-a1ca-428d-a085-37fee5a6d098', '2011-01-13', NULL, NULL),
	('30a2ea2c-49b7-4bb8-914e-c41ae7d25d7a', '01c8bc59-6ad1-45bb-93d2-d08ce48d7620', '5c862086-8457-4014-916c-e1fc75dc52e5', '2016-10-01', NULL, false),
	('fec328f9-a520-4f9e-adc9-822dfef79f10', '01c8bc59-6ad1-45bb-93d2-d08ce48d7620', '2a43ecb5-6cc9-400b-a5de-95a008fb3d1f', '2016-10-01', NULL, false),
	('73be2939-76e1-490e-b17c-2f39099d8e39', '01c8bc59-6ad1-45bb-93d2-d08ce48d7620', '451eac75-37a5-45e6-a7f3-a6af4f43d600', '2016-10-01', NULL, false),
	('cbd0c510-8c9d-4a25-a199-88192863d283', '01c8bc59-6ad1-45bb-93d2-d08ce48d7620', 'f9f541d9-c2d1-44f4-9d22-2880a46d1b78', '2016-10-01', NULL, false),
	('3d8518d3-8d60-43a4-87f0-470c003fb743', '01c8bc59-6ad1-45bb-93d2-d08ce48d7620', '2d334f07-e06d-4c20-9086-5631946fd19f', '2016-10-01', NULL, true),
	('55dc60d7-3879-4a66-844a-1225b3fde4d6', '01c8bc59-6ad1-45bb-93d2-d08ce48d7620', '76ce4bac-644a-4abd-adb8-c1c8e330c6fa', '2016-10-01', NULL, false),
	('7e2d84f2-f2d9-4209-8ef1-c02171df8eee', '01c8bc59-6ad1-45bb-93d2-d08ce48d7620', 'aeb24dea-3777-4a18-82ce-9d7d1ffab595', '2016-10-01', NULL, false),
	('b99f095c-5e50-4043-9f66-aa1672624cb7', '01c8bc59-6ad1-45bb-93d2-d08ce48d7620', '7c396d2d-3485-4455-af63-178bb3416ab9', '2016-10-01', NULL, false),
	('91d780d6-ae99-44b4-b227-c6ede84636c5', '01c8bc59-6ad1-45bb-93d2-d08ce48d7620', '5ec8d7e2-76b6-4227-87e5-00175b72e889', '2016-10-01', NULL, false);


--
-- Data for Name: organisation_identifier; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.organisation_identifier (organisation_identifier_id, legal_entity_id, organisation_identifier_type_id, value, is_current) VALUES
	('49d53214-55fb-4f5f-b9f1-1ccb750fad44', '6c6334c4-3ae9-4cbd-87e8-03bc47f3458f', 1, '07747126', true),
	('4345caa4-59b8-4d96-a010-75546a362cb0', '6c6334c4-3ae9-4cbd-87e8-03bc47f3458f', 2, '10059286', true),
	('d04e1a62-c864-4320-95d3-1586b56efb49', 'b8a3c074-9870-4b43-b3e1-3ba90017f1a2', 1, '07158839', true),
	('9b1cd7d6-b06d-47ef-8fc3-59d6607b3578', 'b8a3c074-9870-4b43-b3e1-3ba90017f1a2', 2, '10061289', true),
	('a1af95a6-9579-4b95-9bd0-3e68d9b9de16', '9c5c38c8-c175-4313-9e0b-96d909bd10c7', 1, '05412502', true),
	('8d70e4ce-60c2-4703-8662-b723aa9ff282', '9c5c38c8-c175-4313-9e0b-96d909bd10c7', 2, '10058191', true),
	('cc62cf8e-c78a-44db-9bc4-ca10cadbfff0', 'd261dcca-92e3-46a0-a927-c871901d84cd', 1, '06888873', true),
	('179db9a4-253c-4a1d-a50b-484b4cf97465', '4f28bece-75ed-4e30-a04e-f963e3e13ce9', 1, '07795736', true),
	('1e34f465-c3c5-4a5f-8f89-d956f30a9d60', '4f28bece-75ed-4e30-a04e-f963e3e13ce9', 2, '10059335', true),
	('64112dc5-96fb-4272-ad11-f557c25cbf4d', 'd63c950d-8f31-4540-8933-415fd3e0ddfe', 1, '06960253', true),
	('e3837c45-248e-4e2d-8a78-74ec26cacfd9', 'd63c950d-8f31-4540-8933-415fd3e0ddfe', 2, '10058269', true);


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
	('f8937a6c-5169-4410-bd2c-c8e3b032f3a1', '18907f4b-19a1-41f8-9273-2d20d5a1bb9d', 11, 16),
	('a8ed0d32-4b24-426a-88d6-cdef5522b9c3', '10c2071b-6aaf-4be4-8309-c8aebc113370', 4, 19),
	('78be887b-2012-4520-a5d1-425ef5c38b88', 'fada3eec-4304-4eb6-8f6e-7960c663a24a', 11, 19),
	('f7f0b3c9-7895-4dc8-aa2d-33867189e05f', '50e10142-ddc6-4b83-a271-6868b1d22ef0', 11, 19),
	('011572db-a483-473a-b7fa-84726f64db53', '8176ab38-28f0-4311-add0-293f875acf8e', 5, 11),
	('ecc5f56b-8675-4abe-820b-cce2fab1f39c', '488366c4-763c-40d6-b811-8364170050fb', 4, 11),
	('9041d073-95c5-468e-940d-682024552f43', 'c0194490-ca56-4198-9a00-ed2012168de7', 3, 11),
	('3afd2f7b-e54f-4424-968c-33625d45f828', 'fb3f7c31-9cc0-48d3-8794-4ae08055e7bc', 11, 16),
	('1ef42277-c38e-4375-bd64-bece67dbbd20', '91eefaeb-e598-48e7-bab7-da6f0c6e2a1b', 5, 19),
	('91875e5d-a60f-482e-b2e8-fa65ab185909', '9b2bb42b-6fc8-497f-b82d-5fe8e7212567', 5, 18);


--
-- PostgreSQL database dump complete
--

\unrestrict e93lnUNAKdAdBH0TCxP2NrCyKfjd74NPFLjPmqY5wjSxAG57bfd9amwhU2lwY3X

