-- 09/17/14 20:45:44
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';


-- -----------------------------------------------------
-- Table `regions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS  `regions` (
    `rid` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(64) NULL DEFAULT NULL COMMENT  'name of region',
    PRIMARY KEY (`rid`),
    UNIQUE INDEX `name_UNIQUE` (`name` ASC))
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8
    COMMENT =  'regions for holidays';

INSERT INTO `regions` (rid, `name`) VALUES (1, 'SK');



-- -----------------------------------------------------
-- Table `holidays`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `holidays` (
    `hid` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'unique bank holiday ID',
    `date` INT(10) UNSIGNED NOT NULL,
    `name` VARCHAR(50) NOT NULL,
    `localName` VARCHAR(50) NULL DEFAULT NULL COMMENT  'localized name',
    `freeDay` TINYINT(1) UNSIGNED NOT NULL DEFAULT 1,
    `country` CHAR(2) NOT NULL DEFAULT 'SK',
    `rid` INT(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT  'regions.rid',
    PRIMARY KEY (`hid`),
    UNIQUE INDEX `date_rid` (`date` ASC, `rid` ASC),
    INDEX `fk_holidays_regions1_idx` (`rid` ASC),
    CONSTRAINT `fk_holidays_regions1`
    FOREIGN KEY (`rid`)
    REFERENCES `regions` (`rid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    )
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `admins`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `admins` (
                                        `aid` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
                                        `login` VARCHAR(30) NULL,
    `name` VARCHAR(64) NULL DEFAULT NULL COMMENT 'Full name',
    `mail` VARCHAR(64) NULL DEFAULT NULL ,
    `pass` VARCHAR(64) NULL,
    `status` TINYINT UNSIGNED NOT NULL DEFAULT 1,
    `perms` INT(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Main menu permissions - bit array',
    `created` INT UNSIGNED NOT NULL DEFAULT 0,
    `creator` TINYINT UNSIGNED NOT NULL DEFAULT 0,
    `edited` INT UNSIGNED NULL,
    `editor` TINYINT UNSIGNED NULL,
    `lng` CHAR(2) NULL DEFAULT NULL COMMENT  'GUI Language in ISO 639-1 format',
    `personalNumber` INT(10) UNSIGNED NULL DEFAULT NULL,
    `del` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT  'deleted',
    PRIMARY KEY (`aid`),
    UNIQUE INDEX `login_UNIQUE` (`login` ASC),
    UNIQUE INDEX `mail_UNIQUE` (`mail` ASC),
    INDEX `status` (`status` ASC))
    ENGINE = InnoDB
    AUTO_INCREMENT = 0
    COMMENT = 'administrators';


-- -----------------------------------------------------
-- Table `mastergroups`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS  `mastergroups` (
    `mgid` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT  'Master group ID',
    `name` VARCHAR(255) NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (`mgid`),
    UNIQUE INDEX `uniq` (`name` ASC))
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8
    COLLATE = utf8_general_ci;



-- -----------------------------------------------------
-- Table `groups`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `groups` (
    `gid` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Group ID',
    `name` VARCHAR(64) NOT NULL,
    `type` TINYINT(1) UNSIGNED NOT NULL DEFAULT '0' COMMENT 'identical work time whole week/ every day different',
    `shifts` TINYINT(1) UNSIGNED NOT NULL DEFAULT '1',
    `flexi` TINYINT(1) UNSIGNED NOT NULL COMMENT 'flexible work time',
    `round_entry` INT(4) UNSIGNED NOT NULL DEFAULT '0' COMMENT 'rounding of entry',
    `round_leave` INT(4) UNSIGNED NOT NULL DEFAULT '0' COMMENT 'rounding of leave',
    `round_work` INT(4) UNSIGNED NOT NULL DEFAULT '0' COMMENT 'rounding of work time (all day)',
    `adjust_entry` INT(4) NOT NULL DEFAULT '0' COMMENT 'adjustment of entry (+/-)',
    `adjust_leave` INT(4) NOT NULL DEFAULT '0' COMMENT 'adjustments of leave (+/-)',
    `lunch` TINYINT(1) UNSIGNED NOT NULL DEFAULT '0' COMMENT 'automatically take-away lunch break',
    `lunch_val` INT(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT 'number of hours in order to receive lunch',
    `lunch_len` INT(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT 'lenght of luch break',
    `lunch2` TINYINT(1) UNSIGNED NOT NULL DEFAULT '0' COMMENT 'automatically take-away 2nd lunch',
    `lunch2_val` INT(10) UNSIGNED NOT NULL DEFAULT '0',
    `lunchBegin` INT(10) UNSIGNED NOT NULL DEFAULT '0',
    `lunchEnd` INT(10) UNSIGNED NOT NULL DEFAULT '0',
    `penalty` INT(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT 'penalty for lunch not entered (number of min)',
    `voucher_val` INT(10) UNSIGNED NOT NULL DEFAULT '0',
    `vouchers` TINYINT(1) UNSIGNED NOT NULL DEFAULT '0',
    `voucher2_val` INT(10) UNSIGNED NOT NULL DEFAULT '0',
    `vouchers2` TINYINT(1) UNSIGNED NOT NULL DEFAULT '0',
    `week` TINYINT(1) UNSIGNED NOT NULL DEFAULT '0' COMMENT 'annul a weekly overtime',
    `month` TINYINT(1) UNSIGNED NOT NULL DEFAULT '0' COMMENT 'annul a monthly overtime',
    `night` TINYINT(1) UNSIGNED NOT NULL DEFAULT '0' COMMENT 'add a night shift to the day when it started (options)',
    `night1` TINYINT(1) UNSIGNED NOT NULL DEFAULT '0' COMMENT 'do not add night shift in the first shift',
    `holiday` TINYINT(1) UNSIGNED NOT NULL DEFAULT '0' COMMENT 'bank holiday during week add to fond',
    `holiday_over` TINYINT(1) UNSIGNED NOT NULL DEFAULT '0' COMMENT 'worked bank holiday count as overtime',
    `annual` INT(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT 'minimal use of annual leave (hour, 1/2 day, whole day)',
    `annual_rest` TINYINT(1) UNSIGNED NOT NULL DEFAULT '0' COMMENT 'do not accept rest of annual leave/ accept positive/ accept',
    `fixedLunch` TINYINT UNSIGNED NOT NULL DEFAULT 0,
    `parent` INT(10) UNSIGNED NULL DEFAULT NULL COMMENT  'ID of master group',
    `created` INT UNSIGNED NOT NULL DEFAULT 0,
    `creator` TINYINT UNSIGNED NOT NULL DEFAULT 0,
    `edited` INT UNSIGNED NULL,
    `editor` TINYINT UNSIGNED NULL,
    `night_begin` INT(10) UNSIGNED NOT NULL DEFAULT 79200 ,
    `night_end` INT(10) UNSIGNED NOT NULL DEFAULT 21600 ,
    `wtnd` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT  'Work time move to next  day',
    `breakLimit` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
    `days` TINYINT(3) UNSIGNED NOT NULL DEFAULT 96 COMMENT  'free days in week' ,
    `nightBreak` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT  'Subtract break from night' ,
    `hwFund` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT  'Holiday on weekend count in fund',
    `annulDaily` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'annul a daily overtime',
    `refFund` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT  'reference fund enabled',
    `refFundValue` INT(10) UNSIGNED NULL DEFAULT NULL COMMENT  'daily reference fund value',
    `refFundAllDay` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT  'use reference fund for all day interruption',
    `checkLess` INT(10) UNSIGNED NULL DEFAULT NULL COMMENT  'mark day for check if diff is less than',
    `checkGreat` INT(10) UNSIGNED NULL DEFAULT NULL COMMENT  'mark day for check if diff is greather than',
    `checkUnrecog` INT(10) UNSIGNED NOT NULL DEFAULT 1800 COMMENT  'mark day for check if unrecognized interruption is greather than',
    `noHolidays` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
    `disOverLess` INT(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT  'Dismiss overtime less than..',
    `disOverLessType` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Type of \"Dismiss overtime less..\"',
    `disOverLessInterval` TINYINT(1) NOT NULL DEFAULT 0,
    `disOverLessRest` TINYINT(1) NOT NULL DEFAULT 0,
    `disOverGreat` INT(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT  'Dismiss overtime greater than..',
    `entrancePenalty` INT(10) UNSIGNED NOT NULL DEFAULT 0,
    `autoCalc` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
    `HAWD` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT  'Holiday as working day',
    `DVOW` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT  'Disable Vouchers on Weekend',
    `quarter` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT  'annul a quarterly overtime',
    `worked` TINYINT(1) UNSIGNED NOT NULL DEFAULt 0,
    `annulYearly` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0  COMMENT  'annul a yearly overtime',
    `bonus` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Enable bonus calculation' ,
    `bonusBegin` INT(5) UNSIGNED NULL DEFAULT NULL ,
    `bonusEnd` INT(5) UNSIGNED NULL DEFAULT NULL,
    `break2` INT(10) UNSIGNED NULL DEFAULT 0,
    `wta` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Working Time Account (WTA) - enable / disable',
    `wta_limit` INT(11) NOT NULL DEFAULT 0 COMMENT 'WTA - account limit',
    `wta_limitAct` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'WTA - action after filling limit',
    `bonusBreak` TINYINT(1) UNSIGNED NOT NULL DEFAULT '0' COMMENT 'Subtract break from bonus time',
    `calendarID` INT(10) UNSIGNED NULL DEFAULT NULL COMMENT  'ID kalendara (Softip HR - ron.Kalendar)',
    `holidayBonus` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
    `holidayIncrease` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT  'allow Holiday fund move > 1 / day (e.g. 1,5)',
    `harmonogram` VARCHAR(255) NULL DEFAULT NULL COMMENT 'IFS Harmonogram(s)',
    `irregularTime` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT  'nepravidelne rozvrhnuty cas',
    `rid` INT(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'regions.rid',
    PRIMARY KEY (`gid`),
    INDEX `type` (`type` ASC),
    INDEX `fk_groups_mastergroups1_idx` (`parent` ASC),
    INDEX `fk_groups_creator_idx` (`creator` ASC),
    INDEX `fk_groups_editor_idx` (`editor` ASC),
    INDEX `fk_groups_regions1_idx` (`rid` ASC),
    CONSTRAINT `fk_groups_creator`
    FOREIGN KEY (`creator`)
    REFERENCES `admins` (`aid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    CONSTRAINT `fk_groups_editor`
    FOREIGN KEY (`editor`)
    REFERENCES `admins` (`aid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    CONSTRAINT `fk_groups_mastergroups1`
    FOREIGN KEY (`parent`)
    REFERENCES `mastergroups` (`mgid`)
    ON DELETE NO ACTION
    ON UPDATE SET NULL,
    CONSTRAINT `fk_groups_regions1`
    FOREIGN KEY (`rid`)
    REFERENCES `regions` (`rid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    )
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8
    COMMENT = 'workgroups (departments)';


-- -----------------------------------------------------
-- Table `groups_plan`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `groups_plan` (
    `gid` INT(10) UNSIGNED NOT NULL COMMENT  'groups.gid',
    `uid` INT(10) UNSIGNED NOT NULL COMMENT  'people.uid',
    `since` INT(10) UNSIGNED NOT NULL DEFAULT 201801 COMMENT 'Validity from YYYYMM',
    PRIMARY KEY `gid_uid_since` (`gid`, `uid`, `since`),
    INDEX `fk_groups_plan_groups1_idx` (`gid` ASC),
    INDEX `fk_groups_plan_people1_idx` (`uid` ASC),
    UNIQUE INDEX `uid_since` (`uid`, `since` DESC),
    CONSTRAINT `fk_groups_plan_groups1`
    FOREIGN KEY (`gid`)
    REFERENCES `groups` (`gid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    CONSTRAINT `fk_groups_plan_people1`
    FOREIGN KEY (`uid`)
    REFERENCES `people` (`uid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8;



-- -----------------------------------------------------
-- Table `groups_month`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `groups_month` (
    `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
    `gid` int(10) unsigned DEFAULT NULL COMMENT 'groups.gid',
    `uid` int(10) unsigned NOT NULL COMMENT 'people.uid',
    `month` int(10) unsigned NOT NULL DEFAULT '201801' COMMENT 'month in format YYYYMM',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uid_month` (`uid`,`month`),
    KEY `fk_groups_month_groups1_idx` (`gid`),
    KEY `fk_groups_month_people1_idx` (`uid`),
    CONSTRAINT `groups_month_ibfk_1` FOREIGN KEY (`gid`) REFERENCES `groups` (`gid`) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT `fk_groups_month_people1` FOREIGN KEY (`uid`) REFERENCES `people` (`uid`) ON DELETE NO ACTION ON UPDATE NO ACTION
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8;




-- -----------------------------------------------------
-- Table `departs`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `departs` (
    `did` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '',
    `name` VARCHAR(255) NOT NULL COMMENT '',
    PRIMARY KEY (`did`)  COMMENT '',
    UNIQUE INDEX `name_UNIQUE` (`name` ASC) )
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8
    COLLATE = utf8_general_ci
    COMMENT =  'departments';


-- -----------------------------------------------------
-- Table `people`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `people` (
    `uid` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    `pid` INT(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT 'personal person ID',
    `pamId` VARCHAR(16) DEFAULT NULL COMMENT 'personal ID for export',
    `title` VARCHAR(15) NULL DEFAULT NULL COMMENT 'title in front of name',
    `name` VARCHAR(30) NULL DEFAULT NULL,
    `surname` VARCHAR(30) NULL DEFAULT NULL,
    `title2` VARCHAR(15) NULL DEFAULT NULL,
    `phone` VARCHAR(50) NULL DEFAULT NULL,
    `email` VARCHAR(50) NULL DEFAULT NULL,
    `type` TINYINT(1) UNSIGNED NOT NULL DEFAULT '0' COMMENT 'type of contract (employee, part time...)',
    `begin` INT(8) UNSIGNED NULL DEFAULT NULL COMMENT 'begining of employment',
    `end` INT(8) UNSIGNED NULL DEFAULT NULL COMMENT 'end of employment',
    `gid` INT(10) UNSIGNED NULL DEFAULT NULL COMMENT 'group ID',
    `description` VARCHAR(255) NULL DEFAULT NULL,
    `admin` TINYINT(1) UNSIGNED NOT NULL DEFAULT '0',
    `pass` VARCHAR(50) NULL DEFAULT NULL COMMENT 'password to check attendance online',
    `authstr` CHAR(41) NULL DEFAULT NULL COMMENT  'authentication string',
    `card` VARCHAR(255) NULL DEFAULT NULL COMMENT 'card ID',
    `status` TINYINT(1) UNSIGNED NOT NULL DEFAULT '1' COMMENT '0= deleted person (will not appear GUI)',
    `alert` TINYINT(1) UNSIGNED NOT NULL DEFAULT '0' COMMENT 'alert about a missing list',
    `pan` TINYINT(1) UNSIGNED NOT NULL DEFAULT '0' COMMENT 'possible additional note',
    `lastCalc` INT(11) NOT NULL DEFAULT 1420070400,
    `lct` INT(11) NOT NULL DEFAULT 0 COMMENT 'Last Calculated Time',
    `photo` BLOB NULL,
    `access` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
    `did` INT(10) UNSIGNED NULL COMMENT  'departs.did',
    `present` INT UNSIGNED NOT NULL DEFAULT 0,
    `saldo` int NOT NULL DEFAULT '0',
    `calc` INT(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'attendance calculation is in progress',
    `wta` INT(11) NOT NULL DEFAULT 0 COMMENT 'current value of Working Time Account',
    `bid` SMALLINT(5) UNSIGNED NULL DEFAULT NULL COMMENT 'branches.bid',
    `rsBegin` INT(8) UNSIGNED NULL DEFAULT NULL COMMENT  'Registry state - begin',
    `rsEnd` INT(8) UNSIGNED NULL DEFAULT NULL COMMENT  'Registry state - end',
    `rsText` VARCHAR(64) NULL DEFAULT NULL COMMENT  'Registry state - description',
    `created` INT UNSIGNED NOT NULL DEFAULT 0,
    `creator` TINYINT UNSIGNED NOT NULL DEFAULT 0,
    `edited` INT UNSIGNED NULL DEFAULT NULL,
    `editor` TINYINT UNSIGNED NULL DEFAULT NULL,
    `lng` CHAR(2) NULL DEFAULT NULL COMMENT  'GUI Language in ISO 639-1 format',
    `calendarID` INT(10) NULL DEFAULT NULL COMMENT  'SoftipHR - ron.Kalendar',
    `tom` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT  'type of meal (typ stravneho): 0 = stravne listky (vouchers), 1=financny prislpevok (financial contribution)',
    PRIMARY KEY (`uid`),
    UNIQUE INDEX `mapId` (`pid` ASC),
    INDEX `typ` (`type` ASC),
    INDEX `skup` (`gid` ASC),
    INDEX `poz` (`description` ASC),
    INDEX `stav` (`status` ASC),
    INDEX `fk_people_creator_idx` (`creator` ASC),
    INDEX `fk_people_editor_idx` (`editor` ASC),
    INDEX `lastCalc` (`lastCalc` ASC),
    INDEX `status` (`status` ASC),
    INDEX `endofcontract` (`end` ASC),
    INDEX `fk_people_departs1_idx` (`did` ASC),
    INDEX `lct` (`lct` ASC),
    INDEX `present` (`present` ASC),
    INDEX `calc` (`calc` ASC),
    INDEX `fk_people_branches1_idx` (`bid` ASC),
    CONSTRAINT `fk_people_groups1`
    FOREIGN KEY (`gid`)
    REFERENCES `groups` (`gid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    CONSTRAINT `fk_people_creator`
    FOREIGN KEY (`creator`)
    REFERENCES `admins` (`aid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    CONSTRAINT `fk_people_editor`
    FOREIGN KEY (`editor`)
    REFERENCES `admins` (`aid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    CONSTRAINT `fk_people_departs1`
    FOREIGN KEY (`did`)
    REFERENCES `departs` (`did`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
    CONSTRAINT `fk_people_branches1`
    FOREIGN KEY (`bid`)
    REFERENCES `branches` (`bid`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
    ENGINE = InnoDB
    AUTO_INCREMENT = 1
    DEFAULT CHARACTER SET = utf8
    COMMENT = 'employees';


-- -----------------------------------------------------
-- Table `atten`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `atten` (
    `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    `uid` INT(10) UNSIGNED NULL DEFAULT '0' COMMENT 'Person ID',
    `date` INT(10) UNSIGNED NOT NULL DEFAULT '0',
    `month` INT(6) UNSIGNED NULL DEFAULT NULL COMMENT  'month in format YYYYMM',
    `dom` TINYINT(2) UNSIGNED NOT NULL DEFAULT '0' COMMENT 'day of month',
    `dow` TINYINT(1) UNSIGNED NOT NULL DEFAULT '0' COMMENT 'day of week',
    `hid` INT(10) UNSIGNED NULL DEFAULT NULL COMMENT 'holiday ID',
    `fond` INT UNSIGNED NOT NULL DEFAULT 0,
    `entry` INT(10) UNSIGNED NULL DEFAULT NULL,
    `leave` INT(10) UNSIGNED NULL,
    `total` INT(10) UNSIGNED NULL,
    `work` INT(10) UNSIGNED NULL DEFAULT NULL,
    `shift` TINYINT(1) UNSIGNED NULL,
    `vouchers` DECIMAL(3,1) UNSIGNED NULL DEFAULT NULL,
    `lunch` INT(10) UNSIGNED NULL DEFAULT NULL,
    `diff` INT(11) NULL DEFAULT NULL,
    `saldo` INT(11) NULL DEFAULT NULL,
    `saldo_p` INT(11) NULL DEFAULT NULL COMMENT  'pay',
    `saldo_c` INT(11) NULL DEFAULT NULL COMMENT  'canceled',
    `ok` TINYINT(1) NOT NULL DEFAULT '0',
    `lock` TINYINT(1) UNSIGNED NOT NULL DEFAULT '0',
    `man` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'manual change',
    `created` INT(10) UNSIGNED NOT NULL DEFAULT 0 ,
    `creator` TINYINT(3) UNSIGNED NOT NULL DEFAULT 0 ,
    `edited` INT(10) UNSIGNED NULL DEFAULT NULL ,
    `editor` TINYINT(3) UNSIGNED NULL DEFAULT NULL,
    `note` MEDIUMTEXT NULL DEFAULT NULL,
    `freeDay` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
    `inters` TINYTEXT NULL DEFAULT NULL,
    `night` INT(10) UNSIGNED NULL DEFAULT NULL,
    `checked` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
    `flags` TINYINT(3) UNSIGNED NOT NULL DEFAULT 0 COMMENT  'some flags - bitmap',
    `readBegin` INT(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT  'Begin of readiness',
    `readEnd` INT(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT  'End of readiness',
    `wore` INT(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT  'worked readiness',
    `expFund` INT(10) UNSIGNED NULL DEFAULT NULL COMMENT  'Fund for export',
    `bonus` INT(10) UNSIGNED NULL DEFAULT NULL,
    `order` SMALLINT(5) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'number of continuous allday interruption',
    `wta` INT(11) NULL DEFAULT NULL COMMENT 'Working Time Account',
    `acWta` INT(11) NULL DEFAULT NULL COMMENT  'Working Time Account adjusted by AttenCalc',
    `manOvertime` TINYINT(3) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Overtime was manually edited - flag',
    `overtimeNote` TEXT NULL DEFAULT NULL COMMENT  'poznamka k nadcasu',
    PRIMARY KEY (`id`),
    UNIQUE INDEX `uid_date` (`uid` ASC, `date` ASC),
    INDEX `uid` (`uid` ASC),
    INDEX `ok` (`ok` ASC),
    INDEX `lock` (`lock` ASC),
    INDEX `fk_atten_holidays1_idx` (`hid` ASC),
    INDEX `date` (`date` ASC),
    INDEX `flags` (`flags`),
    INDEX `order` (`order` ASC),
    INDEX `uid_month` (`uid` ASC, `month` ASC),
    INDEX `uid_lock` (`uid` ASC, `lock` ASC),
    CONSTRAINT `fk_atten_holidays1`
    FOREIGN KEY (`hid`)
    REFERENCES `holidays` (`hid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    CONSTRAINT `fk_atten_people1`
    FOREIGN KEY (`uid`)
    REFERENCES `people` (`uid`)
    ON DELETE NO ACTION
    ON UPDATE SET NULL)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8
    COMMENT = 'calculated attendance (per day)';


-- -----------------------------------------------------
-- Table `atten_data`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `atten_data` (
    `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    `uid` INT(10) UNSIGNED NULL DEFAULT '0' COMMENT 'Employee ID',
    `iid` INT(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT 'Interuption ID',
    `from` INT(10) UNSIGNED NOT NULL COMMENT 'time from which interuption is valid',
    `duration` INT(10) UNSIGNED NOT NULL COMMENT 'duration in seconds',
    `man` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'manual change',
    `del` TINYINT(1) UNSIGNED NOT NULL DEFAULT '0',
    `request` INT(10) UNSIGNED NULL DEFAULT NULL COMMENT  'Reference to request',
    `lock` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'locked',
    `rounded` INT(10) UNSIGNED NULL DEFAULT NULL,
    `flags` TINYINT(3) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'some flags - bitmap',
    `note` TEXT NULL DEFAULT NULL,
    PRIMARY KEY (`id`),
    UNIQUE INDEX `uniq` (`uid` ASC, `from` ASC, `del` ASC),
    INDEX `uid` (`uid` ASC),
    INDEX `iid` (`iid` ASC),
    INDEX `from` (`from` ASC),
    INDEX `del` (`del` ASC),
    INDEX `man` (`man` ASC),
    INDEX `request` (`request` ASC),
    INDEX `lock` (`lock` ASC),
    INDEX `uid_iid_del_from_duration` (`uid`, `iid`, `del`, `from`, `duration`),
    CONSTRAINT `fk_atten_data_people1`
    FOREIGN KEY (`uid`)
    REFERENCES `people` (`uid`)
    ON DELETE NO ACTION
    ON UPDATE SET NULL,
    CONSTRAINT `fk_atten_data_requests1`
    FOREIGN KEY (`request`)
    REFERENCES  `requests` (`rid`)
    ON DELETE SET NULL
    ON UPDATE CASCADE
    )
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8
    COMMENT = 'entrances from terminals';


-- -----------------------------------------------------
-- Table `inters`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `inters` (
    `iid` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'interuption ID',
    `name` VARCHAR(50) NOT NULL COMMENT 'interuption name',
    `shortcut` VARCHAR(5) NOT NULL,
    `weight` INT(11) NOT NULL DEFAULT '0',
    `start` VARCHAR(15) NULL DEFAULT NULL,
    `stop` VARCHAR(15) NULL DEFAULT NULL,
    `color` CHAR(7) NULL DEFAULT NULL COMMENT 'color of interuption on the graph',
    `work` TINYINT(1) NOT NULL DEFAULT '0',
    `locked` TINYINT(1) NOT NULL DEFAULT '0',
    `lunch` TINYINT(1) UNSIGNED NOT NULL DEFAULT '0' COMMENT 'luch during interuption',
    `next` TINYINT(1) UNSIGNED NOT NULL DEFAULT '0' COMMENT 'it continues during next few days',
    `weekend` TINYINT(1) UNSIGNED NOT NULL DEFAULT '0' COMMENT 'it continues during weekend',
    `saldo` TINYINT(1) UNSIGNED NOT NULL DEFAULT '0',
    `flexi` TINYINT(1) UNSIGNED NOT NULL DEFAULT '0' COMMENT 'flexible time',
    `autoentry` TINYINT(1) UNSIGNED NOT NULL DEFAULT '0' COMMENT 'automatic entry (calculating)',
    `autoleave` TINYINT(1) UNSIGNED NOT NULL DEFAULT '0' COMMENT 'automatic leave (calculating)',
    `autoentry_val` INT(11) NOT NULL DEFAULT '0' COMMENT 'automatic entry - value +/- hour',
    `autoleave_val` INT(11) NOT NULL DEFAULT '0' COMMENT 'automatic leave - value +/- hour',
    `durat` TINYINT(1) UNSIGNED NOT NULL DEFAULT '0',
    `ignor` TINYINT(1) UNSIGNED NOT NULL DEFAULT '0',
    `present` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
    `vouchers` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
    `aliasWork` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
    `round` INT(10) UNSIGNED NOT NULL DEFAULT 0,
    `ignorePresent` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
    `created` INT UNSIGNED NOT NULL DEFAULT 0,
    `creator` TINYINT UNSIGNED NOT NULL DEFAULT 0,
    `edited` INT UNSIGNED NULL,
    `editor` TINYINT UNSIGNED NULL,
    `noFlexi` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Not in flexible time',
    `request` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'allow as request',
    `country` CHAR(2) NOT NULL DEFAULT 'SK',
    `nextBreak` SMALLINT(5) UNSIGNED NOT NULL DEFAULT 0 COMMENT  'Break limit for next column (it continues during next few days)',
    `checkDelay` INT(10) UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (`iid`),
    UNIQUE INDEX `skr` (`shortcut` ASC),
    INDEX `fk_inters_creator_idx` (`creator` ASC),
    INDEX `fk_inters_editor_idx` (`editor` ASC),
    INDEX `ignorePresent_idx` (`ignorePresent` ASC),
    CONSTRAINT `fk_inters_creator`
    FOREIGN KEY (`creator`)
    REFERENCES `admins` (`aid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    CONSTRAINT `fk_inters_editor`
    FOREIGN KEY (`editor`)
    REFERENCES `admins` (`aid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8
    COMMENT = 'List of interruptions';


-- -----------------------------------------------------
-- Table `inters_data`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `inters_data` (
    `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    `uid` INT(10) UNSIGNED NOT NULL,
    `iid` INT(10) UNSIGNED NOT NULL COMMENT 'Interuption ID',
    `type` TINYINT(4) NOT NULL DEFAULT '-1' COMMENT 'type of interuption - direction (entry/leave)',
    `aid` INT(10) UNSIGNED NOT NULL DEFAULT '0',
    `tid` INT(10) UNSIGNED NOT NULL DEFAULT '0',
    `date` INT(10) UNSIGNED NOT NULL,
    `created` INT(10) UNSIGNED NOT NULL,
    `description` VARCHAR(255) NULL DEFAULT NULL,
    `photo` BLOB NULL DEFAULT NULL,
    `del` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
    `face` TINYINT(1) NULL DEFAULT NULL COMMENT 'face detect status',
    `refId` INT(10) UNSIGNED NULL DEFAULT NULL COMMENT 'reference ID (from ATT)' ,
    `latitude` DOUBLE NULL DEFAULT NULL,
    `longitude` DOUBLE NULL DEFAULT NULL,
    PRIMARY KEY (`id`),
    UNIQUE INDEX `replace` (`uid` ASC, `iid` ASC, `type` ASC, `aid` ASC, `tid` ASC, `date` ASC, `del`),
    INDEX `pid` (`iid` ASC),
    INDEX `typ` (`type` ASC),
    INDEX `aid` (`aid` ASC),
    INDEX `tid` (`tid` ASC),
    INDEX `uid` (`uid` ASC),
    INDEX `date` (`date` ASC),
    INDEX `face` (`face` ASC),
    INDEX `refId` (`refId` ASC) ,
    INDEX `tid_ref` (`tid` ASC, `refId` ASC) ,
    INDEX `deleted` (`del` ASC),
    CONSTRAINT `fk_inters_data_inters1`
    FOREIGN KEY (`iid`)
    REFERENCES `inters` (`iid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    CONSTRAINT `fk_inters_data_people1`
    FOREIGN KEY (`uid`)
    REFERENCES `people` (`uid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8
    COMMENT = 'history of interruptions from terminals';


-- -----------------------------------------------------
-- Table `plan`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `plan` (
    `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    `uid` INT(10) UNSIGNED NOT NULL,
    `day` INT(10) UNSIGNED NOT NULL COMMENT 'timestamp day (midnight)',
    `flexi_entry` INT(10) UNSIGNED NOT NULL DEFAULT '0',
    `fixed_entry` INT(10) UNSIGNED NOT NULL DEFAULT '0',
    `fixed_leave` INT(10) UNSIGNED NOT NULL DEFAULT '0',
    `flexi_leave` INT(10) UNSIGNED NOT NULL DEFAULT '0',
    `fond` INT(10) UNSIGNED NOT NULL COMMENT 'work fond (number of hours in seconds)',
    `del` TINYINT(1) UNSIGNED NOT NULL DEFAULT '0',
    `locked` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
    `shift` TINYINT(1) UNSIGNED NULL DEFAULT NULL COMMENT  'target shift',
    `cycitid` INT(10) UNSIGNED NULL  COMMENT 'cycle_items.id',
    `secid` SMALLINT(5) UNSIGNED NULL DEFAULT NULL COMMENT  'sections.secid',
    `break_len` INT(10) UNSIGNED NULL DEFAULT NULL,
    `break_auto` INT(10) UNSIGNED NULL DEFAULT NULL,
    PRIMARY KEY (`id`),
    UNIQUE INDEX `uid_day` (`uid` ASC, `day` ASC),
    INDEX `uid` (`uid` ASC),
    INDEX `day` (`day` ASC),
    INDEX `del` (`del` ASC),
    INDEX `locked` (`locked` ASC),
    INDEX `fk_plan_cycle_items1_idx` (`cycitid` ASC),
    INDEX `fk_plan_sections1_idx` (`secid` ASC),
    CONSTRAINT `fk_plan_people1`
    FOREIGN KEY (`uid`)
    REFERENCES `people` (`uid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    CONSTRAINT `fk_plan_cycle_items1`
    FOREIGN KEY (`cycitid`)
    REFERENCES `cycle_items` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8
    COMMENT = 'plans of shifts for employees';


-- -----------------------------------------------------
-- Table `shifts`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `shifts` (
    `sid` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    `shift` TINYINT(1) UNSIGNED NOT NULL DEFAULT '1',
    `gid` int(10) unsigned NULL COMMENT 'Group ID',
    `fond` INT(10) UNSIGNED NOT NULL COMMENT 'work fond (number of hours in seconds)',
    `flexi_entry` INT(10) UNSIGNED NOT NULL,
    `flexi_leave` INT(10) UNSIGNED NOT NULL,
    `fixed_entry` INT(10) UNSIGNED NOT NULL,
    `fixed_leave` INT(10) UNSIGNED NOT NULL,
    `dow` TINYINT(1) UNSIGNED NOT NULL DEFAULT '0' COMMENT 'Day of week',
    `break_len` INT(10) UNSIGNED NOT NULL DEFAULT 0,
    `break_begin` INT(10) UNSIGNED NOT NULL DEFAULT 0,
    `break_end` INT(10) UNSIGNED NOT NULL DEFAULT 0,
    `break_auto` INT(10) UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (`sid`),
    UNIQUE INDEX `shift_gid_dow` (`shift` ASC, `gid` ASC, `dow` ASC),
    INDEX `shift` (`shift` ASC),
    INDEX `dow` (`dow` ASC),
    INDEX `fk_shifts_groups1_idx` (`gid` ASC),
    CONSTRAINT `fk_shifts_groups1`
    FOREIGN KEY (`gid`)
    REFERENCES `groups` (`gid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8
    COMMENT = 'list of work shifts';


-- -----------------------------------------------------
-- Table `term`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `term` (
    `tid` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'unique terminal ID',
    `mac` VARCHAR(30) NOT NULL COMMENT 'MAC address',
    `ip` VARCHAR(20) NOT NULL DEFAULT '0.0.0.0' COMMENT 'IP address',
    `name` VARCHAR(30) NULL DEFAULT NULL COMMENT 'terminal name',
    `online` INT(10) UNSIGNED NULL DEFAULT NULL,
    `type` VARCHAR(30) NULL DEFAULT NULL COMMENT 'type/model',
    `ver` VARCHAR(64) NULL COMMENT 'ATT version',
    `fenixID` INT UNSIGNED NULL COMMENT 'Terminal ID in Fenix DB',
    `btime` INT NULL COMMENT 'boot time',
    `crNum` INT UNSIGNED NULL COMMENT 'Number of cards readed',
    `accNum` INT UNSIGNED NULL COMMENT 'Number of accesses',
    `memu` TINYINT NULL COMMENT 'RAM usage',
    `cpuu` TINYINT NULL COMMENT 'CPU usage',
    `hddu` TINYINT NULL COMMENT 'HDD usage',
    `sdu` TINYINT NULL COMMENT 'SD card usage',
    `fpu` TINYINT NULL COMMENT 'Fingerprint module usage',
    `status` TINYINT(1) UNSIGNED NOT NULL DEFAULT '1' COMMENT '0=forbidden/deleted',
    `syn` SMALLINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'synchronization flags',
    `flags` SMALLINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'flags / features for synchronization' ,
    `bid` SMALLINT(5) UNSIGNED NULL DEFAULT NULL ,
    PRIMARY KEY (`tid`),
    INDEX `mac` (`mac` ASC),
    INDEX `syn` (`syn` ASC),
    INDEX `fenixId` (`fenixID` ASC) ,
    INDEX `flags` (`flags` ASC),
    INDEX `status` (`status`),
    INDEX `fk_term_branches1_idx` (`bid` ASC),
    CONSTRAINT `fk_term_branches1`
    FOREIGN KEY (`bid`)
    REFERENCES `branches` (`bid`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8
    COMMENT = 'terminals';


-- -----------------------------------------------------
-- Table `term_sync`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `term_sync` (
    `tid` INT(10) UNSIGNED NOT NULL COMMENT '',
    `type` ENUM('I', 'U', 'D') NULL DEFAULT NULL COMMENT '',
    `ref` VARCHAR(64) NOT NULL COMMENT 'reference table',
    `ref_col` VARCHAR(45) NULL DEFAULT NULL COMMENT 'reference column',
    `ref_id` INT(10) UNSIGNED NULL DEFAULT NULL COMMENT 'reference ID',
    `ref_col2` VARCHAR(45) NULL DEFAULT NULL COMMENT 'reference column 2',
    `ref_id2` INT(10) UNSIGNED NULL DEFAULT NULL COMMENT 'reference ID 2',
    `created` INT(10) UNSIGNED NOT NULL COMMENT '',
    `flags` SMALLINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'synchronization flags',
    INDEX `fk_term_sync_term1_idx` (`tid` ASC)  COMMENT '',
    INDEX `type` (`type` ASC)  COMMENT '',
    INDEX `ref` (`ref` ASC)  COMMENT '',
    INDEX `ref_id` (`ref_id` ASC)  COMMENT '',
    INDEX `ref_ref_id` (`ref` ASC, `ref_id` ASC)  COMMENT '',
    INDEX `ref_col` (`ref_col` ASC)  COMMENT '',
    INDEX `flags` (`flags` ASC)  COMMENT '',
    INDEX `created` (`created` ASC)  COMMENT '',
    CONSTRAINT `fk_term_sync_term1`
    FOREIGN KEY (`tid`)
    REFERENCES `term` (`tid`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8
    COLLATE = utf8_general_ci
    COMMENT = 'synchronization tasks for terminals';


-- -----------------------------------------------------
-- Table `pamsettings`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pamsettings` (
    `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '',
    `active` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '',
    `type` VARCHAR(45) NOT NULL COMMENT '',
    `name` VARCHAR(64) NULL DEFAULT NULL COMMENT '',
    `data` LONGBLOB NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (`id`)  COMMENT '')
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8
    COLLATE = utf8_general_ci;


-- -----------------------------------------------------
-- Table `inters_term`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `inters_term` (
    `iid` INT(10) UNSIGNED NOT NULL,
    `tid` INT(10) UNSIGNED NOT NULL,
    `syn` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (`iid`, `tid`),
    INDEX `fk_inters_has_term_term1_idx` (`tid` ASC),
    INDEX `fk_inters_has_term_inters_idx` (`iid` ASC),
    INDEX `syn` (`syn` ASC),
    CONSTRAINT `fk_inters_has_term_inters`
    FOREIGN KEY (`iid`)
    REFERENCES `inters` (`iid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    CONSTRAINT `fk_inters_has_term_term1`
    FOREIGN KEY (`tid`)
    REFERENCES `term` (`tid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `people_term`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `people_term` (
    `uid` INT(10) UNSIGNED NOT NULL,
    `tid` INT(10) UNSIGNED NOT NULL,
    `grp` TINYINT(3) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'color group',
    `syn` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (`uid`, `tid`),
    INDEX `fk_people_has_term_term1_idx` (`tid` ASC),
    INDEX `fk_people_has_term_people1_idx` (`uid` ASC),
    INDEX `grp` (`grp` ASC),
    INDEX `syn` (`syn` ASC),
    CONSTRAINT `fk_people_has_term_people1`
    FOREIGN KEY (`uid`)
    REFERENCES `people` (`uid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    CONSTRAINT `fk_people_has_term_term1`
    FOREIGN KEY (`tid`)
    REFERENCES `term` (`tid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `perms`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `perms` (
                                       `pid` INT UNSIGNED NOT NULL AUTO_INCREMENT,
                                       `name` VARCHAR(30) NOT NULL,
    `title` VARCHAR(30) NOT NULL,
    `note` VARCHAR(255) NULL,
    `parent` INT UNSIGNED NULL,
    `maxLevel` TINYINT UNSIGNED NOT NULL DEFAULT 2,
    PRIMARY KEY (`pid`),
    UNIQUE INDEX `name_UNIQUE` (`name` ASC),
    INDEX `parent` (`parent` ASC),
    CONSTRAINT `fk_parent_pid`
    FOREIGN KEY (`parent`)
    REFERENCES `perms` (`pid`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
    ENGINE = InnoDB
    COMMENT = 'permissions';


-- -----------------------------------------------------
-- Table `admins_perms`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `admins_perms` (
                                              `admins_aid` TINYINT UNSIGNED NOT NULL,
                                              `perms_pid` INT UNSIGNED NOT NULL,
                                              `level` TINYINT UNSIGNED NOT NULL DEFAULT 0,
                                              `created` INT UNSIGNED NOT NULL DEFAULT 0,
                                              `creator` TINYINT UNSIGNED NOT NULL DEFAULT 0,
                                              `edited` INT UNSIGNED NULL,
                                              `editor` TINYINT UNSIGNED NULL,
                                              PRIMARY KEY (`admins_aid`, `perms_pid`),
    INDEX `fk_admins_has_perms_perms1_idx` (`perms_pid` ASC),
    INDEX `fk_admins_has_perms_admins1_idx` (`admins_aid` ASC),
    INDEX `fk_admins_perms_creator_idx` (`creator` ASC),
    INDEX `fk_admins_perms_editor_idx` (`editor` ASC),
    CONSTRAINT `fk_admins_has_perms_admins1`
    FOREIGN KEY (`admins_aid`)
    REFERENCES `admins` (`aid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    CONSTRAINT `fk_admins_has_perms_perms1`
    FOREIGN KEY (`perms_pid`)
    REFERENCES `perms` (`pid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    CONSTRAINT `fk_admins_perms_creator`
    FOREIGN KEY (`creator`)
    REFERENCES `admins` (`aid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    CONSTRAINT `fk_admins_perms_editor`
    FOREIGN KEY (`editor`)
    REFERENCES `admins` (`aid`)
    ON DELETE SET NULL
    ON UPDATE SET NULL)
    ENGINE = InnoDB
    COMMENT = 'permissions associated to administrators';


-- -----------------------------------------------------
-- Table `fingers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `fingers` (
                                         `fid` INT NOT NULL AUTO_INCREMENT,
                                         `uid` INT UNSIGNED NOT NULL,
                                         `finger` TINYINT(2) UNSIGNED NOT NULL,
    `tpl` BLOB NOT NULL,
    UNIQUE INDEX `uid_finger` (`uid` ASC, `finger` ASC),
    INDEX `uid` (`uid` ASC),
    PRIMARY KEY (`fid`),
    CONSTRAINT `fingers_people`
    FOREIGN KEY (`uid`)
    REFERENCES `people` (`uid`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
    ENGINE = InnoDB
    COMMENT = 'fingerprints';


-- -----------------------------------------------------
-- Table `fingers_term`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `fingers_term` (
                                              `fid` INT NOT NULL,
                                              `tid` INT(10) UNSIGNED NOT NULL,
    `syn` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (`fid`, `tid`),
    INDEX `fk_fingers_has_term_term1_idx` (`tid` ASC),
    INDEX `fk_fingers_has_term_fingers1_idx` (`fid` ASC),
    CONSTRAINT `fk_fingers_has_term_fingers1`
    FOREIGN KEY (`fid`)
    REFERENCES `fingers` (`fid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    CONSTRAINT `fk_fingers_has_term_term1`
    FOREIGN KEY (`tid`)
    REFERENCES `term` (`tid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
    ENGINE = InnoDB
    COMMENT = 'Synchronization of fingerprints with terminals';


-- -----------------------------------------------------
-- Table `vars`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `vars` (
    `name` VARCHAR(64) NOT NULL,
    `value` BLOB NULL DEFAULT NULL,
    PRIMARY KEY (`name`))
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8
    COLLATE = utf8_general_ci
    COMMENT =  'variables';


-- -----------------------------------------------------
-- Table `zones`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `zones` (
    `zid` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT  'zone ID',
    `name` VARCHAR(45) NULL DEFAULT NULL,
    `from_time` INT(10) UNSIGNED NOT NULL DEFAULT 0,
    `to_time` INT(10) UNSIGNED NOT NULL DEFAULT 0,
    `days` TINYINT(3) UNSIGNED NOT NULL DEFAULT 0 COMMENT  'bit array of days in week',
    `status` TINYINT(1) UNSIGNED NOT NULL DEFAULT 1,
    PRIMARY KEY (`zid`))
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8
    COLLATE = utf8_general_ci
    COMMENT =  'timezones (access)';


-- -----------------------------------------------------
-- Table `pzt`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pzt` (
    `uid` INT(10) UNSIGNED NOT NULL COMMENT '',
    `zid` INT(10) UNSIGNED NOT NULL COMMENT '',
    `tid` INT(10) UNSIGNED NOT NULL COMMENT '',
    `syn` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '',
    PRIMARY KEY (`uid`, `zid`, `tid`)  COMMENT '',
    INDEX `fk_zones_has_people_people1_idx` (`uid` ASC)  COMMENT '',
    INDEX `fk_zones_has_people_zones1_idx` (`zid` ASC)  COMMENT '',
    INDEX `fk_zones_has_people_term1_idx` (`tid` ASC)  COMMENT '',
    INDEX `syn` (`syn` ASC)  COMMENT '',
    CONSTRAINT `fk_zones_has_people_zones1`
    FOREIGN KEY (`zid`)
    REFERENCES `zones` (`zid`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
    CONSTRAINT `fk_zones_has_people_people1`
    FOREIGN KEY (`uid`)
    REFERENCES `people` (`uid`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
    CONSTRAINT `fk_zones_has_people_term1`
    FOREIGN KEY (`tid`)
    REFERENCES `term` (`tid`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8
    COLLATE = utf8_general_ci
    COMMENT = 'people - zones - terminals';

-- -----------------------------------------------------
-- Table `admins_people`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `admins_people` (
    `aid` TINYINT(3) UNSIGNED NOT NULL,
    `uid` INT(10) UNSIGNED NOT NULL,
    `request` TINYINT(1) NOT NULL DEFAULT 0 COMMENT  'requests allowed',
    PRIMARY KEY (`aid`, `uid`),
    INDEX `fk_admins_has_people_people1_idx` (`uid` ASC),
    INDEX `fk_admins_has_people_admins1_idx` (`aid` ASC),
    CONSTRAINT `fk_admins_has_people_admins1`
    FOREIGN KEY (`aid`)
    REFERENCES `admins` (`aid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    CONSTRAINT `fk_admins_has_people_people1`
    FOREIGN KEY (`uid`)
    REFERENCES `people` (`uid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8
    COLLATE = utf8_general_ci;




-- -----------------------------------------------------
-- Table `emails`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `emails` (
    `mid` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT  'mail ID',
    `type` CHAR(1) NULL DEFAULT NULL,
    `status` CHAR(1) NOT NULL DEFAULT 'N',
    `from` VARCHAR(127) NULL DEFAULT NULL COMMENT  'E-mail address - sender',
    `to` VARCHAR(127) NULL DEFAULT NULL COMMENT  'E-mail address - recipient',
    `subject` VARCHAR(127) NULL DEFAULT NULL COMMENT  'E-mail subject',
    `body` LONGBLOB NULL DEFAULT NULL COMMENT  'E-mail body',
    `created` INT(11) NULL DEFAULT NULL COMMENT  'created timestamp',
    `sent` TINYINT(3) UNSIGNED NOT NULL DEFAULT 0 COMMENT  'sent status / counter',
    `done` INT(11) NULL DEFAULT NULL COMMENT 'sent timestamp',
    `aid` TINYINT(3) UNSIGNED  NULL COMMENT  'admins.aid',
    `uid` INT(10) UNSIGNED  NULL COMMENT  'people.uid',
    `data` LONGBLOB NULL DEFAULT NULL,
    `apiID` VARCHAR(64) NULL DEFAULT NULL,
    PRIMARY KEY (`mid`),
    INDEX `fk_emails_admins1_idx` (`aid` ASC),
    INDEX `fk_emails_people1_idx` (`uid` ASC),
    INDEX `type` (`type` ASC),
    INDEX `sent` (`sent` ASC),
    INDEX `done` (`done` ASC),
    UNIQUE INDEX `apiID_UNIQUE` (`apiID` ASC),
    CONSTRAINT `fk_emails_admins1`
    FOREIGN KEY (`aid`)
    REFERENCES `admins` (`aid`)
    ON DELETE NO ACTION
    ON UPDATE SET NULL,
    CONSTRAINT `fk_emails_people1`
    FOREIGN KEY (`uid`)
    REFERENCES `people` (`uid`)
    ON DELETE NO ACTION
    ON UPDATE SET NULL)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8
    COLLATE = utf8_general_ci
    COMMENT =  'E-mail queue';


-- -----------------------------------------------------
-- Table `requests`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `requests` (
    `rid` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT  'Request ID',
    `type` TINYINT(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'request / info',
    `status` CHAR(1) NOT NULL DEFAULT 'N',
    `uid` INT(10) UNSIGNED  NULL,
    `from` INT(11) NULL DEFAULT 0 COMMENT  'from timestamp',
    `to` INT(11) NULL DEFAULT NULL COMMENT  'to timestamp',
    `reason` TEXT NULL DEFAULT NULL COMMENT  'Text from employee',
    `aid` TINYINT(3) UNSIGNED  NULL,
    `statement` TEXT NULL DEFAULT NULL COMMENT  'Text from admin',
    `created` INT(11) NULL DEFAULT NULL COMMENT  'created timestamp',
    `iid` INT(10) UNSIGNED  NULL COMMENT  'inters.iid',
    `donetime` INT(10) UNSIGNED NULL DEFAULT NULL COMMENT  'confirmed / cancelled timestamp',
    `shift` SMALLINT(5) UNSIGNED NULL DEFAULT NULL,
    PRIMARY KEY (`rid`),
    INDEX `fk_requests_people1_idx` (`uid` ASC),
    INDEX `fk_requests_admins1_idx` (`aid` ASC),
    INDEX `fk_requests_inters1_idx` (`iid` ASC),
    INDEX `status` (`status` ASC),
    CONSTRAINT `fk_requests_people1`
    FOREIGN KEY (`uid`)
    REFERENCES `people` (`uid`)
    ON DELETE NO ACTION
    ON UPDATE SET NULL,
    CONSTRAINT `fk_requests_admins1`
    FOREIGN KEY (`aid`)
    REFERENCES `admins` (`aid`)
    ON DELETE NO ACTION
    ON UPDATE SET NULL,
    CONSTRAINT `fk_requests_inters1`
    FOREIGN KEY (`iid`)
    REFERENCES `inters` (`iid`)
    ON DELETE NO ACTION
    ON UPDATE SET NULL)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8
    COLLATE = utf8_general_ci
    COMMENT =  'requests (requisitions) of employees';


-- -----------------------------------------------------
-- Table `notes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `notes` (
    `nid` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'note ID',
    `aid` TINYINT(3) UNSIGNED  NULL COMMENT  'admins.aid',
    `uid` INT(10) UNSIGNED  NULL COMMENT  'people.uid',
    `note` TEXT NULL DEFAULT NULL COMMENT  'note text',
    `created` INT(11) NULL DEFAULT NULL COMMENT  'created timestamp',
    `parent` INT(11)  NULL,
    `depth` TINYINT(3) UNSIGNED NOT NULL DEFAULT 0 COMMENT  'Level of tree depth',
    PRIMARY KEY (`nid`),
    INDEX `fk_notes_admins1_idx` (`aid` ASC),
    INDEX `fk_notes_people1_idx` (`uid` ASC),
    INDEX `parent` (`parent` ASC),
    INDEX `depth` (`depth` ASC),
    CONSTRAINT `fk_notes_admins1`
    FOREIGN KEY (`aid`)
    REFERENCES `admins` (`aid`)
    ON DELETE NO ACTION
    ON UPDATE SET NULL,
    CONSTRAINT `fk_notes_people1`
    FOREIGN KEY (`uid`)
    REFERENCES `people` (`uid`)
    ON DELETE NO ACTION
    ON UPDATE SET NULL,
    CONSTRAINT `fk_notes_notes1`
    FOREIGN KEY (`parent`)
    REFERENCES `notes` (`nid`)
    ON DELETE NO ACTION
    ON UPDATE SET NULL)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8
    COLLATE = utf8_general_ci
    COMMENT =  'descriptions';




-- -----------------------------------------------------
-- Table `funds`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `funds` (
    `fid` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT  'Fund ID',
    `unit` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT  'Unit of Fund (sec. / hour / day)',
    `iid` INT(10) UNSIGNED NOT NULL COMMENT  'Interruption ID',
    `type` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT  'incremental / decremental fund',
    `annulYearly` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT  'yearly annul fund',
    `att` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'show in terminal' ,
    `info` TINYINT(1) NOT NULL DEFAULT 0 ,
    `noNegative` TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (`fid`)  COMMENT '',
    UNIQUE INDEX `fk_funds_inters1_idx` (`iid` ASC),
    INDEX `att` (`att` ASC),
    CONSTRAINT `fk_funds_inters1`
    FOREIGN KEY (`iid`)
    REFERENCES `inters` (`iid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8
    COLLATE = utf8_general_ci;


-- -----------------------------------------------------
-- Table `funds_status`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS  `funds_status` (
    `id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '',
    `month` INT(10) UNSIGNED NULL DEFAULT NULL COMMENT '',
    `value` INT(11) NOT NULL DEFAULT 0 COMMENT  'Value of fund account',
    `fid` INT(10) UNSIGNED NOT NULL COMMENT  'funds.fid',
    `uid` INT(10) UNSIGNED NOT NULL COMMENT  'people.uid',
    PRIMARY KEY (`id`)  COMMENT '',
    INDEX `fk_funds_status_funds1_idx` (`fid` ASC) ,
    INDEX `fk_funds_status_people1_idx` (`uid` ASC),
    UNIQUE INDEX `unq` (`month` ASC, `uid` ASC, `fid` ASC),
    CONSTRAINT `fk_funds_status_funds1`
    FOREIGN KEY (`fid`)
    REFERENCES `funds` (`fid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    CONSTRAINT `fk_funds_status_people1`
    FOREIGN KEY (`uid`)
    REFERENCES `people` (`uid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8
    COLLATE = utf8_general_ci;


-- -----------------------------------------------------
-- Table `funds_move`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `funds_move` (
    `fmid` INT(11) NOT NULL AUTO_INCREMENT COMMENT  'funds - move ID',
    `type` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '',
    `day` INT(11) NULL DEFAULT NULL COMMENT  'timestamp',
    `month` INT(10) UNSIGNED NULL DEFAULT NULL,
    `value` INT(11) NOT NULL DEFAULT 0 ,
    `fid` INT(10) UNSIGNED NOT NULL COMMENT  'funds.fid',
    `uid` INT(10) UNSIGNED NOT NULL COMMENT  'people.uid',
    `locked` TINYINT(3) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'locked record',
    PRIMARY KEY (`fmid`)  ,
    INDEX `fk_funds_move_funds1_idx` (`fid` ASC) ,
    INDEX `fk_funds_move_people1_idx` (`uid` ASC)  ,
    UNIQUE INDEX `unq` (`type` ASC, `day` ASC, `fid` ASC, `uid` ASC)  ,
    INDEX `fid_uid_month` (`fid` ASC, `uid` ASC, `month` ASC),
    CONSTRAINT `fk_funds_move_funds1`
    FOREIGN KEY (`fid`)
    REFERENCES `funds` (`fid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    CONSTRAINT `fk_funds_move_people1`
    FOREIGN KEY (`uid`)
    REFERENCES `people` (`uid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8
    COLLATE = utf8_general_ci;


-- -----------------------------------------------------
-- Table `rpp` - Readiness Post Process
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `rpp` (
    `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT ,
    `iid` INT(10) UNSIGNED NOT NULL COMMENT  'inters.iid',
    `name` VARCHAR(255) NOT NULL ,
    `freeDay` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 ,
    `condType` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
    `condFrom` INT(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT  'Condition - from time',
    `condTo` INT(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT  'Condition - to time',
    `acceptFrom` INT(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT  'Accept - from time',
    `acceptTo` INT(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT  'Accept - to time',
    `acceptType` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT 'Accept type',
    `acceptDuration` int(10) unsigned NOT NULL DEFAULT '0',
    `acceptInterrupt` int(10) unsigned NULL,
    PRIMARY KEY (`id`) ,
    INDEX `fk_rpp_inters1_idx` (`iid` ASC),
    CONSTRAINT `fk_rpp_inters1`
    FOREIGN KEY (`iid`)
    REFERENCES `inters` (`iid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    CONSTRAINT `fk_rpp_inters2` FOREIGN KEY (`acceptInterrupt`) REFERENCES `inters` (`iid`) ON DELETE SET NULL ON UPDATE CASCADE)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8
    COLLATE = utf8_general_ci
    COMMENT =  'Readiness post process';


-- -----------------------------------------------------
-- Table `faces`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `faces` (
    `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    `uid` INT(10) UNSIGNED NOT NULL COMMENT  'people.uid',
    `data` BLOB NOT NULL COMMENT  'face data (image for training)',
    `refId` INT(10) UNSIGNED NOT NULL COMMENT 'inters_data.id',
    PRIMARY KEY (`id`),
    INDEX `fk_faces_people1_idx` (`uid` ASC),
    CONSTRAINT `fk_faces_people1`
    FOREIGN KEY (`uid`)
    REFERENCES `people` (`uid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    INDEX `fk_faces_inters_data1_idx` (`refId` ASC),
    CONSTRAINT `fk_faces_inters_data1`
    FOREIGN KEY (`refId`)
    REFERENCES `inters_data` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
    )
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8
    COLLATE = utf8_general_ci;




-- -----------------------------------------------------
-- Table `branches`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `branches` (
    `bid` SMALLINT(5) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '',
    `number` INT(10) UNSIGNED NULL DEFAULT NULL,
    `name` VARCHAR(64) NULL DEFAULT NULL COMMENT '',
    `address` TINYTEXT NULL DEFAULT NULL COMMENT '',
    `note` MEDIUMTEXT NULL DEFAULT NULL COMMENT '',
    `wh1b` SMALLINT(5) UNSIGNED NULL DEFAULT NULL COMMENT 'working hours on day 1 - begin',
    `wh1e` SMALLINT(5) UNSIGNED NULL DEFAULT NULL COMMENT 'working hours on day 1 - end',
    `wh2b` SMALLINT(5) UNSIGNED NULL DEFAULT NULL COMMENT 'working hours on day 2 - begin',
    `wh2e` SMALLINT(5) UNSIGNED NULL DEFAULT NULL COMMENT 'working hours on day 2 - end',
    `wh3b` SMALLINT(5) UNSIGNED NULL DEFAULT NULL COMMENT 'working hours on day 3 - begin',
    `wh3e` SMALLINT(5) UNSIGNED NULL DEFAULT NULL COMMENT 'working hours on day 3 - end',
    `wh4b` SMALLINT(5) UNSIGNED NULL DEFAULT NULL COMMENT 'working hours on day 4 - begin',
    `wh4e` SMALLINT(5) UNSIGNED NULL DEFAULT NULL COMMENT 'working hours on day 4 - end',
    `wh5b` SMALLINT(5) UNSIGNED NULL DEFAULT NULL COMMENT 'working hours on day 5 - begin',
    `wh5e` SMALLINT(5) UNSIGNED NULL DEFAULT NULL COMMENT 'working hours on day 5 - end',
    `wh6b` SMALLINT(5) UNSIGNED NULL DEFAULT NULL COMMENT 'working hours on day 6 - begin',
    `wh6e` SMALLINT(5) UNSIGNED NULL DEFAULT NULL COMMENT 'working hours on day 6 - end',
    `wh7b` SMALLINT(5) UNSIGNED NULL DEFAULT NULL COMMENT 'working hours on day 7 - begin',
    `wh7e` SMALLINT(5) UNSIGNED NULL DEFAULT NULL COMMENT 'working hours on day 7 - end',
    `mgid` INT(10) UNSIGNED NULL DEFAULT NULL COMMENT 'mastergroups.mgid',
    `onlyRequest` TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (`bid`)  COMMENT '',
    UNIQUE INDEX `name_UNIQUE` (`name` ASC)  COMMENT '',
    UNIQUE INDEX `number_UNIQUE` (`number`),
    INDEX `fk_branches_mastergroups1_idx` (`mgid` ASC)
    )
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8
    COLLATE = utf8_general_ci;


-- -----------------------------------------------------
-- Table `attributes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `attributes` (
    `attrid` SMALLINT(5) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '',
    `name` VARCHAR(64) NULL DEFAULT NULL COMMENT '',
    `note` MEDIUMTEXT NULL DEFAULT NULL COMMENT '',
    `flags` TINYINT(3) UNSIGNED NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (`attrid`)  COMMENT '',
    UNIQUE INDEX `name_UNIQUE` (`name` ASC)  COMMENT '')
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8
    COLLATE = utf8_general_ci;


-- -----------------------------------------------------
-- Table `sections`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sections` (
    `secid` SMALLINT(5) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '',
    `name` VARCHAR(64) NULL DEFAULT NULL COMMENT '',
    `note` MEDIUMTEXT NULL DEFAULT NULL COMMENT '',
    `color` CHAR(7) NULL DEFAULT NULL,
    PRIMARY KEY (`secid`)  COMMENT '',
    UNIQUE INDEX `name_UNIQUE` (`name` ASC)  COMMENT '',
    UNIQUE INDEX `color_UNIQUE` (`color` ASC)
    )
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8
    COLLATE = utf8_general_ci
    COMMENT = 'sections of branches';


-- -----------------------------------------------------
-- Table `bas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bas` (
    `bid` SMALLINT(5) UNSIGNED NOT NULL COMMENT '',
    `attrid` SMALLINT(5) UNSIGNED NOT NULL COMMENT '',
    `secid` SMALLINT(5) UNSIGNED NOT NULL COMMENT '',
    PRIMARY KEY (`bid`, `attrid`, `secid`)  COMMENT '',
    INDEX `fk_branches_has_attributes_attributes1_idx` (`attrid` ASC)  COMMENT '',
    INDEX `fk_branches_has_attributes_branches1_idx` (`bid` ASC)  COMMENT '',
    INDEX `fk_branches_has_attributes_sections1_idx` (`secid` ASC)  COMMENT '',
    CONSTRAINT `fk_branches_has_attributes_branches1`
    FOREIGN KEY (`bid`)
    REFERENCES `branches` (`bid`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
    CONSTRAINT `fk_branches_has_attributes_attributes1`
    FOREIGN KEY (`attrid`)
    REFERENCES `attributes` (`attrid`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
    CONSTRAINT `fk_branches_has_attributes_sections1`
    FOREIGN KEY (`secid`)
    REFERENCES `sections` (`secid`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8
    COLLATE = utf8_general_ci;


-- -----------------------------------------------------
-- Table `bradm`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bradm` (
    `bid` SMALLINT(5) UNSIGNED NOT NULL COMMENT '',
    `aid` TINYINT(3) UNSIGNED NOT NULL COMMENT '',
    PRIMARY KEY (`bid`, `aid`)  COMMENT '',
    INDEX `fk_branches_has_admins_admins1_idx` (`aid` ASC)  COMMENT '',
    INDEX `fk_branches_has_admins_branches1_idx` (`bid` ASC)  COMMENT '',
    CONSTRAINT `fk_branches_has_admins_branches1`
    FOREIGN KEY (`bid`)
    REFERENCES `branches` (`bid`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
    CONSTRAINT `fk_branches_has_admins_admins1`
    FOREIGN KEY (`aid`)
    REFERENCES `admins` (`aid`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8
    COLLATE = utf8_general_ci;


-- -----------------------------------------------------
-- Table `people_attr`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `people_attr` (
    `uid` INT(10) UNSIGNED NOT NULL COMMENT '',
    `attrid` SMALLINT(5) UNSIGNED NOT NULL COMMENT '',
    `number` VARCHAR(45) NULL DEFAULT NULL COMMENT 'number of card / document',
    `expiration` INT(10) UNSIGNED NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (`uid`, `attrid`)  COMMENT '',
    INDEX `fk_people_has_attributes_attributes1_idx` (`attrid` ASC)  COMMENT '',
    INDEX `fk_people_has_attributes_people1_idx` (`uid` ASC)  COMMENT '',
    INDEX `people_attr_expiration` (`expiration` ASC)  COMMENT '',
    CONSTRAINT `fk_people_has_attributes_people1`
    FOREIGN KEY (`uid`)
    REFERENCES `people` (`uid`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
    CONSTRAINT `fk_people_has_attributes_attributes1`
    FOREIGN KEY (`attrid`)
    REFERENCES `attributes` (`attrid`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8
    COLLATE = utf8_general_ci;


-- -----------------------------------------------------
-- Table `brape`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `brape` (
    `bid` SMALLINT(5) UNSIGNED NOT NULL COMMENT '',
    `uid` INT(10) UNSIGNED NOT NULL COMMENT '',
    `since` INT(10) UNSIGNED NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (`bid`, `uid`)  COMMENT '',
    INDEX `fk_branches_has_people_people1_idx` (`uid` ASC)  COMMENT '',
    INDEX `fk_branches_has_people_branches1_idx` (`bid` ASC)  COMMENT '',
    INDEX `brape_since` (`since` ASC)  COMMENT '',
    CONSTRAINT `fk_branches_has_people_branches1`
    FOREIGN KEY (`bid`)
    REFERENCES `branches` (`bid`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
    CONSTRAINT `fk_branches_has_people_people1`
    FOREIGN KEY (`uid`)
    REFERENCES `people` (`uid`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8
    COLLATE = utf8_general_ci;


-- -----------------------------------------------------
-- Table `cycles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cycles` (
    `cid` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT   COMMENT 'Cycle ID',
    `name` VARCHAR(64) NULL DEFAULT NULL COMMENT '',
    `shortcut` VARCHAR(5) NULL DEFAULT NULL COMMENT '',
    `gid` INT(10) UNSIGNED NOT NULL COMMENT '',
    `note` TEXT NULL DEFAULT NULL,
    PRIMARY KEY (`cid`)  COMMENT '',
    INDEX `fk_cycles_groups1_idx` (`gid` ASC)  COMMENT '',
    UNIQUE INDEX `uniq_short` (`shortcut` ASC, `gid` ASC)  COMMENT '',
    CONSTRAINT `fk_cycles_groups1`
    FOREIGN KEY (`gid`)
    REFERENCES `groups` (`gid`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8
    COLLATE = utf8_general_ci
    COMMENT = 'cycles for plan';


-- -----------------------------------------------------
-- Table `cycle_items`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cycle_items` (
    `id` INT(10) UNSIGNED NOT NULL  AUTO_INCREMENT COMMENT 'cycle item ID',
    `cid` INT(10) UNSIGNED NOT NULL COMMENT 'cycles.cid',
    `sid` INT(10) UNSIGNED NULL COMMENT 'shifts.sid',
    `day` SMALLINT(6) NOT NULL DEFAULT 0 COMMENT '',
    `note` TEXT NULL DEFAULT NULL,
    PRIMARY KEY (`id`)  COMMENT '',
    INDEX `fk_cycle_items_cycles1_idx` (`cid` ASC)  COMMENT '',
    INDEX `fk_cycle_items_shifts1_idx` (`sid` ASC)  COMMENT '',
    CONSTRAINT `fk_cycle_items_cycles1`
    FOREIGN KEY (`cid`)
    REFERENCES `cycles` (`cid`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
    CONSTRAINT `fk_cycle_items_shifts1`
    FOREIGN KEY (`sid`)
    REFERENCES `shifts` (`sid`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8
    COLLATE = utf8_general_ci;



-- -----------------------------------------------------
-- Table `sec_branch`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sec_branch` (
    `secid` SMALLINT(5) UNSIGNED NOT NULL,
    `bid` SMALLINT(5) UNSIGNED NOT NULL,
    PRIMARY KEY (`secid`, `bid`),
    INDEX `fk_sections_has_branches_branches1_idx` (`bid` ASC),
    INDEX `fk_sections_has_branches_sections1_idx` (`secid` ASC),
    CONSTRAINT `fk_sections_has_branches_sections1`
    FOREIGN KEY (`secid`)
    REFERENCES `sections` (`secid`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
    CONSTRAINT `fk_sections_has_branches_branches1`
    FOREIGN KEY (`bid`)
    REFERENCES `branches` (`bid`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8;



-- -----------------------------------------------------
-- Table `atten_month`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `atten_month` (
    `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    `uid` INT(10) UNSIGNED NOT NULL COMMENT  'people.uid',
    `month` INT(6) UNSIGNED NULL DEFAULT NULL COMMENT  'month in format YYYYMM',
    `gid` INT(10) UNSIGNED NULL DEFAULT NULL COMMENT  'groups.gid',
    `status` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT  'lock status',
    `days` SMALLINT(2) UNSIGNED NULL DEFAULT NULL,
    `locks` SMALLINT(2) UNSIGNED NULL DEFAULT NULL,
    `oks` SMALLINT(2) UNSIGNED NULL DEFAULT NULL,
    `checks` SMALLINT(2) UNSIGNED NULL DEFAULT NULL,
    `fond` INT(10) UNSIGNED NULL DEFAULT NULL,
    `work` INT(10) UNSIGNED NULL DEFAULT NULL,
    `vouchers` DECIMAL(3,1) UNSIGNED NULL DEFAULT NULL,
    `diff` INT(11) NULL DEFAULT NULL,
    `saldo` INT(11) NULL DEFAULT NULL,
    `saldo_p` INT(11) NULL DEFAULT NULL ,
    `saldo_c` INT(11) NULL DEFAULT NULL ,
    `editorID` TINYINT(3) UNSIGNED NULL DEFAULT NULL,
    `edited` INT(10) UNSIGNED NULL DEFAULT NULL,
    `refFund` INT(10) UNSIGNED NULL DEFAULT NULL,
    `night` INT(10) UNSIGNED NULL DEFAULT NULL,
    `break` INT(10) UNSIGNED NULL DEFAULT NULL,
    `bonus` INT(10) UNSIGNED NULL DEFAULT NULL,
    `workDays` SMALLINT(2) UNSIGNED NULL DEFAULT NULL,
    `holidays` SMALLINT(2) UNSIGNED NULL DEFAULT NULL,
    `wFond` INT(10) UNSIGNED NULL DEFAULT NULL,
    `ref_workDays` SMALLINT(2) UNSIGNED NULL DEFAULT NULL,
    `ref_holidays` SMALLINT(2) UNSIGNED NULL DEFAULT NULL,
    `ref_wFond` INT(10) UNSIGNED NULL DEFAULT NULL,
    `ref_fond` INT(10) UNSIGNED NULL DEFAULT NULL,
    `curSaldo` INT(11) NULL DEFAULT NULL,
    `planSaldo` INT(11) NULL DEFAULT NULL,
    `totalSaldo` INT(11) NULL DEFAULT NULL,
    `workDaysVal` INT(10) UNSIGNED NULL DEFAULT NULL,
    `day6sum` INT(10) UNSIGNED NULL DEFAULT NULL,
    `day7sum` INT(10) UNSIGNED NULL DEFAULT NULL,
    `holidayFond` INT(10) UNSIGNED NULL DEFAULT NULL,
    `holidaySum` INT(10) UNSIGNED NULL DEFAULT NULL,
    `wta` INT(11) NULL DEFAULT NULL,
    `wtaPlus` INT(10) UNSIGNED NULL DEFAULT NULL,
    `wtaMinus` INT(10) UNSIGNED NULL DEFAULT NULL,
    `wtaTotal` INT(11) NULL DEFAULT NULL,
    `readiness` INT(10) UNSIGNED NULL DEFAULT NULL,
    `readWorked` INT(10) UNSIGNED NULL DEFAULT NULL,
    `acv` VARCHAR(45) NULL DEFAULT NULL COMMENT  'Version of AttenCalc plugin',
    INDEX `fk_atten_month_people1_idx` (`uid` ASC),
    INDEX `fk_atten_month_groups1_idx` (`gid` ASC),
    UNIQUE INDEX `uid_month` (`uid` ASC, `month` ASC),
    INDEX `uid_month_status` (`uid` ASC, `month` ASC, `status` ASC),
    PRIMARY KEY (`id`),
    CONSTRAINT `fk_atten_month_people1`
    FOREIGN KEY (`uid`)
    REFERENCES `people` (`uid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    CONSTRAINT `fk_atten_month_groups1`
    FOREIGN KEY (`gid`)
    REFERENCES `groups` (`gid`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8
    COMMENT =  'Attendance summary by month';



-- -----------------------------------------------------
-- Table `people_pam`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `people_pam` (
    `uid` INT(10) UNSIGNED NOT NULL COMMENT  'people.uid',
    `id` INT(10) UNSIGNED NOT NULL COMMENT 'pamsettings.id',
    PRIMARY KEY (`uid`, `id`),
    INDEX `fk_people_has_pamsettings_pamsettings1_idx` (`id` ASC),
    INDEX `fk_people_has_pamsettings_people1_idx` (`uid` ASC),
    CONSTRAINT `fk_people_has_pamsettings_people1`
    FOREIGN KEY (`uid`)
    REFERENCES `people` (`uid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    CONSTRAINT `fk_people_has_pamsettings_pamsettings1`
    FOREIGN KEY (`id`)
    REFERENCES `pamsettings` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8
    COMMENT =  'priradenie zamestnancov k exportom do PaM';



-- -----------------------------------------------------
-- --------------  CATERING SYSTEM  --------------------
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Table `cat_alergens`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cat_alergens` (
    `alergenID` int(10) unsigned NOT NULL AUTO_INCREMENT,
    `title` varchar(64) NOT NULL,
    `description` text,
    PRIMARY KEY (`alergenID`),
    UNIQUE KEY `id_UNIQUE` (`alergenID`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- -----------------------------------------------------
-- Table `cat_types`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cat_types` (
    `typeID` int(10) unsigned NOT NULL AUTO_INCREMENT,
    `name` varchar(64) NOT NULL,
    `position` tinyint(3) unsigned DEFAULT NULL,
    `informative` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT  'Food type is not orderable (only informative)',
    PRIMARY KEY (`typeID`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='food types';

-- -----------------------------------------------------
-- Table `cat_suppliers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cat_suppliers` (
    `supplierID` int(10) unsigned NOT NULL AUTO_INCREMENT,
    `name` varchar(64) NOT NULL,
    `description` text,
    `deadline` time NOT NULL,
    `color` varchar(45) DEFAULT NULL,
    `shortcut` varchar(5) DEFAULT NULL,
    `daysto` INT(10) UNSIGNED NOT NULL DEFAULT 1,
    PRIMARY KEY (`supplierID`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- -----------------------------------------------------
-- Table `cat_suppliermails`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cat_suppliermails` (
    `supplierMailID` int(10) unsigned NOT NULL AUTO_INCREMENT,
    `supplierID` int(10) unsigned NOT NULL,
    `mail` varchar(64) NOT NULL,
    PRIMARY KEY (`supplierMailID`),
    UNIQUE KEY `supplierMailID_UNIQUE` (`supplierMailID`),
    KEY `fk_cat_supplierMails_cat_suppliers1_idx` (`supplierID`),
    CONSTRAINT `fk_cat_supplierMails_cat_suppliers1` FOREIGN KEY (`supplierID`) REFERENCES `cat_suppliers` (`supplierID`) ON DELETE NO ACTION ON UPDATE NO ACTION
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- -----------------------------------------------------
-- Table `cat_foods`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cat_foods` (
    `foodID` int(10) unsigned NOT NULL AUTO_INCREMENT,
    `typeID` int(10) unsigned NOT NULL,
    `supplierID` int(10) unsigned DEFAULT NULL,
    `name` varchar(64) NOT NULL,
    `description` text,
    `picture` blob,
    `price` decimal(10,2) NOT NULL,
    PRIMARY KEY (`foodID`),
    UNIQUE KEY `foodID_UNIQUE` (`foodID`),
    KEY `fk_cat_foods_cat_types_idx` (`typeID`),
    KEY `fk_cat_foods_cat_suppliers1_idx` (`supplierID`),
    CONSTRAINT `fk_cat_foods_cat_suppliers1` FOREIGN KEY (`supplierID`) REFERENCES `cat_suppliers` (`supplierID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT `fk_cat_foods_cat_types` FOREIGN KEY (`typeID`) REFERENCES `cat_types` (`typeID`) ON DELETE NO ACTION ON UPDATE NO ACTION
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- -----------------------------------------------------
-- Table `cat_foodalergen`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cat_foodalergen` (
    `foodID` int(10) unsigned NOT NULL,
    `alergenID` int(10) unsigned NOT NULL,
    PRIMARY KEY (`foodID`,`alergenID`),
    KEY `fk_cat_foodAlergen_cat_alergens1_idx` (`alergenID`),
    KEY `fk_cat_foodAlergen_cat_foods1_idx` (`foodID`),
    CONSTRAINT `fk_cat_foodAlergen_cat_foods1` FOREIGN KEY (`foodID`) REFERENCES `cat_foods` (`foodID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT `fk_cat_foodAlergen_cat_alergens1` FOREIGN KEY (`alergenID`) REFERENCES `cat_alergens` (`alergenID`) ON DELETE NO ACTION ON UPDATE NO ACTION
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- -----------------------------------------------------
-- Table `cat_orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cat_orders` (
    `orderID` int(10) unsigned NOT NULL AUTO_INCREMENT,
    `orderableID` int(10) unsigned NOT NULL,
    `uid` int(10) unsigned NOT NULL,
    `quantity` tinyint(3) unsigned NOT NULL DEFAULT '1',
    `ordered` varchar(45) DEFAULT NULL,
    `delivered` timestamp NULL DEFAULT NULL,
    PRIMARY KEY (`orderID`),
    KEY `delivered` (`delivered`),
    KEY `fk_cat_orders_people1_idx` (`uid`),
    KEY `fk_cat_orders_cat_orderables1_idx` (`orderableID`),
    CONSTRAINT `fk_cat_orders_people1` FOREIGN KEY (`uid`) REFERENCES `people` (`uid`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT `fk_cat_orders_cat_orderables1` FOREIGN KEY (`orderableID`) REFERENCES `cat_orderables` (`orderableID`) ON DELETE NO ACTION ON UPDATE NO ACTION
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='food orders of employees';

-- -----------------------------------------------------
-- Table `cat_orderables`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cat_orderables` (
    `orderableID` int(10) unsigned NOT NULL AUTO_INCREMENT,
    `foodID` int(10) unsigned NOT NULL,
    `segmentID` int(10) unsigned NOT NULL,
    `bid` smallint(5) unsigned DEFAULT NULL,
    `date` date DEFAULT NULL,
    `position` tinyint(3) unsigned DEFAULT NULL,
    `price` decimal(10,2) NOT NULL,
    `locked` tinyint(3) unsigned DEFAULT '0',
    `sent` tinyint(3) unsigned DEFAULT '0',
    `limit` INT(10) UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (`orderableID`),
    KEY `fk_cat_menus_cat_foods1_idx` (`foodID`),
    KEY `date` (`date`),
    KEY `fk_cat_orderables_cat_segments1_idx` (`segmentID`),
    KEY `fk_cat_orderables_branches1_idx` (`bid`),
    CONSTRAINT `fk_cat_menus_cat_foods1` FOREIGN KEY (`foodID`) REFERENCES `cat_foods` (`foodID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT `fk_cat_orderables_cat_segments1` FOREIGN KEY (`segmentID`) REFERENCES `cat_segments` (`segmentID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT `fk_cat_orderables_branches1` FOREIGN KEY (`bid`) REFERENCES `branches` (`bid`) ON DELETE NO ACTION ON UPDATE NO ACTION
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='items of food menu';

-- -----------------------------------------------------
-- Table `cat_segments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cat_segments` (
    `segmentID` int(10) unsigned NOT NULL AUTO_INCREMENT,
    `name` varchar(64) NOT NULL,
    `start` time DEFAULT NULL,
    `stop` time DEFAULT NULL,
    `position` tinyint(3) unsigned DEFAULT NULL,
    PRIMARY KEY (`segmentID`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- -----------------------------------------------------
-- Table `cat_supplierbranch`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cat_supplierbranch` (
    `supplierID` int(10) unsigned NOT NULL,
    `bid` smallint(5) unsigned DEFAULT NULL,
    UNIQUE KEY `onecopy` (`supplierID`,`bid`),
    KEY `fk_cat_supplierBranch_branches1_idx` (`bid`),
    KEY `Fk supplierID suppliers SupplierID` (`supplierID`),
    CONSTRAINT `FK supplierID` FOREIGN KEY (`supplierID`) REFERENCES `cat_suppliers` (`supplierID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT `FK bid` FOREIGN KEY (`bid`) REFERENCES `branches` (`bid`) ON DELETE NO ACTION ON UPDATE NO ACTION
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- -----------------------------------------------------
-- Table `cat_branchmails`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cat_branchmails` (
    `branchMailID` int(10) unsigned NOT NULL AUTO_INCREMENT,
    `bid` smallint(5) unsigned DEFAULT NULL,
    `mail` varchar(45) NOT NULL,
    PRIMARY KEY (`branchMailID`),
    UNIQUE KEY `branchMailID_UNIQUE` (`branchMailID`),
    KEY `fk_cat_branchMails_branches1_idx` (`bid`),
    CONSTRAINT `fk_cat_branchMails_branches1` FOREIGN KEY (`bid`) REFERENCES `branches` (`bid`) ON DELETE NO ACTION ON UPDATE NO ACTION
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- -----------------------------------------------------
-- Table `cat_promailsdelay`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cat_promailsdelay` (
    `proMailDelayID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    `supplierID` INT(10) UNSIGNED NOT NULL,
    `sendtime` TIME NOT NULL,
    `daysto` INT(10) UNSIGNED NOT NULL,
    PRIMARY KEY (`proMailDelayID`),
    INDEX `fk_cat_proMailsDelay_cat_suppliers1_idx` (`supplierID` ASC),
    CONSTRAINT `fk_cat_proMailsDelay_cat_suppliers1`
    FOREIGN KEY (`supplierID`)
    REFERENCES `cat_suppliers` (`supplierID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8;


--
-- Dumping data for table `vars`
--
INSERT IGNORE INTO `vars` (`name`, `value`) VALUES
('ver_db', '22.03.21'),
('ver_ams', '1.1.04'),
('needRecalculate', 0),
('colorGroups', '#663300,#009900,#ff9900,#cc0000,#cc0099,#663399,#0033cc,#03979f'),
('lastEntranceTime', 0);


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
--
-- Dumping data for table `admins`
--

INSERT INTO `admins` (`login`, `pass`, `created`, `creator`, `edited`, `editor`, `status`, `perms`) VALUES
                                                                                                        ('admin', NULL, UNIX_TIMESTAMP(), 0, NULL, NULL, 2, 65535),
                                                                                                        ('SYSTEM', '*66E640492E3555FEADBB69BC0DAD74978271219B', UNIX_TIMESTAMP(), 0, NULL, NULL, 2, 65535);

UPDATE  `admins` SET aid=0 WHERE login='SYSTEM';

ALTER TABLE `admins` AUTO_INCREMENT =2;


DELIMITER $$

-- -----------------------------------------------------
-- function getSaldo
-- -----------------------------------------------------

DROP FUNCTION IF EXISTS `getSaldo`  $$
CREATE FUNCTION `getSaldo` (`userID` int unsigned, `dayEnd` int unsigned) RETURNS int
    RETURN (SELECT a2.saldo FROM people p JOIN atten a2 USING(uid) WHERE a2.uid = userID AND a2.date < IF(p.end IS NOT NULL AND p.end < dayEnd, p.end, dayEnd) AND a2.saldo IS NOT NULL ORDER BY a2.date DESC LIMIT 1)$$


-- -----------------------------------------------------
-- function midnightFromTs
-- -----------------------------------------------------

DROP FUNCTION IF EXISTS `midnightFromTs` $$
CREATE FUNCTION `midnightFromTs`(ts int unsigned) RETURNS int(10) unsigned
RETURN UNIX_TIMESTAMP( FROM_UNIXTIME(ts, '%Y%m%d' ))$$


-- -----------------------------------------------------
-- function pidToUid
-- -----------------------------------------------------

DROP FUNCTION IF EXISTS `pidToUid` $$
CREATE FUNCTION `pidToUid`(`dochId` INT UNSIGNED ) RETURNS int(10) unsigned
BEGIN
  DECLARE ret INT UNSIGNED;

SELECT uid INTO ret FROM people WHERE pid=dochId LIMIT 1;

IF ret is NULL THEN
    SET ret=0;
END IF;

RETURN ret;
END$$


-- -----------------------------------------------------
-- function tidFromMac
-- -----------------------------------------------------

DROP FUNCTION IF EXISTS `tidFromMac` $$
CREATE FUNCTION `tidFromMac`(`macAddr` VARCHAR(30)  CHARACTER SET 'utf8') RETURNS int(10) unsigned
RETURN (SELECT tid FROM term WHERE mac COLLATE utf8_slovak_ci = macAddr COLLATE utf8_slovak_ci LIMIT 1)$$


-- -----------------------------------------------------
-- function tidFromName
-- -----------------------------------------------------

DROP FUNCTION IF EXISTS `tidFromName` $$
CREATE FUNCTION `tidFromName`(`termName` VARCHAR(50)  CHARACTER SET 'utf8') RETURNS int(10) unsigned
RETURN (SELECT tid FROM term WHERE name COLLATE utf8_slovak_ci = termName COLLATE utf8_slovak_ci LIMIT 1)$$


-- -----------------------------------------------------
-- procedure setLastcalc
-- -----------------------------------------------------
DROP PROCEDURE IF EXISTS `setLastCalc` $$
CREATE PROCEDURE `setLastCalc` (`UserId` INT UNSIGNED, `IntId` INT UNSIGNED, `Typ` TINYINT(4), `intts` INT UNSIGNED)
BEGIN

DECLARE ts INT unsigned;
DECLARE fromts INT unsigned;
DECLARE hasNext TINYINT(1) unsigned;

SET fromts = intts -86400;

IF Typ = 1 then
SELECT `next` FROM `inters` WHERE iid = IntId INTO hasNext;

IF hasNext = 1 then
SELECT `date`-86400 FROM `inters_data` WHERE uid=UserId AND `date` < intts ORDER BY `date` DESC LIMIT 1 INTO fromts;
end if;

end if;

SELECT midnightFromTs(fromts) INTO ts;

UPDATE people SET lastCalc = ts WHERE uid=UserId AND lastCalc > ts;

END
$$

-- -----------------------------------------------------
-- function getPresent
-- -----------------------------------------------------
DROP FUNCTION IF EXISTS `getPresent` $$
CREATE FUNCTION `getPresent` (aUid int unsigned) RETURNS INT unsigned
NOT DETERMINISTIC
BEGIN
	DECLARE ret int unsigned;

SELECT IF(`date` >= (UNIX_TIMESTAMP() - 86400) AND  (type=1 OR (type=0 AND id.iid != 1 AND i.aliasWork !=1 AND present = 1)), id.id, 0)
FROM `inters_data` id JOIN `inters` i ON id.iid = i.iid
WHERE `uid` = aUid AND `del`=0 AND i.ignorePresent = 0 AND (`date` <= UNIX_TIMESTAMP() + 900)
ORDER BY `date` DESC LIMIT 1 INTO ret;

IF (ret IS NULL) then
		  SET ret = 0;
END IF;

RETURN ret;
END
$$


-- -----------------------------------------------------
-- procedure updateTermsSync
-- -----------------------------------------------------
DROP PROCEDURE IF EXISTS `updateTermsSync` $$
CREATE PROCEDURE `updateTermsSync` (IN `aUid` int unsigned, IN `aSync` tinyint unsigned)
BEGIN
  DROP TEMPORARY TABLE IF EXISTS tmptbl_updateTermsSync;
  CREATE TEMPORARY TABLE tmptbl_updateTermsSync AS (SELECT pt.tid FROM people_term pt JOIN term t ON pt.tid = t.tid WHERE t.status = 1 AND uid = aUid AND (t.flags & aSync) = aSync);

UPDATE `term` SET `syn` = (`syn` | aSync ) WHERE `tid` IN (SELECT tid FROM tmptbl_updateTermsSync);

IF (aSync & 4) THEN
    INSERT INTO `term_sync` (tid, type, ref, ref_col, ref_id, created, flags) SELECT tid, 'U' type, 'people' ref, 'uid' ref_col, aUid ref_id, UNIX_TIMESTAMP() created, 4 flags FROM tmptbl_updateTermsSync;
END IF;

  IF (aSync & 8) THEN
    INSERT INTO `term_sync` (tid, type, ref, ref_col, ref_id, created, flags) SELECT tid, 'U' type, 'people' ref, 'uid' ref_col, aUid ref_id, UNIX_TIMESTAMP() created, 8 flags FROM tmptbl_updateTermsSync;
END IF;

  DROP TEMPORARY TABLE IF EXISTS tmptbl_updateTermsSync;
END
$$

DELIMITER ;

DROP FUNCTION IF EXISTS `monthFromTimestamp`;
CREATE FUNCTION `monthFromTimestamp` (`ts` int unsigned) RETURNS int unsigned
RETURN DATE_FORMAT(FROM_UNIXTIME(ts), '%Y%m') ;

DROP FUNCTION IF EXISTS `getCurrentGid`;
DELIMITER $$
CREATE FUNCTION `getCurrentGid` (`aUid` int unsigned, `month` int unsigned, `defaultGid` int unsigned) RETURNS int unsigned
BEGIN
  DECLARE `g` INT UNSIGNED;

SELECT gid FROM groups_plan WHERE uid = aUid AND since <= IF(`month` IS NULL OR `month` = 0, DATE_FORMAT(NOW(), '%Y%m'), `month`) ORDER BY since DESC LIMIT 1 INTO `g`;

RETURN IF(`g` IS NULL OR `g` = 0, `defaultGid`, `g`);
END$$
DELIMITER ;
--
-- TRIGGERS
--


DELIMITER $$

DROP TRIGGER IF EXISTS `t_admins_perms_BINS` $$
CREATE TRIGGER `t_admins_perms_BINS` BEFORE INSERT ON `admins_perms` FOR EACH ROW
    SET NEW.created = UNIX_TIMESTAMP();
$$

DROP TRIGGER IF EXISTS `t_groups_BINS` $$
CREATE TRIGGER `t_groups_BINS` BEFORE INSERT ON `groups` FOR EACH ROW
    SET NEW.created = UNIX_TIMESTAMP();
$$

DROP TRIGGER IF EXISTS `t_people_BINS` $$
CREATE TRIGGER `t_people_BINS` BEFORE INSERT ON `people` FOR EACH ROW
    SET NEW.created = UNIX_TIMESTAMP();
$$

DROP TRIGGER IF EXISTS `t_people_au` $$
CREATE TRIGGER `t_people_au` AFTER UPDATE ON `people` FOR EACH ROW
BEGIN
    IF (OLD.saldo != NEW.saldo) THEN
    CALL updateTermsSync(NEW.uid, 4);
END IF;

IF (OLD.present != NEW.present) THEN
    CALL updateTermsSync(NEW.uid, 8);
END IF;
END$$


DROP TRIGGER IF EXISTS `t_inters_BINS` $$
CREATE TRIGGER `t_inters_BINS` BEFORE INSERT ON `inters` FOR EACH ROW
    SET NEW.created = UNIX_TIMESTAMP();
$$

DROP TRIGGER IF EXISTS `t_AD_inters_data` $$
CREATE
    TRIGGER `t_AD_inters_data`
    AFTER DELETE ON `inters_data`
    FOR EACH ROW
BEGIN
    CALL setLastCalc(OLD.uid, OLD.iid, OLD.type, OLD.date);

    IF (OLD.date <= UNIX_TIMESTAMP() + 900) THEN
    UPDATE people set present = getPresent(OLD.uid) WHERE uid = OLD.uid;
END IF;

UPDATE `vars` SET `value` = UNIX_TIMESTAMP() WHERE `name` = 'lastEntranceTime';

END$$

DROP TRIGGER IF EXISTS `t_AI_inters_data` $$
CREATE
    TRIGGER `t_AI_inters_data`
    AFTER INSERT ON `inters_data`
    FOR EACH ROW
BEGIN
    CALL setLastCalc(NEW.uid, NEW.iid, NEW.type, NEW.date);

    IF (NEW.date <= UNIX_TIMESTAMP() + 900) THEN
    UPDATE people set present = getPresent(NEW.uid) WHERE uid = NEW.uid;
END IF;

UPDATE `vars` SET `value` = UNIX_TIMESTAMP() WHERE `name` = 'lastEntranceTime';

END$$

DROP TRIGGER IF EXISTS `t_AU_inters_data` $$
CREATE
    TRIGGER `t_AU_inters_data`
    AFTER UPDATE ON `inters_data`
    FOR EACH ROW
BEGIN
    CALL setLastCalc(NEW.uid, NEW.iid, NEW.type, NEW.date);

    IF (NEW.date <= UNIX_TIMESTAMP() + 900) THEN
    UPDATE people set present = getPresent(NEW.uid) WHERE uid = NEW.uid;
END IF;

UPDATE `vars` SET `value` = UNIX_TIMESTAMP() WHERE `name` = 'lastEntranceTime';

END$$

DROP TRIGGER IF EXISTS `t_admins_perms_BINS` $$
CREATE TRIGGER `t_admins_perms_BINS` BEFORE INSERT ON `admins_perms` FOR EACH ROW
    SET NEW.created = UNIX_TIMESTAMP();
$$


DELIMITER ;

--
-- Dumping data for table `inters`
--
INSERT IGNORE INTO `inters` (`iid`, `name`, `shortcut`, `weight`, `start`, `stop`, `color`, `work`, `locked`, `lunch`, `next`, `weekend`, `saldo`,
                      `flexi`, `autoentry`, `autoleave`, `autoentry_val`, `autoleave_val`, `durat`, `ignor`, `present`, `vouchers`,
                      `created`, `creator`, `edited`, `editor`, `request`) VALUES
(1,	'Práca',	        'P',    -10,    '',	'',	'#00aa00',	1,	1,	1,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	1,	1,	1422899847,	1,	NULL,	NULL, 0),
(2,	'Obed',                 'O',	0,	'',	'',	'#ffff00',	0,	1,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	1422899847,	1,	NULL,	NULL, 0),
(3,	'Dovolenka',            'D',	0,	'',	'',	'#55aaff',	0,	1,	0,	1,	0,	1,	0,	1,	1,	0,	0,	0,	0,	0,	0,	1422899847,	1,	NULL,	NULL, 1),
(4,	'Služobná cesta',	'SLC',  0,	'',	'',	'#05c89e',	1,	1,	0,	1,	0,	0,	0,	1,	0,	0,	0,	1,	0,	1,	1,	1422899847,	1,	NULL,	NULL, 0),
(5,	'Služobne',             'SL',	0,	'',	'',	'#00e8aa',	1,	1,	1,	1,	0,	0,	0,	1,	2,	0,	0,	0,	0,	1,	1,	1422899847,	1,	NULL,	NULL, 0),
(6,	'Súkromne',             'SU',	0,	'',	'',	'#ffaa7f',	0,	1,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	1422899847,	1,	NULL,	NULL, 0),
(7,	'Paragraf',             '§',	0,	'',	'',	'#ff00ff',	0,	1,	0,	0,	0,	1,	0,	1,	2,	0,	0,	0,	0,	0,	0,	1422899847,	1,	NULL,	NULL, 0),
(8,	'Lekár',	        'L',	0,	'',	'',	'#ffaaff',	0,	1,	0,	1,	0,	1,	0,	1,	2,	0,	0,	0,	0,	0,	0,	1422899847,	1,	NULL,	NULL, 0),
(9,	'Náhradné voľno',       'NV',	0,	'',	'',	'#00ffff',	0,	1,	0,	1,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	1422899847,	1,	NULL,	NULL, 0),
(10,	'Študijné voľno',	'SV',	0,	'',	'',	'#6355ff',	0,	1,	0,	1,	0,	0,	0,	1,	1,	0,	0,	0,	0,	0,	0,	1422899847,	1,	NULL,	NULL, 0),
(11,	'Verejný záujem',	'VZ',	0,	'',	'',	'#9575ff',	0,	1,	0,	0,	0,	0,	0,	1,	2,	0,	0,	0,	0,	0,	0,	1422899847,	1,	NULL,	NULL, 0),
(12,	'Fajčenie',             'F',	0,	'',	'',	'#aa5500',	0,	1,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	1422899847,	1,	NULL,	NULL, 0),
(13,	'Lekár doprovod',	'LD',	0,	'',	'',	'#55ff7f',	0,	1,	0,	1,	0,	1,	0,	1,	2,	0,	0,	0,	0,	0,	0,	1422899847,	1,	NULL,	NULL, 0),
(14,	'OČR',                  'OCR',  0,	'',	'',	'#aaff00',	0,	1,	0,	1,	1,	1,	0,	1,	1,	0,	0,	0,	0,	0,	0,	1422899847,	1,	NULL,	NULL, 0),
(15,	'PN',                   'PN',	0,	'',	'',	'#ffaa00',	0,	1,	0,	1,	1,	1,	0,	0,	1,	0,	0,	0,	0,	0,	0,	1422899847,	1,	NULL,	NULL, 0);
--
-- Dumping data for table `holidays`
--

INSERT IGNORE INTO `holidays` (`date`, `name`) VALUES
(1546297200, 'Deň vzniku Slovenskej republiky'),
(1546729200, 'Zjavenie Pána'),
(1555624800, 'Veľký piatok'),
(1555884000, 'Veľkonočný pondelok'),
(1556661600, 'Sviatok práce'),
(1557266400, 'Deň víťazstva nad fašizmom'),
(1562277600, 'Sviatok svätého Cyrila a Metoda'),
(1567029600, 'Výročie Slovenského národného povstania'),
(1567288800, 'Deň ústavy Slovenskej republiky'),
(1568498400, 'Sedembolestná Panna Mária'),
(1572562800, 'Sviatok všetkých svätých'),
(1573945200, 'Deň boja za slobodu a demokraciu'),
(1577142000, 'Štedrý deň'),
(1577228400, 'Prvý sviatok vianočný'),
(1577314800, 'Druhý sviatok vianočný'),
(1577833200, 'Deň vzniku Slovenskej republiky'),
(1578265200, 'Zjavenie Pána'),
(1586469600, 'Veľký piatok'),
(1586728800, 'Veľkonočný pondelok'),
(1588284000, 'Sviatok práce'),
(1588888800, 'Deň víťazstva nad fašizmom'),
(1593900000, 'Sviatok svätého Cyrila a Metoda'),
(1598652000, 'Výročie Slovenského národného povstania'),
(1598911200, 'Deň ústavy Slovenskej republiky'),
(1600120800, 'Sedembolestná Panna Mária'),
(1604185200, 'Sviatok všetkých svätých'),
(1605567600, 'Deň boja za slobodu a demokraciu'),
(1608764400, 'Štedrý deň'),
(1608850800, 'Prvý sviatok vianočný'),
(1608937200, 'Druhý sviatok vianočný');
INSERT IGNORE INTO `cat_alergens` (`alergenID`, `title`, `description`) VALUES (1, 'obilniny obsahujúce lepok', 'obilniny obsahujúce lepok ( t.j. pšenica, raž, jačmeň, ovos, špalda, kamut alebo ich hybridné odrody ) a výrobky z nich okrem :\na)pšeničných  glukózových sirupov vrátane dextrózy, ako aj výrobky z nich, ak proces, ktorému sa podrobili, pravdepodobne nezvýši stupeň alergénnosti určený Európskym úradom pre bezpečnosť potravín pre výrobok, z ktorého pochádzajú, \nb)pšeničných maltodextrín, ako aj výrobky z nich, ak proces, ktorému sa podrobili, pravdepodobne nezvýši stupeň alergénnosti určený Európskym úradom pre bezpečnosť potravín pre výrobok, z ktorého pochádzajú, \nc)jačmenného glukózového sirupu, obilnín používaných na výrobu destilátov alebo etylalkoholu poľnohospodárskeho pôvodu určeného na liehoviny a iné alkoholické nápoje.');
INSERT IGNORE INTO `cat_alergens` (`alergenID`, `title`, `description`) VALUES (2, 'kôrovce', 'kôrovce a výrobky z nich');
INSERT IGNORE INTO `cat_alergens` (`alergenID`, `title`, `description`) VALUES (3, 'vajcia', 'vajcia a výrobky z nich');
INSERT IGNORE INTO `cat_alergens` (`alergenID`, `title`, `description`) VALUES (4, 'ryby', 'ryby a výrobky z nich okrem :\na)rybacej želatíny používanej ako nosičvitamínov alebo karotenoidových prípravkov, \nb)rybacej želatíny alebo rybacieho gleja používaných na čírenie piva a vína.');
INSERT IGNORE INTO `cat_alergens` (`alergenID`, `title`, `description`) VALUES (5, 'arašidy', 'arašidy a výrobky z nich');
INSERT IGNORE INTO `cat_alergens` (`alergenID`, `title`, `description`) VALUES (6, 'sójové zrná', 'sójové zrná a výrobky z nich okrem :\na)úplne rafinovaného sójového oleja a tuku, ako aj výrobky z nich, ak proces, ktorému sa podrobili, pravdepodobne nezvýši stupeň alergénnosti určený  Európskym úradom pre bezpečnosť potravín pre výrobok, z ktorého pochádzajú, \nb)prírodných zmesných tokoferolov (E 306), prírodného D-alfa-tokoferolu, prírodného D-alfatokoferolacetátu, prírodného D-alfa-tokoferolsukcinátu sójového pôvodu, \nc)fytosterolov a esterov fytosterolov získaných z rastlinných olejov sójového pôvodu, \nd)fytostanolesteru získaného zo sterolov rastlinného oleja sójového pôvodu.');
INSERT IGNORE INTO `cat_alergens` (`alergenID`, `title`, `description`) VALUES (7, 'mlieko', 'mlieko a výrobky z neho, vrátane laktózy okrem:\na)srvátky používanej na výrobu destilátov alebo etylalkoholu poľnohospodárskeho pôvodu určeného na liehoviny a iné alkoholické nápoje, \nb)laktitolu');
INSERT IGNORE INTO `cat_alergens` (`alergenID`, `title`, `description`) VALUES (8, 'orechy', 'orechy, ktorými sú mandle, lieskové orechy, vlašské orechy, kešu, pekanové orechy, para  orechy,  pistácie,  makadamové  orechy  a  queenslandské  orechy  a  výrobky  z  nich okrem :\n- orechov, ktoré sú používané na výrobu destilátov');
INSERT IGNORE INTO `cat_alergens` (`alergenID`, `title`, `description`) VALUES (9, 'zeler', 'zeler a výrobky z neho');
INSERT IGNORE INTO `cat_alergens` (`alergenID`, `title`, `description`) VALUES (10, 'horčica', 'horčica a výrobky z nej');
INSERT IGNORE INTO `cat_alergens` (`alergenID`, `title`, `description`) VALUES (11, 'sezamové semená', 'sezamové semená a výrobky z nich');
INSERT IGNORE INTO `cat_alergens` (`alergenID`, `title`, `description`) VALUES (12, 'oxid siričitý a siričitany', 'oxid siričitý a siričitany v koncentráciách vyšších ako 10 mg/ kg alebo 10mg/l ');
INSERT IGNORE INTO `cat_alergens` (`alergenID`, `title`, `description`) VALUES (13, 'vlčí bôb', 'vlčí bôb a výrobky z neho');
INSERT IGNORE INTO `cat_alergens` (`alergenID`, `title`, `description`) VALUES (14, 'mäkkýše', 'mäkkýše a výrobky z nich');

INSERT IGNORE INTO `cat_types` (`typeID`, `name`, `position`) VALUES
(1, 'Polievka', 1),
(2, 'Hlavné jedlo', 2);

INSERT IGNORE INTO `cat_suppliers` (`supplierID`, `name`, `description`, `deadline`, `color`, `shortcut`, `daysto`) VALUES
(1,	'dodávateľ 1',	'',	'00:00:00',	NULL,	'',	0);


INSERT IGNORE INTO `cat_segments` (`segmentID`, `name`, `start`, `stop`, `position`) VALUES
(1,	'obed',	'11:00:00',	'13:00:00',	1);
