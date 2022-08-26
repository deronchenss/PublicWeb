using System.Collections.Generic;
using System.Data;

namespace Ivan_Dal
{
    public class Dal_Paku : DataOperator
	{
		/// <summary>
		/// 樣品備貨維護 查詢 Return DataTable
		/// </summary>
		/// <returns></returns>
		public DataTable SearchTable(Dictionary<string, string> dic)
		{
			DataTable dt = new DataTable();
			string sqlStr = "";
			sqlStr = @" 
						WITH TOT (INVOICE ,箱號, 淨重,毛重)
						AS
						(
							SELECT   INVOICE INVOICE
								    ,箱號
								    ,MAX(ISNULL(淨重,0)) 淨重
									,MAX(ISNULL(毛重,0)) 毛重
							FROM [dbo].[paku] P
							WHERE IsNull(P.已刪除,0) = 0 
							GROUP BY INVOICE,箱號
						)

						SELECT TOP 500 P.[序號]
							  ,P.[INVOICE]
							  ,P.[SUPLU_SEQ]
							  ,P.[PAKU2_SEQ]
							  ,P.[客戶編號]
							  ,P.[客戶簡稱]
							  ,P.[樣品號碼]
							  ,P.[頤坊型號]
							  ,P.[暫時型號]
							  ,P.[產品說明]
							  ,P.[單位]
							  ,IIF(P.[美元單價] = 0, NULL,P.[美元單價]) 美元單價
							  ,IIF(P.[台幣單價] = 0, NULL,P.[台幣單價]) 台幣單價
							  ,P.[外幣幣別]
							  ,IIF(P.[外幣單價] = 0, NULL,P.[外幣單價]) 外幣單價
							  ,P.[出貨數量]
							  ,P.[廠商編號]
							  ,P.[廠商簡稱]
							  ,IIF(P.[FREE] = 1, '是', '') FREE
							  ,IIF(P.[價格待通知] = 1, '是', '') [價格待通知]
							  ,P.[ATTN]
							  ,P.[箱號]
							  ,TOT.[淨重]
							  ,TOT.[毛重]
							  ,P.[變更日期]
							  ,P.[已刪除]
							  ,P2.備貨數量 備貨數量 --舊資料不管
							  ,P2.已刪除 P2_已刪除 --舊資料不管
							  ,P.[建立人員]
							  ,CONVERT(VARCHAR,P.[建立日期],23) 建立日期
							  ,P.[更新人員]
							  ,CONVERT(VARCHAR,P.[更新日期],23) 更新日期 
						      ,CAST(ISNULL((SELECT TOP 1 1 FROM [192.168.1.135].pic.dbo.xpic X WHERE X.[SUPLU_SEQ] = P.[SUPLU_SEQ]),0) AS BIT) [Has_IMG]
						  FROM [dbo].[paku] P
						  JOIN TOT ON P.INVOICE = TOT.INVOICE AND P.箱號 = TOT.箱號
						  LEFT JOIN paku2 P2 ON P.paku2_SEQ = P2.序號
						  WHERE ISNULL(P.已刪除,0) = 0 ";

			//共用function 需調整日期名稱,form !=, 簡稱類, 串TABLE 簡稱 
			foreach (string form in dic.Keys)
			{
				if (!string.IsNullOrEmpty(dic[form]) && form != "Account")
				{
					switch (form)
					{
						case "更新日期_S":
							sqlStr += " AND CONVERT(DATE,P.[更新日期]) >= @更新日期_S";
							this.SetParameters(form, dic[form]);
							break;
						case "更新日期_E":
							sqlStr += " AND CONVERT(DATE,P.[更新日期]) <= @更新日期_E";
							this.SetParameters(form, dic[form]);
							break;
						case "廠商簡稱":
							sqlStr += " AND ISNULL(P.[廠商簡稱],'') LIKE '%' + @廠商簡稱 + '%'";
							this.SetParameters(form, dic[form]);
							break;
						case "客戶簡稱":
							sqlStr += " AND ISNULL(P.[客戶簡稱],'') LIKE '%' + @客戶簡稱 + '%'";
							this.SetParameters(form, dic[form]);
							break;
						default:
							sqlStr += " AND ISNULL(P.[" + form + "],'') LIKE @" + form + " + '%'";
							this.SetParameters(form, dic[form]);
							break;
					}
				}
			}
			dt = GetDataTable(sqlStr);
			return dt;
		}

