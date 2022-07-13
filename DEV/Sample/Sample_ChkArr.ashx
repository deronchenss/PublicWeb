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
                                                     ISNULL(SUM(RA.點收數量),0) 點收數量
                                                     ,CONVERT(VARCHAR, MAX(RA.點收日期), 111) 點收日期
                                                     ,ISNULL(SUM(R.到貨數量),0) 到貨數量
                                                     ,CONVERT(VARCHAR, MAX(R.到貨日期), 111) 到貨日期
                                                     ,P.工作類別 AS 類別,P.樣品號碼,
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
                                                     LEFT JOIN RECUA RA ON P.序號 = RA.PUDU_SEQ
                                                     LEFT JOIN RECU R ON P.序號 = R.PUDU_SEQ
                                                     WHERE IsNull(P.採購單號,'') <> ''
                                                     AND 工作類別 <>'詢價'
                                              ";

                                //共用function 需調整日期名稱,form !=, 簡稱類, 串TABLE 簡稱 
                                foreach (string form in context.Request.Form)
                                {
                                    if (!string.IsNullOrEmpty(context.Request[form]) && form != "Call_Type" && form != "WRITE_OFF")
                                    {
                                        switch (form)
                                        {
                                            case "採購日期_S":
                                                cmd.CommandText += " AND CONVERT(DATE,[採購日期]) >= @採購日期_S";
                                                cmd.Parameters.AddWithValue(form, context.Request[form]);
                                                break;
                                            case "採購日期_E":
                                                cmd.CommandText += " AND CONVERT(DATE,[採購日期]) <= @採購日期_E";
                                                cmd.Parameters.AddWithValue(form, context.Request[form]);
                                                break;
                                            case "廠商簡稱":
                                                cmd.CommandText += " AND ISNULL(P.[廠商簡稱],'') LIKE '%' + @廠商簡稱 + '%'";
                                                cmd.Parameters.AddWithValue(form, context.Request[form]);
                                                break;
                                            default:
                                                cmd.CommandText += " AND ISNULL(P.[" + form + "],'') LIKE @" + form + " + '%'";
                                                cmd.Parameters.AddWithValue(form, context.Request[form]);
                                                break;
                                        }
                                    }
                                }

                                cmd.CommandText += @" GROUP BY P.採購單號,P.廠商簡稱,P.頤坊型號,P.採購數量,P.客戶簡稱,P.暫時型號,P.單位,P.產品說明
                                                     ,P.工作類別,P.樣品號碼
                                                     ,S.設計圖號,P.廠商型號,P.廠商編號,P.客戶編號,S.圖型啟用,P.序號,P.更新人員
                                                     ,P.更新日期,P.到貨處理,P.採購日期,P.採購交期
                                                     , S.單位淨重, S.單位毛重, S.產品長度, S.產品寬度, S.產品高度, P.結案  ";

                                //未結案
                                if (!string.IsNullOrEmpty(context.Request["WRITE_OFF"]) && context.Request["WRITE_OFF"] == "0")
                                {
                                    cmd.CommandText += " HAVING P.採購數量 > ISNULL(SUM(RA.點收數量),0)";
                                }

                                cmd.CommandText += " ORDER BY P.採購單號,P.頤坊型號";
                                break;
                            case "INSERT_RECUA":
                                string[] seqArray = context.Request["SEQ[]"].Split(',');
                                string[] chkCntArr = context.Request["CHK_CNT[]"].Split(',');
                                string[] netWeiArray = context.Request["NET_WEIGHT[]"].Split(',');
                                string[] weiArray = context.Request["WEIGHT[]"].Split(',');
                                string[] lenArr = context.Request["LEN[]"].Split(',');
                                string[] widthArray = context.Request["WIDTH[]"].Split(',');
                                string[] heightArr = context.Request["HEIGHT[]"].Split(',');
                                string[] ivanType = context.Request["IVAN_TYPE[]"].Split(',');
                                string[] factNo = context.Request["FACT_NO[]"].Split(',');

                                for (int cnt = 0; cnt < seqArray.Length; cnt++)
                                {
                                    cmd.CommandText = @" INSERT INTO [dbo].[recua]
                                                                       ([序號]
                                                                       ,[PUDU_SEQ]
                                                                       ,[點收批號]
                                                                       ,[採購單號]
                                                                       ,[樣品號碼]
                                                                       ,[廠商編號]
                                                                       ,[廠商簡稱]
                                                                       ,[頤坊型號]
                                                                       ,[暫時型號]
                                                                       ,[廠商型號]
                                                                       ,[單位]
                                                                       ,[點收日期]
                                                                       ,[點收數量]
                                                                       ,[核銷數量]
                                                                       ,[運輸編號]
                                                                       ,[運輸簡稱]
                                                                       ,[運送方式]
                                                                       ,[變更日期]
                                                                       ,[更新人員]
                                                                       ,[更新日期])
                                                           SELECT		(Select IsNull(Max(序號),0)+1 From recua) [序號]
                                                                       ,@SEQ [PUDU_SEQ]
                                                                       ,@CHK_BATCH_NO [點收批號]
                                                                       ,[採購單號]
                                                                       ,[樣品號碼]
                                                                       ,[廠商編號]
                                                                       ,[廠商簡稱]
                                                                       ,[頤坊型號]
                                                                       ,[暫時型號]
                                                                       ,[廠商型號]
                                                                       ,[單位]
                                                                       ,@CHK_DATE [點收日期]
                                                                       ,@CHK_CNT [點收數量]
                                                                       ,NULL [核銷數量]
                                                                       ,@TRANSFER_NO [運輸編號]
                                                                       ,@TRANSFER_S_NAME [運輸簡稱]
                                                                       ,NULL [運送方式]
                                                                       ,NULL [變更日期]
                                                                       ,@UPD_USER [更新人員]
                                                                       ,GETDATE()[更新日期]
                                                           FROM pudu
                                                           WHERE 序號 = @SEQ
                                                         
                                                           UPDATE SUPLU
                                                           SET 單位淨重 = @NET_WEI
                                                              ,單位毛重 = @WEI
                                                              ,產品長度 = @LEN
                                                              ,產品寬度 = @WIDTH
                                                              ,產品高度 = @HEIGHT
                                                           WHERE 頤坊型號 = @IVAN_TYPE
                                                           AND 廠商編號 = @FACT_NO ";
                                    cmd.Parameters.Clear();
                                    cmd.Parameters.AddWithValue("SEQ", seqArray[cnt]);
                                    cmd.Parameters.AddWithValue("CHK_CNT", chkCntArr[cnt]);
                                    cmd.Parameters.AddWithValue("CHK_BATCH_NO", context.Request["CHK_BATCH_NO"]);
                                    cmd.Parameters.AddWithValue("TRANSFER_NO", context.Request["TRANSFER_NO"]);
                                    cmd.Parameters.AddWithValue("CHK_DATE", context.Request["CHK_DATE"]);
                                    cmd.Parameters.AddWithValue("TRANSFER_S_NAME", context.Request["TRANSFER_S_NAME"]);
                                    cmd.Parameters.AddWithValue("UPD_USER", "IVAN10");
                                    cmd.Parameters.AddWithValue("NET_WEI", string.IsNullOrEmpty(netWeiArray[cnt]) ? "0" : netWeiArray[cnt]);
                                    cmd.Parameters.AddWithValue("WEI", string.IsNullOrEmpty(weiArray[cnt]) ? "0" : weiArray[cnt]);
                                    cmd.Parameters.AddWithValue("LEN", string.IsNullOrEmpty(lenArr[cnt]) ? "0" : lenArr[cnt]);
                                    cmd.Parameters.AddWithValue("WIDTH", string.IsNullOrEmpty(widthArray[cnt]) ? "0" : widthArray[cnt]);
                                    cmd.Parameters.AddWithValue("HEIGHT", string.IsNullOrEmpty(heightArr[cnt]) ? "0" : heightArr[cnt]);
                                    cmd.Parameters.AddWithValue("IVAN_TYPE", ivanType[cnt]);
                                    cmd.Parameters.AddWithValue("FACT_NO", factNo[cnt]);

                                    cmd.ExecuteNonQuery();
                                }

                                context.Response.StatusCode = 200;
                                context.Response.Write(seqArray.Length);
                                context.Response.End();
                                break;

                            case "GET_IMG":
                                cmd.CommandText = @" SELECT TOP 1 [COST_SEQ], [圖檔] [P_IMG]
                                                     FROM [192.168.1.135].pic.dbo.xpic
                                                     WHERE [COST_SEQ] = (SELECT TOP 1 COST_SEQ FROM byrlu where 廠商編號 = @FACT_NO AND 頤坊型號 = @IVAN_TYPE) ";
                                cmd.Parameters.AddWithValue("FACT_NO", context.Request["FACT_NO"]);
                                cmd.Parameters.AddWithValue("IVAN_TYPE", context.Request["IVAN_TYPE"]);
                                break;
                        }

                        if (!context.Request["Call_Type"].Equals("INSERT_RECUA"))
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



