using Ivan_Log;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Reflection;

namespace Ivan_Service
{
    /// <summary>
    /// 目前放在Service層 應切割放於ToolKit層
    /// </summary>
    public class DataTableHelper
    {
		public static List<T> ConvertDataTable<T>(DataTable dt) where T : new()
		{
			string dtJson = JsonConvert.SerializeObject(dt);
			List<T> data = JsonConvert.DeserializeObject<List<T>>(dtJson);

			return data;
		}
	}
}