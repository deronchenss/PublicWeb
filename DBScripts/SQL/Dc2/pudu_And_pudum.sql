USE [Dc2]
GO

--DROP INDEX [IX_pudu_2] ON [dbo].[pudu]
--DROP INDEX [IX_pudu_1] ON [dbo].[pudu]
--DROP INDEX [IX_pudu] ON [dbo].[pudu]
--GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pudu]') AND type in (N'U'))
DROP TABLE [dbo].[pudu]
GO
CREATE TABLE [dbo].[pudu](
	[序號] [int] NOT NULL,
	[SUPLU_SEQ] [int] NULL,
	[採購單號] [varchar](9) NULL,
	[採購日期] [datetime] NULL,
	[樣品號碼] [varchar](18) NULL,
	[工作類別] [varchar](4) NULL,
	[廠商編號] [varchar](8) NULL,
	[廠商簡稱] [varchar](10) NULL,
	[頤坊型號] [varchar](15) NULL,
	[暫時型號] [varchar](15) NULL,
	[廠商型號] [varchar](19) NULL,
	[產品說明] [varchar](360) NULL,
	[單位] [varchar](6) NULL,
	[台幣單價] [decimal](9, 2) NULL,
	[美元單價] [decimal](9, 3) NULL,
	[人民幣單價] [decimal](9, 2) NULL,
	[單價_2] [decimal](9, 3) NULL,
	[單價_3] [decimal](9, 3) NULL,
	[MIN_1] [int] NULL,
	[MIN_2] [int] NULL,
	[MIN_3] [int] NULL,
	[外幣幣別] [varchar](3) NULL,
	[外幣單價] [decimal](9, 2) NULL,
	[外幣單價_2] [decimal](9, 2) NULL,
	[外幣單價_3] [decimal](9, 2) NULL,
	[採購數量] [decimal](9, 3) NULL,
	[採購交期] [datetime] NULL,
	[交期狀況] [varchar](30) NULL,
--	[點收批號] [varchar](9) NULL,
--	[點收數量] [decimal](9, 3) NULL,
--	[點收日期] [datetime] NULL,
--	[到貨數量] [decimal](9, 3) NULL,
--	[出貨日期] [datetime] NULL,
--	[到貨日期] [datetime] NULL,
--	[運輸編號] [varchar](8) NULL,
--	[運輸簡稱] [varchar](20) NULL,
	[訂單數量] [decimal](9, 3) NULL,
	[客戶編號] [varchar](8) NULL,
	[客戶簡稱] [varchar](10) NULL,
	[到貨處理] [varchar](255) NULL,
	[列表小備註] [varchar](50) NULL,
	[結案] [bit] NULL,
	[強制結案] [bit] NULL,
	[運送方式] [varchar](18) NULL,
	[部門] [varchar](2) NULL,
	[變更日期] [datetime] NULL,
	[更新人員] [varchar](6) NULL,
	[更新日期] [datetime] NULL,
 CONSTRAINT [PK_pudu] PRIMARY KEY CLUSTERED 
([序號] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_pudu] ON [dbo].[pudu]
([更新日期] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_pudu_1] ON [dbo].[pudu]
([採購單號] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_pudu_2] ON [dbo].[pudu]
([採購日期] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[pudu] ADD  CONSTRAINT [DF_pudu_台幣單價]  DEFAULT ((0)) FOR [台幣單價]
ALTER TABLE [dbo].[pudu] ADD  CONSTRAINT [DF_pudu_美元單價]  DEFAULT ((0)) FOR [美元單價]
ALTER TABLE [dbo].[pudu] ADD  CONSTRAINT [DF_pudu_人民幣單價]  DEFAULT ((0)) FOR [人民幣單價]
ALTER TABLE [dbo].[pudu] ADD  CONSTRAINT [DF_pudu_單價_2]  DEFAULT ((0)) FOR [單價_2]
ALTER TABLE [dbo].[pudu] ADD  CONSTRAINT [DF_pudu_單價_3]  DEFAULT ((0)) FOR [單價_3]
ALTER TABLE [dbo].[pudu] ADD  CONSTRAINT [DF_pudu_MIN_1]  DEFAULT ((0)) FOR [MIN_1]
ALTER TABLE [dbo].[pudu] ADD  CONSTRAINT [DF_pudu_MIN_2]  DEFAULT ((0)) FOR [MIN_2]
ALTER TABLE [dbo].[pudu] ADD  CONSTRAINT [DF_pudu_MIN_3]  DEFAULT ((0)) FOR [MIN_3]
ALTER TABLE [dbo].[pudu] ADD  CONSTRAINT [DF_pudu_採購數量]  DEFAULT ((0)) FOR [採購數量]
--ALTER TABLE [dbo].[pudu] ADD  CONSTRAINT [DF_pudu_點收數量]  DEFAULT ((0)) FOR [點收數量]
--ALTER TABLE [dbo].[pudu] ADD  CONSTRAINT [DF_pudu_到貨數量]  DEFAULT ((0)) FOR [到貨數量]
ALTER TABLE [dbo].[pudu] ADD  CONSTRAINT [DF_pudu_訂單數量]  DEFAULT ((0)) FOR [訂單數量]
ALTER TABLE [dbo].[pudu] ADD  CONSTRAINT [DF_pudu_更新日期]  DEFAULT (getdate()) FOR [更新日期]
GO


INSERT INTO Dc2..pudu with(tablock)
SELECT [序號],
	(SELECT C.序號 FROM Bc2..suplu2 C WHERE C.頤坊型號 = P.頤坊型號 AND C.廠商編號 = P.廠商編號) [SUPLU_SEQ],
	RTRIM([採購單號]), [採購日期], RTRIM([樣品號碼]), RTRIM([工作類別]), RTRIM([廠商編號]), RTRIM([廠商簡稱]), RTRIM([頤坊型號]), RTRIM([暫時型號]), RTRIM([廠商型號]), RTRIM([產品說明]), RTRIM([單位]),
	[台幣單價], [美元單價], [人民幣單價], [單價_2], [單價_3], [MIN_1], [MIN_2], [MIN_3], RTRIM([外幣幣別]), [外幣單價], [外幣單價_2], [外幣單價_3], [採購數量], [採購交期], RTRIM([交期狀況]), [訂單數量], RTRIM([客戶編號]), RTRIM([客戶簡稱]), RTRIM([到貨處理]),
	RTRIM([列表小備註]), [結案], [強制結案], RTRIM([運送方式]), RTRIM([部門]), [變更日期], RTRIM([更新人員]), [更新日期]
FROM Bc2..pudu P

---------------------pudum---------------------
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pudum]') AND type in (N'U'))
DROP TABLE [dbo].[pudum]
GO
CREATE TABLE [dbo].[pudum](
	[序號] [int] NOT NULL,
	[採購單號] [varchar](9) NULL,
	[幣別] [varchar](3) NULL,
	[預付款一] [decimal](8, 2) NULL,
	[預付日一] [datetime] NULL,
	[預付款二] [decimal](8, 2) NULL,
	[預付日二] [datetime] NULL,
	[核銷金額] [decimal](9, 2) NULL,
	[核銷日期] [datetime] NULL,
	[附加費] [decimal](9, 2) NULL,
	[附加費說明] [varchar](50) NULL,
	[大備註一] [varchar](90) NULL,
	[大備註二] [varchar](90) NULL,
	[大備註三] [varchar](90) NULL,
	[特別事項] [varchar](2048) NULL,
	[變更日期] [datetime] NULL,
	[更新人員] [varchar](6) NULL,
	[更新日期] [datetime] NULL,
 CONSTRAINT [PK_pudum] PRIMARY KEY CLUSTERED 
([序號] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[pudum] ADD  CONSTRAINT [DF_pudum_更新日期]  DEFAULT (getdate()) FOR [更新日期]
GO

INSERT INTO Dc2..pudum
SELECT [序號], RTRIM([採購單號]), RTRIM([幣別]), [預付款一], [預付日一], [預付款二], [預付日二], [核銷金額], [核銷日期], [附加費], 
	RTRIM([附加費說明]), RTRIM([大備註一]), RTRIM([大備註二]), RTRIM([大備註三]), RTRIM([特別事項]), [變更日期], RTRIM([更新人員]), [更新日期]
FROM Bc2..pudum
