using System.Collections.Generic;
using System.Data;
using System.Web;

namespace Ivan_Dal
{
    public class Dal_Invu : Dal_Base
	{
		/// <summary>
		/// 樣品發票 維護 Return DataTable
		/// </summary>
		/// <param name="context"></param>
		/// <returns></returns>
		public IDalBase SearchTable(Dictionary<string, string> dic)
		{
			string sqlStr = "";
			sqlStr = @" SELECT TOP 500 [序號]
						  ,[INVOICE]
						  ,CONVERT(VARCHAR,[出貨日期],23) 出貨日期
						  ,[客戶編號]
						  ,[客戶簡稱]
						  ,[銀行編號]
						  ,[銀行簡稱]
						  ,[提單號碼]
						  ,ISNULL(應稅,0) 應稅
						  ,[發票匯率]
						  ,ISNULL(應收樣品費,0) 應收樣品費
						  ,ISNULL(應收樣品NT,0) 應收樣品NT
						  ,ISNULL(應收運費,0) 應收運費
						  ,ISNULL(應收運費NT,0) 應收運費NT
						  ,ISNULL(併大貨收款,0) 併大貨收款
						  ,ISNULL(已收金額,0) 已收金額
						  ,ISNULL(已收金額NT,0) 已收金額NT
						  ,CONVERT(VARCHAR,[已收日期],23) 已收日期
						  ,ISNULL(應收樣品費,0) + ISNULL(應收樣品NT,0) + ISNULL(應收運費,0) + ISNULL(應收運費NT,0) - ISNULL(已收金額,0) - ISNULL(已收金額NT,0) 未收金額
						  ,[備註業務]
						  ,[備註會計]
						  ,[備註_ivan]
						  ,[運輸編號]
						  ,[運輸簡稱]
						  ,[運送方式]
						  ,[匯入銀行]
						  ,CONVERT(VARCHAR,[變更日期],23) 變更日期 
						  ,[更新人員]
						  ,CONVERT(VARCHAR,[更新日期],23) 更新日期 
					  FROM [dbo].[invu]
					  WHERE 1=1 ";

			//共用function 需調整日期名稱,form !=, 簡稱類, 串TABLE 簡稱 
			foreach (string form in dic.Keys)
			{
				if (!string.IsNullOrEmpty(dic[form]) && form != "Account")
				{
					switch (form)
					{
						case "出貨日期_S":
							sqlStr += " AND CONVERT(DATE,[出貨日期]) >= @出貨日期_S";
							this.SetParameters(form, dic[form]);
							break;
						case "出貨日期_E":
							sqlStr += " AND CONVERT(DATE,[出貨日期]) <= @出貨日期_E";
							this.SetParameters(form, dic[form]);
							break;
						case "變更日期_S":
							sqlStr += " AND CONVERT(DATE,[變更日期]) >= @變更日期_S";
							this.SetParameters(form, dic[form]);
							break;
						case "變更日期_E":
							sqlStr += " AND CONVERT(DATE,[變更日期]) <= @變更日期_E";
							this.SetParameters(form, dic[form]);
							break;
						case "客戶簡稱":
							sqlStr += " AND ISNULL([客戶簡稱],'') LIKE '%' + @客戶簡稱 + '%'";
							this.SetParameters(form, dic[form]);
							break;
						default:
							sqlStr += " AND ISNULL([" + form + "],'') LIKE @" + form + " + '%'";
							this.SetParameters(form, dic[form]);
							break;
					}
				}
			}
			this.SetSqlText(sqlStr);
			return this;
		}

		/// <summary>
		/// 檢查 Sample IV 並 傳回客戶編號 簡稱
		/// </summary>
		/// <param name="context"></param>
		/// <returns></returns>
		public IDalBase SearchIV(Dictionary<string, string> dic)
		{
			string sqlStr = "";
			sqlStr = @" SELECT 客戶編號, 客戶簡稱
						FROM invu 
						WHERE INVOICE = @INVOICE ";

			this.SetParameters("INVOICE", dic["INVOICE"]);
			this.SetSqlText(sqlStr);
			return this;
		}

