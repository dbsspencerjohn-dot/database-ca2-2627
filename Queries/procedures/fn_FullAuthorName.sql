CREATE FUNCTION dbo.fn_FullAuthorName
(
    @AuthorID INT
)
RETURNS VARCHAR(60)
AS
BEGIN
    DECLARE @FullName VARCHAR(60);

    SELECT @FullName = FirstName + ' ' + LastName
    FROM Authors
    WHERE ID = @AuthorID;

    RETURN @FullName;
END;
GO