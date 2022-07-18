using Ivan_Dal;
using System.Data;
using System.Web;

namespace Ivan_Service
{
    public class Dal_Sample_Chk_Dist : DataOperator
    {
        /// <summary>
        /// 樣品點收分配 查詢 Return DataTable
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        public DataTable SearchTable(HttpContext context)
        {
			DataTable dt = new DataTable();
            string sqlStr = @"SELECT  Top 500 R.點收批號 
							  			     ,R.頤坊型號
							  			     ,S.產品說明
							  			     ,S.單位
							  			     ,ISNULL(R.點收數量,0) - ISNULL(R.核銷數量,0) AS 可核銷數
							  			     ,ISNULL(S.內湖庫位,0) 內湖庫位
							  			     ,P.到貨處理
							  			     ,R.廠商編號
							  			     ,R.廠商簡稱
							  			     ,R.暫時型號
							  			     ,R.採購單號
							  			     ,R.點收批號
							  			     ,S.圖型啟用
							  			     ,R.序號
							  			     ,R.更新人員
							  			     ,CONVERT(VARCHAR,R.更新日期,23) 更新日期
							  FROM recua R
							  INNER JOIN PUDU P ON R.PUDU_SEQ = P.序號
							  INNER JOIN SUPLU S ON P.SUPLU_SEQ = S.序號
							  WHERE ISNULL(R.點收數量,0) - ISNULL(R.核銷數量,0) > 0";

            //共用function 需調整日期名稱,form !=, 簡稱類, 串TABLE 簡稱 
            foreach (string form in context.Request.Form)
            {
                if (!string.IsNullOrEmpty(context.Request[form]) && form != "Call_Type")
                {
                    string debug = context.Request[form];
                    switch (form)
                    {
                        case "點收日期_S":
                            sqlStr += " AND CONVERT(DATE,R.[點收日期]) >= @點收日期_S";
                            this.SetParameters(form, context.Request[form]);
                            break;
                        case "點收日期_E":
                            sqlStr += " AND CONVERT(DATE,R.[點收日期]) <= @點收日期_E";
                            this.SetParameters(form, context.Request[form]);
                            break;
                        case "廠商簡稱":
                            sqlStr += " AND ISNULL(P.[廠商簡稱],'') LIKE '%' + @廠商簡稱 + '%'";
                            this.SetParameters(form, context.Request[form]);
                            break;
                        default:
                            sqlStr += " AND ISNULL(R.[" + form + "],'') LIKE @" + form + " + '%'";
                            this.SetParameters(form, context.Request[form]);
                            break;
                    }
                }
            }

            dt = GetDataTable(sqlStr);
			return dt;
        }
    }
}
