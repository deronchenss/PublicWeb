using Ivan.DAL.Models;
using Ivan_Dal;
using System;
using System.Data;
using System.Text;
using System.Web;

namespace Ivan_Service
{
    /// <summary>
    /// 核銷數邏輯待stkio 資料都已結案或刪除 剩新資料再調整
    /// </summary>
    public class Dal_Stkio : LogicBase
    {
        public Dal_Stkio(HttpContext _context)
        {
            context = _context;
        }

        #region 查詢區域

        /// <summary>
        /// 庫存入出查詢 查詢 Return DataTable
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        public DataTable SearchTable()
        {
            DataTable dt = new DataTable();
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
            foreach (string form in context.Request.Form)
            {
                if (!string.IsNullOrEmpty(context.Request[form]) && form != "Call_Type")
                {
                    string debug = context.Request[form];
                    switch (form)
                    {
                        case "產品說明":
                        case "廠商簡稱":
                            sqlStr += " AND ISNULL(S.[" + form + "],'') LIKE '%' + @" + form + " + '%' ";
                            this.SetParameters(form, context.Request[form]);
                            break;
                        case "更新日期_S":
                            sqlStr += " AND CONVERT(DATE,S.[更新日期]) >= @更新日期_S";
                            this.SetParameters(form, context.Request[form]);
                            break;
                        case "更新日期_E":
                            sqlStr += " AND CONVERT(DATE,S.[更新日期]) <= @更新日期_E";
                            this.SetParameters(form, context.Request[form]);
                            break;
                        case "查詢出入庫":
                            if ("入庫".Equals(context.Request[form]))
                            {
                                sqlStr += " AND ISNULL(S.入庫數,0) <> 0";
                            }
                            else if ("出庫".Equals(context.Request[form]))
                            {
                                sqlStr += " AND ISNULL(S.出庫數,0) <> 0";
                            }
                            break;
                        case "資料來源":
                            if("0".Equals(context.Request[form]))
                            {
                                sqlStr = string.Format(sqlStr, "NULL", "stkio", " AND ISNULL(S.已結案,0) != 1 ");

                            }
                            else if ("1".Equals(context.Request[form]))
                            {
                                sqlStr = string.Format(sqlStr, "IIF(S.實扣快取數=0,NULL,S.實扣快取數)", "stkioh", "");
                            }
                            break;
                        default:
                            sqlStr += " AND ISNULL(S.[" + form + "],'') LIKE @" + form + " + '%'";
                            this.SetParameters(form, context.Request[form]);
                            break;
                    }
                }
            }

            sqlStr += " ORDER BY S.頤坊型號, S.廠商編號 ";

            dt = GetDataTableWithLog(sqlStr);
            return dt;
        }

        /// <summary>
        /// 庫存入出維護 查詢 Return DataTable
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        public DataTable SearchTableForMT()
        {
            DataTable dt = new DataTable();
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
            foreach (string form in context.Request.Form)
            {
                if (!string.IsNullOrEmpty(context.Request[form]) && form != "Call_Type")
                {
                    string debug = context.Request[form];
                    switch (form)
                    {
                        case "產品說明":
                        case "廠商簡稱":
                            sqlStr += " AND ISNULL(S.[" + form + "],'') LIKE '%' + @" + form + " + '%' ";
                            this.SetParameters(form, context.Request[form]);
                            break;
                        case "更新日期_S":
                            sqlStr += " AND CONVERT(DATE,S.[更新日期]) >= @更新日期_S";
                            this.SetParameters(form, context.Request[form]);
                            break;
                        case "更新日期_E":
                            sqlStr += " AND CONVERT(DATE,S.[更新日期]) <= @更新日期_E";
                            this.SetParameters(form, context.Request[form]);
                            break;
                        case "查詢出入庫":
                            if ("入庫".Equals(context.Request[form]))
                            {
                                sqlStr += " AND ISNULL(S.入庫數,0) <> 0";
                            }
                            else if ("出庫".Equals(context.Request[form]))
                            {
                                sqlStr += " AND ISNULL(S.出庫數,0) <> 0";
                            }
                            break;
                        default:
                            sqlStr += " AND ISNULL(S.[" + form + "],'') LIKE @" + form + " + '%'";
                            this.SetParameters(form, context.Request[form]);
                            break;
                    }
                }
            }

            sqlStr += " ORDER BY S.頤坊型號, S.更新日期 ";

            dt = GetDataTableWithLog(sqlStr);
            return dt;
        }

