<%@ WebHandler Language = "C#" Class="Sample_Pack" %>

using System.Collections.Generic;
using System.Web;
using System.Web.SessionState;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;
using System.Web.Script.Serialization;
using Newtonsoft.Json;
using CrystalDecisions.CrystalReports.Engine;
using Ivan_Service;
using Ivan_Log;

public class Sample_Pack : IHttpHandler, IRequiresSessionState
{
    public void ProcessRequest(HttpContext context)
    {
        DataTable dt = new DataTable();
        Dal_Sample_Pack dal = new Dal_Sample_Pack();
        
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
                    case "INSERT":
                        result = dal.InsertPaku(context);

                        Log.InsertLog(context, context.Session["Account"], dal.sqlStr);
                        context.Response.StatusCode = 200;
                        context.Response.Write(result);
                        context.Response.End();
                        break;
                    case "DELETE":
                        result = dal.DeletePaku2(context);

                        Log.InsertLog(context, context.Session["Account"], dal.sqlStr);
                        context.Response.StatusCode = 200;
                        context.Response.Write(result);
                        context.Response.End();
                        break;
                    case "ChkIV":
                        dt = dal.SearchIV(context);
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
                Log.InsertLog(context, context.Session["Account"], dal.sqlStr, ex.ToString(), false);
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



