﻿CREATE PROCEDURE dbo.netPageLanguageSettingList
@PageID INT
AS
BEGIN
	SET NOCOUNT ON
	
	SELECT	fkPageID,
			RTRIM(Branch.LanguageID) as LanguageBranch,
			RTRIM(ReplacementBranch.LanguageID) as ReplacementBranch,
			LanguageBranchFallback,
			Active
	FROM tblPageLanguageSetting
	INNER JOIN tblLanguageBranch AS Branch ON Branch.pkID = tblPageLanguageSetting.fkLanguageBranchID
	LEFT JOIN tblLanguageBranch AS ReplacementBranch ON ReplacementBranch.pkID = tblPageLanguageSetting.fkReplacementBranchID
	WHERE fkPageID=@PageID
END