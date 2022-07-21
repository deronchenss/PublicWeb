using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CrystalDecisions.CrystalReports.Engine;
//using Seagull.BarTender.Print;
public partial class Cost_Cost_MT : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        #region BarTender

        #endregion BT

        #region Crystal_Report_Demo
        //DataTable DT = new DataTable();
        //using (SqlConnection conn = new SqlConnection())
        //{
        //    conn.ConnectionString = ConfigurationManager.ConnectionStrings["LocalBC2"].ConnectionString;
        //    using (SqlCommand cmd = new SqlCommand())
        //    {
        //        cmd.CommandText = @" SELECT [序號], [頤坊型號], [廠商型號], [廠商編號], [廠商簡稱], [暫時型號], 
        //                                         			  [單位], [產品說明], [產品詳述], [台幣單價], [美元單價], [台幣單價_2], [台幣單價_3], 
        //                                         			  [MIN_1], [MIN_2], [MIN_3], [外幣幣別], [外幣單價], [外幣單價_2], [外幣單價_3], 
        //                                                      [設計人員], [設計圖號], [備註給採購], [備註給開發],
        //                                                      [開發中], RTRIM([產品狀態]) [產品狀態], [停用日期], [更新人員], 
        //                                                      LEFT(RTRIM(CONVERT(VARCHAR(20),[更新日期],20)),16) [更新日期],
        //                                                      (SELECT TOP 1 b.[圖檔] FROM [192.168.1.135].Pic.dbo.xpic b WHERE P_SEQ = a.[序號]) [IMG],
        //                                                      (SELECT TOP 1 b.[圖檔] FROM [192.168.1.135].Pic.dbo.xpic b WHERE P_SEQ = a.[序號]) [圖檔],
        //                                                      [變更記錄],
        //                                                      LEFT(RTRIM(CONVERT(VARCHAR(20),[新增日期],20)),16) [新增日期],
        //                                                      [製造規格], 
        //                                                      [工時], [內盒容量], [外箱編號], [淨重],
        //                                                      [內盒數], [外箱長度], [毛重], [外箱寬度], [外箱高度], [內箱數],
        //                                                      [單位淨重], [單位毛重], [產品長度], [產品寬度], [產品高度], [包裝深長], [包裝面寬], [包裝高度],
        //                                                      '' [型態], '' [群組1], 0 [列印金額], 0 [列印單價], [台幣單價] [台幣金額], [美元單價] [美元金額],
        //                                                      0 [人民幣金額]
        //                                         FROM Dc2..suplu a
        //                                         WHERE [序號] = @SEQ ";
        //        cmd.Parameters.AddWithValue("SEQ", "125915");
        //        cmd.Connection = conn;
        //        conn.Open();
        //        SqlDataAdapter SQL_DA = new SqlDataAdapter(cmd);
        //        SQL_DA.Fill(DT);

        //        ReportDocument rptDoc = new ReportDocument();
        //        rptDoc.Load(Server.MapPath("~/Cost/Rpt/Bc830_4a.rpt"));
        //        rptDoc.SetDataSource(DT);
        //        System.IO.Stream stream = rptDoc.ExportToStream(CrystalDecisions.Shared.ExportFormatType.PortableDocFormat);
        //        byte[] bytes = new byte[stream.Length];
        //        stream.Read(bytes, 0, bytes.Length);
        //        stream.Seek(0, System.IO.SeekOrigin.Begin);

        //        string filename = "TEST_RPT.pdf";
        //        Response.ClearContent();
        //        Response.ClearHeaders();
        //        Response.AddHeader("content-disposition", "attachment;filename=" + filename);
        //        Response.ContentType = "application/pdf";
        //        Response.OutputStream.Write(bytes, 0, bytes.Length);
        //        Response.Flush();
        //        Response.Close();
        //    }
        //}
        #endregion//CSR
    }
}