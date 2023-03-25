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

DROP TABLE IF EXISTS Clients;

CREATE TABLE IF NOT EXISTS Clients
(
    id         INT         NOT NULL PRIMARY KEY,
    phone      VARCHAR(45) NOT NULL,
    first_name VARCHAR(45) NOT NULL,
    last_name  VARCHAR(45) NOT NULL
);

DROP TABLE IF EXISTS job_titles;

CREATE TABLE IF NOT EXISTS job_titles
(
    id          INT         NOT NULL PRIMARY KEY,
    description VARCHAR(45) NOT NULL,
    PRIMARY KEY (id)
);


DROP TABLE IF EXISTS Manifactoring_facility;

CREATE TABLE IF NOT EXISTS Manifactoring_facility
(
    id          INT         NOT NULL PRIMARY KEY,
    description VARCHAR(45) NOT NULL,
    PRIMARY KEY (id)
);

DROP TABLE IF EXISTS Employees;

CREATE TABLE IF NOT EXISTS Employees
(
    id                        INT         NOT NULL PRIMARY KEY,
    job_title_id              INT         NOT NULL,
    first_name                VARCHAR(45) NOT NULL,
    last_name                 VARCHAR(45) NOT NULL,
    employment_date           TIMESTAMP   NOT NULL,
    dissmisal_date            TIMESTAMP   NULL,
    salary                    INT         NOT NULL,
    phone                     VARCHAR(45) NOT NULL,
    home_address              VARCHAR(45) NOT NULL,
    manifactoring_facility_id INT         NOT NULL,

    CONSTRAINT emp_job_description_id
        FOREIGN KEY (job_title_id)
            REFERENCES job_titles (id),
    CONSTRAINT emp_manifactoring_facility_id
        FOREIGN KEY (manifactoring_facility_id)
            REFERENCES Manifactoring_facility (id)

);

DROP TABLE IF EXISTS Statuses;

CREATE TABLE IF NOT EXISTS Statuses
(
    id          INT         NOT NULL PRIMARY KEY,
    description VARCHAR(45) NOT NULL,
    PRIMARY KEY (id)
);

DROP TABLE IF EXISTS Orders;

CREATE TABLE IF NOT EXISTS Orders
(
    id                      INT         NOT NULL PRIMARY KEY,
    client_id               INT         NOT NULL,
    date_created            timestamp   NOT NULL,
    date_finished           timestamp   NULL,
    delivery_address        VARCHAR(45) NULL,
    paid                    BOOLEAN     NOT NULL,
    status_id               INT         NOT NULL,
    deliveryman_employee_id INT         NULL,
    PRIMARY KEY (id),
    CONSTRAINT client_id
        FOREIGN KEY (client_id)
            REFERENCES Clients (id),
    CONSTRAINT deliveryman_employee_id
        FOREIGN KEY (deliveryman_employee_id)
            REFERENCES Employees (id),
    CONSTRAINT status_id
        FOREIGN KEY (status_id)
            REFERENCES Statuses (id)

);


DROP TABLE IF EXISTS Products_materials_qty;

CREATE TABLE IF NOT EXISTS Products_materials_qty
(
    id                       INT   NOT NULL PRIMARY KEY,
    product_id               INT   NOT NULL,
    material_id              INT   NOT NULL,
    material_cubic_meter_qty FLOAT NOT NULL,

    CONSTRAINT product_id
        FOREIGN KEY (product_id)
            REFERENCES Products (id),
    CONSTRAINT material_id
        FOREIGN KEY (material_id)
            REFERENCES Materials (id)
);

DROP TABLE IF EXISTS Order_products;

