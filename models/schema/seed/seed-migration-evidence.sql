--
-- PostgreSQL database dump
--

\restrict pbH4boHz4oeuLlT2JcpgtZpeY16cSLXfkqmPuaBwUv3cQ9SLM2jQPfwef1KJbvJ

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
	('6223802b-9ffd-4545-b9f4-c5000e9bee3b', 'establishment-rebuild', 'GIAS BAU', 'gias_bau_test_local', '2026-10-08', '2026-10-08 15:00:39.738544+01', '2026-10-08 15:01:23.963809+01', 'completed', 'establishment-party-responsibility-v2', NULL);


--
-- Data for Name: source_snapshot; Type: TABLE DATA; Schema: migration; Owner: -
--

INSERT INTO migration.source_snapshot (source_snapshot_id, migration_run_id, source_system, source_database, snapshot_date, extract_name, created_at) VALUES
	('cfa5cf44-230f-4223-9cf9-c6b114f0e281', '6223802b-9ffd-4545-b9f4-c5000e9bee3b', 'GIAS BAU', 'gias_bau_test_local', '2026-10-08', 'establishment-party-136102-2777', '2026-10-08 15:00:59.187199+01'),
	('95a80c66-ea0c-4448-adf8-34d0d7bacd2c', '6223802b-9ffd-4545-b9f4-c5000e9bee3b', 'GIAS BAU', 'gias_bau_test_local', '2026-10-08', 'establishment-party-136102-2779', '2026-10-08 15:00:59.823814+01'),
	('03d5619f-0283-4581-8718-f4ab8d29947a', '6223802b-9ffd-4545-b9f4-c5000e9bee3b', 'GIAS BAU', 'gias_bau_test_local', '2026-10-08', 'establishment-party-136102-4949', '2026-10-08 15:01:00.458916+01'),
	('e223b86d-0767-4b2b-9dbc-0dd664ff87e5', '6223802b-9ffd-4545-b9f4-c5000e9bee3b', 'GIAS BAU', 'gias_bau_test_local', '2026-10-08', 'establishment-party-134314-23869', '2026-10-08 15:01:01.234038+01'),
	('efa7ccd5-a342-49a7-93e1-ee202bf4a6db', '6223802b-9ffd-4545-b9f4-c5000e9bee3b', 'GIAS BAU', 'gias_bau_test_local', '2026-10-08', 'establishment-party-134314-4737', '2026-10-08 15:01:01.827253+01'),
	('d11a73e2-555b-4b4d-baa2-31e85ddcce4b', '6223802b-9ffd-4545-b9f4-c5000e9bee3b', 'GIAS BAU', 'gias_bau_test_local', '2026-10-08', 'establishment-party-134314-2914', '2026-10-08 15:01:02.416418+01'),
	('ed2a7569-97ec-421c-ac80-9a0a06b767e8', '6223802b-9ffd-4545-b9f4-c5000e9bee3b', 'GIAS BAU', 'gias_bau_test_local', '2026-10-08', 'establishment-party-135905-3839', '2026-10-08 15:01:02.966289+01'),
	('088113aa-a461-4773-9ff2-20a99cace5d7', '6223802b-9ffd-4545-b9f4-c5000e9bee3b', 'GIAS BAU', 'gias_bau_test_local', '2026-10-08', 'establishment-party-137603-2055', '2026-10-08 15:01:03.544575+01'),
	('57ab4755-f676-4696-95b6-3dfbcff2dabb', '6223802b-9ffd-4545-b9f4-c5000e9bee3b', 'GIAS BAU', 'gias_bau_test_local', '2026-10-08', 'establishment-party-137603-20364', '2026-10-08 15:01:04.155371+01'),
	('9b489d30-3bdd-452b-aa96-8ac5bcb65f8c', '6223802b-9ffd-4545-b9f4-c5000e9bee3b', 'GIAS BAU', 'gias_bau_test_local', '2026-10-08', 'establishment-party-132141-1337', '2026-10-08 15:01:04.831096+01'),
	('de70016e-b7f5-42b1-9d2a-eaf93020da75', '6223802b-9ffd-4545-b9f4-c5000e9bee3b', 'GIAS BAU', 'gias_bau_test_local', '2026-10-08', 'establishment-party-135936-2613', '2026-10-08 15:01:05.425728+01'),
	('08d75a45-b2d5-46ba-996a-9db27b12687d', '6223802b-9ffd-4545-b9f4-c5000e9bee3b', 'GIAS BAU', 'gias_bau_test_local', '2026-10-08', 'establishment-party-135936-3147', '2026-10-08 15:01:06.040294+01'),
	('23759449-7440-49c7-a90b-935427cc7e5b', '6223802b-9ffd-4545-b9f4-c5000e9bee3b', 'GIAS BAU', 'gias_bau_test_local', '2026-10-08', 'organisation-group-1809', '2026-10-08 15:01:06.526144+01'),
	('b9b63374-8fea-4e0e-8fb6-90a66993271c', '6223802b-9ffd-4545-b9f4-c5000e9bee3b', 'GIAS BAU', 'gias_bau_test_local', '2026-10-08', 'organisation-group-86052', '2026-10-08 15:01:06.865104+01'),
	('b04cf795-cb7d-4536-ade8-3d73f0e7b362', '6223802b-9ffd-4545-b9f4-c5000e9bee3b', 'GIAS public extract', NULL, '2026-06-16', 'docs/data/extract-data/establishment-fields/edubasealldata20260616.csv', '2026-10-08 15:01:14.34072+01'),
	('4a7584ce-a74c-428c-a8de-da5555667718', '6223802b-9ffd-4545-b9f4-c5000e9bee3b', 'GIAS BAU', 'gias_bau_test_local', '2026-10-08', 'T9-local-proprietor-context', '2026-10-08 15:01:14.34072+01');


