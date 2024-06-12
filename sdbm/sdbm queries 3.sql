
-- 1/ Donnez la liste des bières de même couleur et de même type que la bière ayant le code 142.
--     (affichez le code et le nom de la bière, le nom de la couleur et le nom du type)

SELECT id_article, article_name, color_name, type_name
FROM color
    JOIN article USING (id_color)
    JOIN type USING (id_type)
WHERE (id_type, id_color) = (
    SELECT id_type, id_color
    FROM article
    WHERE id_article = 142
)

-- 2/ Lister les quantités vendues de chaque article pour les années 2014, 2015, 2016 et 2017.

SELECT id_article, YEAR(ticket_date) AS year_, article_name, SUM(quantity) AS total_qty
FROM article
    JOIN sale USING (id_article)
    JOIN ticket USING (id_ticket)
WHERE YEAR(ticket_date) BETWEEN 2014 AND 2017
GROUP BY id_article, year_
ORDER BY id_article, year_;

-- 3/ Lister les tickets sur lesquels apparaissent un des articles apparaissant aussi sur le ticket 20175123.

SELECT id_ticket
FROM sale
WHERE id_article IN (
    SELECT id_article
    FROM sale
    WHERE id_ticket = 20175123
);

-- 4/ Donner pour chaque Type de bière, la bière la plus vendue en 2017. (Classer par quantité décroissante)

SELECT id_type, type_name, article_name, SUM(quantity)
FROM type
    JOIN article USING (id_type)
    JOIN sale USING (id_article)
    JOIN ticket USING (id_ticket)
WHERE YEAR(ticket_date) = 2017
GROUP BY id_article
ORDER BY SUM(quantity) DESC;


SELECT id_type, type_name, article_name, SUM(quantity)
FROM type
    JOIN article USING (id_type)
    JOIN sale USING (id_article)
    JOIN ticket USING (id_ticket)
    WHERE YEAR(ticket_date) = 2017 IN (
        SELECT id_type
        FROM type
            JOIN article USING (id_type)
            JOIN sale USING (id_article)
        WHERE MAX(SUM(quantity))
    )
    GROUP BY id_article
    ORDER BY SUM(quantity) DESC;

-- 5/ Donner la liste des bières qui n'ont pas été vendues en 2014 ni en 2015. (Id, nom et volume)



-- 6/ Donner la liste des bières qui n'ont pas été vendues en 2014 mais ont été vendues en 2015. (Id, nom et volume)