CREATE TABLE IF NOT EXISTS Order_products
(
    id           INT NOT NULL PRIMARY KEY,
    order_id     INT NOT NULL,
    product_id   INT NOT NULL,
    employee_id  INT NOT NULL,
    warehouse_id INT NOT NULL,
    CONSTRAINT op_order_id
        FOREIGN KEY (order_id)
            REFERENCES Orders (id),
    CONSTRAINT op_product_id
        FOREIGN KEY (product_id)
            REFERENCES Products (id),
    CONSTRAINT op_employee_id
        FOREIGN KEY (employee_id)
            REFERENCES Employees (id),
    CONSTRAINT op_warehouse_id
        FOREIGN KEY (warehouse_id)
            REFERENCES Warehouse (id)
);

DROP TABLE IF EXISTS Equipment;

CREATE TABLE IF NOT EXISTS Equipment
(
    id                        INT         NOT NULL PRIMARY KEY,
    description               VARCHAR(45) NOT NULL,
    expluatation_start        timestamp   NOT NULL,
    service_life_years        INT         NOT NULL,
    working_condition         boolean     NOT NULL,
    responsible_employee_id   INT         NOT NULL,
    manifactoring_facility_id INT         NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT responsible_employee_id
        FOREIGN KEY (responsible_employee_id)
            REFERENCES Employees (id),
    CONSTRAINT e_manifactoring_facility_id
        FOREIGN KEY (manifactoring_facility_id)
            REFERENCES Manifactoring_facility (id)
);

CREATE OR REPLACE FUNCTION if_materials_available_for_order(product_id1 INTEGER)
    RETURNS BOOLEAN AS
$$
BEGIN
    RETURN EXISTS(
            SELECT pmq.material_cubic_meter_qty, m.description
            FROM materials m
                     JOIN products_materials_qty pmq ON m.id = pmq.material_id
                     JOIN products p ON pmq.product_id = p.id
            WHERE p.id = product_id1
              AND m.available >= ALL
                  (SELECT material_cubic_meter_qty FROM products_materials_qty WHERE product_id1 = p.id)
        );
END;
$$;

CREATE OR REPLACE FUNCTION order_products_before_insert()
    RETURNS TRIGGER AS
$$
BEGIN
    IF NOT if_materials_available_for_order(NEW.product_id) THEN
        RAISE EXCEPTION 'not enough materials to complete the order';
    END IF;
    RETURN NEW;
END;
$$;

CREATE TRIGGER order_products_trigger
    BEFORE INSERT
    ON order_products
    FOR EACH ROW
EXECUTE FUNCTION order_products_before_insert();


START TRANSACTION;
INSERT INTO Products (id, description, price)
VALUES (1, 'Armchair', 100);
INSERT INTO Products (id, description, price)
VALUES (2, 'Bookshelf', 150);
INSERT INTO Products (id, description, price)
VALUES (3, 'Chair', 350);
INSERT INTO Products (id, description, price)
VALUES (4, 'Coffee-table', 100);
INSERT INTO Products (id, description, price)
VALUES (5, 'Cushion', 50);
INSERT INTO Products (id, description, price)
VALUES (6, 'Floor lamp', 120);
INSERT INTO Products (id, description, price)
VALUES (7, 'Hammock', 135);
INSERT INTO Products (id, description, price)
VALUES (8, 'Rocking chair', 200);
INSERT INTO Products (id, description, price)
VALUES (9, 'Sofa', 500);
INSERT INTO Products (id, description, price)
VALUES (10, 'TV-set', 350);

COMMIT;

START TRANSACTION;
INSERT INTO Suppliers (id, description, phone, address)
VALUES (1, 'mollis', '1-548-790-5724', '8453 Commodo Ave');
INSERT INTO Suppliers (id, description, phone, address)
VALUES (2, 'lacus', '1-248-448-1665', '6078 Magna, Ave');
INSERT INTO Suppliers (id, description, phone, address)
VALUES (3, 'nibh', '1-573-295-7957', '194-8096 Imperdiet Avenue');
INSERT INTO Suppliers (id, description, phone, address)
VALUES (4, 'non', '1-647-616-0598', 'Ap #962-7192 Nascetur Ave');
INSERT INTO Suppliers (id, description, phone, address)
VALUES (5, 'parturient', '1-135-823-2951', 'Ap #497-9020 Dictum. Avenue');
COMMIT;


