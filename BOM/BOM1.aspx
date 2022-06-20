<%@ Page Title="BOM Maintenance" Language="C#" MasterPageFile="~/MP.master" AutoEventWireup="true" CodeFile="BOM1.aspx.cs" Inherits="BOM_BOM1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <link href="/css/dataTables.bootstrap4.min.css" rel="stylesheet" />
    <script src="/js/jquery.dataTables.min.js"></script>
    <script src="/js/dataTables.bootstrap4.min.js"></script>

    <script type="text/javascript">
        $(document).ready(function () {
            var Edit_Mode;
            var Dialog_Control;
            Dialog();
            ATC();

            window.document.body.onbeforeunload = function () {
                if (Edit_Mode === "Edit") {
                    return '您尚未將編輯過的表單資料送出，請問您確定要離開網頁嗎？';
                }
            }
            function Form_Mode_Change(Form_Mode) {
                switch (Form_Mode) {
                    case "Base":
                        $('#BT_New, #BT_Search, #BT_Detail_Search').css('display', '');
                        $('#BT_New_Save, #BT_Cancel').css('display', 'none');

                        $('.M2_For_U, .M2_For_N').css('display', 'none');
                        $('#Div_DT_View').css('display', 'none');
                        $('#V_BT_Master').attr('disabled', 'disabled');

                        $('.V_BT').not($('#V_BT_Master')).attr('disabled', false);
                        $('.V_BT').not($('#V_BT_Master')).css('display', 'none');

                        $('.Div_D, #Div_DT_View2').css('display', 'none');
                        $('#Div_M2').css('display', '')
                        $('#Table_Search_BOM_D').html('');

                        $('#Div_Detail_Form table input, textarea').not('[type=button], #TB_Dia_Where, [type=number]').val('');
                        $('#Div_Detail_Form table input[type=number]').val(0);
                        $('.ED_BT').css('display', 'none');
                        $('#TB_M2_Remark, #BT_M2_Product_Selector').attr('disabled', 'disabled');

                        break;
                    case "New_M":
                        $('#BT_Cancel, #BT_New_Save').css('display', '');
                        $('.M_BT').not($('#BT_Cancel')).css('display', 'none');
                        $('.M2_For_N').css('display', '');
                        $('#TB_M2_Remark, #BT_M2_Product_Selector').attr('disabled', false);
                        $('.ED_BT').css('display', 'none');

                        break;
                    case "Search_M":
                        $('#BT_Cancel').css('display', '');
                        $('.M_BT').not($('#BT_Cancel')).css('display', 'none');
                        $('#Div_DT_View').css('display', '');
                        $('.V_BT').css('display', '');
                        $('#TB_M2_Remark').attr('disabled', 'disabled');
                        $('.ED_BT, #Div_DT_View2').css('display', 'none');

                        $('#Div_Detail_Form table input, textarea').not('[type=button], #TB_Dia_Where, [type=number]').val('');
                        break;
                    case "Search_D":
                        $('.M2_For_U').css('display', '');
                        $('#TB_M2_Remark, .D_4Check').attr('disabled', 'disabled');
                        $('#BT_ED_Edit, #BT_ED_Copy, #BT_Cancel, #Div_DT_View').css('display', '');
                        $('#BT_ED_Save, #BT_ED_Cancel').css('display', 'none');
                        $('#Div_DT_View2').css('display', '');

                        $('#Table_Search_BOM_D tr').not(':nth(0), .0_Child, .-1_Child').toggle(false);
                        $('.D_T_For_U, .U_M_Amount').toggle(false);
                        $('#Table_Search_BOM_D .Expand, .V_M_Amount').toggle(true);
                        $('#Table_Search_BOM_D .Expand').text('+');
                        break;
                    case "Edit_M":
                        $('#BT_ED_Edit, #BT_ED_Copy, #BT_Cancel, #Div_DT_View').css('display', 'none');
                        $('#BT_ED_Save, #BT_ED_Cancel').css('display', '');
                        $('#TB_M2_Remark, .D_4Check').attr('disabled', false);

                        $('#Table_Search_BOM_D tr').toggle(true);
                        $('.D_T_For_U, .U_M_Amount').toggle(true);
                        $('#Table_Search_BOM_D .Expand, .V_M_Amount').toggle(false);
                        break;
                }
            }

            function New_Save_Check() {
                if ($('#TB_M2_IM').val().length === 0) {
                    alert('<%=Resources.MP.Select_Product_Alert%>');;
                    return false;
                }
                return true;
            };

            $('#BT_New').on('click', function () {
                Edit_Mode = "Edit";
                Form_Mode_Change("New_M");
            });


            $('#BT_New_Save').on('click', function () {
                if (confirm("<%=Resources.MP.Save_Alert%>")) {
                    if (New_Save_Check()) {
                        $.ajax({
                            url: "/BOM/BOM_Save.ashx",
                            data: {
                                "P_SEQ": $('#HDN_M2_P_SEQ').val(),
                                "IM": $('#TB_M2_IM').val(),
                                "DVN": $('#HDN_M2_DVN').val(),
                                "S_No": $('#TB_M2_FNS').val(),
                                "S_SName": $('#TB_M2_FNS_SName').val(),
                                "Remark": $('#TB_M2_Remark').val(),
                                "Call_Type": "BOM_New"
                            },
                            cache: false,
                            type: "POST",
                            datatype: "json",
                            contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                            success: function (response) {
                                //console.warn(response);
                                if (String(response).indexOf("UNIQUE KEY") > 0) {
                                    alert(response);
                                }
                                else {
                                    alert("<%=Resources.MP.Add_Success%>");
                                    Edit_Mode = "Save";
                                    Form_Mode_Change("Base");
                                }
                            },
                            error: function (ex) {
                                alert(ex);
                                return false;
                            }
                        });
                    }
                }
            });

            $('#BT_Search').on('click', function () {
                Edit_Mode = "Search";
                Form_Mode_Change("Search_M");
                Search_BOM_M();
            });

            $('#BT_Cancel').on('click', function () {
                var Confirm_Check = true;
                if (Edit_Mode == "Edit") {
                    Confirm_Check = confirm("<%=Resources.MP.Cancel_Alert%>");
                }
                if (Confirm_Check) {
                    Edit_Mode = "Base";
                    Form_Mode_Change("Base");
                }
            });

            $('#BT_Detail_Search').on('click', function () {
                $("#dialog").dialog('open');
            });

            function Search_BOM_M(Search_Where) {
                $.ajax({
                    url: "/BOM/BOM_Search.ashx",
                    data: {
                        "Call_Type": "BOM1_Search",
                        "Search_Where": Search_Where ?? ""
                    },
                    cache: false,
                    type: "POST",
                    datatype: "json",
                    contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                    success: function (response) {
                        $('#Table_Search_BOM').DataTable({
                            "data": response,
                            "destroy": true,
                            "order": [[8, "desc"]],
                            "lengthMenu": [
                                [5, 10, 20, -1],
                                [5, 10, 20, "All"],
                            ],
                            "columns": [
                                { data: "P_SEQ", title: "<%=Resources.BOM.P_SEQ%>" },
                                { data: "SEQ", title: "<%=Resources.BOM.M_SEQ%>" },
                                { data: "IM", title: "<%=Resources.BOM.Ivan_Model%>" },
                                { data: "DVN", title: "<%=Resources.BOM.Developing%>" },
                                { data: "F_S_No", title: "<%=Resources.BOM.Final_Supplier%>" },
                                { data: "F_S_SName", title: "<%=Resources.BOM.Supplier_Short_Name%>" },
                                { data: "Mark", title: "<%=Resources.BOM.Mark%>" },
                                { data: "Update_User", title: "<%=Resources.BOM.Update_User%>" },
                                { data: "Update_Date", title: "<%=Resources.BOM.Update_Date%>" }
                            ],
                        });
                        $('#Table_Search_BOM').css('white-space','nowrap');
                        $('#Table_Search_BOM thead th').css('text-align','center');
                        $('#Table_Search_BOM').on('click', 'tbody tr', function () {
                            Table_Tr_Click($(this));
                        });
                    },
                    error: function (ex) {
                        alert(ex);
                    }
                });
            };

            $('#BT_ED_Edit').on('click', function () {
                Edit_Mode = "Edit";
                Form_Mode_Change("Edit_M");
            });

            $('#Table_Search_BOM_D').on('change', '.U_M_Amount, .D_4Check', function () {
                $(this).parent().parent().attr('Has_Change', '1');
            });

            $('#BT_ED_Save').on('click', function () {
                if (confirm("<%=Resources.MP.Edit_Alert%>")) {
                    //BOM_M_Save
                    var P_SEQ = $('#TB_M2_P_SEQ').val();
                    $.ajax({
                        url: "/BOM/BOM_Save.ashx",
                        data: {
                            "P_SEQ": P_SEQ,
                            "Remark": $('#TB_M2_Remark').val(),
                            "Call_Type": "BOM_M_Save"
                        },
                        cache: false,
                        type: "POST",
                        datatype: "json",
                        contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                        success: function (response) {
                            //Detail_Updpate
                            if ($('#Table_Search_BOM_D tr[Has_Change=1]').length > 0) {
                                $('#Table_Search_BOM_D tr[Has_Change=1]').each(
                                    function () {
                                        var D_SEQ = $(this).find('td:nth(1)').text().trim();
                                        var M_Amount = $(this).find('.U_M_Amount').val() ?? 1;//Rank1為Null
                                        var MS = $(this).find('.D_4Check[name=MS]').prop('checked');
                                        var NB = $(this).find('.D_4Check[name=NB]').prop('checked');
                                        var NE = $(this).find('.D_4Check[name=NE]').prop('checked');
                                        var NCC = $(this).find('.D_4Check[name=NCC]').prop('checked');
                                        //console.warn(D_SEQ);

                                        $.ajax({
                                            url: "/BOM/BOM_Save.ashx",
                                            data: {
                                                "D_SEQ": D_SEQ,
                                                "M_Amount": M_Amount,
                                                "MS": MS,
                                                "NB": NB,
                                                "NE": NE,
                                                "NCC": NCC,
                                                "Call_Type": "BOM_D_Save"
                                            },
                                            cache: false,
                                            type: "POST",
                                            datatype: "json",
                                            contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                                            success: function (response) {},
                                            error: function (ex) {
                                                alert(ex);
                                                return false;
                                            }
                                        });
                                    });
                            }
                            alert("<%=Resources.MP.Update_Success%>");
                            Search_BOM_D(P_SEQ,'');//Re-Search總計金額
                            Edit_Mode = "Edit_Save";
                            Form_Mode_Change("Search_D");
                        },
                        error: function (ex) {
                            alert(ex);
                            return false;
                        }
                    });

                }
            });

            $('#BT_ED_Copy').on('click', function () {
                $('#CD_TB_OLD_SEQ').val($('#TB_M2_M_SEQ').val());
                $('#CD_TB_OLD_IM').val($('#TB_M2_IM').val());
                $('#CD_TB_OLD_Supplier').val($('#TB_M2_FNS').val() + '-' + $('#TB_M2_FNS_SName').val());
                $('#CD_TB_OLD_P_IM').val($('#Table_Search_BOM_D td:contains(' + $('#TB_M2_IM').val() + ')').parent().find(':nth-child(10)').text().trim());
                $("#Copy_Dialog").dialog({
                    modal: true,
                    title: "<%=Resources.MP.Copy%><%=Resources.MP.Speace%>BOM",
                    width: screen.width * 0.8,
                    overlay: 0.5,
                    position: { my: "center", at: "top" },
                    focus: true,
                    buttons: {
                        "Copy": function () {
                            var Old_P_SEQ = $('#TB_M2_P_SEQ').val();
                            var New_P_SEQ = $('#CDN_HDN_P_SEQ').val();
                            var Copy_Check = true;
                            if ($('#CDN_TB_IM').val().length === 0) {
                                alert('<%=Resources.MP.Select_Product_Alert%>');
                                Copy_Check  = false;
                            }
                            if (Old_P_SEQ === New_P_SEQ ) {
                                //不能Insert 同P_SEQ
                                alert('<%=Resources.BOM.Repeat_Copy_Product%>');
                                Copy_Check  = false;
                            }
                            if (Copy_Check) {
                                $.ajax({
                                    url: "/BOM/BOM_Save.ashx",
                                    data: {
                                        "Old_P_SEQ": Old_P_SEQ,
                                        "New_P_SEQ": New_P_SEQ,
                                        "Call_Type": "BOM_Copy"
                                    },
                                    cache: false,
                                    type: "POST",
                                    datatype: "json",
                                    contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                                    success: function (response) {
                                        if (String(response).indexOf("UNIQUE KEY") > 0) {
                                            alert(response);
                                        }
                                        else {
                                            $("#Copy_Dialog").dialog('close');
                                            alert("<%=Resources.MP.Add_Success%>");
                                            Search_BOM_M();
                                            Form_Mode_Change("Search_M");

                                        }
                                    },
                                    error: function (ex) {
                                        alert(ex);
                                        return false;
                                    }
                                });
                            }
                        },
                        "Cancel": function () {
                            $("#Copy_Dialog").dialog('close');
                        }
                    }
                });
                ATC();
            });

            $('#BT_ED_Cancel').on('click', function () {
                var Confirm_Check = confirm("<%=Resources.MP.Cancel_Alert%>");
                if (Confirm_Check) {
                    Edit_Mode = "Cancel";
                    Form_Mode_Change("Search_D");
                }
            });

            $('.V_BT').on('click', function () {
                $(this).attr('disabled', 'disabled');
                $('.V_BT').not($(this)).attr('disabled', false);
            });

            function Search_Product() {
                $.ajax({
                    url: "/BOM/BOM_Search.ashx",
                    data: {
                        "Call_Type": "Product_Search",
                        "IM": $('#SPD_TB_IM').val(),
                        "S_No": $('#SPD_TB_S_No').val(), 
                        "Search_Where": ""
                    },
                    cache: false,
                    type: "POST",
                    datatype: "json",
                    contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                    success: function (response) {
                        $('#SPD_Table_Product').DataTable({
                            "data": response,
                            "destroy": true,
                            "order": [[2, "desc"]],
                            "lengthMenu": [
                                [5, 10, 20, -1],
                                [5, 10, 20, "All"],
                            ],
                            "columns": [
                                {
                                    data: null, title: "",
                                    render: function (data, type, row) {
                                        return '<input type="button" class="BTN_Green" value="' + '<%=Resources.MP.Select%>' + '">'
                                    }
                                },
                                { data: "SEQ", title: "<%=Resources.BOM.P_SEQ%>" },
                                { data: "DVN", title: "<%=Resources.BOM.Developing%>" },
                                { data: "IM", title: "<%=Resources.BOM.Ivan_Model%>" },
                                { data: "S_No", title: "<%=Resources.BOM.Supplier_No%>" },
                                { data: "S_SName", title: "<%=Resources.BOM.Supplier_Short_Name%>" },
                                { data: "Unit", title: "<%=Resources.BOM.Unit%>" },
                                { data: "PI", title: "<%=Resources.BOM.Product_Information%>" }
                            ],
                            "columnDefs": [{
                                targets: [0],
                                className: "text-center"
                            }],
                        });

                        $('#SPD_Table_Product').css('white-space','nowrap');
                        $('#SPD_Table_Product thead th').css('text-align','center');
                    },
                    error: function (ex) {
                        alert(ex);
                    }
                });
            };

            function Table_Tr_Click(Click_tr) {
                $(Click_tr).parent().find('tr').css('background-color', '');
                $(Click_tr).parent().find('tr').css('color', 'black');
                $(Click_tr).css('background-color', '#5a1400');
                $(Click_tr).css('color', 'white');
                var P_SEQ = $(Click_tr).find('td:nth-child(1)').text().toString().trim();
                $('#TB_M2_P_SEQ').val(P_SEQ);
                $('#TB_M2_M_SEQ').val($(Click_tr).find('td:nth-child(2)').text().toString().trim());
                $('#TB_M2_Update_User').val($(Click_tr).find('td:nth-child(8)').text().toString().trim());
                $('#TB_M2_Update_Date').val($(Click_tr).find('td:nth-child(9)').text().toString().trim());

                Form_Mode_Change("Search_D");
                Search_BOM_D(P_SEQ, '');
            };

            function Search_BOM_D(P_SEQ, Type) {
                $.ajax({
                    //async: false,
                    url: "/BOM/BOM_Search.ashx",
                    data: {
                        "P_SEQ": P_SEQ,
                        "Call_Type": "BOM1_Selected"
                    },
                    cache: false,
                    type: "POST",
                    datatype: "json",
                    contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                    success: function (response) {
                        $('#TB_M2_IM').val(String(response[0].IM ?? ""));
                        $('#TB_M2_FNS').val(String(response[0].M_S_No ?? ""));
                        $('#TB_M2_FNS_SName').val(String(response[0].M_S_SName ?? ""));
                        $('#TB_M2_Remark').val(String(response[0].M_Remark ?? ""));

                        var D_Table_HTML =
                            '<thead><tr style="text-align:center;"><th style="width:42px;">'
                            + '</th><th>' + '<%=Resources.BOM.D_SEQ%>'
                            + '</th><th>' + '<%=Resources.BOM.Parent_SEQ%>'
                            + '</th><th>' + '<%=Resources.BOM.Material_Model%>'
                            + '</th><th>' + '<%=Resources.BOM.Rank%>'
                            + '</th><th class="DIMG">' + '<%=Resources.BOM.PD_IMG%>'
                            + '</th><th>' + '<%=Resources.BOM.Developing%>'
                            + '</th><th>' + '<%=Resources.BOM.Unit%>'
                            + '</th><th>' + '<%=Resources.BOM.Material_Amount%>'
                            + '</th><th>' + '<%=Resources.BOM.Product_Information%>'
                            + '</th><th>' + '<%=Resources.BOM.TWD_Price%>'
                            + '</th><th>' + '<%=Resources.BOM.USD_Price%>'
                            + '</th><th>' + '<%=Resources.BOM.Material_Supplier_ALL%>'
                            + '</th><th>' + '<%=Resources.BOM.Stop_Date%>'
                            + '</th><th>' + '<%=Resources.BOM.Material_Sell%>'
                            + '</th><th>' + '<%=Resources.BOM.Not_Billing%>'
                            + '</th><th>' + '<%=Resources.BOM.Not_Expand%>'
                            + '</th><th>' + '<%=Resources.BOM.Not_Computing_Cost%>'
                            + '</th><th>' + '<%=Resources.BOM.Update_User%>'
                            + '</th><th>' + '<%=Resources.BOM.Update_Date%>'
                            + '</th></tr></thead><tbody>';
                        var SUM_TWD = 0;
                        var SUM_USD = 0;

                        $(response).each(function (i) {
                            var binary = '';
                            //console.warn( ( (response[i].TWD_P ?? 0) * (response[i].M_Amount ?? 0) ) + ' --- ' + i + ',' + response[i].TWD_P + ' * ' + response[i].M_Amount);
                            SUM_TWD += (response[i].TWD_P ?? 0) * (response[i].M_Amount ?? 0);
                            SUM_USD += (response[i].USD_P ?? 0) * (response[i].M_Amount ?? 0);

                            if (response[i].HASIMG) {
                                $.ajax({
                                    url: "/BOM/BOM_Search.ashx",
                                    data: {
                                        "Call_Type": "GET_IMG",
                                        "P_SEQ": response[i].PD_SEQ
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
                            var Can_Add = Boolean(String(response[i].Rank ?? "") === "1" || String(response[i].Rank ?? "") === "2");//Onyl Rank 1 And 2 can Insert Detail
                            var Add_BT = "<span class='D_T_ADD' style='cursor:pointer;color:green;'><%=Resources.BOM.Add_Item%></span>";
                            var Can_Delete = !Boolean(response[i].HASC);//Only Not exists Child can Delete
                            var Delete_BT = "<span class='D_T_DEL' style='cursor:pointer;color:red;'><%=Resources.BOM.Delete_Item%></span>";

                            var Show_Item = " <span class='Expand' style='cursor:pointer;color:blue;' onclick=$('." + String(response[i].SEQ ?? "") +
                                "_Child').toggle();$(this).text(($('." + String(response[i].SEQ ?? "") + "_Child').css('display')=='none')?'＋':'－'); >+</span >";

                            D_Table_HTML +=
                                '<tr class="' + String(response[i].Parent_SEQ ?? "") + '_Child">' +
                                '<td style="text-align:center;width:42px;">' + ((response[i].HASC) ? Show_Item : "") +
                                    '<div class="D_T_For_U" style="display:none;">' +
                                        (Can_Add ? Add_BT : '') +
                                        ((Can_Add && Can_Delete) ? "<br />" : "") +
                                        (Can_Delete ? Delete_BT : '') +
                                    '</div>' +
                                '</td><td>' + String(response[i].SEQ ?? "") +
                                '</td><td Class="Parent_SEQ_td">' + String(response[i].Parent_SEQ ?? "") +
                                '</td><td>' + String(response[i].Material_Model ?? "") +
                                '</td><td class="Rank_td">' + String(response[i].Rank ?? "") +
                                '</td><td class="DIMG" style="text-align:center;">' +
                                ((response[i].HASIMG) ? ('<img src="data:image/png;base64,' + window.btoa(binary) + '" />') : ('<%=Resources.Cost.Image_NotExists%>')) +
                                '</td><td>' + String(response[i].DVN ?? "") +
                                '</td><td>' + String(response[i].Unit ?? "") +
                                '</td><td style="text-align:right;">' +
                                    '<span class="V_M_Amount">' + String(response[i].M_Amount ?? "") + '</span>' +
                                    '<input class="U_M_Amount" style="text-align:right;display:none;width:80px;" type="number" step="0.1" value="' + String(response[i].M_Amount ?? 0) + '" />' +
                                '</td><td>' + String(response[i].PI ?? "") +
                                    '<input type="hidden" class="D_PD_SEQ" value="' + String(response[i].PD_SEQ ?? "") + '" />' +
                                '</td><td style="text-align:right;">' + String(response[i].TWD_P ?? "") +
                                '</td><td style="text-align:right;">' + String(response[i].USD_P ?? "") +
                                '</td><td>' + String(response[i].D_S_No ?? "") + '-' + String(response[i].D_S_SName ?? "") +
                                    '<input type="hidden" class="D_S_No" value="' + String(response[i].D_S_No ?? "") + '" />' +
                                    '<input type="hidden" class="D_S_SName" value="' + String(response[i].D_S_SName ?? "") + '" />' +
                                '</td><td>' + String(response[i].SD ?? "") +
                                //Need Add class to control this disabled & get value (+class, name)
                                '</td><td style="text-align:center;"><input type="checkbox" style="width: 1.15em;height: 1.15em;border: 0.15em solid currentColor;" class="D_4Check" name="MS" disabled="disabled" ' + (response[i].MS ? 'checked="checked"' : '') + ' />' +
                                '</td><td style="text-align:center;"><input type="checkbox" style="width: 1.15em;height: 1.15em;border: 0.15em solid currentColor;" class="D_4Check" name="NB" disabled="disabled" ' + (response[i].NB ? 'checked="checked"' : '') + ' />' +
                                '</td><td style="text-align:center;"><input type="checkbox" style="width: 1.15em;height: 1.15em;border: 0.15em solid currentColor;" class="D_4Check" name="NE" disabled="disabled" ' + (response[i].NE ? 'checked="checked"' : '') + ' />' +
                                '</td><td style="text-align:center;"><input type="checkbox" style="width: 1.15em;height: 1.15em;border: 0.15em solid currentColor;" class="D_4Check" name="NCC" disabled="disabled" ' + (response[i].NCC ? 'checked="checked"' : '') + ' />' +
                                '</td><td>' + String(response[i].Update_User ?? "") +
                                '</td><td>' + String(response[i].Update_Date ?? "") +
                                '</td></tr>';
                        });
                        D_Table_HTML += '</tbody>';

                        $('#Table_Search_BOM_D').html(D_Table_HTML);
                        $('#Table_Search_BOM_D tr td').css('vertical-align', 'middle');
                        $('#Table_Search_BOM_D').css('white-space','nowrap');
                        $('.Rank_td:not(:contains(1),:contains(9))').parent().css('display', 'none');//預設不展開
                        $('#TB_M2_D_Count').val($(response).length ?? 0);
                        $('#TB_M2_D_SUM_TWD').val(SUM_TWD.toFixed(2));
                        $('#TB_M2_D_SUM_USD').val(SUM_USD.toFixed(2));
                        $('.Rank_td:contains(1)').parent().find('.V_M_Amount').attr('class', '');//1階不提供用量調整
                        $('.Rank_td:contains(1)').parent().find('.U_M_Amount').remove();
                        $('.Rank_td:contains(9)').parent().find('.Rank_td, .Parent_SEQ_td').css('background-color', 'red');
                        $('.Rank_td:contains(2)').parent().find('.Rank_td, .Parent_SEQ_td').css('background-color', '#4FC3A1');
                        $('.Rank_td:contains(3)').parent().find('.Rank_td, .Parent_SEQ_td').css('background-color', '#96ACC4');
                        $('.Rank_td:contains(2)').parent().find('td:lt(7)').not(':nth-child(1), :nth-child(6)').each(function () { $(this).text('\xa0\xa0\xa0\xa0' + $(this).text()) });
                        $('.Rank_td:contains(3)').parent().find('td:lt(7)').not(':nth-child(1), :nth-child(6)').each(function () { $(this).text('\xa0\xa0\xa0\xa0\xa0\xa0\xa0\xa0' + $(this).text()) });
                        $('.DIMG').toggle(!$('#RB_DV_DIMG').prop('checked'));
                        $('.DIMG img').css('height', ($('#RB_SM_DIMG').prop('checked')) ? '100px' : '');


                        if (Type == "Continue_Edit") {
                            $('#TB_M2_Remark').attr('disabled', false);
                            $('.D_4Check').attr('disabled', false);

                            $('#Table_Search_BOM_D tr').toggle(true);
                            $('.D_T_For_U, .U_M_Amount').toggle(true);
                            $('#Table_Search_BOM_D .Expand, .V_M_Amount').toggle(false);
                        }
                    },
                    error: function (ex) {
                        alert(ex);
                    }
                });
            };

            $('#Table_Search_BOM_D').on('click', '.D_T_ADD', function () {
                var P_SEQ = $('#TB_M2_P_SEQ').val();
                var Parent_SEQ = $(this).parent().parent().parent().find('td:nth(1)').text().trim();
                var Parent_IM = $(this).parent().parent().parent().find('td:nth(3)').text().trim();
                var Parent_Rank = $(this).parent().parent().parent().find('td:nth(4)').text().trim();
                var Parent_Supplier_ALL = $(this).parent().parent().parent().find('td:nth(12)').text().trim();
                var Parent_P_IM = $(this).parent().parent().parent().find('td:nth(9)').text().trim();
                var Parent_Supplier_No = $(this).parent().parent().parent().find('.D_S_No').val();
                var Parent_Supplier_SName = $(this).parent().parent().parent().find('.D_S_SName').val();
                $('#NDD_TB_OLD_SEQ').val(Parent_SEQ);
                $('#NDD_TB_OLD_IM').val(Parent_IM);
                $('#NDD_TB_OLD_Supplier').val(Parent_Supplier_ALL);
                $('#NDD_TB_OLD_Rank').val(Parent_Rank);
                $('#NDD_TB_OLD_P_IM').val(Parent_P_IM);
                $('#NDD_New_Table input').not('[type=button], [type=number]').val('');//New_Item區塊初始化
                $('#NDD_New_Table input[type=bumber]').val('1');//New_Item區塊初始化

                $("#New_Detail_Dialog").dialog({
                    modal: true,
                    title: "<%=Resources.BOM.Add_Item%>",
                    width: screen.width * 0.8,
                    overlay: 0.5,
                    position: { my: "center", at: "top" },
                    focus: true,
                    buttons: {
                        "Save": function () {
                            var Detail_Add_Check = true;
                            if ($('#NDDN_TB_IM').val().length === 0) {
                                alert('<%=Resources.MP.Select_Product_Alert%>');
                                            Detail_Add_Check = false;
                                        }
                                        if (P_SEQ === $('#NDDN_HDN_P_SEQ').val()) {
                                            //不能Insert 1階 P_SEQ
                                            alert('<%=Resources.BOM.Repeat_1_Rank_Product%>');
                                            Detail_Add_Check = false;
                                        }
                                        if (Detail_Add_Check) {
                                            $.ajax({
                                                url: "/BOM/BOM_Save.ashx",
                                                data: {
                                                    "Parent_SEQ": Parent_SEQ,
                                                    "P_SEQ": P_SEQ,
                                                    "Parent_IM": Parent_IM,
                                                    "Parent_Supplier_S_No": Parent_Supplier_No,
                                                    "Parent_Supplier_S_SName": Parent_Supplier_SName,
                                                    "New_S_No": $('#NDDN_HDN_S_No').val(),
                                                    "New_S_SName": $('#NDDN_HDN_S_SName').val(),
                                                    "New_IM": $('#NDDN_TB_IM').val(),
                                                    "New_P_SEQ": $('#NDDN_HDN_P_SEQ').val(),
                                                    "M_Amount": $('#NDDN_TB_M_Amount').val(),
                                                    "New_Rank": Number(Parent_Rank) + 1,
                                                    "Call_Type": "BOM_D_New"
                                                },
                                                cache: false,
                                                type: "POST",
                                                datatype: "json",
                                                contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                                                success: function (response) {
                                                    //console.warn(response);
                                                    if (String(response).indexOf("UNIQUE KEY") > 0) {
                                                        alert(response);
                                                    }
                                                    else {
                                                        $("#New_Detail_Dialog").dialog('close');
                                                        Edit_Mode = "NEW_D_Save";
                                                        alert("<%=Resources.MP.Add_Success%>");
                                                        Search_BOM_D(P_SEQ, 'Continue_Edit');
                                                    }
                                                },
                                                error: function (ex) {
                                                    alert(ex);
                                                    return false;
                                                }
                                            });
                            }
                        },
                        "Cancel": function () {
                            $("#New_Detail_Dialog").dialog('close');
                        }
                    }
                });
                ATC();
            });

            $('#SPD_BT_Search').on('click', function () {
                Search_Product();
                $('#STD_Div_DT').css('display', '');
            });

            $('#SPD_Table_Product').on('click', '.BTN_Green', function () {
                switch (Dialog_Control) {
                    case "M"://Master_Add
                        $('#HDN_M2_P_SEQ').val($(this).parent().parent().find('td:nth(1)').text());
                        $('#HDN_M2_DVN').val($(this).parent().parent().find('td:nth(2)').text());
                        $('#TB_M2_IM').val($(this).parent().parent().find('td:nth(3)').text());
                        $('#TB_M2_FNS').val($(this).parent().parent().find('td:nth(4)').text());
                        $('#TB_M2_FNS_SName').val($(this).parent().parent().find('td:nth(5)').text());
                        $('#TB_M2_P_IM').val($(this).parent().parent().find('td:nth(7)').text());
                        break;
                    case "D"://Detail_Add
                        $('#NDDN_HDN_P_SEQ').val($(this).parent().parent().find('td:nth(1)').text());
                        $('#NDDN_HDN_S_No').val($(this).parent().parent().find('td:nth(4)').text());
                        $('#NDDN_HDN_S_SName').val($(this).parent().parent().find('td:nth(5)').text());
                        $('#NDDN_TB_IM').val($(this).parent().parent().find('td:nth(3)').text());
                        $('#NDDN_TB_S_ALL').val($(this).parent().parent().find('td:nth(4)').text() + '-' + $(this).parent().parent().find('td:nth(5)').text());
                        $('#NDDN_TB_P_IM').val($(this).parent().parent().find('td:nth(7)').text());
                        break;
                    case "C"://Copy
                        $('#CDN_HDN_P_SEQ').val($(this).parent().parent().find('td:nth(1)').text());
                        $('#CDN_HDN_S_No').val($(this).parent().parent().find('td:nth(4)').text());
                        $('#CDN_HDN_S_SName').val($(this).parent().parent().find('td:nth(5)').text());
                        $('#CDN_TB_IM').val($(this).parent().parent().find('td:nth(3)').text());
                        $('#CDN_TB_S_ALL').val($(this).parent().parent().find('td:nth(4)').text() + '-' + $(this).parent().parent().find('td:nth(5)').text());
                        $('#CDN_TB_P_IM').val($(this).parent().parent().find('td:nth(7)').text());
                        break;
                }
                $("#Search_Product_Dialog").dialog('close');
            });

            $('#Table_Search_BOM_D').on('click', '.D_T_DEL', function () {
                var P_SEQ = $('#TB_M2_P_SEQ').val();
                var D_SEQ = $(this).parent().parent().parent().find('td:nth(1)').text().trim();
                var D_PD_SEQ = $(this).parent().parent().parent().find('.D_PD_SEQ').val();
                var D_Product = $(this).parent().parent().parent().find('td:nth(3)').text().trim();

                if (confirm('確定刪除 明細序號：' + D_SEQ + ', 材料型號：' + D_Product)) {
                    //console.warn('D_SEQ:' + D_SEQ + ', P_SEQ:' + P_SEQ + ', D_PD_SEQ:' + D_PD_SEQ)
                    var Delete_Other_Check = true;
                    var Will_Delete_Master = false;

                    if (P_SEQ === D_PD_SEQ) {
                        Will_Delete_Master = true;
                        Delete_Other_Check = confirm('本筆為1階成品，會連同主檔一起刪除，確定執行？');
                    };
                    
                    //if ($(this).parent().parent().parent().length === 1)
                    //Delete_Other_Check = confirm('此為最後一項材料，會連同主檔一起刪除，確定執行？');


                    if (Delete_Other_Check) {
                        $(this).parent().parent().parent().remove();
                        $.ajax({
                            url: "/BOM/BOM_Delete.ashx",
                            data: {
                                "D_SEQ": D_SEQ,
                                "P_SEQ": P_SEQ,
                                "Call_Type": "BOM_D_Delete"
                            },
                            cache: false,
                            type: "POST",
                            datatype: "json",
                            contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                            success: function (response) {
                                /*Edit_Mode = "NEW_D_Save";*/
                                if (Will_Delete_Master) {
                                    Edit_Mode = "Search";
                                    Form_Mode_Change("Search_M");
                                    Search_BOM_M();
                                }
                                else {
                                    Search_BOM_D(P_SEQ, 'Continue_Edit');
                                }
                            },
                            error: function (ex) {
                                alert(ex);
                                return false;
                            }
                        });
                    }
                }
            });

            $('#BT_M2_Product_Selector').on('click', function () {
                Dialog_Control = "M";
                $("#Search_Product_Dialog").dialog('open');
            });

            $('#CDN_BT_Product_Selector').on('click', function () {
                Dialog_Control = "C";
                $("#Search_Product_Dialog").dialog('open');
            });

            $('#NDDN_BT_Product_Selector').on('click', function () {
                Dialog_Control = "D";
                $("#Search_Product_Dialog").dialog('open');
            });

            function Dialog() {
                $("#dialog").dialog({
                    autoOpen: false,
                    modal: true,
                    title: "<%=Resources.MP.Search_Confition%>",
                    width: screen.width * 0.5,
                    overlay: 0.5,
                    focus: true,
                    close: function () {
                        Edit_Mode = "Cancel";
                        Form_Mode_Change("Base");
                    },
                    buttons: {
                        "Search": function () {
                            $("#dialog").dialog('close');
                            var Where_Text = "";

                            switch ($('#Dia_BT_Simple_Change').prop('disabled')) {
                                case true://Simple
                                    switch ($('#Dia_TB1_Operator1').val()) {
                                        case "%LIKE%":
                                            Where_Text += " [頤坊型號] LIKE '%" + $('#Dia_TB1_IM').val() + "%'";
                                            break;
                                        case "LIKE%":
                                            Where_Text += " [頤坊型號] LIKE '" + $('#Dia_TB1_IM').val() + "%'";
                                            break;
                                        case "%LIKE":
                                            Where_Text += " [頤坊型號] LIKE '%" + $('#Dia_TB1_IM').val() + "'";
                                            break;
                                        default:
                                            Where_Text += " [頤坊型號] " + $('#Dia_TB1_Operator1').val() + " '" + $('#Dia_TB1_IM').val() + "'";
                                            break;
                                    }
                                    switch ($('#Dia_TB1_Operator2').val()) {
                                        case "%LIKE%":
                                            Where_Text += " AND [最後完成者] LIKE '%" + $('#Dia_TB1_S_No').val() + "%'";
                                            break;
                                        case "LIKE%":
                                            Where_Text += " AND [最後完成者] LIKE '" + $('#Dia_TB1_S_No').val() + "%'";
                                            break;
                                        case "%LIKE":
                                            Where_Text += " AND [最後完成者] LIKE '%" + $('#Dia_TB1_S_No').val() + "'";
                                            break;
                                        default:
                                            Where_Text += " AND [最後完成者] " + $('#Dia_TB1_Operator2').val() + " '" + $('#Dia_TB1_S_No').val() + "'";
                                            break;
                                    }
                                    console.warn(Where_Text);
                                    Search_BOM_M(Where_Text);
                                    break;
                                case false://Multiple
                                    Where_Text += $('#TB_Dia_Where').val();
                                    console.warn(Where_Text);
                                    Search_BOM_M(Where_Text);
                                    break;
                            }
                            Edit_Mode = "Detail_Search";//沒用到
                            $('#BT_Cancel').css('display', '');
                            $('.M_BT').not($('#BT_Cancel')).css('display', 'none');

                            $('#Div_DT_View').css('display', '');
                            $('.V_BT').not($('#V_BT_Master')).css('display', '');
                        },
                        "Cancel": function () {
                            $("#dialog").dialog('close');
                        }
                    }
                });

                $("#Search_Product_Dialog").dialog({
                    autoOpen: false,
                    modal: true,
                    title: "<%=Resources.MP.Search_Confition%>",
                    width: screen.width * 0.8,
                    overlay: 0.5,
                    focus: true,
                    buttons: {
                        "Cancel": function () {
                            $("#Search_Product_Dialog").dialog('close');
                            $('#STD_Div_DT').css('display', 'none');
                        }
                    }
                });
            };

            function ATC() {
                $('#Dia_TB1_S_No').autocomplete({
                    autoFocus: true,
                    source: function (request, response) {
                        $.ajax({
                            url: "/Web_Service/AutoComplete.asmx/Serach_Supplier_No_Name",
                            cache: false,
                            data: "{'S_No': '" + request.term + "'}",
                            dataType: "json",
                            type: "POST",
                            contentType: "application/json; charset=utf-8",
                            success: function (data) {
                                $('.ui-autocomplete').css('z-index', $('div.ui-dialog').css('z-index') + 1);
                                var Json_Response = JSON.parse(data.d);
                                response($.map(Json_Response, function (item) { return { label: item.S_No + " - " + item.S_Name, value: item.S_No, name: item.S_Name } }));
                            },
                            error: function (response) {
                                alert(response.responseText);
                            },
                        });
                    },
                });

                $('#SPD_TB_IM').autocomplete({
                    autoFocus: true,
                    source: function (request, response) {
                        $.ajax({
                            url: "/Web_Service/AutoComplete.asmx/Serach_Ivan_Model",
                            cache: false,
                            data: "{'IM': '" + request.term + "'}",
                            dataType: "json",
                            type: "POST",
                            contentType: "application/json; charset=utf-8",
                            success: function (data) {
                                $('.ui-autocomplete').css('z-index', $('div.ui-dialog').css('z-index') + 1);
                                var Json_Response = JSON.parse(data.d);
                                response($.map(Json_Response, function (item) { return { label: item.IM + " - " + item.PI, value: item.IM, name: item.PI } }));
                            },
                            error: function (response) {
                                alert(response.responseText);
                            },
                        });
                    },
                });

                $('#SPD_TB_S_No').autocomplete({
                    autoFocus: true,
                    source: function (request, response) {
                        $.ajax({
                            url: "/Web_Service/AutoComplete.asmx/Serach_Supplier_No_Name",
                            cache: false,
                            data: "{'S_No': '" + request.term + "'}",
                            dataType: "json",
                            type: "POST",
                            contentType: "application/json; charset=utf-8",
                            success: function (data) {
                                $('.ui-autocomplete').css('z-index', $('div.ui-dialog').css('z-index') + 1);
                                var Json_Response = JSON.parse(data.d);
                                response($.map(Json_Response, function (item) { return { label: item.S_No + " - " + item.S_Name, value: item.S_No, name: item.S_Name } }));
                            },
                            error: function (response) {
                                alert(response.responseText);
                            },
                        });
                    },
                });

            };//FN_ATC_End

        });
    </script>
    <style type="text/css">
        .V_BT {
            background-color: azure;
            font-weight: bold;
            border: none;
            cursor: pointer;
            font-size: 15px;
            text-align: center;
            text-decoration: none;
        }

            .V_BT:hover {
                background-color: #f8981d;
                color: white;
            }

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


        .ED_BT {
            background-color: aqua;
            font-weight: bold;
            border: none;
            cursor: pointer;
            font-size: large;
            text-align: center;
            text-decoration: none;
        }

            .ED_BT:hover {
                background-color: #f8981d;
                color: white;
            }
            
        #Table_Search_BOM tbody tr:hover, #Table_Search_BOM_D tbody tr:hover, #SPD_Table_Product tbody tr:hover {
            background-color: #f8981d;
            color: white;
        }
        
        .D_T_ADD:hover, .D_T_DEL:hover {
            background-color: cornflowerblue;
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
    </style>

    <div id="dialog" style="display: none;">
        <div style="width: 100%; text-align: center;">
            <input type="button" id="Dia_BT_Simple_Change" value="Simple" style="width: 20%" disabled="disabled" />
            <input type="button" id="Dia_BT_Multiple_Change" value="Multiple" style="width: 20%" />
        </div>
        <br />
        <table border="0" style="margin: 0 auto;" id="Dia_Table_Simple">
            <tr style="text-align: right;">
                <td style="width: 20%;"><%=Resources.BOM.Ivan_Model%></td>
                <td style="width: 30%;">
                    <select style="width: 90%; height: 25px;" id="Dia_TB1_Operator1">
                        <option>=</option>
                        <option selected="selected">%LIKE%</option>
                        <option>LIKE%</option>
                        <option>%LIKE</option>
                    </select>
                </td>
                <td style="width: 50%;">
                    <input style="width: 90%; height: 25px;" id="Dia_TB1_IM" />
                </td>
            </tr>
            <tr style="text-align: right;">
                <td style="width: 20%;"><%=Resources.BOM.Master_Supplier_ALL%></td>
                <td style="width: 30%;">
                    <select style="width: 90%; height: 25px;" id="Dia_TB1_Operator2">
                        <option>=</option>
                        <option selected="selected">%LIKE%</option>
                        <option>LIKE%</option>
                        <option>%LIKE</option>
                    </select>
                </td>
                <td style="width: 50%;">
                    <input style="width: 90%; height: 25px;" id="Dia_TB1_S_No" placeholder="<%=Resources.MP.S_No_ATC_Hint%>" />
                </td>
            </tr>
        </table>
        <table border="1" style="margin: 0 auto; display: none;" id="Dia_Table_Multiple">
            <tr style="text-align: center;">
                <td style="width: 40%;">
                    <%--Where Column--%>
                    <select style="width: 90%; height: 25px;" id="DDL_Dia_Filter">
                        <option value="[頤坊型號]" selected="selected"><%=Resources.BOM.Ivan_Model%></option>
                        <option value="[完成者簡稱]"><%=Resources.BOM.Master_Supplier_S_Name%></option>
                        <option value="[最後完成者]"><%=Resources.BOM.Master_Supplier_S_No%></option>
                        <option value="[序號]"><%=Resources.BOM.M_SEQ%></option>
                        <option value="[更新人員]"><%=Resources.BOM.Update_User%></option>
                        <option value="[P_SEQ]"><%=Resources.BOM.P_SEQ%></option>
                    </select>
                </td>
                <td style="width: 20%;">
                    <%--運算子--%>
                    <select style="width: 90%; height: 25px;" id="DDL_Dia_Operator">
                        <option>=</option>
                        <option>>=</option>
                        <option><=</option>
                        <option>></option>
                        <option><</option>
                        <option><></option>
                        <option selected="selected">%LIKE%</option>
                        <option>LIKE%</option>
                        <option>%LIKE</option>
                    </select>
                </td>
                <td style="width: 40%;">
                    <%--運算元--%>
                    <input style="width: 90%; height: 25px;" id="TB_Dia_Operand" />
                </td>
            </tr>
            <tr>
                <td style="text-align: center; vertical-align: middle;">
                    <div style="float: left; width: 50%; text-align: center;">
                        <input type="radio" value="AND" name="R_Filter_Group" id="RB_Dia_AND" checked="checked" />
                        <label for="RB_Dia_AND">AND</label>
                    </div>
                    <div style="float: right; width: 50%; text-align: center;">
                        <input type="radio" value="OR" name="R_Filter_Group" id="RB_Dia_OR" />
                        <label for="RB_Dia_OR">OR</label>
                    </div>
                </td>
                <td style="text-align: center;">
                    <input type="button" value="Clear" style="width: 80%;" id="BT_Dia_Clear" onclick="$('#TB_Dia_Where').val('')" />
                </td>
                <td style="text-align: center;">
                    <input type="button" value="Join" style="width: 40%;" id="BT_Dia_Join" />
                </td>
                <script type="text/javascript">
                    $(document).ready(function () {
                        $('#Dia_BT_Simple_Change').on('click', function () {
                            $('#Dia_Table_Simple').css('display', '');
                            $('#Dia_BT_Simple_Change').attr('disabled', 'disabled');
                            $('#Dia_Table_Multiple').css('display', 'none');
                            $('#Dia_BT_Multiple_Change').attr('disabled', false);
                        });
                        $('#Dia_BT_Multiple_Change').on('click', function () {
                            $('#Dia_Table_Simple').css('display', 'none');
                            $('#Dia_BT_Simple_Change').attr('disabled', false);
                            $('#Dia_Table_Multiple').css('display', '');
                            $('#Dia_BT_Multiple_Change').attr('disabled', 'disabled');
                        });

                        $('#BT_Dia_Join').on('click', function () {
                            if ($('#TB_Dia_Operand').val() != "") {
                                var Where_Text = $('#DDL_Dia_Filter').val();
                                switch ($('#DDL_Dia_Operator').val()) {
                                    case "%LIKE%":
                                        Where_Text += " LIKE '%" + $('#TB_Dia_Operand').val() + "%'";
                                        break;
                                    case "LIKE%":
                                        Where_Text += " LIKE '" + $('#TB_Dia_Operand').val() + "%'";
                                        break;
                                    case "%LIKE":
                                        Where_Text += " LIKE '%" + $('#TB_Dia_Operand').val() + "'";
                                        break;
                                    default:
                                        Where_Text += " " + $('#DDL_Dia_Operator').val() + " '" + $('#TB_Dia_Operand').val() + "'";
                                        break;
                                }
                                if ($('#TB_Dia_Where').val() != "") {
                                    Where_Text = "\r\n" + $('input[name=R_Filter_Group]:checked').val() + " " + Where_Text;
                                }
                                $('#TB_Dia_Where').val($('#TB_Dia_Where').val() + " " + Where_Text);
                            }
                        });
                    });
                </script>
            </tr>
            <tr>
                <td colspan="3">
                    <textarea id="TB_Dia_Where" style="width: 100%; height: 200px;"></textarea>
                </td>
            </tr>
        </table>
    </div>

    <div id="Copy_Dialog" style="display: none;">
        <div style="position: relative; border: 1px solid #111111; padding: 20px; box-sizing: border-box; margin: 30px auto; width: 100%;background-color:silver;">
            <span style="position: absolute; top: -1em; left: 10%; line-height: 2em; padding: 0 1em; background-color: #fff;border:1px #000 solid;">Old_BOM_Master</span>
            <table style="border-collapse: separate; border-spacing: 0px 8px; margin: 0 auto;width:100%;" id="CD_Old_Table">
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.BOM.Old_Master_SEQ%></td>
                    <td style="text-align: left; width: 15%;">
                        <input style="width: 80%;" id="CD_TB_OLD_SEQ" class="disable" disabled="disabled" />
                    </td>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.BOM.Old_Ivan_Model%></td>
                    <td style="text-align: left; width: 15%;">
                        <input style="width: 80%;" id="CD_TB_OLD_IM" class="disable" disabled="disabled" />
                    </td>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.BOM.Old_Supplier%></td>
                    <td style="text-align: left; width: 15%;">
                        <input style="width: 80%;" id="CD_TB_OLD_Supplier" class="disable" disabled="disabled" />
                    </td>
                    <td style="text-align: right; text-wrap: none; width: 10%;"></td>
                    <td></td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.BOM.Old_Product_Information%></td>
                    <td style="text-align: left; width: 15%;" colspan="7">
                        <input id="CD_TB_OLD_P_IM" class="disable" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
            </table>
        </div>
        <div style="position: relative; border: 1px solid #111111; padding: 20px; box-sizing: border-box; margin: 30px auto; width: 100%;">
            <span style="position: absolute; top: -1em; left: 10%; line-height: 2em; padding: 0 1em; background-color: #fff;">New_BOM</span>
            <table style="border-collapse: separate; border-spacing: 0px 8px; margin: 0 auto;width:100%;" id="CD_New_Table">
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.BOM.Ivan_Model%></td>
                    <td style="text-align: left; width: 15%;">
                        <div style="width: 80%; float: left; z-index: -10;">
                            <input id="CDN_TB_IM" class="disable" autocomplete="off" disabled="disabled" style="width: 100%; z-index: -10;" />
                        </div>
                        <div style="width: 20%; float: right; z-index: 10;">
                            <input id="CDN_BT_Product_Selector" type="button" value="…" style="float: right; z-index: 10;" />
                        </div>
                        <input type="hidden" id="CDN_HDN_P_SEQ" />
                    </td>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.BOM.Material_Supplier_ALL%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="CDN_TB_S_ALL" class="disable" disabled="disabled" style="width: 80%;" />
                        <input type="hidden" id="CDN_HDN_S_No" />
                        <input type="hidden" id="CDN_HDN_S_SName" />
                    </td>
                    <td style="text-align: right; text-wrap: none; width: 10%;"></td>
                    <td></td>
                    <td style="text-align: right; text-wrap: none; width: 10%;"></td>
                    <td></td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.BOM.Product_Information%></td>
                    <td style="text-align: left; width: 15%;" colspan="7">
                        <input id="CDN_TB_P_IM" class="disable" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
            </table>
        </div>
    </div>

    <div id="Search_Product_Dialog" style="display: none;">
        <table border="0" style="margin: 0 auto;" id="SPD_Table">
            <tr style="text-align: right;">
                <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.BOM.Ivan_Model%></td>
                <td style="text-align: left; width: 15%;">
                    <input style="width: 90%; height: 25px;" id="SPD_TB_IM" placeholder="<%=Resources.MP.Product_ATC_Hint%>" />
                </td>

                <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.BOM.Master_Supplier_ALL%></td>
                <td style="text-align: left; width: 15%;">
                    <input style="width: 90%; height: 25px;" id="SPD_TB_S_No" placeholder="<%=Resources.MP.S_No_ATC_Hint%>" />
                </td>
            </tr>
            <tr><td><br /></td></tr>
            <tr>
                <td style="text-align: center;" colspan="4">
                    <div style="display: flex; justify-content: center; align-items: center;">
                        <input id="SPD_BT_Search" class="BTN" type="button" value="<%=Resources.MP.Search%>" style="width:10%;" />
                    </div>
                </td>
            </tr>
        </table>
        <div id="STD_Div_DT" style="margin: auto; width: 98%; overflow: auto; display: none;">
            <br />
            <table id="SPD_Table_Product" style="width: 100%;" class="table table-striped table-bordered dt-responsive">
                <thead></thead>
                <tbody></tbody>
            </table>
        </div>
    </div>

    <div id="New_Detail_Dialog" style="display:none;">
        <div style="position: relative; border: 1px solid #111111; padding: 20px; box-sizing: border-box; margin: 30px auto; width: 100%;background-color:silver;">
            <span style="position: absolute; top: -1em; left: 10%; line-height: 2em; padding: 0 1em; background-color: #fff;border:1px #000 solid;">Parent_Item</span>
            <table style="border-collapse: separate; border-spacing: 0px 8px; margin: 0 auto;width:100%;" id="NDD_Old_Table">
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.BOM.Parent_SEQ%></td>
                    <td style="text-align: left; width: 15%;">
                        <input style="width: 80%;" id="NDD_TB_OLD_SEQ" class="disable" disabled="disabled" />
                    </td>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.BOM.Parent_Model%></td>
                    <td style="text-align: left; width: 15%;">
                        <input style="width: 80%;" id="NDD_TB_OLD_IM" class="disable" disabled="disabled" />
                    </td>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.BOM.Parent_Supplier%></td>
                    <td style="text-align: left; width: 15%;">
                        <input style="width: 80%;" id="NDD_TB_OLD_Supplier" class="disable" disabled="disabled" />
                    </td>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.BOM.Parent_Rank%></td>
                    <td style="text-align: left; width: 15%;">
                        <input style="width: 100%;" id="NDD_TB_OLD_Rank" class="disable" disabled="disabled" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.BOM.Parent_Product_Information%></td>
                    <td style="text-align: left; width: 15%;" colspan="7">
                        <input id="NDD_TB_OLD_P_IM" class="disable" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
            </table>
        </div>
        <div style="position: relative; border: 1px solid #111111; padding: 20px; box-sizing: border-box; margin: 30px auto; width: 100%;">
            <span style="position: absolute; top: -1em; left: 10%; line-height: 2em; padding: 0 1em; background-color: #fff;">New_Item</span>
            <table style="border-collapse: separate; border-spacing: 0px 8px; margin: 0 auto;width:100%;" id="NDD_New_Table">
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.BOM.Ivan_Model%></td>
                    <td style="text-align: left; width: 15%;">
                        <div style="width: 80%; float: left; z-index: -10;">
                            <input id="NDDN_TB_IM" class="disable" autocomplete="off" disabled="disabled" style="width: 100%; z-index: -10;" />
                        </div>
                        <div style="width: 20%; float: right; z-index: 10;">
                            <input id="NDDN_BT_Product_Selector" type="button" value="…" style="float: right; z-index: 10;" />
                        </div>
                        <input type="hidden" id="NDDN_HDN_P_SEQ" />
                    </td>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.BOM.Material_Supplier_ALL%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="NDDN_TB_S_ALL" class="disable" disabled="disabled" style="width: 80%;" />
                        <input type="hidden" id="NDDN_HDN_S_No" />
                        <input type="hidden" id="NDDN_HDN_S_SName" />
                    </td>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.BOM.Material_Amount%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="NDDN_TB_M_Amount" type="number" step="0.1" value="1" style="width: 80%; text-align: right;" />
                    </td>
                    <td style="text-align: right; text-wrap: none; width: 10%;"></td>
                    <td></td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.BOM.Product_Information%></td>
                    <td style="text-align: left; width: 15%;" colspan="7">
                        <input id="NDDN_TB_P_IM" class="disable" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
            </table>
        </div>
    </div>

    <table class="table_th" style="text-align: left;">
        <tr>
            <td style="height: 10px; font-size: smaller;" colspan="8">&nbsp</td>
        </tr>
        <tr>
            <td style="width: 10%;"></td>
            <td style="width: 10%;">
                <input type="button" id="BT_New" class="M_BT" value="<%=Resources.MP.Master%><%=Resources.MP.Insert%>" />
            </td>
            <td style="width: 10%;">
                <input type="button" id="BT_Search" class="M_BT" value="<%=Resources.MP.Search%>" />
            </td>
            <td style="width: 10%;">
                <input type="button" id="BT_Detail_Search" class="M_BT" value="<%=Resources.MP.Detail_Search%>" />
            </td>
            <td style="width: 10%;">
                <input type="button" id="BT_Cancel" class="M_BT" value="<%=Resources.MP.Cancel%>" style="display: none;" />
            </td>
            <td style="width: 80%;"></td>
        </tr>
        <tr>
            <td style="height: 10px; font-size: smaller;" colspan="8">&nbsp</td>
        </tr>
    </table>

    <div id="Div_DT_View" style="margin: auto; width: 98%; overflow: auto; display: none;">
        <table id="Table_Search_BOM" style="width: 100%;" class="table table-striped table-bordered">
            <thead></thead>
            <tbody></tbody>
        </table>
    </div>
    <div id="Div_Edit_Area" style="width: 99%; margin: 0 auto; background-color: white;">
        &nbsp;
        <input type="button" id="BT_ED_Edit" class="ED_BT" value="<%=Resources.MP.Edit%>" style="display: none;" />
        <input type="button" id="BT_ED_Copy" class="ED_BT" value="<%=Resources.MP.Copy%>" style="display: none;" />
        <input type="button" id="BT_ED_Save" class="ED_BT" value="<%=Resources.MP.Save%>" style="display: none;" />
        <input type="button" id="BT_ED_Cancel" class="ED_BT" value="<%=Resources.MP.Cancel%>" style="display: none;" />
    </div>
    <div style="width: 99%; margin: 0 auto; background-color: white;">
        &nbsp;
        <input id="V_BT_Master" type="button" class="V_BT" value="<%=Resources.BOM.Master%>" onclick="$('.Div_D').css('display','none');$('#Div_M2').css('display','');" disabled="disabled" />
        <input type="button" class="V_BT" style="display: none;" value="<%=Resources.MP.Sample%>" onclick="$('.Div_D').css('display','none');$('#Div_Sample').css('display','');" />
    </div>
    <div style="width: 100%;" id="Div_Detail_Form">
        <div id="Div_M2" class="Div_D">
            <table style="font-size: 15px; border-collapse: separate; border-spacing: 0px 8px;">
                <tr class="M2_For_U" style="display: none;">
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.BOM.P_SEQ%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M2_P_SEQ" class="disable" disabled="disabled" style="width: 90%;" />
                    </td>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.BOM.M_SEQ%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M2_M_SEQ" class="disable" disabled="disabled" style="width: 90%;" />
                    </td>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.BOM.Update_User%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M2_Update_User" class="disable" disabled="disabled" style="width: 100%;" />
                    </td>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.BOM.Update_Date%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M2_Update_Date" class="disable" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.BOM.Ivan_Model%></td>
                    <td style="text-align: left; width: 15%;">
                        <div style="width: 90%; float: left; z-index: -10;">
                            <input id="TB_M2_IM" class="disable" autocomplete="off" disabled="disabled" style="width: 100%; z-index: -10;" />
                        </div>
                        <div class="M2_For_N" style="width: 10%; float: right; z-index: 10; display: none;">
                            <input id="BT_M2_Product_Selector" type="button" value="…" disabled="disabled" style="float: right; z-index: 10;" />
                        </div>
                        <input type="hidden" id="HDN_M2_P_SEQ" />
                        <input type="hidden" id="HDN_M2_DVN" />
                    </td>

                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.BOM.Master_Supplier_S_No%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M2_FNS" class="disable" disabled="disabled" style="width: 90%;" />
                    </td>

                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.BOM.Master_Supplier_S_Name%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M2_FNS_SName" class="S_Name" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
                <tr class="M2_For_N" style="display: none;">
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.BOM.Product_Information%></td>
                    <td style="text-align: left; width: 15%;" colspan="7">
                        <input id="TB_M2_P_IM" class="disable" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
                <tr class="M2_For_U" style="display: none;">
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.BOM.D_Count%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M2_D_Count" class="disable" disabled="disabled" style="text-align:right;width: 90%;" />
                    </td>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.BOM.SUM_TWD%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M2_D_SUM_TWD" class="disable" disabled="disabled" style="width: 90%;text-align:right;" />
                    </td>

                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.BOM.SUM_USD%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M2_D_SUM_USD" class="disable" disabled="disabled" style="width: 100%;text-align:right;" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.BOM.Remark%></td>
                    <td style="text-align: left; width: 15%;" colspan="7">
                        <textarea id="TB_M2_Remark" style="width: 100%; height: 80px;" disabled="disabled"></textarea>
                    </td>
                </tr>

                <tr>
                    <td colspan="8" style="margin: auto;">
                        <div style="display: flex; justify-content: center; align-items: center;">
                            <input id="BT_New_Save" class="BTN" style="display: none;" type="button" value="<%=Resources.BOM.Save%>" />
                        </div>
                    </td>
                </tr>
            </table>

            <div id="Div_DT_View2" style="margin: auto; width: 98%; overflow: auto; display: none;">
                <input id="RB_DV_DIMG" type="radio" name="DIMG" checked="checked" onclick="$('.DIMG').css('display', 'none');" />
                <label for="RB_DV_DIMG"><%=Resources.BOM.Not_Show_Image%></label>
                <input id="RB_V_DIMG" type="radio" name="DIMG" onclick="$('.DIMG').css('display', '');$('.DIMG img').css('height', '');" />
                <label for="RB_V_DIMG"><%=Resources.BOM.Show_Original_Image%></label>
                <input id="RB_SM_DIMG" type="radio" name="DIMG" onclick="$('.DIMG').css('display', '');$('.DIMG img').css('height', '100px');" />
                <label for="RB_SM_DIMG"><%=Resources.BOM.Show_Small_Image%></label>
                <table id="Table_Search_BOM_D" style="width: 100%;" class="table table-striped table-bordered">
                    <thead></thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>

        <div id="Div_Sample" class="Div_D" style="display: none; overflow: auto">
        </div>

    </div>

    <br />
    <br />
</asp:Content>

