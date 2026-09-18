--
-- PostgreSQL database dump
--

\restrict pvbtsBgN4RVTgHXhVGFV9b7fqovsEHg3LTOHHxFs1PjajlzA2M5ZJRImQeCnqUg

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
-- Data for Name: admissions_policy; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.admissions_policy (admissions_policy_id, name) VALUES (2, 'Selective');
INSERT INTO establishment.admissions_policy (admissions_policy_id, name) VALUES (1, 'Non-selective');
INSERT INTO establishment.admissions_policy (admissions_policy_id, name) VALUES (3, 'Not applicable (admissions policy)');


--
-- Data for Name: boarding_provision; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.boarding_provision (boarding_provision_id, name) VALUES (1, 'No boarders');
INSERT INTO establishment.boarding_provision (boarding_provision_id, name) VALUES (2, 'Has boarders');
INSERT INTO establishment.boarding_provision (boarding_provision_id, name) VALUES (3, 'Boarding school');


--
-- Data for Name: education_phase; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.education_phase (education_phase_id, name) VALUES (1, 'Nursery');
INSERT INTO establishment.education_phase (education_phase_id, name) VALUES (3, 'Middle deemed primary');
INSERT INTO establishment.education_phase (education_phase_id, name) VALUES (4, 'Middle deemed secondary');
INSERT INTO establishment.education_phase (education_phase_id, name) VALUES (6, 'All-through');
INSERT INTO establishment.education_phase (education_phase_id, name) VALUES (7, '16 to 19');
INSERT INTO establishment.education_phase (education_phase_id, name) VALUES (8, 'Not applicable (education phase)');
INSERT INTO establishment.education_phase (education_phase_id, name) VALUES (2, 'Primary');
INSERT INTO establishment.education_phase (education_phase_id, name) VALUES (5, 'Secondary');


--
-- Data for Name: establishment_status; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_status (establishment_status_id, code, name) VALUES (1, 1, 'Open');
INSERT INTO establishment.establishment_status (establishment_status_id, code, name) VALUES (2, 2, 'Closed');
INSERT INTO establishment.establishment_status (establishment_status_id, code, name) VALUES (3, 3, 'Open, but proposed to close');
INSERT INTO establishment.establishment_status (establishment_status_id, code, name) VALUES (4, 4, 'Proposed to open');


--
-- Data for Name: establishment_type; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_type (establishment_type_id, name) VALUES (2, 'Community special school');
INSERT INTO establishment.establishment_type (establishment_type_id, name) VALUES (3, 'Foundation special school');
INSERT INTO establishment.establishment_type (establishment_type_id, name) VALUES (5, 'Academy special school');
INSERT INTO establishment.establishment_type (establishment_type_id, name) VALUES (6, 'Academy alternative provision');
INSERT INTO establishment.establishment_type (establishment_type_id, name) VALUES (7, 'Academy 16 to 19');
INSERT INTO establishment.establishment_type (establishment_type_id, name) VALUES (8, 'Academy secure 16 to 19');
INSERT INTO establishment.establishment_type (establishment_type_id, name) VALUES (9, 'Voluntary aided school');
INSERT INTO establishment.establishment_type (establishment_type_id, name) VALUES (10, 'Voluntary controlled school');
INSERT INTO establishment.establishment_type (establishment_type_id, name) VALUES (11, 'Foundation school');
INSERT INTO establishment.establishment_type (establishment_type_id, name) VALUES (12, 'Pupil referral unit');
INSERT INTO establishment.establishment_type (establishment_type_id, name) VALUES (13, 'Maintained nursery school');
INSERT INTO establishment.establishment_type (establishment_type_id, name) VALUES (14, 'Non-maintained special school');
INSERT INTO establishment.establishment_type (establishment_type_id, name) VALUES (15, 'Other independent special school');
INSERT INTO establishment.establishment_type (establishment_type_id, name) VALUES (16, 'City technology college');
INSERT INTO establishment.establishment_type (establishment_type_id, name) VALUES (17, 'Other independent school');
INSERT INTO establishment.establishment_type (establishment_type_id, name) VALUES (18, 'Further education');
INSERT INTO establishment.establishment_type (establishment_type_id, name) VALUES (19, 'Sixth form centre');
INSERT INTO establishment.establishment_type (establishment_type_id, name) VALUES (20, 'Higher education institution');
INSERT INTO establishment.establishment_type (establishment_type_id, name) VALUES (21, 'University technical college');
INSERT INTO establishment.establishment_type (establishment_type_id, name) VALUES (22, 'Welsh establishment');
INSERT INTO establishment.establishment_type (establishment_type_id, name) VALUES (23, 'Secure units');
INSERT INTO establishment.establishment_type (establishment_type_id, name) VALUES (24, 'Offshore schools');
INSERT INTO establishment.establishment_type (establishment_type_id, name) VALUES (25, 'Service children''s education');
INSERT INTO establishment.establishment_type (establishment_type_id, name) VALUES (26, 'Miscellaneous');
INSERT INTO establishment.establishment_type (establishment_type_id, name) VALUES (27, 'Special post 16 institution');
INSERT INTO establishment.establishment_type (establishment_type_id, name) VALUES (28, 'British schools overseas');
INSERT INTO establishment.establishment_type (establishment_type_id, name) VALUES (29, 'Institution funded by other government department');
INSERT INTO establishment.establishment_type (establishment_type_id, name) VALUES (30, 'Free schools');
INSERT INTO establishment.establishment_type (establishment_type_id, name) VALUES (31, 'Free schools special');
INSERT INTO establishment.establishment_type (establishment_type_id, name) VALUES (32, 'Free schools alternative provision');
INSERT INTO establishment.establishment_type (establishment_type_id, name) VALUES (33, 'Free schools 16 to 19');
INSERT INTO establishment.establishment_type (establishment_type_id, name) VALUES (34, 'Studio schools');
INSERT INTO establishment.establishment_type (establishment_type_id, name) VALUES (35, 'Children''s centre');
INSERT INTO establishment.establishment_type (establishment_type_id, name) VALUES (36, 'Children''s centre linked site');
INSERT INTO establishment.establishment_type (establishment_type_id, name) VALUES (37, 'Online provider');
INSERT INTO establishment.establishment_type (establishment_type_id, name) VALUES (1, 'Community school');
INSERT INTO establishment.establishment_type (establishment_type_id, name) VALUES (4, 'Mainstream academy');


