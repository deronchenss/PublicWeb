<%@ Page Title="樣品Invoice維護" Language="C#" MasterPageFile="~/MP.master" AutoEventWireup="true" CodeFile="Sample_Inv_MT.aspx.cs" Inherits="Sample_Inv_MT" %>
<%@ Register TagPrefix="uc" TagName="uc1" Src="~/User_Control/Dia_Customer_Selector.ascx" %>
<%@ Register TagPrefix="uc2" TagName="uc2" Src="~/User_Control/Dia_Transfer_Selector.ascx" %>
<%@ Register TagPrefix="uc3" TagName="uc3" Src="~/User_Control/Dia_Duo_Datetime_Picker.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="/css/dataTables.bootstrap4.min.css" rel="stylesheet" />
    <script src="/js/jquery.dataTables.min.js"></script>
    <script src="/js/dataTables.bootstrap4.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            var Edit_Mode;
            var apiUrl = "/Page/DEV/Sample/Ashx/Sample_Inv_MT.ashx";
            //隱藏滾動卷軸
            document.body.style.overflow = 'hidden';

            //init CONTROLER
            Form_Mode_Change("Base");

            //Dialog
            $('#BT_CUST_CHS').on('click', function () {
                $("#Search_Customer_Dialog").dialog('open');
            });

            $('#SCD_Table_Customer').on('click', '.CUST_SEL', function () {
                $('#E_CUST_NO').val($(this).parent().parent().find('td:nth(2)').text());
                $('#E_CUST_S_NAME').val($(this).parent().parent().find('td:nth(3)').text());
                $("#Search_Customer_Dialog").dialog('close');
            });

            $('#BT_TRANS_CHS').on('click', function () {
                $("#Search_Transfer_Dialog").dialog('open');
            });

            $('#SSD_Table_Transfer').on('click', '.SUP_SEL', function () {
                $('#E_TRANS_NO').val($(this).parent().parent().find('td:nth(1)').text());
                $('#E_TRANS_S_NAME').val($(this).parent().parent().find('td:nth(2)').text());
                $("#Search_Transfer_Dialog").dialog('close');
            });

            //DDL
            DDL_Bind();
            function DDL_Bind() {
                $.ajax({
                    url: "/Web_Service/DDL_DataBind.asmx/BankDDL",
                    cache: false,
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (data) {
                        var Json_Response = JSON.parse(data.d);
                        var DDL_Option = "<option></option>";
                        $.each(Json_Response, function (i, value) {
                            DDL_Option += '<option>' + value.txt + '</option>';
                        });
                        $('#E_IMPORT_BANK').html(DDL_Option);
                    },
                    error: function (response) {
                        alert(response.responseText);
                    },
                });
            };

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

                            $('#BT_CUST_CHS').toggle(false); //客戶編號只有INSERT 能選擇
                            $('.onlyEdit').css('display', '');
                            $('#BT_EDIT_SAVE').css('display', 'inline-block');
                            $('#BT_EDIT_CANCEL').css('display', 'inline-block');
                        }
                        else if (Edit_Mode == "Insert") {
                            $('#Div_EDIT_Data').css('display', '');
                            $('#Div_DT_View').css('width', '60%');

                            $('#BT_CUST_CHS').toggle(true);
                            $('#BT_INSERT_SAVE').css('display', 'inline-block');
                            $('#BT_INSERT_CLEAR').css('display', 'inline-block');
                            $('#BT_EDIT_CANCEL').css('display', 'inline-block');
                            $('.onlyEdit').css('display', 'none');
                            $('.editReset').val('');
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

                    if (titleName == '應稅' || titleName == '併大貨收款') {
                        $("[DT_Fill_Name='" + titleName + "']").prop('checked', clickData[titleName] == 1);
                    }
                    else {
                        $("[DT_Fill_Name='" + titleName + "']").val(clickData[titleName]);
                    }
                }

                //RPT PAGE
                $('#R_INVOICE').val(clickData['INVOICE']);
            }

            function V_BT_CHG(buttonChs) {
                $('.V_BT').attr('disabled', false);
                buttonChs.attr('disabled', 'disabled');
            }

            //ajax function
            function Search_Invu(invoice = '') {
                $.ajax({
                    url: apiUrl,
                    data: {
                        "Call_Type": "Search",
                        "INVOICE": invoice == '' ? $('#Q_INVOICE').val() : invoice,
                        "出貨日期_S": $('#Q_SHIP_GO_DATE_S').val(),
                        "出貨日期_E": $('#Q_SHIP_GO_DATE_E').val(),
                        "提單號碼": $('#Q_BILL_NO').val(),
                        "客戶編號": $('#Q_CUST_NO').val(),
                        "客戶簡稱": $('#Q_CUST_S_NAME').val(),
                        "更新日期_S": $('#Q_UPD_DATE_S').val(),
                        "更新日期_E": $('#Q_UPD_DATE_E').val()
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
                                    { data: "出貨日期", title: "出貨日期" },
                                    { data: "客戶編號", title: "客戶編號" },
                                    { data: "客戶簡稱", title: "客戶簡稱" },
                                    { data: "運輸簡稱", title: "運輸簡稱" },
                                    { data: "提單號碼", title: "提單號碼" },
                                    { data: "變更日期", title: "變更日期" },
                                    { data: "更新人員", title: "<%=Resources.MP.Update_User%>" },
                                    { data: "更新日期", title: "<%=Resources.MP.Update_Date%>" },
                                    { data: "運輸編號", title: "運輸編號", visible: false },
                                    { data: "銀行簡稱", title: "銀行簡稱", visible: false },
                                    { data: "備註業務", title: "備註業務", visible: false },
                                    { data: "應稅", title: "應稅", visible: false },
                                    { data: "併大貨收款", title: "併大貨收款", visible: false },
                                    //{ data: "淨重", title: "淨重", visible: false },
                                    //{ data: "毛重", title: "毛重", visible: false },
                                    { data: "發票匯率", title: "發票匯率", visible: false },
                                    { data: "應收樣品費", title: "應收樣品費", visible: false },
                                    { data: "應收樣品NT", title: "應收樣品NT", visible: false },
                                    { data: "應收運費", title: "應收運費", visible: false },
                                    { data: "應收運費NT", title: "應收運費NT", visible: false },
                                    { data: "已收金額", title: "已收金額", visible: false },
                                    { data: "已收金額NT", title: "已收金額NT", visible: false },
                                    { data: "已收日期", title: "已收日期", visible: false },
                                    { data: "未收金額", title: "未收金額", visible: false },
                                    { data: "備註會計", title: "備註會計", visible: false },
                                    { data: "備註_ivan", title: "備註_ivan", visible: false }
                                ],
                                "order": [[1, "asc"]], //根據 INVOICE 排序
                                "scrollX": true,
                                "scrollY": "62vh",
                                "searching": false,
                                "paging": false,
                                "bInfo": false //顯示幾筆隱藏
                            });

                            $('#Table_Search_Data').DataTable().draw();
                            $('#Table_Search_Data_info').text('Showing ' + $('#Table_Search_Data > tbody tr[role=row]').length + ' entries');

                            //新增發票完 轉至修改
                            if (invoice != '') {
                                ClickToEdit($('#Table_Search_Data > tbody > tr:nth(0)'));
                            }
                        }
                    },
                    error: function (ex) {
                        console.log(ex.responseText);
                        alert('查詢有誤請通知資訊人員');
                    }
                });
            };

            //新增資料
            function INSERT_Invu() {
                if ($('#E_CUST_NO').val() === '') {
                    alert('請選擇客戶編號');
                }
                else {
                    $.ajax({
                        url: apiUrl,
                        data: {
                            "Call_Type": "INSERT",
                            "CUST_NO": $('#E_CUST_NO').val(),
                            "CUST_S_NAME": $('#E_CUST_S_NAME').val(),
                            "UPD_USER": "<%=(Session["Account"] == null) ? "IVAN10" : Session["Account"].ToString().Trim() %>"
                        },
                        cache: false,
                        type: "POST",
                        datatype: "json",
                        contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                        success: function (response, status) {
                            if (status === 'success') {
                                alert('已新增發票號碼:' + response);

                                Edit_Mode = "Edit";
                                Form_Mode_Change("Search");
                                Search_Invu(response);
                            }
                            else {
                                alert('新增資料有誤請通知資訊人員');
                            }
                        },
                        error: function (ex) {
                            console.log(ex.responseText);
                            alert('新增資料有誤請通知資訊人員');
                            return;
                        }
                    });
                }
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
                dataReq['更新人員'] = "<%=(Session["Account"] == null) ? "IVAN10" : Session["Account"].ToString().Trim() %>";

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

                                Search_Invu();
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

            //產生報表
            function PRINT_RPT() {
                if ($('#R_INVOICE').val() === '') {
                    alert('請填寫INVOICE');
                }
                else {
                    $("body").loading(); // 遮罩開始
                    $.ajax({
                        url: apiUrl,
                        data: {
                            "Call_Type": "PRINT_RPT",
                            "INVOICE_NO": $('#R_INVOICE').val(),
                            "RPT_TYPE": $('#R_RPT_TYPE').val()
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
                                alert('INVOICE查無資料');
                            }
                            else if (status !== 'success')
                            {
                                alert(response);
                            }
                            else {
                                var blob = new Blob([response], { type: "application/pdf" });
                                var url = window.URL || window.webkitURL;
                                link = url.createObjectURL(blob);
                                var a = $("<a />");
                                switch ($('#R_RPT_TYPE').val()) {
                                    case "0":
                                        a.attr("download", "INVOICE.pdf");
                                        break;
                                    case "1":
                                        a.attr("download", "PACKING.pdf");
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
                            alert('下載報表有誤請通知資訊人員');
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
                Search_Invu();
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

            $('#BT_Insert').on('click', function () {
                $('#Table_Search_Data > tbody tr').removeClass("tableClick");
                Edit_Mode = "Insert";
                Form_Mode_Change("Search");
            });

            $('#BT_Update').on('click', function () {
                Edit_Mode = "Edit";
                Form_Mode_Change("Search");

                if ($('#Table_Search_Data > tbody tr.tableClick').length == 0) {
                    ClickToEdit($('#Table_Search_Data > tbody > tr:nth(0)'));
                }
            });

            $('#BT_INSERT_SAVE').on('click', function () {
                INSERT_Invu();
            });

            $('#BT_INSERT_CLEAR').on('click', function () {
                $('.editReset').val('');
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
    <uc:uc1 ID="uc1" runat="server" /> 
    <uc2:uc2 ID="uc2" runat="server" /> 
    <uc3:uc3 ID="uc3" runat="server" /> 
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
                    <input id="Q_INVOICE"  class="textbox_char" />
                </td>
                <td class="tdhstyle">出貨日期</td>
                <td class="tdbstyle">
                    <input id="Q_SHIP_GO_DATE_S" type="date" class="date_S_style TB_DS" /><input id="Q_SHIP_GO_DATE_E" type="date" class="date_E_style TB_DE" />
                    <input id="BT_Duo_Datetime_Picker" type="button" value="…" onclick="$('#Duo_Datetime_Picker_Dialog').dialog('open');" />
                </td>
                <td class="tdhstyle">提單號碼</td>
                <td class="tdbstyle">
                    <input id="Q_BILL_NO"  class="textbox_char" />
                </td>
            </tr>
            <tr class="trstyle">
                <td class="tdhstyle" >客戶編號</td>
                <td class="tdbstyle">
                    <input id="Q_CUST_NO"  class="textbox_char" />
                </td>
                <td class="tdhstyle">客戶簡稱</td>
                <td class="tdbstyle">
                    <input id="Q_CUST_S_NAME"  class="textbox_char" />
                </td>
                <td class="tdhstyle">更新日期</td>
                <td class="tdbstyle">
                    <input id="Q_UPD_DATE_S" type="date" class="date_S_style" /><input id="Q_UPD_DATE_E" type="date" class="date_E_style" />
                </td>
            </tr>
            <tr class="trstyle">
                <td class="tdtstyleRight" colspan="8">
                    <input type="button" id="BT_Search" class="buttonStyle" value="<%=Resources.MP.Search%>" />
                    <input type="button" id="BT_Insert" class="buttonStyle" value="<%=Resources.MP.Insert%>" />
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
                            <input id="E_SEQ" DT_Fill_Name="序號" class="textbox_char editReset" disabled="disabled" />
                            <input id="E_SUPLU_SEQ" type="hidden" class="textbox_char" />
                        </td>
                        <td class="tdEditstyle">INVOICE</td>
                        <td class="tdbstyle">
                            <input id="E_INVOICE" DT_Fill_Name="INVOICE" class="textbox_char editReset" disabled="disabled" />
                        </td>
                    </tr>
                    <tr class="trstyle">
                        <td class="tdEditstyle">客戶編號</td>
                        <td class="tdbstyle">
                            <input id="E_CUST_NO" DT_Fill_Name="客戶編號"  class="textbox_char editReset" disabled="disabled" />
                            <input id="BT_CUST_CHS" style="font-size:15px" type="button" value="..." />
                        </td>
                        <td class="tdEditstyle">客戶簡稱</td>
                        <td class="tdbstyle">
                            <input id="E_CUST_S_NAME" DT_Fill_Name="客戶簡稱"  class="textbox_char editReset" disabled="disabled" />
                        </td>
                    </tr>
                     <tr class="trstyle onlyEdit">
                        <td class="tdEditstyle">發票匯率</td>
                        <td class="tdbstyle">
                            <input id="E_INVOICE_RATE" DT_Fill_Name="發票匯率" type="number"  class="textbox_char editReset" disabled="disabled" />
                        </td>
                        <td class="tdEditstyle">出貨日期</td>
                        <td class="tdbstyle">
                            <input id="E_SHIP_GO_DATE" DT_Fill_Name="出貨日期" class="textbox_char editRestr updColumn" type="date" />
                        </td>
                    </tr>
                    <tr class="trstyle onlyEdit">
                        <td class="tdEditstyle">運輸編號</td>
                        <td class="tdbstyle">
                            <input id="E_TRANS_NO" DT_Fill_Name="運輸編號"  class="textbox_char editReset" disabled="disabled" />
                            <input id="BT_TRANS_CHS" style="font-size:15px"  type="button" value="..." />
                        </td>
                        <td class="tdEditstyle">運輸簡稱</td>
                        <td class="tdbstyle">
                            <input id="E_TRANS_S_NAME" DT_Fill_Name="運輸簡稱" class="textbox_char editReset" disabled="disabled"  />
                        </td>
                    </tr>
                    <tr class="trstyle onlyEdit">
                        <td class="tdEditstyle">提單號碼</td>
                        <td class="tdbstyle">
                            <input id="E_BILL_NO" DT_Fill_Name="提單號碼"  class="textbox_char editReset updColumn" />
                        </td>
                        <td class="tdEditstyle">銀行簡稱</td>
                        <td class="tdbstyle">
                            <select id="E_IMPORT_BANK" DT_Fill_Name="銀行簡稱" class="updColumn">
                                <option selected="selected" value=""></option>
                            </select>
                        </td>
                    </tr>
                    <tr class="trstyle onlyEdit">
                        <td class="tdEditstyle">印表備註</td>
                        <td class="tdbstyle" colspan ="4">
                            <input id="E_PRINT_REMARK" DT_Fill_Name="備註業務"  class="textbox_char editReset updColumn" style="width:80%"  />
                        </td>
                    </tr>
                    <tr class="trstyle onlyEdit">
                        <td class="tdEditstyle">應稅</td>
                        <td class="tdbstyle">
                            <input id="E_FAX_FLAG" type="checkbox" DT_Fill_Name="應稅"  class="textbox_char editReset updColumn"/>
                        </td>
                        <td class="tdEditstyle">併大貨收款</td>
                        <td class="tdbstyle">
                            <input id="E_BIG_SHIP_COLL" type="checkbox" DT_Fill_Name="併大貨收款" class="textbox_char editReset updColumn"  />
                        </td>
                    </tr>
<%--                    <tr class="trstyle onlyEdit">
                        <td class="tdEditstyle">淨重</td>
                        <td class="tdbstyle">
                            <input id="E_NET_WEIGHT" type="number" DT_Fill_Name="淨重" class="textbox_char editReset" disabled="disabled" />
                        </td>
                        <td class="tdEditstyle">毛重</td>
                        <td class="tdbstyle">
                            <input id="E_WEIGHT" type="number" DT_Fill_Name="毛重" class="textbox_char editReset" disabled="disabled"  />
                        </td>
                    </tr>--%>
                    <tr class="trstyle onlyEdit">
                        <td class="tdEditstyle">應收樣品費USD</td>
                        <td class="tdbstyle">
                            <input id="E_SAMPLE_AMT_USD" type="number" DT_Fill_Name="應收樣品費" class="textbox_char editReset" disabled="disabled" />
                        </td>
                        <td class="tdEditstyle">應收樣品費NTD</td>
                        <td class="tdbstyle">
                            <input id="E_SAMPLE_AMT_NTD" type="number" DT_Fill_Name="應收樣品NT"  class="textbox_char editReset" disabled="disabled" />
                        </td>
                    </tr>
                    <tr class="trstyle onlyEdit">
                        <td class="tdEditstyle">應收運費USD</td>
                        <td class="tdbstyle">
                            <input id="E_TRANS_AMT_USD" type="number" DT_Fill_Name="應收運費" class="textbox_char editReset updColumn"  />
                        </td>
                        <td class="tdEditstyle">應收運費NTD</td>
                        <td class="tdbstyle">
                            <input id="E_TRANS_AMT_NTD" type="number" DT_Fill_Name="應收運費NT" class="textbox_char editReset updColumn"  />
                        </td>
                    </tr>
                    <tr class="trstyle onlyEdit">
                        <td class="tdEditstyle">已收金額USD</td>
                        <td class="tdbstyle">
                            <input id="E_REC_AMT_USD" type="number" DT_Fill_Name="已收金額" class="textbox_char editReset" disabled="disabled" />
                        </td>
                        <td class="tdEditstyle">已收金額NTD</td>
                        <td class="tdbstyle">
                            <input id="E_REC_AMT_NTD" type="number" DT_Fill_Name="已收金額NT"  class="textbox_char editReset" disabled="disabled" />
                        </td>
                    </tr>
                    <tr class="trstyle onlyEdit">
                        <td class="tdEditstyle">已收日期</td>
                        <td class="tdbstyle">
                            <input id="E_REC_DATE" DT_Fill_Name="已收日期" class="textbox_char editReset updColumn" type="date" />
                        </td>
                        <td class="tdEditstyle">未收金額</td>
                        <td class="tdbstyle">
                            <input id="E_NOT_REC_AMT" DT_Fill_Name="未收金額" class="textbox_char editReset" disabled="disabled" type="number" />
                        </td>
                    </tr>
                    <tr class="trstyle onlyEdit">
                        <td class="tdEditstyle">備註_statment</td>
                        <td class="tdbstyle" colspan ="4">
                            <input id="E_REMARK_STATMENT"  DT_Fill_Name="備註會計" class="textbox_char editReset updColumn" style="width:80%"  />
                        </td>
                    </tr>        
                    <tr class="trstyle onlyEdit">
                        <td class="tdEditstyle">備註_IVAN</td>
                        <td class="tdbstyle" colspan ="4">
                            <input id="E_REMARK_IVAN" DT_Fill_Name="備註_ivan" class="textbox_char editReset updColumn" style="width:80%" />
                        </td>
                    </tr>     
                    <tr class="trstyle onlyEdit">
                        <td class="tdEditstyle">更新人員</td>
                        <td class="tdbstyle">
                            <input id="E_UPD_USER" DT_Fill_Name="更新人員" class="textbox_char editReset" disabled="disabled" />
                        </td>
                        <td class="tdEditstyle">更新日期</td>
                        <td class="tdbstyle">
                            <input id="E_UPD_DATE" type="date" DT_Fill_Name="更新日期" class="date_S_style editReset" disabled="disabled" />
                        </td>
                    </tr>
                    <tr class="trstyle"> 
                        <td class="tdbstyle" style="height: 8vh; font-size: smaller;" >&nbsp</td>
                    </tr>
                     <tr class="trCenterstyle"> 
                         <td colspan="4" style="text-align:center" >
                            <input type="button" id="BT_INSERT_SAVE" style="display:inline-block" class="BTN modeButton" value="新增儲存"  />
                            <input type="button" id="BT_EDIT_SAVE" style="display:inline-block" class="BTN modeButton" value="修改儲存"  />
                            <input type="button" id="BT_INSERT_CLEAR" style="display:inline-block" class="BTN modeButton" value="清空"  />
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
