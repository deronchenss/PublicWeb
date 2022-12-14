<%@ WebHandler Language="C#" Class="Sample_Pack_MT" %>

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

public class Sample_Pack_MT : IHttpHandler, IRequiresSessionState
{
    public void ProcessRequest(HttpContext context)
    {
        SampleService service = new SampleService();
        string result = "";
        if (!string.IsNullOrEmpty(context.Request["Call_Type"]))
        {
            try
            {
                switch (context.Request["Call_Type"])
                {
                    case "Search":
                        result = JsonConvert.SerializeObject(service.SamplePackMTSearch(ContextFN.ContextToDictionary(context)));
                        break;
                    case "UPDATE":
                        result = service.SamplePackMTUpdate(ContextFN.ContextToDictionary(context));
                        break;
                    case "DELETE":
                        result = service.SamplePackMTDelete(ContextFN.ContextToDictionary(context));
                        break;
                }

                Log.InsertLog(context, context.Session["Account"], service.sqlLogModel);
                context.Response.StatusCode = 200;
                context.Response.ContentType = "text/json";
                context.Response.Write(result);
            }
            catch (SqlException ex)
            {
                Log.InsertLog(context, context.Session["Account"], service.sqlLogModel, ex.ToString(), false);
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



