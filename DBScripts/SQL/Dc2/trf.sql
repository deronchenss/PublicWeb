USE [Dc2]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[trf]') AND type in (N'U'))
DROP TABLE [dbo].[trf]
GO

CREATE TABLE [dbo].[trf](
	[序號] [int] NOT NULL,
	[運輸編號] [char](4) NULL,
	[運輸簡稱] [varchar](20) NULL,
	[運輸名稱] [varchar](50) NULL,
	[英文名稱] [varchar](50) NULL,
	[運輸區分] [varchar](40) NULL,
	[核准交易] [bit] NULL,
	[連絡地址] [varchar](50) NULL,
	[所在地] [char](4) NULL,
	[幣別] [char](3) NULL,
	[連絡人] [varchar](30) NULL,
	[電話] [varchar](20) NULL,
	[傳真] [varchar](20) NULL,
	[行動電話] [varchar](20) NULL,
	[統一編號] [char](8) NULL,
	[email] [varchar](35) NULL,
	[Skype] [varchar](20) NULL,
	[網站] [varchar](50) NULL,
	[出口帳號] [varchar](14) NULL,
	[往來客戶] [varchar](160) NULL,
	[最後交易日] [smalldatetime] NULL,
	[燃油稅] [decimal](5, 2) NULL,
	[材積除數] [int] NULL,
	[停用日期] [smalldatetime] NULL,
	[備註] [varchar](512) NULL,
	[變更日期] [smalldatetime] NULL,
	[建立人員] [char](6) NULL,
	[建立日期] [smalldatetime] NULL,
	[更新人員] [char](6) NULL,
	[更新日期] [smalldatetime] NULL,
 CONSTRAINT [PK_trf] PRIMARY KEY CLUSTERED 
(
	[序號] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[trf] ADD  CONSTRAINT [DF_trf_更新日期]  DEFAULT (getdate()) FOR [更新日期]
GO


