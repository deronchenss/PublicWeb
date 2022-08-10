/* 本機同步
SELECT TOP 1 * FROM Dc2..suplu
--UNION
SELECT TOP 1 * FROM [192.168.1.135].Dc2.dbo.suplu

INSERT INTO Dc2..suplu with(tablock)
SELECT * FROM [192.168.1.135].Dc2.dbo.suplu
*/
USE Dc2;
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[bom]') AND type in (N'U'))
BEGIN
	DROP TABLE Dc2..bom;
END
GO

CREATE TABLE [dbo].[bom](
	[序號] [int] NOT NULL,
	[SUPLU_SEQ] [INT] NOT NULL,--New
	[頤坊型號] [varchar](15) NULL,
	[開發中] [varchar](1) NULL,
	[最後完成者] [varchar](8) NULL,
	[完成者簡稱] [varchar](10) NULL,
	[備註] [varchar](320) NULL,
	[部門] [varchar](2) NULL,
	[變更日期] [datetime] NULL,
	[建立人員] [varchar](6) NULL,
	[建立日期] [datetime] NULL,
	[更新人員] [varchar](6) NULL,
	[更新日期] [datetime] NULL,
	[註記] [bit] NULL,--New
 CONSTRAINT [PK_bom] PRIMARY KEY CLUSTERED 
(
	[序號] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
SET ANSI_PADDING ON
CREATE NONCLUSTERED INDEX [IX_bom] ON [dbo].[bom]
(
	[頤坊型號] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
SET ANSI_PADDING ON
CREATE NONCLUSTERED INDEX [IX_bom_1] ON [dbo].[bom]
(
	[最後完成者] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
ALTER TABLE [dbo].[bom] ADD  CONSTRAINT [DF_bom_更新日期]  DEFAULT (getdate()) FOR [更新日期]
ALTER TABLE Dc2..bom ADD CONSTRAINT SUPLU_SEQ UNIQUE ([SUPLU_SEQ]);
CREATE INDEX BOM_IDX_SUPLU_SEQ ON Dc2..bom([SUPLU_SEQ])
CREATE INDEX BOM_IDX_SEQ ON Dc2..bom(序號)


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[bomsub]') AND type in (N'U'))
BEGIN
	DROP TABLE Dc2..bomsub;
END
GO
CREATE TABLE [dbo].[bomsub](
	[序號] [int] NOT NULL,
	[PARENT_SEQ] [int] NULL,--New
	[SUPLU_SEQ] [INT] NOT NULL,--New
	[D_SUPLU_SEQ] [INT] NULL,--New
	[頤坊型號] [varchar](15) NULL,
	[最後完成者] [varchar](8) NULL,
	[完成者簡稱] [varchar](10) NULL,
	[廠商編號] [varchar](8) NULL,
	[廠商簡稱] [varchar](10) NULL,
	[材料型號] [varchar](15) NULL,
	[材料用量] [decimal](9,4) NULL,
	[採購] [varchar](1) NULL,
	[轉入單位] [varchar](8) NULL,
	[半成品] [varchar](15) NULL,
	[原料] [bit] NULL,
	[階層] [int] NULL,
	[原料銷售] [bit] NULL,--New
	[不發單] [bit] NULL,--New
	[不展開] [bit] NULL,--New
	[不計成本] [bit] NULL,--New
	[變更日期] [datetime] NULL,
	[建立人員] [varchar](6) NULL,
	[建立日期] [datetime] NULL,
	[更新人員] [varchar](6) NULL,
	[更新日期] [datetime] NULL,
 CONSTRAINT [PK_bomsub] PRIMARY KEY CLUSTERED ([序號] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
SET ANSI_PADDING ON
CREATE NONCLUSTERED INDEX [IX_bomsub] ON [dbo].[bomsub]([頤坊型號] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
SET ANSI_PADDING ON
CREATE NONCLUSTERED INDEX [IX_bomsub_1] ON [dbo].[bomsub]([最後完成者] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
ALTER TABLE [dbo].[bomsub] ADD  CONSTRAINT [DF_bomsub_材料用量]  DEFAULT ((0)) FOR [材料用量]
ALTER TABLE [dbo].[bomsub] ADD  CONSTRAINT [DF_bomsub_更新日期]  DEFAULT (getdate()) FOR [更新日期]
CREATE INDEX bomsub_IDX_SUPLU_SEQ ON Dc2..bomsub([SUPLU_SEQ])
CREATE INDEX bomsub_IDX_D_SUPLU_SEQ ON Dc2..bomsub([D_SUPLU_SEQ])
CREATE INDEX bomsub_IDX_SEQ ON Dc2..bomsub(序號)
GO

INSERT INTO Dc2..bomsub with(tablock)
SELECT [序號], 
	CASE [階層]
		WHEN 1 THEN '0'
		WHEN 2 THEN (SELECT B.[序號] FROM Bc2..bomsub B WHERE A.[最後完成者] = B.[最後完成者] AND A.[頤坊型號] = B.[頤坊型號] AND B.[階層] = '1')
		WHEN 3 THEN (SELECT B.[序號] FROM Bc2..bomsub B WHERE A.[最後完成者] = B.[最後完成者] AND A.[頤坊型號] = B.[頤坊型號] AND B.[階層] = '2' AND B.[材料型號] = A.[半成品] AND A.[轉入單位] = B.[廠商編號])
		ELSE NULL END [上層序號], 
	(SELECT B.[序號] FROM Bc2..suplu2 B WHERE A.[最後完成者] = B.[廠商編號] AND A.[頤坊型號] = B.[頤坊型號]) [SUPLU_SEQ],
	(SELECT B.[序號] FROM Bc2..suplu2 B WHERE A.[材料型號] = B.[頤坊型號] AND A.[廠商編號] = B.[廠商編號])	[D_SUPLU_SEQ],
	RTRIM(CAST([頤坊型號] AS VARCHAR(15))) [頤坊型號], 
	RTRIM(CAST([最後完成者] AS VARCHAR(8))) [最後完成者], 
	RTRIM(CAST([完成者簡稱] AS VARCHAR(10))) [完成者簡稱], 
	RTRIM(CAST([廠商編號] AS VARCHAR(8))) [廠商編號],
	RTRIM(CAST([廠商簡稱] AS VARCHAR(10))) [廠商簡稱],
	RTRIM(CAST([材料型號] AS VARCHAR(15))) [材料型號],
	[材料用量], 
	RTRIM(CAST([採購] AS VARCHAR(1))) [採購],
	RTRIM(CAST([轉入單位] AS VARCHAR(8))) [轉入單位], 
	RTRIM(CAST([半成品] AS VARCHAR(15))) [半成品],
	[原料], [階層], 
	CAST(IIF(LEFT([轉入單位],1) = 'S',1,0) AS bit) [原料銷售], 
	CAST(0 AS bit) [不發單], CAST(0 AS bit) [不展開], 
	CAST(IIF(LEFT([轉入單位],1) = 'S',1,0) AS bit) [不計成本],
	[變更日期],
	RTRIM(CAST([更新人員] AS VARCHAR(6))) [建立人員],
	[更新日期] [建立日期],
	RTRIM(CAST([更新人員] AS VARCHAR(6))) [更新人員],
	[更新日期]
FROM Bc2..bomsub A
UPDATE Dc2..bomsub SET [階層] = 9 WHERE [PARENT_SEQ] IS NULL;

INSERT INTO Dc2..bom with(tablock)
SELECT [序號], 
	CAST( 
		(SELECT B.序號 
		 FROM Bc2..suplu2 B
		 WHERE A.最後完成者 = B.廠商編號 AND A.頤坊型號 = B.頤坊型號
	) AS BIGINT) [SUPLU_SEQ],
	RTRIM(CAST([頤坊型號] AS varchar(15))) [頤坊型號], 
	RTRIM(CAST([開發中] AS VARCHAR(1))) [開發中],
	RTRIM(CAST([最後完成者] AS VARCHAR(8))) [最後完成者],
	RTRIM(CAST([完成者簡稱] AS VARCHAR(10))) [完成者簡稱],
	[備註], 
	RTRIM(CAST([部門] AS VARCHAR(2))) [部門],
	[變更日期],
	RTRIM(CAST([更新人員] AS VARCHAR(6))) [建立人員],
	[更新日期] [建立日期],
	RTRIM(CAST([更新人員] AS VARCHAR(6))) [更新人員],
	[更新日期],
	CAST(0 AS BIT) [註記] --註記需等Detail同步後
FROM Bc2..bom A
UPDATE Dc2..bom SET [註記] = 1, [開發中] = 'Y' WHERE SUPLU_SEQ IN (SELECT SUPLU_SEQ FROM Dc2..bomsub WHERE [階層] = 9)
--UPDATE Dc2..suplu SET [開發中] = 'Y' WHERE [序號] IN (SELECT [P_SEQ] FROM Dc2..bom WHERE [開發中] = 'Y')


--SELECT TOP 1 * FROM bom
--SELECT TOP 1 * FROM bomsub
