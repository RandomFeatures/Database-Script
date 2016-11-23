USE mylife_game;
DELIMITER $$

DROP PROCEDURE IF EXISTS `mylife_static`.`dsp_config_getvalue` $$
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_static`.`dsp_config_getvalue` (Key_Name varchar(25), Game_ID int, Source_Type int)
BEGIN

     IF (Game_ID IS NULL AND Source_Type IS NOT NULL) THEN
          SELECT
                ConfigValue
          FROM
                tbl_Config
          WHERE
               KeyName = Key_Name
          AND
               GameID is NULL
          AND
               SourceType = Source_Type
          AND
               Active = 1;
     ELSEIF (Game_ID IS NOT NULL AND Source_Type IS NULL) THEN
          SELECT
                ConfigValue
          FROM
                tbl_Config
          WHERE
               KeyName = Key_Name
          AND
               GameID = Game_ID
          AND
               SourceType is NULL
          AND
               Active = 1;
     ELSEIF (Game_ID IS NOT NULL AND Source_Type IS NOT NULL)  THEN
          SELECT
                ConfigValue
          FROM
                tbl_Config
          WHERE
               KeyName = Key_Name
          AND
               GameID = Game_ID
          AND
               SourceType = Source_Type
          AND
               Active = 1;
     ELSEIF (Game_ID IS NULL AND Source_Type IS NULL) THEN
          SELECT
                ConfigValue
          FROM
                tbl_Config
          WHERE
               KeyName = Key_Name
          AND
               GameID is NULL
          AND
               SourceType is NULL
          AND
               Active = 1;
     END IF;



END $$



DELIMITER ;

