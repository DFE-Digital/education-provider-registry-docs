--
-- PostgreSQL database dump
--

\restrict 6GjFmBFUdYayXm1gC5XR2mlIMVVdpbGPdduo0ypsK0XTfrHKIu7h7BLghYshPCf

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
	('0b27d041-7050-4f13-9b0e-a276bc101aee', 'establishment-rebuild', 'GIAS BAU', 'gias_bau_test_local', '2026-10-08', '2026-10-08 12:30:07.207798+01', '2026-10-08 12:30:56.342993+01', 'completed', 'establishment-party-responsibility-v2', NULL);


--
-- Data for Name: source_snapshot; Type: TABLE DATA; Schema: migration; Owner: -
--

INSERT INTO migration.source_snapshot (source_snapshot_id, migration_run_id, source_system, source_database, snapshot_date, extract_name, created_at) VALUES
	('fd9f2e97-7ebe-462f-88aa-fb4db969d33f', '0b27d041-7050-4f13-9b0e-a276bc101aee', 'GIAS BAU', 'gias_bau_test_local', '2026-10-08', 'establishment-party-136102-2777', '2026-10-08 12:30:31.490752+01'),
	('ebb7f11a-221e-48b7-8f7c-02fb7bbb5504', '0b27d041-7050-4f13-9b0e-a276bc101aee', 'GIAS BAU', 'gias_bau_test_local', '2026-10-08', 'establishment-party-136102-2779', '2026-10-08 12:30:32.538585+01'),
	('9678e246-e755-4381-bb56-86603cb16ea1', '0b27d041-7050-4f13-9b0e-a276bc101aee', 'GIAS BAU', 'gias_bau_test_local', '2026-10-08', 'establishment-party-136102-4949', '2026-10-08 12:30:33.241493+01'),
	('541cc646-29b0-467f-82f9-aabb65f2dc42', '0b27d041-7050-4f13-9b0e-a276bc101aee', 'GIAS BAU', 'gias_bau_test_local', '2026-10-08', 'establishment-party-134314-23869', '2026-10-08 12:30:33.952344+01'),
	('29072d8e-07db-44d3-af9c-0c5b28b1eac4', '0b27d041-7050-4f13-9b0e-a276bc101aee', 'GIAS BAU', 'gias_bau_test_local', '2026-10-08', 'establishment-party-134314-4737', '2026-10-08 12:30:34.567575+01'),
	('33ec154f-8e40-4dbe-9972-f1346b3423b8', '0b27d041-7050-4f13-9b0e-a276bc101aee', 'GIAS BAU', 'gias_bau_test_local', '2026-10-08', 'establishment-party-134314-2914', '2026-10-08 12:30:35.422209+01'),
	('4612c7ce-a251-4aad-ab3e-06add1fb8d8c', '0b27d041-7050-4f13-9b0e-a276bc101aee', 'GIAS BAU', 'gias_bau_test_local', '2026-10-08', 'establishment-party-135905-3839', '2026-10-08 12:30:36.073598+01'),
	('8a0e102a-d878-4cd7-8b09-42678ef471b9', '0b27d041-7050-4f13-9b0e-a276bc101aee', 'GIAS BAU', 'gias_bau_test_local', '2026-10-08', 'establishment-party-137603-2055', '2026-10-08 12:30:36.557855+01'),
	('214313af-db8b-4847-8f3e-a6fcbc3e8eba', '0b27d041-7050-4f13-9b0e-a276bc101aee', 'GIAS BAU', 'gias_bau_test_local', '2026-10-08', 'establishment-party-137603-20364', '2026-10-08 12:30:37.22592+01'),
	('33235bc8-79ea-489a-997b-75291dcd3b07', '0b27d041-7050-4f13-9b0e-a276bc101aee', 'GIAS BAU', 'gias_bau_test_local', '2026-10-08', 'establishment-party-132141-1337', '2026-10-08 12:30:37.866886+01'),
	('335782c6-70ca-47c4-a0cc-a43131c204e0', '0b27d041-7050-4f13-9b0e-a276bc101aee', 'GIAS BAU', 'gias_bau_test_local', '2026-10-08', 'establishment-party-135936-2613', '2026-10-08 12:30:38.373145+01'),
	('ff25733e-615c-47ac-a7ba-56c4fc0f5b9a', '0b27d041-7050-4f13-9b0e-a276bc101aee', 'GIAS BAU', 'gias_bau_test_local', '2026-10-08', 'establishment-party-135936-3147', '2026-10-08 12:30:38.949096+01'),
	('4c3d5275-c7b7-4c41-a25f-687d6c9c6306', '0b27d041-7050-4f13-9b0e-a276bc101aee', 'GIAS BAU', 'gias_bau_test_local', '2026-10-08', 'organisation-group-1809', '2026-10-08 12:30:39.445735+01'),
	('883f22fb-c922-4ec6-99ce-a3070e96dae1', '0b27d041-7050-4f13-9b0e-a276bc101aee', 'GIAS BAU', 'gias_bau_test_local', '2026-10-08', 'organisation-group-86052', '2026-10-08 12:30:39.879034+01'),
	('08889c97-3da1-401b-8509-5e9d05ceb0d7', '0b27d041-7050-4f13-9b0e-a276bc101aee', 'GIAS public extract', NULL, '2026-06-16', 'docs/data/extract-data/establishment-fields/edubasealldata20260616.csv', '2026-10-08 12:30:46.593622+01'),
	('a20503e5-6cdb-4e66-b441-39f422ac940a', '0b27d041-7050-4f13-9b0e-a276bc101aee', 'GIAS BAU', 'gias_bau_test_local', '2026-10-08', 'T9-local-proprietor-context', '2026-10-08 12:30:46.593622+01');


