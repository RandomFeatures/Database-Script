SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/*
Description:    Record all the ICE Data in a useable format
Usage:         	dsp_ICE_RecordICEData 'ProcessName'  'XML'
                
****************History************************************
Date:         	08.07.2007
Author:       	Allen Halsted
Mod:          	Creation
***********************************************************
*/


CREATE  PROCEDURE dsp_ICE_RecordICEData(	
					@IceID int,   
					@IceMarketID int,   
					@ProductCode varchar(10),   
					@ProductGroupID varchar(10),
					@DeliveryMonth varchar(10),   
					@IceTimeStamp varchar(10),   
					@LastTradePrice varchar(10),   
					@LastTradeVolume varchar(10),   
					@OpenPrice varchar(10),   
					@CurrentHigh varchar(10),   
					@CurrentLow varchar(10),   
					@SettlementPrice varchar(10),   
					@SettlementDate varchar(30),   
					@PreviousOpenInterest varchar(10),   
					@CurrentVolume varchar(10)
					)
AS 

	
	INSERT INTO 
		[dbPrivateContent].[dbo].[tblICEData]
		(
		[IceID],  
		[IceMarketID],  
		[ProductCode],  
		[ProductGroupID],
		[DeliveryMonth],  
		[IceTimeStamp],  
		[LastTradePrice],  
		[LastTradeVolume],  
		[OpenPrice],  
		[CurrentHigh],  
		[CurrentLow],  
		[SettlementPrice],  
		[SettlementDate],  
		[PreviousOpenInterest],
		[CurrentVolume],  
		[RecodeDateTime]
		)
	
	VALUES (
		@IceID, 
		@IceMarketID,
		@ProductCode,
		@ProductGroupID,
		@DeliveryMonth,
		@IceTimeStamp,
		@LastTradePrice,
		@LastTradeVolume, 
		@OpenPrice,
		@CurrentHigh,
		@CurrentLow ,
		@SettlementPrice ,
		@SettlementDate,
		@PreviousOpenInterest,
		@CurrentVolume,
		GetDate() 
		)

	

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [dbo].[dsp_ICE_RecordICEData]  TO [EnergyUser]
GO



