using System;
using System.Collections.Generic;
using System.Data;
using System.Web;

namespace Ivan_Dal
{
    public class Dal_Pudu : Dal_Base
    {
        /// <summary>
        /// 樣品點收 查詢 Return DataTable
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        public IDalBase SearchTable(Dictionary<string, string> dic)
        {
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
                        ,CAST(ISNULL((SELECT TOP 1 1 FROM [192.168.1.135].pic.dbo.xpic X WHERE X.[SUPLU_SEQ] = P.[SUPLU_SEQ]),0) AS BIT) [Has_IMG]
                        FROM pudu P
                        INNER JOIN SUPLU S ON P.頤坊型號=S.頤坊型號 AND P.廠商編號=S.廠商編號 
                        LEFT JOIN RECUA RA ON P.序號 = RA.PUDU_SEQ
                        LEFT JOIN RECU R ON P.序號 = R.PUDU_SEQ
                        WHERE IsNull(P.採購單號,'') <> ''
                        AND 工作類別 <>'詢價' ";

			//共用function 需調整日期名稱,form !=, 簡稱類, 串TABLE 簡稱 
			foreach (string form in dic.Keys)
			{
				if (!string.IsNullOrEmpty(dic[form]) && form != "Account" && form != "WRITE_OFF")
				{
					switch (form)
					{
						case "採購日期_S":
							sqlStr += " AND CONVERT(DATE,[採購日期]) >= @採購日期_S";
                            this.SetParameters(form, dic[form]);
							break;
						case "採購日期_E":
							sqlStr += " AND CONVERT(DATE,[採購日期]) <= @採購日期_E";
                            this.SetParameters(form, dic[form]);
							break;
						case "廠商簡稱":
							sqlStr += " AND ISNULL(P.[廠商簡稱],'') LIKE '%' + @廠商簡稱 + '%'";
                            this.SetParameters(form, dic[form]);
							break;
						default:
							sqlStr += " AND ISNULL(P.[" + form + "],'') LIKE @" + form + " + '%'";
                            this.SetParameters(form, dic[form]);
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
			if (!string.IsNullOrEmpty(dic["WRITE_OFF"]) && dic["WRITE_OFF"] == "0")
			{
				sqlStr += " HAVING P.採購數量 > ISNULL(SUM(RA.點收數量),0)";
			}

			sqlStr += " ORDER BY P.採購單號,P.頤坊型號";
            this.SetSqlText(sqlStr);
            return this;
        }

        /// <summary>
        /// 樣品開發維護 查詢 Return DataTable
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        public IDalBase SearchTableForMT(Dictionary<string, string> dic)
        {
            DataTable dt = new DataTable();
            string sqlStr = "";
            sqlStr = @" SELECT TOP 500 pudu.[序號]
                                        ,pudu.SUPLU_SEQ
                                        ,pudu.[採購單號]
                                        ,CONVERT(VARCHAR,pudu.[採購日期],23) 採購日期
                                        ,pudu.[樣品號碼]
                                        ,pudu.[工作類別]
                                        ,pudu.[廠商編號]
                                        ,pudu.[廠商簡稱]
                                        ,pudu.[頤坊型號]
                                        ,pudu.[暫時型號]
                                        ,pudu.[廠商型號]
                                        ,pudu.[產品說明]
                                        ,pudu.[單位]
                                        ,IIF(pudu.[台幣單價] = 0, NULL, pudu.[台幣單價]) 台幣單價
                                        ,IIF(pudu.[美元單價] = 0, NULL, pudu.[美元單價]) 美元單價
                                        ,IIF(pudu.[人民幣單價] = 0, NULL, pudu.[人民幣單價]) 人民幣單價
                                        ,IIF(pudu.[單價_2] = 0, NULL, pudu.[單價_2]) 單價_2
                                        ,IIF(pudu.[單價_3] = 0, NULL, pudu.[單價_3]) 單價_3
                                        ,IIF(pudu.[MIN_1] = 0, NULL, pudu.[MIN_1]) 基本量_1
                                        ,IIF(pudu.[MIN_2] = 0, NULL, pudu.[MIN_2]) 基本量_2
                                        ,IIF(pudu.[MIN_3] = 0, NULL, pudu.[MIN_3]) 基本量_3
                                        ,pudu.[外幣幣別]
                                        ,pudu.[外幣單價]
                                        ,pudu.[外幣單價_2]
                                        ,pudu.[外幣單價_3]
                                        ,IIF(pudu.[採購數量] = 0, NULL, pudu.[採購數量]) 採購數量
                                        ,CONVERT(VARCHAR,pudu.[採購交期],23) [採購交期]
                                        ,pudu.[交期狀況]
                                        ,RA.[點收批號]
                                        ,IIF(SUM(ISNULL(RA.[點收數量],0)) = 0, NULL, SUM(ISNULL(RA.[點收數量],0))) 點收數量
                                        ,CONVERT(VARCHAR,RA.[點收日期],23) [點收日期]
                                        ,IIF(SUM(ISNULL(R.[到貨數量],0)) = 0 ,NULL,SUM(ISNULL(R.[到貨數量],0))) 到貨數量
                                        ,CONVERT(VARCHAR,R.[出貨日期],23) [出貨日期]
                                        ,CONVERT(VARCHAR,R.[到貨日期],23) [到貨日期]
                                        ,RA.[運輸編號]
                                        ,RA.[運輸簡稱]
                                        ,pudu.[訂單數量]
                                        ,pudu.[客戶編號]
                                        ,pudu.[客戶簡稱]
                                        ,pudu.[到貨處理] 分配方式
                                        ,pudu.[列表小備註]
                                        ,pudu.[結案]
                                        ,IIF(pudu.[強制結案] = 1, '是', '') 強制結案
                                        ,pudu.[運送方式]
                                        ,pudu.[部門]
                                        ,pudu.[變更日期]
                                        ,pudu.[更新人員]
                                        ,CONVERT(VARCHAR,pudu.[更新日期],23) [更新日期]
                                        ,IIF(pudum.[預付款一] = 0, NULL, pudum.[預付款一]) 預付款一
                                        ,CONVERT(VARCHAR,pudum.[預付日一],23) 預付日一
                                        ,IIF(pudum.[預付款二] = 0, NULL, pudum.[預付款二]) 預付款二
                                        ,CONVERT(VARCHAR,pudum.[預付日二],23) 預付日二
                                        ,IIF(pudum.[附加費] = 0, NULL, pudum.[附加費]) 附加費
                                        ,pudum.附加費說明
                                        ,pudum.大備註一
                                        ,pudum.大備註二
                                        ,pudum.大備註三
                                        ,pudum.特別事項
                                        ,CAST(ISNULL((SELECT TOP 1 1 FROM [192.168.1.135].pic.dbo.xpic X WHERE X.[SUPLU_SEQ] = pudu.[SUPLU_SEQ]),0) AS BIT) [Has_IMG]
                            FROM Dc2..pudu 
                            LEFT JOIN pudum on pudu.採購單號 = pudum.採購單號
                            LEFT JOIN RECUA RA ON pudu.序號 = RA.PUDU_SEQ
                            LEFT JOIN RECU R ON pudu.序號 = R.PUDU_SEQ
                            WHERE ISNULL(pudu.[頤坊型號],'') LIKE @IVAN_TYPE + '%'
                            AND ISNULL(pudu.[樣品號碼],'') LIKE @SAMPLE_NO + '%'
                            AND ISNULL(pudu.[客戶編號],'') LIKE @CUST_NO + '%'
                            AND ISNULL(pudu.[客戶簡稱],'') LIKE '%' + @CUST_S_NAME + '%'
                            AND ISNULL(pudu.[採購單號],'') LIKE @PUDU_NO + '%'
                            AND ISNULL(pudu.[廠商編號],'') LIKE @FACT_NO + '%'
                            AND ISNULL(pudu.[廠商簡稱],'') LIKE '%' + @FACT_S_NAME + '%'
                            AND ISNULL(pudu.[產品說明],'') LIKE '%' + @PROD_DES + '%'
                            AND 強制結案 LIKE '%' + @WRITE_OFF + '%'
                    ";

            if (!string.IsNullOrEmpty(dic["PUDU_DATE_E"]))
            {
                sqlStr += " AND CONVERT(DATE,[採購日期]) <= @PUDU_DATE_E";
            }
            if (!string.IsNullOrEmpty(dic["PUDU_DATE_S"]))
            {
                sqlStr += " AND CONVERT(DATE,[採購日期]) >= @PUDU_DATE_S";
            }

            this.SetParameters("IVAN_TYPE", dic["IVAN_TYPE"]);
            this.SetParameters("PUDU_DATE_S", dic["PUDU_DATE_S"]);
            this.SetParameters("PUDU_DATE_E", dic["PUDU_DATE_E"]);
            this.SetParameters("CUST_NO", dic["CUST_NO"]);
            this.SetParameters("CUST_S_NAME", dic["CUST_S_NAME"]);
            this.SetParameters("SAMPLE_NO", dic["SAMPLE_NO"]);
            this.SetParameters("PUDU_NO", dic["PUDU_NO"]);
            this.SetParameters("FACT_NO", dic["FACT_NO"]);
            this.SetParameters("FACT_S_NAME", dic["FACT_S_NAME"]);
            this.SetParameters("PROD_DES", dic["PROD_DES"]);
            this.SetParameters("WRITE_OFF", dic["WRITE_OFF"]);

            sqlStr += @" GROUP BY pudu.[序號],pudu.[SUPLU_SEQ],pudu.[採購單號],pudu.[採購日期],pudu.[樣品號碼]
                                                              ,pudu.[工作類別],pudu.[廠商編號],pudu.[廠商簡稱],pudu.[頤坊型號]
                                                              ,pudu.[暫時型號],pudu.[廠商型號],pudu.[產品說明],pudu.[單位]
                                                              ,pudu.[台幣單價],pudu.[美元單價],pudu.[人民幣單價],pudu.[單價_2]
                                                              ,pudu.[單價_3],pudu.[MIN_1],pudu.[MIN_2],pudu.[MIN_3]
                                                              ,pudu.[外幣幣別],pudu.[外幣單價],pudu.[外幣單價_2]
                                                              ,pudu.[外幣單價_3],pudu.[採購數量],pudu.[採購交期]
                                                              ,pudu.[交期狀況],RA.[點收批號],RA.[點收日期]
                                                              ,R.[出貨日期],R.[到貨日期],RA.[運輸編號],RA.[運輸簡稱]
                                                              ,pudu.[訂單數量],pudu.[客戶編號],pudu.[客戶簡稱]
                                                              ,pudu.[到貨處理],pudu.[列表小備註],pudu.[結案]
                                                              ,pudu.[強制結案],pudu.[運送方式],pudu.[部門]
                                                              ,pudu.[變更日期],pudu.[更新人員],pudu.[更新日期],pudum.[預付款一]
                                                              ,pudum.[預付日一],pudum.[預付款二],pudum.[預付日二]
                                                              ,pudum.[附加費],pudum.附加費說明
                                                              ,pudum.大備註一,pudum.大備註二,pudum.大備註三,pudum.特別事項";
            this.SetSqlText(sqlStr);
            return this;
        }

        /// <summary>
        /// 樣品到貨作業 查詢 Return DataTable
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        public IDalBase SearchTableForRecu(Dictionary<string, string> dic)
        {
            DataTable dt = new DataTable();
            string sqlStr = "";
            sqlStr = @" SELECT Top 500 MAX(ISNULL(RA.點收批號,'')) 點收批號
                                                                   ,P.廠商簡稱
                                                                   ,P.採購單號
                                                                   ,P.頤坊型號
                                                                   ,P.採購數量
                                                                   ,ISNULL(SUM(RA.點收數量),0) 累計點收
                                                                   ,ISNULL(SUM(R.到貨數量),0) 累計到貨
                                                                   ,CASE WHEN ISNULL(P.台幣單價,0) = 0 THEN '' ELSE CONVERT(VARCHAR,P.台幣單價) END 台幣單價
                                                                   ,CASE WHEN ISNULL(P.美元單價,0) = 0 THEN '' ELSE CONVERT(VARCHAR,P.美元單價) END 美元單價
                                                                   ,CASE WHEN ISNULL(P.外幣單價,0) = 0 THEN '' ELSE CONVERT(VARCHAR,P.外幣單價) END 外幣
                                                                   ,ISNULL(P.到貨處理,'') 到貨備註
                                                                   ,CONVERT(VARCHAR,P.採購交期, 111) 採購交期
                                                                   ,P.產品說明
                                                                   ,P.單位
                                                                   ,P.暫時型號
                                                                   ,P.廠商型號
                                                                   ,P.廠商編號
                                                                   ,CONVERT(VARCHAR,P.採購日期, 111) 採購日期
                                                                   ,CONVERT(VARCHAR, MAX(RA.點收日期), 111) 點收日期
                                                                   ,CONVERT(VARCHAR, MAX(R.到貨日期), 111) 到貨日期
                                                                   ,P.工作類別
                                                                   ,CASE WHEN P.結案 = 1 THEN '是' ELSE '否' END 結案
                                                                   ,P.序號
                                                                   ,P.SUPLU_SEQ
                                                                   ,P.更新人員
                                                                   ,CONVERT(VARCHAR,P.更新日期, 111) 更新日期
                                                                   ,CAST(ISNULL((SELECT TOP 1 1 FROM [192.168.1.135].pic.dbo.xpic X WHERE X.[SUPLU_SEQ] = P.[SUPLU_SEQ]),0) AS BIT) [Has_IMG]
                                                     FROM pudu P
                                                     INNER JOIN SUPLU S ON P.頤坊型號=S.頤坊型號 AND P.廠商編號=S.廠商編號 
                                                     LEFT JOIN RECUA RA ON P.序號 = RA.PUDU_SEQ
                                                     LEFT JOIN RECU R ON P.序號 = R.PUDU_SEQ
                                                     WHERE 1=1
                                              ";

            //共用function 需調整日期名稱,form !=, 簡稱類, 串TABLE 簡稱 
            foreach (string form in dic.Keys)
            {
                if (!string.IsNullOrEmpty(dic[form]) && form != "Account" && form != "WRITE_OFF")
                {
                    switch (form)
                    {
                        case "點收日期_S":
                            sqlStr += " AND CONVERT(DATE,[點收日期]) >= @點收日期_S";
                            this.SetParameters(form, dic[form]);
                            break;
                        case "點收日期_E":
                            sqlStr += " AND CONVERT(DATE,[點收日期]) <= @點收日期_E";
                            this.SetParameters(form, dic[form]);
                            break;
                        case "廠商簡稱":
                            sqlStr += " AND ISNULL(P.[廠商簡稱],'') LIKE '%' + @廠商簡稱 + '%'";
                            this.SetParameters(form, dic[form]);
                            break;
                        case "點收批號":
                            sqlStr += " AND ISNULL(RA.[" + form + "],'') LIKE @" + form + " + '%'";
                            this.SetParameters(form, dic[form]);
                            break;
                        default:
                            sqlStr += " AND ISNULL(P.[" + form + "],'') LIKE @" + form + " + '%'";
                            this.SetParameters(form, dic[form]);
                            break;
                    }
                }
            }

            sqlStr += @" GROUP BY P.廠商簡稱,P.採購單號,P.頤坊型號,P.採購數量
                                                               ,P.台幣單價,P.美元單價,P.外幣單價
                                                               ,P.到貨處理, P.採購交期,P.產品說明
                                                               ,P.單位,P.暫時型號,P.廠商型號,P.廠商編號
                                                               ,P.採購日期,P.工作類別,P.結案,P.序號
                                                               ,S.序號,P.SUPLU_SEQ,P.更新人員,P.更新日期";

            //未結案
            if (!string.IsNullOrEmpty(dic["WRITE_OFF"]) && dic["WRITE_OFF"] == "0")
            {
                sqlStr += " HAVING (ISNULL(SUM(RA.點收數量),0) > ISNULL(SUM(R.到貨數量),0)) OR (ISNULL(採購數量,0) > ISNULL(SUM(R.到貨數量),0))";
            }

            sqlStr += " ORDER BY P.採購單號,P.頤坊型號";
            this.SetSqlText(sqlStr);
            return this;
        }

        /// <summary>
		/// 樣品開發維護報表
		/// </summary>
		/// <param name="context"></param>
		/// <returns></returns>
		public IDalBase SampleMTReport(Dictionary<string, string> dic)
        {
            DataTable dt = new DataTable();
            string workType = "";
            string sqlStr = "";

            if (dic["WORK_TYPE"] != "3")
            {
                switch (dic["WORK_TYPE"])
                {
                    case "0":
                        workType = "開";
                        break;
                    case "1":
                        workType = "詢";
                        break;
                    case "2":
                        workType = "索";
                        break;
                }

                sqlStr = @" SELECT P.採購單號,P.採購日期,P.樣品號碼,P.工作類別,P.廠商編號,P.廠商簡稱,P.頤坊型號,CASE WHEN P.頤坊型號 = P.暫時型號 THEN '暫時型號' ELSE '頤坊型號' END  抬頭,P.廠商型號,P.產品說明,P.單位,
                                    P.台幣單價,P.美元單價,P.單價_2,P.單價_3,P.MIN_1,P.MIN_2,P.MIN_3,P.外幣幣別,P.外幣單價,P.採購數量,P.採購交期,P.列表小備註,
                                    S.廠商名稱,S.連絡人採購,S.公司地址,S.電話,S.傳真,S.幣別,
                                    S.所在地,PU.大備註一,PU.大備註二,PU.大備註三
                                   ,'' 列印圖檔, '' 圖檔, P.採購單號 群組一
	                               ,CASE WHEN ISNULL(S.email開發,'') <> '' THEN  '    E-mail: ' + S.email開發 ELSE S.連絡人開發 END 連絡人與email
                                   ,CASE WHEN ISNULL(外幣單價,0) <> 0 THEN 外幣幣別 WHEN ISNULL(美元單價,0) <> 0 THEN '(USD)' ELSE 'NTD' END 預設幣別 
	                               ,CASE WHEN ISNULL(外幣單價,0) <> 0 THEN 外幣單價 WHEN ISNULL(美元單價,0) <> 0 THEN 美元單價 ELSE 台幣單價 END 單價 
	                               ,CASE WHEN ISNULL(外幣單價,0) <> 0 THEN 外幣單價 WHEN ISNULL(美元單價,0) <> 0 THEN 美元單價 ELSE 台幣單價 END * ISNULL(採購數量,0) 金額
	                               ,(SELECT 內容 FROM refdata r JOIN pass p ON r.備註 = CASE WHEN p.所在地 = '汐止' THEN p.所在地 ELSE '內湖' END WHERE 代碼 = '交貨地點' AND p.使用者名稱 = @USER) 交貨地點
	                               ,(SELECT TOP 1 R.RI_IMAGE FROM [192.168.1.135].pic.dbo.REF_IMAGE R WHERE R.RI_REFENCE_KEY = @USER) 簽名圖檔1
                             FROM PUDU P 
                             INNER JOIN SUP S ON P.廠商編號=S.廠商編號 
                             LEFT JOIN PUDUM PU ON P.採購單號=PU.採購單號 
                             WHERE P.採購單號 >= @PUDU_NO_S 
                             AND P.採購單號 <= @PUDU_NO_E
                             AND P.工作類別 LIKE '%' + @WORK_TYPE + '%' 
                             ORDER BY P.頤坊型號 ";

                this.SetParameters("USER", "IVAN");
                this.SetParameters("PUDU_NO_S", dic["PUDU_NO_S"]);
                this.SetParameters("PUDU_NO_E", dic["PUDU_NO_E"]);
                this.SetParameters("WORK_TYPE", workType);
            }
            else
            {
                sqlStr = @" SELECT P.採購單號,P.採購日期,P.樣品號碼,P.工作類別,P.廠商編號,P.廠商簡稱,P.頤坊型號,CASE WHEN P.頤坊型號 = P.暫時型號 THEN '暫時型號' ELSE '頤坊型號' END 抬頭,P.廠商型號,P.產品說明,P.單位,
                                P.台幣單價,P.美元單價,P.單價_2,P.單價_3,P.MIN_1,P.MIN_2,P.MIN_3,P.外幣幣別,P.外幣單價,P.採購數量,P.採購交期,P.列表小備註,
                                S.廠商名稱,S.連絡人採購,S.公司地址,S.電話,S.傳真,S.幣別,
                                S.所在地,PU.大備註一,PU.大備註二,PU.大備註三,
                                P.採購單號 群組一, P.到貨處理 列印到貨處理
                            FROM PUDU P 
                            INNER JOIN SUP S ON P.廠商編號=S.廠商編號 
                            LEFT JOIN PUDUM PU ON P.採購單號=PU.採購單號
                            LEFT JOIN RECU R ON P.序號 = R.PUDU_SEQ 
                            WHERE (1=0 ";

                if (dic["PUDU_NO_1"] != "")
                {
                    sqlStr += " OR P.採購單號 = @PUDU_NO_1 ";
                    this.SetParameters("PUDU_NO_1", dic["PUDU_NO_1"]);
                }
                if (dic["PUDU_NO_2"] != "")
                {
                    sqlStr += " OR P.採購單號 = @PUDU_NO_2 ";
                    this.SetParameters("PUDU_NO_2", dic["PUDU_NO_2"]);
                }
                if (dic["PUDU_NO_3"] != "")
                {
                    sqlStr += " OR P.採購單號 = @PUDU_NO_3 ";
                    this.SetParameters("PUDU_NO_3", dic["PUDU_NO_3"]);
                }
                if (dic["PUDU_NO_4"] != "")
                {
                    sqlStr += " OR P.採購單號 = @PUDU_NO_4 ";
                    this.SetParameters("PUDU_NO_4", dic["PUDU_NO_4"]);
                }
                if (dic["PUDU_NO_5"] != "")
                {
                    sqlStr += " OR P.採購單號 = @PUDU_NO_5 ";
                    this.SetParameters("PUDU_NO_5", dic["PUDU_NO_5"]);
                }

                sqlStr += ")";
                sqlStr += @" GROUP BY P.採購單號,P.採購日期,P.樣品號碼,P.工作類別,P.廠商編號,P.廠商簡稱,P.頤坊型號,P.頤坊型號,P.廠商型號,P.產品說明,P.單位,
                                                              P.台幣單價,P.美元單價,P.單價_2,P.單價_3,P.MIN_1,P.MIN_2,P.MIN_3,P.外幣幣別,P.外幣單價,P.採購數量,P.採購交期,P.列表小備註,
                                                              S.廠商名稱,S.連絡人採購,S.公司地址,S.電話,S.傳真,S.幣別,
                                                              S.所在地,PU.大備註一,PU.大備註二,PU.大備註三,
                                                              P.採購單號, P.到貨處理
                                                     HAVING IsNull(P.採購數量,0) - SUM(IsNull(R.到貨數量,0)) > 0   ";

            }
            this.SetSqlText(sqlStr);
            return this;
        }

        /// <summary>
		/// 寫入
		/// </summary>
		/// <returns></returns>
		public IDalBase InsertPudu(Dictionary<string, string> dic)
        {
            string sqlStr = @" INSERT INTO [dbo].[pudu]
                                    (序號,SUPLU_SEQ,[樣品號碼],[工作類別],[廠商編號],[廠商簡稱]
                                    ,[頤坊型號],[暫時型號],[廠商型號],[產品說明]
                                    ,[客戶編號],[客戶簡稱],[到貨處理],[強制結案]
                                    ,[採購單號],[採購日期],[採購數量],[採購交期]
                                    ,[單位]
                                    --,[到貨數量],[出貨日期],[到貨日期]
                                    --,[點收批號],[點收數量],[點收日期]
                                    --,[交期狀況],[列表小備註],[美元單價],[台幣單價]
                                    --,[單價_2]  ,[單價_3],[min_1] ,[min_2],[min_3] 
                                    ,[更新人員] ,[更新日期])
                                SELECT (Select IsNull(Max(序號),0)+1 From pudu), @SUPLU_SEQ
                                    ,@SAMPLE_NO,@WORK_TYPE,@FACT_NO,@FACT_S_NAME
                                    ,@IVAN_TYPE,@TMP_TYPE,@FACT_TYPE,@PROD_DESC
                                    ,@CUST_NO,@CUST_S_NAME,@GIVE_WAY, 0
                                    ,@PUDU_NO,@PUDU_DATE,@PUDU_CNT,@PUDU_GIVE_DATE
                                    ,@UNIT
                                    --,@ACC_SHIP_CNT,@GIVE_SHIP_DATE,@ACC_SHIP_DATE
                                    --,@CHECK_NO,@CHECK_CNT,@CHECK_DATE
                                    --,@GIVE_STATUS,@RPT_REMARK
                                    --,IIF(@USD = '', 0,CONVERT(DECIMAL,@USD))
                                    --,IIF(@NTD = '', 0,CONVERT(DECIMAL,@NTD))
                                    --,IIF(@PRICE_2 = '', 0,CONVERT(DECIMAL,@PRICE_2))
                                    --,IIF(@PRICE_3 = '', 0,CONVERT(DECIMAL,@PRICE_3))
                                    --,IIF(@MIN_1 = '', 0,CONVERT(DECIMAL,@MIN_1))
                                    --,IIF(@MIN_2 = '', 0,CONVERT(DECIMAL,@MIN_2))
                                    --,IIF(@MIN_3 = '', 0,CONVERT(DECIMAL,@MIN_3))
                                    ,@UPD_USER, GETDATE() ";

            this.SetParameters("SEQ", dic["SEQ"]);
            this.SetParameters("SUPLU_SEQ", dic["SUPLU_SEQ"]);
            this.SetParameters("UNIT", dic["UNIT"]);
            this.SetParameters("SAMPLE_NO", dic["SAMPLE_NO"]);
            this.SetParameters("IVAN_TYPE", dic["IVAN_TYPE"]);
            this.SetParameters("FACT_NO", dic["FACT_NO"]);
            this.SetParameters("FACT_S_NAME", dic["FACT_S_NAME"]);
            this.SetParameters("TMP_TYPE", dic["TMP_TYPE"]);
            this.SetParameters("FACT_TYPE", dic["FACT_TYPE"]);
            this.SetParameters("PROD_DESC", dic["PROD_DESC"]);
            this.SetParameters("WORK_TYPE", dic["WORK_TYPE"]);
            this.SetParameters("RPT_REMARK", dic["RPT_REMARK"]);
            this.SetParameters("CUST_NO", dic["CUST_NO"]);
            this.SetParameters("CUST_S_NAME", dic["CUST_S_NAME"]);
            this.SetParameters("GIVE_WAY", dic["GIVE_WAY"]);
            this.SetParameters("PUDU_NO", dic["PUDU_NO"]);
            this.SetParameters("PUDU_DATE", dic["PUDU_DATE"]);
            this.SetParameters("PUDU_CNT", dic["PUDU_CNT"]);
            this.SetParameters("PUDU_GIVE_DATE", dic["PUDU_GIVE_DATE"]);
            this.SetParameters("UPD_USER", "IVAN10");

            this.SetSqlText(sqlStr);
            return this;
        }

        /// <summary>
        /// UPDATE
        /// </summary>
        /// <returns></returns>
        public IDalBase UpdatePudu(Dictionary<string, string> dic)
        {
            string sqlStr = @" UPDATE [dbo].[pudu]
                                SET SUPLU_SEQ = @SUPLU_SEQ
                                ,[採購單號] = @PUDU_NO
                                ,[採購日期] = @PUDU_DATE
                                ,[樣品號碼] = @SAMPLE_NO
                                ,[強制結案] = @FORCE_CLOSE
                                ,[結案] = CASE WHEN @FORCE_CLOSE = 1 THEN 1 ELSE 結案 END
                                ,[工作類別] = @WORK_TYPE
                                ,[廠商編號] = @FACT_NO
                                ,[廠商簡稱] = @FACT_S_NAME
                                ,[頤坊型號] = @IVAN_TYPE
                                ,[暫時型號] = @TMP_TYPE
                                ,[廠商型號] = @FACT_TYPE
                                ,[產品說明] = @PROD_DESC
                                ,[採購數量] = @PUDU_CNT
                                ,[採購交期] = @PUDU_GIVE_DATE
                                ,[交期狀況] = @GIVE_STATUS
                                ,[客戶編號] = @CUST_NO
                                ,[客戶簡稱] = @CUST_S_NAME
                                ,[到貨處理] = @GIVE_WAY
                                ,[列表小備註] = @RPT_REMARK
                                ,[單位] = @UNIT
                                ,[美元單價] = IIF(@USD = '', 0,CONVERT(DECIMAL,@USD))
                                ,[台幣單價] = IIF(@NTD = '', 0,CONVERT(DECIMAL,@NTD))
                                ,[單價_2] = IIF(@PRICE_2 = '', 0,CONVERT(DECIMAL,@PRICE_2))
                                ,[單價_3] = IIF(@PRICE_3 = '', 0,CONVERT(DECIMAL,@PRICE_3))
                                ,[min_1] = IIF(@MIN_1 = '', 0,CONVERT(DECIMAL,@MIN_1))
                                ,[min_2] = IIF(@MIN_2 = '', 0,CONVERT(DECIMAL,@MIN_2))
                                ,[min_3] = IIF(@MIN_3 = '', 0,CONVERT(DECIMAL,@MIN_3))
                                ,[外幣幣別] = @FORE_CODE
                                ,[外幣單價] = IIF(@FORE_AMT = '', 0,CONVERT(DECIMAL,@FORE_AMT))
                                ,[更新人員] = @UPD_USER
                                ,[變更日期] = GETDATE()
                                WHERE [序號] = @SEQ 

                            --增加回報COST
                            IF(@WORK_TYPE like '%詢%' AND @AMT_CHANGE = 1)
			                BEGIN
				                UPDATE SUPLU
                                SET [美元單價] = IIF(@USD = '', 0,CONVERT(DECIMAL,@USD))
                                    ,[台幣單價] = IIF(@NTD = '', 0,CONVERT(DECIMAL,@NTD))
                                    ,[單價_2] = IIF(@PRICE_2 = '', 0,CONVERT(DECIMAL,@PRICE_2))
                                    ,[單價_3] = IIF(@PRICE_3 = '', 0,CONVERT(DECIMAL,@PRICE_3))
                                    ,[min_1] = IIF(@MIN_1 = '', 0,CONVERT(DECIMAL,@MIN_1))
                                    ,[min_2] = IIF(@MIN_2 = '', 0,CONVERT(DECIMAL,@MIN_2))
                                    ,[min_3] = IIF(@MIN_3 = '', 0,CONVERT(DECIMAL,@MIN_3))
                                    ,[外幣幣別] = @FORE_CODE
                                    ,[外幣單價] = IIF(@FORE_AMT = '', 0,CONVERT(DECIMAL,@FORE_AMT))
                                    ,更新人員 = @UPD_USER
                                WHERE [序號] = @SUPLU_SEQ 
			                END
                    ";

            this.SetParameters("FORCE_CLOSE", dic["FORCE_CLOSE"]);
            this.SetParameters("GIVE_STATUS", dic["GIVE_STATUS"]);
            this.SetParameters("CHECK_NO", dic["CHECK_NO"]);
            this.SetParameters("CHECK_DATE", dic["CHECK_DATE"]);
            this.SetParameters("CHECK_CNT", dic["CHECK_CNT"]);
            this.SetParameters("ACC_SHIP_CNT", dic["ACC_SHIP_CNT"]);
            this.SetParameters("GIVE_SHIP_DATE", dic["GIVE_SHIP_DATE"]);
            this.SetParameters("ACC_SHIP_DATE", dic["ACC_SHIP_DATE"]);
            this.SetParameters("USD", dic["USD"]);
            this.SetParameters("NTD", dic["NTD"]);
            this.SetParameters("FORE_CODE", dic["FORE_CODE"]);
            this.SetParameters("FORE_AMT", dic["FORE_AMT"]);
            this.SetParameters("PRICE_2", dic["PRICE_2"]);
            this.SetParameters("PRICE_3", dic["PRICE_3"]);
            this.SetParameters("MIN_1", dic["MIN_1"]);
            this.SetParameters("MIN_2", dic["MIN_2"]);
            this.SetParameters("MIN_3", dic["MIN_3"]);
            this.SetParameters("AMT_CHANGE", dic["AMT_CHANGE"]);
            this.SetParameters("SEQ", dic["SEQ"]);
            this.SetParameters("SUPLU_SEQ", dic["SUPLU_SEQ"]);
            this.SetParameters("UNIT", dic["UNIT"]);
            this.SetParameters("SAMPLE_NO", dic["SAMPLE_NO"]);
            this.SetParameters("IVAN_TYPE", dic["IVAN_TYPE"]);
            this.SetParameters("FACT_NO", dic["FACT_NO"]);
            this.SetParameters("FACT_S_NAME", dic["FACT_S_NAME"]);
            this.SetParameters("TMP_TYPE", dic["TMP_TYPE"]);
            this.SetParameters("FACT_TYPE", dic["FACT_TYPE"]);
            this.SetParameters("PROD_DESC", dic["PROD_DESC"]);
            this.SetParameters("WORK_TYPE", dic["WORK_TYPE"]);
            this.SetParameters("RPT_REMARK", dic["RPT_REMARK"]);
            this.SetParameters("CUST_NO", dic["CUST_NO"]);
            this.SetParameters("CUST_S_NAME", dic["CUST_S_NAME"]);
            this.SetParameters("GIVE_WAY", dic["GIVE_WAY"]);
            this.SetParameters("PUDU_NO", dic["PUDU_NO"]);
            this.SetParameters("PUDU_DATE", dic["PUDU_DATE"]);
            this.SetParameters("PUDU_CNT", dic["PUDU_CNT"]);
            this.SetParameters("PUDU_GIVE_DATE", dic["PUDU_GIVE_DATE"]);
            this.SetParameters("UPD_USER", dic["Account"]);

            this.SetSqlText(sqlStr);
            return this;
        }

        /// <summary>
        /// UPDATE SEQ
        /// </summary>
        /// <returns></returns>
        public IDalBase UpdateSeq(Dictionary<string, string> dic)
        {
            string sqlStr = @" UPDATE pudu SET 採購單號 = N.SEQ
			                                    ,採購交期 = @PUDU_GIVE_DATE
			                                    ,採購日期 = GETDATE()
			                                    ,更新人員 = @UPD_USER
			                                    ,更新日期 = GETDATE()
                                    FROM pudu P 
                                    JOIN (SELECT SUBSTRING(CONVERT(VARCHAR,GETDATE(),111),3,2)
		                                    + CASE MONTH(GETDATE()) WHEN 10 THEN 'A' WHEN 11 THEN 'B' WHEN 12 THEN 'C' ELSE CONVERT(VARCHAR,MONTH(GETDATE())) END
		                                    + RIGHT(REPLICATE('0', len(號碼長度)) + CONVERT(VARCHAR,號碼 + ROW_NUMBER() OVER(ORDER BY P.廠商編號 ASC)), len(號碼長度))
		                                    + 字尾 SEQ, P.廠商編號, P.樣品號碼 
	                                    FROM nofile N 
	                                    JOIN (SELECT DISTINCT 廠商編號,樣品號碼 FROM pudu WHERE 樣品號碼 = @SAMPLE_NO) P ON 1 = 1
	                                    WHERE N.使用者 = @SET_SEQ_USER
	                                    AND 單據 LIKE '%' + @WORK_TYPE +'%') N ON P.廠商編號 = N.廠商編號 AND P.樣品號碼 = N.樣品號碼

                                    --更新nofile
                                    UPDATE nofile 
                                    SET 年度 = SUBSTRING(CONVERT(VARCHAR,GETDATE(),111),3,2)
	                                    ,月份 = CONVERT(VARCHAR,MONTH(GETDATE()))
	                                    ,號碼 = 號碼 + (SELECT COUNT(1) FROM (SELECT 廠商編號 FROM pudu WHERE 樣品號碼 = @SAMPLE_NO GROUP BY 廠商編號) B)
                                    FROM nofile N
                                    WHERE N.使用者 = @SET_SEQ_USER
                                    AND 單據 LIKE '%' + '開發' +'%'  ";

            this.SetParameters("FORCE_CLOSE", dic["FORCE_CLOSE"]);
            this.SetParameters("UPD_USER", "IVAN");
            this.SetParameters("SAMPLE_NO", dic["SAMPLE_NO"]);
            this.SetParameters("WORK_TYPE", dic["WORK_TYPE"]);
            this.SetParameters("PUDU_GIVE_DATE", dic["PUDU_GIVE_DATE"]);
            //特殊需求 如是以下這些人，先以Nancy 撈取號碼 先註解 等UPD_USER 抓session後使用
            if (dic["Account"] == "游佩穎" || dic["Account"] == "莊智涵" || dic["Account"] == "智涵"
                || dic["Account"] == "冠蓉" || dic["Account"] == "陳顥翰" || dic["Account"] == "黃如韻" || dic["Account"] == "許薇萱")
            {
                this.SetParameters("SET_SEQ_USER", "IVAN");
            }
            else
            {
                this.SetParameters("SET_SEQ_USER", "IVAN");
            }

            this.SetSqlText(sqlStr);
            return this;
        }

        /// <summary>
        /// UPDATE RPT_REMARK
        /// </summary>
        /// <returns></returns>
        public IDalBase UpdateRptRemark(Dictionary<string, string> dic)
        {
            string sqlStr = @" DELETE FROM pudum WHERE [採購單號] = @PUDU_NO
                                INSERT INTO [dbo].[pudum]
                                SELECT (Select IsNull(Max(序號),0)+1 From pudum) [序號] 
                                    ,@PUDU_NO 採購單號
                                    ,@CURR_CODE 幣別
                                    ,IIF(@PRE_PAY_AMT_1 = '', 0,CONVERT(DECIMAL,@PRE_PAY_AMT_1)) 預付款一
                                    ,IIF(@PRE_PAY_DATE_1 = '', NULL, @PRE_PAY_DATE_1) 預付日一
                                    ,IIF(@PRE_PAY_AMT_2 = '', 0,CONVERT(DECIMAL,@PRE_PAY_AMT_2)) 預付款二
                                    ,IIF(@PRE_PAY_DATE_2 = '', NULL, @PRE_PAY_DATE_2) 預付日二
                                    ,null 核銷金額
                                    ,null 核銷日期
                                    ,IIF(@ADD_AMT = '', 0,CONVERT(DECIMAL,@ADD_AMT)) 附加費一
                                    ,@ADD_DESC [附加費說明]
                                    ,@BIG_REMARK_1 [大備註一]
                                    ,@BIG_REMARK_2 [大備註二]
                                    ,@BIG_REMARK_3 [大備註三]
                                    ,@SPEC_REMARK [特別事項]
                                    ,null 變更日期
                                    ,@UPD_USER [更新人員]
                                    ,GETDATE() [更新日期] ";

            this.SetParameters("PUDU_NO", dic["PUDU_NO"]);
            this.SetParameters("CURR_CODE", dic["CURR_CODE"]);
            this.SetParameters("PRE_PAY_AMT_1", dic["PRE_PAY_AMT_1"]);
            this.SetParameters("PRE_PAY_DATE_1", dic["PRE_PAY_DATE_1"]);
            this.SetParameters("PRE_PAY_AMT_2", dic["PRE_PAY_AMT_2"]);
            this.SetParameters("PRE_PAY_DATE_2", dic["PRE_PAY_DATE_2"]);
            this.SetParameters("ADD_AMT", dic["ADD_AMT"]);
            this.SetParameters("ADD_DESC", dic["ADD_DESC"]);
            this.SetParameters("BIG_REMARK_1", dic["BIG_REMARK_1"]);
            this.SetParameters("BIG_REMARK_2", dic["BIG_REMARK_2"]);
            this.SetParameters("BIG_REMARK_3", dic["BIG_REMARK_3"]);
            this.SetParameters("SPEC_REMARK", dic["SPEC_REMARK"]);
            this.SetParameters("UPD_USER", dic["Account"]);

            this.SetSqlText(sqlStr);
            return this;
        }

        /// <summary>
        /// UPDATE 結案
        /// </summary>
        /// <returns></returns>
        public IDalBase UpdateWriteOff(Dictionary<string, string> dic, string seq)
        {
            string sqlStr = "";
            sqlStr = @" UPDATE pudu
                        SET [結案] = @FORCE_CLOSE,
                            [強制結案] = @FORCE_CLOSE
                        WHERE 序號 = @SEQ";
            this.SetParameters("SEQ", seq);
            this.SetParameters("FORCE_CLOSE", dic["FORCE_CLOSE"]);
            this.SetSqlText(sqlStr);
            return this;
        }
    }
}
