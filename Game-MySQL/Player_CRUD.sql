USE mylife_player;
DELIMITER GO
--
-- Table: tbl_Player
--

DROP PROCEDURE IF EXISTS `mylife_player`.`dsp_Player_lst` GO

DROP PROCEDURE IF EXISTS `mylife_player`.`dsp_Player_sel` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_player`.`dsp_Player_sel`(kvUserID int)
BEGIN
	
	SET @level = 0;
	SET @thislevel = 0;
	SET @nextlevel = 0;
	-- Get current level
	SELECT 
		 @level := `Level`
	FROM 
		mylife_player.tbl_Player
	WHERE 
		id = kvUserID;
	-- get xp for this level
	SELECT
		@thislevel := XP
	FROM 
		mylife_static.tbl_Level_Progression 
	WHERE
		level =  @level;

	-- get xp for next level
	SELECT
		@nextlevel := XP
	FROM 
		mylife_static.tbl_Level_Progression 
	WHERE
		level =  @level + 1;

	-- get player data
	SELECT 
		UserID,
	    PlayerName,
	    `Level`,
		@thislevel as thislevel,
		@nextlevel as nextlevel,
		Experience,
	    Coins,
	    Bookmarks,
	    JobApproval,
	    Congregation,
	    Capacity,
		Energy,
		MaxEnergy,
		Setup,
	    XRef
	  FROM 
		mylife_player.tbl_Player
	 WHERE 
		UserID= kvUserID;
END;
GO

DROP PROCEDURE IF EXISTS `mylife_player`.`dsp_Player_upd` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_player`.`dsp_Player_upd`(
	kvUserID int,
	kvPlayerName varchar(30),
	kvLevel int,
	kvExperience int,
	kvCoins int,
	kvBookmarks int,
	kvJobApproval int,
	kvCongregation int,
	kvCapacity int,
	kvEnergy int,
	kvMaxEnergy int,
	kvSetup int,
	kvXRef varchar(100))
BEGIN
	DECLARE lcount INT;
	SELECT 
		count(1) 
	INTO 
		lcount
	FROM 
		mylife_player.tbl_Player
	WHERE 
		id = kvUserID;

	IF lcount = 0 THEN
		INSERT INTO mylife_player.tbl_Player(
							UserID,
							PlayerName,
							`Level`,
							Experience,
							Coins,
							Bookmarks,
							JobApproval,
							Congregation,
							Capacity,
							Energy,
							MaxEnergy,
 							Setup,
							XRef)
		VALUES (
				kvUserID,
				kvPlayerName,
				kvLevel,
				kvExperience,
				kvCoins,
				kvBookmarks,
				kvJobApproval,
				kvCongregation,
				kvCapacity,
				kvEnergy,
				kvMaxEnergy,
				kvSetup,
				kvXRef);
	ELSE
		UPDATE 
				mylife_player.tbl_Player
		SET 
			PlayerName = kvPlayerName,
			`Level` = kvLevel,
			Experience = kvExperience,
			Coins = kvCoins,
			Bookmarks = kvBookmarks,
			JobApproval = kvJobApproval,
			Congregation = kvCongregation,
			Capacity = kvCapacity,
			Energy = kvEnergy,
			MaxEnergy = kvMaxEnergy,
			Setup = kvSetup,
			XRef = kvXRef
		WHERE 
			UserID = kvUserID;
	END IF;
END;
GO


DROP PROCEDURE IF EXISTS `mylife_player`.`dsp_Player_Stats_upd` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_player`.`dsp_Player_Stats_upd`(
	kvUserID int,
	kvExperience int,
	kvLevel int,
	kvCoins int,
	kvBookmarks int,
	kvJobApproval int,
	kvCongregation int,
	kvCapacity int,
	kvEnergy int,
	kvSetup int,
	kvMaxEnergy int)
BEGIN
	UPDATE 
		mylife_player.tbl_Player
	SET 
		`Level` = kvLevel,
		Experience = kvExperience,
		Coins = kvCoins,
		Bookmarks = kvBookmarks,
		JobApproval = kvJobApproval,
		Congregation = kvCongregation,
		Capacity = kvCapacity,
		Energy = kvEnergy,
		Setup = kvSetup,
		MaxEnergy = kvMaxEnergy
	WHERE 
		UserID = kvUserID;
END;
GO


--
-- Table: tbl_Player_Achievement
--

DROP PROCEDURE IF EXISTS `mylife_player`.`dsp_Player_Achievement_lst` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_player`.`dsp_Player_Achievement_lst`(kvUserID int)
BEGIN
	SELECT 
		id,
        UserID,
	    AchievementID,
	    Count,
	    Level1,
	    Level2,
	    Level3,
	    Complete,
	    Active
	  FROM 
		mylife_player.tbl_Player_Achievement
	  WHERE 
		UserID = kvUserID;
END;
GO

DROP PROCEDURE IF EXISTS `mylife_player`.`dsp_Player_Achievement_sel` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_player`.`dsp_Player_Achievement_sel`(pkid int)
BEGIN
	SELECT 
		id,
	    UserID,
	    AchievementID,
	    Count,
	    Level1,
	    Level2,
	    Level3,
	    Complete,
	    Active
	 FROM 
		mylife_player.tbl_Player_Achievement
	 WHERE 
		id = pkid;
END;
GO

DROP PROCEDURE IF EXISTS `mylife_player`.`dsp_Player_Achievement_upd` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_player`.`dsp_Player_Achievement_upd`(kvid int,
	kvUserID int,
	kvAchievementID int,
	kvCount int,
	kvLevel1 int,
	kvLevel2 int,
	kvLevel3 int,
	kvComplete bit(1),
	kvActive bit(1))
