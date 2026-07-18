CREATE VIEW vw_PublisherBookSummary
AS
SELECT
    P.PublisherName,
    COUNT(B.BookBarcode) AS TotalBooks
FROM Publishers P
INNER JOIN Books B
    ON P.ID = B.Publisher
GROUP BY
    P.PublisherName;
GO