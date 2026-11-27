-- Discover from either endpoint, including the reciprocal BAU assertion.
-- URNs are validated integers supplied by the migration entry point.
SELECT CONVERT(integer,l.id) AS source_link_id,
       CONVERT(integer,l.URN) AS urn, CONVERT(integer,l.linkURN) AS linked_urn,
       CONVERT(varchar(20),l.type_code) AS link_type,
       CONVERT(date,l.establishedDate) AS link_date
FROM dbo.EstablishmentLink l
JOIN dbo.LinkType t ON t.code=l.type_code
WHERE ISNULL(t.archived,0)=0 AND (l.URN IN ($(URNS)) OR l.linkURN IN ($(URNS)));
