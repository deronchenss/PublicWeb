using Ivan_Dal;
using System.Data;
using System.Web;

namespace Ivan_Service
{
    public class Dal_Sample_Chk_MT : DataOperator
    {
        /// <summary>
        /// 樣品點收維護 查詢 Return DataTable
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        public DataTable SearchTable(HttpContext context)
        {
			DataTable dt = new DataTable();
            string sqlStr = "";

			sqlStr = @" SELECT TOP 500 RA.[序號]
                                    ,P.[採購單號]
                                    ,P.[樣品號碼]
                                    ,P.[SUPLU_SEQ]
                                    ,P.[廠商編號]
                                    ,P.[廠商簡稱]
                                    ,P.[頤坊型號]
                                    ,P.[暫時型號]
                                    ,P.[廠商型號]
                                    ,P.[產品說明]
                                    ,P.[單位]
                                    ,RA.[點收批號]
                                    ,IIF(RA.[點收數量] = 0, NULL, RA.[點收數量]) 點收數量
                                    ,IIF(RA.[核銷數量] = 0, NULL, RA.[核銷數量]) 核銷數量
                                    ,CONVERT(VARCHAR,RA.[點收日期],23) [點收日期]
                                    ,RA.[運輸編號]
                                    ,RA.[運輸簡稱]
                                    ,RA.[更新人員]
                                    ,CONVERT(VARCHAR,RA.[更新日期],23) [更新日期]
                        FROM Dc2..pudu P
                        INNER JOIN RECUA RA ON P.序號 = RA.PUDU_SEQ
                        WHERE 1=1 ";

            //共用function 需調整日期名稱,form !=, 簡稱類, 串TABLE 簡稱 
            foreach (string form in context.Request.Form)
            {
                if (!string.IsNullOrEmpty(context.Request[form]) && form != "Call_Type")
                {
                    string debug = context.Request[form];
                    switch (form)
                    {
                        case "點收日期_S":
                            sqlStr += " AND CONVERT(DATE,[點收日期]) >= @點收日期_S";
                            this.SetParameters(form, context.Request[form]);
                            break;
                        case "點收日期_E":
                            sqlStr += " AND CONVERT(DATE,[點收日期]) <= @點收日期_E";
                            this.SetParameters(form, context.Request[form]);
                            break;
                        case "廠商簡稱":
                            sqlStr += " AND ISNULL(RA.[廠商簡稱],'') LIKE '%' + @廠商簡稱 + '%'";
                            this.SetParameters(form, context.Request[form]);
                            break;
                        default:
                            sqlStr += " AND ISNULL(RA.[" + form + "],'') LIKE @" + form + " + '%'";
                            this.SetParameters(form, context.Request[form]);
                            break;
                    }
                }
            }

            dt = GetDataTable(sqlStr);
			return dt;
        }

		/// <summary>
		/// 寫入點收 TABLE 
		/// </summary>
		/// <param name="context"></param>
		/// <returns></returns>
		public int DeleteRecua(HttpContext context)
		{
			int res = 0;
            string sqlStr = @"      DELETE FROM RECUA 
                                    WHERE [序號] = @SEQ
                                    
                                    UPDATE SUPLU
                                    SET 內湖庫存數 = ISNULL(內湖庫存數,0) - 入庫數
									   ,更新人員 = @UPD_USER
									   ,變更日期 = GETDATE()
                                    FROM SUPLU S
                                    INNER JOIN stkioh ST ON S.序號 = ST.SUPLU_SEQ
                                    WHERE ISNULL(ST.已刪除,0) = 0

                                    UPDATE stkioh
                                    SET 變更日期 = GETDATE()
                                       ,更新人員 = @UPD_USER
                                       ,已刪除 = 1
                                    WHERE SOURCE_TABLE = 'recua'
                                    AND SOURCE_SEQ = @SEQ
                                     ";

            this.SetParameters("SEQ", context.Request["SEQ"]);
            this.SetParameters("UPD_USER", "IVAN10");

            this.SetTran();
			Execute(sqlStr);
			this.TranCommit();

			return res;
		}
	}
}
