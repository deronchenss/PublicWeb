
--********************************

--SELECT * FROM [192.168.1.135].Bc2.dbo.suplu_ean
--20220630-Will_Add MSRP�e��, MSRP�U��  By Suplu_Ean
--20220701-Dc2..suplu �Ȥ᫬��>�P�⫬��
--MSRPV2&���浥��V2Del, +���浥�ūe��
--20220725-Rename �D���~>���p�w�s

--EXEC sp_rename 'dbo.suplu.�D���~', '���p�w�s', 'COLUMN';
--UPDATE Dc2..suplu SET ���p�w�s = 1 WHERE �t�ӽs�� = 'E-6001'

--20220802-ALTER TABLE Dc2..suplu ALTER COLUMN �t�ӫ��� NVARCHAR(20)


--********************************
--TRUNCATE TABLE Dc2.dbo.suplu
--ALTER TABLE Dc2..suplu ADD [���~�ԭz] varchar(560)
--DROP TABLE Dc2.dbo.suplu
--ALTER TABLE Dc2.dbo.suplu ADD [�s�y�W��] varchar(4096)
--ALTER TABLE Dc2..suplu ALTER COLUMN [�ܧ�O��] NVARCHAR(MAX)
--ALTER TABLE Dc2..suplu ADD [�ӽЭ�]] NVARCHAR(50)--20220614

--use Dc2  
--EXEC sp_rename 'dbo.suplu.���c�]�˼�', '�����e�q', 'COLUMN';
--EXEC sp_rename 'dbo.suplu.�~�c�]�˼�', '������', 'COLUMN';
--EXEC sp_rename 'dbo.suplu.�`��', '���~����', 'COLUMN';
--EXEC sp_rename 'dbo.suplu.���e', '���~�e��', 'COLUMN';
--EXEC sp_rename 'dbo.suplu.����', '���~����', 'COLUMN';