--
-- Data for Name: source_record; Type: TABLE DATA; Schema: migration; Owner: -
--

INSERT INTO migration.source_record (source_record_id, source_snapshot_id, source_table, source_key, source_group_id, source_urn, source_row_hash) VALUES
	('37e757c5-9252-4e64-9057-3022860627c9', 'fd9f2e97-7ebe-462f-88aa-fb4db969d33f', 'dbo.EstablishmentGroup/GroupLink', '2777:136102', '2777', 136102, NULL),
	('502de28d-132c-4b15-a21f-7b0b3f7d66fe', 'ebb7f11a-221e-48b7-8f7c-02fb7bbb5504', 'dbo.EstablishmentGroup/GroupLink', '2779:136102', '2779', 136102, NULL),
	('79f7a4fb-7b58-4e9c-8714-ef204972eb8f', '9678e246-e755-4381-bb56-86603cb16ea1', 'dbo.EstablishmentGroup/GroupLink', '4949:136102', '4949', 136102, NULL),
	('e0ed0e04-005c-4650-a2d0-7bdb13a54170', '541cc646-29b0-467f-82f9-aabb65f2dc42', 'dbo.EstablishmentGroup/GroupLink', '23869:134314', '23869', 134314, NULL),
	('f97d8c74-858d-4874-8390-478bb8a5ae61', '29072d8e-07db-44d3-af9c-0c5b28b1eac4', 'dbo.EstablishmentGroup/GroupLink', '4737:134314', '4737', 134314, NULL),
	('69967c49-81bb-41a1-8a22-a34cda8b24bc', '33ec154f-8e40-4dbe-9972-f1346b3423b8', 'dbo.EstablishmentGroup/GroupLink', '2914:134314', '2914', 134314, NULL),
	('5709285f-eb32-4570-a2f4-80210ebd8506', '4612c7ce-a251-4aad-ab3e-06add1fb8d8c', 'dbo.EstablishmentGroup/GroupLink', '3839:135905', '3839', 135905, NULL),
	('dd8b9d20-61d8-494e-9ff3-25bce413241e', '8a0e102a-d878-4cd7-8b09-42678ef471b9', 'dbo.EstablishmentGroup/GroupLink', '2055:137603', '2055', 137603, NULL),
	('622936a8-c484-420c-9f63-e58df0ccee5f', '214313af-db8b-4847-8f3e-a6fcbc3e8eba', 'dbo.EstablishmentGroup/GroupLink', '20364:137603', '20364', 137603, NULL),
	('e0d3090f-a2d5-4c83-a292-700e768a2ccc', '33235bc8-79ea-489a-997b-75291dcd3b07', 'dbo.EstablishmentGroup/GroupLink', '1337:132141', '1337', 132141, NULL),
	('8f6c9db7-e104-4cc5-a433-b3bd518e2ccf', '335782c6-70ca-47c4-a0cc-a43131c204e0', 'dbo.EstablishmentGroup/GroupLink', '2613:135936', '2613', 135936, NULL),
	('05d07cd5-7775-4de9-bfd2-75d2ab56da4a', 'ff25733e-615c-47ac-a7ba-56c4fc0f5b9a', 'dbo.EstablishmentGroup/GroupLink', '3147:135936', '3147', 135936, NULL),
	('7c81f86d-3b10-4938-9706-4718fe5953d8', '4c3d5275-c7b7-4c41-a25f-687d6c9c6306', 'dbo.EstablishmentGroup/GroupLink', '1928', '1809', 109443, NULL),
	('3bd73bab-f11a-490c-af60-d3a3a228e3ba', '4c3d5275-c7b7-4c41-a25f-687d6c9c6306', 'dbo.EstablishmentGroup/GroupLink', '1929', '1809', 109613, NULL),
	('9b193a50-5d64-48ea-9498-435a818d9014', '883f22fb-c922-4ec6-99ce-a3070e96dae1', 'dbo.EstablishmentGroup/GroupLink', '25390', '86052', 20338, NULL),
	('645e81e1-05e6-441f-833a-d410d4690627', '883f22fb-c922-4ec6-99ce-a3070e96dae1', 'dbo.EstablishmentGroup/GroupLink', '25391', '86052', 20549, NULL),
	('41719d27-9ae9-4edd-9793-87e57a210cf6', '883f22fb-c922-4ec6-99ce-a3070e96dae1', 'dbo.EstablishmentGroup/GroupLink', '25392', '86052', 20614, NULL),
	('a25cbde3-6868-4f88-b7b6-7a63750e967c', '883f22fb-c922-4ec6-99ce-a3070e96dae1', 'dbo.EstablishmentGroup/GroupLink', '25395', '86052', 21363, NULL),
	('508872db-d4ff-492f-9d05-c80f8a19e11b', '883f22fb-c922-4ec6-99ce-a3070e96dae1', 'dbo.EstablishmentGroup/GroupLink', '25396', '86052', 22422, NULL),
	('a39d9251-a23e-44d4-abf1-b1de72e5c545', '883f22fb-c922-4ec6-99ce-a3070e96dae1', 'dbo.EstablishmentGroup/GroupLink', '25394', '86052', 22459, NULL),
	('cd3328ef-ec49-499d-aeff-31757e4a7552', '883f22fb-c922-4ec6-99ce-a3070e96dae1', 'dbo.EstablishmentGroup/GroupLink', '25397', '86052', 22975, NULL),
	('ec101e31-18dd-4014-9f42-2933a7996a1f', '883f22fb-c922-4ec6-99ce-a3070e96dae1', 'dbo.EstablishmentGroup/GroupLink', '25393', '86052', 23004, NULL),
	('9de70b87-09e3-4623-8b29-7088a3c5fb39', '883f22fb-c922-4ec6-99ce-a3070e96dae1', 'dbo.EstablishmentGroup/GroupLink', '25398', '86052', 23122, NULL),
	('07e1f80c-d6d9-453a-a960-73d399087722', '08889c97-3da1-401b-8509-5e9d05ceb0d7', 'Establishment extract PropsName', '112461', NULL, 112461, '10dc16379435aa61d05c534771c10ed9'),
	('aace775d-b918-444a-a81f-f5d2546fa3a8', '08889c97-3da1-401b-8509-5e9d05ceb0d7', 'Establishment extract PropsName', '119009', NULL, 119009, '5aa20f3444180e744e297a5fa69e1bee'),
	('13e9139a-bb85-446e-8d5c-ac3da4403fc5', 'a20503e5-6cdb-4e66-b441-39f422ac940a', 'dbo.IndependentSchools (context only)', '112461', NULL, 112461, 'a1cc1f32cf7cafe4e71155e65f89826d'),
	('af11ea35-3679-4cda-80d9-ca0d7bdcd7b0', 'a20503e5-6cdb-4e66-b441-39f422ac940a', 'dbo.IndependentSchools (context only)', '119009', NULL, 119009, '40d707e0a0c2f2c8e28582e3845f5dd2');


