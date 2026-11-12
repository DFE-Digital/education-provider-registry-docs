-- Target-owned route identities; source-owned dictionaries are imported from BAU.
INSERT INTO establishment.academy_route(academy_route_id,name) VALUES
    (1,'Converter'),(2,'Sponsor led')
ON CONFLICT(academy_route_id) DO UPDATE SET name=excluded.name;
