using Ivan_Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Web;

namespace Ivan_Dal
{
    /// <summary>
    /// 核銷數邏輯待stkio 資料都已結案或刪除 剩新資料再調整
    /// </summary>
    public class Dal_Stkio : Dal_Base
    {
        #region 查詢區域
        /// <summary>
        /// 庫存入出查詢 查詢 Return DataTable
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        public IDalBase SearchTable(Dictionary<string, string> dic)
        {
            string sqlStr = "";
            sqlStr = @"SELECT Top 500 CONVERT(VARCHAR,S.更新日期,23) 更新日期
		                              ,S.廠商簡稱
			                          ,S.頤坊型號
			                          ,S.單位
			                          ,CASE WHEN ISNULL(S.入庫數,0) <> 0 AND ISNULL(S.入庫數,0) - ISNULL(S.核銷數,0) <> 0 THEN ISNULL(S.入庫數,0) - ISNULL(S.核銷數,0) ELSE NULL END 入庫數
			                          ,CASE WHEN ISNULL(S.出庫數,0) <> 0 AND ISNULL(S.出庫數,0) - ISNULL(S.核銷數,0) <> 0 THEN ISNULL(S.出庫數,0) - ISNULL(S.核銷數,0) ELSE NULL END 出庫數
                                      ,{0} 扣快取
			                          ,S.訂單號碼
			                          ,S.單據編號
			                          ,IIF(S.異動前庫存 = 0, NULL, S.異動前庫存) 異動前庫存
			                          ,IIF(SU.大貨庫存數 = 0, NULL, SU.大貨庫存數) AS 大貨庫存數
			                          ,IIF((SELECT SUM(ISNULL(出庫數,0) - ISNULL(核銷數,0)) FROM stkio INS WHERE ISNULL(INS.已刪除,0) != 1 AND ISNULL(INS.已結案,0) != 1 AND INS.SUPLU_SEQ = S.SUPLU_SEQ) = 0,NULL, (SELECT SUM(ISNULL(出庫數,0) - ISNULL(核銷數,0)) FROM stkio INS WHERE ISNULL(INS.已刪除,0) != 1 AND ISNULL(INS.已結案,0) != 1 AND INS.SUPLU_SEQ = S.SUPLU_SEQ)) AS 分配庫存數
			                          ,S.備註
			                          ,S.庫位
			                          ,S.庫區
			                          ,S.帳項
			                          ,S.廠商編號
			                          ,S.客戶編號
			                          ,S.客戶簡稱
			                          ,S.內銷入庫
			                          ,S.更新人員
			                          ,S.序號
			                          ,CASE WHEN (SELECT TOP 1 1 FROM [192.168.1.135].pic.dbo.xpic X WHERE X.[SUPLU_SEQ] = S.SUPLU_SEQ) = 1 THEN 'Y' ELSE 'N' END [Has_IMG]
			                          ,S.SUPLU_SEQ
                                      ,CASE WHEN ISNULL(SU.大貨庫存數,0) >= ISNULL(S.出庫數,0) - ISNULL(S.核銷數,0) AND ISNULL(S.出庫數,0) - ISNULL(S.核銷數,0) > 0 AND ISNULL(SU.大貨庫存數,0) >= ISNULL((SELECT SUM(ISNULL(出庫數,0) - ISNULL(核銷數,0)) FROM stkio INS WHERE ISNULL(INS.已刪除,0) != 1 AND ISNULL(INS.已結案,0) != 1 AND INS.SUPLU_SEQ = S.SUPLU_SEQ),0) THEN 'Y' 
                                            ELSE 'N' END 庫存足夠
                                      ,CASE WHEN ISNULL(SU.大貨庫存數,0) >= ISNULL(S.出庫數,0) - ISNULL(S.核銷數,0) AND ISNULL(S.出庫數,0) - ISNULL(S.核銷數,0) > 0 AND ISNULL(SU.大貨庫存數,0) < ISNULL((SELECT SUM(ISNULL(出庫數,0) - ISNULL(核銷數,0)) FROM stkio INS WHERE ISNULL(INS.已刪除,0) != 1 AND ISNULL(INS.已結案,0) != 1 AND INS.SUPLU_SEQ = S.SUPLU_SEQ),0) THEN 'Y' 
                                            ELSE 'N' END 分配數不足
                        FROM {1} S
                        JOIN suplu SU ON S.SUPLU_SEQ = SU.序號
                        WHERE ISNULL(S.已刪除,0) != 1
                        {2}
                        AND (ISNULL(S.入庫數,0) + ISNUll(S.出庫數,0)) != 0
                         ";

            //共用function 需調整日期名稱,form !=, 簡稱類, 串TABLE 簡稱 
            foreach (string form in dic.Keys)
            {
                if (!string.IsNullOrEmpty(dic[form]) && form != "Account")
                {
                    string debug = dic[form];
                    switch (form)
                    {
                        case "產品說明":
                        case "廠商簡稱":
                            sqlStr += " AND ISNULL(S.[" + form + "],'') LIKE '%' + @" + form + " + '%' ";
                            this.SetParameters(form, dic[form]);
                            break;
                        case "更新日期_S":
                            sqlStr += " AND CONVERT(DATE,S.[更新日期]) >= @更新日期_S";
                            this.SetParameters(form, dic[form]);
                            break;
                        case "更新日期_E":
                            sqlStr += " AND CONVERT(DATE,S.[更新日期]) <= @更新日期_E";
                            this.SetParameters(form, dic[form]);
                            break;
                        case "查詢出入庫":
                            if ("入庫".Equals(dic[form]))
                            {
                                sqlStr += " AND ISNULL(S.入庫數,0) <> 0";
                            }
                            else if ("出庫".Equals(dic[form]))
                            {
                                sqlStr += " AND ISNULL(S.出庫數,0) <> 0";
                            }
                            break;
                        case "資料來源":
                            if("0".Equals(dic[form]))
                            {
                                sqlStr = string.Format(sqlStr, "NULL", "stkio", " AND ISNULL(S.已結案,0) != 1 ");

                            }
                            else if ("1".Equals(dic[form]))
                            {
                                sqlStr = string.Format(sqlStr, "IIF(S.實扣快取數=0,NULL,S.實扣快取數)", "stkioh", "");
                            }
                            break;
                        default:
                            sqlStr += " AND ISNULL(S.[" + form + "],'') LIKE @" + form + " + '%'";
                            this.SetParameters(form, dic[form]);
                            break;
                    }
                }
            }

            sqlStr += " ORDER BY S.頤坊型號, S.廠商編號 ";
            this.SetSqlText(sqlStr);
            return this;
        }

