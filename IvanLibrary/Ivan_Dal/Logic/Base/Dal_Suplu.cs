using Ivan_Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web;

namespace Ivan_Dal
{
    public class Dal_Suplu : Dal_Base 
    {
        /// <summary>
        /// 庫存查詢 查詢 Return DataTable
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        public IDalBase SearchTable(Dictionary<string, string> dic)
        {
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
                        ),
                        DIS
                        AS
                        (
	                        SELECT SUM(IIF(出庫數 > 0,ISNULL(出庫數,0) - ISNULL(核銷數,0),0)) 分配庫存數
		                          ,SUPLU_SEQ
	                        FROM Stkio A 
	                        WHERE ISNULL(A.已刪除,0) = 0
	                        AND ISNULL(A.已結案,0) = 0
	                        GROUP BY SUPLU_SEQ
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
			                           ,IIF(DIS.分配庫存數 = 0, NULL, DIS.分配庫存數) 分配庫存數
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
			                           ,S.英文ISP
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
                                       ,CASE WHEN ISNULL(S.大貨安全數,0) > 0 AND ISNULL(S.大貨庫存數,0) + ISNULL(DIS.分配庫存數,0) + ISNULL(P.庫存在途數, 0) < ISNULL(S.大貨安全數,0) THEN 'Y' ELSE 'N' END 安全數不足
                        FROM suplu S
                        LEFT JOIN S1 ON S.頤坊型號 = S1.頤坊型號 AND S.產品二階 = S1.產品二階
                        LEFT JOIN PUD_CNT P ON S.序號 = P.SUPLU_SEQ
                        LEFT JOIN DIS ON S.序號 = DIS.SUPLU_SEQ
                        WHERE 1=1 
                         ";

            //共用function 需調整日期名稱,form !=, 簡稱類, 串TABLE 簡稱 
            foreach (string form in dic.Keys)
            {
                if (!string.IsNullOrEmpty(dic[form]) && form != "Account")
                {
                    string debug = dic[form];
                    switch (form)
                    {
                        case "產品說明":
                        case "廠商簡稱":
                            sqlStr += " AND ISNULL(S.[" + form + "],'') LIKE '%' + @" + form + " + '%' ";
                            this.SetParameters(form, dic[form]);
                            break;
                        case "倉位":
                            if(dic[form].Equals("ISP"))
                            {
                                sqlStr += " AND ISNULL(S.[" + dic[form] + "安全數],0) != 0 ";
                            }
                            else
                            {
                                sqlStr += " AND ISNULL(S.[" + dic[form] + "庫存數],0) != 0 ";
                            }
                            break;
                        case "限門市":
                            if(dic[form] == "1")
                            {
                                sqlStr += " AND ISNULL(S.台北安全數,0) + ISNULL(S.台中安全數,0) + ISNULL(S.高雄安全數,0) <> 0 ";
                            }
                            break;
                        case "售完":
                            if (dic[form] == "1")
                            {
                                sqlStr += " AND ISNULL(S.ISP安全數,0)=1 AND ISNULL(S.ISP庫存數,0)=0 ";
                            }
                            break;
                        case "草稿":
                            if (dic[form] == "1")
                            {
                                sqlStr += " AND ISNULL(S.ISP安全數,0)=2 ";
                            }
                            break;
                        case "封存":
                            if (dic[form] == "1")
                            {
                                sqlStr += " AND ISNULL(S.ISP安全數,0)=3 ";
                            }
                            break;
                        case "替代庫存":
                            if (dic[form] == "1")
                            {
                                sqlStr += " AND IIF(ISNULL(總庫存,0) - 大貨庫存數 = 0, NULL, ISNULL(總庫存,0) - 大貨庫存數) > 0 ";
                            }
                            break;
                        case "庫位":
                            sqlStr += " AND ISNULL(S.[" + dic["倉位"] + "庫位],'') LIKE '%' + @" + form + " + '%' ";
                            this.SetParameters(form, dic[form]);
                            break;
                        default:
                            sqlStr += " AND ISNULL(S.[" + form + "],'') LIKE @" + form + " + '%'";
                            this.SetParameters(form, dic[form]);
                            break;
                    }
                }
            }

            sqlStr += " ORDER BY S.頤坊型號, S.廠商編號 ";
            this.SetSqlText(sqlStr);
            return this;
        }

