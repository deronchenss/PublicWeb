
--********************************

--SELECT * FROM [192.168.1.135].Bc2.dbo.suplu_ean
--20220630-Will_Add MSRP前期, MSRP下期  By Suplu_Ean
--20220701-Dc2..suplu 客戶型號>銷售型號
--MSRPV2&價格等級V2Del, +價格等級前期
--20220725-Rename 非產品>不計庫存

--EXEC sp_rename 'dbo.suplu.非產品', '不計庫存', 'COLUMN';
--UPDATE Dc2..suplu SET 不計庫存 = 1 WHERE 廠商編號 = 'E-6001'

--20220802-ALTER TABLE Dc2..suplu ALTER COLUMN 廠商型號 NVARCHAR(20)


--********************************
--TRUNCATE TABLE Dc2.dbo.suplu
--ALTER TABLE Dc2..suplu ADD [產品詳述] varchar(560)
--DROP TABLE Dc2.dbo.suplu
--ALTER TABLE Dc2.dbo.suplu ADD [製造規格] varchar(4096)
--ALTER TABLE Dc2..suplu ALTER COLUMN [變更記錄] NVARCHAR(MAX)
--ALTER TABLE Dc2..suplu ADD [申請原因] NVARCHAR(50)--20220614

--use Dc2  
--EXEC sp_rename 'dbo.suplu.內箱包裝數', '內盒容量', 'COLUMN';
--EXEC sp_rename 'dbo.suplu.外箱包裝數', '內盒數', 'COLUMN';
--EXEC sp_rename 'dbo.suplu.深長', '產品長度', 'COLUMN';
--EXEC sp_rename 'dbo.suplu.面寬', '產品寬度', 'COLUMN';
--EXEC sp_rename 'dbo.suplu.高度', '產品高度', 'COLUMN';

INSERT INTO Dc2.dbo.suplu with(tablock)
([序號], [unactive], [開發中], [帳務分類], [不計庫存], 
	[新增日期], [廠商編號], [廠商簡稱], [頤坊型號], [頤坊條碼], 
	[廠商型號], [暫時型號], [產品說明], [單位], [最後單價日], [台幣單價], [美元單價], 
	[單價_2], [單價_3], [min_1], [min_2], [min_3], [外幣幣別], 
	[外幣單價], [外幣單價_2], [外幣單價_3], [進口稅則], [進口稅率], 
	[申請放行],
	[單價核准], [企劃核准], [點收核准], [大貨庫存數], [大貨安全數], [快取庫存數], 
	[快取安全數], [台北庫存數], [台北安全數], [台中庫存數], [台中安全數], [高雄庫存數], [高雄安全數], 
	[ISP庫存數], [ISP安全數], [ISP單價], [ISP比較單價], 
	[IBU庫存數], [IBU安全數], [IBU單價], [IBU比較單價], 
	[ITW庫存數], [ITW安全數], [ITW單價], [ITW比較單價], 
	[廠商庫存數], [樣品庫存數], [內湖庫存數], [展示庫存數], [留底庫存數], 
	[展場庫存數], [設計庫存數], [分配庫存數], [分配裝配數], [託管庫存數], 
	[大貨庫位], [大貨庫更], [快取庫位], [台北庫位], [台中庫位], [高雄庫位], [廠商庫位], 
	[樣品庫位], [內湖庫位], [展示庫位], [留底庫位], [展場庫位], [設計庫位], [託管庫位], [內盒容量], [內盒數], [內箱數], 
	[外箱長度], [外箱寬度], [外箱高度], [外箱編號], 
	[單位淨重], [單位毛重], [產品長度], [產品寬度], [產品高度], [包裝深長], [包裝面寬], [包裝高度], 
	[紙箱重量], [淨重], [毛重], [工時], 
	[銷售型號], [虛擬商品], [國際條碼], [產品一階], [產品二階], [產品三階], [一階V3], [二階V3], [價格等級], 
	[價格等級_2021], [價格等級_2022],
	[產品狀態], [簡短說明], [產地], [商標ISP], [稅則ISP], [樣式], 
	[自有條碼], [自有標籤], [寄送袋子], [寄送吊卡], [自備袋子], [自備吊卡], [特殊包裝], 
	[條碼印價], [CP65], [年齡], [英文說明], [條碼英文一], [條碼英文二], 
	[英文ISP], [中文ITW], [英文單位], [產品分類], [台幣單價_1], [台幣單價_2], [台幣單價_3],
	[皮革材數], [皮革單價], [參考號碼],
	[MSRP啟用], [MSRP到期], [MSRP], [MSRPV2], [MSRP_2021], [MSRP_2022], [MSRP_ITW_手動], [設計人員], [設計圖號], [圖型啟用],
	[SQLP日期], [最後點收日], [停用日期], [備註給採購], [備註給開發], [備註給倉庫], [變更記錄], [變更日期], [更新日期], [更新人員], [產品詳述], [製造規格])
