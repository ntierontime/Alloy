﻿CREATE PROCEDURE dbo.netRemoteSiteDelete
(
	@ID INT OUTPUT
)
AS
BEGIN
	DELETE FROM tblRemoteSite WHERE pkID=@ID
END