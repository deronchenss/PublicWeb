<%@ WebHandler Language="C#" Class="Sup_Search" %>

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

public class Sup_Search : IHttpHandler, IRequiresSessionState
{
    //SqlConnection LocalBC2 = new SqlConnection(WebConfigurationManager.ConnectionStrings["LocalBC2"].ConnectionString.ToString());
    public void ProcessRequest(HttpContext context)
    {
        DataTable DT = new DataTable();

        if (!string.IsNullOrEmpty(context.Request["Call_Type"]))
        {
            List<object> supplier = new List<object>();
            SqlConnection conn = new SqlConnection();
            conn.ConnectionString = ConfigurationManager.ConnectionStrings["LocalBC2"].ConnectionString;
            SqlCommand cmd = new SqlCommand();
            switch (context.Request["Call_Type"])
            {
                case "BT_Search":
                    cmd.CommandText = @" SELECT TOP 500 [廠商編號], [電話], [廠商簡稱], [傳真], [廠商名稱], 
                                                    [行動電話], [序號], [所在地], [統一編號], [付款條件], 
                                                    [負責人], [網站], [連絡人開發], [email開發], [連絡人採購], 
                                                    [email採購], [公司地址], [工廠地址], [裝配品寄送地址], [更新人員], 
                                                    LEFT(RTRIM(CONVERT(VARCHAR(20),[更新日期],20)),16) [更新日期], 
                                                    [國名], [注音]
                                                 FROM Dc2..sup
                                                 WHERE [廠商編號] LIKE '%' + @S_NO + '%' ";
                    cmd.CommandText += " AND ISNULL([電話],'') LIKE '%' + @S_Tel + '%' ";
                    cmd.CommandText += " AND ISNULL([國名],'') LIKE '%' + @Nation + '%' ";
                    cmd.CommandText += " AND ISNULL([傳真],'') LIKE '%' + @FAX + '%' ";
                    cmd.CommandText += " AND ( ISNULL([公司地址],'') LIKE '%' + @Address + '%' OR ISNULL([工廠地址],'') LIKE '%' + @Address + '%' )";

                    cmd.Parameters.AddWithValue("S_NO", context.Request["S_NO"]);
                    cmd.Parameters.AddWithValue("S_Tel", context.Request["S_Tel"]);
                    cmd.Parameters.AddWithValue("Nation", context.Request["Nation"]);
                    cmd.Parameters.AddWithValue("FAX", context.Request["FAX"]);
                    cmd.Parameters.AddWithValue("Address", context.Request["Address"]);
                    break;
                case "GV_Selected":
                    cmd.CommandText = @" SELECT [廠商編號], [電話], [廠商簡稱], [傳真], [廠商名稱], 
                                                    [行動電話], [序號], [所在地], [統一編號], [付款條件], 
                                                    [負責人], [網站], [連絡人開發], [email開發], [連絡人採購], 
                                                    [email採購], [公司地址], [工廠地址], [裝配品寄送地址], [更新人員], 
                                                    LEFT(RTRIM(CONVERT(VARCHAR(20),[更新日期],20)),16) [更新日期], 
                                                    [國名], [注音], [備註開發], [備註採購],
                                                    [往來銀行_1] [帳號抬頭],
                                                    [往來銀行_2] [銀行名稱],
	                                                [往來銀行_3] [銀行地址],
	                                                [往來銀行_4] [廠商帳號],
	                                                [swift] 
                                                 FROM Dc2..sup
                                                 WHERE [廠商編號] = @S_NO ";
                    cmd.Parameters.AddWithValue("S_NO", context.Request["S_NO"]);
                    break;
                case "Supplier2_Search":
                    cmd.CommandText = @" SELECT TOP 500 [廠商編號], [廠商簡稱], [電話], [傳真], [連絡人採購], 
                                                                [連絡人開發], [負責人], [統一編號], 
                                                                [序號], [更新人員], LEFT(RTRIM(CONVERT(VARCHAR(20),[更新日期],20)),16) [更新日期]

                                                 FROM Dc2..sup
                                                 WHERE 1 = 1 ";
                    if (!string.IsNullOrEmpty(context.Request["Search_Where"]))
                    {
                        cmd.CommandText += " AND " + context.Request["Search_Where"];
                    }
                    cmd.CommandText += " ORDER BY [更新日期] DESC ";
                    break;
                case "Supplier2_Selected":
                    cmd.CommandText = @" SELECT [序號], [廠商編號], [電話], [廠商簡稱], [傳真], [廠商名稱], [所在地], [統一編號], [帳務分類], 
                                                 	   [國名], [負責人], [幣別], [行動電話], [付款條件], [網站], [連絡人開發], [Email開發], [連絡人採購], 
                                                 	   [Email採購], [公司地址], [工廠地址], [裝配品寄送地址], 
                                                 	   [更新人員], LEFT(RTRIM(CONVERT(VARCHAR(20),[更新日期],20)),16) [更新日期],
                                                 	   [備註開發], [備註採購], 
                                                 	   [國內支付] [支付方式],
                                                 	   [收款總行] [收款總行代號], 
                                                 	   [收款分行] [收款分行代號],
                                                 	   [收款帳號] [收款人帳號],
                                                 	   [收款戶名] [收款人戶名],
                                                 	   [收款統編] [收款人統編],
                                                 	   [收款mail] [收款人Mail],
                                                 	   [海外支付] [OP_支付方式],
                                                 	   [受款國別] [OP_收款地國別],
                                                 	   [匯款幣別] [OP_幣別],
                                                 	   [受款名稱] [OP_收款人戶名],
                                                 	   [受款地址] [OP_收款人地址],
                                                 	   [受款帳號] [OP_收款人帳號],
                                                 	   [受款swift] [OP_SWIFT],
                                                 	   [受款行名] [OP_收款銀行名稱],
                                                 	   [受款行址] [OP_收款銀行地址]
                                                 FROM Dc2..sup
                                                 WHERE [廠商編號] = @S_NO ";
                    cmd.Parameters.AddWithValue("S_NO", context.Request["S_NO"]);
                    break;
            }
            cmd.Connection = conn;
            conn.Open();
            SqlDataReader sdr = cmd.ExecuteReader();
            switch (context.Request["Call_Type"])
            {
                case "BT_Search":
                    while (sdr.Read())
                    {
                        supplier.Add(new
                        {
                            S_NO = sdr["廠商編號"],
                            S_Name = sdr["廠商簡稱"],
                            S_Tel = sdr["電話"],
                            S_FAX = sdr["傳真"],
                            S_P_Purchase = sdr["連絡人採購"],
                            S_P_Develop = sdr["連絡人開發"],
                            S_Principal = sdr["負責人"],
                            S_Area = sdr["所在地"],
                            S_Nation = sdr["國名"],
                            S_Z = sdr["注音"],
                            S_Phone = sdr["行動電話"],
                            S_Company_Address = sdr["公司地址"],
                            S_Factory_Address = sdr["工廠地址"],
                            S_SEQ = sdr["序號"],
                            S_Update_User = sdr["更新人員"],
                            S_Update_Date = sdr["更新日期"],
                        });
                    }
                    break;
                case "GV_Selected":
                    while (sdr.Read())
                    {
                        supplier.Add(new
                        {
                            S_NO = sdr["廠商編號"],
                            S_Tel = sdr["電話"],
                            S_Name = sdr["廠商簡稱"],
                            S_FAX = sdr["傳真"],
                            S_Full_Name = sdr["廠商名稱"],
                            S_Phone = sdr["行動電話"],
                            S_SEQ = sdr["序號"],
                            S_Area = sdr["所在地"],
                            S_EIN = sdr["統一編號"],
                            S_Pay = sdr["付款條件"],
                            S_Person = sdr["負責人"],
                            S_Site = sdr["網站"],
                            S_P_Develop = sdr["連絡人開發"],
                            S_Mail_Develop = sdr["email開發"],
                            S_P_Purchase = sdr["連絡人採購"],
                            S_Mail_Purchase = sdr["email採購"],
                            S_Company_Address = sdr["公司地址"],
                            S_Factory_Address = sdr["工廠地址"],
                            S_Send_Address = sdr["裝配品寄送地址"],
                            S_Update_User = sdr["更新人員"],
                            S_Update_Date = sdr["更新日期"],
                            S_Nation = sdr["國名"],
                            S_Z = sdr["注音"],
                            S_Remark_Develop = sdr["備註開發"],
                            S_Remark_Purchase = sdr["備註採購"],
                            B_Account_Head = sdr["帳號抬頭"],
                            B_Bank_Name = sdr["銀行名稱"],
                            B_Bank_Address = sdr["銀行地址"],
                            B_Bank_Account = sdr["廠商帳號"],
                            B_Swift = sdr["swift"]
                        });
                    }
                    break;
                case "Supplier2_Search":
                    while (sdr.Read())
                    {
                        supplier.Add(new
                        {
                            S_No = sdr["廠商編號"],
                            S_SName = sdr["廠商簡稱"],
                            S_Tel = sdr["電話"],
                            S_FAX = sdr["傳真"],
                            S_P_Purchase = sdr["連絡人採購"],
                            S_P_Develop = sdr["連絡人開發"],
                            S_Principal = sdr["負責人"],
                            S_EIN = sdr["統一編號"],
                            S_SEQ = sdr["序號"],
                            S_Update_User = sdr["更新人員"],
                            S_Update_Date = sdr["更新日期"]
                        });
                    }
                    break;
                case "Supplier2_Selected":
                    while (sdr.Read())
                    {
                        supplier.Add(new
                        {
                            SEQ = sdr["序號"],
                            S_No = sdr["廠商編號"],
                            S_Tel = sdr["電話"],
                            S_SName = sdr["廠商簡稱"],
                            S_FAX = sdr["傳真"],
                            S_Name = sdr["廠商名稱"],
                            S_Area = sdr["所在地"],
                            S_EIN = sdr["統一編號"],
                            S_Account_Class = sdr["帳務分類"],
                            S_Nation = sdr["國名"],
                            S_Principal = sdr["負責人"],
                            S_Currency = sdr["幣別"],
                            S_Phone = sdr["行動電話"],
                            S_Payment_Terms = sdr["付款條件"],
                            S_Web = sdr["網站"],
                            S_P_Develop = sdr["連絡人開發"],
                            S_Mail_Develop = sdr["Email開發"],
                            S_P_Purchase = sdr["連絡人採購"],
                            S_Mail_Purchase = sdr["Email採購"],
                            S_Company_Address = sdr["公司地址"],
                            S_Factory_Address = sdr["工廠地址"],
                            S_Send_Address = sdr["裝配品寄送地址"],
                            S_Update_User = sdr["更新人員"],
                            S_Update_Date = sdr["更新日期"],
                            S_Remark_Purchase = sdr["備註採購"],
                            S_Remark_Develop = sdr["備註開發"],
                            S_Payment_Mode = sdr["支付方式"],
                            S_Bank_Head_Code = sdr["收款總行代號"],
                            S_Bank_Branch_Code = sdr["收款分行代號"],
                            S_Collect_Account = sdr["收款人帳號"],
                            S_Collect_Name = sdr["收款人戶名"],
                            S_Collect_EIN = sdr["收款人統編"],
                            S_Collect_Mail = sdr["收款人Mail"],
                            S_OP_Payment_Mode = sdr["OP_支付方式"],
                            S_OP_Collect_Nation = sdr["OP_收款地國別"],
                            S_OP_Currency = sdr["OP_幣別"],
                            S_OP_Collect_Name = sdr["OP_收款人戶名"],
                            S_OP_Collect_Address = sdr["OP_收款人地址"],
                            S_OP_Collect_Account = sdr["OP_收款人帳號"],
                            S_OP_SWIFT = sdr["OP_SWIFT"],
                            S_OP_Collect_Bank_Name = sdr["OP_收款銀行名稱"],
                            S_OP_Collect_Bank_Address = sdr["OP_收款銀行地址"],
                        });
                    }
                    break;

            }

            SqlDataAdapter SQL_DA = new SqlDataAdapter(cmd);
            conn.Close();
            SQL_DA.Fill(DT);

            //context.Request["Call_Type"]

            var json = (new JavaScriptSerializer().Serialize(supplier));
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
