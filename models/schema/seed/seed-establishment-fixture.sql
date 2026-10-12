--
-- PostgreSQL database dump
--

\restrict flgJrhQPUKE5GayHQNVmsqQw0r4vWKOIiquvaNzHETx6QLs7p0GoZMaxGLloN2B

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
	('05248c5c-bce4-4819-afb8-95d6304aad86', 'THE CO-OPERATIVE ACADEMIES TRUST', 1, NULL, '2011-08-19', NULL),
	('980686ef-fef1-4cb2-81ba-f9df2b6e4df1', 'THE CO-OPERATIVE ACADEMY OF STOKE ON TRENT', 1, NULL, '2010-02-16', NULL),
	('8e31c85c-f5d5-4986-b65e-c7b729df1f7d', 'The Co-operative Group', NULL, NULL, NULL, NULL),
	('6193bf84-dbf3-4d71-a654-29c2acfdb732', 'HIVE EDUCATION TRUST', 1, NULL, '2005-04-04', NULL),
	('44d6692c-6d24-4dc3-896a-a1362bd4db73', 'Diocese of London', NULL, NULL, NULL, NULL),
	('37bcaf9f-f610-4193-b942-b02ecdc1367b', 'BLACK COUNTRY UTC', 1, NULL, '2011-03-08', NULL),
	('3ecc1d6b-978e-4e6c-b3d6-222db56217da', 'THE ACADEMY @ RIDGEWOOD TRUST', 1, NULL, '2011-10-03', NULL),
	('c9d47bfb-e67a-408d-9adb-8515643aac8d', 'The North Tyneside Learning Trust', NULL, NULL, NULL, NULL),
	('1c8f582a-5dee-4bed-8919-31b2c9781457', 'DUNSTONE EDUCATION TRUST', 1, NULL, '2009-07-13', NULL),
	('5be037f1-12fc-4b40-829c-4135c96fc783', 'Acorn Care and Education Ltd', NULL, NULL, NULL, NULL),
	('87fb0d50-8169-4ac1-b928-61d9bbea878e', 'MARCH 2016 LIMITED', 1, NULL, '2009-04-27', NULL),
	('a0372be4-5176-4293-95cc-324ed49ff1ad', 'Four Oaks Learning Trust For Excellence', NULL, NULL, NULL, NULL),
	('73d09caa-5883-4fdb-b6b4-c4c45d56a221', 'Mr & Mrs Readhead (Partnership)', 12, NULL, NULL, NULL),
	('d5536b33-b3ba-47e6-b8ec-20db8c85f72b', 'EDUCATION SOUTH WEST', 1, NULL, '2010-11-25', NULL),
	('c59c4cdc-01e4-4656-830c-e5f634e3d717', 'TEMPLER ACADEMY SCHOOLS TRUST', 1, NULL, '2011-02-04', NULL),
	('1f4b2ea1-3590-48a6-9eaa-027b9ac942fb', 'THE NORTHAMPTON FREE SCHOOL TRUST', NULL, NULL, NULL, NULL),
	('01f1c31f-c774-47fc-a358-51ba5bc40df3', 'WOOTTON PARK ACADEMY TRUST', 1, NULL, '2013-11-20', NULL),
	('c08b2b23-bf2a-47c8-b2c4-09ebd67525fd', 'OUTWOOD GRANGE ACADEMIES TRUST', 1, NULL, '2009-08-19', NULL),
	('8656f963-c3dd-4a30-a6c6-326ca448884e', 'OASIS COMMUNITY LEARNING', 1, NULL, '2005-03-18', NULL),
	('4edc36ee-fdc5-42e5-9eca-e74483c712f1', 'Trust in Learning', NULL, NULL, NULL, NULL),
	('27546d94-e327-49fd-aecb-26c8c043a597', 'The King''s School', NULL, NULL, NULL, NULL),
	('a4099bbe-ea70-4371-96a2-55be90d5872f', 'THE KING''S SCHOOL', 1, NULL, '2011-07-15', NULL),
	('117294bf-8077-49bd-b36f-9d59ec0d4b43', 'Diocese of Ely', NULL, NULL, NULL, NULL),
	('f1a6af5f-7134-4e63-8562-c4fbb5eaf072', 'GRACE SCHOOLS', 1, NULL, '2013-03-27', NULL);


--
-- Data for Name: academy_trust_classification; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.academy_trust_classification (academy_trust_classification_id, legal_entity_id, academy_trust_type_id, start_date, end_date, is_current) VALUES
	('7d520bad-db0e-4ff2-8fc2-bf8668dfc461', '05248c5c-bce4-4819-afb8-95d6304aad86', 2, NULL, NULL, true),
	('467df28d-d3f2-4859-9952-754b83dcce09', '980686ef-fef1-4cb2-81ba-f9df2b6e4df1', 1, NULL, NULL, false),
	('41718836-547d-4316-b389-5d3395671cc0', '6193bf84-dbf3-4d71-a654-29c2acfdb732', 2, NULL, NULL, true),
	('fee83219-d7ea-4d33-840d-e315f15b4516', '6193bf84-dbf3-4d71-a654-29c2acfdb732', 1, NULL, NULL, false),
	('ed78cae3-a315-4409-977c-3428ce3b1a58', '3ecc1d6b-978e-4e6c-b3d6-222db56217da', 1, NULL, '2021-03-30', false),
	('fbb6441d-9f06-4e93-bdc3-3a0eacf17e10', '3ecc1d6b-978e-4e6c-b3d6-222db56217da', 2, '2021-03-30', NULL, true),
	('8af6bdeb-5644-42a0-85e2-1edc898969a3', '1c8f582a-5dee-4bed-8919-31b2c9781457', 2, NULL, NULL, true),
	('3148b97d-934d-4c70-a548-67d1d129b8e4', 'd5536b33-b3ba-47e6-b8ec-20db8c85f72b', 2, NULL, NULL, true),
	('d1050304-d610-4d03-a0dd-eb26b810bcc3', 'c59c4cdc-01e4-4656-830c-e5f634e3d717', 2, NULL, NULL, true),
	('4854640d-cf86-4ac1-9ddc-d6c4b7931c06', 'c08b2b23-bf2a-47c8-b2c4-09ebd67525fd', 2, NULL, NULL, true),
	('fd0c81c3-85d0-4904-bb72-2f34de998ee0', '8656f963-c3dd-4a30-a6c6-326ca448884e', 2, NULL, NULL, true),
	('3d3728f1-f674-4ebb-ac65-43091e71d351', 'a4099bbe-ea70-4371-96a2-55be90d5872f', 1, NULL, NULL, true),
	('854953ca-928c-442a-88da-1e90ab8535a0', 'f1a6af5f-7134-4e63-8562-c4fbb5eaf072', 2, NULL, NULL, true),
	('5184deac-f6ce-49c2-b3eb-aea6911c3fd3', '37bcaf9f-f610-4193-b942-b02ecdc1367b', 1, NULL, '2015-08-31', false),
	('f1d269a4-3f92-40e2-8bf2-557c8996ec5b', '87fb0d50-8169-4ac1-b928-61d9bbea878e', 2, NULL, '2016-02-29', false),
	('f7d7e63c-7078-42cd-a0fb-5b29125803c9', '01f1c31f-c774-47fc-a358-51ba5bc40df3', 1, NULL, NULL, true),
	('926f33dd-62e5-48a8-abbd-080b48cb81be', '1f4b2ea1-3590-48a6-9eaa-027b9ac942fb', 2, '2018-10-09', '2019-07-09', false),
	('62659430-74ba-4e76-8f46-c86fab40652a', '1f4b2ea1-3590-48a6-9eaa-027b9ac942fb', 1, NULL, '2018-10-09', false);


--
-- Data for Name: address; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.address (address_id, address_line_1, address_line_2, address_line_3, town, county, postcode) VALUES
	('b271abbd-5ca7-4039-9e08-4f4d6c8e991b', 'obfuscated', NULL, 'obfuscated', 'obfuscated', '032', 'ST6 4LD'),
	('df9ab569-7f02-40b4-9c32-81c172c28531', 'obfuscated', 'Islington', NULL, 'obfuscated', '099', 'N7 8PG'),
	('50ba5830-d684-457b-ad84-bcee6b06c1a7', 'obfuscated', 'Scawsby', NULL, 'obfuscated', '031', 'DN5 7UB'),
	('63c4cfd7-38f8-4a7d-91aa-196542f34980', 'obfuscated', 'Upper Dean', NULL, 'obfuscated', '003', 'PE28 0ND'),
	('6e22b61a-16cd-4e62-ba24-9d4ef5b980d2', 'obfuscated', 'Milton Ernest', NULL, 'obfuscated', '001', 'MK44 1RF'),
	('3f1ff810-30d9-489c-8ed0-b9dbb2f190bc', 'obfuscated', 'School Way', 'obfuscated', 'obfuscated', '012', 'SS9 4HX'),
	('696d776f-cc70-4d80-8ee7-de70b303d8b6', 'obfuscated', NULL, NULL, 'obfuscated', '012', 'SS1 1ES'),
	('741b744b-c95f-452c-9202-d825592434d0', NULL, 'Centre Place', 'obfuscated', 'obfuscated', '012', 'SS1 2JD'),
	('d53bc482-53cd-4df4-9263-8537a6e8388f', 'obfuscated', 'Hamstel Road', NULL, 'obfuscated', '012', 'SS2 4PQ'),
	('fb43e080-6b19-4ff3-bb6b-ed5bb76ba4a1', 'obfuscated', NULL, NULL, 'obfuscated', '012', 'SS0 0LG'),
	('15604187-4663-494a-aa08-5839a7f0bac2', 'obfuscated', 'Constable Way', NULL, 'obfuscated', '012', 'SS3 9XX'),
	('5336cce0-308e-464c-9864-d7bba7016697', 'obfuscated', NULL, NULL, 'obfuscated', '012', 'SS0 7AU'),
	('223cb4ff-a9e7-4fef-be05-17663e2597c6', 'obfuscated', 'Rayleigh Road', 'obfuscated', 'obfuscated', '012', 'SS9 5UT'),
	('8a0d116e-3410-401e-a343-944236cb5f66', 'obfuscated', 'Eastern Avenue', NULL, 'obfuscated', '012', 'SS2 4BA'),
	('51877581-2e21-4678-8709-f9c20fa5c8c2', 'obfuscated', NULL, NULL, 'obfuscated', '035', 'NE28 9RT'),
	('c0e0c252-1b02-4ee9-b3eb-a8e6faef147d', 'obfuscated', NULL, 'obfuscated', 'obfuscated', '019', 'PR2 9YR'),
	('4088a420-3998-4971-9fbd-58fe90b42eca', 'Kirkby Lonsdale', NULL, NULL, 'Carnforth', '019', 'LA6 2DZ'),
	('c818ee9f-fa55-4a86-9dfd-ed088c3be6be', 'Egerton Road', 'Charing Heath', NULL, 'Ashford', '018', 'TN27 0AX'),
	('2fe63b30-0a10-4700-b790-5d72bc16d42e', 'obfuscated', 'Kingsteignton', NULL, 'obfuscated', '008', 'TQ12 3JG'),
	('b6bfeb1c-7df7-455e-b913-9b588c127737', 'obfuscated', 'Outwood', NULL, 'O6kryuf7yc6', '039', 'WF1 2PF'),
	('0a0a25a9-f44b-49e5-9738-507122da9891', NULL, NULL, NULL, NULL, NULL, NULL),
	('c3b79e69-6786-4aae-8f52-803459e6950a', 'obfuscated', 'Innova Park', NULL, 'obfuscated', '058', 'EN3 7XH'),
	('766ed9d0-e2e6-4128-be2b-00f02a561040', 'obfuscated', 'Teyfant Road', 'obfuscated', 'obfuscated', '099', 'BS13 0RG'),
	('98a82a5e-72d6-40ef-b2d6-a89062eee97e', 'obfuscated', NULL, NULL, 'obfuscated', '021', 'NG31 6RP'),
	('d8e23aad-ea8b-4423-a4ba-326a48147c5e', 'Pitt Street', NULL, NULL, 'Gloucester', '013', 'GL1 2BG'),
	('d0a37cb3-14bd-417c-9a4a-4ed9148e4059', 'obfuscated', 'Bury', NULL, 'obfuscated', '003', 'PE26 2NJ'),
	('83282b82-318c-4676-bd82-a02aed2d56a8', 'obfuscated', NULL, NULL, 'obfuscated', '037', 'WS3 2PA'),
	('d4113f70-1f77-4713-bd0e-cae38a38dcd3', 'obfuscated', NULL, NULL, 'obfuscated', '099', 'NN4 0JA'),
	('c4a28252-8758-49c1-bf61-67fd3c48c25d', 'obfuscated', 'Blackley', NULL, 'obfuscated', '099', 'M9 7SS'),
	('9f641fa7-9d2f-4308-8bb1-bd764bc96637', 'obfuscated', NULL, NULL, 'obfuscated', '037', 'B75 6TJ'),
	('484ff988-e2d9-4baa-932e-e93fe7b1d27c', 'obfuscated', NULL, NULL, 'obfuscated', '034', 'CR2 6DF'),
	('073fa6e0-617b-40a5-89e4-0cafb844f418', 'obfuscated', 'Roundshaw', NULL, 'obfuscated', '034', 'SM6 9HY'),
	('5b10d5cc-dd05-4c50-9d34-8bfaa660732e', 'obfuscated', 'Roundshaw', NULL, 'obfuscated', '034', 'SM6 9HY'),
	('6d13d9ae-5836-4810-b209-0ee05cd767df', 'obfuscated', NULL, NULL, 'obfuscated', '058', 'EN3 5PA'),
	('e4239574-6886-43b4-a74b-80ca0aa397fe', 'obfuscated', NULL, NULL, 'obfuscated', '058', 'EN1 4JY'),
	('d807594c-1a89-4f8e-ae30-8d1c30ba6088', 'obfuscated', 'New Southgate', NULL, 'obfuscated', '000', 'N11 1RR'),
	('40788d62-a5fa-485a-bdd4-dbc8242c1517', 'obfuscated', 'Edmonton', NULL, 'obfuscated', '000', 'N9 9TT'),
	('cf146daa-a92f-4782-a8e1-f418cdcbdd99', 'obfuscated', 'Hazelwood School', 'obfuscated', 'obfuscated', '058', 'N13 5HE'),
	('ed93cdb0-bb28-4e85-aa22-e9e30db43116', 'obfuscated', 'Enfield', NULL, 'obfuscated', '058', 'EN1 4RE'),
	('056aca12-1498-4c54-beb9-c2c9bf3cac1e', 'obfuscated', NULL, NULL, 'obfuscated', '000', 'EN3 6HG'),
	('0fdedd1c-be52-4881-9a06-0142cf64e36e', 'WESTWARD HO', 'LEISTON', 'SUFFOLK', 'Leiston', '033', 'IP16 4HY'),
	('fdf88c8d-831c-4ae7-9378-d183f087d931', '1 Angel Square', NULL, NULL, 'Manchester', NULL, 'M60 0AG');


