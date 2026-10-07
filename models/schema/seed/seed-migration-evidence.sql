--
-- PostgreSQL database dump
--

\restrict Vln2OUxqAC8wIMrE6hBhggM0schp490klIFpouKpY0Hhx9UYARRAl4MVs3OgQJJ

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
-- Data for Name: migration_run; Type: TABLE DATA; Schema: migration; Owner: -
--

INSERT INTO migration.migration_run (migration_run_id, run_type, source_system, source_database, source_snapshot_date, started_at, completed_at, status, transform_version, notes) VALUES
	('c2f4c057-48f1-4315-8ee2-c7b12659a7cd', 'establishment-rebuild', 'GIAS BAU', 'gias_bau_test_local', '2026-10-07', '2026-10-07 09:40:06.198399+01', '2026-10-07 09:41:18.195271+01', 'completed', 'establishment-party-responsibility-v2', NULL);


--
-- Data for Name: source_snapshot; Type: TABLE DATA; Schema: migration; Owner: -
--

INSERT INTO migration.source_snapshot (source_snapshot_id, migration_run_id, source_system, source_database, snapshot_date, extract_name, created_at) VALUES
	('eef829f4-b3a4-4cea-a5fe-e3eb44349ab5', 'c2f4c057-48f1-4315-8ee2-c7b12659a7cd', 'GIAS BAU', 'gias_bau_test_local', '2026-10-07', 'establishment-party-136102-2777', '2026-10-07 09:40:39.705071+01'),
	('d89f6de1-ca42-4407-b72e-014bcf63518b', 'c2f4c057-48f1-4315-8ee2-c7b12659a7cd', 'GIAS BAU', 'gias_bau_test_local', '2026-10-07', 'establishment-party-136102-2779', '2026-10-07 09:40:40.273604+01'),
	('e57c20c7-35e7-4c9a-917c-7c7820c0bd28', 'c2f4c057-48f1-4315-8ee2-c7b12659a7cd', 'GIAS BAU', 'gias_bau_test_local', '2026-10-07', 'establishment-party-136102-4949', '2026-10-07 09:40:40.899029+01'),
	('0fc93b0e-8b49-4751-9490-f8a803c9e0dd', 'c2f4c057-48f1-4315-8ee2-c7b12659a7cd', 'GIAS BAU', 'gias_bau_test_local', '2026-10-07', 'establishment-party-134314-23869', '2026-10-07 09:40:41.488688+01'),
	('6c18374b-f432-467d-a0a1-1a2fadf3c3e4', 'c2f4c057-48f1-4315-8ee2-c7b12659a7cd', 'GIAS BAU', 'gias_bau_test_local', '2026-10-07', 'establishment-party-134314-4737', '2026-10-07 09:40:42.086921+01'),
	('9e4565cb-0bc5-4f23-b276-67f62a802496', 'c2f4c057-48f1-4315-8ee2-c7b12659a7cd', 'GIAS BAU', 'gias_bau_test_local', '2026-10-07', 'establishment-party-134314-2914', '2026-10-07 09:40:42.726351+01'),
	('e154e1ac-f375-42ba-8128-38d8b31c38a7', 'c2f4c057-48f1-4315-8ee2-c7b12659a7cd', 'GIAS BAU', 'gias_bau_test_local', '2026-10-07', 'establishment-party-135905-3839', '2026-10-07 09:40:43.401409+01'),
	('d1ef5573-a4dc-423e-a113-7ace015a2083', 'c2f4c057-48f1-4315-8ee2-c7b12659a7cd', 'GIAS BAU', 'gias_bau_test_local', '2026-10-07', 'establishment-party-137603-2055', '2026-10-07 09:40:44.194644+01'),
	('0846743b-f959-44cd-8ab8-fa27be31de60', 'c2f4c057-48f1-4315-8ee2-c7b12659a7cd', 'GIAS BAU', 'gias_bau_test_local', '2026-10-07', 'establishment-party-137603-20364', '2026-10-07 09:40:45.15414+01'),
	('fb189c1c-b501-47ae-9253-9678b93dfd72', 'c2f4c057-48f1-4315-8ee2-c7b12659a7cd', 'GIAS BAU', 'gias_bau_test_local', '2026-10-07', 'establishment-party-132141-1337', '2026-10-07 09:40:45.863808+01'),
	('a15d8983-08b1-46de-9b0d-efd456fd811b', 'c2f4c057-48f1-4315-8ee2-c7b12659a7cd', 'GIAS BAU', 'gias_bau_test_local', '2026-10-07', 'establishment-party-135936-2613', '2026-10-07 09:40:46.491358+01'),
	('b42a22d6-aeef-40aa-8f02-653efaf82a24', 'c2f4c057-48f1-4315-8ee2-c7b12659a7cd', 'GIAS BAU', 'gias_bau_test_local', '2026-10-07', 'establishment-party-135936-3147', '2026-10-07 09:40:47.208249+01'),
	('920ddac9-c3e1-4c74-8a1c-19e7fb766bdb', 'c2f4c057-48f1-4315-8ee2-c7b12659a7cd', 'GIAS BAU', 'gias_bau_test_local', '2026-10-07', 'organisation-group-1809', '2026-10-07 09:40:47.764602+01'),
	('73c901f7-1989-4138-bc88-58be6319e52d', 'c2f4c057-48f1-4315-8ee2-c7b12659a7cd', 'GIAS BAU', 'gias_bau_test_local', '2026-10-07', 'organisation-group-86052', '2026-10-07 09:40:48.259692+01'),
	('dda504d7-a928-4a20-8cfc-164fdc99651a', 'c2f4c057-48f1-4315-8ee2-c7b12659a7cd', 'GIAS public extract', NULL, '2026-06-16', 'docs/data/extract-data/establishment-fields/edubasealldata20260616.csv', '2026-10-07 09:41:01.313777+01'),
	('d350c1df-fcf0-4e8b-a577-19a1cd9a20cc', 'c2f4c057-48f1-4315-8ee2-c7b12659a7cd', 'GIAS BAU', 'gias_bau_test_local', '2026-10-07', 'T9-local-proprietor-context', '2026-10-07 09:41:01.313777+01');


