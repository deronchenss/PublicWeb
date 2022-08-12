using Ivan_Dal;
using System.Data;
using System.Web;

namespace Ivan_Service
{
    public class Dal_Suplu : LogicBase
    {
        public Dal_Suplu(HttpContext _context)
        {
            context = _context;
        }

        /// <summary>
        /// 庫存查詢 查詢 Return DataTable
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        public DataTable SearchTable()
        {
            DataTable dt = new DataTable();
            string sqlStr = "";

            sqlStr = @";WITH PUD_CNT 
                        AS
                        (
                            SELECT SUPLU_SEQ
	                              ,SUM(在途數) 在途數
	                              ,SUM(庫存在途數) 庫存在途數
                            FROM(
                            SELECT SUPLU_SEQ
	                              ,P.採購數量 - ISNULL((SELECT SUM(R.點收數量) FROM reca R WHERE P.序號 = R.PUD_SEQ),0) 在途數
	                              ,CASE WHEN P.訂單號碼 LIKE 'X%' OR P.訂單號碼 LIKE 'WR%' THEN P.採購數量 - ISNULL((SELECT SUM(R.點收數量) FROM reca R WHERE P.序號 = R.PUD_SEQ),0)
	                                    ELSE 0 END 庫存在途數
                            FROM pud P 
                            WHERE ISNULL(P.採購單號,'') != ''
                            AND ISNULL(P.已刪除,0)=0
                            AND P.採購數量 - ISNULL((SELECT SUM(R.點收數量) FROM reca R WHERE P.序號 = R.PUD_SEQ),0) > 0
                            ) P
                            GROUP BY SUPLU_SEQ
                        ),
                        S1 
                        AS
                        (
	                        SELECT 頤坊型號,產品二階, SUM(大貨庫存數) 總庫存
	                        FROM suplu S1 
	                        GROUP BY 頤坊型號,產品二階
                        ) 

                        SELECT  Top 500 S.廠商簡稱
			                           ,S.頤坊型號
			                           ,S.銷售型號
                                       ,S.產品狀態
			                           ,S.單位
			                           ,IIF(S.大貨庫存數 = 0, NULL, S.大貨庫存數) 大貨庫存數
			                           ,IIF(ISNULL(總庫存,0) - 大貨庫存數 = 0, NULL, ISNULL(總庫存,0) - 大貨庫存數)  替代庫存數
			                           ,S.大貨庫位
			                           ,IIF(S.快取庫存數 = 0, NULL, S.快取庫存數) 快取庫存數 
			                           ,S.快取庫位
			                           ,IIF(S.分配庫存數 = 0, NULL, S.分配庫存數) 分配庫存數
			                           ,IIF(P.庫存在途數 = 0, NULL, P.庫存在途數) 庫存在途數
			                           ,IIF(P.在途數 = 0, NULL, P.在途數) 在途數
			                           , CASE WHEN IsNull(S.ISP安全數,0)=1 AND IsNull(S.ISP庫存數,0)>0 THEN '上架' 
			                                  WHEN IsNull(S.ISP安全數,0)=1 AND IsNull(S.ISP庫存數,0)=0 THEN '售完' 
					                          WHEN IsNull(S.ISP安全數,0)=2 THEN '草稿' 
					                          WHEN IsNull(S.ISP安全數,0)=3 THEN '封存' 
					                          ELSE '' END AS ISP上架 
			                           ,IIF(S.大貨安全數 = 0, NULL, S.大貨安全數) 大貨安全數
			                           ,IIF(S.快取安全數 = 0, NULL, S.快取安全數) 快取安全數
			                           ,IIF(S.內湖庫存數 = 0, NULL, S.內湖庫存數) 內湖庫存數
			                           ,S.內湖庫位
			                           ,IIF(S.台北庫存數 = 0, NULL, S.台北庫存數) 台北庫存數
			                           ,S.台北庫位
			                           ,IIF(S.台中庫存數 = 0, NULL, S.台中庫存數) 台中庫存數
			                           ,S.台中庫位
			                           ,IIF(S.高雄庫存數 = 0, NULL, S.高雄庫存數) 高雄庫存數
			                           ,S.高雄庫位
			                           ,IIF(S.託管庫存數 = 0, NULL, S.託管庫存數) 託管庫存數
			                           ,S.託管庫位
			                           ,IIF(S.樣品庫存數 = 0, NULL, S.樣品庫存數) 樣品庫存數
			                           ,S.樣品庫位
			                           ,IIF(S.留底庫存數 = 0, NULL, S.留底庫存數) 留底庫存數
			                           ,S.留底庫位
			                           ,IIF(S.展示庫存數 = 0, NULL, S.展示庫存數) 展示庫存數
			                           ,S.展示庫位
			                           ,IIF(S.展場庫存數 = 0, NULL, S.展場庫存數) 展場庫存數
			                           ,S.展場庫位
			                           ,IIF(S.廠商庫存數 = 0, NULL, S.廠商庫存數) 廠商庫存數
			                           ,S.廠商庫位
			                           ,IIF(S.設計庫存數 = 0, NULL, S.設計庫存數) 設計庫存數
			                           ,S.產品說明
			                           ,S.英文說明--
			                           ,S.大貨庫更
			                           ,S.工時
			                           ,S.廠商型號
			                           ,S.暫時型號
			                           ,S.頤坊條碼
			                           ,S.備註給倉庫
			                           ,S.產品二階
			                           ,S.廠商編號
			                           ,S.開發中
			                           ,S.帳務分類
			                           ,CONVERT(VARCHAR,S.停用日期,23) 停用日期
			                           ,S.序號
			                           --,'現行' AS DBO
			                           ,S.更新人員
			                           ,CONVERT(VARCHAR,S.更新日期,23) 更新日期 
                                       ,CASE WHEN (SELECT TOP 1 1 FROM [192.168.1.135].pic.dbo.xpic X WHERE X.[SUPLU_SEQ] = S.序號) = 1 THEN 'Y' ELSE 'N' END [Has_IMG]
                                       ,CASE WHEN ISNULL(S.大貨安全數,0) > 0 AND ISNULL(S.大貨庫存數,0) + IIF(S.分配庫存數 = 0, NULL, S.分配庫存數) + IIF(P.庫存在途數 = 0, NULL, P.庫存在途數) < ISNULL(S.大貨安全數,0) THEN 'Y' ELSE 'N' END 安全數不足
                        FROM suplu S
                        LEFT JOIN S1 ON S.頤坊型號 = S1.頤坊型號 AND S.產品二階 = S1.產品二階
                        LEFT JOIN PUD_CNT P ON S.序號 = P.SUPLU_SEQ
                        WHERE 1=1 
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
                        case "倉位":
                            if(context.Request[form].Equals("ISP"))
                            {
                                sqlStr += " AND ISNULL(S.[" + context.Request[form] + "安全數],0) != 0 ";
                            }
                            else
                            {
                                sqlStr += " AND ISNULL(S.[" + context.Request[form] + "庫存數],0) != 0 ";
                            }
                            break;
                        case "限門市":
                            if(context.Request[form] == "1")
                            {
                                sqlStr += " AND ISNULL(S.台北安全數,0) + ISNULL(S.台中安全數,0) + ISNULL(S.高雄安全數,0) <> 0 ";
                            }
                            break;
                        case "售完":
                            if (context.Request[form] == "1")
                            {
                                sqlStr += " AND ISNULL(S.ISP安全數,0)=1 AND ISNULL(S.ISP庫存數,0)=0 ";
                            }
                            break;
                        case "草稿":
                            if (context.Request[form] == "1")
                            {
                                sqlStr += " AND ISNULL(S.ISP安全數,0)=2 ";
                            }
                            break;
                        case "封存":
                            if (context.Request[form] == "1")
                            {
                                sqlStr += " AND ISNULL(S.ISP安全數,0)=3 ";
                            }
                            break;
                        case "替代庫存":
                            if (context.Request[form] == "1")
                            {
                                sqlStr += " AND IIF(ISNULL(總庫存,0) - 大貨庫存數 = 0, NULL, ISNULL(總庫存,0) - 大貨庫存數) > 0 ";
                            }
                            break;
                        case "庫位":
                            sqlStr += " AND ISNULL(S.[" + context.Request["倉位"] + "庫位],'') LIKE '%' + @" + form + " + '%' ";
                            this.SetParameters(form, context.Request[form]);
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