        /// <summary>
        /// 庫存入出報表 查詢 Return DataTable
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        public IDalBase SearchTableForRpt(Dictionary<string, string> dic)
        {
            string sqlStr = "";
            sqlStr = @"SELECT Top 500 CONVERT(VARCHAR,S.更新日期,23) 更新日期
		                              ,SU.廠商簡稱
			                          ,SU.頤坊型號
                                      ,SU.銷售型號
			                          ,S.訂單號碼
			                          ,S.單據編號
                                      ,S.庫區
			                          ,S.庫位
			                          ,ISNULL(S.入庫數,0) - ISNULL(S.核銷數,0) 入庫數
			                          ,ISNULL(S.出庫數,0) - ISNULL(S.核銷數,0) 出庫數
			                          ,S.備註
			                          ,S.帳項
			                          ,S.客戶編號
			                          ,S.客戶簡稱
			                          ,S.更新人員
			                          ,S.序號
			                          ,CASE WHEN (SELECT TOP 1 1 FROM [192.168.1.135].pic.dbo.xpic X WHERE X.[SUPLU_SEQ] = S.SUPLU_SEQ) = 1 THEN 'Y' ELSE 'N' END [Has_IMG]
			                          ,S.SUPLU_SEQ
                        FROM {0} S
                        JOIN suplu SU ON S.SUPLU_SEQ = SU.序號
                        WHERE ISNULL(S.已刪除,0) != 1
                        {1}
                         ";

            //共用function 需調整日期名稱,form !=, 簡稱類, 串TABLE 簡稱 
            foreach (string form in dic.Keys)
            {
                if (!string.IsNullOrEmpty(dic[form]) && form != "SORT")
                {
                    switch (form)
                    {
                        case "RPT_TYPE":
                            if(dic[form].Equals("外包裝貼紙"))
                            {
                                sqlStr += " AND ISNUll(S.出庫數,0) != 0";
                            }
                            else
                            {
                                sqlStr += " AND (ISNULL(S.入庫數,0) + ISNUll(S.出庫數,0)) != 0";
                            }
                            break;
                        case "UPD_USER":
                            break;
                        case "備註":
                            sqlStr += " AND ISNULL(S.[" + form + "],'') LIKE '%' + @" + form + " + '%' ";
                            this.SetParameters(form, dic[form]);
                            break;
                        case "更新日期_S":
                            sqlStr += " AND CONVERT(DATE,S.[更新日期]) >= @更新日期_S";
                            this.SetParameters(form, dic[form]);
                            break;
                        case "更新日期_E":
                            sqlStr += " AND CONVERT(DATE,S.[更新日期]) <= @更新日期_E";
                            this.SetParameters(form, dic[form]);
                            break;
                        case "入出庫":
                            if ("入庫".Equals(dic[form]))
                            {
                                sqlStr += " AND ISNULL(S.入庫數,0) - ISNULL(S.核銷數,0) <> 0";
                            }
                            else if ("出庫".Equals(dic[form]))
                            {
                                sqlStr += " AND ISNULL(S.出庫數,0) - ISNULL(S.核銷數,0) <> 0";
                            }
                            break;
                        case "DATA_SOURCE":
                            if ("0".Equals(dic[form]))
                            {
                                sqlStr = string.Format(sqlStr, "stkio", " AND ISNULL(S.已結案,0) != 1 ");

                            }
                            else if ("1".Equals(dic[form]))
                            {
                                sqlStr = string.Format(sqlStr, "stkioh", "");
                            }
                            break;
                        default:
                            sqlStr += " AND ISNULL(S.[" + form + "],'') LIKE @" + form + " + '%'";
                            this.SetParameters(form, dic[form]);
                            break;
                    }
                }
            }

            sqlStr += " ORDER BY S.頤坊型號, S.廠商編號 ";
            this.SetSqlText(sqlStr);
            return this;
        }

