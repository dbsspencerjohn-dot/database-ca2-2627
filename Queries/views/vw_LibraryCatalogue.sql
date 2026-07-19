CREATE OR ALTER VIEW vw_LibraryCatalogue
AS
SELECT
    b.BookBarcode,
    b.Title,
    p.PublisherName,
    l.BookLanguage,
    g.Genre,
    s.AvailStatus,
    b.PublicationDate,

    b.BookDescription.value(
        '(/bookdesc/blurb/text())[1]',
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
    ON b.AvailabilityStatus = s.ID;
GO