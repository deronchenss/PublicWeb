USE [Dc2]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[reca]') AND type in (N'U'))
DROP TABLE [dbo].[reca]
GO

CREATE TABLE [dbo].[reca](
	[�Ǹ�] [int] NOT NULL,
	[PUD_SEQ] [int] NULL,
	[���] [varchar](4) NULL,
	[�I���帹] [varchar](9) NULL,
	[�I�����] [datetime] NULL,
	[���ʳ渹] [varchar](9) NULL,
	[�q�渹�X] [varchar](20) NULL,
	[�t�ӽs��] [varchar](8) NULL,
	[�t��²��] [varchar](10) NULL,
	[�[�{����] [varchar](15) NULL,
	[�t�ӫ���] [varchar](19) NULL,
	[���~����] [varchar](40) NULL,
	[���] [varchar](6) NULL,
	[�I���ƶq] [decimal](9, 2) NULL,
	[�w�w�J�w] [decimal](9, 2) NULL,
	[�J�w�c��] [decimal](6, 2) NULL,
	[�w��] [varchar](12) NULL,
	[�w��] [varchar](4) NULL,
	[��ڤJ�w] [decimal](9, 2) NULL,
	[�Wú�ƶq] [decimal](9, 2) NULL,
	[�x�����] [decimal](9, 2) NULL,
	[�������] [decimal](9, 3) NULL,
	[�H�������] [decimal](9, 2) NULL,
	[�~�����O] [varchar](3) NULL,
	[�~�����] [decimal](9, 2) NULL,
	[�Ȥ�s��] [varchar](8) NULL,
	[�Ȥ�²��] [varchar](10) NULL,
	[�I���Ƶ�] [varchar](240) NULL,
	[�b�Ȥ���] [varchar](1) NULL,
	[��f] [varchar](6) NULL,
	[�ӳf�B�z] [varchar](1) NULL,
	[�־P��] [decimal](9, 2) NULL,
	[�w��f] [bit] NULL,
	[�Ƴf����] [bit] NULL,
	[��f����] [bit] NULL,
	[�e�f�d��] [bit] NULL,
	[�妸] [varchar](1) NULL,
	[���ʤ��] [datetime] NULL,
	[���ʥ��] [datetime] NULL,
	[�w�R��] [bit] NULL,
	[�ܧ���] [datetime] NULL,
	[��s�H��] [varchar](6) NULL,
	[��s���] [datetime] NULL,
 CONSTRAINT [PK_reca] PRIMARY KEY CLUSTERED 
(
	[�Ǹ�] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[reca] ADD  CONSTRAINT [DF_reca_��s���]  DEFAULT (getdate()) FOR [��s���]
GO

INSERT INTO Dc2..reca with(tablock)
SELECT [�Ǹ�],
	(SELECT TOP 1 P.�Ǹ� FROM Bc2..pud P WHERE R.���ʳ渹 = P.���ʳ渹 AND R.[�[�{����] = P.[�[�{����] AND R.�t�ӽs�� = P.�t�ӽs�� AND R.�q�渹�X = P.�q�渹�X) [PUD_SEQ],
	RTRIM([���]),
	RTRIM([�I���帹]),
	[�I�����],
	RTRIM([���ʳ渹]),
	RTRIM([�q�渹�X]),
	RTRIM([�t�ӽs��]),
	RTRIM([�t��²��]),
	RTRIM([�[�{����]),
	RTRIM([�t�ӫ���]),
	RTRIM([���~����]),
	RTRIM([���]) ,
	[�I���ƶq],
	[�w�w�J�w],
	[�J�w�c��],
	RTRIM([�w��]),
	RTRIM([�w��]),
	[��ڤJ�w],
	[�Wú�ƶq],
	[�x�����],
	[�������],
	[�H�������],
	RTRIM([�~�����O]),
	[�~�����],
	RTRIM([�Ȥ�s��]),
	RTRIM([�Ȥ�²��]),
	RTRIM([�I���Ƶ�]),
	RTRIM([�b�Ȥ���]),
	RTRIM([��f]),
	RTRIM([�ӳf�B�z]),
	[�־P��],
	[�w��f],
	[�Ƴf����],
	[��f����],
	[�e�f�d��],
	RTRIM([�妸]),
	[���ʤ��],
	[���ʥ��],
	[�w�R��],
	[�ܧ���],
	RTRIM([��s�H��]),
	[��s���]
FROM Bc2..reca R

GO

--�¸�� ���ʳ渹 + X
update reca 
set PUD_SEQ = pud.�Ǹ�
from reca join pud on 'X' + reca.���ʳ渹 = pud.���ʳ渹 AND reca.[�[�{����] = pud.[�[�{����] AND reca.�t�ӽs�� = pud.�t�ӽs�� AND reca.�q�渹�X = pud.�q�渹�X
WHERE reca.PUD_SEQ IS NULL

