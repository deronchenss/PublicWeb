<%@ WebHandler Language = "C#" Class="Sample_ChkArr" %>

using System.Collections.Generic;
using System.Web;
using System.Web.SessionState;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;
using System.Web.Script.Serialization;
using Newtonsoft.Json;
using CrystalDecisions.CrystalReports.Engine;

public class Sample_ChkArr : IHttpHandler, IRequiresSessionState
{
    public void ProcessRequest(HttpContext context)
    {
        DataTable dt = new DataTable();

        if (!string.IsNullOrEmpty(context.Request["Call_Type"]))
        {
            try
            {
                List<object> quote = new List<object>();

                using (SqlCommand cmd = new SqlCommand())
                {
                    using (SqlConnection conn = new SqlConnection())
                    {
                        conn.ConnectionString = ConfigurationManager.ConnectionStrings["LocalBC2"].ConnectionString;
                        cmd.Connection = conn;
                        conn.Open();                  

                        switch (context.Request["Call_Type"])
                        {
                            case "SEARCH_PUDU":
                                cmd.CommandText = @" SELECT Top 500 
                                                     P.採購單號,P.廠商簡稱,P.頤坊型號,
                                                     P.採購數量,P.客戶簡稱,P.暫時型號,P.單位,P.產品說明,
                                                     SUM(P.點收數量) 點收數量
                                                     ,P.點收日期,P.到貨數量,P.到貨日期,P.工作類別 AS 類別,P.樣品號碼,
                                                     S.設計圖號,P.廠商型號,P.廠商編號,P.客戶編號,
                                                     S.圖型啟用,P.序號,P.更新人員
                                                     ,CONVERT(VARCHAR,P.更新日期, 111) 更新日期
                                                     ,ISNULL(P.到貨處理,' ') 到貨處理
                                                     ,CONVERT(VARCHAR,P.採購日期, 111) 採購日期
                                                     ,CONVERT(VARCHAR,P.採購交期, 111) 採購交期
                                                     ,CASE WHEN ISNULL(S.單位淨重,0) = 0 THEN '' ELSE CONVERT(VARCHAR,S.單位淨重) END 單位淨重
                                                     ,CASE WHEN ISNULL(S.單位毛重,0) = 0 THEN '' ELSE CONVERT(VARCHAR,S.單位毛重) END 單位毛重
                                                     ,CASE WHEN ISNULL(S.產品長度,0) = 0 THEN '' ELSE CONVERT(VARCHAR,S.產品長度) END 產品長度
                                                     ,CASE WHEN ISNULL(S.產品寬度,0) = 0 THEN '' ELSE CONVERT(VARCHAR,S.產品寬度) END 產品寬度
                                                     ,CASE WHEN ISNULL(S.產品高度,0) = 0 THEN '' ELSE CONVERT(VARCHAR,S.產品高度) END 產品高度
                                                     ,CASE WHEN P.結案 = 1 THEN '是' ELSE '否' END 結案
                                                     FROM pudu P
                                                     INNER JOIN SUPLU S ON P.頤坊型號=S.頤坊型號 AND P.廠商編號=S.廠商編號 
                                                     LEFT JOIN RECUA R ON P.序號 = R.PUDU_SEQ
                                                     WHERE IsNull(P.採購單號,'') <> ''
                                                     AND 工作類別 <>'詢價'
                                                     AND ISNULL(P.[頤坊型號],'') LIKE @IVAN_TYPE + '%'
                                                     AND ISNULL(P.[暫時型號],'') LIKE @TMP_TYPE + '%'
                                                     AND ISNULL(P.[廠商編號],'') LIKE @FACT_NO + '%'
                                                     AND ISNULL(P.[廠商簡稱],'') LIKE '%' + @FACT_S_NAME + '%'
                                                     AND ISNULL(P.[採購單號],'') LIKE @PUDU_NO + '%'
                                                     AND ISNULL(P.[廠商型號],'') LIKE @FACT_TYPE + '%'
                                              ";

                                if (!string.IsNullOrEmpty(context.Request["PUDU_GIVE_DATE_S"]))
                                {
                                    cmd.CommandText += " AND CONVERT(DATE,[採購日期]) >= @PUDU_GIVE_DATE_S";
                                    cmd.Parameters.AddWithValue("PUDU_GIVE_DATE_S", context.Request["PUDU_GIVE_DATE_S"]);
                                }
                                if (!string.IsNullOrEmpty(context.Request["PUDU_GIVE_DATE_E"]))
                                {
                                    cmd.CommandText += " AND CONVERT(DATE,[採購日期]) <= @PUDU_GIVE_DATE_E";
                                    cmd.Parameters.AddWithValue("PUDU_GIVE_DATE_E", context.Request["PUDU_GIVE_DATE_E"]);
                                }              

                                cmd.Parameters.AddWithValue("IVAN_TYPE", context.Request["IVAN_TYPE"]);
                                cmd.Parameters.AddWithValue("TMP_TYPE", context.Request["TMP_TYPE"]);
                                cmd.Parameters.AddWithValue("FACT_NO", context.Request["FACT_NO"]);
                                cmd.Parameters.AddWithValue("FACT_S_NAME", context.Request["FACT_S_NAME"]);
                                cmd.Parameters.AddWithValue("PUDU_NO", context.Request["PUDU_NO"]);
                                cmd.Parameters.AddWithValue("FACT_TYPE", context.Request["FACT_TYPE"]);

                                cmd.CommandText += @" GROUP BY P.採購單號,P.廠商簡稱,P.頤坊型號,P.採購數量,P.客戶簡稱,P.暫時型號,P.單位,P.產品說明,P.點收日期,P.到貨數量,P.到貨日期,P.工作類別,P.樣品號碼,
                                                     S.設計圖號,P.廠商型號,P.廠商編號,P.客戶編號,S.圖型啟用,P.序號,P.更新人員
                                                     ,P.更新日期,P.到貨處理,P.採購日期,P.採購交期
                                                     , S.單位淨重, S.單位毛重, S.產品長度, S.產品寬度, S.產品高度, P.結案  ";

                                //未結案
                                if (!string.IsNullOrEmpty(context.Request["WRITE_OFF"]) && context.Request["WRITE_OFF"] == "0")
                                {
                                    cmd.CommandText += " HAVING P.採購數量 > SUM(P.點收數量)";
                                }

                                cmd.CommandText += " ORDER BY P.採購單號,P.頤坊型號";
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
                                                       ,[外幣幣別],[外幣單價],[S_FROM],[廠商編號],[廠商簡稱],[變更日期],[更新人員],[更新日期],[PRICE_SEQ])
                                                    SELECT  (Select IsNull(Max(序號),0)+1 From Quah) [序號], @SEQ [報價單號], GETDATE() [報價日期],[客戶編號],[客戶簡稱]
                                                       ,[頤坊型號], '' [暫時型號_Del],[產品說明],[單位],[美元單價],[台幣單價]
                                                       ,[歐元單價],[單價_2],[單價_3],[單價_4],[min_1],[min_2],[min_3],[min_4]
                                                       ,[外幣幣別],[外幣單價],"
                                                            + fromSQl + @"[S_FROM],[廠商編號],[廠商簡稱],[變更日期], 'IVAN' [更新人員], GETDATE() [更新日期],[序號]
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
                    }
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



