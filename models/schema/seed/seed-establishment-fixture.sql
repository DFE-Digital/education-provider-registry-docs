--
-- PostgreSQL database dump
--

\restrict bn0BVmdx2aOu1RkgTqzuyxgek7fQNZtiPW1J7wf3HC41CGjUqiVbLLTLf8Acwbo

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
	('244c9b11-50ca-415d-87a2-f4b91eb37e53', 'THE CO-OPERATIVE ACADEMIES TRUST', 1, NULL, '2011-08-19', NULL),
	('b723a2f1-a5bf-48b0-9e89-ec7527a998fa', 'THE CO-OPERATIVE ACADEMY OF STOKE ON TRENT', 1, NULL, '2010-02-16', NULL),
	('36e1d056-789a-4574-8b11-893e2d470e3e', 'The Co-operative Group', NULL, NULL, NULL, NULL),
	('e165d941-dd82-44ab-ac49-be55ce336bba', 'HIVE EDUCATION TRUST', 1, NULL, '2005-04-04', NULL),
	('94213cc8-78f2-4cb4-91a3-7cc6617d9c0a', 'Diocese of London', NULL, NULL, NULL, NULL),
	('c66276ea-4de3-48bb-9a7f-613e07f2a615', 'MARCH 2016 LIMITED', 1, NULL, '2009-04-27', NULL),
	('e04b4e21-f792-491b-88ba-c7848ab5cf63', 'THE ACADEMY @ RIDGEWOOD TRUST', 1, NULL, '2011-10-03', NULL),
	('4dc58ccf-dadb-4cee-ba8b-4553d5615c14', 'The North Tyneside Learning Trust', NULL, NULL, NULL, NULL),
	('0f3430d8-947f-4fad-b604-e62f783230f7', 'DUNSTONE EDUCATION TRUST', 1, NULL, '2009-07-13', NULL),
	('5be037f1-12fc-4b40-829c-4135c96fc783', 'Acorn Care and Education Ltd', NULL, NULL, NULL, NULL);


--
-- Data for Name: academy_trust_classification; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.academy_trust_classification (academy_trust_classification_id, legal_entity_id, academy_trust_type_id, start_date, end_date, is_current) VALUES
	('0f100f16-1e2b-4a68-90a9-42967725d80c', '244c9b11-50ca-415d-87a2-f4b91eb37e53', 2, NULL, NULL, true),
	('8f7968be-d531-4dad-b5fc-d807a4d25a5d', 'b723a2f1-a5bf-48b0-9e89-ec7527a998fa', 1, NULL, NULL, false),
	('b26c0c26-f2cb-4e07-921d-b1d4a3d01e43', 'e165d941-dd82-44ab-ac49-be55ce336bba', 2, NULL, NULL, true),
	('9fb3ccb2-b32b-48b5-8b05-a287bd60b6c4', 'e165d941-dd82-44ab-ac49-be55ce336bba', 1, NULL, NULL, false),
	('264dacf4-8d4b-4bc5-bc5b-8d24d899ecae', 'c66276ea-4de3-48bb-9a7f-613e07f2a615', 2, NULL, '2016-02-29', false),
	('ab294e0c-8832-4b63-bcd4-dd94f4c07cf4', 'e04b4e21-f792-491b-88ba-c7848ab5cf63', 1, NULL, '2021-03-30', false),
	('5ac52940-1b2b-4086-9269-96f44ec721eb', 'e04b4e21-f792-491b-88ba-c7848ab5cf63', 2, '2021-03-30', NULL, true),
	('44279a12-1e8e-4fbd-a5ec-a69fcc63d3d3', '0f3430d8-947f-4fad-b604-e62f783230f7', 2, NULL, NULL, true);


--
-- Data for Name: address; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.address (address_id, address_line_1, address_line_2, address_line_3, town, county, postcode) VALUES
	('3bd236d7-e7d2-4c63-9f5e-2d67d55eca21', 'obfuscated', NULL, 'obfuscated', 'obfuscated', '032', 'ST6 4LD'),
	('ea20502f-23ab-433c-add5-adcec00ab14b', 'obfuscated', 'Islington', NULL, 'obfuscated', '099', 'N7 8PG'),
	('58250996-2b94-468c-b35b-5586384be67b', 'obfuscated', 'Blackley', NULL, 'obfuscated', '099', 'M9 7SS'),
	('e2a6d4b5-a293-41c4-b3a1-234490876d3d', 'obfuscated', 'Scawsby', NULL, 'obfuscated', '031', 'DN5 7UB'),
	('d7ceafda-e341-4f28-95ae-f9f2d40eb7a5', 'obfuscated', 'Upper Dean', NULL, 'obfuscated', '003', 'PE28 0ND'),
	('1ecc7311-75e2-463a-947c-9faf3b9a5b0c', 'obfuscated', 'Milton Ernest', NULL, 'obfuscated', '001', 'MK44 1RF'),
	('7f355ff6-ba9e-45e4-9270-52a44b64094b', 'obfuscated', 'School Way', 'obfuscated', 'obfuscated', '012', 'SS9 4HX'),
	('89dedebe-e2f0-49a2-8656-88a8f0e746c5', 'obfuscated', NULL, NULL, 'obfuscated', '012', 'SS1 1ES'),
	('e661fad3-fc0f-430e-94e6-967ae22f0c5a', NULL, 'Centre Place', 'obfuscated', 'obfuscated', '012', 'SS1 2JD'),
	('218add21-39d3-4dd9-831a-11de41ae3db3', 'obfuscated', 'Hamstel Road', NULL, 'obfuscated', '012', 'SS2 4PQ'),
	('c3bd88ed-76ff-4377-93af-91ca41107b15', 'obfuscated', NULL, NULL, 'obfuscated', '012', 'SS0 0LG'),
	('38494f61-3e6f-4e0d-b274-8a845ab94b9f', 'obfuscated', 'Constable Way', NULL, 'obfuscated', '012', 'SS3 9XX'),
	('32c62490-7e8f-479a-89ca-42dfc627993e', 'obfuscated', NULL, NULL, 'obfuscated', '012', 'SS0 7AU'),
	('ce7abcb9-ccc6-4430-91e1-035232802313', 'obfuscated', 'Rayleigh Road', 'obfuscated', 'obfuscated', '012', 'SS9 5UT'),
	('883ef9fe-1be4-4ce2-b64d-a4452c94c9c4', 'obfuscated', 'Eastern Avenue', NULL, 'obfuscated', '012', 'SS2 4BA'),
	('073006ad-134b-41ff-b48d-4c09626908ab', 'obfuscated', NULL, NULL, 'obfuscated', '035', 'NE28 9RT'),
	('805e2f5d-e9c6-4725-bf63-6ad5c7056c04', 'obfuscated', NULL, 'obfuscated', 'obfuscated', '019', 'PR2 9YR'),
	('d3c0d2ea-42ff-4047-8130-8c167d79b1ce', 'Kirkby Lonsdale', NULL, NULL, 'Carnforth', '019', 'LA6 2DZ'),
	('81777d1d-dd9c-48be-9e7e-a71328a5cbbc', 'Egerton Road', 'Charing Heath', NULL, 'Ashford', '018', 'TN27 0AX');


