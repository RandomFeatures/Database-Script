SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/*
Description:    Publish a given news item to the website
Usage:         	dsp_NEWS_NewsItemPublish 1
                
****************History************************************
Date:         	11.01.2006
Author:       	Allen Halsted
Mod:          	Creation
***********************************************************
Date:         	04.20.2007
Author:       	Allen Halsted
Mod:          	Added AltText, Picture Replace and TextReplace
***********************************************************
*/


ALTER PROCEDURE dsp_NEWS_NewsItemPublish(@NewsID as integer)

AS 
declare @Status int
	--Make sure it is not already published
	SELECT 
		@Status = [MajorStatus] 
	FROM
		[dbPrivateContent].[dbo].[tblNewsItems] (NOLOCK)
	WHERE
		[NewsID]=@NewsID

	IF (@Status = 0)
	BEGIN
	
		--Mark News Item as published
		UPDATE 
			[dbPrivateContent].[dbo].[tblNewsItems]
		SET 
			[MajorStatus]=1, 
			[MinorStatus]=100,
			[PublishDate]=GetDate()
		WHERE 
			[NewsID]=@NewsID
	
	
	
		--Pictures
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
	
		--Search
		INSERT INTO 
			[dbPublicNews].[dbo].[tblNewsSearch]
			(
			[NewsID], 
			[SearchWords]
			)
			SELECT 
				[NewsID], 
				[SearchWords] 
			FROM 
				[dbPrivateContent].[dbo].[tblNewsSearch] (NOLOCK)
			WHERE 
				[NewsID]=@NewsID
		
		--KeyWords
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
	
	
		--News
		INSERT INTO 
			[dbPublicNews].[dbo].[tblNewsItems]
				(
				[NewsID], 
				[PublishDate], 
				[HeadLine], 
				[FirstParagraph], 
				[FinalStory], 
				[Active]
				)
			SELECT 
				[NewsID], 
				GetDate(), 
				[HeadLine], 
				[FirstParagraph], 
				[FinalStory], 
				1
			FROM 
				[dbPrivateContent].[dbo].[tblNewsItems] (NOLOCK)
			WHERE 
				[NewsID]=@NewsID

	END














GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [dbo].[dsp_NEWS_NewsItemPublish]  TO [EnergyUser]
GO

