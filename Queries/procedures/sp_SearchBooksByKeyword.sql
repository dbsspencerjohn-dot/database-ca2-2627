CREATE OR ALTER PROCEDURE sp_SearchBooksByKeyword
(
    @Keyword VARCHAR(100)
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        b.BookBarcode,
        b.Title,
        p.PublisherName,
        l.BookLanguage,
        g.Genre,
        s.AvailStatus,
        b.PublicationDate,

        b.BookDescription.value(
            '(/bookdesc/blurb)[1]',
            'VARCHAR(MAX)'
        ) AS BookBlurb

    FROM Books b
    INNER JOIN Publishers p
        ON b.Publisher = p.ID
    INNER JOIN Languages l
        ON b.BookLanguage = l.ID
    INNER JOIN BookGenres g
        ON b.Genre = g.ID
    INNER JOIN AvailabilityStatuses s
        ON b.AvailabilityStatus = s.ID

    WHERE
        b.Title LIKE '%' + @Keyword + '%'
        OR
        b.BookDescription.value(
            '(/bookdesc/blurb)[1]',
            'VARCHAR(MAX)'
        ) LIKE '%' + @Keyword + '%';
END;
GO