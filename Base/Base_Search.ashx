<%@ WebHandler Language="C#" Class="Base_Search" %>

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


public class Base_Search : IHttpHandler, IRequiresSessionState
{
    //SqlConnection LocalBC2 = new SqlConnection(WebConfigurationManager.ConnectionStrings["LocalBC2"].ConnectionString.ToString());
    public void ProcessRequest(HttpContext context)
    {
        DataTable DT = new DataTable();

        if (!string.IsNullOrEmpty(context.Request["Call_Type"]))
        {
            List<object> Base = new List<object>();
            SqlConnection conn = new SqlConnection();
            conn.ConnectionString = ConfigurationManager.ConnectionStrings["LocalBC2"].ConnectionString;
            SqlCommand cmd = new SqlCommand();
            switch (context.Request["Call_Type"])
            {
                case "Base_C_Search":
                    cmd.CommandText = @" SELECT TOP 500 [廠商簡稱], [頤坊型號], [產品說明], [單位], [廠商型號], [銷售型號], [暫時型號], [產品狀態], 
                                                        [產品一階], [產品二階], [產品三階], [國際條碼], [廠商編號], [開發中], [序號], [更新人員], 
                                            CONVERT(VARCHAR(20),[停用日期],23) [停用日期],
                                         	LEFT(RTRIM(CONVERT(VARCHAR(20),[更新日期],20)),16) [更新日期], [更新日期] [Sort]
                                         FROM Dc2..suplu C
                                         WHERE [頤坊型號] LIKE @IM + '%'
                                            AND [暫時型號] LIKE @SampleM + '%'
                                            AND 
                                            (   
                                                (LEN(@PC) - LEN(REPLACE(@PC,'-',''))  = 1 AND @PC LIKE [產品一階] + '%' AND 產品一階 <> '')
                                             OR (LEN(@PC) - LEN(REPLACE(@PC,'-',''))  = 2 AND @PC LIKE [產品二階] + '%' AND 產品二階 <> '')
                                             OR (LEN(@PC) - LEN(REPLACE(@PC,'-',''))  = 3 AND @PC LIKE [產品三階] + '%' AND 產品三階 <> '')
                                             OR ISNULL(@PC,'') = ''
                                            )
                                            --AND @PC IN ([產品一階],[產品二階],[產品三階])
                                            AND [廠商編號] LIKE @S_No + '%'
                                            AND [國際條碼] LIKE '%' + @IN + '%'
                                            AND [廠商型號] LIKE @SupM + '%'
                                            AND [銷售型號] LIKE @SaleM + '%'
                                            AND [產品說明] LIKE '%' + @CPI + '%' ";
                    cmd.Parameters.AddWithValue("IM", context.Request["IM"]);
                    cmd.Parameters.AddWithValue("SampleM", context.Request["SampleM"]);
                    cmd.Parameters.AddWithValue("PC", context.Request["PC"]);
                    cmd.Parameters.AddWithValue("S_No", context.Request["S_No"]);
                    cmd.Parameters.AddWithValue("IN", context.Request["IN"]);
                    cmd.Parameters.AddWithValue("SupM", context.Request["SupM"]);
                    cmd.Parameters.AddWithValue("SaleM", context.Request["SaleM"]);
                    cmd.Parameters.AddWithValue("CPI", context.Request["CPI"]);
                    cmd.CommandText += " ORDER BY [Sort] DESC ";
                    break;
                case "Base_P_Search":
                    cmd.CommandText = @" SELECT TOP 500 P.[客戶簡稱], P.[頤坊型號], P.[產品說明], P.[單位], P.[客戶型號], P.[廠商簡稱], P.[廠商編號], C.[產品狀態], C.[銷售型號],
                                                        C.[產品一階], C.[產品二階], C.[產品三階], C.[國際條碼], P.[客戶編號], P.[商標], P.[開發中], P.[序號], P.[更新人員],
                                            CONVERT(VARCHAR(20),C.[停用日期],23) [停用日期],
                                         	LEFT(RTRIM(CONVERT(VARCHAR(20),P.[更新日期],20)),16) [更新日期], P.COST_SEQ, P.[更新日期] [Sort]
                                         FROM Dc2..byrlu P
                                         	INNER JOIN Dc2..suplu C ON P.COST_SEQ = C.[序號]
                                         WHERE P.[頤坊型號] LIKE @IM + '%'
                                            AND 
                                            (   
                                                (LEN(@PC) - LEN(REPLACE(@PC,'-',''))  = 1 AND @PC LIKE C.[產品一階] + '%' AND C.[產品一階] <> '')
                                             OR (LEN(@PC) - LEN(REPLACE(@PC,'-',''))  = 2 AND @PC LIKE C.[產品二階] + '%' AND C.[產品二階] <> '')
                                             OR (LEN(@PC) - LEN(REPLACE(@PC,'-',''))  = 3 AND @PC LIKE C.[產品三階] + '%' AND C.[產品三階] <> '')
                                             OR ISNULL(@PC,'') = ''
                                            )
                                            AND P.[客戶編號] LIKE @C_No + '%'
                                            AND C.[國際條碼] LIKE '%' + @IN + '%'
                                            AND P.[客戶型號] LIKE @CM + '%'
                                            AND C.[銷售型號] LIKE @SaleM + '%'
                                            AND P.[產品說明] LIKE '%' + @PPI + '%' ";
                    cmd.Parameters.AddWithValue("IM", context.Request["IM"]);
                    cmd.Parameters.AddWithValue("PC", context.Request["PC"]);
                    cmd.Parameters.AddWithValue("C_No", context.Request["C_No"]);
                    cmd.Parameters.AddWithValue("IN", context.Request["IN"]);
                    cmd.Parameters.AddWithValue("CM", context.Request["CM"]);
                    cmd.Parameters.AddWithValue("SaleM", context.Request["SaleM"]);
                    cmd.Parameters.AddWithValue("PPI", context.Request["PPI"]);
                    cmd.CommandText += " ORDER BY [Sort] DESC ";
                    break;
            }
            cmd.Connection = conn;
            conn.Open();
            SqlDataReader sdr = cmd.ExecuteReader();
            switch (context.Request["Call_Type"])
            {
                case "Base_C_Search":
                    while (sdr.Read())
                    {
                        Base.Add(new
                        {
                            S_SName = sdr["廠商簡稱"],
                            IM = sdr["頤坊型號"],
                            CPI = sdr["產品說明"],
                            Unit = sdr["單位"],
                            SupM = sdr["廠商型號"],
                            SaleM = sdr["銷售型號"],
                            SampleM = sdr["暫時型號"],
                            PS = sdr["產品狀態"],
                            PC1 = sdr["產品一階"],
                            PC2 = sdr["產品二階"],
                            PC3 = sdr["產品三階"],
                            IN = sdr["國際條碼"],
                            S_No = sdr["廠商編號"],
                            SD = sdr["停用日期"],
                            DVN = sdr["開發中"],
                            SEQ = sdr["序號"],
                            Update_User = sdr["更新人員"],
                            Update_Date = sdr["更新日期"],
                        });
                    }
                    break;
                case "Base_P_Search":
                    while (sdr.Read())
                    {
                        Base.Add(new
                        {
                            C_SName = sdr["客戶簡稱"],
                            IM = sdr["頤坊型號"],
                            PPI = sdr["產品說明"],
                            Unit = sdr["單位"],
                            CM = sdr["客戶型號"],
                            S_SName = sdr["廠商簡稱"],
                            S_No = sdr["廠商編號"],
                            PS = sdr["產品狀態"],
                            PC1 = sdr["產品一階"],
                            PC2 = sdr["產品二階"],
                            PC3 = sdr["產品三階"],
                            IN = sdr["國際條碼"],
                            SD = sdr["停用日期"],
                            C_No = sdr["客戶編號"],
                            Marks = sdr["商標"],
                            DVN = sdr["開發中"],
                            SEQ = sdr["序號"],
                            Update_User = sdr["更新人員"],
                            Update_Date = sdr["更新日期"],
                            Cost_SEQ = sdr["COST_SEQ"],
                        });
                    }
                    break;
            }

            SqlDataAdapter SQL_DA = new SqlDataAdapter(cmd);
            conn.Close();
            SQL_DA.Fill(DT);

            var json = (new JavaScriptSerializer().Serialize(Base));
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
