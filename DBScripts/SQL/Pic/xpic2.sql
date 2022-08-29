/*
DECLARE @ATT_IDENT TABLE ([subdirectory] NVARCHAR(MAX), [depth] int);
INSERT @ATT_IDENT
exec ('exec master.sys.xp_dirtree ''e:\F\showroom'',0,0');
select * FROM @ATT_IDENT 
WHERE depth > 1
*/
exec master.sys.xp_dirtree 'e:\F\showroom',1,0--全Folder
--Count = 1,558 (=廠商數)
------------------------------------------------------------------------------------------------------------
DECLARE @ATT_IDENT TABLE ([subdirectory] NVARCHAR(MAX), [depth] int, [file] int);
INSERT @ATT_IDENT
exec ('exec master.sys.xp_dirtree ''e:\F\showroom'',1,1');
select * FROM @ATT_IDENT 
WHERE [file] = 0
--Count = 114,389 (=檔案數)
------------------------------------------------------------------------------------------------------------
SELECT COUNT(1) FROM pic..xpic
--Count = 143,327

/*
參數1:起始讀取目錄
參數2:是否讀取所有子目錄(預設0 讀取全部)
參數3:是否顯示所有檔案(預設0 不顯示全部)
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
		INNER JOIN Bc2..sup S on RTRIM(B.[subdirectory]) = S.[廠商編號] 
	) B

	--------------------------------------------------------------------------------------------
DECLARE @Q NVARCHAR(MAX), @SUP NVARCHAR(MAX), @PATH NVARCHAR(MAX), @I int = 1, @J int;
DECLARE @File TABLE ([subdirectory] NVARCHAR(MAX), [depth] int, [file] int);
WHILE @I <= (SELECT COUNT(1) FROM #F1)--廠商Count=外迴圈
BEGIN
	SELECT @SUP = [P1] FROM #F1 WHERE #F1.SEQ = @I;
	SET @Q = ('exec master.sys.xp_dirtree ''e:\F\showroom\' + @SUP + ''',0,1')
	DELETE @File 
	INSERT @File EXEC(@Q);
	SELECT * INTO #F2
	FROM (
		 SELECT F.[subdirectory] [File_Name], @SUP [S_No], RTRIM(C.[頤坊型號]) [IM], C.[序號] [SUPLU_SEQ], C.[廠商簡稱] [C_SName], ROW_NUMBER() OVER (ORDER BY F.[subdirectory]) [SEQ] 
		 FROM @File F
		 	INNER JOIN Bc2..suplu2 C ON C.[廠商編號] = @SUP AND REPLACE(F.[subdirectory],'.jpg','') = C.[頤坊型號]
		 WHERE F.[subdirectory] LIKE '%.jpg'
		 )T;
	SET @J = 1;--初始化內迴圈
	WHILE @J <= (SELECT COUNT(1) FROM #F2)--廠商+型號=圖檔Count=內迴圈
	BEGIN
		SELECT @PATH = '\\192.168.1.135\f\showroom\' + [S_No] + '\' + [File_Name] FROM #F2 WHERE [SEQ] = @J
		--SELECT @PATH
		SET @Q = N'
			INSERT INTO pic..xpic2 ([序號], [SUPLU_SEQ], [頤坊型號], [廠商編號], [廠商簡稱], [圖檔], [變更日期], [更新人員], [更新日期])
			SELECT 
				[序號] = (SELECT COALESCE(MAX(X.[序號]),0) + 1 FROM pic..xpic2 X),
				[SUPLU_SEQ] = F2.[SUPLU_SEQ],
				[頤坊型號] = F2.[IM],
				[廠商編號] = F2.[S_No],
				[廠商簡稱] = F2.[C_SName],
				[圖檔] = (SELECT BulkColumn FROM Openrowset(Bulk ''' + @PATH +  ''', Single_Blob) as img),
				[變更日期] = GETDATE(),
				[更新人員] = ''Fatial'',
				[更新日期] = GETDATE()
			FROM #F2 F2
			WHERE F2.[SEQ] = ' + CAST(@J AS VARCHAR)
		--SELECT @Q
		EXEC(@Q)
		SET @J += 1;
	END
	DROP TABLE #F2;
	SET @I += 1
END

--SELECT COUNT(1) FROM pic..[xpic2] WHERE 圖檔 IS NOT NULL
--SELECT * INTO pic..[xpic2] FROM (SELECT TOP 0 * FROM pic..[xpic])B

--47m43s

CREATE INDEX xpic2_IDX_SUPLU_SEQ ON pic..xpic2([SUPLU_SEQ])
CREATE INDEX xpic2_IDX_SUPLU_IM ON pic..xpic2([頤坊型號])

SELECT * FROM pic..xpic2

--圖檔型號轉換1
INSERT INTO pic..xpic2 ([序號], [SUPLU_SEQ], [頤坊型號], [廠商編號], [廠商簡稱], [圖檔], [變更日期], [更新人員], [更新日期])
SELECT [序號] = (SELECT MAX(X.[序號]) FROM pic..xpic2 X) + ROW_NUMBER() OVER(ORDER BY P.[序號]),
	   [SUPLU_SEQ] = C.[序號],
	   [頤坊型號] = C.[頤坊型號], 
	   [廠商編號] = C.[廠商編號], 
	   [廠商簡稱] = C.[廠商簡稱], 
	   [圖檔] = P.[圖檔], 
	   [變更日期] = GETDATE(), 
	   [更新人員] = 'Fatial',
	   [更新日期] = GETDATE() 
--,LEFT(C.[頤坊型號],CHARINDEX('-',C.[頤坊型號])) + '001' [圖型序號]
FROM Dc2..suplu C
	INNER JOIN pic..xpic2 P ON P.[頤坊型號] = LEFT(C.[頤坊型號],CHARINDEX('-',C.[頤坊型號])) + '001' --取圖檔型號資料
WHERE C.[頤坊型號] NOT IN (SELECT X.[頤坊型號] FROM pic..xpic2 X)--不包含已存在
	AND C.[廠商編號] = '0001' AND C.[頤坊型號] LIKE '9%' AND LEN(C.[頤坊型號]) >= 9
--42s
--圖檔型號轉換2
INSERT INTO pic..xpic2 ([序號], [SUPLU_SEQ], [頤坊型號], [廠商編號], [廠商簡稱], [圖檔], [變更日期], [更新人員], [更新日期])
SELECT [序號] = (SELECT MAX(X.[序號]) FROM pic..xpic2 X) + ROW_NUMBER() OVER(ORDER BY P.[序號]), 
	   [SUPLU_SEQ] = C.[序號],
	   [頤坊型號] = C.[頤坊型號], 
	   [廠商編號] = C.[廠商編號], 
	   [廠商簡稱] = C.[廠商簡稱], 
	   [圖檔] = P.[圖檔], 
	   [變更日期] = GETDATE(),
	   [更新人員] = 'Fatial',
	   [更新日期] = GETDATE() 
--,LEFT(C.[頤坊型號],CHARINDEX('-',C.[頤坊型號]) +2) [圖型序號]
FROM Dc2..suplu C
	INNER JOIN pic..xpic2 P ON P.[頤坊型號] = LEFT(C.[頤坊型號],CHARINDEX('-',C.[頤坊型號]) +2)--取圖檔型號資料
WHERE C.[頤坊型號] NOT IN (SELECT X.[頤坊型號] FROM pic..xpic2 X)--不包含已存在
	AND LEFT(C.[頤坊型號],3) IN ('LBE','HBE','BBE','SBE','LOT')
--0s
/*
SELECT TOP 1000
	CASE WHEN [廠商編號] = '0001' AND [頤坊型號] LIKE '9%' AND LEN([頤坊型號]) >= 9
			THEN LEFT([頤坊型號],CHARINDEX('-',[頤坊型號])) + '001' 
		 WHEN LEFT([頤坊型號],3) IN ('LBE','HBE','BBE','SBE','LOT')
			THEN LEFT([頤坊型號],CHARINDEX('-',[頤坊型號]) +3)
		 ELSE [頤坊型號] END, * 
FROM DC2..suplu 
WHERE [廠商編號] = '0001' AND [頤坊型號] LIKE '9%' AND LEN([頤坊型號]) >= 9
*/