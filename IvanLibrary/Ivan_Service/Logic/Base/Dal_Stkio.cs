using Ivan_Dal;
using System.Data;
using System.Web;

namespace Ivan_Service
{
    public class Dal_Stkio : LogicBase
    {
        public Dal_Stkio(HttpContext _context)
        {
            context = _context;
        }

        /// <summary>
        /// 庫存入出查詢 查詢 Return DataTable
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        public DataTable SearchTable()
        {
            DataTable dt = new DataTable();
            string sqlStr = "";

            sqlStr = @"SELECT Top 500 CONVERT(VARCHAR,S.更新日期,23) 更新日期
		                              ,S.廠商簡稱
			                          ,S.頤坊型號
			                          ,S.單位
			                          ,CASE WHEN ISNULL(S.入庫數,0) <> 0 AND ISNULL(S.入庫數,0) - ISNULL(S.核銷數,0) <> 0 THEN ISNULL(S.入庫數,0) - ISNULL(S.核銷數,0) ELSE NULL END 入庫數
			                          ,CASE WHEN ISNULL(S.出庫數,0) <> 0 AND ISNULL(S.出庫數,0) - ISNULL(S.核銷數,0) <> 0 THEN ISNULL(S.出庫數,0) - ISNULL(S.核銷數,0) ELSE NULL END 出庫數
                                      ,{0} 扣快取
			                          ,S.訂單號碼
			                          ,S.單據編號
			                          ,IIF(S.異動前庫存 = 0, NULL, S.異動前庫存) 異動前庫存
			                          ,IIF(SU.大貨庫存數 = 0, NULL, SU.大貨庫存數) AS 大貨庫存數
			                          ,IIF(SU.分配庫存數 = 0, NULL, SU.分配庫存數) AS 分配庫存數
			                          ,S.備註
			                          ,S.庫位
			                          ,S.庫區
			                          ,S.帳項
			                          ,S.廠商編號
			                          ,S.客戶編號
			                          ,S.客戶簡稱
			                          ,S.內銷入庫
			                          ,S.更新人員
			                          ,S.序號
			                          ,CASE WHEN (SELECT TOP 1 1 FROM [192.168.1.135].pic.dbo.xpic X WHERE X.[SUPLU_SEQ] = S.SUPLU_SEQ) = 1 THEN 'Y' ELSE 'N' END [Has_IMG]
			                          ,S.SUPLU_SEQ
                                      ,CASE WHEN ISNULL(SU.大貨庫存數,0) >= ISNULL(S.出庫數,0) - ISNULL(S.核銷數,0) AND ISNULL(S.出庫數,0) - ISNULL(S.核銷數,0) > 0 AND ISNULL(SU.大貨庫存數,0) >= ISNULL(SU.分配庫存數,0) THEN 'Y' ELSE 'N' END 庫存足夠
                                      ,CASE WHEN ISNULL(SU.大貨庫存數,0) >= ISNULL(S.出庫數,0) - ISNULL(S.核銷數,0) AND ISNULL(S.出庫數,0) - ISNULL(S.核銷數,0) > 0 AND ISNULL(SU.大貨庫存數,0) < ISNULL(SU.分配庫存數,0) THEN 'Y' ELSE 'N' END 分配數不足
                        FROM {1} S
                        JOIN suplu SU ON S.SUPLU_SEQ = SU.序號
                        WHERE ISNULL(S.已刪除,0) != 1
                        AND (ISNULL(S.入庫數,0) + ISNUll(S.出庫數,0)) != 0
                         ";

            //共用function 需調整日期名稱,form !=, 簡稱類, 串TABLE 簡稱 
            foreach (string form in context.Request.Form)
            {
                if (!string.IsNullOrEmpty(context.Request[form]) && form != "Call_Type")
                {
                    string debug = context.Request[form];
                    switch (form)
                    {
                        case "產品說明":
                        case "廠商簡稱":
                            sqlStr += " AND ISNULL(S.[" + form + "],'') LIKE '%' + @" + form + " + '%' ";
                            this.SetParameters(form, context.Request[form]);
                            break;
                        case "更新日期_S":
                            sqlStr += " AND CONVERT(DATE,S.[更新日期]) >= @更新日期_S";
                            this.SetParameters(form, context.Request[form]);
                            break;
                        case "更新日期_E":
                            sqlStr += " AND CONVERT(DATE,S.[更新日期]) <= @更新日期_E";
                            this.SetParameters(form, context.Request[form]);
                            break;
                        case "查詢出入庫":
                            if ("入庫".Equals(context.Request[form]))
                            {
                                sqlStr += " AND ISNULL(S.入庫數,0) <> 0";
                            }
                            else if ("出庫".Equals(context.Request[form]))
                            {
                                sqlStr += " AND ISNULL(S.出庫數,0) <> 0";
                            }
                            break;
                        case "資料來源":
                            if("0".Equals(context.Request[form]))
                            {
                                sqlStr = string.Format(sqlStr, "NULL", "stkio");

                            }
                            else if ("1".Equals(context.Request[form]))
                            {
                                sqlStr = string.Format(sqlStr, "IIF(S.實扣快取數=0,NULL,S.實扣快取數)", "stkioh");
                            }
                            break;
                        default:
                            sqlStr += " AND ISNULL(S.[" + form + "],'') LIKE @" + form + " + '%'";
                            this.SetParameters(form, context.Request[form]);
                            break;
                    }
                }
            }

            sqlStr += " ORDER BY S.頤坊型號, S.廠商編號 ";

            dt = GetDataTableWithLog(sqlStr);
            return dt;
        }

