<%@ Page Title="Price Maintenance" Language="C#" MasterPageFile="~/MP.master" AutoEventWireup="true" CodeFile="Price_MT.aspx.cs" Inherits="Price_MT" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <link href="/css/dataTables.bootstrap4.min.css" rel="stylesheet" />
    <script src="/js/jquery.dataTables.min.js"></script>
    <script src="/js/dataTables.bootstrap4.min.js"></script>

    <script type="text/javascript">
        $(document).ready(function () {
            var From_Mode;
            var PS_Control;
            DDL_Bind();
            Dialog();

            function Form_Mode_Change(Form_Mode) {
                switch (Form_Mode) {
                    case "Base":
                        $('#Div_Detail_Form input, #Div_Detail_Form textarea').not('[type=button], #TB_Dia_Where, [type=number]').val('');
                        $('#Div_Detail_Form input[type=number]').val(0);
                        $('#DDL_M2_DVN').val('Y');
                        $('#Div_Detail_Form input, #Div_Detail_Form textarea, #Div_Detail_Form select').css('background-color', '');
                        $('#Div_Detail_Form input, #Div_Detail_Form textarea, #Div_Detail_Form select').attr('disabled', 'disabled');

                        $('#BT_New, #BT_Search, #BT_Detail_Search').css('display', '');
                        $('#BT_New_Save, #BT_Cancel, #Div_DT_View, .ED_BT').css('display', 'none');

                        $('.V_BT').not('#V_BT_Master').css('display', 'none');
                        $('.V_BT').not('#V_BT_Master').attr('disabled', false);
                        $('#V_BT_Master').attr('disabled', 'disabled');
                        $('.Div_D').not('#Div_M2').css('display', 'none');
                        $('#Div_M2').css('display', '');
                        $('.M2_For_V, .M2_For_NU').css('display', 'none');
                        break;
                    case "New_M":
                        $('input[required], select[required]').css('background-color', 'yellow');
                        $('.M2_For_NU').css('display', '');
                        $('#Div_Detail_Form input, #Div_Detail_Form textarea, #Div_Detail_Form select').not('.disabled').attr('disabled', false);
                        $('#BT_New, #BT_Search, #BT_Detail_Search').css('display', 'none');
                        $('#BT_Cancel, #BT_New_Save').css('display', '');
                        break;
                    case "Search_M":
                        //$('#Div_Detail_Form input, #Div_Detail_Form textarea, #Div_Detail_Form select').attr('disabled', 'disabled');
                        $('#BT_New, #BT_Search, #BT_Detail_Search, #BT_ED_Save, #BT_ED_Cancel, #BT_ED_Edit').css('display', 'none');
                        $('#BT_Cancel, #Div_DT_View').css('display', '');
                        //$('.ED_BT').css('display', 'none');
                        //$('#BT_ED_Edit, #BT_Cancel, #Div_DT_View').css('display', '');
                        //$('#BT_ED_Save, #BT_ED_Cancel').css('display', 'none');
                        break;
                    case "Search_D":
                        $('.V_BT').css('display', '');
                        $('.M2_For_V').css('display', '');
                        $('#Div_Detail_Form input, #Div_Detail_Form textarea, #Div_Detail_Form select').attr('disabled', 'disabled');
                        $('#BT_ED_Edit, #BT_ED_Copy, #BT_Cancel, #Div_DT_View').css('display', '');
                        $('#BT_ED_Save, #BT_ED_Cancel').css('display', 'none');
                        break;
                    case "Edit_D":
                        $('#BT_ED_Edit, #BT_ED_Copy, #BT_Cancel, #Div_DT_View').css('display', 'none');
                        $('#BT_ED_Save, #BT_ED_Cancel, .M2_For_NU').css('display', '');
                        $('#Div_Detail_Form input, #Div_Detail_Form textarea, #Div_Detail_Form select').not('.disabled').attr('disabled', false);
                        break;
                }
            }

            $('#BT_New').on('click', function () {
                From_Mode = "New";
                Form_Mode_Change("New_M");
            });

            $('#BT_New_Save').on('click', function () {
                if (confirm("<%=Resources.MP.Save_Alert%>")) {
                    if (Save_Check()) {
                        $.ajax({
                            url: "/Cost/Cost_Save.ashx",
                            data: {
                                "IM": $('#TB_M2_IM').val(),
                                "SM": $('#TB_M2_SM').val(),
                                "S_No": $('#TB_M2_S_No').val(),
                                "S_SName": $('#TB_M2_S_SName').val(),
                                "Sample_PN": $('#TB_M2_Sample_P_No').val(),
                                "Unit": $('#TB_M2_Unit').val(),
                                "PI": $('#TB_M2_P_IM').val(),
                                "P_TWD": parseInt($('#TB_M2_TWD_1').val()) || 0,
                                "P_USD": parseInt($('#TB_M2_USD').val()) || 0,
                                "P_TWD_2": parseInt($('#TB_M2_TWD_2').val()) || 0,
                                "P_TWD_3": parseInt($('#TB_M2_TWD_3').val()) || 0,
                                "MIN_1": parseInt($('#TB_M2_MIN_1').val()) || 0,
                                "MIN_2": parseInt($('#TB_M2_MIN_2').val()) || 0,
                                "MIN_3": parseInt($('#TB_M2_MIN_3').val()) || 0,
                                "Curr": $('#TB_M2_Currency').val(),
                                "P_Curr": parseInt($('#TB_M2_PC_1').val()) || 0,
                                "P_Curr_2": parseInt($('#TB_M2_PC_2').val()) || 0,
                                "P_Curr_3": parseInt($('#TB_M2_PC_3').val()) || 0,
                                "DS_P": $('#DDL_M2_DP').val(),
                                "DS_IM": $('#TB_M2_DI').val(),
                                "RP": $('#TB_M2_RP').val(),
                                "RD": $('#TB_M2_RD').val(),
                                "Call_Type": "Cost_New"
                            },
                            cache: false,
                            type: "POST",
                            datatype: "json",
                            contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                            success: function (response) {
                                console.warn(response);
                                if (String(response).indexOf("UNIQUE KEY") > 0) {
                                    alert(response);
                                }
                                else {
                                    alert("<%=Resources.MP.Add_Success%>");
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
                Search_Price();
                From_Mode = "Search";
                Form_Mode_Change("Search_M");
            });

            $('#BT_Detail_Search').on('click', function () {
                $("#dialog").dialog('open');
            });

            function Search_Price(Search_Where) {
                $.ajax({
                    url: "/Price/Price_Search.ashx",
                    data: {
                        "Call_Type": "Price_MT_Search",
                        "Search_Where": Search_Where ?? ""
                    },
                    cache: false,
                    type: "POST",
                    datatype: "json",
                    contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                    success: function (response) {
                        $('#Table_Search_Price').DataTable({
                            "data": response,
                            "destroy": true,
                            "order": [[17, "desc"]],
                            "lengthMenu": [
                                [5, 10, 20, -1],
                                [5, 10, 20, "All"],
                            ],
                            "columns": [
                                { data: "SEQ", title: "<%=Resources.Price.SEQ%>" },
                                { data: "CM", title: "<%=Resources.Price.Customer_Model%>" },
                                { data: "IM", title: "<%=Resources.Price.Ivan_Model%>" },
                                { data: "DVN", title: "<%=Resources.Price.Developing%>" },
                                { data: "C_SName", title: "<%=Resources.Price.Customer_Short_Name%>" },
                                { data: "USD_P", title: "<%=Resources.Price.USD_Price%>" },
                                { data: "S_SName", title: "<%=Resources.Price.Supplier_Short_Name%>" },
                                { data: "Unit", title: "<%=Resources.Price.Unit%>" },
                                { data: "MIN_1", title: "MIN_1" },
                                { data: "LSTP_Day", title: "<%=Resources.Price.Last_Price_Day%>" },
                                { data: "TWD_P", title: "<%=Resources.Price.TWD_Price%>" },
                                { data: "SDate", title: "<%=Resources.Price.Stop_Date%>" },
                                { data: "PI", title: "<%=Resources.Price.Product_Information%>" },
                                { data: "S_No", title: "<%=Resources.Price.Supplier_No%>" },
                                { data: "C_No", title: "<%=Resources.Price.Customer_No%>" },
                                { data: "P_SEQ", title: "<%=Resources.Price.Product_SEQ%>" },
                                { data: "Update_User", title: "<%=Resources.Price.Update_User%>" },
                                { data: "Update_Date", title: "<%=Resources.Price.Update_Date%>" }
                            ],
                        });
                        $('#Table_Search_Price').css('white-space', 'nowrap');
                        $('#Table_Search_Price thead th').css('text-align', 'center');
                    },
                    error: function (ex) {
                        alert(ex);
                    }
                });
            };

            $('#Table_Search_Price').on('click', 'tbody tr', function () {
                $(this).parent().find('tr').css('background-color', '');
                $(this).parent().find('tr').css('color', 'black');
                $(this).css('background-color', '#5a1400');
                $(this).css('color', 'white');
                Form_Mode_Change("Search_D");

                $.ajax({
                    url: "/Price/Price_Search.ashx",
                    data: {
                        "SEQ": $(this).find('td:nth-child(1)').text(),
                        "Call_Type": "Price_MT_Selected"
                    },
                    cache: false,
                    type: "POST",
                    datatype: "json",
                    contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                    success: function (response) {
                        $('#TB_M2_SEQ').val(String(response[0].SEQ ?? ""));
                        $('#DDL_M2_DVN').val(String(response[0].DVN ?? ""));
                        $('#DDL_M2_TM').val(String(response[0].TM ?? ""));
                        $('#TB_M2_CM').val(String(response[0].CM ?? ""));
                        $('#TB_M2_LSPD').val(String(response[0].LSPD ?? ""));
                        $('#TB_M2_SD').val(String(response[0].SD ?? ""));
                        $('#TB_M2_C_No').val(String(response[0].C_No ?? ""));
                        $('#TB_M2_C_SName').val(String(response[0].C_SName ?? ""));
                        $('#TB_M2_IM').val(String(response[0].IM ?? ""));
                        $('#TB_M2_Unit').val(String(response[0].Unit ?? ""));
                        $('#TB_M2_S_No').val(String(response[0].S_No ?? ""));
                        $('#TB_M2_S_SName').val(String(response[0].S_SName ?? ""));
                        $('#TB_M2_P_IM').val(String(response[0].PI ?? ""));
                        $('#TB_M2_TWD_1').val(String(response[0].TWD_P ?? ""));
                        $('#TB_M2_USD_1').val(String(response[0].USD_P ?? ""));
                        $('#TB_M2_P_2').val(String(response[0].P_2 ?? ""));
                        $('#TB_M2_P_3').val(String(response[0].P_3 ?? ""));
                        $('#TB_M2_P_4').val(String(response[0].P_4 ?? ""));
                        $('#TB_M2_MIN_1').val(String(response[0].MIN_1 ?? ""));
                        $('#TB_M2_MIN_2').val(String(response[0].MIN_2 ?? ""));
                        $('#TB_M2_MIN_3').val(String(response[0].MIN_3 ?? ""));
                        $('#TB_M2_MIN_4').val(String(response[0].MIN_4 ?? ""));
                        $('#TB_M2_Update_User').val(String(response[0].Update_User ?? ""));
                        $('#TB_M2_Update_Date').val(String(response[0].Update_Date ?? ""));
                        $('#TB_M2_Remark').val(String(response[0].Remark ?? ""));
                        
                        $('#TB_I_IM').val(String(response[0].IM ?? ""));
                        $('#TB_I_S_No').val(String(response[0].S_No ?? ""));
                        $('#TB_I_S_SName').val(String(response[0].S_SName ?? ""));
                        $('#TB_I_P_IM').val(String(response[0].PI ?? ""));

                        var IMG_View = (response[0].IMG == null);
                        $('#IMG_I_IMG').css('display', (IMG_View) ? 'none' : '');
                        $('#IMG_I_IMG_Hint').css('display', (IMG_View) ? '' : 'none');
                        var binary = '';
                        var bytes = new Uint8Array(response[0].IMG);
                        var len = bytes.byteLength;
                        for (var i = 0; i < len; i++) {
                            binary += String.fromCharCode(bytes[i]);
                        }
                        $('#IMG_I_IMG').attr('src', 'data:image/png;base64,' + window.btoa(binary));
                    },
                    error: function (ex) {
                        alert(ex);
                    }
                });
            });

            $('#BT_ED_Copy').on('click', function () {
                $('#TB_CD_IM, #TB_CD_S_No').css('background-color', '');
                $("#Copy_Dialog").dialog('open');
            });

            $('#BT_Cancel').on('click', function () {
                var Confirm_Check = true;
                if (From_Mode == "New") {
                    Confirm_Check = confirm("<%=Resources.MP.Cancel_Alert%>");
                }
                if (Confirm_Check) {
                    From_Mode = "Cancel";
                    Form_Mode_Change("Base");
                }
            });

            $('#BT_ED_Edit').on('click', function () {
                Form_Mode_Change("Edit_D");
            });

            $('#BT_ED_Save').on('click', function () {
                if (confirm("<%=Resources.MP.Edit_Alert%>")) {
                    if (Save_Check()) {
                        $.ajax({
                            url: "/Cost/Cost_Save.ashx",
                            data: {
                                "SEQ": $('#TB_M2_SEQ').val(),
                                "IM": $('#TB_M2_IM').val(),
                                "SM": $('#TB_M2_SM').val(),
                                "S_No": $('#TB_M2_S_No').val(),
                                "S_SName": $('#TB_M2_S_SName').val(),
                                "Sample_PN": $('#TB_M2_Sample_P_No').val(),
                                "Unit": $('#TB_M2_Unit').val(),
                                "PI": $('#TB_M2_P_IM').val(),
                                "PID": $('#TB_M2_P_ID').val(),
                                "P_TWD": parseInt($('#TB_M2_TWD_1').val()) || 0,
                                "P_USD": parseInt($('#TB_M2_USD').val()) || 0,
                                "P_TWD_2": parseInt($('#TB_M2_TWD_2').val()) || 0,
                                "P_TWD_3": parseInt($('#TB_M2_TWD_3').val()) || 0,
                                "MIN_1": parseInt($('#TB_M2_MIN_1').val()) || 0,
                                "MIN_2": parseInt($('#TB_M2_MIN_2').val()) || 0,
                                "MIN_3": parseInt($('#TB_M2_MIN_3').val()) || 0,
                                "Curr": $('#TB_M2_Currency').val(),
                                "P_Curr": parseInt($('#TB_M2_PC_1').val()) || 0,
                                "P_Curr_2": parseInt($('#TB_M2_PC_2').val()) || 0,
                                "P_Curr_3": parseInt($('#TB_M2_PC_3').val()) || 0,
                                "DS_P": $('#DDL_M2_DP').val(),
                                "DS_IM": $('#TB_M2_DI').val(),
                                "DPN": $('#TB_M2_DPN').val(),
                                "PS": $('#DDL_M2_PS').val(),
                                "RP": $('#TB_M2_RP').val(),
                                "RD": $('#TB_M2_RD').val(),
                                "MS": $('#TB_MR_MS').val(),
                                "WH": parseInt($('#TB_P_WH').val()) || 0,
                                "IBC": parseInt($('#TB_P_IBC').val()) || 0,
                                "OBNo": parseInt($('#TB_P_OBNo').val()) || 0,
                                "NW": parseInt($('#TB_P_NW').val()) || 0,
                                "OBL": parseInt($('#TB_P_OBL').val()) || 0,
                                "GW": parseInt($('#TB_P_GW').val()) || 0,
                                "IA": parseInt($('#TB_P_IA').val()) || 0,
                                "OBW": parseInt($('#TB_P_OBW').val()) || 0,
                                "OBH": parseInt($('#TB_P_OBH').val()) || 0,
                                "IA2": parseInt($('#TB_P_IA2').val()) || 0,
                                "P_NW": parseInt($('#TB_P_P_NW').val()) || 0,
                                "P_GW": parseInt($('#TB_P_P_GW').val()) || 0,
                                "PL": parseInt($('#TB_P_PL').val()) || 0,
                                "PW": parseInt($('#TB_P_PW').val()) || 0,
                                "PH": parseInt($('#TB_P_PH').val()) || 0,
                                "PGL": parseInt($('#TB_P_PGL').val()) || 0,
                                "PGW": parseInt($('#TB_P_PGW').val()) || 0,
                                "PGH": parseInt($('#TB_P_PGH').val()) || 0,
                                "Call_Type": "Cost_Update"
                            },
                            cache: false,
                            type: "POST",
                            datatype: "json",
                            contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                            success: function (response) {
                                console.warn(response);
                                if (String(response).indexOf("UNIQUE KEY") > 0) {
                                    alert(response);
                                }
                                else {
                                    alert("<%=Resources.MP.Update_Success%>");
                                    Form_Mode_Change("Search_D");
                                    Search_Price();
                                }
                            },
                            error: function (ex) {
                                if (ex != null) {
                                    alert(ex);
                                }
                            }
                        });
                    }
                }
            });

            $('#BT_ED_Cancel').on('click', function () {
                Form_Mode_Change("Search_D");
            });

            function Save_Check() {
                var Check_Item = true;
                var Alert_Message = "";
                //if ($('#TB_M2_S_No').val().length < 4 || $('#TB_M2_S_No').val().length > 8) {
                //    Alert_Message += "請輸入4~8碼廠商編號";
                //    $('#TB_M2_S_No').css('background-color', 'red');
                //    Check_Item = false;
                //}
                //if ($('#TB_M2_S_SName').val().length === 0) {
                //    Alert_Message += "\r\n請輸入廠商簡稱";
                //    $('#TB_M2_S_SName').css('background-color', 'red');
                //    Check_Item = false;
                //}
                //if ($('#TB_M2_S_Nation').val().length === 0) {
                //    Alert_Message += "\r\n請輸入國名";
                //    $('#TB_M2_S_Nation').css('background-color', 'red');
                //    Check_Item = false;
                //}
                //if (!Check_Item) {
                //    alert(Alert_Message);
                //}
                return Check_Item;
            };
            function Copy_Check() {
                var Check_Item = true;
                var Alert_Message = "";
                if ($('#TB_CD_IM').val().length === 0) {
                    Alert_Message += "請輸入頤坊型號";
                    $('#TB_CD_IM').css('background-color', 'red');
                    Check_Item = false;
                }
                else {
                    $('#TB_CD_IM').css('background-color', '');
                }

                if ($('#TB_CD_S_No').val().length === 0) {
                    Alert_Message += "\r\n請輸入廠商編號";
                    $('#TB_CD_S_No').css('background-color', 'red');
                    Check_Item = false;
                }
                if (Check_Item) {
                    $.ajax({
                        url: "/Cost/Cost_Search.ashx",
                        data: {
                            "S_No": $('#TB_CD_S_No').val(),
                            "Call_Type": "Supplier_No_Check"
                        },
                        cache: false,
                        async: false,
                        type: "POST",
                        datatype: "json",
                        contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                        success: function (response) {
                            if (response.length === 0) {
                                Alert_Message += "\r\n廠商編號不存在";
                                $('#TB_CD_S_No').css('background-color', 'red');
                                Check_Item = false;
                            }
                            else {
                                $.ajax({
                                    url: "/Cost/Cost_Search.ashx",
                                    data: {
                                        "IM": $('#TB_CD_IM').val(),
                                        "S_No": $('#TB_CD_S_No').val(),
                                        "Call_Type": "Copy_ALL_Check"
                                    },
                                    cache: false,
                                    async: false,
                                    type: "POST",
                                    datatype: "json",
                                    contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                                    success: function (response) {
                                        if (response.length > 0) {
                                            Alert_Message += "\r\n已存在相同頤坊型號&廠商編號";
                                            $('#TB_CD_IM').css('background-color', 'red');
                                            $('#TB_CD_S_No').css('background-color', 'red');
                                            Check_Item = false;
                                        }
                                        else {
                                            $('#TB_CD_IM').css('background-color', '');
                                            $('#TB_CD_S_No').css('background-color', '');
                                        }
                                    },
                                    error: function (ex) {
                                        alert(ex);
                                    }
                                });

                            }
                        },
                        error: function (ex) {
                            alert(ex);
                        }
                    });
                }

                if (!Check_Item) {
                    alert(Alert_Message);
                }
                // 1. 型號 or 編號 不為空, 2.編號需存在DB 3. 型號+編號 不可重複DB,
                return Check_Item;
            };

            $('.V_BT').on('click', function () {
                $(this).attr('disabled', 'disabled');
                $('.V_BT').not($(this)).attr('disabled', false);
            });

            $('#BT_M2_Customer_Selector').on('click', function () {
                PS_Control = 'NU';
                $("#Search_Customer_Dialog").dialog('open');
            });

            $('#SCD_BT_Search').on('click', function () {
                $.ajax({
                    url: "/Customer/Customer_Search.ashx",
                    data: {
                        "Call_Type": "SCD_Search",
                        "C_No": $('#SCD_TB_C_No').val(),
                        "C_SName": $('#SCD_TB_C_SName').val(),
                        "Search_Where": ""
                    },
                    cache: false,
                    type: "POST",
                    datatype: "json",
                    contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                    success: function (response) {
                        $('#SCD_Table_Customer').DataTable({
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
                                { data: "SEQ", title: "<%=Resources.Customer.SEQ%>" },
                                { data: "C_No", title: "<%=Resources.Customer.Customer_No%>" },
                                { data: "C_SName", title: "<%=Resources.Customer.Customer_Short_Name%>" },
                                { data: "C_Name", title: "<%=Resources.Customer.Customer_Name%>" },
                                { data: "Principal", title: "<%=Resources.Customer.Principal%>" },
                                { data: "Mail", title: "Mail" },
                                { data: "Remark", title: "<%=Resources.Customer.Remark%>" }
                            ],
                            "columnDefs": [{
                                targets: [0],
                                className: "text-center"
                            }],
                        });

                        $('#SCD_Table_Customer').css('white-space', 'nowrap');
                        $('#SCD_Table_Customer thead th').css('text-align', 'center');
                    },
                    error: function (ex) {
                        alert(ex);
                    }
                });
                $('#SCD_Div_DT').css('display', '');
            });

            $('#SCD_Table_Customer').on('click', '.BTN_Green', function () {
                switch (PS_Control) {
                    case "NU"://New&Update
                        $('#TB_M2_C_No').val($(this).parent().parent().find('td:nth(2)').text());
                        $('#TB_M2_C_SName').val($(this).parent().parent().find('td:nth(3)').text());
                        break;
                    case "C"://Copy
                        //$('#TB_M2_C_No').val($(this).parent().parent().find('td:nth(2)').text());
                        //$('#TB_M2_C_SName').val($(this).parent().parent().find('td:nth(3)').text());
                        break;
                }
                $("#Search_Customer_Dialog").dialog('close');
            });

            $('#BT_M2_Product_Selector').on('click', function () {
                PS_Control = 'NU';
                $("#Search_Product_Dialog").dialog('open');
            });

            $('#SPD_BT_Search').on('click', function () {
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
                                { data: "SEQ", title: "<%=Resources.Price.Product_SEQ%>" },
                                { data: "DVN", title: "<%=Resources.Price.Developing%>" },
                                { data: "IM", title: "<%=Resources.Price.Ivan_Model%>" },
                                { data: "S_No", title: "<%=Resources.Price.Supplier_No%>" },
                                { data: "S_SName", title: "<%=Resources.Price.Supplier_Short_Name%>" },
                                { data: "Unit", title: "<%=Resources.Price.Unit%>" },
                                { data: "PI", title: "<%=Resources.Price.Product_Information%>" }
                            ],
                            "columnDefs": [{
                                targets: [0],
                                className: "text-center"
                            }],
                        });

                        $('#SPD_Table_Product').css('white-space', 'nowrap');
                        $('#SPD_Table_Product thead th').css('text-align', 'center');
                    },
                    error: function (ex) {
                        alert(ex);
                    }
                });
                $('#SPD_Div_DT').css('display', '');
            });

            $('#SPD_Table_Product').on('click', '.BTN_Green', function () {
                switch (PS_Control) {
                    case "NU"://New&Update
                        $('#HDN_M2_P_SEQ').val($(this).parent().parent().find('td:nth(1)').text());
                        $('#TB_M2_IM').val($(this).parent().parent().find('td:nth(3)').text());
                        $('#TB_M2_S_No').val($(this).parent().parent().find('td:nth(4)').text());
                        $('#TB_M2_S_SName').val($(this).parent().parent().find('td:nth(5)').text());
                        $('#TB_M2_Unit').val($(this).parent().parent().find('td:nth(6)').text());
                        $('#TB_M2_P_IM').val($(this).parent().parent().find('td:nth(7)').text());
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

            function Dialog() {
                $("#dialog").dialog({
                    autoOpen: false,
                    modal: true,
                    title: "<%=Resources.MP.Search_Confition%>",
                    width: 800,//=Div寬度$
                    overlay: 0.5,
                    focus: true,
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
                                            Where_Text += " [頤坊型號] LIKE '" + $('#Dia_TB1_IM').val() + "%'";;
                                            break;
                                        case "%LIKE":
                                            Where_Text += " [頤坊型號] LIKE '%" + $('#Dia_TB1_IM').val() + "'";;
                                            break;
                                        default:
                                            Where_Text += " [頤坊型號] " + $('#Dia_TB1_Operator1').val() + " '" + $('#Dia_TB1_IM').val() + "'";
                                            break;
                                    }
                                    switch ($('#Dia_TB1_Operator2').val()) {
                                        case "%LIKE%":
                                            Where_Text += " AND [廠商編號] LIKE '%" + $('#Dia_TB1_S_No').val() + "%'";
                                            break;
                                        case "LIKE%":
                                            Where_Text += " AND [廠商編號] LIKE '" + $('#Dia_TB1_S_No').val() + "%'";;
                                            break;
                                        case "%LIKE":
                                            Where_Text += " AND [廠商編號] LIKE '%" + $('#Dia_TB1_S_No').val() + "'";;
                                            break;
                                        default:
                                            Where_Text += " AND [廠商編號] " + $('#Dia_TB1_Operator2').val() + " '" + $('#Dia_TB1_S_No').val() + "'";
                                            break;
                                    }
                                    console.warn(Where_Text);
                                    Search_Price(Where_Text);
                                    break;
                                case false://Multiple
                                    Where_Text += $('#TB_Dia_Where').val();
                                    console.warn(Where_Text);
                                    Search_Price(Where_Text);
                                    break;
                            }
                            From_Mode = "Detail_Search";
                            Form_Mode_Change("Search_M");
                        },
                        "Cancel": function () {
                            $("#dialog").dialog('close');
                        }
                    }
                });

                $("#Copy_Dialog").dialog({
                    autoOpen: false,
                    modal: true,
                    title: "<%=Resources.MP.Copy_Condition%>",
                    width: 800,
                    overlay: 0.5,
                    buttons: {
                        "Copy": function () {
                            if (Copy_Check()) {
                                $("#Copy_Dialog").dialog('close');
                                $.ajax({
                                    url: "/Cost/Cost_Save.ashx",
                                    data: {
                                        "IM": $('#TB_CD_IM').val(),
                                        "SM": $('#TB_M2_SM').val(),
                                        "S_No": $('#TB_CD_S_No').val(),
                                        "S_SName": $('#HDN_CD_S_SName').val(),
                                        "Sample_PN": $('#TB_M2_Sample_P_No').val(),
                                        "Unit": $('#TB_M2_Unit').val(),
                                        "PI": $('#TB_M2_P_IM').val(),
                                        "P_TWD": parseInt($('#TB_M2_TWD_1').val()) || 0,
                                        "P_USD": parseInt($('#TB_M2_USD').val()) || 0,
                                        "P_TWD_2": parseInt($('#TB_M2_TWD_2').val()) || 0,
                                        "P_TWD_3": parseInt($('#TB_M2_TWD_3').val()) || 0,
                                        "MIN_1": parseInt($('#TB_M2_MIN_1').val()) || 0,
                                        "MIN_2": parseInt($('#TB_M2_MIN_2').val()) || 0,
                                        "MIN_3": parseInt($('#TB_M2_MIN_3').val()) || 0,
                                        "Curr": $('#TB_M2_Currency').val(),
                                        "P_Curr": parseInt($('#TB_M2_PC_1').val()) || 0,
                                        "P_Curr_2": parseInt($('#TB_M2_PC_2').val()) || 0,
                                        "P_Curr_3": parseInt($('#TB_M2_PC_3').val()) || 0,
                                        "DS_P": $('#DDL_M2_DP').val(),
                                        "DS_IM": $('#TB_M2_DI').val(),
                                        "RP": $('#TB_M2_RP').val(),
                                        "RD": $('#TB_M2_RD').val(),
                                        "Call_Type": "Cost_New"
                                    },
                                    cache: false,
                                    type: "POST",
                                    datatype: "json",
                                    contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                                    success: function (response) {
                                        console.warn(response);
                                        if (String(response).indexOf("UNIQUE KEY") > 0) {
                                            alert(response);
                                        }
                                        else {
                                            alert("<%=Resources.MP.Copy_Success%>");
                                            Search_Price();
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

                $("#Search_Customer_Dialog").dialog({
                    autoOpen: false,
                    modal: true,
                    title: "<%=Resources.MP.Search_Confition%>",
                    width: screen.width * 0.8,
                    overlay: 0.5,
                    focus: true,
                    buttons: {
                        "Cancel": function () {
                            $("#Search_Customer_Dialog").dialog('close');
                            $('#SCD_Div_DT').css('display', 'none');
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
                            $('#SPD_Div_DT').css('display', 'none');
                        }
                    }
                });
            };

            function DDL_Bind() {
                $.ajax({
                    url: "/Web_Service/DDL_DataBind.asmx/Customer_Trademark",
                    cache: false,
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (data) {
                        var Json_Response = JSON.parse(data.d);
                        var DDL_Option = "<option></option>";
                        $.each(Json_Response, function (i, value) {
                            DDL_Option += '<option>' + value.txt + '</option>';
                        });
                        $('#DDL_M2_TM').html(DDL_Option);
                    },
                    error: function (response) {
                        alert(response.responseText);
                    },
                });
            };
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
            background-color:aqua;
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

        #Table_Search_Price tbody tr:hover {
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
    </style>

    <div id="dialog" style="display: none;">
        <div style="width: 100%; text-align: center;">
            <input type="button" id="Dia_BT_Simple_Change" value="Simple" style="width: 20%" disabled="disabled" />
            <input type="button" id="Dia_BT_Multiple_Change" value="Multiple" style="width: 20%" />
        </div>
        <br />
        <table border="0" style="margin: 0 auto;" id="Dia_Table_Simple">
            <tr style="text-align: right;">
                <td style="width: 20%;"><%=Resources.Cost.Ivan_Model%></td>
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
                <td style="width: 20%;"><%=Resources.Cost.Supplier_No%></td>
                <td style="width: 30%;">
                    <select style="width: 90%; height: 25px;" id="Dia_TB1_Operator2">
                        <option>=</option>
                        <option selected="selected">%LIKE%</option>
                        <option>LIKE%</option>
                        <option>%LIKE</option>
                    </select>
                </td>
                <td style="width: 50%;">
                    <input style="width: 90%; height: 25px;" id="Dia_TB1_S_No" />
                </td>
            </tr>
        </table>
        <table border="1" style="margin: 0 auto; display: none;" id="Dia_Table_Multiple">
            <tr style="text-align: center;">
                <td style="width: 40%;">
                    <%--Where Column--%>
                    <select style="width: 90%; height: 25px;" id="DDL_Dia_Filter">
                        <option value="[頤坊型號]" selected="selected"><%=Resources.Cost.Ivan_Model%></option>
                        <option value="[廠商編號]"><%=Resources.Cost.Supplier_No%></option>
                        <option value="[廠商型號]"><%=Resources.Cost.Supplier_Model%></option>
                        <option value="[暫時型號]"><%=Resources.Cost.Sample_Product_No%></option>
                        <option value="[廠商簡稱]"><%=Resources.Cost.Supplier_Short_Name%></option>
                        <option value="[最後價日]"><%=Resources.Cost.Last_Price_Day%></option>
                        <option value="[產品說明]"><%=Resources.Cost.Product_Information%></option>
                        <option value="[新增日期]"><%=Resources.Cost.Add_Date%></option>
                        <option value="[序號]"><%=Resources.Cost.SEQ%></option>
                        <option value="[更新人員]"><%=Resources.Cost.Update_User%></option>
                        <option value="[更新日期]"><%=Resources.Cost.Update_Date%></option>
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
                                        Where_Text += " LIKE '" + $('#TB_Dia_Operand').val() + "%'";;
                                        break;
                                    case "%LIKE":
                                        Where_Text += " LIKE '%" + $('#TB_Dia_Operand').val() + "'";;
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
    
    <div id="Copy_Dialog" style="display:none;">
        <table border="0" style="margin: 0 auto;" id="CD_Table">
            <tr style="background-color:lightgray;">
                <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Old%><%=Resources.Cost.Ivan_Model%></td>
                <td style="text-align: left; width: 15%;">
                    <span id="LB_CD_IM"></span>
                </td>
                <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Old%><%=Resources.Cost.Supplier_Model%></td>
                <td style="text-align: left; width: 15%;">
                    <span id="LB_M2_SM"></span>
                </td>
            </tr>
            <tr style="background-color:lightgray;">
                <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Old%><%=Resources.Cost.Supplier_No%></td>
                <td style="text-align: left; width: 15%;">
                    <span id="LB_CD_S_No"></span>
                </td>
                <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Old%><%=Resources.Cost.Supplier_Short_Name%></td>
                <td style="text-align: left; width: 15%;">
                    <span id="LB_CD_S_SName"></span>
                </td>
            </tr>
            <tr style="background-color:lightgray;">
                <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Old%><%=Resources.Cost.Product_Information%></td>
                <td style="text-align: left; width: 15%;" colspan="3">
                    <span id="LB_CD_P_IM"></span>
                </td>
            </tr>

            <tr>
                <td style="text-align:right;"><%=Resources.Cost.New%><%=Resources.Cost.Ivan_Model%></td>
                <td style="text-align:left;" colspan="3">
                    <input style="width: 90%; height: 25px;" id="TB_CD_IM" />
                </td>
            </tr>
            <tr>
                <td style="text-align:right;"><%=Resources.Cost.New%><%=Resources.Cost.Supplier_No%></td>
                <td style="text-align:left;" colspan="3">
                    <input style="width: 90%; height: 25px;" id="TB_CD_S_No" />
                    <input type="hidden" id="HDN_CD_S_SName" />
                </td>
            </tr>
        </table>
    </div>
    
    <div id="Search_Customer_Dialog" style="display: none;">
        <table border="0" style="margin: 0 auto;" id="SCD_Table">
            <tr style="text-align: right;">
                <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Price.Customer_No%></td>
                <td style="text-align: left; width: 15%;">
                    <input style="width: 90%; height: 25px;" id="SCD_TB_C_No" />
                </td>

                <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Price.Customer_Short_Name%></td>
                <td style="text-align: left; width: 15%;">
                    <input style="width: 90%; height: 25px;" id="SCD_TB_C_SName" />
                </td>
            </tr>
            <tr><td><br /></td></tr>
            <tr>
                <td style="text-align: center;" colspan="4">
                    <div style="display: flex; justify-content: center; align-items: center;">
                        <input id="SCD_BT_Search" class="BTN" type="button" value="<%=Resources.MP.Search%>" style="width:10%;" />
                    </div>
                </td>
            </tr>
        </table>
        <div id="SCD_Div_DT" style="margin: auto; width: 98%; overflow: auto; display: none;">
            <br />
            <table id="SCD_Table_Customer" style="width: 100%;" class="table table-striped table-bordered dt-responsive">
                <thead></thead>
                <tbody></tbody>
            </table>
        </div>
    </div>

    <div id="Search_Product_Dialog" style="display: none;">
        <table border="0" style="margin: 0 auto;" id="SPD_Table">
            <tr style="text-align: right;">
                <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Price.Ivan_Model%></td>
                <td style="text-align: left; width: 15%;">
                    <input style="width: 90%; height: 25px;" id="SPD_TB_IM" />
                </td>

                <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Price.Supplier_No%></td>
                <td style="text-align: left; width: 15%;">
                    <input style="width: 90%; height: 25px;" id="SPD_TB_S_No" />
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
        <div id="SPD_Div_DT" style="margin: auto; width: 98%; overflow: auto; display: none;">
            <br />
            <table id="SPD_Table_Product" style="width: 100%;" class="table table-striped table-bordered dt-responsive">
                <thead></thead>
                <tbody></tbody>
            </table>
        </div>
    </div>

    <table class="table_th" style="text-align:left;">
        <tr>
            <td style="height: 10px; font-size: smaller;" colspan="8">&nbsp</td>
        </tr>
        <tr>
            <td style="width: 10%;"></td>
            <td style="width:10%;">
                <input type="button" id="BT_New" class="M_BT" value="<%=Resources.MP.Insert%>" />
            </td>
            <td style="width:10%;">
                <input type="button" id="BT_Search" class="M_BT" value="<%=Resources.MP.Search%>" />
            </td>
            <td style="width:10%;">
                <input type="button" id="BT_Detail_Search" class="M_BT" value="<%=Resources.MP.Detail_Search%>" />
            </td>
            <td style="width:10%;">
                <input type="button" id="BT_Cancel" class="M_BT" value="<%=Resources.MP.Cancel%>" style="display:none;" />
            </td>
            <td style="width:80%;">
            </td>
        </tr>
        <tr>
            <td style="height: 10px; font-size: smaller;" colspan="8">&nbsp</td>
        </tr>
    </table>

    <div id="Div_DT_View" style="margin: auto;width:98%;overflow:auto;display:none;">
        <table id="Table_Search_Price" style="width:100%;" class="table table-striped table-bordered">
            <thead></thead>
            <tbody></tbody>
        </table>
    </div> 
    <div id="Div_Edit_Area" style="width: 99%; margin: 0 auto; background-color: white;">
        &nbsp;
        <input type="button" id="BT_ED_Edit" class="ED_BT" value="<%=Resources.MP.Edit%>" style="display:none;" />
        <input type="button" id="BT_ED_Copy" class="ED_BT" value="<%=Resources.MP.Copy%>" style="display:none;" />
        <input type="button" id="BT_ED_Save" class="ED_BT" value="<%=Resources.MP.Save%>" style="display:none;" />
        <input type="button" id="BT_ED_Cancel" class="ED_BT" value="<%=Resources.MP.Cancel%>" style="display:none;" />
    </div>
    <div style="width: 99%; margin: 0 auto; background-color: white;">
        &nbsp;
        <input id="V_BT_Master" type="button" class="V_BT" value="<%=Resources.MP.Master%>" onclick="$('.Div_D').css('display','none');$('#Div_M2').css('display','');" disabled="disabled" />
        <input type="button" class="V_BT" style="display:none;" value="<%=Resources.Cost.Image%>" onclick="$('.Div_D').css('display','none');$('#Div_Image').css('display','');" />
        <input type="button" class="V_BT" style="display:none;" value="<%=Resources.MP.Sample%>" onclick="$('.Div_D').css('display','none');$('#Div_More').css('display','');" />
    </div>
    <div style="width: 100%;" id="Div_Detail_Form">
        <div id="Div_M2" class="Div_D">
            <table style="font-size: 15px; border-collapse: separate; border-spacing: 0px 8px;">
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;display:none;" class="M2_For_V"><%=Resources.Price.SEQ%></td>
                    <td style="text-align: left; width: 15%;display:none;" colspan="3" class="M2_For_V">
                        <input id="TB_M2_SEQ" class="disabled" disabled="disabled" style="width: 100%;" />
                    </td>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Price.Developing%></td>
                    <td style="text-align: left; width: 15%;">
                        <select id="DDL_M2_DVN" disabled="disabled" style="width: 100%;" >
                            <option selected="selected">Y</option>
                            <option>N</option>
                        </select>
                    </td>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Price.Trademark%></td>
                    <td style="text-align: left; width: 15%;">
                        <select id="DDL_M2_TM" disabled="disabled" style="width: 100%;" >
                        </select>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Price.Customer_Model%></td>
                    <td style="text-align: left; width: 15%;" colspan="3">
                        <input id="TB_M2_CM" autocomplete="off" required="required" disabled="disabled" style="width: 100%;" />
                    </td>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Price.Last_Price_Day%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M2_LSPD" disabled="disabled" type="date" style="width: 100%;" />
                    </td>
                    <td class="M2_For_V" style="text-align: right; text-wrap: none; width: 10%; display: none;"><%=Resources.Price.Stop_Date%></td>
                    <td class="M2_For_V" style="text-align: left; width: 15%; display: none;">
                        <input id="TB_M2_SD" autocomplete="off" disabled="disabled" type="date" style="width: 100%;" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Price.Customer_No%></td>
                    <td style="text-align: left; width: 15%;" colspan="3">
                        <div style="width: 90%; float: left; z-index: -10;">
                            <input id="TB_M2_C_No" class="disabled" required="required" disabled="disabled" style="width: 100%;" />
                        </div>
                        <div class="M2_For_NU" style="width: 10%; float: right; z-index: 10;display: none;">
                            <input id="BT_M2_Customer_Selector" type="button" value="…" disabled="disabled" style="float: right; z-index: 10;width:100%;" />
                        </div>
                    </td>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Price.Customer_Short_Name%></td>
                    <td style="text-align: left; width: 15%;" colspan="3">
                        <input id="TB_M2_C_SName" class="disabled" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Price.Ivan_Model%></td>
                    <td style="text-align: left; width: 15%;" colspan="3">
                        <div style="width: 90%; float: left; z-index: -10;">
                            <input id="TB_M2_IM" class="disabled" required="required" disabled="disabled" style="width: 100%;" />
                            <input type="hidden" id="HDN_M2_P_SEQ" />
                        </div>
                        <div class="M2_For_NU" style="width: 10%; float: right; z-index: 10;display: none;">
                            <input id="BT_M2_Product_Selector" type="button" value="…" disabled="disabled" style="float: right; z-index: 10;width:100%;" />
                        </div>
                    </td>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Price.Unit%></td>
                    <td style="text-align: left; width: 15%;" colspan="3">
                        <input id="TB_M2_Unit" class="disabled" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Price.Supplier_No%></td>
                    <td style="text-align: left; width: 15%;" colspan="3">
                        <input id="TB_M2_S_No" class="disabled" disabled="disabled" style="width: 100%;" />
                    </td>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Supplier_Short_Name%></td>
                    <td style="text-align: left; width: 15%;" colspan="3">
                        <input id="TB_M2_S_SName" class="disabled" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Product_Information%></td>
                    <td style="text-align: left; width: 15%;" colspan="7">
                        <input id="TB_M2_P_IM" class="disabled" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;">
                        <%=Resources.Price.TWD_Price%>
                        <br />
                        <%=Resources.Price.USD_Price%>
                    </td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M2_TWD_1" autocomplete="off" disabled="disabled" type="number" value="0" style="width: 100%;text-align:right;" />
                        <br />
                        <input id="TB_M2_USD_1" autocomplete="off" disabled="disabled" type="number" value="0" style="width: 100%;text-align:right;" />
                    </td>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Price.Price_T%>_2</td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M2_P_2" autocomplete="off" disabled="disabled" type="number" value="0" style="width: 100%;text-align:right;" />
                    </td>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Price.Price_T%>_3</td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M2_P_3" autocomplete="off" disabled="disabled" type="number" value="0" style="width: 100%;text-align:right;" />
                    </td>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Price.Price_T%>_4</td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M2_P_4" autocomplete="off" disabled="disabled" type="number" value="0" style="width: 100%;text-align:right;" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;">MIN_1</td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M2_MIN_1" autocomplete="off" disabled="disabled" type="number" value="0" style="width: 100%;text-align:right;" />
                    </td>
                    <td style="text-align: right; text-wrap: none; width: 10%;">MIN_2</td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M2_MIN_2" autocomplete="off" disabled="disabled" type="number" value="0" style="width: 100%;text-align:right;" />
                    </td>
                    <td style="text-align: right; text-wrap: none; width: 10%;">MIN_3</td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M2_MIN_3" autocomplete="off" disabled="disabled" type="number" value="0" style="width: 100%;text-align:right;" />
                    </td>
                    <td style="text-align: right; text-wrap: none; width: 10%;">MIN_4</td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M2_MIN_4" autocomplete="off" disabled="disabled" type="number" value="0" style="width: 100%;text-align:right;" />
                    </td>
                </tr>
                <tr class="M2_For_V" style="display:none;">
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Price.Update_User%></td>
                    <td style="text-align: left; width: 15%;" colspan="3">
                        <input id="TB_M2_Update_User" class="disabled" disabled="disabled" style="width: 100%;" />
                    </td>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Price.Update_Date%></td>
                    <td style="text-align: left; width: 15%;" colspan="3">
                        <input id="TB_M2_Update_Date" class="disabled" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Remark%></td>
                    <td style="text-align: left; width: 15%;" colspan="7">
                        <textarea id="TB_M2_Remark" style="width: 100%; height: 250px;" maxlength="560" disabled="disabled"></textarea>
                    </td>
                </tr>
                <tr>
                    <td colspan="8" style="margin: auto;">
                        <div style="display: flex; justify-content: center; align-items: center;">
                            <input id="BT_New_Save" class="BTN" style="display:none;" type="button" value="<%=Resources.MP.Save%>" />
                        </div>
                    </td>
                </tr>
            </table>
        </div>

        <div id="Div_Image" class="Div_D" style="display: none; overflow: auto;">
            <table style="font-size: 15px; border-collapse: separate; border-spacing: 0px 8px;">
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Price.Ivan_Model%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_I_IM" class="disabled" disabled="disabled" style="width: 100%;" />
                    </td>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Price.Supplier_No%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_I_S_No" class="disabled" disabled="disabled" style="width: 100%;" />
                    </td>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Price.Supplier_Short_Name%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_I_S_SName" class="disabled" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Product_Information%></td>
                    <td style="text-align: left; width: 15%;" colspan="7">
                        <input id="TB_I_P_IM" class="disabled" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align:center; width: 15%;" colspan="8">
                        <img id="IMG_I_IMG" src=""  />
                        <span id="IMG_I_IMG_Hint" style="display:none;"><%=Resources.Cost.Image_NotExists%></span>
                    </td>
                </tr>
            </table>
        </div>

        <div id="Div_More" class="Div_D" style="display: none; overflow: auto">
            <%--<table style="font-size: 15px; border-collapse: separate; border-spacing: 0px 10px;">
            </table>--%>
        </div>

    </div>
    <br />
    <br />

</asp:Content>

