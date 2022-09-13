USE [Dc2]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ord]') AND type in (N'U'))
DROP TABLE [dbo].[ord]
GO

CREATE TABLE [dbo].[ord](
	[�Ǹ�] [int] NOT NULL,
	[SUPLU_SEQ] [int] NULL,
	[�q�渹�X] [varchar](20) NULL,
	[�Ȥ�s��] [varchar](8) NULL,
	[�Ȥ�²��] [varchar](10) NULL,
	[������] [datetime] NULL,
	[�����ײv] [decimal](6, 3) NULL,
	[�ڤ��ײv] [decimal](6, 3) NULL,
	[�~���ײv] [decimal](6, 3) NULL,
	[�Ȥ᫬��] [varchar](15) NULL,
	[�[�{����] [varchar](15) NULL,
	[���~����] [varchar](80) NULL,
	[���] [varchar](6) NULL,
	[price�ƶq] [decimal](9, 2) NULL,
	[�q��ƶq] [decimal](9, 2) NULL,
	[��q��ƶq] [decimal](9, 2) NULL,
	[�����ƶq] [decimal](9, 2) NULL,
	[�������] [decimal](9, 3) NULL,
	[�x�����] [decimal](9, 2) NULL,
	[�ڤ����] [decimal](9, 2) NULL,
	[�~�����O] [varchar](3) NULL,
	[�~�����] [decimal](9, 3) NULL,
	[���X] [bit] NULL,
	[�t�ӽs��] [varchar](8) NULL,
	[�t��²��] [varchar](10) NULL,
	[���~����ch] [varchar](40) NULL,
	[���ch] [varchar](6) NULL,
	[COST_NTD] [decimal](9, 2) NULL,
	[COST_USD] [decimal](9, 3) NULL,
	[COST_RMB] [decimal](9, 2) NULL,
	[��Q�v] [decimal](7, 2) NULL,
	[�զX�~] [bit] NULL,
	[�ǳƼƶq] [decimal](9, 2) NULL,
	[�Ƴf�ƶq] [decimal](9, 2) NULL,
	[�X�f�ƶq] [decimal](9, 2) NULL,
	[�b�Ȥ���] [varchar](1) NULL,
	[�X�f�a] [varchar](1) NULL,
	[FREE] [bit] NULL,
	[PI���D] [datetime] NULL,
	[������pD] [varchar](30) NULL,
	[�Ȥ���] [datetime] NULL,
	[TOP300] [bit] NULL,
	[�Ӽ�] [varchar](6) NULL,
	[�Ӽ�2] [varchar](6) NULL,
	[���Xivan_Del] [varchar](1) NULL,
	[�X�f�ܧ�] [varchar](40) NULL,
	[�Ƶ�] [varchar](30) NULL,
	[�����] [bit] NULL,
	[����] [bit] NULL,
	[�ܧ���] [datetime] NULL,
	[��s�H��] [varchar](6) NULL,
	[��s���] [datetime] NULL,
 CONSTRAINT [PK_ord] PRIMARY KEY CLUSTERED 
(
	[�Ǹ�] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ord] ADD  CONSTRAINT [DF_ord_�����ײv]  DEFAULT ((0)) FOR [�����ײv]
GO

ALTER TABLE [dbo].[ord] ADD  CONSTRAINT [DF_ord_�~���ײv]  DEFAULT ((0)) FOR [�~���ײv]
GO

ALTER TABLE [dbo].[ord] ADD  CONSTRAINT [DF_ord_price�ƶq]  DEFAULT ((0)) FOR [price�ƶq]
GO

ALTER TABLE [dbo].[ord] ADD  CONSTRAINT [DF_ord_�q��ƶq]  DEFAULT ((0)) FOR [�q��ƶq]
GO

ALTER TABLE [dbo].[ord] ADD  CONSTRAINT [DF_ord_��q��ƶq]  DEFAULT ((0)) FOR [��q��ƶq]
GO

ALTER TABLE [dbo].[ord] ADD  CONSTRAINT [DF_ord_�������]  DEFAULT ((0)) FOR [�������]
GO

ALTER TABLE [dbo].[ord] ADD  CONSTRAINT [DF_ord_�x�����]  DEFAULT ((0)) FOR [�x�����]
GO

ALTER TABLE [dbo].[ord] ADD  CONSTRAINT [DF_ord_�ڤ����]  DEFAULT ((0)) FOR [�ڤ����]
GO

ALTER TABLE [dbo].[ord] ADD  CONSTRAINT [DF_ord_�~�����]  DEFAULT ((0)) FOR [�~�����]
GO

ALTER TABLE [dbo].[ord] ADD  CONSTRAINT [DF_ord_COST_NTD]  DEFAULT ((0)) FOR [COST_NTD]
GO

ALTER TABLE [dbo].[ord] ADD  CONSTRAINT [DF_ord_COST_USD]  DEFAULT ((0)) FOR [COST_USD]
GO

ALTER TABLE [dbo].[ord] ADD  CONSTRAINT [DF_ord_COST_RMB]  DEFAULT ((0)) FOR [COST_RMB]
GO

ALTER TABLE [dbo].[ord] ADD  CONSTRAINT [DF_ord_��Q�v]  DEFAULT ((0)) FOR [��Q�v]
GO

ALTER TABLE [dbo].[ord] ADD  CONSTRAINT [DF_ord_�ǳƼƶq]  DEFAULT ((0)) FOR [�ǳƼƶq]
GO

ALTER TABLE [dbo].[ord] ADD  CONSTRAINT [DF_ord_�Ƴf�ƶq]  DEFAULT ((0)) FOR [�Ƴf�ƶq]
GO

ALTER TABLE [dbo].[ord] ADD  CONSTRAINT [DF_ord_�X�f�ƶq]  DEFAULT ((0)) FOR [�X�f�ƶq]
GO

ALTER TABLE [dbo].[ord] ADD  CONSTRAINT [DF_ord_��s���]  DEFAULT (getdate()) FOR [��s���]
GO




INSERT INTO Dc2..ord
SELECT [�Ǹ�]
	  ,(SELECT [�Ǹ�] FROM Bc2..suplu2 C WHERE C.�t�ӽs�� = ord.�t�ӽs�� AND C.�[�{���� = ord.�[�{����) [SUPLU_SEQ]
      ,RTRIM([�q�渹�X])
      ,RTRIM([�Ȥ�s��])
      ,RTRIM([�Ȥ�²��])
      ,[������]
      ,[�����ײv]
      ,[�ڤ��ײv]
      ,[�~���ײv]
      ,RTRIM([�Ȥ᫬��])
      ,RTRIM([�[�{����])
      ,RTRIM([���~����])
      ,RTRIM([���])
      ,[price�ƶq]
      ,[�q��ƶq]
      ,[��q��ƶq]
      ,[�����ƶq]
      ,[�������]
      ,[�x�����]
      ,[�ڤ����]
      ,RTRIM([�~�����O])
      ,[�~�����]
      ,[���X]
      ,RTRIM([�t�ӽs��])
      ,RTRIM([�t��²��])
      ,RTRIM([���~����ch])
      ,RTRIM([���ch])
      ,[COST_NTD]
      ,[COST_USD]
      ,[COST_RMB]
      ,[��Q�v]
      ,[�զX�~]
      ,[�ǳƼƶq]
      ,[�Ƴf�ƶq]
      ,[�X�f�ƶq]
      ,RTRIM([�b�Ȥ���])
      ,RTRIM([�X�f�a])
      ,[FREE]
      ,[PI���D]
      ,RTRIM([������pD])
      ,[�Ȥ���]
      ,[TOP300]
      ,RTRIM([�Ӽ�])
      ,RTRIM([�Ӽ�2])
      ,RTRIM([���Xivan_Del])
      ,RTRIM([�X�f�ܧ�])
      ,RTRIM([�Ƶ�])
      ,[�����]
      ,[����]
      ,[�ܧ���]
      ,RTRIM([��s�H��])
      ,[��s���]
FROM Bc2..ord;
