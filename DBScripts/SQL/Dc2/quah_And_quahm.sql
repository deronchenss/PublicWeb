USE [Dc2]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[quah]') AND type in (N'U'))
DROP TABLE [dbo].[quah]
GO

CREATE TABLE [dbo].[quah](
	[�Ǹ�] [int] NOT NULL,
	[BYRLU_SEQ] [INT] NULL,
	[�����渹] [varchar](8) NULL,
	[�������] [datetime] NULL,
	[�Ȥ�s��] [varchar](8) NULL,
	[�Ȥ�²��] [varchar](10) NULL,
	[�[�{����] [varchar](15) NULL,
	[���~����] [varchar](360) NULL,
	[���] [varchar](6) NULL,
	[�������] [decimal](9, 3) NULL,
	[�x�����] [decimal](9, 2) NULL,
	--[�ڤ����] [decimal](9, 2) NULL,
	[���_2] [decimal](9, 3) NULL,
	[���_3] [decimal](9, 3) NULL,
	[���_4] [decimal](9, 3) NULL,
	[min_1] [int] NULL,
	[min_2] [int] NULL,
	[min_3] [int] NULL,
	[min_4] [int] NULL,
	--[�~�����O] [varchar](3) NULL,
	--[�~�����] [decimal](9, 3) NULL,
	[S_FROM] [varchar](1) NULL,
	[�t�ӽs��] [varchar](8) NULL,
	[�t��²��] [varchar](10) NULL,
	[�ܧ���] [datetime] NULL,
	[��s�H��] [varchar](6) NULL,
	[��s���] [datetime] NULL,
 CONSTRAINT [PK_quah] PRIMARY KEY CLUSTERED 
([�Ǹ�] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE INDEX quah_IDX_BYRLU_SEQ ON quah(BYRLU_SEQ);

ALTER TABLE [dbo].[quah] ADD  CONSTRAINT [DF_quah_�������]  DEFAULT ((0)) FOR [�������]
ALTER TABLE [dbo].[quah] ADD  CONSTRAINT [DF_quah_�x�����]  DEFAULT ((0)) FOR [�x�����]
--ALTER TABLE [dbo].[quah] ADD  CONSTRAINT [DF_quah_�ڤ����]  DEFAULT ((0)) FOR [�ڤ����]
--ALTER TABLE [dbo].[quah] ADD  CONSTRAINT [DF_quah_�~�����]  DEFAULT ((0)) FOR [�~�����]
ALTER TABLE [dbo].[quah] ADD  CONSTRAINT [DF_quah_��s���]  DEFAULT (getdate()) FOR [��s���]

INSERT INTO Dc2..quah
SELECT [�Ǹ�],  
	(SELECT MAX(p.�Ǹ�) FROM Bc2..byrlu p WHERE q.�Ȥ�s�� = p.�Ȥ�s�� AND q.�[�{���� = p.�[�{���� AND q.�t�ӽs�� = p.�t�ӽs��) [BYRLU_SEQ], 
	[�����渹], [�������], RTRIM([�Ȥ�s��]), RTRIM([�Ȥ�²��]), RTRIM([�[�{����]), RTRIM([���~����]), RTRIM([���]), 
	[�������], [�x�����], [���_2], [���_3], [���_4], [min_1], [min_2], [min_3], [min_4], RTRIM([S_FROM]), RTRIM([�t�ӽs��]), RTRIM([�t��²��]), [�ܧ���],RTRIM([��s�H��]), [��s���]
FROM Bc2..quah q

/*
SELECT * 
FROM Bc2..quah q
	LEFT JOIN Bc2..byrlu p on q.�Ȥ�s�� = p.�Ȥ�s�� AND q.�[�{���� = p.�[�{����	
WHERE p.�Ǹ� IS NULL


SELECT 	(SELECT CAST(�Ǹ� AS VARCHAR(10)) + ',' FROM Bc2..byrlu p WHERE q.�Ȥ�s�� = p.�Ȥ�s�� AND q.�[�{���� = p.�[�{���� AND q.�t�ӽs�� = p.�t�ӽs�� FOR XML PATH('')) [BYRLU_SEQ], 
(SELECT COUNT(1) FROM Bc2..byrlu p WHERE q.�Ȥ�s�� = p.�Ȥ�s�� AND q.�[�{���� = p.�[�{���� AND q.�t�ӽs�� = p.�t�ӽs��) [CT], *
FROM Bc2..quah q
WHERE (SELECT COUNT(1) FROM Bc2..byrlu p WHERE q.�Ȥ�s�� = p.�Ȥ�s�� AND q.�[�{���� = p.�[�{���� AND q.�t�ӽs�� = p.�t�ӽs��) > 1
order by 2 desc

SELECT * FROM bc2..byrlu WHERE �Ǹ� IN ('126989','220303')
SELECT * FROM dc2..byrlu WHERE �Ǹ� IN ('126989','220303')
*/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[quahm]') AND type in (N'U'))
DROP TABLE [dbo].[quahm]
GO

CREATE TABLE [dbo].[quahm](
	[�Ǹ�] [int] NOT NULL,
	[�����渹] [varchar](8) NULL,
	[�j�Ƶ�] [nvarchar](1024) NULL,
	[�ܧ���] [datetime] NULL,
	[��s�H��] [varchar](6) NULL,
	[��s���] [datetime] NULL,
 CONSTRAINT [PK_quahm] PRIMARY KEY CLUSTERED 
([�Ǹ�] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
ALTER TABLE [dbo].[quahm] ADD  CONSTRAINT [DF_quahm_��s���]  DEFAULT (getdate()) FOR [��s���]
GO

INSERT INTO Dc2..quahm
SELECT * FROM Bc2..quahm