BEGIN
	DECLARE lcount INT;
	SELECT 
		count(1) 
	INTO 
		lcount
	FROM 
		mylife_player.tbl_Player_Achievement
	WHERE 
		id = kvid;

	IF lcount = 0 THEN
		INSERT INTO mylife_player.tbl_Player_Achievement(
				UserID,
				AchievementID,
				Count,
				Level1,
				Level2,
				Level3,
				Complete,
				Active)
		VALUES (
				kvUserID,
				kvAchievementID,
				kvCount,
				kvLevel1,
				kvLevel2,
				kvLevel3,
				kvComplete,
				kvActive);
	ELSE
		UPDATE 
			mylife_player.tbl_Player_Achievement
		SET 
			Count = kvCount,
			Level1 = kvLevel1,
			Level2 = kvLevel2,
			Level3 = kvLevel3,
			Complete = kvComplete,
			Active = kvActive
		WHERE 
			id = kvid;
	END IF;
END;
GO

DROP PROCEDURE IF EXISTS `mylife_player`.`dsp_Player_Achievement_del` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_player`.`dsp_Player_Achievement_del`(pkid int)
BEGIN
	DELETE FROM 
		mylife_player.tbl_Player_Achievement
	 WHERE 
		id = pkid;
END;
GO
--
-- Table: tbl_Player_Building_Progress
--

DROP PROCEDURE IF EXISTS `mylife_player`.`dsp_Player_Building_Progress_lst` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_player`.`dsp_Player_Building_Progress_lst`(kvUserID int)
BEGIN
	SELECT id,
	       UserID,
	       BuildingID,
	       ChurchID,
	       Item1,
	       Item1Done,
	       Item1Require,$XML_Header
		   Item1BuyNow,
	       Item2,
	       Item2Done,
	       Item2Require,
		   Item2BuyNow,
	       Item3,
	       Item3Done,
	       Item3Require,
		   Item3BuyNow,
	       Item4,
	       Item4Done,
	       Item4Require,
		   Item4BuyNow,
	       Item5,
	       Item5Done,
	       Item5Require,
		   Item5BuyNow,
	       Item6,
	       Item6Done,
	       Item6Require,
		   Item6BuyNow,
	       Complete
	FROM 
		mylife_player.tbl_Player_Building_Progress
	WHERE 
		UserID = kvUserID;
END;
GO

DROP PROCEDURE IF EXISTS `mylife_player`.`dsp_Player_Building_Progress_sel` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_player`.`dsp_Player_Building_Progress_sel`(kvUserID int, kvChurchID int)
BEGIN
	SELECT id,
	       UserID,
	       BuildingID,
	       ChurchID,
		   Item1,
	       Item1Done,
	       Item1Require,
		   Item1BuyNow,
		   Item2,
	       Item2Done,
	       Item2Require,
		   Item2BuyNow,
		   Item3,
	       Item3Done,
	       Item3Require,
		   Item3BuyNow,
		   Item4,
	       Item4Done,
	       Item4Require,
		   Item4BuyNow,
		   Item5,
	       Item5Done,
	       Item5Require,
		   Item5BuyNow,
		   Item6,
	       Item6Done,
	       Item6Require,
		   Item6BuyNow,
	       Complete
	FROM 
		mylife_player.tbl_Player_Building_Progress
	WHERE 
		UserID = kvUserID
	AND
		ChurchID = kvChurchID;
END;
GO

DROP PROCEDURE IF EXISTS `mylife_player`.`dsp_Player_Building_Progress_upd` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_player`.`dsp_Player_Building_Progress_upd`(
	kvUserID int,
	kvBuildingID int,
	kvChurchID int,
	kvItem1 int,
	kvItem1Done int,
	kvItem1Require int,
	kvItem1BuyNow int,
	kvItem2 int,
	kvItem2Done int,
	kvItem2Require int,
	kvItem21BuyNow int,
	kvItem3 int,
	kvItem3Done int,
	kvItem3Require int,
	kvItem3BuyNow int,
	kvItem4 int,
	kvItem4Done int,
	kvItem4Require int,
	kvItem4BuyNow int,
	kvItem5 int,
	kvItem5Done int,
	kvItem5Require int,
	kvItem5BuyNow int,
	kvItem6 int,
	kvItem6Done int,
	kvItem6Require int,
	kvItem6BuyNow int,
	kvComplete bit(1))
