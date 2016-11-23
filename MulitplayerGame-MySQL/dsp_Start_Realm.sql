USE lands;
DELIMITER $$

DROP PROCEDURE IF EXISTS lands.dsp_Start_Realm $$
CREATE DEFINER=`lands_game`@`%` PROCEDURE lands.`dsp_Start_Realm`(iUserID int, iGameID int ,iGender int)
BEGIN

	/*
	Set @ChestRoomTemplateID = 6;
	Set @StartRoomTemplateID = 7;
	*/
	
	SET @random = RAND();
	

	IF (@random < 0.34) THEN
		SET @TmpRealmID = 1;
		SET @TmpStartRoom = 1;
		SET @TmpChestRoom = 2;
		SET @TmpChestX = 1;
		SET @TmpChestY = 0;
		SET @TmpChestDir = 1;	
	END IF;

	IF (@random > 0.33 AND @random < 0.67) THEN
		SET @TmpRealmID = 2;
		SET @TmpStartRoom = 4;
		SET @TmpChestRoom = 3;
		SET @TmpChestX = 3;
		SET @TmpChestY = 3;
		SET @TmpChestDir = 1;	
	END IF;

	IF (@random > 0.66) THEN
		SET @TmpRealmID = 3;
		SET @TmpStartRoom = 6;
		SET @TmpChestRoom = 5;
		SET @TmpChestX = 3;
		SET @TmpChestY = 3;
		SET @TmpChestDir = 1;	
	END IF;




	SELECT @ChestRoomTemplateID := ConfigValue FROM lands.tbl_Config Where KeyName = 'ChestRoomTemplateID';
	SELECT @StartRoomTemplateID := ConfigValue FROM lands.tbl_Config Where KeyName = 'StartRoomTemplateID';
	SELECT @StartRoomDoorID := ConfigValue FROM lands.tbl_Config Where KeyName = 'defaultdoor';
	SELECT @ChestRoomDoorID := ConfigValue FROM lands.tbl_Config Where KeyName = 'doorstepid';


	SELECT @KeeperID := min(id) FROM lands.tbl_Keepers Where Active = 1;
	SELECT @ChestID := min(id) FROM lands.tbl_Chests Where Active = 1;

	SELECT @Playing := count(UserID) FROM lands.tbl_Player_Realmz Where UserID = iUserID and Active = 1;

    if  @Playing = 0 THEN
        /* New Realm */
        INSERT INTO lands.tbl_Player_Realmz
        (UserID, GameID, FloorCount, RoomCount, MonsterCount, TrapCount, GridRows, GridCols, StartRoom, ChestRoom, KeeperID, LastClean, ElaspedTime, KeeperState, ChestID, ChestX, ChestY, ChestDir, RealmLevel, MonsterLevel, TrapLevel, Active) 
        VALUES (iUserID, iGameID, 1, 2, 0, 0, 3, 3, 0, 0, @KeeperID, NOW(), 0, 0, @ChestID, 0, 3, 0, 0, 0, 0, 1);
        SET @RealmID = LAST_INSERT_ID();
    
        
    
        INSERT INTO lands.tbl_Players
        (UserID, RealmID, Gender, Experince, Level, Gold, Bucks, MaxEnergy, Energy, Recharge, BaseID, BaseColor, HairID, HairColor, HeadID, HeadColor, BodyID, BodyColor, MainHandID, MainHandColor, OffHandID, OffHandColor, AccessoryID, AccessoryColor, FaceID, FaceColor) 
		SELECT 
				iUserID, @RealmID, Gender, Experince, Level, Gold, Bucks, Energy, Energy, 1, BaseID, BaseColor, HairID, HairColor, HeadID, HeadColor, BodyID, BodyColor, MainHandID, MainHandColor, OffHandID, OffHandColor, AccessoryID, AccessoryColor, FaceID, FaceColor 
		FROM 
				lands.tbl_Player_Start_Values
		WHERE 
				Gender = iGender;
		
		
		IF iGender = 0 THEN
			INSERT INTO lands.tbl_Player_Inventory
				(UserID, RealmID, ObjectType, ObjectID, Count, Deleted) 
			VALUES 
				(iUserID, @RealmID, 11, 1, 1, 0);
			INSERT INTO lands.tbl_Player_Inventory
				(UserID, RealmID, ObjectType, ObjectID, Count, Deleted) 
			VALUES 
				(iUserID, @RealmID, 11, 199, 1, 0);
			INSERT INTO lands.tbl_Player_Inventory
				(UserID, RealmID, ObjectType, ObjectID, Count, Deleted) 
			VALUES 
				(iUserID, @RealmID, 11, 200, 1, 0);
			INSERT INTO lands.tbl_Player_Inventory
				(UserID, RealmID, ObjectType, ObjectID, Count, Deleted) 
			VALUES 
				(iUserID, @RealmID, 11, 201, 1, 0);
		END IF;

		IF iGender = 1 THEN
		
			INSERT INTO lands.tbl_Player_Inventory
				(UserID, RealmID, ObjectType, ObjectID, Count, Deleted) 
			VALUES 
				(iUserID, @RealmID, 11, 11, 1, 0);
			INSERT INTO lands.tbl_Player_Inventory
				(UserID, RealmID, ObjectType, ObjectID, Count, Deleted) 
			VALUES 
				(iUserID, @RealmID, 11, 202, 1, 0);
			INSERT INTO lands.tbl_Player_Inventory
				(UserID, RealmID, ObjectType, ObjectID, Count, Deleted) 
			VALUES 
				(iUserID, @RealmID, 11, 203, 1, 0);
			INSERT INTO lands.tbl_Player_Inventory
				(UserID, RealmID, ObjectType, ObjectID, Count, Deleted) 
			VALUES 
				(iUserID, @RealmID, 11, 204, 1, 0);
		END IF;

    

		/* New Chest Room */
        INSERT INTO lands.tbl_Player_Rooms
        (RealmID, TemplateID, GridY, GridX, Floor, Deleted, SFXType, SFX, MonsterCount, TrapCount, RoomID) 
        VALUES (@RealmID, @ChestRoomTemplateID, 2, 3, 1, 0, 0, 'SFX', 0, 0, 2);
        SET @ChestRoomID = LAST_INSERT_ID();


    	/* New Start Room */
        INSERT INTO lands.tbl_Player_Rooms
        (RealmID, TemplateID, GridY, GridX, Floor, Deleted, SFXType, SFX, MonsterCount, TrapCount, RoomID) 
        VALUES (@RealmID, @StartRoomTemplateID, 3, 3, 1, 0, 0, 'SFX', 0, 0, 1);
        SET @StartRoomID = LAST_INSERT_ID();
    
        
    
       
    
       /* Walls and floor for Chest Room */
		INSERT INTO lands.tbl_Player_Room_Items
		(RealmID, RoomID, ObjectType, ObjectID, GridX, GridY, Direction, DataType, Data, Deleted) 
		SELECT  @RealmID, @ChestRoomID, ObjectType, ObjectID, GridX, GridY, Direction, DataType, Data, Deleted 
		FROM lands.tbl_Player_Room_Items
		WHERE
			RealmID = @TmpRealmID
		AND 
			RoomID = @TmpChestRoom
		AND 
			ObjectType <> 14;

		/* Walls and floor for Start Room */
		INSERT INTO lands.tbl_Player_Room_Items
		(RealmID, RoomID, ObjectType, ObjectID, GridX, GridY, Direction, DataType, Data, Deleted) 
		SELECT  @RealmID, @StartRoomID, ObjectType, ObjectID, GridX, GridY, Direction, DataType, Data, Deleted 
		FROM lands.tbl_Player_Room_Items
		WHERE
			RealmID = @TmpRealmID
		AND 
			RoomID = @TmpStartRoom
		AND 
			ObjectType <> 14;

		/* connecting doors */
		INSERT INTO lands.tbl_Player_Room_Items
		(RealmID, RoomID, ObjectType, ObjectID, GridX, GridY, Direction, DataType, Data, Deleted) 
		VALUES (@RealmID, @StartRoomID, 14, @StartRoomDoorID, 4, 0, 3, 1, @ChestRoomID, 0);

		INSERT INTO lands.tbl_Player_Room_Items
		(RealmID, RoomID, ObjectType, ObjectID, GridX, GridY, Direction, DataType, Data, Deleted) 
		VALUES (@RealmID, @ChestRoomID, 14, @ChestRoomDoorID, 4, 7, 1, 1, @StartRoomID, 0);

		/* Set the chest and start rooms in the realm */
        UPDATE lands.tbl_Player_Realmz 
        SET  StartRoom = @StartRoomID, 
            ChestRoom = @ChestRoomID,
			ChestX =  @TmpChestX,
			ChestY =  @TmpChestY,
			ChestDir =  @TmpChestDir	 
        WHERE id = @RealmID;

				
    END IF;
END $$

DELIMITER ;

