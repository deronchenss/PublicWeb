<%@ Page Title="Cost Approve" Language="C#" MasterPageFile="~/MP.master" AutoEventWireup="true" CodeFile="Cost_Approve.aspx.cs" Inherits="Cost_Cost_Approve" %>
<%@ Register TagPrefix="uc1" TagName="uc1" Src="~/User_Control/Dia_Duo_Datetime_Picker.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <link href="/css/dataTables.bootstrap4.min.css" rel="stylesheet" />
    <script src="/js/jquery.dataTables.min.js"></script>
    <script src="/js/dataTables.bootstrap4.min.js"></script>

    <script type="text/javascript">
        $(document).ready(function () {
            var Edit_Mode;
            var IMG_Has_Read = false;
            //隱藏滾動卷軸
            document.body.style.overflow = 'hidden';

            $('#TB_Date_S').val($.datepicker.formatDate('yy-mm-dd', new Date(new Date().setDate(new Date().getDate() - 14)) ));
            $('#TB_Date_E').val($.datepicker.formatDate('yy-mm-dd', new Date()));

            window.document.body.onbeforeunload = function () {
                if (Edit_Mode === "Edit") {
                    return '您尚未將編輯過的表單資料送出，請問您確定要離開網頁嗎？';
                }
            }
            function Form_Mode_Change(Form_Mode) {
                switch (Form_Mode) {
                    case "Base":
                        $('#BT_Search, .For_S').css('display', '');
                        $('#BT_Cancel, #Div_DT_View, #Div_Data_Control, #Div_Exec_Data, #BT_Approve').css('display', 'none');
                        $('#RB_DV_DIMG').prop('checked', true);
                        $('input[type=radio][name=DIMG]').attr('disabled', 'disabled');
                        break;
                    case "Search":
                        $('#BT_Cancel, #Div_DT_View, #Div_Data_Control, #Div_Exec_Data').css('display', '');
                        $('#BT_Approve').css('display', 'none');
                        $('#Div_DT_View').css('width', '60%');
                        $('#Div_Exec_Data').css('width', '35%');
                        $('input[type=radio][name=DIMG]').attr('disabled', false);
                        break;
                    case "Review_Data":
                        $('#BT_Cancel, #Div_DT_View, #Div_Data_Control').css('display', 'none');
                        $('#BT_Approve').css('display', '');
                        $('#Div_Exec_Data').css('width', '100%');
                        break;
                }
            }

            $('#BT_Search').on('click', function () {
                Edit_Mode = "Can_Move";
                Form_Mode_Change("Search");
                Search_Cost();
            });

            $('#BT_Cancel').on('click', function () {
                Edit_Mode = "Base";
                Form_Mode_Change("Base");
            });

            $('#BT_Re_Select').on('click', function () {
                Edit_Mode = "Can_Move";
                Form_Mode_Change("Search");
            });

            function Search_Cost(Search_Where) {
                $.ajax({
                    url: "/Page/Base/Cost/Cost_Search.ashx",
                    data: {
                        "Call_Type": "Cost_Apply_Search",
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
                                + '</th><th>' + '<%=Resources.MP.Developing%>'
                                + '</th><th>' + '<%=Resources.MP.Supplier_Short_Name%>'
                                + '</th><th>' + '<%=Resources.MP.Ivan_Model%>'
                                + '</th><th>' + '<%=Resources.MP.Supplier_Model%>'
                                + '</th><th>' + '<%=Resources.MP.Sale_Model%>'
                                + '</th><th>' + '<%=Resources.MP.Product_Status%>'
                                + '</th><th>' + '<%=Resources.MP.Product_Information%>'
                                + '</th><th class="DIMG">' + '<%=Resources.MP.Image%>'
                                + '</th><th>' + '<%=Resources.MP.Apply_Reason%>'
                                + '</th><th>' + '<%=Resources.MP.Unit%>'
                                + '</th><th>' + '<%=Resources.MP.Price_TWD%>'
                                + '</th><th>' + '<%=Resources.MP.Price_USD%>'
                                + '</th><th>' + '<%=Resources.MP.Currency%>'
                                + '</th><th>' + '<%=Resources.MP.Price_Curr%>'
                                + '</th><th>' + 'MSRP'
                                + '</th><th>' + 'Cost'
                                + '</th><th>' + 'GP'
                                + '</th><th>' + '<%=Resources.MP.Last_Price_Day%>'
                                + '</th><th>' + '<%=Resources.MP.Supplier_No%>'
                                + '</th><th>' + '<%=Resources.MP.SEQ%>'
                                + '</th><th>' + '<%=Resources.MP.Update_User%>'
                                + '</th><th>' + '<%=Resources.MP.Update_Date%>'
                                + '</th></tr></thead><tbody>';

                            $(response).each(function (i) {
                                Table_HTML +=
                                    '<tr><td>' + String(response[i].DVN ?? "") +
                                    '</td><td>' + String(response[i].S_SName ?? "") +
                                    '</td><td>' + String(response[i].IM ?? "") +
                                    '</td><td>' + String(response[i].SM ?? "") +
                                    '</td><td>' + String(response[i].SaleM ?? "") +
                                    '</td><td>' + String(response[i].PS ?? "") +
                                    '</td><td>' + String(response[i].PI ?? "") +
                                    (((response[i].Change_Log ?? "").length > 0) ? ('<br /><span style="color:blue;" title="' + (response[i].Change_Log ?? "") + '">移入檢視變更記錄</sapn>') : '') +
                                    '</td><td class="DIMG" style="text-align:center;">' +
                                    ((response[i].Has_IMG) ? ('<img type="Product" SEQ="' + String(response[i].SEQ ?? "") + '" />') : ('<%=Resources.MP.Image_NotExists%>')) +
                                    '</td><td>' + String(response[i].Apply_Reason ?? "") + 
                                    '</td><td>' + String(response[i].Unit ?? "") +
                                    '</td><td style="text-align:right;">' + ((response[i].TWD_P != 0) ? String(response[i].TWD_P ?? "") : "") +
                                    '</td><td style="text-align:right;">' + ((response[i].USD_P != 0) ? String(response[i].USD_P ?? "") : "")  +
                                    '</td><td>' + String(response[i].Curr ?? "") +
                                    '</td><td style="text-align:right;">' + ((response[i].Curr_P != 0) ? String(response[i].Curr_P ?? ""): "")  +
                                    '</td><td style="text-align:right;">' + ((response[i].MSRP != 0) ? String(response[i].MSRP ?? ""): "")  +
                                    '</td><td style="text-align:right;">' + ((response[i].Cost != 0) ? String(response[i].Cost ?? ""): "")  +
                                    '</td><td style="text-align:right;">' + ((response[i].GP != 0) ? String(response[i].GP ?? "") : "") +
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
                            IMG_Has_Read = false;//初始化IMG讀取

                            $('#Table_Search_Cost').css('white-space', 'nowrap');
                            $('#Table_Search_Cost thead th').css('text-align', 'center');


                            //$('#Table_Exec_Data_info').text('');
                            //$('#Table_Exec_Data').html('');
                        }
                    },
                    error: function (ex) {
                        alert(ex);
                    }
                });
            };

            $('input[type=radio][name=DIMG]').on('click', function () {
                var Show_IMG = false;
                $('.DIMG').toggle(!$('#RB_DV_DIMG').prop('checked'));

                switch ($(this).prop('id')) {
                    case "RB_DV_DIMG":
                        break;
                    case "RB_V_DIMG":
                        Show_IMG = true;
                        $('.DIMG img').css({ 'max-height': '', 'max-width': '' });
                        break;
                    case "RB_SM_DIMG":
                        Show_IMG = true;
                        $('.DIMG img').css({ 'max-height': '100px', 'max-width': '100px' });
                        break;
                }
                if (Show_IMG && !IMG_Has_Read) {//Need Show And Not Read Data
                    $('img[type=Product]').each(function (i) {
                        var IMG_SEL = $(this);
                        var binary = '';
                        $.ajax({
                            url: "/Page/Base/BOM/BOM_Search.ashx",
                            data: {
                                "Call_Type": "GET_IMG",
                                "SUPLU_SEQ": $(this).attr('SEQ')//response[i].SEQ
                            },
                            cache: false,
                            type: "POST",
                            datatype: "json",
                            contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                            success: function (RR) {
                                var bytes = new Uint8Array(RR[0].P_IMG);
                                var len = bytes.byteLength;
                                for (var j = 0; j < len; j++) {
                                    binary += String.fromCharCode(bytes[j]);
                                }
                                var SRC = 'data:image/png;base64,' + window.btoa(binary);
                                IMG_SEL.attr('src', SRC);
                            }
                        });
                    });
                    IMG_Has_Read = true;
                }
            });

            $('#BT_Next').on('click', function () {
                Edit_Mode = "Edit";
                Form_Mode_Change("Review_Data");
            });

            $('#BT_Approve').on('click', function () {
                $('#Table_Exec_Data tbody tr').each(function () {
                    $.ajax({
                        url: "/Page/Base/Cost/Cost_Save.ashx",
                        data: {
                            "SEQ": $(this).find('.SEQ').text(),
                            "Update_User": "<%=(Session["Account"] == null) ? "Ivan10" : Session["Account"].ToString().Trim() %>",
                            "Call_Type": "Cost_Approve"
                        },
                        cache: false,
                        type: "POST",
                        async: false,
                        datatype: "json",
                        contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                        success: function (response) {
                            $('#Table_Exec_Data').html('');
                            $('#Table_Exec_Data_info').text('Showing 0 entries');
                            Edit_Mode = "Can_Move";
                            Form_Mode_Change("Search");
                            Search_Cost();
                        },
                        error: function (ex) {
                            alert(ex);
                            return false;
                        }
                    });
                });
                alert('核准完成');
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
                        FromTable.find('.SEQ').each(function () {
                            var OT = $(this).text();
                            if (ToTable.find('.SEQ').filter(function () { return $(this).text() == OT; }).length === 0) {
                                ToTable.append($(this).parent().clone());
                            }
                            else {
                                console.warn($(this));
                            }
                            $(this).parent().remove();
                        });
                    }
                    else {
                        click_tr.remove();
                        if (ToTable.find('.SEQ').filter(function () { return $(this).text() == click_tr.find('.SEQ').text(); }).length === 0) {
                            ToTable.append(click_tr.clone());
                        }
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
      
        table thead tr th {
            background-color:white;
            position: sticky;
            top: 0; /* 列首永遠固定於上 */
        }
    </style>
    <uc1:uc1 ID="uc1" runat="server" /> 

    <table class="table_th" style="text-align: left;">
        <tr><td style="height:5px;"></td></tr>
        <tr class="For_S">
            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Ivan_Model%></td>
            <td style="text-align: left; width: 15%;">
                <input id="TB_IM" autocomplete="off" style="width: 100%;" />
            </td>
            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Update_Date%></td>
            <td style="text-align: left; width: 15%;">
                <div style="width: 90%; float: left; z-index: -10;">
                    <input id="TB_Date_S" class="TB_DS" type="date" style="width: 50%;" /><input id="TB_Date_E" type="date" class="TB_DE" style="width: 50%;" />
                </div>
                <div style="width: 10%; float: right; z-index: 10;">
                    <input id="BT_Duo_Datetime_Picker" type="button" value="…" style="float: right; z-index: 10; width: 100%;" onclick="$('#Duo_Datetime_Picker_Dialog').dialog('open');" />
                </div>
            </td>
        </tr>
        <tr class="For_S">
            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Supplier_No%></td>
            <td style="text-align: left; width: 15%;">
                <input id="TB_S_No" autocomplete="off" style="width: 100%;" /><%--暫先不用ATC placeholder="<%=Resources.MP.S_No_ATC_Hint%>"--%>
            </td>
            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Developing%></td>
            <td style="text-align: left; width: 15%;">
                <select id="DDL_DVN">
                    <option selected="selected" value="R">申請中</option>
                    <option value="N">正式</option>
                    <option>ALL</option>
                </select>
            </td>
        </tr>
        <tr>
            <td class="tdtstyleRight" colspan="8">
                <input type="button" id="BT_Search" class="M_BT" value="<%=Resources.MP.Search%>" />
                <input type="button" id="BT_Approve" class="M_BT" value="<%=Resources.MP.Approve%>" style="display:none;" />
            </td>
        </tr>
        <tr>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
        </tr>
    </table>
    <div>&nbsp;&nbsp;&nbsp;&nbsp;
        <input id="RB_DV_DIMG" type="radio" name="DIMG" disabled="disabled" checked="checked" />
        <label for="RB_DV_DIMG"><%=Resources.MP.Not_Show_Image%></label>
        <input id="RB_V_DIMG" type="radio" name="DIMG" disabled="disabled" />
        <label for="RB_V_DIMG"><%=Resources.MP.Show_Original_Image%></label>
        <input id="RB_SM_DIMG" type="radio" name="DIMG" disabled="disabled" />
        <label for="RB_SM_DIMG"><%=Resources.MP.Show_Small_Image%></label>
    </div>
    <div style="width: 98%; margin: 0 auto;">
        <div id="Div_DT_View" style="width: 60%; height: 75vh; overflow: auto; display: none; float: left;border-style:solid;border-width:1px; ">
            <span class="dataTables_info" id="Table_Search_Cost_info" role="status" aria-live="polite"></span>
            <table id="Table_Search_Cost" style="width: 99%;" class="table table-striped table-bordered">
                <thead></thead>
                <tbody></tbody>
            </table>
        </div>

        <div id="Div_Data_Control" style="width: 5%; margin: 0 auto; text-align: center; height: 75vh; float: left; display: none;">
            <table style="width: 100%; height: 100%;">
                <tr>
                    <td style="width: 100%; height: 100%; vertical-align: middle;">
                        <input id="BT_ATR" type="button" value=">>" class="BTN_Green" />
                        <br />
                        <br />
                        <input id="BT_ATL" type="button" value="<<" class="BTN_Green" />
                        <br />
                        <br />
                        <input id="BT_Next" type="button" value="Next" style="inline-size: 100%; display: none;" class="BTN" />
                    </td>
                </tr>
            </table>
        </div>

        <div id="Div_Exec_Data" style="width: 35%; height: 75vh; overflow: auto; display: none; float: right;border-style:solid;border-width:1px; ">
            <span class="dataTables_info" id="Table_Exec_Data_info" role="status" aria-live="polite"></span>
            <table id="Table_Exec_Data" style="width: 100%;" class="table table-striped table-bordered">
                <thead></thead>
                <tbody></tbody>
            </table>
        </div>
    </div>
    
    <br />
    <br />
</asp:Content>

