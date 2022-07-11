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
/// Dialog_DataBind 的摘要描述
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// 若要允許使用 ASP.NET AJAX 從指令碼呼叫此 Web 服務，請取消註解下列一行。
// [System.Web.Script.Services.ScriptService]
public class Dialog_DataBind : System.Web.Services.WebService
{

    public Dialog_DataBind()
    {

        //如果使用設計的元件，請取消註解下列一行
        //InitializeComponent(); 
    }

    [WebMethod]
    public void Customer_Search(string C_No, string C_SName)
    {
        List<object> Customer = new List<object>();
        SqlConnection conn = new SqlConnection();

        conn.ConnectionString = ConfigurationManager.ConnectionStrings["LocalBC2"].ConnectionString;
        SqlCommand cmd = new SqlCommand();

        cmd.CommandText = @" SELECT TOP 100 [序號], [客戶編號], [客戶簡稱], [客戶名稱], [負責人], [email], LEFT([備註],30) + IIF(LEN([備註]) > 30,'...','')  [備註]
                                         FROM Dc2..byr
                                         WHERE [客戶編號] LIKE @C_No + '%' AND [客戶簡稱] LIKE '%' + @C_SName + '%' ";
        cmd.Parameters.AddWithValue("C_No", C_No);
        cmd.Parameters.AddWithValue("C_SName", C_SName);
        cmd.Connection = conn;
        conn.Open();
        SqlDataReader sdr = cmd.ExecuteReader();
        while (sdr.Read())
        {
            Customer.Add(new
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
        conn.Close();
        var json = (new JavaScriptSerializer().Serialize(Customer));
        Context.Response.Write(json);
    }

    [WebMethod]
    public void Supplier_Search(string S_No, string S_SName)
    {
        List<object> Supplier = new List<object>();
        SqlConnection conn = new SqlConnection();

        conn.ConnectionString = ConfigurationManager.ConnectionStrings["LocalBC2"].ConnectionString;
        SqlCommand cmd = new SqlCommand();
        cmd.CommandText = @" SELECT TOP 100 [序號], [開發中], [廠商編號], [廠商簡稱], [連絡人採購], [電話], [公司地址]
                                         FROM Dc2..sup
                                         WHERE [廠商編號] LIKE @S_No + '%' AND [廠商簡稱] LIKE '%' + @S_SName + '%'
                                         ORDER BY [更新日期] DESC ";
        cmd.Parameters.AddWithValue("S_No", S_No);
        cmd.Parameters.AddWithValue("S_SName", S_SName);
        cmd.Connection = conn;
        conn.Open();
        SqlDataReader sdr = cmd.ExecuteReader();
        while (sdr.Read())
        {
            Supplier.Add(new
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
        conn.Close();
        var json = (new JavaScriptSerializer().Serialize(Supplier));
        Context.Response.Write(json);
        //return json;//return > <string xmlns="http://tempuri.org/">
    }

    [WebMethod]
    public void Transfer_Search(string S_No, string S_Type)
    {
        List<object> Supplier = new List<object>();
        SqlConnection conn = new SqlConnection();

        conn.ConnectionString = ConfigurationManager.ConnectionStrings["LocalBC2"].ConnectionString;
        SqlCommand cmd = new SqlCommand();
        cmd.CommandText = @" SELECT TOP 100 [運輸編號], [運輸簡稱]
                             FROM Dc2..TRF
                             WHERE [運輸編號] LIKE @S_No + '%' 
                             AND 運輸區分 Like '%' + @S_Type + '%'
                             AND 停用日期 IS NULL
                             ORDER BY [更新日期] DESC 
                           ";
        cmd.Parameters.AddWithValue("S_No", S_No);
        cmd.Parameters.AddWithValue("S_Type", S_Type);

        cmd.Connection = conn;
        conn.Open();
        SqlDataReader sdr = cmd.ExecuteReader();
        while (sdr.Read())
        {
            Supplier.Add(new
            {
                S_No = sdr["運輸編號"],
                S_S_Name = sdr["運輸簡稱"]
            });
        }
        conn.Close();
        var json = (new JavaScriptSerializer().Serialize(Supplier));
        Context.Response.Write(json);
    }
}
