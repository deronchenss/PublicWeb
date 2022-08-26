using Ivan.Models;
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
            SetSqlLogModel(dalSup);
            return dalSup.SearchTableForReplace(dic);
        }

        /// <summary>
        /// 替代庫存 執行
        /// </summary>
        /// <returns></returns>
        public string ReplaceStockOExec(List<StkioFromSuplu> liEntity, object user)
        {
            SetSqlLogModel(dalStk);
            return Convert.ToString(dalStk.MutiInsertStkio(liEntity, user));
        }

        /// <summary>
        /// 庫存入出核銷 查詢
        /// </summary>
        /// <returns></returns>
        public DataTable StockIOApSearch(Dictionary<string, string> dic)
        {
            SetSqlLogModel(dalStk);
            return dalStk.SearchTableForAp(dic);
        }

        /// <summary>
        /// 庫存入出核銷 執行
        /// </summary>
        /// <returns></returns>
        public string StockIOApExec(Dictionary<string, string> dic)
        {
            SetSqlLogModel(dalStk);
            return Convert.ToString(dalStk.ApproveStkio(dic));
        }

        /// <summary>
        /// 庫存入出維護 查詢
        /// </summary>
        /// <returns></returns>
        public DataTable StockIOMTSearch(Dictionary<string, string> dic)
        {
            SetSqlLogModel(dalStk);
            return dalStk.SearchTableForMT(dic);
        }

        /// <summary>
        /// 庫存入出維護 新增
        /// </summary>
        /// <returns></returns>
        public string StockIOMTInsert(Dictionary<string, string> dic)
        {
            SetSqlLogModel(dalStk);
            return Convert.ToString(dalStk.InsertStkio(dic));
        }

        /// <summary>
        /// 庫存入出維護 修改
        /// </summary>
        /// <returns></returns>
        public string StockIOMTUpdate(Dictionary<string, string> dic)
        {
            SetSqlLogModel(dalStk);
            return Convert.ToString(dalStk.UpdateStkio(dic));
        }

        /// <summary>
        /// 庫存入出維護 刪除
        /// </summary>
        /// <returns></returns>
        public string StockIOMTDelete(Dictionary<string, string> dic)
        {
            SetSqlLogModel(dalStk);
            return Convert.ToString(dalStk.DeleteStkio(dic));
        }

        /// <summary>
        /// 庫存入出多筆新增 查詢
        /// </summary>
        /// <returns></returns>
        public DataTable StockIOMMISearch(Dictionary<string, string> dic)
        {
            SetSqlLogModel(dalSup);
            return dalSup.SearchTableForMutiInsert(dic);
        }

        /// <summary>
        /// 庫存入出多筆新增 新增
        /// </summary>
        /// <returns></returns>
        public string StockIOMMIInsert(List<StkioFromSuplu> liEntity, object user)
        {
            SetSqlLogModel(dalStk);
            return Convert.ToString(dalStk.MutiInsertStkio(liEntity, user));
        }

        /// <summary>
        /// 庫存入出查詢 查詢
        /// </summary>
        /// <returns></returns>
        public DataTable StockIOSearch(Dictionary<string, string> dic)
        {
            SetSqlLogModel(dalStk);
            return dalStk.SearchTable(dic);
        }

        /// <summary>
        /// 庫位變更 查詢
        /// </summary>
        /// <returns></returns>
        public DataTable StockLocUpdSearch(Dictionary<string, string> dic)
        {
            SetSqlLogModel(dalSup);
            return dalSup.SearchTableForUpdLoc(dic);
        }

        /// <summary>
        /// 庫位變更 執行
        /// </summary>
        /// <returns></returns>
        public string StockLocUpdExec(Dictionary<string, string> dic)
        {
            SetSqlLogModel(dalSup);
            return Convert.ToString(dalSup.UpdateSuplu(dic));
        }

        /// <summary>
        /// 庫存查詢 查詢
        /// </summary>
        /// <returns></returns>
        public DataTable StockSearchSearch(Dictionary<string, string> dic)
        {
            SetSqlLogModel(dalSup);
            return dalSup.SearchTable(dic);
        }
    }
}
