<%@ WebHandler Language="C#" Class="Stock_IO_MT" %>

using System.Collections.Generic;
using System.Web;
using System.Web.SessionState;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;
using System.Web.Script.Serialization;
using Newtonsoft.Json;
using Ivan_Service;
using Ivan_Log;
using Ivan_Models;

public class Stock_IO_MT : IHttpHandler, IRequiresSessionState
{
    public void ProcessRequest(HttpContext context)
    {
        StockService service = new StockService();
        string result = "";
        if (!string.IsNullOrEmpty(context.Request["Call_Type"]))
        {
            try
            {
                switch (context.Request["Call_Type"])
                {
                    case "SEARCH":
                        result = JsonConvert.SerializeObject(service.StockIOMTSearch(ContextFN.ContextToDictionary(context)));
                        break;
                    case "INSERT":
                        Stkio entity = JsonConvert.DeserializeObject<Stkio>(context.Request["EXEC_DATA"]);
                        result = service.StockIOMTInsert(entity);
                        break;
                    case "UPDATE":
                        result = service.StockIOMTUpdate(ContextFN.ContextToDictionary(context));
                        break;
                    case "DELETE":
                        result = service.StockIOMTDelete(ContextFN.ContextToDictionary(context));
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



