using Ivan.Models;
using Ivan_Dal;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Data;
using System.Text;

namespace Ivan_Service
{
    public class SampleService : ServiceBase
    {
        Dal_Recu dalRecu = new Dal_Recu();
        Dal_Pudu dalPudu = new Dal_Pudu();
        Dal_Recua dalRecua = new Dal_Recua();
        Dal_Suplu dalSup = new Dal_Suplu();
        Dal_Paku dalPaku = new Dal_Paku();
        Dal_Paku2 dalPaku2 = new Dal_Paku2();
        Dal_Invu dalInvu = new Dal_Invu();

        /// <summary>
        /// 樣品開發查詢維護 查詢
        /// </summary>
        /// <returns></returns>
        public DataTable SampleMTSearch(Dictionary<string, string> dic)
        {
            SetSqlLogModel(dalPudu);
            return dalPudu.SearchTableForMT(dic);
        }

        /// <summary>
        /// 樣品開發查詢維護 報表
        /// </summary>
        /// <returns></returns>
        public DataTable SampleMTReport(Dictionary<string, string> dic)
        {
            SetSqlLogModel(dalPudu);
            return dalPudu.SampleMTReport(dic);
        }

        /// <summary>
        /// 樣品開發查詢維護 新增
        /// </summary>
        /// <returns></returns>
        public string SampleMTInsert(Dictionary<string, string> dic)
        {
            SetSqlLogModel(dalPudu);
            return Convert.ToString(dalPudu.InsertPudu(dic));
        }

        /// <summary>
        /// 樣品開發查詢維護 修改
        /// </summary>
        /// <returns></returns>
        public string SampleMTUpdate(Dictionary<string, string> dic)
        {
            SetSqlLogModel(dalPudu);
            return Convert.ToString(dalPudu.UpdatePudu(dic));
        }

        /// <summary>
        /// 樣品開發查詢維護 更新序號
        /// </summary>
        /// <returns></returns>
        public string SampleMTUpdateSeq(Dictionary<string, string> dic)
        {
            SetSqlLogModel(dalPudu);
            return Convert.ToString(dalPudu.UpdateSeq(dic));
        }

        /// <summary>
        /// 樣品開發查詢維護 更新列印備註
        /// </summary>
        /// <returns></returns>
        public string SampleMTUpdateRptRemark(Dictionary<string, string> dic)
        {
            SetSqlLogModel(dalPudu);
            return Convert.ToString(dalPudu.UpdateRptRemark(dic));
        }

        /// <summary>
        /// 樣品開發查詢維護 更新核銷
        /// </summary>
        /// <returns></returns>
        public string SampleMTUpdateWriteOff(Dictionary<string, string> dic)
        {
            SetSqlLogModel(dalPudu);
            return Convert.ToString(dalPudu.UpdateWriteOff(dic));
        }

        /// <summary>
        /// 樣品到貨 查詢
        /// </summary>
        /// <returns></returns>
        public DataTable SampleArrSearch(Dictionary<string, string> dic)
        {
            SetSqlLogModel(dalPudu);
            return dalPudu.SearchTableForRecu(dic);
        }

        /// <summary>
        /// 樣品到貨 執行
        /// </summary>
        /// <returns></returns>
        public string SampleArrExec(Dictionary<string, string> dic)
        {
            SetSqlLogModel(dalRecu);
            return Convert.ToString(dalRecu.InsertRecu(dic));
        }

        /// <summary>
        /// 樣品到貨維護 查詢
        /// </summary>
        /// <returns></returns>
        public DataTable SampleArrMTSearch(Dictionary<string, string> dic)
        {
            SetSqlLogModel(dalRecu);
            return dalRecu.SearchTable(dic);
        }

        /// <summary>
        /// 樣品到貨維護 修改
        /// </summary>
        /// <returns></returns>
        public string SampleArrMTUpdate(Dictionary<string, string> dic)
        {
            SetSqlLogModel(dalRecu);
            return Convert.ToString(dalRecu.UpdateRecu(dic));
        }

        /// <summary>
        /// 樣品到貨維護 刪除
        /// </summary>
        /// <returns></returns>
        public string SampleArrMTDelete(Dictionary<string, string> dic)
        {
            SetSqlLogModel(dalRecu);
            return Convert.ToString(dalRecu.DeleteRecu(dic));
        }

        /// <summary>
        /// 樣品到貨維護 報表
        /// </summary>
        /// <returns></returns>
        public DataTable SampleArrMTReport(Dictionary<string, string> dic)
        {
            SetSqlLogModel(dalRecu);
            return dalRecu.SampleShippingReport(dic);
        }

        /// <summary>
        /// 樣品點收作業 查詢
        /// </summary>
        /// <returns></returns>
        public DataTable SampleChkSearch(Dictionary<string, string> dic)
        {
            SetSqlLogModel(dalPudu);
            return dalPudu.SearchTable(dic);
        }

