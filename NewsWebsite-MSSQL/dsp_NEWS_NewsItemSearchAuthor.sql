SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/*
Description:    Gets list of recent news items
Usage:         	dsp_NEWS_NewsItemSearchAuthor 0
                
****************History************************************
Date:         	12.05.2006
Author:       	Allen Halsted
Mod:          	Creation
***********************************************************
*/


CREATE  PROCEDURE dsp_NEWS_NewsItemSearchAuthor(@UserID int,
					     	  @StartDate Datetime,
					          @EndDate Datetime)
AS 
	
set rowcount 50

	SELECT  
		distinct (n.[NewsID]), 
		u.[FirstName] + ' ' + u.[LastName] as username,
		n.[SubmitDate], 
		n.[PublishDate], 
		n.[HeadLine], 
		u2.[FirstName] + ' ' + u2.[LastName] as publishername,
		s.[SectionName],
		ss.[SubSection]

	FROM 
		[dbPrivateContent].[dbo].[tblNewsItems] n (NOLOCK)
	JOIN
		[dbPrivateContent].[dbo].[tblLookup] l1 (NOLOCK)
	ON
		n.[MinorStatus] = l1.[LookupCode] and l1.[Lookuptype] = 'MinorStatus'
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
			)
	LEFT JOIN
		[dbPrivateContent].[dbo].[tblSections] s (NOLOCK)
	ON
		s.[SectionID]=ns.[SectionID]
	LEFT JOIN
		[dbPrivateContent].[dbo].[tblSubSections] ss (NOLOCK)
	ON
		ss.[SectionID]=s.[SectionID]
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
	and
		u.[userid]=@UserID
	and
		n.[PublishDate]>@StartDate
	and 
		n.[PublishDate]<dateadd(dd, 1,@EndDate)
		
	ORDER BY n.[NEWSID] DESC

set rowcount 0






GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [dbo].[dsp_NEWS_NewsItemSearchAuthor]  TO [EnergyUser]
GO

