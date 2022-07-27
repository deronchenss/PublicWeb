USE pic
CREATE TABLE REF_IMAGE
(
[RI_SEQ] int identity(1,1) NOT NULL,
[RI_IMAGE] image,
[RI_IMAGE_SOURCE] NVARCHAR(50),
[RI_REFENCE_KEY] VARCHAR(50),
[RI_TYPE] VARCHAR(50),
[CREATE_USER] VARCHAR(50),
[CREATE_DATE] DATETIME
);

INSERT INTO Pic..REF_IMAGE (RI_IMAGE, RI_IMAGE_SOURCE, RI_REFENCE_KEY, RI_TYPE, CREATE_USER, CREATE_DATE)
SELECT 
 (SELECT BulkColumn FROM Openrowset( Bulk '\\192.168.1.135\f\showroom\簽名\alice.jpg', Single_Blob) as img),
 '\\192.168.1.135\f\showroom\簽名\alice.jpg', 'Alice', 'Employee_Sign' , 'Fatial', GETDATE()
UNION ALL
SELECT 
 (SELECT BulkColumn FROM Openrowset( Bulk '\\192.168.1.135\f\showroom\簽名\fanny.jpg', Single_Blob) as img),
 '\\192.168.1.135\f\showroom\簽名\fanny.jpg', 'Fanny', 'Employee_Sign' , 'Fatial', GETDATE()
UNION ALL
SELECT 
 (SELECT BulkColumn FROM Openrowset( Bulk '\\192.168.1.135\f\showroom\簽名\Gloria.jpg', Single_Blob) as img),
 '\\192.168.1.135\f\showroom\簽名\Gloria.jpg', 'Gloria', 'Employee_Sign' , 'Fatial', GETDATE()
UNION ALL
SELECT 
 (SELECT BulkColumn FROM Openrowset( Bulk '\\192.168.1.135\f\showroom\簽名\Hanna.jpg', Single_Blob) as img),
 '\\192.168.1.135\f\showroom\簽名\Hanna.jpg', 'Hanna', 'Employee_Sign' , 'Fatial', GETDATE()
UNION ALL
SELECT 
 (SELECT BulkColumn FROM Openrowset( Bulk '\\192.168.1.135\f\showroom\簽名\HAOHAN.jpg', Single_Blob) as img),
 '\\192.168.1.135\f\showroom\簽名\HAOHAN.jpg', 'HAOHAN', 'Employee_Sign' , 'Fatial', GETDATE()
UNION ALL
SELECT 
 (SELECT BulkColumn FROM Openrowset( Bulk '\\192.168.1.135\f\showroom\簽名\HKC.jpg', Single_Blob) as img),
 '\\192.168.1.135\f\showroom\簽名\HKC.jpg', 'HKC', 'Employee_Sign' , 'Fatial', GETDATE()
UNION ALL
SELECT 
 (SELECT BulkColumn FROM Openrowset( Bulk '\\192.168.1.135\f\showroom\簽名\Jill.jpg', Single_Blob) as img),
 '\\192.168.1.135\f\showroom\簽名\Jill.jpg', 'Jill', 'Employee_Sign' , 'Fatial', GETDATE()
UNION ALL
SELECT 
 (SELECT BulkColumn FROM Openrowset( Bulk '\\192.168.1.135\f\showroom\簽名\KAREN.jpg', Single_Blob) as img),
 '\\192.168.1.135\f\showroom\簽名\KAREN.jpg', 'Karen', 'Employee_Sign' , 'Fatial', GETDATE()
UNION ALL
SELECT 
 (SELECT BulkColumn FROM Openrowset( Bulk '\\192.168.1.135\f\showroom\簽名\Migi.jpg', Single_Blob) as img),
 '\\192.168.1.135\f\showroom\簽名\Migi.jpg', 'Migi', 'Employee_Sign' , 'Fatial', GETDATE()
UNION ALL
SELECT 
 (SELECT BulkColumn FROM Openrowset( Bulk '\\192.168.1.135\f\showroom\簽名\Nancy.jpg', Single_Blob) as img),
 '\\192.168.1.135\f\showroom\簽名\Nancy.jpg', 'Nancy', 'Employee_Sign' , 'Fatial', GETDATE()
UNION ALL
SELECT 
 (SELECT BulkColumn FROM Openrowset( Bulk '\\192.168.1.135\f\showroom\簽名\SCOTT.jpg', Single_Blob) as img),
 '\\192.168.1.135\f\showroom\簽名\SCOTT.jpg', 'Scott', 'Employee_Sign' , 'Fatial', GETDATE()

SELECT * INTO #T FROM (SELECT 麥頭檔名, ROW_NUMBER() OVER(order by 麥頭檔名) [R] FROM Dc2..byr WHERE 麥頭檔名 IS NOT NULL GROUP BY 麥頭檔名)A
DECLARE @Q NVARCHAR(MAX), @COUNT INT, @I INT = 1, @C_No NVARCHAR(MAX)
SELECT @COUNT = COUNT(1) FROM #T
WHILE @I <= @COUNT
BEGIN
	SELECT @C_No = #T.[麥頭檔名] FROM #T WHERE #T.[R] = @I
	SET @Q = N'
		INSERT INTO Pic..REF_IMAGE (RI_IMAGE, RI_IMAGE_SOURCE, RI_REFENCE_KEY, RI_TYPE, CREATE_USER, CREATE_DATE)
		SELECT (SELECT BulkColumn FROM Openrowset( Bulk ''\\192.168.1.135\f\showroom\麥頭\' + @C_No +  '.jpg'', Single_Blob) as img),
			''\\192.168.1.135\f\showroom\麥頭\' + @C_No +  '.jpg'', ''' + @C_No + ''', ''Customer_Mark'' , ''Fatial'', GETDATE()'
	--SELECT @Q
	EXEC(@Q)
	SET @I+=1;
END
DROP TABLE #T;

