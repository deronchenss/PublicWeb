USE [Dc2]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[paku]') AND type in (N'U'))
DROP TABLE [dbo].[paku]
GO

CREATE TABLE [dbo].[paku](
	[�Ǹ�] [int] NOT NULL,
	[INVOICE] [varchar](8) NULL,
	[SUPLU_SEQ] [int] NULL,
	[PAKU2_SEQ] [int] NULL,
	[�Ȥ�s��] [varchar](8) NULL,
	[�Ȥ�²��] [varchar](10) NULL,
	[�˫~���X] [varchar](18) NULL,
	[�[�{����] [varchar](15) NULL,
	[�Ȯɫ���] [varchar](15) NULL,
	[���~����] [varchar](80) NULL,
	[���] [varchar](6) NULL,
	[�������] [decimal](9, 3) NULL,
	[�x�����] [decimal](9, 2) NULL,
	[�~�����O] [varchar](3) NULL,
	[�~�����] [decimal](9, 3) NULL,
	[�X�f�ƶq] [decimal](9, 3) NULL,
	[�t�ӽs��] [varchar](8) NULL,
	[�t��²��] [varchar](10) NULL,
	[FREE] [bit] NULL,
	[����ݳq��] [bit] NULL,
	[ATTN] [varchar](2) NULL,
	[�c��] [varchar](4) NULL,
	[�b��] [decimal](5, 2) NULL,
	[��] [decimal](5, 2) NULL,
	[�ܧ���] [datetime] NULL,
	[�w�R��] [bit] NULL,
	[�إߤH��] [varchar](20) NULL,
	[�إߤ��] [datetime] NULL,
	[��s�H��] [varchar](20) NULL,
	[��s���] [datetime] NULL,
 CONSTRAINT [PK_paku] PRIMARY KEY CLUSTERED 
(
	[�Ǹ�] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE INDEX paku_IDX_INVOICE ON [paku]([INVOICE]);
CREATE INDEX paku_IDX_SUPLU_SEQ ON [paku]([SUPLU_SEQ]);
CREATE INDEX paku_IDX_PAKU2_SEQ ON [paku]([PAKU2_SEQ]);


ALTER TABLE [dbo].[paku] ADD  CONSTRAINT [DF_paku_�������]  DEFAULT ((0)) FOR [�������]
ALTER TABLE [dbo].[paku] ADD  CONSTRAINT [DF_paku_�x�����]  DEFAULT ((0)) FOR [�x�����]
ALTER TABLE [dbo].[paku] ADD  CONSTRAINT [DF_paku_�~�����]  DEFAULT ((0)) FOR [�~�����]
ALTER TABLE [dbo].[paku] ADD  CONSTRAINT [DF_paku_�X�f�ƶq]  DEFAULT ((0)) FOR [�X�f�ƶq]
ALTER TABLE [dbo].[paku] ADD  CONSTRAINT [DF_paku_��s���]  DEFAULT (getdate()) FOR [��s���]
GO

INSERT INTO Dc2..paku
SELECT [�Ǹ�], RTRIM([INVOICE]), 
	(SELECT C.[�Ǹ�] FROM Bc2..suplu2 C WHERE C.[�[�{����] = P.[�[�{����] AND C.[�t�ӽs��] = P.[�t�ӽs��]) [SUPLU_SEQ], 
	0 [PAKU2_SEQ],
	RTRIM([�Ȥ�s��]), RTRIM([�Ȥ�²��]), RTRIM([�˫~���X]), RTRIM([�[�{����]),
	RTRIM([�Ȯɫ���]), RTRIM([���~����]), RTRIM([���]), [�������],
	[�x�����], RTRIM([�~�����O]), [�~�����], [�X�f�ƶq], RTRIM([�t�ӽs��]), RTRIM([�t��²��]),
	[FREE], [����ݳq��], RTRIM([ATTN]), RTRIM([�c��]), [�b��], [��], [�ܧ���], [�w�R��],
	RTRIM([��s�H��]) [�إߤH��], [��s���] [�إߤ��], RTRIM([��s�H��]), [��s���]
FROM Bc2..paku P;
