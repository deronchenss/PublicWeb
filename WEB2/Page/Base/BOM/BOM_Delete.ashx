<%@ WebHandler Language="C#" Class="BOM_Delete" %>

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

public class BOM_Delete : IHttpHandler, IRequiresSessionState
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
                case "BOM_D_Delete":
                    cmd.CommandText = @" IF((SELECT D_SUPLU_SEQ FROM Dc2..bomsub WHERE [序號] = @D_SEQ) = @SUPLU_SEQ)
                                         BEGIN
                                         	DELETE Dc2..bom WHERE [SUPLU_SEQ] = @SUPLU_SEQ
                                         END
                                         ELSE
                                         BEGIN
                                         	UPDATE Dc2..bom 
                                             SET [更新人員] = @Update_User, 
                                                 [更新日期] = GETDATE()
                                             WHERE [SUPLU_SEQ] = @SUPLU_SEQ;
                                         END
                                         DELETE Dc2..bomsub WHERE [序號] = @D_SEQ; ";
                    cmd.Parameters.AddWithValue("D_SEQ", context.Request["D_SEQ"]);
                    cmd.Parameters.AddWithValue("Update_User", context.Request["Update_User"]);
                    cmd.Parameters.AddWithValue("SUPLU_SEQ", context.Request["SUPLU_SEQ"]);
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
