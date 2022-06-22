<%@ Page Title="Cost Apply" Language="C#" MasterPageFile="~/MP.master" AutoEventWireup="true" CodeFile="Quote_MT.aspx.cs" Inherits="Quote_MT" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="/css/dataTables.bootstrap4.min.css" rel="stylesheet" />
    <script src="/js/jquery.dataTables.min.js"></script>
    <script src="/js/dataTables.bootstrap4.min.js"></script>

    <script type="text/javascript">
        $(document).ready(function () {
            var Edit_Mode;
            //隱藏滾動卷軸
            document.body.style.overflow = 'hidden';

            $('#TB_Date_S').val($.datepicker.formatDate('yy-mm-dd', new Date()));
            $('#TB_Date_E').val($.datepicker.formatDate('yy-mm-dd', new Date()));

            window.document.body.onbeforeunload = function () {
                if (Edit_Mode === "Edit") {
                    return '您尚未將編輯過的表單資料送出，請問您確定要離開網頁嗎？';
                }
            }
            function Form_Mode_Change(Form_Mode) {
                switch (Form_Mode) {
                    case "Base":
                        $('#BT_Search').css('display', '');
                        $('#BT_Cancel').css('display', 'none');
                        $('#Div_DT_View, #Div_Exec_Data').css('display', 'none');
                        $('#BT_ATR, #BT_ATL, #BT_Next').css('display', 'none');
                        $('#BT_Re_Select, #BT_Save').css('display', 'none');
                        $('.For_S').css('display', '');
                        $('.For_U').css('display', 'none');
                        break;
                    case "Search":
                        $('#BT_Cancel').css('display', '');
                        $('#BT_Search').css('display', 'none');
                        $('#Div_DT_View, #Div_Exec_Data').css('display', '');
                        $('#Div_DT_View').css('width', '70%');
                        $('#Div_Exec_Data').css('width', '25%');
                        $('#BT_ATR, #BT_ATL').css('display', '');
                        $('#BT_Re_Select, #BT_Save').css('display', 'none');
                        $('.For_S, .For_U').css('display', 'none');
                        break;
                    case "Review_Data":
                        $('#BT_Cancel').css('display', 'none');
                        $('#Div_DT_View').css('display', 'none');
                        $('#Div_Exec_Data').css('width', '100%');
                        $('#BT_Re_Select, #BT_Save').css('display', '');
                        $('.For_U').css('display', '');
                        break;
                }
            }

            $('#BT_Search').on('click', function () {
                Edit_Mode = "Can_Move";
                Form_Mode_Change("Search");
                Search_Cost();
            });

            $('#BT_Cancel').on('click', function () {
                var Confirm_Check = confirm("<%=Resources.MP.Cancel_Alert%>");
                if (Confirm_Check) {
                    Edit_Mode = "Base";
                    Form_Mode_Change("Base");
                }
            });

            $('#BT_Re_Select').on('click', function () {
                Edit_Mode = "Can_Move";
                Form_Mode_Change("Search");
            });

            function Search_Cost(Search_Where) {
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

                            <%--var Table_HTML =
                                '<thead style="display:block;overflow:hidden"><tr>'
                                + '</th><th>' + '客戶簡稱'
                                + '</th><th>' + '頤坊型號'
                                + '</th><th>' + '美元單價'
                                + '</th><th>' + '台幣單價'
                                + '</th><th class="DIMG">' + '<%=Resources.BOM.PD_IMG%>'
                                + '</th><th>' + '外幣幣別'
                                + '</th><th>' + '外幣單價'
                                + '</th><th>' + 'MIN'
                                + '</th><th>' + '產品說明'
                                + '</th><th>' + '單位'
                                + '</th><th>' + '廠商編號>'
                                + '</th><th>' + '廠商簡稱'
                                + '</th><th>' + '客戶編號'
                                + '</th><th>' + '序號'
                                + '</th><th>' + '<%=Resources.Cost.Update_User%>'
                                + '</th><th>' + '<%=Resources.Cost.Update_Date%>'
                                + '</th></tr></thead><tbody style="display:block;overflow:auto;height:inherit">';

                            $(response).each(function (i) {
                                var binary = '';
                                if (response[i].Has_IMG) {
                                    $.ajax({
                                        url: "/BOM/BOM_Search.ashx",
                                        data: {
                                            "Call_Type": "GET_IMG",
                                            "P_SEQ": response[i].SEQ
                                        },
                                        cache: false,
                                        async: false,
                                        type: "POST",
                                        datatype: "json",
                                        contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                                        success: function (RR) {
                                            var bytes = new Uint8Array(RR[0].P_IMG);
                                            var len = bytes.byteLength;
                                            for (var j = 0; j < len; j++) {
                                                binary += String.fromCharCode(bytes[j]);
                                            }
                                        }
                                    });
                                }
                                Table_HTML +=
                                    '<tr><td>' + String(response[i].CUSTOMER_S_NAME ?? "") +
                                    '</td><td>' + String(response[i].IVAN_TYPE ?? "") +
                                    '</td><td>' + String(response[i].USD_P ?? "") +
                                    '</td><td>' + String(response[i].TWD_P ?? "") +
                                    (((response[i].Change_Log ?? "").length > 0) ? ('<br /><span style="color:blue;" title="' + (response[i].Change_Log ?? "") + '">移入檢視變更記錄</sapn>') : '') +
                                    '</td><td class="DIMG" style="text-align:center;">' +
                                    ((response[i].Has_IMG) ? ('<img src="data:image/png;base64,' + window.btoa(binary) + '" />') : ('<%=Resources.Cost.Image_NotExists%>')) +
                                    '</td><td class="For_U" style="display:none;">' +
                                    '<textarea class="U_Element" style="width:300px;" maxlength="50" title="Max Length 50 words.">' + String(response[i].Apply_Reason ?? "") + '</textarea>' +
                                    '</td><td>' + String(response[i].CURR_TYPE ?? "") +
                                    '</td><td>' + String(response[i].FOR_P ?? "") +
                                    '</td><td>' + String(response[i].MIN ?? "") +
                                    '</td><td>' + String(response[i].PROD_INT ?? "") +
                                    '</td><td>' + String(response[i].UNIT ?? "") +
                                    '</td><td>' + String(response[i].COM_NO ?? "") +
                                    '</td><td>' + String(response[i].COM_S_NAME ?? "") +
                                    '</td><td>' + String(response[i].CUST_NO ?? "") +
                                    '</td><td class="SEQ">' + String(response[i].SEQ ?? "") +
                                    '</td><td>' + String(response[i].UPDATE_USER ?? "") +
                                    '</td><td>' + String(response[i].UPDATE_DATE ?? "") +
                                    '</td></tr>';
                            });

                            Table_HTML += '</tbody>';
                            $('#Table_Search_Quote').html(Table_HTML);
                            $('.DIMG').toggle(!$('#RB_DV_DIMG').prop('checked'));
                            $('#Table_Search_Quote_info').text('Showing ' + $('#Table_Search_Quote > tbody tr').length + ' entries');

                            $('#Table_Search_Quote').css('white-space', 'nowrap');
                            $('#Table_Search_Quote thead th').css('text-align', 'center');

                            var $table = $('#Table_Search_Quote'),
                                $bodyCells = $table.find('tbody tr:first').children(),
                                colWidth;

                            // Get the tbody columns width array
                            colWidth = $bodyCells.map(function () {
                                return $(this).width();
                            }).get();

                            $('#Table_Search_Quote thead tr').children().each(function (i, v) {
                                $(v).width(colWidth[i]);
                            });    --%>

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
                                "language": {
                                    "lengthMenu": "&nbsp;Show _MENU_ entries"
                                },
                                "scrollX": true,
                                "scrollY": "62vh",
                                "searching": false,
                                "paging": false,
                                "ordering": false,
                                "bInfo": false //顯示幾筆隱藏
                            });

                           $('#Table_Exec_Data').DataTable({
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
                            $('#Table_Exec_Data').DataTable().draw();

                            $('#Table_Exec_Data').find('tbody tr').remove();
                        }
                    },
                    error: function (ex) {
                        alert(ex);
                    }
                });
            };

            $('#BT_Next').on('click', function () {
                Edit_Mode = "Edit";
                Form_Mode_Change("Review_Data");
            });
            
            $('#BT_Fill_Reason').on('click', function () {
                if (confirm('<%=Resources.Cost.Confirm_Fill_Reason%>')) {
                    $('.U_Element').val($('#TB_ALL_Reason').val());
                }
            });

            $('#BT_Save').on('click', function () {
                if (confirm("<%=Resources.MP.Save_Alert%>")) {
                    $('#Table_Exec_Data tbody tr').each(function () {
                        console.warn('SEQ: ' + $(this).find('.SEQ').text() + ', Reason: ' + $(this).find('.U_Element').val());
                        $.ajax({
                            url: "/Cost/Cost_Save.ashx",
                            data: {
                                "SEQ":$(this).find('.SEQ').text(),
                                "Reason": $(this).find('.U_Element').val(),
                                "Call_Type": "Cost_Apply"
                            },
                            cache: false,
                            type: "POST",
                            async: false,
                            datatype: "json",
                            contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                            success: function (response) {
                                Edit_Mode = "Save";
                                Form_Mode_Change("Base");
                            },
                            error: function (ex) {
                                alert(ex);
                                return false;
                            }
                        });
                    });
                    alert("<%=Resources.MP.Add_Success%>");
                }
            });

            function Item_Move(click_tr, ToTable, FromTable, Full) {
                if (Edit_Mode == "Can_Move") {
                    if (ToTable.find('tbody tr').length === 0) {
                        ToTable.html(FromTable.find('thead').clone());
                        ToTable.append('<tbody></tbody>');
                        ToTable.find('thead th').css('text-align', 'center');
                        ToTable.css('white-space', 'nowrap');
                    }
                    if (Full) {
                        ToTable.find('tbody').append(FromTable.find('tbody tr').clone());
                        FromTable.find('tbody tr').remove();
                    }
                    else {
                        //ToTable.DataTable().row.add(click_tr);
                        //FromTable.DataTable().row(click_tr).remove();
                        ToTable.append(click_tr.clone());
                        click_tr.remove();
                    }
               
                    $('#Table_Exec_Data_info').text('Showing ' + $('#Table_Exec_Data > tbody tr').length + ' entries');
                    $('#Table_Search_Quote_info').text('Showing ' + $('#Table_Search_Quote > tbody tr').length + ' entries');
                    $('#BT_Next').toggle(Boolean($('#Table_Exec_Data').find('tbody tr').length > 0));

                    //FromTable.DataTable().draw();
                    //ToTable.DataTable().draw();
                }
            }
            $('#Table_Search_Quote').on('click', 'tbody tr', function () {
                Item_Move($(this), $('#Table_Exec_Data'), $('#Table_Search_Quote'), false);
            });
            $('#Table_Exec_Data').on('click', 'tbody tr', function () {
                Item_Move($(this), $('#Table_Search_Quote'), $('#Table_Exec_Data'), false);
            });
            $('#BT_ATR').on('click', function () {
                Item_Move($(this), $('#Table_Exec_Data'), $('#Table_Search_Quote'), true);
            });
            $('#BT_ATL').on('click', function () {
                Item_Move($(this), $('#Table_Search_Quote'), $('#Table_Exec_Data'), true);
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
                    <input id="CUST_NO" autocomplete="off" class="textbox_char_200" />
                </td>
                <td class="tdhstyle">客戶簡稱</td>
                <td class="tdbstyle">
                    <input id="CUST_S_NAME" autocomplete="off" class="textbox_char_200" />
                </td>
            </tr>
            <tr class="trstyle">
                <td class="tdhstyle">頤坊型號</td>
                <td class="tdbstyle">
                    <input id="IVAN_TYPE" autocomplete="off" class="textbox_char_200" />
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
            <tr class="trstyle">
                <td class="tdtstyleLeft" colspan="4">
                    <input id="RB_DV_DIMG" type="radio" name="DIMG" checked="checked" onclick="$('.DIMG').css('display', 'none');" />
                    <label for="RB_DV_DIMG"><%=Resources.BOM.Not_Show_Image%></label>
                    <input id="RB_V_DIMG" type="radio" name="DIMG" onclick="$('.DIMG').css('display', '');$('.DIMG img').css('height', '');" />
                    <label for="RB_V_DIMG"><%=Resources.BOM.Show_Original_Image%></label>
                    <input id="RB_SM_DIMG" type="radio" name="DIMG" onclick="$('.DIMG').css('display', '');$('.DIMG img').css('height', '100px');" />
                    <label for="RB_SM_DIMG"><%=Resources.BOM.Show_Small_Image%></label>
                </td>
            </tr>
        </table>
        </div>
    
    
        <div class="button_change_section">
            &nbsp;
            <input type="button" class="V_BT" value="選擇" onclick="$('.Div_D').css('display','none');$('#Div_Basic2').css('display','');" disabled="disabled" />
            <input type="button" class="V_BT" IVMD_PERMISSIONS="1" value="報價內容" onclick="$('.Div_D').css('display','none');$('#Div_TW_Customs_Clearance').css('display','');" />
            <input type="button" class="V_BT" IVMD_PERMISSIONS="2" value="報表" onclick="$('.Div_D').css('display','none');$('#Div_HK_Customs_Clearance').css('display','');" />
            <input type="button" class="V_BT" value="圖例" onclick="$('.Div_D').css('display','none');$('#Div_Marks').css('display','');" />
        </div>

        <div id="Div_DT_View" style=" border-style:solid;border-width:1px; display: none;float:left;">
                <div class="dataTables_info" id="Table_Search_Quote_info" role="status" aria-live="polite"></div>
                <table id="Table_Search_Quote" class="Table_Search table table-striped table-bordered">
                    <thead style="white-space:nowrap"></thead>
                    <tbody style="white-space:nowrap"></tbody>
                </table>
            </div>
    
            <div id="Div_Exec_Data" style="border-style:solid;border-width:1px; display: none;float:right;">
                <div class="dataTables_info" id="Table_Exec_Data_info" role="status" aria-live="polite"></div>
                <div class="For_U" style="float:left;">
                    <textarea id="TB_ALL_Reason" style="width:300px;float:left;"></textarea>
                    &nbsp;&nbsp;<input type="button" id="BT_Fill_Reason" value="<%=Resources.Cost.Batch_Update_Reason%>" style="height:54px;background-color: cadetblue;padding: 8px 10px;border-radius: 10px;" />
                </div>
                <table id="Table_Exec_Data" style="width: 100%;" class="Table_Exec_Data table table-striped table-bordered">
                    <thead style="white-space:nowrap"></thead>
                    <tbody style="white-space:nowrap"></tbody>
                </table>
            </div>
    
            <div style="width:5%; float:right;margin:0 auto;text-align:center;height:80vh;">
                <table style="width:100%;height:100%;">
                    <tr>
                        <td style="width:100%;height:100%;vertical-align:middle;">
                            <input id="BT_ATR" type="button" value=">>" class="BTN_Green" style="display:none;" />
                            <br /><br />
                            <input id="BT_ATL" type="button" value="<<" class="BTN_Green" style="display:none;" />
                            <br /><br />
                            <input id="BT_Next" type="button" value="Next" style="inline-size:100%;display:none;" class="BTN" />
                        </td>
                    </tr>
                </table>
            </div>
    </div>
</asp:Content>
