-- BAU import inventory: open, closed, and open but proposed to close.
SELECT URN AS urn
FROM dbo.Establishment
WHERE status_code IN ('1','2','3')
ORDER BY URN;
