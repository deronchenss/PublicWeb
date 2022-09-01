<%@ WebHandler Language="C#" Class="Cost_MMT" %>

using System.Collections.Generic;
using System.Web;
using System.Web.SessionState;
using System.Data.SqlClient;
using System.Web.Configuration;
using System.Data;
using System.Configuration;
using System.Web.Script.Serialization;
using System.Text;
using System.IO;
using System.Web.UI.WebControls;
using Newtonsoft.Json;
using Ivan_Service.FN.Base;
using Ivan_Service;
using Ivan_Log;

public class Cost_MMT : IHttpHandler, IRequiresSessionState
{
    public void ProcessRequest(HttpContext context)
    {
        if (!string.IsNullOrEmpty(context.Request["Call_Type"]))
        {
            DataTable dt = new DataTable();
            var Cost = new Cost();
            try
            {
                switch (context.Request["Call_Type"])
                {
                    case "Cost_MMT_Search":
                        dt = Cost.Cost_MMT_Search(JsonConvert.DeserializeObject<DataTable>(context.Request["Search_Data"]));
                        Log.InsertLog(context, context.Session["Name"], Cost._sqlLogModel);
                        break;
                    case "Cost_MMT_Update":
                        //DataTable Request_DT = JsonConvert.DeserializeObject<DataTable>(context.Request["Exec_Data"]);
                        Cost.Cost_MMT_Update(JsonConvert.DeserializeObject<DataTable>(context.Request["Exec_Data"]));
                        Log.InsertLog(context, context.Session["Name"], Cost._sqlLogModel);

                        context.Response.StatusCode = 200;
                        context.Response.End();
                        break;
                }
                var json = JsonConvert.SerializeObject(dt);
                context.Response.ContentType = "text/json";
                context.Response.Write(json);
            }
            catch (SqlException ex)
            {
                Log.InsertLog(context, context.Session["Name"], Cost._sqlLogModel, ex.ToString(), false);
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
