if (exists (select * from Setting where Name like 'articlessettings%'))
begin
	delete from Setting where Name like 'cmsmanagersettings%'
	update Setting 
	set Name = REPLACE(Name, 'articlessettings', 'cmsmanagersettings') 
	where Name like 'articlessettings%'

	update Setting 
	set Name = 'cmsmanagersettings.thumbpicturesize' 
	where Name ='cmsmanagersettings.articlethumbpicturesize'

	update Setting 
	set Name = 'cmsmanagersettings.ProductDetailsPageSize' 
	where Name ='cmsmanagersettings.articlepageproductsperpage'

	update Setting 
	set Name = 'cmsmanagersettings.productpagepagesperpage' 
	where Name ='cmsmanagersettings.productpagearticlesperpage'
	
	update Setting 
	set Name = 'cmsmanagersettings.EnableTopMenuItem' 
	where Name ='cmsmanagersettings.ArticleMenuEnabled'

	update Setting 
	set Name = 'cmsmanagersettings.EnablePagesOnHomePage' 
	where Name ='cmsmanagersettings.ShowArticleOnHomePage'

	update Setting 
	set Name = 'cmsmanagersettings.HomePageCMSPagesPerPage' 
	where Name ='cmsmanagersettings.HomePageArticlesPerPage'

	update Setting 
	set Name = 'cmsmanagersettings.HomePageCMSPagesPerPage' 
	where Name ='cmsmanagersettings.EnablePagerOfArticlesOnHomePage'

	update Setting 
	set Name = 'cmsmanagersettings.PageSearchTermMinimumLength' 
	where Name ='cmsmanagersettings.ArticleSearchTermMinimumLength'

	update Setting 
	set Name = 'cmsmanagersettings.SearchInBodyByDefault' 
	where Name ='cmsmanagersettings.SearchPageArticlesPerPage'
	
end 
go
if (exists (select * from PermissionRecord where SystemName = 'FoxNetSoft.Articles'))
begin
	delete from PermissionRecord where SystemName = 'FoxNetSoft.CMSManager'
	update PermissionRecord 
	set SystemName = 'FoxNetSoft.CMSManager'
	where SystemName = 'FoxNetSoft.Articles'
end 
go
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[FNS_ArticleTemplate]') AND type in (N'U'))
BEGIN
	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[FNS_CMSPageTemplate]') AND type in (N'U'))
	BEGIN
		drop table FNS_CMSPageTemplate
	END
	exec sp_rename 'FNS_ArticleTemplate', 'FNS_CMSPageTemplate'
END
GO
update FNS_CMSPageTemplate
set ViewPath = 'PageTemplate.Default'
where ViewPath ='ArticleTemplate.Default'
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[FNS_ArticleComment]') AND type in (N'U'))
BEGIN
	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[FNS_CMSPageComment]') AND type in (N'U'))
	BEGIN
		drop table FNS_CMSPageComment
	END
	exec sp_rename 'FNS_ArticleComment', 'FNS_CMSPageComment'
END
GO
IF EXISTS( SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
            WHERE TABLE_NAME = 'FNS_CMSPageComment' 
           AND  COLUMN_NAME = 'ArticleId')
BEGIN
	EXEC sp_rename 'FNS_CMSPageComment.ArticleId', 'PageId', 'COLUMN';
END
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[FNS_Article]') AND type in (N'U'))
BEGIN
	exec sp_rename 'FNS_Article', 'FNS_CMSPage'
END
GO
IF EXISTS( SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
            WHERE TABLE_NAME = 'FNS_CMSPage' 
           AND  COLUMN_NAME = 'ArticleTemplateId')
BEGIN
	EXEC sp_rename 'FNS_CMSPage.ArticleTemplateId', 'PageTemplateId', 'COLUMN';
