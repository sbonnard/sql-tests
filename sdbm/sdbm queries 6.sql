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

CREATE VIEW total_litres_and_hectolitres_sold_by_type_by_maker AS
SELECT YEAR(ticket_date) AS years, id_maker, maker_name, id_type, type_name, SUM(quantity * volume) / 100 AS total_litres_sold, SUM(quantity * volume) / 10000 AS total_hectolitres_sold
    FROM ticket
        JOIN sale USING (id_ticket)
        JOIN article USING (id_article)
        JOIN brand USING (id_brand)
        JOIN maker USING (id_maker)
        JOIN type USING (id_type)
GROUP BY id_maker, id_type, years;

CREATE VIEW total_litres_and_hectolitres_sold_by_type_by_maker_fidelity AS
SELECT YEAR(ticket_date) AS years, id_maker, maker_name, id_type, type_name, SUM(quantity * volume) / 100 AS total_litres_sold, SUM(quantity * volume) / 10000 AS total_hectolitres_sold, 0 AS fidelity_points
    FROM ticket
        JOIN sale USING (id_ticket)
        JOIN article USING (id_article)
        JOIN brand USING (id_brand)
        JOIN maker USING (id_maker)
        JOIN type USING (id_type)
GROUP BY id_maker, id_type, years;


CREATE PROCEDURE add_fidelity_points_to_maker_2014(IN id_m INT)
UPDATE total_litres_and_hectolitres_sold_by_type_by_maker_fidelity
SET fidelity_points = (
    
)




CREATE PROCEDURE modify_price_by_brand(IN percentage INT, IN this_id_brand INT)
UPDATE article 
SET purchase_price = purchase_price * (1 + percentage / 100)
WHERE id_brand = this_id_brand;