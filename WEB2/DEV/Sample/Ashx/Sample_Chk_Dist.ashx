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
        Dal_Suplu dalSuplu = new Dal_Suplu(context);
        Dal_Paku2 dalPaku2 = new Dal_Paku2(context);
        DataTable dt = new DataTable();
        int result = 0;
        if (!string.IsNullOrEmpty(context.Request["Call_Type"]))
        {
            try
            {
                switch (context.Request["Call_Type"])
                {
                    case "SEARCH":
                        dt = dalSuplu.SearchTableForSample();
                        break;
                    case "INSERT_PAKU2":
                        result = dalPaku2.InsertPaku2();

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



