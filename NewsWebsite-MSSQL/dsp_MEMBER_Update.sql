SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/*
Description:    Update Member in the system
Usage:         	dsp_MEMBER_Update 0, 'login','FName', 'LName', 'Email@me.com', 'Pass'
                
****************History************************************
Date:         	05.23.2007
Author:       	Allen Halsted
Mod:          	Creation
***********************************************************
*/

CREATE    PROCEDURE dsp_MEMBER_Update(	
					@MemberID int,
					@CC_MemberID int,
					@FirstName varchar(25),
					@LastName varchar(25),
					@EMail varchar(50),
					@Password varchar(25),
					@Title Varchar(25),
					@Address1 Varchar(255),
					@Address2 Varchar(255),
					@City Varchar(255),
					@State Varchar(255),
					@ZipCode Varchar(25),
					@Country Int,
					@Phone Varchar(50),
					@Mobile Varchar(50)
					)
AS 
	IF (@MemberID = -1 and @CC_MemberID > 0) 
	BEGIN
		UPDATE 
			[dbMemberData].[dbo].[tblMembers] 
		SET 
			[FirstName] = @FirstName,
			[LastName] = @LastName,
			[Email] = @EMail,
			[title] = @title,
			[Password] = @Password,
			[Address1] = @Address1,
			[Address2] = @Address2,
			[City] = @City,
			[State] = @State,
			[ZipCode] = @ZipCode,
			[Country] = @Country,
			[Phone] = @Phone,
			[Mobile] = @Mobile
		WHERE
			[cc_MemberID]=@CC_MemberID
	
	END
	ELSE
	BEGIN
		UPDATE 
			[dbMemberData].[dbo].[tblMembers] 
		SET 
			[FirstName] = @FirstName,
			[LastName] = @LastName,
			[Email] = @EMail,
			[title] = @title,
			[Password] = @Password,
			[Address1] = @Address1,
			[Address2] = @Address2,
			[City] = @City,
			[State] = @State,
			[ZipCode] = @ZipCode,
			[Country] = @Country,
			[Phone] = @Phone,
			[Mobile] = @Mobile
		WHERE
			[MemberID]=@MemberID
	END	






GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [dbo].[dsp_MEMBER_Update]  TO [webuser]
GO

