USE [Dc2]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ord]') AND type in (N'U'))
DROP TABLE [dbo].[ord]
GO

CREATE TABLE [dbo].[ord](
	[序號] [int] NOT NULL,
	[SUPLU_SEQ] [int] NULL,
	[訂單號碼] [varchar](20) NULL,
	[客戶編號] [varchar](8) NULL,
	[客戶簡稱] [varchar](10) NULL,
	[接單日期] [datetime] NULL,
	[美元匯率] [decimal](6, 3) NULL,
	[歐元匯率] [decimal](6, 3) NULL,
	[外幣匯率] [decimal](6, 3) NULL,
	[客戶型號] [varchar](15) NULL,
	[頤坊型號] [varchar](15) NULL,
	[產品說明] [varchar](80) NULL,
	[單位] [varchar](6) NULL,
	[price數量] [decimal](9, 2) NULL,
	[訂單數量] [decimal](9, 2) NULL,
	[原訂單數量] [decimal](9, 2) NULL,
	[取消數量] [decimal](9, 2) NULL,
	[美元單價] [decimal](9, 3) NULL,
	[台幣單價] [decimal](9, 2) NULL,
	[歐元單價] [decimal](9, 2) NULL,
	[外幣幣別] [varchar](3) NULL,
	[外幣單價] [decimal](9, 3) NULL,
	[條碼] [bit] NULL,
	[廠商編號] [varchar](8) NULL,
	[廠商簡稱] [varchar](10) NULL,
	[產品說明ch] [varchar](40) NULL,
	[單位ch] [varchar](6) NULL,
	[COST_NTD] [decimal](9, 2) NULL,
	[COST_USD] [decimal](9, 3) NULL,
	[COST_RMB] [decimal](9, 2) NULL,
	[毛利率] [decimal](7, 2) NULL,
	[組合品] [bit] NULL,
	[準備數量] [decimal](9, 2) NULL,
	[備貨數量] [decimal](9, 2) NULL,
	[出貨數量] [decimal](9, 2) NULL,
	[帳務分類] [varchar](1) NULL,
	[出貨地] [varchar](1) NULL,
	[FREE] [bit] NULL,
	[PI交期D] [datetime] NULL,
	[交期狀況D] [varchar](30) NULL,
	[客戶交期] [datetime] NULL,
	[TOP300] [bit] NULL,
	[商標] [varchar](6) NULL,
	[商標2] [varchar](6) NULL,
	[條碼ivan_Del] [varchar](1) NULL,
	[出貨變更] [varchar](40) NULL,
	[備註] [varchar](30) NULL,
	[轉採購] [bit] NULL,
	[結案] [bit] NULL,
	[變更日期] [datetime] NULL,
	[更新人員] [varchar](6) NULL,
	[更新日期] [datetime] NULL,
 CONSTRAINT [PK_ord] PRIMARY KEY CLUSTERED 
(
	[序號] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ord] ADD  CONSTRAINT [DF_ord_美元匯率]  DEFAULT ((0)) FOR [美元匯率]
GO

ALTER TABLE [dbo].[ord] ADD  CONSTRAINT [DF_ord_外幣匯率]  DEFAULT ((0)) FOR [外幣匯率]
GO

ALTER TABLE [dbo].[ord] ADD  CONSTRAINT [DF_ord_price數量]  DEFAULT ((0)) FOR [price數量]
GO

ALTER TABLE [dbo].[ord] ADD  CONSTRAINT [DF_ord_訂單數量]  DEFAULT ((0)) FOR [訂單數量]
GO

ALTER TABLE [dbo].[ord] ADD  CONSTRAINT [DF_ord_原訂單數量]  DEFAULT ((0)) FOR [原訂單數量]
GO

ALTER TABLE [dbo].[ord] ADD  CONSTRAINT [DF_ord_美元單價]  DEFAULT ((0)) FOR [美元單價]
GO

ALTER TABLE [dbo].[ord] ADD  CONSTRAINT [DF_ord_台幣單價]  DEFAULT ((0)) FOR [台幣單價]
GO

ALTER TABLE [dbo].[ord] ADD  CONSTRAINT [DF_ord_歐元單價]  DEFAULT ((0)) FOR [歐元單價]
GO

ALTER TABLE [dbo].[ord] ADD  CONSTRAINT [DF_ord_外幣單價]  DEFAULT ((0)) FOR [外幣單價]
GO

ALTER TABLE [dbo].[ord] ADD  CONSTRAINT [DF_ord_COST_NTD]  DEFAULT ((0)) FOR [COST_NTD]
GO

ALTER TABLE [dbo].[ord] ADD  CONSTRAINT [DF_ord_COST_USD]  DEFAULT ((0)) FOR [COST_USD]
GO

ALTER TABLE [dbo].[ord] ADD  CONSTRAINT [DF_ord_COST_RMB]  DEFAULT ((0)) FOR [COST_RMB]
GO

ALTER TABLE [dbo].[ord] ADD  CONSTRAINT [DF_ord_毛利率]  DEFAULT ((0)) FOR [毛利率]
GO

ALTER TABLE [dbo].[ord] ADD  CONSTRAINT [DF_ord_準備數量]  DEFAULT ((0)) FOR [準備數量]
GO

ALTER TABLE [dbo].[ord] ADD  CONSTRAINT [DF_ord_備貨數量]  DEFAULT ((0)) FOR [備貨數量]
GO

ALTER TABLE [dbo].[ord] ADD  CONSTRAINT [DF_ord_出貨數量]  DEFAULT ((0)) FOR [出貨數量]
GO

ALTER TABLE [dbo].[ord] ADD  CONSTRAINT [DF_ord_更新日期]  DEFAULT (getdate()) FOR [更新日期]
GO




INSERT INTO Dc2..ord
SELECT [序號]
	  ,(SELECT [序號] FROM Bc2..suplu2 C WHERE C.廠商編號 = ord.廠商編號 AND C.頤坊型號 = ord.頤坊型號) [SUPLU_SEQ]
      ,RTRIM([訂單號碼])
      ,RTRIM([客戶編號])
      ,RTRIM([客戶簡稱])
      ,[接單日期]
      ,[美元匯率]
      ,[歐元匯率]
      ,[外幣匯率]
      ,RTRIM([客戶型號])
      ,RTRIM([頤坊型號])
      ,RTRIM([產品說明])
      ,RTRIM([單位])
      ,[price數量]
      ,[訂單數量]
      ,[原訂單數量]
      ,[取消數量]
      ,[美元單價]
      ,[台幣單價]
      ,[歐元單價]
      ,RTRIM([外幣幣別])
      ,[外幣單價]
      ,[條碼]
      ,RTRIM([廠商編號])
      ,RTRIM([廠商簡稱])
      ,RTRIM([產品說明ch])
      ,RTRIM([單位ch])
      ,[COST_NTD]
      ,[COST_USD]
      ,[COST_RMB]
      ,[毛利率]
      ,[組合品]
      ,[準備數量]
      ,[備貨數量]
      ,[出貨數量]
      ,RTRIM([帳務分類])
      ,RTRIM([出貨地])
      ,[FREE]
      ,[PI交期D]
      ,RTRIM([交期狀況D])
      ,[客戶交期]
      ,[TOP300]
      ,RTRIM([商標])
      ,RTRIM([商標2])
      ,RTRIM([條碼ivan_Del])
      ,RTRIM([出貨變更])
      ,RTRIM([備註])
      ,[轉採購]
      ,[結案]
      ,[變更日期]
      ,RTRIM([更新人員])
      ,[更新日期]
FROM Bc2..ord;
