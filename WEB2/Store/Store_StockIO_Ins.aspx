<%@ Page Title="門市庫取申請" Language="C#" MasterPageFile="~/MP.master" AutoEventWireup="true" CodeFile="Store_StockIO_Ins.aspx.cs" Inherits="Store_StockIO_Ins" %>
<%@ Register TagPrefix="uc2" TagName="uc2" Src="~/User_Control/Dia_Product_ALL.ascx" %>
<%@ Register TagPrefix="uc3" TagName="uc3" Src="~/User_Control/Dia_Duo_Datetime_Picker.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="/css/dataTables.bootstrap4.min.css" rel="stylesheet" />
    <script src="/js/jquery.dataTables.min.js"></script>
    <script src="/js/dataTables.bootstrap4.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            var Edit_Mode;
            var storeOrder = { '台北': 'WR1-', '台中': 'WR2-', '高雄': 'WR3-' };
            var apiUrl = "/Store/Ashx/Store_StockIO_Ins.ashx";
            //隱藏滾動卷軸
            document.body.style.overflow = 'hidden';

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

            function Re_Bind_Inner_JS() {
                $('.Call_Product_Tool').off('click');
                $('.Call_Product_Tool').on('click', function (e) {
                    e.stopPropagation();
                    $('#PAD_HDN_SUPLU_SEQ').val($(this).attr('SUPLU_SEQ'));
                    $("#Product_ALL_Dialog").dialog('open');
                });
            };

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

            //init CONTROLER
            Form_Mode_Change("Base");

            //DDL
            DDL_Bind();
            function DDL_Bind() {
                $.ajax({
                    url: "/CommonAshx/Common.ashx",
                    data: {
                        "Call_Type": "GET_DATA_FROM_REFDATA",
                        "CODE": '產品分類RT'
                    },
                    cache: false,
                    contentType: "application/x-www-form-urlencoded; charset=UTF-8",
                    type: "POST",
                    dataType: "json",
                    success: function (data) {
                        var DDL_Option = "<option></option>";
                        $.each(data, function (i, value) {
                            DDL_Option += '<option value="' + value.內容 + '">' + value.內容 + '</option>';
                        });
                        $('#E_PROD_TYPE').html(DDL_Option);
                    },
                    error: function (response) {
                        alert(response.responseText);
                    },
                });

                $.ajax({
                    url: "/CommonAshx/Common.ashx",
                    data: {
                        "Call_Type": "GET_DATA_FROM_REFDATA",
                        "CODE": '產品分類一階'
                    },
                    cache: false,
                    contentType: "application/x-www-form-urlencoded; charset=UTF-8",
                    type: "POST",
                    dataType: "json",
                    success: function (data) {
                        var DDL_Option = "<option></option>";
                        $.each(data, function (i, value) {
                            DDL_Option += '<option value="' + value.內容.substring(0, 2) + '">' + value.內容 + '</option>';
                        });
                        $('#E_PROD_FIR_TYPE').html(DDL_Option);
                    },
                    error: function (response) {
                        alert(response.responseText);
                    },
                });
            };

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
                            $('#Div_COLOR').css('display', 'none');
                            $('#Table_EXEC_Data').DataTable().clear().rows.add($('#Table_CHS_Data').find('tbody tr[role=row]').clone()).draw(); //將選擇後TABLE 複製至第二面
                            $('#Table_EXEC_info').text('Showing ' + $('#Table_EXEC_Data > tbody tr[role=row]').length + ' entries'); //顯示TABLE 列數

                            $('#Div_Exec_Section').css('display', '');
                            $('#Div_PRE_DEL').css('display', 'none');
                            V_BT_CHG($('#BT_S_EXEC'));

                            $('#E_EXEC_TITLE').text('庫取項次，筆數: ' + $('#Table_EXEC_Data > tbody tr[role=row]').length);
                            var $inputObj = $('#Table_EXEC_Data .tableInput');
                            $inputObj.attr('disabled', false);
                            
                            break;
                        }
                    case "COLOR":
                        $('.Div_D').css('display', 'none');
                        $('#Div_DT_DETAIL').css('display', '');
                        $('#Div_Exec_Section').css('display', 'none');
                        $('#Div_PRE_DEL').css('display', 'none');
                        $('#Div_COLOR').css('display', '');
                        $('#Div_IMG_DETAIL').css('display', 'none');
                        V_BT_CHG($('#BT_S_COLOR'));
                        break;
                    case "IMG":
                        $('.Div_D').css('display', 'none');
                        $('#Div_DT_DETAIL').css('display', '');
                        $('#Div_Exec_Section').css('display', 'none');
                        $('#Div_PRE_DEL').css('display', 'none');
                        $('#Div_COLOR').css('display', 'none');
                        $('#Div_IMG_DETAIL').css('display', '');
                        V_BT_CHG($('#BT_S_EX_IMG'));

                        if ($('#Table_CHS_Data > tbody tr[role=row]').length > 0 && Edit_Mode != 'EXEC') {
                            $('#Table_EXEC_Data').DataTable().clear().rows.add($('#Table_CHS_Data').find('tbody tr[role=row]').clone()).draw(); //將選擇後TABLE 複製至第二面
                        }

                        //設定DEFAULT Click
                        if ($('#Table_EXEC_Data > tbody tr[role=row]').length != 0 && $('#Table_EXEC_Data > tbody tr.tableClick').length == 0) {
                            ClickAddClass($('#Table_EXEC_Data > tbody > tr:nth(0)'));
                        }

                        break;
                }
            }

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
            }

            function V_BT_CHG(buttonChs) {
                $('.V_BT').attr('disabled', false);
                buttonChs.attr('disabled', 'disabled');
            }

            //ajax function
            function SearchData() {
                var dataReq = {};
                dataReq['Call_Type'] = 'SEARCH';

                //組json data
                $("[DT_Query_Name]").each(function () {
                    if ($(this).attr('type') == 'checkbox') {
                        dataReq[$(this).attr('DT_Query_Name')] = ($(this).is(':checked') ? '1' : '');
                    }
                    else {
                        dataReq[$(this).attr('DT_Query_Name')] = $.trim($(this).val());
                    }
                });

                $.ajax({
                    url: apiUrl,
                    data: dataReq,
                    cache: false,
                    type: "POST",
                    datatype: "json",
                    contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                    success: function (response, status) {
                        if (response.length === 0) {
                            alert('<%=Resources.MP.Data_Not_Exists_Alert%>');
                            Edit_Mode = "Base";
                            Form_Mode_Change("Base");
                            $('#Table_Search_Data').DataTable().clear().draw();
                        }
                        else {
                            var columns = [];
                            var columnsOnlyTitle = [];
                            columnNames = Object.keys(response[0]);
                            for (var i in columnNames) {
                                columns.push({
                                    data: columnNames[i],
                                    title: columnNames[i]
                                });
                                columnsOnlyTitle.push({
                                    title: columnNames[i]
                                });
                            }

                            $('#Table_Search_Data_Tmp').DataTable({
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
                                "columns": columns,
                                "order": [1, "asc"], //根據 頤坊型號 排序
                                "scrollX": true,
                                "scrollY": "62vh",
                                "searching": false,
                                "paging": false,
                                "bInfo": false, //顯示幾筆隱藏
                                "autoWidth": false //欄位小於VIEW 長度，自動擴展
                            });

                            //顏色設定
                            var ivanIndex = $('#Table_Search_Data_Tmp').find('thead th:contains(頤坊型號)').index() + 1;
                            var stockOIndex = $('#Table_Search_Data_Tmp').find('thead th:contains(預定庫取數量)').index() + 1;
                            var remarkIndex = $('#Table_Search_Data_Tmp').find('thead th:contains(備註)').index() + 1;
                            $('#Table_Search_Data_Tmp').find('tbody tr[role=row]').each(function () {
                                var rowData = $('#Table_Search_Data_Tmp').DataTable().row($(this)).data();
                                var $columnIvan = $(this).find('td:nth-child(' + ivanIndex + ')');
                                var $stockOcolumn = $(this).find('td:nth-child(' + stockOIndex + ')');
                                var $remarkIvan = $(this).find('td:nth-child(' + remarkIndex + ')');

                                var index = $('#Table_Search_Data_Tmp').find('thead th:contains(北待)').index() + 1;
                                var $column = $(this).find('td:nth-child(' + index + ')');
                                if ($.trim(rowData["北待"]) != '') {
                                    $column.css("background-color", "LightSalmon");
                                }
                                index = $('#Table_Search_Data_Tmp').find('thead th:contains(中待)').index() + 1;
                                $column = $(this).find('td:nth-child(' + index + ')');
                                if ($.trim(rowData["中待"]) != '') {
                                    $column.css("background-color", "LightSalmon");
                                }
                                index = $('#Table_Search_Data_Tmp').find('thead th:contains(高待)').index() + 1;
                                $column = $(this).find('td:nth-child(' + index + ')');
                                if ($.trim(rowData["高待"]) != '') {
                                    $column.css("background-color", "LightSalmon");
                                }

                                index = $('#Table_Search_Data_Tmp').find('thead th:contains(北逾)').index() + 1;
                                $column = $(this).find('td:nth-child(' + index + ')');
                                if ($.trim(rowData["北逾"]) != '' && parseInt(rowData["北逾"]) > 15) {
                                    $column.css("background-color", "DeepPink");
                                }
                                index = $('#Table_Search_Data_Tmp').find('thead th:contains(中待)').index() + 1;
                                $column = $(this).find('td:nth-child(' + index + ')');
                                if ($.trim(rowData["中逾"]) != '' && parseInt(rowData["中逾"]) > 15) {
                                    $column.css("background-color", "DeepPink");
                                }
                                index = $('#Table_Search_Data_Tmp').find('thead th:contains(高待)').index() + 1;
                                $column = $(this).find('td:nth-child(' + index + ')');
                                if ($.trim(rowData["高逾"]) != '' && parseInt(rowData["高逾"]) > 15) {
                                    $column.css("background-color", "DeepPink");
                                }

                                index = $('#Table_Search_Data_Tmp').find('thead th:contains(單價)').index() + 1;
                                $column = $(this).find('td:nth-child(' + index + ')');
                                if ($.trim(rowData["單價"]) == '???') {
                                    $column.css("background-color", "DarkViolet");
                                }
                                index = $('#Table_Search_Data_Tmp').find('thead th:contains(袋子)').index() + 1;
                                $column = $(this).find('td:nth-child(' + index + ')');
                                if ($.trim(rowData["袋子"]) == '???') {
                                    $column.css("background-color", "DarkViolet");
                                }
                                index = $('#Table_Search_Data_Tmp').find('thead th:contains(產地)').index() + 1;
                                $column = $(this).find('td:nth-child(' + index + ')');
                                if ($.trim(rowData["產地"]) == '???') {
                                    $column.css("background-color", "DarkViolet");
                                }

                                //{庫區}庫存數
                                index = $('#Table_Search_Data_Tmp').find('thead th:contains(' + $('#Q_STORE').val() + '庫存數)').index() + 1;
                                $column = $(this).find('td:nth-child(' + index + ')');
                                if ($.trim(rowData["產地"]) != '') {
                                    $column.css("background-color", "LightPink");
                                }
                                //分配
                                index = $('#Table_Search_Data_Tmp').find('thead th:contains(分配)').index() + 1;
                                $column = $(this).find('td:nth-child(' + index + ')');
                                if ($.trim(rowData["分配"]) != '') {
                                    $column.css("background-color", "LightPink");
                                }

                                var storeSNameObj = { '台北': '北', '台中': '中', '高雄': '高' };
                                var storeSName = storeSNameObj[$('#Q_STORE').val()];
                                index = $('#Table_Search_Data_Tmp').find('thead th:contains(' + storeSName + '安)').index() + 1;
                                $column = $(this).find('td:nth-child(' + index + ')');
                                if ($.trim(rowData[storeSName + '安']) != '') {
                                    $column.css("background-color", "LightPink");
                                }
                                index = $('#Table_Search_Data_Tmp').find('thead th:contains(' + storeSName + '庫)').index() + 1;
                                $column = $(this).find('td:nth-child(' + index + ')');
                                if ($.trim(rowData[storeSName + '庫']) != '') {
                                    $column.css("background-color", "LightPink");
                                }

                                //可修改欄位
                                var style = '<input type="number" id="E_STOCK_O_CNT" class="tableInput" style="width:80px;text-align: right;" disabled="disabled" value="' + rowData.預定庫取數量 + '" />';
                                $stockOcolumn.html(style);
                                style = '<input id="E_REMARK" class="tableInput fillRemark" style="text-align: right;" disabled="disabled" value="' + rowData.備註 + '" />';
                                $remarkIvan.html(style);
                               
                                //button
                                var ivanStyle = '<input class="Call_Product_Tool" SUPLU_SEQ = "' + (rowData.序號 ?? "")
                                    + '" type="button" value="' + (rowData.頤坊型號 ?? "")
                                    + '" style="text-align:left;width:100%;z-index:1000;' + ((rowData.Has_IMG == 'Y') ? 'background: #90ee90;' : '') + '" />';
                                $columnIvan.html(ivanStyle);
                            });

                            $('#Table_Search_Data').DataTable({
                                "destroy": true,
                                //維持scroll bar 位置
                                "preDrawCallback": function (settings) {
                                    pageScrollPos = $('#Table_Search_Data_wrapper div.dataTables_scrollBody').scrollTop();
                                },
                                "drawCallback": function (settings) {
                                    $('#Table_Search_Data_wrapper div.dataTables_scrollBody').scrollTop(pageScrollPos);
                                    Re_Bind_Inner_JS();
                                },
                                "columns": columnsOnlyTitle,
                                "columnDefs": [
                                    {
                                        className: 'text-right', targets: [4,5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21]  
                                    }
                                ],
                                "order": [1, "asc"], //根據 頤坊型號 排序
                                "scrollX": true,
                                "scrollY": "62vh",
                                "searching": false,
                                "paging": false,
                                "bInfo": false, //顯示幾筆隱藏
                                "autoWidth": false //欄位小於VIEW 長度，自動擴展
                            });

                            $('#Table_CHS_Data').DataTable({
                                "destroy": true,
                                //維持scroll bar 位置
                                "preDrawCallback": function (settings) {
                                    pageScrollPos = $('#Table_CHS_Data_wrapper div.dataTables_scrollBody').scrollTop();
                                },
                                "drawCallback": function (settings) {
                                    $('#Table_CHS_Data_wrapper div.dataTables_scrollBody').scrollTop(pageScrollPos);
                                    Re_Bind_Inner_JS();
                                    $('#BT_Next').toggle(Boolean($('#Table_CHS_Data').find('tbody tr[role=row]').length > 0));
                                },
                                "columnDefs": [
                                    {
                                        className: 'text-right', targets: [4, 5, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21]
                                    }
                                ],
                                "columns": columnsOnlyTitle,
                                "order": [1, "asc"], //根據 頤坊型號 排序
                                "scrollX": true,
                                "scrollY": "62vh",
                                "searching": false,
                                "paging": false,
                                "bInfo": false, //顯示幾筆隱藏
                                "autoWidth": false //欄位小於VIEW 長度，自動擴展
                            });

                            $('#Table_EXEC_Data').DataTable({
                                "destroy": true,
                                //維持scroll bar 位置
                                "preDrawCallback": function (settings) {
                                    pageScrollPos = $('#Table_EXEC_Data_wrapper div.dataTables_scrollBody').scrollTop();
                                },
                                "drawCallback": function (settings) {
                                    $('#Table_EXEC_Data_wrapper div.dataTables_scrollBody').scrollTop(pageScrollPos);
                                    Re_Bind_Inner_JS();
                                },
                                "columns": columnsOnlyTitle,
                                "columnDefs": [
                                    {
                                        className: 'text-right', targets: [4, 5, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19]
                                    }
                                ],
                                "order": [1, "asc"], //根據 頤坊型號 排序
                                "scrollX": true,
                                "scrollY": "62vh",
                                "searching": false,
                                "paging": false,
                                "bInfo": false, //顯示幾筆隱藏
                                "autoWidth": false //欄位小於VIEW 長度，自動擴展
                            });

                            //不顯示拿來判斷的欄位
                            //複製會有問題 暫不隱藏
                            //$('#Table_Search_Data').DataTable().column(-1).visible(false);
                            //$('#Table_Search_Data').DataTable().column(-2).visible(false);
                            //$('#Table_CHS_Data').DataTable().column(-1).visible(false);
                            //$('#Table_CHS_Data').DataTable().column(-2).visible(false);
                            //$('#Table_EXEC_Data').DataTable().column(-1).visible(false);
                            //$('#Table_EXEC_Data').DataTable().column(-2).visible(false);

                            //input 欄位 Undefind 問題 調整為 先存TMP TABLE 再將 VALUE 複製到正式 table 
                            $('#Table_Search_Data_Tmp').DataTable().draw();
                            $('#Table_Search_Data').DataTable().draw();
                            $('#Table_Search_Data').DataTable().clear().rows.add($('#Table_Search_Data_Tmp').find('tbody tr[role=row]').clone()).draw();

                            $('#Table_CHS_Data').DataTable().draw();
                            $('#Table_CHS_Data_info').text('Showing ' + $('#Table_CHS_Data > tbody tr[role=row]').length + ' entries');
                            $('#Table_Search_Data_info').text('Showing ' + $('#Table_Search_Data > tbody tr[role=row]').length + ' entries');
                            $('#Table_EXEC_Data').DataTable().draw();

                            //紀錄查詢 供第二次查詢核對
                            $('#E_STOCK_POS').val($('#Q_STOCK_POS').val());
                            $('#E_STORE').val($('#Q_STORE').val());
                            $('#E_ORDER_NO').val(storeOrder[$($('#Q_STORE').val())]);
                        }
                    },
                    error: function (ex) {
                        console.log(ex.responseText);
                        alert('查詢有誤請通知資訊人員');
                        return;
                    }
                });
            };          
 
            //寫入 TABLE
            function Exec() {
                if ($.trim($('#E_ORDER_NO').val()) == '') {
                    alert('訂單號碼不可為空!');
                    return;
                }

                if (!$.trim($('#E_ORDER_NO').val()).startsWith(storeOrder[$('#E_STORE').val()])) {
                    alert($('#E_STORE').val() + '訂單號碼 需為' + storeOrder[$('#E_STORE').val()] + '開頭');
                    return;
                }
                var execData = [];
                var execCnt = $('#Table_EXEC_Data > tbody tr[role=row]').length;
                var err = false;
                $('#Table_EXEC_Data > tbody tr[role=row]').each(function (index) {
                    var stockOCnt = $(this).find('#E_STOCK_O_CNT').val();
                    if (stockOCnt == 0 || stockOCnt == '') {
                        alert('第' + (index + 1) + '筆，庫取數不可為 0!');
                        err = true;
                        return err;
                    }

                    var object = {};
                    var seqIndex = $('#Table_EXEC_Data thead th:contains(序號)').index() + 1; //序號INDEX
                    object['SEQ'] = $(this).find('td:nth-child(' + seqIndex + ')').text();
                    object['ORDER_NO'] = $('#E_ORDER_NO').val();
                    object['DOCUMENT_NO'] = $('#E_STORE').val();
                    object['BILL_TYPE'] = 'P';
                    object['STOCK_POS'] = $('#E_STOCK_POS').val();
                    object['STOCK_I_CNT'] = '0';
                    object['STOCK_O_CNT'] = stockOCnt;
                    object['STOCK_LOC'] = ''; //空的抓預設庫位
                    object['CUST_NO'] = '00001'; //找內銷 寄送袋子(重要,印待入出庫輸入核對表用)
                    object['CUST_S_NAME'] = 'IVAN';
                    object['REMARK'] = $(this).find('#E_REMARK').val();
                    execData.push(object);
                })

                if (err) {
                    return;
                }

                $.ajax({
                    url: apiUrl,
                    data: {
                        "Call_Type": "EXEC",
                        "EXEC_DATA": JSON.stringify(execData)
                    },
                    cache: false,
                    type: "POST",
                    datatype: "json",
                    contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                    success: function (response, status) {
                        console.log(status);
                        if (status != "success") {
                            console.log(response);
                            alert('新增有誤請通知資訊人員');
                            return;
                        }
                        else {
                            alert('已新增，筆數:' + execCnt);
                            $('#Table_EXEC_Data').DataTable().rows().remove().draw();
                            $('#Table_CHS_Data').DataTable().rows().remove().draw();

                            //回到第一頁
                            SearchData();
                            Edit_Mode = "Search";
                            Form_Mode_Change("Search");
                        }
                    },
                    error: function (ex) {
                        console.log(ex.responseText);
                        alert('新增有誤請通知資訊人員');
                        return;
                    }
                });
            };         

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
                if ($('#Table_CHS_Data > tbody tr[role=row]').length != 0 && ($('#E_STOCK_POS').val() != $('#Q_STOCK_POS').val() || $('#E_STORE').val() != $('#Q_STORE').val())) {
                    alert('同一筆訂單只能同一庫區及門市!');
                    return;
                }

                Edit_Mode = "Base";
                Form_Mode_Change("Search");
                SearchData();
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
            $('#BT_EXECUTE').on('click', function () {
                if ($('#Table_EXEC_Data > tbody tr[role=row]').length == 0) {
                    alert('請選擇欲執行資料!');
                    return;
                }

                Exec();
            });

            $('#Table_EXEC_Data').on('click', 'tbody tr', function () {
                ClickAddClass($(this));
            });

            $('#BT_EXECUTE_CANCEL').on('click', function () {
                Edit_Mode = "Base";
                Form_Mode_Change("Search");
            });

            $('#E_ALL_REMARK_CHK').on('click', function () {
                $('.fillRemark').val($('#E_ALL_REMARK').val());
            });

            //功能選單
            $('#BT_S_CHS').on('click', function () {
                Edit_Mode = "Base";
                if ($('#Table_Search_Data > tbody tr[role=row]').length > 0 || $('#Table_CHS_Data > tbody tr[role=row]').length > 0) {
                    Form_Mode_Change("Search");
                }
                else {
                    Form_Mode_Change("Base");
                }
            });

            $('#BT_S_EXEC').on('click', function () {
                Edit_Mode = "EXEC";
                Form_Mode_Change("EXEC");
            });
            $('#BT_S_COLOR').on('click', function () {
                Form_Mode_Change("COLOR");
            });
            $('#BT_S_EX_IMG').on('click', function () {
                Form_Mode_Change("IMG");
            }); 
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <uc2:uc2 ID="uc2" runat="server" /> 
    <uc3:uc3 ID="uc3" runat="server" /> 
    <div style="width:98%;margin:0 auto; ">
        <div class="search_section_all">
            <table class="search_section_control">
            <tr class="trstyle">
                <td class="tdhstyle">頤坊型號</td>
                <td class="tdbstyle">
                    <input id="Q_IVAN_TYPE" DT_Query_Name="頤坊型號" class="textbox_char" />
                </td>
                 <td class="tdhstyle">庫區</td>
                <td class="tdbstyle">
                        <select id="Q_STOCK_POS" DT_Query_Name="庫區" >
                        <option selected="selected" value="大貨">大貨</option>
                        <option value="內湖">內湖</option>
                    </select>
                </td>
                <td class="tdhstyle">門市</td>
                <td class="tdbstyle">
                        <select id="Q_STORE" DT_Query_Name="門市" >
                        <option selected="selected" value="台北">台北</option>
                        <option value="台中">台中</option>
                        <option value="高雄">高雄</option>
                    </select>
                </td>
                 <td class="tdhstyle">
                       <input id="Q_NOT_ENOUGH" type="checkbox" DT_Query_Name="庫待不足" class="textbox_char" checked />
                        庫存+待入 足夠不顯示
                  </td>
                <td class="tdbstyle">
                    <input id="Q_ENOUGH" type="checkbox" DT_Query_Name="庫存足夠" class="textbox_char" checked />
                    庫存足夠顯示
                </td>
            </tr>
             <tr class="trstyle">
                <td class="tdhstyle">廠商編號</td>
                <td class="tdbstyle"> 
                    <input id="Q_FACT_NO" DT_Query_Name="廠商編號" class="textbox_char" />
                </td>
                <td class="tdhstyle">廠商簡稱</td>
                <td class="tdbstyle">
                    <input id="Q_FACT_S_NAME" DT_Query_Name="廠商簡稱" class="textbox_char" />
                </td>
                  <td class="tdhstyle">庫存狀態</td>
                <td class="tdbstyle">
                        <select id="Q_STOCK_STATUS" DT_Query_Name="庫存狀態" >
                        <option selected="selected" value="20">低於20%</option>
                        <option value="50">低於50%</option>
                        <option value="建議採購">建議採購</option>
                        <option value="ALL">全部</option>
                    </select>
                </td>
                 <td class="tdhstyle">
                       <input id="Q_SAFE_CNT" type="checkbox" DT_Query_Name="安全數" class="textbox_char" checked />
                        安全數大於1
                  </td>
                <td class="tdbstyle">
                    <input id="Q_BAG_ALREADY" type="checkbox" DT_Query_Name="袋子吊卡" class="textbox_char" checked />
                    袋子吊卡已建檔
                </td>
            </tr>
            <tr class="trstyle">
                 <td class="tdhstyle">銷售型號</td>
                <td class="tdbstyle"> 
                    <input id="Q_SALE_TYPE" DT_Query_Name="銷售型號" class="textbox_char" />
                </td>
                <td class="tdhstyle">產品分類</td>
                <td class="tdbstyle">
                    <select id="E_PROD_TYPE" DT_Query_Name="產品分類" class="textbox_char" >
                        <option selected="selected" value=""></option>
                    </select>
                </td>
                <td class="tdhstyle">產品一階</td>
                <td class="tdbstyle">
                    <select id="E_PROD_FIR_TYPE" DT_Query_Name="產品一階" class="textbox_char" >
                        <option selected="selected" value=""></option>
                    </select>
                </td>
            </tr>
            <tr class="trstyle">
                <td class="tdtstyleRight" colspan="7">
                    <input type="button" id="BT_Search" class="buttonStyle" value="<%=Resources.MP.Search%>" />
                    <input type="reset" id="BT_Cancel" class="buttonStyle" value="<%=Resources.MP.Cancel%>" style="display: none;" />
                </td>
            </tr>
        </table>
        </div>
        <div class="button_change_section">
            &nbsp;
            <input type="button" id="BT_S_CHS" class="V_BT" value="選擇"  disabled="disabled" />
            <input type="button" id="BT_S_EXEC" class="V_BT" value="庫取" />
            <input type="button" id="BT_S_COLOR" class="V_BT" value="圖例" />
            <input type="button" id="BT_S_EX_IMG" class="V_BT" value="圖型" />
        </div>

        <div id="Div_DT_Search" class=" Div_D">
            <div id="Div_DT_View" style=" width:70%;height:71vh; border-style:solid;border-width:1px; float:left;">
                <div class="dataTables_info" id="Table_Search_Data_info" role="status" aria-live="polite"></div>
                <div style="display:none">
                    <table id="Table_Search_Data_Tmp" class="Table_Search table table-striped table-bordered" >
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
                            <input id="BT_Next" type="button" value="Next" style="inline-size:100%;display:none" class="BTN"  />
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
                <div class="search_section_control">
                    <table style="margin:0 auto">
                        <tr style="font-size:20px">
                            <td colspan="2"  id="E_EXEC_TITLE" >庫取項次:</td>
                        </tr>
                    </table>
                    <div style="position: relative; border: 1px solid #111111; padding: 20px; box-sizing: border-box; margin: 30px auto; width: 90%;">
                        <span style="position: absolute; top: -1em; left: 10%; line-height: 2em; padding: 0 1em; background-color: #fff;">批次更新選取資料</span>
                        <table style="margin:0 auto">
                            <tr >
                                <td class="tdhstyle">備註</td>
                                <td class="tdbstyle">
                                     <input id="E_ALL_REMARK"  class="textbox_char" maxlength="30" />
                                    <input id="E_ALL_REMARK_CHK" type="button" value="Reset" />
                                </td>
                            </tr>
                        </table>
                    </div>
                    <table style="margin:0 auto">
                        <tr >
                            <td class="tdhstyle">訂單號碼</td>
                            <td class="tdbstyle">
                                <input id="E_STORE" type="hidden"  class="textbox_char"  />
                                <input id="E_STOCK_POS" type="hidden"  class="textbox_char"  />
                                <input id="E_ORDER_NO"  class="textbox_char" maxlength="20" />
                            </td>
                        </tr>
                    </table>
                </div>
                <div style="height: 10vh; font-size: smaller;" >&nbsp</div>
                <div style="text-align:center">
                     <input id="BT_EXECUTE" style="font-size:20px" type="button" value="執行"  />
                    <input id="BT_EXECUTE_CANCEL" style="font-size:20px" type="button" value="返回" />
                </div>
            </div> 
            <div id="Div_COLOR" style="width:28%;height:71vh; border-style:solid;border-width:1px; float:right; overflow:auto ">
                <table class="edit_section_control" style="width:70%">
                     <tr class="trstyle"> 
                        <td class="tdbstyle" style="height: 10vh; font-size: smaller;" >&nbsp</td>
                    </tr>
                    <tr class="trstyle">
                        <td style="background-color:#90ee90;width:10%"></td>
                        <td>有圖檔</td>
                        <td style="background-color:DarkViolet;width:10%"></td>
                        <td>無內銷資訊</td>
                    </tr>
                    <tr class="trstyle">
                        <td style="background-color:LightSalmon;width:10%"></td>
                        <td>門市待入庫數</td>
                        <td style="background-color:DeepPink;width:10%"></td>
                        <td>入出庫逾期15天</td>
                    </tr>
                    <tr class="trstyle">
                        <td style="background-color:LightPink;width:10%"></td>
                        <td>選擇門市</td>
                    </tr>
                    <tr class="trstyle"> 
                        <td class="tdbstyle" style="height: 5vh; font-size: smaller;" >&nbsp</td>
                    </tr>
                    <tr> 
                        <td colspan="4">
                            <div style="position: relative; border: 1px solid #111111; padding: 20px; box-sizing: border-box; margin: 30px auto; width: 100%;">
                                <span style="position: absolute; top: -1em; left: 10%; line-height: 2em; padding: 0 1em; background-color: #fff;">說明</span>
                                <table style="margin:0 auto">
                                    <tr class="trstyle">
                                        <td colspan="4">北安:台北安全數,   北庫:台北庫存數,   北待:台北待入數</td>
                                    </tr>
                                    <tr class="trstyle">
                                        <td colspan="4">中安:台中安全數,   中庫:台中庫存數,   中待:台中待入數</td>
                                    </tr>
                                    <tr class="trstyle">
                                        <td colspan="4">高安:高雄安全數,   高庫:高雄庫存數,   高待:高雄待入數</td>
                                    </tr>
                                </table>
                            </div>
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
                            <input id="I_IVAN_TYPE" class="textbox_char" disabled="disabled" style="width:100%"   />
                            <input id="I_SUPLU_SEQ" class="textbox_char" type="hidden"   />
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
