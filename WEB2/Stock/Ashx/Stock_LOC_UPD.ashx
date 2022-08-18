<%@ WebHandler Language="C#" Class="Stock_LOC_UPD" %>

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

public class Stock_LOC_UPD : IHttpHandler, IRequiresSessionState
{
    public void ProcessRequest(HttpContext context)
    {
        DataTable dt = new DataTable();
        Dal_Suplu dalSup = new Dal_Suplu(context);
        Dal_Stkio dalStk = new Dal_Stkio(context);

        int result = 0;
        if (!string.IsNullOrEmpty(context.Request["Call_Type"]))
        {
            try
            {
                switch (context.Request["Call_Type"])
                {
                    case "SEARCH":
                        dt = dalSup.SearchTableForUpdLoc();
                        break;
                    case "EXEC":
                        result = dalSup.UpdateSuplu();
                        context.Response.StatusCode = 200;
                        context.Response.Write(result);
                        context.Response.End();
                        break;
                }

                var json = JsonConvert.SerializeObject(dt);
                context.Response.StatusCode = 200;
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



