--
-- PostgreSQL database dump
--

\restrict bxlzmZOd0kkq5h3JQHRdakHgCMbJu6dCvtgmfzQIEjVgV1dlYrRmr2xbT5gAhsd

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
	('6a2266d9-7315-4b3b-baf8-fd4dc948d71f', 'establishment-rebuild', 'GIAS BAU', 'gias_bau_test_local', '2026-10-06', '2026-10-06 13:51:16.603716+01', '2026-10-06 13:51:45.821957+01', 'completed', 'establishment-party-responsibility-v2', NULL);


--
-- Data for Name: source_snapshot; Type: TABLE DATA; Schema: migration; Owner: -
--

INSERT INTO migration.source_snapshot (source_snapshot_id, migration_run_id, source_system, source_database, snapshot_date, extract_name, created_at) VALUES
	('63ae5a46-b795-4dc9-9aca-df875b10eecb', '6a2266d9-7315-4b3b-baf8-fd4dc948d71f', 'GIAS BAU', 'gias_bau_test_local', '2026-10-06', 'establishment-party-136102-2777', '2026-10-06 13:51:34.120981+01'),
	('b9ecd9c8-8bc3-43d7-a207-0229ea208dd5', '6a2266d9-7315-4b3b-baf8-fd4dc948d71f', 'GIAS BAU', 'gias_bau_test_local', '2026-10-06', 'establishment-party-136102-2779', '2026-10-06 13:51:34.61824+01'),
	('1b081798-b1cd-4181-b451-a279bda6bd67', '6a2266d9-7315-4b3b-baf8-fd4dc948d71f', 'GIAS BAU', 'gias_bau_test_local', '2026-10-06', 'establishment-party-136102-4949', '2026-10-06 13:51:35.146984+01'),
	('fdfb9c86-9061-47fc-8be7-3f8852b97947', '6a2266d9-7315-4b3b-baf8-fd4dc948d71f', 'GIAS BAU', 'gias_bau_test_local', '2026-10-06', 'establishment-party-134314-23869', '2026-10-06 13:51:35.550397+01'),
	('b3184fca-fafb-49c5-a247-4b4fe936774a', '6a2266d9-7315-4b3b-baf8-fd4dc948d71f', 'GIAS BAU', 'gias_bau_test_local', '2026-10-06', 'establishment-party-134314-4737', '2026-10-06 13:51:36.090016+01'),
	('85df7bfc-7130-486c-a44d-12320805381d', '6a2266d9-7315-4b3b-baf8-fd4dc948d71f', 'GIAS BAU', 'gias_bau_test_local', '2026-10-06', 'establishment-party-134314-2914', '2026-10-06 13:51:36.666949+01'),
	('3ce80872-6765-4988-92fa-62cb0dea21a9', '6a2266d9-7315-4b3b-baf8-fd4dc948d71f', 'GIAS BAU', 'gias_bau_test_local', '2026-10-06', 'establishment-party-135905-3839', '2026-10-06 13:51:37.435835+01'),
	('ca4b042a-9e27-460a-95de-0a87587f09e0', '6a2266d9-7315-4b3b-baf8-fd4dc948d71f', 'GIAS BAU', 'gias_bau_test_local', '2026-10-06', 'establishment-party-137603-2055', '2026-10-06 13:51:37.90393+01'),
	('bb008cce-1cdf-4d7b-9f6a-d2c176dee924', '6a2266d9-7315-4b3b-baf8-fd4dc948d71f', 'GIAS BAU', 'gias_bau_test_local', '2026-10-06', 'establishment-party-137603-20364', '2026-10-06 13:51:38.361706+01'),
	('c673faa7-2c92-485d-8725-849e58ea16cc', '6a2266d9-7315-4b3b-baf8-fd4dc948d71f', 'GIAS BAU', 'gias_bau_test_local', '2026-10-06', 'organisation-group-1809', '2026-10-06 13:51:38.808042+01'),
	('e82dfa11-45cf-4937-bf26-d6cc79ea2b08', '6a2266d9-7315-4b3b-baf8-fd4dc948d71f', 'GIAS BAU', 'gias_bau_test_local', '2026-10-06', 'organisation-group-86052', '2026-10-06 13:51:39.256999+01');


