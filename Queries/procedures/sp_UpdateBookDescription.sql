CREATE OR ALTER PROCEDURE sp_UpdateBookDescription
(
    @BookBarcode VARCHAR(50),
    @NewBlurb VARCHAR(MAX)
)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS
    (
        SELECT *
        FROM Books
        WHERE BookBarcode = @BookBarcode
    )
    BEGIN
        PRINT 'Book not found.';
        RETURN;
    END;

    UPDATE Books
    SET BookDescription =
    CAST(
    '<bookdesc>
        <blurb>' + @NewBlurb + '</blurb>
        <awards></awards>
    </bookdesc>' AS XML)

    WHERE BookBarcode = @BookBarcode;

    PRINT 'Book description updated successfully.';
END;
GO