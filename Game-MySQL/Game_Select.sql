USE mylife_static;
DELIMITER GO
--
-- Table: tbl_Buildings
--

DROP PROCEDURE IF EXISTS `mylife_static`.`dsp_Buildings_lst` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_static`.`dsp_Buildings_lst`()
BEGIN

	SELECT id, Name, Dscrpt, Capacity, `Row`, Col, Width, Height, OffsetX, OffsetY, SellValue, Image, Facings 
	FROM mylife_static.tbl_Buildings;
	
END;
GO

DROP PROCEDURE IF EXISTS `mylife_static`.`dsp_Buildings_sel` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_static`.`dsp_Buildings_sel`(pkid int)
BEGIN

	SELECT id, Name, Dscrpt, Capacity, `Row`, Col, Width, Height, OffsetX, OffsetY, SellValue, Image, Facings 
	FROM mylife_static.tbl_Buildings
	WHERE id = pkid;
	
END;
GO


--
-- Table: tbl_Building_Dailies
--

DROP PROCEDURE IF EXISTS `mylife_static`.`dsp_Building_Dailies_lst` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_static`.`dsp_Building_Dailies_lst`(kvBuildingID int)
BEGIN

	SELECT 
		b.id, 
		b.BuildingID, 
		b.DailyID, 
		d.Name, 
		d.Dscrpt, 
		d.RechargeTime, 
		d.BusyTime, 
		d.RewardID, 
		w.Coins, 
		w.Bookmarks, 
		w.JobApproval, 
		w.Xp
	FROM 
		mylife_static.tbl_Building_Dailies b

	JOIN 
		mylife_static.tbl_Dailies d
	ON
		b.DailyID = d.id
	JOIN
		mylife_static.tbl_Rewards w
	ON
		w.id = d.RewardID	
	WHERE
		b.Active = 1
	AND
		b.BuildingID = kvBuildingID;
	
END;
GO

DROP PROCEDURE IF EXISTS `mylife_static`.`dsp_Building_Daily_sel` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_static`.`dsp_Building_Daily_sel`(kvBuildingID int, kvDailyID int)
BEGIN

	SELECT 
		b.id, 
		b.BuildingID, 
		b.DailyID, 
		d.Name, 
		d.Dscrpt, 
		d.RechargeTime, 
		d.BusyTime, 
		d.RewardID, 
		w.Coins, 
		w.Bookmarks, 
		w.JobApproval, 
		w.Xp
	FROM 
		mylife_static.tbl_Building_Dailies b

	JOIN 
		mylife_static.tbl_Dailies d
	ON
		b.DailyID = d.id
	JOIN
		mylife_static.tbl_Rewards w
	ON
		w.id = d.RewardID	
	WHERE
		b.Active = 1
	AND
		b.BuildingID = kvBuildingID
	AND
		b.DailyID = kvDailyID;
	
END;
GO

--
-- Table: tbl_Building_Requirements
--

DROP PROCEDURE IF EXISTS `mylife_static`.`dsp_Building_Requirements_lst` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_static`.`dsp_Building_Requirements_lst`(kvBuildingID int)
BEGIN

	SELECT id, BuildingID, CollectionItemID, ItemCount, BuyNow 
	FROM mylife_static.tbl_Building_Requirements
	WHERE BuildingID = kvBuildingID;
END;
GO

DROP PROCEDURE IF EXISTS `mylife_static`.`dsp_Building_Requirements_Item_lst` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_static`.`dsp_Building_Requirements_Item_lst`(kvBuildingID int, kvCollectionItemID int)
BEGIN

	SELECT id, BuildingID, CollectionItemID, ItemCount, BuyNow 
	FROM mylife_static.tbl_Building_Requirements
	WHERE BuildingID = kvBuildingID
	AND CollectionItemID = kvCollectionItemID;
END;
GO


--
-- Table: tbl_Collections
--

