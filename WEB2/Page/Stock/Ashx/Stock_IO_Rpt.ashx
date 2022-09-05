<%@ WebHandler Language="C#" Class="Stock_IO_Rpt" %>

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

public class Stock_IO_Rpt : IHttpHandler, IRequiresSessionState
{
    public void ProcessRequest(HttpContext context)
    {
        StockService service = new StockService();
        string result = "";
        if (!string.IsNullOrEmpty(context.Request["Call_Type"]))
        {
            try
            {
                switch (context.Request["Call_Type"])
                {
                    case "SEARCH":
                        result = JsonConvert.SerializeObject(service.StockIORptSearch(ContextFN.ContextToDictionary(context)));
                        break;
                    case "RPT":
                        DataTable dt = new DataTable();
                        string rptDir = "~/Page/Stock/Rpt/Stock_IO_Img.rpt";
                        switch (context.Request["RPT_TYPE"])
                        {
                            case "待入出庫輸入核對表-圖":
                                rptDir = "~/Page/Stock/Rpt/Stock_IO_Img.rpt";
                                break;
                             case "外包裝貼紙":
                                rptDir = "~/Page/Stock/Rpt/Stock_IO_Sticker.rpt";
                                break;
                        }
                        dt = service.StockIORptPrint(ContextFN.ContextToDictionary(context));

                        //資料型別不同自己處理
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

                            string filename = "庫存待入出報表.pdf";
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



