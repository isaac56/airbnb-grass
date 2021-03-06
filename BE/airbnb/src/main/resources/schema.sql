-- MySQL Script generated by MySQL Workbench
-- Sun May 30 21:36:57 2021
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Table `user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `user` ;

CREATE TABLE IF NOT EXISTS `user` (
                                               `id` BIGINT NOT NULL AUTO_INCREMENT,
                                               `email` VARCHAR(45) NOT NULL,
    `nickname` VARCHAR(45) NOT NULL,
    `oauth_resource_server` VARCHAR(45) NULL,
    PRIMARY KEY (`id`),
    UNIQUE INDEX `email_UNIQUE` (`email` ASC))
    ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `detail_condition`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `detail_condition` ;

CREATE TABLE IF NOT EXISTS `detail_condition` (
                                                           `id` BIGINT NOT NULL AUTO_INCREMENT,
                                                           `room_type` VARCHAR(45) NOT NULL,
    `max_of_people` INT NOT NULL,
    `number_of_toilet` INT NOT NULL,
    `number_of_rooms` INT NULL,
    PRIMARY KEY (`id`))
    ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `accommodation_address`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `accommodation_address` ;

CREATE TABLE IF NOT EXISTS `accommodation_address` (
                                                                `id` BIGINT NOT NULL AUTO_INCREMENT,
                                                                `address_name` VARCHAR(200) NOT NULL,
    `road_address_name` VARCHAR(200) NOT NULL,
    `region1_depth_name` VARCHAR(45) NULL,
    `region2_depth_name` VARCHAR(45) NULL,
    `region3_depth_name` VARCHAR(45) NULL,
    `location` POINT NOT NULL,
    PRIMARY KEY (`id`),
    SPATIAL INDEX `location_spatial_index` (`location`),
    INDEX `region1_depth_name_index` USING BTREE (`region1_depth_name`),
    INDEX `region2_depth_name_index` USING BTREE (`region2_depth_name`),
    INDEX `region3_depth_name_index` USING BTREE (`region3_depth_name`))
    ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `accommodation`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `accommodation` ;

CREATE TABLE IF NOT EXISTS `accommodation` (
                                                        `id` BIGINT NOT NULL AUTO_INCREMENT,
                                                        `name` VARCHAR(45) NOT NULL,
    `basic_fee` INT NOT NULL,
    `weekend_fee` INT NULL,
    `cleaning_fee` INT NOT NULL DEFAULT 0,
    `title_image_url` VARCHAR(1000) NULL,
    `description` VARCHAR(4000) NOT NULL,
    `host_id` BIGINT NOT NULL,
    `detail_condition_id` BIGINT NOT NULL,
    `accommodation_address_id` BIGINT NOT NULL,
    PRIMARY KEY (`id`),
    INDEX `fk_accommodation_user1_idx` (`host_id` ASC),
    INDEX `fk_accommodation_detail_condition1_idx` (`detail_condition_id` ASC),
    INDEX `fk_accommodation_accommodation_address1_idx` (`accommodation_address_id` ASC),
    CONSTRAINT `fk_accommodation_user1`
    FOREIGN KEY (`host_id`)
    REFERENCES `user` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    CONSTRAINT `fk_accommodation_detail_condition1`
    FOREIGN KEY (`detail_condition_id`)
    REFERENCES `detail_condition` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    CONSTRAINT `fk_accommodation_accommodation_address1`
    FOREIGN KEY (`accommodation_address_id`)
    REFERENCES `accommodation_address` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
    ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `accommodation_image`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `accommodation_image` ;

CREATE TABLE IF NOT EXISTS `accommodation_image` (
                                                              `id` BIGINT NOT NULL AUTO_INCREMENT,
                                                              `accommodation_id` BIGINT NOT NULL,
                                                              `image_url` VARCHAR(1000) NULL,
    PRIMARY KEY (`id`),
    INDEX `fk_accomodation_image_accommodation1_idx` (`accommodation_id` ASC),
    CONSTRAINT `fk_accomodation_image_accommodation1`
    FOREIGN KEY (`accommodation_id`)
    REFERENCES `accommodation` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
    ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `accommodation_option`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `accommodation_option` ;

CREATE TABLE IF NOT EXISTS `accommodation_option` (
                                                               `id` BIGINT NOT NULL AUTO_INCREMENT,
                                                               `accommodation_id` BIGINT NOT NULL,
                                                               `name` VARCHAR(45) NOT NULL,
    PRIMARY KEY (`id`),
    INDEX `fk_accommodation_options_accommodation1_idx` (`accommodation_id` ASC),
    CONSTRAINT `fk_accommodation_options_accommodation1`
    FOREIGN KEY (`accommodation_id`)
    REFERENCES `accommodation` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
    ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `hash_tag`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `hash_tag` ;

CREATE TABLE IF NOT EXISTS `hash_tag` (
                                                   `id` BIGINT NOT NULL AUTO_INCREMENT,
                                                   `accommodation_id` BIGINT NOT NULL,
                                                   `name` VARCHAR(45) NOT NULL,
    PRIMARY KEY (`id`),
    INDEX `fk_hash_tag_accommodation1_idx` (`accommodation_id` ASC),
    CONSTRAINT `fk_hash_tag_accommodation1`
    FOREIGN KEY (`accommodation_id`)
    REFERENCES `accommodation` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
    ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `reservation`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `reservation` ;

CREATE TABLE IF NOT EXISTS `reservation` (
                                                      `id` BIGINT NOT NULL AUTO_INCREMENT,
                                                      `start_date` DATE NOT NULL,
                                                      `end_date` DATE NOT NULL,
                                                      `total_fee` INT NOT NULL,
                                                      `accommodation_id` BIGINT NOT NULL,
                                                      `user_id` BIGINT NOT NULL,
                                                      `created_time` DATETIME NOT NULL,
                                                      `deleted` TINYINT NOT NULL DEFAULT 0,
                                                      PRIMARY KEY (`id`),
    INDEX `fk_reservation_accommodation1_idx` (`accommodation_id` ASC),
    INDEX `fk_reservation_user1_idx` (`user_id` ASC),
    INDEX `start_end_idx` (`start_date` ASC, `end_date` ASC),
    CONSTRAINT `fk_reservation_accommodation1`
    FOREIGN KEY (`accommodation_id`)
    REFERENCES `accommodation` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    CONSTRAINT `fk_reservation_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `user` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
    ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `special_fee`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `special_fee` ;

