-- Afin de tester vos compétences en SQL, voici une série de questions auxquelles vous devez
-- répondre en rédigeant des requêtes SQL permettant d’obtenir les données demandées :


-- 1 ● Combien de bières différentes sont disponibles dans la base de données ?

SELECT COUNT(id_article)
FROM article;

-- 2 ● Quel est le nom de la bière avec le prix de vente le plus élevé ?

SELECT article_name, purchase_price
FROM article
ORDER BY purchase_price DESC LIMIT 3;

-- 3 ● Quel est le nom du continent qui compte le plus grand nombre de pays répertoriés dans
-- la base de données ?

SELECT continent_name, COUNT(id_country) AS all_countries_from
FROM continent C
    JOIN country co USING(id_continent)
GROUP BY id_continent
ORDER BY all_countries_from DESC LIMIT 1;

-- 4 ● Quel est le nom du pays d'origine de la marque de bière "Heineken" ?

SELECT brand_name, country_name
FROM brand b
    JOIN country USING (id_country)
WHERE brand_name = 'Heineken';

-- 5 ● Combien de bières ont été vendues lors de chaque transaction ? Afficher les numéros de
-- ticket, la date de ticket, et le nombre de bières.



-- 6 ● Quel est le nombre total de bières vendues jusqu'à présent ?



-- 7 ● Quelle est la marque de bière la plus vendue (en termes de quantité) ?