		/// <summary>
		/// 寫入備貨 TABLE 
		/// </summary>
		/// <param name="context"></param>
		/// <returns></returns>
		public int InsertPaku(Dictionary<string, string> dic)
		{
			int res = 0;
			string sqlStr = @"   INSERT INTO [dbo].[paku]
										   ([序號]
										   ,[SUPLU_SEQ]
										   ,[PAKU2_SEQ]
										   ,[INVOICE]
										   ,[客戶編號]
										   ,[客戶簡稱]
										   ,[樣品號碼]
										   ,[頤坊型號]
										   ,[暫時型號]
										   ,[產品說明]
										   ,[單位]
										   ,[美元單價]
										   ,[台幣單價]
										   ,[外幣幣別]
										   ,[外幣單價]
										   ,[出貨數量]
										   ,[廠商編號]
										   ,[廠商簡稱]
										   ,[FREE]
										   ,[價格待通知]
										   ,[ATTN]
										   ,[箱號]
										   ,[淨重]
										   ,[毛重]
										   ,[變更日期]
										   ,[已刪除]
										   ,[建立人員]
										   ,[建立日期]
										   ,[更新人員]
										   ,[更新日期])
									SELECT (SELECT IsNull(Max(序號),0)+1 FROM paku)[序號]
										   ,P.[SUPLU_SEQ]
										   ,P.序號 [PAKU2_SEQ]
										   ,@INVOICE [INVOICE]
										   ,P.[客戶編號]
										   ,P.[客戶簡稱]
										   ,@SAMPLE_NO [樣品號碼]
										   ,P.[頤坊型號]
										   ,P.[暫時型號]
										   ,P.[產品說明]
										   ,P.[單位]
										   ,B.[美元單價]
										   ,B.[台幣單價]
										   ,B.[外幣幣別]
										   ,B.[外幣單價]
										   ,@PACK_CNT [出貨數量]
										   ,P.[廠商編號]
										   ,P.[廠商簡稱]
										   ,@FREE [FREE]
										   ,0 [價格待通知]
										   ,@ATTN [ATTN]
										   ,@PACK_NO [箱號]
										   ,0 [淨重]
										   ,0 [毛重]
										   ,GETDATE() [變更日期]
										   ,0 [已刪除]
										   ,@UPD_USER [建立人員]
										   ,GETDATE() [建立日期]
										   ,@UPD_USER [更新人員]
										   ,GETDATE() [更新日期]
									FROM   paku2 P
									LEFT JOIN byrlu B ON P.SUPLU_SEQ = B.SUPLU_SEQ AND P.客戶編號 = B.客戶編號
									WHERE P.序號 = @SEQ 

									--更新PAKU2 結案狀態
									UPDATE paku2
									SET 已結案 = CASE WHEN 備貨數量 = (SELECT SUM(出貨數量) FROM paku WHERE PAKU2_SEQ = @SEQ AND ISNULL(已刪除,0) = 0) THEN 1
													  ELSE 0 
													  END
									WHERE 序號 = @SEQ

									";

			string[] seqArray = dic["SEQ[]"].Split(',');
			string[] freeArr = dic["FREE[]"].Split(',');
			string[] packCntArr = dic["PACK_CNT[]"].Split(',');

			this.SetTran();
			for (int cnt = 0; cnt < seqArray.Length; cnt++)
			{
				this.ClearParameter();
				this.SetParameters("SEQ", seqArray[cnt]);
				this.SetParameters("PACK_CNT", packCntArr[cnt]);
				this.SetParameters("FREE", freeArr[cnt]);
				this.SetParameters("INVOICE", dic["INVOICE"]);
				this.SetParameters("ATTN", dic["ATTN"]);
				this.SetParameters("PACK_NO", dic["PACK_NO"]);
				this.SetParameters("SAMPLE_NO", dic["SAMPLE_NO"]);
				this.SetParameters("UPD_USER", dic["Account"]);
				Execute(sqlStr);
			}

			//後續還有語法，額外紀錄LOG
			//Log.InsertLog(context, context.Session["Account"], sqlStr, parmStr);

			//最後更新重量 只更新第一筆
			sqlStr = @" UPDATE paku
						SET 淨重 = 0
						   ,毛重 = 0
						WHERE INVOICE = @INVOICE
						AND 箱號 = @PACK_NO 
						
						UPDATE paku 
						SET 淨重 = @NET_WEIGHT
						   ,毛重 = @WEIGHT
						WHERE INVOICE = @INVOICE
						AND 箱號 = @PACK_NO
						AND 序號 = (SELECT TOP 1 序號 
									FROM paku 
									WHERE INVOICE = @INVOICE
									AND 箱號 = @PACK_NO
									Order By CASE When Substring(paku.箱號,1,1)>='A' Then substring(paku.箱號,1,1)+Right(Space(3)+Substring(Rtrim(paku.箱號),2,3),3) Else Right(Space(4)+Rtrim(paku.箱號),4) End,paku.淨重 DESC,paku.頤坊型號) ";
			this.SetParameters("NET_WEIGHT", dic["NET_WEIGHT"]);
			this.SetParameters("WEIGHT", dic["WEIGHT"]);
			Execute(sqlStr);

			//更新發票
			sqlStr = @" UPDATE invu
						SET 發票匯率 = (SELECT 美元匯率 FROM rate WHERE 日期 = 出貨日期)
						WHERE INVOICE = @INVOICE
				     ";

			Execute(sqlStr);

			this.TranCommit();

			return res;
		}

