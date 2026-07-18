CREATE PROCEDURE sp_BookAuthorXML
(
    @GenreID TINYINT
)
AS
BEGIN

    SELECT
        B.Title,
        dbo.fn_FullAuthorName(A.ID) AS Author,
        P.PublisherName,
        L.BookLanguage
    FROM Books B
    INNER JOIN Books_Authors BA
        ON B.BookBarcode = BA.Book
    INNER JOIN Authors A
        ON BA.Author = A.ID
    INNER JOIN Publishers P
        ON B.Publisher = P.ID
    INNER JOIN Languages L
        ON B.BookLanguage = L.ID
    WHERE
        B.Genre = @GenreID
    ORDER BY
        B.Title ASC
    FOR XML PATH('Book'), ROOT('LibraryBooks');

END;
GO