--
-- Data for Name: source_record; Type: TABLE DATA; Schema: migration; Owner: -
--

INSERT INTO migration.source_record (source_record_id, source_snapshot_id, source_table, source_key, source_group_id, source_urn, source_row_hash) VALUES
	('4a8916e6-c0b2-46b1-91c4-95c893e08eb0', '63ae5a46-b795-4dc9-9aca-df875b10eecb', 'dbo.EstablishmentGroup/GroupLink', '2777:136102', '2777', 136102, NULL),
	('854c805c-4340-4f05-9840-84e06c71f891', 'b9ecd9c8-8bc3-43d7-a207-0229ea208dd5', 'dbo.EstablishmentGroup/GroupLink', '2779:136102', '2779', 136102, NULL),
	('b99dce92-7fe8-4a6a-9f99-eb16ed822169', '1b081798-b1cd-4181-b451-a279bda6bd67', 'dbo.EstablishmentGroup/GroupLink', '4949:136102', '4949', 136102, NULL),
	('c1b8a4f4-cf44-4ff3-873b-61a5733b544b', 'fdfb9c86-9061-47fc-8be7-3f8852b97947', 'dbo.EstablishmentGroup/GroupLink', '23869:134314', '23869', 134314, NULL),
	('7775965c-4b0e-47fb-ba60-b168ffa53791', 'b3184fca-fafb-49c5-a247-4b4fe936774a', 'dbo.EstablishmentGroup/GroupLink', '4737:134314', '4737', 134314, NULL),
	('23a56715-7a4e-420d-a33e-9261c2a4b793', '85df7bfc-7130-486c-a44d-12320805381d', 'dbo.EstablishmentGroup/GroupLink', '2914:134314', '2914', 134314, NULL),
	('8621bb0c-0db9-4013-a682-fb9eaa9b61b8', '3ce80872-6765-4988-92fa-62cb0dea21a9', 'dbo.EstablishmentGroup/GroupLink', '3839:135905', '3839', 135905, NULL),
	('1815b984-cadb-44c1-80b4-297f209968bb', 'ca4b042a-9e27-460a-95de-0a87587f09e0', 'dbo.EstablishmentGroup/GroupLink', '2055:137603', '2055', 137603, NULL),
	('4af10933-3b0d-497c-8e61-1a34529004bb', 'bb008cce-1cdf-4d7b-9f6a-d2c176dee924', 'dbo.EstablishmentGroup/GroupLink', '20364:137603', '20364', 137603, NULL),
	('aef1b3ad-5690-472f-9c95-ce6f869c89ed', 'c673faa7-2c92-485d-8725-849e58ea16cc', 'dbo.EstablishmentGroup/GroupLink', '1928', '1809', 109443, NULL),
	('96a5aa63-4b7d-4800-a2d0-2b4c719f702f', 'c673faa7-2c92-485d-8725-849e58ea16cc', 'dbo.EstablishmentGroup/GroupLink', '1929', '1809', 109613, NULL),
	('0af182b6-bbc7-46eb-888d-3ccb1e9a1c61', 'e82dfa11-45cf-4937-bf26-d6cc79ea2b08', 'dbo.EstablishmentGroup/GroupLink', '25390', '86052', 20338, NULL),
	('0e24d783-7670-4851-b17d-275db650c01d', 'e82dfa11-45cf-4937-bf26-d6cc79ea2b08', 'dbo.EstablishmentGroup/GroupLink', '25391', '86052', 20549, NULL),
	('e545b27f-9a97-48fb-ad93-2df30f7f948d', 'e82dfa11-45cf-4937-bf26-d6cc79ea2b08', 'dbo.EstablishmentGroup/GroupLink', '25392', '86052', 20614, NULL),
	('8b392222-1eae-4df2-9b15-c634c476633a', 'e82dfa11-45cf-4937-bf26-d6cc79ea2b08', 'dbo.EstablishmentGroup/GroupLink', '25395', '86052', 21363, NULL),
	('b1e9ddf9-e327-4cf0-8baa-2fa19134fbb6', 'e82dfa11-45cf-4937-bf26-d6cc79ea2b08', 'dbo.EstablishmentGroup/GroupLink', '25396', '86052', 22422, NULL),
	('55b06fae-5856-4f9f-9a81-8f500938d315', 'e82dfa11-45cf-4937-bf26-d6cc79ea2b08', 'dbo.EstablishmentGroup/GroupLink', '25394', '86052', 22459, NULL),
	('b27e1ae7-1fdd-450e-a519-0ce9c906c09b', 'e82dfa11-45cf-4937-bf26-d6cc79ea2b08', 'dbo.EstablishmentGroup/GroupLink', '25397', '86052', 22975, NULL),
	('c8e8210a-333e-4b9a-aafc-c5f6dbc59501', 'e82dfa11-45cf-4937-bf26-d6cc79ea2b08', 'dbo.EstablishmentGroup/GroupLink', '25393', '86052', 23004, NULL),
	('2e66811a-1e82-48b3-8add-a42732f83c8e', 'e82dfa11-45cf-4937-bf26-d6cc79ea2b08', 'dbo.EstablishmentGroup/GroupLink', '25398', '86052', 23122, NULL);


