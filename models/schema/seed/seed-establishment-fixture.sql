--
-- PostgreSQL database dump
--

\restrict JqwXHcwcyCRIJgh4Cqmu6nli7crJbdRVLC5a5gey86VZbvwQXaeB1EHR6nuK9Cu

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
	('8ad9caf7-de5c-4d8c-b26d-ffd18ae3eb0d', 'obfuscated', NULL, NULL, 'obfuscated', '099', 'NW1 3EX'),
	('53f34749-91e6-4426-b796-22620f38a4ac', 'obfuscated', 'Milton Ernest', NULL, 'obfuscated', '001', 'MK44 1RF'),
	('c8a75e25-6df1-401a-b85c-60675e895918', 'obfuscated', 'Scawsby', NULL, 'obfuscated', '031', 'DN5 7UB');


--
-- Data for Name: establishment; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment (establishment_id, urn, ukprn, establishment_number, name, establishment_type_id, ofsted_link, education_phase_id, further_education_type_id, section_41_approval_status_id, religious_character_id, religious_ethos_id, diocese_id) VALUES
	('02f5adea-7922-4c31-977b-ee43078ecb6a', 100018, 10069172, 2436, 'Netley Primary School & Centre for Autism', 1, 'https://reports.ofsted.gov.uk/search?q=100018', 2, NULL, NULL, NULL, NULL, NULL),
	('5f0715ba-5388-457a-946c-9c770fe03b5d', 109613, 10075753, 3023, 'Milton Ernest CofE Primary School', 3, 'https://reports.ofsted.gov.uk/search?q=109613', 2, NULL, NULL, 1, NULL, 'b702a76d-948e-a580-6ffa-366c146b59bd'),
	('181c62bb-a958-40cb-a73c-1cb06b519af8', 137603, 10035482, 4033, 'Ridgewood School', 24, 'https://reports.ofsted.gov.uk/search?q=137603', 4, NULL, NULL, NULL, NULL, NULL);


--
-- Data for Name: capacity_and_pupil_measures; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.capacity_and_pupil_measures (capacity_and_pupil_measures_id, establishment_id, school_capacity, pupil_count, free_school_meal_measure, census_date) VALUES
	('8b96a7ce-d341-45af-80b2-f4738df141e8', '02f5adea-7922-4c31-977b-ee43078ecb6a', 65801, 383, 224, '2026-01-15'),
	('b86ae566-0c49-4a46-a81a-c241762116ae', '5f0715ba-5388-457a-946c-9c770fe03b5d', 63964, 67, 5, '2026-01-15'),
	('e4a1df38-ca10-4d1a-9f54-1536005bf309', '181c62bb-a958-40cb-a73c-1cb06b519af8', 1512, 1425, 250, '2026-01-15');


--
-- Data for Name: education_admissions_and_provision; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.education_admissions_and_provision (education_admissions_and_provision_id, establishment_id, gender_of_entry_type_id, admissions_policy_id, boarding_provision_id, nursery_provision_id, sixth_form_provision_id, has_special_classes) VALUES
	('773abb21-8738-4e14-acc2-1c7d6079959c', '02f5adea-7922-4c31-977b-ee43078ecb6a', 3, NULL, 1, 1, 2, true),
	('93c48e2c-b419-4287-a3f2-fe69c7ffd957', '5f0715ba-5388-457a-946c-9c770fe03b5d', 3, NULL, 1, 2, 2, false),
	('f7b7da3c-a1e6-43b1-ba3c-2e6dfc2899e6', '181c62bb-a958-40cb-a73c-1cb06b519af8', 3, 1, 1, NULL, 1, true);


--
-- Data for Name: establishment_contact; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_contact (establishment_contact_id, establishment_id, website, telephone_number) VALUES
	('1702c330-2a4f-48a8-9dbd-c36e2e5caa6b', '02f5adea-7922-4c31-977b-ee43078ecb6a', 'www.netley.camden.sch.uk/', '111111'),
	('2751d8bb-05f2-41ae-9f2e-28e6aefb64bb', '5f0715ba-5388-457a-946c-9c770fe03b5d', 'www.ewmeschools.org.uk', '111111'),
	('102bf87a-2103-4d6b-a5bc-5cd57109ffec', '181c62bb-a958-40cb-a73c-1cb06b519af8', 'http://www.ridgewoodschool.co.uk', '111111');


--
-- Data for Name: establishment_geography; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_geography (establishment_geography_id, establishment_id, local_authority_area_id, government_office_region_id, district_administrative_id, administrative_ward_id, parliamentary_constituency_id, lsoa_id, msoa_id, urban_rural_id) VALUES
	('ba851da4-8c49-4d17-85ba-1201c433b319', '02f5adea-7922-4c31-977b-ee43078ecb6a', '591b5ab3-0a9b-4ffd-a197-046dea0fb78b', '31b0c265-5ee9-48f7-a42c-4534c77008c7', '778ca3b6-5c8d-4256-95b9-13ad64805139', '2c4c80ec-208e-4ac1-9737-fcad2642e16a', '146f4f83-d478-4491-a06f-17eecabc5c75', '8f0b00a6-5914-4d48-9934-31439a8cc15e', 'b8d8dd4f-153a-4d7e-92a9-dc9d89748b77', 25),
	('a9f58ba2-8a26-4823-9b0f-47116e058c34', '5f0715ba-5388-457a-946c-9c770fe03b5d', '19b9acc3-065c-4899-8b1d-10150bc10344', '1584f300-bdcc-43a6-94a5-1f58854abe5c', '5a6feea6-bafc-45eb-95eb-914d74eff69d', 'e534959e-6cec-48b3-a7e4-b4f4a7e3f20d', '872e895d-c21a-4b61-9eb1-6ca58c2fb3b8', 'e8a9696c-245c-41a5-b975-f98a5fa68c5b', '811387b5-94cc-470b-b59d-7ceca2cffab6', 23),
	('1af10954-532f-4c63-921d-8e000db27cfb', '181c62bb-a958-40cb-a73c-1cb06b519af8', '31d3a034-8231-40fe-b121-5a80cc140be6', '47d528a0-085a-4fed-bac2-5ef01d7f326a', 'b8c0b597-5571-49a7-ac81-c1f4bdc968f1', '2e0c5d63-6645-4ac5-8062-4f3dd80cb528', 'f76bd968-b408-445f-95fc-785e37738e54', 'fe8c5904-b2f1-4c0e-8e5a-70a5da6ef50c', 'fbfbc5b3-96d8-4733-9a57-0b930add9223', 25);


--
-- Data for Name: establishment_lifecycle; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_lifecycle (establishment_lifecycle_id, establishment_id, establishment_status_id, open_date, close_date, reason_establishment_opened_id, reason_establishment_closed_id, last_changed_date) VALUES
	('351f618b-671b-47e6-a98b-7afde229b521', '02f5adea-7922-4c31-977b-ee43078ecb6a', 1, NULL, NULL, NULL, NULL, '2026-06-23'),
	('f823f356-abf8-4898-bd06-b80ac9565808', '5f0715ba-5388-457a-946c-9c770fe03b5d', 1, NULL, NULL, NULL, NULL, '2026-06-23'),
	('a218177c-7d34-4926-9921-15880b61bf4c', '181c62bb-a958-40cb-a73c-1cb06b519af8', 1, '2011-11-01', NULL, 10, NULL, '2026-06-23');


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
-- Data for Name: establishment_sen; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_sen (establishment_sen_id, establishment_id, sen_id) VALUES
	('2fa2c8e0-217e-4418-937d-eb1e47b2f525', '02f5adea-7922-4c31-977b-ee43078ecb6a', 4);


