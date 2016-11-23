SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/*
Description:    Gets list of recent news items
Usage:         	dsp_NEWS_NewsItemPublishedList 
                
****************History************************************
Date:         	12.05.2006
Author:       	Allen Halsted
Mod:          	Creation
***********************************************************
*/


ALTER     PROCEDURE dsp_NEWS_NewsItemPublishedList(
						@SectionID int = 0, 
						@SubsectionID int = 0
						)
AS 
	
set rowcount 50

IF (@SectionID = 0)
BEGIN

	SELECT  
		distinct (n.[NewsID]), 
		u.[FirstName] + ' ' + u.[LastName] as username,
		n.[SubmitDate], 
		n.[PublishDate],
		n.[HeadLine], 
		u2.[FirstName] + ' ' + u2.[LastName] as publishername,
		s.[SectionName],
		ss.[SubSection],
		ns.[SectionID]

	FROM 
		[dbPrivateContent].[dbo].[tblNewsItems] n (NOLOCK)
	JOIN
		[dbPrivateContent].[dbo].[tblUsers] u (NOLOCK)
	ON
		n.[userID] = u.[userID]
	JOIN
		[dbPrivateContent].[dbo].[tblNewsSections] ns (NOLOCK)
	ON
		ns.[ID]= (select 
				max([ID])
			  from 
				[dbPrivateContent].[dbo].[tblNewsSections] (NOLOCK)
			  where
				[newsid] = n.[NewsID]
			  and
				[SectionID] < 5
			)
	LEFT JOIN
		[dbPrivateContent].[dbo].[tblSections] s (NOLOCK)
	ON
		s.[SectionID]=ns.[SectionID]
	LEFT JOIN
		[dbPrivateContent].[dbo].[tblSubSections] ss (NOLOCK)
	ON
		ss.[SectionID]=ns.[SectionID]
	and
		ss.[SubsectionID]=ns.[subsectionid]
	LEFT JOIN
		[dbPrivateContent].[dbo].[tblNewsEvents] e (NOLOCK)
	ON
		e.[NewsID] = n.[NewsID]
	and
		e.[EventCode] = 500
	LEFT JOIN
		[dbPrivateContent].[dbo].[tblUsers] u2 (NOLOCK)
	ON
		e.[userID] = u2.[userID]

	WHERE
		n.[MajorStatus]=1
		
	ORDER BY n.[NEWSID] DESC
END
ELSE
BEGIN
	SELECT  
		Distinct (n.[NewsID]), 
		u.[FirstName] + ' ' + u.[LastName] as username,
		n.[SubmitDate], 
		n.[PublishDate], 
		n.[HeadLine], 
		u2.[FirstName] + ' ' + u2.[LastName] as publishername,
		s.[SectionName],
		ss.[SubSection],
		ns.[SectionID]

	FROM 
		[dbPrivateContent].[dbo].[tblNewsItems] n (NOLOCK)
	JOIN
		[dbPrivateContent].[dbo].[tblUsers] u (NOLOCK)
	ON
		n.[userID] = u.[userID]
	JOIN
		[dbPrivateContent].[dbo].[tblNewsSections] ns (NOLOCK)
	ON
		ns.[NewsID]= n.[NewsID]
	and
		ns.[SectionID]=@SectionID
	and 	
		(@SubsectionID=0 or ns.[SubsectionID]=@SubsectionID)
			
	LEFT JOIN
		[dbPrivateContent].[dbo].[tblSections] s (NOLOCK)
	ON
		s.[SectionID]=ns.[SectionID]
	LEFT JOIN
		[dbPrivateContent].[dbo].[tblSubSections] ss (NOLOCK)
	ON
		ss.[SectionID]=ns.[SectionID]
	and
		ss.[SubsectionID]=ns.[subsectionid]
	LEFT JOIN
		[dbPrivateContent].[dbo].[tblNewsEvents] e (NOLOCK)
	ON
		e.[NewsID] = n.[NewsID]
	and
		e.[EventCode] = 500
	LEFT JOIN
		[dbPrivateContent].[dbo].[tblUsers] u2 (NOLOCK)
	ON
		e.[userID] = u2.[userID]

	WHERE
		n.[MajorStatus]=1
		
	ORDER BY n.[NEWSID] DESC

END

set rowcount 0











GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