--
-- Data for Name: establishment; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment (establishment_id, urn, ukprn, establishment_number, name, establishment_type_id, education_phase_id) VALUES
	('4e29ed4f-3418-4b36-822f-0e94aacdf08c', 136102, 10030216, 6905, 'The Co-Operative Academy of Stoke-On-Trent', 4, 5),
	('1ef65a39-891a-4ad2-a2c6-bccd3a5f13a6', 134314, 10024207, 6905, 'St Mary Magdalene Academy', 4, 6),
	('7aa926f6-ce2e-4247-812a-c689240cac54', 137603, 10035482, 4033, 'Ridgewood School', 4, 5),
	('75cd413e-73ca-4b6a-87b7-dbbb4ffa485c', 109443, 10077509, 2036, 'Eileen Wade Primary School', 11, 2),
	('a3d0478b-2257-4078-b3de-ce8ca0f1f09b', 109613, 10075753, 3023, 'Milton Ernest CofE Primary School', 10, 2),
	('ef9a8b00-2708-41df-acc9-fc5c675f8fb7', 20338, NULL, NULL, 'Blenheim Children''s Centre', 35, 8),
	('b1ae776f-2bcc-4237-83dd-7fdc843f582b', 20549, NULL, NULL, 'Cambridge Road Children''s Centre', 35, 8),
	('9bb810af-c7e0-48a0-b936-5843a69f2c64', 20614, NULL, NULL, 'Centre Place Family Centre', 35, 8),
	('97ca1988-6de7-4674-8482-5a5baa4c2203', 21363, NULL, NULL, 'Hamstel Children and Family Centre', 35, 8),
	('b54bbd98-8ea9-4cca-87ba-c4e34539b6c6', 22422, NULL, NULL, 'Prince Avenue Children and Family Centre', 35, 8),
	('744f18b2-51b2-4525-9d1a-5990dfe9598a', 22459, NULL, NULL, 'Friars Children''s Centre', 35, 8),
	('f98ddfa7-6ee9-4e85-b97d-30acf38f92e0', 22975, NULL, NULL, 'Summercourt Children''s Centre', 35, 8),
	('1400713f-fd61-470b-a9bc-1428d8228a22', 23004, NULL, NULL, 'Eastwood Children''s Centre', 35, 8),
	('70758a6c-5970-4782-93bc-e7b03242129e', 23122, NULL, NULL, 'Temple Sutton Children''s Centre', 35, 8),
	('d0ea1f2c-baec-438a-801d-014bc4535392', 132141, 10073628, 2087, 'Hadrian Park Primary School', 11, 2),
	('a8b92a45-0527-4d96-a447-655794f07d46', 135936, 10027711, 6906, 'Fulwood Academy', 4, 5),
	('82243d05-e27c-481c-8646-cd23d6e1156c', 112461, 10015990, 6044, 'Underley Garden School', 15, 8),
	('b1c2ad38-5969-4c5d-82e8-958dff480969', 119009, 10015772, 6060, 'Heath Farm School', 15, 8),
	('29127bbf-da06-42e5-98c3-dc0ad5947fd4', 136494, 10033036, 5402, 'Teign School', 4, 5),
	('9483d5ac-be47-4590-ae47-ed94186bd376', 135961, 10028145, 6905, 'Outwood Grange Academy', 4, 5),
	('b1dc31f6-b63a-4d1c-a6d4-fec41aa9c0ef', 148341, 10092329, 6003, 'Outwood Alternative Provision Eston', 17, 8),
	('6db6ce3a-5540-41c5-9c78-cfb576c5b061', 134311, 10021087, 6905, 'Oasis Academy Enfield', 4, 5),
	('7a9d3fea-1169-4319-bcb3-2637c11b13d2', 109393, 10016445, 7014, 'New Fosseway School', 3, 8),
	('e21d23b0-23a3-4e28-89e5-12c0059818d2', 137166, 10034779, 5402, 'The King''s School Grantham', 4, 5),
	('98130685-8a80-4e6b-839d-e81da8e66baa', 115780, 10003659, 6003, 'The King''s School, Gloucester', 17, 8),
	('13d1b8b6-c6a8-47c1-959e-bcb9d27fc3f9', 139844, 10042228, 3367, 'Bury CofE Primary School', 4, 2),
	('4d3f1d5d-59ac-40be-bb40-32f09eafe6b8', 136933, NULL, 4000, 'Black Country UTC', 21, 5),
	('5d30cf6f-49cf-42c8-88b8-1ab720bf0dda', 135905, NULL, 6910, 'Manchester Creative and Media Academy', 4, 5),
	('fdea59a7-6537-43f2-a5c1-fb83bab3a498', 103630, 10077032, 7060, 'Langley School', 3, 8),
	('419a482b-1722-4adb-85af-fdcd9d9640f8', 101800, 10071655, 3408, 'Regina Coeli Catholic Primary School', 9, 2),
	('f62c29b5-f955-45ae-bc39-2a347bbfa582', 102996, 10079489, 3503, 'St Elphege''s RC Junior School', 9, 2),
	('998775ca-c521-4df1-8cf6-5304b20b5a5e', 102997, 10078365, 3504, 'St Elphege''s RC Infants'' School', 9, 2),
	('62edb636-34fa-4856-99ca-d06f7ae8354d', 20048, NULL, NULL, 'Carterhatch Bell Lane Children''s Centre', 35, 8),
	('82d29ae9-0f77-4ee6-a8de-6a9521cec0f3', 20575, NULL, NULL, 'Carterhatch Autumn Close Children''s Centre', 35, 8),
	('948a2896-62e2-4546-b5b8-59b422350235', 21240, NULL, NULL, 'Bowes and Garfield Children''s Centre', 35, 8),
	('bb92723a-335c-454b-9a95-def4cc4a6820', 21423, NULL, NULL, 'Hazelbury Children''s Centre', 35, 8),
	('4144d29e-6d62-4bf6-aa6f-3e7bdc376da2', 21425, NULL, NULL, 'Hazelwood Children''s Centre', 35, 8),
	('923af34d-8cbb-45f8-80f5-513314a15cdf', 21547, NULL, NULL, 'Honilands Children''s Centre', 35, 8),
	('925bb411-89bd-4d51-ba94-dc3af0ed1de5', 22423, NULL, NULL, 'Prince of Wales Childrens Centre', 35, 8),
	('147a02bd-e737-4d3b-94c0-c2185db187bc', 124870, 10017679, 6016, 'Summerhill School', 17, 8),
	('bbd5f265-3f34-426f-b2b2-f5eefa753d0f', 142869, 10056995, 4020, 'Wootton Park School', 30, 6);


--
-- Data for Name: capacity_and_pupil_measures; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.capacity_and_pupil_measures (capacity_and_pupil_measures_id, establishment_id, school_capacity, pupil_count, free_school_meal_measure, census_date) VALUES
	('1efbfb8f-71e5-4579-a70b-3a834437c7b6', '4e29ed4f-3418-4b36-822f-0e94aacdf08c', 1050, 1300, 735, NULL),
	('ce860ac0-e21d-428f-9783-277d2f874f85', '1ef65a39-891a-4ad2-a2c6-bccd3a5f13a6', 1310, 1561, 465, NULL),
	('886e5394-b4e8-4ffe-acf7-42458911b509', '7aa926f6-ce2e-4247-812a-c689240cac54', 1512, 1425, 250, NULL),
	('65f5e931-4b06-468d-9b3a-85e3afccf05c', '75cd413e-73ca-4b6a-87b7-dbbb4ffa485c', 23610, 70, 10, NULL),
	('bf9dc1e6-278f-44c4-96c6-72588f1068ad', 'a3d0478b-2257-4078-b3de-ce8ca0f1f09b', 63964, 67, 5, NULL),
	('19fabaa6-d121-4047-8788-2265bc090335', 'd0ea1f2c-baec-438a-801d-014bc4535392', 965, 422, 114, NULL),
	('4fb18d44-ea30-4ec9-8bc3-3c0df22737fe', 'a8b92a45-0527-4d96-a447-655794f07d46', 1000, 973, 418, NULL),
	('f1d98883-d901-44d2-b756-bc3e2b4525f7', '82243d05-e27c-481c-8646-cd23d6e1156c', 84881, 101, NULL, NULL),
	('0d0e37d1-cfb0-4158-86fe-2d32a7b89fc3', 'b1c2ad38-5969-4c5d-82e8-958dff480969', 20643, 141, NULL, NULL),
	('7b43e046-f071-49e1-88c7-f861514a7bc8', '29127bbf-da06-42e5-98c3-dc0ad5947fd4', 1353, 1111, 220, NULL),
	('312e85dd-ca35-44ef-bc01-0b75275036f5', '9483d5ac-be47-4590-ae47-ed94186bd376', 2200, 1900, 309, NULL),
	('a15c7677-3b14-4b81-bca2-a003556e2295', '6db6ce3a-5540-41c5-9c78-cfb576c5b061', 1150, 690, 359, NULL),
	('c2df866f-3486-427c-9104-edd8efacdcb2', '7a9d3fea-1169-4319-bcb3-2637c11b13d2', 62041, 142, 73, NULL),
	('99e8bcb6-e657-4450-8f37-b8d49903479d', 'e21d23b0-23a3-4e28-89e5-12c0059818d2', 1086, 1221, 68, NULL),
	('4990f0d6-efb9-4be7-95ef-41d14493270f', '98130685-8a80-4e6b-839d-e81da8e66baa', 73290, 709, NULL, NULL),
	('b549219a-69ee-4107-8a97-3d83e6041152', '13d1b8b6-c6a8-47c1-959e-bcb9d27fc3f9', 210, 207, 30, NULL),
	('4d4edf01-356a-41b1-99ea-3001d7210857', '4d3f1d5d-59ac-40be-bb40-32f09eafe6b8', 480, NULL, NULL, NULL),
	('078c97f8-0870-47d1-b3f9-818e3053fa28', '5d30cf6f-49cf-42c8-88b8-1ab720bf0dda', 660, NULL, NULL, NULL),
	('73f7a208-a1cc-4f16-84fc-1c24a6eedc7c', 'fdea59a7-6537-43f2-a5c1-fb83bab3a498', 51694, 137, 81, NULL),
	('7cac34f9-fcd5-4481-a719-4bf5f61660a1', '419a482b-1722-4adb-85af-fdcd9d9640f8', 1357, 382, 96, NULL),
	('3496bb50-8e1f-4eeb-bd26-95f42d435bbd', 'f62c29b5-f955-45ae-bc39-2a347bbfa582', 37309, 382, 77, NULL),
	('b892956c-5541-4728-99a7-48656733074c', '998775ca-c521-4df1-8cf6-5304b20b5a5e', 5534, 321, 43, NULL),
	('7ad5297f-1bbb-466b-8e92-b7c881e99d6f', '147a02bd-e737-4d3b-94c0-c2185db187bc', 51776, 51, NULL, NULL),
	('29cf1c39-e717-4a22-90a2-ebb16c97a879', 'bbd5f265-3f34-426f-b2b2-f5eefa753d0f', 1290, 1670, 131, NULL);


--
-- Data for Name: data_correction_audit; Type: TABLE DATA; Schema: establishment; Owner: -
--



--
-- Data for Name: education_admissions_and_provision; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.education_admissions_and_provision (education_admissions_and_provision_id, establishment_id, gender_of_entry_type_id, admissions_policy_id, boarding_provision_id, nursery_provision_id, sixth_form_provision_id) VALUES
	('2df98956-98dd-4035-a83e-7a9803203809', '4e29ed4f-3418-4b36-822f-0e94aacdf08c', 1, 1, 1, 3, 3),
	('0ee70364-63a0-420b-8474-4485708f49e4', '1ef65a39-891a-4ad2-a2c6-bccd3a5f13a6', 1, 1, 1, 2, 1),
	('ca8731e7-a16a-4c83-ba2f-dbb7d2331e14', '7aa926f6-ce2e-4247-812a-c689240cac54', 1, 1, 1, 3, 1),
	('98933169-56e7-4729-a815-513351060c01', '75cd413e-73ca-4b6a-87b7-dbbb4ffa485c', 1, 3, 1, 2, 2),
	('9c1b3c7f-d88c-43df-b1af-8598e45c8a90', 'a3d0478b-2257-4078-b3de-ce8ca0f1f09b', 1, 3, 1, 2, 2),
	('82d2af2c-b025-4e04-99cd-44e1cefd5c32', 'ef9a8b00-2708-41df-acc9-fc5c675f8fb7', NULL, 3, NULL, 3, 3),
	('d45505b4-670e-4b18-b047-a1dfac470966', 'b1ae776f-2bcc-4237-83dd-7fdc843f582b', NULL, 3, NULL, 3, 3),
	('7e93bb0c-583c-4013-9a16-2b7e38f5fa69', '9bb810af-c7e0-48a0-b936-5843a69f2c64', NULL, 3, NULL, 3, 3),
	('f2f595c7-9623-438a-8085-28d8a5ba9df4', '97ca1988-6de7-4674-8482-5a5baa4c2203', NULL, 3, NULL, 3, 3),
	('e66ea270-d7bb-47f9-bdc1-0fd650c60161', 'b54bbd98-8ea9-4cca-87ba-c4e34539b6c6', NULL, 3, NULL, 3, 3),
	('65238fec-e1fb-499c-aa62-99dfdf96d907', '744f18b2-51b2-4525-9d1a-5990dfe9598a', NULL, 3, NULL, 3, 3),
	('f5d3ebbc-47e1-4f32-9207-e500589f0ac8', 'f98ddfa7-6ee9-4e85-b97d-30acf38f92e0', NULL, 3, NULL, 3, 3),
	('c586080e-5e3d-439a-81b8-1136b6c91c6f', '1400713f-fd61-470b-a9bc-1428d8228a22', NULL, 3, NULL, 3, 3),
	('93fc7d67-e230-4cca-af33-799ec4fcc65c', '70758a6c-5970-4782-93bc-e7b03242129e', NULL, 3, NULL, 3, 3),
	('ffb9e5f1-44d9-4c6c-94e1-ad65e6612e69', 'd0ea1f2c-baec-438a-801d-014bc4535392', 1, 3, 1, 1, 2),
	('4a9cc2f8-1b16-43cf-8da3-97acad4c84ff', 'a8b92a45-0527-4d96-a447-655794f07d46', 1, 1, 1, 3, 2),
	('9bc925d3-9a9d-416e-826f-afab3916c0e7', '82243d05-e27c-481c-8646-cd23d6e1156c', 1, 2, 3, 3, 1),
	('330b7001-22b1-4326-9d18-9e08378230ed', 'b1c2ad38-5969-4c5d-82e8-958dff480969', 1, NULL, 1, 2, 1),
	('edc5b783-ee89-4e55-9f33-39385867638b', '29127bbf-da06-42e5-98c3-dc0ad5947fd4', 1, 1, 1, 3, 1),
	('873cb24e-668e-4770-88d5-1841b16dd0d7', '9483d5ac-be47-4590-ae47-ed94186bd376', 1, 1, 1, 3, 1),
	('15c144c1-0eb5-447e-9507-5d6d180d34fe', 'b1dc31f6-b63a-4d1c-a6d4-fec41aa9c0ef', NULL, NULL, NULL, NULL, NULL),
	('4b3e3325-2e3b-4769-9b3f-b6a51e2fb262', '6db6ce3a-5540-41c5-9c78-cfb576c5b061', 1, 1, 1, 3, 1),
	('188e3d1b-ac8d-4a5a-ae11-2afe02f094c8', '7a9d3fea-1169-4319-bcb3-2637c11b13d2', 1, 3, 1, 3, 1),
	('ad9d05c6-4f00-4b4c-8994-b90738aedb69', 'e21d23b0-23a3-4e28-89e5-12c0059818d2', 2, 2, 1, 3, 1),
	('646c9c1b-8ded-4403-a2e7-f15b597d5752', '98130685-8a80-4e6b-839d-e81da8e66baa', 1, NULL, 1, 1, 1),
	('4d99a32f-c9ca-4829-a7e7-8f95ea70f085', '13d1b8b6-c6a8-47c1-959e-bcb9d27fc3f9', 1, 3, 1, 2, 2),
	('a5741da6-c7e0-4855-90c3-755d1b2b87d3', '4d3f1d5d-59ac-40be-bb40-32f09eafe6b8', 1, 1, 1, 3, 1),
	('dd493941-f518-4794-9646-6fd4e405fe58', '5d30cf6f-49cf-42c8-88b8-1ab720bf0dda', 1, 1, 1, 3, 1),
	('1e68a170-d53a-4c13-a42b-f795ca20a25e', 'fdea59a7-6537-43f2-a5c1-fb83bab3a498', 1, 3, 1, 1, 3),
	('c264083f-9f9a-413e-b7ca-9027344d9a22', '419a482b-1722-4adb-85af-fdcd9d9640f8', 1, 3, 1, 2, 2),
	('8dac98aa-6528-4d05-9e4d-e6b9c1e45ea6', 'f62c29b5-f955-45ae-bc39-2a347bbfa582', 1, 3, 1, 2, 2),
	('7dc4ff2b-809b-48ae-8533-41a8e692b0f1', '998775ca-c521-4df1-8cf6-5304b20b5a5e', 1, 3, 1, 1, 2),
	('37506447-c8fa-4c80-8835-976fabe35b5e', '62edb636-34fa-4856-99ca-d06f7ae8354d', NULL, 3, NULL, 3, 3),
	('15ff8f30-546f-40da-80b8-3359ee499d79', '82d29ae9-0f77-4ee6-a8de-6a9521cec0f3', NULL, 3, NULL, 3, 3),
	('a7946d94-4052-4dc8-9351-ee94a0193f62', '948a2896-62e2-4546-b5b8-59b422350235', NULL, 3, NULL, 3, 3),
	('28f9994f-dbed-4f25-9f03-9f791e4f0629', 'bb92723a-335c-454b-9a95-def4cc4a6820', NULL, 3, NULL, 3, 3),
	('33c2224a-1202-4322-825f-cf8211958922', '4144d29e-6d62-4bf6-aa6f-3e7bdc376da2', NULL, 3, NULL, 3, 3),
	('720c07d0-8cbe-467d-9098-42334dd7375d', '923af34d-8cbb-45f8-80f5-513314a15cdf', NULL, 3, NULL, 3, 3),
	('b63443ce-de19-493d-b23d-e0a37a0caaab', '925bb411-89bd-4d51-ba94-dc3af0ed1de5', NULL, 3, NULL, 3, 3),
	('689541c3-3098-4608-96ef-6ff757eecc0e', '147a02bd-e737-4d3b-94c0-c2185db187bc', 1, 1, 3, 2, 1),
	('72c1eaa3-be5c-4c3f-a3b6-794e7eaef747', 'bbd5f265-3f34-426f-b2b2-f5eefa753d0f', 1, 1, 1, 2, 1);


