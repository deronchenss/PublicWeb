<%@ WebHandler Language="C#" Class="BOM_MMT" %>

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
using Ivan_Service;
using Demo;


public class BOM_MMT : IHttpHandler, IRequiresSessionState
{
    public void ProcessRequest(HttpContext context)
    {
        if (!string.IsNullOrEmpty(context.Request["Call_Type"]))
        {
            DataTable dt = new DataTable();
            try
            {
                var BMD = new BOM_MMT_Data(context);
                switch (context.Request["Call_Type"])
                {
                    case "BOM_MMT_Search":
                        dt = BMD.BOM_MMT_Search();
                        break;
                    case "BOM_MMT_Update":
                        BMD.BOM_MMT_Update();
                        context.Response.StatusCode = 200;
                        //context.Response.Write(result);
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
