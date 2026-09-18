--
-- PostgreSQL database dump
--

\restrict vA7pod6Uz7TcdnnWftpEFqVEX7V2P0lxghkiUVLdIgJbinGdUv5uXkacQfHEhbY

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
INSERT INTO establishment.establishment_type (establishment_type_id, name) VALUES (15, 'Other independent special school');
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

INSERT INTO establishment.government_office_region (government_office_region_id, code, name) VALUES ('6cc3324b-91cb-4ea6-a0db-2cd327ce7941', 'A', 'North East');
INSERT INTO establishment.government_office_region (government_office_region_id, code, name) VALUES ('489dce3e-58d7-44c5-b9ef-2f7d7cbdb592', 'B', 'North West');
INSERT INTO establishment.government_office_region (government_office_region_id, code, name) VALUES ('f5cdf1f1-5f75-4420-b597-862614e13549', 'D', 'Yorkshire and the Humber');
INSERT INTO establishment.government_office_region (government_office_region_id, code, name) VALUES ('9c5ec547-5f0d-4ed6-938c-ba51c67d197d', 'E', 'East Midlands');
INSERT INTO establishment.government_office_region (government_office_region_id, code, name) VALUES ('7ca695f4-dfcd-4f78-bdaf-17861eafbf97', 'F', 'West Midlands');
INSERT INTO establishment.government_office_region (government_office_region_id, code, name) VALUES ('32e46d74-0ebf-495b-8261-2c508cd2c2bb', 'G', 'East of England');
INSERT INTO establishment.government_office_region (government_office_region_id, code, name) VALUES ('1375841f-e6ba-4cda-9fac-753ff9df93a2', 'H', 'London');
INSERT INTO establishment.government_office_region (government_office_region_id, code, name) VALUES ('f85647db-e5d1-41a6-befb-bfbf6420f5c4', 'J', 'South East');
INSERT INTO establishment.government_office_region (government_office_region_id, code, name) VALUES ('21478f61-4270-49ad-8c24-d9058ea036ab', 'K', 'South West');
INSERT INTO establishment.government_office_region (government_office_region_id, code, name) VALUES ('c73ecd90-4dde-422f-a8da-e234af0a07dd', 'N', 'Not Applicable (Archived)');
INSERT INTO establishment.government_office_region (government_office_region_id, code, name) VALUES ('28c0b88a-9329-4c96-9ac8-cb44cf6926e1', 'W', 'Wales (pseudo)');
INSERT INTO establishment.government_office_region (government_office_region_id, code, name) VALUES ('c8b33e9c-23a0-4591-84dd-e764fac11d13', 'Z', 'Not Applicable');


--
-- Data for Name: gss_local_authority_code; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('68cd051a-e509-4b8c-bcbe-8233a1be851c', 'E06000001');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('528cfd33-7c8f-4a76-a8e5-6ed9e6c3d5f7', 'E06000002');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('7e7ef8af-df61-4e53-b3db-820cbe7cabd6', 'E06000003');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('38c8e16b-d29f-4a9f-900e-657610b09883', 'E06000004');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('08f3157c-e544-4587-9947-6077a96597d6', 'E06000005');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('c0285bd3-5089-4c06-ab38-17e45f8871f7', 'E06000006');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('a403595f-b88a-4cd9-8d7c-4f9a0e178d5c', 'E06000007');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('1a53dfa3-91dc-47ce-bd0e-0f5022448980', 'E06000008');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('29b80a60-d84b-4957-99ca-f890781c0ce4', 'E06000009');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('51e41009-7166-4b84-b7de-42dd4bead5ae', 'E06000010');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('3f866fc6-463b-4c56-9648-7e6e4be56fcc', 'E06000011');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('7be73934-b33d-425c-8d59-fb51f63200b7', 'E06000012');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('175540a1-d282-46e4-ad9c-28228a2800a4', 'E06000013');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('567128cb-98c1-400f-a79d-b18b47d22a34', 'E06000014');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('06860e92-5f3f-4616-b6ae-91e55b2aab40', 'E06000015');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('66cbe75b-e75b-463f-9cdb-1dba349047a5', 'E06000016');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('0fff8215-b86b-4185-84c0-609c59271132', 'E06000017');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('f9bc39e2-74b0-4c65-b318-0a43aa9dd8ac', 'E06000018');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('ab86a576-9545-403c-8cb9-d864987ffc5e', 'E06000019');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('6408e67c-c375-4dbc-a81c-2550b9eb44ed', 'E06000020');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('532ece4b-dc88-42d8-a888-7530ec3c2333', 'E06000021');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('c926a278-0615-4c7b-b241-97e28b614f51', 'E06000022');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('cf44f0bf-6f68-466a-b34d-416f64ae8f52', 'E06000023');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('df9162c4-6bdd-46d4-94bf-c96540ef1383', 'E06000024');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('572ae0da-ec77-4b74-a0ef-41e7eb738aae', 'E06000025');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('61857c7d-1d99-4683-babd-157d47bf9119', 'E06000026');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('b097fab7-0b76-4164-a3cb-ce7cb6d25b79', 'E06000027');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('f18a019b-f1a4-4d66-834e-004c96e18a7f', 'E06000028');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('66210ae1-0f6f-41a2-970b-edcc55062a53', 'E06000029');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('08aa6dce-271d-4cb5-b303-789e4b452d64', 'E06000030');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('d7067e31-045d-4446-a5be-51580f5178c8', 'E06000031');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('3d3dc398-8efc-4b88-ae06-c9f2de1b3780', 'E06000032');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('de673613-1c63-48c6-9f6e-f600da387cc5', 'E06000033');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('879110cb-70ab-4cf7-90f1-f91aaf712c70', 'E06000034');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('9eca6d99-ec5f-4c0c-b36c-7c750c71fdf4', 'E06000035');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('d1a6fb5e-771d-4b15-83fe-d2cf5f1b9223', 'E06000036');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('03dd66f9-15e7-459b-91ae-5c02e0565183', 'E06000037');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('0e61d269-ef45-406d-827e-956fadcc104e', 'E06000038');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('0be0b98c-46bb-4d70-abed-59316bbba15a', 'E06000039');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('5d129aea-efdc-4e72-9fbb-0cc2a2ddfb89', 'E06000040');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('c3e89d13-e407-4a23-888f-c6c1b213a055', 'E06000041');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('063739c0-909b-4843-a044-97767dc26a7f', 'E06000042');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('55033753-6221-49c8-882a-03d3e075341a', 'E06000043');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('eb044208-828b-48ac-8f79-dede35249dee', 'E06000044');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('b456122d-3820-4e3c-968f-67841b85130f', 'E06000045');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('97322b1b-3d4c-4664-aa9c-bf692e69d463', 'E06000046');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('1b720972-9d98-4e55-9e3c-6415185c037b', 'E06000047');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('a97128b3-19d1-48df-b8bc-779bd2a79f9b', 'E06000048');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('c869ed3f-d94c-411a-94e5-c4edd2ac88e3', 'E06000049');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('d977fbe6-dafa-47e6-8145-156c2ebf223f', 'E06000050');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('7d71fdc6-e14e-4872-8684-67e769b3bc6e', 'E06000051');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('e920e8b9-f434-481a-9803-7b1bce21c892', 'E06000052');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('b5ceb64d-6e87-427b-b486-45df353b0815', 'E06000053');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('0679d512-ce43-4e71-9ef5-38e5a03a831c', 'E06000054');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('eb50987e-eeed-466a-a60e-852672ad0bab', 'E06000055');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('91066742-bb90-4e6c-989e-507bba1503e1', 'E06000056');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('49dffb8c-9989-4f7d-8249-458eba530cc9', 'E06000057');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('4087aee5-62aa-4f62-9eec-b78f8e228a35', 'E06000058');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('10021186-8164-449e-970a-04e6ecfff4f8', 'E06000059');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('e462204c-6081-444e-8d73-6e82c3799385', 'E06000060');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('5741d0fd-c7bd-4f2c-88f7-e03c96035984', 'E06000061');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('829ac8ae-ce9c-4b8f-930f-c3b5d2bb9f27', 'E06000062');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('ac9a39d5-f66c-465d-b52a-d4f1b9ba39de', 'E06000063');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('81db2795-8569-4b8c-bf68-94b95f1fc39c', 'E06000064');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('6d157895-f375-4e82-b8d0-f2cc5291a3ca', 'E06000065');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('dbef8afc-e714-4b82-8300-11d62bf7de5a', 'E06000066');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('9083c009-2eb4-4dff-8110-2281730ee121', 'E08000001');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('7235f6f8-2ec1-47bb-8ef7-2b69fd7d2662', 'E08000002');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('688e9820-82e6-46eb-bd89-ee75f9de4306', 'E08000003');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('04762dab-fae6-4109-9f24-32a1293c443d', 'E08000004');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('ba3f93b3-cb54-4735-bfd1-a52397758591', 'E08000005');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('e064c801-9cd7-49a8-a35d-42bbbc7464f4', 'E08000006');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('a05ea1b6-270a-4d62-951e-4ec5ec76cb56', 'E08000007');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('4580fe1b-983c-4a71-8569-a566f4b0ed1f', 'E08000008');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('bb4d6810-8393-460e-8dd4-13e39aa0b450', 'E08000009');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('14cf0349-90ab-4760-a035-8ae9834cbb6d', 'E08000010');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('0e1fe2c1-47f9-4f9e-8a0c-138ea91326ec', 'E08000011');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('7693b683-84a9-4528-9d40-744b8d55ae2e', 'E08000012');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('e6962e95-69ea-4448-94bc-282e6570eb07', 'E08000013');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('6d2a06ac-feda-465d-8496-14db913eef54', 'E08000014');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('a5d131c9-6265-4a79-b302-fe2a83f381ff', 'E08000015');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('1dab4969-6c28-4da5-ad92-145d1a0e7ed3', 'E08000016');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('e62bfe1a-78b1-46e7-8948-b8cb080e6d02', 'E08000017');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('228b0d2d-4e00-4c64-9878-143595df81e2', 'E08000018');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('be14f3a3-f824-42f0-a1fa-c6afa7aca808', 'E08000019');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('7b94bdda-3346-4703-9b1d-3400e861c5a9', 'E08000020');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('a36e6f21-220f-4efe-ad36-228b855b7f49', 'E08000021');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('b29ab908-fcf8-44d2-9a5c-b44a136c86ac', 'E08000022');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('74975d2f-5f7e-4535-8075-de381ac6002c', 'E08000023');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('c93241bc-85f5-4a2c-8a98-8e44ce5a18dd', 'E08000024');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('7cf16c61-524f-461a-b3ec-8111e1e0a647', 'E08000025');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('fc8139a6-14db-478f-9cbb-498ff64891df', 'E08000026');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('0af5a16f-c8df-4a31-a25e-d4898c493e9d', 'E08000027');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('d56a1a7f-bc8d-449e-ba45-1da72f7dd187', 'E08000028');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('79b1d637-8e5d-41a6-b3ac-b1ebbc0bd853', 'E08000029');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('857ca089-46e4-4900-b430-4451fa09c5c8', 'E08000030');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('37391414-668d-45df-91d9-18f360724609', 'E08000031');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('019b51e3-3018-40e6-bf18-8f99d77e32ef', 'E08000032');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('4c37c302-b65e-47c7-aef4-7c33581414cd', 'E08000033');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('62af31c3-738e-460f-bf20-755b488cbcc1', 'E08000034');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('0173f863-2471-45c8-9814-6aab7a4defb1', 'E08000035');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('f120c713-f6ff-427c-bf47-e285fe87ca28', 'E08000036');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('35477483-5cf6-424e-a0c3-732b635da45a', 'E08000037');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('50f171b1-f0a4-4ce4-88c6-34f2131bedc9', 'E09000001');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('cb24cfe5-b867-4d77-b222-d34804b7c671', 'E09000002');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('6ce1ab21-b3c0-4766-9383-a932edfd93ad', 'E09000003');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('aa3c2214-9689-4feb-8a4f-a5ca11788fa1', 'E09000004');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('8db2e3a7-3bdf-4795-9ed5-bdf0ad16bd7f', 'E09000005');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('2763992b-c7bd-42d8-b183-6140a8fe8f63', 'E09000006');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('daffde1b-4db3-4c53-b9ea-fe960d076f70', 'E09000007');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('45b31c93-5821-4408-8329-19ccd1865519', 'E09000008');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('19d1bb17-d504-4bdb-a589-1e83d27585f9', 'E09000009');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('994885ed-ca3f-450c-8900-00619f91e446', 'E09000010');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('fb5498f2-55c6-4da3-96cb-3f53b19ebffc', 'E09000011');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('f781b1e2-29c5-42ee-848b-170736ee685a', 'E09000012');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('c10c219c-2c91-4246-8afe-5164380a47a6', 'E09000013');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('f4f4eb08-e916-40b3-b738-7f5b0fb553f5', 'E09000014');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('d3cc4664-bf47-45ac-ac03-b5663240d436', 'E09000015');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('d4cfaa08-02ab-4272-a876-2d6e084a76ba', 'E09000016');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('d72c6872-9137-4a82-b958-923a144088e0', 'E09000017');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('18f61ef6-82f6-4f5b-90ac-5f6474c27b6d', 'E09000018');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('b2a844ce-14a5-4d86-89b3-49341e942838', 'E09000019');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('cda03c92-9108-4ef2-be66-01e1b3ea291c', 'E09000020');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('38686609-05a3-40f5-bd99-8692f2b88a57', 'E09000021');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('b7c35927-ad2a-455f-81d7-1ad9b8bd359a', 'E09000022');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('e590d972-c9be-4db6-8d70-8ffbaff9120b', 'E09000023');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('a6a84ae3-4f80-4d16-b5dc-2dfc491ae01d', 'E09000024');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('eeebf4cb-3861-4db2-80dc-8874dc0cad43', 'E09000025');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('c9351085-9d4c-4db0-bee0-a49b20f2c761', 'E09000026');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('a523de0d-5838-431b-9f24-d83d642f335c', 'E09000027');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('0cb8727c-ff5b-4bfc-ae87-bcb6a0c9c2c2', 'E09000028');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('bfe0c029-6535-4e0e-b8cc-762977114f25', 'E09000029');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('0291a857-0648-4701-a1e1-0bb8440c39c8', 'E09000030');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('4d7ac87d-36f1-4590-8da1-c663b3bfa6bb', 'E09000031');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('42609d72-36c8-4909-9eb8-1af099e5d99f', 'E09000032');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('01605454-839f-43ef-baa7-a4b2e7f52418', 'E09000033');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('a37afc2b-cff2-48ea-96b9-27ed3223d149', 'E10000001');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('75d2f58a-5ee7-47e5-9227-f20634ee6ff5', 'E10000002');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('15111c87-c920-4b46-a862-50ad69575d76', 'E10000003');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('18586277-8243-40a5-8bc0-f37b69549960', 'E10000004');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('f2733ac5-2091-4e6d-82f9-c72a2e80f4cd', 'E10000006');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('a41ff2a9-2f75-489f-887b-2a1c350a280e', 'E10000007');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('786fe0d6-ce73-4276-ad22-d7ac08df0c9e', 'E10000008');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('b7fbe147-db42-4347-a0ac-077496f2eef8', 'E10000009');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('3e926758-2bc7-45f7-8378-75ed3e73fc80', 'E10000011');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('71eb8c1d-97eb-4a23-b7cd-2dcbd436335c', 'E10000012');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('c3b99c12-2468-48d5-9abe-99af8a9a122e', 'E10000013');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('8b277f2a-58b8-4eb2-9e27-a728073169e6', 'E10000014');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('a1b2c748-394d-4b49-aae2-4cd3e6a348ca', 'E10000015');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('78a449ce-4ab6-48a2-82b9-3fcf0e085f12', 'E10000016');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('7723e45d-687d-4c49-bdb9-9b630893945c', 'E10000017');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('c4c6607e-fe1d-467e-8704-3334865a18f0', 'E10000018');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('d761ad1f-b418-4b3b-957d-7e29ff8896ad', 'E10000019');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('fcdbd2d6-7414-4921-b31e-52ae4283280a', 'E10000020');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('ebee2484-c14f-49e3-a15e-14cc5e4be0cf', 'E10000021');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('0d86a378-45a5-4b26-b29e-1e372ef26817', 'E10000023');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('de099e11-79ec-491c-a5c8-cb5f37195753', 'E10000024');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('36522bf4-bddb-4814-9aef-cb6386d8af4d', 'E10000025');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('8f292e2a-79f5-4760-802a-0fada2b43aca', 'E10000027');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('35a8c76a-6677-407b-b658-9074de12ffdb', 'E10000028');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('11370f82-11df-4b4b-b5b3-33553339ec05', 'E10000029');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('4fdfe545-2371-4ad7-a186-b911fdf3eb61', 'E10000030');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('1c3a9958-1c8f-4909-bd23-e8037d35176d', 'E10000031');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('20a0e661-15a9-4f83-95fe-1e3ac16aea3d', 'E10000032');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('76e8fe3d-9ab6-4774-9eab-02716fd249c3', 'E10000034');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('2f42f49e-4440-4e9e-9719-c77a89be4d07', 'W06000001');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('e491edfb-8718-4b90-8041-e9d3e77bf468', 'W06000002');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('06e30d37-d72c-4846-bcca-21b9d2ea66de', 'W06000003');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('016d9fe2-2de1-451c-8b93-dfc8fb2792d7', 'W06000004');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('e682d495-bb58-41b4-880b-710909421949', 'W06000005');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('dcbbb71d-927c-4acf-b6c7-8275bb31deb7', 'W06000006');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('38f8fbd0-29a8-4188-87de-405cb731afd1', 'W06000007');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('67987b1d-d089-4cc9-9aa3-9ad35c092032', 'W06000008');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('6984a42e-5cd3-46d4-864c-e9a95b7a9be0', 'W06000009');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('2f68f9b2-a4f1-4dc6-85e7-b3029a8a21b9', 'W06000010');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('8b42468c-f049-4353-a782-1b950a7a5c9c', 'W06000011');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('578d9f2f-78f7-42c8-a845-026f2fa078e1', 'W06000012');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('80a4d5e0-b444-4815-9bf9-5f99343d7841', 'W06000013');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('e9ff10e7-5d41-4cc4-9e5e-421db6fbc56b', 'W06000014');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('d8b4821e-e3c1-44c7-99c4-f8d8534cb3f2', 'W06000015');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('620a2ca3-a83c-474c-8085-5bf563a8998c', 'W06000016');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('d3380ad6-afdc-48ae-8ade-2916dd00a2fe', 'W06000017');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('c64d10e0-2f8b-42da-b233-673690ecd354', 'W06000018');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('41affa57-85ce-44e8-bf7d-ef9ce12398b2', 'W06000019');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('a9a95d5d-7896-4c64-98e1-b5cb9b0d69b6', 'W06000020');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('7b391b73-ad99-4a78-9447-d2f40647acf9', 'W06000021');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('77eb0229-6196-4975-9dd2-f619dba0486e', 'W06000022');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('04386fc9-6387-4c9e-90b5-f495f1a34e1d', 'W06000023');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('b5a61f17-ce59-4e54-a69d-b806fb52d195', 'W06000024');
INSERT INTO establishment.gss_local_authority_code (id, code) VALUES ('62a75e3c-da57-4104-9e7d-b6d7c8bb2823', 'X999999');


