using System.Collections.Generic;
using System.Data;
using System.Web;

namespace Ivan_Dal
{
    public class Dal_Recu : Dal_Base
    {
        /// <summary>
        /// 樣品到貨作業 查詢 Return DataTable
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        public IDalBase SearchTable(Dictionary<string, string> dic)
        {
            string sqlStr = "";
            sqlStr = @" SELECT TOP 500 R.[序號]
                                      ,P.[採購單號]
                                      ,P.[樣品號碼]
                                      ,P.[SUPLU_SEQ]
                                      ,P.[廠商編號]
                                      ,P.[廠商簡稱]
                                      ,P.[頤坊型號]
                                      ,P.[暫時型號]
                                      ,P.[廠商型號]
                                      ,P.[產品說明]
                                      ,P.[單位]
                                      ,CONVERT(VARCHAR,R.[出貨日期],23) [出貨日期]
                                      ,CONVERT(VARCHAR,R.[到貨日期],23) [到貨日期]
                                      ,CONVERT(VARCHAR,R.[到單日期],23) [到單日期]
                                      ,IIF(R.[到貨數量] = 0, NULL, R.[到貨數量]) 到貨數量
                                      ,R.[到貨單號]
                                      ,IIF(P.[台幣單價] = 0, NULL, P.[台幣單價]) 台幣單價
                                      ,IIF(P.[美元單價] = 0, NULL, P.[美元單價]) 美元單價
                                      ,P.[外幣幣別]
                                      ,IIF(P.[外幣單價] = 0, NULL, P.[外幣單價]) 外幣單價
                                      ,IIF(R.[不付款] = 1, '是', '否') 不付款
                                      ,IIF(R.[發票異常] = 1, '是', '否') 發票異常
                                      ,ISNULL(R.[發票樣式],'') 發票樣式
                                      ,ISNULL(R.[發票號碼],'') 發票號碼
                                      ,R.[到貨備註]
                                      ,IIF(R.[調整額01] = 0, NULL, R.[調整額01]) 調整額01
                                      ,IIF(R.[調整額02] = 0, NULL, R.[調整額02]) 調整額02
                                      ,R.[更新人員]
                                      ,CONVERT(VARCHAR,R.[更新日期],23) [更新日期]
                                      ,CAST(ISNULL((SELECT TOP 1 1 FROM [192.168.1.135].pic.dbo.xpic X WHERE X.[SUPLU_SEQ] = P.[SUPLU_SEQ]),0) AS BIT) [Has_IMG]
                          FROM Dc2..pudu P
                          INNER JOIN RECU R ON P.序號 = R.PUDU_SEQ
                          WHERE 1=1 ";

            //共用function 需調整日期名稱,form !=, 簡稱類, 串TABLE 簡稱 
            foreach (string form in dic.Keys)
            {
                if (!string.IsNullOrEmpty(dic[form]) && form != "Account")
                {
                    string debug = dic[form];
                    switch (form)
                    {
                        case "到貨日期_S":
                            sqlStr += " AND CONVERT(DATE,[到貨日期]) >= @到貨日期_S";
                            this.SetParameters(form, dic[form]);
                            break;
                        case "到貨日期_E":
                            sqlStr += " AND CONVERT(DATE,[到貨日期]) <= @到貨日期_E";
                            this.SetParameters(form, dic[form]);
                            break;
                        case "廠商簡稱":
                            sqlStr += " AND ISNULL(R.[廠商簡稱],'') LIKE '%' + @廠商簡稱 + '%'";
                            this.SetParameters(form, dic[form]);
                            break;
                        default:
                            sqlStr += " AND ISNULL(R.[" + form + "],'') LIKE @" + form + " + '%'";
                            this.SetParameters(form, dic[form]);
                            break;
                    }
                }
            }
            this.SetSqlText(sqlStr);
            return this;
        }