BEGIN
	DECLARE lcount INT;
	SELECT 
		count(1) 
	INTO 
		lcount
	FROM 
		mylife_player.tbl_Player_Building_Progress
	WHERE 
		UserID = kvUserID
	AND
		ChurchID = kvChurchID;

	IF lcount = 0 THEN
		INSERT INTO mylife_player.tbl_Player_Building_Progress(
				UserID,
				BuildingID,
				ChurchID,
				Item1,				
				Item1Done,
				Item1Require,
				Item1BuyNow,
				Item2,
				Item2Done,
				Item2Require,
				Item2BuyNow,
				Item3,				
				Item3Done,
				Item3Require,
				Item3BuyNow,
				Item4,
				Item4Done,
				Item4Require,
				Item4BuyNow,
				Item5,
				Item5Done,
				Item5Require,
				Item5BuyNow,
				Item6,
				Item6Done,
				Item6Require,
				Item6BuyNow,
				Complete)
		VALUES (
				kvUserID,
				kvBuildingID,
				kvChurchID,
				kvItem1,
				kvItem1Done,
				kvItem1Require,
				kvItem1BuyNow,
				kvItem2,
				kvItem2Done,
				kvItem2Require,
				kvItem2BuyNow,
				kvItem3,
				kvItem3Done,
				kvItem3Require,
				kvItem3BuyNow,
				kvItem4,
				kvItem4Done,
				kvItem4Require,
				kvItem4BuyNow,
				kvItem5,
				kvItem5Done,
				kvItem5Require,
				kvItem5BuyNow,
				kvItem6,
				kvItem6Done,
				kvItem6Require,
				kvItem6BuyNow,
				kvComplete);
	ELSE
		UPDATE 
			mylife_player.tbl_Player_Building_Progress
		SET 
			ChurchID = kvChurchID,
			Item1Done = kvItem1Done,
			Item2Done = kvItem2Done,
			Item3Done = kvItem3Done,
			Item4Done = kvItem4Done,
			Item5Done = kvItem5Done,
			Item6Done = kvItem6Done,
			Complete = kvComplete
		WHERE 
			UserID = kvUserID
		AND
			ChurchID = kvChurchID;

	END IF;
END;
GO

DROP PROCEDURE IF EXISTS `mylife_player`.`dsp_Player_Building_Progress_del` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_player`.`dsp_Player_Building_Progress_del`(pkid int)
BEGIN
	DELETE FROM 
		mylife_player.tbl_Player_Building_Progress
	 WHERE 
		id = pkid;
END;
GO
--
-- Table: tbl_Player_Building_Recharge
--

DROP PROCEDURE IF EXISTS `mylife_player`.`dsp_Player_Building_Recharge_lst` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_player`.`dsp_Player_Building_Recharge_lst`(kvUserID int)
BEGIN
	SELECT id,
	       UserID,
		   ChurchID,
	       BuildingID,
	       DailyID,
	       RechargeRate,
	       LastUsed,
		   Complete
	FROM 
		mylife_player.tbl_Player_Building_Recharge
	WHERE 
		UserID = kvUserID;
END;
GO

DROP PROCEDURE IF EXISTS `mylife_player`.`dsp_Player_Building_Recharge_sel` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_player`.`dsp_Player_Building_Recharge_sel`(
	kvUserID int,
	kvChurchID int)
BEGIN
	SELECT id,
	       UserID,
		   ChurchID,
	       BuildingID,
	       DailyID,
	       RechargeRate,
	       LastUsed,
		   Complete
	FROM 
		mylife_player.tbl_Player_Building_Recharge
	WHERE 
		UserID = kvUserID
	AND
		ChurchID = kvChurchID;
END;
GO

DROP PROCEDURE IF EXISTS `mylife_player`.`dsp_Player_Building_Recharge_upd` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_player`.`dsp_Player_Building_Recharge_upd`(
	kvUserID int,
	kvChurchID int,
	kvBuildingID int,
	kvDailyID int,
	kvRechargeRate int,
	kvComplete bit(1))
BEGIN
	DECLARE lcount INT;
	SELECT 
		count(1) 
	INTO 
		lcount
	FROM 
		mylife_player.tbl_Player_Building_Recharge
	WHERE 
		UserID = kvUserID
	AND
		ChurchID = kvChurchID;


	IF lcount = 0 THEN
		INSERT INTO mylife_player.tbl_Player_Building_Recharge(
				UserID,
				ChurchID,
				BuildingID,
				DailyID,
				RechargeRate,
				LastUsed,
				Complete)
		VALUES (
				kvUserID,
				kvChurchID,
				kvBuildingID,
				kvDailyID,
				kvRechargeRate,
				Now(),
				0);
	ELSE
		UPDATE 
			mylife_player.tbl_Player_Building_Recharge
		SET 
			ChurchID = kvChurchID,
			DailyID = kvDailyID,
			RechargeRate = kvRechargeRate,
			LastUsed = Now(),
			Complete = kvComplete
		WHERE 
			UserID = kvUserID
		AND
			BuildingID = kvBuildingID
		AND
			DailyID = kvDailyID;
	END IF;
END;
GO

DROP PROCEDURE IF EXISTS `mylife_player`.`dsp_Player_Building_Recharge_del` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_player`.`dsp_Player_Building_Recharge_del`(pkid int)
BEGIN
	DELETE FROM 
		mylife_player.tbl_Player_Building_Recharge
	WHERE 
		id = pkid;
END;
GO
--
-- Table: tbl_Player_Church
--

DROP PROCEDURE IF EXISTS `mylife_player`.`dsp_Player_Church_lst` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_player`.`dsp_Player_Church_lst`(kvUserID int)
BEGIN
	SELECT id,
	       UserID,
	       ItemType,
	       ItemID,
	       GridX,
	       GridY,
		   SubGridX,
		   SubGridY,
	       FacingType,
	       LastUsed,
	       Deleted
	FROM 
		mylife_player.tbl_Player_Church
	WHERE 
		UserID = kvUserID
	AND
		Deleted = 0;