--
-- Data for Name: gender_of_entry_type; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.gender_of_entry_type (gender_of_entry_type_id, name) VALUES (1, 'Mixed');
INSERT INTO establishment.gender_of_entry_type (gender_of_entry_type_id, name) VALUES (2, 'Boys');
INSERT INTO establishment.gender_of_entry_type (gender_of_entry_type_id, name) VALUES (3, 'Girls');
INSERT INTO establishment.gender_of_entry_type (gender_of_entry_type_id, name) VALUES (4, 'Not applicable (gender of entry)');


--
-- Data for Name: government_office_region; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.government_office_region (government_office_region_id, code, name) VALUES ('2b2adf05-0f50-4d22-8318-a2803e8c0bd7', 'A', 'North East');
INSERT INTO establishment.government_office_region (government_office_region_id, code, name) VALUES ('bcd24826-f4c1-42fd-b10f-a1c9f8dfdab9', 'B', 'North West');
INSERT INTO establishment.government_office_region (government_office_region_id, code, name) VALUES ('04bdb243-5603-48e2-8da4-0e383082fe8b', 'D', 'Yorkshire and the Humber');
INSERT INTO establishment.government_office_region (government_office_region_id, code, name) VALUES ('a662279e-cc78-4933-9628-63ceb5f9a1fd', 'E', 'East Midlands');
INSERT INTO establishment.government_office_region (government_office_region_id, code, name) VALUES ('0f439fe1-5bb7-4246-b856-67b30114e097', 'F', 'West Midlands');
INSERT INTO establishment.government_office_region (government_office_region_id, code, name) VALUES ('4a86f1ef-ae77-427a-9efb-8e8839710636', 'G', 'East of England');
INSERT INTO establishment.government_office_region (government_office_region_id, code, name) VALUES ('83a2bdc1-f953-4fd4-b171-7236e1e72f5a', 'H', 'London');
INSERT INTO establishment.government_office_region (government_office_region_id, code, name) VALUES ('642f9004-fc4a-4d85-9d9f-07a7d2c1ab61', 'J', 'South East');
INSERT INTO establishment.government_office_region (government_office_region_id, code, name) VALUES ('22a54a29-afa3-4e90-8bf5-178959900e4c', 'K', 'South West');
INSERT INTO establishment.government_office_region (government_office_region_id, code, name) VALUES ('ee368f7c-e262-4ae9-8506-c73a7cfbe7bc', 'N', 'Not Applicable (Archived)');
INSERT INTO establishment.government_office_region (government_office_region_id, code, name) VALUES ('ea19330e-ed8c-4ccb-83b3-7f52ad7575c2', 'W', 'Wales (pseudo)');
INSERT INTO establishment.government_office_region (government_office_region_id, code, name) VALUES ('4b9cf6ec-8567-4652-aee8-d686445d032a', 'Z', 'Not Applicable');


--
-- Data for Name: local_authority_jurisdiction; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.local_authority_jurisdiction (local_authority_jurisdiction_id, name) VALUES (1, 'English');
INSERT INTO establishment.local_authority_jurisdiction (local_authority_jurisdiction_id, name) VALUES (2, 'Welsh');


