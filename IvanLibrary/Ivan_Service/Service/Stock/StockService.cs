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
        Dal_Stkioh dalStkH = new Dal_Stkioh();

        /// <summary>
        /// 庫存待入出報表 查詢
        /// </summary>
        /// <returns></returns>
        public DataTable StockIORptSearch(Dictionary<string, string> dic)
        {
            return this.GetDataTable(dalStk.SearchTableForRpt(dic));
        }

        /// <summary>
        /// 庫存待入出報表 列印
        /// </summary>
        /// <returns></returns>
        public DataTable StockIORptPrint(Dictionary<string, string> dic)
        {
            DataTable dt = new DataTable();
            //貼紙
            if (dic.ContainsKey("RPT_TYPE") && "外包裝貼紙".Equals(dic["RPT_TYPE"]))
            {
                dt = this.GetDataTable(dalStk.GetStickerRptData(dic));
            }
            //預設 待入出庫輸入核對表-圖
            else
            {
                dt = this.GetDataTable(dalStk.GetImgRptData(dic));
            }
            return dt;
        }

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
        public string ReplaceStockOExec(List<StkioFromSuplu> liEntity)
        {
            int res = 0;
            _dataOperator.SetTran();
            foreach (StkioFromSuplu entity in liEntity)
            {
                res += this.Execute(dalStk.InsertStkioFromSuplu(entity));
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
            int res = this.Execute(dalStk.DeleteStkioSingle(dic));
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
        public string StockIOMMIInsert(List<StkioFromSuplu> liEntity)
        {
            int res = 0;
            _dataOperator.SetTran();
            foreach (StkioFromSuplu entity in liEntity)
            {
                res += this.Execute(dalStk.InsertStkioFromSuplu(entity));
            }
            _dataOperator.TranCommit();
            return Convert.ToString(res);
        }

        /// <summary>
        /// 庫取跟催查詢 查詢
        /// </summary>
        /// <returns></returns>
        public DataTable StockIOTraceSearch(Dictionary<string, string> dic)
        {
            return this.GetDataTable(dalStk.StockTraceSearchTable(dic));
        }

        /// <summary>
        /// 庫取跟催查詢 點擊Grid
        /// </summary>
        /// <returns></returns>
        public DataTable StockIOTraceDetailSearch(Dictionary<string, string> dic)
        {
            return this.GetDataTable(dalStk.StocTracekDetailSearchTable(dic));
        }

        /// <summary>
        /// 庫取跟催查詢 報表
        /// </summary>
        /// <returns></returns>
        public DataTable StockIOTraceRptSearch(Dictionary<string, string> dic)
        {
            return this.GetDataTable(dalStk.StocTraceGetRptData(dic));
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