--
-- Data for Name: establishment; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment (establishment_id, urn, ukprn, establishment_number, name, establishment_type_id, education_phase_id) VALUES
	('fe72fe3f-5277-44fc-9e69-73e1ee8da281', 136102, 10030216, 6905, 'The Co-Operative Academy of Stoke-On-Trent', 4, 5),
	('98cb3653-0b86-4d9a-97c9-15a02bdc1064', 134314, 10024207, 6905, 'St Mary Magdalene Academy', 4, 6),
	('7f4edade-0b37-4094-a430-cdd2b0f8fb49', 135905, NULL, 6910, 'Manchester Creative and Media Academy', 4, 5),
	('451ad2ed-34d6-458c-a2e5-29c0a203de73', 137603, 10035482, 4033, 'Ridgewood School', 4, 5),
	('2c455dd1-e9cf-41b0-b443-ccd9b722f3fe', 109443, 10077509, 2036, 'Eileen Wade Primary School', 11, 2),
	('5f593782-4859-467b-8e11-9900ddd5ce43', 109613, 10075753, 3023, 'Milton Ernest CofE Primary School', 10, 2),
	('7d1175bd-bfc3-4b29-9cfe-1b19aa2f2602', 20338, NULL, NULL, 'Blenheim Children''s Centre', 35, 8),
	('0e1a85e6-7dc9-4295-ac7b-e2c7c6df8ed8', 20549, NULL, NULL, 'Cambridge Road Children''s Centre', 35, 8),
	('ab99c285-111e-4b81-8f28-cc368413aaab', 20614, NULL, NULL, 'Centre Place Family Centre', 35, 8),
	('2cd15d5d-32d5-4c85-80d0-f60bf98d2256', 21363, NULL, NULL, 'Hamstel Children and Family Centre', 35, 8),
	('a51e2bfa-884c-46e0-9566-5c29016abbda', 22422, NULL, NULL, 'Prince Avenue Children and Family Centre', 35, 8),
	('dcb8c95c-1aa1-411b-b9b4-8571b1f581a1', 22459, NULL, NULL, 'Friars Children''s Centre', 35, 8),
	('f015162d-ae4c-4f05-940d-bfbea4ec86cb', 22975, NULL, NULL, 'Summercourt Children''s Centre', 35, 8),
	('ef90ef60-7cf4-4fdf-80a2-83e66134d7af', 23004, NULL, NULL, 'Eastwood Children''s Centre', 35, 8),
	('4d98af90-074e-4a4a-8f06-7e804e23201d', 23122, NULL, NULL, 'Temple Sutton Children''s Centre', 35, 8),
	('e15da342-e460-4efc-8ea2-e4fad7f2a7d6', 132141, 10073628, 2087, 'Hadrian Park Primary School', 11, 2),
	('4b7db4ba-f393-4998-b205-f517bf10cb3d', 135936, 10027711, 6906, 'Fulwood Academy', 4, 5),
	('1d73f35c-d991-47dd-8997-a7c80dd102c9', 112461, 10015990, 6044, 'Underley Garden School', 15, 8),
	('84d0dfde-0b21-4792-a3f5-d25d3d5e50e0', 119009, 10015772, 6060, 'Heath Farm School', 15, 8);


--
-- Data for Name: capacity_and_pupil_measures; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.capacity_and_pupil_measures (capacity_and_pupil_measures_id, establishment_id, school_capacity, pupil_count, free_school_meal_measure, census_date) VALUES
	('541b1847-f5e5-4c00-b23e-d8a84d27f904', 'fe72fe3f-5277-44fc-9e69-73e1ee8da281', 1050, 1300, 735, NULL),
	('eb3cd560-50fa-4420-b7f9-16f37196e5c6', '98cb3653-0b86-4d9a-97c9-15a02bdc1064', 1310, 1561, 465, NULL),
	('dd84ec0d-6498-44a7-baa8-aab0be269b6a', '7f4edade-0b37-4094-a430-cdd2b0f8fb49', 660, NULL, NULL, NULL),
	('26e4c331-577a-4372-8284-ecda964d93ee', '451ad2ed-34d6-458c-a2e5-29c0a203de73', 1512, 1425, 250, NULL),
	('b0d441c4-ccc3-4777-b184-dd3adcaa24e2', '2c455dd1-e9cf-41b0-b443-ccd9b722f3fe', 23610, 70, 10, NULL),
	('ad49eb50-8524-4d7e-9e64-8768de742914', '5f593782-4859-467b-8e11-9900ddd5ce43', 63964, 67, 5, NULL),
	('758833d3-dd82-4657-8383-6e9a19d2249e', 'e15da342-e460-4efc-8ea2-e4fad7f2a7d6', 965, 422, 114, NULL),
	('00e82e5e-4d52-4c35-920d-f6f19562892e', '4b7db4ba-f393-4998-b205-f517bf10cb3d', 1000, 973, 418, NULL),
	('9767c2b9-e121-4106-99d6-88f28a38291f', '1d73f35c-d991-47dd-8997-a7c80dd102c9', 84881, 101, NULL, NULL),
	('ddde274b-d714-41d9-bbd6-b69c2b9a2ab5', '84d0dfde-0b21-4792-a3f5-d25d3d5e50e0', 20643, 141, NULL, NULL);


--
-- Data for Name: education_admissions_and_provision; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.education_admissions_and_provision (education_admissions_and_provision_id, establishment_id, gender_of_entry_type_id, admissions_policy_id, boarding_provision_id, nursery_provision_id, sixth_form_provision_id) VALUES
	('8d2797fa-ce2e-4e43-91c5-4b331f4bd7f9', 'fe72fe3f-5277-44fc-9e69-73e1ee8da281', 1, 1, 1, 3, 3),
	('f66788e7-7bb1-4861-be42-6fa3bb7f88e4', '98cb3653-0b86-4d9a-97c9-15a02bdc1064', 1, 1, 1, 2, 1),
	('59090054-f469-49a2-bc6f-ab00ece96925', '7f4edade-0b37-4094-a430-cdd2b0f8fb49', 1, 1, 1, 3, 1),
	('2db594e0-7229-4ba3-8e06-26a4a123687c', '451ad2ed-34d6-458c-a2e5-29c0a203de73', 1, 1, 1, 3, 1),
	('3d8f95b6-fc84-40f1-9238-3f1b8cca6daf', '2c455dd1-e9cf-41b0-b443-ccd9b722f3fe', 1, 3, 1, 2, 2),
	('48cfbc86-a99b-4408-8f7e-b9e2a41f4aa6', '5f593782-4859-467b-8e11-9900ddd5ce43', 1, 3, 1, 2, 2),
	('5cbb7876-89da-4a60-9a6a-8ab9100e9f18', '7d1175bd-bfc3-4b29-9cfe-1b19aa2f2602', NULL, 3, NULL, 3, 3),
	('549e56cc-dc93-4c2c-9011-10227fa4465c', '0e1a85e6-7dc9-4295-ac7b-e2c7c6df8ed8', NULL, 3, NULL, 3, 3),
	('972a40e2-3ddb-4173-be24-e9a3cbb911ce', 'ab99c285-111e-4b81-8f28-cc368413aaab', NULL, 3, NULL, 3, 3),
	('05d67a2e-c4e7-44d8-ad87-06d68ae8c061', '2cd15d5d-32d5-4c85-80d0-f60bf98d2256', NULL, 3, NULL, 3, 3),
	('1c5844c9-1ea1-48a4-90da-8f0871827890', 'a51e2bfa-884c-46e0-9566-5c29016abbda', NULL, 3, NULL, 3, 3),
	('6d8252c8-e303-4a51-a344-0ced6fd82245', 'dcb8c95c-1aa1-411b-b9b4-8571b1f581a1', NULL, 3, NULL, 3, 3),
	('a47d87c0-c069-4b2d-b126-198f33c12178', 'f015162d-ae4c-4f05-940d-bfbea4ec86cb', NULL, 3, NULL, 3, 3),
	('0be094c3-278b-4239-ab9b-188908768b11', 'ef90ef60-7cf4-4fdf-80a2-83e66134d7af', NULL, 3, NULL, 3, 3),
	('f5ab3a2f-129e-4447-8bd0-5fb47e98fdb8', '4d98af90-074e-4a4a-8f06-7e804e23201d', NULL, 3, NULL, 3, 3),
	('15dc9055-a38a-45bd-bb11-bdce93ebfe62', 'e15da342-e460-4efc-8ea2-e4fad7f2a7d6', 1, 3, 1, 1, 2),
	('5fe29953-7282-4377-8ca9-f8bad38c2b5d', '4b7db4ba-f393-4998-b205-f517bf10cb3d', 1, 1, 1, 3, 2),
	('bfb89d31-ceca-442d-bd0c-1a06191eccec', '1d73f35c-d991-47dd-8997-a7c80dd102c9', 1, 2, 3, 3, 1),
	('5b60221a-8a98-45ab-8189-14aa68492c6e', '84d0dfde-0b21-4792-a3f5-d25d3d5e50e0', 1, NULL, 1, 2, 1);


