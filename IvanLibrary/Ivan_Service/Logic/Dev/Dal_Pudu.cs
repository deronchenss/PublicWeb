using Ivan_Dal;
using System;
using System.Data;
using System.Web;

namespace Ivan_Service
{
    public class Dal_Pudu : LogicBase
    {
        public Dal_Pudu(HttpContext _context)
        {
            context = _context;
        }

        /// <summary>
        /// 樣品點收 查詢 Return DataTable
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        public DataTable SearchTable()
        {
            DataTable dt = new DataTable();
            string sqlStr = "";
			sqlStr = @" SELECT Top 500 
                        P.SUPLU_SEQ,P.採購單號,P.廠商簡稱,P.頤坊型號,
                        P.採購數量,P.客戶簡稱,P.暫時型號,P.單位,P.產品說明,
                        ISNULL(SUM(RA.點收數量),0) 點收數量
                        ,CONVERT(VARCHAR, MAX(RA.點收日期), 111) 點收日期
                        ,ISNULL(SUM(R.到貨數量),0) 到貨數量
                        ,CONVERT(VARCHAR, MAX(R.到貨日期), 111) 到貨日期
                        ,P.工作類別 AS 類別,P.樣品號碼,
                        S.設計圖號,P.廠商型號,P.廠商編號,P.客戶編號,
                        S.圖型啟用,P.序號,P.更新人員
                        ,CONVERT(VARCHAR,P.更新日期, 111) 更新日期
                        ,ISNULL(P.到貨處理,' ') 到貨處理
                        ,CONVERT(VARCHAR,P.採購日期, 111) 採購日期
                        ,CONVERT(VARCHAR,P.採購交期, 111) 採購交期
                        ,CASE WHEN ISNULL(S.單位淨重,0) = 0 THEN '' ELSE CONVERT(VARCHAR,S.單位淨重) END 單位淨重
                        ,CASE WHEN ISNULL(S.單位毛重,0) = 0 THEN '' ELSE CONVERT(VARCHAR,S.單位毛重) END 單位毛重
                        ,CASE WHEN ISNULL(S.產品長度,0) = 0 THEN '' ELSE CONVERT(VARCHAR,S.產品長度) END 產品長度
                        ,CASE WHEN ISNULL(S.產品寬度,0) = 0 THEN '' ELSE CONVERT(VARCHAR,S.產品寬度) END 產品寬度
                        ,CASE WHEN ISNULL(S.產品高度,0) = 0 THEN '' ELSE CONVERT(VARCHAR,S.產品高度) END 產品高度
                        ,CASE WHEN P.結案 = 1 THEN '是' ELSE '否' END 結案
                        ,CAST(ISNULL((SELECT TOP 1 1 FROM [192.168.1.135].pic.dbo.xpic X WHERE X.[SUPLU_SEQ] = P.[SUPLU_SEQ]),0) AS BIT) [Has_IMG]
                        FROM pudu P
                        INNER JOIN SUPLU S ON P.頤坊型號=S.頤坊型號 AND P.廠商編號=S.廠商編號 
                        LEFT JOIN RECUA RA ON P.序號 = RA.PUDU_SEQ
                        LEFT JOIN RECU R ON P.序號 = R.PUDU_SEQ
                        WHERE IsNull(P.採購單號,'') <> ''
                        AND 工作類別 <>'詢價' ";

			//共用function 需調整日期名稱,form !=, 簡稱類, 串TABLE 簡稱 
			foreach (string form in context.Request.Form)
			{
				if (!string.IsNullOrEmpty(context.Request[form]) && form != "Call_Type" && form != "WRITE_OFF")
				{
					switch (form)
					{
						case "採購日期_S":
							sqlStr += " AND CONVERT(DATE,[採購日期]) >= @採購日期_S";
                            this.SetParameters(form, context.Request[form]);
							break;
						case "採購日期_E":
							sqlStr += " AND CONVERT(DATE,[採購日期]) <= @採購日期_E";
                            this.SetParameters(form, context.Request[form]);
							break;
						case "廠商簡稱":
							sqlStr += " AND ISNULL(P.[廠商簡稱],'') LIKE '%' + @廠商簡稱 + '%'";
                            this.SetParameters(form, context.Request[form]);
							break;
						default:
							sqlStr += " AND ISNULL(P.[" + form + "],'') LIKE @" + form + " + '%'";
                            this.SetParameters(form, context.Request[form]);
							break;
					}
				}
			}

			sqlStr += @" GROUP BY P.SUPLU_SEQ,P.採購單號,P.廠商簡稱,P.頤坊型號,P.採購數量,P.客戶簡稱,P.暫時型號,P.單位,P.產品說明
                                                     ,P.工作類別,P.樣品號碼
                                                     ,S.設計圖號,P.廠商型號,P.廠商編號,P.客戶編號,S.圖型啟用,P.序號,P.更新人員
                                                     ,P.更新日期,P.到貨處理,P.採購日期,P.採購交期
                                                     , S.單位淨重, S.單位毛重, S.產品長度, S.產品寬度, S.產品高度, P.結案  ";

			//未結案
			if (!string.IsNullOrEmpty(context.Request["WRITE_OFF"]) && context.Request["WRITE_OFF"] == "0")
			{
				sqlStr += " HAVING P.採購數量 > ISNULL(SUM(RA.點收數量),0)";
			}

			sqlStr += " ORDER BY P.採購單號,P.頤坊型號";
            dt = GetDataTableWithLog(sqlStr);
            return dt;
        }

