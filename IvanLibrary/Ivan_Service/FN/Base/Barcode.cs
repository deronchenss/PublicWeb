using Ivan_Dal;
using System.Data;
using System.Web;

namespace Ivan_Service.FN.Base
{
    public class Barcode : DataOperator
    {
        DataTable dt = new DataTable();
        string SQL_STR = "";

        #region Barcode_Print
        public DataTable Barcode_Print_Search(DataTable Request_DT)
        {
            SQL_STR = @" 
                SELECT TOP 500 [樣式], [廠商簡稱], [頤坊型號], [銷售型號], [簡短說明], [英文單位],
                	2 [數量], [寄送袋子], [寄送吊卡], [產地], [條碼印價], [台幣單價_1], [自有條碼], [廠商編號], 
                	[頤坊條碼], [國際條碼], [CP65], [年齡], [序號], [更新人員], [條碼英文一], [條碼英文二], [英文ISP],
                	--'NONE'+SPACE(11) [單據編號],--WD
                	'NONE'+SPACE(16) [訂單號碼],
                    (SELECT TOP 1 1 FROM [192.168.1.135].pic.dbo.xpic X WHERE X.[SUPLU_SEQ] = C.[序號]) [Has_IMG],
                    LEFT(RTRIM(CONVERT(VARCHAR(20),[更新日期],20)),16) [更新日期],
                    C.[更新日期] [sort]
                    --WD:[皮革材數]
                FROM Dc2..suplu C
                WHERE C.[頤坊型號] LIKE @頤坊型號 + '%'
                    AND C.[廠商編號] LIKE @廠商編號 + '%'
                    AND C.[廠商簡稱] LIKE '%' + @廠商簡稱 + '%'
                    AND ( (@條碼樣式 <> '' AND C.[樣式] = @條碼樣式) OR (@條碼樣式 = '' AND ISNULL(C.[樣式],'') <> '') )
                    --AND [訂單號碼] LIKE @訂單號碼 + '%'
                    AND C.[銷售型號] LIKE @銷售型號 + '%'
                ORDER BY [sort] DESC ";
            this.ClearParameter();
            for (int i = 0; i < Request_DT.Columns.Count; i++)
            {
                this.SetParameters(Request_DT.Columns[i].ColumnName, Request_DT.Rows[0][i]);
            }
            dt = GetDataTable(SQL_STR);
            return dt;
        }

        #endregion
    }

}
