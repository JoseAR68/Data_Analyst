/* Necessitem optimitzar l'assignació dels recursos i dependrà de la capacitat operativa que es requereixi, 
per la qual cosa et demanen la informació sobre la quantitat de transaccions que realitzen les empreses, 
però el departament de recursos humans és exigent i vol un llistat de les empreses on especifiquis si tenen més de 4 transaccions o menys. */

-- Se ha dividido la categoria en 2 grupos: 4 o mas transacciones o menos de 4.
-- Se muestra el número de transacciones a efectos de comprobación de las categorias.
-- Se toman todas las transacciones sin valorar si han sido rechazadas o no.

SELECT company_id
, company_name
, COUNT(transaction.id) AS num_transacciones,
CASE
WHEN COUNT(transaction.id)>=4 THEN 'mayor o igual a 4' 
else 'menos de 4'
END AS 'categoria_transacciones'
FROM transaction
JOIN company ON company.id = transaction.company_id
GROUP BY company_id
ORDER BY COUNT(transaction.id) DESC
;