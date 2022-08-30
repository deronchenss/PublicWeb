using Ivan.Models;
using Ivan_Dal;
using System;
using System.Collections.Generic;
using System.Data;

namespace Ivan_Service
{
    public class StoreService : ServiceBase
    {
        Dal_Suplu dalSup = new Dal_Suplu();
        Dal_Stkio dalStk = new Dal_Stkio();
        Dal_Stock_Sale dalStkSale = new Dal_Stock_Sale();

        /// <summary>
        /// 門市庫取申請 查詢
        /// </summary>
        /// <returns></returns>
        public DataTable StoreStockInsSearch(Dictionary<string, string> dic)
        {
            return this.GetDataTable(dalSup.SearchTableForStore(dic));
        }

        /// <summary>
        /// 門市庫取申請 執行
        /// </summary>
        /// <returns></returns>
        public string StoreStockInsExec(List<StkioFromSuplu> liEntity, object user)
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
        /// 門市庫取核銷 查詢
        /// </summary>
        /// <returns></returns>
        public DataTable StoreStockApSearch(Dictionary<string, string> dic)
        {
            return this.GetDataTable(dalStk.SearchTableStoreAp(dic));
        }

        /// <summary>
        /// 門市庫取核銷 執行
        /// </summary>
        /// <returns></returns>
        public string StoreStockApExec(List<Stkio_SaleFromStkio> liEntity, object user)
        {
            int res = 0;
            _dataOperator.SetTran();
            foreach (Stkio_SaleFromStkio entity in liEntity)
            {
                res += this.Execute(dalStkSale.InsertStkioSale(entity, user));
            }
            _dataOperator.TranCommit();
            return Convert.ToString(res);
        }

        /// <summary>
        /// 門市出貨作業 查詢
        /// </summary>
        /// <returns></returns>
        public DataTable StoreStockShippingSearch(Dictionary<string, string> dic)
        {
            return this.GetDataTable(dalStkSale.SearchTable(dic));
        }

        /// <summary>
        /// 門市出貨作業 執行
        /// </summary>
        /// <returns></returns>
        public string StoreStockShippingExec(List<Stkio_Sale> liEntity, List<InsertStkioFromSaleModel> liInsEntity)
        {
            int res = 0;
            _dataOperator.SetTran();
            foreach (Stkio_Sale entity in liEntity)
            {
                //不為不入庫 新增stkio 一筆待入庫
                if (entity.不入庫 != true)
                {
                    var insEntity = liInsEntity.Find(x => x.序號 == entity.序號);
                    res += this.Execute(dalStk.InsertStkioFromSale(insEntity));
                }

                //更新StkioSale 狀態為已出庫
                res += this.Execute(dalStkSale.UpdateStkioSale(entity));
            }
            _dataOperator.TranCommit();
            return Convert.ToString(res);
        }
    }
}
