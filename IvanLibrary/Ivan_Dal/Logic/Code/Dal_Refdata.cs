using System.Data;
using System.Web;

namespace Ivan_Dal
{
    public class Dal_Refdata : DataOperator
    {
        /// <summary>
        /// 撈出設定檔 BY 代碼
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        public DataTable SearchTable(string code)
        {
            DataTable dt = new DataTable();
            string sqlStr = "";

            sqlStr = @"SELECT 內容 FROM Refdata Where 代碼=@CODE ORDER BY 內容 ";
            this.SetParameters("CODE", code);

            //下拉式選單不記LOG
            dt = GetDataTable(sqlStr);
            return dt;
        }
    }
}
