using System;

namespace Ivan_Log
{
    public class datalog
    {
        /// <summary>
        /// LOG 日期
        /// </summary>
        public DateTime? LOG_DATE { get; set; }

        /// <summary>
        /// 操作人員
        /// </summary>
        public string USER { get; set; }

        /// <summary>
        /// 執行功能
        /// </summary>
        public string PROG_URL { get; set; }

        /// <summary>
        /// CONTEXT Call_Type
        /// </summary>
        public string CALL_TYPE { get; set; }

        /// <summary>
        /// CONTEXT
        /// </summary>
        public string CALL_CONTEXT { get; set; }

        /// <summary>
        /// SQL PARAMETER 變數
        /// </summary>
        public string SQL_PARAMETERS { get; set; }

        /// <summary>
        /// 錯誤訊息
        /// </summary>
        public string ERROR_MSG { get; set; }

        /// <summary>
        /// 執行語法
        /// </summary>
        public string SQL_TEXT { get; set; }

        /// <summary>
        /// 連線DB IP
        /// </summary>
        public string SERVER_IP { get; set; }

        /// <summary>
        /// 操作人員IP
        /// </summary>
        public string CLIENT_IP { get; set; }

        /// <summary>
        /// 執行結果
        /// </summary>
        public string RESULT { get; set; }

    }
}


