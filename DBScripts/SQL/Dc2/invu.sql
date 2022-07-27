USE [Dc2]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[invu]') AND type in (N'U'))
DROP TABLE [dbo].[invu]
GO

CREATE TABLE [dbo].[invu](
	[�Ǹ�] [int] NOT NULL,
	[INVOICE] [char](8) NULL,
	[�X�f���] [smalldatetime] NULL,
	[�Ȥ�s��] [char](8) NULL,
	[�Ȥ�²��] [char](10) NULL,
	[�Ȧ�s��] [char](2) NULL,
	[�Ȧ�²��] [varchar](8) NULL,
	[���渹�X] [varchar](18) NULL,
	[���|] [bit] NULL,
	[�o���ײv] [decimal](6, 3) NULL,
	[�����˫~�O] [decimal](8, 2) NULL,
	[�����˫~NT] [decimal](8, 2) NULL,
	[�����B�O] [decimal](6, 2) NULL,
	[�����B�ONT] [decimal](6, 2) NULL,
	[�֤j�f����] [bit] NULL,
	[�w�����B] [decimal](8, 2) NULL,
	[�w�����BNT] [decimal](8, 2) NULL,
	[�w�����] [smalldatetime] NULL,
	[�~�����O] [char](3) NULL,
	[�Ƶ��~��] [varchar](1024) NULL,
	[�Ƶ��|�p] [varchar](80) NULL,
	[�Ƶ�_ivan] [varchar](80) NULL,
	[�B��s��] [char](8) NULL,
	[�B��²��] [varchar](20) NULL,
	[�B�e�覡] [varchar](18) NULL,
	[�פJ�Ȧ�] [char](4) NULL,
	[�ܧ���] [smalldatetime] NULL,
	[�إߤH��] [char](6) NULL,
	[�إߤ��] [smalldatetime] NULL,
	[��s�H��] [char](6) NULL,
	[��s���] [smalldatetime] NULL,
 CONSTRAINT [PK_invu] PRIMARY KEY CLUSTERED 
(
	[�Ǹ�] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[invu] ADD  CONSTRAINT [DF_invu_�o���ײv]  DEFAULT ((0)) FOR [�o���ײv]
GO

ALTER TABLE [dbo].[invu] ADD  CONSTRAINT [DF_invu_�����˫~�O]  DEFAULT ((0)) FOR [�����˫~�O]
GO

ALTER TABLE [dbo].[invu] ADD  CONSTRAINT [DF_invu_�����˫~NT]  DEFAULT ((0)) FOR [�����˫~NT]
GO

ALTER TABLE [dbo].[invu] ADD  CONSTRAINT [DF_invu_�����B�O]  DEFAULT ((0)) FOR [�����B�O]
GO

ALTER TABLE [dbo].[invu] ADD  CONSTRAINT [DF_invu_�����B�ONT]  DEFAULT ((0)) FOR [�����B�ONT]
GO

ALTER TABLE [dbo].[invu] ADD  CONSTRAINT [DF_invu_�w�����B]  DEFAULT ((0)) FOR [�w�����B]
GO

ALTER TABLE [dbo].[invu] ADD  CONSTRAINT [DF_invu_�w�����BNT]  DEFAULT ((0)) FOR [�w�����BNT]
GO

ALTER TABLE [dbo].[invu] ADD  CONSTRAINT [DF_invu_��s���]  DEFAULT (getdate()) FOR [��s���]
GO


