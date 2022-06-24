<%@ WebHandler Language="C#" Class="Price_Search" %>

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


public class Price_Search : IHttpHandler, IRequiresSessionState
{
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
                case "Price_MT_Search":
                    cmd.CommandText = @" SELECT TOP 500 [客戶型號], [頤坊型號], [開發中], [客戶簡稱], [美元單價], [廠商簡稱], [單位], [MIN_1], 
                                         	CONVERT(VARCHAR(20),[最後單價日],23) [最後單價日], 
                                         	REPLACE(CONVERT(VARCHAR(40),CAST([台幣單價] AS MONEY),1),'.00','') [台幣單價], 
                                         	CONVERT(VARCHAR(20),[停用日期],23) [停用日期], 
                                         	[產品說明], [廠商編號], [客戶編號], [序號], [更新人員], 
                                         	LEFT(RTRIM(CONVERT(VARCHAR(20),[更新日期],20)),16) [更新日期], [更新日期] [Sort], P_SEQ
                                         FROM Dc2..byrlu
                                         WHERE 1=1 ";
                    if (!string.IsNullOrEmpty(context.Request["Search_Where"]))
                    {
                        cmd.CommandText += " AND " + context.Request["Search_Where"];
                    }
                    cmd.CommandText += " ORDER BY [Sort] DESC ";
                    break;
                case "Price_MT_Selected":
                    cmd.CommandText = @" SELECT TOP 1 [序號], [開發中], [商標], [客戶型號], 
                                         	CONVERT(VARCHAR(20),[最後單價日],23) [最後單價日], 
                                         	CONVERT(VARCHAR(20),[停用日期],23) [停用日期], 
                                         	[客戶編號], [客戶簡稱], [頤坊型號], [單位], [廠商編號], [廠商簡稱], [產品說明], 
                                         	REPLACE(CONVERT(VARCHAR(40),CAST([台幣單價] AS MONEY),1),'.00','') [台幣單價], 
                                         	[美元單價], [單價_2], [單價_3], [單價_4], [MIN_1], [MIN_2], [MIN_3], [MIN_4], [更新人員], 
                                         	LEFT(RTRIM(CONVERT(VARCHAR(20),[更新日期],20)),16) [更新日期], [備註],
                                         	(SELECT TOP 1 b.[圖檔] FROM [192.168.1.135].Pic.dbo.xpic b WHERE b.P_SEQ = P.[序號]) [IMG]
                                         FROM Dc2..byrlu P
                                         WHERE [序號] = @SEQ ";
                    cmd.Parameters.AddWithValue("SEQ", context.Request["SEQ"]);
                    break;
            }
            cmd.Connection = conn;
            conn.Open();
            SqlDataReader sdr = cmd.ExecuteReader();
            switch (context.Request["Call_Type"])
            {
                case "Price_MT_Search":
                    while (sdr.Read())
                    {
                        Cost.Add(new
                        {
                            CM = sdr["客戶型號"],
                            IM = sdr["頤坊型號"],
                            DVN = sdr["開發中"],
                            C_SName = sdr["客戶簡稱"],
                            USD_P = sdr["美元單價"],
                            S_SName = sdr["廠商簡稱"],
                            Unit = sdr["單位"],
                            MIN_1 = sdr["MIN_1"],
                            LSTP_Day = sdr["最後單價日"],
                            TWD_P = sdr["台幣單價"],
                            SDate = sdr["停用日期"],
                            PI = sdr["產品說明"],
                            S_No = sdr["廠商編號"],
                            C_No = sdr["客戶編號"],
                            SEQ = sdr["序號"],
                            Update_User = sdr["更新人員"],
                            Update_Date = sdr["更新日期"],
                            P_SEQ = sdr["P_SEQ"],
                        });
                    }
                    break;
                case "Price_MT_Selected":
                    while (sdr.Read())
                    {
                        Cost.Add(new
                        {
                            SEQ = sdr["序號"],
                            DVN = sdr["開發中"],
                            TM = sdr["商標"],
                            CM = sdr["客戶型號"],
                            LSPD = sdr["最後單價日"],
                            SD = sdr["停用日期"],
                            C_No = sdr["客戶編號"],
                            C_SName = sdr["客戶簡稱"],
                            IM = sdr["頤坊型號"],
                            Unit = sdr["單位"],
                            S_No = sdr["廠商編號"],
                            S_SName = sdr["廠商簡稱"],
                            PI = sdr["產品說明"],
                            TWD_P = sdr["台幣單價"],
                            USD_P = sdr["美元單價"],
                            P_2 = sdr["單價_2"],
                            P_3 = sdr["單價_3"],
                            P_4 = sdr["單價_4"],
                            MIN_1 = sdr["MIN_1"],
                            MIN_2 = sdr["MIN_2"],
                            MIN_3 = sdr["MIN_3"],
                            MIN_4 = sdr["MIN_4"],
                            Update_User = sdr["更新人員"],
                            Update_Date = sdr["更新日期"],
                            Remark = sdr["備註"],
                            IMG = sdr["IMG"],
                        });
                    }
                    break;
            }

            SqlDataAdapter SQL_DA = new SqlDataAdapter(cmd);
            conn.Close();
            SQL_DA.Fill(DT);

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
