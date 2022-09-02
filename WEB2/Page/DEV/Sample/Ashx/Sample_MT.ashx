<%@ WebHandler Language = "C#" Class="Sample_MT" %>

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

public class Sample_MT : IHttpHandler, IRequiresSessionState
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
                    case "Sample_Base":
                        result = JsonConvert.SerializeObject(service.SampleMTSearch(ContextFN.ContextToDictionary(context)));
                        break;
                    case "UPD_SAMPLE":
                        result = service.SampleMTUpdate(ContextFN.ContextToDictionary(context));
                        break;
                    case "INSERT_SAMPLE":
                        result = service.SampleMTInsert(ContextFN.ContextToDictionary(context));
                        break;
                    case "SEQ_PURC_SEQ":
                        result = service.SampleMTUpdateSeq(ContextFN.ContextToDictionary(context));
                        break;
                    case "UPD_RPT_REMARK":
                        result = service.SampleMTUpdateRptRemark(ContextFN.ContextToDictionary(context));
                        break;
                    case "UPD_WRITEOFF":
                        result = service.SampleMTUpdateWriteOff(ContextFN.ContextToDictionary(context));
                        break;
                    case "PRINT_RPT":
                        string rptDir = "~/DEV/Sample/Rpt/Sample_Dev.rpt";
                        DataTable dt = new DataTable();
                        if(context.Request["WORK_TYPE"] != "3")
                        {
                            switch (context.Request["WORK_TYPE"])
                            {
                                case "0":
                                    rptDir = "~/DEV/Sample/Rpt/Sample_Dev.rpt";
                                    break;
                                case "1":
                                    rptDir = "~/DEV/Sample/Rpt/Sample_Ask.rpt";
                                    break;
                                case "2":
                                    rptDir = "~/DEV/Sample/Rpt/Sample_Get.rpt";
                                    break;
                            }
                        }
                        else
                        {
                            rptDir = "~/DEV/Sample/Rpt/Sample_Chk.rpt";
                        }

                        //報表型別不同自行處理
                        dt = service.SampleMTReport(ContextFN.ContextToDictionary(context));
                        if (dt != null && dt.Rows.Count > 0)
                        {
                            ReportDocument rptDoc = new ReportDocument();
                            rptDoc.Load(context.Server.MapPath(rptDir));
                            rptDoc.SetDataSource(dt);
                            System.IO.Stream stream = rptDoc.ExportToStream(CrystalDecisions.Shared.ExportFormatType.PortableDocFormat);
                            byte[] bytes = new byte[stream.Length];
                            stream.Read(bytes, 0, bytes.Length);
                            stream.Seek(0, System.IO.SeekOrigin.Begin);

                            string filename = "樣品開發維護.pdf";
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