--
-- Data for Name: source_record; Type: TABLE DATA; Schema: migration; Owner: -
--

INSERT INTO migration.source_record (source_record_id, source_snapshot_id, source_table, source_key, source_group_id, source_urn, source_row_hash) VALUES
	('9b2926ae-487c-4009-9053-132564d021f0', 'cfa5cf44-230f-4223-9cf9-c6b114f0e281', 'dbo.EstablishmentGroup/GroupLink', '2777:136102', '2777', 136102, NULL),
	('7d35acb1-0103-41b9-9493-3b178780047d', '95a80c66-ea0c-4448-adf8-34d0d7bacd2c', 'dbo.EstablishmentGroup/GroupLink', '2779:136102', '2779', 136102, NULL),
	('567e74ee-633d-442a-b8ab-2c665ce129b9', '03d5619f-0283-4581-8718-f4ab8d29947a', 'dbo.EstablishmentGroup/GroupLink', '4949:136102', '4949', 136102, NULL),
	('4b1b1da1-4eb8-4617-a861-588bc683fee7', 'e223b86d-0767-4b2b-9dbc-0dd664ff87e5', 'dbo.EstablishmentGroup/GroupLink', '23869:134314', '23869', 134314, NULL),
	('de418d70-ec05-47ca-8b9f-ae13993e80dc', 'efa7ccd5-a342-49a7-93e1-ee202bf4a6db', 'dbo.EstablishmentGroup/GroupLink', '4737:134314', '4737', 134314, NULL),
	('37db52a1-ea70-4e96-8a26-3ea050435af9', 'd11a73e2-555b-4b4d-baa2-31e85ddcce4b', 'dbo.EstablishmentGroup/GroupLink', '2914:134314', '2914', 134314, NULL),
	('27f232d6-a116-4636-b993-b9080f9132a4', 'ed2a7569-97ec-421c-ac80-9a0a06b767e8', 'dbo.EstablishmentGroup/GroupLink', '3839:135905', '3839', 135905, NULL),
	('f14201f9-8196-477c-8135-a2f5e51c8285', '088113aa-a461-4773-9ff2-20a99cace5d7', 'dbo.EstablishmentGroup/GroupLink', '2055:137603', '2055', 137603, NULL),
	('181b5b86-cf18-49c1-9e93-e2e932e30a1c', '57ab4755-f676-4696-95b6-3dfbcff2dabb', 'dbo.EstablishmentGroup/GroupLink', '20364:137603', '20364', 137603, NULL),
	('83a2076b-3665-4ce4-b85b-14977b3baf01', '9b489d30-3bdd-452b-aa96-8ac5bcb65f8c', 'dbo.EstablishmentGroup/GroupLink', '1337:132141', '1337', 132141, NULL),
	('5067738a-2fd4-48f1-8a08-97d8ed1747e1', 'de70016e-b7f5-42b1-9d2a-eaf93020da75', 'dbo.EstablishmentGroup/GroupLink', '2613:135936', '2613', 135936, NULL),
	('b273a93f-90e0-4952-8e4f-a7bee92eb9aa', '08d75a45-b2d5-46ba-996a-9db27b12687d', 'dbo.EstablishmentGroup/GroupLink', '3147:135936', '3147', 135936, NULL),
	('db23b2cd-831f-453f-980e-baaa00230e79', '23759449-7440-49c7-a90b-935427cc7e5b', 'dbo.EstablishmentGroup/GroupLink', '1928', '1809', 109443, NULL),
	('eaf00eea-df0b-45d3-94ff-5c5def136188', '23759449-7440-49c7-a90b-935427cc7e5b', 'dbo.EstablishmentGroup/GroupLink', '1929', '1809', 109613, NULL),
	('2c485675-4db5-4508-b8f2-b018723fa50f', 'b9b63374-8fea-4e0e-8fb6-90a66993271c', 'dbo.EstablishmentGroup/GroupLink', '25390', '86052', 20338, NULL),
	('8f634c3e-ce85-4a14-8685-c68331eda6ed', 'b9b63374-8fea-4e0e-8fb6-90a66993271c', 'dbo.EstablishmentGroup/GroupLink', '25391', '86052', 20549, NULL),
	('975bf4bb-9bda-46d9-a9e1-304763c0db4c', 'b9b63374-8fea-4e0e-8fb6-90a66993271c', 'dbo.EstablishmentGroup/GroupLink', '25392', '86052', 20614, NULL),
	('f9e2451c-5c55-40f6-a025-b14d05554863', 'b9b63374-8fea-4e0e-8fb6-90a66993271c', 'dbo.EstablishmentGroup/GroupLink', '25395', '86052', 21363, NULL),
	('cfe85904-1b2f-455c-90d0-35cf8b3a405c', 'b9b63374-8fea-4e0e-8fb6-90a66993271c', 'dbo.EstablishmentGroup/GroupLink', '25396', '86052', 22422, NULL),
	('33b23b59-8e51-4db1-a32e-612db6ef147b', 'b9b63374-8fea-4e0e-8fb6-90a66993271c', 'dbo.EstablishmentGroup/GroupLink', '25394', '86052', 22459, NULL),
	('e1519847-99b7-4733-b369-915b439fb73d', 'b9b63374-8fea-4e0e-8fb6-90a66993271c', 'dbo.EstablishmentGroup/GroupLink', '25397', '86052', 22975, NULL),
	('6f083941-3dd6-450b-b267-44a355343e09', 'b9b63374-8fea-4e0e-8fb6-90a66993271c', 'dbo.EstablishmentGroup/GroupLink', '25393', '86052', 23004, NULL),
	('bfe3d6f8-f4d8-482f-92f2-4f39cc5f696f', 'b9b63374-8fea-4e0e-8fb6-90a66993271c', 'dbo.EstablishmentGroup/GroupLink', '25398', '86052', 23122, NULL),
	('c945d961-dc8c-4379-a769-f2846bf02614', 'b04cf795-cb7d-4536-ade8-3d73f0e7b362', 'Establishment extract PropsName', '112461', NULL, 112461, '10dc16379435aa61d05c534771c10ed9'),
	('5695c91f-a293-417f-91ec-0a01b0dd91b0', 'b04cf795-cb7d-4536-ade8-3d73f0e7b362', 'Establishment extract PropsName', '119009', NULL, 119009, '5aa20f3444180e744e297a5fa69e1bee'),
	('8137dfa4-bb88-45c1-b4fa-5f140315535e', '4a7584ce-a74c-428c-a8de-da5555667718', 'dbo.IndependentSchools (context only)', '112461', NULL, 112461, 'a1cc1f32cf7cafe4e71155e65f89826d'),
	('695d4fdc-7a7e-4cdc-8ed4-d3089d753574', '4a7584ce-a74c-428c-a8de-da5555667718', 'dbo.IndependentSchools (context only)', '119009', NULL, 119009, '40d707e0a0c2f2c8e28582e3845f5dd2');