--
-- Data for Name: academy_trust_classification_evidence; Type: TABLE DATA; Schema: migration; Owner: -
--

INSERT INTO migration.academy_trust_classification_evidence (evidence_id, academy_trust_classification_id, source_record_id, assertion_rule, review_status, notes) VALUES
	('42cbaa72-2162-4489-89f4-cac6a072b2f0', 'b2491a5b-c338-4a42-afba-101da4c44772', '37e757c5-9252-4e64-9057-3022860627c9', 'MR001', 'accepted', NULL),
	('e6d0f729-a0b4-4799-8dd3-9a7540e926ad', '38e41c55-9024-49b4-851f-732aee5d6d7c', '502de28d-132c-4b15-a21f-7b0b3f7d66fe', 'MR005', 'accepted', NULL),
	('2adc9eca-fd19-4ea5-bf0b-8f875774975a', '3f473cee-c5f6-46f0-9b35-139a7e4e5122', 'e0ed0e04-005c-4650-a2d0-7bdb13a54170', 'MR001', 'accepted', NULL),
	('9395cccc-ccf1-4298-b709-a2cb24714fa6', '1327f1ea-4b85-4844-848f-b0497ad058ca', '5709285f-eb32-4570-a2f4-80210ebd8506', 'MR005', 'accepted', NULL),
	('8892ea39-61eb-443b-aaa1-545d2f62794a', '2ccae914-79b2-44aa-ba92-1ae14963fffe', 'dd8b9d20-61d8-494e-9ff3-25bce413241e', 'MR005', 'accepted', 'T3: shared Group ID TR00009, UKPRN 10059335 and incorporation date; Companies House 07795736 supplied by MAT 20364. GroupRelationsLink 547 (2055 -> 20364, 1M) and 548 (20364 -> 2055, 1S) evidence classification transition 2021-03-30. Source GroupLink 4778 supplies the historical SAT responsibility start 2011-11-01; GroupLink 34277 supplies the current MAT responsibility start 2021-03-30. One continuing legal entity and role; separate SAT and MAT responsibilities. SAT responsibility end and initial SAT classification start unknown; classification dates are not copied into responsibility boundaries.'),
	('3366f5a7-e2f1-43e7-ba6a-99603af1a0ef', 'b3848bf5-c4ee-4dde-bd16-faf11e556301', '622936a8-c484-420c-9f63-e58df0ccee5f', 'MR001', 'accepted', 'T3: shared Group ID TR00009, UKPRN 10059335 and incorporation date; Companies House 07795736 supplied by MAT 20364. GroupRelationsLink 547 (2055 -> 20364, 1M) and 548 (20364 -> 2055, 1S) evidence classification transition 2021-03-30. Source GroupLink 4778 supplies the historical SAT responsibility start 2011-11-01; GroupLink 34277 supplies the current MAT responsibility start 2021-03-30. One continuing legal entity and role; separate SAT and MAT responsibilities. SAT responsibility end and initial SAT classification start unknown; classification dates are not copied into responsibility boundaries.'),
	('0f5fb75e-63cc-492c-99b0-9a833023703a', '53cc3ed2-ef3a-44b3-94c2-d9940c668d75', '05d07cd5-7775-4de9-bfd2-75d2ab56da4a', 'MR001', 'accepted', NULL);


