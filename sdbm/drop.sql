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