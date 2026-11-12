--
-- PostgreSQL database dump
--

\restrict jX7SZbrLyElkaFRxwXkFpQUuhvXIXAvTZIuM5fFANvwgOTEulBbWHZYgcYvEAfF

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
	('e1a6327a-d009-4188-9e1b-7024a720b88f', 'City of London Corporation', 9, NULL, NULL, NULL),
	('b086cfb6-8e69-41bd-aabb-7c8280e0303c', 'London Borough of Camden', 9, NULL, NULL, NULL),
	('b59eda0d-f6e0-4ad9-8b0b-ac627e4025aa', 'Royal Borough of Greenwich', 9, NULL, NULL, NULL),
	('81c75ae1-8301-4525-a050-6955bdfa4779', 'London Borough of Hackney', 9, NULL, NULL, NULL),
	('287bdf12-6aef-4594-a075-78925c23bba6', 'London Borough of Hammersmith & Fulham', 9, NULL, NULL, NULL),
	('541af47a-2e3e-4d54-a5d7-6cea57348f64', 'London Borough of Islington', 9, NULL, NULL, NULL),
	('1a64cadb-fa10-49fe-bb99-3d2bfcfa0eee', 'Royal Borough of Kensington and Chelsea', 9, NULL, NULL, NULL),
	('f968439b-71db-4cb2-b232-1e7dbd92ecd1', 'London Borough of Lambeth', 9, NULL, NULL, NULL),
	('ae59b13a-8127-4417-83e4-9f7b677bf46f', 'London Borough of Lewisham', 9, NULL, NULL, NULL),
	('ee74e081-08c0-4a4b-b835-a777a0bf3da2', 'London Borough of Southwark', 9, NULL, NULL, NULL),
	('05bbf16c-664d-43de-82d9-127106fb01bf', 'London Borough of Tower Hamlets', 9, NULL, NULL, NULL),
	('fba0b2b9-b081-4a9a-9998-1f288138b0f4', 'London Borough of Wandsworth', 9, NULL, NULL, NULL),
	('a4f836d5-158f-4643-8ad1-55820a6d02f3', 'City of Westminster', 9, NULL, NULL, NULL),
	('2a01be7d-4171-45f3-982d-e6f4c7fb6d08', 'London Borough of Barking and Dagenham', 9, NULL, NULL, NULL),
	('b418bcfb-b7a1-4e06-8fc8-abefb368e2a8', 'London Borough of Barnet', 9, NULL, NULL, NULL),
	('c0f0dc1e-240a-44e0-a0d1-85557ea41bd4', 'London Borough of Bexley', 9, NULL, NULL, NULL),
	('a36e0503-0257-49c0-b2fe-fede9f990140', 'London Borough of Brent', 9, NULL, NULL, NULL),
	('d292b5da-c2c8-439f-943a-b77519e48a06', 'London Borough of Bromley', 9, NULL, NULL, NULL),
	('5a851616-ec93-498a-aed8-b9052dd78b2f', 'London Borough of Croydon', 9, NULL, NULL, NULL),
	('3b1ce9a8-2ab4-4215-a778-b95a5938afd5', 'London Borough of Ealing', 9, NULL, NULL, NULL),
	('af753f8e-2a47-466d-8fa2-1489b8ad9823', 'London Borough of Enfield', 9, NULL, NULL, NULL),
	('d34624f7-95b5-4629-acf9-7aa95160f7ba', 'London Borough of Haringey', 9, NULL, NULL, NULL),
	('97310377-f4c9-45cd-9acc-22f14a165640', 'London Borough of Harrow', 9, NULL, NULL, NULL),
	('682b27b6-fc2e-4734-ba33-ab96083bad02', 'London Borough of Havering', 9, NULL, NULL, NULL),
	('87b6ead5-d37e-48e1-a944-25b3364a3b13', 'London Borough of Hillingdon', 9, NULL, NULL, NULL),
	('d6d73dea-10eb-4b24-9cd9-e2ac8ade8e11', 'London Borough of Hounslow', 9, NULL, NULL, NULL),
	('f019d94a-2daa-4c8d-a45f-bf9e70cc0401', 'Royal Borough of Kingston upon Thames', 9, NULL, NULL, NULL),
	('6df12011-91bc-4df4-95cd-57f7a691cae9', 'London Borough of Merton', 9, NULL, NULL, NULL),
	('e55fed18-fbb5-4218-a6e2-46fefd8999a9', 'London Borough of Newham', 9, NULL, NULL, NULL),
	('97561530-a844-49d5-b345-235c69c66ae4', 'London Borough of Redbridge', 9, NULL, NULL, NULL),
	('90ddde1c-9c1c-4705-8495-c38da5c137f5', 'London Borough of Richmond upon Thames', 9, NULL, NULL, NULL),
	('eb5b0b5c-a949-4f27-87e2-47c2b20c2ab7', 'London Borough of Sutton', 9, NULL, NULL, NULL),
	('d2d454cd-322a-4885-adf8-5f5b1971c476', 'London Borough of Waltham Forest', 9, NULL, NULL, NULL),
	('942acd8c-ef18-4af1-8d40-0dadd1eadf5b', 'Birmingham City Council', 9, NULL, NULL, NULL),
	('85561b92-9620-44b2-9f12-8a272704daa9', 'Coventry City Council', 9, NULL, NULL, NULL),
	('bdb3bf08-b740-4014-bb5c-70f05595b43b', 'Dudley Metropolitan Borough Council', 9, NULL, NULL, NULL),
	('bc6bda39-2166-4720-b426-7cf7e96085c4', 'Sandwell Metropolitan Borough Council', 9, NULL, NULL, NULL),
	('ff00d301-1407-441c-8ec5-65271bf391ba', 'Solihull Metropolitan Borough Council', 9, NULL, NULL, NULL),
	('04878a1d-d789-4d14-befd-70cbd533c7b3', 'Walsall Metropolitan Borough Council', 9, NULL, NULL, NULL),
	('0e11f0eb-5761-406f-b9c8-fd01a4316870', 'City of Wolverhampton Council', 9, NULL, NULL, NULL),
	('fa3df49f-fa1f-4032-b8ec-d0f263dbee59', 'Knowsley Metropolitan Borough Council', 9, NULL, NULL, NULL),
	('41193d0a-bf29-494a-aaaf-05ac1ede2322', 'Liverpool City Council', 9, NULL, NULL, NULL),
	('33006a16-04f2-41a2-af19-d8a2876d6f04', 'St Helens Council', 9, NULL, NULL, NULL),
	('b4e1b686-613c-4013-8c3e-39ccebc94d37', 'Sefton Metropolitan Borough Council', 9, NULL, NULL, NULL),
	('e740c0fb-4283-437f-bda2-52aafd1a7e6a', 'Wirral Borough Council', 9, NULL, NULL, NULL),
	('e374c4f2-c99b-49a4-9449-ea94ecde7601', 'Bolton Metropolitan Borough Council', 9, NULL, NULL, NULL),
	('49707b1a-f355-43aa-a184-e2fce887d9c9', 'Bury Metropolitan Borough Council', 9, NULL, NULL, NULL),
	('56835c41-66a2-4764-b14b-92bb66468d42', 'Manchester City Council', 9, NULL, NULL, NULL),
	('017b9add-c648-49b7-a4c7-65f7de7c6c25', 'Oldham Metropolitan Borough Council', 9, NULL, NULL, NULL),
	('c87b6099-8be6-45c7-9d5c-433bcea32525', 'Rochdale Metropolitan Borough Council', 9, NULL, NULL, NULL),
	('446693e4-33a8-411d-8979-0d79932e7bc4', 'Salford City Council', 9, NULL, NULL, NULL),
	('5ae43dea-8870-4d5e-ad96-f5b307ad787a', 'Stockport Metropolitan Borough Council', 9, NULL, NULL, NULL),
	('077d3abb-b97a-4cba-8774-a5858ee13eba', 'Tameside Metropolitan Borough Council', 9, NULL, NULL, NULL),
	('b4503845-d24f-4dbc-a6b9-751293682f6f', 'Trafford Metropolitan Borough Council', 9, NULL, NULL, NULL),
	('cda5f0fb-4753-4518-928e-0e5a0eff3271', 'Wigan Metropolitan Borough Council', 9, NULL, NULL, NULL),
	('b502aae0-349b-404c-9752-c36e48ad9818', 'Barnsley Metropolitan Borough Council', 9, NULL, NULL, NULL),
	('03e9b947-740c-413f-8245-823e7cc3b19b', 'Doncaster Metropolitan Borough Council', 9, NULL, NULL, NULL),
	('a9f081bf-24a9-45f0-90e9-8ae9b823214e', 'Rotherham Metropolitan Borough Council', 9, NULL, NULL, NULL),
	('2db035a6-7e30-42b0-b20e-94964aec2dee', 'Sheffield City Council', 9, NULL, NULL, NULL),
	('5013072c-6e76-4a09-af30-90af79265c26', 'City of Bradford Metropolitan District Council', 9, NULL, NULL, NULL),
	('e5f200f3-b862-4aab-8bc0-3adc87d75171', 'Calderdale Metropolitan Borough Council', 9, NULL, NULL, NULL),
	('fc67db5d-45ed-4644-a507-a40ecd9994b2', 'Kirklees Council', 9, NULL, NULL, NULL),
	('a7feafff-a347-4c85-8656-169875a689ad', 'Leeds City Council', 9, NULL, NULL, NULL),
	('9b0fb1fb-1c56-4457-8af3-df326b9f98e6', 'Wakefield Metropolitan District Council', 9, NULL, NULL, NULL),
	('06c0ed0d-3e50-44af-87fd-974211357055', 'Gateshead Metropolitan Borough Council', 9, NULL, NULL, NULL),
	('c8c3ec0b-e506-4584-83b4-8bc4dc3ff171', 'Newcastle City Council', 9, NULL, NULL, NULL),
	('5034f523-bde4-4997-b61f-30853654a477', 'North Tyneside Council', 9, NULL, NULL, NULL),
	('a6ec94a0-0cea-404e-ba9a-09c01b9f11e8', 'South Tyneside Council', 9, NULL, NULL, NULL),
	('89b5e4f6-95eb-4a8f-854c-17c91059db2d', 'Sunderland City Council', 9, NULL, NULL, NULL),
	('673cbcfa-6f5b-4fab-b24c-7cf3009e88fc', 'Council of the Isles of Scilly', 9, NULL, NULL, NULL),
	('db6491ce-a480-46c0-ae1a-f91303f671e8', 'Isle of Anglesey County Council', 9, NULL, NULL, NULL),
	('dea03165-a419-45c1-bbe8-894ab6602408', 'Gwynedd Council', 9, NULL, NULL, NULL),
	('f1006fd8-7b85-42c7-bdca-469cc97fcba4', 'Conwy County Borough Council', 9, NULL, NULL, NULL),
	('3309c091-6209-4bd2-81f3-e953e66624cb', 'Denbighshire County Council', 9, NULL, NULL, NULL),
	('f719db8a-a59c-4839-9eb8-4113ec0f5d0c', 'Flintshire County Council', 9, NULL, NULL, NULL),
	('e0400e07-fa7f-46c5-bf78-d5bb2475f3ac', 'Wrexham County Borough Council', 9, NULL, NULL, NULL),
	('332c38fc-04d0-4f39-bc8e-b0f72c76bd43', 'Powys County Council', 9, NULL, NULL, NULL),
	('187c7041-14d8-4051-a649-d77ff5b10904', 'Ceredigion County Council', 9, NULL, NULL, NULL),
	('5ff98f3d-075e-4f15-a044-479c7d59d299', 'Pembrokeshire County Council', 9, NULL, NULL, NULL),
	('44258f9e-c5ca-4f47-826e-ea4448dc7b39', 'Carmarthenshire County Council', 9, NULL, NULL, NULL),
	('7c636518-736e-4660-a6bf-38cfcf2c9f39', 'Swansea Council', 9, NULL, NULL, NULL),
	('a03546d3-1adf-445e-b96e-9a25fc2b92f9', 'Neath Port Talbot County Borough Council', 9, NULL, NULL, NULL),
	('4dfd7688-147b-47b3-b883-e41426f22414', 'Bridgend County Borough Council', 9, NULL, NULL, NULL),
	('8b0462a5-9181-4529-8769-aca7ba890465', 'Vale of Glamorgan Council', 9, NULL, NULL, NULL),
	('cc3e154a-d2cb-4d25-9c3a-707887952b9b', 'Rhondda Cynon Taf County Borough Council', 9, NULL, NULL, NULL),
	('4f8da841-6ab3-46e6-a645-0847978e78e2', 'Merthyr Tydfil County Borough Council', 9, NULL, NULL, NULL),
	('e1de73cc-6c38-46d9-b9b9-0121f2a0bdf7', 'Caerphilly County Borough Council', 9, NULL, NULL, NULL),
	('2d4707c3-cf6a-4990-8606-bf1c614e1339', 'Blaenau Gwent County Borough Council', 9, NULL, NULL, NULL),
	('980fb43b-e022-4c74-974f-491a624704e5', 'Torfaen County Borough Council', 9, NULL, NULL, NULL),
	('0e8b54ba-0e91-4a63-8f9d-15a3720a4263', 'Monmouthshire County Council', 9, NULL, NULL, NULL),
	('cc753e92-609b-4670-b990-9e54bd98759a', 'Newport City Council', 9, NULL, NULL, NULL),
	('3f20db79-36c9-4313-a9af-1420703adb73', 'County Council of the City and County of Cardiff', 9, NULL, NULL, NULL),
	('2753d56d-7daa-4111-bc63-f5b7470035bb', 'Bath and North East Somerset Council', 9, NULL, NULL, NULL),
	('deaf4026-684d-452c-b80c-ed5a9db7ade2', 'Bristol City Council', 9, NULL, NULL, NULL),
	('51fadc3a-a181-43de-b550-52aa96da3e9c', 'North Somerset Council', 9, NULL, NULL, NULL),
	('c155281c-f98b-41bc-bb1a-1c2d8b044491', 'South Gloucestershire Council', 9, NULL, NULL, NULL),
	('e7bf23da-dfb1-464a-843c-24a483893614', 'Hartlepool Borough Council', 9, NULL, NULL, NULL),
	('7fd1ea14-0082-4dc3-b57b-b0b18b83776d', 'Middlesbrough Borough Council', 9, NULL, NULL, NULL),
	('4c5b6bf7-ffb5-4cf9-ac1f-874721ea2a03', 'Redcar and Cleveland Borough Council', 9, NULL, NULL, NULL),
	('a2e945f6-5f41-45b0-830b-f8c31901f5f5', 'Stockton-on-Tees Borough Council', 9, NULL, NULL, NULL),
	('77a62ab9-ad2a-4a1e-9afe-4ffd731a0439', 'Hull City Council', 9, NULL, NULL, NULL),
	('fa59d5bd-98f6-4a50-8082-2e7151bb13b8', 'East Riding of Yorkshire Council', 9, NULL, NULL, NULL),
	('26eeaff9-c310-43db-ad82-4c0bfda460b8', 'North East Lincolnshire Council', 9, NULL, NULL, NULL),
	('c2911c7b-31b4-44d7-8eab-2c65fcec2d92', 'North Lincolnshire Council', 9, NULL, NULL, NULL),
	('fb889851-0b87-4fce-b606-bf250ef492a3', 'City of York Council', 9, NULL, NULL, NULL),
	('2cc7068d-e2c1-4f89-bcf7-d254640fccce', 'Luton Borough Council', 9, NULL, NULL, NULL),
	('3802ccd1-0803-4817-bfc8-5188ccbf06e2', 'Bedford Borough Council', 9, NULL, NULL, NULL),
	('6fa0fa20-9beb-447f-bb7e-c55064758477', 'Central Bedfordshire Council', 9, NULL, NULL, NULL),
	('e4636164-5024-41ae-a628-fdda61a7ce3f', 'Buckinghamshire Council', 9, NULL, NULL, NULL),
	('67b5f616-39fe-4b31-b116-924192c6859c', 'Milton Keynes City Council', 9, NULL, NULL, NULL),
	('0604190a-2422-4c72-90b7-5684714a59ac', 'Derby City Council', 9, NULL, NULL, NULL),
	('b522b97d-8d52-4b79-bf36-bf671af9336a', 'Borough of Poole', 9, NULL, NULL, '2019-04-01'),
	('2f9a996e-ad57-4f99-8f3e-2ce482a1927f', 'Bournemouth Borough Council', 9, NULL, NULL, '2019-04-01'),
	('d5606470-d7c8-4ba5-9756-7a9895ebc1fd', 'Dorset Council', 9, NULL, NULL, NULL),
	('339df911-4d26-4c96-9952-39e09d8d3e16', 'Bournemouth, Christchurch and Poole Council', 9, NULL, NULL, NULL),
	('bbeb4921-d158-41b8-bc3f-cb69e816e97a', 'Darlington Borough Council', 9, NULL, NULL, NULL),
	('b28aa95b-78f3-43b0-88cb-eb3059f8d6e9', 'Brighton and Hove City Council', 9, NULL, NULL, NULL),
	('025bb820-d1f3-4453-86b8-9f38b5215eee', 'Portsmouth City Council', 9, NULL, NULL, NULL),
	('93ae56c8-97e3-4329-aa89-fb1aeb55b97d', 'Southampton City Council', 9, NULL, NULL, NULL),
	('975790b4-4ee9-4441-a221-0542a7643960', 'Leicester City Council', 9, NULL, NULL, NULL),
	('cc9bd538-c4e9-4d85-bf7b-71f1df6edc23', 'Rutland County Council', 9, NULL, NULL, NULL),
	('78ccc4b3-472c-4e62-9d53-9bded5d55fe3', 'Stoke-on-Trent City Council', 9, NULL, NULL, NULL),
	('b1de0c81-1379-4d63-809d-ff0776e9290a', 'Swindon Borough Council', 9, NULL, NULL, NULL),
	('f23d827d-4352-4a1e-ae6c-29d10933bec9', 'Bracknell Forest Council', 9, NULL, NULL, NULL),
	('9b0cbf0f-1631-4130-a947-614ee98dc9e0', 'Royal Borough of Windsor and Maidenhead', 9, NULL, NULL, NULL),
	('b36730b2-e5cb-4c99-8f59-735407239472', 'West Berkshire Council', 9, NULL, NULL, NULL),
	('fab48b2f-1c2e-4ced-a086-c500ac4df2d5', 'Reading Borough Council', 9, NULL, NULL, NULL),
	('cdd84a97-ddf2-4fbb-a7f2-d18b16870e62', 'Slough Borough Council', 9, NULL, NULL, NULL),
	('2ac7c2b6-53da-440a-a313-41c78eb35ad6', 'Wokingham Borough Council', 9, NULL, NULL, NULL),
	('b952d053-4fe3-4a17-bb21-8c1578788b48', 'Peterborough City Council', 9, NULL, NULL, NULL),
	('de79e58e-3465-45fa-8168-5f9f1ad00232', 'Halton Borough Council', 9, NULL, NULL, NULL),
	('2252b68e-9ecd-4199-bd4f-ba1961a25fc5', 'Warrington Borough Council', 9, NULL, NULL, NULL),
	('5827756d-86e3-4de5-8469-3f283f7720c4', 'Plymouth City Council', 9, NULL, NULL, NULL),
	('ef858f6b-3d2d-4d2a-a458-6e855b6aca27', 'Torbay Council', 9, NULL, NULL, NULL),
	('b360b238-6c52-4832-9043-6233078322b2', 'Southend-on-Sea Borough Council', 9, NULL, NULL, NULL),
	('324b4c97-a6f7-42b1-a0bb-691448804347', 'Thurrock Council', 9, NULL, NULL, NULL),
	('4dfdecda-ac8c-4253-abce-0354105dcd9a', 'Herefordshire Council', 9, NULL, NULL, NULL),
	('49d316d6-6cc0-45f3-a869-8380cea33cf5', 'Worcestershire County Council', 9, NULL, NULL, NULL),
	('705c1c08-2b8d-48fb-9fae-52ee96575424', 'Medway Council', 9, NULL, NULL, NULL),
	('bc6f073b-9831-466b-8488-b97fbf19f2b4', 'Blackburn with Darwen Borough Council', 9, NULL, NULL, NULL),
	('f8e65d35-b2db-4c0c-9f32-9069cf5525d0', 'Blackpool Borough Council', 9, NULL, NULL, NULL),
	('1f7e5cff-981d-4a19-b175-7976651532a0', 'Nottingham City Council', 9, NULL, NULL, NULL),
	('4c61a1bf-474a-4530-9e9b-783f74eef813', 'Telford & Wrekin Council', 9, NULL, NULL, NULL),
	('6f9bc24c-f6ca-4cbe-9946-8eeb13fc4884', 'Cheshire East Council', 9, NULL, NULL, NULL),
	('c6224d1d-e1dd-44f2-b9b4-79c6b57aab94', 'Cheshire West and Chester Council', 9, NULL, NULL, NULL),
	('f8cd82a7-4c45-483b-9ba6-75d46fff8ab6', 'Avon County Council', 9, NULL, NULL, '1996-04-01'),
	('f36d53bd-7d85-4040-af96-d22cff0ef708', 'Bedfordshire County Council', 9, NULL, NULL, '2009-04-01'),
	('ea046f10-de23-4dda-b3bf-2ca12e876bf2', 'Berkshire County Council', 9, NULL, NULL, '1998-04-01'),
	('5b5721c4-9f88-44cb-9302-e6130e8ed6e6', 'Buckinghamshire County Council', 9, NULL, NULL, '2020-04-01'),
	('bad2d713-bd8e-4c56-9435-ac404e51109a', 'Cambridgeshire County Council', 9, NULL, NULL, NULL),
	('fcf0f52a-1c8a-4090-a361-bcebfe4f6986', 'Cheshire County Council', 9, NULL, NULL, '2009-04-01'),
	('3944a193-a6f9-4a9a-aad6-219c83ff71ff', 'Cleveland County Council', 9, NULL, NULL, '1996-04-01'),
	('6c429195-ac5d-4622-843c-fe13aedbc0e0', 'Cornwall Council', 9, NULL, NULL, NULL),
	('052e2cf5-ebd4-4a10-af22-01dd41afe5c7', 'Cumbria County Council', 9, NULL, NULL, '2023-04-01'),
	('00081acf-dd3a-41c1-90d9-6be0dda47be2', 'Derbyshire County Council', 9, NULL, NULL, NULL),
	('5fe408d9-fb14-4acf-999d-f8caa9098401', 'Devon County Council', 9, NULL, NULL, NULL),
	('1b00df3e-1b56-4574-9bf9-cfd920c1e468', 'Dorset County Council', 9, NULL, NULL, '2019-04-01'),
	('9bc31c3b-a426-4c3b-aa93-9857e76a029c', 'Durham County Council', 9, NULL, NULL, NULL),
	('22743a4f-933c-4f60-ba3b-514714ce8752', 'East Sussex County Council', 9, NULL, NULL, NULL),
	('d58456a8-eb8a-4d44-bd48-9611fff6b332', 'Essex County Council', 9, NULL, NULL, NULL),
	('c0bab65a-1dda-451f-9012-638ae1078ebe', 'Gloucestershire County Council', 9, NULL, NULL, NULL),
	('e05aa0c3-07e2-45bd-a9ee-fd2e1e7ec3e2', 'Hampshire County Council', 9, NULL, NULL, NULL),
	('dc82f36a-c010-405b-ac23-985fc21c7cb3', 'Hereford and Worcester County Council', 9, NULL, NULL, '1998-04-01'),
	('df867651-16f1-4266-91f9-4509f3a9ac50', 'Hertfordshire County Council', 9, NULL, NULL, NULL),
	('97939759-3e3b-4c4a-a2b4-9ff9ebbc145c', 'Humberside County Council', 9, NULL, NULL, '1996-04-01'),
	('35d541a2-f11c-4778-99e8-4d779bd9da62', 'Isle of Wight Council', 9, NULL, NULL, NULL),
	('4eb78548-efa5-4688-85e2-0d3a01ecd786', 'Kent County Council', 9, NULL, NULL, NULL),
	('bbd501c2-2def-4e0c-b22a-ceb523d5ab56', 'Lancashire County Council', 9, NULL, NULL, NULL),
	('39ef0d98-239c-4f8f-9b5a-d8678df8c398', 'Leicestershire County Council', 9, NULL, NULL, NULL),
	('6b2e2c44-71c7-4ab6-800c-7202af3a9df3', 'Lincolnshire County Council', 9, NULL, NULL, NULL),
	('a95ba826-f1eb-4c64-80a2-9f147d9a4a7f', 'Norfolk County Council', 9, NULL, NULL, NULL),
	('53c392d9-9d44-4c5d-bf03-b2c39df95953', 'North Yorkshire Council', 9, NULL, NULL, NULL),
	('b05840c4-c612-478c-8243-56cc8542886f', 'Northamptonshire County Council', 9, NULL, NULL, '2021-04-01'),
	('de51de93-8ce1-49e2-8740-929dcc6cfccf', 'Northumberland County Council', 9, NULL, NULL, NULL),
	('5fb139ce-a696-4ac2-ba3a-445b361c206a', 'Nottinghamshire County Council', 9, NULL, NULL, NULL),
	('ba306a61-57b7-401a-891a-21302c0debf9', 'Oxfordshire County Council', 9, NULL, NULL, NULL),
	('64f34b7e-3413-4bcf-817a-c8024a243b32', 'Shropshire Council', 9, NULL, NULL, NULL),
	('fbd8faf4-3dbe-4410-81c0-ce0891128d5a', 'Somerset Council', 9, NULL, NULL, NULL),
	('dc951090-305e-42e5-aaa3-5ebccd8ef9f7', 'Staffordshire County Council', 9, NULL, NULL, NULL),
	('1a88dac3-1035-481a-89e9-a53036c47a51', 'Suffolk County Council', 9, NULL, NULL, NULL),
	('30783fab-3dcc-4091-b26a-af8907c0dfd1', 'Surrey County Council', 9, NULL, NULL, NULL),
	('a1e1223a-8442-424c-8b9f-59714899a9b0', 'Warwickshire County Council', 9, NULL, NULL, NULL),
	('cf576508-e284-4938-9c4d-ea3439e92f75', 'West Sussex County Council', 9, NULL, NULL, NULL),
	('5ef4014b-53b5-4283-95d9-02a053ecee56', 'Wiltshire Council', 9, NULL, NULL, NULL),
	('058cc7ab-9391-4aa6-9ba4-93a8cd4e378b', 'North Northamptonshire Council', 9, NULL, NULL, NULL),
	('0e0e4de8-f04e-428a-ab29-ef1bc67cb376', 'West Northamptonshire Council', 9, NULL, NULL, NULL),
	('1c20b22f-1f5c-41d6-a3ff-3696e4522a15', 'Cumberland Council', 9, NULL, NULL, NULL),
	('41272cc4-45fc-499e-bf6c-ffe78ce50b9b', 'Westmorland and Furness Council', 9, NULL, NULL, NULL);


