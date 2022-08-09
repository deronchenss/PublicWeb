USE [Dc2]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[quah]') AND type in (N'U'))
DROP TABLE [dbo].[quah]
GO

CREATE TABLE [dbo].[quah](
	[序號] [int] NOT NULL,
	[BYRLU_SEQ] [INT] NULL,
	[報價單號] [varchar](8) NULL,
	[報價日期] [datetime] NULL,
	[客戶編號] [varchar](8) NULL,
	[客戶簡稱] [varchar](10) NULL,
	[頤坊型號] [varchar](15) NULL,
	[產品說明] [varchar](360) NULL,
	[單位] [varchar](6) NULL,
	[美元單價] [decimal](9, 3) NULL,
	[台幣單價] [decimal](9, 2) NULL,
	--[歐元單價] [decimal](9, 2) NULL,
	[單價_2] [decimal](9, 3) NULL,
	[單價_3] [decimal](9, 3) NULL,
	[單價_4] [decimal](9, 3) NULL,
	[min_1] [int] NULL,
	[min_2] [int] NULL,
	[min_3] [int] NULL,
	[min_4] [int] NULL,
	--[外幣幣別] [varchar](3) NULL,
	--[外幣單價] [decimal](9, 3) NULL,
	[S_FROM] [varchar](1) NULL,
	[廠商編號] [varchar](8) NULL,
	[廠商簡稱] [varchar](10) NULL,
	[變更日期] [datetime] NULL,
	[更新人員] [varchar](6) NULL,
	[更新日期] [datetime] NULL,
 CONSTRAINT [PK_quah] PRIMARY KEY CLUSTERED 
([序號] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE INDEX quah_IDX_BYRLU_SEQ ON quah(BYRLU_SEQ);

ALTER TABLE [dbo].[quah] ADD  CONSTRAINT [DF_quah_美元單價]  DEFAULT ((0)) FOR [美元單價]
ALTER TABLE [dbo].[quah] ADD  CONSTRAINT [DF_quah_台幣單價]  DEFAULT ((0)) FOR [台幣單價]
--ALTER TABLE [dbo].[quah] ADD  CONSTRAINT [DF_quah_歐元單價]  DEFAULT ((0)) FOR [歐元單價]
--ALTER TABLE [dbo].[quah] ADD  CONSTRAINT [DF_quah_外幣單價]  DEFAULT ((0)) FOR [外幣單價]
ALTER TABLE [dbo].[quah] ADD  CONSTRAINT [DF_quah_更新日期]  DEFAULT (getdate()) FOR [更新日期]

INSERT INTO Dc2..quah
SELECT [序號],  
	(SELECT MAX(p.序號) FROM Bc2..byrlu p WHERE q.客戶編號 = p.客戶編號 AND q.頤坊型號 = p.頤坊型號 AND q.廠商編號 = p.廠商編號) [BYRLU_SEQ], 
	[報價單號], [報價日期], RTRIM([客戶編號]), RTRIM([客戶簡稱]), RTRIM([頤坊型號]), RTRIM([產品說明]), RTRIM([單位]), 
	[美元單價], [台幣單價], [單價_2], [單價_3], [單價_4], [min_1], [min_2], [min_3], [min_4], RTRIM([S_FROM]), RTRIM([廠商編號]), RTRIM([廠商簡稱]), [變更日期],RTRIM([更新人員]), [更新日期]
FROM Bc2..quah q

/*
SELECT * 
FROM Bc2..quah q
	LEFT JOIN Bc2..byrlu p on q.客戶編號 = p.客戶編號 AND q.頤坊型號 = p.頤坊型號	
WHERE p.序號 IS NULL


SELECT 	(SELECT CAST(序號 AS VARCHAR(10)) + ',' FROM Bc2..byrlu p WHERE q.客戶編號 = p.客戶編號 AND q.頤坊型號 = p.頤坊型號 AND q.廠商編號 = p.廠商編號 FOR XML PATH('')) [BYRLU_SEQ], 
(SELECT COUNT(1) FROM Bc2..byrlu p WHERE q.客戶編號 = p.客戶編號 AND q.頤坊型號 = p.頤坊型號 AND q.廠商編號 = p.廠商編號) [CT], *
FROM Bc2..quah q
WHERE (SELECT COUNT(1) FROM Bc2..byrlu p WHERE q.客戶編號 = p.客戶編號 AND q.頤坊型號 = p.頤坊型號 AND q.廠商編號 = p.廠商編號) > 1
order by 2 desc

SELECT * FROM bc2..byrlu WHERE 序號 IN ('126989','220303')
SELECT * FROM dc2..byrlu WHERE 序號 IN ('126989','220303')
*/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[quahm]') AND type in (N'U'))
DROP TABLE [dbo].[quahm]
GO

CREATE TABLE [dbo].[quahm](
	[序號] [int] NOT NULL,
	[報價單號] [varchar](8) NULL,
	[大備註] [nvarchar](1024) NULL,
	[變更日期] [datetime] NULL,
	[更新人員] [varchar](6) NULL,
	[更新日期] [datetime] NULL,
 CONSTRAINT [PK_quahm] PRIMARY KEY CLUSTERED 
([序號] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
ALTER TABLE [dbo].[quahm] ADD  CONSTRAINT [DF_quahm_更新日期]  DEFAULT (getdate()) FOR [更新日期]
GO

INSERT INTO Dc2..quahm
SELECT * FROM Bc2..quahm