		/// <summary>
		/// 寫入INVU 回傳 發票號碼
		/// </summary>
		/// <param name="context"></param>
		/// <returns></returns>
		public IDalBase InsertInvu(Dictionary<string, string> dic)
		{
			string sqlStr = @"      DECLARE @INVOICE_NO nvarchar(20); 
									SELECT @INVOICE_NO = 字頭 + CONVERT(VARCHAR,年度) + RIGHT(REPLICATE('0', len(號碼長度)) + CONVERT(VARCHAR,號碼 + 1),len(號碼長度))  
								    FROM nofile
								    WHERE 單據 = '樣品INVOICE'
								    
								    UPDATE nofile
								    SET 號碼 = 號碼+1
									   ,更新人員 = @UPD_USER
									   ,更新日期 = GETDATE() 
								    WHERE 單據 = '樣品INVOICE'

									INSERT INTO [dbo].[invu]
                                                ([序號]
                                                ,[INVOICE]
                                                ,[客戶編號]
												,[客戶簡稱]
												,[出貨日期]
                                                ,[變更日期]
												,[建立人員]
                                                ,[建立日期]
                                                ,[更新人員]
                                                ,[更新日期])
                                    VALUES		((SELECT IsNull(Max(序號),0)+1 FROM invu) 
												,@INVOICE_NO 
												,@CUST_NO 
												,@CUST_S_NAME 
												,GETDATE()
												,GETDATE()
                                                ,@UPD_USER 
                                                ,GETDATE()
                                                ,@UPD_USER 
                                                ,GETDATE())

								   SELECT @INVOICE_NO INVOICE
                                    ";

			this.SetParameters("CUST_NO", dic["CUST_NO"]);
			this.SetParameters("CUST_S_NAME", dic["CUST_S_NAME"]);
			this.SetParameters("UPD_USER", dic["Account"]);
			this.SetSqlText(sqlStr);
			return this;
		}

		/// <summary>
		/// UPDATE INVU 
		/// </summary>
		/// <param name="context"></param>
		/// <returns></returns>
		public IDalBase UpdateInvu(Dictionary<string, string> dic)
		{
			string sqlStr = @"      UPDATE [dbo].[invu]
                                       SET 更新日期 = GETDATE()
										  ,更新人員 = @UPD_USER
                                    ";

			foreach (string form in dic.Keys)
			{
				if (!string.IsNullOrEmpty(dic[form]) && form != "Account" && form != "SEQ")
				{
					switch (form)
					{
						default:
							sqlStr += " ," + form + " = @" + form;
							this.SetParameters(form, dic[form]);
							break;
					}
				}
			}

			sqlStr += " WHERE 序號 = @SEQ ";
			this.SetParameters("SEQ", dic["SEQ"]);
			this.SetParameters("UPD_USER", dic["Account"]);
			this.SetSqlText(sqlStr);
			return this;
		}