--
-- Data for Name: academy_trust_classification_evidence; Type: TABLE DATA; Schema: migration; Owner: -
--

INSERT INTO migration.academy_trust_classification_evidence (evidence_id, academy_trust_classification_id, source_record_id, assertion_rule, review_status, notes) VALUES
	('a15baab4-1868-4dcb-9d99-eab636a76341', 'e44022e0-e02c-452a-92fe-9625b763d607', '4a8916e6-c0b2-46b1-91c4-95c893e08eb0', 'MR001', 'accepted', NULL),
	('94dd7655-f2d0-45ed-a41e-e17bf57a8294', '4f474282-9c7b-4967-88ae-2a9b5e4333f5', '854c805c-4340-4f05-9840-84e06c71f891', 'MR005', 'accepted', NULL),
	('1b5cf4ba-c688-4eb3-98b0-4132e27f879f', '1b62624f-b75b-4a85-9be3-b268f4c6546a', 'c1b8a4f4-cf44-4ff3-873b-61a5733b544b', 'MR001', 'accepted', NULL),
	('6f73a1ee-6b9f-47b5-a06d-24ca9992e8dc', '6d966336-6dba-4f13-8f11-042326da2828', '8621bb0c-0db9-4013-a682-fb9eaa9b61b8', 'MR005', 'accepted', NULL),
	('e2cdbe1a-ae1d-4bff-b050-ba3c940c51e6', '9b2fc01f-2fe6-49b4-b6e2-d2bb688996e6', '1815b984-cadb-44c1-80b4-297f209968bb', 'MR005', 'accepted', 'T3: shared Group ID TR00009, UKPRN 10059335 and incorporation date; Companies House 07795736 supplied by MAT 20364. GroupRelationsLink 547 (2055 -> 20364, 1M) and 548 (20364 -> 2055, 1S) evidence classification transition 2021-03-30. Source GroupLink 4778 supplies the historical SAT responsibility start 2011-11-01; GroupLink 34277 supplies the current MAT responsibility start 2021-03-30. One continuing legal entity and role; separate SAT and MAT responsibilities. SAT responsibility end and initial SAT classification start unknown; classification dates are not copied into responsibility boundaries.'),
	('2f8573d0-18d6-42a3-8e61-c4641b462165', '9abe6b5b-1b89-47ce-8037-514e7eb90516', '4af10933-3b0d-497c-8e61-1a34529004bb', 'MR001', 'accepted', 'T3: shared Group ID TR00009, UKPRN 10059335 and incorporation date; Companies House 07795736 supplied by MAT 20364. GroupRelationsLink 547 (2055 -> 20364, 1M) and 548 (20364 -> 2055, 1S) evidence classification transition 2021-03-30. Source GroupLink 4778 supplies the historical SAT responsibility start 2011-11-01; GroupLink 34277 supplies the current MAT responsibility start 2021-03-30. One continuing legal entity and role; separate SAT and MAT responsibilities. SAT responsibility end and initial SAT classification start unknown; classification dates are not copied into responsibility boundaries.');


