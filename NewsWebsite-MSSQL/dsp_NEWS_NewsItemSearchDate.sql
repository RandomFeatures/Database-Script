SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/*
Description:    Gets list of recent news items
Usage:         	dsp_NEWS_NewsItemSearchDate 0, '1/1/2000', 1'/2/2000'
                
****************History************************************
Date:         	12.05.2006
Author:       	Allen Halsted
Mod:          	Creation
***********************************************************
*/


CREATE PROCEDURE dsp_NEWS_NewsItemSearchDate(
					     @SectionID int = 0,
					     @StartDate Datetime,
					     @EndDate Datetime
					    )
AS 
	
IF (@SectionID = 0)
BEGIN
	SELECT  TOP 50
		n.[NewsID], 
		u.[FirstName] + ' ' + u.[LastName] as username,
		n.[MajorStatus] as MajorStatusCode, 
		n.[MinorStatus] as MinorStatusCode, 
		l1.[LookupDesc] as MinorStatus,
		n.[SubmitDate], 
		n.[PublishDate], 
		n.[HeadLine], 
		n.[FirstParagraph], 
		n.[MainBody],
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
		ns.[NewsID]= n.[NewsID]
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

	WHERE
		n.[MajorStatus]=1
	and
		n.[PublishDate]>@StartDate
	and 
		n.[PublishDate]<dateadd(dd, 1,@EndDate)
		
	ORDER BY n.[NEWSID] DESC
END
ELSE
BEGIN
	SELECT  TOP 50
		n.[NewsID], 
		u.[FirstName] + ' ' + u.[LastName] as username,
		n.[MajorStatus] as MajorStatusCode, 
		n.[MinorStatus] as MinorStatusCode, 
		l1.[LookupDesc] as MinorStatus,
		n.[SubmitDate], 
		n.[PublishDate], 
		n.[HeadLine], 
		n.[FirstParagraph], 
		n.[MainBody], 
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
		ns.[NewsID]= n.[NewsID]
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

	WHERE
		n.[MajorStatus]=1
	and
		ns.[SectionID]=@SectionID
	and
		n.[PublishDate]>@StartDate
	and 
		n.[PublishDate]<dateadd(dd, 1,@EndDate)
	
	ORDER BY n.[NEWSID] DESC

END




GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [dbo].[dsp_NEWS_NewsItemSearchDate]  TO [EnergyUser]
GO