END;
GO

DROP PROCEDURE IF EXISTS `mylife_player`.`dsp_Player_Church_Buildings_lst` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_player`.`dsp_Player_Church_Buildings_lst`(kvUserID int)
BEGIN
	SELECT c.id,
	       c.ItemType,
	       c.ItemID,
	       c.GridX,
	       c.GridY,
		   c.SubGridX,
		   c.SubGridY,
	       c.FacingType,
	       c.LastUsed,
		   b.capacity,
		   b.`Row`,
 		   b.Col,
		   b.Width,
		   b.Height,
		   b.OffsetX,
		   b.OffsetY,
		   b.Image,
		   b.Facings
		
	FROM 
		mylife_player.tbl_Player_Church c
	JOIN 
		mylife_static.tbl_Buildings b
	ON
		b.id = c.ItemID
	WHERE 
		c.UserID = kvUserID
	AND
		c.Deleted = 0
	AND
		c.ItemType = 1;
END;
GO

DROP PROCEDURE IF EXISTS `mylife_player`.`dsp_Player_Church_Decore_lst` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_player`.`dsp_Player_Church_Decore_lst`(kvUserID int)
BEGIN
	SELECT c.id,
	       c.ItemType,
	       c.ItemID,
	       c.GridX,
	       c.GridY,
		   c.SubGridX,
		   c.SubGridY,
	       c.FacingType,
	       c.LastUsed,
		   d.GridType,
		   d.`Row`,
 		   d.Col,
		   d.Width,
		   d.Height,
		   d.OffsetX,
		   d.OffsetY,
		   d.Image,
		   d.Facings
	FROM 
		mylife_player.tbl_Player_Church c
	JOIN 
		mylife_static.tbl_Decore d
	ON
		b.id = c.ItemID
	WHERE 
		c.UserID = kvUserID
	AND
		c.Deleted = 0
	AND
		c.ItemType = 0;
END;
GO


DROP PROCEDURE IF EXISTS `mylife_player`.`dsp_Player_Church_sel` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_player`.`dsp_Player_Church_sel`(pkid int, kvUserID int)
BEGIN
	SELECT id,
	       UserID,
	       ItemType,
	       ItemID,
	       GridX,
	       GridY,
 		   SubGridX,
		   SubGridY,
	       FacingType,
	       LastUsed,
	       Deleted
	FROM 
		mylife_player.tbl_Player_Church
	WHERE 
		id = pkid
	AND
		UserID = kvUserID;
END;
GO

DROP PROCEDURE IF EXISTS `mylife_player`.`dsp_Player_Church_upd` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_player`.`dsp_Player_Church_upd`(kvid int,
	kvUserID int,
	kvItemType int,
	kvItemID int,
	kvGridX int,
	kvGridY int,
	kvSubGridX int,
	kvSubGridY int,
	kvFacingType int,
	kvDeleted bit(1))
BEGIN
	DECLARE lcount INT;
	SELECT 
		count(1) 
	INTO 
		lcount
	FROM 
		mylife_player.tbl_Player_Church
	WHERE 
		id = kvid;


	IF lcount = 0 THEN
		INSERT INTO mylife_player.tbl_Player_Church(
				UserID,
				ItemType,
				ItemID,
				GridX,
				GridY,
				SubGridX,
				SubGridY,
				FacingType,
				LastUsed,
				Deleted)
		VALUES (
				kvUserID,
				kvItemType,
				kvItemID,
				kvGridX,
				kvGridY,
				kvSubGridX,
				kvSubGridY,
				kvFacingType,
				Now(),
				kvDeleted);
	
	 	SELECT LAST_INSERT_ID() AS indx;
	ELSE
		UPDATE 
			mylife_player.tbl_Player_Church
		SET 
			ItemType = kvItemType,
			ItemID = kvItemID,
			GridX = kvGridX,
			GridY = kvGridY,
			FacingType = kvFacingType,
			LastUsed = Now(),
			Deleted = kvDeleted
		WHERE 
			id = kvid;
	END IF;
END;
GO

DROP PROCEDURE IF EXISTS `mylife_player`.`dsp_Player_Church_del` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_player`.`dsp_Player_Church_del`(kvid int, kvUserID int)
BEGIN
	UPDATE 
		mylife_player.tbl_Player_Church
	SET 
		Deleted = 1
	WHERE 
		id = kvid
	AND
		UserID = kvUserID;
END;
GO
--
-- Table: tbl_Player_Collections
--

DROP PROCEDURE IF EXISTS `mylife_player`.`dsp_Player_Collections_lst` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_player`.`dsp_Player_Collections_lst`(kvUserID int)
BEGIN
	SELECT id,
		   UserID,
	       CollectionID,
	       ItemID,
	       ItemCount
	  FROM 
			mylife_player.tbl_Player_Collections
	  WHERE 
			UserID = kvUserID;
END;
GO

