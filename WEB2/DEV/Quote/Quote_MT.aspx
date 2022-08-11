<%@ Page Title="報價作業維護" Language="C#" MasterPageFile="~/MP.master" AutoEventWireup="true" CodeFile="Quote_MT.aspx.cs" Inherits="Quote_MT" %>
<%@ Register TagPrefix="uc" TagName="uc1" Src="~/User_Control/Dia_Customer_Selector.ascx" %>
<%@ Register TagPrefix="uc2" TagName="uc2" Src="~/User_Control/Dia_Product_Selector.ascx" %>
<%@ Register TagPrefix="uc3" TagName="uc3" Src="~/User_Control/Dia_Duo_Datetime_Picker.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="/css/dataTables.bootstrap4.min.css" rel="stylesheet" />
    <script src="/js/jquery.dataTables.min.js"></script>
    <script src="/js/dataTables.bootstrap4.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            var Edit_Mode;
            var apiUrl = "/DEV/Quote/Ashx/Quote_MT.ashx";
            //隱藏滾動卷軸
            //document.body.style.overflow = 'hidden';

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

            $('#BT_E_IVAN_TYPE').on('click', function () {
                $("#Search_Product_Dialog").dialog('open');
            });

            $('#SPD_Table_Product').on('click', '.PROD_SEL', function () {
                $('#E_IVAN_TYPE').val($(this).parent().parent().find('td:nth(3)').text());
                $('#E_FACT_NO').val($(this).parent().parent().find('td:nth(4)').text());
                $('#E_FACT_S_NAME').val($(this).parent().parent().find('td:nth(5)').text());
                $('#E_UNIT').val($(this).parent().parent().find('td:nth(5)').text());
                $('#E_PROD_DESC').val($(this).parent().parent().find('td:nth(7)').text());

                $("#Search_Product_Dialog").dialog('close');
            });

            //$('#Q_QUAH_DATE_S').val($.datepicker.formatDate('yy-mm-dd', new Date()));
            //$('#Q_QUAH_DATE_E').val($.datepicker.formatDate('yy-mm-dd', new Date()));          

            window.document.body.onbeforeunload = function () {
                if (Edit_Mode === "Edit") {
                    return '您尚未將編輯過的表單資料送出，請問您確定要離開網頁嗎？';
                }
            }

            //上下移功能 根據每個頁面客製
            $(document).keydown(function (event) {
                var key = (event.keyCode ? event.keyCode : event.which);
                var clickIndex = $('#Table_Search_Quote > tbody > tr.tableClick').index();
                if (key == '40') {
                    if (clickIndex < $('#Table_Search_Quote tbody tr').length - 1) {
                        clickIndex++;
                        ClickToEdit($('#Table_Search_Quote > tbody > tr:nth(' + clickIndex + ')'));
                    }
                }
                else if (key == '38') {
                    if (clickIndex > 0) {
                        clickIndex--;
                        ClickToEdit($('#Table_Search_Quote > tbody > tr:nth(' + clickIndex + ')'));
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
              
                        V_BT_CHG($('#BT_BASE'));
                        break;
                    case "Search":
                        $('.Div_D').css('display', 'none');
                        $('#Div_EDIT_Data').css('display', '');
                        $('#Div_DT_View').css('display', '');
                        $('#BT_Cancel').css('display', '');

                        V_BT_CHG($('#BT_BASE'));
                        break;
                    case "RPT":
                        $('.Div_D').css('display', 'none');
                        $('#Div_RPT_DETAIL').css('display', '');

                        V_BT_CHG($('#BT_REMARK'));
                        break;
                    case "IMG":
                        $('.Div_D').css('display', 'none');
                        $('#Div_IMG_DETAIL').css('display', '');

                        V_BT_CHG($('#BT_IMG'));
                        break;
                }
            }

            function ClickToEdit(click_tr) {

                //點擊賦予顏色
                $('#Table_Search_Quote > tbody tr').removeClass("tableClick");
                click_tr.addClass("tableClick");

                var clickData = $('#Table_Search_Quote').DataTable().row(click_tr).data();

                //Edit page
                $('#E_SEQ').val(clickData['序號']);
                $('#E_QUAH_NO').val(clickData['報價單號']);
                $('#E_QUAH_DATE').val(clickData['報價日期'].substr(0, 10));
                $('#E_CUST_NO').val(clickData['客戶編號']);
                $('#E_CUST_S_NAME').val(clickData['客戶簡稱']);
                $('#E_IVAN_TYPE').val(clickData['頤坊型號']);
                $('#E_PROD_DESC').val(clickData['產品說明']);
                $('#E_FACT_NO').val(clickData['廠商編號']);
                $('#E_FACT_S_NAME').val(clickData['廠商簡稱']);
                $('#E_MIN_1').val(clickData['基本量_1']);
                $('#E_USD').val(clickData['美元單價']);
                $('#E_UNIT').val(clickData['單位']);
                $('#E_NTD').val(clickData['台幣單價']);
                $('#E_MIN_2').val(clickData['基本量_2']);
                $('#E_PRICE_2').val(clickData['單價_2']);
                $('#E_MIN_3').val(clickData['基本量_3']);
                $('#E_PRICE_3').val(clickData['單價_3']);
                $('#E_MIN_4').val(clickData['基本量_4']);
                $('#E_PRICE_4').val(clickData['單價_4']);
                $('#E_S_FROM').val(clickData['出貨地']);
                $('#E_UPD_USER').val(clickData['更新人員']);
                $('#E_UPD_DATE').val(clickData['更新日期'].substr(0, 10));

                //RPT page
                $('#R_QUAH_NO').val(clickData['報價單號']);
                $('#R_RPT_REMARK').val(clickData['大備註']);

                //IMG page
                $('#I_IVAN_TYPE').val(clickData['頤坊型號']);
                $('#I_FACT_NO').val(clickData['廠商編號']);
                $('#I_FACT_S_NAME').val(clickData['廠商簡稱']);
                $('#I_PROD_DESC').val(clickData['產品說明']);
                $('#I_RPT_REMARK').val(clickData['大備註']);
                Search_IMG(clickData['BYRLU_SEQ']);
            }
            
            function V_BT_CHG(buttonChs) {
                $('.V_BT').attr('disabled', false);
                buttonChs.attr('disabled', 'disabled');
            }

            //ajax function
            function Search_Quote() {
                $.ajax({
                    url: apiUrl,
                    data: {
                        "Call_Type": "Quote_Base",
                        "IVAN_TYPE": $('#Q_IVAN_TYPE').val(),
                        "QUAH_DATE_S": $('#Q_QUAH_DATE_S').val(),
                        "QUAH_DATE_E": $('#Q_QUAH_DATE_E').val(),
                        "CUST_NO": $('#Q_CUST_NO').val(),
                        "CUST_S_NAME": $('#Q_CUST_S_NAME').val(),
                        "QUAH_NO": $('#Q_QUAH_NO').val(),
                        "FACT_NO": $('#Q_FACT_NO').val(),
                        "FACT_S_NAME": $('#Q_FACT_S_NAME').val(),
                        "PROD_DES": $('#Q_PROD_DES').val()
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
                            $('#Table_Search_Quote').DataTable({
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
                                    { data: "報價單號", title: "報價單號" },
                                    { data: "報價日期", title: "報價日期" },
                                    { data: "客戶簡稱", title: "客戶簡稱" },
                                    { data: "頤坊型號", title: "頤坊型號" },
                                    { data: "單位", title: "單位" },
                                    { data: "美元單價", title: "美元單價" },
                                    { data: "基本量_1", title: "基本量_1" },
                                    { data: "廠商簡稱", title: "廠商簡稱" },
                                    { data: "台幣單價", title: "台幣單價" },
                                    { data: "產品說明", title: "產品說明" },
                                    { data: "廠商編號", title: "廠商編號" },
                                    { data: "客戶編號", title: "客戶編號" },
                                    { data: "基本量_2", title: "基本量_2" },
                                    { data: "基本量_3", title: "基本量_3" },
                                    { data: "基本量_4", title: "基本量_4" },
                                    { data: "單價_2", title: "單價_2" },
                                    { data: "單價_3", title: "單價_3" },
                                    { data: "單價_4", title: "單價_4" },
                                    { data: "出貨地", title: "出貨地" },
                                    { data: "更新人員", title: "<%=Resources.MP.Update_User%>" },
                                    { data: "更新日期", title: "<%=Resources.MP.Update_Date%>" },
                                    { data: "大備註", title: "大備註", visible: false },
                                    { data: "BYRLU_SEQ", title: "BYRLU_SEQ", visible: false }
                                ],
                                "columnDefs": [
                                    {
                                        className: 'text-right', targets: [6,7,9,13,14,15,16,17,18] //數字靠右
                                    },
                                ],
                                "order": [[1, "asc"]], //根據 報價單號 排序
                                "scrollX": true,
                                "scrollY": "62vh",
                                "searching": false,
                                "paging": false,
                                "bInfo": false //顯示幾筆隱藏
                            });

                            $('#Table_Search_Quote').DataTable().draw();
                            $('#Table_Search_Quote_info').text('Showing ' + $('#Table_Search_Quote > tbody tr[role=row]').length + ' entries');
                        }
                    },
                    error: function (ex) {
                        alert(ex);
                    }
                });
            };        

            function Search_IMG(priceSeq) {
                $.ajax({
                    url: "/CommonAshx/Common.ashx",
                    data: {
                        "Call_Type": "GET_IMG_BY_BYRLU_SEQ",
                        "SEQ": priceSeq
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

            //更新印表備註
            function UPD_RPT_REMARK() {

                $.ajax({
                    url: apiUrl,
                    data: {
                        "Call_Type": "UPD_RPT_REMARK",
                        "QUAH_NO": $('#R_QUAH_NO').val(),
                        "RPT_REMARK": $('#R_RPT_REMARK').val()
                    },
                    cache: false,
                    type: "POST",
                    datatype: "json",
                    contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                    success: function (response, status) {
                        if (status === 'success') {
                            alert('報價單號:' + $('#R_QUAH_NO').val() + '已修改完成');
                        }
                        else {
                            alert('修改資料有誤請通知資訊人員');
                        }
                    },
                    error: function (ex) {
                        alert(ex);
                    }
                });
            };        

            //更新DB
            function UPD_QUAH() {
                if ($('#E_SEQ').val() === '') {
                    alert('請選擇要修改的資料');
                }
                else{
                    $.ajax({
                        url: apiUrl,
                        data: {
                            "Call_Type": "UPD_QUAH",
                            "SEQ": $('#E_SEQ').val(),
                            "QUAH_NO": $('#E_QUAH_NO').val(),
                            "QUAH_DATE": $('#E_QUAH_DATE').val(),
                            "CUST_NO": $('#E_CUST_NO').val(),
                            "CUST_S_NAME": $('#E_CUST_S_NAME').val(),
                            "IVAN_TYPE": $('#E_IVAN_TYPE').val(),
                            "PROD_DESC": $('#E_PROD_DESC').val(),
                            "FACT_NO": $('#E_FACT_NO').val(),
                            "FACT_S_NAME": $('#E_FACT_S_NAME').val(),
                            "MIN_1": $('#E_MIN_1').val(),
                            "USD": $('#E_USD').val(),
                            "UNIT": $('#E_UNIT').val(),
                            "NTD": $('#E_NTD').val(),
                            "MIN_2": $('#E_MIN_2').val(),
                            "PRICE_2": $('#E_PRICE_2').val(),
                            "MIN_3": $('#E_MIN_3').val(),
                            "PRICE_3": $('#E_PRICE_3').val(),
                            "MIN_4": $('#E_MIN_4').val(),
                            "PRICE_4": $('#E_PRICE_4').val(),
                            "S_FROM": $('#E_S_FROM').val(),
                            "UPD_USER": $('#E_UPD_USER').val(),
                            "UPD_DATE": $('#E_UPD_DATE').val()
                        },
                        cache: false,
                        type: "POST",
                        datatype: "json",
                        contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                        success: function (response, status) {
                            console.log(status);
                            if (status === 'success') {
                                alert('序號:' + $('#E_SEQ').val() + '已修改完成');

                                Search_Quote();
                            }
                            else {
                                alert('修改資料有誤請通知資訊人員');
                            }
                        },
                        error: function (ex) {
                            alert(ex);
                            return;
                        }
                    });
                }
            };           

            //TABLE 功能設定
            $('#Table_Search_Quote').on('click', 'tbody tr', function () {
                ClickToEdit($(this));
            });

            //BUTTON CLICK EVENT BASE 頁
            $('#BT_Search').on('click', function () {
                Edit_Mode = "Base";
                Form_Mode_Change("Search");
                Search_Quote();
            });

            $('#BT_Cancel').on('click', function () {
                $('#Table_Search_Quote').DataTable().clear().draw();

                var Confirm_Check = confirm("<%=Resources.MP.Cancel_Alert%>");
                if (Confirm_Check) {
                    Edit_Mode = "Base";
                    Form_Mode_Change("Base");
                }
            });

            $('#BT_EDIT').on('click', function () {
                UPD_QUAH();
            });

            $('#BT_RPT_SETTING').on('click', function () {
                UPD_RPT_REMARK();
            });
      
            //功能選單
            $('#BT_BASE').on('click', function () {
                Edit_Mode = "Base";
                if ($('#Table_Search_Quote > tbody tr[role=row]').length > 0)
                {
                    Form_Mode_Change("Search");
                }
                else {
                    Form_Mode_Change("Base");
                }
            });    

            $('#BT_REMARK').on('click', function () {
                Form_Mode_Change("RPT");
            });       

            $('#BT_IMG').on('click', function () {
                Form_Mode_Change("IMG");
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
                <td class="tdhstyle">頤坊型號</td>
                <td class="tdbstyle">
                    <input id="Q_IVAN_TYPE"  class="textbox_char" />
                </td>
                <td class="tdhstyle">報價日期</td>
                <td class="tdbstyle">
                    <input id="Q_QUAH_DATE_S" type="date" class="date_S_style TB_DS" /><input id="Q_QUAH_DATE_E" type="date" class="date_E_style TB_DE" />
                    <input id="BT_Duo_Datetime_Picker" type="button" value="…" onclick="$('#Duo_Datetime_Picker_Dialog').dialog('open');" />
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
                <td class="tdhstyle">報價單號</td>
                <td class="tdbstyle">
                    <input id="Q_QUAH_NO"  class="textbox_char" />
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
                <td class="tdhstyle">產品說明</td>
                <td class="tdbstyle">
                    <input id="Q_PROD_DES" class="textbox_char" />
                </td>
            </tr>
            <tr class="trstyle">
                <td class="tdtstyleRight" colspan="6">
                    <input type="button" id="BT_Search" class="buttonStyle" value="<%=Resources.MP.Search%>" />
                    <input type="button" id="BT_Cancel" class="buttonStyle" value="<%=Resources.MP.Cancel%>" style="display: none;" />
                </td>
            </tr>
        </table>
        </div>
        <div class="button_change_section">
            &nbsp;
            <input type="button" id="BT_BASE" class="V_BT" value="主檔"  disabled="disabled" />
            <input type="button" id="BT_REMARK" class="V_BT" value="印表備註" />
            <input type="button" id="BT_IMG" class="V_BT" value="圖型" />
            <input type="button" class="V_BT" value="圖例" />
        </div>

        <div id="Div_DT">
            <div id="Div_DT_View" style=" width:60%; border-style:solid;border-width:1px; float:left;">
                <div class="dataTables_info" id="Table_Search_Quote_info" role="status" aria-live="polite"></div>
                <table id="Table_Search_Quote" class="Table_Search table table-striped table-bordered">
                    <thead style="white-space:nowrap"></thead>
                    <tbody style="white-space:nowrap"></tbody>
                </table>
            </div>
    
            <div id="Div_EDIT_Data" class=" Div_D" style="width:35%; height:71vh; border-style:solid; border-width:1px;  float:right;">
                <table class="edit_section_control">
                    <tr class="trstyle"> 
                        <td class="tdbstyle" style="height: 5vh; font-size: smaller;" >&nbsp</td>
                    </tr>
                    <tr class="trstyle" >
                        <td class="tdEditstyle">序號</td>
                        <td class="tdbstyle">
                            <input id="E_SEQ"  class="textbox_char" disabled="disabled" />
                        </td>
                        <td class="tdEditstyle"></td>
                        <td class="tdbstyle"></td>
                    </tr>
                    <tr class="trstyle">
                        <td class="tdEditstyle">報價單號</td>
                        <td class="tdbstyle">
                            <input id="E_QUAH_NO"  class="textbox_char" />
                        </td>
                        <td class="tdEditstyle">報價日期</td>
                        <td class="tdbstyle">
                            <input id="E_QUAH_DATE" type="date" class="date_S_style" />
                        </td>
                    </tr>
                    <tr class="trstyle">
                        <td class="tdEditstyle">客戶編號</td>
                        <td class="tdbstyle">
                            <input id="E_CUST_NO"  class="textbox_char" disabled="disabled" />
                            <input id="BT_CUST_CHS" style="font-size:15px" type="button" value="..." />
                        </td>
                        <td class="tdEditstyle">客戶簡稱</td>
                        <td class="tdbstyle">
                            <input id="E_CUST_S_NAME"  class="textbox_char" disabled="disabled" />
                        </td>
                    </tr>
                    <tr class="trstyle">
                        <td class="tdEditstyle">頤坊型號</td>
                        <td class="tdbstyle">
                            <input id="E_IVAN_TYPE"  class="textbox_char" />
                            <input id="BT_E_IVAN_TYPE" style="font-size:15px" type="button" value="..." />
                        </td>
                        <td class="tdhstyle"></td>
                        <td class="tdbstyle"></td>
                    </tr>
                    <tr class="trstyle">
                        <td class="tdEditstyle">產品說明</td>
                        <td class="tdbstyle" colspan ="4">
                            <input id="E_PROD_DESC" class="textbox_char" style="width:100%"  />
                        </td>
                    </tr>
                    <tr class="trstyle">
                        <td class="tdEditstyle">廠商編號</td>
                        <td class="tdbstyle">
                            <input id="E_FACT_NO"  class="textbox_char" />
                        </td>
                        <td class="tdEditstyle">廠商簡稱</td>
                        <td class="tdbstyle">
                            <input id="E_FACT_S_NAME" class="textbox_char" disabled="disabled"  />
                        </td>
                    </tr>
                    <tr class="trstyle">
                        <td class="tdEditstyle">基本量_1</td>
                        <td class="tdbstyle">
                            <input id="E_MIN_1" class="textbox_char" type="number" />
                        </td>
                        <td class="tdEditstyle">美元單價</td>
                        <td class="tdbstyle">
                            <input id="E_USD"  class="textbox_char" type="number" />
                        </td>
                    </tr>
                    <tr class="trstyle">
                        <td class="tdEditstyle">單位</td>
                        <td class="tdbstyle">
                            <input id="E_UNIT"  class="textbox_char" />
                        </td>
                        <td class="tdEditstyle">台幣單價</td>
                        <td class="tdbstyle">
                            <input id="E_NTD"  class="textbox_char" type="number" />
                        </td>
                    </tr>
                    <tr class="trstyle">
                        <td class="tdEditstyle">基本量_2</td>
                        <td class="tdbstyle">
                            <input id="E_MIN_2"  class="textbox_char" type="number" />
                        </td>
                        <td class="tdEditstyle">單價_2</td>
                        <td class="tdbstyle">
                            <input id="E_PRICE_2"  class="textbox_char" type="number" />
                        </td>
                    </tr>
                    <tr class="trstyle">
                         <td class="tdEditstyle">基本量_3</td>
                        <td class="tdbstyle">
                            <input id="E_MIN_3"  class="textbox_char" type="number" />
                        </td>
                        <td class="tdEditstyle">單價_3</td>
                        <td class="tdbstyle">
                            <input id="E_PRICE_3"  class="textbox_char" type="number" />
                        </td>
                    </tr>
                    <tr class="trstyle">
                        <td class="tdEditstyle">基本量_4</td>
                        <td class="tdbstyle">
                            <input id="E_MIN_4"  class="textbox_char" type="number" />
                        </td>
                        <td class="tdEditstyle">單價_4</td>
                        <td class="tdbstyle">
                            <input id="E_PRICE_4"  class="textbox_char" type="number" />
                        </td>
                    </tr>
                    <tr class="trstyle">
                        <td class="tdEditstyle">出貨地</td>
                        <td class="tdbstyle">
                            <select id="E_S_FROM">
                                <option selected="selected" value="1">1-台灣出貨</option>
                                <option value="2">2-香港出貨</option>
                                <option value="3">3-中國出貨</option>
                            </select>
                        </td>
                    </tr>
                    <tr class="trstyle">
                        <td class="tdEditstyle">更新人員</td>
                        <td class="tdbstyle">
                            <input id="E_UPD_USER"  class="textbox_char" disabled="disabled" />
                        </td>
                        <td class="tdEditstyle">更新日期</td>
                        <td class="tdbstyle">
                            <input id="E_UPD_DATE" type="date" class="date_S_style" disabled="disabled" />
                        </td>
                    </tr>
                    <tr class="trstyle"> 
                        <td class="tdbstyle" style="height: 10vh; font-size: smaller;" >&nbsp</td>
                    </tr>
                     <tr class="trCenterstyle"> 
                         <td colspan="4" style="text-align:center" >
                            <input type="button" id="BT_EDIT" style="display:inline-block" class="BTN" value="修改"  />
                         </td>
                    </tr>
                </table>
            </div>
            <div id="Div_RPT_DETAIL" class=" Div_D" style="width:35%;height:71vh; border-style:solid;border-width:1px; float:right; ">
                <table class="search_section_control">
                    <tr class="trstyle"> 
                        <td class="tdbstyle" style="height: 15vh; font-size: smaller;" >&nbsp</td>
                    </tr>
                    <tr class="trCenterstyle">
                        <td class="tdhstyle" style="font-size:20px;">報價單號</td>
                        <td class="tdbstyle">
                            <input id="R_QUAH_NO"  class="textbox_char" disabled="disabled" />
                        </td>
                    </tr>
                    <tr class="trstyle"> 
                        <td class="tdbstyle" style="height: 3vh; font-size: smaller;" >&nbsp</td>
                    </tr>
                    <tr class="trCenterstyle">
                        <td colspan="2">
                            <textarea id="R_RPT_REMARK" cols="40" rows="5"></textarea>
                        </td>
                    </tr>
                    <tr class="trstyle"> 
                        <td class="tdbstyle" style="height: 5vh; font-size: smaller;" >&nbsp</td>
                    </tr>
                     <tr class="trCenterstyle"> 
                         <td colspan="2" style="text-align:center" >
                            <input type="button" id="BT_RPT_SETTING" style="display:inline-block" class="BTN" value="修改"  />
                         </td>
                    </tr>

                </table>
            </div> 
            <div id="Div_IMG_DETAIL" class=" Div_D" style="width:35%;height:71vh; border-style:solid;border-width:1px; float:right; ">
                <table class="edit_section_control">
                     <tr class="trstyle"> 
                        <td class="tdbstyle" style="height: 5vh; font-size: smaller;" >&nbsp</td>
                    </tr>
                    <tr class="trstyle">
                        <td class="tdEditstyle">頤坊型號</td>
                        <td class="tdbstyle">
                            <input id="I_IVAN_TYPE" class="textbox_char"disabled="disabled"   />
                        </td>
                        <td class="tdEditstyle">廠商編號</td>
                        <td class="tdbstyle">
                            <input id="I_FACT_NO"  class="textbox_char" disabled="disabled"  />
                        </td>
                    </tr>
                    <tr class="trstyle">
                        <td class="tdEditstyle"></td>
                        <td class="tdbstyle"></td>
                        <td class="tdEditstyle">廠商簡稱</td>
                        <td class="tdbstyle" >
                            <input id="I_FACT_S_NAME" class="textbox_char" disabled="disabled"  />
                        </td>
                    </tr>
                    <tr class="trstyle">
                        <td class="tdEditstyle">產品說明</td>
                        <td class="tdbstyle" colspan="4">
                            <input id="I_PROD_DESC" class="textbox_char" style="max-width:100%; max-height:100%;" disabled="disabled" />
                        </td>
                    </tr>

                    <tr class="trstyle">
                        <td style="text-align:center" colspan="4">
                            <img id="I_IMG" src="#" style="display:none" />
                            <span id="I_NO_IMG" >查無圖檔</span>
                        </td>
                    </tr>

                </table>
            </div> 
        </div>
    </div>

</asp:Content>
