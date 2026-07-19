-- rent a book - create a rent record from:
-- @RentedBook as the barcode of a book
-- @RentedBy as the ID of a member
-- @AuthorizedBy as the ID of a staff member
-- @RentalDays as a number of days the book will be rented for
-- @RentStatusText the rental status, 'On Hold' or 'On Time'

CREATE OR ALTER PROCEDURE sp_RentBook
    @RentedBook VARCHAR(40),
    @RentedBy INT,
    @AuthorizedBy VARCHAR(9),
    @RentalDays INT,
    @RentStatusText VARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CurDate DATE
    SET @CurDate = CONVERT(DATE, GETDATE())

    INSERT INTO RentRecords(RentedBook, RentedBy, AuthorizedBy, 
                            DateOfRental, DueDate, RentStatus)

    VALUES(
        @RentedBook, @RentedBy, @AuthorizedBy, @CurDate,
        (DATEADD(day, @RentalDays, @CurDate)),
        (SELECT ID FROM RentalStatuses WHERE RentStatus = @RentStatusText)
    )
END;
