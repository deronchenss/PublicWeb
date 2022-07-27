USE [Dc2]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[paku]') AND type in (N'U'))
DROP TABLE [dbo].[paku]
GO

CREATE TABLE [dbo].[paku](
	[�Ǹ�] [int] NOT NULL,
	[INVOICE] [char](8) NULL,
	[SUPLU_SEQ] [int] NULL,
	[PAKU2_SEQ] [int] NULL,
	[�Ȥ�s��] [char](8) NULL,
	[�Ȥ�²��] [char](10) NULL,
	[�˫~���X] [char](18) NULL,
	[�[�{����] [char](15) NULL,
	[�Ȯɫ���] [char](15) NULL,
	[���~����] [varchar](80) NULL,
	[���] [char](6) NULL,
	[�������] [decimal](9, 3) NULL,
	[�x�����] [decimal](9, 2) NULL,
	[�~�����O] [char](3) NULL,
	[�~�����] [decimal](9, 3) NULL,
	[�X�f�ƶq] [decimal](9, 3) NULL,
	[�t�ӽs��] [char](8) NULL,
	[�t��²��] [char](10) NULL,
	[FREE] [bit] NULL,
	[����ݳq��] [bit] NULL,
	[ATTN] [char](2) NULL,
	[�c��] [char](4) NULL,
	[�b��] [decimal](5, 2) NULL,
	[��] [decimal](5, 2) NULL,
	[�ܧ���] [smalldatetime] NULL,
	[�w�R��] [bit] NULL,
	[�إߤH��] [char](6) NULL,
	[�إߤ��] [smalldatetime] NULL,
	[��s�H��] [char](6) NULL,
	[��s���] [smalldatetime] NULL,
 CONSTRAINT [PK_paku] PRIMARY KEY CLUSTERED 
(
	[�Ǹ�] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


ALTER TABLE [dbo].[paku] ADD  CONSTRAINT [DF_paku_�������]  DEFAULT ((0)) FOR [�������]
GO

ALTER TABLE [dbo].[paku] ADD  CONSTRAINT [DF_paku_�x�����]  DEFAULT ((0)) FOR [�x�����]
GO

ALTER TABLE [dbo].[paku] ADD  CONSTRAINT [DF_paku_�~�����]  DEFAULT ((0)) FOR [�~�����]
GO

ALTER TABLE [dbo].[paku] ADD  CONSTRAINT [DF_paku_�X�f�ƶq]  DEFAULT ((0)) FOR [�X�f�ƶq]
GO

ALTER TABLE [dbo].[paku] ADD  CONSTRAINT [DF_paku_��s���]  DEFAULT (getdate()) FOR [��s���]
GO


