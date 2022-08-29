using System.Data;
using System.Web;

namespace Ivan_Dal
{
    public class Dal_Refdata : Dal_Base
    {
        /// <summary>
        /// 撈出設定檔 BY 代碼
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        public IDalBase SearchTable(string code)
        {
            string sqlStr = "";
            sqlStr = @"SELECT 內容 FROM Refdata Where 代碼=@CODE ORDER BY 內容 ";
            this.SetParameters("CODE", code);
            this.SetSqlText(sqlStr);
            return this;
        }
    }
}