        /// <summary>
        /// 庫存入出核銷 查詢 Return DataTable
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        public DataTable SearchTableForAp()
        {
            DataTable dt = new DataTable();
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
                                      ,{庫區}庫位 AS 目前庫位
			                          ,S.庫位 本次庫位
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
            foreach (string form in context.Request.Form)
            {
                if (!string.IsNullOrEmpty(context.Request[form]) && form != "Call_Type")
                {
                    string debug = context.Request[form];
                    switch (form)
                    {
                        case "產品說明":
                        case "廠商簡稱":
                            sqlStr += " AND ISNULL(S.[" + form + "],'') LIKE '%' + @" + form + " + '%' ";
                            this.SetParameters(form, context.Request[form]);
                            break;
                        case "更新日期_S":
                            sqlStr += " AND CONVERT(DATE,S.[更新日期]) >= @更新日期_S";
                            this.SetParameters(form, context.Request[form]);
                            break;
                        case "更新日期_E":
                            sqlStr += " AND CONVERT(DATE,S.[更新日期]) <= @更新日期_E";
                            this.SetParameters(form, context.Request[form]);
                            break;
                        case "庫區":
                            sqlStr = sqlStr.Replace("{庫區}", context.Request[form]);
                            sqlStr += " AND S.庫區 = @庫區";
                            this.SetParameters(form, context.Request[form]);
                            break;
                        case "查詢出入庫":
                            if ("入庫".Equals(context.Request[form]))
                            {
                                sqlStr = sqlStr.Replace("{出入庫}", context.Request[form]);
                                sqlStr += " AND ISNULL(S.入庫數,0) <> 0";
                            }
                            else if ("出庫".Equals(context.Request[form]))
                            {
                                sqlStr = sqlStr.Replace("{出入庫}", context.Request[form]);
                                sqlStr += " AND ISNULL(S.出庫數,0) <> 0";
                            }
                            break;
                        default:
                            sqlStr += " AND ISNULL(S.[" + form + "],'') LIKE @" + form + " + '%'";
                            this.SetParameters(form, context.Request[form]);
                            break;
                    }
                }
            }

            if ("大貨".Equals(context.Request["庫區"]) && "出庫".Equals(context.Request["查詢出入庫"]))
            {
                sqlStr = sqlStr.Replace("{扣快取}", ",'Y' 扣快取");
            }
            else
            {
                sqlStr = sqlStr.Replace("{扣快取}", ",'N' 扣快取");
            }

            sqlStr += " ORDER BY S.頤坊型號, S.更新日期 ";

            dt = GetDataTableWithLog(sqlStr);
            return dt;
        }

        /// <summary>
        /// 樣品準備作業 查詢 Return DataTable
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        public DataTable SearchTableForSample()
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
                                      ,CAST(ISNULL((SELECT TOP 1 1 FROM [192.168.1.135].pic.dbo.xpic X WHERE X.[SUPLU_SEQ] = A.序號),0) AS BIT) [Has_IMG]
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

            if (sqlStr.IndexOf("{0}") != -1)
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

            dt = GetDataTableWithLog(sqlStr);
            return dt;
        }

        #endregion

