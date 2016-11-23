SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/*
Description:    Update a published story
Usage:         	dsp_NEWS_NewsItemUpdatePublish 1,1
		@mode=1 update pictures
		@mode=2 update Keywords
                @mode=3 update Sections
****************History************************************
Date:         	4.19.2007
Author:       	Allen Halsted
Mod:          	Creation
***********************************************************
*/


CREATE  PROCEDURE dsp_NEWS_NewsItemUpdatePublish(@NewsID as integer, @mode as integer = 0)

AS 
declare @Status int
	--Make sure it is not already published
	SELECT 
		@Status = [MajorStatus] 
	FROM
		[dbPrivateContent].[dbo].[tblNewsItems] (NOLOCK)
	WHERE
		[NewsID]=@NewsID

	IF (@Status = 1)
	BEGIN
	
		--Pictures
		IF (@mode = 1)
		BEGIN
			DELETE FROM
				[dbPublicNews].[dbo].[tblNewsPictures]
			WHERE
				[NewsID]=@NewsID

			INSERT INTO 
				[dbPublicNews].[dbo].[tblNewsPictures]
				(
				 [NewsID], 
				 [PictureID],
				 [AltText],
				 [PictureReplace],
		 		 [TextReplace]
				)	
				SELECT 
					[NewsID], 
					[PictureID],
					[AltText],
				 	[PictureReplace],
		 		 	[TextReplace]
				FROM 
					[dbPrivateContent].[dbo].[tblNewsPictures] (NOLOCK)
				WHERE 
					[NewsID]=@NewsID
		END
		--KeyWords
		IF (@mode = 2)
		BEGIN
			DELETE FROM
				[dbPublicNews].[dbo].[tblNewsKeywords]
			WHERE
				[NewsID]=@NewsID

			INSERT INTO 
				[dbPublicNews].[dbo].[tblNewsKeywords]
				(
				[NewsID], 
				[KeyID]
				)
				SELECT 
					[NewsID], 
					[KeyID] 
				FROM 
					[dbPrivateContent].[dbo].[tblNewsKeywords] (NOLOCK)
				WHERE 
					[NewsID]=@NewsID
		END
		--Sections
		IF (@mode = 3)
		BEGIN
			DELETE FROM
				[dbPublicNews].[dbo].[tblNewsSections]
			WHERE
				[NewsID]=@NewsID

			--Sections
			INSERT INTO 
				[dbPublicNews].[dbo].[tblNewsSections]
				(
				[NewsID], 
				[SectionID],
				[SubSectionID],
				[StartPriority], 
				[FirstDecay], 
				[SecondDecay],
				[StoryType]
				)
				SELECT 
					[NewsID], 
					[SectionID],
					[SubSectionID],
					[StartPriority], 
					[FirstDecay], 
					[SecondDecay],
					[StoryType]
				FROM 
					[dbPrivateContent].[dbo].[tblNewsSections] (NOLOCK)
				WHERE 
					[NewsID]=@NewsID
		

			DELETE FROM
				[dbPublicNews].[dbo].[tblNewsPriority]
			WHERE
				[NewsID]=@NewsID

			--priority
			INSERT INTO 
				[dbPublicNews].[dbo].[tblNewsPriority]
				(
				[NewsID], 
				[SectionID], 
				[Priority], 
				[LastUpdate], 
				[NextDecay]
				)
				SELECT 
					[NewsID],
					[SectionID],
					[StartPriority],
					GetDate(),
					[FirstDecay]
				FROM 
					[dbPrivateContent].[dbo].[tblNewsSections]
				WHERE 
					[NewsID]=@NewsID
		END

	END


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [dbo].[dsp_NEWS_NewsItemUpdatePublish]  TO [EnergyUser]
GO