--
-- Data for Name: local_authority_jurisdiction; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.local_authority_jurisdiction (local_authority_jurisdiction_id, name) VALUES (1, 'English');
INSERT INTO establishment.local_authority_jurisdiction (local_authority_jurisdiction_id, name) VALUES (2, 'Welsh');


--
-- Data for Name: local_authority; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('3429bd17-3db3-42ad-a0bf-7b6682f9ea98', 670, 'Swansea', 2, NULL);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('7265e4f9-7622-4944-8bd9-fb3825952c3f', 883, 'Thurrock', 1, NULL);
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('10279260-69e5-4534-9feb-30c48c6d9b06', 201, 'City of London', 1, '50f171b1-f0a4-4ce4-88c6-34f2131bedc9');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('0956c9af-2de2-4dea-94ed-b5c432eae45f', 202, 'Camden', 1, 'daffde1b-4db3-4c53-b9ea-fe960d076f70');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('41ee14e6-dabb-4874-af14-2c93e5adebfa', 203, 'Greenwich', 1, 'fb5498f2-55c6-4da3-96cb-3f53b19ebffc');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('a916541b-fd17-42f4-a8ac-186326f3817c', 204, 'Hackney', 1, 'f781b1e2-29c5-42ee-848b-170736ee685a');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('6617fc31-5146-429b-8b1a-2b8a7c37204c', 205, 'Hammersmith and Fulham', 1, 'c10c219c-2c91-4246-8afe-5164380a47a6');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('3574e75c-8870-449a-82e7-1b083e2efc42', 206, 'Islington', 1, 'b2a844ce-14a5-4d86-89b3-49341e942838');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('6e8b3ded-c1b4-4a2f-817e-b9bfd3aa3e86', 207, 'Kensington and Chelsea', 1, 'cda03c92-9108-4ef2-be66-01e1b3ea291c');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('b9f9a0d5-74cb-4bd4-b205-2b8c8fdf3697', 208, 'Lambeth', 1, 'b7c35927-ad2a-455f-81d7-1ad9b8bd359a');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('5167896b-40e6-420c-8510-45c4106ac301', 209, 'Lewisham', 1, 'e590d972-c9be-4db6-8d70-8ffbaff9120b');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('c0b0dbb1-9d64-4b93-9a52-6fe463541bc1', 210, 'Southwark', 1, '0cb8727c-ff5b-4bfc-ae87-bcb6a0c9c2c2');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('20011641-8b10-45f9-acb2-4766b159b17d', 211, 'Tower Hamlets', 1, '0291a857-0648-4701-a1e1-0bb8440c39c8');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('22b946b9-bc4f-4687-9177-31680e369c9c', 212, 'Wandsworth', 1, '42609d72-36c8-4909-9eb8-1af099e5d99f');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('4f47e935-0285-478e-af4d-ce3220c144d1', 213, 'Westminster', 1, '01605454-839f-43ef-baa7-a4b2e7f52418');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('dd41d40d-7a3b-469c-b49d-930cbe7d0dd5', 301, 'Barking and Dagenham', 1, 'cb24cfe5-b867-4d77-b222-d34804b7c671');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('29a27929-4bba-49b9-8fb7-fbf94257fff8', 302, 'Barnet', 1, '6ce1ab21-b3c0-4766-9383-a932edfd93ad');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('75379562-3c0b-4270-944d-22df468d3cf7', 303, 'Bexley', 1, 'aa3c2214-9689-4feb-8a4f-a5ca11788fa1');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('9ff7ac3e-71c5-4eb7-b74c-4a83a229261e', 304, 'Brent', 1, '8db2e3a7-3bdf-4795-9ed5-bdf0ad16bd7f');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('5fc312d8-9428-4ee3-a9ed-9b204c8be91c', 305, 'Bromley', 1, '2763992b-c7bd-42d8-b183-6140a8fe8f63');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('b852b15b-c92e-4f4c-a014-5a99cdf7025b', 306, 'Croydon', 1, '45b31c93-5821-4408-8329-19ccd1865519');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('fe174e6d-3642-4892-bd26-8a1dd3ad5d59', 307, 'Ealing', 1, '19d1bb17-d504-4bdb-a589-1e83d27585f9');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('987bd60d-dd0c-4707-818f-d4aeb184a7b8', 308, 'Enfield', 1, '994885ed-ca3f-450c-8900-00619f91e446');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('c83c49ad-6125-4936-ac35-e8f804f49ba8', 309, 'Haringey', 1, 'f4f4eb08-e916-40b3-b738-7f5b0fb553f5');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('d9936778-b559-4d95-aedc-cffea5d3a18f', 310, 'Harrow', 1, 'd3cc4664-bf47-45ac-ac03-b5663240d436');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('d818eaaa-a1ae-44cc-b02e-98fbeb4dc406', 311, 'Havering', 1, 'd4cfaa08-02ab-4272-a876-2d6e084a76ba');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('3eb4bca9-62d4-4b5d-96e7-69693099d354', 312, 'Hillingdon', 1, 'd72c6872-9137-4a82-b958-923a144088e0');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('e10c2651-5a62-4b95-bb0b-2f81c55c6467', 313, 'Hounslow', 1, '18f61ef6-82f6-4f5b-90ac-5f6474c27b6d');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('709d8fff-6108-4446-9ec0-d648b85c4683', 314, 'Kingston upon Thames', 1, '38686609-05a3-40f5-bd99-8692f2b88a57');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('c22f0cc4-052e-44b6-a13d-308e877a16e3', 315, 'Merton', 1, 'a6a84ae3-4f80-4d16-b5dc-2dfc491ae01d');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('0abdf041-18e4-487d-9eac-f30657f66ebd', 316, 'Newham', 1, 'eeebf4cb-3861-4db2-80dc-8874dc0cad43');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('4efdbb20-4c85-4e3c-abe7-6de1186e5990', 317, 'Redbridge', 1, 'c9351085-9d4c-4db0-bee0-a49b20f2c761');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('3e8db405-e3da-4b0d-9a31-1f88061ee3b4', 318, 'Richmond upon Thames', 1, 'a523de0d-5838-431b-9f24-d83d642f335c');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('34427472-2794-4f4b-9bf3-d17e2b945133', 319, 'Sutton', 1, 'bfe0c029-6535-4e0e-b8cc-762977114f25');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('4f674528-165a-40a0-b3fc-b8588fcc5241', 320, 'Waltham Forest', 1, '4d7ac87d-36f1-4590-8da1-c663b3bfa6bb');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('2331ef34-0efc-46ff-bd37-a5046d40a753', 330, 'Birmingham', 1, '7cf16c61-524f-461a-b3ec-8111e1e0a647');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('33a476dc-5eb8-4150-9a06-6364f8130bbe', 331, 'Coventry', 1, 'fc8139a6-14db-478f-9cbb-498ff64891df');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('1b0ebe93-3b10-4663-98b5-a096c63e8040', 332, 'Dudley', 1, '0af5a16f-c8df-4a31-a25e-d4898c493e9d');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('cb3f41c9-3a3c-4632-8b67-2ecf69b670fc', 333, 'Sandwell', 1, 'd56a1a7f-bc8d-449e-ba45-1da72f7dd187');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('24403d37-2f07-4bbb-bd2d-f7e1fadf7fbf', 334, 'Solihull', 1, '79b1d637-8e5d-41a6-b3ac-b1ebbc0bd853');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('db38471e-2843-4e5a-9712-1d8fc220f3de', 335, 'Walsall', 1, '857ca089-46e4-4900-b430-4451fa09c5c8');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('3cc794db-378c-4fd1-b201-dcd8078462e6', 336, 'Wolverhampton', 1, '37391414-668d-45df-91d9-18f360724609');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('00b4455a-6f3e-4b8e-8399-b7db5455d306', 340, 'Knowsley', 1, '0e1fe2c1-47f9-4f9e-8a0c-138ea91326ec');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('df763548-f436-42d8-ae03-ddcc7cf6d77c', 341, 'Liverpool', 1, '7693b683-84a9-4528-9d40-744b8d55ae2e');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('35b43617-d7aa-45b7-8031-07494aa5c136', 342, 'St. Helens', 1, 'e6962e95-69ea-4448-94bc-282e6570eb07');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('c74da403-1c0d-480d-bd31-a548a7305e80', 343, 'Sefton', 1, '6d2a06ac-feda-465d-8496-14db913eef54');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('1b99670e-0e47-46d4-b618-b7ee0ed45f14', 344, 'Wirral', 1, 'a5d131c9-6265-4a79-b302-fe2a83f381ff');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('7a6803d6-c5fa-47ff-97af-7e13757750b0', 350, 'Bolton', 1, '9083c009-2eb4-4dff-8110-2281730ee121');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('353acfff-cbbe-4a26-817a-a4e6e0875c5c', 351, 'Bury', 1, '7235f6f8-2ec1-47bb-8ef7-2b69fd7d2662');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('0a78f87e-d71b-44c3-b598-2cc2b8038e95', 352, 'Manchester', 1, '688e9820-82e6-46eb-bd89-ee75f9de4306');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('2625193c-09d9-45a7-bcb2-b1dcdf077b61', 353, 'Oldham', 1, '04762dab-fae6-4109-9f24-32a1293c443d');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('5601040a-cd9c-499f-b38a-f7a77479cd7f', 354, 'Rochdale', 1, 'ba3f93b3-cb54-4735-bfd1-a52397758591');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('e7fbed96-c797-4709-92c8-310ec0c3245c', 355, 'Salford', 1, 'e064c801-9cd7-49a8-a35d-42bbbc7464f4');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('e9345306-86a0-442b-bafa-4ebcfd1a877c', 356, 'Stockport', 1, 'a05ea1b6-270a-4d62-951e-4ec5ec76cb56');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('2e8478cf-6cbc-424a-ade1-050239c7d330', 357, 'Tameside', 1, '4580fe1b-983c-4a71-8569-a566f4b0ed1f');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('7734fb10-1f0f-49da-b13f-e3c538beb17a', 358, 'Trafford', 1, 'bb4d6810-8393-460e-8dd4-13e39aa0b450');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('2601da0a-6f35-4c15-984e-f4482d1df384', 359, 'Wigan', 1, '14cf0349-90ab-4760-a035-8ae9834cbb6d');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('bcbf9ead-5cd3-4616-b0ba-c805d60bb7e7', 370, 'Barnsley', 1, '1dab4969-6c28-4da5-ad92-145d1a0e7ed3');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('77b9cfe6-842e-41c8-9be4-410cac32719a', 371, 'Doncaster', 1, 'e62bfe1a-78b1-46e7-8948-b8cb080e6d02');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('fdb10144-ddb3-4a5a-9eae-21a3da07031b', 372, 'Rotherham', 1, '228b0d2d-4e00-4c64-9878-143595df81e2');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('0881090c-70bc-486a-a74c-6c3754f93c88', 373, 'Sheffield', 1, 'be14f3a3-f824-42f0-a1fa-c6afa7aca808');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('74887ed3-ff4f-45a9-b9bf-22e9aec0fa66', 380, 'Bradford', 1, '019b51e3-3018-40e6-bf18-8f99d77e32ef');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('31e56f49-2fb5-4b09-a80f-cceebcce7e07', 381, 'Calderdale', 1, '4c37c302-b65e-47c7-aef4-7c33581414cd');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('a7a2261a-963a-4396-a976-98a6a39c7936', 382, 'Kirklees', 1, '62af31c3-738e-460f-bf20-755b488cbcc1');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('e62b9c65-4a77-474c-a2a3-0cf0f70ca2e3', 383, 'Leeds', 1, '0173f863-2471-45c8-9814-6aab7a4defb1');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('7788aab1-b623-462a-9e65-32e7d9c353ca', 384, 'Wakefield', 1, 'f120c713-f6ff-427c-bf47-e285fe87ca28');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('7d097780-45d5-4445-a0e3-7b76e09e4bb3', 390, 'Gateshead', 1, '35477483-5cf6-424e-a0c3-732b635da45a');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('e81ff5ff-09b8-46ae-ad1d-fff4604cd987', 391, 'Newcastle upon Tyne', 1, 'a36e6f21-220f-4efe-ad36-228b855b7f49');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('cf117bdb-0226-42f0-9f40-e11aa3369b61', 392, 'North Tyneside', 1, 'b29ab908-fcf8-44d2-9a5c-b44a136c86ac');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('2cf281fc-921d-418b-9243-4f54a59ac052', 393, 'South Tyneside', 1, '74975d2f-5f7e-4535-8075-de381ac6002c');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('2cd82783-74ed-4b7c-82c5-450101d78ac4', 394, 'Sunderland', 1, 'c93241bc-85f5-4a2c-8a98-8e44ce5a18dd');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('d7a06acf-52cf-4239-92f4-f6ce9af1556a', 420, 'Isles Of Scilly', 1, 'b5ceb64d-6e87-427b-b486-45df353b0815');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('49873b81-b75f-4e3a-9b74-608a06b35d0c', 660, 'Isle of Anglesey', 2, '2f42f49e-4440-4e9e-9719-c77a89be4d07');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('8fb5ef34-d13b-4864-9d2b-4932b86cba4d', 661, 'Gwynedd', 2, 'e491edfb-8718-4b90-8041-e9d3e77bf468');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('4cf5905c-6515-4f7f-80f3-8e7f58edd478', 662, 'Conwy', 2, '06e30d37-d72c-4846-bcca-21b9d2ea66de');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('b24af43a-5cfc-448f-8e4e-43da7cd0601a', 663, 'Denbighshire', 2, '016d9fe2-2de1-451c-8b93-dfc8fb2792d7');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('ae106cbe-8e7f-4318-900f-0a235e304043', 664, 'Flintshire', 2, 'e682d495-bb58-41b4-880b-710909421949');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('58b9e813-3c32-4da2-b590-e95f821b94fd', 665, 'Wrexham', 2, 'dcbbb71d-927c-4acf-b6c7-8275bb31deb7');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('9b399694-f8d9-45da-98f3-bce51c027b0e', 666, 'Powys', 2, '04386fc9-6387-4c9e-90b5-f495f1a34e1d');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('19452369-a4c3-426b-a5fb-4e34a81a0253', 667, 'Ceredigion', 2, '67987b1d-d089-4cc9-9aa3-9ad35c092032');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('5483bf0c-f14a-42e7-b2f5-f349f831570c', 668, 'Pembrokeshire', 2, '6984a42e-5cd3-46d4-864c-e9a95b7a9be0');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('2dfe9d4f-5760-40de-9140-fc00ad0b92fd', 669, 'Carmarthenshire', 2, '2f68f9b2-a4f1-4dc6-85e7-b3029a8a21b9');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('978e6e3d-47d0-471b-b830-f8a21b2bad1d', 671, 'Neath Port Talbot', 2, '578d9f2f-78f7-42c8-a845-026f2fa078e1');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('d5e442e1-da7e-423a-8f83-498e0114d5ab', 672, 'Bridgend', 2, '80a4d5e0-b444-4815-9bf9-5f99343d7841');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('019c45e1-caca-4e7b-97e4-6bbd54b155f3', 673, 'Vale of Glamorgan', 2, 'e9ff10e7-5d41-4cc4-9e5e-421db6fbc56b');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('07bfe421-8047-4f34-8421-267734e72c82', 674, 'Rhondda Cynon Taf', 2, '620a2ca3-a83c-474c-8085-5bf563a8998c');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('2884de00-e0be-4adc-9c25-0738a4ccf110', 675, 'Merthyr Tydfil', 2, 'b5a61f17-ce59-4e54-a69d-b806fb52d195');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('2ca74ae1-648a-4a8f-a52e-7213f316f451', 676, 'Caerphilly', 2, 'c64d10e0-2f8b-42da-b233-673690ecd354');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('af39818c-0553-4686-9843-dadbf2f10a9e', 677, 'Blaenau Gwent', 2, '41affa57-85ce-44e8-bf7d-ef9ce12398b2');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('1e826e80-82e8-4676-a5a7-b4c5edfbc560', 678, 'Torfaen', 2, 'a9a95d5d-7896-4c64-98e1-b5cb9b0d69b6');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('b7d08b02-fd4e-4206-85ee-7cdfeaaa7c08', 679, 'Monmouthshire', 2, '7b391b73-ad99-4a78-9447-d2f40647acf9');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('2ccda29b-5f3b-4adf-9a9b-6f24071bfaa2', 680, 'Newport', 2, '77eb0229-6196-4975-9dd2-f619dba0486e');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('0fa3ad59-cc32-4c31-a123-f2bf56e45c5a', 681, 'Cardiff', 2, 'd8b4821e-e3c1-44c7-99c4-f8d8534cb3f2');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('2071cd19-b79e-4c80-aaac-47be5cc80089', 800, 'Bath and North East Somerset', 1, 'c926a278-0615-4c7b-b241-97e28b614f51');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('50d53eb6-b12f-4962-8eff-50c36d424d9d', 801, 'Bristol, City of', 1, 'cf44f0bf-6f68-466a-b34d-416f64ae8f52');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('e44c7526-3b42-47ee-b3ca-1ccd5c37744a', 802, 'North Somerset', 1, 'df9162c4-6bdd-46d4-94bf-c96540ef1383');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('ac649890-34e4-4204-8241-b6ea6b8ee8ae', 803, 'South Gloucestershire', 1, '572ae0da-ec77-4b74-a0ef-41e7eb738aae');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('34527815-5555-490b-8d7a-63c766c57dd5', 805, 'Hartlepool', 1, '68cd051a-e509-4b8c-bcbe-8233a1be851c');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('093a0c1c-b1d3-41f4-b33c-b8d9b609acc1', 806, 'Middlesbrough', 1, '528cfd33-7c8f-4a76-a8e5-6ed9e6c3d5f7');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('8d9e4a37-f50c-41c9-81c3-895306cf4782', 807, 'Redcar and Cleveland', 1, '7e7ef8af-df61-4e53-b3db-820cbe7cabd6');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('fc015308-d288-4fcb-83de-4122b917b0f9', 808, 'Stockton-on-Tees', 1, '38c8e16b-d29f-4a9f-900e-657610b09883');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('74d83726-41f7-4e5a-8a57-0e304e4736e7', 810, 'Kingston upon Hull, City of', 1, '51e41009-7166-4b84-b7de-42dd4bead5ae');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('a5aeb112-ca6f-4b1a-b614-df4ce06eed2a', 811, 'East Riding of Yorkshire', 1, '3f866fc6-463b-4c56-9648-7e6e4be56fcc');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('fad94daf-6f11-4cd2-9256-7270f0787391', 812, 'North East Lincolnshire', 1, '7be73934-b33d-425c-8d59-fb51f63200b7');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('ce696e6c-24a4-4a56-95da-947bac9cc4d4', 813, 'North Lincolnshire', 1, '175540a1-d282-46e4-ad9c-28228a2800a4');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('4cb5116b-d132-47bb-a99f-98ceef5c8dbe', 815, 'North Yorkshire', 1, '6d157895-f375-4e82-b8d0-f2cc5291a3ca');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('a1c5d24c-5ecc-4889-92ab-9163a91e3e79', 816, 'York', 1, '567128cb-98c1-400f-a79d-b18b47d22a34');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('0f449571-79f9-454e-b19a-ae34b5c31cb3', 820, 'Pre LGR (2009) Bedfordshire', 1, 'a37afc2b-cff2-48ea-96b9-27ed3223d149');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('3dfc7437-5d3d-4e69-ae0b-c97376d6cc38', 821, 'Luton', 1, '3d3dc398-8efc-4b88-ae06-c9f2de1b3780');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('942f0927-84a7-43b6-8be9-68f88917b043', 822, 'Bedford', 1, 'eb50987e-eeed-466a-a60e-852672ad0bab');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('0a7cb25e-e9f9-40c7-97f5-5eee9bb436ee', 823, 'Central Bedfordshire', 1, '91066742-bb90-4e6c-989e-507bba1503e1');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('3346d12b-0c32-4bf2-b3eb-2e2e2d24dbc7', 825, 'Buckinghamshire', 1, 'e462204c-6081-444e-8d73-6e82c3799385');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('1ab5d183-d9d1-4d00-9f6c-eb75c323d92c', 826, 'Milton Keynes', 1, '063739c0-909b-4843-a044-97767dc26a7f');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('05cc5f5e-45cd-437e-805e-0ec749453739', 830, 'Derbyshire', 1, 'a41ff2a9-2f75-489f-887b-2a1c350a280e');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('24f8bcc1-22d4-4ac1-9887-c5392ca4a5b9', 831, 'Derby', 1, '06860e92-5f3f-4616-b6ae-91e55b2aab40');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('84f7c0ea-e498-4f14-bfa9-896a12e91a47', 835, 'Pre-LGR 2019 Dorset', 1, 'b7fbe147-db42-4347-a0ac-077496f2eef8');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('0ffd5853-b247-4645-bb43-4c21cd3c097f', 836, 'Pre-LGR 2019 Poole', 1, '66210ae1-0f6f-41a2-970b-edcc55062a53');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('a717a384-7ad1-4905-8d05-dea6f9bc274a', 837, 'Pre-LGR 2019 Bournemouth', 1, 'f18a019b-f1a4-4d66-834e-004c96e18a7f');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('5aac67d2-6e20-477c-a3f6-0ba844fa4bac', 838, 'Dorset', 1, '10021186-8164-449e-970a-04e6ecfff4f8');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('516a5708-bc4f-4f0d-9a8d-8cb036494616', 839, 'Bournemouth, Christchurch and Poole', 1, '4087aee5-62aa-4f62-9eec-b78f8e228a35');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('04f71e88-521e-4679-ba88-83125125950c', 840, 'County Durham', 1, '1b720972-9d98-4e55-9e3c-6415185c037b');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('221e3d83-edc6-4a8d-949c-f77a6785b431', 841, 'Darlington', 1, '08f3157c-e544-4587-9947-6077a96597d6');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('23dec583-f738-4c69-94f8-8419868cefad', 845, 'East Sussex', 1, '3e926758-2bc7-45f7-8378-75ed3e73fc80');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('8bb04782-9600-4d83-a0c0-e9d2d3466c34', 846, 'Brighton and Hove', 1, '55033753-6221-49c8-882a-03d3e075341a');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('5885bd90-8384-462f-9edb-a90f44519d81', 850, 'Hampshire', 1, '8b277f2a-58b8-4eb2-9e27-a728073169e6');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('cf2319f9-aced-4926-8d4b-e10cac4024a9', 851, 'Portsmouth', 1, 'eb044208-828b-48ac-8f79-dede35249dee');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('dd45f000-7108-4d65-aa54-75fd7eaad6bb', 852, 'Southampton', 1, 'b456122d-3820-4e3c-968f-67841b85130f');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('51cb7b94-0266-48b5-8d90-f13aa42b983d', 855, 'Leicestershire', 1, 'c4c6607e-fe1d-467e-8704-3334865a18f0');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('34a353a0-aab3-4aee-978a-937a1bf24f34', 856, 'Leicester', 1, '66cbe75b-e75b-463f-9cdb-1dba349047a5');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('8a475312-0978-46ba-a4af-ffef53132608', 857, 'Rutland', 1, '0fff8215-b86b-4185-84c0-609c59271132');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('55083c61-a058-42c6-a0f9-680a97700a80', 860, 'Staffordshire', 1, '35a8c76a-6677-407b-b658-9074de12ffdb');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('3332ea83-bcbe-48d1-970d-a3650d9bcf10', 861, 'Stoke-on-Trent', 1, '532ece4b-dc88-42d8-a888-7530ec3c2333');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('f029fe2f-656d-409c-aca4-fdd50231fa75', 865, 'Wiltshire', 1, '0679d512-ce43-4e71-9ef5-38e5a03a831c');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('4eb4d2f2-73bc-4f31-a476-1a265094b7aa', 866, 'Swindon', 1, '08aa6dce-271d-4cb5-b303-789e4b452d64');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('f4d6c9d4-fbff-4538-b0a1-53d6d8c36a0b', 867, 'Bracknell Forest', 1, 'd1a6fb5e-771d-4b15-83fe-d2cf5f1b9223');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('0659cec9-f4f1-4281-aa38-dac5b79a93e7', 868, 'Windsor and Maidenhead', 1, '5d129aea-efdc-4e72-9fbb-0cc2a2ddfb89');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('19c03d55-f6bd-4912-85db-129ff938d6fd', 869, 'West Berkshire', 1, '03dd66f9-15e7-459b-91ae-5c02e0565183');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('154a9b7a-7ef2-4988-9c4d-49e10a09507d', 870, 'Reading', 1, '0e61d269-ef45-406d-827e-956fadcc104e');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('e7980e70-c33e-4539-8573-106a6245da72', 871, 'Slough', 1, '0be0b98c-46bb-4d70-abed-59316bbba15a');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('de723409-6555-4aed-a1f9-82b6e9cb1cc1', 872, 'Wokingham', 1, 'c3e89d13-e407-4a23-888f-c6c1b213a055');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('3a839d72-f591-4c51-9b4b-91637c541035', 873, 'Cambridgeshire', 1, '15111c87-c920-4b46-a862-50ad69575d76');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('42e364c7-0769-4180-85af-94979c4a5604', 874, 'Peterborough', 1, 'd7067e31-045d-4446-a5be-51580f5178c8');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('75380e70-1b77-4afb-a53e-a69c2f21f86e', 875, 'Pre LGR (2009) Cheshire', 1, '18586277-8243-40a5-8bc0-f37b69549960');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('b8bab4f4-b58c-4b0f-9a07-df5d16f9380b', 876, 'Halton', 1, 'c0285bd3-5089-4c06-ab38-17e45f8871f7');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('145f84fa-36ae-4c6c-84f0-3f6b551ac5b2', 877, 'Warrington', 1, 'a403595f-b88a-4cd9-8d7c-4f9a0e178d5c');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('275bafd9-e869-4606-ad4a-6c578baae51f', 878, 'Devon', 1, '786fe0d6-ce73-4276-ad22-d7ac08df0c9e');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('5725447b-2398-4c41-8ca0-4fa6ebb9e691', 879, 'Plymouth', 1, '61857c7d-1d99-4683-babd-157d47bf9119');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('ba283a65-25f7-4eac-a3ec-fa46b93d1245', 880, 'Torbay', 1, 'b097fab7-0b76-4164-a3cb-ce7cb6d25b79');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('fc8cf832-fb45-45ba-bc98-09fb41b3a224', 881, 'Essex', 1, '71eb8c1d-97eb-4a23-b7cd-2dcbd436335c');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('dc9f9e86-8d80-46b7-87bc-e998cafca819', 882, 'Southend-on-Sea', 1, 'de673613-1c63-48c6-9f6e-f600da387cc5');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('a8333a46-7a89-42b6-ab95-43a73e09e704', 884, 'Herefordshire, County of', 1, 'ab86a576-9545-403c-8cb9-d864987ffc5e');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('3f8cc89e-9279-48fd-b440-48dc00f06fca', 885, 'Worcestershire', 1, '76e8fe3d-9ab6-4774-9eab-02716fd249c3');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('893121c9-05e6-4e35-bfef-ea76e40c012e', 886, 'Kent', 1, '78a449ce-4ab6-48a2-82b9-3fcf0e085f12');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('f0810578-383d-4303-b694-41e13fb73823', 887, 'Medway', 1, '9eca6d99-ec5f-4c0c-b36c-7c750c71fdf4');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('a4572037-9765-42e9-890c-0a4c47a49abd', 888, 'Lancashire', 1, '7723e45d-687d-4c49-bdb9-9b630893945c');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('88a167eb-994e-49ae-b1ee-4db968a5bf4b', 889, 'Blackburn with Darwen', 1, '1a53dfa3-91dc-47ce-bd0e-0f5022448980');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('b8be820c-b9c1-4b6e-80e4-53384b370924', 890, 'Blackpool', 1, '29b80a60-d84b-4957-99ca-f890781c0ce4');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('7004982b-a526-4013-82b5-68c877c0de28', 891, 'Nottinghamshire', 1, 'de099e11-79ec-491c-a5c8-cb5f37195753');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('c97c1960-148d-4fa3-8f4a-81fb6da42447', 892, 'Nottingham', 1, 'f9bc39e2-74b0-4c65-b318-0a43aa9dd8ac');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('3bb666d7-f8a2-4c07-b5de-06eead480743', 893, 'Shropshire', 1, '7d71fdc6-e14e-4872-8684-67e769b3bc6e');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('e9fbec24-bc95-49dd-b2a5-76e562c97185', 894, 'Telford and Wrekin', 1, '6408e67c-c375-4dbc-a81c-2550b9eb44ed');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('b0785849-4633-422e-b170-6b33fd8c4555', 895, 'Cheshire East', 1, 'c869ed3f-d94c-411a-94e5-c4edd2ac88e3');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('62f727b9-cb7a-49b4-9a78-3bda13bdc5ca', 896, 'Cheshire West and Chester', 1, 'd977fbe6-dafa-47e6-8145-156c2ebf223f');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('d7f6360e-a0a2-4948-9abe-b8dfa2191c83', 901, 'Pre LGR (1996) Avon', 1, '62a75e3c-da57-4104-9e7d-b6d7c8bb2823');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('3ae26c72-c959-4407-8d09-ab05653ff56b', 902, 'Pre LGR (1997) Bedfordshire', 1, '62a75e3c-da57-4104-9e7d-b6d7c8bb2823');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('81bf98ca-5884-443d-bf88-b319df5c53b7', 903, 'Pre LGR (1998) Berkshire', 1, '62a75e3c-da57-4104-9e7d-b6d7c8bb2823');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('8cc4e741-ebed-449f-a828-4c1e2dafde43', 904, 'Pre LGR (1997) Buckinghamshire', 1, '62a75e3c-da57-4104-9e7d-b6d7c8bb2823');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('9ea9a305-39f5-4c57-9ef2-3a3673c4c132', 905, 'Pre LGR (1998) Cambridgeshire', 1, '62a75e3c-da57-4104-9e7d-b6d7c8bb2823');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('05967224-7461-414d-b378-0ba6f085b3e4', 906, 'Pre LGR (1998) Cheshire', 1, '62a75e3c-da57-4104-9e7d-b6d7c8bb2823');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('c03b5eac-473d-4abc-8cea-1aecc5717477', 907, 'Pre LGR (1996) Cleveland', 1, '62a75e3c-da57-4104-9e7d-b6d7c8bb2823');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('6c224a0d-ed93-4dc1-bb76-b39f7890044e', 908, 'Cornwall', 1, 'e920e8b9-f434-481a-9803-7b1bce21c892');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('36b0d8c9-ea35-4cc1-9d29-fef2975d98f9', 909, 'Pre-LGR 2023 Cumbria', 1, 'f2733ac5-2091-4e6d-82f9-c72a2e80f4cd');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('35cb204a-5a7d-40d8-b5d2-98b3b872b2ce', 910, 'Pre LGR (1997) Derbyshire', 1, '62a75e3c-da57-4104-9e7d-b6d7c8bb2823');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('1d92096e-0bb4-44dd-9298-35405a6092ff', 911, 'Pre LGR (1998) Devon', 1, '62a75e3c-da57-4104-9e7d-b6d7c8bb2823');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('39bbbc7d-18de-4c56-9072-3e2f053e745a', 912, 'Pre LGR (1997) Dorset', 1, '62a75e3c-da57-4104-9e7d-b6d7c8bb2823');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('c09f8fc9-9f2d-4f77-bea5-80528c3533ae', 913, 'Pre LGR (1997) Durham', 1, '62a75e3c-da57-4104-9e7d-b6d7c8bb2823');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('8ba06800-fec1-41da-b0a9-822f05fb9019', 914, 'Pre LGR (1997) East Sussex', 1, '62a75e3c-da57-4104-9e7d-b6d7c8bb2823');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('1e59b614-94db-427c-bfd3-99c0b393ad14', 915, 'Pre LGR (1998) Essex', 1, '62a75e3c-da57-4104-9e7d-b6d7c8bb2823');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('3b110d34-2776-4827-969e-2af0d39a4aa2', 916, 'Gloucestershire', 1, 'c3b99c12-2468-48d5-9abe-99af8a9a122e');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('200c738d-2f8f-4349-b600-f568a52f7389', 917, 'Pre LGR (1997) Hampshire', 1, '62a75e3c-da57-4104-9e7d-b6d7c8bb2823');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('4576e83b-4f05-4e08-bce7-2bcc4ed79c9c', 918, 'Pre LGR (1998) Hereford & Worcester', 1, '62a75e3c-da57-4104-9e7d-b6d7c8bb2823');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('17d78c35-15f4-4065-a8c1-7e06b39285ec', 919, 'Hertfordshire', 1, 'a1b2c748-394d-4b49-aae2-4cd3e6a348ca');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('f8eedfd2-0ee9-49ba-a21a-d3b7689ca877', 920, 'Pre LGR (1996) Humberside', 1, '62a75e3c-da57-4104-9e7d-b6d7c8bb2823');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('3b27e455-7000-4c6a-b41f-5fbe41bef115', 921, 'Isle of Wight', 1, '97322b1b-3d4c-4664-aa9c-bf692e69d463');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('8be0b302-bc81-41b6-822a-131b844dac65', 922, 'Pre LGR (1998) Kent', 1, '62a75e3c-da57-4104-9e7d-b6d7c8bb2823');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('f9819105-1161-47ad-9bb9-25d960a9370a', 923, 'Pre LGR (1998) Lancashire', 1, '62a75e3c-da57-4104-9e7d-b6d7c8bb2823');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('cf173149-3ef1-4f3d-888f-c7d6fe4024a7', 924, 'Pre LGR (1997) Leicestershire', 1, '62a75e3c-da57-4104-9e7d-b6d7c8bb2823');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('00720f6a-c51f-4c33-8146-3c3bd96dc279', 925, 'Lincolnshire', 1, 'd761ad1f-b418-4b3b-957d-7e29ff8896ad');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('bb96fa49-32fb-408b-84cd-5d067bce81d0', 926, 'Norfolk', 1, 'fcdbd2d6-7414-4921-b31e-52ae4283280a');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('b2cdb195-afdc-4aef-a886-065c30e8d726', 927, 'Pre LGR (1996) North Yorkshire', 1, '62a75e3c-da57-4104-9e7d-b6d7c8bb2823');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('4f5cf1f1-e617-4ad7-b077-41042c25dd30', 928, 'Pre-LGR 2021 Northamptonshire', 1, 'ebee2484-c14f-49e3-a15e-14cc5e4be0cf');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('7022a4a3-5042-4d4f-af8e-fe3f8e0987b3', 929, 'Northumberland', 1, '49dffb8c-9989-4f7d-8249-458eba530cc9');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('e3406846-6987-4d8e-b2cf-f318721c1b11', 930, 'Pre LGR (1998) Nottinghamshire', 1, '62a75e3c-da57-4104-9e7d-b6d7c8bb2823');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('cdf59613-2d50-4afa-9ad0-69ab9555cc63', 931, 'Oxfordshire', 1, '36522bf4-bddb-4814-9aef-cb6386d8af4d');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('f8337f43-8a21-4010-90ff-46ea8a95f486', 932, 'Pre LGR (1998) Shropshire', 1, '62a75e3c-da57-4104-9e7d-b6d7c8bb2823');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('7b8c9e1a-8fc4-4651-b901-7846b63b0672', 933, 'Somerset', 1, 'dbef8afc-e714-4b82-8300-11d62bf7de5a');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('07c97c88-db4f-4861-8d5f-42c14416c7b1', 934, 'Pre LGR (1997) Staffordshire', 1, '62a75e3c-da57-4104-9e7d-b6d7c8bb2823');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('c1782af8-ed41-4ee1-bd3a-a5449b43acde', 935, 'Suffolk', 1, '11370f82-11df-4b4b-b5b3-33553339ec05');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('f76fed20-3a9b-4a0d-b15f-b3cde9c65b0a', 936, 'Surrey', 1, '4fdfe545-2371-4ad7-a186-b911fdf3eb61');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('26478edc-2fa3-4d8b-b9f7-aebc52a7dd2a', 937, 'Warwickshire', 1, '1c3a9958-1c8f-4909-bd23-e8037d35176d');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('8e5cc3ab-5773-49b5-9242-44413e8c2bf4', 938, 'West Sussex', 1, '20a0e661-15a9-4f83-95fe-1e3ac16aea3d');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('fe1af861-cf8a-4ec2-8138-8044c254786d', 939, 'Pre LGR (1997) Wiltshire', 1, '62a75e3c-da57-4104-9e7d-b6d7c8bb2823');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('e88b8486-ec97-4b98-a450-f0166bfe954f', 940, 'North Northamptonshire', 1, '5741d0fd-c7bd-4f2c-88f7-e03c96035984');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('8cb6de69-7978-4365-be32-d4f17554110a', 941, 'West Northamptonshire', 1, '829ac8ae-ce9c-4b8f-930f-c3b5d2bb9f27');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('e2ce8ae7-4ce9-4963-88cc-4456fb70de9d', 942, 'Cumberland', 1, 'ac9a39d5-f66c-465d-b52a-d4f1b9ba39de');
INSERT INTO establishment.local_authority (local_authority_id, code, name, local_authority_jurisdiction_id, gss_local_authority_code_id) VALUES ('c3481033-0753-4614-b00b-677ccc85d1ee', 943, 'Westmorland and Furness', 1, '81db2795-8569-4b8c-bf68-94b95f1fc39c');


