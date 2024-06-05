CREATE DATABASE store;

CREATE TABLE customer (
    id_customer SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    firstname VARCHAR(50) NOT NULL,
    lastname VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    date_create DATETIME NOT NULL,
    PRIMARY KEY (id_customer)
);

CREATE TABLE orders (
    id_order SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    date_purchase DATETIME NOT NULL,
    id_customer SMALLINT UNSIGNED NOT NULL,
    PRIMARY KEY (id_order),
    FOREIGN KEY (id_customer) REFERENCES customer(id_customer)
);

CREATE TABLE product (
    ref_product SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    name_product VARCHAR(50) NOT NULL,
    price DECIMAL(10, 2) UNSIGNED NOT NULL,
    description VARCHAR(255),
    PRIMARY KEY (ref_product)
);

CREATE TABLE order_product (
    ref_product SMALLINT UNSIGNED NOT NULL,
    id_order SMALLINT UNSIGNED NOT NULL,
    quantity INT UNSIGNED NOT NULL,
    price_purchase DECIMAL(10, 2) UNSIGNED NOT NULL,
    PRIMARY KEY (ref_product, id_order),
    FOREIGN KEY (ref_product) REFERENCES product(ref_product),
    FOREIGN KEY (id_order) REFERENCES orders(id_order)
);

INSERT INTO
    product (name_product, price, description)
VALUES
    (
        "Ecran OLED 4K",
        225.95,
        "Un écran de grande qualité pour un confort visuel inégalé."
    );

INSERT INTO
    product (name_product, price, description)
VALUES
    (
        "Souris de précision",
        50.90,
        "Une souris précise et ergonomique pour les professionnels exigeants."
    );

INSERT INTO
    product (name_product, price, description)
VALUES
    (
        "Clavier gamer",
        65.25,
        "Un clavier haut de gamme et stylé".
    );

INSERT INTO
    customer (firstname, lastname, email, date_create)
VALUES
    (
        "Samir",
        "Dermis",
        "samird@monmail.com",
        '2022-06-21 10:35:20'
    );

INSERT INTO
    customer (firstname, lastname, email, date_create)
VALUES
    (
        "Loanne",
        "Carfou",
        "carfou.loanne@roumail.fr",
        '2020-01-20 18:22:31'
    );

INSERT INTO
    orders (date_purchase, id_customer)
VALUES
    ("2024-06-05", 1);

INSERT INTO
    order_product (ref_product, id_order, quantity, price_purchase)
VALUES
    (2, 1, 1, 50.90);

INSERT INTO
    order_product (ref_product, id_order, quantity, price_purchase)
VALUES
    (3, 1, 1, 65.25);

INSERT INTO
    orders (date_purchase, id_customer)
VALUES
    ("2024-06-05", 2);

INSERT INTO
    order_product (ref_product, id_order, quantity, price_purchase)
VALUES
    (1, 2, 2, 225.95);

-- Emptying TABLE order_product
TRUNCATE order_product;

-- Emptying TABLE orders but not working
TRUNCATE orders;

-- This line does not work
DELETE FROM orders WHERE 'orders'.'id_orders' = 2; 

-- Emptying TABLE orders
DELETE FROM orders WHERE id_orders = 1;
DELETE FROM orders WHERE id_orders = 2;

-- Emptying TABLE customer
DELETE FROM customer WHERE id_customer = 1;
DELETE FROM customer WHERE id_customer = 2;

-- Emptying TABLE product
DELETE FROM product WHERE ref_product = 1;
DELETE FROM product WHERE ref_product = 2;
DELETE FROM product WHERE ref_product = 3;