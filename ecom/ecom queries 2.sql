
-- 1/ Récupérer le nombre de clients total dans la base de données

SELECT COUNT(id_customer) AS nb_customers
FROM customer;

-- 2/ Récupérer le nombre de clients qui ont été créés chaque jour

SELECT date_create, COUNT(date_create) AS create_by_date
FROM customer
GROUP BY date_create
ORDER BY date_create;

-- 3/ Récupérer le prix du produit le plus bas

SELECT MIN(price) AS min_price
FROM product;

SELECT price
FROM product
ORDER BY price ASC LIMIT 1;

-- 4/ Récupérer le prix du produit le plus élevé

SELECT MAX(price) AS max_price
FROM product;

SELECT price
FROM product
ORDER BY price DESC LIMIT 1;

-- 5/ Récupérer le numéro des clients ayant commandé avec la date de leur dernière commande,
-- classés par cette date de dernière commande décroissant

SELECT id_customer, MAX(date_order) AS last_order
FROM orders
GROUP BY id_customer
ORDER BY last_order DESC;

-- 6/ Récupérer la liste des jours de commande par ordre décroissant avec pour chaque jour le nombre de commandes passées

SELECT date_order, COUNT(id_order) AS order_by_date
FROM orders
GROUP BY date_order
ORDER BY date_order DESC;

-- 7/ Récupérer les identifiants des commandes et pour chacune le nombre total de produits achetés

SELECT id_order, SUM(quantity) AS quantity_order
FROM product_order
GROUP BY id_order;

-- 8/ Récupérer le nombre de comptes clients créés pour chaque année

SELECT COUNT(id_customer) AS number_clients, YEAR(date_create) AS create_by_year
FROM customer
GROUP BY create_by_year;

-- 9/ Récupérer le montant total de la commande numéro 12

SELECT SUM(price_order * quantity) AS total_price
FROM product_order
WHERE id_order = 12
GROUP BY id_order;

-- 10/ Récupérer les identifiants des commandes et pour chacune le montant total payé par le client

SELECT id_order, SUM(price_order * quantity) AS total_price
FROM product_order
GROUP BY id_order;

-- 11/ Récupérer pour chaque mois le nombre de commandes passées classé par mois croissant

SELECT COUNT(id_order) AS nb_orders, MONTH(date_order) AS month_nb, YEAR(date_order) AS year
FROM orders
GROUP BY month_nb, year
ORDER BY month_nb ASC;

-- OR 

SELECT 
DATE_FORMAT (date_order, "%Y-%m") AS ym, COUNT(id_order) AS nb_orders
FROM orders
GROUP BY ym
ORDER BY ym;

-- 12/ Récupérer les identifiants des clients ayant passées au moins 3 commandes

SELECT id_customer, COUNT(id_order) AS total_orders
FROM orders
GROUP BY id_customer
HAVING total_orders >= 3;

-- 13/ Récupérer les références des produits dont il a déjà été vendu plus de 20 exemplaires, triés par nombre d'exemplaires vendus décroissant

SELECT ref_product, SUM(quantity) AS total_quantity_sold
FROM product_order
GROUP BY ref_product
HAVING total_quantity_sold > 20
ORDER BY total_quantity_sold DESC;

-- 14/ Récupérer la référence et le chiffre d'affaire du produit qui a généré le plus de chiffre d'affaire

SELECT ref_product, SUM(quantity * price_order) AS best_product_revenue
FROM product_order
GROUP BY ref_product
ORDER BY best_product_revenue DESC
LIMIT 1;

-- BONUS.15/ Récupérer les identifiants des clients ayant passés au moins 3 commandes en 2022

SELECT id_customer, COUNT(id_order) AS total_customers_orders
FROM orders
WHERE date_order LIKE "%2022%"
GROUP BY id_customer
HAVING total_customers_orders >= 3;

-- BONUS.16/ Récupérer les identifiants des produits dont le prix a varié de plus 8 € dans l'historique des ventes 

SELECT ref_product, MAX(price_order) AS max_price, MIN(price_order) AS min_price
FROM product_order
GROUP BY ref_product
HAVING max_price - min_price > 8;

-- BONUS.17/ Récupérer l'identifiant des produits dont le prix de vente moyen est supérieur à 20€ et dont au moins 15 exemplaires ont déjà vendus 

SELECT ref_product, AVG(price_order) AS average_price, SUM(quantity) AS total_quantity_sold
FROM product_order
GROUP BY ref_product
HAVING total_quantity_sold >= 15 AND average_price > 20;


-- First version but not complete
-- SELECT ref_product, SUM(quantity) AS total_quantity_sold
-- FROM product_order
-- WHERE price_order > 20
-- GROUP BY ref_product
-- HAVING total_quantity_sold >= 15;