--
-- Data for Name: local_authority; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('563065c7-e487-4a0b-b527-bc53d934f047', 201, 'City of London', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('62ab8205-c94e-43eb-92ee-c66f767d50ad', 202, 'Camden', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('4217059c-dbfb-4437-9a4b-2c8ad7f52d45', 203, 'Greenwich', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('25fe65f4-2f73-4ef7-a535-66a1cbf81f7a', 204, 'Hackney', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('20c4f763-5d9b-42eb-9b77-22ecb4ac72f8', 205, 'Hammersmith and Fulham', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('8110a266-97bf-4867-a143-acb4ec3df01f', 206, 'Islington', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('2559799e-92c6-4d25-93b3-9c9ca144f4aa', 207, 'Kensington and Chelsea', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('7d43f822-5912-4309-91a2-cbda3c308baa', 208, 'Lambeth', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('57736c5e-4680-4a80-a29a-5a986391bab1', 209, 'Lewisham', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('6cef5e59-6100-43a6-ba32-9117824fcc63', 210, 'Southwark', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('02941e4d-bb2d-420f-a422-47dfd5d62c46', 211, 'Tower Hamlets', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('e289f440-d251-4335-8e86-aec1eb64b30e', 212, 'Wandsworth', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('52022c02-ccbc-4d26-945d-bda8838fd90a', 213, 'Westminster', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('809c29c7-1226-4159-be13-54c72dc55e4e', 301, 'Barking and Dagenham', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('d6aca7e1-9839-4742-a771-6dffdc0eb11c', 302, 'Barnet', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('43cfde53-66a9-483a-ae1e-5769f2af273a', 303, 'Bexley', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('33fa39b5-6d85-4082-820f-ea2af308665c', 304, 'Brent', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('24c0d351-65ff-42b9-be16-a4c7c2b79833', 305, 'Bromley', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('27760f93-da7a-4443-9e94-729603c692fa', 306, 'Croydon', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('943878e5-592a-4bd8-875f-cdfe9eee4bbf', 307, 'Ealing', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('11316c6f-b469-4b7d-8f98-7595ab75081e', 308, 'Enfield', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('dbcc227b-28c9-4a24-b630-7e48cb638063', 309, 'Haringey', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('93638e7f-57c2-4013-9229-313456965f7a', 310, 'Harrow', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('ec3746c0-4927-4a37-ac23-9771c7d38acd', 311, 'Havering', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('6ed547fd-3bc4-4acc-9beb-8ab13dda81d4', 312, 'Hillingdon', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('f72ab82f-4aaf-4c1e-855f-9229e63fd056', 313, 'Hounslow', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('8975fa26-cacc-49d5-bee0-275b1d394939', 314, 'Kingston upon Thames', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('133c6cb0-de69-4252-85a2-e23ca5e8f5f7', 315, 'Merton', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('ecb4d7d2-42d2-4c96-ab82-e9443b59283c', 316, 'Newham', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('1d5089cf-75a9-4d5c-b61d-10317b83fa13', 317, 'Redbridge', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('5de3a306-35e1-4cba-90cf-360cdbf58992', 318, 'Richmond upon Thames', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('29969b77-9d3c-4d4b-8ae6-e35e25b2691e', 319, 'Sutton', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('25da90ae-6c71-486c-82f3-02be09b7ff90', 320, 'Waltham Forest', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('43971b89-5605-497f-9bf3-c8ba8b06ce09', 330, 'Birmingham', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('22359907-b2af-4331-834b-5ed8930da789', 331, 'Coventry', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('3a6d2c2f-c004-4bb6-8ca0-7756ef9709c7', 332, 'Dudley', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('88b1b957-4ac3-4d87-9d17-86466e62d1cd', 333, 'Sandwell', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('378e52db-2a7b-43d9-b753-6d48c380ecb1', 334, 'Solihull', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('17806310-fe94-4500-825f-a5ceecd483e9', 335, 'Walsall', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('5fd44d59-26d7-4e8d-8aaf-03544cb9524b', 336, 'Wolverhampton', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('99180cfc-0c13-45ba-8580-2b71c2e58598', 340, 'Knowsley', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('4ccb2102-46d2-4dc2-a31f-45d253cad837', 341, 'Liverpool', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('ded6b8e4-9fc1-48b3-a421-f35802812dd3', 342, 'St. Helens', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('8adb8d61-a92d-41b2-9a73-80a38f752de2', 343, 'Sefton', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('fd277c68-4c7f-4243-9a0b-0d02ceedfad6', 344, 'Wirral', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('d11978fa-a251-4cdb-9ca3-864da9c0a162', 350, 'Bolton', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('29620c7f-a684-461c-9dc6-aa7a47049983', 351, 'Bury', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('ea409b0f-9151-4c70-aed2-e8ae9f6bdd0e', 352, 'Manchester', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('6ff294b3-2ff4-4b70-9986-922383c44bc6', 353, 'Oldham', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('10514a56-fb54-483a-8eba-b2dca558fe13', 354, 'Rochdale', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('f1ac4ad1-e186-470e-8120-af7f9917ffc0', 355, 'Salford', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('ea334930-a1dd-400a-b128-2246fa6ff9ac', 356, 'Stockport', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('ea3db851-2958-4181-aa79-87f74316bdac', 357, 'Tameside', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('e764e819-2ca7-4d26-b94e-88b849584baa', 358, 'Trafford', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('9209d19b-f883-4784-8b40-635c3afa0e9a', 359, 'Wigan', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('ece35c83-f91d-4b21-8f8b-6aaf46240f99', 370, 'Barnsley', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('ceb0a132-1650-473e-9356-b253dab5d19c', 371, 'Doncaster', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('0cc820e6-aa5e-4ca6-919c-8ff30a5bccbf', 372, 'Rotherham', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('e7cba7e7-a382-470b-9730-843474183ebe', 373, 'Sheffield', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('1b785419-75d6-4ef1-a7ba-c0dfa034edbb', 380, 'Bradford', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('14883dbe-92c2-4b00-bb01-d37aec93dbfc', 381, 'Calderdale', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('a718b082-18a0-4283-a4ed-39272d819948', 382, 'Kirklees', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('7ca7d61a-063e-4f97-bb43-6064c2713af1', 383, 'Leeds', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('a3258295-7adc-491c-be73-a9b988227bea', 384, 'Wakefield', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('a6a5eddc-bfef-4547-b21a-001a74a30ce3', 390, 'Gateshead', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('987c6ba9-821a-4a8f-9b0f-dde9ade0ab68', 391, 'Newcastle upon Tyne', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('45cde1eb-52f1-4ca7-8ddb-545dc27fa7ee', 392, 'North Tyneside', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('a1166517-eb7a-4718-a6ec-5cdd71e28c71', 393, 'South Tyneside', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('145f92df-3549-4674-acd7-67839f98b0f7', 394, 'Sunderland', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('09fae6d6-2d82-4a69-892c-96650f957dc7', 420, 'Isles Of Scilly', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('89de95bc-1116-4204-b702-bbf9bf08d168', 660, 'Isle of Anglesey', 2);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('c434a335-4f15-4427-8b04-8fe6ca9dd189', 661, 'Gwynedd', 2);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('c1d75a9e-9cf3-4692-866b-403305054caa', 662, 'Conwy', 2);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('381da4ef-5b7c-4a98-825d-8dc5dee27dc4', 663, 'Denbighshire', 2);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('bd266d44-f528-4060-a921-a84c70e3b14a', 664, 'Flintshire', 2);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('c36eb8d2-0b2f-4d72-bbf2-e1cfaa0ca718', 665, 'Wrexham', 2);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('31eaf556-9a24-44f7-ada4-eed35e160db8', 666, 'Powys', 2);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('b3c93ff5-95ec-4fb0-9679-c6536fc14f70', 667, 'Ceredigion', 2);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('0d8946c9-f4ac-4ecf-96e0-df4e7640b2c6', 668, 'Pembrokeshire', 2);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('3184d075-9aba-43f9-bd60-add770bff5ea', 669, 'Carmarthenshire', 2);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('e649f2b5-9189-4b4e-bf74-39fb00b32474', 670, 'Swansea', 2);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('2ed968a4-bf5f-4796-b2ea-31efb74cd608', 671, 'Neath Port Talbot', 2);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('9059a2db-949e-4a9e-9dfb-2a38cd8823bd', 672, 'Bridgend', 2);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('67e1b156-4f50-495d-88d0-b9312251dc6d', 673, 'Vale of Glamorgan', 2);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('77bc5a24-5a1f-49cc-b9ff-4948ceb8abba', 674, 'Rhondda Cynon Taf', 2);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('34f3145f-074a-42e1-8705-146143592528', 675, 'Merthyr Tydfil', 2);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('b4c10a73-445c-4555-9171-1ee3027d6803', 676, 'Caerphilly', 2);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('05450f5c-b407-4f67-af9c-d03a5b30d710', 677, 'Blaenau Gwent', 2);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('fc27677a-1e7d-4fc3-b436-100af2e55289', 678, 'Torfaen', 2);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('316f475a-8fae-44ed-b5ca-2ffcf474e0b4', 679, 'Monmouthshire', 2);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('91e1aee3-45dc-4db9-9246-0de21b5d5b9f', 680, 'Newport', 2);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('280a4dd9-aef7-453f-bdc1-0fa1c3f2a31c', 681, 'Cardiff', 2);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('c5aefa50-5472-4e70-8fa4-af3d4a8a19d6', 800, 'Bath and North East Somerset', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('a7cfaaa7-b6b3-4192-a1a8-e5341aa40c05', 801, 'Bristol, City of', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('ccfaa223-c0ac-4ca8-80ef-7f482ab49261', 802, 'North Somerset', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('46550835-1743-4ccb-9e6b-06dbd56175ce', 803, 'South Gloucestershire', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('9020e689-78c0-4626-91d0-5a82727d1d9d', 805, 'Hartlepool', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('905ee4be-0aef-41f2-881d-ffa7f86ec3fc', 806, 'Middlesbrough', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('b30ea679-f9ce-46cc-a4f3-20b7a3695eaf', 807, 'Redcar and Cleveland', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('93df1f48-c756-4f59-b91f-81f68126f1df', 808, 'Stockton-on-Tees', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('2bb2563d-3eb5-4ba9-a455-ac0ac278a603', 810, 'Kingston upon Hull, City of', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('72112d7c-e833-45fd-a828-46aa1cfe15ff', 811, 'East Riding of Yorkshire', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('8c362ee7-42fc-44ab-b36f-bca0c00615fd', 812, 'North East Lincolnshire', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('ab4966da-9ca5-4705-871c-34ea5fb5324e', 813, 'North Lincolnshire', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('91bb8a81-0921-486a-a01f-6dc92ada79dd', 815, 'North Yorkshire', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('faa45eb8-19f5-4b44-ae00-a0c6ff3a29d8', 816, 'York', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('539182d9-7615-4602-bd54-37dbb410d568', 820, 'Pre LGR (2009) Bedfordshire', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('94de79f8-3c87-4b85-b1cc-50cc0ee68b1b', 821, 'Luton', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('f99109cc-d214-4b17-b8cc-d97b821f9bac', 822, 'Bedford', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('b395ac6b-04e7-4fbc-9511-ea5d0745130e', 823, 'Central Bedfordshire', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('a4ed67e6-6c4f-4e69-92c9-0315753c3b3d', 825, 'Buckinghamshire', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('24122615-f857-47a9-a611-f407332d636a', 826, 'Milton Keynes', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('d999bd8a-ba7f-4e6a-bea4-5cc48ee0da02', 830, 'Derbyshire', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('51c77084-c59f-47bd-8807-96137e5a219e', 831, 'Derby', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('addacebe-2ee4-4b30-8e4a-849a971bd508', 835, 'Pre-LGR 2019 Dorset', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('2bb44495-4a56-40cf-8bb6-10820e11c562', 836, 'Pre-LGR 2019 Poole', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('33ab1c3a-4900-488d-aef6-c4fb1c061ad6', 837, 'Pre-LGR 2019 Bournemouth', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('cc16ad72-58cb-4d7b-8692-975659d65ed3', 838, 'Dorset', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('9a202148-2ae7-49ed-9c02-14b3d645fa93', 839, 'Bournemouth, Christchurch and Poole', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('22c1904a-b714-40c7-a584-1f1acb001d05', 840, 'County Durham', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('5e708bc3-f913-428e-b20e-42227fe039e8', 841, 'Darlington', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('4dc8a94c-3179-4068-b916-563e3e80a098', 845, 'East Sussex', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('6c5ebecd-5f10-4d30-88f8-ec91fbfd5842', 846, 'Brighton and Hove', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('742fde9b-2988-4308-af57-ddd8f7b602ad', 850, 'Hampshire', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('1bb40750-67a1-400f-a242-5784f3b444af', 851, 'Portsmouth', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('724a4ff9-0f0b-46c8-b0c6-e99bc16318ba', 852, 'Southampton', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('268357da-b1ee-46d1-ad09-c428d555340e', 855, 'Leicestershire', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('6c4fcb71-3d61-494b-b368-056a8cdb30c6', 856, 'Leicester', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('2ce5f13b-f481-4705-8f98-fc1b47af433f', 857, 'Rutland', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('b3ccd77b-e73b-467f-8420-84ac47cb6cce', 860, 'Staffordshire', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('c8f863e8-88a1-4105-895f-7229c914423e', 861, 'Stoke-on-Trent', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('80d219ba-7b1e-4d80-8576-448ee5b8b43e', 865, 'Wiltshire', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('97d491e1-c7c1-43ea-bf7a-c1935dbdcb4f', 866, 'Swindon', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('26025888-a6b5-4437-bfa0-7b3ccaf0d922', 867, 'Bracknell Forest', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('4ba00454-886d-442f-87da-37b2ce1e2c2d', 868, 'Windsor and Maidenhead', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('4f642de9-c2e0-4840-9422-ecac7ccb555e', 869, 'West Berkshire', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('5e5a2fbe-0846-4d17-b605-c7a892e1cdbd', 870, 'Reading', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('8926ddbb-f3b9-4e16-ad56-57e56066c044', 871, 'Slough', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('03e1aad6-003f-466f-8ced-97ed582a3f03', 872, 'Wokingham', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('2df214c6-a8ac-49d5-be61-9f2c1623456a', 873, 'Cambridgeshire', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('21f9d3d2-9b2f-4cbe-814c-d2af592bd360', 874, 'Peterborough', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('f53c1d0b-7961-49f6-8ae2-21a8a29ae9ec', 875, 'Pre LGR (2009) Cheshire', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('75a82298-6cb0-4ff6-898d-5b02c9c7f3e1', 876, 'Halton', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('12b7fa70-1ab6-4879-ae2b-0ee89c670956', 877, 'Warrington', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('43cb8f5a-5702-4838-aa97-da86d779fb9e', 878, 'Devon', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('3474daf4-10cb-49e3-8693-00838553f83e', 879, 'Plymouth', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('68e1cce3-4df3-4f45-ba65-bc2eeb69c983', 880, 'Torbay', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('e15b5a6e-36aa-4097-9b52-af7f766a24e3', 881, 'Essex', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('33dde4d2-7783-4696-9acd-2ce161ba11eb', 882, 'Southend-on-Sea', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('241afe6c-7ba4-4147-8b41-2ff414dff5d1', 883, 'Thurrock', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('57e2142b-89c6-4088-a938-19213a737b84', 884, 'Herefordshire, County of', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('491fc1e8-c03f-460f-ac33-6d2bf2255322', 885, 'Worcestershire', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('344245b1-21ee-4b99-a552-7ae4e161ae55', 886, 'Kent', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('149f5145-36ab-43c3-81c3-470384349d45', 887, 'Medway', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('fec58ab2-a99d-4a32-83eb-fe892bbbb017', 888, 'Lancashire', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('411b298f-00be-428d-a049-153d590fd2f5', 889, 'Blackburn with Darwen', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('718bc727-5c04-4f5b-b087-1d1df033123a', 890, 'Blackpool', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('ebdf5d9a-914b-456c-9427-86b1d0222232', 891, 'Nottinghamshire', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('509ebf84-8049-4b89-91ba-1fc64753f747', 892, 'Nottingham', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('e3ff6931-f8bb-4fd8-8934-33caf3b93ce9', 893, 'Shropshire', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('44fe2785-7d3a-47e5-a688-4be3e6861e09', 894, 'Telford and Wrekin', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('9690e66c-6e7d-4a67-b813-32a53c381fba', 895, 'Cheshire East', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('7629bdad-5d49-49d5-a8ed-e456dbb4a51b', 896, 'Cheshire West and Chester', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('6fbb76d1-fec3-4da9-8d6f-e14e1b142f3b', 901, 'Pre LGR (1996) Avon', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('82076b94-d3ac-446f-ba52-c482f36e4ef3', 902, 'Pre LGR (1997) Bedfordshire', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('1275c087-e58a-4f72-ac70-06a2e80b035d', 903, 'Pre LGR (1998) Berkshire', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('f3e772b7-731e-404a-87ac-205ba8207e3a', 904, 'Pre LGR (1997) Buckinghamshire', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('459f4a1e-8093-4132-b7b1-6864902598ac', 905, 'Pre LGR (1998) Cambridgeshire', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('f4401211-eb81-465c-b8e9-ec111804be62', 906, 'Pre LGR (1998) Cheshire', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('852b8dcf-1e0a-408f-90a7-d24aacf6826e', 907, 'Pre LGR (1996) Cleveland', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('414e255d-d076-4ce3-81aa-95aa43d9739c', 908, 'Cornwall', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('bc7dd6fe-dff4-4b33-8777-ec1ccde84046', 909, 'Pre-LGR 2023 Cumbria', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('5fbe47fa-5e7c-4d40-8f6e-d0c1aeabeb4b', 910, 'Pre LGR (1997) Derbyshire', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('a506959d-709e-4195-8c94-b58e3ca7409f', 911, 'Pre LGR (1998) Devon', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('0dca248b-fbcc-4271-a2a2-76b3d35cf360', 912, 'Pre LGR (1997) Dorset', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('5ba7e3aa-0cbb-41c6-8f4f-3f59e179ae6c', 913, 'Pre LGR (1997) Durham', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('01f8d9b8-4751-4c0f-b0f5-829d05462906', 914, 'Pre LGR (1997) East Sussex', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('1228a360-f887-4f04-b7ff-e830bc10dc13', 915, 'Pre LGR (1998) Essex', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('6af46ad9-b295-488b-a972-222c3f43f20a', 916, 'Gloucestershire', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('8a2017ab-22c0-4ff3-bc9e-375a4d9b54d2', 917, 'Pre LGR (1997) Hampshire', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('5bf7ea07-9e78-4101-be57-7042e478be58', 918, 'Pre LGR (1998) Hereford & Worcester', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('15df9e17-f102-4ba0-b737-5d846fd1af4b', 919, 'Hertfordshire', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('53b48b2f-f818-4e23-9446-ae8e4b27a5a7', 920, 'Pre LGR (1996) Humberside', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('b74f6936-7b96-4a66-be7e-88dcb91ff960', 921, 'Isle of Wight', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('94aa5d37-d88f-4a5c-9c24-d400ff2d49fe', 922, 'Pre LGR (1998) Kent', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('ce2d10f9-d471-457a-9a21-597ff526f638', 923, 'Pre LGR (1998) Lancashire', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('67783543-4746-4fcb-bea6-c32db9662d5b', 924, 'Pre LGR (1997) Leicestershire', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('4fd14254-ae48-4ab6-b979-e51bf2c0c88b', 925, 'Lincolnshire', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('c2476274-37f4-4e6e-a2ef-c0a8ccfcfff5', 926, 'Norfolk', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('a443aa7b-0f03-4a02-aaf3-2b01c41f84ab', 927, 'Pre LGR (1996) North Yorkshire', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('b638dbc6-5d8a-4084-a61a-f020c9400cca', 928, 'Pre-LGR 2021 Northamptonshire', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('315ac507-1d7b-4c18-90aa-60a506d51f1e', 929, 'Northumberland', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('efaf8b8d-661e-46ef-a2ea-c015411a2f73', 930, 'Pre LGR (1998) Nottinghamshire', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('bb153106-653b-4604-885d-07945231c079', 931, 'Oxfordshire', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('cc65d16e-00c4-4534-9cf9-5e571f1e5bbc', 932, 'Pre LGR (1998) Shropshire', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('48dceb93-31f1-43ae-a3e8-c5365add7b90', 933, 'Somerset', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('559289b2-218d-4364-a81b-b7f867d82f0b', 934, 'Pre LGR (1997) Staffordshire', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('e4e17e09-4567-4f33-a050-a7820741d6a1', 935, 'Suffolk', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('8cb62cb8-1614-4f25-b09a-3fa252f5d703', 936, 'Surrey', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('d0f2effe-4ef5-44c8-8915-689ac877e5d7', 937, 'Warwickshire', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('33b999e5-ac5d-41fd-bbf4-f498cd22dffa', 938, 'West Sussex', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('bb14f375-124b-40ba-8703-43122f1392e6', 939, 'Pre LGR (1997) Wiltshire', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('e86a348a-9640-4b1d-9497-cb05cb220428', 940, 'North Northamptonshire', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('6ead42c0-fd00-4113-aa3b-861678bf8fd1', 941, 'West Northamptonshire', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('f22e5bc9-6114-4bdd-b1eb-8d327bdab31d', 942, 'Cumberland', 1);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id) VALUES ('de92d8c9-7a54-4739-87b8-99c70e724a02', 943, 'Westmorland and Furness', 1);


--
-- Data for Name: local_authority_contact; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.local_authority_contact (local_authority_contact_id, local_authority_id, contact_email, contact_first_name, contact_last_name, contact_title, contact_phone, contact_role, is_current) VALUES ('b53a264a-92a7-4cee-ab20-bb76baad7d3f', '563065c7-e487-4a0b-b527-bc53d934f047', 'FAKE.local-authority-contact-01@example.invalid', 'FAKE Contact 01', 'FAKE Local Authority', 'FAKE Contact Title', 'FAKE-0000-01', 'FAKE Local Authority Contact 01', true);
INSERT INTO establishment.local_authority_contact (local_authority_contact_id, local_authority_id, contact_email, contact_first_name, contact_last_name, contact_title, contact_phone, contact_role, is_current) VALUES ('5f9906ef-0d12-4d6a-8d1f-8c86405d6860', '62ab8205-c94e-43eb-92ee-c66f767d50ad', 'FAKE.local-authority-contact-02@example.invalid', 'FAKE Contact 02', 'FAKE Local Authority', 'FAKE Contact Title', 'FAKE-0000-02', 'FAKE Local Authority Contact 02', true);
INSERT INTO establishment.local_authority_contact (local_authority_contact_id, local_authority_id, contact_email, contact_first_name, contact_last_name, contact_title, contact_phone, contact_role, is_current) VALUES ('9091b477-b88f-4d2a-865c-6141d2580b81', '4217059c-dbfb-4437-9a4b-2c8ad7f52d45', 'FAKE.local-authority-contact-03@example.invalid', 'FAKE Contact 03', 'FAKE Local Authority', 'FAKE Contact Title', 'FAKE-0000-03', 'FAKE Local Authority Contact 03', true);
INSERT INTO establishment.local_authority_contact (local_authority_contact_id, local_authority_id, contact_email, contact_first_name, contact_last_name, contact_title, contact_phone, contact_role, is_current) VALUES ('6c37315b-20f8-4e44-ac20-5ab82d841979', '25fe65f4-2f73-4ef7-a535-66a1cbf81f7a', 'FAKE.local-authority-contact-04@example.invalid', 'FAKE Contact 04', 'FAKE Local Authority', 'FAKE Contact Title', 'FAKE-0000-04', 'FAKE Local Authority Contact 04', true);
INSERT INTO establishment.local_authority_contact (local_authority_contact_id, local_authority_id, contact_email, contact_first_name, contact_last_name, contact_title, contact_phone, contact_role, is_current) VALUES ('0e789e4a-cce4-4e01-af3d-0428c1cfa7fa', '20c4f763-5d9b-42eb-9b77-22ecb4ac72f8', 'FAKE.local-authority-contact-05@example.invalid', 'FAKE Contact 05', 'FAKE Local Authority', 'FAKE Contact Title', 'FAKE-0000-05', 'FAKE Local Authority Contact 05', true);
INSERT INTO establishment.local_authority_contact (local_authority_contact_id, local_authority_id, contact_email, contact_first_name, contact_last_name, contact_title, contact_phone, contact_role, is_current) VALUES ('7d7a7fb6-054d-4987-bd5e-3db2d00ba3fb', '8110a266-97bf-4867-a143-acb4ec3df01f', 'FAKE.local-authority-contact-06@example.invalid', 'FAKE Contact 06', 'FAKE Local Authority', 'FAKE Contact Title', 'FAKE-0000-06', 'FAKE Local Authority Contact 06', true);
INSERT INTO establishment.local_authority_contact (local_authority_contact_id, local_authority_id, contact_email, contact_first_name, contact_last_name, contact_title, contact_phone, contact_role, is_current) VALUES ('d7b30793-ba8b-4d1f-8043-315052193391', '2559799e-92c6-4d25-93b3-9c9ca144f4aa', 'FAKE.local-authority-contact-07@example.invalid', 'FAKE Contact 07', 'FAKE Local Authority', 'FAKE Contact Title', 'FAKE-0000-07', 'FAKE Local Authority Contact 07', true);
INSERT INTO establishment.local_authority_contact (local_authority_contact_id, local_authority_id, contact_email, contact_first_name, contact_last_name, contact_title, contact_phone, contact_role, is_current) VALUES ('6d911b0c-6f05-4885-9b39-f8f61396b56c', '7d43f822-5912-4309-91a2-cbda3c308baa', 'FAKE.local-authority-contact-08@example.invalid', 'FAKE Contact 08', 'FAKE Local Authority', 'FAKE Contact Title', 'FAKE-0000-08', 'FAKE Local Authority Contact 08', true);
INSERT INTO establishment.local_authority_contact (local_authority_contact_id, local_authority_id, contact_email, contact_first_name, contact_last_name, contact_title, contact_phone, contact_role, is_current) VALUES ('7f1b2b23-fe43-474b-ad13-5a6062707bd7', '57736c5e-4680-4a80-a29a-5a986391bab1', 'FAKE.local-authority-contact-09@example.invalid', 'FAKE Contact 09', 'FAKE Local Authority', 'FAKE Contact Title', 'FAKE-0000-09', 'FAKE Local Authority Contact 09', true);
INSERT INTO establishment.local_authority_contact (local_authority_contact_id, local_authority_id, contact_email, contact_first_name, contact_last_name, contact_title, contact_phone, contact_role, is_current) VALUES ('7030c572-e292-4b9c-972a-2475d12729a8', '6cef5e59-6100-43a6-ba32-9117824fcc63', 'FAKE.local-authority-contact-10@example.invalid', 'FAKE Contact 10', 'FAKE Local Authority', 'FAKE Contact Title', 'FAKE-0000-10', 'FAKE Local Authority Contact 10', true);


--
-- Data for Name: nursery_provision; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.nursery_provision (nursery_provision_id, name) VALUES (1, 'Nursery classes');
INSERT INTO establishment.nursery_provision (nursery_provision_id, name) VALUES (2, 'No nursery classes');
INSERT INTO establishment.nursery_provision (nursery_provision_id, name) VALUES (3, 'Not applicable (nursery provision)');


--
-- Data for Name: reason_establishment_closed; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.reason_establishment_closed (reason_establishment_closed_id, name) VALUES (1, 'Academy Converter');
INSERT INTO establishment.reason_establishment_closed (reason_establishment_closed_id, name) VALUES (2, 'Result of Amalgamation/Merger');
INSERT INTO establishment.reason_establishment_closed (reason_establishment_closed_id, name) VALUES (3, 'Closure');
INSERT INTO establishment.reason_establishment_closed (reason_establishment_closed_id, name) VALUES (4, 'For Academy');
INSERT INTO establishment.reason_establishment_closed (reason_establishment_closed_id, name) VALUES (5, 'Fresh Start');
INSERT INTO establishment.reason_establishment_closed (reason_establishment_closed_id, name) VALUES (6, 'Close Nursery School');
INSERT INTO establishment.reason_establishment_closed (reason_establishment_closed_id, name) VALUES (7, 'Change Religious Character');
INSERT INTO establishment.reason_establishment_closed (reason_establishment_closed_id, name) VALUES (8, 'Does not meet criteria for registration');
INSERT INTO establishment.reason_establishment_closed (reason_establishment_closed_id, name) VALUES (9, 'De-registered');
INSERT INTO establishment.reason_establishment_closed (reason_establishment_closed_id, name) VALUES (10, 'Academy Free School');
INSERT INTO establishment.reason_establishment_closed (reason_establishment_closed_id, name) VALUES (11, 'Change in status');
INSERT INTO establishment.reason_establishment_closed (reason_establishment_closed_id, name) VALUES (12, 'Transferred to new sponsor');
INSERT INTO establishment.reason_establishment_closed (reason_establishment_closed_id, name) VALUES (13, 'Created in Error - application rejected');


--
-- Data for Name: reason_establishment_opened; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.reason_establishment_opened (reason_establishment_opened_id, name) VALUES (1, 'Academy Converter');
INSERT INTO establishment.reason_establishment_opened (reason_establishment_opened_id, name) VALUES (2, 'New Provision');
INSERT INTO establishment.reason_establishment_opened (reason_establishment_opened_id, name) VALUES (3, 'Result of Amalgamation');
INSERT INTO establishment.reason_establishment_opened (reason_establishment_opened_id, name) VALUES (4, 'Fresh Start');
INSERT INTO establishment.reason_establishment_opened (reason_establishment_opened_id, name) VALUES (5, 'Academy Free School');
INSERT INTO establishment.reason_establishment_opened (reason_establishment_opened_id, name) VALUES (6, 'Result of Closure');
INSERT INTO establishment.reason_establishment_opened (reason_establishment_opened_id, name) VALUES (7, 'Change Religious Character');
INSERT INTO establishment.reason_establishment_opened (reason_establishment_opened_id, name) VALUES (8, 'Change in status');
INSERT INTO establishment.reason_establishment_opened (reason_establishment_opened_id, name) VALUES (9, 'Former Independent');
INSERT INTO establishment.reason_establishment_opened (reason_establishment_opened_id, name) VALUES (10, 'Split school');
INSERT INTO establishment.reason_establishment_opened (reason_establishment_opened_id, name) VALUES (11, 'New Nursery School');
INSERT INTO establishment.reason_establishment_opened (reason_establishment_opened_id, name) VALUES (12, 'Meets accreditation standards');
INSERT INTO establishment.reason_establishment_opened (reason_establishment_opened_id, name) VALUES (13, 'Free Special School');


--
-- Data for Name: sixth_form_provision; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.sixth_form_provision (sixth_form_provision_id, name) VALUES (1, 'Sixth form');
INSERT INTO establishment.sixth_form_provision (sixth_form_provision_id, name) VALUES (2, 'No sixth form');
INSERT INTO establishment.sixth_form_provision (sixth_form_provision_id, name) VALUES (3, 'Not applicable (sixth-form provision)');


--
-- Data for Name: specialist_provision_type; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.specialist_provision_type (specialist_provision_type_id, name) VALUES (1, 'Resourced provision');
INSERT INTO establishment.specialist_provision_type (specialist_provision_type_id, name) VALUES (2, 'SEN unit');
INSERT INTO establishment.specialist_provision_type (specialist_provision_type_id, name) VALUES (3, 'Resourced provision and SEN unit');


--
-- PostgreSQL database dump complete
--

\unrestrict pvbtsBgN4RVTgHXhVGFV9b7fqovsEHg3LTOHHxFs1PjajlzA2M5ZJRImQeCnqUg