--
-- Data for Name: academy_trust_classification; Type: TABLE DATA; Schema: establishment; Owner: -
--



--
-- Data for Name: address; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.address (address_id, address_line_1, address_line_2, address_line_3, town, county, postcode) VALUES
	('31bd97a4-3ffe-44f4-a03c-747adfdb8a54', 'obfuscated', NULL, NULL, 'obfuscated', '099', 'NW1 3EX'),
	('1c86eb7d-4149-4275-a2d0-bbb6e50ecbee', 'obfuscated', 'Milton Ernest', NULL, 'obfuscated', '001', 'MK44 1RF'),
	('457591a1-928f-49ed-8d27-87397a2a2860', 'obfuscated', 'Scawsby', NULL, 'obfuscated', '031', 'DN5 7UB');


--
-- Data for Name: establishment; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment (establishment_id, urn, ukprn, establishment_number, name, establishment_type_id, ofsted_link, education_phase_id, further_education_type_id, section_41_approval_status_id, religious_character_id, religious_ethos_id, diocese_id) VALUES
	('1e5f4b3b-9f3e-4a32-8b06-0a8bbdd960d3', 100018, 10069172, 2436, 'Netley Primary School & Centre for Autism', 1, 'https://reports.ofsted.gov.uk/search?q=100018', 2, NULL, NULL, NULL, NULL, NULL),
	('e9dd8a63-cefe-4c2e-b1ec-ee9d0875b25e', 109613, 10075753, 3023, 'Milton Ernest CofE Primary School', 3, 'https://reports.ofsted.gov.uk/search?q=109613', 2, NULL, NULL, 2, NULL, 'be8dd938-8147-44d4-9641-ed1342218405'),
	('ed87bf46-7fca-42e3-ad14-1df78b70f411', 137603, 10035482, 4033, 'Ridgewood School', 34, 'https://reports.ofsted.gov.uk/search?q=137603', 4, NULL, NULL, NULL, NULL, NULL);


