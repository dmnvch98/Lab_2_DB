-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`Products`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Products` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Products` (
                                                 `id` INT NOT NULL AUTO_INCREMENT,
                                                 `description` VARCHAR(45) NOT NULL,
    `price` INT NOT NULL,
    PRIMARY KEY (`id`, `description`))
    ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Suppliers`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Suppliers` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Suppliers` (
                                                  `id` INT NOT NULL AUTO_INCREMENT,
                                                  `description` VARCHAR(45) NOT NULL,
    `phone` VARCHAR(45) NOT NULL,
    `address` VARCHAR(45) NOT NULL,
    PRIMARY KEY (`id`))
    ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Warehouse`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Warehouse` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Warehouse` (
                                                  `id` INT NOT NULL AUTO_INCREMENT,
                                                  `description` VARCHAR(45) NOT NULL,
    `address` VARCHAR(45) NOT NULL,
    PRIMARY KEY (`id`))
    ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Materials`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Materials` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Materials` (
                                                  `id` INT NOT NULL AUTO_INCREMENT,
                                                  `description` VARCHAR(45) NOT NULL,
    `peace_price` INT NOT NULL,
    `supplier_id` INT NOT NULL,
    `warehouse_id` INT NOT NULL,
    `available` INT NOT NULL,
    PRIMARY KEY (`id`),
    INDEX `supplier_id_idx` (`supplier_id` ASC) VISIBLE,
    INDEX `s_warehouse_id_idx` (`warehouse_id` ASC) VISIBLE,
    CONSTRAINT `supplier_id`
    FOREIGN KEY (`supplier_id`)
    REFERENCES `mydb`.`Suppliers` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    CONSTRAINT `s_warehouse_id`
    FOREIGN KEY (`warehouse_id`)
    REFERENCES `mydb`.`Warehouse` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
    ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Clients`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Clients` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Clients` (
                                                `id` INT NOT NULL AUTO_INCREMENT,
                                                `phone` VARCHAR(45) NOT NULL,
    `first_name` VARCHAR(45) NOT NULL,
    `last_name` VARCHAR(45) NOT NULL,
    PRIMARY KEY (`id`))
    ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`job_titles`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`job_titles` ;