        /// <summary>
        /// 樣品到貨作業 查詢 Return DataTable
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        public DataTable SearchTableForRecu()
        {
            DataTable dt = new DataTable();
            string sqlStr = "";
            sqlStr = @" SELECT Top 500 MAX(ISNULL(RA.點收批號,'')) 點收批號
                                                                   ,P.廠商簡稱
                                                                   ,P.採購單號
                                                                   ,P.頤坊型號
                                                                   ,P.採購數量
                                                                   ,ISNULL(SUM(RA.點收數量),0) 累計點收
                                                                   ,ISNULL(SUM(R.到貨數量),0) 累計到貨
                                                                   ,CASE WHEN ISNULL(P.台幣單價,0) = 0 THEN '' ELSE CONVERT(VARCHAR,P.台幣單價) END 台幣單價
                                                                   ,CASE WHEN ISNULL(P.美元單價,0) = 0 THEN '' ELSE CONVERT(VARCHAR,P.美元單價) END 美元單價
                                                                   ,CASE WHEN ISNULL(P.外幣單價,0) = 0 THEN '' ELSE CONVERT(VARCHAR,P.外幣單價) END 外幣
                                                                   ,ISNULL(P.到貨處理,'') 到貨備註
                                                                   ,CONVERT(VARCHAR,P.採購交期, 111) 採購交期
                                                                   ,P.產品說明
                                                                   ,P.單位
                                                                   ,P.暫時型號
                                                                   ,P.廠商型號
                                                                   ,P.廠商編號
                                                                   ,CONVERT(VARCHAR,P.採購日期, 111) 採購日期
                                                                   ,CONVERT(VARCHAR, MAX(RA.點收日期), 111) 點收日期
                                                                   ,CONVERT(VARCHAR, MAX(R.到貨日期), 111) 到貨日期
                                                                   ,P.工作類別
                                                                   ,CASE WHEN P.結案 = 1 THEN '是' ELSE '否' END 結案
                                                                   ,P.序號
                                                                   ,P.SUPLU_SEQ
                                                                   ,P.更新人員
                                                                   ,CONVERT(VARCHAR,P.更新日期, 111) 更新日期
                                                                   ,CAST(ISNULL((SELECT TOP 1 1 FROM [192.168.1.135].pic.dbo.xpic X WHERE X.[SUPLU_SEQ] = P.[SUPLU_SEQ]),0) AS BIT) [Has_IMG]
                                                     FROM pudu P
                                                     INNER JOIN SUPLU S ON P.頤坊型號=S.頤坊型號 AND P.廠商編號=S.廠商編號 
                                                     LEFT JOIN RECUA RA ON P.序號 = RA.PUDU_SEQ
                                                     LEFT JOIN RECU R ON P.序號 = R.PUDU_SEQ
                                                     WHERE 1=1
                                              ";

            //共用function 需調整日期名稱,form !=, 簡稱類, 串TABLE 簡稱 
            foreach (string form in context.Request.Form)
            {
                if (!string.IsNullOrEmpty(context.Request[form]) && form != "Call_Type" && form != "WRITE_OFF")
                {
                    switch (form)
                    {
                        case "點收日期_S":
                            sqlStr += " AND CONVERT(DATE,[點收日期]) >= @點收日期_S";
                            this.SetParameters(form, context.Request[form]);
                            break;
                        case "點收日期_E":
                            sqlStr += " AND CONVERT(DATE,[點收日期]) <= @點收日期_E";
                            this.SetParameters(form, context.Request[form]);
                            break;
                        case "廠商簡稱":
                            sqlStr += " AND ISNULL(P.[廠商簡稱],'') LIKE '%' + @廠商簡稱 + '%'";
                            this.SetParameters(form, context.Request[form]);
                            break;
                        case "點收批號":
                            sqlStr += " AND ISNULL(RA.[" + form + "],'') LIKE @" + form + " + '%'";
                            this.SetParameters(form, context.Request[form]);
                            break;
                        default:
                            sqlStr += " AND ISNULL(P.[" + form + "],'') LIKE @" + form + " + '%'";
                            this.SetParameters(form, context.Request[form]);
                            break;
                    }
                }
            }

            sqlStr += @" GROUP BY P.廠商簡稱,P.採購單號,P.頤坊型號,P.採購數量
                                                               ,P.台幣單價,P.美元單價,P.外幣單價
                                                               ,P.到貨處理, P.採購交期,P.產品說明
                                                               ,P.單位,P.暫時型號,P.廠商型號,P.廠商編號
                                                               ,P.採購日期,P.工作類別,P.結案,P.序號
                                                               ,S.序號,P.SUPLU_SEQ,P.更新人員,P.更新日期";

            //未結案
            if (!string.IsNullOrEmpty(context.Request["WRITE_OFF"]) && context.Request["WRITE_OFF"] == "0")
            {
                sqlStr += " HAVING (ISNULL(SUM(RA.點收數量),0) > ISNULL(SUM(R.到貨數量),0)) OR (ISNULL(採購數量,0) > ISNULL(SUM(R.到貨數量),0))";
            }

            sqlStr += " ORDER BY P.採購單號,P.頤坊型號";
            dt = GetDataTableWithLog(sqlStr);
            return dt;
        }
    }
}
