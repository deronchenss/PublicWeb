USE [Dc2]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[byrlu_RT]') AND type in (N'U'))
DROP TABLE [dbo].[byrlu_RT]
GO

CREATE TABLE [dbo].[byrlu_RT](
	[序號] [int] NOT NULL,
	[SUPLU_SEQ] [int] NULL,
	[廠商編號] [varchar](8) NULL,
	[廠商簡稱] [varchar](10) NULL,
	[頤坊型號] [varchar](15) NULL,
	[簡短說明] [varchar](40) NULL,
	[單位] [varchar](6) NULL,
	[最後單價日] [datetime] NULL,
	[產品分類] [varchar](10) NULL,
	[定價] [int] NULL,
	[特價] [int] NULL,
	[特價開始] [datetime] NULL,
	[特價截止] [datetime] NULL,
	[促銷大標] [varchar](20) NULL,
	[促銷小標] [varchar](40) NULL,
	[促銷開始] [datetime] NULL,
	[促銷截止] [datetime] NULL,
	[台幣單價_1] [int] NULL,
	[台幣單價_2] [int] NULL,
	[台幣單價_3] [int] NULL,
	[台幣單價_4] [int] NULL,
	[台幣單價_5] [int] NULL,
	[台幣單價_6] [int] NULL,
	[港幣特價] [int] NULL,
	[港幣單價_1] [int] NULL,
	[港幣單價_2] [int] NULL,
	[港幣單價_3] [int] NULL,
	[香港成本] [decimal](9, 3) NULL,
	[皮革材數] [decimal](5, 2) NULL,
	[皮革單價] [int] NULL,
	[皮革港單] [decimal](8, 2) NULL,
	[條碼印價] [bit] NULL,
	[轉待入庫] [bit] NULL,
	[型錄頁數1] [int] NULL,
	[型錄頁數2] [int] NULL,
	[型錄頁數3] [int] NULL,
	[英文說明] [varchar](80) NULL,
	[停用日期] [datetime] NULL,
	[備註] [varchar](1024) NULL,
	[結案] [bit] NULL,
	[已刪除] [bit] NULL,
	[變更日期] [datetime] NULL,
	[更新人員] [varchar](6) NULL,
	[更新日期] [datetime] NULL,
 CONSTRAINT [PK_byrlu_RT] PRIMARY KEY CLUSTERED 
(
	[序號] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[byrlu_RT] ADD  CONSTRAINT [DF_byrlu_RT_更新日期]  DEFAULT (getdate()) FOR [更新日期]
GO



INSERT INTO Dc2..byrlu_RT
SELECT [序號]
	  ,(SELECT [序號] FROM Bc2..suplu2 C WHERE C.廠商編號 = byrlu_RT.廠商編號 AND C.頤坊型號 = byrlu_RT.頤坊型號) [SUPLU_SEQ]
      ,RTRIM([廠商編號])
      ,RTRIM([廠商簡稱])
      ,RTRIM([頤坊型號])
      ,RTRIM([簡短說明])
      ,RTRIM([單位])
      ,[最後單價日]
      ,RTRIM([產品分類])
      ,[定價]
      ,[特價]
      ,[特價開始]
      ,[特價截止]
      ,RTRIM([促銷大標])
      ,RTRIM([促銷小標])
      ,[促銷開始]
      ,[促銷截止]
      ,[台幣單價_1]
      ,[台幣單價_2]
      ,[台幣單價_3]
      ,[台幣單價_4]
      ,[台幣單價_5]
      ,[台幣單價_6]
      ,[港幣特價]
      ,[港幣單價_1]
      ,[港幣單價_2]
      ,[港幣單價_3]
      ,[香港成本]
      ,[皮革材數]
      ,[皮革單價]
      ,[皮革港單]
      ,[條碼印價]
      ,[轉待入庫]
      ,[型錄頁數1]
      ,[型錄頁數2]
      ,[型錄頁數3]
      ,RTRIM([英文說明])
      ,[停用日期]
      ,RTRIM([備註])
      ,[結案]
      ,[已刪除]
      ,[變更日期]
      ,RTRIM([更新人員])
      ,[更新日期]
FROM Bc2..byrlu_RT;