--
-- Data for Name: capacity_and_pupil_measures; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.capacity_and_pupil_measures (capacity_and_pupil_measures_id, establishment_id, school_capacity, pupil_count, free_school_meal_measure, census_date) VALUES
	('e21b78d7-c9c4-4050-b771-5828fa7da0c9', '1e5f4b3b-9f3e-4a32-8b06-0a8bbdd960d3', 65801, 383, 224, '2026-01-15'),
	('69778766-3063-4cc6-8b93-0b58285167c2', 'e9dd8a63-cefe-4c2e-b1ec-ee9d0875b25e', 63964, 67, 5, '2026-01-15'),
	('2362242c-f062-4b0d-b3f8-da5898a0b828', 'ed87bf46-7fca-42e3-ad14-1df78b70f411', 1512, 1425, 250, '2026-01-15');


--
-- Data for Name: education_admissions_and_provision; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.education_admissions_and_provision (education_admissions_and_provision_id, establishment_id, gender_of_entry_type_id, admissions_policy_id, boarding_provision_id, nursery_provision_id, sixth_form_provision_id, has_special_classes) VALUES
	('104392bc-0a12-4985-98e3-48a823f1cf38', '1e5f4b3b-9f3e-4a32-8b06-0a8bbdd960d3', 3, NULL, 1, 1, 2, true),
	('068629a5-cf2f-44c9-b82b-47dedc4fe31f', 'e9dd8a63-cefe-4c2e-b1ec-ee9d0875b25e', 3, NULL, 1, 2, 2, false),
	('dab403a3-1a62-4988-ba63-15dcc75d7084', 'ed87bf46-7fca-42e3-ad14-1df78b70f411', 3, NULL, 1, NULL, 1, true);


--
-- Data for Name: establishment_contact; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_contact (establishment_contact_id, establishment_id, website, telephone_number) VALUES
	('ea9bf1a1-d9e0-4785-9222-818dd973ad32', '1e5f4b3b-9f3e-4a32-8b06-0a8bbdd960d3', 'www.netley.camden.sch.uk/', '111111'),
	('6c654684-e349-4498-baae-252accd58b2a', 'e9dd8a63-cefe-4c2e-b1ec-ee9d0875b25e', 'www.ewmeschools.org.uk', '111111'),
	('07b9106f-927e-44dc-87f4-841385adb148', 'ed87bf46-7fca-42e3-ad14-1df78b70f411', 'http://www.ridgewoodschool.co.uk', '111111');


--
-- Data for Name: establishment_geography; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_geography (establishment_geography_id, establishment_id, local_authority_area_id, government_office_region_id, district_administrative_id, administrative_ward_id, parliamentary_constituency_id, lsoa_id, msoa_id, urban_rural_id) VALUES
	('c0980a0c-37cb-41f7-af3b-9672485f5ef2', '1e5f4b3b-9f3e-4a32-8b06-0a8bbdd960d3', '0956c9af-2de2-4dea-94ed-b5c432eae45f', '1375841f-e6ba-4cda-9fac-753ff9df93a2', 'f2665403-6621-493d-8a2d-8de9ae1f1c4a', '2aebb958-956d-4800-a776-00aac3556316', '90dee41f-c934-4b2d-9d52-b42e83fdfe88', '94fb01a9-81ec-4a90-88a6-4ad2a8db4ba9', '4cdb54e5-d81b-45d9-b218-65030aab6d87', 25),
	('589c0b15-a208-4368-a406-dd4de07804b0', 'e9dd8a63-cefe-4c2e-b1ec-ee9d0875b25e', '942f0927-84a7-43b6-8be9-68f88917b043', '32e46d74-0ebf-495b-8261-2c508cd2c2bb', '1146af1e-822e-49f1-a51e-da31f849045c', 'f08ea39d-20ae-4f5e-8274-15207e7b5eec', 'd180f323-3f6f-44dc-a1de-d1cac6e11c0c', '534b5a89-c075-4962-8367-8c8ffc158b9e', 'edc1ad99-4391-4d91-8717-6c10929ae180', 23),
	('7464a034-417e-4a0b-8955-aa813872ad79', 'ed87bf46-7fca-42e3-ad14-1df78b70f411', '77b9cfe6-842e-41c8-9be4-410cac32719a', 'f5cdf1f1-5f75-4420-b597-862614e13549', '05471fcf-d815-4c82-a7f6-6a9ff75cdaa2', 'cf41c2bc-c0cc-4394-992e-1db6d9f032dd', '8d116d07-483e-41bc-83ea-00c89c3f3a6d', 'c4402a6f-a614-4961-a889-554ef686642a', '011465c5-0d85-498d-8b85-14ea8833c9d5', 25);


