CREATE PROCEDURE sp_UpdateBookDescription
(
    @Barcode VARCHAR(40),
    @NewDescription VARCHAR(300)
)
AS
BEGIN

    UPDATE Books
    SET BookDescription.modify(
        'replace value of (/Description/text())[1]
         with sql:variable("@NewDescription")'
    )
    WHERE BookBarcode = @Barcode;

END;
GO