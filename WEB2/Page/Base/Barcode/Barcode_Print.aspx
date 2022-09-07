<%@ Page Title="Barcode_Print" Language="C#" MasterPageFile="~/MP.master" AutoEventWireup="true" %>
<%@ Register TagPrefix="uc1" TagName="uc1" Src="~/User_Control/Dia_Supplier_Selector.ascx" %>
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
            document.body.style.overflow = 'hidden';
            //Search_Barcode();//WD
            //Form_Mode_Change("Search");//WD
            DDL_DataBind("內銷條碼", $('#DDL_Barcode_Type'));

            $('#SSD_Table_Supplier').on('click', '.SUP_SEL', function () {
                $('#TB_S_No').val($(this).parent().parent().find('td:nth(2)').text());
                $('#TB_S_SName').val($(this).parent().parent().find('td:nth(3)').text());
                $("#Search_Supplier_Dialog").dialog('close');
            });

            $('#DDL_Data_Souce').on('change', function () {
                switch ($(this).val()) {
                    case "Cost":
                        $('.Cost').toggle(true);
                        $('.Stkio').toggle(false);
                        break;
                    case "Stkio":
                        $('.Cost').toggle(false);
                        $('.Stkio').toggle(true);
                        break;
                }
            });

            $('#BT_Search').on('click', function () {
                Form_Mode_Change("Search");
                Search_Barcode();
            });

            function Check() {
                var Check_Result = true;
                //if ($('#DNT_TB_C_No').val().trim().length === 0) {
                //    Check_Result = false;
                //    alert("請選擇新客戶");
                //}
                //if ($('#Table_Exec_Data tbody tr .C_No').filter(function () { return $(this).text() == $('#DNT_TB_C_No').val(); }).length > 0) {
                //    Check_Result = false;
                //    alert('複製對象與新客戶編號相同');
                //}
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
                            Search_Barcode();
                            //Table_Sort($('#Table_Search_Barcode thead th').filter(function () { return $(this).text() === "更新日期"; }).addClass('asc selected'));
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

                $('.Change_VE .Edit_Data').off('change');
                $('.Change_VE').on('change', '.Edit_Data', function () {
                    Print_Count();
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
                //Hint:若修改值，仍會還原為舊資料
            };

            function Change_View_Element() {
                $('#Div_Exec_Data .Change_VE').each(function () {
                    $(this).attr('Original_Data', $(this).html());
                    switch ($(this).attr('colType')) {
                        //case "CB":
                        //    $(this).find('input[type=checkbox]').attr('disabled', false);
                        //    break;
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

            $('#BT_Next, #V_BT_Print').on('click', function () {
                $('.V_BT').attr('disabled', false);
                $('#V_BT_Print').attr('disabled', 'disabled');
                Form_Mode_Change("Edit_Data");
                Print_Count();
                //Click_tr_IDX = 0;
                //FN_Tr_Click($('#Table_Exec_Data tbody tr:nth(' + Click_tr_IDX + ')'));
            });

            $('.V_Edit').on('click', function () {
                Form_Mode_Change("Edit_Data");
                $('[Control_By]').toggle(false);
                $('[Control_By=' + $(this).prop('id') + ']').toggle(true);
            });

            $('.DPA_V_BT').on('click', function () {
                $('.DPA_V_BT').attr('disabled', false);
                $(this).attr('disabled', 'disabled');
                $('[DPA_Control_By]').toggle(false);
                $('[DPA_Control_By=' + $(this).prop('id') + ']').toggle(true);
            });

            function Print_Count() {
                var SUM = 0;
                $('.Edit_Data').each(function () {
                    SUM += Number($(this).val());
                });
                $('#DPAB_P_C').text('共列印' + SUM + '張');
            };

            function Search_Barcode() {
                var S_Json = [];
                var Search_Obj = {};
                $('[Request_Colname]').each(function () {
                    Search_Obj[$(this).attr('Request_Colname')] = $(this).val();
                });
                S_Json.push(Search_Obj);

                $.ajax({
                    url: "/Page/Base/Barcode/Ashx/Barcode_Print.ashx",
                    data: {
                        "Call_Type": "Barcode_Print_Search",
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
                                        <th>樣式</th>\
                                        <th>單據編號</th>\
                                        <th>' + '<%=Resources.MP.Supplier_Short_Name%>' + '</th>\
                                        <th>' + '<%=Resources.MP.Ivan_Model%>' + '</th>\
                                        <th>' + '<%=Resources.MP.Sale_Model%>' + '</th>\
                                        <th class="DIMG">' + '<%=Resources.MP.Image%>' + '</th>\
                                        <th>簡短說明</th>\
                                        <th>' + '<%=Resources.MP.Unit%>' + '</th>\
                                        <th>數量</th>\
                                        <th>列印數量</th>\
                                        <th>寄送袋子</th>\
                                        <th>寄送吊卡</th>\
                                        <th>產地</th>\
                                        <th>條碼印價</th>\
                                        <th>自有條碼</th>\
                                        <th>' + '<%=Resources.MP.Unit%>' + '</th>\
                                        <th>英文說明一</th>\
                                        <th>英文說明二</th>\
                                        <th>英文ISP</th>\
                                        <th>' + '<%=Resources.MP.Supplier_No%>' + '</th>\
                                        <th>訂單號碼</th>\
                                        <th>頤坊條碼</th>\
                                        <th>CP65</th>\
                                        <th>' + '<%=Resources.MP.SEQ%>' + '</th>\
                                        <th>' + '<%=Resources.MP.Update_User%>' + '</th>\
                                        <th>' + '<%=Resources.MP.Update_Date%>' + '</th>\
                                   </tr>\
                            </thead>\
                            <tbody>';
                            var Class_Color, Remark_Color, BP_Color;
                            $(R).each(function (i) {
                                switch (String(R[i].樣式 ?? "")) {
                                    case "IV02":
                                        Class_Color = "background-color:gold;";
                                        break;
                                    case "IV06":
                                        Class_Color = "background-color:aqua;";
                                        break;
                                    case "IV07":
                                        Class_Color = "background-color:chocolate;";
                                        break;
                                    default:
                                        Class_Color = "";
                                        break;
                                }
                                Remark_Color = (String(R[i].寄送袋子 ?? "").length * String(R[i].寄送吊卡 ?? "").length * String(R[i].產地 ?? "").length * String(R[i].英文ISP ?? "").length == 0) ? 'background-color:hotpink;' : '';
                                BP_Color = (String(R[i].條碼印價 ?? "") == "true") ? 'background-color:burlywood;' : '';

                                Table_HTML +=
                                    '<tr>\
                                    <td style="' + Class_Color + '">' + String(R[i].樣式 ?? "") + '</td>\
                                    <td>' + String(R[i].單據編號 ?? "") + '</td>\
                                    <td>' + String(R[i].廠商簡稱 ?? "") + '</td>\
                                    <td>\
                                        <input class="Call_Product_Tool" SUPLU_SEQ = "' + String(R[i].序號 ?? "") + '" \
                                               type="button" value="' + String(R[i].頤坊型號 ?? "") + '" \
                                               style="text-align:left;width:100%;z-index:1000;' + ((R[i].Has_IMG) ? 'background: #90ee90;' : '') + '" />\
                                    </td>\
                                    <td>' + String(R[i].銷售型號 ?? "").trim() + '</td>\
                                    <td class="DIMG" style="text-align:center; height:100px; vertical-align:middle;">'
                                    + ((R[i].Has_IMG) ? ('<img type="Product" SEQ="' + String(R[i].序號 ?? "") + '" />') : ('<%=Resources.MP.Image_NotExists%>')) +
                                    '</td>\
                                    <td style="' + Remark_Color + '">' + String(R[i].簡短說明 ?? "") + '</td>\
                                    <td>' + String(R[i].英文單位 ?? "") + '</td>\
                                    <td style="text-align:right;">' + String(R[i].數量 ?? "") + '</td>\
                                    <td class="Change_VE" colType="NUM_INT" colDB="列印數量" style="text-align:right;">' + String(R[i].數量 ?? "") + '</td>\
                                    <td>' + String(R[i].寄送袋子 ?? "") + '</td>\
                                    <td>' + String(R[i].寄送吊卡 ?? "") + '</td>\
                                    <td>' + String(R[i].產地 ?? "") + '</td>\
                                    <td style="text-align:center;' + BP_Color + '">\
                                        <input type="checkbox" style="width: 1.15em;height: 1.15em;border: 0.15em solid currentColor;" ' + ((String(R[i].條碼印價 ?? "") == "true") ? 'checked="checked"' : '') + ' disabled />\
                                    </td>\
                                    <td style="text-align:center;">\
                                        <input type="checkbox" style="width: 1.15em;height: 1.15em;border: 0.15em solid currentColor;" ' + ((String(R[i].自有條碼 ?? "") == "true") ? 'checked="checked"' : '') + ' disabled />\
                                    </td>\
                                    <td>' + String(R[i].單位 ?? "") + '</td>\
                                    <td>' + String(R[i].英文說明一 ?? "") + '</td>\
                                    <td>' + String(R[i].英文說明二 ?? "") + '</td>\
                                    <td>' + String(R[i].英文ISP ?? "") + '</td>\
                                    <td>' + String(R[i].廠商編號 ?? "") + '</td>\
                                    <td>' + String(R[i].訂單號碼 ?? "") + '</td>\
                                    <td>' + String(R[i].頤坊條碼 ?? "") + '</td>\
                                    <td>' + String(R[i].CP65 ?? "") + '</td>\
                                    <td class="SEQ">' + String(R[i].序號 ?? "") + '</td>\
                                    <td>' + String(R[i].更新人員 ?? "") + '</td>\
                                    <td>' + String(R[i].更新日期 ?? "") + '</td>\
                                </tr>';
                            });

                            Table_HTML += '</tbody>';
                            $('#Table_Search_Barcode').html(Table_HTML);

                            $('.DIMG').toggle(!$('#RB_DV_DIMG').prop('checked'));
                            $('#Table_Search_Barcode_info').text('Showing ' + $('#Table_Search_Barcode > tbody tr').length + ' entries');
                            IMG_Has_Read = false;//初始化IMG讀取

                            $('#Table_Search_Barcode').css('white-space', 'nowrap');
                            $('#Table_Search_Barcode thead th').css('text-align', 'center');
                            $('#Table_Search_Barcode tbody td').css('vertical-align', 'middle');
                            $('#Table_Search_Barcode tbody td').filter(function () { return $(this).text() === "0"; }).text('');
                            Re_Bind_Inner_JS();

                            //Table_Sort($('#Table_Search_Barcode thead th').filter(function () { return $(this).text() === "更新日期"; }).addClass('asc selected'));
                            //Table_Sort($('#Table_Search_Barcode thead th:last').addClass('asc selected'));
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
                    FN_GET_IMG($('#Table_Search_Barcode img[type=Product]'));
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
                    $('#Table_Search_Barcode_info').text('Showing ' + $('#Table_Search_Barcode > tbody tr').length + ' entries');

                    $('.Exist_Select').toggle(Boolean($('#Table_Exec_Data').find('tbody tr').length > 0));

                    Re_Bind_Inner_JS();
                }
            }

            $('#Table_Search_Barcode').on('click', 'tbody tr', function () {
                Item_Move($(this), $('#Table_Exec_Data'), $('#Table_Search_Barcode'), false);
            });
            $('#Table_Exec_Data').on('click', 'tbody tr', function () {
                switch (Edit_Mode) {
                    case "Can_Move":
                        Item_Move($(this), $('#Table_Search_Barcode'), $('#Table_Exec_Data'), false);
                        break;
                    //case "Edit":
                        //Click_tr_IDX = $(this).index();
                        //FN_Tr_Click($(this));
                        //break;
                }
            });
            $('#BT_ATR').on('click', function () {
                Item_Move($(this), $('#Table_Exec_Data'), $('#Table_Search_Barcode'), true);
            });
            $('#BT_ATL').on('click', function () {
                Item_Move($(this), $('#Table_Search_Barcode'), $('#Table_Exec_Data'), true);
            });

            $('#Table_Search_Barcode, #Table_Exec_Data').on('click', 'thead th', function () {
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

            function DDL_DataBind(Call_Code, Bind_Element) {
                $.ajax({
                    url: "/Web_Service/DDL_DataBind.asmx/REF_Data_Basic",
                    data: "{'Call_Code': '" + Call_Code + "'}",
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
                        Bind_Element.html(DDL_Option);
                    },
                    error: function (response) {
                        alert(response.responseText);
                    },
                });
            };
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
        #Table_Search_Barcode tbody tr:hover, #Table_Exec_Data tbody tr:hover{
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
        table thead tr th {
            background-color:white;
            position: sticky;
            top: 0; /* 凍結th */
        }
        .DPA_V_BT {
            background-color: azure !important;
            font-weight: bold;
            border: none;
            cursor: pointer;
            font-size: 15px;
            text-align: center;
            text-decoration: none;
        }
            .DPA_V_BT:hover {
                background-color: #f8981d;
                color: white;
            }

    </style>
    <uc1:uc1 ID="uc1" runat="server" /> 
    <uc3:uc3 ID="uc3" runat="server" /> 
    <uc4:uc4 ID="uc4" runat="server" /> 

    <table class="table_th" style="text-align: left;">
        <tr><td style="height:5px;"></td></tr>
        <tr>
            <td rowspan="8" style="width:10%">
                <span>Data Source</span>
                <br />
                <select id="DDL_Data_Souce" style="width:100%;">
                    <option value="Stkio">有單據號碼</option>
                    <option selected="selected" value="Cost">無單據號碼</option>
                </select>
            </td>
        </tr>
        <tr class="Stkio" style="display:none;">
            <td style="text-align: right; text-wrap: none; width: 10%;">訂單號碼</td>
            <td style="text-align: left; width: 15%;">
                <input Request_ColName="訂單號碼" id="TB_ORD_No" style="width: 100%" />
            </td>
            <td style="text-align: left; width: 15%;" colspan="2">
                <input class="disabled" id="RB_Hint" type="radio" checked disabled />
                <label for="RB_Hint">出庫</label>
            </td>
            <%--等待/歷史/全部--%>
            <%--<td style="text-align: right; text-wrap: none; width: 10%;">單據編號</td>
            <td style="text-align: left; width: 15%;">
                <input Request_ColName="單據編號" id="TB_PM_No" style="width: 100%" placeholder="PM_No" />
            </td>--%>
        </tr>
        <tr>
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
            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Sale_Model%></td>
            <td style="text-align: left; width: 15%;">
                <input Request_ColName="銷售型號" id="TB_SaleM" autocomplete="off" style="width: 100%;" />
            </td>
            <td style="text-align: right; text-wrap: none; width: 10%;">條碼樣式</td>
            <td style="text-align: left; width: 15%;">
                <select Request_ColName="條碼樣式" id="DDL_Barcode_Type" style="width: 100%;height:28.5px;"></select>
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
        <input id="V_BT_Print" type="button" class="V_BT Exist_Select V_Edit" style="display:none;" value="列印" />
        <input id="V_BT_Sample" type="button" class="V_BT Exist_Select V_Edit" style="display:none;" value="<%=Resources.MP.Sample%>" />
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
            <span class="dataTables_info" id="Table_Search_Barcode_info" role="status" aria-live="polite"></span>
            <table id="Table_Search_Barcode" style="width: 99%;" class="table table-striped table-bordered">
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
            <div class="search_section_control" control_by="V_BT_Print" id="Div_Print_Area">
                <div style="width: 99%; margin: 0 auto; background-color: white;">
                    &nbsp;
                    <input id="DPA_V_BT_Barcode" type="button" class="DPA_V_BT" value="條碼" disabled="disabled" />
                    <input id="DPA_V_BT_Setup" type="button" class="DPA_V_BT" value="設定" />
                    <input id="DPA_V_BT_Member" type="button" class="DPA_V_BT" value="會員條碼" />
                </div>
                <div id="DPA_Div_Barcode" dpa_control_by="DPA_V_BT_Barcode" style="height: 60vh; overflow: auto; border-style: solid; border-width: 1px;">
                    <table style="border-collapse: separate; border-spacing: 0px 8px; margin: 0 auto; width: 100%;">
                        <tr>
                            <td colspan="2" style="text-align:center;">
                                <span>列印筆數：</span>
                                <span id="DPAB_P_C"></span>
                            </td>
                        </tr>
                        <tr>
                            <td style="width:20%;text-align:right;">速度</td>
                            <td style="width:30%;text-align:left;">
                                <input />
                            </td>
                        </tr>
                        <tr>
                            <td style="width:20%;text-align:right;">濃暗</td>
                            <td style="width:30%;text-align:left;">
                                <input type="number" min="-10" max="10" step="1" value="0" />
                            </td>
                        </tr>
                        <tr>
                            <td style="width:20%;text-align:right;">條碼樣式</td>
                            <td style="width:30%;text-align:left;">
                                <input />
                            </td>
                        </tr>
                        <tr>
                            <td style="width:20%;text-align:right;">印表機</td>
                            <td style="width:30%;text-align:left;">
                                <select>
                                    <option value="192.168.1.31">192.168.1.31(內湖_IT)</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <input type="checkbox" />
                                <label>轉換成博客來條碼</label>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <input type="checkbox" />
                                <label>印型號結束標籤</label>
                            </td>
                        </tr>
                    </table>
                </div>
                <div id="DPA_Div_Setup" dpa_control_by="DPA_V_BT_Setup" style="display:none;height: 60vh; overflow: auto; border-style: solid; border-width: 1px;">
                    設定
                </div>
                <div id="DPA_Div_Member" dpa_control_by="DPA_V_BT_Member" style="display:none;height: 60vh; overflow: auto; border-style: solid; border-width: 1px;">
                    會員條碼
                </div>
                <div style="width: 100%; text-align: center;">
                    <input id="BT_Print" type="button" class="BTN" style="display: inline-block;" value="列印條碼" />
                </div>
            </div>

            <div class="search_section_control" control_by="V_BT_Sample" style="display: none;">
                <table style="border-collapse: separate; border-spacing: 0px 8px; margin: 0 auto; width: 80%;">
                    <tr>
                        <td style="background-color: #90ee90; width: 20%"></td>
                        <td style="text-align: left;">有圖檔</td>
                    </tr>
                    <tr>
                        <td style="background-color: hotpink; width: 20%"></td>
                        <td style="text-align: left;">資料不齊</td>
                    </tr>
                    <tr>
                        <td style="background-color: gold; width: 20%"></td>
                        <td style="text-align: left;">條碼IV02</td>
                    </tr>
                    <tr>
                        <td style="background-color: aqua; width: 20%"></td>
                        <td style="text-align: left;">條碼IV06</td>
                    </tr>
                    <tr>
                        <td style="background-color: chocolate; width: 20%"></td>
                        <td style="text-align: left;">條碼IV07</td>
                    </tr>
                    <tr>
                        <td style="background-color: burlywood; width: 20%"></td>
                        <td style="text-align: left;">條碼印價</td>
                    </tr>
                </table>
            </div>
        </div>
    </div>

    <br />
    <br />
</asp:Content>
