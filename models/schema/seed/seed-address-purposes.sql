INSERT INTO establishment.address_purpose(address_purpose_id,code,name) VALUES
    (1,'registered','Registered office'),(2,'contact','Contact'),(3,'administrative','Administrative')
ON CONFLICT(address_purpose_id) DO NOTHING;