DROP PROCEDURE IF EXISTS `mylife_player`.`dsp_Player_Collections_sel` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_player`.`dsp_Player_Collections_sel`(kvUserID int, kvCollectionID int)
BEGIN
	SELECT id,
	       UserID,
	       CollectionID,
	       ItemID,
	       ItemCount
	FROM 
		mylife_player.tbl_Player_Collections
	WHERE 
		UserID = kvUserID
	AND
		CollectionID = kvCollectionID;
END;
GO

DROP PROCEDURE IF EXISTS `mylife_player`.`dsp_Player_Collection_Item_sel` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_player`.`dsp_Player_Collection_Item_sel`(kvUserID int, kvItemID int)
BEGIN
	SELECT id,
	       UserID,
	       CollectionID,
	       ItemID,
	       ItemCount
	FROM 
		mylife_player.tbl_Player_Collections
	WHERE 
		UserID = kvUserID
	AND
		ItemID = kvItemID;
END;
GO



DROP PROCEDURE IF EXISTS `mylife_player`.`dsp_Player_Collections_upd` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_player`.`dsp_Player_Collections_upd`(
	kvUserID int,
	kvCollectionID int,
	kvItemID int,
	kvItemCount int)
BEGIN
	DECLARE lcount INT;
	SELECT 
		count(1) 
	INTO 
		lcount
	FROM 
		mylife_player.tbl_Player_Collections
	WHERE 
		UserID = kvUserID
	AND
		ItemID = kvItemID;


	IF lcount = 0 THEN
		INSERT INTO mylife_player.tbl_Player_Collections(
				UserID,
				CollectionID,
				ItemID,
				ItemCount)
		VALUES (
				kvUserID,
				kvCollectionID,
				kvItemID,
				kvItemCount);
	ELSE
		UPDATE 
			mylife_player.tbl_Player_Collections
		SET 
			ItemCount = ItemCount+kvItemCount
		WHERE 
			UserID = kvUserID
		AND
			ItemID = kvItemID;
	END IF;
END;
GO



DROP PROCEDURE IF EXISTS `mylife_player`.`dsp_Player_Collections_del` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_player`.`dsp_Player_Collections_del`(pkid int)
BEGIN
	DELETE FROM 
		mylife_player.tbl_Player_Collections
	 WHERE 
		id = pkid;
END;
GO
--
-- Table: tbl_Player_Friends
--

DROP PROCEDURE IF EXISTS `mylife_player`.`dsp_Player_Friends_lst` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_player`.`dsp_Player_Friends_lst`(kvUserID int)
BEGIN
	SELECT id,
	       UserID,
	       FriendID,
	       FriendName,
	       XRef,
	       `Level`,
	       JobApproval,
	       LastUsed,
	       Active
	FROM 
		mylife_player.tbl_Player_Friends
	WHERE 
		UserID = kvUserID;
END;
GO

DROP PROCEDURE IF EXISTS `mylife_player`.`dsp_Player_Friends_sel` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_player`.`dsp_Player_Friends_sel`(
	kvUserID int,
	kvFriendID int)
BEGIN
	SELECT id,
	       UserID,
	       FriendID,
	       FriendName,
	       XRef,
	       `Level`,
	       JobApproval,
	       LastUsed,
	       Active
	FROM 
		mylife_player.tbl_Player_Friends
	WHERE 
		UserID = kvUserID 
	AND
		FriendID = kvFriendID;
END;
GO

DROP PROCEDURE IF EXISTS `mylife_player`.`dsp_Player_Friends_upd` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_player`.`dsp_Player_Friends_upd`(
	kvUserID int,
	kvFriendID int,
	kvXRef varchar(100),
	kvActive bit(1))
BEGIN
	DECLARE lcount INT;

	-- Get the most current details frist
	
	IF (kvXRef = '') THEN
		SELECT
			@XRef := XRef,
			@FriendID := UserID, 
			@JobApproval := JobApproval,
			@FriendName:= PlayerName,
			@Level := `Level`
		FROM
			mylife_player.tbl_Player
		WHERE
			UserID = kvFriendID;
	ELSE
		SELECT
			@FriendID := kvFriendID,
			@XRef := XRef,
			@JobApproval := JobApproval,
			@FriendName:= PlayerName,
			@Level := `Level`
		FROM
			mylife_player.tbl_Player
		WHERE
			XRef = kvXRef;
	END IF;


	SELECT 
		count(1) 
	INTO 
		lcount
	FROM 
		mylife_player.tbl_Player_Friends
	WHERE 
		UserID = kvUserID
	AND
		FriendID = @FriendID;

	IF (lcount = 0) THEN
		INSERT INTO mylife_player.tbl_Player_Friends(
				UserID,
				FriendID,
				FriendName,
				XRef,
				Level,
				JobApproval,
				Active)
		VALUES (
				kvUserID,
				@FriendID,
				@FriendName,
				@XRef,
				@Level,
				@JobApproval,
				kvActive);
	ELSE
		UPDATE 
			mylife_player.tbl_Player_Friends
		SET 
			FriendID = @FriendID,
			FriendName = @FriendName,
			XRef = @XRef,
			Level = @Level,
			JobApproval = @JobApproval,
			Active = kvActive
		WHERE 
			UserID = kvUserID
		AND
			FriendID = @FriendID;

	END IF;
END;
GO

DROP PROCEDURE IF EXISTS `mylife_player`.`dsp_Player_Friends_join` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_player`.`dsp_Player_Friends_join`(
	kvAccepted  varchar(100),
	kvRequested varchar(100))
