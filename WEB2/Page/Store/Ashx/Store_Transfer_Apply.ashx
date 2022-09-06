<%@ WebHandler Language="C#" Class="Store_Transfer_Apply" %>

using System.Collections.Generic;
using System.Web;
using System.Web.SessionState;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;
using System.Web.Script.Serialization;
using Newtonsoft.Json;
using Ivan_Service;
using Ivan_Models;
using Ivan_Log;

public class Store_Transfer_Apply : IHttpHandler, IRequiresSessionState
{
    public void ProcessRequest(HttpContext context)
    {
        StoreService service = new StoreService();
        string result = "";
        if (!string.IsNullOrEmpty(context.Request["Call_Type"]))
        {
            try
            {
                switch (context.Request["Call_Type"])
                {
                    case "SEARCH":
                        result = JsonConvert.SerializeObject(service.StoreTransferSearch(ContextFN.ContextToDictionary(context)));
                        break;
                    case "EXEC":
                        List<StkioFromSuplu> liStkio = JsonConvert.DeserializeObject<List<StkioFromSuplu>>(context.Request["EXEC_DATA"]);
                        result = service.StoreTransferExec(liStkio);
                        break;
                    case "CANCEL":
                        List<Stkio> liEntity = JsonConvert.DeserializeObject<List<Stkio>>(context.Request["EXEC_DATA"]);
                        result = service.StoreTransferCancel(liEntity);
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

