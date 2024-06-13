-- 1/ Récupérer toutes les bières les plus alcoolisés de chaque continent
-- afficher le nom du continent , le nom de la bière, le degrès d'alcool et le volume 

SELECT continent_name, article_name, alcohol, volume
FROM continent c
    JOIN country USING (id_continent)
    JOIN brand USING (id_country)
    JOIN article USING (id_brand)
WHERE alcohol = (
        SELECT MAX(alcohol)
        FROM continent
            JOIN country USING (id_continent)
            JOIN brand USING (id_country)
            JOIN article USING (id_brand)
        WHERE id_continent = c.id_continent
    );

-- 2/ Récupérer le volume de bières vendu pour chaque mois et pour chaque type de bière
-- classés par années, mois et type de bière

SELECT YEAR(ticket_date) AS year_, MONTH(ticket_date) AS month_, SUM(volume * quantity) / 100 AS volume_litres, id_type, type_name
FROM ticket
    JOIN sale USING (id_ticket)
    JOIN article USING (id_article)
    JOIN type USING (id_type)
GROUP BY id_type, year_, month_
ORDER BY id_type ASC;

-- 3/ Récupérer le nom et le volume des bières allemandes achetées en même temps que des bières françaises
-- classés par nom de bière

SELECT id_article, article_name, SUM(quantity) AS total_qty
FROM country
    JOIN brand USING (id_country)
    JOIN article USING (id_brand)
    JOIN sale s USING (id_article)
WHERE country_name = 'Allemagne' AND id_ticket IN (
    SELECT id_ticket
    FROM country
        JOIN brand USING (id_country)
        JOIN article USING (id_brand)
        JOIN sale USING (id_article)
    WHERE country_name = 'France' 
)
GROUP BY id_article
ORDER BY id_article;

-- 4/ Récupérer la liste des bières pour lequelles les ventes ont agumentées entre 2015 et 2016

SELECT id_article, article_name, YEAR(ticket_date) AS year_
FROM article
    JOIN sale USING (id_article)
    JOIN ticket USING (id_ticket)
WHERE YEAR(ticket_date) IN (2015, 2016)
GROUP BY id_article, year_
HAVING (SUM(quantity) AND year_ = 2015) < (SUM(quantity) AND year_ = 2016)
ORDER BY id_article;

-- 5/ Récupérer les bières pour lesquelles le volume de bières
-- vendus est d'au moins 200 litres pour toutes les années

SELECT YEAR(ticket_date) AS year_, id_article, article_name, SUM(volume * quantity) / 100 AS volume_litres
FROM article
    JOIN sale USING (id_article)
    JOIN ticket USING (id_ticket)
GROUP BY id_article, year_
HAVING volume_litres >= 200
ORDER BY id_article, year_;

-- 6/ Récupérer pour chaque pays la ou les marques de bière dont le degrès d'alcool moyen est le plus élevé en affichant le degré d'alcool moyen

SELECT id_country, country_name, id_brand, brand_name, ROUND(AVG(alcohol), 2) AS average_alcohol
FROM country c
    JOIN brand USING (id_country)
    JOIN article USING (id_brand)
    GROUP BY id_country, id_brand
HAVING AVG(alcohol) = (
        SELECT AVG(alcohol) as average_alcohol
        FROM country
            JOIN brand USING (id_country)
            JOIN article USING (id_brand)
        WHERE id_country = c.id_country
    )
    ORDER BY id_brand ASC;

-- 7/ Donner pour chaque type de bière, la bière la plus vendue et la bière la moins vendue en 2016

SELECT id_type, type_name, id_article, article_name, 
   
    (SELECT SUM(quantity) AS best_seller
    FROM sale
        JOIN ticket USING (id_ticket)
    WHERE YEAR(ticket_date) = 2016
    GROUP BY s.id_article
    ORDER BY best_seller DESC LIMIT 1) AS best_seller,
    
    (SELECT SUM(quantity) AS least_sold
    FROM sale
        JOIN ticket USING (id_ticket)
    WHERE YEAR(ticket_date) = 2016
    GROUP BY s.id_article
    ORDER BY least_sold ASC LIMIT 1) AS least_sold

    FROM type
    JOIN article USING (id_type)
    JOIN sale s USING (id_article)
    JOIN ticket USING (id_ticket)
    WHERE YEAR(ticket_date) = 2016
    GROUP BY id_type, id_article;

-- SUBQUERY 1 

SELECT id_type, type_name, id_article, article_name, SUM(quantity) AS best_seller
FROM type
    JOIN article USING (id_type)
    JOIN sale USING (id_article)
    JOIN ticket USING (id_ticket)
WHERE YEAR(ticket_date) = 2016
GROUP BY id_type, id_article
ORDER BY best_seller DESC LIMIT 1;

-- SUBQUERY 2

SELECT id_type, type_name, id_article, article_name, SUM(quantity) AS least_sold
FROM type
    JOIN article USING (id_type)
    JOIN sale USING (id_article)
    JOIN ticket USING (id_ticket)
WHERE YEAR(ticket_date) = 2016
GROUP BY id_type, id_article
ORDER BY least_sold ASC LIMIT 1;

-- 8/ Donner pour toutes les couleurs de bières la plus vendue pour chacune des années 2015, 2016 et 2017 



-- 9/ Lister les marques de bières dont le volume total vendu (en litres) en 2015 est supérieur à celui de Heineken.



-- 10/ Lister les marques de bières dont le volume total vendu (en litres) est supérieur à celui de Heineken pour chaque année entre 2015 et 2017.