USE [Dc2]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[barcode]') AND type in (N'U'))
DROP TABLE [dbo].[barcode]
GO

CREATE TABLE [dbo].[barcode](
	[序號] [int] NOT NULL,
	[客戶編號] [varchar](8) NULL,
	[客戶簡稱] [varchar](10) NULL,
	[頤坊型號] [varchar](15) NULL,
	[客戶型號] [varchar](15) NULL,
	[upc] [varchar](13) NULL,
	[產品說明] [varchar](40) NULL,
	[產品說明二] [varchar](30) NULL,
	[產品說明三] [varchar](33) NULL,
	[產品說明四] [varchar](33) NULL,
	[產品說明五] [varchar](33) NULL,
	[產品說明六] [varchar](33) NULL,
	[色澤] [varchar](10) NULL,
	[尺寸] [varchar](10) NULL,
	[單位] [varchar](12) NULL,
	[產地] [varchar](20) NULL,
	[樣式] [varchar](4) NULL,
	[樣式2] [varchar](4) NULL,
	[CP65] [varchar](2) NULL,
	[賣價] [decimal](6, 2) NULL,
	[內袋標籤] [int] NULL,
	[內袋單位] [int] NULL,
	[自有條碼] [bit] NULL,
	[條碼倍數] [int] NULL,
	[寄送袋子] [varchar](12) NULL,
	[寄送吊卡] [varchar](12) NULL,
	[自備袋子] [bit] NULL,
	[自備吊卡] [bit] NULL,
	[特殊包裝] [varchar](12) NULL,
	[特殊吊卡] [varchar](12) NULL,
	[年齡] [varchar](2) NULL,
	[包裝單價] [decimal](6, 3) NULL,
	[廠商編號] [varchar](8) NULL,
	[廠商簡稱] [varchar](10) NULL,
	[變更日期] [datetime] NULL,
	[更新人員] [varchar](6) NULL,
	[更新日期] [datetime] NULL,
 CONSTRAINT [PK_barcode] PRIMARY KEY CLUSTERED 
(
	[序號] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[barcode] ADD  CONSTRAINT [DF_barcode_更新日期]  DEFAULT (getdate()) FOR [更新日期]
GO


INSERT INTO Dc2..barcode
SELECT [序號]
      ,RTRIM([客戶編號])
      ,RTRIM([客戶簡稱])
      ,RTRIM([頤坊型號])
      ,RTRIM([客戶型號])
      ,RTRIM([upc])
      ,RTRIM([產品說明])
      ,RTRIM([產品說明二])
      ,RTRIM([產品說明三])
      ,RTRIM([產品說明四])
      ,RTRIM([產品說明五])
      ,RTRIM([產品說明六])
      ,RTRIM([色澤])
      ,RTRIM([尺寸])
      ,RTRIM([單位])
      ,RTRIM([產地])
      ,RTRIM([樣式])
      ,RTRIM([樣式2])
      ,RTRIM([CP65])
      ,[賣價]
      ,[內袋標籤]
      ,[內袋單位]
      ,[自有條碼]
      ,[條碼倍數]
      ,RTRIM([寄送袋子])
      ,RTRIM([寄送吊卡])
      ,[自備袋子]
      ,[自備吊卡]
      ,RTRIM([特殊包裝])
      ,RTRIM([特殊吊卡])
      ,RTRIM([年齡])
      ,[包裝單價]
      ,RTRIM([廠商編號])
      ,RTRIM([廠商簡稱])
      ,[變更日期]
      ,RTRIM([更新人員])
      ,[更新日期]
FROM Bc2..barcode;