        /// <summary>
        /// 樣品點收作業 查詢
        /// </summary>
        /// <returns></returns>
        public string SampleChkExec(Dictionary<string, string> dic)
        {
            SetSqlLogModel(dalRecua);
            return Convert.ToString(dalRecua.InsertRecua(dic));
        }

        /// <summary>
        /// 樣品準備作業 查詢
        /// </summary>
        /// <returns></returns>
        public DataTable SampleChkDistSearch(Dictionary<string, string> dic)
        {
            SetSqlLogModel(dalSup);
            return dalSup.SearchTableForSample(dic);
        }

        /// <summary>
        /// 樣品準備作業 執行
        /// </summary>
        /// <returns></returns>
        public string SampleChkDistExec(Dictionary<string, string> dic)
        {
            SetSqlLogModel(dalPaku2);
            return Convert.ToString(dalPaku2.InsertPaku2(dic));
        }

        /// <summary>
        /// 樣品點收維護 查詢
        /// </summary>
        /// <returns></returns>
        public DataTable SampleChkMTSearch(Dictionary<string, string> dic)
        {
            SetSqlLogModel(dalRecua);
            return dalRecua.SearchTable(dic);
        }

        /// <summary>
        /// 樣品點收維護 刪除
        /// </summary>
        /// <returns></returns>
        public string SampleChkMTDelete(Dictionary<string, string> dic)
        {
            SetSqlLogModel(dalRecua);
            return Convert.ToString(dalRecua.DeleteRecua(dic));
        }

        /// <summary>
        /// 樣品Invoice維護 查詢
        /// </summary>
        /// <returns></returns>
        public DataTable SampleInvMTSearch(Dictionary<string, string> dic)
        {
            SetSqlLogModel(dalInvu);
            return dalInvu.SearchTable(dic);
        }

        /// <summary>
        /// 樣品Invoice維護 新增
        /// </summary>
        /// <returns></returns>
        public string SampleInvMTInsert(Dictionary<string, string> dic)
        {
            SetSqlLogModel(dalInvu);
            return Convert.ToString(dalInvu.InsertInvu(dic));
        }

        /// <summary>
        /// 樣品Invoice維護 修改
        /// </summary>
        /// <returns></returns>
        public string SampleInvMTUpdate(Dictionary<string, string> dic)
        {
            SetSqlLogModel(dalInvu);
            return Convert.ToString(dalInvu.UpdateInvu(dic));
        }

        /// <summary>
        /// 樣品Invoice維護 Invoice報表 
        /// </summary>
        /// <returns></returns>
        public DataTable SampleInvMTReportIV(Dictionary<string, string> dic)
        {
            SetSqlLogModel(dalInvu);
            return dalInvu.SampleIVReport(dic);
        }

        /// <summary>
        /// 樣品Invoice維護 Packing報表 
        /// </summary>
        /// <returns></returns>
        public DataTable SampleInvMTReportPacking(Dictionary<string, string> dic)
        {
            SetSqlLogModel(dalInvu);
            return dalInvu.SamplePackingReport(dic);
        }

        /// <summary>
        /// 樣品備貨作業 查詢 
        /// </summary>
        /// <returns></returns>
        public DataTable SamplePackSearch(Dictionary<string, string> dic)
        {
            SetSqlLogModel(dalPaku2);
            return dalPaku2.SearchTable(dic);
        }

        /// <summary>
        /// 樣品備貨作業 檢查IV 
        /// </summary>
        /// <returns></returns>
        public DataTable SamplePackCheckIV(Dictionary<string, string> dic)
        {
            SetSqlLogModel(dalInvu);
            return dalInvu.SearchIV(dic);
        }

        /// <summary>
        /// 樣品備貨作業 新增
        /// </summary>
        /// <returns></returns>
        public string SamplePackInsert(Dictionary<string, string> dic)
        {
            SetSqlLogModel(dalPaku);
            return Convert.ToString(dalPaku.InsertPaku(dic));
        }

        /// <summary>
        /// 樣品備貨作業 刪除
        /// </summary>
        /// <returns></returns>
        public string SamplePackDelete(Dictionary<string, string> dic)
        {
            SetSqlLogModel(dalPaku2);
            return Convert.ToString(dalPaku2.DeletePaku2(dic));
        }

        /// <summary>
        /// 樣品備貨維護 查詢 
        /// </summary>
        /// <returns></returns>
        public DataTable SamplePackMTSearch(Dictionary<string, string> dic)
        {
            SetSqlLogModel(dalPaku);
            return dalPaku.SearchTable(dic);
        }

        /// <summary>
        /// 樣品備貨維護 修改
        /// </summary>
        /// <returns></returns>
        public string SamplePackMTUpdate(Dictionary<string, string> dic)
        {
            SetSqlLogModel(dalPaku);
            return Convert.ToString(dalPaku.UpdatePaku(dic));
        }

        /// <summary>
        /// 樣品備貨維護 刪除
        /// </summary>
        /// <returns></returns>
        public string SamplePackMTDelete(Dictionary<string, string> dic)
        {
            SetSqlLogModel(dalPaku);
            return Convert.ToString(dalPaku.DeletePaku(dic));
        }
    }
}