        /// <summary>
        /// 替代庫存出庫 查詢 Return DataTable
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        public IDalBase SearchTableForReplace(Dictionary<string, string> dic)
        {
            string sqlStr = "";
            sqlStr = @" ;WITH S1 
                        AS
                        (
	                        SELECT 頤坊型號,產品二階, SUM(大貨庫存數) 總庫存
	                        FROM suplu S1 
	                        GROUP BY 頤坊型號,產品二階
                        ) 
                        ,DIS
                        AS
                        (
	                        SELECT SUM(IIF(出庫數 > 0,ISNULL(出庫數,0) - ISNULL(核銷數,0),0)) 分配庫存數
		                          ,SUPLU_SEQ
	                        FROM Stkio A 
	                        WHERE ISNULL(A.已刪除,0) = 0
	                        AND ISNULL(A.已結案,0) = 0
	                        GROUP BY SUPLU_SEQ
                        )
                        SELECT  Top 500 S.廠商簡稱
			                           ,S.頤坊型號
			                           ,S.銷售型號
                                       ,S.產品狀態
			                           ,S.單位
			                           ,IIF(S.大貨庫存數 = 0, NULL, S.大貨庫存數) 大貨庫存數
			                           ,IIF(ISNULL(總庫存,0) - 大貨庫存數 = 0, NULL, ISNULL(總庫存,0) - 大貨庫存數)  替代庫存數
                                       ,S.大貨庫位 大貨庫位
                                       ,IIF(DIS.分配庫存數 = 0, NULL, DIS.分配庫存數) 分配庫存數
			                           ,S.產品說明
			                           ,S.廠商型號
			                           ,S.暫時型號
			                           ,S.廠商編號
			                           ,S.序號
			                           ,S.更新人員
			                           ,CONVERT(VARCHAR,S.更新日期,23) 更新日期 
                                       ,CASE WHEN (SELECT TOP 1 1 FROM [192.168.1.135].pic.dbo.xpic X WHERE X.[SUPLU_SEQ] = S.序號) = 1 THEN 'Y' ELSE 'N' END [Has_IMG]
                        FROM suplu S
                        LEFT JOIN S1 ON S.頤坊型號 = S1.頤坊型號 AND S.產品二階 = S1.產品二階
                        LEFT JOIN DIS ON S.序號 = DIS.SUPLU_SEQ
                        WHERE 1=1 
                         ";

            //共用function 需調整日期名稱,form !=, 簡稱類, 串TABLE 簡稱 
            foreach (string form in dic.Keys)
            {
                if (!string.IsNullOrEmpty(dic[form]) && form != "Account")
                {
                    string debug = dic[form];
                    switch (form)
                    {
                        default:
                            sqlStr += " AND ISNULL(S.[" + form + "],'') LIKE @" + form + " + '%'";
                            this.SetParameters(form, dic[form]);
                            break;
                    }
                }
            }
            
            
            sqlStr += " ORDER BY S.頤坊型號, S.廠商編號 ";
            this.SetSqlText(sqlStr);
            return this;
        }

