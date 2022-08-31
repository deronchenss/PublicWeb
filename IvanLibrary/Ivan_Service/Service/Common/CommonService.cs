using Ivan_Models;
using Ivan_Dal;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Data;
using System.Text;

namespace Ivan_Service
{
    /// <summary>
    /// 共用Service
    /// </summary>
    public class CommonService : ServiceBase
    {
        Dal_Refdata dalRefData = new Dal_Refdata();
        Dal_Nofile dalNoFile = new Dal_Nofile();

        /// <summary>
        /// 取得設定檔 BY 代碼
        /// </summary>
        /// <returns></returns>
        public DataTable GetRefData(string code)
        {
            return this.GetDataTable(dalRefData.SearchTable(code));
        }

        /// <summary>
        /// 從Nofile取得新號碼
        /// </summary>
        /// <returns></returns>
        public string GetNofileNewNo(string code, object user)
        {
            _dataOperator.SetTran();
            DataTable dt = this.GetDataTable(dalNoFile.SearchTable(code, user));
            _dataOperator.TranCommit();
            return dt.Rows[0]["NEW_NO"] == null ? "" : dt.Rows[0]["NEW_NO"].ToString();
        }
    }
}
