using Ivan_Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;

namespace Ivan_Dal
{
    public class Dal_Stkioh : Dal_Base
    {

		#region 查詢區域
		/// <summary>
		/// 從Stkio_Sale 取得 stkioh 並回傳
		/// </summary>
		/// <param name="context"></param>
		/// <returns></returns>
		public IDalBase GetDataFromSale(Stkio_Sale stkioSale)
		{
			string sqlStr = @"  SELECT * 
									  ,SA.序號 SALE_SEQ
								FROM stkioh S
								INNER JOIN STKIO_SALE SA ON S.SOURCE_TABLE = 'STKIO' AND S.SOURCE_SEQ = SA.STKIO_SEQ 
								WHERE 1 = 1
								AND ISNULL(SA.已刪除,0) = 0
								AND ISNULL(SA.已結案,0) = 0
								AND ISNULL(S.已刪除,0) = 0
                         ";

			foreach (var property in stkioSale.GetType().GetProperties())
			{
				if (property.GetValue(stkioSale, null) != null && property.Name != "更新人員" && property.Name != "序號")
				{
					switch (property.Name)
					{
						case "序號":
							//序號0代表沒傳入 不處理
							if(stkioSale.序號 != 0)
                            {
								sqlStr += $" AND ISNULL(SA.[{ property.Name}],'') = @{ property.Name} ";
								SetParameters($"@{property.Name}", property.GetValue(stkioSale));
							}
							break;
						default:
							sqlStr += $" AND ISNULL(SA.[{ property.Name}],'') = @{ property.Name} ";
							SetParameters($"@{property.Name}", property.GetValue(stkioSale));
							break;
					}
				}
			}

			this.SetSqlText(sqlStr);
			return this;
		}

		#endregion

		#region 新增區域
		/// <summary>
		/// INSERT stkioh FROM stkio
		/// </summary>
		/// <returns></returns>
		public IDalBase InsertStkiohFromStkio(Stkioh entity)
        {
            CleanParameters();
            string sqlStr = @"      INSERT INTO [dbo].[stkioh]
											([序號]
											,[SUPLU_SEQ]
											,SOURCE_SEQ
											,SOURCE_TABLE
											,[訂單號碼]
											,[單據編號]
											,[異動日期]
											,[帳項]
											,[帳項原因]
											,[廠商編號]
											,[廠商簡稱]
											,[頤坊型號]
											,[暫時型號]
											,[單位]
											,[庫區]
											,[入庫數]
											,[出庫數]
											,[庫位]
											,[核銷數]
											,[異動前庫存]
											,[實扣快取數]
											,[客戶編號]
											,[客戶簡稱]
											,[完成品型號]
											,[備註]
											,[內銷入庫]
											,[已刪除]
											,[變更日期]
                                            ,[建立人員]
											,[建立日期]
											,[更新人員]
											,[更新日期]
											)
										SELECT (Select IsNull(Max(序號),0)+1 From StkioH) [序號]
											,A.SUPLU_SEQ [SUPLU_SEQ]
											,@序號 SOURCE_SEQ
											,'stkio' SOURCE_TABLE
											,A.訂單號碼 [訂單號碼]
											,A.單據編號 [單據編號]
											,GETDATE() [異動日期]
											,A.帳項 [帳項]
											,NULL [帳項原因]
											,S.[廠商編號]
											,S.[廠商簡稱]
											,S.[頤坊型號]
											,S.[暫時型號]
											,S.[單位]
											,A.庫區 [庫區]
											,CASE WHEN 入庫數 > 0 THEN @核銷數 ELSE 0 END [入庫數]
											,CASE WHEN 出庫數 > 0 THEN @核銷數 ELSE 0 END [出庫數]
											,A.庫位 [庫位]
											,0 [核銷數]
											,S.{庫區}庫存數 [異動前庫存]
											,@實扣快取數 [實扣快取數]
											,NULL 客戶編號
						       			    ,NULL 客戶簡稱
											,NULL [完成品型號]
											,@備註 [備註]
											,NULL [內銷入庫]
											,0 [已刪除]
											,NULL [變更日期]
                                            ,@更新人員 [建立人員]
											,GETDATE() [建立日期]
											,@更新人員 [更新人員]
											,GETDATE() [更新日期]
									FROM stkio A
									JOIN SUPLU S ON A.SUPLU_SEQ = S.序號
                                    WHERE A.序號 = @序號
									";

            foreach (var property in entity.GetType().GetProperties())
            {
				if(property.GetValue(entity, null) != null)
                {
					switch (property.Name)
					{
						case "庫區":
							sqlStr = sqlStr.Replace("{庫區}", entity.庫區);
							SetParameters($"@{property.Name}", property.GetValue(entity));
							break;
						default:
							SetParameters($"@{property.Name}", property.GetValue(entity));
							break;
					}
				}
            }
            this.SetSqlText(sqlStr);
            return this;
        }
		#endregion

		#region 更新區域
		#endregion

		#region 刪除區域
		/// <summary>
		/// 刪除STKIOH 單筆
		/// </summary>
		/// <returns></returns>
		public IDalBase DeleteStkioh(Stkioh stkioh)
		{
			this.CleanParameters();
			string sqlStr = @"      UPDATE stkioh
                                    SET 已刪除 = 1
                                       ,更新日期 = GETDATE()
									   ,更新人員 = @更新人員
                                    WHERE [序號] = @序號
                                     ";

			this.SetParameters("序號", stkioh.序號);
			this.SetParameters("更新人員", stkioh.更新人員);
			this.SetSqlText(sqlStr);
			return this;
		}

		#endregion
	}
}
