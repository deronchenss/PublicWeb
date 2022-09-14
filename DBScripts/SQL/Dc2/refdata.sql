USE [Dc2]
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[refdata]') AND type in (N'U'))
DROP TABLE [dbo].[refdata]
GO

CREATE TABLE [dbo].[refdata](
	[�Ǹ�] [int] NOT NULL,
	[�N�X] [varchar](14) NULL,
	[���e] [varchar](50) NULL,
	[�Ѧ�] [varchar](14) NULL,
	[����] [bit] NULL,
	[Chk_BYR_Del] [bit] NULL,
	[�Ƶ�] [varchar](250) NULL,
	[�ܧ���] [datetime] NULL,
	[��s�H��] [varchar](6) NULL,
	[��s���] [datetime] NULL,
 CONSTRAINT [PK_refdata] PRIMARY KEY CLUSTERED 
(
	[�Ǹ�] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE INDEX REFDATA_IDX_CODE ON Dc2..refdata([�N�X])
ALTER TABLE [dbo].[refdata] ADD  CONSTRAINT [DF_refdata_��s���]  DEFAULT (getdate()) FOR [��s���]
GO

INSERT INTO Dc2..refdata
SELECT [�Ǹ�], RTRIM([�N�X]), RTRIM([���e]), RTRIM([�Ѧ�]), [����], [Chk_BYR_Del], RTRIM([�Ƶ�]), [�ܧ���], [��s�H��], [��s���]
FROM Bc2..refdata

INSERT INTO Dc2..refdata([�Ǹ�], [�N�X], [���e], [��s�H��], [��s���])
SELECT (SELECT COALESCE(MAX([�Ǹ�]),0) FROM Dc2..refdata) +1, 'PUR_Rate', '28.5', 'Ivan10', GETDATE()
UNION ALL SELECT (SELECT COALESCE(MAX([�Ǹ�]),0) FROM Dc2..refdata) +2, 'ORD_Rate', '30', 'Ivan10', GETDATE();

INSERT INTO Dc2..refdata([�Ǹ�], [�N�X], [���e], [�Ƶ�], [��s�H��], [��s���])
SELECT (SELECT COALESCE(MAX([�Ǹ�]),0) FROM Dc2..refdata) +1, '��f�a�I', '�x�_������Ϭw�l��100��4��', '����', 'Ivan10', GETDATE()
UNION ALL SELECT (SELECT COALESCE(MAX([�Ǹ�]),0) FROM Dc2..refdata) +2, '��f�a�I', '�s�_������Ϻּw�@��393��32��', '����', 'Ivan10', GETDATE();

INSERT INTO Dc2..refdata([�Ǹ�], [�N�X], [���e], [��s�H��], [��s���])
SELECT [�Ǹ�] = (SELECT COALESCE(MAX([�Ǹ�]),0) FROM Dc2..refdata) + ROW_NUMBER() OVER (ORDER BY T.[���e]), 
	   [�N�X] = '���P���X', 
	   T.[���e],
	   [��s�H��] = 'Ivan10',
	   [��s���] = GETDATE()
FROM (
SELECT'IV01 (IVAN W38mm*H28mm*2)' [���e]
UNION ALL SELECT'IV02 (IVAN�V�ƱM�ί�)'
UNION ALL SELECT'IV05 (IVAN W35mm*H20mm*2)'
UNION ALL SELECT'IV06 (IVAN W38mm*H40mm*2)'
UNION ALL SELECT'IV07 (MakerAid W65mm*28mm)'
UNION ALL SELECT'IV08 (�u�t�ֱ� W38mm*H12mm*2)'
--UNION ALL SELECT'�L'
) T;

--20220912
UPDATE Dc2..refdata SET ���� = '1' WHERE �N�X = '���P���X' AND ���e = 'IV02 (IVAN�V�ƱM�ί�)';

INSERT INTO Dc2..refdata([�Ǹ�], [�N�X], [���e], [��s�H��], [��s���])
SELECT [�Ǹ�] = (SELECT COALESCE(MAX([�Ǹ�]),0) FROM Dc2..refdata) + ROW_NUMBER() OVER (ORDER BY T.[���e]), 
	   [�N�X] = '���X', 
	   T.[���e],
	   [��s�H��] = 'Ivan10',
	   [��s���] = GETDATE()
FROM (
SELECT 'IV05 (IVAN W35mm*H20mm*2)' [���e]
UNION ALL SELECT 'IV06 (IVAN W38mm*H40mm*2)'
UNION ALL SELECT 'IV07 (MakerAid W65mm*28mm)'
UNION ALL SELECT 'IV08 (�u�t�ֱ� W38mm*H12mm*2)'
UNION ALL SELECT 'TL01 (+AGE H40mm)'
UNION ALL SELECT 'TL02 (+��y H40mm)'
UNION ALL SELECT 'TL03 (+CP65 H40mm)'
UNION ALL SELECT 'TLA3 (+AGE H28mm)'
UNION ALL SELECT 'C128 (JCA H40mm)'
UNION ALL SELECT 'C129 (TLF H40mm)'
UNION ALL SELECT 'C130 (TLF +CP65 H40mm)'
UNION ALL SELECT 'M1-M (M&F�կ� H28mm)'
UNION ALL SELECT 'M1-N (NOCONA�կ� H28mm)'
UNION ALL SELECT 'M2-M (M&F�׹a)'
UNION ALL SELECT 'M2-N (NOCONA�׹a)'
UNION ALL SELECT 'M3-M (M&F�d��)'
UNION ALL SELECT 'M3-N (NOCONA�d��)'
UNION ALL SELECT 'M4-M (M&F LO)'
UNION ALL SELECT 'M4-N (NOCONA LO)'
UNION ALL SELECT 'M5-M (M&F����)'
UNION ALL SELECT 'M5-N (NOCONA����)'
UNION ALL SELECT 'M6   (M&F W35mm*H20mm*2)'
UNION ALL SELECT 'M7   (M&F W20mm*H15mm*3)'
UNION ALL SELECT 'NO8T (TLF�׹a)'
UNION ALL SELECT 'ST01 (UPC�q�Ϊ� H28mm)'
UNION ALL SELECT '��JA (JARIR�կ� H28mm)'
UNION ALL SELECT '��JB (JOHN BEAD H28mm)'
UNION ALL SELECT '��M5 (M&F���U���X H28mm)'
UNION ALL SELECT 'S-�� (TLF�s�� W20mm*H15mm*3)'
UNION ALL SELECT 'EN13 (RMW H28mm)'
UNION ALL SELECT 'EN14 (SLOJD H28mm)'
UNION ALL SELECT 'EN15 (RMW-CG287.NI/AE H28mm)'
UNION ALL SELECT 'HL01 (HOBBY�~�cW77mm*H60mm)'
--UNION ALL SELECT '�L'
) T;

--20220912
UPDATE Dc2..refdata SET ���� = '1' WHERE �N�X = '���X' AND ���e = 'S-�� (TLF�s�� W20mm*H15mm*3)';