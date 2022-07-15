<%@ WebHandler Language = "C#" Class="Sample_Chk_MT" %>

using System.Collections.Generic;
using System.Web;
using System.Web.SessionState;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;
using System.Web.Script.Serialization;
using Newtonsoft.Json;
using CrystalDecisions.CrystalReports.Engine;

public class Sample_Chk_MT : IHttpHandler, IRequiresSessionState
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
                            case "Search_Recua":
                                cmd.CommandText = @" SELECT TOP 500 RA.[序號]
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
                                                                   ,RA.[點收批號]
                                                                   ,IIF(RA.[點收數量] = 0, NULL, RA.[點收數量]) 點收數量
                                                                   ,IIF(RA.[核銷數量] = 0, NULL, RA.[核銷數量]) 核銷數量
                                                                   ,CONVERT(VARCHAR,RA.[點收日期],23) [點收日期]
                                                                   ,RA.[運輸編號]
                                                                   ,RA.[運輸簡稱]
                                                                   ,RA.[更新人員]
                                                                   ,CONVERT(VARCHAR,RA.[更新日期],23) [更新日期]
                                                     FROM Dc2..pudu P
                                                     INNER JOIN RECUA RA ON P.序號 = RA.PUDU_SEQ
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
                                            case "點收日期_S":
                                                cmd.CommandText += " AND CONVERT(DATE,[點收日期]) >= @點收日期_S";
                                                cmd.Parameters.AddWithValue(form, context.Request[form]);
                                                break;
                                            case "點收日期_E":
                                                cmd.CommandText += " AND CONVERT(DATE,[點收日期]) <= @點收日期_E";
                                                cmd.Parameters.AddWithValue(form, context.Request[form]);
                                                break;
                                            case "廠商簡稱":
                                                cmd.CommandText += " AND ISNULL(RA.[廠商簡稱],'') LIKE '%' + @廠商簡稱 + '%'";
                                                cmd.Parameters.AddWithValue(form, context.Request[form]);
                                                break;
                                            default:
                                                cmd.CommandText += " AND ISNULL(RA.[" + form + "],'') LIKE @" + form + " + '%'";
                                                cmd.Parameters.AddWithValue(form, context.Request[form]);
                                                break;
                                        }
                                    }
                                }

                                break;
                            case "UPD_RECUA":
                                string sql = "";

                                cmd.Parameters.Clear();
                                cmd.CommandText = @" UPDATE [dbo].[RECUA]
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

                            case "DELETE_RECUA":
                                cmd.Parameters.Clear();
                                cmd.CommandText = @" DELETE FROM RECUA 
                                                     WHERE [序號] = @SEQ ";

                                cmd.Parameters.AddWithValue("SEQ", context.Request["SEQ"]);
                                res = cmd.ExecuteNonQuery();
                                context.Response.StatusCode = res == 1 ? 200 : 404;
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



