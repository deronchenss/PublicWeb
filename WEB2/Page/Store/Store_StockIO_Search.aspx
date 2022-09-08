<%@ Page Title="門市庫取跟催查詢" Language="C#" MasterPageFile="~/MP.master" AutoEventWireup="true" CodeFile="Store_StockIO_Search.aspx.cs" Inherits="Store_StockIO_Search" %>
<%@ Register TagPrefix="uc1" TagName="uc1" Src="~/User_Control/Dia_Duo_Datetime_Picker.ascx" %>
<%@ Register TagPrefix="uc2" TagName="uc2" Src="~/User_Control/Dia_Product_ALL.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="/css/dataTables.bootstrap4.min.css" rel="stylesheet" />
    <script src="/js/jquery.dataTables.min.js"></script>
    <script src="/js/dataTables.bootstrap4.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            var Edit_Mode = "Base";
            var apiUrl = "/Page/Store/Ashx/Store_StockIO_Search.ashx";
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
                        $('#Div_Detail_View').css('display', 'none');
                        $('#BT_Cancel').css('display', 'none');
                        $('#BT_Search').css('display', '');

                        V_BT_CHG($('#BT_S_BASE'));
                        break;
                    case "Search":
                        $('.Div_D').css('display', 'none');
                        $('#Div_DT_View').css('width', '35%');
                        $('#Div_DT_View').css('display', '');

                        $('#Div_Detail_View').css('display', '');
                        $('#Div_Detail_View').css('float', 'right');
                        $('#BT_Cancel').css('display', '');
                        $('#BT_E_CANCEL').css('display', 'none');

                        V_BT_CHG($('#BT_S_BASE'));
                        break;
                    case "IMG":
                        $('.Div_D').css('display', 'none');
                        $('#Div_DT_View').css('display', 'none');
                        $('#Div_Detail_View').css('display', '');
                        $('#Div_Detail_View').css('float', 'left');
                        $('#Div_IMG_DETAIL').css('display', '');

                        //設定DEFAULT Click
                        if ($('#Table_Search_Detail_Data > tbody tr[role=row]').length != 0 && $('#Table_Search_Detail_Data > tbody tr.tableClick').length == 0) {
                            ClickToEdit($('#Table_Search_Detail_Data > tbody > tr:nth(0)'));
                        }

                        V_BT_CHG($('#BT_S_IMG'));
                        break;
                    case "COLOR":
                        $('.Div_D').css('display', 'none');
                        $('#Div_DT_View').css('display', 'none');
                        $('#Div_COLOR').css('display', '');
                        $('#Div_Detail_View').css('display', '');
                        $('#Div_Detail_View').css('float', 'left');

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
                SearchDetailData(clickData['訂單號碼'], clickData['狀態']);
            }

            function ClickToEdit(click_tr) {
                //點擊賦予顏色
                $('#Table_Search_Detail_Data > tbody tr').removeClass("tableClick");
                click_tr.addClass("tableClick");
                var clickData = $('#Table_Search_Detail_Data').DataTable().row(click_tr).data();

                //IMG page
                $('#I_IVAN_TYPE').val(clickData['頤坊型號']);
                $('#I_FACT_NO').val(clickData['廠商編號']);
                $('#I_FACT_S_NAME').val(clickData['廠商簡稱']);
                $('#I_PROD_DESC').val(clickData['產品說明']);
                Search_IMG(clickData['SUPLU_SEQ']);
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
                        dataReq[$(this).attr('DT_Query_Name')] = ($(this).is(':checked') ? '1' : '0');
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
                                var delayDate = ($.trim(rowData['日數']) == '' ? 0 : parseInt($.trim(rowData['日數'])));
                                
                                //日數
                                index = $('#Table_Search_Data').find('thead th:contains(日數)').index() + 1;
                                $column = $(this).find('td:nth-child(' + index + ')');
                                if (delayDate >= 30) {
                                    $column.css("background-color", "Red");
                                }
                                else if (delayDate >= 20) {
                                    $column.css("background-color", "DeepPink");
                                }
                                else if (delayDate >= 7) {
                                    $column.css("background-color", "Salmon");
                                }

                                //狀態
                                index = $('#Table_Search_Data').find('thead th:contains(狀態)').index() + 1;
                                $column = $(this).find('td:nth-child(' + index + ')');
                                if ($.trim(rowData['狀態']) == '建檔') {
                                    $column.css("background-color", "MistyRose");
                                }
                                else if ($.trim(rowData['狀態']) == '備貨') {
                                    $column.css("background-color", "MintCream");
                                }
                                else if ($.trim(rowData['狀態']) == '待核') {
                                    $column.css("background-color", "PaleGreen");
                                }
                                else if ($.trim(rowData['狀態']) == '其他') {
                                    $column.css("background-color", "Thistle");
                                }
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

            function SearchDetailData(orderNo, status) {
                var dataReq = {};
                dataReq['Call_Type'] = 'SEARCH_DETAIL';
                dataReq['訂單號碼'] = orderNo;
                dataReq['狀態'] = status;

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
                            columnNames = Object.keys(response[0]);
                            for (var i in columnNames) {
                                columns.push({
                                    data: columnNames[i],
                                    title: columnNames[i]
                                });
                            }
                            $('#Table_Search_Detail_Data').DataTable({
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
                                "columnDefs": [
                                    {
                                        className: 'text-right', targets: [4, 5] //數字靠右
                                    },
                                ],
                                "order": [0, "asc"], //根據 訂單號碼 排序
                                "scrollX": true,
                                "scrollY": "62vh",
                                "searching": false,
                                "paging": false,
                                "bInfo": false, //顯示幾筆隱藏
                                "autoWidth": false //欄位小於VIEW 長度，自動擴展
                            });

                            //0 輸出空白
                            $('#Table_Search_Detail_Data tbody td').filter(function () { return parseFloat($(this).text()) === 0; }).text('');

                            //顏色設定
                            var ivanIndex = $('#Table_Search_Detail_Data').find('thead th:contains(頤坊型號)').index() + 1;
                            $('#Table_Search_Detail_Data').find('tbody tr[role=row]').each(function () {
                                var rowData = $('#Table_Search_Detail_Data').DataTable().row($(this)).data();
                                var $columnIvan = $(this).find('td:nth-child(' + ivanIndex + ')');
                                var stockCnt = ($.trim(rowData['大貨庫存數']) == '' ? 0 : parseInt($.trim(rowData['大貨庫存數'])));
                                var distributeCnt = ($.trim(rowData['分配庫存數']) == '' ? 0 : parseInt($.trim(rowData['分配庫存數'])));

                                //狀態
                                index = $('#Table_Search_Detail_Data').find('thead th:contains(狀態)').index() + 1;
                                $column = $(this).find('td:nth-child(' + index + ')');
                                if ($.trim(rowData['狀態']) == '建檔') {
                                    $column.css("background-color", "MistyRose");
                                }
                                else if ($.trim(rowData['狀態']) == '備貨') {
                                    $column.css("background-color", "MintCream");
                                }
                                else if ($.trim(rowData['狀態']) == '待核') {
                                    $column.css("background-color", "PaleGreen");
                                }
                                else if ($.trim(rowData['狀態']) == '其他') {
                                    $column.css("background-color", "Thistle");
                                }

                                //庫存狀態
                                index = $('#Table_Search_Detail_Data').find('thead th:contains(分配庫存數)').index() + 1;
                                $column = $(this).find('td:nth-child(' + index + ')');
                                if (stockCnt < distributeCnt && $.trim(rowData['庫區']) == '大貨') {
                                    $column.css("background-color", "PaleTurquoise");
                                }
                                else if (stockCnt >= distributeCnt && $.trim(rowData['庫區']) == '大貨'){
                                    $column.css("background-color", "Moccasin");
                                }

                                //button
                                var ivanStyle = '<input class="Call_Product_Tool" SUPLU_SEQ = "' + (rowData.SUPLU_SEQ ?? "")
                                    + '" type="button" value="' + (rowData.頤坊型號 ?? "")
                                    + '" style="text-align:left;width:100%;z-index:1000;' + ((rowData.Has_IMG == 'Y') ? 'background: #90ee90;' : '') + '" />';
                                $columnIvan.html(ivanStyle);
                            });

                            $('#Table_Search_Detail_Data').DataTable().draw();
                            $('#Table_Search_Detail_Data_info').text('Showing ' + $('#Table_Search_Detail_Data > tbody tr[role=row]').length + ' entries');
                        }
                    },
                    error: function (ex) {
                        console.log(ex.responseText);
                        alert('查詢明細有誤請通知資訊人員');
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

            $('#BT_S_IMG').on('click', function () {
                Form_Mode_Change("IMG");
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
                <td class="tdhstyle">訂單號碼</td>
                <td class="tdbstyle">
                    <input id="Q_ORDER_NO" DT_Query_Name="訂單號碼" class="textbox_char" />
                </td>
                 <td class="tdhstyle">開單日期</td>
                <td class="tdbstyle">
                    <input id="Q_UPD_DATE_S" type="date" DT_Query_Name="更新日期_S" class="date_S_style TB_DS" /><input id="Q_UPD_DATE_E" DT_Query_Name="更新日期_E" type="date" class="date_E_style TB_DE" />
                    <input id="BT_Duo_Datetime_Picker" type="button" value="…" onclick="$('#Duo_Datetime_Picker_Dialog').dialog('open');" />
                </td>
                <td class="tdhstyle">頤坊型號</td>
                <td class="tdbstyle">
                    <input id="Q_IVAN_TYPE" DT_Query_Name="頤坊型號" class="textbox_char" />
                </td>
                
            </tr>
            <tr class="trstyle">
                <td class="tdhstyle">庫取狀態</td>
                <td class="tdbstyle">
                    <select id="Q_STOCKIO_STATUS" DT_Query_Name="庫取狀態" > 
                        <option selected="selected" value="">全部</option>
                        <option value="建檔">建檔</option>
                        <option value="備貨">備貨</option>
                        <option value="待核">待核</option>
                    </select>
                </td>
                <td class="tdhstyle">入區</td>
                <td class="tdbstyle">
                    <select id="Q_STORE" DT_Query_Name="庫區" > 
                        <option selected="selected" value="台北">台北</option>
                        <option value="台中">台中</option>
                        <option value="高雄">高雄</option>
                    </select>
                </td>
            </tr>
            <tr class="trstyle">
                <td class="tdtstyleRight" colspan="5">
                    <input type="button" id="BT_Search" class="buttonStyle" value="<%=Resources.MP.Search%>" />
                    <input type="reset" id="BT_Cancel" class="buttonStyle" value="<%=Resources.MP.Cancel%>" style="display: none;" />
                </td>
            </tr>
        </table>
        </div>
        <div class="button_change_section">
            &nbsp;
            <input type="button" id="BT_S_BASE" class="V_BT" value="主檔"  disabled="disabled" />
            <input type="button" id="BT_S_IMG" class="V_BT" value="圖型" />
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
            <div id="Div_Detail_View" style=" width:60%;height:71vh; border-style:solid;border-width:1px; float:right;">
                <div class="dataTables_info" id="Table_Search_Detail_Data_info" role="status" aria-live="polite"></div>
                <table id="Table_Search_Detail_Data" class="Table_Search table table-striped table-bordered">
                    <thead style="white-space:nowrap"></thead>
                    <tbody style="white-space:nowrap"></tbody>
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
                            <input id="I_IVAN_TYPE" class="textbox_char" disabled="disabled" style="width:100%"  />
                        </td>
                        <td class="tdEditstyle">廠商編號</td>
                        <td class="tdbstyle">
                            <input id="I_FACT_NO"  class="textbox_char" disabled="disabled"  style="width:100%" />
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
            <div id="Div_COLOR" class=" Div_D" style="width:35%;height:71vh; border-style:solid;border-width:1px; float:right; overflow:auto ">
                <table class="edit_section_control" style="width:70%">
                     <tr class="trstyle"> 
                        <td class="tdbstyle" style="height: 10vh; font-size: smaller;" >&nbsp</td>
                    </tr>
                    <tr class="trstyle">
                        <td style="background-color:#90ee90;width:10%"></td>
                        <td>有圖檔</td>
                        <td style="background-color:Salmon;width:10%"></td>
                        <td>逾期7天</td>
                    </tr>
                    <tr class="trstyle">
                        <td style="background-color:DeepPink;width:10%"></td>
                        <td>逾期20天</td>
                        <td style="background-color:Red;width:10%"></td>
                        <td>逾期30天</td>
                    </tr>
                    <tr class="trstyle">
                        <td style="background-color:Moccasin;width:10%"></td>
                        <td>庫存足夠</td>
                        <td style="background-color:MistyRose;width:10%"></td>
                        <td>建檔</td>
                    </tr>
                   <tr class="trstyle">
                        <td style="background-color:MintCream;width:10%"></td>
                        <td>備貨</td>
                        <td style="background-color:PaleGreen;width:10%"></td>
                        <td>待核</td>
                    </tr>
                    <tr class="trstyle">
                        <td style="background-color:Thistle;width:10%"></td>
                        <td>其他</td>
                        <td style="background-color:PaleTurquoise;width:10%"></td>
                        <td>分配庫存不足</td>
                    </tr>
                </table>
            </div> 
        </div>
    </div>

</asp:Content>