--
-- Data for Name: establishment_party_role_evidence; Type: TABLE DATA; Schema: migration; Owner: -
--

INSERT INTO migration.establishment_party_role_evidence (evidence_id, establishment_party_role_id, source_record_id, first_observed_date, end_date_basis, inference_rule, review_status, notes) VALUES
	('bdc81fa0-1ff4-4295-9cb2-467a3d8c8bb1', 'd5d273e6-adea-4a3b-886c-3c1632ac9e4b', '4a8916e6-c0b2-46b1-91c4-95c893e08eb0', NULL, NULL, NULL, 'accepted', NULL),
	('d4f20538-f823-4263-947a-fe51d283b796', '39d8bd36-73f0-4f10-a92d-33d055192a0e', '854c805c-4340-4f05-9840-84e06c71f891', NULL, NULL, NULL, 'accepted', NULL),
	('e1b625dd-7743-4e32-b3f7-882eaaa89899', '65211b18-24c0-4605-b69b-476183c5b6ed', 'c1b8a4f4-cf44-4ff3-873b-61a5733b544b', NULL, NULL, NULL, 'accepted', NULL),
	('a2817386-a87a-41c6-93a4-0f6381b76833', '76e4976d-0c24-4fd6-9a1c-895a4ca2c818', '8621bb0c-0db9-4013-a682-fb9eaa9b61b8', NULL, 'evidenced', NULL, 'accepted', NULL),
	('c5851a2d-2bfb-4f5f-9990-8d928a38a8fd', 'b026f18a-b3c8-4425-9e56-622c6a7c5d8f', '1815b984-cadb-44c1-80b4-297f209968bb', NULL, NULL, NULL, 'accepted', 'T3: shared Group ID TR00009, UKPRN 10059335 and incorporation date; Companies House 07795736 supplied by MAT 20364. GroupRelationsLink 547 (2055 -> 20364, 1M) and 548 (20364 -> 2055, 1S) evidence classification transition 2021-03-30. Source GroupLink 4778 supplies the historical SAT responsibility start 2011-11-01; GroupLink 34277 supplies the current MAT responsibility start 2021-03-30. One continuing legal entity and role; separate SAT and MAT responsibilities. SAT responsibility end and initial SAT classification start unknown; classification dates are not copied into responsibility boundaries.'),
	('2f44175a-5102-4849-82a6-9beb1dd5186c', 'b026f18a-b3c8-4425-9e56-622c6a7c5d8f', '4af10933-3b0d-497c-8e61-1a34529004bb', NULL, NULL, NULL, 'accepted', 'T3: shared Group ID TR00009, UKPRN 10059335 and incorporation date; Companies House 07795736 supplied by MAT 20364. GroupRelationsLink 547 (2055 -> 20364, 1M) and 548 (20364 -> 2055, 1S) evidence classification transition 2021-03-30. Source GroupLink 4778 supplies the historical SAT responsibility start 2011-11-01; GroupLink 34277 supplies the current MAT responsibility start 2021-03-30. One continuing legal entity and role; separate SAT and MAT responsibilities. SAT responsibility end and initial SAT classification start unknown; classification dates are not copied into responsibility boundaries.');


--
-- Data for Name: establishment_responsibility_evidence; Type: TABLE DATA; Schema: migration; Owner: -
--

