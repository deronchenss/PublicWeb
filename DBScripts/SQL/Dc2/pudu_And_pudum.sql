USE [Dc2]
GO

--DROP INDEX [IX_pudu_2] ON [dbo].[pudu]
--DROP INDEX [IX_pudu_1] ON [dbo].[pudu]
--DROP INDEX [IX_pudu] ON [dbo].[pudu]
--GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pudu]') AND type in (N'U'))
DROP TABLE [dbo].[pudu]
GO
CREATE TABLE [dbo].[pudu](
	[�Ǹ�] [int] NOT NULL,
	[SUPLU_SEQ] [int] NULL,
	[���ʳ渹] [varchar](9) NULL,
	[���ʤ��] [datetime] NULL,
	[�˫~���X] [varchar](18) NULL,
	[�u�@���O] [varchar](4) NULL,
	[�t�ӽs��] [varchar](8) NULL,
	[�t��²��] [varchar](10) NULL,
	[�[�{����] [varchar](15) NULL,
	[�Ȯɫ���] [varchar](15) NULL,
	[�t�ӫ���] [varchar](19) NULL,
	[���~����] [varchar](360) NULL,
	[���] [varchar](6) NULL,
	[�x�����] [decimal](9, 2) NULL,
	[�������] [decimal](9, 3) NULL,
	[�H�������] [decimal](9, 2) NULL,
	[���_2] [decimal](9, 3) NULL,
	[���_3] [decimal](9, 3) NULL,
	[MIN_1] [int] NULL,
	[MIN_2] [int] NULL,
	[MIN_3] [int] NULL,
	[�~�����O] [varchar](3) NULL,
	[�~�����] [decimal](9, 2) NULL,
	[�~�����_2] [decimal](9, 2) NULL,
	[�~�����_3] [decimal](9, 2) NULL,
	[���ʼƶq] [decimal](9, 3) NULL,
	[���ʥ��] [datetime] NULL,
	[������p] [varchar](30) NULL,
--	[�I���帹] [varchar](9) NULL,
--	[�I���ƶq] [decimal](9, 3) NULL,
--	[�I�����] [datetime] NULL,
--	[��f�ƶq] [decimal](9, 3) NULL,
--	[�X�f���] [datetime] NULL,
--	[��f���] [datetime] NULL,
--	[�B��s��] [varchar](8) NULL,
--	[�B��²��] [varchar](20) NULL,
	[�q��ƶq] [decimal](9, 3) NULL,
	[�Ȥ�s��] [varchar](8) NULL,
	[�Ȥ�²��] [varchar](10) NULL,
	[��f�B�z] [varchar](255) NULL,
	[�C��p�Ƶ�] [varchar](50) NULL,
	[����] [bit] NULL,
	[�j���] [bit] NULL,
	[�B�e�覡] [varchar](18) NULL,
	[����] [varchar](2) NULL,
	[�ܧ���] [datetime] NULL,
	[��s�H��] [varchar](6) NULL,
	[��s���] [datetime] NULL,
 CONSTRAINT [PK_pudu] PRIMARY KEY CLUSTERED 
([�Ǹ�] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_pudu] ON [dbo].[pudu]
([��s���] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_pudu_1] ON [dbo].[pudu]
([���ʳ渹] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_pudu_2] ON [dbo].[pudu]
([���ʤ��] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[pudu] ADD  CONSTRAINT [DF_pudu_�x�����]  DEFAULT ((0)) FOR [�x�����]
ALTER TABLE [dbo].[pudu] ADD  CONSTRAINT [DF_pudu_�������]  DEFAULT ((0)) FOR [�������]
ALTER TABLE [dbo].[pudu] ADD  CONSTRAINT [DF_pudu_�H�������]  DEFAULT ((0)) FOR [�H�������]
ALTER TABLE [dbo].[pudu] ADD  CONSTRAINT [DF_pudu_���_2]  DEFAULT ((0)) FOR [���_2]
ALTER TABLE [dbo].[pudu] ADD  CONSTRAINT [DF_pudu_���_3]  DEFAULT ((0)) FOR [���_3]
ALTER TABLE [dbo].[pudu] ADD  CONSTRAINT [DF_pudu_MIN_1]  DEFAULT ((0)) FOR [MIN_1]
ALTER TABLE [dbo].[pudu] ADD  CONSTRAINT [DF_pudu_MIN_2]  DEFAULT ((0)) FOR [MIN_2]
ALTER TABLE [dbo].[pudu] ADD  CONSTRAINT [DF_pudu_MIN_3]  DEFAULT ((0)) FOR [MIN_3]
ALTER TABLE [dbo].[pudu] ADD  CONSTRAINT [DF_pudu_���ʼƶq]  DEFAULT ((0)) FOR [���ʼƶq]
--ALTER TABLE [dbo].[pudu] ADD  CONSTRAINT [DF_pudu_�I���ƶq]  DEFAULT ((0)) FOR [�I���ƶq]
--ALTER TABLE [dbo].[pudu] ADD  CONSTRAINT [DF_pudu_��f�ƶq]  DEFAULT ((0)) FOR [��f�ƶq]
ALTER TABLE [dbo].[pudu] ADD  CONSTRAINT [DF_pudu_�q��ƶq]  DEFAULT ((0)) FOR [�q��ƶq]
ALTER TABLE [dbo].[pudu] ADD  CONSTRAINT [DF_pudu_��s���]  DEFAULT (getdate()) FOR [��s���]
GO


INSERT INTO Dc2..pudu with(tablock)
SELECT [�Ǹ�],
	(SELECT C.�Ǹ� FROM Bc2..suplu2 C WHERE C.�[�{���� = P.�[�{���� AND C.�t�ӽs�� = P.�t�ӽs��) [SUPLU_SEQ],
	RTRIM([���ʳ渹]), [���ʤ��], RTRIM([�˫~���X]), RTRIM([�u�@���O]), RTRIM([�t�ӽs��]), RTRIM([�t��²��]), RTRIM([�[�{����]), RTRIM([�Ȯɫ���]), RTRIM([�t�ӫ���]), RTRIM([���~����]), RTRIM([���]),
	[�x�����], [�������], [�H�������], [���_2], [���_3], [MIN_1], [MIN_2], [MIN_3], RTRIM([�~�����O]), [�~�����], [�~�����_2], [�~�����_3], [���ʼƶq], [���ʥ��], RTRIM([������p]), [�q��ƶq], RTRIM([�Ȥ�s��]), RTRIM([�Ȥ�²��]), RTRIM([��f�B�z]),
	RTRIM([�C��p�Ƶ�]), [����], [�j���], RTRIM([�B�e�覡]), RTRIM([����]), [�ܧ���], RTRIM([��s�H��]), [��s���]
FROM Bc2..pudu P

---------------------pudum---------------------
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pudum]') AND type in (N'U'))
DROP TABLE [dbo].[pudum]
GO
CREATE TABLE [dbo].[pudum](
	[�Ǹ�] [int] NOT NULL,
	[���ʳ渹] [varchar](9) NULL,
	[���O] [varchar](3) NULL,
	[�w�I�ڤ@] [decimal](8, 2) NULL,
	[�w�I��@] [datetime] NULL,
	[�w�I�ڤG] [decimal](8, 2) NULL,
	[�w�I��G] [datetime] NULL,
	[�־P���B] [decimal](9, 2) NULL,
	[�־P���] [datetime] NULL,
	[���[�O] [decimal](9, 2) NULL,
	[���[�O����] [varchar](50) NULL,
	[�j�Ƶ��@] [varchar](90) NULL,
	[�j�Ƶ��G] [varchar](90) NULL,
	[�j�Ƶ��T] [varchar](90) NULL,
	[�S�O�ƶ�] [varchar](2048) NULL,
	[�ܧ���] [datetime] NULL,
	[��s�H��] [varchar](6) NULL,
	[��s���] [datetime] NULL,
 CONSTRAINT [PK_pudum] PRIMARY KEY CLUSTERED 
([�Ǹ�] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[pudum] ADD  CONSTRAINT [DF_pudum_��s���]  DEFAULT (getdate()) FOR [��s���]
GO

INSERT INTO Dc2..pudum
SELECT [�Ǹ�], RTRIM([���ʳ渹]), RTRIM([���O]), [�w�I�ڤ@], [�w�I��@], [�w�I�ڤG], [�w�I��G], [�־P���B], [�־P���], [���[�O], 
	RTRIM([���[�O����]), RTRIM([�j�Ƶ��@]), RTRIM([�j�Ƶ��G]), RTRIM([�j�Ƶ��T]), RTRIM([�S�O�ƶ�]), [�ܧ���], RTRIM([��s�H��]), [��s���]
FROM Bc2..pudum
