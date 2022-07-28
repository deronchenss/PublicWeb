using Ivan_Dal;
using System.Data;
using System.Web;

namespace Ivan_Service
{
    public class Dal_Paku2 : LogicBase
	{
		public Dal_Paku2(HttpContext _context)
		{
			context = _context;
		}
		/// <summary>
		/// 樣品備貨 查詢 Return DataTable
		/// </summary>
		/// <param name="context"></param>
		/// <returns></returns>
		public DataTable SearchTable()
		{
			DataTable dt = new DataTable();
			string sqlStr = "";

			sqlStr = @" WITH TOT (PAKU2_SEQ,出貨數量)
						AS
						(
							SELECT   PAKU2_SEQ 
									,SUM(出貨數量)
							FROM paku P 
							WHERE ISNULL(P.已刪除,0)=0
							GROUP BY PAKU2_SEQ 
						)

						SELECT TOP 500 P.[序號]
				        	  ,P.[SUPLU_SEQ]
				        	  ,CONVERT(VARCHAR,P.[備貨日期],23) [備貨日期]
				        	  ,P.[客戶編號]
				        	  ,P.[客戶簡稱]
							  ,CASE WHEN B.客戶型號 IS NULL THEN '未建檔' ELSE B.客戶型號 END [客戶型號]
				        	  ,P.[頤坊型號]
				        	  ,P.[暫時型號]
				        	  ,P.[產品說明]
				        	  ,P.[單位]
				        	  ,ISNULL(P.備貨數量,0)-ISNULL(TOT.出貨數量,0) [備貨數量]
				        	  ,P.[廠商編號]
					          ,P.[廠商編號]
				        	  ,P.[廠商簡稱]
							  ,CASE WHEN B.客戶型號 IS NULL THEN '未建檔' 
								    WHEN B.停用日期 IS NOT NULL THEN '停用' 
								    WHEN Isnull(B.美元單價,0)+Isnull(B.台幣單價,0)+Isnull(B.外幣單價,0) = 0 THEN '無價格'
									ELSE 'OK' END 狀態
				        	  ,P.[來源]
				        	  ,P.[點收批號]
				        	  ,P.[已刪除]
				        	  ,P.[變更日期]
				        	  ,P.[更新人員]
				        	  ,CONVERT(VARCHAR,P.[更新日期],23) 更新日期
							  ,B.序號 BYRLU_SEQ
				        FROM [dbo].[paku2] P
						LEFT JOIN TOT ON P.序號 = TOT.PAKU2_SEQ
						LEFT JOIN SUPLU S ON P.SUPLU_SEQ = S.序號
					    LEFT JOIN BYRLU B ON P.SUPLU_SEQ = B.SUPLU_SEQ AND P.客戶編號 = B.客戶編號
						WHERE ISNULL(P.已刪除,0)=0
						AND ISNULL(P.備貨數量,0)-ISNULL(TOT.出貨數量,0) > 0 ";

			//共用function 需調整日期名稱,form !=, 簡稱類, 串TABLE 簡稱 
			foreach (string form in context.Request.Form)
			{
				if (!string.IsNullOrEmpty(context.Request[form]) && form != "Call_Type")
				{
					switch (form)
					{
						case "備貨日期_S":
							sqlStr += " AND CONVERT(DATE,[備貨日期]) >= @備貨日期_S";
							this.SetParameters(form, context.Request[form]);
							break;
						case "備貨日期_E":
							sqlStr += " AND CONVERT(DATE,[備貨日期]) <= @備貨日期_E";
							this.SetParameters(form, context.Request[form]);
							break;
						case "廠商簡稱":
							sqlStr += " AND ISNULL(P.[廠商簡稱],'') LIKE '%' + @廠商簡稱 + '%'";
							this.SetParameters(form, context.Request[form]);
							break;
						case "客戶簡稱":
							sqlStr += " AND ISNULL(P.[客戶簡稱],'') LIKE '%' + @客戶簡稱 + '%'";
							this.SetParameters(form, context.Request[form]);
							break;
						default:
							sqlStr += " AND ISNULL(P.[" + form + "],'') LIKE @" + form + " + '%'";
							this.SetParameters(form, context.Request[form]);
							break;
					}
				}
			}
			dt = GetDataTableWithLog(sqlStr);
			return dt;
		}

		/// <summary>
		/// 寫入準備出貨 TABLE 
		/// </summary>
		/// <param name="context"></param>
		/// <returns></returns>
		public int InsertPaku2()
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
				res = ExecuteWithLog(sqlStr);
			}
			this.TranCommit();

			return res;
		}

		/// <summary>
		/// 刪除集貨 TABLE 
		/// </summary>
		/// <param name="context"></param>
		/// <returns></returns>
		public int DeletePaku2()
		{
			int res = 0;
			string sqlStr = @"  DECLARE @ENTER_CNT DECIMAL(18,2)
								SELECT  @ENTER_CNT = ISNULL(備貨數量,0) - SUM(ISNULL(出貨數量,0))
								FROM paku2 P2 
								LEFT JOIN paku P ON P2.序號 = P.PAKU2_SEQ
								WHERE ISNULL(P.已刪除,0)=0
								AND P2.序號 = @SEQ
								GROUP BY P2.序號, P2.備貨數量 
								
								SET @ENTER_CNT = ISNULL(@ENTER_CNT,0)								

								 UPDATE paku2
								 SET 已刪除 = 1
									,更新日期 = GETDATE()
									,更新人員 = @UPD_USER
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
											,@SEQ SOURCE_SEQ
											,'paku2' SOURCE_TABLE
											,'樣品準備刪除(入庫)' [訂單號碼]
											,'' [單據編號]
											,GETDATE() [異動日期]
											,'6' [帳項]
											,NULL [帳項原因]
											,S.[廠商編號]
											,S.[廠商簡稱]
											,S.[頤坊型號]
											,S.[暫時型號]
											,S.[單位]
											,'內湖' [庫區]
											,@ENTER_CNT [入庫數]
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
									FROM paku2 A
									JOIN SUPLU S ON A.SUPLU_SEQ = S.序號
									JOIN stkioh ST ON A.序號 = ST.SOURCE_SEQ AND ST.SOURCE_TABLE = 'paku2'
                                    WHERE A.序號 = @SEQ
									
									--JOIN stkioh FOR 刪除舊資料時，庫存不動
                                    UPDATE SUPLU
                                    SET 內湖庫存數 = ISNULL(內湖庫存數,0) + @ENTER_CNT
									   ,更新人員 = @UPD_USER
									   ,更新日期 = GETDATE()
									FROM SUPLU S
									JOIN paku2 P ON S.序號 = P.SUPLU_SEQ
									JOIN stkioh ST ON P.序號 = ST.SOURCE_SEQ AND ST.SOURCE_TABLE = 'paku2'
                                    WHERE P.序號 = @SEQ
							";

			string[] seqArray = context.Request["SEQ[]"].Split(',');

			this.SetTran();
			for (int cnt = 0; cnt < seqArray.Length; cnt++)
			{
				this.ClearParameter();
				this.SetParameters("SEQ", seqArray[cnt]);
				this.SetParameters("UPD_USER", "IVAN10");
				ExecuteWithLog(sqlStr);
			}
			this.TranCommit();

			return res;
		}
	}
}
