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
    PRIMARY KEY (`id`)
)  ENGINE=INNODB;


-- -----------------------------------------------------
-- Table `JUDO`.`categorys`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `JUDO`.`categorys` (
    `id` VARCHAR(3) NOT NULL,
    `gender` VARCHAR(1) NULL DEFAULT NULL,
    `weight category` ENUM('light', 'heavy') NULL DEFAULT NULL,
    `age range` ENUM('young', 'old') NULL DEFAULT NULL,
    PRIMARY KEY (`id`)
)  ENGINE=INNODB;


-- -----------------------------------------------------
-- Table `JUDO`.`coaches`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `JUDO`.`coaches` (
    `id` INT NOT NULL,
    `years exp` INT NULL DEFAULT NULL,
    PRIMARY KEY (`id`)
)  ENGINE=INNODB;


-- -----------------------------------------------------
-- Table `JUDO`.`teams`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `JUDO`.`teams` (
    `name` VARCHAR(15) NOT NULL,
    `win count` INT  NULL DEFAULT 0,
    PRIMARY KEY (`name`)
)  ENGINE=INNODB;


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
  `wins` INT UNSIGNED ZEROFILL NULL DEFAULT NULL,
  `game played` INT UNSIGNED ZEROFILL NULL DEFAULT NULL,
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
  `date` DATE NULL DEFAULT NULL,
    `time` TIME NULL DEFAULT NULL,
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
  `judoka 1 points` INT NULL DEFAULT NULL,
  `judoka 2 points` INT NULL DEFAULT NULL,
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
  `battles_id` INT NOT NULL,
  `battles_judge_id` INT NOT NULL,
  PRIMARY KEY (`id`, `judokas_id`, `battles_id`, `battles_judge_id`),
  INDEX `fk_fouls_judokas1_idx` (`judokas_id` ASC) VISIBLE,
  INDEX `fk_fouls_battles1_idx` (`battles_id` ASC, `battles_judge_id` ASC) VISIBLE,
  CONSTRAINT `fk_fouls_judokas1`
    FOREIGN KEY (`judokas_id`)
    REFERENCES `JUDO`.`judokas` (`id`),
  CONSTRAINT `fk_fouls_battles1`
    FOREIGN KEY (`battles_id` , `battles_judge_id`)
    REFERENCES `JUDO`.`battles` (`id` , `judge_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `JUDO`.`sponsers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `JUDO`.`sponsers` (
    `id` INT NOT NULL,
    `name` VARCHAR(25) NOT NULL,
    PRIMARY KEY (`id`)
)  ENGINE=INNODB;


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


-- -----------------------------------------------------
-- Triggers
-- -----------------------------------------------------
delimiter $$

create TRIGGER trigger_j1 after insert 
on JUDO.battles
for each row begin
update judo.judokas
set `game played` =`game played`+1
where new.`judoka 1 id`=judokas.id;

end$$
delimiter $$

create TRIGGER trigger_judge after insert 
on JUDO.battles
for each row begin
update judo.judge
set `battle count` =`battle count`+1
where new.`judge_id`=judge.id;

end$$
delimiter $$

create TRIGGER trigger_j2 after insert 
on JUDO.battles
for each row begin
update judo.judokas
set `game played` =`game played`+1
where new.`juduka 2 id`=judokas.id;

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
 -- -----------------------------------------------------
-- Procedures
-- -----------------------------------------------------
  DELIMITER $$ 
CREATE PROCEDURE JUDO.set_injury (IN judokas_id INT )
BEGIN 
  UPDATE JUDO.judokas 
  SET judokas.`is injured`=1
  WHERE judokas.id=judokas_id ;
  END $$
  DELIMITER ;
    DELIMITER $$ 
CREATE PROCEDURE JUDO.unset_injury (IN judokas_id INT )
BEGIN 
  UPDATE JUDO.judokas 
  SET judokas.`is injured`=0
  WHERE judokas.id=judokas_id ;
  END $$
  DELIMITER ;
  
DELIMITER $$ 
CREATE PROCEDURE JUDO.set_foul (IN id1 int,IN judokas_id INT, IN foul_type int,in battle_id int ,in judge_id int)
BEGIN 
 insert into fouls (id,`foul type`,judokas_id,battles_id,battles_judge_id)
 values (id1,foul_type,judokas_id,battle_id,judge_id);
  END $$
  DELIMITER ;
  DELIMITER $$
CREATE PROCEDURE JUDO.set_battle_result (IN id1 int,IN judoka1_points INT, IN judoka2_points INT ,in win_type int)
BEGIN 
declare winner1 int;
 declare team1 varchar(15);
 IF judoka1_points > judoka2_points THEN BEGIN
 SELECT `judoka 1 id` into winner1 FROM JUDO.BATTLES WHERE id1=judo.battles.id;end;
 ELSE  BEGIN 
  SELECT `juduka 2 id` into winner1 FROM JUDO.BATTLES WHERE id1=judo.battles.id;end;
end if;
select team into team1 from judo.teammates where teammates.id=winner1;
UPDATE JUDO.teams 
  SET teams.`win count`=teams.`win count`+1
  WHERE teams.name=team1 ; 
  insert into judo.`battle results` (id,`judoka 1 points`,`judoka 2 points`,winner,`win type`)
  VALUes (id1,judoka1_points,judoka2_points,winner1,win_type);
  
  END $$
  DELIMITER ;

USE JUDO;
-- -----------------------------------------------------
-- 	Inserts
-- -----------------------------------------------------
INSERT INTO JUDO.categorys (id,gender,`weight category`,`age range`)
VALUES('MLY', 'M', 'light', 'young'),
('MHY', 'M', 'heavy', 'young'),
('FLY', 'F', 'light', 'young'),
('FHY', 'F', 'heavy', 'young'),
('MLO', 'M', 'light', 'old'),
('MHO', 'M', 'heavy', 'old'),
('FLO', 'F', 'light', 'old'),
('FHO', 'F', 'heavy', 'old');

INSERT INTO judo.sponsers (ID,name)
VALUES
    ('301', 'nike'),
    ('302', 'adidas'),
    ('303', 'dunder mifflin'),
    ('304', 'new balance');

INSERT INTO JUDO.teams (name,`win count`)
VALUES  ('ISRAEL', '0'),
    ('USA', '0'),
    ('RUSSIA', '0'),
    ('MEXICO', '0');

INSERT INTO JUDO.teams_has_sponsers(teams_name,sponsers_id,money_contribute)
VALUES 
('usa', '301', '100000'),
    ('russia', '304', '25000'),
    ('israel', '302', '30000'),
    ('israel', '303', '20300');

INSERT INTO judo.teammates (ID,name,team)
VALUES
    ('101', 'bar', 'israel'),
    ('102', 'gabi', 'israel'),
    ('103', 'shlomi', 'israel'),
    ('104', 'sahar', 'israel'),
    ('105', 'tal', 'israel'),
    ('106', 'noa', 'israel'),
    ('107', 'or', 'israel'),
    ('108', 'ella', 'israel'),
    ('109', 'juan', 'mexico'),
    ('110', 'loco', 'mexico'),
    ('111', 'kaka', 'mexico'),
    ('112', 'ronaldo', 'mexico'),
    ('113', 'julia', 'mexico'),
    ('114', 'jin', 'mexico'),
    ('115', 'tonic', 'mexico'),
    ('116', 'silvi', 'mexico'),
    ('117', 'alex', 'russia'),
    ('118', 'vladimir', 'russia'),
    ('119', 'stalin', 'russia'),
    ('120', 'gavi', 'russia'),
    ('121', 'xenya', 'russia'),
    ('122', 'victoria', 'russia'),
    ('123', 'alexa', 'russia'),
    ('124', 'maria', 'russia'),
    ('125', 'derek', 'usa'),
    ('126', 'post', 'usa'),
    ('127', 'justin', 'usa'),
    ('128', 'lil wayne', 'usa'),
    ('129', 'madona', 'usa'),
    ('130', 'britny', 'usa'),
    ('131', 'rihanna', 'usa'),
    ('132', 'beyonce', 'usa'),
    ('133', 'elkoubi', 'israel'),
    ('134', 'jon', 'usa'),
    ('135', 'putin', 'russia'),
    ('136', 'pablo', 'mexico');
    
INSERT INTO JUDO.coaches(id,`years exp`)
VALUES ('133', '7'),
    ('134', '5'),
    ('135', '4'),
    ('136', '11');


INSERT INTO JUDO.judokas(id,weight,gender,`coach id`,age,category,`is injured`,wins,`game played`)
VALUES
    (101, '85', 'M', '133', '37', 'MHO', 0, '0', '0'),
    (102, '95', 'M', '133', '21', 'MHY', 0, '0', '0'),
    ('103', '73', 'M', '133', '27', 'MLO', 0, '0', '0'),
    ('104', '77', 'M', '133', '19', 'MLY', 0, '0', '0'),
    ('105', '77', 'F', '133', '27', 'FHO', 0, '0', '0'),
    ('106', '71', 'F', '133', '16', 'FHY', 0, '0', '0'),
    ('107', '69', 'F', '133', '44', 'FLO', 0, '0', '0'),
    ('108', '69', 'F', '133', '21', 'FLY', 0, '0', '0'),
    ('109', '99', 'M', '134', '30', 'MHO', 0, '0', '0'),
    ('110', '91', 'M', '134', '21', 'MHY', 0, '0', '0'),
    ('111', '79', 'M', '134', '26', 'MLO', 0, '0', '0'),
    ('112', '79', 'M', '134', '20', 'MLY', 0, '0', '0'),
    ('113', '76', 'F', '134', '22', 'FHO', 0, '0', '0'),
    ('114', '81', 'F', '134', '21', 'FHY', 0, '0', '0'),
    ('115', '60', 'F', '134', '44', 'FLO', 0, '0', '0'),
    ('116', '59', 'F', '134', '18', 'FLY', 0, '0', '0'),
    ('117', '85', 'M', '135', '37', 'MHO', 0, '0', '0'),
    ('118', '95', 'M', '135', '21', 'MHY', 0, '0', '0'),
    ('119', '73', 'M', '135', '27', 'MLO', 0, '0', '0'),
    ('120', '77', 'M', '135', '19', 'MLY', 0, '0', '0'),
    ('121', '77', 'F', '135', '27', 'FHO', 0, '0', '0'),
    ('122', '71', 'F', '135', '16', 'FHY', 0, '0', '0'),
    ('123', '69', 'F', '135', '44', 'FLO', 0, '0', '0'),
    ('124', '66', 'F', '135', '21', 'FLY', 0, '0', '0'),
    ('125', '91', 'M', '136', '30', 'MHO', 0, '0', '0'),
    ('126', '91', 'M', '136', '21', 'MHY', 0, '0', '0'),
    ('127', '77', 'M', '136', '26', 'MLO', 0, '0', '0'),
    ('128', '79', 'M', '136', '20', 'MLY', 0, '0', '0'),
    ('129', '76', 'F', '136', '22', 'FHO', 0, '0', '0'),
    ('130', '83', 'F', '136', '21', 'FHY', 0, '0', '0'),
    ('131', '60', 'F', '136', '44', 'FLO', 0, '0', '0'),
    ('132', '59', 'F', '136', '18', 'FLY', 0, '0', '0');
    
INSERT INTO judge(id,name,`battle count`)
VALUES 
 ('203', 'shalom', '173'),
    ('204', 'shlomi', '11'),
    ('205', 'shmuel', '132'),
    ('206', 'shimon', '111'),
    ('207', 'shuky', '265');
    
INSERT INTO battles (ID,`judoka 1 id`,`juduka 2 id`,date,time,judge_id,category)
VALUES
('401', '101', '109', '2023-08-07', '19:00:00', '204', 'MHO'),
    ('402', '101', '117', '2023-03-04', '20:00:00', '205', 'MHO'),
    ('403', '101', '125', '2023-10-12', '17:30:00', '204', 'MHO'),
    ('404', '109', '117', '2023-08-13', '21:30:00', '205', 'MHO'),
    ('405', '109', '125', '2023-07-19', '15:30:00', '204', 'MHO'),
    ('406', '117', '125', '2023-10-16', '13:00:00', '203', 'MHO'),
    ('407', '102', '110', '2023-04-13', '11:00:00', '206', 'MHY'),
    ('408', '102', '118', '2023-10-17', '13:30:00', '204', 'MHY'),
    ('409', '102', '126', '2023-05-15', '18:30:00', '205', 'MHY'),
    ('410', '110', '118', '2023-06-13', '14:00:00', '203', 'MHY'),
    ('411', '110', '126', '2023-06-11', '22:00:00', '205', 'MHY'),
    ('412', '118', '126', '2023-08-09', '13:00:00', '206', 'MHY'),
    ('413', '103', '111', '2023-02-23', '9:30:00', '207', 'MLO'),
    ('414', '103', '119', '2023-03-06', '21:00:00', '205', 'MLO'),
    ('415', '103', '127', '2023-06-05', '19:30:00', '207', 'MLO'),
    ('416', '111', '119', '2023-09-20', '10:00:00', '207', 'MLO'),
    ('417', '111', '127', '2023-08-16', '14:00:00', '207', 'MLO'),
    ('418', '119', '127', '2023-07-26', '12:00:00', '207', 'MLO'),
    ('419', '104', '112', '2023-08-07', '15:30:00', '205', 'MLY'),
    ('420', '104', '120', '2023-05-23', '15:00:00', '205', 'MLY'),
    ('421', '104', '128', '2023-04-03', '14:00:00', '204', 'MLY'),
    ('422', '112', '120', '2023-09-02', '18:00:00', '206', 'MLY'),
    ('423', '112', '128', '2023-01-26', '9:00:00', '204', 'MLY'),
    ('424', '120', '128', '2023-10-13', '17:30:00', '205', 'MLY'),
    ('425', '105', '113', '2023-02-22', '16:30:00', '204', 'FHO'),
    ('426', '105', '121', '2023-10-02', '16:00:00', '205', 'FHO'),
    ('427', '105', '129', '2023-08-11', '19:30:00', '207', 'FHO'),
    ('428', '113', '121', '2023-02-04', '21:00:00', '205', 'FHO'),
    ('429', '113', '129', '2023-09-26', '20:00:00', '203', 'FHO'),
    ('430', '121', '129', '2023-08-09', '15:30:00', '203', 'FHO'),
    ('431', '106', '114', '2023-09-18', '11:30:00', '206', 'FLO'),
    ('432', '106', '122', '2023-07-11', '13:00:00', '205', 'FLO'),
    ('433', '106', '130', '2023-03-28', '20:00:00', '207', 'FLO'),
    ('434', '114', '122', '2023-04-14', '11:30:00', '205', 'FLO'),
    ('435', '114', '130', '2023-05-23', '18:30:00', '205', 'FLO'),
    ('436', '122', '130', '2023-09-25', '11:30:00', '207', 'FLO'),
    ('437', '107', '115', '2023-01-27', '12:30:00', '203', 'FHY'),
    ('438', '107', '123', '2023-08-13', '14:30:00', '205', 'FHY'),
    ('439', '107', '131', '2023-10-04', '17:00:00', '205', 'FHY'),
    ('440', '115', '123', '2023-03-20', '15:00:00', '205', 'FHY'),
    ('441', '115', '131', '2023-09-11', '15:00:00', '207', 'FHY'),
    ('442', '123', '131', '2023-05-08', '18:00:00', '205', 'FHY'),
    ('443', '108', '116', '2023-08-01', '17:00:00', '207', 'FLY'),
    ('444', '108', '124', '2023-06-25', '22:00:00', '206', 'FLY'),
    ('445', '108', '132', '2023-01-29', '13:30:00', '204', 'FLY'),
    ('446', '116', '124', '2023-02-27', '12:00:00', '204', 'FLY'),
    ('447', '116', '132', '2023-08-21', '18:30:00', '203', 'FLY'),
    ('448', '124', '132', '2023-04-26', '21:00:00', '207', 'FLY');

call judo.set_battle_result('401', '0', '2', '1');
call judo.set_battle_result    ('402', '6', '0', '1');
call judo.set_battle_result    ('403', '5', '6', '1');
call judo.set_battle_result    ('404', '6', '6', '2');
call judo.set_battle_result    ('405', '2', '4', '1');
call judo.set_battle_result    ('406', '0', '8', '2');
call judo.set_battle_result    ('407', '6', '2', '1');
call judo.set_battle_result    ('408', '1', '9', '1');
call judo.set_battle_result    ('409', '8', '4', '2');
call judo.set_battle_result    ('410', '0', '0', '1');
call judo.set_battle_result    ('411', '1', '2', '1');
call judo.set_battle_result    ('412', '0', '0', '2');
call judo.set_battle_result    ('413', '7', '0', '2');
call judo.set_battle_result    ('414', '9', '8', '1');
call judo.set_battle_result    ('415', '5', '9', '2');
call judo.set_battle_result    ('416', '1', '0', '1');
call judo.set_battle_result    ('417', '1', '4', '2');
call judo.set_battle_result    ('418', '8', '9', '2');
call judo.set_battle_result    ('419', '9', '7', '1');
call judo.set_battle_result    ('420', '5', '9', '2');
call judo.set_battle_result    ('421', '1', '6', '2');
call judo.set_battle_result    ('422', '7', '9', '1');
call judo.set_battle_result    ('423', '8', '0', '1');
call judo.set_battle_result    ('424', '1', '5', '2');
call judo.set_battle_result    ('425', '0', '9', '1');
call judo.set_battle_result    ('426', '1', '2', '2');
call judo.set_battle_result    ('427', '2', '4', '1');
call judo.set_battle_result    ('428', '9', '9', '2');
call judo.set_battle_result    ('429', '3', '0', '1');
call judo.set_battle_result    ('430', '1', '9', '2');
call judo.set_battle_result    ('431', '3', '6', '1');
call judo.set_battle_result    ('432', '1', '9', '2');
call judo.set_battle_result    ('433', '5', '2', '2');
call judo.set_battle_result    ('434', '5', '5', '1');
call judo.set_battle_result    ('435', '1', '2', '1');
call judo.set_battle_result    ('436', '5', '4', '1');
call judo.set_battle_result    ('437', '0', '5', '1');
call judo.set_battle_result    ('438', '4', '7', '2');
call judo.set_battle_result    ('439', '1', '5', '1');
call judo.set_battle_result    ('440', '1', '4', '1');
call judo.set_battle_result    ('441', '2', '0', '2');
call judo.set_battle_result    ('442', '1', '3', '1');
call judo.set_battle_result    ('443', '6', '1', '1');
call judo.set_battle_result    ('444', '6', '0', '2');
call judo.set_battle_result    ('445', '7', '3', '2');
call judo.set_battle_result    ('446', '3', '3', '1');
call judo.set_battle_result    ('447', '0', '0', '2');
call judo.set_battle_result    ('448', '7', '5', '1');