        /// <summary>
        /// 庫存入出報表  待入出庫輸入核對表-圖
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        public IDalBase GetImgRptData(Dictionary<string, string> dic)
        {
            string sqlStr = "";
            sqlStr = @"SELECT Top 500 CONVERT(VARCHAR,S.更新日期,23) 異動日期
		                              ,SU.廠商簡稱
			                          ,SU.頤坊型號
                                      ,SU.單位
                                      ,S.庫區
			                          ,ISNULL(S.入庫數,0) - ISNULL(S.核銷數,0) 入庫數
			                          ,ISNULL(S.出庫數,0) - ISNULL(S.核銷數,0) 出庫數
			                          ,S.客戶編號
			                          ,S.客戶簡稱
			                          ,S.備註
                                      ,SU.產品說明
                                      ,CASE WHEN S.庫區 = '大貨' THEN SU.快取庫位
                                            ELSE ''
                                            END 快取庫位
                                      ,CASE WHEN S.庫區 = '大貨' AND ISNULL(S.庫位,'') = '' THEN SU.大貨庫位
                                            WHEN S.庫區 = '大貨' AND ISNULL(S.庫位,'') != '' THEN S.庫位
                                            WHEN S.庫區 = '樣品' THEN SU.樣品庫位
                                            WHEN S.庫區 = '內湖' THEN SU.內湖庫位
                                            WHEN S.庫區 = '留底' THEN SU.留底庫位
                                            WHEN S.庫區 = '展示' THEN SU.展示庫位
                                            WHEN S.庫區 = '台北' THEN SU.台北庫位
                                            WHEN S.庫區 = '台中' THEN SU.台中庫位
                                            WHEN S.庫區 = '高雄' THEN SU.高雄庫位
                                            WHEN S.庫區 = '展場' THEN SU.展場庫位
                                            ELSE '???'
                                            END 列印庫位
                                      ,CASE WHEN S.庫區 = '大貨' THEN ISNULL(SU.大貨庫存數,0)
                                            WHEN S.庫區 = '樣品' THEN ISNULL(SU.樣品庫存數,0)
                                            WHEN S.庫區 = '內湖' THEN ISNULL(SU.內湖庫存數,0)
                                            WHEN S.庫區 = '留底' THEN ISNULL(SU.留底庫存數,0)
                                            WHEN S.庫區 = '展示' THEN ISNULL(SU.展示庫存數,0)
                                            WHEN S.庫區 = '台北' THEN ISNULL(SU.台北庫存數,0)
                                            WHEN S.庫區 = '台中' THEN ISNULL(SU.台中庫存數,0)
                                            WHEN S.庫區 = '高雄' THEN ISNULL(SU.高雄庫存數,0)
                                            WHEN S.庫區 = '展場' THEN ISNULL(SU.展場庫存數,0)
                                            ELSE 0
                                            END 目前庫存
                                      ,@UPD_USER 使用者代碼
                                      ,SU.備註給倉庫 
                                      ,'建檔日期 : ' + @更新日期_S + ' - ' +  @更新日期_E 列印條件
                                      ,(SELECT TOP 1 客戶型號 FROM BYRLU WHERE SU.序號 = BYRLU.SUPLU_SEQ) 客戶型號
                                      ,CASE WHEN S.客戶編號 = '1505A' THEN (SELECT TOP 1 寄送袋子 FROM BARCODE WHERE 頤坊型號 = SU.頤坊型號 AND 客戶編號 = '1505A')
                                            ELSE SU.寄送袋子 END 寄送袋子
                                      ,CASE WHEN S.客戶編號 = '1505A' THEN (SELECT TOP 1 寄送吊卡 FROM BARCODE WHERE 頤坊型號 = SU.頤坊型號 AND 客戶編號 = '1505A')
                                            ELSE SU.寄送吊卡 END 寄送吊卡
			                          ,(SELECT TOP 1 國名 FROM SUP WHERE 廠商編號 = SU.廠商編號) 列印產地
			                          ,S.訂單號碼 + ' ' + S.庫區 群組一 
                                      ,CASE WHEN S.訂單號碼 LIKE 'WS-%' THEN '網購客戶 : ' + (SELECT TOP 1 寄送袋子 FROM orm_rt WHERE 訂單號碼 = S.訂單號碼)
                                            ELSE '單據編號 : ' + S.單據編號 END 抬頭一
                                      ,(SELECT TOP 1 X.[圖檔] FROM [192.168.1.135].Pic.dbo.xpic X WHERE X.SUPLU_SEQ = SU.序號) 圖檔
                                      ,'Y' 列印圖檔區段
                        FROM {0} S
                        JOIN suplu SU ON S.SUPLU_SEQ = SU.序號
                        WHERE ISNULL(S.已刪除,0) != 1
                        {1}
                        AND (ISNULL(S.入庫數,0) + ISNUll(S.出庫數,0)) != 0
                         ";

            //共用function 需調整日期名稱,form !=, 簡稱類, 串TABLE 簡稱 
            foreach (string form in dic.Keys)
            {
                if (!string.IsNullOrEmpty(dic[form]) && form != "RPT_TYPE" && form != "SORT")
                {
                    string debug = dic[form];
                    switch (form)
                    {
                        case "UPD_USER":
                            this.SetParameters(form, dic[form]);
                            break;
                        case "備註":
                            sqlStr += " AND ISNULL(S.[" + form + "],'') LIKE '%' + @" + form + " + '%' ";
                            this.SetParameters(form, dic[form]);
                            break;
                        case "更新日期_S":
                            sqlStr += " AND CONVERT(DATE,S.[更新日期]) >= @更新日期_S";
                            this.SetParameters(form, dic[form]);
                            break;
                        case "更新日期_E":
                            sqlStr += " AND CONVERT(DATE,S.[更新日期]) <= @更新日期_E";
                            this.SetParameters(form, dic[form]);
                            break;
                        case "入出庫":
                            if ("入庫".Equals(dic[form]))
                            {
                                sqlStr += " AND ISNULL(S.入庫數,0) - ISNULL(S.核銷數,0) <> 0";
                            }
                            else if ("出庫".Equals(dic[form]))
                            {
                                sqlStr += " AND ISNULL(S.出庫數,0) - ISNULL(S.核銷數,0) <> 0";
                            }
                            break;
                        case "DATA_SOURCE":
                            if ("0".Equals(dic[form]))
                            {
                                sqlStr = string.Format(sqlStr, "stkio", " AND ISNULL(S.已結案,0) != 1 ");

                            }
                            else if ("1".Equals(dic[form]))
                            {
                                sqlStr = string.Format(sqlStr, "stkioh", "");
                            }
                            break;
                        default:
                            sqlStr += " AND ISNULL(S.[" + form + "],'') LIKE @" + form + " + '%'";
                            this.SetParameters(form, dic[form]);
                            break;
                    }
                }
            }

            switch (dic["SORT"])
            {
                case "訂單號碼":
                    sqlStr += " ORDER BY S.訂單號碼, S.頤坊型號 ";
                    break;
                case "庫位":
                    sqlStr += " ORDER BY S.庫位, S.廠商編號, S.頤坊型號, S.訂單號碼 ";
                    break;
                default:
                    sqlStr += " ORDER BY S.頤坊型號, S.廠商編號 ";
                    break;
            }

            this.SetSqlText(sqlStr);
            return this;
        }

