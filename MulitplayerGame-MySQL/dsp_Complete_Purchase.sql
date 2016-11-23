USE lands;
DELIMITER $$

DROP PROCEDURE IF EXISTS lands.dsp_Complete_Purchase $$
CREATE DEFINER=`lands_game`@`%` PROCEDURE lands.`dsp_Complete_Purchase`(purchase varchar(1000))
BEGIN

SET @s = CONCAT('UPDATE ' , purchase );
PREPARE stmt FROM @s;
EXECUTE stmt;

END $$

DROP PROCEDURE IF EXISTS lands.dsp_Find_Adventure $$
CREATE DEFINER=`lands_game`@`%` PROCEDURE lands.`dsp_Find_Adventure` (RealmID int )
BEGIN

	DROP TABLE IF EXISTS tmp_skatt;
    CREATE TEMPORARY TABLE tmp_skatt
	(
		randomid INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
        `id` int(11) NOT NULL,
        `Realm` mediumtext
    );
    
    
    INSERT INTO tmp_skatt(id, Realm)
    SELECT 
            id,
			Realm
    FROM 
         	lands.tbl_Published_Realm
    WHERE 
			Deleted = 0
	AND
			RoomCount > 2;
    
    SELECT 
            id,
			Realm
    FROM 
            tmp_skatt
    WHERE 
            randomid  = RealmID;
	
    DROP TABLE tmp_skatt;

END$$

DROP PROCEDURE IF EXISTS lands.dsp_Find_Max_Realm $$
CREATE DEFINER=`lands_game`@`%` PROCEDURE lands.`dsp_Find_Max_Realm`( )
BEGIN

    SELECT 
        COUNT(id)
    FROM 
        lands.tbl_Published_Realm
    WHERE
        Deleted = 0
	AND
		RoomCount > 2;


END$$


DROP PROCEDURE IF EXISTS `lands`.`dsp_Find_Realm_Rooms` $$
CREATE DEFINER=`lands_game`@`%` PROCEDURE `dsp_Find_Realm_Rooms`(realmid int)
BEGIN
     
    SELECT 
        r.id, 
        r.RealmID, 
        r.TemplateID, 
        r.GridY, 
        r.GridX, 
        r.`Floor`, 
        t.GridRows, 
        t.GridCols, 
        t.OffsetX, 
        t.OffsetY
    FROM 
        lands.tbl_Player_Rooms r
    JOIN
        lands.tbl_Room_Templates t
    ON
        r.TemplateID = t.id
    WHERE
        r.RealmID = realmid
    AND 
        r.Deleted = 0;
END$$

DROP PROCEDURE IF EXISTS `lands`.`dsp_Find_Room`$$
CREATE DEFINER=`lands_game`@`%` PROCEDURE `dsp_Find_Room`(realmid int, roomid int)
BEGIN
     
    SELECT 
        r.id, 
        r.RealmID, 
        r.TemplateID, 
        r.GridY, 
        r.GridX, 
        r.`Floor`, 
        t.GridRows, 
        t.GridCols, 
        t.OffsetX, 
        t.OffsetY
    FROM 
        lands.tbl_Player_Rooms r
    JOIN
        lands.tbl_Room_Templates t
    ON
        r.TemplateID = t.id
    WHERE
        r.id = roomid
    AND
        r.RealmID = realmid;


END$$


DROP PROCEDURE IF EXISTS lands.dsp_Regen_Power $$
CREATE DEFINER=`lands_game`@`%` PROCEDURE lands.`dsp_Regen_Power`( )
BEGIN

  
	UPDATE 
		lands.tbl_Players 
	SET 
		Energy = Energy + Recharge
	WHERE 
		Energy < MaxEnergy;


END$$


















DELIMITER ;
 
