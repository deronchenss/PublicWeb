<%@ WebHandler Language="C#" Class="BOM_Save" %>

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

public class BOM_Save : IHttpHandler, IRequiresSessionState
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
                case "BOM_New":
                    cmd.CommandText = @" INSERT INTO Dc2..bom([序號], [SUPLU_SEQ], [頤坊型號], [開發中], [最後完成者], [完成者簡稱], [備註], [部門], [變更日期], [更新人員], [更新日期], [註記])
                                         SELECT [序號] = (SELECT COALESCE(MAX([序號]),0) +1 FROM Dc2..bom), 
                                         		[SUPLU_SEQ] = @SUPLU_SEQ,
                                         		[頤坊型號] = @IM,
                                         		[開發中] = @DVN,
                                         		[最後完成者] = @S_No,
                                         		[完成者簡稱] = @S_SName,
                                         		[備註] = @Remark,
                                         		[部門] = 'IV',
                                         		[變更日期] = NULL,
                                         		[更新人員] = @Update_User,
                                         		[更新日期] = GETDATE(),
                                         		[註記] = 0
                                        IF( @@ROWCOUNT > 0)
                                        BEGIN
                                            INSERT INTO Dc2..bomsub([序號], [PARENT_SEQ], [SUPLU_SEQ], [頤坊型號], [最後完成者], [完成者簡稱], [廠商編號], [廠商簡稱], [材料型號], [D_SUPLU_SEQ], [材料用量], [採購], [轉入單位], [半成品], [原料], [階層], [原料銷售], [不發單], [不展開], [不計成本], [變更日期], [更新人員], [更新日期])
                                            SELECT [序號] = (SELECT COALESCE(MAX([序號]),0) +1 FROM Dc2..bomsub),
                                        		    [PARENT_SEQ] = 0, 
                                        		    [SUPLU_SEQ] = @SUPLU_SEQ,
                                        		    [頤坊型號] = @IM,
                                        		    [最後完成者] = @S_No,
                                        		    [完成者簡稱] = @S_SName,
                                        		    [廠商編號] = @S_No,
                                        		    [廠商簡稱] = @S_SName,
                                        		    [材料型號] = @IM,
                                        		    [D_SUPLU_SEQ] = @SUPLU_SEQ,
                                        		    [材料用量] = 1,
                                        		    [採購] = 'A',
                                        		    [轉入單位] = '*',
                                        		    [半成品] = NULL,
                                        		    [原料] = 0,
                                        		    [階層] = 1,
                                        		    [原料銷售] = 0,
                                        		    [不發單] = 0,
                                        		    [不展開] = 0,
                                        		    [不計成本] = 0,
                                        		    [變更日期] = NULL,
                                        		    [更新人員] = @Update_User,
                                        		    [更新日期] = GETDATE();
                                        END ";
                    cmd.Parameters.AddWithValue("SUPLU_SEQ", context.Request["SUPLU_SEQ"]);
                    cmd.Parameters.AddWithValue("IM", context.Request["IM"]);
                    cmd.Parameters.AddWithValue("DVN", context.Request["DVN"]);
                    cmd.Parameters.AddWithValue("S_No", context.Request["S_No"]);
                    cmd.Parameters.AddWithValue("S_SName", context.Request["S_SName"]);
                    cmd.Parameters.AddWithValue("Update_User", context.Request["Update_User"]);
                    cmd.Parameters.AddWithValue("Remark", context.Request["Remark"]);
                    break;
                case "BOM_D_New":
                    cmd.CommandText = @" INSERT INTO Dc2..bomsub([序號], [PARENT_SEQ], [SUPLU_SEQ], [頤坊型號], [最後完成者], [完成者簡稱], [廠商編號], [廠商簡稱], [材料型號], [D_SUPLU_SEQ], [材料用量], [採購], [轉入單位], [半成品], [原料], [階層], [原料銷售], [不發單], [不展開], [不計成本], [變更日期], [更新人員], [更新日期])
                                         SELECT [序號] = (SELECT COALESCE(MAX([序號]),0) +1 FROM Dc2..bomsub),
                                        	    [PARENT_SEQ] = @Parent_SEQ, 
                                        	    [SUPLU_SEQ] = @SUPLU_SEQ,
                                        	    [頤坊型號] = @Parent_IM,
                                        	    [最後完成者] = @Parent_Supplier_S_No,
                                        	    [完成者簡稱] = @Parent_Supplier_S_SName,
                                        	    [廠商編號] = @New_S_No,
                                        	    [廠商簡稱] = @New_S_SName,
                                        	    [材料型號] = @New_IM,
                                        	    [D_SUPLU_SEQ] = @New_SUPLU_SEQ,
                                        	    [材料用量] = @M_Amount,
                                        	    [採購] = 'B',
                                        	    [轉入單位] = @Parent_Supplier_S_No,
                                        	    [半成品] = NULL,
                                        	    [原料] = 0,
                                        	    [階層] = @New_Rank,
                                        	    [原料銷售] = 0,
                                        	    [不發單] = 0,
                                        	    [不展開] = 0,
                                        	    [不計成本] = 0,
                                        	    [變更日期] = NULL,
                                        	    [更新人員] = @Update_User,
                                        	    [更新日期] = GETDATE();
                                         UPDATE Dc2..bom 
                                         SET [更新人員] = @Update_User, 
                                             [更新日期] = GETDATE()
                                         WHERE [SUPLU_SEQ] = @SUPLU_SEQ; ";
                    cmd.Parameters.AddWithValue("Parent_SEQ", context.Request["Parent_SEQ"]);
                    cmd.Parameters.AddWithValue("SUPLU_SEQ", context.Request["SUPLU_SEQ"]);
                    cmd.Parameters.AddWithValue("Parent_IM", context.Request["Parent_IM"]);
                    cmd.Parameters.AddWithValue("Parent_Supplier_S_No", context.Request["Parent_Supplier_S_No"]);
                    cmd.Parameters.AddWithValue("Parent_Supplier_S_SName", context.Request["Parent_Supplier_S_SName"]);
                    cmd.Parameters.AddWithValue("New_S_No", context.Request["New_S_No"]);
                    cmd.Parameters.AddWithValue("New_S_SName", context.Request["New_S_SName"]);
                    cmd.Parameters.AddWithValue("New_IM", context.Request["New_IM"]);
                    cmd.Parameters.AddWithValue("New_SUPLU_SEQ", context.Request["New_SUPLU_SEQ"]);
                    cmd.Parameters.AddWithValue("M_Amount", context.Request["M_Amount"]);
                    cmd.Parameters.AddWithValue("Update_User", context.Request["Update_User"]);
                    cmd.Parameters.AddWithValue("New_Rank", context.Request["New_Rank"]);
                    break;
                case "BOM_M_Save":
                    cmd.CommandText = @" UPDATE Dc2..bom 
                                         SET [備註] = @Remark,
                                             [更新人員] = @Update_User, 
                                             [更新日期] = GETDATE()
                                         WHERE [SUPLU_SEQ] = @SUPLU_SEQ; ";
                    cmd.Parameters.AddWithValue("SUPLU_SEQ", context.Request["SUPLU_SEQ"]);
                    cmd.Parameters.AddWithValue("Update_User", context.Request["Update_User"]);
                    cmd.Parameters.AddWithValue("Remark", context.Request["Remark"]);
                    break;
                case "BOM_D_Save":
                    cmd.CommandText = @" UPDATE Dc2..bomsub
                                         SET [材料用量] = @M_Amount,
                                         	[原料銷售] = @MS,
                                         	[不發單] = @NB,
                                         	[不展開] = @NE,
                                         	[不計成本] = @NCC,
                                         	[更新人員] = @Update_User, 
                                         	[更新日期] = GETDATE()
                                         WHERE [序號] = @D_SEQ ";
                    cmd.Parameters.AddWithValue("D_SEQ", context.Request["D_SEQ"]);
                    cmd.Parameters.AddWithValue("M_Amount", context.Request["M_Amount"]);
                    cmd.Parameters.AddWithValue("MS", context.Request["MS"]);
                    cmd.Parameters.AddWithValue("NB", context.Request["NB"]);
                    cmd.Parameters.AddWithValue("NE", context.Request["NE"]);
                    cmd.Parameters.AddWithValue("NCC", context.Request["NCC"]);
                    cmd.Parameters.AddWithValue("Update_User", context.Request["Update_User"]);
                    break;
                case "BOM_Copy":
                    cmd.CommandText = @" INSERT INTO Dc2..bom
                                         SELECT  [序號] = (SELECT COALESCE(MAX([序號]),0) + 1 FROM Dc2..bom),
                                         		[SUPLU_SEQ] = @New_SUPLU_SEQ, 
                                         	    [頤坊型號] = (SELECT x.[頤坊型號] FROM Dc2..suplu x WHERE x.[序號] = @New_SUPLU_SEQ),
                                         		[開發中] = (SELECT x.[開發中] FROM Dc2..suplu x WHERE x.[序號] = @New_SUPLU_SEQ),
                                         		[最後完成者] = (SELECT x.[廠商編號] FROM Dc2..suplu x WHERE x.[序號] = @New_SUPLU_SEQ),
                                         	    [完成者簡稱] = (SELECT x.[廠商簡稱] FROM Dc2..suplu x WHERE x.[序號] = @New_SUPLU_SEQ),
                                         		[備註], 
                                         		[部門], 
                                         		[變更日期] = NULL, 
                                         		[更新人員] = @Update_User, 
                                         		[更新日期] = GETDATE(), 
                                         		[註記]
                                         FROM Dc2..bom
                                         WHERE SUPLU_SEQ = @Old_SUPLU_SEQ
                                         IF( @@ROWCOUNT > 0)
                                         BEGIN
                                            SELECT [序號] [O_SEQ], [Sort] = ROW_NUMBER() OVER(ORDER BY [PARENT_SEQ], [序號]) INTO #S FROM Dc2..bomsub WHERE SUPLU_SEQ = @Old_SUPLU_SEQ ORDER BY 2,1;
                                            INSERT INTO Dc2..bomsub
                                            SELECT [序號] = (SELECT COALESCE(MAX([序號]),0) FROM Dc2..bomsub) + (ROW_NUMBER() OVER(ORDER BY [PARENT_SEQ], [序號])),
                                            	    [PARENT_SEQ] = IIF([PARENT_SEQ] = 0,0,
                                                                   ((SELECT COALESCE(MAX([序號]),0) FROM Dc2..bomsub) + (ROW_NUMBER() OVER(ORDER BY [PARENT_SEQ], [序號]))) - 
                                                                     ((ROW_NUMBER() OVER(ORDER BY [PARENT_SEQ], [序號])) - (SELECT [Sort] FROM #S WHERE [O_SEQ] = [PARENT_SEQ]) )),
                                            	    [SUPLU_SEQ] = @New_SUPLU_SEQ,
                                            	    [頤坊型號] = (SELECT x.[頤坊型號] FROM Dc2..suplu x WHERE x.[序號] = @New_SUPLU_SEQ),
                                            	    [最後完成者] = (SELECT x.[廠商編號] FROM Dc2..suplu x WHERE x.[序號] = @New_SUPLU_SEQ),
                                            	    [完成者簡稱] = (SELECT x.[廠商簡稱] FROM Dc2..suplu x WHERE x.[序號] = @New_SUPLU_SEQ),
                                            	    [廠商編號] = IIF([頤坊型號] = [材料型號],(SELECT x.[廠商編號] FROM Dc2..suplu x WHERE x.[序號] = @New_SUPLU_SEQ),[廠商編號]),
                                            	    [廠商簡稱] = IIF([頤坊型號] = [材料型號],(SELECT x.[廠商簡稱] FROM Dc2..suplu x WHERE x.[序號] = @New_SUPLU_SEQ),[廠商簡稱]),
                                            	    [材料型號] = IIF([頤坊型號] = [材料型號],(SELECT x.[頤坊型號] FROM Dc2..suplu x WHERE x.[序號] = @New_SUPLU_SEQ),[廠商簡稱]),
	                                                [D_SUPLU_SEQ] = IIF([PARENT_SEQ] = 0,@New_SUPLU_SEQ,[D_SUPLU_SEQ]),
                                            	    [材料用量],
                                            	    [採購],
                                            	    [轉入單位],
                                            	    [半成品],
                                            	    [原料],
                                            	    [階層],
                                            	    [原料銷售],
                                            	    [不發單],
                                            	    [不展開],
                                            	    [不計成本],
                                            	    [變更日期] = NULL,
                                            	    [更新人員] = @Update_User,
                                            	    [更新日期] = GETDATE()
                                            FROM Dc2..bomsub
                                            WHERE SUPLU_SEQ = @Old_SUPLU_SEQ
                                            ORDER BY [PARENT_SEQ], [序號];
                                            DROP TABLE #S;
                                         END ";
                    cmd.Parameters.AddWithValue("Old_SUPLU_SEQ", context.Request["Old_SUPLU_SEQ"]);
                    cmd.Parameters.AddWithValue("New_SUPLU_SEQ", context.Request["New_SUPLU_SEQ"]);
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