        /// <summary>
        /// 庫存入出報表 貼紙
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        public IDalBase GetStickerRptData(Dictionary<string, string> dic)
        {
            string sqlStr = "";
            sqlStr = @"SELECT Top 500 S.訂單號碼
			                          ,SU.頤坊型號
                                      ,(SELECT TOP 1 單位 FROM ORD WHERE SU.序號 = ORD.SUPLU_SEQ AND ORD.訂單號碼 = S.訂單號碼) 單位
			                          ,ISNULL(S.出庫數,0) - ISNULL(S.核銷數,0) 出庫數
                                      ,(SELECT TOP 1 客戶型號 FROM ORD WHERE SU.序號 = ORD.SUPLU_SEQ AND ORD.訂單號碼 = S.訂單號碼) 客戶型號
                                      ,SU.頤坊型號 列印頤坊型號
                        FROM {0} S
                        JOIN suplu SU ON S.SUPLU_SEQ = SU.序號
                        WHERE ISNULL(S.已刪除,0) != 1
                        {1}
                        AND ISNUll(S.出庫數,0) != 0
                        AND S.庫區 != '準備' --舊邏輯 新架構沒有準備 直接寫入庫區
                         ";

            //共用function 需調整日期名稱,form !=, 簡稱類, 串TABLE 簡稱 
            foreach (string form in dic.Keys)
            {
                if (!string.IsNullOrEmpty(dic[form]) && form != "RPT_TYPE" && form != "SORT")
                {
                    string debug = dic[form];
                    switch (form)
                    {
                        case "UPD_USER":
                            this.SetParameters(form, dic[form]);
                            break;
                        case "備註":
                            sqlStr += " AND ISNULL(S.[" + form + "],'') LIKE '%' + @" + form + " + '%' ";
                            this.SetParameters(form, dic[form]);
                            break;
                        case "更新日期_S":
                            sqlStr += " AND CONVERT(DATE,S.[更新日期]) >= @更新日期_S";
                            this.SetParameters(form, dic[form]);
                            break;
                        case "更新日期_E":
                            sqlStr += " AND CONVERT(DATE,S.[更新日期]) <= @更新日期_E";
                            this.SetParameters(form, dic[form]);
                            break;
                        case "入出庫":
                            if ("入庫".Equals(dic[form]))
                            {
                                sqlStr += " AND ISNULL(S.入庫數,0) - ISNULL(S.核銷數,0) <> 0";
                            }
                            else if ("出庫".Equals(dic[form]))
                            {
                                sqlStr += " AND ISNULL(S.出庫數,0) - ISNULL(S.核銷數,0) <> 0";
                            }
                            break;
                        case "DATA_SOURCE":
                            if ("0".Equals(dic[form]))
                            {
                                sqlStr = string.Format(sqlStr, "stkio", " AND ISNULL(S.已結案,0) != 1 ");

                            }
                            else if ("1".Equals(dic[form]))
                            {
                                sqlStr = string.Format(sqlStr, "stkioh", "");
                            }
                            break;
                        default:
                            sqlStr += " AND ISNULL(S.[" + form + "],'') LIKE @" + form + " + '%'";
                            this.SetParameters(form, dic[form]);
                            break;
                    }
                }
            }

            switch (dic["SORT"])
            {
                case "大貨庫位":
                    sqlStr += " ORDER BY S.庫位, S.頤坊型號, S.訂單號碼 ";
                    break;
                case "快取庫位":
                    sqlStr += " ORDER BY S.庫位, S.頤坊型號, S.訂單號碼 ";
                    break;
                case "訂單號碼":
                    sqlStr += " ORDER BY S.訂單號碼, S.頤坊型號, S.庫位 ";
                    break;
                case "銷售型號":
                    sqlStr += " ORDER BY S.訂單號碼, 客戶型號, S.庫位 ";
                    break;
                default:
                    sqlStr += " ORDER BY S.頤坊型號, S.廠商編號 ";
                    break;
            }

            this.SetSqlText(sqlStr);
            return this;
        }

        /// <summary>
        /// 庫存入出維護 查詢 Return DataTable
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        public IDalBase SearchTableForMT(Dictionary<string, string> dic)
        {
            string sqlStr = "";
            sqlStr = @"SELECT Top 500 S.訂單號碼
			                          ,S.頤坊型號
                                      ,CONVERT(VARCHAR,S.更新日期,23) 更新日期
		                              ,S.廠商簡稱
			                          ,S.單位
			                          ,S.庫區
			                          ,S.庫位
			                          ,S.單據編號
			                          ,IIF(S.入庫數 = 0, NULL, S.入庫數) 入庫數
			                          ,IIF(S.出庫數 = 0, NULL, S.出庫數) 出庫數
                                      ,IIF(S.核銷數 = 0, NULL, S.核銷數) 核銷數
			                          --,(SELECT SH.入庫數 + SH.出庫數 FROM stkioh SH WHERE SH.SOURCE_TABLE = 'stkio' AND S.序號 = SH.SOURCE_SEQ) 核銷數
			                          ,SU.產品說明
                                      ,S.帳項
                                      ,S.備註
			                          ,S.廠商編號
			                          ,S.客戶編號
			                          ,S.客戶簡稱
			                          ,S.更新人員
			                          ,S.序號
			                          ,CASE WHEN (SELECT TOP 1 1 FROM [192.168.1.135].pic.dbo.xpic X WHERE X.[SUPLU_SEQ] = S.SUPLU_SEQ) = 1 THEN 'Y' ELSE 'N' END [Has_IMG]
			                          ,S.SUPLU_SEQ
                        FROM stkio S
                        JOIN suplu SU ON S.SUPLU_SEQ = SU.序號
                        WHERE ISNULL(S.已刪除,0) != 1
                        AND ISNULL(S.已結案,0) != 1
                        AND (ISNULL(S.入庫數,0) + ISNUll(S.出庫數,0)) != 0
                         ";

            //共用function 需調整日期名稱,form !=, 簡稱類, 串TABLE 簡稱 
            foreach (string form in dic.Keys)
            {
                if (!string.IsNullOrEmpty(dic[form]) && form != "Account")
                {
                    string debug = dic[form];
                    switch (form)
                    {
                        case "產品說明":
                        case "廠商簡稱":
                            sqlStr += " AND ISNULL(S.[" + form + "],'') LIKE '%' + @" + form + " + '%' ";
                            this.SetParameters(form, dic[form]);
                            break;
                        case "更新日期_S":
                            sqlStr += " AND CONVERT(DATE,S.[更新日期]) >= @更新日期_S";
                            this.SetParameters(form, dic[form]);
                            break;
                        case "更新日期_E":
                            sqlStr += " AND CONVERT(DATE,S.[更新日期]) <= @更新日期_E";
                            this.SetParameters(form, dic[form]);
                            break;
                        case "查詢出入庫":
                            if ("入庫".Equals(dic[form]))
                            {
                                sqlStr += " AND ISNULL(S.入庫數,0) <> 0";
                            }
                            else if ("出庫".Equals(dic[form]))
                            {
                                sqlStr += " AND ISNULL(S.出庫數,0) <> 0";
                            }
                            break;
                        default:
                            sqlStr += " AND ISNULL(S.[" + form + "],'') LIKE @" + form + " + '%'";
                            this.SetParameters(form, dic[form]);
                            break;
                    }
                }
            }

            sqlStr += " ORDER BY S.頤坊型號, S.更新日期 ";
            this.SetSqlText(sqlStr);
            return this;
        }

