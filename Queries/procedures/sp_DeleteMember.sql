CREATE PROCEDURE sp_DeleteMember
(
    @MemberID INT
)
AS
BEGIN

    DELETE FROM Members
    WHERE ID = @MemberID
      AND MembershipActive = 0;

END;
GO