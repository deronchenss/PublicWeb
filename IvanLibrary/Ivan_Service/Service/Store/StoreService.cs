using Ivan_Models;
using Ivan_Dal;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace Ivan_Service
{
    public class StoreService : ServiceBase
    {
        Dal_Suplu dalSup = new Dal_Suplu();
        Dal_Stkio dalStk = new Dal_Stkio();
        Dal_Stkioh dalStkH = new Dal_Stkioh();
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
        /// Step1: INSERT stkioh
        /// Step2: UPDATE suplu 庫存數
        /// Step3: INSERT stkio_sale
        /// Step4: UPDATE stkio 核銷數
        /// </summary>
        /// <returns></returns>
        public string StoreStockApExec(List<Stkio> liStkio, List<Stkioh> liStkioh,  List<Stkio_Sale> liStkioSale)
        {
            int res = 0;
            _dataOperator.SetTran();
            //序號同為stkio 序號
            foreach (Stkio stkio in liStkio)
            {
                var stkioh = liStkioh.Find(x => x.序號 == stkio.序號);
                var stkioSale = liStkioSale.Find(x => x.序號 == stkio.序號);

                res += this.Execute(dalStkH.InsertStkiohFromStkio(stkioh));
                res += this.Execute(dalSup.UpdateSupluFromStkio(stkio, stkioh.實扣快取數));
                res += this.Execute(dalStkSale.InsertStkioSaleFromStkio(stkioSale));
                stkio.備註 = null; //備註不需UPDATE
                res += this.Execute(dalStk.UpdateStkio(stkio));
            }
            _dataOperator.TranCommit();
            return Convert.ToString(res);
        }

        /// <summary>
        /// 門市庫取 取消 核銷
        /// Step1: DELETE stkioh
        /// Step2: UPDATE suplu 庫存數 加回
        /// Step3: DELETE stkio_sale 
        /// Step4: UPDATE stkio 核銷數 扣回
        /// </summary>
        /// <returns></returns>
        public string StoreStockApCancel(Stkio_Sale stkioSale)
        {
            int res = 0;
            //PM NO 箱號
            DataTable dt = this.GetDataTable(dalStkH.GetDataFromSale(stkioSale));
            if(dt != null && dt.Rows.Count > 0)
            {
                _dataOperator.SetTran();
                List<Stkioh> liStkioh = DataTableHelper.ConvertDataTable<Stkioh>(dt);
                stkioSale.序號 = Convert.ToInt32(dt.Rows[0]["SALE_SEQ"]);
                foreach (Stkioh stkioh in liStkioh)
                {
                    stkioh.更新人員 = stkioSale.更新人員;

                    Stkio stkio = new Stkio();
                    stkio.序號 = Convert.ToInt32(stkioh.SOURCE_SEQ);
                    stkio.核銷數 = -1 * (stkioh.入庫數 != null && stkioh.入庫數 > 0 ? stkioh.入庫數 : stkioh.出庫數); //核銷數扣回
                    stkio.更新人員 = stkioSale.更新人員;
                    stkio.庫區 = stkioh.庫區;

                    //筆數只需要紀錄更新項目筆數
                    this.Execute(dalStkH.DeleteStkioh(stkioh)); 
                    this.Execute(dalSup.UpdateSupluFromStkio(stkio, stkioh.實扣快取數 * -1)); 
                    this.Execute(dalStkSale.DeleteStkioSale(stkioSale));
                    res += this.Execute(dalStk.UpdateStkio(stkio));
                }
                _dataOperator.TranCommit();
            }
           
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

        /// <summary>
        /// 門市PM 查詢
        /// </summary>
        /// <returns></returns>
        public DataTable StockPMSearch(Dictionary<string, string> dic)
        {
            return this.GetDataTable(dalStkSale.SearchPMTable(dic));
        }
    }
}
