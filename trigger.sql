USE [Hotels Booking Manager]
GO
CREATE TRIGGER HOTEL_HOST_INSERT_TRIGGER
ON [HotelHosts]
AFTER INSERT
/**
 * This trigger show all data of hotel hosts that you have inserted
 * It shows all data in Hotel host table and Account table 
 */
AS
BEGIN
	SELECT
		[Accounts].AccountID,
		inserted.[Name],
		[Accounts].PhoneNumber,
		[Accounts].Email,
		[Accounts].BankAccount
	FROM inserted
	JOIN [Accounts] ON inserted.AccountID = [Accounts].AccountID
END
GO
CREATE TRIGGER CUSTOMER_INSERT_TRIGGER
ON [Customers]
AFTER INSERT 
/**
 * This trigger show all data of customer that have been inserted
 * It shows all data in Customer table and Account table
 */
AS
BEGIN
	SELECT
		[Accounts].AccountID,
		inserted.FirstName,
		inserted.LastName,
		inserted.DateOfBirth,
		inserted.Gender,
		[Accounts].PhoneNumber,
		[Accounts].Email,
		[Accounts].BankAccount
	FROM inserted
	JOIN [Accounts] ON inserted.AccountID = [Accounts].AccountID
END