using System;

namespace Ivan_Models
{
	public class Stkio_Sale
	{
		public int 序號 { get; set; }

		public int? STKIO_SEQ { get; set; }

		public string PM_NO { get; set; }
		public string 訂單號碼 { get; set; }

		public DateTime? 出貨日期 { get; set; }
		public string 廠商編號 { get; set; }
		public string 廠商簡稱 { get; set; }
		public string 頤坊型號 { get; set; }

		public string 銷售型號 { get; set; }

		public string 單位 { get; set; }

		public string 出區 { get; set; }

		public string 入區 { get; set; }

		public decimal? 出貨數 { get; set; }

		public string 庫位 { get; set; }

		public decimal? 核銷數 { get; set; }

		public string 備註 { get; set; }

		public string 箱號 { get; set; }

		//保留舊資料 後續不使用
		public string 箱號E { get; set; } 

		public string 產品一階 { get; set; }

		public string 皮革型號 { get; set; }

		public bool? 不入庫 { get; set; }

		public bool? 已結案 { get; set; }

		public bool? 已刪除 { get; set; }

		public DateTime? 變更日期 { get; set; }

		public string 建立人員 { get; set; }

		public DateTime? 建立日期 { get; set; }

		public string 更新人員 { get; set; }

		public DateTime? 更新日期 { get; set; }

	}

	/// <summary>
	/// 多筆寫入 Stkio_Sale From Stkio 需要的參數
	/// </summary>
	public class Stkio_SaleFromStkio
	{
		//序號
		public string SEQ { get; set; }
		//出庫數
		public string STOCK_O_CNT { get; set; }
		//取快取 Y
		public string QUICK_TAKE { get; set; }
		//PM_NO
		public string PM_NO { get; set; }
		//庫存出區
		public string STOCK_POS_O { get; set; }
		//庫存入區
		public string STOCK_POS_I { get; set; }
		//箱號
		public string PACK_NO { get; set; }
		//REMARK
		public string REMARK { get; set; }
	}
}

