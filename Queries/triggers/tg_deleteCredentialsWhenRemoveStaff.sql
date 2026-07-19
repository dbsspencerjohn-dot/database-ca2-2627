-- whenever a staff member is removed from the system, their
-- credentials should also be removed

CREATE TRIGGER tg_deleteCredentialsWhenRemoveStaff
ON Staff
AFTER DELETE
AS 
BEGIN
	DECLARE @old_username VARCHAR(15)
	SELECT @old_username = Credentials FROM deleted
	DELETE FROM Credentials WHERE Username = @old_username
END;
