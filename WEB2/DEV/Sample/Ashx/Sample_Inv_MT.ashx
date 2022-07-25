<%@ WebHandler Language="C#" Class="Sample_Inv_MT" %>

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

public class Sample_Inv_MT : IHttpHandler, IRequiresSessionState
{
    public void ProcessRequest(HttpContext context)
    {
        DataTable dt = new DataTable();
        Dal_Sample_Inv_MT dal = new Dal_Sample_Inv_MT();

        int result = 0;
        if (!string.IsNullOrEmpty(context.Request["Call_Type"]))
        {
            try
            {
                switch (context.Request["Call_Type"])
                {
                    case "Search":
                        dt = dal.SearchTable(context);
                        break;
                    case "INSERT":
                        string invoiceNo = dal.InsertInvu(context);

                        Log.InsertLog(context, context.Session["Account"], dal.sqlStr);
                        context.Response.StatusCode = 200;
                        context.Response.Write(invoiceNo);
                        context.Response.End();
                        break;
                    case "UPD":
                        result = dal.UpdateInvu(context);

                        Log.InsertLog(context, context.Session["Account"], dal.sqlStr);
                        context.Response.StatusCode = 200;
                        context.Response.Write(result);
                        context.Response.End();
                        break;
                    case "PRINT_RPT":
                        string rptDir = "~/DEV/Sample/Rpt/Sample_Invoice.rpt";

                        if (context.Request["RPT_TYPE"] == "0")
                        {
                            dt = dal.SampleIVReport(context);
                        }

                        if (dt != null && dt.Rows.Count > 0)
                        {
                            ReportDocument rptDoc = new ReportDocument();
                            rptDoc.Load(context.Server.MapPath(rptDir));
                            rptDoc.SetDataSource(dt);
                            System.IO.Stream stream = rptDoc.ExportToStream(CrystalDecisions.Shared.ExportFormatType.PortableDocFormat);
                            byte[] bytes = new byte[stream.Length];
                            stream.Read(bytes, 0, bytes.Length);
                            stream.Seek(0, System.IO.SeekOrigin.Begin);

                            string filename = "Invoice.pdf";
                            context.Response.ClearContent();
                            context.Response.ClearHeaders();
                            context.Response.AddHeader("content-disposition", "attachment;filename=" + filename);
                            context.Response.ContentType = "application/pdf";
                            context.Response.OutputStream.Write(bytes, 0, bytes.Length);
                            context.Response.Flush();
                            context.Response.End();
                        }
                        else
                        {
                            context.Response.StatusCode = 204;
                            context.Response.End();
                        }
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