		/// <summary>
		/// 樣品發票 Invoice 報表
		/// </summary>
		/// <param name="context"></param>
		/// <returns></returns>
		public IDalBase SampleIVReport(Dictionary<string, string> dic)
		{
			string sqlStr = "";
			sqlStr = @" WITH TOT (INVOICE ,樣品號碼,頤坊型號,產品說明,單位,出貨數量,FREE,價格待通知, ATTN,幣別,計算單價)
						AS
						(
							SELECT   MAX(I.INVOICE) INVOICE
										,P.樣品號碼
										,P.頤坊型號
										,P.產品說明
										,P.單位
										,SUM(P.出貨數量) AS 出貨數量
										,ISNULL(P.FREE,0) FREE
										,ISNULL(P.價格待通知,0) 價格待通知
										,ISNULL(P.ATTN,0) ATTN
										,CASE WHEN MAX(P.台幣單價) > 0 THEN 'PRICE/NTD' ELSE 'PRICE/USD' END 幣別
										,IIF(ISNULL(MAX(台幣單價),0) > 0, MAX(ISNULL(台幣單價,0)), MAX(ISNULL(美元單價,0))) 計算單價
								FROM [dbo].[INVU] I
								LEFT JOIN paku P ON I.INVOICE = P.INVOICE
								WHERE IsNull(P.已刪除,0) = 0 
								AND IsNull(P.出貨數量,0) <> 0
								AND I.INVOICE = @INVOICE_NO
								GROUP BY P.樣品號碼,P.頤坊型號,P.產品說明,P.單位,ISNULL(P.FREE,0),ISNULL(P.價格待通知,0),ISNULL(P.ATTN,0) 
						)

							SELECT  I.INVOICE INVOICE
								,I.出貨日期 AS 出貨日期
								,TOT.樣品號碼
								,TOT.頤坊型號
								,TOT.產品說明
								,TOT.單位
								,TOT.出貨數量 AS 出貨數量
								,TOT.FREE
								,TOT.價格待通知
								,TOT.ATTN
								,byr.客戶名稱
								,CASE WHEN ISNULL(byr.連絡人樣品,'') = '' THEN byr.連絡人大貨 ELSE byr.連絡人樣品 END 連絡人樣品
								,byr.公司地址
								,B.帳號內容
								,I.應收運費+I.應收運費NT AS 應收運費
								,TOT.幣別 幣別
								,CASE WHEN TOT.價格待通知 = 1 THEN 0 ELSE ROUND(計算單價 * TOT.出貨數量,2) END 金額
								,CASE WHEN TOT.價格待通知 = 1 THEN 0 ELSE ROUND(計算單價,2) END 列印單價
								,CASE WHEN TOT.價格待通知 = 1 THEN 0 ELSE ROUND(計算單價 * TOT.出貨數量,2) END 列印金額
			                    ,CASE WHEN TOT.價格待通知 = 1 THEN 0 ELSE (SELECT SUM(ROUND(計算單價 * TOT.出貨數量,2)) FROM TOT) + I.應收運費+I.應收運費NT END 總額
			                    ,CASE WHEN TOT.幣別 = 'PRICE/NTD' THEN 'SAY TOTAL NT DOLLARS ' + dbo.FN_GET_NUM2WORD((SELECT SUM(ROUND(計算單價 * TOT.出貨數量,2)) FROM TOT) + I.應收運費+I.應收運費NT) 
			                          ELSE 'SAY TOTAL US DOLLARS ' + dbo.FN_GET_NUM2WORD((SELECT SUM(ROUND(計算單價 * TOT.出貨數量,2)) FROM TOT) + I.應收運費+I.應收運費NT) END + ' ONLY.' 列印大寫
								,'W/B : ' + I.提單號碼 列印提單號碼
								,I.備註業務
								,'PLEASE FIND ENCLOSED:' + CHAR(13) + CHAR(13) + CASE WHEN ISNULL(I.銀行簡稱,'') != '' THEN 'PLEASE WIRE PAYMENT TO OUR BANK ACCOUNT.' ELSE '' END 列印備註 
								,T.英文名稱 運輸英文名稱
						FROM invu I
						INNER JOIN TOT ON I.INVOICE = TOT.INVOICE
						INNER JOIN byr ON I.客戶編號 = byr.客戶編號
						LEFT JOIN BANK B ON I.銀行簡稱=B.銀行簡稱
						LEFT JOIN TRF T ON I.運輸編號=T.運輸編號
						ORDER BY TOT.頤坊型號 ";

			this.SetParameters("INVOICE_NO", dic["INVOICE_NO"]);
			this.SetSqlText(sqlStr);
			return this;
		}

