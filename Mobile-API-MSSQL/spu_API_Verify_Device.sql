USE [Notifications]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
/*************************************************************
* Purpose: Verifiy that the UserID and the deviceID match to
		   prevent people from trying to access someone else's
		   account.
* System: Mobile API
* Caller: MobileDAL.RegisterDAO.VerifyDevice
* Author: Allen Halsted
*************************************************************
* Date: 5/23/2013
* Changed By: Allen Halsted
* Modification: Creation
*************************************************************/
CREATE PROCEDURE [dbo].[spu_API_Verify_Device]
	(
	@UserID Integer,
	@DeviceID Varchar(256)
	)
AS
SET NOCOUNT ON


DECLARE @Status Integer
DECLARE @DeviceXrefID Integer

SET @Status = 0
SET @DeviceXrefID = 0


IF NOT EXISTS(
			SELECT 
				[Device_Xref_ID]
			FROM 
				[Notifications].[dbo].[User_Device_Xref]
			WHERE  
				  [Device_ID] = @DeviceID
			)
BEGIN
	SELECT 
		@DeviceXrefID = [Device_Xref_ID]
	FROM 
		[Notifications].[dbo].[User_Device_Xref]
	WHERE  
		[Device_ID] = @DeviceID
	SET @Status = 0 --Device Not Registered
END
ELSE
IF EXISTS(
			SELECT 
				[Device_Xref_ID]
			FROM 
				[Notifications].[dbo].[User_Device_Xref]
			WHERE  
				  [Device_ID] = @DeviceID
			AND      
				  [User_ID] = @UserID
		 )
BEGIN
	SELECT 
		@DeviceXrefID = [Device_Xref_ID]
	FROM 
		[Notifications].[dbo].[User_Device_Xref]
	WHERE  
		  [Device_ID] = @DeviceID
	AND      
		  [User_ID] = @UserID
	
	SET @Status = 1 -- Device & User Match
END	
ELSE
IF EXISTS(
			SELECT 
				[Device_Xref_ID]
			FROM 
				[Notifications].[dbo].[User_Device_Xref]
			WHERE  
				  [Device_ID] = @DeviceID
			AND      
				  [User_ID] is NULL
		 )
BEGIN		 
	SELECT 
		@DeviceXrefID = [Device_Xref_ID]
	FROM 
		[Notifications].[dbo].[User_Device_Xref]
	WHERE  
		  [Device_ID] = @DeviceID
	AND      
		  [User_ID] is NULL		 

	SET @Status = 2 -- User Not Registered to this Device
END	
ELSE
BEGIN
	
	DECLARE @OtherUser Integer
		
	SELECT 
		@OtherUser = [User_ID]
	FROM 
		[Notifications].[dbo].[User_Device_Xref]
	WHERE  
	  [Device_ID] = @DeviceID

	IF @OtherUser <> @UserID
		SET @Status = 3  -- Device Registered to a different User

END


SELECT @Status AS 'Status', @DeviceXrefID as 'DeviceXrefID'

GO
