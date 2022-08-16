<%@ Page Title="樣品準備作業" Language="C#" MasterPageFile="~/MP.master" AutoEventWireup="true" CodeFile="Sample_Chk_Dist.aspx.cs" Inherits="Sample_Chk_Dist" %>
<%@ Register TagPrefix="uc" TagName="uc1" Src="~/User_Control/Dia_Customer_Selector.ascx" %>
<%@ Register TagPrefix="uc2" TagName="uc2" Src="~/User_Control/Dia_Product_ALL.ascx" %>
<%@ Register TagPrefix="uc3" TagName="uc3" Src="~/User_Control/Dia_Duo_Datetime_Picker.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="/css/dataTables.bootstrap4.min.css" rel="stylesheet" />
    <script src="/js/jquery.dataTables.min.js"></script>
    <script src="/js/dataTables.bootstrap4.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            var Edit_Mode;
            var Exec_Mode;
            var Data_Source = 'recua';
            var apiUrl = "/DEV/Sample/Ashx/Sample_Chk_Dist.ashx";
            //隱藏滾動卷軸
            document.body.style.overflow = 'hidden';

            window.document.body.onbeforeunload = function () {
                if (Edit_Mode === "Edit") {
                    return '您尚未將編輯過的表單資料送出，請問您確定要離開網頁嗎？';
                }
            }

            //init CONTROLER
            Form_Mode_Change("Base");
            $('.onlyStkio').toggle(false);
            $('.onlyRecua').toggle(true);

            $('#Table_EXEC_Data').DataTable({
                "destroy": true,
                "drawCallback": function (settings) {
                    Re_Bind_Inner_JS();
                },
                "columns": [
                    { title: "批號" },
                    { title: "頤坊型號" },
                    { title: "產品說明" },
                    { title: "單位" },
                    { title: "內湖庫存數" },
                    { title: "備貨數量" },
                    { title: "內湖庫位" },
                    { title: "到貨處理" },
                    { title: "廠商編號" },
                    { title: "廠商簡稱" },
                    { title: "暫時型號" },
                    { title: "採購單號" },
                    { title: "<%=Resources.MP.Update_User%>" },
                    { title: "<%=Resources.MP.Update_Date%>" },
                    { title: "序號" }
                ],
                "columnDefs": [
                    {
                        className: 'text-right', targets: [4] //數字靠右
                    },
                ],
                "order": [[0, "asc"]], //根據 採購單號 排序
                "scrollX": true,
                "scrollY": "62vh",
                "searching": false,
                "paging": false,
                "bInfo": false //顯示幾筆隱藏
            });   

            //Dialog
            $('#SG_BT_CUST_CHS').on('click', function () {
                $("#Search_Customer_Dialog").dialog('open');
            });

            $('#SCD_Table_Customer').on('click', '.CUST_SEL', function () {
                $('#SG_CUST_NO').val($(this).parent().parent().find('td:nth(2)').text());
                $('#SG_CUST_S_NAME').val($(this).parent().parent().find('td:nth(3)').text());
                $("#Search_Customer_Dialog").dialog('close');
            });

            //上下移功能 根據每個頁面客製
            $(document).keydown(function (event) {
                var key = (event.keyCode ? event.keyCode : event.which);
                var clickIndex = $('#Table_EXEC_Data > tbody > tr.tableClick').index();
                if (key == '40') {
                    if (clickIndex < $('#Table_EXEC_Data tbody tr').length - 1) {
                        clickIndex++;
                        ClickAddClass($('#Table_EXEC_Data > tbody > tr:nth(' + clickIndex + ')'));
                    }
                }
                else if (key == '38') {
                    if (clickIndex > 0) {
                        clickIndex--;
                        ClickAddClass($('#Table_EXEC_Data > tbody > tr:nth(' + clickIndex + ')'));
                    }
                }
            });

            function ClickAddClass($click) {
                //點擊賦予顏色
                $('#Table_EXEC_Data > tbody tr').removeClass("tableClick");
                $click.addClass("tableClick");

                //IMG page
                var clickData = $('#Table_EXEC_Data').DataTable().row($click).data();
                var index = $('#Table_EXEC_Data thead th:contains(頤坊型號)').index();
                $('#I_IVAN_TYPE').val(clickData[index]);
                index = $('#Table_EXEC_Data thead th:contains(廠商編號)').index();
                $('#I_FACT_NO').val(clickData[index]);
                index = $('#Table_EXEC_Data thead th:contains(廠商簡稱)').index();
                $('#I_FACT_S_NAME').val(clickData[index]);
                index = $('#Table_EXEC_Data thead th:contains(產品說明)').index();
                $('#I_PROD_DESC').val(clickData[index]);
                index = $('#Table_EXEC_Data thead th:contains(序號)').index();
                $('#I_SUPLU_SEQ').val(clickData[index]);
                Search_IMG($('#I_SUPLU_SEQ').val());
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

                        $('#Table_Search_Data_info').text('Showing ' + $('#Table_Search_Data > tbody tr[role=row]').length + ' entries');
                        $('#Table_CHS_Data_info').text('Showing ' + $('#Table_CHS_Data > tbody tr[role=row]').length + ' entries');
                        V_BT_CHG($('#BT_S_CHS'));
                        break;
                    case "EXEC":
                        if ($('#Table_Search_Data > tbody tr[role=row]').length === 0 && $('#Table_CHS_Data > tbody tr[role=row]').length === 0) {
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
                            $('.ExecSection').css('display', 'none');
                            V_BT_CHG($('#BT_S_SHIP_GO'));

                            $('#Div_Exec_Ship_Go_Section').css('display', '');
                            $('#Table_EXEC_Data').DataTable().clear().rows.add($('#Table_CHS_Data').find('tbody tr[role=row]').clone()).draw(); //將選擇後TABLE 複製至第二面
                            $('#Table_EXEC_info').text('Showing ' + $('#Table_EXEC_Data > tbody tr[role=row]').length + ' entries'); //顯示TABLE 列數
                            var $inputObj = $('#Table_EXEC_Data .tableInput');
                            $inputObj.attr('disabled', false);

                            break;
                        }
                    case "IMG":
                        $('.Div_D').css('display', 'none');
                        $('#Div_DT_DETAIL').css('display', '');
                        $('.ExecSection').css('display', 'none');
                        $('#Div_IMG_DETAIL').css('display', '');

                        $('#Table_EXEC_Data').DataTable().clear().rows.add($('#Table_CHS_Data').find('tbody tr[role=row]').clone()).draw(); //將選擇後TABLE 複製至第二面
                        $('#Table_EXEC_info').text('Showing ' + $('#Table_EXEC_Data > tbody tr[role=row]').length + ' entries'); //顯示TABLE 列數
                        $('#E_CNT').text('到貨筆數: ' + $('#Table_EXEC_Data > tbody tr[role=row]').length); 

                        V_BT_CHG($('#BT_S_EX_IMG'));
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

            function Item_Move(click_tr, ToTable, FromTable, Full) {
                var seqIndex = FromTable.find('thead th:contains(序號)').index() + 1;
                if (Full) {
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
                $('#Table_Search_Data_info').text('Showing ' + $('#Table_Search_Data > tbody tr[role=row]').length + ' entries');
                $('#BT_Next').toggle(Boolean($('#Table_CHS_Data').find('tbody tr').length > 0));
            }
           
            function V_BT_CHG(buttonChs) {
                $('.V_BT').attr('disabled', false);
                buttonChs.attr('disabled', 'disabled');
            }
            //ajax function
            function Search_Recua() {
                Data_Source = $('#Q_DATA_SOURCE').val();

                $.ajax({
                    url: apiUrl,
                    data:{
                        "Call_Type": "SEARCH",    
                        "DATA_SOURCE": $('#Q_DATA_SOURCE').val(),
                        "點收批號": $('#Q_CHK_BATCH_NO').val(),
                        "採購單號": $('#Q_PUDU_NO').val(),
                        "頤坊型號": $('#Q_IVAN_TYPE').val(),
                        "點收日期_S": $('#Q_CHK_DATE_S').val(),
                        "點收日期_E": $('#Q_CHK_DATE_E').val(),
                        "廠商編號": $('#Q_FACT_NO').val(),
                        "廠商簡稱": $('#Q_FACT_S_NAME').val(),
                        "訂單號碼": $('#Q_ORDER_NO').val()
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
                            $('#Table_Search_Tmp').DataTable({
                                "data": response,
                                "destroy": true,
                                "columns": [
                                    { data: "點收批號", title: "批號" },
                                    {
                                        data: "頤坊型號", title: "頤坊型號",
                                        render: function (data, type, row) {
                                            return '<input class="Call_Product_Tool" SUPLU_SEQ = "' + (row.序號 ?? "")
                                                + '" type="button" value="' + (data ?? "")
                                                + '" style="text-align:left;width:100%;z-index:1000;' + ((row.Has_IMG) ? 'background: #90ee90;' : '') + '" />'
                                        },
                                        orderable: false
                                    },
                                    { data: "產品說明", title: "產品說明" },
                                    { data: "單位", title: "單位" },
                                    { data: "內湖庫存數", title: "內湖庫存數" },
                                    {
                                        data: "備貨數量", title: "備貨數量",
                                        render: function (data, type, row) {
                                            return '<input type="number" id="E_APP_CNT" class="tableInput" disabled="disabled" style="width:80px;text-align: right;" value = "' + data + '"  />'
                                        },
                                        orderable: false
                                    },
                                    { data: "內湖庫位", title: "內湖庫位" },
                                    { data: "到貨處理", title: "到貨處理" },
                                    { data: "廠商編號", title: "廠商編號" },
                                    { data: "廠商簡稱", title: "廠商簡稱" },
                                    { data: "暫時型號", title: "暫時型號" },
                                    { data: "採購單號", title: "採購單號" },
                                    { data: "更新人員", title: "<%=Resources.MP.Update_User%>" },
                                    { data: "更新日期", title: "<%=Resources.MP.Update_Date%>" },
                                    { data: "序號", title: "序號" }
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

                            $('#Table_Search_Data').DataTable({
                                "destroy": true,
                                "preDrawCallback": function (settings) {
                                    searchPageScroll = $('#Table_Search_Data_wrapper div.dataTables_scrollBody').scrollTop();
                                },
                                "drawCallback": function (settings) {
                                    $('#Table_Search_Data_wrapper div.dataTables_scrollBody').scrollTop(searchPageScroll);
                                    Re_Bind_Inner_JS();
                                },
                                "columns": [
                                    { title: "批號" },
                                    { title: "頤坊型號" },
                                    { title: "產品說明" },
                                    { title: "單位" },
                                    { title: "內湖庫存數" },
                                    { title: "備貨數量" },
                                    { title: "內湖庫位" },
                                    { title: "到貨處理" },
                                    { title: "廠商編號" },
                                    { title: "廠商簡稱" },
                                    { title: "暫時型號" },
                                    { title: "採購單號" },
                                    { title: "<%=Resources.MP.Update_User%>" },
                                    { title: "<%=Resources.MP.Update_Date%>" },
                                    { title: "序號" }
                                ],
                                "columnDefs": [
                                    {
                                        className: 'text-right', targets: [4] //數字靠右
                                    },
                                ],
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
                                   chsPageScroll = $('Table_CHS_Data_wrapper div.dataTables_scrollBody').scrollTop();
                               },
                               "drawCallback": function (settings) {
                                   $('Table_CHS_Data_wrapper div.dataTables_scrollBody').scrollTop(chsPageScroll);
                                   Re_Bind_Inner_JS();
                               },
                                "columns": [
                                    { title: "批號" },
                                    { title: "頤坊型號" },
                                    { title: "產品說明" },
                                    { title: "單位" },
                                    { title: "內湖庫存數" },
                                    { title: "備貨數量" },
                                    { title: "內湖庫位" },
                                    { title: "到貨處理" },
                                    { title: "廠商編號" },
                                    { title: "廠商簡稱" },
                                    { title: "暫時型號" },
                                    { title: "採購單號" },
                                    { title: "<%=Resources.MP.Update_User%>" },
                                    { title: "<%=Resources.MP.Update_Date%>" },
                                    { title: "序號" }
                               ],
                               "columnDefs": [
                                   {
                                       className: 'text-right', targets: [4] //數字靠右
                                   },
                               ],
                               "order": [[0, "asc"]], //根據 點收批號 排序
                               "scrollX": true,
                               "scrollY": "62vh",
                               "searching": false,
                               "paging": false,
                               "bInfo": false //顯示幾筆隱藏
                           });

                            //input 欄位 Undefind 問題 調整為 先存TMP TABLE 再將 VALUE 複製到正式 table 
                            $('#Table_Search_Tmp').DataTable().draw();
                            $('#Table_Search_Data').DataTable().draw();
                            $('#Table_Search_Data').DataTable().clear().rows.add($('#Table_Search_Tmp').find('tbody tr[role=row]').clone()).draw();

                            $('#Table_CHS_Data').DataTable().draw();
                            $('#Table_CHS_Data_info').text('Showing ' + $('#Table_CHS_Data > tbody tr[role=row]').length + ' entries');
                            $('#Table_Search_Data_info').text('Showing ' + $('#Table_Search_Data > tbody tr[role=row]').length + ' entries');
                        }
                    },
                    error: function (ex) {
                        console.log(ex.responseText);
                        alert('查詢有誤請通知資訊人員');
                        return;
                    }
                });
            };          

            function INSERT(callType) {
                var liSeq = [];
                var liAppCnt = [];
                var liBatchNo = []; //含點收批號，訂單號碼
                var execCnt = $('#Table_EXEC_Data > tbody tr[role=row]').length;

                for (var tableCnt = 1; tableCnt <= execCnt; tableCnt++) {
                    var $tableRow = $('#Table_EXEC_Data > tbody tr:nth-child(' + tableCnt + ')');

                    var index = $('#Table_EXEC_Data thead th:contains(序號)').index() + 1; //序號INDEX
                    var seq = $tableRow.find('td:nth-child(' + index + ')').text();
                    index = $('#Table_EXEC_Data thead th:contains(批號)').index() + 1; //批號INDEX
                    var batchNo = $tableRow.find('td:nth-child(' + index + ')').text();
                    index = $('#Table_EXEC_Data thead th:contains(內湖庫存數)').index() + 1; //內湖庫存數INDEX
                    var stockCnt = $tableRow.find('td:nth-child(' + index + ')').text() == '' ? 0 : $tableRow.find('td:nth-child(' + index + ')').text();
                    var appCnt = $tableRow.find('#E_APP_CNT').val() == '' ? 0 : $tableRow.find('#E_APP_CNT').val();

                    if (stockCnt == 0) {
                        alert('第' + tableCnt + '筆，庫存數為 0，請重新確認!');
                        return;
                    }
                    if (appCnt > stockCnt && stockCnt != 0) {
                        alert('第' + tableCnt + '筆，備貨數量 > 庫存數，請重新確認!');
                        return;
                    }
                    if (appCnt == 0) {
                        alert('第' + tableCnt + '筆，備貨數量為 0，請重新確認!');
                        return;
                    }
                    liSeq.push(seq);
                    liAppCnt.push(appCnt);
                    liBatchNo.push(batchNo);
                }

                $.ajax({
                    url: apiUrl,
                    data: {
                        "Call_Type": callType,
                        "DATA_SOURCE": Data_Source,
                        "SEQ": liSeq,
                        "APP_CNT": liAppCnt,
                        "BATCH_NO": liBatchNo,
                        //準備出貨
                        "CUST_NO": $('#SG_CUST_NO').val(),
                        "CUST_S_NAME": $('#SG_CUST_S_NAME').val()
                    },
                    cache: false,
                    type: "POST",
                    datatype: "json",
                    contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                    success: function (response, status) {
                        console.log(status);
                        if (status != "success") {
                            console.log(response);
                            alert('執行有誤請通知資訊人員');
                            return;
                        }
                        else {
                            $('#Table_EXEC_Data').DataTable().rows().remove().draw();
                            $('#Table_CHS_Data').DataTable().rows().remove().draw();
                            alert('執行完成，並扣除庫存，筆數:' + execCnt);

                            //回到第一頁
                            Edit_Mode = "Base";
                            Form_Mode_Change("Search");
                        }
                    },
                    error: function (ex) {
                        console.log(ex.responseText);
                        alert('執行有誤請通知資訊人員');
                        return;
                    }
                });
            }

            $('#Q_DATA_SOURCE').on('change', function () {
                switch (this.value) {
                    case 'recua':
                        $('.onlyStkio').toggle(false);
                        $('.onlyRecua').toggle(true);
                        $('#Q_ORDER_NO').val('');
                        break;
                    case 'suplu':
                        $('.onlyStkio').toggle(true);
                        $('.onlyRecua').toggle(false);
                        $('#Q_CHK_BATCH_NO').val('');
                        $('#Q_PUDU_NO').val('');
                        $('#Q_CHK_DATE_S').val('');
                        $('#Q_CHK_DATE_E').val('');
                        break;
                }
            });

            //TABLE 功能設定
            $('#Table_Search_Data').on('click', 'tbody tr', function () {   
                Item_Move($(this), $('#Table_CHS_Data'), $('#Table_Search_Data'), false);
            });
            $('#Table_CHS_Data').on('click', 'tbody tr', function () {
                Item_Move($(this), $('#Table_Search_Data'), $('#Table_CHS_Data'), false);
            });
            $('#BT_ATR').on('click', function () {
                Item_Move($(this), $('#Table_CHS_Data'), $('#Table_Search_Data'), true);
            });
            $('#BT_ATL').on('click', function () {            
                Item_Move($(this), $('#Table_Search_Data'), $('#Table_CHS_Data'), true);
            });
            $('#BT_Next').on('click', function () {
                Edit_Mode = "Edit";
                Form_Mode_Change("EXEC");
            });
            
            //BUTTON CLICK EVENT BASE 頁
            $('#BT_Search').on('click', function () {
                Edit_Mode = "Base";
                Form_Mode_Change("Search");
                Search_Recua();
            });

            $('#BT_Cancel').on('click', function () {
                $('#Table_Search_Data').DataTable().clear().draw();
                $('#Table_CHS_Data').DataTable().clear().draw();

                var Confirm_Check = confirm("<%=Resources.MP.Cancel_Alert%>");
                if (Confirm_Check) {
                    Edit_Mode = "Base";
                    Form_Mode_Change("Base");
                }
            });

            //BUTTON CLICK EVENT 執行頁
            $('#Table_EXEC_Data').on('click', 'tbody tr', function () {
                ClickAddClass($(this));
            });     

            //出貨頁
            $('#SG_BT_EXECUTE').on('click', function () {
                if ($('#SG_CUST_NO').val() == '') {
                    alert('請選擇客戶編號!');
                    return;
                }

                INSERT("INSERT_PAKU2");
            });

            $('#SG_BT_EXECUTE_CANCEL').on('click', function () {
                Edit_Mode = "Base";
                Form_Mode_Change("Search");
            });

            //功能選單
            $('#BT_S_CHS').on('click', function () {
                Edit_Mode = "Base";
                if ($('#Table_Search_Data > tbody tr[role=row]').length > 0 || $('#Table_CHS_Data > tbody tr[role=row]').length > 0)
                {
                    Form_Mode_Change("Search");
                }
                else {
                    Form_Mode_Change("Base");
                }
            });

            $('#BT_S_SHIP_GO').on('click', function () {
                Edit_Mode = "EXEC";
                Exec_Mode = "SHIP_GO";
                Form_Mode_Change("EXEC");
                V_BT_CHG($('#BT_S_SHIP_GO'));
            });                 

            $('#BT_S_EX_IMG').on('click', function () {
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
                <td style="height: 5px; font-size: smaller;" colspan="8">&nbsp</td>
            </tr>
            <tr class="trstyle">
                <td class="tdhstyle">來源</td>
                <td class="tdbstyle">
                    <select id="Q_DATA_SOURCE" >
                        <option selected="selected" value="recua">從點收選擇</option>
                        <option value="suplu">從型號選擇</option>
                    </select>
                </td>
                <td class="tdhstyle onlyRecua">點收批號</td>
                <td class="tdbstyle onlyRecua">
                    <input id="Q_CHK_BATCH_NO" class="textbox_char" />
                </td>
                <td class="tdhstyle onlyRecua">採購單號</td>
                <td class="tdbstyle onlyRecua">
                    <input id="Q_PUDU_NO"  class="textbox_char" />
                </td>
            </tr>
            <tr class="trstyle">
                <td class="tdhstyle">頤坊型號</td>
                <td class="tdbstyle">
                    <input id="Q_IVAN_TYPE"  class="textbox_char" />
                </td>
                <td class="tdhstyle">廠商編號</td>
                <td class="tdbstyle">
                    <input id="Q_FACT_NO"  class="textbox_char" />
                </td>
                <td class="tdhstyle onlyRecua">點收日期</td>
                <td class="tdbstyle onlyRecua">
                    <input id="Q_CHK_DATE_S" type="date" class="date_S_style TB_DS" /><input id="Q_CHK_DATE_E" type="date" class="date_E_style TB_DE" />
                    <input id="BT_Duo_Datetime_Picker" type="button" value="…" onclick="$('#Duo_Datetime_Picker_Dialog').dialog('open');" />
                </td>
            </tr>      
                <tr class="trstyle">
                <td class="tdhstyle onlyStkio">訂單號碼</td>
                <td class="tdbstyle onlyStkio">
                    <input id="Q_ORDER_NO"  class="textbox_char" />
                </td>
                    <td class="tdhstyle">廠商簡稱</td>
                <td class="tdbstyle">
                    <input id="Q_FACT_S_NAME" class="textbox_char" />
                </td>
            </tr>      
            <tr class="trstyle">
                <td class="tdtstyleRight" colspan="8">
                    <input type="button" id="BT_Search" class="buttonStyle" value="<%=Resources.MP.Search%>" />
                    <input type="button" id="BT_Cancel" class="buttonStyle" value="<%=Resources.MP.Cancel%>" style="display: none;" />
                </td>
            </tr>
        </table>
        </div>
        <div class="button_change_section">
            &nbsp;
            <input type="button" id="BT_S_CHS" class="V_BT" value="選擇"  disabled="disabled" />
            <input type="button" id="BT_S_SHIP_GO" class="V_BT" value="準備出貨" />
            <input type="button" id="BT_S_EX_IMG" class="V_BT" value="圖型" />
        </div>

        <div id="Div_DT_Search" class=" Div_D">
            <div id="Div_DT_View" style=" width:70%;height:71vh; border-style:solid;border-width:1px; float:left;">
                <div class="dataTables_info" id="Table_Search_Data_info" role="status" aria-live="polite"></div>
                <div style="display:none">
                    <table id="Table_Search_Tmp" class="Table_Search table table-striped table-bordered" >
                        <thead style="white-space:nowrap"></thead>
                        <tbody style="white-space:nowrap"></tbody>
                    </table>
                </div>
                <table id="Table_Search_Data" class="Table_Search table table-striped table-bordered">
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
    
            <div id="Div_Exec_Ship_Go_Section" class="ExecSection" style="width:28%;height:71vh; border-style:solid;border-width:1px; float:right;">
                <table class="edit_section_control" style="width:auto">
                    <tr> 
                        <td style="height: 2vh; font-size: smaller;" >&nbsp</td>
                    </tr>
                    <tr class="trCenterstyle" >
                        <td colspan="2"  id="SG_TITLE" style="font-size:20px" >準備出貨項次</td>
                    </tr>
                    <tr> 
                        <td style="height: 10vh; font-size: smaller;" >&nbsp</td>
                    </tr>
                    <tr class="trCenterstyle">
                        <td class="tdhstyle" style="font-size:20px">客戶編號</td>
                        <td class="tdbstyle">
                            <input id="SG_CUST_NO"  class="textbox_char" disabled="disabled" />
                            <input id="SG_BT_CUST_CHS" style="font-size:15px" type="button" value="..." />
                        </td>
                    </tr>
                    <tr class="trCenterstyle">
                        <td class="tdhstyle" style="font-size:20px">客戶簡稱</td>
                        <td class="tdbstyle">
                            <input id="SG_CUST_S_NAME"  class="textbox_char" disabled="disabled" />
                        </td>
                    </tr>
                    <tr class="trstyle"> 
                        <td class="tdbstyle" style="height: 15vh; font-size: smaller;" >&nbsp</td>
                    </tr>
                    <tr class="trCenterstyle">
                        <td colspan="2">
                            <input id="SG_BT_EXECUTE" style="font-size:20px" type="button" value="執行"  />
                            <input id="SG_BT_EXECUTE_CANCEL" style="font-size:20px" type="button" value="返回" />
                        </td>
                    </tr>
                </table>
            </div> 

            <div id="Div_IMG_DETAIL" style="width:28%;height:71vh; border-style:solid;border-width:1px; float:right; overflow:auto ">
                <table class="edit_section_control">
                     <tr class="trstyle"> 
                        <td class="tdbstyle" style="height: 5vh; font-size: smaller;" >&nbsp</td>
                    </tr>
                    <tr class="trstyle">
                        <td class="tdEditstyle">頤坊型號</td>
                        <td class="tdbstyle">
                            <input id="I_SUPLU_SEQ" type="hidden" class="textbox_char"  style="width:100%"/>
                            <input id="I_IVAN_TYPE" class="textbox_char" disabled="disabled" />
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
        </div> 
    </div>

</asp:Content>
