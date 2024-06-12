
-- 1/ Donnez la liste des bières de même couleur et de même type que la bière ayant le code 142.
--     (affichez le code et le nom de la bière, le nom de la couleur et le nom du type)

SELECT id_article, article_name, color_name, type_name
FROM color
    JOIN article USING (id_color)
    JOIN type USING (id_type)
WHERE (id_type, id_color) IN (
    SELECT id_type, id_color
    FROM type
        JOIN article USING (id_type)
        JOIN color USING (id_color)
    WHERE id_article = 142
)

-- 2/ Lister les quantités vendues de chaque article pour les années 2014, 2015, 2016 et 2017.

SELECT id_article, article_name, SUM(quantity) AS total_qty, YEAR(ticket_date) AS year_
FROM article
    JOIN sale USING (id_article)
    JOIN ticket USING (id_ticket)
GROUP BY id_article, year_
HAVING year_ IN (2014, 2015, 2016, 2017);

-- 3/ Lister les tickets sur lesquels apparaissent un des articles apparaissant aussi sur le ticket 20175123.

SELECT id_ticket
FROM sale
WHERE id_article IN (
        SELECT id_article
        FROM sale
        WHERE id_ticket = 20175123
);

-- 4/ Donner pour chaque Type de bière, la bière la plus vendue en 2017. (Classer par quantité décroissante)



-- 5/ Donner la liste des bières qui n'ont pas été vendues en 2014 ni en 2015. (Id, nom et volume)



-- 6/ Donner la liste des bières qui n'ont pas été vendues en 2014 mais ont été vendues en 2015. (Id, nom et volume)