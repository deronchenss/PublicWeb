<%@ WebHandler Language = "C#" Class="Quote_Base" %>

using System.Collections.Generic;
using System.Web;
using System.Web.SessionState;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;
using System.Web.Script.Serialization;
using Newtonsoft.Json;
using CrystalDecisions.CrystalReports.Engine;

public class Quote_Base : IHttpHandler, IRequiresSessionState
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
                            case "Quote_Base":
                                cmd.CommandText = @" SELECT TOP 500 Byr.客戶簡稱, Byr.頤坊型號
                                                   ,IIF(Byr.美元單價 = 0, NULL, Byr.美元單價) 美元單價, IIF(Byr.台幣單價=0,NULL, Byr.台幣單價) 台幣單價, 外幣幣別, IIF(Byr.外幣單價=0, NULL, Byr.外幣單價) 外幣單價
                                                   ,IIF(Byr.MIN_1 = 0, NULL, Byr.MIN_1) MIN
                                                   ,Byr.產品說明, Byr.單位, Byr.廠商編號, Byr.廠商簡稱
                                                   ,Byr.客戶編號, Byr.序號, Byr.更新人員, CONVERT(VARCHAR, Byr.更新日期, 120) 更新日期
                                         	       --,CAST(ISNULL((SELECT TOP 1 1 FROM [192.168.1.135].pic.dbo.xpic X WHERE X.[P_SEQ] = Byr.[序號]),0) AS BIT) [Has_IMG]
                                             FROM Dc2..Byrlu Byr
                                             WHERE Byr.[客戶編號] LIKE @CUST_NO + '%'
                                             AND Byr.[客戶簡稱] LIKE '%' + @CUST_S_NAME + '%'
                                             AND Byr.[頤坊型號] LIKE @IVAN_TYPE + '%'
                                              ";

                                if (!string.IsNullOrEmpty(context.Request["Date_E"]))
                                {
                                    cmd.CommandText += " AND CONVERT(DATE,[更新日期]) <= @Date_E";
                                }
                                if (!string.IsNullOrEmpty(context.Request["Date_S"]))
                                {
                                    cmd.CommandText += " AND CONVERT(DATE,[更新日期]) >= @Date_S";
                                }

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
                            case "GEN_RPT":
                                cmd.CommandText = @" SELECT Q.報價單號
			                                           ,Q.頤坊型號
			                                           ,D.客戶型號
			                                           ,Q.產品說明
			                                           ,Q.單位
			                                           ,TMP.min_1
			                                           ,B.客戶名稱
			                                           ,B.連絡人樣品
			                                           ,@DELV_DAYS 交貨天數
			                                           ,RTRIM(B.價格條件) + CASE Q.S_FROM WHEN '1' THEN ' TAIWAN' WHEN '2' THEN ' HONG KONG' WHEN '3' THEN ' CHINA' ELSE '' END 價格條件
                                                       ,CASE Q.S_FROM WHEN '1' THEN ' *** SHIPPING FROM TAIWAN ***' WHEN '2' THEN '*** SHIPPING FROM HONG KONG ***' WHEN '3' THEN ' *** SHIPPING FROM CHINA ***' ELSE '*** SHIPPING FROM ***' END ShipFrom
                                                       ,TMP.列印單價
			                                           ,CASE WHEN Q.美元單價 > 0 THEN 'USD'
					                                         ELSE 'NTD' END 幣別
			                                           ,C.大備註
                                                       ,(SELECT TOP 1 X.[圖檔] FROM [192.168.1.135].Pic.dbo.xpic X WHERE X.P_SEQ = (SELECT P_SEQ FROM byrlu where 序號 = Q.PRICE_SEQ)) 圖檔
			                                           ,'' 圖檔路徑
			                                           ,ISNULL((SELECT TOP 1 'Y' FROM [192.168.1.135].Pic.dbo.xpic X WHERE X.P_SEQ = (SELECT P_SEQ FROM byrlu where 序號 = Q.PRICE_SEQ)), '') 列印圖檔
			                                           ,(SELECT TOP 1 R.RI_IMAGE FROM [192.168.1.135].pic.dbo.REF_IMAGE R WHERE R.RI_REFENCE_KEY = @SIGN) 簽名圖檔
			                                           ,'' 簽名圖檔路徑
			                                           ,ISNULL((SELECT TOP 1 'Y' FROM [192.168.1.135].pic.dbo.REF_IMAGE R WHERE R.RI_REFENCE_KEY = @SIGN), '') 簽名列印圖檔
			                                           ,LEFT(FORMAT(Q.報價日期, 'MMMM', 'en-US'),3) + '. ' + RIGHT(CONVERT(VARCHAR,Q.報價日期,112),2) + ', ' + LEFT(CONVERT(VARCHAR,Q.報價日期,112),4) 轉換列印日期
		                                         FROM (
			                                         SELECT 序號
				                                           ,min_1 
				                                           ,CASE WHEN Q.美元單價 > 0 THEN Q.美元單價
						                                         ELSE Q.台幣單價 END 列印單價
			                                         FROM QUAH Q 
			                                         Where Q.報價單號 = @QUAH_NO
			                                         UNION ALL 
			                                         SELECT 序號
				                                           ,min_2 min_1
				                                           ,單價_2 列印單價
			                                         FROM QUAH Q 
			                                         WHERE Q.min_2 != 0
			                                         AND Q.報價單號 = @QUAH_NO
			                                         UNION ALL 
			                                         SELECT 序號
				                                           ,min_3 min_1
				                                           ,單價_3 列印單價
			                                         FROM QUAH Q 
			                                         WHERE Q.min_3 != 0
			                                         AND Q.報價單號 = @QUAH_NO 
			                                         UNION ALL 
			                                         SELECT 序號
				                                           ,min_4 min_1
				                                           ,單價_4 列印單價
			                                         FROM QUAH Q 
			                                         WHERE Q.min_4 != 0
			                                         AND Q.報價單號 = @QUAH_NO ) TMP
		                                        JOIN QUAH Q ON TMP.序號 = Q.序號
		                                        INNER JOIN BYR B ON Q.客戶編號=B.客戶編號 
		                                        LEFT JOIN QUAHM C ON Q.報價單號=C.報價單號 
		                                        INNER JOIN BYRLU D ON Q.PRICE_SEQ=D.序號
		                                        ORDER BY Q.頤坊型號, Q.min_1 ";

                                cmd.Parameters.AddWithValue("QUAH_NO", context.Request["QUAH_NO"]);
                                cmd.Parameters.AddWithValue("DELV_DAYS", context.Request["DELV_DAYS"]);
                                cmd.Parameters.AddWithValue("SIGN", context.Request["SIGN"]);

                                SqlDataAdapter sqlData = new SqlDataAdapter(cmd);
                                sqlData.Fill(dt);

                                if (dt != null && dt.Rows.Count > 0)
                                {
                                    string rptDir = "~/DEV/Quote/Rpt/Quote_BASE.rpt";
                                    switch (context.Request["RPT_TYPE"])
                                    {
                                        case "0":
                                            rptDir = "~/DEV/Quote/Rpt/Quote_BASE.rpt";
                                            break;
                                        case "1":
                                            rptDir = "~/DEV/Quote/Rpt/Quote_IMG.rpt";
                                            break;

                                    }

                                    ReportDocument rptDoc = new ReportDocument();
                                    rptDoc.Load(context.Server.MapPath(rptDir));
                                    rptDoc.SetDataSource(dt);
                                    System.IO.Stream stream = rptDoc.ExportToStream(CrystalDecisions.Shared.ExportFormatType.PortableDocFormat);
                                    byte[] bytes = new byte[stream.Length];
                                    stream.Read(bytes, 0, bytes.Length);
                                    stream.Seek(0, System.IO.SeekOrigin.Begin);

                                    string filename = "QUAH_RPT.pdf";
                                    context.Response.ClearContent();
                                    context.Response.ClearHeaders();
                                    context.Response.AddHeader("content-disposition", "attachment;filename=" + filename);
                                    context.Response.ContentType = "application/pdf";
                                    context.Response.OutputStream.Write(bytes, 0, bytes.Length);
                                    context.Response.Flush();
                                    context.Response.End();
                                }
                                else
                                {
                                    context.Response.StatusCode = 204;
                                    context.Response.End();
                                }
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



