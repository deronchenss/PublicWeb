<%@ WebHandler Language = "C#" Class="Sample_Arr_MT" %>

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

public class Sample_Arr_MT : IHttpHandler, IRequiresSessionState
{
    public void ProcessRequest(HttpContext context)
    {
        DataTable dt = new DataTable();
        Dal_Recu dal = new Dal_Recu(context);

        int result = 0;
        if (!string.IsNullOrEmpty(context.Request["Call_Type"]))
        {
            try
            {
                switch (context.Request["Call_Type"])
                {
                    case "Search_Recu":
                        dt = dal.SearchTable();
                        break;
                    case "UPD_RECU":
                        result = dal.UpdateRecu();

                        context.Response.StatusCode = 200;
                        context.Response.Write(result);
                        context.Response.End();
                        break;
                    case "DELETE_RECU":
                        result = dal.DeleteRecu();

                        context.Response.StatusCode = 200;
                        context.Response.Write(result);
                        context.Response.End();
                        break;
                    case "PRINT_RPT":
                        string rptDir = "~/DEV/Sample/Rpt/Invoice_Tot_Amt.rpt";
                        switch (context.Request["RPT_TYPE"])
                        {
                            case "0":
                                rptDir = "~/DEV/Sample/Rpt/Invoice_Tot_Amt.rpt";
                                dt = dal.SampleShippingReport();
                                break;
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

                            string filename = "樣品出貨.pdf";
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



