/*
DECLARE @ATT_IDENT TABLE ([subdirectory] NVARCHAR(MAX), [depth] int);
INSERT @ATT_IDENT
exec ('exec master.sys.xp_dirtree ''e:\F\showroom'',0,0');
select * FROM @ATT_IDENT 
WHERE depth > 1
*/
exec master.sys.xp_dirtree 'e:\F\showroom',1,0--��Folder
--Count = 1,558 (=�t�Ӽ�)
------------------------------------------------------------------------------------------------------------
DECLARE @ATT_IDENT TABLE ([subdirectory] NVARCHAR(MAX), [depth] int, [file] int);
INSERT @ATT_IDENT
exec ('exec master.sys.xp_dirtree ''e:\F\showroom'',1,1');
select * FROM @ATT_IDENT 
WHERE [file] = 0
--Count = 114,389 (=�ɮ׼�)
------------------------------------------------------------------------------------------------------------
SELECT COUNT(1) FROM pic..xpic
--Count = 143,327

/*
�Ѽ�1:�_�lŪ���ؿ�
�Ѽ�2:�O�_Ū���Ҧ��l�ؿ�(�w�]0 Ū������)
�Ѽ�3:�O�_��ܩҦ��ɮ�(�w�]0 ����ܥ���)
*/

TRUNCATE TABLE pic..[xpic2]
--DROP TABLE #F1,

DECLARE @Folder TABLE ([subdirectory] NVARCHAR(MAX), [depth] int);
INSERT @Folder
exec ('exec master.sys.xp_dirtree ''e:\F\showroom'',1,0');
SELECT * INTO #F1
FROM (
	select B.[subdirectory] P1, ROW_NUMBER() OVER (ORDER BY B.[subdirectory] ) [SEQ] 
	FROM @Folder B
		INNER JOIN Bc2..sup S on RTRIM(B.[subdirectory]) = S.[�t�ӽs��] 
	) B

	--------------------------------------------------------------------------------------------