BEGIN
	DECLARE mycount INT;
	DECLARE hiscount INT;


	-- Get the most current details frist
	-- Find the accepting parties details
	SELECT
		@Acc_UserID := UserID,
		@Acc_XRef := XRef,
		@Acc_JobApproval := JobApproval,
		@Acc_FriendName:= PlayerName,
		@Acc_Level := `Level`
	FROM
		mylife_player.tbl_Player
	WHERE
		XRef = kvAccepted;
	
	-- Find the accepting parties details
	SELECT
		@Req_UserID := UserID,
		@Req_XRef := XRef,
		@Req_JobApproval := JobApproval,
		@Req_FriendName:= PlayerName,
		@Req_Level := `Level`
	FROM
		mylife_player.tbl_Player
	WHERE
		XRef = kvRequested;

	-- make sure I dont already have him
	SELECT 
		count(1) 
	INTO 
		mycount
	FROM 
		mylife_player.tbl_Player_Friends
	WHERE 
		UserID = @Acc_UserID
	AND
		FriendID = @Req_UserID;

	IF mycount = 0 THEN
		INSERT INTO mylife_player.tbl_Player_Friends(
				UserID,
				FriendID,
				FriendName,
				XRef,
				Level,
				JobApproval,
				Active)
		VALUES (
				@Acc_UserID,
				@Req_UserID,
				@Req_FriendName,
				@Req_XRef,
				@Req_Level,
				@Req_JobApproval,
				1);
	END IF;


	-- make he doesnt already have me
	SELECT 
		count(1) 
	INTO 
		hiscount
	FROM 
		mylife_player.tbl_Player_Friends
	WHERE 
		UserID = @Req_UserID
	AND
		FriendID = @Acc_UserID;

	IF hiscount = 0 THEN
		INSERT INTO mylife_player.tbl_Player_Friends(
				UserID,
				FriendID,
				FriendName,
				XRef,
				Level,
				JobApproval,
				Active)
		VALUES (
				@Req_UserID,
				@Acc_UserID,
				@Acc_FriendName,
				@Acc_XRef,
				@Acc_Level,
				@Acc_JobApproval,
				1);
	END IF;

END;
GO


DROP PROCEDURE IF EXISTS `mylife_player`.`dsp_Player_Friends_Used` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_player`.`dsp_Player_Friends_Used`(
	kvUserID int,
	kvFriendID int)
BEGIN

		UPDATE 
			mylife_player.tbl_Player_Friends
		SET 
			LastUsed = Now()
		WHERE 
			UserID = kvUserID 
		AND
			FriendID = kvFriendID;
END;
GO


DROP PROCEDURE IF EXISTS `mylife_player`.`dsp_Player_Friends_Refresh` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_player`.`dsp_Player_Friends_Refresh`(kvUserID int)
BEGIN
	
	UPDATE 
		mylife_player.tbl_Player_Friends as f
	LEFT JOIN
		mylife_player.tbl_Player as p
	ON 
		f.FriendID = p.UserID
	SET 
		f.Level = p.Level,
		f.JobApproval = p.JobApproval
	WHERE 
		f.UserID = kvUserID;
	
END;
GO

DROP PROCEDURE IF EXISTS `mylife_player`.`dsp_Player_Friends_Activate` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_player`.`dsp_Player_Friends_Activate`(kvid int)
BEGIN
	
	UPDATE 
		mylife_player.tbl_Player_Friends
	SET 
		LastUsed = Now()
	WHERE 
		id = kvid;
END;
GO


DROP PROCEDURE IF EXISTS `mylife_player`.`dsp_Player_Friends_del` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_player`.`dsp_Player_Friends_del`(pkid int)
BEGIN
	DELETE FROM 
		mylife_player.tbl_Player_Friends
	WHERE 
		id = pkid;
END;
GO
--
-- Table: tbl_Player_Inventory
--
DROP PROCEDURE IF EXISTS `mylife_player`.`dsp_Player_Inventory_lst` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_player`.`dsp_Player_Inventory_lst`(kvUserID int)
BEGIN
	SELECT id,
	       UserID,
		   ItemType,
	       ItemID,
	       ItemCount,
	       Deleted
	FROM 
		mylife_player.tbl_Player_Inventory
	WHERE 
		UserID = kvUserID;
END;
GO

DROP PROCEDURE IF EXISTS `mylife_player`.`dsp_Player_Inventory_sel` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_player`.`dsp_Player_Inventory_sel`(pkid int)
BEGIN
	SELECT id,
	       UserID,
		   ItemType,	
	       ItemID,
	       ItemCount,
	       Deleted
	FROM 
		mylife_player.tbl_Player_Inventory
	WHERE
		id = pkid;
END;
GO

DROP PROCEDURE IF EXISTS `mylife_player`.`dsp_Player_Inventory_upd` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_player`.`dsp_Player_Inventory_upd`(
	kvUserID int,
	kvItemType int,
	kvItemID int,
	kvItemCount int)
BEGIN
	DECLARE lcount INT;
	SELECT 
		count(1) 
	INTO 
		lcount
	FROM 
		mylife_player.tbl_Player_Inventory
	WHERE 
		UserID = kvUserID
	AND
		ItemType = kvItemType
	AND 
		ItemID = kvItemID;

	IF lcount = 0 THEN
		INSERT INTO mylife_player.tbl_Player_Inventory(
				UserID,
				ItemType,
				ItemID,
				ItemCount,
				Deleted)
		VALUES (
				kvUserID,
				kvItemType,
				kvItemID,
				kvItemCount,
				0);
	ELSE
		UPDATE 
			mylife_player.tbl_Player_Inventory
		SET
			ItemCount = ItemCount + kvItemCount
		WHERE 
			UserID = kvUserID
		AND
			ItemType = kvItemType
		AND 
			ItemID = kvItemID;
	END IF;
END;
GO

DROP PROCEDURE IF EXISTS `mylife_player`.`dsp_Player_Inventory_del` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_player`.`dsp_Player_Inventory_del`(pkid int)
BEGIN
	DELETE FROM 
		mylife_player.tbl_Player_Inventory
	WHERE 
		id = pkid;