START TRANSACTION;
INSERT INTO Warehouse (id, description, address)
VALUES (1, 'Number 1', '428-4574 Nec, Avenue');
INSERT INTO Warehouse (id, description, address)
VALUES (2, 'Number 2', 'P.O. Box 333, 8305 Risus. Road');
INSERT INTO Warehouse (id, description, address)
VALUES (3, 'Number 3', '926-7835 Non Ave');

COMMIT;



START TRANSACTION;
INSERT INTO Materials (id, description, peace_price, supplier_id, warehouse_id, available)
VALUES (1, 'birch', 600, 3, 1, 5);
INSERT INTO Materials (id, description, peace_price, supplier_id, warehouse_id, available)
VALUES (2, 'walnut', 500, 2, 1, 6);
INSERT INTO Materials (id, description, peace_price, supplier_id, warehouse_id, available)
VALUES (3, 'spruce', 550, 2, 2, 1);
INSERT INTO Materials (id, description, peace_price, supplier_id, warehouse_id, available)
VALUES (4, 'chestnut', 450, 5, 3, 2);
INSERT INTO Materials (id, description, peace_price, supplier_id, warehouse_id, available)
VALUES (5, 'cedar', 500, 1, 2, 0.5);
INSERT INTO Materials (id, description, peace_price, supplier_id, warehouse_id, available)
VALUES (6, 'maple', 550, 1, 3, 3);
INSERT INTO Materials (id, description, peace_price, supplier_id, warehouse_id, available)
VALUES (7, 'linden', 365, 5, 2, 1.25);
INSERT INTO Materials (id, description, peace_price, supplier_id, warehouse_id, available)
VALUES (8, 'hazel', 435, 4, 1, 0.6);

COMMIT;


START TRANSACTION;
INSERT INTO Clients (id, phone, first_name, last_name)
VALUES (1, '1-413-791-8613', 'Chastity', 'Goodwin');
INSERT INTO Clients (id, phone, first_name, last_name)
VALUES (2, '1-825-468-4196', 'Gretchen', 'Robbins');
INSERT INTO Clients (id, phone, first_name, last_name)
VALUES (3, '1-546-876-8819', 'Lenore', 'Britt');
INSERT INTO Clients (id, phone, first_name, last_name)
VALUES (4, '1-261-553-4884', 'Mallory', 'Richard');
INSERT INTO Clients (id, phone, first_name, last_name)
VALUES (5, '1-887-677-6638', 'Theodore', 'Hodge');

COMMIT;


START TRANSACTION;
INSERT INTO job_titles (id, description)
VALUES (1, 'carpenter');
INSERT INTO job_titles (id, description)
VALUES (2, 'painter');
INSERT INTO job_titles (id, description)
VALUES (3, 'handyman');
INSERT INTO job_titles (id, description)
VALUES (4, 'accountant');
INSERT INTO job_titles (id, description)
VALUES (5, 'security guard');
INSERT INTO job_titles (id, description)
VALUES (6, 'director');
INSERT INTO job_titles (id, description)
VALUES (7, 'deliveryman');

COMMIT;


START TRANSACTION;
INSERT INTO Manifactoring_facility (id, description)
VALUES (1, 'Manifactoring facility N1');
INSERT INTO Manifactoring_facility (id, description)
VALUES (2, 'Manifactoring facility N2');
INSERT INTO Manifactoring_facility (id, description)
VALUES (3, 'Manifactoring facility N3');

COMMIT;

START TRANSACTION;
INSERT INTO Employees (id, job_title_id, first_name, last_name, employment_date, dissmisal_date, salary, phone,
                       home_address, manifactoring_facility_id)
VALUES (1, 1, 'Julie', 'Banks', '2020-05-12', '2023-01-06', 700, '1-835-658-3946', '904 Montes, St', 1);
INSERT INTO Employees (id, job_title_id, first_name, last_name, employment_date, dissmisal_date, salary, phone,
                       home_address, manifactoring_facility_id)