INSERT INTO migration.establishment_responsibility_evidence (evidence_id, establishment_responsibility_id, source_record_id, first_observed_date, end_date_basis, inference_rule, review_status, notes) VALUES
	('2a506d3c-0efe-4e11-884c-a79af1e83313', '74c3455c-a8c6-456d-8cfd-3f30d0661afb', '4a8916e6-c0b2-46b1-91c4-95c893e08eb0', NULL, NULL, NULL, 'accepted', NULL),
	('397fe49b-4803-4849-b385-9ae263c99999', '04f342d3-94fe-40df-86e2-99437d0e4e36', '854c805c-4340-4f05-9840-84e06c71f891', NULL, NULL, NULL, 'accepted', NULL),
	('351a1071-8547-406b-86ac-c699b6ca7758', '82c694d4-949b-4ede-9cb2-e38bcf9b9366', 'c1b8a4f4-cf44-4ff3-873b-61a5733b544b', NULL, NULL, NULL, 'accepted', NULL),
	('69f0560a-6977-4d2c-956c-e723e47bd2ca', 'a6b5a447-9c19-4934-b81b-f78e5dbc790b', '8621bb0c-0db9-4013-a682-fb9eaa9b61b8', NULL, 'inferred', 'Responsibility end date inferred from the source establishment closure date.', 'accepted', NULL),
	('415d33cf-6370-40bd-9217-66dcd951b873', '426b11a3-d21b-4cb2-9680-917ff267a032', '1815b984-cadb-44c1-80b4-297f209968bb', NULL, NULL, NULL, 'accepted', 'T3: shared Group ID TR00009, UKPRN 10059335 and incorporation date; Companies House 07795736 supplied by MAT 20364. GroupRelationsLink 547 (2055 -> 20364, 1M) and 548 (20364 -> 2055, 1S) evidence classification transition 2021-03-30. Source GroupLink 4778 supplies the historical SAT responsibility start 2011-11-01; GroupLink 34277 supplies the current MAT responsibility start 2021-03-30. One continuing legal entity and role; separate SAT and MAT responsibilities. SAT responsibility end and initial SAT classification start unknown; classification dates are not copied into responsibility boundaries.'),
	('1d03bc76-ff01-4db5-9378-ef796fea03b9', '47711d2c-49f5-4d92-919e-5a996cd04c60', '4af10933-3b0d-497c-8e61-1a34529004bb', NULL, NULL, NULL, 'accepted', 'T3: shared Group ID TR00009, UKPRN 10059335 and incorporation date; Companies House 07795736 supplied by MAT 20364. GroupRelationsLink 547 (2055 -> 20364, 1M) and 548 (20364 -> 2055, 1S) evidence classification transition 2021-03-30. Source GroupLink 4778 supplies the historical SAT responsibility start 2011-11-01; GroupLink 34277 supplies the current MAT responsibility start 2021-03-30. One continuing legal entity and role; separate SAT and MAT responsibilities. SAT responsibility end and initial SAT classification start unknown; classification dates are not copied into responsibility boundaries.');


--
-- Data for Name: identity_resolution; Type: TABLE DATA; Schema: migration; Owner: -
--

