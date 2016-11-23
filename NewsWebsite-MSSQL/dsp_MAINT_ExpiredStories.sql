SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/*
Description:    Remove expired Yellow Brix stories from the db
Usage:         	dsp_MAINT_ExpiredStories 
                
****************History************************************
Date:         	01.09.2009
Author:       	Allen Halsted
Mod:          	Creation
***********************************************************
*/


CREATE PROCEDURE dbo.dsp_MAINT_ExpiredStories
AS 

	--News Itmes
	UPDATE 
		[dbPublicNews].[dbo].[tblNewsItems]
	SET 
		[Active]=0
	WHERE 
		[Active]=1
	and
		[NewsID] in
		(
			SELECT 
				[NewsID]
			FROM 
				[dbPrivateContent].[dbo].[tblYellowBrix] (NOLOCK)
			WHERE
				DATEADD(dd,-1,[ExpirationDate])<=GETDATE()			
			and
				[Status] in (2,3)
	
		)

	--Search
	DELETE FROM 
		[dbPublicNews].[dbo].[tblNewsSearch]
	WHERE 
		[NewsID] in
		(
			SELECT 
				[NewsID]
			FROM 
				[dbPrivateContent].[dbo].[tblYellowBrix] (NOLOCK)
			WHERE
				DATEADD(dd,-1,[ExpirationDate])<=GETDATE()			
			and
				[Status] in (2,3)
	
		)

	--Mark News Item as expired
	UPDATE 
		[dbPrivateContent].[dbo].[tblNewsItems]
	SET 
		[MajorStatus]=2, 
		[MinorStatus]=35
	WHERE 
		[NewsID] in
		(
			SELECT 
				[NewsID]
			FROM 
				[dbPrivateContent].[dbo].[tblYellowBrix] (NOLOCK)
			WHERE
				DATEADD(dd,-1,[ExpirationDate])<=GETDATE()			
			and
				[Status] in (2,3)
	
		)



	--Yellow Brix List
	UPDATE 
		[dbPrivateContent].[dbo].[tblYellowBrix]
	SET  
		[Status]=5
	WHERE 
		DATEADD(dd,-1,[ExpirationDate])<=GETDATE()			
	and
		[Status] in (0,2,3)


	

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [dbo].[dsp_MAINT_ExpiredStories]  TO [EnergyUser]
GO
