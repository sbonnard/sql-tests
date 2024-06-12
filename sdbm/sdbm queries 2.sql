-- 1/ Quels sont les tickets qui comportent l'article d'ID 500 ?
-- Afficher le numéro de ticket uniquement.

SELECT id_ticket
FROM sale
WHERE id_article = 500;

-- 2/ Quels sont les tickets du 15/01/2017 ?
-- Afficher le numéro de ticket et la date.

SELECT id_ticket, ticket_date
FROM ticket
WHERE ticket_date = '2017-01-15';

-- 3/ Quels sont les tickets émis du 15/01/2017 au 17/01/2017 ?
-- Afficher le numéro de ticket et la date.

SELECT id_ticket, DATE_FORMAT(ticket_date, "%Y-%m-%d") AS date_
FROM ticket
GROUP BY id_ticket
HAVING ticket_date 
BETWEEN date_ = '2017-01-15' AND '2017-01-17';

-- 4/ Quels sont les articles (Code et nom uniquement) apparaissant sur un ticket à au moins 95 exemplaires.

SELECT id_article, article_name, SUM(quantity)
FROM article    
    JOIN sale USING (id_article)
    JOIN ticket USING (id_ticket)
GROUP BY id_article, id_ticket
HAVING SUM(quantity) >= 95;

-- 5/ Quels sont les tickets émis au mois de mars 2017 ?
-- Afficher le numéro de ticket et la date.

SELECT id_ticket, DATE_FORMAT(ticket_date, "%Y-%m") AS date_ticket
FROM ticket
    JOIN sale USING (id_ticket)
GROUP BY id_ticket
HAVING date_ticket = '2017-03';

-- 6/ Quels sont les tickets émis au deuxième trimestre 2017 ?
-- Afficher le numéro de ticket et la date.

SELECT id_ticket, ticket_date
FROM ticket
    JOIN sale USING (id_ticket)
GROUP BY id_ticket
HAVING ticket_date BETWEEN '2017-04-01' AND '2017-06-30'
ORDER BY ticket_date DESC;

-- OR BETTER

SELECT id_ticket, ticket_date
FROM ticket
    JOIN sale USING (id_ticket)
GROUP BY id_ticket
HAVING QUARTER(ticket_date) = 2 AND YEAR(ticket_date) = '2017'
ORDER BY ticket_date DESC;

-- 7/ Quels sont les tickets émis au mois de mars et juillet 2017 ?
-- Afficher le numéro de ticket et la date.

SELECT id_ticket, DATE_FORMAT(ticket_date, '%Y-%m') AS date_
FROM ticket
    JOIN sale USING (id_ticket)
GROUP BY id_ticket
HAVING date_ = '2017-03' OR date_ = '2017-07';

-- 8/ Afficher la liste de toutes les bières classée par couleur.
-- Afficher code et nom de bière, nom de la couleur

SELECT id_article, article_name, color_name
FROM article
    JOIN color USING (id_color)
GROUP BY id_article;

-- 9/ Afficher la liste des bières n'ayant pas de couleur. 
-- Afficher le code et le nom

SELECT id_article, article_name, color_name
FROM article
    LEFT JOIN color USING (id_color)
GROUP BY id_article
HAVING color_name IS NULL;

-- 10/ Lister pour chaque ticket la quantité totale d'articles vendus (en nombre).
-- Classer par quantité décroissante

SELECT id_ticket, SUM(quantity) AS total_qty_ticket
FROM sale
    JOIN ticket USING (id_ticket)
GROUP BY id_ticket
ORDER BY total_qty_ticket DESC;

-- 11/ Lister chaque ticket pour lequel la quantité totale d'articles vendus est inférieure à 50.
-- Classer par quantité croissante

SELECT id_ticket, SUM(quantity) AS total_qty_ticket
FROM sale
    JOIN ticket USING (id_ticket)
GROUP BY id_ticket
HAVING SUM(quantity) < 50
ORDER BY total_qty_ticket ASC;

-- 12/ Lister chaque ticket pour lequel la quantité totale d'articles vendus est supérieure à 500.
-- Classer par quantité décroissante

SELECT id_ticket, SUM(quantity) AS total_qty_ticket
FROM sale
    JOIN ticket USING (id_ticket)
GROUP BY id_ticket
HAVING SUM(quantity) > 500
ORDER BY total_qty_ticket DESC;

-- 13/ Lister chaque ticket pour lequel la quantité totale d'articles vendus est supérieure à 500. On exclura du total, les ventes de 50 articles et plus.
-- classer par quantité décroissante

SELECT id_ticket, SUM(quantity) AS total_qty_ticket
FROM sale
    JOIN ticket USING (id_ticket)
GROUP BY id_ticket
HAVING total_qty_ticket > 500 AND COUNT(id_article) < 50
ORDER BY total_qty_ticket DESC;

-- 14/ Lister les bières de type ‘Trappiste'.
-- Afficher id, nom de la bière, volume et titrage

SELECT id_article, article_name, volume, alcohol
FROM article
    JOIN type USING (id_type)
WHERE type_name = 'Trappiste'
GROUP BY id_article;

-- 15/ Lister les marques du continent ‘Afrique'.
-- Afficher id et nom de marque, nom du continent

SELECT id_brand, brand_name, continent_name
FROM brand
    JOIN country USING (id_country)
    JOIN continent USING (id_continent)
WHERE continent_name = 'Afrique';

-- 16/ Lister les bières du continent ‘Afrique'.
-- Afficher ID, Nom et volume

SELECT id_article, article_name, volume, continent_name
FROM article
    JOIN brand USING (id_brand)
    JOIN country USING (id_country)
    JOIN continent USING (id_continent)
WHERE continent_name = 'Afrique';

-- 17/ Lister les tickets classés par montant décroissant.
-- Afficher l'année, numéro de ticket, montant total à payer
--     En sachant que l'on applique un taux de TVA de 20% au montant total hors taxe de chaque ticket.

SELECT id_ticket, YEAR(ticket_date) AS year_, SUM(quantity * purchase_price) AS total_price_HT, SUM(quantity * purchase_price) * 1.2 AS total_price_TTC
FROM ticket
    JOIN sale USING (id_ticket)
    JOIN article USING (id_article)
GROUP BY id_ticket
ORDER BY total_price_TTC DESC;

-- 18/ Donner le C.A. par année.
-- Afficher les années et Total HT

SELECT YEAR(ticket_date) AS year_, SUM(quantity * purchase_price) AS total_price_HT
FROM ticket
    JOIN sale USING (id_ticket)
    JOIN article USING (id_article)
GROUP BY year_;

-- 19/ Lister les quantités vendues de chaque article pour l'année 2017.
-- Afficher id et nom de l'article, quantité vendue

SELECT YEAR(ticket_date) AS year_, id_article, article_name, SUM(quantity)
FROM article
    JOIN sale USING (id_article)
    JOIN ticket USING (id_ticket)
GROUP BY id_article, year_
HAVING year_ = '2017'
ORDER BY id_article ASC;