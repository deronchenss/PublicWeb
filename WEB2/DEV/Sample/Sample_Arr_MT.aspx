<%@ Page Title="樣品到貨查詢維護" Language="C#" MasterPageFile="~/MP.master" AutoEventWireup="true" CodeFile="Sample_Arr_MT.aspx.cs" Inherits="Sample_Arr_MT" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="/css/dataTables.bootstrap4.min.css" rel="stylesheet" />
    <script src="/js/jquery.dataTables.min.js"></script>
    <script src="/js/dataTables.bootstrap4.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            var Edit_Mode = "Base";
            var apiUrl = "/DEV/Sample/Ashx/Sample_Arr_MT.ashx";
            //隱藏滾動卷軸
            document.body.style.overflow = 'hidden';

            //init CONTROLER
            Form_Mode_Change("Base");

            //報表預設前一個月
            var dateToday = new Date();
            var date = new Date(dateToday.setMonth(dateToday.getMonth() - 1));
            $('#R_INVOICE_DATE_S').val($.datepicker.formatDate('yy-mm-dd',new Date(date.getFullYear(), date.getMonth(), 1)));
            $('#R_INVOICE_DATE_E').val($.datepicker.formatDate('yy-mm-dd',new Date(date.getFullYear(), date.getMonth() + 1, 0)));

            window.document.body.onbeforeunload = function () {
                if (Edit_Mode === "Insert" || Edit_Mode === "Edit") {
                    return '您尚未將編輯過的表單資料送出，請問您確定要離開網頁嗎？';
                }
            }

            //上下移功能 根據每個頁面客製
            $(document).keydown(function (event) {
                var key = (event.keyCode ? event.keyCode : event.which);
                var clickIndex = $('#Table_Search_Recu > tbody > tr.tableClick').index();
                if (key == '40') {
                    if (clickIndex < $('#Table_Search_Recu tbody tr').length - 1) {
                        clickIndex++;
                        ClickToEdit($('#Table_Search_Recu > tbody > tr:nth(' + clickIndex + ')'));
                    }
                }
                else if (key == '38') {
                    clickIndex--;
                    ClickToEdit($('#Table_Search_Recu > tbody > tr:nth(' + clickIndex + ')'));
                }
            });

            //function region
            function Form_Mode_Change(Form_Mode) {
                switch (Form_Mode) {
                    case "Base":
                        $('.Div_D').css('display', 'none');
                        $('#Div_DT_View').css('display', 'none');
                        $('#BT_Cancel').css('display', 'none');
                        $('#BT_Search').css('display', '');
                        $('#BT_Update').css('display', 'none');
              
                        V_BT_CHG($('#BT_S_BASE'));
                        break;
                    case "Search":
                        $('.Div_D').css('display', 'none');
                        $('#Div_DT_View').css('width', '100%');
                        $('#Div_DT_View').css('display', '');

                        $('#BT_Cancel').css('display', '');
                        $('#BT_E_CANCEL').css('display', 'none');

                        if (Edit_Mode == "Edit") {
                            $('.modeButton').css('display', 'none')
                            $('#Div_EDIT_Data').css('display', '');
                            $('#Div_DT_View').css('width', '60%');
                            $('#Table_Search_Recu').DataTable().draw();

                            $('#BT_DELETE').css('display', 'inline-block');
                            $('#BT_EDIT_SAVE').css('display', 'inline-block');
                            $('#BT_E_CANCEL').css('display', 'inline-block');

                        }
                       
                        V_BT_CHG($('#BT_S_BASE'));
                        break;
                    case "IMG":
                        $('.Div_D').css('display', 'none');
                        $('#Div_DT_View').css('width', '60%');
                        $('#Div_IMG_DETAIL').css('display', '');
                        if ($('#Table_Search_Recu > tbody tr[role=row]').length != 0) {
                            $('#Table_Search_Recu').DataTable().draw();
                        }

                        V_BT_CHG($('#BT_S_IMG'));
                        break;       
                    case "RPT":
                        $('.Div_D').css('display', 'none');
                        $('#Div_DT_View').css('width', '60%');
                        $('#Div_RPT_DETAIL').css('display', '');

                        if ($('#Table_Search_Recu > tbody tr[role=row]').length != 0) {
                            $('#Table_Search_Recu').DataTable().draw();
                        }

                        V_BT_CHG($('#BT_S_RPT'));
                        break;      
                }
            }

            function ClickToEdit(click_tr) {
                $('#BT_Update').css('display', '');

                //點擊賦予顏色
                $('#Table_Search_Recu > tbody tr').removeClass("tableClick");
                click_tr.addClass("tableClick");
                var clickData = $('#Table_Search_Recu').DataTable().row(click_tr).data();

                //Edit page
                for (var i = 0; i < $('#Table_Search_Recu').DataTable().columns().header().length; i++) {
                    var titleName = $($('#Table_Search_Recu').DataTable().column(i).header()).text();

                    if (titleName == '發票異常' || titleName == '不付款') {
                        $("[DT_Fill_Name='" + titleName + "']").prop('checked', clickData[titleName] == '是');
                    }
                    else {
                        $("[DT_Fill_Name='" + titleName + "']").val(clickData[titleName]);
                    }
                }

                //IMG page
                $('#I_IVAN_TYPE').val(clickData['頤坊型號']);
                $('#I_FACT_NO').val(clickData['廠商編號']);
                $('#I_FACT_S_NAME').val(clickData['廠商簡稱']);
                $('#I_PROD_DESC').val(clickData['產品說明']);
                $('#I_RPT_REMARK').val(clickData['大備註']);
                Search_IMG($('#E_SUPLU_SEQ').val());
            }
            
            function V_BT_CHG(buttonChs) {
                $('.V_BT').attr('disabled', false);
                buttonChs.attr('disabled', 'disabled');
            }

            //ajax function
            function Search_Recu() {
                $.ajax({
                    url: apiUrl,
                    data: {
                        "Call_Type": "Search_Recu", 
                        "到貨單號": $('#Q_ARR_NO').val(),
                        "樣品號碼": $('#Q_SAMPLE_NO').val(),
                        "頤坊型號": $('#Q_IVAN_TYPE').val(),
                        "到貨日期_S": $('#Q_ARR_DATE_S').val(),
                        "到貨日期_E": $('#Q_ARR_DATE_E').val(),
                        "採購單號": $('#Q_PUDU_NO').val(),
                        "廠商編號": $('#Q_FACT_NO').val(),
                        "廠商簡稱": $('#Q_FACT_S_NAME').val()
                    },
                    cache: false,
                    type: "POST",
                    datatype: "json",
                    contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                    success: function (response) {
                        if (response.length === 0) {
                            alert('<%=Resources.MP.Data_Not_Exists_Alert%>');
                            Edit_Mode = "Base";
                            Form_Mode_Change("Base");
                        }
                        else {       
                            $('#Table_Search_Recu').DataTable({
                                "data": response,
                                "destroy": true,
                                //維持scroll bar 位置
                                "preDrawCallback": function (settings) {
                                    pageScrollPos = $('div.dataTables_scrollBody').scrollTop();
                                },
                                "drawCallback": function (settings) {
                                    $('div.dataTables_scrollBody').scrollTop(pageScrollPos);
                                },
                                "columns": [
                                    { data: "序號", title: "序號"},
                                    { data: "採購單號", title: "採購單號" },
                                    { data: "到貨日期", title: "到貨日期" },
                                    { data: "廠商簡稱", title: "廠商簡稱" },
                                    { data: "頤坊型號", title: "頤坊型號" },
                                    { data: "單位", title: "單位" },
                                    { data: "到貨數量", title: "到貨數量" },
                                    { data: "到貨單號", title: "到貨單號" },
                                    { data: "樣品號碼", title: "樣品號碼" },
                                    { data: "更新人員", title: "<%=Resources.MP.Update_User%>" },
                                    { data: "更新日期", title: "<%=Resources.MP.Update_Date%>" },
                                    { data: "產品說明", title: "產品說明", visible: false },
                                    { data: "出貨日期", title: "出貨日期", visible: false },
                                    { data: "暫時型號", title: "暫時型號", visible: false },
                                    { data: "廠商型號", title: "廠商型號", visible: false },
                                    { data: "廠商編號", title: "廠商編號", visible: false },
                                    { data: "不付款", title: "不付款", visible: false },
                                    { data: "台幣單價", title: "台幣單價", visible: false },
                                    { data: "美元單價", title: "美元單價", visible: false },
                                    { data: "外幣幣別", title: "外幣幣別", visible: false },
                                    { data: "外幣單價", title: "外幣單價", visible: false },
                                    { data: "到單日期", title: "到單日期", visible: false },
                                    { data: "發票樣式", title: "發票樣式", visible: false },
                                    { data: "發票號碼", title: "發票號碼", visible: false },
                                    { data: "發票異常", title: "發票異常", visible: false },
                                    { data: "到貨備註", title: "到貨備註", visible: false },
                                    { data: "調整額01", title: "調整額01", visible: false },
                                    { data: "調整額02", title: "調整額02", visible: false },
                                    { data: "SUPLU_SEQ", title: "SUPLU_SEQ", visible: false }
                                ],
                                "order": [[2, "asc"]], //根據 採購單號 排序
                                "scrollX": true,
                                "scrollY": "62vh",
                                "searching": false,
                                "paging": false,
                                "bInfo": false, //顯示幾筆隱藏
                                "autoWidth": false //欄位小於VIEW 長度，自動擴展
                            });

                            $('#Table_Search_Recu').DataTable().draw();
                            $('#Table_Search_Recu_info').text('Showing ' + $('#Table_Search_Recu > tbody tr[role=row]').length + ' entries');
                        }
                    },
                    error: function (ex) {
                        console.log(ex.responseText);
                        alert('查詢有誤請通知資訊人員');
                    }
                });
            };        

            function Search_IMG(supluSeq) {
                $.ajax({
                    url: "/CommonAshx/Common.ashx",
                    data: {
                        "Call_Type": "GET_IMG_BY_SUPLU_SEQ",
                        "SEQ": supluSeq
                    },
                    cache: false,
                    async: false,
                    type: "POST",
                    datatype: "json",
                    contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                    success: function (RR) {
                        if (RR != null && RR.length > 0) {
                            $('#I_NO_IMG').css('display', 'none');
                            $('#I_IMG').css('display', '');

                            var SRC = 'data:image/png;base64,' + RR[0].P_IMG;
                            $('#I_IMG').attr('src', SRC);
                        }
                        else {
                            $('#I_NO_IMG').css('display', '');
                            $('#I_IMG').css('display', 'none');
                        }
                    }
                });
            };             

            //更新DB
            function UPD_RECU() {
                if ($('#E_SEQ').val() === '') {
                    alert('請選擇要修改的資料');
                }
                else{
                    $.ajax({
                        url: apiUrl,
                        data: {
                            "Call_Type": "UPD_RECU",
                            "SEQ": $('#E_SEQ').val(),
                            "出貨日期": $('#E_SHIP_GO_DATE').val(),
                            "到貨日期": $('#E_SHIP_ARR_DATE').val(),
                            "不付款": $('#E_NO_PAY').is(":checked"),
                            "到單日期": $('#E_ORDER_ARR_DATE').val(),
                            "發票樣式": $('#E_INVOICE_TYPE').val(),
                            "發票號碼": $('#E_INVOICE_NO').val(),
                            "發票異常": $('#E_INVOICE_ERR').is(":checked"),
                            "到貨備註": $('#E_ARR_REMARK').val(),
                            "調整額01": $('#E_ADJ_AMT_01').val() == '' ? 0 : $('#E_ADJ_AMT_01').val(),
                            "調整額02": $('#E_ADJ_AMT_02').val() == '' ? 0 : $('#E_ADJ_AMT_02').val()
                        },
                        cache: false,
                        type: "POST",
                        datatype: "json",
                        contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                        success: function (response, status) {
                            console.log(status);
                            if (status === 'success') {
                                alert('序號:' + $('#E_SEQ').val() + '已修改完成');

                                Search_Recu();
                            }
                            else {
                                alert('修改資料有誤請通知資訊人員');
                            }
                        },
                        error: function (ex) {
                            console.log(ex.responseText);
                            alert('修改資料有誤請通知資訊人員');
                            return;
                        }
                    });
                }
            };           

            //刪除單筆資料
            function DELETE_RECU() {
                if ($('#E_SEQ').val() === '') {
                    alert('請選擇要刪除的資料');
                }
                else {
                    $.ajax({
                        url: apiUrl,
                        data: {
                            "Call_Type": "DELETE_RECU",
                            "SEQ": $('#E_SEQ').val()
                        },
                        cache: false,
                        type: "POST",
                        datatype: "json",
                        contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                        success: function (response, status) {
                            console.log(status);
                            if (status === 'success') {
                                alert('序號:' + $('#E_SEQ').val() + '已刪除完成');
                                Search_Recu();
                            }
                            else {
                                alert('刪除資料有誤請通知資訊人員');
                            }
                        },
                        error: function (ex) {
                            console.log(ex.responseText);
                            alert('刪除資料有誤請通知資訊人員');
                            return;
                        }
                    });
                }
            };           

            //產生報表
            function PRINT_RPT() {
                if ($('#R_INVOICE_DATE_S').val() == '' || $('#R_INVOICE_DATE_E').val() == '') {
                    alert('請填寫發票區間');
                }
                else {
                    $("body").loading(); // 遮罩開始
                    $.ajax({
                        url: apiUrl,
                        data: {
                            "Call_Type": "PRINT_RPT",
                            "RPT_TYPE": $('#R_RPT_TYPE').val(),
                            "出貨日期_S": $('#R_INVOICE_DATE_S').val(),
                            "出貨日期_E": $('#R_INVOICE_DATE_E').val(),
                            "廠商編號": $('#R_FACT_NO').val()
                        },
                        cache: false,
                        type: "POST",
                        datatype: "json",
                        contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                        xhr: function () {// Seems like the only way to get access to the xhr object
                            var xhr = new XMLHttpRequest();
                            xhr.responseType = 'blob'
                            return xhr;
                        },
                        success: function (response, status) {
                            if (status === 'nocontent') {
                                alert('採購單號查無資料');
                            }
                            else if (status !== 'success') {
                                alert(response);
                            }
                            else {
                                var blob = new Blob([response], { type: "application/pdf" });
                                var url = window.URL || window.webkitURL;
                                link = url.createObjectURL(blob);
                                var a = $("<a />");
                                switch ($('#R_RPT_TYPE').val()) {
                                    case "0":
                                        a.attr("download", "發票金額統計表.pdf");
                                        break;
                                }

                                a.attr("href", link);
                                $("body").append(a);

                                a[0].click();
                                $("body").remove(a);
                            }
                            $("body").loading("stop") // 遮罩停止
                        },
                        error: function (ex) {
                            console.log(ex.responseText);
                            $("body").loading("stop") // 遮罩停止
                            alert('產生報表有誤請通知資訊人員');
                            return;
                        }
                    });
                }
            };    

            //TABLE 功能設定
            $('#Table_Search_Recu').on('click', 'tbody tr', function () {
                ClickToEdit($(this));
            });

            //BUTTON CLICK EVENT BASE 頁
            $('#BT_Search').on('click', function () {
                Form_Mode_Change("Search");
                Search_Recu();
            });

            $('#BT_Cancel').on('click', function () {
                Edit_Mode = "Base";

                var Confirm_Check = confirm("<%=Resources.MP.Cancel_Alert%>");
                if (Confirm_Check) {
                    $('#Table_Search_Recu').DataTable().clear().draw();
                    Form_Mode_Change("Base");
                }
            });

            $('#BT_EDIT_SAVE').on('click', function () {
                UPD_RECU();
            });

            $('#BT_DELETE').on('click', function () {
                var Confirm_Check = confirm("確認刪除嗎? 序號:" + $('#E_SEQ').val());
                if (Confirm_Check) {
                    DELETE_RECU();
                }
            });

            $('#BT_Update').on('click', function () {
                Edit_Mode = "Edit";
                Form_Mode_Change("Search");
            });

            $('#BT_E_CANCEL').on('click', function () {
                Edit_Mode = "Search";
                Form_Mode_Change("Search");
                $('#Table_Search_Recu').DataTable().draw();
            });

            //報表頁
            $('#BT_R_PRINT').on('click', function () {
                PRINT_RPT();
            });
            
            //功能選單
            $('#BT_S_BASE').on('click', function () {
                if($('#Table_Search_Recu > tbody tr[role=row]').length > 0)
                {
                    Form_Mode_Change('Search');
                }
                else {
                    Form_Mode_Change("Base");
                }
            });    

            $('#BT_S_IMG').on('click', function () {
                Form_Mode_Change("IMG");
            });   

            $('#BT_S_RPT').on('click', function () {
                Form_Mode_Change("RPT");
            });   

        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div style="width:98%;margin:0 auto; ">
        <div class="search_section_all">
            <table class="search_section_control">
            <tr class="trstyle"> 
                <td style="height: 10px; font-size: smaller;" colspan="8">&nbsp
                </td>
            </tr>
            <tr class="trstyle">
                <td class="tdhstyle">到貨單號</td>
                <td class="tdbstyle">
                    <input id="Q_ARR_NO" class="textbox_char" />
                </td>
                <td class="tdhstyle">採購單號</td>
                <td class="tdbstyle">
                    <input id="Q_PUDU_NO"  class="textbox_char" />
                </td>
                <td class="tdhstyle">到貨日期</td>
                <td class="tdbstyle">
                    <input id="Q_ARR_DATE_S" type="date" class="date_S_style" />~<input id="Q_ARR_DATE_E" type="date" class="date_E_style" />
                </td>
            </tr>
            <tr class="trstyle">
                <td class="tdhstyle">頤坊型號</td>
                <td class="tdbstyle">
                    <input id="Q_IVAN_TYPE"  class="textbox_char" />
                </td>
                <td class="tdhstyle">樣品號碼</td>
                <td class="tdbstyle">
                    <input id="Q_SAMPLE_NO"  class="textbox_char" />
                </td>
            </tr>
             <tr class="trstyle">
                <td class="tdhstyle">廠商編號</td>
                <td class="tdbstyle">
                    <input id="Q_FACT_NO"  class="textbox_char" />
                </td>
                <td class="tdhstyle">廠商簡稱</td>
                <td class="tdbstyle">
                    <input id="Q_FACT_S_NAME" class="textbox_char" />
                </td>
            </tr>
            <tr class="trstyle">
                <td class="tdtstyleRight" colspan="8">
                    <input type="button" id="BT_Search" class="buttonStyle" value="<%=Resources.MP.Search%>" />
                    <input type="button" id="BT_Update" class="buttonStyle" value="修改" />
                    <input type="button" id="BT_Cancel" class="buttonStyle" value="<%=Resources.MP.Cancel%>" style="display: none;" />
                </td>
            </tr>
        </table>
        </div>
        <div class="button_change_section">
            &nbsp;
            <input type="button" id="BT_S_BASE" class="V_BT" value="主檔"  disabled="disabled" />
            <input type="button" id="BT_S_IMG" class="V_BT" value="圖型" />
            <input type="button" id="BT_S_RPT" class="V_BT" value="報表" />
        </div>

        <div id="Div_DT">
            <div id="Div_DT_View" style=" width:60%;height:71vh; border-style:solid;border-width:1px; float:left;">
                <div class="dataTables_info" id="Table_Search_Recu_info" role="status" aria-live="polite"></div>
                <table id="Table_Search_Recu" class="Table_Search table table-striped table-bordered">
                    <thead style="white-space:nowrap"></thead>
                    <tbody style="white-space:nowrap"></tbody>
                </table>
            </div>
    
            <div id="Div_EDIT_Data" class=" Div_D" style="width:35%; height:71vh;white-space:nowrap; border-style:solid; border-width:1px;  float:right; overflow:auto">
                <table class="edit_section_control">
                    <tr> 
                        <td style="height: 5vh; font-size: smaller;" >&nbsp</td>
                    </tr>
                    <tr class="trstyle" >
                        <td class="tdhstyle">序號</td>
                        <td class="tdbstyle">
                            <input id="E_SEQ" DT_Fill_Name="序號"  class="textbox_char" disabled="disabled" />
                            <input id="E_SUPLU_SEQ" DT_Fill_Name="SUPLU_SEQ"  class="textbox_char" type="hidden" />
                        </td>
                    </tr>
                    <tr class="trstyle">
                        <td class="tdhstyle">頤坊型號</td>
                        <td class="tdbstyle">
                            <input id="E_IVAN_TYPE" DT_Fill_Name="頤坊型號"  class="textbox_char" disabled="disabled" />
                        </td>
                        <td class="tdhstyle ">樣品號碼</td>
                        <td class="tdbstyle">
                            <input id="E_SAMPLE_NO" DT_Fill_Name="樣品號碼" disabled="disabled" class="textbox_char "/>
                        </td>
                    </tr>
                    <tr class="trstyle">
                        <td class="tdhstyle">廠商編號</td>
                        <td class="tdbstyle">
                            <input id="E_FACT_NO" DT_Fill_Name="廠商編號"  class="textbox_char" disabled="disabled" />
                        </td>
                        <td class="tdhstyle">廠商簡稱</td>
                        <td class="tdbstyle">
                            <input id="E_FACT_S_NAME" DT_Fill_Name="廠商簡稱" class="textbox_char" disabled="disabled"  />
                        </td>
                    </tr>
                    <tr class="trstyle">
                        <td class="tdhstyle">暫時型號</td>
                        <td class="tdbstyle">
                            <input id="E_TMP_TYPE" DT_Fill_Name="暫時型號"   class="textbox_char" disabled="disabled" />
                        </td>
                        <td class="tdhstyle">廠商型號</td>
                        <td class="tdbstyle">
                            <input id="E_FACT_TYPE" DT_Fill_Name="廠商型號"  class="textbox_char" disabled="disabled"  />
                        </td>
                    </tr>
                    <tr class="trstyle">
                        <td class="tdhstyle">產品說明</td>
                        <td class="tdbstyle" colspan ="4">
                            <input id="E_PROD_DESC" DT_Fill_Name="產品說明"  class="textbox_char " style="width:80%" disabled="disabled"  />
                        </td>
                    </tr>     
                    <tr class="trstyle ">
                        <td class="tdhstyle">採購單號</td>
                        <td class="tdbstyle">
                            <input id="E_PUDU_NO" DT_Fill_Name="採購單號" disabled="disabled"  class="textbox_char" />
                        </td>
                        <td class="tdhstyle">出貨日期</td>
                        <td class="tdbstyle">
                            <input id="E_SHIP_GO_DATE" DT_Fill_Name="出貨日期"  type="date" class="date_S_style"  />
                        </td>
                    </tr>
                    <tr class="trstyle ">
                        <td class="tdhstyle">到貨日期</td>
                        <td class="tdbstyle">
                            <input id="E_SHIP_ARR_DATE" DT_Fill_Name="到貨日期"  type="date" class="date_S_style"  />
                        </td>
                        <td class="tdhstyle">到貨數量</td>
                        <td class="tdbstyle">
                            <input id="E_ARR_CNT" DT_Fill_Name="到貨數量"  class="textbox_char" type="number" disabled="disabled" />
                        </td>
                    </tr>
                     <tr class="trstyle ">
                        <td class="tdhstyle">單位</td>
                        <td class="tdbstyle">
                            <input id="E_UNIT" DT_Fill_Name="單位"  class="textbox_char" disabled="disabled" />
                        </td>
                        <td class="tdhstyle">不付款</td>
                        <td class="tdbstyle">
                            <input id="E_NO_PAY" DT_Fill_Name="不付款"  type="checkbox"  />
                        </td>
                    </tr>
                    <tr class="trstyle ">
                        <td class="tdhstyle">台幣單價</td>
                        <td class="tdbstyle">
                            <input id="E_NTD" DT_Fill_Name="台幣單價"  class="textbox_char" type="number" disabled="disabled" />
                        </td>
                        <td class="tdhstyle">美元單價</td>
                        <td class="tdbstyle">
                            <input id="E_USD" DT_Fill_Name="美元單價"  class="textbox_char" type="number" disabled="disabled" />
                        </td>
                    </tr>
                    <tr class="trstyle ">
                        <td class="tdhstyle">外幣幣別</td>
                        <td class="tdbstyle">
                            <input id="E_CURR_CODE" DT_Fill_Name="外幣幣別" class="textbox_char " disabled="disabled" />
                        </td>
                        <td class="tdhstyle">外幣單價</td>
                        <td class="tdbstyle">
                            <input id="E_FORE_AMT" DT_Fill_Name="外幣單價" class="textbox_char" type="number" disabled="disabled" />
                        </td>
                    </tr>
                    <tr class="trstyle ">
                        <td class="tdhstyle">到單日期</td>
                        <td class="tdbstyle">
                            <input id="E_ORDER_ARR_DATE" DT_Fill_Name="到單日期" type="date" class="date_S_style"  />
                        </td>
                        <td class="tdhstyle">到貨單號</td>
                        <td class="tdbstyle">
                            <input id="E_ARR_NO" DT_Fill_Name="到貨單號" class="textbox_char" disabled="disabled" />
                        </td>
                    </tr>
                    <tr class="trCenterstyle">
                        <td class="tdhstyle">發票樣式</td>
                        <td class="tdbstyle">
                            <select id="E_INVOICE_TYPE" DT_Fill_Name="發票樣式"  >
                                <option selected="selected"value=""></option>
                                <option value="21">21-三聯式</option>
                                <option value="22">22-二聯式</option>
                                <option value="23">23-三聯式折讓單</option>
                                <option value="24">24-二聯式折讓單</option>
                                <option value="25">25-三聯式收銀機</option>
                                <option value="99">99-香港-INVOICE</option>
                            </select>
                        </td>
                        <td class="tdhstyle">發票號碼</td>
                        <td class="tdbstyle" >
                            <input id="E_INVOICE_NO" DT_Fill_Name="發票號碼" class="textbox_char"   />
                        </td>
                    </tr>
                    <tr class="trstyle ">
                        <td class="tdhstyle">發票異常</td>
                        <td class="tdbstyle">
                            <input id="E_INVOICE_ERR" DT_Fill_Name="發票異常"  type="checkbox"   />
                        </td>
                        <td class="tdhstyle">到貨備註</td>
                        <td class="tdbstyle">
                            <input id="E_ARR_REMARK" DT_Fill_Name="到貨備註" class="textbox_char" />
                        </td>
                    </tr>
                    <tr class="trstyle ">
                        <td class="tdhstyle">調整額01-採購</td>
                        <td class="tdbstyle">
                            <input id="E_ADJ_AMT_01" DT_Fill_Name="調整額01" class="textbox_char" type="number"  />
                        </td>
                        <td class="tdhstyle">調整額02-會計</td>
                        <td class="tdbstyle">
                            <input id="E_ADJ_AMT_02" DT_Fill_Name="調整額02" class="textbox_char" type="number"  />
                        </td>
                    </tr>
                    <tr class="trstyle ">
                        <td class="tdhstyle">更新人員</td>
                        <td class="tdbstyle">
                            <input id="E_UPD_USER" DT_Fill_Name="更新人員" class="textbox_char " disabled="disabled" />
                        </td>
                        <td class="tdhstyle">更新日期</td>
                        <td class="tdbstyle">
                            <input id="E_UPD_DATE" DT_Fill_Name="更新日期" type="date" class="date_S_style " disabled="disabled" />
                        </td>
                    </tr>
                    <tr> 
                        <td style="height: 5vh; font-size: smaller;" >&nbsp</td>
                    </tr>
                     <tr class="trCenterstyle"> 
                         <td colspan="4" style="text-align:center" >
                            <input type="button" id="BT_DELETE" style="display:inline-block" class="BTN modeButton" value="刪除"  />
                            <input type="button" id="BT_EDIT_SAVE" style="display:inline-block" class="BTN modeButton" value="修改儲存"  />
                            <input type="button" id="BT_E_CANCEL" style="display:inline-block" class="BTN modeButton" value="返回"  />
                         </td>
                    </tr>
                </table>
            </div>
            <div id="Div_IMG_DETAIL" class=" Div_D" style="width:35%;height:71vh; border-style:solid;border-width:1px; float:right; overflow:auto ">
                <table class="edit_section_control">
                     <tr class="trstyle"> 
                        <td class="tdbstyle" style="height: 5vh; font-size: smaller;" >&nbsp</td>
                    </tr>
                    <tr class="trstyle">
                        <td class="tdEditstyle">頤坊型號</td>
                        <td class="tdbstyle">
                            <input id="I_IVAN_TYPE" class="textbox_char" disabled="disabled" style="width:100%"  />
                        </td>
                        <td class="tdEditstyle">廠商編號</td>
                        <td class="tdbstyle">
                            <input id="I_FACT_NO"  class="textbox_char" disabled="disabled"  style="width:100%" />
                        </td>
                    </tr>
                    <tr class="trstyle">
                        <td class="tdEditstyle"></td>
                        <td class="tdbstyle"></td>
                        <td class="tdEditstyle">廠商簡稱</td>
                        <td class="tdbstyle" >
                            <input id="I_FACT_S_NAME" class="textbox_char" disabled="disabled" style="width:100%"  />
                        </td>
                    </tr>
                    <tr class="trstyle">
                        <td class="tdEditstyle">產品說明</td>
                        <td class="tdbstyle" colspan="4">
                            <input id="I_PROD_DESC" class="textbox_char" style="width:80%" disabled="disabled"  />
                        </td>
                    </tr>

                    <tr class="trstyle">
                        <td style="text-align:center" colspan="4">
                            <img id="I_IMG" src="#" style="max-width:100%; max-height:100%;display:none" />
                            <span id="I_NO_IMG" >查無圖檔</span>
                        </td>
                    </tr>

                </table>
            </div> 
            <div id="Div_RPT_DETAIL" class=" Div_D" style="width:35%;height:71vh; border-style:solid;border-width:1px; float:right; overflow:auto ">
                <table class="search_section_control"style="width:80%">
                    <tr class="trstyle"> 
                        <td class="tdbstyle" style="height: 10vh; font-size: smaller;" >&nbsp</td>
                    </tr>
                    <tr class="trCenterstyle">
                        <td class="tdhstyle" style="font-size:20px;">報表類型</td>
                        <td class="tdbstyle" >
                            <select id="R_RPT_TYPE" >
                                <option selected="selected" value="0">發票金額統計表</option>
                            </select>
                         </td>
                    </tr>
                    <tr class="trCenterstyle">
                        <td class="tdhstyle" style="font-size:20px;">發票日期</td>
                        <td class="tdbstyle" >
                            <input id="R_INVOICE_DATE_S"  type="date" class="date_S_style" />~<input id="R_INVOICE_DATE_E"  type="date" class="date_E_style" />
                        </td>
                    </tr>
                    <tr class="trCenterstyle">
                        <td class="tdhstyle" style="font-size:10px;">(出貨日期)</td>
                    </tr>
                    <tr class="trCenterstyle">
                        <td class="tdhstyle" style="font-size:20px;" >廠商編號</td>
                        <td class="tdbstyle" >
                            <input id="R_FACT_NO"  class="textbox_char" />
                        </td>
                    </tr>
                     <tr class="trstyle"> 
                        <td class="tdbstyle" style="height: 10vh; font-size: smaller;" >&nbsp</td>
                    </tr>
                     <tr class="trCenterstyle"> 
                         <td colspan="2" style="text-align:center" >
                            <input type="button" id="BT_R_PRINT" style="display:inline-block" class="BTN" value="列印"  />
                         </td>
                    </tr>

                </table>
            </div> 
        </div>
    </div>

</asp:Content>
