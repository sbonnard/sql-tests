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
    price DECIMAL(10,2) UNSIGNED NOT NULL,
    description VARCHAR(255),
    PRIMARY KEY (ref_product)
);

CREATE TABLE order_product (
    ref_product SMALLINT UNSIGNED NOT NULL,
    id_order SMALLINT UNSIGNED NOT NULL,
    quantity INT UNSIGNED NOT NULL,
    price_purchase DECIMAL(10,2) UNSIGNED NOT NULL,
    PRIMARY KEY (ref_product, id_order),
    FOREIGN KEY (ref_product) REFERENCES product(ref_product),
    FOREIGN KEY (id_order) REFERENCES orders(id_order)
);