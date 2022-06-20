<%@ WebHandler Language="C#" Class="BOM_Search" %>

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


public class BOM_Search : IHttpHandler, IRequiresSessionState
{
    //SqlConnection LocalBC2 = new SqlConnection(WebConfigurationManager.ConnectionStrings["LocalBC2"].ConnectionString.ToString());
    public void ProcessRequest(HttpContext context)
    {
        DataTable DT = new DataTable();

        if (!string.IsNullOrEmpty(context.Request["Call_Type"]))
        {
            List<object> BOM = new List<object>();
            SqlConnection conn = new SqlConnection();
            conn.ConnectionString = ConfigurationManager.ConnectionStrings["LocalBC2"].ConnectionString;
            SqlCommand cmd = new SqlCommand();
            switch (context.Request["Call_Type"])
            {
                case "BOM1_Search":
                    cmd.CommandText = @" SELECT TOP 500 [P_SEQ], [序號], [頤坊型號], [開發中], [最後完成者], [完成者簡稱], [註記], [更新人員],
                                         	LEFT(RTRIM(CONVERT(VARCHAR(20),[更新日期],20)),16) [更新日期]
                                         FROM Dc2..bom
                                         WHERE 1 = 1 ";
                    if (!string.IsNullOrEmpty(context.Request["Search_Where"]))
                    {
                        cmd.CommandText += " AND " + context.Request["Search_Where"];
                    }
                    cmd.CommandText += " ORDER BY [序號] DESC ";
                    break;
                case "BOM1_Selected":
                    cmd.CommandText = @" SELECT A.[P_SEQ], A.[序號], ISNULL(A.[上層序號],-1) [上層序號], DP.[頤坊型號] [材料型號], A.[PD_SEQ], A.[階層], A.[更新人員], 
                                         	   LEFT(RTRIM(CONVERT(VARCHAR(20),A.[更新日期],20)),16) [更新日期],
                                         	   CAST(ISNULL((SELECT TOP 1 1 FROM [192.168.1.135].pic.dbo.xpic X WHERE X.[P_SEQ] = A.[PD_SEQ]),0) AS BIT) [Has_IMG],
                                         	   CAST(ISNULL((SELECT TOP 1 1 FROM Dc2..bomsub X WHERE X.[上層序號] = A.[序號]),0) AS BIT) [Has_Child],
                                         	   CASE WHEN A.[階層] = 1 THEN '0'
                                         	   		WHEN A.[階層] = 2 THEN DP.[頤坊型號]
                                         	        --ELSE (SELECT TOP 1 X.[材料型號] FROM Dc2..bomsub X WHERE X.[序號] = A.[上層序號]) END [Sort_Group],
                                         	        ELSE (SELECT X2.[頤坊型號] FROM Dc2..suplu X2 WHERE X2.序號 = (SELECT TOP 1 X.[PD_SEQ] FROM Dc2..bomsub X WHERE X.[序號] = A.[上層序號])) END [Sort_Group],
                                         	   MP.[頤坊型號], DP.[廠商簡稱], A.[材料用量], A.[採購], A.[轉入單位], MP.[廠商編號] [最後完成者], MP.[廠商簡稱] [完成者簡稱], DP.[廠商編號],
	                                           A.[原料銷售], A.[不發單], A.[不展開], A.[不計成本],
                                         	   DP.[開發中], DP.[單位], DP.[產品說明], DP.[台幣單價], DP.[美元單價], 
                                         	   LEFT(RTRIM(CONVERT(VARCHAR(20),DP.[停用日期],20)),16) [停用日期],
                                               (SELECT X.備註 FROM Dc2..bom X WHERE X.[P_SEQ] = A.[P_SEQ]) [M_Remark]
                                         FROM Dc2..bomsub A
                                         	LEFT JOIN Dc2..suplu DP ON DP.[序號] = A.[PD_SEQ]
											LEFT JOIN Dc2..suplu MP ON MP.[序號] = A.[P_SEQ]
                                         WHERE A.[P_SEQ] = @P_SEQ ";
                    cmd.CommandText += " ORDER BY [Sort_Group], [階層], [材料型號] ";
                    cmd.Parameters.AddWithValue("P_SEQ", context.Request["P_SEQ"]);
                    break;
                case "GET_IMG":
                    cmd.CommandText = @" SELECT TOP 1 [P_SEQ], [圖檔] [P_IMG]
                                         FROM [192.168.1.135].pic.dbo.xpic
                                         WHERE [P_SEQ] = @P_SEQ ";
                    cmd.Parameters.AddWithValue("P_SEQ", context.Request["P_SEQ"]);
                    break;
                case "Product_Search":
                    cmd.CommandText = @" SELECT TOP 100 [序號], [開發中], [頤坊型號], [廠商編號], [廠商簡稱], [單位], [產品說明]
                                         FROM Dc2..suplu
                                         WHERE [頤坊型號] LIKE @IM + '%' AND [廠商編號] LIKE '%' + @S_No + '%' ";
                    cmd.Parameters.AddWithValue("IM", context.Request["IM"]);
                    cmd.Parameters.AddWithValue("S_No", context.Request["S_No"]);
                    break;
            }
            cmd.Connection = conn;
            conn.Open();
            SqlDataReader sdr = cmd.ExecuteReader();
            switch (context.Request["Call_Type"])
            {
                case "BOM1_Search":
                    while (sdr.Read())
                    {
                        BOM.Add(new
                        {
                            P_SEQ = sdr["P_SEQ"],
                            SEQ = sdr["序號"],
                            IM = sdr["頤坊型號"],
                            DVN = sdr["開發中"],
                            F_S_No = sdr["最後完成者"],
                            F_S_SName = sdr["完成者簡稱"],
                            Mark = sdr["註記"],
                            Update_User = sdr["更新人員"],
                            Update_Date = sdr["更新日期"],
                        });
                    }
                    break;
                case "BOM1_Selected":
                    while (sdr.Read())
                    {
                        BOM.Add(new
                        {
                            P_SEQ = sdr["P_SEQ"],
                            SEQ = sdr["序號"],
                            Parent_SEQ = sdr["上層序號"],
                            Material_Model = sdr["材料型號"],
                            PD_SEQ = sdr["PD_SEQ"],
                            Rank = sdr["階層"],

                            DVN = sdr["開發中"],
                            IM = sdr["頤坊型號"],
                            M_S_No = sdr["最後完成者"],
                            M_S_SName = sdr["完成者簡稱"],
                            Unit = sdr["單位"],
                            M_Amount = sdr["材料用量"],
                            Purchase_Plan = sdr["採購"],
                            PI = sdr["產品說明"],
                            TWD_P = sdr["台幣單價"],
                            USD_P = sdr["美元單價"],
                            D_S_No = sdr["廠商編號"],
                            D_S_SName = sdr["廠商簡稱"],
                            SD = sdr["停用日期"],
                            MS = sdr["原料銷售"],
                            NB = sdr["不發單"],
                            NE = sdr["不展開"],
                            NCC = sdr["不計成本"],
                            Update_User = sdr["更新人員"],
                            Update_Date = sdr["更新日期"],
                            HASIMG = sdr["Has_IMG"],
                            HASC = sdr["Has_Child"],

                            M_Remark = sdr["M_Remark"],//M欄位可考慮移植單獨呼叫，似IMG
                        });
                    }
                    break;
                case "GET_IMG":
                    while (sdr.Read())
                    {
                        BOM.Add(new
                        {
                            P_SEQ = sdr["P_SEQ"],
                            P_IMG = sdr["P_IMG"],
                        });
                    }
                    break;
                case "Product_Search":
                    while (sdr.Read())
                    {
                        BOM.Add(new
                        {
                            SEQ = sdr["序號"],
                            DVN = sdr["開發中"],
                            IM = sdr["頤坊型號"],
                            S_No = sdr["廠商編號"],
                            S_SName = sdr["廠商簡稱"],
                            Unit = sdr["單位"],
                            PI = sdr["產品說明"],
                        });
                    }
                    break;
            }
            SqlDataAdapter SQL_DA = new SqlDataAdapter(cmd);
            conn.Close();
            SQL_DA.Fill(DT);

            var json = (new JavaScriptSerializer().Serialize(BOM));
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