END
GO
--add a new column
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=object_id('[FNS_CMSPage]') and NAME='[AdminComment]')
BEGIN
	ALTER TABLE [FNS_CMSPage] ADD [AdminComment] nvarchar(400) NULL
END
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[FNS_ArticleProduct]') AND type in (N'U'))
BEGIN
	exec sp_rename 'FNS_ArticleProduct', 'FNS_CMSPageProduct'
END
GO
IF EXISTS( SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
            WHERE TABLE_NAME = 'FNS_CMSPageProduct' 
           AND  COLUMN_NAME = 'ArticleId')
BEGIN
	EXEC sp_rename 'FNS_CMSPageProduct.ArticleId', 'PageId', 'COLUMN';
END
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[FNS_ArticleCategory]') AND type in (N'U'))
BEGIN
	exec sp_rename 'FNS_ArticleCategory', 'FNS_CMSPageCategory'
END
GO
IF EXISTS( SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
            WHERE TABLE_NAME = 'FNS_CMSPageCategory' 
           AND  COLUMN_NAME = 'ArticleId')
BEGIN
	EXEC sp_rename 'FNS_CMSPageCategory.ArticleId', 'PageId', 'COLUMN';
END
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[FNS_ArticleManufacturer]') AND type in (N'U'))
BEGIN
	exec sp_rename 'FNS_ArticleManufacturer', 'FNS_CMSPageManufacturer'
END
GO
IF EXISTS( SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
            WHERE TABLE_NAME = 'FNS_CMSPageManufacturer' 
           AND  COLUMN_NAME = 'ArticleId')
BEGIN
	EXEC sp_rename 'FNS_CMSPageManufacturer.ArticleId', 'PageId', 'COLUMN';
END
GO
update UrlRecord
set EntityName='CMSPage'
where EntityName='Article'

update AclRecord 
set EntityName = 'CMSPage'
where EntityName='Article'

update StoreMapping 
set EntityName = 'CMSPage'
where EntityName='Article'

update LocalizedProperty 
set LocaleKeyGroup='CMSPage'
where LocaleKeyGroup='Article'

update LocalizedProperty 
set LocaleKey='Name'
where LocaleKeyGroup='CMSPage' and LocaleKey='Title'

update LocalizedProperty 
set LocaleKey='FullDescription'
where LocaleKeyGroup='CMSPage' and LocaleKey='Body'

GO
--add a new column
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=object_id('[FNS_CMSPage]') and NAME='[PageTypeId]')
BEGIN
	ALTER TABLE [FNS_CMSPage] ADD [PageTypeId] int NOT NULL
	 CONSTRAINT DF_FNS_CMSPage_PageTypeId DEFAULT 5
END
GO
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=object_id('[FNS_CMSPage]') and NAME='[AddToTopMenu]')
BEGIN
	ALTER TABLE [FNS_CMSPage] ADD [AddToTopMenu] bit NOT NULL
	 CONSTRAINT DF_FNS_CMSPage_AddToTopMenu DEFAULT 0
END
GO
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=object_id('[FNS_CMSPage]') and NAME='[DisplayOrder]')
BEGIN
	ALTER TABLE [FNS_CMSPage] ADD [DisplayOrder] int NOT NULL
	 CONSTRAINT DF_FNS_CMSPage_DisplayOrder DEFAULT 0
END
GO
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=object_id('[FNS_CMSPage]') and NAME='[ParentPageId]')
BEGIN
	ALTER TABLE [FNS_CMSPage] ADD [ParentPageId] int NOT NULL
	 CONSTRAINT DF_FNS_CMSPage_ParentPageId DEFAULT 0
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=object_id('[FNS_CMSPage]') and NAME='[HasPersonalTree]')
BEGIN
	ALTER TABLE [FNS_CMSPage] ADD [HasPersonalTree] bit NOT NULL
	 CONSTRAINT DF_FNS_CMSPage_HasPersonalTree DEFAULT 0
END
GO

