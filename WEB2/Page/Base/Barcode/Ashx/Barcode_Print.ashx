<%@ WebHandler Language="C#" Class="Barcode_Print" %>

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
using Newtonsoft.Json;
using Ivan_Service.FN.Base;
using Ivan_Log;
using System.Threading;
using System.Globalization;


public class Barcode_Print : IHttpHandler, IRequiresSessionState
{
    public void ProcessRequest(HttpContext context)
    {
        if (!string.IsNullOrEmpty(context.Request["Call_Type"]))
        {
            DataTable dt = new DataTable();
            var Barcode = new Barcode();
            try
            {
                string Print_File_Path = "";
                switch (context.Request["Call_Type"])
                {
                    case "Barcode_Print_Search":
                        dt = Barcode.Barcode_Print_Search(JsonConvert.DeserializeObject<DataTable>(context.Request["Search_Data"]));
                        Log.InsertLog(context, context.Session["Name"], Barcode._sqlLogModel);
                        break;
                    case "Barcode_Print":
                        var Server_Path = @"D:\OneDrive\WEB2\WEB2\Page\Base\Barcode\Lpr\";//上線須改
                        System.Diagnostics.Process Info = new System.Diagnostics.Process();
                        Info.StartInfo.FileName = Server_Path + @"\LPR.exe";  //要啟動的應用程式
                        dt = JsonConvert.DeserializeObject<DataTable>(context.Request["Exec_Data"]);

                        if (context.Request["Check_Print"] == "1")
                        {
                            string Check_Txt_Path = Server_Path + @"\Check_Paper\TestPaper.txt";
                            /*
                                var MyDirectoryInfo = new DirectoryInfo(Server_Path + @"\Check_Paper\");
                                if (!MyDirectoryInfo.Exists)
                                {
                                    MyDirectoryInfo.Create();
                                }
                                else
                                {
                                    context.Response.Write(MyDirectoryInfo.FullName);
                                }
                            */
                            System.IO.File.WriteAllText(Check_Txt_Path, context.Request["Check_Print_Command"], System.Text.Encoding.GetEncoding("big5"));
                            Info.StartInfo.Arguments = @"-S " + context.Request["Print_Destination"] + @" -P T " + Check_Txt_Path;
                        }
                        else
                        {
                            string BR = System.Environment.NewLine;
                            string Print_Head = "^XA" + BR
                                    + "~CC!" + BR
                                    + "~CT&" + BR
                                    + "^XZ" + BR + BR
                                    + "!XA" + BR
                                    + "!PR" + context.Request["Print_Speed"] + BR
                                    + "!MD" + context.Request["Print_Chroma"] + BR
                                    + "!LH0,0^FS" + BR
                                    + "!LL{0}^FS" + BR
                                    + "!MNY" + BR
                                    + "!PW600^FS" + BR
                                    + "!SEE:CP950.DAT^FS" + BR
                                    + "!CWJ,B:KAIU.TTF^FS" + BR
                                    + "!CWK,B:MSJH.TTF!FS" + BR
                                    + "!CI26" + BR;
                            string Print_Footer = BR + "!XA" +BR
                                    + "!IDR:ID*.*" + BR
                                    + "!XZ" + BR + BR
                                    + "!XA" + BR
                                    + "&CC^" + BR
                                    + "&CT~" + BR
                                    + "!XZ" + BR;

                            Print_File_Path = Server_Path + @"\Print\" + context.Request["Print_Type"].ToString() + "_" + System.DateTime.Now.ToString("yyyyMMdd_HHmmss") + ".txt";
                            string Print_Context = "", Print_Detail = "";
                            int Print_Amount;
                            switch (context.Request["Print_Type"])
                            {
                                case "IV01":
                                    //Alert 1 :銷售型號不能有[A-Z]
                                    //Alert 2 :產地要存在
                                    //Alert 3 :產品說明>36字
                                    //Alert 4 :沒有單價
                                    //博客來Replace("-","") FN待確認
                                    //"^MMC" '裁切
                                    //"^MMT" '正常不用裁刀
                                    Print_Head = string.Format(Print_Head, "224");//28mm*8
                                    for (int i = 0; i < dt.Rows.Count; i++)
                                    {
                                        Print_Amount = int.Parse(dt.Rows[i]["列印數量"].ToString()) / 2;
                                        string P_EN1 = dt.Rows[i]["EN1"].ToString(), P_EN2 = dt.Rows[i]["EN2"].ToString(), P_EN3 = "";
                                        if (P_EN1.Length + P_EN2.Length == 0 || dt.Rows[i]["ENA"].ToString().Length > 0)
                                        {
                                            string ENA = dt.Rows[i]["ENA"].ToString();
                                            if (ENA.Length > 54)
                                            {
                                                int NL = ENA.LastIndexOf(" ", 27);
                                                P_EN1 = ENA.Substring(0, NL);
                                                ENA = ENA.Substring(NL, ENA.Length);//去第一行
                                                int NL2 = ENA.LastIndexOf(" ", 27);
                                                P_EN2 = ENA.Substring(0, NL2);
                                                P_EN3 = ENA.Substring(NL2 + 1, ENA.Length - NL2 - 1);
                                            }
                                            else if (ENA.Length > 27)
                                            {
                                                int NL = ENA.LastIndexOf(" ", 27);
                                                P_EN1 = ENA.Substring(0, NL);
                                                P_EN2 = ENA.Substring(NL + 1, ENA.Length - NL - 1);
                                            }
                                            else
                                            {
                                                P_EN1 = ENA;
                                            }
                                        }
                                        Print_Detail = "^FO {0},10^AKN,16,16^FD" + dt.Rows[i]["簡短說明"].ToString() + "^FS" + BR
                                                + "^FO {0},27^AKN,16,16^FD" + P_EN1 + "^FS" + BR
                                                + "^FO {0},42^AKN,16,16^FD" + P_EN2 + "^FS" + BR
                                                + "^FO {0},57^AKN,16,16^FD" + P_EN3 + "^FS" + BR
                                                + "^FO {0},77^AKN,22,22^FD" + dt.Rows[i]["銷售型號"].ToString() + "^FS" + BR
                                                + "^FO {4},77^AKN,18,18^FD" + (bool.Parse(dt.Rows[i]["條碼印價"].ToString()) ? "$" + dt.Rows[i]["台幣單價"].ToString() : "") + "^FS" + BR
                                                + "^FO {1},125^AKN,16,16^FD" + dt.Rows[i]["單位"].ToString() + "^FS" + BR
                                                + "^FO {2},98^BY2^" + ((dt.Rows[i]["國際條碼"].ToString().Length > 0) ? "BEN,70,Y,N^FD" + dt.Rows[i]["國際條碼"].ToString():"BCN,70,Y,N,N^FD") + dt.Rows[i]["頤坊條碼"].ToString()  + "^FS" + BR
                                                + "^FO {0},193^AKN,20,20^FD" + "MADE IN " + dt.Rows[i]["產地"].ToString() + "^FS" + BR
                                                + "^FO {3},193^AKN,20,20^FD^FS";
                                        Print_Context += BR + "^XA" + BR
                                                + string.Format(Print_Detail, "20", "10", "40", "170", "200")
                                                + string.Format(Print_Detail, "324", "314", "344", "474", "504")
                                                + "^PQ" + Print_Amount.ToString() + ",0,0,N" + BR
                                                + "^XZ" + BR;
                                    }
                                    break;
                                case "IV05":
                                    Print_Head = string.Format(Print_Head, "160");//20mm*8

                                    for (int i = 0; i < dt.Rows.Count; i++)
                                    {
                                        Print_Amount = int.Parse(dt.Rows[i]["列印數量"].ToString()) / 2;
                                        string P_EN1 = dt.Rows[i]["EN1"].ToString(), P_EN2 = dt.Rows[i]["EN2"].ToString(), P_EN3 = "";

                                        if (P_EN1.Length + P_EN2.Length == 0 || dt.Rows[i]["ENA"].ToString().Length > 0)
                                        {
                                            string ENA = dt.Rows[i]["ENA"].ToString();
                                            if (ENA.Length > 50)
                                            {
                                                int NL = ENA.LastIndexOf(" ", 25);
                                                P_EN1 = ENA.Substring(0, NL);
                                                ENA = ENA.Substring(NL, ENA.Length);//去第一行
                                                int NL2 = ENA.LastIndexOf(" ", 25);
                                                P_EN2 = ENA.Substring(0, NL2);
                                                P_EN3 = ENA.Substring(NL2 + 1, ENA.Length - NL2 - 1);
                                            }
                                            else if (ENA.Length > 25)
                                            {
                                                int NL = ENA.LastIndexOf(" ", 25);
                                                P_EN1 = ENA.Substring(0, NL);
                                                P_EN2 = ENA.Substring(NL + 1, ENA.Length - NL - 1);
                                            }
                                            else
                                            {
                                                P_EN1 = ENA;
                                            }
                                        }
                                        Print_Detail = "^FO {0},20^AKN,28,28^FD" + dt.Rows[i]["銷售型號"].ToString() + "^FS" + BR
                                                + "^FO {0},50^AKN,14,14^FD" + P_EN1 + "^FS" + BR
                                                + "^FO {0},70^AKN,14,14^FD" + P_EN2 + "^FS" + BR
                                                + "^FO {0},90^AKN,14,14^FD" + P_EN3 + "^FS" + BR
                                                + "^FO {0},110^AKN,20,20^FD" + (dt.Rows[i]["銷售型號"].ToString() != dt.Rows[i]["頤坊型號"].ToString() ? "# "+ dt.Rows[i]["頤坊型號"].ToString():"") + "^FS" + BR
                                                + "^FO {1},115^AKN,20,20^FD" + dt.Rows[i]["單位"].ToString() + "^FS";
                                        Print_Context += BR + "^XA" + BR
                                                + string.Format(Print_Detail, "20", "230")
                                                + string.Format(Print_Detail, "304", "514")
                                                + "^PQ" + Print_Amount.ToString() + ",0,0,N" + BR
                                                + "^XZ" + BR;
                                    }
                                    break;
                                case "IV06":
                                    Print_Head = string.Format(Print_Head, "320");//40mm*8
                                    //'W11-IVAN大
                                    string mLogoW1 = "80^GFA,02048,02048,00032,:Z64:" + BR
                                            + "eJzt1MFL21AcB/Df6+uS4h5xl42MvTYdwrxWOmZEp9lxt/0JkYC9yJauoLKJvhJWy6iDgQMPYQq7eVLGoEwPr2TUy+auu2xLKdiLbIKgHTi7pNpaC9Y/YP4Ojwef/Hgv7/sSgMu6rE6FLnDRvcB3O3sk1tmp2tllubOrFCAIoWhXAEIaEIDls25KAIQSVbGsnGnWQKyedd1zKSJPDTpp24wdsKv5s+6KAEJEnZYrTq4a5yCF2hx7Z3BPHZfLpdx0j7cWRLOh02dQwWKA+2NbqjO68DjF6F1UPRyenmk4Thc44JReVJyBXCJ+RZbRwM7EWNMDdTeSRcW6ZRtxMSsDzbgVs+Ei4i6gUql205nPGe9fMAr3i1ot2uJ63eVyt13asxhF3165erNfQtz0NungfEUkeqmQlcLzn9yC3nAC3AuIO+nFFLZds0bFP98zz2aa/bTuzEKLcZzTY7Myrh4WI8PN9VWk0XOSO3HW0WPAhU5uItbwZeE6XIu2OQcmnkyPupS86t1GsYWRe+o1oshT3ou1roc4cMyO586QTH0PtDoDhngooCGIOjGZjI8GgxoEXsIDLznQwO9FnBhG2OabQ5SMbxZ/V2aVn2jPVb7a+vFeXFKOr8v8aFaRtr5Ufk08X1/DH8xB+pn7e+GgC/uTaz/40STOFHlC6L39ekOEaF9+x7uN/g5NYb9/9S/nRnpus7AtJZJrbwW027f6hHvxeD4lbtDdA+AGmrMy2+RpcknEeFVRi8xzYKBim7qJLE+9syxpLNjbY2NRSNJYmUH946OYEN2gfHjEwpl9aTK5OJI8SC2ELS8+3wkKEW2U8EgEIXGC3Ikt3UimPi51W358fr/3j9FaQwn7J9rvD8f97aH2cT9Zf1BqXlXbfcCnODvXu/1B8Yfgysqbh4/a/f+pfyda778=:5F72";
                                    //'W12-IVAN大
                                    string mLogoW2 = "63^GFA,03072,03072,00032,:Z64:" + BR
                                            + "eJzt089rE2kYB/Dn7VsyCtNJvL3BMQ0Ie1udtAffmDizu4f9G/YizBhILiojASu0tm8MpAfb6sGDQsHjInhYT9tll3XiQAJuafaYQksnBhOEmsZTIw2JM/lRU6epXoV8IS/DfN6fz5sBGGWUUb6X+I59SwjVlUVMLLV1rItRoit5TOta+1jno3pDyqfJ/7F7LuMMAGFOKobyJmkk3GO9FoDnB22L5sp0Kw70Sw+otle1JSWTJBsJkFx71+014qWlycUIrca9rgNSe0ZcNlvhTISYCa9r/Y6bZi2U85JSmXO5KgKgVJqjVS/Jlk3X/HXe8QyWKhy1Sm3X/i3B8UVMb+PHhjrv2r/hXnIwOPU1T7MTHWdPdA6njM4d2F3tjlK3IJ8jIGZ73XlEXZfIEcfMAr5zqjEG43Z5yJHxImK67UEf+E4zZNfKHh8c+BsS7Lj+obHVVMKFnf1wnZIPL2eNvlPEKHjLm1tztciLle3ps0Xl3drBjtV3HTECXtO/8jYTCxf56Smf0vBnl9QBF4EvNXPaovZilb9VbUi0afKHbiEmAJ98ljHM2JkiH6oWCdlMLX3h06mclk/+scpLb4D6xeyjvqOfEONACBebxm4ksrJRN9ek8N/pw/mdmnHAk48NdW7yaT4vZS3q3zVX+44ZYk7dnX5OCV3X05uj56503Oj+josACJA1fDwP2ACru9VmQJF0+2vyDLjouN71FlHoHfWoE3v+3jeJMlQidevo/PSwAZTXJVp8BWj8FIw7L5ymM5SQXFkhRkaPituF5Z1ca/JfXDWUpyHWdVGsJKbD2dZ8YGL9v8JGZWZ2itu3Ls3+1XM6UbM91ahdnHjwcOO3Wjqme0CNaU8YyNt/vr9RnHh+pbSHDBN7l9Ov+Xj8fNSDrKRaYKC02wvtBvfPj6U9YAnMccI6uV6WA4LHkkP37fruHbRbFrcWtapnjIrt/LoYj8meXz3XRK3QP+UYIUYuzOYXOO7cOn/z9+CFxN1kMJLpOyY+9ovfuCyPjQm7pBKTZa1akQODheyWpJcICzJYGHJldkoO/TzcLznNzFCGq04jD/dRRvm2fAKr4x89:94DF";
                                    //'W13-IVAN大
                                    string mLogoW3 = "60^GFA,03072,03072,00032,:Z64:" + BR
                                            + "eJzt1E+IG1UYAPD3dtKZKM9MRA8TdvaPCku9TTbQTLolG/agHkQ8SS/KpNFGcKmByG4C2903zZJ4CEkvwoZ6cBHsRUpA1IoH3zQyQcgmeCjtIa4JgURh3STsoVnabXyTzWSzbdOexf1ghsf7ve+9l/e9CQAncRIn8T8PrC6o2Wn7+tjYV+D5wy77sBMthh/IjjzDd8Aa7nV5h71ajanb56jbsuAy6XWtDXugltZSnwmlmADgIYMLpp2jTzjAanGvJ5+XqZ+yquqCz236qpH/XbJ6w23XaxLU8FT6VqPeWjH9Hn1cZ5D/gUvWP4q8rmHHduOboCKanjM26xb9nXBGD0sdSODnl5DL3CaAOfp7vN6pdtLZKc7L5yHmyh/yDdDEfVfpwElxsp2S/tInZAkSMblrm4H5vjOGI1HyJKSIzosybmUKF1kW5PrOgQp1RA9P8ugsv0/W/rgbbPwAuv31WcOt1pAnlpWKDFfB8+lyLtAAUd+h8yD0hHodNRGQHvehEAX5qS6LwjOcnuRir9kf6MPDLok2s9jUGQwgJsMeMrxpOqSuHcuvIA4Af6+LLqSAR/MrIp0zcOW5Kwtkwyp8fDUOtRzA6yZD/DL1cDpd36sepC53b/6p3i5tdbdNZ4hIb9yquBW8Ec4UdzYzGdz9rfTOvYFjK/WHQmEZuRxJkhvPav/gXTEwcLqrCghO7cwg90ScVK/NazhfsA6cBVa66cAGWkKzND+QPgvJr0Xxa9NttEAhEPgSBZHbUazkUgJUywU0yJ+k+RKolpp1rl0uL0bjE0Tbqgs100XqMlBKWwlus7PrXWN5FacXj/IF6sZVR+DJIT/DQ709jnaJ5rOHfsqn/A7hI16hs9MCAgu9qRX//ViiP6cZpO/GMm3t70SMNt49Ymg4LaARyKmqifzx6XtEB03TFWxRFev66Zm3X1XeUmwIXH3F0k/VdLdzP47cflIvrCw/DLcPWvwqONjX+06KS9FMga+1Wzs7l842gtHvpbk3mZ/KBVre3vyfvjY3XuavZyMrK2zoDde4g4Q4ZtxC/fZ7X7x/h3xSu//CXcTKQmRxUqktvZSpSFPwWioCYLfbbXZxVGvyEcTJgiwvKRcCnk5IcsE9WwQA6t0D4NGK3PkkMyvLcj10/YxAZqWwPZccfJkeotucRWavJUkfKLfCL6o///KjZ/PbwUHa8brFmQTVlt2+rDQuevZr/Fym1Rr68i3HTq3so6+b0yNqChgrfY2JoxiMGf/JzMZIZ1rGqXVG+kn8V+Jf6g9d6A==:0234";

                                    for (int i = 0; i < dt.Rows.Count; i++)
                                    {
                                        Print_Amount = int.Parse(dt.Rows[i]["列印數量"].ToString()) / 2;
                                        string P_EN1 = dt.Rows[i]["EN1"].ToString(), P_EN2 = dt.Rows[i]["EN2"].ToString();
                                        if (P_EN1.Length + P_EN2.Length == 0 || dt.Rows[i]["ENA"].ToString().Length > 0)
                                        {
                                            string ENA = dt.Rows[i]["ENA"].ToString();
                                            if (ENA.Length > 27)
                                            {
                                                int NL = ENA.LastIndexOf(" ", 27);
                                                P_EN1 = ENA.Substring(0, NL);
                                                P_EN2 = ENA.Substring(NL + 1, ENA.Length - NL - 1);
                                            }
                                            else
                                            {
                                                P_EN1 = ENA;
                                            }
                                        }
                                        string CP65_Mark = "";
                                        switch (dt.Rows[i]["CP65"].ToString().Trim())
                                        {
                                            case "W1":
                                                //⚠
                                                CP65_Mark = mLogoW1;
                                                break;
                                            case "W2":
                                                CP65_Mark = mLogoW2;
                                                break;
                                            case "W3":
                                                CP65_Mark = mLogoW3;
                                                break;
                                        }
                                        Print_Detail = "^A@N,12,12,B:ARIALBD.TTF^FS" + BR//宣告字型
                                            + "^FO {0},10^A@N,18,18^FD" + dt.Rows[i]["銷售型號"].ToString() + "^FS" + BR
                                            + "^FO {1},10^A@N,18,18^FD" + dt.Rows[i]["單位"].ToString() + "^FS" + BR
                                            + "^FO {0},33^A@N,16,16^FD" + P_EN1 + "^FS" + BR
                                            + "^FO {0},50^A@N,16,16^FD" + P_EN2 + "^FS" + BR
                                            + "^FO {2},105^A@N,16,16^FD" + ((dt.Rows[i]["年齡"].ToString() != "0") ? dt.Rows[i]["年齡"].ToString() + "+" : "") + "^FS" + BR
                                            //省略：^CWK,B:MSJH.TTF^FS ('宣告正黑體 K)
                                            + "^FO {0},70^AKN,16,16^FD" + dt.Rows[i]["簡短說明"].ToString() + "^FS" + BR
                                            + "^FO {3}," + CP65_Mark + BR//Test_Unicode
                                                                         //省略: ^A@N,12,12,B:ARIALBD.TTF^FS
                                            + "^FO {4},145^BY2^BEN,70,Y,N^FD" + dt.Rows[i]["國際條碼"].ToString() + "^FS" + BR
                                            + "^FO {0},240^A@N,16,16^FD" + "IVAN LEATHERCRAFT CO.,LTD" + "^FS" + BR
                                            //省略：^CWK,B:MSJH.TTF^FS
                                            + "^FO {0},257^AKN,16,16^FD" + "頤坊皮藝" + "^FS" + BR
                                            //省略：^CWK,B:MSJH.TTF^FS
                                            + "^FO {5},257^A@N,16,16^FD" + "IVAN.TW" + "^FS" + BR
                                            + "^FO {0},274^A@N,16,16^FD" + "MADE IN " + dt.Rows[i]["產地"].ToString() + "^FS" + BR
                                            + "^FO {0},291^A@N,16,16^FD" + dt.Rows[i]["頤坊型號"].ToString() + "^FS" + BR;
                                        Print_Context += BR + "^XA" + BR
                                                + string.Format(Print_Detail, "20", "220","250","15","58","195")
                                                + string.Format(Print_Detail, "324", "524","554","319","362","499")
                                                + "^PQ" + Print_Amount.ToString() + ",0,0,N" + BR
                                                + "^XZ" + BR;
                                    }
                                    break;
                                case "IV07":
                                    Print_Head = string.Format(Print_Head, "224");//28mm*8
                                    string mLogo = "^GFA,06528,06528,00068,:Z64:" + BR +
                                        "eJzt1+FPG2UcB/Dn6VM5TA6ObclSYsct+NI3V2u2U2YPM2S+8I3/wbEqvNkMRBNZFO7pimOJXdnL28Rh/AtmYoyJL7hC18akKTHxxZaY7FjjSJRhiYk7suMef09bGHPzfBh7YSK/Qkvo3Yfv8zy/e64gtF/7tV/79R+t3sjejYnK3g29Knqk5RFG+Svd/o2DAoRU58BPT28wlxuG++qf4ob0RANyfPPUBt7KoX8rbPiPGfVd5/CVRw3SNAxXVPgHA/EcezI8/tLIIdipjxm4aTRySIJGAIYSgPEVNdxI7zh54KFelGrk6KD/cnbLmFQZteArw2CdsR9ID3yYUzbHczwvbMxTxhwrG2AWkM2mgRnjOWLO9nFyuDGXgTOsaZ8whjd9aR0M+JGffrAfleVxoyyXYlaYYRnzDWMGGpZlma/8EaBAauY4ZqKV9vHXVuTfY7WQYVmGamSYWrfm6pIPk+Ip602D5zitoTdj49pK7lSskAszjPlsoNSteVfxjEUwlsFQmjkWdHTPrmh3K0s2DZkQS33doHEJDEepqwVG1WUGhmfxHAsxdNauGMXKwK1Pw+bDmDcoghzMUVyjxpDqNgzeH+R8Ozr7XdW4sLq2MR02H6oBhsoN1YUcLaNuQA4ciaIzPwbJtjMD526EGjwHaxi/ztcCuFAY5QbPEWlD+nqQKJ2ojBdCjcCgatNgrACGww2XXy8ReOjr04lSvKgvh60LNxg3XDB4DtYweI62CEF6Oqvdja/pVj7EUALojxUw6mAsbxs8RxTh7ePi/0w0jCybaRmQw4L2auVoj6CQWdhhdPhG1of+uFeHP419MDYdv7kusShyhAyeg/fpiqe4iMBVDy3aWhcNIVfIkCCHB0YZnngO1hiLx3Mcv89MsRwtIwsDSGW3cvj8ejGaV41YDl/lhuRZBcgBnbp13QqWJXmwLtAfWX4i38ygU7f2j90aGb55ZXww1PrWPia6rxMPeuy+B9sPnEgCHDSN2zwH3CY621GjS442jqaoB557mz/uMOrQ6794Ft2kzMc+GEodRsT3dezEkZFDGNPGOkM5aAKek/D9sIObxnmWBYNRwyMBdIjiweqoLh8KoUM5uHzRQyNNmwbZkSOsZDThmB2FWvfn5evHlbnypWsOMl+YTSXJqHd7SQzpIXnX7VxJJmaro332UmXpewd9El8bTpIruQc3xYzDhJj98vCBsdnKaIIWnFLCQUasFEkSWS7ExMaSbMPXXfn9vmV7VUt8tpitarBr2iUYi3yiNidmDE29ddmUhw+t229riWvlnqJWqGO79EGSdKwuSo6QYa623xzKDfd9DfeYhF2NVTTny2W7dAeM3OJFMaP/XXTzo9xIotseGE1c+flIsdtBY3aRz+lswRb7GO2kvItGZ7rWba9cT1y7vVTtgTm9Wvo4SbxgcSlkk95pxG9sHag98gYROr1RtDPTMjrNpzYkqXWn/tsi7MYgQcuI0Efe2MV/NhT7YR+hhCpP3Pa9Gj88Z+7Z+I3osV0N/gn1zli8a4hi7MC2RQdbiwF7rETFjZekvDZG2/iWhWm1ZUAsxRE3XiHk6FimDcPe+cbltkPRrihCXYejSO5H0SjqEjJ0RNxzM0vTSzN0w1+zUr5Fuv3JVAq5NcOYmxQyZNjZJ3IjJFbGXxQHR/RimnRXBpM6punEgdl+IaMTpuFsbpjE1kgmX63pF8DIlV7UiXN6KGubQoYEj/dywzg2gPHUwEnNT+Pu3IKlIfPDCdUWGwu5k0IjF1s51movU8iRXzB1ZB4z+64qQgYy6ijN56OIL00NjmgOH8spTZPNuJmwT4oZcLmmZ8pZpYo38lULxkI28pOGrjhxw7Anj4ohsLdnMJGiaGyqdEjT0vhW7qCsERSXj9hxU9R4cgneoEJr9BkY5jMw9mu//of1F6br/0A=:3C09";
                                    for (int i = 0; i < dt.Rows.Count; i++)
                                    {
                                        Print_Amount = int.Parse(dt.Rows[i]["列印數量"].ToString());
                                        string P_EN1 = dt.Rows[i]["EN1"].ToString(), P_EN2 = dt.Rows[i]["EN2"].ToString();

                                        Print_Detail = "^A@N,12,12,B:ARIALBD.TTF^FS" + BR
                                            + "^FO {0},10^" + mLogo + BR
                                            + "^FO {1},100^A@N,20,20^FD" + dt.Rows[i]["銷售型號"].ToString() + "^FS" + BR
                                            + "^FO {1},125^A@N,16,16^FD" + P_EN1 + "^FS" + BR
                                            + "^FO {1},145^A@N,16,16^FD" + P_EN2 + "^FS" + BR
                                            + "^FO {1},170^AKN,16,16^FD" + dt.Rows[i]["簡短說明"].ToString() + "^FS" + BR
                                            + "^FO {2},100^BY2^BEN,65,Y,N^FD" + dt.Rows[i]["國際條碼"].ToString() + "^FS" + BR
                                            + "^FO {3},190^A@N,16,16^FD" + "MADE IN " + dt.Rows[i]["產地"].ToString() + "^FS" + BR;
                                        Print_Context += BR + "^XA" + BR
                                                + string.Format(Print_Detail, "5", "30","300","320")
                                                + "^PQ" + Print_Amount.ToString() + ",0,0,N" + BR
                                                + "^XZ" + BR;
                                    }
                                    break;
                                case "IV08":
                                    Print_Head = string.Format(Print_Head, "96");//12mm*8
                                    for (int i = 0; i < dt.Rows.Count; i++)
                                    {
                                        Print_Amount = int.Parse(dt.Rows[i]["列印數量"].ToString()) / 2;

                                        Print_Detail = "^A@N,12,12,B:ARIALBD.TTF^FS" + BR
                                            + "^FO {0},5^A@N,18,18^FD" + dt.Rows[i]["銷售型號"].ToString() + "^FS" + BR
                                            + "^FO {1},25^BY2^BEN,35,Y,N^FD" + dt.Rows[i]["國際條碼"].ToString() + "^FS" + BR;
                                        Print_Context += BR + "^XA" + BR
                                                + string.Format(Print_Detail, "10", "58")
                                                + string.Format(Print_Detail, "314", "362")
                                                + "^PQ" + Print_Amount.ToString() + ",0,0,N" + BR
                                                + "^XZ" + BR;
                                    }
                                    break;

                            }
                            Print_Context = Print_Head + Print_Context.Replace("^", "!") + Print_Footer;
                            System.IO.File.WriteAllText(Print_File_Path, Print_Context, System.Text.Encoding.GetEncoding("big5"));
                            Info.StartInfo.Arguments = @"-S " + context.Request["Print_Destination"] + @" -P T " + Print_File_Path;
                        }

                        //if (Print_File_Path.Length > 0) //Check_Print時不會建txt
                        //{
                        //    Info.Exited += new System.EventHandler(Delete_File);
                        //}
                        Info.Start();
                        context.Response.StatusCode = 200;
                        context.Response.End();
                        break;
                }
                var json = JsonConvert.SerializeObject(dt);
                context.Response.ContentType = "text/json";
                context.Response.Write(json);
            }
            catch (SqlException ex)
            {
                Log.InsertLog(context, context.Session["Name"], Barcode._sqlLogModel, ex.ToString(), false);
                context.Response.StatusCode = 404;
                context.Response.Write(ex.Message);
            }
        }
    }
    public void Delete_File()
    {
        System.IO.File.Delete("");
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
}
