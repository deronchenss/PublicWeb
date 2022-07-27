USE Dc2
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[nofile]') AND type in (N'U'))
DROP TABLE [dbo].[nofile]
GO
CREATE TABLE [dbo].[nofile](
	[序號] [int] NOT NULL,
	[單據] [varchar](20) NULL,
	[字頭] [varchar](10) NULL,
	[年度] [varchar](2) NULL,
	[月份] [varchar](1) NULL,
	[號碼] [varchar](10) NULL,
	[字尾] [varchar](2) NULL,
	[號碼長度] [varchar](10) NULL,
	[使用者] [varchar](6) NULL,
	[變更日期] [datetime] NULL,
	[更新人員] [varchar](6) NULL,
	[更新日期] [datetime] NULL,
 CONSTRAINT [PK_nofile] PRIMARY KEY CLUSTERED 
(
	[序號] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[nofile] ADD  CONSTRAINT [DF_nofile_更新日期]  DEFAULT (getdate()) FOR [更新日期]
GO
INSERT INTO Dc2..nofile
SELECT [序號], RTRIM([單據]),  RTRIM([字頭]),  RTRIM([年度]),  RTRIM([月份]),  RTRIM([號碼]),  RTRIM([字尾]),  RTRIM([號碼長度]), RTRIM([使用者]), [變更日期], RTRIM([更新人員]), [更新日期]
FROM Bc2..nofile;