DROP PROCEDURE IF EXISTS `mylife_static`.`dsp_Collections_lst` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_static`.`dsp_Collections_lst`()
BEGIN

	SELECT 
		c.id, 
		c.Name, 
		c.RewardID,
		w.Coins, 
		w.Bookmarks, 
		w.JobApproval, 
		w.Xp
	FROM 
		mylife_static.tbl_Collections c
	JOIN
		mylife_static.tbl_Rewards w
	ON
		w.id = c.RewardID
	WHERE 
		c.Active = 1;	
END;
GO


--
-- Table: tbl_Collection_Items
--

DROP PROCEDURE IF EXISTS `mylife_static`.`dsp_Collections_Items_lst` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_static`.`dsp_Collections_Items_lst`(kvCollectionID int)
BEGIN

	SELECT id, CollectionID, Name, Image, `Level`, ItemNumber, DropRate, Active 
	FROM mylife_static.tbl_Collection_Items
	WHERE CollectionID = kvCollectionID
	AND Active = 1;	
	
END;
GO


DROP PROCEDURE IF EXISTS `mylife_static`.`dsp_Collections_Items_sel` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_static`.`dsp_Collections_Items_sel`(pkid int)
BEGIN

	SELECT id, CollectionID, Name, Image, `Level`, ItemNumber, DropRate, Active 
	FROM mylife_static.tbl_Collection_Items
	WHERE id = pkid;	
	
END;
GO


DROP PROCEDURE IF EXISTS `mylife_static`.`dsp_Collections_Reward_lst` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_static`.`dsp_Collections_Reward_lst`(kvLevel int)
BEGIN

	SELECT id, CollectionID, Name, Image, `Level`, ItemNumber, DropRate, Active 
	FROM mylife_static.tbl_Collection_Items
	WHERE 
		`Level`< kvLevel+5
	AND
		`Level`> kvLevel-5
	AND Active = 1;	
	
END;
GO

DROP PROCEDURE IF EXISTS `mylife_static`.`dsp_Collections_Gifts_lst` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_static`.`dsp_Collections_Gifts_lst`()
BEGIN

	SELECT id, CollectionID, Name, Image, `Level`, ItemNumber, DropRate, Active 
	FROM mylife_static.tbl_Collection_Items
	WHERE Active = 1;	
	
END;
GO


--
-- Table: tbl_Dailies
--

DROP PROCEDURE IF EXISTS `mylife_static`.`dsp_Dailies_lst` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_static`.`dsp_Dailies_lst`()
BEGIN

	SELECT 
		d.id, 
		d.Name, 
		d.Dscrpt, 
		d.RechargeTime, 
		d.BusyTime, 
		d.RewardID, 
		w.Coins, 
		w.Bookmarks, 
		w.JobApproval, 
		w.Xp
	FROM 
		mylife_static.tbl_Dailies d
	JOIN
		mylife_static.tbl_Rewards w
	ON
		w.id = d.RewardID;	


END;
GO

DROP PROCEDURE IF EXISTS `mylife_static`.`dsp_Dailies_sel` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_static`.`dsp_Dailies_sel`(pkid int)
BEGIN

	SELECT 
		d.id, 
		d.Name, 
		d.Dscrpt, 
		d.RechargeTime, 
		d.BusyTime, 
		d.RewardID, 
		w.Coins, 
		w.Bookmarks, 
		w.JobApproval, 
		w.Xp
	FROM 
		mylife_static.tbl_Dailies d
	JOIN
		mylife_static.tbl_Rewards w
	ON
		w.id = d.RewardID	
	WHERE
		d.id = pkid;

END;
GO

--
-- Table: tbl_Decore
--

DROP PROCEDURE IF EXISTS `mylife_static`.`dsp_Decore_lst` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_static`.`dsp_Decore_lst`()
BEGIN

	SELECT id, Name, Dscrpt, `Row`, Col, GridType, Width, Height, OffsetX, OffsetY, SellValue, Image, Facings 
	FROM mylife_static.tbl_Decore;
	
END;
GO

