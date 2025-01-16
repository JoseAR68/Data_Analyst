-- NIVEL 1
-- EJERCICIO 2

-- Llistat dels països que estan fent compres.
SELECT DISTINCT
 company.country 
FROM company
JOIN transaction ON transaction.company_id = company.id
ORDER BY company.country
;

-- Des de quants països es realitzen les compres.
SELECT COUNT(DISTINCT company.country) AS num_paises 
FROM company
JOIN transaction ON transaction.company_id = company.id
ORDER BY company.country
;

-- Identifica la companyia amb la mitjana més gran de vendes.
-- USANDO JOIN. Este resultado no es preciso si hay varias compañias con la misma media de ventas
SELECT company.id
, company.company_name
, AVG(transaction.amount) AS media 
FROM company
JOIN transaction ON transaction.company_id = company.id
GROUP BY company.id
ORDER BY media DESC
LIMIT 1
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
;

-- NIVEL 1
-- EJERCICIO 3


    # Mostra totes les transaccions realitzades per empreses d'Alemanya.
    SELECT * 
    FROM transaction
    WHERE company_id IN (SELECT id 
						 FROM company
						 WHERE country ='Germany')
	;
    
    # Llista les empreses que han realitzat transaccions per un amount superior a la mitjana de totes les transaccions.
    # lista de empresas cuya media de  transacciones es superior a la media de todas las transacciones.
    
    SELECT company_name
    FROM company
    WHERE company.id IN (SELECT company_id
						 FROM transaction
						 WHERE amount > (SELECT AVG(amount) AS media_total 
										 FROM transaction AS trans_2))
	;
    
    # Eliminaran del sistema les empreses que no tenen transaccions registrades, entrega el llistat d'aquestes empreses.
    
    SELECT company_name 
    FROM company
    WHERE company.id NOT IN ( SELECT company_id 
							  FROM transaction)
    ;
   
   -- NIVEL 2
   -- EJERCICIO 1
   
# Identifica els cinc dies que es va generar la quantitat més gran d'ingressos a l'empresa per vendes. 
# Mostra la data de cada transacció juntament amb el total de les vendes.

-- Al solicitar los ingresos se comprueba que las transacciones no hayan sido rechazadas. 

SELECT date_format(timestamp, '%Y-%m-%d') AS fecha
, SUM(amount) AS ventas_por_fecha
FROM transaction
WHERE declined = '0'
GROUP BY fecha, declined
ORDER BY ventas_por_fecha DESC
LIMIT 5
;

-- NIVEL 2
-- EJERCICIO 2

-- Quina és la mitjana de vendes per país? Presenta els resultats ordenats de major a menor mitjà.

SELECT company.country
, AVG(transaction.amount) AS media_ventas
FROM company
JOIN transaction ON transaction.company_id = company.id
GROUP BY company.country
ORDER BY media_ventas DESC
;

-- NIVEL 2
-- EJERCICIO 3

/* En la teva empresa, es planteja un nou projecte per a llançar algunes campanyes publicitàries 
per a fer competència a la companyia "Non Institute". Per a això, et demanen la llista de totes 
les transaccions realitzades per empreses que estan situades en el mateix país que aquesta companyia.*/

-- Aplicando JOIN y subconsulta
SELECT *
FROM transaction
JOIN company ON company.id = transaction.company_id
WHERE country = (SELECT country
				 FROM company
				 WHERE company_name = 'Non Institute')
;

-- Aplicando solo subconsultas
SELECT *
FROM transaction
WHERE transaction.company_id IN (SELECT company.id
								 FROM company
								 WHERE company.country = (SELECT country
														  FROM company
														  WHERE company_name = 'Non Institute'))
;

-- NIVEL 3
-- EJERCICIO 1

/* Presenta el nom, telèfon, país, data i amount, d'aquelles empreses que van realitzar transaccions amb un valor 
comprès entre 100 i 200 euros i en alguna d'aquestes dates: 29 d'abril del 2021, 20 de juliol del 2021 i 13 de març del 2022. 
Ordena els resultats de major a menor quantitat. */

-- Se muestran los campos amount y timestamp a efectos de comprobación.
-- Se toman todas las transacciones sin valorar si han sido rechazadas o no.

SELECT company_name
, phone, country
, amount
, timestamp
FROM company
JOIN transaction ON company.id = transaction.company_id
WHERE amount BETWEEN 100 AND 200 
AND date_format(timestamp, '%Y-%m-%d') IN ('2021-04-29','2021-07-20','2022-03-13')
ORDER BY amount DESC
;

-- NIVEL 3
-- EJERCICIO 2

/* Necessitem optimitzar l'assignació dels recursos i dependrà de la capacitat operativa que es requereixi, 
per la qual cosa et demanen la informació sobre la quantitat de transaccions que realitzen les empreses, 
però el departament de recursos humans és exigent i vol un llistat de les empreses on especifiquis si tenen més de 4 transaccions o menys. */

-- Se ha dividido la categoria en 2 grupos: 4 o mas transacciones o menos de 4.
-- Se muestra el número de transacciones a efectos de comprobación de las categorias.
-- Se toman todas las transacciones sin valorar si han sido rechazadas o no.

SELECT company_id
, company_name
, COUNT(transaction.id) AS num_transacciones
, CASE
WHEN COUNT(transaction.id)>=4 THEN 'mayor o igual a 4' 
ELSE 'menos de 4'
END AS 'categoria_transacciones'
FROM transaction
JOIN company ON company.id = transaction.company_id
GROUP BY company_id
ORDER BY num_transacciones DESC
;


