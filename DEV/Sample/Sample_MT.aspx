<%@ Page Title="樣品開發維護" Language="C#" MasterPageFile="~/MP.master" AutoEventWireup="true" CodeFile="Sample_MT.aspx.cs" Inherits="Sample_MT" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="/css/dataTables.bootstrap4.min.css" rel="stylesheet" />
    <script src="/js/jquery.dataTables.min.js"></script>
    <script src="/js/dataTables.bootstrap4.min.js"></script>
    <style type="text/css">
       .tableToEdit {
            color: white;
            background-color: rgb(90, 20, 0) !important;
        }
    </style>
    <script type="text/javascript">
        $(document).ready(function () {
            var Edit_Mode;
            var apiUrl = "/DEV/Sample/Sample_MT.ashx";
            //隱藏滾動卷軸
            //document.body.style.overflow = 'hidden';

            //init CONTROLER
            Form_Mode_Change("Base");

            //$('#Q_QUAH_DATE_S').val($.datepicker.formatDate('yy-mm-dd', new Date()));
            //$('#Q_QUAH_DATE_E').val($.datepicker.formatDate('yy-mm-dd', new Date()));          

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
                        $('#Div_DT_View').css('display', 'none');
                        $('#BT_Cancel').css('display', 'none');
                        $('#BT_Insert').css('display', '');
                        $('#BT_Search').css('display', '');
              
                        V_BT_CHG($('#BT_BASE'));
                        break;
                    case "Search": //EDIT
                        $('.Div_D').css('display', 'none');
                        $('#Div_EDIT_Data').css('display', '');
                        $('#Div_DT_View').css('display', '');
                        $('#BT_Cancel').css('display', '');
                        $('#BT_Insert').css('display', '');
                        $('#BT_EDIT').css('display', 'inline-block');
                        $('#BT_SAVE').css('display', 'none');
                        $('#BT_INSERT_CANCEL').css('display', 'none');

                        V_BT_CHG($('#BT_BASE'));
                        break;
                    case "Insert":
                        $('.Div_D').css('display', 'none');
                        $('#Div_EDIT_Data').css('display', '');
                        $('#Div_DT_View').css('display', '');
                        $('#BT_Cancel').css('display', '');
                        $('#BT_Insert').css('display', 'none');
                        $('#BT_EDIT').css('display', 'none');
                        $('#BT_SAVE').css('display', 'inline-block');
                        $('#BT_INSERT_CANCEL').css('display', 'inline-block');

                        $('#E_SEQ').val('');
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
                $('#Table_Search_Sample > tbody tr').removeClass("tableToEdit");
                click_tr.addClass("tableToEdit");

                var clickData = $('#Table_Search_Sample').DataTable().row(click_tr).data();

                //Edit page
                $('#E_SAMPLE_NO').val(clickData['樣品號碼']);

                if (Edit_Mode !== "Insert") {
                    $('#E_SEQ').val(clickData['序號']);
                }

                $('#E_IVAN_TYPE').val(clickData['頤坊型號']);
                $('#E_FACT_NO').val(clickData['廠商編號']);
                $('#E_FACT_S_NAME').val(clickData['廠商簡稱']);
                $('#E_TMP_TYPE').val(clickData['暫時型號']);
                $('#E_FACT_TYPE').val(clickData['廠商型號']);
                $('#E_PROD_DESC').val(clickData['產品說明']);
                $('#E_WORK_TYPE').val(clickData['工作類別']);
                $('#E_RPT_REMARK').val(clickData['列印備註']);
                $('#E_PUDU_NO').val(clickData['採購單號']);
                $('#E_PUDU_DATE').val(clickData['採購日期'].substr(0, 10));
                $('#E_PUDU_CNT').val(clickData['採購數量']);
                $('#E_PUDU_GIVE_DATE').val(clickData['採購交期'].substr(0, 10));
                $('#E_CUST_NO').val(clickData['客戶編號']);
                $('#E_CUST_S_NAME').val(clickData['客戶簡稱']);
                $('#E_GIVE_STATUS').val(clickData['交期狀況']);
                $('#E_GIVE_WAY').val(clickData['分配方式']);
                $('#E_CHECK_NO').val(clickData['點收批號']);
                $('#E_CHECK_DATE').val(clickData['點收日期']); 
                $('#E_CHECK_CNT').val(clickData['點收數量']);
                $('#E_ACC_SHIP_CNT').val(clickData['到貨數量']);
                $('#E_GIVE_SHIP_DATE').val(clickData['出貨日期']);
                $('#E_ACC_SHIP_DATE').val(clickData['到貨日期']);
                $('#E_MIN_1').val(clickData['基本量_1']);
                $('#E_USD').val(clickData['美元單價']);
                $('#E_UNIT').val(clickData['單位']);
                $('#E_NTD').val(clickData['台幣單價']);
                $('#E_MIN_2').val(clickData['基本量_2']);
                $('#E_PRICE_2').val(clickData['單價_2']);
                $('#E_MIN_3').val(clickData['基本量_3']);
                $('#E_PRICE_3').val(clickData['單價_3']);
                $('#E_UPD_USER').val(clickData['更新人員']);
                $('#E_UPD_DATE').val(clickData['更新日期'].substr(0, 10));

                //IMG page
                $('#I_IVAN_TYPE').val(clickData['頤坊型號']);
                $('#I_FACT_NO').val(clickData['廠商編號']);
                $('#I_FACT_S_NAME').val(clickData['廠商簡稱']);
                $('#I_PROD_DESC').val(clickData['產品說明']);
                $('#I_RPT_REMARK').val(clickData['大備註']);
                Search_IMG(clickData['廠商編號'], clickData['頤坊型號']);
            }
            
            function V_BT_CHG(buttonChs) {
                $('.V_BT').attr('disabled', false);
                buttonChs.attr('disabled', 'disabled');
            }

            //ajax function
            function Search_Sample() {
                $.ajax({
                    url: apiUrl,
                    data: {
                        "Call_Type": "Sample_Base", 
                        "SAMPLE_NO": $('#Q_SAMPLE_NO').val(),
                        "IVAN_TYPE": $('#Q_IVAN_TYPE').val(),
                        "PUDU_DATE_S": $('#Q_PUDU_DATE_S').val(),
                        "PUDU_DATE_E": $('#Q_PUDU_DATE_E').val(),
                        "CUST_NO": $('#Q_CUST_NO').val(),
                        "CUST_S_NAME": $('#Q_CUST_S_NAME').val(),
                        "PUDU_NO": $('#Q_PUDU_NO').val(),
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
                            $('#Table_Search_Sample').DataTable({
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
                                    { data: "樣品號碼", title: "樣品號碼" },
                                    { data: "工作類別", title: "工作類別" },
                                    { data: "採購單號", title: "採購單號" },
                                    { data: "採購日期", title: "採購日期" },
                                    { data: "廠商簡稱", title: "廠商簡稱" },
                                    { data: "頤坊型號", title: "頤坊型號" },
                                    { data: "單位", title: "單位" },
                                    { data: "採購數量", title: "採購數量" },
                                    { data: "點收數量", title: "點收數量" },
                                    { data: "到貨數量", title: "到貨數量" },
                                    { data: "採購交期", title: "採購交期" },
                                    { data: "點收批號", title: "點收批號" },
                                    { data: "暫時型號", title: "暫時型號" },
                                    { data: "產品說明", title: "產品說明" },
                                    { data: "台幣單價", title: "台幣單價" },
                                    { data: "美元單價", title: "美元單價" },
                                    { data: "廠商編號", title: "廠商編號" },
                                    { data: "更新人員", title: "<%=Resources.Customer.Update_User%>" },
                                    { data: "更新日期", title: "<%=Resources.Customer.Update_Date%>" },
                                    { data: "基本量_1", title: "基本量_1", visible: false },
                                    { data: "台幣單價", title: "台幣單價", visible: false },
                                    { data: "客戶編號", title: "客戶編號", visible: false },
                                    { data: "基本量_2", title: "基本量_2", visible: false },
                                    { data: "基本量_3", title: "基本量_3", visible: false },
                                    { data: "單價_2", title: "單價_2", visible: false },
                                    { data: "單價_3", title: "單價_3", visible: false },
                                    { data: "分配方式", title: "分配方式", visible: false },
                                    { data: "交期狀況", title: "交期狀況", visible: false },
                                    { data: "點收日期", title: "點收日期", visible: false },
                                    { data: "點收數量", title: "點收數量", visible: false },
                                    { data: "出貨日期", title: "出貨日期", visible: false },
                                    { data: "到貨日期", title: "到貨日期", visible: false },
                                    { data: "到貨數量", title: "到貨數量", visible: false },
                                    { data: "強制結案", title: "強制結案", visible: false }
                                ],
                                "order": [[1, "asc"]], //根據 樣品號碼 排序
                                "scrollX": true,
                                "scrollY": "62vh",
                                "searching": false,
                                "paging": false,
                                "bInfo": false //顯示幾筆隱藏
                            });

                            $('#Table_Search_Sample').DataTable().draw();
                            $('#Table_Search_Sample_info').text('Showing ' + $('#Table_Search_Sample > tbody tr[role=row]').length + ' entries');
                        }
                    },
                    error: function (ex) {
                        alert(ex);
                    }
                });
            };        

            function Search_IMG(factNo, IvanType) {
                $.ajax({
                    url: apiUrl,
                    data: {
                        "Call_Type": "GET_IMG",
                        "FACT_NO": factNo,
                        "IVAN_TYPE": IvanType
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

            //新增資料
            function INSERT_SAMPLE() {
                if ($('#E_SAMPLE_NO').val() === '') {
                    alert('請填寫樣品號碼');
                }
                else {
                    $.ajax({
                        url: apiUrl,
                        data: {
                            "Call_Type": "INSERT_SAMPLE",
                            "SEQ": $('#E_SEQ').val(),
                            "SAMPLE_NO": $('#E_SAMPLE_NO').val(),
                            "IVAN_TYPE": $('#E_IVAN_TYPE').val(),
                            "FACT_NO": $('#E_FACT_NO').val(),
                            "FACT_S_NAME": $('#E_FACT_S_NAME').val(),
                            "TMP_TYPE": $('#E_TMP_TYPE').val(),
                            "FACT_TYPE": $('#E_FACT_TYPE').val(),
                            "PROD_DESC": $('#E_PROD_DESC').val(),
                            "WORK_TYPE": $('#E_WORK_TYPE').val(),
                            "RPT_REMARK": $('#E_RPT_REMARK').val(),
                            "PUDU_NO": $('#E_PUDU_NO').val(),
                            "PUDU_CNT": $('#E_PUDU_CNT').val(),
                            "PUDU_DATE": $('#E_PUDU_DATE').val(),
                            "PUDU_GIVE_DATE": $('#E_PUDU_GIVE_DATE').val(),
                            "CUST_NO": $('#E_CUST_NO').val(),
                            "CUST_S_NAME": $('#E_CUST_S_NAME').val(),
                            "GIVE_STATUS": $('#E_GIVE_STATUS').val(),
                            "GIVE_WAY": $('#E_GIVE_WAY').val(),
                            "CHECK_NO": $('#E_CHECK_NO').val(),
                            "CHECK_DATE": $('#E_CHECK_DATE').val(),
                            "CHECK_CNT": $('#E_CHECK_CNT').val(),
                            "ACC_SHIP_CNT": $('#E_ACC_SHIP_CNT').val(),
                            "GIVE_SHIP_DATE": $('#E_GIVE_SHIP_DATE').val(),
                            "ACC_SHIP_DATE": $('#E_ACC_SHIP_DATE').val(),
                            "MIN_1": $('#E_MIN_1').val(),
                            "USD": $('#E_USD').val(),
                            "UNIT": $('#E_UNIT').val(),
                            "NTD": $('#E_NTD').val(),
                            "MIN_2": $('#E_MIN_2').val(),
                            "PRICE_2": $('#E_PRICE_2').val(),
                            "MIN_3": $('#E_MIN_3').val(),
                            "PRICE_3": $('#E_PRICE_3').val(),
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
                                alert('樣品號碼:' + $('#E_SAMPLE_NO').val() + '已新增完成');

                                Search_Sample();
                            }
                            else {
                                alert('新增資料有誤請通知資訊人員');
                            }
                        },
                        error: function (ex) {
                            alert(ex);
                            return;
                        }
                    });
                }
            };           

            //更新DB
            function UPD_SAMPLE() {
                if ($('#E_SEQ').val() === '') {
                    alert('請選擇要修改的資料');
                }
                else{
                    $.ajax({
                        url: apiUrl,
                        data: {
                            "Call_Type": "UPD_SAMPLE",
                            "SEQ": $('#E_SEQ').val(),
                            "SAMPLE_NO": $('#E_SAMPLE_NO').val(),
                            "IVAN_TYPE": $('#E_IVAN_TYPE').val(),
                            "FACT_NO": $('#E_FACT_NO').val(),
                            "FACT_S_NAME": $('#E_FACT_S_NAME').val(),
                            "TMP_TYPE": $('#E_TMP_TYPE').val(),
                            "FACT_TYPE": $('#E_FACT_TYPE').val(),
                            "PROD_DESC": $('#E_PROD_DESC').val(),
                            "WORK_TYPE": $('#E_WORK_TYPE').val(),
                            "RPT_REMARK": $('#E_RPT_REMARK').val(),
                            "PUDU_NO": $('#E_PUDU_NO').val(),
                            "PUDU_CNT": $('#E_PUDU_CNT').val(),
                            "PUDU_DATE": $('#E_PUDU_DATE').val(),
                            "PUDU_GIVE_DATE": $('#E_PUDU_GIVE_DATE').val(),
                            "CUST_NO": $('#E_CUST_NO').val(),
                            "CUST_S_NAME": $('#E_CUST_S_NAME').val(),
                            "GIVE_STATUS": $('#E_GIVE_STATUS').val(),
                            "GIVE_WAY": $('#E_GIVE_WAY').val(),
                            "CHECK_NO": $('#E_CHECK_NO').val(),
                            "CHECK_DATE": $('#E_CHECK_DATE').val(),
                            "CHECK_CNT": $('#E_CHECK_CNT').val(),
                            "ACC_SHIP_CNT": $('#E_ACC_SHIP_CNT').val(),
                            "GIVE_SHIP_DATE": $('#E_GIVE_SHIP_DATE').val(),
                            "ACC_SHIP_DATE": $('#E_ACC_SHIP_DATE').val(),
                            "MIN_1": $('#E_MIN_1').val(),
                            "USD": $('#E_USD').val(),
                            "UNIT": $('#E_UNIT').val(),
                            "NTD": $('#E_NTD').val(),
                            "MIN_2": $('#E_MIN_2').val(),
                            "PRICE_2": $('#E_PRICE_2').val(),
                            "MIN_3": $('#E_MIN_3').val(),
                            "PRICE_3": $('#E_PRICE_3').val(),
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

                                Search_Sample();
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
            $('#Table_Search_Sample').on('click', 'tbody tr', function () {
                ClickToEdit($(this));
            });

            //BUTTON CLICK EVENT BASE 頁
            $('#BT_Search').on('click', function () {

                if (Edit_Mode !== "Insert") {
                    Edit_Mode = "Base";
                    Form_Mode_Change("Search");
                }
                
                Search_Sample();
            });

            $('#BT_Cancel').on('click', function () {
                $('#Table_Search_Sample').DataTable().clear().draw();

                var Confirm_Check = confirm("<%=Resources.MP.Cancel_Alert%>");
                if (Confirm_Check) {
                    Edit_Mode = "Base";
                    Form_Mode_Change("Base");
                }
            });

            $('#BT_EDIT').on('click', function () {
                UPD_SAMPLE();
            });

            $('#BT_Insert').on('click', function () {
                Edit_Mode = "Insert";
                Form_Mode_Change("Insert");

                Search_Sample();
            });

            $('#BT_SAVE').on('click', function () {
                INSERT_SAMPLE();
            });

            $('#BT_INSERT_CANCEL').on('click', function () {
                Edit_Mode = "Base";
                Form_Mode_Change("Search");
                Search_Sample();
            });

            $('#BT_RPT_SETTING').on('click', function () {
                UPD_RPT_REMARK();
            });
      
            //功能選單
            $('#BT_BASE').on('click', function () {
                Edit_Mode = "Base";
                if($('#Table_Search_Sample > tbody tr[role=row]').length > 0)
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
    <div style="width:98%;margin:0 auto; ">
        <div class="search_section_all">
            <table class="search_section_control">
            <tr class="trstyle"> 
                <td style="height: 10px; font-size: smaller;" colspan="8">&nbsp
                </td>
            </tr>
            <tr class="trstyle">
                <td class="tdhstyle">樣品號碼</td>
                <td class="tdbstyle">
                    <input id="Q_SAMPLE_NO"  class="textbox_char" />
                </td>
                <td class="tdhstyle">頤坊型號</td>
                <td class="tdbstyle">
                    <input id="Q_IVAN_TYPE"  class="textbox_char" />
                </td>
                <td class="tdhstyle">採購日期</td>
                <td class="tdbstyle">
                    <input id="Q_PUDU_DATE_S" type="date" class="date_S_style" />~<input id="Q_PUDU_DATE_E" type="date" class="date_E_style" />
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
                <td class="tdhstyle">採購單號</td>
                <td class="tdbstyle">
                    <input id="Q_PUDU_NO"  class="textbox_char" />
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
                    <input type="button" id="BT_Insert" class="buttonStyle" value="<%=Resources.MP.Insert%>" />
                    <input type="button" id="BT_Cancel" class="buttonStyle" value="<%=Resources.MP.Cancel%>" style="display: none;" />
                </td>
            </tr>
        </table>
        </div>
        <div class="button_change_section">
            &nbsp;
            <input type="button" id="BT_BASE" class="V_BT" value="主檔"  disabled="disabled" />
            <input type="button" id="BT_SEQ" class="V_BT" value="編號" />
            <input type="button" id="BT_BIG_REMARK" class="V_BT" value="大備註" />
            <input type="button" id="BT_IMG" class="V_BT" value="圖型" />
            <input type="button" class="V_BT" value="圖例" />
        </div>

        <div id="Div_DT">
            <div id="Div_DT_View" style=" width:60%;height:71vh; border-style:solid;border-width:1px; float:left;">
                <div class="dataTables_info" id="Table_Search_Sample_info" role="status" aria-live="polite"></div>
                <table id="Table_Search_Sample" class="Table_Search table table-striped table-bordered">
                    <thead style="white-space:nowrap"></thead>
                    <tbody style="white-space:nowrap"></tbody>
                </table>
            </div>
    
            <div id="Div_EDIT_Data" class=" Div_D" style="width:35%; height:71vh;white-space:nowrap; border-style:solid; border-width:1px;  float:right; overflow:auto">
                <table class="edit_section_control">
                    <tr class="trstyle" >
                        <td class="tdEditstyle">樣品號碼</td>
                        <td class="tdbstyle">
                            <input id="E_SAMPLE_NO"  class="textbox_char" required="required" />
                        </td>
                        <td class="tdEditstyle">序號</td>
                        <td class="tdbstyle">
                            <input id="E_SEQ"  class="textbox_char" disabled="disabled" />
                        </td>
                    </tr>
                    <tr class="trstyle">
                        <td class="tdEditstyle">頤坊型號</td>
                        <td class="tdbstyle">
                            <input id="E_IVAN_TYPE"  class="textbox_char" />
                        </td>
                        <td class="tdEditstyle"></td>
                        <td class="tdbstyle"></td>
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
                        <td class="tdEditstyle">暫時型號</td>
                        <td class="tdbstyle">
                            <input id="E_TMP_TYPE"  class="textbox_char" />
                        </td>
                        <td class="tdEditstyle">廠商型號</td>
                        <td class="tdbstyle">
                            <input id="E_FACT_TYPE" class="textbox_char" disabled="disabled"  />
                        </td>
                    </tr>
                    <tr class="trstyle">
                        <td class="tdEditstyle">產品說明</td>
                        <td class="tdbstyle" colspan ="4">
                            <input id="E_PROD_DESC" class="textbox_char" style="width:80%"  />
                        </td>
                    </tr>     
                    <tr class="trstyle">
                        <td class="tdEditstyle">工作類別</td>
                        <td class="tdbstyle">
                            <select id="E_WORK_TYPE">
                                <option selected="selected" value="開發">開發</option>
                                <option value="詢價">詢價</option>
                                <option value="索樣">索樣</option>
                                <option value="詢索">詢索</option>
                                <option value="詢開">詢開</option>
                            </select>
                        </td>
                        <td class="tdEditstyle">列印備註</td>
                        <td class="tdbstyle">
                            <input id="E_RPT_REMARK"  class="textbox_char" />
                        </td>
                    </tr>
                    <tr class="trstyle">
                        <td class="tdEditstyle">採購單號</td>
                        <td class="tdbstyle">
                            <input id="E_PUDU_NO"  class="textbox_char" />
                        </td>
                        <td class="tdEditstyle">採購數量</td>
                        <td class="tdbstyle">
                            <input id="E_PUDU_CNT"  class="textbox_char" type="number" />
                        </td>
                    </tr>
                     <tr class="trstyle">
                        <td class="tdEditstyle">採購日期</td>
                        <td class="tdbstyle">
                            <input id="E_PUDU_DATE"  class="textbox_char" type="date" />
                        </td>
                        <td class="tdEditstyle">採購交期</td>
                        <td class="tdbstyle">
                            <input id="E_PUDU_GIVE_DATE"  class="textbox_char" type="date" />
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
                        <td class="tdEditstyle">交期狀況</td>
                        <td class="tdbstyle" colspan ="4">
                            <input id="E_GIVE_STATUS" class="textbox_char" style="width:80%"  />
                        </td>
                    </tr>     
                    <tr class="trstyle">
                        <td class="tdEditstyle">分配方式</td>
                        <td class="tdbstyle" colspan ="4">
                            <input id="E_GIVE_WAY" class="textbox_char" style="width:80%"  />
                        </td>
                    </tr>     
                    <tr class="trstyle">
                        <td class="tdEditstyle">點收批號</td>
                        <td class="tdbstyle">
                            <input id="E_CHECK_NO"  class="textbox_char"  />
                        </td>
                        <td class="tdEditstyle">點收日期</td>
                        <td class="tdbstyle">
                            <input id="E_CHECK_DATE" type="date" class="date_S_style"  />
                        </td>
                    </tr>
                    <tr class="trstyle">
                        <td class="tdEditstyle">點收數量</td>
                        <td class="tdbstyle">
                            <input id="E_CHECK_CNT" class="textbox_char" type="number" />
                        </td>
                        <td class="tdEditstyle">到貨數量</td>
                        <td class="tdbstyle">
                            <input id="E_ACC_SHIP_CNT" class="textbox_char" type="number" />
                        </td>
                    </tr>
                    <tr class="trstyle">
                        <td class="tdEditstyle">出貨日期</td>
                        <td class="tdbstyle">
                            <input id="E_GIVE_SHIP_DATE"  class="textbox_char"  />
                        </td>
                        <td class="tdEditstyle">到貨日期</td>
                        <td class="tdbstyle">
                            <input id="E_ACC_SHIP_DATE" type="date" class="date_S_style"  />
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
                        <td class="tdbstyle" style="height: 5px; font-size: smaller;" >&nbsp</td>
                    </tr>
                     <tr class="trCenterstyle"> 
                         <td colspan="4" style="text-align:center" >
                            <input type="button" id="BT_SAVE" style="display:inline-block" class="BTN" value="儲存"  />
                            <input type="button" id="BT_INSERT_CANCEL" style="display:inline-block" class="BTN" value="返回"  />
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
                            <input id="I_IVAN_TYPE" class="textbox_char" disabled="disabled"   />
                        </td>
                        <td class="tdEditstyle">廠商編號</td>
                        <td class="tdbstyle">
                            <input id="I_FACT_NO"  class="textbox_char" disabled="disabled"   />
                        </td>
                    </tr>
                    <tr class="trstyle">
                        <td class="tdEditstyle"></td>
                        <td class="tdbstyle"></td>
                        <td class="tdEditstyle">廠商簡稱</td>
                        <td class="tdbstyle" >
                            <input id="I_FACT_S_NAME" class="textbox_char" disabled="disabled"   />
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
                            <img id="I_IMG" src="#" style="display:none" />
                            <span id="I_NO_IMG" >查無圖檔</span>
                        </td>
                    </tr>

                </table>
            </div> 
        </div>
    </div>

</asp:Content>
