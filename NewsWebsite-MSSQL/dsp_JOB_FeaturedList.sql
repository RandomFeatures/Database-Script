SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

/*
Description:    Gets a list of an featured jobs
Usage:         	dsp_JOB_FeaturedList
                
****************History************************************
Date:         	08.28.2007
Author:       	Allen Halsted
Mod:          	Creation
***********************************************************
Date:         	02.18.2009
Author:       	Allen Halsted
Mod:          	Added support for featured employers
		to get their jobs in without making the 
		job featured
***********************************************************
*/

ALTER PROCEDURE dbo.dsp_JOB_FeaturedList
AS 

	Create table #tmp
	(
		[ID] int IDENTITY (1, 1) NOT NULL ,
		[JobID] int NOT NULL, 
		[PostedDate] DateTime NOT NULL,
		[JobTitle] varchar(200) not null,
		[Location] varchar(200) not null,
		[CompanyName]varchar(100) not null,
		[EmployerID]int NOT NULL,
		[JobDesc] varchar(6000) not null,
	)

	Create table #tmp2
	(
		[ID] int IDENTITY (1, 1) NOT NULL ,
		[JobID] int NOT NULL, 
		[PostedDate] DateTime NOT NULL,
		[JobTitle] varchar(200) not null,
		[Location] varchar(200) not null,
		[CompanyName]varchar(100) not null,
		[EmployerID]int NOT NULL,
		[JobDesc] varchar(6000) not null,
	)

	--Put in categories with jobs and count them
	Insert into #tmp ([JobID], [PostedDate], [JobTitle], [Location], [CompanyName], [EmployerID], [JobDesc])
	SELECT 
		j.[JobID],
		j.[PostedDate], 
		j.[JobTitle],
		l.[Country] as [Location],
		e.[CompanyName],
		j.[EmployerID],
		j.[JobDesc]
	FROM 
		[dbCareer].[dbo].[tblJobs] j (NOLOCK)
	JOIN
		[dbCareer].[dbo].[tblEmployer] e (NOLOCK)
	ON
		j.[EmployerID] = e.[EmployerID]
	JOIN
		[dbCareer].[dbo].[tblLocations] l (NOLOCK)
	ON
		j.[Location]=l.[ID]
	WHERE
		j.[FeatureDate] > DateAdd(wk,-1,getdate())
	AND
		j.[Featured]=1		
	AND 
		j.[Removed]=0
	AND
		j.[Visible]=1
	AND
		e.[Suspended]=0
	

	--get all jobs from employers who are featured
	Insert into #tmp ([JobID], [PostedDate], [JobTitle], [Location], [CompanyName], [EmployerID], [JobDesc])
	SELECT 
		j.[JobID],
		j.[PostedDate], 
		j.[JobTitle],
		l.[Country] as [Location],
		e.[CompanyName],
		j.[EmployerID],
		j.[JobDesc]
	FROM 
		[dbCareer].[dbo].[tblJobs] j (NOLOCK)
	JOIN
		[dbCareer].[dbo].[tblEmployer] e (NOLOCK)
	ON
		j.[EmployerID] = e.[EmployerID]
	JOIN
		[dbCareer].[dbo].[tblLocations] l (NOLOCK)
	ON
		j.[Location]=l.[ID]
	LEFT JOIN
		#tmp t
	ON
		t.[JobID]=j.[JobID]
	WHERE
		t.[JobID] is NULL
	AND
		--e.[Expiration] > getdate() --still featured
		DATEADD(dd,1,e.[Expiration])<=GETDATE()--still featured		
	AND 
		j.[Removed]=0
	AND
		j.[Visible]=1
	AND
		e.[Suspended]=0
	
	
	Insert into #tmp2 ([JobID], [PostedDate], [JobTitle], [Location], [CompanyName], [EmployerID], [JobDesc])
	SELECT Top 10
		[JobID],
		[PostedDate], 
		[JobTitle],
		 [Location],
		[CompanyName],
		[EmployerID],
		[JobDesc]
	FROM
		#tmp
	Order By
		newid()

	--fill in with non featured jobs just to fill things out
	Insert into #tmp2 ([JobID], [PostedDate], [JobTitle], [Location], [CompanyName], [EmployerID], [JobDesc])
	SELECT Top 10
		j.[JobID],
		j.[PostedDate], 
		j.[JobTitle],
		l.[Country] as [Location],
		e.[CompanyName],
		j.[EmployerID],
		j.[JobDesc]
	FROM 
		[dbCareer].[dbo].[tblJobs] j (NOLOCK)
	JOIN
		[dbCareer].[dbo].[tblEmployer] e (NOLOCK)
	ON
		j.[EmployerID] = e.[EmployerID]
	JOIN
		[dbCareer].[dbo].[tblLocations] l (NOLOCK)
	ON
		j.[Location]=l.[ID]
	LEFT JOIN
		#tmp2 t
	ON
		t.[JobID]=j.[JobID]
	WHERE
		t.[JobID] is NULL
	AND 
		j.[Removed]=0
	AND
		j.[Visible]=1
	AND
		e.[Suspended]=0
	Order By
		j.[PostedDate]

	--only need 10
	SELECT TOP 10
		[JobID], 
		[PostedDate], 
		[JobTitle], 
		[Location], 
		[CompanyName], 
		[EmployerID], 
		[JobDesc]
	FROM 
		#tmp2

Drop Table #tmp
Drop Table #tmp2





GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [dbo].[dsp_JOB_FeaturedList]  TO [WebUser]
GO

