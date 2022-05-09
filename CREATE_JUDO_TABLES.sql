-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';


-- -----------------------------------------------------
-- Schema JUDO
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `JUDO`;
USE `JUDO` ;

-- -----------------------------------------------------
-- Table `JUDO`.`judge`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `JUDO`.`judge` (
  `id` INT NOT NULL,
  `name` VARCHAR(30) NULL DEFAULT NULL,
  `battle count` INT NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `JUDO`.`categorys`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `JUDO`.`categorys` (
  `id` VARCHAR(3) NOT NULL,
  `gender` VARCHAR(1) NULL DEFAULT NULL,
  `weight category` ENUM('light', 'heavy') NULL DEFAULT NULL,
  `age range` ENUM('young', 'old') NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `JUDO`.`coaches`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `JUDO`.`coaches` (
  `id` INT NOT NULL,
  `years exp` INT NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `JUDO`.`teams`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `JUDO`.`teams` (
  `name` VARCHAR(15) NOT NULL,
  `win count` INT(10) NULL DEFAULT 0,
  PRIMARY KEY (`name`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `JUDO`.`teammates`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `JUDO`.`teammates` (
  `name` VARCHAR(25) NOT NULL,
  `team` VARCHAR(15) NOT NULL,
  `id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_teammates_teams1_idx` (`team` ASC) VISIBLE,
  CONSTRAINT `fk_teammates_teams1`
    FOREIGN KEY (`team`)
    REFERENCES `JUDO`.`teams` (`name`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `JUDO`.`judokas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `JUDO`.`judokas` (
  `id` INT NOT NULL,
  `weight` INT NOT NULL,
  `gender` VARCHAR(1) NOT NULL,
  `coach id` INT NOT NULL,
  `age` INT NOT NULL,
  `category` VARCHAR(3) NOT NULL,
  `is injured` BIT   NOT NULL,
  `wins` INT(10) UNSIGNED ZEROFILL NULL DEFAULT NULL,
  `game played` INT(10) UNSIGNED ZEROFILL NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_judokas_coach1_idx` (`coach id` ASC) VISIBLE,
  INDEX `fk_judokas_category1_idx` (`category` ASC) VISIBLE,
  CONSTRAINT `fk_judokas_category1`
    FOREIGN KEY (`category`)
    REFERENCES `JUDO`.`categorys` (`id`),
  CONSTRAINT `fk_judokas_coach1`
    FOREIGN KEY (`coach id`)
    REFERENCES `JUDO`.`coaches` (`id`),
  CONSTRAINT `fk_judokas_teammates`
    FOREIGN KEY (`id`)
    REFERENCES `JUDO`.`teammates` (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `JUDO`.`battles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `JUDO`.`battles` (
  `id` INT NOT NULL,
  `judoka 1 id` INT NOT NULL,
  `juduka 2 id` INT NOT NULL,
  `time` DATETIME NULL DEFAULT NULL,
  `judge_id` INT NOT NULL,
  `category` VARCHAR(3) NOT NULL,
  PRIMARY KEY (`id`, `judge_id`),
  INDEX `fk_battles_judge1_idx` (`judge_id` ASC) VISIBLE,
  CONSTRAINT `fk_battles_judge1`
    FOREIGN KEY (`judge_id`)
    REFERENCES `JUDO`.`judge` (`id`),
  CONSTRAINT `fk_battles_judokas1`
    FOREIGN KEY (`judoka 1 id`)
    REFERENCES `JUDO`.`judokas` (`id`),
  CONSTRAINT `fk_battles_judokas2`
    FOREIGN KEY (`juduka 2 id`)
    REFERENCES `JUDO`.`judokas` (`id`),
     CONSTRAINT `FK_category`
    FOREIGN KEY (`category`)
    REFERENCES `JUDO`.`categorys` (`id`)
    )
    
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `JUDO`.`battle results`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `JUDO`.`battle results` (
  `id` INT NOT NULL,
  `judoka 1 points` INT(10) NULL DEFAULT NULL,
  `judoka 2 points` INT(10) NULL DEFAULT NULL,
  `winner` INT NULL DEFAULT NULL,
  `win type` ENUM('waza-ari', 'ippon') NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_battle results_battles1_idx` (`id` ASC) VISIBLE,
  INDEX `fk_battle results_judokas1_idx` (`winner` ASC) VISIBLE,
  CONSTRAINT `fk_battle results_battles1`
    FOREIGN KEY (`id`)
    REFERENCES `JUDO`.`battles` (`id`),
  CONSTRAINT `fk_battle results_judokas1`
    FOREIGN KEY (`winner`)
    REFERENCES `JUDO`.`judokas` (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `JUDO`.`fouls`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `JUDO`.`fouls` (
  `id` INT NOT NULL,
  `foul type` ENUM('hard', 'soft') NULL DEFAULT NULL,
  `judokas_id` INT NOT NULL,
  PRIMARY KEY (`id`, `judokas_id`),
  INDEX `fk_fouls_judokas1_idx` (`judokas_id` ASC) VISIBLE,
  CONSTRAINT `fk_fouls_judokas1`
    FOREIGN KEY (`judokas_id`)
    REFERENCES `JUDO`.`judokas` (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `JUDO`.`sponsers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `JUDO`.`sponsers` (
  `id` INT NOT NULL,
  `name` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `JUDO`.`teams_has_sponsers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `JUDO`.`teams_has_sponsers` (
  `teams_name` VARCHAR(15) NOT NULL,
  `sponsers_id` INT NOT NULL,
  `money_contribute` INT,
  PRIMARY KEY (`teams_name`, `sponsers_id`),
  INDEX `fk_teams_has_sponsers_sponsers1_idx` (`sponsers_id` ASC) VISIBLE,
  INDEX `fk_teams_has_sponsers_teams1_idx` (`teams_name` ASC) VISIBLE,
  CONSTRAINT `fk_teams_has_sponsers_sponsers1`
    FOREIGN KEY (`sponsers_id`)
    REFERENCES `JUDO`.`sponsers` (`id`),
  CONSTRAINT `fk_teams_has_sponsers_teams1`
    FOREIGN KEY (`teams_name`)
    REFERENCES `JUDO`.`teams` (`name`))
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

delimiter $$

create TRIGGER trigger_j1 after insert 
on JUDO.battles
for each row begin
update judo.judokas
set `game played` =`game played`+1
where new.`judoka 1 id`=judokas.id;

end$$
delimiter $$

create TRIGGER trigger_j2 after insert 
on JUDO.battles
for each row begin
update judo.judokas
set `game played` =`game played`+1
where new.`judoka 1 id`=judokas.id;

end$$
delimiter $$

create TRIGGER trigger_win after insert 
on JUDO.`battle results`
for each row begin
update judo.judokas
set `wins` =`wins`+1
where new.winner=judokas.id;

end$$
delimiter ;

USE JUDO;

INSERT INTO JUDO.categorys (id,gender,`weight category`,`age range`)
VALUES('MLY', 'M', 'light', 'young'),
('MHY', 'M', 'heavy', 'young'),
('FLY', 'F', 'light', 'young'),
('FHY', 'F', 'heavy', 'young'),
('MLO', 'M', 'light', 'old'),
('MHO', 'M', 'heavy', 'old'),
('FLO', 'F', 'light', 'old'),
('FHO', 'F', 'heavy', 'old');

INSERT INTO JUDO.sponsers(id,name)
VALUES 
(1,'NIKE'),
(2,'PUMA'),
(3,'ADIDAS'),
(5,'HIKE');

INSERT INTO JUDO.teams (name,`win count`)
VALUES ('Israel',NULL),
('Germany',NULL),
('Italy',NULL),
('Lapid',NULL),
('Brazil',NULL),
('USA',NULL),
('Australia',NULL);

INSERT INTO JUDO.teams_has_sponsers(teams_name,sponsers_id,money_contribute)
VALUES 
('Israel',2,1000),
('Germany',1,5000),
('Brazil',5,2000),
('Italy',5,10000),
('Lapid',3,1000);


INSERT INTO JUDO.teammates(name,team,id)
VALUES 
('Gabi','ISRAEL',1),#JUDOKA
('Ella','ISRAEL',2),#JUDOKA
('Dobby','ISRAEL',3),#COACH
('Bar','Brazil',4),#JUDOKA
('Roni','Brazil',5),#JUDOKA
('Galya','Brazil',6),#COACH
('Tomer','Germany',7),#JUDOKA
('Sergio','Germany',8),#JUDOKA
('Paul','Germany',9),#COACH
('Rodrigo','Italy',10),#JUDOKA
('Dudu','Italy',11),#JUDOKA
('Noam','Italy',12),#COACH
('Timur','Lapid',13),#JUDOKA
('Ben','Lapid',14),#JUDOKA
('Aflek','Lapid',15),#COACH
('Pumba','USA',16),#JUDOKA
('Sanji','USA',17),#JUDOKA
('Zoro','USA',18),#COACH
('Luffy','Australia',19),#JUDOKA
('Nami','Australia',20),#JUDOKA
('Oumar','Australia',21);#COACH


INSERT INTO JUDO.coaches(id,`years exp`)
VALUES (3,7),(6,2),(9,10),(12,12),(15,3),(18,1),(21,10);


INSERT INTO JUDO.judokas(id,weight,gender,`coach id`,age,category,`is injured`,wins,`game played`)
VALUES
(1,100,'M',3,26,"MHO",0,0,0),
(2,60,'F',3,25,"FLO",0,0,0),
(4,85,'M',6,24,"MLY",0,0,0),
(5,75,'F',6,29,"FHO",0,0,0),
(7,82,'M',9,26,"MLY",0,0,0),
(8,74,'F',9,19,"FHY",0,0,0),
(10,88,'M',12,25,"MHO",0,0,0),
(11,72,'F',12,20,"FHY",0,0,0),
(13,66,'F',15,26,"FLO",0,0,0),
(14,81,'M',15,26,"MLO",0,0,0),
(16,71,'F',18,26,"FHO",0,0,0),
(17,81,'M',18,26,"MLO",0,0,0),
(19,77,'F',21,28,"FHO",0,0,0),
(20,104,'M',21,26,"MHO",0,0,0);

INSERT INTO judge(id,name,`battle count`)
VALUES 
(1,'OMRI',69),
(2,'PINHAS',62),
(3,'SHALOM',15),
(4,'SHAHAR',10);






