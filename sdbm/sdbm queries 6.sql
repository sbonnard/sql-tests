-- A chaque début d'année, les ventes de bière de l'année précédente de chaque fabricant sont analysées pour leur attribuer des points de fidélité basés sur le volume total vendu par marque. Les règles d'attribution des points de fidélité sont les suivantes :

    -- Si le volume total vendu d'une marque atteint 1 hectolitre, le fabricant gagne 10 points par hectolitre intégralement vendu.
    -- Si le volume total vendu d'une marque atteint 5 hectolitres, le fabricant gagne 20 points par hectolitre intégralement vendu.
    -- Si le volume total vendu d'une marque atteint 10 hectolitres, le fabricant gagne 30 points par hectolitre intégralement vendu.
    -- Si le volume total vendu d'une marque atteint 20 hectolitres, le fabricant gagne 40 points par hectolitre intégralement vendu.

-- En plus de ces points, les fabricants touchent un bonus de points s'ils ont vendu (toutes marques confondues) des bières de certains types. Tous les ans les types de bière permettant d'obtenir ces points bonus changent. Voici les règles d'attribution de ces points bonus :

    -- En 2014 c'était :
        -- Pour plus de 300 litres de bière de type Abbaye, 300 points ;
        -- Pour plus de 200 litres de bière de type Pils et Lager, 200 points ;
        -- Pour plus de 100 litres de bière de type Stout, 100 points ;

    -- En 2015 c'était :
        -- Pour plus de 1500 litres de bière de type Abbaye, 300 points ;
        -- Pour plus de 1000 litres de bière de type Pils et Lager, 200 points ;
        -- Pour plus de 500 litres de bière de type Lambic, 100 points ;

    -- En 2016 c'était :
        -- Pour plus de 500 litres de bière de type Trappiste, 300 points ;
        -- Pour plus de 300 litres de bière de type Bière Aromatisée, 200 points ;
        -- Pour plus de 200 litres de bière de type Ale, 100 points ;

    -- En 2017, c'était :
        -- Pour plus de 2000 litres de bière de type Trappiste, 300 points ;
        -- Pour plus de 1500 litres de bière de type Bière de Saison, 200 points ;
        -- Pour plus de 1000 litres de bière de type Stout, 100 points ;

-- Calculer le nombre de points de fidélités gagnés par chaque fabricant pour chacune des années écoulées.


------------------------------------ VIEW WITH ALL THE DATAS OF QUANTITY AND MAKERS -----------------------------------
CREATE VIEW volume_by_makers_by_types_years AS
SELECT maker_name, brand_name, (SUM(volume * quantity) / 10000) AS volume, type_name, YEAR(ticket_date) AS year_
FROM maker
    JOIN brand USING (id_maker)
    JOIN article USING (id_brand)
    JOIN sale USING (id_article)
    JOIN ticket USING (id_ticket)
    JOIN type USING (id_type)
GROUP BY id_maker, id_brand, id_type, year_
ORDER BY id_maker, id_brand, year_;

------------------------------------------ VIEW TO MANAGE LOYALTY -----------------------------------------------------
CREATE VIEW loyalty_by_brand AS
SELECT maker_name, brand_name, year_, SUM(volume),
    CASE
        WHEN SUM(volume) >= 20 THEN FLOOR(SUM(volume)) * 40
        WHEN SUM(volume) >= 10 THEN FLOOR(SUM(volume)) * 30
        WHEN SUM(volume) >= 5 THEN FLOOR(SUM(volume)) * 20
        WHEN SUM(volume) >= 1 THEN FLOOR(SUM(volume)) * 10
        ELSE 0
    END AS loyalty_points
FROM volume_by_makers_by_types_years
GROUP BY maker_name, brand_name, year_
ORDER BY maker_name, year_;

--------------------------------------------- LOYALTY POINTS BY MAKER -------------------------------------------------
SELECT maker_name, year_, SUM(loyalty_points) AS loyalty_points_base
FROM loyalty_by_brand
GROUP BY maker_name, year_
ORDER BY maker_name, year_;


------------------------------------------------- REWARDS BY YEAR------------------------------------------------------

--2014
CREATE VIEW bonus_points_2014 AS
SELECT maker_name, 2014 AS year_,
    SUM(CASE WHEN type_name = 'Abbaye' AND volume > 3 THEN 300 ELSE 0 END) AS abbaye_bonus,
    SUM(CASE WHEN type_name = 'Pils et Lager' AND volume > 2 THEN 200 ELSE 0 END) AS pils_bonus,
    SUM(CASE WHEN type_name = 'Stout' AND volume > 1 THEN 100 ELSE 0 END) AS stout_bonus
FROM volume_by_makers_by_types_years
WHERE year_ = 2014
GROUP BY maker_name;

SELECT maker_name, SUM(abbaye_bonus + pils_bonus + stout_bonus) AS total_bonus_points_2014
FROM bonus_points_2014
GROUP BY maker_name;

--2015 
CREATE VIEW bonus_points_2015 AS
SELECT maker_name, 2015 AS year_,
    SUM(CASE WHEN type_name = 'Abbaye' AND volume > 15 THEN 300 ELSE 0 END) AS abbaye_bonus,
    SUM(CASE WHEN type_name = 'Pils et Lager' AND volume > 10 THEN 200 ELSE 0 END) AS pils_bonus,
    SUM(CASE WHEN type_name = 'Lambic' AND volume > 5 THEN 100 ELSE 0 END) AS lambic_bonus
FROM volume_by_makers_by_types_years
WHERE year_ = 2015
GROUP BY maker_name;

SELECT maker_name, SUM(abbaye_bonus + pils_bonus + lambic_bonus) AS total_bonus_points_2015
FROM bonus_points_2015
GROUP BY maker_name;

--2016
CREATE VIEW bonus_points_2016  AS
SELECT maker_name, 2016  AS year_,
    SUM(CASE WHEN type_name = 'Trappiste' AND volume > 5 THEN 300 ELSE 0 END) AS trappiste_bonus,
    SUM(CASE WHEN type_name = 'Bière Aromatisée' AND volume > 3 THEN 200 ELSE 0 END) AS flavoured_bonus,
    SUM(CASE WHEN type_name = 'Ale' AND volume > 2 THEN 100 ELSE 0 END) AS ale_bonus
FROM volume_by_makers_by_types_years
WHERE year_ = 2016 
GROUP BY maker_name;

SELECT maker_name, SUM(trappiste_bonus + flavoured_bonus + ale_bonus) AS total_bonus_points_2016
FROM bonus_points_2016
GROUP BY maker_name;

--2017
CREATE VIEW bonus_points_2017  AS
SELECT maker_name, 2017  AS year_,
    SUM(CASE WHEN type_name = 'Trappiste' AND volume > 20 THEN 300 ELSE 0 END) AS trappiste_bonus,
    SUM(CASE WHEN type_name = 'Bière de Saison' AND volume > 15 THEN 200 ELSE 0 END) AS saison_bonus,
    SUM(CASE WHEN type_name = 'Stout' AND volume > 10 THEN 100 ELSE 0 END) AS stout_bonus
FROM volume_by_makers_by_types_years
WHERE year_ = 2017 
GROUP BY maker_name;

SELECT maker_name, SUM(trappiste_bonus + saison_bonus + stout_bonus) AS total_bonus_points_2017
FROM bonus_points_2017
GROUP BY maker_name;