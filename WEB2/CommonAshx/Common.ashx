<%@ WebHandler Language = "C#" Class="Common" %>

using System.Collections.Generic;
using System.Web;
using System.Web.SessionState;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;
using System.Web.Script.Serialization;
using Newtonsoft.Json;
using Ivan_Service;

public class Common : IHttpHandler, IRequiresSessionState
{
    public void ProcessRequest(HttpContext context)
    {
        DataTable dt = new DataTable();
        Dal_Refdata dalRefData = new Dal_Refdata(context);

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
                        SqlDataAdapter sqlData = new SqlDataAdapter(cmd);

                        switch (context.Request["Call_Type"])
                        {
                            case "GET_IMG_BY_SUPLU_SEQ":
                                cmd.CommandText = @" SELECT TOP 1 [SUPLU_SEQ], [圖檔] [P_IMG]
                                                     FROM [192.168.1.135].pic.dbo.xpic
                                                     WHERE [SUPLU_SEQ] = @SUPLU_SEQ ";
                                cmd.Parameters.AddWithValue("SUPLU_SEQ", context.Request["SEQ"]);
                                sqlData.Fill(dt);

                                break;
                            case "GET_IMG_BY_BYRLU_SEQ":
                                cmd.CommandText = @" SELECT TOP 1 [SUPLU_SEQ], [圖檔] [P_IMG]
                                                     FROM [192.168.1.135].pic.dbo.xpic
                                                     WHERE [SUPLU_SEQ] = (SELECT TOP 1 SUPLU_SEQ FROM byrlu where 序號 = @BYRLU_SEQ) ";
                                cmd.Parameters.AddWithValue("BYRLU_SEQ", context.Request["SEQ"]);
                                sqlData.Fill(dt);

                                break;
                            case "GET_DATA_FROM_REFDATA":
                                 dt = dalRefData.SearchTable();
                                break;
                        }

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



