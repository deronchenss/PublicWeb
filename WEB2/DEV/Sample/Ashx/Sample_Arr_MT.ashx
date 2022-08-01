<%@ WebHandler Language = "C#" Class="Sample_Arr_MT" %>

using System.Collections.Generic;
using System.Web;
using System.Web.SessionState;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;
using System.Web.Script.Serialization;
using Newtonsoft.Json;
using CrystalDecisions.CrystalReports.Engine;


public class Sample_Arr_MT : IHttpHandler, IRequiresSessionState
{
    public void ProcessRequest(HttpContext context)
    {
        DataTable dt = new DataTable();

        if (!string.IsNullOrEmpty(context.Request["Call_Type"]))
        {
            try
            {
                List<object> quote = new List<object>();
                int res = 0;

                using (SqlCommand cmd = new SqlCommand())
                {
                    using (SqlConnection conn = new SqlConnection())
                    {
                        conn.ConnectionString = ConfigurationManager.ConnectionStrings["LocalBC2"].ConnectionString;
                        cmd.Connection = conn;
                        conn.Open();

                        switch (context.Request["Call_Type"])
                        {
                            case "Search_Recu":
                                cmd.CommandText = @" SELECT TOP 500 R.[序號]
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
                                            case "到貨日期_S":
                                                cmd.CommandText += " AND CONVERT(DATE,[到貨日期]) >= @到貨日期_S";
                                                cmd.Parameters.AddWithValue(form, context.Request[form]);
                                                break;
                                            case "到貨日期_E":
                                                cmd.CommandText += " AND CONVERT(DATE,[到貨日期]) <= @到貨日期_E";
                                                cmd.Parameters.AddWithValue(form, context.Request[form]);
                                                break;
                                            case "廠商簡稱":
                                                cmd.CommandText += " AND ISNULL(R.[廠商簡稱],'') LIKE '%' + @廠商簡稱 + '%'";
                                                cmd.Parameters.AddWithValue(form, context.Request[form]);
                                                break;
                                            default:
                                                cmd.CommandText += " AND ISNULL(R.[" + form + "],'') LIKE @" + form + " + '%'";
                                                cmd.Parameters.AddWithValue(form, context.Request[form]);
                                                break;
                                        }
                                    }
                                }

                                break;
                            case "UPD_RECU":
                                string sql = "";

                                cmd.Parameters.Clear();
                                cmd.CommandText = @" UPDATE [dbo].[RECU]
                                                        SET [更新人員] = @UPD_USER
                                                           ,[更新日期] = GETDATE()
                                                           {0}
                                                      WHERE [序號] = @SEQ ";

                                cmd.Parameters.AddWithValue("UPD_USER", "IVAN");
                                cmd.Parameters.AddWithValue("SEQ", context.Request["SEQ"]);

                                //共用function 需調整日期名稱,form !=, 簡稱類, 串TABLE 簡稱 
                                foreach (string form in context.Request.Form)
                                {
                                    if (form != "Call_Type" && form != "SEQ")
                                    {
                                        string debug = context.Request[form];
                                        switch (form)
                                        {
                                            default:
                                                sql += " ," + form + " = @" + form ;
                                                cmd.Parameters.AddWithValue(form, context.Request[form]);
                                                break;
                                        }
                                    }
                                }

                                cmd.CommandText = string.Format(cmd.CommandText, sql);

                                res = cmd.ExecuteNonQuery();
                                context.Response.StatusCode = res == 1 ? 200 : 404;
                                context.Response.End();
                                break;

                            case "DELETE_RECU":
                                cmd.Parameters.Clear();
                                cmd.CommandText = @" DELETE FROM RECU
                                                     WHERE [序號] = @SEQ ";

                                cmd.Parameters.AddWithValue("SEQ", context.Request["SEQ"]);
                                res = cmd.ExecuteNonQuery();
                                context.Response.StatusCode = res == 1 ? 200 : 404;
                                context.Response.End();
                                break;

                            case "PRINT_RPT":
                                string rptDir = "~/DEV/Sample/Rpt/Invoice_Tot_Amt.rpt";

                                switch (context.Request["RPT_TYPE"])
                                {
                                    case "0":
                                        rptDir = "~/DEV/Sample/Rpt/Invoice_Tot_Amt.rpt";
                                        break;
                                }

                                cmd.CommandText = @" SELECT P.廠商簡稱
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

                                foreach (string form in context.Request.Form)
                                {
                                    if (!string.IsNullOrEmpty(context.Request[form]) && form != "Call_Type" && form != "RPT_TYPE")
                                    {
                                        string debug = context.Request[form];
                                        switch (form)
                                        {
                                            case "出貨日期_S":
                                                cmd.CommandText += " AND CONVERT(DATE,[出貨日期]) >= @出貨日期_S";
                                                cmd.Parameters.AddWithValue(form, context.Request[form]);
                                                break;
                                            case "出貨日期_E":
                                                cmd.CommandText += " AND CONVERT(DATE,[出貨日期]) <= @出貨日期_E";
                                                cmd.Parameters.AddWithValue(form, context.Request[form]);
                                                break;
                                            default:
                                                cmd.CommandText += " AND ISNULL(R.[" + form + "],'') LIKE @" + form + " + '%'";
                                                cmd.Parameters.AddWithValue(form, context.Request[form]);
                                                break;
                                        }
                                    }
                                }

                                cmd.CommandText += " GROUP BY P.廠商簡稱,R.出貨日期,R.發票號碼,R.到貨備註, R.發票樣式, 發票異常, P.廠商編號";

                                SqlDataAdapter sqlDatai = new SqlDataAdapter(cmd);
                                sqlDatai.Fill(dt);

                                if (dt != null && dt.Rows.Count > 0)
                                {
                                    ReportDocument rptDoc = new ReportDocument();
                                    rptDoc.Load(context.Server.MapPath(rptDir));
                                    rptDoc.SetDataSource(dt);
                                    System.IO.Stream stream = rptDoc.ExportToStream(CrystalDecisions.Shared.ExportFormatType.PortableDocFormat);
                                    byte[] bytes = new byte[stream.Length];
                                    stream.Read(bytes, 0, bytes.Length);
                                    stream.Seek(0, System.IO.SeekOrigin.Begin);

                                    string filename = "樣品出貨.pdf";
                                    context.Response.ClearContent();
                                    context.Response.ClearHeaders();
                                    context.Response.AddHeader("content-disposition", "attachment;filename=" + filename);
                                    context.Response.ContentType = "application/pdf";
                                    context.Response.OutputStream.Write(bytes, 0, bytes.Length);
                                    context.Response.Flush();
                                    context.Response.End();
                                }
                                else
                                {
                                    context.Response.StatusCode = 204;
                                    context.Response.End();
                                }
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