DROP PROCEDURE IF EXISTS `mylife_static`.`dsp_Decore_sel` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_static`.`dsp_Decore_sel`(pkid int)
BEGIN

	SELECT id, Name, Dscrpt, `Row`, Col, GridType, Width, Height, OffsetX, OffsetY, SellValue, Image, Facings 
	FROM mylife_static.tbl_Decore
	WHERE id = pkid;
	
END;
GO

--
-- Table: tbl_Level_Progression
--

DROP PROCEDURE IF EXISTS `mylife_static`.`dsp_Level_Progression_lst` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_static`.`dsp_Level_Progression_lst`()
BEGIN

	SELECT id, Levels, XP, Reward 
	FROM mylife_static.tbl_Level_Progression;
	
END;
GO

DROP PROCEDURE IF EXISTS `mylife_static`.`dsp_Level_Progression_sel` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_static`.`dsp_Level_Progression_sel`(kvLevel int)
BEGIN

	SELECT id, Levels, XP, Reward 
	FROM mylife_static.tbl_Level_Progression
	WHERE Levels = kvLevel;
	
END;
GO



--
-- Table: tbl_Missions
--

DROP PROCEDURE IF EXISTS `mylife_static`.`dsp_Missions_lst` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_static`.`dsp_Missions_lst`()
BEGIN

	SELECT 
		m.id, 
		m.Name, 
		m.Dscrpt, 
		m.Image, 
		m.RestrictionID,
		r.Dscrpt as restrictDesc, 
		r.StatType, 
		r.StatID, 
		r.BuyNow 
	FROM 
		mylife_static.tbl_Missions m
	JOIN
		mylife_static.tbl_Restrictions r
	ON
		r.id = m.RestrictionID
	WHERE
		m.Active = 1;

END;
GO


--
-- Table: tbl_Quests
--

DROP PROCEDURE IF EXISTS `mylife_static`.`dsp_Quests_lst` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_static`.`dsp_Quests_lst`()
BEGIN

	SELECT 
		q.id, 
		q.Name, 
		q.Dscrpt, 
		q.Steps, 
		q.RewardID, 
		q.Hint, 
		w.Coins, 
		w.Bookmarks, 
		w.JobApproval, 
		w.Xp

	FROM 
		mylife_static.tbl_Quests q
	JOIN
		mylife_static.tbl_Rewards w
	ON
		w.id = q.RewardID
	WHERE
		q.Active = 1;
END;
GO



--
-- Table: tbl_Quest_Steps
--

DROP PROCEDURE IF EXISTS `mylife_static`.`dsp_Quest_Steps_lst` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_static`.`dsp_Quest_Steps_lst`(kvQuestID int)
BEGIN

	SELECT id, QuestID, Dscrpt, Required, StepNumber, BuyNow, Image 
	FROM mylife_static.tbl_Quest_Steps
	WHERE QuestID = kvQuestID;
	
END;
GO


--
-- Table: tbl_Restrictions
--

DROP PROCEDURE IF EXISTS `mylife_static`.`dsp_Restrictions_lst` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_static`.`dsp_Restrictions_lst`()
BEGIN

	SELECT id, Dscrpt, StatType, StatID, BuyNow 
	FROM mylife_static.tbl_Restrictions;
	
END;
GO


DROP PROCEDURE IF EXISTS `mylife_static`.`dsp_Restrictions_sel` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_static`.`dsp_Restrictions_sel`(pkid int)
BEGIN

	SELECT id, Dscrpt, StatType, StatID, BuyNow 
	FROM mylife_static.tbl_Restrictions
	WHERE id = pkid;
	
END;
GO


--
-- Table: tbl_Rewards
--

