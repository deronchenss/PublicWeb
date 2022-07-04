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
                int res = 0;

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
                                cmd.CommandText = @" SELECT TOP 500 pudu.[序號]
                                                                  ,pudu.[採購單號]
                                                                  ,CONVERT(VARCHAR,pudu.[採購日期],23) 採購日期
                                                                  ,pudu.[樣品號碼]
                                                                  ,pudu.[工作類別]
                                                                  ,pudu.[廠商編號]
                                                                  ,pudu.[廠商簡稱]
                                                                  ,pudu.[頤坊型號]
                                                                  ,pudu.[暫時型號]
                                                                  ,pudu.[廠商型號]
                                                                  ,pudu.[產品說明]
                                                                  ,pudu.[單位]
                                                                  ,IIF(pudu.[台幣單價] = 0, NULL, pudu.[台幣單價]) 台幣單價
                                                                  ,IIF(pudu.[美元單價] = 0, NULL, pudu.[美元單價]) 美元單價
                                                                  ,IIF(pudu.[人民幣單價] = 0, NULL, pudu.[人民幣單價]) 人民幣單價
                                                                  ,IIF(pudu.[單價_2] = 0, NULL, pudu.[單價_2]) 單價_2
                                                                  ,IIF(pudu.[單價_3] = 0, NULL, pudu.[單價_3]) 單價_3
                                                                  ,IIF(pudu.[MIN_1] = 0, NULL, pudu.[MIN_1]) 基本量_1
                                                                  ,IIF(pudu.[MIN_2] = 0, NULL, pudu.[MIN_2]) 基本量_2
                                                                  ,IIF(pudu.[MIN_3] = 0, NULL, pudu.[MIN_3]) 基本量_3
                                                                  ,pudu.[外幣幣別]
                                                                  ,pudu.[外幣單價]
                                                                  ,pudu.[外幣單價_2]
                                                                  ,pudu.[外幣單價_3]
                                                                  ,pudu.[採購數量]
                                                                  ,CONVERT(VARCHAR,pudu.[採購交期],23) [採購交期]
                                                                  ,pudu.[交期狀況]
                                                                  ,pudu.[點收批號]
                                                                  ,pudu.[點收數量]
                                                                  ,CONVERT(VARCHAR,pudu.[點收日期],23) [點收日期]
                                                                  ,pudu.[到貨數量]
                                                                  ,CONVERT(VARCHAR,pudu.[出貨日期],23) [出貨日期]
                                                                  ,CONVERT(VARCHAR,pudu.[到貨日期],23) [到貨日期]
                                                                  ,pudu.[運輸編號]
                                                                  ,pudu.[運輸簡稱]
                                                                  ,pudu.[訂單數量]
                                                                  ,pudu.[客戶編號]
                                                                  ,pudu.[客戶簡稱]
                                                                  ,pudu.[到貨處理] 分配方式
                                                                  ,pudu.[列表小備註]
                                                                  ,pudu.[結案]
                                                                  ,pudu.[強制結案]
                                                                  ,pudu.[運送方式]
                                                                  ,pudu.[部門]
                                                                  ,pudu.[變更日期]
                                                                  ,pudu.[更新人員]
                                                                  ,CONVERT(VARCHAR,pudu.[更新日期],23) [更新日期]
                                                                  ,IIF(pudum.[預付款一] = 0, NULL, pudum.[預付款一]) 預付款一
                                                                  ,CONVERT(VARCHAR,pudum.[預付日一],23) 預付日一
                                                                  ,IIF(pudum.[預付款二] = 0, NULL, pudum.[預付款二]) 預付款二
                                                                  ,CONVERT(VARCHAR,pudum.[預付日二],23) 預付日二
                                                                  ,IIF(pudum.[附加費] = 0, NULL, pudum.[附加費]) 附加費
                                                                  ,pudum.附加費說明
                                                                  ,pudum.大備註一
                                                                  ,pudum.大備註二
                                                                  ,pudum.大備註三
                                                                  ,pudum.特別事項
                                                     FROM Dc2..pudu 
                                                     LEFT JOIN pudum on pudu.採購單號 = pudum.採購單號
                                                     WHERE ISNULL(pudu.[頤坊型號],'') LIKE @IVAN_TYPE + '%'
                                                     AND ISNULL(pudu.[樣品號碼],'') LIKE @SAMPLE_NO + '%'
                                                     AND ISNULL(pudu.[客戶編號],'') LIKE @CUST_NO + '%'
                                                     AND ISNULL(pudu.[客戶簡稱],'') LIKE '%' + @CUST_S_NAME + '%'
                                                     AND ISNULL(pudu.[採購單號],'') LIKE @PUDU_NO + '%'
                                                     AND ISNULL(pudu.[廠商編號],'') LIKE @FACT_NO + '%'
                                                     AND ISNULL(pudu.[廠商簡稱],'') LIKE '%' + @FACT_S_NAME + '%'
                                                     AND ISNULL(pudu.[產品說明],'') LIKE '%' + @PROD_DES + '%'
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
                                                               (序號,[樣品號碼],[工作類別],[廠商編號],[廠商簡稱]
                                                               ,[頤坊型號],[暫時型號],[廠商型號],[產品說明]
                                                               ,[客戶編號],[客戶簡稱],[到貨處理]
                                                               --,[採購單號],[採購日期],[採購數量],[採購交期]
                                                               --,[到貨數量],[出貨日期],[到貨日期]
                                                               --,[點收批號],[點收數量],[點收日期]
                                                               --,[交期狀況],[列表小備註],[單位],[美元單價],[台幣單價]
                                                               --,[單價_2]  ,[單價_3],[min_1] ,[min_2],[min_3] 
                                                               ,[更新人員] ,[更新日期])
                                                         SELECT (Select IsNull(Max(序號),0)+1 From pudu)
                                                               ,@SAMPLE_NO,@WORK_TYPE,@FACT_NO,@FACT_S_NAME
                                                               ,@IVAN_TYPE,@TMP_TYPE,@FACT_TYPE,@PROD_DESC
                                                               ,@CUST_NO,@CUST_S_NAME,@GIVE_WAY
                                                               --,@PUDU_NO,@PUDU_DATE,@PUDU_CNT,@PUDU_GIVE_DATE
                                                               --,@ACC_SHIP_CNT,@GIVE_SHIP_DATE,@ACC_SHIP_DATE
                                                               --,@CHECK_NO,@CHECK_CNT,@CHECK_DATE
                                                               --,@GIVE_STATUS,@RPT_REMARK,@UNIT
                                                               --,IIF(@USD = '', 0,CONVERT(DECIMAL,@USD))
                                                               --,IIF(@NTD = '', 0,CONVERT(DECIMAL,@NTD))
                                                               --,IIF(@PRICE_2 = '', 0,CONVERT(DECIMAL,@PRICE_2))
                                                               --,IIF(@PRICE_3 = '', 0,CONVERT(DECIMAL,@PRICE_3))
                                                               --,IIF(@MIN_1 = '', 0,CONVERT(DECIMAL,@MIN_1))
                                                               --,IIF(@MIN_2 = '', 0,CONVERT(DECIMAL,@MIN_2))
                                                               --,IIF(@MIN_3 = '', 0,CONVERT(DECIMAL,@MIN_3))
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
                                cmd.Parameters.AddWithValue("CUST_NO", context.Request["CUST_NO"]);
                                cmd.Parameters.AddWithValue("CUST_S_NAME", context.Request["CUST_S_NAME"]);
                                cmd.Parameters.AddWithValue("GIVE_WAY", context.Request["GIVE_WAY"]);
                                cmd.Parameters.AddWithValue("UPD_USER", "IVAN");
                                
                                res = cmd.ExecuteNonQuery();
                                context.Response.StatusCode = res == 1 ? 200 : 404;
                                context.Response.End();
                                break;
                            case "SEQ_PURC_SEQ":

                                cmd.CommandText = @" UPDATE pudu SET 採購單號 = N.SEQ
			                                                        ,採購交期 = @PUDU_GIVE_DATE
			                                                        ,採購日期 = GETDATE()
			                                                        ,更新人員 = @UPD_USER
			                                                        ,更新日期 = GETDATE()
                                                     FROM pudu P 
                                                     JOIN (SELECT SUBSTRING(CONVERT(VARCHAR,GETDATE(),111),3,2)
		                                                        + CASE MONTH(GETDATE()) WHEN 10 THEN 'A' WHEN 11 THEN 'B' WHEN 12 THEN 'C' ELSE CONVERT(VARCHAR,MONTH(GETDATE())) END
		                                                        + RIGHT(REPLICATE('0', len(號碼長度)) + CONVERT(VARCHAR,號碼 + ROW_NUMBER() OVER(ORDER BY P.廠商編號 ASC)), len(號碼長度))
		                                                        + 字尾 SEQ, P.廠商編號, P.樣品號碼 
	                                                       FROM nofile N 
	                                                       JOIN (SELECT DISTINCT 廠商編號,樣品號碼 FROM pudu WHERE 樣品號碼 = @SAMPLE_NO) P ON 1 = 1
	                                                       WHERE N.使用者 = @SET_SEQ_USER
	                                                       AND 單據 LIKE '%' + @WORK_TYPE +'%') N ON P.廠商編號 = N.廠商編號 AND P.樣品號碼 = N.樣品號碼

                                                     --更新nofile
                                                     UPDATE nofile 
                                                     SET 年度 = SUBSTRING(CONVERT(VARCHAR,GETDATE(),111),3,2)
	                                                     ,月份 = CONVERT(VARCHAR,MONTH(GETDATE()))
	                                                     ,號碼 = 號碼 + (SELECT COUNT(1) FROM (SELECT 廠商編號 FROM pudu WHERE 樣品號碼 = @SAMPLE_NO GROUP BY 廠商編號) B)
                                                     FROM nofile N
                                                     WHERE N.使用者 = @SET_SEQ_USER
                                                     AND 單據 LIKE '%' + '開發' +'%'  ";

                                cmd.Parameters.AddWithValue("UPD_USER", "IVAN");
                                cmd.Parameters.AddWithValue("SET_SEQ_USER", "IVAN");
                                cmd.Parameters.AddWithValue("SAMPLE_NO", context.Request["SAMPLE_NO"]);
                                cmd.Parameters.AddWithValue("WORK_TYPE", context.Request["WORK_TYPE"]);
                                cmd.Parameters.AddWithValue("PUDU_GIVE_DATE", context.Request["PUDU_GIVE_DATE"]);
                                //特殊需求 如是以下這些人，先以Nancy 撈取號碼 先註解 等UPD_USER 抓session後使用
                                //if (Session["UPD_USER"] == "游佩穎" || Session["UPD_USER"] == "莊智涵" || Session["UPD_USER"] == "智涵" 
                                //    || Session["UPD_USER"] == "冠蓉" || Session["UPD_USER"] == "陳顥翰" || Session["UPD_USER"] == "黃如韻" || Session["UPD_USER"] == "許薇萱")
                                //{
                                //    cmd.Parameters.AddWithValue("SET_SEQ_USER", "IVAN");
                                //}
                                //else
                                //{
                                //    cmd.Parameters.AddWithValue("SET_SEQ_USER", "IVAN");
                                //}

                                res = cmd.ExecuteNonQuery();
                                context.Response.StatusCode = res != 1 ? 200 : 404;
                                context.Response.Write(res);
                                context.Response.End();
                                break;
                            case "GET_IMG":
                                cmd.CommandText = @" SELECT TOP 1 [P_SEQ], [圖檔] [P_IMG]
                                                     FROM [192.168.1.135].pic.dbo.xpic
                                                     WHERE [P_SEQ] = (SELECT TOP 1 P_SEQ FROM byrlu where 廠商編號 = @FACT_NO AND 頤坊型號 = @IVAN_TYPE) ";
                                cmd.Parameters.AddWithValue("FACT_NO", context.Request["FACT_NO"]);
                                cmd.Parameters.AddWithValue("IVAN_TYPE", context.Request["IVAN_TYPE"]);
                                break;
                            case "UPD_RPT_REMARK":

                                cmd.CommandText = @" DELETE FROM pudum WHERE [採購單號] = @PUDU_NO
                                                     INSERT INTO [dbo].[pudum]
                                                     SELECT (Select IsNull(Max(序號),0)+1 From pudum) [序號] 
                                                           ,@PUDU_NO 採購單號
                                                           ,@CURR_CODE 幣別
                                                           ,IIF(@PRE_PAY_AMT_1 = '', 0,CONVERT(DECIMAL,@PRE_PAY_AMT_1)) 預付款一
                                                           ,IIF(@PRE_PAY_DATE_1 = '', NULL, @PRE_PAY_DATE_1) 預付日一
                                                           ,IIF(@PRE_PAY_AMT_2 = '', 0,CONVERT(DECIMAL,@PRE_PAY_AMT_2)) 預付款二
                                                           ,IIF(@PRE_PAY_DATE_2 = '', NULL, @PRE_PAY_DATE_2) 預付日二
                                                           ,null 核銷金額
                                                           ,null 核銷日期
                                                           ,IIF(@ADD_AMT = '', 0,CONVERT(DECIMAL,@ADD_AMT)) 附加費一
                                                           ,@ADD_DESC [附加費說明]
                                                           ,@BIG_REMARK_1 [大備註一]
                                                           ,@BIG_REMARK_2 [大備註二]
                                                           ,@BIG_REMARK_3 [大備註三]
                                                           ,@SPEC_REMARK [特別事項]
                                                           ,null 變更日期
                                                           ,@UPD_USER [更新人員]
                                                           ,GETDATE() [更新日期] ";
                                cmd.Parameters.Clear();
                                cmd.Parameters.AddWithValue("PUDU_NO", context.Request["PUDU_NO"]);
                                cmd.Parameters.AddWithValue("CURR_CODE", context.Request["CURR_CODE"]);
                                cmd.Parameters.AddWithValue("PRE_PAY_AMT_1", context.Request["PRE_PAY_AMT_1"]);
                                cmd.Parameters.AddWithValue("PRE_PAY_DATE_1", context.Request["PRE_PAY_DATE_1"]);
                                cmd.Parameters.AddWithValue("PRE_PAY_AMT_2", context.Request["PRE_PAY_AMT_2"]);
                                cmd.Parameters.AddWithValue("PRE_PAY_DATE_2", context.Request["PRE_PAY_DATE_2"]);
                                cmd.Parameters.AddWithValue("ADD_AMT", context.Request["ADD_AMT"]);
                                cmd.Parameters.AddWithValue("ADD_DESC", context.Request["ADD_DESC"]);
                                cmd.Parameters.AddWithValue("BIG_REMARK_1", context.Request["BIG_REMARK_1"]);
                                cmd.Parameters.AddWithValue("BIG_REMARK_2", context.Request["BIG_REMARK_2"]);
                                cmd.Parameters.AddWithValue("BIG_REMARK_3", context.Request["BIG_REMARK_3"]);
                                cmd.Parameters.AddWithValue("SPEC_REMARK", context.Request["SPEC_REMARK"]);
                                cmd.Parameters.AddWithValue("UPD_USER", "IVAN");

                                context.Response.StatusCode = cmd.ExecuteNonQuery() > 0 ? 200 : 404;
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



