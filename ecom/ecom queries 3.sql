
-- 1/ Récupérer le numéro, la date et l'email du client des commandes passées en 2021, ordonnées par date

SELECT id_order, date_order, email
FROM orders o 
    JOIN customer c USING(id_customer)
WHERE YEAR(date_order) = 2021
ORDER BY date_order;

-- 2/ Récupérer le nom, le prénom et l'email des clients n'ayant jamais passé de commande

SELECT id_customer, lastname, firstname, email
FROM customer
WHERE id_customer
NOT IN (
    SELECT id_customer
    FROM orders
);

-- OR BETTER 

SELECT id_customer, lastname, firstname, email
FROM customer c
    LEFT JOIN orders o USING(id_customer)
WHERE ISNULL(id_order);

-- 3/ Récupérer pour la commande numéro 15 pour chaque produit acheté : son nom, la quantité achetée, le prix d'achat unitaire et le prix total de la ligne

SELECT name_product, quantity, price_order, quantity * price_order AS total_price
FROM product p
    JOIN product_order po USING(ref_product)
WHERE id_order = 15;

-- 4/ Récupérer le nom et le prix des produits qui n'ont jamais été vendus

SELECT name_product, price
FROM product p
WHERE ref_product
NOT IN (
    SELECT ref_product
    FROM product_order
);

-- OR BETTER 

SELECT name_product, price
FROM product p
    LEFT JOIN product_order po USING(ref_product)
WHERE id_order IS NULL;

-- 5/ Récupérer le numéro, la date et le montant total des commandes d'avril 2022

SELECT id_order, date_order, price_order
FROM orders o
    JOIN product_order po USING(id_order)
WHERE YEAR(date_order) = 2022 AND MONTH(date_order) = 04;

-- 6/ Récupérer l'historique des commandes par ordre décroissant pour le client numéro 14
-- en affichant le montant total de chaque commande

SELECT id_order, id_customer, date_order, SUM(price_order * quantity) AS total_price
FROM orders o
    JOIN product_order USING(id_order)
WHERE id_customer = 14
GROUP BY id_order
ORDER BY date_order DESC;

-- 7/ Récupérer le nom et la quantité vendues pour chaque vin dont au moins 10 bouteilles ont été vendues

SELECT ref_product, name_product, SUM(quantity) AS total_quantity
FROM product p
    JOIN product_order po USING(ref_product)
WHERE name_product LIKE "wine%"
GROUP BY ref_product
HAVING total_quantity >= 10;

-- 8/ Récupérer le nom et le total de chiffre d'affaire de tous les produits (0.00 si le produit n'a pas été vendu)

SELECT ref_product, name_product, COALESCE(SUM(price_order * quantity), 0.00) AS total_price
FROM product p
LEFT JOIN product_order po USING(ref_product)
GROUP BY ref_product;

-- OR FOR ONLY TWO PARAMETERS
SELECT ref_product, name_product, IFNULL(SUM(price_order * quantity), 0.00) AS total_price
FROM product p
LEFT JOIN product_order po USING(ref_product)
GROUP BY ref_product;

-- 9/ Récupérer les noms des produits qui n'ont jamais été vendus
-- à un prix aussi bas qu'aujourd'hui

SELECT ref_product, name_product, MIN(price_order)
FROM product p
JOIN product_order po USING (ref_product)
GROUP BY ref_product;

-- 10/ Récupérer pour toutes les commandes passées le 27 novembre 2021,
-- le nom, le prénom, l'email du client et le montant total

SELECT date_order, lastname, firstname, email, SUM(price_order * quantity) AS total_price
FROM product_order po
JOIN orders o USING (id_order)
JOIN customer c USING (id_customer)
WHERE YEAR(date_order) = 2021 AND MONTH(date_order) = 11 AND DAY(date_order) = 27
GROUP BY id_order;

-- 11/ Récupérer l'adresse email des clients ayant effectués plus de 300 euros de commande au total en 2021

SELECT email, date_order, SUM(price_order * quantity) AS total_purchases
FROM product_order po
JOIN orders o USING (id_order)
JOIN customer c USING (id_customer)
WHERE YEAR(date_order) = 2021
GROUP BY id_order
HAVING total_purchases > 300;

-- 12/ Récupérer le nom et le prénom du plus gros acheteur de vin en quantité

SELECT lastname, firstname, SUM(quantity) AS total_wine
FROM product p
JOIN product_order po USING (ref_product)
JOIN orders o USING (id_order)
JOIN customer c USING (id_customer)
WHERE name_product LIKE 'wine%'
GROUP BY id_customer
ORDER BY total_wine DESC LIMIT 1;

-- 13/ Récupérer les emails de tous les clients et aussi leur dernière date de commande
-- s'ils ont déjà passé commande

SELECT id_customer, email, MAX(date_order) AS last_order
FROM customer c
JOIN orders o USING (id_customer)
GROUP BY id_customer
ORDER BY last_order DESC;

-- 14/ Récupérer l'historique des chiffres d'affaire mensuels des ventes de fromage

SELECT YEAR(date_order) AS year_, MONTH(date_order) AS month_, SUM(price_order * quantity) AS total_revenue
FROM product p
JOIN product_order po USING (ref_product)
JOIN orders o USING (id_order)
WHERE name_product LIKE "cheese%"
GROUP BY year_, month_
ORDER BY year_, month_;

-- 15/ Récupérer le nom et le chiffre d'affaire total de décembre 2021
-- des produits ayant généré plus 100 € de chiffre d'affaire sur ce mois.

SELECT name_product, SUM(price_order * quantity) AS total_revenue
FROM product p
JOIN product_order po USING(ref_product)
JOIN orders o USING (id_order)
WHERE YEAR(date_order) = 2021 AND MONTH(date_order) = 12
GROUP BY ref_product
HAVING total_revenue > 100;

-- 16/ Récupérer pour chaque mois la valeur du panier moyen
-- (moyenne du total des commandes de la période)

SELECT YEAR(date_order) AS year_, MONTH(date_order) AS month_, AVG(price_order * quantity) AS average_cart
FROM product_order po
JOIN orders USING (id_order)
GROUP BY year_, month_
ORDER BY year_, month_;

-- BONUS.17/ Récupérer les emails des clients qui ont achetés en 2021 le produit "Cheese - Brie, Triple Creme" à moins de 80% de son prix actuel

SELECT email, date_order, name_product, price, price_order
FROM customer c
JOIN orders o USING (id_customer)
JOIN product_order po USING (id_order)
JOIN product p USING (ref_product)
WHERE name_product = "Cheese - Brie, Triple Creme" AND price_order < (price * 0.8);

-- BONUS.18/ Quel produit Shawna Knowller a acheté le plus souvent ?

SELECT firstname, lastname, name_product, SUM(quantity) AS max_qty
FROM customer c
JOIN orders o USING (id_customer)
JOIN product_order po USING (id_order)
JOIN product p USING (ref_product)
WHERE firstname = 'Shawna' AND lastname = 'Knowller'
GROUP BY ref_product
ORDER BY max_qty DESC LIMIT 1;

-- BONUS.19/ Récupérer la liste les clients (nom et prénom) ayant acheté plusieurs fois le même produit, ainsi que le nom des produits concernés.

