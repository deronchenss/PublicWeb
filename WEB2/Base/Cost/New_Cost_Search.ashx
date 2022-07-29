<%@ WebHandler Language="C#" Class="New_Cost_Search" %>

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
using Newtonsoft.Json;
using Ivan_Service;
using Ivan_Log;

public class New_Cost_Search : IHttpHandler, IRequiresSessionState
{
    public void ProcessRequest(HttpContext context)
    {
        SqlConnection conn = new SqlConnection();
        DataTable dt = new DataTable();
        SqlCommand cmd = new SqlCommand();
        conn.ConnectionString = ConfigurationManager.ConnectionStrings["LocalBC2"].ConnectionString;
        try
        {
            switch (context.Request["Call_Type"])
            {
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
                                         WHERE C.[頤坊型號] LIKE @IM + '%'
                                            AND 
                                            (   
                                                (LEN(@PC) - LEN(REPLACE(@PC,'-',''))  = 1 AND @PC LIKE C.[產品一階] + '%' AND C.[產品一階] <> '')
                                             OR (LEN(@PC) - LEN(REPLACE(@PC,'-',''))  = 2 AND @PC LIKE C.[產品二階] + '%' AND C.[產品二階] <> '')
                                             OR (LEN(@PC) - LEN(REPLACE(@PC,'-',''))  = 3 AND @PC LIKE C.[產品三階] + '%' AND C.[產品三階] <> '')
                                             OR ISNULL(@PC,'') = ''
                                            )
                                            AND ((C.[更新日期] >= @Date_S AND C.[更新日期] <= DATEADD(DAY,+1,@Date_E)) OR (@Date_S ='' AND @Date_E = '' ))
                                            AND C.[廠商編號] LIKE @S_No + '%'
                                            AND C.[銷售型號] LIKE @SaleM + '%'
                                            AND C.[產品說明] LIKE '%' + @PI + '%'
		                                    AND (
			                                    (@BIgS = 'Y' AND ISNULL(C.[大貨庫存數],0) > 0)
			                                    OR (@BIgS = 'N' AND ISNULL(C.[大貨庫存數],0) = 0)
			                                    OR (@BIgS = 'ALL')
			                                    )
		                                    AND (
			                                    (@MSRP = 'Y' AND ISNULL(C.[MSRP],0) > 0)
			                                    OR (@MSRP = 'N' AND ISNULL(C.[MSRP],0) = 0)
			                                    OR (@MSRP = 'ALL')
			                                    )
		                                    AND (
			                                    (@PC_NEX = '1' AND ISNULL(C.[產品一階],'') = '')
			                                    OR (@PC_NEX = '2' AND ISNULL(C.[產品二階],'') = '')
			                                    OR (@PC_NEX = '3' AND ISNULL(C.[產品三階],'') = '')
                                                OR (@PC_NEX = 'ALL')
			                                    )
                                            AND (
                                                (@NO_L = 'True' AND ISNULL(C.[產品一階],'') <> '01') 
                                                 OR (@NO_L = 'False')
                                                )
                                         ORDER BY [Sort] desc ";
                    cmd.Parameters.AddWithValue("IM", context.Request["IM"]);
                    cmd.Parameters.AddWithValue("PC", context.Request["PC"]);
                    cmd.Parameters.AddWithValue("Date_S", context.Request["Date_S"]);
                    cmd.Parameters.AddWithValue("Date_E", context.Request["Date_E"]);
                    cmd.Parameters.AddWithValue("S_No", context.Request["S_No"]);
                    cmd.Parameters.AddWithValue("SaleM", context.Request["SaleM"]);
                    cmd.Parameters.AddWithValue("PI", context.Request["PI"]);
                    cmd.Parameters.AddWithValue("BigS", context.Request["BigS"]);
                    cmd.Parameters.AddWithValue("MSRP", context.Request["MSRP"]);
                    cmd.Parameters.AddWithValue("PC_NEX", context.Request["PC_NEX"]);
                    cmd.Parameters.AddWithValue("NO_L", context.Request["NO_L"]);
                    break;
                case "Fist_CAA_Approve_Search":
                    cmd.CommandText = @" SELECT TOP 500 [廠商簡稱], [頤坊型號], [產品說明], [單位], 
                                            '' [廠商確認], 
                                            '' [採購交期], 
                                            '' [採購單號], 
                                            [點收核准], [暫時型號], [廠商編號],
                                            CAST(ISNULL((SELECT TOP 1 1 FROM [192.168.1.135].pic.dbo.xpic X WHERE X.[SUPLU_SEQ] = C.[序號]),0) AS BIT) [Has_IMG], 
                                            [序號], [更新人員], LEFT(RTRIM(CONVERT(VARCHAR(20),[更新日期],20)),16) [更新日期], [更新日期] [Sort]
                                         FROM Dc2..suplu C
                                         WHERE ([點收核准] = 0 OR [點收核准] IS NULL)
                                               AND [頤坊型號] LIKE @IM + '%'
                                               AND [暫時型號] LIKE @SampleM + '%'
                                               --AND [採購單號] LIKE @Purchase_No + '%'
                                               AND [廠商編號] LIKE @S_No + '%'
                                               AND [廠商簡稱] LIKE @S_SName + '%' 
                                         ORDER BY [Sort] desc ";
                    cmd.Parameters.AddWithValue("IM", context.Request["IM"]);
                    cmd.Parameters.AddWithValue("SampleM", context.Request["SampleM"]);
                    //Will_Add
                    //cmd.Parameters.AddWithValue("Purchase_No", context.Request["Purchase_No"]);
                    cmd.Parameters.AddWithValue("S_No", context.Request["S_No"]);
                    cmd.Parameters.AddWithValue("S_SName", context.Request["S_SName"]);
                    break;
                case "Cost_Report_C_Search":
                    cmd.CommandText = @" SELECT TOP 500 [開發中], [廠商簡稱], [頤坊型號], [銷售型號], [暫時型號], [產品說明], [單位], [大貨庫存數],
                                         	CONVERT(VARCHAR(20),[新增日期],23) [新增日期],
	                                        CAST(ISNULL((SELECT TOP 1 1 FROM [192.168.1.135].pic.dbo.xpic X WHERE X.[SUPLU_SEQ] = C.[序號]),0) AS BIT) [Has_IMG], 
                                         	CONVERT(VARCHAR(20),[最後點收日],23) [最後點收日],
                                         	CONVERT(VARCHAR(20),[最後單價日],23) [最後單價日],
                                         	[廠商編號], 'Cost' [來源], [序號], [更新人員],
                                         	LEFT(RTRIM(CONVERT(VARCHAR(20),[更新日期],20)),16) [更新日期], [更新日期] [sort]
                                         FROM Dc2..suplu C
                                         WHERE [頤坊型號] LIKE @IM + '%'
                                         ORDER BY [sort] DESC ";
                    cmd.Parameters.AddWithValue("IM", context.Request["IM"]);
                    break;
                case "Cost_Report_P_Search":
                    cmd.CommandText = @" SELECT TOP 500 [開發中], [客戶簡稱], [頤坊型號], [客戶型號], 
                                         	CAST(ISNULL((SELECT TOP 1 1 FROM [192.168.1.135].pic.dbo.xpic X WHERE X.[SUPLU_SEQ] = P.[SUPLU_SEQ]),0) AS BIT) [Has_IMG], 
                                         	(SELECT C.[銷售型號] FROM Dc2..suplu C WHERE C.[序號] = P.SUPLU_SEQ) [銷售型號], 
                                         	[產品說明], [單位], [廠商編號], [廠商簡稱], [客戶編號], 'Price' [來源], [序號], [更新人員], 
                                         	LEFT(RTRIM(CONVERT(VARCHAR(20),[更新日期],20)),16) [更新日期], [更新日期] [sort]
                                         FROM Dc2..byrlu P
                                         WHERE [頤坊型號] LIKE @IM + '%'
                                         ORDER BY [sort] DESC ";
                    cmd.Parameters.AddWithValue("IM", context.Request["IM"]);
                    break;
                case "Cost_Report_Print":
                    string RPT_File = "~/Base/Cost/Rpt/Cost_Report_R1.rpt";
                    cmd.CommandText = @" 

SELECT TOP 5 [廠商編號], [廠商簡稱], [頤坊型號], [廠商型號], [產品說明], [單位], [最後單價日], 
	CASE WHEN [台幣單價] > 0 THEN 'NTD'
		 WHEN [美元單價] > 0 THEN 'USD'
		 ELSE NULL END [幣別],
	[台幣單價] [台幣金額], --bom 
	[美元單價] [美元金額],
	NULL [最後完成者], 
	NULL [材料型號],
	NULL [材料用量],
	CASE WHEN (SELECT COUNT(1) FROM Dc2..bom BM WHERE BM.SUPLU_SEQ = C.[序號]) > 1 THEN '組合品'
		 WHEN (SELECT COUNT(1) FROM Dc2..bomsub BD WHERE BD.D_SUPLU_SEQ = C.[序號]) > 1 THEN '材料'
		 ELSE '單一產品' END [型態],
	'USDTWD: ' + (SELECT [內容] FROM Dc2..REFDATA WHERE [代碼] = 'PUR_Rate') [抬頭一], 
	NULL [群組一],--最後完成者
	NULL [群組二],--最後完成者+頤坊型號
	'KEJYUU' [印表人員],
	(SELECT [付款條件] FROM Dc2..sup S WHERE S.[廠商編號] = C.[廠商編號]) [付款條件],
	NULL [組合品],--Exists bom 轉入單位 <> '*' > 組, Else ''
	'NTD ' + CONVERT(VARCHAR,CAST([台幣單價] AS money),1) + REPLICATE(' ',8) + IIF([min_1]=0,'',CAST([min_1] AS VARCHAR)) + REPLICATE(' ',7) + ISNULL(CONVERT(VARCHAR(20),CAST([最後單價日] AS DATE),111),'') [COST], 
	'門市-USD : ' + CAST( CAST([台幣單價] AS FLOAT) / CAST((SELECT [內容] FROM Dc2..REFDATA WHERE [代碼] = 'PUR_Rate') AS FLOAT) AS VARCHAR ) + REPLICATE(' ',10) + 'NTD : ' + IIF([台幣單價]=0,'',CAST([台幣單價] AS VARCHAR)) + CHAR(10) + CHAR(13) +
	'MSRP-REP : ' + CONVERT(VARCHAR,CAST([MSRP] AS money),1) + REPLICATE(' ',7) + CHAR(10) + CHAR(13)
	--'' + C.折扣
		 [PRICE], --~~~~
	NULL [MIDAS_UPRICE],--Bom
	NULL [MIDAS_AMT],--BOM
	'Y' [印價格填寫欄],--CB_Check, Y/''
	ROW_NUMBER() OVER (ORDER BY [序號])[序],
	ISNULL((SELECT TOP 1 [圖檔] FROM [192.168.1.135].pic.dbo.xpic X WHERE X.[SUPLU_SEQ] = C.[序號]),'') [圖檔], 
	ISNULL((SELECT TOP 1 'Y' FROM [192.168.1.135].pic.dbo.xpic X WHERE X.[SUPLU_SEQ] = C.[序號]),'N') [列印圖檔],
	[台幣單價] [換算美元]--台幣單價>同上台幣金額, by Bom
	--** 轉入單位=S時為原料銷售 > 金額相關、Cost =0
FROM Dc2..suplu C
WHERE 頤坊型號 LIKE '1339-%' AND 廠商編號 = '16602'


 ";
                    //cmd.Parameters.AddWithValue("IM", context.Request["IM"]);

                    SqlDataAdapter sqlDatai = new SqlDataAdapter(cmd);
                        
                    cmd.Connection = conn;
                    //SqlDataAdapter SDA = new SqlDataAdapter(cmd);
                    sqlDatai.Fill(dt);

                    if (dt != null && dt.Rows.Count > 0)
                    {
                        ReportDocument rptDoc = new ReportDocument();
                        rptDoc.Load(context.Server.MapPath(RPT_File));
                        rptDoc.SetDataSource(dt);
                        System.IO.Stream stream = rptDoc.ExportToStream(CrystalDecisions.Shared.ExportFormatType.PortableDocFormat);
                        byte[] bytes = new byte[stream.Length];
                        stream.Read(bytes, 0, bytes.Length);
                        stream.Seek(0, System.IO.SeekOrigin.Begin);

                        string filename = "T.pdf";
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
            cmd.Connection = conn;
            conn.Open();
            SqlDataAdapter SDA = new SqlDataAdapter(cmd);
            SDA.Fill(dt);
            conn.Close();
            var json = JsonConvert.SerializeObject(dt);
            Log.InsertLog(context, context.Session["Account"], cmd.CommandText);
            context.Response.ContentType = "text/json";
            context.Response.Write(json);
        }

        catch (SqlException ex)
        {
            Log.InsertLog(context, context.Session["Account"], cmd.CommandText ?? "", ex.ToString(), false);
            context.Response.StatusCode = 404;
            context.Response.Write(ex.Message);
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