--
-- Data for Name: source_record; Type: TABLE DATA; Schema: migration; Owner: -
--

INSERT INTO migration.source_record (source_record_id, source_snapshot_id, source_table, source_key, source_group_id, source_urn, source_row_hash) VALUES
	('bc553305-dc03-4837-896c-131499639a37', 'eef829f4-b3a4-4cea-a5fe-e3eb44349ab5', 'dbo.EstablishmentGroup/GroupLink', '2777:136102', '2777', 136102, NULL),
	('125d305b-f9cf-4bef-93b1-50a045a1e3e3', 'd89f6de1-ca42-4407-b72e-014bcf63518b', 'dbo.EstablishmentGroup/GroupLink', '2779:136102', '2779', 136102, NULL),
	('ce997630-dff0-4fa8-8780-ad87457670e2', 'e57c20c7-35e7-4c9a-917c-7c7820c0bd28', 'dbo.EstablishmentGroup/GroupLink', '4949:136102', '4949', 136102, NULL),
	('28900ffe-c40c-40c7-ad03-5d286e7ebdc5', '0fc93b0e-8b49-4751-9490-f8a803c9e0dd', 'dbo.EstablishmentGroup/GroupLink', '23869:134314', '23869', 134314, NULL),
	('a3be0df1-1543-42ca-bddb-d4a284d0d322', '6c18374b-f432-467d-a0a1-1a2fadf3c3e4', 'dbo.EstablishmentGroup/GroupLink', '4737:134314', '4737', 134314, NULL),
	('6d794554-cac5-46a8-b636-106c37f99e74', '9e4565cb-0bc5-4f23-b276-67f62a802496', 'dbo.EstablishmentGroup/GroupLink', '2914:134314', '2914', 134314, NULL),
	('3b77b798-fa61-49e8-ac2c-fa67b716c9d6', 'e154e1ac-f375-42ba-8128-38d8b31c38a7', 'dbo.EstablishmentGroup/GroupLink', '3839:135905', '3839', 135905, NULL),
	('46ede70b-0106-4914-a2aa-a943d43cd2d6', 'd1ef5573-a4dc-423e-a113-7ace015a2083', 'dbo.EstablishmentGroup/GroupLink', '2055:137603', '2055', 137603, NULL),
	('eceb4294-06fe-43b0-9730-15157fbe675e', '0846743b-f959-44cd-8ab8-fa27be31de60', 'dbo.EstablishmentGroup/GroupLink', '20364:137603', '20364', 137603, NULL),
	('87cf4d6f-6972-4355-a9d3-2c1218a88c62', 'fb189c1c-b501-47ae-9253-9678b93dfd72', 'dbo.EstablishmentGroup/GroupLink', '1337:132141', '1337', 132141, NULL),
	('66d6fa0b-c6c3-4df7-9f2e-e5a40e3ca543', 'a15d8983-08b1-46de-9b0d-efd456fd811b', 'dbo.EstablishmentGroup/GroupLink', '2613:135936', '2613', 135936, NULL),
	('e0e252ab-ec9d-4e7d-ada8-c3d8c8cb475e', 'b42a22d6-aeef-40aa-8f02-653efaf82a24', 'dbo.EstablishmentGroup/GroupLink', '3147:135936', '3147', 135936, NULL),
	('cbdbf656-3880-48f3-badf-f2a480c8b44d', '920ddac9-c3e1-4c74-8a1c-19e7fb766bdb', 'dbo.EstablishmentGroup/GroupLink', '1928', '1809', 109443, NULL),
	('ef318b1f-9e5b-4d1e-9cee-3b5121f91c70', '920ddac9-c3e1-4c74-8a1c-19e7fb766bdb', 'dbo.EstablishmentGroup/GroupLink', '1929', '1809', 109613, NULL),
	('4ce8f234-b726-4bb1-b4b4-0af744f56153', '73c901f7-1989-4138-bc88-58be6319e52d', 'dbo.EstablishmentGroup/GroupLink', '25390', '86052', 20338, NULL),
	('09eb7b6b-828d-4258-80c3-0222268c05e7', '73c901f7-1989-4138-bc88-58be6319e52d', 'dbo.EstablishmentGroup/GroupLink', '25391', '86052', 20549, NULL),
	('625461ae-0874-4fea-9abf-e0a93bb7876a', '73c901f7-1989-4138-bc88-58be6319e52d', 'dbo.EstablishmentGroup/GroupLink', '25392', '86052', 20614, NULL),
	('b6bd90e9-2474-4c8d-89de-da0376a535f8', '73c901f7-1989-4138-bc88-58be6319e52d', 'dbo.EstablishmentGroup/GroupLink', '25395', '86052', 21363, NULL),
	('e5c26c45-2005-45ca-bd16-e6fd6fd9142a', '73c901f7-1989-4138-bc88-58be6319e52d', 'dbo.EstablishmentGroup/GroupLink', '25396', '86052', 22422, NULL),
	('34f60aee-8ec1-493f-90b1-54a3a2cca6ee', '73c901f7-1989-4138-bc88-58be6319e52d', 'dbo.EstablishmentGroup/GroupLink', '25394', '86052', 22459, NULL),
	('e55a7389-13de-4a8c-ab82-3ffe2a9c9d54', '73c901f7-1989-4138-bc88-58be6319e52d', 'dbo.EstablishmentGroup/GroupLink', '25397', '86052', 22975, NULL),
	('869fdb6c-f4d3-4803-a5c2-7f0b1353d06b', '73c901f7-1989-4138-bc88-58be6319e52d', 'dbo.EstablishmentGroup/GroupLink', '25393', '86052', 23004, NULL),
	('aa7dbf65-131b-402f-9576-267448a136d1', '73c901f7-1989-4138-bc88-58be6319e52d', 'dbo.EstablishmentGroup/GroupLink', '25398', '86052', 23122, NULL),
	('72cee5b7-3c0d-4d83-a3d7-3a5f075bf20e', 'dda504d7-a928-4a20-8cfc-164fdc99651a', 'Establishment extract PropsName', '112461', NULL, 112461, '10dc16379435aa61d05c534771c10ed9'),
	('a63b71ac-e82d-47a7-a6de-1d70ac90f665', 'dda504d7-a928-4a20-8cfc-164fdc99651a', 'Establishment extract PropsName', '119009', NULL, 119009, '5aa20f3444180e744e297a5fa69e1bee'),
	('3efb0d83-5e22-4bd6-8a96-71c5ddbc618e', 'd350c1df-fcf0-4e8b-a577-19a1cd9a20cc', 'dbo.IndependentSchools (context only)', '112461', NULL, 112461, 'a1cc1f32cf7cafe4e71155e65f89826d'),
	('244e9282-9b59-4140-9300-a48fb04acd1f', 'd350c1df-fcf0-4e8b-a577-19a1cd9a20cc', 'dbo.IndependentSchools (context only)', '119009', NULL, 119009, '40d707e0a0c2f2c8e28582e3845f5dd2');


