<%@ WebHandler Language="C#" Class="Cost_Search" %>

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
using CrystalDecisions.CrystalReports.Engine;


public class Cost_Search : IHttpHandler, IRequiresSessionState
{
    //SqlConnection LocalBC2 = new SqlConnection(WebConfigurationManager.ConnectionStrings["LocalBC2"].ConnectionString.ToString());
    public void ProcessRequest(HttpContext context)
    {
        DataTable DT = new DataTable();

        if (!string.IsNullOrEmpty(context.Request["Call_Type"]))
        {
            List<object> Cost = new List<object>();
            SqlConnection conn = new SqlConnection();
            conn.ConnectionString = ConfigurationManager.ConnectionStrings["LocalBC2"].ConnectionString;
            SqlCommand cmd = new SqlCommand();
            switch (context.Request["Call_Type"])
            {
                case "Cost_MT_Search":
                    cmd.CommandText = @" SELECT TOP 500 [頤坊型號], [廠商型號], [廠商編號], [廠商簡稱], [暫時型號], [單位], 
                                                                [台幣單價], [美元單價], [外幣幣別], [外幣單價], [MIN_1], 
                                                                CONVERT(VARCHAR(20),[最後單價日],23) [最後單價日],
                                                                [產品說明], 
                                                                LEFT(RTRIM(CONVERT(VARCHAR(20),[新增日期],20)),16) [新增日期],
                                                                [圖型啟用], [序號], [更新人員], 
                                                                LEFT(RTRIM(CONVERT(VARCHAR(20),[更新日期],20)),16) [更新日期], [更新日期] [Sort]
                                                 FROM Dc2..suplu
                                                 WHERE 1 = 1 ";
                    if (!string.IsNullOrEmpty(context.Request["Search_Where"]))
                    {
                        cmd.CommandText += " AND " + context.Request["Search_Where"];
                    }
                    cmd.CommandText += " ORDER BY [Sort] DESC ";
                    break;
                case "Cost_MT_Selected":
                    cmd.CommandText = @" SELECT TOP 1 [序號], [頤坊型號], [廠商型號], [廠商編號], [廠商簡稱], [暫時型號], 
                                                 			  [單位], [產品說明], [產品詳述], [台幣單價], [美元單價], [台幣單價_2], [台幣單價_3], 
                                                 			  [MIN_1], [MIN_2], [MIN_3], [外幣幣別], [外幣單價], [外幣單價_2], [外幣單價_3], 
                                                              [設計人員], [設計圖號], [備註給採購], [備註給開發],
                                                              [開發中], RTRIM([產品狀態]) [產品狀態], [停用日期], [更新人員], 
                                                              LEFT(RTRIM(CONVERT(VARCHAR(20),[更新日期],20)),16) [更新日期],
                                                              (SELECT TOP 1 b.[圖檔] FROM [192.168.1.135].Pic.dbo.xpic b WHERE SUPLU_SEQ = a.[序號]) [IMG],
                                                              [變更記錄],
                                                              LEFT(RTRIM(CONVERT(VARCHAR(20),[新增日期],20)),16) [新增日期],
                                                              [製造規格], 
                                                              [工時], [內盒容量], [外箱編號], [淨重],
                                                              [內盒數], [外箱長度], [毛重], [外箱寬度], [外箱高度], [內箱數],
                                                              [單位淨重], [單位毛重], [產品長度], [產品寬度], [產品高度], [包裝深長], [包裝面寬], [包裝高度]
                                                 FROM Dc2..suplu a
                                                 WHERE [序號] = @SEQ ";
                    cmd.Parameters.AddWithValue("SEQ", context.Request["SEQ"]);
                    break;
                case "Copy_ALL_Check":
                    cmd.CommandText = @" SELECT 1 [Rows] FROM Dc2..suplu WHERE [頤坊型號] = @IM AND [廠商編號] = @S_No ";
                    cmd.Parameters.AddWithValue("IM", context.Request["IM"]);
                    cmd.Parameters.AddWithValue("S_No", context.Request["S_No"]);
                    break;
                case "Cost_Apply_Search":
                    cmd.CommandText = @" DECLARE @PUR_USD_Rate float = (SELECT [內容] FROM Dc2..refdata WHERE [代碼] = 'PUR_Rate')
                                         DECLARE @ORD_USD_Rate float = (SELECT [內容] FROM Dc2..refdata WHERE [代碼] = 'ORD_Rate')
                                         SELECT IIF(ISNULL(A.[MSRP],0) = 0,'0', CAST(ROUND( (A.MSRP - A.Cost) / A.MSRP * 100 ,2,2) AS VARCHAR(20)) + '%' )  [GP], * 
                                         FROM (
                                            SELECT TOP 500 P.[開發中], P.[廠商簡稱], P.[頤坊型號], P.[廠商型號], P.[銷售型號], P.[產品說明], P.[單位], 
                                                REPLACE(CONVERT(VARCHAR(40),CAST(P.[台幣單價] AS MONEY),1),'.00','') [台幣單價], 
                                                P.[美元單價], P.[外幣幣別], P.[外幣單價], REPLACE(P.[變更記錄],'""','') [變更記錄], P.[MSRP], 
                                            	CASE WHEN ISNULL(P.[MSRP],0) = 0 THEN 0
                                            		 WHEN (SELECT 1 FROM Dc2..bom BM WHERE BM.SUPLU_SEQ = P.[序號]) IS NULL THEN ROUND(P.[美元單價] + (P.[台幣單價] / @PUR_USD_Rate),2)
                                            		 ELSE (SELECT ROUND( SUM( (BDP.[美元單價] * BD.[材料用量]) + (BDP.[台幣單價] * BD.[材料用量] / @PUR_USD_Rate )) ,2)
                                            			   FROM Dc2..bomsub BD 
                                            				INNER JOIN Dc2..suplu BDP ON BDP.[序號]	= BD.D_SUPLU_SEQ  
                                            			   WHERE BD.SUPLU_SEQ = P.[序號] AND BD.[不計成本] = 0 ) END [Cost],
                                            	CONVERT(VARCHAR(20),P.[最後單價日],23) [最後單價日], P.[廠商編號], P.[序號], P.[申請原因],
                                            	P.[更新人員], LEFT(RTRIM(CONVERT(VARCHAR(20),P.[更新日期],20)),16) [更新日期], 
                                            	CAST(ISNULL((SELECT TOP 1 1 FROM [192.168.1.135].pic.dbo.xpic X WHERE X.[SUPLU_SEQ] = P.[序號]),0) AS BIT) [Has_IMG]
                                            FROM Dc2..suplu P
                                            WHERE (P.[開發中] = @DVN OR @DVN = 'ALL')
                                                   AND P.[頤坊型號] LIKE @IM + '%'
                                                   AND P.[廠商編號] LIKE @S_No + '%'
                                                   AND ((P.[更新日期] >= @Date_S AND DATEADD(DAY,-1,P.[更新日期]) <= @Date_E) OR (@Date_S ='' AND @Date_E = '' ))
                                         ) A
                                         ORDER BY [頤坊型號] ";
                    cmd.Parameters.AddWithValue("IM", context.Request["IM"]);
                    cmd.Parameters.AddWithValue("S_No", context.Request["S_No"]);
                    cmd.Parameters.AddWithValue("Date_S", context.Request["Date_S"]);
                    cmd.Parameters.AddWithValue("Date_E", context.Request["Date_E"]);
                    cmd.Parameters.AddWithValue("DVN", context.Request["DVN"]);
                    break;
                case "Cost_Class_Search":
                    cmd.CommandText = @" SELECT TOP 500 
                                         	[頤坊型號], [廠商型號], [銷售型號], [廠商簡稱], [單位], [產品一階], [產品二階], [產品三階], [一階V3], [二階V3], [MSRP], [產品說明], 
                                         	'ORD' [最後接單], 
                                         --(SELECT Max(接單日期) From ORD A WHERE A.頤坊型號=T1.頤坊型號 AND A.廠商編號=T1.廠商編號 AND A.訂單數量>0) AS 最後接單,
                                         	[大貨庫存數], [分配庫存數], 
                                         	'PUD' 庫存在途, 
                                         --(SELECT Sum(採購數量-點收數量) From PUD A WHERE A.頤坊型號=T1.頤坊型號 AND A.廠商編號=T1.廠商編號 AND IsNull(A.採購單號,'')<>'' AND (A.採購數量-A.點收數量)>0 AND (A.訂單號碼 Like 'X%' Or A.訂單號碼 Like 'WR%') AND IsNull(A.已刪除,0)=0) AS 庫存在途,
                                         	[大貨安全數], [台北安全數], [ISP安全數], [UNActive], [國際條碼], [樣式], [大貨庫位], [廠商編號], 
                                            --[圖型啟用], 
                                            CAST(ISNULL((SELECT TOP 1 1 FROM [192.168.1.135].pic.dbo.xpic X WHERE X.[SUPLU_SEQ] = C.[序號]),0) AS BIT) [Has_IMG],
                                            [序號], [更新人員], LEFT(RTRIM(CONVERT(VARCHAR(20),[更新日期],20)),16) [更新日期], [更新日期] [Sort]
                                         FROM Dc2..suplu C
                                         WHERE 1 = 1
                                         ORDER BY [Sort] desc ";
                    //cmd.Parameters.AddWithValue("S_No", context.Request["S_No"]);
                    break;
            }
            cmd.Connection = conn;
            conn.Open();
            SqlDataReader sdr = cmd.ExecuteReader();
            switch (context.Request["Call_Type"])
            {
                case "Cost_MT_Search":
                    while (sdr.Read())
                    {
                        Cost.Add(new
                        {
                            SEQ = sdr["序號"],
                            IM = sdr["頤坊型號"].ToString().Trim(),
                            SM = sdr["廠商型號"].ToString().Trim(),
                            S_No = sdr["廠商編號"].ToString().Trim(),
                            S_SName = sdr["廠商簡稱"].ToString().Trim(),
                            Sample_PN = sdr["暫時型號"].ToString().Trim(),
                            Unit = sdr["單位"].ToString().Trim(),
                            TWD_P = sdr["台幣單價"],
                            USD_P = sdr["美元單價"],
                            Curr = sdr["外幣幣別"],
                            Curr_P = sdr["外幣單價"],
                            MIN_1 = sdr["MIN_1"],
                            LSTP_Day = sdr["最後單價日"],
                            PI = sdr["產品說明"].ToString().Trim(),
                            Create_Date = sdr["新增日期"],
                            IMG_Enabele = sdr["圖型啟用"],
                            S_Update_User = sdr["更新人員"].ToString().Trim(),
                            S_Update_Date = sdr["更新日期"],
                        });
                    }
                    break;
                case "Cost_MT_Selected":
                    while (sdr.Read())
                    {
                        Cost.Add(new
                        {
                            IM = sdr["頤坊型號"].ToString().Trim(),
                            SM = sdr["廠商型號"].ToString().Trim(),
                            S_No = sdr["廠商編號"].ToString().Trim(),
                            S_SName = sdr["廠商簡稱"].ToString().Trim(),
                            Sample_PN = sdr["暫時型號"].ToString().Trim(),
                            Unit = sdr["單位"],
                            PI = sdr["產品說明"].ToString().Trim(),
                            PID = sdr["產品詳述"].ToString().Trim(),
                            P_TWD = sdr["台幣單價"],
                            P_USD = sdr["美元單價"],
                            P_TWD_2 = sdr["台幣單價_2"],
                            P_TWD_3 = sdr["台幣單價_3"],
                            MIN_1 = sdr["MIN_1"],
                            MIN_2 = sdr["MIN_2"],
                            MIN_3 = sdr["MIN_3"],
                            Curr = sdr["外幣幣別"],
                            P_Curr = sdr["外幣單價"],
                            P_Curr_2 = sdr["外幣單價_2"],
                            P_Curr_3 = sdr["外幣單價_3"],
                            DS_P = sdr["設計人員"],
                            DS_IM = sdr["設計圖號"],
                            RP = sdr["備註給採購"],
                            RD = sdr["備註給開發"],
                            DPN = sdr["開發中"],
                            PS = sdr["產品狀態"],
                            SDate = sdr["停用日期"],
                            SEQ = sdr["序號"],
                            Update_User = sdr["更新人員"],
                            Update_Date = sdr["更新日期"],
                            IMG = sdr["IMG"],
                            CL = sdr["變更記錄"].ToString().Trim(),
                            MS = sdr["製造規格"].ToString().Trim(),
                            WH = sdr["工時"],
                            IBC = sdr["內盒容量"],
                            OBNo = sdr["外箱編號"],
                            NW = sdr["淨重"],
                            OBL = sdr["外箱長度"],
                            GW = sdr["毛重"],
                            IA = sdr["內盒數"],
                            OBW = sdr["外箱寬度"],
                            OBH = sdr["外箱高度"],
                            IA2 = sdr["內箱數"],
                            P_NW = sdr["單位淨重"],
                            P_GW = sdr["單位毛重"],
                            PL = sdr["產品長度"],
                            PW = sdr["產品寬度"],
                            PH = sdr["產品高度"],
                            PGL = sdr["包裝深長"],
                            PGW = sdr["包裝面寬"],
                            PGH = sdr["包裝高度"],
                        });
                    }
                    break;
                case "Copy_ALL_Check":
                    while (sdr.Read())
                    {
                        Cost.Add(new
                        {
                            Rows = sdr["Rows"],
                        });
                    }
                    break;
                case "Cost_Apply_Search":
                    while (sdr.Read())
                    {
                        Cost.Add(new
                        {
                            DVN = sdr["開發中"].ToString().Trim(),
                            S_SName = sdr["廠商簡稱"],
                            IM = sdr["頤坊型號"],
                            SM = sdr["廠商型號"],
                            SaleM = sdr["銷售型號"],
                            PI = sdr["產品說明"],
                            Unit = sdr["單位"],
                            TWD_P = sdr["台幣單價"],
                            USD_P = sdr["美元單價"],
                            Curr = sdr["外幣幣別"],
                            Curr_P = sdr["外幣單價"],
                            Change_Log = sdr["變更記錄"],
                            MSRP = sdr["MSRP"],
                            Cost = sdr["Cost"],
                            GP = sdr["GP"],
                            LSTP_Day = sdr["最後單價日"],
                            S_No = sdr["廠商編號"],
                            SEQ = sdr["序號"],
                            Apply_Reason = sdr["申請原因"],
                            Has_IMG = sdr["Has_IMG"],
                            Update_User = sdr["更新人員"],
                            Update_Date = sdr["更新日期"],
                        });
                    }
                    break;
                case "Cost_Class_Search":
                    while (sdr.Read())
                    {
                        Cost.Add(new
                        {
                            IM = sdr["頤坊型號"],
                            SM = sdr["廠商型號"],
                            SaleM = sdr["銷售型號"],
                            S_SName = sdr["廠商簡稱"],
                            Unit = sdr["單位"],
                            Rank1 = sdr["產品一階"],
                            Rank2 = sdr["產品二階"],
                            Rank3 = sdr["產品三階"],
                            Rank1_V3 = sdr["一階V3"],
                            Rank2_V3 = sdr["二階V3"],
                            MSRP = sdr["MSRP"],
                            PI = sdr["產品說明"],
                            LS_ORD = sdr["最後接單"],
                            Location_1_Stock = sdr["大貨庫存數"],
                            Location_2_Stock = sdr["分配庫存數"],
                            SUM_PUD = sdr["庫存在途"],
                            Location_1_Safe = sdr["大貨安全數"],
                            Location_TPE_Safe = sdr["台北安全數"],
                            Location_ISP_Safe = sdr["ISP安全數"],
                            UN = sdr["UNActive"],
                            I_No = sdr["國際條碼"],
                            P_Style = sdr["樣式"],
                            Location_1_Area = sdr["大貨庫位"],
                            S_No = sdr["廠商編號"],
                            Has_IMG = sdr["Has_IMG"],
                            SEQ = sdr["序號"],
                            Update_User = sdr["更新人員"],
                            Update_Date = sdr["更新日期"],
                        });
                    }
                    break;
            }

            SqlDataAdapter SQL_DA = new SqlDataAdapter(cmd);
            conn.Close();
            SQL_DA.Fill(DT);

            //CRPT_Test
            if (context.Request["Call_Type"] == "Cost_MT_Selected")
            {
                //ReportDocument rptDoc = new ReportDocument();
                //rptDoc.Load(context.Server.MapPath("~/Base/Cost/Rpt/Bc830_4a.rpt"));
                //rptDoc.SetDataSource(DT);
                //System.IO.Stream stream = rptDoc.ExportToStream(CrystalDecisions.Shared.ExportFormatType.PortableDocFormat);
                //byte[] bytes = new byte[stream.Length];
                //stream.Read(bytes, 0, bytes.Length);
                //stream.Seek(0, System.IO.SeekOrigin.Begin);

                //string filename = "TEST_RPT.pdf";
                //context.Response.ClearContent();
                //context.Response.ClearHeaders();
                //context.Response.AddHeader("content-disposition", "attachment;filename=" + filename);
                //context.Response.ContentType = "application/pdf";
                //context.Response.OutputStream.Write(bytes, 0, bytes.Length);
                //context.Response.Flush();
                //context.Response.Close();
            }

            var json = (new JavaScriptSerializer().Serialize(Cost));
            context.Response.ContentType = "text/json";
            context.Response.Write(json);
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
