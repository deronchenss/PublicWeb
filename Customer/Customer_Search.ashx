<%@ WebHandler Language="C#" Class="Customer_Search" %>

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

public class Customer_Search : IHttpHandler, IRequiresSessionState
{
    public void ProcessRequest(HttpContext context)
    {
        DataTable DT = new DataTable();

        if (!string.IsNullOrEmpty(context.Request["Call_Type"]))
        {
            List<object> customer = new List<object>();
            SqlConnection conn = new SqlConnection();
            conn.ConnectionString = ConfigurationManager.ConnectionStrings["LocalBC2"].ConnectionString;
            SqlCommand cmd = new SqlCommand();
            switch (context.Request["Call_Type"])
            {
                case "BT_Search":
                    cmd.CommandText = @" SELECT TOP 500 [客戶編號], [客戶簡稱], [客戶來源], [報價等級], [電話], 
                                                                [傳真], [連絡人大貨], [連絡人樣品], [國名], [Email], 
                                                                [序號], [更新人員], LEFT(RTRIM(CONVERT(VARCHAR(20),[更新日期],20)),16) [更新日期]
                                                 FROM Dc2..byr
                                                 WHERE [客戶編號] LIKE '%' + @C_No + '%' 
                                                    AND ( ISNULL([公司地址],'') LIKE '%' + @Address + '%' OR ISNULL([工廠地址],'') LIKE '%' + @Address + '%' OR ISNULL([送貨地址],'') LIKE '%' + @Address + '%' )
                                                    AND  ISNULL([電話],'') LIKE '%' + @Tel + '%'
                                                    AND  ISNULL([國名],'') LIKE '%' + @Nation + '%'
                                                    AND  ISNULL([客戶來源],'') LIKE '%' + @C_Source + '%'
                                                    AND  ISNULL([郵件群組],'') LIKE '%' + @C_Mail_Group + '%'
                                                    AND  ISNULL([更新日期],'') LIKE '%' + @C_Update_Date + '%'
                                                    AND  ISNULL([Email],'') LIKE '%' + @C_Mail + '%' ";

                    cmd.Parameters.AddWithValue("C_No", context.Request["C_No"]);
                    cmd.Parameters.AddWithValue("Address", context.Request["C_Address"]);
                    cmd.Parameters.AddWithValue("Tel", context.Request["C_Tel"]);
                    cmd.Parameters.AddWithValue("Nation", context.Request["Nation"]);
                    cmd.Parameters.AddWithValue("C_Source", context.Request["C_Source"]);
                    cmd.Parameters.AddWithValue("C_Mail_Group", context.Request["C_Mail_Group"]);
                    cmd.Parameters.AddWithValue("C_Update_Date", context.Request["C_Update_Date"]);
                    cmd.Parameters.AddWithValue("C_Mail", context.Request["C_Mail"]);
                    break;
                case "Table_Selected":
                    cmd.CommandText = @" SELECT [客戶編號], [客戶簡稱], [電話], [客戶名稱], [國名], 
                                                 	[負責人], [連絡人大貨], [連絡人樣品], [Email], [網站], 
                                                 	[客戶來源], [郵件群組], [公司地址], [工廠地址], [送貨地址], 
                                                 	[更新人員], LEFT(RTRIM(CONVERT(VARCHAR(20),[更新日期],20)),16) [更新日期]
		                                            ,[報關行], [台灣空運代理], [台灣海運代理], [台灣海運船期], [出貨備註]
		                                            ,[香港空運代理], [香港海運代理], [香港海運船期]
		                                            ,[港口], [麥頭_1], [麥頭_2], [麥頭型狀], [麥頭字], [特殊文件], [快遞帳號], [統一編號]
		                                            ,[備註]
                                                 FROM Dc2..byr
                                                 WHERE [客戶編號] = @C_No ";
                    cmd.Parameters.AddWithValue("C_No", context.Request["C_No"]);
                    break;
                case "Customer2_Search":
                    cmd.CommandText = @" SELECT TOP 500 [客戶編號], [電話], [客戶簡稱], [傳真], [客戶名稱], 
                                                    [國名], [負責人], [付款方式], [連絡人大貨], [報價等級], 
                                                    [幣別], [連絡人樣品], [價格條件], [網站], [Email], 
                                                    [IV列印地址], [客戶來源], [參考號碼], [公司地址], [工廠地址], 
                                                    [送貨地址], [emailEDM], [更新人員], LEFT(RTRIM(CONVERT(VARCHAR(20),[更新日期],20)),16) [更新日期], [序號]
                                                 FROM Dc2..byr
                                                 WHERE 1 = 1 ";
                    //WHERE [客戶編號] LIKE '%' + @C_No + '%' ";
                    if (!string.IsNullOrEmpty(context.Request["Search_Where"]))
                    {
                        cmd.CommandText += " AND " + context.Request["Search_Where"];
                    }
                    cmd.CommandText += " ORDER BY [更新日期] DESC ";
                    //cmd.Parameters.AddWithValue("C_No", context.Request["C_No"]);
                    break;
                case "Customer2_Selected":
                    cmd.CommandText = @" SELECT [序號], [客戶編號], [客戶簡稱], [客戶名稱], [國名], [幣別], [報價等級], 
                                                 	[付款方式], [郵件群組], [負責人], [連絡人大貨], [連絡人樣品], [電話], [傳真], [統一編號], [網站], 
                                                 	[Email], [emailEDM], [價格條件], [IV列印地址], [公司地址], [工廠地址], [送貨地址], [備註], 
                                                 	[出貨備註], [更新人員], LEFT(RTRIM(CONVERT(VARCHAR(20),[更新日期],20)),16) [更新日期],
	                                                [報關行], [台灣空運代理], [台灣海運代理], [台灣海運船期], [香港空運代理], [香港海運代理], [香港海運船期],
	                                                [港口], [麥頭檔名], [麥頭_1], [麥頭_2], [麥頭型狀], [麥頭字], [包裝要求], [特殊文件], [快遞帳號],
	                                                [客戶來源], [參考號碼], [初接觸日], [採購人員], [財務人員], [email財務], [帳齡海運], [帳齡非海運], [停用日期], [發貨中心使用]
                                                 FROM Dc2..byr
                                                 WHERE [客戶編號] = @C_No ";
                    cmd.Parameters.AddWithValue("C_No", context.Request["C_No"]);
                    break;
                case "SCD_Search":
                    cmd.CommandText = @" SELECT TOP 100 [序號], [客戶編號], [客戶簡稱], [客戶名稱], [負責人], [email], LEFT([備註],30) + IIF(LEN([備註]) > 30,'...','')  [備註]
                                         FROM Dc2..byr
                                         WHERE [客戶編號] LIKE @C_No + '%' AND [客戶簡稱] LIKE '%' + @C_SName + '%' ";
                    cmd.Parameters.AddWithValue("C_No", context.Request["C_No"]);
                    cmd.Parameters.AddWithValue("C_SName", context.Request["C_SName"]);
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
                        customer.Add(new
                        {
                            C_No = sdr["客戶編號"],
                            C_SName = sdr["客戶簡稱"],
                            C_Source = sdr["客戶來源"],
                            C_Quote = sdr["報價等級"],
                            C_Tel = sdr["電話"],
                            C_Fax = sdr["傳真"],
                            C_Person_Commodity = sdr["連絡人大貨"],
                            C_Person_Sample = sdr["連絡人樣品"],
                            C_Nation = sdr["國名"],
                            C_Mail = sdr["Email"],
                            C_SEQ = sdr["序號"],
                            C_Update_User = sdr["更新人員"],
                            C_Update_Date = sdr["更新日期"],
                        });
                    }
                    break;
                case "Table_Selected":
                    while (sdr.Read())
                    {
                        customer.Add(new
                        {
                            C_No = sdr["客戶編號"],
                            C_SName = sdr["客戶簡稱"],
                            C_Tel = sdr["電話"],
                            C_Name = sdr["客戶名稱"],
                            C_Nation = sdr["國名"],
                            C_Principal = sdr["負責人"],
                            C_Person_Commodity = sdr["連絡人大貨"],
                            C_Person_Sample = sdr["連絡人樣品"],
                            C_Mail = sdr["Email"],
                            C_Web = sdr["網站"],
                            C_Source = sdr["客戶來源"],
                            C_Mail_Group = sdr["郵件群組"],
                            C_Company_Address = sdr["公司地址"],
                            C_Factory_Address = sdr["工廠地址"],
                            C_Delivery_Address = sdr["送貨地址"],
                            C_Update_User = sdr["更新人員"],
                            C_Update_Date = sdr["更新日期"],

                            C_Customs_Broker = sdr["報關行"],
                            C_TW_Air_Shipping_Agent = sdr["台灣空運代理"],
                            C_TW_Shipping_Agent = sdr["台灣海運代理"],
                            C_TW_Shipping_Schedule = sdr["台灣海運船期"],
                            C_Shipping_Notes = sdr["出貨備註"],

                            C_HK_Air_Shipping_Agent = sdr["香港空運代理"],
                            C_HK_Shipping_Agent = sdr["香港海運代理"],
                            C_HK_Shipping_Schedule = sdr["香港海運船期"],

                            C_Port = sdr["港口"],
                            C_Marks_1 = sdr["麥頭_1"],
                            C_Marks_2 = sdr["麥頭_2"],
                            C_Marks_Shape = sdr["麥頭型狀"],
                            C_Marks_Word = sdr["麥頭字"],
                            C_Special_Document = sdr["特殊文件"],
                            C_Express_Delivery_Account = sdr["快遞帳號"],
                            C_EIN = sdr["統一編號"],

                            C_Remark = sdr["備註"]
                        });
                    }
                    break;
                case "Customer2_Search":
                    while (sdr.Read())
                    {
                        customer.Add(new
                        {
                            C_No = sdr["客戶編號"],
                            C_Tel = sdr["電話"],
                            C_SName = sdr["客戶簡稱"],
                            C_Fax = sdr["傳真"],
                            C_Name = sdr["客戶名稱"],
                            C_Nation = sdr["國名"],
                            C_Principal = sdr["負責人"],
                            C_Payment_Terms = sdr["付款方式"],
                            C_Person_Commodity = sdr["連絡人大貨"],
                            C_Quote = sdr["報價等級"],
                            C_Currency = sdr["幣別"],
                            C_Person_Sample = sdr["連絡人樣品"],
                            C_Price_Condition = sdr["價格條件"],
                            C_Web = sdr["網站"],
                            C_Mail = sdr["Email"],
                            C_IV_Address = sdr["IV列印地址"],
                            C_Costomer_Source = sdr["客戶來源"],
                            C_Reference_Number = sdr["參考號碼"],
                            C_Company_Address = sdr["公司地址"],
                            C_Factory_Address = sdr["工廠地址"],
                            C_Delivery_Address = sdr["送貨地址"],
                            C_MailEDM = sdr["emailEDM"],
                            C_Update_User = sdr["更新人員"],
                            C_Update_Date = sdr["更新日期"],
                            C_SEQ = sdr["序號"],
                        });
                    }
                    break;
                case "Customer2_Selected":
                    while (sdr.Read())
                    {
                        customer.Add(new
                        {
                            C_SEQ = sdr["序號"],
                            C_No = sdr["客戶編號"],
                            C_SName = sdr["客戶簡稱"],
                            C_Name = sdr["客戶名稱"],
                            C_Nation = sdr["國名"],
                            C_Currency = sdr["幣別"],
                            C_Quote = sdr["報價等級"],
                            C_Payment_Terms = sdr["付款方式"],
                            C_Mailgroup = sdr["郵件群組"],
                            C_Principal = sdr["負責人"],
                            C_Person_Commodity = sdr["連絡人大貨"],
                            C_Person_Sample = sdr["連絡人樣品"],
                            C_Tel = sdr["電話"],
                            C_Fax = sdr["傳真"],
                            C_EIN = sdr["統一編號"],
                            C_Web = sdr["網站"],
                            C_Mail = sdr["Email"],
                            C_MailEDM = sdr["emailEDM"],
                            C_Price_Condition = sdr["價格條件"],
                            C_IV_Address = sdr["IV列印地址"],
                            C_Company_Address = sdr["公司地址"],
                            C_Factory_Address = sdr["工廠地址"],
                            C_Delivery_Address = sdr["送貨地址"],
                            C_Remark = sdr["備註"],
                            C_Shipping_Notes = sdr["出貨備註"],
                            C_Update_User = sdr["更新人員"],
                            C_Update_Date = sdr["更新日期"],
                            C_Customs_Broker = sdr["報關行"],
                            C_TW_Air_Shipping_Agent = sdr["台灣空運代理"],
                            C_TW_Shipping_Agent = sdr["台灣海運代理"],
                            C_TW_Shipping_Schedule = sdr["台灣海運船期"],
                            C_HK_Air_Shipping_Agent = sdr["香港空運代理"],
                            C_HK_Shipping_Agent = sdr["香港海運代理"],
                            C_HK_Shipping_Schedule = sdr["香港海運船期"],
                            C_Port = sdr["港口"],
                            C_Marks_File_Name = sdr["麥頭檔名"],
                            C_Marks_1 = sdr["麥頭_1"],
                            C_Marks_2 = sdr["麥頭_2"],
                            C_Marks_Shape = sdr["麥頭型狀"],
                            C_Marks_Word = sdr["麥頭字"],
                            C_Packag_Request = sdr["包裝要求"],
                            C_Special_Document = sdr["特殊文件"],
                            C_Express_Delivery_Account = sdr["快遞帳號"],
                            C_Costomer_Source = sdr["客戶來源"],
                            C_Reference_Number = sdr["參考號碼"],
                            C_First_Contact = sdr["初接觸日"],
                            C_Person_Purchase = sdr["採購人員"],
                            C_Person_Finance = sdr["財務人員"],
                            C_Finance_Mail = sdr["email財務"],
                            C_Aging_Shipping = sdr["帳齡海運"],
                            C_Aging_Other = sdr["帳齡非海運"],
                            C_Stop_Date = sdr["停用日期"],
                            C_Center_Use = sdr["發貨中心使用"]
                        });
                    }
                    break;
                case "SCD_Search":
                    while (sdr.Read())
                    {
                        customer.Add(new
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
                    break;
            }

            SqlDataAdapter SQL_DA = new SqlDataAdapter(cmd);
            conn.Close();
            SQL_DA.Fill(DT);

            var json = (new JavaScriptSerializer().Serialize(customer));
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