--
-- Data for Name: establishment_party_role_evidence; Type: TABLE DATA; Schema: migration; Owner: -
--

INSERT INTO migration.establishment_party_role_evidence (evidence_id, establishment_party_role_id, source_record_id, first_observed_date, end_date_basis, inference_rule, review_status, notes) VALUES
	('a76f170f-7a35-47e0-a4c8-6ba48b90b446', '47b1c284-e194-4860-be2a-5edcd2b97378', '37e757c5-9252-4e64-9057-3022860627c9', NULL, NULL, NULL, 'accepted', NULL),
	('a27431b9-4ccd-476b-a383-e560999fb005', '31b01e1c-0e81-4700-bc07-d283ea55f57b', '502de28d-132c-4b15-a21f-7b0b3f7d66fe', NULL, NULL, NULL, 'accepted', NULL),
	('647cd0e6-f5aa-4d5c-a5ea-1d2e58a9f210', '83ba124e-cebd-43dd-8d15-6fa978dce414', '79f7a4fb-7b58-4e9c-8714-ef204972eb8f', NULL, NULL, NULL, 'accepted', NULL),
	('63d6767e-6b00-4dc9-8ccf-02e622f82be5', 'cde2c1df-2e9d-45c5-80e5-76e088687325', 'e0ed0e04-005c-4650-a2d0-7bdb13a54170', NULL, NULL, NULL, 'accepted', NULL),
	('c21ceb12-5c4e-44b3-af48-75168a8c6206', 'cde2c1df-2e9d-45c5-80e5-76e088687325', 'f97d8c74-858d-4874-8390-478bb8a5ae61', NULL, NULL, NULL, 'accepted', NULL),
	('0cf23957-feae-4e12-a663-57ca90d7cc70', '79c093ac-2395-4575-bbaf-c330cfb2321c', '69967c49-81bb-41a1-8a22-a34cda8b24bc', NULL, NULL, NULL, 'accepted', NULL),
	('cf1ac8f3-d55c-4f69-83b9-1bba48182de6', '6951b746-42ff-4ce0-99f0-00b62a043400', '5709285f-eb32-4570-a2f4-80210ebd8506', NULL, 'evidenced', NULL, 'accepted', NULL),
	('a849c70a-7ff8-4d26-b808-e2f0cf374be8', '35bbd698-da03-4404-967a-3beace540afe', 'dd8b9d20-61d8-494e-9ff3-25bce413241e', NULL, NULL, NULL, 'accepted', 'T3: shared Group ID TR00009, UKPRN 10059335 and incorporation date; Companies House 07795736 supplied by MAT 20364. GroupRelationsLink 547 (2055 -> 20364, 1M) and 548 (20364 -> 2055, 1S) evidence classification transition 2021-03-30. Source GroupLink 4778 supplies the historical SAT responsibility start 2011-11-01; GroupLink 34277 supplies the current MAT responsibility start 2021-03-30. One continuing legal entity and role; separate SAT and MAT responsibilities. SAT responsibility end and initial SAT classification start unknown; classification dates are not copied into responsibility boundaries.'),
	('eeb5e84a-4bf7-4ba3-89a9-3959c3a2e3ac', '35bbd698-da03-4404-967a-3beace540afe', '622936a8-c484-420c-9f63-e58df0ccee5f', NULL, NULL, NULL, 'accepted', 'T3: shared Group ID TR00009, UKPRN 10059335 and incorporation date; Companies House 07795736 supplied by MAT 20364. GroupRelationsLink 547 (2055 -> 20364, 1M) and 548 (20364 -> 2055, 1S) evidence classification transition 2021-03-30. Source GroupLink 4778 supplies the historical SAT responsibility start 2011-11-01; GroupLink 34277 supplies the current MAT responsibility start 2021-03-30. One continuing legal entity and role; separate SAT and MAT responsibilities. SAT responsibility end and initial SAT classification start unknown; classification dates are not copied into responsibility boundaries.'),
	('ea2e637d-02d2-4b09-bceb-7901ad005cea', '530d5251-739b-4b7d-b5d0-8d6ea8d72b41', 'e0d3090f-a2d5-4c83-a292-700e768a2ccc', '2026-10-08', NULL, NULL, 'accepted', 'Source GroupLink 1029: archived=0; source group openDate=2010-09-03; role start unknown; group openDate is not role start or incorporation; legal identity provisional.'),
	('b01d80bf-50ee-4437-8dda-5bbb0a6e0beb', '86096d21-1611-42fc-8ef9-6c98e4de894e', '8f6c9db7-e104-4cc5-a433-b3bd518e2ccf', '2026-10-08', NULL, NULL, 'accepted', 'T7 reviewed person sponsor: Charles Dunstone. Fulwood Academy identifies Sir Charles as its sponsor and states personal funding: https://www.fulwoodacademy.co.uk/page/?pid=53&title=Welcome+from+the+Sponsor. GroupLink 3648: archived=0; effectiveDate=2009-09-01. Source group openDate=1900-01-01 rejected as placeholder; role start unknown. No Companies House number applies to the person; do not merge with trust UID 3147.'),
	('370bdefa-c2ff-4c66-9061-e7cdbb3ace61', '436e1160-f46f-4598-9ea1-95d51299e0ee', '05d07cd5-7775-4de9-bfd2-75d2ab56da4a', NULL, NULL, NULL, 'accepted', NULL);


