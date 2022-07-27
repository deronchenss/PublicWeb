USE [Dc2]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[paku2]') AND type in (N'U'))
DROP TABLE [dbo].[paku2]
GO
CREATE TABLE [dbo].[paku2](
	[�Ǹ�] [int] NOT NULL,
	[SUPLU_SEQ] [int] NULL,
	[�Ƴf���] [datetime] NULL,
	[�Ȥ�s��] [varchar](8) NULL,
	[�Ȥ�²��] [varchar](10) NULL,
	[�[�{����] [varchar](15) NULL,
	[�Ȯɫ���] [varchar](15) NULL,
	[���~����] [varchar](80) NULL,
	[���] [varchar](6) NULL,
	[�Ƴf�ƶq] [decimal](9, 3) NULL,
	[�־P�ƶq] [decimal](9, 3) NULL,
	[�t�ӽs��] [varchar](8) NULL,
	[�t��²��] [varchar](10) NULL,
	[�ӷ�] [varchar](6) NULL,
	[�I���帹] [varchar](9) NULL,
	[�w�R��] [bit] NULL,
	[�ܧ���] [datetime] NULL,
	[��s�H��] [varchar](6) NULL,
	[��s���] [datetime] NULL,
 CONSTRAINT [PK_paku2] PRIMARY KEY CLUSTERED 
(
	[�Ǹ�] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[paku2] ADD CONSTRAINT [DF_paku2_��s���]  DEFAULT (getdate()) FOR [��s���]
GO

INSERT INTO Dc2..[paku2]
SELECT [�Ǹ�], (SELECT [�Ǹ�] FROM Bc2..suplu2 C WHERE C.�t�ӽs�� = P.�t�ӽs�� AND C.�[�{���� = P.�[�{����) [SUPLU_SEQ], [�Ƴf���],
	RTRIM([�Ȥ�s��]), RTRIM([�Ȥ�²��]), RTRIM([�[�{����]), 
	RTRIM([�Ȯɫ���]), RTRIM([���~����]), RTRIM([���]),
	[�Ƴf�ƶq], [�־P�ƶq], RTRIM([�t�ӽs��]),
	RTRIM([�t��²��]), RTRIM([�ӷ�]), RTRIM([�I���帹]),
	[�w�R��], [�ܧ���], RTRIM([��s�H��]), [��s���]
FROM Bc2..[paku2] P


