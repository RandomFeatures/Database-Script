DROP PROCEDURE IF EXISTS lands.dsp_Find_Active_Realm;
CREATE DEFINER=`jbossuser`@`%` PROCEDURE  lands.`dsp_Find_Active_Realm` (RealmID int )
BEGIN

    SELECT 
            ActiveRealm 
    FROM 
            lands.tbl_Player_Realmz 
    WHERE 
            id > (RealmID - 5)
    AND
            id < (RealmID + 5)
    AND
            Active = 1
    LIMIT 1;

END;

