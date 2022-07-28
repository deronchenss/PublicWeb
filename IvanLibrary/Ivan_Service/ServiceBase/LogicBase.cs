using Ivan_Dal;
using Ivan_Log;
using System;
using System.Data;
using System.Web;

namespace Ivan_Service
{
    public class LogicBase : DataOperator
    {
        protected HttpContext context;
        protected DataTable GetDataTableWithLog(string sqlStr)
        {
            try
            {
                DataTable dt = GetDataTable(sqlStr);
                Log.InsertLog(context, context.Session["Account"], sqlStr);
                return dt;
            }
            catch (Exception ex)
            {
                Log.InsertLog(context, context.Session["Account"], sqlStr, ex.ToString(), false);
                throw ex;
            }
        }

        protected int ExecuteWithLog(string sqlStr)
        {
            try
            {
                int res = 0;
                res = Execute(sqlStr);
                Log.InsertLog(context, context.Session["Account"], sqlStr);
                return res;
            }
            catch (Exception ex)
            {
                Log.InsertLog(context, context.Session["Account"], sqlStr, ex.ToString(), false);
                throw ex;
            }
        }

        protected int InsertWithLog(Object entity)
        {
            try
            {
                int res = 0;
                res = Insert(entity);
                Log.InsertLog(context, context.Session["Account"], sqlStr);
                return res;
            }
            catch (Exception ex)
            {
                Log.InsertLog(context, context.Session["Account"], sqlStr, ex.ToString(), false);
                throw ex;
            }
        }
    }
}
