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