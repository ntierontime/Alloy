﻿CREATE PROCEDURE [dbo].[netConvertPropertyForPageType]
(
	@PageID		INT,
	@FromPageType	INT,
	@FromPropertyID 	INT,
	@ToPropertyID		INT,
	@Recursive		BIT,
	@MasterLanguageID INT,
	@IsTest			BIT
)
AS
BEGIN
	DECLARE @cnt INT;
	DECLARE @LanguageSpecific INT
	DECLARE @LanguageSpecificSource INT
	DECLARE @IsBlock BIT
	SET @LanguageSpecific = 0
	SET @LanguageSpecificSource = 0
	SET @IsBlock = 0
	CREATE TABLE  #updatepages(fkChildID int)
 
	INSERT INTO #updatepages(fkChildID)  
	SELECT fkChildID 
	FROM tblTree tree
	JOIN tblPage page
	ON page.pkID = tree.fkChildID 
	WHERE @Recursive = 1
	AND tree.fkParentID = @PageID
	AND page.fkPageTypeID = @FromPageType
	UNION (SELECT pkID FROM tblPage WHERE pkID = @PageID AND fkPageTypeID = @FromPageType)
	IF @IsTest = 1
	BEGIN	
		SET @cnt = (	SELECT COUNT(*)
				FROM tblProperty 
				WHERE (fkPageDefinitionID = @FromPropertyID
				or ScopeName LIKE '%.' + CAST(@FromPropertyID as varchar) + '.%')
				AND  EXISTS (
					SELECT * from #updatepages WHERE fkChildID=fkPageID))
			+ (	SELECT COUNT(*)
				FROM tblWorkProperty 
				WHERE (fkPageDefinitionID = @FromPropertyID
				or ScopeName LIKE '%.' + CAST(@FromPropertyID as varchar) + '.%')
				AND EXISTS (
				SELECT * 
					FROM tblWorkPage 
					WHERE pkID = fkWorkPageID
					AND  EXISTS (
						SELECT * from #updatepages WHERE fkChildID=fkPageID)
				))
		IF @ToPropertyID IS NULL OR @ToPropertyID = 0-- mark deleted rows with -
			SET @cnt = -@cnt
	END
	ELSE
	BEGIN
		IF @ToPropertyID IS NULL OR @ToPropertyID = 0-- no definition exists for the new page type for this property so remove it
		BEGIN
			DELETE
			FROM tblProperty 
			WHERE (fkPageDefinitionID = @FromPropertyID
			or ScopeName LIKE '%.' + CAST(@FromPropertyID as varchar) + '.%')
			AND  EXISTS (
				SELECT * from #updatepages WHERE fkChildID=fkPageID)
			SET @cnt = -@@rowcount
			DELETE 
			FROM tblWorkProperty 
			WHERE (fkPageDefinitionID = @FromPropertyID
			or ScopeName LIKE '%.' + CAST(@FromPropertyID as varchar) + '.%')
			AND EXISTS (
				SELECT * 
				FROM tblWorkPage 
				WHERE pkID = fkWorkPageID
				AND  EXISTS (
					SELECT * from #updatepages WHERE fkChildID=fkPageID)
				)
			SET @cnt = @cnt-@@rowcount 
		END 	
		ELSE IF @FromPropertyID IS NOT NULL -- from property exists and has to be replaced
		BEGIN
			-- Need to check if the property we're converting to is unique for each language or not
			SELECT @LanguageSpecific = LanguageSpecific 
			FROM tblPageDefinition 
			WHERE pkID = @ToPropertyID
			-- Need to check if the property we're converting from is unique for each language or not
			SELECT @LanguageSpecificSource = LanguageSpecific 
			FROM tblPageDefinition 
			WHERE pkID = @FromPropertyID
			
			-- Need to check if the property we're converting is a block (Property 12 is a block)
			SELECT @IsBlock = CAST(count(*) as bit)
			FROM tblPageDefinition 
			Where pkID = @FromPropertyID and Property = 12
			IF @IsBlock = 1
			BEGIN
				DECLARE @DefinitionTypeFrom int
				DECLARE @DefinitionTypeTo int
				SET @DefinitionTypeFrom = 
					(SELECT fkPageDefinitionTypeID FROM tblPageDefinition WHERE pkID =@FromPropertyID)
				SET @DefinitionTypeTo = 
					(SELECT fkPageDefinitionTypeID FROM tblPageDefinition WHERE pkID =@ToPropertyID)
				IF (@DefinitionTypeFrom <> @DefinitionTypeTo)
				BEGIN
					RAISERROR (N'Property definitions are not of same block type.', 16, 1)
					RETURN 0
				END
				
				-- Update older versions of block
				-- update scopename in tblWorkProperty
				
				 UPDATE tblWorkProperty 
				 SET ScopeName = dbo.ConvertScopeName(ScopeName,@FromPropertyID, @ToPropertyID)
				 FROM tblWorkProperty prop
				 INNER JOIN tblWorkPage wpa ON prop.fkWorkPageID = wpa.pkID
				 WHERE ScopeName LIKE '%.' + CAST(@FromPropertyID as varchar) + '.%'
				 AND EXISTS (SELECT * from #updatepages WHERE fkChildID=wpa.fkPageID)
			
				SET @cnt = @@rowcount
				-- Update current version of block
				-- update scopename in tblProperty
				
				 UPDATE tblProperty 
				 SET ScopeName = dbo.ConvertScopeName(ScopeName,@FromPropertyID, @ToPropertyID)
				 WHERE ScopeName LIKE '%.' + CAST(@FromPropertyID as varchar) + '.%'
				 AND  EXISTS (
					SELECT * from #updatepages WHERE fkChildID=fkPageID)
				SET @cnt = @cnt + @@rowcount
			END
			ELSE -- Not a block.
			BEGIN
				-- Update older versions
				UPDATE tblWorkProperty SET fkPageDefinitionID = @ToPropertyID
					FROM tblWorkProperty prop
					INNER JOIN tblWorkPage wpa ON prop.fkWorkPageID = wpa.pkID
					WHERE prop.fkPageDefinitionID = @FromPropertyID
					AND EXISTS (SELECT * from #updatepages WHERE fkChildID=wpa.fkPageID)
			
				SET @cnt = @@rowcount
				-- Update current version 
				UPDATE tblProperty SET fkPageDefinitionID = @ToPropertyID
				WHERE fkPageDefinitionID = @FromPropertyID
				AND  EXISTS (
					SELECT * from #updatepages WHERE fkChildID=fkPageID)
				SET @cnt = @cnt + @@rowcount
			END
			IF (@LanguageSpecific < 3 AND @LanguageSpecificSource > 2)
			BEGIN
				-- The destination property is not language specific which means
				-- that we need to remove all of the old properties in other
				-- languages that could not be mapped
				DELETE FROM tblWorkProperty
					FROM tblWorkProperty prop
					INNER JOIN tblWorkPage wpa ON prop.fkWorkPageID = wpa.pkID
					WHERE (prop.fkPageDefinitionID = @ToPropertyID -- already converted to new type!
					or prop.ScopeName LIKE '%.' + CAST(@ToPropertyID as varchar) + '.%')
					AND wpa.fkLanguageBranchID <> @MasterLanguageID
					AND EXISTS (SELECT * from #updatepages WHERE fkChildID=wpa.fkPageID)
				
				SET @cnt = @cnt - @@rowcount		
				
				DELETE FROM tblProperty 
				WHERE (fkPageDefinitionID = @ToPropertyID -- already converted to new type!
				or ScopeName LIKE '%.' + CAST(@ToPropertyID as varchar) + '.%')
				AND fkLanguageBranchID <> @MasterLanguageID
				AND  EXISTS (
					SELECT * from #updatepages WHERE fkChildID=fkPageID)
				SET @cnt = @cnt - @@rowcount				
			END
			ELSE IF (@LanguageSpecificSource < 3)
			BEGIN
				-- Converting from language neutral to language supporting property
				-- We must copy existing master language property to other languages for the page
				
				-- NOTE: Due to the way language neutral properties are loaded, that is they are always
				-- loaded from published version, see netPageDataLoadVersion it is sufficient to add property
				-- values to tblProperty (no need to update tblWorkProperty
				
				INSERT INTO tblProperty
					(fkPageDefinitionID,
					fkPageID,
					fkLanguageBranchID,
					ScopeName,
					Boolean,
					Number,
					FloatNumber,
					PageType,
					PageLink,
					LinkGuid,
					Date,
					String,
					LongString,
					LongStringLength)
				SELECT 
					CASE @IsBlock when 1 then Prop.fkPageDefinitionID else @ToPropertyID end, 
					Prop.fkPageID,
					Lang.fkLanguageBranchID,
					Prop.ScopeName,
					Prop.Boolean,
					Prop.Number,
					Prop.FloatNumber,
					Prop.PageType,
					Prop.PageLink,
					Prop.LinkGuid,
					Prop.Date,
					Prop.String,
					Prop.LongString,
					Prop.LongStringLength
				FROM
				tblPageLanguage Lang
				INNER JOIN
				tblProperty Prop ON Prop.fkLanguageBranchID = @MasterLanguageID
				WHERE
				Prop.fkPageID = @PageID AND
				(Prop.fkPageDefinitionID = @ToPropertyID -- already converted to new type!
				or Prop.ScopeName LIKE '%.' + CAST(@ToPropertyID as varchar) + '.%') AND
				Prop.fkLanguageBranchID = @MasterLanguageID AND
				Lang.fkLanguageBranchID <> @MasterLanguageID AND
				Lang.fkPageID = @PageID
				-- Need to add entries to tblWorkProperty for all pages not in the master language
				-- First we need to read the master language property into a temp table
				CREATE TABLE #TempWorkProperty
				(
					fkPageDefinitionID int,
					ScopeName nvarchar(450),
					Boolean bit,
					Number int,
					FloatNumber float,
					PageType int,
					PageLink int,
				    LinkGuid uniqueidentifier,
					Date datetime,
					String nvarchar(450),
					LongString nvarchar(max)
				)
				INSERT INTO #TempWorkProperty
				SELECT
					Prop.fkPageDefinitionID,
					Prop.ScopeName,
					Prop.Boolean,
					Prop.Number,
					Prop.FloatNumber,
					Prop.PageType,
					Prop.PageLink,
				    Prop.LinkGuid,
					Prop.Date,
					Prop.String,
					Prop.LongString
				FROM
					tblWorkProperty AS Prop
					INNER JOIN
					tblWorkPage AS Page ON Prop.fkWorkPageID = Page.pkID
				WHERE
					(Prop.fkPageDefinitionID = @ToPropertyID -- already converted to new type!
				or Prop.ScopeName LIKE '%.' + CAST(@ToPropertyID as varchar) + '.%') AND
					Page.fkLanguageBranchID = @MasterLanguageID AND
					Page.fkPageID = @PageID
					ORDER BY Page.pkID DESC
				-- Now add a new property for every language (except master) using the master value
				INSERT INTO	tblWorkProperty 
				SELECT
					CASE @IsBlock when 1 then TempProp.fkPageDefinitionID else @ToPropertyID end,
					Page.pkID,
					TempProp.ScopeName,
					TempProp.Boolean,
					TempProp.Number,
					TempProp.FloatNumber,
					TempProp.PageType,
					TempProp.PageLink,
					TempProp.Date,
					TempProp.String,
					TempProp.LongString,
					TempProp.LinkGuid
				FROM 
					tblWorkPage AS Page, #TempWorkProperty AS TempProp
				WHERE
					Page.fkPageID = @PageID AND
					Page.fkLanguageBranchID <> @MasterLanguageID
				DROP TABLE #TempWorkProperty
			END
		END
	END
	DROP TABLE #updatepages
	RETURN (@cnt)
END
