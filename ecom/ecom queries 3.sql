
-- 1/ Récupérer le numéro, la date et l'email du client des commandes passées en 2021, ordonnées par date

SELECT c.id_customer, date_order, email
FROM orders o 
    JOIN customer c USING(id_customer)
WHERE date_order LIKE "%2021%"
ORDER BY date_order;



-- 2/ Récupérer le nom, le prénom et l'email des clients n'ayant jamais passé de commande

-- SELECT lastname, firstname, email
-- FROM customer c
--     JOIN orders o USING(id_customer)
-- WHERE o.id_customer = NULL;

SELECT c.id_customer
FROM customer c
WHERE c.id_customer
NOT IN (
    SELECT id_customer
    FROM orders
);

-- 3/ Récupérer pour la commande numéro 15 pour chaque produit acheté : son nom, la quantité achetée, le prix d'achat unitaire et le prix total de la ligne

SELECT id_order, name_product, quantity, price, SUM(quantity * price) AS total_price
FROM orders o
    JOIN product_order po USING(id_order)
    JOIN product p USING (ref_product)
WHERE o.id_order = po.id_order AND id_order = 15
GROUP BY po.ref_product;

-- 4/ Récupérer le nom et le prix des produits qui n'ont jamais été vendus

SELECT name_product, price
FROM product p
WHERE p.ref_product
NOT IN (
    SELECT ref_product
    FROM product_order
);

-- 5/ Récupérer le numéro, la date et le montant total des commandes d'avril 2022



-- 6/ Récupérer l'historique des commandes par ordre décroissant pour le client numéro 14
-- en affichant le montant total de chaque commande



-- 7/ Récupérer le nom et la quantité vendues pour chaque vin dont au moins 10 bouteilles ont été vendues



-- 8/ Récupérer le nom et le total de chiffre d'affaire de tous les produits (0.00 si le produit n'a pas été vendu)



-- 9/ Récupérer les noms des produits qui n'ont jamais été vendus
-- à un prix aussi bas qu'aujourd'hui



-- 10/ Récupérer pour toutes les commandes passées le 27 novembre 2021,
-- le nom, le prénom, l'email du client et le montant total



-- 11/ Récupérer l'adresse email des clients ayant effectués plus de 300 euros de commande au total en 2021



-- 12/ Récupérer le nom et le prénom du plus gros acheteur de vin en quantité



-- 13/ Récupérer les emails de tous les clients et aussi leur dernière date de commande
-- s'ils ont déjà passé commande



-- 14/ Récupérer l'historique des chiffres d'affaire mensuels des ventes de fromage



-- 15/ Récupérer le nom et le chiffre d'affaire total de décembre 2021
-- des produits ayant généré plus 100 € de chiffre d'affaire sur ce mois.



-- 16/ Récupérer pour chaque mois la valeur du panier moyen
-- (moyenne du total des commandes de la période)


