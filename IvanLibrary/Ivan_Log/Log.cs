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
        /// <param name="callType">執行動作 S:SELECT I:INSERT U UPDATE D DELETE</param>
        /// <param name="result">執行結果 True: 成功 False: 失敗</param>        
        public static void InsertLog(HttpContext context, object user = null,string sqlStr = "", string callType = "S", bool result = true)
        {
            DataOperator dao = new DataOperator();
            datalog logModel = new datalog();

            logModel.LOG_DATE = DateTime.Now;
            logModel.USER = user == null ? "IVAN10" : user.ToString();
            logModel.PROG_URL = System.IO.Path.GetFileName(context.Request.UrlReferrer.ToString());
            switch (callType)
            {
                case "S":
                    logModel.CALL_TYPE = "查詢";
                    break;
                case "I":
                    logModel.CALL_TYPE = "寫入";
                    break;
                case "U":
                    logModel.CALL_TYPE = "更新";
                    break;
                case "D":
                    logModel.CALL_TYPE = "刪除";
                    break;
                //自定義動作
                default:
                    logModel.CALL_TYPE = callType;
                    break;
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