--
-- Data for Name: academy_trust_classification_evidence; Type: TABLE DATA; Schema: migration; Owner: -
--

INSERT INTO migration.academy_trust_classification_evidence (evidence_id, academy_trust_classification_id, source_record_id, assertion_rule, review_status, notes) VALUES
	('9aa5debe-af3f-48e6-85ac-a91bc38cfaef', '0f100f16-1e2b-4a68-90a9-42967725d80c', '9b2926ae-487c-4009-9053-132564d021f0', 'MR001', 'accepted', NULL),
	('74f82fc1-39dc-467a-b2ec-45123428c61a', '8f7968be-d531-4dad-b5fc-d807a4d25a5d', '7d35acb1-0103-41b9-9493-3b178780047d', 'MR005', 'accepted', NULL),
	('449d3b99-664a-4243-a38d-ba2e1491f25c', 'b26c0c26-f2cb-4e07-921d-b1d4a3d01e43', '4b1b1da1-4eb8-4617-a861-588bc683fee7', 'MR001', 'accepted', NULL),
	('167cec10-2b68-4d34-a7ef-da90b241ff95', '264dacf4-8d4b-4bc5-bc5b-8d24d899ecae', '27f232d6-a116-4636-b993-b9080f9132a4', 'MR005', 'accepted', NULL),
	('79c17543-6380-4e6e-bc92-318ab5659226', 'ab294e0c-8832-4b63-bcd4-dd94f4c07cf4', 'f14201f9-8196-477c-8135-a2f5e51c8285', 'MR005', 'accepted', 'T3: shared Group ID TR00009, UKPRN 10059335 and incorporation date; Companies House 07795736 supplied by MAT 20364. GroupRelationsLink 547 (2055 -> 20364, 1M) and 548 (20364 -> 2055, 1S) evidence classification transition 2021-03-30. Source GroupLink 4778 supplies the historical SAT responsibility start 2011-11-01; GroupLink 34277 supplies the current MAT responsibility start 2021-03-30. One continuing legal entity and role; separate SAT and MAT responsibilities. SAT responsibility end and initial SAT classification start unknown; classification dates are not copied into responsibility boundaries.'),
	('91617378-2c30-467d-a869-b8f43e3b6461', '5ac52940-1b2b-4086-9269-96f44ec721eb', '181b5b86-cf18-49c1-9e93-e2e932e30a1c', 'MR001', 'accepted', 'T3: shared Group ID TR00009, UKPRN 10059335 and incorporation date; Companies House 07795736 supplied by MAT 20364. GroupRelationsLink 547 (2055 -> 20364, 1M) and 548 (20364 -> 2055, 1S) evidence classification transition 2021-03-30. Source GroupLink 4778 supplies the historical SAT responsibility start 2011-11-01; GroupLink 34277 supplies the current MAT responsibility start 2021-03-30. One continuing legal entity and role; separate SAT and MAT responsibilities. SAT responsibility end and initial SAT classification start unknown; classification dates are not copied into responsibility boundaries.'),
	('e894211c-023f-452b-b84a-35482b17e041', '44279a12-1e8e-4fbd-a5ec-a69fcc63d3d3', 'b273a93f-90e0-4952-8e4f-a7bee92eb9aa', 'MR001', 'accepted', NULL);