        /// <summary>
        /// 門市庫取核銷 查詢 Return DataTable
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        public IDalBase SearchTableStoreAp(Dictionary<string, string> dic)
        {
            DataTable dt = new DataTable();
            string sqlStr = "";
            sqlStr = @"SELECT Top 500 S.訂單號碼
			                          ,S.廠商簡稱
			                          ,S.頤坊型號
                                      {扣快取}
			                          ,S.單位
			                          ,ISNULL(S.出庫數,0)-ISNULL(S.核銷數,0) AS 預定數量
                                      ,CASE WHEN ISNULL(S.出庫數,0)-ISNULL(S.核銷數,0) > ISNULL(SU.{庫區}庫存數,0) THEN ISNULL(SU.{庫區}庫存數,0) 
                                            ELSE ISNULL(S.出庫數,0)-ISNULL(S.核銷數,0) END AS 本次核銷
			                          ,ISNULL(SU.{庫區}庫存數,0) AS 庫存數
			                          ,{快取} AS 快取庫存數
			                          ,ISNULL(S.庫位,'') AS 庫位
			                          ,S.備註
			                          ,SU.銷售型號
			                          ,RTRIM(SU.產品說明) AS 產品說明
			                          ,S.單據編號
			                          ,S.庫區 AS 出區
			                          ,SU.產品一階
			                          ,S.廠商編號
			                          ,S.序號
			                          ,S.更新人員
			                          ,CONVERT(VARCHAR,S.更新日期,23) 更新日期
			                          ,S.SUPLU_SEQ
                                      ,CASE WHEN (SELECT TOP 1 1 FROM [192.168.1.135].pic.dbo.xpic X WHERE X.[SUPLU_SEQ] = S.SUPLU_SEQ) = 1 THEN 'Y' ELSE 'N' END [Has_IMG]
                        FROM Stkio S 
                        INNER JOIN SUPLU SU ON S.SUPLU_SEQ = SU.序號  
                        WHERE ISNULL(S.出庫數,0)-ISNULL(S.核銷數,0) > 0 
                        AND ISNULL(S.已刪除,0) = 0  
                        AND ISNULL(S.已結案,0) = 0  
                        AND ISNULL(S.出庫數,0) <> 0    
                         ";

            //共用function 需調整日期名稱,form !=, 簡稱類, 串TABLE 簡稱 
            foreach (string form in dic.Keys)
            {
                if (!string.IsNullOrEmpty(dic[form]) && form != "Account")
                {
                    string debug = dic[form];
                    switch (form)
                    {
                        case "更新日期_S":
                            sqlStr += " AND CONVERT(DATE,S.[更新日期]) >= @更新日期_S";
                            this.SetParameters(form, dic[form]);
                            break;
                        case "更新日期_E":
                            sqlStr += " AND CONVERT(DATE,S.[更新日期]) <= @更新日期_E";
                            this.SetParameters(form, dic[form]);
                            break;
                        case "庫區":
                            if ("大貨".Equals(dic[form]))
                            {
                                sqlStr = sqlStr.Replace("{快取}", "ISNULL(SU.快取庫存數, 0)").Replace("{扣快取}", ",'Y' 扣快取");
                            }
                            else 
                            {
                                sqlStr = sqlStr.Replace("{快取}", "0").Replace("{扣快取}", ",'N' 扣快取");
                            }

                            sqlStr = sqlStr.Replace("{庫區}", dic[form]);
                            sqlStr += " AND S.庫區 = @庫區";
                            this.SetParameters(form, dic[form]);
                            break;
                        default:
                            sqlStr += " AND ISNULL(S.[" + form + "],'') LIKE @" + form + " + '%'";
                            this.SetParameters(form, dic[form]);
                            break;
                    }
                }
            }

            sqlStr += " ORDER BY S.頤坊型號, S.更新日期 ";
            this.SetSqlText(sqlStr);
            return this;
        }

        /// <summary>
        /// 庫存入出核銷 查詢 Return DataTable
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        public IDalBase SearchTableForAp(Dictionary<string, string> dic)
        {
            string sqlStr = "";
            sqlStr = @"SELECT Top 500 S.訂單號碼
			                          ,S.頤坊型號
                                      {扣快取}
                                      ,CONVERT(VARCHAR,S.更新日期,23) 更新日期
		                              ,S.廠商簡稱
			                          ,S.單位
                                      ,S.{出入庫}數 - ISNULL(S.核銷數,0) {庫區}{出入庫}
			                          ,SU.{庫區}庫存數 庫存數
                                      ,IIF('{出入庫}' = '出庫' AND SU.{庫區}庫存數 > 0 AND (S.{出入庫}數 - ISNULL(S.核銷數,0)) > SU.{庫區}庫存數, SU.{庫區}庫存數, (S.{出入庫}數 - ISNULL(S.核銷數,0))) 本次核銷數量
                                      ,ISNULL({庫區}庫位,'') AS 目前庫位
			                          ,ISNULL(S.庫位,'') 本次庫位
                                      ,ISNULL(S.備註,'') 備註
                                      ,SU.產品說明
                                      ,SU.暫時型號
			                          ,S.單據編號
			                          ,S.廠商編號
			                          ,S.客戶編號
			                          ,S.客戶簡稱
			                          ,S.帳項
			                          ,S.更新人員
                                      ,'{庫區}' 庫區
                                      ,'{出入庫}' 出入庫
			                          ,S.序號
			                          ,CASE WHEN (SELECT TOP 1 1 FROM [192.168.1.135].pic.dbo.xpic X WHERE X.[SUPLU_SEQ] = S.SUPLU_SEQ) = 1 THEN 'Y' ELSE 'N' END [Has_IMG]
			                          ,S.SUPLU_SEQ
                        FROM stkio S
                        JOIN SUPLU SU ON S.SUPLU_SEQ = SU.序號
                        WHERE ISNULL(S.已刪除,0) != 1
                        AND ISNULL(S.已結案,0) != 1
                        AND (ISNULL(S.入庫數,0) + ISNUll(S.出庫數,0)) != 0
                         ";

            //共用function 需調整日期名稱,form !=, 簡稱類, 串TABLE 簡稱 
            foreach (string form in dic.Keys)
            {
                if (!string.IsNullOrEmpty(dic[form]) && form != "Account")
                {
                    string debug = dic[form];
                    switch (form)
                    {
                        case "產品說明":
                        case "廠商簡稱":
                            sqlStr += " AND ISNULL(S.[" + form + "],'') LIKE '%' + @" + form + " + '%' ";
                            this.SetParameters(form, dic[form]);
                            break;
                        case "更新日期_S":
                            sqlStr += " AND CONVERT(DATE,S.[更新日期]) >= @更新日期_S";
                            this.SetParameters(form, dic[form]);
                            break;
                        case "更新日期_E":
                            sqlStr += " AND CONVERT(DATE,S.[更新日期]) <= @更新日期_E";
                            this.SetParameters(form, dic[form]);
                            break;
                        case "庫區":
                            sqlStr = sqlStr.Replace("{庫區}", dic[form]);
                            sqlStr += " AND S.庫區 = @庫區";
                            this.SetParameters(form, dic[form]);
                            break;
                        case "查詢出入庫":
                            if ("入庫".Equals(dic[form]))
                            {
                                sqlStr = sqlStr.Replace("{出入庫}", dic[form]);
                                sqlStr += " AND ISNULL(S.入庫數,0) <> 0";
                            }
                            else if ("出庫".Equals(dic[form]))
                            {
                                sqlStr = sqlStr.Replace("{出入庫}", dic[form]);
                                sqlStr += " AND ISNULL(S.出庫數,0) <> 0";
                            }
                            break;
                        default:
                            sqlStr += " AND ISNULL(S.[" + form + "],'') LIKE @" + form + " + '%'";
                            this.SetParameters(form, dic[form]);
                            break;
                    }
                }
            }

            if ("大貨".Equals(dic["庫區"]) && "出庫".Equals(dic["查詢出入庫"]))
            {
                sqlStr = sqlStr.Replace("{扣快取}", ",'Y' 扣快取");
            }
            else
            {
                sqlStr = sqlStr.Replace("{扣快取}", ",'N' 扣快取");
            }
            sqlStr += " ORDER BY S.頤坊型號, S.更新日期 ";

            this.SetSqlText(sqlStr);
            return this;
        }

