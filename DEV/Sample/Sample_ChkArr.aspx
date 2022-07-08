<%@ Page Title="報價作業" Language="C#" MasterPageFile="~/MP.master" AutoEventWireup="true" CodeFile="Sample_ChkArr.aspx.cs" Inherits="Sample_ChkArr" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="/css/dataTables.bootstrap4.min.css" rel="stylesheet" />
    <script src="/js/jquery.dataTables.min.js"></script>
    <script src="/js/dataTables.bootstrap4.min.js"></script>

    <script type="text/javascript">
        $(document).ready(function () {
            var Edit_Mode;
            var apiUrl = "/DEV/Sample/Sample_ChkArr.ashx";
            //隱藏滾動卷軸
            //document.body.style.overflow = 'hidden';

            <%=Session["QUAH_NO"] = null%>;

            //init CONTROLER
            Form_Mode_Change("Base");

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
                            V_BT_CHG($('#BT_DT'));

                            $('#Table_EXEC_Data').DataTable({
                                "destroy": true,
                                "columns": [
                                    { title: "客戶簡稱" },
                                    { title: "頤坊型號" },
                                    { title: "美元單價" },
                                    { title: "台幣單價" },
                                    { title: "外幣幣別" },
                                    { title: "外幣單價" },
                                    { title: "MIN" },
                                    { title: "產品說明" },
                                    { title: "單位" },
                                    { title: "廠商編號" },
                                    { title: "廠商簡稱" },
                                    { title: "客戶編號" },
                                    { title: "序號" },
                                    { title: "<%=Resources.Customer.Update_User%>" },
                                    { title: "<%=Resources.Customer.Update_Date%>" }
                                ],
                                "order": [[1, "asc"]], //根據 頤坊型號 排序
                                "scrollX": true,
                                "scrollY": "62vh",
                                "searching": false,
                                "paging": false,
                                "bInfo": false //顯示幾筆隱藏
                            });

                            $('#Table_EXEC_Data').DataTable().clear().rows.add($('#Table_CHS_Data').find('tbody tr[role=row]').clone()).draw(); //將選擇後TABLE 複製至第二面
                            $('#Table_EXEC_info').text('Showing ' + $('#Table_EXEC_Data > tbody tr[role=row]').length + ' entries'); //顯示TABLE 列數
                            $('#E_QUAH_CNT').text('報價筆數: ' + $('#Table_EXEC_Data > tbody tr[role=row]').length); 

                            //帶出客戶編號、客戶簡稱、客戶全名
                            //因為同一批一定要同個客戶編號才可執行，前方UI有做檢核，故這邊只需要選TABLE第一筆的客戶編號即可
                            var custNoIndex = $('#Table_EXEC_Data thead th:contains(客戶編號)').index() + 1; //客戶編號INDEX
                            var custNo = $('#Table_EXEC_Data > tbody tr:nth-child(1)').find('td:nth-child(' + custNoIndex + ')').text();
                            $('#E_CUST_NO').val(custNo);
                            Search_BYR_NAME(custNo);

                            //帶出報價單號
                            Search_QUAH_SEQ(); 

                            break;
                        }
                    case "RPT":
                        $('.Div_D').css('display', 'none');
                        $('#Div_RPT').css('display', 'flex');

                        V_BT_CHG($('#BT_RPT'));
                        break;
                }
            }

            function Item_Move(click_tr, ToTable, FromTable, Full) {

                if (Full) {
                    ToTable.DataTable().rows.add(FromTable.find('tbody tr[role=row]').clone()).draw();
                    FromTable.DataTable().rows(FromTable.find('tbody tr[role=row]')).remove().draw();
                }
                else {
                    ToTable.DataTable().row.add(click_tr.clone()).draw();
                    FromTable.DataTable().rows(click_tr).remove().draw();
                }

                //移除重複ROWS
                removeDuplicateRows(ToTable);

                $('#Table_CHS_Data_info').text('Showing ' + $('#Table_CHS_Data > tbody tr[role=row]').length + ' entries');
                $('#Table_Search_Pudu_info').text('Showing ' + $('#Table_Search_Pudu > tbody tr[role=row]').length + ' entries');
                $('#BT_Next').toggle(Boolean($('#Table_CHS_Data').find('tbody tr').length > 0));
            }

            //移除 DATATABLE 重複ROWS
            function removeDuplicateRows($table) {
                function getVisibleRowText($row) {
                    return $row.find('td:visible').text().toLowerCase();
                }

                $table.find('tr').each(function (index, row) {
                    var $row = $(row);
                    $row.nextAll('tr').each(function (index, next) {
                        var $next = $(next);
                        if (getVisibleRowText($next) == getVisibleRowText($row))
                            $table.DataTable().rows($row).remove().draw();
                    })
                });
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
                        "IVAN_TYPE": $('#Q_IVAN_TYPE').val(),
                        "TMP_TYPE": $('#Q_TMP_TYPE').val(),
                        "PUDU_GIVE_DATE_S": $('#Q_PUDU_GIVE_DATE_S').val(),
                        "PUDU_GIVE_DATE_E": $('#Q_PUDU_GIVE_DATE_E').val(),
                        "FACT_NO": $('#Q_FACT_NO').val(),
                        "FACT_S_NAME": $('#Q_FACT_S_NAME').val(),
                        "PUDU_NO": $('#Q_PUDU_NO').val(),
                        "FACT_TYPE": $('#Q_FACT_TYPE').val(),
                        "WRITE_OFF": $('#Q_WRITEOFF').val()
                    },
                    cache: false,
                    type: "POST",
                    datatype: "json",
                    contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                    success: function (response,status) {
                        if (response.length === 0) {
                            alert('<%=Resources.MP.Data_Not_Exists_Alert%>');
                            Edit_Mode = "Base";
                            Form_Mode_Change("Base");
                        }
                        else {
                            console.log(status);
                            var jsonArr = $.parseJSON(response);
                            $('#Table_Search_Pudu').DataTable({
                                "data": jsonArr,
                                "destroy": true,
                                //維持scroll bar 位置
                                "preDrawCallback": function (settings) {
                                    pageScrollPos = $('div.dataTables_scrollBody').scrollTop();
                                },
                                "drawCallback": function (settings) {
                                    $('div.dataTables_scrollBody').scrollTop(pageScrollPos);
                                },
                                "columns": [
                                    { data: "採購單號", title: "採購單號" },
                                    { data: "廠商簡稱", title: "廠商簡稱" },
                                    { data: "頤坊型號", title: "頤坊型號" },
                                    { data: "採購數量", title: "採購數量" },
                                    {
                                        data: null, title: "本次點收",
                                        render: function (data, type, row) {
                                            return '<input type="checkbox" style="text-align:center" class="tbChkBox tableChkBox" />'
                                        },
                                        orderable: false
                                    },
                                    { data: "外幣幣別", title: "外幣幣別" },
                                    { data: "外幣單價", title: "外幣單價" },
                                    { data: "MIN", title: "MIN" },
                                    { data: "產品說明", title: "產品說明" },
                                    { data: "單位", title: "單位" },
                                    { data: "廠商編號", title: "廠商編號" },
                                    { data: "客戶編號", title: "客戶編號" },
                                    { data: "序號", title: "序號" },
                                    { data: "更新人員", title: "<%=Resources.Customer.Update_User%>" },
                                    { data: "更新日期", title: "<%=Resources.Customer.Update_Date%>" }
                                ],
                                "order": [[1, "asc"]], //根據 頤坊型號 排序
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
                                    { title: "客戶簡稱" },
                                    { title: "頤坊型號" },
                                    { title: "美元單價" },
                                    { title: "台幣單價" },
                                    { title: "外幣幣別" },
                                    { title: "外幣單價" },
                                    { title: "MIN" },
                                    { title: "產品說明" },
                                    { title: "單位" },
                                    { title: "廠商編號" },
                                    { title: "廠商簡稱" },
                                    { title: "客戶編號" },
                                    { title: "序號" },
                                    { title: "<%=Resources.Customer.Update_User%>" },
                                   { title: "<%=Resources.Customer.Update_Date%>" }
                               ],
                               "order": [[1, "asc"]], //根據 頤坊型號 排序
                               "scrollX": true,
                               "scrollY": "62vh",
                               "searching": false,
                               "paging": false,
                               "bInfo": false //顯示幾筆隱藏
                           });

                            $('#Table_Search_Pudu').DataTable().draw();
                            $('#Table_CHS_Data').DataTable().draw();

                            $('#Table_CHS_Data_info').text('Showing ' + $('#Table_CHS_Data > tbody tr[role=row]').length + ' entries');
                            $('#Table_Search_Pudu_info').text('Showing ' + $('#Table_Search_Pudu > tbody tr[role=row]').length + ' entries');
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

            //寫入DB
            function INSERT_QUAH() {
                var liIvanType = [];
                var liFactNo = [];
                var custNo = $('#E_CUST_NO').val(); 
                var corCnt = 0;
                var errCnt = 0;
                var execCnt = $('#Table_EXEC_Data > tbody tr[role=row]').length;

                for (var tableCnt = 1; tableCnt <= execCnt; tableCnt++) {
                    var ivanTypeIndex = $('#Table_EXEC_Data thead th:contains(頤坊型號)').index() + 1; //頤坊型號INDEX
                    var ivanType = $('#Table_EXEC_Data > tbody tr:nth-child(' + tableCnt + ')').find('td:nth-child(' + ivanTypeIndex + ')').text();
                    var factNoIndex = $('#Table_EXEC_Data thead th:contains(廠商編號)').index() + 1; //廠商編號INDEX
                    var factNo = $('#Table_EXEC_Data > tbody tr:nth-child(' + tableCnt + ')').find('td:nth-child(' + factNoIndex + ')').text();
                    var custNoIndex = $('#Table_EXEC_Data thead th:contains(客戶編號)').index() + 1; //客戶編號INDEX
                    var tableCustNo = $('#Table_EXEC_Data > tbody tr:nth-child(' + tableCnt + ')').find('td:nth-child(' + custNoIndex + ')').text();

                    //一樣的寫入DB
                    if (custNo == tableCustNo) {
                        corCnt++;

                        liIvanType.push(ivanType);
                        liFactNo.push(factNo);
                        $('#Table_EXEC_Data > tbody tr:nth-child(' + tableCnt + ')').toggleClass('removeReady');
                    }
                    else {
                        errCnt++;
                    }
                }

                //一次刪，防止迴圈判斷錯誤
                $('#Table_EXEC_Data').DataTable().rows('.removeReady').remove().draw();

                if (errCnt != 0) {
                    alert('共' + errCnt + '筆客戶編號不同');
                }

                $.ajax({
                    url: apiUrl,
                    data: {
                        "Call_Type": "INSERT_QUAH",
                        "SEQ": $('#E_QUAH_SEQ').val(),
                        "IVAN_TYPE": liIvanType,
                        "FACT_NO": liFactNo,
                        "FROM": $('#E_SHIP_PLACE').val(),
                        "CUST_NO": $('#E_CUST_NO').val()
                    },
                    cache: false,
                    type: "POST",
                    datatype: "json",
                    contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                    success: function (response) {
                        if (response != liIvanType.length) {
                            console.log(response);
                            alert('寫入有誤請通知資訊人員');
                            return;
                        }
                        else {
                            alert('已寫入報價檔，筆數:' + corCnt);

                            //回到第一頁
                            Search_Pudu();
                            $('#Table_CHS_Data').DataTable().clear().rows.add($('#Table_EXEC_Data').find('tbody tr[role=row]').clone()).draw();

                            Edit_Mode = "Search";
                            Form_Mode_Change("Search");
                            $('#R_QUAH_NO').val($('#E_QUAH_SEQ').val());
                        }
                    },
                    error: function (ex) {
                        alert(ex);
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
                if ($('#E_QUAH_SEQ').val().length != 7) {
                    alert('報價單號 規格不正確 !');
                    return;
                }
                if ($('#E_CUST_S_NAME').val() === '') {
                    alert('客戶簡稱不可空白');
                    return;
                }
                if ($('#E_SHIP_PLACE').val() === '') {
                    alert('出貨地不可空白');
                    return;
                }

                INSERT_QUAH();
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

            $('#BT_S_CHK').on('click', function () {
                Edit_Mode = "EXEC";
                Form_Mode_Change("EXEC");
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
                <td class="tdhstyle">暫時型號</td>
                <td class="tdbstyle">
                    <input id="Q_TMP_TYPE"  class="textbox_char" />
                </td>
                <td class="tdhstyle">採購交期</td>
                <td class="tdbstyle">
                    <input id="Q_PUDU_GIVE_DATE_S" type="date" class="date_S_style" />~<input id="Q_PUDU_GIVE_DATE_E" type="date" class="date_E_style" />
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
                <td class="tdhstyle">結案狀態</td>
                <td class="tdbstyle">
                    <select id="Q_WRITEOFF" >
                        <option selected="selected"value="0">未結案</option>
                        <option value="">全部</option>
                        <option value="1">結案</option>
                    </select>
                </td>
            </tr>
            <tr class="trstyle">
                <td class="tdhstyle">採購單號</td>
                <td class="tdbstyle">
                    <input id="Q_PUDU_NO"  class="textbox_char" />
                </td>
                <td class="tdhstyle">廠商型號</td>
                <td class="tdbstyle">
                    <input id="Q_FACT_TYPE" class="textbox_char" />
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
            <input type="button" id="BT_S_CHS" class="V_BT" value="選擇"  disabled="disabled" />
            <input type="button" id="BT_S_CHK" class="V_BT" value="點收內容" />
            <input type="button" id="BT_S_EX_IMG" class="V_BT" value="圖例" />
        </div>

        <div id="Div_DT_Search" class=" Div_D">
            <div id="Div_DT_View" style=" width:70%; border-style:solid;border-width:1px; float:left;">
                <div class="dataTables_info" id="Table_Search_Pudu_info" role="status" aria-live="polite"></div>
                <table id="Table_Search_Pudu" class="Table_Search table table-striped table-bordered">
                    <thead style="white-space:nowrap"></thead>
                    <tbody style="white-space:nowrap"></tbody>
                </table>
            </div>
    
            <div id="Div_Exec_Data" style="width:25%; border-style:solid;border-width:1px; float:right;">
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
            <div id="Div_DETAIL_VIEW"  style="width:70%; border-style:solid;border-width:1px; float:left;">
                <div class="dataTables_info" id="Table_EXEC_info" role="status" aria-live="polite"></div>
                    <table id="Table_EXEC_Data" class="Table_Search table table-striped table-bordered">
                        <thead style="white-space:nowrap"></thead>
                        <tbody style="white-space:nowrap"></tbody>
                    </table>
            </div>
    
            <div id="Div_Exec_Section" style="width:28%;height:71vh; border-style:solid;border-width:1px; float:right;">
                <table class="search_section_control">
                    <tr> 
                        <td style="height: 2vh; font-size: smaller;" >&nbsp</td>
                    </tr>
                    <tr class="trCenterstyle" style="font-size:20px">
                        <td colspan="2"  id="E_QUAH_CNT" >報價筆數:</td>
                    </tr>
                    <tr> 
                        <td style="height: 15vh; font-size: smaller;" >&nbsp</td>
                    </tr>
                    <tr class="trCenterstyle">
                        <td class="tdhstyle" style="font-size:20px">報價單號</td>
                        <td class="tdbstyle">
                            <input id="E_QUAH_SEQ"  class="textbox_char" style="width:80%" />
                            <input id="BT_QUAH_SEQ" style="font-size:20px;width:20%" type="button" value="..." />
                        </td>
                    </tr>
                    <tr class="trCenterstyle">
                        <td class="tdhstyle" style="font-size:20px">客戶編號</td>
                        <td class="tdbstyle">
                            <input id="E_CUST_NO"  class="textbox_char" disabled="disabled" style="width:100%" />
                        </td>
                    </tr>
                    <tr class="trCenterstyle">
                        <td class="tdhstyle" style="font-size:20px">客戶簡稱</td>
                        <td class="tdbstyle">
                            <input id="E_CUST_S_NAME"  class="textbox_char" disabled="disabled" style="width:100%" />
                        </td>
                    </tr>
                     <tr class="trCenterstyle">
                        <td class="tdhstyle" style="font-size:20px">客戶全名</td>
                        <td class="tdbstyle" >
                            <input id="E_CUST_NAME"  style="width:100%" disabled="disabled" />
                        </td>
                    </tr>
                    <tr class="trCenterstyle">
                        <td class="tdhstyle" style="font-size:20px">出貨地</td>
                        <td class="tdbstyle">
                            <select id="E_SHIP_PLACE">
                                <option selected="selected" value="0">0-預設</option>
                                <option value="1">1-台灣出貨</option>
                                <option value="2">2-中國出貨</option>
                            </select>
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
        </div>
    </div>

</asp:Content>
