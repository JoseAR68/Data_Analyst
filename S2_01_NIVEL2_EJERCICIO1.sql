
#Identifica els cinc dies que es va generar la quantitat més gran d'ingressos a l'empresa per vendes. 
#Mostra la data de cada transacció juntament amb el total de les vendes.

-- Al solicitar los ingresos se comprueba que las transacciones no hayan sido rechazadas. 

SELECT date_format(timestamp, '%Y-%m-%d') AS fecha
, SUM(amount) AS ventas_por_fecha
FROM transaction
WHERE declined = '0'
GROUP BY fecha, declined
ORDER BY ventas_por_fecha DESC
LIMIT 5
;