--
-- Data for Name: academy_trust_classification_evidence; Type: TABLE DATA; Schema: migration; Owner: -
--

INSERT INTO migration.academy_trust_classification_evidence (evidence_id, academy_trust_classification_id, source_record_id, assertion_rule, review_status, notes) VALUES
	('2506333b-7bac-4e77-ae36-25146b04f06b', '105c06f2-f48c-424c-a873-26d753df4790', 'bc553305-dc03-4837-896c-131499639a37', 'MR001', 'accepted', NULL),
	('06f4b92b-ec7c-4df6-8ec3-efb6ab423b3e', 'f0974324-e383-407e-94d1-590a805b042c', '125d305b-f9cf-4bef-93b1-50a045a1e3e3', 'MR005', 'accepted', NULL),
	('7484758b-84e0-4ec4-a377-81c817e3ad27', '801578ea-60cc-423e-aba3-5fd253cdaf96', '28900ffe-c40c-40c7-ad03-5d286e7ebdc5', 'MR001', 'accepted', NULL),
	('5afd299e-817c-4109-a813-0d44bd4edc0f', '98d9f377-c578-4846-a65d-c9610aa6022d', '3b77b798-fa61-49e8-ac2c-fa67b716c9d6', 'MR005', 'accepted', NULL),
	('4e2fc3b2-606f-435e-a412-406a19ab4178', 'd1f41d8c-cbdf-4d66-a74b-149b416ca049', '46ede70b-0106-4914-a2aa-a943d43cd2d6', 'MR005', 'accepted', 'T3: shared Group ID TR00009, UKPRN 10059335 and incorporation date; Companies House 07795736 supplied by MAT 20364. GroupRelationsLink 547 (2055 -> 20364, 1M) and 548 (20364 -> 2055, 1S) evidence classification transition 2021-03-30. Source GroupLink 4778 supplies the historical SAT responsibility start 2011-11-01; GroupLink 34277 supplies the current MAT responsibility start 2021-03-30. One continuing legal entity and role; separate SAT and MAT responsibilities. SAT responsibility end and initial SAT classification start unknown; classification dates are not copied into responsibility boundaries.'),
	('3f37be5c-356b-4527-b159-966f740bac8b', '6bb2d26f-b952-49aa-a449-4a8255c3b9f3', 'eceb4294-06fe-43b0-9730-15157fbe675e', 'MR001', 'accepted', 'T3: shared Group ID TR00009, UKPRN 10059335 and incorporation date; Companies House 07795736 supplied by MAT 20364. GroupRelationsLink 547 (2055 -> 20364, 1M) and 548 (20364 -> 2055, 1S) evidence classification transition 2021-03-30. Source GroupLink 4778 supplies the historical SAT responsibility start 2011-11-01; GroupLink 34277 supplies the current MAT responsibility start 2021-03-30. One continuing legal entity and role; separate SAT and MAT responsibilities. SAT responsibility end and initial SAT classification start unknown; classification dates are not copied into responsibility boundaries.'),
	('b3d1be08-174b-4715-9344-00e36f8e4d60', 'f5b3493b-78bc-4aa7-a239-967fba6ffa54', 'e0e252ab-ec9d-4e7d-ada8-c3d8c8cb475e', 'MR001', 'accepted', NULL);


