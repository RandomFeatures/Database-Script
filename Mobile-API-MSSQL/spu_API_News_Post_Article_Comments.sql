USE [Website]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*************************************************************
* Purpose: Post a comment to a given article
* System: Mobile API
* Caller: MobileDAL.NewsDAO.PostArticleComments
* Author: Allen Halsted
*************************************************************
* Date: 6/5/2013
* Changed By: Allen Halsted
* Modification: Creation
*************************************************************/
CREATE PROCEDURE [dbo].[spu_API_News_Post_Article_Comments]
(
	@Article_ID INT,
	@User_ID INT,
	@User_Name VARCHAR(50) = '',
	@Comment VARCHAR(max)	
)

AS
SET NOCOUNT ON

DECLARE @Email_Address VARCHAR(75)
DECLARE @Full_Name VARCHAR(50)

SELECT 
	@Email_Address = [Email],
	@Full_Name = [FirstName] + ' ' + [LastName]
FROM 
	[Website].[dbo].[Users]
WHERE 
	[UserID] = @User_ID

IF LTRIM(RTRIM(@Full_Name))	= ''
	SET @Full_Name = @User_Name
	
INSERT INTO 
	[Website].[dbo].[News_Article_Comment]
		(
			 [Article_ID]
			,[User_ID]
			,[Email_Address]
            ,[Full_Name]
            ,[Comment]
            ,[Comment_Date]
			,[Source_Code]
			
		) 
VALUES (
			 @Article_ID
			,@User_ID
			,@Email_Address
            ,@Full_Name
            ,@Comment
            ,GETDATE()
			,'M'
		) 


DECLARE @Author_Email VARCHAR(50)
DECLARE @Article_Title VARCHAR(100)
DECLARE @Email_Body VARCHAR(8000)
DECLARE @Email_Subject VARCHAR(150) = 'Website News Article Comment Added'
DECLARE @Article_Date smalldatetime

SELECT 
		 @Author_Email = a.Author_Email
		,@Article_Title = na.Title
		,@Article_Date = na.Article_Date
FROM 
	[Website].[dbo].[News_Article] na
LEFT JOIN 
	[Website].[dbo].[News_Author] a
ON 
	na.[Author_ID] = a.[Author_ID]
WHERE 
	na.[Article_ID] = @Article_ID

	
Set @Email_Body = '------------------------------------------------------------' + CHAR(13) + CHAR(10)
Set @Email_Body = @Email_Body + 'NEWS ARTICLE COMMENT ADDED' + CHAR(13) + CHAR(10)
Set @Email_Body = @Email_Body + '------------------------------------------------------------' + CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10)
Set @Email_Body = @Email_Body + @Article_Title + CHAR(13) + CHAR(10)
Set @Email_Body = @Email_Body + '  Date: ' + CONVERT(VARCHAR(12), @Article_Date, 107) + CHAR(13) + CHAR(10)
Set @Email_Body = @Email_Body + '  http://www.website.com/news/article?a_id=' + CONVERT(VARCHAR(20),@Article_ID) + CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10)
Set @Email_Body = @Email_Body + 'Full Name: ' + @Full_Name + CHAR(13) + CHAR(10)
Set @Email_Body = @Email_Body + 'Email: ' + @Email_Address + CHAR(13) + CHAR(10)
Set @Email_Body = @Email_Body + 'Comment: ' + CHAR(13) + CHAR(10)
Set @Email_Body = @Email_Body + '------------------------------------------------------------' + CHAR(13) + CHAR(10) + @Comment
		
EXEC [Portal].[dbo].[spu_Send_Email] 16,'news@Website.com','info@Website.com',@Email_Subject,@Email_Body, 0

IF LTRIM( RTRIM( ISNULL( @Author_Email, '' ) ) ) <> ''
BEGIN
    EXEC [Portal].[dbo].[spu_Send_Email] 16,@Author_Email,'info@Website.com',@Email_Subject,@Email_Body, 0
END
		
		
		
RETURN @@IDENTITY


GO

