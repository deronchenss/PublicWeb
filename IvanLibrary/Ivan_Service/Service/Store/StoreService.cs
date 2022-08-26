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
            SetSqlLogModel(dalSup);
            return dalSup.SearchTableForStore(dic);
        }

        /// <summary>
        /// 門市庫取申請 執行
        /// </summary>
        /// <returns></returns>
        public string StoreStockInsExec(List<StkioFromSuplu> liEntity, object user)
        {
            SetSqlLogModel(dalStk);
            return Convert.ToString(dalStk.MutiInsertStkio(liEntity, user));
        }

        /// <summary>
        /// 門市庫取核銷 查詢
        /// </summary>
        /// <returns></returns>
        public DataTable StoreStockApSearch(Dictionary<string, string> dic)
        {
            SetSqlLogModel(dalStk);
            return dalStk.SearchTableStoreAp(dic);
        }

        /// <summary>
        /// 門市庫取核銷 執行
        /// </summary>
        /// <returns></returns>
        public string StoreStockApExec(List<Stkio_SaleFromStkio> liEntity, object user)
        {
            SetSqlLogModel(dalStkSale);
            return Convert.ToString(dalStkSale.MutiInsertStkioSale(liEntity, user));
        }
    }
}