        /// <summary>
        /// 寫入到貨 TABLE 
        /// </summary>
        /// <returns></returns>
        public IDalBase InsertRecu(Dictionary<string, string> dic, int cnt)
        {
            CleanParameters();
            string[] seqArray = dic["SEQ[]"].Split(',');
            string[] invErrArray = dic["INVOICE_ERR[]"].Split(',');
            string[] shipRemarkArray = dic["SHIP_ARR_REMARK[]"].Split(',');
            string[] shipArrCnt = dic["ARR_CNT[]"].Split(',');
            string sqlStr = @" INSERT INTO [dbo].[recu]
                                        ([序號]
                                        ,[PUDU_SEQ]
                                        ,[點收批號]
                                        ,[採購單號]
                                        ,[樣品號碼]
                                        ,[廠商編號]
                                        ,[廠商簡稱]
                                        ,[頤坊型號]
                                        ,[暫時型號]
                                        ,[廠商型號]
                                        ,[單位]
                                        ,[出貨日期]
                                        ,[到貨日期]
                                        ,[到貨單號]
                                        ,[到貨數量]
                                        ,[到單日期]
                                        ,[運送方式]
                                        ,[不付款]
                                        ,[發票樣式]
                                        ,[發票號碼]
                                        ,[發票異常]
                                        ,[歸屬年]
                                        ,[歸屬月]
                                        ,[到貨備註]
                                        ,[部門]
                                        ,[變更日期]
                                        ,[更新人員]
                                        ,[更新日期])
                                    SELECT TOP 1 (Select IsNull(Max(序號),0)+1 From Recu) [序號]
                                        ,P.[序號] [PUDU_SEQ]
                                        ,RA.點收批號
                                        ,P.[採購單號]
                                        ,P.[樣品號碼]
                                        ,P.[廠商編號]
                                        ,P.[廠商簡稱]
                                        ,P.[頤坊型號]
                                        ,P.[暫時型號]
                                        ,P.[廠商型號]
                                        ,P.[單位]
                                        ,@SHIP_GO_DATE [出貨日期]
                                        ,@SHIP_ARR_DATE [到貨日期]
                                        ,@SHIP_ARR_NO [到貨單號]
                                        ,@SHIP_ARR_CNT [到貨數量]
                                        ,@ORDER_ARR_DATE [到單日期]
                                        ,null [運送方式]
                                        ,@NO_PAY [不付款]
                                        ,@INVOICE_TYPE [發票樣式]
                                        ,@INVOICE_NO [發票號碼]
                                        ,@INVOICE_ERR [發票異常]
                                        ,NULL [歸屬年]
                                        ,NULL [歸屬月]
                                        ,@SHIP_ARR_REMARK [到貨備註]
                                        ,NULL [部門]
                                        ,NULL [變更日期]
                                        ,@UPD_USER [更新人員]
                                        ,GETDATE() [更新日期]
	                                FROM pudu P
                                    LEFT JOIN RECUA RA ON P.序號 = RA.PUDU_SEQ
	                                WHERE P.序號 = @SEQ
                                    
                                    --後續抽離!!
                                    UPDATE pudu
                                    SET 結案 = 1
                                    FROM pudu P
                                    WHERE P.序號 IN (SELECT pudu.序號 
                                                     FROM pudu 
                                                     JOIN recu R on pudu.序號 = R.PUDU_SEQ
                                                     WHERE pudu.序號 = @SEQ
                                                     GROUP BY pudu.序號, pudu.工作類別, pudu.採購數量, pudu.台幣單價, pudu.美元單價, pudu.外幣單價, pudu.結案
                                                     HAVING CASE WHEN pudu.工作類別 LIKE '%詢%' THEN ISNULL(台幣單價,0) + ISNULL(美元單價,0) + ISNULL(外幣單價,0)
                                                                 ELSE 1 END <> 0
                                                     AND SUM(ISNULL(R.到貨數量,0)) >= pudu.採購數量
                                                     AND ISNULL(pudu.結案,0) != 1  )

                                                        ";

            this.SetParameters("SEQ", seqArray[cnt]);
            this.SetParameters("SHIP_GO_DATE", dic["SHIP_GO_DATE"]);
            this.SetParameters("SHIP_ARR_DATE", dic["SHIP_ARR_DATE"]);
            this.SetParameters("SHIP_ARR_NO", dic["SHIP_ARR_NO"]);
            this.SetParameters("ORDER_ARR_DATE", dic["ORDER_ARR_DATE"]);
            this.SetParameters("NO_PAY", dic["NO_PAY"]);
            this.SetParameters("INVOICE_TYPE", dic["INVOICE_TYPE"]);
            this.SetParameters("INVOICE_NO", dic["INVOICE_NO"]);
            this.SetParameters("INVOICE_ERR", invErrArray[cnt]);
            this.SetParameters("SHIP_ARR_REMARK", shipRemarkArray[cnt]);
            this.SetParameters("SHIP_ARR_CNT", shipArrCnt[cnt]);
            this.SetParameters("UPD_USER", dic["Account"]);

            if (dic["FORCE_CLOSE"] == "true")
            {
                sqlStr += @"UPDATE PUDU
                            SET 強制結案 = 1, 結案 = 1
                            WHERE 序號 = @SEQ";
            }

            this.SetSqlText(sqlStr);
            return this;
        }

