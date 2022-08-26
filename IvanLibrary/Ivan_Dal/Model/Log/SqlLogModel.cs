using System;

namespace Ivan.Models
{
    public class SqlLogModel
    {
        /// <summary>
        /// SQL 執行語法
        /// </summary>
        public string SQL_TEXT { get; set; }

        /// <summary>
        /// SQL 變數
        /// </summary>
        public string SQL_PARAMETERS { get; set; }
    }
}


