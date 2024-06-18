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
    )
    ORDER BY id_continent;

-- 2/ Récupérer le volume de bières vendu pour chaque mois et pour chaque type de bière
-- classés par années, mois et type de bière

SELECT YEAR(ticket_date) AS year_, MONTH(ticket_date) AS month_, ROUND(SUM(volume * quantity) / 100, 2) AS volume_litres, id_type, type_name
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
WHERE country_name = 'Allemagne' AND EXISTS (
    SELECT id_ticket
    FROM country
        JOIN brand USING (id_country)
        JOIN article USING (id_brand)
        JOIN sale USING (id_article)
    WHERE country_name = 'France' AND id_ticket = s.id_ticket
    GROUP BY id_ticket 
)
GROUP BY id_article
ORDER BY article_name;

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

SELECT id_article, article_name
FROM article a
    JOIN sale USING (id_article)
GROUP BY id_article
HAVING NOT EXISTS (
    SELECT SUM(quantity * volume) / 100 AS total_litres
    FROM article
        JOIN sale USING (id_article)
        JOIN ticket USING (id_ticket)
    WHERE id_article = a.id_article
    GROUP BY YEAR(ticket_date)
    HAVING total_litres < 200
) 
ORDER BY id_article;

-------------------- OR BETTER ----------------------

SELECT id_article, article_name
FROM article a
WHERE 200 < ALL (
    SELECT SUM(quantity * volume) / 100 AS total_litres
    FROM article
        JOIN sale USING (id_article)
        JOIN ticket USING (id_ticket)
    WHERE id_article = a.id_article
    GROUP BY YEAR(ticket_date)
) 
ORDER BY id_article;

----------------------- TESTS ------------------------

SELECT YEAR(ticket_date) AS year_, id_article, article_name, SUM(quantity * volume) / 100 AS total_litres
FROM article
    JOIN sale USING (id_article)
    JOIN ticket USING (id_ticket)
GROUP BY id_article, year_
HAVING total_litres >= 200
ORDER BY id_article, year_;

SELECT YEAR(ticket_date) AS year_, id_article, article_name, SUM(quantity * volume) / 100 AS total_litres
FROM article
    JOIN sale USING (id_article)
    JOIN ticket USING (id_ticket)
WHERE id_article = 14
GROUP BY year_;

-- 6/ Récupérer pour chaque pays la ou les marques de bière dont le degrès d'alcool moyen est le plus élevé en affichant le degré d'alcool moyen

SELECT id_country AS id_country1, country_name, brand_name, AVG(alcohol) AS average_alcohol
FROM country
    JOIN brand USING (id_country)
    JOIN article USING (id_brand)
GROUP BY id_brand
HAVING average_alcohol >= ALL (
    SELECT AVG(alcohol)
    FROM brand
        JOIN article USING (id_brand)
    WHERE id_country = id_country1
    GROUP BY id_brand
);


SELECT id_country AS id_country1, country_name, brand_name, AVG(alcohol) AS average_alcohol
FROM country
    JOIN brand USING (id_country)
    JOIN article USING (id_brand)
GROUP BY id_brand
HAVING average_alcohol = (
    SELECT MAX(avg) 
    FROM (
        SELECT AVG(alcohol) AS avg
        FROM brand
            JOIN article USING (id_brand)
        WHERE id_country = id_country1
        GROUP BY id_brand
    ) AS avg_alcohol_brand
);


SELECT id_country AS id_country1, country_name, brand_name, AVG(alcohol) AS average_alcohol
FROM country
    JOIN brand USING (id_country)
    JOIN article USING (id_brand)
GROUP BY id_brand
HAVING average_alcohol = (
    SELECT AVG(alcohol) AS avg
    FROM brand 
        JOIN article USING (id_brand)
    WHERE id_country = id_country1
    GROUP BY id_brand
    ORDER BY avg DESC
    LIMIT 1
);

-- STRONGEST BEER FROM FRANCE, NOT USEFUL

SELECT id_country, country_name, id_brand, brand_name, alcohol
FROM country
    JOIN brand USING (id_country)
    JOIN article USING (id_brand)
WHERE id_country = 9
GROUP BY id_brand, id_country, alcohol
ORDER BY alcohol DESC LIMIT 1;

----------------------------------------------------

-- CALCULATE THE AVERAGE ALCOHOL FROM EACH BREWERY

SELECT id_brand, brand_name, ROUND(AVG(alcohol), 2) AS average_alcohol
FROM article
    JOIN brand USING (id_brand)
    JOIN country USING (id_country)
GROUP BY id_brand
ORDER BY average_alcohol DESC;


-- 7/ Donner pour chaque type de bière, la bière la plus vendue et la bière la moins vendue en 2016

-------------------------------------------------------------
CREATE VIEW beer_sales_by_article_2016 AS
SELECT id_article, article_name, SUM(quantity) AS total_sold
FROM article
    JOIN sale USING (id_article)
    JOIN ticket USING (id_ticket)
WHERE YEAR(ticket_date) = 2016
GROUP BY id_article
ORDER BY total_sold;
-------------------------------------------------------------