--
-- Data for Name: establishment_party_role_evidence; Type: TABLE DATA; Schema: migration; Owner: -
--

INSERT INTO migration.establishment_party_role_evidence (evidence_id, establishment_party_role_id, source_record_id, first_observed_date, end_date_basis, inference_rule, review_status, notes) VALUES
	('42f58355-6026-4f6d-90eb-9644d403a2de', '55c3dfaf-699c-42bf-b56c-ccd86bf18923', '9b2926ae-487c-4009-9053-132564d021f0', NULL, NULL, NULL, 'accepted', NULL),
	('85afb5a2-92fe-424e-a581-fc7daf638f12', 'd2b4bdd4-fd45-4c9c-b547-c98c75874ca1', '7d35acb1-0103-41b9-9493-3b178780047d', NULL, NULL, NULL, 'accepted', NULL),
	('e4bc0866-998f-42f4-a9f0-da6d7995f97a', '74235b37-ec44-467b-a19f-a9ce06b3aa15', '567e74ee-633d-442a-b8ab-2c665ce129b9', NULL, NULL, NULL, 'accepted', NULL),
	('4ba7a09a-0d5b-4fcc-8f6b-e29d37eae9e3', 'bb3387e0-2348-484f-a92b-48f94be1d681', '4b1b1da1-4eb8-4617-a861-588bc683fee7', NULL, NULL, NULL, 'accepted', NULL),
	('022bbf42-4e5e-40ca-8421-43fae2ade0b9', 'bb3387e0-2348-484f-a92b-48f94be1d681', 'de418d70-ec05-47ca-8b9f-ae13993e80dc', NULL, NULL, NULL, 'accepted', NULL),
	('9319648f-4990-420b-8908-5efa8f5209b3', 'f9b4627b-e24a-4056-805b-356f6575423d', '37db52a1-ea70-4e96-8a26-3ea050435af9', NULL, NULL, NULL, 'accepted', NULL),
	('b949c293-ceac-4701-9923-52793fc7e548', '063411f5-f50d-41a3-b17f-777ad4c0a9fd', '27f232d6-a116-4636-b993-b9080f9132a4', NULL, 'evidenced', NULL, 'accepted', NULL),
	('e395988f-bf2a-41a8-8bb5-c57919fbde74', '9f8e70f2-d0df-4a07-b823-f76f50011894', 'f14201f9-8196-477c-8135-a2f5e51c8285', NULL, NULL, NULL, 'accepted', 'T3: shared Group ID TR00009, UKPRN 10059335 and incorporation date; Companies House 07795736 supplied by MAT 20364. GroupRelationsLink 547 (2055 -> 20364, 1M) and 548 (20364 -> 2055, 1S) evidence classification transition 2021-03-30. Source GroupLink 4778 supplies the historical SAT responsibility start 2011-11-01; GroupLink 34277 supplies the current MAT responsibility start 2021-03-30. One continuing legal entity and role; separate SAT and MAT responsibilities. SAT responsibility end and initial SAT classification start unknown; classification dates are not copied into responsibility boundaries.'),
	('86790e7d-f9a5-4567-b193-204ad646087f', '9f8e70f2-d0df-4a07-b823-f76f50011894', '181b5b86-cf18-49c1-9e93-e2e932e30a1c', NULL, NULL, NULL, 'accepted', 'T3: shared Group ID TR00009, UKPRN 10059335 and incorporation date; Companies House 07795736 supplied by MAT 20364. GroupRelationsLink 547 (2055 -> 20364, 1M) and 548 (20364 -> 2055, 1S) evidence classification transition 2021-03-30. Source GroupLink 4778 supplies the historical SAT responsibility start 2011-11-01; GroupLink 34277 supplies the current MAT responsibility start 2021-03-30. One continuing legal entity and role; separate SAT and MAT responsibilities. SAT responsibility end and initial SAT classification start unknown; classification dates are not copied into responsibility boundaries.'),
	('ae485733-fc4b-4238-ad05-b09f3fd65cf8', 'f1b26597-1fca-4286-a0bb-e7b708248514', '83a2076b-3665-4ce4-b85b-14977b3baf01', '2026-10-08', NULL, NULL, 'accepted', 'Source GroupLink 1029: archived=0; source group openDate=2010-09-03; role start unknown; group openDate is not role start or incorporation; legal identity provisional.'),
	('54d07f0d-64e8-40b7-a64b-50877f824bfb', 'bc85ae83-f01e-4764-993b-67e44a8c0f06', '5067738a-2fd4-48f1-8a08-97d8ed1747e1', '2026-10-08', NULL, NULL, 'accepted', 'T7 reviewed person sponsor: Charles Dunstone. Fulwood Academy identifies Sir Charles as its sponsor and states personal funding: https://www.fulwoodacademy.co.uk/page/?pid=53&title=Welcome+from+the+Sponsor. GroupLink 3648: archived=0; effectiveDate=2009-09-01. Source group openDate=1900-01-01 rejected as placeholder; role start unknown. No Companies House number applies to the person; do not merge with trust UID 3147.'),
	('29957302-2187-4f70-a016-c2aa65c83621', '1eb11232-bed2-4aee-953e-4ab901001737', 'b273a93f-90e0-4952-8e4f-a7bee92eb9aa', NULL, NULL, NULL, 'accepted', NULL);