        /// <summary>
        /// 庫位變更 查詢 Return DataTable
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        public IDalBase SearchTableForUpdLoc(Dictionary<string, string> dic)
        {
            string sqlStr = "";
            sqlStr = @" ;WITH DIS
                        AS
                        (
	                        SELECT SUM(IIF(出庫數 > 0,ISNULL(出庫數,0) - ISNULL(核銷數,0),0)) 分配庫存數
		                          ,SUPLU_SEQ
	                        FROM Stkio A 
	                        WHERE ISNULL(A.已刪除,0) = 0
	                        AND ISNULL(A.已結案,0) = 0
	                        GROUP BY SUPLU_SEQ
                        )
                        SELECT  Top 500 S.廠商簡稱
			                           ,S.頤坊型號
			                           ,S.銷售型號
                                       ,S.產品狀態
			                           ,S.單位
			                           ,IIF(S.{庫區}庫存數 = 0, NULL, S.{庫區}庫存數) {庫區}庫存數
                                       ,S.{庫區}庫位 {庫區}庫位
                                       ,IIF(DIS.分配庫存數 = 0, NULL, DIS.分配庫存數) 分配庫存數
			                           ,S.產品說明
			                           ,S.廠商型號
			                           ,S.暫時型號
			                           ,S.廠商編號
			                           ,S.序號
			                           ,S.更新人員
			                           ,CONVERT(VARCHAR,S.更新日期,23) 更新日期 
                                       ,CASE WHEN (SELECT TOP 1 1 FROM [192.168.1.135].pic.dbo.xpic X WHERE X.[SUPLU_SEQ] = S.序號) = 1 THEN 'Y' ELSE 'N' END [Has_IMG]
                        FROM suplu S
                        LEFT JOIN DIS ON S.序號 = DIS.SUPLU_SEQ
                        WHERE 1=1 
                         ";

            //共用function 需調整日期名稱,form !=, 簡稱類, 串TABLE 簡稱 
            foreach (string form in dic.Keys)
            {
                if (!string.IsNullOrEmpty(dic[form]) && form != "Account")
                {
                    string debug = dic[form];
                    switch (form)
                    {
                        case "廠商簡稱":
                            sqlStr += " AND ISNULL(S.[" + form + "],'') LIKE '%' + @" + form + " + '%' ";
                            this.SetParameters(form, dic[form]);
                            break;
                        case "庫位":
                            sqlStr += $" AND S.{dic["庫區"]}庫位 LIKE '%' + @" + form + " + '%' ";
                            this.SetParameters(form, dic[form]);
                            break;
                        case "庫區":
                            sqlStr = sqlStr.Replace("{庫區}", dic[form]);
                            break;
                        case "限有庫存":
                            if("1".Equals(dic[form]))
                            {
                                sqlStr += $" AND ISNULL(S.{dic["庫區"]}庫存數, 0) > 0 ";
                            }
                            break;
                        default:
                            sqlStr += " AND ISNULL(S.[" + form + "],'') LIKE @" + form + " + '%'";
                            this.SetParameters(form, dic[form]);
                            break;
                    }
                }
            }


            sqlStr += " ORDER BY S.頤坊型號, S.廠商編號 ";
            this.SetSqlText(sqlStr);
            return this;
        }

