<%@ WebHandler Language="C#" Class="Cost_Save" %>

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

public class Cost_Save : IHttpHandler, IRequiresSessionState
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
                case "Cost_New":
                    cmd.CommandText = @" INSERT INTO Dc2..suplu(
	                                         序號, 
	                                         頤坊型號, 廠商型號, 銷售型號, 廠商編號, 廠商簡稱, 暫時型號, 
	                                         單位, 產品說明, 台幣單價, 美元單價, 台幣單價_2, 台幣單價_3, 
	                                         MIN_1, MIN_2, MIN_3, 外幣幣別, 外幣單價, 外幣單價_2, 外幣單價_3, 
	                                         設計人員, 設計圖號, 備註給採購, 備註給開發, 新增日期, 更新日期, 更新人員
                                         )
                                         SELECT [序號] = (SELECT COALESCE(MAX([序號]),0) +1 FROM Dc2..suplu), 
	                                            [頤坊型號] = @IM, 
	                                            [廠商型號] = @SM, 
	                                            [銷售型號] = @SaleM, 
	                                            [廠商編號] = @S_No, 
	                                            [廠商簡稱] = @S_SName, 
	                                            [暫時型號] = @Sample_PN, 
                                                [單位] = @Unit, 
	                                            [產品說明] = @PI, 
	                                            [台幣單價] = @P_TWD, 
	                                            [美元單價] = @P_USD, 
	                                            [台幣單價_2] = @P_TWD_2, 
	                                            [台幣單價_3] = @P_TWD_3, 
                                                [MIN_1] = @MIN_1, 
	                                            [MIN_2] = @MIN_2, 
	                                            [MIN_3] = @MIN_3, 
	                                            [外幣幣別] = @Curr, 
	                                            [外幣單價] = @P_Curr, 
	                                            [外幣單價_2] = @P_Curr_2, 
	                                            [外幣單價_3] = @P_Curr_3,
                                                [設計人員] = @DS_P, 
	                                            [設計圖號] = @DS_IM, 
	                                            [備註給採購] = @RP, 
	                                            [備註給開發] = @RD,
	                                            [新增日期] = GETDATE(),
	                                            [更新日期] = GETDATE(),
	                                            [更新人員] = @Update_User; ";
                    cmd.Parameters.AddWithValue("IM", context.Request["IM"]);
                    cmd.Parameters.AddWithValue("SM", context.Request["SM"]);
                    cmd.Parameters.AddWithValue("SaleM", context.Request["SaleM"]);
                    cmd.Parameters.AddWithValue("S_No", context.Request["S_No"]);
                    cmd.Parameters.AddWithValue("S_SName", context.Request["S_SName"]);
                    cmd.Parameters.AddWithValue("Sample_PN", context.Request["Sample_PN"]);
                    cmd.Parameters.AddWithValue("Unit", context.Request["Unit"]);
                    cmd.Parameters.AddWithValue("PI", context.Request["PI"]);
                    cmd.Parameters.AddWithValue("P_TWD", context.Request["P_TWD"]);
                    cmd.Parameters.AddWithValue("P_USD", context.Request["P_USD"]);
                    cmd.Parameters.AddWithValue("P_TWD_2", context.Request["P_TWD_2"]);
                    cmd.Parameters.AddWithValue("P_TWD_3", context.Request["P_TWD_3"]);
                    cmd.Parameters.AddWithValue("MIN_1", context.Request["MIN_1"]);
                    cmd.Parameters.AddWithValue("MIN_2", context.Request["MIN_2"]);
                    cmd.Parameters.AddWithValue("MIN_3", context.Request["MIN_3"]);
                    cmd.Parameters.AddWithValue("Curr", context.Request["Curr"]);
                    cmd.Parameters.AddWithValue("P_Curr", context.Request["P_Curr"]);
                    cmd.Parameters.AddWithValue("P_Curr_2", context.Request["P_Curr_2"]);
                    cmd.Parameters.AddWithValue("P_Curr_3", context.Request["P_Curr_3"]);
                    cmd.Parameters.AddWithValue("DS_P", context.Request["DS_P"]);
                    cmd.Parameters.AddWithValue("DS_IM", context.Request["DS_IM"]);
                    cmd.Parameters.AddWithValue("RP", context.Request["RP"]);
                    cmd.Parameters.AddWithValue("RD", context.Request["RD"]);
                    cmd.Parameters.AddWithValue("Update_User", context.Request["Update_User"]);
                    break;
                case "Cost_Update":
                    cmd.CommandText = @" UPDATE Dc2..suplu
                                         SET [頤坊型號] = @IM,
	                                         [廠商型號] = @SM,
	                                         [銷售型號] = @SaleM,
	                                         [廠商編號] = @S_No, 
	                                         [廠商簡稱] = @S_SName,
	                                         [暫時型號] = @Sample_PN, 
	                                         [單位] = @Unit,
	                                         [產品說明] = @PI,
	                                         [產品詳述] = @PID,	 
	                                         [台幣單價] = @P_TWD, 
	                                         [美元單價] = @P_USD, 
	                                         [台幣單價_2] = @P_TWD_2, 
	                                         [台幣單價_3] = @P_TWD_3, 
	                                         [MIN_1] = @MIN_1, 
	                                         [MIN_2] = @MIN_2, 
	                                         [MIN_3] = @MIN_3, 
	                                         [外幣幣別] = @Curr, 
	                                         [外幣單價] = @P_Curr, 
	                                         [外幣單價_2] = @P_Curr_2, 
	                                         [外幣單價_3] = @P_Curr_3, 
	                                         [設計人員] = @DS_P, 
	                                         [設計圖號] = @DS_IM, 
	                                         [開發中] = @DPN,
	                                         [產品狀態] = @PS,
	                                         [備註給採購] = @RP, 
	                                         [備註給開發] = @RD,
	                                         [更新日期] = GETDATE(),
	                                         [更新人員] = @Update_User,
	                                        --變更記錄 > Tri
                                             [製造規格] = @MS,
                                             [工時] = @WH, 
                                             [內盒容量] = @IBC, 
                                             [外箱編號] = @OBNo, 
                                             [淨重] = @NW,
                                             [內盒數] = @IA, 
                                             [外箱長度] = @OBL, 
                                             [毛重] = @GW, 
                                             [外箱寬度] = @OBW, 
                                             [外箱高度] = @OBH, 
                                             [內箱數] = @IA2,
                                             [單位淨重] = @P_NW, 
                                             [單位毛重] = @P_GW, 
                                             [產品長度] = @PL, 
                                             [產品寬度] = @PW, 
                                             [產品高度] = @PH, 
                                             [包裝深長] = @PGL, 
                                             [包裝面寬] = @PGW, 
                                             [包裝高度] = @PGH
                                         WHERE [序號] = @SEQ; ";
                    cmd.Parameters.AddWithValue("SEQ", context.Request["SEQ"]);
                    cmd.Parameters.AddWithValue("IM", context.Request["IM"]);
                    cmd.Parameters.AddWithValue("SM", context.Request["SM"]);
                    cmd.Parameters.AddWithValue("SaleM", context.Request["SaleM"]);
                    cmd.Parameters.AddWithValue("S_No", context.Request["S_No"]);
                    cmd.Parameters.AddWithValue("S_SName", context.Request["S_SName"]);
                    cmd.Parameters.AddWithValue("Sample_PN", context.Request["Sample_PN"]);
                    cmd.Parameters.AddWithValue("Unit", context.Request["Unit"]);
                    cmd.Parameters.AddWithValue("PI", context.Request["PI"]);
                    cmd.Parameters.AddWithValue("PID", context.Request["PID"]);
                    cmd.Parameters.AddWithValue("P_TWD", context.Request["P_TWD"]);
                    cmd.Parameters.AddWithValue("P_USD", context.Request["P_USD"]);
                    cmd.Parameters.AddWithValue("P_TWD_2", context.Request["P_TWD_2"]);
                    cmd.Parameters.AddWithValue("P_TWD_3", context.Request["P_TWD_3"]);
                    cmd.Parameters.AddWithValue("MIN_1", context.Request["MIN_1"]);
                    cmd.Parameters.AddWithValue("MIN_2", context.Request["MIN_2"]);
                    cmd.Parameters.AddWithValue("MIN_3", context.Request["MIN_3"]);
                    cmd.Parameters.AddWithValue("Curr", context.Request["Curr"]);
                    cmd.Parameters.AddWithValue("P_Curr", context.Request["P_Curr"]);
                    cmd.Parameters.AddWithValue("P_Curr_2", context.Request["P_Curr_2"]);
                    cmd.Parameters.AddWithValue("P_Curr_3", context.Request["P_Curr_3"]);
                    cmd.Parameters.AddWithValue("DS_P", context.Request["DS_P"]);
                    cmd.Parameters.AddWithValue("DS_IM", context.Request["DS_IM"]);
                    cmd.Parameters.AddWithValue("DPN", context.Request["DPN"]);
                    cmd.Parameters.AddWithValue("PS", context.Request["PS"]);
                    cmd.Parameters.AddWithValue("RP", context.Request["RP"]);
                    cmd.Parameters.AddWithValue("RD", context.Request["RD"]);
                    cmd.Parameters.AddWithValue("Update_User", context.Request["Update_User"]);
                    cmd.Parameters.AddWithValue("MS", context.Request["MS"]);
                    cmd.Parameters.AddWithValue("WH", context.Request["WH"]);
                    cmd.Parameters.AddWithValue("IBC", context.Request["IBC"]);
                    cmd.Parameters.AddWithValue("OBNo", context.Request["OBNo"]);
                    cmd.Parameters.AddWithValue("NW", context.Request["NW"]);
                    cmd.Parameters.AddWithValue("OBL", context.Request["OBL"]);
                    cmd.Parameters.AddWithValue("GW", context.Request["GW"]);
                    cmd.Parameters.AddWithValue("IA", context.Request["IA"]);
                    cmd.Parameters.AddWithValue("OBW", context.Request["OBW"]);
                    cmd.Parameters.AddWithValue("OBH", context.Request["OBH"]);
                    cmd.Parameters.AddWithValue("IA2", context.Request["IA2"]);
                    cmd.Parameters.AddWithValue("P_NW", context.Request["P_NW"]);
                    cmd.Parameters.AddWithValue("P_GW", context.Request["P_GW"]);
                    cmd.Parameters.AddWithValue("PL", context.Request["PL"]);
                    cmd.Parameters.AddWithValue("PW", context.Request["PW"]);
                    cmd.Parameters.AddWithValue("PH", context.Request["PH"]);
                    cmd.Parameters.AddWithValue("PGL", context.Request["PGL"]);
                    cmd.Parameters.AddWithValue("PGW", context.Request["PGW"]);
                    cmd.Parameters.AddWithValue("PGH", context.Request["PGH"]);
                    break;
                case "Cost_Apply":
                    cmd.CommandText = @" UPDATE Dc2..suplu
                                             SET [開發中] = 'R',
                                             	[申請原因] = @Reason,
                                             	[更新人員] = @Update_User,
                                             	[更新日期] = GETDATE()
                                             WHERE [序號] = @SEQ; ";
                    cmd.Parameters.AddWithValue("SEQ", context.Request["SEQ"]);
                    cmd.Parameters.AddWithValue("Reason", context.Request["Reason"]);
                    cmd.Parameters.AddWithValue("Update_User", context.Request["Update_User"]);
                    break;
                case "Cost_Approve":
                    cmd.CommandText = @" UPDATE Dc2..suplu
                                             SET [開發中] = 'N',
                                             	[更新人員] = @Update_User,
                                             	[更新日期] = GETDATE()
                                             WHERE [序號] = @SEQ; ";
                    cmd.Parameters.AddWithValue("SEQ", context.Request["SEQ"]);
                    cmd.Parameters.AddWithValue("Update_User", context.Request["Update_User"]);
                    break;
                case "Cost_Class":
                    cmd.CommandText = @" UPDATE Dc2..suplu
                                         SET [產品一階] = @PC1,
                                             [產品二階] = @PC2,
                                             [產品三階] = @PC3,
                                         	 [更新人員] = @Update_User,
                                         	 [更新日期] = GETDATE()
                                         WHERE [序號] = @SEQ; ";
                    cmd.Parameters.AddWithValue("SEQ", context.Request["SEQ"]);
                    cmd.Parameters.AddWithValue("PC1", context.Request["PC1"]);
                    cmd.Parameters.AddWithValue("PC2", context.Request["PC2"]);
                    cmd.Parameters.AddWithValue("PC3", context.Request["PC3"]);
                    cmd.Parameters.AddWithValue("Update_User", context.Request["Update_User"]);
                    break;
                case "CAA_Approve":
                    cmd.CommandText = @" UPDATE Dc2..suplu
                                         SET [點收核准] = '1',
                                         	 [更新人員] = @Update_User,
                                         	 [更新日期] = GETDATE()
                                         WHERE [序號] = @SEQ; ";
                    cmd.Parameters.AddWithValue("SEQ", context.Request["SEQ"]);
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
