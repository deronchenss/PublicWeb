USE [Dc2]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[orm_RT]') AND type in (N'U'))
DROP TABLE [dbo].[orm_RT]
GO

CREATE TABLE [dbo].[orm_RT](
	[序號] [int] NOT NULL,
	[訂單號碼] [varchar](20) NULL,
	[報價] [bit] NULL,
	[客戶編號] [varchar](8) NULL,
	[客戶簡稱] [varchar](20) NULL,
	[接單日期] [datetime] NULL,
	[客戶等級] [varchar](1) NULL,
	[網購庫取] [datetime] NULL,
	[收款方式] [varchar](8) NULL,
	[便利箱] [varchar](4) NULL,
	[毛重] [decimal](5, 2) NULL,
	[箱數] [smallint] NULL,
	[應收金額] [int] NULL,
	[運費應收] [int] NULL,
	[運費實收] [int] NULL,
	[運費實付] [int] NULL,
	[已收金額] [decimal](8, 2) NULL,
	[已收日期] [datetime] NULL,
	[寄送日期] [datetime] NULL,
	[寄送人員] [varchar](6) NULL,
	[運輸編號] [varchar](4) NULL,
	[運輸簡稱] [varchar](20) NULL,
	[提單號碼] [varchar](15) NULL,
	[發票格式] [varchar](6) NULL,
	[發票號碼] [varchar](12) NULL,
	[特別事項] [varchar](1024) NULL,
	[報價單備註] [varchar](512) NULL,
	[出貨核准] [bit] NULL,
	[核准日期] [datetime] NULL,
	[核准人員] [varchar](6) NULL,
	[美元匯率] [decimal](6, 3) NULL,
	[歐元匯率] [decimal](6, 3) NULL,
	[人民幣匯率] [decimal](6, 3) NULL,
	[變更日期] [datetime] NULL,
	[更新人員] [varchar](6) NULL,
	[更新日期] [datetime] NULL,
 CONSTRAINT [PK_orm_RT] PRIMARY KEY CLUSTERED 
(
	[序號] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[orm_RT] ADD  CONSTRAINT [DF_orm_RT_更新日期]  DEFAULT (getdate()) FOR [更新日期]
GO

INSERT INTO Dc2..orm_RT
SELECT [序號]
      ,RTRIM([訂單號碼])
      ,[報價]
      ,RTRIM([客戶編號])
      ,RTRIM([客戶簡稱])
      ,[接單日期]
      ,RTRIM([客戶等級])
      ,[網購庫取]
      ,RTRIM([收款方式])
      ,RTRIM([便利箱])
      ,[毛重]
      ,[箱數]
      ,[應收金額]
      ,[運費應收]
      ,[運費實收]
      ,[運費實付]
      ,[已收金額]
      ,[已收日期]
      ,[寄送日期]
      ,RTRIM([寄送人員])
      ,RTRIM([運輸編號])
      ,RTRIM([運輸簡稱])
      ,RTRIM([提單號碼])
      ,RTRIM([發票格式])
      ,RTRIM([發票號碼])
      ,RTRIM([特別事項])
      ,RTRIM([報價單備註])
      ,[出貨核准]
      ,[核准日期]
      ,RTRIM([核准人員])
      ,[美元匯率]
      ,[歐元匯率]
      ,[人民幣匯率]
      ,[變更日期]
      ,RTRIM([更新人員])
      ,[更新日期]
FROM Bc2..orm_RT;