--
-- Data for Name: establishment_party_role_evidence; Type: TABLE DATA; Schema: migration; Owner: -
--

INSERT INTO migration.establishment_party_role_evidence (evidence_id, establishment_party_role_id, source_record_id, first_observed_date, end_date_basis, inference_rule, review_status, notes) VALUES
	('eef6ebd7-44b1-45f4-b690-ded89e0aa151', '59057f8a-b8fd-4188-b16c-674dbd564859', 'bc553305-dc03-4837-896c-131499639a37', NULL, NULL, NULL, 'accepted', NULL),
	('906c83c8-260a-4f86-aea4-1b2999e4b1df', 'f2e33c0e-37d0-4489-9ef0-5fdd75869582', '125d305b-f9cf-4bef-93b1-50a045a1e3e3', NULL, NULL, NULL, 'accepted', NULL),
	('f9280d67-f26b-48d0-94ac-8ffd63e82776', 'b73aa8bf-21f0-47c1-b574-84492b96c10b', 'ce997630-dff0-4fa8-8780-ad87457670e2', NULL, NULL, NULL, 'accepted', NULL),
	('5d8e17b7-565c-46d9-80db-7a2a19edf236', '01846c62-6790-470b-bdff-d112deca07c6', '28900ffe-c40c-40c7-ad03-5d286e7ebdc5', NULL, NULL, NULL, 'accepted', NULL),
	('442132db-d7a7-4afe-8ab1-d6b36723870c', '01846c62-6790-470b-bdff-d112deca07c6', 'a3be0df1-1543-42ca-bddb-d4a284d0d322', NULL, NULL, NULL, 'accepted', NULL),
	('1ed9755e-789f-4eb7-a843-584c232582bc', '07780fd9-3c18-410e-98b5-270436a1604f', '6d794554-cac5-46a8-b636-106c37f99e74', NULL, NULL, NULL, 'accepted', NULL),
	('fc55a944-7071-4dc6-bd86-4b78c6c9739c', '2ccee160-350e-42be-a1b5-c2fd8fe9fcbb', '3b77b798-fa61-49e8-ac2c-fa67b716c9d6', NULL, 'evidenced', NULL, 'accepted', NULL),
	('75935cb8-cc9b-4f16-9b47-ec478e995f44', '2d4b2846-723c-4570-9de6-0fab60468ecb', '46ede70b-0106-4914-a2aa-a943d43cd2d6', NULL, NULL, NULL, 'accepted', 'T3: shared Group ID TR00009, UKPRN 10059335 and incorporation date; Companies House 07795736 supplied by MAT 20364. GroupRelationsLink 547 (2055 -> 20364, 1M) and 548 (20364 -> 2055, 1S) evidence classification transition 2021-03-30. Source GroupLink 4778 supplies the historical SAT responsibility start 2011-11-01; GroupLink 34277 supplies the current MAT responsibility start 2021-03-30. One continuing legal entity and role; separate SAT and MAT responsibilities. SAT responsibility end and initial SAT classification start unknown; classification dates are not copied into responsibility boundaries.'),
	('c9a3d0a6-4991-4534-81b7-f17b314783ff', '2d4b2846-723c-4570-9de6-0fab60468ecb', 'eceb4294-06fe-43b0-9730-15157fbe675e', NULL, NULL, NULL, 'accepted', 'T3: shared Group ID TR00009, UKPRN 10059335 and incorporation date; Companies House 07795736 supplied by MAT 20364. GroupRelationsLink 547 (2055 -> 20364, 1M) and 548 (20364 -> 2055, 1S) evidence classification transition 2021-03-30. Source GroupLink 4778 supplies the historical SAT responsibility start 2011-11-01; GroupLink 34277 supplies the current MAT responsibility start 2021-03-30. One continuing legal entity and role; separate SAT and MAT responsibilities. SAT responsibility end and initial SAT classification start unknown; classification dates are not copied into responsibility boundaries.'),
	('285751b4-a2cf-44aa-aad1-b6762ff05d45', '1004e4f3-c976-4af7-9221-c73503db5eb3', '87cf4d6f-6972-4355-a9d3-2c1218a88c62', '2026-10-07', NULL, NULL, 'accepted', 'Source GroupLink 1029: archived=0; source group openDate=2010-09-03; role start unknown; group openDate is not role start or incorporation; legal identity provisional.'),
	('a09358a9-fec8-413a-9282-2b0bd329d888', '1b9e9d8c-d891-4fea-9e30-96840f69abbf', '66d6fa0b-c6c3-4df7-9f2e-e5a40e3ca543', '2026-10-07', NULL, NULL, 'accepted', 'T7 reviewed person sponsor: Charles Dunstone. Fulwood Academy identifies Sir Charles as its sponsor and states personal funding: https://www.fulwoodacademy.co.uk/page/?pid=53&title=Welcome+from+the+Sponsor. GroupLink 3648: archived=0; effectiveDate=2009-09-01. Source group openDate=1900-01-01 rejected as placeholder; role start unknown. No Companies House number applies to the person; do not merge with trust UID 3147.'),
	('c7e9aa6d-25c3-4077-a8e5-a406bd751717', '4d2110d0-5eb4-45e0-bae6-906df6f01ebd', 'e0e252ab-ec9d-4e7d-ada8-c3d8c8cb475e', NULL, NULL, NULL, 'accepted', NULL);