VALUES (2, 2, 'Micah', 'Mcmillan', '2020-06-16', NULL, 700, '1-347-315-8714', 'Ap #658-7657 Proin Street', 2);
INSERT INTO Employees (id, job_title_id, first_name, last_name, employment_date, dissmisal_date, salary, phone,
                       home_address, manifactoring_facility_id)
VALUES (3, 2, 'Carlos', 'Wise', '2019-03-30', '2023-01-05', 700, '1-847-315-9334', 'Ap #121-8284 Eget Av.', 3);
INSERT INTO Employees (id, job_title_id, first_name, last_name, employment_date, dissmisal_date, salary, phone,
                       home_address, manifactoring_facility_id)
VALUES (4, 3, 'Jonah', 'Pena', '2015-12-30', '2021-11-23', 700, '1-117-555-4526', 'P.O. Box 103, 4662 Amet St.', 1);
INSERT INTO Employees (id, job_title_id, first_name, last_name, employment_date, dissmisal_date, salary, phone,
                       home_address, manifactoring_facility_id)
VALUES (5, 1, 'Drew', 'Collier', '2011-01-01', NULL, 800, '1-783-516-4445', 'P.O. Box 947, 4505 Imperdiet, Rd.', 2);
INSERT INTO Employees (id, job_title_id, first_name, last_name, employment_date, dissmisal_date, salary, phone,
                       home_address, manifactoring_facility_id)
VALUES (6, 3, 'Merritt', 'Carey', '2013-05-14', NULL, 800, '1-316-441-6102', '\"Ap #731-5626 Ipsum Road', 3);
INSERT INTO Employees (id, job_title_id, first_name, last_name, employment_date, dissmisal_date, salary, phone,
                       home_address, manifactoring_facility_id)
VALUES (7, 2, 'Elliott', 'Mullen', '2009-09-09', '2019-03-05', 700, '1-470-733-3498', 'Ap #731-5626 Ipsum Road', 1);
INSERT INTO Employees (id, job_title_id, first_name, last_name, employment_date, dissmisal_date, salary, phone,
                       home_address, manifactoring_facility_id)
VALUES (8, 1, 'Mira', 'Mathews', '2014-08-07', NULL, 750, '1-947-714-3334', 'P.O. Box 316, 637 Netus St', 2);
INSERT INTO Employees (id, job_title_id, first_name, last_name, employment_date, dissmisal_date, salary, phone,
                       home_address, manifactoring_facility_id)
VALUES (9, 4, 'Kirby', 'Mclean', '2016-04-25', NULL, 800, '1-847-875-5543', 'P.O. Box 645, 9199 Dolor St.', 3);
INSERT INTO Employees (id, job_title_id, first_name, last_name, employment_date, dissmisal_date, salary, phone,
                       home_address, manifactoring_facility_id)
VALUES (10, 5, 'Tiger', 'Mcintosh', '2018-06-03', NULL, 1000, '1-559-872-3059', '846-9809 Quis Avenue', 1);
INSERT INTO Employees (id, job_title_id, first_name, last_name, employment_date, dissmisal_date, salary, phone,
                       home_address, manifactoring_facility_id)
VALUES (11, 7, 'Noelle', 'Macias', '2013-06-14', '2022-01-06', 700, '1-981-167-3911', 'P.O. Box 581, 4918 Proin Street',
        2);
INSERT INTO Employees (id, job_title_id, first_name, last_name, employment_date, dissmisal_date, salary, phone,
                       home_address, manifactoring_facility_id)
VALUES (12, 7, 'Lacota', 'Chang', '2010-08-11', NULL, 700, '1-254-343-9454', 'P.O. Box 308, 3873 Ante St.', 3);
INSERT INTO Employees (id, job_title_id, first_name, last_name, employment_date, dissmisal_date, salary, phone,
                       home_address, manifactoring_facility_id)
