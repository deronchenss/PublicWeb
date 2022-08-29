using System.Data;
using System.Web;

namespace Ivan_Dal
{
    public class Dal_Nofile : Dal_Base
    {
        /// <summary>
        /// 組新的 NO BY 單據
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        public IDalBase SearchTable(string code, object user)
        {
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

            this.SetParameters("CODE", code);
            this.SetParameters("USER", user ?? "IVAN10");
            this.SetSqlText(sqlStr);
            return this;
        }
    }
}