DECLARE @Q NVARCHAR(MAX), @SUP NVARCHAR(MAX), @PATH NVARCHAR(MAX), @I int = 1, @J int;
DECLARE @File TABLE ([subdirectory] NVARCHAR(MAX), [depth] int, [file] int);
WHILE @I <= (SELECT COUNT(1) FROM #F1)--�t��Count=�~�j��
BEGIN
	SELECT @SUP = [P1] FROM #F1 WHERE #F1.SEQ = @I;
	SET @Q = ('exec master.sys.xp_dirtree ''e:\F\showroom\' + @SUP + ''',0,1')
	DELETE @File 
	INSERT @File EXEC(@Q);
	SELECT * INTO #F2
	FROM (
		 SELECT F.[subdirectory] [File_Name], @SUP [S_No], RTRIM(C.[�[�{����]) [IM], C.[�Ǹ�] [SUPLU_SEQ], C.[�t��²��] [C_SName], ROW_NUMBER() OVER (ORDER BY F.[subdirectory]) [SEQ] 
		 FROM @File F
		 	INNER JOIN Bc2..suplu2 C ON C.[�t�ӽs��] = @SUP AND REPLACE(F.[subdirectory],'.jpg','') = C.[�[�{����]
		 WHERE F.[subdirectory] LIKE '%.jpg'
		 )T;
	SET @J = 1;--��l�Ƥ��j��
	WHILE @J <= (SELECT COUNT(1) FROM #F2)--�t��+����=����Count=���j��
	BEGIN
		SELECT @PATH = '\\192.168.1.135\f\showroom\' + [S_No] + '\' + [File_Name] FROM #F2 WHERE [SEQ] = @J
		--SELECT @PATH
		SET @Q = N'
			INSERT INTO pic..xpic2 ([�Ǹ�], [SUPLU_SEQ], [�[�{����], [�t�ӽs��], [�t��²��], [����], [�ܧ���], [��s�H��], [��s���])
			SELECT 
				[�Ǹ�] = (SELECT COALESCE(MAX(X.[�Ǹ�]),0) + 1 FROM pic..xpic2 X),
				[SUPLU_SEQ] = F2.[SUPLU_SEQ],
				[�[�{����] = F2.[IM],
				[�t�ӽs��] = F2.[S_No],
				[�t��²��] = F2.[C_SName],
				[����] = (SELECT BulkColumn FROM Openrowset(Bulk ''' + @PATH +  ''', Single_Blob) as img),
				[�ܧ���] = GETDATE(),
				[��s�H��] = ''Fatial'',
				[��s���] = GETDATE()
			FROM #F2 F2
			WHERE F2.[SEQ] = ' + CAST(@J AS VARCHAR)
		--SELECT @Q
		EXEC(@Q)
		SET @J += 1;
	END
	DROP TABLE #F2;
	SET @I += 1
END

--SELECT COUNT(1) FROM pic..[xpic2] WHERE ���� IS NOT NULL
--SELECT * INTO pic..[xpic2] FROM (SELECT TOP 0 * FROM pic..[xpic])B

--47m43s

CREATE INDEX xpic2_IDX_SUPLU_SEQ ON pic..xpic2([SUPLU_SEQ])
CREATE INDEX xpic2_IDX_SUPLU_IM ON pic..xpic2([�[�{����])

SELECT * FROM pic..xpic2

--���ɫ����ഫ1
INSERT INTO pic..xpic2 ([�Ǹ�], [SUPLU_SEQ], [�[�{����], [�t�ӽs��], [�t��²��], [����], [�ܧ���], [��s�H��], [��s���])
SELECT [�Ǹ�] = (SELECT MAX(X.[�Ǹ�]) FROM pic..xpic2 X) + ROW_NUMBER() OVER(ORDER BY P.[�Ǹ�]),
	   [SUPLU_SEQ] = C.[�Ǹ�],
	   [�[�{����] = C.[�[�{����], 
	   [�t�ӽs��] = C.[�t�ӽs��], 
	   [�t��²��] = C.[�t��²��], 
	   [����] = P.[����], 
	   [�ܧ���] = GETDATE(), 
	   [��s�H��] = 'Fatial',
	   [��s���] = GETDATE() 
--,LEFT(C.[�[�{����],CHARINDEX('-',C.[�[�{����])) + '001' [�ϫ��Ǹ�]
FROM Dc2..suplu C
	INNER JOIN pic..xpic2 P ON P.[�[�{����] = LEFT(C.[�[�{����],CHARINDEX('-',C.[�[�{����])) + '001' --�����ɫ������
WHERE C.[�[�{����] NOT IN (SELECT X.[�[�{����] FROM pic..xpic2 X)--���]�t�w�s�b
	AND C.[�t�ӽs��] = '0001' AND C.[�[�{����] LIKE '9%' AND LEN(C.[�[�{����]) >= 9
--42s
--���ɫ����ഫ2
INSERT INTO pic..xpic2 ([�Ǹ�], [SUPLU_SEQ], [�[�{����], [�t�ӽs��], [�t��²��], [����], [�ܧ���], [��s�H��], [��s���])
SELECT [�Ǹ�] = (SELECT MAX(X.[�Ǹ�]) FROM pic..xpic2 X) + ROW_NUMBER() OVER(ORDER BY P.[�Ǹ�]), 
	   [SUPLU_SEQ] = C.[�Ǹ�],
	   [�[�{����] = C.[�[�{����], 
	   [�t�ӽs��] = C.[�t�ӽs��], 
	   [�t��²��] = C.[�t��²��], 
	   [����] = P.[����], 
	   [�ܧ���] = GETDATE(),
	   [��s�H��] = 'Fatial',
	   [��s���] = GETDATE() 
--,LEFT(C.[�[�{����],CHARINDEX('-',C.[�[�{����]) +2) [�ϫ��Ǹ�]
FROM Dc2..suplu C
	INNER JOIN pic..xpic2 P ON P.[�[�{����] = LEFT(C.[�[�{����],CHARINDEX('-',C.[�[�{����]) +2)--�����ɫ������
WHERE C.[�[�{����] NOT IN (SELECT X.[�[�{����] FROM pic..xpic2 X)--���]�t�w�s�b
	AND LEFT(C.[�[�{����],3) IN ('LBE','HBE','BBE','SBE','LOT')
--0s
/*
SELECT TOP 1000
	CASE WHEN [�t�ӽs��] = '0001' AND [�[�{����] LIKE '9%' AND LEN([�[�{����]) >= 9
			THEN LEFT([�[�{����],CHARINDEX('-',[�[�{����])) + '001' 
		 WHEN LEFT([�[�{����],3) IN ('LBE','HBE','BBE','SBE','LOT')
			THEN LEFT([�[�{����],CHARINDEX('-',[�[�{����]) +3)
		 ELSE [�[�{����] END, * 
FROM DC2..suplu 
WHERE [�t�ӽs��] = '0001' AND [�[�{����] LIKE '9%' AND LEN([�[�{����]) >= 9
*/