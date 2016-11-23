DROP PROCEDURE IF EXISTS lands.dsp_Find_Random_Realm;
CREATE PROCEDURE lands.`dsp_Find_Random_Realm`( )
BEGIN

  
    SELECT 
        id 
    FROM 
        lands.tbl_Player_Realmz 
    WHERE 
        id >= (SELECT FLOOR( MAX(id) * RAND()) FROM lands.tbl_Player_Realmz) 
    AND 
        Active = 1
    ORDER BY id LIMIT 1;

END;

