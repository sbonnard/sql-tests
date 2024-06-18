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


SELECT years, id_maker, maker_name, id_type AS type_id, type_name, total_sold
FROM maker_beers_by_type m
WHERE total_sold IN (
    SELECT total_sold
    FROM maker_beers_by_type
    WHERE id_type = m.id_type AND years = 2016
)
GROUP BY id_maker, total_sold, id_type, years
HAVING type_name = 'Abbaye' AND years = 2016
ORDER BY total_sold;

-- 2/ Automatiser le calcul de la quantité total de bière vendu en nombre de bière. pour un jour donné.



-- 3/ Donner pour chaque année la ou les marques ayant vendues le plus gros volume de bière (en litres)



-- 4/ Automatiser la mise à jour de la date d'un ticket à la date du jour à chaque ajout d'une bière à celui-ci.



-- 5/ Donnez la liste des marques de bière dont au moins une bière a vendu plus de 500 unitées en 2016



-- 6/ Automatiser le fait de pouvoir augmenter ou diminuer les prix de toutes les bières d'une même marque d'un certain pourcentage.



-- 7/ Donnez pour chaque type de bière le pourcentage de répartition par continent (en nb d'article)
