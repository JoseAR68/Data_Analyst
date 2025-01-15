
    # Mostra totes les transaccions realitzades per empreses d'Alemanya.
    SELECT * FROM transaction
    WHERE company_id IN (SELECT id FROM company
						 WHERE country ="Germany")
	;
    
    # Llista les empreses que han realitzat transaccions per un amount superior a la mitjana de totes les transaccions.
    # lista de empresas cuya media de  transacciones es superior a la media de todas las transacciones.
    
    SELECT company_id, AVG(amount) AS media FROM transaction
    GROUP BY company_id
    HAVING media > (
    SELECT AVG(amount) AS media_total FROM transaction AS trans_2)
    ORDER BY media
	;
    
    # Eliminaran del sistema les empreses que no tenen transaccions registrades, entrega el llistat d'aquestes empreses.
    
    SELECT company.id FROM company
    WHERE company.id NOT IN ( SELECT company_id FROM transaction)
    ;
   
    
    
    
    
    