        /// <summary>
        /// 樣品準備作業 查詢 Return DataTable
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        public IDalBase SearchTableForSample(Dictionary<string, string> dic)
        {
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
                                      ,CAST(ISNULL((SELECT TOP 1 1 FROM [192.168.1.135].pic.dbo.xpic X WHERE X.[SUPLU_SEQ] = A.序號),0) AS BIT) [Has_IMG]
					   FROM SUPLU A ";

            foreach (string form in dic.Keys)
            {
                if (!string.IsNullOrEmpty(dic[form]) && form != "Account" && form != "DATA_SOURCE")
                {
                    string debug = dic[form];
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

            if (sqlStr.IndexOf("{0}") != -1)
            {
                sqlStr = string.Format(sqlStr, "''", "''", "''");
            }

            sqlStr += "WHERE 1=1";
            //共用function 需調整日期名稱,form !=, 簡稱類, 串TABLE 簡稱 
            foreach (string form in dic.Keys)
            {
                if (!string.IsNullOrEmpty(dic[form]) && form != "Account" && form != "DATA_SOURCE")
                {
                    string debug = dic[form];
                    switch (form)
                    {
                        case "點收日期_S":
                            sqlStr += " AND CONVERT(DATE,R.[點收日期]) >= @點收日期_S";
                            this.SetParameters(form, dic[form]);
                            break;
                        case "點收日期_E":
                            sqlStr += " AND CONVERT(DATE,R.[點收日期]) <= @點收日期_E";
                            this.SetParameters(form, dic[form]);
                            break;
                        case "採購單號":
                        case "點收批號":
                            sqlStr += " AND ISNULL(R.[" + form + "],'') LIKE @" + form + " + '%'";
                            this.SetParameters(form, dic[form]);
                            break;
                        case "訂單號碼":
                            sqlStr += " AND ISNULL(ST.[" + form + "],'') LIKE @" + form + " + '%'";
                            this.SetParameters(form, dic[form]);
                            break;
                        case "廠商簡稱":
                            sqlStr += " AND ISNULL(A.[廠商簡稱],'') LIKE '%' + @廠商簡稱 + '%'";
                            this.SetParameters(form, dic[form]);
                            break;
                        default:
                            sqlStr += " AND ISNULL(A.[" + form + "],'') LIKE @" + form + " + '%'";
                            this.SetParameters(form, dic[form]);
                            break;
                    }
                }
            }
            this.SetSqlText(sqlStr);
            return this;
        }

        #endregion

        #region 新增區域
        /// <summary>
        /// Insert Stkio 
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        public IDalBase InsertStkio(Stkio stkioModel)
        {
            var column = new StringBuilder();
            var columnVar = new StringBuilder();

            foreach (var property in stkioModel.GetType().GetProperties())
            {
                //序號特殊邏輯， 如DB 訂為 identity可以移除
                if ("序號".Equals(property.Name))
                {
                    column.Append($" [{property.Name}],");
                    columnVar.Append($" (SELECT MAX(序號) + 1 FROM stkio),");
                }
                else if ("建立人員".Equals(property.Name) || "更新人員".Equals(property.Name))
                {
                    column.Append($" [{property.Name}],");
                    columnVar.Append($" '{stkioModel.更新人員}',");
                }
                else if ("建立日期".Equals(property.Name) || "更新日期".Equals(property.Name))
                {
                    column.Append($" [{property.Name}],");
                    columnVar.Append($" GETDATE(),");
                }
                else if ("庫位".Equals(property.Name))
                {
                    //庫位空的抓DEFAULT
                    if (string.IsNullOrEmpty(property.Name))
                    {
                        column.Append($" [{property.Name}],");
                        columnVar.Append($" (SELECT "+ property.GetValue(stkioModel) + "庫位 FROM suplu WHERE 序號 = @SUPLU_SEQ),");
                    }
                    else
                    {
                        column.Append($" [{property.Name}],");
                        columnVar.Append($" @{property.Name},");
                        SetParameters($"@{property.Name}", property.GetValue(stkioModel));
                    }
                }
                else
                {
                    if (property.GetValue(stkioModel, null) != null)
                    {
                        column.Append($" [{property.Name}],");
                        columnVar.Append($" @{property.Name},");
                        SetParameters($"@{property.Name}", property.GetValue(stkioModel));
                    }
                }
            }

            string sqlStr = string.Format($"INSERT INTO stkio ({column.ToString().TrimEnd(',')}) VALUES ({columnVar.ToString().TrimEnd(',')})");
            this.SetSqlText(sqlStr);
            return this;
        }

        /// <summary>
        /// Insert Stkio 
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        public IDalBase InsertStkioFromSuplu(StkioFromSuplu entity)
        {
            CleanParameters();
            string sqlStr = @"   INSERT INTO [dbo].[stkio]
                                               ([序號]
                                               ,[SOURCE_SEQ]
                                               ,[SOURCE_TABLE]
                                               ,[SUPLU_SEQ]
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
                                               ,[客戶編號]
                                               ,[客戶簡稱]
                                               ,[完成品型號]
                                               ,[備註]
                                               ,[內銷入庫]
                                               ,[已結案]
                                               ,[已刪除]
                                               ,[變更日期]
                                               ,[建立人員]
                                               ,[建立日期]
                                               ,[更新人員]
                                               ,[更新日期])
                                         SELECT (Select IsNull(Max(序號),0)+1 From stkio) [序號]
                                               ,@SEQ [SOURCE_SEQ]
                                               ,'suplu' [SOURCE_TABLE]
                                               ,@SEQ [SUPLU_SEQ]
                                               ,@ORDER_NO [訂單號碼]
                                               ,@DOCUMENT_NO [單據編號]
                                               ,NULL [異動日期]
                                               ,@BILL_TYPE [帳項]
                                               ,NULL [帳項原因]
                                               ,[廠商編號]
                                               ,[廠商簡稱]
                                               ,[頤坊型號]
                                               ,[暫時型號]
                                               ,[單位]
                                               ,@STOCK_POS [庫區]
                                               ,@STOCK_I_CNT [入庫數]
                                               ,@STOCK_O_CNT [出庫數]
                                               ,@STOCK_LOC [庫位]
                                               ,0 [核銷數]
                                               ,NULL [異動前庫存]
                                               ,@CUST_NO [客戶編號]
                                               ,@CUST_S_NAME [客戶簡稱]
                                               ,NULL [完成品型號]
                                               ,@REMARK [備註]
                                               ,NULL [內銷入庫]
                                               ,0 [已結案]
                                               ,0 [已刪除]
                                               ,GETDATE() [變更日期]
                                               ,@UPD_USER [建立人員]
                                               ,GETDATE() [建立日期]
                                               ,@UPD_USER [更新人員]
                                               ,GETDATE() [更新日期]
	                                    FROM suplu
	                                    WHERE 序號 = @SEQ
									";

            foreach (var property in entity.GetType().GetProperties())
            {
                if ("STOCK_LOC".Equals(property.Name))
                {
                    //庫位沒有傳入 用 庫區 + 庫位寫入
                    if (string.IsNullOrEmpty(entity.STOCK_LOC))
                    {
                        sqlStr = sqlStr.Replace($"@{property.Name}", entity.STOCK_POS + "庫位");
                    }
                    else
                    {
                        SetParameters($"@{property.Name}", property.GetValue(entity));
                    }
                }
                else
                {
                    SetParameters($"@{property.Name}", property.GetValue(entity));
                }
            }
            this.SetSqlText(sqlStr);
            return this;
        }

        /// <summary>
        /// Insert Stkio From Stkio_sale
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        public IDalBase InsertStkioFromSale(InsertStkioFromSaleModel entity)
        {
            CleanParameters();
            string sqlStr = @"   INSERT INTO [dbo].[stkio]
                                               ([序號]
                                               ,[SOURCE_SEQ]
                                               ,[SOURCE_TABLE]
                                               ,[SUPLU_SEQ]
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
                                               ,[客戶編號]
                                               ,[客戶簡稱]
                                               ,[完成品型號]
                                               ,[備註]
                                               ,[內銷入庫]
                                               ,[已結案]
                                               ,[已刪除]
                                               ,[變更日期]
                                               ,[建立人員]
                                               ,[建立日期]
                                               ,[更新人員]
                                               ,[更新日期])
                                         SELECT (Select IsNull(Max(序號),0)+1 From stkio) [序號]
                                               ,@序號 [SOURCE_SEQ]
                                               ,'stkio_sale' [SOURCE_TABLE]
                                               ,@SUPLU_SEQ [SUPLU_SEQ]
                                               ,S.訂單號碼 [訂單號碼]
                                               ,S.PM_NO [單據編號]
                                               ,GETDATE() [異動日期]
                                               ,'8' [帳項]
                                               ,NULL [帳項原因]
                                               ,SU.[廠商編號]
                                               ,SU.[廠商簡稱]
                                               ,SU.[頤坊型號]
                                               ,SU.[暫時型號]
                                               ,SU.[單位]
                                               ,S.入區 [庫區]
                                               ,S.出貨數 [入庫數]
                                               ,0 [出庫數]
                                               ,S.庫位 [庫位]
                                               ,0 [核銷數]
                                               ,NULL [異動前庫存]
                                               ,'00001' [客戶編號]
                                               ,'IVAN' [客戶簡稱]
                                               ,CASE WHEN SU.[產品一階] = '01' THEN SU.暫時型號 ELSE S.箱號 END [完成品型號]
                                               ,S.備註 [備註]
                                               ,NULL [內銷入庫]
                                               ,0 [已結案]
                                               ,0 [已刪除]
                                               ,GETDATE() [變更日期]
                                               ,@更新人員 [建立人員]
                                               ,GETDATE() [建立日期]
                                               ,@更新人員 [更新人員]
                                               ,GETDATE() [更新日期]
	                                    FROM stkio_sale S
                                        INNER JOIN stkio ST ON S.STKIO_SEQ = ST.序號
                                        INNER JOIN SUPLU SU ON ST.SUPLU_SEQ = SU.序號
	                                    WHERE S.序號 = @序號
									";

            foreach (var property in entity.GetType().GetProperties())
            {
                SetParameters($"@{property.Name}", property.GetValue(entity));
            }
            this.SetSqlText(sqlStr);
            return this;
        }

        #endregion

        #region 更新區域
        /// <summary>
        /// UPDATE Stkio 
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        public IDalBase UpdateStkioOld(Dictionary<string, string> dic)
        {
            string sqlStr = @"      UPDATE [dbo].[stkio]
                                       SET 更新日期 = GETDATE()
										  ,更新人員 = @UPD_USER
                                    ";

            foreach (string form in dic.Keys)
            {
                if (!string.IsNullOrEmpty(dic[form]) && form != "UPD_USER" && form != "SEQ")
                {
                    switch (form)
                    {
                        default:
                            this.SetParameters(form, dic[form]); 
                            sqlStr += " ," + form + " = @" + form;
                            break;
                    }
                }
            }

            this.SetParameters("SEQ", dic["SEQ"]);
            sqlStr += " WHERE [序號] = @SEQ ";
            this.SetParameters("UPD_USER", dic["UPD_USER"]);
            this.SetSqlText(sqlStr);
            return this;
        }

        /// <summary>
        /// UPDATE Stkio 
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        public IDalBase UpdateStkio(Stkio stkio)
        {
            this.CleanParameters();
            string sqlStr = @"      UPDATE [dbo].[stkio]
                                       SET 更新日期 = GETDATE() ";

            foreach (var property in stkio.GetType().GetProperties())
            {
                if (property.GetValue(stkio, null) != null)
                {
                    switch (property.Name)
                    {
                        case "SUPLU_SEQ":
                            break;
                        case "序號":
                            this.SetParameters(property.Name, property.GetValue(stkio));
                            break;
                        case "核銷數":
                            sqlStr += " ," + property.Name + " = ISNULL(核銷數,0) + @核銷數";
                            sqlStr += " , 已結案 = CASE WHEN ISNULL(核銷數,0) + @核銷數 >= ISNULL(入庫數,0) + ISNULL(出庫數,0) THEN 1 ELSE 0 END ";
                            this.SetParameters(property.Name, property.GetValue(stkio));
                            break;
                        default:
                            sqlStr += " ," + property.Name + " = @" + property.Name;
                            this.SetParameters(property.Name, property.GetValue(stkio));
                            break;
                    }
                }
            }

            sqlStr += " WHERE [序號] = @序號 ";
            this.SetSqlText(sqlStr);
            return this;
        }

        /// <summary>
        /// 核銷 Stkio 
        /// </summary>
        /// <returns></returns>
        public IDalBase ApproveStkio(Dictionary<string, string> dic, int cnt)
        {
            CleanParameters();
            string sqlStr = @"      UPDATE [dbo].[stkio]
                                       SET 已結案 = CASE WHEN ISNULL(核銷數,0) + @APPROVE_CNT >= ISNULL(入庫數,0) + ISNULL(出庫數,0) THEN 1 ELSE 0 END 
                                          ,核銷數 = ISNULL(核銷數,0) + @APPROVE_CNT
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
                                            ,[建立人員]
											,[建立日期]
											,[更新人員]
											,[更新日期]
											)
										SELECT (Select IsNull(Max(序號),0)+1 From StkioH) [序號]
											,A.SUPLU_SEQ [SUPLU_SEQ]
											,@SEQ SOURCE_SEQ
											,'stkio' SOURCE_TABLE
											,A.訂單號碼 [訂單號碼]
											,A.單據編號 [單據編號]
											,GETDATE() [異動日期]
											,A.帳項 [帳項]
											,NULL [帳項原因]
											,S.[廠商編號]
											,S.[廠商簡稱]
											,S.[頤坊型號]
											,S.[暫時型號]
											,S.[單位]
											,A.庫區 [庫區]
											,CASE WHEN A.入庫數 > 0 THEN @APPROVE_CNT ELSE 0 END [入庫數]
											,CASE WHEN A.出庫數 > 0 THEN @APPROVE_CNT ELSE 0 END [出庫數]
											,@STOCK_LOC [庫位]
											,0 [核銷數]
											,S.{庫區}庫存數 [異動前庫存]
											,CASE WHEN @QUICK_TAKE = 'Y' THEN @APPROVE_CNT ELSE 0 END [實扣快取數]
											,NULL 客戶編號
						       			    ,NULL 客戶簡稱
											,NULL [完成品型號]
											,[備註]
											,NULL [內銷入庫]
											,0 [已刪除]
											,NULL [變更日期]
                                            ,@UPD_USER [建立人員]
											,GETDATE() [建立日期]
											,@UPD_USER [更新人員]
											,GETDATE() [更新日期]
									FROM stkio A
									JOIN SUPLU S ON A.SUPLU_SEQ = S.序號
                                    WHERE A.序號 = @SEQ

                                    UPDATE SUPLU
                                    SET {庫區}庫存數 = ISNULL({庫區}庫存數,0) + (CASE WHEN ISNULL(ST.出庫數,0) > 0 THEN -1 WHEN ISNULL(ST.入庫數,0) > 0 THEN 1 ELSE 0 END * @APPROVE_CNT)
									   ,{庫區}庫位 = @STOCK_LOC
                                       ,快取庫存數 = ISNULL(快取庫存數,0) - CASE WHEN @QUICK_TAKE = 'Y' THEN @APPROVE_CNT ELSE 0 END
									   ,更新日期 = GETDATE()
                                       ,更新人員 = @UPD_USER
                                    FROM SUPLU S
                                    JOIN stkio ST ON S.序號 = ST.SUPLU_SEQ
                                    WHERE ST.序號 = @SEQ

                                    ";

            string[] seqArray = dic["SEQ[]"].Split(',');
            string[] approveCntArr = dic["APPROVE_CNT[]"].Split(',');
            string[] stockPosArr = dic["STOCK_POS[]"].Split(',');
            string[] stockLocArr = dic["STOCK_LOC[]"].Split(',');
            string[] remarkArr = dic["REMARK[]"].Split(',');
            string[] quickTakeArr = dic["QUICK_TAKE[]"].Split(',');

            this.SetParameters("SEQ", seqArray[cnt]);
            this.SetParameters("APPROVE_CNT", Convert.ToDecimal(approveCntArr[cnt]));
            this.SetParameters("STOCK_LOC", stockLocArr[cnt]);
            this.SetParameters("REMARK", remarkArr[cnt]);
            this.SetParameters("QUICK_TAKE", quickTakeArr[cnt]);
            this.SetParameters("UPD_USER", dic["UPD_USER"]);
            sqlStr = sqlStr.Replace("{庫區}", stockPosArr[cnt]);
            this.SetSqlText(sqlStr);

            return this;
        }

        #endregion

        #region 刪除區域
        /// <summary>
        /// 刪除 單筆
        /// </summary>
        /// <returns></returns>
        public IDalBase DeleteStkioSingle(Dictionary<string, string> dic)
        {
            string sqlStr = @"      UPDATE stkio
                                    SET 已刪除 = 1
                                       ,更新日期 = GETDATE()
									   ,更新人員 = @UPD_USER
                                    WHERE [序號] = @SEQ
                                     ";

            this.SetParameters("SEQ", dic["SEQ"]);
            this.SetParameters("UPD_USER", dic["UPD_USER"]);

            this.SetSqlText(sqlStr);
            return this;
        }

        /// <summary>
        /// 刪除 stkio by 條件
        /// </summary>
        /// <returns></returns>
        public IDalBase DeleteStkio(Stkio stkio)
        {
            string sqlStr = @"      UPDATE stkio
                                    SET 已刪除 = 1
                                       ,更新日期 = GETDATE()
									   ,更新人員 = @更新人員
                                    WHERE ISNULL(已刪除,0)=0
                                    AND ISNULL(已結案,0)=0 --結案不能刪
                                     ";

            foreach (var property in stkio.GetType().GetProperties())
            {
                if (property.GetValue(stkio, null) != null)
                {
                    switch (property.Name)
                    {
                        case "序號":
                            //0為沒有傳入
                            if(!0.Equals(property.GetValue(stkio)))
                            {
                                this.SetParameters(property.Name, property.GetValue(stkio));
                            }
                            break;
                        case "更新人員":
                            this.SetParameters(property.Name, property.GetValue(stkio));
                            break;
                        default:
                            sqlStr += " AND " + property.Name + " = @" + property.Name;
                            this.SetParameters(property.Name, property.GetValue(stkio));
                            break;
                    }
                }
            }

            this.SetSqlText(sqlStr);
            return this;
        }
        #endregion
    }
}
