USE [Dc2]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[invu]') AND type in (N'U'))
DROP TABLE [dbo].[invu]
GO

CREATE TABLE [dbo].[invu](
	[�Ǹ�] [int] NOT NULL,
	[INVOICE] [varchar](8) NULL,
	[�X�f���] [datetime] NULL,
	[�Ȥ�s��] [varchar](8) NULL,
	[�Ȥ�²��] [varchar](10) NULL,
	[�Ȧ�s��] [varchar](2) NULL,
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
	[�w�����] [datetime] NULL,
	[�~�����O] [varchar](3) NULL,
	[�Ƶ��~��] [varchar](1024) NULL,
	[�Ƶ��|�p] [varchar](80) NULL,
	[�Ƶ�_ivan] [varchar](80) NULL,
	[�B��s��] [varchar](8) NULL,
	[�B��²��] [varchar](20) NULL,
	[�B�e�覡] [varchar](18) NULL,
	[�פJ�Ȧ�] [varchar](4) NULL,
	[�ܧ���] [datetime] NULL,
	[�إߤH��] [varchar](20) NULL,
	[�إߤ��] [datetime] NULL,
	[��s�H��] [varchar](20) NULL,
	[��s���] [datetime] NULL,
 CONSTRAINT [PK_invu] PRIMARY KEY CLUSTERED 
(
	[�Ǹ�] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE INDEX invu_SEQ_INVOICE ON [invu]([INVOICE])

ALTER TABLE [dbo].[invu] ADD  CONSTRAINT [DF_invu_�o���ײv]  DEFAULT ((0)) FOR [�o���ײv]
ALTER TABLE [dbo].[invu] ADD  CONSTRAINT [DF_invu_�����˫~�O]  DEFAULT ((0)) FOR [�����˫~�O]
ALTER TABLE [dbo].[invu] ADD  CONSTRAINT [DF_invu_�����˫~NT]  DEFAULT ((0)) FOR [�����˫~NT]
ALTER TABLE [dbo].[invu] ADD  CONSTRAINT [DF_invu_�����B�O]  DEFAULT ((0)) FOR [�����B�O]
ALTER TABLE [dbo].[invu] ADD  CONSTRAINT [DF_invu_�����B�ONT]  DEFAULT ((0)) FOR [�����B�ONT]
ALTER TABLE [dbo].[invu] ADD  CONSTRAINT [DF_invu_�w�����B]  DEFAULT ((0)) FOR [�w�����B]
ALTER TABLE [dbo].[invu] ADD  CONSTRAINT [DF_invu_�w�����BNT]  DEFAULT ((0)) FOR [�w�����BNT]
ALTER TABLE [dbo].[invu] ADD  CONSTRAINT [DF_invu_��s���]  DEFAULT (getdate()) FOR [��s���]
GO

INSERT INTO Dc2..invu
SELECT [�Ǹ�], RTRIM([INVOICE]), [�X�f���], RTRIM([�Ȥ�s��]), RTRIM([�Ȥ�²��]),
	RTRIM([�Ȧ�s��]), RTRIM([�Ȧ�²��]), RTRIM([���渹�X]), [���|],
	[�o���ײv], [�����˫~�O], [�����˫~NT], [�����B�O], [�����B�ONT], [�֤j�f����], [�w�����B], [�w�����BNT], [�w�����],
	RTRIM([�~�����O]), RTRIM([�Ƶ��~��]), RTRIM([�Ƶ��|�p]), RTRIM([�Ƶ�_ivan]), RTRIM([�B��s��]), RTRIM([�B��²��]),RTRIM([�B�e�覡]), RTRIM([�פJ�Ȧ�]),
	[�ܧ���], RTRIM([��s�H��]) [�إߤH��], [��s���] [�إߤ��], RTRIM([��s�H��]), [��s���]
FROM Bc2..invu;