--
-- Data for Name: establishment_lifecycle; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_lifecycle (establishment_lifecycle_id, establishment_id, establishment_status_id, open_date, close_date, reason_establishment_opened_id, reason_establishment_closed_id, last_changed_date) VALUES
	('525210da-5f69-4a65-b55c-8fdaf0d06878', '1e5f4b3b-9f3e-4a32-8b06-0a8bbdd960d3', 1, NULL, NULL, NULL, NULL, '2026-06-23'),
	('087fcd48-6620-424b-86b8-7a8f86773086', 'e9dd8a63-cefe-4c2e-b1ec-ee9d0875b25e', 1, NULL, NULL, NULL, NULL, '2026-06-23'),
	('b2fc72e8-4c1e-4d47-ad02-e0c642f2509b', 'ed87bf46-7fca-42e3-ad14-1df78b70f411', 1, '2011-11-01', NULL, 10, NULL, '2026-06-23');


--
-- Data for Name: person; Type: TABLE DATA; Schema: establishment; Owner: -
--



--
-- Data for Name: establishment_party_role; Type: TABLE DATA; Schema: establishment; Owner: -
--



--
-- Data for Name: establishment_responsibility; Type: TABLE DATA; Schema: establishment; Owner: -
--



--
-- Data for Name: site; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.site (site_id, address_id, site_name, uprn) VALUES
	('35d72dbf-ebbf-4f2f-b730-967a7789b1ae', '31bd97a4-3ffe-44f4-a03c-747adfdb8a54', NULL, 5172210),
	('df36c20c-08a0-41e0-b71f-d7b3520a5544', '1c86eb7d-4149-4275-a2d0-bbb6e50ecbee', NULL, 100081212588),
	('28baba62-40ee-4340-b925-c2d9638cdbff', '457591a1-928f-49ed-8d27-87397a2a2860', NULL, 10006581609);


--
-- Data for Name: establishment_to_site; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_to_site (establishment_to_site_id, establishment_id, site_id, is_main_site) VALUES
	('0a149265-a1f7-4966-b489-5090b58b5a6f', '1e5f4b3b-9f3e-4a32-8b06-0a8bbdd960d3', '35d72dbf-ebbf-4f2f-b730-967a7789b1ae', true),
	('5ad828dd-db9f-400f-823c-d0dc6e421879', 'e9dd8a63-cefe-4c2e-b1ec-ee9d0875b25e', 'df36c20c-08a0-41e0-b71f-d7b3520a5544', true),
	('5b241bbd-e826-4604-9bdc-16c7921ed4c0', 'ed87bf46-7fca-42e3-ad14-1df78b70f411', '28baba62-40ee-4340-b925-c2d9638cdbff', true);


--
-- Data for Name: organisation_group; Type: TABLE DATA; Schema: establishment; Owner: -
--



--
-- Data for Name: group_identifier; Type: TABLE DATA; Schema: establishment; Owner: -
--



--
-- Data for Name: legal_entity_address; Type: TABLE DATA; Schema: establishment; Owner: -
--



--
-- Data for Name: legal_entity_partner; Type: TABLE DATA; Schema: establishment; Owner: -
--



--
-- Data for Name: legal_entity_sole_trader; Type: TABLE DATA; Schema: establishment; Owner: -
--