		/// <summary>
		/// 樣品發票 PACKING 報表
		/// </summary>
		/// <param name="context"></param>
		/// <returns></returns>
		public IDalBase SamplePackingReport(Dictionary<string, string> dic)
		{
			string sqlStr = "";
			sqlStr = @" WITH TOT (INVOICE ,樣品號碼,頤坊型號,產品說明,單位,箱號,淨重,毛重,出貨數量,FREE,價格待通知, ATTN,幣別,計算單價)
						AS
						(
							SELECT   MAX(I.INVOICE) INVOICE
										,P.樣品號碼
										,P.頤坊型號
										,P.產品說明
										,P.單位
										,P.箱號
										,P.淨重
										,P.毛重
										,SUM(P.出貨數量) AS 出貨數量
										,ISNULL(P.FREE,0) FREE
										,ISNULL(P.價格待通知,0) 價格待通知
										,ISNULL(P.ATTN,0) ATTN
										,CASE WHEN MAX(P.台幣單價) > 0 THEN 'PRICE/NTD' ELSE 'PRICE/USD' END 幣別
										,IIF(ISNULL(MAX(台幣單價),0) > 0, MAX(ISNULL(台幣單價,0)), MAX(ISNULL(美元單價,0))) 計算單價
								FROM [dbo].[INVU] I
								LEFT JOIN paku P ON I.INVOICE = P.INVOICE
								WHERE IsNull(P.已刪除,0) = 0 
								AND IsNull(P.出貨數量,0) <> 0
								AND I.INVOICE = @INVOICE_NO
								GROUP BY P.樣品號碼,P.頤坊型號,P.產品說明,P.單位,ISNULL(P.FREE,0),ISNULL(P.價格待通知,0),ISNULL(P.ATTN,0) ,P.箱號,P.淨重,P.毛重
						)

							SELECT  I.INVOICE INVOICE
								,I.出貨日期 AS 出貨日期
								,TOT.樣品號碼
								,TOT.頤坊型號
								,TOT.產品說明
								,TOT.單位
								,TOT.出貨數量 AS 出貨數量
								,TOT.FREE
								,TOT.價格待通知
								,TOT.ATTN
								,byr.客戶名稱
								,CASE WHEN ISNULL(byr.連絡人樣品,'') = '' THEN byr.連絡人大貨 ELSE byr.連絡人樣品 END 連絡人樣品
								,byr.公司地址
								,TOT.箱號
								,TOT.淨重
								,TOT.毛重
								,B.帳號內容
								,I.應收運費+I.應收運費NT AS 應收運費
								,TOT.幣別 幣別
								,CASE WHEN TOT.價格待通知 = 1 OR TOT.FREE = 1 THEN 0 ELSE (SELECT SUM(ROUND(計算單價 * TOT.出貨數量,2)) FROM TOT) + I.應收運費+I.應收運費NT END 總額
								,'SAY TOTAL ONE CARTONS.' 列印大寫
								,'W/B : ' + I.提單號碼 列印提單號碼
								,T.英文名稱 運輸英文名稱
								,STUFF((SELECT CHAR(10) + 單位 + RIGHT('           ' + CONVERT(VARCHAR,SUM(出貨數量)),11) FROM TOT
									     GROUP BY 單位
										 FOR XML PATH('')),1,1,'') 列印單位合計
						FROM invu I
						INNER JOIN TOT ON I.INVOICE = TOT.INVOICE
						INNER JOIN byr ON I.客戶編號 = byr.客戶編號
						LEFT JOIN BANK B ON I.銀行簡稱=B.銀行簡稱
						LEFT JOIN TRF T ON I.運輸編號=T.運輸編號
						Order By CASE When Substring(TOT.箱號,1,1)>='A' Then substring(TOT.箱號,1,1)+Right(Space(3)+Substring(Rtrim(TOT.箱號),2,3),3) Else Right(Space(4)+Rtrim(TOT.箱號),4) End,TOT.淨重 DESC,TOT.頤坊型號
							";

			this.SetParameters("INVOICE_NO", dic["INVOICE_NO"]);
			this.SetSqlText(sqlStr);
			return this;
		}
	}
}
