-- Expand a selected URN list to its complete connected set of active BAU
-- establishment links. Traverse either direction; reciprocal rows, cycles and
-- shared neighbours are deduplicated. No classification is inferred here.
SET NOCOUNT ON;
DECLARE @selected TABLE (urn integer PRIMARY KEY);
INSERT INTO @selected
SELECT DISTINCT CONVERT(integer,value) FROM STRING_SPLIT('$(URNS)',',') WHERE value<>'';

SELECT DISTINCT CONVERT(integer,l.URN) AS urn,CONVERT(integer,l.linkURN) AS linked_urn
INTO #selection_links
FROM dbo.EstablishmentLink l
JOIN dbo.LinkType t ON t.code=l.type_code
WHERE ISNULL(t.archived,0)=0 AND l.URN IS NOT NULL AND l.linkURN IS NOT NULL;
CREATE INDEX source_urn_idx ON #selection_links(urn);
CREATE INDEX linked_urn_idx ON #selection_links(linked_urn);

WHILE 1=1
BEGIN
    INSERT INTO @selected(urn)
    SELECT neighbours.urn
    FROM (
        SELECT l.linked_urn AS urn FROM #selection_links l JOIN @selected s ON s.urn=l.urn
        UNION
        SELECT l.urn FROM #selection_links l JOIN @selected s ON s.urn=l.linked_urn
    ) neighbours
    WHERE NOT EXISTS(SELECT 1 FROM @selected s WHERE s.urn=neighbours.urn);
    IF @@ROWCOUNT=0 BREAK;
END;
SELECT urn FROM @selected ORDER BY urn;
DROP TABLE #selection_links;
