USE [Dc2]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pud]') AND type in (N'U'))
DROP TABLE [dbo].[pud]
GO

CREATE TABLE [dbo].[pud](
	[序號] [int] NOT NULL,
	[SUPLU_SEQ] [int] NULL,
	[訂單序號] [varchar](8) NULL,
	[訂單號碼] [varchar](20) NULL,
	[庫存採購_下次版本] [bit] NULL,
	[廠商編號] [varchar](8) NULL,
	[廠商簡稱] [varchar](10) NULL,
	[頤坊型號] [varchar](15) NULL,
	[產品說明] [varchar](40) NULL,
	[單位] [varchar](6) NULL,
	[採購日期] [datetime] NULL,
	[採購單號] [varchar](9) NULL,
	[採購數量] [decimal](9, 3) NULL,
	[原始數量] [decimal](9, 3) NULL,
	[採購交期] [datetime] NULL,
	[工廠交期] [datetime] NULL,
	[交期狀況] [varchar](30) NULL,
	[台幣單價] [decimal](9, 2) NULL,
	[美元單價] [decimal](9, 3) NULL,
	[人民幣單價] [decimal](9, 2) NULL,
	[外幣幣別] [varchar](3) NULL,
	[外幣單價] [decimal](9, 2) NULL,
	[廠商型號] [varchar](19) NULL,
	[完成品型號] [varchar](15) NULL,
	[指定受貨人] [varchar](18) NULL,
	[簽收日期] [datetime] NULL,
	[到貨日期] [datetime] NULL,
	[到貨數量] [decimal](9, 2) NULL,
	[點收日期] [datetime] NULL,
	[點收數量] [decimal](9, 2) NULL,
	[組合品] [bit] NULL,
	[帳務分類] [varchar](1) NULL,
	[物流] [varchar](1) NULL,
	[採購] [varchar](1) NULL,
	[處置代碼] [varchar](1) NULL,
	[廠商交期] [int] NULL,
	[分配庫存數] [decimal](9, 2) NULL,
	[裝配old] [bit] NULL,
	[新品] [bit] NULL,
	[材料合併] [bit] NULL,
	[採購備註] [varchar](30) NULL,
	[應扣庫取數] [decimal](9, 2) NULL,
	[客戶編號] [varchar](8) NULL,
	[客戶簡稱] [varchar](10) NULL,
	[結案] [bit] NULL,
	[貨品回台_下次版本] [bit] NULL,
	[已刪除] [bit] NULL,
	[變更日期] [datetime] NULL,
	[更新人員] [varchar](6) NULL,
	[更新日期] [datetime] NULL,
 CONSTRAINT [PK_pud] PRIMARY KEY CLUSTERED 
(
	[序號] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[pud] ADD  CONSTRAINT [DF_pud_採購數量]  DEFAULT ((0)) FOR [採購數量]
ALTER TABLE [dbo].[pud] ADD  CONSTRAINT [DF_pud_溢採數量]  DEFAULT ((0)) FOR [原始數量]
ALTER TABLE [dbo].[pud] ADD  CONSTRAINT [DF_pud_台幣單價]  DEFAULT ((0)) FOR [台幣單價]
ALTER TABLE [dbo].[pud] ADD  CONSTRAINT [DF_pud_美元單價]  DEFAULT ((0)) FOR [美元單價]
ALTER TABLE [dbo].[pud] ADD  CONSTRAINT [DF_pud_人民幣單價]  DEFAULT ((0)) FOR [人民幣單價]
ALTER TABLE [dbo].[pud] ADD  CONSTRAINT [DF_pud_外幣單價]  DEFAULT ((0)) FOR [外幣單價]
ALTER TABLE [dbo].[pud] ADD  CONSTRAINT [DF_pud_到貨數量]  DEFAULT ((0)) FOR [到貨數量]
ALTER TABLE [dbo].[pud] ADD  CONSTRAINT [DF_pud_點收數量]  DEFAULT ((0)) FOR [點收數量]
ALTER TABLE [dbo].[pud] ADD  CONSTRAINT [DF_pud_廠商交期]  DEFAULT ((0)) FOR [廠商交期]
ALTER TABLE [dbo].[pud] ADD  CONSTRAINT [DF_pud_分配庫存數]  DEFAULT ((0)) FOR [分配庫存數]
ALTER TABLE [dbo].[pud] ADD  CONSTRAINT [DF_pud_庫取扣除數]  DEFAULT ((0)) FOR [應扣庫取數]
ALTER TABLE [dbo].[pud] ADD  CONSTRAINT [DF_pud_更新日期]  DEFAULT (getdate()) FOR [更新日期]
GO

INSERT INTO Dc2..pud with(tablock)
SELECT [序號],
	(SELECT C.序號 FROM Bc2..suplu2 C WHERE C.頤坊型號 = P.頤坊型號 AND C.廠商編號 = P.廠商編號) [SUPLU_SEQ],
	RTRIM([訂單序號]),
	RTRIM([訂單號碼]),
	[庫存採購_下次版本],
	RTRIM([廠商編號]),
	RTRIM([廠商簡稱]),
	RTRIM([頤坊型號]),
	RTRIM([產品說明]),
	RTRIM([單位]),
	[採購日期],
	RTRIM([採購單號]),
	[採購數量],
	[原始數量],
	[採購交期],
	[工廠交期],
	RTRIM([交期狀況]),
	[台幣單價],
	[美元單價],
	[人民幣單價],
	RTRIM([外幣幣別]),
	[外幣單價],
	RTRIM([廠商型號]),
	RTRIM([完成品型號]),
	RTRIM([指定受貨人]),
	[簽收日期],
	[到貨日期],
	[到貨數量],
	[點收日期],
	[點收數量],
	[組合品],
	RTRIM([帳務分類]),
	RTRIM([物流]),
	RTRIM([採購]),
	RTRIM([處置代碼]),
	[廠商交期],
	[分配庫存數],
	[裝配old],
	[新品],
	[材料合併],
	RTRIM([採購備註]),
	[應扣庫取數],
	RTRIM([客戶編號]),
	RTRIM([客戶簡稱]),
	[結案],
	[貨品回台_下次版本],
	[已刪除],
	[變更日期],
	RTRIM([更新人員]),
	[更新日期]
FROM Bc2..pud P

