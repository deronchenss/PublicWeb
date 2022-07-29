USE [Dc2]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DisCount_EAN]') AND type in (N'U'))
DROP TABLE [dbo].[DisCount_EAN]
GO
CREATE TABLE [dbo].[DisCount_EAN](--���~���O-MSRP�馩�v
	[�Ǹ�] [int] NOT NULL,
	[����] [varchar](2) NULL,
	[�ƦC] [int] NULL,
	[�����N�X] [varchar](2) NULL,
	[����@��] [varchar](22) NULL,
	[����G��] [varchar](8) NULL,
	[���满��] [varchar](55) NULL,
	[���浥��] [varchar](3) NULL,
	[�����s��] [varchar](5) NULL,
	[CP65] [varchar](2) NULL,
	[�~��] [varchar](2) NULL,
	[�馩�vC2] [int] NULL,
	[�馩�vC3] [int] NULL,
	[�馩�vC5] [int] NULL,
	[�馩�vC6] [int] NULL,
	[�馩�vC7] [int] NULL,
	[�馩�vB2] [int] NULL,
	[�馩�vB5] [int] NULL,
	[�馩�vB6] [int] NULL,
	[�馩�vB7] [int] NULL,
	[�馩�v2] [int] NULL,
	[�馩�v3] [int] NULL,
	[�馩�v4] [int] NULL,
	[�馩�v5] [int] NULL,
	[�馩�v6] [int] NULL,
	[�馩�v7] [int] NULL,
	[�馩�v8] [int] NULL,
	[�馩�v9] [int] NULL,
	[���Τ��] [datetime] NULL,
	[�ܧ���] [datetime] NULL,
	[�إߤH��] [varchar](20) NULL,
	[�إߤ��] [datetime] NULL,
	[��s�H��] [varchar](20) NULL,
	[��s���] [datetime] NULL,
 CONSTRAINT [PK_DisCount_EAN] PRIMARY KEY CLUSTERED 
([�Ǹ�] ASC )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DisCount_EAN] ADD  CONSTRAINT [DF_DisCount_EAN_��s���]  DEFAULT (getdate()) FOR [��s���]
CREATE INDEX DisCount_EAN_IDX_CLASS ON [DisCount_EAN]([�����N�X])
GO

INSERT INTO Dc2..[DisCount_EAN] 
SELECT [�Ǹ�], RTRIM([����]),
[�ƦC], RTRIM([�����N�X]), RTRIM([����@��]), RTRIM([����G��]),RTRIM([���满��]), RTRIM([���浥��]), RTRIM([�����s��]), RTRIM([CP65]), RTRIM([�~��]),
[�馩�vC2], [�馩�vC3], [�馩�vC5], [�馩�vC6], [�馩�vC7], [�馩�vB2], [�馩�vB5], [�馩�vB6], [�馩�vB7],
[�馩�v2], [�馩�v3], [�馩�v4], [�馩�v5], [�馩�v6], [�馩�v7], [�馩�v8], [�馩�v9], [���Τ��], [�ܧ���],
RTRIM([��s�H��]) [�إߤH��], [��s���] [�إߤ��], RTRIM([��s�H��]), [��s���]
FROM Bc2..DisCount_EAN DE
WHERE ���� IN ('C3','V3')