INSERT INTO migration.identity_resolution (identity_resolution_id, source_record_id, target_entity_type, target_entity_id, resolution_method, confidence, decision_status, decided_at, decided_by, rationale) VALUES
	('a77a0262-c5c2-420e-8f0a-8daeede30c5f', '4a8916e6-c0b2-46b1-91c4-95c893e08eb0', 'legal_entity', 'afd36da5-3292-421f-af78-73e0d6d42405', 'companies-house-number', 'high', 'accepted', NULL, NULL, 'Resolved by companies-house-number. A new separate source party is not a verification of its registered legal identity; names do not authorise consolidation.'),
	('6e59221f-7fed-4fbc-9626-cb7e04b2d830', '854c805c-4340-4f05-9840-84e06c71f891', 'legal_entity', '41ff8d1d-d0ba-415e-ae39-3fdce680e460', 'companies-house-number', 'high', 'accepted', NULL, NULL, 'Resolved by companies-house-number. A new separate source party is not a verification of its registered legal identity; names do not authorise consolidation.'),
	('3a533c0a-beda-49f0-bae8-6a37c914e089', 'b99dce92-7fe8-4a6a-9f99-eb16ed822169', 'legal_entity', 'c4573ea5-4946-4971-85f9-cb73896bff75', 'new-separate-source-party', 'provisional', 'accepted', NULL, NULL, 'Resolved by new-separate-source-party. A new separate source party is not a verification of its registered legal identity; names do not authorise consolidation.'),
	('723aa20f-361c-4754-a57c-ae1149fbb614', 'c1b8a4f4-cf44-4ff3-873b-61a5733b544b', 'legal_entity', '26e99bb7-1198-4943-85ab-5404a0e9481b', 'companies-house-number', 'high', 'accepted', NULL, NULL, 'Resolved by companies-house-number. A new separate source party is not a verification of its registered legal identity; names do not authorise consolidation.'),
	('e03c8ffb-4ed3-4d53-bac7-74cc4bf58ba2', '7775965c-4b0e-47fb-ba60-b168ffa53791', 'legal_entity', '26e99bb7-1198-4943-85ab-5404a0e9481b', 'ukprn', 'high', 'accepted', NULL, NULL, 'Resolved by ukprn. A new separate source party is not a verification of its registered legal identity; names do not authorise consolidation.'),
	('b33b7fe1-b7e4-407b-9d0d-1cfc49d5a02b', '23a56715-7a4e-420d-a33e-9261c2a4b793', 'legal_entity', 'e2c14078-1d3b-444d-b6ff-1479b1394992', 'new-separate-source-party', 'provisional', 'accepted', NULL, NULL, 'Resolved by new-separate-source-party. A new separate source party is not a verification of its registered legal identity; names do not authorise consolidation.'),
	('f5b4efaa-4e88-4ec8-99c6-6b5118ca7aca', '8621bb0c-0db9-4013-a682-fb9eaa9b61b8', 'legal_entity', 'e19062e6-f475-4e3c-8aab-d08a91aedc6b', 'companies-house-number', 'high', 'accepted', NULL, NULL, 'Resolved by companies-house-number. A new separate source party is not a verification of its registered legal identity; names do not authorise consolidation.'),
	('3d639f7b-1b47-4a81-8787-d8f7ba4f185d', '1815b984-cadb-44c1-80b4-297f209968bb', 'legal_entity', 'ea91f652-ad88-4ae8-b02b-71778ee480da', 'shared-identifiers-and-explicit-sat-mat-transition', 'high', 'accepted', NULL, NULL, 'T3: shared Group ID TR00009, UKPRN 10059335 and incorporation date; Companies House 07795736 supplied by MAT 20364. GroupRelationsLink 547 (2055 -> 20364, 1M) and 548 (20364 -> 2055, 1S) evidence classification transition 2021-03-30. Source GroupLink 4778 supplies the historical SAT responsibility start 2011-11-01; GroupLink 34277 supplies the current MAT responsibility start 2021-03-30. One continuing legal entity and role; separate SAT and MAT responsibilities. SAT responsibility end and initial SAT classification start unknown; classification dates are not copied into responsibility boundaries.'),
	('c27c162f-7a93-4747-9659-76108f27d4c1', '4af10933-3b0d-497c-8e61-1a34529004bb', 'legal_entity', 'ea91f652-ad88-4ae8-b02b-71778ee480da', 'shared-identifiers-and-explicit-sat-mat-transition', 'high', 'accepted', NULL, NULL, 'T3: shared Group ID TR00009, UKPRN 10059335 and incorporation date; Companies House 07795736 supplied by MAT 20364. GroupRelationsLink 547 (2055 -> 20364, 1M) and 548 (20364 -> 2055, 1S) evidence classification transition 2021-03-30. Source GroupLink 4778 supplies the historical SAT responsibility start 2011-11-01; GroupLink 34277 supplies the current MAT responsibility start 2021-03-30. One continuing legal entity and role; separate SAT and MAT responsibilities. SAT responsibility end and initial SAT classification start unknown; classification dates are not copied into responsibility boundaries.');


--
-- Data for Name: organisation_group_member_evidence; Type: TABLE DATA; Schema: migration; Owner: -
--

