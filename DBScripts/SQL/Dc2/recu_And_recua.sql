--�h��
--[�x�����] [decimal](9, 2) NULL,[�������] [decimal](9, 3) NULL,[�H�������] [decimal](9, 2) NULL,[�~�����O] [varchar](3) NULL,[�~�����] [decimal](9, 2) NULL,

USE Dc2;
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[recu]') AND type in (N'U'))
DROP TABLE [dbo].[recu]
--�W�[ PUDU_SEQ
CREATE TABLE [dbo].[recu](
	[�Ǹ�] [int] NOT NULL,
	[PUDU_SEQ] [int] NULL,
	[�I���帹] [varchar](9) NULL,
	[���ʳ渹] [varchar](9) NULL,
	[�˫~���X] [varchar](18) NULL,
	[�t�ӽs��] [varchar](8) NULL,
	[�t��²��] [varchar](10) NULL,
	[�[�{����] [varchar](15) NULL,
	[�Ȯɫ���] [varchar](15) NULL,
	[�t�ӫ���] [varchar](19) NULL,
	[���] [varchar](6) NULL,
	[�վ��B01] [decimal](9, 2) NULL,
	[�վ��B02] [decimal](4, 2) NULL,
	[�X�f���] [datetime] NULL,
	[��f���] [datetime] NULL,
	[��f�渹] [varchar](15) NULL,
	[��f�ƶq] [decimal](9, 2) NULL,
	[�����] [datetime] NULL,
--	[�B��s��] [varchar](8) NULL,
--	[�B��²��] [varchar](20) NULL,
	[�B�e�覡] [varchar](18) NULL,
	[���I��] [bit] NULL,
	[�o���˦�] [varchar](2) NULL,
	[�o�����X] [varchar](12) NULL,
	[�o�����`] [bit] NULL,
	[�k�ݦ~] [smallint] NULL,
	[�k�ݤ�] [smallint] NULL,
	[��f�Ƶ�] [varchar](50) NULL,
	[����] [varchar](2) NULL,
	[�ܧ���] [datetime] NULL,
	[��s�H��] [varchar](6) NULL,
	[��s���] [datetime] NULL,
 CONSTRAINT [PK_recu] PRIMARY KEY CLUSTERED 
([�Ǹ�] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [IX_recu] ON [dbo].[recu]
([�X�f���] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_recu_1] ON [dbo].[recu]
([�[�{����] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_recu_2] ON [dbo].[recu]
([�t�ӽs��] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_recu_3] ON [dbo].[recu]
([��f���] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_recu_4] ON [dbo].[recu]
([�I���帹] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
CREATE INDEX recu_IDX_PUDU_SEQ ON recu(PUDU_SEQ);
ALTER TABLE [dbo].[recu] ADD  CONSTRAINT [DF_recu_��f�ƶq]  DEFAULT ((0)) FOR [��f�ƶq]
ALTER TABLE [dbo].[recu] ADD  CONSTRAINT [DF_recu_��s���]  DEFAULT (getdate()) FOR [��s���]

INSERT INTO Dc2..recu
SELECT [�Ǹ�],
CASE (SELECT COUNT(1) FROM Bc2..pudu P WHERE P.���ʳ渹 = R.���ʳ渹 AND P.�˫~���X = R.�˫~���X AND P.[�[�{����] = R.[�[�{����]) WHEN 1 
	 THEN (SELECT TOP 1 [�Ǹ�] FROM Bc2..pudu P WHERE P.���ʳ渹 = R.���ʳ渹 AND P.�˫~���X = R.�˫~���X AND P.[�[�{����] = R.[�[�{����])
	 ELSE 0 END [PUDU_SEQ],
RTRIM([�I���帹]), 
RTRIM([���ʳ渹]), RTRIM([�˫~���X]), RTRIM([�t�ӽs��]), RTRIM([�t��²��]), RTRIM([�[�{����]), RTRIM([�Ȯɫ���]), RTRIM([�t�ӫ���]), RTRIM([���]),
	[�վ��B01], [�վ��B02], [�X�f���], [��f���], [��f�渹], [��f�ƶq], [�����], 
	--RTRIM([�B��s��]), 
	--[�B��²��], 
	[�B�e�覡], [���I��], [�o���˦�], [�o�����X], [�o�����`], [�k�ݦ~], [�k�ݤ�], [��f�Ƶ�], [����], [�ܧ���], RTRIM([��s�H��]),[��s���]
FROM Bc2..recu R

-----------------recua
USE Dc2;
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[recua]') AND type in (N'U'))
DROP TABLE [dbo].[recua]
GO
CREATE TABLE [dbo].[recua](
	[�Ǹ�] [int] NOT NULL,
	PUDU_SEQ [int] NULL,
	[�I���帹] [varchar](9) NULL,
	[���ʳ渹] [varchar](9) NULL,
	[�˫~���X] [varchar](18) NULL,
	[�t�ӽs��] [varchar](8) NULL,
	[�t��²��] [varchar](10) NULL,
	[�[�{����] [varchar](15) NULL,
	[�Ȯɫ���] [varchar](15) NULL,
	[�t�ӫ���] [varchar](19) NULL,
	[���] [varchar](6) NULL,
	[�I�����] [datetime] NULL,
	[�I���ƶq] [decimal](9, 2) NULL,
	[�־P�ƶq] [decimal](9, 2) NULL,
	[�B��s��] [varchar](8) NULL,
	[�B��²��] [varchar](20) NULL,
	[�B�e�覡] [varchar](18) NULL,
	[�ܧ���] [datetime] NULL,
	[��s�H��] [varchar](6) NULL,
	[��s���] [datetime] NULL,
 CONSTRAINT [PK_recua] PRIMARY KEY CLUSTERED 
(
	[�Ǹ�] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_recua] ON [dbo].[recua]
([�I�����] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_recua_1] ON [dbo].[recua]
([�[�{����] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_recua_2] ON [dbo].[recua]
([�t�ӽs��] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_recua_3] ON [dbo].[recua]
([�I���帹] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
ALTER TABLE [dbo].[recua] ADD  CONSTRAINT [DF_recua_�I���ƶq]  DEFAULT ((0)) FOR [�I���ƶq]
ALTER TABLE [dbo].[recua] ADD  CONSTRAINT [DF_recua_�־P�ƶq]  DEFAULT ((0)) FOR [�־P�ƶq]
ALTER TABLE [dbo].[recua] ADD  CONSTRAINT [DF_recua_��s���]  DEFAULT (getdate()) FOR [��s���]
CREATE INDEX recua_IDX_PUDU_SEQ ON recua(PUDU_SEQ);
GO


INSERT INTO Dc2..recua
SELECT [�Ǹ�], 
CASE (SELECT COUNT(1) FROM Bc2..pudu P WHERE P.���ʳ渹 = R.���ʳ渹 AND P.�˫~���X = R.�˫~���X AND P.[�[�{����] = R.[�[�{����]) WHEN 1 
	 THEN (SELECT TOP 1 [�Ǹ�] FROM Bc2..pudu P WHERE P.���ʳ渹 = R.���ʳ渹 AND P.�˫~���X = R.�˫~���X AND P.[�[�{����] = R.[�[�{����])
	 ELSE 0 END [PUDU_SEQ],
RTRIM([�I���帹]), RTRIM([���ʳ渹]), RTRIM([�˫~���X]), RTRIM([�t�ӽs��]), RTRIM([�t��²��]), RTRIM([�[�{����]), RTRIM([�Ȯɫ���]), RTRIM([�t�ӫ���]), RTRIM([���]), 
[�I�����], [�I���ƶq], [�־P�ƶq], RTRIM([�B��s��]), RTRIM([�B��²��]), RTRIM([�B�e�覡]), [�ܧ���], RTRIM([��s�H��]), [��s���]
FROM Bc2..recua R

/*
SELECT 
(SELECT COUNT(1) FROM pudu P WHERE P.���ʳ渹 = R.���ʳ渹 AND P.�˫~���X = R.�˫~���X AND P.[�[�{����] = R.[�[�{����]) C,
(SELECT CAST([�Ǹ�] AS VARCHAR(MAX)) + ',' FROM pudu P WHERE P.���ʳ渹 = R.���ʳ渹 AND P.�˫~���X = R.�˫~���X AND P.[�[�{����] = R.[�[�{����] FOR XML PATH('')) SEQ, *
FROM recu R
order by 1 desc

SELECT * FROM pudu WHERE �Ǹ� IN ('67384','67406')
SELECT * FROM recu WHERE �Ǹ�  = '57901'
*/