SELECT 
	a.[序號], a.[unactive], a.[開發中], a.[帳務分類], a.[非產品_下次版本] [不計庫存], 
	a.[新增日期], a.[廠商編號], a.[廠商簡稱], a.[頤坊型號], a.[頤坊條碼], 
	a.[廠商型號], a.[暫時型號], a.[產品說明], a.[單位], a.[最後單價日], a.[台幣單價], a.[美元單價], 
	a.[單價_2], a.[單價_3], a.[min_1], a.[min_2], a.[min_3], a.[外幣幣別], 
	a.[外幣單價], a.[外幣單價_2], a.[外幣單價_3], a.[進口稅則], a.[進口稅率], 
	b.[申請放行],
	b.[單價核准], b.[企劃核准], b.[點收核准], b.[大貨庫存數], b.[大貨安全數], b.[快取庫存數], 
	b.[快取安全數], b.[台北庫存數], b.[台北安全數], b.[台中庫存數], b.[台中安全數], b.[高雄庫存數], b.[高雄安全數], 
	b.[ISP庫存數], b.[ISP安全數], b.[ISP單價], b.[ISP比較單價], 
	b.[IBU庫存數], b.[IBU安全數], b.[IBU單價], b.[IBU比較單價], 
	b.[ITW庫存數], b.[ITW安全數], b.[ITW單價], b.[ITW比較單價], 
	b.[廠商庫存數], b.[樣品庫存數], b.[內湖庫存數], b.[展示庫存數], b.[留底庫存數], 
	b.[展場庫存數], b.[設計庫存數], b.[分配庫存數], b.[分配裝配數], b.[託管庫存數], 
	b.[大貨庫位], b.[大貨庫更], b.[快取庫位], b.[台北庫位], b.[台中庫位], b.[高雄庫位], b.[廠商庫位], 
	b.[樣品庫位], b.[內湖庫位], b.[展示庫位], b.[留底庫位], b.[展場庫位], b.[設計庫位], b.[託管庫位], b.[內箱包裝數], b.[外箱包裝數], b.[內箱數], 
	b.[外箱長度], b.[外箱寬度], b.[外箱高度],	b.[外箱編號], 
	b.[單位重量] [單位淨重], b.[單位毛重], b.[深長], b.[面寬], b.[高度], b.[包裝深長], b.[包裝面寬], b.[包裝高度], 
	b.[紙箱重量], b.[淨重], b.[毛重], b.[工時], 
	c.[客戶型號], c.[虛擬商品], c.[國際條碼], c.[產品一階], c.[產品二階], c.[產品三階], c.[一階V3], c.[二階V3], c.[價格等級], 
	d.[價格等級_2021], d.[價格等級_2022],
	c.[產品狀態], c.[簡短說明], c.[產地], c.[商標ISP], c.[稅則ISP], c.[樣式], 
	c.[自有條碼], c.[自有標籤], c.[寄送袋子], c.[寄送吊卡], c.[自備袋子], c.[自備吊卡], c.[特殊包裝], 
	c.[條碼印價], c.[CP65], c.[年齡], c.[英文說明], d.[英文說明] [條碼英文一], d.[英文說明二] [條碼英文二], 
	c.[英文ISP], c.[中文ITW], c.[英文單位], e.[產品分類], e.[台幣單價_1], e.[台幣單價_2], e.[台幣單價_3],
	e.[皮革材數], e.[皮革單價], d.[參考號碼],
	d.[MSRP啟用], d.[MSRP到期], d.[MSRP], d.[MSRPV2], d.[MSRP_2021], d.[MSRP_2022], d.[MSRP_ITW_手動], a.[設計人員], a.[設計圖號], a.[圖型啟用],
	a.[SQLP日期], a.[最後點收日], a.[停用日期], a.[備註給採購], a.[備註給開發], b.[備註給倉庫], c.[變更記錄], c.[變更日期], a.[更新日期], a.[更新人員], b.[產品詳述], f.[製造規格]
