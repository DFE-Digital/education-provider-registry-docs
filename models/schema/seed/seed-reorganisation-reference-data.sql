-- Target-owned lists; integer IDs are internal and are not BAU LinkType codes.
INSERT INTO establishment.reorganisation_pattern VALUES
 (1,'Replacement'),(2,'Absorption'),(3,'Amalgamation'),(4,'Split'),
 (5,'Spin-out'),(6,'Transfer between continuing establishments'),
 (7,'Complex reorganisation') ON CONFLICT DO NOTHING;
INSERT INTO establishment.reorganisation_cause VALUES
 (1,'Academy conversion'),(2,'Fresh start'),(3,'Change of registration regime'),(4,'Change in status') ON CONFLICT DO NOTHING;
INSERT INTO establishment.reorganisation_outcome VALUES (1,'Closed'),(2,'Opened'),(3,'Continued') ON CONFLICT DO NOTHING;
INSERT INTO establishment.reorganisation_effect_type VALUES
 (1,'Age range changed'),(2,'Capacity increased'),(3,'Capacity reduced'),
 (4,'Sixth form added'),(5,'Sixth form removed'),(6,'Nursery added'),
 (7,'Nursery removed'),(8,'Religious character changed') ON CONFLICT DO NOTHING;