--
-- Data for Name: establishment_responsibility_evidence; Type: TABLE DATA; Schema: migration; Owner: -
--

INSERT INTO migration.establishment_responsibility_evidence (evidence_id, establishment_responsibility_id, source_record_id, first_observed_date, end_date_basis, inference_rule, review_status, notes) VALUES
	('bf90d50e-1bfc-4431-83c0-05ef94512731', 'e2c7c2ce-8998-4a65-bc7d-4d67170042b6', 'bc553305-dc03-4837-896c-131499639a37', NULL, NULL, NULL, 'accepted', NULL),
	('836fc5ee-4c5c-476a-8f91-fa833554aeae', 'b8ba4e6a-c93b-4771-8003-7d0472cc5ff3', '125d305b-f9cf-4bef-93b1-50a045a1e3e3', NULL, NULL, NULL, 'accepted', NULL),
	('d709e55f-0d51-4fd8-83a6-e75fcc03abd1', 'f1ff56fe-d50b-492b-9cde-a1a60746a4bd', 'ce997630-dff0-4fa8-8780-ad87457670e2', NULL, NULL, NULL, 'accepted', NULL),
	('fda43699-fb38-4ea7-8e87-c90767944d2c', '7a5adc1e-e402-4ad9-9585-897a45efde49', '28900ffe-c40c-40c7-ad03-5d286e7ebdc5', NULL, NULL, NULL, 'accepted', NULL),
	('2b79ddfe-7882-4d11-a1be-2e96a97c667d', '7f59de00-5378-4d1a-94de-7d94305f6478', 'a3be0df1-1543-42ca-bddb-d4a284d0d322', NULL, NULL, NULL, 'accepted', NULL),
	('6c0378f8-78a4-4c25-8295-a7af9c5adf9a', '7813914d-0855-46b4-ac73-4b51ea7b69d6', '6d794554-cac5-46a8-b636-106c37f99e74', NULL, NULL, NULL, 'accepted', NULL),
	('b5c99f1f-78b3-45c7-9f8b-daf8c98eb168', '0a0be5af-65bb-4a4d-bbf3-c74a12772a5c', '3b77b798-fa61-49e8-ac2c-fa67b716c9d6', NULL, 'inferred', 'Responsibility end date inferred from the source establishment closure date.', 'accepted', NULL),
	('74b554e1-7b61-4dc9-a76f-32c7a3985ff4', 'b61e41fc-7d8b-4b19-8011-b665e74f8aa3', '46ede70b-0106-4914-a2aa-a943d43cd2d6', NULL, NULL, NULL, 'accepted', 'T3: shared Group ID TR00009, UKPRN 10059335 and incorporation date; Companies House 07795736 supplied by MAT 20364. GroupRelationsLink 547 (2055 -> 20364, 1M) and 548 (20364 -> 2055, 1S) evidence classification transition 2021-03-30. Source GroupLink 4778 supplies the historical SAT responsibility start 2011-11-01; GroupLink 34277 supplies the current MAT responsibility start 2021-03-30. One continuing legal entity and role; separate SAT and MAT responsibilities. SAT responsibility end and initial SAT classification start unknown; classification dates are not copied into responsibility boundaries.'),
	('ba091589-1307-49ce-ad8c-7b2278c14487', '940e03a9-a2e6-47c7-a324-11ac4626d239', 'eceb4294-06fe-43b0-9730-15157fbe675e', NULL, NULL, NULL, 'accepted', 'T3: shared Group ID TR00009, UKPRN 10059335 and incorporation date; Companies House 07795736 supplied by MAT 20364. GroupRelationsLink 547 (2055 -> 20364, 1M) and 548 (20364 -> 2055, 1S) evidence classification transition 2021-03-30. Source GroupLink 4778 supplies the historical SAT responsibility start 2011-11-01; GroupLink 34277 supplies the current MAT responsibility start 2021-03-30. One continuing legal entity and role; separate SAT and MAT responsibilities. SAT responsibility end and initial SAT classification start unknown; classification dates are not copied into responsibility boundaries.'),
	('66ee5f63-0c4f-456c-90ac-33e4da591c37', '60d84a78-172f-4b98-a012-e90acb07c4fe', '87cf4d6f-6972-4355-a9d3-2c1218a88c62', NULL, NULL, NULL, 'accepted', 'Source GroupLink 1029: archived=0; responsibility start from effectiveDate; end unknown; source group openDate=2010-09-03; no name-based consolidation.'),
	('1e5b7ba9-f5ba-464e-a07f-c48763e5942f', 'ff32f07d-44ef-479c-af5a-d6e631ae39c5', '66d6fa0b-c6c3-4df7-9f2e-e5a40e3ca543', NULL, NULL, NULL, 'accepted', 'T7 reviewed person sponsor: Charles Dunstone. Fulwood Academy identifies Sir Charles as its sponsor and states personal funding: https://www.fulwoodacademy.co.uk/page/?pid=53&title=Welcome+from+the+Sponsor. GroupLink 3648: archived=0; effectiveDate=2009-09-01. Source group openDate=1900-01-01 rejected as placeholder; role start unknown. No Companies House number applies to the person; do not merge with trust UID 3147.'),
	('b141eeee-e3fb-415d-b5e9-86ef14617a23', '3f803c73-cc86-4270-8358-57f4b8e80cb7', 'e0e252ab-ec9d-4e7d-ada8-c3d8c8cb475e', NULL, NULL, NULL, 'accepted', NULL),
	('fb8115b4-559e-4301-921b-a895219f6187', '63765484-67fe-4f86-a1d4-993210744f23', '3efb0d83-5e22-4bd6-8a96-71c5ddbc618e', NULL, NULL, NULL, 'accepted', 'Local context only: proprietorType_code=01; proprietor_type=Individual Proprietor; additional_proprietor_rows=1. Obfuscated local proprietor identity is not resolved to Acorn; additional rows not imported.'),
	('623272b0-1c79-4a7c-a48f-651d5614493d', '63765484-67fe-4f86-a1d4-993210744f23', '72cee5b7-3c0d-4d83-a3d7-3a5f075bf20e', '2026-06-16', NULL, NULL, 'accepted', 'Controlled accepted PropsName=Acorn Care and Education Ltd; T9 accepted proprietor-identity assumption: both selected extract assertions resolve to one body; local proprietor records are obfuscated, not evidence of Acorn''s legal identity or ownership. Responsibility dates unknown; legal form unverified; ownership not asserted.'),
	('feeae239-8e89-438f-81bd-871fb56654ef', 'b7747702-79a3-44ff-9ee3-0e353728631e', '244e9282-9b59-4140-9300-a48fb04acd1f', NULL, NULL, NULL, 'accepted', 'Local context only: proprietorType_code=01; proprietor_type=Individual Proprietor; additional_proprietor_rows=1. Obfuscated local proprietor identity is not resolved to Acorn; additional rows not imported.'),
	('18182d37-ff2c-4b0d-b4a4-9ab1cfadb597', 'b7747702-79a3-44ff-9ee3-0e353728631e', 'a63b71ac-e82d-47a7-a6de-1d70ac90f665', '2026-06-16', NULL, NULL, 'accepted', 'Controlled accepted PropsName=Acorn Care and Education Ltd; T9 accepted proprietor-identity assumption: both selected extract assertions resolve to one body; local proprietor records are obfuscated, not evidence of Acorn''s legal identity or ownership. Responsibility dates unknown; legal form unverified; ownership not asserted.');


