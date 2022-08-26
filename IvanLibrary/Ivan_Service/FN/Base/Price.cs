using Ivan_Dal;
using System.Data;
using System.Web;

namespace Ivan_Service.FN.Base
{
    public class Price : DataOperator
    {
        DataTable dt = new DataTable();
        string SQL_STR = "";

        #region Price_MMC
        public DataTable Price_MMC_Search(DataTable Request_DT)
        {
            SQL_STR = @" 
                SELECT TOP 500 P.[開發中], P.[客戶簡稱], P.[頤坊型號], C.[銷售型號], C.[產品狀態], P.[美元單價], P.[台幣單價], P.[產品說明], P.[單位], P.[客戶型號], 
                	P.[MIN_1], P.[單價_2], P.[廠商編號], P.[廠商簡稱], P.[客戶編號], P.[序號], P.[更新人員], P.[SUPLU_SEQ],
                    CAST(ISNULL((SELECT TOP 1 1 FROM [192.168.1.135].pic.dbo.xpic X WHERE X.[SUPLU_SEQ] = P.[SUPLU_SEQ]),0) AS BIT) [Has_IMG],
                	LEFT(RTRIM(CONVERT(VARCHAR(20),P.[更新日期],20)),16) [更新日期], P.[更新日期] [sort]
                FROM Dc2..Byrlu P
                    INNER JOIN Dc2..suplu C ON C.[序號] = P.[SUPLU_SEQ]
                WHERE P.[客戶編號] LIKE '%' + @客戶編號
                    AND P.[客戶簡稱] LIKE @客戶簡稱 + '%'
                    AND P.[廠商編號] LIKE @廠商編號 + '%'
                    AND P.[廠商簡稱] LIKE @廠商簡稱 + '%'
                    AND P.[頤坊型號] LIKE @頤坊型號 + '%'
                    AND P.[客戶型號] LIKE @客戶型號 + '%'
                    --AND C.[銷售型號] LIKE @銷售型號 + '%'
                    AND ((P.[更新日期] >= @DS AND P.[更新日期] <= DATEADD(DAY,+1,@DE)) OR (@DS ='' AND @DE = '' ))
                    AND P.[產品說明] LIKE '%' + @產品說明 + '%'
                ORDER BY [sort] DESC ";
            this.ClearParameter();
            for (int i = 0; i < Request_DT.Columns.Count; i++)
            {
                this.SetParameters(Request_DT.Columns[i].ColumnName, Request_DT.Rows[0][i]);
            }
            dt = GetDataTable(SQL_STR);
            return dt;
        }

        public void Price_MMC_Copy(DataTable Request_DT)
        {
            if (Request_DT.Rows.Count > 0)
            {
                for (int i = 0; i < Request_DT.Rows.Count; i++)
                {
                    SQL_STR = @" INSERT INTO Dc2..byrlu
	                                 ([SUPLU_SEQ], [頤坊型號], [產品說明], [單位], [最後單價日], [台幣單價], [單價_2], [單價_3], [單價_4], [單價_5], 
	                                  [min_2], [min_3], [min_4], [min_5], [外幣幣別], [外幣單價], [廠商編號], [廠商簡稱],
	                                  [序號], 
	                                  [開發中], [客戶編號], [客戶簡稱], [客戶型號], [美元單價], [min_1], [更新人員], [更新日期])
                                 SELECT TOP 1 P.[SUPLU_SEQ], C.[頤坊型號], P.[產品說明], P.[單位], 
	                                 C.[最後單價日], P.[台幣單價], P.[單價_2], P.[單價_3], P.[單價_4], P.[單價_5], 
	                                 P.[min_2], P.[min_3], P.[min_4], P.[min_5], P.[外幣幣別], P.[外幣單價], 
	                                 C.[廠商編號], C.[廠商簡稱],
	                                 [序號] = (SELECT COALESCE(MAX(X.[序號]),0) + 1 FROM Dc2..byrlu X),
	                                 [開發中] = @開發中, 
	                                 [客戶編號] = @客戶編號, 
	                                 [客戶簡稱] = @客戶簡稱, 
	                                 [客戶型號] = @客戶型號,
	                                 [美元單價] = @美元單價, 
	                                 [min_1] = @MIN_1, 
	                                 [更新人員] = @更新人員,
	                                 [更新日期] = GETDATE()
                                 FROM Dc2..byrlu P
	                                 INNER JOIN Dc2..suplu C ON C.[序號] = P.[SUPLU_SEQ]
                                 WHERE P.[序號] = @OLD_BYRLU_SEQ ";
                    this.ClearParameter();
                    for (int j = 0; j < Request_DT.Columns.Count; j++)
                    {
                        this.SetParameters(Request_DT.Columns[j].ColumnName, Request_DT.Rows[i][j]);
                    }
                    this.SetTran();
                    int TT = Execute(SQL_STR);
                    this.TranCommit();
                }
            }
        }
        #endregion
    }

}
