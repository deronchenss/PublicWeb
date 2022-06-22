<%@ WebHandler Language="C#" Class="Quote_MT_Search" %>

using System.Collections.Generic;
using System.Web;
using System.Web.SessionState;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;
using System.Web.Script.Serialization;
using Newtonsoft.Json; 

public class Quote_MT_Search : IHttpHandler, IRequiresSessionState
{
    public void ProcessRequest(HttpContext context)
    {
        DataTable dt = new DataTable();

        if (!string.IsNullOrEmpty(context.Request["Call_Type"]))
        {
            List<object> quote = new List<object>();
            SqlConnection conn = new SqlConnection();
            conn.ConnectionString = ConfigurationManager.ConnectionStrings["LocalBC2"].ConnectionString;
            using (SqlCommand cmd = new SqlCommand())
            {
                switch (context.Request["Call_Type"])
                {
                    case "Quote_MT_Search":
                        cmd.CommandText = @" SELECT TOP 1000 Byr.客戶簡稱, Byr.頤坊型號
                                                   ,Byr.美元單價, Byr.台幣單價, Byr.外幣幣別, Byr.外幣單價
                                                   ,Byr.MIN_1 MIN
                                                   ,Byr.產品說明, Byr.單位, Byr.廠商編號, Byr.廠商簡稱
                                                   ,Byr.客戶編號, Byr.序號, Byr.更新人員, CONVERT(VARCHAR, Byr.更新日期, 120) 更新日期
                                         	       ,CAST(ISNULL((SELECT TOP 1 1 FROM [192.168.1.135].pic.dbo.xpic X WHERE X.[P_SEQ] = Byr.[序號]),0) AS BIT) [Has_IMG]
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
                }
                cmd.Connection = conn;
                conn.Open();
                //SqlDataReader sdr = cmd.ExecuteReader();
                //switch (context.Request["Call_Type"])
                //{
                //    case "Quote_MT_Search":
                //        while (sdr.Read())
                //        {
                //            quote.Add(new
                //            {
                //                CUSTOMER_S_NAME = sdr["客戶簡稱"],
                //                IVAN_TYPE = sdr["頤坊型號"],
                //                USD_P = sdr["美元單價"],
                //                TWD_P = sdr["台幣單價"],
                //                CURR_TYPE = sdr["外幣幣別"],
                //                FOR_P = sdr["外幣單價"],
                //                MIN = sdr["MIN"],
                //                PROD_INT = sdr["產品說明"],
                //                UNIT = sdr["單位"],
                //                COM_NO = sdr["廠商編號"],
                //                COM_S_NAME = sdr["廠商簡稱"],
                //                CUST_NO = sdr["客戶編號"],
                //                SEQ = sdr["序號"],
                //                UPDATE_USER = sdr["更新人員"],
                //                UPDATE_DATE = sdr["更新日期"]
                //            });
                //        }
                //        break;
                //}

                SqlDataAdapter sqlData = new SqlDataAdapter(cmd);
                sqlData.Fill(dt);
                conn.Close();

                var json = JsonConvert.SerializeObject(dt);
                context.Response.ContentType = "text/json";
                context.Response.Write(json);
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
