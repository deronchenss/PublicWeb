using Ivan_Models;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Web;

namespace Ivan_Dal
{
    public class Dal_Stock_Sale : Dal_Base
    {
        #region 查詢區域
        /// <summary>
        /// 門市庫取出貨 查詢 Return DataTable
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        public IDalBase SearchTable(Dictionary<string, string> dic)
        {
            string sqlStr = "";
            sqlStr = @"SELECT Top 500 S.箱號S
			                          ,S.箱號E
			                          ,S.內袋
			                          ,S.pm_no
			                          ,S.訂單號碼
			                          ,S.頤坊型號
			                          ,SU.銷售型號
			                          ,S.單位
			                          ,S.出貨數
			                          ,S.備註
			                          ,SU.產品說明
			                          ,S.出區
			                          ,S.入區
			                          ,CONVERT(VARCHAR,S.出貨日期,23) AS 備貨日期
			                          ,SU.產品一階
			                          ,S.廠商編號
			                          ,S.廠商簡稱
			                          ,S.序號
			                          ,S.更新人員
			                          ,CONVERT(VARCHAR,S.更新日期,23)  更新日期
                                      ,ST.SUPLU_SEQ
                                      ,CASE WHEN (SELECT TOP 1 1 FROM [192.168.1.135].pic.dbo.xpic X WHERE X.[SUPLU_SEQ] = ST.SUPLU_SEQ) = 1 THEN 'Y' ELSE 'N' END [Has_IMG]
                                      ,CASE WHEN (S.入區 = '台北' AND ISNULL(SU.台北安全數,0) = 0) 
                                              OR (S.入區 = '台中' AND ISNULL(SU.台中安全數,0) = 0) 
                                              OR (S.入區 = '高雄' AND ISNULL(SU.高雄安全數,0) = 0) 
                                              OR (S.入區 = '其他')   THEN 'Y' 
                                            ELSE 'N' END 不入庫 
                        FROM stkio_sale S  
                        INNER JOIN stkio ST ON S.STKIO_SEQ = ST.序號 --出庫寫入
                        INNER JOIN suplu SU ON ST.SUPLU_SEQ = SU.序號 
                        LEFT JOIN stkio STI ON S.序號 = STI.SOURCE_SEQ AND STI.SOURCE_TABLE = 'stkio_sale' AND ISNULL(STI.已刪除,0) = 0
                        WHERE NOT (ISNULL(S.出貨數,0) = ISNULL(S.核銷數,0) --舊邏輯
                        OR ISNULL(STI.入庫數,0) = ISNULL(S.出貨數,0)) -- 新邏輯
                        AND ISNULL(S.已刪除,0) = 0
                        AND ISNULL(S.不入庫,0) = 0 --新邏輯已出貨不寫核銷 不入庫不寫stkio 故改用 不入庫辨別
                         ";

            //共用function 需調整日期名稱,form !=, 簡稱類, 串TABLE 簡稱 
            foreach (string form in dic.Keys)
            {
                if (!string.IsNullOrEmpty(dic[form]))
                {
                    string debug = dic[form];
                    switch (form)
                    {
                        default:
                            //PM_NO
                            sqlStr += " AND ISNULL(S.[" + form + "],'') = @" + form;
                            this.SetParameters(form, dic[form]);
                            break;
                    }
                }
            }

            sqlStr += " ORDER BY S.頤坊型號, S.廠商編號 ";
            this.SetSqlText(sqlStr);
            return this;
        }

        #endregion

        #region 新增區域
        /// <summary>
        /// INSERT stkio_sale From stkio 
        /// </summary>
        /// <returns></returns>
        public IDalBase InsertStkioSale(Stkio_SaleFromStkio entity, object account)
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
											,@SEQ SOURCE_SEQ
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
											,CASE WHEN A.入庫數 > 0 THEN @STOCK_O_CNT ELSE 0 END [入庫數]
											,CASE WHEN A.出庫數 > 0 THEN @STOCK_O_CNT ELSE 0 END [出庫數]
											,A.庫位 [庫位]
											,0 [核銷數]
											,S.{庫區}庫存數 [異動前庫存]
											,CASE WHEN @QUICK_TAKE = 'Y' THEN @STOCK_O_CNT ELSE 0 END [實扣快取數]
											,NULL 客戶編號
						       			    ,NULL 客戶簡稱
											,NULL [完成品型號]
											,[備註]
											,NULL [內銷入庫]
											,0 [已刪除]
											,NULL [變更日期]
                                            ,@UPD_USER [建立人員]
											,GETDATE() [建立日期]
											,@UPD_USER [更新人員]
											,GETDATE() [更新日期]
									FROM stkio A
									JOIN SUPLU S ON A.SUPLU_SEQ = S.序號
                                    WHERE A.序號 = @SEQ
                                    