--
-- Data for Name: local_authority_area_council_period; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.local_authority_area_council_period (local_authority_area_council_period_id, local_authority_area_id, legal_entity_id, start_date, end_date, is_current) VALUES
	('22188ad3-5b9e-41e4-8c69-384d892075e6', '10279260-69e5-4534-9feb-30c48c6d9b06', 'e1a6327a-d009-4188-9e1b-7024a720b88f', NULL, NULL, true),
	('9e68bebb-561d-45b5-9404-0c7aa1ae2075', '0956c9af-2de2-4dea-94ed-b5c432eae45f', 'b086cfb6-8e69-41bd-aabb-7c8280e0303c', NULL, NULL, true),
	('7c33384f-61a2-4f35-ac6a-fd4e3395be55', '41ee14e6-dabb-4874-af14-2c93e5adebfa', 'b59eda0d-f6e0-4ad9-8b0b-ac627e4025aa', NULL, NULL, true),
	('14177ffc-bb4b-4977-bfa9-baf11f4474c6', 'a916541b-fd17-42f4-a8ac-186326f3817c', '81c75ae1-8301-4525-a050-6955bdfa4779', NULL, NULL, true),
	('469279e6-c539-45c9-9629-507667ddc8fb', '6617fc31-5146-429b-8b1a-2b8a7c37204c', '287bdf12-6aef-4594-a075-78925c23bba6', NULL, NULL, true),
	('eb7d56e8-a6a2-4b0d-b096-733d749ae302', '3574e75c-8870-449a-82e7-1b083e2efc42', '541af47a-2e3e-4d54-a5d7-6cea57348f64', NULL, NULL, true),
	('3e614576-cd6d-42d1-abe0-c578b7de799f', '6e8b3ded-c1b4-4a2f-817e-b9bfd3aa3e86', '1a64cadb-fa10-49fe-bb99-3d2bfcfa0eee', NULL, NULL, true),
	('31192324-3797-4260-bc32-136bfc85a95a', 'b9f9a0d5-74cb-4bd4-b205-2b8c8fdf3697', 'f968439b-71db-4cb2-b232-1e7dbd92ecd1', NULL, NULL, true),
	('e4390ff3-3247-46c6-b4bb-f15b8cfbcbe2', '5167896b-40e6-420c-8510-45c4106ac301', 'ae59b13a-8127-4417-83e4-9f7b677bf46f', NULL, NULL, true),
	('5678925e-3e64-4ed4-9141-5feb3a3b8424', 'c0b0dbb1-9d64-4b93-9a52-6fe463541bc1', 'ee74e081-08c0-4a4b-b835-a777a0bf3da2', NULL, NULL, true),
	('4a589292-ea90-4c7d-a346-0fdfd170af7e', '20011641-8b10-45f9-acb2-4766b159b17d', '05bbf16c-664d-43de-82d9-127106fb01bf', NULL, NULL, true),
	('1e87890c-55e6-412e-a247-51a41821e582', '22b946b9-bc4f-4687-9177-31680e369c9c', 'fba0b2b9-b081-4a9a-9998-1f288138b0f4', NULL, NULL, true),
	('c443a31d-cc09-4651-999c-03ffd8ddcafa', '4f47e935-0285-478e-af4d-ce3220c144d1', 'a4f836d5-158f-4643-8ad1-55820a6d02f3', NULL, NULL, true),
	('4e754ac0-b8bd-4e63-8a85-dbe77b682ff9', 'dd41d40d-7a3b-469c-b49d-930cbe7d0dd5', '2a01be7d-4171-45f3-982d-e6f4c7fb6d08', NULL, NULL, true),
	('262ee09c-094a-48d1-b692-88806f6e0ece', '29a27929-4bba-49b9-8fb7-fbf94257fff8', 'b418bcfb-b7a1-4e06-8fc8-abefb368e2a8', NULL, NULL, true),
	('efd5e4d5-83cd-483c-80d2-e77de4b35d1a', '75379562-3c0b-4270-944d-22df468d3cf7', 'c0f0dc1e-240a-44e0-a0d1-85557ea41bd4', NULL, NULL, true),
	('d58aaaa8-f5c4-4331-9e45-8638d2b44051', '9ff7ac3e-71c5-4eb7-b74c-4a83a229261e', 'a36e0503-0257-49c0-b2fe-fede9f990140', NULL, NULL, true),
	('28f5227b-7b68-4ec9-b822-b215e0cb5f60', '5fc312d8-9428-4ee3-a9ed-9b204c8be91c', 'd292b5da-c2c8-439f-943a-b77519e48a06', NULL, NULL, true),
	('dc2b2db1-f55e-48ed-8d48-a522ac4b7563', 'b852b15b-c92e-4f4c-a014-5a99cdf7025b', '5a851616-ec93-498a-aed8-b9052dd78b2f', NULL, NULL, true),
	('c1ddfcec-96d0-489c-a30a-134e65bc21ea', 'fe174e6d-3642-4892-bd26-8a1dd3ad5d59', '3b1ce9a8-2ab4-4215-a778-b95a5938afd5', NULL, NULL, true),
	('08b4a0ab-49b8-4807-918f-00427be54afb', '987bd60d-dd0c-4707-818f-d4aeb184a7b8', 'af753f8e-2a47-466d-8fa2-1489b8ad9823', NULL, NULL, true),
	('d5cecb12-fff1-4435-a08f-200592751b62', 'c83c49ad-6125-4936-ac35-e8f804f49ba8', 'd34624f7-95b5-4629-acf9-7aa95160f7ba', NULL, NULL, true),
	('9c7e1427-1a32-4d56-8425-debb21ddc5fb', 'd9936778-b559-4d95-aedc-cffea5d3a18f', '97310377-f4c9-45cd-9acc-22f14a165640', NULL, NULL, true),
	('87d808b0-7ae0-41bd-8a62-15167a0f5a15', 'd818eaaa-a1ae-44cc-b02e-98fbeb4dc406', '682b27b6-fc2e-4734-ba33-ab96083bad02', NULL, NULL, true),
	('f8c2f78d-35a2-4af7-8ce4-8ffe543ebf32', '3eb4bca9-62d4-4b5d-96e7-69693099d354', '87b6ead5-d37e-48e1-a944-25b3364a3b13', NULL, NULL, true),
	('a92b12ce-cc1c-4166-a7b0-b05873cb6882', 'e10c2651-5a62-4b95-bb0b-2f81c55c6467', 'd6d73dea-10eb-4b24-9cd9-e2ac8ade8e11', NULL, NULL, true),
	('3f67a566-78f8-4317-936f-afcb8a9f74e9', '709d8fff-6108-4446-9ec0-d648b85c4683', 'f019d94a-2daa-4c8d-a45f-bf9e70cc0401', NULL, NULL, true),
	('70421737-5242-4cd6-ba58-437ae162d24f', 'c22f0cc4-052e-44b6-a13d-308e877a16e3', '6df12011-91bc-4df4-95cd-57f7a691cae9', NULL, NULL, true),
	('9a27eabf-8fc0-47c3-8cc6-c876b87b5a9f', '0abdf041-18e4-487d-9eac-f30657f66ebd', 'e55fed18-fbb5-4218-a6e2-46fefd8999a9', NULL, NULL, true),
	('90b2a825-08dc-4286-9f27-c51025a8e460', '4efdbb20-4c85-4e3c-abe7-6de1186e5990', '97561530-a844-49d5-b345-235c69c66ae4', NULL, NULL, true),
	('17c34561-0785-44c8-9bdf-a56936b579f6', '3e8db405-e3da-4b0d-9a31-1f88061ee3b4', '90ddde1c-9c1c-4705-8495-c38da5c137f5', NULL, NULL, true),
	('2496caf0-0485-495d-a9a8-ecebfdd7081d', '34427472-2794-4f4b-9bf3-d17e2b945133', 'eb5b0b5c-a949-4f27-87e2-47c2b20c2ab7', NULL, NULL, true),
	('8fe6b81f-1e2a-4fc1-8f99-4f01aa521b01', '4f674528-165a-40a0-b3fc-b8588fcc5241', 'd2d454cd-322a-4885-adf8-5f5b1971c476', NULL, NULL, true),
	('6d7be1de-e582-4379-82b3-52a651b7ca5f', '2331ef34-0efc-46ff-bd37-a5046d40a753', '942acd8c-ef18-4af1-8d40-0dadd1eadf5b', NULL, NULL, true),
	('4f185830-9aef-4b43-8415-713b306d9853', '33a476dc-5eb8-4150-9a06-6364f8130bbe', '85561b92-9620-44b2-9f12-8a272704daa9', NULL, NULL, true),
	('b045b40c-f5a3-4259-add7-29203da70b36', '1b0ebe93-3b10-4663-98b5-a096c63e8040', 'bdb3bf08-b740-4014-bb5c-70f05595b43b', NULL, NULL, true),
	('712f9348-68b6-42c9-a81f-0139d6f9445f', 'cb3f41c9-3a3c-4632-8b67-2ecf69b670fc', 'bc6bda39-2166-4720-b426-7cf7e96085c4', NULL, NULL, true),
	('eb90577b-fb22-49ad-88ab-450e5b57d4e7', '24403d37-2f07-4bbb-bd2d-f7e1fadf7fbf', 'ff00d301-1407-441c-8ec5-65271bf391ba', NULL, NULL, true),
	('cf8e81d8-500f-457f-9eac-fdbb3c9b6a97', 'db38471e-2843-4e5a-9712-1d8fc220f3de', '04878a1d-d789-4d14-befd-70cbd533c7b3', NULL, NULL, true),
	('202617f6-fffe-4975-b5b0-65b79a20144e', '3cc794db-378c-4fd1-b201-dcd8078462e6', '0e11f0eb-5761-406f-b9c8-fd01a4316870', NULL, NULL, true),
	('fb3c91af-d4c2-456b-b126-69ce8ec03111', '00b4455a-6f3e-4b8e-8399-b7db5455d306', 'fa3df49f-fa1f-4032-b8ec-d0f263dbee59', NULL, NULL, true),
	('26e9b014-9d16-468f-a0a5-8096f4cb7422', 'df763548-f436-42d8-ae03-ddcc7cf6d77c', '41193d0a-bf29-494a-aaaf-05ac1ede2322', NULL, NULL, true),
	('b4cd29cf-805e-4ac3-8ff9-fbfc7e23a0b9', '35b43617-d7aa-45b7-8031-07494aa5c136', '33006a16-04f2-41a2-af19-d8a2876d6f04', NULL, NULL, true),
	('5f3810c3-5e7c-4125-bdc7-d010d49bbea9', 'c74da403-1c0d-480d-bd31-a548a7305e80', 'b4e1b686-613c-4013-8c3e-39ccebc94d37', NULL, NULL, true),
	('648d019e-c24f-4d58-9f42-79a0dd1cd961', '1b99670e-0e47-46d4-b618-b7ee0ed45f14', 'e740c0fb-4283-437f-bda2-52aafd1a7e6a', NULL, NULL, true),
	('1a5c3bda-103c-4f5e-8e68-6ac487ad3377', '7a6803d6-c5fa-47ff-97af-7e13757750b0', 'e374c4f2-c99b-49a4-9449-ea94ecde7601', NULL, NULL, true),
	('e84bc2bc-f8c2-40a4-80eb-befcf7def6c9', '353acfff-cbbe-4a26-817a-a4e6e0875c5c', '49707b1a-f355-43aa-a184-e2fce887d9c9', NULL, NULL, true),
	('59ef7cc9-edfc-4102-af49-3bbdc828fcc7', '0a78f87e-d71b-44c3-b598-2cc2b8038e95', '56835c41-66a2-4764-b14b-92bb66468d42', NULL, NULL, true),
	('2752aff9-a48a-4da4-949c-cedb0c55a26a', '2625193c-09d9-45a7-bcb2-b1dcdf077b61', '017b9add-c648-49b7-a4c7-65f7de7c6c25', NULL, NULL, true),
	('44d8139c-192c-41b7-b88a-969a3b67b22a', '5601040a-cd9c-499f-b38a-f7a77479cd7f', 'c87b6099-8be6-45c7-9d5c-433bcea32525', NULL, NULL, true),
	('b9549963-6ac0-4eef-a420-1a7f2cf0c986', 'e7fbed96-c797-4709-92c8-310ec0c3245c', '446693e4-33a8-411d-8979-0d79932e7bc4', NULL, NULL, true),
	('d96696c2-c6eb-48ad-be85-19c26aa058e9', 'e9345306-86a0-442b-bafa-4ebcfd1a877c', '5ae43dea-8870-4d5e-ad96-f5b307ad787a', NULL, NULL, true),
	('e91ac3ba-50fc-4274-8392-df2137cea1ef', '2e8478cf-6cbc-424a-ade1-050239c7d330', '077d3abb-b97a-4cba-8774-a5858ee13eba', NULL, NULL, true),
	('f818203a-743a-460f-8d73-721ff6a36c68', '7734fb10-1f0f-49da-b13f-e3c538beb17a', 'b4503845-d24f-4dbc-a6b9-751293682f6f', NULL, NULL, true),
	('ece0f094-d7ac-4c34-97ff-85329f4de924', '2601da0a-6f35-4c15-984e-f4482d1df384', 'cda5f0fb-4753-4518-928e-0e5a0eff3271', NULL, NULL, true),
	('e25fc786-37bd-4c4b-8227-667a41ff7e0c', 'bcbf9ead-5cd3-4616-b0ba-c805d60bb7e7', 'b502aae0-349b-404c-9752-c36e48ad9818', NULL, NULL, true),
	('fd662202-1bbc-45b7-8a5b-0c14701e840a', '77b9cfe6-842e-41c8-9be4-410cac32719a', '03e9b947-740c-413f-8245-823e7cc3b19b', NULL, NULL, true),
	('59d67913-b1af-46ef-81ce-d4c7909a5f28', 'fdb10144-ddb3-4a5a-9eae-21a3da07031b', 'a9f081bf-24a9-45f0-90e9-8ae9b823214e', NULL, NULL, true),
	('c804fab4-f837-4759-b69e-44a03b3e4450', '0881090c-70bc-486a-a74c-6c3754f93c88', '2db035a6-7e30-42b0-b20e-94964aec2dee', NULL, NULL, true),
	('f3745ff4-f373-4aae-bcb6-c6fe7d58aec5', '74887ed3-ff4f-45a9-b9bf-22e9aec0fa66', '5013072c-6e76-4a09-af30-90af79265c26', NULL, NULL, true),
	('0ce205fe-5ac1-4951-9852-5b25357cfba5', '31e56f49-2fb5-4b09-a80f-cceebcce7e07', 'e5f200f3-b862-4aab-8bc0-3adc87d75171', NULL, NULL, true),
	('46d7f2c5-307a-4ac0-93d2-bbd9a0f7e254', 'a7a2261a-963a-4396-a976-98a6a39c7936', 'fc67db5d-45ed-4644-a507-a40ecd9994b2', NULL, NULL, true),
	('b892c36d-a317-4257-8708-ede11bfa8bc2', 'e62b9c65-4a77-474c-a2a3-0cf0f70ca2e3', 'a7feafff-a347-4c85-8656-169875a689ad', NULL, NULL, true),
	('103b2f56-c476-4143-b4d3-d7784d6ed825', '7788aab1-b623-462a-9e65-32e7d9c353ca', '9b0fb1fb-1c56-4457-8af3-df326b9f98e6', NULL, NULL, true),
	('a7ca4080-1a2e-44df-b4a5-be4199f67148', '7d097780-45d5-4445-a0e3-7b76e09e4bb3', '06c0ed0d-3e50-44af-87fd-974211357055', NULL, NULL, true),
	('37ecaabe-c743-480f-a051-6650e380cfe5', 'e81ff5ff-09b8-46ae-ad1d-fff4604cd987', 'c8c3ec0b-e506-4584-83b4-8bc4dc3ff171', NULL, NULL, true),
	('4de74482-85a3-440c-9c2b-dd50fc09d777', 'cf117bdb-0226-42f0-9f40-e11aa3369b61', '5034f523-bde4-4997-b61f-30853654a477', NULL, NULL, true),
	('353c36cc-201e-4e5b-9f7a-d1446d65ae51', '2cf281fc-921d-418b-9243-4f54a59ac052', 'a6ec94a0-0cea-404e-ba9a-09c01b9f11e8', NULL, NULL, true),
	('019c049e-2f13-4cf1-9f31-64935bccf3f3', '2cd82783-74ed-4b7c-82c5-450101d78ac4', '89b5e4f6-95eb-4a8f-854c-17c91059db2d', NULL, NULL, true),
	('32326126-8b2a-4830-b849-d71121f9a26a', 'd7a06acf-52cf-4239-92f4-f6ce9af1556a', '673cbcfa-6f5b-4fab-b24c-7cf3009e88fc', NULL, NULL, true),
	('2888063b-d150-45e6-a55b-754acd5d6ad4', '49873b81-b75f-4e3a-9b74-608a06b35d0c', 'db6491ce-a480-46c0-ae1a-f91303f671e8', NULL, NULL, true),
	('2e14e92a-bd33-475b-bc7d-42221e532d79', '8fb5ef34-d13b-4864-9d2b-4932b86cba4d', 'dea03165-a419-45c1-bbe8-894ab6602408', NULL, NULL, true),
	('92ce3418-db11-4135-a7d5-c8d64ba4bea9', '4cf5905c-6515-4f7f-80f3-8e7f58edd478', 'f1006fd8-7b85-42c7-bdca-469cc97fcba4', NULL, NULL, true),
	('f95bc2d4-57f9-42e8-8161-4641697e0a2d', 'b24af43a-5cfc-448f-8e4e-43da7cd0601a', '3309c091-6209-4bd2-81f3-e953e66624cb', NULL, NULL, true),
	('b3d3d143-80d2-42b8-b3ca-795c6c1d670a', 'ae106cbe-8e7f-4318-900f-0a235e304043', 'f719db8a-a59c-4839-9eb8-4113ec0f5d0c', NULL, NULL, true),
	('6f872a7f-8826-40ac-84a6-9ffef846b2d2', '58b9e813-3c32-4da2-b590-e95f821b94fd', 'e0400e07-fa7f-46c5-bf78-d5bb2475f3ac', NULL, NULL, true),
	('8e8400fa-64dd-414e-8969-92f639ba30b9', '9b399694-f8d9-45da-98f3-bce51c027b0e', '332c38fc-04d0-4f39-bc8e-b0f72c76bd43', NULL, NULL, true),
	('63495093-d848-437b-b1df-7da017a80c15', '19452369-a4c3-426b-a5fb-4e34a81a0253', '187c7041-14d8-4051-a649-d77ff5b10904', NULL, NULL, true),
	('f270b8b7-2eac-4641-8e8b-69f1b3307cdf', '5483bf0c-f14a-42e7-b2f5-f349f831570c', '5ff98f3d-075e-4f15-a044-479c7d59d299', NULL, NULL, true),
	('f426e9a9-baeb-4e1e-8a5c-de51c3f1bc05', '2dfe9d4f-5760-40de-9140-fc00ad0b92fd', '44258f9e-c5ca-4f47-826e-ea4448dc7b39', NULL, NULL, true),
	('0c260aed-fb0c-43a0-b68d-6ed812008ce9', '3429bd17-3db3-42ad-a0bf-7b6682f9ea98', '7c636518-736e-4660-a6bf-38cfcf2c9f39', NULL, NULL, true),
	('f88deb59-12e4-4a3d-98fd-45aae1854712', '978e6e3d-47d0-471b-b830-f8a21b2bad1d', 'a03546d3-1adf-445e-b96e-9a25fc2b92f9', NULL, NULL, true),
	('3bb3b2ad-e689-406b-9213-5761dec5cb35', 'd5e442e1-da7e-423a-8f83-498e0114d5ab', '4dfd7688-147b-47b3-b883-e41426f22414', NULL, NULL, true),
	('6f997d49-9fe3-4ca3-9766-231075c9ddf4', '019c45e1-caca-4e7b-97e4-6bbd54b155f3', '8b0462a5-9181-4529-8769-aca7ba890465', NULL, NULL, true),
	('92de4e00-1b2e-470f-8044-878d7454be08', '07bfe421-8047-4f34-8421-267734e72c82', 'cc3e154a-d2cb-4d25-9c3a-707887952b9b', NULL, NULL, true),
	('a7066660-a749-438f-ba7a-87fbdd3c5e2c', '2884de00-e0be-4adc-9c25-0738a4ccf110', '4f8da841-6ab3-46e6-a645-0847978e78e2', NULL, NULL, true),
	('9aff9f4e-fbfc-445a-bc2e-6c01ecde4f08', '2ca74ae1-648a-4a8f-a52e-7213f316f451', 'e1de73cc-6c38-46d9-b9b9-0121f2a0bdf7', NULL, NULL, true),
	('93cb8783-9c95-41a0-9ded-f449e6e30280', 'af39818c-0553-4686-9843-dadbf2f10a9e', '2d4707c3-cf6a-4990-8606-bf1c614e1339', NULL, NULL, true),
	('b4792b2f-fe25-48e6-bb2f-4d1a2251338e', '1e826e80-82e8-4676-a5a7-b4c5edfbc560', '980fb43b-e022-4c74-974f-491a624704e5', NULL, NULL, true),
	('30458455-f09a-44e6-bbaa-09b366913204', 'b7d08b02-fd4e-4206-85ee-7cdfeaaa7c08', '0e8b54ba-0e91-4a63-8f9d-15a3720a4263', NULL, NULL, true),
	('0985e368-6f73-4fa2-86e8-23828dcd127e', '2ccda29b-5f3b-4adf-9a9b-6f24071bfaa2', 'cc753e92-609b-4670-b990-9e54bd98759a', NULL, NULL, true),
	('8f32ee7c-f167-45df-b092-53c6d407847d', '0fa3ad59-cc32-4c31-a123-f2bf56e45c5a', '3f20db79-36c9-4313-a9af-1420703adb73', NULL, NULL, true),
	('d353f342-21b4-4a00-bf05-e4966f316341', '2071cd19-b79e-4c80-aaac-47be5cc80089', '2753d56d-7daa-4111-bc63-f5b7470035bb', NULL, NULL, true),
	('b9a41bc9-ffc2-41d2-8742-fdfd925a06a0', '50d53eb6-b12f-4962-8eff-50c36d424d9d', 'deaf4026-684d-452c-b80c-ed5a9db7ade2', NULL, NULL, true),
	('2fc9755d-e1ab-4133-a2af-50abdeb45a77', 'e44c7526-3b42-47ee-b3ca-1ccd5c37744a', '51fadc3a-a181-43de-b550-52aa96da3e9c', NULL, NULL, true),
	('2c5d646e-fe30-4163-a478-45f6dc2a54e3', 'ac649890-34e4-4204-8241-b6ea6b8ee8ae', 'c155281c-f98b-41bc-bb1a-1c2d8b044491', NULL, NULL, true),
	('e592c4cb-ab4f-40e8-ac35-448a9cfb9fd4', '34527815-5555-490b-8d7a-63c766c57dd5', 'e7bf23da-dfb1-464a-843c-24a483893614', NULL, NULL, true),
	('9d366fd4-1c26-4e23-af92-cf8a68995a59', '093a0c1c-b1d3-41f4-b33c-b8d9b609acc1', '7fd1ea14-0082-4dc3-b57b-b0b18b83776d', NULL, NULL, true),
	('376f577b-3932-44c4-b324-2538a701d487', '8d9e4a37-f50c-41c9-81c3-895306cf4782', '4c5b6bf7-ffb5-4cf9-ac1f-874721ea2a03', NULL, NULL, true),
	('27353d83-6fcf-4966-9747-309b9b97876a', 'fc015308-d288-4fcb-83de-4122b917b0f9', 'a2e945f6-5f41-45b0-830b-f8c31901f5f5', NULL, NULL, true),
	('6440ca32-e188-41a4-9ffc-8aa393e85452', '74d83726-41f7-4e5a-8a57-0e304e4736e7', '77a62ab9-ad2a-4a1e-9afe-4ffd731a0439', NULL, NULL, true),
	('cbda95ec-69bf-43c0-87ac-6bf5064f8b4e', 'a5aeb112-ca6f-4b1a-b614-df4ce06eed2a', 'fa59d5bd-98f6-4a50-8082-2e7151bb13b8', NULL, NULL, true),
	('55df8a39-8458-40ad-bac4-9a927044aa6c', 'fad94daf-6f11-4cd2-9256-7270f0787391', '26eeaff9-c310-43db-ad82-4c0bfda460b8', NULL, NULL, true),
	('2b4c0cf4-042c-466d-8823-1c3741ecfb54', 'ce696e6c-24a4-4a56-95da-947bac9cc4d4', 'c2911c7b-31b4-44d7-8eab-2c65fcec2d92', NULL, NULL, true),
	('b7083685-1255-43fb-ad3a-2f01b3a431b9', '4cb5116b-d132-47bb-a99f-98ceef5c8dbe', '53c392d9-9d44-4c5d-bf03-b2c39df95953', NULL, NULL, true),
	('6810a09e-5fc5-40c1-a7ca-05aaf0cabbdd', 'a1c5d24c-5ecc-4889-92ab-9163a91e3e79', 'fb889851-0b87-4fce-b606-bf250ef492a3', NULL, NULL, true),
	('a8d3d3ec-2cb0-450e-9848-57df1b406d62', '0f449571-79f9-454e-b19a-ae34b5c31cb3', 'f36d53bd-7d85-4040-af96-d22cff0ef708', NULL, '2009-04-01', false),
	('e5000980-c3ee-4f54-a53b-2c3e657271c4', '3dfc7437-5d3d-4e69-ae0b-c97376d6cc38', '2cc7068d-e2c1-4f89-bcf7-d254640fccce', NULL, NULL, true),
	('09fdab57-6bdc-4b76-be44-6996a39246b3', '942f0927-84a7-43b6-8be9-68f88917b043', '3802ccd1-0803-4817-bfc8-5188ccbf06e2', '2009-04-01', NULL, true),
	('b39a1c36-9634-4034-9903-e91fad345b9b', '0a7cb25e-e9f9-40c7-97f5-5eee9bb436ee', '6fa0fa20-9beb-447f-bb7e-c55064758477', NULL, NULL, true),
	('78773f8b-e30e-47b5-91ef-6feaa2ffd634', '3346d12b-0c32-4bf2-b3eb-2e2e2d24dbc7', '5b5721c4-9f88-44cb-9302-e6130e8ed6e6', NULL, '2020-04-01', false),
	('eff9595a-f7e0-4a7c-aca3-b6232f2e02ed', '3346d12b-0c32-4bf2-b3eb-2e2e2d24dbc7', 'e4636164-5024-41ae-a628-fdda61a7ce3f', '2020-04-01', NULL, true),
	('1cde2a1b-e6a8-4665-b471-a4b7aec68c43', '1ab5d183-d9d1-4d00-9f6c-eb75c323d92c', '67b5f616-39fe-4b31-b116-924192c6859c', NULL, NULL, true),
	('548470ac-50d4-4f0c-975f-6c9275798cdb', '05cc5f5e-45cd-437e-805e-0ec749453739', '00081acf-dd3a-41c1-90d9-6be0dda47be2', NULL, NULL, true),
	('57868f69-4141-409b-8c4c-2b5384f1a1de', '24f8bcc1-22d4-4ac1-9887-c5392ca4a5b9', '0604190a-2422-4c72-90b7-5684714a59ac', NULL, NULL, true),
	('11da55b4-9e64-4f21-8a17-528b83e6fa9a', '84f7c0ea-e498-4f14-bfa9-896a12e91a47', '1b00df3e-1b56-4574-9bf9-cfd920c1e468', NULL, '2019-04-01', false),
	('a1b800b0-c7e9-4fd3-bb64-8b1e3f57fb62', '0ffd5853-b247-4645-bb43-4c21cd3c097f', 'b522b97d-8d52-4b79-bf36-bf671af9336a', NULL, '2019-04-01', false),
	('c1b62fc8-9836-4181-8d2b-ababf08a46e6', 'a717a384-7ad1-4905-8d05-dea6f9bc274a', '2f9a996e-ad57-4f99-8f3e-2ce482a1927f', NULL, '2019-04-01', false),
	('2333dc42-f745-4892-b72c-bae0883ed4d3', '5aac67d2-6e20-477c-a3f6-0ba844fa4bac', 'd5606470-d7c8-4ba5-9756-7a9895ebc1fd', '2019-04-01', NULL, true),
	('1dd7edc3-3734-490d-8c5f-2305b7c2b840', '516a5708-bc4f-4f0d-9a8d-8cb036494616', '339df911-4d26-4c96-9952-39e09d8d3e16', '2019-04-01', NULL, true),
	('c8bc4723-4f4f-4d73-802a-16f5cda87a95', '04f71e88-521e-4679-ba88-83125125950c', '9bc31c3b-a426-4c3b-aa93-9857e76a029c', NULL, NULL, true),
	('e8dbda76-869d-4c8b-9f60-8c2b4f9ebf4e', '221e3d83-edc6-4a8d-949c-f77a6785b431', 'bbeb4921-d158-41b8-bc3f-cb69e816e97a', NULL, NULL, true),
	('ad5b991f-3166-45c3-8440-237817c23c79', '23dec583-f738-4c69-94f8-8419868cefad', '22743a4f-933c-4f60-ba3b-514714ce8752', NULL, NULL, true),
	('3226060a-b1bd-4b33-b5bb-c37d6a74b56e', '8bb04782-9600-4d83-a0c0-e9d2d3466c34', 'b28aa95b-78f3-43b0-88cb-eb3059f8d6e9', NULL, NULL, true),
	('63e7a326-2131-4ebe-ad69-2ad5c35da478', '5885bd90-8384-462f-9edb-a90f44519d81', 'e05aa0c3-07e2-45bd-a9ee-fd2e1e7ec3e2', NULL, NULL, true),
	('e8dcf13a-1eed-4c8a-8d44-de4a9b0a6fe0', 'cf2319f9-aced-4926-8d4b-e10cac4024a9', '025bb820-d1f3-4453-86b8-9f38b5215eee', NULL, NULL, true),
	('e436cf17-735e-4f4f-80f6-e53b7bbb7a82', 'dd45f000-7108-4d65-aa54-75fd7eaad6bb', '93ae56c8-97e3-4329-aa89-fb1aeb55b97d', NULL, NULL, true),
	('2f7c0c71-4b91-4a50-9f31-304855540b80', '51cb7b94-0266-48b5-8d90-f13aa42b983d', '39ef0d98-239c-4f8f-9b5a-d8678df8c398', NULL, NULL, true),
	('671507ad-9f02-48c6-9b30-bd72d3fa52b3', '34a353a0-aab3-4aee-978a-937a1bf24f34', '975790b4-4ee9-4441-a221-0542a7643960', NULL, NULL, true),
	('ca284ee4-f01c-4ccc-af01-c9b82c0ee0c6', '8a475312-0978-46ba-a4af-ffef53132608', 'cc9bd538-c4e9-4d85-bf7b-71f1df6edc23', NULL, NULL, true),
	('25079d47-2721-48ae-8a6d-7ea21b48a6c9', '55083c61-a058-42c6-a0f9-680a97700a80', 'dc951090-305e-42e5-aaa3-5ebccd8ef9f7', NULL, NULL, true),
	('716b95e1-44a7-401b-bbe1-2dc30b7f1b7c', '3332ea83-bcbe-48d1-970d-a3650d9bcf10', '78ccc4b3-472c-4e62-9d53-9bded5d55fe3', NULL, NULL, true),
	('a4e44a8a-2afa-4e52-ac91-067836ae17ec', 'f029fe2f-656d-409c-aca4-fdd50231fa75', '5ef4014b-53b5-4283-95d9-02a053ecee56', NULL, NULL, true),
	('0366605a-b3e3-467b-9599-11f021822c42', '4eb4d2f2-73bc-4f31-a476-1a265094b7aa', 'b1de0c81-1379-4d63-809d-ff0776e9290a', NULL, NULL, true),
	('ed622b0c-666a-4b0d-a52a-e5e5f57d9861', 'f4d6c9d4-fbff-4538-b0a1-53d6d8c36a0b', 'f23d827d-4352-4a1e-ae6c-29d10933bec9', NULL, NULL, true),
	('44e6c3ff-f63f-4b56-bdad-d78241c1c3ca', '0659cec9-f4f1-4281-aa38-dac5b79a93e7', '9b0cbf0f-1631-4130-a947-614ee98dc9e0', NULL, NULL, true),
	('539ea0ce-5ae0-4349-9b6f-71882467ff24', '19c03d55-f6bd-4912-85db-129ff938d6fd', 'b36730b2-e5cb-4c99-8f59-735407239472', NULL, NULL, true),
	('85b96f10-f419-4b68-bc9e-b2b5c643886c', '154a9b7a-7ef2-4988-9c4d-49e10a09507d', 'fab48b2f-1c2e-4ced-a086-c500ac4df2d5', NULL, NULL, true),
	('874f6aa5-f574-4495-ae8a-c01eaa399a3f', 'e7980e70-c33e-4539-8573-106a6245da72', 'cdd84a97-ddf2-4fbb-a7f2-d18b16870e62', NULL, NULL, true),
	('6fed8956-f93e-471e-a835-1a8953450dfa', 'de723409-6555-4aed-a1f9-82b6e9cb1cc1', '2ac7c2b6-53da-440a-a313-41c78eb35ad6', NULL, NULL, true),
	('981206c6-877e-42cb-8e44-09fbebc228a1', '3a839d72-f591-4c51-9b4b-91637c541035', 'bad2d713-bd8e-4c56-9435-ac404e51109a', NULL, NULL, true),
	('8fd41e24-a48e-40c9-86ac-a03f650de002', '42e364c7-0769-4180-85af-94979c4a5604', 'b952d053-4fe3-4a17-bb21-8c1578788b48', NULL, NULL, true),
	('101de4f4-4144-4a72-8d93-361ad5ba6746', '75380e70-1b77-4afb-a53e-a69c2f21f86e', 'fcf0f52a-1c8a-4090-a361-bcebfe4f6986', NULL, '2009-04-01', false),
	('0b54dba0-5f84-4184-924b-39fc7eea6f0f', 'b8bab4f4-b58c-4b0f-9a07-df5d16f9380b', 'de79e58e-3465-45fa-8168-5f9f1ad00232', NULL, NULL, true),
	('82e54c87-1f46-4bfb-a0ed-71dac3ee8583', '145f84fa-36ae-4c6c-84f0-3f6b551ac5b2', '2252b68e-9ecd-4199-bd4f-ba1961a25fc5', NULL, NULL, true),
	('bdf1bfc4-cb59-4985-b256-6df68e49a351', '275bafd9-e869-4606-ad4a-6c578baae51f', '5fe408d9-fb14-4acf-999d-f8caa9098401', NULL, NULL, true),
	('3850ecda-1881-48f9-ba7c-ac5cc305312b', '5725447b-2398-4c41-8ca0-4fa6ebb9e691', '5827756d-86e3-4de5-8469-3f283f7720c4', NULL, NULL, true),
	('605db2e3-79b2-421a-a18f-821c72e41814', 'ba283a65-25f7-4eac-a3ec-fa46b93d1245', 'ef858f6b-3d2d-4d2a-a458-6e855b6aca27', NULL, NULL, true),
	('434f6324-e6e4-40d3-9c36-70c209631654', 'fc8cf832-fb45-45ba-bc98-09fb41b3a224', 'd58456a8-eb8a-4d44-bd48-9611fff6b332', NULL, NULL, true),
	('f8c8c376-4f71-4881-84f2-4587668e41b1', 'dc9f9e86-8d80-46b7-87bc-e998cafca819', 'b360b238-6c52-4832-9043-6233078322b2', NULL, NULL, true),
	('bd38cee4-5cf7-470b-a06d-b302def4089d', '7265e4f9-7622-4944-8bd9-fb3825952c3f', '324b4c97-a6f7-42b1-a0bb-691448804347', NULL, NULL, true),
	('e6641fa5-5535-4fca-b3a8-36afc0983ac1', 'a8333a46-7a89-42b6-ab95-43a73e09e704', '4dfdecda-ac8c-4253-abce-0354105dcd9a', NULL, NULL, true),
	('46747818-72bd-4e74-b356-ab5dd46cdae5', '3f8cc89e-9279-48fd-b440-48dc00f06fca', '49d316d6-6cc0-45f3-a869-8380cea33cf5', NULL, NULL, true),
	('3b0bb043-b305-4af7-9334-01ad1265506f', '893121c9-05e6-4e35-bfef-ea76e40c012e', '4eb78548-efa5-4688-85e2-0d3a01ecd786', '1998-04-01', NULL, true),
	('178df9b9-e7fb-4c78-b39d-bcfdb281b0c3', 'f0810578-383d-4303-b694-41e13fb73823', '705c1c08-2b8d-48fb-9fae-52ee96575424', NULL, NULL, true),
	('f1c30044-265f-4e2c-9ba6-65650304d7ad', 'a4572037-9765-42e9-890c-0a4c47a49abd', 'bbd501c2-2def-4e0c-b22a-ceb523d5ab56', NULL, NULL, true),
	('2c34847f-71d7-466d-8997-0de95f681d6f', '88a167eb-994e-49ae-b1ee-4db968a5bf4b', 'bc6f073b-9831-466b-8488-b97fbf19f2b4', NULL, NULL, true),
	('13ed281e-ff01-4a96-9967-c38d76cd6ec3', 'b8be820c-b9c1-4b6e-80e4-53384b370924', 'f8e65d35-b2db-4c0c-9f32-9069cf5525d0', NULL, NULL, true),
	('551de912-a535-43ae-81b4-46c60ffc7610', '7004982b-a526-4013-82b5-68c877c0de28', '5fb139ce-a696-4ac2-ba3a-445b361c206a', NULL, NULL, true),
	('4989e1d3-9d5a-4a5e-9309-7db83dc7d08e', 'c97c1960-148d-4fa3-8f4a-81fb6da42447', '1f7e5cff-981d-4a19-b175-7976651532a0', NULL, NULL, true),
	('e8f6b81e-4546-48d1-b5f3-325bf5a06808', '3bb666d7-f8a2-4c07-b5de-06eead480743', '64f34b7e-3413-4bcf-817a-c8024a243b32', NULL, NULL, true),
	('e91d1599-14ee-46fd-9119-d517749ffcb2', 'e9fbec24-bc95-49dd-b2a5-76e562c97185', '4c61a1bf-474a-4530-9e9b-783f74eef813', NULL, NULL, true),
	('d677058b-a579-41ce-9bcf-eb56e5d93f3a', 'b0785849-4633-422e-b170-6b33fd8c4555', '6f9bc24c-f6ca-4cbe-9946-8eeb13fc4884', '2009-04-01', NULL, true),
	('1a74ed23-94b1-4a4b-9807-1240376d44ef', '62f727b9-cb7a-49b4-9a78-3bda13bdc5ca', 'c6224d1d-e1dd-44f2-b9b4-79c6b57aab94', '2009-04-01', NULL, true),
	('e9dc2aa7-b28e-45f4-8657-68fb25b6792c', 'd7f6360e-a0a2-4948-9abe-b8dfa2191c83', 'f8cd82a7-4c45-483b-9ba6-75d46fff8ab6', NULL, '1996-04-01', false),
	('564c3c83-9bf5-45e2-bf3e-c62cef6ac6d4', '3ae26c72-c959-4407-8d09-ab05653ff56b', 'f36d53bd-7d85-4040-af96-d22cff0ef708', NULL, NULL, false),
	('631eef63-7d37-4d0e-b5bd-85cf2c2518a2', '81bf98ca-5884-443d-bf88-b319df5c53b7', 'ea046f10-de23-4dda-b3bf-2ca12e876bf2', NULL, '1998-04-01', false),
	('0d1950e4-a1ec-4c7f-a872-e741d7a7e008', '8cc4e741-ebed-449f-a828-4c1e2dafde43', '5b5721c4-9f88-44cb-9302-e6130e8ed6e6', NULL, NULL, false),
	('0b2ed288-a662-447a-8525-e00a534e02d9', '9ea9a305-39f5-4c57-9ef2-3a3673c4c132', 'bad2d713-bd8e-4c56-9435-ac404e51109a', NULL, NULL, false),
	('3228af35-eddc-4e7b-b811-628012324266', '05967224-7461-414d-b378-0ba6f085b3e4', 'fcf0f52a-1c8a-4090-a361-bcebfe4f6986', NULL, NULL, false),
	('5929fbb2-70b0-4863-be39-73e40410e3f4', 'c03b5eac-473d-4abc-8cea-1aecc5717477', '3944a193-a6f9-4a9a-aad6-219c83ff71ff', NULL, '1996-04-01', false),
	('06493854-c2ea-46c5-b508-cbde99a27456', '6c224a0d-ed93-4dc1-bb76-b39f7890044e', '6c429195-ac5d-4622-843c-fe13aedbc0e0', NULL, NULL, true),
	('39f4a1a1-87b5-4fb9-8836-c4245167ae03', '36b0d8c9-ea35-4cc1-9d29-fef2975d98f9', '052e2cf5-ebd4-4a10-af22-01dd41afe5c7', NULL, '2023-04-01', false),
	('8bc4c899-f335-49e8-b053-ce7d442bbfcf', '35cb204a-5a7d-40d8-b5d2-98b3b872b2ce', '00081acf-dd3a-41c1-90d9-6be0dda47be2', NULL, NULL, false),
	('579e35a1-a7f7-41a3-900f-8341e9aaca4e', '1d92096e-0bb4-44dd-9298-35405a6092ff', '5fe408d9-fb14-4acf-999d-f8caa9098401', NULL, NULL, false),
	('5382cfac-c5b2-48e4-8586-cbda219f5aa4', '39bbbc7d-18de-4c56-9072-3e2f053e745a', '1b00df3e-1b56-4574-9bf9-cfd920c1e468', NULL, NULL, false),
	('c64d7b88-fcc5-4826-8fde-43a0ae90a542', 'c09f8fc9-9f2d-4f77-bea5-80528c3533ae', '9bc31c3b-a426-4c3b-aa93-9857e76a029c', NULL, NULL, false),
	('eaaf5f30-c020-4809-9465-d9f156fb299f', '8ba06800-fec1-41da-b0a9-822f05fb9019', '22743a4f-933c-4f60-ba3b-514714ce8752', NULL, NULL, false),
	('c90fc534-e79c-435a-9ac2-13041cca14bb', '1e59b614-94db-427c-bfd3-99c0b393ad14', 'd58456a8-eb8a-4d44-bd48-9611fff6b332', NULL, NULL, false),
	('1ce60817-0b96-4508-ae24-66c96bee5187', '3b110d34-2776-4827-969e-2af0d39a4aa2', 'c0bab65a-1dda-451f-9012-638ae1078ebe', NULL, NULL, true),
	('d82cc44f-d032-4f22-b3d2-653a40a6cd58', '200c738d-2f8f-4349-b600-f568a52f7389', 'e05aa0c3-07e2-45bd-a9ee-fd2e1e7ec3e2', NULL, NULL, false),
	('e5a0e914-fd48-4014-a8ea-26726c819e6c', '4576e83b-4f05-4e08-bce7-2bcc4ed79c9c', 'dc82f36a-c010-405b-ac23-985fc21c7cb3', NULL, '1998-04-01', false),
	('233ecd5d-c10e-4539-9be5-6f5011aef6c8', '17d78c35-15f4-4065-a8c1-7e06b39285ec', 'df867651-16f1-4266-91f9-4509f3a9ac50', NULL, NULL, true),
	('a5036635-11b5-468f-b148-489cdc583f14', 'f8eedfd2-0ee9-49ba-a21a-d3b7689ca877', '97939759-3e3b-4c4a-a2b4-9ff9ebbc145c', NULL, '1996-04-01', false),
	('524a68e9-6044-4b9c-b138-73a7863fab53', '3b27e455-7000-4c6a-b41f-5fbe41bef115', '35d541a2-f11c-4778-99e8-4d779bd9da62', NULL, NULL, true),
	('bd289413-106b-465c-98a8-6f648d794e0a', '8be0b302-bc81-41b6-822a-131b844dac65', '4eb78548-efa5-4688-85e2-0d3a01ecd786', NULL, '1998-04-01', false),
	('255496f4-221c-4202-825f-eda84c647b3d', 'f9819105-1161-47ad-9bb9-25d960a9370a', 'bbd501c2-2def-4e0c-b22a-ceb523d5ab56', NULL, NULL, false),
	('cb5bbd71-910e-464a-a259-896cea97c863', 'cf173149-3ef1-4f3d-888f-c7d6fe4024a7', '39ef0d98-239c-4f8f-9b5a-d8678df8c398', NULL, NULL, false),
	('a22ba674-5d8b-4c38-bfdb-595d9f8324df', '00720f6a-c51f-4c33-8146-3c3bd96dc279', '6b2e2c44-71c7-4ab6-800c-7202af3a9df3', NULL, NULL, true),
	('b31edfb9-7b22-4bc9-b174-3491d795338a', 'bb96fa49-32fb-408b-84cd-5d067bce81d0', 'a95ba826-f1eb-4c64-80a2-9f147d9a4a7f', NULL, NULL, true),
	('cd5ae02d-e380-4a58-a365-c5da4ab0e2ab', 'b2cdb195-afdc-4aef-a886-065c30e8d726', '53c392d9-9d44-4c5d-bf03-b2c39df95953', NULL, NULL, false),
	('69603b1c-87b1-467d-8e45-2d84c701198c', '4f5cf1f1-e617-4ad7-b077-41042c25dd30', 'b05840c4-c612-478c-8243-56cc8542886f', NULL, '2021-04-01', false),
	('048f18df-1356-447c-8014-a5375618ed67', '7022a4a3-5042-4d4f-af8e-fe3f8e0987b3', 'de51de93-8ce1-49e2-8740-929dcc6cfccf', NULL, NULL, true),
	('4e60185b-befc-4c75-a324-f26cc5f020c3', 'e3406846-6987-4d8e-b2cf-f318721c1b11', '5fb139ce-a696-4ac2-ba3a-445b361c206a', NULL, NULL, false),
	('cfbb8d0c-154c-453e-8b03-3bded857465c', 'cdf59613-2d50-4afa-9ad0-69ab9555cc63', 'ba306a61-57b7-401a-891a-21302c0debf9', NULL, NULL, true),
	('0afb0a12-f5ef-42f9-920d-b0968e2750e0', 'f8337f43-8a21-4010-90ff-46ea8a95f486', '64f34b7e-3413-4bcf-817a-c8024a243b32', NULL, NULL, false),
	('9ced8a97-a695-408c-84a6-0e2c09cac013', '7b8c9e1a-8fc4-4651-b901-7846b63b0672', 'fbd8faf4-3dbe-4410-81c0-ce0891128d5a', NULL, NULL, true),
	('33959df8-c672-4ac7-b067-afb49a15307e', '07c97c88-db4f-4861-8d5f-42c14416c7b1', 'dc951090-305e-42e5-aaa3-5ebccd8ef9f7', NULL, NULL, false),
	('ac19a791-30b8-4bb8-9d19-d20c3cb857da', 'c1782af8-ed41-4ee1-bd3a-a5449b43acde', '1a88dac3-1035-481a-89e9-a53036c47a51', NULL, NULL, true),
	('a4dc9d2b-ed7e-43f2-afd4-aa8c3b46c995', 'f76fed20-3a9b-4a0d-b15f-b3cde9c65b0a', '30783fab-3dcc-4091-b26a-af8907c0dfd1', NULL, NULL, true),
	('890e3832-06af-4de5-9179-5d0bce6d5a9c', '26478edc-2fa3-4d8b-b9f7-aebc52a7dd2a', 'a1e1223a-8442-424c-8b9f-59714899a9b0', NULL, NULL, true),
	('e56b56ee-615f-4d3d-a887-2bc2b18f4580', '8e5cc3ab-5773-49b5-9242-44413e8c2bf4', 'cf576508-e284-4938-9c4d-ea3439e92f75', NULL, NULL, true),
	('6be64525-0202-4f90-a71a-89663bbdc0b7', 'fe1af861-cf8a-4ec2-8138-8044c254786d', '5ef4014b-53b5-4283-95d9-02a053ecee56', NULL, NULL, false),
	('f3b2527e-e391-45e7-93cb-c539eb5f1605', 'e88b8486-ec97-4b98-a450-f0166bfe954f', '058cc7ab-9391-4aa6-9ba4-93a8cd4e378b', '2021-04-01', NULL, true),
	('afc4f192-222a-4fd2-9970-c46898e3828a', '8cb6de69-7978-4365-be32-d4f17554110a', '0e0e4de8-f04e-428a-ab29-ef1bc67cb376', '2021-04-01', NULL, true),
	('e16d3c31-b28a-42d9-a406-cfa4c5bdda93', 'e2ce8ae7-4ce9-4963-88cc-4456fb70de9d', '1c20b22f-1f5c-41d6-a3ff-3696e4522a15', '2023-04-01', NULL, true),
	('2a813012-c757-4d9f-a804-7b3348208867', 'c3481033-0753-4614-b00b-677ccc85d1ee', '41272cc4-45fc-499e-bf6c-ffe78ce50b9b', '2023-04-01', NULL, true);


