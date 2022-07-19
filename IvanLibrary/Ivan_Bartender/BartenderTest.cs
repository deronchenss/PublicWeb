using Seagull.BarTender.Print; //重要
using System;

namespace Ivan_Bartender
{
    public class BartenderTest
    {
        public static void Bartender()
        {
            try
            {
                Engine btEngine = new Engine();
                btEngine.Start();
                string lj = @"C:\test\btwtest.btw";
                LabelFormatDocument btFormat = btEngine.Documents.Open(lj);

                //對模版相應欄位進行賦值
                btFormat.SubStrings["1"].Value = "44";
                btFormat.SubStrings["2"].Value = "55";
                btFormat.SubStrings["3"].Value = "FRVGT789";

                //指定印表機名
                btFormat.PrintSetup.PrinterName = "標籤機名字";
                //改變標籤列印數份連載
                btFormat.PrintSetup.NumberOfSerializedLabels = 1;
                //列印份數                  
                btFormat.PrintSetup.IdenticalCopiesOfLabel = 1;

                Messages messages;
                int waitout = 10000; // 10秒 超時
                Result nResult1 = btFormat.Print("標籤列印軟體", waitout, out messages);

                btFormat.PrintSetup.Cache.FlushInterval = CacheFlushInterval.PerSession;
                //不儲存對開啟模板的修改
                //btFormat.Close(SaveOptions.DoNotSaveChanges);
                //結束列印引擎                 
                btEngine.Stop();
            }
            catch (Exception ex)
            {
                return;
            }
        }
    }
}
