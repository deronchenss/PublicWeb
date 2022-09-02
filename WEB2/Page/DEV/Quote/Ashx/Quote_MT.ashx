<%@ WebHandler Language = "C#" Class="Quote_MT" %>

using System.Collections.Generic;
using System.Web;
using System.Web.SessionState;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;
using System.Web.Script.Serialization;
using Newtonsoft.Json;
using CrystalDecisions.CrystalReports.Engine;

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
                                cmd.CommandText = @" SELECT TOP 500 Quah.報價單號, CONVERT(VARCHAR, Quah.報價日期, 23) 報價日期, Quah.客戶簡稱, Quah.頤坊型號, Quah.單位
                                                            ,IIF(Quah.美元單價 = 0, NULL, Quah.美元單價) 美元單價, IIF(Quah.台幣單價=0,NULL, Quah.台幣單價) 台幣單價
                                                            ,IIF(Quah.MIN_1 = 0, NULL, Quah.MIN_1) 基本量_1
                                                            ,產品說明, 單位, 廠商編號, 廠商簡稱,客戶編號
                                                            ,IIF(Quah.MIN_2 = 0, NULL, Quah.MIN_2) 基本量_2
                                                            ,IIF(Quah.MIN_3 = 0, NULL, Quah.MIN_3) 基本量_3
                                                            ,IIF(Quah.MIN_4 = 0, NULL, Quah.MIN_4) 基本量_4
                                                            ,IIF(Quah.單價_2 = 0, NULL, Quah.單價_2) 單價_2
                                                            ,IIF(Quah.單價_3 = 0, NULL, Quah.單價_3) 單價_3
                                                            ,IIF(Quah.單價_4 = 0, NULL, Quah.單價_4) 單價_4
                                                            ,CASE Quah.S_FROM WHEN 1 THEN '台灣'
                                                                              ELSE '中國' END 出貨地
                                                            , Quah.序號, Quah.更新人員, CONVERT(VARCHAR, Quah.更新日期, 23) 更新日期
                                                            ,ISNULL(quahm.大備註,'') 大備註
                                                            ,BYRLU_SEQ
                                                     FROM Dc2..Quah 
                                                     LEFT JOIN quahm ON Quah.報價單號 = quahm.報價單號
                                                     WHERE Quah.[頤坊型號] LIKE @IVAN_TYPE + '%'
                                                     AND Quah.[客戶編號] LIKE @CUST_NO + '%'
                                                     AND Quah.[客戶簡稱] LIKE '%' + @CUST_S_NAME + '%'
                                                     AND Quah.[報價單號] LIKE @QUAH_NO + '%'
                                                     AND Quah.[廠商編號] LIKE @FACT_NO + '%'
                                                     AND Quah.[廠商簡稱] LIKE '%' + @FACT_S_NAME + '%'
                                                     AND Quah.[產品說明] LIKE '%' + @PROD_DES + '%'
                                              ";

                                if (!string.IsNullOrEmpty(context.Request["QUAH_DATE_E"]))
                                {
                                    cmd.CommandText += " AND CONVERT(DATE,[報價日期]) <= @QUAH_DATE_E";
                                }
                                if (!string.IsNullOrEmpty(context.Request["QUAH_DATE_S"]))
                                {
                                    cmd.CommandText += " AND CONVERT(DATE,[報價日期]) >= @QUAH_DATE_S";
                                }

                                cmd.Parameters.AddWithValue("IVAN_TYPE", context.Request["IVAN_TYPE"]);
                                cmd.Parameters.AddWithValue("QUAH_DATE_S", context.Request["QUAH_DATE_S"]);
                                cmd.Parameters.AddWithValue("QUAH_DATE_E", context.Request["QUAH_DATE_E"]);
                                cmd.Parameters.AddWithValue("CUST_NO", context.Request["CUST_NO"]);
                                cmd.Parameters.AddWithValue("CUST_S_NAME", context.Request["CUST_S_NAME"]);
                                cmd.Parameters.AddWithValue("QUAH_NO", context.Request["QUAH_NO"]);
                                cmd.Parameters.AddWithValue("FACT_NO", context.Request["FACT_NO"]);
                                cmd.Parameters.AddWithValue("FACT_S_NAME", context.Request["FACT_S_NAME"]);
                                cmd.Parameters.AddWithValue("PROD_DES", context.Request["PROD_DES"]);
                                break;
                            case "UPD_RPT_REMARK":

                                cmd.CommandText = @" DELETE FROM quahm WHERE [報價單號] = @QUAH_NO
                                                     INSERT INTO [dbo].[quahm]
                                                     SELECT (Select IsNull(Max(序號),0)+1 From quahm) [序號] 
                                                             ,@QUAH_NO 報價單號
                                                             ,@RPT_REMARK 大備註
                                                             ,null 變更日期
                                                             ,@UPD_USER [更新人員]
                                                             ,GETDATE() [更新日期] ";
                                cmd.Parameters.Clear();
                                cmd.Parameters.AddWithValue("QUAH_NO", context.Request["QUAH_NO"]);
                                cmd.Parameters.AddWithValue("RPT_REMARK", context.Request["RPT_REMARK"]);
                                cmd.Parameters.AddWithValue("UPD_USER", "IVAN");

                                context.Response.StatusCode = cmd.ExecuteNonQuery() > 0 ?  200 : 404;
                                context.Response.End();
                                break;

                            case "UPD_QUAH":

                                cmd.CommandText = @" UPDATE [dbo].[quah]
                                                        SET [報價單號] = @QUAH_NO
                                                            ,[報價日期] = @QUAH_DATE
                                                            ,[客戶編號] = @CUST_NO
                                                            ,[客戶簡稱] = @CUST_S_NAME
                                                            ,[頤坊型號] = @IVAN_TYPE
                                                            ,[產品說明] = @PROD_DESC
                                                            ,[單位] = @UNIT
                                                            ,[美元單價] = IIF(@USD = '', 0,CONVERT(DECIMAL(18,3),@USD))
                                                            ,[台幣單價] = IIF(@NTD = '', 0,CONVERT(DECIMAL(18,3),@NTD))
                                                            ,[單價_2] = IIF(@PRICE_2 = '', 0,CONVERT(DECIMAL(18,3),@PRICE_2))
                                                            ,[單價_3] = IIF(@PRICE_3 = '', 0,CONVERT(DECIMAL(18,3),@PRICE_3))
                                                            ,[單價_4] = IIF(@PRICE_4 = '', 0,CONVERT(DECIMAL(18,3),@PRICE_4))
                                                            ,[min_1] = IIF(@MIN_1 = '', 0,CONVERT(DECIMAL,@MIN_1))
                                                            ,[min_2] = IIF(@MIN_2 = '', 0,CONVERT(DECIMAL,@MIN_2))
                                                            ,[min_3] = IIF(@MIN_3 = '', 0,CONVERT(DECIMAL,@MIN_3))
                                                            ,[min_4] = IIF(@MIN_4 = '', 0,CONVERT(DECIMAL,@MIN_4))
                                                            ,[S_FROM] = @S_FROM
                                                            ,[廠商編號] = @FACT_NO
                                                            ,[廠商簡稱] = @FACT_S_NAME
                                                            ,[變更日期] = GETDATE()
                                                            ,[更新人員] = @UPD_USER
                                                            ,[更新日期] = GETDATE()
                                                        WHERE [序號] = @SEQ ";
                                cmd.Parameters.Clear();
                                cmd.Parameters.AddWithValue("SEQ", context.Request["SEQ"]);
                                cmd.Parameters.AddWithValue("QUAH_NO", context.Request["QUAH_NO"]);
                                cmd.Parameters.AddWithValue("QUAH_DATE", context.Request["QUAH_DATE"]);
                                cmd.Parameters.AddWithValue("CUST_NO", context.Request["CUST_NO"]);
                                cmd.Parameters.AddWithValue("CUST_S_NAME", context.Request["CUST_S_NAME"]);
                                cmd.Parameters.AddWithValue("IVAN_TYPE", context.Request["IVAN_TYPE"]);
                                cmd.Parameters.AddWithValue("PROD_DESC", context.Request["PROD_DESC"]);
                                cmd.Parameters.AddWithValue("UNIT", context.Request["UNIT"]);
                                cmd.Parameters.AddWithValue("USD", context.Request["USD"]);
                                cmd.Parameters.AddWithValue("NTD", context.Request["NTD"]);
                                cmd.Parameters.AddWithValue("PRICE_2", context.Request["PRICE_2"]);
                                cmd.Parameters.AddWithValue("PRICE_3", context.Request["PRICE_3"]);
                                cmd.Parameters.AddWithValue("PRICE_4", context.Request["PRICE_4"]);
                                cmd.Parameters.AddWithValue("MIN_1", context.Request["MIN_1"]);
                                cmd.Parameters.AddWithValue("MIN_2", context.Request["MIN_2"]);
                                cmd.Parameters.AddWithValue("MIN_3", context.Request["MIN_3"]);
                                cmd.Parameters.AddWithValue("MIN_4", context.Request["MIN_4"]);
                                cmd.Parameters.AddWithValue("S_FROM", context.Request["S_FROM"]);
                                cmd.Parameters.AddWithValue("FACT_NO", context.Request["FACT_NO"]);
                                cmd.Parameters.AddWithValue("FACT_S_NAME", context.Request["FACT_S_NAME"]);
                                cmd.Parameters.AddWithValue("UPD_USER", "IVAN");

                                context.Response.StatusCode = cmd.ExecuteNonQuery() == 1 ? 200 : 404;
                                context.Response.End();
                                break;
                        }

                        SqlDataAdapter sqlData = new SqlDataAdapter(cmd);
                        sqlData.Fill(dt);

                        var json = JsonConvert.SerializeObject(dt);
                        context.Response.ContentType = "text/json";
                        context.Response.Write(json);
                    }
                }
            }
            catch (SqlException ex)
            {
                context.Response.StatusCode = 404;
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