        /// <summary>
        /// 樣品準備作業 查詢 Return DataTable
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        public DataTable SearchTableForSample()
        {
            DataTable dt = new DataTable();
            string sqlStr = "";

            sqlStr = @"SELECT DISTINCT Top 500 {0} 點收批號 
					   			      ,A.頤坊型號
					   			      ,A.產品說明
					   			      ,A.單位
					   			      ,IIF(A.內湖庫存數 = 0, NULL, A.內湖庫存數) 內湖庫存數
								      ,IIF(A.內湖庫存數 IS NULL, 0, A.內湖庫存數) 備貨數量
					   			      ,A.內湖庫位 內湖庫位
					   			      ,{1} 到貨處理
					   			      ,A.廠商編號
					   			      ,A.廠商簡稱
					   			      ,A.暫時型號
					   			      ,{2} 採購單號
					   			      ,A.序號
					   			      ,A.更新人員
					   			      ,CONVERT(VARCHAR,A.更新日期,23) 更新日期
                                      ,CAST(ISNULL((SELECT TOP 1 1 FROM [192.168.1.135].pic.dbo.xpic X WHERE X.[SUPLU_SEQ] = A.序號),0) AS BIT) [Has_IMG]
					   FROM SUPLU A ";

            foreach (string form in context.Request.Form)
            {
                if (!string.IsNullOrEmpty(context.Request[form]) && form != "Call_Type" && form != "DATA_SOURCE")
                {
                    string debug = context.Request[form];
                    switch (form)
                    {
                        case "點收日期_S":
                        case "點收日期_E":
                        case "採購單號":
                        case "點收批號":
                            sqlStr = string.Format(sqlStr, "ISNULL(R.點收批號, '')", "ISNULL(P.到貨處理, '')", "ISNULL(R.採購單號, '')");
                            sqlStr += @" INNER JOIN PUDU P ON A.序號 = P.SUPLU_SEQ
										 INNER JOIN recua R ON P.序號 = R.PUDU_SEQ ";
                            break;
                        case "訂單號碼":
                            sqlStr = string.Format(sqlStr, "ISNULL(ST.訂單號碼, '')", "''", "''");
                            sqlStr += @" INNER JOIN stkioh ST ON A.序號 = ST.SUPLU_SEQ ";
                            break;
                    }
                }
            }

            if (sqlStr.IndexOf("{0}") != -1)
            {
                sqlStr = string.Format(sqlStr, "''", "''", "''");
            }

            sqlStr += "WHERE 1=1";
            //共用function 需調整日期名稱,form !=, 簡稱類, 串TABLE 簡稱 
            foreach (string form in context.Request.Form)
            {
                if (!string.IsNullOrEmpty(context.Request[form]) && form != "Call_Type" && form != "DATA_SOURCE")
                {
                    string debug = context.Request[form];
                    switch (form)
                    {
                        case "點收日期_S":
                            sqlStr += " AND CONVERT(DATE,R.[點收日期]) >= @點收日期_S";
                            this.SetParameters(form, context.Request[form]);
                            break;
                        case "點收日期_E":
                            sqlStr += " AND CONVERT(DATE,R.[點收日期]) <= @點收日期_E";
                            this.SetParameters(form, context.Request[form]);
                            break;
                        case "採購單號":
                        case "點收批號":
                            sqlStr += " AND ISNULL(R.[" + form + "],'') LIKE @" + form + " + '%'";
                            this.SetParameters(form, context.Request[form]);
                            break;
                        case "訂單號碼":
                            sqlStr += " AND ISNULL(ST.[" + form + "],'') LIKE @" + form + " + '%'";
                            this.SetParameters(form, context.Request[form]);
                            break;
                        case "廠商簡稱":
                            sqlStr += " AND ISNULL(A.[廠商簡稱],'') LIKE '%' + @廠商簡稱 + '%'";
                            this.SetParameters(form, context.Request[form]);
                            break;
                        default:
                            sqlStr += " AND ISNULL(A.[" + form + "],'') LIKE @" + form + " + '%'";
                            this.SetParameters(form, context.Request[form]);
                            break;
                    }
                }
            }

            dt = GetDataTableWithLog(sqlStr);
            return dt;
        }
    }
}
