using Ivan_Dal;
using System.Data;
using System.Web;

namespace Ivan_Service
{
    public class Dal_Sample_Chk : DataOperator
    {
        /// <summary>
        /// 樣品點收 查詢 Return DataTable
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        public DataTable SearchTable(HttpContext context)
        {
			DataTable dt = new DataTable();
            string sqlStr = "";

			sqlStr = @" SELECT Top 500 
                        P.SUPLU_SEQ,P.採購單號,P.廠商簡稱,P.頤坊型號,
                        P.採購數量,P.客戶簡稱,P.暫時型號,P.單位,P.產品說明,
                        ISNULL(SUM(RA.點收數量),0) 點收數量
                        ,CONVERT(VARCHAR, MAX(RA.點收日期), 111) 點收日期
                        ,ISNULL(SUM(R.到貨數量),0) 到貨數量
                        ,CONVERT(VARCHAR, MAX(R.到貨日期), 111) 到貨日期
                        ,P.工作類別 AS 類別,P.樣品號碼,
                        S.設計圖號,P.廠商型號,P.廠商編號,P.客戶編號,
                        S.圖型啟用,P.序號,P.更新人員
                        ,CONVERT(VARCHAR,P.更新日期, 111) 更新日期
                        ,ISNULL(P.到貨處理,' ') 到貨處理
                        ,CONVERT(VARCHAR,P.採購日期, 111) 採購日期
                        ,CONVERT(VARCHAR,P.採購交期, 111) 採購交期
                        ,CASE WHEN ISNULL(S.單位淨重,0) = 0 THEN '' ELSE CONVERT(VARCHAR,S.單位淨重) END 單位淨重
                        ,CASE WHEN ISNULL(S.單位毛重,0) = 0 THEN '' ELSE CONVERT(VARCHAR,S.單位毛重) END 單位毛重
                        ,CASE WHEN ISNULL(S.產品長度,0) = 0 THEN '' ELSE CONVERT(VARCHAR,S.產品長度) END 產品長度
                        ,CASE WHEN ISNULL(S.產品寬度,0) = 0 THEN '' ELSE CONVERT(VARCHAR,S.產品寬度) END 產品寬度
                        ,CASE WHEN ISNULL(S.產品高度,0) = 0 THEN '' ELSE CONVERT(VARCHAR,S.產品高度) END 產品高度
                        ,CASE WHEN P.結案 = 1 THEN '是' ELSE '否' END 結案
                        FROM pudu P
                        INNER JOIN SUPLU S ON P.頤坊型號=S.頤坊型號 AND P.廠商編號=S.廠商編號 
                        LEFT JOIN RECUA RA ON P.序號 = RA.PUDU_SEQ
                        LEFT JOIN RECU R ON P.序號 = R.PUDU_SEQ
                        WHERE IsNull(P.採購單號,'') <> ''
                        AND 工作類別 <>'詢價' ";

			//共用function 需調整日期名稱,form !=, 簡稱類, 串TABLE 簡稱 
			foreach (string form in context.Request.Form)
			{
				if (!string.IsNullOrEmpty(context.Request[form]) && form != "Call_Type" && form != "WRITE_OFF")
				{
					switch (form)
					{
						case "採購日期_S":
							sqlStr += " AND CONVERT(DATE,[採購日期]) >= @採購日期_S";
							this.SetParameters(form, context.Request[form]);
							break;
						case "採購日期_E":
							sqlStr += " AND CONVERT(DATE,[採購日期]) <= @採購日期_E";
							this.SetParameters(form, context.Request[form]);
							break;
						case "廠商簡稱":
							sqlStr += " AND ISNULL(P.[廠商簡稱],'') LIKE '%' + @廠商簡稱 + '%'";
							this.SetParameters(form, context.Request[form]);
							break;
						default:
							sqlStr += " AND ISNULL(P.[" + form + "],'') LIKE @" + form + " + '%'";
							this.SetParameters(form, context.Request[form]);
							break;
					}
				}
			}

			sqlStr += @" GROUP BY P.SUPLU_SEQ,P.採購單號,P.廠商簡稱,P.頤坊型號,P.採購數量,P.客戶簡稱,P.暫時型號,P.單位,P.產品說明
                                                     ,P.工作類別,P.樣品號碼
                                                     ,S.設計圖號,P.廠商型號,P.廠商編號,P.客戶編號,S.圖型啟用,P.序號,P.更新人員
                                                     ,P.更新日期,P.到貨處理,P.採購日期,P.採購交期
                                                     , S.單位淨重, S.單位毛重, S.產品長度, S.產品寬度, S.產品高度, P.結案  ";

			//未結案
			if (!string.IsNullOrEmpty(context.Request["WRITE_OFF"]) && context.Request["WRITE_OFF"] == "0")
			{
				sqlStr += " HAVING P.採購數量 > ISNULL(SUM(RA.點收數量),0)";
			}

			sqlStr += " ORDER BY P.採購單號,P.頤坊型號";
			dt = GetDataTable(sqlStr);
			return dt;
        }

		/// <summary>
		/// 寫入點收 TABLE 
		/// </summary>
		/// <param name="context"></param>
		/// <returns></returns>
		public int InsertRecua(HttpContext context)
		{
			int res = 0;
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
											,'D' [帳項]
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

            string[] seqArray = context.Request["SEQ[]"].Split(',');
			string[] chkCntArr = context.Request["CHK_CNT[]"].Split(',');
			string[] netWeiArray = context.Request["NET_WEIGHT[]"].Split(',');
			string[] weiArray = context.Request["WEIGHT[]"].Split(',');
			string[] lenArr = context.Request["LEN[]"].Split(',');
			string[] widthArray = context.Request["WIDTH[]"].Split(',');
			string[] heightArr = context.Request["HEIGHT[]"].Split(',');
			string[] ivanType = context.Request["IVAN_TYPE[]"].Split(',');
			string[] factNo = context.Request["FACT_NO[]"].Split(',');

            this.SetTran();
            for (int cnt = 0; cnt < seqArray.Length; cnt++)
			{
				this.ClearParameter();
				this.SetParameters("SEQ", seqArray[cnt]);
				this.SetParameters("CHK_CNT", chkCntArr[cnt]);
				this.SetParameters("CHK_BATCH_NO", context.Request["CHK_BATCH_NO"]);
				this.SetParameters("TRANSFER_NO", context.Request["TRANSFER_NO"]);
				this.SetParameters("CHK_DATE", context.Request["CHK_DATE"]);
				this.SetParameters("TRANSFER_S_NAME", context.Request["TRANSFER_S_NAME"]);
				this.SetParameters("UPD_USER", "IVAN10");
				this.SetParameters("NET_WEI", string.IsNullOrEmpty(netWeiArray[cnt]) ? "0" : netWeiArray[cnt]);
				this.SetParameters("WEI", string.IsNullOrEmpty(weiArray[cnt]) ? "0" : weiArray[cnt]);
				this.SetParameters("LEN", string.IsNullOrEmpty(lenArr[cnt]) ? "0" : lenArr[cnt]);
				this.SetParameters("WIDTH", string.IsNullOrEmpty(widthArray[cnt]) ? "0" : widthArray[cnt]);
				this.SetParameters("HEIGHT", string.IsNullOrEmpty(heightArr[cnt]) ? "0" : heightArr[cnt]);
				this.SetParameters("IVAN_TYPE", ivanType[cnt]);
				this.SetParameters("FACT_NO", factNo[cnt]);
				Execute(sqlStr);
			}
			this.TranCommit();

			return res;
		}
	}
}
