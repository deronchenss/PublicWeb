USE [Dc2]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[trf]') AND type in (N'U'))
DROP TABLE [dbo].[trf]
GO

CREATE TABLE [dbo].[trf](
	[�Ǹ�] [int] NOT NULL,
	[�B��s��] [varchar](4) NULL,
	[�B��²��] [varchar](20) NULL,
	[�B��W��] [varchar](50) NULL,
	[�^��W��] [varchar](50) NULL,
	[�B��Ϥ�] [varchar](40) NULL,
	[�֭���] [bit] NULL,
	[�s���a�}] [varchar](50) NULL,
	[�Ҧb�a] [varchar](4) NULL,
	[���O] [varchar](3) NULL,
	[�s���H] [varchar](30) NULL,
	[�q��] [varchar](20) NULL,
	[�ǯu] [varchar](20) NULL,
	[��ʹq��] [varchar](20) NULL,
	[�Τ@�s��] [varchar](8) NULL,
	[email] [varchar](35) NULL,
	[Skype] [varchar](20) NULL,
	[����] [varchar](50) NULL,
	[�X�f�b��] [varchar](14) NULL,
	[���ӫȤ�] [varchar](160) NULL,
	[�̫�����] [datetime] NULL,
	[�U�o�|] [decimal](5, 2) NULL,
	[���n����] [int] NULL,
	[���Τ��] [datetime] NULL,
	[�Ƶ�] [varchar](512) NULL,
	[�ܧ���] [datetime] NULL,
	[�إߤH��] [varchar](6) NULL,
	[�إߤ��] [datetime] NULL,
	[��s�H��] [varchar](6) NULL,
	[��s���] [datetime] NULL,
 CONSTRAINT [PK_trf] PRIMARY KEY CLUSTERED 
(
	[�Ǹ�] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[trf] ADD  CONSTRAINT [DF_trf_��s���]  DEFAULT (getdate()) FOR [��s���]
GO

INSERT INTO Dc2..trf
SELECT [�Ǹ�], RTRIM([�B��s��]), RTRIM([�B��²��]), RTRIM([�B��W��]), RTRIM([�^��W��]),
	RTRIM([�B��Ϥ�]), [�֭���], RTRIM([�s���a�}]), RTRIM([�Ҧb�a]), RTRIM([���O]), RTRIM([�s���H]), RTRIM([�q��]),
	RTRIM([�ǯu]), RTRIM([��ʹq��]), RTRIM([�Τ@�s��]), RTRIM([email]), RTRIM([Skype]), RTRIM([����]),
	RTRIM([�X�f�b��]), RTRIM([���ӫȤ�]), [�̫�����], [�U�o�|], [���n����], [���Τ��], RTRIM([�Ƶ�]), [�ܧ���],
	RTRIM([��s�H��]) [�إߤH��], [��s���] [�إߤ��], RTRIM([��s�H��]), [��s���]
FROM Bc2..trf;
