using Ivan_Log;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;

namespace Ivan_Service
{
    /// <summary>
    /// 目前放在Service層 應切割放於ToolKit層
    /// </summary>
    public class ContextFN
    {
        /// <summary>
        /// 傳入context回傳 Dictionary<string,string> 排除Call_Type
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        public static Dictionary<string, string> ContextToDictionary(HttpContext context)
        {
            Dictionary<string, string> dic = context.Request.Form.AllKeys.Where(x => x != "Call_Type").ToDictionary(k => k, k => context.Request.Form[k]);
            return dic;
        }
    }
}