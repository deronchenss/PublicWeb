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
                                                                  ,pudu.SUPLU_SEQ
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
                                                                  ,IIF(pudu.[採購數量] = 0, NULL, pudu.[採購數量]) 採購數量
                                                                  ,CONVERT(VARCHAR,pudu.[採購交期],23) [採購交期]
                                                                  ,pudu.[交期狀況]
                                                                  ,RA.[點收批號]
                                                                  ,IIF(SUM(ISNULL(RA.[點收數量],0)) = 0, NULL, SUM(ISNULL(RA.[點收數量],0))) 點收數量
                                                                  ,CONVERT(VARCHAR,RA.[點收日期],23) [點收日期]
                                                                  ,IIF(SUM(ISNULL(R.[到貨數量],0)) = 0 ,NULL,SUM(ISNULL(R.[到貨數量],0))) 到貨數量
                                                                  ,CONVERT(VARCHAR,R.[出貨日期],23) [出貨日期]
                                                                  ,CONVERT(VARCHAR,R.[到貨日期],23) [到貨日期]
                                                                  ,RA.[運輸編號]
                                                                  ,RA.[運輸簡稱]
                                                                  ,pudu.[訂單數量]
                                                                  ,pudu.[客戶編號]
                                                                  ,pudu.[客戶簡稱]
                                                                  ,pudu.[到貨處理] 分配方式
                                                                  ,pudu.[列表小備註]
                                                                  ,pudu.[結案]
                                                                  ,IIF(pudu.[強制結案] = 1, '是', '') 強制結案
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
                                                     LEFT JOIN RECUA RA ON pudu.序號 = RA.PUDU_SEQ
                                                     LEFT JOIN RECU R ON pudu.序號 = R.PUDU_SEQ
                                                     WHERE ISNULL(pudu.[頤坊型號],'') LIKE @IVAN_TYPE + '%'
                                                     AND ISNULL(pudu.[樣品號碼],'') LIKE @SAMPLE_NO + '%'
                                                     AND ISNULL(pudu.[客戶編號],'') LIKE @CUST_NO + '%'
                                                     AND ISNULL(pudu.[客戶簡稱],'') LIKE '%' + @CUST_S_NAME + '%'
                                                     AND ISNULL(pudu.[採購單號],'') LIKE @PUDU_NO + '%'
                                                     AND ISNULL(pudu.[廠商編號],'') LIKE @FACT_NO + '%'
                                                     AND ISNULL(pudu.[廠商簡稱],'') LIKE '%' + @FACT_S_NAME + '%'
                                                     AND ISNULL(pudu.[產品說明],'') LIKE '%' + @PROD_DES + '%'
                                                     AND 強制結案 LIKE '%' + @WRITE_OFF + '%'
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
                                cmd.Parameters.AddWithValue("WRITE_OFF", context.Request["WRITE_OFF"]);

                                cmd.CommandText += @" GROUP BY pudu.[序號],pudu.[SUPLU_SEQ],pudu.[採購單號],pudu.[採購日期],pudu.[樣品號碼]
                                                              ,pudu.[工作類別],pudu.[廠商編號],pudu.[廠商簡稱],pudu.[頤坊型號]
                                                              ,pudu.[暫時型號],pudu.[廠商型號],pudu.[產品說明],pudu.[單位]
                                                              ,pudu.[台幣單價],pudu.[美元單價],pudu.[人民幣單價],pudu.[單價_2]
                                                              ,pudu.[單價_3],pudu.[MIN_1],pudu.[MIN_2],pudu.[MIN_3]
                                                              ,pudu.[外幣幣別],pudu.[外幣單價],pudu.[外幣單價_2]
                                                              ,pudu.[外幣單價_3],pudu.[採購數量],pudu.[採購交期]
                                                              ,pudu.[交期狀況],RA.[點收批號],RA.[點收日期]
                                                              ,R.[出貨日期],R.[到貨日期],RA.[運輸編號],RA.[運輸簡稱]
                                                              ,pudu.[訂單數量],pudu.[客戶編號],pudu.[客戶簡稱]
                                                              ,pudu.[到貨處理],pudu.[列表小備註],pudu.[結案]
                                                              ,pudu.[強制結案],pudu.[運送方式],pudu.[部門]
                                                              ,pudu.[變更日期],pudu.[更新人員],pudu.[更新日期],pudum.[預付款一]
                                                              ,pudum.[預付日一],pudum.[預付款二],pudum.[預付日二]
                                                              ,pudum.[附加費],pudum.附加費說明
                                                              ,pudum.大備註一,pudum.大備註二,pudum.大備註三,pudum.特別事項";

                                break;
                            case "INSERT_SAMPLE":
                            case "UPD_SAMPLE":
                                cmd.Parameters.Clear();

                                if (context.Request["Call_Type"] == "UPD_SAMPLE")
                                {
                                    cmd.CommandText = @" UPDATE [dbo].[pudu]
                                                         SET SUPLU_SEQ = @SUPLU_SEQ
                                                            ,[採購單號] = @PUDU_NO
                                                            ,[採購日期] = @PUDU_DATE
                                                            ,[樣品號碼] = @SAMPLE_NO
                                                            ,[強制結案] = @FORCE_CLOSE
                                                            ,[結案] = CASE WHEN @FORCE_CLOSE = 1 THEN 1 ELSE 結案 END
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
                                                            ,[外幣幣別] = @FORE_CODE
                                                            ,[外幣單價] = IIF(@FORE_AMT = '', 0,CONVERT(DECIMAL,@FORE_AMT))
                                                            ,[更新人員] = @UPD_USER
                                                            ,[變更日期] = GETDATE()
                                                         WHERE [序號] = @SEQ 

                                            --增加回報COST
                                            IF(@WORK_TYPE like '%詢%' AND @AMT_CHANGE = 1)
									        BEGIN
										        UPDATE SUPLU
                                                SET [美元單價] = IIF(@USD = '', 0,CONVERT(DECIMAL,@USD))
                                                   ,[台幣單價] = IIF(@NTD = '', 0,CONVERT(DECIMAL,@NTD))
                                                   ,[單價_2] = IIF(@PRICE_2 = '', 0,CONVERT(DECIMAL,@PRICE_2))
                                                   ,[單價_3] = IIF(@PRICE_3 = '', 0,CONVERT(DECIMAL,@PRICE_3))
                                                   ,[min_1] = IIF(@MIN_1 = '', 0,CONVERT(DECIMAL,@MIN_1))
                                                   ,[min_2] = IIF(@MIN_2 = '', 0,CONVERT(DECIMAL,@MIN_2))
                                                   ,[min_3] = IIF(@MIN_3 = '', 0,CONVERT(DECIMAL,@MIN_3))
                                                   ,[外幣幣別] = @FORE_CODE
                                                   ,[外幣單價] = IIF(@FORE_AMT = '', 0,CONVERT(DECIMAL,@FORE_AMT))
                                                   ,更新人員 = @UPD_USER
                                                WHERE [序號] = @SUPLU_SEQ 
									        END
                                    ";

                                    cmd.Parameters.AddWithValue("FORCE_CLOSE", context.Request["FORCE_CLOSE"]);
                                    cmd.Parameters.AddWithValue("GIVE_STATUS", context.Request["GIVE_STATUS"]);
                                    cmd.Parameters.AddWithValue("CHECK_NO", context.Request["CHECK_NO"]);
                                    cmd.Parameters.AddWithValue("CHECK_DATE", context.Request["CHECK_DATE"]);
                                    cmd.Parameters.AddWithValue("CHECK_CNT", context.Request["CHECK_CNT"]);
                                    cmd.Parameters.AddWithValue("ACC_SHIP_CNT", context.Request["ACC_SHIP_CNT"]);
                                    cmd.Parameters.AddWithValue("GIVE_SHIP_DATE", context.Request["GIVE_SHIP_DATE"]);
                                    cmd.Parameters.AddWithValue("ACC_SHIP_DATE", context.Request["ACC_SHIP_DATE"]);
                                    cmd.Parameters.AddWithValue("USD", context.Request["USD"]);
                                    cmd.Parameters.AddWithValue("NTD", context.Request["NTD"]);
                                    cmd.Parameters.AddWithValue("FORE_CODE", context.Request["FORE_CODE"]);
                                    cmd.Parameters.AddWithValue("FORE_AMT", context.Request["FORE_AMT"]);
                                    cmd.Parameters.AddWithValue("PRICE_2", context.Request["PRICE_2"]);
                                    cmd.Parameters.AddWithValue("PRICE_3", context.Request["PRICE_3"]);
                                    cmd.Parameters.AddWithValue("MIN_1", context.Request["MIN_1"]);
                                    cmd.Parameters.AddWithValue("MIN_2", context.Request["MIN_2"]);
                                    cmd.Parameters.AddWithValue("MIN_3", context.Request["MIN_3"]);
                                    cmd.Parameters.AddWithValue("AMT_CHANGE", context.Request["AMT_CHANGE"]);
                                }
                                else
                                {
                                    cmd.CommandText = @" INSERT INTO [dbo].[pudu]
                                                               (序號,SUPLU_SEQ,[樣品號碼],[工作類別],[廠商編號],[廠商簡稱]
                                                               ,[頤坊型號],[暫時型號],[廠商型號],[產品說明]
                                                               ,[客戶編號],[客戶簡稱],[到貨處理],[強制結案]
                                                               ,[採購單號],[採購日期],[採購數量],[採購交期]
                                                               ,[單位]
                                                               --,[到貨數量],[出貨日期],[到貨日期]
                                                               --,[點收批號],[點收數量],[點收日期]
                                                               --,[交期狀況],[列表小備註],[美元單價],[台幣單價]
                                                               --,[單價_2]  ,[單價_3],[min_1] ,[min_2],[min_3] 
                                                               ,[更新人員] ,[更新日期])
                                                         SELECT (Select IsNull(Max(序號),0)+1 From pudu), @SUPLU_SEQ
                                                               ,@SAMPLE_NO,@WORK_TYPE,@FACT_NO,@FACT_S_NAME
                                                               ,@IVAN_TYPE,@TMP_TYPE,@FACT_TYPE,@PROD_DESC
                                                               ,@CUST_NO,@CUST_S_NAME,@GIVE_WAY, 0
                                                               ,@PUDU_NO,@PUDU_DATE,@PUDU_CNT,@PUDU_GIVE_DATE
                                                               ,@UNIT
                                                               --,@ACC_SHIP_CNT,@GIVE_SHIP_DATE,@ACC_SHIP_DATE
                                                               --,@CHECK_NO,@CHECK_CNT,@CHECK_DATE
                                                               --,@GIVE_STATUS,@RPT_REMARK
                                                               --,IIF(@USD = '', 0,CONVERT(DECIMAL,@USD))
                                                               --,IIF(@NTD = '', 0,CONVERT(DECIMAL,@NTD))
                                                               --,IIF(@PRICE_2 = '', 0,CONVERT(DECIMAL,@PRICE_2))
                                                               --,IIF(@PRICE_3 = '', 0,CONVERT(DECIMAL,@PRICE_3))
                                                               --,IIF(@MIN_1 = '', 0,CONVERT(DECIMAL,@MIN_1))
                                                               --,IIF(@MIN_2 = '', 0,CONVERT(DECIMAL,@MIN_2))
                                                               --,IIF(@MIN_3 = '', 0,CONVERT(DECIMAL,@MIN_3))
                                                               ,@UPD_USER, GETDATE() ";
                                }
                                
                                cmd.Parameters.AddWithValue("SEQ", context.Request["SEQ"]);
                                cmd.Parameters.AddWithValue("SUPLU_SEQ", context.Request["SUPLU_SEQ"]);
                                cmd.Parameters.AddWithValue("UNIT", context.Request["UNIT"]);
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
                                cmd.Parameters.AddWithValue("PUDU_NO", context.Request["PUDU_NO"]);
                                cmd.Parameters.AddWithValue("PUDU_DATE", context.Request["PUDU_DATE"]);
                                cmd.Parameters.AddWithValue("PUDU_CNT", context.Request["PUDU_CNT"]);
                                cmd.Parameters.AddWithValue("PUDU_GIVE_DATE", context.Request["PUDU_GIVE_DATE"]);
                                cmd.Parameters.AddWithValue("UPD_USER", "IVAN");
                                
                                res = cmd.ExecuteNonQuery();
                                context.Response.StatusCode = 200;
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
                            case "UPD_WRITEOFF":
                                string[] seqArr = context.Request["SEQ[]"].Split(',');
                                foreach(string seq in seqArr)
                                {
                                    cmd.CommandText = @" UPDATE pudu
                                                         SET [結案] = @FORCE_CLOSE,
                                                             [強制結案] = @FORCE_CLOSE
                                                         WHERE 序號 = @SEQ";
                                    cmd.Parameters.Clear();
                                    cmd.Parameters.AddWithValue("SEQ", seq);
                                    cmd.Parameters.AddWithValue("FORCE_CLOSE", context.Request["FORCE_CLOSE"]);
                                    cmd.ExecuteNonQuery();
                                }

                                context.Response.StatusCode = 200;
                                context.Response.End();
                                break;
                            case "PRINT_RPT":
                                string rptDir = "~/DEV/Sample/Rpt/Sample_Dev.rpt";
                                string workType = "";

                                if(context.Request["WORK_TYPE"] != "3")
                                {
                                    switch (context.Request["WORK_TYPE"])
                                    {
                                        case "0":
                                            rptDir = "~/DEV/Sample/Rpt/Sample_Dev.rpt";
                                            workType = "開";
                                            break;
                                        case "1":
                                            rptDir = "~/DEV/Sample/Rpt/Sample_Ask.rpt";
                                            workType = "詢";
                                            break;
                                        case "2":
                                            rptDir = "~/DEV/Sample/Rpt/Sample_Get.rpt";
                                            workType = "索";
                                            break;
                                    }

                                    cmd.CommandText = @" SELECT P.採購單號,P.採購日期,P.樣品號碼,P.工作類別,P.廠商編號,P.廠商簡稱,P.頤坊型號,P.頤坊型號 抬頭,P.廠商型號,P.產品說明,P.單位,
                                                            P.台幣單價,P.美元單價,P.單價_2,P.單價_3,P.MIN_1,P.MIN_2,P.MIN_3,P.外幣幣別,P.外幣單價,P.採購數量,P.採購交期,P.列表小備註,
                                                            S.廠商名稱,S.連絡人採購,S.公司地址,S.電話,S.傳真,S.幣別,
                                                            S.所在地,PU.大備註一,PU.大備註二,PU.大備註三
                                                           ,'' 列印圖檔, '' 圖檔, P.採購單號 群組一
	                                                       ,CASE WHEN ISNULL(S.email開發,'') <> '' THEN  '    E-mail: ' + S.email開發 ELSE S.連絡人開發 END 連絡人與email
                                                           ,CASE WHEN ISNULL(外幣單價,0) <> 0 THEN 外幣幣別 WHEN ISNULL(美元單價,0) <> 0 THEN '(USD)' ELSE 'NTD' END 預設幣別 
	                                                       ,CASE WHEN ISNULL(外幣單價,0) <> 0 THEN 外幣單價 WHEN ISNULL(美元單價,0) <> 0 THEN 美元單價 ELSE 台幣單價 END 單價 
	                                                       ,CASE WHEN ISNULL(外幣單價,0) <> 0 THEN 外幣單價 WHEN ISNULL(美元單價,0) <> 0 THEN 美元單價 ELSE 台幣單價 END * ISNULL(採購數量,0) 金額
	                                                       ,(SELECT 內容 FROM refdata r JOIN pass p ON r.備註 = CASE WHEN p.所在地 = '汐止' THEN p.所在地 ELSE '內湖' END WHERE 代碼 = '交貨地點' AND p.使用者名稱 = @USER) 交貨地點
	                                                       ,(SELECT TOP 1 R.RI_IMAGE FROM [192.168.1.135].pic.dbo.REF_IMAGE R WHERE R.RI_REFENCE_KEY = @USER) 簽名圖檔1
                                                     FROM PUDU P 
                                                     INNER JOIN SUP S ON P.廠商編號=S.廠商編號 
                                                     LEFT JOIN PUDUM PU ON P.採購單號=PU.採購單號 
                                                     WHERE P.採購單號 >= @PUDU_NO_S 
                                                     AND P.採購單號 <= @PUDU_NO_E
                                                     AND P.工作類別 LIKE '%' + @WORK_TYPE + '%'   ";

                                    cmd.Parameters.AddWithValue("USER", "IVAN");
                                    cmd.Parameters.AddWithValue("PUDU_NO_S", context.Request["PUDU_NO_S"]);
                                    cmd.Parameters.AddWithValue("PUDU_NO_E", context.Request["PUDU_NO_E"]);
                                    cmd.Parameters.AddWithValue("WORK_TYPE", workType);
                                }
                                else
                                {
                                    rptDir = "~/DEV/Sample/Rpt/Sample_Chk.rpt";

                                    cmd.CommandText = @" SELECT P.採購單號,P.採購日期,P.樣品號碼,P.工作類別,P.廠商編號,P.廠商簡稱,P.頤坊型號,P.頤坊型號 抬頭,P.廠商型號,P.產品說明,P.單位,
                                                                P.台幣單價,P.美元單價,P.單價_2,P.單價_3,P.MIN_1,P.MIN_2,P.MIN_3,P.外幣幣別,P.外幣單價,P.採購數量,P.採購交期,P.列表小備註,
                                                                S.廠商名稱,S.連絡人採購,S.公司地址,S.電話,S.傳真,S.幣別,
                                                                S.所在地,PU.大備註一,PU.大備註二,PU.大備註三,
                                                                P.採購單號 群組一, P.到貨處理 列印到貨處理
                                                         FROM PUDU P 
                                                         INNER JOIN SUP S ON P.廠商編號=S.廠商編號 
                                                         LEFT JOIN PUDUM PU ON P.採購單號=PU.採購單號
                                                         LEFT JOIN RECU R ON P.序號 = R.PUDU_SEQ 
                                                         WHERE (1=0
                                                           ";

                                    if(context.Request["PUDU_NO_1"] != "")
                                    {
                                        cmd.CommandText += " OR P.採購單號 = @PUDU_NO_1 ";
                                        cmd.Parameters.AddWithValue("PUDU_NO_1", context.Request["PUDU_NO_1"]);
                                    }
                                    if (context.Request["PUDU_NO_2"] != "")
                                    {
                                        cmd.CommandText += " OR P.採購單號 = @PUDU_NO_2 ";
                                        cmd.Parameters.AddWithValue("PUDU_NO_2", context.Request["PUDU_NO_2"]);
                                    }
                                    if (context.Request["PUDU_NO_3"] != "")
                                    {
                                        cmd.CommandText += " OR P.採購單號 = @PUDU_NO_3 ";
                                        cmd.Parameters.AddWithValue("PUDU_NO_3", context.Request["PUDU_NO_3"]);
                                    }
                                    if (context.Request["PUDU_NO_4"] != "")
                                    {
                                        cmd.CommandText += " OR P.採購單號 = @PUDU_NO_4 ";
                                        cmd.Parameters.AddWithValue("PUDU_NO_4", context.Request["PUDU_NO_4"]);
                                    }
                                    if (context.Request["PUDU_NO_5"] != "")
                                    {
                                        cmd.CommandText += " OR P.採購單號 = @PUDU_NO_5 ";
                                        cmd.Parameters.AddWithValue("PUDU_NO_5", context.Request["PUDU_NO_5"]);
                                    }

                                    cmd.CommandText += ")";

                                    cmd.CommandText += @" GROUP BY P.採購單號,P.採購日期,P.樣品號碼,P.工作類別,P.廠商編號,P.廠商簡稱,P.頤坊型號,P.頤坊型號,P.廠商型號,P.產品說明,P.單位,
                                                              P.台幣單價,P.美元單價,P.單價_2,P.單價_3,P.MIN_1,P.MIN_2,P.MIN_3,P.外幣幣別,P.外幣單價,P.採購數量,P.採購交期,P.列表小備註,
                                                              S.廠商名稱,S.連絡人採購,S.公司地址,S.電話,S.傳真,S.幣別,
                                                              S.所在地,PU.大備註一,PU.大備註二,PU.大備註三,
                                                              P.採購單號, P.到貨處理
                                                     HAVING IsNull(P.採購數量,0) - SUM(IsNull(R.到貨數量,0)) > 0   ";

                                }

                                SqlDataAdapter sqlDatai = new SqlDataAdapter(cmd);
                                sqlDatai.Fill(dt);

                                if (dt != null && dt.Rows.Count > 0)
                                {
                                    ReportDocument rptDoc = new ReportDocument();
                                    rptDoc.Load(context.Server.MapPath(rptDir));
                                    rptDoc.SetDataSource(dt);
                                    System.IO.Stream stream = rptDoc.ExportToStream(CrystalDecisions.Shared.ExportFormatType.PortableDocFormat);
                                    byte[] bytes = new byte[stream.Length];
                                    stream.Read(bytes, 0, bytes.Length);
                                    stream.Seek(0, System.IO.SeekOrigin.Begin);

                                    string filename = "樣品開發維護.pdf";
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



