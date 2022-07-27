--去掉
--[台幣單價] [decimal](9, 2) NULL,[美元單價] [decimal](9, 3) NULL,[人民幣單價] [decimal](9, 2) NULL,[外幣幣別] [varchar](3) NULL,[外幣單價] [decimal](9, 2) NULL,

USE Dc2;
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[recu]') AND type in (N'U'))
DROP TABLE [dbo].[recu]
--增加 PUDU_SEQ
CREATE TABLE [dbo].[recu](
	[序號] [int] NOT NULL,
	[PUDU_SEQ] [int] NULL,
	[點收批號] [varchar](9) NULL,
	[採購單號] [varchar](9) NULL,
	[樣品號碼] [varchar](18) NULL,
	[廠商編號] [varchar](8) NULL,
	[廠商簡稱] [varchar](10) NULL,
	[頤坊型號] [varchar](15) NULL,
	[暫時型號] [varchar](15) NULL,
	[廠商型號] [varchar](19) NULL,
	[單位] [varchar](6) NULL,
	[調整額01] [decimal](9, 2) NULL,
	[調整額02] [decimal](4, 2) NULL,
	[出貨日期] [datetime] NULL,
	[到貨日期] [datetime] NULL,
	[到貨單號] [varchar](15) NULL,
	[到貨數量] [decimal](9, 2) NULL,
	[到單日期] [datetime] NULL,
--	[運輸編號] [varchar](8) NULL,
--	[運輸簡稱] [varchar](20) NULL,
	[運送方式] [varchar](18) NULL,
	[不付款] [bit] NULL,
	[發票樣式] [varchar](2) NULL,
	[發票號碼] [varchar](12) NULL,
	[發票異常] [bit] NULL,
	[歸屬年] [smallint] NULL,
	[歸屬月] [smallint] NULL,
	[到貨備註] [varchar](50) NULL,
	[部門] [varchar](2) NULL,
	[變更日期] [datetime] NULL,
	[更新人員] [varchar](6) NULL,
	[更新日期] [datetime] NULL,
 CONSTRAINT [PK_recu] PRIMARY KEY CLUSTERED 
([序號] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [IX_recu] ON [dbo].[recu]
([出貨日期] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_recu_1] ON [dbo].[recu]
([頤坊型號] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_recu_2] ON [dbo].[recu]
([廠商編號] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_recu_3] ON [dbo].[recu]
([到貨日期] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_recu_4] ON [dbo].[recu]
([點收批號] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
CREATE INDEX recu_IDX_PUDU_SEQ ON recu(PUDU_SEQ);
ALTER TABLE [dbo].[recu] ADD  CONSTRAINT [DF_recu_到貨數量]  DEFAULT ((0)) FOR [到貨數量]
ALTER TABLE [dbo].[recu] ADD  CONSTRAINT [DF_recu_更新日期]  DEFAULT (getdate()) FOR [更新日期]

INSERT INTO Dc2..recu
SELECT [序號],
CASE (SELECT COUNT(1) FROM Bc2..pudu P WHERE P.採購單號 = R.採購單號 AND P.樣品號碼 = R.樣品號碼 AND P.[頤坊型號] = R.[頤坊型號]) WHEN 1 
	 THEN (SELECT TOP 1 [序號] FROM Bc2..pudu P WHERE P.採購單號 = R.採購單號 AND P.樣品號碼 = R.樣品號碼 AND P.[頤坊型號] = R.[頤坊型號])
	 ELSE 0 END [PUDU_SEQ],
RTRIM([點收批號]), 
RTRIM([採購單號]), RTRIM([樣品號碼]), RTRIM([廠商編號]), RTRIM([廠商簡稱]), RTRIM([頤坊型號]), RTRIM([暫時型號]), RTRIM([廠商型號]), RTRIM([單位]),
	[調整額01], [調整額02], [出貨日期], [到貨日期], [到貨單號], [到貨數量], [到單日期], 
	--RTRIM([運輸編號]), 
	--[運輸簡稱], 
	[運送方式], [不付款], [發票樣式], [發票號碼], [發票異常], [歸屬年], [歸屬月], [到貨備註], [部門], [變更日期], RTRIM([更新人員]),[更新日期]
FROM Bc2..recu R

-----------------recua
USE Dc2;
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[recua]') AND type in (N'U'))
DROP TABLE [dbo].[recua]
GO
CREATE TABLE [dbo].[recua](
	[序號] [int] NOT NULL,
	PUDU_SEQ [int] NULL,
	[點收批號] [varchar](9) NULL,
	[採購單號] [varchar](9) NULL,
	[樣品號碼] [varchar](18) NULL,
	[廠商編號] [varchar](8) NULL,
	[廠商簡稱] [varchar](10) NULL,
	[頤坊型號] [varchar](15) NULL,
	[暫時型號] [varchar](15) NULL,
	[廠商型號] [varchar](19) NULL,
	[單位] [varchar](6) NULL,
	[點收日期] [datetime] NULL,
	[點收數量] [decimal](9, 2) NULL,
	[核銷數量] [decimal](9, 2) NULL,
	[運輸編號] [varchar](8) NULL,
	[運輸簡稱] [varchar](20) NULL,
	[運送方式] [varchar](18) NULL,
	[變更日期] [datetime] NULL,
	[更新人員] [varchar](6) NULL,
	[更新日期] [datetime] NULL,
 CONSTRAINT [PK_recua] PRIMARY KEY CLUSTERED 
(
	[序號] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_recua] ON [dbo].[recua]
([點收日期] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_recua_1] ON [dbo].[recua]
([頤坊型號] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_recua_2] ON [dbo].[recua]
([廠商編號] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_recua_3] ON [dbo].[recua]
([點收批號] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
ALTER TABLE [dbo].[recua] ADD  CONSTRAINT [DF_recua_點收數量]  DEFAULT ((0)) FOR [點收數量]
ALTER TABLE [dbo].[recua] ADD  CONSTRAINT [DF_recua_核銷數量]  DEFAULT ((0)) FOR [核銷數量]
ALTER TABLE [dbo].[recua] ADD  CONSTRAINT [DF_recua_更新日期]  DEFAULT (getdate()) FOR [更新日期]
CREATE INDEX recua_IDX_PUDU_SEQ ON recua(PUDU_SEQ);
GO


INSERT INTO Dc2..recua
SELECT [序號], 
CASE (SELECT COUNT(1) FROM Bc2..pudu P WHERE P.採購單號 = R.採購單號 AND P.樣品號碼 = R.樣品號碼 AND P.[頤坊型號] = R.[頤坊型號]) WHEN 1 
	 THEN (SELECT TOP 1 [序號] FROM Bc2..pudu P WHERE P.採購單號 = R.採購單號 AND P.樣品號碼 = R.樣品號碼 AND P.[頤坊型號] = R.[頤坊型號])
	 ELSE 0 END [PUDU_SEQ],
RTRIM([點收批號]), RTRIM([採購單號]), RTRIM([樣品號碼]), RTRIM([廠商編號]), RTRIM([廠商簡稱]), RTRIM([頤坊型號]), RTRIM([暫時型號]), RTRIM([廠商型號]), RTRIM([單位]), 
[點收日期], [點收數量], [核銷數量], RTRIM([運輸編號]), RTRIM([運輸簡稱]), RTRIM([運送方式]), [變更日期], RTRIM([更新人員]), [更新日期]
FROM Bc2..recua R

/*
SELECT 
(SELECT COUNT(1) FROM pudu P WHERE P.採購單號 = R.採購單號 AND P.樣品號碼 = R.樣品號碼 AND P.[頤坊型號] = R.[頤坊型號]) C,
(SELECT CAST([序號] AS VARCHAR(MAX)) + ',' FROM pudu P WHERE P.採購單號 = R.採購單號 AND P.樣品號碼 = R.樣品號碼 AND P.[頤坊型號] = R.[頤坊型號] FOR XML PATH('')) SEQ, *
FROM recu R
order by 1 desc

SELECT * FROM pudu WHERE 序號 IN ('67384','67406')
SELECT * FROM recu WHERE 序號  = '57901'
*/