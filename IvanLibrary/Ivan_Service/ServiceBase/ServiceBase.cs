using Ivan.Models;
using Ivan_Dal;

namespace Ivan_Service
{
    public class ServiceBase
    {
        private IDataOperator _dataOperator;
        protected void SetSqlLogModel(IDataOperator dataOperator) {
            _dataOperator = dataOperator;
        }
        public SqlLogModel sqlLogModel => _dataOperator._sqlLogModel;
    }
}
