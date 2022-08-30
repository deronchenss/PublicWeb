using System;

namespace Ivan.Models
{
	public class Stkio
	{
		public int 序號 { get; set; }

		public int? SOURCE_SEQ { get; set; }

		public string SOURCE_TABLE { get; set; }

		public int? SUPLU_SEQ { get; set; }

		public string 訂單號碼 { get; set; }

		public string 單據編號 { get; set; }

		public DateTime? 異動日期 { get; set; }

		public string 帳項 { get; set; }

		public string 帳項原因 { get; set; }

		public string 廠商編號 { get; set; }

		public string 廠商簡稱 { get; set; }

		public string 頤坊型號 { get; set; }

		public string 暫時型號 { get; set; }

		public string 單位 { get; set; }

		public string 庫區 { get; set; }

		public decimal? 入庫數 { get; set; }

		public decimal? 出庫數 { get; set; }

		public string 庫位 { get; set; }

		public decimal? 核銷數 { get; set; }

		public decimal? 異動前庫存 { get; set; }

		public string 客戶編號 { get; set; }

		public string 客戶簡稱 { get; set; }

		public string 完成品型號 { get; set; }

		public string 備註 { get; set; }

		public bool? 內銷入庫 { get; set; }

		public bool? 已刪除 { get; set; }

		public DateTime? 變更日期 { get; set; }

		public string 建立人員 { get; set; }

		public DateTime? 建立日期 { get; set; }

		public string 更新人員 { get; set; }

		public DateTime? 更新日期 { get; set; }

	}

	/// <summary>
	/// 多筆寫入 Stkio From Suplu 需要的參數
	/// </summary>
	public class StkioFromSuplu
	{
		//序號
		public string SEQ { get; set; }
		//訂單號碼
		public string ORDER_NO { get; set; }
		//單據編號
		public string DOCUMENT_NO { get; set; }
		//帳項
		public string BILL_TYPE { get; set; }
		//庫區
		public string STOCK_POS { get; set; }
		//入庫數
		public string STOCK_I_CNT { get; set; }
		//出庫數
		public string STOCK_O_CNT { get; set; }
		//庫位
		public string STOCK_LOC { get; set; }
		//客戶編號
		public string CUST_NO { get; set; }
		//客戶簡稱
		public string CUST_S_NAME { get; set; }
		//REMARK
		public string REMARK { get; set; }
	}

	/// <summary>
	/// 寫入 Stkio 從 stkio sale model
	/// </summary>
	public class InsertStkioFromSaleModel
	{
		public int 序號 { get; set; }
		public string SUPLU_SEQ { get; set; }
		public string 更新人員 { get; set; }
	}
}

