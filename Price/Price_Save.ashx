<%@ WebHandler Language="C#" Class="Price_Save" %>

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

public class Price_Save : IHttpHandler, IRequiresSessionState
{
    public void ProcessRequest(HttpContext context)
    {
        if (!string.IsNullOrEmpty(context.Request["Call_Type"]))
        {
            SqlConnection conn = new SqlConnection();
                    
            conn.ConnectionString = ConfigurationManager.ConnectionStrings["LocalBC2"].ConnectionString;
            SqlCommand cmd = new SqlCommand();
            switch (context.Request["Call_Type"])
            {
                case "Price_New":
                    cmd.CommandText = @" INSERT INTO Dc2..byrlu([序號], [開發中], [商標], [客戶型號], [最後單價日], [客戶編號], [客戶簡稱], [頤坊型號], [單位], [廠商編號], [廠商簡稱], [產品說明], [台幣單價], [美元單價], [單價_2], [單價_3], [單價_4], [MIN_1], [MIN_2], [MIN_3], [MIN_4], [更新人員], [更新日期], [備註])
                                         SELECT [序號] = (SELECT COALESCE(MAX([序號]),0) + 1 FROM Dc2..byrlu),
                                         	   [開發中] = @DVN,
                                         	   [商標] = @TM,
                                         	   [客戶型號] = @CM,
                                         	   [最後單價日] = @LSPD,
                                         	   [客戶編號] = @C_No,
                                         	   [客戶簡稱] = @C_SName,
                                         	   [頤坊型號] = @IM,
                                         	   [單位] = @Unit,
                                         	   [廠商編號] = @S_No,
                                         	   [廠商簡稱] = @S_SName,
                                         	   [產品說明] = @PRI,
                                         	   [台幣單價] = @TWD_P,
                                         	   [美元單價] = @USD_P,
                                         	   [單價_2] = @P_2,
                                         	   [單價_3] = @P_3,
                                         	   [單價_4] = @P_4,
                                         	   [MIN_1] = @MIN_1,
                                         	   [MIN_2] = @MIN_2,
                                         	   [MIN_3] = @MIN_3,
                                         	   [MIN_4] = @MIN_4,
                                         	   [更新人員] = 'Ivan10',
                                         	   [更新日期] = GETDATE(),
                                         	   [備註] = @Remark ";
                    cmd.Parameters.AddWithValue("DVN", context.Request["DVN"]);
                    cmd.Parameters.AddWithValue("TM", context.Request["TM"]);
                    cmd.Parameters.AddWithValue("CM", context.Request["CM"]);
                    cmd.Parameters.AddWithValue("LSPD", context.Request["LSPD"]);
                    cmd.Parameters.AddWithValue("C_No", context.Request["C_No"]);
                    cmd.Parameters.AddWithValue("C_SName", context.Request["C_SName"]);
                    cmd.Parameters.AddWithValue("IM", context.Request["IM"]);
                    cmd.Parameters.AddWithValue("Unit", context.Request["Unit"]);
                    cmd.Parameters.AddWithValue("S_No", context.Request["S_No"]);
                    cmd.Parameters.AddWithValue("S_SName", context.Request["S_SName"]);
                    cmd.Parameters.AddWithValue("PRI", context.Request["PRI"]);
                    cmd.Parameters.AddWithValue("TWD_P", context.Request["TWD_P"]);
                    cmd.Parameters.AddWithValue("USD_P", context.Request["USD_P"]);
                    cmd.Parameters.AddWithValue("P_2", context.Request["P_2"]);
                    cmd.Parameters.AddWithValue("P_3", context.Request["P_3"]);
                    cmd.Parameters.AddWithValue("P_4", context.Request["P_4"]);
                    cmd.Parameters.AddWithValue("MIN_1", context.Request["MIN_1"]);
                    cmd.Parameters.AddWithValue("MIN_2", context.Request["MIN_2"]);
                    cmd.Parameters.AddWithValue("MIN_3", context.Request["MIN_3"]);
                    cmd.Parameters.AddWithValue("MIN_4", context.Request["MIN_4"]);
                    cmd.Parameters.AddWithValue("Update_User", context.Request["Update_User"]);
                    cmd.Parameters.AddWithValue("Remark", context.Request["Remark"]);
                    break;
                case "Price_Update":
                    cmd.CommandText = @" UPDATE Dc2..byrlu
                                         SET [開發中] = @DVN,
                                         	[商標] = @TM,
                                         	[客戶型號] = @CM,
                                         	[最後單價日] = @LSPD,
                                         	[停用日期] = @SD,
                                         	[客戶編號] = @C_No,
                                         	[客戶簡稱] = @C_SName,
                                         	[頤坊型號] = @IM,
                                         	[單位] = @Unit,
                                         	[廠商編號] = @S_No,
                                         	[廠商簡稱] = @S_SName,
                                         	[產品說明] = @PRI,
                                         	[台幣單價] = @TWD_P,
                                         	[美元單價] = @USD_P,
                                         	[單價_2] = @P_2,
                                         	[單價_3] = @P_3,
                                         	[單價_4] = @P_4,
                                         	[MIN_1] = @MIN_1,
                                         	[MIN_2] = @MIN_2,
                                         	[MIN_3] = @MIN_3,
                                         	[MIN_4] = @MIN_4,
                                         	[更新人員] = @Update_User, 
                                         	[更新日期] = GETDATE(),
                                         	[備註] = @Remark
                                         WHERE [序號] = @SEQ ";
                    cmd.Parameters.AddWithValue("SEQ", context.Request["SEQ"]);
                    cmd.Parameters.AddWithValue("DVN", context.Request["DVN"]);
                    cmd.Parameters.AddWithValue("TM", context.Request["TM"]);
                    cmd.Parameters.AddWithValue("CM", context.Request["CM"]);
                    cmd.Parameters.AddWithValue("LSPD", context.Request["LSPD"]);
                    cmd.Parameters.AddWithValue("SD", context.Request["SD"]);
                    cmd.Parameters.AddWithValue("C_No", context.Request["C_No"]);
                    cmd.Parameters.AddWithValue("C_SName", context.Request["C_SName"]);
                    cmd.Parameters.AddWithValue("IM", context.Request["IM"]);
                    cmd.Parameters.AddWithValue("Unit", context.Request["Unit"]);
                    cmd.Parameters.AddWithValue("S_No", context.Request["S_No"]);
                    cmd.Parameters.AddWithValue("S_SName", context.Request["S_SName"]);
                    cmd.Parameters.AddWithValue("PRI", context.Request["PRI"]);
                    cmd.Parameters.AddWithValue("TWD_P", context.Request["TWD_P"]);
                    cmd.Parameters.AddWithValue("USD_P", context.Request["USD_P"]);
                    cmd.Parameters.AddWithValue("P_2", context.Request["P_2"]);
                    cmd.Parameters.AddWithValue("P_3", context.Request["P_3"]);
                    cmd.Parameters.AddWithValue("P_4", context.Request["P_4"]);
                    cmd.Parameters.AddWithValue("MIN_1", context.Request["MIN_1"]);
                    cmd.Parameters.AddWithValue("MIN_2", context.Request["MIN_2"]);
                    cmd.Parameters.AddWithValue("MIN_3", context.Request["MIN_3"]);
                    cmd.Parameters.AddWithValue("MIN_4", context.Request["MIN_4"]);
                    cmd.Parameters.AddWithValue("Update_User", context.Request["Update_User"]);
                    cmd.Parameters.AddWithValue("Remark", context.Request["Remark"]);
                    break;
                case "Price_Copy":
                    cmd.CommandText = @" INSERT INTO Dc2..byrlu([序號], [開發中], [商標], [客戶型號], [最後單價日], [客戶編號], [客戶簡稱], [頤坊型號], [單位], [廠商編號], [廠商簡稱], [產品說明], [台幣單價], [美元單價], [單價_2], [單價_3], [單價_4], [MIN_1], [MIN_2], [MIN_3], [MIN_4], [更新人員], [更新日期], [備註])
                                         SELECT [序號] = (SELECT COALESCE(MAX([序號]),0) + 1 FROM Dc2..byrlu), 
                                         		[開發中], [商標],
                                         		[客戶型號] = @CM, 
                                         		[最後單價日] = NULL, 
                                         		[客戶編號] = @C_No, 
                                         		[客戶簡稱] = @C_SName, 
                                         		[頤坊型號] = @IM,
                                         		[單位], 
                                         		[廠商編號] = @S_No, 
                                         		[廠商簡稱] = @S_SName, 
                                         		[產品說明], 
                                                [台幣單價], [美元單價], [單價_2], [單價_3], [單價_4], [MIN_1], [MIN_2], [MIN_3], [MIN_4], 
                                         		[更新人員] = @Update_User, 
                                         		[更新日期] = GETDATE(), 
                                         		[備註] = ''
                                         FROM Dc2..byrlu
                                         WHERE [序號] = @Old_SEQ ";
                    cmd.Parameters.AddWithValue("Old_SEQ", context.Request["Old_SEQ"]);
                    cmd.Parameters.AddWithValue("CM", context.Request["CM"]);
                    cmd.Parameters.AddWithValue("C_No", context.Request["C_No"]);
                    cmd.Parameters.AddWithValue("C_SName", context.Request["C_SName"]);
                    cmd.Parameters.AddWithValue("IM", context.Request["IM"]);
                    cmd.Parameters.AddWithValue("S_No", context.Request["S_No"]);
                    cmd.Parameters.AddWithValue("S_SName", context.Request["S_SName"]);
                    cmd.Parameters.AddWithValue("Update_User", context.Request["Update_User"]);
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
