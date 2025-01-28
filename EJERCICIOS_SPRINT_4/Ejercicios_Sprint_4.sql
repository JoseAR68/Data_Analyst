
-- Nivel_1
-- Creacion de base de datos
CREATE DATABASE SPRINT_4
;
USE SPRINT_4
;
-- Creacion de la tabla users. 
CREATE TABLE users (
id INT PRIMARY KEY,
name VARCHAR(255),
surname VARCHAR(255),
phone VARCHAR(255),
email VARCHAR(255),
birth_date VARCHAR(255),
country VARCHAR(255),
city VARCHAR(255),
postal_code VARCHAR(255),
address VARCHAR(255)
)
;

-- Comprobacion de la tabla users. 
show columns
from users
;

-- Creacion de la tabla companies.
CREATE TABLE companies (
company_id VARCHAR(255) PRIMARY KEY
, company_name VARCHAR(255)
, phone VARCHAR(255)
, email VARCHAR(255)
, country VARCHAR(255)
, website VARCHAR(255)
)
;

-- Comprobacion de la tabla companies. 
SHOW COLUMNS
FROM companies
;

-- Creacion de la tabla credit_cards. 
CREATE TABLE credit_cards (
id VARCHAR(255) PRIMARY KEY
, user_id INT
, iban VARCHAR(255)
, pan VARCHAR(255)
, pin INT
, cvv int 
, track1 VARCHAR(255)
, track2 VARCHAR(255)
, expiring_date VARCHAR(255)
)
;

-- Comprobacion de la tabla credit_cards.
SHOW COLUMNS
FROM credit_cards
;

-- Creacion de la tabla transactions. 
CREATE TABLE transactions (
id VARCHAR(255) PRIMARY KEY
, card_id VARCHAR(255)
, business_id VARCHAR(255)
, timestamp timestamp
, amount DECIMAL(10,2)
, declined tinyint(1) 
, product_ids VARCHAR(255)
, user_id INT
, lat FLOAT
, longitude FLOAT
, FOREIGN KEY (card_id) REFERENCES credit_cards(id)
, FOREIGN KEY (business_id) REFERENCES companies(company_id)
, FOREIGN KEY (user_id) REFERENCES users(id)
)
;

-- Comprobacion de la tabla transactions. 
SHOW COLUMNS
FROM transactions
;

-- Introduccion de datos desde users_ca.csv a la tabla users. 
LOAD DATA LOCAL INFILE "C:/Desktop/users_ca.csv"
INTO TABLE users
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
;

-- Introduccion de datos desde users_uk.csv a la tabla users. 
LOAD DATA LOCAL INFILE "C:/Desktop/users_uk.csv"
INTO TABLE users
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
;

-- Introduccion de datos desde users_usa.csv a la tabla users. 
LOAD DATA LOCAL INFILE "C:/Users/Descargas/users_usa.csv"
INTO TABLE users
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
;

-- Introduccion de datos desde companies.csv a la tabla companies. 
LOAD DATA LOCAL INFILE "C:/Descargas/companies.csv"
INTO TABLE companies
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
;

-- Introduccion de datos desde credit_cards.csv a la tabla credit_cards. 
LOAD DATA LOCAL INFILE "C:/Descargas/credit_cards.csv"
INTO TABLE credit_cards
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
;

-- Introduccion de datos desde transactions.csv a la tabla transactions. 
-- Se realiza la introduccion de datos desde el tabla data import wizard de mysql workbench. 
-- sprint_4 / transactions / table data import wizard / desde transactions.csv a la tabla transactions. 
;

-- Nivel 1
-- Ejercicio 1
/*
Haz un subconsulta que muestre a todos los usuarios con más de 30 transacciones usando al menos 2 tablas.
*/
SELECT transactions.user_id
, users.name
, users.surname
, COUNT(transactions.id) AS num_transactions
FROM transactions
JOIN users ON transactions.user_id = users.id
GROUP BY user_id
HAVING num_transactions > 30
ORDER BY num_transactions DESC
;

