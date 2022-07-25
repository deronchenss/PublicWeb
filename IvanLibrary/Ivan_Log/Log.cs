using Ivan.DAL.Models;
using Ivan_Dal;
using System;
using System.Configuration;
using System.Text;
using System.Web;

namespace Ivan_Log
{
    public class Log
    {
        /// <summary>
        /// 寫入LOG
        /// </summary>
        /// <param name="context">HttpContext參數</param>
        /// <param name="user">session[USER]</param>
        /// <param name="sqlStr">執行語法</param>
        /// <param name="callType">執行動作 有傳入使用傳入值 沒有的話根據 SQL 語法 拆解 </param>
        /// <param name="result">執行結果 True: 成功 False: 失敗</param>        
        public static void InsertLog(HttpContext context, object user = null,string sqlStr = "", string callType = "", bool result = true)
        {
            DataOperator dao = new DataOperator();
            datalog logModel = new datalog();

            logModel.LOG_DATE = DateTime.Now;
            logModel.USER = user == null ? "IVAN10" : user.ToString();
            logModel.PROG_URL = System.IO.Path.GetFileName(context.Request.UrlReferrer.ToString());
            logModel.CALL_TYPE = "";

            //ERROR 訊息不塞callType
            if (string.IsNullOrEmpty(callType))
            {
                if (sqlStr.IndexOf("INSERT") != -1)
                {
                    logModel.CALL_TYPE = "I";
                }
                if (sqlStr.IndexOf("UPDATE") != -1)
                {
                    logModel.CALL_TYPE += "U";
                }
                if (sqlStr.IndexOf("DELETE") != -1)
                {
                    logModel.CALL_TYPE += "D";
                }
                if (string.IsNullOrEmpty(logModel.CALL_TYPE))
                {
                    logModel.CALL_TYPE = "S";
                }
            }
            else
            {
                logModel.CALL_TYPE = callType.Length > 200 ? callType.Substring(0,200) : callType;
            }

            logModel.CALL_CONTEXT = HttpUtility.UrlDecode(context.Request.Form.ToString(), Encoding.UTF8);
            logModel.SQL_TEXT = sqlStr.Replace("\t","").Replace("\r\n", "");
            logModel.SERVER_IP = context.Request.Url.Authority;
            logModel.CLIENT_IP = context.Request.UserHostAddress;
            logModel.RESULT = result ? "SUCCESS" : "FAIL";
            dao.Insert(logModel);
        }
    }
}