IF EXISTS( SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
            WHERE TABLE_NAME = 'FNS_CMSPage' 
           AND  COLUMN_NAME = 'Title')
BEGIN
	EXEC sp_rename 'FNS_CMSPage.Title', 'Name', 'COLUMN';
END
GO
IF EXISTS( SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
            WHERE TABLE_NAME = 'FNS_CMSPage' 
           AND  COLUMN_NAME = 'Body')
BEGIN
	EXEC sp_rename 'FNS_CMSPage.Body', 'FullDescription', 'COLUMN';
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=object_id('[FNS_CMSPage]') and NAME='[ShortDescription]')
BEGIN
	ALTER TABLE [FNS_CMSPage] ADD [ShortDescription] nvarchar(400) NULL
END
GO
delete from Topic where SystemName='CMSManagerHomePage'

update Topic
set SystemName='CMSManagerHomePage'
where SystemName='ArticleHomePage'
GO
delete from MessageTemplate where Name='CMSManager.PageComment'

update MessageTemplate
set Name='CMSManager.PageComment'
where Name='Article.ArticleComment'
GO

CREATE TABLE [dbo].[FNS_CMSPageGroup_Mapping](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PageId] [int] NOT NULL,
	[GroupId] [int] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
 CONSTRAINT [PK_FNS_CMSPageGroup_Mapping] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[FNS_CMSPageGroup_Mapping]  WITH CHECK ADD  CONSTRAINT [FK_FNS_CMSPageGroup_Mapping_PageId_FNS_CMSPage_Id] FOREIGN KEY([PageId])
REFERENCES [dbo].[FNS_CMSPage] ([Id])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[FNS_CMSPageGroup_Mapping] CHECK CONSTRAINT [FK_FNS_CMSPageGroup_Mapping_PageId_FNS_CMSPage_Id]
GO
	ALTER TABLE [FNS_CMSPage] ADD [OldId] int NOT NULL
	 CONSTRAINT DF_FNS_CMSPage_OldId DEFAULT 0
