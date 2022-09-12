USE [Dc2]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[orm_RT]') AND type in (N'U'))
DROP TABLE [dbo].[orm_RT]
GO

CREATE TABLE [dbo].[orm_RT](
	[�Ǹ�] [int] NOT NULL,
	[�q�渹�X] [varchar](20) NULL,
	[����] [bit] NULL,
	[�Ȥ�s��] [varchar](8) NULL,
	[�Ȥ�²��] [varchar](20) NULL,
	[������] [datetime] NULL,
	[�Ȥᵥ��] [varchar](1) NULL,
	[���ʮw��] [datetime] NULL,
	[���ڤ覡] [varchar](8) NULL,
	[�K�Q�c] [varchar](4) NULL,
	[��] [decimal](5, 2) NULL,
	[�c��] [smallint] NULL,
	[�������B] [int] NULL,
	[�B�O����] [int] NULL,
	[�B�O�ꦬ] [int] NULL,
	[�B�O��I] [int] NULL,
	[�w�����B] [decimal](8, 2) NULL,
	[�w�����] [datetime] NULL,
	[�H�e���] [datetime] NULL,
	[�H�e�H��] [varchar](6) NULL,
	[�B��s��] [varchar](4) NULL,
	[�B��²��] [varchar](20) NULL,
	[���渹�X] [varchar](15) NULL,
	[�o���榡] [varchar](6) NULL,
	[�o�����X] [varchar](12) NULL,
	[�S�O�ƶ�] [varchar](1024) NULL,
	[������Ƶ�] [varchar](512) NULL,
	[�X�f�֭�] [bit] NULL,
	[�֭���] [datetime] NULL,
	[�֭�H��] [varchar](6) NULL,
	[�����ײv] [decimal](6, 3) NULL,
	[�ڤ��ײv] [decimal](6, 3) NULL,
	[�H�����ײv] [decimal](6, 3) NULL,
	[�ܧ���] [datetime] NULL,
	[��s�H��] [varchar](6) NULL,
	[��s���] [datetime] NULL,
 CONSTRAINT [PK_orm_RT] PRIMARY KEY CLUSTERED 
(
	[�Ǹ�] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[orm_RT] ADD  CONSTRAINT [DF_orm_RT_��s���]  DEFAULT (getdate()) FOR [��s���]
GO

INSERT INTO Dc2..orm_RT
SELECT [�Ǹ�]
      ,RTRIM([�q�渹�X])
      ,[����]
      ,RTRIM([�Ȥ�s��])
      ,RTRIM([�Ȥ�²��])
      ,[������]
      ,RTRIM([�Ȥᵥ��])
      ,[���ʮw��]
      ,RTRIM([���ڤ覡])
      ,RTRIM([�K�Q�c])
      ,[��]
      ,[�c��]
      ,[�������B]
      ,[�B�O����]
      ,[�B�O�ꦬ]
      ,[�B�O��I]
      ,[�w�����B]
      ,[�w�����]
      ,[�H�e���]
      ,RTRIM([�H�e�H��])
      ,RTRIM([�B��s��])
      ,RTRIM([�B��²��])
      ,RTRIM([���渹�X])
      ,RTRIM([�o���榡])
      ,RTRIM([�o�����X])
      ,RTRIM([�S�O�ƶ�])
      ,RTRIM([������Ƶ�])
      ,[�X�f�֭�]
      ,[�֭���]
      ,RTRIM([�֭�H��])
      ,[�����ײv]
      ,[�ڤ��ײv]
      ,[�H�����ײv]
      ,[�ܧ���]
      ,RTRIM([��s�H��])
      ,[��s���]
FROM Bc2..orm_RT;
