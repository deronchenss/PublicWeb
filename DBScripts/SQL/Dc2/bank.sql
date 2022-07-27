USE [Dc2]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[bank]') AND type in (N'U'))
DROP TABLE [dbo].[bank]
GO

CREATE TABLE [dbo].[bank](
	[�Ǹ�] [int] NOT NULL,
	[�Ȧ�s��] [varchar](2) NULL,
	[�Ȧ�²��] [varchar](8) NULL,
	[�b�����e] [varchar](240) NULL,
	[�a��] [varchar](4) NULL,
	[�ϥΰϤ�] [varchar](50) NULL,
	[�ܧ���] [datetime] NULL,
	[�إߤH��] [varchar](20) NULL,
	[�إߤ��] [datetime] NULL,
	[��s�H��] [varchar](20) NULL,
	[��s���] [datetime] NULL,
 CONSTRAINT [PK_bank] PRIMARY KEY CLUSTERED 
(
	[�Ǹ�] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[bank] ADD  CONSTRAINT [DF_bank_��s���]  DEFAULT (getdate()) FOR [��s���]
GO

INSERT INTO Dc2..bank
SELECT  [�Ǹ�], RTRIM([�Ȧ�s��]), RTRIM([�Ȧ�²��]), RTRIM([�b�����e]), RTRIM([�a��]), RTRIM([�ϥΰϤ�]), [�ܧ���],
	RTRIM([��s�H��]) [�إߤH��], [��s���] [�إߤ��], RTRIM([��s�H��]), [��s���]
FROM Bc2..bank;
