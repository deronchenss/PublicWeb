USE [Dc2]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[paku2]') AND type in (N'U'))
DROP TABLE [dbo].[paku2]
GO
CREATE TABLE [dbo].[paku2](
	[序號] [int] NOT NULL,
	[SUPLU_SEQ] [int] NULL,
	[備貨日期] [datetime] NULL,
	[客戶編號] [varchar](8) NULL,
	[客戶簡稱] [varchar](10) NULL,
	[頤坊型號] [varchar](15) NULL,
	[暫時型號] [varchar](15) NULL,
	[產品說明] [varchar](80) NULL,
	[單位] [varchar](6) NULL,
	[備貨數量] [decimal](9, 3) NULL,
	[核銷數量] [decimal](9, 3) NULL,
	[廠商編號] [varchar](8) NULL,
	[廠商簡稱] [varchar](10) NULL,
	[來源] [varchar](6) NULL,
	[點收批號] [varchar](9) NULL,
	[已刪除] [bit] NULL,
	[變更日期] [datetime] NULL,
	[更新人員] [varchar](6) NULL,
	[更新日期] [datetime] NULL,
 CONSTRAINT [PK_paku2] PRIMARY KEY CLUSTERED 
(
	[序號] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[paku2] ADD CONSTRAINT [DF_paku2_更新日期]  DEFAULT (getdate()) FOR [更新日期]
GO

INSERT INTO Dc2..[paku2]
SELECT [序號], (SELECT [序號] FROM Bc2..suplu2 C WHERE C.廠商編號 = P.廠商編號 AND C.頤坊型號 = P.頤坊型號) [SUPLU_SEQ], [備貨日期],
	RTRIM([客戶編號]), RTRIM([客戶簡稱]), RTRIM([頤坊型號]), 
	RTRIM([暫時型號]), RTRIM([產品說明]), RTRIM([單位]),
	[備貨數量], [核銷數量], RTRIM([廠商編號]),
	RTRIM([廠商簡稱]), RTRIM([來源]), RTRIM([點收批號]),
	[已刪除], [變更日期], RTRIM([更新人員]), [更新日期]
FROM Bc2..[paku2] P


