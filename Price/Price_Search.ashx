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
                case "Cost1_Search":
                    cmd.CommandText = @" SELECT TOP 500 [頤坊型號], [廠商型號], [廠商編號], [廠商簡稱], [暫時型號], [單位], 
                                                                [台幣單價], [美元單價], [外幣幣別], [外幣單價], [MIN_1], 
                                                                LEFT(RTRIM(CONVERT(VARCHAR(20),[最後單價日],20)),16) [最後單價日],
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

            }
            cmd.Connection = conn;
            conn.Open();
            SqlDataReader sdr = cmd.ExecuteReader();
            switch (context.Request["Call_Type"])
            {
                case "Cost1_Search":
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
