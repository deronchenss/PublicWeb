USE [Dc2]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[bank]') AND type in (N'U'))
DROP TABLE [dbo].[bank]
GO

CREATE TABLE [dbo].[bank](
	[�Ǹ�] [int] NOT NULL,
	[�Ȧ�s��] [char](2) NULL,
	[�Ȧ�²��] [varchar](8) NULL,
	[�b�����e] [varchar](240) NULL,
	[�a��] [char](4) NULL,
	[�ϥΰϤ�] [varchar](50) NULL,
	[�ܧ���] [smalldatetime] NULL,
	[�إߤH��] [char](6) NULL,
	[�إߤ��] [smalldatetime] NULL,
	[��s�H��] [char](6) NULL,
	[��s���] [smalldatetime] NULL,
 CONSTRAINT [PK_bank] PRIMARY KEY CLUSTERED 
(
	[�Ǹ�] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[bank] ADD  CONSTRAINT [DF_bank_��s���]  DEFAULT (getdate()) FOR [��s���]
GO