END;
GO
--
-- Table: tbl_Player_Quests
--

DROP PROCEDURE IF EXISTS `mylife_player`.`dsp_Player_Quests_lst` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_player`.`dsp_Player_Quests_lst`(kvUserID int)
BEGIN
	SELECT id,
	       UserID,
	       QuestID,
	       Step1Require,
	       Step1Done,
	       Step2Require,
	       Step2Done,
	       Step3Require,
	       Step3Done,
	       Complete
	FROM 
		mylife_player.tbl_Player_Quests
	WHERE 
		UserID = kvUserID;
END;
GO

DROP PROCEDURE IF EXISTS `mylife_player`.`dsp_Player_Quests_sel` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_player`.`dsp_Player_Quests_sel`(pkid int)
BEGIN
	SELECT id,
	       UserID,
	       QuestID,
	       Step1Require,
	       Step1Done,
	       Step2Require,
	       Step2Done,
	       Step3Require,
	       Step3Done,
	       Complete
	FROM
		mylife_player.tbl_Player_Quests
	WHERE 
		id = pkid;
END;
GO

DROP PROCEDURE IF EXISTS `mylife_player`.`dsp_Player_Quests_upd` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_player`.`dsp_Player_Quests_upd`(kvid int,
	kvUserID int,
	kvQuestID int,
	kvStep1Require int,
	kvStep1Done int,
	kvStep2Require int,
	kvStep2Done int,
	kvStep3Require int,
	kvStep3Done int,
	kvComplete bit(1))
BEGIN
	DECLARE lcount INT;
	SELECT 
		count(1) 
	INTO 
		lcount
	FROM 
		mylife_player.tbl_Player_Quests
	WHERE 
		id = kvid;

	IF lcount = 0 THEN
		INSERT INTO tbl_Player_Quests(
				UserID,
				QuestID,
				Step1Require,
				Step1Done,
				Step2Require,
				Step2Done,
				Step3Require,
				Step3Done,
				Complete)
		VALUES (
				kvUserID,
				kvQuestID,
				kvStep1Require,
				kvStep1Done,
				kvStep2Require,
				kvStep2Done,
				kvStep3Require,
				kvStep3Done,
				kvComplete);
	ELSE
		UPDATE 
			mylife_player.tbl_Player_Quests
		SET 
			Step1Require = kvStep1Require,
			Step1Done = kvStep1Done,
			Step2Require = kvStep2Require,
			Step2Done = kvStep2Done,
			Step3Require = kvStep3Require,
			Step3Done = kvStep3Done,
			Complete = kvComplete
		WHERE 
			id = kvid;
	END IF;
END;
GO

DROP PROCEDURE IF EXISTS `mylife_player`.`dsp_Player_Quests_del` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_player`.`dsp_Player_Quests_del`(pkid int)
BEGIN
	DELETE FROM 
		mylife_player.tbl_Player_Quests
	WHERE 
		id = pkid;
END;
GO
--
-- Table: tbl_Player_Unlocks
--

DROP PROCEDURE IF EXISTS `mylife_player`.`dsp_Player_Unlocks_lst` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_player`.`dsp_Player_Unlocks_lst`(kvUserID int)
BEGIN
	SELECT id,
	       UserID,
	       UnlockType,
	       UnlockID
	FROM 
		mylife_player.tbl_Player_Unlocks
	WHERE 
		UserID = kvUserID;
END;
GO

DROP PROCEDURE IF EXISTS `mylife_player`.`dsp_Player_Unlocks_sel` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_player`.`dsp_Player_Unlocks_sel`(pkid int)
BEGIN
	SELECT id,
	       UserID,
	       UnlockType,
	       UnlockID
	FROM 
		mylife_player.tbl_Player_Unlocks
	WHERE 
		id = pkid;
END;
GO

DROP PROCEDURE IF EXISTS `mylife_player`.`dsp_Player_Unlocks_upd` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_player`.`dsp_Player_Unlocks_upd`(kvid int,
	kvUserID int,
	kvUnlockType int,
	kvUnlockID int)
BEGIN
	DECLARE lcount INT;
	SELECT
		count(1) 
	INTO
		lcount
	FROM
		mylife_player.tbl_Player_Unlocks
	WHERE 
		id = kvid;

	IF lcount = 0 THEN
		INSERT INTO mylife_player.tbl_Player_Unlocks(
				UserID,
				UnlockType,
				UnlockID)
		VALUES (
				kvUserID,
				kvUnlockType,
				kvUnlockID);
	ELSE
		UPDATE 
			mylife_player.tbl_Player_Unlocks
		SET 
			UnlockType = kvUnlockType,
			UnlockID = kvUnlockID
		WHERE 
			id = kvid;
	END IF;
END;
GO

DROP PROCEDURE IF EXISTS `mylife_player`.`dsp_Player_Unlocks_del` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_player`.`dsp_Player_Unlocks_del`(pkid int)
BEGIN
	DELETE FROM 
		mylife_player.tbl_Player_Unlocks
	WHERE
		id = pkid;
