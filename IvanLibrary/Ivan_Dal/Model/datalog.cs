using System;

namespace Ivan.DAL.Models
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
        /// 查詢新增修改刪除(ELSE)
        /// </summary>
        public string CALL_TYPE { get; set; }

        /// <summary>
        /// Http Request Context
        /// </summary>
        public string CALL_CONTEXT { get; set; }

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


