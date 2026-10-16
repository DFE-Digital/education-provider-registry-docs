--
-- PostgreSQL database dump
--

\restrict RM9PhMQLlrQ5daQlLBNkCeqgok7aZLQU2tjao9wjxm5h5p8EJVJt3k3yW0ECeyO

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
	('a6af2721-825e-4cb9-afb8-d596208173f8', 'Trust in Learning', NULL, NULL, NULL, NULL),
	('55a5f300-b304-421c-aa4e-1ae2b909b83d', 'THE CO-OPERATIVE ACADEMIES TRUST', 1, NULL, '2011-08-19', NULL),
	('dfbfa842-402d-4c6c-8f07-c2b123d9ab41', 'THE CO-OPERATIVE ACADEMY OF STOKE ON TRENT', 1, NULL, '2010-02-16', NULL),
	('e3e521ea-7d27-4a6f-a696-52f65a16ff48', 'The Co-operative Group', NULL, NULL, NULL, NULL),
	('cb3d2596-28a8-411a-8651-856d75b4e650', 'HIVE EDUCATION TRUST', 1, NULL, '2005-04-04', NULL),
	('65847c51-02b7-4222-92f0-1a2bbdb3d631', 'Diocese of London', NULL, NULL, NULL, NULL),
	('853b8dd4-cd78-4aba-82ce-7b0c207aceac', 'THE ACADEMY @ RIDGEWOOD TRUST', 1, NULL, '2011-10-03', NULL),
	('28c6cbfe-daa3-479e-aed8-94eae82ebd11', 'The North Tyneside Learning Trust', NULL, NULL, NULL, NULL),
	('511a8952-b41c-44de-9706-d8791fad664f', 'DUNSTONE EDUCATION TRUST', 1, NULL, '2009-07-13', NULL),
	('5be037f1-12fc-4b40-829c-4135c96fc783', 'Acorn Care and Education Ltd', NULL, NULL, NULL, NULL),
	('27546d94-e327-49fd-aecb-26c8c043a597', 'The King''s School', NULL, NULL, NULL, NULL),
	('e6aa6cec-8ee5-47ae-aa64-3a30e0e274a9', 'THE KING''S SCHOOL', 1, NULL, '2011-07-15', NULL),
	('6e00145a-8739-4de7-aaf9-00b88630cd3f', 'EDUCATION SOUTH WEST', 1, NULL, '2010-11-25', NULL),
	('00ad3b7a-1658-4128-9152-ac9746cb7013', 'TEMPLER ACADEMY SCHOOLS TRUST', 1, NULL, '2011-02-04', NULL),
	('23f9cb5e-203e-46a1-bb04-d1960561b15c', 'Diocese of Ely', NULL, NULL, NULL, NULL),
	('8c583f6f-fcbf-48be-a29a-82659646e8e1', 'GRACE SCHOOLS', 1, NULL, '2013-03-27', NULL),
	('5a5c9b6b-7f1c-455d-9909-0cc4fa456001', 'OUTWOOD GRANGE ACADEMIES TRUST', 1, NULL, '2009-08-19', NULL),
	('e471a59d-d17b-422b-9851-b3121c88a757', 'BLACK COUNTRY UTC', 1, NULL, '2011-03-08', NULL),
	('1a3eaa21-e772-49da-ac8b-f26c74c310bd', 'OASIS COMMUNITY LEARNING', 1, NULL, '2005-03-18', NULL),
	('b84e131a-4d76-498c-8cde-b487fca42fd7', 'MARCH 2016 LIMITED', 1, NULL, '2009-04-27', NULL),
	('07499405-9190-472f-ac28-39e405b9afb8', 'Four Oaks Learning Trust For Excellence', NULL, NULL, NULL, NULL),
	('73d09caa-5883-4fdb-b6b4-c4c45d56a221', 'Mr & Mrs Readhead (Partnership)', 12, NULL, NULL, NULL),
	('d28c88c1-6741-4fe9-ba5c-4ae4305d1fa0', 'THE NORTHAMPTON FREE SCHOOL TRUST', NULL, NULL, NULL, NULL),
	('ee7f7d2b-c26b-4726-a6d4-d68d5dc73ef3', 'WOOTTON PARK ACADEMY TRUST', 1, NULL, '2013-11-20', NULL);


--
-- Data for Name: academy_trust_classification; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.academy_trust_classification (academy_trust_classification_id, legal_entity_id, academy_trust_type_id, start_date, end_date, is_current) VALUES
	('2e53d394-a6a4-464d-b758-98de5d497a25', '55a5f300-b304-421c-aa4e-1ae2b909b83d', 2, NULL, NULL, true),
	('5f09540b-933b-471f-9b07-c493439ef6fe', 'dfbfa842-402d-4c6c-8f07-c2b123d9ab41', 1, NULL, NULL, false),
	('db0109d8-9f48-43f4-a1f7-3d9068fd4b3d', 'cb3d2596-28a8-411a-8651-856d75b4e650', 2, NULL, NULL, true),
	('ddcb3109-edba-4236-8802-72fb17ebdc30', 'cb3d2596-28a8-411a-8651-856d75b4e650', 1, NULL, NULL, false),
	('f93a9c27-1cee-4579-aaf5-a0b82ea6bdce', '853b8dd4-cd78-4aba-82ce-7b0c207aceac', 1, NULL, '2021-03-30', false),
	('d5319a2b-3688-4ea8-bdf2-6a1cb2766f8c', '853b8dd4-cd78-4aba-82ce-7b0c207aceac', 2, '2021-03-30', NULL, true),
	('2c785798-1aed-4610-b15b-0be7efcb7340', '511a8952-b41c-44de-9706-d8791fad664f', 2, NULL, NULL, true),
	('be365022-5f57-4207-8355-4d4719d80f44', '6e00145a-8739-4de7-aaf9-00b88630cd3f', 2, NULL, NULL, true),
	('1a8657a7-bca6-4878-9e95-efa5fd9a5a90', '00ad3b7a-1658-4128-9152-ac9746cb7013', 2, NULL, NULL, true),
	('9ea740b6-a169-4d01-8dcd-7e5eeb61be6f', '5a5c9b6b-7f1c-455d-9909-0cc4fa456001', 2, NULL, NULL, true),
	('1cb3d721-975e-4517-a740-cfa62993e72c', '1a3eaa21-e772-49da-ac8b-f26c74c310bd', 2, NULL, NULL, true),
	('bbb46cb6-fbb1-4a33-b3e4-b250995e4dd1', 'e6aa6cec-8ee5-47ae-aa64-3a30e0e274a9', 1, NULL, NULL, true),
	('377530cc-2184-499c-b8b3-ff1d0ec4ffa4', '8c583f6f-fcbf-48be-a29a-82659646e8e1', 2, NULL, NULL, true),
	('5715733d-895b-4236-a51b-785af80d31c0', 'e471a59d-d17b-422b-9851-b3121c88a757', 1, NULL, '2015-08-31', false),
	('74d53fad-e27d-4a63-a9f9-080b1b11bab9', 'b84e131a-4d76-498c-8cde-b487fca42fd7', 2, NULL, '2016-02-29', false),
	('b694796d-0739-41ac-9c77-e4aedd5dc821', 'ee7f7d2b-c26b-4726-a6d4-d68d5dc73ef3', 1, NULL, NULL, true),
	('ba6689fc-9a85-44d6-9712-27e9d0401f2b', 'd28c88c1-6741-4fe9-ba5c-4ae4305d1fa0', 2, '2018-10-09', '2019-07-09', false),
	('242ec154-07fd-447a-a7df-353d590dfbe6', 'd28c88c1-6741-4fe9-ba5c-4ae4305d1fa0', 1, NULL, '2018-10-09', false);


--
-- Data for Name: address; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.address (address_id, address_line_1, address_line_2, address_line_3, town, county, postcode) VALUES
	('b2ecd0d4-a56b-44e6-8e04-47f7b7cd4d60', 'obfuscated', NULL, 'obfuscated', 'obfuscated', '032', 'ST6 4LD'),
	('95ea5eeb-892d-496c-9916-096944f2ff36', 'obfuscated', 'Islington', NULL, 'obfuscated', '099', 'N7 8PG'),
	('dd60d0aa-2899-4aff-9593-6334d612d751', 'obfuscated', 'Scawsby', NULL, 'obfuscated', '031', 'DN5 7UB'),
	('0cbb76b0-7252-4328-a3d9-4cac580f526e', 'obfuscated', 'Upper Dean', NULL, 'obfuscated', '003', 'PE28 0ND'),
	('ae61d11d-9568-40d1-b76f-b5667e6c6be0', 'obfuscated', 'Milton Ernest', NULL, 'obfuscated', '001', 'MK44 1RF'),
	('c2857431-87de-4cd5-a1b0-67d88f8cd095', 'obfuscated', 'School Way', 'obfuscated', 'obfuscated', '012', 'SS9 4HX'),
	('181025f3-b1d9-40a2-a52b-a5d2109c9694', 'obfuscated', NULL, NULL, 'obfuscated', '012', 'SS1 1ES'),
	('7ff2bad4-00b7-467d-abd9-ae3dd825808e', NULL, 'Centre Place', 'obfuscated', 'obfuscated', '012', 'SS1 2JD'),
	('f49c8022-c6f7-4cbd-9ff8-ccff8a620133', 'obfuscated', 'Hamstel Road', NULL, 'obfuscated', '012', 'SS2 4PQ'),
	('795eec1a-aeef-41f1-a4df-7e0258016783', 'obfuscated', NULL, NULL, 'obfuscated', '012', 'SS0 0LG'),
	('e2f54a48-3618-4c12-b340-15e0f3006d21', 'obfuscated', 'Constable Way', NULL, 'obfuscated', '012', 'SS3 9XX'),
	('35e7e71e-e139-4ed8-a49e-9f75b8af36f6', 'obfuscated', NULL, NULL, 'obfuscated', '012', 'SS0 7AU'),
	('fdfacb5e-9ed7-40c6-bb2e-11ac5a3ee363', 'obfuscated', 'Rayleigh Road', 'obfuscated', 'obfuscated', '012', 'SS9 5UT'),
	('c2bb1d15-7d19-48d9-83a5-322b33e59889', 'obfuscated', 'Eastern Avenue', NULL, 'obfuscated', '012', 'SS2 4BA'),
	('991e4e48-f793-4a9b-8c4e-fa3352883637', 'obfuscated', NULL, NULL, 'obfuscated', '035', 'NE28 9RT'),
	('3fae8037-cdba-46f3-8e8f-be79dad785aa', 'obfuscated', NULL, 'obfuscated', 'obfuscated', '019', 'PR2 9YR'),
	('05967a2e-c7c0-478b-91cb-4cf58fac5f17', 'Kirkby Lonsdale', NULL, NULL, 'Carnforth', '019', 'LA6 2DZ'),
	('95ce68e2-71c3-46b4-866e-cf421e1b82b1', 'Egerton Road', 'Charing Heath', NULL, 'Ashford', '018', 'TN27 0AX'),
	('e7ab13ee-590a-4fbd-b879-315b337ab19d', 'WESTWARD HO', 'LEISTON', 'SUFFOLK', 'Leiston', '033', 'IP16 4HY'),
	('102bbf17-ca4d-4c0b-a7fd-9bf9944d561c', '1 Angel Square', NULL, NULL, 'Manchester', NULL, 'M60 0AG'),
	('1c26eb64-8dcf-4600-8cea-cd6262c689e8', 'obfuscated', NULL, NULL, 'obfuscated', '099', 'NN4 0JA'),
	('7d93f740-1d47-4dd3-949f-bab2b46f4e19', 'Liverpool Road', 'Islington', NULL, 'London', NULL, 'N7 8PG'),
	('5c58eb5d-26f0-4b4e-8c84-7cfabbb2171e', 'Ridgewood School Barnsley Road', 'Scawsby', NULL, 'Doncaster', NULL, 'DN5 7UB'),
	('63f812ed-8fe1-49dc-998b-a1e664f87f3a', 'Dunstone Education Trust Black Bull Lane', 'Fulwood', NULL, 'Preston', NULL, 'PR2 9YR'),
	('38becec9-0b08-488f-8dcd-755e4f8c9ae5', 'Wootton Park School Wootton Hall Park', 'Wootton', NULL, 'Northampton', NULL, 'NN4 0JA'),
	('06bcffd1-429a-4bc2-a0a7-48d873227cd0', 'obfuscated', 'Kingsteignton', NULL, 'obfuscated', '008', 'TQ12 3JG'),
	('e1ea8411-76b7-49a5-8ee0-aa375e6f30c1', 'Wootton Park School', 'Wootton Hall Park', NULL, 'Northampton', NULL, 'NN4 0HZ'),
	('1067a22a-6844-4a04-a2d9-560db0f289f5', NULL, 'Balkwill Road', NULL, 'Kingsbridge', NULL, 'TQ7 1PL'),
	('f9b11c38-9fb5-43b2-9edb-b139a3d24b70', 'Teign School Chudleigh Road', 'Kingsteignton', NULL, 'Newton Abbot', NULL, 'TQ12 3JG'),
	('8c9d6190-35d0-4c0b-8875-6b9c57308b9e', 'obfuscated', 'Outwood', NULL, 'O6kryuf7yc6', '039', 'WF1 2PF'),
	('591e6319-eced-473c-a2f2-b04721c3b236', NULL, NULL, NULL, NULL, NULL, NULL),
	('ff63e911-f803-46a8-b294-b90f38e07dbe', 'Potovens Lane', 'Outwood', 'obfuscated', 'Wakefield', NULL, 'WF1 2PF'),
	('7438f2f2-6e5d-40bb-99bd-54ecccdcc96d', 'obfuscated', 'Innova Park', NULL, 'obfuscated', '058', 'EN3 7XH'),
	('222c9481-d10d-4eea-b268-18cb5b6490ae', '75 Westminster Bridge Road', NULL, NULL, 'London', NULL, 'SE1 7HS'),
	('d1a5c94c-71d3-4832-bf9d-9d03d822c9c3', 'obfuscated', 'Teyfant Road', 'obfuscated', 'obfuscated', '099', 'BS13 0RG'),
	('6a8a846c-0406-481d-a71f-a1bc9ec7741c', 'obfuscated', NULL, NULL, 'obfuscated', '021', 'NG31 6RP'),
	('34cc9a8f-7352-4a25-9f1d-eb0d1a3d76c8', 'Pitt Street', NULL, NULL, 'Gloucester', '013', 'GL1 2BG'),
	('0dc77638-e1c7-4ce1-b2fa-550084604543', 'The King''s School', 'Brook Street', NULL, 'Grantham', NULL, 'NG31 6RP'),
	('fe7c02b6-d604-4404-8116-561b23d7c8a6', 'obfuscated', 'Bury', NULL, 'obfuscated', '003', 'PE26 2NJ'),
	('9c8503d8-9f53-4434-8357-6f3e4ea79867', 'Grace Building', '8 High Street', NULL, 'Ely', NULL, 'CB7 4JU'),
	('8a7e080c-0e81-4cdb-8e63-c652c4417a57', 'obfuscated', NULL, NULL, 'obfuscated', '037', 'WS3 2PA'),
	('50b1a490-3ff6-4883-934c-d38d6a643367', 'Walsall College', 'Littleton Street West', NULL, 'Walsall', NULL, 'WS2 8ES'),
	('8512bd55-9a5b-4918-a0de-4d32a0cbc504', 'obfuscated', 'Blackley', NULL, 'obfuscated', '099', 'M9 7SS'),
	('891e80ad-b535-4de3-b956-0e115851ae7b', '300 Victoria Avenue East Victoria Avenue East', 'Blackley', NULL, 'Manchester', NULL, 'M9 7SS'),
	('a0a23bd2-1a88-45b0-b220-c9d6f0c9fd68', 'obfuscated', NULL, NULL, 'obfuscated', '037', 'B75 6TJ'),
	('358b768f-c8e2-4db8-a275-7b1acc962acb', 'obfuscated', NULL, NULL, 'obfuscated', '034', 'CR2 6DF'),
	('735d6e40-9a31-4183-adbb-27517cc7f11d', 'obfuscated', 'Roundshaw', NULL, 'obfuscated', '034', 'SM6 9HY'),
	('c2172dce-8b4c-4981-8139-9c891226d37f', 'obfuscated', 'Roundshaw', NULL, 'obfuscated', '034', 'SM6 9HY'),
	('955b01d8-c2c2-44ec-a3c2-ec180f99872b', 'obfuscated', NULL, NULL, 'obfuscated', '058', 'EN3 5PA'),
	('e7e7b5cf-336c-4711-877a-d68247ea9550', 'obfuscated', NULL, NULL, 'obfuscated', '058', 'EN1 4JY'),
	('743fe226-b711-4eaa-8ef6-5dd9e886d033', 'obfuscated', 'New Southgate', NULL, 'obfuscated', '000', 'N11 1RR'),
	('83451d87-de52-4f42-83a6-04e1a4154d16', 'obfuscated', 'Edmonton', NULL, 'obfuscated', '000', 'N9 9TT'),
	('beaaaf41-348e-4367-bfe8-be927f176932', 'obfuscated', 'Hazelwood School', 'obfuscated', 'obfuscated', '058', 'N13 5HE'),
	('4993a886-746d-4091-88b9-8431cb4b43fc', 'obfuscated', 'Enfield', NULL, 'obfuscated', '058', 'EN1 4RE'),
	('4e8725ea-27cf-40cc-b4f0-1166481b093a', 'obfuscated', NULL, NULL, 'obfuscated', '000', 'EN3 6HG');


