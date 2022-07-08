<%@ WebHandler Language="C#" Class="Customer_Save" %>

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

public class Customer_Save : IHttpHandler, IRequiresSessionState
{
    public void ProcessRequest(HttpContext context)
    {
        //DataTable DT = new DataTable();

        if (!string.IsNullOrEmpty(context.Request["Call_Type"]))
        {
            List<object> supplier = new List<object>();
            SqlConnection conn = new SqlConnection();
            conn.ConnectionString = ConfigurationManager.ConnectionStrings["LocalBC2"].ConnectionString;
            SqlCommand cmd = new SqlCommand();
            switch (context.Request["Call_Type"])
            {
                case "Customer_MT_New":
                    cmd.CommandText = @" INSERT INTO Dc2..byr
                                         ( [序號], 
                                           [客戶編號], [客戶簡稱], [客戶名稱], [負責人], [國名], [報價等級], [付款方式], 
                                           [價格條件], [連絡人大貨], [連絡人樣品], [電話], [傳真], [網站], [EMAIL], [emailEDM], 
                                           [公司地址], [工廠地址], [送貨地址], [幣別], [帳齡海運], [帳齡非海運], [IV列印地址], 
                                           [初接觸日], [客戶來源], [參考號碼], [更新人員])
                                         SELECT 
                                           [序號] = (SELECT COALESCE(MAX([序號]),0) + 1 FROM Dc2..byr),
                                           [客戶編號] = @C_No, 
                                           [客戶簡稱] = @C_SName, 
                                           [客戶名稱] = @C_Name, 
                                           [負責人] = @Principal, 
                                           [國名] = @Nation, 
                                           [報價等級] = LEFT(@Quote_Class,1), 
                                           [付款方式] = @Payment_Terms, 
                                           [價格條件] = @Price_Condition, 
                                           [連絡人大貨] = @Person_Commodity, 
                                           [連絡人樣品] = @Person_Sample, 
                                           [電話] = @Tel,
                                           [傳真] = @Fax, 
                                           [網站] = @Web, 
                                           [EMAIL] = @Mail, 
                                           [emailEDM] = @MailEDM, 
                                           [公司地址] = @Company_Address,
                                           [工廠地址] = @Factory_Address, 
                                           [送貨地址] = @Delivery_Address,
                                           [幣別] = @Currency, 
                                           [帳齡海運] = 30, 
                                           [帳齡非海運] = 30, 
                                           [IV列印地址] = @IV_Address, 
                                           [初接觸日] = CONVERT(VARCHAR(10),GETDATE(),23), 
                                           [客戶來源] = @Costomer_Source,
                                           [參考號碼] = @Reference_Number, 
                                           [更新人員] = 'Ivan10'; ";
                    cmd.Parameters.AddWithValue("C_No", context.Request["C_No"]);
                    cmd.Parameters.AddWithValue("C_SName", context.Request["C_SName"]);
                    cmd.Parameters.AddWithValue("C_Name", context.Request["C_Name"]);
                    cmd.Parameters.AddWithValue("Principal", context.Request["Principal"]);
                    cmd.Parameters.AddWithValue("Nation", context.Request["Nation"]);
                    cmd.Parameters.AddWithValue("Quote_Class", context.Request["Quote_Class"]);
                    cmd.Parameters.AddWithValue("Payment_Terms", context.Request["Payment_Terms"]);
                    cmd.Parameters.AddWithValue("Price_Condition", context.Request["Price_Condition"]);
                    cmd.Parameters.AddWithValue("Person_Commodity", context.Request["Person_Commodity"]);
                    cmd.Parameters.AddWithValue("Person_Sample", context.Request["Person_Sample"]);
                    cmd.Parameters.AddWithValue("Tel", context.Request["Tel"]);
                    cmd.Parameters.AddWithValue("Fax", context.Request["Fax"]);
                    cmd.Parameters.AddWithValue("Web", context.Request["Web"]);
                    cmd.Parameters.AddWithValue("Mail", context.Request["Mail"]);
                    cmd.Parameters.AddWithValue("MailEDM", context.Request["MailEDM"]);
                    cmd.Parameters.AddWithValue("Company_Address", context.Request["Company_Address"]);
                    cmd.Parameters.AddWithValue("Factory_Address", context.Request["Factory_Address"]);
                    cmd.Parameters.AddWithValue("Delivery_Address", context.Request["Delivery_Address"]);
                    cmd.Parameters.AddWithValue("Currency", context.Request["Currency"]);
                    cmd.Parameters.AddWithValue("IV_Address", context.Request["IV_Address"]);
                    cmd.Parameters.AddWithValue("Costomer_Source", context.Request["Costomer_Source"]);
                    cmd.Parameters.AddWithValue("Reference_Number", context.Request["Reference_Number"]);
                    break;

                case "Customer_MT_Update":
                    cmd.CommandText = @" UPDATE Dc2..byr
                                         SET [客戶編號] = @C_No,
	                                         [客戶簡稱] = @C_SName,
	                                         [客戶名稱] = @C_Name,
	                                         [國名] = @Nation,
	                                         [報價等級] = @Quote_Class,
	                                         [付款方式] = @Payment_Terms,
	                                         [連絡人大貨] = @Person_Commodity,
	                                         [連絡人樣品] = @Person_Sample,
	                                         [電話] = @Tel,
	                                         [傳真] = @Fax,
	                                         [統一編號] = @EIN,
	                                         [網站] = @Web,
	                                         [Email] = @Mail,
	                                         [價格條件] = @Price_Condition,
	                                         [公司地址] = @Company_Address,
	                                         [工廠地址] = @Factory_Address,
	                                         [送貨地址] = @Delivery_Address,
	                                         [備註] = @Remark,
	                                         --[郵件群組] = @Mail_Group,
	                                         --[發貨中心使用] = @Center_Use,
	                                         [幣別] = @Currency,
	                                         [負責人] = @Principal,
	                                         [emailEDM] = @MailEDM,
	                                         [IV列印地址] = @IV_Address,
	                                         [出貨備註] = @Shipping_Notes,
	                                         [更新人員] = 'Ivan10',
	                                         [更新日期] = GETDATE()
                                         WHERE [序號] = @SEQ ";
                    cmd.Parameters.AddWithValue("SEQ", context.Request["SEQ"]);
                    cmd.Parameters.AddWithValue("C_No", context.Request["C_No"]);
                    cmd.Parameters.AddWithValue("C_SName", context.Request["C_SName"]);
                    cmd.Parameters.AddWithValue("C_Name", context.Request["C_Name"]);
                    cmd.Parameters.AddWithValue("Nation", context.Request["Nation"]);
                    cmd.Parameters.AddWithValue("Quote_Class", context.Request["Quote_Class"]);
                    cmd.Parameters.AddWithValue("Payment_Terms", context.Request["Payment_Terms"]);
                    cmd.Parameters.AddWithValue("Person_Commodity", context.Request["Person_Commodity"]);
                    cmd.Parameters.AddWithValue("Person_Sample", context.Request["Person_Sample"]);
                    cmd.Parameters.AddWithValue("Tel", context.Request["Tel"]);
                    cmd.Parameters.AddWithValue("Fax", context.Request["Fax"]);
                    cmd.Parameters.AddWithValue("EIN", context.Request["EIN"]);
                    cmd.Parameters.AddWithValue("Web", context.Request["Web"]);
                    cmd.Parameters.AddWithValue("Mail", context.Request["Mail"]);
                    cmd.Parameters.AddWithValue("Price_Condition", context.Request["Price_Condition"]);
                    cmd.Parameters.AddWithValue("Company_Address", context.Request["Company_Address"]);
                    cmd.Parameters.AddWithValue("Factory_Address", context.Request["Factory_Address"]);
                    cmd.Parameters.AddWithValue("Delivery_Address", context.Request["Delivery_Address"]);
                    cmd.Parameters.AddWithValue("Remark", context.Request["Remark"]);

                    //cmd.Parameters.AddWithValue("Mail_Group", context.Request["Mail_Group"]);
                    //cmd.Parameters.AddWithValue("Center_Use", context.Request["Center_Use"]);

                    cmd.Parameters.AddWithValue("Currency", context.Request["Currency"]);
                    cmd.Parameters.AddWithValue("Principal", context.Request["Principal"]);
                    cmd.Parameters.AddWithValue("MailEDM", context.Request["MailEDM"]);
                    cmd.Parameters.AddWithValue("IV_Address", context.Request["IV_Address"]);
                    cmd.Parameters.AddWithValue("Shipping_Notes", context.Request["Shipping_Notes"]);
                    break;
            }
            cmd.Connection = conn;
            conn.Open();
            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (SqlException ex)
            {
                context.Response.Write(ex.Message);
            }

            //using (SqlDataReader sdr = cmd.ExecuteReader())
            //{
            //    switch (context.Request["Call_Type"])
            //    {
            //        case "":
            //            while (sdr.Read())
            //            {
            //                supplier.Add(new
            //                {
            //                    C_No = sdr["客戶編號"],
            //                    C_Tel = sdr["電話"],
            //                    C_SName = sdr["客戶簡稱"],
            //                    C_Fax = sdr["傳真"],
            //                    C_Name = sdr["客戶名稱"],
            //                    C_Nation = sdr["國名"],
            //                    C_Principal = sdr["負責人"],
            //                    C_Payment_Terms = sdr["付款方式"],
            //                    C_Person_Commodity = sdr["連絡人大貨"],
            //                    C_Quote = sdr["報價等級"],
            //                    C_Currency = sdr["幣別"],
            //                    C_Person_Sample = sdr["連絡人樣品"],
            //                    C_Price_Condition = sdr["價格條件"],
            //                    C_Web = sdr["網站"],
            //                    C_Mail = sdr["Email"],
            //                    C_IV_Address = sdr["IV列印地址"],
            //                    C_Costomer_Source = sdr["客戶來源"],
            //                    C_Reference_Number = sdr["參考號碼"],
            //                    C_Company_Address = sdr["公司地址"],
            //                    C_Factory_Address = sdr["工廠地址"],
            //                    C_Delivery_Address = sdr["送貨地址"],
            //                    C_MailEDM = sdr["emailEDM"],
            //                    C_Update_User = sdr["更新人員"],
            //                    C_Update_Date = sdr["更新日期"],
            //                    C_SEQ = sdr["序號"],
            //                });
            //            }
            //            break;
            //    }
            //}
            //SqlDataAdapter SQL_DA = new SqlDataAdapter(cmd);
            conn.Close();
            //SQL_DA.Fill(DT);
            //var json = (new JavaScriptSerializer().Serialize(supplier));
            //context.Response.ContentType = "text/json";
            //context.Response.Write(json);
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