--
-- Data for Name: establishment_responsibility_evidence; Type: TABLE DATA; Schema: migration; Owner: -
--

INSERT INTO migration.establishment_responsibility_evidence (evidence_id, establishment_responsibility_id, source_record_id, first_observed_date, end_date_basis, inference_rule, review_status, notes) VALUES
	('7b6c7817-bbb7-4ca4-a5d4-127031f38f3e', '1c991917-4026-4c1b-84b1-477930097f5d', '37e757c5-9252-4e64-9057-3022860627c9', NULL, NULL, NULL, 'accepted', NULL),
	('22af9210-3bae-4ff9-ae15-805ff7d8165a', '6512a851-c19f-46a1-ac1c-5c771a8de817', '502de28d-132c-4b15-a21f-7b0b3f7d66fe', NULL, NULL, NULL, 'accepted', NULL),
	('5b7b0dc2-73cb-4f38-9fc2-0cb371cbd200', '4a0465b7-2b13-4b00-81e1-098430dda624', '79f7a4fb-7b58-4e9c-8714-ef204972eb8f', NULL, NULL, NULL, 'accepted', NULL),
	('798f823e-d9b4-4684-8c53-fc3638c582a9', '2a4843bf-2164-4afa-942a-c0f0bf8bcaaf', 'e0ed0e04-005c-4650-a2d0-7bdb13a54170', NULL, NULL, NULL, 'accepted', NULL),
	('7e422cfa-c624-4db8-a38c-822630201523', 'd8f4a4df-64ca-410f-90e0-b7f34f3e0b23', 'f97d8c74-858d-4874-8390-478bb8a5ae61', NULL, NULL, NULL, 'accepted', NULL),
	('d473a495-20dd-4250-b891-7c650e3e731a', 'bb36455a-bedb-4ac4-ac14-7f4681178aea', '69967c49-81bb-41a1-8a22-a34cda8b24bc', NULL, NULL, NULL, 'accepted', NULL),
	('2e9eab1d-d1f3-4ef0-b8c2-7f95733851bd', 'f2b8fc67-addd-4a55-8a30-119f0108fae4', '5709285f-eb32-4570-a2f4-80210ebd8506', NULL, 'inferred', 'Responsibility end date inferred from the source establishment closure date.', 'accepted', NULL),
	('c2d211f3-9b55-4541-a245-c0de36a5fc96', '0409cd84-38c3-4da1-8604-d5e5affba433', 'dd8b9d20-61d8-494e-9ff3-25bce413241e', NULL, NULL, NULL, 'accepted', 'T3: shared Group ID TR00009, UKPRN 10059335 and incorporation date; Companies House 07795736 supplied by MAT 20364. GroupRelationsLink 547 (2055 -> 20364, 1M) and 548 (20364 -> 2055, 1S) evidence classification transition 2021-03-30. Source GroupLink 4778 supplies the historical SAT responsibility start 2011-11-01; GroupLink 34277 supplies the current MAT responsibility start 2021-03-30. One continuing legal entity and role; separate SAT and MAT responsibilities. SAT responsibility end and initial SAT classification start unknown; classification dates are not copied into responsibility boundaries.'),
	('f019b432-32b7-4175-a2ce-f5c8327b6260', 'c5b72834-ddee-49d9-9bec-b7f062659c68', '622936a8-c484-420c-9f63-e58df0ccee5f', NULL, NULL, NULL, 'accepted', 'T3: shared Group ID TR00009, UKPRN 10059335 and incorporation date; Companies House 07795736 supplied by MAT 20364. GroupRelationsLink 547 (2055 -> 20364, 1M) and 548 (20364 -> 2055, 1S) evidence classification transition 2021-03-30. Source GroupLink 4778 supplies the historical SAT responsibility start 2011-11-01; GroupLink 34277 supplies the current MAT responsibility start 2021-03-30. One continuing legal entity and role; separate SAT and MAT responsibilities. SAT responsibility end and initial SAT classification start unknown; classification dates are not copied into responsibility boundaries.'),
	('78a5da6d-1beb-4ece-95cd-749b3328d3d6', 'e1bb39c9-9fcd-4746-a16d-5b202b69d6b4', 'e0d3090f-a2d5-4c83-a292-700e768a2ccc', NULL, NULL, NULL, 'accepted', 'Source GroupLink 1029: archived=0; responsibility start from effectiveDate; end unknown; source group openDate=2010-09-03; no name-based consolidation.'),
	('dc6f40af-186f-480b-a92e-4fe2a52df275', 'c637d49d-85b0-4cb7-96f5-ee9378fc53dd', '8f6c9db7-e104-4cc5-a433-b3bd518e2ccf', NULL, NULL, NULL, 'accepted', 'T7 reviewed person sponsor: Charles Dunstone. Fulwood Academy identifies Sir Charles as its sponsor and states personal funding: https://www.fulwoodacademy.co.uk/page/?pid=53&title=Welcome+from+the+Sponsor. GroupLink 3648: archived=0; effectiveDate=2009-09-01. Source group openDate=1900-01-01 rejected as placeholder; role start unknown. No Companies House number applies to the person; do not merge with trust UID 3147.'),
	('b689ba6b-65ed-4fcd-a442-9c49d4ba1d60', '0c73b959-8a5f-4783-9f49-4497e860f85d', '05d07cd5-7775-4de9-bfd2-75d2ab56da4a', NULL, NULL, NULL, 'accepted', NULL),
	('3e36318a-73cb-4ba1-b4de-f0439dba82e6', 'e0e23d24-5fe8-4330-a181-373c9e7ed21f', '13e9139a-bb85-446e-8d5c-ac3da4403fc5', NULL, NULL, NULL, 'accepted', 'Local context only: proprietorType_code=01; proprietor_type=Individual Proprietor; additional_proprietor_rows=1. Obfuscated local proprietor identity is not resolved to Acorn; additional rows not imported.'),
	('eddb2066-bb1f-47e5-8a3a-2c52c166647e', 'e0e23d24-5fe8-4330-a181-373c9e7ed21f', '07e1f80c-d6d9-453a-a960-73d399087722', '2026-06-16', NULL, NULL, 'accepted', 'Controlled accepted PropsName=Acorn Care and Education Ltd; T9 accepted proprietor-identity assumption: both selected extract assertions resolve to one body; local proprietor records are obfuscated, not evidence of Acorn''s legal identity or ownership. Responsibility dates unknown; legal form unverified; ownership not asserted.'),
	('c9192bfe-f878-4e5f-9ccf-83a7fd4b4440', '00d4e6df-99b0-4c61-b2f3-c04b96d35268', 'af11ea35-3679-4cda-80d9-ca0d7bdcd7b0', NULL, NULL, NULL, 'accepted', 'Local context only: proprietorType_code=01; proprietor_type=Individual Proprietor; additional_proprietor_rows=1. Obfuscated local proprietor identity is not resolved to Acorn; additional rows not imported.'),
	('bf2aea65-40ab-4879-98ba-bd695747702e', '00d4e6df-99b0-4c61-b2f3-c04b96d35268', 'aace775d-b918-444a-a81f-f5d2546fa3a8', '2026-06-16', NULL, NULL, 'accepted', 'Controlled accepted PropsName=Acorn Care and Education Ltd; T9 accepted proprietor-identity assumption: both selected extract assertions resolve to one body; local proprietor records are obfuscated, not evidence of Acorn''s legal identity or ownership. Responsibility dates unknown; legal form unverified; ownership not asserted.');