--
-- Data for Name: site; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.site (site_id, address_id, site_name, uprn) VALUES
	('7046c0cd-a88d-4e3b-9b8b-51f73c365c40', '8ad9caf7-de5c-4d8c-b26d-ffd18ae3eb0d', NULL, 5172210),
	('5d3937dc-f44e-41b9-a559-a361d1b1f425', '53f34749-91e6-4426-b796-22620f38a4ac', NULL, 100081212588),
	('723d872d-01e4-4e9f-98b0-759a826b42a0', 'c8a75e25-6df1-401a-b85c-60675e895918', NULL, 10006581609);


--
-- Data for Name: establishment_to_site; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_to_site (establishment_to_site_id, establishment_id, site_id, is_main_site) VALUES
	('f6c58a09-5e1d-4269-9721-a3af4815094d', '02f5adea-7922-4c31-977b-ee43078ecb6a', '7046c0cd-a88d-4e3b-9b8b-51f73c365c40', true),
	('45bddcdc-dfda-4e30-b8d3-ff0925500c25', '5f0715ba-5388-457a-946c-9c770fe03b5d', '5d3937dc-f44e-41b9-a559-a361d1b1f425', true),
	('cb7d4a86-1bb5-42f5-ad6e-c0ae5e0ce44a', '181c62bb-a958-40cb-a73c-1cb06b519af8', '723d872d-01e4-4e9f-98b0-759a826b42a0', true);


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
	('22188ad3-5b9e-41e4-8c69-384d892075e6', 'cca66d7b-9a48-4c39-90cd-3ca09788872c', 'e1a6327a-d009-4188-9e1b-7024a720b88f', NULL, NULL, true),
	('9e68bebb-561d-45b5-9404-0c7aa1ae2075', '591b5ab3-0a9b-4ffd-a197-046dea0fb78b', 'b086cfb6-8e69-41bd-aabb-7c8280e0303c', NULL, NULL, true),
	('7c33384f-61a2-4f35-ac6a-fd4e3395be55', '5264873d-858d-43e3-aa67-be77f426cfc3', 'b59eda0d-f6e0-4ad9-8b0b-ac627e4025aa', NULL, NULL, true),
	('14177ffc-bb4b-4977-bfa9-baf11f4474c6', '3d26f20d-53cb-47e6-b958-9c8841005ec2', '81c75ae1-8301-4525-a050-6955bdfa4779', NULL, NULL, true),
	('469279e6-c539-45c9-9629-507667ddc8fb', 'a0440ae0-ed6e-4019-98e0-fe3487c4003d', '287bdf12-6aef-4594-a075-78925c23bba6', NULL, NULL, true),
	('eb7d56e8-a6a2-4b0d-b096-733d749ae302', 'b7ef89c1-fa32-442d-a8b8-5133f4ba14af', '541af47a-2e3e-4d54-a5d7-6cea57348f64', NULL, NULL, true),
	('3e614576-cd6d-42d1-abe0-c578b7de799f', '6202a64c-5549-48f4-8ae7-323c8ecc3447', '1a64cadb-fa10-49fe-bb99-3d2bfcfa0eee', NULL, NULL, true),
	('31192324-3797-4260-bc32-136bfc85a95a', '6214ae50-1350-49a7-8830-8fe5206db6fa', 'f968439b-71db-4cb2-b232-1e7dbd92ecd1', NULL, NULL, true),
	('e4390ff3-3247-46c6-b4bb-f15b8cfbcbe2', '37463379-3612-4809-8520-180576f2ddff', 'ae59b13a-8127-4417-83e4-9f7b677bf46f', NULL, NULL, true),
	('5678925e-3e64-4ed4-9141-5feb3a3b8424', '6154ebad-6d67-4d08-84bc-70f4ca79a19c', 'ee74e081-08c0-4a4b-b835-a777a0bf3da2', NULL, NULL, true),
	('4a589292-ea90-4c7d-a346-0fdfd170af7e', 'f8bf5b08-f365-41fd-9b5a-551fda397b4e', '05bbf16c-664d-43de-82d9-127106fb01bf', NULL, NULL, true),
	('1e87890c-55e6-412e-a247-51a41821e582', '792306ad-010e-4368-b03c-6b72115f65bc', 'fba0b2b9-b081-4a9a-9998-1f288138b0f4', NULL, NULL, true),
	('c443a31d-cc09-4651-999c-03ffd8ddcafa', '42d91b82-c0b5-446c-a776-202d6baed9ff', 'a4f836d5-158f-4643-8ad1-55820a6d02f3', NULL, NULL, true),
	('4e754ac0-b8bd-4e63-8a85-dbe77b682ff9', 'c5521b28-3e98-486b-9ea5-a6cfb0863a3f', '2a01be7d-4171-45f3-982d-e6f4c7fb6d08', NULL, NULL, true),
	('262ee09c-094a-48d1-b692-88806f6e0ece', '08c8a648-079c-4c83-9311-5308e1e5a93f', 'b418bcfb-b7a1-4e06-8fc8-abefb368e2a8', NULL, NULL, true),
	('efd5e4d5-83cd-483c-80d2-e77de4b35d1a', 'b350853b-98cf-45fe-8d2e-066ff0cb21c9', 'c0f0dc1e-240a-44e0-a0d1-85557ea41bd4', NULL, NULL, true),
	('d58aaaa8-f5c4-4331-9e45-8638d2b44051', '97458a9e-eba1-4279-8cfc-b5cbcfdd2bad', 'a36e0503-0257-49c0-b2fe-fede9f990140', NULL, NULL, true),
	('28f5227b-7b68-4ec9-b822-b215e0cb5f60', 'beb94fc4-a6eb-45c4-99a5-6c9a2ce014a5', 'd292b5da-c2c8-439f-943a-b77519e48a06', NULL, NULL, true),
	('dc2b2db1-f55e-48ed-8d48-a522ac4b7563', '38d3b991-6f40-422b-a034-5a0e2c123494', '5a851616-ec93-498a-aed8-b9052dd78b2f', NULL, NULL, true),
	('c1ddfcec-96d0-489c-a30a-134e65bc21ea', '503a30d0-e2e4-4590-9163-841d3fd348a2', '3b1ce9a8-2ab4-4215-a778-b95a5938afd5', NULL, NULL, true),
	('08b4a0ab-49b8-4807-918f-00427be54afb', 'ad21c5ca-7d47-402a-8faa-c10e7c35a92a', 'af753f8e-2a47-466d-8fa2-1489b8ad9823', NULL, NULL, true),
	('d5cecb12-fff1-4435-a08f-200592751b62', '1a90747e-f7df-4352-9460-d0e28836aec5', 'd34624f7-95b5-4629-acf9-7aa95160f7ba', NULL, NULL, true),
	('9c7e1427-1a32-4d56-8425-debb21ddc5fb', 'f3b19321-3542-48f1-88e4-3d310a5bbb40', '97310377-f4c9-45cd-9acc-22f14a165640', NULL, NULL, true),
	('87d808b0-7ae0-41bd-8a62-15167a0f5a15', '514d6b9e-f7ff-4778-8f1c-a079d50bc60f', '682b27b6-fc2e-4734-ba33-ab96083bad02', NULL, NULL, true),
	('f8c2f78d-35a2-4af7-8ce4-8ffe543ebf32', '68b3b421-0bca-4528-b342-3357fcfd1790', '87b6ead5-d37e-48e1-a944-25b3364a3b13', NULL, NULL, true),
	('a92b12ce-cc1c-4166-a7b0-b05873cb6882', 'b20a460b-8cd0-438b-9f7b-fbc1bc764b7e', 'd6d73dea-10eb-4b24-9cd9-e2ac8ade8e11', NULL, NULL, true),
	('3f67a566-78f8-4317-936f-afcb8a9f74e9', 'e342a807-9feb-491b-9d66-58c0fa01bd10', 'f019d94a-2daa-4c8d-a45f-bf9e70cc0401', NULL, NULL, true),
	('70421737-5242-4cd6-ba58-437ae162d24f', 'dfe640cb-1882-4212-9b2f-cbceb11cfc4d', '6df12011-91bc-4df4-95cd-57f7a691cae9', NULL, NULL, true),
	('9a27eabf-8fc0-47c3-8cc6-c876b87b5a9f', '9ea75145-c635-415c-9948-d39f59b13def', 'e55fed18-fbb5-4218-a6e2-46fefd8999a9', NULL, NULL, true),
	('90b2a825-08dc-4286-9f27-c51025a8e460', '4f1f668c-bd3a-4cc8-8865-8aacd9b5402e', '97561530-a844-49d5-b345-235c69c66ae4', NULL, NULL, true),
	('17c34561-0785-44c8-9bdf-a56936b579f6', '9b3bba30-d2c9-4354-88b8-33efe55eedc8', '90ddde1c-9c1c-4705-8495-c38da5c137f5', NULL, NULL, true),
	('2496caf0-0485-495d-a9a8-ecebfdd7081d', '8c92a329-db6f-46f3-89ed-8d0d1ec6b6a7', 'eb5b0b5c-a949-4f27-87e2-47c2b20c2ab7', NULL, NULL, true),
	('8fe6b81f-1e2a-4fc1-8f99-4f01aa521b01', '4cd8dfaf-65e4-4312-b361-31955b916e4a', 'd2d454cd-322a-4885-adf8-5f5b1971c476', NULL, NULL, true),
	('6d7be1de-e582-4379-82b3-52a651b7ca5f', '37b2221e-e4e3-4cb3-a6b5-266358f5691b', '942acd8c-ef18-4af1-8d40-0dadd1eadf5b', NULL, NULL, true),
	('4f185830-9aef-4b43-8415-713b306d9853', 'a7e92b8c-2b00-4002-97e9-62af03ba2402', '85561b92-9620-44b2-9f12-8a272704daa9', NULL, NULL, true),
	('b045b40c-f5a3-4259-add7-29203da70b36', '52cc146e-1905-4045-8092-e6f6e4d08518', 'bdb3bf08-b740-4014-bb5c-70f05595b43b', NULL, NULL, true),
	('712f9348-68b6-42c9-a81f-0139d6f9445f', '1090af2d-5b0c-47bc-b4ba-a287019b0039', 'bc6bda39-2166-4720-b426-7cf7e96085c4', NULL, NULL, true),
	('eb90577b-fb22-49ad-88ab-450e5b57d4e7', 'c9256008-c9b3-4348-880a-21a688c25d4e', 'ff00d301-1407-441c-8ec5-65271bf391ba', NULL, NULL, true),
	('cf8e81d8-500f-457f-9eac-fdbb3c9b6a97', '4582260a-08c3-42bd-a963-4f8678202edc', '04878a1d-d789-4d14-befd-70cbd533c7b3', NULL, NULL, true),
	('202617f6-fffe-4975-b5b0-65b79a20144e', '509fb19a-791f-4a4a-a804-68a1765ef95e', '0e11f0eb-5761-406f-b9c8-fd01a4316870', NULL, NULL, true),
	('fb3c91af-d4c2-456b-b126-69ce8ec03111', '3f620461-6bab-4c1c-83de-920940e0b39a', 'fa3df49f-fa1f-4032-b8ec-d0f263dbee59', NULL, NULL, true),
	('26e9b014-9d16-468f-a0a5-8096f4cb7422', 'dc3ca87f-5371-4fe6-9623-f79e28ed69ba', '41193d0a-bf29-494a-aaaf-05ac1ede2322', NULL, NULL, true),
	('b4cd29cf-805e-4ac3-8ff9-fbfc7e23a0b9', 'bbd0afc1-3f20-4715-a673-7605809a34e9', '33006a16-04f2-41a2-af19-d8a2876d6f04', NULL, NULL, true),
	('5f3810c3-5e7c-4125-bdc7-d010d49bbea9', 'a3465664-8c85-48f5-9d3e-717175a4935a', 'b4e1b686-613c-4013-8c3e-39ccebc94d37', NULL, NULL, true),
	('648d019e-c24f-4d58-9f42-79a0dd1cd961', '25a50d68-55fa-40f0-a768-c7d9d2783930', 'e740c0fb-4283-437f-bda2-52aafd1a7e6a', NULL, NULL, true),
	('1a5c3bda-103c-4f5e-8e68-6ac487ad3377', '4e1741ee-115b-4005-a9e9-aab962001293', 'e374c4f2-c99b-49a4-9449-ea94ecde7601', NULL, NULL, true),
	('e84bc2bc-f8c2-40a4-80eb-befcf7def6c9', '5d85bb6e-7f71-4837-b39b-fa074df7980b', '49707b1a-f355-43aa-a184-e2fce887d9c9', NULL, NULL, true),
	('59ef7cc9-edfc-4102-af49-3bbdc828fcc7', '21ff2009-a01e-4ad5-945c-7bd433cb630c', '56835c41-66a2-4764-b14b-92bb66468d42', NULL, NULL, true),
	('2752aff9-a48a-4da4-949c-cedb0c55a26a', '790ad25a-d516-425f-b640-bf5cc5afa321', '017b9add-c648-49b7-a4c7-65f7de7c6c25', NULL, NULL, true),
	('44d8139c-192c-41b7-b88a-969a3b67b22a', '1d4ae5a5-bf1b-42fb-9aa8-0184ba006a24', 'c87b6099-8be6-45c7-9d5c-433bcea32525', NULL, NULL, true),
	('b9549963-6ac0-4eef-a420-1a7f2cf0c986', '31ce486b-0a39-471b-95b5-5819fc10ab43', '446693e4-33a8-411d-8979-0d79932e7bc4', NULL, NULL, true),
	('d96696c2-c6eb-48ad-be85-19c26aa058e9', 'cdecab28-a9cf-4e07-ab8c-ffa4810efc4a', '5ae43dea-8870-4d5e-ad96-f5b307ad787a', NULL, NULL, true),
	('e91ac3ba-50fc-4274-8392-df2137cea1ef', 'e7b9fc70-c693-4644-9a73-abe3cd0b9972', '077d3abb-b97a-4cba-8774-a5858ee13eba', NULL, NULL, true),
	('f818203a-743a-460f-8d73-721ff6a36c68', 'ecead755-839a-4ca6-bfb0-b20090b896c9', 'b4503845-d24f-4dbc-a6b9-751293682f6f', NULL, NULL, true),
	('ece0f094-d7ac-4c34-97ff-85329f4de924', '7c639bc2-e2a8-4e09-b543-fdee642b33fa', 'cda5f0fb-4753-4518-928e-0e5a0eff3271', NULL, NULL, true),
	('e25fc786-37bd-4c4b-8227-667a41ff7e0c', 'f9d34538-8b47-4a52-a5df-927b08eb15cd', 'b502aae0-349b-404c-9752-c36e48ad9818', NULL, NULL, true),
	('fd662202-1bbc-45b7-8a5b-0c14701e840a', '31d3a034-8231-40fe-b121-5a80cc140be6', '03e9b947-740c-413f-8245-823e7cc3b19b', NULL, NULL, true),
	('59d67913-b1af-46ef-81ce-d4c7909a5f28', '2f63b228-8cad-46c8-885f-161cc8d6ed33', 'a9f081bf-24a9-45f0-90e9-8ae9b823214e', NULL, NULL, true),
	('c804fab4-f837-4759-b69e-44a03b3e4450', '5b15144b-7849-40ec-a378-5b465d1fa2e5', '2db035a6-7e30-42b0-b20e-94964aec2dee', NULL, NULL, true),
	('f3745ff4-f373-4aae-bcb6-c6fe7d58aec5', '7b88e28e-8fd3-4488-afde-7c58c5950d99', '5013072c-6e76-4a09-af30-90af79265c26', NULL, NULL, true),
	('0ce205fe-5ac1-4951-9852-5b25357cfba5', 'c7cb76ea-75ae-4edd-a59c-2896366771a3', 'e5f200f3-b862-4aab-8bc0-3adc87d75171', NULL, NULL, true),
	('46d7f2c5-307a-4ac0-93d2-bbd9a0f7e254', '15feae7d-24de-4bc6-a260-449341490bf3', 'fc67db5d-45ed-4644-a507-a40ecd9994b2', NULL, NULL, true),
	('b892c36d-a317-4257-8708-ede11bfa8bc2', 'bb6dfaf7-2497-494a-a16d-06c7f4fa7c90', 'a7feafff-a347-4c85-8656-169875a689ad', NULL, NULL, true),
	('103b2f56-c476-4143-b4d3-d7784d6ed825', '7fc8711a-bbdc-4e01-9f52-a5ff37ef46bc', '9b0fb1fb-1c56-4457-8af3-df326b9f98e6', NULL, NULL, true),
	('a7ca4080-1a2e-44df-b4a5-be4199f67148', 'ccf4cb03-f2aa-4f0b-88e3-3002122443df', '06c0ed0d-3e50-44af-87fd-974211357055', NULL, NULL, true),
	('37ecaabe-c743-480f-a051-6650e380cfe5', '118f3260-efd8-4bfb-ae77-a896e91130ef', 'c8c3ec0b-e506-4584-83b4-8bc4dc3ff171', NULL, NULL, true),
	('4de74482-85a3-440c-9c2b-dd50fc09d777', '494d62c4-ca99-4016-984e-c4e7a969d8a0', '5034f523-bde4-4997-b61f-30853654a477', NULL, NULL, true),
	('353c36cc-201e-4e5b-9f7a-d1446d65ae51', 'fcae2962-663e-4fc7-b3bb-2d193f94144c', 'a6ec94a0-0cea-404e-ba9a-09c01b9f11e8', NULL, NULL, true),
	('019c049e-2f13-4cf1-9f31-64935bccf3f3', '381dd97d-3f6d-435b-8269-16b4f45b1ebd', '89b5e4f6-95eb-4a8f-854c-17c91059db2d', NULL, NULL, true),
	('32326126-8b2a-4830-b849-d71121f9a26a', '18eed669-b459-463d-80b0-7cf37d27d6a8', '673cbcfa-6f5b-4fab-b24c-7cf3009e88fc', NULL, NULL, true),
	('2888063b-d150-45e6-a55b-754acd5d6ad4', '3c0d0bc0-1537-445a-97a9-f12c1933bd06', 'db6491ce-a480-46c0-ae1a-f91303f671e8', NULL, NULL, true),
	('2e14e92a-bd33-475b-bc7d-42221e532d79', 'ef820af0-33dc-4e59-a1f4-af3ce7bad197', 'dea03165-a419-45c1-bbe8-894ab6602408', NULL, NULL, true),
	('92ce3418-db11-4135-a7d5-c8d64ba4bea9', '17ae0e8a-cfb3-44f1-b930-b3f8c94c2169', 'f1006fd8-7b85-42c7-bdca-469cc97fcba4', NULL, NULL, true),
	('f95bc2d4-57f9-42e8-8161-4641697e0a2d', '71722a1c-35f1-4d14-b51e-db53d90654a8', '3309c091-6209-4bd2-81f3-e953e66624cb', NULL, NULL, true),
	('b3d3d143-80d2-42b8-b3ca-795c6c1d670a', 'e8f27ba0-e393-425c-8275-2532f01975ad', 'f719db8a-a59c-4839-9eb8-4113ec0f5d0c', NULL, NULL, true),
	('6f872a7f-8826-40ac-84a6-9ffef846b2d2', 'f105dcc7-73aa-4765-a760-b6ddf6846983', 'e0400e07-fa7f-46c5-bf78-d5bb2475f3ac', NULL, NULL, true),
	('8e8400fa-64dd-414e-8969-92f639ba30b9', 'a980a1b2-682f-46af-a74e-eae6890bd63c', '332c38fc-04d0-4f39-bc8e-b0f72c76bd43', NULL, NULL, true),
	('63495093-d848-437b-b1df-7da017a80c15', 'a6aad290-b8ad-4e72-8ee0-23f207c4fea0', '187c7041-14d8-4051-a649-d77ff5b10904', NULL, NULL, true),
	('f270b8b7-2eac-4641-8e8b-69f1b3307cdf', '3db8fe08-6acc-4e09-ab91-5f9fd67afa7b', '5ff98f3d-075e-4f15-a044-479c7d59d299', NULL, NULL, true),
	('f426e9a9-baeb-4e1e-8a5c-de51c3f1bc05', '880f7ddd-3941-469c-801c-c135d1902c88', '44258f9e-c5ca-4f47-826e-ea4448dc7b39', NULL, NULL, true),
	('0c260aed-fb0c-43a0-b68d-6ed812008ce9', '86cf0c5a-7090-42c8-98f4-17ea2f49d9dd', '7c636518-736e-4660-a6bf-38cfcf2c9f39', NULL, NULL, true),
	('f88deb59-12e4-4a3d-98fd-45aae1854712', '8a6ef6c7-85c4-4d4d-8870-f9ca1c4fa4e1', 'a03546d3-1adf-445e-b96e-9a25fc2b92f9', NULL, NULL, true),
	('3bb3b2ad-e689-406b-9213-5761dec5cb35', 'a818b6f6-b18e-4e82-ae75-ba20099725f6', '4dfd7688-147b-47b3-b883-e41426f22414', NULL, NULL, true),
	('6f997d49-9fe3-4ca3-9766-231075c9ddf4', 'b6cf59f0-88c8-4cc7-843a-f35669d6f53b', '8b0462a5-9181-4529-8769-aca7ba890465', NULL, NULL, true),
	('92de4e00-1b2e-470f-8044-878d7454be08', '973d82d1-0dd1-4434-a9a7-b51e71cf9f79', 'cc3e154a-d2cb-4d25-9c3a-707887952b9b', NULL, NULL, true),
	('a7066660-a749-438f-ba7a-87fbdd3c5e2c', '37512013-765a-4768-bd8b-11b3ced29d82', '4f8da841-6ab3-46e6-a645-0847978e78e2', NULL, NULL, true),
	('9aff9f4e-fbfc-445a-bc2e-6c01ecde4f08', '5eced70a-a034-4ba2-92f5-e3d45f864563', 'e1de73cc-6c38-46d9-b9b9-0121f2a0bdf7', NULL, NULL, true),
	('93cb8783-9c95-41a0-9ded-f449e6e30280', '101ba857-3fb5-4050-bc2e-f4f077bd2675', '2d4707c3-cf6a-4990-8606-bf1c614e1339', NULL, NULL, true),
	('b4792b2f-fe25-48e6-bb2f-4d1a2251338e', '423000a3-724f-4d6f-9db2-8e1de3021008', '980fb43b-e022-4c74-974f-491a624704e5', NULL, NULL, true),
	('30458455-f09a-44e6-bbaa-09b366913204', 'ed1c52e7-6b11-46ed-90b0-9c4693f117ff', '0e8b54ba-0e91-4a63-8f9d-15a3720a4263', NULL, NULL, true),
	('0985e368-6f73-4fa2-86e8-23828dcd127e', 'dfc53132-7e4c-4446-a93d-b0c4fdd51cf9', 'cc753e92-609b-4670-b990-9e54bd98759a', NULL, NULL, true),
	('8f32ee7c-f167-45df-b092-53c6d407847d', 'df56804f-c789-45b4-9e99-2d32d35885d7', '3f20db79-36c9-4313-a9af-1420703adb73', NULL, NULL, true),
	('d353f342-21b4-4a00-bf05-e4966f316341', '207fd55e-3c3b-45f7-8ec5-88448a1250f0', '2753d56d-7daa-4111-bc63-f5b7470035bb', NULL, NULL, true),
	('b9a41bc9-ffc2-41d2-8742-fdfd925a06a0', 'de1f98fc-9f40-40d3-9258-94895509f86e', 'deaf4026-684d-452c-b80c-ed5a9db7ade2', NULL, NULL, true),
	('2fc9755d-e1ab-4133-a2af-50abdeb45a77', '174b2f81-5d42-4f2c-af12-e971c271c3a5', '51fadc3a-a181-43de-b550-52aa96da3e9c', NULL, NULL, true),
	('2c5d646e-fe30-4163-a478-45f6dc2a54e3', '03d57383-f9a6-4bb2-ab4e-e40b9185ac9b', 'c155281c-f98b-41bc-bb1a-1c2d8b044491', NULL, NULL, true),
	('e592c4cb-ab4f-40e8-ac35-448a9cfb9fd4', '4ce9e171-0b8d-4b6c-8d96-afa675dd3246', 'e7bf23da-dfb1-464a-843c-24a483893614', NULL, NULL, true),
	('9d366fd4-1c26-4e23-af92-cf8a68995a59', '3145dc47-9a46-45ca-be37-6c7d40f6b784', '7fd1ea14-0082-4dc3-b57b-b0b18b83776d', NULL, NULL, true),
	('376f577b-3932-44c4-b324-2538a701d487', '0d3908df-4968-4d5e-a5b0-40158fad447e', '4c5b6bf7-ffb5-4cf9-ac1f-874721ea2a03', NULL, NULL, true),
	('27353d83-6fcf-4966-9747-309b9b97876a', '26652651-d26d-4dd2-9035-0430535a8f8f', 'a2e945f6-5f41-45b0-830b-f8c31901f5f5', NULL, NULL, true),
	('6440ca32-e188-41a4-9ffc-8aa393e85452', '57c56703-ad41-4adb-9b29-bba728bed1d3', '77a62ab9-ad2a-4a1e-9afe-4ffd731a0439', NULL, NULL, true),
	('cbda95ec-69bf-43c0-87ac-6bf5064f8b4e', '4963ff31-907f-47f3-8e7f-c1c32886b110', 'fa59d5bd-98f6-4a50-8082-2e7151bb13b8', NULL, NULL, true),
	('55df8a39-8458-40ad-bac4-9a927044aa6c', '82e43af9-0fc1-49a5-9ea4-a4b010ae28ce', '26eeaff9-c310-43db-ad82-4c0bfda460b8', NULL, NULL, true),
	('2b4c0cf4-042c-466d-8823-1c3741ecfb54', '29f01a8f-c151-4be6-b960-80ff34f55fb4', 'c2911c7b-31b4-44d7-8eab-2c65fcec2d92', NULL, NULL, true),
	('b7083685-1255-43fb-ad3a-2f01b3a431b9', 'b57369da-4b98-4646-9df2-186d75b057be', '53c392d9-9d44-4c5d-bf03-b2c39df95953', NULL, NULL, true),
	('6810a09e-5fc5-40c1-a7ca-05aaf0cabbdd', '01d60469-dd5b-4acd-8f09-1a79c44bab0c', 'fb889851-0b87-4fce-b606-bf250ef492a3', NULL, NULL, true),
	('a8d3d3ec-2cb0-450e-9848-57df1b406d62', '015979f5-7391-4186-897a-5c42efab4484', 'f36d53bd-7d85-4040-af96-d22cff0ef708', NULL, '2009-04-01', false),
	('e5000980-c3ee-4f54-a53b-2c3e657271c4', 'de5c6439-d03b-4d07-b9de-7d2304d9d71b', '2cc7068d-e2c1-4f89-bcf7-d254640fccce', NULL, NULL, true),
	('09fdab57-6bdc-4b76-be44-6996a39246b3', '19b9acc3-065c-4899-8b1d-10150bc10344', '3802ccd1-0803-4817-bfc8-5188ccbf06e2', '2009-04-01', NULL, true),
	('b39a1c36-9634-4034-9903-e91fad345b9b', 'd77ad846-fd26-4433-9171-4af805e22976', '6fa0fa20-9beb-447f-bb7e-c55064758477', NULL, NULL, true),
	('78773f8b-e30e-47b5-91ef-6feaa2ffd634', '3608afab-cdf9-40a7-8619-5e575c6ac933', '5b5721c4-9f88-44cb-9302-e6130e8ed6e6', NULL, '2020-04-01', false),
	('eff9595a-f7e0-4a7c-aca3-b6232f2e02ed', '3608afab-cdf9-40a7-8619-5e575c6ac933', 'e4636164-5024-41ae-a628-fdda61a7ce3f', '2020-04-01', NULL, true),
	('1cde2a1b-e6a8-4665-b471-a4b7aec68c43', '3e332f79-eb0e-4e86-8f90-cdc9e562e619', '67b5f616-39fe-4b31-b116-924192c6859c', NULL, NULL, true),
	('548470ac-50d4-4f0c-975f-6c9275798cdb', '4e20c534-9df8-4679-9720-18c0b9eb1af4', '00081acf-dd3a-41c1-90d9-6be0dda47be2', NULL, NULL, true),
	('57868f69-4141-409b-8c4c-2b5384f1a1de', '4dab42a4-1908-47e5-9041-e18437df14a0', '0604190a-2422-4c72-90b7-5684714a59ac', NULL, NULL, true),
	('11da55b4-9e64-4f21-8a17-528b83e6fa9a', 'd20cb9c8-d38b-405c-ba9e-c50479a5c228', '1b00df3e-1b56-4574-9bf9-cfd920c1e468', NULL, '2019-04-01', false),
	('a1b800b0-c7e9-4fd3-bb64-8b1e3f57fb62', '3c439d44-ae84-4e17-8673-376fc92c0c1f', 'b522b97d-8d52-4b79-bf36-bf671af9336a', NULL, '2019-04-01', false),
	('c1b62fc8-9836-4181-8d2b-ababf08a46e6', 'ba1b60f5-f3a6-4a2d-aee0-2b2463accd7e', '2f9a996e-ad57-4f99-8f3e-2ce482a1927f', NULL, '2019-04-01', false),
	('2333dc42-f745-4892-b72c-bae0883ed4d3', '0ae1d2be-6b35-4c3f-ae3a-9242048b1e15', 'd5606470-d7c8-4ba5-9756-7a9895ebc1fd', '2019-04-01', NULL, true),
	('1dd7edc3-3734-490d-8c5f-2305b7c2b840', 'ca8c2e8e-a9cc-437f-b5ed-3cd6c39e6817', '339df911-4d26-4c96-9952-39e09d8d3e16', '2019-04-01', NULL, true),
	('c8bc4723-4f4f-4d73-802a-16f5cda87a95', 'bc421618-1809-49cd-b7ca-bb95171fd9a6', '9bc31c3b-a426-4c3b-aa93-9857e76a029c', NULL, NULL, true),
	('e8dbda76-869d-4c8b-9f60-8c2b4f9ebf4e', 'a4af7760-1520-43fd-a261-20525927dea2', 'bbeb4921-d158-41b8-bc3f-cb69e816e97a', NULL, NULL, true),
	('ad5b991f-3166-45c3-8440-237817c23c79', 'd823dc7b-5dc8-4731-9c89-c24e42073e5b', '22743a4f-933c-4f60-ba3b-514714ce8752', NULL, NULL, true),
	('3226060a-b1bd-4b33-b5bb-c37d6a74b56e', 'ec2049b8-e976-4f2d-8541-b5275b3c5457', 'b28aa95b-78f3-43b0-88cb-eb3059f8d6e9', NULL, NULL, true),
	('63e7a326-2131-4ebe-ad69-2ad5c35da478', 'c35ba972-dab4-4be0-941a-45c403f2ae1e', 'e05aa0c3-07e2-45bd-a9ee-fd2e1e7ec3e2', NULL, NULL, true),
	('e8dcf13a-1eed-4c8a-8d44-de4a9b0a6fe0', '2e465d7c-155e-4544-995c-f3b047c4fe2e', '025bb820-d1f3-4453-86b8-9f38b5215eee', NULL, NULL, true),
	('e436cf17-735e-4f4f-80f6-e53b7bbb7a82', '070573c4-5588-47e8-b9e2-20fc1715ba75', '93ae56c8-97e3-4329-aa89-fb1aeb55b97d', NULL, NULL, true),
	('2f7c0c71-4b91-4a50-9f31-304855540b80', 'ad0d2b0e-02e7-4791-9da9-dfc9099c6046', '39ef0d98-239c-4f8f-9b5a-d8678df8c398', NULL, NULL, true),
	('671507ad-9f02-48c6-9b30-bd72d3fa52b3', '43478985-2bb2-4a44-badf-49c4769be168', '975790b4-4ee9-4441-a221-0542a7643960', NULL, NULL, true),
	('ca284ee4-f01c-4ccc-af01-c9b82c0ee0c6', 'd52a9826-1ab8-4e37-b7cc-80366f644237', 'cc9bd538-c4e9-4d85-bf7b-71f1df6edc23', NULL, NULL, true),
	('25079d47-2721-48ae-8a6d-7ea21b48a6c9', 'c2648242-e279-4843-9816-f7a50d577ab6', 'dc951090-305e-42e5-aaa3-5ebccd8ef9f7', NULL, NULL, true),
	('716b95e1-44a7-401b-bbe1-2dc30b7f1b7c', '66154b30-81ac-4fcb-be95-eeeb331996b6', '78ccc4b3-472c-4e62-9d53-9bded5d55fe3', NULL, NULL, true),
	('a4e44a8a-2afa-4e52-ac91-067836ae17ec', '18fd14b9-a20f-4c46-8de5-1d144f64d211', '5ef4014b-53b5-4283-95d9-02a053ecee56', NULL, NULL, true),
	('0366605a-b3e3-467b-9599-11f021822c42', '519b4f50-9d0e-4d46-8b0c-eedc62f0cfe0', 'b1de0c81-1379-4d63-809d-ff0776e9290a', NULL, NULL, true),
	('ed622b0c-666a-4b0d-a52a-e5e5f57d9861', '028bf838-1647-41fa-8445-faa0d988e087', 'f23d827d-4352-4a1e-ae6c-29d10933bec9', NULL, NULL, true),
	('44e6c3ff-f63f-4b56-bdad-d78241c1c3ca', '18fe941d-db8d-4df1-95e4-aef3a90ef0e7', '9b0cbf0f-1631-4130-a947-614ee98dc9e0', NULL, NULL, true),
	('539ea0ce-5ae0-4349-9b6f-71882467ff24', '1992e092-9a64-45d6-b437-c43220a62d3e', 'b36730b2-e5cb-4c99-8f59-735407239472', NULL, NULL, true),
	('85b96f10-f419-4b68-bc9e-b2b5c643886c', 'a8ccff15-adf7-4cd4-8c76-c400fbf9cb4c', 'fab48b2f-1c2e-4ced-a086-c500ac4df2d5', NULL, NULL, true),
	('874f6aa5-f574-4495-ae8a-c01eaa399a3f', '49d73d0d-f7aa-4276-b296-5dfff9fc4301', 'cdd84a97-ddf2-4fbb-a7f2-d18b16870e62', NULL, NULL, true),
	('6fed8956-f93e-471e-a835-1a8953450dfa', '0e668acc-4129-479b-a8eb-8156e5d51b18', '2ac7c2b6-53da-440a-a313-41c78eb35ad6', NULL, NULL, true),
	('981206c6-877e-42cb-8e44-09fbebc228a1', 'bbfe5723-759e-4a58-8b95-2ea278c6c7f3', 'bad2d713-bd8e-4c56-9435-ac404e51109a', NULL, NULL, true),
	('8fd41e24-a48e-40c9-86ac-a03f650de002', 'ad517542-eb8e-46b1-bc72-42d6ea79d61b', 'b952d053-4fe3-4a17-bb21-8c1578788b48', NULL, NULL, true),
	('101de4f4-4144-4a72-8d93-361ad5ba6746', '00318e38-2a8e-43ec-8efd-44e82e536103', 'fcf0f52a-1c8a-4090-a361-bcebfe4f6986', NULL, '2009-04-01', false),
	('0b54dba0-5f84-4184-924b-39fc7eea6f0f', '29b6c275-23db-4fd7-939b-508a60f001af', 'de79e58e-3465-45fa-8168-5f9f1ad00232', NULL, NULL, true),
	('82e54c87-1f46-4bfb-a0ed-71dac3ee8583', '82200b36-b283-46cf-a311-415a30de46da', '2252b68e-9ecd-4199-bd4f-ba1961a25fc5', NULL, NULL, true),
	('bdf1bfc4-cb59-4985-b256-6df68e49a351', '8e70fc58-fe8b-427b-9148-770031d4c3df', '5fe408d9-fb14-4acf-999d-f8caa9098401', NULL, NULL, true),
	('3850ecda-1881-48f9-ba7c-ac5cc305312b', '2322d14d-98b8-427d-9308-1f22596df641', '5827756d-86e3-4de5-8469-3f283f7720c4', NULL, NULL, true),
	('605db2e3-79b2-421a-a18f-821c72e41814', 'f56ef045-d528-45dd-9787-9550e7c7edb2', 'ef858f6b-3d2d-4d2a-a458-6e855b6aca27', NULL, NULL, true),
	('434f6324-e6e4-40d3-9c36-70c209631654', 'ceb5b628-dd85-4324-931c-be1f388de7d3', 'd58456a8-eb8a-4d44-bd48-9611fff6b332', NULL, NULL, true),
	('f8c8c376-4f71-4881-84f2-4587668e41b1', '9e2d6e72-022f-4496-9cb3-aee6b289f423', 'b360b238-6c52-4832-9043-6233078322b2', NULL, NULL, true),
	('bd38cee4-5cf7-470b-a06d-b302def4089d', '2a3c0873-623d-4328-8d2a-1eed96c45d62', '324b4c97-a6f7-42b1-a0bb-691448804347', NULL, NULL, true),
	('e6641fa5-5535-4fca-b3a8-36afc0983ac1', '6cbaa646-51b4-45d9-95ae-2dd385f93133', '4dfdecda-ac8c-4253-abce-0354105dcd9a', NULL, NULL, true),
	('46747818-72bd-4e74-b356-ab5dd46cdae5', '265aef13-1d72-49d7-b703-50d46549acb1', '49d316d6-6cc0-45f3-a869-8380cea33cf5', NULL, NULL, true),
	('3b0bb043-b305-4af7-9334-01ad1265506f', '44e07e7f-aaea-446f-a1fc-f064acdf1588', '4eb78548-efa5-4688-85e2-0d3a01ecd786', '1998-04-01', NULL, true),
	('178df9b9-e7fb-4c78-b39d-bcfdb281b0c3', 'c32e971d-5e37-4bff-8b38-ff843d13fb22', '705c1c08-2b8d-48fb-9fae-52ee96575424', NULL, NULL, true),
	('f1c30044-265f-4e2c-9ba6-65650304d7ad', '569e3b19-8b5f-49cd-b15c-37ed952daa4d', 'bbd501c2-2def-4e0c-b22a-ceb523d5ab56', NULL, NULL, true),
	('2c34847f-71d7-466d-8997-0de95f681d6f', '0edc3732-2e7d-466a-87cb-4c08fc145b64', 'bc6f073b-9831-466b-8488-b97fbf19f2b4', NULL, NULL, true),
	('13ed281e-ff01-4a96-9967-c38d76cd6ec3', '761c3e40-402e-4efc-96e7-ce3de51cc90d', 'f8e65d35-b2db-4c0c-9f32-9069cf5525d0', NULL, NULL, true),
	('551de912-a535-43ae-81b4-46c60ffc7610', '7bb23767-d9ef-4ea4-9a45-3eecb0dac5d5', '5fb139ce-a696-4ac2-ba3a-445b361c206a', NULL, NULL, true),
	('4989e1d3-9d5a-4a5e-9309-7db83dc7d08e', '0d29d3f6-b284-4d34-b4f9-c92a3cba8cc8', '1f7e5cff-981d-4a19-b175-7976651532a0', NULL, NULL, true),
	('e8f6b81e-4546-48d1-b5f3-325bf5a06808', '01cb278f-07be-41f8-a883-2083f13268f9', '64f34b7e-3413-4bcf-817a-c8024a243b32', NULL, NULL, true),
	('e91d1599-14ee-46fd-9119-d517749ffcb2', 'b26a62a7-fa83-4a65-a52f-4d5e5b868bca', '4c61a1bf-474a-4530-9e9b-783f74eef813', NULL, NULL, true),
	('d677058b-a579-41ce-9bcf-eb56e5d93f3a', '67a77259-59ec-42a0-beb3-d099d644d764', '6f9bc24c-f6ca-4cbe-9946-8eeb13fc4884', '2009-04-01', NULL, true),
	('1a74ed23-94b1-4a4b-9807-1240376d44ef', 'e00798d5-fd49-4c66-9662-3de1c50249d6', 'c6224d1d-e1dd-44f2-b9b4-79c6b57aab94', '2009-04-01', NULL, true),
	('e9dc2aa7-b28e-45f4-8657-68fb25b6792c', '039e3cbe-c7ad-45dd-b76b-189c229db7de', 'f8cd82a7-4c45-483b-9ba6-75d46fff8ab6', NULL, '1996-04-01', false),
	('564c3c83-9bf5-45e2-bf3e-c62cef6ac6d4', '20b8120e-1b11-4bd4-93c9-02c83207be61', 'f36d53bd-7d85-4040-af96-d22cff0ef708', NULL, NULL, false),
	('631eef63-7d37-4d0e-b5bd-85cf2c2518a2', '0cbaaeee-6a62-4fc7-b54d-787a283458cb', 'ea046f10-de23-4dda-b3bf-2ca12e876bf2', NULL, '1998-04-01', false),
	('0d1950e4-a1ec-4c7f-a872-e741d7a7e008', '08f5a7d0-67e0-4280-a4b9-dd1689c2b8a3', '5b5721c4-9f88-44cb-9302-e6130e8ed6e6', NULL, NULL, false),
	('0b2ed288-a662-447a-8525-e00a534e02d9', '7234b852-2635-4429-b096-1881c6ed8a6e', 'bad2d713-bd8e-4c56-9435-ac404e51109a', NULL, NULL, false),
	('3228af35-eddc-4e7b-b811-628012324266', '24d84499-975e-43fa-b16f-d8348426b0bb', 'fcf0f52a-1c8a-4090-a361-bcebfe4f6986', NULL, NULL, false),
	('5929fbb2-70b0-4863-be39-73e40410e3f4', '1651f2a0-db45-4504-b4cf-2a3c5051b201', '3944a193-a6f9-4a9a-aad6-219c83ff71ff', NULL, '1996-04-01', false),
	('06493854-c2ea-46c5-b508-cbde99a27456', 'c946edfe-d0c5-44ae-b938-0962f9ab55e6', '6c429195-ac5d-4622-843c-fe13aedbc0e0', NULL, NULL, true),
	('39f4a1a1-87b5-4fb9-8836-c4245167ae03', 'c92377d7-9be7-4869-9787-32641b5d0d6d', '052e2cf5-ebd4-4a10-af22-01dd41afe5c7', NULL, '2023-04-01', false),
	('8bc4c899-f335-49e8-b053-ce7d442bbfcf', '26869cbb-57c2-40f5-81a0-5aa050358225', '00081acf-dd3a-41c1-90d9-6be0dda47be2', NULL, NULL, false),
	('579e35a1-a7f7-41a3-900f-8341e9aaca4e', '7a2f42c1-8c7b-4c63-b31a-98a2810e850a', '5fe408d9-fb14-4acf-999d-f8caa9098401', NULL, NULL, false),
	('5382cfac-c5b2-48e4-8586-cbda219f5aa4', '0aba9243-d54d-464c-a52d-02181cde3069', '1b00df3e-1b56-4574-9bf9-cfd920c1e468', NULL, NULL, false),
	('c64d7b88-fcc5-4826-8fde-43a0ae90a542', 'c0b22e46-a1ff-4cb0-b60a-871ff6051f66', '9bc31c3b-a426-4c3b-aa93-9857e76a029c', NULL, NULL, false),
	('eaaf5f30-c020-4809-9465-d9f156fb299f', '8027d847-984e-4d08-955a-f362cf44b90e', '22743a4f-933c-4f60-ba3b-514714ce8752', NULL, NULL, false),
	('c90fc534-e79c-435a-9ac2-13041cca14bb', 'acfd918e-3976-4936-9ed5-a5deb54975b4', 'd58456a8-eb8a-4d44-bd48-9611fff6b332', NULL, NULL, false),
	('1ce60817-0b96-4508-ae24-66c96bee5187', 'b367f230-6596-4fcb-9a9c-54552a64a823', 'c0bab65a-1dda-451f-9012-638ae1078ebe', NULL, NULL, true),
	('d82cc44f-d032-4f22-b3d2-653a40a6cd58', '41e1c52d-d38a-4a88-bb5d-2da7607b10c6', 'e05aa0c3-07e2-45bd-a9ee-fd2e1e7ec3e2', NULL, NULL, false),
	('e5a0e914-fd48-4014-a8ea-26726c819e6c', 'b79884c6-0bb5-4c47-96f7-21e99fcea840', 'dc82f36a-c010-405b-ac23-985fc21c7cb3', NULL, '1998-04-01', false),
	('233ecd5d-c10e-4539-9be5-6f5011aef6c8', '38167fd4-3629-4cb7-9f78-821dbc07a7ca', 'df867651-16f1-4266-91f9-4509f3a9ac50', NULL, NULL, true),
	('a5036635-11b5-468f-b148-489cdc583f14', '1bf9c770-0c6a-4509-8e5c-a5932d6877f8', '97939759-3e3b-4c4a-a2b4-9ff9ebbc145c', NULL, '1996-04-01', false),
	('524a68e9-6044-4b9c-b138-73a7863fab53', '06f1e991-6f6b-4473-88ac-dd6c8ae76aa3', '35d541a2-f11c-4778-99e8-4d779bd9da62', NULL, NULL, true),
	('bd289413-106b-465c-98a8-6f648d794e0a', '47c04385-234d-48d1-80c0-37f05c93fd66', '4eb78548-efa5-4688-85e2-0d3a01ecd786', NULL, '1998-04-01', false),
	('255496f4-221c-4202-825f-eda84c647b3d', '204308a2-7249-46dd-89b7-6f12ccf2d4b1', 'bbd501c2-2def-4e0c-b22a-ceb523d5ab56', NULL, NULL, false),
	('cb5bbd71-910e-464a-a259-896cea97c863', '1fa33a03-da01-440f-9233-b4823fb0612e', '39ef0d98-239c-4f8f-9b5a-d8678df8c398', NULL, NULL, false),
	('a22ba674-5d8b-4c38-bfdb-595d9f8324df', '965d48ff-f5e5-41d8-97c2-ce57eb293214', '6b2e2c44-71c7-4ab6-800c-7202af3a9df3', NULL, NULL, true),
	('b31edfb9-7b22-4bc9-b174-3491d795338a', '8f12ea6d-4553-4be4-a977-254ecd121c5a', 'a95ba826-f1eb-4c64-80a2-9f147d9a4a7f', NULL, NULL, true),
	('cd5ae02d-e380-4a58-a365-c5da4ab0e2ab', 'd851ada9-e781-4ffd-be70-d5db920978d7', '53c392d9-9d44-4c5d-bf03-b2c39df95953', NULL, NULL, false),
	('69603b1c-87b1-467d-8e45-2d84c701198c', '53ceec26-6940-4a33-b2e0-6190dbb28235', 'b05840c4-c612-478c-8243-56cc8542886f', NULL, '2021-04-01', false),
	('048f18df-1356-447c-8014-a5375618ed67', '866ace78-0716-482e-8870-0f851a566f8f', 'de51de93-8ce1-49e2-8740-929dcc6cfccf', NULL, NULL, true),
	('4e60185b-befc-4c75-a324-f26cc5f020c3', '6eda8156-7d6d-4efb-9c53-5227f148c30e', '5fb139ce-a696-4ac2-ba3a-445b361c206a', NULL, NULL, false),
	('cfbb8d0c-154c-453e-8b03-3bded857465c', 'b8f58bd5-a8ed-412e-a1b8-cd2e5cd13291', 'ba306a61-57b7-401a-891a-21302c0debf9', NULL, NULL, true),
	('0afb0a12-f5ef-42f9-920d-b0968e2750e0', 'a02e4a50-1f45-4134-a890-c7faacb2985a', '64f34b7e-3413-4bcf-817a-c8024a243b32', NULL, NULL, false),
	('9ced8a97-a695-408c-84a6-0e2c09cac013', '41b81c3c-5aa7-4335-8502-438a3d59ee46', 'fbd8faf4-3dbe-4410-81c0-ce0891128d5a', NULL, NULL, true),
	('33959df8-c672-4ac7-b067-afb49a15307e', 'ffd38ef6-e91f-43aa-8cd3-08e19c415984', 'dc951090-305e-42e5-aaa3-5ebccd8ef9f7', NULL, NULL, false),
	('ac19a791-30b8-4bb8-9d19-d20c3cb857da', '70f640cb-e7c9-40ad-aec3-aba613960cfa', '1a88dac3-1035-481a-89e9-a53036c47a51', NULL, NULL, true),
	('a4dc9d2b-ed7e-43f2-afd4-aa8c3b46c995', 'e57e572e-d376-4a28-a4eb-9b965d8894c2', '30783fab-3dcc-4091-b26a-af8907c0dfd1', NULL, NULL, true),
	('890e3832-06af-4de5-9179-5d0bce6d5a9c', '9cec40c4-03c1-4e42-9ff8-d937643ddef8', 'a1e1223a-8442-424c-8b9f-59714899a9b0', NULL, NULL, true),
	('e56b56ee-615f-4d3d-a887-2bc2b18f4580', '50ab1a34-54d5-4a37-8af4-c9573d59ebdb', 'cf576508-e284-4938-9c4d-ea3439e92f75', NULL, NULL, true),
	('6be64525-0202-4f90-a71a-89663bbdc0b7', '0407db9f-cb55-4035-b471-4eda7db8b833', '5ef4014b-53b5-4283-95d9-02a053ecee56', NULL, NULL, false),
	('f3b2527e-e391-45e7-93cb-c539eb5f1605', 'b3dba0b2-5b6a-4e1a-884d-21965932173b', '058cc7ab-9391-4aa6-9ba4-93a8cd4e378b', '2021-04-01', NULL, true),
	('afc4f192-222a-4fd2-9970-c46898e3828a', 'a5aa5877-9cd5-4431-9952-d7728e90cc0b', '0e0e4de8-f04e-428a-ab29-ef1bc67cb376', '2021-04-01', NULL, true),
	('e16d3c31-b28a-42d9-a406-cfa4c5bdda93', '8f75c3cd-55a6-4f2c-998e-e8fcdbcfd2c7', '1c20b22f-1f5c-41d6-a3ff-3696e4522a15', '2023-04-01', NULL, true),
	('2a813012-c757-4d9f-a804-7b3348208867', 'f4a0d585-5725-40ea-9e5f-12c1700155ad', '41272cc4-45fc-499e-bf6c-ffe78ce50b9b', '2023-04-01', NULL, true);


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
	('3d52ee71-c034-485d-9b47-92b2cf06a522', '02f5adea-7922-4c31-977b-ee43078ecb6a', 3);


