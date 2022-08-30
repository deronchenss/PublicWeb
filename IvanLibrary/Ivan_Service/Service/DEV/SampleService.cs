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
            return this.GetDataTable(dalPudu.SearchTableForMT(dic));
        }

        /// <summary>
        /// 樣品開發查詢維護 報表
        /// </summary>
        /// <returns></returns>
        public DataTable SampleMTReport(Dictionary<string, string> dic)
        {
            return this.GetDataTable(dalPudu.SampleMTReport(dic));
        }

        /// <summary>
        /// 樣品開發查詢維護 新增
        /// </summary>
        /// <returns></returns>
        public string SampleMTInsert(Dictionary<string, string> dic)
        {
            _dataOperator.SetTran();
            int res = this.Execute(dalPudu.InsertPudu(dic));
            _dataOperator.TranCommit();
            return Convert.ToString(res);
        }

        /// <summary>
        /// 樣品開發查詢維護 修改
        /// </summary>
        /// <returns></returns>
        public string SampleMTUpdate(Dictionary<string, string> dic)
        {
            _dataOperator.SetTran();
            int res = this.Execute(dalPudu.UpdatePudu(dic));
            _dataOperator.TranCommit();
            return Convert.ToString(res);
        }

        /// <summary>
        /// 樣品開發查詢維護 更新序號
        /// </summary>
        /// <returns></returns>
        public string SampleMTUpdateSeq(Dictionary<string, string> dic)
        {
            _dataOperator.SetTran();
            int res = this.Execute(dalPudu.UpdateSeq(dic));
            _dataOperator.TranCommit();
            return Convert.ToString(res);
        }

        /// <summary>
        /// 樣品開發查詢維護 更新列印備註
        /// </summary>
        /// <returns></returns>
        public string SampleMTUpdateRptRemark(Dictionary<string, string> dic)
        {
            _dataOperator.SetTran();
            int res = this.Execute(dalPudu.UpdateRptRemark(dic));
            _dataOperator.TranCommit();
            return Convert.ToString(res);
        }

        /// <summary>
        /// 樣品開發查詢維護 更新核銷
        /// </summary>
        /// <returns></returns>
        public string SampleMTUpdateWriteOff(Dictionary<string, string> dic)
        {
            int res = 0;
            _dataOperator.SetTran();
            string[] seqArr = dic["SEQ[]"].Split(',');
            foreach (string seq in seqArr)
            {
                res = this.Execute(dalPudu.UpdateWriteOff(dic,seq));
            }
            _dataOperator.TranCommit();
            return Convert.ToString(res);
        }

        /// <summary>
        /// 樣品到貨 查詢
        /// </summary>
        /// <returns></returns>
        public DataTable SampleArrSearch(Dictionary<string, string> dic)
        {
            return this.GetDataTable(dalPudu.SearchTableForRecu(dic));
        }

        /// <summary>
        /// 樣品到貨 執行
        /// </summary>
        /// <returns></returns>
        public string SampleArrExec(Dictionary<string, string> dic)
        {
            string[] seqArray = dic["SEQ[]"].Split(',');
            int res = 0;
            _dataOperator.SetTran();
            for (int cnt = 0; cnt < seqArray.Length; cnt++)
            {
                res += this.Execute(dalRecu.InsertRecu(dic, cnt));
            }
            _dataOperator.TranCommit();
            return Convert.ToString(res);
        }

        /// <summary>
        /// 樣品到貨維護 查詢
        /// </summary>
        /// <returns></returns>
        public DataTable SampleArrMTSearch(Dictionary<string, string> dic)
        {
            return this.GetDataTable(dalRecu.SearchTable(dic));
        }

        /// <summary>
        /// 樣品到貨維護 修改
        /// </summary>
        /// <returns></returns>
        public string SampleArrMTUpdate(Dictionary<string, string> dic)
        {
            _dataOperator.SetTran();
            int res = this.Execute(dalRecu.UpdateRecu(dic));
            _dataOperator.TranCommit();
            return Convert.ToString(res);
        }

        /// <summary>
        /// 樣品到貨維護 刪除
        /// </summary>
        /// <returns></returns>
        public string SampleArrMTDelete(Dictionary<string, string> dic)
        {
            _dataOperator.SetTran();
            int res = this.Execute(dalRecu.DeleteRecu(dic));
            _dataOperator.TranCommit();
            return Convert.ToString(res);
        }

        /// <summary>
        /// 樣品到貨維護 報表
        /// </summary>
        /// <returns></returns>
        public DataTable SampleArrMTReport(Dictionary<string, string> dic)
        {
            return this.GetDataTable(dalRecu.SampleShippingReport(dic));
        }

        /// <summary>
        /// 樣品點收作業 查詢
        /// </summary>
        /// <returns></returns>
        public DataTable SampleChkSearch(Dictionary<string, string> dic)
        {
            return this.GetDataTable(dalPudu.SearchTable(dic));
        }

        /// <summary>
        /// 樣品點收作業 執行
        /// </summary>
        /// <returns></returns>
        public string SampleChkExec(Dictionary<string, string> dic)
        {
            string[] seqArray = dic["SEQ[]"].Split(',');
            int res = 0;
            _dataOperator.SetTran();
            for (int cnt = 0; cnt < seqArray.Length; cnt++)
            {
                res += this.Execute(dalRecua.InsertRecua(dic, cnt));
            }
            _dataOperator.TranCommit();
            return Convert.ToString(res);
        }

        /// <summary>
        /// 樣品準備作業 查詢
        /// </summary>
        /// <returns></returns>
        public DataTable SampleChkDistSearch(Dictionary<string, string> dic)
        {
            return this.GetDataTable(dalSup.SearchTableForSample(dic));
        }

        /// <summary>
        /// 樣品準備作業 執行
        /// </summary>
        /// <returns></returns>
        public string SampleChkDistExec(Dictionary<string, string> dic)
        {
            string[] seqArray = dic["SEQ[]"].Split(',');
            int res = 0;
            _dataOperator.SetTran();
            for (int cnt = 0; cnt < seqArray.Length; cnt++)
            {
                res += this.Execute(dalPaku2.InsertPaku2(dic, cnt));
            }
            _dataOperator.TranCommit();
            return Convert.ToString(res);
        }

        /// <summary>
        /// 樣品點收維護 查詢
        /// </summary>
        /// <returns></returns>
        public DataTable SampleChkMTSearch(Dictionary<string, string> dic)
        {
            return this.GetDataTable(dalRecua.SearchTable(dic));
        }

        /// <summary>
        /// 樣品點收維護 刪除
        /// </summary>
        /// <returns></returns>
        public string SampleChkMTDelete(Dictionary<string, string> dic)
        {
            _dataOperator.SetTran();
            int res = this.Execute(dalRecua.DeleteRecua(dic));
            _dataOperator.TranCommit();
            return Convert.ToString(res);
        }

        /// <summary>
        /// 樣品Invoice維護 查詢
        /// </summary>
        /// <returns></returns>
        public DataTable SampleInvMTSearch(Dictionary<string, string> dic)
        {
            return this.GetDataTable(dalInvu.SearchTable(dic));
        }

        /// <summary>
        /// 樣品Invoice維護 新增
        /// </summary>
        /// <returns></returns>
        public string SampleInvMTInsert(Dictionary<string, string> dic)
        {
            _dataOperator.SetTran();
            DataTable dt = this.GetDataTable(dalInvu.InsertInvu(dic));
            _dataOperator.TranCommit();
            return dt.Rows[0]["INVOICE"].ToString();
        }

        /// <summary>
        /// 樣品Invoice維護 修改
        /// </summary>
        /// <returns></returns>
        public string SampleInvMTUpdate(Dictionary<string, string> dic)
        {
            _dataOperator.SetTran();
            int res = this.Execute(dalInvu.UpdateInvu(dic));
            _dataOperator.TranCommit();
            return Convert.ToString(res);
        }

        /// <summary>
        /// 樣品Invoice維護 Invoice報表 
        /// </summary>
        /// <returns></returns>
        public DataTable SampleInvMTReportIV(Dictionary<string, string> dic)
        {
            return this.GetDataTable(dalInvu.SampleIVReport(dic));
        }

        /// <summary>
        /// 樣品Invoice維護 Packing報表 
        /// </summary>
        /// <returns></returns>
        public DataTable SampleInvMTReportPacking(Dictionary<string, string> dic)
        {
            return this.GetDataTable(dalInvu.SamplePackingReport(dic));
        }

        /// <summary>
        /// 樣品備貨作業 查詢 
        /// </summary>
        /// <returns></returns>
        public DataTable SamplePackSearch(Dictionary<string, string> dic)
        {
            return this.GetDataTable(dalPaku2.SearchTable(dic));
        }

        /// <summary>
        /// 樣品備貨作業 檢查IV 
        /// </summary>
        /// <returns></returns>
        public DataTable SamplePackCheckIV(Dictionary<string, string> dic)
        {
            return this.GetDataTable(dalInvu.SearchIV(dic));
        }

        /// <summary>
        /// 樣品備貨作業 新增
        /// </summary>
        /// <returns></returns>
        public string SamplePackInsert(Dictionary<string, string> dic)
        {
            string[] seqArray = dic["SEQ[]"].Split(',');
            int res = 0;
            _dataOperator.SetTran();
            for (int cnt = 0; cnt < seqArray.Length; cnt++)
            {
                res += this.Execute(dalPaku.InsertPaku(dic, cnt));
            }
            _dataOperator.TranCommit();
            return Convert.ToString(res);
        }

        /// <summary>
        /// 樣品備貨作業 刪除
        /// </summary>
        /// <returns></returns>
        public string SamplePackDelete(Dictionary<string, string> dic)
        {
            string[] seqArray = dic["SEQ[]"].Split(',');
            int res = 0;
            _dataOperator.SetTran();
            for (int cnt = 0; cnt < seqArray.Length; cnt++)
            {
                res += this.Execute(dalPaku2.DeletePaku2(dic, cnt));
            }
            _dataOperator.TranCommit();
            return Convert.ToString(res);
        }

        /// <summary>
        /// 樣品備貨維護 查詢 
        /// </summary>
        /// <returns></returns>
        public DataTable SamplePackMTSearch(Dictionary<string, string> dic)
        {
            return this.GetDataTable(dalPaku.SearchTable(dic));
        }

        /// <summary>
        /// 樣品備貨維護 修改
        /// </summary>
        /// <returns></returns>
        public string SamplePackMTUpdate(Dictionary<string, string> dic)
        {
            _dataOperator.SetTran();
            int res = this.Execute(dalPaku.UpdatePaku(dic));
            _dataOperator.TranCommit();
            return Convert.ToString(res);
        }

        /// <summary>
        /// 樣品備貨維護 刪除
        /// </summary>
        /// <returns></returns>
        public string SamplePackMTDelete(Dictionary<string, string> dic)
        {
            _dataOperator.SetTran();
            int res = this.Execute(dalPaku.DeletePaku(dic));
            _dataOperator.TranCommit();
            return Convert.ToString(res);
        }
    }
}