--
-- Data for Name: establishment_responsibility_evidence; Type: TABLE DATA; Schema: migration; Owner: -
--

INSERT INTO migration.establishment_responsibility_evidence (evidence_id, establishment_responsibility_id, source_record_id, first_observed_date, end_date_basis, inference_rule, review_status, notes) VALUES
	('90fae96c-de2d-4483-953e-f79f5eb17e03', '5f49907d-8358-49a6-8e79-e605aba96e95', '9b2926ae-487c-4009-9053-132564d021f0', NULL, NULL, NULL, 'accepted', NULL),
	('39784782-1c1f-4ac2-bd75-d78659a29a25', '644bae51-7218-4c56-9055-bc9e10f590b7', '7d35acb1-0103-41b9-9493-3b178780047d', NULL, NULL, NULL, 'accepted', NULL),
	('f536dc26-0791-42d3-b7ed-6b4cc27f98bd', '3e0da29a-94cd-41c5-b391-abb8c854e38c', '567e74ee-633d-442a-b8ab-2c665ce129b9', NULL, NULL, NULL, 'accepted', NULL),
	('2b0e1b37-348a-4135-9c6b-dc2003504126', '86cc51df-3d54-49a9-a6fb-19a6bcf22f5a', '4b1b1da1-4eb8-4617-a861-588bc683fee7', NULL, NULL, NULL, 'accepted', NULL),
	('1a9c6ac9-b99d-4f5a-9fcb-98ef6e047422', '81e844e4-5871-4d79-8a65-abfdcbb396e8', 'de418d70-ec05-47ca-8b9f-ae13993e80dc', NULL, NULL, NULL, 'accepted', NULL),
	('87d44307-d7e0-4db1-b569-b02d28a8fc41', 'c739264f-e2e1-46f2-912f-a5de94824f00', '37db52a1-ea70-4e96-8a26-3ea050435af9', NULL, NULL, NULL, 'accepted', NULL),
	('5e823d5f-da09-4a1c-8fe0-3b8a0facdc54', '1692eed1-25b3-41b5-8438-0a3b9160020b', '27f232d6-a116-4636-b993-b9080f9132a4', NULL, 'inferred', 'Responsibility end date inferred from the source establishment closure date.', 'accepted', NULL),
	('5fb4ada7-37a2-489e-94a9-20584cc4101c', 'c6fa0892-f6db-464c-a7ae-49a1c4e0eee1', 'f14201f9-8196-477c-8135-a2f5e51c8285', NULL, NULL, NULL, 'accepted', 'T3: shared Group ID TR00009, UKPRN 10059335 and incorporation date; Companies House 07795736 supplied by MAT 20364. GroupRelationsLink 547 (2055 -> 20364, 1M) and 548 (20364 -> 2055, 1S) evidence classification transition 2021-03-30. Source GroupLink 4778 supplies the historical SAT responsibility start 2011-11-01; GroupLink 34277 supplies the current MAT responsibility start 2021-03-30. One continuing legal entity and role; separate SAT and MAT responsibilities. SAT responsibility end and initial SAT classification start unknown; classification dates are not copied into responsibility boundaries.'),
	('b8c53eef-ef40-47d3-964d-9f259f09f1e9', '48ca263b-b11d-4e1a-86d9-d0ff69dd44da', '181b5b86-cf18-49c1-9e93-e2e932e30a1c', NULL, NULL, NULL, 'accepted', 'T3: shared Group ID TR00009, UKPRN 10059335 and incorporation date; Companies House 07795736 supplied by MAT 20364. GroupRelationsLink 547 (2055 -> 20364, 1M) and 548 (20364 -> 2055, 1S) evidence classification transition 2021-03-30. Source GroupLink 4778 supplies the historical SAT responsibility start 2011-11-01; GroupLink 34277 supplies the current MAT responsibility start 2021-03-30. One continuing legal entity and role; separate SAT and MAT responsibilities. SAT responsibility end and initial SAT classification start unknown; classification dates are not copied into responsibility boundaries.'),
	('2621eff9-e008-43f0-b6bf-ce72ef81fff6', '4cd9eb21-a2ba-4e3d-a13b-2cf056943475', '83a2076b-3665-4ce4-b85b-14977b3baf01', NULL, NULL, NULL, 'accepted', 'Source GroupLink 1029: archived=0; responsibility start from effectiveDate; end unknown; source group openDate=2010-09-03; no name-based consolidation.'),
	('adac7162-cef9-4e89-b461-fa1a851e9242', 'd86a3a70-c575-496e-8768-1e18e3517e40', '5067738a-2fd4-48f1-8a08-97d8ed1747e1', NULL, NULL, NULL, 'accepted', 'T7 reviewed person sponsor: Charles Dunstone. Fulwood Academy identifies Sir Charles as its sponsor and states personal funding: https://www.fulwoodacademy.co.uk/page/?pid=53&title=Welcome+from+the+Sponsor. GroupLink 3648: archived=0; effectiveDate=2009-09-01. Source group openDate=1900-01-01 rejected as placeholder; role start unknown. No Companies House number applies to the person; do not merge with trust UID 3147.'),
	('c58524ba-a60d-4d7d-a31b-45b313cc9d19', 'ab7f6b56-1157-4a63-8c47-19efcf23ae93', 'b273a93f-90e0-4952-8e4f-a7bee92eb9aa', NULL, NULL, NULL, 'accepted', NULL),
	('e98bca7e-239a-4c5d-bd42-b9158441ce66', '61fe498a-e04a-4242-a07a-13de4d365157', '8137dfa4-bb88-45c1-b4fa-5f140315535e', NULL, NULL, NULL, 'accepted', 'Local context only: proprietorType_code=01; proprietor_type=Individual Proprietor; additional_proprietor_rows=1. Obfuscated local proprietor identity is not resolved to the controlled party; additional rows not imported.'),
	('34e39c16-f7aa-4e40-9d4b-32734a081fb5', '61fe498a-e04a-4242-a07a-13de4d365157', 'c945d961-dc8c-4379-a769-f2846bf02614', '2026-06-16', NULL, NULL, 'accepted', 'Controlled accepted PropsName=Acorn Care and Education Ltd; T9 accepted proprietor-identity assumption: both selected extract assertions resolve to one body; local proprietor records are obfuscated, not evidence of Acorn''s legal identity or ownership. Responsibility dates unknown; legal form unverified; ownership not asserted.'),
	('4368c215-6d66-48ed-ba87-2ed4c055cec6', 'fe1d5a6c-e088-4003-ad51-7e2bdcf73e26', '695d4fdc-7a7e-4cdc-8ed4-d3089d753574', NULL, NULL, NULL, 'accepted', 'Local context only: proprietorType_code=01; proprietor_type=Individual Proprietor; additional_proprietor_rows=1. Obfuscated local proprietor identity is not resolved to the controlled party; additional rows not imported.'),
	('062857a7-a2f8-489f-8989-976a5779167b', 'fe1d5a6c-e088-4003-ad51-7e2bdcf73e26', '5695c91f-a293-417f-91ec-0a01b0dd91b0', '2026-06-16', NULL, NULL, 'accepted', 'Controlled accepted PropsName=Acorn Care and Education Ltd; T9 accepted proprietor-identity assumption: both selected extract assertions resolve to one body; local proprietor records are obfuscated, not evidence of Acorn''s legal identity or ownership. Responsibility dates unknown; legal form unverified; ownership not asserted.');


