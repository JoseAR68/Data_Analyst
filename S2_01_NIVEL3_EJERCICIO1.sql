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