FROM Bc2.dbo.suplu2 a
	INNER JOIN Bc2.dbo.suplu3 b ON a.[廠商編號] = b.[廠商編號] AND a.[頤坊型號] = b.[頤坊型號]
	INNER JOIN Bc2.dbo.suplu4 c ON a.[廠商編號] = c.[廠商編號] AND a.[頤坊型號] = c.[頤坊型號]
	LEFT JOIN Bc2.dbo.suplu_ean d ON a.[廠商編號] = d.[廠商編號] AND a.[頤坊型號] = d.[頤坊型號] AND ISNULL(已刪除,0) <> '1'
	LEFT JOIN Bc2.dbo.byrlu_RT e ON a.[廠商編號] = e.[廠商編號] AND a.[頤坊型號]= e.[頤坊型號] AND (e.[停用日期] <= GETDATE() OR e.[停用日期] IS NULL)
	LEFT JOIN Bc2..Spec f ON a.[廠商編號] = f.[廠商編號] AND a.[頤坊型號] = f.[頤坊型號]
GO
USE Dc2;	
GO
CREATE TRIGGER [TRI_suplu_AIU] ON [dbo].[suplu]
AFTER INSERT, UPDATE
AS
DECLARE @SEQ bigint, @S_Date DATETIME, @P_Status VARCHAR(20), @O_S_Date DATETIME, @O_P_Status VARCHAR(20);
BEGIN
	IF EXISTS(SELECT [序號] FROM INSERTED)
	BEGIN
		SELECT @SEQ = [序號], @S_Date = [停用日期], @P_Status = [產品狀態] FROM INSERTED;
		SELECT @O_S_Date = [停用日期], @O_P_Status = [產品狀態] FROM DELETED;
		IF(@O_S_Date IS NOT NULL AND @S_Date IS NULL)
		BEGIN
			UPDATE Dc2..suplu SET [產品狀態] = 'A' WHERE [序號] = @SEQ;
		END
		IF(@O_S_Date IS NULL AND @S_Date IS NOT NULL)
		BEGIN
			UPDATE Dc2..suplu SET [產品狀態] = 'D' WHERE [序號] = @SEQ;
		END
		IF(@P_Status <> @O_P_Status AND @P_Status = 'D')
		BEGIN
			UPDATE Dc2..suplu SET [停用日期] = GETDATE() WHERE [序號] = @SEQ;
		END
		IF(@P_Status <> @O_P_Status AND @P_Status = 'A')
		BEGIN
			UPDATE Dc2..suplu SET [停用日期] = NULL WHERE [序號] = @SEQ;
		END
	END
END

GO

--------------------------------------AU
USE [Dc2]
GO
--DROP TRIGGER [dbo].[TRI_suplu_AU]
GO
CREATE TRIGGER [dbo].[TRI_suplu_AU] ON [dbo].[suplu]
AFTER UPDATE
AS
DECLARE @SEQ bigint, @Change_Log NVARCHAR(MAX), @DVN VARCHAR(1),
		@OLD_IM VARCHAR(50), @NEW_IM VARCHAR(50), 
		@OLD_S_No VARCHAR(50), @NEW_S_No NVARCHAR(50), 
		@OLD_PI NVARCHAR(MAX), @NEW_PI NVARCHAR(MAX), 
		@OLD_Unit NVARCHAR(20), @NEW_Unit NVARCHAR(20),
		@OLD_TWD_P NUMERIC(9,3), @NEW_TWD_P NUMERIC(9,3),
		@OLD_USD_P NUMERIC(9,3), @NEW_USD_P NUMERIC(9,3),
		@OLD_Price_2 NUMERIC(9,3), @NEW_Price_2 NUMERIC(9,3),
		@OLD_Price_3 NUMERIC(9,3), @NEW_Price_3 NUMERIC(9,3),
		@OLD_MIN_1 INT, @NEW_MIN_1 INT,
		@OLD_MIN_2 INT, @NEW_MIN_2 INT,
		@OLD_MIN_3 INT, @NEW_MIN_3 INT,
		@OLD_Curr NUMERIC(9,3), @NEW_Curr NUMERIC(9,3),
		@OLD_Curr_2 NUMERIC(9,3), @NEW_Curr_2 NUMERIC(9,3),
		@OLD_Curr_3 NUMERIC(9,3), @NEW_Curr_3 NUMERIC(9,3),
		@OLD_SM VARCHAR(50), @NEW_SM VARCHAR(50),
		@OLD_DVN BIT, @NEW_DVN BIT
