using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.Script.Services;
using System.Web.Script.Serialization;

/// <summary>
/// AutoComplete 的摘要描述
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// 若要允許使用 ASP.NET AJAX 從指令碼呼叫此 Web 服務，請取消註解下列一行。
[System.Web.Script.Services.ScriptService]
public class AutoComplete : System.Web.Services.WebService
{

    public AutoComplete()
    {

        //如果使用設計的元件，請取消註解下列一行
        //InitializeComponent(); 
    }


    [WebMethod]
    public string Serach_Supplier_No_Name(string S_No)
    {
        List<object> supplier = new List<object>();
        SqlConnection conn = new SqlConnection();

        conn.ConnectionString = ConfigurationManager.ConnectionStrings["LocalBC2"].ConnectionString;
        SqlCommand cmd = new SqlCommand();
        cmd.CommandText = @" SELECT TOP 15 RTRIM(CAST([廠商編號] AS VARCHAR(MAX))) [S_No], RTRIM(CAST([廠商簡稱] AS VARCHAR(MAX))) [S_Name]
                             FROM Bc2..sup
                             WHERE [廠商編號] LIKE '%' +  @S_No + '%' OR [廠商簡稱] LIKE '%' + @S_No + '%' ";
        cmd.Parameters.AddWithValue("S_No", S_No);
        cmd.Connection = conn;
        conn.Open();
        SqlDataReader sdr = cmd.ExecuteReader();
        while (sdr.Read())
        {
            supplier.Add(new
            {
                S_No = sdr["S_No"],
                S_Name = sdr["S_Name"]
            });
        }
        conn.Close();
        var json = (new JavaScriptSerializer().Serialize(supplier));
        return json;
    }


    [WebMethod]
    public string Serach_Customer_No_Name(string C_No)
    {
        List<object> customer = new List<object>();
        SqlConnection conn = new SqlConnection();
        conn.ConnectionString = ConfigurationManager.ConnectionStrings["LocalBC2"].ConnectionString;
        //to_Dc2
        SqlCommand cmd = new SqlCommand();
        cmd.CommandText = @" SELECT TOP 15 RTRIM(CAST([客戶編號] AS VARCHAR(MAX))) [C_No], RTRIM(CAST([客戶簡稱] AS VARCHAR(MAX))) [C_Name]
                                     FROM Dc2..byr
                                     WHERE [客戶編號] LIKE '%' +  @C_No + '%' OR [客戶簡稱] LIKE '%' + @C_No + '%' ";
        cmd.Parameters.AddWithValue("C_No", C_No);
        cmd.Connection = conn;
        conn.Open();
        SqlDataReader sdr = cmd.ExecuteReader();
        while (sdr.Read())
        {
            customer.Add(new
            {
                C_No = sdr["C_No"],
                C_Name = sdr["C_Name"]
            });
        }
        conn.Close();
        var json = (new JavaScriptSerializer().Serialize(customer));
        return json;
    }

    [WebMethod]
    public string Serach_Ivan_Model(string IM)
    {
        List<object> Product = new List<object>();
        SqlConnection conn = new SqlConnection();
        conn.ConnectionString = ConfigurationManager.ConnectionStrings["LocalBC2"].ConnectionString;
        SqlCommand cmd = new SqlCommand();
        cmd.CommandText = @" SELECT DISTINCT TOP 15 RTRIM(CAST([頤坊型號] AS VARCHAR(MAX))) [IM], RTRIM(CAST([產品說明] AS NVARCHAR(MAX))) [PI]
                             FROM Dc2..suplu
                             WHERE [頤坊型號] LIKE @IM + '%'
                             order by 1 ";
        cmd.Parameters.AddWithValue("IM", IM);
        cmd.Connection = conn;
        conn.Open();
        SqlDataReader sdr = cmd.ExecuteReader();
        while (sdr.Read())
        {
            Product.Add(new
            {
                IM = sdr["IM"],
                PI = sdr["PI"]
            });
        }
        conn.Close();
        var json = (new JavaScriptSerializer().Serialize(Product));
        return json;
    }

    [WebMethod]
    public string Serach_Nation(string Nation)
    {
        List<object> LN = new List<object>();
        SqlConnection conn = new SqlConnection();
        conn.ConnectionString = ConfigurationManager.ConnectionStrings["LocalBC2"].ConnectionString;
        //to_Dc2

        SqlCommand cmd = new SqlCommand();
        cmd.CommandText = @" SELECT TOP 15 RTRIM(內容) [Nation] FROM Bc2..REFDATA
                                     WHERE [代碼] = '國別' AND [內容] LIKE '%' + @Nation + '%'
                                     ORDER BY 1 ";
        cmd.Parameters.AddWithValue("Nation", Nation);
        cmd.Connection = conn;
        conn.Open();
        SqlDataReader sdr = cmd.ExecuteReader();
        while (sdr.Read())
        {
            LN.Add(new
            {
                Nation = sdr["Nation"]
            });
        }
        conn.Close();
        var json = (new JavaScriptSerializer().Serialize(LN));
        return json;
    }
    /* 字串回傳
    [WebMethod]
    public string[] Serach_Supplier_No_Name(string S_No)
    {
        //List<object> supplier = new List<object>();
        List<string> supplier = new List<string>();
        using (SqlConnection conn = new SqlConnection())
        {
            conn.ConnectionString = ConfigurationManager.ConnectionStrings["LocalBC2"].ConnectionString;
            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.CommandText = @" SELECT TOP 10 RTRIM(CAST([廠商編號] AS VARCHAR(MAX))) + ' :|: ' + RTRIM(CAST([廠商簡稱] AS VARCHAR(MAX))) [S_NoName]
                                     FROM Bc2..sup
                                     WHERE [廠商編號] LIKE '%' +  @S_NO + '%' ";
                cmd.Parameters.AddWithValue("S_No", S_No);
                cmd.Connection = conn;
                conn.Open();
                using (SqlDataReader sdr = cmd.ExecuteReader())
                {
                    while (sdr.Read())
                    {
                        supplier.Add(sdr["S_NoName"].ToString());
                    }
                }
                conn.Close();
            }
            return supplier.ToArray();
            //return (new JavaScriptSe0rializer().Serialize(supplier));
        }
    }
    */

}
