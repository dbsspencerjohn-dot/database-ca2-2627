CREATE PROCEDURE sp_SearchBooksByKeyword
(
    @Keyword VARCHAR(50),
    @LanguageID TINYINT
)
AS
BEGIN

    SELECT
        B.BookBarcode,
        B.Title,
        L.BookLanguage,
        G.Genre,
        P.PublisherName
    FROM Books B
    INNER JOIN Languages L
        ON B.BookLanguage = L.ID
    INNER JOIN BookGenres G
        ON B.Genre = G.ID
    INNER JOIN Publishers P
        ON B.Publisher = P.ID
    WHERE
        B.BookDescription.exist('/Description[contains(., sql:variable("@Keyword"))]') = 1
        AND B.BookLanguage = @LanguageID
    ORDER BY
        B.Title ASC;

END;
GO