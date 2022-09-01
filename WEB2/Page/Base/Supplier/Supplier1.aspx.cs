using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Data.SqlClient;
using System.Web.Configuration;
using System.Data;

public partial class Supplier1 : System.Web.UI.Page
{
    //SqlConnection LocalBC2 = new SqlConnection(WebConfigurationManager.ConnectionStrings["LocalBC2"].ConnectionString.ToString());
    protected void Page_Load(object sender, EventArgs e)
    {
        if(!IsPostBack)
        {
            //GV_BIND_DATA();
        }
    }
    //protected void BT_Search_Click(object sender, EventArgs e)
    //{
    //    GV_BIND_DATA();
    //}
    //public void GV_BIND_DATA()
    //{
    //    string SQL_STR = @" SELECT TOP 20 [廠商編號], [廠商簡稱], [電話], [傳真], [連絡人採購], [連絡人開發], [負責人], [所在地], [國名], [注音], [行動電話], [公司地址], [工廠地址], [序號], [更新人員], 
    //                                LEFT(RTRIM(CONVERT(VARCHAR(20),[更新日期],20)),16) [更新日期]
    //                            , [廠商名稱], [統一編號], [付款條件], [網站], [email開發], [email採購], [裝配品寄送地址]
    //                            FROM Bc2..sup
    //                            WHERE 1 = 1 ";
        
    //    SqlCommand cmd = new SqlCommand(SQL_STR, LocalBC2);
    //    //GV_BIND_DATA();

    //    //string TB_Search_S_NO_Text = ((HtmlInputText)Page.FindControl("TB_Search_S_NO")).Value;
    //    //if (!string.IsNullOrEmpty(TB_Search_S_NO_Text)) 
    //    //{
    //    //    cmd.CommandText += " AND [廠商編號] LIKE '%' + @S_NO + '%' ";
    //    //    cmd.Parameters.AddWithValue("S_NO", TB_Search_S_NO_Text);
    //    //}

    //    //cmd.CommandText += " AND [電話] LIKE '%' + @S_Tel + '%' ";
    //    //cmd.CommandText += " AND [國名] LIKE '%' + @Nation + '%' ";
    //    //cmd.CommandText += " AND [傳真] LIKE '%' + @FAX + '%' ";
    //    //cmd.CommandText += " AND ( [公司地址] LIKE '%' + @Address + '%' OR [工廠地址] LIKE '%' + @Address + '%' )";


    //    //"S_NO": $('#TB_Search_S_NO').val(),
    //    //                    "S_Tel": $('#TB_Search_S_Tel').val(),
    //    //                    "Nation": $('#TB_Search_Nation').val(),
    //    //                    "FAX": $('#TB_Search_FAX').val(),
    //    //                    "Address": $('#TB_Search_Address').val(),
    //    //                    "Call_Type" : "BT_Serach"

    //    //cmd.Parameters.AddWithValue("S_Tel", context.Request["S_Tel"]);
    //    //cmd.Parameters.AddWithValue("Nation", context.Request["Natopn"]);
    //    //cmd.Parameters.AddWithValue("FAX", context.Request["FAX"]);
    //    //cmd.Parameters.AddWithValue("Address", context.Request["Address"]);

    //    SqlDataAdapter SQL_DA = new SqlDataAdapter(cmd);
    //    DataTable DT = new DataTable();
    //    SQL_DA.Fill(DT);


    //    GV_Supplier.DataSource = DT;
    //    GV_Supplier.DataBind();
    //}

    #region GV_Event
    //protected void GV_Supplier_RowCommand(object sender, GridViewCommandEventArgs e)
    //{

    //}

    //protected void GV_Supplier_RowDataBound(object sender, GridViewRowEventArgs e)
    //{

    //}

    //protected void GV_Supplier_PageIndexChanging(object sender, GridViewPageEventArgs e)
    //{
    //    GV_Supplier.PageIndex = e.NewPageIndex;
    //    GV_BIND_DATA();
    //}
    #endregion




}