--
-- Data for Name: establishment_contact; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_contact (establishment_contact_id, establishment_id, website, telephone_number) VALUES
	('4ae1f15e-dd97-49ce-b57e-852f18496fcf', 'fe72fe3f-5277-44fc-9e69-73e1ee8da281', 'http://www.cas.coop', '111111'),
	('9e8d12f2-de4f-47ae-b410-b7a00bc3eeb0', '98cb3653-0b86-4d9a-97c9-15a02bdc1064', 'www.smmacademy.org', '111111'),
	('c7a36d33-192b-4b34-928b-9ef69f992a06', '451ad2ed-34d6-458c-a2e5-29c0a203de73', 'http://www.ridgewoodschool.co.uk', '111111'),
	('2946f417-6beb-40b0-93f2-6d2406d79731', '2c455dd1-e9cf-41b0-b443-ccd9b722f3fe', 'www.ewmeschools.org.uk', '111111'),
	('5a66b422-b22c-4746-b006-020f89d6d24c', '5f593782-4859-467b-8e11-9900ddd5ce43', 'www.ewmeschools.org.uk', '111111'),
	('dd20e279-aec4-4258-84ce-67b56dce502e', '7d1175bd-bfc3-4b29-9cfe-1b19aa2f2602', NULL, '111111'),
	('c0842064-a0e1-4a72-a0e6-72fa22221b5e', '0e1a85e6-7dc9-4295-ac7b-e2c7c6df8ed8', NULL, '111111'),
	('77ea7e96-eb2e-40e4-94b8-a5b6bf9a2b75', 'ab99c285-111e-4b81-8f28-cc368413aaab', NULL, '111111'),
	('9d77ab48-a1b5-4028-bb9c-d07f7d93a94a', '2cd15d5d-32d5-4c85-80d0-f60bf98d2256', NULL, '111111'),
	('5f50effc-0df9-4ced-b316-64f72989331b', 'a51e2bfa-884c-46e0-9566-5c29016abbda', NULL, '111111'),
	('d69aed1a-39f8-4027-9b79-97f1f735f098', 'dcb8c95c-1aa1-411b-b9b4-8571b1f581a1', NULL, '111111'),
	('bf7ab6bb-cfdd-4030-bc2a-2e229edff7c8', 'f015162d-ae4c-4f05-940d-bfbea4ec86cb', NULL, '111111'),
	('c983b169-74c6-4f17-8d0a-5e395f8744fc', 'ef90ef60-7cf4-4fdf-80a2-83e66134d7af', NULL, '111111'),
	('e3766ab7-65d1-461c-8407-9e509d03ae78', '4d98af90-074e-4a4a-8f06-7e804e23201d', NULL, '111111'),
	('e6b51543-335e-418d-98be-6e76a7d9dc67', 'e15da342-e460-4efc-8ea2-e4fad7f2a7d6', 'www.hadrianparkprimary.org.uk/', '111111'),
	('bbc6cbfb-9b88-4169-ab0d-6f23fc226d1f', '4b7db4ba-f393-4998-b205-f517bf10cb3d', 'http://www.fulwoodacademy.co.uk/', '111111'),
	('19e5d2b0-45f1-40cb-965e-412c6b9a1a2f', '1d73f35c-d991-47dd-8997-a7c80dd102c9', 'www.underleygarden.org', '111111'),
	('c370107e-4294-4615-9299-2b33590f6511', '84d0dfde-0b21-4792-a3f5-d25d3d5e50e0', NULL, '111111');


