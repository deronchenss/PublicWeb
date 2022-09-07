USE [Dc2]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[reca]') AND type in (N'U'))
DROP TABLE [dbo].[reca]
GO

CREATE TABLE [dbo].[reca](
	[序號] [int] NOT NULL,
	[PUD_SEQ] [int] NULL,
	[表單] [varchar](4) NULL,
	[點收批號] [varchar](9) NULL,
	[點收日期] [datetime] NULL,
	[採購單號] [varchar](9) NULL,
	[訂單號碼] [varchar](20) NULL,
	[廠商編號] [varchar](8) NULL,
	[廠商簡稱] [varchar](10) NULL,
	[頤坊型號] [varchar](15) NULL,
	[廠商型號] [varchar](19) NULL,
	[產品說明] [varchar](40) NULL,
	[單位] [varchar](6) NULL,
	[點收數量] [decimal](9, 2) NULL,
	[預定入庫] [decimal](9, 2) NULL,
	[入庫箱數] [decimal](6, 2) NULL,
	[庫位] [varchar](12) NULL,
	[庫區] [varchar](4) NULL,
	[實際入庫] [decimal](9, 2) NULL,
	[超繳數量] [decimal](9, 2) NULL,
	[台幣單價] [decimal](9, 2) NULL,
	[美元單價] [decimal](9, 3) NULL,
	[人民幣單價] [decimal](9, 2) NULL,
	[外幣幣別] [varchar](3) NULL,
	[外幣單價] [decimal](9, 2) NULL,
	[客戶編號] [varchar](8) NULL,
	[客戶簡稱] [varchar](10) NULL,
	[點收備註] [varchar](240) NULL,
	[帳務分類] [varchar](1) NULL,
	[驗貨] [varchar](6) NULL,
	[來貨處理] [varchar](1) NULL,
	[核銷數] [decimal](9, 2) NULL,
	[已到貨] [bit] NULL,
	[備貨關閉] [bit] NULL,
	[到貨關閉] [bit] NULL,
	[送貨櫃場] [bit] NULL,
	[批次] [varchar](1) NULL,
	[採購日期] [datetime] NULL,
	[採購交期] [datetime] NULL,
	[已刪除] [bit] NULL,
	[變更日期] [datetime] NULL,
	[更新人員] [varchar](6) NULL,
	[更新日期] [datetime] NULL,
 CONSTRAINT [PK_reca] PRIMARY KEY CLUSTERED 
(
	[序號] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[reca] ADD  CONSTRAINT [DF_reca_更新日期]  DEFAULT (getdate()) FOR [更新日期]
GO

INSERT INTO Dc2..reca with(tablock)
SELECT [序號],
	(SELECT TOP 1 P.序號 FROM Bc2..pud P WHERE R.採購單號 = P.採購單號 AND R.[頤坊型號] = P.[頤坊型號] AND R.廠商編號 = P.廠商編號 AND R.訂單號碼 = P.訂單號碼) [PUD_SEQ],
	RTRIM([表單]),
	RTRIM([點收批號]),
	[點收日期],
	RTRIM([採購單號]),
	RTRIM([訂單號碼]),
	RTRIM([廠商編號]),
	RTRIM([廠商簡稱]),
	RTRIM([頤坊型號]),
	RTRIM([廠商型號]),
	RTRIM([產品說明]),
	RTRIM([單位]) ,
	[點收數量],
	[預定入庫],
	[入庫箱數],
	RTRIM([庫位]),
	RTRIM([庫區]),
	[實際入庫],
	[超繳數量],
	[台幣單價],
	[美元單價],
	[人民幣單價],
	RTRIM([外幣幣別]),
	[外幣單價],
	RTRIM([客戶編號]),
	RTRIM([客戶簡稱]),
	RTRIM([點收備註]),
	RTRIM([帳務分類]),
	RTRIM([驗貨]),
	RTRIM([來貨處理]),
	[核銷數],
	[已到貨],
	[備貨關閉],
	[到貨關閉],
	[送貨櫃場],
	RTRIM([批次]),
	[採購日期],
	[採購交期],
	[已刪除],
	[變更日期],
	RTRIM([更新人員]),
	[更新日期]
FROM Bc2..reca R

GO

--舊資料 採購單號 + X
update reca 
set PUD_SEQ = pud.序號
from reca join pud on 'X' + reca.採購單號 = pud.採購單號 AND reca.[頤坊型號] = pud.[頤坊型號] AND reca.廠商編號 = pud.廠商編號 AND reca.訂單號碼 = pud.訂單號碼
WHERE reca.PUD_SEQ IS NULL

