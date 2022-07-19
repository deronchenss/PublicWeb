<%@ WebHandler Language = "C#" Class="Sample_Chk_Dist" %>

using System.Collections.Generic;
using System.Web;
using System.Web.SessionState;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;
using System.Web.Script.Serialization;
using Newtonsoft.Json;
using System.Collections.Specialized;
using Ivan_Log;
using Ivan_Service;

public class Sample_Chk_Dist : IHttpHandler, IRequiresSessionState
{
    public void ProcessRequest(HttpContext context)
    {
        Dal_Sample_Chk_Dist dal = new Dal_Sample_Chk_Dist();
        DataTable dt = new DataTable();
        int result = 0;
        if (!string.IsNullOrEmpty(context.Request["Call_Type"]))
        {
            try
            {
                switch (context.Request["Call_Type"])
                {
                    case "SEARCH":
                        dt = dal.SearchTable(context);
                        break;
                    case "INSERT_PAKU2":
                        result = dal.InsertPaku2(context);

                        Log.InsertLog(context, context.Session["Account"], dal.sqlStr);
                        context.Response.StatusCode = 200;
                        context.Response.Write(result);
                        context.Response.End();
                        break;
                    case "INSERT_STKIOH":
                        result = dal.InsertPaku2(context);

                        Log.InsertLog(context, context.Session["Account"], dal.sqlStr);
                        context.Response.StatusCode = 200;
                        context.Response.Write(result);
                        context.Response.End();
                        break;
                    case "INSERT_STKIO":
                        result = dal.InsertPaku2(context);

                        Log.InsertLog(context, context.Session["Account"], dal.sqlStr);
                        context.Response.StatusCode = 200;
                        context.Response.Write(result);
                        context.Response.End();
                        break;
                }

                Log.InsertLog(context, context.Session["Account"], dal.sqlStr);
                var json = JsonConvert.SerializeObject(dt);
                context.Response.StatusCode = 200;
                context.Response.ContentType = "text/json";
                context.Response.Write(json);
            }
            catch (SqlException ex)
            {
                Log.InsertLog(context, context.Session["Account"], dal.sqlStr, "", false);
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



