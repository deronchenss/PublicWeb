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
                                                                   ,P.[廠商編號]
                                                                   ,P.[廠商簡稱]
                                                                   ,P.[頤坊型號]
                                                                   ,P.[暫時型號]
                                                                   ,P.[廠商型號]
                                                                   ,P.[產品說明]
                                                                   ,R.[單位]
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

                            case "GET_IMG":
                                cmd.CommandText = @" SELECT TOP 1 [COST_SEQ], [圖檔] [P_IMG]
                                                     FROM [192.168.1.135].pic.dbo.xpic
                                                     WHERE [COST_SEQ] = (SELECT TOP 1 COST_SEQ FROM byrlu where 廠商編號 = @FACT_NO AND 頤坊型號 = @IVAN_TYPE) ";
                                cmd.Parameters.AddWithValue("FACT_NO", context.Request["FACT_NO"]);
                                cmd.Parameters.AddWithValue("IVAN_TYPE", context.Request["IVAN_TYPE"]);
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



