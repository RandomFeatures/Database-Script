
USE [website]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
/*************************************************************
* Purpose: Get a list News that are bookmarked for a give user
* System: Mobile API
* Caller: MobileDAL.NewsDAO.GetBookmarkedNewsList
* Author: Allen Halsted
*************************************************************
* Date: 5/20/2013
* Changed By: Allen Halsted
* Modification: Creation
*************************************************************/
CREATE PROCEDURE [dbo].[spu_API_User_News_Bookmarks]
(
	@UserID int
)
AS
SET NOCOUNT ON

SELECT 
		 b.[Bookmark_ID]
		,CONVERT(VARCHAR(30), b.[Date_Created], 23) as 'Bookmark_Created'
		,jp.[Posting_ID]
		,jp.[Job_Title]
		,jp.[Job_Country_ID]
		,ctry.[Country_Name]
		,ctry.[Region_ID]
		,r.[Region_Name]
		,sr.[Super_Region_ID]
        ,sr.[Super_Region_Name]
		,jp.[Job_Location]
		,jp.[Job_State]
		,CONVERT(VARCHAR(30), jp.[Date_Created], 23) as 'Date_Created'
		,jsc.[Skill_Cat] AS Category_Name
		,jsc.[News_Skill_Cat_ID] AS News_Category_ID
		,je.[Education_Level]
		,je.[Display_Order] AS Edu_Display_Order
		,jet.[Employment_Type] AS Employment_Type
FROM 
	[website].[dbo].[News_Posting_Bookmark] b
JOIN 
	[website].[dbo].[News_Posting] jp 	
ON
	jp.[Posting_ID] = b.[Posting_ID]
CROSS APPLY
        (
        SELECT  TOP 1 [Skill_ID]
        FROM    [website].[dbo].[News_Posting_Skill_Xref] jsx (nolock)
        WHERE   jsx.[Posting_ID] = jp.[Posting_ID]
        ) Skill_ID	
LEFT JOIN 
	[website].[dbo].[Country] ctry
ON 
	jp.[Job_Country_ID] = ctry.[Country_ID]
LEFT JOIN  
	[website].[dbo].[Country_Region] r
ON 
	ctry.[Region_ID] = r.[Region_ID]
LEFT JOIN
	[website].[dbo].[Country_Super_Region] sr
ON
	ctry.[Super_Region_ID] = sr.[Super_Region_ID]	
WHERE
	b.[UserID] = @UserID
AND
	b.[Is_Active] = 1
ORDER BY
	b.[Date_Created] DESC
	
GO

