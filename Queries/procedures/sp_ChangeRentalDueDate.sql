-- adds more days on on a book's rental
-- @RentalID as the ID of the rental record
-- @RentalDays as a number of days to add to the rental record

CREATE OR ALTER PROCEDURE sp_ChangeRentalDueDate
    @RentalID INT,
    @RentalDays INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CurRentStatus INT
    DECLARE @CurDueDate DATE
    DECLARE @NewDueDate DATE

    SELECT @CurRentStatus = RentStatus, @CurDueDate = DueDate 
    FROM RentRecords 
    WHERE ID = @RentalID

    SET @NewDueDate = DATEADD(day, @RentalDays, @CurDueDate)

    UPDATE RentRecords 
    SET DueDate = @NewDueDate
    WHERE ID = @RentalID

    -- Update from overdue to on time if date is extended
    IF ( @CurRentStatus = (SELECT ID FROM RentalStatuses WHERE RentStatus = 'Overdue')
        AND @NewDueDate > CONVERT(DATE, GETDATE()))
        BEGIN
            UPDATE RentRecords
            SET RentStatus = (SELECT ID FROM RentalStatuses WHERE RentStatus = 'On Time')
            WHERE ID = @RentalID
        END;
END;