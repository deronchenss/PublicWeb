<%@ WebHandler Language="C#" Class="UC_Search" %>

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


public class UC_Search : IHttpHandler, IRequiresSessionState
{
    public void ProcessRequest(HttpContext context)
    {
        DataTable DT = new DataTable();

        if (!string.IsNullOrEmpty(context.Request["Call_Type"]))
        {
            List<object> LT = new List<object>();
            SqlConnection conn = new SqlConnection();
            conn.ConnectionString = ConfigurationManager.ConnectionStrings["LocalBC2"].ConnectionString;
            SqlCommand cmd = new SqlCommand();
            switch (context.Request["Call_Type"])
            {
                case "Supplier_Search":
                    cmd.CommandText = @" SELECT TOP 100 [序號], [開發中], [廠商編號], [廠商簡稱], [連絡人採購], [電話], [公司地址]
                                         FROM Dc2..sup
                                         WHERE [廠商編號] LIKE @S_No + '%' AND [廠商簡稱] LIKE '%' + @S_SName + '%'
                                         ORDER BY [更新日期] DESC ";
                    cmd.Parameters.AddWithValue("S_No", context.Request["S_No"]);
                    cmd.Parameters.AddWithValue("S_SName", context.Request["S_SName"]);
                    break;
                case "Product_Search":
                    cmd.CommandText = @" SELECT TOP 100 [序號], [開發中], [頤坊型號], [廠商編號], [廠商簡稱], [單位], [產品說明]
                                         FROM Dc2..suplu
                                         WHERE [頤坊型號] LIKE @IM + '%' AND [廠商編號] LIKE '%' + @S_No + '%'
                                         ORDER BY [更新日期] DESC ";
                    cmd.Parameters.AddWithValue("IM", context.Request["IM"]);
                    cmd.Parameters.AddWithValue("S_No", context.Request["S_No"]);
                    break;                        
                case "Customer_Search":
                    cmd.CommandText = @" SELECT TOP 100 [序號], [客戶編號], [客戶簡稱], [客戶名稱], [負責人], [email], LEFT([備註],30) + IIF(LEN([備註]) > 30,'...','')  [備註]
                                         FROM Dc2..byr
                                         WHERE [客戶編號] LIKE @C_No + '%' AND [客戶簡稱] LIKE '%' + @C_SName + '%' ";
                    cmd.Parameters.AddWithValue("C_No", context.Request["C_No"]);
                    cmd.Parameters.AddWithValue("C_SName", context.Request["C_SName"]);
                    break;
            }
            cmd.Connection = conn;
            conn.Open();
            SqlDataReader sdr = cmd.ExecuteReader();
            switch (context.Request["Call_Type"])
            {
                case "Supplier_Search":
                    while (sdr.Read())
                    {
                        LT.Add(new
                        {
                            SEQ = sdr["序號"],
                            DVN = sdr["開發中"],
                            S_No = sdr["廠商編號"],
                            S_SName = sdr["廠商簡稱"],
                            Purchase_Person = sdr["連絡人採購"],
                            TEL = sdr["電話"],
                            Address = sdr["公司地址"],
                        });
                    }
                    break;
                case "Product_Search":
                    while (sdr.Read())
                    {
                        LT.Add(new
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
                case "Customer_Search":
                    while (sdr.Read())
                    {
                        LT.Add(new
                        {
                            SEQ = sdr["序號"],
                            C_No = sdr["客戶編號"],
                            C_SName = sdr["客戶簡稱"],
                            C_Name = sdr["客戶名稱"],
                            Principal = sdr["負責人"],
                            Mail = sdr["email"],
                            Remark = sdr["備註"],
                        });
                    }
                    break;
            }
            SqlDataAdapter SQL_DA = new SqlDataAdapter(cmd);
            conn.Close();
            SQL_DA.Fill(DT);

            var json = (new JavaScriptSerializer().Serialize(LT));
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
