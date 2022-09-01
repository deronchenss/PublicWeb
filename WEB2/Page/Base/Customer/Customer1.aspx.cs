using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Configuration;
using System.Data;
using System.Data.SqlClient;

public partial class Customer1 : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        //string SQL_STR = @" SELECT IVMD_PERMISSIONS
        //                    FROM Dc2..pass
        //                    WHERE 使用者名稱 = @User ";

        //SqlCommand SQL_CMD = new SqlCommand(SQL_STR, new SqlConnection(WebConfigurationManager.ConnectionStrings["LocalBC2"].ConnectionString.ToString()));

        //string User_ID = "Fatial";
        //if (Request.Cookies.Get("SE") != null)
        //{
        //    User_ID = Request.Cookies.Get("SE").Value;
        //}
        //SQL_CMD.Parameters.AddWithValue("User", User_ID);
        //SqlDataAdapter SQL_DA = new SqlDataAdapter(SQL_CMD);
        //DataTable DT = new DataTable();
        //SQL_DA.Fill(DT);

        //HttpCookie cookie = new HttpCookie("IVMD_PERMISSIONS");
        //cookie.Value = DT.Rows[0][0].ToString();
        //Response.Cookies.Add(cookie);
    }
}