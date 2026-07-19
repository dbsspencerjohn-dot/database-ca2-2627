CREATE OR ALTER PROCEDURE sp_BookAuthorXML
(
    @BookBarcode VARCHAR(40)
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        b.BookBarcode,
        b.Title,
        dbo.fn_FullAuthorName(a.ID) AS Author
    FROM Books b
        INNER JOIN Books_Authors ba
            ON b.BookBarcode = ba.Book
        INNER JOIN Authors a
            ON ba.Author = a.ID
    WHERE b.BookBarcode = @BookBarcode
    FOR XML PATH('Book'), ROOT('Library');
END;
GO