--
-- Data for Name: organisation_group_address; Type: TABLE DATA; Schema: establishment; Owner: -
--



--
-- Data for Name: organisation_group_member; Type: TABLE DATA; Schema: establishment; Owner: -
--



--
-- Data for Name: organisation_group_member_lead_period; Type: TABLE DATA; Schema: establishment; Owner: -
--



--
-- Data for Name: organisation_identifier; Type: TABLE DATA; Schema: establishment; Owner: -
--



--
-- Data for Name: specialist_provision; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.specialist_provision (specialist_provision_id, establishment_id, specialist_provision_type_id) VALUES
	('b0b1f0e4-7e59-4e9e-9294-b8ec13816ea3', '1e5f4b3b-9f3e-4a32-8b06-0a8bbdd960d3', 3);


--
-- Data for Name: resourced_provision; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.resourced_provision (resourced_provision_id, specialist_provision_id, capacity, pupil_count) VALUES
	('e5457b33-d468-49e9-9dc7-2a206a3813c5', 'b0b1f0e4-7e59-4e9e-9294-b8ec13816ea3', 24, 24);


--
-- Data for Name: sen_unit_provision; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.sen_unit_provision (sen_unit_provision_id, specialist_provision_id, capacity, pupil_count) VALUES
	('feeaaff6-d2f0-44d6-ad9c-5c18510a7c52', 'b0b1f0e4-7e59-4e9e-9294-b8ec13816ea3', 24, 24);


--
-- Data for Name: statutory_age_range; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.statutory_age_range (statutory_age_range_id, education_admissions_and_provision_id, lower_statutory_age, upper_statutory_age) VALUES
	('894f4550-c387-4140-8d25-ef6b32194ef1', '104392bc-0a12-4985-98e3-48a823f1cf38', 2, 11),
	('d1447476-1843-4840-84e1-82e103bf5e6e', '068629a5-cf2f-44c9-b82b-47dedc4fe31f', 4, 11),
	('d8592ab5-293a-4229-bd5c-718d8f046713', 'dab403a3-1a62-4988-ba63-15dcc75d7084', 11, 19);


--
-- PostgreSQL database dump complete
--

\unrestrict jX7SZbrLyElkaFRxwXkFpQUuhvXIXAvTZIuM5fFANvwgOTEulBbWHZYgcYvEAfF