VALUES (13, 6, 'Audra', 'Yang', '2016-12-11', NULL, 600, '1-497-817-6368', '212-9332 Luctus Street', 1);

COMMIT;


-- -----------------------------------------------------
-- Data for table ,Statuses,
-- -----------------------------------------------------
START TRANSACTION;
INSERT INTO Statuses (id, description)
VALUES (1, 'Created');
INSERT INTO Statuses (id, description)
VALUES (2, 'In progress');
INSERT INTO Statuses (id, description)
VALUES (3, 'Paused');
INSERT INTO Statuses (id, description)
VALUES (4, 'Canceled');
INSERT INTO Statuses (id, description)
VALUES (5, 'Completed');
INSERT INTO Statuses (id, description)
VALUES (6, 'Delivered');
INSERT INTO Statuses (id, description)
VALUES (7, 'Returned');

COMMIT;


START TRANSACTION;
INSERT INTO Orders (id, client_id, date_created, date_finished, delivery_address, paid, status_id,
                    deliveryman_employee_id)
VALUES (1, 2, '2023-01-06', '2023-02-01', 'P.O. Box 581, 4918 Proin Street', 1, 6, 11);
INSERT INTO Orders (id, client_id, date_created, date_finished, delivery_address, paid, status_id,
                    deliveryman_employee_id)
VALUES (2, 3, '2014-09-13', '2014-10-11', 'P.O. Box 308, 3873 Ante St.', 1, 6, 12);
INSERT INTO Orders (id, client_id, date_created, date_finished, delivery_address, paid, status_id,
                    deliveryman_employee_id)
VALUES (3, 1, '2016-09-01', '2016-09-03', '212-9332 Luctus Street', 0, 4, NULL);
INSERT INTO Orders (id, client_id, date_created, date_finished, delivery_address, paid, status_id,
                    deliveryman_employee_id)
VALUES (4, 4, '2015-01-05', '2015-02-12', '396-4717 Vitae, Rd.', 1, 6, 12);
INSERT INTO Orders (id, client_id, date_created, date_finished, delivery_address, paid, status_id,
                    deliveryman_employee_id)
VALUES (5, 5, '2023-01-20', '2023-02-20', '319-9284 Egestas St.', 1, 7, 12);
INSERT INTO Orders (id, client_id, date_created, date_finished, delivery_address, paid, status_id,
                    deliveryman_employee_id)
VALUES (6, 1, '2023-02-20', NULL, 'P.O. Box 702, 4617 Sem Ave', 0, 2, NULL);
INSERT INTO Orders (id, client_id, date_created, date_finished, delivery_address, paid, status_id,
                    deliveryman_employee_id)
VALUES (7, 2, '2022-11-12', NULL, 'Ap #361-3163 Tristique Rd.', 0, 3, NULL);

COMMIT;

