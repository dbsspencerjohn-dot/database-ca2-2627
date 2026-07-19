-- update the status of a rental record
-- @RentalID as the ID of the rental record
-- @NewRentStatusText as the new status of the rental record
-- as 'On Time', 'Overdue', 'Returned' or 'Book Lost'  

CREATE OR ALTER PROCEDURE sp_UpdateRentalStatus
    @RentalID INT
    @NewRentStatusText VARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE RentRecords
    SET RentStatus = (SELECT ID FROM RentalStatuses WHERE RentStatus = @NewRentStatusText)
    WHERE ID = @RentalID
END;