--
-- Data for Name: establishment; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment (establishment_id, urn, ukprn, establishment_number, name, establishment_type_id, education_phase_id) VALUES
	('a8538208-f08a-48a8-bd74-10aecdde50bf', 136102, 10030216, 6905, 'The Co-Operative Academy of Stoke-On-Trent', 4, 5),
	('4e1f7553-2c83-4e4a-9d4e-8a65a913ae37', 134314, 10024207, 6905, 'St Mary Magdalene Academy', 4, 6),
	('3f96fa85-9b22-43fd-9cd2-c83cb5df5206', 137603, 10035482, 4033, 'Ridgewood School', 4, 5),
	('ebab3c21-fd1a-4ec5-9308-48135237ef1d', 109443, 10077509, 2036, 'Eileen Wade Primary School', 11, 2),
	('3a1d444e-c986-41ad-9d8e-ea6b87d1ac16', 109613, 10075753, 3023, 'Milton Ernest CofE Primary School', 10, 2),
	('80c0a588-27ee-46c9-8ff6-3b89c19676e3', 20338, NULL, NULL, 'Blenheim Children''s Centre', 35, 8),
	('819b02fc-2395-4916-a4ed-b00708f42b04', 20549, NULL, NULL, 'Cambridge Road Children''s Centre', 35, 8),
	('058f2896-fe48-4ddb-8192-363b268cddde', 20614, NULL, NULL, 'Centre Place Family Centre', 35, 8),
	('1ded357c-605f-48d4-a4e9-376d0a65f440', 21363, NULL, NULL, 'Hamstel Children and Family Centre', 35, 8),
	('5aab769c-9fe6-47a0-9a66-786fd25df82d', 22422, NULL, NULL, 'Prince Avenue Children and Family Centre', 35, 8),
	('bd591157-607c-4fca-877c-bbf7b4fcc12e', 22459, NULL, NULL, 'Friars Children''s Centre', 35, 8),
	('ac1b64de-eaad-447f-89f9-74e6b308ca87', 22975, NULL, NULL, 'Summercourt Children''s Centre', 35, 8),
	('b349fdea-f0bb-41ee-be2e-e27a7816ca04', 23004, NULL, NULL, 'Eastwood Children''s Centre', 35, 8),
	('8589dbf2-eb5b-4a25-9ea0-6db7aaf82faf', 23122, NULL, NULL, 'Temple Sutton Children''s Centre', 35, 8),
	('3b634058-fad9-4182-8efb-7135ddd49191', 132141, 10073628, 2087, 'Hadrian Park Primary School', 11, 2),
	('ac0b68cb-a088-417e-b146-c12f01189258', 135936, 10027711, 6906, 'Fulwood Academy', 4, 5),
	('20a78c18-9bce-4906-8d19-6ea9bd952dca', 112461, 10015990, 6044, 'Underley Garden School', 15, 8),
	('ca690855-3c00-4a67-847c-f1dd48cb6d58', 119009, 10015772, 6060, 'Heath Farm School', 15, 8),
	('3c45ac83-6b0a-459d-9056-6018a6987a52', 136494, 10033036, 5402, 'Teign School', 4, 5),
	('ffdb1114-ca75-45c9-bb4d-8bc643addf6e', 135961, 10028145, 6905, 'Outwood Grange Academy', 4, 5),
	('1aec26c0-547f-4114-9905-478adc2da9d5', 148341, 10092329, 6003, 'Outwood Alternative Provision Eston', 17, 8),
	('70866e1a-a586-4779-8937-5dfd324cc6db', 134311, 10021087, 6905, 'Oasis Academy Enfield', 4, 5),
	('8917c9ce-932e-42fd-a750-7aaf221d02fc', 109393, 10016445, 7014, 'New Fosseway School', 3, 8),
	('29f46cb8-ea36-45d1-a1fa-ef2710c97eb4', 137166, 10034779, 5402, 'The King''s School Grantham', 4, 5),
	('fa69e872-c3eb-4d5c-8d58-ea39f6326881', 115780, 10003659, 6003, 'The King''s School, Gloucester', 17, 8),
	('88503d93-533c-48d2-baf4-a64302fd0abd', 139844, 10042228, 3367, 'Bury CofE Primary School', 4, 2),
	('a8f4598d-22fc-4a4b-bc77-5f504172e655', 136933, NULL, 4000, 'Black Country UTC', 21, 5),
	('ac6b6174-433d-4c19-bb15-23ea234162fa', 135905, NULL, 6910, 'Manchester Creative and Media Academy', 4, 5),
	('65648f23-38dd-4ec9-9c4d-b43d66c13951', 103630, 10077032, 7060, 'Langley School', 3, 8),
	('75cad99b-1620-47e1-889b-34c984737fb9', 101800, 10071655, 3408, 'Regina Coeli Catholic Primary School', 9, 2),
	('8b38d17f-41b1-4dd8-ae8e-1c0070fe2364', 102996, 10079489, 3503, 'St Elphege''s RC Junior School', 9, 2),
	('cc99a28f-f8bc-4943-91c1-fa0a90a05215', 102997, 10078365, 3504, 'St Elphege''s RC Infants'' School', 9, 2),
	('64d47bd5-8867-4345-8c76-b882c683531d', 20048, NULL, NULL, 'Carterhatch Bell Lane Children''s Centre', 35, 8),
	('7ab4fb81-686f-4138-a748-1280a376c808', 20575, NULL, NULL, 'Carterhatch Autumn Close Children''s Centre', 35, 8),
	('00d26539-1e3a-4592-a872-52eeae204a6c', 21240, NULL, NULL, 'Bowes and Garfield Children''s Centre', 35, 8),
	('832d2d1c-0d29-43a9-898d-68587861eb14', 21423, NULL, NULL, 'Hazelbury Children''s Centre', 35, 8),
	('b846c6d0-a09f-419f-824a-400b26d50a3f', 21425, NULL, NULL, 'Hazelwood Children''s Centre', 35, 8),
	('f5625438-2d3b-42d9-a18a-697270c51bf3', 21547, NULL, NULL, 'Honilands Children''s Centre', 35, 8),
	('8b9089a7-7af3-4724-9b5d-f387c67165ad', 22423, NULL, NULL, 'Prince of Wales Childrens Centre', 35, 8),
	('0921e1ca-b510-4a19-819d-fd009558276c', 124870, 10017679, 6016, 'Summerhill School', 17, 8),
	('299e49bd-2e16-4159-a267-891cf14b3d13', 142869, 10056995, 4020, 'Wootton Park School', 30, 6);


--
-- Data for Name: capacity_and_pupil_measures; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.capacity_and_pupil_measures (capacity_and_pupil_measures_id, establishment_id, school_capacity, pupil_count, free_school_meal_measure, census_date) VALUES
	('c6ec820e-6f54-4138-b779-6117f66f7f3e', 'a8538208-f08a-48a8-bd74-10aecdde50bf', 1050, 1300, 735, '2026-01-15'),
	('8af473bd-230f-4d0c-a902-c12a09bf7385', '4e1f7553-2c83-4e4a-9d4e-8a65a913ae37', 1310, 1561, 465, '2026-01-15'),
	('c61bf3b4-9e59-469e-a9ee-6dded042729c', '3f96fa85-9b22-43fd-9cd2-c83cb5df5206', 1512, 1425, 250, '2026-01-15'),
	('2ba487e0-fe1c-4cb3-999f-ee85722c9ac5', 'ebab3c21-fd1a-4ec5-9308-48135237ef1d', 23610, 70, 10, '2026-01-15'),
	('01dbc71a-4ab1-416d-8859-3a50b79e0fd2', '3a1d444e-c986-41ad-9d8e-ea6b87d1ac16', 63964, 67, 5, '2026-01-15'),
	('891a19f8-b512-41ad-a57b-60a820859b58', '3b634058-fad9-4182-8efb-7135ddd49191', 965, 422, 114, '2023-01-19'),
	('f9703d39-2b33-4981-9fb4-e1856785ff0a', 'ac0b68cb-a088-417e-b146-c12f01189258', 1000, 973, 418, '2026-01-15'),
	('ae4520e7-b316-41a1-b26e-225893f013c7', '20a78c18-9bce-4906-8d19-6ea9bd952dca', 84881, 101, NULL, '2024-01-18'),
	('21935dda-32ae-497a-b03d-cbf6fb8d0e21', 'ca690855-3c00-4a67-847c-f1dd48cb6d58', 20643, 141, NULL, '2024-01-18'),
	('d9fe0267-0b31-4c31-8b48-9ac6ec24f3a3', '3c45ac83-6b0a-459d-9056-6018a6987a52', 1353, 1111, 220, '2026-01-15'),
	('e9e8f83d-8880-47f9-b519-82df973521a6', 'ffdb1114-ca75-45c9-bb4d-8bc643addf6e', 2200, 1900, 309, '2026-01-15'),
	('7bb9792a-fe1d-48a8-89c1-94119888df51', '70866e1a-a586-4779-8937-5dfd324cc6db', 1150, 690, 359, '2026-01-15'),
	('a358a809-5c67-4e6b-bcd3-a0e2223e4903', '8917c9ce-932e-42fd-a750-7aaf221d02fc', 62041, 142, 73, '2026-01-15'),
	('cc0d6a82-e810-407e-ba61-26f7cf914dec', '29f46cb8-ea36-45d1-a1fa-ef2710c97eb4', 1086, 1221, 68, '2026-01-15'),
	('c9a71411-3f7d-4052-b8bf-c5dc9d39caa8', 'fa69e872-c3eb-4d5c-8d58-ea39f6326881', 73290, 709, NULL, '2024-01-18'),
	('058afd49-b49f-4a45-a210-7690381d50b1', '88503d93-533c-48d2-baf4-a64302fd0abd', 210, 207, 30, '2026-01-15'),
	('a4919691-a21a-4e5d-aeec-87dbf3626b4d', 'a8f4598d-22fc-4a4b-bc77-5f504172e655', 480, NULL, NULL, NULL),
	('b8ac87be-cea8-45db-8384-99bde3ab08f3', 'ac6b6174-433d-4c19-bb15-23ea234162fa', 660, NULL, NULL, '2016-01-21'),
	('7365ebe6-b786-464f-af40-6a7ba9df2990', '65648f23-38dd-4ec9-9c4d-b43d66c13951', 51694, 137, 81, '2026-01-15'),
	('45551f88-6a9d-4574-87c6-0f6de857b976', '75cad99b-1620-47e1-889b-34c984737fb9', 1357, 382, 96, '2025-01-16'),
	('e50a018b-617b-43d1-a034-5c6491041d26', '8b38d17f-41b1-4dd8-ae8e-1c0070fe2364', 37309, 382, 77, '2025-01-16'),
	('c62181d1-db8c-4b8e-940f-7f1bfe48182d', 'cc99a28f-f8bc-4943-91c1-fa0a90a05215', 5534, 321, 43, '2025-01-16'),
	('ec9724bd-563b-4ce3-8fa3-a200b165993a', '0921e1ca-b510-4a19-819d-fd009558276c', 51776, 51, NULL, '2024-01-18'),
	('f8d0b6cf-4200-4384-b043-4ab4ec13e17f', '299e49bd-2e16-4159-a267-891cf14b3d13', 1290, 1670, 131, '2026-01-15');


--
-- Data for Name: education_admissions_and_provision; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.education_admissions_and_provision (education_admissions_and_provision_id, establishment_id, gender_of_entry_type_id, admissions_policy_id, boarding_provision_id, nursery_provision_id, sixth_form_provision_id) VALUES
	('2638b68f-a55e-4b91-96db-f679dbcd3b63', 'a8538208-f08a-48a8-bd74-10aecdde50bf', 1, 1, 1, 3, 3),
	('0bc1a84c-ffe1-4a3c-9637-7356890eabcc', '4e1f7553-2c83-4e4a-9d4e-8a65a913ae37', 1, 1, 1, 2, 1),
	('a9f267a2-734c-4777-8146-599076b8abc2', '3f96fa85-9b22-43fd-9cd2-c83cb5df5206', 1, 1, 1, 3, 1),
	('f8d0a9e7-1172-4d9b-9863-889cbc972ef4', 'ebab3c21-fd1a-4ec5-9308-48135237ef1d', 1, 3, 1, 2, 2),
	('92f7b8a4-3e12-4f13-8346-f3b51d86ca43', '3a1d444e-c986-41ad-9d8e-ea6b87d1ac16', 1, 3, 1, 2, 2),
	('eaddcedd-3cb2-4706-9e14-9e20750d0f8e', '80c0a588-27ee-46c9-8ff6-3b89c19676e3', NULL, 3, NULL, 3, 3),
	('74a28b19-df41-46fb-bae4-dcef22de5e27', '819b02fc-2395-4916-a4ed-b00708f42b04', NULL, 3, NULL, 3, 3),
	('c40b7f25-3034-4239-887f-78230f531b03', '058f2896-fe48-4ddb-8192-363b268cddde', NULL, 3, NULL, 3, 3),
	('3d6b4dd7-765e-4570-a93b-a86159057cac', '1ded357c-605f-48d4-a4e9-376d0a65f440', NULL, 3, NULL, 3, 3),
	('0490606a-c084-4a04-b7cc-820fe93ea64c', '5aab769c-9fe6-47a0-9a66-786fd25df82d', NULL, 3, NULL, 3, 3),
	('0c0db83c-c39f-4c7a-a0b1-ffd9647e10f9', 'bd591157-607c-4fca-877c-bbf7b4fcc12e', NULL, 3, NULL, 3, 3),
	('8a78184b-6c8d-4b20-8928-6a8576b4cc01', 'ac1b64de-eaad-447f-89f9-74e6b308ca87', NULL, 3, NULL, 3, 3),
	('14e69e53-702e-4444-a9f7-ef6858209155', 'b349fdea-f0bb-41ee-be2e-e27a7816ca04', NULL, 3, NULL, 3, 3),
	('b2407659-a7b1-4f2a-aac7-62a74ee2186b', '8589dbf2-eb5b-4a25-9ea0-6db7aaf82faf', NULL, 3, NULL, 3, 3),
	('2f0b4d41-e944-44e9-9476-e8313e0a76f1', '3b634058-fad9-4182-8efb-7135ddd49191', 1, 3, 1, 1, 2),
	('b9fb6299-e813-4b82-a9a9-abff282b2d5e', 'ac0b68cb-a088-417e-b146-c12f01189258', 1, 1, 1, 3, 2),
	('b71e5e25-a5ea-494c-95a6-005356b4b80e', '20a78c18-9bce-4906-8d19-6ea9bd952dca', 1, 2, 3, 3, 1),
	('76daf53c-741e-4052-8ee4-5d9fdf9f5ea1', 'ca690855-3c00-4a67-847c-f1dd48cb6d58', 1, NULL, 1, 2, 1),
	('24e95ed4-57a1-4b91-be98-87785e2d712a', '3c45ac83-6b0a-459d-9056-6018a6987a52', 1, 1, 1, 3, 1),
	('cff649d5-73f5-4427-94f7-c2b6cd7a9410', 'ffdb1114-ca75-45c9-bb4d-8bc643addf6e', 1, 1, 1, 3, 1),
	('1a4f3bc8-16a0-4022-aee2-95d375cb8cdb', '1aec26c0-547f-4114-9905-478adc2da9d5', NULL, NULL, NULL, NULL, NULL),
	('768c2866-6734-42cf-9784-2670238e5522', '70866e1a-a586-4779-8937-5dfd324cc6db', 1, 1, 1, 3, 1),
	('1e84d55a-56cb-4dcd-9253-ea9d947db8aa', '8917c9ce-932e-42fd-a750-7aaf221d02fc', 1, 3, 1, 3, 1),
	('5343a8f9-17a6-4db9-b5cb-9befd76f0a51', '29f46cb8-ea36-45d1-a1fa-ef2710c97eb4', 2, 2, 1, 3, 1),
	('9fcfda35-5648-4718-9a39-7d4c3e7285d4', 'fa69e872-c3eb-4d5c-8d58-ea39f6326881', 1, NULL, 1, 1, 1),
	('b876c2a5-20e6-4ace-8439-0bc069be014d', '88503d93-533c-48d2-baf4-a64302fd0abd', 1, 3, 1, 2, 2),
	('2e253ce6-cbb6-4a34-b392-604221556f78', 'a8f4598d-22fc-4a4b-bc77-5f504172e655', 1, 1, 1, 3, 1),
	('6e676e70-e686-465d-a8b1-343f24352b61', 'ac6b6174-433d-4c19-bb15-23ea234162fa', 1, 1, 1, 3, 1),
	('702277ef-a2cd-4b6b-bf4d-cff6e4dbf289', '65648f23-38dd-4ec9-9c4d-b43d66c13951', 1, 3, 1, 1, 3),
	('c0ee262b-cba3-4003-8409-1595438cb4da', '75cad99b-1620-47e1-889b-34c984737fb9', 1, 3, 1, 2, 2),
	('6b6ef742-2051-4e29-98c5-7d7bbeab7b3b', '8b38d17f-41b1-4dd8-ae8e-1c0070fe2364', 1, 3, 1, 2, 2),
	('03acdc8e-b738-4915-b734-9d937c71a50a', 'cc99a28f-f8bc-4943-91c1-fa0a90a05215', 1, 3, 1, 1, 2),
	('6c1f98ab-1b3d-42c1-8b89-ba6738701c13', '64d47bd5-8867-4345-8c76-b882c683531d', NULL, 3, NULL, 3, 3),
	('9cc68c6a-f48f-4b27-969d-a9be5633c628', '7ab4fb81-686f-4138-a748-1280a376c808', NULL, 3, NULL, 3, 3),
	('631ea2cb-fa22-4796-8b94-b56ec451396d', '00d26539-1e3a-4592-a872-52eeae204a6c', NULL, 3, NULL, 3, 3),
	('c1eb96f0-887a-41be-afd8-470bc42bc945', '832d2d1c-0d29-43a9-898d-68587861eb14', NULL, 3, NULL, 3, 3),
	('d36ec310-d5a8-4748-85f9-4f5a1e866308', 'b846c6d0-a09f-419f-824a-400b26d50a3f', NULL, 3, NULL, 3, 3),
	('e1c9d34d-93fb-483c-a227-1b9b0e6e28bb', 'f5625438-2d3b-42d9-a18a-697270c51bf3', NULL, 3, NULL, 3, 3),
	('949c09be-967e-40ce-ba3c-ffa2c6454ce7', '8b9089a7-7af3-4724-9b5d-f387c67165ad', NULL, 3, NULL, 3, 3),
	('3e6638e7-8e0a-40d0-ab01-df53fc0b46da', '0921e1ca-b510-4a19-819d-fd009558276c', 1, 1, 3, 2, 1),
	('8ed2ea80-df01-49fd-b95f-bb583e2ff9cb', '299e49bd-2e16-4159-a267-891cf14b3d13', 1, 1, 1, 2, 1);


