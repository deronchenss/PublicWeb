<%@ WebHandler Language="C#" Class="Replace_Stock_O" %>

using System.Collections.Generic;
using System.Web;
using System.Web.SessionState;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;
using System.Web.Script.Serialization;
using Newtonsoft.Json;
using Ivan_Service;
using Ivan.Models;
using Ivan_Log;

public class Replace_Stock_O : IHttpHandler, IRequiresSessionState
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
                        result = JsonConvert.SerializeObject(service.ReplaceStockOSearch(ContextFN.ContextToDictionary(context)));
                        break;
                    case "EXEC":
                        List<StkioFromSuplu> entity = JsonConvert.DeserializeObject<List<StkioFromSuplu>>(context.Request["EXEC_DATA"]);
                        result = service.ReplaceStockOExec(entity, context.Session["Account"]);
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