(
SELECT id_type, type_name, b.article_name, 'best-seller' AS sales
FROM beer_sales_by_article_2016 b
    JOIN article USING (id_article)
    JOIN type t USING (id_type)
WHERE total_sold >= ALL (
    SELECT total_sold
    FROM beer_sales_by_article_2016
    JOIN article USING (id_article)
    JOIN type USING (id_type)
    WHERE id_type = t.id_type
)) 
UNION
(
SELECT id_type, type_name, b.article_name, 'worst-seller' AS sales
FROM beer_sales_by_article_2016 b
    JOIN article USING (id_article)
    JOIN type t USING (id_type)
WHERE total_sold <= ALL (
    SELECT total_sold
    FROM beer_sales_by_article_2016
    JOIN article USING (id_article)
    JOIN type USING (id_type)
    WHERE id_type = t.id_type
)) 
ORDER BY id_type;


------ BESTSELLER FROM 2016
SELECT total_sold, article_name
FROM beer_sales_by_article_2016
ORDER BY total_sold DESC LIMIT 1;


------ WORSTSELLER FROM 2016
SELECT total_sold, article_name
FROM beer_sales_by_article_2016
ORDER BY total_sold ASC LIMIT 1;

-- 8/ Donner pour toutes les couleurs de bières la plus vendue pour chacune des années 2015, 2016 et 2017 

SELECT id_color AS color_id, color_name, YEAR(ticket_date) AS years, article_name, SUM(quantity) AS sum
FROM article
    JOIN sale USING (id_article)
    JOIN ticket USING (id_ticket)
    JOIN color USING (id_color)
WHERE YEAR(ticket_date) IN (2015, 2016, 2017)
GROUP BY id_article, years
HAVING sum >= ALL (
    SELECT SUM(quantity) AS sum
    FROM article
        JOIN sale USING (id_article)
        JOIN ticket USING (id_ticket)
    WHERE YEAR(ticket_date) = years AND id_color = color_id
    GROUP BY id_article
)
ORDER BY color_id, years;
    
-- 9/ Lister les marques de bières dont le volume total vendu (en litres) en 2015 est supérieur à celui de Heineken.

-- WITH A VIEW
CREATE VIEW brand_volume_years AS 
SELECT brand_name, YEAR(ticket_date) AS years,(SUM(volume*quantity)/100) AS volume_total
FROM article
    JOIN sale USING (id_article)
    JOIN brand USING (id_brand)
    JOIN ticket USING (id_ticket)
GROUP BY id_brand, years;

-- WAY EASIER

SELECT brand_name, volume_total
FROM  brand_volume_years
WHERE years = 2015 AND volume_total > 
(
    SELECT volume_total
    FROM  brand_volume_years
    WHERE years = 2015  AND brand_name = "Heineken" 
);

-----------------------------------------------------------------------

-- WITHOUT VIEWS

SELECT id_brand, brand_name, SUM(quantity * volume) /100 AS total_sold
FROM brand
    JOIN article USING (id_brand)
    JOIN sale USING (id_article)
    JOIN ticket USING (id_ticket)
WHERE YEAR(ticket_date) = 2015
GROUP BY id_brand
HAVING total_sold > (
    SELECT SUM(quantity * volume) / 100 AS total_sold
    FROM brand
        JOIN article USING (id_brand)
        JOIN sale USING (id_article)
        JOIN ticket USING (id_ticket)
    WHERE YEAR(ticket_date) = 2015 AND brand_name = 'Heineken'
    GROUP BY id_brand
    )
ORDER BY total_sold;

-- SUBQUERY FOR HEINEKEN SALES IN 2015
SELECT id_brand, brand_name, SUM(quantity * volume) / 100 AS total_sold
FROM brand
    JOIN article USING (id_brand)
    JOIN sale USING (id_article)
    JOIN ticket USING (id_ticket)
WHERE YEAR(ticket_date) = 2015 AND brand_name = 'Heineken'
GROUP BY id_brand;

-- 10/ Lister les marques de bières dont le volume total vendu (en litres) est supérieur à celui de Heineken pour chaque année entre 2015 et 2017.


SELECT brand_name
FROM brand_volume_years b
WHERE years IN (2015, 2016, 2017) AND volume_total > (
    SELECT volume_total
    FROM brand_volume_years
    WHERE brand_name = 'Heineken' AND years = b.years
)
GROUP BY brand_name
HAVING COUNT(DISTINCT years) = 3;


-- HEINEKEN SALES IN 2015, 2016 and 2017 
SELECT YEAR(ticket_date) AS year_, id_brand, brand_name, SUM(quantity * volume) / 100 AS total_sold
FROM brand
    JOIN article USING (id_brand)
    JOIN sale USING (id_article)
    JOIN ticket USING (id_ticket)
WHERE (YEAR(ticket_date) IN (2015, 2016, 2017)) AND brand_name = 'Heineken'
GROUP BY id_brand, year_;


-- BEST HEINEKEN SALES IN LITRES BETWEEN 2015, 2016 AND 2017
SELECT YEAR(ticket_date) AS year_, id_brand, brand_name, SUM(quantity * volume) / 100 AS total_sold
FROM brand
    JOIN article USING (id_brand)
    JOIN sale USING (id_article)
    JOIN ticket USING (id_ticket)
WHERE (YEAR(ticket_date) IN (2015, 2016, 2017)) AND brand_name = 'Heineken'
GROUP BY id_brand, year_
ORDER BY total_sold DESC LIMIT 1;