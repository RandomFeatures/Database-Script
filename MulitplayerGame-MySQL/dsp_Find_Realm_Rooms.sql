USE lands;
DELIMITER $$

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

DELIMITER ;

