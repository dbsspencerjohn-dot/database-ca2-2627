CREATE VIEW vw_BookCatalogue
AS
SELECT
    B.BookBarcode,
    B.Title,
    A.FirstName + ' ' + A.LastName AS Author,
    P.PublisherName,
    L.BookLanguage,
    G.Genre,
    B.BookDescription.value('(/Description/text())[1]', 'VARCHAR(300)') AS Description
FROM Books B
INNER JOIN Books_Authors BA
    ON B.BookBarcode = BA.Book
INNER JOIN Authors A
    ON BA.Author = A.ID
INNER JOIN Publishers P
    ON B.Publisher = P.ID
INNER JOIN Languages L
    ON B.BookLanguage = L.ID
INNER JOIN BookGenres G
    ON B.Genre = G.ID;
GO