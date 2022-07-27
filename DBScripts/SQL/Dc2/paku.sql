USE [Dc2]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[paku]') AND type in (N'U'))
DROP TABLE [dbo].[paku]
GO

CREATE TABLE [dbo].[paku](
	[序號] [int] NOT NULL,
	[INVOICE] [char](8) NULL,
	[SUPLU_SEQ] [int] NULL,
	[PAKU2_SEQ] [int] NULL,
	[客戶編號] [char](8) NULL,
	[客戶簡稱] [char](10) NULL,
	[樣品號碼] [char](18) NULL,
	[頤坊型號] [char](15) NULL,
	[暫時型號] [char](15) NULL,
	[產品說明] [varchar](80) NULL,
	[單位] [char](6) NULL,
	[美元單價] [decimal](9, 3) NULL,
	[台幣單價] [decimal](9, 2) NULL,
	[外幣幣別] [char](3) NULL,
	[外幣單價] [decimal](9, 3) NULL,
	[出貨數量] [decimal](9, 3) NULL,
	[廠商編號] [char](8) NULL,
	[廠商簡稱] [char](10) NULL,
	[FREE] [bit] NULL,
	[價格待通知] [bit] NULL,
	[ATTN] [char](2) NULL,
	[箱號] [char](4) NULL,
	[淨重] [decimal](5, 2) NULL,
	[毛重] [decimal](5, 2) NULL,
	[變更日期] [smalldatetime] NULL,
	[已刪除] [bit] NULL,
	[建立人員] [char](6) NULL,
	[建立日期] [smalldatetime] NULL,
	[更新人員] [char](6) NULL,
	[更新日期] [smalldatetime] NULL,
 CONSTRAINT [PK_paku] PRIMARY KEY CLUSTERED 
(
	[序號] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


ALTER TABLE [dbo].[paku] ADD  CONSTRAINT [DF_paku_美元單價]  DEFAULT ((0)) FOR [美元單價]
GO

ALTER TABLE [dbo].[paku] ADD  CONSTRAINT [DF_paku_台幣單價]  DEFAULT ((0)) FOR [台幣單價]
GO

ALTER TABLE [dbo].[paku] ADD  CONSTRAINT [DF_paku_外幣單價]  DEFAULT ((0)) FOR [外幣單價]
GO

ALTER TABLE [dbo].[paku] ADD  CONSTRAINT [DF_paku_出貨數量]  DEFAULT ((0)) FOR [出貨數量]
GO

ALTER TABLE [dbo].[paku] ADD  CONSTRAINT [DF_paku_更新日期]  DEFAULT (getdate()) FOR [更新日期]
GO


