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
 (SELECT BulkColumn FROM Openrowset( Bulk '\\192.168.1.135\f\showroom\ñ�W\alice.jpg', Single_Blob) as img),
 '\\192.168.1.135\f\showroom\ñ�W\alice.jpg', 'Alice', 'Employee_Sign' , 'Fatial', GETDATE()
UNION ALL
SELECT 
 (SELECT BulkColumn FROM Openrowset( Bulk '\\192.168.1.135\f\showroom\ñ�W\fanny.jpg', Single_Blob) as img),
 '\\192.168.1.135\f\showroom\ñ�W\fanny.jpg', 'Fanny', 'Employee_Sign' , 'Fatial', GETDATE()
UNION ALL
SELECT 
 (SELECT BulkColumn FROM Openrowset( Bulk '\\192.168.1.135\f\showroom\ñ�W\Gloria.jpg', Single_Blob) as img),
 '\\192.168.1.135\f\showroom\ñ�W\Gloria.jpg', 'Gloria', 'Employee_Sign' , 'Fatial', GETDATE()
UNION ALL
SELECT 
 (SELECT BulkColumn FROM Openrowset( Bulk '\\192.168.1.135\f\showroom\ñ�W\Hanna.jpg', Single_Blob) as img),
 '\\192.168.1.135\f\showroom\ñ�W\Hanna.jpg', 'Hanna', 'Employee_Sign' , 'Fatial', GETDATE()
UNION ALL
SELECT 
 (SELECT BulkColumn FROM Openrowset( Bulk '\\192.168.1.135\f\showroom\ñ�W\HAOHAN.jpg', Single_Blob) as img),
 '\\192.168.1.135\f\showroom\ñ�W\HAOHAN.jpg', 'HAOHAN', 'Employee_Sign' , 'Fatial', GETDATE()
UNION ALL
SELECT 
 (SELECT BulkColumn FROM Openrowset( Bulk '\\192.168.1.135\f\showroom\ñ�W\HKC.jpg', Single_Blob) as img),
 '\\192.168.1.135\f\showroom\ñ�W\HKC.jpg', 'HKC', 'Employee_Sign' , 'Fatial', GETDATE()
UNION ALL
SELECT 
 (SELECT BulkColumn FROM Openrowset( Bulk '\\192.168.1.135\f\showroom\ñ�W\Jill.jpg', Single_Blob) as img),
 '\\192.168.1.135\f\showroom\ñ�W\Jill.jpg', 'Jill', 'Employee_Sign' , 'Fatial', GETDATE()
UNION ALL
SELECT 
 (SELECT BulkColumn FROM Openrowset( Bulk '\\192.168.1.135\f\showroom\ñ�W\KAREN.jpg', Single_Blob) as img),
 '\\192.168.1.135\f\showroom\ñ�W\KAREN.jpg', 'Karen', 'Employee_Sign' , 'Fatial', GETDATE()
UNION ALL
SELECT 
 (SELECT BulkColumn FROM Openrowset( Bulk '\\192.168.1.135\f\showroom\ñ�W\Migi.jpg', Single_Blob) as img),
 '\\192.168.1.135\f\showroom\ñ�W\Migi.jpg', 'Migi', 'Employee_Sign' , 'Fatial', GETDATE()
UNION ALL
SELECT 
 (SELECT BulkColumn FROM Openrowset( Bulk '\\192.168.1.135\f\showroom\ñ�W\Nancy.jpg', Single_Blob) as img),
 '\\192.168.1.135\f\showroom\ñ�W\Nancy.jpg', 'Nancy', 'Employee_Sign' , 'Fatial', GETDATE()
UNION ALL
SELECT 
 (SELECT BulkColumn FROM Openrowset( Bulk '\\192.168.1.135\f\showroom\ñ�W\SCOTT.jpg', Single_Blob) as img),
 '\\192.168.1.135\f\showroom\ñ�W\SCOTT.jpg', 'Scott', 'Employee_Sign' , 'Fatial', GETDATE()

SELECT * INTO #T FROM (SELECT ���Y�ɦW, ROW_NUMBER() OVER(order by ���Y�ɦW) [R] FROM Dc2..byr WHERE ���Y�ɦW IS NOT NULL GROUP BY ���Y�ɦW)A
DECLARE @Q NVARCHAR(MAX), @COUNT INT, @I INT = 1, @C_No NVARCHAR(MAX)
SELECT @COUNT = COUNT(1) FROM #T
WHILE @I <= @COUNT
BEGIN
	SELECT @C_No = #T.[���Y�ɦW] FROM #T WHERE #T.[R] = @I
	SET @Q = N'
		INSERT INTO Pic..REF_IMAGE (RI_IMAGE, RI_IMAGE_SOURCE, RI_REFENCE_KEY, RI_TYPE, CREATE_USER, CREATE_DATE)
		SELECT (SELECT BulkColumn FROM Openrowset( Bulk ''\\192.168.1.135\f\showroom\���Y\' + @C_No +  '.jpg'', Single_Blob) as img),
			''\\192.168.1.135\f\showroom\���Y\' + @C_No +  '.jpg'', ''' + @C_No + ''', ''Customer_Mark'' , ''Fatial'', GETDATE()'
	--SELECT @Q
	EXEC(@Q)
	SET @I+=1;
END
DROP TABLE #T;