        /// <summary>
        /// 庫存入出多筆新增 查詢 Return DataTable
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        public IDalBase SearchTableForMutiInsert(Dictionary<string, string> dic)
        {
            string sqlStr = "";
            sqlStr = @" SELECT  Top 500 S.廠商簡稱
			                           ,S.頤坊型號
			                           ,S.銷售型號
                                       ,S.產品狀態
			                           ,IIF(S.{庫區}庫存數 = 0, NULL, S.{庫區}庫存數) {庫區}庫存數
                                       ,0 出入庫數
			                           ,S.{庫區}庫位
                                       ,S.{庫區}庫位 本次庫位
			                           ,S.單位
			                           ,S.產品說明
			                           ,S.英文ISP
			                           ,S.大貨庫更
			                           ,S.廠商型號
			                           ,S.暫時型號
			                           ,S.頤坊條碼
			                           ,S.備註給倉庫
			                           ,S.產品二階
			                           ,S.廠商編號
			                           ,CONVERT(VARCHAR,S.停用日期,23) 停用日期
			                           ,S.序號
                                       ,'{庫區}' 庫區
			                           ,S.更新人員
			                           ,CONVERT(VARCHAR,S.更新日期,23) 更新日期 
                                       ,CASE WHEN (SELECT TOP 1 1 FROM [192.168.1.135].pic.dbo.xpic X WHERE X.[SUPLU_SEQ] = S.序號) = 1 THEN 'Y' ELSE 'N' END [Has_IMG]
                        FROM suplu S
                        WHERE 1=1 
                         ";

            //共用function 需調整日期名稱,form !=, 簡稱類, 串TABLE 簡稱 
            foreach (string form in dic.Keys)
            {
                if (!string.IsNullOrEmpty(dic[form]) && form != "Account")
                {
                    string debug = dic[form];
                    switch (form)
                    {
                        case "產品說明":
                        case "廠商簡稱":
                            sqlStr += " AND ISNULL(S.[" + form + "],'') LIKE '%' + @" + form + " + '%' ";
                            this.SetParameters(form, dic[form]);
                            break;
                        case "庫區":
                            sqlStr += " AND ISNULL(S.{庫區}庫存數,0) <> 0";
                            sqlStr = sqlStr.Replace("{庫區}", dic[form]);
                            this.SetParameters(form, dic[form]);
                            break;
                        case "庫位":
                            sqlStr += " AND ISNULL(S.[" + dic["倉位"] + "庫位],'') LIKE '%' + @" + form + " + '%' ";
                            this.SetParameters(form, dic[form]);
                            break;
                        default:
                            sqlStr += " AND ISNULL(S.[" + form + "],'') LIKE @" + form + " + '%'";
                            this.SetParameters(form, dic[form]);
                            break;
                    }
                }
            }

            sqlStr += " ORDER BY S.頤坊型號, S.廠商編號 ";
            this.SetSqlText(sqlStr);
            return this;
        }