--
-- Data for Name: establishment_contact; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_contact (establishment_contact_id, establishment_id, website, telephone_number) VALUES
	('54adbd92-e040-4daf-b4f1-df2c117e9fea', 'a8538208-f08a-48a8-bd74-10aecdde50bf', 'http://www.cas.coop', '111111'),
	('b93879c5-054a-486e-bf01-1f4b90e9072d', '4e1f7553-2c83-4e4a-9d4e-8a65a913ae37', 'www.smmacademy.org', '111111'),
	('22314382-d1fd-4cf9-aa1e-e6a183ef4706', '3f96fa85-9b22-43fd-9cd2-c83cb5df5206', 'http://www.ridgewoodschool.co.uk', '111111'),
	('83bc98ca-81a1-425e-9d6f-68f15895a9d2', 'ebab3c21-fd1a-4ec5-9308-48135237ef1d', 'www.ewmeschools.org.uk', '111111'),
	('1ca21330-811a-4b06-96f2-b6bdcecc809f', '3a1d444e-c986-41ad-9d8e-ea6b87d1ac16', 'www.ewmeschools.org.uk', '111111'),
	('cca90b37-9fb2-4cff-9e09-5541a630ddab', '80c0a588-27ee-46c9-8ff6-3b89c19676e3', NULL, '111111'),
	('d7a5c8ab-d763-4ca2-beec-13154fa7e153', '819b02fc-2395-4916-a4ed-b00708f42b04', NULL, '111111'),
	('61bea691-78c7-4c40-affe-af8df7ce00bf', '058f2896-fe48-4ddb-8192-363b268cddde', NULL, '111111'),
	('32aad657-7767-4946-b1a6-2f9afbbd5818', '1ded357c-605f-48d4-a4e9-376d0a65f440', NULL, '111111'),
	('1bbe244f-c3d5-40f5-8759-bdfdb0c3e687', '5aab769c-9fe6-47a0-9a66-786fd25df82d', NULL, '111111'),
	('d3fb9ee4-3d08-4800-aebd-0f5a241871d6', 'bd591157-607c-4fca-877c-bbf7b4fcc12e', NULL, '111111'),
	('bf9059aa-8c79-4fc0-a8e7-dcb40268777c', 'ac1b64de-eaad-447f-89f9-74e6b308ca87', NULL, '111111'),
	('508977a8-f628-4001-b30d-13c8daff4506', 'b349fdea-f0bb-41ee-be2e-e27a7816ca04', NULL, '111111'),
	('8afd5395-139a-4af6-aa60-8fb8eed48087', '8589dbf2-eb5b-4a25-9ea0-6db7aaf82faf', NULL, '111111'),
	('29a1b73e-63cf-4059-b63f-4881922c33f7', '3b634058-fad9-4182-8efb-7135ddd49191', 'www.hadrianparkprimary.org.uk/', '111111'),
	('e96aba70-cf04-44e9-9449-0a33ccb1d2f0', 'ac0b68cb-a088-417e-b146-c12f01189258', 'http://www.fulwoodacademy.co.uk/', '111111'),
	('28ee746a-3a38-436e-9bcc-9761d8f1ec33', '20a78c18-9bce-4906-8d19-6ea9bd952dca', 'www.underleygarden.org', '111111'),
	('d574f005-8c29-4d86-9b10-8e6d66c4711f', 'ca690855-3c00-4a67-847c-f1dd48cb6d58', NULL, '111111'),
	('8e3a33ad-ed1c-40ba-acc9-6eb7c90a3ce2', '3c45ac83-6b0a-459d-9056-6018a6987a52', 'www.teignacademy.co.uk', '111111'),
	('5986888f-7343-4a2c-815e-06728b364561', 'ffdb1114-ca75-45c9-bb4d-8bc643addf6e', 'http://www.grange.outwood.com/', '111111'),
	('f9474724-e205-4029-bb73-484e5505e0bb', '70866e1a-a586-4779-8937-5dfd324cc6db', 'www.oasisacademyenfield.org', '111111'),
	('14f0007e-50b6-4bc2-9f38-d75a5fe25a63', '8917c9ce-932e-42fd-a750-7aaf221d02fc', 'www.newfossewayschool.co.uk', '111111'),
	('f5755095-17bf-442d-884f-57a2e2757fbe', '29f46cb8-ea36-45d1-a1fa-ef2710c97eb4', 'http://www.kings.lincs.sch.uk', '111111'),
	('0658e4bb-a708-4b8c-87d9-a1aec41a01a3', 'fa69e872-c3eb-4d5c-8d58-ea39f6326881', 'www.thekingsschool.co.uk', '111111'),
	('a2ead61e-9d64-4d40-845f-db5086b5a15b', '88503d93-533c-48d2-baf4-a64302fd0abd', 'http://www.bury.cambs.sch.uk', '111111'),
	('46fac263-7c17-46c6-9c3d-80de5d15213f', '75cad99b-1620-47e1-889b-34c984737fb9', 'www.reginacoelischool.co.uk', '111111'),
	('5b96eb1f-c6af-433a-92ab-f27c87eeb876', '8b38d17f-41b1-4dd8-ae8e-1c0070fe2364', 'www.stelphege.org.uk/', '111111'),
	('9f91d65a-d298-402f-9877-dbb83984e983', 'cc99a28f-f8bc-4943-91c1-fa0a90a05215', 'www.stelphegesrcschool.org.uk', '111111'),
	('38124bc2-4e55-486d-895a-4a819900abde', '64d47bd5-8867-4345-8c76-b882c683531d', NULL, '111111'),
	('5c5a1603-7252-414f-aa47-12fc3d9624b2', '7ab4fb81-686f-4138-a748-1280a376c808', NULL, '111111'),
	('b4d5d7e7-8582-4b86-a2f3-11f99c8d7475', '00d26539-1e3a-4592-a872-52eeae204a6c', NULL, '111111'),
	('a86e5b6c-52e7-464c-b86f-1b436864b707', '832d2d1c-0d29-43a9-898d-68587861eb14', NULL, '111111'),
	('1cd64dcc-b9e2-4cd9-bd6b-e4da706efbac', 'b846c6d0-a09f-419f-824a-400b26d50a3f', NULL, '111111'),
	('5134aef3-4e0f-4498-8cb6-f01958259be8', 'f5625438-2d3b-42d9-a18a-697270c51bf3', NULL, '111111'),
	('a34d0d7d-0fc0-4a58-8863-18b53b6cc4d6', '8b9089a7-7af3-4724-9b5d-f387c67165ad', NULL, '111111'),
	('23fd2d39-26fd-4edf-acd7-9ef8f0cc8b4c', '0921e1ca-b510-4a19-819d-fd009558276c', 'www.summerhillschool.co.uk', '111111'),
	('0c7a3334-429e-45ec-ae44-570bd1bf4b95', '299e49bd-2e16-4159-a267-891cf14b3d13', 'www.woottonparkschool.org.uk', '111111');


