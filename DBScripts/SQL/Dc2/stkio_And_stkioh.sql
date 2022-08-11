USE Dc2;
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stkio]') AND type in (N'U'))
DROP TABLE [dbo].[stkio]

CREATE TABLE [dbo].[stkio](
	[�Ǹ�] [int] NOT NULL,
	[SOURCE_SEQ] [int] NULL,
	[SOURCE_TABLE] [varchar](50) NULL,
	[SUPLU_SEQ] [int] NULL,
	[�q�渹�X] [varchar](20) NULL,
	[��ڽs��] [varchar](15) NULL,
	[���ʤ��] [datetime] NULL,
	[�b��] [varchar](2) NULL,
	[�b����]] [varchar](14) NULL,
	[�t�ӽs��] [varchar](8) NULL,
	[�t��²��] [varchar](10) NULL,
	[�[�{����] [varchar](15) NULL,
	[�Ȯɫ���] [varchar](15) NULL,
	[���] [varchar](6) NULL,
	[�w��] [varchar](4) NULL,
	[�J�w��] [decimal](10, 3) NULL,
	[�X�w��] [decimal](10, 3) NULL,
	[�w��] [varchar](12) NULL,
	[�־P��] [decimal](10, 3) NULL,
	[���ʫe�w�s] [decimal](10, 3) NULL,
	[�Ȥ�s��] [varchar](8) NULL,
	[�Ȥ�²��] [varchar](20) NULL,
	[�����~����] [varchar](15) NULL,
	[�Ƶ�] [nvarchar](30) NULL,
	[���P�J�w] [bit] NULL,
	[�w����] [bit] NULL,
	[�w�R��] [bit] NULL,
	[�ܧ���] [datetime] NULL,
	[�إߤH��] [varchar](6) NULL,
	[�إߤ��] [datetime] NULL,
	[��s�H��] [varchar](6) NULL,
	[��s���] [datetime] NULL,
 CONSTRAINT [PK_stkio] PRIMARY KEY CLUSTERED 
(
	[�Ǹ�] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_stkio] ON [dbo].[stkio]
([�q�渹�X] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_stkio_2] ON [dbo].[stkio]
([�w��] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_stkio_3] ON [dbo].[stkio]
([��s���] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[stkio] ADD  CONSTRAINT [DF_stkio_�J�w��]  DEFAULT ((0)) FOR [�J�w��]
GO
ALTER TABLE [dbo].[stkio] ADD  CONSTRAINT [DF_stkio_�X�w��]  DEFAULT ((0)) FOR [�X�w��]
GO
ALTER TABLE [dbo].[stkio] ADD  CONSTRAINT [DF_stkio_�־P��]  DEFAULT ((0)) FOR [�־P��]
GO
ALTER TABLE [dbo].[stkio] ADD  CONSTRAINT [DF_stkio_���ʫe�w�s]  DEFAULT ((0)) FOR [���ʫe�w�s]
GO
ALTER TABLE [dbo].[stkio] ADD  CONSTRAINT [DF_stkio_��s���]  DEFAULT (getdate()) FOR [��s���]
GO
ALTER TABLE [dbo].[stkio] ADD  CONSTRAINT [DF_stkio_�إߤ��]  DEFAULT (getdate()) FOR [�إߤ��]
GO

INSERT INTO Dc2..stkio with(tablock)
SELECT [�Ǹ�], 0 [SOURCE_SEQ], '' [SOURCE_TABLE], (SELECT [�Ǹ�] FROM Bc2..suplu2 C WHERE C.�t�ӽs�� = S.�t�ӽs�� AND C.�[�{���� = S.�[�{����) [SUPLU_SEQ], RTRIM([�q�渹�X]), RTRIM([��ڽs��]),
	[���ʤ��], RTRIM([�b��]), RTRIM([�b����]]), RTRIM([�t�ӽs��]), RTRIM([�t��²��]), RTRIM([�[�{����]),
	RTRIM([�Ȯɫ���]), RTRIM([���]), RTRIM([�w��]), [�J�w��], [�X�w��], RTRIM([�w��]), [�־P��], [���ʫe�w�s],
	RTRIM([�Ȥ�s��]), RTRIM([�Ȥ�²��]), RTRIM([�����~����]), RTRIM([�Ƶ�]), [���P�J�w], [�w�R��], [�w�R��], [�ܧ���], RTRIM([��s�H��]), [��s���], RTRIM([��s�H��]), [��s���]
FROM Bc2..stkio S


USE Dc2;
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stkioh]') AND type in (N'U'))
DROP TABLE [dbo].[stkioh]

CREATE TABLE [dbo].[stkioh](
	[�Ǹ�] [int] NOT NULL,
	[SOURCE_SEQ] [int] NULL,
	[SOURCE_TABLE] [varchar](50) NULL,
	[SUPLU_SEQ] [int] NULL,
	[�q�渹�X] [varchar](20) NULL,
	[��ڽs��] [varchar](15) NULL,
	[���ʤ��] [datetime] NULL,
	[�b��] [varchar](2) NULL,
	[�b����]] [varchar](14) NULL,
	[�t�ӽs��] [varchar](8) NULL,
	[�t��²��] [varchar](10) NULL,
	[�[�{����] [varchar](15) NULL,
	[�Ȯɫ���] [varchar](15) NULL,
	[���] [varchar](6) NULL,
	[�w��] [varchar](4) NULL,
	[�J�w��] [decimal](10, 3) NULL,
	[�X�w��] [decimal](10, 3) NULL,
	[�w��] [varchar](12) NULL,
	[�־P��] [decimal](10, 3) NULL,
	[���ʫe�w�s] [decimal](10, 3) NULL,
	[�ꦩ�֨���] [decimal](10, 3) NULL,
	[�Ȥ�s��] [varchar](8) NULL,
	[�Ȥ�²��] [varchar](20) NULL,
	[�����~����] [varchar](15) NULL,
	[�Ƶ�] [nvarchar](30) NULL,
	[���P�J�w] [bit] NULL,
	[�w�R��] [bit] NULL,
	[�ܧ���] [datetime] NULL,
	[�إߤH��] [varchar](6) NULL,
	[�إߤ��] [datetime] NULL,
	[��s�H��] [varchar](6) NULL,
	[��s���] [datetime] NULL,
 CONSTRAINT [PK_stkioh] PRIMARY KEY CLUSTERED 
(
	[�Ǹ�] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_stkio] ON [dbo].[stkioh]
([�q�渹�X] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_stkioh_2] ON [dbo].[stkioh]
([�w��] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_stkioh_3] ON [dbo].[stkioh]
([��s���] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[stkioh] ADD  CONSTRAINT [DF_stkioh_�J�w��]  DEFAULT ((0)) FOR [�J�w��]
GO
ALTER TABLE [dbo].[stkioh] ADD  CONSTRAINT [DF_stkioh_�X�w��]  DEFAULT ((0)) FOR [�X�w��]
GO
ALTER TABLE [dbo].[stkioh] ADD  CONSTRAINT [DF_stkioh_�־P��]  DEFAULT ((0)) FOR [�־P��]
GO
ALTER TABLE [dbo].[stkioh] ADD  CONSTRAINT [DF_stkioh_���ʫe�w�s]  DEFAULT ((0)) FOR [���ʫe�w�s]
GO
ALTER TABLE [dbo].[stkioh] ADD  CONSTRAINT [DF_stkioh_��s���]  DEFAULT (getdate()) FOR [��s���]
GO
ALTER TABLE [dbo].[stkioh] ADD  CONSTRAINT [DF_stkioh_�إߤ��]  DEFAULT (getdate()) FOR [�إߤ��]
GO

INSERT INTO Dc2..stkioh with(tablock)
SELECT [�Ǹ�], 0 [SOURCE_SEQ], '' [SOURCE_TABLE],
	(SELECT [�Ǹ�] FROM Bc2..suplu2 C WHERE C.�t�ӽs�� = S.�t�ӽs�� AND C.�[�{���� = S.�[�{����) [SUPLU_SEQ], RTRIM([�q�渹�X]), RTRIM([��ڽs��]),
	[���ʤ��], RTRIM([�b��]), RTRIM([�b����]]), RTRIM([�t�ӽs��]), RTRIM([�t��²��]), RTRIM([�[�{����]),
	RTRIM([�Ȯɫ���]), RTRIM([���]), RTRIM([�w��]), [�J�w��], [�X�w��], RTRIM([�w��]), [�־P��], [���ʫe�w�s],	[�ꦩ�֨���],
	RTRIM([�Ȥ�s��]), RTRIM([�Ȥ�²��]), RTRIM([�����~����]), RTRIM([�Ƶ�]), [���P�J�w], [�w�R��], [�ܧ���], RTRIM([��s�H��]), [��s���], RTRIM([��s�H��]), [��s���]
FROM Bc2..stkioh S

