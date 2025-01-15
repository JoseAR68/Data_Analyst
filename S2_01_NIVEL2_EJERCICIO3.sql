/* En la teva empresa, es planteja un nou projecte per a llançar algunes campanyes publicitàries 
per a fer competència a la companyia "Non Institute". Per a això, et demanen la llista de totes 
les transaccions realitzades per empreses que estan situades en el mateix país que aquesta companyia.*/

SELECT transaction.id 
FROM transaction
JOIN company ON company.id = transaction.company_id
where country = (SELECT country
FROM company
WHERE company_name = 'Non Institute')
;