--
-- Data for Name: local_authority_contact; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.local_authority_contact (local_authority_contact_id, local_authority_id, contact_email, contact_first_name, contact_last_name, contact_title, contact_phone, contact_role, is_current) VALUES ('e07a2b4d-c8a1-4c08-86f0-b0418b1f588b', '10279260-69e5-4534-9feb-30c48c6d9b06', 'FAKE.local-authority-contact-01@example.invalid', 'FAKE Contact 01', 'FAKE Local Authority', 'FAKE Contact Title', 'FAKE-0000-01', 'FAKE Local Authority Contact 01', true);
INSERT INTO establishment.local_authority_contact (local_authority_contact_id, local_authority_id, contact_email, contact_first_name, contact_last_name, contact_title, contact_phone, contact_role, is_current) VALUES ('843a4a22-9e41-4094-bb03-2a8cdcf77c2c', '0956c9af-2de2-4dea-94ed-b5c432eae45f', 'FAKE.local-authority-contact-02@example.invalid', 'FAKE Contact 02', 'FAKE Local Authority', 'FAKE Contact Title', 'FAKE-0000-02', 'FAKE Local Authority Contact 02', true);
INSERT INTO establishment.local_authority_contact (local_authority_contact_id, local_authority_id, contact_email, contact_first_name, contact_last_name, contact_title, contact_phone, contact_role, is_current) VALUES ('b20e62ac-9b9c-4231-bd0e-b142bac781b4', '41ee14e6-dabb-4874-af14-2c93e5adebfa', 'FAKE.local-authority-contact-03@example.invalid', 'FAKE Contact 03', 'FAKE Local Authority', 'FAKE Contact Title', 'FAKE-0000-03', 'FAKE Local Authority Contact 03', true);
INSERT INTO establishment.local_authority_contact (local_authority_contact_id, local_authority_id, contact_email, contact_first_name, contact_last_name, contact_title, contact_phone, contact_role, is_current) VALUES ('20a84515-db97-4447-8066-68ee6b5f413a', 'a916541b-fd17-42f4-a8ac-186326f3817c', 'FAKE.local-authority-contact-04@example.invalid', 'FAKE Contact 04', 'FAKE Local Authority', 'FAKE Contact Title', 'FAKE-0000-04', 'FAKE Local Authority Contact 04', true);
INSERT INTO establishment.local_authority_contact (local_authority_contact_id, local_authority_id, contact_email, contact_first_name, contact_last_name, contact_title, contact_phone, contact_role, is_current) VALUES ('d7ec878a-0152-48c4-aac3-77e5091bceb9', '6617fc31-5146-429b-8b1a-2b8a7c37204c', 'FAKE.local-authority-contact-05@example.invalid', 'FAKE Contact 05', 'FAKE Local Authority', 'FAKE Contact Title', 'FAKE-0000-05', 'FAKE Local Authority Contact 05', true);
INSERT INTO establishment.local_authority_contact (local_authority_contact_id, local_authority_id, contact_email, contact_first_name, contact_last_name, contact_title, contact_phone, contact_role, is_current) VALUES ('e0782ecb-2d42-4ee7-bde3-6d57318766ad', '3574e75c-8870-449a-82e7-1b083e2efc42', 'FAKE.local-authority-contact-06@example.invalid', 'FAKE Contact 06', 'FAKE Local Authority', 'FAKE Contact Title', 'FAKE-0000-06', 'FAKE Local Authority Contact 06', true);
INSERT INTO establishment.local_authority_contact (local_authority_contact_id, local_authority_id, contact_email, contact_first_name, contact_last_name, contact_title, contact_phone, contact_role, is_current) VALUES ('bd6d7572-ab8b-430c-9a1a-f1a8218438fe', '6e8b3ded-c1b4-4a2f-817e-b9bfd3aa3e86', 'FAKE.local-authority-contact-07@example.invalid', 'FAKE Contact 07', 'FAKE Local Authority', 'FAKE Contact Title', 'FAKE-0000-07', 'FAKE Local Authority Contact 07', true);
INSERT INTO establishment.local_authority_contact (local_authority_contact_id, local_authority_id, contact_email, contact_first_name, contact_last_name, contact_title, contact_phone, contact_role, is_current) VALUES ('e2c603dc-92c2-4f82-8826-92860432598e', 'b9f9a0d5-74cb-4bd4-b205-2b8c8fdf3697', 'FAKE.local-authority-contact-08@example.invalid', 'FAKE Contact 08', 'FAKE Local Authority', 'FAKE Contact Title', 'FAKE-0000-08', 'FAKE Local Authority Contact 08', true);
INSERT INTO establishment.local_authority_contact (local_authority_contact_id, local_authority_id, contact_email, contact_first_name, contact_last_name, contact_title, contact_phone, contact_role, is_current) VALUES ('56dec20d-ef88-48fd-96df-ed548f7e0538', '5167896b-40e6-420c-8510-45c4106ac301', 'FAKE.local-authority-contact-09@example.invalid', 'FAKE Contact 09', 'FAKE Local Authority', 'FAKE Contact Title', 'FAKE-0000-09', 'FAKE Local Authority Contact 09', true);
INSERT INTO establishment.local_authority_contact (local_authority_contact_id, local_authority_id, contact_email, contact_first_name, contact_last_name, contact_title, contact_phone, contact_role, is_current) VALUES ('82ab7a53-d9de-4d1f-a876-26288297866b', 'c0b0dbb1-9d64-4b93-9a52-6fe463541bc1', 'FAKE.local-authority-contact-10@example.invalid', 'FAKE Contact 10', 'FAKE Local Authority', 'FAKE Contact Title', 'FAKE-0000-10', 'FAKE Local Authority Contact 10', true);


