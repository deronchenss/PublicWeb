<%@ Page Title="Cost Class Maintain" Language="C#" MasterPageFile="~/MP.master" AutoEventWireup="true" CodeFile="Cost_Class.aspx.cs" Inherits="Cost_Cost_Class" %>
<%@ Register TagPrefix="uc1" TagName="uc1" Src="~/User_Control/Dia_Supplier_Selector.ascx" %>
<%@ Register TagPrefix="uc2" TagName="uc2" Src="~/User_Control/Dia_Product_ALL.ascx" %>
<%@ Register TagPrefix="uc3" TagName="uc3" Src="~/User_Control/Dia_Duo_Datetime_Picker.ascx" %>

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
            DDL();

            $('#BT_Product_Selector').on('click', function () {
                $("#Search_Supplier_Dialog").dialog('open');
            });

            //Today_DSDE
            //Clear_DSDE

            function Re_Bind_Inner_JS() {
                $('.Call_Product_Tool').off('click');
                $('.Call_Product_Tool').on('click', function (e) {
                    e.stopPropagation();
                    $('#PAD_HDN_SUPLU_SEQ').val($(this).attr('SUPLU_SEQ'));
                    $("#Product_ALL_Dialog").dialog('open');
                });
            };

            $('#TB_S_No').on('change', function () {
                $('#TB_S_SName').val('');
            });

            $('#SSD_Table_Supplier').on('click', '.SUP_SEL', function () {
                $('#TB_S_No').val($(this).parent().parent().find('td:nth(2)').text());
                $('#TB_S_SName').val($(this).parent().parent().find('td:nth(3)').text());
                $("#Search_Supplier_Dialog").dialog('close');
            });

            window.document.body.onbeforeunload = function () {
                if (Edit_Mode === "Edit") {
                    return '您尚未將編輯過的表單資料送出，請問您確定要離開網頁嗎？';
                }
            }
            function Form_Mode_Change(Form_Mode) {
                switch (Form_Mode) {
                    case "Base":
                        $('#BT_Search, .For_S').css('display', '');
                        //$('#BT_Cancel, #Div_DT_View, #Div_Data_Control, #Div_Exec_Data, #BT_Re_Select, #BT_Save, .For_U').css('display', 'none');
                        $('#Div_DT_View, #Div_Data_Control, #Div_Exec_Data, #BT_Save, .For_U').css('display', 'none');
                        $('#RB_DV_DIMG').prop('checked', true);
                        $('input[type=radio][name=DIMG]').attr('disabled', 'disabled');
                        break;
                    case "Search":
                        //$('#BT_Cancel, #Div_DT_View, #Div_Data_Control, #Div_Exec_Data').css('display', '');
                        $('#Div_DT_View, #Div_Data_Control, #Div_Exec_Data').css('display', '');
                        //$('#BT_Re_Select, #BT_Save, .For_U').css('display', 'none');
                        $('#BT_Save, .For_U').css('display', 'none');
                        $('#Div_DT_View').css('width', '60%');
                        $('#Div_Exec_Data').css('width', '35%');
                        $('input[type=radio][name=DIMG]').attr('disabled', false);
                        break;
                    case "Review_Data":
                        //$('#BT_Cancel, #Div_DT_View, #Div_Data_Control').css('display', 'none');
                        $('#Div_DT_View, #Div_Data_Control').css('display', 'none');
                        //$('#BT_Re_Select, #BT_Save, .For_U').css('display', '');
                        $('#BT_Save, .For_U').css('display', '');
                        $('#Div_Exec_Data').css('width', '100%');
                        break;
                }
            }

            $('#BT_Search').on('click', function () {
                Edit_Mode = "Can_Move";
                Form_Mode_Change("Search");
                Search_Cost();
            });

            //$('#BT_Cancel').on('click', function () {
            //    Edit_Mode = "Base";
            //    Form_Mode_Change("Base");
            //});

            //$('#BT_Re_Select').on('click', function () {
            //    Edit_Mode = "Can_Move";
            //    Form_Mode_Change("Search");
            //});

            function Search_Cost(Search_Where) {
                $.ajax({
                    url: "/Page/Base/Cost/New_Cost_Search.ashx",
                    data: {
                        "Call_Type": "Cost_Class_Search",
                        "IM": $('#TB_IM').val(),
                        "PC": $('#DDL_PC').val(),
                        "Date_S": $('#TB_Date_S').val(),
                        "Date_E": $('#TB_Date_E').val(),
                        "S_No": $('#TB_S_No').val(),
                        "SaleM": $('#TB_SaleM').val(),
                        "PI": $('#TB_PI').val(),
                        "BigS": $('#DDL_BigS').val(),
                        "MSRP": $('#DDL_MSRP').val(),
                        "PC_NEX": $('#DDL_PC_NEX').val(),//Not_Exists
                        "NO_L": $('#CB_Not_Leather').prop('checked')
                    },
                    cache: false,
                    async: false,
                    type: "POST",
                    datatype: "json",
                    contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                    success: function (R) {
                        if (R.length === 0) {
                            alert('<%=Resources.MP.Data_Not_Exists_Alert%>');
                            Edit_Mode = "Base";
                            Form_Mode_Change("Base");
                        }
                        else {
                            var Table_HTML =
                                '<thead><tr>'
                                + '</th><th>' + '<%=Resources.MP.Ivan_Model%>'
                                + '</th><th>' + '<%=Resources.MP.Supplier_Model%>'
                                + '</th><th>' + '<%=Resources.MP.Sale_Model%>'
                                + '</th><th>' + '<%=Resources.MP.Supplier_Short_Name%>'
                                + '</th><th class="DIMG">' + '<%=Resources.MP.Image%>'
                                + '</th><th>' + '<%=Resources.MP.Unit%>'
                                + '</th><th>' + '<%=Resources.MP.Rank%>1'
                                + '</th><th>' + '<%=Resources.MP.Rank%>2'
                                + '</th><th>' + '<%=Resources.MP.Rank%>3'
                                + '</th><th>' + '<%=Resources.MP.Rank%>1_V3'
                                + '</th><th>' + '<%=Resources.MP.Rank%>2_V3'
                                + '</th><th>MSRP'
                                + '</th><th>' + '<%=Resources.MP.Product_Information%>'
                                + '</th><th>' + '<%=Resources.MP.Last_Order%>'
                                + '</th><th>' + '<%=Resources.MP.Location_1%><%=Resources.MP.Speace%><%=Resources.MP.Stock%>'
                                + '</th><th>' + '<%=Resources.MP.Location_2%><%=Resources.MP.Speace%><%=Resources.MP.Stock%>'
                                + '</th><th>' + '<%=Resources.MP.On_the_way_Stock%>'
                                + '</th><th>' + '<%=Resources.MP.Location_1%><%=Resources.MP.Speace%><%=Resources.MP.Safe_Stock%>'
                                + '</th><th>' + 'TPE<%=Resources.MP.Speace%><%=Resources.MP.Safe_Stock%>'
                                + '</th><th>' + 'ISP<%=Resources.MP.Speace%><%=Resources.MP.Safe_Stock%>'
                                + '</th><th>UN'
                                + '</th><th>' + '<%=Resources.MP.International_No%>'
                                + '</th><th>' + '<%=Resources.MP.Style%>'
                                + '</th><th>' + '<%=Resources.MP.Location_1_Area%>'
                                + '</th><th>' + '<%=Resources.MP.Supplier_No%>'
                                + '</th><th>' + '<%=Resources.MP.SEQ%>'
                                + '</th><th>' + '<%=Resources.MP.Update_User%>'
                                + '</th><th>' + '<%=Resources.MP.Update_Date%>'
                                + '</th></tr></thead><tbody>';
                            $(R).each(function (i) {
                                Table_HTML +=
                                    '<tr><td><input class="Call_Product_Tool" SUPLU_SEQ = "' + String(R[i].序號 ?? "")
                                    + '" type="button" value="' + String(R[i].頤坊型號 ?? "")
                                    + '" style="text-align:left;width:100%;z-index:1000;' + ((R[i].Has_IMG) ? 'background: #90ee90;' : '') + '" />' +
                                    '</td><td>' + String(R[i].廠商型號 ?? "") +
                                    '</td><td>' + String(R[i].銷售型號 ?? "") +
                                    '</td><td>' + String(R[i].廠商簡稱 ?? "") +
                                    '</td><td class="DIMG" style="text-align:center;">' +
                                    ((R[i].Has_IMG) ? ('<img type="Product" SEQ="' + String(R[i].序號 ?? "") + '" />') : ('<%=Resources.MP.Image_NotExists%>')) +
                                    '</td><td>' + String(R[i].單位 ?? "") +
                                    '</td><td class="PC1">' + String(R[i].產品一階 ?? "") +
                                    '</td><td class="PC2">' + String(R[i].產品二階 ?? "") +
                                    '</td><td class="PC3">' + String(R[i].產品三階 ?? "") +
                                    '</td><td>' + String(R[i].一階V3 ?? "") +
                                    '</td><td>' + String(R[i].二階V3 ?? "") +
                                    '</td><td>' + String(R[i].MSRP ?? "") +
                                    '</td><td>' + String(R[i].產品說明 ?? "") +
                                    '</td><td>' + String(R[i].最後接單 ?? "") +
                                    '</td><td style="text-align:right;">' + ((R[i].大貨庫存數 != 0) ? String(R[i].大貨庫存數 ?? "") : "") +
                                    '</td><td style="text-align:right;">' + ((R[i].分配庫存數 != 0) ? String(R[i].分配庫存數 ?? "") : "") +
                                    '</td><td>' + String(R[i].庫存在途 ?? "") +
                                    '</td><td style="text-align:right;">' + ((R[i].大貨安全數 != 0) ? String(R[i].大貨安全數 ?? "") : "") +
                                    '</td><td style="text-align:right;">' + ((R[i].台北安全數 != 0) ? String(R[i].台北安全數 ?? "") : "") +
                                    '</td><td style="text-align:right;">' + ((R[i].ISP安全數 != 0) ? String(R[i].ISP安全數 ?? "") : "") +
                                    '</td><td>' + String(R[i].UNActive ?? "") +
                                    '</td><td>' + String(R[i].國際條碼 ?? "") +
                                    '</td><td>' + String(R[i].樣式 ?? "") +
                                    '</td><td>' + String(R[i].大貨庫位 ?? "") +
                                    '</td><td>' + String(R[i].廠商編號 ?? "") +
                                    '</td><td class="SEQ">' + String(R[i].序號 ?? "") +
                                    '</td><td>' + String(R[i].更新人員 ?? "") +
                                    '</td><td>' + String(R[i].更新日期 ?? "") +
                                    '</td></tr>';
                            });

                            Table_HTML += '</tbody>';
                            $('#Table_Search_Cost').html(Table_HTML);

                            $('.DIMG').toggle(!$('#RB_DV_DIMG').prop('checked'));
                            $('#Table_Search_Cost_info').text('Showing ' + $('#Table_Search_Cost > tbody tr').length + ' entries');
                            IMG_Has_Read = false;//初始化IMG讀取

                            $('#Table_Search_Cost').css('white-space', 'nowrap');
                            $('#Table_Search_Cost thead th').css('text-align', 'center');

                            Re_Bind_Inner_JS();
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
            
            $('#DDL_SET_PC').on('change', function () {
                var NPC = $('#DDL_SET_PC').val().toString().trim();
                var SP_NPC = NPC.split('-');
                switch (SP_NPC.length - 1) {
                    case 1:
                        $('#Table_Exec_Data .PC1').text(SP_NPC[0]);
                        $('#Table_Exec_Data .PC2, #Table_Exec_Data .PC3').text('');
                        break;
                    case 2:
                        $('#Table_Exec_Data .PC1').text(SP_NPC[0]);
                        $('#Table_Exec_Data .PC2').text(SP_NPC[0] + '-' + SP_NPC[1]);
                        $('#Table_Exec_Data .PC3').text('');
                        break;
                    case 3:
                        $('#Table_Exec_Data .PC1').text(SP_NPC[0]);
                        $('#Table_Exec_Data .PC2').text(SP_NPC[0] + '-' + SP_NPC[1]);
                        $('#Table_Exec_Data .PC3').text(SP_NPC[0] + '-' + SP_NPC[1] + '-' + SP_NPC[2]);
                        break;
                }
                //console.warn(SP_NPC);
            });

            $('#BT_Save').on('click', function () {
                if ($('#DDL_SET_PC').val().length === 0) {
                    alert('Please select product-class.');
                }
                else {
                    $('#Table_Exec_Data tbody tr').each(function () {
                        console.warn('SEQ: ' + $(this).find('.SEQ').text() + ', SET_PC: ' + $('#DDL_SET_PC').val().toString().trim());
                        var NPC = $('#DDL_SET_PC').val().toString().trim();
                        var PC1, PC2, PC3;
                        var SP_NPC = NPC.split('-');
                        switch (SP_NPC.length - 1) {
                            case 1:
                                PC1 = SP_NPC[0];
                                PC2 = PC3 = '';
                                break;
                            case 2:
                                PC1 = SP_NPC[0];
                                PC2 = SP_NPC[0] + '-' + SP_NPC[1];
                                PC3 = '';
                                break;
                            case 3:
                                PC1 = SP_NPC[0];
                                PC2 = SP_NPC[0] + '-' + SP_NPC[1];
                                PC3 = SP_NPC[0] + '-' + SP_NPC[1] + '-' + SP_NPC[2];
                                break;
                        }
                        $.ajax({
                            url: "/Page/Base/Cost/Cost_Save.ashx",
                            data: {
                                "SEQ": $(this).find('.SEQ').text(),
                                "PC1": PC1,
                                "PC2": PC2,
                                "PC3": PC3,
                                "Update_User": "<%=(Session["Account"] == null) ? "Ivan10" : Session["Account"].ToString().Trim() %>",
                                "Call_Type": "Cost_Class"
                            },
                            cache: false,
                            type: "POST",
                            datatype: "json",
                            contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                            success: function (response) {
                                //console.warn(response);
                                $('#DDL_SET_PC').val('');
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
                        if (ToTable.find('.SEQ').filter(function () { return $(this).text() == click_tr.find('.SEQ').text(); }).length === 0) {
                            ToTable.append(click_tr.clone());
                        }
                        click_tr.remove();
                    }

                    if (FromTable.find('tbody tr').length === 0) {
                        FromTable.html('');
                    }
                    $('#Table_Exec_Data_info').text('Showing ' + $('#Table_Exec_Data > tbody tr').length + ' entries');
                    $('#Table_Search_Cost_info').text('Showing ' + $('#Table_Search_Cost > tbody tr').length + ' entries');

                    $('#BT_Next').toggle(Boolean($('#Table_Exec_Data').find('tbody tr').length > 0));
                    Re_Bind_Inner_JS();
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
                Item_Move($(this), $('#Table_Search_Cost'), $('#Table_Exec_Data'), true);
            });

            function DDL() {
                $.ajax({
                    url: "/Web_Service/DDL_DataBind.asmx/Product_Class",
                    cache: false,
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (data) {
                        var Json_Response = JSON.parse(data.d);
                        var DDL_Option = "<option></option>";

                        $.each(Json_Response, function (i, value) {
                            DDL_Option += '<option value="' + value.val + '">' + value.txt + '</option>';
                        });
                        $('#DDL_PC, #DDL_SET_PC').html(DDL_Option);
                    },
                    error: function (response) {
                        alert(response.responseText);
                    },
                });
            }
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
        .Call_Product_Tool{
            border-radius: 4px;
            border:5px blue none;
            text-shadow: 0 1px 1px rgba(0, 0, 0, 0.2);
            background: Gainsboro;
        }
        .Call_Product_Tool:hover {
            opacity: 0.8;
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
    <uc2:uc2 ID="uc2" runat="server" /> 
    <uc3:uc3 ID="uc3" runat="server" /> 

    <table class="table_th" style="text-align: left;">
        <tr><td style="height:5px;"></td></tr>
        <tr class="For_S">
            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Ivan_Model%></td>
            <td style="text-align: left; width: 15%;">
                <input id="TB_IM" autocomplete="off" style="width: 100%;" />
            </td>
            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Product_Class%></td>
            <td style="text-align: left; width: 15%;">
                <select id="DDL_PC" style="width:100%;"></select>
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
            <td></td><td></td>
        </tr>
        <tr class="For_S">
            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Supplier_No%></td>
            <td style="text-align: left; width: 15%;">
                <div style="width: 90%; float: left; z-index: -10;">
                    <input id="TB_S_No" style="width: 100%; z-index: -10;" />
                </div>
                <div style="width: 10%; float: right; z-index: 10;">
                    <input id="BT_Product_Selector" type="button" value="…" style="float: right; z-index: 10; width: 100%;" />
                </div>
            </td>
            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Supplier_Short_Name%></td>
            <td style="text-align: left; width: 15%;">
                <input id="TB_S_SName" class="disabled" disabled="disabled" style="width: 100%;" />
            </td>
            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Sale_Model%></td>
            <td style="text-align: left; width: 15%;">
                <input id="TB_SaleM" style="width: 100%;" />
            </td>
            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Product_Information%></td>
            <td style="text-align: left; width: 15%;">
                <input id="TB_PI" style="width: 100%;" />
            </td>
        </tr>
        <tr>
            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Big_Stock%></td>
            <td style="text-align: left; width: 15%;">
                <select id="DDL_BigS">
                    <option selected="selected">ALL</option>
                    <option value="Y">有</option>
                    <option value="N">無</option>
                </select>
            </td>
            <td style="text-align: right; text-wrap: none; width: 10%;">MSRP</td>
            <td style="text-align: left; width: 15%;">
                <select id="DDL_MSRP">
                    <option selected="selected">ALL</option>
                    <option value="Y">有</option>
                    <option value="N">無</option>
                </select>
            </td>
            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Product_Class%></td>
            <td style="text-align: left; width: 15%;">
                <select id="DDL_PC_NEX">
                    <option selected="selected">ALL</option>
                    <option value="1">無一階</option>
                    <option value="2">無二階</option>
                    <option value="3">無三階</option>
                </select>
            </td>
            <td style="text-align: right; text-wrap: none; width: 10%;"></td>
            <td style="text-align: left; width: 15%;">
                <input id="CB_Not_Leather" type="checkbox" checked="checked" />
                <label for="CB_Not_Leather">排除皮革</label>
            </td>
        </tr>
        <tr>
            <td class="tdtstyleRight" colspan="7">
                <input type="button" id="BT_Search" class="M_BT" value="<%=Resources.MP.Search%>" />
                <input type="button" id="BT_Save" class="M_BT" value="<%=Resources.MP.Save%>" style="display:none;" />
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
        <div id="Div_DT_View" style="width: 60%; height: 65vh; overflow: auto; display: none; float: left;border-style:solid;border-width:1px; ">
            <span class="dataTables_info" id="Table_Search_Cost_info" role="status" aria-live="polite"></span>
            <table id="Table_Search_Cost" style="width: 99%;" class="table table-striped table-bordered">
                <thead></thead>
                <tbody></tbody>
            </table>
        </div>

        <div id="Div_Data_Control" style="width: 5%; margin: 0 auto; text-align: center; height: 65vh; float: left; display: none;">
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

        <div id="Div_Exec_Data" style="width: 35%; height: 65vh; overflow: auto; display: none; float: right;border-style:solid;border-width:1px; ">
            <span class="dataTables_info" id="Table_Exec_Data_info" role="status" aria-live="polite"></span>
            <div class="For_U">
                <div style="display: flex;align-items: center;">
                    <span><%=Resources.MP.Set_Product_Class%>&nbsp;&nbsp;&nbsp;&nbsp;</span>
                    <select id="DDL_SET_PC" style="width:300px;height:50px;"></select>
                </div>
            </div>
            <table id="Table_Exec_Data" style="width: 100%;" class="table table-striped table-bordered">
                <thead></thead>
                <tbody></tbody>
            </table>
        </div>
    </div>

    <br />
    <br />
</asp:Content>