--
-- Data for Name: establishment_contact; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_contact (establishment_contact_id, establishment_id, website, telephone_number) VALUES
	('bf035690-93eb-462b-9651-518be66c258e', '4e29ed4f-3418-4b36-822f-0e94aacdf08c', 'http://www.cas.coop', '111111'),
	('34dcd33c-1db5-45b1-a505-8a0cd5d8ae9e', '1ef65a39-891a-4ad2-a2c6-bccd3a5f13a6', 'www.smmacademy.org', '111111'),
	('701313f5-84dd-4911-a671-d8b3d955ed7b', '7aa926f6-ce2e-4247-812a-c689240cac54', 'http://www.ridgewoodschool.co.uk', '111111'),
	('9b790aba-dd88-4418-8110-fff2fa0a885d', '75cd413e-73ca-4b6a-87b7-dbbb4ffa485c', 'www.ewmeschools.org.uk', '111111'),
	('6a34fed5-2221-416f-9173-30b2bd54c4fc', 'a3d0478b-2257-4078-b3de-ce8ca0f1f09b', 'www.ewmeschools.org.uk', '111111'),
	('b77ea02f-9fbd-46fb-8ad1-cf38dd988f7e', 'ef9a8b00-2708-41df-acc9-fc5c675f8fb7', NULL, '111111'),
	('5f2311f0-ed5d-4aa6-922e-114ed202da7b', 'b1ae776f-2bcc-4237-83dd-7fdc843f582b', NULL, '111111'),
	('4a518434-7883-4d7f-b6b7-f71e1214f794', '9bb810af-c7e0-48a0-b936-5843a69f2c64', NULL, '111111'),
	('948e511b-dbe7-47bb-b7be-f61f51d2639e', '97ca1988-6de7-4674-8482-5a5baa4c2203', NULL, '111111'),
	('edaf0629-99eb-4820-95ea-92a67723bd28', 'b54bbd98-8ea9-4cca-87ba-c4e34539b6c6', NULL, '111111'),
	('a7c59bef-bcb1-4bbd-ae4d-4f8a5c1ec2e6', '744f18b2-51b2-4525-9d1a-5990dfe9598a', NULL, '111111'),
	('e6a2076d-eb2b-4dcd-9464-194a18cca9cd', 'f98ddfa7-6ee9-4e85-b97d-30acf38f92e0', NULL, '111111'),
	('736cc761-70ba-4dc7-bfdc-cbab5785a886', '1400713f-fd61-470b-a9bc-1428d8228a22', NULL, '111111'),
	('6520be5d-cae3-483e-8df0-ee2581b2c331', '70758a6c-5970-4782-93bc-e7b03242129e', NULL, '111111'),
	('6c18e441-2dca-491f-8f2f-2a3b1842280c', 'd0ea1f2c-baec-438a-801d-014bc4535392', 'www.hadrianparkprimary.org.uk/', '111111'),
	('9af9621d-7a2a-47c7-b865-8c0f4b29e2bb', 'a8b92a45-0527-4d96-a447-655794f07d46', 'http://www.fulwoodacademy.co.uk/', '111111'),
	('1b2e578e-a1bb-49b3-9d83-126f85c9b27b', '82243d05-e27c-481c-8646-cd23d6e1156c', 'www.underleygarden.org', '111111'),
	('be14e23f-3e70-4129-8930-bc30057e4186', 'b1c2ad38-5969-4c5d-82e8-958dff480969', NULL, '111111'),
	('8195f7ba-1bb2-4ec2-9e0a-2523f676dc02', '29127bbf-da06-42e5-98c3-dc0ad5947fd4', 'www.teignacademy.co.uk', '111111'),
	('026d3e9c-cfee-468f-b70a-3b19c030c386', '9483d5ac-be47-4590-ae47-ed94186bd376', 'http://www.grange.outwood.com/', '111111'),
	('81c7181d-65eb-4837-98e5-50216aa0b2a5', '6db6ce3a-5540-41c5-9c78-cfb576c5b061', 'www.oasisacademyenfield.org', '111111'),
	('08afaaf0-35c5-41f3-887c-7224c33dc097', '7a9d3fea-1169-4319-bcb3-2637c11b13d2', 'www.newfossewayschool.co.uk', '111111'),
	('b21ab514-24a3-46dc-ad8b-f89614962011', 'e21d23b0-23a3-4e28-89e5-12c0059818d2', 'http://www.kings.lincs.sch.uk', '111111'),
	('a38673d2-829d-4517-a085-825ecf4e40c5', '98130685-8a80-4e6b-839d-e81da8e66baa', 'www.thekingsschool.co.uk', '111111'),
	('5de71177-8502-43d9-9c20-4cf6b5b04edc', '13d1b8b6-c6a8-47c1-959e-bcb9d27fc3f9', 'http://www.bury.cambs.sch.uk', '111111'),
	('67a56f03-4fca-4587-b6a5-214fe12f9cb4', '419a482b-1722-4adb-85af-fdcd9d9640f8', 'www.reginacoelischool.co.uk', '111111'),
	('a0cc8465-9cd6-4884-917f-653911cd73b3', 'f62c29b5-f955-45ae-bc39-2a347bbfa582', 'www.stelphege.org.uk/', '111111'),
	('c6cb3205-b5f0-443c-a6da-a4376f5913c3', '998775ca-c521-4df1-8cf6-5304b20b5a5e', 'www.stelphegesrcschool.org.uk', '111111'),
	('ad4ee2b3-b718-436e-b7c1-36989d5b39f2', '62edb636-34fa-4856-99ca-d06f7ae8354d', NULL, '111111'),
	('9450c6d9-8d95-4783-9cfc-59fdce56434a', '82d29ae9-0f77-4ee6-a8de-6a9521cec0f3', NULL, '111111'),
	('57c43984-45c8-4172-99c8-0d78d35db6df', '948a2896-62e2-4546-b5b8-59b422350235', NULL, '111111'),
	('82b6dcbe-a6b4-4cee-91ea-a82eb9f4959e', 'bb92723a-335c-454b-9a95-def4cc4a6820', NULL, '111111'),
	('9c78a673-5b73-4294-8ed1-bb07dece68b0', '4144d29e-6d62-4bf6-aa6f-3e7bdc376da2', NULL, '111111'),
	('201aceee-3a3e-4002-9b78-edb95b32eedf', '923af34d-8cbb-45f8-80f5-513314a15cdf', NULL, '111111'),
	('f6e924eb-36c4-4aaa-9340-fd111f344d28', '925bb411-89bd-4d51-ba94-dc3af0ed1de5', NULL, '111111'),
	('09bf49e6-018b-4555-8b69-948df1dc8c15', '147a02bd-e737-4d3b-94c0-c2185db187bc', 'www.summerhillschool.co.uk', '111111'),
	('5ff1e14f-be20-4e4c-afbb-98d28b32b266', 'bbd5f265-3f34-426f-b2b2-f5eefa753d0f', 'www.woottonparkschool.org.uk', '111111');