GO



   DECLARE @oldgroupId int
   DECLARE @newgroupId int
  
   DECLARE myArticleGroup CURSOR FOR 
     SELECT Id
     FROM FNS_ArticleGroup
   
   OPEN myArticleGroup
   FETCH NEXT FROM myArticleGroup INTO @oldgroupId
   WHILE @@FETCH_STATUS = 0
   BEGIN
       INSERT INTO [FNS_CMSPage]
           ([MetaKeywords]
           ,[MetaTitle]
           ,[Author]
           ,[AdminComment]
           ,[PageTypeId]
           ,[PageTemplateId]
           ,[ParentPageId]
           ,[Name]
           ,[ShortDescription]
           ,[FullDescription]
           ,[PictureId]
           ,[MetaDescription]
           ,[Published]
           ,[AddToTopMenu]
           ,[LimitedToStores]
           ,[SubjectToAcl]
           ,[DateUtc]
           ,[AllowComments]
           ,[CommentCount]
           ,[Tags]
           ,[IncludeInSitemap]
           ,[ShowOnHomePage]
           ,[HasPersonalTree]
           ,[DisplayOrder]
           ,[CreatedOnUtc]
           ,[UpdatedOnUtc]
           ,[Deleted]
		   ,OldId)
       select [MetaKeywords]
           ,[MetaTitle]
           ,'' as [Author]
           ,ltrim(rtrim(str(Id))) as [AdminComment]
           ,10 as [PageTypeId]
           ,1 as [PageTemplateId]
           ,0 as [ParentPageId]
           ,[Name]
           ,'' as [ShortDescription]
           ,[Description] as [FullDescription]
           ,0 as [PictureId]
           ,[MetaDescription]
           ,[Published]
           ,0 as [AddToTopMenu]
           ,[LimitedToStores]
           ,[SubjectToAcl]
           ,getdate() as [DateUtc]
           ,0 as [AllowComments]
           ,0 as [CommentCount]
           ,'' as [Tags]
           ,0 as [IncludeInSitemap]
           ,0 as [ShowOnHomePage]
           ,0 as [HasPersonalTree]
           ,[DisplayOrder]
           ,getdate() as [CreatedOnUtc]
           ,getdate() as [UpdatedOnUtc]
           ,[Deleted]
		   ,Id
	   from FNS_ArticleGroup 
	   where Id=@oldgroupId

	   set @newgroupId = SCOPE_IDENTITY( )

	   update UrlRecord
		set EntityName='CMSPage', EntityId=@newgroupId
		where EntityName='ArticleGroup' and EntityId=@oldgroupId

	    update AclRecord 
		set EntityName = 'CMSPage', EntityId=@newgroupId
		where EntityName='ArticleGroup' and EntityId=@oldgroupId

	    update StoreMapping 
		set EntityName = 'CMSPage', EntityId=@newgroupId
		where EntityName='ArticleGroup' and EntityId=@oldgroupId

		update LocalizedProperty 
		set LocaleKey='Name', EntityId=@newgroupId, LocaleKeyGroup='CMSPage'
		where LocaleKeyGroup='ArticleGroup' and LocaleKey='Name' and EntityId=@oldgroupId

		update LocalizedProperty 
		set EntityId=@newgroupId, LocaleKeyGroup='CMSPage'
		where LocaleKeyGroup='ArticleGroup' and LocaleKey='MetaTitle' and EntityId=@oldgroupId

		update LocalizedProperty 
		set EntityId=@newgroupId, LocaleKeyGroup='CMSPage'
		where LocaleKeyGroup='ArticleGroup' and LocaleKey='MetaKeywords' and EntityId=@oldgroupId

		update LocalizedProperty 
		set EntityId=@newgroupId, LocaleKeyGroup='CMSPage'
		where LocaleKeyGroup='ArticleGroup' and LocaleKey='MetaDescription' and EntityId=@oldgroupId

	insert into [FNS_CMSPageGroup_Mapping](
	[PageId],
	[GroupId],
	[DisplayOrder])
	select ArticleId,
	@newgroupId as [GroupId],
	[DisplayOrder]
	from FNS_ArticleGroup_Mapping
	where GroupId = @oldgroupId

	   FETCH NEXT FROM myArticleGroup INTO @oldgroupId
   END
   
   CLOSE myArticleGroup
   DEALLOCATE myArticleGroup
   GO

update P
set [ParentPageId] = P2.Id
from [FNS_CMSPage] P, FNS_ArticleGroup A, [FNS_CMSPage] P2
where P.OldId=A.Id and P.PageTypeId =10 
	and A.ParentGroupId = P2.OldId and P2.PageTypeId =10
   
GO
Drop table FNS_ArticleGroup_Mapping
GO
Drop table FNS_ArticleGroup
GO
if (exists(select * 
	from Setting 
	where Name ='cmsmanagersettings.EachRootCategoryHasPersonalTree'
	and Value='true'))
begin
	update FNS_CMSPage
	set HasPersonalTree = 1
	where ParentPageId = 0 and PageTypeId = 10
end

GO
	update S
	set Value = Replace(S.Value, 'FoxNetSoft.Plugin.Misc.Articles','FoxNetSoft.CMSManager')
	from Setting S
	where S.Name ='widgetsettings.activewidgetsystemnames'
GO
update LocaleStringResource 
set ResourceName = 'FoxNetSoft.CMSManager.PageTitle.CMSPage'
where ResourceName = 'FoxNetSoft.Plugin.Misc.Articles.PageTitle.Article'

update LocaleStringResource 
set ResourceName = replace(ResourceName, 'FoxNetSoft.Plugin.Misc.Articles', 'FoxNetSoft.CMSManager')
where ResourceName like '%FoxNetSoft.Plugin.Misc.Articles%'

GO


