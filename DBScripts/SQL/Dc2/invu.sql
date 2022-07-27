USE [Dc2]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[invu]') AND type in (N'U'))
DROP TABLE [dbo].[invu]
GO

CREATE TABLE [dbo].[invu](
	[序號] [int] NOT NULL,
	[INVOICE] [char](8) NULL,
	[出貨日期] [smalldatetime] NULL,
	[客戶編號] [char](8) NULL,
	[客戶簡稱] [char](10) NULL,
	[銀行編號] [char](2) NULL,
	[銀行簡稱] [varchar](8) NULL,
	[提單號碼] [varchar](18) NULL,
	[應稅] [bit] NULL,
	[發票匯率] [decimal](6, 3) NULL,
	[應收樣品費] [decimal](8, 2) NULL,
	[應收樣品NT] [decimal](8, 2) NULL,
	[應收運費] [decimal](6, 2) NULL,
	[應收運費NT] [decimal](6, 2) NULL,
	[併大貨收款] [bit] NULL,
	[已收金額] [decimal](8, 2) NULL,
	[已收金額NT] [decimal](8, 2) NULL,
	[已收日期] [smalldatetime] NULL,
	[外幣幣別] [char](3) NULL,
	[備註業務] [varchar](1024) NULL,
	[備註會計] [varchar](80) NULL,
	[備註_ivan] [varchar](80) NULL,
	[運輸編號] [char](8) NULL,
	[運輸簡稱] [varchar](20) NULL,
	[運送方式] [varchar](18) NULL,
	[匯入銀行] [char](4) NULL,
	[變更日期] [smalldatetime] NULL,
	[建立人員] [char](6) NULL,
	[建立日期] [smalldatetime] NULL,
	[更新人員] [char](6) NULL,
	[更新日期] [smalldatetime] NULL,
 CONSTRAINT [PK_invu] PRIMARY KEY CLUSTERED 
(
	[序號] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[invu] ADD  CONSTRAINT [DF_invu_發票匯率]  DEFAULT ((0)) FOR [發票匯率]
GO

ALTER TABLE [dbo].[invu] ADD  CONSTRAINT [DF_invu_應收樣品費]  DEFAULT ((0)) FOR [應收樣品費]
GO

ALTER TABLE [dbo].[invu] ADD  CONSTRAINT [DF_invu_應收樣品NT]  DEFAULT ((0)) FOR [應收樣品NT]
GO

ALTER TABLE [dbo].[invu] ADD  CONSTRAINT [DF_invu_應收運費]  DEFAULT ((0)) FOR [應收運費]
GO

ALTER TABLE [dbo].[invu] ADD  CONSTRAINT [DF_invu_應收運費NT]  DEFAULT ((0)) FOR [應收運費NT]
GO

ALTER TABLE [dbo].[invu] ADD  CONSTRAINT [DF_invu_已收金額]  DEFAULT ((0)) FOR [已收金額]
GO

ALTER TABLE [dbo].[invu] ADD  CONSTRAINT [DF_invu_已收金額NT]  DEFAULT ((0)) FOR [已收金額NT]
GO

ALTER TABLE [dbo].[invu] ADD  CONSTRAINT [DF_invu_更新日期]  DEFAULT (getdate()) FOR [更新日期]
GO


