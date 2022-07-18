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

public class New_Cost_Search : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        SqlConnection conn = new SqlConnection();
        DataTable dt = new DataTable();
        SqlCommand cmd = new SqlCommand();
        conn.ConnectionString = ConfigurationManager.ConnectionStrings["LocalBC2"].ConnectionString;
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
        }
        cmd.Connection = conn;
        conn.Open();
        SqlDataAdapter SDA = new SqlDataAdapter(cmd);
        SDA.Fill(dt);
        conn.Close();
        var json = JsonConvert.SerializeObject(dt);
        context.Response.ContentType = "text/json";
        context.Response.Write(json);
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}