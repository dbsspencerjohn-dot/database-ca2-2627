CREATE OR ALTER PROCEDURE sp_PublisherBookCount
(
    @MinimumBooks INT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        P.PublisherName,
        COUNT(B.BookBarcode) AS TotalBooks
    FROM Publishers P
    INNER JOIN Books B
        ON P.ID = B.Publisher
    GROUP BY
        P.PublisherName
    HAVING
        COUNT(B.BookBarcode) >= @MinimumBooks
    ORDER BY
        TotalBooks DESC;
END;
GO