--
-- Data for Name: identity_resolution; Type: TABLE DATA; Schema: migration; Owner: -
--

INSERT INTO migration.identity_resolution (identity_resolution_id, source_record_id, target_entity_type, target_entity_id, resolution_method, confidence, decision_status, decided_at, decided_by, rationale) VALUES
	('1b375da8-e571-498a-b35e-d2a2ed886cfa', '37e757c5-9252-4e64-9057-3022860627c9', 'legal_entity', '6c6334c4-3ae9-4cbd-87e8-03bc47f3458f', 'companies-house-number', 'high', 'accepted', NULL, NULL, 'Resolved by companies-house-number. A new separate source party is not a verification of its registered legal identity; names do not authorise consolidation.'),
	('673dfff6-8770-4a70-b1b5-ff646e5d3694', '502de28d-132c-4b15-a21f-7b0b3f7d66fe', 'legal_entity', 'b8a3c074-9870-4b43-b3e1-3ba90017f1a2', 'companies-house-number', 'high', 'accepted', NULL, NULL, 'Resolved by companies-house-number. A new separate source party is not a verification of its registered legal identity; names do not authorise consolidation.'),
	('7d2f13dc-c6fd-46a0-bae4-74405a6e08ae', '79f7a4fb-7b58-4e9c-8714-ef204972eb8f', 'legal_entity', '5355748e-57d2-460c-a10f-6cd9c01d188e', 'new-separate-source-party', 'provisional', 'accepted', NULL, NULL, 'Resolved by new-separate-source-party. A new separate source party is not a verification of its registered legal identity; names do not authorise consolidation.'),
	('e4a799ff-9a57-404d-91cf-6a003f2e426b', 'e0ed0e04-005c-4650-a2d0-7bdb13a54170', 'legal_entity', '9c5c38c8-c175-4313-9e0b-96d909bd10c7', 'companies-house-number', 'high', 'accepted', NULL, NULL, 'Resolved by companies-house-number. A new separate source party is not a verification of its registered legal identity; names do not authorise consolidation.'),
	('b9aed1ea-1bf6-40a3-b1aa-83b3a6a56190', 'f97d8c74-858d-4874-8390-478bb8a5ae61', 'legal_entity', '9c5c38c8-c175-4313-9e0b-96d909bd10c7', 'ukprn', 'high', 'accepted', NULL, NULL, 'Resolved by ukprn. A new separate source party is not a verification of its registered legal identity; names do not authorise consolidation.'),
	('18e2d6c4-d410-4b78-b3ab-f6dcd49f2792', '69967c49-81bb-41a1-8a22-a34cda8b24bc', 'legal_entity', '55f19c2d-eab1-4a54-a154-4c5d7752f2cb', 'new-separate-source-party', 'provisional', 'accepted', NULL, NULL, 'Resolved by new-separate-source-party. A new separate source party is not a verification of its registered legal identity; names do not authorise consolidation.'),
	('28518e5b-5f65-47a2-8e4c-546f69367f9b', '5709285f-eb32-4570-a2f4-80210ebd8506', 'legal_entity', 'd261dcca-92e3-46a0-a927-c871901d84cd', 'companies-house-number', 'high', 'accepted', NULL, NULL, 'Resolved by companies-house-number. A new separate source party is not a verification of its registered legal identity; names do not authorise consolidation.'),
	('80b8b624-6873-4945-bc98-82d04c37946c', 'dd8b9d20-61d8-494e-9ff3-25bce413241e', 'legal_entity', '4f28bece-75ed-4e30-a04e-f963e3e13ce9', 'shared-identifiers-and-explicit-sat-mat-transition', 'high', 'accepted', NULL, NULL, 'T3: shared Group ID TR00009, UKPRN 10059335 and incorporation date; Companies House 07795736 supplied by MAT 20364. GroupRelationsLink 547 (2055 -> 20364, 1M) and 548 (20364 -> 2055, 1S) evidence classification transition 2021-03-30. Source GroupLink 4778 supplies the historical SAT responsibility start 2011-11-01; GroupLink 34277 supplies the current MAT responsibility start 2021-03-30. One continuing legal entity and role; separate SAT and MAT responsibilities. SAT responsibility end and initial SAT classification start unknown; classification dates are not copied into responsibility boundaries.'),
	('cb14054c-bedc-4ea4-b75d-68109de6aa08', '622936a8-c484-420c-9f63-e58df0ccee5f', 'legal_entity', '4f28bece-75ed-4e30-a04e-f963e3e13ce9', 'shared-identifiers-and-explicit-sat-mat-transition', 'high', 'accepted', NULL, NULL, 'T3: shared Group ID TR00009, UKPRN 10059335 and incorporation date; Companies House 07795736 supplied by MAT 20364. GroupRelationsLink 547 (2055 -> 20364, 1M) and 548 (20364 -> 2055, 1S) evidence classification transition 2021-03-30. Source GroupLink 4778 supplies the historical SAT responsibility start 2011-11-01; GroupLink 34277 supplies the current MAT responsibility start 2021-03-30. One continuing legal entity and role; separate SAT and MAT responsibilities. SAT responsibility end and initial SAT classification start unknown; classification dates are not copied into responsibility boundaries.'),
	('2d0c66d3-4f67-4897-a159-ba227f09da7c', 'e0d3090f-a2d5-4c83-a292-700e768a2ccc', 'legal_entity', '560bdb6e-dd12-4b6a-bd25-2a1b7acf8209', 'new-separate-source-party', 'provisional', 'accepted', NULL, NULL, 'Resolved by new-separate-source-party. A new separate source party is not a verification of its registered legal identity; names do not authorise consolidation.'),
	('e76deb7b-eb73-42a2-afd2-1d94c7288d79', '8f6c9db7-e104-4cc5-a433-b3bd518e2ccf', 'person', '1af49f62-5f3e-419d-8f6b-51189a6e8515', 'reviewed-person-sponsor', 'reviewed', 'accepted', NULL, NULL, 'T7 reviewed person sponsor: Charles Dunstone. Fulwood Academy identifies Sir Charles as its sponsor and states personal funding: https://www.fulwoodacademy.co.uk/page/?pid=53&title=Welcome+from+the+Sponsor. GroupLink 3648: archived=0; effectiveDate=2009-09-01. Source group openDate=1900-01-01 rejected as placeholder; role start unknown. No Companies House number applies to the person; do not merge with trust UID 3147.'),
	('f41895b0-c86e-4d34-b31a-482a63c1c191', '05d07cd5-7775-4de9-bfd2-75d2ab56da4a', 'legal_entity', 'd63c950d-8f31-4540-8933-415fd3e0ddfe', 'companies-house-number', 'high', 'accepted', NULL, NULL, 'Resolved by companies-house-number. A new separate source party is not a verification of its registered legal identity; names do not authorise consolidation.'),
	('2173e5a8-5c4e-4128-8720-4343500cbeb9', '07e1f80c-d6d9-453a-a960-73d399087722', 'legal_entity', '5be037f1-12fc-4b40-829c-4135c96fc783', 'controlled-reviewed-proprietor', 'accepted-fixture-assumption', 'accepted', '2026-10-08 12:30:46.593622+01', 'T9 accepted fixture decision', 'T9 accepted proprietor-identity assumption: both selected extract assertions resolve to one body; local proprietor records are obfuscated, not evidence of Acorn''s legal identity or ownership.'),
	('3070ed09-4313-48d1-901c-3a88851e5afc', 'aace775d-b918-444a-a81f-f5d2546fa3a8', 'legal_entity', '5be037f1-12fc-4b40-829c-4135c96fc783', 'controlled-reviewed-proprietor', 'accepted-fixture-assumption', 'accepted', '2026-10-08 12:30:46.593622+01', 'T9 accepted fixture decision', 'T9 accepted proprietor-identity assumption: both selected extract assertions resolve to one body; local proprietor records are obfuscated, not evidence of Acorn''s legal identity or ownership.');


