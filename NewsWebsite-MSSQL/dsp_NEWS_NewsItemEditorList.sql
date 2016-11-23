SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/*
Description:    Gets list of news items needing editing
Usage:         	dsp_NEWS_NewsItemEditorList 21
                
****************History************************************
Date:         	10.20.2006
Author:       	Allen Halsted
Mod:          	Creation
***********************************************************
*/


CREATE PROCEDURE dsp_NEWS_NewsItemEditorList(@UserID int)
AS 
	SELECT 
		n.[NewsID],
		u.[FirstName] + ' ' + u.[LastName] as username,
		n.[MajorStatus] as MajorStatusCode, 
		l2.[LookupDesc] as MajorStatus,
		n.[MinorStatus] as MinorStatusCode, 
		l1.[LookupDesc] as MinorStatus,
		n.[SubmitDate], 
		n.[PublishDate], 
		n.[HeadLine], 
		n.[FirstParagraph], 
		n.[MainBody], 
		l.[LayoutName],
		n.[LayoutID], 
		n.[MsgWaiting]
	FROM 
		[dbPrivateContent].[dbo].[tblNewsItems] n (NOLOCK)
	JOIN
		[dbPrivateContent].[dbo].[tblLookup] l1 (NOLOCK)
	ON
		n.[MinorStatus] = l1.[LookupCode] and l1.[Lookuptype] = 'MinorStatus'
	JOIN
		[dbPrivateContent].[dbo].[tblLookup] l2 (NOLOCK)
	ON
		n.[MajorStatus] = l2.[LookupCode] and l2.[Lookuptype] = 'MajorStatus'
	JOIN
		[dbPrivateContent].[dbo].[tblUsers] u (NOLOCK)
	ON
		n.[userID] = u.[userID]
	LEFT JOIN
		[dbPrivateContent].[dbo].[tblLayoutTemplates] l (NOLOCK)
	ON
		l.[LayoutID] = n.[LayoutID]
	WHERE
		n.[MajorStatus]=0
	and
		(n.[MinorStatus]=40 or n.[MinorStatus]=50)
		
	and	
		n.[UserID]<>@UseriD
	









GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [dbo].[dsp_NEWS_NewsItemEditorList]  TO [EnergyUser]
GO