CREATE TABLE IF NOT EXISTS `special_fee` (
                                                      `id` BIGINT NOT NULL AUTO_INCREMENT,
                                                      `start_date` DATE NOT NULL,
                                                      `end_date` DATE NOT NULL,
                                                      `basic_fee` INT NOT NULL,
                                                      `weekend_fee` INT NULL,
                                                      `accommodation_id` BIGINT NOT NULL,
                                                      PRIMARY KEY (`id`),
    INDEX `fk_special_fee_accommodation1_idx` (`accommodation_id` ASC),
    CONSTRAINT `fk_special_fee_accommodation1`
    FOREIGN KEY (`accommodation_id`)
    REFERENCES `accommodation` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
    ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `wish`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `wish` ;

CREATE TABLE IF NOT EXISTS `wish` (
                                               `id` BIGINT NOT NULL AUTO_INCREMENT,
                                               `accommodation_id` BIGINT NOT NULL,
                                               `user_id` BIGINT NOT NULL,
                                               `created_time` DATETIME NOT NULL,
                                               PRIMARY KEY (`id`),
    INDEX `fk_wish_accommodation1_idx` (`accommodation_id` ASC),
    INDEX `fk_wish_user1_idx` (`user_id` ASC),
    CONSTRAINT `fk_wish_accommodation1`
    FOREIGN KEY (`accommodation_id`)
    REFERENCES `accommodation` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    CONSTRAINT `fk_wish_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `user` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
    ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
