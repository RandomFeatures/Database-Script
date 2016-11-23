USE lands;
DELIMITER $$
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

DELIMITER ;
