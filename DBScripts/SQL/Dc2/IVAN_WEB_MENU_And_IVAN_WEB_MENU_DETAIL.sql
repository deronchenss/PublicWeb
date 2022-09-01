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
	[IVM_TITLE] = N'����',
	[IVM_PROG_NAME] = '',
	[IVM_PARENT_SEQ] = 0,
	[IVM_RANK] = 1,
	[IVM_REMARK] = '',
	[CREATE_USER] = 'Fatial',
	[CREATE_DATE] = GETDATE(),
	[UPDATE_USER] = 'Fatial',
	[UPDATE_DATE] = GETDATE()
UNION ALL SELECT '2',N'����','',0,1,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '3',N'�q��','',0,1,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '4',N'�X�f','',0,1,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '5',N'�w�s','',0,1,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '6',N'�˰t','',0,1,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '7',N'�˫~','',0,1,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '8',N'�z�f','',0,1,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '9',N'�|�p','',0,1,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '10',N'�]��','',0,1,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '11',N'�t��','',1,2,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '12',N'�Ȥ�','',1,2,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '13',N'Cost','',1,2,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '14',N'Price','',1,2,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '15',N'BOM','',1,2,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '16',N'���X�@�~','',1,2,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '17',N'�����M��','',1,2,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '18',N'���ʧ@�~','',2,2,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '19',N'�I���@�~','',2,2,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '20',N'��f�@�~','',2,2,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '21',N'�q��@�~','',3,2,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '22',N'SHOPIFY','',3,2,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '23',N'�Ȥ�h�f','',3,2,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '24',N'�����b��','',3,2,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '25',N'���P','',3,2,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '26',N'�Ƴf�@�~','',4,2,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '27',N'�X�f�@�~','',4,2,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '28',N'�t�Ӱh�f','',5,2,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '29',N'�˫~�}�o','',7,2,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '30',N'�X�f�@�~','',7,2,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '31',N'�˫~��f','',7,2,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '32',N'�˫~�X�f','',7,2,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '33',N'�˫~����','',7,2,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '34',N'�t�Ӭd��','Supplier1',11,3,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '35',N'�t�Ӻ��@','Supplier_MT',11,3,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '36',N'�Ȥ�d��','Customer1',12,3,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '37',N'�Ȥ���@','Customer_MT',12,3,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '38',N'Cost�d�ߺ��@','Cost_MT',13,3,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '39',N'Cost�h�����@','Cost_Multiple_MT',13,3,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '40',N'Cost�������@','Cost_Class',13,3,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '41',N'Cost�ӽЩ��','Cost_Apply',13,3,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '42',N'Cost�f��','Cost_Approve',13,3,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '43',N'Cost�����I���֭�','Fist_CAA_Approve',13,3,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '44',N'Cost����','Cost_Report',13,3,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '45',N'Price�d�ߺ��@','Price_MT',14,3,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '46',N'Price�h���ƻs','Price_Multiple_Copy',14,3,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '47',N'BOM�d�ߺ��@(���~�ܧ�)','BOM_MT',15,3,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '48',N'BOM�h�����@(�����ܧ�)','BOM_Multiple_MT',15,3,'','Fatial',GETDATE(),'Fatial',GETDATE()
UNION ALL SELECT '49',N'�����d��','Model_Search',1,3,'','Fatial',GETDATE(),'Fatial',GETDATE()

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
SELECT �{���W��, �ϥΪ�, COUNT(1) [A], (SELECT RTRIM(X.���e)+',' FROM Bc2..bcright X WHERE X.�ϥΪ� = M.�ϥΪ� AND X.�{���W�� = M.�{���W�� FOR XML PATH('')) [B]
FROM Bc2..bcright M
WHERE �{���W�� = 'Bc710UM'
GROUP BY �{���W��, �ϥΪ�
)T
*/