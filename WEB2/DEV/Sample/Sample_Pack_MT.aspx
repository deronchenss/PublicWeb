﻿<%@ Page Title="樣品備貨查詢維護" Language="C#" MasterPageFile="~/MP.master" AutoEventWireup="true" CodeFile="Sample_Pack_MT.aspx.cs" Inherits="Sample_Pack_MT" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="/css/dataTables.bootstrap4.min.css" rel="stylesheet" />
    <script src="/js/jquery.dataTables.min.js"></script>
    <script src="/js/dataTables.bootstrap4.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            var Edit_Mode;
            var apiUrl = "/DEV/Sample/Ashx/Sample_Pack_MT.ashx";
            //隱藏滾動卷軸
            document.body.style.overflow = 'hidden';

            //init CONTROLER
            Form_Mode_Change("Base");

            window.document.body.onbeforeunload = function () {
                if (Edit_Mode === "Insert" || Edit_Mode === "Edit") {
                    return '您尚未將編輯過的表單資料送出，請問您確定要離開網頁嗎？';
                }
            }

            //上下移功能 根據每個頁面客製
            $(document).keydown(function (event) {
                var key = (event.keyCode ? event.keyCode : event.which);
                var clickIndex = $('#Table_Search_Data > tbody > tr.tableClick').index();
                if (key == '40') {
                    if (clickIndex < $('#Table_Search_Data tbody tr').length - 1) {
                        clickIndex++;
                        ClickToEdit($('#Table_Search_Data > tbody > tr:nth(' + clickIndex + ')'));
                    }
                }
                else if (key == '38') {
                    if (clickIndex > 0) {
                        clickIndex--;
                        ClickToEdit($('#Table_Search_Data > tbody > tr:nth(' + clickIndex + ')'));
                    }
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

                        V_BT_CHG($('#BT_BASE'));
                        break;
                    case "Search":
                        $('.Div_D').css('display', 'none');
                        $('#Div_DT_View').css('width', '100%');
                        $('#Div_DT_View').css('display', '');
                        $('#BT_Cancel').css('display', '');

                        $('.onlyEdit').css('display', 'none');
                        $('.modeButton').css('display', 'none')
                        if (Edit_Mode == "Edit") {
                            $('#Div_EDIT_Data').css('display', '');
                            $('#Div_DT_View').css('width', '60%');

                            $('.onlyEdit').css('display', '');
                            $('#BT_EDIT_SAVE').css('display', 'inline-block');
                            $('#BT_EDIT_CANCEL').css('display', 'inline-block');
                        }

                        V_BT_CHG($('#BT_BASE'));
                        break;
                    case "RPT":
                        $('.Div_D').css('display', 'none');
                        $('#Div_DT_View').css('width', '60%');
                        $('#Div_RPT_DETAIL').css('display', '');

                        V_BT_CHG($('#BT_RPT'));
                        break;
                }
            }

            function ClickToEdit(click_tr) {
                $('#BT_Update').css('display', '');

                //點擊賦予顏色
                $('#Table_Search_Data > tbody tr').removeClass("tableClick");
                click_tr.addClass("tableClick");
                var clickData = $('#Table_Search_Data').DataTable().row(click_tr).data();

                //Edit page
                for (var i = 0; i < $('#Table_Search_Data').DataTable().columns().header().length; i++) {
                    var titleName = $($('#Table_Search_Data').DataTable().column(i).header()).text();

                    if ($("[DT_Fill_Name='" + titleName + "']").attr('type') == 'checkbox') {
                        $("[DT_Fill_Name='" + titleName + "']").prop('checked', clickData[titleName] == 1 || clickData[titleName] == '是');
                    }
                    else {
                        $("[DT_Fill_Name='" + titleName + "']").val(clickData[titleName]);
                    }
                }
            }

            function V_BT_CHG(buttonChs) {
                $('.V_BT').attr('disabled', false);
                buttonChs.attr('disabled', 'disabled');
            }

            //ajax function
            function Search() {
                var dataReq = {};
                dataReq['Call_Type'] = 'Search';

                //組json data
                $('.queryColumn').each(function () {
                    if ($(this).attr('type') == 'checkbox') {
                        dataReq[$(this).attr('DT_Query_Name')] = ($(this).is(':checked') ? '1' : '0');
                    }
                    else {
                        dataReq[$(this).attr('DT_Query_Name')] = $(this).val();
                    }
                });

                $.ajax({
                    url: apiUrl,
                    data: dataReq,
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
                            $('#Table_Search_Data').DataTable({
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
                                    { data: "序號", title: "序號" },
                                    { data: "INVOICE", title: "INVOICE" },
                                    { data: "樣品號碼", title: "樣品號碼" },
                                    { data: "客戶簡稱", title: "客戶簡稱" },
                                    { data: "頤坊型號", title: "頤坊型號" },
                                    { data: "價格待通知", title: "價格待通知" },
                                    { data: "單位", title: "單位" },
                                    { data: "出貨數量", title: "出貨數量" },
                                    { data: "FREE", title: "FREE" },
                                    { data: "廠商簡稱", title: "廠商簡稱" },
                                    { data: "更新人員", title: "<%=Resources.MP.Update_User%>" },
                                    { data: "更新日期", title: "<%=Resources.MP.Update_Date%>" },
                                    { data: "SUPLU_SEQ", title: "SUPLU_SEQ", visible: false },
                                    { data: "客戶編號", title: "客戶編號", visible: false },
                                    { data: "暫時型號", title: "暫時型號", visible: false },
                                    { data: "產品說明", title: "產品說明", visible: false },
                                    { data: "單位", title: "單位", visible: false },
                                    { data: "廠商編號", title: "廠商編號", visible: false },
                                    { data: "美元單價", title: "美元單價", visible: false },
                                    { data: "台幣單價", title: "台幣單價", visible: false },
                                    { data: "出貨數量", title: "出貨數量", visible: false },
                                    { data: "ATTN", title: "ATTN", visible: false },
                                    { data: "箱號", title: "箱號", visible: false },
                                    { data: "淨重", title: "淨重", visible: false },
                                    { data: "毛重", title: "毛重", visible: false },
                                    { data: "備貨數量", title: "備貨數量", visible: false },
                                    { data: "價格待通知", title: "價格待通知", visible: false }
                                ],
                                columnDefs: [{
                                    targets: [0],
                                    createdCell: function (td, cellData, rowData, row, col) { //操作dom元素
                                    },
                                    className: "text-center",// 新增class
                                }],
                                "order": [[1, "asc"]], //根據 INVOICE 排序
                                "scrollX": true,
                                "scrollY": "62vh",
                                "searching": false,
                                "paging": false,
                                "bInfo": false //顯示幾筆隱藏
                            });

                            $('#Table_Search_Data').DataTable().draw();
                            $('#Table_Search_Data_info').text('Showing ' + $('#Table_Search_Data > tbody tr[role=row]').length + ' entries');
                        }
                    },
                    error: function (ex) {
                        console.log(ex.responseText);
                        alert('查詢有誤請通知資訊人員');
                    }
                });
            };

            //更新DB
            function UPD_Invu() {
                if ($('#E_IMPORT_BANK').val() == 'HK台' && ($('#E_CUST_NO').val() == '1914C' || $('#E_CUST_NO').val() == '14N9C') || $('#E_CUST_NO').val() == '1380C')
                {
                    alert('匯入銀行選擇錯誤 ! 此客戶禁用私人銀行帳戶 !');
                    return;
                }

                var dataReq = {};
                dataReq['Call_Type'] = 'UPD';
                dataReq['SEQ'] = $('#E_SEQ').val();

                //組json data
                $('.updColumn').each(function () {
                    if ($(this).attr('type') == 'checkbox') {
                        dataReq[$(this).attr('DT_Fill_Name')] = ($(this).is(':checked') ? '1' : '0');
                    }
                    else {
                        dataReq[$(this).attr('DT_Fill_Name')] = $(this).val();
                    }
                });

                if ($('#E_SEQ').val() === '') {
                    alert('請選擇要修改的資料');
                }
                else{
                    $.ajax({
                        url: apiUrl,
                        data: dataReq,
                        cache: false,
                        type: "POST",
                        datatype: "json",
                        contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                        success: function (response, status) {
                            console.log(status);
                            if (status === 'success') {
                                alert('INVOICE:' + $('#E_INVOICE').val() + '已修改完成');

                                Search();
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

            //TABLE 功能設定
            $('#Table_Search_Data').on('click', 'tbody tr', function () {
                ClickToEdit($(this));
            });

            //BUTTON CLICK EVENT BASE 頁
            $('#BT_Search').on('click', function () {
                Search();
                Form_Mode_Change("Search");
            });

            $('#BT_Cancel').on('click', function () {
                Edit_Mode = "Base";

                var Confirm_Check = confirm("<%=Resources.MP.Cancel_Alert%>");
                if (Confirm_Check) {
                    $('#Table_Search_Data').DataTable().clear().draw();
                    Form_Mode_Change("Base");
                }
            });

            $('#BT_EDIT_SAVE').on('click', function () {
                UPD_Invu();
            });

            $('#BT_Update').on('click', function () {
                Edit_Mode = "Edit";
                Form_Mode_Change("Search");

                if ($('#Table_Search_Data > tbody tr.tableClick').length == 0) {
                    ClickToEdit($('#Table_Search_Data > tbody > tr:nth(0)'));
                }
            });

            $('#BT_EDIT_CANCEL').on('click', function () {
                Edit_Mode = "Search";
                Form_Mode_Change("Search");
            });

            //報表頁
            $('#BT_PRINT').on('click', function () {
                PRINT_RPT();
            });
            
            //功能選單
            $('#BT_BASE').on('click', function () {
                if ($('#Table_Search_Data > tbody tr[role=row]').length > 0 || $('#Table_CHS_Data > tbody tr[role=row]').length > 0)
                {
                    Form_Mode_Change('Search');
                }
                else {
                    Form_Mode_Change("Base");
                }
            });    

            $('#BT_RPT').on('click', function () {
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
                <td class="tdhstyle">INVOICE</td>
                <td class="tdbstyle">
                    <input id="Q_INVOICE" DT_Query_Name="INVOICE"  class="textbox_char queryColumn" />
                </td>
                <td class="tdhstyle">樣品號碼</td>
                <td class="tdbstyle">
                    <input id="Q_SAMPLE_NO" DT_Query_Name="樣品號碼" class="textbox_char queryColumn" />
                </td>
                <td class="tdhstyle">頤坊型號</td>
                <td class="tdbstyle">
                    <input id="Q_IVAN_TYPE" DT_Query_Name="頤坊型號"  class="textbox_char queryColumn" />
                </td>
            </tr>
            <tr class="trstyle">
                <td class="tdhstyle" >客戶編號</td>
                <td class="tdbstyle">
                    <input id="Q_CUST_NO" DT_Query_Name="客戶編號"  class="textbox_char queryColumn"  />
                </td>
                <td class="tdhstyle">客戶簡稱</td>
                <td class="tdbstyle">
                    <input id="Q_CUST_S_NAME" DT_Query_Name="客戶簡稱"  class="textbox_char queryColumn" />
                </td>
                <td class="tdhstyle">更新日期</td>
                <td class="tdbstyle">
                    <input id="Q_UPD_DATE_S" type="date" class="date_S_style queryColumn" DT_Query_Name="更新日期_S"  />~<input id="Q_UPD_DATE_E" type="date" class="date_E_style queryColumn" DT_Query_Name="更新日期_E" />
                </td>
            </tr>
            <tr class="trstyle">
                <td class="tdhstyle" >廠商編號</td>
                <td class="tdbstyle">
                    <input id="Q_FACT_NO"  class="textbox_char queryColumn" DT_Query_Name="廠商編號" />
                </td>
                <td class="tdhstyle">廠商簡稱</td>
                <td class="tdbstyle">
                    <input id="Q_FACT_S_NAME"  class="textbox_char queryColumn" DT_Query_Name="廠商簡稱" />
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
            <input type="button" id="BT_BASE" class="V_BT" value="主檔"  disabled="disabled" />
            <input type="button" id="BT_RPT" class="V_BT" value="報表" />
        </div>

        <div id="Div_DT">
            <div id="Div_DT_View" style=" width:60%;height:71vh; border-style:solid;border-width:1px; float:left;">
                <div class="dataTables_info" id="Table_Search_Data_info" role="status" aria-live="polite"></div>
                <table id="Table_Search_Data" class="Table_Search table table-striped table-bordered">
                    <thead style="white-space:nowrap"></thead>
                    <tbody style="white-space:nowrap"></tbody>
                </table>
            </div>
    
            <div id="Div_EDIT_Data" class=" Div_D" style="width:35%; height:71vh;white-space:nowrap; border-style:solid; border-width:1px;  float:right; overflow:auto">
                <table class="edit_section_control">
                    <tr class="trstyle"> 
                        <td class="tdbstyle" style="height: 2vh; font-size: smaller;" >&nbsp</td>
                    </tr>
                    <tr class="trstyle onlyEdit" >
                        <td class="tdEditstyle">序號</td>
                        <td class="tdbstyle">
                            <input id="E_SEQ" DT_Fill_Name="序號" class="textbox_char" disabled="disabled" />
                            <input id="E_SUPLU_SEQ" type="hidden" DT_Fill_Name="SUPLU_SEQ" class="textbox_char" />
                            <input id="E_PACK_PRE_CNT" type="hidden" DT_Fill_Name="備貨數量" class="textbox_char" />
                        </td>
                        <td class="tdEditstyle">INVOICE</td>
                        <td class="tdbstyle">
                            <input id="E_INVOICE" DT_Fill_Name="INVOICE" class="textbox_char" disabled="disabled" />
                        </td>
                    </tr>
                    <tr class="trstyle">
                        <td class="tdEditstyle">客戶編號</td>
                        <td class="tdbstyle">
                            <input id="E_CUST_NO" DT_Fill_Name="客戶編號"  class="textbox_char" disabled="disabled" />
                        </td>
                        <td class="tdEditstyle">客戶簡稱</td>
                        <td class="tdbstyle">
                            <input id="E_CUST_S_NAME" DT_Fill_Name="客戶簡稱"  class="textbox_char" disabled="disabled" />
                        </td>
                    </tr>
                     <tr class="trstyle">
                        <td class="tdEditstyle">頤坊型號</td>
                        <td class="tdbstyle">
                            <input id="E_IVAN_TYPE" DT_Fill_Name="頤坊型號"  class="textbox_char" disabled="disabled" />
                        </td>
                        <td class="tdEditstyle">暫時型號</td>
                        <td class="tdbstyle">
                            <input id="E_TMP_TYPE" DT_Fill_Name="暫時型號"  class="textbox_char" disabled="disabled" />
                        </td>
                    </tr>
                     <tr class="trstyle">
                        <td class="tdEditstyle">單位</td>
                        <td class="tdbstyle">
                            <input id="E_UNIT" DT_Fill_Name="單位"  class="textbox_char" disabled="disabled" />
                        </td>
                        <td class="tdEditstyle">產品說明</td>
                        <td class="tdbstyle">
                            <input id="E_TMP_TYPE" DT_Fill_Name="暫時型號"  class="textbox_char" disabled="disabled" />
                        </td>
                    </tr>
                    <tr class="trstyle onlyEdit">
                        <td class="tdEditstyle">廠商編號</td>
                        <td class="tdbstyle">
                            <input id="E_FACT_NO" DT_Fill_Name="廠商編號"  class="textbox_char" disabled="disabled" />
                        </td>
                        <td class="tdEditstyle">廠商簡稱</td>
                        <td class="tdbstyle">
                            <input id="E_FACT_S_NAME" DT_Fill_Name="廠商編號"  class="textbox_char" disabled="disabled" />
                        </td>
                    </tr>
                    <tr class="trstyle onlyEdit">
                        <td class="tdEditstyle">美元單價</td>
                        <td class="tdbstyle">
                            <input id="E_USD" type="number" DT_Fill_Name="美元單價" class="textbox_char " disabled="disabled" />
                        </td>
                        <td class="tdEditstyle">台幣單價</td>
                        <td class="tdbstyle">
                            <input id="E_NTD" type="number" DT_Fill_Name="台幣單價"  class="textbox_char " disabled="disabled" />
                        </td>
                    </tr>
                    <tr class="trstyle onlyEdit">
                        <td class="tdEditstyle">出貨數量</td>
                        <td class="tdbstyle">
                            <input id="E_PACK_CNT" type="number" DT_Fill_Name="出貨數量" class="textbox_char  updColumn"  />
                        </td>
                        <td class="tdEditstyle">ATTN</td>
                        <td class="tdbstyle">
                            <input id="E_ATTN" DT_Fill_Name="ATTN" class="textbox_char  updColumn"  />
                        </td>
                    </tr>
                     <tr class="trstyle onlyEdit">
                        <td class="tdEditstyle">FREE</td>
                        <td class="tdbstyle">
                            <input id="E_FREE" type="checkbox" DT_Fill_Name="FREE" class="textbox_char updColumn"  />
                        </td>
                        <td class="tdEditstyle">價格待通知</td>
                        <td class="tdbstyle">
                             <input id="E_WAIT_AMT" type="checkbox" DT_Fill_Name="價格待通知" class="textbox_char updColumn"  />
                        </td>
                    </tr>
                     <tr class="onlyEdit">
                        <td colspan="4" style="color:red">以下欄位以箱號為單位 修改</td>
                    </tr>
                     <tr class="trstyle onlyEdit">
                        <td class="tdEditstyle">箱號</td>
                        <td class="tdbstyle">
                            <input id="E_PACK_NO" DT_Fill_Name="箱號" class="textbox_char updColumn"  />
                        </td>
                    </tr>
                    <tr class="trstyle onlyEdit">
                        <td class="tdEditstyle">淨重</td>
                        <td class="tdbstyle">
                            <input id="E_NET_WEIGHT" type="number" DT_Fill_Name="淨重" class="textbox_char updColumn"  />
                        </td>
                        <td class="tdEditstyle">毛重</td>
                        <td class="tdbstyle">
                            <input id="E_WEIGHT" type="number" DT_Fill_Name="毛重"  class="textbox_char updColumn" />
                        </td>
                    </tr>
                    <tr class="trstyle onlyEdit">
                        <td class="tdEditstyle">更新人員</td>
                        <td class="tdbstyle">
                            <input id="E_UPD_USER" DT_Fill_Name="更新人員" class="textbox_char " disabled="disabled" />
                        </td>
                        <td class="tdEditstyle">更新日期</td>
                        <td class="tdbstyle">
                            <input id="E_UPD_DATE" type="date" DT_Fill_Name="更新日期" class="date_S_style " disabled="disabled" />
                        </td>
                    </tr>
                    <tr class="trstyle"> 
                        <td class="tdbstyle" style="height: 8vh; font-size: smaller;" >&nbsp</td>
                    </tr>
                     <tr class="trCenterstyle"> 
                         <td colspan="4" style="text-align:center" >
                            <input type="button" id="BT_EDIT_SAVE" style="display:inline-block" class="BTN modeButton" value="修改儲存"  />
                            <input type="button" id="BT_EDIT_CANCEL" style="display:inline-block" class="BTN modeButton" value="返回"  />
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
                        <td class="tdbstyle" style="font-size:20px;">
                            <select id="R_RPT_TYPE" >
                                <option selected="selected" value="0">INVOICE</option>
                                <option value="1">PACKING</option>
                            </select>
                         </td>
                    </tr>
                    <tr class="trCenterstyle" >
                        <td class="tdhstyle" style="font-size:20px;" >INVOICE</td>
                        <td class="tdbstyle" style="font-size:20px;">
                            <input id="R_INVOICE" style="font-size:20px;" class="textbox_char" />
                        </td>
                    </tr>
                     <tr class="trstyle"> 
                        <td class="tdbstyle" style="height: 10vh; font-size: smaller;" >&nbsp</td>
                    </tr>
                     <tr class="trCenterstyle"> 
                         <td colspan="2" style="text-align:center" >
                            <input type="button" id="BT_PRINT" style="display:inline-block" class="BTN" value="列印"  />
                         </td>
                    </tr>

                </table>
            </div> 
        </div>
    </div>

</asp:Content>
