<%@ Page Title="Quah MT" Language="C#" MasterPageFile="~/MP.master" AutoEventWireup="true" CodeFile="Quote_MT.aspx.cs" Inherits="Quote_MT" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="/css/dataTables.bootstrap4.min.css" rel="stylesheet" />
    <script src="/js/jquery.dataTables.min.js"></script>
    <script src="/js/dataTables.bootstrap4.min.js"></script>

    <script type="text/javascript">
        $(document).ready(function () {
            var Edit_Mode;
            var apiUrl = "/DEV/Quote/Quote_MT.ashx";
            //隱藏滾動卷軸
            //document.body.style.overflow = 'hidden';

            //init CONTROLER
            Form_Mode_Change("Base");

            $('#Q_QUAH_DATE_S').val($.datepicker.formatDate('yy-mm-dd', new Date()));
            $('#Q_QUAH_DATE_E').val($.datepicker.formatDate('yy-mm-dd', new Date()));          

            window.document.body.onbeforeunload = function () {
                if (Edit_Mode === "Edit") {
                    return '您尚未將編輯過的表單資料送出，請問您確定要離開網頁嗎？';
                }
            }

            //function region
            function Form_Mode_Change(Form_Mode) {
                switch (Form_Mode) {
                    case "Base":
                        $('.Div_D').css('display', 'none');
                        $('#BT_Cancel').css('display', 'none');
              
                        V_BT_CHG($('#BT_BASE'));
                        break;
                    case "Search":
                        $('.Div_D').css('display', 'none');
                        $('#Div_DT_Search').css('display', '');
                        $('#BT_Cancel').css('display', '');

                        V_BT_CHG($('#BT_BASE'));
                        break;
                    case "EXEC":
                        if ($('#Div_DT_Search').css("display") === 'none') {
                            alert('請先查詢');
                            Edit_Mode = "Base";
                            return;
                        }
                        if ($('#Table_CHS_Data > tbody tr[role=row]').length === 0) {
                            alert('請至少選擇1筆');
                            Edit_Mode = "Base";

                            V_BT_CHG($('#BT_BASE'));
                            return;
                        }
                        else {
                            $('.Div_D').css('display', 'none');
                            $('#Div_DT_DETAIL').css('display', '');
                            V_BT_CHG($('#BT_DT'));
                        }
                    case "RPT":
                        $('.Div_D').css('display', 'none');
                        $('#Div_RPT').css('display', 'flex');

                        V_BT_CHG($('#BT_RPT'));
                        break;
                }
            }

            function ClickToEdit(click_tr) {

                var index = $('#Table_Search_Quote thead th:contains(序號)').index() + 1; 
                $('#E_SEQ').val(click_tr.find('td:nth-child(' + index + ')').text());
                index = $('#Table_Search_Quote thead th:contains(報價單號)').index() + 1;
                $('#E_QUAH_NO').val(click_tr.find('td:nth-child(' + index + ')').text());
                index = $('#Table_Search_Quote thead th:contains(報價日期)').index() + 1;
                $('#E_QUAH_DATE').val(click_tr.find('td:nth-child(' + index + ')').text().substr(0, 10));
                index = $('#Table_Search_Quote thead th:contains(客戶編號)').index() + 1;
                $('#E_CUST_NO').val(click_tr.find('td:nth-child(' + index + ')').text());
                index = $('#Table_Search_Quote thead th:contains(客戶簡稱)').index() + 1;
                $('#E_CUST_S_NAME').val(click_tr.find('td:nth-child(' + index + ')').text());
                index = $('#Table_Search_Quote thead th:contains(頤坊型號)').index() + 1;
                $('#E_IVAN_TYPE').val(click_tr.find('td:nth-child(' + index + ')').text());
                index = $('#Table_Search_Quote thead th:contains(產品說明)').index() + 1;
                $('#E_PROD_DESC').val(click_tr.find('td:nth-child(' + index + ')').text());
                index = $('#Table_Search_Quote thead th:contains(廠商編號)').index() + 1;
                $('#E_FACT_NO').val(click_tr.find('td:nth-child(' + index + ')').text());
                index = $('#Table_Search_Quote thead th:contains(廠商簡稱)').index() + 1;
                $('#E_FACT_S_NAME').val(click_tr.find('td:nth-child(' + index + ')').text());
                index = $('#Table_Search_Quote thead th:contains(基本量_1)').index() + 1;
                $('#E_MIN_1').val(click_tr.find('td:nth-child(' + index + ')').text());
                index = $('#Table_Search_Quote thead th:contains(美元單價)').index() + 1;
                $('#E_USD').val(click_tr.find('td:nth-child(' + index + ')').text());
                index = $('#Table_Search_Quote thead th:contains(單位)').index() + 1;
                $('#E_UNIT').val(click_tr.find('td:nth-child(' + index + ')').text());
                index = $('#Table_Search_Quote thead th:contains(台幣單價)').index() + 1;
                $('#E_NTD').val(click_tr.find('td:nth-child(' + index + ')').text());
                index = $('#Table_Search_Quote thead th:contains(基本量_2)').index() + 1;
                $('#E_MIN_2').val(click_tr.find('td:nth-child(' + index + ')').text());
                index = $('#Table_Search_Quote thead th:contains(單價_2)').index() + 1;
                $('#E_PRICE_2').val(click_tr.find('td:nth-child(' + index + ')').text());
                index = $('#Table_Search_Quote thead th:contains(基本量_3)').index() + 1;
                $('#E_MIN_3').val(click_tr.find('td:nth-child(' + index + ')').text());
                index = $('#Table_Search_Quote thead th:contains(單價_3)').index() + 1;
                $('#E_PRICE_3').val(click_tr.find('td:nth-child(' + index + ')').text());
                index = $('#Table_Search_Quote thead th:contains(基本量_4)').index() + 1;
                $('#E_MIN_4').val(click_tr.find('td:nth-child(' + index + ')').text());
                index = $('#Table_Search_Quote thead th:contains(單價_4)').index() + 1;
                $('#E_PRICE_4').val(click_tr.find('td:nth-child(' + index + ')').text());
                index = $('#Table_Search_Quote thead th:contains(出貨地)').index() + 1;
                $('#E_S_FROM').val(click_tr.find('td:nth-child(' + index + ')').text());
                index = $('#Table_Search_Quote thead th:contains(更新人員)').index() + 1;
                $('#E_UPD_USER').val(click_tr.find('td:nth-child(' + index + ')').text());
                index = $('#Table_Search_Quote thead th:contains(更新日期)').index() + 1;
                $('#E_UPD_DATE').val(click_tr.find('td:nth-child(' + index + ')').text().substr(0, 10));
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
                                    { data: "序號", title: "序號" },
                                    { data: "更新人員", title: "<%=Resources.Customer.Update_User%>" },
                                    { data: "更新日期", title: "<%=Resources.Customer.Update_Date%>" }
                                ],
                                "order": [[3, "asc"]], //根據 頤坊型號 排序
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

            function Search_QUAH_SEQ() {
                $.ajax({
                    url: apiUrl,
                    data: {
                        "Call_Type": "QUAH_SEQ_SEARCH"                
                    },
                    cache: false,
                    type: "POST",
                    datatype: "json",
                    contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                    success: function (response) {
                        if (response.length === 0) {
                            alert('<%=Resources.MP.Data_Not_Exists_Alert%>');
                        }
                        else {
                            $('#E_QUAH_SEQ').val('Q' + response[0].Column1);
                        }
                    },
                    error: function (ex) {
                        alert(ex);
                    }
                });
            };        

            function Search_BYR_NAME(custNo) {
                $.ajax({
                    url: apiUrl,
                    data: {
                        "Call_Type": "CUST_NAME_SEARCH",
                        "CUST_NO": custNo
                    },
                    cache: false,
                    type: "POST",
                    datatype: "json",
                    contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                    success: function (response) {
                        if (response.length === 0) {
                            alert('<%=Resources.MP.Data_Not_Exists_Alert%>');
                        }
                        else {
                            $('#E_CUST_S_NAME').val(response[0].CUST_S_NAME);
                            $('#E_CUST_NAME').val(response[0].CUST_NAME);
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
                $('#Table_CHS_Data').DataTable().clear().draw();

                var Confirm_Check = confirm("<%=Resources.MP.Cancel_Alert%>");
                if (Confirm_Check) {
                    Edit_Mode = "Base";
                    Form_Mode_Change("Base");
                }
            });

            $('#BT_EDIT').on('click', function () {
                UPD_QUAH();
            });
      
            //功能選單
            $('#BT_BASE').on('click', function () {
                Edit_Mode = "Base";
                if($('#Table_Search_Quote > tbody tr[role=row]').length > 0)
                {
                    Form_Mode_Change("Search");
                }
                else {
                    Form_Mode_Change("Base");
                }
            });

            $('#BT_DT').on('click', function () {
                Edit_Mode = "Edit";
                Form_Mode_Change("EXEC");
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
                <td style="height: 10px; font-size: smaller;" colspan="8">&nbsp</td>
            </tr>
            <tr class="trstyle">
                <td class="tdhstyle">頤坊型號</td>
                <td class="tdbstyle">
                    <input id="Q_IVAN_TYPE"  class="textbox_char" />
                </td>
                <td class="tdhstyle">報價日期</td>
                <td class="tdbstyle">
                    <input id="Q_QUAH_DATE_S" type="date" class="date_S_style" />~<input id="Q_QUAH_DATE_E" type="date" class="date_E_style" />
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
            <tr>
                <td style="height: 5px; font-size: smaller;" colspan="8">&nbsp</td>
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

        <div id="Div_DT_Search" class=" Div_D">
            <div id="Div_DT_View" style=" width:60%; border-style:solid;border-width:1px; float:left;">
                <div class="dataTables_info" id="Table_Search_Quote_info" role="status" aria-live="polite"></div>
                <table id="Table_Search_Quote" class="Table_Search table table-striped table-bordered">
                    <thead style="white-space:nowrap"></thead>
                    <tbody style="white-space:nowrap"></tbody>
                </table>
            </div>
    
            <div id="Div_EDIT_Data" style="width:35%; height:71vh; border-style:solid; border-width:1px;  float:right;">
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
                            <input id="E_CUST_NO"  class="textbox_char" />
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
    
        </div>

        <div id="Div_DT_DETAIL" class=" Div_D" style="white-space:nowrap">
            
        </div>

        <div id="Div_RPT" class=" Div_D" style=" display:flex; align-items:center; justify-content:center;" >
            <div id="Div_RPT_DETAIL" style="width:50%;height:71vh; border-style:solid;border-width:1px; display:flex; align-items:center; justify-content:center ">
                <table class="search_section_control">
                    <tr class="trCenterstyle">
                        <td class="tdhstyle" style="font-size:20px;">報表類型</td>
                        <td class="tdbstyle">
                            <select id="R_RPT_TYPE" style="font-size:20px;">
                                <option selected="selected" value="0">無圖報價單</option>
                                <option value="1">雙排1:1</option>
                            </select>
                         </td>
                    </tr>
                    <tr class="trCenterstyle">
                        <td class="tdhstyle" style="font-size:20px;">報價單號</td>
                        <td class="tdbstyle">
                            <input id="R_QUAH_NO"  class="textbox_char" />
                        </td>
                    </tr>
                    <tr class="trCenterstyle">
                        <td class="tdhstyle" style="font-size:20px;">交貨天數</td>
                        <td class="tdbstyle">
                            <input id="R_DELV_DAYS" type="number" value="45" />
                        </td>
                    </tr>
                    <tr class="trCenterstyle">
                        <td class="tdhstyle" style="font-size:20px">簽名</td>
                        <td class="tdbstyle">
                            <select id="R_SIGN" style="font-size:20px;">
                                <option selected="selected" value="0">無</option>
                                <option value="HKC">HKC</option>
                                <option value="HAOHAN">HAOHAN</option>
                                <option value="SCOTT">SCOTT</option>
                            </select>
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