        #region 新增區域
        /// <summary>
        /// Insert Stkio 
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        public int InsertStkio()
        {
            Stkio stkioModel = new Stkio();
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
                    columnVar.Append($" 'IVAN10',");
                }
                else if ("建立日期".Equals(property.Name) || "更新日期".Equals(property.Name))
                {
                    column.Append($" [{property.Name}],");
                    columnVar.Append($" GETDATE(),");
                }
                else if ("庫位".Equals(property.Name))
                {
                    //庫位空的抓DEFAULT
                    if (string.IsNullOrEmpty(context.Request[property.Name]))
                    {
                        column.Append($" [{property.Name}],");
                        columnVar.Append($" (SELECT "+ context.Request["庫區"] + "庫位 FROM suplu WHERE 序號 = @SUPLU_SEQ),");
                    }
                    else
                    {
                        column.Append($" [{property.Name}],");
                        columnVar.Append($" @{property.Name},");
                        SetParameters($"@{property.Name}", context.Request[property.Name]);
                    }
                }
                else
                {
                    if (string.IsNullOrEmpty(context.Request[property.Name]))
                        continue;

                    column.Append($" [{property.Name}],");
                    columnVar.Append($" @{property.Name},");
                    SetParameters($"@{property.Name}", context.Request[property.Name]);
                }
            }

            string sqlStr = string.Format($"INSERT INTO stkio ({column.ToString().TrimEnd(',')}) VALUES ({columnVar.ToString().TrimEnd(',')})");

            this.SetTran();
            int res = ExecuteWithLog(sqlStr);
            this.TranCommit();

            return res;
        }

        /// <summary>
        /// 多筆 Insert Stkio 
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        public int MutiInsertStkio()
        {
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
                                               ,@訂單號碼 [訂單號碼]
                                               ,@單據編號 [單據編號]
                                               ,NULL [異動日期]
                                               ,@帳項 [帳項]
                                               ,NULL [帳項原因]
                                               ,[廠商編號]
                                               ,[廠商簡稱]
                                               ,[頤坊型號]
                                               ,[暫時型號]
                                               ,[單位]
                                               ,@STOCK_POS [庫區]
                                               ,CASE WHEN @入出庫 = '入庫' THEN @STOCK_IO_CNT ELSE 0 END [入庫數]
                                               ,CASE WHEN @入出庫 = '出庫' THEN @STOCK_IO_CNT ELSE 0 END [出庫數]
                                               ,@STOCK_LOC [庫位]
                                               ,0 [核銷數]
                                               ,NULL [異動前庫存]
                                               ,@客戶編號 [客戶編號]
                                               ,@客戶簡稱 [客戶簡稱]
                                               ,NULL [完成品型號]
                                               ,@備註 [備註]
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
          
            string[] seqArray = context.Request["SEQ[]"].Split(',');
            string[] approveCntArr = context.Request["STOCK_IO_CNT[]"].Split(',');
            string[] stockLocArr = context.Request["STOCK_LOC[]"].Split(',');
            string[] stockPosArr = context.Request["STOCK_POS[]"].Split(',');

            int res = 0;
            this.SetTran();
            for (int cnt = 0; cnt < seqArray.Length; cnt++)
            {
                ClearParameter();
                this.SetParameters("SEQ", seqArray[cnt]);
                this.SetParameters("STOCK_IO_CNT", Convert.ToDecimal(approveCntArr[cnt]));
                this.SetParameters("STOCK_POS", stockPosArr[cnt]);
                this.SetParameters("STOCK_LOC", stockLocArr[cnt]);
                this.SetParameters("UPD_USER", "IVAN10");

                //一次性變數 不重複設
                foreach (string form in context.Request.Form)
                {
                    if (form != "Call_Type" && !form.Contains("[]"))
                    {
                        switch (form)
                        {
                            default:
                                this.SetParameters(form, context.Request[form]);
                                break;
                        }
                    }
                }

                res += Execute(sqlStr);
            }
            //Log一次寫
            this.TranCommitWithLog();

            return res;
        }

        #endregion

        #region 更新區域
        /// <summary>
        /// UPDATE Stkio 
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        public int UpdateStkio()
        {
            string sqlStr = @"      UPDATE [dbo].[stkio]
                                       SET 更新日期 = GETDATE()
										  ,更新人員 = @UPD_USER
                                    ";

            foreach (string form in context.Request.Form)
            {
                if (!string.IsNullOrEmpty(context.Request[form]) && form != "Call_Type" && form != "SEQ")
                {
                    switch (form)
                    {
                        default:
                            this.SetParameters(form, context.Request[form]); 
                            sqlStr += " ," + form + " = @" + form;
                            break;
                    }
                }
            }

            this.SetParameters("SEQ", context.Request["SEQ"]);
            sqlStr += " WHERE [序號] = @SEQ ";

            this.SetTran();
            this.SetParameters("UPD_USER", "IVAN10");
            int res = ExecuteWithLog(sqlStr);
            this.TranCommit();

            return res;
        }

        /// <summary>
        /// 核銷 Stkio 
        /// </summary>
        /// <returns></returns>
        public int ApproveStkio()
        {
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
											,NULL [備註]
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
									   ,更新日期 = GETDATE()
                                       ,更新人員 = @UPD_USER
                                    FROM SUPLU S
                                    JOIN stkio ST ON S.序號 = ST.SUPLU_SEQ
                                    WHERE ST.序號 = @SEQ

                                    ";

            string[] seqArray = context.Request["SEQ[]"].Split(',');
            string[] approveCntArr = context.Request["APPROVE_CNT[]"].Split(',');
            string[] stockPosArr = context.Request["STOCK_POS[]"].Split(',');
            string[] stockLocArr = context.Request["STOCK_LOC[]"].Split(',');
            string[] remarkArr = context.Request["REMARK[]"].Split(',');
            string[] quickTakeArr = context.Request["QUICK_TAKE[]"].Split(',');

            int res = 0;
            this.SetTran();
            for (int cnt = 0; cnt < seqArray.Length; cnt++)
            {
                this.ClearParameter();
                this.SetParameters("SEQ", seqArray[cnt]);
                this.SetParameters("APPROVE_CNT", Convert.ToDecimal(approveCntArr[cnt]));
                this.SetParameters("STOCK_LOC", stockLocArr[cnt]);
                this.SetParameters("REMARK", remarkArr[cnt]);
                this.SetParameters("QUICK_TAKE", quickTakeArr[cnt]);
                this.SetParameters("UPD_USER", "IVAN10");

                sqlStr = sqlStr.Replace("{庫區}", stockPosArr[cnt]);
                res += Execute(sqlStr);
            }
            this.TranCommitWithLog();

            return res;
        }

        #endregion

        #region 刪除區域
        /// <summary>
        /// 刪除RECU 單筆
        /// </summary>
        /// <returns></returns>
        public int DeleteStkio()
        {
            int res = 0;
            string sqlStr = @"      UPDATE stkio
                                    SET 已刪除 = 1
                                       ,更新日期 = GETDATE()
									   ,更新人員 = @UPD_USER
                                    WHERE [序號] = @SEQ
                                     ";

            this.SetParameters("SEQ", context.Request["SEQ"]);
            this.SetParameters("UPD_USER", "IVAN10");

            this.SetTran();
            res = ExecuteWithLog(sqlStr);
            this.TranCommit();
            return res;
        }
        #endregion
    }
}