SELECT @SEQ = [序號],
	   @Change_Log = [變更記錄],
	   @DVN = [開發中],
	   @OLD_IM = [頤坊型號],
	   @OLD_S_No = [廠商編號],
	   @OLD_PI = [產品說明],
	   @OLD_Unit = [單位],
	   @OLD_TWD_P = [台幣單價],
	   @OLD_USD_P = [美元單價],
	   @OLD_Price_2 = [單價_2],
	   @OLD_Price_3 = [單價_3],
	   @OLD_MIN_1 = [min_1],
	   @OLD_MIN_2 = [min_2],
	   @OLD_MIN_3 = [min_3],
	   @OLD_Curr = [外幣單價],
	   @OLD_Curr_2 = [外幣單價_2],
	   @OLD_Curr_3 = [外幣單價_3],
	   @OLD_SM = [廠商型號]
FROM DELETED;
SELECT @NEW_IM = [頤坊型號],
	   @NEW_S_No = [廠商編號],
	   @NEW_PI = [產品說明],
	   @NEW_Unit = [單位],
	   @NEW_TWD_P = [台幣單價],
	   @NEW_USD_P = [美元單價],
	   @NEW_Price_2 = [單價_2],
	   @NEW_Price_3 = [單價_3],
	   @NEW_MIN_1 = [min_1],
	   @NEW_MIN_2 = [min_2],
	   @NEW_MIN_3 = [min_3],
	   @NEW_Curr = [外幣單價],
	   @NEW_Curr_2 = [外幣單價_2],
	   @NEW_Curr_3 = [外幣單價_3],
	   @NEW_SM = [廠商型號]
