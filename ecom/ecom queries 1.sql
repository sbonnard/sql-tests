--
-- COMMENCER PAR IMPORTER LA BASE "ecom" AFIN D'OBTENIR LES TABLES ET LES DONNEES
--


-- 1/ Récupérer toutes les données des clients dont le prénom est Ramsay

SELECT * 
FROM customer 
WHERE firstname = "Ramsay";

-- 2/ Récupérer les noms et prénoms des clients par ordre alphabétique

-- Only lastnames :
SELECT lastname 
FROM customer 
ORDER BY lastname ASC;

-- Only firstnames :
SELECT firstname 
FROM customer 
ORDER BY firstname ASC;

-- Both :
SELECT lastname, firstname 
FROM customer 
ORDER BY lastname, firstname ASC;

-- 3/ Récupérer les noms, prénoms et email du client numéro 15

SELECT lastname, firstname, email 
FROM customer 
WHERE id_customer = 15;

-- 4/ Récupérer les adresses email des clients numéro 20, 34, 50, 69 et 88.

SELECT email 
FROM customer 
WHERE id_customer IN (20, 34, 50, 69, 88);

-- 5/ Récupérer les noms et prénoms des clients dont l'ajout a été effectué avant 2022

SELECT lastname, firstname 
FROM customer 
WHERE date_create < "2022-01-01";

-- OR

SELECT lastname, firstname 
FROM customer 
WHERE YEAR(date_create) < 2022;

-- 6/ Récupérer toutes les données des clients dont l'ajout a été effectué en juin 2022

SELECT * 
FROM customer 
WHERE date_create 
BETWEEN '2022-06-01' AND '2022-06-30';

-- OR 

SELECT * 
FROM customer 
WHERE YEAR(date_create) = 2022 AND MONTH(date_create) = 06;

-- OR

SELECT *
FROM customer
WHERE EXTRACT(YEAR_MONTH FROM date_create) = 202206;

-- OR BETTER

SELECT * 
FROM customer 
WHERE date_create LIKE '%2022-06%';

-- 7/ Récupérer le nom et le prix des produits du plus cher au moins cher

SELECT name_product, price 
FROM product 
ORDER BY price DESC;

-- 8/ Récupérer le nom et le prix des 5 produits les moins cher

SELECT name_product, price 
FROM product 
ORDER BY price ASC 
LIMIT 5;

-- 9/ Récupérer le nom des produits qui contiennent le mot "bread"

SELECT name_product 
FROM product 
WHERE name_product LIKE "%bread%";

-- 10/ Récupérer le nom des produits qui commencent par le mot "wine"

SELECT name_product 
FROM product 
WHERE name_product LIKE 'Wine%';

-- 11/ Récupérer le nom et le prix du vin le moins cher

SELECT name_product, price
FROM product
WHERE name_product LIKE 'Wine%'
ORDER BY price ASC LIMIT 1;

-- 12/ Récupérer le nom et le prix des produits dont le prix est compris entre 15 et 20, classés par ordre alphabétique

SELECT name_product, price 
FROM product
WHERE price 
BETWEEN 15 AND 20
ORDER BY name_product ASC;

-- 13/ Récupérer le nom et le prix des vins dont le prix est compris entre 8 et 10

SELECT name_product, price
FROM product
WHERE name_product LIKE 'Wine%'
AND price BETWEEN 8 AND 10;

-- 14/ Récupérer le numéro et la date des commandes passées au mois de mai 2022

SELECT id_order, date_order
FROM orders
WHERE date_order
LIKE '%2022-05%';

-- OTHER SOLUTIONS IN QUESTION 6

-- 15/ Récupérer le numéro et la date des commandes passées par le client numéro 59 en 2022, classées par date croissante. 

SELECT id_order, date_order, id_customer
FROM orders 
WHERE id_customer = 59
AND date_order
LIKE '%2022%'
ORDER BY date_order ASC;

-- 16/ Récupérer le prénom et le nom des clients dont le fournisseur de l'adresse email est "google.com"

SELECT firstname, lastname, email
FROM customer
WHERE email
LIKE '%google.com';

-- 17/ Récupérer le numéro et la date de la dernière commande du client numéro 42

SELECT id_order, date_order, id_customer
FROM orders
WHERE id_customer = 42
ORDER BY date_order DESC
LIMIT 1;

-- 18/ Modifier l'adresse email du client numéro 15 par emilymcgrail@yahoo.com"

UPDATE customer
SET email = "emilymcgrail@yahoo.com"
WHERE id_customer = 15;

-- 19/ Créer la requête permettant de mette à jour le prix du produit ayant la référence 42 à 10.20 €

UPDATE product
SET price = 10.20
WHERE ref_product = 42;

-- 20/ Créer la requête permettant d'augmenter de 10% le prix de tous les fromages.

UPDATE product
SET price = 1.10 * price
WHERE name_product
LIKE "cheese%";


--Round the result
UPDATE product
SET price = ROUND(1.10 * price, 2)
WHERE name_product
LIKE "cheese%";
