using System.Data.SqlClient;

namespace Ivan_Dal
{
    public class Dal_Base : IDalBase
    {
        private SqlCommand _cmd = new SqlCommand();

        public SqlCommand cmd
        {
            get
            {
                return _cmd;
            }
            set {
                _cmd = value;
            }
        }

        /// <summary>
        /// 變數賦予值
        /// </summary>
        /// <param name="paramName"></param>
        /// <param name="value"></param>
        protected void CleanParameters()
        {
            cmd.Parameters.Clear();
        }

        /// <summary>
        /// 變數賦予值
        /// </summary>
        /// <param name="paramName"></param>
        /// <param name="value"></param>
        protected void SetParameters(string paramName, object value)
        {
            cmd.Parameters.AddWithValue(paramName, value);
        }

        /// <summary>
        /// 設定執行Sql 
        /// </summary>
        /// <param name="paramName"></param>
        /// <param name="value"></param>
        protected void SetSqlText(string sqlText)
        {
            cmd.CommandText = sqlText;
        }

    }
}
