USE [Dc2]
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[refdata]') AND type in (N'U'))
DROP TABLE [dbo].[refdata]
GO

CREATE TABLE [dbo].[refdata](
	[序號] [int] NOT NULL,
	[代碼] [varchar](14) NULL,
	[內容] [varchar](50) NULL,
	[參考] [varchar](14) NULL,
	[停用] [bit] NULL,
	[Chk_BYR_Del] [bit] NULL,
	[備註] [varchar](250) NULL,
	[變更日期] [datetime] NULL,
	[更新人員] [varchar](6) NULL,
	[更新日期] [datetime] NULL,
 CONSTRAINT [PK_refdata] PRIMARY KEY CLUSTERED 
(
	[序號] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE INDEX REFDATA_IDX_CODE ON Dc2..refdata([代碼])
ALTER TABLE [dbo].[refdata] ADD  CONSTRAINT [DF_refdata_更新日期]  DEFAULT (getdate()) FOR [更新日期]
GO

INSERT INTO Dc2..refdata
SELECT [序號], RTRIM([代碼]), RTRIM([內容]), RTRIM([參考]), [停用], [Chk_BYR_Del], RTRIM([備註]), [變更日期], [更新人員], [更新日期]
FROM Bc2..refdata

INSERT INTO Dc2..refdata([序號], [代碼], [內容], [更新人員], [更新日期])
SELECT (SELECT COALESCE(MAX([序號]),0) FROM Dc2..refdata) +1, 'PUR_Rate', '28.5', 'Ivan10', GETDATE()
UNION ALL SELECT (SELECT COALESCE(MAX([序號]),0) FROM Dc2..refdata) +2, 'ORD_Rate', '30', 'Ivan10', GETDATE();

INSERT INTO Dc2..refdata([序號], [代碼], [內容], [備註], [更新人員], [更新日期])
SELECT (SELECT COALESCE(MAX([序號]),0) FROM Dc2..refdata) +1, '交貨地點', '台北市內湖區洲子街100號4樓', '內湖', 'Ivan10', GETDATE()
UNION ALL SELECT (SELECT COALESCE(MAX([序號]),0) FROM Dc2..refdata) +2, '交貨地點', '新北市汐止區福德一路393巷32號', '汐止', 'Ivan10', GETDATE();

INSERT INTO Dc2..refdata([序號], [代碼], [內容], [更新人員], [更新日期])
SELECT [序號] = (SELECT COALESCE(MAX([序號]),0) FROM Dc2..refdata) + ROW_NUMBER() OVER (ORDER BY T.[內容]), 
	   [代碼] = '內銷條碼', 
	   T.[內容],
	   [更新人員] = 'Ivan10',
	   [更新日期] = GETDATE()
FROM (
SELECT'IV01 (IVAN W38mm*H28mm*2)' [內容]
UNION ALL SELECT'IV02 (IVAN染料專用紙)'
UNION ALL SELECT'IV05 (IVAN W35mm*H20mm*2)'
UNION ALL SELECT'IV06 (IVAN W38mm*H40mm*2)'
UNION ALL SELECT'IV07 (MakerAid W65mm*28mm)'
UNION ALL SELECT'IV08 (工廠皮條 W38mm*H12mm*2)'
--UNION ALL SELECT'無'
) T;

--20220912
UPDATE Dc2..refdata SET 停用 = '1' WHERE 代碼 = '內銷條碼' AND 內容 = 'IV02 (IVAN染料專用紙)';

INSERT INTO Dc2..refdata([序號], [代碼], [內容], [更新人員], [更新日期])
SELECT [序號] = (SELECT COALESCE(MAX([序號]),0) FROM Dc2..refdata) + ROW_NUMBER() OVER (ORDER BY T.[內容]), 
	   [代碼] = '條碼', 
	   T.[內容],
	   [更新人員] = 'Ivan10',
	   [更新日期] = GETDATE()
FROM (
SELECT 'IV05 (IVAN W35mm*H20mm*2)' [內容]
UNION ALL SELECT 'IV06 (IVAN W38mm*H40mm*2)'
UNION ALL SELECT 'IV07 (MakerAid W65mm*28mm)'
UNION ALL SELECT 'IV08 (工廠皮條 W38mm*H12mm*2)'
UNION ALL SELECT 'TL01 (+AGE H40mm)'
UNION ALL SELECT 'TL02 (+西語 H40mm)'
UNION ALL SELECT 'TL03 (+CP65 H40mm)'
UNION ALL SELECT 'TLA3 (+AGE H28mm)'
UNION ALL SELECT 'C128 (JCA H40mm)'
UNION ALL SELECT 'C129 (TLF H40mm)'
UNION ALL SELECT 'C130 (TLF +CP65 H40mm)'
UNION ALL SELECT 'M1-M (M&F白紙 H28mm)'
UNION ALL SELECT 'M1-N (NOCONA白紙 H28mm)'
UNION ALL SELECT 'M2-M (M&F啞鈴)'
UNION ALL SELECT 'M2-N (NOCONA啞鈴)'
UNION ALL SELECT 'M3-M (M&F卡紙)'
UNION ALL SELECT 'M3-N (NOCONA卡紙)'
UNION ALL SELECT 'M4-M (M&F LO)'
UNION ALL SELECT 'M4-N (NOCONA LO)'
UNION ALL SELECT 'M5-M (M&F布標)'
UNION ALL SELECT 'M5-N (NOCONA布標)'
UNION ALL SELECT 'M6   (M&F W35mm*H20mm*2)'
UNION ALL SELECT 'M7   (M&F W20mm*H15mm*3)'
UNION ALL SELECT 'NO8T (TLF啞鈴)'
UNION ALL SELECT 'ST01 (UPC通用版 H28mm)'
UNION ALL SELECT '白JA (JARIR白紙 H28mm)'
UNION ALL SELECT '白JB (JOHN BEAD H28mm)'
UNION ALL SELECT '白M5 (M&F內袋條碼 H28mm)'
UNION ALL SELECT 'S-白 (TLF酒壺 W20mm*H15mm*3)'
UNION ALL SELECT 'EN13 (RMW H28mm)'
UNION ALL SELECT 'EN14 (SLOJD H28mm)'
UNION ALL SELECT 'EN15 (RMW-CG287.NI/AE H28mm)'
UNION ALL SELECT 'HL01 (HOBBY外箱W77mm*H60mm)'
--UNION ALL SELECT '無'
) T;

--20220912
UPDATE Dc2..refdata SET 停用 = '1' WHERE 代碼 = '條碼' AND 內容 = 'S-白 (TLF酒壺 W20mm*H15mm*3)';