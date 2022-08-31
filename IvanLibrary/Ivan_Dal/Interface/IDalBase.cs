using Ivan_Models;
using System.Data.SqlClient;

namespace Ivan_Dal
{
    public interface IDalBase
    {
        SqlCommand cmd { get; set; }
    }
}
