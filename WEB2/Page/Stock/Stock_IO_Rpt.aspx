<%@ Page Title="待入出庫報表" Language="C#" MasterPageFile="~/MP.master" AutoEventWireup="true" CodeFile="Stock_IO_Rpt.aspx.cs" Inherits="Stock_IO_Rpt" %>
<%@ Register TagPrefix="uc2" TagName="uc2" Src="~/User_Control/Dia_Product_ALL.ascx" %>
<%@ Register TagPrefix="uc3" TagName="uc3" Src="~/User_Control/Dia_Duo_Datetime_Picker.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="/css/dataTables.bootstrap4.min.css" rel="stylesheet" />
    <script src="/js/jquery.dataTables.min.js"></script>
    <script src="/js/dataTables.bootstrap4.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            var Edit_Mode;
            var apiUrl = "/Page/Stock/Ashx/Stock_IO_Rpt.ashx";
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
                index = $('#Table_EXEC_Data thead th:contains(SUPLU_SEQ)').index();
                $('#I_SUPLU_SEQ').val(clickData[index]);
                Search_IMG($('#I_SUPLU_SEQ').val());
            }

            //init CONTROLER
            Form_Mode_Change("Base");
            $('.onlyImg').toggle(true);
            $('.onlySticker').toggle(false);
            //報表預設前三個月
            var dateToday = new Date();
            var date = new Date(dateToday.setMonth(dateToday.getMonth() - 3));
            $('#Q_UPD_DATE_S').val($.datepicker.formatDate('yy-mm-dd', new Date(date.getFullYear(), date.getMonth(), 1)));
            $('#Q_UPD_DATE_E').val($.datepicker.formatDate('yy-mm-dd', new Date()));

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
                dataReq['UPD_USER'] = "<%=(Session["Account"] == null) ? "IVAN10" : Session["Account"].ToString().Trim() %>";

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
                        if ($(this).attr('DT_Query_Name') == 'SORT') {
                            if ($(this).css('display') != 'none') {
                                dataReq[$(this).attr('DT_Query_Name')] = $.trim($(this).val());
                            }
                        }
                        else {
                            dataReq[$(this).attr('DT_Query_Name')] = $.trim($(this).val());
                        }
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
                                        className: 'text-right', targets: [8, 9]  //number
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
                            $('#E_PRINT_TITLE').text('列印項次，筆數: ' + $('#Table_EXEC_Data > tbody tr[role=row]').length);
                            $('#E_RPT_TYPE').val($("input[type=radio][name=RPT_TYPE]:checked").val());
                            $('#E_DATA_SOURCE').val($.trim($('#Q_DATA_SOURCE option:selected').text()));
                            $('#E_QUERY_CONDITION').val(JSON.stringify(dataReq));
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
                if ($.trim($('#E_RPT_TYPE').val()) == '') {
                    alert('請重新查詢!');
                    return;
                }

                var obj = JSON.parse($('#E_QUERY_CONDITION').val());
                obj['Call_Type'] = 'RPT';

                $("body").loading(); // 遮罩開始
                $.ajax({
                    url: apiUrl,
                    data: obj,
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
                            alert('查無資料!');
                        }
                        else if (status !== 'success') {
                            alert(response);
                        }
                        else {
                            var blob = new Blob([response], { type: "application/pdf" });
                            var url = window.URL || window.webkitURL;
                            link = url.createObjectURL(blob);
                            var a = $("<a />");
                            a.attr("download", $('#E_RPT_TYPE').val() + ".pdf");
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
                        alert('產生報表有誤請通知資訊人員');
                        return;
                    }
                });
            };         

            $('input[type=radio][name=RPT_TYPE]').on('click', function () {
                switch ($(this).prop('id')) {
                    case "Q_RB_IMG":
                        $('.onlyImg').toggle(true);
                        $('.onlySticker').toggle(false);
                        break;
                    case "Q_RB_STICKER":
                        $('.onlySticker').toggle(true);
                        $('.onlyImg').toggle(false);
                        break;
                }
            });

            //BUTTON CLICK EVENT BASE 頁
            $('#BT_Search').on('click', function () {
                if ($('#Q_UPD_DATE_S').val() == '' || $('#Q_UPD_DATE_E').val() == '') {
                    alert('請選擇更新日期區間!');
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
            $('#BT_PRINT').on('click', function () {
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
                <td class="tdhstyle">報表類型</td>
                <td class="tdbstyle">
                    <input id="Q_RB_IMG"  DT_Query_Name="RPT_TYPE" value ="待入出庫輸入核對表-圖" type="radio" name="RPT_TYPE" checked="checked" />
                    <label for="Q_RB_IMG">待入出庫輸入核對表-圖</label>
                </td>
                <td class="tdhstyle">更新日期</td>
                <td class="tdbstyle">
                    <input id="Q_UPD_DATE_S" type="date" DT_Query_Name="更新日期_S" class="date_S_style TB_DS" /><input id="Q_UPD_DATE_E" DT_Query_Name="更新日期_E" type="date" class="date_E_style TB_DE" />
                    <input id="BT_Duo_Datetime_Picker" type="button" value="…" onclick="$('#Duo_Datetime_Picker_Dialog').dialog('open');" />
                </td>
                <td class="tdhstyle">訂單號碼</td>
                <td class="tdbstyle">
                    <input id="Q_ORDER_NO" DT_Query_Name="訂單號碼" class="textbox_char" />
                </td>
                <td class="tdhstyle">資料來源</td>
                <td class="tdbstyle">
                    <select id="Q_DATA_SOURCE" DT_Query_Name="DATA_SOURCE" > 
                        <option selected="selected" value="0">等待</option>
                        <option value="1">歷史</option>
                    </select>
                </td>
            </tr>
            <tr class="trstyle">
                <td class="tdhstyle">
                </td>
                <td class="tdbstyle">
                    <input id="Q_RB_STICKER" DT_Query_Name="RPT_TYPE" value ="外包裝貼紙" type="radio" name="RPT_TYPE" />
                    <label for="Q_RB_STICKER">外包裝貼紙</label>
                </td>
                <td class="tdhstyle onlyImg">單據編號</td>
                <td class="tdbstyle onlyImg">
                    <input id="Q_DOCUMENT_NO" DT_Query_Name="單據編號" class="textbox_char" />
                </td>
                <td class="tdhstyle onlySticker">頤坊型號</td>
                <td class="tdbstyle onlySticker">
                    <input id="Q_IVAN_TYPE" DT_Query_Name="頤坊型號" class="textbox_char" />
                </td>
                <td class="tdhstyle">客戶編號</td>
                <td class="tdbstyle">
                    <input id="Q_CUST_NO" DT_Query_Name="客戶編號" class="textbox_char" />
                </td>
                <td class="tdhstyle onlyImg">備註</td>
                <td class="tdbstyle onlyImg">
                    <input id="Q_REMARK" DT_Query_Name="備註" class="textbox_char" />
                </td>
            </tr>
            <tr class="trstyle">
                <td class="tdhstyle">庫區</td>
                <td class="tdbstyle">
                    <select id="Q_STOCK_POS" DT_Query_Name="庫區" >
                        <option selected="selected"value=""></option>
                        <option value="大貨">大貨</option>
                        <option value="台北">台北</option>
                        <option value="台中">台中</option>
                        <option value="高雄">高雄</option>
                        <option value="樣品">樣品</option>
                        <option value="內湖">內湖</option>
                        <option value="展示">展示</option>
                        <option value="留底">留底</option>
                        <option value="展場">展場</option>
                        <option value="廠商">廠商</option>
                        <option value="設計">設計</option>                      
                    </select>
                </td>
                <td class="tdhstyle onlyImg">入出庫</td>
                <td class="tdbstyle onlyImg">
                    <select id="Q_STOCK_IO" DT_Query_Name="入出庫" > 
                        <option selected="selected" value=""></option>
                        <option value="入庫">入庫</option>
                        <option value="出庫">出庫</option>
                    </select>
                </td>
                <td class="tdhstyle">列印排序</td>
                <td class="tdbstyle">
                    <select id="Q_ORDER_TYPE_IMG" class="onlyImg" DT_Query_Name="SORT" > 
                        <option selected="selected" value="訂單號碼">訂單排</option>
                        <option value="庫位">庫位排</option>
                    </select>
                    <select id="Q_ORDER_TYPE_STICKER" class="onlySticker" DT_Query_Name="SORT" > 
                        <option selected="selected" value="訂單號碼">訂單號碼</option>
                        <option value="大貨庫位">大貨庫位</option>
                        <option value="快取庫位">快取庫位</option>
                        <option value="銷售型號">銷售型號</option>
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
            <input type="button" id="BT_S_EXEC" class="V_BT" value="列印" disabled="disabled" />
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
                            <td colspan="2"  id="E_PRINT_TITLE" >列印筆數:</td>
                        </tr>
                        <tr style="font-size:20px">
                            <td colspan="2" >                    
                                <div style="height: 10vh; font-size: smaller;" >&nbsp
                                </div>
                            </td>
                        </tr>
                         <tr style="font-size:20px">
                            <td class="tdhstyle">報表類型:</td>
                            <td class="tdbstyle">
                                <input id="E_QUERY_CONDITION" type="hidden"/> <%--紀錄查詢條件--%>
                                <input id="E_RPT_TYPE" class="textbox_char" disabled="disabled" />
                            </td>
                        </tr>
                        <tr style="font-size:20px">
                            <td class="tdhstyle">資料來源:</td>
                            <td class="tdbstyle">
                                <input id="E_DATA_SOURCE" class="textbox_char" disabled="disabled" />
                            </td>
                        </tr>
                    </table>
                </div>
                <div style="height: 5vh; font-size: smaller;" >&nbsp</div>
                <div style="text-align:center">
                     <input id="BT_PRINT" style="font-size:20px" type="button" value="列印"  />
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
