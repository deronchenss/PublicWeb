<%@ WebHandler Language = "C#" Class="Sample_Chk_Dist" %>

using System.Collections.Generic;
using System.Web;
using System.Web.SessionState;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;
using System.Web.Script.Serialization;
using Ivan_Log;
using Newtonsoft.Json;
using Ivan_Service;

public class Sample_Chk_Dist : IHttpHandler, IRequiresSessionState
{
    public void ProcessRequest(HttpContext context)
    {
        Dal_Sample_Chk_Dist dal = new Dal_Sample_Chk_Dist();
        DataTable dt = new DataTable();

        if (!string.IsNullOrEmpty(context.Request["Call_Type"]))
        {
            try
            {
                switch (context.Request["Call_Type"])
                {
                    case "SEARCH":
                        dt = dal.SearchTable(context);
                        Log.InsertLog(context, context.Session["Account"], dal.sqlStr);
                        break;
                    case "INSERT_RECU":

                        context.Response.StatusCode = 200;
                        context.Response.Write(0);
                        context.Response.End();
                        break;
                }

                var json = JsonConvert.SerializeObject(dt);
                context.Response.ContentType = "text/json";
                context.Response.Write(json);
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



