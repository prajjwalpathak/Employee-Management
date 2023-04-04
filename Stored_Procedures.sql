USE [organizationdb]
GO
/****** Object:  StoredProcedure [dbo].[spusers_getcurrentuser]    Script Date: 4/5/2023 1:18:10 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spusers_getcurrentuser]
	@email nvarchar(255)
AS
BEGIN
	SELECT * from dbo.users where email = @email
	SET NOCOUNT ON;
END
GO
/****** Object:  StoredProcedure [dbo].[spusers_getuser]    Script Date: 4/5/2023 1:18:10 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spusers_getuser]
	@userId int 
AS 
BEGIN
	SELECT * from  dbo.users 
	where id = @userId
	SET NOCOUNT ON;
END
GO
/****** Object:  StoredProcedure [dbo].[spusers_getuserattendance]    Script Date: 4/5/2023 1:18:10 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spusers_getuserattendance]
	@userId int 
AS 
BEGIN
	SELECT * from  dbo.userAttendances
	where userId = @userId
	SET NOCOUNT ON;
END
GO
/****** Object:  StoredProcedure [dbo].[spusers_getuserlatesttimesheets]    Script Date: 4/5/2023 1:18:10 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spusers_getuserlatesttimesheets]
	@userId int 
AS 
BEGIN
	SELECT * from  dbo.userTimesheets
	where userId = @userId
	ORDER BY dbo.userTimesheets.id DESC
	SET NOCOUNT ON;
END
GO
/****** Object:  StoredProcedure [dbo].[spusers_getuserprofile]    Script Date: 4/5/2023 1:18:10 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spusers_getuserprofile]
	@userId int 
AS 
BEGIN
	SELECT dbo.users.id, image, permanentAddress,city, state, country, emergencyPhone, hrmid, name, email, password, phone, role, reportingManager, location, joiningDate from  dbo.users LEFT JOIN dbo.userProfiles ON dbo.users.id = dbo.userProfiles.userId
	where dbo.users.id = @userId
	SET NOCOUNT ON;
END
GO
/****** Object:  StoredProcedure [dbo].[spusers_getuserprojects]    Script Date: 4/5/2023 1:18:10 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spusers_getuserprojects]
	@userId int 
AS 
BEGIN
	SELECT * from  dbo.userProjects
	where userId = @userId
	SET NOCOUNT ON;
END
GO
/****** Object:  StoredProcedure [dbo].[spusers_getuserrequests]    Script Date: 4/5/2023 1:18:10 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spusers_getuserrequests]
	@userId int 
AS 
BEGIN
	SELECT * from  dbo.userRequests
	where userId = @userId
	SET NOCOUNT ON;
END
GO
/****** Object:  StoredProcedure [dbo].[spusers_getuserskills]    Script Date: 4/5/2023 1:18:10 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spusers_getuserskills]
	@userId int 
AS 
BEGIN
	SELECT dbo.users.id, primarySkills, secondarySkills, certifications, hrmid, name, email, password, phone, role, reportingManager, location, joiningDate from  dbo.users LEFT JOIN dbo.userSkills ON dbo.userSkills.userId = dbo.users.id
	where dbo.users.id = @userId
	SET NOCOUNT ON;
END
GO
/****** Object:  StoredProcedure [dbo].[spusers_getusertimesheets]    Script Date: 4/5/2023 1:18:10 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spusers_getusertimesheets]
	@userId int 
AS 
BEGIN
	SELECT * from  dbo.userTimesheets
	where userId = @userId
	SET NOCOUNT ON;
END
GO
/****** Object:  StoredProcedure [dbo].[spusers_postusercheckin]    Script Date: 4/5/2023 1:18:10 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spusers_postusercheckin]
	@userId int, @checkInTime time(7), @checkInDate date, @location nvarchar(255)
AS 
BEGIN
	INSERT INTO dbo.userAttendances (userId, checkInTime, checkInDate, location)
	values (@userId, @checkInTime, @checkInDate, @location)
END
GO
/****** Object:  StoredProcedure [dbo].[spusers_postuserprofile]    Script Date: 4/5/2023 1:18:10 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spusers_postuserprofile]
	@userId int, @image nvarchar(255), @permanentAddress nvarchar(255), @city nvarchar(255), @state nvarchar(255),@country nvarchar(255), @emergencyPhone nvarchar(255)
AS 
BEGIN
	IF NOT EXISTS (SELECT userId from dbo.userProfiles WHERE userId = @userId)
	INSERT INTO dbo.userProfiles (userId, image, permanentAddress , city, state, country, emergencyPhone)
	values (@userId, @image, @permanentAddress ,  @city ,  @state,@country,  @emergencyPhone)
END
GO
/****** Object:  StoredProcedure [dbo].[spusers_postuserproject]    Script Date: 4/5/2023 1:18:10 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spusers_postuserproject]
	@userId int, @projectId nvarchar(255), @projectName nvarchar(255), @assignedOn date, @completeBy date, @teamMembers nvarchar(255), @teamHead nvarchar(255), @department nvarchar(255)
AS 
BEGIN
	IF NOT EXISTS (SELECT userId, projectId from dbo.userProjects WHERE userId = @userId AND projectId = @projectId)
	INSERT INTO dbo.userProjects(userId, projectId, projectName, assignedOn, completeBy, teamMembers, teamHead, department)
	values (@userId, @projectId, @projectName, @assignedOn, @completeBy, @teamMembers, @teamHead, @department)
END
GO
/****** Object:  StoredProcedure [dbo].[spusers_postuserrequest]    Script Date: 4/5/2023 1:18:10 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spusers_postuserrequest]
	@userId int, @startDate date, @endDate date, @request nvarchar(255), @reason nvarchar(255)
AS 
BEGIN
	INSERT INTO dbo.userRequests(userId,startDate, endDate, request, reason)
	values (@userId,@startDate,@endDate,@request, @reason)
END
GO
/****** Object:  StoredProcedure [dbo].[spusers_postuserskills]    Script Date: 4/5/2023 1:18:10 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spusers_postuserskills]
	@userId int, @primarySkills nvarchar(255), @secondarySkills nvarchar(255),@certifications nvarchar(255)
AS 
BEGIN
	IF NOT EXISTS (SELECT userId from dbo.userSkills WHERE userId = @userId)
	INSERT INTO dbo.userSkills(userId, primarySkills, secondarySkills, certifications)
	values (@userId,@primarySkills,@secondarySkills,@certifications )
END
GO
/****** Object:  StoredProcedure [dbo].[spusers_postusertimesheet]    Script Date: 4/5/2023 1:18:10 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spusers_postusertimesheet]
	@userId int, @timesheetName nvarchar(255), @clientName nvarchar(255), @projectName nvarchar(255), @jobName nvarchar(255), @workItem nvarchar(255), @date date, @week nvarchar(255), @description nvarchar(255), @startTime time(7), @endTime time(7), @billableStatus nvarchar(255), @submittedHours nvarchar(255)
AS 
BEGIN
	IF NOT EXISTS (SELECT userId, date from dbo.userTimesheets WHERE userId = @userId AND date = @date)
	INSERT INTO dbo.userTimesheets(userId, timesheetName, clientName, projectName, jobName, workItem, date, week, description, startTime, endTime, billableStatus, submittedHours)
	values (@userId, @timesheetName, @clientName, @projectName, @jobName, @workItem, @date, @week, @description, @startTime, @endTime, @billableStatus, @submittedHours)
END
GO
/****** Object:  StoredProcedure [dbo].[spusers_updateuserattendance]    Script Date: 4/5/2023 1:18:10 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spusers_updateuserattendance]
	@userId int ,@checkOutDate date,@checkOutTime time(7)
AS 
BEGIN
	UPDATE dbo.userAttendances
	SET checkOutDate=@checkOutDate, checkOutTime=@checkOutTime
	where userId = @userId AND checkInDate= @checkOutDate
	SET NOCOUNT ON;
END
GO
/****** Object:  StoredProcedure [dbo].[spusers_updateuserprofile]    Script Date: 4/5/2023 1:18:10 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spusers_updateuserprofile]
	@userId int , @image nvarchar(255), @permanentAddress nvarchar(255),@city nvarchar(255) ,@state nvarchar(255),@country nvarchar(255), @emergencyPhone nvarchar(255)
AS 
BEGIN
	UPDATE dbo.userProfiles
	SET image=@image, permanentAddress=@permanentAddress, city=@city, state=@state, country = @country,  emergencyPhone=@emergencyPhone
	where userProfiles.id = @userId
	SET NOCOUNT ON;
END
GO
/****** Object:  StoredProcedure [dbo].[spusers_updateusersignup]    Script Date: 4/5/2023 1:18:10 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spusers_updateusersignup]
	@name nvarchar(255), @email nvarchar(255),@password nvarchar(255)
AS 
BEGIN
	UPDATE dbo.users
	SET name=@name, email=@email, password=@password
	where users.email = @email
	SET NOCOUNT ON; 
END
GO
/****** Object:  StoredProcedure [dbo].[spusers_updateuserskills]    Script Date: 4/5/2023 1:18:10 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spusers_updateuserskills]
	@userId int ,@primarySkills nvarchar(255),@secondarySkills nvarchar(255) ,@certifications nvarchar(255)
AS 
BEGIN
	UPDATE dbo.userSkills
	SET primarySkills=@primarySkills, secondarySkills=@secondarySkills, certifications=@certifications
	where userId = @userId
	SET NOCOUNT ON;
END
GO
