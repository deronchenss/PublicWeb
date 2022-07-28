using Ivan_Dal;
using System.Data;
using System.Web;

namespace Ivan_Service
{
    public class Dal_Paku : LogicBase
	{
		public Dal_Paku(HttpContext _context)
		{
			context = _context;
		}

		/// <summary>
		/// 寫入備貨 TABLE 
		/// </summary>
		/// <param name="context"></param>
		/// <returns></returns>
		public int InsertPaku()
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
										   ,@UPD_USER [更新人員]
										   ,GETDATE() [更新日期]
									FROM   paku2 P
									LEFT JOIN byrlu B ON P.SUPLU_SEQ = B.SUPLU_SEQ AND P.客戶編號 = B.客戶編號
									WHERE P.序號 = @SEQ 
									";

			string[] seqArray = context.Request["SEQ[]"].Split(',');
			string[] freeArr = context.Request["FREE[]"].Split(',');
			string[] packCntArr = context.Request["PACK_CNT[]"].Split(',');

			this.SetTran();
			for (int cnt = 0; cnt < seqArray.Length; cnt++)
			{
				this.ClearParameter();
				this.SetParameters("SEQ", seqArray[cnt]);
				this.SetParameters("PACK_CNT", packCntArr[cnt]);
				this.SetParameters("FREE", freeArr[cnt]);
				this.SetParameters("INVOICE", context.Request["INVOICE"]);
				this.SetParameters("ATTN", context.Request["ATTN"]);
				this.SetParameters("PACK_NO", context.Request["PACK_NO"]);
				this.SetParameters("SAMPLE_NO", context.Request["SAMPLE_NO"]);
				this.SetParameters("UPD_USER", "IVAN10");
				ExecuteWithLog(sqlStr);
			}

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
			this.SetParameters("NET_WEIGHT", context.Request["NET_WEIGHT"]);
			this.SetParameters("WEIGHT", context.Request["WEIGHT"]);
			ExecuteWithLog(sqlStr);

			this.TranCommit();

			return res;
		}
	}
}