--
-- Data for Name: establishment_geography; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_geography (establishment_geography_id, establishment_id, local_authority_id, government_office_region_id, district_administrative_id, administrative_ward_id, parliamentary_constituency_id, lsoa_id, msoa_id, urban_rural_id) VALUES
	('3117f1e4-fb04-4d70-a4ee-7f20d408130e', 'a8538208-f08a-48a8-bd74-10aecdde50bf', '3332ea83-bcbe-48d1-970d-a3650d9bcf10', '7ca695f4-dfcd-4f78-bdaf-17861eafbf97', '6ef1f577-d0bc-4698-951c-f202f9eaada6', 'e73f0fc2-114a-4772-a84e-5363b02ba34b', '714fb4a2-4d2e-4875-9853-1d7d6696559e', 'cec78739-d3a7-4831-9934-8dec5c5bdcd1', '5ed6445f-c41a-4778-9a5c-55ba74a2155b', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('fdee4f8c-2440-4216-9b89-a82cdc5c4682', '4e1f7553-2c83-4e4a-9d4e-8a65a913ae37', '3574e75c-8870-449a-82e7-1b083e2efc42', '1375841f-e6ba-4cda-9fac-753ff9df93a2', '9a5cfcfa-3605-4253-8e1c-fc081510a4ea', '9a2f2163-03c6-45b8-84e0-b34cc7a3450c', '6c7acd08-ad7f-406e-85e4-0bade3e57de6', '05aa5060-26b4-4edf-ad40-5e4640903d5a', '0d87ce8f-019d-4403-9527-975bbabd10e1', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('70e44d6c-028b-4e57-800a-a6cd8e7ba35c', '3f96fa85-9b22-43fd-9cd2-c83cb5df5206', '77b9cfe6-842e-41c8-9be4-410cac32719a', 'f5cdf1f1-5f75-4420-b597-862614e13549', '05471fcf-d815-4c82-a7f6-6a9ff75cdaa2', 'cf41c2bc-c0cc-4394-992e-1db6d9f032dd', '8d116d07-483e-41bc-83ea-00c89c3f3a6d', 'c4402a6f-a614-4961-a889-554ef686642a', '011465c5-0d85-498d-8b85-14ea8833c9d5', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('4cdd194d-b1a5-4a6f-9a31-ff21a72abbda', 'ebab3c21-fd1a-4ec5-9308-48135237ef1d', '942f0927-84a7-43b6-8be9-68f88917b043', '32e46d74-0ebf-495b-8261-2c508cd2c2bb', '1146af1e-822e-49f1-a51e-da31f849045c', 'f08ea39d-20ae-4f5e-8274-15207e7b5eec', 'd180f323-3f6f-44dc-a1de-d1cac6e11c0c', '84494da7-5525-4dc5-a454-83a2b9b7bdc0', 'bc444798-7011-43c1-a1e2-269efd7885ef', '1c041cb3-373a-4dd5-9af4-2950293776bc'),
	('de7349d0-4a48-4bcb-95de-6992575dd1c5', '3a1d444e-c986-41ad-9d8e-ea6b87d1ac16', '942f0927-84a7-43b6-8be9-68f88917b043', '32e46d74-0ebf-495b-8261-2c508cd2c2bb', '1146af1e-822e-49f1-a51e-da31f849045c', 'f08ea39d-20ae-4f5e-8274-15207e7b5eec', 'd180f323-3f6f-44dc-a1de-d1cac6e11c0c', '534b5a89-c075-4962-8367-8c8ffc158b9e', 'edc1ad99-4391-4d91-8717-6c10929ae180', '1c041cb3-373a-4dd5-9af4-2950293776bc'),
	('45978453-62b7-48ce-b856-f977c4be1da4', '80c0a588-27ee-46c9-8ff6-3b89c19676e3', 'dc9f9e86-8d80-46b7-87bc-e998cafca819', '32e46d74-0ebf-495b-8261-2c508cd2c2bb', '38ab2b8e-4373-4176-8944-4c6d8cffa7d8', 'c21f6874-6733-4b9b-bc1a-b54fbb495ac9', 'c487eba0-9903-4df2-b999-20f1cca784fb', '84badc4c-a7f2-4af6-8532-8ebf665e5686', '0d9136b3-d6e1-4143-bc20-59738dffb35b', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('1e97770a-a5a0-49e0-9587-d48fa14e6ccd', '819b02fc-2395-4916-a4ed-b00708f42b04', 'dc9f9e86-8d80-46b7-87bc-e998cafca819', '32e46d74-0ebf-495b-8261-2c508cd2c2bb', '38ab2b8e-4373-4176-8944-4c6d8cffa7d8', '0af643ac-6840-48a4-8ed7-dc98ad8626a9', '485e8a03-6bd3-4c3b-95d6-baf2f9b44cad', 'd7b13e80-761e-4cb2-b40f-0dfb91095689', '6c891a27-897f-41ec-ac35-7e207d4fead3', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('10c699d7-8e53-49f1-8a03-dca06759505a', '058f2896-fe48-4ddb-8192-363b268cddde', 'dc9f9e86-8d80-46b7-87bc-e998cafca819', '32e46d74-0ebf-495b-8261-2c508cd2c2bb', '38ab2b8e-4373-4176-8944-4c6d8cffa7d8', '28286c17-e7ea-4022-b909-1a6b60808185', '485e8a03-6bd3-4c3b-95d6-baf2f9b44cad', '56a40580-3dbd-4d1f-bdaa-54370f39b26d', 'd40b3466-6329-406a-93f7-a4978722af70', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('382a4c6b-5301-4f46-b31c-e2792da842e7', '1ded357c-605f-48d4-a4e9-376d0a65f440', 'dc9f9e86-8d80-46b7-87bc-e998cafca819', '32e46d74-0ebf-495b-8261-2c508cd2c2bb', '38ab2b8e-4373-4176-8944-4c6d8cffa7d8', 'bdd0a9a0-8af5-4232-b7ce-30a76be572ca', '485e8a03-6bd3-4c3b-95d6-baf2f9b44cad', 'e8b85e8f-e837-4dd2-9ac3-b3f22e6f83a6', '5a9caa00-1c9c-49c6-ba30-dd3df2b2599f', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('c242fcb1-4a51-4c5f-b93a-57444d90731d', '5aab769c-9fe6-47a0-9a66-786fd25df82d', 'dc9f9e86-8d80-46b7-87bc-e998cafca819', '32e46d74-0ebf-495b-8261-2c508cd2c2bb', '38ab2b8e-4373-4176-8944-4c6d8cffa7d8', '1bcfab2c-6971-4998-9c38-55c1e039be68', 'c487eba0-9903-4df2-b999-20f1cca784fb', '52692e65-37ae-4851-9b83-d318448b8a15', '35b2356d-cad3-415a-af7d-dc32bd148ae2', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('295852cf-4d9b-415c-99bc-10c9a78c71b7', 'bd591157-607c-4fca-877c-bbf7b4fcc12e', 'dc9f9e86-8d80-46b7-87bc-e998cafca819', '32e46d74-0ebf-495b-8261-2c508cd2c2bb', '38ab2b8e-4373-4176-8944-4c6d8cffa7d8', 'b40c3129-d1f9-4ee7-9b6f-a4ed111c7109', '485e8a03-6bd3-4c3b-95d6-baf2f9b44cad', '1e9505f2-4f09-47be-82fe-648e59412d31', 'c5197681-247e-481b-b496-b4503db81187', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('cee76cd8-0fa7-4cb4-825a-72701780dcc9', 'ac1b64de-eaad-447f-89f9-74e6b308ca87', 'dc9f9e86-8d80-46b7-87bc-e998cafca819', '32e46d74-0ebf-495b-8261-2c508cd2c2bb', '38ab2b8e-4373-4176-8944-4c6d8cffa7d8', '9fdf9c47-28c6-4d2f-ba6f-906b588206c3', '485e8a03-6bd3-4c3b-95d6-baf2f9b44cad', 'e8a5b83c-e982-454d-a84a-3bb3b76806f3', '5577ba9a-318d-4440-8baa-7abf3925e7f0', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('2a49cca8-cf4a-4492-9970-f35f05ba24d5', 'b349fdea-f0bb-41ee-be2e-e27a7816ca04', 'dc9f9e86-8d80-46b7-87bc-e998cafca819', '32e46d74-0ebf-495b-8261-2c508cd2c2bb', '38ab2b8e-4373-4176-8944-4c6d8cffa7d8', '1bcfab2c-6971-4998-9c38-55c1e039be68', 'c487eba0-9903-4df2-b999-20f1cca784fb', '34a90645-b540-4351-8d4b-356bec2a4c76', '35b2356d-cad3-415a-af7d-dc32bd148ae2', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('611f839e-5423-4caf-8098-cad1ba4f9fde', '8589dbf2-eb5b-4a25-9ea0-6db7aaf82faf', 'dc9f9e86-8d80-46b7-87bc-e998cafca819', '32e46d74-0ebf-495b-8261-2c508cd2c2bb', '38ab2b8e-4373-4176-8944-4c6d8cffa7d8', 'e8e39ac5-cd31-4312-8f42-063aed530c47', 'c487eba0-9903-4df2-b999-20f1cca784fb', 'e43873e2-e36a-4f91-876b-b62ee15b6a55', '15cd7b16-0306-42b8-8208-9cca5b9deda3', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('bbabb075-7a46-46a2-bf95-c458f6f0aaa8', '3b634058-fad9-4182-8efb-7135ddd49191', 'cf117bdb-0226-42f0-9f40-e11aa3369b61', '6cc3324b-91cb-4ea6-a0db-2cd327ce7941', '7272229e-d4b1-419e-849b-531e45200032', 'ec46bd78-eaea-4593-b5de-9d07bb169875', '68489e77-9d60-498a-840c-712d1fb7ae01', 'bb066056-57d6-44aa-ae8f-b9ecc2d16c15', '07789943-52cc-4a00-a811-7656fbdc20f4', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('74f34fdf-4e00-49a2-a5ef-6c7513c265f8', 'ac0b68cb-a088-417e-b146-c12f01189258', 'a4572037-9765-42e9-890c-0a4c47a49abd', '489dce3e-58d7-44c5-b9ef-2f7d7cbdb592', '50c00d93-da6b-4df1-87ad-ebe1b4af26d0', 'a92333cd-38a8-4b10-9822-3d66ade87507', 'd0b01b14-129d-452c-aba9-32a10da493ab', '87cd11b8-7e94-47cd-9996-0ecc21f1ca54', '7dd76107-3e1d-40a1-b89b-e801475b55b9', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('b2d0d433-b677-4c36-b6b6-f74fe240acba', '20a78c18-9bce-4906-8d19-6ea9bd952dca', 'c3481033-0753-4614-b00b-677ccc85d1ee', '489dce3e-58d7-44c5-b9ef-2f7d7cbdb592', '3f0b99bb-4666-463d-b373-6f096c6c032c', '1e6798c9-c8d2-4cec-acfa-c60a17acc802', 'ce572531-777d-4112-b07a-99c827d21bb7', '48507344-3f4b-475c-9b60-b913b01b5d27', '0254b351-1c59-4e0e-822d-b99b185b22f4', 'f755a09b-bf99-4ac1-a3cc-266ad9a9c32b'),
	('2565e531-2d13-4dd7-b7d1-ecda325a688f', 'ca690855-3c00-4a67-847c-f1dd48cb6d58', '893121c9-05e6-4e35-bfef-ea76e40c012e', 'f85647db-e5d1-41a6-befb-bfbf6420f5c4', '17fc3b24-6e02-44e2-8efc-2c47da891a27', '530f3047-08df-4892-b9ab-16df2a2a39be', '530f1da7-9067-43a1-b515-e93f9199b65e', 'cda69748-98b0-4ee6-a025-27833304c743', '7100b4af-5ca3-4746-a8ef-4c5f46714353', '1c041cb3-373a-4dd5-9af4-2950293776bc'),
	('593692f8-eda7-4bc2-9ece-891fd9dc92bb', '3c45ac83-6b0a-459d-9056-6018a6987a52', '275bafd9-e869-4606-ad4a-6c578baae51f', '21478f61-4270-49ad-8c24-d9058ea036ab', '97abf0ae-974e-47fc-b853-8453a99c0ed8', '4091a6cd-4f4f-4991-88c6-43a0bc656cd0', 'b372ba77-97c3-4aae-924d-8d8cecef24e9', '5a954a5c-ee09-4d51-8fae-a269e79601b0', '776ff4b6-d4d0-438d-be38-b8b227c0949e', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('fcdde308-2bc1-42a9-a998-a9d914e7237f', 'ffdb1114-ca75-45c9-bb4d-8bc643addf6e', '7788aab1-b623-462a-9e65-32e7d9c353ca', 'f5cdf1f1-5f75-4420-b597-862614e13549', '2cf133a0-4155-492d-a705-b2a17e189483', 'c9e8a8b9-0b68-4c4a-bd56-d65202b95275', '7186247e-c257-4a0f-8c65-6fe2540a95d3', '0f955cfc-255c-470c-8a4c-c91586d92930', 'ec039d06-459b-4c69-89fc-ed048ea4689f', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('12330cf4-946b-4ea5-af8f-40ec002a5036', '1aec26c0-547f-4114-9905-478adc2da9d5', '8d9e4a37-f50c-41c9-81c3-895306cf4782', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	('80724648-910a-4f6c-83b0-e9863c7363fb', '70866e1a-a586-4779-8937-5dfd324cc6db', '987bd60d-dd0c-4707-818f-d4aeb184a7b8', '1375841f-e6ba-4cda-9fac-753ff9df93a2', '54101cc5-e262-4a15-9d6b-9d0aad2921aa', '04d0ac1c-15cc-467d-adef-51c7ca94f07b', '9088bbcc-4370-4e5e-a8eb-9ee9493d1c94', 'adfcb62a-2e5b-4bd1-9362-b189bc0acf6a', 'e3af2bbe-c7ab-473c-a172-d800f6797c01', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('2e641948-84e1-49f8-83cc-8fd66a3609f3', '8917c9ce-932e-42fd-a750-7aaf221d02fc', '50d53eb6-b12f-4962-8eff-50c36d424d9d', '21478f61-4270-49ad-8c24-d9058ea036ab', '620361b1-ff4f-4cb5-984d-cd0d725dcd1a', '2e4f45e8-802f-4f37-8106-fb05e2bbc022', 'ee21b42c-060d-46e0-aad4-1efd37616e5e', 'bf065165-c08f-4505-b28e-48b2051c9a97', '777adfc3-4c6e-4c7d-8652-d4dec28581cc', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('a40bd7e4-98c3-4482-b1eb-bffdd26554d1', '29f46cb8-ea36-45d1-a1fa-ef2710c97eb4', '00720f6a-c51f-4c33-8146-3c3bd96dc279', '9c5ec547-5f0d-4ed6-938c-ba51c67d197d', '1a9c5f8e-4a8e-4d53-982d-214ecffc11be', '82e334b9-bbea-40cb-931c-fb61b7b6cd41', 'be38bb40-3440-4bf5-b15e-74b9c8632300', '236e4125-e6f5-4af6-9850-a4177cd7215d', 'ae23fb48-50c9-4aed-a878-b3c810a35180', '1d69b4b9-1c8a-4b68-80a6-1ed414f9a43a'),
	('322c48c3-afd9-46de-b696-62d669eaf530', 'fa69e872-c3eb-4d5c-8d58-ea39f6326881', '3b110d34-2776-4827-969e-2af0d39a4aa2', '21478f61-4270-49ad-8c24-d9058ea036ab', 'beab8458-fc51-4818-a8eb-938c0fbf10bf', 'ede75355-97be-4487-88b6-a9a6595aab89', '4f760621-fec5-4a87-afdb-cd62a17fdc27', 'b9c7af72-836d-4e53-88b6-de151c03119e', 'e8514cc1-4d25-48e2-a587-a56080759ee0', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('b954bb5b-a623-48e5-977f-5cc57dd2bc09', '88503d93-533c-48d2-baf4-a64302fd0abd', '3a839d72-f591-4c51-9b4b-91637c541035', '32e46d74-0ebf-495b-8261-2c508cd2c2bb', '2bc0a446-371e-4d91-87d9-ac0fbcc1445d', '445a5318-efa8-4f52-a740-563f101c7567', '25b05125-3e5f-4c7f-84b9-efd472525f3d', '01b8e7ee-bb4f-43d0-ab69-2f2cb597858e', '84503731-6851-4d4f-a5c4-485544cb67c6', 'f755a09b-bf99-4ac1-a3cc-266ad9a9c32b'),
	('299f9a9a-ba77-4760-b767-0324960bcd57', 'a8f4598d-22fc-4a4b-bc77-5f504172e655', 'db38471e-2843-4e5a-9712-1d8fc220f3de', '7ca695f4-dfcd-4f78-bdaf-17861eafbf97', '1e04f205-ee15-4a66-9df8-3806ee7ea570', '8acaa659-c224-45be-9866-388a0ca3756e', 'f12d79d9-d96c-430f-9999-3e3429d13e58', 'f3f1401b-2a66-4e7c-9661-f37932651481', 'aea71101-bf51-4b1b-8ea1-b8d3b2121334', 'fba31373-6bf1-4ad2-9d63-a2c783849aad'),
	('e0ca090d-41f8-40d6-a2a5-2558e1dd5391', 'ac6b6174-433d-4c19-bb15-23ea234162fa', '0a78f87e-d71b-44c3-b598-2cc2b8038e95', '489dce3e-58d7-44c5-b9ef-2f7d7cbdb592', 'c8efb411-9c6d-492e-af1e-624ed743712f', 'f22dfd05-c647-403a-bebd-69fb3a62cca6', '93b33a64-95d1-4d7f-9142-4acc73221e9a', '22d38930-6da2-4b70-9bca-6208cbb43ba5', 'cddc19f9-9b91-4e98-a4c8-656753fd673c', 'fba31373-6bf1-4ad2-9d63-a2c783849aad'),
	('429f8db3-8308-4395-8e8d-e1e1e112fddb', '65648f23-38dd-4ec9-9c4d-b43d66c13951', '2331ef34-0efc-46ff-bd37-a5046d40a753', '7ca695f4-dfcd-4f78-bdaf-17861eafbf97', 'f7e241f3-c6fb-48e6-a77d-027951284c61', '0fa1ef24-4b15-4692-b1c4-8f47dc872dac', 'c27f9203-9440-4d37-be02-8ccbdd0e7c95', '81e44df7-d1d8-4222-8191-ffc69999093c', '368c9d59-0593-4a0f-bf51-2b07a7151332', 'fba31373-6bf1-4ad2-9d63-a2c783849aad'),
	('6d2d6880-e3d3-4dcd-8ac0-dbf5d34d2cc3', '75cad99b-1620-47e1-889b-34c984737fb9', 'b852b15b-c92e-4f4c-a014-5a99cdf7025b', '1375841f-e6ba-4cda-9fac-753ff9df93a2', 'd73a9b66-ca0c-43b9-83a8-efae806bdde8', '2512f633-7cc6-42ad-b433-bc7973470bda', 'b25de346-0bba-425e-8ad3-5d259b47114d', '27190c0c-310c-47a7-b9fe-2f286bc33298', 'f5c5681e-2ec4-43fa-aa2a-12af704f14ca', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('f89debba-0885-4545-88e0-2923e6514c08', '8b38d17f-41b1-4dd8-ae8e-1c0070fe2364', '34427472-2794-4f4b-9bf3-d17e2b945133', '1375841f-e6ba-4cda-9fac-753ff9df93a2', 'dd4dab97-8547-4bb1-b683-875cfc46a680', '18aeb09f-5e30-4e51-9432-996257bf2155', '6df803f9-6f84-41da-9507-6db18aec825a', '6d08c397-a891-4d02-9a51-19de5ca81837', '47de1daa-d977-41be-9925-216a45804274', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('86a1a207-b1b6-4e66-9b7a-ce09decdbfaa', 'cc99a28f-f8bc-4943-91c1-fa0a90a05215', '34427472-2794-4f4b-9bf3-d17e2b945133', '1375841f-e6ba-4cda-9fac-753ff9df93a2', 'dd4dab97-8547-4bb1-b683-875cfc46a680', '18aeb09f-5e30-4e51-9432-996257bf2155', '6df803f9-6f84-41da-9507-6db18aec825a', '6d08c397-a891-4d02-9a51-19de5ca81837', '47de1daa-d977-41be-9925-216a45804274', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('471f05a0-91d0-41c2-867e-c616fe78d002', 'f5625438-2d3b-42d9-a18a-697270c51bf3', '987bd60d-dd0c-4707-818f-d4aeb184a7b8', '1375841f-e6ba-4cda-9fac-753ff9df93a2', '54101cc5-e262-4a15-9d6b-9d0aad2921aa', 'ad916db9-124c-4c6e-829a-e9421671a31c', '9088bbcc-4370-4e5e-a8eb-9ee9493d1c94', '0d2f65b5-4bce-40e5-8eb5-fb15f8a18fdb', '3882234b-cf19-47af-9dfe-c285dbe35ce0', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('0ab5f9c7-81c4-4ae8-8451-f00e15e22b6a', '8b9089a7-7af3-4724-9b5d-f387c67165ad', '987bd60d-dd0c-4707-818f-d4aeb184a7b8', '1375841f-e6ba-4cda-9fac-753ff9df93a2', '54101cc5-e262-4a15-9d6b-9d0aad2921aa', '04d0ac1c-15cc-467d-adef-51c7ca94f07b', '9088bbcc-4370-4e5e-a8eb-9ee9493d1c94', 'adfcb62a-2e5b-4bd1-9362-b189bc0acf6a', 'e3af2bbe-c7ab-473c-a172-d800f6797c01', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('ff221062-8821-4f4f-8e66-a8da63045113', '7ab4fb81-686f-4138-a748-1280a376c808', '987bd60d-dd0c-4707-818f-d4aeb184a7b8', '1375841f-e6ba-4cda-9fac-753ff9df93a2', '54101cc5-e262-4a15-9d6b-9d0aad2921aa', '439f4298-d666-4239-bee4-9bd46f7bfcd9', '9088bbcc-4370-4e5e-a8eb-9ee9493d1c94', 'e9773da7-0792-44a1-b923-cc0adf25a57e', '675c8870-19bb-44e3-93ad-de23c20dbfc2', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('f8025f6d-3303-4326-8510-e7fa33bff150', '64d47bd5-8867-4345-8c76-b882c683531d', '987bd60d-dd0c-4707-818f-d4aeb184a7b8', '1375841f-e6ba-4cda-9fac-753ff9df93a2', '54101cc5-e262-4a15-9d6b-9d0aad2921aa', '4579d615-a2b7-44d7-9a03-4a5983a4ca2c', '9088bbcc-4370-4e5e-a8eb-9ee9493d1c94', 'be526a74-d188-491f-baab-9c965bb2b816', '22c9c864-c795-4105-9e06-fca6d8fb01f4', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('78ec957c-6c86-4d23-b722-ab9f38f644a4', '832d2d1c-0d29-43a9-898d-68587861eb14', '987bd60d-dd0c-4707-818f-d4aeb184a7b8', '1375841f-e6ba-4cda-9fac-753ff9df93a2', '54101cc5-e262-4a15-9d6b-9d0aad2921aa', 'd2aaea09-f2bd-4363-9528-ba1502781740', '7a03aae3-9cf1-4bfd-8d77-c57978ad4d91', 'e92c649e-930b-4197-8cac-51986743902a', 'b663e8d8-8e5d-4631-92d2-a68999ee7385', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('1aee627a-fd46-4c93-84ba-fbef14aff1fb', '00d26539-1e3a-4592-a872-52eeae204a6c', '987bd60d-dd0c-4707-818f-d4aeb184a7b8', '1375841f-e6ba-4cda-9fac-753ff9df93a2', '54101cc5-e262-4a15-9d6b-9d0aad2921aa', '2186ae56-626c-4efb-9ccd-57b0b43a2baf', 'bf56b35e-bc52-49ae-a3e1-024ce12dc124', 'bd55873b-de12-4085-9166-779acfa6c739', '79427e27-95d9-4dae-a20b-438c654be397', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('c479e094-e8ee-42e0-bb26-a16353e8a808', 'b846c6d0-a09f-419f-824a-400b26d50a3f', '987bd60d-dd0c-4707-818f-d4aeb184a7b8', '1375841f-e6ba-4cda-9fac-753ff9df93a2', '54101cc5-e262-4a15-9d6b-9d0aad2921aa', '81c4338c-1667-434c-803f-0680411015fe', 'bf56b35e-bc52-49ae-a3e1-024ce12dc124', '5004d684-dfd5-44be-9c39-503e58c23ae2', '9bd93f61-f661-42cc-bd8f-36779668cceb', '8826f875-fade-4b0b-a4b1-f8536505ecd1'),
	('8b70ed3c-89e6-4cfd-9ac6-556fb1c50da5', '0921e1ca-b510-4a19-819d-fd009558276c', 'c1782af8-ed41-4ee1-bd3a-a5449b43acde', '32e46d74-0ebf-495b-8261-2c508cd2c2bb', '94320f96-6ff3-44e7-a39e-22c0f53257c2', 'cbb1ca15-8873-4094-8ddc-a0a58e20ed86', '24db7f84-44da-4eca-b216-e013b4a41323', 'fdcf6bc2-1d6a-47d7-bd26-37c10a580ca8', '4bc48b4e-735d-4409-8dc8-5ed306c90e76', 'f755a09b-bf99-4ac1-a3cc-266ad9a9c32b'),
	('c7ac70d9-e52a-4108-8dff-099cf878133b', '299e49bd-2e16-4159-a267-891cf14b3d13', '4f5cf1f1-e617-4ad7-b077-41042c25dd30', '9c5ec547-5f0d-4ed6-938c-ba51c67d197d', 'c3c11c4d-05b1-447d-a13b-4186b7956fb2', '89179d09-63c9-4bdf-a104-c63d646a59e2', 'c3b261d9-2479-442e-bc74-3074b3bcfeb9', '8789ff34-8c1a-4ccb-9ce9-31691db5d6b2', 'a5bcf7df-24f6-4d10-adc3-96c6aa334f6d', '8826f875-fade-4b0b-a4b1-f8536505ecd1');


--
-- Data for Name: establishment_lifecycle; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_lifecycle (establishment_lifecycle_id, establishment_id, establishment_status_id, open_date, close_date, reason_establishment_opened_id, reason_establishment_closed_id, last_changed_date) VALUES
	('794b7357-8b7c-4b9c-9723-04ebef47a118', 'a8538208-f08a-48a8-bd74-10aecdde50bf', 1, '2010-09-01', NULL, 2, NULL, '2026-06-23'),
	('657468a8-da72-4b51-862d-bd5b60fed2c2', '4e1f7553-2c83-4e4a-9d4e-8a65a913ae37', 1, '2007-09-01', NULL, 2, NULL, '2026-06-23'),
	('9e9a64d0-5a2b-42e2-91ea-c7753cb9a8b3', '3f96fa85-9b22-43fd-9cd2-c83cb5df5206', 1, '2011-11-01', NULL, 1, NULL, '2026-06-23'),
	('e3890785-580d-40f6-9338-df22c685025d', 'ebab3c21-fd1a-4ec5-9308-48135237ef1d', 1, NULL, NULL, NULL, NULL, '2026-06-23'),
	('f645d28e-d88d-4044-9113-f7452323e33f', '3a1d444e-c986-41ad-9d8e-ea6b87d1ac16', 1, NULL, NULL, NULL, NULL, '2026-06-23'),
	('bc50085f-8b5b-4314-9c1a-37d94f813e4c', '80c0a588-27ee-46c9-8ff6-3b89c19676e3', 1, '2008-02-07', NULL, NULL, NULL, '2025-06-20'),
	('88c1898f-8a17-4643-a4e5-07a492b7e5e7', '819b02fc-2395-4916-a4ed-b00708f42b04', 1, '2006-03-14', NULL, NULL, NULL, '2025-06-20'),
	('8a89f9aa-4791-412d-8107-0f52f87f21e2', '058f2896-fe48-4ddb-8192-363b268cddde', 1, '2008-03-03', NULL, NULL, NULL, '2025-06-20'),
	('34151b4e-a4d3-4a8b-8b11-31b9e198f887', '1ded357c-605f-48d4-a4e9-376d0a65f440', 1, '2009-12-14', NULL, NULL, NULL, '2025-06-20'),
	('07223e9f-641d-47d0-9125-026c66e87ce5', '5aab769c-9fe6-47a0-9a66-786fd25df82d', 1, '2009-12-14', NULL, NULL, NULL, '2025-06-20'),
	('72655116-e744-4cc3-aeec-7705e95eee0b', 'bd591157-607c-4fca-877c-bbf7b4fcc12e', 1, '2008-01-16', NULL, NULL, NULL, '2025-06-20'),
	('cc5721a8-313a-4638-9fd1-3b2dd1d8404e', 'ac1b64de-eaad-447f-89f9-74e6b308ca87', 1, '2008-01-16', NULL, NULL, NULL, '2025-06-20'),
	('8b8ef98f-4447-4ac7-b397-83b9d28143a9', 'b349fdea-f0bb-41ee-be2e-e27a7816ca04', 1, '2008-02-07', NULL, NULL, NULL, '2025-06-20'),
	('0430fff1-d4d9-4510-b22c-1d5eced0e23a', '8589dbf2-eb5b-4a25-9ea0-6db7aaf82faf', 1, '2006-09-28', NULL, NULL, NULL, '2025-06-20'),
	('cd641eed-b0a7-404d-a8a7-7b58ff47cb3c', '3b634058-fad9-4182-8efb-7135ddd49191', 1, '2001-09-01', NULL, 6, NULL, '2025-06-20'),
	('4462b9c8-71da-4a61-ae8e-b814adc9f61b', 'ac0b68cb-a088-417e-b146-c12f01189258', 1, '2009-09-01', NULL, 2, NULL, '2026-06-23'),
	('61410f22-81a0-4eda-a0ec-90e957cfb02f', '20a78c18-9bce-4906-8d19-6ea9bd952dca', 1, '1990-03-28', NULL, NULL, NULL, '2026-07-20'),
	('d2b8579c-f417-46db-8301-7106a19a261e', 'ca690855-3c00-4a67-847c-f1dd48cb6d58', 1, '1988-12-12', NULL, NULL, NULL, '2026-07-20'),
	('ba8d8c93-2cb1-4491-ac43-d0ed75f36f8e', '3c45ac83-6b0a-459d-9056-6018a6987a52', 1, '2011-03-01', NULL, 1, NULL, '2026-06-23'),
	('03a87ca2-aa48-463e-b824-24d7500e94cb', '1aec26c0-547f-4114-9905-478adc2da9d5', 1, '2021-02-18', NULL, NULL, NULL, NULL),
	('0d25f0e8-2dda-44d6-8c82-378fe75c71fd', 'ffdb1114-ca75-45c9-bb4d-8bc643addf6e', 1, '2009-09-01', NULL, 2, NULL, '2026-06-23'),
	('5a5c318a-fe6f-4809-83e6-fee3abb55096', '70866e1a-a586-4779-8937-5dfd324cc6db', 1, '2007-09-01', NULL, 2, NULL, '2026-06-23'),
	('680027a1-521a-4109-8cd3-00dd22c77f0e', '8917c9ce-932e-42fd-a750-7aaf221d02fc', 1, NULL, NULL, NULL, NULL, '2026-06-23'),
	('40f19c50-041a-4ce4-ac86-30019b2f6ebc', '29f46cb8-ea36-45d1-a1fa-ef2710c97eb4', 1, '2011-08-01', NULL, 1, NULL, '2026-06-23'),
	('7d4714ec-4746-4ed5-bec3-0ee7e5c4ee67', 'fa69e872-c3eb-4d5c-8d58-ea39f6326881', 1, '1930-01-01', NULL, NULL, NULL, '2026-07-20'),
	('a6681584-00d6-4bd0-8359-427db654b177', '88503d93-533c-48d2-baf4-a64302fd0abd', 1, '2013-07-01', NULL, 1, NULL, '2026-06-23'),
	('045e8215-f84f-4027-8822-42ac29c03db6', 'a8f4598d-22fc-4a4b-bc77-5f504172e655', 2, '2011-09-01', '2015-08-31', 2, 3, '2016-06-30'),
	('64a4c4e1-8025-45d1-921c-68cbf9cc4b1f', 'ac6b6174-433d-4c19-bb15-23ea234162fa', 2, '2009-09-01', '2016-02-29', 2, 12, '2018-07-02'),
	('d0a96de5-5575-41c8-aaad-be76f9f04045', '65648f23-38dd-4ec9-9c4d-b43d66c13951', 2, NULL, '2020-06-16', NULL, 1, '2026-06-23'),
	('921f2842-4c18-4a22-843b-e28221481afe', 'cc99a28f-f8bc-4943-91c1-fa0a90a05215', 1, NULL, NULL, NULL, NULL, '2025-07-03'),
	('12e18213-61fc-46bc-b724-c5d1cdd36039', '8b38d17f-41b1-4dd8-ae8e-1c0070fe2364', 1, NULL, NULL, NULL, NULL, '2025-07-03'),
	('6d6f9271-b433-4d54-8e24-abd3f9f00ff4', '75cad99b-1620-47e1-889b-34c984737fb9', 1, NULL, NULL, NULL, NULL, '2025-07-03'),
	('6c2ec064-05a2-4f9a-bea2-26cbe1e92797', '8b9089a7-7af3-4724-9b5d-f387c67165ad', 1, '2008-01-23', NULL, NULL, NULL, '2025-06-20'),
	('a2051918-a370-44f7-b2c0-03d3885403f3', 'f5625438-2d3b-42d9-a18a-697270c51bf3', 1, '2008-01-23', NULL, NULL, NULL, '2025-06-20'),
	('5a90eb58-c596-461a-b765-c19da5be8516', 'b846c6d0-a09f-419f-824a-400b26d50a3f', 1, '2009-09-30', NULL, NULL, NULL, '2025-06-20'),
	('b2541960-7796-4de1-935e-f3ae286e8dbb', '832d2d1c-0d29-43a9-898d-68587861eb14', 1, '2006-09-27', NULL, NULL, NULL, '2025-06-20'),
	('4e0ff26c-bc52-48d8-9474-e54a60ced598', '00d26539-1e3a-4592-a872-52eeae204a6c', 1, '2006-09-27', NULL, NULL, NULL, '2025-06-20'),
	('f94569f0-c22e-4543-a8a3-9bf295338f40', '7ab4fb81-686f-4138-a748-1280a376c808', 1, '2007-09-16', NULL, NULL, NULL, '2025-06-20'),
	('d9697a38-5fb8-4192-aea8-cde59e853763', '64d47bd5-8867-4345-8c76-b882c683531d', 1, '2008-03-31', NULL, NULL, NULL, '2025-06-20'),
	('6e5d502d-b22c-4130-bc07-405d67fe4956', '0921e1ca-b510-4a19-819d-fd009558276c', 1, '1921-03-13', NULL, 2, NULL, '2026-07-20'),
	('d284345b-c22a-4309-aa1e-4e32995aac39', '299e49bd-2e16-4159-a267-891cf14b3d13', 1, '2016-09-01', NULL, NULL, NULL, '2026-06-23');


--
-- Data for Name: person; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.person (person_id) VALUES
	('26b91f6e-8ca7-42b5-91be-babd43a22b1f');


--
-- Data for Name: establishment_party_role; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_party_role (establishment_party_role_id, establishment_party_role_type_id, legal_entity_id, person_id, start_date, end_date) VALUES
	('b354c1c9-12d0-42f8-a78a-eea51409d5df', 1, '55a5f300-b304-421c-aa4e-1ae2b909b83d', NULL, NULL, NULL),
	('136d089f-651e-454e-9834-6c2ef6b04186', 1, 'dfbfa842-402d-4c6c-8f07-c2b123d9ab41', NULL, NULL, NULL),
	('bb9823b2-4430-446c-9719-d0fe653e537c', 4, 'e3e521ea-7d27-4a6f-a696-52f65a16ff48', NULL, NULL, NULL),
	('e3a349f0-fa2f-4dd2-a0d3-eccb299a69cb', 1, 'cb3d2596-28a8-411a-8651-856d75b4e650', NULL, NULL, NULL),
	('8992dc3f-6a5b-49d6-9dc4-4efdedd25968', 4, '65847c51-02b7-4222-92f0-1a2bbdb3d631', NULL, NULL, NULL),
	('1ebef5f0-237a-4bb3-a6a9-6d20a415614d', 1, 'b84e131a-4d76-498c-8cde-b487fca42fd7', NULL, NULL, '2016-02-29'),
	('f8a6b1e8-8c95-44c0-997c-c29fd7a01b05', 1, '853b8dd4-cd78-4aba-82ce-7b0c207aceac', NULL, NULL, NULL),
	('d0b2530e-24af-4b26-9243-d227a175c7f8', 2, '28c6cbfe-daa3-479e-aed8-94eae82ebd11', NULL, NULL, NULL),
	('ff0fac23-e58a-4c68-82c4-4c0c98d5d867', 4, NULL, '26b91f6e-8ca7-42b5-91be-babd43a22b1f', NULL, NULL),
	('5ce9657f-953c-4e8a-9760-3c225a205a3d', 1, '511a8952-b41c-44de-9706-d8791fad664f', NULL, NULL, NULL),
	('cf7ce5ef-32af-45e2-b35e-3f45f9022395', 1, '00ad3b7a-1658-4128-9152-ac9746cb7013', NULL, NULL, NULL),
	('b6ced685-f7cc-4244-b59c-70249b770975', 1, '6e00145a-8739-4de7-aaf9-00b88630cd3f', NULL, NULL, NULL),
	('d8c711fd-26cc-4be1-a227-53251de9a967', 4, '5a5c9b6b-7f1c-455d-9909-0cc4fa456001', NULL, NULL, NULL),
	('6d5e3488-6c02-4a22-8f42-4e2f03baf971', 1, '5a5c9b6b-7f1c-455d-9909-0cc4fa456001', NULL, NULL, NULL),
	('1455f600-fa01-4d21-9f55-e47c22fbc650', 4, '1a3eaa21-e772-49da-ac8b-f26c74c310bd', NULL, NULL, NULL),
	('b0bf0a0a-84e3-42bc-956f-e52debf2a437', 1, '1a3eaa21-e772-49da-ac8b-f26c74c310bd', NULL, NULL, NULL),
	('cc1f46cb-e18d-43f4-9b0a-55088a556d64', 2, 'a6af2721-825e-4cb9-afb8-d596208173f8', NULL, NULL, NULL),
	('91be9dcf-635e-46ea-ab50-e9f823f6895c', 1, 'e6aa6cec-8ee5-47ae-aa64-3a30e0e274a9', NULL, NULL, NULL),
	('252aa012-a9e6-48ad-ba5c-3c2841f95d2c', 4, '23f9cb5e-203e-46a1-bb04-d1960561b15c', NULL, NULL, NULL),
	('7f35a695-2023-42e3-8f3b-7de32a6a15dc', 1, '8c583f6f-fcbf-48be-a29a-82659646e8e1', NULL, NULL, NULL),
	('61ef6eac-fba6-40f1-af0f-2f03ddc433a4', 1, 'e471a59d-d17b-422b-9851-b3121c88a757', NULL, NULL, '2015-08-31'),
	('45871316-f091-4cd9-9e55-ea342245c21f', 2, '07499405-9190-472f-ac28-39e405b9afb8', NULL, NULL, NULL),
	('798438a5-950c-4d9b-b902-1d484183844e', 1, 'd28c88c1-6741-4fe9-ba5c-4ae4305d1fa0', NULL, NULL, NULL),
	('150c2750-8d3e-4d7b-ab99-c91d2e69ee1c', 1, 'ee7f7d2b-c26b-4726-a6d4-d68d5dc73ef3', NULL, NULL, NULL);


--
-- Data for Name: establishment_responsibility; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_responsibility (establishment_responsibility_id, establishment_id, legal_entity_id, person_id, responsibility_type_id, academy_trust_type_id, start_date, end_date, is_current) VALUES
	('9165d9cb-970e-470c-9cd6-788d86fa1516', 'a8538208-f08a-48a8-bd74-10aecdde50bf', '55a5f300-b304-421c-aa4e-1ae2b909b83d', NULL, 1, 2, '2015-07-01', NULL, true),
	('746925a2-082b-457e-babd-e3077ba1cd13', 'a8538208-f08a-48a8-bd74-10aecdde50bf', 'dfbfa842-402d-4c6c-8f07-c2b123d9ab41', NULL, 1, 1, '2010-09-01', NULL, false),
	('fdd893b0-3eac-4e24-840e-bcf9cd2d667c', 'a8538208-f08a-48a8-bd74-10aecdde50bf', 'e3e521ea-7d27-4a6f-a696-52f65a16ff48', NULL, 3, NULL, '2010-09-01', NULL, true),
	('fcc409f1-9866-4058-b830-e696024199b1', '4e1f7553-2c83-4e4a-9d4e-8a65a913ae37', 'cb3d2596-28a8-411a-8651-856d75b4e650', NULL, 1, 2, '2021-10-04', NULL, true),
	('9afefd62-d170-4a03-9eaa-3d67657717f7', '4e1f7553-2c83-4e4a-9d4e-8a65a913ae37', 'cb3d2596-28a8-411a-8651-856d75b4e650', NULL, 1, 1, '2007-09-01', NULL, false),
	('e72d4066-e3b9-4d48-b1b7-cb1ba7cac649', '4e1f7553-2c83-4e4a-9d4e-8a65a913ae37', '65847c51-02b7-4222-92f0-1a2bbdb3d631', NULL, 3, NULL, '2007-09-01', NULL, true),
	('6af64c11-e6f0-45fb-bce4-91773855e74b', '3f96fa85-9b22-43fd-9cd2-c83cb5df5206', '853b8dd4-cd78-4aba-82ce-7b0c207aceac', NULL, 1, 1, '2011-11-01', NULL, false),
	('89051364-ac09-4f16-8b72-ab943257c4c7', '3f96fa85-9b22-43fd-9cd2-c83cb5df5206', '853b8dd4-cd78-4aba-82ce-7b0c207aceac', NULL, 1, 2, '2021-03-30', NULL, true),
	('e03e3ef1-dbef-49a1-82a5-533cfcd78e87', '3b634058-fad9-4182-8efb-7135ddd49191', '28c6cbfe-daa3-479e-aed8-94eae82ebd11', NULL, 2, NULL, '2011-09-01', NULL, true),
	('1f6b4826-078f-4ebd-9121-0733cbf85ccf', 'ac0b68cb-a088-417e-b146-c12f01189258', NULL, '26b91f6e-8ca7-42b5-91be-babd43a22b1f', 3, NULL, '2009-09-01', NULL, true),
	('a96d1001-aec7-4493-847d-ffbd2e44030f', 'ac0b68cb-a088-417e-b146-c12f01189258', '511a8952-b41c-44de-9706-d8791fad664f', NULL, 1, 2, '2009-09-01', NULL, true),
	('94e6ee13-58d1-46f6-89e0-af809d8d6bf6', '20a78c18-9bce-4906-8d19-6ea9bd952dca', '5be037f1-12fc-4b40-829c-4135c96fc783', NULL, 4, NULL, NULL, NULL, true),
	('3edfee33-7e79-41ec-9203-ed253869b48b', 'ca690855-3c00-4a67-847c-f1dd48cb6d58', '5be037f1-12fc-4b40-829c-4135c96fc783', NULL, 4, NULL, NULL, NULL, true),
	('cff75e39-a27c-4c6b-bc6b-1c7eb44bb7df', '3c45ac83-6b0a-459d-9056-6018a6987a52', '6e00145a-8739-4de7-aaf9-00b88630cd3f', NULL, 1, 2, '2017-01-01', NULL, true),
	('46295166-6307-437d-b8c9-28f22bf6a5b2', '3c45ac83-6b0a-459d-9056-6018a6987a52', '00ad3b7a-1658-4128-9152-ac9746cb7013', NULL, 1, 2, '2011-03-01', NULL, false),
	('832b7d08-b644-4538-91f5-e2591afa63e3', '1aec26c0-547f-4114-9905-478adc2da9d5', '5a5c9b6b-7f1c-455d-9909-0cc4fa456001', NULL, 4, NULL, NULL, NULL, true),
	('9e59a8ee-4d6a-4b2d-a0a4-efc290903bdc', 'ffdb1114-ca75-45c9-bb4d-8bc643addf6e', '5a5c9b6b-7f1c-455d-9909-0cc4fa456001', NULL, 1, 2, '2009-09-01', NULL, true),
	('1e8cb948-2d4f-43c8-b114-455e03e7d87f', 'ffdb1114-ca75-45c9-bb4d-8bc643addf6e', '5a5c9b6b-7f1c-455d-9909-0cc4fa456001', NULL, 3, NULL, '2009-09-01', NULL, true),
	('fbda9899-0774-4d94-8dde-e1ecaba0e201', '70866e1a-a586-4779-8937-5dfd324cc6db', '1a3eaa21-e772-49da-ac8b-f26c74c310bd', NULL, 1, 2, '2007-09-01', NULL, true),
	('0dab9d35-6ee4-41ae-baff-6ab636350f5d', '70866e1a-a586-4779-8937-5dfd324cc6db', '1a3eaa21-e772-49da-ac8b-f26c74c310bd', NULL, 3, NULL, '2007-09-01', NULL, true),
	('7e9d3ce5-4264-4ec3-80e2-b5b64f1e83bc', '8917c9ce-932e-42fd-a750-7aaf221d02fc', 'a6af2721-825e-4cb9-afb8-d596208173f8', NULL, 2, NULL, '2010-09-01', NULL, true),
	('8e543230-7516-445e-89ba-1c598c6b586b', 'fa69e872-c3eb-4d5c-8d58-ea39f6326881', '27546d94-e327-49fd-aecb-26c8c043a597', NULL, 4, NULL, NULL, NULL, true),
	('bc76d419-c2d4-4526-93db-05cc3334793f', '29f46cb8-ea36-45d1-a1fa-ef2710c97eb4', 'e6aa6cec-8ee5-47ae-aa64-3a30e0e274a9', NULL, 1, 1, '2011-08-01', NULL, true),
	('964e8a47-3107-41e6-a875-634da3647b36', '88503d93-533c-48d2-baf4-a64302fd0abd', '8c583f6f-fcbf-48be-a29a-82659646e8e1', NULL, 1, 2, '2013-07-01', NULL, true),
	('d2a11fe1-8a97-43b5-9a04-0ebe06c9281e', '88503d93-533c-48d2-baf4-a64302fd0abd', '23f9cb5e-203e-46a1-bb04-d1960561b15c', NULL, 3, NULL, '2013-07-01', NULL, true),
	('0b33fc0e-85e5-4a53-a3b7-17b6804cdcbf', 'a8f4598d-22fc-4a4b-bc77-5f504172e655', 'e471a59d-d17b-422b-9851-b3121c88a757', NULL, 1, 1, '2011-09-01', '2015-08-31', false),
	('6345c30e-37e1-4fd2-b7ac-a19b389082bf', 'ac6b6174-433d-4c19-bb15-23ea234162fa', 'b84e131a-4d76-498c-8cde-b487fca42fd7', NULL, 1, 2, '2009-09-01', '2016-02-29', false),
	('21390e7d-0c0c-4bfb-8319-891ab7228986', '65648f23-38dd-4ec9-9c4d-b43d66c13951', '07499405-9190-472f-ac28-39e405b9afb8', NULL, 2, NULL, '2013-05-20', '2020-06-16', false),
	('865d875f-2a4b-4862-a4c1-2d693aecf90b', '0921e1ca-b510-4a19-819d-fd009558276c', '73d09caa-5883-4fdb-b6b4-c4c45d56a221', NULL, 4, NULL, NULL, NULL, true),
	('9f536113-8e45-49ae-932c-ff75ba4e617a', '299e49bd-2e16-4159-a267-891cf14b3d13', 'ee7f7d2b-c26b-4726-a6d4-d68d5dc73ef3', NULL, 1, 1, '2019-07-09', NULL, true),
	('e068333f-1660-4fb1-96d1-ee637cbf5c9c', '299e49bd-2e16-4159-a267-891cf14b3d13', 'd28c88c1-6741-4fe9-ba5c-4ae4305d1fa0', NULL, 1, 2, '2018-10-09', NULL, false),
	('9cf251f5-b5fc-4f02-9ce5-e703bc376b16', '299e49bd-2e16-4159-a267-891cf14b3d13', 'd28c88c1-6741-4fe9-ba5c-4ae4305d1fa0', NULL, 1, 1, '2016-09-01', NULL, false);


--
-- Data for Name: site; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.site (site_id, address_id, site_name, uprn) VALUES
	('3a37d790-9e4a-49e8-9baf-73c6ae178d3e', 'b2ecd0d4-a56b-44e6-8e04-47f7b7cd4d60', NULL, 3455015782),
	('90c5d71d-f9a4-408c-9e2a-0858c7084d49', '95ea5eeb-892d-496c-9916-096944f2ff36', NULL, 5300060053),
	('da7e6e0d-8c82-42c5-9bcb-1c88758f6d88', 'dd60d0aa-2899-4aff-9593-6334d612d751', NULL, 10006581609),
	('90ddb8c2-f120-4348-8b88-7cb589b79019', '0cbb76b0-7252-4328-a3d9-4cac580f526e', NULL, 100081218005),
	('7e35c2e8-1e8d-480d-bb73-dff63f6d6eee', 'ae61d11d-9568-40d1-b76f-b5667e6c6be0', NULL, 100081212588),
	('4a517027-77eb-4cfd-969c-fe6f474cd792', 'c2857431-87de-4cd5-a1b0-67d88f8cd095', NULL, 100091605340),
	('c0a76400-e225-45b0-9996-5e2362676e93', '181025f3-b1d9-40a2-a52b-a5d2109c9694', NULL, NULL),
	('eb47eeaf-a983-48e5-8758-9749718c1e4c', '7ff2bad4-00b7-467d-abd9-ae3dd825808e', NULL, 10024158444),
	('9f0230e3-fec7-4bdb-a983-5ed9debe9fa9', 'f49c8022-c6f7-4cbd-9ff8-ccff8a620133', NULL, 100091593148),
	('f8ae7e0b-06c6-41f6-8895-d6f74a483741', '795eec1a-aeef-41f1-a4df-7e0258016783', NULL, 10012151948),
	('82e85fc3-187e-457a-9acc-f286ddf3a7f0', 'e2f54a48-3618-4c12-b340-15e0f3006d21', NULL, 100091595925),
	('98add6b1-37d8-4150-ac67-2302c6dd2abd', '35e7e71e-e139-4ed8-a49e-9f75b8af36f6', NULL, 10012152076),
	('667f1161-0c38-45af-9b0b-d0ea733e5fd7', 'fdfacb5e-9ed7-40c6-bb2e-11ac5a3ee363', NULL, 100091656436),
	('98598200-fae1-4046-8433-607c67adc77f', 'c2bb1d15-7d19-48d9-83a5-322b33e59889', NULL, 200001258935),
	('0870116e-59c2-4234-97f8-5ada3b0dee45', '991e4e48-f793-4a9b-8c4e-fa3352883637', NULL, 47000575),
	('ed01fadf-dd6c-4d1a-91fd-8588840562c0', '3fae8037-cdba-46f3-8e8f-be79dad785aa', NULL, 100012750549),
	('e07ff16a-16bb-4931-9025-5d3b4fe2d5ed', '05967a2e-c7c0-478b-91cb-4cf58fac5f17', NULL, NULL),
	('eb5840ea-f69e-4d86-be88-94cc9390fead', '95ce68e2-71c3-46b4-866e-cf421e1b82b1', NULL, 200004392318),
	('b2adecf3-8682-4f88-89dc-b9dea4f28280', '06bcffd1-429a-4bc2-a0a7-48d873227cd0', NULL, 100041036051),
	('283d0eda-efc6-419d-a8f9-a9539ea6677d', '8c9d6190-35d0-4c0b-8875-6b9c57308b9e', NULL, 63154429),
	('1679a083-0b42-4da0-bfae-e6d03348d7be', '591e6319-eced-473c-a2f2-b04721c3b236', NULL, NULL),
	('33645cea-33ae-4fca-b320-56566f867285', '7438f2f2-6e5d-40bb-99bd-54ecccdcc96d', NULL, NULL),
	('b8f4f216-78c9-4bd8-a980-0b5fe421f5c8', 'd1a5c94c-71d3-4832-bf9d-9d03d822c9c3', NULL, 212066),
	('bad0b55e-8e4d-4028-8a9c-e4610496613f', '6a8a846c-0406-481d-a71f-a1bc9ec7741c', NULL, 100032118443),
	('fcc1edb0-f231-4d8d-9769-02a718fe744d', '34cc9a8f-7352-4a25-9f1d-eb0d1a3d76c8', NULL, 100121246035),
	('f9805094-ab22-4d8d-91c0-6434523a3eca', 'fe7c02b6-d604-4404-8116-561b23d7c8a6', NULL, 100091518218),
	('0f167826-6b2c-4bb2-a030-89751fc6a7a2', '8a7e080c-0e81-4cdb-8e63-c652c4417a57', NULL, NULL),
	('f7574d61-d216-4e70-a3c0-0bdf316517c7', '8512bd55-9a5b-4918-a0de-4d32a0cbc504', NULL, 10090666596),
	('6fc0cb9e-a918-451b-9e56-7a9323a16ce6', 'a0a23bd2-1a88-45b0-b220-c9d6f0c9fd68', NULL, 100071418496),
	('9be4d8ea-d3fb-40bb-b6ad-2742773be89a', '358b768f-c8e2-4db8-a275-7b1acc962acb', NULL, 200001203807),
	('e04da8ad-89d1-496a-8d83-f7bda74a7ff7', '735d6e40-9a31-4183-adbb-27517cc7f11d', NULL, 5870097499),
	('cc060fed-1752-40a9-bce4-368a8a19bd0a', 'c2172dce-8b4c-4981-8139-9c891226d37f', NULL, 5870097499),
	('b6878fd5-892d-4c8d-b5d6-08d7f0b200c0', '955b01d8-c2c2-44ec-a3c2-ec180f99872b', NULL, 207177244),
	('e442d722-e42e-4aee-9efd-ad609f1d1e20', 'e7e7b5cf-336c-4711-877a-d68247ea9550', NULL, 207172599),
	('26ded43e-7a54-4e65-826f-1d0fa14f7423', '743fe226-b711-4eaa-8ef6-5dd9e886d033', NULL, 200017096),
	('3978bde7-1ea2-49fc-8ebf-98d1a723a5d4', '83451d87-de52-4f42-83a6-04e1a4154d16', NULL, 207016666),
	('d65fa4c4-08e3-4863-9578-23684002ff48', 'beaaaf41-348e-4367-bfe8-be927f176932', NULL, 207035789),
	('5a17bc8c-6551-4782-bfce-e2dc2960a903', '4993a886-746d-4091-88b9-8431cb4b43fc', NULL, 207162707),
	('20aba254-47ce-4a15-8b10-7a1b5707683f', '4e8725ea-27cf-40cc-b4f0-1166481b093a', NULL, NULL),
	('c41f023c-8654-4424-81c5-b0cf0c8be509', 'e7ab13ee-590a-4fbd-b879-315b337ab19d', NULL, 100091394129),
	('662be469-847c-4ea8-bbea-44e63f51f7c8', '1c26eb64-8dcf-4600-8cea-cd6262c689e8', NULL, 15073795);


--
-- Data for Name: establishment_to_site; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_to_site (establishment_id, site_id, is_main_site) VALUES
	('a8538208-f08a-48a8-bd74-10aecdde50bf', '3a37d790-9e4a-49e8-9baf-73c6ae178d3e', true),
	('4e1f7553-2c83-4e4a-9d4e-8a65a913ae37', '90c5d71d-f9a4-408c-9e2a-0858c7084d49', true),
	('3f96fa85-9b22-43fd-9cd2-c83cb5df5206', 'da7e6e0d-8c82-42c5-9bcb-1c88758f6d88', true),
	('ebab3c21-fd1a-4ec5-9308-48135237ef1d', '90ddb8c2-f120-4348-8b88-7cb589b79019', true),
	('3a1d444e-c986-41ad-9d8e-ea6b87d1ac16', '7e35c2e8-1e8d-480d-bb73-dff63f6d6eee', true),
	('80c0a588-27ee-46c9-8ff6-3b89c19676e3', '4a517027-77eb-4cfd-969c-fe6f474cd792', true),
	('819b02fc-2395-4916-a4ed-b00708f42b04', 'c0a76400-e225-45b0-9996-5e2362676e93', true),
	('058f2896-fe48-4ddb-8192-363b268cddde', 'eb47eeaf-a983-48e5-8758-9749718c1e4c', true),
	('1ded357c-605f-48d4-a4e9-376d0a65f440', '9f0230e3-fec7-4bdb-a983-5ed9debe9fa9', true),
	('5aab769c-9fe6-47a0-9a66-786fd25df82d', 'f8ae7e0b-06c6-41f6-8895-d6f74a483741', true),
	('bd591157-607c-4fca-877c-bbf7b4fcc12e', '82e85fc3-187e-457a-9acc-f286ddf3a7f0', true),
	('ac1b64de-eaad-447f-89f9-74e6b308ca87', '98add6b1-37d8-4150-ac67-2302c6dd2abd', true),
	('b349fdea-f0bb-41ee-be2e-e27a7816ca04', '667f1161-0c38-45af-9b0b-d0ea733e5fd7', true),
	('8589dbf2-eb5b-4a25-9ea0-6db7aaf82faf', '98598200-fae1-4046-8433-607c67adc77f', true),
	('3b634058-fad9-4182-8efb-7135ddd49191', '0870116e-59c2-4234-97f8-5ada3b0dee45', true),
	('ac0b68cb-a088-417e-b146-c12f01189258', 'ed01fadf-dd6c-4d1a-91fd-8588840562c0', true),
	('20a78c18-9bce-4906-8d19-6ea9bd952dca', 'e07ff16a-16bb-4931-9025-5d3b4fe2d5ed', true),
	('ca690855-3c00-4a67-847c-f1dd48cb6d58', 'eb5840ea-f69e-4d86-be88-94cc9390fead', true),
	('3c45ac83-6b0a-459d-9056-6018a6987a52', 'b2adecf3-8682-4f88-89dc-b9dea4f28280', true),
	('ffdb1114-ca75-45c9-bb4d-8bc643addf6e', '283d0eda-efc6-419d-a8f9-a9539ea6677d', true),
	('1aec26c0-547f-4114-9905-478adc2da9d5', '1679a083-0b42-4da0-bfae-e6d03348d7be', true),
	('70866e1a-a586-4779-8937-5dfd324cc6db', '33645cea-33ae-4fca-b320-56566f867285', true),
	('8917c9ce-932e-42fd-a750-7aaf221d02fc', 'b8f4f216-78c9-4bd8-a980-0b5fe421f5c8', true),
	('29f46cb8-ea36-45d1-a1fa-ef2710c97eb4', 'bad0b55e-8e4d-4028-8a9c-e4610496613f', true),
	('fa69e872-c3eb-4d5c-8d58-ea39f6326881', 'fcc1edb0-f231-4d8d-9769-02a718fe744d', true),
	('88503d93-533c-48d2-baf4-a64302fd0abd', 'f9805094-ab22-4d8d-91c0-6434523a3eca', true),
	('a8f4598d-22fc-4a4b-bc77-5f504172e655', '0f167826-6b2c-4bb2-a030-89751fc6a7a2', true),
	('ac6b6174-433d-4c19-bb15-23ea234162fa', 'f7574d61-d216-4e70-a3c0-0bdf316517c7', true),
	('65648f23-38dd-4ec9-9c4d-b43d66c13951', '6fc0cb9e-a918-451b-9e56-7a9323a16ce6', true),
	('75cad99b-1620-47e1-889b-34c984737fb9', '9be4d8ea-d3fb-40bb-b6ad-2742773be89a', true),
	('8b38d17f-41b1-4dd8-ae8e-1c0070fe2364', 'e04da8ad-89d1-496a-8d83-f7bda74a7ff7', true),
	('cc99a28f-f8bc-4943-91c1-fa0a90a05215', 'cc060fed-1752-40a9-bce4-368a8a19bd0a', true),
	('64d47bd5-8867-4345-8c76-b882c683531d', 'b6878fd5-892d-4c8d-b5d6-08d7f0b200c0', true),
	('7ab4fb81-686f-4138-a748-1280a376c808', 'e442d722-e42e-4aee-9efd-ad609f1d1e20', true),
	('00d26539-1e3a-4592-a872-52eeae204a6c', '26ded43e-7a54-4e65-826f-1d0fa14f7423', true),
	('832d2d1c-0d29-43a9-898d-68587861eb14', '3978bde7-1ea2-49fc-8ebf-98d1a723a5d4', true),
	('b846c6d0-a09f-419f-824a-400b26d50a3f', 'd65fa4c4-08e3-4863-9578-23684002ff48', true),
	('f5625438-2d3b-42d9-a18a-697270c51bf3', '5a17bc8c-6551-4782-bfce-e2dc2960a903', true),
	('8b9089a7-7af3-4724-9b5d-f387c67165ad', '20aba254-47ce-4a15-8b10-7a1b5707683f', true),
	('0921e1ca-b510-4a19-819d-fd009558276c', 'c41f023c-8654-4424-81c5-b0cf0c8be509', true),
	('299e49bd-2e16-4159-a267-891cf14b3d13', '662be469-847c-4ea8-bbea-44e63f51f7c8', true);


--
-- Data for Name: organisation_group; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.organisation_group (organisation_group_id, name, organisation_group_type_id, local_authority_id, open_date, close_date) VALUES
	('1aba6352-cab0-4909-99f7-9ea6e5a26a33', 'Federation of Eileen Wade and Milton Ernest VC lower schools', 1, NULL, '2011-01-13', NULL),
	('a07af86f-2bb3-427b-af1b-1107aceb06fb', 'Southend Children''s Centres', 2, 'dc9f9e86-8d80-46b7-87bc-e998cafca819', '2016-10-01', NULL),
	('ca91feeb-a81b-4f94-bc3f-27fe7bd61b26', 'The Federation of Beaufort School and Langley School', 1, NULL, '2012-04-01', '2020-07-01'),
	('9d1d7431-bd7e-4296-ae90-86fcc5efb0b3', 'The Federation of St Elphege''s RC School', 1, NULL, '2006-01-01', NULL),
	('2f04a24f-6a48-4b37-8d3c-7a35cfad4744', 'Hazelbury', 2, '987bd60d-dd0c-4707-818f-d4aeb184a7b8', '2015-09-01', NULL);


--
-- Data for Name: group_identifier; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.group_identifier (group_identifier_id, establishment_party_role_id, organisation_group_id, group_identifier_type_id, group_identifier_issuer_id, value, is_current) VALUES
	('c8fb7c99-0368-49c9-bd90-8d7ca9ce9a62', 'b354c1c9-12d0-42f8-a78a-eea51409d5df', NULL, 1, 1, '2777', true),
	('38ab9b69-9707-4b52-a25d-61d547af5b0f', 'b354c1c9-12d0-42f8-a78a-eea51409d5df', NULL, 2, 1, 'TR00567', true),
	('9550d301-d510-44e5-9ad9-9e540a16fe74', '136d089f-651e-454e-9834-6c2ef6b04186', NULL, 1, 1, '2779', false),
	('0ac8d89d-ce3b-4552-849b-90fe10d7c5cf', '136d089f-651e-454e-9834-6c2ef6b04186', NULL, 2, 1, 'TR00569', false),
	('fad47078-957e-4ba6-8158-6cc286aa7807', 'bb9823b2-4430-446c-9719-d0fe653e537c', NULL, 1, 1, '4949', true),
	('d0e8c513-4c1e-4032-bac5-72309cfa251a', 'bb9823b2-4430-446c-9719-d0fe653e537c', NULL, 2, 1, 'SP00125', true),
	('8d26d1ce-6fb2-4d40-9f70-769860f2382f', 'e3a349f0-fa2f-4dd2-a0d3-eccb299a69cb', NULL, 1, 1, '23869', true),
	('40eb53a7-7336-432c-8202-690c63b2ab79', 'e3a349f0-fa2f-4dd2-a0d3-eccb299a69cb', NULL, 2, 1, 'TR02103', true),
	('0648e17a-ff6f-4112-b827-d3467dfd0c67', 'e3a349f0-fa2f-4dd2-a0d3-eccb299a69cb', NULL, 1, 1, '4737', false),
	('3e8a5f59-2a39-45ca-a9ad-17d26bfa6037', '8992dc3f-6a5b-49d6-9dc4-4efdedd25968', NULL, 1, 1, '2914', true),
	('37f434e8-7924-4e9a-bce5-5e1d892081fd', '8992dc3f-6a5b-49d6-9dc4-4efdedd25968', NULL, 2, 1, 'SP00172', true),
	('95b21573-b757-4d45-b0f1-0678f2191592', '1ebef5f0-237a-4bb3-a6a9-6d20a415614d', NULL, 1, 1, '3839', false),
	('82e6f4cb-4537-44fa-8ce7-63bcbe591140', '1ebef5f0-237a-4bb3-a6a9-6d20a415614d', NULL, 2, 1, 'TR01385', false),
	('64739b3a-9986-4f09-975f-d87bec428dbd', 'f8a6b1e8-8c95-44c0-997c-c29fd7a01b05', NULL, 1, 1, '2055', false),
	('3344edc8-9ad8-43e5-ae49-490abcf0668c', 'f8a6b1e8-8c95-44c0-997c-c29fd7a01b05', NULL, 1, 1, '20364', true),
	('d8c16945-9856-4882-bd8d-ecb3df2f5ee5', 'f8a6b1e8-8c95-44c0-997c-c29fd7a01b05', NULL, 2, 1, 'TR00009', true),
	('fa160989-9e1f-4b12-90d5-2cc9adeab01d', 'd0b2530e-24af-4b26-9243-d227a175c7f8', NULL, 1, 1, '1337', true),
	('17cc69b3-3e21-498f-bbaf-9896500ded41', 'ff0fac23-e58a-4c68-82c4-4c0c98d5d867', NULL, 1, 1, '2613', true),
	('7a4c11ce-f9a6-4e9c-814a-a3c72ad966bf', 'ff0fac23-e58a-4c68-82c4-4c0c98d5d867', NULL, 2, 1, 'SP00099', true),
	('7a8f6120-4aa3-4313-bad7-7c80c55e21ce', '5ce9657f-953c-4e8a-9760-3c225a205a3d', NULL, 1, 1, '3147', true),
	('fa33e6a3-10dd-422c-b16c-44d45a26d941', '5ce9657f-953c-4e8a-9760-3c225a205a3d', NULL, 2, 1, 'TR00830', true),
	('fee2700e-68d2-44ac-98d6-3c87827a82d5', NULL, '1aba6352-cab0-4909-99f7-9ea6e5a26a33', 1, 1, '1809', true),
	('d20a5e5b-4af3-4de6-9018-c059111f175b', NULL, 'a07af86f-2bb3-427b-af1b-1107aceb06fb', 1, 1, '86052', true),
	('58a74fea-e6e6-442e-ad86-8956e7da1af6', 'cf7ce5ef-32af-45e2-b35e-3f45f9022395', NULL, 1, 1, '4920', true),
	('6acd55ed-222c-41b8-94a2-dc6579ba5d6a', 'cf7ce5ef-32af-45e2-b35e-3f45f9022395', NULL, 2, 1, 'TR02256', true),
	('ed05f68b-f0a4-4803-9831-ac68bcadf9e0', 'b6ced685-f7cc-4244-b59c-70249b770975', NULL, 1, 1, '3643', true),
	('0d158521-bde5-415d-bd7e-4676feb43447', 'b6ced685-f7cc-4244-b59c-70249b770975', NULL, 2, 1, 'TR01237', true),
	('f4c68bf4-7462-4fa9-8d96-aae2ab686e1e', 'd8c711fd-26cc-4be1-a227-53251de9a967', NULL, 1, 1, '4118', true),
	('47eb0353-3de8-4bfe-bc56-efbe5f0fc4b2', 'd8c711fd-26cc-4be1-a227-53251de9a967', NULL, 2, 1, 'SP00396', true),
	('3f9e1a44-6750-4de8-b404-7ff8ac31d594', '6d5e3488-6c02-4a22-8f42-4e2f03baf971', NULL, 1, 1, '4119', true),
	('5b68f4e1-ae52-42b9-adf5-1b3d096dd712', '6d5e3488-6c02-4a22-8f42-4e2f03baf971', NULL, 2, 1, 'TR01585', true),
	('0a6a8694-39d9-4e6f-ac03-41502bb0362a', '1455f600-fa01-4d21-9f55-e47c22fbc650', NULL, 1, 1, '4075', true),
	('0972be72-2735-43b1-b325-89f0fd80e4f6', '1455f600-fa01-4d21-9f55-e47c22fbc650', NULL, 2, 1, 'SP00392', true),
	('346ae6a1-ec51-489e-a1c4-88706f70f305', 'b0bf0a0a-84e3-42bc-956f-e52debf2a437', NULL, 1, 1, '4076', true),
	('01d8dbc7-3a98-4184-96f3-d89b76f9db02', 'b0bf0a0a-84e3-42bc-956f-e52debf2a437', NULL, 2, 1, 'TR01553', true),
	('7f84c817-216a-40be-803a-49fe0b369cec', 'cc1f46cb-e18d-43f4-9b0a-55088a556d64', NULL, 1, 1, '1193', true),
	('fae179c0-1b77-4f97-8873-de0b61aba5a3', '91be9dcf-635e-46ea-ab50-e9f823f6895c', NULL, 1, 1, '3641', true),
	('bbfb68e6-44e7-478d-99f5-ece97853a1e2', '91be9dcf-635e-46ea-ab50-e9f823f6895c', NULL, 2, 1, 'TR01236', true),
	('669dd100-bee6-4470-a054-bb30c09d1737', '252aa012-a9e6-48ad-ba5c-3c2841f95d2c', NULL, 1, 1, '2904', true),
	('769110f5-088c-4e79-b477-66f8c48000c1', '252aa012-a9e6-48ad-ba5c-3c2841f95d2c', NULL, 2, 1, 'SP00160', true),
	('d9d36228-e3b7-4885-ab5d-9c5afb0a7d56', '7f35a695-2023-42e3-8f3b-7de32a6a15dc', NULL, 1, 1, '2905', true),
	('ad0d19ce-7b30-4eee-8cb4-a91c31411948', '7f35a695-2023-42e3-8f3b-7de32a6a15dc', NULL, 2, 1, 'TR00661', true),
	('319ffc25-2049-4fbb-9790-70fd0d2271f5', '61ef6eac-fba6-40f1-af0f-2f03ddc433a4', NULL, 1, 1, '2347', false),
	('03b5eba8-8c7f-4ebe-a45d-7b8753675acd', '61ef6eac-fba6-40f1-af0f-2f03ddc433a4', NULL, 2, 1, 'TR00230', false),
	('b5680f9b-d7c5-44c3-b5a2-1f1ef673e8e7', '45871316-f091-4cd9-9e55-ea342245c21f', NULL, 1, 1, '1650', true),
	('1fe90584-bd4b-48c1-98cc-13a593b887f6', NULL, 'ca91feeb-a81b-4f94-bc3f-27fe7bd61b26', 1, 1, '1537', false),
	('d8ebb092-c395-4d0f-af9a-51f6da1356ee', NULL, '9d1d7431-bd7e-4296-ae90-86fcc5efb0b3', 1, 1, '1761', true),
	('49c8175f-bb7c-4bd4-b8a1-43973e7cc99d', NULL, '2f04a24f-6a48-4b37-8d3c-7a35cfad4744', 1, 1, '86008', true),
	('3a954b97-20ca-417b-afca-69a57b25301a', '150c2750-8d3e-4d7b-ab99-c91d2e69ee1c', NULL, 2, 1, 'TR03305', true),
	('8498f449-a1a1-43d1-bbb9-e1fe1192ea5a', '798438a5-950c-4d9b-b902-1d484183844e', NULL, 1, 1, '16279', false),
	('2612fef5-ca0e-491a-971c-3d6012456807', '798438a5-950c-4d9b-b902-1d484183844e', NULL, 2, 1, 'TR03305.old', false),
	('7882a8ad-f74a-439e-9706-e537e17d349f', '798438a5-950c-4d9b-b902-1d484183844e', NULL, 1, 1, '17115', false),
	('b1d20bea-99d3-43b5-924c-e4bfe68f81c6', '798438a5-950c-4d9b-b902-1d484183844e', NULL, 2, 1, 'TR03305.old2', false),
	('7faa96e3-adb0-4228-ac64-04044b25a5a7', '150c2750-8d3e-4d7b-ab99-c91d2e69ee1c', NULL, 1, 1, '17397', true);


--
-- Data for Name: legal_entity_address; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.legal_entity_address (legal_entity_address_id, legal_entity_id, address_id, address_purpose_id, start_date, end_date, is_current) VALUES
	('86a85f03-e609-4ae3-974e-de5e67f4cb4f', '55a5f300-b304-421c-aa4e-1ae2b909b83d', '102bbf17-ca4d-4c0b-a7fd-9bf9944d561c', 3, NULL, NULL, true),
	('acf55744-7c67-48fe-9602-07f78982af07', 'dfbfa842-402d-4c6c-8f07-c2b123d9ab41', '102bbf17-ca4d-4c0b-a7fd-9bf9944d561c', 3, NULL, NULL, true),
	('5fbad865-b841-492a-b1f3-8058e9e5ea8a', 'cb3d2596-28a8-411a-8651-856d75b4e650', '7d93f740-1d47-4dd3-949f-bab2b46f4e19', 3, NULL, NULL, true),
	('ede9545e-6efd-427a-9cae-07db8d104702', '853b8dd4-cd78-4aba-82ce-7b0c207aceac', '5c58eb5d-26f0-4b4e-8c84-7cfabbb2171e', 3, NULL, NULL, true),
	('adbf4842-613a-453f-b29d-1a378d0aee51', '511a8952-b41c-44de-9706-d8791fad664f', '63f812ed-8fe1-49dc-998b-a1e664f87f3a', 3, NULL, NULL, true),
	('08671fea-1c90-4808-a040-2bd6ecb17cd9', '6e00145a-8739-4de7-aaf9-00b88630cd3f', '1067a22a-6844-4a04-a2d9-560db0f289f5', 3, NULL, NULL, true),
	('7503c780-e042-4ff2-8bf4-221bd96b7de5', '00ad3b7a-1658-4128-9152-ac9746cb7013', 'f9b11c38-9fb5-43b2-9edb-b139a3d24b70', 3, NULL, NULL, true),
	('a567687a-7826-45f2-845f-77e4611f2c2c', '5a5c9b6b-7f1c-455d-9909-0cc4fa456001', 'ff63e911-f803-46a8-b294-b90f38e07dbe', 3, NULL, NULL, true),
	('5f3aa9d8-057e-4f94-bf5b-5d6bd1362917', '1a3eaa21-e772-49da-ac8b-f26c74c310bd', '222c9481-d10d-4eea-b268-18cb5b6490ae', 3, NULL, NULL, true),
	('47869d10-9722-45d8-a160-9a445a472f90', 'e6aa6cec-8ee5-47ae-aa64-3a30e0e274a9', '0dc77638-e1c7-4ce1-b2fa-550084604543', 3, NULL, NULL, true),
	('f511e568-91de-41bb-8356-e13236db70b7', '8c583f6f-fcbf-48be-a29a-82659646e8e1', '9c8503d8-9f53-4434-8357-6f3e4ea79867', 3, NULL, NULL, true),
	('27dab2fc-c743-4062-ba73-685492d0424f', 'e471a59d-d17b-422b-9851-b3121c88a757', '50b1a490-3ff6-4883-934c-d38d6a643367', 3, NULL, NULL, true),
	('95d11493-aadb-45f7-aff3-d8aef4f10d47', 'b84e131a-4d76-498c-8cde-b487fca42fd7', '891e80ad-b535-4de3-b956-0e115851ae7b', 3, NULL, NULL, true),
	('93dbef42-ac12-464c-bec2-eeb209b764fa', 'd28c88c1-6741-4fe9-ba5c-4ae4305d1fa0', '38becec9-0b08-488f-8dcd-755e4f8c9ae5', 3, NULL, NULL, true),
	('b6d0a72e-b42c-4970-9276-5b88713e6cea', 'ee7f7d2b-c26b-4726-a6d4-d68d5dc73ef3', 'e1ea8411-76b7-49a5-8ee0-aa375e6f30c1', 3, NULL, NULL, true);


--
-- Data for Name: organisation_group_address; Type: TABLE DATA; Schema: establishment; Owner: -
--



--
-- Data for Name: organisation_group_member; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.organisation_group_member (organisation_group_member_id, organisation_group_id, establishment_id, joined_date, left_date) VALUES
	('8508c5ec-9ed3-456a-a8ab-513928168610', '1aba6352-cab0-4909-99f7-9ea6e5a26a33', '3a1d444e-c986-41ad-9d8e-ea6b87d1ac16', '2011-01-13', NULL),
	('2706cf19-3ee4-4bb8-89e6-84961fc7e705', '1aba6352-cab0-4909-99f7-9ea6e5a26a33', 'ebab3c21-fd1a-4ec5-9308-48135237ef1d', '2011-01-13', NULL),
	('bf748f2c-65ab-42c4-abf2-e7c2ad212874', 'a07af86f-2bb3-427b-af1b-1107aceb06fb', '8589dbf2-eb5b-4a25-9ea0-6db7aaf82faf', '2016-10-01', NULL),
	('dd01070c-2535-46b8-9edf-fc95d7bf28f6', 'a07af86f-2bb3-427b-af1b-1107aceb06fb', '1ded357c-605f-48d4-a4e9-376d0a65f440', '2016-10-01', NULL),
	('dc25cf85-9d83-4d49-9fc1-6e07d36eb388', 'a07af86f-2bb3-427b-af1b-1107aceb06fb', '5aab769c-9fe6-47a0-9a66-786fd25df82d', '2016-10-01', NULL),
	('5c52ebd6-7a47-4e82-88cd-9915e8ea2489', 'a07af86f-2bb3-427b-af1b-1107aceb06fb', '80c0a588-27ee-46c9-8ff6-3b89c19676e3', '2016-10-01', NULL),
	('6158584a-46e6-4ea3-b5c9-29ef01df0ddf', 'a07af86f-2bb3-427b-af1b-1107aceb06fb', 'bd591157-607c-4fca-877c-bbf7b4fcc12e', '2016-10-01', NULL),
	('8892d5a1-ff27-4048-a232-22d11d6315e3', 'a07af86f-2bb3-427b-af1b-1107aceb06fb', '819b02fc-2395-4916-a4ed-b00708f42b04', '2016-10-01', NULL),
	('035f1690-1375-43e2-87da-12edfe5877d1', 'a07af86f-2bb3-427b-af1b-1107aceb06fb', 'b349fdea-f0bb-41ee-be2e-e27a7816ca04', '2016-10-01', NULL),
	('1e79d50a-68af-4043-8f6f-6d6650c26120', 'a07af86f-2bb3-427b-af1b-1107aceb06fb', 'ac1b64de-eaad-447f-89f9-74e6b308ca87', '2016-10-01', NULL),
	('d9d10e34-b2a9-4f87-a557-3c959686c2e7', 'a07af86f-2bb3-427b-af1b-1107aceb06fb', '058f2896-fe48-4ddb-8192-363b268cddde', '2016-10-01', NULL),
	('2436f047-9db7-4221-8e75-c9782eb6b706', 'ca91feeb-a81b-4f94-bc3f-27fe7bd61b26', '65648f23-38dd-4ec9-9c4d-b43d66c13951', '2012-04-01', '2020-06-16'),
	('b821017a-2109-4f54-874d-4c9238db28f6', '9d1d7431-bd7e-4296-ae90-86fcc5efb0b3', '75cad99b-1620-47e1-889b-34c984737fb9', '2014-09-15', NULL),
	('c5049935-e5cd-4334-9279-1c2477bb5520', '9d1d7431-bd7e-4296-ae90-86fcc5efb0b3', 'cc99a28f-f8bc-4943-91c1-fa0a90a05215', '2006-01-01', NULL),
	('e26a7585-02ab-46b9-a9dd-994254c21d18', '9d1d7431-bd7e-4296-ae90-86fcc5efb0b3', '8b38d17f-41b1-4dd8-ae8e-1c0070fe2364', '2006-01-01', NULL),
	('1d55c956-0676-42a7-b089-79b1dc57617e', '2f04a24f-6a48-4b37-8d3c-7a35cfad4744', '832d2d1c-0d29-43a9-898d-68587861eb14', '2016-02-01', NULL),
	('6cc2c8de-3086-42c8-9854-6c264e2ac177', '2f04a24f-6a48-4b37-8d3c-7a35cfad4744', '7ab4fb81-686f-4138-a748-1280a376c808', '2016-02-01', NULL),
	('fd587f97-94ad-47f9-97a2-a18efa05349e', '2f04a24f-6a48-4b37-8d3c-7a35cfad4744', 'f5625438-2d3b-42d9-a18a-697270c51bf3', '2016-02-01', NULL),
	('5fc7b681-1f43-4d28-a945-5afff3cc53f6', '2f04a24f-6a48-4b37-8d3c-7a35cfad4744', 'b846c6d0-a09f-419f-824a-400b26d50a3f', '2016-02-01', NULL),
	('70251a76-1222-41da-b033-14ba23c087b5', '2f04a24f-6a48-4b37-8d3c-7a35cfad4744', '00d26539-1e3a-4592-a872-52eeae204a6c', '2016-02-01', NULL),
	('29a65f6f-7bc3-46fd-9b43-86ea918d793f', '2f04a24f-6a48-4b37-8d3c-7a35cfad4744', '8b9089a7-7af3-4724-9b5d-f387c67165ad', '2016-02-01', NULL),
	('e01bae73-6ffe-454a-9e29-73f49b5b93f7', '2f04a24f-6a48-4b37-8d3c-7a35cfad4744', '64d47bd5-8867-4345-8c76-b882c683531d', '2016-02-01', NULL);


--
-- Data for Name: organisation_group_member_lead_period; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.organisation_group_member_lead_period (organisation_group_member_lead_period_id, organisation_group_member_id, organisation_group_id, start_date, end_date, is_current) VALUES
	('7849a305-c7cb-47ab-bb1a-0591f1e3236e', '8892d5a1-ff27-4048-a232-22d11d6315e3', 'a07af86f-2bb3-427b-af1b-1107aceb06fb', NULL, NULL, true),
	('56b92855-399f-40e1-bf9b-1cf1bd5e6d07', '1d55c956-0676-42a7-b089-79b1dc57617e', '2f04a24f-6a48-4b37-8d3c-7a35cfad4744', NULL, NULL, true);


--
-- Data for Name: organisation_identifier; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.organisation_identifier (organisation_identifier_id, legal_entity_id, organisation_identifier_type_id, value, is_current) VALUES
	('d2070393-5b77-4a28-8ad3-f72b5279c2f2', '55a5f300-b304-421c-aa4e-1ae2b909b83d', 1, '07747126', true),
	('77f3ff7d-8638-4c4c-bd9f-c55570087b3a', '55a5f300-b304-421c-aa4e-1ae2b909b83d', 2, '10059286', true),
	('cea4f80b-e279-4d45-a816-94a37f5d9a2b', 'dfbfa842-402d-4c6c-8f07-c2b123d9ab41', 1, '07158839', true),
	('867f94f5-0aab-4ded-b6db-4f87eea64517', 'dfbfa842-402d-4c6c-8f07-c2b123d9ab41', 2, '10061289', true),
	('3d4f090d-47c5-4077-907e-323f44d9015b', 'cb3d2596-28a8-411a-8651-856d75b4e650', 1, '05412502', true),
	('e9122f1c-851a-419f-af2d-585c6526a947', 'cb3d2596-28a8-411a-8651-856d75b4e650', 2, '10058191', true),
	('72dd6ede-1bc6-4549-944e-24dfdce4b137', 'b84e131a-4d76-498c-8cde-b487fca42fd7', 1, '06888873', true),
	('93cfe5c8-5f44-432d-877a-b93483c6a7a2', '853b8dd4-cd78-4aba-82ce-7b0c207aceac', 1, '07795736', true),
	('66321b8a-628b-412d-8f5f-1ff05420f7bb', '853b8dd4-cd78-4aba-82ce-7b0c207aceac', 2, '10059335', true),
	('6cf6679a-bbd5-476f-a256-1bc3368ef651', '511a8952-b41c-44de-9706-d8791fad664f', 1, '06960253', true),
	('c533ad27-3317-41d7-9fd1-2a3aa768e48f', '511a8952-b41c-44de-9706-d8791fad664f', 2, '10058269', true),
	('5cab02d7-a45e-4582-9446-bbe639efa2e3', '00ad3b7a-1658-4128-9152-ac9746cb7013', 1, '07518252', true),
	('6c87d1fb-bf60-4c7e-b94b-8731822db599', '00ad3b7a-1658-4128-9152-ac9746cb7013', 2, '10058494', true),
	('72778170-c02b-488c-a0dc-a37074822650', '6e00145a-8739-4de7-aaf9-00b88630cd3f', 1, '07451553', true),
	('fa6a3e85-1852-4323-9e9a-9414409dd087', '6e00145a-8739-4de7-aaf9-00b88630cd3f', 2, '10058417', true),
	('f03986aa-6d13-45bc-b83d-324736fd0138', '5a5c9b6b-7f1c-455d-9909-0cc4fa456001', 1, '06995649', true),
	('54071d4d-c141-4c29-b0ea-954374cdc4b9', '5a5c9b6b-7f1c-455d-9909-0cc4fa456001', 2, '10058273', true),
	('baffb4a1-0a69-4f9e-a982-9540a14e755a', '1a3eaa21-e772-49da-ac8b-f26c74c310bd', 1, '05398529', true),
	('12f76fee-193e-45d1-9313-be7099aded95', '1a3eaa21-e772-49da-ac8b-f26c74c310bd', 2, '10058190', true),
	('956dddbc-5b44-4454-a842-f7d5ad3f81bb', 'e6aa6cec-8ee5-47ae-aa64-3a30e0e274a9', 1, '07706900', true),
	('c577be60-7020-4532-b0a2-d1e316f0bb3c', 'e6aa6cec-8ee5-47ae-aa64-3a30e0e274a9', 2, '10059149', true),
	('3a2044fb-0f29-4b8b-8d82-861fc41a9768', '8c583f6f-fcbf-48be-a29a-82659646e8e1', 1, '08464996', true),
	('81e6afa7-7d4a-49dc-9699-503d8d687cec', '8c583f6f-fcbf-48be-a29a-82659646e8e1', 2, '10060395', true),
	('7bd7f0aa-097a-436b-98b4-b269fc6b0158', 'e471a59d-d17b-422b-9851-b3121c88a757', 1, '07556132', true),
	('e3e76c73-6ae6-43df-913a-56a72bc9f643', 'ee7f7d2b-c26b-4726-a6d4-d68d5dc73ef3', 1, '08782697', true),
	('ba30d075-d87d-4732-b1d8-7a1b4ddd3a92', 'ee7f7d2b-c26b-4726-a6d4-d68d5dc73ef3', 2, '10064301', true);


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
	('9f7bfef3-4aab-4ab7-97c6-966d56af2bc2', '2638b68f-a55e-4b91-96db-f679dbcd3b63', 11, 16),
	('6b0e068f-b0a4-4293-83bf-d9f6e1c24bfc', '0bc1a84c-ffe1-4a3c-9637-7356890eabcc', 4, 19),
	('2f75d6c2-4ca1-49f3-965f-aa5064858372', 'a9f267a2-734c-4777-8146-599076b8abc2', 11, 19),
	('4dc1b6f5-2e04-4bdf-ae5c-358f19a7828b', 'f8d0a9e7-1172-4d9b-9863-889cbc972ef4', 5, 11),
	('afb410a3-8aba-4adc-a8e6-5f08d75af1ee', '92f7b8a4-3e12-4f13-8346-f3b51d86ca43', 4, 11),
	('c6fd080e-2745-4c09-85b9-aa9c3133f169', '2f0b4d41-e944-44e9-9476-e8313e0a76f1', 3, 11),
	('a3bcca7f-7c11-4803-b03c-608ba26db29b', 'b9fb6299-e813-4b82-a9a9-abff282b2d5e', 11, 16),
	('418d0545-df65-4c62-bb3a-5a921825cddd', 'b71e5e25-a5ea-494c-95a6-005356b4b80e', 5, 19),
	('51c6d495-806d-4c2f-92ec-58f061fed36a', '76daf53c-741e-4052-8ee4-5d9fdf9f5ea1', 5, 18),
	('7cf022c2-d5c7-4472-aaa2-f3219178d26d', '24e95ed4-57a1-4b91-be98-87785e2d712a', 11, 18),
	('46dce56b-0713-4354-af01-660cc09b153a', 'cff649d5-73f5-4427-94f7-c2b6cd7a9410', 11, 18),
	('a6e9f9ca-9043-409e-8be7-a2266ae1416d', '768c2866-6734-42cf-9784-2670238e5522', 11, 18),
	('eebdd5d6-e798-4d06-b79a-77dedd351c4c', '1e84d55a-56cb-4dcd-9253-ea9d947db8aa', 6, 19),
	('d2e65010-6d18-4d7c-a68e-5ccfb1b5f109', '5343a8f9-17a6-4db9-b5cb-9befd76f0a51', 11, 18),
	('62c1459b-f408-44e3-b78a-9e49d6c0e984', '9fcfda35-5648-4718-9a39-7d4c3e7285d4', 3, 18),
	('d6269db4-1d3f-485b-b5e7-472a557eb220', 'b876c2a5-20e6-4ace-8439-0bc069be014d', 4, 11),
	('510b3f62-db10-48b6-af55-d5d015ec48dd', '2e253ce6-cbb6-4a34-b392-604221556f78', 14, 19),
	('574612fd-9079-4a95-a808-ead20de5303b', '6e676e70-e686-465d-a8b1-343f24352b61', 11, 19),
	('8820e651-4548-43ef-802a-10460475b629', '702277ef-a2cd-4b6b-bf4d-cff6e4dbf289', 3, 11),
	('4669c12b-eb10-46fb-8a34-9103abbb468f', 'c0ee262b-cba3-4003-8409-1595438cb4da', 4, 11),
	('8a4727d8-96f2-437c-b062-c2620ab3f1da', '6b6ef742-2051-4e29-98c5-7d7bbeab7b3b', 7, 11),
	('f2b80552-a584-4523-a77d-d8da4c79ca41', '03acdc8e-b738-4915-b734-9d937c71a50a', 3, 7),
	('827219da-e909-4327-ac8e-d14b99bbc905', '3e6638e7-8e0a-40d0-ab01-df53fc0b46da', 5, 18),
	('98b0005a-d19b-436d-b6e7-4e4a042f0a4f', '8ed2ea80-df01-49fd-b95f-bb583e2ff9cb', 4, 19);


--
-- PostgreSQL database dump complete
--

\unrestrict RM9PhMQLlrQ5daQlLBNkCeqgok7aZLQU2tjao9wjxm5h5p8EJVJt3k3yW0ECeyO