CREATE TABLE IF NOT EXISTS `mydb`.`job_titles` (
                                                   `id` INT NOT NULL AUTO_INCREMENT,
                                                   `description` VARCHAR(45) NOT NULL,
    PRIMARY KEY (`id`))
    ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Manifactoring_facility`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Manifactoring_facility` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Manifactoring_facility` (
                                                               `id` INT NOT NULL AUTO_INCREMENT,
                                                               `description` VARCHAR(45) NOT NULL,
    PRIMARY KEY (`id`))
    ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Employees`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Employees` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Employees` (
                                                  `id` INT NOT NULL AUTO_INCREMENT,
                                                  `job_title_id` INT NOT NULL,
                                                  `first_name` VARCHAR(45) NOT NULL,
    `last_name` VARCHAR(45) NOT NULL,
    `employment_date` DATETIME NOT NULL,
    `dissmisal_date` DATETIME NULL,
    `salary` INT NOT NULL,
    `phone` VARCHAR(45) NOT NULL,
    `home_address` VARCHAR(45) NOT NULL,
    `manifactoring_facility_id` INT NOT NULL,
    PRIMARY KEY (`id`),
    INDEX `job_description_id_idx` (`job_title_id` ASC) VISIBLE,
    INDEX `e_manifactoring_facility_id_idx` (`manifactoring_facility_id` ASC) VISIBLE,
    CONSTRAINT `emp_job_description_id`
    FOREIGN KEY (`job_title_id`)
    REFERENCES `mydb`.`job_titles` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    CONSTRAINT `emp_manifactoring_facility_id`
    FOREIGN KEY (`manifactoring_facility_id`)
    REFERENCES `mydb`.`Manifactoring_facility` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
    ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Statuses`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Statuses` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Statuses` (
                                                 `id` INT NOT NULL AUTO_INCREMENT,
                                                 `description` VARCHAR(45) NOT NULL,
    PRIMARY KEY (`id`))
    ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Orders`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Orders` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Orders` (
                                               `id` INT NOT NULL AUTO_INCREMENT,
                                               `client_id` INT NOT NULL,
                                               `date_created` DATETIME NOT NULL,
                                               `date_finished` DATETIME NULL,
                                               `delivery_address` VARCHAR(45) NULL,
    `paid` TINYINT NOT NULL,
    `status_id` INT NOT NULL,
    `deliveryman_employee_id` INT NULL,
    PRIMARY KEY (`id`),
    INDEX `client_id_idx` (`client_id` ASC) VISIBLE,
    INDEX `deliveryman_employee_id_idx` (`deliveryman_employee_id` ASC) VISIBLE,
    INDEX `status_id_idx` (`status_id` ASC) VISIBLE,
    CONSTRAINT `client_id`
    FOREIGN KEY (`client_id`)
    REFERENCES `mydb`.`Clients` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    CONSTRAINT `deliveryman_employee_id`
    FOREIGN KEY (`deliveryman_employee_id`)
    REFERENCES `mydb`.`Employees` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    CONSTRAINT `status_id`
    FOREIGN KEY (`status_id`)
    REFERENCES `mydb`.`Statuses` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
    ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Products_materials_qty`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Products_materials_qty` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Products_materials_qty` (
                                                               `id` INT NOT NULL AUTO_INCREMENT,
                                                               `product_id` INT NOT NULL,
                                                               `material_id` INT NOT NULL,
                                                               `material_cubic_meter_qty` FLOAT NOT NULL,
                                                               PRIMARY KEY (`id`),
    INDEX `product_id_idx` (`product_id` ASC) VISIBLE,
    INDEX `material_id_idx` (`material_id` ASC) VISIBLE,
    CONSTRAINT `product_id`
    FOREIGN KEY (`product_id`)
    REFERENCES `mydb`.`Products` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    CONSTRAINT `material_id`
    FOREIGN KEY (`material_id`)
    REFERENCES `mydb`.`Materials` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
    ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Order_products`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Order_products` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Order_products` (
                                                       `id` INT NOT NULL AUTO_INCREMENT,
                                                       `order_id` INT NOT NULL,
                                                       `product_id` INT NOT NULL,
                                                       `employee_id` INT NOT NULL,
                                                       `warehouse_id` INT NOT NULL,
                                                       PRIMARY KEY (`id`),
    INDEX `order_id_idx` (`order_id` ASC) VISIBLE,
    INDEX `product_id_idx` (`product_id` ASC) VISIBLE,
    INDEX `employee_id_idx` (`employee_id` ASC) VISIBLE,
    INDEX `op_warehouse_id_idx` (`warehouse_id` ASC) VISIBLE,
    CONSTRAINT `op_order_id`
    FOREIGN KEY (`order_id`)
    REFERENCES `mydb`.`Orders` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    CONSTRAINT `op_product_id`
    FOREIGN KEY (`product_id`)
    REFERENCES `mydb`.`Products` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    CONSTRAINT `op_employee_id`
    FOREIGN KEY (`employee_id`)
    REFERENCES `mydb`.`Employees` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    CONSTRAINT `op_warehouse_id`
    FOREIGN KEY (`warehouse_id`)
    REFERENCES `mydb`.`Warehouse` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
    ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`equipment`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`equipment` ;

CREATE TABLE IF NOT EXISTS `mydb`.`equipment` (
                                                  `id` INT NOT NULL AUTO_INCREMENT,
                                                  `description` VARCHAR(45) NOT NULL,
    `expluatation_start` DATETIME NOT NULL,
    `service_life_years` INT NOT NULL,
    `working_condition` TINYINT NOT NULL,
    `responsible_employee_id` INT NOT NULL,
    `manifactoring_facility_id` INT NOT NULL,
    PRIMARY KEY (`id`),
    INDEX `responsible_employee_id_idx` (`responsible_employee_id` ASC) VISIBLE,
    INDEX `e_manifactoring_facility_id_idx` (`manifactoring_facility_id` ASC) VISIBLE,
    CONSTRAINT `responsible_employee_id`
    FOREIGN KEY (`responsible_employee_id`)
    REFERENCES `mydb`.`Employees` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    CONSTRAINT `e_manifactoring_facility_id`
    FOREIGN KEY (`manifactoring_facility_id`)
    REFERENCES `mydb`.`Manifactoring_facility` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
    ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Stored function
-- -----------------------------------------------------

DELIMITER //
CREATE FUNCTION if_materials_available_for_order (product_id INT)
    RETURNS boolean DETERMINISTIC
BEGIN
    return exists (
            select pmq.material_cubic_meter_qty, m.description from materials m
                                                                        join products_materials_qty pmq on m.id = pmq.material_id
                                                                        join products p on pmq.product_id = p.id
            where p.id = product_id and m.available >= ALL
                                        (select material_cubic_meter_qty from products_materials_qty where product_id = product_id)
        );
END //
DELIMITER ;

-- -----------------------------------------------------
-- Trigger for Order_products
-- -----------------------------------------------------
# CREATE DEFINER=`root`@`localhost` TRIGGER `Order_products_BEFORE_INSERT` BEFORE INSERT ON `Order_products` FOR EACH ROW BEGIN
#     IF(if_materials_available_for_order(NEW.product_id) = 0)
#     THEN
#     SIGNAL SQLSTATE '45000'
# SET MESSAGE_TEXT = "not enough materials to complete the order";
# END IF;
# END;

delimiter //

CREATE DEFINER=`root`@`localhost` TRIGGER `Order_products_BEFORE_INSERT` BEFORE INSERT ON `Order_products` FOR EACH ROW
BEGIN
    IF(if_materials_available_for_order(NEW.product_id) = 0) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = "not enough materials to complete the order";
    END IF;
END //

delimiter ;


-- -----------------------------------------------------
-- Data for table `mydb`.`Products`
-- -----------------------------------------------------
START TRANSACTION;
USE `mydb`;
INSERT INTO `mydb`.`Products` (`id`, `description`, `price`) VALUES (1, 'Armchair', 100);
INSERT INTO `mydb`.`Products` (`id`, `description`, `price`) VALUES (2, 'Bookshelf', 150);
INSERT INTO `mydb`.`Products` (`id`, `description`, `price`) VALUES (3, 'Chair', 350);
INSERT INTO `mydb`.`Products` (`id`, `description`, `price`) VALUES (4, 'Coffee-table', 100);
INSERT INTO `mydb`.`Products` (`id`, `description`, `price`) VALUES (5, 'Cushion', 50);
INSERT INTO `mydb`.`Products` (`id`, `description`, `price`) VALUES (6, 'Floor lamp', 120);
INSERT INTO `mydb`.`Products` (`id`, `description`, `price`) VALUES (7, 'Hammock', 135);
INSERT INTO `mydb`.`Products` (`id`, `description`, `price`) VALUES (8, 'Rocking chair', 200);
INSERT INTO `mydb`.`Products` (`id`, `description`, `price`) VALUES (9, 'Sofa', 500);
INSERT INTO `mydb`.`Products` (`id`, `description`, `price`) VALUES (10, 'TV-set', 350);

COMMIT;


-- -----------------------------------------------------
-- Data for table `mydb`.`Suppliers`
-- -----------------------------------------------------
START TRANSACTION;
USE `mydb`;
INSERT INTO `mydb`.`Suppliers` (`id`, `description`, `phone`, `address`) VALUES (1, 'mollis', '1-548-790-5724', '8453 Commodo Ave');
INSERT INTO `mydb`.`Suppliers` (`id`, `description`, `phone`, `address`) VALUES (2, 'lacus', '1-248-448-1665', '6078 Magna, Ave');
INSERT INTO `mydb`.`Suppliers` (`id`, `description`, `phone`, `address`) VALUES (3, 'nibh', '1-573-295-7957', '194-8096 Imperdiet Avenue');
INSERT INTO `mydb`.`Suppliers` (`id`, `description`, `phone`, `address`) VALUES (4, 'non', '1-647-616-0598', 'Ap #962-7192 Nascetur Ave');
INSERT INTO `mydb`.`Suppliers` (`id`, `description`, `phone`, `address`) VALUES (5, 'parturient', '1-135-823-2951', 'Ap #497-9020 Dictum. Avenue');

COMMIT;


-- -----------------------------------------------------
-- Data for table `mydb`.`Warehouse`
-- -----------------------------------------------------
START TRANSACTION;
USE `mydb`;
INSERT INTO `mydb`.`Warehouse` (`id`, `description`, `address`) VALUES (1, 'Number 1', '428-4574 Nec, Avenue');
INSERT INTO `mydb`.`Warehouse` (`id`, `description`, `address`) VALUES (2, 'Number 2', 'P.O. Box 333, 8305 Risus. Road');
INSERT INTO `mydb`.`Warehouse` (`id`, `description`, `address`) VALUES (3, 'Number 3', '926-7835 Non Ave');

COMMIT;


-- -----------------------------------------------------
-- Data for table `mydb`.`Materials`
-- -----------------------------------------------------
START TRANSACTION;
USE `mydb`;
INSERT INTO `mydb`.`Materials` (`id`, `description`, `peace_price`, `supplier_id`, `warehouse_id`, `available`) VALUES (1, 'birch', 600, 3, 1, 5);
INSERT INTO `mydb`.`Materials` (`id`, `description`, `peace_price`, `supplier_id`, `warehouse_id`, `available`) VALUES (2, 'walnut', 500, 2, 1, 6);
INSERT INTO `mydb`.`Materials` (`id`, `description`, `peace_price`, `supplier_id`, `warehouse_id`, `available`) VALUES (3, 'spruce', 550, 2, 2, 1);
INSERT INTO `mydb`.`Materials` (`id`, `description`, `peace_price`, `supplier_id`, `warehouse_id`, `available`) VALUES (4, 'chestnut', 450, 5, 3, 2);
INSERT INTO `mydb`.`Materials` (`id`, `description`, `peace_price`, `supplier_id`, `warehouse_id`, `available`) VALUES (5, 'cedar', 500, 1, 2, 0.5);
INSERT INTO `mydb`.`Materials` (`id`, `description`, `peace_price`, `supplier_id`, `warehouse_id`, `available`) VALUES (6, 'maple', 550, 1, 3, 3);
INSERT INTO `mydb`.`Materials` (`id`, `description`, `peace_price`, `supplier_id`, `warehouse_id`, `available`) VALUES (7, 'linden', 365, 5, 2, 1.25);
INSERT INTO `mydb`.`Materials` (`id`, `description`, `peace_price`, `supplier_id`, `warehouse_id`, `available`) VALUES (8, 'hazel', 435, 4, 1, 0.6);

COMMIT;


-- -----------------------------------------------------
-- Data for table `mydb`.`Clients`
-- -----------------------------------------------------
START TRANSACTION;
USE `mydb`;
INSERT INTO `mydb`.`Clients` (`id`, `phone`, `first_name`, `last_name`) VALUES (1, '1-413-791-8613', 'Chastity', 'Goodwin');
INSERT INTO `mydb`.`Clients` (`id`, `phone`, `first_name`, `last_name`) VALUES (2, '1-825-468-4196', 'Gretchen', 'Robbins');
INSERT INTO `mydb`.`Clients` (`id`, `phone`, `first_name`, `last_name`) VALUES (3, '1-546-876-8819', 'Lenore', 'Britt');
INSERT INTO `mydb`.`Clients` (`id`, `phone`, `first_name`, `last_name`) VALUES (4, '1-261-553-4884', 'Mallory', 'Richard');
INSERT INTO `mydb`.`Clients` (`id`, `phone`, `first_name`, `last_name`) VALUES (5, '1-887-677-6638', 'Theodore', 'Hodge');

COMMIT;


-- -----------------------------------------------------
-- Data for table `mydb`.`job_titles`
-- -----------------------------------------------------
START TRANSACTION;
USE `mydb`;
INSERT INTO `mydb`.`job_titles` (`id`, `description`) VALUES (1, 'carpenter');
INSERT INTO `mydb`.`job_titles` (`id`, `description`) VALUES (2, 'painter');
INSERT INTO `mydb`.`job_titles` (`id`, `description`) VALUES (3, 'handyman');
INSERT INTO `mydb`.`job_titles` (`id`, `description`) VALUES (4, 'accountant');
INSERT INTO `mydb`.`job_titles` (`id`, `description`) VALUES (5, 'security guard');
INSERT INTO `mydb`.`job_titles` (`id`, `description`) VALUES (6, 'director');
INSERT INTO `mydb`.`job_titles` (`id`, `description`) VALUES (7, 'deliveryman');

COMMIT;


-- -----------------------------------------------------
-- Data for table `mydb`.`Manifactoring_facility`
-- -----------------------------------------------------
START TRANSACTION;
USE `mydb`;
INSERT INTO `mydb`.`Manifactoring_facility` (`id`, `description`) VALUES (1, 'Manifactoring facility N1');
INSERT INTO `mydb`.`Manifactoring_facility` (`id`, `description`) VALUES (2, 'Manifactoring facility N2');
INSERT INTO `mydb`.`Manifactoring_facility` (`id`, `description`) VALUES (3, 'Manifactoring facility N3');

COMMIT;


-- -----------------------------------------------------
-- Data for table `mydb`.`Employees`
-- -----------------------------------------------------
START TRANSACTION;
USE `mydb`;
INSERT INTO `mydb`.`Employees` (`id`, `job_title_id`, `first_name`, `last_name`, `employment_date`, `dissmisal_date`, `salary`, `phone`, `home_address`, `manifactoring_facility_id`) VALUES (1, 1, 'Julie', 'Banks', '2020-05-12', '2023-01-06', 700, '1-835-658-3946', '904 Montes, St', 1);
INSERT INTO `mydb`.`Employees` (`id`, `job_title_id`, `first_name`, `last_name`, `employment_date`, `dissmisal_date`, `salary`, `phone`, `home_address`, `manifactoring_facility_id`) VALUES (2, 2, 'Micah', 'Mcmillan', '2020-06-16', NULL, 700, '1-347-315-8714', 'Ap #658-7657 Proin Street', 2);
INSERT INTO `mydb`.`Employees` (`id`, `job_title_id`, `first_name`, `last_name`, `employment_date`, `dissmisal_date`, `salary`, `phone`, `home_address`, `manifactoring_facility_id`) VALUES (3, 2, 'Carlos', 'Wise', '2019-03-30', '2023-01-05', 700, '1-847-315-9334', 'Ap #121-8284 Eget Av.', 3);
INSERT INTO `mydb`.`Employees` (`id`, `job_title_id`, `first_name`, `last_name`, `employment_date`, `dissmisal_date`, `salary`, `phone`, `home_address`, `manifactoring_facility_id`) VALUES (4, 3, 'Jonah', 'Pena', '2015-12-30', '2021-11-23', 700, '1-117-555-4526', 'P.O. Box 103, 4662 Amet St.', 1);
INSERT INTO `mydb`.`Employees` (`id`, `job_title_id`, `first_name`, `last_name`, `employment_date`, `dissmisal_date`, `salary`, `phone`, `home_address`, `manifactoring_facility_id`) VALUES (5, 1, 'Drew', 'Collier', '2011-01-01', NULL, 800, '1-783-516-4445', 'P.O. Box 947, 4505 Imperdiet, Rd.', 2);
INSERT INTO `mydb`.`Employees` (`id`, `job_title_id`, `first_name`, `last_name`, `employment_date`, `dissmisal_date`, `salary`, `phone`, `home_address`, `manifactoring_facility_id`) VALUES (6, 3, 'Merritt', 'Carey', '2013-05-14', NULL, 800, '1-316-441-6102', '\"Ap #731-5626 Ipsum Road', 3);
INSERT INTO `mydb`.`Employees` (`id`, `job_title_id`, `first_name`, `last_name`, `employment_date`, `dissmisal_date`, `salary`, `phone`, `home_address`, `manifactoring_facility_id`) VALUES (7, 2, 'Elliott', 'Mullen', '2009-09-09', '2019-03-05', 700, '1-470-733-3498', 'Ap #731-5626 Ipsum Road', 1);
INSERT INTO `mydb`.`Employees` (`id`, `job_title_id`, `first_name`, `last_name`, `employment_date`, `dissmisal_date`, `salary`, `phone`, `home_address`, `manifactoring_facility_id`) VALUES (8, 1, 'Mira', 'Mathews', '2014-08-07', NULL, 750, '1-947-714-3334', 'P.O. Box 316, 637 Netus St', 2);
INSERT INTO `mydb`.`Employees` (`id`, `job_title_id`, `first_name`, `last_name`, `employment_date`, `dissmisal_date`, `salary`, `phone`, `home_address`, `manifactoring_facility_id`) VALUES (9, 4, 'Kirby', 'Mclean', '2016-04-25', NULL, 800, '1-847-875-5543', 'P.O. Box 645, 9199 Dolor St.', 3);
INSERT INTO `mydb`.`Employees` (`id`, `job_title_id`, `first_name`, `last_name`, `employment_date`, `dissmisal_date`, `salary`, `phone`, `home_address`, `manifactoring_facility_id`) VALUES (10, 5, 'Tiger', 'Mcintosh', '2018-06-03', NULL, 1000, '1-559-872-3059', '846-9809 Quis Avenue', 1);
INSERT INTO `mydb`.`Employees` (`id`, `job_title_id`, `first_name`, `last_name`, `employment_date`, `dissmisal_date`, `salary`, `phone`, `home_address`, `manifactoring_facility_id`) VALUES (11, 7, 'Noelle', 'Macias', '2013-06-14', '2022-01-06', 700, '1-981-167-3911', 'P.O. Box 581, 4918 Proin Street', 2);
INSERT INTO `mydb`.`Employees` (`id`, `job_title_id`, `first_name`, `last_name`, `employment_date`, `dissmisal_date`, `salary`, `phone`, `home_address`, `manifactoring_facility_id`) VALUES (12, 7, 'Lacota', 'Chang', '2010-08-11', NULL, 700, '1-254-343-9454', 'P.O. Box 308, 3873 Ante St.', 3);
INSERT INTO `mydb`.`Employees` (`id`, `job_title_id`, `first_name`, `last_name`, `employment_date`, `dissmisal_date`, `salary`, `phone`, `home_address`, `manifactoring_facility_id`) VALUES (13, 6, 'Audra', 'Yang', '2016-12-11', NULL, 600, '1-497-817-6368', '212-9332 Luctus Street', 1);

COMMIT;


-- -----------------------------------------------------
-- Data for table `mydb`.`Statuses`
-- -----------------------------------------------------
START TRANSACTION;
USE `mydb`;
INSERT INTO `mydb`.`Statuses` (`id`, `description`) VALUES (1, 'Created');
INSERT INTO `mydb`.`Statuses` (`id`, `description`) VALUES (2, 'In progress');
INSERT INTO `mydb`.`Statuses` (`id`, `description`) VALUES (3, 'Paused');
INSERT INTO `mydb`.`Statuses` (`id`, `description`) VALUES (4, 'Canceled');
INSERT INTO `mydb`.`Statuses` (`id`, `description`) VALUES (5, 'Completed');
INSERT INTO `mydb`.`Statuses` (`id`, `description`) VALUES (6, 'Delivered');
INSERT INTO `mydb`.`Statuses` (`id`, `description`) VALUES (7, 'Returned');

COMMIT;


-- -----------------------------------------------------
-- Data for table `mydb`.`Orders`
-- -----------------------------------------------------
START TRANSACTION;
USE `mydb`;
INSERT INTO `mydb`.`Orders` (`id`, `client_id`, `date_created`, `date_finished`, `delivery_address`, `paid`, `status_id`, `deliveryman_employee_id`) VALUES (1, 2, '2023-01-06', '2023-02-01', 'P.O. Box 581, 4918 Proin Street', 1, 6, 11);
INSERT INTO `mydb`.`Orders` (`id`, `client_id`, `date_created`, `date_finished`, `delivery_address`, `paid`, `status_id`, `deliveryman_employee_id`) VALUES (2, 3, '2014-09-13', '2014-10-11', 'P.O. Box 308, 3873 Ante St.', 1, 6, 12);
INSERT INTO `mydb`.`Orders` (`id`, `client_id`, `date_created`, `date_finished`, `delivery_address`, `paid`, `status_id`, `deliveryman_employee_id`) VALUES (3, 1, '2016-09-01', '2016-09-03', '212-9332 Luctus Street', 0, 4, NULL);
INSERT INTO `mydb`.`Orders` (`id`, `client_id`, `date_created`, `date_finished`, `delivery_address`, `paid`, `status_id`, `deliveryman_employee_id`) VALUES (4, 4, '2015-01-05', '2015-02-12', '396-4717 Vitae, Rd.', 1, 6, 12);
INSERT INTO `mydb`.`Orders` (`id`, `client_id`, `date_created`, `date_finished`, `delivery_address`, `paid`, `status_id`, `deliveryman_employee_id`) VALUES (5, 5, '2023-01-20', '2023-02-20', '319-9284 Egestas St.', 1, 7, 12);
INSERT INTO `mydb`.`Orders` (`id`, `client_id`, `date_created`, `date_finished`, `delivery_address`, `paid`, `status_id`, `deliveryman_employee_id`) VALUES (6, 1, '2023-02-20', NULL, 'P.O. Box 702, 4617 Sem Ave', 0, 2, NULL);
INSERT INTO `mydb`.`Orders` (`id`, `client_id`, `date_created`, `date_finished`, `delivery_address`, `paid`, `status_id`, `deliveryman_employee_id`) VALUES (7, 2, '2022-11-12', NULL, 'Ap #361-3163 Tristique Rd.', 0, 3, NULL);

COMMIT;


-- -----------------------------------------------------
-- Data for table `mydb`.`Products_materials_qty`
-- -----------------------------------------------------
START TRANSACTION;
USE `mydb`;
INSERT INTO `mydb`.`Products_materials_qty` (`id`, `product_id`, `material_id`, `material_cubic_meter_qty`) VALUES (1, 1, 6, 0.15);
INSERT INTO `mydb`.`Products_materials_qty` (`id`, `product_id`, `material_id`, `material_cubic_meter_qty`) VALUES (2, 1, 2, 0.25);
INSERT INTO `mydb`.`Products_materials_qty` (`id`, `product_id`, `material_id`, `material_cubic_meter_qty`) VALUES (3, 1, 4, 0.2);
INSERT INTO `mydb`.`Products_materials_qty` (`id`, `product_id`, `material_id`, `material_cubic_meter_qty`) VALUES (4, 2, 1, 0.15);
INSERT INTO `mydb`.`Products_materials_qty` (`id`, `product_id`, `material_id`, `material_cubic_meter_qty`) VALUES (5, 3, 6, 0.3);
INSERT INTO `mydb`.`Products_materials_qty` (`id`, `product_id`, `material_id`, `material_cubic_meter_qty`) VALUES (6, 3, 8, 0.1);
INSERT INTO `mydb`.`Products_materials_qty` (`id`, `product_id`, `material_id`, `material_cubic_meter_qty`) VALUES (7, 4, 3, 0.5);
INSERT INTO `mydb`.`Products_materials_qty` (`id`, `product_id`, `material_id`, `material_cubic_meter_qty`) VALUES (8, 4, 6, 0.1);
INSERT INTO `mydb`.`Products_materials_qty` (`id`, `product_id`, `material_id`, `material_cubic_meter_qty`) VALUES (9, 4, 5, 0.15);
INSERT INTO `mydb`.`Products_materials_qty` (`id`, `product_id`, `material_id`, `material_cubic_meter_qty`) VALUES (10, 5, 7, 0.5);
INSERT INTO `mydb`.`Products_materials_qty` (`id`, `product_id`, `material_id`, `material_cubic_meter_qty`) VALUES (11, 6, 2, 0.35);
INSERT INTO `mydb`.`Products_materials_qty` (`id`, `product_id`, `material_id`, `material_cubic_meter_qty`) VALUES (12, 6, 1, 0.7);
INSERT INTO `mydb`.`Products_materials_qty` (`id`, `product_id`, `material_id`, `material_cubic_meter_qty`) VALUES (13, 7, 6, 0.25);
INSERT INTO `mydb`.`Products_materials_qty` (`id`, `product_id`, `material_id`, `material_cubic_meter_qty`) VALUES (14, 8, 3, 0.15);
INSERT INTO `mydb`.`Products_materials_qty` (`id`, `product_id`, `material_id`, `material_cubic_meter_qty`) VALUES (15, 8, 5, 0.2);
INSERT INTO `mydb`.`Products_materials_qty` (`id`, `product_id`, `material_id`, `material_cubic_meter_qty`) VALUES (16, 8, 4, 0.45);
INSERT INTO `mydb`.`Products_materials_qty` (`id`, `product_id`, `material_id`, `material_cubic_meter_qty`) VALUES (17, 9, 2, 0.3);
INSERT INTO `mydb`.`Products_materials_qty` (`id`, `product_id`, `material_id`, `material_cubic_meter_qty`) VALUES (18, 9, 8, 0.4);
INSERT INTO `mydb`.`Products_materials_qty` (`id`, `product_id`, `material_id`, `material_cubic_meter_qty`) VALUES (19, 10, 1, 0.1);

COMMIT;


-- -----------------------------------------------------
-- Data for table `mydb`.`Order_products`
-- -----------------------------------------------------

START TRANSACTION;
USE `mydb`;
INSERT INTO `mydb`.`Order_products` (`id`, `order_id`, `product_id`, `employee_id`, `warehouse_id`) VALUES (1, 1, 3, 4, 1);
INSERT INTO `mydb`.`Order_products` (`id`, `order_id`, `product_id`, `employee_id`, `warehouse_id`) VALUES (2, 1, 4, 3, 1);
INSERT INTO `mydb`.`Order_products` (`id`, `order_id`, `product_id`, `employee_id`, `warehouse_id`) VALUES (3, 1, 1, 1, 3);
INSERT INTO `mydb`.`Order_products` (`id`, `order_id`, `product_id`, `employee_id`, `warehouse_id`) VALUES (4, 2, 6, 6, 2);
INSERT INTO `mydb`.`Order_products` (`id`, `order_id`, `product_id`, `employee_id`, `warehouse_id`) VALUES (5, 2, 1, 3, 2);
INSERT INTO `mydb`.`Order_products` (`id`, `order_id`, `product_id`, `employee_id`, `warehouse_id`) VALUES (6, 3, 6, 5, 3);
INSERT INTO `mydb`.`Order_products` (`id`, `order_id`, `product_id`, `employee_id`, `warehouse_id`) VALUES (7, 4, 8, 7, 3);
INSERT INTO `mydb`.`Order_products` (`id`, `order_id`, `product_id`, `employee_id`, `warehouse_id`) VALUES (8, 4, 1, 5, 2);
INSERT INTO `mydb`.`Order_products` (`id`, `order_id`, `product_id`, `employee_id`, `warehouse_id`) VALUES (9, 5, 5, 4, 2);
INSERT INTO `mydb`.`Order_products` (`id`, `order_id`, `product_id`, `employee_id`, `warehouse_id`) VALUES (10, 5, 2, 7, 3);

COMMIT;

-- -----------------------------------------------------
-- Data for table `mydb`.`equipment`
-- -----------------------------------------------------
START TRANSACTION;
USE `mydb`;
INSERT INTO `mydb`.`equipment` (`id`, `description`, `expluatation_start`, `service_life_years`, `working_condition`, `responsible_employee_id`, `manifactoring_facility_id`) VALUES (1, 'Electric drill', '2015-05-11', 10, 1, 1, 1);
INSERT INTO `mydb`.`equipment` (`id`, `description`, `expluatation_start`, `service_life_years`, `working_condition`, `responsible_employee_id`, `manifactoring_facility_id`) VALUES (2, 'Circular saw', '2011-11-12', 10, 1, 2, 2);
INSERT INTO `mydb`.`equipment` (`id`, `description`, `expluatation_start`, `service_life_years`, `working_condition`, `responsible_employee_id`, `manifactoring_facility_id`) VALUES (3, 'Soldering iron', '2013-07-19', 11, 1, 3, 3);
INSERT INTO `mydb`.`equipment` (`id`, `description`, `expluatation_start`, `service_life_years`, `working_condition`, `responsible_employee_id`, `manifactoring_facility_id`) VALUES (4, 'Electric screwdriver', '2015-09-11', 5, 1, 4, 1);
INSERT INTO `mydb`.`equipment` (`id`, `description`, `expluatation_start`, `service_life_years`, `working_condition`, `responsible_employee_id`, `manifactoring_facility_id`) VALUES (5, 'Chainsaw', '2011-03-03', 10, 1, 5, 2);
INSERT INTO `mydb`.`equipment` (`id`, `description`, `expluatation_start`, `service_life_years`, `working_condition`, `responsible_employee_id`, `manifactoring_facility_id`) VALUES (6, 'Nail gun', '2012-04-16', 5, 1, 6, 3);
INSERT INTO `mydb`.`equipment` (`id`, `description`, `expluatation_start`, `service_life_years`, `working_condition`, `responsible_employee_id`, `manifactoring_facility_id`) VALUES (7, 'Hammer', '2016-10-05', 12, 1, 7, 1);
INSERT INTO `mydb`.`equipment` (`id`, `description`, `expluatation_start`, `service_life_years`, `working_condition`, `responsible_employee_id`, `manifactoring_facility_id`) VALUES (8, 'Hammer', '2013-01-14', 12, 0, 8, 2);
INSERT INTO `mydb`.`equipment` (`id`, `description`, `expluatation_start`, `service_life_years`, `working_condition`, `responsible_employee_id`, `manifactoring_facility_id`) VALUES (9, 'Hammer', '2019-06-06', 12, 1, 1, 3);
INSERT INTO `mydb`.`equipment` (`id`, `description`, `expluatation_start`, `service_life_years`, `working_condition`, `responsible_employee_id`, `manifactoring_facility_id`) VALUES (10, 'Screwdriver', '2020-11-19', 7, 1, 2, 1);
INSERT INTO `mydb`.`equipment` (`id`, `description`, `expluatation_start`, `service_life_years`, `working_condition`, `responsible_employee_id`, `manifactoring_facility_id`) VALUES (11, 'Screwdriver', '2018-06-07', 7, 0, 3, 2);
INSERT INTO `mydb`.`equipment` (`id`, `description`, `expluatation_start`, `service_life_years`, `working_condition`, `responsible_employee_id`, `manifactoring_facility_id`) VALUES (12, 'Screwdriver', '2017-08-22', 7, 1, 4, 3);
INSERT INTO `mydb`.`equipment` (`id`, `description`, `expluatation_start`, `service_life_years`, `working_condition`, `responsible_employee_id`, `manifactoring_facility_id`) VALUES (13, 'Screwdriver', '2019-06-07', 7, 1, 5, 1);
INSERT INTO `mydb`.`equipment` (`id`, `description`, `expluatation_start`, `service_life_years`, `working_condition`, `responsible_employee_id`, `manifactoring_facility_id`) VALUES (14, 'Saw', '2015-07-23', 3, 1, 6, 2);
INSERT INTO `mydb`.`equipment` (`id`, `description`, `expluatation_start`, `service_life_years`, `working_condition`, `responsible_employee_id`, `manifactoring_facility_id`) VALUES (15, 'Saw', '2016-11-03', 3, 0, 7, 3);
INSERT INTO `mydb`.`equipment` (`id`, `description`, `expluatation_start`, `service_life_years`, `working_condition`, `responsible_employee_id`, `manifactoring_facility_id`) VALUES (16, 'Chisel', '2017-04-17', 6, 1, 8, 1);
INSERT INTO `mydb`.`equipment` (`id`, `description`, `expluatation_start`, `service_life_years`, `working_condition`, `responsible_employee_id`, `manifactoring_facility_id`) VALUES (17, 'Tape measure', '2016-05-31', 7, 0, 1, 2);
INSERT INTO `mydb`.`equipment` (`id`, `description`, `expluatation_start`, `service_life_years`, `working_condition`, `responsible_employee_id`, `manifactoring_facility_id`) VALUES (18, 'Tape measure', '2017-01-06', 7, 1, 2, 3);
INSERT INTO `mydb`.`equipment` (`id`, `description`, `expluatation_start`, `service_life_years`, `working_condition`, `responsible_employee_id`, `manifactoring_facility_id`) VALUES (19, 'Electric screwdriver', '2019-06-07', 10, 1, 3, 1);
INSERT INTO `mydb`.`equipment` (`id`, `description`, `expluatation_start`, `service_life_years`, `working_condition`, `responsible_employee_id`, `manifactoring_facility_id`) VALUES (20, 'Nail gun', '2011-09-05', 7, 1, 4, 2);

COMMIT;

