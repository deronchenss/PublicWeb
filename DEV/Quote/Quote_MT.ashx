<%@ WebHandler Language="C#" Class="Quote_MT" %>

using System.Collections.Generic;
using System.Web;
using System.Web.SessionState;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;
using System.Web.Script.Serialization;
using Newtonsoft.Json;

public class Quote_MT : IHttpHandler, IRequiresSessionState
{
    public void ProcessRequest(HttpContext context)
    {
        DataTable dt = new DataTable();

        if (!string.IsNullOrEmpty(context.Request["Call_Type"]))
        {
            try
            {
                List<object> quote = new List<object>();
                SqlConnection conn = new SqlConnection();
                conn.ConnectionString = ConfigurationManager.ConnectionStrings["LocalBC2"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    conn.Open();

                    switch (context.Request["Call_Type"])
                    {
                        case "Quote_MT":
                            cmd.CommandText = @" SELECT TOP 1000 Byr.客戶簡稱, Byr.頤坊型號
                                                   ,Byr.美元單價, Byr.台幣單價, Byr.外幣幣別, Byr.外幣單價
                                                   ,Byr.MIN_1 MIN
                                                   ,Byr.產品說明, Byr.單位, Byr.廠商編號, Byr.廠商簡稱
                                                   ,Byr.客戶編號, Byr.序號, Byr.更新人員, CONVERT(VARCHAR, Byr.更新日期, 120) 更新日期
                                         	       --,CAST(ISNULL((SELECT TOP 1 1 FROM [192.168.1.135].pic.dbo.xpic X WHERE X.[P_SEQ] = Byr.[序號]),0) AS BIT) [Has_IMG]
                                             FROM Dc2..Byrlu Byr
                                             WHERE Byr.[客戶編號] LIKE '%' + @CUST_NO + '%'
                                             AND Byr.[客戶簡稱] LIKE '%' + @CUST_S_NAME + '%'
                                             AND Byr.[頤坊型號] LIKE '%' + @IVAN_TYPE + '%'
                                             AND Byr.[更新日期] BETWEEN @Date_S AND @Date_E
                                             ORDER BY Byr.客戶編號, Byr.頤坊型號 DESC ";
                            cmd.Parameters.AddWithValue("CUST_NO", context.Request["CUST_NO"]);
                            cmd.Parameters.AddWithValue("CUST_S_NAME", context.Request["CUST_S_NAME"]);
                            cmd.Parameters.AddWithValue("IVAN_TYPE", context.Request["IVAN_TYPE"]);
                            cmd.Parameters.AddWithValue("Date_S", context.Request["Date_S"]);
                            cmd.Parameters.AddWithValue("Date_E", context.Request["Date_E"]);
                            break;
                        case "QUAH_SEQ_SEARCH":
                            cmd.CommandText = @" SELECT ISNULL(CONVERT(INT,SUBSTRING(MAX(報價單號),2,6)), 220000) +1 from QUAH 
							                     WHERE SUBSTRING([報價單號],2,2) = SUBSTRING(CONVERT(VARCHAR,GETDATE(),111),3,2)
							                     AND LEN([報價單號]) = 7 ";
                            break;
                        case "CUST_NAME_SEARCH":
                            cmd.CommandText = @" SELECT [客戶簡稱] CUST_S_NAME, [客戶名稱] CUST_NAME from BYR 
							                     WHERE [客戶編號] = @CUST_NO ";

                            cmd.Parameters.AddWithValue("CUST_NO", context.Request["CUST_NO"]);
                            break;
                        case "INSERT_QUAH":

                            string[] ivanArray = context.Request["IVAN_TYPE[]"].Split(',');
                            string[] factNoArr = context.Request["FACT_NO[]"].Split(',');

                            for (int cnt = 0; cnt < ivanArray.Length; cnt++)
                            {
                                string fromSQl = (context.Request["FROM"] == "0" ? @"(SELECT CASE WHEN 所在地 IN ('台灣','國外') THEN '1' WHEN 所在地 = '香港' THEN '2' WHEN 所在地 = '中國' THEN '3' ELSE '?' END FROM Sup 
                                                                                      WHERE 廠商編號= @FACT_NO)  " 
                                                                                 : context.Request["FROM"]);

                                cmd.CommandText = @" INSERT INTO [dbo].[quah]
                                                       ([序號],[報價單號],[報價日期],[客戶編號],[客戶簡稱]
                                                       ,[頤坊型號],[暫時型號_Del],[產品說明],[單位],[美元單價],[台幣單價]
                                                       ,[歐元單價],[單價_2],[單價_3],[單價_4],[min_1],[min_2],[min_3],[min_4]
                                                       ,[外幣幣別],[外幣單價],[S_FROM],[廠商編號],[廠商簡稱],[變更日期],[更新人員],[更新日期])
                                                    SELECT  (Select IsNull(Max(序號),0)+1 From Quah) [序號], @SEQ [報價單號], GETDATE() [報價日期],[客戶編號],[客戶簡稱]
                                                       ,[頤坊型號], '' [暫時型號_Del],[產品說明],[單位],[美元單價],[台幣單價]
                                                       ,[歐元單價],[單價_2],[單價_3],[單價_4],[min_1],[min_2],[min_3],[min_4]
                                                       ,[外幣幣別],[外幣單價],"
                                                        + fromSQl + @"[S_FROM],[廠商編號],[廠商簡稱],[變更日期], 'IVAN' [更新人員],[更新日期]
                                                    FROM byrlu
                                                    WHERE 頤坊型號 = @IVAN_TYPE 
                                                    AND 客戶編號 = @CUST_NO ";
                                cmd.Parameters.Clear();
                                cmd.Parameters.AddWithValue("SEQ", context.Request["SEQ"]);
                                cmd.Parameters.AddWithValue("FROM", context.Request["FROM"]);
                                cmd.Parameters.AddWithValue("FACT_NO", factNoArr[cnt]);
                                cmd.Parameters.AddWithValue("IVAN_TYPE", ivanArray[cnt]);
                                cmd.Parameters.AddWithValue("CUST_NO", context.Request["CUST_NO"]);

                                cmd.ExecuteNonQuery();
                            }

                            context.Response.Write(ivanArray.Length);
                            break;
                    }

                    if (!context.Request["Call_Type"].Equals("INSERT_QUAH"))
                    {
                        SqlDataAdapter sqlData = new SqlDataAdapter(cmd);
                        sqlData.Fill(dt);

                        var json = JsonConvert.SerializeObject(dt);
                        context.Response.ContentType = "text/json";
                        context.Response.Write(json);
                    }
                    conn.Close();
                }
            }
            catch (SqlException ex)
            {
                context.Response.Write(ex.Message);
            }
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