        /// <summary>
		/// UPDATE RECU 單筆 
		/// </summary>
		/// <param name="context"></param>
		/// <returns></returns>
		public IDalBase UpdateRecu(Dictionary<string, string> dic)
        {
            CleanParameters();
            string sql = "";
            string sqlStr = "";
            sqlStr = @" UPDATE [dbo].[RECU]
                        SET [更新人員] = @UPD_USER
                            ,[更新日期] = GETDATE()
                            {0}
                        WHERE [序號] = @SEQ ";

            this.SetParameters("UPD_USER", "IVAN");
            this.SetParameters("SEQ", dic["SEQ"]);

            //共用function 需調整日期名稱,form !=, 簡稱類, 串TABLE 簡稱 
            foreach (string form in dic.Keys)
            {
                if (form != "Account" && form != "SEQ")
                {
                    string debug = dic[form];
                    switch (form)
                    {
                        default:
                            sql += " ," + form + " = @" + form;
                            this.SetParameters(form, dic[form]);
                            break;
                    }
                }
            }

            sqlStr = string.Format(sqlStr, sql);
            this.SetSqlText(sqlStr);
            return this;
        }

        /// <summary>
        /// 刪除RECU 單筆
        /// </summary>
        /// <returns></returns>
        public IDalBase DeleteRecu(Dictionary<string, string> dic)
        {
            CleanParameters();
            string sqlStr = @"      DELETE FROM RECU
                                    WHERE [序號] = @SEQ
                                     ";

            this.SetParameters("SEQ", dic["SEQ"]);
            this.SetParameters("UPD_USER", dic["Account"]);
            this.SetSqlText(sqlStr);
            return this;
        }

        /// <summary>
		/// 樣品出貨 報表
		/// </summary>
		/// <param name="context"></param>
		/// <returns></returns>
		public IDalBase SampleShippingReport(Dictionary<string, string> dic)
        {
            string sqlStr = "";
            sqlStr = @" SELECT P.廠商簡稱
                              ,R.出貨日期
                              ,R.發票號碼
                              ,R.到貨備註
                              ,SUM(ROUND(台幣單價*到貨數量,0)+IsNull(調整額01,0) + IsNull(調整額02,0)) AS 金額
                              ,SUM(IsNull(調整額01,0)) 調整額01
                              ,SUM(IsNull(調整額02,0)) 調整額02
                              ,CASE WHEN R.發票樣式 IN ('08','09') THEN 0 
                                      ELSE ROUND(SUM(ROUND(台幣單價*到貨數量,0)+IsNull(調整額01,0) + IsNull(調整額02,0)) * 0.05,0) END 稅額
                              ,SUM(ROUND(台幣單價*到貨數量,0)+IsNull(調整額01,0) + IsNull(調整額02,0)) + CASE WHEN R.發票樣式 IN ('08','09') THEN 0 
                                                                                                              ELSE ROUND(SUM(ROUND(台幣單價*到貨數量,0)+IsNull(調整額01,0) + IsNull(調整額02,0)) * 0.05,0) END 總額
                              ,'出貨日期 : ' + @出貨日期_S + @出貨日期_E 印表條件
                              ,IIF(ISNULL(發票異常,0) = '1', '*', '') 列印發票異常
                              ,P.廠商編號 群組一
                          FROM PUDU P 
                          INNER JOIN RECU R ON P.序號=R.PUDU_SEQ 
                          WHERE IsNull(台幣單價,0) > 0   ";

            foreach (string form in dic.Keys)
            {
                if (!string.IsNullOrEmpty(dic[form]) && form != "Account" && form != "RPT_TYPE")
                {
                    string debug = dic[form];
                    switch (form)
                    {
                        case "出貨日期_S":
                            sqlStr += " AND CONVERT(DATE,[出貨日期]) >= @出貨日期_S";
                            this.SetParameters(form, dic[form]);
                            break;
                        case "出貨日期_E":
                            sqlStr += " AND CONVERT(DATE,[出貨日期]) <= @出貨日期_E";
                            this.SetParameters(form, dic[form]);
                            break;
                        default:
                            sqlStr += " AND ISNULL(R.[" + form + "],'') LIKE @" + form + " + '%'";
                            this.SetParameters(form, dic[form]);
                            break;
                    }
                }
            }

            sqlStr += " GROUP BY P.廠商簡稱,R.出貨日期,R.發票號碼,R.到貨備註, R.發票樣式, 發票異常, P.廠商編號";
            this.SetSqlText(sqlStr);
            return this;
        }
    }
}