		/// <summary>
		/// UPDATE Paku 
		/// </summary>
		/// <param name="context"></param>
		/// <returns></returns>
		public int UpdatePaku(Dictionary<string, string> dic)
		{
			string sqlStr = @"      UPDATE [dbo].[paku]
                                       SET 更新日期 = GETDATE()
										  ,更新人員 = @UPD_USER
                                    ";

			foreach (string form in dic.Keys)
			{
				this.SetParameters(form, dic[form]); //因後續還有UPDATE重量語法，故所有變數皆須設定
				if (!string.IsNullOrEmpty(dic[form]) && form != "Account" && form != "SEQ")
				{
					switch (form)
					{
						default:
							sqlStr += " ," + form + " = @" + form;
							break;
					}
				}
			}

			sqlStr += @" WHERE 序號 = @SEQ

						 --更新PAKU2 結案狀態
						DECLARE @PAKU2_SEQ VARCHAR(20)
						SELECT @PAKU2_SEQ = PAKU2_SEQ FROM paku WHERE 序號 = @SEQ
						UPDATE paku2
						SET 已結案 = CASE WHEN 備貨數量 = (SELECT SUM(出貨數量) FROM paku WHERE PAKU2_SEQ = @PAKU2_SEQ AND ISNULL(已刪除,0) = 0) THEN 1
											ELSE 0
											END
						WHERE 序號 = @PAKU2_SEQ";
			
			this.SetTran();
			this.SetParameters("UPD_USER", dic["Account"]);
			int res = Execute(sqlStr);

			//最後更新重量 只更新第一筆
			sqlStr = @" UPDATE paku
						SET 淨重 = 0
						   ,毛重 = 0
						WHERE INVOICE = @INVOICE
						AND 箱號 = @箱號 
						
						UPDATE paku 
						SET 淨重 = @淨重
						   ,毛重 = @毛重
						WHERE INVOICE = @INVOICE
						AND 箱號 = @箱號
						AND 序號 = (SELECT TOP 1 序號 
									FROM paku 
									WHERE INVOICE = @INVOICE
									AND 箱號 = @箱號
									Order By CASE When Substring(paku.箱號,1,1)>='A' Then substring(paku.箱號,1,1)+Right(Space(3)+Substring(Rtrim(paku.箱號),2,3),3) Else Right(Space(4)+Rtrim(paku.箱號),4) End,paku.淨重 DESC,paku.頤坊型號) ";
			Execute(sqlStr);
			this.TranCommit();

			return res;
		}

		/// <summary>
		/// 刪除備貨 TABLE 
		/// </summary>
		/// <param name="context"></param>
		/// <returns></returns>
		public int DeletePaku(Dictionary<string, string> dic)
		{
			int res = 0;
			string sqlStr = @"   UPDATE paku
								 SET 已刪除 = 1
									,更新日期 = GETDATE()
									,更新人員 = @UPD_USER
								 WHERE 序號 = @SEQ 
								
								 --更新PAKU2 結案狀態
								DECLARE @PAKU2_SEQ VARCHAR(20)
								SELECT @PAKU2_SEQ = PAKU2_SEQ FROM paku WHERE 序號 = @SEQ 
								UPDATE paku2
								SET 已結案 = CASE WHEN 備貨數量 = (SELECT SUM(出貨數量) FROM paku WHERE PAKU2_SEQ = @PAKU2_SEQ AND ISNULL(已刪除,0) = 0) THEN 1
													ELSE 0 
													END
								WHERE 序號 = @PAKU2_SEQ

							";

			this.SetParameters("SEQ", dic["SEQ"]);
			this.SetParameters("UPD_USER", dic["Account"]);

			this.SetTran();
			Execute(sqlStr);
			this.TranCommit();

			return res;
		}
	}
}
