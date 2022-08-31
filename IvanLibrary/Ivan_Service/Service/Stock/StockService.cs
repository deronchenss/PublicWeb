using Ivan_Models;
using Ivan_Dal;
using System;
using System.Collections.Generic;
using System.Data;

namespace Ivan_Service
{
    public class StockService : ServiceBase
    {
        Dal_Suplu dalSup = new Dal_Suplu();
        Dal_Stkio dalStk = new Dal_Stkio();

        /// <summary>
        /// 替代庫存 查詢
        /// </summary>
        /// <returns></returns>
        public DataTable ReplaceStockOSearch(Dictionary<string, string> dic)
        {
            return this.GetDataTable(dalSup.SearchTableForReplace(dic));
        }

        /// <summary>
        /// 替代庫存 執行
        /// </summary>
        /// <returns></returns>
        public string ReplaceStockOExec(List<StkioFromSuplu> liEntity, object user)
        {
            int res = 0;
            _dataOperator.SetTran();
            foreach (StkioFromSuplu entity in liEntity)
            {
                res += this.Execute(dalStk.InsertStkioFromSuplu(entity, user));
            }
            _dataOperator.TranCommit();
            return Convert.ToString(res);
        }

        /// <summary>
        /// 庫存入出核銷 查詢
        /// </summary>
        /// <returns></returns>
        public DataTable StockIOApSearch(Dictionary<string, string> dic)
        {
            return this.GetDataTable(dalStk.SearchTableForAp(dic));
        }

        /// <summary>
        /// 庫存入出核銷 執行
        /// </summary>
        /// <returns></returns>
        public string StockIOApExec(Dictionary<string, string> dic)
        {
            string[] seqArray = dic["SEQ[]"].Split(',');
            int res = 0;
            _dataOperator.SetTran();
            for (int cnt = 0; cnt < seqArray.Length; cnt++)
            {
                res += this.Execute(dalStk.ApproveStkio(dic, cnt));
            }
            _dataOperator.TranCommit();
            return Convert.ToString(res);
        }

        /// <summary>
        /// 庫存入出維護 查詢
        /// </summary>
        /// <returns></returns>
        public DataTable StockIOMTSearch(Dictionary<string, string> dic)
        {
            return this.GetDataTable(dalStk.SearchTableForMT(dic));
        }

        /// <summary>
        /// 庫存入出維護 新增
        /// </summary>
        /// <returns></returns>
        public string StockIOMTInsert(Stkio entity)
        {
            _dataOperator.SetTran();
            int res = this.Execute(dalStk.InsertStkio(entity));
            _dataOperator.TranCommit();
            return Convert.ToString(res);
        }

        /// <summary>
        /// 庫存入出維護 修改
        /// </summary>
        /// <returns></returns>
        public string StockIOMTUpdate(Dictionary<string, string> dic)
        {
            _dataOperator.SetTran();
            int res = this.Execute(dalStk.UpdateStkioOld(dic));
            _dataOperator.TranCommit();
            return Convert.ToString(res);
        }

        /// <summary>
        /// 庫存入出維護 單筆刪除
        /// </summary>
        /// <returns></returns>
        public string StockIOMTDelete(Dictionary<string, string> dic)
        {
            _dataOperator.SetTran();
            int res = this.Execute(dalStk.DeleteStkio(dic));
            _dataOperator.TranCommit();
            return Convert.ToString(res);
        }

        /// <summary>
        /// 庫存入出多筆新增 查詢
        /// </summary>
        /// <returns></returns>
        public DataTable StockIOMMISearch(Dictionary<string, string> dic)
        {
            return this.GetDataTable(dalSup.SearchTableForMutiInsert(dic));
        }

        /// <summary>
        /// 庫存入出多筆新增 新增
        /// </summary>
        /// <returns></returns>
        public string StockIOMMIInsert(List<StkioFromSuplu> liEntity, object user)
        {
            int res = 0;
            _dataOperator.SetTran();
            foreach (StkioFromSuplu entity in liEntity)
            {
                res += this.Execute(dalStk.InsertStkioFromSuplu(entity, user));
            }
            _dataOperator.TranCommit();
            return Convert.ToString(res);
        }

        /// <summary>
        /// 庫存入出查詢 查詢
        /// </summary>
        /// <returns></returns>
        public DataTable StockIOSearch(Dictionary<string, string> dic)
        {
            return this.GetDataTable(dalStk.SearchTable(dic));
        }

        /// <summary>
        /// 庫位變更 查詢
        /// </summary>
        /// <returns></returns>
        public DataTable StockLocUpdSearch(Dictionary<string, string> dic)
        {
            return this.GetDataTable(dalSup.SearchTableForUpdLoc(dic));
        }

        /// <summary>
        /// 庫位變更 執行
        /// </summary>
        /// <returns></returns>
        public string StockLocUpdExec(Dictionary<string, string> dic)
        {
            string[] seqArray = dic["SEQ[]"].Split(',');
            int res = 0;
            _dataOperator.SetTran();
            for (int cnt = 0; cnt < seqArray.Length; cnt++)
            {
                res += this.Execute(dalSup.UpdateSuplu(dic, cnt));
            }
            _dataOperator.TranCommit();
            return Convert.ToString(res);
        }

        /// <summary>
        /// 庫存查詢 查詢
        /// </summary>
        /// <returns></returns>
        public DataTable StockSearchSearch(Dictionary<string, string> dic)
        {
            return this.GetDataTable(dalSup.SearchTable(dic));
        }
    }
}
