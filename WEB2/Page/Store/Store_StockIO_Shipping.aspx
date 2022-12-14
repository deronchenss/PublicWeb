<%@ Page Title="門市庫取出貨" Language="C#" MasterPageFile="~/MP.master" AutoEventWireup="true" CodeFile="Store_StockIO_Shipping.aspx.cs" Inherits="Store_StockIO_Shipping" %>
<%@ Register TagPrefix="uc2" TagName="uc2" Src="~/User_Control/Dia_Product_ALL.ascx" %>
<%@ Register TagPrefix="uc3" TagName="uc3" Src="~/User_Control/Dia_Duo_Datetime_Picker.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="/css/dataTables.bootstrap4.min.css" rel="stylesheet" />
    <script src="/js/jquery.dataTables.min.js"></script>
    <script src="/js/dataTables.bootstrap4.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            var Edit_Mode;
            var apiUrl = "/Page/Store/Ashx/Store_StockIO_Shipping.ashx";
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
                $('#I_IVAN_TYPE').val($click.find('.Call_Product_Tool').val());
                index = $('#Table_EXEC_Data thead th:contains(廠商編號)').index();
                $('#I_FACT_NO').val(clickData[index]);
                index = $('#Table_EXEC_Data thead th:contains(廠商簡稱)').index();
                $('#I_FACT_S_NAME').val(clickData[index]);
                index = $('#Table_EXEC_Data thead th:contains(產品說明)').index();
                $('#I_PROD_DESC').val(clickData[index]);
                index = $('#Table_EXEC_Data thead th:contains(SUPLU_SEQ)').index();
                $('#I_SUPLU_SEQ').val(clickData[index]);
                Search_IMG($('#I_SUPLU_SEQ').val());
            }

            //init CONTROLER
            Form_Mode_Change("Base");
            $('#E_SHIPPING_DATE').val($.datepicker.formatDate('yy-mm-dd', new Date()));

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

                        V_BT_CHG($('#BT_S_EXEC'));
                        break;
                    case "EXEC":
                        $('.Div_D').css('display', 'none');
                        $('#Div_DT_DETAIL').css('display', '');
                        $('#Div_IMG_DETAIL').css('display', 'none');

                        $('#Div_Exec_Section').css('display', '');
                        $('#Div_PRE_DEL').css('display', 'none');
                        V_BT_CHG($('#BT_S_EXEC'));
                        break;
                    case "IMG":
                        $('.Div_D').css('display', 'none');
                        $('#Div_DT_DETAIL').css('display', '');
                        $('#Div_Exec_Section').css('display', 'none');
                        $('#Div_PRE_DEL').css('display', 'none');
                        $('#Div_IMG_DETAIL').css('display', '');
                        V_BT_CHG($('#BT_S_EX_IMG'));

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
                            $('#Table_Search_Data_Tmp').empty();
                            $('#Table_EXEC_Data').empty();
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

                            //0 輸出空白
                            $('#Table_Search_Data_Tmp tbody td').filter(function () { return parseFloat($(this).text()) === 0; }).text('');

                            //顏色設定
                            var ivanIndex = $('#Table_Search_Data_Tmp').find('thead th:contains(頤坊型號)').index() + 1;
                            $('#Table_Search_Data_Tmp').find('tbody tr[role=row]').each(function () {
                                var rowData = $('#Table_Search_Data_Tmp').DataTable().row($(this)).data();
                                var $columnIvan = $(this).find('td:nth-child(' + ivanIndex + ')');

                                //button
                                var ivanStyle = '<input class="Call_Product_Tool" SUPLU_SEQ = "' + (rowData.SUPLU_SEQ ?? "")
                                    + '" type="button" value="' + (rowData.頤坊型號 ?? "")
                                    + '" style="text-align:left;width:100%;z-index:1000;' + ((rowData.Has_IMG == 'Y') ? 'background: #90ee90;' : '') + '" />';
                                $columnIvan.html(ivanStyle);
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
                                        className: 'text-right', targets: [8]  //number
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

                            $('#Table_EXEC_Data').DataTable().clear().rows.add($('#Table_Search_Data_Tmp').find('tbody tr[role=row]').clone()).draw();
                            $('#Table_EXEC_Data_info').text('Showing ' + $('#Table_EXEC_Data > tbody tr[role=row]').length + ' entries');
                            $('#E_EXEC_TITLE').text('出貨項次，筆數: ' + $('#Table_EXEC_Data > tbody tr[role=row]').length);
                            $('#E_PM_NO').val($('#Q_PM_NO').val());

                            //取得箱數
                            var bigNo = 1;
                            var smallNo = 1;
                            var cnt = 1;
                            $('#Table_EXEC_Data > tbody tr[role=row]').each(function (index) {
                                var packSeq = $('#Table_EXEC_Data thead th:contains(箱號)').index() + 1; //箱號INDEX
                                packNo = $(this).find('td:nth-child(' + packSeq + ')').text();
                                var numStr = packNo.replace(/[^0-9]/ig, '');
                                if (isNaN(parseInt(numStr, 10))) {
                                    numStr = 1;
                                }
                                if (cnt == 1) {
                                    bigNo = parseInt(numStr, 10);
                                    smallNo = parseInt(numStr, 10);
                                }

                                if (parseInt(numStr, 10) > bigNo) {
                                    bigNo = parseInt(numStr, 10);
                                }
                                if (parseInt(numStr, 10) < smallNo) {
                                    smallNo = parseInt(numStr, 10);
                                }
                                cnt++;
                            })
                            $('#Q_PACK_CNT').val(bigNo - smallNo + 1);
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
                if ($.trim($('#E_PM_NO').val()) == '') {
                    alert('PM_NO不可為空!');
                    return;
                }
                else if ($.trim($('#E_SHIPPING_DATE').val()) == '') {
                    alert('出貨日期不可為空!');
                    return;
                }

                var execData = [];
                var execCnt = $('#Table_EXEC_Data > tbody tr[role=row]').length;
                var err = false;
                $('#Table_EXEC_Data > tbody tr[role=row]').each(function (index) {
                    var object = {};
                    var seqIndex = $('#Table_EXEC_Data thead th:contains(序號)').index() + 1; //序號INDEX
                    var noEnterStockIndex = $('#Table_EXEC_Data thead th:contains(不入庫)').index() + 1; //不入庫INDEX
                    var shippingCntIndex = $('#Table_EXEC_Data thead th:contains(出貨數)').index() + 1; //出貨數INDEX
                    var supluSeqIndex = $('#Table_EXEC_Data thead th:contains(SUPLU_SEQ)').index() + 1; //SUPLU_SEQINDEX
                    object['序號'] = $(this).find('td:nth-child(' + seqIndex + ')').text();
                    object['不入庫'] = ($(this).find('td:nth-child(' + noEnterStockIndex + ')').text() == 'Y' ? 1 : 0);
                    object['出貨日期'] = $('#E_SHIPPING_DATE').val();
                    object['核銷數'] = $(this).find('td:nth-child(' + shippingCntIndex + ')').text();
                    object['已結案'] = 1;
                    object['SUPLU_SEQ'] = $(this).find('td:nth-child(' + supluSeqIndex + ')').text();
                    object['更新人員'] = "<%=(Session["Account"] == null) ? "IVAN10" : Session["Account"].ToString().Trim() %>";
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
                            alert('出貨有誤請通知資訊人員');
                            return;
                        }
                        else {
                            alert('已出貨，筆數:' + execCnt);
                            $('#Table_EXEC_Data').DataTable().rows().remove().draw();

                            //回到第一頁
                            SearchData();
                            Edit_Mode = "Base";
                            Form_Mode_Change("Base");
                        }
                    },
                    error: function (ex) {
                        console.log(ex.responseText);
                        alert('出貨有誤請通知資訊人員');
                        return;
                    }
                });
            };         

            //BUTTON CLICK EVENT BASE 頁
            $('#BT_Search').on('click', function () {
                if ($.trim($('#Q_PM_NO').val()) == '') {
                    alert('PM_NO不可為空!');
                    return;
                }

                Edit_Mode = "Base";
                Form_Mode_Change("EXEC");
                SearchData();
            });

            $('#BT_Cancel').on('click', function () {
                $('#Table_EXEC_Data').DataTable().clear().draw();

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
                <td style="height: 5px;"  colspan="8"></td>
            </tr>
            <tr class="trstyle">
                <td class="tdhstyle">PM_NO</td>
                <td class="tdbstyle">
                    <input id="Q_PM_NO" DT_Query_Name="PM_NO" class="textbox_char" />
                </td>
            </tr>
            <tr class="trstyle">
                <td class="tdhstyle">箱數</td>
                <td class="tdbstyle">
                    <input id="Q_PACK_CNT" class="textbox_char" disabled="disabled" />
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
            <input type="button" id="BT_S_EXEC" class="V_BT" value="出貨" disabled="disabled" />
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
                            <td colspan="2"  id="E_EXEC_TITLE" >出貨項次:</td>
                        </tr>
                    </table>
                    <div style="height: 10vh; font-size: smaller;" >&nbsp</div>
                    <table style="margin:0 auto">
                         <tr >
                            <td class="tdhstyle">PM_NO</td>
                            <td class="tdbstyle">
                                <input id="E_PM_NO"  class="textbox_char" maxlength="30" disabled="disabled" />
                            </td>
                        </tr>
                        <tr >
                            <td class="tdhstyle">出貨日期</td>
                            <td class="tdbstyle">
                                <input id="E_SHIPPING_DATE" type="date" class="textbox_char" />
                            </td>
                        </tr>
                    </table>
                </div>
                <div style="height: 5vh; font-size: smaller;" >&nbsp</div>
                <div style="text-align:center">
                     <input id="BT_EXECUTE" style="font-size:20px" type="button" value="執行"  />
                </div>
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