FROM INSERTED;
BEGIN
	IF (@OLD_IM <> @NEW_IM)
	BEGIN
		SET @DVN = 'Y'
		SET @Change_Log += CHAR(10) + LEFT(RTRIM(CONVERT(VARCHAR(20),GETDATE(),20)),16) + ' ' + (SELECT [更新人員] FROM INSERTED) + ' 頤坊型號: ' + @OLD_IM + '  ->  '+ @NEW_IM
	END
	IF(@OLD_S_No <> @NEW_S_No)
	BEGIN
		SET @DVN = 'Y'
		SET @Change_Log += CHAR(10) + LEFT(RTRIM(CONVERT(VARCHAR(20),GETDATE(),20)),16) + ' ' + (SELECT [更新人員] FROM INSERTED) + ' 廠商編號: ' + @OLD_S_No + '  ->  '+ @NEW_S_No
	END
	IF(@OLD_PI <> @NEW_PI)
	BEGIN
		SET @DVN = 'Y'
		SET @Change_Log += CHAR(10) + LEFT(RTRIM(CONVERT(VARCHAR(20),GETDATE(),20)),16) + ' ' + (SELECT [更新人員] FROM INSERTED) + ' 產品說明: ' + @OLD_PI + '  ->  '+ @NEW_PI
	END
	IF(@OLD_Unit <> @NEW_Unit)
	BEGIN
		SET @DVN = 'Y'
		SET @Change_Log += CHAR(10) + LEFT(RTRIM(CONVERT(VARCHAR(20),GETDATE(),20)),16) + ' ' + (SELECT [更新人員] FROM INSERTED) + ' 單位: ' + @OLD_Unit + '  ->  '+ @NEW_Unit
	END
	IF(@OLD_TWD_P <> @NEW_TWD_P)
	BEGIN
		SET @DVN = 'Y'
		SET @Change_Log += CHAR(10) + LEFT(RTRIM(CONVERT(VARCHAR(20),GETDATE(),20)),16) + ' ' + (SELECT [更新人員] FROM INSERTED) + ' 台幣單價: ' + CAST(@OLD_TWD_P AS NVARCHAR(50)) + '  ->  '+ CAST(@NEW_TWD_P AS NVARCHAR(50))
	END
	IF(@OLD_USD_P <> @NEW_USD_P)
	BEGIN
		SET @DVN = 'Y'
		SET @Change_Log += CHAR(10) + LEFT(RTRIM(CONVERT(VARCHAR(20),GETDATE(),20)),16) + ' ' + (SELECT [更新人員] FROM INSERTED) + ' 美元單價: ' + CAST(@OLD_USD_P AS NVARCHAR(50)) + '  ->  '+ CAST(@NEW_USD_P AS NVARCHAR(50))
	END
	IF(@OLD_Price_2 <> @NEW_Price_2)
	BEGIN
		SET @DVN = 'Y'
		SET @Change_Log += CHAR(10) + LEFT(RTRIM(CONVERT(VARCHAR(20),GETDATE(),20)),16) + ' ' + (SELECT [更新人員] FROM INSERTED) + ' 單價_2: ' + CAST(@OLD_Price_2 AS NVARCHAR(50)) + '  ->  '+ CAST(@NEW_Price_2 AS NVARCHAR(50))
	END
	IF(@OLD_Price_3 <> @NEW_Price_3)
	BEGIN
		SET @DVN = 'Y'
		SET @Change_Log += CHAR(10) + LEFT(RTRIM(CONVERT(VARCHAR(20),GETDATE(),20)),16) + ' ' + (SELECT [更新人員] FROM INSERTED) + ' 單價_3: ' + CAST(@OLD_Price_3 AS NVARCHAR(50)) + '  ->  '+ CAST(@NEW_Price_3 AS NVARCHAR(50))
	END
	IF(@OLD_MIN_1 <> @NEW_MIN_1)
	BEGIN
		SET @DVN = 'Y'
		SET @Change_Log += CHAR(10) + LEFT(RTRIM(CONVERT(VARCHAR(20),GETDATE(),20)),16) + ' ' + (SELECT [更新人員] FROM INSERTED) + ' min_1: ' + CAST(@OLD_MIN_1 AS NVARCHAR(50)) + '  ->  '+ CAST(@NEW_MIN_1 AS NVARCHAR(50))
	END
	IF(@OLD_MIN_2 <> @NEW_MIN_2)
	BEGIN
		SET @DVN = 'Y'
		SET @Change_Log += CHAR(10) + LEFT(RTRIM(CONVERT(VARCHAR(20),GETDATE(),20)),16) + ' ' + (SELECT [更新人員] FROM INSERTED) + ' min_2: ' + CAST(@OLD_MIN_2 AS NVARCHAR(50)) + '  ->  '+ CAST(@NEW_MIN_2 AS NVARCHAR(50))
	END
	IF(@OLD_MIN_3 <> @NEW_MIN_3)
	BEGIN
		SET @DVN = 'Y'
		SET @Change_Log += CHAR(10) + LEFT(RTRIM(CONVERT(VARCHAR(20),GETDATE(),20)),16) + ' ' + (SELECT [更新人員] FROM INSERTED) + ' min_3: ' + CAST(@OLD_MIN_3 AS NVARCHAR(50)) + '  ->  '+ CAST(@NEW_MIN_3 AS NVARCHAR(50))
	END
	IF(@OLD_Curr <> @NEW_Curr)
	BEGIN
		SET @DVN = 'Y'
		SET @Change_Log += CHAR(10) + LEFT(RTRIM(CONVERT(VARCHAR(20),GETDATE(),20)),16) + ' ' + (SELECT [更新人員] FROM INSERTED) + ' 外幣單價: ' + CAST(@OLD_Curr AS NVARCHAR(50)) + '  ->  '+ CAST(@NEW_Curr AS NVARCHAR(50))
	END
	IF(@OLD_Curr_2 <> @NEW_Curr_2)
	BEGIN
		SET @DVN = 'Y'
		SET @Change_Log += CHAR(10) + LEFT(RTRIM(CONVERT(VARCHAR(20),GETDATE(),20)),16) + ' ' + (SELECT [更新人員] FROM INSERTED) + ' 外幣單價_2: ' + CAST(@OLD_Curr_2 AS NVARCHAR(50)) + '  ->  '+ CAST(@NEW_Curr_2 AS NVARCHAR(50))
	END
	IF(@OLD_Curr_3 <> @NEW_Curr_3)
	BEGIN
		SET @DVN = 'Y'
		SET @Change_Log += CHAR(10) + LEFT(RTRIM(CONVERT(VARCHAR(20),GETDATE(),20)),16) + ' ' + (SELECT [更新人員] FROM INSERTED) + ' 外幣單價_3: ' + CAST(@OLD_Curr_3 AS NVARCHAR(50)) + '  ->  '+ CAST(@NEW_Curr_3 AS NVARCHAR(50))
	END
	IF(@OLD_SM <> @NEW_SM)
	BEGIN
		SET @DVN = 'Y'
		SET @Change_Log += CHAR(10) + LEFT(RTRIM(CONVERT(VARCHAR(20),GETDATE(),20)),16) + ' ' + (SELECT [更新人員] FROM INSERTED) + ' 廠商型號: ' + @OLD_SM + '  ->  '+ @NEW_SM
	END
	--審核放行
	IF(@DVN = 'R' AND (SELECT [開發中] FROM INSERTED) = 'N')
	BEGIN--日期?
		SET @DVN = 'N'
		SET @Change_Log += CHAR(10) + LEFT(RTRIM(CONVERT(VARCHAR(20),GETDATE(),20)),16) + ' ' + (SELECT [更新人員] FROM INSERTED) + ' 申請放行, 申請原因: '+ (SELECT [申請原因] FROM INSERTED)
	END
	--申請放行
	IF(@DVN = 'Y' AND (SELECT [開發中] FROM INSERTED) = 'R')
	BEGIN
		SET @DVN = 'R'
	END
	UPDATE Dc2..suplu SET [開發中] = @DVN, [變更記錄] = @Change_Log WHERE [序號] = @SEQ
	IF( (SELECT [變更記錄] FROM DELETED) <> @Change_Log)
	BEGIN
		UPDATE Dc2..suplu SET [更新人員] = (SELECT [更新人員] FROM INSERTED), [更新日期] = GETDATE() WHERE [序號] = @SEQ
	END
