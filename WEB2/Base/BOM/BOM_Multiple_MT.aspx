<%@ Page Title="BOM Multiple Maintenance" Language="C#" MasterPageFile="~/MP.master" AutoEventWireup="true" %>
<%@ Register TagPrefix="uc1" TagName="uc1" Src="~/User_Control/Dia_Supplier_Selector.ascx" %>
<%@ Register TagPrefix="uc2" TagName="uc2" Src="~/User_Control/Dia_Product_ALL.ascx" %>
<%@ Register TagPrefix="uc3" TagName="uc3" Src="~/User_Control/Dia_Product_Selector.ascx" %>

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
            var Supplier_Selector_Type;
            var Click_tr_IDX;
            document.body.style.overflow = 'hidden';
            //Form_Mode_Change("Search");//WD
            //Search_BOM();//WD

            $('#BT_Supplier_Selector_M').on('click', function () {
                $("#Search_Supplier_Dialog").dialog('open');
                Supplier_Selector_Type = "M";
            });

            $('#BT_Supplier_Selector_EP').on('click', function () {
                $("#Search_Supplier_Dialog").dialog('open');
                Supplier_Selector_Type = "EP";
            });

            $('#SSD_Table_Supplier').on('click', '.SUP_SEL', function () {
                switch (Supplier_Selector_Type) {
                    case "M":
                        $('#TB_M_S_No').val($(this).parent().parent().find('td:nth(2)').text());
                        $('#TB_M_S_SName').val($(this).parent().parent().find('td:nth(3)').text());
                        break;
                    case "EP":
                        $('#TB_EP_S_No').val($(this).parent().parent().find('td:nth(2)').text());
                        $('#TB_EP_S_SName').val($(this).parent().parent().find('td:nth(3)').text());
                        break;
                }
                $("#Search_Supplier_Dialog").dialog('close');
            });

            $('#DNT_BT_Product_Selector').on('click', function () {
                $("#Search_Product_Dialog").dialog('open');
            });

            $('#SPD_Table_Product').on('click', '.PROD_SEL', function () {
                $('#DNT_HDN_SUPLU_SEQ').val($(this).parent().parent().find('td:nth(1)').text());
                $('#DNT_TB_IM').val($(this).parent().parent().find('td:nth(3)').text());
                $('#DNT_TB_S_ALL').val($(this).parent().parent().find('td:nth(5)').text());
                $('#DNT_TB_P_IM').val($(this).parent().parent().find('td:nth(7)').text());
                $("#Search_Product_Dialog").dialog('close');
            });

            $('#BT_Edit').on('click', function () {
                var Exec_SEQ = '';
                $('#Table_Exec_Data tbody tr .SEQ').each(function (i) {
                    if (i > 0) {
                        Exec_SEQ += ',';
                    }
                    Exec_SEQ += $(this).text();
                });

                if ($('#DNT_HDN_SUPLU_SEQ').val().length > 0) {
                    var Update_Check = true;
                    if ($('#Table_Exec_Data tbody tr .D_SUPLU_SEQ').filter(function () { return $(this).attr('SUPLU_SEQ') != $('#DDT_HDN_D_SUPLU_SEQ').val(); }).length > 0) {
                        Update_Check = confirm('選取材料有不同，確定一併更新？');
                    }
                    if (Update_Check) {
                        $.ajax({
                            url: "/Base/BOM/BOM_MMT.ashx",
                            data: {
                                "Call_Type": "BOM_MMT_Update",
                                "SEQ_Array": Exec_SEQ,
                                "New_D_SUPLU_SEQ": $('#DNT_HDN_SUPLU_SEQ').val(),
                                "Update_User": "<%=(Session["Account"] == null) ? "Ivan10" : Session["Name"].ToString().Trim() %>"
                            },
                            cache: false,
                            async: false,
                            type: "POST",
                            datatype: "json",
                            contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                            success: function (R) {
                                alert(Exec_SEQ + ' > 已Update');
                                $('#Table_Exec_Data').html('');
                                $('#Table_Exec_Data_info').text('Showing 0 entries');
                                Form_Mode_Change("Search");
                                Search_BOM();
                            },
                            error: function (ex) {
                                alert(ex);
                            }
                        });
                    }
                }
                else {
                    alert('請選擇變更後的新材料');
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
                        $('#Div_DT_View').css('width', '60%');
                        $('#Div_Exec_Data').css('width', '35%');
                        $('#Div_Exec_Data').css('float', 'Right');
                        Click_tr_IDX = null;
                        $('#Table_Exec_Data tbody tr').css('background-color', '');
                        $('#Table_Exec_Data tbody tr').css('color', 'black');
                        break;
                    //case "Review_Data"://WD
                    //    Edit_Mode = "Edit";
                    //    $('.V_BT').attr('disabled', false);
                    //    //$('#V_BT_Review').attr('disabled', 'disabled');
                    //    $('#Div_DT_View, #Div_Data_Control, #Div_Edit_Area').toggle(false);
                    //    $('#Div_Exec_Data').css('width', '100%');
                    //    $('#Div_Exec_Data').css('float', 'Right');
                    //    break;
                    case "Edit_Data":
                        Edit_Mode = "Edit";
                        $('.V_BT').attr('disabled', false);
                        $('#V_BT_Edit').attr('disabled', 'disabled');
                        $('#Div_DT_View, #Div_Data_Control').toggle(false);
                        $('#Div_Edit_Area').toggle(true);
                        $('#Div_Exec_Data').css('width', '60%');
                        $('#Div_Exec_Data').css('float', 'left');
                        $('#Div_Edit_Area').css('width', '39%');
                        break;
                }
            }

            $('#BT_Search').on('click', function () {
                Form_Mode_Change("Search");
                Search_BOM();
            });

            $('.V_BT').on('click', function () {
                $('.V_BT').attr('disabled', false);
                $(this).attr('disabled', 'disabled');
            });

            //$('.V_Report').on('click', function () {
            //    Form_Mode_Change("Edit_Data");
            //    $('[Control_By]').toggle(false);
            //    $('[Control_By=' + $(this).prop('id') + ']').toggle(true);
            //});

            function Search_BOM() {
                $.ajax({
                    url: "/Base/BOM/BOM_MMT.ashx",
                    data: {
                        "Call_Type": "BOM_MMT_Search",
                        "MM": $('#TB_MM').val(),
                        "EPM": $('#TB_EPM').val(),
                        "M_S_No": $('#TB_M_S_No').val(),
                        "M_S_SName": $('#TB_M_S_SName').val(),
                        "EP_S_No": $('#TB_EP_S_No').val(),
                        "EP_S_SName": $('#TB_EP_S_SName').val()
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
                                '<thead><tr>'
                                + '</th><th>' + '<%=Resources.MP.Supplier_Short_Name%>'
                                + '</th><th>' + '<%=Resources.MP.Material_Model%>'
                                + '</th><th>' + '<%=Resources.MP.Master_Supplier_S_Name%>'
                                + '</th><th>' + '<%=Resources.MP.End_Product_Model%>'
                                + '</th><th>' + '<%=Resources.MP.Unit%>'
                                + '</th><th>' + '<%=Resources.MP.Material_Amount%>'
                                + '</th><th>' + '<%=Resources.MP.Rank%>'
                                + '</th><th class="DIMG">' + '<%=Resources.MP.Material%><%=Resources.MP.Speace%><%=Resources.MP.Image%>'
                                + '</th><th class="DIMG">' + '<%=Resources.MP.End_Product%><%=Resources.MP.Speace%><%=Resources.MP.Image%>'
                                + '</th><th>' + '<%=Resources.MP.Product_Information%>'
                                + '</th><th>' + '<%=Resources.MP.Supplier_No%>'
                                + '</th><th>' + '<%=Resources.MP.Final_Supplier%>'
                                + '</th><th>' + '<%=Resources.MP.SEQ%>'
                                + '</th><th>' + '<%=Resources.MP.Update_User%>'
                                + '</th><th>' + '<%=Resources.MP.Update_Date%>'
                                + '</th></tr></thead><tbody>';
                            $(R).each(function (i) {
                                Table_HTML +=
                                    '<tr><td>' + String(R[i].廠商簡稱 ?? "") +
                                    '</td><td><input class="Call_Product_Tool D_SUPLU_SEQ" SUPLU_SEQ = "' + String(R[i].D_SUPLU_SEQ ?? "")
                                    + '" type="button" value="' + String(R[i].材料型號 ?? "")
                                    + '" style="text-align:left;width:100%;z-index:1000;' + ((R[i].D_Has_IMG) ? 'background: #90ee90;' : '') + '" />' +
                                    '</td><td>' + String(R[i].完成者簡稱 ?? "") +
                                    '</td><td><input class="Call_Product_Tool" SUPLU_SEQ = "' + String(R[i].SUPLU_SEQ  ?? "")
                                    + '" type="button" value="' + String(R[i].頤坊型號 ?? "")
                                    + '" style="text-align:left;width:100%;z-index:1000;' + ((R[i].Has_IMG) ? 'background: #90ee90;' : '') + '" />' +
                                    '</td><td>' + String(R[i].單位 ?? "") +
                                    '</td><td style="text-align:right;">' + String(R[i].材料用量 ?? "") +
                                    '</td><td>' + String(R[i].階層 ?? "") +
                                    '</td><td class="DIMG" style="text-align:center; height:100px; vertical-align:middle;">' +
                                        ((R[i].D_Has_IMG) ? ('<img type="Product" SEQ="' + String(R[i].D_SUPLU_SEQ ?? "") + '" />') : ('<%=Resources.MP.Image_NotExists%>')) +
                                    '</td><td class="DIMG" style="text-align:center; height:100px; vertical-align:middle;">' +
                                        ((R[i].Has_IMG) ? ('<img type="Product" SEQ="' + String(R[i].SUPLU_SEQ ?? "") + '" />') : ('<%=Resources.MP.Image_NotExists%>')) +
                                    '</td><td>' + String(R[i].產品說明 ?? "") +
                                    '</td><td>' + String(R[i].廠商編號 ?? "") +
                                    '</td><td>' + String(R[i].最後完成者 ?? "") +
                                    '</td><td class="SEQ">' + String(R[i].序號 ?? "") +//Class辨別左右全移
                                    '</td><td>' + String(R[i].更新人員 ?? "") +
                                    '</td><td>' + String(R[i].更新日期 ?? "") +
                                    '</td></tr>';
                            });

                            Table_HTML += '</tbody>';
                            $('#Table_Search_BOMD').html(Table_HTML);

                            $('.DIMG').toggle(!$('#RB_DV_DIMG').prop('checked'));
                            $('#Table_Search_BOMD_info').text('Showing ' + $('#Table_Search_BOMD > tbody tr').length + ' entries');
                            IMG_Has_Read = false;//初始化IMG讀取

                            $('#Table_Search_BOMD').css('white-space', 'nowrap');
                            $('#Table_Search_BOMD thead th').css('text-align', 'center');
                            $('#Table_Search_BOMD tbody td').css('vertical-align', 'middle');

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
                if (Show_IMG && !IMG_Has_Read) {
                    FN_GET_IMG($('#Table_Exec_Data img[type=Product]'));
                    FN_GET_IMG($('#Table_Search_BOMD img[type=Product]'));
                }
                function FN_GET_IMG(IMG) {//取得順序調整，Exec優先
                    $(IMG).each(function (i) {
                        var IMG_SEL = $(this);
                        var binary = '';
                        $.ajax({
                            url: "/Base/BOM/BOM_Search.ashx",
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

            $('#BT_Next, #V_BT_Edit').on('click', function () {
                //Form_Mode_Change("Review_Data");//Pass
                Form_Mode_Change("Edit_Data");
                Click_tr_IDX = 0;
                FN_Tr_Click($('#Table_Exec_Data tbody tr:nth(' + Click_tr_IDX + ')'));
            });

            $('#V_BT_Master').on('click', function () {
                Form_Mode_Change("Search");
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
                    $('#Table_Search_BOMD_info').text('Showing ' + $('#Table_Search_BOMD > tbody tr').length + ' entries');

                    $('.Exist_Select').toggle(Boolean($('#Table_Exec_Data').find('tbody tr').length > 0));

                    Re_Bind_Inner_JS();
                }
            }

            $('#Table_Search_BOMD').on('click', 'tbody tr', function () {
                Item_Move($(this), $('#Table_Exec_Data'), $('#Table_Search_BOMD'), false);
            });
            $('#Table_Exec_Data').on('click', 'tbody tr', function () {
                switch (Edit_Mode) {
                    case "Can_Move":
                        Item_Move($(this), $('#Table_Search_BOMD'), $('#Table_Exec_Data'), false);
                        break;
                    case "Edit":
                        Click_tr_IDX = $(this).index();
                        FN_Tr_Click($(this));
                        break;
                }
            });
            $('#BT_ATR').on('click', function () {
                Item_Move($(this), $('#Table_Exec_Data'), $('#Table_Search_BOMD'), true);
            });
            $('#BT_ATL').on('click', function () {
                Item_Move($(this), $('#Table_Search_BOMD'), $('#Table_Exec_Data'), true);
            });

            $(window).keydown(function (e) {
                if (Click_tr_IDX != null) {
                    switch (e.keyCode) {
                        case 38://^
                            if (Click_tr_IDX > 0) {
                                Click_tr_IDX -= 1;
                            }
                            FN_Tr_Click($('#Table_Exec_Data tbody tr:nth(' + Click_tr_IDX + ')'));
                            break;
                        case 40://v
                            if (Click_tr_IDX < ($('#Table_Exec_Data tbody tr').length - 1)) {
                                Click_tr_IDX += 1;
                            }
                            FN_Tr_Click($('#Table_Exec_Data tbody tr:nth(' + Click_tr_IDX + ')'));
                            break;
                    }
                }
            });

            function FN_Tr_Click(Click_tr) {
                Click_tr.parent().find('tr').css('background-color', '');
                Click_tr.parent().find('tr').css('color', 'black');
                Click_tr.css('background-color', '#5a1400');
                Click_tr.css('color', 'white');

                $('#DOT_TB_IM').val(Click_tr.find('td').eq(1).find('input').val());
                $('#DDT_HDN_D_SUPLU_SEQ').val(Click_tr.find('td').eq(1).find('input').attr('SUPLU_SEQ'));
                $('#DOT_TB_S_ALL').val(Click_tr.find('td').eq(0).text());
                $('#DOT_TB_PI').val(Click_tr.find('td').eq(9).text());
            };

            $('#Table_Search_BOMD, #Table_Exec_Data').on('click', 'thead th', function () {//Sort
                $(this).siblings().removeClass('focus');
                $(this).addClass('focus');

                var Sort_Table = $(this).parents('table');
                var IDX = $(this).index();

                if ($(this).is('.asc')) {
                    $(this).removeClass('asc');
                    $(this).addClass('desc selected');
                    sortOrder = -1;
                } else {
                    $(this).addClass('asc selected');
                    $(this).removeClass('desc');
                    sortOrder = 1;
                }
                $(this).siblings().removeClass('asc selected desc selected');
                var arrData = Sort_Table.find('tbody>tr:has(td)').get();
                console.warn($(this).text());

                arrData.sort(function (a, b) {
                    var val1 = $(a).children('td').eq(IDX).text(); 
                    if (val1.length == 0) {
                        val1 = $(a).children('td').eq(IDX).find('input').val();
                    }
                    
                    var val2 = $(b).children('td').eq(IDX).text();
                    if (val2.length == 0) {
                        val2 = $(b).children('td').eq(IDX).find('input').val();
                    }

                    if ($.isNumeric(val1) && $.isNumeric(val2))
                        return sortOrder == 1 ? val1 - val2 : val2 - val1;
                    else
                        return (val1 < val2) ? -sortOrder : (val1 > val2) ? sortOrder : 0;
                });
                $.each(arrData, function (index, row) {
                    Sort_Table.find('tbody').append(row);
                });
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
        #Table_Search_BOMD tbody tr:hover, #Table_Exec_Data tbody tr:hover{
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

    <table class="table_th" style="text-align: left;">
        <tr>
            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Material_Model%></td>
            <td style="text-align: left; width: 15%;">
                <input id="TB_MM" autocomplete="off" style="width: 100%;" />
            </td>
            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.End_Product_Model%></td>
            <td style="text-align: left; width: 15%;">
                <input id="TB_EPM" autocomplete="off" style="width: 100%;" />
            </td>
            <td style="text-align: right; text-wrap: none; width: 10%;display:none;"></td>
            <td style="text-align: left; width: 15%;display:none;"></td>
            <td style="text-align: right; text-wrap: none; width: 10%;display:none;"></td>
            <td style="text-align: left; width: 15%;display:none;"></td>

            <td></td><td></td>
        </tr>
        <tr>
            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Material%><%=Resources.MP.Speace%><%=Resources.MP.Supplier%></td>
            <td style="text-align: left; width: 15%;">
                <div style="width: 90%; float: left; z-index: -10;">
                    <input id="TB_M_S_No" style="width: 100%; z-index: -10;" />
                    <br />
                    <input id="TB_M_S_SName" style="width: 111%; z-index: -10;" />
                </div>
                <div style="width: 10%; float: right; z-index: 10;">
                    <input id="BT_Supplier_Selector_M" type="button" value="…" style="float: right; z-index: 10; width: 100%;" />
                </div>
            </td>
            
            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Final_Supplier%></td>
            <td style="text-align: left; width: 15%;">
                <div style="width: 90%; float: left; z-index: -10;">
                    <input id="TB_EP_S_No" style="width: 100%; z-index: -10;" />
                    <br />
                    <input id="TB_EP_S_SName" style="width: 111%; z-index: -10;" />
                </div>
                <div style="width: 10%; float: right; z-index: 10;">
                    <input id="BT_Supplier_Selector_EP" type="button" value="…" style="float: right; z-index: 10; width: 100%;" />
                </div>
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
        <%--<input id="V_BT_Review" type="button" class="V_BT Exist_Select" style="display:none;" value="TTT" />--%>
        <input id="V_BT_Edit" type="button" class="V_BT Exist_Select" style="display:none;" value="<%=Resources.MP.Material_Model%><%=Resources.MP.Speace%><%=Resources.MP.Edit%>" />
        <%--<input id="V_BT_Report_1" type="button" class="V_BT Exist_Select V_Report" style="display:none;" value="成本分析" />--%>
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
        <div id="Div_DT_View" style="width: 60%; height: 65vh; overflow: auto; display: none; float: left;border-style:solid;border-width:1px; ">
            <span class="dataTables_info" id="Table_Search_BOMD_info" role="status" aria-live="polite"></span>
            <table id="Table_Search_BOMD" style="width: 99%;" class="table table-striped table-bordered">
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
                        <input id="BT_Next" type="button" value="Next" style="inline-size: 100%; display: none;" class="BTN Exist_Select" />
                    </td>
                </tr>
            </table>
        </div>

        <div id="Div_Exec_Data" style="width: 35%; height: 65vh; overflow: auto; display: none; float: right;border-style:solid;border-width:1px; ">
            <span class="dataTables_info" id="Table_Exec_Data_info" role="status" aria-live="polite"></span>
            <table id="Table_Exec_Data" style="width: 100%;" class="table table-striped table-bordered">
                <thead></thead>
                <tbody></tbody>
            </table>
        </div>

        <div id="Div_Edit_Area" style="width: 35%; height: 65vh; overflow: auto; display: none; float: right;border-style:solid;border-width:1px;">
            <div class="search_section_control"><%--control_by="V_BT_Report_1" style="display: none;"--%>
                <div style="position: relative; border: 1px solid #111111; padding: 20px; box-sizing: border-box; margin: 30px auto; width: 90%;background-color:silver;">
                    <span style="position: absolute; top: -1em; left: 10%; line-height: 2em; padding: 0 1em; background-color: #fff;"><%=Resources.MP.Old%><%=Resources.MP.Speace%><%=Resources.MP.Material%></span>
                    <table style="border-collapse: separate; border-spacing: 0px 8px; margin: 0 auto; width: 100%;" id="DEA_Old_Table">
                        <tr>
                            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Old%><%=Resources.MP.Speace%><%=Resources.MP.Material%></td>
                            <td style="text-align: left; width: 15%;">
                                <input style="width: 80%;" id="DOT_TB_IM" class="disable" disabled="disabled" />
                                <input type="hidden" id="DDT_HDN_D_SUPLU_SEQ" />
                            </td>
                            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Old%><%=Resources.MP.Speace%><%=Resources.MP.Material_Supplier_ALL%></td>
                            <td style="text-align: left; width: 15%;">
                                <input style="width: 100%;" id="DOT_TB_S_ALL" class="disable" disabled="disabled" />
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Old%><%=Resources.MP.Speace%><%=Resources.MP.Product_Information%></td>
                            <td style="text-align: left; width: 15%;" colspan="4">
                                <input id="DOT_TB_PI" class="disable" disabled="disabled" style="width: 100%;" />
                            </td>
                        </tr>
                    </table>
                </div>
                <div style="position: relative; border: 1px solid #111111; padding: 20px; box-sizing: border-box; margin: 30px auto; width: 90%;">
                    <span style="position: absolute; top: -1em; left: 10%; line-height: 2em; padding: 0 1em; background-color: #fff;"><%=Resources.MP.New%><%=Resources.MP.Speace%><%=Resources.MP.Material%></span>
                    <table style="border-collapse: separate; border-spacing: 0px 8px; margin: 0 auto; width: 100%;" id="DEA_New_Table">
                        <tr>
                            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.New%><%=Resources.MP.Speace%><%=Resources.MP.Material%></td>
                            <td style="text-align: left; width: 15%;">
                                <div style="width: 80%; float: left; z-index: -10;">
                                    <input id="DNT_TB_IM" class="disable" autocomplete="off" disabled="disabled" style="width: 100%; z-index: -10;" />
                                </div>
                                <div style="width: 20%; float: right; z-index: 10;">
                                    <input id="DNT_BT_Product_Selector" type="button" value="…" style="float: right; z-index: 10;" />
                                </div>
                                <input type="hidden" id="DNT_HDN_SUPLU_SEQ" />
                            </td>
                            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.New%><%=Resources.MP.Speace%><%=Resources.MP.Material_Supplier_ALL%></td>
                            <td style="text-align: left; width: 15%;">
                                <input id="DNT_TB_S_ALL" class="disable" disabled="disabled" style="width: 100%;" />
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Product_Information%></td>
                            <td style="text-align: left; width: 15%;" colspan="7">
                                <input id="DNT_TB_P_IM" class="disable" disabled="disabled" style="width: 100%;" />
                            </td>
                        </tr>
                    </table>

                </div>
            </div>
            <br />
            <div style="width: 100%; text-align: center;">
                <input id="BT_Edit" type="button" class="BTN" style="display:inline-block;" value="<%=Resources.MP.Edit%>" />
            </div>
        </div>
    </div>

    <br />
    <br />
</asp:Content>