END;
GO
--
-- Table: tbl_Player_Wishlist
--

DROP PROCEDURE IF EXISTS `mylife_player`.`dsp_Player_Wishlist_lst` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_player`.`dsp_Player_Wishlist_lst`(kvUserID int)
BEGIN
	SELECT id,
	       UserID,
	       Item1,
	       Item2,
	       Item3,
	       Item4,
	       Item5
	FROM 
		mylife_player.tbl_Player_Wishlist
	WHERE 
		UserID = kvUserID;
END;
GO

DROP PROCEDURE IF EXISTS `mylife_player`.`dsp_Player_Wishlist_sel` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_player`.`dsp_Player_Wishlist_sel`(pkid int)
BEGIN
	SELECT id,
	       UserID,
	       Item1,
	       Item2,
	       Item3,
	       Item4,
	       Item5
	FROM 
		mylife_player.tbl_Player_Wishlist
	WHERE 
		id = pkid;
END;
GO

DROP PROCEDURE IF EXISTS `mylife_player`.`dsp_Player_Wishlist_upd` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_player`.`dsp_Player_Wishlist_upd`(
	kvUserID int,
	kvItem1 int,
	kvItem2 int,
	kvItem3 int,
	kvItem4 int,
	kvItem5 int)
BEGIN
	DECLARE lcount INT;
	SELECT 
		count(1) 
	INTO 
		lcount
	FROM 
		mylife_player.tbl_Player_Wishlist
	WHERE 
		UserID = kvUserID;

	IF lcount = 0 THEN
		INSERT INTO mylife_player.tbl_Player_Wishlist(
				UserID,
				Item1,
				Item2,
				Item3,
				Item4,
				Item5)
		VALUES (
				kvUserID,
				kvItem1,
				kvItem2,
				kvItem3,
				kvItem4,
				kvItem5);
	ELSE
		UPDATE 
			mylife_player.tbl_Player_Wishlist
		SET 
			Item1 = kvItem1,
			Item2 = kvItem2,
			Item3 = kvItem3,
			Item4 = kvItem4,
			Item5 = kvItem5
		WHERE 
			UserID = kvUserID;
	END IF;
END;
GO

DROP PROCEDURE IF EXISTS `mylife_player`.`dsp_Player_Wishlist_del` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_player`.`dsp_Player_Wishlist_del`(pkid int)
BEGIN
	DELETE FROM 
		mylife_player.tbl_Player_Wishlist
	WHERE
		id = pkid;
END;
GO

--
-- Table: tbl_Player_Pending
--


DROP PROCEDURE IF EXISTS `mylife_player`.`dsp_Player_Pending_lst` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_player`.`dsp_Player_Pending_lst`(kvUserID int)
BEGIN
	SELECT id,
	       UserID,
	       ItemType,
	       ItemID,
	       Source,
	       IDKey,
	       Complete
	FROM 
		mylife_player.tbl_Player_Pending
	WHERE 
		UserID = kvUserID;
END;
GO

DROP PROCEDURE IF EXISTS `mylife_player`.`dsp_Player_Pending_sel` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_player`.`dsp_Player_Pending_sel`(
kvUserID int,
kvIDKey varchar(20))
BEGIN
	SELECT id,
	       UserID,
	       ItemType,
	       ItemID,
	       Source,
	       IDKey,
	       Complete
	FROM 
		mylife_player.tbl_Player_Pending
	WHERE 
		UserID = kvUserID
	AND
		IDKey = kvIDKey
	AND
		Complete = 0;
END;
GO

DROP PROCEDURE IF EXISTS `mylife_player`.`dsp_Player_Pending_upd` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_player`.`dsp_Player_Pending_upd`(
	kvUserID int,
	kvItemType int,
	kvItemID int,
	kvSource int,
	kvIDKey varchar(20),
	Complete bit(1))
BEGIN
	DECLARE lcount INT;
	SELECT 
		count(1) 
	INTO 
		lcount
	FROM 
		mylife_player.tbl_Player_Pending
	WHERE 
		UserID = kvUserID
	AND
		IDKey = kvIDKey
	AND
		Complete = 0;

	IF lcount = 0 THEN
		INSERT INTO mylife_player.tbl_Player_Pending(
				UserID,
	       		ItemType,
	       		ItemID,
	       		Source,
	       		IDKey,
	       		Complete)
		VALUES (
				kvUserID,
				kvItemType,
				kvItemID,
				kvSource,
				kvIDKey,
				Complete);
	ELSE
		UPDATE 
			mylife_player.tbl_Player_Pending
		SET 
			Complete = 1
		WHERE 
			UserID = kvUserID
		AND
			IDKey = kvIDKey
		AND
			Complete = 0;
	END IF;
END;
GO

DROP PROCEDURE IF EXISTS `mylife_player`.`dsp_Player_Pending_del` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_player`.`dsp_Player_Pending_del`(
kvUserID int,
kvIDKey varchar(20))
BEGIN
	DELETE FROM 
		mylife_player.tbl_Player_Pending
	WHERE
		UserID = kvUserID
	AND
		IDKey = kvIDKey;
END;
GO

DELIMITER ;


