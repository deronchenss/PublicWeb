<%@ Page Title="Cost Approve" Language="C#" MasterPageFile="~/MP.master" AutoEventWireup="true" CodeFile="Cost_Approve.aspx.cs" Inherits="Cost_Cost_Approve" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

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
                        $('#BT_Re_Select, #BT_Approve').css('display', 'none');
                        $('.For_S').css('display', '');
                        break;
                    case "Search":
                        $('#BT_Cancel').css('display', '');
                        $('#BT_Search').css('display', 'none');
                        $('#Div_DT_View, #Div_Exec_Data').css('display', '');
                        $('#Div_DT_View').css('width', '60%');
                        $('#Div_Exec_Data').css('width', '35%');
                        $('#BT_ATR, #BT_ATL').css('display', '');
                        $('#BT_Re_Select, #BT_Approve').css('display', 'none');
                        $('.For_S').css('display', 'none');
                        break;
                    case "Review_Data":
                        $('#BT_Cancel').css('display', 'none');
                        $('#Div_DT_View').css('display', 'none');
                        $('#Div_Exec_Data').css('width', '100%');
                        $('#BT_Re_Select, #BT_Approve').css('display', '');
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
                    url: "/Cost/Cost_Search.ashx",
                    data: {
                        "Call_Type": "Copy_Apply_Search",
                        "IM": $('#TB_IM').val(),
                        "S_No": $('#TB_S_No').val(),
                        "Date_S": $('#TB_Date_S').val(),
                        "Date_E": $('#TB_Date_E').val(),
                        "DVN": $('#DDL_DVN').val(),
                        "Search_Where": Search_Where ?? ""
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

                            var Table_HTML =
                                '<thead><tr>'
                                + '</th><th>' + '<%=Resources.Cost.Developing%>'
                                + '</th><th>' + '<%=Resources.Cost.Supplier_Short_Name%>'
                                + '</th><th>' + '<%=Resources.Cost.Ivan_Model%>'
                                + '</th><th>' + '<%=Resources.Cost.Product_Information%>'
                                + '</th><th class="DIMG">' + '<%=Resources.BOM.PD_IMG%>'
                                + '</th><th>' + '<%=Resources.Cost.Apply_Reason%>'
                                + '</th><th>' + '<%=Resources.Cost.Unit%>'
                                + '</th><th>' + '<%=Resources.Cost.Price_TWD%>'
                                + '</th><th>' + '<%=Resources.Cost.Price_USD%>'
                                + '</th><th>' + '<%=Resources.Cost.Currency%>'
                                + '</th><th>' + '<%=Resources.Cost.Price_Curr%>'
                                + '</th><th>' + 'MSRP'
                                + '</th><th>' + '<%=Resources.Cost.Last_Price_Day%>'
                                + '</th><th>' + '<%=Resources.Cost.Supplier_No%>'
                                + '</th><th>' + '<%=Resources.Cost.SEQ%>'
                                + '</th><th>' + '<%=Resources.Cost.Update_User%>'
                                + '</th><th>' + '<%=Resources.Cost.Update_Date%>'
                                + '</th></tr></thead><tbody>';

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
                                    '<tr><td>' + String(response[i].DVN ?? "") +
                                    '</td><td>' + String(response[i].S_SName ?? "") +
                                    '</td><td>' + String(response[i].IM ?? "") +
                                    '</td><td>' + String(response[i].PI ?? "") +
                                        (((response[i].Change_Log ?? "").length > 0) ? ('<br /><span style="color:blue;" title="' + (response[i].Change_Log ?? "") + '">移入檢視變更記錄</sapn>') : '') +
                                    '</td><td class="DIMG" style="text-align:center;">' +
                                    ((response[i].Has_IMG) ? ('<img src="data:image/png;base64,' + window.btoa(binary) + '" />') : ('<%=Resources.Cost.Image_NotExists%>')) +
                                    //'</td><td title="XXXXX">' + String(response[i].change_ ?? "") +
                                    '</td><td>' + String(response[i].Apply_Reason ?? "") + 
                                    '</td><td>' + String(response[i].Unit ?? "") +
                                    '</td><td>' + String(response[i].TWD_P ?? "") +
                                    '</td><td>' + String(response[i].USD_P ?? "") +
                                    '</td><td>' + String(response[i].Curr ?? "") +
                                    '</td><td>' + String(response[i].Curr_P ?? "") +
                                    '</td><td>' + String(response[i].MSRP ?? "") +
                                    '</td><td>' + String(response[i].LSTP_Day ?? "") +
                                    '</td><td>' + String(response[i].S_No ?? "") +
                                    '</td><td class="SEQ">' + String(response[i].SEQ ?? "") +
                                    '</td><td>' + String(response[i].Update_User ?? "") +
                                    '</td><td>' + String(response[i].Update_Date ?? "") +
                                    '</td></tr>';
                            });

                            Table_HTML += '</tbody>';
                            $('#Table_Search_Cost').html(Table_HTML);
                            $('.DIMG').toggle(!$('#RB_DV_DIMG').prop('checked'));
                            $('#Table_Search_Cost_info').text('Showing ' + $('#Table_Search_Cost > tbody tr').length + ' entries');

                            $('#Table_Search_Cost').css('white-space', 'nowrap');
                            $('#Table_Search_Cost thead th').css('text-align', 'center');

                            $('#Table_Exec_Data_info').text('');
                            $('#Table_Exec_Data').html('');
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
            
            $('#BT_Approve').on('click', function () {
                if (confirm("確認要核准以下資料嗎？")) {
                    $('#Table_Exec_Data tbody tr').each(function () {
                        $.ajax({
                            url: "/Cost/Cost_Save.ashx",
                            data: {
                                "SEQ":$(this).find('.SEQ').text(),
                                "Call_Type": "Cost_Approve"
                            },
                            cache: false,
                            type: "POST",
                            async: false,
                            datatype: "json",
                            contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                            success: function (response) {
                                Edit_Mode = "Approve";
                                Form_Mode_Change("Base");
                                console.warn(response);
                            },
                            error: function (ex) {
                                alert(ex);
                                return false;
                            }
                        });
                    });
                    alert('核准完成');
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
                        ToTable.append(click_tr.clone());
                        click_tr.remove();
                    }

                    if (FromTable.find('tbody tr').length === 0) {
                        FromTable.html('');
                    }
                    $('#Table_Exec_Data_info').text('Showing ' + $('#Table_Exec_Data > tbody tr').length + ' entries');
                    $('#Table_Search_Cost_info').text('Showing ' + $('#Table_Search_Cost > tbody tr').length + ' entries');

                    $('#BT_Next').toggle(Boolean($('#Table_Exec_Data').find('tbody tr').length > 0));
                }
            }
            $('#Table_Search_Cost').on('click', 'tbody tr', function () {
                Item_Move($(this), $('#Table_Exec_Data'), $('#Table_Search_Cost'), false);
            });
            $('#Table_Exec_Data').on('click', 'tbody tr', function () {
                Item_Move($(this), $('#Table_Search_Cost'), $('#Table_Exec_Data'), false);
            });
            $('#BT_ATR').on('click', function () {
                Item_Move($(this), $('#Table_Exec_Data'), $('#Table_Search_Cost'), true);
            });
            $('#BT_ATL').on('click', function () {
                Item_Move($(this), $('#Table_Search_Cost'), $('#Table_Exec_Data'),  true);
            });
        });
    </script>

    <style type="text/css">
        .M_BT {
            background-color: azure;
            font-weight: bold;
            border: none;
            cursor: pointer;
            font-size: large;
            text-align: center;
            text-decoration: none;
        }
            .M_BT:hover {
                background-color: #f8981d;
                color: white;
            }
        #Table_Search_Cost tbody tr:hover, #Table_Exec_Data tbody tr:hover{
            background-color: #f8981d;
            color: white;
        }
        .BTN_Green {
            color: white;
            border-radius: 4px;
            border:5px blue none;
            text-shadow: 0 1px 1px rgba(0, 0, 0, 0.2);
            background: rgb(28, 184, 65);
        }
        .BTN_Green:hover {
            opacity: 0.8;
        }
        .U_Element:hover {
            opacity: 0.8;
        }
    </style>

    <table class="table_th" style="text-align: left;">
        <tr>
            <td style="height: 10px; font-size: smaller;" colspan="8">&nbsp</td>
        </tr>
        <tr class="For_S">
            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Ivan_Model%></td>
            <td style="text-align: left; width: 15%;">
                <input id="TB_IM" autocomplete="off" style="width: 100%;" />
            </td>
            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Update_Date%></td>
            <td style="text-align: left; width: 15%;">
                <input id="TB_Date_S" type="date" style="width: 50%;" /><input id="TB_Date_E" type="date" style="width: 50%;" />
            </td>
        </tr>
        <tr class="For_S">
            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Supplier_No%></td>
            <td style="text-align: left; width: 15%;">
                <input id="TB_S_No" autocomplete="off" style="width: 100%;" /><%--暫先不用ATC placeholder="<%=Resources.MP.S_No_ATC_Hint%>"--%>
            </td>
            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Developing%></td>
            <td style="text-align: left; width: 15%;">
                <select id="DDL_DVN">
                    <option selected="selected" value="R">申請中</option>
                    <option value="N">正式</option>
                    <option>ALL</option>
                </select>
            </td>
        </tr>
        <tr>
            <td style="height: 10px; font-size: smaller;" colspan="8">&nbsp</td>
        </tr>
        <tr>
            <td></td>
            <td></td>
            <td></td>
            <td style="width: 10%;">
                <input type="button" id="BT_Search" class="M_BT" value="<%=Resources.MP.Search%>" />
            </td>
            <td style="width: 10%;">
                <input type="button" id="BT_Cancel" class="M_BT" value="<%=Resources.MP.Cancel%>" style="display: none;" />
            </td>
            <td style="width: 10%;">
                <input type="button" id="BT_Re_Select" class="M_BT" value="<%=Resources.Cost.Re_Selet%>" style="display:none;" />
            </td>
            <td style="width: 10%;">
                <input type="button" id="BT_Approve" class="M_BT" value="<%=Resources.MP.Approve%>" style="display:none;" />
            </td>
            <td style="width: 80%;"></td>
        </tr>
        <tr>
            <td style="height: 10px; font-size: smaller;" colspan="8">&nbsp</td>
        </tr>
        <tr>
            <td colspan="8">
                <input id="RB_DV_DIMG" type="radio" name="DIMG" checked="checked" onclick="$('.DIMG').css('display', 'none');" />
                <label for="RB_DV_DIMG"><%=Resources.BOM.Not_Show_Image%></label>
                <input id="RB_V_DIMG" type="radio" name="DIMG" onclick="$('.DIMG').css('display', '');$('.DIMG img').css('height', '');" />
                <label for="RB_V_DIMG"><%=Resources.BOM.Show_Original_Image%></label>
                <input id="RB_SM_DIMG" type="radio" name="DIMG" onclick="$('.DIMG').css('display', '');$('.DIMG img').css('height', '100px');" />
                <label for="RB_SM_DIMG"><%=Resources.BOM.Show_Small_Image%></label>
            </td>
        </tr>
    </table>
    
    <div id="Div_DT_View" style="width: 60%; height:80vh; overflow: auto; display: none;float:left;">
        <div class="dataTables_info" id="Table_Search_Cost_info" role="status" aria-live="polite"></div>
        <table id="Table_Search_Cost" style="width: 100%;" class="table table-striped table-bordered">
            <thead></thead>
            <tbody></tbody>
        </table>
    </div>
    
    <div id="Div_Exec_Data" style="width: 35%; height:80vh; overflow: auto; display: none;float:right;">
        <div class="dataTables_info" id="Table_Exec_Data_info" role="status" aria-live="polite"></div>
        <table id="Table_Exec_Data" style="width: 100%;" class="table table-striped table-bordered">
            <thead></thead>
            <tbody></tbody>
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

    <br />
    <br />
</asp:Content>

