USE [Dc2]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DisCount_EAN]') AND type in (N'U'))
DROP TABLE [dbo].[DisCount_EAN]
GO
CREATE TABLE [dbo].[DisCount_EAN](--產品類別-MSRP折扣率
	[序號] [int] NOT NULL,
	[版本] [varchar](2) NULL,
	[排列] [int] NULL,
	[全階代碼] [varchar](2) NULL,
	[價格一階] [varchar](22) NULL,
	[價格二階] [varchar](8) NULL,
	[價格說明] [varchar](55) NULL,
	[價格等級] [varchar](3) NULL,
	[分類編號] [varchar](5) NULL,
	[CP65] [varchar](2) NULL,
	[年齡] [varchar](2) NULL,
	[折扣率C2] [int] NULL,
	[折扣率C3] [int] NULL,
	[折扣率C5] [int] NULL,
	[折扣率C6] [int] NULL,
	[折扣率C7] [int] NULL,
	[折扣率B2] [int] NULL,
	[折扣率B5] [int] NULL,
	[折扣率B6] [int] NULL,
	[折扣率B7] [int] NULL,
	[折扣率2] [int] NULL,
	[折扣率3] [int] NULL,
	[折扣率4] [int] NULL,
	[折扣率5] [int] NULL,
	[折扣率6] [int] NULL,
	[折扣率7] [int] NULL,
	[折扣率8] [int] NULL,
	[折扣率9] [int] NULL,
	[停用日期] [datetime] NULL,
	[變更日期] [datetime] NULL,
	[建立人員] [varchar](20) NULL,
	[建立日期] [datetime] NULL,
	[更新人員] [varchar](20) NULL,
	[更新日期] [datetime] NULL,
 CONSTRAINT [PK_DisCount_EAN] PRIMARY KEY CLUSTERED 
([序號] ASC )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DisCount_EAN] ADD  CONSTRAINT [DF_DisCount_EAN_更新日期]  DEFAULT (getdate()) FOR [更新日期]
CREATE INDEX DisCount_EAN_IDX_CLASS ON [DisCount_EAN]([全階代碼])
GO

INSERT INTO Dc2..[DisCount_EAN] 
SELECT [序號], RTRIM([版本]),
[排列], RTRIM([全階代碼]), RTRIM([價格一階]), RTRIM([價格二階]),RTRIM([價格說明]), RTRIM([價格等級]), RTRIM([分類編號]), RTRIM([CP65]), RTRIM([年齡]),
[折扣率C2], [折扣率C3], [折扣率C5], [折扣率C6], [折扣率C7], [折扣率B2], [折扣率B5], [折扣率B6], [折扣率B7],
[折扣率2], [折扣率3], [折扣率4], [折扣率5], [折扣率6], [折扣率7], [折扣率8], [折扣率9], [停用日期], [變更日期],
RTRIM([更新人員]) [建立人員], [更新日期] [建立日期], RTRIM([更新人員]), [更新日期]
FROM Bc2..DisCount_EAN DE
WHERE 版本 IN ('C3','V3')

