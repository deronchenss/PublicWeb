using Ivan.Models;
using Ivan_Dal;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Data;
using System.Text;
using System.Web;

namespace Ivan_Service
{
    public class Dal_Stock_Sale : LogicBase
    {
        public Dal_Stock_Sale(HttpContext _context)
        {
            context = _context;
        }

        #region 查詢區域
        #endregion

        #region 新增區域
        /// <summary>
        /// 門市庫取核銷 
        /// Step1: INSERT stkioh
        /// Step2: UPDATE stkio 核銷數
        /// Step3: UPDATE suplu 庫存數
        /// Step4: INSERT stkio_sale
        /// </summary>
        /// <returns></returns>
        public int MutiInsertStkioSale(List<Stkio_SaleFromStkio> liEntity)
        {
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
                                               ,[箱號S]
                                               ,[箱號E]
                                               ,[內袋]
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
                                               ,@PACK_NO_S [箱號S]
                                               ,@PACK_NO_E [箱號E]
                                               ,@IN_BAG [內袋]
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

            int res = 0;
            this.SetTran();
            foreach (Stkio_SaleFromStkio entity in liEntity)
            {
                ClearParameter();
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
                this.SetParameters("UPD_USER", context.Session["Account"] ?? "IVAN10");
                res += Execute(sqlStr);
            }
            //Log一次寫
            this.TranCommitWithLog();
            return res;
        }
        #endregion

        #region 更新區域
        #endregion

        #region 刪除區域
        #endregion
    }
}
