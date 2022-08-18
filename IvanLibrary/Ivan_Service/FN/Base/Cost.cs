using System.Data;
using System.Web;

namespace Ivan_Service.FN.Base
{
    public class Cost : LogicBase
    {
        public Cost(HttpContext _context)
        {
            context = _context;
        }

        DataTable dt = new DataTable();
        string SQL_STR = "";

        #region Cost_MMT
        public DataTable Cost_MMT_Search()
        {
            SQL_STR = @" 
                SELECT TOP 500 C.[開發中], C.[產品狀態], C.[頤坊型號], C.[銷售型號], C.[廠商型號], C.[廠商簡稱], C.[單位], C.[外幣幣別], 
                               IIF(C.[台幣單價] = 0,'', CONVERT(VARCHAR,CAST(C.[台幣單價] AS MONEY),1)) [台幣單價],
                               IIF(C.[美元單價] = 0,'', CONVERT(VARCHAR,CAST(C.[美元單價] AS MONEY),1)) [美元單價],
                               IIF(C.[單價_2] = 0,'', CONVERT(VARCHAR,CAST(C.[單價_2] AS MONEY),1)) [單價_2],
                               IIF(C.[單價_3] = 0,'', CONVERT(VARCHAR,CAST(C.[單價_3] AS MONEY),1)) [單價_3],
                               IIF(C.[MIN_1] = 0,'', REPLACE(CONVERT(VARCHAR,CAST(C.[MIN_1] AS MONEY),1),'.00','')) [MIN_1],
                               IIF(C.[MIN_2] = 0,'', REPLACE(CONVERT(VARCHAR,CAST(C.[MIN_2] AS MONEY),1),'.00','')) [MIN_2],
                               IIF(C.[MIN_3] = 0,'', REPLACE(CONVERT(VARCHAR,CAST(C.[MIN_3] AS MONEY),1),'.00','')) [MIN_3],
                               C.[產品說明], C.[暫時型號], C.[備註給開發], C.[備註給採購], C.[UnActive], C.[廠商編號],
                	           C.[圖型啟用], C.[序號], C.[更新人員],
                               CAST(ISNULL((SELECT TOP 1 1 FROM [192.168.1.135].pic.dbo.xpic X WHERE X.[SUPLU_SEQ] = C.[序號]),0) AS BIT) [Has_IMG],
                               CONVERT(VARCHAR(20),C.[最後點收日],23) [最後點收日],
                               CONVERT(VARCHAR(20),C.[最後單價日],23) [最後單價日],
                               LEFT(RTRIM(CONVERT(VARCHAR(20),C.[新增日期],20)),16) [新增日期],
                               LEFT(RTRIM(CONVERT(VARCHAR(20),C.[停用日期],20)),16) [停用日期],
                               LEFT(RTRIM(CONVERT(VARCHAR(20),C.[更新日期],20)),16) [更新日期],
                               C.[更新日期] [sort]
                FROM Dc2..suplu C
                WHERE C.[頤坊型號] LIKE @IM + '%'
                    AND C.[廠商型號] LIKE @SupM + '%'
                    AND C.[廠商編號] LIKE @S_No + '%'
                    AND C.[廠商簡稱] LIKE @S_SName + '%'
                    AND ((C.[新增日期] >= @N_DS AND C.[新增日期] <= DATEADD(DAY,+1,@N_DE)) OR (@N_DS ='' AND @N_DE = '' ))
                    AND ((C.[最後點收日] >= @LCACD_DS AND C.[最後點收日] <= DATEADD(DAY,+1,@LCACD_DE)) OR (@LCACD_DS ='' AND @LCACD_DE = '' ))
                    AND C.[產品說明] LIKE '%' + @PI + '%'
                ORDER BY sort DESC ";
            this.ClearParameter();
            this.SetParameters("IM", context.Request["IM"]);
            this.SetParameters("SupM", context.Request["SupM"]);
            this.SetParameters("S_No", context.Request["S_No"]);
            this.SetParameters("S_SName", context.Request["S_SName"]);
            this.SetParameters("N_DS", context.Request["N_DS"]);
            this.SetParameters("N_DE", context.Request["N_DE"]);
            this.SetParameters("LCACD_DS", context.Request["LCACD_DS"]);
            this.SetParameters("LCACD_DE", context.Request["LCACD_DE"]);
            this.SetParameters("PI", context.Request["PI"]);
            dt = GetDataTableWithLog(SQL_STR);
            return dt;
        }

        public void Cost_MMT_Update(DataTable Request_DT)
        {
            if (Request_DT.Rows.Count > 0)
            {
                for (int i = 0; i < Request_DT.Rows.Count; i++)
                {
                    SQL_STR = @" UPDATE Dc2..suplu
                                 SET [廠商型號] = @廠商型號,
                                     [單位] = @單位,
                                     [台幣單價] = @台幣單價,
                                     [美元單價] = @美元單價,
                                     [外幣單價] = @外幣單價,
                                     [最後單價日] = @最後單價日,
                                     [單價_2] = @單價_2,
                                     [單價_3] = @單價_3,
                                     [MIN_1] = @MIN_1,
                                     [MIN_2] = @MIN_2,
                                     [MIN_3] = @MIN_3,
                                     [產品說明] = @產品說明,
                                     [備註給開發] = @備註給開發,
                                     [備註給採購] = @備註給採購,
                                     [更新人員] = @更新人員, 
                                     [更新日期] = GETDATE()
                                 WHERE [序號] = @序號 ";
                    this.ClearParameter();
                    this.SetParameters("廠商型號",Request_DT.Rows[i]["廠商型號"]);
                    this.SetParameters("單位",Request_DT.Rows[i]["單位"]);
                    this.SetParameters("台幣單價",Request_DT.Rows[i]["台幣單價"]);
                    this.SetParameters("美元單價",Request_DT.Rows[i]["美元單價"]);
                    this.SetParameters("外幣單價",Request_DT.Rows[i]["外幣單價"]);
                    this.SetParameters("最後單價日",Request_DT.Rows[i]["最後單價日"]);
                    this.SetParameters("單價_2",Request_DT.Rows[i]["單價_2"]);
                    this.SetParameters("單價_3",Request_DT.Rows[i]["單價_3"]);
                    this.SetParameters("MIN_1",Request_DT.Rows[i]["MIN_1"]);
                    this.SetParameters("MIN_2",Request_DT.Rows[i]["MIN_2"]);
                    this.SetParameters("MIN_3",Request_DT.Rows[i]["MIN_3"]);
                    this.SetParameters("產品說明",Request_DT.Rows[i]["產品說明"]);
                    this.SetParameters("備註給開發",Request_DT.Rows[i]["備註給開發"]);
                    this.SetParameters("備註給採購",Request_DT.Rows[i]["備註給採購"]);
                    this.SetParameters("更新人員", Request_DT.Rows[i]["更新人員"]);
                    this.SetParameters("序號", Request_DT.Rows[i]["序號"]);

                    this.SetTran();
                    int TT = Execute(SQL_STR);
                    this.TranCommit();
                }
            }
        }

        #endregion
    }


}
