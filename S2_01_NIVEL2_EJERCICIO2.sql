-- Quina és la mitjana de vendes per país? Presenta els resultats ordenats de major a menor mitjà.

SELECT country, AVG(amount) AS media_ventas
FROM company
JOIN transaction ON transaction.company_id = company.id
GROUP BY country
ORDER BY media_ventas DESC
;
