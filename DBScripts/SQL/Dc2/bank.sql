USE [Dc2]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[bank]') AND type in (N'U'))
DROP TABLE [dbo].[bank]
GO

CREATE TABLE [dbo].[bank](
	[序號] [int] NOT NULL,
	[銀行編號] [char](2) NULL,
	[銀行簡稱] [varchar](8) NULL,
	[帳號內容] [varchar](240) NULL,
	[地區] [char](4) NULL,
	[使用區分] [varchar](50) NULL,
	[變更日期] [smalldatetime] NULL,
	[建立人員] [char](6) NULL,
	[建立日期] [smalldatetime] NULL,
	[更新人員] [char](6) NULL,
	[更新日期] [smalldatetime] NULL,
 CONSTRAINT [PK_bank] PRIMARY KEY CLUSTERED 
(
	[序號] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[bank] ADD  CONSTRAINT [DF_bank_更新日期]  DEFAULT (getdate()) FOR [更新日期]
GO


