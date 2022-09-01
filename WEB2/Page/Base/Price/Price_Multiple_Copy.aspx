<%@ Page Title="Price Multiple Copy" Language="C#" MasterPageFile="~/MP.master" AutoEventWireup="true" %>
<%@ Register TagPrefix="uc1" TagName="uc1" Src="~/User_Control/Dia_Supplier_Selector.ascx" %>
<%@ Register TagPrefix="uc2" TagName="uc2" Src="~/User_Control/Dia_Customer_Selector.ascx" %>
<%@ Register TagPrefix="uc3" TagName="uc3" Src="~/User_Control/Dia_Product_ALL.ascx" %>
<%@ Register TagPrefix="uc4" TagName="uc4" Src="~/User_Control/Dia_Duo_Datetime_Picker.ascx" %>


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
            var Customer_Selector_Control;
            //var Click_tr_IDX;
            document.body.style.overflow = 'hidden';
            //Search_Price();//WD
            //Form_Mode_Change("Search");//WD

            $('#SSD_Table_Supplier').on('click', '.SUP_SEL', function () {
                $('#TB_S_No').val($(this).parent().parent().find('td:nth(2)').text());
                $('#TB_S_SName').val($(this).parent().parent().find('td:nth(3)').text());
                $("#Search_Supplier_Dialog").dialog('close');
            });

            $('#BT_Customer_Selector, #DNT_BT_Customer_Selector').on('click', function () {
                switch ($(this).prop('id')){
                    case "BT_Customer_Selector":
                        Customer_Selector_Control = 1;
                        break;
                    case "DNT_BT_Customer_Selector":
                        Customer_Selector_Control = 2;
                        break;
                }
                $('#Search_Customer_Dialog').dialog('open');
            });

            $('#SCD_Table_Customer').on('click', '.CUST_SEL', function () {
                switch (Customer_Selector_Control) {
                    case 1:
                        $('#TB_C_No').val($(this).parent().parent().find('td:nth(2)').text());
                        $('#TB_C_SName').val($(this).parent().parent().find('td:nth(3)').text());
                        break;
                    case 2:
                        $('#DNT_TB_C_No').val($(this).parent().parent().find('td:nth(2)').text());
                        $('#DNT_TB_C_SName').val($(this).parent().parent().find('td:nth(3)').text());
                        break;
                }
                $("#Search_Customer_Dialog").dialog('close');
            });

            $('#BT_Search').on('click', function () {
                Form_Mode_Change("Search");
                Search_Price();
            });

            function Check() {
                var Check_Result = true;
                var Repeat_IM;
                if ($('#DNT_TB_C_No').val().trim().length === 0) {
                    Check_Result = false;
                    alert("請選擇新客戶");
                }
                if ($('#Table_Exec_Data tbody tr .C_No').filter(function () { return $(this).text() == $('#DNT_TB_C_No').val(); }).length > 0) {
                    Check_Result = false;
                    alert('複製對象與新客戶編號相同');
                }
                return Check_Result;
            };

            $('#BT_Copy').on('click', function () {
                if (Check()) {
                    var E_Json = [];
                    $('#Table_Exec_Data tbody tr').each(function () {
                        var Exec_Obj = {};
                        Exec_Obj["客戶編號"] = $('#DNT_TB_C_No').val();
                        Exec_Obj["客戶簡稱"] = $('#DNT_TB_C_SName').val();
                        Exec_Obj["開發中"] = $('#DNT_DDL_DVN').val();
                        $(this).find('.Edit_Data').each(function () {
                            switch ($(this).attr('type')) {
                                case "number":
                                    Exec_Obj[$(this).attr('Column_Name')] = parseFloat($(this).val()) || 0;
                                    break;
                                default:
                                    Exec_Obj[$(this).attr('Column_Name')] = $(this).val();
                                    break;
                            }
                        });
                        Exec_Obj["更新人員"] = "<%=(Session["Account"] == null) ? "Ivan10" : Session["Name"].ToString().Trim() %>";
                        Exec_Obj["OLD_BYRLU_SEQ"] = $(this).find('.SEQ').text();
                        E_Json.push(Exec_Obj);
                        //console.warn(Exec_Obj);
                    });
                    $.ajax({
                        url: "/Page/Base/Price/Ashx/Price_MMC.ashx",
                        data: {
                            "Call_Type": "Price_MMC_Copy",
                            "Exec_Data": JSON.stringify(E_Json)
                        },
                        cache: false,
                        async: false,
                        type: "POST",
                        datatype: "json",
                        contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                        success: function (R) {
                            alert('儲存完成');
                            console.warn(R);
                            $('#Table_Exec_Data').html('');
                            $('#Div_Edit_Area input').not('[type=button]').val('');
                            $('#Table_Exec_Data_info').text('Showing 0 entries');
                            Form_Mode_Change("Search");
                            Search_Price();
                            //Table_Sort($('#Table_Search_Price thead th').filter(function () { return $(this).text() === "更新日期"; }).addClass('asc selected'));
                        },
                        error: function (ex) {
                            alert(ex.responseText);
                        }
                    });
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

            function Form_Mode_Change(Form_Mode) {
                switch (Form_Mode) {
                    case "Base":
                        Edit_Mode = "Base";
                        $('.V_BT').attr('disabled', false);
                        $('#V_BT_Master').attr('disabled', 'disabled');
                        $('#Div_DT_View, #Div_Data_Control, #Div_Exec_Data, #Div_Edit_Area').toggle(false);
                        $('#RB_DV_DIMG').prop('checked', true);
                        $('input[type=radio][name=DIMG]').attr('disabled', 'disabled');
                        break;
                    case "Search":
                        Edit_Mode = "Can_Move";
                        $('.V_BT').attr('disabled', false);
                        $('#V_BT_Master').attr('disabled', 'disabled');
                        $('#Div_DT_View, #Div_Data_Control, #Div_Exec_Data').toggle(true);
                        $('#Div_Edit_Area').toggle(false);
                        $('#RB_DV_DIMG').prop('checked', true);
                        $('input[type=radio][name=DIMG]').attr('disabled', false);
                        //$('#Div_DT_View').css('width', '60%');
                        $('#Div_Exec_Data').css('width', '35%');
                        $('#Div_Exec_Data').css('float', 'Right');
                        //Click_tr_IDX = null;
                        $('#Table_Exec_Data tbody tr').css('background-color', '');
                        $('#Table_Exec_Data tbody tr').css('color', 'black');
                        Restore_Element();
                        break;
                    case "Edit_Data":
                        Edit_Mode = "Edit";
                        $('.V_BT').attr('disabled', false);
                        $('#V_BT_Copy').attr('disabled', 'disabled');
                        $('#Div_DT_View, #Div_Data_Control').toggle(false);
                        $('#Div_Edit_Area').toggle(true);
                        $('#Div_Exec_Data').css('width', '80%');
                        $('#Div_Exec_Data').css('float', 'left');
                        $('#Div_Edit_Area').css('width', '19%');
                        Change_View_Element();
                        break;
                }
            }

            function Restore_Element() {
                $('#Div_Exec_Data tbody tr td[Original_Data]').each(function () {
                    $(this).html($(this).attr('Original_Data'));
                });
            };

            function Change_View_Element() {
                $('#Div_Exec_Data .Change_VE').each(function () {
                    $(this).attr('Original_Data', $(this).text());
                    switch ($(this).attr('colType')) {
                        case "NUM":
                            $(this).html('<input type="number" style="text-align:right;width:80px;" min="0" step="0.1" class="Edit_Data" Column_Name="' + $(this).attr('colDB') + '" value="' + $(this).text().replace(',', '') + '"/>');
                            break;
                        case "NUM_INT":
                            $(this).html('<input type="number" style="text-align:right;width:80px;" min="0" step="1" class="Edit_Data" Column_Name="' + $(this).attr('colDB') + '" value="' + $(this).text().replace(',', '') + '"/>');
                            break;
                        default:
                            $(this).html('<input class="Edit_Data" Column_Name="' + $(this).attr('colDB') + '" value="' + $(this).text() + '"/>');
                            break;
                    }
                });
                $('#Div_Exec_Data .Edit_Data[Column_Name=單位]').css('width', '80px');
            };

            $('#V_BT_Master').on('click', function () {
                Form_Mode_Change("Search");
            });

            $('.V_BT').on('click', function () {
                $('.V_BT').attr('disabled', false);
                $(this).attr('disabled', 'disabled');
            });

            $('#BT_Next, #V_BT_Copy').on('click', function () {
                Form_Mode_Change("Edit_Data");
                //Click_tr_IDX = 0;
                //FN_Tr_Click($('#Table_Exec_Data tbody tr:nth(' + Click_tr_IDX + ')'));
            });
            //$('.V_Report').on('click', function () {
            //    Form_Mode_Change("Edit_Data");
            //    $('[Control_By]').toggle(false);
            //    $('[Control_By=' + $(this).prop('id') + ']').toggle(true);
            //});
            function Search_Price() {
                var S_Json = [];
                var Search_Obj = {};
                $('[request_colname]').each(function () {
                    Search_Obj[$(this).attr('request_colname')] = $(this).val();
                });
                S_Json.push(Search_Obj);

                $.ajax({
                    url: "/Page/Base/Price/Ashx/Price_MMC.ashx",
                    data: {
                        "Call_Type": "Price_MMC_Search",
                        "Search_Data": JSON.stringify(S_Json)
                    },
                    cache: false,
                    async: false,
                    type: "POST",
                    datatype: "json",
                    contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                    success: function (R) {
                        //console.warn(R);
                        if (R.length === 0) {
                            alert('<%=Resources.MP.Data_Not_Exists_Alert%>');
                            Form_Mode_Change("Base");
                        }
                        else {
                            var Table_HTML =
                                '<thead>\
                                    <tr>\
                                        <th>' + '<%=Resources.MP.Developing%>' + '</th>\
                                        <th>' + '<%=Resources.MP.Customer_Short_Name%>' + '</th>\
                                        <th>' + '<%=Resources.MP.Ivan_Model%>' + '</th>\
                                        <th>' + '<%=Resources.MP.Sale_Model%>' + '</th>\
                                        <th>' + '<%=Resources.MP.Product_Status%>' + '</th>\
                                        <th>' + '<%=Resources.MP.USD_Price%>' + '</th>\
                                        <th class="DIMG">' + '<%=Resources.MP.Image%>' + '</th>\
                                        <th>' + '<%=Resources.MP.Unit%>' + '</th>\
                                        <th>' + '<%=Resources.MP.Customer_Model%>' + '</th>\
                                        <th>MIN_1</th>\
                                        <th>' + '<%=Resources.MP.Price_Information%>' + '</th>\
                                        <th>' + '<%=Resources.MP.TWD_Price%>' + '</th>\
                                        <th>' + '<%=Resources.MP.Price_T%>_2' + '</th>\
                                        <th>' + '<%=Resources.MP.Supplier_No%>' + '</th>\
                                        <th>' + '<%=Resources.MP.Supplier_Short_Name%>' + '</th>\
                                        <th>' + '<%=Resources.MP.Customer_No%>' + '</th>\
                                        <th>' + '<%=Resources.MP.SEQ%>' + '</th>\
                                        <th>' + '<%=Resources.MP.Update_User%>' + '</th>\
                                        <th>' + '<%=Resources.MP.Update_Date%>' + '</th>\
                                   </tr>\
                            </thead>\
                            <tbody>';
                            $(R).each(function (i) {
                                Table_HTML +=
                                    '<tr>\
                                    <td>' + String(R[i].開發中 ?? "") + '</td>\
                                    <td>' + String(R[i].客戶簡稱 ?? "") + '</td>\
                                    <td>\
                                        <input class="Call_Product_Tool" SUPLU_SEQ = "' + String(R[i].SUPLU_SEQ ?? "") + '" \
                                               type="button" value="' + String(R[i].頤坊型號 ?? "") + '" \
                                               style="text-align:left;width:100%;z-index:1000;' + ((R[i].Has_IMG) ? 'background: #90ee90;' : '') + '" />\
                                    </td>\
                                    <td>' + String(R[i].銷售型號 ?? "").trim() + '</td>\
                                    <td>' + String(R[i].產品狀態 ?? "") + '</td>\
                                    <td class="Change_VE" colType="NUM" colDB="美元單價" style="text-align:right;">' + String(R[i].美元單價 ?? "").replace(/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ",") + '</td>\
                                    <td class="DIMG" style="text-align:center; height:100px; vertical-align:middle;">'
                                        + ((R[i].Has_IMG) ? ('<img type="Product" SEQ="' + String(R[i].SUPLU_SEQ ?? "") + '" />') : ('<%=Resources.MP.Image_NotExists%>')) +
                                    '</td>\
                                    <td>' + String(R[i].單位 ?? "") + '</td>\
                                    <td class="Change_VE" colDB="客戶型號">' + String(R[i].客戶型號 ?? "").trim() + '</td>\
                                    <td class="Change_VE" colType="NUM_INT" colDB="MIN_1" style="text-align:right;">' + String(R[i].MIN_1 ?? "").replace(/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ",") + '</td>\
                                    <td>' + String(R[i].產品說明 ?? "") + '</td>\
                                    <td>' + String(R[i].台幣單價 ?? "").replace(/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ",") + '</td>\
                                    <td>' + String(R[i].單價_2 ?? "").replace(/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ",") + '</td>\
                                    <td>' + String(R[i].廠商編號 ?? "") + '</td>\
                                    <td>' + String(R[i].廠商簡稱 ?? "") + '</td>\
                                    <td class="C_No">' + String(R[i].客戶編號 ?? "") + '</td>\
                                    <td class="SEQ">' + String(R[i].序號 ?? "") + '</td>\
                                    <td>' + String(R[i].更新人員 ?? "") + '</td>\
                                    <td>' + String(R[i].更新日期 ?? "") + '</td>\
                                </tr>';
                            });

                            Table_HTML += '</tbody>';
                            $('#Table_Search_Price').html(Table_HTML);

                            $('.DIMG').toggle(!$('#RB_DV_DIMG').prop('checked'));
                            $('#Table_Search_Price_info').text('Showing ' + $('#Table_Search_Price > tbody tr').length + ' entries');
                            IMG_Has_Read = false;//初始化IMG讀取

                            $('#Table_Search_Price').css('white-space', 'nowrap');
                            $('#Table_Search_Price thead th').css('text-align', 'center');
                            $('#Table_Search_Price tbody td').css('vertical-align', 'middle');
                            $('#Table_Search_Price tbody td').filter(function () { return $(this).text() === "0"; }).text('');
                            Re_Bind_Inner_JS();

                            //Table_Sort($('#Table_Search_Price thead th').filter(function () { return $(this).text() === "更新日期"; }).addClass('asc selected'));
                            //Table_Sort($('#Table_Search_Price thead th:last').addClass('asc selected'));
                        }
                    },
                    error: function (ex) {
                        //alert(ex);
                        console.warn(ex);
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
                if (Show_IMG && !IMG_Has_Read) {
                    FN_GET_IMG($('#Table_Exec_Data img[type=Product]'));
                    FN_GET_IMG($('#Table_Search_Price img[type=Product]'));
                }
                function FN_GET_IMG(IMG) {//取得順序調整，Exec優先
                    $(IMG).each(function (i) {
                        var IMG_SEL = $(this);
                        var binary = '';
                        $.ajax({
                            url: "/Page/Base/BOM/BOM_Search.ashx",
                            data: {
                                "Call_Type": "GET_IMG",
                                "SUPLU_SEQ": $(this).attr('SEQ')
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

            function Item_Move(click_tr, ToTable, FromTable, Full) {
                if (Edit_Mode == "Can_Move") {
                    if (ToTable.find('tbody tr').length === 0) {
                        ToTable.html(FromTable.find('thead').clone());
                        ToTable.append('<tbody></tbody>');
                        ToTable.find('thead th').css('text-align', 'center');
                        ToTable.css('white-space', 'nowrap');
                    }
                    if (Full) {
                        //For Price客製，Suplu_SEQ重複即刪除
                        FromTable.find('.Call_Product_Tool').each(function () {
                            var OT = $(this).attr('SUPLU_SEQ');
                            if (ToTable.find('.Call_Product_Tool').filter(function () { return $(this).attr('SUPLU_SEQ') == OT; }).length === 0) {
                                ToTable.append($(this).parents('tr').clone());
                            }
                            else {
                                console.warn($(this));
                            }
                            $(this).parents('tr').remove();
                        });
                    }
                    else {
                        if (ToTable.find('.Call_Product_Tool').filter(function () { return $(this).attr('SUPLU_SEQ') == click_tr.find('.Call_Product_Tool').attr('SUPLU_SEQ'); }).length === 0) {
                            ToTable.append(click_tr.clone());
                        }
                        click_tr.remove();
                    }
                    if (FromTable.find('tbody tr').length === 0) {
                        FromTable.html('');
                    }
                    $('#Table_Exec_Data_info').text('Showing ' + $('#Table_Exec_Data > tbody tr').length + ' entries');
                    $('#Table_Search_Price_info').text('Showing ' + $('#Table_Search_Price > tbody tr').length + ' entries');

                    $('.Exist_Select').toggle(Boolean($('#Table_Exec_Data').find('tbody tr').length > 0));

                    Re_Bind_Inner_JS();
                }
            }

            $('#Table_Search_Price').on('click', 'tbody tr', function () {
                Item_Move($(this), $('#Table_Exec_Data'), $('#Table_Search_Price'), false);
            });
            $('#Table_Exec_Data').on('click', 'tbody tr', function () {
                switch (Edit_Mode) {
                    case "Can_Move":
                        Item_Move($(this), $('#Table_Search_Price'), $('#Table_Exec_Data'), false);
                        break;
                    case "Edit":
                        //Click_tr_IDX = $(this).index();
                        //FN_Tr_Click($(this));
                        break;
                }
            });
            $('#BT_ATR').on('click', function () {
                Item_Move($(this), $('#Table_Exec_Data'), $('#Table_Search_Price'), true);
            });
            $('#BT_ATL').on('click', function () {
                Item_Move($(this), $('#Table_Search_Price'), $('#Table_Exec_Data'), true);
            });

            //$(window).keydown(function (e) {
            //    if (Click_tr_IDX != null) {
            //        switch (e.keyCode) {
            //            case 38://^
            //                if (Click_tr_IDX > 0) {
            //                    Click_tr_IDX -= 1;
            //                }
            //                FN_Tr_Click($('#Table_Exec_Data tbody tr:nth(' + Click_tr_IDX + ')'));
            //                break;
            //            case 40://v
            //                if (Click_tr_IDX < ($('#Table_Exec_Data tbody tr').length - 1)) {
            //                    Click_tr_IDX += 1;
            //                }
            //                FN_Tr_Click($('#Table_Exec_Data tbody tr:nth(' + Click_tr_IDX + ')'));
            //                break;
            //        }
            //    }
            //});

            //function FN_Tr_Click(Click_tr) {
            //    Click_tr.parent().find('tr').css('background-color', '');
            //    Click_tr.parent().find('tr').css('color', 'black');
            //    Click_tr.css('background-color', '#5a1400');
            //    Click_tr.css('color', 'white');

            //    $('#DOT_TB_IM').val(Click_tr.find('td').eq(1).find('input').val());
            //    $('#DDT_HDN_D_SUPLU_SEQ').val(Click_tr.find('td').eq(1).find('input').attr('SUPLU_SEQ'));
            //    $('#DOT_TB_S_ALL').val(Click_tr.find('td').eq(0).text());
            //    $('#DOT_TB_PI').val(Click_tr.find('td').eq(9).text());
            //};

            $('#Table_Search_Price, #Table_Exec_Data').on('click', 'thead th', function () {
                //If !Column is cannot sort
                Table_Sort($(this));
            });

            function Table_Sort(Click_th) {
                Click_th.siblings().removeClass('focus');
                Click_th.addClass('focus');
                //Click_th.siblings().text().replace('▲','').replace('▼', '');

                var Sort_Table = Click_th.parents('table');
                var IDX = Click_th.index();

                if (Click_th.is('.asc')) {
                    Click_th.removeClass('asc');
                    Click_th.addClass('desc selected');
                    sortOrder = -1;
                } else {
                    Click_th.addClass('asc selected');
                    Click_th.removeClass('desc');
                    sortOrder = 1;
                }
                Click_th.siblings().removeClass('asc selected desc selected');
                var arrData = Sort_Table.find('tbody>tr:has(td)').get();

                arrData.sort(function (a, b) {
                    var val1 = $(a).children('td').eq(IDX).text().trim();
                    if (val1.length == 0) {
                        val1 = $(a).children('td').eq(IDX).find('input').val().trim();
                    }

                    var val2 = $(b).children('td').eq(IDX).text().trim();
                    if (val2.length == 0) {
                        val2 = $(b).children('td').eq(IDX).find('input').val().trim();
                    }

                    if ($.isNumeric(val1) && $.isNumeric(val2))
                        return sortOrder == 1 ? val1 - val2 : val2 - val1;
                    else
                        return (val1 < val2) ? -sortOrder : (val1 > val2) ? sortOrder : 0;
                });
                $.each(arrData, function (index, row) {
                    Sort_Table.find('tbody').append(row);
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
        #Table_Search_Price tbody tr:hover, #Table_Exec_Data tbody tr:hover{
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
            top: 0; /* 凍結th */
        }
    </style>
    <uc1:uc1 ID="uc1" runat="server" /> 
    <uc2:uc2 ID="uc2" runat="server" /> 
    <uc3:uc3 ID="uc3" runat="server" /> 
    <uc4:uc4 ID="uc4" runat="server" /> 

    <table class="table_th" style="text-align: left;">
        <tr>
            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Customer_No%></td>
            <td style="text-align: left; width: 15%;">
                <div style="width: 90%; float: left; z-index: -10;">
                    <input id="TB_C_No" Request_ColName="客戶編號" style="width: 100%; z-index: -10;" />
                </div>
                <div style="width: 10%; float: right; z-index: 10;">
                    <input id="BT_Customer_Selector" type="button" value="…" style="float: right; z-index: 10; width: 100%;" />
                </div>
            </td>
            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Customer_Short_Name%></td>
            <td style="text-align: left; width: 15%;">
                <input id="TB_C_SName" Request_ColName="客戶簡稱" autocomplete="off" style="width: 100%;" />
            </td>
            
            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Supplier_No%></td>
            <td style="text-align: left; width: 15%;">
                    <div style="width: 90%; float: left; z-index: -10;">
                        <input id="TB_S_No" Request_ColName="廠商編號" style="width: 100%; z-index: -10;" />
                    </div>
                    <div style="width: 10%; float: right; z-index: 10;">
                        <input id="BT_Supplier_Selector" type="button" value="…" style="float: right; z-index: 10; width: 100%;" onclick="$('#Search_Supplier_Dialog').dialog('open');" />
                    </div>
            </td>
            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Supplier_Short_Name%></td>
            <td style="text-align: left; width: 15%;">
                <input Request_ColName="廠商簡稱" id="TB_S_SName" style="width: 100%; z-index: -10;" />
            </td>
        </tr>
        <tr>
            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Ivan_Model%></td>
            <td style="text-align: left; width: 15%;">
                <input Request_ColName="頤坊型號" id="TB_IM" autocomplete="off" style="width: 100%;" />
            </td>
            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Customer_Model%></td>
            <td style="text-align: left; width: 15%;">
                <input Request_ColName="客戶型號" id="TB_CustM" autocomplete="off" style="width: 100%;" />
            </td>
            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Sale_Model%></td>
            <td style="text-align: left; width: 15%;">
                <input Request_ColName="銷售型號" id="TB_SaleM" autocomplete="off" style="width: 100%;" />
            </td>
            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Update_Date%></td>
            <td style="text-align: left; width: 15%;">
                <div style="width: 90%; float: left; z-index: -10;">
                    <input Request_ColName="DS" id="TB_Date_S1" class="TB_DS1" type="date" style="width: 50%;" /><input id="TB_Date_E1" Request_ColName="DE" type="date" class="TB_DE1" style="width: 50%;" />
                </div>
                <div style="width: 10%; float: right; z-index: 10;">
                    <input id="BT_Duo_Datetime_Picker" type="button" value="…" style="float: right; z-index: 10; width: 100%;" onclick="$('#DDPB_HDN_DP_Control').val(1);$('#Duo_Datetime_Picker_Dialog').dialog('open');" />
                </div>
            </td>
        </tr>
        <tr>
            <td style="text-align: right; text-wrap: none; width: 10%;" ><%=Resources.MP.Price_Information%></td>
            <td style="text-align: left; width: 40%;" colspan="3">
                <input id="TB_PI" Request_ColName="產品說明" style="width: 100%;" />
            </td>
        </tr>
        <tr>
            <td class="tdtstyleRight" colspan="7">
                <input type="button" id="BT_Search" class="M_BT" value="<%=Resources.MP.Search%>" />
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
    <div style="width: 99%; margin: 0 auto; background-color: white;">
        &nbsp;
        <input id="V_BT_Master" type="button" class="V_BT" value="<%=Resources.MP.Select%>" disabled="disabled" />
        <input id="V_BT_Copy" type="button" class="V_BT Exist_Select" style="display:none;" value="<%=Resources.MP.Copy%>" />
    </div>
    <div>&nbsp;&nbsp;&nbsp;&nbsp;
        <input id="RB_DV_DIMG" type="radio" name="DIMG" disabled="disabled" checked="checked" />
        <label for="RB_DV_DIMG"><%=Resources.MP.Not_Show_Image%></label>
        <%--<input id="RB_V_DIMG" type="radio" name="DIMG" disabled="disabled" />
        <label for="RB_V_DIMG"><%=Resources.MP.Show_Original_Image%></label>--%>
        <input id="RB_SM_DIMG" type="radio" name="DIMG" disabled="disabled" />
        <label for="RB_SM_DIMG"><%=Resources.MP.Show_Small_Image%></label>
    </div>
    <div style="width: 98%; margin: 0 auto;">
        <div id="Div_DT_View" style="width: 60%; height: 70vh; overflow: auto; display: none; float: left;border-style:solid;border-width:1px;">
            <span class="dataTables_info" id="Table_Search_Price_info" role="status" aria-live="polite"></span>
            <table id="Table_Search_Price" style="width: 99%;" class="table table-striped table-bordered">
                <thead></thead>
                <tbody></tbody>
            </table>
        </div>

        <div id="Div_Data_Control" style="width: 5%; margin: 0 auto; text-align: center; height: 70vh; float: left; display: none;">
            <table style="width: 100%; height: 100%;">
                <tr>
                    <td style="width: 100%; height: 100%; vertical-align: middle;">
                        <input id="BT_ATR" type="button" value=">>" class="BTN_Green" />
                        <br />
                        <br />
                        <input id="BT_ATL" type="button" value="<<" class="BTN_Green" />
                        <br />
                        <br />
                        <input id="BT_Next" type="button" value="Next" style="inline-size: 100%; display: none;" class="BTN Exist_Select" />
                    </td>
                </tr>
            </table>
        </div>

        <div id="Div_Exec_Data" style="width: 35%; height: 70vh; overflow: auto; display: none; float: right;border-style:solid;border-width:1px; ">
            <span class="dataTables_info" id="Table_Exec_Data_info" role="status" aria-live="polite"></span>
            <table id="Table_Exec_Data" style="width: 100%;" class="table table-striped table-bordered">
                <thead></thead>
                <tbody></tbody>
            </table>
        </div>

        <div id="Div_Edit_Area" style="width: 19%; height: 70vh; overflow: auto; display: none; float: right; border-style: solid; border-width: 1px;">
            <table style="border-collapse: separate; border-spacing: 0px 8px; margin: 0 auto; width: 100%;" id="DEA_New_Table">
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.New%><%=Resources.MP.Speace%><%=Resources.MP.Customer_No%></td>
                    <td style="text-align: left; width: 15%;">
                        <div style="width: 80%; float: left; z-index: -10;">
                            <input id="DNT_TB_C_No" class="disable" autocomplete="off" disabled="disabled" style="width: 100%; z-index: -10;" />
                        </div>
                        <div style="width: 20%; float: right; z-index: 10;">
                            <input id="DNT_BT_Customer_Selector" type="button" value="…" style="float: right; z-index: 10;" />
                        </div>
                    </td>
                    <td style="width: 2%;"></td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.New%><%=Resources.MP.Speace%><%=Resources.MP.Customer_Short_Name%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="DNT_TB_C_SName" class="disable" disabled="disabled" style="width: 100%;" />
                    </td>
                    <td></td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.New%><%=Resources.MP.Speace%><%=Resources.MP.Customer%>_<%=Resources.MP.Developing%></td>
                    <td style="text-align: left; width: 15%;">
                        <select id="DNT_DDL_DVN" style="width: 100%; height: 28.5px;">
                            <option selected="selected">Y</option>
                            <option>N</option>
                        </select>
                    </td>
                    <td></td>
                </tr>
            </table>
            <br />
            <div style="width: 100%; text-align: center;">
                <input id="BT_Copy" type="button" class="BTN" style="display:inline-block;" value="<%=Resources.MP.Copy%>" />
            </div>
        </div>
    </div>

    <br />
    <br />
</asp:Content>