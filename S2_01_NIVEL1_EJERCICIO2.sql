-- Llistat dels països que estan fent compres.
SELECT DISTINCT country FROM company
JOIN transaction ON transaction.company_id = company.id
ORDER BY country
;

-- Des de quants països es realitzen les compres.
SELECT COUNT(DISTINCT country) AS num_paises FROM company
JOIN transaction ON transaction.company_id = company.id
ORDER BY country
;

-- Identifica la companyia amb la mitjana més gran de vendes.
-- USANDO JOIN. Este resultado no es preciso si hay varias compañias con la misma media de ventas
SELECT company.id, company_name, AVG(amount) AS media FROM company
JOIN transaction ON transaction.company_id = company.id
GROUP BY company.id
ORDER BY media DESC
LIMIT 1
;

-- Identifica la companyia amb la mitjana més gran de vendes.
-- USANDO CTE´S Y FUNCION MAX.
-- METODO MAS DINAMICO

WITH media AS
(
SELECT company_id, AVG(amount) as media_ventas FROM transaction
GROUP BY company_id
)
,
max_media AS
(
SELECT MAX(media_ventas) AS max_avg from media
)
SELECT company.id, company_name, media_ventas
FROM company
JOIN media ON  company.id = media.company_id
JOIN max_media ON max_media.max_avg = media.media_ventas
;

-- Identifica la companyia amb la mitjana més gran de vendes.
-- USANDO CTE´S Y FUNCION DENSE_RANK.
-- EL SISTEMA MAS DINAMICO AL PERMITIR ESCOGER DISTINTOS RANGOS DE VALORES

WITH media AS
(
SELECT company_id, AVG(amount) as media_ventas FROM transaction
GROUP BY company_id
)
,
rango_media AS 
(
SELECT company_id, media_ventas,
DENSE_RANK () OVER (ORDER BY media_ventas DESC ) AS rango FROM media
)
SELECT company.id, company.company_name
FROM company
JOIN rango_media ON company.id = rango_media.company_id
WHERE rango = 1













