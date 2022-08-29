using Ivan.Models;
using Ivan_Dal;
using System.Data;
using System.Data.SqlClient;

namespace Ivan_Service
{
    public class ServiceBase
    {
        protected DataOperator _dataOperator = new DataOperator();
        protected DataTable GetDataTable(IDalBase dalBase)
        {
            _dataOperator.cmd = dalBase.cmd;
            return _dataOperator.GetDataTable();
        }

        protected int Execute(IDalBase dalBase)
        {
            _dataOperator.cmd = dalBase.cmd;
            return _dataOperator.Execute();
        }
        public SqlLogModel sqlLogModel => _dataOperator._sqlLogModel;
    }
}
