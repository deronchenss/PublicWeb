using Ivan_Models;
using Ivan_Dal;
using System;
using System.Configuration;
using System.Text;
using System.Web;

namespace Ivan_Log
{
    public class Log
    {
        //Log連線字串不變
        private static string connStr = ConfigurationManager.ConnectionStrings["LocalBC2"].ConnectionString;

        /// <summary>
        /// 寫入LOG
        /// </summary>
        /// <param name="context">HttpContext參數</param>
        /// <param name="user">session[USER]</param>
        /// <param name="sqlStr">執行語法</param>
        /// <param name="errMsg">錯誤訊息 </param>
        /// <param name="result">執行結果 True: 成功 False: 失敗</param>        
        public static void InsertLog(HttpContext context, object user, string sqlStr = "", string paraStr = "", string errMsg = "", bool result = true)
        {
            DataOperator dao = new DataOperator();
            Datalog datalog = new Datalog();

            //log 連線字串獨立
            dao.connStr = connStr;
            datalog.LOG_DATE = DateTime.Now;
            datalog.USER =  user == null ? "IVAN10" : user.ToString();
            datalog.PROG_URL = System.IO.Path.GetFileName(context.Request.UrlReferrer.ToString());
            datalog.CALL_TYPE = context.Request["Call_Type"] ?? "";
            datalog.SQL_PARAMETERS = paraStr;
            datalog.ERROR_MSG = errMsg;
            datalog.CALL_CONTEXT = HttpUtility.UrlDecode(context.Request.Form.ToString(), Encoding.UTF8);
            datalog.SQL_TEXT = sqlStr.Replace("\t","").Replace("\r\n", "").Replace("     ", " ").Replace("    ", " ").Replace("   ", " ").Replace("  ", " ");
            datalog.SERVER_IP = context.Request.Url.Authority;
            datalog.CLIENT_IP = context.Request.UserHostAddress;
            datalog.RESULT = result ? "SUCCESS" : "FAIL";
            dao.Insert(datalog);
        }

        /// <summary>
        /// 寫入LOG
        /// </summary>
        /// <param name="context">HttpContext參數</param>
        /// <param name="user">session[USER]</param>
        /// <param name="sqlStr">執行語法</param>
        /// <param name="errMsg">錯誤訊息 </param>
        /// <param name="result">執行結果 True: 成功 False: 失敗</param>        
        public static void InsertLog(HttpContext context, object user, SqlLogModel sqlLogModel, string errMsg = "", bool result = true)
        {
            DataOperator dao = new DataOperator();
            Datalog datalog = new Datalog();

            //log 連線字串獨立
            dao.connStr = connStr;
            datalog.LOG_DATE = DateTime.Now;
            datalog.USER = user == null ? "IVAN10" : user.ToString();
            datalog.PROG_URL = System.IO.Path.GetFileName(context.Request.UrlReferrer.ToString());
            datalog.CALL_TYPE = context.Request["Call_Type"] ?? "";
            datalog.SQL_PARAMETERS = sqlLogModel.SQL_PARAMETERS;
            datalog.ERROR_MSG = errMsg;
            datalog.CALL_CONTEXT = HttpUtility.UrlDecode(context.Request.Form.ToString(), Encoding.UTF8);
            datalog.SQL_TEXT = sqlLogModel.SQL_TEXT.Replace("\t", "").Replace("\r\n", "").Replace("     ", " ").Replace("    ", " ").Replace("   ", " ").Replace("  ", " ");
            datalog.SERVER_IP = context.Request.Url.Authority;
            datalog.CLIENT_IP = context.Request.UserHostAddress;
            datalog.RESULT = result ? "SUCCESS" : "FAIL";
            dao.Insert(datalog);
        }
    }
}
