using Ivan_Models;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Linq;

namespace Ivan_Dal
{
    public class DataOperator : IDataOperator
    {
        public SqlCommand cmd = new SqlCommand();
        private SqlConnection conn = new SqlConnection();
        private SqlTransaction trans;
        private SqlDataAdapter da = new SqlDataAdapter();
        public string connStr = ConfigurationManager.ConnectionStrings["LocalBC2"].ConnectionString;
        bool isTran = false;

        private SqlLogModel sqlLogModel = new SqlLogModel();

        //最後寫入SQL語句 LOG用
        public SqlLogModel _sqlLogModel 
        { 
            get 
            {
                sqlLogModel.SQL_TEXT = cmd.CommandText;
                sqlLogModel.SQL_PARAMETERS = GetParameters();
                return sqlLogModel;
            } 
        }

        private void SetConnection()
        {
            if(conn.State != ConnectionState.Open)
            {
                conn.ConnectionString = connStr;
                cmd.Connection = conn;
                conn.Open();
            }
            else
            {
                cmd.Connection = conn;
            }

            if (isTran)
            {
                cmd.Transaction = trans;
            }
        }

        private void CloseConnection()
        {
            if (!isTran)
            {
                conn.Close();
                conn.Dispose();
                cmd.Dispose();
            }
        }

        private void CatchDoThing()
        {
            if (isTran)
            {
                trans.Rollback();
            }
        }

        /// <summary>
        /// 清空變數
        /// </summary>
        public void ClearParameter()
        {
            cmd.Parameters.Clear();
        }

        /// <summary>
        /// 變數賦予值
        /// </summary>
        /// <param name="paramName"></param>
        /// <param name="value"></param>
        public void SetParameters(string paramName, object value)
        {
            cmd.Parameters.AddWithValue(paramName, value);
        }

        public string GetParameters()
        {
            string sqlparm = "";
            foreach (SqlParameter para in cmd.Parameters)
            {
                sqlparm += (para.ParameterName + ":" + Convert.ToString(para.Value) + ";"); 
            }
            return sqlparm;
        }

        /// <summary>
        /// Transaction 開啟
        /// </summary>
        /// <param name="tran"></param>
        public void SetTran()
        {
            SetConnection();
            trans = conn.BeginTransaction();
            isTran = true;
        }

        /// <summary>
        /// Transaction Commit
        /// </summary>
        /// <param name="tran"></param>
        public void TranCommit()
        {
            trans.Commit();
            isTran = false;
            CloseConnection();
        }

        /// <summary>
        /// 執行SQL 回傳 DATATABLE
        /// </summary>
        /// <param name="sqlStr"></param>
        /// <returns></returns>
        public DataTable GetDataTable(string sqlStr)
        {
            DataTable dt = new DataTable();
            try
            {
                SetConnection();
                cmd.CommandText = sqlStr;
                da.SelectCommand = cmd;
                da.Fill(dt);
                return dt;
            }
            catch(Exception ex)
            {
                CatchDoThing();
                throw ex;
            }
            finally
            {
                CloseConnection();
            }
        }

        /// <summary>
        /// 執行SQL 回傳影響筆數
        /// </summary>
        /// <param name="sqlStr"></param>
        /// <returns></returns>
        public int Execute(string sqlStr)
        {
            try
            {
                SetConnection();
                cmd.CommandText = sqlStr;
                int res = cmd.ExecuteNonQuery();
                return res;
            }
            catch (Exception ex)
            {
                CatchDoThing();
                throw ex;
            }
            finally
            {
                CloseConnection();
            }
        }

        /// <summary>
        /// 執行SQL 回傳 DATATABLE
        /// </summary>
        /// <returns></returns>
        public DataTable GetDataTable()
        {
            DataTable dt = new DataTable();
            try
            {
                SetConnection();
                da.SelectCommand = cmd;
                da.Fill(dt);
                return dt;
            }
            catch (Exception ex)
            {
                CatchDoThing();
                throw ex;
            }
            finally
            {
                CloseConnection();
            }
        }

        /// <summary>
        /// 執行SQL 回傳影響筆數
        /// </summary>
        /// <returns></returns>
        public int Execute()
        {
            try
            {
                SetConnection();
                int res = cmd.ExecuteNonQuery();
                return res;
            }
            catch (Exception ex)
            {
                CatchDoThing();
                throw ex;
            }
            finally
            {
                CloseConnection();
            }
        }

        /// <summary>
        /// 傳入MODEL INSERT 語法 
        /// </summary>
        /// <param name="entity"></param>
        /// <returns></returns>
        public int Insert(Object entity)
        {
            try
            {
                SetConnection();
                string table = entity.GetType().Name;
                var column = new StringBuilder();
                var columnVar = new StringBuilder();

                foreach (var property in entity.GetType().GetProperties())
                {
                    if (property.GetValue(entity, null) == null)
                        continue;
                    column.Append($" [{property.Name}],");
                    columnVar.Append($" @{property.Name},");
                    SetParameters($"@{property.Name}", property.GetValue(entity, null));
                }

                cmd.CommandText = string.Format($"INSERT INTO {table} ({column.ToString().TrimEnd(',')}) VALUES ({columnVar.ToString().TrimEnd(',')})");
                int res = cmd.ExecuteNonQuery();
                return res;
            }
            catch(Exception ex)
            {
                CatchDoThing();
                throw ex;
            }
            finally{
                CloseConnection();
            }
        }
    }
}
