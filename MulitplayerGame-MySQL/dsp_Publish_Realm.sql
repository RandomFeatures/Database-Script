DROP PROCEDURE IF EXISTS lands.dsp_Publish_Realm;
CREATE PROCEDURE  lands.`dsp_Publish_Realm` (RealmID int, PropertyXML tinytext )
BEGIN

    SELECT @Backup = ActiveRealm FROM lands.tbl_Player_Realmz WHERE id = RealmID;

    UPDATE 
        lands.tbl_Player_Realmz 
    SET 
         OldRealm = @Backup, 
         ActiveRealm = PropertyXML 
    WHERE id = RealmID;

    
END;