--
-- Data for Name: identity_resolution; Type: TABLE DATA; Schema: migration; Owner: -
--

INSERT INTO migration.identity_resolution (identity_resolution_id, source_record_id, target_entity_type, target_entity_id, resolution_method, confidence, decision_status, decided_at, decided_by, rationale) VALUES
	('d9aa9123-8001-4bb1-b9a2-b9fa017ce745', 'bc553305-dc03-4837-896c-131499639a37', 'legal_entity', 'dfe2042e-da1c-4767-aea0-8fce23d37527', 'companies-house-number', 'high', 'accepted', NULL, NULL, 'Resolved by companies-house-number. A new separate source party is not a verification of its registered legal identity; names do not authorise consolidation.'),
	('3e7bb5cd-e239-40e1-ad83-ff6dee88652d', '125d305b-f9cf-4bef-93b1-50a045a1e3e3', 'legal_entity', '9859a07f-61c0-4845-a976-9adda9fdf604', 'companies-house-number', 'high', 'accepted', NULL, NULL, 'Resolved by companies-house-number. A new separate source party is not a verification of its registered legal identity; names do not authorise consolidation.'),
	('7e1565f6-af4b-4ee7-a9b0-51bf947a8183', 'ce997630-dff0-4fa8-8780-ad87457670e2', 'legal_entity', 'a2dcd133-77fc-40d6-8b7f-6f9655aceb7e', 'new-separate-source-party', 'provisional', 'accepted', NULL, NULL, 'Resolved by new-separate-source-party. A new separate source party is not a verification of its registered legal identity; names do not authorise consolidation.'),
	('90a327f9-e225-4c7d-95fd-2fa6f25cac65', '28900ffe-c40c-40c7-ad03-5d286e7ebdc5', 'legal_entity', 'bc20aa22-6e2b-4c8e-b8ae-484a6e55067b', 'companies-house-number', 'high', 'accepted', NULL, NULL, 'Resolved by companies-house-number. A new separate source party is not a verification of its registered legal identity; names do not authorise consolidation.'),
	('77cf18e8-e493-4ca3-a1c1-35d28f0ecec0', 'a3be0df1-1543-42ca-bddb-d4a284d0d322', 'legal_entity', 'bc20aa22-6e2b-4c8e-b8ae-484a6e55067b', 'ukprn', 'high', 'accepted', NULL, NULL, 'Resolved by ukprn. A new separate source party is not a verification of its registered legal identity; names do not authorise consolidation.'),
	('5786c8c5-e1f9-45cc-95fe-9754133cdeac', '6d794554-cac5-46a8-b636-106c37f99e74', 'legal_entity', '993b8053-8d32-4351-b6b0-49f343e58883', 'new-separate-source-party', 'provisional', 'accepted', NULL, NULL, 'Resolved by new-separate-source-party. A new separate source party is not a verification of its registered legal identity; names do not authorise consolidation.'),
	('b912ca02-a561-4cd2-991d-599f05c57c6a', '3b77b798-fa61-49e8-ac2c-fa67b716c9d6', 'legal_entity', '776a7bee-cbf4-48e8-ad8b-c2e1e3d79302', 'companies-house-number', 'high', 'accepted', NULL, NULL, 'Resolved by companies-house-number. A new separate source party is not a verification of its registered legal identity; names do not authorise consolidation.'),
	('52ce05f4-22c1-4642-b335-3318cc9278a2', '46ede70b-0106-4914-a2aa-a943d43cd2d6', 'legal_entity', 'e1f70fda-02c0-4fab-92be-ff514f767637', 'shared-identifiers-and-explicit-sat-mat-transition', 'high', 'accepted', NULL, NULL, 'T3: shared Group ID TR00009, UKPRN 10059335 and incorporation date; Companies House 07795736 supplied by MAT 20364. GroupRelationsLink 547 (2055 -> 20364, 1M) and 548 (20364 -> 2055, 1S) evidence classification transition 2021-03-30. Source GroupLink 4778 supplies the historical SAT responsibility start 2011-11-01; GroupLink 34277 supplies the current MAT responsibility start 2021-03-30. One continuing legal entity and role; separate SAT and MAT responsibilities. SAT responsibility end and initial SAT classification start unknown; classification dates are not copied into responsibility boundaries.'),
	('bfd621bf-5c10-4e8b-a847-8c7996502b2d', 'eceb4294-06fe-43b0-9730-15157fbe675e', 'legal_entity', 'e1f70fda-02c0-4fab-92be-ff514f767637', 'shared-identifiers-and-explicit-sat-mat-transition', 'high', 'accepted', NULL, NULL, 'T3: shared Group ID TR00009, UKPRN 10059335 and incorporation date; Companies House 07795736 supplied by MAT 20364. GroupRelationsLink 547 (2055 -> 20364, 1M) and 548 (20364 -> 2055, 1S) evidence classification transition 2021-03-30. Source GroupLink 4778 supplies the historical SAT responsibility start 2011-11-01; GroupLink 34277 supplies the current MAT responsibility start 2021-03-30. One continuing legal entity and role; separate SAT and MAT responsibilities. SAT responsibility end and initial SAT classification start unknown; classification dates are not copied into responsibility boundaries.'),
	('e2cf2370-d9a4-4265-b358-89a6e0131cfb', '87cf4d6f-6972-4355-a9d3-2c1218a88c62', 'legal_entity', '43e519c2-8b3e-473e-990d-583f4a500402', 'new-separate-source-party', 'provisional', 'accepted', NULL, NULL, 'Resolved by new-separate-source-party. A new separate source party is not a verification of its registered legal identity; names do not authorise consolidation.'),
	('e81c281b-e48f-4f4f-8447-a2f52139068f', '66d6fa0b-c6c3-4df7-9f2e-e5a40e3ca543', 'person', 'c11a6d35-1f58-413f-8339-150314652533', 'reviewed-person-sponsor', 'reviewed', 'accepted', NULL, NULL, 'T7 reviewed person sponsor: Charles Dunstone. Fulwood Academy identifies Sir Charles as its sponsor and states personal funding: https://www.fulwoodacademy.co.uk/page/?pid=53&title=Welcome+from+the+Sponsor. GroupLink 3648: archived=0; effectiveDate=2009-09-01. Source group openDate=1900-01-01 rejected as placeholder; role start unknown. No Companies House number applies to the person; do not merge with trust UID 3147.'),
	('5d99f8be-d2ab-464f-9b92-c6e518de29e8', 'e0e252ab-ec9d-4e7d-ada8-c3d8c8cb475e', 'legal_entity', '7eadb097-76e1-48da-aeb2-9268c1dbb859', 'companies-house-number', 'high', 'accepted', NULL, NULL, 'Resolved by companies-house-number. A new separate source party is not a verification of its registered legal identity; names do not authorise consolidation.'),
	('e396fdb2-cae6-41c1-9219-7abdd86cd574', '72cee5b7-3c0d-4d83-a3d7-3a5f075bf20e', 'legal_entity', '5be037f1-12fc-4b40-829c-4135c96fc783', 'controlled-reviewed-proprietor', 'accepted-fixture-assumption', 'accepted', '2026-10-07 09:41:01.313777+01', 'T9 accepted fixture decision', 'T9 accepted proprietor-identity assumption: both selected extract assertions resolve to one body; local proprietor records are obfuscated, not evidence of Acorn''s legal identity or ownership.'),
	('2eb64172-4bd9-4f15-9f80-326688487ef7', 'a63b71ac-e82d-47a7-a6de-1d70ac90f665', 'legal_entity', '5be037f1-12fc-4b40-829c-4135c96fc783', 'controlled-reviewed-proprietor', 'accepted-fixture-assumption', 'accepted', '2026-10-07 09:41:01.313777+01', 'T9 accepted fixture decision', 'T9 accepted proprietor-identity assumption: both selected extract assertions resolve to one body; local proprietor records are obfuscated, not evidence of Acorn''s legal identity or ownership.');


