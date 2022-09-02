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
        SampleService service = new SampleService();
        string result = "";
        if (!string.IsNullOrEmpty(context.Request["Call_Type"]))
        {
            try
            {
                switch (context.Request["Call_Type"])
                {
                    case "Search":
                        result = JsonConvert.SerializeObject(service.SampleInvMTSearch(ContextFN.ContextToDictionary(context)));
                        break;
                    case "INSERT":
                        result = JsonConvert.SerializeObject(service.SampleInvMTInsert(ContextFN.ContextToDictionary(context)));
                        break;
                    case "UPD":
                        result = service.SampleInvMTUpdate(ContextFN.ContextToDictionary(context));
                        break;
                    case "PRINT_RPT":
                        string rptDir = "~/DEV/Sample/Rpt/Sample_Invoice.rpt";
                        DataTable dt = new DataTable();
                        switch(context.Request["RPT_TYPE"])
                        {
                            case "0":
                                rptDir = "~/Page/DEV/Sample/Rpt/Sample_Invoice.rpt";
                                dt = service.SampleInvMTReportIV(ContextFN.ContextToDictionary(context));
                                break;
                            case "1":
                                rptDir = "~/Page/DEV/Sample/Rpt/Sample_IV_Packing.rpt";
                                dt = service.SampleInvMTReportPacking(ContextFN.ContextToDictionary(context));
                                break;
                        }

                        //型別不同自行處理
                        Log.InsertLog(context, context.Session["Account"], service.sqlLogModel);
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