DROP PROCEDURE IF EXISTS `mylife_static`.`dsp_Rewards_lst` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_static`.`dsp_Rewards_lst`()
BEGIN

	SELECT id, Name, Coins, Bookmarks, JobApproval, Xp, Active 
	FROM mylife_static.tbl_Rewards;
	
END;
GO



--
-- Table: tbl_Store
--

DROP PROCEDURE IF EXISTS `mylife_static`.`dsp_Store_Buildings_lst` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_static`.`dsp_Store_Buildings_lst`()
BEGIN

	SELECT 
		s.id, 
		s.ItemType, 
		s.ItemID, 
		s.Dscrpt, 
		s.Image as StoreIcon, 
		s.SaleEndDate, 
		s.RewardID, 
		s.Cost, 
		s.CostType, 
		s.RestrictionID, 
		b.capacity,
		b.`Row`,
 		b.Col,
		b.Width,
		b.Height,
		b.OffsetX,
		b.OffsetY,
		b.Image,
		b.Facings,
		r.Dscrpt as restrictDesc, 
		r.StatType, 
		r.StatID, 
		r.BuyNow,
		w.Coins, 
		w.Bookmarks, 
		w.JobApproval, 
		w.Xp
	

	FROM 
		mylife_static.tbl_Store s
	JOIN 
		mylife_static.tbl_Buildings b
	ON
		b.id = s.ItemID

	JOIN
		mylife_static.tbl_Restrictions r
	ON
		r.id = s.RestrictionID

	JOIN
		mylife_static.tbl_Rewards w
	on
		w.id = s.RewardID

	WHERE
		s.Active = 1 
	AND
		s.ItemType = 1;
	
END;
GO

DROP PROCEDURE IF EXISTS `mylife_static`.`dsp_Store_Decore_lst` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_static`.`dsp_Store_Decore_lst`()
BEGIN

	SELECT 
		s.id, 
		s.ItemType,
		s.ItemID,  
		s.Dscrpt, 
		s.Image as StoreIcon, 
		s.SaleEndDate, 
		s.RewardID, 
		s.Cost, 
		s.CostType, 
		s.RestrictionID, 
		d.GridType,
	    d.`Row`,
 		d.Col,
		d.Width,
		d.Height,
		d.OffsetX,
		d.OffsetY,
		d.Image,
		d.Facings,
		r.Dscrpt as restrictDesc, 
		r.StatType, 
		r.StatID, 
		r.BuyNow,
		w.Coins, 
		w.Bookmarks, 
		w.JobApproval, 
		w.Xp

	FROM 
		mylife_static.tbl_Store s
	JOIN 
		mylife_static.tbl_Decore d
	ON
		b.id = s.ItemID

	JOIN
		mylife_static.tbl_Restrictions r
	ON
		r.id = s.RestrictionID

	JOIN
		mylife_static.tbl_Rewards w
	on
		w.id = s.RewardID

	WHERE
		s.Active = 1 
	AND
		s.ItemType = 0;
	
END;
GO

DROP PROCEDURE IF EXISTS `mylife_static`.`dsp_Store_sel` GO
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_static`.`dsp_Store_sel`(pkid int)
BEGIN

	SELECT 
		s.id, 
		s.ItemType, 
		s.ItemID, 
		s.Dscrpt, 
		s.Image as StoreIcon, 
		s.SaleEndDate, 
		s.RewardID, 
		s.Cost, 
		s.CostType, 
		s.RestrictionID, 
		b.capacity,
		b.`Row`,
 		b.Col,
		b.Width,
		b.Height,
		b.OffsetX,
		b.OffsetY,
		b.Image,
		b.Facings,
		w.Coins, 
		w.Bookmarks, 
		w.JobApproval, 
		w.Xp
	

	FROM 
		mylife_static.tbl_Store s
	JOIN 
		mylife_static.tbl_Buildings b
	ON
		b.id = s.ItemID

	JOIN
		mylife_static.tbl_Rewards w
	on
		w.id = s.RewardID

	WHERE
		s.Active = 1 
	AND
		s.id = pkid;
	
END;
GO

