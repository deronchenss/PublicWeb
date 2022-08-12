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
            datalog logModel = new datalog();

            //log 連線字串獨立
            dao.connStr = connStr;
            logModel.LOG_DATE = DateTime.Now;
            logModel.USER =  user == null ? "IVAN10" : user.ToString();
            logModel.PROG_URL = System.IO.Path.GetFileName(context.Request.UrlReferrer.ToString());
            logModel.CALL_TYPE = context.Request["Call_Type"] ?? "";
            logModel.SQL_PARAMETERS = paraStr;
            logModel.ERROR_MSG = errMsg;
            logModel.CALL_CONTEXT = HttpUtility.UrlDecode(context.Request.Form.ToString(), Encoding.UTF8);
            logModel.SQL_TEXT = sqlStr.Replace("\t","").Replace("\r\n", "");
            logModel.SERVER_IP = context.Request.Url.Authority;
            logModel.CLIENT_IP = context.Request.UserHostAddress;
            logModel.RESULT = result ? "SUCCESS" : "FAIL";
            dao.Insert(logModel);
        }
    }
}
