USE [Dc2]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pud]') AND type in (N'U'))
DROP TABLE [dbo].[pud]
GO

CREATE TABLE [dbo].[pud](
	[�Ǹ�] [int] NOT NULL,
	[SUPLU_SEQ] [int] NULL,
	[�q��Ǹ�] [varchar](8) NULL,
	[�q�渹�X] [varchar](20) NULL,
	[�w�s����_�U������] [bit] NULL,
	[�t�ӽs��] [varchar](8) NULL,
	[�t��²��] [varchar](10) NULL,
	[�[�{����] [varchar](15) NULL,
	[���~����] [varchar](40) NULL,
	[���] [varchar](6) NULL,
	[���ʤ��] [datetime] NULL,
	[���ʳ渹] [varchar](9) NULL,
	[���ʼƶq] [decimal](9, 3) NULL,
	[��l�ƶq] [decimal](9, 3) NULL,
	[���ʥ��] [datetime] NULL,
	[�u�t���] [datetime] NULL,
	[������p] [varchar](30) NULL,
	[�x�����] [decimal](9, 2) NULL,
	[�������] [decimal](9, 3) NULL,
	[�H�������] [decimal](9, 2) NULL,
	[�~�����O] [varchar](3) NULL,
	[�~�����] [decimal](9, 2) NULL,
	[�t�ӫ���] [varchar](19) NULL,
	[�����~����] [varchar](15) NULL,
	[���w���f�H] [varchar](18) NULL,
	[ñ�����] [datetime] NULL,
	[��f���] [datetime] NULL,
	[��f�ƶq] [decimal](9, 2) NULL,
	[�I�����] [datetime] NULL,
	[�I���ƶq] [decimal](9, 2) NULL,
	[�զX�~] [bit] NULL,
	[�b�Ȥ���] [varchar](1) NULL,
	[���y] [varchar](1) NULL,
	[����] [varchar](1) NULL,
	[�B�m�N�X] [varchar](1) NULL,
	[�t�ӥ��] [int] NULL,
	[���t�w�s��] [decimal](9, 2) NULL,
	[�˰told] [bit] NULL,
	[�s�~] [bit] NULL,
	[���ƦX��] [bit] NULL,
	[���ʳƵ�] [varchar](30) NULL,
	[�����w����] [decimal](9, 2) NULL,
	[�Ȥ�s��] [varchar](8) NULL,
	[�Ȥ�²��] [varchar](10) NULL,
	[����] [bit] NULL,
	[�f�~�^�x_�U������] [bit] NULL,
	[�w�R��] [bit] NULL,
	[�ܧ���] [datetime] NULL,
	[��s�H��] [varchar](6) NULL,
	[��s���] [datetime] NULL,
 CONSTRAINT [PK_pud] PRIMARY KEY CLUSTERED 
(
	[�Ǹ�] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[pud] ADD  CONSTRAINT [DF_pud_���ʼƶq]  DEFAULT ((0)) FOR [���ʼƶq]
ALTER TABLE [dbo].[pud] ADD  CONSTRAINT [DF_pud_���ļƶq]  DEFAULT ((0)) FOR [��l�ƶq]
ALTER TABLE [dbo].[pud] ADD  CONSTRAINT [DF_pud_�x�����]  DEFAULT ((0)) FOR [�x�����]
ALTER TABLE [dbo].[pud] ADD  CONSTRAINT [DF_pud_�������]  DEFAULT ((0)) FOR [�������]
ALTER TABLE [dbo].[pud] ADD  CONSTRAINT [DF_pud_�H�������]  DEFAULT ((0)) FOR [�H�������]
ALTER TABLE [dbo].[pud] ADD  CONSTRAINT [DF_pud_�~�����]  DEFAULT ((0)) FOR [�~�����]
ALTER TABLE [dbo].[pud] ADD  CONSTRAINT [DF_pud_��f�ƶq]  DEFAULT ((0)) FOR [��f�ƶq]
ALTER TABLE [dbo].[pud] ADD  CONSTRAINT [DF_pud_�I���ƶq]  DEFAULT ((0)) FOR [�I���ƶq]
ALTER TABLE [dbo].[pud] ADD  CONSTRAINT [DF_pud_�t�ӥ��]  DEFAULT ((0)) FOR [�t�ӥ��]
ALTER TABLE [dbo].[pud] ADD  CONSTRAINT [DF_pud_���t�w�s��]  DEFAULT ((0)) FOR [���t�w�s��]
ALTER TABLE [dbo].[pud] ADD  CONSTRAINT [DF_pud_�w��������]  DEFAULT ((0)) FOR [�����w����]
ALTER TABLE [dbo].[pud] ADD  CONSTRAINT [DF_pud_��s���]  DEFAULT (getdate()) FOR [��s���]
GO

INSERT INTO Dc2..pud with(tablock)
SELECT [�Ǹ�],
	(SELECT C.�Ǹ� FROM Bc2..suplu2 C WHERE C.�[�{���� = P.�[�{���� AND C.�t�ӽs�� = P.�t�ӽs��) [SUPLU_SEQ],
	RTRIM([�q��Ǹ�]),
	RTRIM([�q�渹�X]),
	[�w�s����_�U������],
	RTRIM([�t�ӽs��]),
	RTRIM([�t��²��]),
	RTRIM([�[�{����]),
	RTRIM([���~����]),
	RTRIM([���]),
	[���ʤ��],
	RTRIM([���ʳ渹]),
	[���ʼƶq],
	[��l�ƶq],
	[���ʥ��],
	[�u�t���],
	RTRIM([������p]),
	[�x�����],
	[�������],
	[�H�������],
	RTRIM([�~�����O]),
	[�~�����],
	RTRIM([�t�ӫ���]),
	RTRIM([�����~����]),
	RTRIM([���w���f�H]),
	[ñ�����],
	[��f���],
	[��f�ƶq],
	[�I�����],
	[�I���ƶq],
	[�զX�~],
	RTRIM([�b�Ȥ���]),
	RTRIM([���y]),
	RTRIM([����]),
	RTRIM([�B�m�N�X]),
	[�t�ӥ��],
	[���t�w�s��],
	[�˰told],
	[�s�~],
	[���ƦX��],
	RTRIM([���ʳƵ�]),
	[�����w����],
	RTRIM([�Ȥ�s��]),
	RTRIM([�Ȥ�²��]),
	[����],
	[�f�~�^�x_�U������],
	[�w�R��],
	[�ܧ���],
	RTRIM([��s�H��]),
	[��s���]
FROM Bc2..pud P

