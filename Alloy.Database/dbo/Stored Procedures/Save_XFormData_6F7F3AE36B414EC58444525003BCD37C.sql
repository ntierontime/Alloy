﻿create procedure [dbo].[Save_XFormData_6F7F3AE36B414EC58444525003BCD37C]
@Id bigint output,
@UniqueId uniqueidentifier,
@ItemType nvarchar(2048),
@Email nvarchar(max) = NULL,
@Message nvarchar(max) = NULL,
@Meta_ChannelOptions int = NULL,
@Meta_DatePosted datetime = NULL,
@Meta_FormId uniqueidentifier = NULL,
@Meta_PageGuid uniqueidentifier = NULL,
@Meta_UserName nvarchar(450) = NULL,
@Name nvarchar(max) = NULL
as
begin
declare @pkId bigint
	select @pkId = pkId from tblBigTableIdentity where [Guid] = @UniqueId
	if @pkId IS NULL
	begin
		begin transaction
		insert into [tblBigTableIdentity]([Guid], [StoreName]) values(@UniqueId, 'XFormData_6F7F3AE36B414EC58444525003BCD37C')

		select @Id = SCOPE_IDENTITY()
				insert into [tblXFormData] (pkId, StoreName, Row, ItemType,String01,String02,ChannelOptions,DatePosted,FormId,PageGuid,UserName,String03)
		values(@Id, 'XFormData_6F7F3AE36B414EC58444525003BCD37C', 1, @ItemType ,@Email,@Message,@Meta_ChannelOptions,@Meta_DatePosted,@Meta_FormId,@Meta_PageGuid,@Meta_UserName,@Name)

		commit transaction
	end
	else
	begin
		begin transaction
		select @Id = @pkId
		DECLARE @rows int
		select @rows = count(*) from [tblXFormData] where pkId = @Id
		if(@rows < 1) begin
				insert into [tblXFormData] (pkId, StoreName, Row, ItemType,String01,String02,ChannelOptions,DatePosted,FormId,PageGuid,UserName,String03)
		values(@Id, 'XFormData_6F7F3AE36B414EC58444525003BCD37C', 1, @ItemType ,@Email,@Message,@Meta_ChannelOptions,@Meta_DatePosted,@Meta_FormId,@Meta_PageGuid,@Meta_UserName,@Name)

		end
		else begin
				update [tblXFormData] set 
		ItemType = @ItemType,
		String01 = @Email,
		String02 = @Message,
		ChannelOptions = @Meta_ChannelOptions,
		DatePosted = @Meta_DatePosted,
		FormId = @Meta_FormId,
		PageGuid = @Meta_PageGuid,
		UserName = @Meta_UserName,
		String03 = @Name
                from [tblXFormData]
                where pkId=@pkId
                and Row=1
		end
		commit transaction
	end
end