--
-- Data for Name: identity_resolution; Type: TABLE DATA; Schema: migration; Owner: -
--

INSERT INTO migration.identity_resolution (identity_resolution_id, source_record_id, target_entity_type, target_entity_id, resolution_method, confidence, decision_status, decided_at, decided_by, rationale) VALUES
	('b8ac5cd5-dcf4-4330-b4d0-fd6457ae520e', '9b2926ae-487c-4009-9053-132564d021f0', 'legal_entity', '244c9b11-50ca-415d-87a2-f4b91eb37e53', 'companies-house-number', 'high', 'accepted', NULL, NULL, 'Resolved by companies-house-number. A new separate source party is not a verification of its registered legal identity; names do not authorise consolidation.'),
	('a2db1a08-ac16-4bfc-a0e3-40124686df09', '7d35acb1-0103-41b9-9493-3b178780047d', 'legal_entity', 'b723a2f1-a5bf-48b0-9e89-ec7527a998fa', 'companies-house-number', 'high', 'accepted', NULL, NULL, 'Resolved by companies-house-number. A new separate source party is not a verification of its registered legal identity; names do not authorise consolidation.'),
	('1dd2871b-f450-43ab-bf70-1e71f6ad155a', '567e74ee-633d-442a-b8ab-2c665ce129b9', 'legal_entity', '36e1d056-789a-4574-8b11-893e2d470e3e', 'new-separate-source-party', 'provisional', 'accepted', NULL, NULL, 'Resolved by new-separate-source-party. A new separate source party is not a verification of its registered legal identity; names do not authorise consolidation.'),
	('a9e56763-9b07-43b6-88d3-b9d540c33c45', '4b1b1da1-4eb8-4617-a861-588bc683fee7', 'legal_entity', 'e165d941-dd82-44ab-ac49-be55ce336bba', 'companies-house-number', 'high', 'accepted', NULL, NULL, 'Resolved by companies-house-number. A new separate source party is not a verification of its registered legal identity; names do not authorise consolidation.'),
	('42220664-2b58-4b69-9ce3-30d9350f2f18', 'de418d70-ec05-47ca-8b9f-ae13993e80dc', 'legal_entity', 'e165d941-dd82-44ab-ac49-be55ce336bba', 'ukprn', 'high', 'accepted', NULL, NULL, 'Resolved by ukprn. A new separate source party is not a verification of its registered legal identity; names do not authorise consolidation.'),
	('c05fc4fc-c29b-4c72-856e-92d7fd7db32c', '37db52a1-ea70-4e96-8a26-3ea050435af9', 'legal_entity', '94213cc8-78f2-4cb4-91a3-7cc6617d9c0a', 'new-separate-source-party', 'provisional', 'accepted', NULL, NULL, 'Resolved by new-separate-source-party. A new separate source party is not a verification of its registered legal identity; names do not authorise consolidation.'),
	('bd92b765-81bd-4a77-8422-3cd2427b0dd9', '27f232d6-a116-4636-b993-b9080f9132a4', 'legal_entity', 'c66276ea-4de3-48bb-9a7f-613e07f2a615', 'companies-house-number', 'high', 'accepted', NULL, NULL, 'Resolved by companies-house-number. A new separate source party is not a verification of its registered legal identity; names do not authorise consolidation.'),
	('0601a475-4266-498f-8826-f07359281c06', 'f14201f9-8196-477c-8135-a2f5e51c8285', 'legal_entity', 'e04b4e21-f792-491b-88ba-c7848ab5cf63', 'shared-identifiers-and-explicit-sat-mat-transition', 'high', 'accepted', NULL, NULL, 'T3: shared Group ID TR00009, UKPRN 10059335 and incorporation date; Companies House 07795736 supplied by MAT 20364. GroupRelationsLink 547 (2055 -> 20364, 1M) and 548 (20364 -> 2055, 1S) evidence classification transition 2021-03-30. Source GroupLink 4778 supplies the historical SAT responsibility start 2011-11-01; GroupLink 34277 supplies the current MAT responsibility start 2021-03-30. One continuing legal entity and role; separate SAT and MAT responsibilities. SAT responsibility end and initial SAT classification start unknown; classification dates are not copied into responsibility boundaries.'),
	('ec007072-a6d5-48cf-b76f-8a2f477d55ce', '181b5b86-cf18-49c1-9e93-e2e932e30a1c', 'legal_entity', 'e04b4e21-f792-491b-88ba-c7848ab5cf63', 'shared-identifiers-and-explicit-sat-mat-transition', 'high', 'accepted', NULL, NULL, 'T3: shared Group ID TR00009, UKPRN 10059335 and incorporation date; Companies House 07795736 supplied by MAT 20364. GroupRelationsLink 547 (2055 -> 20364, 1M) and 548 (20364 -> 2055, 1S) evidence classification transition 2021-03-30. Source GroupLink 4778 supplies the historical SAT responsibility start 2011-11-01; GroupLink 34277 supplies the current MAT responsibility start 2021-03-30. One continuing legal entity and role; separate SAT and MAT responsibilities. SAT responsibility end and initial SAT classification start unknown; classification dates are not copied into responsibility boundaries.'),
	('a397f4e4-b83c-48fd-973b-05e8be52af0f', '83a2076b-3665-4ce4-b85b-14977b3baf01', 'legal_entity', '4dc58ccf-dadb-4cee-ba8b-4553d5615c14', 'new-separate-source-party', 'provisional', 'accepted', NULL, NULL, 'Resolved by new-separate-source-party. A new separate source party is not a verification of its registered legal identity; names do not authorise consolidation.'),
	('40d8006f-abf1-4e59-b53a-604ba544c6b2', '5067738a-2fd4-48f1-8a08-97d8ed1747e1', 'person', '251ffeb7-8cfa-4339-9483-1d34c56198b0', 'reviewed-person-sponsor', 'reviewed', 'accepted', NULL, NULL, 'T7 reviewed person sponsor: Charles Dunstone. Fulwood Academy identifies Sir Charles as its sponsor and states personal funding: https://www.fulwoodacademy.co.uk/page/?pid=53&title=Welcome+from+the+Sponsor. GroupLink 3648: archived=0; effectiveDate=2009-09-01. Source group openDate=1900-01-01 rejected as placeholder; role start unknown. No Companies House number applies to the person; do not merge with trust UID 3147.'),
	('5fd44584-0199-408f-b9e9-e89bb5ad4fb7', 'b273a93f-90e0-4952-8e4f-a7bee92eb9aa', 'legal_entity', '0f3430d8-947f-4fad-b604-e62f783230f7', 'companies-house-number', 'high', 'accepted', NULL, NULL, 'Resolved by companies-house-number. A new separate source party is not a verification of its registered legal identity; names do not authorise consolidation.'),
	('070b2765-8de7-4c98-8124-ad2afa6c1c5a', 'c945d961-dc8c-4379-a769-f2846bf02614', 'legal_entity', '5be037f1-12fc-4b40-829c-4135c96fc783', 'controlled-reviewed-proprietor', 'accepted-fixture-assumption', 'accepted', '2026-10-08 15:01:14.34072+01', 'T9 accepted fixture decision', 'T9 accepted proprietor-identity assumption: both selected extract assertions resolve to one body; local proprietor records are obfuscated, not evidence of Acorn''s legal identity or ownership.'),
	('004ae1a7-3b6f-49bb-a1a3-d41248d11a3c', '5695c91f-a293-417f-91ec-0a01b0dd91b0', 'legal_entity', '5be037f1-12fc-4b40-829c-4135c96fc783', 'controlled-reviewed-proprietor', 'accepted-fixture-assumption', 'accepted', '2026-10-08 15:01:14.34072+01', 'T9 accepted fixture decision', 'T9 accepted proprietor-identity assumption: both selected extract assertions resolve to one body; local proprietor records are obfuscated, not evidence of Acorn''s legal identity or ownership.');