INSERT INTO migration.organisation_group_member_evidence (evidence_id, organisation_group_member_id, source_record_id, first_observed_date, left_date_basis, inference_rule, review_status, notes) VALUES
	('da96bca8-a44f-4aff-b652-0ed1192188ff', '3c86ab87-d56c-492e-8e59-02e5d50fd917', 'aef1b3ad-5690-472f-9c95-ce6f869c89ed', NULL, NULL, NULL, 'accepted', 'Source GroupLink 1928: archived=0; linkType=HARD; joined date from effectiveDate; leaving date unknown.'),
	('63881a68-a32d-42ab-9fda-d226e83426ef', '73684d04-092f-4aba-b3d7-3341a61d356d', '96a5aa63-4b7d-4800-a2d0-2b4c719f702f', NULL, NULL, NULL, 'accepted', 'Source GroupLink 1929: archived=0; linkType=HARD; joined date from effectiveDate; leaving date unknown.'),
	('704abf51-a614-4c75-9f31-061b4478b310', 'b94191f1-0b27-4a00-a174-d12932223c20', '0e24d783-7670-4851-b17d-275db650c01d', NULL, NULL, NULL, 'accepted', 'Source GroupLink 25391: archived=0; ccLinkType=LEAD; joined date from effectiveDate; leaving date unknown.'),
	('0e03c4fc-b5d0-4c4e-9a9f-9a28acc051a1', 'c017b6ce-b1dc-47cc-bb04-52ab84203c0b', 'b1e9ddf9-e327-4cf0-8baa-2fa19134fbb6', NULL, NULL, NULL, 'accepted', 'Source GroupLink 25396: archived=0; ccLinkType=STANDARD; joined date from effectiveDate; leaving date unknown.'),
	('18eb8af0-fafa-44bd-9862-6ff36a652257', '759c57e4-9a8e-41be-aa76-90a7f22561c0', 'c8e8210a-333e-4b9a-aafc-c5f6dbc59501', NULL, NULL, NULL, 'accepted', 'Source GroupLink 25393: archived=0; ccLinkType=STANDARD; joined date from effectiveDate; leaving date unknown.'),
	('8b24e3e0-e8ea-4c7f-b06b-a4a688116818', 'f0b783a4-b735-4f1c-b57c-c0c675594588', 'b27e1ae7-1fdd-450e-a519-0ce9c906c09b', NULL, NULL, NULL, 'accepted', 'Source GroupLink 25397: archived=0; ccLinkType=STANDARD; joined date from effectiveDate; leaving date unknown.'),
	('622849ca-e622-4334-9e8d-e7a8e8506a0f', '38512300-2773-49ad-8acd-a22a951eb53d', '55b06fae-5856-4f9f-9a81-8f500938d315', NULL, NULL, NULL, 'accepted', 'Source GroupLink 25394: archived=0; ccLinkType=STANDARD; joined date from effectiveDate; leaving date unknown.'),
	('b3854527-fe22-4578-8c6f-bb3a05e34887', '61c11ff5-2ccb-4eda-ab68-86f3bd432ac5', 'e545b27f-9a97-48fb-ad93-2df30f7f948d', NULL, NULL, NULL, 'accepted', 'Source GroupLink 25392: archived=0; ccLinkType=STANDARD; joined date from effectiveDate; leaving date unknown.'),
	('14ce3960-d05b-43f7-a27c-a13ec718e5db', '4922e356-7495-4d7c-a18c-a77783e64ea1', '2e66811a-1e82-48b3-8add-a42732f83c8e', NULL, NULL, NULL, 'accepted', 'Source GroupLink 25398: archived=0; ccLinkType=STANDARD; joined date from effectiveDate; leaving date unknown.'),
	('1a929f9b-bd4a-4333-a24f-bd2392bf0a1e', '65c9e5bd-8d00-4837-a2df-d7e8c610ced4', '0af182b6-bbc7-46eb-888d-3ccb1e9a1c61', NULL, NULL, NULL, 'accepted', 'Source GroupLink 25390: archived=0; ccLinkType=STANDARD; joined date from effectiveDate; leaving date unknown.'),
	('a865e1b4-8a96-49c0-9ccf-071d0a282fe5', '2ebeb552-2cf0-46e6-af50-21f4c8abebce', '8b392222-1eae-4df2-9b15-c634c476633a', NULL, NULL, NULL, 'accepted', 'Source GroupLink 25395: archived=0; ccLinkType=STANDARD; joined date from effectiveDate; leaving date unknown.');


--
-- PostgreSQL database dump complete
--

\unrestrict bxlzmZOd0kkq5h3JQHRdakHgCMbJu6dCvtgmfzQIEjVgV1dlYrRmr2xbT5gAhsd

