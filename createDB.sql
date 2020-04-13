USE [master]
GO
IF EXISTS
(
	SELECT
		*
	FROM [master].[sys].[databases]
	WHERE [name] = N'Hotels Booking Manager'
)
BEGIN
	DROP DATABASE [Hotels Booking Manager]
END
GO
CREATE DATABASE [Hotels Booking Manager]
GO 
USE [Hotels Booking Manager]
GO
/*CREATE TABLES IN DATABASE*/
/*Account table*/
CREATE TABLE [Accounts]
(
	AccountID   CHAR(20),
	PhoneNumber CHAR(20),
	Email       VARCHAR(254),
	BankAccount VARCHAR(20)
	
	PRIMARY KEY (AccountID)
)
GO
/*Customer table */
CREATE TABLE [Customers]
(
	AccountID    CHAR(20),
	FirstName    NVARCHAR(50) NOT NULL,
	LastName     NVARCHAR(50) NOT NULL,
	DateOfBirth  DATE,
	Gender       BIT NOT NULL

	PRIMARY KEY (AccountID),
	FOREIGN KEY (AccountID) REFERENCES [Accounts](AccountID)
)
GO
/*Hotel host table*/
CREATE TABLE [HotelHosts]
(
	AccountID CHAR(20),
	[Name]    NVARCHAR(50) NOT NULL

	PRIMARY KEY (AccountID),
	FOREIGN KEY (AccountID) REFERENCES [Accounts](AccountID)
)
GO
/*Country table*/
CREATE TABLE [Countries]
(
	CountryName NVARCHAR(50)

	PRIMARY KEY (CountryName)
)
/*Provinces table*/ 
CREATE TABLE [Provinces]
(
	CountryName NVARCHAR(50),
	ProvinceName NVARCHAR(50)


	FOREIGN KEY (CountryName) REFERENCES [Countries](CountryName)
	PRIMARY KEY (CountryName, ProvinceName) 
)
GO
/*District table*/
CREATE TABLE [Districts]
(
	CountryName  NVARCHAR(50),
	ProvinceName  NVARCHAR(50),
	DistrictName NVARCHAR(50)

	PRIMARY KEY (CountryName, ProvinceName, DistrictName),
	FOREIGN KEY (CountryName, ProvinceName) REFERENCES [Provinces](CountryName, ProvinceName)
)
GO
/*Hotel table*/
CREATE TABLE [Hotels]
(
	HotelID         CHAR(20),
	[Name]          NVARCHAR(50),
	PhoneNumber     CHAR(20),
	[Description]   NTEXT,
	SpecificAddress NVARCHAR(50),
	DistrictName    NVARCHAR(50),
	ProvinceName     NVARCHAR(50),
	CountryName     NVARCHAR(50),
	AccountID       CHAR(20) NOT NULL

	PRIMARY KEY (HotelID),
	FOREIGN KEY (AccountID) REFERENCES [HotelHosts](AccountID),
	FOREIGN KEY (CountryName, ProvinceName, DistrictName) REFERENCES [Districts](CountryName, ProvinceName, DistrictName)
)
GO
/*Room table*/
CREATE TABLE [Rooms]
(
	RoomID     CHAR(20),
	Capacity   INT,
	Price      FLOAT,
	HotelID    CHAR(20)

	PRIMARY KEY(RoomID),
	FOREIGN KEY(HotelID) REFERENCES [Hotels](HotelID)
)
GO
/*Service table*/
CREATE TABLE [Services]
(
	ServiceID CHAR(20),
	[Name] NVARCHAR(50),
	[Description] NTEXT

	PRIMARY KEY(ServiceID)
)
GO
/*CREATE TABLE FOR RELATIONS*/
/*Book is the relationship between Customer and Room*/
CREATE TABLE [Book]
(
	AccountID CHAR(20),
	RoomID CHAR(20),
	QuantityOfHuman INT NOT NULL,
	CheckIn DATE NOT NULL,
	CheckOut DATE,
	TotalAmount FLOAT

	PRIMARY KEY(AccountID, RoomID),
	FOREIGN KEY (AccountID) REFERENCES [Customers](AccountID),
	FOREIGN KEY (RoomID) REFERENCES [Rooms](RoomID)
)
/*Include is the relationship between Room and Service*/
CREATE TABLE [Include]
(
	ServiceID CHAR(20),
	RoomID    CHAR(20)

	PRIMARY KEY (ServiceID, RoomID),
	FOREIGN KEY (ServiceID) REFERENCES [Services](ServiceID),
	FOREIGN KEY (RoomID) REFERENCES [Rooms](RoomID)
)