--
-- Data for Name: local_authority_government_office_region; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('10279260-69e5-4534-9feb-30c48c6d9b06', '1375841f-e6ba-4cda-9fac-753ff9df93a2');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('0956c9af-2de2-4dea-94ed-b5c432eae45f', '1375841f-e6ba-4cda-9fac-753ff9df93a2');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('41ee14e6-dabb-4874-af14-2c93e5adebfa', '1375841f-e6ba-4cda-9fac-753ff9df93a2');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('a916541b-fd17-42f4-a8ac-186326f3817c', '1375841f-e6ba-4cda-9fac-753ff9df93a2');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('6617fc31-5146-429b-8b1a-2b8a7c37204c', '1375841f-e6ba-4cda-9fac-753ff9df93a2');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('3574e75c-8870-449a-82e7-1b083e2efc42', '1375841f-e6ba-4cda-9fac-753ff9df93a2');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('6e8b3ded-c1b4-4a2f-817e-b9bfd3aa3e86', '1375841f-e6ba-4cda-9fac-753ff9df93a2');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('b9f9a0d5-74cb-4bd4-b205-2b8c8fdf3697', '1375841f-e6ba-4cda-9fac-753ff9df93a2');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('5167896b-40e6-420c-8510-45c4106ac301', '1375841f-e6ba-4cda-9fac-753ff9df93a2');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('c0b0dbb1-9d64-4b93-9a52-6fe463541bc1', '1375841f-e6ba-4cda-9fac-753ff9df93a2');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('20011641-8b10-45f9-acb2-4766b159b17d', '1375841f-e6ba-4cda-9fac-753ff9df93a2');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('22b946b9-bc4f-4687-9177-31680e369c9c', '1375841f-e6ba-4cda-9fac-753ff9df93a2');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('4f47e935-0285-478e-af4d-ce3220c144d1', '1375841f-e6ba-4cda-9fac-753ff9df93a2');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('dd41d40d-7a3b-469c-b49d-930cbe7d0dd5', '1375841f-e6ba-4cda-9fac-753ff9df93a2');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('29a27929-4bba-49b9-8fb7-fbf94257fff8', '1375841f-e6ba-4cda-9fac-753ff9df93a2');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('75379562-3c0b-4270-944d-22df468d3cf7', '1375841f-e6ba-4cda-9fac-753ff9df93a2');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('9ff7ac3e-71c5-4eb7-b74c-4a83a229261e', '1375841f-e6ba-4cda-9fac-753ff9df93a2');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('5fc312d8-9428-4ee3-a9ed-9b204c8be91c', '1375841f-e6ba-4cda-9fac-753ff9df93a2');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('b852b15b-c92e-4f4c-a014-5a99cdf7025b', '1375841f-e6ba-4cda-9fac-753ff9df93a2');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('fe174e6d-3642-4892-bd26-8a1dd3ad5d59', '1375841f-e6ba-4cda-9fac-753ff9df93a2');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('987bd60d-dd0c-4707-818f-d4aeb184a7b8', '1375841f-e6ba-4cda-9fac-753ff9df93a2');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('c83c49ad-6125-4936-ac35-e8f804f49ba8', '1375841f-e6ba-4cda-9fac-753ff9df93a2');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('d9936778-b559-4d95-aedc-cffea5d3a18f', '1375841f-e6ba-4cda-9fac-753ff9df93a2');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('d818eaaa-a1ae-44cc-b02e-98fbeb4dc406', '1375841f-e6ba-4cda-9fac-753ff9df93a2');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('3eb4bca9-62d4-4b5d-96e7-69693099d354', '1375841f-e6ba-4cda-9fac-753ff9df93a2');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('e10c2651-5a62-4b95-bb0b-2f81c55c6467', '1375841f-e6ba-4cda-9fac-753ff9df93a2');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('709d8fff-6108-4446-9ec0-d648b85c4683', '1375841f-e6ba-4cda-9fac-753ff9df93a2');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('c22f0cc4-052e-44b6-a13d-308e877a16e3', '1375841f-e6ba-4cda-9fac-753ff9df93a2');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('0abdf041-18e4-487d-9eac-f30657f66ebd', '1375841f-e6ba-4cda-9fac-753ff9df93a2');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('4efdbb20-4c85-4e3c-abe7-6de1186e5990', '1375841f-e6ba-4cda-9fac-753ff9df93a2');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('3e8db405-e3da-4b0d-9a31-1f88061ee3b4', '1375841f-e6ba-4cda-9fac-753ff9df93a2');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('34427472-2794-4f4b-9bf3-d17e2b945133', '1375841f-e6ba-4cda-9fac-753ff9df93a2');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('4f674528-165a-40a0-b3fc-b8588fcc5241', '1375841f-e6ba-4cda-9fac-753ff9df93a2');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('2331ef34-0efc-46ff-bd37-a5046d40a753', '7ca695f4-dfcd-4f78-bdaf-17861eafbf97');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('33a476dc-5eb8-4150-9a06-6364f8130bbe', '7ca695f4-dfcd-4f78-bdaf-17861eafbf97');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('1b0ebe93-3b10-4663-98b5-a096c63e8040', '7ca695f4-dfcd-4f78-bdaf-17861eafbf97');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('cb3f41c9-3a3c-4632-8b67-2ecf69b670fc', '7ca695f4-dfcd-4f78-bdaf-17861eafbf97');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('24403d37-2f07-4bbb-bd2d-f7e1fadf7fbf', '7ca695f4-dfcd-4f78-bdaf-17861eafbf97');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('db38471e-2843-4e5a-9712-1d8fc220f3de', '7ca695f4-dfcd-4f78-bdaf-17861eafbf97');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('3cc794db-378c-4fd1-b201-dcd8078462e6', '7ca695f4-dfcd-4f78-bdaf-17861eafbf97');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('00b4455a-6f3e-4b8e-8399-b7db5455d306', '489dce3e-58d7-44c5-b9ef-2f7d7cbdb592');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('df763548-f436-42d8-ae03-ddcc7cf6d77c', '489dce3e-58d7-44c5-b9ef-2f7d7cbdb592');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('35b43617-d7aa-45b7-8031-07494aa5c136', '489dce3e-58d7-44c5-b9ef-2f7d7cbdb592');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('c74da403-1c0d-480d-bd31-a548a7305e80', '489dce3e-58d7-44c5-b9ef-2f7d7cbdb592');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('1b99670e-0e47-46d4-b618-b7ee0ed45f14', '489dce3e-58d7-44c5-b9ef-2f7d7cbdb592');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('7a6803d6-c5fa-47ff-97af-7e13757750b0', '489dce3e-58d7-44c5-b9ef-2f7d7cbdb592');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('353acfff-cbbe-4a26-817a-a4e6e0875c5c', '489dce3e-58d7-44c5-b9ef-2f7d7cbdb592');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('0a78f87e-d71b-44c3-b598-2cc2b8038e95', '489dce3e-58d7-44c5-b9ef-2f7d7cbdb592');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('2625193c-09d9-45a7-bcb2-b1dcdf077b61', '489dce3e-58d7-44c5-b9ef-2f7d7cbdb592');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('5601040a-cd9c-499f-b38a-f7a77479cd7f', '489dce3e-58d7-44c5-b9ef-2f7d7cbdb592');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('e7fbed96-c797-4709-92c8-310ec0c3245c', '489dce3e-58d7-44c5-b9ef-2f7d7cbdb592');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('e9345306-86a0-442b-bafa-4ebcfd1a877c', '489dce3e-58d7-44c5-b9ef-2f7d7cbdb592');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('2e8478cf-6cbc-424a-ade1-050239c7d330', '489dce3e-58d7-44c5-b9ef-2f7d7cbdb592');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('7734fb10-1f0f-49da-b13f-e3c538beb17a', '489dce3e-58d7-44c5-b9ef-2f7d7cbdb592');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('2601da0a-6f35-4c15-984e-f4482d1df384', '489dce3e-58d7-44c5-b9ef-2f7d7cbdb592');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('bcbf9ead-5cd3-4616-b0ba-c805d60bb7e7', 'f5cdf1f1-5f75-4420-b597-862614e13549');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('77b9cfe6-842e-41c8-9be4-410cac32719a', 'f5cdf1f1-5f75-4420-b597-862614e13549');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('fdb10144-ddb3-4a5a-9eae-21a3da07031b', 'f5cdf1f1-5f75-4420-b597-862614e13549');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('0881090c-70bc-486a-a74c-6c3754f93c88', 'f5cdf1f1-5f75-4420-b597-862614e13549');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('74887ed3-ff4f-45a9-b9bf-22e9aec0fa66', 'f5cdf1f1-5f75-4420-b597-862614e13549');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('31e56f49-2fb5-4b09-a80f-cceebcce7e07', 'f5cdf1f1-5f75-4420-b597-862614e13549');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('a7a2261a-963a-4396-a976-98a6a39c7936', 'f5cdf1f1-5f75-4420-b597-862614e13549');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('e62b9c65-4a77-474c-a2a3-0cf0f70ca2e3', 'f5cdf1f1-5f75-4420-b597-862614e13549');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('7788aab1-b623-462a-9e65-32e7d9c353ca', 'f5cdf1f1-5f75-4420-b597-862614e13549');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('7d097780-45d5-4445-a0e3-7b76e09e4bb3', '6cc3324b-91cb-4ea6-a0db-2cd327ce7941');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('e81ff5ff-09b8-46ae-ad1d-fff4604cd987', '6cc3324b-91cb-4ea6-a0db-2cd327ce7941');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('cf117bdb-0226-42f0-9f40-e11aa3369b61', '6cc3324b-91cb-4ea6-a0db-2cd327ce7941');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('2cf281fc-921d-418b-9243-4f54a59ac052', '6cc3324b-91cb-4ea6-a0db-2cd327ce7941');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('2cd82783-74ed-4b7c-82c5-450101d78ac4', '6cc3324b-91cb-4ea6-a0db-2cd327ce7941');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('d7a06acf-52cf-4239-92f4-f6ce9af1556a', '21478f61-4270-49ad-8c24-d9058ea036ab');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('49873b81-b75f-4e3a-9b74-608a06b35d0c', '28c0b88a-9329-4c96-9ac8-cb44cf6926e1');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('8fb5ef34-d13b-4864-9d2b-4932b86cba4d', '28c0b88a-9329-4c96-9ac8-cb44cf6926e1');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('4cf5905c-6515-4f7f-80f3-8e7f58edd478', '28c0b88a-9329-4c96-9ac8-cb44cf6926e1');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('b24af43a-5cfc-448f-8e4e-43da7cd0601a', '28c0b88a-9329-4c96-9ac8-cb44cf6926e1');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('ae106cbe-8e7f-4318-900f-0a235e304043', '28c0b88a-9329-4c96-9ac8-cb44cf6926e1');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('58b9e813-3c32-4da2-b590-e95f821b94fd', '28c0b88a-9329-4c96-9ac8-cb44cf6926e1');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('9b399694-f8d9-45da-98f3-bce51c027b0e', '28c0b88a-9329-4c96-9ac8-cb44cf6926e1');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('19452369-a4c3-426b-a5fb-4e34a81a0253', '28c0b88a-9329-4c96-9ac8-cb44cf6926e1');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('5483bf0c-f14a-42e7-b2f5-f349f831570c', '28c0b88a-9329-4c96-9ac8-cb44cf6926e1');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('2dfe9d4f-5760-40de-9140-fc00ad0b92fd', '28c0b88a-9329-4c96-9ac8-cb44cf6926e1');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('978e6e3d-47d0-471b-b830-f8a21b2bad1d', '28c0b88a-9329-4c96-9ac8-cb44cf6926e1');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('d5e442e1-da7e-423a-8f83-498e0114d5ab', '28c0b88a-9329-4c96-9ac8-cb44cf6926e1');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('019c45e1-caca-4e7b-97e4-6bbd54b155f3', '28c0b88a-9329-4c96-9ac8-cb44cf6926e1');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('07bfe421-8047-4f34-8421-267734e72c82', '28c0b88a-9329-4c96-9ac8-cb44cf6926e1');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('2884de00-e0be-4adc-9c25-0738a4ccf110', '28c0b88a-9329-4c96-9ac8-cb44cf6926e1');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('2ca74ae1-648a-4a8f-a52e-7213f316f451', '28c0b88a-9329-4c96-9ac8-cb44cf6926e1');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('af39818c-0553-4686-9843-dadbf2f10a9e', '28c0b88a-9329-4c96-9ac8-cb44cf6926e1');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('1e826e80-82e8-4676-a5a7-b4c5edfbc560', '28c0b88a-9329-4c96-9ac8-cb44cf6926e1');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('b7d08b02-fd4e-4206-85ee-7cdfeaaa7c08', '28c0b88a-9329-4c96-9ac8-cb44cf6926e1');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('2ccda29b-5f3b-4adf-9a9b-6f24071bfaa2', '28c0b88a-9329-4c96-9ac8-cb44cf6926e1');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('0fa3ad59-cc32-4c31-a123-f2bf56e45c5a', '28c0b88a-9329-4c96-9ac8-cb44cf6926e1');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('2071cd19-b79e-4c80-aaac-47be5cc80089', '21478f61-4270-49ad-8c24-d9058ea036ab');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('50d53eb6-b12f-4962-8eff-50c36d424d9d', '21478f61-4270-49ad-8c24-d9058ea036ab');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('e44c7526-3b42-47ee-b3ca-1ccd5c37744a', '21478f61-4270-49ad-8c24-d9058ea036ab');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('ac649890-34e4-4204-8241-b6ea6b8ee8ae', '21478f61-4270-49ad-8c24-d9058ea036ab');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('34527815-5555-490b-8d7a-63c766c57dd5', '6cc3324b-91cb-4ea6-a0db-2cd327ce7941');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('093a0c1c-b1d3-41f4-b33c-b8d9b609acc1', '6cc3324b-91cb-4ea6-a0db-2cd327ce7941');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('8d9e4a37-f50c-41c9-81c3-895306cf4782', '6cc3324b-91cb-4ea6-a0db-2cd327ce7941');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('fc015308-d288-4fcb-83de-4122b917b0f9', '6cc3324b-91cb-4ea6-a0db-2cd327ce7941');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('74d83726-41f7-4e5a-8a57-0e304e4736e7', 'f5cdf1f1-5f75-4420-b597-862614e13549');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('a5aeb112-ca6f-4b1a-b614-df4ce06eed2a', 'f5cdf1f1-5f75-4420-b597-862614e13549');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('fad94daf-6f11-4cd2-9256-7270f0787391', 'f5cdf1f1-5f75-4420-b597-862614e13549');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('ce696e6c-24a4-4a56-95da-947bac9cc4d4', 'f5cdf1f1-5f75-4420-b597-862614e13549');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('4cb5116b-d132-47bb-a99f-98ceef5c8dbe', 'f5cdf1f1-5f75-4420-b597-862614e13549');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('a1c5d24c-5ecc-4889-92ab-9163a91e3e79', 'f5cdf1f1-5f75-4420-b597-862614e13549');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('0f449571-79f9-454e-b19a-ae34b5c31cb3', '32e46d74-0ebf-495b-8261-2c508cd2c2bb');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('3dfc7437-5d3d-4e69-ae0b-c97376d6cc38', '32e46d74-0ebf-495b-8261-2c508cd2c2bb');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('942f0927-84a7-43b6-8be9-68f88917b043', '32e46d74-0ebf-495b-8261-2c508cd2c2bb');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('0a7cb25e-e9f9-40c7-97f5-5eee9bb436ee', '32e46d74-0ebf-495b-8261-2c508cd2c2bb');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('3346d12b-0c32-4bf2-b3eb-2e2e2d24dbc7', 'f85647db-e5d1-41a6-befb-bfbf6420f5c4');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('1ab5d183-d9d1-4d00-9f6c-eb75c323d92c', 'f85647db-e5d1-41a6-befb-bfbf6420f5c4');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('05cc5f5e-45cd-437e-805e-0ec749453739', '9c5ec547-5f0d-4ed6-938c-ba51c67d197d');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('24f8bcc1-22d4-4ac1-9887-c5392ca4a5b9', '9c5ec547-5f0d-4ed6-938c-ba51c67d197d');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('84f7c0ea-e498-4f14-bfa9-896a12e91a47', '21478f61-4270-49ad-8c24-d9058ea036ab');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('0ffd5853-b247-4645-bb43-4c21cd3c097f', '21478f61-4270-49ad-8c24-d9058ea036ab');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('a717a384-7ad1-4905-8d05-dea6f9bc274a', '21478f61-4270-49ad-8c24-d9058ea036ab');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('5aac67d2-6e20-477c-a3f6-0ba844fa4bac', '21478f61-4270-49ad-8c24-d9058ea036ab');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('516a5708-bc4f-4f0d-9a8d-8cb036494616', '21478f61-4270-49ad-8c24-d9058ea036ab');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('04f71e88-521e-4679-ba88-83125125950c', '6cc3324b-91cb-4ea6-a0db-2cd327ce7941');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('221e3d83-edc6-4a8d-949c-f77a6785b431', '6cc3324b-91cb-4ea6-a0db-2cd327ce7941');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('23dec583-f738-4c69-94f8-8419868cefad', 'f85647db-e5d1-41a6-befb-bfbf6420f5c4');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('8bb04782-9600-4d83-a0c0-e9d2d3466c34', 'f85647db-e5d1-41a6-befb-bfbf6420f5c4');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('5885bd90-8384-462f-9edb-a90f44519d81', 'f85647db-e5d1-41a6-befb-bfbf6420f5c4');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('cf2319f9-aced-4926-8d4b-e10cac4024a9', 'f85647db-e5d1-41a6-befb-bfbf6420f5c4');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('dd45f000-7108-4d65-aa54-75fd7eaad6bb', 'f85647db-e5d1-41a6-befb-bfbf6420f5c4');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('51cb7b94-0266-48b5-8d90-f13aa42b983d', '9c5ec547-5f0d-4ed6-938c-ba51c67d197d');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('34a353a0-aab3-4aee-978a-937a1bf24f34', '9c5ec547-5f0d-4ed6-938c-ba51c67d197d');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('8a475312-0978-46ba-a4af-ffef53132608', '9c5ec547-5f0d-4ed6-938c-ba51c67d197d');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('55083c61-a058-42c6-a0f9-680a97700a80', '7ca695f4-dfcd-4f78-bdaf-17861eafbf97');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('3332ea83-bcbe-48d1-970d-a3650d9bcf10', '7ca695f4-dfcd-4f78-bdaf-17861eafbf97');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('f029fe2f-656d-409c-aca4-fdd50231fa75', '21478f61-4270-49ad-8c24-d9058ea036ab');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('4eb4d2f2-73bc-4f31-a476-1a265094b7aa', '21478f61-4270-49ad-8c24-d9058ea036ab');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('f4d6c9d4-fbff-4538-b0a1-53d6d8c36a0b', 'f85647db-e5d1-41a6-befb-bfbf6420f5c4');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('0659cec9-f4f1-4281-aa38-dac5b79a93e7', 'f85647db-e5d1-41a6-befb-bfbf6420f5c4');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('19c03d55-f6bd-4912-85db-129ff938d6fd', 'f85647db-e5d1-41a6-befb-bfbf6420f5c4');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('154a9b7a-7ef2-4988-9c4d-49e10a09507d', 'f85647db-e5d1-41a6-befb-bfbf6420f5c4');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('e7980e70-c33e-4539-8573-106a6245da72', 'f85647db-e5d1-41a6-befb-bfbf6420f5c4');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('de723409-6555-4aed-a1f9-82b6e9cb1cc1', 'f85647db-e5d1-41a6-befb-bfbf6420f5c4');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('3a839d72-f591-4c51-9b4b-91637c541035', '32e46d74-0ebf-495b-8261-2c508cd2c2bb');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('42e364c7-0769-4180-85af-94979c4a5604', '32e46d74-0ebf-495b-8261-2c508cd2c2bb');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('75380e70-1b77-4afb-a53e-a69c2f21f86e', '489dce3e-58d7-44c5-b9ef-2f7d7cbdb592');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('b8bab4f4-b58c-4b0f-9a07-df5d16f9380b', '489dce3e-58d7-44c5-b9ef-2f7d7cbdb592');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('145f84fa-36ae-4c6c-84f0-3f6b551ac5b2', '489dce3e-58d7-44c5-b9ef-2f7d7cbdb592');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('275bafd9-e869-4606-ad4a-6c578baae51f', '21478f61-4270-49ad-8c24-d9058ea036ab');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('5725447b-2398-4c41-8ca0-4fa6ebb9e691', '21478f61-4270-49ad-8c24-d9058ea036ab');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('ba283a65-25f7-4eac-a3ec-fa46b93d1245', '21478f61-4270-49ad-8c24-d9058ea036ab');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('fc8cf832-fb45-45ba-bc98-09fb41b3a224', '32e46d74-0ebf-495b-8261-2c508cd2c2bb');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('dc9f9e86-8d80-46b7-87bc-e998cafca819', '32e46d74-0ebf-495b-8261-2c508cd2c2bb');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('a8333a46-7a89-42b6-ab95-43a73e09e704', '7ca695f4-dfcd-4f78-bdaf-17861eafbf97');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('3f8cc89e-9279-48fd-b440-48dc00f06fca', '7ca695f4-dfcd-4f78-bdaf-17861eafbf97');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('893121c9-05e6-4e35-bfef-ea76e40c012e', 'f85647db-e5d1-41a6-befb-bfbf6420f5c4');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('f0810578-383d-4303-b694-41e13fb73823', 'f85647db-e5d1-41a6-befb-bfbf6420f5c4');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('a4572037-9765-42e9-890c-0a4c47a49abd', '489dce3e-58d7-44c5-b9ef-2f7d7cbdb592');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('88a167eb-994e-49ae-b1ee-4db968a5bf4b', '489dce3e-58d7-44c5-b9ef-2f7d7cbdb592');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('b8be820c-b9c1-4b6e-80e4-53384b370924', '489dce3e-58d7-44c5-b9ef-2f7d7cbdb592');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('7004982b-a526-4013-82b5-68c877c0de28', '9c5ec547-5f0d-4ed6-938c-ba51c67d197d');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('c97c1960-148d-4fa3-8f4a-81fb6da42447', '9c5ec547-5f0d-4ed6-938c-ba51c67d197d');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('3bb666d7-f8a2-4c07-b5de-06eead480743', '7ca695f4-dfcd-4f78-bdaf-17861eafbf97');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('e9fbec24-bc95-49dd-b2a5-76e562c97185', '7ca695f4-dfcd-4f78-bdaf-17861eafbf97');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('b0785849-4633-422e-b170-6b33fd8c4555', '489dce3e-58d7-44c5-b9ef-2f7d7cbdb592');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('62f727b9-cb7a-49b4-9a78-3bda13bdc5ca', '489dce3e-58d7-44c5-b9ef-2f7d7cbdb592');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('d7f6360e-a0a2-4948-9abe-b8dfa2191c83', '21478f61-4270-49ad-8c24-d9058ea036ab');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('3ae26c72-c959-4407-8d09-ab05653ff56b', '32e46d74-0ebf-495b-8261-2c508cd2c2bb');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('81bf98ca-5884-443d-bf88-b319df5c53b7', 'f85647db-e5d1-41a6-befb-bfbf6420f5c4');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('8cc4e741-ebed-449f-a828-4c1e2dafde43', 'f85647db-e5d1-41a6-befb-bfbf6420f5c4');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('9ea9a305-39f5-4c57-9ef2-3a3673c4c132', '32e46d74-0ebf-495b-8261-2c508cd2c2bb');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('05967224-7461-414d-b378-0ba6f085b3e4', '489dce3e-58d7-44c5-b9ef-2f7d7cbdb592');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('c03b5eac-473d-4abc-8cea-1aecc5717477', '6cc3324b-91cb-4ea6-a0db-2cd327ce7941');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('6c224a0d-ed93-4dc1-bb76-b39f7890044e', '21478f61-4270-49ad-8c24-d9058ea036ab');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('36b0d8c9-ea35-4cc1-9d29-fef2975d98f9', '489dce3e-58d7-44c5-b9ef-2f7d7cbdb592');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('35cb204a-5a7d-40d8-b5d2-98b3b872b2ce', '9c5ec547-5f0d-4ed6-938c-ba51c67d197d');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('1d92096e-0bb4-44dd-9298-35405a6092ff', '21478f61-4270-49ad-8c24-d9058ea036ab');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('39bbbc7d-18de-4c56-9072-3e2f053e745a', '21478f61-4270-49ad-8c24-d9058ea036ab');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('c09f8fc9-9f2d-4f77-bea5-80528c3533ae', '6cc3324b-91cb-4ea6-a0db-2cd327ce7941');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('8ba06800-fec1-41da-b0a9-822f05fb9019', 'f85647db-e5d1-41a6-befb-bfbf6420f5c4');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('1e59b614-94db-427c-bfd3-99c0b393ad14', '32e46d74-0ebf-495b-8261-2c508cd2c2bb');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('3b110d34-2776-4827-969e-2af0d39a4aa2', '21478f61-4270-49ad-8c24-d9058ea036ab');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('200c738d-2f8f-4349-b600-f568a52f7389', 'f85647db-e5d1-41a6-befb-bfbf6420f5c4');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('4576e83b-4f05-4e08-bce7-2bcc4ed79c9c', '7ca695f4-dfcd-4f78-bdaf-17861eafbf97');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('17d78c35-15f4-4065-a8c1-7e06b39285ec', '32e46d74-0ebf-495b-8261-2c508cd2c2bb');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('f8eedfd2-0ee9-49ba-a21a-d3b7689ca877', 'f5cdf1f1-5f75-4420-b597-862614e13549');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('3b27e455-7000-4c6a-b41f-5fbe41bef115', 'f85647db-e5d1-41a6-befb-bfbf6420f5c4');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('8be0b302-bc81-41b6-822a-131b844dac65', 'f85647db-e5d1-41a6-befb-bfbf6420f5c4');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('f9819105-1161-47ad-9bb9-25d960a9370a', '489dce3e-58d7-44c5-b9ef-2f7d7cbdb592');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('cf173149-3ef1-4f3d-888f-c7d6fe4024a7', '9c5ec547-5f0d-4ed6-938c-ba51c67d197d');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('00720f6a-c51f-4c33-8146-3c3bd96dc279', '9c5ec547-5f0d-4ed6-938c-ba51c67d197d');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('bb96fa49-32fb-408b-84cd-5d067bce81d0', '32e46d74-0ebf-495b-8261-2c508cd2c2bb');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('b2cdb195-afdc-4aef-a886-065c30e8d726', 'f5cdf1f1-5f75-4420-b597-862614e13549');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('4f5cf1f1-e617-4ad7-b077-41042c25dd30', '9c5ec547-5f0d-4ed6-938c-ba51c67d197d');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('7022a4a3-5042-4d4f-af8e-fe3f8e0987b3', '6cc3324b-91cb-4ea6-a0db-2cd327ce7941');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('e3406846-6987-4d8e-b2cf-f318721c1b11', '9c5ec547-5f0d-4ed6-938c-ba51c67d197d');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('cdf59613-2d50-4afa-9ad0-69ab9555cc63', 'f85647db-e5d1-41a6-befb-bfbf6420f5c4');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('f8337f43-8a21-4010-90ff-46ea8a95f486', '7ca695f4-dfcd-4f78-bdaf-17861eafbf97');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('7b8c9e1a-8fc4-4651-b901-7846b63b0672', '21478f61-4270-49ad-8c24-d9058ea036ab');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('07c97c88-db4f-4861-8d5f-42c14416c7b1', '7ca695f4-dfcd-4f78-bdaf-17861eafbf97');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('c1782af8-ed41-4ee1-bd3a-a5449b43acde', '32e46d74-0ebf-495b-8261-2c508cd2c2bb');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('f76fed20-3a9b-4a0d-b15f-b3cde9c65b0a', 'f85647db-e5d1-41a6-befb-bfbf6420f5c4');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('26478edc-2fa3-4d8b-b9f7-aebc52a7dd2a', '7ca695f4-dfcd-4f78-bdaf-17861eafbf97');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('8e5cc3ab-5773-49b5-9242-44413e8c2bf4', 'f85647db-e5d1-41a6-befb-bfbf6420f5c4');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('fe1af861-cf8a-4ec2-8138-8044c254786d', '21478f61-4270-49ad-8c24-d9058ea036ab');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('e88b8486-ec97-4b98-a450-f0166bfe954f', '9c5ec547-5f0d-4ed6-938c-ba51c67d197d');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('8cb6de69-7978-4365-be32-d4f17554110a', '9c5ec547-5f0d-4ed6-938c-ba51c67d197d');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('e2ce8ae7-4ce9-4963-88cc-4456fb70de9d', '489dce3e-58d7-44c5-b9ef-2f7d7cbdb592');
INSERT INTO establishment.local_authority_government_office_region (local_authority_id, government_office_region_id) VALUES ('c3481033-0753-4614-b00b-677ccc85d1ee', '489dce3e-58d7-44c5-b9ef-2f7d7cbdb592');


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

\unrestrict vA7pod6Uz7TcdnnWftpEFqVEX7V2P0lxghkiUVLdIgJbinGdUv5uXkacQfHEhbY

