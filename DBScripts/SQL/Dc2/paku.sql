USE [Dc2]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[paku]') AND type in (N'U'))
DROP TABLE [dbo].[paku]
GO

CREATE TABLE [dbo].[paku](
	[序號] [int] NOT NULL,
	[INVOICE] [varchar](8) NULL,
	[SUPLU_SEQ] [int] NULL,
	[PAKU2_SEQ] [int] NULL,
	[客戶編號] [varchar](8) NULL,
	[客戶簡稱] [varchar](10) NULL,
	[樣品號碼] [varchar](18) NULL,
	[頤坊型號] [varchar](15) NULL,
	[暫時型號] [varchar](15) NULL,
	[產品說明] [varchar](80) NULL,
	[單位] [varchar](6) NULL,
	[美元單價] [decimal](9, 3) NULL,
	[台幣單價] [decimal](9, 2) NULL,
	[外幣幣別] [varchar](3) NULL,
	[外幣單價] [decimal](9, 3) NULL,
	[出貨數量] [decimal](9, 3) NULL,
	[廠商編號] [varchar](8) NULL,
	[廠商簡稱] [varchar](10) NULL,
	[FREE] [bit] NULL,
	[價格待通知] [bit] NULL,
	[ATTN] [varchar](2) NULL,
	[箱號] [varchar](4) NULL,
	[淨重] [decimal](5, 2) NULL,
	[毛重] [decimal](5, 2) NULL,
	[變更日期] [datetime] NULL,
	[已刪除] [bit] NULL,
	[建立人員] [varchar](20) NULL,
	[建立日期] [datetime] NULL,
	[更新人員] [varchar](20) NULL,
	[更新日期] [datetime] NULL,
 CONSTRAINT [PK_paku] PRIMARY KEY CLUSTERED 
(
	[序號] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE INDEX paku_IDX_INVOICE ON [paku]([INVOICE]);
CREATE INDEX paku_IDX_SUPLU_SEQ ON [paku]([SUPLU_SEQ]);
CREATE INDEX paku_IDX_PAKU2_SEQ ON [paku]([PAKU2_SEQ]);


ALTER TABLE [dbo].[paku] ADD  CONSTRAINT [DF_paku_美元單價]  DEFAULT ((0)) FOR [美元單價]
ALTER TABLE [dbo].[paku] ADD  CONSTRAINT [DF_paku_台幣單價]  DEFAULT ((0)) FOR [台幣單價]
ALTER TABLE [dbo].[paku] ADD  CONSTRAINT [DF_paku_外幣單價]  DEFAULT ((0)) FOR [外幣單價]
ALTER TABLE [dbo].[paku] ADD  CONSTRAINT [DF_paku_出貨數量]  DEFAULT ((0)) FOR [出貨數量]
ALTER TABLE [dbo].[paku] ADD  CONSTRAINT [DF_paku_更新日期]  DEFAULT (getdate()) FOR [更新日期]
GO

INSERT INTO Dc2..paku
SELECT [序號], RTRIM([INVOICE]), 
	(SELECT C.[序號] FROM Bc2..suplu2 C WHERE C.[頤坊型號] = P.[頤坊型號] AND C.[廠商編號] = P.[廠商編號]) [SUPLU_SEQ], 
	0 [PAKU2_SEQ],
	RTRIM([客戶編號]), RTRIM([客戶簡稱]), RTRIM([樣品號碼]), RTRIM([頤坊型號]),
	RTRIM([暫時型號]), RTRIM([產品說明]), RTRIM([單位]), [美元單價],
	[台幣單價], RTRIM([外幣幣別]), [外幣單價], [出貨數量], RTRIM([廠商編號]), RTRIM([廠商簡稱]),
	[FREE], [價格待通知], RTRIM([ATTN]), RTRIM([箱號]), [淨重], [毛重], [變更日期], [已刪除],
	RTRIM([更新人員]) [建立人員], [更新日期] [建立日期], RTRIM([更新人員]), [更新日期]
FROM Bc2..paku P;