START TRANSACTION;
INSERT INTO Products_materials_qty (id, product_id, material_id, material_cubic_meter_qty)
VALUES (1, 1, 6, 0.15);
INSERT INTO Products_materials_qty (id, product_id, material_id, material_cubic_meter_qty)
VALUES (2, 1, 2, 0.25);
INSERT INTO Products_materials_qty (id, product_id, material_id, material_cubic_meter_qty)
VALUES (3, 1, 4, 0.2);
INSERT INTO Products_materials_qty (id, product_id, material_id, material_cubic_meter_qty)
VALUES (4, 2, 1, 0.15);
INSERT INTO Products_materials_qty (id, product_id, material_id, material_cubic_meter_qty)
VALUES (5, 3, 6, 0.3);
INSERT INTO Products_materials_qty (id, product_id, material_id, material_cubic_meter_qty)
VALUES (6, 3, 8, 0.1);
INSERT INTO Products_materials_qty (id, product_id, material_id, material_cubic_meter_qty)
VALUES (7, 4, 3, 0.5);
INSERT INTO Products_materials_qty (id, product_id, material_id, material_cubic_meter_qty)
VALUES (8, 4, 6, 0.1);
INSERT INTO Products_materials_qty (id, product_id, material_id, material_cubic_meter_qty)
VALUES (9, 4, 5, 0.15);
INSERT INTO Products_materials_qty (id, product_id, material_id, material_cubic_meter_qty)
VALUES (10, 5, 7, 0.5);
INSERT INTO Products_materials_qty (id, product_id, material_id, material_cubic_meter_qty)
VALUES (11, 6, 2, 0.35);
INSERT INTO Products_materials_qty (id, product_id, material_id, material_cubic_meter_qty)
VALUES (12, 6, 1, 0.7);
INSERT INTO Products_materials_qty (id, product_id, material_id, material_cubic_meter_qty)
VALUES (13, 7, 6, 0.25);
INSERT INTO Products_materials_qty (id, product_id, material_id, material_cubic_meter_qty)
VALUES (14, 8, 3, 0.15);
INSERT INTO Products_materials_qty (id, product_id, material_id, material_cubic_meter_qty)
VALUES (15, 8, 5, 0.2);
INSERT INTO Products_materials_qty (id, product_id, material_id, material_cubic_meter_qty)
VALUES (16, 8, 4, 0.45);
INSERT INTO Products_materials_qty (id, product_id, material_id, material_cubic_meter_qty)
VALUES (17, 9, 2, 0.3);
INSERT INTO Products_materials_qty (id, product_id, material_id, material_cubic_meter_qty)
VALUES (18, 9, 8, 0.4);
INSERT INTO Products_materials_qty (id, product_id, material_id, material_cubic_meter_qty)
VALUES (19, 10, 1, 0.1);

COMMIT;

START TRANSACTION;
INSERT INTO Order_products (id, order_id, product_id, employee_id, warehouse_id)
VALUES (1, 1, 3, 4, 1);
INSERT INTO Order_products (id, order_id, product_id, employee_id, warehouse_id)
VALUES (2, 1, 4, 3, 1);
INSERT INTO Order_products (id, order_id, product_id, employee_id, warehouse_id)
VALUES (3, 1, 1, 1, 3);
INSERT INTO Order_products (id, order_id, product_id, employee_id, warehouse_id)
VALUES (4, 2, 6, 6, 2);
INSERT INTO Order_products (id, order_id, product_id, employee_id, warehouse_id)
VALUES (5, 2, 1, 3, 2);
INSERT INTO Order_products (id, order_id, product_id, employee_id, warehouse_id)
VALUES (6, 3, 6, 5, 3);
INSERT INTO Order_products (id, order_id, product_id, employee_id, warehouse_id)
VALUES (7, 4, 8, 7, 3);
INSERT INTO Order_products (id, order_id, product_id, employee_id, warehouse_id)
VALUES (8, 4, 1, 5, 2);
INSERT INTO Order_products (id, order_id, product_id, employee_id, warehouse_id)
VALUES (9, 5, 5, 4, 2);
INSERT INTO Order_products (id, order_id, product_id, employee_id, warehouse_id)
VALUES (10, 5, 2, 7, 3);

COMMIT;

START TRANSACTION;
INSERT INTO Equipment (id, description, expluatation_start, service_life_years, working_condition,
                       responsible_employee_id, manifactoring_facility_id)
VALUES (1, 'Electric drill', '2015-05-11', 10, 1, 1, 1);
INSERT INTO Equipment (id, description, expluatation_start, service_life_years, working_condition,
                       responsible_employee_id, manifactoring_facility_id)
VALUES (2, 'Circular saw', '2011-11-12', 10, 1, 2, 2);
INSERT INTO Equipment (id, description, expluatation_start, service_life_years, working_condition,
                       responsible_employee_id, manifactoring_facility_id)
VALUES (3, 'Soldering iron', '2013-07-19', 11, 1, 3, 3);
INSERT INTO Equipment (id, description, expluatation_start, service_life_years, working_condition,
                       responsible_employee_id, manifactoring_facility_id)
