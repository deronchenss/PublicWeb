/* �����P�B
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
	[�Ǹ�] [int] NOT NULL,
	[SUPLU_SEQ] [INT] NOT NULL,--New
	[�[�{����] [varchar](15) NULL,
	[�}�o��] [varchar](1) NULL,
	[�̫᧹����] [varchar](8) NULL,
	[������²��] [varchar](10) NULL,
	[�Ƶ�] [varchar](320) NULL,
	[����] [varchar](2) NULL,
	[�ܧ���] [datetime] NULL,
	[�إߤH��] [varchar](6) NULL,
	[�إߤ��] [datetime] NULL,
	[��s�H��] [varchar](6) NULL,
	[��s���] [datetime] NULL,
	[���O] [bit] NULL,--New
 CONSTRAINT [PK_bom] PRIMARY KEY CLUSTERED 
(
	[�Ǹ�] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
SET ANSI_PADDING ON
CREATE NONCLUSTERED INDEX [IX_bom] ON [dbo].[bom]
(
	[�[�{����] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
SET ANSI_PADDING ON
CREATE NONCLUSTERED INDEX [IX_bom_1] ON [dbo].[bom]
(
	[�̫᧹����] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
ALTER TABLE [dbo].[bom] ADD  CONSTRAINT [DF_bom_��s���]  DEFAULT (getdate()) FOR [��s���]
ALTER TABLE Dc2..bom ADD CONSTRAINT SUPLU_SEQ UNIQUE ([SUPLU_SEQ]);
CREATE INDEX BOM_IDX_SUPLU_SEQ ON Dc2..bom([SUPLU_SEQ])
CREATE INDEX BOM_IDX_SEQ ON Dc2..bom(�Ǹ�)


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[bomsub]') AND type in (N'U'))
BEGIN
	DROP TABLE Dc2..bomsub;
END
GO
CREATE TABLE [dbo].[bomsub](
	[�Ǹ�] [int] NOT NULL,
	[PARENT_SEQ] [int] NULL,--New
	[SUPLU_SEQ] [INT] NOT NULL,--New
	[D_SUPLU_SEQ] [INT] NULL,--New
	[�[�{����] [varchar](15) NULL,
	[�̫᧹����] [varchar](8) NULL,
	[������²��] [varchar](10) NULL,
	[�t�ӽs��] [varchar](8) NULL,
	[�t��²��] [varchar](10) NULL,
	[���ƫ���] [varchar](15) NULL,
	[���ƥζq] [decimal](9,4) NULL,
	[����] [varchar](1) NULL,
	[��J���] [varchar](8) NULL,
	[�b���~] [varchar](15) NULL,
	[���] [bit] NULL,
	[���h] [int] NULL,
	[��ƾP��] [bit] NULL,--New
	[���o��] [bit] NULL,--New
	[���i�}] [bit] NULL,--New
	[���p����] [bit] NULL,--New
	[�ܧ���] [datetime] NULL,
	[�إߤH��] [varchar](6) NULL,
	[�إߤ��] [datetime] NULL,
	[��s�H��] [varchar](6) NULL,
	[��s���] [datetime] NULL,
 CONSTRAINT [PK_bomsub] PRIMARY KEY CLUSTERED ([�Ǹ�] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
SET ANSI_PADDING ON
CREATE NONCLUSTERED INDEX [IX_bomsub] ON [dbo].[bomsub]([�[�{����] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
SET ANSI_PADDING ON
CREATE NONCLUSTERED INDEX [IX_bomsub_1] ON [dbo].[bomsub]([�̫᧹����] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
ALTER TABLE [dbo].[bomsub] ADD  CONSTRAINT [DF_bomsub_���ƥζq]  DEFAULT ((0)) FOR [���ƥζq]
ALTER TABLE [dbo].[bomsub] ADD  CONSTRAINT [DF_bomsub_��s���]  DEFAULT (getdate()) FOR [��s���]
CREATE INDEX bomsub_IDX_SUPLU_SEQ ON Dc2..bomsub([SUPLU_SEQ])
CREATE INDEX bomsub_IDX_D_SUPLU_SEQ ON Dc2..bomsub([D_SUPLU_SEQ])
CREATE INDEX bomsub_IDX_SEQ ON Dc2..bomsub(�Ǹ�)
GO

INSERT INTO Dc2..bomsub with(tablock)
SELECT [�Ǹ�], 
	CASE [���h]
		WHEN 1 THEN '0'
		WHEN 2 THEN (SELECT B.[�Ǹ�] FROM Bc2..bomsub B WHERE A.[�̫᧹����] = B.[�̫᧹����] AND A.[�[�{����] = B.[�[�{����] AND B.[���h] = '1')
		WHEN 3 THEN (SELECT B.[�Ǹ�] FROM Bc2..bomsub B WHERE A.[�̫᧹����] = B.[�̫᧹����] AND A.[�[�{����] = B.[�[�{����] AND B.[���h] = '2' AND B.[���ƫ���] = A.[�b���~] AND A.[��J���] = B.[�t�ӽs��])
		ELSE NULL END [�W�h�Ǹ�], 
	(SELECT B.[�Ǹ�] FROM Bc2..suplu2 B WHERE A.[�̫᧹����] = B.[�t�ӽs��] AND A.[�[�{����] = B.[�[�{����]) [SUPLU_SEQ],
	(SELECT B.[�Ǹ�] FROM Bc2..suplu2 B WHERE A.[���ƫ���] = B.[�[�{����] AND A.[�t�ӽs��] = B.[�t�ӽs��])	[D_SUPLU_SEQ],
	RTRIM(CAST([�[�{����] AS VARCHAR(15))) [�[�{����], 
	RTRIM(CAST([�̫᧹����] AS VARCHAR(8))) [�̫᧹����], 
	RTRIM(CAST([������²��] AS VARCHAR(10))) [������²��], 
	RTRIM(CAST([�t�ӽs��] AS VARCHAR(8))) [�t�ӽs��],
	RTRIM(CAST([�t��²��] AS VARCHAR(10))) [�t��²��],
	RTRIM(CAST([���ƫ���] AS VARCHAR(15))) [���ƫ���],
	[���ƥζq], 
	RTRIM(CAST([����] AS VARCHAR(1))) [����],
	RTRIM(CAST([��J���] AS VARCHAR(8))) [��J���], 
	RTRIM(CAST([�b���~] AS VARCHAR(15))) [�b���~],
	[���], [���h], 
	CAST(IIF(LEFT([��J���],1) = 'S',1,0) AS bit) [��ƾP��], 
	CAST(0 AS bit) [���o��], CAST(0 AS bit) [���i�}], 
	CAST(IIF(LEFT([��J���],1) = 'S',1,0) AS bit) [���p����],
	[�ܧ���],
	RTRIM(CAST([��s�H��] AS VARCHAR(6))) [�إߤH��],
	[��s���] [�إߤ��],
	RTRIM(CAST([��s�H��] AS VARCHAR(6))) [��s�H��],
	[��s���]
FROM Bc2..bomsub A
UPDATE Dc2..bomsub SET [���h] = 9 WHERE [PARENT_SEQ] IS NULL;

INSERT INTO Dc2..bom with(tablock)
SELECT [�Ǹ�], 
	CAST( 
		(SELECT B.�Ǹ� 
		 FROM Bc2..suplu2 B
		 WHERE A.�̫᧹���� = B.�t�ӽs�� AND A.�[�{���� = B.�[�{����
	) AS BIGINT) [SUPLU_SEQ],
	RTRIM(CAST([�[�{����] AS varchar(15))) [�[�{����], 
	RTRIM(CAST([�}�o��] AS VARCHAR(1))) [�}�o��],
	RTRIM(CAST([�̫᧹����] AS VARCHAR(8))) [�̫᧹����],
	RTRIM(CAST([������²��] AS VARCHAR(10))) [������²��],
	[�Ƶ�], 
	RTRIM(CAST([����] AS VARCHAR(2))) [����],
	[�ܧ���],
	RTRIM(CAST([��s�H��] AS VARCHAR(6))) [�إߤH��],
	[��s���] [�إߤ��],
	RTRIM(CAST([��s�H��] AS VARCHAR(6))) [��s�H��],
	[��s���],
	CAST(0 AS BIT) [���O] --���O�ݵ�Detail�P�B��
FROM Bc2..bom A
UPDATE Dc2..bom SET [���O] = 1, [�}�o��] = 'Y' WHERE SUPLU_SEQ IN (SELECT SUPLU_SEQ FROM Dc2..bomsub WHERE [���h] = 9)
--UPDATE Dc2..suplu SET [�}�o��] = 'Y' WHERE [�Ǹ�] IN (SELECT [P_SEQ] FROM Dc2..bom WHERE [�}�o��] = 'Y')


--SELECT TOP 1 * FROM bom
--SELECT TOP 1 * FROM bomsub
