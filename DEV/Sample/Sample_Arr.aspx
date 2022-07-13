<%@ Page Title="樣品到貨作業" Language="C#" MasterPageFile="~/MP.master" AutoEventWireup="true" CodeFile="Sample_Arr.aspx.cs" Inherits="Sample_Arr" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="/css/dataTables.bootstrap4.min.css" rel="stylesheet" />
    <script src="/js/jquery.dataTables.min.js"></script>
    <script src="/js/dataTables.bootstrap4.min.js"></script>
    <style type="text/css">
       .tableClick {
            color: white;
            background-color: rgb(90, 20, 0) !important;
        }
    </style>
    <script type="text/javascript">
        $(document).ready(function () {
            var Edit_Mode;
            var apiUrl = "/DEV/Sample/Sample_Arr.ashx";
            //隱藏滾動卷軸
            document.body.style.overflow = 'hidden';

            //init CONTROLER
            Form_Mode_Change("Base");
            $('#E_SHIP_GO_DATE').val($.datepicker.formatDate('yy-mm-dd', new Date()));
            $('#E_SHIP_ARR_DATE').val($.datepicker.formatDate('yy-mm-dd', new Date()));
            $('#E_ORDER_ARR_DATE').val($.datepicker.formatDate('yy-mm-dd', new Date()));

            $('#Table_EXEC_Data').DataTable({
                "destroy": true,
                "preDrawCallback": function (settings) {
                    pageScrollPos = $('div.dataTables_scrollBody').scrollTop();
                },
                "drawCallback": function (settings) {
                    $('div.dataTables_scrollBody').scrollTop(pageScrollPos);
                },
                "columns": [
                    { title: "點收批號" },
                    { title: "廠商簡稱" },
                    { title: "採購單號" },
                    { title: "頤坊型號" },
                    { title: "採購數量" },
                    { title: "累計點收" },
                    { title: "本次到貨" },
                    { title: "累計到貨" },
                    { title: "台幣單價" },
                    { title: "美元單價" },
                    { title: "外幣" },
                    { title: "發票異常" },
                    { title: "到貨備註" },
                    { title: "採購交期" },
                    { title: "產品說明" },
                    { title: "單位" },
                    { title: "暫時型號" },
                    { title: "廠商型號" },
                    { title: "廠商編號" },
                    { title: "採購日期" },
                    { title: "點收日期" },
                    { title: "到貨日期" },
                    { title: "工作類別" },
                    { title: "結案" },
                    { title: "序號" },
                    { title: "<%=Resources.MP.Update_User%>" },
                    { title: "<%=Resources.MP.Update_Date%>" }
                ],
                columnDefs: [{
                    className: "text-center",// 新增class
                }],
                "order": [[0, "asc"]], //根據 採購單號 排序
                "scrollX": true,
                "scrollY": "62vh",
                "searching": false,
                "paging": false,
                "bInfo": false //顯示幾筆隱藏
            });

            //Dialog
            $('#BT_TRANS_WAY').on('click', function () {
                $("#Search_Transfer_Dialog").dialog('open');
            });

            $('#SSD_Table_Transfer').on('click', '.SUP_SEL', function () {
                $('#E_TRANS_WAY_NO').val($(this).parent().parent().find('td:nth(1)').text());
                $('#E_TRANS_WAY').val($(this).parent().parent().find('td:nth(2)').text());
                $("#Search_Transfer_Dialog").dialog('close');
            });

            //$('#TB_Date_S').val($.datepicker.formatDate('yy-mm-dd', new Date()));
            //$('#TB_Date_E').val($.datepicker.formatDate('yy-mm-dd', new Date()));          

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
                        $('.V_BT').attr('disabled', false);
                        $('#BT_Cancel').css('display', 'none');
              
                        V_BT_CHG($('#BT_S_CHS'));
                        break;
                    case "Search":
                        $('.Div_D').css('display', 'none');
                        $('#Div_DT_Search').css('display', '');
                        $('#BT_Cancel').css('display', '');

                        //如果有修改內容切回選擇將到貨TABLE貼回去
                        if ($('#Table_EXEC_Data > tbody tr[role=row]').length != 0) {
                            $('#Table_CHS_Data').DataTable().clear().rows.add($('#Table_EXEC_Data').find('tbody tr[role=row]').clone()).draw(); 
                        }

                        V_BT_CHG($('#BT_S_CHS'));
                        break;
                    case "EXEC":
                        if ($('#Table_Search_Pudu > tbody tr[role=row]').length === 0) {
                            alert('請先查詢');
                            Edit_Mode = "Base";
                            Form_Mode_Change("Base");
                            return;
                        }
                        if ($('#Table_CHS_Data > tbody tr[role=row]').length === 0) {
                            alert('請至少選擇1筆');
                            Edit_Mode = "Base";

                            Form_Mode_Change("Search");
                            V_BT_CHG($('#BT_S_CHS'));
                            return;
                        }
                        else {
                            $('.Div_D').css('display', 'none');
                            $('#Div_DT_DETAIL').css('display', '');
                            $('#Div_IMG_DETAIL').css('display', 'none');
                            $('#Div_Exec_Section').css('display', '');
                            V_BT_CHG($('#BT_S_ARR'));
                   
                            $('#Table_EXEC_Data').DataTable().clear().rows.add($('#Table_CHS_Data').find('tbody tr[role=row]').clone()).draw(); //將選擇後TABLE 複製至第二面
                            $('#Table_EXEC_info').text('Showing ' + $('#Table_EXEC_Data > tbody tr[role=row]').length + ' entries'); //顯示TABLE 列數
                            $('#E_CNT').text('到貨筆數: ' + $('#Table_EXEC_Data > tbody tr[role=row]').length); 

                            //計算總金額
                            calAmt();

                            var $inputObj = $('#Table_EXEC_Data .tableInput');
                            $inputObj.attr('disabled', false);

                            break;
                        }
                    case "IMG":
                        $('.Div_D').css('display', 'none');
                        $('#Div_DT_DETAIL').css('display', '');
                        $('#Div_Exec_Section').css('display', 'none');
                        $('#Div_IMG_DETAIL').css('display', '');

                        $('#Table_EXEC_Data').DataTable().clear().rows.add($('#Table_CHS_Data').find('tbody tr[role=row]').clone()).draw(); //將選擇後TABLE 複製至第二面
                        $('#Table_EXEC_info').text('Showing ' + $('#Table_EXEC_Data > tbody tr[role=row]').length + ' entries'); //顯示TABLE 列數
                        $('#E_CNT').text('到貨筆數: ' + $('#Table_EXEC_Data > tbody tr[role=row]').length); 

                        V_BT_CHG($('#BT_S_EX_IMG'));
                        break;
                }
            }

            function calAmt() {
                //帶出總金額欄位
                var execCnt = $('#Table_EXEC_Data > tbody tr[role=row]').length;
                var foreignAmt = 0;
                var usd = 0;
                var ntd = 0;

                for (var tableCnt = 1; tableCnt <= execCnt; tableCnt++) {
                    var $tableRow = $('#Table_EXEC_Data > tbody tr:nth-child(' + tableCnt + ')');
                    var arrCnt = $tableRow.find('#E_ARR_CNT').val();

                    if (arrCnt != '' && parseInt(arrCnt) != 0) {
                        var index = $('#Table_EXEC_Data thead th:contains(外幣)').index() + 1;
                        var money = $tableRow.find('td:nth-child(' + index + ')').text();
                        if (money != '') {
                            foreignAmt += parseFloat(money) * parseFloat(arrCnt);
                        }

                        index = $('#Table_EXEC_Data thead th:contains(美元單價)').index() + 1;
                        money = $tableRow.find('td:nth-child(' + index + ')').text();
                        if (money != '') {
                            console.log(usd);
                            usd += parseFloat(money) * parseFloat(arrCnt);
                            console.log(usd);
                        }

                        index = $('#Table_EXEC_Data thead th:contains(台幣單價)').index() + 1;
                        money = $tableRow.find('td:nth-child(' + index + ')').text();
                        if (money != '') {
                            ntd += parseFloat(money) * parseFloat(arrCnt);
                        }
                    }
                }

                if (foreignAmt != 0) {
                    $('#E_TOT_AMT').val(foreignAmt.toFixed(2));
                }
                else if (usd != 0) {
                    $('#E_TOT_AMT').val(usd.toFixed(2));
                }
                else if (ntd != 0) {
                    $('#E_TOT_AMT').val(ntd.toFixed(2));
                }
                else {
                    $('#E_TOT_AMT').val('');
                }
            }

            $('#Table_EXEC_Data tbody').on('change', 'tr', function () {
                calAmt();
            });

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

            function Item_Move(click_tr, ToTable, FromTable, Full) {
                var seqIndex = FromTable.find('thead th:contains(序號)').index() + 1;
                if (Full) {
                    console.log(FromTable.find('tbody tr[role=row]'));
                    FromTable.find('tbody tr[role=row]').each(function () {
                        var OT = $(this).find('td:nth-child(' + seqIndex + ')').text();
                        if (ToTable.find('td:nth-child(' + seqIndex + ')').filter(function () { return $(this).text() == OT; }).length === 0) {
                            ToTable.DataTable().row.add($(this).clone());
                        }
                        else {
                            console.warn($(this));
                        }
                        FromTable.DataTable().rows($(this)).remove();
                    });
                    ToTable.DataTable().draw();
                    FromTable.DataTable().draw();
                }
                else {
                    FromTable.DataTable().rows(click_tr).remove().draw();
                    if (ToTable.find('td:nth-child(' + seqIndex + ')').filter(function () { return $(this).text() == click_tr.find('td:nth-child(' + seqIndex + ')').text(); }).length === 0) {
                        ToTable.DataTable().row.add(click_tr.clone()).draw();
                    }
                }

                $('#Table_CHS_Data_info').text('Showing ' + $('#Table_CHS_Data > tbody tr[role=row]').length + ' entries');
                $('#Table_Search_Pudu_info').text('Showing ' + $('#Table_Search_Pudu > tbody tr[role=row]').length + ' entries');
                $('#BT_Next').toggle(Boolean($('#Table_CHS_Data').find('tbody tr').length > 0));
            }
           
            function V_BT_CHG(buttonChs) {
                $('.V_BT').attr('disabled', false);
                buttonChs.attr('disabled', 'disabled');
            }
            //ajax function
            function Search_Pudu() {
                $.ajax({
                    url: apiUrl,
                    data:{
                        "Call_Type": "SEARCH_PUDU",    
                        "點收批號": $('#Q_CHK_BATCH_NO').val(),
                        "採購單號": $('#Q_PUDU_NO').val(),
                        "頤坊型號": $('#Q_IVAN_TYPE').val(),
                        "暫時型號": $('#Q_TMP_TYPE').val(),
                        "點收日期_S": $('#Q_CHK_DATE_S').val(),
                        "點收日期_E": $('#Q_CHK_DATE_E').val(),
                        "廠商編號": $('#Q_FACT_NO').val(),
                        "廠商簡稱": $('#Q_FACT_S_NAME').val(),
                        "WRITE_OFF": $('#Q_WRITEOFF').val()
                    },
                    cache: false,
                    type: "POST",
                    datatype: "json",
                    contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                    success: function (response, status) {
                        if (status != 'success') {
                            alert('編號有誤請通知資訊人員');
                            return;
                        }
                        if (response.length === 0) {
                            alert('<%=Resources.MP.Data_Not_Exists_Alert%>');
                            Edit_Mode = "Base";
                            Form_Mode_Change("Base");
                        }
                        else {
                            $('#Table_Search_Pudu_Tmp').DataTable({
                                "data": response,
                                "destroy": true,
                                "columns": [
                                    { data: "點收批號", title: "點收批號" },
                                    { data: "廠商簡稱", title: "廠商簡稱" },
                                    { data: "採購單號", title: "採購單號" },
                                    { data: "頤坊型號", title: "頤坊型號" },
                                    { data: "採購數量", title: "採購數量" },
                                    { data: "累計點收", title: "累計點收" },
                                    {
                                        data: null, title: "本次到貨",
                                        render: function (data, type, row) {
                                            return '<input type="number" id="E_ARR_CNT" class="tableInput" disabled="disabled" style="width:80px;text-align: right;" value = "0"  />'
                                        },
                                        orderable: false
                                    },
                                    { data: "累計到貨", title: "累計到貨" },
                                    { data: "台幣單價", title: "台幣單價" },
                                    { data: "美元單價", title: "美元單價" },
                                    { data: "外幣", title: "外幣" },
                                    {
                                        data: null, title: '發票異常',
                                        render: function (data, type, row) {
                                            return '<input type="checkbox" id="E_INVOICE_ERR" style="text-align:center" class="tbChkBox" />'
                                        },
                                        orderable: false
                                    },
                                    {
                                        data: null, title: "到貨備註",
                                        render: function (data, type, row) {
                                            return '<input type="text" id="E_SHIP_ARR_DEAL" class="tableInput" style="width:300px;text-align: left;" disabled="disabled" value = "' + row.到貨備註 + '"   />'
                                        },
                                        orderable: false
                                    },
                                    { data: "採購交期", title: "採購交期" },
                                    { data: "產品說明", title: "產品說明" },
                                    { data: "單位", title: "單位" },
                                    { data: "暫時型號", title: "暫時型號" },
                                    { data: "廠商型號", title: "廠商型號" },
                                    { data: "廠商編號", title: "廠商編號" },
                                    { data: "採購日期", title: "採購日期" },
                                    { data: "點收日期", title: "點收日期" },
                                    { data: "到貨日期", title: "到貨日期" },
                                    { data: "工作類別", title: "工作類別" },
                                    { data: "結案", title: "結案" },
                                    { data: "序號", title: "序號" },
                                    { data: "更新人員", title: "<%=Resources.MP.Update_User%>" },
                                    { data: "更新日期", title: "<%=Resources.MP.Update_Date%>" }
                                ],
                                columnDefs: [{
                                    className: "text-center",// 新增class
                                }],
                                "order": [[0, "asc"]], //根據 點收批號 排序
                                "scrollX": true,
                                "scrollY": "62vh",
                                "searching": false,
                                "paging": false,
                                "bInfo": false //顯示幾筆隱藏
                            });

                            $('#Table_Search_Pudu').DataTable({
                                "destroy": true,
                                "preDrawCallback": function (settings) {
                                    pageScrollPudu = $('#Table_Search_Pudu_wrapper div.dataTables_scrollBody').scrollTop();
                                },
                                "drawCallback": function (settings) {
                                    $('#Table_Search_Pudu_wrapper div.dataTables_scrollBody').scrollTop(pageScrollPudu);
                                },
                                "columns": [
                                    { title: "點收批號" },
                                    { title: "廠商簡稱" },
                                    { title: "採購單號" },
                                    { title: "頤坊型號" },
                                    { title: "採購數量" },
                                    { title: "累計點收" },
                                    { title: "本次到貨" },
                                    { title: "累計到貨" },
                                    { title: "台幣單價" },
                                    { title: "美元單價" },
                                    { title: "外幣" },
                                    { title: "發票異常" },
                                    { title: "到貨備註" },
                                    { title: "採購交期" },
                                    { title: "產品說明" },
                                    { title: "單位" },
                                    { title: "暫時型號" },
                                    { title: "廠商型號" },
                                    { title: "廠商編號" },
                                    { title: "採購日期" },
                                    { title: "點收日期" },
                                    { title: "到貨日期" },
                                    { title: "工作類別" },
                                    { title: "結案" },
                                    { title: "序號" },
                                    { title: "<%=Resources.MP.Update_User%>" },
                                    { title: "<%=Resources.MP.Update_Date%>" }
                                ],
                                columnDefs: [{
                                    className: "text-center",// 新增class
                                }],
                               "order": [[0, "asc"]], //根據 採購單號 排序
                               "scrollX": true,
                               "scrollY": "62vh",
                               "searching": false,
                               "paging": false,
                               "bInfo": false //顯示幾筆隱藏
                           });

                           $('#Table_CHS_Data').DataTable({
                               "destroy": true,
                               "preDrawCallback": function (settings) {
                                   pageScrollPos = $('div.dataTables_scrollBody').scrollTop();
                               },
                               "drawCallback": function (settings) {
                                   $('div.dataTables_scrollBody').scrollTop(pageScrollPos);
                               },
                                "columns": [
                                    { title: "點收批號" },
                                    { title: "廠商簡稱" },
                                    { title: "採購單號" },
                                    { title: "頤坊型號" },
                                    { title: "採購數量" },
                                    { title: "累計點收" },
                                    { title: "本次到貨" },
                                    { title: "累計到貨" },
                                    { title: "台幣單價" },
                                    { title: "美元單價" },
                                    { title: "外幣" },
                                    { title: "發票異常" },
                                    { title: "到貨備註" },
                                    { title: "採購交期" },
                                    { title: "產品說明" },
                                    { title: "單位" },
                                    { title: "暫時型號" },
                                    { title: "廠商型號" },
                                    { title: "廠商編號" },
                                    { title: "採購日期" },
                                    { title: "點收日期" },
                                    { title: "到貨日期" },
                                    { title: "工作類別" },
                                    { title: "結案" },
                                    { title: "序號" },
                                    { title: "<%=Resources.MP.Update_User%>" },
                                    { title: "<%=Resources.MP.Update_Date%>" }
                               ],
                               "order": [[0, "asc"]], //根據 點收批號 排序
                               "scrollX": true,
                               "scrollY": "62vh",
                               "searching": false,
                               "paging": false,
                               "bInfo": false //顯示幾筆隱藏
                           });

                            //input 欄位 Undefind 問題 調整為 先存TMP TABLE 再將 VALUE 複製到正式 table 
                            $('#Table_Search_Pudu_Tmp').DataTable().draw();
                            $('#Table_Search_Pudu').DataTable().draw();
                            $('#Table_Search_Pudu').DataTable().clear().rows.add($('#Table_Search_Pudu_Tmp').find('tbody tr[role=row]').clone()).draw();

                            $('#Table_CHS_Data').DataTable().draw();
                            $('#Table_CHS_Data_info').text('Showing ' + $('#Table_CHS_Data > tbody tr[role=row]').length + ' entries');
                            $('#Table_Search_Pudu_info').text('Showing ' + $('#Table_Search_Pudu > tbody tr[role=row]').length + ' entries');
                        }
                    },
                    error: function (ex) {
                        console.log(ex.responseText);
                        alert('查詢有誤請通知資訊人員');
                        return;
                    }
                });
            };          
 
            //寫入點收 TABLE
            function INSERT_RECU() {
                var liSeq = [];
                var liArrCnt = [];
                var liInvoiceErr = [];
                var liShipArrDeal = [];
                var execCnt = $('#Table_EXEC_Data > tbody tr[role=row]').length;

                for (var tableCnt = 1; tableCnt <= execCnt; tableCnt++) {
                    var $tableRow = $('#Table_EXEC_Data > tbody tr:nth-child(' + tableCnt + ')');
                    var arrCnt = $tableRow.find('#E_ARR_CNT').val();
                    if (arrCnt == '' || arrCnt == 0) {
                        alert('第' + tableCnt + '筆，本次到貨不可為 0!');
                        return;
                    }

                    var seqIndex = $('#Table_EXEC_Data thead th:contains(序號)').index() + 1; //序號INDEX
                    var seq = $tableRow.find('td:nth-child(' + seqIndex + ')').text();
                    var invoiceErr = $tableRow.find('#E_INVOICE_ERR').is(":checked");
                    var shipArrDeal = $tableRow.find('#E_SHIP_ARR_DEAL').val();


                    liSeq.push(seq);
                    liArrCnt.push(arrCnt);
                    liInvoiceErr.push(invoiceErr);
                    liShipArrDeal.push(shipArrDeal);
                }

                $.ajax({
                    url: apiUrl,
                    data: {
                        "Call_Type": "INSERT_RECU",
                        "SEQ": liSeq,
                        "INVOICE_ERR": liInvoiceErr,
                        "SHIP_ARR_REMARK": liShipArrDeal,
                        "ARR_CNT": liArrCnt,
                        "SHIP_GO_DATE": $('#E_SHIP_GO_DATE').val(),
                        "SHIP_ARR_DATE": $('#E_SHIP_ARR_DATE').val(),
                        "SHIP_ARR_NO": $('#E_SHIP_ARR_NO').val(),
                        "ORDER_ARR_DATE": $('#E_ORDER_ARR_DATE').val(),
                        "NO_PAY": $('#E_SAMPLE_NO_PAY').is(":checked"),
                        "FORCE_CLOSE": $('#E_FORCE_CLOSE').is(":checked"),
                        "INVOICE_TYPE": $('#E_INVOICE_TYPE').val(),
                        "INVOICE_NO": $('#E_INVOICE_NO').val()
                    },
                    cache: false,
                    type: "POST",
                    datatype: "json",
                    contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                    success: function (response, status) {
                        console.log(status);
                        if (status != "success") {
                            console.log(response);
                            alert('寫入有誤請通知資訊人員');
                            return;
                        }
                        else {
                            alert('已寫入到貨檔，筆數:' + execCnt);
                            $('#Table_EXEC_Data').DataTable().rows().remove().draw();
                            $('#Table_CHS_Data').DataTable().rows().remove().draw();

                            //回到第一頁
                            Search_Pudu();
                            Edit_Mode = "Search";
                            Form_Mode_Change("Search");
                        }
                    },
                    error: function (ex) {
                        console.log(ex.responseText);
                        alert('寫入有誤請通知資訊人員');
                        return;
                    }
                });
            };         

            //TABLE 功能設定
            $('#Table_Search_Pudu').on('click', 'tbody tr', function () {   
                Item_Move($(this), $('#Table_CHS_Data'), $('#Table_Search_Pudu'), false);
            });
            $('#Table_CHS_Data').on('click', 'tbody tr', function () {
                Item_Move($(this), $('#Table_Search_Pudu'), $('#Table_CHS_Data'), false);
            });
            $('#BT_ATR').on('click', function () {
                Item_Move($(this), $('#Table_CHS_Data'), $('#Table_Search_Pudu'), true);
            });
            $('#BT_ATL').on('click', function () {            
                Item_Move($(this), $('#Table_Search_Pudu'), $('#Table_CHS_Data'), true);
            });
            $('#BT_Next').on('click', function () {
                Edit_Mode = "Edit";
                Form_Mode_Change("EXEC");
            });
            

            //BUTTON CLICK EVENT BASE 頁
            $('#BT_Search').on('click', function () {
                Edit_Mode = "Base";
                Form_Mode_Change("Search");
                Search_Pudu();
            });

            $('#BT_Cancel').on('click', function () {
                $('#Table_Search_Pudu').DataTable().clear().draw();
                $('#Table_CHS_Data').DataTable().clear().draw();

                var Confirm_Check = confirm("<%=Resources.MP.Cancel_Alert%>");
                if (Confirm_Check) {
                    Edit_Mode = "Base";
                    Form_Mode_Change("Base");
                }
            });

            //BUTTON CLICK EVENT 執行頁
            $('#BT_EXECUTE').on('click', function () {
                if ($('#Table_EXEC_Data > tbody tr[role=row]').length == 0) {
                    alert('請選擇點收資料!');
                    return;
                }
                if ($('#E_CHK_BATCH_NO').val() === '') {
                    alert('點收批號不可為空白');
                    return;
                }  

                INSERT_RECU();
            });

            $('#Table_EXEC_Data').on('click', 'tbody tr', function () {
                //點擊賦予顏色
                $('#Table_EXEC_Data > tbody tr').removeClass("tableClick");
                $(this).addClass("tableClick");

                //IMG page
                var clickData = $('#Table_EXEC_Data').DataTable().row($(this)).data();
                var index = $('#Table_EXEC_Data thead th:contains(頤坊型號)').index(); 
                $('#I_IVAN_TYPE').val(clickData[index]);
                index = $('#Table_EXEC_Data thead th:contains(廠商編號)').index(); 
                $('#I_FACT_NO').val(clickData[index]);
                index = $('#Table_EXEC_Data thead th:contains(廠商簡稱)').index(); 
                $('#I_FACT_S_NAME').val(clickData[index]);
                index = $('#Table_EXEC_Data thead th:contains(產品說明)').index(); 
                $('#I_PROD_DESC').val(clickData[index]);
                Search_IMG($('#I_FACT_NO').val(), $('#I_IVAN_TYPE').val());
            });

            $('#BT_EXECUTE_CANCEL').on('click', function () {
                Edit_Mode = "Base";
                Form_Mode_Change("Search");
            });

            //BUTTON CLICK REPORT 執行頁
            $('#BT_PRINT').on('click', function () {
                GenerateRPT();
            });

            //功能選單
            $('#BT_S_CHS').on('click', function () {
                Edit_Mode = "Base";
                if($('#Table_Search_Pudu > tbody tr[role=row]').length > 0)
                {
                    Form_Mode_Change("Search");
                }
                else {
                    Form_Mode_Change("Base");
                }
            });

            $('#BT_S_ARR').on('click', function () {
                Edit_Mode = "EXEC";
                Form_Mode_Change("EXEC");
            });          

            $('#BT_S_EX_IMG').on('click', function () {
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
                <td style="height: 10px; font-size: smaller;" colspan="8">&nbsp</td>
            </tr>
            <tr class="trstyle">
                <td class="tdhstyle">點收批號</td>
                <td class="tdbstyle">
                    <input id="Q_CHK_BATCH_NO" class="textbox_char" />
                </td>
                <td class="tdhstyle">採購單號</td>
                <td class="tdbstyle">
                    <input id="Q_PUDU_NO"  class="textbox_char" />
                </td>
                <td class="tdhstyle">點收日期</td>
                <td class="tdbstyle">
                    <input id="Q_CHK_DATE_S" type="date" class="date_S_style" />~<input id="Q_CHK_DATE_E" type="date" class="date_E_style" />
                </td>
            </tr>
            <tr class="trstyle">
                <td class="tdhstyle">頤坊型號</td>
                <td class="tdbstyle">
                    <input id="Q_IVAN_TYPE"  class="textbox_char" />
                </td>
                <td class="tdhstyle">暫時型號</td>
                <td class="tdbstyle">
                    <input id="Q_TMP_TYPE"  class="textbox_char" />
                </td>
                <td class="tdhstyle">結案狀態</td>
                <td class="tdbstyle">
                    <select id="Q_WRITEOFF" >
                        <option selected="selected"value="0">未結案</option>
                        <option value="">全部</option>
                    </select>
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
                <td class="tdtstyleRight" colspan="6">
                    <input type="button" id="BT_Search" class="buttonStyle" value="<%=Resources.MP.Search%>" />
                    <input type="button" id="BT_Cancel" class="buttonStyle" value="<%=Resources.MP.Cancel%>" style="display: none;" />
                </td>
            </tr>
        </table>
        </div>
        <div class="button_change_section">
            &nbsp;
            <input type="button" id="BT_S_CHS" class="V_BT" value="選擇"  disabled="disabled" />
            <input type="button" id="BT_S_ARR" class="V_BT" value="到貨內容" />
            <input type="button" id="BT_S_EX_IMG" class="V_BT" value="圖型" />
        </div>

        <div id="Div_DT_Search" class=" Div_D">
            <div id="Div_DT_View" style=" width:70%;height:71vh; border-style:solid;border-width:1px; float:left;">
                <div class="dataTables_info" id="Table_Search_Pudu_info" role="status" aria-live="polite"></div>
                <div style="display:none">
                    <table id="Table_Search_Pudu_Tmp" class="Table_Search table table-striped table-bordered" >
                        <thead style="white-space:nowrap"></thead>
                        <tbody style="white-space:nowrap"></tbody>
                    </table>
                </div>
                <table id="Table_Search_Pudu" class="Table_Search table table-striped table-bordered">
                    <thead style="white-space:nowrap"></thead>
                    <tbody style="white-space:nowrap"></tbody>
                </table>
            </div>
    
            <div id="Div_Exec_Data" style="width:25%;height:71vh; border-style:solid;border-width:1px; float:right;">
                <div class="dataTables_info" id="Table_CHS_Data_info" role="status" aria-live="polite"></div>
                <table id="Table_CHS_Data" style="width: 100%;" class="Table_Search table table-striped table-bordered">
                    <thead style="white-space:nowrap"></thead>
                    <tbody style="white-space:nowrap"></tbody>
                </table>
            </div>
    
            <div style="width:5%; float:right;margin:0 auto;text-align:center;height:80vh;">
                <table style="width:100%;height:100%;">
                    <tr>
                        <td style="width:100%;height:100%;vertical-align:middle;">
                            <input id="BT_ATR" type="button" value=">>" class="BTN_Green"  />
                            <br /><br />
                            <input id="BT_ATL" type="button" value="<<" class="BTN_Green" />
                            <br /><br />
                            <input id="BT_Next" type="button" value="Next" style="inline-size:100%;" class="BTN" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>

        <div id="Div_DT_DETAIL" class=" Div_D" style="white-space:nowrap">
            <div id="Div_DETAIL_VIEW"  style="width:70%;height:71vh; border-style:solid;border-width:1px; float:left;">
                <div class="dataTables_info" id="Table_EXEC_info" role="status" aria-live="polite"></div>
                    <table id="Table_EXEC_Data" class="Table_Search table table-striped table-bordered">
                        <thead style="white-space:nowrap"></thead>
                        <tbody style="white-space:nowrap"></tbody>
                    </table>
            </div>
    
            <div id="Div_Exec_Section" style="width:28%;height:71vh; border-style:solid;border-width:1px; float:right;">
                <table class="edit_section_control">
                    <tr> 
                        <td style="height: 2vh; font-size: smaller;" >&nbsp</td>
                    </tr>
                    <tr class="trCenterstyle" >
                        <td colspan="2"  id="E_CNT" style="font-size:20px" >到貨筆數:</td>
                    </tr>
                    <tr> 
                        <td style="height: 10vh; font-size: smaller;" >&nbsp</td>
                    </tr>
                    <tr class="trCenterstyle">
                        <td class="tdhstyle" style="font-size:20px">出貨日期</td>
                        <td class="tdbstyle">
                            <input id="E_SHIP_GO_DATE" type="date" class="date_S_style" />
                        </td>
                    </tr>
                    <tr class="trCenterstyle">
                        <td class="tdhstyle" style="font-size:20px">到貨日期</td>
                        <td class="tdbstyle">
                            <input id="E_SHIP_ARR_DATE" type="date" class="date_S_style" />
                        </td>
                    </tr>
                    <tr class="trCenterstyle">
                        <td class="tdhstyle" style="font-size:20px">到單日期</td>
                        <td class="tdbstyle">
                            <input id="E_ORDER_ARR_DATE" type="date" class="date_S_style" />
                        </td>
                    </tr>
                    <tr class="trCenterstyle">
                        <td class="tdhstyle" style="font-size:20px">到貨單號</td>
                        <td class="tdbstyle">
                            <input id="E_SHIP_ARR_NO"  class="textbox_char" />
                        </td>
                    </tr>
                    <tr class="trCenterstyle">
                        <td class="tdhstyle" style="font-size:20px">發票樣式</td>
                        <td class="tdbstyle">
                            <select id="E_INVOICE_TYPE" >
                                <option selected="selected"value=""></option>
                                <option value="21">21-三聯式</option>
                                <option value="22">22-二聯式</option>
                                <option value="23">23-三聯式折讓單</option>
                                <option value="24">24-二聯式折讓單</option>
                                <option value="25">25-三聯式收銀機</option>
                                <option value="99">99-香港-INVOICE</option>
                            </select>
                        </td>
                    </tr>
                    <tr class="trCenterstyle">
                        <td class="tdhstyle" style="font-size:20px">發票號碼</td>
                        <td class="tdbstyle">
                            <input id="E_INVOICE_NO"  class="textbox_char" />
                        </td>
                    </tr>
                     <tr class="trCenterstyle">
                        <td style="font-size:20px" colspan="2" >
                            樣品不付款
                            <input id="E_SAMPLE_NO_PAY" type="checkbox"  /> 
                            強制結案
                            <input id="E_FORCE_CLOSE" type="checkbox"  />
                        </td>
                        
                    </tr>
                    <tr class="trCenterstyle">
                        <td class="tdhstyle" style="font-size:20px">總金額</td>
                        <td class="tdbstyle">
                            <input id="E_TOT_AMT"  class="textbox_char" disabled="disabled" />
                        </td>
                    </tr>
                    <tr class="trstyle"> 
                        <td class="tdbstyle" style="height: 15vh; font-size: smaller;" >&nbsp</td>
                    </tr>
                    <tr class="trCenterstyle">
                        <td colspan="2">
                            <input id="BT_EXECUTE" style="font-size:20px" type="button" value="執行"  />
                            <input id="BT_EXECUTE_CANCEL" style="font-size:20px" type="button" value="返回" />
                        </td>
                    </tr>
                </table>
            </div> 

            <div id="Div_IMG_DETAIL" style="height:71vh; border-style:solid;border-width:1px; float:right; overflow:auto ">
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
