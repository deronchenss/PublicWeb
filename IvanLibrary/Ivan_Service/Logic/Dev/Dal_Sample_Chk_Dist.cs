using Ivan_Dal;
using System.Data;
using System.Web;

namespace Ivan_Service
{
    public class Dal_Sample_Chk_Dist : DataOperator
    {
        /// <summary>
        /// 樣品準備作業 查詢 Return DataTable
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        public DataTable SearchTable(HttpContext context)
        {
			DataTable dt = new DataTable();
            string sqlStr = "";

			sqlStr = @"SELECT DISTINCT Top 500 {0} 點收批號 
					   			      ,A.頤坊型號
					   			      ,A.產品說明
					   			      ,A.單位
					   			      ,IIF(A.內湖庫存數 = 0, NULL, A.內湖庫存數) 內湖庫存數
								      ,IIF(A.內湖庫存數 IS NULL, 0, A.內湖庫存數) 備貨數量
					   			      ,A.內湖庫位 內湖庫位
					   			      ,{1} 到貨處理
					   			      ,A.廠商編號
					   			      ,A.廠商簡稱
					   			      ,A.暫時型號
					   			      ,{2} 採購單號
					   			      ,A.序號
					   			      ,A.更新人員
					   			      ,CONVERT(VARCHAR,A.更新日期,23) 更新日期
					   FROM SUPLU A ";

			foreach (string form in context.Request.Form)
			{
                if (!string.IsNullOrEmpty(context.Request[form]) && form != "Call_Type" && form != "DATA_SOURCE")
                {
                    string debug = context.Request[form];
                    switch (form)
                    {
                        case "點收日期_S":
                        case "點收日期_E":
                        case "採購單號":
                        case "點收批號":
                            sqlStr = string.Format(sqlStr, "ISNULL(R.點收批號, '')", "ISNULL(P.到貨處理, '')", "ISNULL(R.採購單號, '')");
                            sqlStr += @" INNER JOIN PUDU P ON A.序號 = P.SUPLU_SEQ
										 INNER JOIN recua R ON P.序號 = R.PUDU_SEQ ";
                            break;
                        case "訂單號碼":
							sqlStr = string.Format(sqlStr, "ISNULL(ST.訂單號碼, '')", "''", "''");
							sqlStr += @" INNER JOIN stkioh ST ON A.序號 = ST.SUPLU_SEQ ";
                            break;
                    }
                }
			}

			if(sqlStr.IndexOf("{0}") != -1)
            {
				sqlStr = string.Format(sqlStr, "''", "''", "''");
			}

			sqlStr += "WHERE 1=1";
			//共用function 需調整日期名稱,form !=, 簡稱類, 串TABLE 簡稱 
			foreach (string form in context.Request.Form)
            {
                if (!string.IsNullOrEmpty(context.Request[form]) && form != "Call_Type" && form != "DATA_SOURCE")
                {
                    string debug = context.Request[form];
                    switch (form)
                    {
                        case "點收日期_S":
                            sqlStr += " AND CONVERT(DATE,R.[點收日期]) >= @點收日期_S";
                            this.SetParameters(form, context.Request[form]);
                            break;
                        case "點收日期_E":
                            sqlStr += " AND CONVERT(DATE,R.[點收日期]) <= @點收日期_E";
                            this.SetParameters(form, context.Request[form]);
                            break;
						case "採購單號":
						case "點收批號":
							sqlStr += " AND ISNULL(R.[" + form + "],'') LIKE @" + form + " + '%'";
							this.SetParameters(form, context.Request[form]);
							break;
						case "訂單號碼":
							sqlStr += " AND ISNULL(ST.[" + form + "],'') LIKE @" + form + " + '%'";
							this.SetParameters(form, context.Request[form]);
							break;
						case "廠商簡稱":
                            sqlStr += " AND ISNULL(A.[廠商簡稱],'') LIKE '%' + @廠商簡稱 + '%'";
                            this.SetParameters(form, context.Request[form]);
                            break;
                        default:
                            sqlStr += " AND ISNULL(A.[" + form + "],'') LIKE @" + form + " + '%'";
                            this.SetParameters(form, context.Request[form]);
                            break;
                    }
                }
            }

            dt = GetDataTable(sqlStr);
			return dt;
        }

