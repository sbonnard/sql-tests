-- 1/ Afficher la liste des articles avec leur nom, prix d'achat et quantité totale vendue (en nombre de bière).

SELECT article_name, purchase_price, SUM(quantity) AS qty_sold
FROM article
    JOIN sale USING (id_article)
GROUP BY id_article;

-- 2/ Afficher le nombre de bières vendues par pays, en affichant le nom du pays.

SELECT country_name, SUM(quantity) AS qty_sold
FROM sale
    JOIN article USING (id_article)
    JOIN brand USING (id_brand)
    JOIN country USING (id_country)
GROUP BY id_country;

-- 3/ Afficher la quantité totale de bières vendues par marque, avec le nom de chaque marque, triée par ordre décroissant.

SELECT brand_name, SUM(quantity) AS qty_sold
FROM brand
    JOIN article USING (id_brand)
    JOIN sale USING (id_article)
GROUP BY id_brand
ORDER BY qty_sold DESC;

-- 4/ Afficher la quantité totale de bières vendues par continent, en affichant le nom du continent.

SELECT continent_name, SUM(quantity) AS qty_sold
FROM sale
    JOIN article USING (id_article)
    JOIN brand USING (id_brand)
    JOIN country USING (id_country)
    JOIN continent USING (id_continent)
GROUP BY id_continent;

-- 5/ Afficher la moyenne des prix d'achat des articles par type, en indiquant le nom du type et la moyenne des prix d'achat.

SELECT type_name, ROUND(AVG(purchase_price), 2) AS average_price
FROM article
    JOIN type USING (id_type)
GROUP BY id_type;

-- 6/ Afficher la somme des quantités vendues pour chaque couleur de bière, en affichant le nom de la couleur et la somme des quantités.

SELECT color_name, SUM(quantity) AS qty_sold
FROM color
    JOIN article a USING (id_color)
    JOIN sale s USING (id_article)
GROUP BY id_color;

-- 7/ Afficher le volume total des ventes réalisées pour chaque marque, trié par ordre décroissant.

SELECT brand_name, SUM(volume) AS total_vol, SUM(quantity) AS qty_sold
FROM brand
    JOIN article USING (id_brand)
    JOIN sale USING (id_article)
GROUP BY id_brand;

-- 8/ Afficher le prix d'achat moyen des articles pour chaque pays, en indiquant le nom du pays et le prix d'achat moyen.

SELECT country_name, ROUND(AVG(purchase_price), 2) AS average_price
FROM article
    JOIN brand USING (id_brand)
    JOIN country USING (id_country)
GROUP BY id_country;

-- 9/ Afficher le prix d'achat le plus élevé et le prix d'achat le plus bas par continent, en précisant le nom du continent.

SELECT continent_name, MAX(purchase_price) AS max_price, MIN(purchase_price) AS min_price
FROM article
    JOIN brand USING (id_brand)
    JOIN country USING (id_country)
    JOIN continent USING (id_continent)
GROUP BY id_continent
ORDER BY max_price, min_price DESC;

-- 10/ Afficher le nombre total d'articles vendus pour chaque type de bière, en affichant le nom du type et le nombre total d'articles vendus.