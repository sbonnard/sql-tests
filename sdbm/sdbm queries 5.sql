-- 1/ Donner la liste des fabriquants dont le type de bière les plus vendues en 2016 sont les abbayes.

CREATE VIEW maker_beers_by_type AS
SELECT YEAR(ticket_date) AS years, id_maker, maker_name, id_type, type_name, SUM(quantity) AS total_sold
FROM maker
    JOIN brand USING (id_maker)
    JOIN article USING (id_brand)
    JOIN type USING (id_type)
    JOIN sale USING (id_article)
    JOIN ticket USING (id_ticket)
GROUP BY id_maker, id_type, years
ORDER BY id_maker, id_type, years;


SELECT years, id_maker, maker_name, id_type, type_name, total_sold
FROM maker_beers_by_type m
WHERE years = 2016 AND total_sold >= (
    SELECT total_sold
    FROM maker_beers_by_type
    WHERE id_maker = m.id_maker AND years = 2016
    ORDER BY total_sold DESC LIMIT 1
)
GROUP BY id_maker, total_sold, id_type, years
HAVING type_name = 'Abbaye' --OR type_name = 'Trappiste'--
ORDER BY total_sold;

-- 2/ Automatiser le calcul de la quantité total de bière vendu en nombre de bière. pour un jour donné.

CREATE VIEW quantity_sold_per_day AS
SELECT DATE_FORMAT(ticket_date, "%Y-%m-%d") AS date_, SUM(quantity) AS quantity_sold
FROM sale
    JOIN ticket USING (id_ticket)
GROUP BY date_;

CREATE PROCEDURE get_quantity_sold_per_date (IN d DATE)
SELECT DATE_FORMAT(ticket_date, "%Y-%m-%d") AS date_, SUM(quantity) AS quantity_sold
FROM ticket
    JOIN sale USING (id_ticket)
GROUP BY date_
HAVING date_ = d;

CALL get_quantity_sold_per_date ("2016-03-22");

-- 3/ Donner pour chaque année la ou les marques ayant vendues le plus gros volume de bière (en litres)


--------------------------- FULL QUERY ------------------------------
SELECT YEAR(ticket_date) AS years, id_brand, brand_name, SUM(quantity * volume) / 100 AS total_litres_sold
FROM brand b
    JOIN article USING (id_brand)
    JOIN sale USING (id_article)
    JOIN ticket t USING (id_ticket)
GROUP BY id_brand, years
HAVING total_litres_sold >= ALL (
    SELECT SUM(quantity * volume) / 100 AS total_litres_sold
    FROM brand b
        JOIN article USING (id_brand)
        JOIN sale USING (id_article)
        JOIN ticket USING (id_ticket)
    WHERE YEAR(ticket_date) = years
    GROUP BY years, id_brand
);

-------------------------- WITH VIEW -------------------------------

SELECT brand_name, years
FROM brand_volume_years b
WHERE volume_total >= ALL (
    SELECT volume_total
    FROM brand_volume_years
    WHERE years = b.years
)
ORDER BY years;

--------------------------------------------------------------------
-- THE MOST SOLD BRAND IN 2015 
SELECT YEAR(ticket_date) AS years, id_brand, brand_name
FROM brand b
    JOIN article USING (id_brand)
    JOIN sale USING (id_article)
    JOIN ticket USING (id_ticket)
WHERE YEAR(ticket_date) = 2015
GROUP BY years, id_brand
ORDER BY SUM(quantity * volume) / 100 DESC LIMIT 1;


-- 4/ Automatiser la mise à jour de la date d'un ticket à la date du jour à chaque ajout d'une bière à celui-ci.


------------------------ TRIGGER ------------------------
DELIMITER //

CREATE TRIGGER update_date_for_ticket
AFTER INSERT ON sale
FOR EACH ROW
BEGIN
    UPDATE ticket
    SET ticket_date = CURDATE()
    WHERE id_ticket = NEW.id_ticket;
END //

DELIMITER ;

---------------------------------------------------------
------------------------- QUERY -------------------------

INSERT INTO sale (id_ticket, id_article, quantity)
VALUES (20141, 15, 1);

-- 5/ Donnez la liste des marques de bière dont au moins une bière a vendu plus de 500 unités en 2016

CREATE VIEW sales_by_article_per_years AS
SELECT YEAR(ticket_date) AS years, id_brand, brand_name, id_article, article_name, SUM(quantity) AS total_sold
FROM brand  
    JOIN article USING (id_brand)
    JOIN sale USING (id_article)
    JOIN ticket USING (id_ticket)
GROUP BY id_article, id_brand, years;

SELECT years, brand_name, article_name, total_sold
FROM sales_by_article_per_years
WHERE years = 2016 AND total_sold > 500
GROUP BY id_brand, total_sold, id_article;

-- 6/ Automatiser le fait de pouvoir augmenter ou diminuer les prix de toutes les bières d'une même marque d'un certain pourcentage.

CREATE PROCEDURE modify_price_by_brand(IN percentage INT, IN this_id_brand INT)
UPDATE article 
SET purchase_price = purchase_price * (1 + percentage / 100)
WHERE id_brand = this_id_brand;



SELECT article_name, purchase_price
FROM article
WHERE id_brand = 1;

CALL modify_price_by_brand(10, 1);

SELECT article_name, purchase_price
FROM article
WHERE id_brand = 1;

-- 7/ Donnez pour chaque type de bière le pourcentage de répartition par continent (en nb d'article)

CREATE VIEW number_beer_by_type_by_continent AS
SELECT COUNT(id_article) AS count_id, id_type, type_name, id_continent, continent_name
FROM article
    JOIN type USING (id_type)
    JOIN brand USING (id_brand)
    JOIN country USING (id_country)
    JOIN continent USING (id_continent)
GROUP BY id_type, id_continent
ORDER BY id_type, id_continent;

SELECT type_name,
    ROUND(count_id / (
        SELECT SUM(count_id)
        FROM number_beer_by_type_by_continent
        WHERE id_type = b.id_type
        GROUP BY id_type
    ) * 100, 2) AS percentage_,
    continent_name
FROM number_beer_by_type_by_continent b
ORDER BY id_type;