DROP PROCEDURE IF EXISTS `mylife_static`.`dsp_game_init` $$
CREATE DEFINER=`mylife_game`@`%` PROCEDURE `mylife_static`.`dsp_game_init` (Source_Type int)
BEGIN

	
	SET @Main = 'mylife.swf';
	SET @UIHeader = 'uiheader.swf';
	SET @UIStore = 'uistore.swf';
	SET @UIFriends = 'uifriends.swf';
	SET @Splash = 'splash.swf';
	SET @SWFUrl = '/uriel.life.common/public/swfs/';

	IF (Source_Type IS NOT NULL) THEN
		SELECT
		   @Main := ConfigValue
		FROM
			tbl_Config
		WHERE
		   KeyName = 'main_swf'
		AND
		   SourceType = Source_Type
		AND
		   Active = 1;
	ELSEIF (Source_Type IS NULL) THEN
		SELECT
		   @Main := ConfigValue
		FROM
			tbl_Config
		WHERE
		   KeyName = 'main_swf'
		AND
		   SourceType is NULL
		AND
		   Active = 1;
	END IF;

	IF (Source_Type IS NOT NULL) THEN
		SELECT
		   @UIHeader := ConfigValue
		FROM
			tbl_Config
		WHERE
		   KeyName = 'header_swf'
		AND
		   SourceType = Source_Type
		AND
		   Active = 1;
	ELSEIF (Source_Type IS NULL) THEN
		SELECT
		   @UIHeader := ConfigValue
		FROM
			tbl_Config
		WHERE
		   KeyName = 'header_swf'
		AND
		   SourceType is NULL
		AND
		   Active = 1;
	END IF;

	IF (Source_Type IS NOT NULL) THEN
		SELECT
		   @UIStore := ConfigValue
		FROM
			tbl_Config
		WHERE
		   KeyName = 'store_swf'
		AND
		   SourceType = Source_Type
		AND
		   Active = 1;
	ELSEIF (Source_Type IS NULL) THEN
		SELECT
		   @UIStore := ConfigValue
		FROM
			tbl_Config
		WHERE
		   KeyName = 'store_swf'
		AND
		   SourceType is NULL
		AND
		   Active = 1;
	END IF;


	IF (Source_Type IS NOT NULL) THEN
		SELECT
		   @UIFriends := ConfigValue
		FROM
			tbl_Config
		WHERE
		   KeyName = 'friends_swf'
		AND
		   SourceType = Source_Type
		AND
		   Active = 1;
	ELSEIF (Source_Type IS NULL) THEN
		SELECT
		   @UIFriends := ConfigValue
		FROM
			tbl_Config
		WHERE
		   KeyName = 'friends_swf'
		AND
		   SourceType is NULL
		AND
		   Active = 1;
	END IF;

	IF (Source_Type IS NOT NULL) THEN
		SELECT
		   @Splash := ConfigValue
		FROM
			tbl_Config
		WHERE
		   KeyName = 'splash_swf'
		AND
		   SourceType = Source_Type
		AND
		   Active = 1;
	ELSEIF (Source_Type IS NULL) THEN
		SELECT
		   @Splash := ConfigValue
		FROM
			tbl_Config
		WHERE
		   KeyName = 'splash_swf'
		AND
		   SourceType is NULL
		AND
		   Active = 1;
	END IF;


	IF (Source_Type IS NOT NULL) THEN
		SELECT
		   @SWFUrl := ConfigValue
		FROM
			tbl_Config
		WHERE
		   KeyName = 'url_swf'
		AND
		   SourceType = Source_Type
		AND
		   Active = 1;
	ELSEIF (Source_Type IS NULL) THEN
		SELECT
		   @SWFUrl := ConfigValue
		FROM
			tbl_Config
		WHERE
		   KeyName = 'url_swf'
		AND
		   SourceType is NULL
		AND
		   Active = 1;
	END IF;

	SELECT @Main as 'Main', @UIHeader as 'Header', @UIStore as 'Store', @UIFriends as 'Friends', @Splash as 'Splash', @SWFUrl as 'URL';


END $$



DELIMITER ;
