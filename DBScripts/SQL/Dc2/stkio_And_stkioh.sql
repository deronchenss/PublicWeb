USE Dc2;
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stkio]') AND type in (N'U'))
DROP TABLE [dbo].[stkio]

CREATE TABLE [dbo].[stkio](
	[序號] [int] NOT NULL,
	[SOURCE_SEQ] [int] NULL,
	[SOURCE_TABLE] [varchar](50) NULL,
	[SUPLU_SEQ] [int] NULL,
	[訂單號碼] [varchar](20) NULL,
	[單據編號] [varchar](15) NULL,
	[異動日期] [datetime] NULL,
	[帳項] [varchar](2) NULL,
	[帳項原因] [varchar](14) NULL,
	[廠商編號] [varchar](8) NULL,
	[廠商簡稱] [varchar](10) NULL,
	[頤坊型號] [varchar](15) NULL,
	[暫時型號] [varchar](15) NULL,
	[單位] [varchar](6) NULL,
	[庫區] [varchar](4) NULL,
	[入庫數] [decimal](10, 3) NULL,
	[出庫數] [decimal](10, 3) NULL,
	[庫位] [varchar](12) NULL,
	[核銷數] [decimal](10, 3) NULL,
	[異動前庫存] [decimal](10, 3) NULL,
	[客戶編號] [varchar](8) NULL,
	[客戶簡稱] [varchar](20) NULL,
	[完成品型號] [varchar](15) NULL,
	[備註] [nvarchar](30) NULL,
	[內銷入庫] [bit] NULL,
	[已結案] [bit] NULL,
	[已刪除] [bit] NULL,
	[變更日期] [datetime] NULL,
	[建立人員] [varchar](6) NULL,
	[建立日期] [datetime] NULL,
	[更新人員] [varchar](6) NULL,
	[更新日期] [datetime] NULL,
 CONSTRAINT [PK_stkio] PRIMARY KEY CLUSTERED 
(
	[序號] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_stkio] ON [dbo].[stkio]
([訂單號碼] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_stkio_2] ON [dbo].[stkio]
([庫區] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_stkio_3] ON [dbo].[stkio]
([更新日期] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[stkio] ADD  CONSTRAINT [DF_stkio_入庫數]  DEFAULT ((0)) FOR [入庫數]
GO
ALTER TABLE [dbo].[stkio] ADD  CONSTRAINT [DF_stkio_出庫數]  DEFAULT ((0)) FOR [出庫數]
GO
ALTER TABLE [dbo].[stkio] ADD  CONSTRAINT [DF_stkio_核銷數]  DEFAULT ((0)) FOR [核銷數]
GO
ALTER TABLE [dbo].[stkio] ADD  CONSTRAINT [DF_stkio_異動前庫存]  DEFAULT ((0)) FOR [異動前庫存]
GO
ALTER TABLE [dbo].[stkio] ADD  CONSTRAINT [DF_stkio_更新日期]  DEFAULT (getdate()) FOR [更新日期]
GO
ALTER TABLE [dbo].[stkio] ADD  CONSTRAINT [DF_stkio_建立日期]  DEFAULT (getdate()) FOR [建立日期]
GO

INSERT INTO Dc2..stkio with(tablock)
SELECT [序號], 0 [SOURCE_SEQ], '' [SOURCE_TABLE], (SELECT [序號] FROM Bc2..suplu2 C WHERE C.廠商編號 = S.廠商編號 AND C.頤坊型號 = S.頤坊型號) [SUPLU_SEQ], RTRIM([訂單號碼]), RTRIM([單據編號]),
	[異動日期], RTRIM([帳項]), RTRIM([帳項原因]), RTRIM([廠商編號]), RTRIM([廠商簡稱]), RTRIM([頤坊型號]),
	RTRIM([暫時型號]), RTRIM([單位]), RTRIM([庫區]), [入庫數], [出庫數], RTRIM([庫位]), [核銷數], [異動前庫存],
	RTRIM([客戶編號]), RTRIM([客戶簡稱]), RTRIM([完成品型號]), RTRIM([備註]), [內銷入庫], [已刪除], [已刪除], [變更日期], RTRIM([更新人員]), [更新日期], RTRIM([更新人員]), [更新日期]
FROM Bc2..stkio S


USE Dc2;
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stkioh]') AND type in (N'U'))
DROP TABLE [dbo].[stkioh]

CREATE TABLE [dbo].[stkioh](
	[序號] [int] NOT NULL,
	[SOURCE_SEQ] [int] NULL,
	[SOURCE_TABLE] [varchar](50) NULL,
	[SUPLU_SEQ] [int] NULL,
	[訂單號碼] [varchar](20) NULL,
	[單據編號] [varchar](15) NULL,
	[異動日期] [datetime] NULL,
	[帳項] [varchar](2) NULL,
	[帳項原因] [varchar](14) NULL,
	[廠商編號] [varchar](8) NULL,
	[廠商簡稱] [varchar](10) NULL,
	[頤坊型號] [varchar](15) NULL,
	[暫時型號] [varchar](15) NULL,
	[單位] [varchar](6) NULL,
	[庫區] [varchar](4) NULL,
	[入庫數] [decimal](10, 3) NULL,
	[出庫數] [decimal](10, 3) NULL,
	[庫位] [varchar](12) NULL,
	[核銷數] [decimal](10, 3) NULL,
	[異動前庫存] [decimal](10, 3) NULL,
	[實扣快取數] [decimal](10, 3) NULL,
	[客戶編號] [varchar](8) NULL,
	[客戶簡稱] [varchar](20) NULL,
	[完成品型號] [varchar](15) NULL,
	[備註] [nvarchar](30) NULL,
	[內銷入庫] [bit] NULL,
	[已刪除] [bit] NULL,
	[變更日期] [datetime] NULL,
	[建立人員] [varchar](6) NULL,
	[建立日期] [datetime] NULL,
	[更新人員] [varchar](6) NULL,
	[更新日期] [datetime] NULL,
 CONSTRAINT [PK_stkioh] PRIMARY KEY CLUSTERED 
(
	[序號] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_stkio] ON [dbo].[stkioh]
([訂單號碼] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_stkioh_2] ON [dbo].[stkioh]
([庫區] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_stkioh_3] ON [dbo].[stkioh]
([更新日期] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[stkioh] ADD  CONSTRAINT [DF_stkioh_入庫數]  DEFAULT ((0)) FOR [入庫數]
GO
ALTER TABLE [dbo].[stkioh] ADD  CONSTRAINT [DF_stkioh_出庫數]  DEFAULT ((0)) FOR [出庫數]
GO
ALTER TABLE [dbo].[stkioh] ADD  CONSTRAINT [DF_stkioh_核銷數]  DEFAULT ((0)) FOR [核銷數]
GO
ALTER TABLE [dbo].[stkioh] ADD  CONSTRAINT [DF_stkioh_異動前庫存]  DEFAULT ((0)) FOR [異動前庫存]
GO
ALTER TABLE [dbo].[stkioh] ADD  CONSTRAINT [DF_stkioh_更新日期]  DEFAULT (getdate()) FOR [更新日期]
GO
ALTER TABLE [dbo].[stkioh] ADD  CONSTRAINT [DF_stkioh_建立日期]  DEFAULT (getdate()) FOR [建立日期]
GO

INSERT INTO Dc2..stkioh with(tablock)
SELECT [序號], 0 [SOURCE_SEQ], '' [SOURCE_TABLE],
	(SELECT [序號] FROM Bc2..suplu2 C WHERE C.廠商編號 = S.廠商編號 AND C.頤坊型號 = S.頤坊型號) [SUPLU_SEQ], RTRIM([訂單號碼]), RTRIM([單據編號]),
	[異動日期], RTRIM([帳項]), RTRIM([帳項原因]), RTRIM([廠商編號]), RTRIM([廠商簡稱]), RTRIM([頤坊型號]),
	RTRIM([暫時型號]), RTRIM([單位]), RTRIM([庫區]), [入庫數], [出庫數], RTRIM([庫位]), [核銷數], [異動前庫存],	[實扣快取數],
	RTRIM([客戶編號]), RTRIM([客戶簡稱]), RTRIM([完成品型號]), RTRIM([備註]), [內銷入庫], [已刪除], [變更日期], RTRIM([更新人員]), [更新日期], RTRIM([更新人員]), [更新日期]
FROM Bc2..stkioh S