--
-- Data for Name: organisation_group_member_evidence; Type: TABLE DATA; Schema: migration; Owner: -
--

INSERT INTO migration.organisation_group_member_evidence (evidence_id, organisation_group_member_id, source_record_id, first_observed_date, left_date_basis, inference_rule, review_status, notes) VALUES
	('16b3fe1d-c9ed-41d9-b148-51fa926cae11', '15f7e109-803d-41fb-a27a-a9370fada8a3', '3bd73bab-f11a-490c-af60-d3a3a228e3ba', NULL, NULL, NULL, 'accepted', 'Source GroupLink 1929: archived=0; linkType=HARD; joined date from effectiveDate; leaving date unknown.'),
	('dd069380-41dd-487c-8efa-75cedd0ebf92', '7d3b281d-f779-4209-b164-2b444fc47c9a', '7c81f86d-3b10-4938-9706-4718fe5953d8', NULL, NULL, NULL, 'accepted', 'Source GroupLink 1928: archived=0; linkType=HARD; joined date from effectiveDate; leaving date unknown.'),
	('b9f1d1bc-eff6-4920-a3e6-d8d32db8b4e6', '91d780d6-ae99-44b4-b227-c6ede84636c5', 'cd3328ef-ec49-499d-aeff-31757e4a7552', NULL, NULL, NULL, 'accepted', 'Source GroupLink 25397: archived=0; ccLinkType=STANDARD; joined date from effectiveDate; leaving date unknown.'),
	('e6383b94-2fda-46c1-b3a6-ad82e7162ebe', 'b99f095c-5e50-4043-9f66-aa1672624cb7', 'a39d9251-a23e-44d4-abf1-b1de72e5c545', NULL, NULL, NULL, 'accepted', 'Source GroupLink 25394: archived=0; ccLinkType=STANDARD; joined date from effectiveDate; leaving date unknown.'),
	('c1c8103c-6da1-4e90-ad7f-f379f76affce', '7e2d84f2-f2d9-4209-8ef1-c02171df8eee', 'a25cbde3-6868-4f88-b7b6-7a63750e967c', NULL, NULL, NULL, 'accepted', 'Source GroupLink 25395: archived=0; ccLinkType=STANDARD; joined date from effectiveDate; leaving date unknown.'),
	('1a825466-7f41-4154-b9bc-1a4b689cadfc', '55dc60d7-3879-4a66-844a-1225b3fde4d6', '9b193a50-5d64-48ea-9498-435a818d9014', NULL, NULL, NULL, 'accepted', 'Source GroupLink 25390: archived=0; ccLinkType=STANDARD; joined date from effectiveDate; leaving date unknown.'),
	('de9613ce-62a2-4488-b4f1-fbb73bbd5435', '3d8518d3-8d60-43a4-87f0-470c003fb743', '645e81e1-05e6-441f-833a-d410d4690627', NULL, NULL, NULL, 'accepted', 'Source GroupLink 25391: archived=0; ccLinkType=LEAD; joined date from effectiveDate; leaving date unknown.'),
	('41929688-2893-4896-84c1-496d4a2be33e', 'cbd0c510-8c9d-4a25-a199-88192863d283', '41719d27-9ae9-4edd-9793-87e57a210cf6', NULL, NULL, NULL, 'accepted', 'Source GroupLink 25392: archived=0; ccLinkType=STANDARD; joined date from effectiveDate; leaving date unknown.'),
	('968a757d-31ec-4cd0-8d69-810ec25b9aea', '73be2939-76e1-490e-b17c-2f39099d8e39', '9de70b87-09e3-4623-8b29-7088a3c5fb39', NULL, NULL, NULL, 'accepted', 'Source GroupLink 25398: archived=0; ccLinkType=STANDARD; joined date from effectiveDate; leaving date unknown.'),
	('4d35278b-095b-473f-9f2e-009b18fbd1d3', 'fec328f9-a520-4f9e-adc9-822dfef79f10', 'ec101e31-18dd-4014-9f42-2933a7996a1f', NULL, NULL, NULL, 'accepted', 'Source GroupLink 25393: archived=0; ccLinkType=STANDARD; joined date from effectiveDate; leaving date unknown.'),
	('a83ca713-e388-47aa-be63-7da9837ed5c0', '30a2ea2c-49b7-4bb8-914e-c41ae7d25d7a', '508872db-d4ff-492f-9d05-c80f8a19e11b', NULL, NULL, NULL, 'accepted', 'Source GroupLink 25396: archived=0; ccLinkType=STANDARD; joined date from effectiveDate; leaving date unknown.');


--
-- PostgreSQL database dump complete
--

\unrestrict 6GjFmBFUdYayXm1gC5XR2mlIMVVdpbGPdduo0ypsK0XTfrHKIu7h7BLghYshPCf

