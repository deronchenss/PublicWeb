namespace Ivan.Models
{
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
		//箱號S
		public string PACK_NO_S { get; set; }
		//箱號E
		public string PACK_NO_E { get; set; }
		//內袋
		public string IN_BAG { get; set; }
		//REMARK
		public string REMARK { get; set; }
	}
}

