<%@ WebHandler Language = "C#" Class="Sample_Arr" %>

using System.Collections.Generic;
using System.Web;
using System.Web.SessionState;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;
using System.Web.Script.Serialization;
using Newtonsoft.Json;
using CrystalDecisions.CrystalReports.Engine;

public class Sample_Arr : IHttpHandler, IRequiresSessionState
{
    public void ProcessRequest(HttpContext context)
    {
        DataTable dt = new DataTable();

        if (!string.IsNullOrEmpty(context.Request["Call_Type"]))
        {
            try
            {
                List<object> quote = new List<object>();

                using (SqlCommand cmd = new SqlCommand())
                {
                    using (SqlConnection conn = new SqlConnection())
                    {
                        conn.ConnectionString = ConfigurationManager.ConnectionStrings["LocalBC2"].ConnectionString;
                        cmd.Connection = conn;
                        conn.Open();                  

                        switch (context.Request["Call_Type"])
                        {
                            case "SEARCH_PUDU":
                                cmd.CommandText = @" SELECT Top 500 MAX(ISNULL(RA.點收批號,'')) 點收批號
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
                                    if(!string.IsNullOrEmpty(context.Request[form]) && form != "Call_Type" && form != "WRITE_OFF")
                                    {
                                        switch (form)
                                        {
                                            case "點收日期_S":
                                                cmd.CommandText += " AND CONVERT(DATE,[點收日期]) >= @點收日期_S";
                                                cmd.Parameters.AddWithValue(form, context.Request[form]);
                                                break;
                                            case "點收日期_E":
                                                cmd.CommandText += " AND CONVERT(DATE,[點收日期]) <= @點收日期_E";
                                                cmd.Parameters.AddWithValue(form, context.Request[form]);
                                                break;
                                            case "廠商簡稱":
                                                cmd.CommandText += " AND ISNULL(P.[廠商簡稱],'') LIKE '%' + @廠商簡稱 + '%'";
                                                cmd.Parameters.AddWithValue(form, context.Request[form]);
                                                break;
                                            case "點收批號":
                                                cmd.CommandText += " AND ISNULL(RA.[" + form + "],'') LIKE @" + form + " + '%'";
                                                cmd.Parameters.AddWithValue(form, context.Request[form]);
                                                break;
                                            default:
                                                cmd.CommandText += " AND ISNULL(P.[" + form + "],'') LIKE @" + form + " + '%'";
                                                cmd.Parameters.AddWithValue(form, context.Request[form]);
                                                break;
                                        }
                                    }
                                }

                                cmd.CommandText += @" GROUP BY P.廠商簡稱,P.採購單號,P.頤坊型號,P.採購數量
                                                               ,P.台幣單價,P.美元單價,P.外幣單價
                                                               ,P.到貨處理, P.採購交期,P.產品說明
                                                               ,P.單位,P.暫時型號,P.廠商型號,P.廠商編號
                                                               ,P.採購日期,P.工作類別,P.結案,P.序號
                                                               ,S.序號,P.SUPLU_SEQ,P.更新人員,P.更新日期";

                                //未結案
                                if (!string.IsNullOrEmpty(context.Request["WRITE_OFF"]) && context.Request["WRITE_OFF"] == "0")
                                {
                                    cmd.CommandText += " HAVING (ISNULL(SUM(RA.點收數量),0) > ISNULL(SUM(R.到貨數量),0)) OR (ISNULL(採購數量,0) > ISNULL(SUM(R.到貨數量),0))";
                                }

                                cmd.CommandText += " ORDER BY P.採購單號,P.頤坊型號";
                                break;
                            case "INSERT_RECU":
                                string[] seqArray = context.Request["SEQ[]"].Split(',');
                                string[] invErrArray = context.Request["INVOICE_ERR[]"].Split(',');
                                string[] shipRemarkArray = context.Request["SHIP_ARR_REMARK[]"].Split(',');
                                string[] shipArrCnt = context.Request["ARR_CNT[]"].Split(',');

                                for (int cnt = 0; cnt < seqArray.Length; cnt++)
                                {
                                    cmd.CommandText = @" INSERT INTO [dbo].[recu]
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
                                                          
                                                        ";
                                    cmd.Parameters.Clear();
                                    cmd.Parameters.AddWithValue("SEQ", seqArray[cnt]);
                                    cmd.Parameters.AddWithValue("SHIP_GO_DATE", context.Request["SHIP_GO_DATE"]);
                                    cmd.Parameters.AddWithValue("SHIP_ARR_DATE", context.Request["SHIP_ARR_DATE"]);
                                    cmd.Parameters.AddWithValue("SHIP_ARR_NO", context.Request["SHIP_ARR_NO"]);
                                    cmd.Parameters.AddWithValue("ORDER_ARR_DATE", context.Request["ORDER_ARR_DATE"]);
                                    cmd.Parameters.AddWithValue("NO_PAY", context.Request["NO_PAY"]);
                                    cmd.Parameters.AddWithValue("INVOICE_TYPE", context.Request["INVOICE_TYPE"]);
                                    cmd.Parameters.AddWithValue("INVOICE_NO", context.Request["INVOICE_NO"]);
                                    cmd.Parameters.AddWithValue("INVOICE_ERR", invErrArray[cnt]);
                                    cmd.Parameters.AddWithValue("SHIP_ARR_REMARK", shipRemarkArray[cnt]);
                                    cmd.Parameters.AddWithValue("SHIP_ARR_CNT", shipArrCnt[cnt]);
                                    cmd.Parameters.AddWithValue("UPD_USER", "IVAN10");

                                    if (context.Request["FORCE_CLOSE"] == "true")
                                    {
                                        cmd.CommandText += @"UPDATE PUDU
                                                             SET 強制結案 = 1, 結案 = 1
                                                             WHERE 序號 = @SEQ";
                                    }

                                    cmd.ExecuteNonQuery();
                                }

                                //根據寫入到貨數量 一次更新結案狀態
                                cmd.CommandText = @"UPDATE pudu
                                                    SET 結案 = 1
                                                    FROM pudu P
                                                    WHERE P.序號 IN (SELECT pudu.序號 
                                                                     FROM pudu 
                                                                     JOIN recu R on pudu.序號 = R.PUDU_SEQ
                                                                     GROUP BY pudu.序號, pudu.工作類別, pudu.採購數量, pudu.台幣單價, pudu.美元單價, pudu.外幣單價, pudu.結案
                                                                     HAVING CASE WHEN pudu.工作類別 LIKE '%詢%' THEN ISNULL(台幣單價,0) + ISNULL(美元單價,0) + ISNULL(外幣單價,0)
                                                                                 ELSE 1 END <> 0
                                                                     AND SUM(ISNULL(R.到貨數量,0)) >= pudu.採購數量
                                                                     AND ISNULL(pudu.結案,0) != 1    )";
                                cmd.ExecuteNonQuery();

                                context.Response.StatusCode = 200;
                                context.Response.Write(seqArray.Length);
                                context.Response.End();
                                break;
                        }

                        SqlDataAdapter sqlData = new SqlDataAdapter(cmd);
                        sqlData.Fill(dt);

                        var json = JsonConvert.SerializeObject(dt);
                        context.Response.ContentType = "text/json";
                        context.Response.Write(json);
                    }
                }
            }
            catch (SqlException ex)
            {
                context.Response.StatusCode = 404;
                context.Response.Write(ex.Message);
            }
        }

    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
}