                                    UPDATE stkio
                                    SET 核銷數 = ISNULL(核銷數,0) + @STOCK_O_CNT
                                       ,已結案 = CASE WHEN ISNULL(核銷數,0) + @STOCK_O_CNT >= ISNULL(入庫數,0) + ISNULL(出庫數,0) THEN 1 ELSE 0 END 
                                       ,更新日期 = GETDATE()
									   ,更新人員 = @UPD_USER
                                    WHERE 序號 = @SEQ
                                    
                                    UPDATE SUPLU
                                    SET {庫區}庫存數 = ISNULL({庫區}庫存數,0) + (CASE WHEN ISNULL(ST.出庫數,0) > 0 THEN -1 WHEN ISNULL(ST.入庫數,0) > 0 THEN 1 ELSE 0 END * @STOCK_O_CNT)
									   ,{庫區}庫位 = ST.庫位
                                       ,快取庫存數 = ISNULL(快取庫存數,0) - CASE WHEN @QUICK_TAKE = 'Y' THEN @STOCK_O_CNT ELSE 0 END
									   ,更新日期 = GETDATE()
                                       ,更新人員 = @UPD_USER
                                    FROM SUPLU S
                                    JOIN stkio ST ON S.序號 = ST.SUPLU_SEQ
                                    WHERE ST.序號 = @SEQ

                                    INSERT INTO [dbo].[stkio_sale]
                                               ([序號]
                                               ,[STKIO_SEQ]
                                               ,[pm_no]
                                               ,[訂單號碼]
                                               ,[出貨日期]
                                               ,[廠商編號]
                                               ,[廠商簡稱]
                                               ,[頤坊型號]
                                               ,[銷售型號]
                                               ,[單位]
                                               ,[出區]
                                               ,[入區]
                                               ,[出貨數]
                                               ,[庫位]
                                               ,[核銷數]
                                               ,[備註]
                                               ,[箱號]
                                               ,[產品一階]
                                               ,[皮革型號]
                                               ,[不入庫]
                                               ,[已結案]
                                               ,[已刪除]
                                               ,[變更日期]
                                               ,[建立人員]
                                               ,[建立日期]
                                               ,[更新人員]
                                               ,[更新日期])
                                         SELECT (Select IsNull(Max(序號),0)+1 From stkio_sale) [序號]
                                               ,@SEQ [STKIO_SEQ]
                                               ,@PM_NO [pm_no]
                                               ,S.[訂單號碼] 訂單號碼
                                               ,GETDATE() [出貨日期]
                                               ,SU.[廠商編號]
                                               ,SU.[廠商簡稱]
                                               ,SU.[頤坊型號]
                                               ,SU.[銷售型號]
                                               ,SU.[單位]
                                               ,@STOCK_POS_O [出區]
                                               ,@STOCK_POS_I [入區]
                                               ,@STOCK_O_CNT [出貨數]
                                               ,S.[庫位] 庫位
                                               ,0 [核銷數]
                                               ,@REMARK [備註]
                                               ,@PACK_NO [箱號]
                                               ,SU.[產品一階] 產品一階
                                               ,NULL [皮革型號]
                                               ,0 [不入庫]
                                               ,0 [已結案]
                                               ,0 [已刪除]
                                               ,GETDATE() [變更日期]
                                               ,@UPD_USER [建立人員]
                                               ,GETDATE() [建立日期]
                                               ,@UPD_USER [更新人員]
                                               ,GETDATE() [更新日期]
	                                    FROM stkio S
                                        INNER JOIN suplu SU ON S.SUPLU_SEQ = SU.序號
	                                    WHERE S.序號 = @SEQ
									";
          
            foreach (var property in entity.GetType().GetProperties())
            {
                if ("STOCK_POS_O".Equals(property.Name))
                {
                    sqlStr = sqlStr.Replace("{庫區}", entity.STOCK_POS_O);
                    SetParameters($"@{property.Name}", property.GetValue(entity));
                }
                else
                {
                    SetParameters($"@{property.Name}", property.GetValue(entity));
                }
            }
            this.SetParameters("UPD_USER", account ?? "IVAN10");
            this.SetSqlText(sqlStr);
            return this;
        }