END
GO

ALTER TABLE [dbo].[suplu] ENABLE TRIGGER [TRI_suplu_AU]
GO

----------------------------------------------------------------------------AU_END


GO
CREATE NONCLUSTERED INDEX [suplu_IDX1] ON [dbo].[suplu]
(
	[更新日期] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO

SET ANSI_PADDING ON
GO

CREATE NONCLUSTERED INDEX [suplu_IDX2] ON [dbo].[suplu]
(
	[頤坊型號] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO

SET ANSI_PADDING ON
GO

CREATE NONCLUSTERED INDEX [suplu_IDX3] ON [dbo].[suplu]
(
	[廠商編號] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO

--ALTER TABLE [dbo].[suplu] ADD  CONSTRAINT [DF_suplu_台幣單價]  DEFAULT ((0)) FOR [台幣單價]
--GO

--ALTER TABLE [dbo].[suplu] ADD  CONSTRAINT [DF_suplu_美元單價]  DEFAULT ((0)) FOR [美元單價]
--GO

--ALTER TABLE [dbo].[suplu] ADD  CONSTRAINT [DF_suplu_單價_2]  DEFAULT ((0)) FOR [單價_2]
--GO

--ALTER TABLE [dbo].[suplu] ADD  CONSTRAINT [DF_suplu_單價_3]  DEFAULT ((0)) FOR [單價_3]
--GO

--ALTER TABLE [dbo].[suplu] ADD  CONSTRAINT [DF_suplu_min_1]  DEFAULT ((0)) FOR [min_1]
--GO

--ALTER TABLE [dbo].[suplu] ADD  CONSTRAINT [DF_suplu_min_2]  DEFAULT ((0)) FOR [min_2]
--GO

--ALTER TABLE [dbo].[suplu] ADD  CONSTRAINT [DF_suplu_min_3]  DEFAULT ((0)) FOR [min_3]
--GO

--ALTER TABLE [dbo].[suplu] ADD  CONSTRAINT [DF_suplu_外幣單價]  DEFAULT ((0)) FOR [外幣單價]
--GO

--ALTER TABLE [dbo].[suplu] ADD  CONSTRAINT [DF_suplu_外幣單價_2]  DEFAULT ((0)) FOR [外幣單價_2]
--GO

--ALTER TABLE [dbo].[suplu] ADD  CONSTRAINT [DF_suplu_外幣單價_3]  DEFAULT ((0)) FOR [外幣單價_3]
--GO

--ALTER TABLE [dbo].[suplu] ADD  CONSTRAINT [DF_suplu_新增日期]  DEFAULT (getdate()) FOR [新增日期]
--GO

--ALTER TABLE [dbo].[suplu] ADD  CONSTRAINT [DF_suplu_更新日期]  DEFAULT (getdate()) FOR [更新日期]
--GO