        /// <summary>
        /// 樣品準備作業 查詢 Return DataTable
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        public IDalBase SearchTableForSample(Dictionary<string, string> dic)
        {
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

            foreach (string form in dic.Keys)
            {
                if (!string.IsNullOrEmpty(dic[form]) && form != "Account" && form != "DATA_SOURCE")
                {
                    string debug = dic[form];
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
            foreach (string form in dic.Keys)
            {
                if (!string.IsNullOrEmpty(dic[form]) && form != "Account" && form != "DATA_SOURCE")
                {
                    string debug = dic[form];
                    switch (form)
                    {
                        case "點收日期_S":
                            sqlStr += " AND CONVERT(DATE,R.[點收日期]) >= @點收日期_S";
                            this.SetParameters(form, dic[form]);
                            break;
                        case "點收日期_E":
                            sqlStr += " AND CONVERT(DATE,R.[點收日期]) <= @點收日期_E";
                            this.SetParameters(form, dic[form]);
                            break;
                        case "採購單號":
                        case "點收批號":
                            sqlStr += " AND ISNULL(R.[" + form + "],'') LIKE @" + form + " + '%'";
                            this.SetParameters(form, dic[form]);
                            break;
                        case "訂單號碼":
                            sqlStr += " AND ISNULL(ST.[" + form + "],'') LIKE @" + form + " + '%'";
                            this.SetParameters(form, dic[form]);
                            break;
                        case "廠商簡稱":
                            sqlStr += " AND ISNULL(A.[廠商簡稱],'') LIKE '%' + @廠商簡稱 + '%'";
                            this.SetParameters(form, dic[form]);
                            break;
                        default:
                            sqlStr += " AND ISNULL(A.[" + form + "],'') LIKE @" + form + " + '%'";
                            this.SetParameters(form, dic[form]);
                            break;
                    }
                }
            }

            this.SetSqlText(sqlStr);
            return this;
        }

        /// <summary>
        /// 門市庫取申請 查詢 Return DataTable
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        public IDalBase SearchTableForStore(Dictionary<string, string> dic)
        {
            string sqlStr = "";
            sqlStr = @" ;WITH STK 
                        AS
                        (
	                        SELECT SUM(CASE WHEN A.訂單號碼 Like 'WR1-%' AND A.庫區 = '台北' THEN 入庫數 ELSE 0 END) 台北待入
		                          ,MAX(DATEDIFF(DAY,CASE WHEN A.訂單號碼 Like 'WR1-%' AND A.庫區 = '台北' THEN 更新日期 ELSE NULL END,GETDATE())) 台北逾期
		                          ,SUM(CASE WHEN A.訂單號碼 Like 'WR2-%' AND A.庫區 = '台中' THEN 入庫數 ELSE 0 END) 台中待入
		                          ,MAX(DATEDIFF(DAY,CASE WHEN A.訂單號碼 Like 'WR2-%' AND A.庫區 = '台中' THEN 更新日期 ELSE NULL END,GETDATE())) 台中逾期
		                          ,SUM(CASE WHEN A.訂單號碼 Like 'WR3-%' AND A.庫區 = '高雄' THEN 入庫數 ELSE 0 END) 高雄待入
		                          ,MAX(DATEDIFF(DAY,CASE WHEN A.訂單號碼 Like 'WR3-%' AND A.庫區 = '高雄' THEN 更新日期 ELSE NULL END,GETDATE())) 高雄逾期
		                          ,SUM(IIF(出庫數 > 0,ISNULL(出庫數,0) - ISNULL(核銷數,0),0)) 分配
		                          ,SUPLU_SEQ
	                        FROM Stkio A 
	                        WHERE ISNULL(A.已刪除,0) = 0
	                        AND ISNULL(A.已結案,0) = 0
	                        GROUP BY SUPLU_SEQ
                        )
                        , TOT
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
			                           ,IIF(S.{庫區}庫存數 = 0, NULL, S.{庫區}庫存數) AS {庫區}庫存數
			                           ,IIF(ISNULL(總庫存,0) - 大貨庫存數 = 0, NULL, ISNULL(總庫存,0) - 大貨庫存數) AS 替代庫存
                                       ,CASE WHEN '{庫區}' = '大貨' AND 大貨庫存數 - ISNULL(STK.分配,0) >= {門市}安全數 - {門市}庫存數 - ISNULL({門市}待入,0) THEN {門市}安全數 - {門市}庫存數 - ISNULL({門市}待入,0) 
                                             WHEN '{庫區}' = '大貨' AND 大貨庫存數 - ISNULL(STK.分配,0) < {門市}安全數 - {門市}庫存數 - ISNULL({門市}待入,0) AND 大貨庫存數 > ISNULL(STK.分配,0) THEN 大貨庫存數 - ISNULL(STK.分配,0)
                                             WHEN '{庫區}' = '內湖' AND 內湖庫存數 >= {門市}安全數 - {門市}庫存數 - ISNULL({門市}待入,0) THEN {門市}安全數 - {門市}庫存數 - ISNULL({門市}待入,0) 
                                             WHEN '{庫區}' = '內湖' AND 內湖庫存數 < {門市}安全數 - {門市}庫存數 - ISNULL({門市}待入,0) AND 內湖庫存數 > 0 THEN 內湖庫存數
                                             ELSE 0 END AS 預定庫取數量
			                           ,IIF(STK.分配 = 0, NULL, STK.分配) AS 分配
			                           ,IIF(S.台北安全數 = 0, NULL, S.台北安全數) AS 北安
			                           ,IIF(S.台北庫存數 = 0, NULL, S.台北庫存數) AS 北庫
			                           ,IIF(STK.台北待入 = 0, NULL, STK.台北待入) 北待
			                           ,IIF(STK.台北逾期 = 0, NULL, STK.台北逾期) 北逾
			                           ,IIF(S.台中安全數 = 0, NULL, S.台中安全數) AS 中安
			                           ,IIF(S.台中庫存數 = 0, NULL, S.台中庫存數) AS 中庫
			                           ,IIF(STK.台中待入 = 0, NULL, STK.台中待入) 中待
			                           ,IIF(STK.台中逾期 = 0, NULL, STK.台中逾期) 中逾
			                           ,IIF(S.高雄安全數 = 0, NULL, S.高雄安全數) AS 高安
			                           ,IIF(S.高雄庫存數 = 0, NULL, S.高雄庫存數) AS 高庫
			                           ,IIF(STK.高雄待入 = 0, NULL, STK.高雄待入) 高待
			                           ,IIF(STK.高雄逾期 = 0, NULL, STK.高雄逾期) 高逾
                                       ,'' 備註
			                           ,CASE WHEN ISNULL(B.台幣單價_1,0)=0 THEN '???' ELSE '' END AS 單價
			                           ,CASE WHEN ISNULL(S.寄送袋子,'')='' THEN '???' ELSE S.寄送袋子 END AS 袋子
			                           ,CASE WHEN ISNULL(S.產地,'')='' THEN '???' ELSE S.產地 END AS 產地
			                           ,RTRIM(S.簡短說明) As 簡短說明
			                           ,S.大貨庫位 AS 庫位
			                           ,S.產品一階
			                           ,B.產品分類
			                           ,S.廠商編號
			                           ,S.開發中
			                           ,CONVERT(VARCHAR,S.停用日期,23) 停用日期
			                           ,S.序號
			                           ,S.更新人員
			                           ,CONVERT(VARCHAR,S.更新日期,23) 更新日期
                                       ,CASE WHEN (SELECT TOP 1 1 FROM [192.168.1.135].pic.dbo.xpic X WHERE X.[SUPLU_SEQ] = S.序號) = 1 THEN 'Y' ELSE 'N' END [Has_IMG]
                                       ,'{門市}' 門市
                                       ,'{庫區}' 庫區
                        FROM SUPLU S 
                        LEFT JOIN STK ON S.序號 = STK.SUPLU_SEQ 
                        INNER JOIN TOT ON S.頤坊型號 = TOT.頤坊型號 AND S.產品二階 = TOT.產品二階
                        INNER JOIN BYRLU_RT B ON S.序號 = B.SUPLU_SEQ
                        WHERE B.停用日期 IS NULL  
                         ";

            //共用function 需調整日期名稱,form !=, 簡稱類, 串TABLE 簡稱 
            foreach (string form in dic.Keys)
            {
                if (!string.IsNullOrEmpty(dic[form]) && form != "Account")
                {
                    switch (form)
                    {
                        case "庫存足夠":
                            sqlStr += "內湖".Equals(dic["門市"]) ? " AND ISNULL(S.內湖庫存數,0) > 0 " : $" AND ISNULL(S.大貨庫存數,0) > IsNull(STK.分配,0)";
                            break;
                        case "庫待不足":
                            sqlStr += $" AND ISNULL({dic["門市"]}庫存數,0) + ISNULL({dic["門市"]}待入,0) < ISNULL({dic["門市"]}安全數,0) ";
                            break;
                        case "庫存狀態":
                            switch (dic[form])
                            {
                                case "50":
                                    sqlStr += $" AND ISNULL(S.{dic["門市"]}安全數,0) * 0.5 > ISNULL(S.{dic["門市"]}庫存數,0) ";
                                    break;
                                case "20":
                                    sqlStr += $" AND ISNULL(S.{dic["門市"]}安全數,0) * 0.2 > ISNULL(S.{dic["門市"]}庫存數,0) ";
                                    break;
                                case "建議採購":
                                    sqlStr += $" AND ISNULL(S.{dic["門市"]}安全數,0) > ISNULL(S.{dic["門市"]}庫存數,0) ";
                                    break;
                                default:
                                    sqlStr += $" AND ISNULL(S.{dic["門市"]}庫存數,0) > 0 ";
                                    break;
                            }
                            break;
                        case "廠商簡稱":
                            sqlStr += " AND ISNULL(S.[廠商簡稱],'') LIKE '%' + @廠商簡稱 + '%'";
                            this.SetParameters(form, dic[form]);
                            break;
                        case "安全數":
                            sqlStr += $" AND ISNULL(S.{dic["門市"]}安全數,0) > 1 ";
                            this.SetParameters(form, dic[form]);
                            break;
                        case "袋子吊卡":
                            sqlStr += " AND (ISNULL(S.寄送袋子,'') != '' OR ISNULL(S.寄送吊卡,'') !='' OR ISNULL(S.自備袋子,0) != '' OR IsNull(S.自備吊卡,0) != '' ) ";
                            break;
                        case "門市":
                            sqlStr = sqlStr.Replace("{門市}", dic["門市"]);
                            break;
                        case "庫區":
                            sqlStr = sqlStr.Replace("{庫區}", dic["庫區"]);
                            break;
                        case "產品分類":
                            sqlStr += " AND ISNULL(B.[" + form + "],'') LIKE @" + form + " + '%'";
                            this.SetParameters(form, dic[form]);
                            break;
                        default:
                            sqlStr += " AND ISNULL(S.[" + form + "],'') LIKE @" + form + " + '%'";
                            this.SetParameters(form, dic[form]);
                            break;
                    }
                }
            }

            sqlStr += " ORDER BY S.頤坊型號, S.廠商編號 ";
            this.SetSqlText(sqlStr);
            return this;
        }

        #region 更新區域
        /// <summary>
        /// UPDATE Suplu 多筆SEQ 同樣變數
        /// </summary>
        /// <returns></returns>
        public IDalBase UpdateSuplu(Dictionary<string, string> dic, int cnt)
        {
            CleanParameters();
            string sqlStr = @"      UPDATE [dbo].[suplu]
                                       SET 更新日期 = GETDATE()
                                    ";


            string[] seqArray = dic["SEQ[]"].Split(',');
            foreach (string form in dic.Keys)
            {
                if (!string.IsNullOrEmpty(dic[form]) && form != "Account" && form != "SEQ" && !form.Contains("[]"))
                {
                    switch (form)
                    {
                        default:
                            this.SetParameters(form, dic[form]);
                            sqlStr += " ," + form + " = @" + form;
                            break;
                    }
                }
            }
            sqlStr += " WHERE [序號] = @SEQ ";
            this.SetParameters("SEQ", seqArray[cnt]);
            this.SetSqlText(sqlStr);
            return this;
        }

        /// <summary>
        /// UPDATE Suplu From Stkio Seq
        /// </summary>
        /// <returns></returns>
        public IDalBase UpdateSupluFromStkio(Stkio stkio, object quickTakeCnt)
        {
            CleanParameters();
            string sqlStr = @"      UPDATE SUPLU
                                    SET {庫區}庫存數 = ISNULL({庫區}庫存數,0) + (CASE WHEN ST.出庫數 > 0 THEN -1 ELSE 1 END * @核銷數)
									   ,{庫區}庫位 = ST.庫位
                                       ,快取庫存數 = ISNULL(快取庫存數,0) - @快取庫存數 
									   ,更新日期 = GETDATE()
                                       ,更新人員 = @更新人員
                                    FROM SUPLU S
                                    JOIN stkio ST ON S.序號 = ST.SUPLU_SEQ
                                    WHERE ST.序號 = @序號
                                    ";

            //需要自己擴充 沒有 DEFAULT
            sqlStr = sqlStr.Replace("{庫區}", stkio.庫區);
            this.SetParameters("快取庫存數", quickTakeCnt);
            this.SetParameters("更新人員", stkio.更新人員);
            this.SetParameters("序號", stkio.序號);
            this.SetParameters("核銷數", stkio.核銷數); //出庫數用減的

            this.SetSqlText(sqlStr);
            return this;
        }

        #endregion

    }
}
