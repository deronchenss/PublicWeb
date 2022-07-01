<%@ WebHandler Language = "C#" Class="Sample_MT" %>

using System.Collections.Generic;
using System.Web;
using System.Web.SessionState;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;
using System.Web.Script.Serialization;
using Newtonsoft.Json;
using CrystalDecisions.CrystalReports.Engine;

public class Sample_MT : IHttpHandler, IRequiresSessionState
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
                            case "Sample_Base":
                                cmd.CommandText = @" SELECT TOP 500 [序號]
                                                                  ,[採購單號]
                                                                  ,CONVERT(VARCHAR,[採購日期],23) 採購日期
                                                                  ,[樣品號碼]
                                                                  ,[工作類別]
                                                                  ,[廠商編號]
                                                                  ,[廠商簡稱]
                                                                  ,[頤坊型號]
                                                                  ,[暫時型號]
                                                                  ,[廠商型號]
                                                                  ,[產品說明]
                                                                  ,[單位]
                                                                  ,IIF([台幣單價] = 0, NULL, [台幣單價]) 台幣單價
                                                                  ,IIF([美元單價] = 0, NULL, [美元單價]) 美元單價
                                                                  ,IIF([人民幣單價] = 0, NULL, [人民幣單價]) 人民幣單價
                                                                  ,IIF([單價_2] = 0, NULL, [單價_2]) 單價_2
                                                                  ,IIF([單價_3] = 0, NULL, [單價_3]) 單價_3
                                                                  ,IIF([MIN_1] = 0, NULL, [MIN_1]) 基本量_1
                                                                  ,IIF([MIN_2] = 0, NULL, [MIN_2]) 基本量_2
                                                                  ,IIF([MIN_3] = 0, NULL, [MIN_3]) 基本量_3
                                                                  ,[外幣幣別]
                                                                  ,[外幣單價]
                                                                  ,[外幣單價_2]
                                                                  ,[外幣單價_3]
                                                                  ,[採購數量]
                                                                  ,CONVERT(VARCHAR,[採購交期],23) [採購交期]
                                                                  ,[交期狀況]
                                                                  ,[點收批號]
                                                                  ,[點收數量]
                                                                  ,CONVERT(VARCHAR,[點收日期],23) [點收日期]
                                                                  ,[到貨數量]
                                                                  ,CONVERT(VARCHAR,[出貨日期],23) [出貨日期]
                                                                  ,CONVERT(VARCHAR,[到貨日期],23) [到貨日期]
                                                                  ,[運輸編號]
                                                                  ,[運輸簡稱]
                                                                  ,[訂單數量]
                                                                  ,[客戶編號]
                                                                  ,[客戶簡稱]
                                                                  ,[到貨處理] 分配方式
                                                                  ,[列表小備註]
                                                                  ,[結案]
                                                                  ,[強制結案]
                                                                  ,[運送方式]
                                                                  ,[部門]
                                                                  ,[變更日期]
                                                                  ,[更新人員]
                                                                  ,CONVERT(VARCHAR,[更新日期],23) [更新日期]
                                                     FROM Dc2..pudu 
                                                     WHERE pudu.[頤坊型號] LIKE @IVAN_TYPE + '%'
                                                     AND pudu.[樣品號碼] LIKE @SAMPLE_NO + '%'
                                                     AND pudu.[客戶編號] LIKE @CUST_NO + '%'
                                                     AND pudu.[客戶簡稱] LIKE '%' + @CUST_S_NAME + '%'
                                                     AND pudu.[採購單號] LIKE @PUDU_NO + '%'
                                                     AND pudu.[廠商編號] LIKE @FACT_NO + '%'
                                                     AND pudu.[廠商簡稱] LIKE '%' + @FACT_S_NAME + '%'
                                                     AND pudu.[產品說明] LIKE '%' + @PROD_DES + '%'
                                              ";

                                if (!string.IsNullOrEmpty(context.Request["PUDU_DATE_E"]))
                                {
                                    cmd.CommandText += " AND CONVERT(DATE,[採購日期]) <= @PUDU_DATE_E";
                                }
                                if (!string.IsNullOrEmpty(context.Request["PUDU_DATE_S"]))
                                {
                                    cmd.CommandText += " AND CONVERT(DATE,[採購日期]) >= @PUDU_DATE_S";
                                }

                                cmd.Parameters.AddWithValue("IVAN_TYPE", context.Request["IVAN_TYPE"]);
                                cmd.Parameters.AddWithValue("PUDU_DATE_S", context.Request["PUDU_DATE_S"]);
                                cmd.Parameters.AddWithValue("PUDU_DATE_E", context.Request["PUDU_DATE_E"]);
                                cmd.Parameters.AddWithValue("CUST_NO", context.Request["CUST_NO"]);
                                cmd.Parameters.AddWithValue("CUST_S_NAME", context.Request["CUST_S_NAME"]);
                                cmd.Parameters.AddWithValue("SAMPLE_NO", context.Request["SAMPLE_NO"]);
                                cmd.Parameters.AddWithValue("PUDU_NO", context.Request["PUDU_NO"]);
                                cmd.Parameters.AddWithValue("FACT_NO", context.Request["FACT_NO"]);
                                cmd.Parameters.AddWithValue("FACT_S_NAME", context.Request["FACT_S_NAME"]);
                                cmd.Parameters.AddWithValue("PROD_DES", context.Request["PROD_DES"]);
                                break;
                            case "INSERT_SAMPLE":
                            case "UPD_SAMPLE":

                                if(context.Request["Call_Type"] == "UPD_SAMPLE")
                                {
                                    cmd.CommandText = @" UPDATE [dbo].[pudu]
                                                        SET [採購單號] = @PUDU_NO
                                                           ,[採購日期] = @PUDU_DATE
                                                           ,[樣品號碼] = @SAMPLE_NO
                                                           ,[工作類別] = @WORK_TYPE
                                                           ,[廠商編號] = @FACT_NO
                                                           ,[廠商簡稱] = @FACT_S_NAME
                                                           ,[頤坊型號] = @IVAN_TYPE
                                                           ,[暫時型號] = @TMP_TYPE
                                                           ,[廠商型號] = @FACT_TYPE
                                                           ,[產品說明] = @PROD_DESC
                                                           ,[採購數量] = @PUDU_CNT
                                                           ,[採購交期] = @PUDU_GIVE_DATE
                                                           ,[交期狀況] = @GIVE_STATUS
                                                           ,[點收批號] = @CHECK_NO
                                                           ,[點收數量] = @CHECK_CNT
                                                           ,[點收日期] = @CHECK_DATE
                                                           ,[到貨數量] = @ACC_SHIP_CNT
                                                           ,[出貨日期] = @GIVE_SHIP_DATE
                                                           ,[到貨日期] = @ACC_SHIP_DATE
                                                           ,[客戶編號] = @CUST_NO
                                                           ,[客戶簡稱] = @CUST_S_NAME
                                                           ,[到貨處理] = @GIVE_WAY
                                                           ,[列表小備註] = @RPT_REMARK
                                                           ,[單位] = @UNIT
                                                           ,[美元單價] = IIF(@USD = '', 0,CONVERT(DECIMAL,@USD))
                                                           ,[台幣單價] = IIF(@NTD = '', 0,CONVERT(DECIMAL,@NTD))
                                                           ,[單價_2] = IIF(@PRICE_2 = '', 0,CONVERT(DECIMAL,@PRICE_2))
                                                           ,[單價_3] = IIF(@PRICE_3 = '', 0,CONVERT(DECIMAL,@PRICE_3))
                                                           ,[min_1] = IIF(@MIN_1 = '', 0,CONVERT(DECIMAL,@MIN_1))
                                                           ,[min_2] = IIF(@MIN_2 = '', 0,CONVERT(DECIMAL,@MIN_2))
                                                           ,[min_3] = IIF(@MIN_3 = '', 0,CONVERT(DECIMAL,@MIN_3))
                                                           ,[更新人員] = @UPD_USER
                                                           ,[更新日期] = GETDATE()
                                                        WHERE [序號] = @SEQ ";
                                }
                                else
                                {
                                    cmd.CommandText = @" INSERT INTO [dbo].[pudu]
                                                               (序號
                                                               ,[採購單號],[採購日期],[樣品號碼],[工作類別],[廠商編號]
                                                               ,[廠商簡稱],[頤坊型號],[暫時型號],[廠商型號],[產品說明]
                                                               ,[採購數量],[採購交期],[交期狀況],[點收批號],[點收數量]
                                                               ,[點收日期],[到貨數量],[出貨日期],[到貨日期] ,[客戶編號]
                                                               ,[客戶簡稱],[到貨處理],[列表小備註],[單位]
                                                               ,[美元單價] ,[台幣單價] ,[單價_2]  ,[單價_3],[min_1] ,[min_2] 
                                                               ,[min_3] ,[更新人員] ,[更新日期])
                                                         SELECT (Select IsNull(Max(序號),0)+1 From pudu), @PUDU_NO
                                                               ,@PUDU_DATE,@SAMPLE_NO,@WORK_TYPE,@FACT_NO,@FACT_S_NAME
                                                               ,@IVAN_TYPE,@TMP_TYPE,@FACT_TYPE,@PROD_DESC
                                                               ,@PUDU_CNT,@PUDU_GIVE_DATE,@GIVE_STATUS
                                                               ,@CHECK_NO,@CHECK_CNT,@CHECK_DATE,@ACC_SHIP_CNT
                                                               ,@GIVE_SHIP_DATE,@ACC_SHIP_DATE,@CUST_NO
                                                               ,@CUST_S_NAME,@GIVE_WAY,@RPT_REMARK,@UNIT
                                                               ,IIF(@USD = '', 0,CONVERT(DECIMAL,@USD))
                                                               ,IIF(@NTD = '', 0,CONVERT(DECIMAL,@NTD))
                                                               ,IIF(@PRICE_2 = '', 0,CONVERT(DECIMAL,@PRICE_2))
                                                               ,IIF(@PRICE_3 = '', 0,CONVERT(DECIMAL,@PRICE_3))
                                                               ,IIF(@MIN_1 = '', 0,CONVERT(DECIMAL,@MIN_1))
                                                               ,IIF(@MIN_2 = '', 0,CONVERT(DECIMAL,@MIN_2))
                                                               ,IIF(@MIN_3 = '', 0,CONVERT(DECIMAL,@MIN_3))
                                                               ,@UPD_USER, GETDATE() ";
                                }
                                
                                cmd.Parameters.Clear();
                                cmd.Parameters.AddWithValue("SEQ", context.Request["SEQ"]);
                                cmd.Parameters.AddWithValue("SAMPLE_NO", context.Request["SAMPLE_NO"]);
                                cmd.Parameters.AddWithValue("IVAN_TYPE", context.Request["IVAN_TYPE"]);
                                cmd.Parameters.AddWithValue("FACT_NO", context.Request["FACT_NO"]);
                                cmd.Parameters.AddWithValue("FACT_S_NAME", context.Request["FACT_S_NAME"]);
                                cmd.Parameters.AddWithValue("TMP_TYPE", context.Request["TMP_TYPE"]);
                                cmd.Parameters.AddWithValue("FACT_TYPE", context.Request["FACT_TYPE"]);
                                cmd.Parameters.AddWithValue("PROD_DESC", context.Request["PROD_DESC"]);
                                cmd.Parameters.AddWithValue("WORK_TYPE", context.Request["WORK_TYPE"]);
                                cmd.Parameters.AddWithValue("RPT_REMARK", context.Request["RPT_REMARK"]);
                                cmd.Parameters.AddWithValue("PUDU_NO", context.Request["PUDU_NO"]);
                                cmd.Parameters.AddWithValue("PUDU_DATE", context.Request["PUDU_DATE"]);
                                cmd.Parameters.AddWithValue("PUDU_CNT", context.Request["PUDU_CNT"]);
                                cmd.Parameters.AddWithValue("PUDU_GIVE_DATE", context.Request["PUDU_GIVE_DATE"]);
                                cmd.Parameters.AddWithValue("CUST_NO", context.Request["CUST_NO"]);
                                cmd.Parameters.AddWithValue("CUST_S_NAME", context.Request["CUST_S_NAME"]);
                                cmd.Parameters.AddWithValue("GIVE_STATUS", context.Request["GIVE_STATUS"]);
                                cmd.Parameters.AddWithValue("GIVE_WAY", context.Request["GIVE_WAY"]);
                                cmd.Parameters.AddWithValue("CHECK_NO", context.Request["CHECK_NO"]);
                                cmd.Parameters.AddWithValue("CHECK_DATE", context.Request["CHECK_DATE"]);
                                cmd.Parameters.AddWithValue("CHECK_CNT", context.Request["CHECK_CNT"]);
                                cmd.Parameters.AddWithValue("ACC_SHIP_CNT", context.Request["ACC_SHIP_CNT"]);
                                cmd.Parameters.AddWithValue("GIVE_SHIP_DATE", context.Request["GIVE_SHIP_DATE"]);
                                cmd.Parameters.AddWithValue("ACC_SHIP_DATE", context.Request["ACC_SHIP_DATE"]);
                                cmd.Parameters.AddWithValue("UNIT", context.Request["UNIT"]);
                                cmd.Parameters.AddWithValue("USD", context.Request["USD"]);
                                cmd.Parameters.AddWithValue("NTD", context.Request["NTD"]);
                                cmd.Parameters.AddWithValue("PRICE_2", context.Request["PRICE_2"]);
                                cmd.Parameters.AddWithValue("PRICE_3", context.Request["PRICE_3"]);
                                cmd.Parameters.AddWithValue("MIN_1", context.Request["MIN_1"]);
                                cmd.Parameters.AddWithValue("MIN_2", context.Request["MIN_2"]);
                                cmd.Parameters.AddWithValue("MIN_3", context.Request["MIN_3"]);
                                cmd.Parameters.AddWithValue("UPD_USER", "IVAN");

                                int res = cmd.ExecuteNonQuery();
                                context.Response.StatusCode = res == 1 ? 200 : 404;
                                context.Response.End();
                                break;
                            case "GET_IMG":
                                cmd.CommandText = @" SELECT TOP 1 [P_SEQ], [圖檔] [P_IMG]
                                                     FROM [192.168.1.135].pic.dbo.xpic
                                                     WHERE [P_SEQ] = (SELECT TOP 1 P_SEQ FROM byrlu where 廠商編號 = @FACT_NO AND 頤坊型號 = @IVAN_TYPE) ";
                                cmd.Parameters.AddWithValue("FACT_NO", context.Request["FACT_NO"]);
                                cmd.Parameters.AddWithValue("IVAN_TYPE", context.Request["IVAN_TYPE"]);
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



