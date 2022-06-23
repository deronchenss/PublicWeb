<%@ Page Title="Cost Apply" Language="C#" MasterPageFile="~/MP.master" AutoEventWireup="true" CodeFile="Quote_MT.aspx.cs" Inherits="Quote_MT" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="/css/dataTables.bootstrap4.min.css" rel="stylesheet" />
    <script src="/js/jquery.dataTables.min.js"></script>
    <script src="/js/dataTables.bootstrap4.min.js"></script>

    <script type="text/javascript">
        $(document).ready(function () {
            var Edit_Mode;
            //隱藏滾動卷軸
            //document.body.style.overflow = 'hidden';

            //init CONTROLER
            Form_Mode_Change("Base");

            $('#TB_Date_S').val($.datepicker.formatDate('yy-mm-dd', new Date()));
            $('#TB_Date_E').val($.datepicker.formatDate('yy-mm-dd', new Date()));          

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
                        $('#BT_CHS').attr('disabled', 'disabled');
                        $('#BT_Cancel').css('display', 'none');
                        $('#BT_Search').css('display','')
                        break;
                    case "Search":
                        $('.Div_D').css('display', 'none');
                        $('#Div_DT_Search').css('display', '');
                        $('#BT_Search').css('display', 'none')
                        $('#BT_Cancel').css('display', '');
                        $('.V_BT').attr('disabled', false);
                        $('#BT_CHS').attr('disabled', 'disabled');
                        break;
                    case "EXEC":
                        if ($('#Table_CHS_Data > tbody tr').length === 0) {
                            alert('請至少選擇1筆');
                            $('.V_BT').attr('disabled', false);
                            $('#BT_CHS').attr('disabled', 'disabled');
                            Edit_Mode = "Base";
                        }
                        else {
                            $('.Div_D').css('display', 'none');
                            $('#Div_DT_DETAIL').css('display', '');
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
                                "scrollX": true,
                                "scrollY": "62vh",
                                "searching": false,
                                "paging": false,
                                "ordering": false,
                                "bInfo": false //顯示幾筆隱藏
                            });

                            $('#Table_EXEC_Data').DataTable().clear().rows.add($('#Table_CHS_Data').find('tbody tr').clone()).draw(); //將選擇後TABLE 複製至第二面
                            $('#Table_EXEC_info').text('Showing ' + $('#Table_EXEC_Data > tbody tr').length + ' entries'); //顯示TABLE 列數
                            $('#E_QUAH_CNT').text('報價筆數: ' + $('#Table_EXEC_Data > tbody tr').length); //顯示TABLE 列數
                        }
                }
            }

            function Search_Quote() {
                $.ajax({
                    url: "/DEV/Quote/Quote_MT_Search.ashx",
                    data: {
                        "Call_Type": "Quote_MT_Search",
                        "CUST_NO": $('#CUST_NO').val(),
                        "CUST_S_NAME": $('#CUST_S_NAME').val(),
                        "Date_S": $('#TB_Date_S').val(),
                        "Date_E": $('#TB_Date_E').val(),
                        "IVAN_TYPE": $('#IVAN_TYPE').val()
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
                            $('#Table_Search_Quote').DataTable({
                                "data": response,
                                "destroy": true,
                                "columns": [
                                    { data: "客戶簡稱", title: "客戶簡稱" },
                                    { data: "頤坊型號", title: "頤坊型號" },
                                    { data: "美元單價", title: "美元單價" },
                                    { data: "台幣單價", title: "台幣單價" },
                                    { data: "外幣幣別", title: "外幣幣別" },
                                    { data: "外幣單價", title: "外幣單價" },
                                    { data: "MIN", title: "MIN" },
                                    { data: "產品說明", title: "產品說明" },
                                    { data: "單位", title: "單位" },
                                    { data: "廠商編號", title: "廠商編號" },
                                    { data: "廠商簡稱", title: "廠商簡稱" },
                                    { data: "客戶編號", title: "客戶編號" },
                                    { data: "序號", title: "序號" },
                                    { data: "更新人員", title: "<%=Resources.Customer.Update_User%>" },
                                    { data: "更新日期", title: "<%=Resources.Customer.Update_Date%>" }
                                ],
                                "scrollX": true,
                                "scrollY": "62vh",
                                "searching": false,
                                "paging": false,
                                "ordering": false,
                                "bInfo": false //顯示幾筆隱藏
                            });
                            
                           $('#Table_CHS_Data').DataTable({
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
                                "scrollX": true,
                                "scrollY": "62vh",
                                "searching": false,
                                "paging": false,
                                "ordering": false,
                                "bInfo": false //顯示幾筆隱藏
                            });

                            $('#Table_Search_Quote').DataTable().draw();
                            $('#Table_CHS_Data').DataTable().draw();
                            $('#Table_CHS_Data').find('tbody tr').remove();

                            $('#Table_CHS_Data_info').text('Showing ' + $('#Table_CHS_Data > tbody tr').length + ' entries');
                            $('#Table_Search_Quote_info').text('Showing ' + $('#Table_Search_Quote > tbody tr').length + ' entries');
                        }
                    },
                    error: function (ex) {
                        alert(ex);
                    }
                });
            };        

            function Search_QUAH_SEQ() {
                $.ajax({
                    url: "/DEV/Quote/Quote_MT_Search.ashx",
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

            function Item_Move(click_tr, ToTable, FromTable, Full) {
                if (ToTable.find('tbody tr').length === 0) {
                    ToTable.css('white-space', 'nowrap');
                }
                if (Full) {
                    //ToTable.DataTable().rows.add(FromTable.find('tbody tr[role=row]').clone()).draw();
                    //FromTable.DataTable().rows(FromTable.find('tbody tr[role=row]')).remove().draw();
                    ToTable.find('tbody').append(FromTable.find('tbody tr').clone());
                    FromTable.find('tbody tr').remove();
                }
                else {
                    //ToTable.DataTable().row.add(click_tr.clone()).draw();
                    //FromTable.DataTable().rows(click_tr).remove().draw();
                    //ToTable.DataTable().row.add(click_tr);
                    //FromTable.DataTable().row(click_tr).remove();
                    //ToTable.find('tbody').append(FromTable.find(click_tr).clone());
                    ToTable.append(click_tr.clone());
                    click_tr.remove();
                }
               
                $('#Table_CHS_Data_info').text('Showing ' + $('#Table_CHS_Data > tbody tr[role=row]').length + ' entries');
                $('#Table_Search_Quote_info').text('Showing ' + $('#Table_Search_Quote > tbody tr[role=row]').length + ' entries');
                $('#BT_Next').toggle(Boolean($('#Table_CHS_Data').find('tbody tr').length > 0));

                //FromTable.DataTable().draw();
                //ToTable.DataTable().draw();
            }

            //BUTTON CLICK EVENT        
            $('#Table_Search_Quote').on('click', 'tbody tr', function () {
                Item_Move($(this), $('#Table_CHS_Data'), $('#Table_Search_Quote'), false);
            });
            $('#Table_CHS_Data').on('click', 'tbody tr', function () {
                Item_Move($(this), $('#Table_Search_Quote'), $('#Table_CHS_Data'), false);
            });
            $('#BT_ATR').on('click', function () {
                Item_Move($(this), $('#Table_CHS_Data'), $('#Table_Search_Quote'), true);
            });
            $('#BT_ATL').on('click', function () {
                Item_Move($(this), $('#Table_Search_Quote'), $('#Table_CHS_Data'), true);
            });

            $('.V_BT').on('click', function () {
                $(this).attr('disabled', 'disabled');
                $('.V_BT').not($(this)).attr('disabled', false);
            });

            $('#BT_Next').on('click', function () {
                Edit_Mode = "Edit";
                Form_Mode_Change("Review_Data");
            });

            $('#BT_Search').on('click', function () {
                Edit_Mode = "Base";
                Form_Mode_Change("Search");
                Search_Quote();
            });

            $('#BT_QUAH_SEQ').on('click', function () {
                Search_QUAH_SEQ();
            });

            //功能選單
            $('#BT_CHS').on('click', function () {
                Edit_Mode = "Base";
                Form_Mode_Change("Search");
            });

            $('#BT_DT').on('click', function () {
                Edit_Mode = "Edit";
                Form_Mode_Change("EXEC");
            });

            $('#BT_Cancel').on('click', function () {
                var Confirm_Check = confirm("<%=Resources.MP.Cancel_Alert%>");
                if (Confirm_Check) {
                    Edit_Mode = "Base";
                    Form_Mode_Change("Base");
                }
            });

            $('#BT_Re_Select').on('click', function () {
                Edit_Mode = "Base";
                Form_Mode_Change("Search");
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
                <td class="tdhstyle" >客戶編號</td>
                <td class="tdbstyle">
                    <input id="CUST_NO"  class="textbox_char" />
                </td>
                <td class="tdhstyle">客戶簡稱</td>
                <td class="tdbstyle">
                    <input id="CUST_S_NAME"  class="textbox_char" />
                </td>
            </tr>
            <tr class="trstyle">
                <td class="tdhstyle">頤坊型號</td>
                <td class="tdbstyle">
                    <input id="IVAN_TYPE"  class="textbox_char" />
                </td>
                <td class="tdhstyle">更新日期</td>
                <td class="tdbstyle">
                    <input id="TB_Date_S" type="date" class="date_S_style" />~<input id="TB_Date_E" type="date" class="date_E_style" />
                </td>
            </tr>
            <tr>
                <td style="height: 5px; font-size: smaller;" colspan="8">&nbsp</td>
            </tr>
            <tr class="trstyle">
                <td class="tdtstyleRight" colspan="4">
                    <input type="button" id="BT_Search" class="buttonStyle" value="<%=Resources.MP.Search%>" />
                    <input type="button" id="BT_Cancel" class="buttonStyle" value="<%=Resources.MP.Cancel%>" style="display: none;" />
                    <input type="button" id="BT_Re_Select" class="buttonStyle" value="<%=Resources.Cost.Re_Selet%>" style="display:none;" />
                    <input type="button" id="BT_Save" class="buttonStyle" value="<%=Resources.MP.Save%>" style="display:none;" />
                </td>
            </tr>
        </table>
        </div>
        <div class="button_change_section">
            &nbsp;
            <input type="button" id="BT_CHS" class="V_BT" value="選擇"  disabled="disabled" />
            <input type="button" id="BT_DT" class="V_BT" value="報價內容" />
            <input type="button" class="V_BT" value="報表" />
            <input type="button" class="V_BT" value="圖例" />
        </div>

        <div id="Div_DT_Search" class=" Div_D">
            <div id="Div_DT_View" style=" width:70%; border-style:solid;border-width:1px; float:left;">
                <div class="dataTables_info" id="Table_Search_Quote_info" role="status" aria-live="polite"></div>
                <table id="Table_Search_Quote" class="Table_Search table table-striped table-bordered">
                    <thead style="white-space:nowrap"></thead>
                    <tbody style="white-space:nowrap"></tbody>
                </table>
            </div>
    
            <div id="Div_Exec_Data" style="width:25%; border-style:solid;border-width:1px; float:right;">
                <div class="dataTables_info" id="Table_CHS_Data_info" role="status" aria-live="polite"></div>
                <table id="Table_CHS_Data" style="width: 100%;" class="Table_CHS_Data table table-striped table-bordered">
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
                            <input id="E_CUST_SEQ"  class="textbox_char" style="width:80%" />
                            <input id="E_B_CUST_SEQ" style="font-size:20px;width:20%" type="button" value="..." />
                        </td>
                    </tr>
                    <tr class="trCenterstyle">
                        <td class="tdhstyle" style="font-size:20px">客戶簡稱</td>
                        <td class="tdbstyle">
                            <input id="E_CUST_S_NAME"  class="textbox_char" style="width:100%" />
                        </td>
                    </tr>
                     <tr class="trCenterstyle">
                        <td class="tdhstyle" style="font-size:20px">客戶全名</td>
                        <td class="tdbstyle" >
                            <input id="E_CUST_NAME"  style="width:100%" />
                        </td>
                    </tr>
                    <tr class="trCenterstyle">
                        <td class="tdhstyle" style="font-size:20px">出貨地</td>
                        <td class="tdbstyle">
                            <input id="E_SHIP_PLACE" class="textbox_char" style="width:100%"  />
                        </td>
                    </tr>
                    <tr class="trstyle"> 
                        <td class="tdbstyle" style="height: 15vh; font-size: smaller;" >&nbsp</td>
                    </tr>
                    <tr class="trCenterstyle">
                        <td colspan="2">
                            <input id="BT_EXECUTE" style="font-size:20px" type="button" value="執行"  />
                            <input id="BT_CANCEL" style="font-size:20px" type="button" value="返回" />
                        </td>
                    </tr>
                </table>
            </div> 
        </div>
    </div>

</asp:Content>
