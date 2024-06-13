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




    SELECT YEAR(ticket_date) AS year_, id_type, type_name, id_article, article_name, SUM(quantity) AS max_sold, SUM(quantity) AS min_sold
FROM type
    JOIN article USING (id_type)
    JOIN sale USING (id_article)
    JOIN ticket USING (id_ticket)
GROUP BY id_type, id_article, year_
HAVING max_sold = MAX(max_sold) AND min_sold = MIN(min_sold);