		/// <summary>
		/// 寫入出貨 TABLE 
		/// </summary>
		/// <param name="context"></param>
		/// <returns></returns>
		public int InsertPaku2(HttpContext context)
		{
			int res = 0;
			string sqlStr = @" DECLARE @MAX_SEQ int; 
						       Select @MAX_SEQ = IsNull(Max(序號),0)+1 From [paku2]
						       INSERT INTO [dbo].[paku2]
						       			([序號]
						       			,[SUPLU_SEQ]
						       			,[備貨日期]
						       			,[客戶編號]
						       			,[客戶簡稱]
						       			,[頤坊型號]
						       			,[暫時型號]
						       			,[產品說明]
						       			,[單位]
						       			,[備貨數量]
						       			,[核銷數量]
						       			,[廠商編號]
						       			,[廠商簡稱]
						       			,[來源]
						       			,[點收批號]
						       			,[已刪除]
						       			,[變更日期]
						       			,[更新人員]
						       			,[更新日期])
						       	SELECT @MAX_SEQ [序號]
						       			,序號 SUPLU_SEQ
						       			,GETDATE() 備貨日期
						       			,@CUST_NO 客戶編號
						       			,@CUST_S_NAME 客戶簡稱
						       			,A.[頤坊型號]
						       			,A.[暫時型號]
						       			,A.[產品說明]
						       			,A.[單位]
						       			,@APP_CNT 備貨數量
						       			,0 核銷數量
						       			,A.[廠商編號]
						       			,A.[廠商簡稱]
						       			,'suplu' 來源
						       			,'' 點收批號
						       			,0 已刪除
						       			,NULL 變更日期
						       			,@USER 更新人員
						       			,GETDATE() 更新日期
						       FROM suplu A
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
											,A.序號 [SUPLU_SEQ]
											,@MAX_SEQ SOURCE_SEQ
											,'paku2' SOURCE_TABLE
											,'樣品出庫(準備出貨)' [訂單號碼]
											,@BATCH_NO [單據編號]
											,GETDATE() [異動日期]
											,'D' [帳項]
											,NULL [帳項原因]
											,A.[廠商編號]
											,A.[廠商簡稱]
											,A.[頤坊型號]
											,A.[暫時型號]
											,A.[單位]
											,'內湖' [庫區]
											,0 [入庫數]
											,@APP_CNT [出庫數]
											,A.內湖庫位 [庫位]
											,0 [核銷數]
											,0 [異動前庫存]
											,0 [實扣快取數]
											,@CUST_NO 客戶編號
						       			    ,@CUST_S_NAME 客戶簡稱
											,NULL [完成品型號]
											,NULL [備註]
											,NULL [內銷入庫]
											,0 [已刪除]
											,NULL [變更日期]
											,@USER [更新人員]
											,GETDATE() [更新日期]
										FROM suplu A
										WHERE A.序號 = @SEQ

						       UPDATE suplu
						       SET 內湖庫存數 = ISNULL(內湖庫存數,0) - @APP_CNT
								  ,變更日期 = GETDATE()
								  ,更新人員 = @USER
						       WHERE 序號 = @SEQ
						       ";

			string[] seqArray = context.Request["SEQ[]"].Split(',');
			string[] appCntArray = context.Request["APP_CNT[]"].Split(',');
			string[] batchNoArray = context.Request["BATCH_NO[]"].Split(',');

			this.SetTran();
			for (int cnt = 0; cnt < seqArray.Length; cnt++)
			{
				this.ClearParameter();
				this.SetParameters("SEQ", seqArray[cnt]);
				this.SetParameters("APP_CNT", appCntArray[cnt]);
				this.SetParameters("BATCH_NO", batchNoArray[cnt]);
				this.SetParameters("CUST_NO", context.Request["CUST_NO"]);
				this.SetParameters("CUST_S_NAME", context.Request["CUST_S_NAME"]);
				this.SetParameters("USER", "IVAN10");
				res = Execute(sqlStr);
			}
			this.TranCommit();

			return res;
		}
	}
}
