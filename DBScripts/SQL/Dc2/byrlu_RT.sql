USE [Dc2]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[byrlu_RT]') AND type in (N'U'))
DROP TABLE [dbo].[byrlu_RT]
GO

CREATE TABLE [dbo].[byrlu_RT](
	[�Ǹ�] [int] NOT NULL,
	[SUPLU_SEQ] [int] NULL,
	[�t�ӽs��] [varchar](8) NULL,
	[�t��²��] [varchar](10) NULL,
	[�[�{����] [varchar](15) NULL,
	[²�u����] [varchar](40) NULL,
	[���] [varchar](6) NULL,
	[�̫�����] [datetime] NULL,
	[���~����] [varchar](10) NULL,
	[�w��] [int] NULL,
	[�S��] [int] NULL,
	[�S���}�l] [datetime] NULL,
	[�S���I��] [datetime] NULL,
	[�P�P�j��] [varchar](20) NULL,
	[�P�P�p��] [varchar](40) NULL,
	[�P�P�}�l] [datetime] NULL,
	[�P�P�I��] [datetime] NULL,
	[�x�����_1] [int] NULL,
	[�x�����_2] [int] NULL,
	[�x�����_3] [int] NULL,
	[�x�����_4] [int] NULL,
	[�x�����_5] [int] NULL,
	[�x�����_6] [int] NULL,
	[����S��] [int] NULL,
	[������_1] [int] NULL,
	[������_2] [int] NULL,
	[������_3] [int] NULL,
	[���䦨��] [decimal](9, 3) NULL,
	[�֭�����] [decimal](5, 2) NULL,
	[�֭����] [int] NULL,
	[�֭����] [decimal](8, 2) NULL,
	[���X�L��] [bit] NULL,
	[��ݤJ�w] [bit] NULL,
	[��������1] [int] NULL,
	[��������2] [int] NULL,
	[��������3] [int] NULL,
	[�^�廡��] [varchar](80) NULL,
	[���Τ��] [datetime] NULL,
	[�Ƶ�] [varchar](1024) NULL,
	[����] [bit] NULL,
	[�w�R��] [bit] NULL,
	[�ܧ���] [datetime] NULL,
	[��s�H��] [varchar](6) NULL,
	[��s���] [datetime] NULL,
 CONSTRAINT [PK_byrlu_RT] PRIMARY KEY CLUSTERED 
(
	[�Ǹ�] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[byrlu_RT] ADD  CONSTRAINT [DF_byrlu_RT_��s���]  DEFAULT (getdate()) FOR [��s���]
GO



INSERT INTO Dc2..byrlu_RT
SELECT [�Ǹ�]
	  ,(SELECT [�Ǹ�] FROM Bc2..suplu2 C WHERE C.�t�ӽs�� = byrlu_RT.�t�ӽs�� AND C.�[�{���� = byrlu_RT.�[�{����) [SUPLU_SEQ]
      ,RTRIM([�t�ӽs��])
      ,RTRIM([�t��²��])
      ,RTRIM([�[�{����])
      ,RTRIM([²�u����])
      ,RTRIM([���])
      ,[�̫�����]
      ,RTRIM([���~����])
      ,[�w��]
      ,[�S��]
      ,[�S���}�l]
      ,[�S���I��]
      ,RTRIM([�P�P�j��])
      ,RTRIM([�P�P�p��])
      ,[�P�P�}�l]
      ,[�P�P�I��]
      ,[�x�����_1]
      ,[�x�����_2]
      ,[�x�����_3]
      ,[�x�����_4]
      ,[�x�����_5]
      ,[�x�����_6]
      ,[����S��]
      ,[������_1]
      ,[������_2]
      ,[������_3]
      ,[���䦨��]
      ,[�֭�����]
      ,[�֭����]
      ,[�֭����]
      ,[���X�L��]
      ,[��ݤJ�w]
      ,[��������1]
      ,[��������2]
      ,[��������3]
      ,RTRIM([�^�廡��])
      ,[���Τ��]
      ,RTRIM([�Ƶ�])
      ,[����]
      ,[�w�R��]
      ,[�ܧ���]
      ,RTRIM([��s�H��])
      ,[��s���]
FROM Bc2..byrlu_RT;
