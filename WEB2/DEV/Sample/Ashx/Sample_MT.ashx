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

public class Sample_MT : IHttpHandler, IRequiresSessionState
{
    public void ProcessRequest(HttpContext context)
    {
        DataTable dt = new DataTable();
        Dal_Pudu dal = new Dal_Pudu(context);

        if (!string.IsNullOrEmpty(context.Request["Call_Type"]))
        {
            try
            {
                int res = 0;
                switch (context.Request["Call_Type"])
                {
                    case "Sample_Base":
                        dt = dal.SearchTableForMT();
                        break;
                    case "UPD_SAMPLE":
                        res = dal.UpdatePudu();
                        context.Response.StatusCode = 200;
                        context.Response.Write(res);
                        context.Response.End();
                        break;
                    case "INSERT_SAMPLE":
                        res = dal.InsertPudu();
                        context.Response.StatusCode = 200;
                        context.Response.Write(res);
                        context.Response.End();
                        break;
                    case "SEQ_PURC_SEQ":
                        res = dal.UpdateSeq();
                        context.Response.StatusCode = res != 1 ? 200 : 404;
                        context.Response.Write(res);
                        context.Response.End();
                        break;
                    case "UPD_RPT_REMARK":
                        res = dal.UpdateRptRemark();
                        context.Response.StatusCode = res > 0 ? 200 : 404;
                        context.Response.Write(res);
                        context.Response.End();
                        break;
                    case "UPD_WRITEOFF":
                        dal.UpdateWriteOff();
                        context.Response.StatusCode = 200;
                        context.Response.Write(res);
                        context.Response.End();
                        break;
                    case "PRINT_RPT":
                        string rptDir = "~/DEV/Sample/Rpt/Sample_Dev.rpt";
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

                        dt = dal.SampleMTReport();
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