--
-- Data for Name: establishment_geography; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_geography (establishment_geography_id, establishment_id, local_authority_id, government_office_region_id, district_administrative_id, administrative_ward_id, parliamentary_constituency_id, lsoa_id, msoa_id, urban_rural_id) VALUES
	('e1fd4325-18e6-4790-a0e5-25cb637c74a6', '4e29ed4f-3418-4b36-822f-0e94aacdf08c', '3332ea83-bcbe-48d1-970d-a3650d9bcf10', '7ca695f4-dfcd-4f78-bdaf-17861eafbf97', '6ef1f577-d0bc-4698-951c-f202f9eaada6', 'e73f0fc2-114a-4772-a84e-5363b02ba34b', '714fb4a2-4d2e-4875-9853-1d7d6696559e', 'cec78739-d3a7-4831-9934-8dec5c5bdcd1', '5ed6445f-c41a-4778-9a5c-55ba74a2155b', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('7a996a3b-696b-4557-ab0c-baec7c9287f3', '1ef65a39-891a-4ad2-a2c6-bccd3a5f13a6', '3574e75c-8870-449a-82e7-1b083e2efc42', '1375841f-e6ba-4cda-9fac-753ff9df93a2', '9a5cfcfa-3605-4253-8e1c-fc081510a4ea', '9a2f2163-03c6-45b8-84e0-b34cc7a3450c', '6c7acd08-ad7f-406e-85e4-0bade3e57de6', '05aa5060-26b4-4edf-ad40-5e4640903d5a', '0d87ce8f-019d-4403-9527-975bbabd10e1', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('2b75f259-4120-4fab-b935-3642dd12bc07', '7aa926f6-ce2e-4247-812a-c689240cac54', '77b9cfe6-842e-41c8-9be4-410cac32719a', 'f5cdf1f1-5f75-4420-b597-862614e13549', '05471fcf-d815-4c82-a7f6-6a9ff75cdaa2', 'cf41c2bc-c0cc-4394-992e-1db6d9f032dd', '8d116d07-483e-41bc-83ea-00c89c3f3a6d', 'c4402a6f-a614-4961-a889-554ef686642a', '011465c5-0d85-498d-8b85-14ea8833c9d5', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('e60a74fa-4a37-4210-8a1a-133e3f3d8184', '75cd413e-73ca-4b6a-87b7-dbbb4ffa485c', '942f0927-84a7-43b6-8be9-68f88917b043', '32e46d74-0ebf-495b-8261-2c508cd2c2bb', '1146af1e-822e-49f1-a51e-da31f849045c', 'f08ea39d-20ae-4f5e-8274-15207e7b5eec', 'd180f323-3f6f-44dc-a1de-d1cac6e11c0c', '84494da7-5525-4dc5-a454-83a2b9b7bdc0', 'bc444798-7011-43c1-a1e2-269efd7885ef', '1c041cb3-373a-4dd5-9af4-2950293776bc'),
	('5c93fc49-20ff-4505-97a2-3164e9df2432', 'a3d0478b-2257-4078-b3de-ce8ca0f1f09b', '942f0927-84a7-43b6-8be9-68f88917b043', '32e46d74-0ebf-495b-8261-2c508cd2c2bb', '1146af1e-822e-49f1-a51e-da31f849045c', 'f08ea39d-20ae-4f5e-8274-15207e7b5eec', 'd180f323-3f6f-44dc-a1de-d1cac6e11c0c', '534b5a89-c075-4962-8367-8c8ffc158b9e', 'edc1ad99-4391-4d91-8717-6c10929ae180', '1c041cb3-373a-4dd5-9af4-2950293776bc'),
	('546a775e-ed7e-4a41-ac93-eeda27518f4e', 'ef9a8b00-2708-41df-acc9-fc5c675f8fb7', 'dc9f9e86-8d80-46b7-87bc-e998cafca819', '32e46d74-0ebf-495b-8261-2c508cd2c2bb', '38ab2b8e-4373-4176-8944-4c6d8cffa7d8', 'c21f6874-6733-4b9b-bc1a-b54fbb495ac9', 'c487eba0-9903-4df2-b999-20f1cca784fb', '84badc4c-a7f2-4af6-8532-8ebf665e5686', '0d9136b3-d6e1-4143-bc20-59738dffb35b', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('608ede0a-0e79-41ed-9f79-353a4e7cf908', 'b1ae776f-2bcc-4237-83dd-7fdc843f582b', 'dc9f9e86-8d80-46b7-87bc-e998cafca819', '32e46d74-0ebf-495b-8261-2c508cd2c2bb', '38ab2b8e-4373-4176-8944-4c6d8cffa7d8', '0af643ac-6840-48a4-8ed7-dc98ad8626a9', '485e8a03-6bd3-4c3b-95d6-baf2f9b44cad', 'd7b13e80-761e-4cb2-b40f-0dfb91095689', '6c891a27-897f-41ec-ac35-7e207d4fead3', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('42d9a130-9da0-469f-937f-95475faafaa4', '9bb810af-c7e0-48a0-b936-5843a69f2c64', 'dc9f9e86-8d80-46b7-87bc-e998cafca819', '32e46d74-0ebf-495b-8261-2c508cd2c2bb', '38ab2b8e-4373-4176-8944-4c6d8cffa7d8', '28286c17-e7ea-4022-b909-1a6b60808185', '485e8a03-6bd3-4c3b-95d6-baf2f9b44cad', '56a40580-3dbd-4d1f-bdaa-54370f39b26d', 'd40b3466-6329-406a-93f7-a4978722af70', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('b3dae05a-8744-41f9-911a-a752682da386', '97ca1988-6de7-4674-8482-5a5baa4c2203', 'dc9f9e86-8d80-46b7-87bc-e998cafca819', '32e46d74-0ebf-495b-8261-2c508cd2c2bb', '38ab2b8e-4373-4176-8944-4c6d8cffa7d8', 'bdd0a9a0-8af5-4232-b7ce-30a76be572ca', '485e8a03-6bd3-4c3b-95d6-baf2f9b44cad', 'e8b85e8f-e837-4dd2-9ac3-b3f22e6f83a6', '5a9caa00-1c9c-49c6-ba30-dd3df2b2599f', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('94e08a43-595e-415e-89a5-92ecf463b817', 'b54bbd98-8ea9-4cca-87ba-c4e34539b6c6', 'dc9f9e86-8d80-46b7-87bc-e998cafca819', '32e46d74-0ebf-495b-8261-2c508cd2c2bb', '38ab2b8e-4373-4176-8944-4c6d8cffa7d8', '1bcfab2c-6971-4998-9c38-55c1e039be68', 'c487eba0-9903-4df2-b999-20f1cca784fb', '52692e65-37ae-4851-9b83-d318448b8a15', '35b2356d-cad3-415a-af7d-dc32bd148ae2', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('d28cc73e-5767-4c87-96e4-e0781f44488e', '744f18b2-51b2-4525-9d1a-5990dfe9598a', 'dc9f9e86-8d80-46b7-87bc-e998cafca819', '32e46d74-0ebf-495b-8261-2c508cd2c2bb', '38ab2b8e-4373-4176-8944-4c6d8cffa7d8', 'b40c3129-d1f9-4ee7-9b6f-a4ed111c7109', '485e8a03-6bd3-4c3b-95d6-baf2f9b44cad', '1e9505f2-4f09-47be-82fe-648e59412d31', 'c5197681-247e-481b-b496-b4503db81187', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('8f4065ee-3af9-47d0-a2c5-0c167c7daa2a', 'f98ddfa7-6ee9-4e85-b97d-30acf38f92e0', 'dc9f9e86-8d80-46b7-87bc-e998cafca819', '32e46d74-0ebf-495b-8261-2c508cd2c2bb', '38ab2b8e-4373-4176-8944-4c6d8cffa7d8', '9fdf9c47-28c6-4d2f-ba6f-906b588206c3', '485e8a03-6bd3-4c3b-95d6-baf2f9b44cad', 'e8a5b83c-e982-454d-a84a-3bb3b76806f3', '5577ba9a-318d-4440-8baa-7abf3925e7f0', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('7638d690-405a-4533-9b22-3b55c8c39cb6', '1400713f-fd61-470b-a9bc-1428d8228a22', 'dc9f9e86-8d80-46b7-87bc-e998cafca819', '32e46d74-0ebf-495b-8261-2c508cd2c2bb', '38ab2b8e-4373-4176-8944-4c6d8cffa7d8', '1bcfab2c-6971-4998-9c38-55c1e039be68', 'c487eba0-9903-4df2-b999-20f1cca784fb', '34a90645-b540-4351-8d4b-356bec2a4c76', '35b2356d-cad3-415a-af7d-dc32bd148ae2', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('074ac468-c2bf-4682-b69a-e4d0daa54f9d', '70758a6c-5970-4782-93bc-e7b03242129e', 'dc9f9e86-8d80-46b7-87bc-e998cafca819', '32e46d74-0ebf-495b-8261-2c508cd2c2bb', '38ab2b8e-4373-4176-8944-4c6d8cffa7d8', 'e8e39ac5-cd31-4312-8f42-063aed530c47', 'c487eba0-9903-4df2-b999-20f1cca784fb', 'e43873e2-e36a-4f91-876b-b62ee15b6a55', '15cd7b16-0306-42b8-8208-9cca5b9deda3', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('52c56c4e-33a4-4aa0-8939-466297806da5', 'd0ea1f2c-baec-438a-801d-014bc4535392', 'cf117bdb-0226-42f0-9f40-e11aa3369b61', '6cc3324b-91cb-4ea6-a0db-2cd327ce7941', '7272229e-d4b1-419e-849b-531e45200032', 'ec46bd78-eaea-4593-b5de-9d07bb169875', '68489e77-9d60-498a-840c-712d1fb7ae01', 'bb066056-57d6-44aa-ae8f-b9ecc2d16c15', '07789943-52cc-4a00-a811-7656fbdc20f4', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('b90a1758-7d11-4148-bf24-c152d32bc873', 'a8b92a45-0527-4d96-a447-655794f07d46', 'a4572037-9765-42e9-890c-0a4c47a49abd', '489dce3e-58d7-44c5-b9ef-2f7d7cbdb592', '50c00d93-da6b-4df1-87ad-ebe1b4af26d0', 'a92333cd-38a8-4b10-9822-3d66ade87507', 'd0b01b14-129d-452c-aba9-32a10da493ab', '87cd11b8-7e94-47cd-9996-0ecc21f1ca54', '7dd76107-3e1d-40a1-b89b-e801475b55b9', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('48255fe1-9822-4189-980f-f281616252bc', '82243d05-e27c-481c-8646-cd23d6e1156c', 'c3481033-0753-4614-b00b-677ccc85d1ee', '489dce3e-58d7-44c5-b9ef-2f7d7cbdb592', '3f0b99bb-4666-463d-b373-6f096c6c032c', '1e6798c9-c8d2-4cec-acfa-c60a17acc802', 'ce572531-777d-4112-b07a-99c827d21bb7', '48507344-3f4b-475c-9b60-b913b01b5d27', '0254b351-1c59-4e0e-822d-b99b185b22f4', 'f755a09b-bf99-4ac1-a3cc-266ad9a9c32b'),
	('3b5f8153-33c1-4873-9d89-8725d72a7abc', 'b1c2ad38-5969-4c5d-82e8-958dff480969', '893121c9-05e6-4e35-bfef-ea76e40c012e', 'f85647db-e5d1-41a6-befb-bfbf6420f5c4', '17fc3b24-6e02-44e2-8efc-2c47da891a27', '530f3047-08df-4892-b9ab-16df2a2a39be', '530f1da7-9067-43a1-b515-e93f9199b65e', 'cda69748-98b0-4ee6-a025-27833304c743', '7100b4af-5ca3-4746-a8ef-4c5f46714353', '1c041cb3-373a-4dd5-9af4-2950293776bc'),
	('064f24af-750a-40a0-9cfd-a705f06fbc20', '29127bbf-da06-42e5-98c3-dc0ad5947fd4', '275bafd9-e869-4606-ad4a-6c578baae51f', '21478f61-4270-49ad-8c24-d9058ea036ab', '97abf0ae-974e-47fc-b853-8453a99c0ed8', '4091a6cd-4f4f-4991-88c6-43a0bc656cd0', 'b372ba77-97c3-4aae-924d-8d8cecef24e9', '5a954a5c-ee09-4d51-8fae-a269e79601b0', '776ff4b6-d4d0-438d-be38-b8b227c0949e', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('11379dca-c756-4834-bd3a-104eca10c89f', '9483d5ac-be47-4590-ae47-ed94186bd376', '7788aab1-b623-462a-9e65-32e7d9c353ca', 'f5cdf1f1-5f75-4420-b597-862614e13549', '2cf133a0-4155-492d-a705-b2a17e189483', 'c9e8a8b9-0b68-4c4a-bd56-d65202b95275', '7186247e-c257-4a0f-8c65-6fe2540a95d3', '0f955cfc-255c-470c-8a4c-c91586d92930', 'ec039d06-459b-4c69-89fc-ed048ea4689f', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('aa8f7326-fbb5-42dc-88cd-f0a2a750e4a7', 'b1dc31f6-b63a-4d1c-a6d4-fec41aa9c0ef', '8d9e4a37-f50c-41c9-81c3-895306cf4782', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	('da838ab0-b997-4c07-b0ee-1a6cc33eba98', '6db6ce3a-5540-41c5-9c78-cfb576c5b061', '987bd60d-dd0c-4707-818f-d4aeb184a7b8', '1375841f-e6ba-4cda-9fac-753ff9df93a2', '54101cc5-e262-4a15-9d6b-9d0aad2921aa', '04d0ac1c-15cc-467d-adef-51c7ca94f07b', '9088bbcc-4370-4e5e-a8eb-9ee9493d1c94', 'adfcb62a-2e5b-4bd1-9362-b189bc0acf6a', 'e3af2bbe-c7ab-473c-a172-d800f6797c01', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('835ebd4c-480a-4eae-a204-e54567c79ccb', '7a9d3fea-1169-4319-bcb3-2637c11b13d2', '50d53eb6-b12f-4962-8eff-50c36d424d9d', '21478f61-4270-49ad-8c24-d9058ea036ab', '620361b1-ff4f-4cb5-984d-cd0d725dcd1a', '2e4f45e8-802f-4f37-8106-fb05e2bbc022', 'ee21b42c-060d-46e0-aad4-1efd37616e5e', 'bf065165-c08f-4505-b28e-48b2051c9a97', '777adfc3-4c6e-4c7d-8652-d4dec28581cc', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('711ab6b2-f0f9-42a3-871f-60e53b0b7df7', 'e21d23b0-23a3-4e28-89e5-12c0059818d2', '00720f6a-c51f-4c33-8146-3c3bd96dc279', '9c5ec547-5f0d-4ed6-938c-ba51c67d197d', '1a9c5f8e-4a8e-4d53-982d-214ecffc11be', '82e334b9-bbea-40cb-931c-fb61b7b6cd41', 'be38bb40-3440-4bf5-b15e-74b9c8632300', '236e4125-e6f5-4af6-9850-a4177cd7215d', 'ae23fb48-50c9-4aed-a878-b3c810a35180', '1d69b4b9-1c8a-4b68-80a6-1ed414f9a43a'),
	('c306cfde-fff8-4881-a28d-5dc7477def1f', '98130685-8a80-4e6b-839d-e81da8e66baa', '3b110d34-2776-4827-969e-2af0d39a4aa2', '21478f61-4270-49ad-8c24-d9058ea036ab', 'beab8458-fc51-4818-a8eb-938c0fbf10bf', 'ede75355-97be-4487-88b6-a9a6595aab89', '4f760621-fec5-4a87-afdb-cd62a17fdc27', 'b9c7af72-836d-4e53-88b6-de151c03119e', 'e8514cc1-4d25-48e2-a587-a56080759ee0', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('859368fd-9efc-45a3-92a8-7a61faf18b32', '13d1b8b6-c6a8-47c1-959e-bcb9d27fc3f9', '3a839d72-f591-4c51-9b4b-91637c541035', '32e46d74-0ebf-495b-8261-2c508cd2c2bb', '2bc0a446-371e-4d91-87d9-ac0fbcc1445d', '445a5318-efa8-4f52-a740-563f101c7567', '25b05125-3e5f-4c7f-84b9-efd472525f3d', '01b8e7ee-bb4f-43d0-ab69-2f2cb597858e', '84503731-6851-4d4f-a5c4-485544cb67c6', 'f755a09b-bf99-4ac1-a3cc-266ad9a9c32b'),
	('0e75b523-0f17-4bd9-bbe2-bda2eacdcb61', '4d3f1d5d-59ac-40be-bb40-32f09eafe6b8', 'db38471e-2843-4e5a-9712-1d8fc220f3de', '7ca695f4-dfcd-4f78-bdaf-17861eafbf97', '1e04f205-ee15-4a66-9df8-3806ee7ea570', '8acaa659-c224-45be-9866-388a0ca3756e', 'f12d79d9-d96c-430f-9999-3e3429d13e58', 'f3f1401b-2a66-4e7c-9661-f37932651481', 'aea71101-bf51-4b1b-8ea1-b8d3b2121334', 'fba31373-6bf1-4ad2-9d63-a2c783849aad'),
	('141589b3-9168-460c-9cbb-f6f7f0fef801', '5d30cf6f-49cf-42c8-88b8-1ab720bf0dda', '0a78f87e-d71b-44c3-b598-2cc2b8038e95', '489dce3e-58d7-44c5-b9ef-2f7d7cbdb592', 'c8efb411-9c6d-492e-af1e-624ed743712f', 'f22dfd05-c647-403a-bebd-69fb3a62cca6', '93b33a64-95d1-4d7f-9142-4acc73221e9a', '22d38930-6da2-4b70-9bca-6208cbb43ba5', 'cddc19f9-9b91-4e98-a4c8-656753fd673c', 'fba31373-6bf1-4ad2-9d63-a2c783849aad'),
	('6d113d68-3183-4d9b-afb0-d4f3326537a7', 'fdea59a7-6537-43f2-a5c1-fb83bab3a498', '2331ef34-0efc-46ff-bd37-a5046d40a753', '7ca695f4-dfcd-4f78-bdaf-17861eafbf97', 'f7e241f3-c6fb-48e6-a77d-027951284c61', '0fa1ef24-4b15-4692-b1c4-8f47dc872dac', 'c27f9203-9440-4d37-be02-8ccbdd0e7c95', '81e44df7-d1d8-4222-8191-ffc69999093c', '368c9d59-0593-4a0f-bf51-2b07a7151332', 'fba31373-6bf1-4ad2-9d63-a2c783849aad'),
	('0d6bcfdf-0ffe-4ee4-8b61-da012593d034', '419a482b-1722-4adb-85af-fdcd9d9640f8', 'b852b15b-c92e-4f4c-a014-5a99cdf7025b', '1375841f-e6ba-4cda-9fac-753ff9df93a2', 'd73a9b66-ca0c-43b9-83a8-efae806bdde8', '2512f633-7cc6-42ad-b433-bc7973470bda', 'b25de346-0bba-425e-8ad3-5d259b47114d', '27190c0c-310c-47a7-b9fe-2f286bc33298', 'f5c5681e-2ec4-43fa-aa2a-12af704f14ca', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('2cde4641-cf7f-49e7-9230-e0918d4b12d5', 'f62c29b5-f955-45ae-bc39-2a347bbfa582', '34427472-2794-4f4b-9bf3-d17e2b945133', '1375841f-e6ba-4cda-9fac-753ff9df93a2', 'dd4dab97-8547-4bb1-b683-875cfc46a680', '18aeb09f-5e30-4e51-9432-996257bf2155', '6df803f9-6f84-41da-9507-6db18aec825a', '6d08c397-a891-4d02-9a51-19de5ca81837', '47de1daa-d977-41be-9925-216a45804274', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('ea5b530f-398c-463d-868f-079969016437', '998775ca-c521-4df1-8cf6-5304b20b5a5e', '34427472-2794-4f4b-9bf3-d17e2b945133', '1375841f-e6ba-4cda-9fac-753ff9df93a2', 'dd4dab97-8547-4bb1-b683-875cfc46a680', '18aeb09f-5e30-4e51-9432-996257bf2155', '6df803f9-6f84-41da-9507-6db18aec825a', '6d08c397-a891-4d02-9a51-19de5ca81837', '47de1daa-d977-41be-9925-216a45804274', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('3fccbe91-1861-48ac-90e5-6b0e57bbd48e', '923af34d-8cbb-45f8-80f5-513314a15cdf', '987bd60d-dd0c-4707-818f-d4aeb184a7b8', '1375841f-e6ba-4cda-9fac-753ff9df93a2', '54101cc5-e262-4a15-9d6b-9d0aad2921aa', 'ad916db9-124c-4c6e-829a-e9421671a31c', '9088bbcc-4370-4e5e-a8eb-9ee9493d1c94', '0d2f65b5-4bce-40e5-8eb5-fb15f8a18fdb', '3882234b-cf19-47af-9dfe-c285dbe35ce0', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('619f3665-533c-49e0-a47d-05d5473eacd7', '925bb411-89bd-4d51-ba94-dc3af0ed1de5', '987bd60d-dd0c-4707-818f-d4aeb184a7b8', '1375841f-e6ba-4cda-9fac-753ff9df93a2', '54101cc5-e262-4a15-9d6b-9d0aad2921aa', '04d0ac1c-15cc-467d-adef-51c7ca94f07b', '9088bbcc-4370-4e5e-a8eb-9ee9493d1c94', 'adfcb62a-2e5b-4bd1-9362-b189bc0acf6a', 'e3af2bbe-c7ab-473c-a172-d800f6797c01', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('b3f8bab2-494b-4a94-9fe2-b634cd60b4a2', '82d29ae9-0f77-4ee6-a8de-6a9521cec0f3', '987bd60d-dd0c-4707-818f-d4aeb184a7b8', '1375841f-e6ba-4cda-9fac-753ff9df93a2', '54101cc5-e262-4a15-9d6b-9d0aad2921aa', '439f4298-d666-4239-bee4-9bd46f7bfcd9', '9088bbcc-4370-4e5e-a8eb-9ee9493d1c94', 'e9773da7-0792-44a1-b923-cc0adf25a57e', '675c8870-19bb-44e3-93ad-de23c20dbfc2', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('dc428a8d-29ce-44c4-9256-4ba0640a9d86', '62edb636-34fa-4856-99ca-d06f7ae8354d', '987bd60d-dd0c-4707-818f-d4aeb184a7b8', '1375841f-e6ba-4cda-9fac-753ff9df93a2', '54101cc5-e262-4a15-9d6b-9d0aad2921aa', '4579d615-a2b7-44d7-9a03-4a5983a4ca2c', '9088bbcc-4370-4e5e-a8eb-9ee9493d1c94', 'be526a74-d188-491f-baab-9c965bb2b816', '22c9c864-c795-4105-9e06-fca6d8fb01f4', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('7efe043b-ec0c-47c0-8c07-03de4797a9ab', 'bb92723a-335c-454b-9a95-def4cc4a6820', '987bd60d-dd0c-4707-818f-d4aeb184a7b8', '1375841f-e6ba-4cda-9fac-753ff9df93a2', '54101cc5-e262-4a15-9d6b-9d0aad2921aa', 'd2aaea09-f2bd-4363-9528-ba1502781740', '7a03aae3-9cf1-4bfd-8d77-c57978ad4d91', 'e92c649e-930b-4197-8cac-51986743902a', 'b663e8d8-8e5d-4631-92d2-a68999ee7385', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('7a71309c-70ac-40ad-a4c3-f70423d92e62', '948a2896-62e2-4546-b5b8-59b422350235', '987bd60d-dd0c-4707-818f-d4aeb184a7b8', '1375841f-e6ba-4cda-9fac-753ff9df93a2', '54101cc5-e262-4a15-9d6b-9d0aad2921aa', '2186ae56-626c-4efb-9ccd-57b0b43a2baf', 'bf56b35e-bc52-49ae-a3e1-024ce12dc124', 'bd55873b-de12-4085-9166-779acfa6c739', '79427e27-95d9-4dae-a20b-438c654be397', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('1b2257d1-a9e1-4ce5-9ece-b4b2b955f501', '4144d29e-6d62-4bf6-aa6f-3e7bdc376da2', '987bd60d-dd0c-4707-818f-d4aeb184a7b8', '1375841f-e6ba-4cda-9fac-753ff9df93a2', '54101cc5-e262-4a15-9d6b-9d0aad2921aa', '81c4338c-1667-434c-803f-0680411015fe', 'bf56b35e-bc52-49ae-a3e1-024ce12dc124', '5004d684-dfd5-44be-9c39-503e58c23ae2', '9bd93f61-f661-42cc-bd8f-36779668cceb', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('3b66f0b2-e8f9-4036-84d8-c121c98ed998', '147a02bd-e737-4d3b-94c0-c2185db187bc', 'c1782af8-ed41-4ee1-bd3a-a5449b43acde', '32e46d74-0ebf-495b-8261-2c508cd2c2bb', '94320f96-6ff3-44e7-a39e-22c0f53257c2', 'cbb1ca15-8873-4094-8ddc-a0a58e20ed86', '24db7f84-44da-4eca-b216-e013b4a41323', 'fdcf6bc2-1d6a-47d7-bd26-37c10a580ca8', '4bc48b4e-735d-4409-8dc8-5ed306c90e76', 'f755a09b-bf99-4ac1-a3cc-266ad9a9c32b'),
	('76738b43-67ad-4365-a2a4-1e1b03bf000a', 'bbd5f265-3f34-426f-b2b2-f5eefa753d0f', '4f5cf1f1-e617-4ad7-b077-41042c25dd30', '9c5ec547-5f0d-4ed6-938c-ba51c67d197d', 'c3c11c4d-05b1-447d-a13b-4186b7956fb2', '89179d09-63c9-4bdf-a104-c63d646a59e2', 'c3b261d9-2479-442e-bc74-3074b3bcfeb9', '8789ff34-8c1a-4ccb-9ce9-31691db5d6b2', 'a5bcf7df-24f6-4d10-adc3-96c6aa334f6d', '8826f875-fade-4b0b-a4b1-f8536505ecd1');


--
-- Data for Name: establishment_lifecycle; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_lifecycle (establishment_lifecycle_id, establishment_id, establishment_status_id, open_date, close_date, reason_establishment_opened_id, reason_establishment_closed_id, last_changed_date) VALUES
	('117ddccb-6588-489b-8a2d-d5c111a395c0', '4e29ed4f-3418-4b36-822f-0e94aacdf08c', 1, '2010-09-01', NULL, 2, NULL, '2026-06-23'),
	('ea5c3c2f-3746-430a-af1e-2735bc99e010', '1ef65a39-891a-4ad2-a2c6-bccd3a5f13a6', 1, '2007-09-01', NULL, 2, NULL, '2026-06-23'),
	('9d74acfb-7fda-4548-8f9f-da7273bad5a9', '7aa926f6-ce2e-4247-812a-c689240cac54', 1, '2011-11-01', NULL, 1, NULL, '2026-06-23'),
	('f832dea8-d230-4bb3-b282-862695117e9a', '75cd413e-73ca-4b6a-87b7-dbbb4ffa485c', 1, NULL, NULL, NULL, NULL, '2026-06-23'),
	('e347a712-6837-40e6-afc6-0a8bc9290b76', 'a3d0478b-2257-4078-b3de-ce8ca0f1f09b', 1, NULL, NULL, NULL, NULL, '2026-06-23'),
	('bf43e07a-2f8a-437d-80de-7827b8bb8a24', 'ef9a8b00-2708-41df-acc9-fc5c675f8fb7', 1, '2008-02-07', NULL, NULL, NULL, '2025-06-20'),
	('343cf303-06f7-41de-9b53-70e5f70d9f11', 'b1ae776f-2bcc-4237-83dd-7fdc843f582b', 1, '2006-03-14', NULL, NULL, NULL, '2025-06-20'),
	('f78e8764-7aab-4c3a-8bdc-7c8640c7e947', '9bb810af-c7e0-48a0-b936-5843a69f2c64', 1, '2008-03-03', NULL, NULL, NULL, '2025-06-20'),
	('1c8e7366-fe76-4dc0-bc4c-a28b694f0b57', '97ca1988-6de7-4674-8482-5a5baa4c2203', 1, '2009-12-14', NULL, NULL, NULL, '2025-06-20'),
	('08c3c7f5-72d7-4fb8-b38e-b29eeed55309', 'b54bbd98-8ea9-4cca-87ba-c4e34539b6c6', 1, '2009-12-14', NULL, NULL, NULL, '2025-06-20'),
	('35396f18-0865-437b-b80f-db0b2f5be556', '744f18b2-51b2-4525-9d1a-5990dfe9598a', 1, '2008-01-16', NULL, NULL, NULL, '2025-06-20'),
	('447bf571-6cc5-4f2b-aa65-134b190ebe6c', 'f98ddfa7-6ee9-4e85-b97d-30acf38f92e0', 1, '2008-01-16', NULL, NULL, NULL, '2025-06-20'),
	('e54bf681-cd55-4f25-b0cf-655ba08e6998', '1400713f-fd61-470b-a9bc-1428d8228a22', 1, '2008-02-07', NULL, NULL, NULL, '2025-06-20'),
	('9f919333-df89-4820-9fd4-95799026ff44', '70758a6c-5970-4782-93bc-e7b03242129e', 1, '2006-09-28', NULL, NULL, NULL, '2025-06-20'),
	('234644c9-b44c-49d1-babc-af63adf34a2f', 'd0ea1f2c-baec-438a-801d-014bc4535392', 1, '2001-09-01', NULL, 6, NULL, '2025-06-20'),
	('2c22b3c1-b71d-4e38-907e-4b9456fca9ff', 'a8b92a45-0527-4d96-a447-655794f07d46', 1, '2009-09-01', NULL, 2, NULL, '2026-06-23'),
	('5ed540c8-6097-45af-8b2a-67af8058cb12', '82243d05-e27c-481c-8646-cd23d6e1156c', 1, '1990-03-28', NULL, NULL, NULL, '2026-07-20'),
	('4082cb02-a191-4eca-adce-dfe09ec19f7e', 'b1c2ad38-5969-4c5d-82e8-958dff480969', 1, '1988-12-12', NULL, NULL, NULL, '2026-07-20'),
	('7cecae66-590b-4647-b991-4e66b624bd41', '29127bbf-da06-42e5-98c3-dc0ad5947fd4', 1, '2011-03-01', NULL, 1, NULL, '2026-06-23'),
	('d327bca2-865a-4372-bfe4-d198492e2716', 'b1dc31f6-b63a-4d1c-a6d4-fec41aa9c0ef', 1, '2021-02-18', NULL, NULL, NULL, NULL),
	('888d9c69-f2ab-42dd-a294-4591f5c7f384', '9483d5ac-be47-4590-ae47-ed94186bd376', 1, '2009-09-01', NULL, 2, NULL, '2026-06-23'),
	('4c9e30ec-9e9b-49ef-9e7f-b1d84f8644ba', '6db6ce3a-5540-41c5-9c78-cfb576c5b061', 1, '2007-09-01', NULL, 2, NULL, '2026-06-23'),
	('fe17adf9-675f-466a-8e44-06ed4961715b', '7a9d3fea-1169-4319-bcb3-2637c11b13d2', 1, NULL, NULL, NULL, NULL, '2026-06-23'),
	('51b82442-5434-4a0a-b011-9f0d1aa456da', 'e21d23b0-23a3-4e28-89e5-12c0059818d2', 1, '2011-08-01', NULL, 1, NULL, '2026-06-23'),
	('2f70e718-1b1b-40e6-ba65-ed310fe6af30', '98130685-8a80-4e6b-839d-e81da8e66baa', 1, '1930-01-01', NULL, NULL, NULL, '2026-07-20'),
	('7c0d1a35-6793-40e1-b4df-12f70d790da2', '13d1b8b6-c6a8-47c1-959e-bcb9d27fc3f9', 1, '2013-07-01', NULL, 1, NULL, '2026-06-23'),
	('a2ae3b06-7deb-4522-b7ea-f5e6f4a392a2', '4d3f1d5d-59ac-40be-bb40-32f09eafe6b8', 2, '2011-09-01', '2015-08-31', 2, 3, '2016-06-30'),
	('1acb2be5-cb7b-45a4-96b4-d2727de4cfe0', '5d30cf6f-49cf-42c8-88b8-1ab720bf0dda', 2, '2009-09-01', '2016-02-29', 2, 12, '2018-07-02'),
	('96017916-dbc0-49ef-9fe9-5b1c97795d36', 'fdea59a7-6537-43f2-a5c1-fb83bab3a498', 2, NULL, '2020-06-16', NULL, 1, '2026-06-23'),
	('7d1e4cdd-8cc9-4fbc-bfeb-4822a2980bd2', '998775ca-c521-4df1-8cf6-5304b20b5a5e', 1, NULL, NULL, NULL, NULL, '2025-07-03'),
	('60ab4852-acd9-407e-ab92-3c013ba49b59', 'f62c29b5-f955-45ae-bc39-2a347bbfa582', 1, NULL, NULL, NULL, NULL, '2025-07-03'),
	('81cb70f4-c92d-4300-8a63-bd3ad0a89ca4', '419a482b-1722-4adb-85af-fdcd9d9640f8', 1, NULL, NULL, NULL, NULL, '2025-07-03'),
	('a44caa4d-f474-46ff-8e9f-d77294673b9c', '925bb411-89bd-4d51-ba94-dc3af0ed1de5', 1, '2008-01-23', NULL, NULL, NULL, '2025-06-20'),
	('ac255f1e-d708-43dc-a47d-c5a3ebb55763', '923af34d-8cbb-45f8-80f5-513314a15cdf', 1, '2008-01-23', NULL, NULL, NULL, '2025-06-20'),
	('936f2be4-02e1-4601-9310-dde09d6f9439', '4144d29e-6d62-4bf6-aa6f-3e7bdc376da2', 1, '2009-09-30', NULL, NULL, NULL, '2025-06-20'),
	('4544fa6c-0f25-45e2-9159-b9c28995dba6', 'bb92723a-335c-454b-9a95-def4cc4a6820', 1, '2006-09-27', NULL, NULL, NULL, '2025-06-20'),
	('3b36d1dc-e653-46f2-a19b-df5e80393531', '948a2896-62e2-4546-b5b8-59b422350235', 1, '2006-09-27', NULL, NULL, NULL, '2025-06-20'),
	('ee94d8f7-64b1-49de-944e-640ffece872f', '82d29ae9-0f77-4ee6-a8de-6a9521cec0f3', 1, '2007-09-16', NULL, NULL, NULL, '2025-06-20'),
	('e6ae31e0-bd55-4478-a961-60808f57e343', '62edb636-34fa-4856-99ca-d06f7ae8354d', 1, '2008-03-31', NULL, NULL, NULL, '2025-06-20'),
	('031d1cdb-d2b0-4fca-a67c-b13f7eac41f9', '147a02bd-e737-4d3b-94c0-c2185db187bc', 1, '1921-03-13', NULL, 2, NULL, '2026-07-20'),
	('46354894-bb4d-4d3a-a3d8-45c22409aaa9', 'bbd5f265-3f34-426f-b2b2-f5eefa753d0f', 1, '2016-09-01', NULL, NULL, NULL, '2026-06-23');


--
-- Data for Name: person; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.person (person_id) VALUES
	('e271ca89-95be-46f9-b771-c3684c22c9c5');


--
-- Data for Name: establishment_party_role; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_party_role (establishment_party_role_id, establishment_party_role_type_id, legal_entity_id, person_id, start_date, end_date) VALUES
	('30e9a305-ee34-4145-80d3-5330cd63db42', 1, '05248c5c-bce4-4819-afb8-95d6304aad86', NULL, NULL, NULL),
	('c0dd5c60-c867-46ac-9863-b76a5d8ca7f5', 1, '980686ef-fef1-4cb2-81ba-f9df2b6e4df1', NULL, NULL, NULL),
	('71e61308-3848-4c97-b006-36522ce42574', 4, '8e31c85c-f5d5-4986-b65e-c7b729df1f7d', NULL, NULL, NULL),
	('6b723e23-367e-4493-8020-6d2582851d96', 1, '6193bf84-dbf3-4d71-a654-29c2acfdb732', NULL, NULL, NULL),
	('a9a522a2-a357-42e9-899b-81d7d189992d', 4, '44d6692c-6d24-4dc3-896a-a1362bd4db73', NULL, NULL, NULL),
	('b554b481-8627-478d-89ef-6cf88fd216a2', 1, '87fb0d50-8169-4ac1-b928-61d9bbea878e', NULL, NULL, '2016-02-29'),
	('3a4c150d-110e-46d7-b07a-fa1ed5224fbb', 1, '3ecc1d6b-978e-4e6c-b3d6-222db56217da', NULL, NULL, NULL),
	('dc1aeab7-0da1-42cc-b1e3-484b050716c1', 2, 'c9d47bfb-e67a-408d-9adb-8515643aac8d', NULL, NULL, NULL),
	('4686dafe-2de4-429b-bec3-83069f2b180e', 4, NULL, 'e271ca89-95be-46f9-b771-c3684c22c9c5', NULL, NULL),
	('593a82d2-f1be-4a03-8345-9933285e6c3b', 1, '1c8f582a-5dee-4bed-8919-31b2c9781457', NULL, NULL, NULL),
	('3a5cafb4-71f7-4cb9-b476-a0ca4f0b1157', 1, 'c59c4cdc-01e4-4656-830c-e5f634e3d717', NULL, NULL, NULL),
	('24c3a6af-4d43-42aa-8474-1747b0b32427', 1, 'd5536b33-b3ba-47e6-b8ec-20db8c85f72b', NULL, NULL, NULL),
	('8c7d79bc-bdcd-4b45-8412-2e54b76d4ac5', 4, 'c08b2b23-bf2a-47c8-b2c4-09ebd67525fd', NULL, NULL, NULL),
	('a7f5851a-6a9a-4adc-a05d-cac6b992064f', 1, 'c08b2b23-bf2a-47c8-b2c4-09ebd67525fd', NULL, NULL, NULL),
	('337e88e2-5c9a-45eb-9d14-8aaea96ad32e', 4, '8656f963-c3dd-4a30-a6c6-326ca448884e', NULL, NULL, NULL),
	('c5cd7356-5755-4c3b-8cbe-61733964fa64', 1, '8656f963-c3dd-4a30-a6c6-326ca448884e', NULL, NULL, NULL),
	('67621ccd-c9a3-4967-9310-704025d5e5ac', 2, '4edc36ee-fdc5-42e5-9eca-e74483c712f1', NULL, NULL, NULL),
	('991e5121-89c0-433e-8d79-c86af82c7670', 1, 'a4099bbe-ea70-4371-96a2-55be90d5872f', NULL, NULL, NULL),
	('69449a85-7744-4292-94ec-8e8222aa16fa', 4, '117294bf-8077-49bd-b36f-9d59ec0d4b43', NULL, NULL, NULL),
	('698a28ae-9ff0-4eae-ad39-5a835d202978', 1, 'f1a6af5f-7134-4e63-8562-c4fbb5eaf072', NULL, NULL, NULL),
	('f3dc0261-9446-4249-a876-a9d55088d6d5', 1, '37bcaf9f-f610-4193-b942-b02ecdc1367b', NULL, NULL, '2015-08-31'),
	('0b7eee62-a8c6-4a50-9e79-9b49c9085e66', 2, 'a0372be4-5176-4293-95cc-324ed49ff1ad', NULL, NULL, NULL),
	('9d27858e-173c-4179-8119-617a3dd8ce2e', 1, '1f4b2ea1-3590-48a6-9eaa-027b9ac942fb', NULL, NULL, NULL),
	('6a61d989-8a13-4afa-bd3e-104a1175703c', 1, '01f1c31f-c774-47fc-a358-51ba5bc40df3', NULL, NULL, NULL);


--
-- Data for Name: establishment_responsibility; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_responsibility (establishment_responsibility_id, establishment_id, legal_entity_id, person_id, responsibility_type_id, academy_trust_type_id, start_date, end_date, is_current) VALUES
	('20730d87-4416-43e9-b902-25fd81c4fb51', '4e29ed4f-3418-4b36-822f-0e94aacdf08c', '05248c5c-bce4-4819-afb8-95d6304aad86', NULL, 1, 2, '2015-07-01', NULL, true),
	('d340ed78-1f71-4cc9-a896-d38f990b436c', '4e29ed4f-3418-4b36-822f-0e94aacdf08c', '980686ef-fef1-4cb2-81ba-f9df2b6e4df1', NULL, 1, 1, '2010-09-01', NULL, false),
	('590e747a-deef-4d3a-b028-7d7b782d910d', '4e29ed4f-3418-4b36-822f-0e94aacdf08c', '8e31c85c-f5d5-4986-b65e-c7b729df1f7d', NULL, 3, NULL, '2010-09-01', NULL, true),
	('89dc668d-1e64-4f10-ba4c-3cb50aeada53', '1ef65a39-891a-4ad2-a2c6-bccd3a5f13a6', '6193bf84-dbf3-4d71-a654-29c2acfdb732', NULL, 1, 2, '2021-10-04', NULL, true),
	('1142a848-9137-403b-b741-259830e3e27a', '1ef65a39-891a-4ad2-a2c6-bccd3a5f13a6', '6193bf84-dbf3-4d71-a654-29c2acfdb732', NULL, 1, 1, '2007-09-01', NULL, false),
	('7295aea9-64af-44aa-9073-e64a4ab0e1af', '1ef65a39-891a-4ad2-a2c6-bccd3a5f13a6', '44d6692c-6d24-4dc3-896a-a1362bd4db73', NULL, 3, NULL, '2007-09-01', NULL, true),
	('392a6c75-a441-49b6-a03f-3698345e951a', '7aa926f6-ce2e-4247-812a-c689240cac54', '3ecc1d6b-978e-4e6c-b3d6-222db56217da', NULL, 1, 1, '2011-11-01', NULL, false),
	('76f6aa0a-cc08-4cbf-aaa4-47288d50032e', '7aa926f6-ce2e-4247-812a-c689240cac54', '3ecc1d6b-978e-4e6c-b3d6-222db56217da', NULL, 1, 2, '2021-03-30', NULL, true),
	('90c55d6a-68a5-4ad9-810a-4daf9ce4c66a', 'd0ea1f2c-baec-438a-801d-014bc4535392', 'c9d47bfb-e67a-408d-9adb-8515643aac8d', NULL, 2, NULL, '2011-09-01', NULL, true),
	('99bb8984-12ce-4a59-bc61-42152d8919cd', 'a8b92a45-0527-4d96-a447-655794f07d46', NULL, 'e271ca89-95be-46f9-b771-c3684c22c9c5', 3, NULL, '2009-09-01', NULL, true),
	('54fcc994-26a9-49aa-b1b9-56a9b20239d1', 'a8b92a45-0527-4d96-a447-655794f07d46', '1c8f582a-5dee-4bed-8919-31b2c9781457', NULL, 1, 2, '2009-09-01', NULL, true),
	('e1270caf-6eca-4ba7-a371-c7cbfd922e0d', '82243d05-e27c-481c-8646-cd23d6e1156c', '5be037f1-12fc-4b40-829c-4135c96fc783', NULL, 4, NULL, NULL, NULL, true),
	('00f26a48-2ec8-49cb-b2ef-3b3c6d64c218', 'b1c2ad38-5969-4c5d-82e8-958dff480969', '5be037f1-12fc-4b40-829c-4135c96fc783', NULL, 4, NULL, NULL, NULL, true),
	('c07933f0-88f2-44d3-b5f3-736ea7e17cfd', '29127bbf-da06-42e5-98c3-dc0ad5947fd4', 'd5536b33-b3ba-47e6-b8ec-20db8c85f72b', NULL, 1, 2, '2017-01-01', NULL, true),
	('4954b54d-30f7-4ee1-bb0a-ba83a6fe41d3', '29127bbf-da06-42e5-98c3-dc0ad5947fd4', 'c59c4cdc-01e4-4656-830c-e5f634e3d717', NULL, 1, 2, '2011-03-01', NULL, false),
	('c003bcc1-1ea3-48c4-848a-71caf8827cd3', 'b1dc31f6-b63a-4d1c-a6d4-fec41aa9c0ef', 'c08b2b23-bf2a-47c8-b2c4-09ebd67525fd', NULL, 4, NULL, NULL, NULL, true),
	('9a9eaace-da20-4a1c-a160-77c0fac66a14', '9483d5ac-be47-4590-ae47-ed94186bd376', 'c08b2b23-bf2a-47c8-b2c4-09ebd67525fd', NULL, 1, 2, '2009-09-01', NULL, true),
	('7de600af-df47-4076-8fe7-cbc40ac5a37b', '9483d5ac-be47-4590-ae47-ed94186bd376', 'c08b2b23-bf2a-47c8-b2c4-09ebd67525fd', NULL, 3, NULL, '2009-09-01', NULL, true),
	('d80f88b9-4d68-4834-8f38-9f706f702337', '6db6ce3a-5540-41c5-9c78-cfb576c5b061', '8656f963-c3dd-4a30-a6c6-326ca448884e', NULL, 1, 2, '2007-09-01', NULL, true),
	('ab262b7c-697f-4d16-977b-e320fe7e4fec', '6db6ce3a-5540-41c5-9c78-cfb576c5b061', '8656f963-c3dd-4a30-a6c6-326ca448884e', NULL, 3, NULL, '2007-09-01', NULL, true),
	('ceefe831-9a6d-45d1-bc7a-c72b9d8ff9e7', '7a9d3fea-1169-4319-bcb3-2637c11b13d2', '4edc36ee-fdc5-42e5-9eca-e74483c712f1', NULL, 2, NULL, '2010-09-01', NULL, true),
	('bb2415ab-b3cc-4775-9011-be7634dced22', '98130685-8a80-4e6b-839d-e81da8e66baa', '27546d94-e327-49fd-aecb-26c8c043a597', NULL, 4, NULL, NULL, NULL, true),
	('ccd73258-01ad-4f6b-a16f-e91e124eb705', 'e21d23b0-23a3-4e28-89e5-12c0059818d2', 'a4099bbe-ea70-4371-96a2-55be90d5872f', NULL, 1, 1, '2011-08-01', NULL, true),
	('1e94c56e-831f-403b-8619-4fe7bf6f44ab', '13d1b8b6-c6a8-47c1-959e-bcb9d27fc3f9', 'f1a6af5f-7134-4e63-8562-c4fbb5eaf072', NULL, 1, 2, '2013-07-01', NULL, true),
	('1a678ad1-d393-4cdd-a57e-8a3ecd2f590f', '13d1b8b6-c6a8-47c1-959e-bcb9d27fc3f9', '117294bf-8077-49bd-b36f-9d59ec0d4b43', NULL, 3, NULL, '2013-07-01', NULL, true),
	('05456621-1164-44af-a6cb-560e20cce6b8', '4d3f1d5d-59ac-40be-bb40-32f09eafe6b8', '37bcaf9f-f610-4193-b942-b02ecdc1367b', NULL, 1, 1, '2011-09-01', '2015-08-31', false),
	('5ccc9cc3-6818-4014-8ad5-fa0f98dd4b93', '5d30cf6f-49cf-42c8-88b8-1ab720bf0dda', '87fb0d50-8169-4ac1-b928-61d9bbea878e', NULL, 1, 2, '2009-09-01', '2016-02-29', false),
	('3bb6b30c-e01f-4c4c-b1b0-d0374b9f4e50', 'fdea59a7-6537-43f2-a5c1-fb83bab3a498', 'a0372be4-5176-4293-95cc-324ed49ff1ad', NULL, 2, NULL, '2013-05-20', '2020-06-16', false),
	('550b430e-8c51-4c38-ae1c-f2f161cf6dfe', '147a02bd-e737-4d3b-94c0-c2185db187bc', '73d09caa-5883-4fdb-b6b4-c4c45d56a221', NULL, 4, NULL, NULL, NULL, true),
	('967a3e90-e9e7-414a-840a-bcc6a02642c3', 'bbd5f265-3f34-426f-b2b2-f5eefa753d0f', '01f1c31f-c774-47fc-a358-51ba5bc40df3', NULL, 1, 1, '2019-07-09', NULL, true),
	('bff449d3-337b-4f81-bf86-ed425e4a1031', 'bbd5f265-3f34-426f-b2b2-f5eefa753d0f', '1f4b2ea1-3590-48a6-9eaa-027b9ac942fb', NULL, 1, 2, '2018-10-09', NULL, false),
	('d164a130-4d19-4d47-af40-3714b6be24ad', 'bbd5f265-3f34-426f-b2b2-f5eefa753d0f', '1f4b2ea1-3590-48a6-9eaa-027b9ac942fb', NULL, 1, 1, '2016-09-01', NULL, false);


--
-- Data for Name: site; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.site (site_id, address_id, site_name, uprn) VALUES
	('a12be7e8-9930-4057-bde1-bcf31bbe9226', 'b271abbd-5ca7-4039-9e08-4f4d6c8e991b', NULL, 3455015782),
	('db9c12bd-0cf5-4ad6-b91a-5fe05e28278e', 'df9ab569-7f02-40b4-9c32-81c172c28531', NULL, 5300060053),
	('5997dd98-9199-47c3-9062-edcac0c35e15', '50ba5830-d684-457b-ad84-bcee6b06c1a7', NULL, 10006581609),
	('46793a03-818d-44da-b97a-7defc7d10d95', '63c4cfd7-38f8-4a7d-91aa-196542f34980', NULL, 100081218005),
	('d3068534-d6e6-4258-862b-639044f333d1', '6e22b61a-16cd-4e62-ba24-9d4ef5b980d2', NULL, 100081212588),
	('11a4a43e-084c-4529-b9e5-e625029610d2', '3f1ff810-30d9-489c-8ed0-b9dbb2f190bc', NULL, 100091605340),
	('770579ff-c223-439f-ae75-09e135ad119d', '696d776f-cc70-4d80-8ee7-de70b303d8b6', NULL, NULL),
	('1df06fb6-38e4-4d3c-ba2b-78dfffb2d94b', '741b744b-c95f-452c-9202-d825592434d0', NULL, 10024158444),
	('4082429b-75d1-4025-9347-dbde2c66095a', 'd53bc482-53cd-4df4-9263-8537a6e8388f', NULL, 100091593148),
	('7f896441-bb93-4330-9bf5-33910ac2a1a5', 'fb43e080-6b19-4ff3-bb6b-ed5bb76ba4a1', NULL, 10012151948),
	('d25a1378-e7f2-42b6-b29a-278325543383', '15604187-4663-494a-aa08-5839a7f0bac2', NULL, 100091595925),
	('9fa9d5fb-65a9-4bdc-ba84-16926141115d', '5336cce0-308e-464c-9864-d7bba7016697', NULL, 10012152076),
	('67ae9d73-35d0-4d8c-9257-2ddb94d4005e', '223cb4ff-a9e7-4fef-be05-17663e2597c6', NULL, 100091656436),
	('bdd0c9c4-0e68-400c-bbc5-ea7530175bd0', '8a0d116e-3410-401e-a343-944236cb5f66', NULL, 200001258935),
	('daedfd26-6f85-468c-a438-8325b22f9b55', '51877581-2e21-4678-8709-f9c20fa5c8c2', NULL, 47000575),
	('28965ce4-97eb-46db-bee0-f07961df5e57', 'c0e0c252-1b02-4ee9-b3eb-a8e6faef147d', NULL, 100012750549),
	('55bde988-e7f5-44bc-8e80-676e94a8d7b4', '4088a420-3998-4971-9fbd-58fe90b42eca', NULL, NULL),
	('fe27f281-148f-453e-841e-7d534a950bcf', 'c818ee9f-fa55-4a86-9dfd-ed088c3be6be', NULL, 200004392318),
	('044d2948-f803-4b11-8ff6-1b30221bab21', '2fe63b30-0a10-4700-b790-5d72bc16d42e', NULL, 100041036051),
	('12f88a02-c1f6-4ef4-adfd-d1944ba576c8', 'b6bfeb1c-7df7-455e-b913-9b588c127737', NULL, 63154429),
	('969fcbf8-3ef8-477d-8cb1-068b4cc87265', '0a0a25a9-f44b-49e5-9738-507122da9891', NULL, NULL),
	('e595304a-e6a9-4df4-9257-ff4a8b957af5', 'c3b79e69-6786-4aae-8f52-803459e6950a', NULL, NULL),
	('bb8ae2c3-bc51-4163-829c-dffe58aa8fc5', '766ed9d0-e2e6-4128-be2b-00f02a561040', NULL, 212066),
	('040bca99-835e-46bc-8a0c-016284acacb6', '98a82a5e-72d6-40ef-b2d6-a89062eee97e', NULL, 100032118443),
	('8a4f4c1e-3e1e-4f3f-a376-7adef19456c3', 'd8e23aad-ea8b-4423-a4ba-326a48147c5e', NULL, 100121246035),
	('6883304a-04a1-42ac-ab90-e577c32af62a', 'd0a37cb3-14bd-417c-9a4a-4ed9148e4059', NULL, 100091518218),
	('f964a390-a8ad-4e8f-95d8-b658a30ecb8b', '83282b82-318c-4676-bd82-a02aed2d56a8', NULL, NULL),
	('c7a10392-c663-44a6-ac0d-e8e85d803391', 'c4a28252-8758-49c1-bf61-67fd3c48c25d', NULL, 10090666596),
	('a9e5748b-4399-43f6-88f1-69208d4ad705', '9f641fa7-9d2f-4308-8bb1-bd764bc96637', NULL, 100071418496),
	('12d21081-6bd1-4b77-a41d-794c84c8cee1', '484ff988-e2d9-4baa-932e-e93fe7b1d27c', NULL, 200001203807),
	('2cabba7b-0f1f-4db8-b759-ea2d777edaa4', '073fa6e0-617b-40a5-89e4-0cafb844f418', NULL, 5870097499),
	('542f8e03-38b4-47ba-86f4-9e14cc94fcf3', '5b10d5cc-dd05-4c50-9d34-8bfaa660732e', NULL, 5870097499),
	('8c2290de-3672-4b43-a358-fbabc5fcc102', '6d13d9ae-5836-4810-b209-0ee05cd767df', NULL, 207177244),
	('14a90c97-bed2-4a64-abb9-8b5491934379', 'e4239574-6886-43b4-a74b-80ca0aa397fe', NULL, 207172599),
	('b693ae69-c29b-41d9-8687-d97b44821b2f', 'd807594c-1a89-4f8e-ae30-8d1c30ba6088', NULL, 200017096),
	('c5f28944-2333-47b4-9f86-e710464a1c86', '40788d62-a5fa-485a-bdd4-dbc8242c1517', NULL, 207016666),
	('6593d095-8b45-4e32-ac35-c4782759faf9', 'cf146daa-a92f-4782-a8e1-f418cdcbdd99', NULL, 207035789),
	('8d223105-6f58-4d2f-adee-d92c8b15a60c', 'ed93cdb0-bb28-4e85-aa22-e9e30db43116', NULL, 207162707),
	('aa06520e-19cd-465d-b150-d56fd195ff91', '056aca12-1498-4c54-beb9-c2c9bf3cac1e', NULL, NULL),
	('9f6a1a1a-7bf8-4e27-9894-919ec060a602', '0fdedd1c-be52-4881-9a06-0142cf64e36e', NULL, 100091394129),
	('409ef768-102c-4747-b484-dd9f2b838fe4', 'd4113f70-1f77-4713-bd0e-cae38a38dcd3', NULL, 15073795);


--
-- Data for Name: establishment_to_site; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_to_site (establishment_id, site_id, is_main_site) VALUES
	('4e29ed4f-3418-4b36-822f-0e94aacdf08c', 'a12be7e8-9930-4057-bde1-bcf31bbe9226', true),
	('1ef65a39-891a-4ad2-a2c6-bccd3a5f13a6', 'db9c12bd-0cf5-4ad6-b91a-5fe05e28278e', true),
	('7aa926f6-ce2e-4247-812a-c689240cac54', '5997dd98-9199-47c3-9062-edcac0c35e15', true),
	('75cd413e-73ca-4b6a-87b7-dbbb4ffa485c', '46793a03-818d-44da-b97a-7defc7d10d95', true),
	('a3d0478b-2257-4078-b3de-ce8ca0f1f09b', 'd3068534-d6e6-4258-862b-639044f333d1', true),
	('ef9a8b00-2708-41df-acc9-fc5c675f8fb7', '11a4a43e-084c-4529-b9e5-e625029610d2', true),
	('b1ae776f-2bcc-4237-83dd-7fdc843f582b', '770579ff-c223-439f-ae75-09e135ad119d', true),
	('9bb810af-c7e0-48a0-b936-5843a69f2c64', '1df06fb6-38e4-4d3c-ba2b-78dfffb2d94b', true),
	('97ca1988-6de7-4674-8482-5a5baa4c2203', '4082429b-75d1-4025-9347-dbde2c66095a', true),
	('b54bbd98-8ea9-4cca-87ba-c4e34539b6c6', '7f896441-bb93-4330-9bf5-33910ac2a1a5', true),
	('744f18b2-51b2-4525-9d1a-5990dfe9598a', 'd25a1378-e7f2-42b6-b29a-278325543383', true),
	('f98ddfa7-6ee9-4e85-b97d-30acf38f92e0', '9fa9d5fb-65a9-4bdc-ba84-16926141115d', true),
	('1400713f-fd61-470b-a9bc-1428d8228a22', '67ae9d73-35d0-4d8c-9257-2ddb94d4005e', true),
	('70758a6c-5970-4782-93bc-e7b03242129e', 'bdd0c9c4-0e68-400c-bbc5-ea7530175bd0', true),
	('d0ea1f2c-baec-438a-801d-014bc4535392', 'daedfd26-6f85-468c-a438-8325b22f9b55', true),
	('a8b92a45-0527-4d96-a447-655794f07d46', '28965ce4-97eb-46db-bee0-f07961df5e57', true),
	('82243d05-e27c-481c-8646-cd23d6e1156c', '55bde988-e7f5-44bc-8e80-676e94a8d7b4', true),
	('b1c2ad38-5969-4c5d-82e8-958dff480969', 'fe27f281-148f-453e-841e-7d534a950bcf', true),
	('29127bbf-da06-42e5-98c3-dc0ad5947fd4', '044d2948-f803-4b11-8ff6-1b30221bab21', true),
	('9483d5ac-be47-4590-ae47-ed94186bd376', '12f88a02-c1f6-4ef4-adfd-d1944ba576c8', true),
	('b1dc31f6-b63a-4d1c-a6d4-fec41aa9c0ef', '969fcbf8-3ef8-477d-8cb1-068b4cc87265', true),
	('6db6ce3a-5540-41c5-9c78-cfb576c5b061', 'e595304a-e6a9-4df4-9257-ff4a8b957af5', true),
	('7a9d3fea-1169-4319-bcb3-2637c11b13d2', 'bb8ae2c3-bc51-4163-829c-dffe58aa8fc5', true),
	('e21d23b0-23a3-4e28-89e5-12c0059818d2', '040bca99-835e-46bc-8a0c-016284acacb6', true),
	('98130685-8a80-4e6b-839d-e81da8e66baa', '8a4f4c1e-3e1e-4f3f-a376-7adef19456c3', true),
	('13d1b8b6-c6a8-47c1-959e-bcb9d27fc3f9', '6883304a-04a1-42ac-ab90-e577c32af62a', true),
	('4d3f1d5d-59ac-40be-bb40-32f09eafe6b8', 'f964a390-a8ad-4e8f-95d8-b658a30ecb8b', true),
	('5d30cf6f-49cf-42c8-88b8-1ab720bf0dda', 'c7a10392-c663-44a6-ac0d-e8e85d803391', true),
	('fdea59a7-6537-43f2-a5c1-fb83bab3a498', 'a9e5748b-4399-43f6-88f1-69208d4ad705', true),
	('419a482b-1722-4adb-85af-fdcd9d9640f8', '12d21081-6bd1-4b77-a41d-794c84c8cee1', true),
	('f62c29b5-f955-45ae-bc39-2a347bbfa582', '2cabba7b-0f1f-4db8-b759-ea2d777edaa4', true),
	('998775ca-c521-4df1-8cf6-5304b20b5a5e', '542f8e03-38b4-47ba-86f4-9e14cc94fcf3', true),
	('62edb636-34fa-4856-99ca-d06f7ae8354d', '8c2290de-3672-4b43-a358-fbabc5fcc102', true),
	('82d29ae9-0f77-4ee6-a8de-6a9521cec0f3', '14a90c97-bed2-4a64-abb9-8b5491934379', true),
	('948a2896-62e2-4546-b5b8-59b422350235', 'b693ae69-c29b-41d9-8687-d97b44821b2f', true),
	('bb92723a-335c-454b-9a95-def4cc4a6820', 'c5f28944-2333-47b4-9f86-e710464a1c86', true),
	('4144d29e-6d62-4bf6-aa6f-3e7bdc376da2', '6593d095-8b45-4e32-ac35-c4782759faf9', true),
	('923af34d-8cbb-45f8-80f5-513314a15cdf', '8d223105-6f58-4d2f-adee-d92c8b15a60c', true),
	('925bb411-89bd-4d51-ba94-dc3af0ed1de5', 'aa06520e-19cd-465d-b150-d56fd195ff91', true),
	('147a02bd-e737-4d3b-94c0-c2185db187bc', '9f6a1a1a-7bf8-4e27-9894-919ec060a602', true),
	('bbd5f265-3f34-426f-b2b2-f5eefa753d0f', '409ef768-102c-4747-b484-dd9f2b838fe4', true);


--
-- Data for Name: organisation_group; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.organisation_group (organisation_group_id, name, organisation_group_type_id, local_authority_id, open_date, close_date) VALUES
	('0bdbed4b-ed9f-4599-9857-cf4303f9c2dc', 'Federation of Eileen Wade and Milton Ernest VC lower schools', 1, NULL, '2011-01-13', NULL),
	('ff365cd2-9deb-4085-b8a0-ed8cbdc54574', 'Southend Children''s Centres', 2, 'dc9f9e86-8d80-46b7-87bc-e998cafca819', '2016-10-01', NULL),
	('f3236041-d5b7-4aeb-b3ea-7b5b840e749b', 'The Federation of Beaufort School and Langley School', 1, NULL, '2012-04-01', '2020-07-01'),
	('ac3fbe2e-876f-4f2e-9bbe-fd4836f45821', 'The Federation of St Elphege''s RC School', 1, NULL, '2006-01-01', NULL),
	('5f8fb071-987b-46f1-adc3-d478bb98ad56', 'Hazelbury', 2, '987bd60d-dd0c-4707-818f-d4aeb184a7b8', '2015-09-01', NULL);


--
-- Data for Name: group_identifier; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.group_identifier (group_identifier_id, establishment_party_role_id, organisation_group_id, group_identifier_type_id, group_identifier_issuer_id, value, is_current) VALUES
	('77c56254-41fa-485f-aba5-086399cda54e', '30e9a305-ee34-4145-80d3-5330cd63db42', NULL, 1, 1, '2777', true),
	('df1bbf77-a6ec-4eee-8be8-ac522f732e32', '30e9a305-ee34-4145-80d3-5330cd63db42', NULL, 2, 1, 'TR00567', true),
	('191f7e4c-0855-432a-a12d-d853da83eef5', 'c0dd5c60-c867-46ac-9863-b76a5d8ca7f5', NULL, 1, 1, '2779', false),
	('48e112e3-7f9d-4fce-af16-401cad2681ff', 'c0dd5c60-c867-46ac-9863-b76a5d8ca7f5', NULL, 2, 1, 'TR00569', false),
	('91accad1-1419-4f06-9d89-f3767d1c37b6', '71e61308-3848-4c97-b006-36522ce42574', NULL, 1, 1, '4949', true),
	('6b30504b-dc9e-4755-a507-46e984566e56', '71e61308-3848-4c97-b006-36522ce42574', NULL, 2, 1, 'SP00125', true),
	('faca6534-b82e-4969-84c6-de31555f371e', '6b723e23-367e-4493-8020-6d2582851d96', NULL, 1, 1, '23869', true),
	('84afb334-9bb9-46df-8a8a-634830d82317', '6b723e23-367e-4493-8020-6d2582851d96', NULL, 2, 1, 'TR02103', true),
	('497384ef-9275-44d8-932a-a80ff2efe356', '6b723e23-367e-4493-8020-6d2582851d96', NULL, 1, 1, '4737', false),
	('7980a316-9859-43fa-ab38-3b14a5fa3d7b', 'a9a522a2-a357-42e9-899b-81d7d189992d', NULL, 1, 1, '2914', true),
	('de0196da-40b9-4614-941a-63a11f6ebc37', 'a9a522a2-a357-42e9-899b-81d7d189992d', NULL, 2, 1, 'SP00172', true),
	('a47ccf7b-f949-4d8e-babe-7822785d4a6d', 'b554b481-8627-478d-89ef-6cf88fd216a2', NULL, 1, 1, '3839', false),
	('53847e6e-2230-4d63-9fbb-88f473cf0708', 'b554b481-8627-478d-89ef-6cf88fd216a2', NULL, 2, 1, 'TR01385', false),
	('b2a85a3c-65bb-4a5b-8b4f-7fa4eace3535', '3a4c150d-110e-46d7-b07a-fa1ed5224fbb', NULL, 1, 1, '2055', false),
	('2b95e7ca-063b-4f40-9a77-c1b5452ad2c2', '3a4c150d-110e-46d7-b07a-fa1ed5224fbb', NULL, 1, 1, '20364', true),
	('49bdcd06-5f96-4008-b571-cb9524f7751e', '3a4c150d-110e-46d7-b07a-fa1ed5224fbb', NULL, 2, 1, 'TR00009', true),
	('5f5c72b0-2f58-4205-b8b1-ca8df6d252f3', 'dc1aeab7-0da1-42cc-b1e3-484b050716c1', NULL, 1, 1, '1337', true),
	('6dd40459-1236-4c54-bb91-06c14b23349a', '4686dafe-2de4-429b-bec3-83069f2b180e', NULL, 1, 1, '2613', true),
	('1b2663d7-dc93-4091-ad98-a558bebf36a8', '4686dafe-2de4-429b-bec3-83069f2b180e', NULL, 2, 1, 'SP00099', true),
	('53eb308a-893e-4a3c-97ed-1247ce380c70', '593a82d2-f1be-4a03-8345-9933285e6c3b', NULL, 1, 1, '3147', true),
	('0012e0a0-fab3-48b0-bf58-90c4687570d5', '593a82d2-f1be-4a03-8345-9933285e6c3b', NULL, 2, 1, 'TR00830', true),
	('12cf389b-9bd2-4a56-8644-0341048364b3', NULL, '0bdbed4b-ed9f-4599-9857-cf4303f9c2dc', 1, 1, '1809', true),
	('70e8ef0d-a844-46c1-bbcb-351b8327d35d', NULL, 'ff365cd2-9deb-4085-b8a0-ed8cbdc54574', 1, 1, '86052', true),
	('e6fbe34c-a6f3-4dfa-8530-44373518545b', '3a5cafb4-71f7-4cb9-b476-a0ca4f0b1157', NULL, 1, 1, '4920', true),
	('e4f6b5d0-5a2b-4214-8456-d47dbd51de22', '3a5cafb4-71f7-4cb9-b476-a0ca4f0b1157', NULL, 2, 1, 'TR02256', true),
	('3f57b1d5-273a-4825-8024-0d71c4dfe99b', '24c3a6af-4d43-42aa-8474-1747b0b32427', NULL, 1, 1, '3643', true),
	('02809498-1350-41fa-aed7-693c1e9fb5ab', '24c3a6af-4d43-42aa-8474-1747b0b32427', NULL, 2, 1, 'TR01237', true),
	('a4a3ddf5-fed7-4a70-95bb-ab53db9c3e63', '8c7d79bc-bdcd-4b45-8412-2e54b76d4ac5', NULL, 1, 1, '4118', true),
	('429136cb-19d8-4146-8e8b-929c4840f132', '8c7d79bc-bdcd-4b45-8412-2e54b76d4ac5', NULL, 2, 1, 'SP00396', true),
	('0247c6b2-5222-4143-81bc-21b88877086f', 'a7f5851a-6a9a-4adc-a05d-cac6b992064f', NULL, 1, 1, '4119', true),
	('9991bc9b-cc53-438b-86a9-6a0799905654', 'a7f5851a-6a9a-4adc-a05d-cac6b992064f', NULL, 2, 1, 'TR01585', true),
	('42ea877f-23a2-428f-8791-378f97a47b14', '337e88e2-5c9a-45eb-9d14-8aaea96ad32e', NULL, 1, 1, '4075', true),
	('ea472ac7-1047-4d8f-878d-76d27958e838', '337e88e2-5c9a-45eb-9d14-8aaea96ad32e', NULL, 2, 1, 'SP00392', true),
	('a2812399-f4df-4079-b7ea-f77cf60d09fd', 'c5cd7356-5755-4c3b-8cbe-61733964fa64', NULL, 1, 1, '4076', true),
	('656e4515-f26d-4d17-b164-6309bd32d25a', 'c5cd7356-5755-4c3b-8cbe-61733964fa64', NULL, 2, 1, 'TR01553', true),
	('337c8100-d888-45b7-b2d1-b73a41d1662a', '67621ccd-c9a3-4967-9310-704025d5e5ac', NULL, 1, 1, '1193', true),
	('9cab1f95-1471-4f3a-a0b0-ef5aa0ea617d', '991e5121-89c0-433e-8d79-c86af82c7670', NULL, 1, 1, '3641', true),
	('8ff4dd8e-e5ae-40ab-b265-0f7a2c4c96f4', '991e5121-89c0-433e-8d79-c86af82c7670', NULL, 2, 1, 'TR01236', true),
	('61567558-416b-420a-8bab-7039880ca3b4', '69449a85-7744-4292-94ec-8e8222aa16fa', NULL, 1, 1, '2904', true),
	('254d4267-e3f2-4500-9e4d-cdfaddfe0643', '69449a85-7744-4292-94ec-8e8222aa16fa', NULL, 2, 1, 'SP00160', true),
	('f9f9b78e-a5eb-4dc3-943a-ac8d8f9d052b', '698a28ae-9ff0-4eae-ad39-5a835d202978', NULL, 1, 1, '2905', true),
	('c7792a2b-5211-41ec-8773-7c624fcc326c', '698a28ae-9ff0-4eae-ad39-5a835d202978', NULL, 2, 1, 'TR00661', true),
	('5ebc9aef-3435-433d-bfb5-b4d88fafdba8', 'f3dc0261-9446-4249-a876-a9d55088d6d5', NULL, 1, 1, '2347', false),
	('c7a21cc5-76c0-4ab1-8e00-c8dc67bd693b', 'f3dc0261-9446-4249-a876-a9d55088d6d5', NULL, 2, 1, 'TR00230', false),
	('ad9c98f6-070a-4c4e-a42e-0f7afc6913dd', '0b7eee62-a8c6-4a50-9e79-9b49c9085e66', NULL, 1, 1, '1650', true),
	('8965211a-cb0e-4019-ba37-a4b1fb96edb1', NULL, 'f3236041-d5b7-4aeb-b3ea-7b5b840e749b', 1, 1, '1537', false),
	('d72c95a9-eeb5-4918-8249-051f02515c33', NULL, 'ac3fbe2e-876f-4f2e-9bbe-fd4836f45821', 1, 1, '1761', true),
	('f4e58cd4-2f7b-4240-8203-d8a9b92dbadb', NULL, '5f8fb071-987b-46f1-adc3-d478bb98ad56', 1, 1, '86008', true),
	('221ba872-cff6-4f2e-a2ce-fefe40664b06', '6a61d989-8a13-4afa-bd3e-104a1175703c', NULL, 2, 1, 'TR03305', true),
	('84632ca1-0bbc-4312-8bf4-7b4d66c5e3d5', '9d27858e-173c-4179-8119-617a3dd8ce2e', NULL, 1, 1, '16279', false),
	('e3842b44-c7b9-43ee-ab73-dcf5581eddb9', '9d27858e-173c-4179-8119-617a3dd8ce2e', NULL, 2, 1, 'TR03305.old', false),
	('fd471250-12a2-466f-b0ae-3d4d58801202', '9d27858e-173c-4179-8119-617a3dd8ce2e', NULL, 1, 1, '17115', false),
	('8c4d3f33-891a-45b8-a5b1-ebb2cda9fc48', '9d27858e-173c-4179-8119-617a3dd8ce2e', NULL, 2, 1, 'TR03305.old2', false),
	('bb23057d-087e-4359-b34f-ea6c0619a341', '6a61d989-8a13-4afa-bd3e-104a1175703c', NULL, 1, 1, '17397', true);


--
-- Data for Name: legal_entity_address; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.legal_entity_address (legal_entity_address_id, legal_entity_id, address_id, address_purpose_id, start_date, end_date, is_current) VALUES
	('27510e70-5a1b-42fa-81b8-153ed0e1eba8', '05248c5c-bce4-4819-afb8-95d6304aad86', 'fdf88c8d-831c-4ae7-9378-d183f087d931', 3, NULL, NULL, true),
	('76227379-7338-4f2c-800e-409da9d8d663', '980686ef-fef1-4cb2-81ba-f9df2b6e4df1', 'fdf88c8d-831c-4ae7-9378-d183f087d931', 3, NULL, NULL, true);


--
-- Data for Name: organisation_group_address; Type: TABLE DATA; Schema: establishment; Owner: -
--



--
-- Data for Name: organisation_group_member; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.organisation_group_member (organisation_group_member_id, organisation_group_id, establishment_id, joined_date, left_date) VALUES
	('c24402de-080c-49d6-ae4c-9b26f04e95eb', '0bdbed4b-ed9f-4599-9857-cf4303f9c2dc', 'a3d0478b-2257-4078-b3de-ce8ca0f1f09b', '2011-01-13', NULL),
	('c3844739-12f8-4ecc-9d2e-703c9afcde46', '0bdbed4b-ed9f-4599-9857-cf4303f9c2dc', '75cd413e-73ca-4b6a-87b7-dbbb4ffa485c', '2011-01-13', NULL),
	('74bbeb7e-8582-4c3b-a207-b7f0290553ea', 'ff365cd2-9deb-4085-b8a0-ed8cbdc54574', 'b1ae776f-2bcc-4237-83dd-7fdc843f582b', '2016-10-01', NULL),
	('b4d8613f-bd12-4ca7-b4b9-bd2bab6f01fe', 'ff365cd2-9deb-4085-b8a0-ed8cbdc54574', '9bb810af-c7e0-48a0-b936-5843a69f2c64', '2016-10-01', NULL),
	('1acda590-f8ca-45ab-bb38-2266c6efb3fb', 'ff365cd2-9deb-4085-b8a0-ed8cbdc54574', '70758a6c-5970-4782-93bc-e7b03242129e', '2016-10-01', NULL),
	('27ac814f-b06b-4cf7-a6d5-ca91434fb4c3', 'ff365cd2-9deb-4085-b8a0-ed8cbdc54574', 'b54bbd98-8ea9-4cca-87ba-c4e34539b6c6', '2016-10-01', NULL),
	('3946bf44-ebdc-4079-8af5-01b1dbea0fa2', 'ff365cd2-9deb-4085-b8a0-ed8cbdc54574', '1400713f-fd61-470b-a9bc-1428d8228a22', '2016-10-01', NULL),
	('91288ef1-1f6a-4f9f-8de0-16d9968418b8', 'ff365cd2-9deb-4085-b8a0-ed8cbdc54574', 'ef9a8b00-2708-41df-acc9-fc5c675f8fb7', '2016-10-01', NULL),
	('6e3f3b44-970e-43f8-8403-ffa345088d49', 'ff365cd2-9deb-4085-b8a0-ed8cbdc54574', 'f98ddfa7-6ee9-4e85-b97d-30acf38f92e0', '2016-10-01', NULL),
	('a1751dcc-7ddc-4e54-9ddd-bc211ddb9c18', 'ff365cd2-9deb-4085-b8a0-ed8cbdc54574', '744f18b2-51b2-4525-9d1a-5990dfe9598a', '2016-10-01', NULL),
	('3960f837-124f-416a-8468-de1036bd9f59', 'ff365cd2-9deb-4085-b8a0-ed8cbdc54574', '97ca1988-6de7-4674-8482-5a5baa4c2203', '2016-10-01', NULL),
	('bb4117ff-93e3-4d4a-addb-63b1433984d6', 'f3236041-d5b7-4aeb-b3ea-7b5b840e749b', 'fdea59a7-6537-43f2-a5c1-fb83bab3a498', '2012-04-01', '2020-06-16'),
	('2937f8fc-733c-4437-bf3f-a447c664db87', 'ac3fbe2e-876f-4f2e-9bbe-fd4836f45821', '998775ca-c521-4df1-8cf6-5304b20b5a5e', '2006-01-01', NULL),
	('4e30ba26-a695-4730-90e1-e3bdf5102bb6', 'ac3fbe2e-876f-4f2e-9bbe-fd4836f45821', '419a482b-1722-4adb-85af-fdcd9d9640f8', '2014-09-15', NULL),
	('1f4ba198-36ee-47e7-86be-9aa5aeb28aea', 'ac3fbe2e-876f-4f2e-9bbe-fd4836f45821', 'f62c29b5-f955-45ae-bc39-2a347bbfa582', '2006-01-01', NULL),
	('d9ec6c20-0581-4c65-ab93-36bd0c2e303a', '5f8fb071-987b-46f1-adc3-d478bb98ad56', 'bb92723a-335c-454b-9a95-def4cc4a6820', '2016-02-01', NULL),
	('b3f25f2e-80ec-40e0-9517-576ac4311bd2', '5f8fb071-987b-46f1-adc3-d478bb98ad56', '925bb411-89bd-4d51-ba94-dc3af0ed1de5', '2016-02-01', NULL),
	('873cc2c0-a966-45e3-a948-235eb44903c0', '5f8fb071-987b-46f1-adc3-d478bb98ad56', '62edb636-34fa-4856-99ca-d06f7ae8354d', '2016-02-01', NULL),
	('1e330b1a-e445-4be9-93f4-99cd3d03b5ed', '5f8fb071-987b-46f1-adc3-d478bb98ad56', '923af34d-8cbb-45f8-80f5-513314a15cdf', '2016-02-01', NULL),
	('34382209-8b95-4c7c-a407-0bb7b95966ae', '5f8fb071-987b-46f1-adc3-d478bb98ad56', '948a2896-62e2-4546-b5b8-59b422350235', '2016-02-01', NULL),
	('dd05683f-d9a6-4844-a62e-a0cb9d07fcad', '5f8fb071-987b-46f1-adc3-d478bb98ad56', '4144d29e-6d62-4bf6-aa6f-3e7bdc376da2', '2016-02-01', NULL),
	('2ab44ef9-d637-452c-afac-b4fd72e3b057', '5f8fb071-987b-46f1-adc3-d478bb98ad56', '82d29ae9-0f77-4ee6-a8de-6a9521cec0f3', '2016-02-01', NULL);


--
-- Data for Name: organisation_group_member_lead_period; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.organisation_group_member_lead_period (organisation_group_member_lead_period_id, organisation_group_member_id, organisation_group_id, start_date, end_date, is_current) VALUES
	('1f56999e-f498-4052-b2c6-f96464073b39', '74bbeb7e-8582-4c3b-a207-b7f0290553ea', 'ff365cd2-9deb-4085-b8a0-ed8cbdc54574', NULL, NULL, true),
	('e6fbb57e-bfa6-4ade-a06f-f7e5cf8f4eba', 'd9ec6c20-0581-4c65-ab93-36bd0c2e303a', '5f8fb071-987b-46f1-adc3-d478bb98ad56', NULL, NULL, true);


--
-- Data for Name: organisation_identifier; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.organisation_identifier (organisation_identifier_id, legal_entity_id, organisation_identifier_type_id, value, is_current) VALUES
	('aa0dfa3a-17c0-42e2-a4de-50c3d7d81997', '05248c5c-bce4-4819-afb8-95d6304aad86', 1, '07747126', true),
	('dd8d4ec4-b9e5-4898-89d9-46226eca8831', '05248c5c-bce4-4819-afb8-95d6304aad86', 2, '10059286', true),
	('3f780869-7157-490d-b9dc-0c9560413a07', '980686ef-fef1-4cb2-81ba-f9df2b6e4df1', 1, '07158839', true),
	('5a88902c-0149-4238-8c6e-1074a1fa21f9', '980686ef-fef1-4cb2-81ba-f9df2b6e4df1', 2, '10061289', true),
	('e854db53-5bf3-4b38-9526-4a664b6478fe', '6193bf84-dbf3-4d71-a654-29c2acfdb732', 1, '05412502', true),
	('beea889a-c592-4aa3-b994-c7fa85892305', '6193bf84-dbf3-4d71-a654-29c2acfdb732', 2, '10058191', true),
	('462f2c8e-43d5-49a6-976a-b91097df35eb', '87fb0d50-8169-4ac1-b928-61d9bbea878e', 1, '06888873', true),
	('5e6cc334-17b6-4bfc-a94f-62713c4e316c', '3ecc1d6b-978e-4e6c-b3d6-222db56217da', 1, '07795736', true),
	('e440ac29-6bcf-4fc8-ab6f-cd4f8c6a10a0', '3ecc1d6b-978e-4e6c-b3d6-222db56217da', 2, '10059335', true),
	('3bc9e05e-4a76-4387-952b-0375d7430d6d', '1c8f582a-5dee-4bed-8919-31b2c9781457', 1, '06960253', true),
	('e4209452-9151-4d66-85ed-6271bbb8fe69', '1c8f582a-5dee-4bed-8919-31b2c9781457', 2, '10058269', true),
	('de1bc459-7929-4c20-8049-c04ff59bbc50', 'c59c4cdc-01e4-4656-830c-e5f634e3d717', 1, '07518252', true),
	('140a1974-8363-4136-a6a4-4e9d35d4d0ca', 'c59c4cdc-01e4-4656-830c-e5f634e3d717', 2, '10058494', true),
	('b42d8674-9666-4513-a992-1d2f78d47fba', 'd5536b33-b3ba-47e6-b8ec-20db8c85f72b', 1, '07451553', true),
	('75ee0cce-4726-43e8-ab9f-8fbd4e8c14fd', 'd5536b33-b3ba-47e6-b8ec-20db8c85f72b', 2, '10058417', true),
	('d2ccae8f-96ff-4721-9d79-1471f57bbcf3', 'c08b2b23-bf2a-47c8-b2c4-09ebd67525fd', 1, '06995649', true),
	('08e8b123-993f-4e67-8bdb-5bcc428d1313', 'c08b2b23-bf2a-47c8-b2c4-09ebd67525fd', 2, '10058273', true),
	('e9809c23-db91-4553-9263-3d67fd4091f7', '8656f963-c3dd-4a30-a6c6-326ca448884e', 1, '05398529', true),
	('b8cf96e9-f45b-4903-9074-edcff0378ca3', '8656f963-c3dd-4a30-a6c6-326ca448884e', 2, '10058190', true),
	('500ff3cb-77f2-40c2-b47a-ba0584f7d59a', 'a4099bbe-ea70-4371-96a2-55be90d5872f', 1, '07706900', true),
	('4a7c0e75-aab2-4f20-b047-eb058169a617', 'a4099bbe-ea70-4371-96a2-55be90d5872f', 2, '10059149', true),
	('c2d01759-047b-4091-b256-f7c2ae768fa9', 'f1a6af5f-7134-4e63-8562-c4fbb5eaf072', 1, '08464996', true),
	('ba32d727-00f2-4757-99c7-96a03bc9d1aa', 'f1a6af5f-7134-4e63-8562-c4fbb5eaf072', 2, '10060395', true),
	('9e8a631f-d541-4650-b48a-5a3c447cb933', '37bcaf9f-f610-4193-b942-b02ecdc1367b', 1, '07556132', true),
	('745c2478-3c3b-4857-8dea-7e37dbdbb62f', '01f1c31f-c774-47fc-a358-51ba5bc40df3', 1, '08782697', true),
	('b97c96bf-21a2-4ab1-ad30-82d51ea73fe1', '01f1c31f-c774-47fc-a358-51ba5bc40df3', 2, '10064301', true);


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
	('48994f37-b520-421c-be40-5fef9ad67bf3', '2df98956-98dd-4035-a83e-7a9803203809', 11, 16),
	('3a688b8b-8c27-45ff-a0ff-31f1572d809e', '0ee70364-63a0-420b-8474-4485708f49e4', 4, 19),
	('26c378a3-e01f-44db-a019-4a09525fca8a', 'ca8731e7-a16a-4c83-ba2f-dbb7d2331e14', 11, 19),
	('e119dd34-ba74-4cb0-a825-ac0e5c098999', '98933169-56e7-4729-a815-513351060c01', 5, 11),
	('95487241-3e26-4202-9411-1d0a9dabba8d', '9c1b3c7f-d88c-43df-b1af-8598e45c8a90', 4, 11),
	('91f5c881-a5d7-44e2-941d-4c3493cabcb5', 'ffb9e5f1-44d9-4c6c-94e1-ad65e6612e69', 3, 11),
	('4c2d8a61-e8f1-416b-a01e-42489bc1c85f', '4a9cc2f8-1b16-43cf-8da3-97acad4c84ff', 11, 16),
	('7ccab87d-50d5-4764-8a32-2a4a562e3a79', '9bc925d3-9a9d-416e-826f-afab3916c0e7', 5, 19),
	('8a789aca-382f-42ab-8e5a-4fb200af4d93', '330b7001-22b1-4326-9d18-9e08378230ed', 5, 18),
	('8e004979-4673-49c4-9972-d3d0a15ac5d2', 'edc5b783-ee89-4e55-9f33-39385867638b', 11, 18),
	('bd4a7edb-07b9-4b06-aaee-5d883e38e7e8', '873cb24e-668e-4770-88d5-1841b16dd0d7', 11, 18),
	('c61f302a-b884-4719-99c5-34cad7064b4c', '4b3e3325-2e3b-4769-9b3f-b6a51e2fb262', 11, 18),
	('09a35750-64bc-4c6d-ae47-783c4bcd1b4f', '188e3d1b-ac8d-4a5a-ae11-2afe02f094c8', 6, 19),
	('e5667400-76f0-4191-9f28-6e234299980c', 'ad9d05c6-4f00-4b4c-8994-b90738aedb69', 11, 18),
	('562d6525-d5e4-412b-9c1a-9d7f025366c8', '646c9c1b-8ded-4403-a2e7-f15b597d5752', 3, 18),
	('ae2625c7-6b4b-41dc-adf3-d43b6a810ded', '4d99a32f-c9ca-4829-a7e7-8f95ea70f085', 4, 11),
	('e76b6b54-b4ba-4eea-aa2c-8f707708c453', 'a5741da6-c7e0-4855-90c3-755d1b2b87d3', 14, 19),
	('536c4ff3-ae37-4e47-8c65-16414e0fe723', 'dd493941-f518-4794-9646-6fd4e405fe58', 11, 19),
	('4acfd726-c822-4ab3-b5c8-4d455e2b6af2', '1e68a170-d53a-4c13-a42b-f795ca20a25e', 3, 11),
	('859a8025-3d88-4d73-8954-6bd149c2cd04', 'c264083f-9f9a-413e-b7ca-9027344d9a22', 4, 11),
	('f3fd1808-fa39-4c32-8cfa-3ab0b113aaf9', '8dac98aa-6528-4d05-9e4d-e6b9c1e45ea6', 7, 11),
	('e6c408f6-d179-480d-bf8c-c123bacca661', '7dc4ff2b-809b-48ae-8533-41a8e692b0f1', 3, 7),
	('de0f7f84-d60c-486b-b4ab-41bdcc116270', '689541c3-3098-4608-96ef-6ff757eecc0e', 5, 18),
	('f4627c93-141f-471f-ad8c-c88996bb95a5', '72c1eaa3-be5c-4c3f-a3b6-794e7eaef747', 4, 19);


--
-- PostgreSQL database dump complete
--

\unrestrict flgJrhQPUKE5GayHQNVmsqQw0r4vWKOIiquvaNzHETx6QLs7p0GoZMaxGLloN2B

