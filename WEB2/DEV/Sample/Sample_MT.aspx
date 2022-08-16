<%@ Page Title="樣品開發查詢維護" Language="C#" MasterPageFile="~/MP.master" AutoEventWireup="true" CodeFile="Sample_MT.aspx.cs" Inherits="Sample_MT" %>
<%@ Register TagPrefix="uc" TagName="uc1" Src="~/User_Control/Dia_Customer_Selector.ascx" %>
<%@ Register TagPrefix="uc2" TagName="uc2" Src="~/User_Control/Dia_Product_Selector.ascx" %>
<%@ Register TagPrefix="uc3" TagName="uc3" Src="~/User_Control/Dia_Product_ALL.ascx" %>
<%@ Register TagPrefix="uc4" TagName="uc4" Src="~/User_Control/Dia_Duo_Datetime_Picker.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="/css/dataTables.bootstrap4.min.css" rel="stylesheet" />
    <script src="/js/jquery.dataTables.min.js"></script>
    <script src="/js/dataTables.bootstrap4.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            var Edit_Mode;
            var amtChange = 0;
            var apiUrl = "/DEV/Sample/Ashx/Sample_MT.ashx";
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
            
            $('#BT_E_IVAN_TYPE').on('click', function () {
                $("#Search_Product_Dialog").dialog('open');
            });

            $('#SPD_Table_Product').on('click', '.PROD_SEL', function () {
                $('#E_SUPLU_SEQ').val($(this).parent().parent().find('td:nth(1)').text());
                $('#E_IVAN_TYPE').val($(this).parent().parent().find('td:nth(3)').text());
                $('#E_FACT_NO').val($(this).parent().parent().find('td:nth(4)').text());
                $('#E_FACT_S_NAME').val($(this).parent().parent().find('td:nth(5)').text());
                $('#E_UNIT').val($(this).parent().parent().find('td:nth(5)').text());
                $('#E_PROD_DESC').val($(this).parent().parent().find('td:nth(7)').text());
                $('#E_TMP_TYPE').val($(this).parent().parent().find('td:nth(8)').text());
                $('#E_FACT_TYPE').val($(this).parent().parent().find('td:nth(9)').text());

                $("#Search_Product_Dialog").dialog('close');
            });

            window.document.body.onbeforeunload = function () {
                if (Edit_Mode === "Insert" || Edit_Mode === "Edit") {
                    return '您尚未將編輯過的表單資料送出，請問您確定要離開網頁嗎？';
                }
            }

            //上下移功能 根據每個頁面客製
            $(document).keydown(function (event) {
                var key = (event.keyCode ? event.keyCode : event.which);
                var clickIndex = $('#Table_Search_Sample > tbody > tr.tableClick').index();
                if (key == '40') {
                    if (clickIndex < $('#Table_Search_Sample tbody tr').length - 1) {
                        clickIndex++;
                        ClickToEdit($('#Table_Search_Sample > tbody > tr:nth(' + clickIndex + ')'));
                    }
                }
                else if (key == '38') {
                    if (clickIndex > 0) {
                        clickIndex--;
                        ClickToEdit($('#Table_Search_Sample > tbody > tr:nth(' + clickIndex + ')'));
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
                        $('#BT_INSERT_SAVE').css('display', 'none');
                        $('#BT_INSERT_CLEAR').css('display', 'none');
                        $('#BT_INSERT_CANCEL').css('display', 'none');
                        $('.onlyEdit').css('display', '');

                        //確保 Table有值 將 第一欄checkbox隱藏
                        if ($('#Table_Search_Sample > tbody tr[role=row]').length > 0) {
                            $('#Table_Search_Sample').DataTable().column(0).visible(false);
                            $('#Table_Search_Sample').DataTable().column(3).visible(false);
                        }

                        $('.modeButton').css('display', 'none')
                        if (Edit_Mode == "Edit") {
                            $('#Div_EDIT_Data').css('display', '');
                            $('#Div_DT_View').css('width', '60%');

                            $('#BT_EDIT_SAVE').css('display', 'inline-block');
                            $('#BT_INSERT_CLEAR').css('display', 'none');
                            $('#BT_INSERT_CANCEL').css('display', 'inline-block');
                        }
                        else if (Edit_Mode == "Insert") {
                            $('#Div_EDIT_Data').css('display', '');
                            $('#Div_DT_View').css('width', '60%');

                            $('#BT_INSERT_SAVE').css('display', 'inline-block');
                            $('#BT_INSERT_CLEAR').css('display', 'inline-block');
                            $('#BT_INSERT_CANCEL').css('display', 'inline-block');
                            $('.onlyEdit').css('display', 'none');
                            $('#E_SEQ').val('');
                            $('#E_FORCE_CLOSE').prop('checked', false);
                            $('.editReset').val('');

                            $('#E_PUDU_DATE').val($.datepicker.formatDate('yy-mm-dd', new Date()))
                            $('#E_PUDU_GIVE_DATE').val($.datepicker.formatDate('yy-mm-dd', new Date()))
                        }
                        else {
                            $('.editReset').val('');
                        }

                        V_BT_CHG($('#BT_BASE'));
                        break;
                    case "SEQ":
                        $('.Div_D').css('display', 'none');
                        $('#Div_DT_View').css('width', '60%');
                        $('#Div_SET_SEQ').css('display', '');

                        V_BT_CHG($('#BT_SEQ'));
                        break;
                    case "REMARK":
                        $('.Div_D').css('display', 'none');
                        $('#Div_DT_View').css('width', '60%');
                        $('#Div_BIG_REMARK').css('display', '');

                        V_BT_CHG($('#BT_BIG_REMARK'));
                        break;
                    case "WriteOff":
                        $('.Div_D').css('display', 'none');
                        $('#Div_DT_View').css('width', '60%');
                        $('#Div_WriteOff').css('display', '');

                        //顯示checkbox
                        if ($('#Table_Search_Sample > tbody tr[role=row]').length > 0) {
                            $('#Table_Search_Sample').DataTable().column(0).visible(true);
                            $('#Table_Search_Sample').DataTable().column(3).visible(true);
                            $('#W_CHK_CNT').text('共選擇: ' + $('.tbChkBox:checked').length + '筆');
                            $('#thCheckbox').on('click', function () {
                                var rows = $('#Table_Search_Sample').DataTable().rows().nodes();
                                $('input[type="checkbox"]', rows).prop('checked', this.checked);
                            });
                            $('.tableChkBox').on('click', function () {
                                $('#W_CHK_CNT').text('共選擇: ' + $('.tbChkBox:checked').length + '筆');
                            });
                        }

                        V_BT_CHG($('#BT_S_WriteOff'));
                        break;
                    case "IMG":
                        $('.Div_D').css('display', 'none');
                        $('#Div_DT_View').css('width', '60%');
                        $('#Div_IMG_DETAIL').css('display', '');

                        V_BT_CHG($('#BT_IMG'));
                        break;
                    case "RPT":
                        $('.Div_D').css('display', 'none');
                        $('#Div_DT_View').css('width', '60%');
                        $('#Div_RPT_DETAIL').css('display', '');

                        V_BT_CHG($('#BT_RPT'));
                        break;              
                }
            }

            function Re_Bind_Inner_JS() {
                $('.Call_Product_Tool').off('click');
                $('.Call_Product_Tool').on('click', function (e) {
                    e.stopPropagation();
                    $('#PAD_HDN_SUPLU_SEQ').val($(this).attr('SUPLU_SEQ'));
                    $("#Product_ALL_Dialog").dialog('open');
                });
            };

            function ClickToEdit(click_tr) {
                $('#BT_Update').css('display', '');
                amtChange = 0;

                //點擊賦予顏色
                $('#Table_Search_Sample > tbody tr').removeClass("tableClick");
                click_tr.addClass("tableClick");

                var clickData = $('#Table_Search_Sample').DataTable().row(click_tr).data();

                //Edit page
                $('#E_SAMPLE_NO').val(clickData['樣品號碼']);

                if (Edit_Mode !== "Insert") {
                    $('#E_SEQ').val(clickData['序號']);
                    $('#E_PUDU_NO').val(clickData['採購單號']);
                    $('#E_PUDU_DATE').val(clickData['採購日期']);
                    $('#E_PUDU_CNT').val(clickData['採購數量']);
                    $('#E_PUDU_GIVE_DATE').val(clickData['採購交期']);
                    $('#E_GIVE_STATUS').val(clickData['交期狀況']);
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
                    $('#E_FORE_CODE').val(clickData['外幣幣別']),
                    $('#E_FORE_AMT').val(clickData['外幣單價']),
                    $('#E_MIN_2').val(clickData['基本量_2']);
                    $('#E_PRICE_2').val(clickData['單價_2']);
                    $('#E_MIN_3').val(clickData['基本量_3']);
                    $('#E_PRICE_3').val(clickData['單價_3']);
                    $('#E_UPD_USER').val(clickData['更新人員']);
                    $('#E_UPD_DATE').val(clickData['更新日期']);
                }

                if (clickData['強制結案'] == '是') {
                    $('#E_FORCE_CLOSE').prop('checked', true);
                }
                else {
                    $('#E_FORCE_CLOSE').prop('checked', false);
                }
                $('#E_SUPLU_SEQ').val(clickData['SUPLU_SEQ']);
                $('#E_IVAN_TYPE').val(clickData['頤坊型號']);
                $('#E_FACT_NO').val(clickData['廠商編號']);
                $('#E_FACT_S_NAME').val(clickData['廠商簡稱']);
                $('#E_TMP_TYPE').val(clickData['暫時型號']);
                $('#E_FACT_TYPE').val(clickData['廠商型號']);
                $('#E_PROD_DESC').val(clickData['產品說明']);
                $('#E_WORK_TYPE').val(clickData['工作類別']);
                $('#E_RPT_REMARK').val(clickData['列印備註']);
                $('#E_CUST_NO').val(clickData['客戶編號']);
                $('#E_CUST_S_NAME').val(clickData['客戶簡稱']);
                $('#E_GIVE_WAY').val(clickData['分配方式']);             

                //IMG page
                $('#I_IVAN_TYPE').val(clickData['頤坊型號']);
                $('#I_FACT_NO').val(clickData['廠商編號']);
                $('#I_FACT_S_NAME').val(clickData['廠商簡稱']);
                $('#I_PROD_DESC').val(clickData['產品說明']);
                $('#I_RPT_REMARK').val(clickData['大備註']);
                Search_IMG(clickData['SUPLU_SEQ']);

                //SET SEQ PAGE
                $('#S_SAMPLE_NO').val(clickData['樣品號碼']);
                $('#S_WORK_TYPE').val(clickData['工作類別']);
                $('#S_PUDU_NO').val(clickData['採購單號']);
                if (clickData['採購交期'] == null || clickData['採購交期'] == '') {
                    $('#S_PUDU_GIVE_DATE').val($.datepicker.formatDate('yy-mm-dd', new Date(new Date().setDate(new Date().getDate() + 14))));
                }
                else {
                    $('#S_PUDU_GIVE_DATE').val(clickData['採購交期']);
                }

                //BIG REMARK PAGE
                $('#B_PUDU_NO').val(clickData['採購單號']);
                $('#B_FACT_S_NAME').val(clickData['廠商簡稱']);
                $('#B_PRE_PAY_AMT_1').val(clickData['預付款一']);
                $('#B_PRE_PAY_DATE_1').val(clickData['預付日一']);
                $('#B_PRE_PAY_AMT_2').val(clickData['預付款二']);
                $('#B_PRE_PAY_DATE_2').val(clickData['預付日二']);
                $('#B_ADD_AMT').val(clickData['附加費']);
                $('#B_ADD_DESC').val(clickData['附加費說明']);
                $('#B_BIG_REMARK_1').val(clickData['大備註一']);
                $('#B_BIG_REMARK_2').val(clickData['大備註二']);
                $('#B_BIG_REMARK_3').val(clickData['大備註三']);
                $('#B_SPEC_REMARK').val(clickData['特別事項']);

                //RPT PAGE
                $('#R_PUDU_NO_S').val(clickData['採購單號']);
                $('#R_PUDU_NO_E').val(clickData['採購單號']);
                $('#R_PUDU_NO_1').val(clickData['採購單號']);
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
                        "PROD_DES": $('#Q_PROD_DES').val(),
                        "WRITE_OFF": $('#Q_WRITEOFF').val()
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
                                    Re_Bind_Inner_JS();
                                },
                                "columns": [
                                    {
                                        data: null, title: '<input type="checkbox" id="thCheckbox" class="tableChkBox" />全選',
                                        render: function (data, type, row) {
                                            return '<input type="checkbox" style="text-align:center" class="tbChkBox tableChkBox" />'
                                        },
                                        orderable: false,
                                        visible: false
                                    },
                                    { data: "序號", title: "序號" },
                                    { data: "樣品號碼", title: "樣品號碼" },
                                    { data: "強制結案", title: "強制結案", visible: false },
                                    { data: "工作類別", title: "工作類別" },
                                    { data: "採購單號", title: "採購單號" },
                                    { data: "採購日期", title: "採購日期" },
                                    { data: "廠商簡稱", title: "廠商簡稱" },
                                    {
                                        data: "頤坊型號", title: "頤坊型號",
                                        render: function (data, type, row) {
                                            return '<input class="Call_Product_Tool" SUPLU_SEQ = "' + (row.SUPLU_SEQ ?? "")
                                                + '" type="button" value="' + (data ?? "")
                                                + '" style="text-align:left;width:100%;z-index:1000;' + ((row.Has_IMG) ? 'background: #90ee90;' : '') + '" />'
                                        },
                                        orderable: false
                                    },
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
                                    { data: "更新人員", title: "<%=Resources.MP.Update_User%>" },
                                    { data: "更新日期", title: "<%=Resources.MP.Update_Date%>" },
                                    { data: "SUPLU_SEQ", title: "SUPLU_SEQ", visible: false },
                                    { data: "基本量_1", title: "基本量_1", visible: false },
                                    { data: "台幣單價", title: "台幣單價", visible: false },
                                    { data: "客戶編號", title: "客戶編號", visible: false },
                                    { data: "外幣幣別", title: "外幣幣別", visible: false },
                                    { data: "外幣單價", title: "外幣單價", visible: false },
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
                                    { data: "預付款一", title: "預付款一", visible: false },
                                    { data: "預付日一", title: "預付日一", visible: false },
                                    { data: "預付款二", title: "預付款二", visible: false },
                                    { data: "預付日二", title: "預付日二", visible: false },
                                    { data: "附加費", title: "附加費", visible: false },
                                    { data: "附加費說明", title: "附加費說明", visible: false },
                                    { data: "大備註一", title: "大備註一", visible: false },
                                    { data: "大備註二", title: "大備註二", visible: false },
                                    { data: "大備註三", title: "大備註三", visible: false },
                                    { data: "特別事項", title: "特別事項", visible: false }
                                ],
                                "columnDefs": [
                                    {
                                        className: 'text-right', targets: [10, 11, 12, 17, 18] //數字靠右
                                    },
                                ],
                                "order": [[2, "asc"]], //根據 樣品號碼 排序
                                "scrollX": true,
                                "scrollY": "62vh",
                                "searching": false,
                                "paging": false,
                                "bInfo": false //顯示幾筆隱藏
                            });

                            $('#Table_Search_Sample').DataTable().draw();
                            $('#Table_Search_Sample_info').text('Showing ' + $('#Table_Search_Sample > tbody tr[role=row]').length + ' entries');

                            if ($('#Table_Search_Sample > tbody tr.tableClick').length == 0 && Edit_Mode == 'Edit') {
                                ClickToEdit($('#Table_Search_Sample > tbody > tr:nth(0)'));
                            }

                            if (Edit_Mode == 'WriteOff') {
                                Form_Mode_Change('WriteOff');
                            }

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

            //編號
            function SET_PURC_SEQ() {
                if ($('#S_SAMPLE_NO').val() === '') {
                    alert('請至少選擇一筆樣品號碼');
                }
                else {
                    $.ajax({
                        url: apiUrl,
                        data: {
                            "Call_Type": "SEQ_PURC_SEQ",
                            "SAMPLE_NO": $('#S_SAMPLE_NO').val(),
                            "WORK_TYPE": $('#S_WORK_TYPE').val(),
                            "PUDU_GIVE_DATE": $('#S_PUDU_GIVE_DATE').val()
                        },
                        cache: false,
                        type: "POST",
                        datatype: "json",
                        contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                        success: function (response, status) {
                            console.log(status);
                            if (status === 'success') {
                                alert('編號成功:' + $('#S_SAMPLE_NO').val() + '已新增完成');
                            }
                            else {
                                alert('編號有誤請通知資訊人員');
                            }
                        },
                        error: function (ex) {
                            console.log(ex.responseText);
                            alert('編號有誤請通知資訊人員');
                            return;
                        }
                    });
                }
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
                            "SUPLU_SEQ": $('#E_SUPLU_SEQ').val(),
                            "SAMPLE_NO": $('#E_SAMPLE_NO').val(),
                            "IVAN_TYPE": $('#E_IVAN_TYPE').val(),
                            "FACT_NO": $('#E_FACT_NO').val(),
                            "FACT_S_NAME": $('#E_FACT_S_NAME').val(),
                            "TMP_TYPE": $('#E_TMP_TYPE').val(),
                            "FACT_TYPE": $('#E_FACT_TYPE').val(),
                            "PROD_DESC": $('#E_PROD_DESC').val(),
                            "WORK_TYPE": $('#E_WORK_TYPE').val(),
                            "RPT_REMARK": $('#E_RPT_REMARK').val(),
                            "CUST_NO": $('#E_CUST_NO').val(),
                            "CUST_S_NAME": $('#E_CUST_S_NAME').val(),
                            "GIVE_WAY": $('#E_GIVE_WAY').val(),
                            "PUDU_NO": $('#E_PUDU_NO').val(),
                            "PUDU_CNT": $('#E_PUDU_CNT').val(),
                            "PUDU_DATE": $('#E_PUDU_DATE').val(),
                            "PUDU_GIVE_DATE": $('#E_PUDU_GIVE_DATE').val(),
                            "UNIT": $('#E_UNIT').val()
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
                            console.log(ex.responseText);
                            alert('新增資料有誤請通知資訊人員');
                            return;
                        }
                    });
                }
            };           

            //更新DB
            function UPD_SAMPLE() {
                var foreAmt = $.trim($('#E_FORE_AMT').val()) == '' ? 0 : $.trim($('#E_FORE_AMT').val());
                var usd = $.trim($('#E_USD').val()) == '' ? 0 : $.trim($('#E_USD').val());

                if ($('#E_SEQ').val() === '') {
                    alert('請選擇要修改的資料');
                }
                else if (foreAmt != 0 && usd == 0) {
                    alert('採用外幣時，主要貨幣美元未輸入!');
                }
                else if ($.trim($('#E_FORE_CODE').val()) != '' && foreAmt == 0) {
                    alert('有外幣幣別,無外幣單價 !');
                }
                else{
                    $.ajax({
                        url: apiUrl,
                        data: {
                            "Call_Type": "UPD_SAMPLE",
                            "SEQ": $('#E_SEQ').val(),
                            "SUPLU_SEQ": $('#E_SUPLU_SEQ').val(),
                            "SAMPLE_NO": $('#E_SAMPLE_NO').val(),
                            "FORCE_CLOSE": $('#E_FORCE_CLOSE').is(':checked') ? '1' : '0',
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
                            "FORE_CODE": $('#E_FORE_CODE').val(),
                            "FORE_AMT": $('#E_FORE_AMT').val(),
                            "MIN_2": $('#E_MIN_2').val(),
                            "PRICE_2": $('#E_PRICE_2').val(),
                            "MIN_3": $('#E_MIN_3').val(),
                            "PRICE_3": $('#E_PRICE_3').val(),
                            "AMT_CHANGE": amtChange
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
                            console.log(ex.responseText);
                            alert('修改資料有誤請通知資訊人員');
                            return;
                        }
                    });
                }
            };           

            //更新列印備註
            function UPD_RPT_REMARK() {
                if ($('#B_PUDU_NO').val() === '') {
                    alert('請選擇要修改的資料');
                }
                else {
                    $.ajax({
                        url: apiUrl,
                        data: {
                            "Call_Type": "UPD_RPT_REMARK",
                            "PUDU_NO": $('#B_PUDU_NO').val(),
                            "CURB_CODE": $('#B_CURB_CODE').val(),
                            "PRE_PAY_AMT_1": $('#B_PRE_PAY_AMT_1').val(),
                            "PRE_PAY_DATE_1": $('#B_PRE_PAY_DATE_1').val(),
                            "PRE_PAY_AMT_2": $('#B_PRE_PAY_AMT_2').val(),
                            "PRE_PAY_DATE_2": $('#B_PRE_PAY_DATE_2').val(),
                            "ADD_AMT": $('#B_ADD_AMT').val(),
                            "ADD_DESC": $('#B_ADD_DESC').val(),
                            "BIG_REMARK_1": $('#B_BIG_REMARK_1').val(),
                            "BIG_REMARK_2": $('#B_BIG_REMARK_2').val(),
                            "BIG_REMARK_3": $('#B_BIG_REMARK_3').val(),
                            "SPEC_REMARK": $('#B_SPEC_REMARK').val()
                        },
                        cache: false,
                        type: "POST",
                        datatype: "json",
                        contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                        success: function (response, status) {
                            console.log(status);
                            if (status === 'success') {
                                alert('採購單號:' + $('#B_PUDU_NO').val() + '已修改完成');
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

            //更新結案
            function UPD_WRITEOFF(type) {
                if ($('.tbChkBox:checked').length == 0) {
                    alert('請選擇要更新結案狀態的資料');
                }
                else {
                    var liSeq = [];
                    var rowcollection = $('#Table_Search_Sample').DataTable().$(".tbChkBox:checked");
                    rowcollection.each(function (index, elem) {
                        var seq = $(elem).parents("tr").find("td")[1].innerHTML;
                        liSeq.push(seq);
                    });
                 
                    $.ajax({
                        url: apiUrl,
                        data: {
                            "Call_Type": "UPD_WRITEOFF",
                            "SEQ": liSeq,
                            "FORCE_CLOSE": type
                        },
                        cache: false,
                        type: "POST",
                        datatype: "json",
                        contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                        success: function (response, status) {
                            if (status === 'success') {
                                var str = type == 1 ? '結案' : '未結案';
                                alert('已更新' + $('.tbChkBox:checked').length + '筆，狀態為' + str);
                                Search_Sample();
                            }
                            else {
                                alert('更新狀態有誤請通知資訊人員');
                            }
                        },
                        error: function (ex) {
                            console.log(ex.responseText);
                            alert('更新狀態有誤請通知資訊人員');
                            return;
                        }
                    });
                }
            };   

            //產生報表
            function PRINT_RPT() {
                if ($('#R_PUDU_NO_S').val() === '' && $('#R_RPT_TYPE').val() != '3') {
                    alert('請填寫採購單號');
                }
                else if ($('#R_PUDU_NO_1').val() === '' && $('#R_RPT_TYPE').val() == '3') {
                    alert('請填寫採購單號');
                }
                else {
                    $("body").loading(); // 遮罩開始

                    $.ajax({
                        url: apiUrl,
                        data: {
                            "Call_Type": "PRINT_RPT",
                            "PUDU_NO_S": $('#R_PUDU_NO_S').val(),
                            "PUDU_NO_E": $('#R_PUDU_NO_E').val(),
                            "WORK_TYPE": $('#R_RPT_TYPE').val(),
                            "PUDU_NO_1": $('#R_PUDU_NO_1').val(),
                            "PUDU_NO_2": $('#R_PUDU_NO_2').val(),
                            "PUDU_NO_3": $('#R_PUDU_NO_3').val(),
                            "PUDU_NO_4": $('#R_PUDU_NO_4').val(),
                            "PUDU_NO_5": $('#R_PUDU_NO_5').val()
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
                                        a.attr("download", "開發單.pdf");
                                        break;
                                    case "1":
                                        a.attr("download", "詢價單.pdf");
                                        break;
                                    case "2":
                                        a.attr("download", "索樣單.pdf");
                                        break;
                                    case "3":
                                        a.attr("download", "樣品到貨核對表.pdf");
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
            $('#Table_Search_Sample').on('click', 'tbody tr', function () {
                ClickToEdit($(this));
            });

            //BUTTON CLICK EVENT BASE 頁
            $('#BT_Search').on('click', function () {
                if (Edit_Mode !== "WriteOff") {
                    Form_Mode_Change("Search");
                }
                Search_Sample();
            });

            $('#BT_Cancel').on('click', function () {
                Edit_Mode = "Base";

                var Confirm_Check = confirm("<%=Resources.MP.Cancel_Alert%>");
                if (Confirm_Check) {
                    $('#Table_Search_Sample').DataTable().clear().draw();
                    Form_Mode_Change("Base");
                }
            });

            $('#BT_EDIT_SAVE').on('click', function () {
                UPD_SAMPLE();
            });

            $('#BT_Insert').on('click', function () {
                Edit_Mode = "Insert";
                Form_Mode_Change("Search");
            });

            $('#BT_Update').on('click', function () {
                Edit_Mode = "Edit";
                Form_Mode_Change("Search");
            });

            $('.supluAmt').change(function () {
                amtChange = 1;
            });

            $('#BT_INSERT_SAVE').on('click', function () {
                INSERT_SAMPLE();
            });

            $('#BT_INSERT_CLEAR').on('click', function () {
                $('.editReset').val('');
            });

            $('#BT_INSERT_CANCEL').on('click', function () {
                Edit_Mode = "Search";
                Form_Mode_Change("Search");
            });

            //編碼頁
            $('#BT_SET_SEQ').on('click', function () {
                SET_PURC_SEQ();
            });

            //列印備註頁
            $('#BT_UPD_REMARK').on('click', function () {
                UPD_RPT_REMARK();
            });

            //結案頁
            $('#BT_WRITEOFF').on('click', function () {
                UPD_WRITEOFF(1);
            });

            $('#BT_WRITEOFF_N').on('click', function () {
                UPD_WRITEOFF(0);
            });
            
            //報表頁
            $('#BT_PRINT').on('click', function () {
                PRINT_RPT();
            });

            $('#R_RPT_TYPE').on('change', function () {
                if ($('#R_RPT_TYPE').val() == '3') {
                    $('.sampleRpt').css('display', '');
                    $('.commonRpt').css('display', 'none');
                }
                else {
                    $('.sampleRpt').css('display', 'none');
                    $('.commonRpt').css('display', '');
                }
            });
            
            //功能選單
            $('#BT_BASE').on('click', function () {
                Edit_Mode = 'Base'
                if ($('#Table_Search_Sample > tbody tr[role=row]').length > 0 || $('#Table_CHS_Data > tbody tr[role=row]').length > 0)
                {
                    Form_Mode_Change('Search');
                }
                else {
                    Form_Mode_Change("Base");
                }
            });    

            $('#BT_SEQ').on('click', function () {
                Form_Mode_Change("SEQ");
            });   

            $('#BT_BIG_REMARK').on('click', function () {
                Form_Mode_Change("REMARK");
            });   

            $('#BT_S_WriteOff').on('click', function () {
                Edit_Mode = 'WriteOff'
                Form_Mode_Change("WriteOff");
            });   

            $('#BT_IMG').on('click', function () {
                Form_Mode_Change("IMG");
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
    <uc4:uc4 ID="uc4" runat="server" />
    <div style="width:98%;margin:0 auto; ">
        <div class="search_section_all">
            <table class="search_section_control">
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
                    <input id="Q_PUDU_DATE_S" type="date" class="date_S_style TB_DS" /><input id="Q_PUDU_DATE_E" type="date" class="date_E_style TB_DE" />
                    <input id="BT_Duo_Datetime_Picker" type="button" value="…" onclick="$('#Duo_Datetime_Picker_Dialog').dialog('open');" />
                </td>
                <td class="tdEditstyle">結案狀態</td>
                <td class="tdbstyle">
                    <select id="Q_WRITEOFF" >
                        <option selected="selected" value=""></option>
                        <option value="1">結案</option>
                        <option value="0">未結案</option>
                    </select>
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
            <input type="button" id="BT_SEQ" class="V_BT" value="編號" />
            <input type="button" id="BT_BIG_REMARK" class="V_BT" value="大備註" />
            <input type="button" id="BT_S_WriteOff" class="V_BT" value="結案"  />
            <input type="button" id="BT_IMG" class="V_BT" value="圖型" />
            <input type="button" id="BT_RPT" class="V_BT" value="報表" />
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
                            <input id="E_SAMPLE_NO"  class="textbox_char editReset" required="required" />
                        </td>
                        <td class="tdEditstyle">序號</td>
                        <td class="tdbstyle">
                            <input id="E_SEQ"  class="textbox_char editReset" disabled="disabled" />
                            <input id="E_SUPLU_SEQ" type="hidden" class="textbox_char editReset" />
                        </td>
                    </tr>
                    <tr class="trstyle">
                        <td class="tdEditstyle">頤坊型號</td>
                        <td class="tdbstyle">
                            <input id="E_IVAN_TYPE"  class="textbox_char editReset" disabled="disabled" />
                            <input id="BT_E_IVAN_TYPE" style="font-size:15px" type="button" value="..." />
                        </td>
                        <td class="tdEditstyle">強制結案</td>
                        <td class="tdbstyle">
                             <input id="E_FORCE_CLOSE" type="checkbox"  />
                        </td>
                    </tr>
                    <tr class="trstyle">
                        <td class="tdEditstyle">廠商編號</td>
                        <td class="tdbstyle">
                            <input id="E_FACT_NO"  class="textbox_char editReset" disabled="disabled" />
                        </td>
                        <td class="tdEditstyle">廠商簡稱</td>
                        <td class="tdbstyle">
                            <input id="E_FACT_S_NAME" class="textbox_char editReset" disabled="disabled"  />
                        </td>
                    </tr>
                    <tr class="trstyle">
                        <td class="tdEditstyle">暫時型號</td>
                        <td class="tdbstyle">
                            <input id="E_TMP_TYPE"  class="textbox_char editReset" disabled="disabled" />
                        </td>
                        <td class="tdEditstyle">廠商型號</td>
                        <td class="tdbstyle">
                            <input id="E_FACT_TYPE" class="textbox_char editReset" disabled="disabled"  />
                        </td>
                    </tr>
                    <tr class="trstyle">
                        <td class="tdEditstyle">產品說明</td>
                        <td class="tdbstyle" colspan ="4">
                            <input id="E_PROD_DESC" class="textbox_char editReset" style="width:80%" disabled="disabled"  />
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
                        <td class="tdEditstyle">單位</td>
                        <td class="tdbstyle">
                            <input id="E_UNIT"  class="textbox_char editReset" disabled="disabled" />
                        </td>
                    </tr>
                    <tr class="trstyle">
                        <td class="tdEditstyle">採購單號</td>
                        <td class="tdbstyle">
                            <input id="E_PUDU_NO"  class="textbox_char editReset" />
                        </td>
                        <td class="tdEditstyle">採購數量</td>
                        <td class="tdbstyle">
                            <input id="E_PUDU_CNT"  class="textbox_char editReset" type="number" />
                        </td>
                    </tr>
                     <tr class="trstyle">
                        <td class="tdEditstyle">採購日期</td>
                        <td class="tdbstyle">
                            <input id="E_PUDU_DATE"  class="textbox_char editReset" type="date"  />
                        </td>
                        <td class="tdEditstyle">採購交期</td>
                        <td class="tdbstyle">
                            <input id="E_PUDU_GIVE_DATE"  class="textbox_char editReset" type="date" />
                        </td>
                    </tr>
                    <tr class="trstyle">
                        <td class="tdEditstyle">客戶編號</td>
                        <td class="tdbstyle">
                            <input id="E_CUST_NO"  class="textbox_char editReset" disabled="disabled" />
                            <input id="BT_CUST_CHS" style="font-size:15px" type="button" value="..." />
                        </td>
                        <td class="tdEditstyle">客戶簡稱</td>
                        <td class="tdbstyle">
                            <input id="E_CUST_S_NAME"  class="textbox_char editReset" disabled="disabled" />
                        </td>
                    </tr>
                    <tr class="trstyle">
                        <td class="tdEditstyle">分配方式</td>
                        <td class="tdbstyle" colspan ="4">
                            <input id="E_GIVE_WAY" class="textbox_char editReset" style="width:80%"  />
                        </td>
                    </tr>     
                    <tr class="trstyle onlyEdit">
                        <td class="tdEditstyle">交期狀況</td>
                        <td class="tdbstyle" colspan ="4">
                            <input id="E_GIVE_STATUS" class="textbox_char editReset" style="width:80%"  />
                        </td>
                    </tr>     
                    <tr class="trstyle onlyEdit">
                        <td class="tdEditstyle">點收批號</td>
                        <td class="tdbstyle">
                            <input id="E_CHECK_NO"  class="textbox_char editReset" disabled="disabled"  />
                        </td>
                        <td class="tdEditstyle">點收日期</td>
                        <td class="tdbstyle">
                            <input id="E_CHECK_DATE" type="date" class="date_S_style editReset" disabled="disabled"  />
                        </td>
                    </tr>
                    <tr class="trstyle onlyEdit">
                        <td class="tdEditstyle">點收數量</td>
                        <td class="tdbstyle">
                            <input id="E_CHECK_CNT" class="textbox_char editReset" type="number" disabled="disabled" />
                        </td>
                        <td class="tdEditstyle">到貨數量</td>
                        <td class="tdbstyle">
                            <input id="E_ACC_SHIP_CNT" class="textbox_char editReset" type="number" disabled="disabled" />
                        </td>
                    </tr>
                    <tr class="trstyle onlyEdit">
                        <td class="tdEditstyle">出貨日期</td>
                        <td class="tdbstyle">
                            <input id="E_GIVE_SHIP_DATE"  class="textbox_char editReset"  disabled="disabled" />
                        </td>
                        <td class="tdEditstyle">到貨日期</td>
                        <td class="tdbstyle">
                            <input id="E_ACC_SHIP_DATE" type="date" class="date_S_style editReset" disabled="disabled"  />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4" class="onlyEdit" style="color:red">詢價、詢索、詢開如有更新單價欄位，會同步更新COST單價</td>
                    </tr>
                    <tr class="trstyle onlyEdit">
                        <td class="tdEditstyle">基本量_1</td>
                        <td class="tdbstyle">
                            <input id="E_MIN_1" class="textbox_char editReset supluAmt" type="number" />
                        </td>
                        <td class="tdEditstyle">美元單價</td>
                        <td class="tdbstyle">
                            <input id="E_USD"  class="textbox_char editReset supluAmt" type="number" />
                        </td>
                    </tr>
                    <tr class="trstyle onlyEdit">
                        <td class="tdEditstyle">列印備註</td>
                        <td class="tdbstyle">
                            <input id="E_RPT_REMARK"  class="textbox_char editReset" />
                        </td>
                        <td class="tdEditstyle">台幣單價</td>
                        <td class="tdbstyle">
                            <input id="E_NTD"  class="textbox_char editReset supluAmt" type="number" />
                        </td>
                    </tr>
                    <tr class="trstyle onlyEdit">
                        <td class="tdEditstyle">基本量_2</td>
                        <td class="tdbstyle">
                            <input id="E_MIN_2"  class="textbox_char editReset supluAmt" type="number" />
                        </td>
                        <td class="tdEditstyle">單價_2</td>
                        <td class="tdbstyle">
                            <input id="E_PRICE_2"  class="textbox_char editReset supluAmt" type="number" />
                        </td>
                    </tr>
                    <tr class="trstyle onlyEdit">
                        <td class="tdEditstyle">外幣幣別</td>
                        <td class="tdbstyle">
                            <input id="E_FORE_CODE"  class="textbox_char editReset supluAmt"  />
                        </td>
                        <td class="tdEditstyle">外幣單價</td>
                        <td class="tdbstyle">
                            <input id="E_FORE_AMT"  class="textbox_char editReset supluAmt" type="number" />
                        </td>
                    </tr>
                    <tr class="trstyle onlyEdit">
                         <td class="tdEditstyle">基本量_3</td>
                        <td class="tdbstyle">
                            <input id="E_MIN_3"  class="textbox_char editReset supluAmt" type="number" />
                        </td>
                        <td class="tdEditstyle">單價_3</td>
                        <td class="tdbstyle">
                            <input id="E_PRICE_3"  class="textbox_char editReset supluAmt" type="number" />
                        </td>
                    </tr>
                    <tr class="trstyle onlyEdit">
                        <td class="tdEditstyle">更新人員</td>
                        <td class="tdbstyle">
                            <input id="E_UPD_USER"  class="textbox_char editReset" disabled="disabled" />
                        </td>
                        <td class="tdEditstyle">更新日期</td>
                        <td class="tdbstyle">
                            <input id="E_UPD_DATE" type="date" class="date_S_style editReset" disabled="disabled" />
                        </td>
                    </tr>
                     <tr class="trCenterstyle"> 
                         <td colspan="4" style="text-align:center" >
                            <input type="button" id="BT_INSERT_SAVE" style="display:inline-block" class="BTN modeButton" value="新增儲存"  />
                            <input type="button" id="BT_EDIT_SAVE" style="display:inline-block" class="BTN modeButton" value="修改儲存"  />
                            <input type="button" id="BT_INSERT_CLEAR" style="display:inline-block" class="BTN modeButton" value="清空"  />
                            <input type="button" id="BT_INSERT_CANCEL" style="display:inline-block" class="BTN modeButton" value="返回"  />
                         </td>
                    </tr>
                </table>
            </div>
            <div id="Div_SET_SEQ" class=" Div_D" style="width:35%;height:71vh; border-style:solid;border-width:1px; float:right; ">
                <table class="search_section_control" style="width:auto">
                    <tr class="trstyle"> 
                        <td class="tdbstyle" style="height: 15vh; font-size: smaller;" >&nbsp</td>
                    </tr>
                    <tr class="trCenterstyle">
                        <td class="tdhstyle" style="font-size:20px;">樣品號碼</td>
                        <td class="tdbstyle">
                            <input id="S_SAMPLE_NO"  class="textbox_char" disabled="disabled" />
                        </td>
                    </tr>
                    <tr class="trCenterstyle">
                        <td class="tdhstyle" style="font-size:20px;">工作類別</td>
                        <td class="tdbstyle">
                            <input id="S_WORK_TYPE"  class="textbox_char" disabled="disabled" />
                        </td>
                    </tr>
                    <tr class="trCenterstyle">
                        <td class="tdhstyle" style="font-size:20px;">採購單號</td>
                        <td class="tdbstyle">
                            <input id="S_PUDU_NO"  class="textbox_char" disabled="disabled" />
                        </td>
                    </tr>
                    <tr class="trCenterstyle">
                        <td class="tdhstyle" style="font-size:20px;">採購交期</td>
                        <td class="tdbstyle">
                            <input id="S_PUDU_GIVE_DATE" type="date"  class="textbox_char" />
                        </td>
                    </tr>
                    <tr class="trstyle"> 
                        <td class="tdbstyle" style="height: 5vh; font-size: smaller;" >&nbsp</td>
                    </tr>
                     <tr class="trCenterstyle"> 
                         <td colspan="2" style="text-align:center" >
                            <input type="button" id="BT_SET_SEQ" style="display:inline-block" class="BTN" value="編號及設定交期"  />
                         </td>
                    </tr>
                </table>
            </div> 
            <div id="Div_BIG_REMARK" class=" Div_D" style="width:35%;height:71vh; border-style:solid;border-width:1px; float:right; ">
                <table class="edit_section_control">
                     <tr class="trstyle"> 
                        <td class="tdbstyle" style="height: 5vh; font-size: smaller;" >&nbsp</td>
                    </tr>
                    <tr class="trstyle">
                        <td class="tdEditstyle">採購單號</td>
                        <td class="tdbstyle">
                            <input id="B_PUDU_NO" class="textbox_char" disabled="disabled"   />
                        </td>
                        <td class="tdEditstyle">廠商簡稱</td>
                        <td class="tdbstyle">
                            <input id="B_FACT_S_NAME"  class="textbox_char" disabled="disabled"   />
                        </td>
                    </tr>
                    <tr class="trstyle">
                        <td class="tdEditstyle">大備註</td>
                        <td class="tdbstyle" colspan="4">
                            <input id="B_BIG_REMARK_1" class="textbox_char" style="width:90%"/>
                        </td>
                    </tr>
                    <tr class="trstyle">
                        <td class="tdEditstyle"></td>
                        <td class="tdbstyle" colspan="4">
                            <input id="B_BIG_REMARK_2" class="textbox_char" style="width:90%"/>
                        </td>
                    </tr>
                    <tr class="trstyle">
                        <td class="tdEditstyle"></td>
                        <td class="tdbstyle" colspan="4">
                            <input id="B_BIG_REMARK_3" class="textbox_char" style="width:90%"/>
                        </td>
                    </tr>
                    <tr class="trstyle">
                        <td class="tdEditstyle">幣別</td>
                        <td class="tdbstyle">
                            <select id="B_CURB_CODE">
                                <option selected="selected" value=""></option>
                                <option value="NTD">NTD</option>
                                <option value="HKD">HKD</option>
                                <option value="USD">USD</option>
                                <option value="RMB">RMB</option>
                            </select>
                        </td>
                    </tr>
                     <tr class="trstyle">
                        <td class="tdEditstyle">預付款一</td>
                        <td class="tdbstyle">
                            <input id="B_PRE_PAY_AMT_1" class="textbox_char" type="number"  />
                        </td>
                        <td class="tdEditstyle">預付日一</td>
                        <td class="tdbstyle">
                            <input id="B_PRE_PAY_DATE_1"  class="textbox_char" disabled="disabled"   />
                        </td>
                    </tr>
                    <tr class="trstyle">
                        <td class="tdEditstyle">預付款二</td>
                        <td class="tdbstyle">
                            <input id="B_PRE_PAY_AMT_2" class="textbox_char" type="number"  />
                        </td>
                        <td class="tdEditstyle">預付日二</td>
                        <td class="tdbstyle">
                            <input id="B_PRE_PAY_DATE_2"  class="textbox_char" disabled="disabled"   />
                        </td>
                    </tr>
                    <tr class="trstyle">
                        <td class="tdEditstyle">附加費</td>
                        <td class="tdbstyle">
                            <input id="B_ADD_AMT" class="textbox_char" type="number"  />
                        </td>
                        <td class="tdEditstyle">附加費說明</td>
                        <td class="tdbstyle">
                            <input id="B_ADD_DESC"  class="textbox_char" disabled="disabled"   />
                        </td>
                    </tr>
                    <tr class="trstyle">
                        <td class="tdEditstyle">特別事項</td>
                        <td class="tdbstyle" colspan="4">
                            <input id="B_SPEC_REMARK" class="textbox_char" style="width:90%"/>
                        </td>
                    </tr>
                    <tr class="trstyle"> 
                        <td class="tdbstyle" style="height: 10vh; font-size: smaller;" >&nbsp</td>
                    </tr>
                    <tr class="trCenterstyle"> 
                         <td colspan="4" style="text-align:center" >
                            <input type="button" id="BT_UPD_REMARK" style="display:inline-block" class="BTN" value="大備註更新"  />
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
                            <input id="I_IVAN_TYPE" class="textbox_char" disabled="disabled"  style="width:100%" />
                        </td>
                        <td class="tdEditstyle">廠商編號</td>
                        <td class="tdbstyle">
                            <input id="I_FACT_NO"  class="textbox_char" disabled="disabled" style="width:100%"  />
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
            <div id="Div_WriteOff" class=" Div_D" style="width:35%;height:71vh; border-style:solid;border-width:1px; float:right; ">
                <table class="search_section_control">
                    <tr class="trstyle"> 
                        <td class="tdbstyle" style="height: 20vh; font-size: smaller;" >&nbsp</td>
                    </tr>
                    <tr class="trCenterstyle"> 
                         <td colspan="4" style="text-align:center" >
                            <label style="font-size:20px" id="W_CHK_CNT"></label>
                         </td>
                    </tr>
                     <tr class="trstyle"> 
                        <td class="tdbstyle" style="height: 2vh; font-size: smaller;" >&nbsp</td>
                    </tr>
                     <tr class="trCenterstyle"> 
                         <td class="tdhstyle" style="text-align:center" >
                            <input type="button" id="BT_WRITEOFF" style="display:inline-block" class="BTN" value="結案"  />
                            <input type="button" id="BT_WRITEOFF_N" style="display:inline-block" class="BTN" value="取消結案"  />
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
                                <option selected="selected" value="0">開發單</option>
                                <option value="1">詢價單</option>
                                <option value="2">索樣單</option>
                                <option value="3">樣品到貨核對表</option>
                            </select>
                         </td>
                    </tr>
                    <tr class="trCenterstyle commonRpt">
                        <td class="tdhstyle" style="font-size:20px;" >採購單號</td>
                        <td class="tdbstyle" style="font-size:20px;">
                            <input id="R_PUDU_NO_S"  class="textbox_char" />~
                            <input id="R_PUDU_NO_E"  class="textbox_char" />
                        </td>
                    </tr>
                    <tr class="trCenterstyle sampleRpt" style="display:none">
                        <td class="tdhstyle" style="font-size:20px;" >採購單號</td>
                        <td class="tdbstyle" style="font-size:20px;">
                            <input id="R_PUDU_NO_1"  class="textbox_char" />
                        </td>
                    </tr>
                    <tr class="trCenterstyle sampleRpt" style="display:none">
                        <td class="tdhstyle" style="font-size:20px;" ></td>
                        <td class="tdbstyle" style="font-size:20px;">
                            <input id="R_PUDU_NO_2"  class="textbox_char" />
                        </td>
                    </tr>
                    <tr class="trCenterstyle sampleRpt" style="display:none">
                        <td class="tdhstyle" style="font-size:20px;" ></td>
                        <td class="tdbstyle" style="font-size:20px;">
                            <input id="R_PUDU_NO_3"  class="textbox_char" />
                        </td>
                    </tr>
                    <tr class="trCenterstyle sampleRpt" style="display:none">
                        <td class="tdhstyle" style="font-size:20px;" ></td>
                        <td class="tdbstyle" style="font-size:20px;">
                            <input id="R_PUDU_NO_4"  class="textbox_char" />
                        </td>
                    </tr>
                    <tr class="trCenterstyle sampleRpt" style="display:none">
                        <td class="tdhstyle" style="font-size:20px;" ></td>
                        <td class="tdbstyle" style="font-size:20px;">
                            <input id="R_PUDU_NO_5"  class="textbox_char" />
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
