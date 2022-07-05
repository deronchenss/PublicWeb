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
/// DDL_DataBind 的摘要描述
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// 若要允許使用 ASP.NET AJAX 從指令碼呼叫此 Web 服務，請取消註解下列一行。
[System.Web.Script.Services.ScriptService]
public class DDL_DataBind : System.Web.Services.WebService
{

    public DDL_DataBind()
    {
        //如果使用設計的元件，請取消註解下列一行
        //InitializeComponent(); 
    }

    [WebMethod]
    public string Product_Status()
    {
        List<object> PS = new List<object>();
        SqlConnection conn = new SqlConnection();
        conn.ConnectionString = ConfigurationManager.ConnectionStrings["LocalBC2"].ConnectionString;
        SqlCommand cmd = new SqlCommand();

        cmd.CommandText = @" SELECT RTRIM([內容]) [txt], RTRIM(LEFT([內容],2)) [val] FROM Bc2..Refdata WHERE [代碼] = '產品狀態' order by 1 ";
        cmd.Connection = conn;
        conn.Open();
        SqlDataReader sdr = cmd.ExecuteReader();

        while (sdr.Read())
        {
            PS.Add(new
            {
                txt = sdr["txt"],
                val = sdr["val"]
            });
        }
        conn.Close();
        var json = (new JavaScriptSerializer().Serialize(PS));
        return json;
    }
    [WebMethod]
    public string Design_Person()
    {
        List<object> DP = new List<object>();
        SqlConnection conn = new SqlConnection();
        conn.ConnectionString = ConfigurationManager.ConnectionStrings["LocalBC2"].ConnectionString;
        SqlCommand cmd = new SqlCommand();
        cmd.CommandText = @" SELECT [序號] [SEQ], [使用者中文] [val], [使用者中文] + ' ' + [使用者名稱] [txt]
                             FROM Dc2..pass
                             WHERE [部門] LIKE '%設計部' AND [停用日期] IS NULL
                             ORDER BY 1 ";
        cmd.Connection = conn;
        conn.Open();
        SqlDataReader sdr = cmd.ExecuteReader();
        while (sdr.Read())
        {
            DP.Add(new
            {
                txt = sdr["txt"],
                val = sdr["val"]
            });
        }
        conn.Close();
        var json = (new JavaScriptSerializer().Serialize(DP));
        return json;
    }
    [WebMethod]
    public string Customer_Trademark()
    {
        List<object> CT = new List<object>();
        SqlConnection conn = new SqlConnection();
        conn.ConnectionString = ConfigurationManager.ConnectionStrings["LocalBC2"].ConnectionString;
        SqlCommand cmd = new SqlCommand();
        cmd.CommandText = @" SELECT RTRIM([內容]) [txt] FROM Dc2..Refdata Where [代碼] = '商標' Order By 1 ";
        cmd.Connection = conn;
        conn.Open();
        SqlDataReader sdr = cmd.ExecuteReader();
        while (sdr.Read())
        {
            CT.Add(new
            {
                txt = sdr["txt"]
            });
        }
        conn.Close();
        var json = (new JavaScriptSerializer().Serialize(CT));
        return json;
    }

    [WebMethod]
    public string Product_Class()
    {
        List<object> CT = new List<object>();
        SqlConnection conn = new SqlConnection();
        conn.ConnectionString = ConfigurationManager.ConnectionStrings["LocalBC2"].ConnectionString;
        SqlCommand cmd = new SqlCommand();
        cmd.CommandText = @" SELECT CASE ( LEN(RTRIM([內容])) - LEN(REPLACE(RTRIM([內容]),'-','')) ) 
                             	        WHEN '2' THEN '&nbsp;&nbsp;&nbsp;&nbsp;'
                             	        WHEN '3' THEN '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'
                             	        ELSE '' END + RTRIM([內容]) [txt], RTRIM([內容]) [val]
                             FROM Dc2..refdata WHERE [代碼] LIKE '產品分類%階' 
                             ORDER BY [內容] ";
        cmd.Connection = conn;
        conn.Open();
        SqlDataReader sdr = cmd.ExecuteReader();
        while (sdr.Read())
        {
            CT.Add(new
            {
                txt = sdr["txt"],
                val = sdr["val"]
            });
        }
        conn.Close();
        var json = (new JavaScriptSerializer().Serialize(CT));
        return json;
    }
}
