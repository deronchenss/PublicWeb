<%@ WebHandler Language="C#" Class="Supplier_Save" %>

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

public class Supplier_Save : IHttpHandler, IRequiresSessionState
{
    public void ProcessRequest(HttpContext context)
    {

        if (!string.IsNullOrEmpty(context.Request["Call_Type"]))
        {
            List<object> supplier = new List<object>();
            SqlConnection conn = new SqlConnection();
            conn.ConnectionString = ConfigurationManager.ConnectionStrings["LocalBC2"].ConnectionString;
            SqlCommand cmd = new SqlCommand();
            switch (context.Request["Call_Type"])
            {
                case "Supplier_MT_New":
                    cmd.CommandText = @" INSERT INTO Dc2..sup ([序號],[廠商編號],[廠商簡稱],[廠商名稱],[所在地],[幣別],[付款條件],[連絡人採購],[連絡人開發],[電話],[傳真],[行動電話],[統一編號],[網站],[EMAIL採購],[EMAIL開發],[公司地址],[工廠地址],[裝配品寄送地址],[負責人],[帳務分類],[國名],[更新人員])
                                         SELECT [序號] = (SELECT COALESCE(MAX([序號]),0) + 1 FROM Dc2..sup),
                                         	[廠商編號] = @S_No,
                                         	[廠商簡稱] = @S_SName,
                                         	[廠商名稱] = @S_Name,
                                         	[所在地] = @Area,
                                         	[幣別] = @Currency,
                                         	[付款條件] = @Payment_Terms,
                                         	[連絡人採購] = @Purchase_Person,
                                         	[連絡人開發] = @Develop_Person,
                                         	[電話] = @Tel,
                                         	[傳真] = @Fax,
                                         	[行動電話] = @Phone, 
                                         	[統一編號] = @EIN,
                                         	[網站] = @Web,
                                         	[EMAIL採購] = @Purchase_Mail,
                                         	[EMAIL開發] = @Develop_Mail,
                                         	[公司地址] = @Company_Address,
                                         	[工廠地址] = @Factory_Address,
                                         	[裝配品寄送地址] = @Delivery_Address,
                                         	[負責人] = @Principal,
                                         	[帳務分類] = @Account_Class,
                                         	[國名] = @Nation,
                                         	[更新人員] = @Update_User,
                                            [更新日期] = GETDATE(); ";
                    cmd.Parameters.AddWithValue("S_No", context.Request["S_No"]);
                    cmd.Parameters.AddWithValue("S_SName", context.Request["S_SName"]);
                    cmd.Parameters.AddWithValue("S_Name", context.Request["S_Name"]);
                    cmd.Parameters.AddWithValue("Area", context.Request["Area"]);
                    cmd.Parameters.AddWithValue("Currency", context.Request["Currency"]);
                    cmd.Parameters.AddWithValue("Payment_Terms", context.Request["Payment_Terms"]);
                    cmd.Parameters.AddWithValue("Purchase_Person", context.Request["Purchase_Person"]);
                    cmd.Parameters.AddWithValue("Develop_Person", context.Request["Develop_Person"]);
                    cmd.Parameters.AddWithValue("Tel", context.Request["Tel"]);
                    cmd.Parameters.AddWithValue("Fax", context.Request["Fax"]);
                    cmd.Parameters.AddWithValue("Phone", context.Request["Phone"]);
                    cmd.Parameters.AddWithValue("EIN", context.Request["EIN"]);
                    cmd.Parameters.AddWithValue("Web", context.Request["Web"]);
                    cmd.Parameters.AddWithValue("Purchase_Mail", context.Request["Purchase_Mail"]);
                    cmd.Parameters.AddWithValue("Develop_Mail", context.Request["Develop_Mail"]);
                    cmd.Parameters.AddWithValue("Company_Address", context.Request["Company_Address"]);
                    cmd.Parameters.AddWithValue("Factory_Address", context.Request["Factory_Address"]);
                    cmd.Parameters.AddWithValue("Delivery_Address", context.Request["Delivery_Address"]);
                    cmd.Parameters.AddWithValue("Principal", context.Request["Principal"]);
                    cmd.Parameters.AddWithValue("Account_Class", context.Request["Account_Class"]);
                    cmd.Parameters.AddWithValue("Nation", context.Request["Nation"]);
                    cmd.Parameters.AddWithValue("Update_User", context.Request["Update_User"]);
                    break;

                case "Supplier_MT_Update":
                    cmd.CommandText = @" UPDATE Dc2..sup
                                         SET [廠商編號] = @S_No, 
                                             [電話] = @S_Tel, 
                                             [廠商簡稱] = @S_SName, 
                                             [傳真] = @S_FAX, 
                                             [廠商名稱] = @S_Name, 
                                             [所在地] = @S_Area, 
                                             [統一編號] = @S_EIN, 
                                             [帳務分類] = @S_Account_Class, 
                                             [國名] = @S_Nation, 
                                             [負責人] = @S_Principal, 
                                             [幣別] = @S_Currency, 
                                             [行動電話] = @S_Phone, 
                                             [付款條件] = @S_Payment_Terms,
                                             [網站] = @S_Web,
                                             [連絡人開發] = @S_P_Develop,
                                             [Email開發] = @S_Mail_Develop,
                                             [連絡人採購] = @S_P_Purchase,
                                             [Email採購] = @S_Mail_Purchase,
                                             [公司地址] = @S_Company_Address, 
                                             [工廠地址] = @S_Factory_Address,
                                             [裝配品寄送地址] = @S_Send_Address,
                                             [更新人員] = @Update_User,
                                             [更新日期] = GETDATE(),
                                             [備註開發] = @S_Remark_Develop, 
                                             [備註採購] = @S_Remark_Purchase, 
                                             [國內支付] = @S_Payment_Mode,
                                             [收款總行] = @S_Bank_Head_Code, 
                                             [收款分行] = @S_Bank_Branch_Code,
                                             [收款帳號] = @S_Collect_Account,
                                             [收款戶名] = @S_Collect_Name,
                                             [收款統編] = @S_Collect_EIN,
                                             [收款mail] = @S_Collect_Mail,
                                             [海外支付] = @S_OP_Payment_Mode,
                                             [受款國別] = @S_OP_Collect_Nation,
                                             [匯款幣別] = @S_OP_Currency,
                                             [受款名稱] = @S_OP_Collect_Name,
                                             [受款地址] = @S_OP_Collect_Address,
                                             [受款帳號] = @S_OP_Collect_Account,
                                             [受款swift] = @S_OP_SWIFT,
                                             [受款行名] = @S_OP_Collect_Bank_Name,
                                             [受款行址] = @S_OP_Collect_Bank_Address
                                         FROM Dc2..sup
                                         WHERE [序號] = @SEQ; ";
                    cmd.Parameters.AddWithValue("SEQ", context.Request["SEQ"]);
                    cmd.Parameters.AddWithValue("S_No", context.Request["S_No"]);
                    cmd.Parameters.AddWithValue("S_Tel", context.Request["S_Tel"]);
                    cmd.Parameters.AddWithValue("S_SName", context.Request["S_SName"]);
                    cmd.Parameters.AddWithValue("S_FAX", context.Request["Fax"]);
                    cmd.Parameters.AddWithValue("S_Name", context.Request["S_Name"]);
                    cmd.Parameters.AddWithValue("S_Area", context.Request["Area"]);
                    cmd.Parameters.AddWithValue("S_EIN", context.Request["EIN"]);
                    cmd.Parameters.AddWithValue("S_Account_Class", context.Request["Account_Class"]);
                    cmd.Parameters.AddWithValue("S_Nation", context.Request["Nation"]);
                    cmd.Parameters.AddWithValue("S_Principal", context.Request["Principal"]);
                    cmd.Parameters.AddWithValue("S_Currency", context.Request["Currency"]);
                    cmd.Parameters.AddWithValue("S_Phone", context.Request["Phone"]);
                    cmd.Parameters.AddWithValue("S_Payment_Terms", context.Request["Payment_Terms"]);
                    cmd.Parameters.AddWithValue("S_Web", context.Request["Web"]);
                    cmd.Parameters.AddWithValue("S_P_Develop", context.Request["Develop_Person"]);
                    cmd.Parameters.AddWithValue("S_Mail_Develop", context.Request["Develop_Mail"]);
                    cmd.Parameters.AddWithValue("S_P_Purchase", context.Request["Purchase_Person"]);
                    cmd.Parameters.AddWithValue("S_Mail_Purchase", context.Request["Purchase_Mail"]);
                    cmd.Parameters.AddWithValue("S_Company_Address", context.Request["Company_Address"]);
                    cmd.Parameters.AddWithValue("S_Factory_Address", context.Request["Factory_Address"]);
                    cmd.Parameters.AddWithValue("S_Send_Address", context.Request["Delivery_Address"]);
                    cmd.Parameters.AddWithValue("Update_User", context.Request["Update_User"]);
                    cmd.Parameters.AddWithValue("S_Remark_Purchase", context.Request["Purchase"]);
                    cmd.Parameters.AddWithValue("S_Remark_Develop", context.Request["Develop"]);
                    cmd.Parameters.AddWithValue("S_Payment_Mode", context.Request["Payment_Mode"]);
                    cmd.Parameters.AddWithValue("S_Bank_Head_Code", context.Request["Bank_Head_Code"]);
                    cmd.Parameters.AddWithValue("S_Bank_Branch_Code", context.Request["Bank_Branch_Code"]);
                    cmd.Parameters.AddWithValue("S_Collect_Account", context.Request["Collect_Account"]);
                    cmd.Parameters.AddWithValue("S_Collect_Name", context.Request["Collect_Name"]);

                    cmd.Parameters.AddWithValue("S_Collect_EIN", context.Request["Collect_EIN"]);
                    cmd.Parameters.AddWithValue("S_Collect_Mail", context.Request["Collect_Mail"]);
                    cmd.Parameters.AddWithValue("S_OP_Payment_Mode", context.Request["OP_Payment_Mode"]);
                    cmd.Parameters.AddWithValue("S_OP_Collect_Nation", context.Request["OP_Collect_Nation"]);
                    cmd.Parameters.AddWithValue("S_OP_Currency", context.Request["OP_Currency"]);
                    cmd.Parameters.AddWithValue("S_OP_Collect_Name", context.Request["OP_Collect_Name"]);
                    cmd.Parameters.AddWithValue("S_OP_Collect_Address", context.Request["OP_Collect_Address"]);
                    cmd.Parameters.AddWithValue("S_OP_Collect_Account", context.Request["OP_Collect_Account"]);
                    cmd.Parameters.AddWithValue("S_OP_SWIFT", context.Request["OP_SWIFT"]);
                    cmd.Parameters.AddWithValue("S_OP_Collect_Bank_Name", context.Request["OP_Collect_Bank_Name"]);
                    cmd.Parameters.AddWithValue("S_OP_Collect_Bank_Address", context.Request["OP_Bank_Address"]);
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

            conn.Close();
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