INSERT INTO Dc2.dbo.suplu with(tablock)
([�Ǹ�], [unactive], [�}�o��], [�b�Ȥ���], [���p�w�s], 
	[�s�W���], [�t�ӽs��], [�t��²��], [�[�{����], [�[�{���X], 
	[�t�ӫ���], [�Ȯɫ���], [���~����], [���], [�̫�����], [�x�����], [�������], 
	[���_2], [���_3], [min_1], [min_2], [min_3], [�~�����O], 
	[�~�����], [�~�����_2], [�~�����_3], [�i�f�|�h], [�i�f�|�v], 
	[�ӽЩ��],
	[����֭�], [�����֭�], [�I���֭�], [�j�f�w�s��], [�j�f�w����], [�֨��w�s��], 
	[�֨��w����], [�x�_�w�s��], [�x�_�w����], [�x���w�s��], [�x���w����], [�����w�s��], [�����w����], 
	[ISP�w�s��], [ISP�w����], [ISP���], [ISP������], 
	[IBU�w�s��], [IBU�w����], [IBU���], [IBU������], 
	[ITW�w�s��], [ITW�w����], [ITW���], [ITW������], 
	[�t�Ӯw�s��], [�˫~�w�s��], [����w�s��], [�i�ܮw�s��], [�d���w�s��], 
	[�i���w�s��], [�]�p�w�s��], [���t�w�s��], [���t�˰t��], [�U�ޮw�s��], 
	[�j�f�w��], [�j�f�w��], [�֨��w��], [�x�_�w��], [�x���w��], [�����w��], [�t�Ӯw��], 
	[�˫~�w��], [����w��], [�i�ܮw��], [�d���w��], [�i���w��], [�]�p�w��], [�U�ޮw��], [�����e�q], [������], [���c��], 
	[�~�c����], [�~�c�e��], [�~�c����], [�~�c�s��], 
	[���b��], [����], [���~����], [���~�e��], [���~����], [�]�˲`��], [�]�˭��e], [�]�˰���], 
	[�Ƚc���q], [�b��], [��], [�u��], 
	[�P�⫬��], [�����ӫ~], [��ڱ��X], [���~�@��], [���~�G��], [���~�T��], [�@��V3], [�G��V3], [���浥��], 
	[���浥��_2021], [���浥��_2022],
	[���~���A], [²�u����], [���a], [�Ӽ�ISP], [�|�hISP], [�˦�], 
	[�ۦ����X], [�ۦ�����], [�H�e�U�l], [�H�e�Q�d], [�۳ƳU�l], [�۳ƦQ�d], [�S��]��], 
	[���X�L��], [CP65], [�~��], [�^�廡��], [���X�^��@], [���X�^��G], 
	[�^��ISP], [����ITW], [�^����], [���~����], [�x�����_1], [�x�����_2], [�x�����_3],
	[�֭�����], [�֭����], [�ѦҸ��X],
	[MSRP�ҥ�], [MSRP���], [MSRP], [MSRPV2], [MSRP_2021], [MSRP_2022], [MSRP_ITW_���], [�]�p�H��], [�]�p�ϸ�], [�ϫ��ҥ�],
	[SQLP���], [�̫��I����], [���Τ��], [�Ƶ�������], [�Ƶ����}�o], [�Ƶ����ܮw], [�ܧ�O��], [�ܧ���], [��s���], [��s�H��], [���~�ԭz], [�s�y�W��])
SELECT 
	a.[�Ǹ�], a.[unactive], a.[�}�o��], a.[�b�Ȥ���], a.[�D���~_�U������] [���p�w�s], 
	a.[�s�W���], a.[�t�ӽs��], a.[�t��²��], a.[�[�{����], a.[�[�{���X], 
	a.[�t�ӫ���], a.[�Ȯɫ���], a.[���~����], a.[���], a.[�̫�����], a.[�x�����], a.[�������], 
	a.[���_2], a.[���_3], a.[min_1], a.[min_2], a.[min_3], a.[�~�����O], 
	a.[�~�����], a.[�~�����_2], a.[�~�����_3], a.[�i�f�|�h], a.[�i�f�|�v], 
	b.[�ӽЩ��],
	b.[����֭�], b.[�����֭�], b.[�I���֭�], b.[�j�f�w�s��], b.[�j�f�w����], b.[�֨��w�s��], 
	b.[�֨��w����], b.[�x�_�w�s��], b.[�x�_�w����], b.[�x���w�s��], b.[�x���w����], b.[�����w�s��], b.[�����w����], 
	b.[ISP�w�s��], b.[ISP�w����], b.[ISP���], b.[ISP������], 
	b.[IBU�w�s��], b.[IBU�w����], b.[IBU���], b.[IBU������], 
	b.[ITW�w�s��], b.[ITW�w����], b.[ITW���], b.[ITW������], 
	b.[�t�Ӯw�s��], b.[�˫~�w�s��], b.[����w�s��], b.[�i�ܮw�s��], b.[�d���w�s��], 
	b.[�i���w�s��], b.[�]�p�w�s��], b.[���t�w�s��], b.[���t�˰t��], b.[�U�ޮw�s��], 
	b.[�j�f�w��], b.[�j�f�w��], b.[�֨��w��], b.[�x�_�w��], b.[�x���w��], b.[�����w��], b.[�t�Ӯw��], 
	b.[�˫~�w��], b.[����w��], b.[�i�ܮw��], b.[�d���w��], b.[�i���w��], b.[�]�p�w��], b.[�U�ޮw��], b.[���c�]�˼�], b.[�~�c�]�˼�], b.[���c��], 
	b.[�~�c����], b.[�~�c�e��], b.[�~�c����],	b.[�~�c�s��], 
	b.[��쭫�q] [���b��], b.[����], b.[�`��], b.[���e], b.[����], b.[�]�˲`��], b.[�]�˭��e], b.[�]�˰���], 
	b.[�Ƚc���q], b.[�b��], b.[��], b.[�u��], 
	c.[�Ȥ᫬��], c.[�����ӫ~], c.[��ڱ��X], c.[���~�@��], c.[���~�G��], c.[���~�T��], c.[�@��V3], c.[�G��V3], c.[���浥��], 
	d.[���浥��_2021], d.[���浥��_2022],
	c.[���~���A], c.[²�u����], c.[���a], c.[�Ӽ�ISP], c.[�|�hISP], c.[�˦�], 
	c.[�ۦ����X], c.[�ۦ�����], c.[�H�e�U�l], c.[�H�e�Q�d], c.[�۳ƳU�l], c.[�۳ƦQ�d], c.[�S��]��], 
	c.[���X�L��], c.[CP65], c.[�~��], c.[�^�廡��], d.[�^�廡��] [���X�^��@], d.[�^�廡���G] [���X�^��G], 
	c.[�^��ISP], c.[����ITW], c.[�^����], e.[���~����], e.[�x�����_1], e.[�x�����_2], e.[�x�����_3],
	e.[�֭�����], e.[�֭����], d.[�ѦҸ��X],
	d.[MSRP�ҥ�], d.[MSRP���], d.[MSRP], d.[MSRPV2], d.[MSRP_2021], d.[MSRP_2022], d.[MSRP_ITW_���], a.[�]�p�H��], a.[�]�p�ϸ�], a.[�ϫ��ҥ�],
	a.[SQLP���], a.[�̫��I����], a.[���Τ��], a.[�Ƶ�������], a.[�Ƶ����}�o], b.[�Ƶ����ܮw], c.[�ܧ�O��], c.[�ܧ���], a.[��s���], a.[��s�H��], b.[���~�ԭz], f.[�s�y�W��]
FROM Bc2.dbo.suplu2 a
	INNER JOIN Bc2.dbo.suplu3 b ON a.[�t�ӽs��] = b.[�t�ӽs��] AND a.[�[�{����] = b.[�[�{����]
	INNER JOIN Bc2.dbo.suplu4 c ON a.[�t�ӽs��] = c.[�t�ӽs��] AND a.[�[�{����] = c.[�[�{����]
	LEFT JOIN Bc2.dbo.suplu_ean d ON a.[�t�ӽs��] = d.[�t�ӽs��] AND a.[�[�{����] = d.[�[�{����] AND ISNULL(�w�R��,0) <> '1'
	LEFT JOIN Bc2.dbo.byrlu_RT e ON a.[�t�ӽs��] = e.[�t�ӽs��] AND a.[�[�{����]= e.[�[�{����] AND (e.[���Τ��] <= GETDATE() OR e.[���Τ��] IS NULL)
	LEFT JOIN Bc2..Spec f ON a.[�t�ӽs��] = f.[�t�ӽs��] AND a.[�[�{����] = f.[�[�{����]
GO
USE Dc2;	
GO
CREATE TRIGGER [TRI_suplu_AIU] ON [dbo].[suplu]
AFTER INSERT, UPDATE
AS
DECLARE @SEQ bigint, @S_Date DATETIME, @P_Status VARCHAR(20), @O_S_Date DATETIME, @O_P_Status VARCHAR(20);
BEGIN
	IF EXISTS(SELECT [�Ǹ�] FROM INSERTED)
	BEGIN
		SELECT @SEQ = [�Ǹ�], @S_Date = [���Τ��], @P_Status = [���~���A] FROM INSERTED;
		SELECT @O_S_Date = [���Τ��], @O_P_Status = [���~���A] FROM DELETED;
		IF(@O_S_Date IS NOT NULL AND @S_Date IS NULL)
		BEGIN
			UPDATE Dc2..suplu SET [���~���A] = 'A' WHERE [�Ǹ�] = @SEQ;
		END
		IF(@O_S_Date IS NULL AND @S_Date IS NOT NULL)
		BEGIN
			UPDATE Dc2..suplu SET [���~���A] = 'D' WHERE [�Ǹ�] = @SEQ;
		END
		IF(@P_Status <> @O_P_Status AND @P_Status = 'D')
		BEGIN
			UPDATE Dc2..suplu SET [���Τ��] = GETDATE() WHERE [�Ǹ�] = @SEQ;
		END
		IF(@P_Status <> @O_P_Status AND @P_Status = 'A')
		BEGIN
			UPDATE Dc2..suplu SET [���Τ��] = NULL WHERE [�Ǹ�] = @SEQ;
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
SELECT @SEQ = [�Ǹ�],
	   @Change_Log = [�ܧ�O��],
	   @DVN = [�}�o��],
	   @OLD_IM = [�[�{����],
	   @OLD_S_No = [�t�ӽs��],
	   @OLD_PI = [���~����],
	   @OLD_Unit = [���],
	   @OLD_TWD_P = [�x�����],
	   @OLD_USD_P = [�������],
	   @OLD_Price_2 = [���_2],
	   @OLD_Price_3 = [���_3],
	   @OLD_MIN_1 = [min_1],
	   @OLD_MIN_2 = [min_2],
	   @OLD_MIN_3 = [min_3],
	   @OLD_Curr = [�~�����],
	   @OLD_Curr_2 = [�~�����_2],
	   @OLD_Curr_3 = [�~�����_3],
	   @OLD_SM = [�t�ӫ���]
FROM DELETED;
SELECT @NEW_IM = [�[�{����],
	   @NEW_S_No = [�t�ӽs��],
	   @NEW_PI = [���~����],
	   @NEW_Unit = [���],
	   @NEW_TWD_P = [�x�����],
	   @NEW_USD_P = [�������],
	   @NEW_Price_2 = [���_2],
	   @NEW_Price_3 = [���_3],
	   @NEW_MIN_1 = [min_1],
	   @NEW_MIN_2 = [min_2],
	   @NEW_MIN_3 = [min_3],
	   @NEW_Curr = [�~�����],
	   @NEW_Curr_2 = [�~�����_2],
	   @NEW_Curr_3 = [�~�����_3],
	   @NEW_SM = [�t�ӫ���]
FROM INSERTED;
BEGIN
	IF (@OLD_IM <> @NEW_IM)
	BEGIN
		SET @DVN = 'Y'
		SET @Change_Log += CHAR(10) + LEFT(RTRIM(CONVERT(VARCHAR(20),GETDATE(),20)),16) + ' ' + (SELECT [��s�H��] FROM INSERTED) + ' �[�{����: ' + @OLD_IM + '  ->  '+ @NEW_IM
	END
	IF(@OLD_S_No <> @NEW_S_No)
	BEGIN
		SET @DVN = 'Y'
		SET @Change_Log += CHAR(10) + LEFT(RTRIM(CONVERT(VARCHAR(20),GETDATE(),20)),16) + ' ' + (SELECT [��s�H��] FROM INSERTED) + ' �t�ӽs��: ' + @OLD_S_No + '  ->  '+ @NEW_S_No
	END
	IF(@OLD_PI <> @NEW_PI)
	BEGIN
		SET @DVN = 'Y'
		SET @Change_Log += CHAR(10) + LEFT(RTRIM(CONVERT(VARCHAR(20),GETDATE(),20)),16) + ' ' + (SELECT [��s�H��] FROM INSERTED) + ' ���~����: ' + @OLD_PI + '  ->  '+ @NEW_PI
	END
	IF(@OLD_Unit <> @NEW_Unit)
	BEGIN
		SET @DVN = 'Y'
		SET @Change_Log += CHAR(10) + LEFT(RTRIM(CONVERT(VARCHAR(20),GETDATE(),20)),16) + ' ' + (SELECT [��s�H��] FROM INSERTED) + ' ���: ' + @OLD_Unit + '  ->  '+ @NEW_Unit
	END
	IF(@OLD_TWD_P <> @NEW_TWD_P)
	BEGIN
		SET @DVN = 'Y'
		SET @Change_Log += CHAR(10) + LEFT(RTRIM(CONVERT(VARCHAR(20),GETDATE(),20)),16) + ' ' + (SELECT [��s�H��] FROM INSERTED) + ' �x�����: ' + CAST(@OLD_TWD_P AS NVARCHAR(50)) + '  ->  '+ CAST(@NEW_TWD_P AS NVARCHAR(50))
	END
	IF(@OLD_USD_P <> @NEW_USD_P)
	BEGIN
		SET @DVN = 'Y'
		SET @Change_Log += CHAR(10) + LEFT(RTRIM(CONVERT(VARCHAR(20),GETDATE(),20)),16) + ' ' + (SELECT [��s�H��] FROM INSERTED) + ' �������: ' + CAST(@OLD_USD_P AS NVARCHAR(50)) + '  ->  '+ CAST(@NEW_USD_P AS NVARCHAR(50))
	END
	IF(@OLD_Price_2 <> @NEW_Price_2)
	BEGIN
		SET @DVN = 'Y'
		SET @Change_Log += CHAR(10) + LEFT(RTRIM(CONVERT(VARCHAR(20),GETDATE(),20)),16) + ' ' + (SELECT [��s�H��] FROM INSERTED) + ' ���_2: ' + CAST(@OLD_Price_2 AS NVARCHAR(50)) + '  ->  '+ CAST(@NEW_Price_2 AS NVARCHAR(50))
	END
	IF(@OLD_Price_3 <> @NEW_Price_3)
	BEGIN
		SET @DVN = 'Y'
		SET @Change_Log += CHAR(10) + LEFT(RTRIM(CONVERT(VARCHAR(20),GETDATE(),20)),16) + ' ' + (SELECT [��s�H��] FROM INSERTED) + ' ���_3: ' + CAST(@OLD_Price_3 AS NVARCHAR(50)) + '  ->  '+ CAST(@NEW_Price_3 AS NVARCHAR(50))
	END
	IF(@OLD_MIN_1 <> @NEW_MIN_1)
	BEGIN
		SET @DVN = 'Y'
		SET @Change_Log += CHAR(10) + LEFT(RTRIM(CONVERT(VARCHAR(20),GETDATE(),20)),16) + ' ' + (SELECT [��s�H��] FROM INSERTED) + ' min_1: ' + CAST(@OLD_MIN_1 AS NVARCHAR(50)) + '  ->  '+ CAST(@NEW_MIN_1 AS NVARCHAR(50))
	END
	IF(@OLD_MIN_2 <> @NEW_MIN_2)
	BEGIN
		SET @DVN = 'Y'
		SET @Change_Log += CHAR(10) + LEFT(RTRIM(CONVERT(VARCHAR(20),GETDATE(),20)),16) + ' ' + (SELECT [��s�H��] FROM INSERTED) + ' min_2: ' + CAST(@OLD_MIN_2 AS NVARCHAR(50)) + '  ->  '+ CAST(@NEW_MIN_2 AS NVARCHAR(50))
	END
	IF(@OLD_MIN_3 <> @NEW_MIN_3)
	BEGIN
		SET @DVN = 'Y'
		SET @Change_Log += CHAR(10) + LEFT(RTRIM(CONVERT(VARCHAR(20),GETDATE(),20)),16) + ' ' + (SELECT [��s�H��] FROM INSERTED) + ' min_3: ' + CAST(@OLD_MIN_3 AS NVARCHAR(50)) + '  ->  '+ CAST(@NEW_MIN_3 AS NVARCHAR(50))
	END
	IF(@OLD_Curr <> @NEW_Curr)
	BEGIN
		SET @DVN = 'Y'
		SET @Change_Log += CHAR(10) + LEFT(RTRIM(CONVERT(VARCHAR(20),GETDATE(),20)),16) + ' ' + (SELECT [��s�H��] FROM INSERTED) + ' �~�����: ' + CAST(@OLD_Curr AS NVARCHAR(50)) + '  ->  '+ CAST(@NEW_Curr AS NVARCHAR(50))
	END
	IF(@OLD_Curr_2 <> @NEW_Curr_2)
	BEGIN
		SET @DVN = 'Y'
		SET @Change_Log += CHAR(10) + LEFT(RTRIM(CONVERT(VARCHAR(20),GETDATE(),20)),16) + ' ' + (SELECT [��s�H��] FROM INSERTED) + ' �~�����_2: ' + CAST(@OLD_Curr_2 AS NVARCHAR(50)) + '  ->  '+ CAST(@NEW_Curr_2 AS NVARCHAR(50))
	END
	IF(@OLD_Curr_3 <> @NEW_Curr_3)
	BEGIN
		SET @DVN = 'Y'
		SET @Change_Log += CHAR(10) + LEFT(RTRIM(CONVERT(VARCHAR(20),GETDATE(),20)),16) + ' ' + (SELECT [��s�H��] FROM INSERTED) + ' �~�����_3: ' + CAST(@OLD_Curr_3 AS NVARCHAR(50)) + '  ->  '+ CAST(@NEW_Curr_3 AS NVARCHAR(50))
	END
	IF(@OLD_SM <> @NEW_SM)
	BEGIN
		SET @DVN = 'Y'
		SET @Change_Log += CHAR(10) + LEFT(RTRIM(CONVERT(VARCHAR(20),GETDATE(),20)),16) + ' ' + (SELECT [��s�H��] FROM INSERTED) + ' �t�ӫ���: ' + @OLD_SM + '  ->  '+ @NEW_SM
	END
	--�f�֩��
	IF(@DVN = 'R' AND (SELECT [�}�o��] FROM INSERTED) = 'N')
	BEGIN--���?
		SET @DVN = 'N'
		SET @Change_Log += CHAR(10) + LEFT(RTRIM(CONVERT(VARCHAR(20),GETDATE(),20)),16) + ' ' + (SELECT [��s�H��] FROM INSERTED) + ' �ӽЩ��, �ӽЭ�]: '+ (SELECT [�ӽЭ�]] FROM INSERTED)
	END
	--�ӽЩ��
	IF(@DVN = 'Y' AND (SELECT [�}�o��] FROM INSERTED) = 'R')
	BEGIN
		SET @DVN = 'R'
	END
	UPDATE Dc2..suplu SET [�}�o��] = @DVN, [�ܧ�O��] = @Change_Log WHERE [�Ǹ�] = @SEQ
	IF( (SELECT [�ܧ�O��] FROM DELETED) <> @Change_Log)
	BEGIN
		UPDATE Dc2..suplu SET [��s�H��] = (SELECT [��s�H��] FROM INSERTED), [��s���] = GETDATE() WHERE [�Ǹ�] = @SEQ
	END
END
GO

ALTER TABLE [dbo].[suplu] ENABLE TRIGGER [TRI_suplu_AU]
GO

----------------------------------------------------------------------------AU_END


GO
CREATE NONCLUSTERED INDEX [suplu_IDX1] ON [dbo].[suplu]
(
	[��s���] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO

SET ANSI_PADDING ON
GO

CREATE NONCLUSTERED INDEX [suplu_IDX2] ON [dbo].[suplu]
(
	[�[�{����] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO

SET ANSI_PADDING ON
GO

CREATE NONCLUSTERED INDEX [suplu_IDX3] ON [dbo].[suplu]
(
	[�t�ӽs��] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO

--ALTER TABLE [dbo].[suplu] ADD  CONSTRAINT [DF_suplu_�x�����]  DEFAULT ((0)) FOR [�x�����]
--GO

--ALTER TABLE [dbo].[suplu] ADD  CONSTRAINT [DF_suplu_�������]  DEFAULT ((0)) FOR [�������]
--GO

--ALTER TABLE [dbo].[suplu] ADD  CONSTRAINT [DF_suplu_���_2]  DEFAULT ((0)) FOR [���_2]
--GO

--ALTER TABLE [dbo].[suplu] ADD  CONSTRAINT [DF_suplu_���_3]  DEFAULT ((0)) FOR [���_3]
--GO

--ALTER TABLE [dbo].[suplu] ADD  CONSTRAINT [DF_suplu_min_1]  DEFAULT ((0)) FOR [min_1]
--GO

--ALTER TABLE [dbo].[suplu] ADD  CONSTRAINT [DF_suplu_min_2]  DEFAULT ((0)) FOR [min_2]
--GO

--ALTER TABLE [dbo].[suplu] ADD  CONSTRAINT [DF_suplu_min_3]  DEFAULT ((0)) FOR [min_3]
--GO

--ALTER TABLE [dbo].[suplu] ADD  CONSTRAINT [DF_suplu_�~�����]  DEFAULT ((0)) FOR [�~�����]
--GO

--ALTER TABLE [dbo].[suplu] ADD  CONSTRAINT [DF_suplu_�~�����_2]  DEFAULT ((0)) FOR [�~�����_2]
--GO

--ALTER TABLE [dbo].[suplu] ADD  CONSTRAINT [DF_suplu_�~�����_3]  DEFAULT ((0)) FOR [�~�����_3]
--GO

--ALTER TABLE [dbo].[suplu] ADD  CONSTRAINT [DF_suplu_�s�W���]  DEFAULT (getdate()) FOR [�s�W���]
--GO

--ALTER TABLE [dbo].[suplu] ADD  CONSTRAINT [DF_suplu_��s���]  DEFAULT (getdate()) FOR [��s���]
--GO
