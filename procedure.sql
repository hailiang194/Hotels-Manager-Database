USE [Hotels Booking Manager]
GO
CREATE PROC GENERATE_ID 
(
	@prefix CHAR(3),
	@IDNumber INT,
	@ID CHAR(20) OUTPUT
)
/**
 * Generate ID
 * @prefix: prefix of id because each table has their own prefix
 * @IDNumber: ID number of this ID
 * ID: Output the id with format: ABC-YYYY-MM-XXXXXXXX where
								ABC: prefix of id
								YYYY: the year that ID create
								MM: month that ID create
								XXXXXXXX: ID number of this id
 */
AS
BEGIN
	SELECT @ID = @prefix + '-' + CAST(YEAR(GETDATE()) AS VARCHAR(4)) + '-' + RIGHT('00' + CAST(MONTH(GETDATE()) AS VARCHAR(2)), 2) + '-' + RIGHT('0000000' + CONVERT(VARCHAR(10), @IDNumber + 1), 8)
END
GO
CREATE PROC CUSTOMER_INSERT
(
	@phoneNumber   CHAR(20),
	@email         VARCHAR(254),
	@bankAccount   VARCHAR(20),
	@firstName     NVARCHAR(50),
	@lastName      NVARCHAR(50),
	@dateOfBirth   DATE,
	@gender        BIT
)
/**
 * Insert customer
 * It also generates ID of customer and insert customer's information into Account table
 * @phoneNumber: phone number of inserted customer
 * @email: email of inserted customer
 * @bankAccount: bank account of inserted customer
 * @firstName: first name of inserted customer
 * @lastName: last name of inserted customer
 * @dateOfBirth: date of birth of inserted customer
 * @gender: gender of inserted customer (1 for male, 0 for female)
 */
AS
BEGIN
	DECLARE @id CHAR(20),
			@numAccount INT = (SELECT COUNT(*) FROM [Accounts])
	EXEC GENERATE_ID 'ACC', @numAccount , @id OUTPUT
	
	INSERT INTO [Accounts](AccountID, PhoneNumber, Email, BankAccount)
	VALUES
	(@id, @phoneNumber, @email, @bankAccount)
	
	INSERT INTO [Customers](AccountID, FirstName, LastName, DateOfBirth, Gender)
	VALUES 
	(@id, @firstName, @lastName, @dateOfBirth, @gender)
END
GO 
CREATE PROC HOTEL_HOST_INSERT
(
	@phoneNumber CHAR(20),
	@email VARCHAR(254),
	@bankAccount VARCHAR(20),
	@name NVARCHAR(50)
)
/**
 * Insert hotel host
 * It also generates ID of hotel host and insert hotel host's information into Account table
 * @phoneNumber: phone number of inserted hotel host
 * @email: email of inserted hotel host
 * @bankAccount: bank account of inserted hotel host
 * @name: name of inserted hotel host
 */
AS
BEGIN
	DECLARE @id CHAR(20),
			@numAccount INT = (SELECT COUNT(*) FROM [Accounts])
	EXEC GENERATE_ID 'ACC', @numAccount, @id OUTPUT

	INSERT INTO [Accounts](AccountID, PhoneNumber, Email, BankAccount)
	VALUES 
	(@id, @phoneNumber, @email, @bankAccount)

	INSERT INTO [HotelHosts](AccountID, [Name])
	VALUES
	(@id, @name)
END
GO 
CREATE PROC HOTEL_INSERT
(
	@name            NVARCHAR(50),
	@phoneNumber     CHAR(20),
	@description     NTEXT,
	@specificAddress NVARCHAR(50),
	@districtName    NVARCHAR(50),
	@provinceName     NVARCHAR(50),
	@countryName     NVARCHAR(50),
	@accountID        CHAR(20)
)
AS
/**
 * insert hotel and generate its ID automatically
 * @name: name of inserted hotel
 * @phoneNumber: phone number of inserted hotel
 * @description: description of inserted hotel
 * @specificAddress: the address of inserted hotel without district, province and country
 * @districtName: district that inserted hotel's at
 * @provinceName: province that inserted hotel's on
 * @countryName: country that inserted hotel's in
 * @accountID: account's ID of hotel host that hosts this hotel
 */
BEGIN
	DECLARE @id CHAR(20),
		@numAccount INT = (SELECT COUNT(*) FROM [Hotels])
	EXEC GENERATE_ID 'HTL', @numAccount, @id OUTPUT

	INSERT INTO [Hotels](HotelID, [Name], PhoneNumber, [Description], SpecificAddress, DistrictName, ProvinceName, CountryName, AccountID)
	VALUES 
	(@id, @name, @phoneNumber, @description, @specificAddress, @districtName, @provinceName, @countryName, @accountID)
END
GO
CREATE PROC ROOM_INSERT
(
	@capacity INT,
	@price    FLOAT,
	@hotelID   CHAR(20)
)
/**
 * insert room and generate its ID automatically
 * @capacity: capacity of inserted room
 * @price: price of inserted room
 * @hotelID: hotel's ID that inserted room is managed
 */
AS
BEGIN
	DECLARE @id CHAR(20),
		@numAccount INT = (SELECT COUNT(*) FROM [Rooms])
	EXEC GENERATE_ID 'RMS', @numAccount, @id OUTPUT

	INSERT INTO [Rooms](RoomID, Capacity, Price, HotelID)
	VALUES
	(@id, @capacity, @price, @hotelID)
END
GO 
CREATE PROC SERVICE_INSERT
(
	@name NVARCHAR(50),
	@description NTEXT
)
/**
 * insert service and generate its ID automatically
 * @name: name of inserted service
 * @description: description of inserted service
 */
AS
BEGIN
	DECLARE @id CHAR(20),
		@numAccount INT = (SELECT COUNT(*) FROM [Services])
	EXEC GENERATE_ID 'SER', @numAccount, @id OUTPUT

	INSERT INTO [Services](ServiceID, [Name], [Description])
	VALUES
	(@id, @name, @description)
END