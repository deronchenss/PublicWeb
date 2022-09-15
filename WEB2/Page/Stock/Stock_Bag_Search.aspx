<%@ Page Title="庫存查詢-袋子彩卡" Language="C#" MasterPageFile="~/MP.master" AutoEventWireup="true" CodeFile="Stock_Bag_Search.aspx.cs" Inherits="Stock_Bag_Search" %>
<%@ Register TagPrefix="uc1" TagName="uc1" Src="~/User_Control/Dia_Duo_Datetime_Picker.ascx" %>
<%@ Register TagPrefix="uc2" TagName="uc2" Src="~/User_Control/Dia_Product_ALL.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="/css/dataTables.bootstrap4.min.css" rel="stylesheet" />
    <script src="/js/jquery.dataTables.min.js"></script>
    <script src="/js/dataTables.bootstrap4.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            var Edit_Mode = "Base";
            var apiUrl = "/Page/Stock/Ashx/Stock_Bag_Search.ashx";
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
                        ClickToDetailEdit($('#Table_Search_Data > tbody > tr:nth(' + clickIndex + ')'));
                    }
                }
                else if (key == '38') {
                    if (clickIndex > 0) {
                        clickIndex--;
                        ClickToDetailEdit($('#Table_Search_Data > tbody > tr:nth(' + clickIndex + ')'));
                    }
                }
            });

            //function region
            function Form_Mode_Change(Form_Mode) {
                switch (Form_Mode) {
                    case "Base":
                        $('.Div_D').css('display', 'none');
                        $('#Div_DT_View').css('display', 'none');
                        $('#Div_DT').css('display', 'none');
                        $('#BT_Cancel').css('display', 'none');
                        $('#BT_Search').css('display', '');

                        V_BT_CHG($('#BT_S_BASE'));
                        break;
                    case "Search":
                        $('.Div_D').css('display', 'none');
                        $('#Div_DT_View').css('width', '35%');
                        $('#Div_DT_View').css('display', '');

                        $('#Div_DT').css('display', '');
                        $('#Div_Detail_View').css('display', '');
                        $('#Div_Detail2').css('display', '');
                        $('#BT_Cancel').css('display', '');
                        $('#BT_E_CANCEL').css('display', 'none');
                        $('#Div_COLOR').css('display', 'none');

                        V_BT_CHG($('#BT_S_BASE'));
                        break;
                    case "COLOR":
                        $('.Div_D').css('display', 'none');
                        $('#Div_DT_View').css('display', '');
                        $('#Div_COLOR').css('display', '');
                        $('#Div_Detail_View').css('display', 'none');
                        $('#Div_Detail2').css('display', 'none');

                        V_BT_CHG($('#BT_S_COLOR'));
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

            function ClickToDetailEdit(click_tr) {
                //點擊賦予顏色
                $('#Table_Search_Data > tbody tr').removeClass("tableClick");
                click_tr.addClass("tableClick");
                var clickData = $('#Table_Search_Data').DataTable().row(click_tr).data();

                //Search Detail
                SearchDetailData(clickData['序號'], clickData['頤坊型號']);
            }

            function ClickToEdit(click_tr) {
                //點擊賦予顏色
                $('#Table_Search_Detail_Data > tbody tr').removeClass("tableClick");
                click_tr.addClass("tableClick");
                var clickData = $('#Table_Search_Detail_Data').DataTable().row(click_tr).data();
            }

            function V_BT_CHG(buttonChs) {
                $('.V_BT').attr('disabled', false);
                buttonChs.attr('disabled', 'disabled');
            }

            //ajax function
            function Search_Data() {
                var dataReq = {};
                dataReq['Call_Type'] = 'SEARCH';

                //組json data
                $("[DT_Query_Name]").each(function () {
                    if ($(this).attr('type') == 'checkbox') {
                        dataReq[$(this).attr('DT_Query_Name')] = ($(this).is(':checked') ? '1' : '');
                    }
                    else if ($(this).attr('type') == 'radio') {
                        //radio 只有一個check
                        if (!($(this).attr('DT_Query_Name') in dataReq) || dataReq[$(this).attr('DT_Query_Name')] == '') {
                            dataReq[$(this).attr('DT_Query_Name')] = ($(this).is(':checked') ? $.trim($(this).val()) : '');
                        }
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
                    success: function (response) {
                        if (response.length === 0) {
                            alert('<%=Resources.MP.Data_Not_Exists_Alert%>');
                            Edit_Mode = "Base";
                            Form_Mode_Change("Base");
                            $('#Table_Search_Data').empty();
                        }
                        else {
                            var columns = [];
                            columnNames = Object.keys(response[0]);
                            for (var i in columnNames) {
                                columns.push({
                                    data: columnNames[i],
                                    title: columnNames[i]
                                });
                            }
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
                               "columns": columns,
                               "columnDefs": [
                                   {
                                       className: 'text-right', targets: [4,5] //數字靠右
                                   },
                               ],
                                "order": [0, "asc"], //根據 訂單號碼 排序
                                "scrollX": true,
                                "scrollY": "62vh",
                                "searching": false,
                                "paging": false,
                                "bInfo": false, //顯示幾筆隱藏
                            });

                            //0 輸出空白
                            $('#Table_Search_Data tbody td').filter(function () { return parseFloat($(this).text()) === 0; }).text('');

                            //不顯示拿來判斷的欄位
                            //$('#Table_Search_Data').DataTable().column(-1).visible(false);
                            //$('#Table_Search_Data').DataTable().column(-2).visible(false);
                            //$('#Table_Search_Data').DataTable().column(-3).visible(false);
                            //$('#Table_Search_Data').DataTable().column(-4).visible(false);
                            //$('#Table_Search_Data').DataTable().column(-5).visible(false);
                            //顏色設定
                            var ivanIndex = $('#Table_Search_Data').find('thead th:contains(頤坊型號)').index() + 1;
                            $('#Table_Search_Data').find('tbody tr[role=row]').each(function () {
                                var rowData = $('#Table_Search_Data').DataTable().row($(this)).data();
                                var $columnIvan = $(this).find('td:nth-child(' + ivanIndex + ')');
                                var stockCnt = ($.trim(rowData['大貨庫存數']) == '' ? 0 : parseInt($.trim(rowData['大貨庫存數'])));
                                var distributeCnt = ($.trim(rowData['總分配']) == '' ? 0 : parseInt($.trim(rowData['總分配'])));

                                //庫存狀態
                                index = $('#Table_Search_Data').find('thead th:contains(預估餘額)').index() + 1;
                                $column = $(this).find('td:nth-child(' + index + ')');
                                if (distributeCnt > stockCnt) {
                                    $column.css("background-color", "Red");
                                }
                                index = $('#Table_Search_Data').find('thead th:contains(總分配QT)').index() + 1;
                                $column = $(this).find('td:nth-child(' + index + ')');
                                if (distributeCnt > stockCnt * 0.6 && stockCnt > distributeCnt) {
                                    $column.css("background-color", "DarkOrange");
                                }

                                //button
                                var ivanStyle = '<input class="Call_Product_Tool" SUPLU_SEQ = "' + (rowData.序號 ?? "")
                                    + '" type="button" value="' + (rowData.頤坊型號 ?? "")
                                    + '" style="text-align:left;width:100%;z-index:1000;' + ((rowData.Has_IMG == 'Y') ? 'background: #90ee90;' : '') + '" />';
                                $columnIvan.html(ivanStyle);
                            });

                            $('#Table_Search_Data').DataTable().draw();
                            $('#Table_Search_Data_info').text('Showing ' + $('#Table_Search_Data > tbody tr[role=row]').length + ' entries');

                            //設定DEFAULT Click
                            ClickToDetailEdit($('#Table_Search_Data > tbody > tr:nth(0)'));
                        }
                    },
                    error: function (ex) {
                        console.log(ex.responseText);
                        alert('查詢有誤請通知資訊人員');
                    }
                });
            };        

            function SearchDetailData(seq, ivanType) {
                var dataReq = {};
                dataReq['Call_Type'] = 'SEARCH_DETAIL';
                dataReq['SUPLU_SEQ'] = seq;
                dataReq['頤坊型號'] = ivanType;

                $.ajax({
                    url: apiUrl,
                    data: dataReq,
                    cache: false,
                    type: "POST",
                    datatype: "json",
                    contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                    success: function (response) {
                        if (response.length === 0) {
                            alert('查無明細');
                            $('#Table_Search_Detail_Data').empty();
                        }
                        else {
                            var columns = [];
                            if (response[0].length != 0) {
                                columnNames = Object.keys(response[0][0]);
                                for (var i in columnNames) {
                                    columns.push({
                                        data: columnNames[i],
                                        title: columnNames[i]
                                    });
                                }

                                $('#Table_Search_Detail_Data').DataTable({
                                    "data": response[0],
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
                                    "columnDefs": [
                                        {
                                            className: 'text-right', targets: [4, 5] //數字靠右
                                        },
                                    ],
                                    "order": [0, "asc"], //根據 訂單號碼 排序
                                    "scrollX": true,
                                    "scrollY": "25vh",
                                    "searching": false,
                                    "paging": false,
                                    "bInfo": false, //顯示幾筆隱藏
                                    "autoWidth": false //欄位小於VIEW 長度，自動擴展
                                });

                                //0 輸出空白
                                $('#Table_Search_Detail_Data tbody td').filter(function () { return parseFloat($(this).text()) === 0; }).text('');

                                $('#Table_Search_Detail_Data').DataTable().draw();
                                $('#Table_Search_Detail_Data_info').text('Showing ' + $('#Table_Search_Detail_Data > tbody tr[role=row]').length + ' entries');

                            }
                            else {
                                $('#Table_Search_Detail_Data').empty();
                            }

                            if (response[1].length != 0) {
                                var columns = [];
                                columnNames = Object.keys(response[1][0]);
                                for (var i in columnNames) {
                                    columns.push({
                                        data: columnNames[i],
                                        title: columnNames[i]
                                    });
                                }

                                $('#Table_Search_Detail2_Data').DataTable({
                                    "data": response[1],
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
                                    "columnDefs": [
                                        {
                                            className: 'text-right', targets: [4, 5] //數字靠右
                                        },
                                    ],
                                    "order": [0, "asc"], //根據 訂單號碼 排序
                                    "scrollX": true,
                                    "scrollY": "25vh",
                                    "searching": false,
                                    "paging": false,
                                    "bInfo": false, //顯示幾筆隱藏
                                    "autoWidth": false //欄位小於VIEW 長度，自動擴展
                                });

                                //0 輸出空白
                                $('#Table_Search_Detail2_Data tbody td').filter(function () { return parseFloat($(this).text()) === 0; }).text('');

                                $('#Table_Search_Detail2_Data').DataTable().draw();
                                $('#Table_Search_Detail2_Data_info').text('Showing ' + $('#Table_Search_Detail2_Data > tbody tr[role=row]').length + ' entries');
                            }
                            else {
                                $('#Table_Search_Detail2_Data').empty();
                            }
                           
                        }
                    },
                    error: function (ex) {
                        console.log(ex.responseText);
                        alert('查詢明細有誤請通知資訊人員');
                    }
                });
            };                 

            //TABLE 功能設定
            $('#Table_Search_Data').on('click', 'tbody tr', function () {
                ClickToDetailEdit($(this));
            });

            $('#Table_Search_Detail_Data').on('click', 'tbody tr', function () {
                ClickToEdit($(this));
            });

            //BUTTON CLICK EVENT BASE 頁
            $('#BT_Search').on('click', function () {
                if ($.trim($('#Q_STOCK_LOC').val()) != '') {
                    if ($.trim($('#Q_STOCK_POS').val()) == '') {
                        alert('庫位搜尋，倉位不可為不限!');
                        return;
                    }
                }

                Form_Mode_Change("Search");
                Search_Data();
            });

            $('#BT_Cancel').on('click', function () {
                Edit_Mode = "Base";

                var Confirm_Check = confirm("<%=Resources.MP.Cancel_Alert%>");
                if (Confirm_Check) {
                    $('#Table_Search_Data').DataTable().clear().draw();
                    Form_Mode_Change("Base");
                }
            });

            //功能選單
            $('#BT_S_BASE').on('click', function () {
                if ($('#Table_Search_Data > tbody tr[role=row]').length > 0) {
                    Form_Mode_Change('Search');
                }
                else {
                    Form_Mode_Change("Base");
                }
            });

            $('#BT_S_COLOR').on('click', function () {
                Form_Mode_Change("COLOR");
            });

        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <uc1:uc1 ID="uc1" runat="server" /> 
    <uc2:uc2 ID="uc2" runat="server" /> 
    <div style="width:98%;margin:0 auto; ">
        <div class="search_section_all">
            <table class="search_section_control">
            <tr class="trstyle"> 
                <td style="height: 5px;"  colspan="8"></td>
            </tr>
            <tr class="trstyle">
                 <td class="tdhstyle">
                 </td>
                <td class="tdbstyle">
                    <input id="Q_RB_IMG"  DT_Query_Name="TYPE" value ="BAG" type="radio" name="RPT_TYPE" checked="checked" />
                    <label for="Q_RB_IMG">BAG</label>
                     <input id="Q_RB_IMG"  DT_Query_Name="TYPE" value ="CARD" type="radio" name="RPT_TYPE"  />
                    <label for="Q_RB_IMG">CARD</label>
                     <input id="Q_RB_IMG"  DT_Query_Name="TYPE" value ="ICARD" type="radio" name="RPT_TYPE"  />
                    <label for="Q_RB_IMG">ICARD</label>
                     <input id="Q_RB_IMG"  DT_Query_Name="TYPE" value ="SLOJD" type="radio" name="RPT_TYPE"  />
                    <label for="Q_RB_IMG">SLOJD</label>
                </td>
                <td class="tdhstyle"></td>
                <td class="tdbstyle">
                </td>
            </tr>
            <tr class="trstyle">
                 <td class="tdhstyle">不含停用</td>
                <td class="tdbstyle">
                    <input id="Q_EXCLUDE_CANCEL" type="checkbox" checked="checked" DT_Query_Name="EXCLUDE_CANCEL" class="textbox_char"  />
                </td>
                <td class="tdhstyle"></td>
                <td class="tdbstyle">
                </td>
            </tr>
            <tr class="trstyle">
                <td class="tdtstyleRight" colspan="2">
                    <input type="button" id="BT_Search" class="buttonStyle" value="<%=Resources.MP.Search%>" />
                    <input type="reset" id="BT_Cancel" class="buttonStyle" value="<%=Resources.MP.Cancel%>" style="display: none;" />
                </td>
            </tr>
        </table>
        </div>
        <div class="button_change_section">
            &nbsp;
            <input type="button" id="BT_S_BASE" class="V_BT" value="主檔"  disabled="disabled" />
            <input type="button" id="BT_S_COLOR" class="V_BT" value="圖例" />
        </div>

        <div id="Div_DT">
            <div id="Div_DT_View" style=" width:35%;height:71vh; border-style:solid;border-width:1px; float:left;">
                <div class="dataTables_info" id="Table_Search_Data_info" role="status" aria-live="polite"></div>
                <table id="Table_Search_Data" class="Table_Search table table-striped table-bordered">
                    <thead style="white-space:nowrap"></thead>
                    <tbody style="white-space:nowrap"></tbody>
                </table>
            </div>
            <div id="Div_Detail_View" style=" width:60%;height:36vh; border-style:solid;border-width:1px; float:right;">
                <div class="dataTables_info" id="Table_Search_Detail_Data_info" role="status" aria-live="polite"></div>
                <table id="Table_Search_Detail_Data" class="Table_Search table table-striped table-bordered">
                    <thead style="white-space:nowrap"></thead>
                    <tbody style="white-space:nowrap"></tbody>
                </table>
            </div>
            <div id="Div_Detail2" style=" width:60%;height:35vh; border-style:solid;border-width:1px; float:right;">
                <div class="dataTables_info" id="Table_Search_Detail2_Data_info" role="status" aria-live="polite"></div>
                <table id="Table_Search_Detail2_Data" class="Table_Search table table-striped table-bordered">
                    <thead style="white-space:nowrap"></thead>
                    <tbody style="white-space:nowrap"></tbody>
                </table>
            </div>
            <div id="Div_COLOR" class=" Div_D" style="width:35%;height:71vh; border-style:solid;border-width:1px; float:right; overflow:auto ">
                <table class="edit_section_control" style="width:70%">
                     <tr class="trstyle"> 
                        <td class="tdbstyle" style="height: 10vh; font-size: smaller;" >&nbsp</td>
                    </tr>
                    <tr class="trstyle">
                        <td style="background-color:#90ee90;width:10%"></td>
                        <td>有圖檔</td>
                        <td style="background-color:Red;width:10%"></td>
                        <td>庫存不足</td>
                    </tr>
                    <tr class="trstyle">
                        <td style="background-color:DarkOrange;width:10%"></td>
                        <td>庫存安全需注意</td>
                    </tr>
                </table>
            </div> 
        </div>
    </div>

</asp:Content>