        /// <summary>
        /// INSERT stkio_sale From stkio 
        /// </summary>
        /// <returns></returns>
        public IDalBase InsertStkioSaleFromStkio(Stkio_Sale stkioSale)
        {
            CleanParameters();
            string sqlStr = @"      INSERT INTO [dbo].[stkio_sale]
                                               ([序號]
                                               ,[STKIO_SEQ]
                                               ,[pm_no]
                                               ,[訂單號碼]
                                               ,[出貨日期]
                                               ,[廠商編號]
                                               ,[廠商簡稱]
                                               ,[頤坊型號]
                                               ,[銷售型號]
                                               ,[單位]
                                               ,[出區]
                                               ,[入區]
                                               ,[出貨數]
                                               ,[庫位]
                                               ,[核銷數]
                                               ,[備註]
                                               ,[箱號]
                                               ,[產品一階]
                                               ,[皮革型號]
                                               ,[不入庫]
                                               ,[已結案]
                                               ,[已刪除]
                                               ,[變更日期]
                                               ,[建立人員]
                                               ,[建立日期]
                                               ,[更新人員]
                                               ,[更新日期])
                                         SELECT (Select IsNull(Max(序號),0)+1 From stkio_sale) [序號]
                                               ,@序號 [STKIO_SEQ]
                                               ,@PM_NO [pm_no]
                                               ,S.[訂單號碼] 訂單號碼
                                               ,GETDATE() [出貨日期]
                                               ,SU.[廠商編號]
                                               ,SU.[廠商簡稱]
                                               ,SU.[頤坊型號]
                                               ,SU.[銷售型號]
                                               ,SU.[單位]
                                               ,@出區 [出區]
                                               ,@入區 [入區]
                                               ,@出貨數 [出貨數]
                                               ,S.[庫位] 庫位
                                               ,0 [核銷數]
                                               ,@備註 [備註]
                                               ,@箱號 [箱號]
                                               ,SU.[產品一階] 產品一階
                                               ,NULL [皮革型號]
                                               ,0 [不入庫]
                                               ,0 [已結案]
                                               ,0 [已刪除]
                                               ,GETDATE() [變更日期]
                                               ,@更新人員 [建立人員]
                                               ,GETDATE() [建立日期]
                                               ,@更新人員 [更新人員]
                                               ,GETDATE() [更新日期]
	                                    FROM stkio S
                                        INNER JOIN suplu SU ON S.SUPLU_SEQ = SU.序號
	                                    WHERE S.序號 = @序號
									";

            foreach (var property in stkioSale.GetType().GetProperties())
            {
                if (property.GetValue(stkioSale, null) != null)
                {
                    SetParameters($"@{property.Name}", property.GetValue(stkioSale));
                }
            }
            this.SetSqlText(sqlStr);
            return this;
        }
        #endregion

        #region 更新區域
        /// <summary>
        /// UPDATE Stkio_sale By 序號
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        public IDalBase UpdateStkioSale(Stkio_Sale entity)
        {
            CleanParameters();
            string sqlStr = @"      UPDATE [dbo].[stkio_sale]
                                       SET 更新日期 = GETDATE()
                                    ";

            foreach (var property in entity.GetType().GetProperties())
            {
                if (property.GetValue(entity, null) != null)
                {
                    switch (property.Name)
                    {
                        case "序號":
                            this.SetParameters(property.Name, property.GetValue(entity));
                            break;
                        default:
                            sqlStr += " ," + property.Name + " = @" + property.Name;
                            this.SetParameters(property.Name, property.GetValue(entity));
                            break;
                    }
                }
            }

            sqlStr += " WHERE [序號] = @序號 ";
            this.SetSqlText(sqlStr);
            return this;
        }
        #endregion

        #region 刪除區域
        /// <summary>
		/// 刪除STKIOH 單筆
		/// </summary>
		/// <returns></returns>
		public IDalBase DeleteStkioSale(Stkio_Sale stkioSale)
        {
            this.CleanParameters();
            string sqlStr = @"      UPDATE stkio_sale
                                    SET 已刪除 = 1
                                       ,更新日期 = GETDATE()
									   ,更新人員 = @更新人員
                                    WHERE [序號] = @序號
                                     ";

            this.SetParameters("序號", stkioSale.序號);
            this.SetParameters("更新人員", stkioSale.更新人員);
            this.SetSqlText(sqlStr);
            return this;
        }

        #endregion
    }
}
