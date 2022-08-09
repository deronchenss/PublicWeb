USE [Dc2]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[byrlu]') AND type in (N'U'))
DROP TABLE [dbo].[byrlu]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[byrlu](
	[序號] [int] NOT NULL,
	[SUPLU_SEQ] [INT] NULL,
	[開發中] [varchar](1) NULL,
	[客戶編號] [varchar](8) NULL,
	[客戶簡稱] [varchar](10) NULL,
	[頤坊型號] [varchar](15) NULL,
	[客戶型號] [varchar](15) NULL,
	[產品說明] [varchar](360) NULL,
	[單位] [varchar](6) NULL,
	[最後單價日] [datetime] NULL,
	[美元單價] [decimal](9, 3) NULL,
	[台幣單價] [decimal](9, 2) NULL,
	[單價_2] [decimal](9, 3) NULL,
	[單價_3] [decimal](9, 3) NULL,
	[單價_4] [decimal](9, 3) NULL,
	[單價_5] [decimal](9, 3) NULL,
	[min_1] [int] NULL,
	[min_2] [int] NULL,
	[min_3] [int] NULL,
	[min_4] [int] NULL,
	[min_5] [int] NULL,
	[外幣幣別] [varchar](3) NULL,
	[外幣單價] [decimal](9, 3) NULL,
	[廠商編號] [varchar](8) NULL,
	[廠商簡稱] [varchar](10) NULL,
	[稅則號碼] [varchar](12) NULL,
	[商標] [varchar](6) NULL,
	[停用日期] [datetime] NULL,
	[備註] [varchar](1024) NULL,
	[變更記錄] [Nvarchar](MAX) NULL,
	[變更日期] [datetime] NULL,
	[更新人員] [varchar](6) NULL,
	[更新日期] [datetime] NULL,
 CONSTRAINT [PK_byrlu] PRIMARY KEY CLUSTERED 
(
	[序號] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
SET ANSI_PADDING ON
CREATE NONCLUSTERED INDEX [IX_byrlu] ON [dbo].[byrlu]([頤坊型號] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
SET ANSI_PADDING ON
CREATE NONCLUSTERED INDEX [IX_byrlu_1] ON [dbo].[byrlu]([客戶編號] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_byrlu_2] ON [dbo].[byrlu]([更新日期] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
SET ANSI_PADDING ON
CREATE NONCLUSTERED INDEX [IX_byrlu_3] ON [dbo].[byrlu]([客戶型號] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
ALTER TABLE [dbo].[byrlu] ADD  CONSTRAINT [DF_byrlu_美元單價]  DEFAULT ((0)) FOR [美元單價]
ALTER TABLE [dbo].[byrlu] ADD  CONSTRAINT [DF_byrlu_台幣單價]  DEFAULT ((0)) FOR [台幣單價]
ALTER TABLE [dbo].[byrlu] ADD  CONSTRAINT [DF_byrlu_單價_2]  DEFAULT ((0)) FOR [單價_2]
ALTER TABLE [dbo].[byrlu] ADD  CONSTRAINT [DF_byrlu_單價_3]  DEFAULT ((0)) FOR [單價_3]
ALTER TABLE [dbo].[byrlu] ADD  CONSTRAINT [DF_byrlu_單價_4]  DEFAULT ((0)) FOR [單價_4]
ALTER TABLE [dbo].[byrlu] ADD  CONSTRAINT [DF_byrlu_min_1]  DEFAULT ((0)) FOR [min_1]
ALTER TABLE [dbo].[byrlu] ADD  CONSTRAINT [DF_byrlu_min_2]  DEFAULT ((0)) FOR [min_2]
ALTER TABLE [dbo].[byrlu] ADD  CONSTRAINT [DF_byrlu_min_3]  DEFAULT ((0)) FOR [min_3]
ALTER TABLE [dbo].[byrlu] ADD  CONSTRAINT [DF_byrlu_min_4]  DEFAULT ((0)) FOR [min_4]
ALTER TABLE [dbo].[byrlu] ADD  CONSTRAINT [DF_byrlu_外幣單價]  DEFAULT ((0)) FOR [外幣單價]
ALTER TABLE [dbo].[byrlu] ADD  CONSTRAINT [DF_byrlu_更新人員]  DEFAULT (getdate()) FOR [更新日期]
CREATE INDEX BURLU_IDX_SUPLU_SEQ ON Dc2..BYRLU([SUPLU_SEQ])
--產品說明>價格說明or資訊?
ALTER TABLE Dc2..byrlu ADD CONSTRAINT CNo_With_CM UNIQUE ([客戶編號], [客戶型號]);
INSERT INTO Dc2..byrlu with(tablock)
SELECT [序號], (SELECT TOP 1 C.[序號] FROM Dc2..suplu C WHERE C.[廠商編號] = P.[廠商編號] AND C.[頤坊型號] = P.[頤坊型號]) [SUPLU_SEQ], 
	[開發中], RTRIM([客戶編號]), RTRIM([客戶簡稱]), RTRIM([頤坊型號]), RTRIM([客戶型號]), RTRIM([產品說明]), RTRIM([單位]), [最後單價日], [美元單價], [台幣單價], [單價_2], [單價_3], [單價_4], [單價_5], 
	[min_1], [min_2], [min_3], [min_4], [min_5],[外幣幣別], [外幣單價], RTRIM([廠商編號]), RTRIM([廠商簡稱]), RTRIM([稅則號碼]), RTRIM([商標]), [停用日期], RTRIM([備註]), 
	(SELECT RTRIM([變更記錄]) FROM Bc2..byrlu4 BB WHERE BB.byrlu序號 = P.序號) [變更記錄],
	[變更日期], RTRIM([更新人員]), [更新日期]
FROM Bc2..byrlu P;



USE Dc2; 
GO
--DROP TRIGGER [TRI_byrlu_AU] 
CREATE TRIGGER [TRI_byrlu_AU] ON [dbo].[byrlu]
AFTER UPDATE
AS
/*
頤坊型號
廠商編號
產品說明--價格說明
單位
客戶型號
美元單價
台幣單價
外幣單價
單價_2
單價_3
單價_4
*/
DECLARE @SEQ bigint, @Change_Log NVARCHAR(MAX), 
		@OLD_IM VARCHAR(50), @NEW_IM VARCHAR(50), 
		@OLD_S_No VARCHAR(50), @NEW_S_No NVARCHAR(50), 
		@OLD_PI NVARCHAR(MAX), @NEW_PI NVARCHAR(MAX), 
		@OLD_Unit NVARCHAR(20), @NEW_Unit NVARCHAR(20),
		@OLD_CustM VARCHAR(50), @NEW_CustM VARCHAR(50), 
		@OLD_TWD_P NUMERIC(9,3), @NEW_TWD_P NUMERIC(9,3),
		@OLD_USD_P NUMERIC(9,3), @NEW_USD_P NUMERIC(9,3),
		@OLD_Curr_P NUMERIC(9,3), @NEW_Curr_P NUMERIC(9,3),
		@OLD_Price_2 NUMERIC(9,3), @NEW_Price_2 NUMERIC(9,3),
		@OLD_Price_3 NUMERIC(9,3), @NEW_Price_3 NUMERIC(9,3),
		@OLD_Price_4 NUMERIC(9,3), @NEW_Price_4 NUMERIC(9,3)
SELECT @SEQ = [序號], @Change_Log = ISNULL([變更記錄],''),
	   @OLD_IM = [頤坊型號],
	   @OLD_S_No = [廠商編號],
	   @OLD_PI = [產品說明],
	   @OLD_Unit = [單位],
	   @OLD_CustM = [客戶型號],
	   @OLD_TWD_P = [台幣單價],
	   @OLD_USD_P = [美元單價],
	   @OLD_Curr_P = [外幣單價],
	   @OLD_Price_2 = [單價_2],
	   @OLD_Price_3 = [單價_3],
	   @OLD_Price_4 = [單價_4]
FROM DELETED;
SELECT @NEW_IM = [頤坊型號],
	   @NEW_S_No = [廠商編號],
	   @NEW_PI = [產品說明],
	   @NEW_Unit = [單位],
	   @NEW_CustM = [客戶型號],
	   @NEW_TWD_P = [台幣單價],
	   @NEW_USD_P = [美元單價],
	   @NEW_Curr_P = [外幣單價],
	   @NEW_Price_2 = [單價_2],
	   @NEW_Price_3 = [單價_3],
	   @NEW_Price_4 = [單價_4]
FROM INSERTED;

BEGIN
	IF (@OLD_IM <> @NEW_IM)
	BEGIN
		SET @Change_Log += CHAR(10) + LEFT(RTRIM(CONVERT(VARCHAR(20),GETDATE(),20)),16) + ' ' + (SELECT [更新人員] FROM INSERTED) + ' 頤坊型號: ' + @OLD_IM + '  ->  '+ @NEW_IM
	END
	IF(@OLD_S_No <> @NEW_S_No)
	BEGIN
		SET @Change_Log += CHAR(10) + LEFT(RTRIM(CONVERT(VARCHAR(20),GETDATE(),20)),16) + ' ' + (SELECT [更新人員] FROM INSERTED) + ' 廠商編號: ' + @OLD_S_No + '  ->  '+ @NEW_S_No
	END
	IF(@OLD_PI <> @NEW_PI)
	BEGIN
		SET @Change_Log += CHAR(10) + LEFT(RTRIM(CONVERT(VARCHAR(20),GETDATE(),20)),16) + ' ' + (SELECT [更新人員] FROM INSERTED) + ' 產品說明: ' + @OLD_PI + '  ->  '+ @NEW_PI
	END
	IF(@OLD_Unit <> @NEW_Unit)
	BEGIN
		SET @Change_Log += CHAR(10) + LEFT(RTRIM(CONVERT(VARCHAR(20),GETDATE(),20)),16) + ' ' + (SELECT [更新人員] FROM INSERTED) + ' 單位: ' + @OLD_Unit + '  ->  '+ @NEW_Unit
	END
	IF(@OLD_CustM <> @NEW_CustM)
	BEGIN
		SET @Change_Log += CHAR(10) + LEFT(RTRIM(CONVERT(VARCHAR(20),GETDATE(),20)),16) + ' ' + (SELECT [更新人員] FROM INSERTED) + ' 客戶型號: ' + CAST(@OLD_CustM AS NVARCHAR(50)) + '  ->  '+ CAST(@NEW_CustM AS NVARCHAR(50))
	END
	IF(@OLD_TWD_P <> @NEW_TWD_P)
	BEGIN
		SET @Change_Log += CHAR(10) + LEFT(RTRIM(CONVERT(VARCHAR(20),GETDATE(),20)),16) + ' ' + (SELECT [更新人員] FROM INSERTED) + ' 台幣單價: ' + CAST(@OLD_TWD_P AS NVARCHAR(50)) + '  ->  '+ CAST(@NEW_TWD_P AS NVARCHAR(50))
	END
	IF(@OLD_USD_P <> @NEW_USD_P)
	BEGIN
		SET @Change_Log += CHAR(10) + LEFT(RTRIM(CONVERT(VARCHAR(20),GETDATE(),20)),16) + ' ' + (SELECT [更新人員] FROM INSERTED) + ' 美元單價: ' + CAST(@OLD_USD_P AS NVARCHAR(50)) + '  ->  '+ CAST(@NEW_USD_P AS NVARCHAR(50))
	END
	IF(@OLD_Curr_P <> @NEW_Curr_P)
	BEGIN
		SET @Change_Log += CHAR(10) + LEFT(RTRIM(CONVERT(VARCHAR(20),GETDATE(),20)),16) + ' ' + (SELECT [更新人員] FROM INSERTED) + ' 外幣單價: ' + CAST(@OLD_Curr_P AS NVARCHAR(50)) + '  ->  '+ CAST(@NEW_Curr_P AS NVARCHAR(50))
	END
	IF(@OLD_Price_2 <> @NEW_Price_2)
	BEGIN
		SET @Change_Log += CHAR(10) + LEFT(RTRIM(CONVERT(VARCHAR(20),GETDATE(),20)),16) + ' ' + (SELECT [更新人員] FROM INSERTED) + ' 單價_2: ' + CAST(@OLD_Price_2 AS NVARCHAR(50)) + '  ->  '+ CAST(@NEW_Price_2 AS NVARCHAR(50))
	END
	IF(@OLD_Price_3 <> @NEW_Price_3)
	BEGIN
		SET @Change_Log += CHAR(10) + LEFT(RTRIM(CONVERT(VARCHAR(20),GETDATE(),20)),16) + ' ' + (SELECT [更新人員] FROM INSERTED) + ' 單價_3: ' + CAST(@OLD_Price_3 AS NVARCHAR(50)) + '  ->  '+ CAST(@NEW_Price_3 AS NVARCHAR(50))
	END
	IF(@OLD_Price_4 <> @NEW_Price_4)
	BEGIN
		SET @Change_Log += CHAR(10) + LEFT(RTRIM(CONVERT(VARCHAR(20),GETDATE(),20)),16) + ' ' + (SELECT [更新人員] FROM INSERTED) + ' 單價_4: ' + CAST(@OLD_Price_4 AS NVARCHAR(50)) + '  ->  '+ CAST(@NEW_Price_4 AS NVARCHAR(50))
	END
	UPDATE Dc2..byrlu SET [變更記錄] = @Change_Log WHERE [序號] = @SEQ
END
