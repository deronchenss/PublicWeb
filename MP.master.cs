using System;
using System.Collections.Generic;
using System.Configuration;
using System.Web.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class MP : System.Web.UI.MasterPage
{
    protected void Page_Load(object sender, EventArgs e)
    {

        if (Request.Cookies.Get("Language") != null) 
        {
            Page.UICulture = Request.Cookies.Get("Language").Value;
        }

        //if (Session["Account"] == null)
        //{
        //    Response.Write("<script type='text/javascript'>alert('Timeout, Please re-login.')</script>");
        //    Response.Redirect("~/Login.aspx",false);
        //}
        //Demo中，正式上線必須權限


        /*
        string SQL_STR = @" SELECT IVM_PERMISSIONS
                                     FROM Dc2..pass
                                     WHERE 使用者名稱 = @User ";
        SqlCommand SQL_CMD = new SqlCommand(SQL_STR, new SqlConnection(WebConfigurationManager.ConnectionStrings["LocalBC2"].ConnectionString.ToString()));


        string User_ID = "Fatial";
        if (Request.Cookies.Get("SE") != null)
        {
            User_ID = Request.Cookies.Get("SE").Value;
        }

        SQL_CMD.Parameters.AddWithValue("User",  User_ID);

        SqlDataAdapter SQL_DA = new SqlDataAdapter(SQL_CMD);

        DataTable DT = new DataTable();
        SQL_DA.Fill(DT);
        //Page.UICulture. = DT.ToString();

        HttpCookie cookie = new HttpCookie("IVM_PERMISSIONS");
        //設定單值
        cookie.Value = DT.Rows[0][0].ToString();
        //設定過期日
        //cookie.Expires = DateTime.Now.AddDays(2);
        //寫到用戶端
        Response.Cookies.Add(cookie);
        */


        //Request.Cookies.Set("IVM_PERMISSIONS")  .Get("Language")
        //if (Request.Cookies.Get("Language") != null)
        //{
        //    Page.UICulture = Request.Cookies.Get("Language").Value;
        //}




        //var Cookie_Language = Request.Cookies.Get("Language").Value;
        //if (!string.IsNullOrEmpty(Cookie_Language))
        //{
        //    Page.UICulture = Cookie_Language;
        //}


        //HttpContext.Current.Response.Cookies.Remove("Language");
        //HttpContext.Current.Response.Cookies.Add(Cookie);


        //if (ViewState["Language"] != null){
        //    this.Page.UICulture = ViewState["Language"].ToString().Trim();
        //}


    }
}
