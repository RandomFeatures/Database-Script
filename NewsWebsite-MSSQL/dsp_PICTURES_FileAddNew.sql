SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/*
Description:    Insert a new File and Assoicate it with an existing template
Usage:         	dsp_PICTURES_FileAddNew 0, 1, 'logo.gif',0,base64blah
                
****************History************************************
Date:         	10.16.2006
Author:       	Allen Halsted
Mod:          	Creation
***********************************************************
Date:         	06.30.2008
Author:       	Allen Halsted
Mod:          	changed @PicturePath to know if it is for a
		new image or editing an existing
***********************************************************
*/

ALTER   PROCEDURE dbo.dsp_PICTURES_FileAddNew(
					    @NewsID int = 0,
					    @PictureType int,
					    @PictureName varchar(100),
					    @PictureAltText varchar(50),
					    @PictureBinary Text,
					    @PicturePath varchar(300),
					    @PictureCaption varchar(250),
					    @Comment varchar(300)
					    )
AS 
declare @PictureID int
Select @PictureID = 0


	IF NOT EXISTS  (
			SELECT 
				[PictureID]
			FROM 
				[dbPrivateContent].[dbo].[tblPictures] (NOLOCK)
			WHERE
				[PictureName]=@PictureName
			)
	BEGIN		
				
		INSERT INTO 
			[dbPrivateContent].[dbo].[tblPictures]
			(
			[PictureType], 
			[PictureName], 
			[PictureAltText],
			[PictureBinary],
			[PictureCaption],
			[PictureNew],
			[PicturePath],
			[Comment],
			[Active]
			)
		VALUES(
			@PictureType,
			@PictureName,
			@PictureAltText,
			@PictureBinary,
			@PictureCaption,
			1,
			@PicturePath,
			@Comment,
			1
			)

		SELECT @PictureID = @@Identity

		--Put the new picture in the news database too
		INSERT INTO 
			[dbPublicNews].[dbo].[tblPictures]
			(
			[PictureID],
			[PictureType], 
			[PictureName], 
			[PictureAltText],
			[PictureBinary],
			[PictureCaption]
			)
		VALUES(
			@PictureID,
			@PictureType,
			@PictureName,
			@PictureAltText,
			@PictureBinary,
			@PictureCaption
			)

	END
	ELSE
	BEGIN
		--path wasnt changed so get the orginal
		IF @PicturePath='Edited' 
		BEGIN
			SELECT @PicturePath = [PicturePath]
			FROM [dbPrivateContent].[dbo].[tblPictures]
			WHERE [PictureName]=@PictureName
		END	

		UPDATE 
			[dbPrivateContent].[dbo].[tblPictures]
		SET 
			[PictureBinary] = @PictureBinary,
			[PictureAltText] = @PictureAltText,
			[PictureCaption] = @PictureCaption,
			[PicturePath] = @PicturePath,
			[Comment] = @Comment,
			[PictureNew] = 1
		WHERE
 			[PictureName]=@PictureName


		UPDATE 
			[dbPublicNews].[dbo].[tblPictures]
		SET 
			[PictureBinary] = @PictureBinary,
			[PictureAltText] = @PictureAltText,
			[PictureCaption] = @PictureCaption
		WHERE
 			[PictureName]=@PictureName
	END

	


SELECT @PictureID













GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

