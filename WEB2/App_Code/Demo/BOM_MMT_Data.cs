using Ivan.DAL.Models;
using Ivan_Dal;
using System;
using System.Data;
using System.Text;
using System.Web;
using Ivan_Log;
using System.Configuration;
using System.Data.SqlClient;

namespace Demo
{
    public class BOM_MMT_Data
    {
        HttpContext context;

        SqlConnection conn = new SqlConnection();
        SqlCommand cmd = new SqlCommand();
        DataTable dt = new DataTable();
        string sqlStr = "";
        public BOM_MMT_Data(HttpContext _context)
        {
            context = _context;
        }
        public DataTable BOM_MMT_Search()
        {
            conn.ConnectionString = ConfigurationManager.ConnectionStrings["LocalBC2"].ConnectionString;
            cmd.Connection = conn;
            try
            {
                conn.Open();
                switch (context.Request["Call_Type"])
                {
                    case "BOM_MMT_Search":
                        sqlStr = @"
                            SELECT TOP 500 
                            	BD.[廠商簡稱], BD.[材料型號], BD.[完成者簡稱], BD.[頤坊型號], C.[單位], 
                            	IIF(BD.[材料用量] = 0,'', CONVERT(VARCHAR,CAST(BD.[材料用量] AS MONEY),1)) [材料用量],
                            	BD.[轉入單位], C.[產品說明], BD.[廠商編號], BD.[最後完成者], BD.[序號], BD.[階層],
                                BD.SUPLU_SEQ, BD.D_SUPLU_SEQ, BD.[更新人員],
                            	LEFT(RTRIM(CONVERT(VARCHAR(20),BD.[更新日期],20)),16) [更新日期],
                                CAST(ISNULL((SELECT TOP 1 1 FROM [192.168.1.135].pic.dbo.xpic X WHERE X.[SUPLU_SEQ] = BD.[SUPLU_SEQ]),0) AS BIT) [Has_IMG], 
                                CAST(ISNULL((SELECT TOP 1 1 FROM [192.168.1.135].pic.dbo.xpic X WHERE X.[SUPLU_SEQ] = BD.[D_SUPLU_SEQ]),0) AS BIT) [D_Has_IMG]
                            FROM Dc2..bomsub BD
                            	INNER JOIN Dc2..suplu C ON C.[序號] = BD.D_SUPLU_SEQ
                            WHERE BD.[材料型號] LIKE @MM + '%'
                                AND BD.[頤坊型號] LIKE @EPM + '%'
                                AND BD.[廠商編號] LIKE @M_S_No + '%'
                                AND BD.[廠商簡稱] LIKE @M_S_SName + '%'
                                AND BD.[最後完成者] LIKE @EP_S_No + '%' 
                                AND BD.[完成者簡稱] LIKE @EP_S_SName + '%' ";
                        cmd.Parameters.AddWithValue("MM", context.Request["MM"]);
                        cmd.Parameters.AddWithValue("EPM", context.Request["EPM"]);
                        cmd.Parameters.AddWithValue("M_S_No", context.Request["M_S_No"]);
                        cmd.Parameters.AddWithValue("M_S_SName", context.Request["M_S_SName"]);
                        cmd.Parameters.AddWithValue("EP_S_No", context.Request["EP_S_No"]);
                        cmd.Parameters.AddWithValue("EP_S_SName", context.Request["EP_S_SName"]);
                        break;
                }
                
                cmd.CommandText = sqlStr;
                SqlDataAdapter SDA = new SqlDataAdapter(cmd);
                SDA.Fill(dt);

                Log.InsertLog(context, context.Session["Name"], cmd.CommandText);
                conn.Close();
                return dt;
            }
            catch (Exception ex)
            {
                Log.InsertLog(context, context.Session["Name"], cmd.CommandText ?? "", ex.ToString(), false);
                conn.Close();
                throw ex;
            }
        }
    }
}


