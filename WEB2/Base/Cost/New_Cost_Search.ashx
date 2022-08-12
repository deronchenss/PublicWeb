<%@ WebHandler Language="C#" Class="New_Cost_Search" %>

using System.Collections.Generic;
using System.Web;
using System.Web.SessionState;
using System.Data.SqlClient;
using System.Web.Configuration;
using System.Data;
using System.Configuration;
using System.Web.Script.Serialization;
using System.Text;
using System.IO;
using System.Web.UI.WebControls;
using CrystalDecisions.CrystalReports.Engine;
using Newtonsoft.Json;
using Ivan_Service;
using Ivan_Log;
using System.Drawing;
using System.Drawing.Imaging;

public class New_Cost_Search : IHttpHandler, IRequiresSessionState
{
    public void ProcessRequest(HttpContext context)
    {
        SqlConnection conn = new SqlConnection();
        DataTable dt = new DataTable();
        SqlCommand cmd = new SqlCommand();
        conn.ConnectionString = ConfigurationManager.ConnectionStrings["LocalBC2"].ConnectionString;
        try
        {
            switch (context.Request["Call_Type"])
            {
                case "Cost_Class_Search":
                    cmd.CommandText = @" SELECT TOP 500 
                                         	[頤坊型號], [廠商型號], [銷售型號], [廠商簡稱], [單位], [產品一階], [產品二階], [產品三階], [一階V3], [二階V3], [MSRP], [產品說明], 
                                         	'ORD' [最後接單], 
                                         --(SELECT Max(接單日期) From ORD A WHERE A.頤坊型號=T1.頤坊型號 AND A.廠商編號=T1.廠商編號 AND A.訂單數量>0) AS 最後接單,
                                         	[大貨庫存數], [分配庫存數], 
                                         	'PUD' 庫存在途, 
                                         --(SELECT Sum(採購數量-點收數量) From PUD A WHERE A.頤坊型號=T1.頤坊型號 AND A.廠商編號=T1.廠商編號 AND IsNull(A.採購單號,'')<>'' AND (A.採購數量-A.點收數量)>0 AND (A.訂單號碼 Like 'X%' Or A.訂單號碼 Like 'WR%') AND IsNull(A.已刪除,0)=0) AS 庫存在途,
                                         	[大貨安全數], [台北安全數], [ISP安全數], [UNActive], [國際條碼], [樣式], [大貨庫位], [廠商編號], 
                                            --[圖型啟用], 
                                            CAST(ISNULL((SELECT TOP 1 1 FROM [192.168.1.135].pic.dbo.xpic X WHERE X.[SUPLU_SEQ] = C.[序號]),0) AS BIT) [Has_IMG],
                                            [序號], [更新人員], LEFT(RTRIM(CONVERT(VARCHAR(20),[更新日期],20)),16) [更新日期], [更新日期] [Sort]
                                         FROM Dc2..suplu C
                                         WHERE C.[頤坊型號] LIKE @IM + '%'
                                            AND 
                                            (   
                                                (LEN(@PC) - LEN(REPLACE(@PC,'-',''))  = 1 AND @PC LIKE C.[產品一階] + '%' AND C.[產品一階] <> '')
                                             OR (LEN(@PC) - LEN(REPLACE(@PC,'-',''))  = 2 AND @PC LIKE C.[產品二階] + '%' AND C.[產品二階] <> '')
                                             OR (LEN(@PC) - LEN(REPLACE(@PC,'-',''))  = 3 AND @PC LIKE C.[產品三階] + '%' AND C.[產品三階] <> '')
                                             OR ISNULL(@PC,'') = ''
                                            )
                                            AND ((C.[更新日期] >= @Date_S AND C.[更新日期] <= DATEADD(DAY,+1,@Date_E)) OR (@Date_S ='' AND @Date_E = '' ))
                                            AND C.[廠商編號] LIKE @S_No + '%'
                                            AND C.[銷售型號] LIKE @SaleM + '%'
                                            AND C.[產品說明] LIKE '%' + @PI + '%'
		                                    AND (
			                                    (@BIgS = 'Y' AND ISNULL(C.[大貨庫存數],0) > 0)
			                                    OR (@BIgS = 'N' AND ISNULL(C.[大貨庫存數],0) = 0)
			                                    OR (@BIgS = 'ALL')
			                                    )
		                                    AND (
			                                    (@MSRP = 'Y' AND ISNULL(C.[MSRP],0) > 0)
			                                    OR (@MSRP = 'N' AND ISNULL(C.[MSRP],0) = 0)
			                                    OR (@MSRP = 'ALL')
			                                    )
		                                    AND (
			                                    (@PC_NEX = '1' AND ISNULL(C.[產品一階],'') = '')
			                                    OR (@PC_NEX = '2' AND ISNULL(C.[產品二階],'') = '')
			                                    OR (@PC_NEX = '3' AND ISNULL(C.[產品三階],'') = '')
                                                OR (@PC_NEX = 'ALL')
			                                    )
                                            AND (
                                                (@NO_L = 'True' AND ISNULL(C.[產品一階],'') <> '01') 
                                                 OR (@NO_L = 'False')
                                                )
                                         ORDER BY [Sort] desc ";
                    cmd.Parameters.AddWithValue("IM", context.Request["IM"]);
                    cmd.Parameters.AddWithValue("PC", context.Request["PC"]);
                    cmd.Parameters.AddWithValue("Date_S", context.Request["Date_S"]);
                    cmd.Parameters.AddWithValue("Date_E", context.Request["Date_E"]);
                    cmd.Parameters.AddWithValue("S_No", context.Request["S_No"]);
                    cmd.Parameters.AddWithValue("SaleM", context.Request["SaleM"]);
                    cmd.Parameters.AddWithValue("PI", context.Request["PI"]);
                    cmd.Parameters.AddWithValue("BigS", context.Request["BigS"]);
                    cmd.Parameters.AddWithValue("MSRP", context.Request["MSRP"]);
                    cmd.Parameters.AddWithValue("PC_NEX", context.Request["PC_NEX"]);
                    cmd.Parameters.AddWithValue("NO_L", context.Request["NO_L"]);
                    break;
                case "Fist_CAA_Approve_Search":
                    cmd.CommandText = @" SELECT TOP 500 [廠商簡稱], [頤坊型號], [產品說明], [單位], 
                                                '' [廠商確認], 
                                                '' [採購交期], 
                                                '' [採購單號], 
                                                [點收核准], [暫時型號], [廠商編號],
                                                CAST(ISNULL((SELECT TOP 1 1 FROM [192.168.1.135].pic.dbo.xpic X WHERE X.[SUPLU_SEQ] = C.[序號]),0) AS BIT) [Has_IMG], 
                                                [序號], [更新人員], LEFT(RTRIM(CONVERT(VARCHAR(20),[更新日期],20)),16) [更新日期], [更新日期] [Sort]
                                             FROM Dc2..suplu C
                                             WHERE ([點收核准] = 0 OR [點收核准] IS NULL)
                                                   AND [頤坊型號] LIKE @IM + '%'
                                                   AND [暫時型號] LIKE @SampleM + '%'
                                                   --AND [採購單號] LIKE @Purchase_No + '%'
                                                   AND [廠商編號] LIKE @S_No + '%'
                                                   AND [廠商簡稱] LIKE @S_SName + '%' 
                                             ORDER BY [Sort] desc ";
                    cmd.Parameters.AddWithValue("IM", context.Request["IM"]);
                    cmd.Parameters.AddWithValue("SampleM", context.Request["SampleM"]);
                    //Will_Add
                    //cmd.Parameters.AddWithValue("Purchase_No", context.Request["Purchase_No"]);
                    cmd.Parameters.AddWithValue("S_No", context.Request["S_No"]);
                    cmd.Parameters.AddWithValue("S_SName", context.Request["S_SName"]);
                    break;
                case "Cost_Report_C_Search":
                    cmd.CommandText = @" SELECT TOP 500 C.[開發中], C.[廠商簡稱], C.[頤坊型號], C.[銷售型號], C.[暫時型號], C.[產品說明], C.[單位], C.[產品狀態],
                                            IIF(C.[大貨庫存數] = 0, '', CONVERT(VARCHAR,CAST(C.[大貨庫存數] AS MONEY),1)) [大貨庫存數],
                                         	CONVERT(VARCHAR(20),C.[新增日期],23) [新增日期],
	                                        CAST(ISNULL((SELECT TOP 1 1 FROM [192.168.1.135].pic.dbo.xpic X WHERE X.[SUPLU_SEQ] = C.[序號]),0) AS BIT) [Has_IMG], 
                                         	CONVERT(VARCHAR(20),C.[最後點收日],23) [最後點收日],
                                         	CONVERT(VARCHAR(20),C.[最後單價日],23) [最後單價日],
                                         	C.[廠商編號], 'Cost' [來源], C.[序號], C.[更新人員],
                                         	LEFT(RTRIM(CONVERT(VARCHAR(20),C.[更新日期],20)),16) [更新日期], C.[更新日期] [sort]
                                         FROM Dc2..suplu C
                                         WHERE C.[頤坊型號] LIKE @IM + '%'
                                            AND C.[銷售型號] LIKE @SaleM + '%'
                                            AND C.[暫時型號] LIKE @SampleM + '%'
                                            AND C.[廠商編號] LIKE @S_No + '%'
                                            AND C.[廠商簡稱] LIKE @S_SName + '%'
                                            AND C.[產品說明] LIKE '%' + @PI + '%'
                                            AND C.[產品狀態] LIKE @PS + '%'
                                         ORDER BY [sort] DESC ";
                    cmd.Parameters.AddWithValue("IM", context.Request["IM"]);
                    cmd.Parameters.AddWithValue("SaleM", context.Request["SaleM"]);
                    cmd.Parameters.AddWithValue("SampleM", context.Request["SampleM"]);
                    cmd.Parameters.AddWithValue("S_No", context.Request["S_No"]);
                    cmd.Parameters.AddWithValue("S_SName", context.Request["S_SName"]);
                    cmd.Parameters.AddWithValue("PI", context.Request["PI"]);
                    cmd.Parameters.AddWithValue("PS", context.Request["PS"]);
                    break;
                case "Cost_Report_P_Search":
                    cmd.CommandText = @" SELECT TOP 500 P.[開發中], P.[客戶簡稱], P.[頤坊型號], P.[客戶型號], 
                                         	CAST(ISNULL((SELECT TOP 1 1 FROM [192.168.1.135].pic.dbo.xpic X WHERE X.[SUPLU_SEQ] = P.[SUPLU_SEQ]),0) AS BIT) [Has_IMG], 
                                         	C.[銷售型號], C.[產品狀態],
                                            P.[SUPLU_SEQ],
                                         	P.[產品說明], P.[單位], P.[廠商編號], P.[廠商簡稱], P.[客戶編號], 'Price' [來源], P.[序號], P.[更新人員], 
                                         	LEFT(RTRIM(CONVERT(VARCHAR(20),P.[更新日期],20)),16) [更新日期], P.[更新日期] [sort]
                                         FROM Dc2..byrlu P
                                            LEFT JOIN Dc2..suplu C ON C.[序號] = P.SUPLU_SEQ
                                         WHERE P.[頤坊型號] LIKE @IM + '%'
                                            AND C.[銷售型號] LIKE @SaleM + '%'
                                            AND P.[客戶編號] LIKE @C_No + '%'
                                            AND P.[客戶簡稱] LIKE @C_SName + '%'
                                            AND P.[產品說明] LIKE '%' + @PI + '%'
                                            AND C.[產品狀態] LIKE @PS + '%'
                                         ORDER BY [sort] DESC ";
                    cmd.Parameters.AddWithValue("IM", context.Request["IM"]);
                    cmd.Parameters.AddWithValue("SaleM", context.Request["SaleM"]);
                    cmd.Parameters.AddWithValue("C_No", context.Request["C_No"]);
                    cmd.Parameters.AddWithValue("C_SName", context.Request["C_SName"]);
                    cmd.Parameters.AddWithValue("PI", context.Request["PI"]);
                    cmd.Parameters.AddWithValue("PS", context.Request["PS"]);
                    break;
                case "Cost_Report_Print":
                    string RPT_File = "", SQL_Str = "";
                    var SP = 1;
                    switch (context.Request["Report_Type"])
                    {
                        case "V_BT_Report_1":
                            #region R1
                            RPT_File = "~/Base/Cost/Rpt/Cost_Report_R1.rpt";
                            SQL_Str = @" 
                        DECLARE @PUR_RATE DECIMAL(9,2) = (SELECT [內容] FROM Dc2..REFDATA WHERE [代碼] = 'PUR_Rate');
                        DECLARE @SUPLU_SEQ INT = '2990';--WD
                        --DECLARE @CB_MSRP bit = 1; --WD
                        --DECLARE @CB_Print_PW bit = 0; --WD'
                        --DECLARE @Session_Name NVARCHAR(20) = '柯君翰'; --WD'
                        
                        SELECT C.[序號], C.[廠商編號], C.[廠商簡稱], C.[頤坊型號], C.[廠商型號], C.[產品說明], C.[單位], C.[最後單價日], 
                        	CASE WHEN C.[台幣單價] > 0 THEN 'NTD'
                        		 WHEN C.[美元單價] > 0 THEN 'USD'
                        		 ELSE NULL END [幣別],
                        	0 [台幣金額],
                        	0 [美元金額],
                        	C.[廠商編號] [最後完成者], 
                        	NULL [材料型號],
                        	NULL [材料用量],
                        	(SELECT CASE WHEN (SELECT COUNT(1) FROM Dc2..bom BM WHERE BM.SUPLU_SEQ = C.[序號]) >= 1 THEN '組合品' ELSE '單一產品' END) [型態],
                        	'USDTWD: ' + (SELECT [內容] FROM Dc2..REFDATA WHERE [代碼] = 'PUR_Rate') [抬頭一], 
                        	C.[序號] [群組一],--SUPLU_SEQ
                        	C.[序號] [群組二],--PARENT?
                        	@Session_Name [印表人員],
                        	(SELECT [付款條件] FROM Dc2..sup S WHERE S.[廠商編號] = C.[廠商編號]) [付款條件],
                        	NULL [組合品],--原說明會+組，新bom結構不顯示
	                        CASE WHEN C.[台幣單價] > 0
	                        	 THEN 'NTD' + REPLICATE(' ',9 - LEN(CONVERT(VARCHAR,CAST(C.[台幣單價] AS MONEY),1))) + CONVERT(VARCHAR,CAST(C.[台幣單價] AS MONEY),1)
	                        	 WHEN C.[美元單價] > 0
	                        	 THEN 'USD' + REPLICATE(' ',9 - LEN(CONVERT(VARCHAR,CAST(C.[美元單價] AS MONEY),1))) + CONVERT(VARCHAR,CAST(C.[美元單價] AS MONEY),1)
	                        	 ELSE ''
	                        END +
	                        IIF(C.[min_1] = 0,'',REPLICATE(' ',9 - LEN(CONVERT(VARCHAR,CAST(C.[min_1] AS MONEY),1))) + CONVERT(VARCHAR,CAST(C.[min_1] AS MONEY),1)) + CHAR(10) + CHAR(13) +
	                        ISNULL(CONVERT(VARCHAR(20),CAST(C.[最後單價日] AS DATE),111),'') [COST],
                        	IIF(@CB_MSRP = 'True',
                        		'門市-USD : ' + REPLICATE(' ',3) + ISNULL(CAST(CAST(CAST(C.[台幣單價_1] AS DECIMAL(9,2)) / @PUR_RATE AS DECIMAL(9,2)) AS VARCHAR ) + '   NTD : ' + IIF(C.[台幣單價_1]=0,'',CAST(C.[台幣單價_1] AS VARCHAR)),'') + CHAR(10) + CHAR(13) +
                        		'MSRP-REP : ' + REPLICATE(' ',3) + ISNULL(CONVERT(VARCHAR,CAST(C.[MSRP] AS MONEY),1),'') + CHAR(10) + CHAR(13) +
                        		'MSRP-WHS : ' + REPLICATE(' ',3) + ISNULL(IIF(DE.[折扣率C3] <> 0,CONVERT(VARCHAR,CAST( ( CAST((100 - DE.[折扣率C3]) AS DECIMAL(9,2)) / 100 * C.[MSRP] + 0.01) AS MONEY),1) ,''),'') + CHAR(10) + CHAR(13) +
                        		'MSRP-BUS : ' + REPLICATE(' ',3) + ISNULL(IIF(DE.[折扣率C5] <> 0,CONVERT(VARCHAR,CAST( ( CAST((100 - DE.[折扣率C5]) AS DECIMAL(9,2)) / 100 * C.[MSRP] + 0.01) AS MONEY),1) ,''),'') + CHAR(10) + CHAR(13) +
                        		'MSRP-DIS : ' + REPLICATE(' ',3) + ISNULL(IIF(DE.[折扣率C6] <> 0,CONVERT(VARCHAR,CAST( ( CAST((100 - DE.[折扣率C6]) AS DECIMAL(9,2)) / 100 * C.[MSRP] + 0.01) AS MONEY),1) ,''),'') + CHAR(10) + CHAR(13) +
                        		'MSRP-M.D.: ' + REPLICATE(' ',3) + ISNULL(IIF(DE.[折扣率C7] <> 0,CONVERT(VARCHAR,CAST( ( CAST((100 - DE.[折扣率C7]) AS DECIMAL(9,2)) / 100 * C.[MSRP] + 0.01) AS MONEY),1) ,''),'') + CHAR(10) + CHAR(13) +
                        		ISNULL(REPLACE(
                        				(
                        					SELECT CONVERT(VARCHAR(7),CAST(T1.[最後單價日] AS DATE),120) + ' ' +
                        							T1.[客戶簡稱] +-- REPLICATE(' ',8 - LEN(T1.[客戶簡稱])) +
                        							REPLICATE(' ',8 - LEN(CONVERT(VARCHAR,CAST(T1.[美元單價] AS MONEY),1))) + CONVERT(VARCHAR,CAST(T1.[美元單價] AS MONEY),1) + 
                        							REPLICATE(' ',7 - LEN(IIF(T1.[min_1]=0,'',CAST(T1.[min_1] AS VARCHAR)))) + IIF(T1.[min_1]=0,'',CAST(T1.[min_1] AS VARCHAR)) + 
                        							+ '++BR++'
                        					FROM (
                        						SELECT TOP 5 A.[客戶簡稱], A.[美元單價], A.[min_1], A.[最後單價日]
                        						FROM Dc2..BYRLU A 
                        							INNER JOIN Dc2..BYR B ON A.[客戶編號] = B.[客戶編號] 
                        						WHERE A.[SUPLU_SEQ] = C.[序號]
                        							AND A.[美元單價] > 0 
                        							AND B.[停用日期] IS NULL 
                        							AND B.[最後交易日] IS NOT NULL
                        							AND A.[客戶編號] NOT LIKE '110%' 
                        							AND A.[客戶編號] LIKE '1%' 
                        						ORDER BY A.[最後單價日] DESC, A.[美元單價] DESC, A.[客戶簡稱]
                        					) T1
                        					ORDER BY T1.[美元單價] DESC, T1.[客戶簡稱]
                        					FOR XML PATH('')
                        				),'++BR++',CHAR(10) + CHAR(13))
                        			,''),'') [PRICE],
                        	NULL [MIDAS_UPRICE],--BOM
                        	NULL [MIDAS_AMT],--BOM
                        	IIF(@CB_Print_PW = 'True','Y','') [印價格填寫欄],
                        	ROW_NUMBER() OVER (PARTITION BY C.[序號] ORDER BY C.[序號]) [序],
                        	X.[圖檔] [圖檔], 
                        	IIF(X.SUPLU_SEQ IS NOT NULL,'Y','') [列印圖檔],
                        	0 [換算美元]--BOM
                        FROM Dc2..suplu C
                        	LEFT JOIN Dc2..DisCount_EAN DE ON DE.[價格等級] IS NOT NULL AND DE.[價格等級] = C.[價格等級]
                        	LEFT JOIN [192.168.1.135].pic.dbo.xpic X ON X.[SUPLU_SEQ] = C.[序號]
                        WHERE C.[序號] IN ({0})
                        UNION ALL
                        SELECT BDC.序號,
                        BDC.[廠商編號],
                        BDC.[廠商簡稱], BDC.[頤坊型號], C.[廠商型號], 
                        IIF(BD.[階層] > 2,' ','') + BDC.[產品說明] [產品說明], 
                        BDC.[單位], BDC.[最後單價日], 
                        	CASE WHEN BDC.[台幣單價] > 0 THEN 'NTD'
                        		 WHEN BDC.[美元單價] > 0 THEN 'USD'
                        		 ELSE NULL END [幣別],
                        	BDC.[台幣單價] * BD.[材料用量] [台幣金額],
                        	BDC.[美元單價] * BD.[材料用量] [美元金額],
                        --BD.序號,
                        --BD.[PARENT_SEQ],
                        --BD.[階層],
                        BD.[最後完成者], 
                        IIF(BD.[階層] > 2,' ','') + BD.[材料型號] [材料型號],
                        BD.[材料用量],
                        '材料' [型態],
                        	'USDTWD: ' + (SELECT [內容] FROM Dc2..REFDATA WHERE [代碼] = 'PUR_Rate') [抬頭一], 
                        	C.[序號] [群組一],--BomM
                        	C.[序號] [群組二],--最後完成者+頤坊型號
                        	@Session_Name [印表人員],
                        	(SELECT [付款條件] FROM Dc2..sup S WHERE S.[廠商編號] = BDC.[廠商編號]) [付款條件],
                        	NULL [組合品],--Exists bom 轉入單位 <> '*' > 組, Else ''
                        	CASE WHEN BDC.[台幣單價] > 0
                        		 THEN 'NTD' + 
                        		 REPLICATE(' ',9 - LEN(CONVERT(VARCHAR,CAST(BDC.[台幣單價] AS MONEY),1))) + CONVERT(VARCHAR,CAST(BDC.[台幣單價] AS MONEY),1) + 
                        		 REPLICATE(' ',9 - LEN(CONVERT(VARCHAR,CAST(CAST(BDC.[台幣單價] * BD.[材料用量] AS DECIMAL(9,2)) AS MONEY),1))) + CONVERT(VARCHAR,CAST(CAST(BDC.[台幣單價] * BD.[材料用量] AS DECIMAL(9,2)) AS MONEY),1)
                        	WHEN BDC.[美元單價] > 0
                        		 THEN 'USD' + 
                        		 REPLICATE(' ',9 - LEN(CONVERT(VARCHAR,CAST(BDC.[美元單價] AS MONEY),1))) + CONVERT(VARCHAR,CAST(BDC.[美元單價] AS MONEY),1) + 
                        		 REPLICATE(' ',9 - LEN(CONVERT(VARCHAR,CAST(CAST(BDC.[美元單價] * BD.[材料用量] AS DECIMAL(9,2)) AS MONEY),1))) + CONVERT(VARCHAR,CAST(CAST(BDC.[美元單價] * BD.[材料用量] AS DECIMAL(9,2)) AS MONEY),1)
                        	END [COST], 
                        	'' [PRICE],
                        	NULL [MIDAS_UPRICE],--BOM
                        	NULL [MIDAS_AMT],--BOM
                        	IIF(@CB_Print_PW = 'True','Y','') [印價格填寫欄],
                        	ROW_NUMBER() OVER (ORDER BY BD.[PARENT_SEQ], BD.[階層], BD.[材料型號]) [序],
                        	NULL [圖檔], 
                        	'' [列印圖檔],
                        	BDC.[台幣單價] * BD.[材料用量] / @PUR_RATE + BDC.[美元單價] * BD.[材料用量] [換算美元]
                        	--** 轉入單位=S時為原料銷售 > 金額相關、Cost =0
                        FROM Dc2..suplu C
                        	LEFT JOIN Dc2..DisCount_EAN DE ON DE.[價格等級] IS NOT NULL AND DE.[價格等級] = C.[價格等級]
                        	--LEFT JOIN Dc2..bom BM ON BM.[SUPLU_SEQ] = C.[序號]
                        	INNER JOIN Dc2..bomsub BD ON BD.[SUPLU_SEQ] = C.[序號] AND BD.[不計成本] = 0 AND BD.[不展開] = 0 AND BD.[不發單] = 0 AND BD.[原料銷售] = 0
                        	LEFT JOIN Dc2..suplu BDC ON BDC.[序號] = BD.[D_SUPLU_SEQ]
                        WHERE C.[序號] IN ({0}) ";
                            cmd.Parameters.AddWithValue("CB_MSRP", context.Request["CB_MSRP"]);
                            cmd.Parameters.AddWithValue("CB_Print_PW", context.Request["CB_Print_PW"]);
                            cmd.Parameters.AddWithValue("Session_Name", context.Request["Session_Name"]);
                            #endregion
                            break;
                        case "V_BT_Report_2":
                            SQL_Str = @"
                                --DECLARE @Session_Name NVARCHAR(20) = 'AAA'
                                DECLARE @Column NVARCHAR(MAX);
                                SELECT C.[廠商編號], C.[廠商簡稱], C.[頤坊型號], C.[銷售型號] [內銷型號], C.[產品說明], C.[單位], C.[廠商型號], C.[暫時型號], C.[台幣單價], C.[美元單價], 0.00 [人民幣單價],
	                                ROW_NUMBER() OVER (ORDER BY C.[序號]) [新序號],
	                                @Session_Name [印表人員],
	                                IIF(@R2_V_PI = 'True', ISNULL(C.[產品說明],'') + CHAR(10) + CHAR(13),'') +
	                                IIF(@R2_V_S_No = 'True', '廠商編號 : ' + ISNULL(C.[廠商編號] + '  ' + C.[廠商簡稱],'') + CHAR(10) + CHAR(13),'') +
	                                IIF(@R2_V_SaleM = 'True', '銷售型號 : ' + ISNULL(C.[銷售型號],'') + CHAR(10) + CHAR(13),'') +
	                                IIF(@R2_V_SupM = 'True', '廠商型號 : ' + ISNULL(C.[廠商型號],'') + CHAR(10) + CHAR(13),'') +
	                                IIF(@R2_V_SampleM = 'True','暫時型號 : ' + ISNULL(C.[暫時型號],'') + CHAR(10) + CHAR(13),'') +
                                    IIF(@R2_V_UP = 'True','單價     : ' + ISNULL(C.[單位],'') + ISNULL(CASE WHEN C.[台幣單價] > 0 THEN ' NTD ' + CONVERT(VARCHAR,CAST(C.[台幣單價] AS MONEY),1) 
                                                                                                           WHEN C.[美元單價] > 0 THEN ' USD ' + CONVERT(VARCHAR,CAST(C.[美元單價] AS MONEY),1) 
                                                                                                           ELSE '' END,'') + CHAR(10) + CHAR(13),
                                                          IIF(@R2_V_Unit = 'True','單位      : ' + ISNULL(C.[單位],'') + CHAR(10) + CHAR(13),'')) +
	                                IIF(@R2_V_UW = 'True' AND C.[單位淨重] > 0, '單位淨重 : ' + ISNULL(CAST(C.[單位淨重] AS VARCHAR),'') + ' g' + CHAR(10) + CHAR(13),'') +
	                                IIF(@R2_V_BS = 'True' AND C.[大貨庫存數] > 0, '大貨庫存 : ' + ISNULL(CAST(C.[大貨庫存數] AS VARCHAR),'') + '  庫位: ' + C.[大貨庫位] + CHAR(10) + CHAR(13),'') +
	                                IIF(@R2_V_BS = 'True' AND C.[分配庫存數] > 0, '分配 : ' + ISNULL(CAST(C.[分配庫存數] AS VARCHAR),'') + CHAR(10) + CHAR(13),'') [列印匯總],
	                                '' [群組一],
	                                ISNULL((SELECT X.[圖檔] FROM [192.168.1.135].pic.dbo.xpic X WHERE X.[SUPLU_SEQ] = C.[序號]),'') [圖檔],
	                                'Y' [列印圖檔],
	                                NULL [圖檔路徑]
                                FROM Dc2..suplu C
	                                LEFT JOIN [192.168.1.135].pic.dbo.xpic X ON X.[SUPLU_SEQ] = C.[序號]
                                WHERE C.[序號] IN ({0}) 
                                ORDER BY C.[頤坊型號], C.[廠商編號] ";
                            cmd.Parameters.AddWithValue("Session_Name", context.Request["Session_Name"]);
                            cmd.Parameters.AddWithValue("R2_V_PI", context.Request["R2_V_PI"]);
                            cmd.Parameters.AddWithValue("R2_V_S_No", context.Request["R2_V_S_No"]);
                            cmd.Parameters.AddWithValue("R2_V_SaleM", context.Request["R2_V_SaleM"]);
                            cmd.Parameters.AddWithValue("R2_V_SupM", context.Request["R2_V_SupM"]);
                            cmd.Parameters.AddWithValue("R2_V_SampleM", context.Request["R2_V_SampleM"]);
                            cmd.Parameters.AddWithValue("R2_V_UP", context.Request["R2_V_UP"]);
                            cmd.Parameters.AddWithValue("R2_V_Unit", context.Request["R2_V_Unit"]);
                            cmd.Parameters.AddWithValue("R2_V_UW", context.Request["R2_V_Unit"]);
                            cmd.Parameters.AddWithValue("R2_V_BS", context.Request["R2_V_BS"]);

                            switch (context.Request["R2_Type"])
                            {
                                case "R2_RB_Report_TypeC":
                                    RPT_File = "~/Base/Cost/Rpt/Cost_Report_R2_C.rpt";
                                    SP = 7;
                                    break;
                                case "R2_RB_Report_TypeD":
                                    RPT_File = "~/Base/Cost/Rpt/Cost_Report_R2_D.rpt";
                                    SP = 2;
                                    break;
                            }
                            break;
                        case "V_BT_Report_3":
                            SQL_Str = @"
                                SELECT 
                                	P.[客戶編號], P.[客戶簡稱], P.[客戶型號], P.[廠商編號], P.[廠商簡稱], P.[頤坊型號], P.[產品說明],
                                	P.[單位], P.[台幣單價], P.[美元單價], 0.00 [歐元單價],
                                	ROW_NUMBER() OVER (ORDER BY P.[序號]) [新序號],
	                                @Session_Name [印表人員], 
                                    IIF(@R3_RSC_CB_S_PI = 'True', ISNULL(P.[產品說明],'') + CHAR(10) + CHAR(13),'') +
	                                IIF(@R3_RSC_CB_CustM = 'True', 'CUS-NO : ' + ISNULL(P.[客戶型號],'') + CHAR(10) + CHAR(13),'') +
	                                IIF(@R3_RSC_CB_SaleM = 'True', 'Sale-NO : ' + ISNULL(C.[銷售型號],'') + CHAR(10) + CHAR(13),'') +
	                                IIF(@R3_RSC_CB_S_No = 'True', 'SUP-NO : ' + ISNULL(P.[廠商編號],'') + '  ' + P.[廠商簡稱] + CHAR(10) + CHAR(13),'') +
                                    IIF(@R3_RSC_CB_UP = 'True','Price  : ' + ISNULL(P.[單位],'') + ISNULL(CASE WHEN P.[台幣單價] > 0 THEN CONVERT(VARCHAR,CAST(P.[台幣單價] AS MONEY),1) 
                                                                                                               WHEN P.[美元單價] > 0 THEN CONVERT(VARCHAR,CAST(P.[美元單價] AS MONEY),1) 
                                                                                                               ELSE '' END,'') + CHAR(10) + CHAR(13),'') +
                                	IIF(@R3_RSC_CB_BS = 'True' AND C.[大貨庫存數] > 0, '大貨庫存 : ' + ISNULL(CAST(C.[大貨庫存數] AS VARCHAR),'') + '  庫位: ' + C.[大貨庫位] + CHAR(10) + CHAR(13),'') +
                                	IIF(@R3_RSC_CB_BS = 'True' AND C.[分配庫存數] > 0, '分配 : ' + ISNULL(CAST(C.[分配庫存數] AS VARCHAR),'') + CHAR(10) + CHAR(13),'') [列印匯總], 
	                                ISNULL((SELECT X.[圖檔] FROM [192.168.1.135].pic.dbo.xpic X WHERE X.[SUPLU_SEQ] = C.[序號]),'') [圖檔],
                                	'Y' [列印圖檔],
                                	NULL [圖檔路徑]
                                FROM Dc2..Byrlu P
                                    INNER JOIN Dc2..Suplu C ON C.[序號] = P.SUPLU_SEQ
                                WHERE P.[序號] IN ({0}) ";
                            cmd.Parameters.AddWithValue("Session_Name", context.Request["Session_Name"]);
                            cmd.Parameters.AddWithValue("R3_RSC_CB_S_PI", context.Request["R3_RSC_CB_S_PI"]);
                            cmd.Parameters.AddWithValue("R3_RSC_CB_S_No", context.Request["R3_RSC_CB_S_No"]);
                            cmd.Parameters.AddWithValue("R3_RSC_CB_CustM", context.Request["R3_RSC_CB_CustM"]);
                            cmd.Parameters.AddWithValue("R3_RSC_CB_SaleM", context.Request["R3_RSC_CB_SaleM"]);
                            cmd.Parameters.AddWithValue("R3_RSC_CB_BS", context.Request["R3_RSC_CB_BS"]);
                            cmd.Parameters.AddWithValue("R3_RSC_CB_UP", context.Request["R3_RSC_CB_UP"]);
                                
                            switch (context.Request["R3_Type"])
                            {
                                case "R3_RB_Report_TypeC":
                                    RPT_File = "~/Base/Cost/Rpt/Cost_Report_R3_2C.rpt";
                                    SP = 7;
                                    break;
                                case "R3_RB_Report_TypeD":
                                    RPT_File = "~/Base/Cost/Rpt/Cost_Report_R3_2D.rpt";
                                    SP = 2;
                                    break;
                            }
                            break;
                    }

                    string[] SEQ_A = context.Request["SEQ_Array"].ToString().Split(',');
                    string New_IN_Filter = "@SEQ";
                    cmd.Parameters.AddWithValue("SEQ", SEQ_A[0].ToString()); ;
                    for (int i = 1; i < SEQ_A.Length; i++)
                    {
                        New_IN_Filter += ",@SEQ" + i;
                        cmd.Parameters.AddWithValue("SEQ" + i, SEQ_A[i].ToString());
                    }

                    SQL_Str = string.Format(SQL_Str, New_IN_Filter);
                    cmd.CommandText = SQL_Str;

                    SqlDataAdapter sqlDatai = new SqlDataAdapter(cmd);

                    cmd.Connection = conn;
                    sqlDatai.Fill(dt);

                    if (dt != null && dt.Rows.Count > 0)
                    {
                        for (int i = 0; i < dt.Rows.Count; i++)
                        {
                            if (dt.Rows[i]["圖檔"] != System.DBNull.Value && SP > 1)
                            {
                                System.Drawing.Image oImage = System.Drawing.Image.FromStream(new MemoryStream((byte[])dt.Rows[i]["圖檔"]));

                                var X = oImage.Width;
                                var Y = oImage.Height;
                                var BB = Y / X * SP + 1;//倍率
                                var W = 0;
                                var H = 0;
                                if (BB > 1)
                                {
                                    W = X * BB;
                                    H = Y;
                                }
                                else
                                {
                                    W = X;
                                    H = Y / BB;
                                }
                                W = (H + 12) * SP;
                                Bitmap BF = new Bitmap(W, H);
                                var G = Graphics.FromImage(BF);
                                G.Clear(Color.White);
                                G.DrawImage(oImage, (W - X) / 2, (H - Y) / 2, oImage.Width, oImage.Height);
                                G.Dispose();
                                MemoryStream NMS = new MemoryStream();
                                BF.Save(NMS, ImageFormat.Jpeg);
                                byte[] buffer = new byte[NMS.Length];
                                NMS.Seek(0, SeekOrigin.Begin);
                                NMS.Read(buffer, 0, buffer.Length);
                                dt.Rows[i]["圖檔"] = buffer;
                            }
                        }
                        ReportDocument rptDoc = new ReportDocument();
                        rptDoc.Load(context.Server.MapPath(RPT_File));
                        rptDoc.SetDataSource(dt);
                        System.IO.Stream stream = rptDoc.ExportToStream(CrystalDecisions.Shared.ExportFormatType.PortableDocFormat);
                        byte[] bytes = new byte[stream.Length];
                        stream.Read(bytes, 0, bytes.Length);
                        stream.Seek(0, System.IO.SeekOrigin.Begin);

                        string filename = "T.pdf";
                        context.Response.ClearContent();
                        context.Response.ClearHeaders();
                        context.Response.AddHeader("content-disposition", "attachment;filename=" + filename);
                        context.Response.ContentType = "application/pdf";
                        context.Response.OutputStream.Write(bytes, 0, bytes.Length);
                        context.Response.Flush();
                        context.Response.End();
                    }
                    else
                    {
                        context.Response.StatusCode = 204;
                        context.Response.End();
                    }
                    break;
            }
            cmd.Connection = conn;
            conn.Open();
            SqlDataAdapter SDA = new SqlDataAdapter(cmd);
            SDA.Fill(dt);
            conn.Close();
            var json = JsonConvert.SerializeObject(dt);
            Log.InsertLog(context, context.Session["Account"], cmd.CommandText);
            context.Response.ContentType = "text/json";
            context.Response.Write(json);
        }

        catch (SqlException ex)
        {
            Log.InsertLog(context, context.Session["Account"], cmd.CommandText ?? "", ex.ToString(), false);
            context.Response.StatusCode = 404;
            context.Response.Write(ex.Message);
        }
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}