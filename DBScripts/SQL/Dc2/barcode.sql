USE [Dc2]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[barcode]') AND type in (N'U'))
DROP TABLE [dbo].[barcode]
GO

CREATE TABLE [dbo].[barcode](
	[�Ǹ�] [int] NOT NULL,
	[�Ȥ�s��] [varchar](8) NULL,
	[�Ȥ�²��] [varchar](10) NULL,
	[�[�{����] [varchar](15) NULL,
	[�Ȥ᫬��] [varchar](15) NULL,
	[upc] [varchar](13) NULL,
	[���~����] [varchar](40) NULL,
	[���~�����G] [varchar](30) NULL,
	[���~�����T] [varchar](33) NULL,
	[���~�����|] [varchar](33) NULL,
	[���~������] [varchar](33) NULL,
	[���~������] [varchar](33) NULL,
	[��A] [varchar](10) NULL,
	[�ؤo] [varchar](10) NULL,
	[���] [varchar](12) NULL,
	[���a] [varchar](20) NULL,
	[�˦�] [varchar](4) NULL,
	[�˦�2] [varchar](4) NULL,
	[CP65] [varchar](2) NULL,
	[���] [decimal](6, 2) NULL,
	[���U����] [int] NULL,
	[���U���] [int] NULL,
	[�ۦ����X] [bit] NULL,
	[���X����] [int] NULL,
	[�H�e�U�l] [varchar](12) NULL,
	[�H�e�Q�d] [varchar](12) NULL,
	[�۳ƳU�l] [bit] NULL,
	[�۳ƦQ�d] [bit] NULL,
	[�S��]��] [varchar](12) NULL,
	[�S��Q�d] [varchar](12) NULL,
	[�~��] [varchar](2) NULL,
	[�]�˳��] [decimal](6, 3) NULL,
	[�t�ӽs��] [varchar](8) NULL,
	[�t��²��] [varchar](10) NULL,
	[�ܧ���] [datetime] NULL,
	[��s�H��] [varchar](6) NULL,
	[��s���] [datetime] NULL,
 CONSTRAINT [PK_barcode] PRIMARY KEY CLUSTERED 
(
	[�Ǹ�] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[barcode] ADD  CONSTRAINT [DF_barcode_��s���]  DEFAULT (getdate()) FOR [��s���]
GO


INSERT INTO Dc2..barcode
SELECT [�Ǹ�]
      ,RTRIM([�Ȥ�s��])
      ,RTRIM([�Ȥ�²��])
      ,RTRIM([�[�{����])
      ,RTRIM([�Ȥ᫬��])
      ,RTRIM([upc])
      ,RTRIM([���~����])
      ,RTRIM([���~�����G])
      ,RTRIM([���~�����T])
      ,RTRIM([���~�����|])
      ,RTRIM([���~������])
      ,RTRIM([���~������])
      ,RTRIM([��A])
      ,RTRIM([�ؤo])
      ,RTRIM([���])
      ,RTRIM([���a])
      ,RTRIM([�˦�])
      ,RTRIM([�˦�2])
      ,RTRIM([CP65])
      ,[���]
      ,[���U����]
      ,[���U���]
      ,[�ۦ����X]
      ,[���X����]
      ,RTRIM([�H�e�U�l])
      ,RTRIM([�H�e�Q�d])
      ,[�۳ƳU�l]
      ,[�۳ƦQ�d]
      ,RTRIM([�S��]��])
      ,RTRIM([�S��Q�d])
      ,RTRIM([�~��])
      ,[�]�˳��]
      ,RTRIM([�t�ӽs��])
      ,RTRIM([�t��²��])
      ,[�ܧ���]
      ,RTRIM([��s�H��])
      ,[��s���]
FROM Bc2..barcode;
