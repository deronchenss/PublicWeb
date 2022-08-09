USE [Dc2]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[byrlu]') AND type in (N'U'))
DROP TABLE [dbo].[byrlu]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[byrlu](
	[�Ǹ�] [int] NOT NULL,
	[SUPLU_SEQ] [INT] NULL,
	[�}�o��] [varchar](1) NULL,
	[�Ȥ�s��] [varchar](8) NULL,
	[�Ȥ�²��] [varchar](10) NULL,
	[�[�{����] [varchar](15) NULL,
	[�Ȥ᫬��] [varchar](15) NULL,
	[���~����] [varchar](360) NULL,
	[���] [varchar](6) NULL,
	[�̫�����] [datetime] NULL,
	[�������] [decimal](9, 3) NULL,
	[�x�����] [decimal](9, 2) NULL,
	[���_2] [decimal](9, 3) NULL,
	[���_3] [decimal](9, 3) NULL,
	[���_4] [decimal](9, 3) NULL,
	[���_5] [decimal](9, 3) NULL,
	[min_1] [int] NULL,
	[min_2] [int] NULL,
	[min_3] [int] NULL,
	[min_4] [int] NULL,
	[min_5] [int] NULL,
	[�~�����O] [varchar](3) NULL,
	[�~�����] [decimal](9, 3) NULL,
	[�t�ӽs��] [varchar](8) NULL,
	[�t��²��] [varchar](10) NULL,
	[�|�h���X] [varchar](12) NULL,
	[�Ӽ�] [varchar](6) NULL,
	[���Τ��] [datetime] NULL,
	[�Ƶ�] [varchar](1024) NULL,
	[�ܧ�O��] [Nvarchar](MAX) NULL,
	[�ܧ���] [datetime] NULL,
	[��s�H��] [varchar](6) NULL,
	[��s���] [datetime] NULL,
 CONSTRAINT [PK_byrlu] PRIMARY KEY CLUSTERED 
(
	[�Ǹ�] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
SET ANSI_PADDING ON
CREATE NONCLUSTERED INDEX [IX_byrlu] ON [dbo].[byrlu]([�[�{����] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
SET ANSI_PADDING ON
CREATE NONCLUSTERED INDEX [IX_byrlu_1] ON [dbo].[byrlu]([�Ȥ�s��] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_byrlu_2] ON [dbo].[byrlu]([��s���] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
SET ANSI_PADDING ON
CREATE NONCLUSTERED INDEX [IX_byrlu_3] ON [dbo].[byrlu]([�Ȥ᫬��] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
ALTER TABLE [dbo].[byrlu] ADD  CONSTRAINT [DF_byrlu_�������]  DEFAULT ((0)) FOR [�������]
ALTER TABLE [dbo].[byrlu] ADD  CONSTRAINT [DF_byrlu_�x�����]  DEFAULT ((0)) FOR [�x�����]
ALTER TABLE [dbo].[byrlu] ADD  CONSTRAINT [DF_byrlu_���_2]  DEFAULT ((0)) FOR [���_2]
ALTER TABLE [dbo].[byrlu] ADD  CONSTRAINT [DF_byrlu_���_3]  DEFAULT ((0)) FOR [���_3]
ALTER TABLE [dbo].[byrlu] ADD  CONSTRAINT [DF_byrlu_���_4]  DEFAULT ((0)) FOR [���_4]
ALTER TABLE [dbo].[byrlu] ADD  CONSTRAINT [DF_byrlu_min_1]  DEFAULT ((0)) FOR [min_1]
ALTER TABLE [dbo].[byrlu] ADD  CONSTRAINT [DF_byrlu_min_2]  DEFAULT ((0)) FOR [min_2]
ALTER TABLE [dbo].[byrlu] ADD  CONSTRAINT [DF_byrlu_min_3]  DEFAULT ((0)) FOR [min_3]
ALTER TABLE [dbo].[byrlu] ADD  CONSTRAINT [DF_byrlu_min_4]  DEFAULT ((0)) FOR [min_4]
ALTER TABLE [dbo].[byrlu] ADD  CONSTRAINT [DF_byrlu_�~�����]  DEFAULT ((0)) FOR [�~�����]
ALTER TABLE [dbo].[byrlu] ADD  CONSTRAINT [DF_byrlu_��s�H��]  DEFAULT (getdate()) FOR [��s���]
CREATE INDEX BURLU_IDX_SUPLU_SEQ ON Dc2..BYRLU([SUPLU_SEQ])
--���~����>���满��or��T?
ALTER TABLE Dc2..byrlu ADD CONSTRAINT CNo_With_CM UNIQUE ([�Ȥ�s��], [�Ȥ᫬��]);
INSERT INTO Dc2..byrlu with(tablock)
SELECT [�Ǹ�], (SELECT TOP 1 C.[�Ǹ�] FROM Dc2..suplu C WHERE C.[�t�ӽs��] = P.[�t�ӽs��] AND C.[�[�{����] = P.[�[�{����]) [SUPLU_SEQ], 
	[�}�o��], RTRIM([�Ȥ�s��]), RTRIM([�Ȥ�²��]), RTRIM([�[�{����]), RTRIM([�Ȥ᫬��]), RTRIM([���~����]), RTRIM([���]), [�̫�����], [�������], [�x�����], [���_2], [���_3], [���_4], [���_5], 
	[min_1], [min_2], [min_3], [min_4], [min_5],[�~�����O], [�~�����], RTRIM([�t�ӽs��]), RTRIM([�t��²��]), RTRIM([�|�h���X]), RTRIM([�Ӽ�]), [���Τ��], RTRIM([�Ƶ�]), 
	(SELECT RTRIM([�ܧ�O��]) FROM Bc2..byrlu4 BB WHERE BB.byrlu�Ǹ� = P.�Ǹ�) [�ܧ�O��],
	[�ܧ���], RTRIM([��s�H��]), [��s���]
FROM Bc2..byrlu P;



USE Dc2; 
GO
--DROP TRIGGER [TRI_byrlu_AU] 
CREATE TRIGGER [TRI_byrlu_AU] ON [dbo].[byrlu]
AFTER UPDATE
AS
/*
�[�{����
�t�ӽs��
���~����--���满��
���
�Ȥ᫬��
�������
�x�����
�~�����
���_2
���_3
���_4
*/
DECLARE @SEQ bigint, @Change_Log NVARCHAR(MAX), 
		@OLD_IM VARCHAR(50), @NEW_IM VARCHAR(50), 
		@OLD_S_No VARCHAR(50), @NEW_S_No NVARCHAR(50), 
		@OLD_PI NVARCHAR(MAX), @NEW_PI NVARCHAR(MAX), 
		@OLD_Unit NVARCHAR(20), @NEW_Unit NVARCHAR(20),
		@OLD_CustM VARCHAR(50), @NEW_CustM VARCHAR(50), 
		@OLD_TWD_P NUMERIC(9,3), @NEW_TWD_P NUMERIC(9,3),
		@OLD_USD_P NUMERIC(9,3), @NEW_USD_P NUMERIC(9,3),
		@OLD_Curr_P NUMERIC(9,3), @NEW_Curr_P NUMERIC(9,3),
		@OLD_Price_2 NUMERIC(9,3), @NEW_Price_2 NUMERIC(9,3),
		@OLD_Price_3 NUMERIC(9,3), @NEW_Price_3 NUMERIC(9,3),
		@OLD_Price_4 NUMERIC(9,3), @NEW_Price_4 NUMERIC(9,3)
SELECT @SEQ = [�Ǹ�], @Change_Log = ISNULL([�ܧ�O��],''),
	   @OLD_IM = [�[�{����],
	   @OLD_S_No = [�t�ӽs��],
	   @OLD_PI = [���~����],
	   @OLD_Unit = [���],
	   @OLD_CustM = [�Ȥ᫬��],
	   @OLD_TWD_P = [�x�����],
	   @OLD_USD_P = [�������],
	   @OLD_Curr_P = [�~�����],
	   @OLD_Price_2 = [���_2],
	   @OLD_Price_3 = [���_3],
	   @OLD_Price_4 = [���_4]
FROM DELETED;
SELECT @NEW_IM = [�[�{����],
	   @NEW_S_No = [�t�ӽs��],
	   @NEW_PI = [���~����],
	   @NEW_Unit = [���],
	   @NEW_CustM = [�Ȥ᫬��],
	   @NEW_TWD_P = [�x�����],
	   @NEW_USD_P = [�������],
	   @NEW_Curr_P = [�~�����],
	   @NEW_Price_2 = [���_2],
	   @NEW_Price_3 = [���_3],
	   @NEW_Price_4 = [���_4]
FROM INSERTED;

BEGIN
	IF (@OLD_IM <> @NEW_IM)
	BEGIN
		SET @Change_Log += CHAR(10) + LEFT(RTRIM(CONVERT(VARCHAR(20),GETDATE(),20)),16) + ' ' + (SELECT [��s�H��] FROM INSERTED) + ' �[�{����: ' + @OLD_IM + '  ->  '+ @NEW_IM
	END
	IF(@OLD_S_No <> @NEW_S_No)
	BEGIN
		SET @Change_Log += CHAR(10) + LEFT(RTRIM(CONVERT(VARCHAR(20),GETDATE(),20)),16) + ' ' + (SELECT [��s�H��] FROM INSERTED) + ' �t�ӽs��: ' + @OLD_S_No + '  ->  '+ @NEW_S_No
	END
	IF(@OLD_PI <> @NEW_PI)
	BEGIN
		SET @Change_Log += CHAR(10) + LEFT(RTRIM(CONVERT(VARCHAR(20),GETDATE(),20)),16) + ' ' + (SELECT [��s�H��] FROM INSERTED) + ' ���~����: ' + @OLD_PI + '  ->  '+ @NEW_PI
	END
	IF(@OLD_Unit <> @NEW_Unit)
	BEGIN
		SET @Change_Log += CHAR(10) + LEFT(RTRIM(CONVERT(VARCHAR(20),GETDATE(),20)),16) + ' ' + (SELECT [��s�H��] FROM INSERTED) + ' ���: ' + @OLD_Unit + '  ->  '+ @NEW_Unit
	END
	IF(@OLD_CustM <> @NEW_CustM)
	BEGIN
		SET @Change_Log += CHAR(10) + LEFT(RTRIM(CONVERT(VARCHAR(20),GETDATE(),20)),16) + ' ' + (SELECT [��s�H��] FROM INSERTED) + ' �Ȥ᫬��: ' + CAST(@OLD_CustM AS NVARCHAR(50)) + '  ->  '+ CAST(@NEW_CustM AS NVARCHAR(50))
	END
	IF(@OLD_TWD_P <> @NEW_TWD_P)
	BEGIN
		SET @Change_Log += CHAR(10) + LEFT(RTRIM(CONVERT(VARCHAR(20),GETDATE(),20)),16) + ' ' + (SELECT [��s�H��] FROM INSERTED) + ' �x�����: ' + CAST(@OLD_TWD_P AS NVARCHAR(50)) + '  ->  '+ CAST(@NEW_TWD_P AS NVARCHAR(50))
	END
	IF(@OLD_USD_P <> @NEW_USD_P)
	BEGIN
		SET @Change_Log += CHAR(10) + LEFT(RTRIM(CONVERT(VARCHAR(20),GETDATE(),20)),16) + ' ' + (SELECT [��s�H��] FROM INSERTED) + ' �������: ' + CAST(@OLD_USD_P AS NVARCHAR(50)) + '  ->  '+ CAST(@NEW_USD_P AS NVARCHAR(50))
	END
	IF(@OLD_Curr_P <> @NEW_Curr_P)
	BEGIN
		SET @Change_Log += CHAR(10) + LEFT(RTRIM(CONVERT(VARCHAR(20),GETDATE(),20)),16) + ' ' + (SELECT [��s�H��] FROM INSERTED) + ' �~�����: ' + CAST(@OLD_Curr_P AS NVARCHAR(50)) + '  ->  '+ CAST(@NEW_Curr_P AS NVARCHAR(50))
	END
	IF(@OLD_Price_2 <> @NEW_Price_2)
	BEGIN
		SET @Change_Log += CHAR(10) + LEFT(RTRIM(CONVERT(VARCHAR(20),GETDATE(),20)),16) + ' ' + (SELECT [��s�H��] FROM INSERTED) + ' ���_2: ' + CAST(@OLD_Price_2 AS NVARCHAR(50)) + '  ->  '+ CAST(@NEW_Price_2 AS NVARCHAR(50))
	END
	IF(@OLD_Price_3 <> @NEW_Price_3)
	BEGIN
		SET @Change_Log += CHAR(10) + LEFT(RTRIM(CONVERT(VARCHAR(20),GETDATE(),20)),16) + ' ' + (SELECT [��s�H��] FROM INSERTED) + ' ���_3: ' + CAST(@OLD_Price_3 AS NVARCHAR(50)) + '  ->  '+ CAST(@NEW_Price_3 AS NVARCHAR(50))
	END
	IF(@OLD_Price_4 <> @NEW_Price_4)
	BEGIN
		SET @Change_Log += CHAR(10) + LEFT(RTRIM(CONVERT(VARCHAR(20),GETDATE(),20)),16) + ' ' + (SELECT [��s�H��] FROM INSERTED) + ' ���_4: ' + CAST(@OLD_Price_4 AS NVARCHAR(50)) + '  ->  '+ CAST(@NEW_Price_4 AS NVARCHAR(50))
	END
	UPDATE Dc2..byrlu SET [�ܧ�O��] = @Change_Log WHERE [�Ǹ�] = @SEQ
END
