using System.Collections.Generic;
using System.Data;

namespace Ivan_Dal
{
    public class Dal_Recua : Dal_Base
    {
        /// <summary>
        /// 樣品點收維護 查詢 Return DataTable
        /// </summary>
        /// <returns></returns>
        public IDalBase SearchTable(Dictionary<string, string> dic)
        {
            string sqlStr = "";
            sqlStr = @" SELECT TOP 500 RA.[序號]
                            ,P.[採購單號]
                            ,P.[樣品號碼]
                            ,P.[SUPLU_SEQ]
                            ,P.[廠商編號]
                            ,P.[廠商簡稱]
                            ,P.[頤坊型號]
                            ,P.[暫時型號]
                            ,P.[廠商型號]
                            ,P.[產品說明]
                            ,P.[單位]
                            ,RA.[點收批號]
                            ,IIF(RA.[點收數量] = 0, NULL, RA.[點收數量]) 點收數量
                            ,IIF(RA.[核銷數量] = 0, NULL, RA.[核銷數量]) 核銷數量
                            ,CONVERT(VARCHAR,RA.[點收日期],23) [點收日期]
                            ,RA.[運輸編號]
                            ,RA.[運輸簡稱]
                            ,RA.[更新人員]
                            ,CONVERT(VARCHAR,RA.[更新日期],23) [更新日期]
                            ,CAST(ISNULL((SELECT TOP 1 1 FROM [192.168.1.135].pic.dbo.xpic X WHERE X.[SUPLU_SEQ] = P.[SUPLU_SEQ]),0) AS BIT) [Has_IMG]
                FROM Dc2..pudu P
                INNER JOIN RECUA RA ON P.序號 = RA.PUDU_SEQ
                WHERE 1=1 ";

            //共用function 需調整日期名稱,form !=, 簡稱類, 串TABLE 簡稱 
            foreach (string form in dic.Keys)
            {
                if (!string.IsNullOrEmpty(dic[form]) && form != "Account")
                {
                    string debug = dic[form];
                    switch (form)
                    {
                        case "點收日期_S":
                            sqlStr += " AND CONVERT(DATE,[點收日期]) >= @點收日期_S";
                            this.SetParameters(form, dic[form]);
                            break;
                        case "點收日期_E":
                            sqlStr += " AND CONVERT(DATE,[點收日期]) <= @點收日期_E";
                            this.SetParameters(form, dic[form]);
                            break;
                        case "廠商簡稱":
                            sqlStr += " AND ISNULL(RA.[廠商簡稱],'') LIKE '%' + @廠商簡稱 + '%'";
                            this.SetParameters(form, dic[form]);
                            break;
                        default:
                            sqlStr += " AND ISNULL(RA.[" + form + "],'') LIKE @" + form + " + '%'";
                            this.SetParameters(form, dic[form]);
                            break;
                    }
                }
            }

            this.SetSqlText(sqlStr);
            return this;
        }

        /// <summary>
        /// 寫入點收 TABLE 
        /// </summary>
        /// <returns></returns>
        public IDalBase InsertRecua(Dictionary<string, string> dic, int cnt)
        {
            string sqlStr = @"      DECLARE @MAX_SEQ int; 
									Select @MAX_SEQ = IsNull(Max(序號),0)+1 From [recua]
									INSERT INTO [dbo].[recua]
                                                ([序號]
                                                ,[PUDU_SEQ]
                                                ,[點收批號]
                                                ,[採購單號]
                                                ,[樣品號碼]
                                                ,[廠商編號]
                                                ,[廠商簡稱]
                                                ,[頤坊型號]
                                                ,[暫時型號]
                                                ,[廠商型號]
                                                ,[單位]
                                                ,[點收日期]
                                                ,[點收數量]
                                                ,[核銷數量]
                                                ,[運輸編號]
                                                ,[運輸簡稱]
                                                ,[運送方式]
                                                ,[變更日期]
                                                ,[更新人員]
                                                ,[更新日期])
                                    SELECT		@MAX_SEQ [序號]
                                                ,@SEQ [PUDU_SEQ]
                                                ,@CHK_BATCH_NO [點收批號]
                                                ,[採購單號]
                                                ,[樣品號碼]
                                                ,[廠商編號]
                                                ,[廠商簡稱]
                                                ,[頤坊型號]
                                                ,[暫時型號]
                                                ,[廠商型號]
                                                ,[單位]
                                                ,@CHK_DATE [點收日期]
                                                ,@CHK_CNT [點收數量]
                                                ,NULL [核銷數量]
                                                ,@TRANSFER_NO [運輸編號]
                                                ,@TRANSFER_S_NAME [運輸簡稱]
                                                ,NULL [運送方式]
                                                ,NULL [變更日期]
                                                ,@UPD_USER [更新人員]
                                                ,GETDATE()[更新日期]
                                    FROM pudu
                                    WHERE 序號 = @SEQ
                                    
                                    INSERT INTO [dbo].[stkioh]
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
											,[更新人員]
											,[更新日期]
											)
										SELECT (Select IsNull(Max(序號),0)+1 From StkioH) [序號]
											,A.SUPLU_SEQ [SUPLU_SEQ]
											,@MAX_SEQ SOURCE_SEQ
											,'recua' SOURCE_TABLE
											,'樣品點收入庫' [訂單號碼]
											,@CHK_BATCH_NO [單據編號]
											,GETDATE() [異動日期]
											,'6' [帳項]
											,NULL [帳項原因]
											,S.[廠商編號]
											,S.[廠商簡稱]
											,S.[頤坊型號]
											,S.[暫時型號]
											,S.[單位]
											,'內湖' [庫區]
											,@CHK_CNT [入庫數]
											,0 [出庫數]
											,S.內湖庫位 [庫位]
											,0 [核銷數]
											,0 [異動前庫存]
											,0 [實扣快取數]
											,NULL 客戶編號
						       			    ,NULL 客戶簡稱
											,NULL [完成品型號]
											,NULL [備註]
											,NULL [內銷入庫]
											,0 [已刪除]
											,NULL [變更日期]
											,@UPD_USER [更新人員]
											,GETDATE() [更新日期]
									FROM pudu A
									JOIN SUPLU S ON A.SUPLU_SEQ = S.序號
                                    WHERE A.序號 = @SEQ