--
-- Data for Name: resourced_provision; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.resourced_provision (resourced_provision_id, specialist_provision_id, capacity, pupil_count) VALUES
	('bcff6794-4562-46b4-97fc-96042a493af2', '3d52ee71-c034-485d-9b47-92b2cf06a522', 24, 24);


--
-- Data for Name: sen_unit_provision; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.sen_unit_provision (sen_unit_provision_id, specialist_provision_id, capacity, pupil_count) VALUES
	('49177064-5145-451e-ae20-4d4c40101672', '3d52ee71-c034-485d-9b47-92b2cf06a522', 24, 24);


--
-- Data for Name: statutory_age_range; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.statutory_age_range (statutory_age_range_id, education_admissions_and_provision_id, lower_statutory_age, upper_statutory_age) VALUES
	('614694a7-0504-4005-b3c6-e5e28bc08d98', '773abb21-8738-4e14-acc2-1c7d6079959c', 2, 11),
	('e591525f-6004-4c33-a758-b7165d180b89', '93c48e2c-b419-4287-a3f2-fe69c7ffd957', 4, 11),
	('f3c6df6f-272b-4df4-9f0a-c40681a41bf1', 'f7b7da3c-a1e6-43b1-ba3c-2e6dfc2899e6', 11, 19);


--
-- PostgreSQL database dump complete
--

\unrestrict JqwXHcwcyCRIJgh4Cqmu6nli7crJbdRVLC5a5gey86VZbvwQXaeB1EHR6nuK9Cu

