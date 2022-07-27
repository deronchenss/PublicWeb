USE [Dc2]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[trf]') AND type in (N'U'))
DROP TABLE [dbo].[trf]
GO

CREATE TABLE [dbo].[trf](
	[序號] [int] NOT NULL,
	[運輸編號] [varchar](4) NULL,
	[運輸簡稱] [varchar](20) NULL,
	[運輸名稱] [varchar](50) NULL,
	[英文名稱] [varchar](50) NULL,
	[運輸區分] [varchar](40) NULL,
	[核准交易] [bit] NULL,
	[連絡地址] [varchar](50) NULL,
	[所在地] [varchar](4) NULL,
	[幣別] [varchar](3) NULL,
	[連絡人] [varchar](30) NULL,
	[電話] [varchar](20) NULL,
	[傳真] [varchar](20) NULL,
	[行動電話] [varchar](20) NULL,
	[統一編號] [varchar](8) NULL,
	[email] [varchar](35) NULL,
	[Skype] [varchar](20) NULL,
	[網站] [varchar](50) NULL,
	[出口帳號] [varchar](14) NULL,
	[往來客戶] [varchar](160) NULL,
	[最後交易日] [datetime] NULL,
	[燃油稅] [decimal](5, 2) NULL,
	[材積除數] [int] NULL,
	[停用日期] [datetime] NULL,
	[備註] [varchar](512) NULL,
	[變更日期] [datetime] NULL,
	[建立人員] [varchar](6) NULL,
	[建立日期] [datetime] NULL,
	[更新人員] [varchar](6) NULL,
	[更新日期] [datetime] NULL,
 CONSTRAINT [PK_trf] PRIMARY KEY CLUSTERED 
(
	[序號] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[trf] ADD  CONSTRAINT [DF_trf_更新日期]  DEFAULT (getdate()) FOR [更新日期]
GO

INSERT INTO Dc2..trf
SELECT [序號], RTRIM([運輸編號]), RTRIM([運輸簡稱]), RTRIM([運輸名稱]), RTRIM([英文名稱]),
	RTRIM([運輸區分]), [核准交易], RTRIM([連絡地址]), RTRIM([所在地]), RTRIM([幣別]), RTRIM([連絡人]), RTRIM([電話]),
	RTRIM([傳真]), RTRIM([行動電話]), RTRIM([統一編號]), RTRIM([email]), RTRIM([Skype]), RTRIM([網站]),
	RTRIM([出口帳號]), RTRIM([往來客戶]), [最後交易日], [燃油稅], [材積除數], [停用日期], RTRIM([備註]), [變更日期],
	RTRIM([更新人員]) [建立人員], [更新日期] [建立日期], RTRIM([更新人員]), [更新日期]
FROM Bc2..trf;