                                    UPDATE SUPLU
                                    SET 內湖庫存數 = ISNULL(內湖庫存數,0) + @CHK_CNT
									   ,單位淨重 = @NET_WEI
                                       ,單位毛重 = @WEI
                                       ,產品長度 = @LEN
                                       ,產品寬度 = @WIDTH
                                       ,產品高度 = @HEIGHT
									   ,更新人員 = @UPD_USER
									   ,變更日期 = GETDATE()
                                    WHERE 頤坊型號 = @IVAN_TYPE
                                    AND 廠商編號 = @FACT_NO ";

            string[] seqArray = dic["SEQ[]"].Split(',');
            string[] chkCntArr = dic["CHK_CNT[]"].Split(',');
            string[] netWeiArray = dic["NET_WEIGHT[]"].Split(',');
            string[] weiArray = dic["WEIGHT[]"].Split(',');
            string[] lenArr = dic["LEN[]"].Split(',');
            string[] widthArray = dic["WIDTH[]"].Split(',');
            string[] heightArr = dic["HEIGHT[]"].Split(',');
            string[] ivanType = dic["IVAN_TYPE[]"].Split(',');
            string[] factNo = dic["FACT_NO[]"].Split(',');

            this.SetParameters("SEQ", seqArray[cnt]);
            this.SetParameters("CHK_CNT", chkCntArr[cnt]);
            this.SetParameters("CHK_BATCH_NO", dic["CHK_BATCH_NO"]);
            this.SetParameters("TRANSFER_NO", dic["TRANSFER_NO"]);
            this.SetParameters("CHK_DATE", dic["CHK_DATE"]);
            this.SetParameters("TRANSFER_S_NAME", dic["TRANSFER_S_NAME"]);
            this.SetParameters("UPD_USER", "IVAN10");
            this.SetParameters("NET_WEI", string.IsNullOrEmpty(netWeiArray[cnt]) ? "0" : netWeiArray[cnt]);
            this.SetParameters("WEI", string.IsNullOrEmpty(weiArray[cnt]) ? "0" : weiArray[cnt]);
            this.SetParameters("LEN", string.IsNullOrEmpty(lenArr[cnt]) ? "0" : lenArr[cnt]);
            this.SetParameters("WIDTH", string.IsNullOrEmpty(widthArray[cnt]) ? "0" : widthArray[cnt]);
            this.SetParameters("HEIGHT", string.IsNullOrEmpty(heightArr[cnt]) ? "0" : heightArr[cnt]);
            this.SetParameters("IVAN_TYPE", ivanType[cnt]);
            this.SetParameters("FACT_NO", factNo[cnt]);
  
            this.SetSqlText(sqlStr);
            return this;
        }

        /// <summary>
        /// 刪除點收 TABLE 
        /// </summary>
        /// <returns></returns>
        public IDalBase DeleteRecua(Dictionary<string, string> dic)
        {
            string sqlStr = @"      DELETE FROM RECUA 
                                    WHERE [序號] = @SEQ
                                    
                                    UPDATE SUPLU
                                    SET 內湖庫存數 = ISNULL(內湖庫存數,0) - 入庫數
									   ,更新人員 = @UPD_USER
									   ,更新日期 = GETDATE()
                                    FROM SUPLU S
                                    INNER JOIN stkioh ST ON S.序號 = ST.SUPLU_SEQ
                                    WHERE ISNULL(ST.已刪除,0) = 0
                                    AND ST.SOURCE_TABLE = 'recua'
                                    AND ST.SOURCE_SEQ = @SEQ

                                    UPDATE stkioh
                                    SET 更新日期 = GETDATE()
                                       ,更新人員 = @UPD_USER
                                       ,已刪除 = 1
                                    WHERE SOURCE_TABLE = 'recua'
                                    AND SOURCE_SEQ = @SEQ
                                     ";

            this.SetParameters("SEQ", dic["SEQ"]);
            this.SetParameters("UPD_USER", dic["Account"]);
            this.SetSqlText(sqlStr);
            return this;
        }
    }
}
