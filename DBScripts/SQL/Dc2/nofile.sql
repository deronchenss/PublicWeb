USE Dc2
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[nofile]') AND type in (N'U'))
DROP TABLE [dbo].[nofile]
GO
CREATE TABLE [dbo].[nofile](
	[�Ǹ�] [int] NOT NULL,
	[���] [varchar](20) NULL,
	[�r�Y] [varchar](10) NULL,
	[�~��] [varchar](2) NULL,
	[���] [varchar](1) NULL,
	[���X] [varchar](10) NULL,
	[�r��] [varchar](2) NULL,
	[���X����] [varchar](10) NULL,
	[�ϥΪ�] [varchar](6) NULL,
	[�ܧ���] [datetime] NULL,
	[��s�H��] [varchar](6) NULL,
	[��s���] [datetime] NULL,
 CONSTRAINT [PK_nofile] PRIMARY KEY CLUSTERED 
(
	[�Ǹ�] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[nofile] ADD  CONSTRAINT [DF_nofile_��s���]  DEFAULT (getdate()) FOR [��s���]
GO
INSERT INTO Dc2..nofile
SELECT [�Ǹ�], RTRIM([���]),  RTRIM([�r�Y]),  RTRIM([�~��]),  RTRIM([���]),  RTRIM([���X]),  RTRIM([�r��]),  RTRIM([���X����]), RTRIM([�ϥΪ�]), [�ܧ���], RTRIM([��s�H��]), [��s���]
FROM Bc2..nofile;

