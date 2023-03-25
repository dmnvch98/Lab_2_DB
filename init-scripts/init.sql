DROP TABLE IF EXISTS Products;

CREATE TABLE IF NOT EXISTS Products
(
    id          INT         NOT NULL PRIMARY KEY,
    description VARCHAR(45) NOT NULL,
    price       INT         NOT NULL
);

DROP TABLE IF EXISTS Suppliers;

CREATE TABLE IF NOT EXISTS Suppliers
(
    id          INT         NOT NULL PRIMARY KEY,
    description VARCHAR(45) NOT NULL,
    phone       VARCHAR(45) NOT NULL,
    address     VARCHAR(45) NOT NULL
);

DROP TABLE IF EXISTS Warehouse;

CREATE TABLE IF NOT EXISTS Warehouse
(
    id          INT         NOT NULL PRIMARY KEY,
    description VARCHAR(45) NOT NULL,
    address     VARCHAR(45) NOT NULL
);

DROP TABLE IF EXISTS Materials;

CREATE TABLE IF NOT EXISTS Materials
(
    id           INT         NOT NULL PRIMARY KEY,
    description  VARCHAR(45) NOT NULL,
    peace_price  INT         NOT NULL,
    supplier_id  INT         NOT NULL,
    warehouse_id INT         NOT NULL,
    available    INT         NOT NULL,

    CONSTRAINT supplier_id
        FOREIGN KEY (supplier_id)
            REFERENCES Suppliers (id),
    CONSTRAINT s_warehouse_id
        FOREIGN KEY (warehouse_id)
            REFERENCES Warehouse (id)
);