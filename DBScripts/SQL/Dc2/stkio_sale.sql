USE Dc2;
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stkio_sale]') AND type in (N'U'))
DROP TABLE [dbo].[stkio_sale]

CREATE TABLE [dbo].[stkio_sale](
	[�Ǹ�] [int] NOT NULL,
	[STKIO_SEQ] [int] NULL,
	[pm_no] [varchar](12) NULL,
	[�q�渹�X] [varchar](20) NULL,
	[�X�f���] [datetime] NULL,
	[�t�ӽs��] [varchar](8) NULL,
	[�t��²��] [varchar](10) NULL,
	[�[�{����] [varchar](15) NULL,
	[�P�⫬��] [varchar](15) NULL,
	[���] [varchar](6) NULL,
	[�X��] [varchar](4) NULL,
	[�J��] [varchar](4) NULL,
	[�X�f��] [decimal](10, 3) NULL,
	[�w��] [varchar](12) NULL,
	[�־P��] [decimal](10, 3) NULL,
	[�Ƶ�] [varchar](30) NULL,
	[�c��S] [varchar](4) NULL,
	[�c��E] [varchar](4) NULL,
	[���U] [varchar](2) NULL,
	[���~�@��] [varchar](2) NULL,
	[�֭�����] [varchar](15) NULL,
	[���J�w] [bit] NULL,
	[�w����] [bit] NULL,
	[�w�R��] [bit] NULL,
	[�ܧ���] [datetime] NULL,
	[�إߤH��] [varchar](6) NULL,
	[�إߤ��] [datetime] NULL,
	[��s�H��] [varchar](6) NULL,
	[��s���] [datetime] NULL,
 CONSTRAINT [PK_stkio_sale] PRIMARY KEY CLUSTERED 
(
	[�Ǹ�] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_stkio_sale] ON [dbo].[stkio_sale]
([��s���] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[stkio_sale] ADD  CONSTRAINT [DF_stkio_sale_�X�f��]  DEFAULT ((0)) FOR [�X�f��]
GO
ALTER TABLE [dbo].[stkio_sale] ADD  CONSTRAINT [DF_stkio_sale_�־P��]  DEFAULT ((0)) FOR [�־P��]
GO
ALTER TABLE [dbo].[stkio_sale] ADD  CONSTRAINT [DF_stkio_sale_��s���]  DEFAULT (getdate()) FOR [��s���]
GO
ALTER TABLE [dbo].[stkio_sale] ADD  CONSTRAINT [DF_stkio_sale_�إߤ��]  DEFAULT (getdate()) FOR [�إߤ��]
GO

INSERT INTO Dc2..stkio_sale with(tablock)
SELECT [�Ǹ�],
	   RTRIM([�X�w�Ǹ�]),
	   RTRIM([pm_no]),
	   RTRIM([�q�渹�X]),
	   RTRIM([�X�f���]),
	   RTRIM([�t�ӽs��]),
	   RTRIM([�t��²��]),
	   RTRIM([�[�{����]),
	   RTRIM([���P����]),
	   RTRIM([���]),
	   RTRIM([�X��]),
	   RTRIM([�J��]),
	   RTRIM([�X�f��]),
	   RTRIM([�w��]),
	   RTRIM([�־P��]),
	   RTRIM([�Ƶ�]),
	   RTRIM([�c��S]),
	   RTRIM([�c��E]),
	   RTRIM([���U]),
	   RTRIM([���~�@��]),
	   RTRIM([�֭�����]),
	   [���J�w],
	   [�w�R��],
	   [�w�R��],
	   [�ܧ���],
       RTRIM([��s�H��]), 
	   [��s���], 
	   RTRIM([��s�H��]), 
	   [��s���]
FROM Bc2..stkio_sale S