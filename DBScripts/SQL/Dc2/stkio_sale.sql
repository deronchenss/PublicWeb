USE Dc2;
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stkio_sale]') AND type in (N'U'))
DROP TABLE [dbo].[stkio_sale]

CREATE TABLE [dbo].[stkio_sale](
	[序號] [int] NOT NULL,
	[STKIO_SEQ] [int] NULL,
	[pm_no] [varchar](12) NULL,
	[訂單號碼] [varchar](20) NULL,
	[出貨日期] [datetime] NULL,
	[廠商編號] [varchar](8) NULL,
	[廠商簡稱] [varchar](10) NULL,
	[頤坊型號] [varchar](15) NULL,
	[銷售型號] [varchar](15) NULL,
	[單位] [varchar](6) NULL,
	[出區] [varchar](4) NULL,
	[入區] [varchar](4) NULL,
	[出貨數] [decimal](10, 3) NULL,
	[庫位] [varchar](12) NULL,
	[核銷數] [decimal](10, 3) NULL,
	[備註] [varchar](30) NULL,
	[箱號S] [varchar](4) NULL,
	[箱號E] [varchar](4) NULL,
	[內袋] [varchar](2) NULL,
	[產品一階] [varchar](2) NULL,
	[皮革型號] [varchar](15) NULL,
	[不入庫] [bit] NULL,
	[已結案] [bit] NULL,
	[已刪除] [bit] NULL,
	[變更日期] [datetime] NULL,
	[建立人員] [varchar](6) NULL,
	[建立日期] [datetime] NULL,
	[更新人員] [varchar](6) NULL,
	[更新日期] [datetime] NULL,
 CONSTRAINT [PK_stkio_sale] PRIMARY KEY CLUSTERED 
(
	[序號] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_stkio_sale] ON [dbo].[stkio_sale]
([更新日期] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[stkio_sale] ADD  CONSTRAINT [DF_stkio_sale_出貨數]  DEFAULT ((0)) FOR [出貨數]
GO
ALTER TABLE [dbo].[stkio_sale] ADD  CONSTRAINT [DF_stkio_sale_核銷數]  DEFAULT ((0)) FOR [核銷數]
GO
ALTER TABLE [dbo].[stkio_sale] ADD  CONSTRAINT [DF_stkio_sale_更新日期]  DEFAULT (getdate()) FOR [更新日期]
GO
ALTER TABLE [dbo].[stkio_sale] ADD  CONSTRAINT [DF_stkio_sale_建立日期]  DEFAULT (getdate()) FOR [建立日期]
GO

INSERT INTO Dc2..stkio_sale with(tablock)
SELECT [序號],
	   RTRIM([出庫序號]),
	   RTRIM([pm_no]),
	   RTRIM([訂單號碼]),
	   RTRIM([出貨日期]),
	   RTRIM([廠商編號]),
	   RTRIM([廠商簡稱]),
	   RTRIM([頤坊型號]),
	   RTRIM([內銷型號]),
	   RTRIM([單位]),
	   RTRIM([出區]),
	   RTRIM([入區]),
	   RTRIM([出貨數]),
	   RTRIM([庫位]),
	   RTRIM([核銷數]),
	   RTRIM([備註]),
	   RTRIM([箱號S]),
	   RTRIM([箱號E]),
	   RTRIM([內袋]),
	   RTRIM([產品一階]),
	   RTRIM([皮革型號]),
	   [不入庫],
	   [已刪除],
	   [已刪除],
	   [變更日期],
       RTRIM([更新人員]), 
	   [更新日期], 
	   RTRIM([更新人員]), 
	   [更新日期]
FROM Bc2..stkio_sale S