-- Nivel 1
-- Ejercicio 2
/*
Mostrar el promedio de amount de la tarjeta de crédito por IBAN en la empresa Donec Ltd, utilizar al menos 2 tablas.
*/
SELECT companies.company_name as company
, credit_cards.iban AS iban
, AVG(transactions.amount) AS average_transaction 
FROM transactions
JOIN credit_cards ON transactions.card_id = credit_cards.id
JOIN companies ON transactions.business_id = companies.company_id
WHERE companies.company_name = 'Donec Ltd'
GROUP BY iban, company
;

-- Nivel 2
-- Ejercicio 1
/*
Crear una nueva tabla que refleje el estado de las tarjetas de crédito en función de si las tres últimas transacciones fueron rechazadas 
y generar la siguiente consulta:
Ejercicio 1
¿Cuántas tarjetas están activas?
*/
-- Creacion de la tabla credit_card_status. 
CREATE TABLE credit_cards_status
( 
card_id VARCHAR(255) PRIMARY KEY
, status VARCHAR(255)
)
;

-- Comprobacion de la tabla credit_cards_status. 
SHOW COLUMNS
from credit_cards_status
;

-- Introduccion de datos en la tabla credit_cards_status. 
INSERT INTO credit_cards_status
WITH rank_num_transactions AS
(
SELECT card_id
, timestamp
, declined
, DENSE_RANK() OVER ( PARTITION BY card_id
					  ORDER BY timestamp DESC
				    ) AS num_trans
FROM transactions
) 

SELECT card_id
, CASE
	 WHEN SUM(declined) < 3 
	 THEN 'active' 
     ELSE 'non-active'
	 END AS status
FROM rank_num_transactions
WHERE num_trans <= 3
GROUP BY card_id
;

-- Establecer la relacion entre credit_cards y credit_cards_status
ALTER TABLE credit_cards
ADD FOREIGN KEY credit_cards(id) REFERENCES credit_cards_status(card_id)
;

-- Nivel 2
-- Ejercicio 1
/*
Ejercicio 1
¿Cuántas tarjetas están activas?
*/
SELECT COUNT(card_id) AS num_cards_active
FROM credit_cards_status
WHERE status = 'active'
;

-- Nivel 3
-- Ejercicio 1
/*
Nivel 3
Crea una tabls con la cual se puedan unir los datos del nuevo archivo productos.csv con la base de datos 
creada, teniendo en cuenta que desde la tabla transactions tienes product_ids. Genera la siguiente consulta:
Exercici 1
Necesitamos conocer el numero de veces que se ha vendido cada producto.
*/

-- Creacion de la tabla productos. 
CREATE TABLE products (
id INT PRIMARY KEY
, product_name VARCHAR(255)
, price VARCHAR(255)
, colour VARCHAR(255)
, weight DECIMAL(4,2)
, warehouse_id VARCHAR(255)
)
;
-- Comprobacion de la tabla productos.
SHOW COLUMNS
FROM products
;

-- Introduccion de datos desde products.csv en la tabla products. 
LOAD DATA LOCAL INFILE "C:/Descargas/products.csv"
INTO TABLE products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
;

-- Creacion de la tabla puente transactions_products. 
CREATE TABLE transactions_products
(
id INT AUTO_INCREMENT PRIMARY KEY
, transaction_id VARCHAR(255)
, product_id INT
, FOREIGN KEY (transaction_id) REFERENCES transactions(id)
, FOREIGN KEY (product_id) REFERENCES products(id)
)
;

-- Insertar datos en la tabla puente transactions_products. 
INSERT INTO transactions_products
(
transaction_id
, product_id
)
SELECT transactions.id
, products.id
FROM transactions
JOIN products 
ON FIND_IN_SET(products.id, REPLACE(transactions.product_ids, ' ', ''))
;

-- Esquema final de la base de datos. 



















