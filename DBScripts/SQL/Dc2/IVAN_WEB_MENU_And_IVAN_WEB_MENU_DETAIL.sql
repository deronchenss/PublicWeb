USE [Dc2]
GO

IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'pass' AND COLUMN_NAME = 'IVM_PERMISSIONS')
	ALTER TABLE Dc2..pass ADD IVM_PERMISSIONS NVARCHAR(MAX);
GO

IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'pass' AND COLUMN_NAME = 'IVMD_PERMISSIONS')
	ALTER TABLE Dc2..pass ADD IVMD_PERMISSIONS NVARCHAR(MAX);
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IVAN_WEB_MENU]') AND type in (N'U'))
	DROP TABLE [dbo].[IVAN_WEB_MENU]
GO

CREATE TABLE [dbo].[IVAN_WEB_MENU](
	[IVM_SEQ] [bigint] NOT NULL,
	[IVM_TITLE] [nvarchar](40) NULL,
	[IVM_PROG_NAME] [nvarchar](40) NULL,
	[IVM_PARENT_SEQ] [bigint] NULL,
	[IVM_RANK] [int] NULL,
	[IVM_REMARK] [nvarchar](max) NULL,
	[CREATE_USER] [varchar](20) NULL,
	[CREATE_DATE] [datetime] NULL,
	[UPDATE_USER] [varchar](20) NULL,
	[UPDATE_DATE] [datetime] NULL,
 CONSTRAINT [PK_IVAN_WEB_MENU] PRIMARY KEY CLUSTERED 
(
	[IVM_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

--SELECT * FROM Dc2..IVAN_WEB_MENU

INSERT INTO Dc2..IVAN_WEB_MENU([IVM_SEQ], [IVM_TITLE], [IVM_PROG_NAME], [IVM_PARENT_SEQ], [IVM_RANK], [IVM_REMARK], [CREATE_USER], [CREATE_DATE], [UPDATE_USER], [UPDATE_DATE])
SELECT 
	[IVM_SEQ] = '1',
	[IVM_TITLE] = N'基本檔',
	[IVM_PROG_NAME] = '',
	[IVM_PARENT_SEQ] = 0,
	[IVM_RANK] = 1,
	[IVM_REMARK] = '',
	[CREATE_USER] = 'Fatial',
	[CREATE_DATE] = GETDATE(),
	[UPDATE_USER] = 'Fatial',
	[UPDATE_DATE] = GETDATE()
UNION ALL SELECT '2',N'採購','',0,1,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '3',N'訂單','',0,1,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '4',N'出貨','',0,1,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '5',N'庫存','',0,1,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '6',N'裝配','',0,1,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '7',N'樣品','',0,1,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '8',N'理貨','',0,1,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '9',N'會計','',0,1,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '10',N'財務','',0,1,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '11',N'廠商','',1,2,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '12',N'客戶','',1,2,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '13',N'Cost','',1,2,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '14',N'Price','',1,2,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '15',N'BOM','',1,2,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '16',N'條碼作業','',1,2,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '17',N'型錄專案','',1,2,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '18',N'採購作業','',2,2,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '19',N'點收作業','',2,2,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '20',N'到貨作業','',2,2,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '21',N'訂單作業','',3,2,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '22',N'SHOPIFY','',3,2,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '23',N'客戶退貨','',3,2,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '24',N'應收帳款','',3,2,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '25',N'內銷','',3,2,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '26',N'備貨作業','',4,2,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '27',N'出貨作業','',4,2,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '28',N'廠商退貨','',5,2,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '29',N'樣品開發','',7,2,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '30',N'出貨作業','',7,2,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '31',N'樣品到貨','',7,2,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '32',N'樣品出貨','',7,2,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '33',N'樣品報價','',7,2,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '34',N'廠商查詢','Supplier1',11,3,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '35',N'廠商維護','Supplier_MT',11,3,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '36',N'客戶查詢','Customer1',12,3,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '37',N'客戶維護','Customer_MT',12,3,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '38',N'Cost查詢維護','Cost_MT',13,3,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '39',N'Cost多筆維護','Cost_Multiple_MT',13,3,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '40',N'Cost分類維護','Cost_Class',13,3,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '41',N'Cost申請放行','Cost_Apply',13,3,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '42',N'Cost審核','Cost_Approve',13,3,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '43',N'Cost首次點收核准','Fist_CAA_Approve',13,3,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '44',N'Cost報表','Cost_Report',13,3,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '45',N'Price查詢維護','Price_MT',14,3,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '46',N'Price多筆複製','Price_Multiple_Copy',14,3,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '47',N'BOM查詢維護(成品變更)','BOM_MT',15,3,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '48',N'BOM多筆維護(材料變更)','BOM_Multiple_MT',15,3,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '49',N'型號查詢','Model_Search',1,3,'','Fatial',GETDATE(),'Fatial',GETDATE()

-------------------------------------[IVAN_WEB_MENU_DETAIL]
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IVAN_WEB_MENU_DETAIL]') AND type in (N'U'))
	DROP TABLE [dbo].[IVAN_WEB_MENU_DETAIL]
GO

CREATE TABLE [dbo].[IVAN_WEB_MENU_DETAIL](
	[IVMD_SEQ] [bigint] NOT NULL,
	[IVM_SEQ] [bigint] NOT NULL,
	[IVMD_ELEMENT_TITLE] [nvarchar](40) NULL,
	[IVMD_CHECK] [bit] NULL,
	[IVMD_REMARK] [nvarchar](max) NULL,
	[CREATE_USER] [varchar](20) NULL,
	[CREATE_DATE] [datetime] NULL,
	[UPDATE_USER] [varchar](20) NULL,
	[UPDATE_DATE] [datetime] NULL,
 CONSTRAINT [PK_IVAN_WEB_MENU_DETAIL] PRIMARY KEY CLUSTERED 
(
	[IVMD_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/*
SELECT DISTINCT T.B
FROM (
SELECT 程式名稱, 使用者, COUNT(1) [A], (SELECT RTRIM(X.內容)+',' FROM Bc2..bcright X WHERE X.使用者 = M.使用者 AND X.程式名稱 = M.程式名稱 FOR XML PATH('')) [B]
FROM Bc2..bcright M
WHERE 程式名稱 = 'Bc710UM'
GROUP BY 程式名稱, 使用者
)T
*/