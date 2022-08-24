﻿using System.Data;
using System.Web;

namespace Ivan_Service
{
    public class Dal_Nofile : LogicBase
    {
        public Dal_Nofile(HttpContext _context)
        {
            context = _context;
        }

        /// <summary>
        /// 組新的 NO BY 單據
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        public string SearchTable()
        {
            DataTable dt = new DataTable();
            string sqlStr = "";

            sqlStr = @" DECLARE @NEW_NO nvarchar(20); 
                        SELECT @NEW_NO = 字頭 + CONVERT(VARCHAR,年度) + RIGHT(REPLICATE('0', len(號碼長度)) + CONVERT(VARCHAR,號碼 + 1),len(號碼長度)) + 字尾
					    FROM nofile
					    WHERE 單據 = @CODE
                        AND 使用者 = @USER
					    		    
					    UPDATE nofile
					    SET 號碼 = 號碼+1
					       ,更新人員 = @USER
					       ,更新日期 = GETDATE() 
					    WHERE 單據 = @CODE
                        AND 使用者 = @USER 
                        
                        SELECT @NEW_NO NEW_NO
                        ";

            this.SetParameters("CODE", context.Request["CODE"]);
            this.SetParameters("USER", context.Session["Account"] ?? "IVAN10");
            this.SetTran();
            dt = GetDataTableWithLog(sqlStr);
            this.TranCommit();
            return dt.Rows[0]["NEW_NO"] == null ? "" : dt.Rows[0]["NEW_NO"].ToString();
        }
    }
}
