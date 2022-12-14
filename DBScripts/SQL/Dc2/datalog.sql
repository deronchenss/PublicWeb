
USE Dc2;
CREATE TABLE [dbo].[datalog](
    [SEQ] [int] IDENTITY(1,1) NOT NULL,
	[LOG_DATE] [datetime] NULL,
	[USER] [nvarchar](50) NULL,
	[PROG_URL] [NVARCHAR](200) NULL,
	[CALL_TYPE] [NVARCHAR](200) NULL,
	[CALL_CONTEXT] [NVARCHAR](MAX) NULL,
	[SQL_PARAMETERS] [NVARCHAR](MAX) NULL,
	[ERROR_MSG] [NVARCHAR](MAX) NULL,
	[SQL_TEXT] [NVarchar](MAX) NULL,
	[SERVER_IP] [Nvarchar](200) NULL,
	[CLIENT_IP] [Nvarchar](200) NULL,
	[RESULT] [Nvarchar](MAX) NULL,
 CONSTRAINT [PK_datalog] PRIMARY KEY CLUSTERED 
(
    [SEQ] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON)
) ON [PRIMARY]


