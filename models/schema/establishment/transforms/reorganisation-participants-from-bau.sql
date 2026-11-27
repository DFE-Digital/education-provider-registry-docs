-- Public lifecycle facts used to validate event-specific outcomes.
SELECT CONVERT(integer,URN) AS urn,
       CONVERT(varchar(20),status_code) AS status_code,
       CONVERT(date,OpenDate) AS open_date,CONVERT(date,CloseDate) AS close_date
FROM dbo.Establishment WHERE URN IN ($(URNS));