VALUES (4, 'Electric screwdriver', '2015-09-11', 5, 1, 4, 1);
INSERT INTO Equipment (id, description, expluatation_start, service_life_years, working_condition,
                       responsible_employee_id, manifactoring_facility_id)
VALUES (5, 'Chainsaw', '2011-03-03', 10, 1, 5, 2);
INSERT INTO Equipment (id, description, expluatation_start, service_life_years, working_condition,
                       responsible_employee_id, manifactoring_facility_id)
VALUES (6, 'Nail gun', '2012-04-16', 5, 1, 6, 3);
INSERT INTO Equipment (id, description, expluatation_start, service_life_years, working_condition,
                       responsible_employee_id, manifactoring_facility_id)
VALUES (7, 'Hammer', '2016-10-05', 12, 1, 7, 1);
INSERT INTO Equipment (id, description, expluatation_start, service_life_years, working_condition,
                       responsible_employee_id, manifactoring_facility_id)
VALUES (8, 'Hammer', '2013-01-14', 12, 0, 8, 2);
INSERT INTO Equipment (id, description, expluatation_start, service_life_years, working_condition,
                       responsible_employee_id, manifactoring_facility_id)
VALUES (9, 'Hammer', '2019-06-06', 12, 1, 1, 3);
INSERT INTO Equipment (id, description, expluatation_start, service_life_years, working_condition,
                       responsible_employee_id, manifactoring_facility_id)
VALUES (10, 'Screwdriver', '2020-11-19', 7, 1, 2, 1);
INSERT INTO Equipment (id, description, expluatation_start, service_life_years, working_condition,
                       responsible_employee_id, manifactoring_facility_id)
VALUES (11, 'Screwdriver', '2018-06-07', 7, 0, 3, 2);
INSERT INTO Equipment (id, description, expluatation_start, service_life_years, working_condition,
                       responsible_employee_id, manifactoring_facility_id)
VALUES (12, 'Screwdriver', '2017-08-22', 7, 1, 4, 3);
INSERT INTO Equipment (id, description, expluatation_start, service_life_years, working_condition,
                       responsible_employee_id, manifactoring_facility_id)
VALUES (13, 'Screwdriver', '2019-06-07', 7, 1, 5, 1);
INSERT INTO Equipment (id, description, expluatation_start, service_life_years, working_condition,
                       responsible_employee_id, manifactoring_facility_id)
VALUES (14, 'Saw', '2015-07-23', 3, 1, 6, 2);
INSERT INTO Equipment (id, description, expluatation_start, service_life_years, working_condition,
                       responsible_employee_id, manifactoring_facility_id)
VALUES (15, 'Saw', '2016-11-03', 3, 0, 7, 3);
INSERT INTO Equipment (id, description, expluatation_start, service_life_years, working_condition,
                       responsible_employee_id, manifactoring_facility_id)
VALUES (16, 'Chisel', '2017-04-17', 6, 1, 8, 1);
INSERT INTO Equipment (id, description, expluatation_start, service_life_years, working_condition,
                       responsible_employee_id, manifactoring_facility_id)
VALUES (17, 'Tape measure', '2016-05-31', 7, 0, 1, 2);
INSERT INTO Equipment (id, description, expluatation_start, service_life_years, working_condition,
                       responsible_employee_id, manifactoring_facility_id)
VALUES (18, 'Tape measure', '2017-01-06', 7, 1, 2, 3);
INSERT INTO Equipment (id, description, expluatation_start, service_life_years, working_condition,
                       responsible_employee_id, manifactoring_facility_id)
VALUES (19, 'Electric screwdriver', '2019-06-07', 10, 1, 3, 1);
INSERT INTO Equipment (id, description, expluatation_start, service_life_years, working_condition,
                       responsible_employee_id, manifactoring_facility_id)
VALUES (20, 'Nail gun', '2011-09-05', 7, 1, 4, 2);

COMMIT;