--
-- Data for Name: organisation_group_member_evidence; Type: TABLE DATA; Schema: migration; Owner: -
--

INSERT INTO migration.organisation_group_member_evidence (evidence_id, organisation_group_member_id, source_record_id, first_observed_date, left_date_basis, inference_rule, review_status, notes) VALUES
	('2b3319fa-b64d-4fc5-b1e6-2f30bbaacb98', 'd87ed95a-1b98-46b3-a053-a308d9638e24', 'cbdbf656-3880-48f3-badf-f2a480c8b44d', NULL, NULL, NULL, 'accepted', 'Source GroupLink 1928: archived=0; linkType=HARD; joined date from effectiveDate; leaving date unknown.'),
	('ae59057f-bcd4-4ef1-8fdd-fc60ece75743', '5c1b435c-3a71-47a8-9a38-6be29554263f', 'ef318b1f-9e5b-4d1e-9cee-3b5121f91c70', NULL, NULL, NULL, 'accepted', 'Source GroupLink 1929: archived=0; linkType=HARD; joined date from effectiveDate; leaving date unknown.'),
	('93faa647-d83d-43eb-a4b7-7d4d6d82bc2d', '477a867d-afd6-43b2-9455-d1c1915a30ca', '4ce8f234-b726-4bb1-b4b4-0af744f56153', NULL, NULL, NULL, 'accepted', 'Source GroupLink 25390: archived=0; ccLinkType=STANDARD; joined date from effectiveDate; leaving date unknown.'),
	('c1ce1c0e-7c9d-49a6-8c31-30b3ef97354d', '4cd9d932-cc5b-49c5-aeec-409d34e4babe', 'e55a7389-13de-4a8c-ab82-3ffe2a9c9d54', NULL, NULL, NULL, 'accepted', 'Source GroupLink 25397: archived=0; ccLinkType=STANDARD; joined date from effectiveDate; leaving date unknown.'),
	('fa1b171e-eec3-40f4-8bd5-f843b43dda3f', '53a879ae-59cd-4112-9010-31073581c9f8', '625461ae-0874-4fea-9abf-e0a93bb7876a', NULL, NULL, NULL, 'accepted', 'Source GroupLink 25392: archived=0; ccLinkType=STANDARD; joined date from effectiveDate; leaving date unknown.'),
	('9b5bc0f8-a150-40ce-81f0-646c35b7c160', 'fbbfcc89-c668-4836-8f29-2c925259d4b5', '34f60aee-8ec1-493f-90b1-54a3a2cca6ee', NULL, NULL, NULL, 'accepted', 'Source GroupLink 25394: archived=0; ccLinkType=STANDARD; joined date from effectiveDate; leaving date unknown.'),
	('628268ab-202f-446e-bb22-8ef1c8892f5b', '23511f8c-2411-4de2-a520-d3ec8079831f', 'b6bd90e9-2474-4c8d-89de-da0376a535f8', NULL, NULL, NULL, 'accepted', 'Source GroupLink 25395: archived=0; ccLinkType=STANDARD; joined date from effectiveDate; leaving date unknown.'),
	('b98bb25f-89b7-431f-bde6-4110a9eecdee', '2e21c189-8c08-4de7-abe0-73fe304c6b40', '869fdb6c-f4d3-4803-a5c2-7f0b1353d06b', NULL, NULL, NULL, 'accepted', 'Source GroupLink 25393: archived=0; ccLinkType=STANDARD; joined date from effectiveDate; leaving date unknown.'),
	('b2ba4273-8dea-4c8e-8744-76c54826ba58', '86f7550b-4c7b-45b4-a76e-1a2285936bed', '09eb7b6b-828d-4258-80c3-0222268c05e7', NULL, NULL, NULL, 'accepted', 'Source GroupLink 25391: archived=0; ccLinkType=LEAD; joined date from effectiveDate; leaving date unknown.'),
	('6455309d-d70c-42f7-a8f0-a5778f070e87', '362f5d75-f2b2-477b-95f0-5f899529ac82', 'e5c26c45-2005-45ca-bd16-e6fd6fd9142a', NULL, NULL, NULL, 'accepted', 'Source GroupLink 25396: archived=0; ccLinkType=STANDARD; joined date from effectiveDate; leaving date unknown.'),
	('272d9069-ab40-4d1b-a752-4589e29ebd27', '9ba31e58-b922-4748-a393-52fcd64447be', 'aa7dbf65-131b-402f-9576-267448a136d1', NULL, NULL, NULL, 'accepted', 'Source GroupLink 25398: archived=0; ccLinkType=STANDARD; joined date from effectiveDate; leaving date unknown.');


--
-- PostgreSQL database dump complete
--

\unrestrict Vln2OUxqAC8wIMrE6hBhggM0schp490klIFpouKpY0Hhx9UYARRAl4MVs3OgQJJ

