SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
/*
Description:    Insert a new Event into the system
Usage:         	dsp_NEWS_EventInsert 1, 1, 1, "Comment"
                
****************History************************************
Date:         	10.18.2006
Author:       	Allen Halsted
Mod:          	Creation
***********************************************************
*/


CREATE    PROCEDURE dsp_NEWS_EventInsert(
					@NewsID  int,
					@EventCode int,
					@UserID int,
					@Comment varchar(255)
					)
AS 
Declare 
	@NewMinorStatus int,
	@NewMajorStatus int,
	@EventID int
	
	--Insert the new record
	INSERT INTO 
		[dbPrivateContent].[dbo].[tblNewsEvents]
		(
		[NewsID], 
		[EventCode], 
		[UserID], 
		[EventDateTime], 
		[Comment]
		)
	VALUES(
		@NewsID,
		@EventCode,
		@UserID,
		GetDate(),
		@Comment
	      )
	SELECT @EventID = @@Identity

	--Get the event status codes
	SELECT 
		@NewMinorStatus = [MinorStatus],
		@NewMajorStatus = [MajorStatus]
	FROM 
		[dbPrivateContent].[dbo].[tblEvents] (NOLOCK)
	WHERE 
		[EventCode]=@EventCode

	--See if this Event Changes the Status
	IF NOT (@NewMinorStatus is NULL) AND NOT (@NewMajorStatus is NULL)
	BEGIN
		-- change both
		UPDATE 
			[dbPrivateContent].[dbo].[tblNewsItems]
		SET 
			[MajorStatus]=@NewMajorStatus, 
			[MinorStatus]=@NewMinorStatus
		WHERE 
			[NewsID]=@NewsID
	END
	ELSE
	BEGIN
		IF NOT (@NewMinorStatus is NULL) 
		BEGIN
			--just change the minor
			UPDATE 
				[dbPrivateContent].[dbo].[tblNewsItems]
			SET 
				[MinorStatus]=@NewMinorStatus
			WHERE 
				[NewsID]=@NewsID
		END

	END

	SELECT @EventID

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [dbo].[dsp_NEWS_EventInsert]  TO [EnergyUser]
GO

