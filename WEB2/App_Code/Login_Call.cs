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
/// Login_Call 的摘要描述
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// 若要允許使用 ASP.NET AJAX 從指令碼呼叫此 Web 服務，請取消註解下列一行。
[System.Web.Script.Services.ScriptService]
public class Login_Call : System.Web.Services.WebService
{

    public Login_Call()
    {

        //如果使用設計的元件，請取消註解下列一行
        //InitializeComponent(); 
    }


    [WebMethod(EnableSession = true)]
    public string Login_FN(string Login_Account, string Login_Password)
    {
        List<object> Account_Data = new List<object>();
        SqlConnection conn = new SqlConnection();
        conn.ConnectionString = ConfigurationManager.ConnectionStrings["LocalBC2"].ConnectionString;
        SqlCommand cmd = new SqlCommand();
        cmd.CommandText = @" SELECT TOP 1 UPPER(RTRIM([使用者名稱])) [Account], RTRIM([使用者中文]) [Name], RTRIM([密碼]) [Password], IVM_PERMISSIONS, IVMD_PERMISSIONS
                                     FROM Dc2..pass
                                     WHERE UPPER(RTRIM([使用者名稱])) = UPPER(@Account) ";
        cmd.Parameters.AddWithValue("Account", Login_Account);
        //cmd.Parameters.AddWithValue("Login_Account", context.Request["Call_Type"]);
        //cmd.Parameters.AddWithValue("Account", Login_Account.ToUpper());
        cmd.Connection = conn;
        conn.Open();
        SqlDataReader sdr = cmd.ExecuteReader();
        sdr.Read();
        if (!sdr.HasRows)
        {
            return "Account_Not_Exists";
        }
        if (sdr["Password"].ToString() != Login_Password)
        {
            return "Password_Error";
        }
        Account_Data.Add(new
        {
            Response_Account = sdr["Account"],
            Response_Name = sdr["Name"],
            IVM_PERMISSIONS = sdr["IVM_PERMISSIONS"],
            IVMD_PERMISSIONS = sdr["IVMD_PERMISSIONS"]
        });

        Session["Account"] = sdr["Account"];
        Session["Name"] = sdr["Name"];
        Session["IVM_PERMISSIONS"] = sdr["IVM_PERMISSIONS"];
        Session["IVMD_PERMISSIONS"] = sdr["IVMD_PERMISSIONS"];
        conn.Close();

        var json = (new JavaScriptSerializer().Serialize(Account_Data));
        return json;
    }
}