--
-- Data for Name: organisation_group_member_evidence; Type: TABLE DATA; Schema: migration; Owner: -
--

INSERT INTO migration.organisation_group_member_evidence (evidence_id, organisation_group_member_id, source_record_id, first_observed_date, left_date_basis, inference_rule, review_status, notes) VALUES
	('44dc160d-72b8-497d-8b1c-5f62c4ffa9f8', 'e369d27a-2daa-440f-9ef8-48dcdc517094', 'eaf00eea-df0b-45d3-94ff-5c5def136188', NULL, NULL, NULL, 'accepted', 'Source GroupLink 1929: archived=0; linkType=HARD; joined date from effectiveDate; leaving date unknown.'),
	('33a4c9a0-f1c3-462e-aca6-6ed3367e2e77', '34f1b2a9-895a-4e97-a5a3-b05ffb490401', 'db23b2cd-831f-453f-980e-baaa00230e79', NULL, NULL, NULL, 'accepted', 'Source GroupLink 1928: archived=0; linkType=HARD; joined date from effectiveDate; leaving date unknown.'),
	('599c69fb-f080-427c-b687-f4821acf7507', 'd9dfda67-21b1-4983-a6d5-6f3d592c8741', '8f634c3e-ce85-4a14-8685-c68331eda6ed', NULL, NULL, NULL, 'accepted', 'Source GroupLink 25391: archived=0; ccLinkType=LEAD; joined date from effectiveDate; leaving date unknown.'),
	('7a2eb4d0-eb67-48ab-ab91-c950876c79d8', '163adb8f-e885-48ff-8f4b-cb63eeabf2f7', '6f083941-3dd6-450b-b267-44a355343e09', NULL, NULL, NULL, 'accepted', 'Source GroupLink 25393: archived=0; ccLinkType=STANDARD; joined date from effectiveDate; leaving date unknown.'),
	('f1ca4a3a-5e47-4592-9cc6-e9dc4f3068e0', '07d3ee66-fb76-4ec6-8abb-6b0a45b288e6', '33b23b59-8e51-4db1-a32e-612db6ef147b', NULL, NULL, NULL, 'accepted', 'Source GroupLink 25394: archived=0; ccLinkType=STANDARD; joined date from effectiveDate; leaving date unknown.'),
	('f01cd857-7297-4163-bd60-45b16db3d886', '2ad462ec-a76d-4939-b567-c99c37320374', '975bf4bb-9bda-46d9-a9e1-304763c0db4c', NULL, NULL, NULL, 'accepted', 'Source GroupLink 25392: archived=0; ccLinkType=STANDARD; joined date from effectiveDate; leaving date unknown.'),
	('01546761-c64f-47d1-b6f3-b172720f854b', '13b54ff3-4f03-4cba-aabe-670dc305c6f0', 'cfe85904-1b2f-455c-90d0-35cf8b3a405c', NULL, NULL, NULL, 'accepted', 'Source GroupLink 25396: archived=0; ccLinkType=STANDARD; joined date from effectiveDate; leaving date unknown.'),
	('7cfa88f0-8682-40b5-b3c5-1dd6eabc0bce', '2df40d89-ed01-4add-a645-e842786b5f81', 'e1519847-99b7-4733-b369-915b439fb73d', NULL, NULL, NULL, 'accepted', 'Source GroupLink 25397: archived=0; ccLinkType=STANDARD; joined date from effectiveDate; leaving date unknown.'),
	('4261633d-7dcb-4a42-95c4-82b97d4748db', '0e7fddfb-6481-47d0-aebb-ca390c8a96ce', '2c485675-4db5-4508-b8f2-b018723fa50f', NULL, NULL, NULL, 'accepted', 'Source GroupLink 25390: archived=0; ccLinkType=STANDARD; joined date from effectiveDate; leaving date unknown.'),
	('220d631c-a62c-4bad-8594-5518286a9fff', 'bb61cfc4-cf31-4d6a-bc38-7451a04799d0', 'f9e2451c-5c55-40f6-a025-b14d05554863', NULL, NULL, NULL, 'accepted', 'Source GroupLink 25395: archived=0; ccLinkType=STANDARD; joined date from effectiveDate; leaving date unknown.'),
	('b875be0b-f5e6-401f-848f-51ba174c1ee5', 'a51d5683-ff67-4102-8cb9-f67fc0e7d4e3', 'bfe3d6f8-f4d8-482f-92f2-4f39cc5f696f', NULL, NULL, NULL, 'accepted', 'Source GroupLink 25398: archived=0; ccLinkType=STANDARD; joined date from effectiveDate; leaving date unknown.');


--
-- PostgreSQL database dump complete
--

\unrestrict pbH4boHz4oeuLlT2JcpgtZpeY16cSLXfkqmPuaBwUv3cQ9SLM2jQPfwef1KJbvJ