--
-- Data for Name: establishment_geography; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_geography (establishment_geography_id, establishment_id, local_authority_id, government_office_region_id, district_administrative_id, administrative_ward_id, parliamentary_constituency_id, lsoa_id, msoa_id, urban_rural_id) VALUES
	('a7613cb7-ced8-413a-bb8a-15e262d3bbe2', 'fe72fe3f-5277-44fc-9e69-73e1ee8da281', '3332ea83-bcbe-48d1-970d-a3650d9bcf10', '7ca695f4-dfcd-4f78-bdaf-17861eafbf97', '6ef1f577-d0bc-4698-951c-f202f9eaada6', 'e73f0fc2-114a-4772-a84e-5363b02ba34b', '714fb4a2-4d2e-4875-9853-1d7d6696559e', 'cec78739-d3a7-4831-9934-8dec5c5bdcd1', '5ed6445f-c41a-4778-9a5c-55ba74a2155b', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('adc37964-8bde-4605-a570-af67554ff29d', '98cb3653-0b86-4d9a-97c9-15a02bdc1064', '3574e75c-8870-449a-82e7-1b083e2efc42', '1375841f-e6ba-4cda-9fac-753ff9df93a2', '9a5cfcfa-3605-4253-8e1c-fc081510a4ea', '9a2f2163-03c6-45b8-84e0-b34cc7a3450c', '6c7acd08-ad7f-406e-85e4-0bade3e57de6', '05aa5060-26b4-4edf-ad40-5e4640903d5a', '0d87ce8f-019d-4403-9527-975bbabd10e1', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('be997ee4-41a2-42e3-b7d5-9b53fe87dcc2', '7f4edade-0b37-4094-a430-cdd2b0f8fb49', '0a78f87e-d71b-44c3-b598-2cc2b8038e95', '489dce3e-58d7-44c5-b9ef-2f7d7cbdb592', 'c8efb411-9c6d-492e-af1e-624ed743712f', 'f22dfd05-c647-403a-bebd-69fb3a62cca6', '93b33a64-95d1-4d7f-9142-4acc73221e9a', '22d38930-6da2-4b70-9bca-6208cbb43ba5', 'cddc19f9-9b91-4e98-a4c8-656753fd673c', 'fba31373-6bf1-4ad2-9d63-a2c783849aad'),
	('1baa27d6-6e38-4527-bf7b-67ea84913342', '451ad2ed-34d6-458c-a2e5-29c0a203de73', '77b9cfe6-842e-41c8-9be4-410cac32719a', 'f5cdf1f1-5f75-4420-b597-862614e13549', '05471fcf-d815-4c82-a7f6-6a9ff75cdaa2', 'cf41c2bc-c0cc-4394-992e-1db6d9f032dd', '8d116d07-483e-41bc-83ea-00c89c3f3a6d', 'c4402a6f-a614-4961-a889-554ef686642a', '011465c5-0d85-498d-8b85-14ea8833c9d5', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('2b0212ac-7190-410f-8e29-b022a218cd90', '2c455dd1-e9cf-41b0-b443-ccd9b722f3fe', '942f0927-84a7-43b6-8be9-68f88917b043', '32e46d74-0ebf-495b-8261-2c508cd2c2bb', '1146af1e-822e-49f1-a51e-da31f849045c', 'f08ea39d-20ae-4f5e-8274-15207e7b5eec', 'd180f323-3f6f-44dc-a1de-d1cac6e11c0c', '84494da7-5525-4dc5-a454-83a2b9b7bdc0', 'bc444798-7011-43c1-a1e2-269efd7885ef', '1c041cb3-373a-4dd5-9af4-2950293776bc'),
	('24be2b06-ef4d-400d-b92d-ee66d2b6d4cd', '5f593782-4859-467b-8e11-9900ddd5ce43', '942f0927-84a7-43b6-8be9-68f88917b043', '32e46d74-0ebf-495b-8261-2c508cd2c2bb', '1146af1e-822e-49f1-a51e-da31f849045c', 'f08ea39d-20ae-4f5e-8274-15207e7b5eec', 'd180f323-3f6f-44dc-a1de-d1cac6e11c0c', '534b5a89-c075-4962-8367-8c8ffc158b9e', 'edc1ad99-4391-4d91-8717-6c10929ae180', '1c041cb3-373a-4dd5-9af4-2950293776bc'),
	('a27a8fbc-4b2d-484f-903f-97f6b389b861', '7d1175bd-bfc3-4b29-9cfe-1b19aa2f2602', 'dc9f9e86-8d80-46b7-87bc-e998cafca819', '32e46d74-0ebf-495b-8261-2c508cd2c2bb', '38ab2b8e-4373-4176-8944-4c6d8cffa7d8', 'c21f6874-6733-4b9b-bc1a-b54fbb495ac9', 'c487eba0-9903-4df2-b999-20f1cca784fb', '84badc4c-a7f2-4af6-8532-8ebf665e5686', '0d9136b3-d6e1-4143-bc20-59738dffb35b', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('9ab1cf0d-6cfd-4e6d-a9c4-5b21d12199e8', '0e1a85e6-7dc9-4295-ac7b-e2c7c6df8ed8', 'dc9f9e86-8d80-46b7-87bc-e998cafca819', '32e46d74-0ebf-495b-8261-2c508cd2c2bb', '38ab2b8e-4373-4176-8944-4c6d8cffa7d8', '0af643ac-6840-48a4-8ed7-dc98ad8626a9', '485e8a03-6bd3-4c3b-95d6-baf2f9b44cad', 'd7b13e80-761e-4cb2-b40f-0dfb91095689', '6c891a27-897f-41ec-ac35-7e207d4fead3', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('96fba807-daae-4dc1-b1ce-54a35c96ec19', 'ab99c285-111e-4b81-8f28-cc368413aaab', 'dc9f9e86-8d80-46b7-87bc-e998cafca819', '32e46d74-0ebf-495b-8261-2c508cd2c2bb', '38ab2b8e-4373-4176-8944-4c6d8cffa7d8', '28286c17-e7ea-4022-b909-1a6b60808185', '485e8a03-6bd3-4c3b-95d6-baf2f9b44cad', '56a40580-3dbd-4d1f-bdaa-54370f39b26d', 'd40b3466-6329-406a-93f7-a4978722af70', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('305c3ac5-bfc3-4526-b2c5-e6dfa80f35d2', '2cd15d5d-32d5-4c85-80d0-f60bf98d2256', 'dc9f9e86-8d80-46b7-87bc-e998cafca819', '32e46d74-0ebf-495b-8261-2c508cd2c2bb', '38ab2b8e-4373-4176-8944-4c6d8cffa7d8', 'bdd0a9a0-8af5-4232-b7ce-30a76be572ca', '485e8a03-6bd3-4c3b-95d6-baf2f9b44cad', 'e8b85e8f-e837-4dd2-9ac3-b3f22e6f83a6', '5a9caa00-1c9c-49c6-ba30-dd3df2b2599f', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('4728e993-f18b-4428-b6f1-3a89f95f19f0', 'a51e2bfa-884c-46e0-9566-5c29016abbda', 'dc9f9e86-8d80-46b7-87bc-e998cafca819', '32e46d74-0ebf-495b-8261-2c508cd2c2bb', '38ab2b8e-4373-4176-8944-4c6d8cffa7d8', '1bcfab2c-6971-4998-9c38-55c1e039be68', 'c487eba0-9903-4df2-b999-20f1cca784fb', '52692e65-37ae-4851-9b83-d318448b8a15', '35b2356d-cad3-415a-af7d-dc32bd148ae2', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('6ab8b0ea-463a-4972-b770-c159aef5bae6', 'dcb8c95c-1aa1-411b-b9b4-8571b1f581a1', 'dc9f9e86-8d80-46b7-87bc-e998cafca819', '32e46d74-0ebf-495b-8261-2c508cd2c2bb', '38ab2b8e-4373-4176-8944-4c6d8cffa7d8', 'b40c3129-d1f9-4ee7-9b6f-a4ed111c7109', '485e8a03-6bd3-4c3b-95d6-baf2f9b44cad', '1e9505f2-4f09-47be-82fe-648e59412d31', 'c5197681-247e-481b-b496-b4503db81187', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('0aaad548-a1bf-444f-a0e7-01eb3f4ad641', 'f015162d-ae4c-4f05-940d-bfbea4ec86cb', 'dc9f9e86-8d80-46b7-87bc-e998cafca819', '32e46d74-0ebf-495b-8261-2c508cd2c2bb', '38ab2b8e-4373-4176-8944-4c6d8cffa7d8', '9fdf9c47-28c6-4d2f-ba6f-906b588206c3', '485e8a03-6bd3-4c3b-95d6-baf2f9b44cad', 'e8a5b83c-e982-454d-a84a-3bb3b76806f3', '5577ba9a-318d-4440-8baa-7abf3925e7f0', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('cd36bf8f-4fc7-4081-8853-fb8a81b75153', 'ef90ef60-7cf4-4fdf-80a2-83e66134d7af', 'dc9f9e86-8d80-46b7-87bc-e998cafca819', '32e46d74-0ebf-495b-8261-2c508cd2c2bb', '38ab2b8e-4373-4176-8944-4c6d8cffa7d8', '1bcfab2c-6971-4998-9c38-55c1e039be68', 'c487eba0-9903-4df2-b999-20f1cca784fb', '34a90645-b540-4351-8d4b-356bec2a4c76', '35b2356d-cad3-415a-af7d-dc32bd148ae2', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('690cccc0-5008-4b59-a8b4-390aae679336', '4d98af90-074e-4a4a-8f06-7e804e23201d', 'dc9f9e86-8d80-46b7-87bc-e998cafca819', '32e46d74-0ebf-495b-8261-2c508cd2c2bb', '38ab2b8e-4373-4176-8944-4c6d8cffa7d8', 'e8e39ac5-cd31-4312-8f42-063aed530c47', 'c487eba0-9903-4df2-b999-20f1cca784fb', 'e43873e2-e36a-4f91-876b-b62ee15b6a55', '15cd7b16-0306-42b8-8208-9cca5b9deda3', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('5997b260-1a0d-4d3e-b5e8-4688a7aa4041', 'e15da342-e460-4efc-8ea2-e4fad7f2a7d6', 'cf117bdb-0226-42f0-9f40-e11aa3369b61', '6cc3324b-91cb-4ea6-a0db-2cd327ce7941', '7272229e-d4b1-419e-849b-531e45200032', 'ec46bd78-eaea-4593-b5de-9d07bb169875', '68489e77-9d60-498a-840c-712d1fb7ae01', 'bb066056-57d6-44aa-ae8f-b9ecc2d16c15', '07789943-52cc-4a00-a811-7656fbdc20f4', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('abe76b05-9b77-45a3-bbb2-42f833efe0d8', '4b7db4ba-f393-4998-b205-f517bf10cb3d', 'a4572037-9765-42e9-890c-0a4c47a49abd', '489dce3e-58d7-44c5-b9ef-2f7d7cbdb592', '50c00d93-da6b-4df1-87ad-ebe1b4af26d0', 'a92333cd-38a8-4b10-9822-3d66ade87507', 'd0b01b14-129d-452c-aba9-32a10da493ab', '87cd11b8-7e94-47cd-9996-0ecc21f1ca54', '7dd76107-3e1d-40a1-b89b-e801475b55b9', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('05306cfc-f666-4041-a80a-3bf16531771b', '1d73f35c-d991-47dd-8997-a7c80dd102c9', 'c3481033-0753-4614-b00b-677ccc85d1ee', '489dce3e-58d7-44c5-b9ef-2f7d7cbdb592', '3f0b99bb-4666-463d-b373-6f096c6c032c', '1e6798c9-c8d2-4cec-acfa-c60a17acc802', 'ce572531-777d-4112-b07a-99c827d21bb7', '48507344-3f4b-475c-9b60-b913b01b5d27', '0254b351-1c59-4e0e-822d-b99b185b22f4', 'f755a09b-bf99-4ac1-a3cc-266ad9a9c32b'),
	('92d68b5f-01d6-4ef8-83bc-a23ff7d1cc8e', '84d0dfde-0b21-4792-a3f5-d25d3d5e50e0', '893121c9-05e6-4e35-bfef-ea76e40c012e', 'f85647db-e5d1-41a6-befb-bfbf6420f5c4', '17fc3b24-6e02-44e2-8efc-2c47da891a27', '530f3047-08df-4892-b9ab-16df2a2a39be', '530f1da7-9067-43a1-b515-e93f9199b65e', 'cda69748-98b0-4ee6-a025-27833304c743', '7100b4af-5ca3-4746-a8ef-4c5f46714353', '1c041cb3-373a-4dd5-9af4-2950293776bc');


--
-- Data for Name: establishment_lifecycle; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_lifecycle (establishment_lifecycle_id, establishment_id, establishment_status_id, open_date, close_date, reason_establishment_opened_id, reason_establishment_closed_id, last_changed_date) VALUES
	('75d9fbbc-d198-4c78-beb4-91e777fcd4c7', 'fe72fe3f-5277-44fc-9e69-73e1ee8da281', 1, '2010-09-01', NULL, 2, NULL, '2026-06-23'),
	('ddcf8386-5f1c-43c1-9465-00b1210156a0', '98cb3653-0b86-4d9a-97c9-15a02bdc1064', 1, '2007-09-01', NULL, 2, NULL, '2026-06-23'),
	('1b291c64-5be1-477a-919a-005f0b8e0ac3', '7f4edade-0b37-4094-a430-cdd2b0f8fb49', 2, '2009-09-01', '2016-02-29', 2, 12, '2018-07-02'),
	('9e0a2395-0b9a-4baa-946b-65664b6909fc', '451ad2ed-34d6-458c-a2e5-29c0a203de73', 1, '2011-11-01', NULL, 1, NULL, '2026-06-23'),
	('0244d878-1a4e-41b2-b096-76a1d3cd84dd', '2c455dd1-e9cf-41b0-b443-ccd9b722f3fe', 1, NULL, NULL, NULL, NULL, '2026-06-23'),
	('996042f1-cd02-4daf-9c72-a2d958db60d6', '5f593782-4859-467b-8e11-9900ddd5ce43', 1, NULL, NULL, NULL, NULL, '2026-06-23'),
	('53a63b6e-1424-4ec7-a82f-bbf52ecbebe5', '7d1175bd-bfc3-4b29-9cfe-1b19aa2f2602', 1, '2008-02-07', NULL, NULL, NULL, '2025-06-20'),
	('0b37d871-1715-4499-8a4e-1910be0ac279', '0e1a85e6-7dc9-4295-ac7b-e2c7c6df8ed8', 1, '2006-03-14', NULL, NULL, NULL, '2025-06-20'),
	('86255f2f-464a-4f21-9b1f-809e584f16de', 'ab99c285-111e-4b81-8f28-cc368413aaab', 1, '2008-03-03', NULL, NULL, NULL, '2025-06-20'),
	('5f4bc790-947d-4a1c-adb9-9d50652fc6e6', '2cd15d5d-32d5-4c85-80d0-f60bf98d2256', 1, '2009-12-14', NULL, NULL, NULL, '2025-06-20'),
	('2224316b-47bf-4921-b875-b9264af09186', 'a51e2bfa-884c-46e0-9566-5c29016abbda', 1, '2009-12-14', NULL, NULL, NULL, '2025-06-20'),
	('54594de0-04e6-469d-8568-3de6e9833ffc', 'dcb8c95c-1aa1-411b-b9b4-8571b1f581a1', 1, '2008-01-16', NULL, NULL, NULL, '2025-06-20'),
	('e612f216-09ea-4a49-ad86-761130c64955', 'f015162d-ae4c-4f05-940d-bfbea4ec86cb', 1, '2008-01-16', NULL, NULL, NULL, '2025-06-20'),
	('3a1bdf00-fe96-40a6-b813-b31946208400', 'ef90ef60-7cf4-4fdf-80a2-83e66134d7af', 1, '2008-02-07', NULL, NULL, NULL, '2025-06-20'),
	('2f670646-2438-4b79-8a89-0397a134b1b4', '4d98af90-074e-4a4a-8f06-7e804e23201d', 1, '2006-09-28', NULL, NULL, NULL, '2025-06-20'),
	('5ca37926-6633-449d-95fd-671ff19040ef', 'e15da342-e460-4efc-8ea2-e4fad7f2a7d6', 1, '2001-09-01', NULL, 6, NULL, '2025-06-20'),
	('06ba6f87-be71-4a4a-b344-f18aeaf3feee', '4b7db4ba-f393-4998-b205-f517bf10cb3d', 1, '2009-09-01', NULL, 2, NULL, '2026-06-23'),
	('131938f7-a4cb-45e2-b21c-7cc30bc72d1f', '1d73f35c-d991-47dd-8997-a7c80dd102c9', 1, '1990-03-28', NULL, NULL, NULL, '2026-07-20'),
	('415fd5b4-c59a-4861-a2c8-a85931c89ff6', '84d0dfde-0b21-4792-a3f5-d25d3d5e50e0', 1, '1988-12-12', NULL, NULL, NULL, '2026-07-20');


--
-- Data for Name: person; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.person (person_id) VALUES
	('251ffeb7-8cfa-4339-9483-1d34c56198b0');


--
-- Data for Name: establishment_party_role; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_party_role (establishment_party_role_id, establishment_party_role_type_id, legal_entity_id, person_id, start_date, end_date) VALUES
	('55c3dfaf-699c-42bf-b56c-ccd86bf18923', 1, '244c9b11-50ca-415d-87a2-f4b91eb37e53', NULL, NULL, NULL),
	('d2b4bdd4-fd45-4c9c-b547-c98c75874ca1', 1, 'b723a2f1-a5bf-48b0-9e89-ec7527a998fa', NULL, NULL, NULL),
	('74235b37-ec44-467b-a19f-a9ce06b3aa15', 4, '36e1d056-789a-4574-8b11-893e2d470e3e', NULL, NULL, NULL),
	('bb3387e0-2348-484f-a92b-48f94be1d681', 1, 'e165d941-dd82-44ab-ac49-be55ce336bba', NULL, NULL, NULL),
	('f9b4627b-e24a-4056-805b-356f6575423d', 4, '94213cc8-78f2-4cb4-91a3-7cc6617d9c0a', NULL, NULL, NULL),
	('063411f5-f50d-41a3-b17f-777ad4c0a9fd', 1, 'c66276ea-4de3-48bb-9a7f-613e07f2a615', NULL, NULL, '2016-02-29'),
	('9f8e70f2-d0df-4a07-b823-f76f50011894', 1, 'e04b4e21-f792-491b-88ba-c7848ab5cf63', NULL, NULL, NULL),
	('f1b26597-1fca-4286-a0bb-e7b708248514', 2, '4dc58ccf-dadb-4cee-ba8b-4553d5615c14', NULL, NULL, NULL),
	('bc85ae83-f01e-4764-993b-67e44a8c0f06', 4, NULL, '251ffeb7-8cfa-4339-9483-1d34c56198b0', NULL, NULL),
	('1eb11232-bed2-4aee-953e-4ab901001737', 1, '0f3430d8-947f-4fad-b604-e62f783230f7', NULL, NULL, NULL);


--
-- Data for Name: establishment_responsibility; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_responsibility (establishment_responsibility_id, establishment_id, legal_entity_id, person_id, responsibility_type_id, academy_trust_type_id, start_date, end_date, is_current) VALUES
	('5f49907d-8358-49a6-8e79-e605aba96e95', 'fe72fe3f-5277-44fc-9e69-73e1ee8da281', '244c9b11-50ca-415d-87a2-f4b91eb37e53', NULL, 1, 2, '2015-07-01', NULL, true),
	('644bae51-7218-4c56-9055-bc9e10f590b7', 'fe72fe3f-5277-44fc-9e69-73e1ee8da281', 'b723a2f1-a5bf-48b0-9e89-ec7527a998fa', NULL, 1, 1, '2010-09-01', NULL, false),
	('3e0da29a-94cd-41c5-b391-abb8c854e38c', 'fe72fe3f-5277-44fc-9e69-73e1ee8da281', '36e1d056-789a-4574-8b11-893e2d470e3e', NULL, 3, NULL, '2010-09-01', NULL, true),
	('86cc51df-3d54-49a9-a6fb-19a6bcf22f5a', '98cb3653-0b86-4d9a-97c9-15a02bdc1064', 'e165d941-dd82-44ab-ac49-be55ce336bba', NULL, 1, 2, '2021-10-04', NULL, true),
	('81e844e4-5871-4d79-8a65-abfdcbb396e8', '98cb3653-0b86-4d9a-97c9-15a02bdc1064', 'e165d941-dd82-44ab-ac49-be55ce336bba', NULL, 1, 1, '2007-09-01', NULL, false),
	('c739264f-e2e1-46f2-912f-a5de94824f00', '98cb3653-0b86-4d9a-97c9-15a02bdc1064', '94213cc8-78f2-4cb4-91a3-7cc6617d9c0a', NULL, 3, NULL, '2007-09-01', NULL, true),
	('1692eed1-25b3-41b5-8438-0a3b9160020b', '7f4edade-0b37-4094-a430-cdd2b0f8fb49', 'c66276ea-4de3-48bb-9a7f-613e07f2a615', NULL, 1, 2, '2009-09-01', '2016-02-29', false),
	('c6fa0892-f6db-464c-a7ae-49a1c4e0eee1', '451ad2ed-34d6-458c-a2e5-29c0a203de73', 'e04b4e21-f792-491b-88ba-c7848ab5cf63', NULL, 1, 1, '2011-11-01', NULL, false),
	('48ca263b-b11d-4e1a-86d9-d0ff69dd44da', '451ad2ed-34d6-458c-a2e5-29c0a203de73', 'e04b4e21-f792-491b-88ba-c7848ab5cf63', NULL, 1, 2, '2021-03-30', NULL, true),
	('4cd9eb21-a2ba-4e3d-a13b-2cf056943475', 'e15da342-e460-4efc-8ea2-e4fad7f2a7d6', '4dc58ccf-dadb-4cee-ba8b-4553d5615c14', NULL, 2, NULL, '2011-09-01', NULL, true),
	('d86a3a70-c575-496e-8768-1e18e3517e40', '4b7db4ba-f393-4998-b205-f517bf10cb3d', NULL, '251ffeb7-8cfa-4339-9483-1d34c56198b0', 3, NULL, '2009-09-01', NULL, true),
	('ab7f6b56-1157-4a63-8c47-19efcf23ae93', '4b7db4ba-f393-4998-b205-f517bf10cb3d', '0f3430d8-947f-4fad-b604-e62f783230f7', NULL, 1, 2, '2009-09-01', NULL, true),
	('61fe498a-e04a-4242-a07a-13de4d365157', '1d73f35c-d991-47dd-8997-a7c80dd102c9', '5be037f1-12fc-4b40-829c-4135c96fc783', NULL, 4, NULL, NULL, NULL, true),
	('fe1d5a6c-e088-4003-ad51-7e2bdcf73e26', '84d0dfde-0b21-4792-a3f5-d25d3d5e50e0', '5be037f1-12fc-4b40-829c-4135c96fc783', NULL, 4, NULL, NULL, NULL, true);


--
-- Data for Name: site; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.site (site_id, address_id, site_name, uprn) VALUES
	('d624a2af-39d4-490d-80f2-2c0ef2e35acf', '3bd236d7-e7d2-4c63-9f5e-2d67d55eca21', NULL, 3455015782),
	('eff30d01-6ea2-47f6-ba42-48137d24f099', 'ea20502f-23ab-433c-add5-adcec00ab14b', NULL, 5300060053),
	('8e54d0cc-da80-4916-bee1-52c20f8d6640', '58250996-2b94-468c-b35b-5586384be67b', NULL, 10090666596),
	('67670aed-74fe-45d5-ae92-5e8dfe7ec7f0', 'e2a6d4b5-a293-41c4-b3a1-234490876d3d', NULL, 10006581609),
	('5143b8b7-9f5f-41c6-a599-ad83ae4b8ca4', 'd7ceafda-e341-4f28-95ae-f9f2d40eb7a5', NULL, 100081218005),
	('dae7db0e-ad3a-46cd-ae84-f0699dc7d8b5', '1ecc7311-75e2-463a-947c-9faf3b9a5b0c', NULL, 100081212588),
	('28eedf39-a4ce-412c-a073-12d848602f2d', '7f355ff6-ba9e-45e4-9270-52a44b64094b', NULL, 100091605340),
	('8aad1744-79de-4a0b-9240-191fa2d10388', '89dedebe-e2f0-49a2-8656-88a8f0e746c5', NULL, NULL),
	('248c7895-065c-4c22-8326-316e02164247', 'e661fad3-fc0f-430e-94e6-967ae22f0c5a', NULL, 10024158444),
	('eb506dcc-7c14-4c4c-922d-08049defcb20', '218add21-39d3-4dd9-831a-11de41ae3db3', NULL, 100091593148),
	('240defb7-4b50-4473-891b-bf04f07bf78a', 'c3bd88ed-76ff-4377-93af-91ca41107b15', NULL, 10012151948),
	('cf5eb64a-ecdd-41b9-8760-cf1c5d33fe23', '38494f61-3e6f-4e0d-b274-8a845ab94b9f', NULL, 100091595925),
	('48630c06-ac14-4f79-955e-d140b3c093ac', '32c62490-7e8f-479a-89ca-42dfc627993e', NULL, 10012152076),
	('ccefb697-0a27-4ee7-94a9-693d69ca6e20', 'ce7abcb9-ccc6-4430-91e1-035232802313', NULL, 100091656436),
	('d9fa9dfd-f1d3-4c88-a885-4b448a559d79', '883ef9fe-1be4-4ce2-b64d-a4452c94c9c4', NULL, 200001258935),
	('553fbab0-02c3-4a3d-8550-cab2b1375e1e', '073006ad-134b-41ff-b48d-4c09626908ab', NULL, 47000575),
	('f5c6ad77-e46c-40fa-98cf-07617b657cb6', '805e2f5d-e9c6-4725-bf63-6ad5c7056c04', NULL, 100012750549),
	('d8bf6c99-e0cd-40d2-a00f-3e6789318893', 'd3c0d2ea-42ff-4047-8130-8c167d79b1ce', NULL, NULL),
	('df793169-d9f6-44fa-b21b-47c48ffc689d', '81777d1d-dd9c-48be-9e7e-a71328a5cbbc', NULL, 200004392318);


--
-- Data for Name: establishment_to_site; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_to_site (establishment_id, site_id, is_main_site) VALUES
	('fe72fe3f-5277-44fc-9e69-73e1ee8da281', 'd624a2af-39d4-490d-80f2-2c0ef2e35acf', true),
	('98cb3653-0b86-4d9a-97c9-15a02bdc1064', 'eff30d01-6ea2-47f6-ba42-48137d24f099', true),
	('7f4edade-0b37-4094-a430-cdd2b0f8fb49', '8e54d0cc-da80-4916-bee1-52c20f8d6640', true),
	('451ad2ed-34d6-458c-a2e5-29c0a203de73', '67670aed-74fe-45d5-ae92-5e8dfe7ec7f0', true),
	('2c455dd1-e9cf-41b0-b443-ccd9b722f3fe', '5143b8b7-9f5f-41c6-a599-ad83ae4b8ca4', true),
	('5f593782-4859-467b-8e11-9900ddd5ce43', 'dae7db0e-ad3a-46cd-ae84-f0699dc7d8b5', true),
	('7d1175bd-bfc3-4b29-9cfe-1b19aa2f2602', '28eedf39-a4ce-412c-a073-12d848602f2d', true),
	('0e1a85e6-7dc9-4295-ac7b-e2c7c6df8ed8', '8aad1744-79de-4a0b-9240-191fa2d10388', true),
	('ab99c285-111e-4b81-8f28-cc368413aaab', '248c7895-065c-4c22-8326-316e02164247', true),
	('2cd15d5d-32d5-4c85-80d0-f60bf98d2256', 'eb506dcc-7c14-4c4c-922d-08049defcb20', true),
	('a51e2bfa-884c-46e0-9566-5c29016abbda', '240defb7-4b50-4473-891b-bf04f07bf78a', true),
	('dcb8c95c-1aa1-411b-b9b4-8571b1f581a1', 'cf5eb64a-ecdd-41b9-8760-cf1c5d33fe23', true),
	('f015162d-ae4c-4f05-940d-bfbea4ec86cb', '48630c06-ac14-4f79-955e-d140b3c093ac', true),
	('ef90ef60-7cf4-4fdf-80a2-83e66134d7af', 'ccefb697-0a27-4ee7-94a9-693d69ca6e20', true),
	('4d98af90-074e-4a4a-8f06-7e804e23201d', 'd9fa9dfd-f1d3-4c88-a885-4b448a559d79', true),
	('e15da342-e460-4efc-8ea2-e4fad7f2a7d6', '553fbab0-02c3-4a3d-8550-cab2b1375e1e', true),
	('4b7db4ba-f393-4998-b205-f517bf10cb3d', 'f5c6ad77-e46c-40fa-98cf-07617b657cb6', true),
	('1d73f35c-d991-47dd-8997-a7c80dd102c9', 'd8bf6c99-e0cd-40d2-a00f-3e6789318893', true),
	('84d0dfde-0b21-4792-a3f5-d25d3d5e50e0', 'df793169-d9f6-44fa-b21b-47c48ffc689d', true);


--
-- Data for Name: organisation_group; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.organisation_group (organisation_group_id, name, organisation_group_type_id, local_authority_id, open_date, close_date) VALUES
	('49491bf6-94a2-46cf-8a8d-2cb446fd40ec', 'Federation of Eileen Wade and Milton Ernest VC lower schools', 1, NULL, '2011-01-13', NULL),
	('a092771d-bfd0-4529-b550-61567cec5c5e', 'Southend Children''s Centres', 2, 'dc9f9e86-8d80-46b7-87bc-e998cafca819', '2016-10-01', NULL);


--
-- Data for Name: group_identifier; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.group_identifier (group_identifier_id, establishment_party_role_id, organisation_group_id, group_identifier_type_id, group_identifier_issuer_id, value, is_current) VALUES
	('e0ae3ded-f41b-42a2-bb8d-bf867ed3778b', '55c3dfaf-699c-42bf-b56c-ccd86bf18923', NULL, 1, 1, '2777', true),
	('3b7d01f0-f7cf-472a-97f9-be15aef2d2f5', '55c3dfaf-699c-42bf-b56c-ccd86bf18923', NULL, 2, 1, 'TR00567', true),
	('5b279eca-1096-46ab-a132-95417967e40d', 'd2b4bdd4-fd45-4c9c-b547-c98c75874ca1', NULL, 1, 1, '2779', false),
	('0aec6b60-8586-4377-b83c-123fa0db9be7', 'd2b4bdd4-fd45-4c9c-b547-c98c75874ca1', NULL, 2, 1, 'TR00569', false),
	('afc42c23-be28-4353-b59c-7a4b215605b7', '74235b37-ec44-467b-a19f-a9ce06b3aa15', NULL, 1, 1, '4949', true),
	('48dae5ad-873f-455a-b8db-6e543da212c0', '74235b37-ec44-467b-a19f-a9ce06b3aa15', NULL, 2, 1, 'SP00125', true),
	('a4ae5290-eff1-4c68-a767-e57ddfec941d', 'bb3387e0-2348-484f-a92b-48f94be1d681', NULL, 1, 1, '23869', true),
	('72b6258a-e09c-4575-928e-8b9a47e38add', 'bb3387e0-2348-484f-a92b-48f94be1d681', NULL, 2, 1, 'TR02103', true),
	('ea065014-42a0-4745-a5a3-d45cec05e902', 'bb3387e0-2348-484f-a92b-48f94be1d681', NULL, 1, 1, '4737', false),
	('6da53b88-9305-4465-85b4-d3c5338f3edc', 'f9b4627b-e24a-4056-805b-356f6575423d', NULL, 1, 1, '2914', true),
	('87f9d72e-0f40-4298-91d4-c28eff817fd6', 'f9b4627b-e24a-4056-805b-356f6575423d', NULL, 2, 1, 'SP00172', true),
	('93af5171-e54c-4c7d-8c28-4f004fa8e0dc', '063411f5-f50d-41a3-b17f-777ad4c0a9fd', NULL, 1, 1, '3839', false),
	('925c0993-2b57-47e4-a15d-f64b7cb0d1dd', '063411f5-f50d-41a3-b17f-777ad4c0a9fd', NULL, 2, 1, 'TR01385', false),
	('85779e02-8a5f-46c7-8345-8114fc46d258', '9f8e70f2-d0df-4a07-b823-f76f50011894', NULL, 1, 1, '2055', false),
	('9a5c5b2a-457b-44f2-b8dd-6bb38c92ce61', '9f8e70f2-d0df-4a07-b823-f76f50011894', NULL, 1, 1, '20364', true),
	('d83bffc4-97b2-46e7-8a3f-896f2023513e', '9f8e70f2-d0df-4a07-b823-f76f50011894', NULL, 2, 1, 'TR00009', true),
	('f5270d0c-cffb-4452-a79e-580b5e296d82', 'f1b26597-1fca-4286-a0bb-e7b708248514', NULL, 1, 1, '1337', true),
	('617a3194-b653-44df-90a3-b9f21e3be67e', 'bc85ae83-f01e-4764-993b-67e44a8c0f06', NULL, 1, 1, '2613', true),
	('50aa7d20-d0ac-4bbd-8c36-540dbefc5092', 'bc85ae83-f01e-4764-993b-67e44a8c0f06', NULL, 2, 1, 'SP00099', true),
	('ba2fc27f-3a7b-4c3b-83f1-3014fa131893', '1eb11232-bed2-4aee-953e-4ab901001737', NULL, 1, 1, '3147', true),
	('dadff68f-c5be-4caa-9e98-351faa26602a', '1eb11232-bed2-4aee-953e-4ab901001737', NULL, 2, 1, 'TR00830', true),
	('3d4d4d32-6cef-4d83-b0e5-223e22806602', NULL, '49491bf6-94a2-46cf-8a8d-2cb446fd40ec', 1, 1, '1809', true),
	('4a8bce8a-d295-44ce-96c6-1af860e13d87', NULL, 'a092771d-bfd0-4529-b550-61567cec5c5e', 1, 1, '86052', true);


--
-- Data for Name: organisation_group_member; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.organisation_group_member (organisation_group_member_id, organisation_group_id, establishment_id, joined_date, left_date, is_lead_member) VALUES
	('34f1b2a9-895a-4e97-a5a3-b05ffb490401', '49491bf6-94a2-46cf-8a8d-2cb446fd40ec', '2c455dd1-e9cf-41b0-b443-ccd9b722f3fe', '2011-01-13', NULL, NULL),
	('e369d27a-2daa-440f-9ef8-48dcdc517094', '49491bf6-94a2-46cf-8a8d-2cb446fd40ec', '5f593782-4859-467b-8e11-9900ddd5ce43', '2011-01-13', NULL, NULL),
	('a51d5683-ff67-4102-8cb9-f67fc0e7d4e3', 'a092771d-bfd0-4529-b550-61567cec5c5e', '4d98af90-074e-4a4a-8f06-7e804e23201d', '2016-10-01', NULL, false),
	('bb61cfc4-cf31-4d6a-bc38-7451a04799d0', 'a092771d-bfd0-4529-b550-61567cec5c5e', '2cd15d5d-32d5-4c85-80d0-f60bf98d2256', '2016-10-01', NULL, false),
	('0e7fddfb-6481-47d0-aebb-ca390c8a96ce', 'a092771d-bfd0-4529-b550-61567cec5c5e', '7d1175bd-bfc3-4b29-9cfe-1b19aa2f2602', '2016-10-01', NULL, false),
	('2df40d89-ed01-4add-a645-e842786b5f81', 'a092771d-bfd0-4529-b550-61567cec5c5e', 'f015162d-ae4c-4f05-940d-bfbea4ec86cb', '2016-10-01', NULL, false),
	('13b54ff3-4f03-4cba-aabe-670dc305c6f0', 'a092771d-bfd0-4529-b550-61567cec5c5e', 'a51e2bfa-884c-46e0-9566-5c29016abbda', '2016-10-01', NULL, false),
	('2ad462ec-a76d-4939-b567-c99c37320374', 'a092771d-bfd0-4529-b550-61567cec5c5e', 'ab99c285-111e-4b81-8f28-cc368413aaab', '2016-10-01', NULL, false),
	('07d3ee66-fb76-4ec6-8abb-6b0a45b288e6', 'a092771d-bfd0-4529-b550-61567cec5c5e', 'dcb8c95c-1aa1-411b-b9b4-8571b1f581a1', '2016-10-01', NULL, false),
	('163adb8f-e885-48ff-8f4b-cb63eeabf2f7', 'a092771d-bfd0-4529-b550-61567cec5c5e', 'ef90ef60-7cf4-4fdf-80a2-83e66134d7af', '2016-10-01', NULL, false),
	('d9dfda67-21b1-4983-a6d5-6f3d592c8741', 'a092771d-bfd0-4529-b550-61567cec5c5e', '0e1a85e6-7dc9-4295-ac7b-e2c7c6df8ed8', '2016-10-01', NULL, true);


--
-- Data for Name: organisation_group_member_lead_period; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.organisation_group_member_lead_period (organisation_group_member_lead_period_id, organisation_group_member_id, organisation_group_id, start_date, end_date, is_current) VALUES
	('0e238cf5-ea55-4889-97b3-a8ea7770d07f', 'd9dfda67-21b1-4983-a6d5-6f3d592c8741', 'a092771d-bfd0-4529-b550-61567cec5c5e', NULL, NULL, true);


--
-- Data for Name: organisation_identifier; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.organisation_identifier (organisation_identifier_id, legal_entity_id, organisation_identifier_type_id, value, is_current) VALUES
	('a7f0b5b8-35a5-44dc-bd53-aa546d430711', '244c9b11-50ca-415d-87a2-f4b91eb37e53', 1, '07747126', true),
	('b17a9753-8ab9-42e5-a7f0-b9e17818278f', '244c9b11-50ca-415d-87a2-f4b91eb37e53', 2, '10059286', true),
	('e94b6764-b9fe-4a59-a0ec-ae4db18db02b', 'b723a2f1-a5bf-48b0-9e89-ec7527a998fa', 1, '07158839', true),
	('56caf8b1-40e8-4648-b9b7-6f1fb546e288', 'b723a2f1-a5bf-48b0-9e89-ec7527a998fa', 2, '10061289', true),
	('8376402c-9435-4ea7-92b7-f51743efeac8', 'e165d941-dd82-44ab-ac49-be55ce336bba', 1, '05412502', true),
	('45a6e99f-ceb2-45e7-9ed0-0e2780a0b2f9', 'e165d941-dd82-44ab-ac49-be55ce336bba', 2, '10058191', true),
	('a5c18623-5a6e-462c-808f-5bbeab84543d', 'c66276ea-4de3-48bb-9a7f-613e07f2a615', 1, '06888873', true),
	('d51166a4-ab00-4c81-8b7f-5e101f554370', 'e04b4e21-f792-491b-88ba-c7848ab5cf63', 1, '07795736', true),
	('3b208874-c14f-41c6-b21e-010e209d5e9e', 'e04b4e21-f792-491b-88ba-c7848ab5cf63', 2, '10059335', true),
	('ddc0d262-517c-4af7-9bd6-e37051755e49', '0f3430d8-947f-4fad-b604-e62f783230f7', 1, '06960253', true),
	('b5a0e856-ab71-454c-a20e-c4132df7ff09', '0f3430d8-947f-4fad-b604-e62f783230f7', 2, '10058269', true);


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
	('b20ed1e3-9dfe-46bf-9a46-1c088afd222d', '8d2797fa-ce2e-4e43-91c5-4b331f4bd7f9', 11, 16),
	('4b4c7d6c-c065-4f00-ba51-9998b45e9a0c', 'f66788e7-7bb1-4861-be42-6fa3bb7f88e4', 4, 19),
	('627b865c-54f1-45f0-bbde-7ae5dc3dd648', '59090054-f469-49a2-bc6f-ab00ece96925', 11, 19),
	('b5c79c33-56ae-457f-b6e2-76da4c1acde6', '2db594e0-7229-4ba3-8e06-26a4a123687c', 11, 19),
	('98501432-0eeb-4532-8ac8-cc41a99c02c6', '3d8f95b6-fc84-40f1-9238-3f1b8cca6daf', 5, 11),
	('96c87e92-e485-4e52-99c4-90012c479a41', '48cfbc86-a99b-4408-8f7e-b9e2a41f4aa6', 4, 11),
	('3adadb40-891e-49de-b47f-25e5699c07c5', '15dc9055-a38a-45bd-bb11-bdce93ebfe62', 3, 11),
	('c5a9399e-59f3-4c21-a14b-2701fa13536c', '5fe29953-7282-4377-8ca9-f8bad38c2b5d', 11, 16),
	('4f32f91b-a4c0-436b-9b87-9692a969f1ff', 'bfb89d31-ceca-442d-bd0c-1a06191eccec', 5, 19),
	('7d12a774-6418-4ba5-b86f-906c4860844d', '5b60221a-8a98-45ab-8189-14aa68492c6e', 5, 18);


--
-- PostgreSQL database dump complete
--

\unrestrict bn0BVmdx2aOu1RkgTqzuyxgek7fQNZtiPW1J7wf3HC41CGjUqiVbLLTLf8Acwbo

