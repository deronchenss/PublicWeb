<%@ Page Title="Price Maintenance" Language="C#" MasterPageFile="~/MP.master" AutoEventWireup="true" CodeFile="Price_MT.aspx.cs" Inherits="Price_MT" %>
<%@ Register TagPrefix="uc1" TagName="uc1" Src="~/User_Control/Dia_Customer_Selector.ascx" %>
<%@ Register TagPrefix="uc2" TagName="uc2" Src="~/User_Control/Dia_Product_Selector.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <link href="/css/dataTables.bootstrap4.min.css" rel="stylesheet" />
    <script src="/js/jquery.dataTables.min.js"></script>
    <script src="/js/dataTables.bootstrap4.min.js"></script>

    <script type="text/javascript">
        $(document).ready(function () {
            var Click_tr_IDX;
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
                        $('.M2_For_V, .M2_For_N').css('display', 'none');
                        break;
                    case "New_M":
                        $('input[required], select[required]').css('background-color', 'yellow');
                        $('.M2_For_N').css('display', '');
                        $('#Div_Detail_Form input, #Div_Detail_Form textarea, #Div_Detail_Form select').not('.disabled').attr('disabled', false);
                        $('#BT_New, #BT_Search, #BT_Detail_Search').css('display', 'none');
                        $('#BT_Cancel, #BT_New_Save').css('display', '');
                        break;
                    case "Search_M":
                        //$('#Div_Detail_Form input, #Div_Detail_Form textarea, #Div_Detail_Form select').attr('disabled', 'disabled');
                        $('#BT_New, #BT_Search, #BT_Detail_Search, #BT_ED_Save, #BT_ED_Cancel, #BT_ED_Edit, #BT_ED_Copy').css('display', 'none');
                        $('#BT_Cancel, #Div_DT_View').css('display', '');
                        //$('.ED_BT').css('display', 'none');
                        //$('#BT_ED_Edit, #BT_Cancel, #Div_DT_View').css('display', '');
                        //$('#BT_ED_Save, #BT_ED_Cancel').css('display', 'none');
                        break;
                    case "Search_D":
                        $('#Div_Detail_Form input, #Div_Detail_Form textarea, #Div_Detail_Form select').css('background-color', '');
                        $('.V_BT').css('display', '');
                        $('.M2_For_V').css('display', '');
                        $('#Div_Detail_Form input, #Div_Detail_Form textarea, #Div_Detail_Form select').attr('disabled', 'disabled');
                        $('#BT_ED_Edit, #BT_ED_Copy, #BT_Cancel, #Div_DT_View').css('display', '');
                        $('#BT_ED_Save, #BT_ED_Cancel').css('display', 'none');
                        break;//TB_M2_Change_Log
                    case "Edit_D":
                        $('#BT_ED_Edit, #BT_ED_Copy, #BT_Cancel, #Div_DT_View, .M2_For_N').css('display', 'none');
                        $('#BT_ED_Save, #BT_ED_Cancel').css('display', '');
                        $('#Div_Detail_Form input, #Div_Detail_Form textarea, #Div_Detail_Form select').not('.disabled').attr('disabled', false);
                        break;
                }
            }

            $('#BT_New').on('click', function () {
                From_Mode = "New";
                Form_Mode_Change("New_M");
            });

            function Save_Check() {
                //Byrlu_UK: 客戶型號&客戶編號
                var Check_Item = true;
                var Alert_Message = "";
                $('#Div_Detail_Form input, #Div_Detail_Form textarea, #Div_Detail_Form select').css('background-color', '');
                $('input[required], select[required]').css('background-color', 'yellow');
                if ($('#TB_M2_CM').val().length === 0) {
                    Check_Item = false;
                    $('#TB_M2_CM').css('background-color', 'red');
                    Alert_Message += "請輸入客戶型號";
                }
                if ($('#TB_M2_C_No').val().length === 0) {
                    Check_Item = false;
                    $('#TB_M2_C_No').css('background-color', 'red');
                    Alert_Message += "\r\n請選擇客戶編號 ";
                }
                if ($('#TB_M2_IM').val().length === 0) {
                    Check_Item = false;
                    $('#TB_M2_IM').css('background-color', 'red');
                    Alert_Message += "\r\n請選擇頤坊型號 ";
                }
                if ($('#TB_M2_PRI').val().length === 0) {
                    Check_Item = false;
                    $('#TB_M2_PRI').css('background-color', 'red');
                    Alert_Message += "\r\n請輸入價格資訊";
                }
                if ($('#TB_M2_PRI').val().length > 80) {
                    Check_Item = false;
                    $('#TB_M2_PRI').css('background-color', 'red');
                    Alert_Message += "\r\n價格資訊過長，最大80碼";
                }
                if (Alert_Message.length > 0) {
                    alert(Alert_Message);
                }
                return Check_Item;
            };

            $('#BT_New_Save').on('click', function () {
                if (confirm("<%=Resources.MP.Save_Alert%>")) {
                    if (Save_Check()) {
                        $.ajax({
                            url: "/Base/Price/Price_Save.ashx",
                            data: {
                                "DVN": $('#DDL_M2_DVN').val(),
                                "TM": $('#DDL_M2_TM').val(),
                                "CM": $('#TB_M2_CM').val(),
                                "LSPD": $('#TB_M2_LSPD').val(),
                                "C_No": $('#TB_M2_C_No').val(),
                                "C_SName": $('#TB_M2_C_SName').val(),
                                "IM": $('#TB_M2_IM').val(),
                                "Unit": $('#TB_M2_Unit').val(),
                                "S_No": $('#TB_M2_S_No').val(),
                                "S_SName": $('#TB_M2_S_SName').val(),
                                "PRI": $('#TB_M2_PRI').val(),
                                "TWD_P": parseFloat($('#TB_M2_TWD_1').val()) || 0,
                                "USD_P": parseFloat($('#TB_M2_USD_1').val()) || 0,
                                "P_2": parseFloat($('#TB_M2_P_2').val()) || 0,
                                "P_3": parseFloat($('#TB_M2_P_3').val()) || 0,
                                "P_4": parseFloat($('#TB_M2_P_4').val()) || 0,
                                "MIN_1": parseFloat($('#TB_M2_MIN_1').val()) || 0,
                                "MIN_2": parseFloat($('#TB_M2_MIN_2').val()) || 0,
                                "MIN_3": parseFloat($('#TB_M2_MIN_3').val()) || 0,
                                "MIN_4": parseFloat($('#TB_M2_MIN_4').val()) || 0,
                                "Update_User": 'Ivan10',
                                "Remark": $('#TB_M2_Remark').val(),
                                "Call_Type": "Price_New"
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
                Click_tr_IDX = null;
                $.ajax({
                    url: "/Base/Price/Price_Search.ashx",
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
                                { data: "SEQ", title: "<%=Resources.MP.SEQ%>" },
                                { data: "CM", title: "<%=Resources.MP.Customer_Model%>" },
                                { data: "IM", title: "<%=Resources.MP.Ivan_Model%>" },
                                { data: "DVN", title: "<%=Resources.MP.Developing%>" },
                                { data: "TWD_P", title: "<%=Resources.MP.TWD_Price%>" },
                                { data: "USD_P", title: "<%=Resources.MP.USD_Price%>" },
                                { data: "MIN_1", title: "MIN_1" },
                                { data: "C_SName", title: "<%=Resources.MP.Customer_Short_Name%>" },
                                { data: "S_SName", title: "<%=Resources.MP.Supplier_Short_Name%>" },
                                { data: "Unit", title: "<%=Resources.MP.Unit%>" },
                                { data: "LSTP_Day", title: "<%=Resources.MP.Last_Price_Day%>" },
                                { data: "SDate", title: "<%=Resources.MP.Stop_Date%>" },
                                { data: "PRI", title: "<%=Resources.MP.Price_Information%>" },
                                { data: "S_No", title: "<%=Resources.MP.Supplier_No%>" },
                                { data: "C_No", title: "<%=Resources.MP.Customer_No%>" },
                                { data: "SUPLU_SEQ", title: "<%=Resources.MP.Product_SEQ%>" },
                                { data: "Update_User", title: "<%=Resources.MP.Update_User%>" },
                                { data: "Update_Date", title: "<%=Resources.MP.Update_Date%>" }
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
                Click_tr_IDX = $(this).index();
                FN_Tr_Click($(this));
            });

            $(window).keydown(function (e) {
                if (Click_tr_IDX != null) {
                    switch (e.keyCode) {
                        case 38://^
                            if (Click_tr_IDX > 0) {
                                Click_tr_IDX -= 1;
                            }
                            FN_Tr_Click($('#Table_Search_Price tbody tr:nth(' + Click_tr_IDX + ')'));
                            break;
                        case 40://v
                            if (Click_tr_IDX < ($('#Table_Search_Price tbody tr').length - 1)) {
                                Click_tr_IDX += 1;
                            }
                            FN_Tr_Click($('#Table_Search_Price tbody tr:nth(' + Click_tr_IDX + ')'));
                            break;
                    }
                }
            });

            function FN_Tr_Click(Click_tr) {
                Click_tr.parent().find('tr').css('background-color', '');
                Click_tr.parent().find('tr').css('color', 'black');
                Click_tr.css('background-color', '#5a1400');
                Click_tr.css('color', 'white');
                Form_Mode_Change("Search_D");

                $.ajax({
                    url: "/Base/Price/Price_Search.ashx",
                    data: {
                        "SEQ": Click_tr.find('td:nth-child(1)').text(),
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
                        $('#TB_M2_PRI').val(String(response[0].PRI ?? ""));
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
                        $('#TB_M2_Change_Log').val(String(response[0].CL ?? ""));

                        $('#TB_I_IM').val(String(response[0].IM ?? ""));
                        $('#TB_I_S_No').val(String(response[0].S_No ?? ""));
                        $('#TB_I_S_SName').val(String(response[0].S_SName ?? ""));
                        $('#TB_I_PRI').val(String(response[0].PRI ?? ""));

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
            };

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
                            url: "/Base/Price/Price_Save.ashx",
                            data: {
                                "SEQ": $('#TB_M2_SEQ').val(),
                                "DVN": $('#DDL_M2_DVN').val(),
                                "TM": $('#DDL_M2_TM').val(),
                                "CM": $('#TB_M2_CM').val(),
                                "LSPD": $('#TB_M2_LSPD').val(),
                                "SD": $('#TB_M2_SD').val(),
                                "C_No": $('#TB_M2_C_No').val(),
                                "C_SName": $('#TB_M2_C_SName').val(),
                                "IM": $('#TB_M2_IM').val(),
                                "Unit": $('#TB_M2_Unit').val(),
                                "S_No": $('#TB_M2_S_No').val(),
                                "S_SName": $('#TB_M2_S_SName').val(),
                                "PRI": $('#TB_M2_PRI').val(),
                                "TWD_P": parseFloat($('#TB_M2_TWD_1').val()) || 0,
                                "USD_P": parseFloat($('#TB_M2_USD_1').val()) || 0,
                                "P_2": parseFloat($('#TB_M2_P_2').val()) || 0,
                                "P_3": parseFloat($('#TB_M2_P_3').val()) || 0,
                                "P_4": parseFloat($('#TB_M2_P_4').val()) || 0,
                                "MIN_1": parseFloat($('#TB_M2_MIN_1').val()) || 0,
                                "MIN_2": parseFloat($('#TB_M2_MIN_2').val()) || 0,
                                "MIN_3": parseFloat($('#TB_M2_MIN_3').val()) || 0,
                                "MIN_4": parseFloat($('#TB_M2_MIN_4').val()) || 0,
                                "Update_User": 'Ivan10',
                                "Remark": $('#TB_M2_Remark').val(),
                                "Call_Type": "Price_Update"
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

            $('#BT_ED_Copy').on('click', function () {
                $("#Copy_Dialog").dialog('open');
                $('#TB_CD_CM').css('background-color', '');
                $('#LB_CD_SEQ').text($('#TB_M2_SEQ').val());
                $('#LB_CD_CM').text($('#TB_M2_CM').val());
                $('#TB_CD_CM').val('');
                $('#LB_CD_C_No').text($('#TB_M2_C_No').val());
                $('#LB_CD_C_SName').text($('#TB_M2_C_SName').val());
                $('#LB_CD_IM').text($('#TB_M2_IM').val());
                $('#LB_CD_S_No').text($('#TB_M2_S_No').val());
                $('#LB_CD_S_SName').text($('#TB_M2_S_SName').val());
            });

            function Copy_Check() {
                var Check_Item = true;
                var Alert_Message = "";
                $('#TB_CD_CM').css('background-color', '');
                if ($('#TB_CD_CM').val().length === 0) {
                    Check_Item = false;
                    $('#TB_CD_CM').css('background-color', 'red');
                    Alert_Message += "請輸入新客戶型號";
                }
                //$('#TB_CD_IM, #TB_CD_S_No').css('background-color', '');
                //if ($('#TB_CD_S_No').val().length === 0) {
                //    Alert_Message += "\r\n請輸入廠商編號";
                //    $('#TB_CD_S_No').css('background-color', 'red');
                //    Check_Item = false;
                //}
               //Will Add MSRP換廠商?
                if (!Check_Item) {
                    alert(Alert_Message);
                }
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
            $('#BT_CD_Customer_Selector').on('click', function () {
                PS_Control = 'C';
                $("#Search_Customer_Dialog").dialog('open');
            });

            $('#SCD_Table_Customer').on('click', '.CUST_SEL', function () {
                switch (PS_Control) {
                    case "NU"://New&Update
                        $('#TB_M2_C_No').val($(this).parent().parent().find('td:nth(2)').text());
                        $('#TB_M2_C_SName').val($(this).parent().parent().find('td:nth(3)').text());
                        break;
                    case "C"://Copy
                        $('#TB_CD_C_No').val($(this).parent().parent().find('td:nth(2)').text());
                        $('#TB_CD_C_SName').val($(this).parent().parent().find('td:nth(3)').text());
                        break;
                }
                $("#Search_Customer_Dialog").dialog('close');
            });

            $('#BT_M2_Product_Selector').on('click', function () {
                PS_Control = 'NU';
                $("#Search_Product_Dialog").dialog('open');
            });
            $('#BT_CD_Product_Selector').on('click', function () {
                PS_Control = 'C';
                $("#Search_Product_Dialog").dialog('open');
            });

            $('#SPD_Table_Product').on('click', '.PROD_SEL', function () {
                switch (PS_Control) {
                    case "NU"://New&Update
                        $('#HDN_M2_SUPLU_SEQ').val($(this).parent().parent().find('td:nth(1)').text());
                        $('#TB_M2_IM').val($(this).parent().parent().find('td:nth(3)').text());
                        $('#TB_M2_S_No').val($(this).parent().parent().find('td:nth(4)').text());
                        $('#TB_M2_S_SName').val($(this).parent().parent().find('td:nth(5)').text());
                        break;
                    case "C"://Copy
                        $('#HDN_CD_SUPLU_SEQ').val($(this).parent().parent().find('td:nth(1)').text());
                        $('#TB_CD_IM').val($(this).parent().parent().find('td:nth(3)').text());
                        $('#TB_CD_S_No').val($(this).parent().parent().find('td:nth(4)').text());
                        $('#TB_CD_S_SName').val($(this).parent().parent().find('td:nth(5)').text());
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
                                            Where_Text += " AND [客戶編號] LIKE '%" + $('#Dia_TB1_S_No').val() + "%'";
                                            break;
                                        case "LIKE%":
                                            Where_Text += " AND [客戶編號] LIKE '" + $('#Dia_TB1_S_No').val() + "%'";;
                                            break;
                                        case "%LIKE":
                                            Where_Text += " AND [客戶編號] LIKE '%" + $('#Dia_TB1_S_No').val() + "'";;
                                            break;
                                        default:
                                            Where_Text += " AND [客戶編號] " + $('#Dia_TB1_Operator2').val() + " '" + $('#Dia_TB1_S_No').val() + "'";
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
                    width: screen.width * 0.8,
                    overlay: 0.5,
                    buttons: {
                        "Copy": function () {
                            if (Copy_Check()) {
                                $("#Copy_Dialog").dialog('close');
                                $.ajax({
                                    url: "/Base/Price/Price_Save.ashx",
                                    data: {
                                        "Old_SEQ": $('#LB_CD_SEQ').text(),
                                        "CM": $('#TB_CD_CM').val(),
                                        "C_No": $('#TB_CD_C_No').val(),
                                        "C_SName": $('#TB_CD_C_SName').val(),
                                        "IM": $('#TB_CD_IM').val(),
                                        "S_No": $('#TB_CD_S_No').val(),
                                        "S_SName": $('#TB_CD_S_SName').val(),
                                        "Update_User" : "Ivan10",
                                        "Call_Type": "Price_Copy"
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
    <uc1:uc1 ID="uc1" runat="server" /> 
    <uc2:uc2 ID="uc2" runat="server" /> 

    <div id="dialog" style="display: none;">
        <div style="width: 100%; text-align: center;">
            <input type="button" id="Dia_BT_Simple_Change" value="Simple" style="width: 20%" disabled="disabled" />
            <input type="button" id="Dia_BT_Multiple_Change" value="Multiple" style="width: 20%" />
        </div>
        <br />
        <table border="0" style="margin: 0 auto;" id="Dia_Table_Simple">
            <tr style="text-align: right;">
                <td style="width: 20%;"><%=Resources.MP.Ivan_Model%></td>
                <td style="width: 30%;">
                    <select style="width: 90%; height: 25px;" id="Dia_TB1_Operator1">
                        <option>=</option>
                        <option>%LIKE%</option>
                        <option selected="selected">LIKE%</option>
                        <option>%LIKE</option>
                    </select>
                </td>
                <td style="width: 50%;">
                    <input style="width: 90%; height: 25px;" id="Dia_TB1_IM" />
                </td>
            </tr>
            <tr style="text-align: right;">
                <td style="width: 20%;"><%=Resources.MP.Supplier_No%></td>
                <td style="width: 30%;">
                    <select style="width: 90%; height: 25px;" id="Dia_TB1_Operator2">
                        <option>=</option>
                        <option>%LIKE%</option>
                        <option selected="selected">LIKE%</option>
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
                        <option value="[頤坊型號]"><%=Resources.MP.Ivan_Model%></option>
                        <option value="[客戶型號]"><%=Resources.MP.Customer_Model%></option>
                        <option value="[開發中]"><%=Resources.MP.Developing%></option>
                        <option value="[客戶簡稱]"><%=Resources.MP.Customer_Short_Name%></option>
                        <option value="[美元單價]"><%=Resources.MP.Price_USD%></option>
                        <option value="[廠商簡稱]"><%=Resources.MP.Supplier_Short_Name%></option>
                        <option value="[單位]"><%=Resources.MP.Unit%></option>
                        <option value="[MIN_1]">MIN_1</option>
                        <option value="[最後價日]"><%=Resources.MP.Last_Price_Day%></option>
                        <option value="[台幣單價]"><%=Resources.MP.Price_TWD%></option>
                        <option value="[停用日期]"><%=Resources.MP.Stop_Date%></option>
                        <option value="[產品說明]"><%=Resources.MP.Product_Information%></option>
                        <option value="[客戶編號]"><%=Resources.MP.Customer_No%></option>
                        <option value="[序號]"><%=Resources.MP.SEQ%></option>
                        <option value="[更新人員]"><%=Resources.MP.Update_User%></option>
                        <option value="[更新日期]"><%=Resources.MP.Update_Date%></option>
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
                        <option>%LIKE%</option>
                        <option selected="selected">LIKE%</option>
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
        <table style="font-size: 15px; border-collapse: separate; border-spacing: 0px 0px;" id="CD_Table">

            <tr style="background-color:lightgray;">
                <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Old%><%=Resources.MP.SEQ%></td>
                <td style="text-align: left; width: 15%;">
                    <span id="LB_CD_SEQ"></span>
                </td>
                <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Old%><%=Resources.MP.Customer_Model%></td>
                <td style="text-align: left; width: 15%;">
                    <span id="LB_CD_CM"></span>
                </td>
            </tr>
            <tr style="background-color:lightgray;">
                <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Old%><%=Resources.MP.Customer_No%></td>
                <td style="text-align: left; width: 15%;">
                    <span id="LB_CD_C_No"></span>
                </td>
                <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Old%><%=Resources.MP.Customer_Short_Name%></td>
                <td style="text-align: left; width: 15%;">
                    <span id="LB_CD_C_SName"></span>
                </td>
            </tr>
            <tr style="background-color:lightgray;">
                <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Old%><%=Resources.MP.Ivan_Model%></td>
                <td style="text-align: left; width: 15%;">
                    <span id="LB_CD_IM"></span>
                </td>
                <td style="text-align: right; text-wrap: none; width: 10%;">
                    <%=Resources.MP.Old%><%=Resources.MP.Supplier_No%>
                    <br />
                    <%=Resources.MP.Old%><%=Resources.MP.Supplier_Short_Name%>
                </td>
                <td style="text-align: left; width: 15%;">
                    <span id="LB_CD_S_No"></span>
                    <br />
                    <span id="LB_CD_S_SName"></span>
                </td>
            </tr>
            
            <tr>
                <td style="text-align:right;"><%=Resources.MP.New%><%=Resources.MP.Customer_Model%></td>
                <td style="text-align: left; width: 15%;">
                    <input id="TB_CD_CM" required="required" autocomplete="off" style="width: 100%;" />
                </td>
            </tr>   
            <tr>
                <td style="text-align:right;"><%=Resources.MP.New%><%=Resources.MP.Customer_No%></td>
                <td style="text-align:left;">
                    <div style="width: 90%; float: left; z-index: -10;">
                        <input id="TB_CD_C_No" class="disabled" required="required" disabled="disabled" style="width: 100%;" />
                    </div>
                    <div style="width: 10%; float: right; z-index: 10;">
                        <input id="BT_CD_Customer_Selector" type="button" value="…" style="float: right; z-index: 10; width: 100%;" />
                    </div>
                </td>
                <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.New%><%=Resources.MP.Customer_Short_Name%></td>
                <td style="text-align: left; width: 15%;" colspan="3">
                    <input id="TB_CD_C_SName" class="disabled" disabled="disabled" style="width: 100%;" />
                </td>
            </tr>
            <tr>
                <td style="text-align:right;"><%=Resources.MP.New%><%=Resources.MP.Ivan_Model%></td>
                <td style="text-align:left;">
                    <div style="width: 90%; float: left; z-index: -10;">
                        <input id="TB_CD_IM" class="disabled" required="required" disabled="disabled" style="width: 100%;" />
                        <input type="hidden" id="HDN_CD_SUPLU_SEQ" />
                    </div>
                    <div style="width: 10%; float: right; z-index: 10;">
                        <input id="BT_CD_Product_Selector" type="button" value="…" style="float: right; z-index: 10; width: 100%;" />
                    </div>
                </td>
                <td style="text-align: right; text-wrap: none; width: 10%;">
                    <%=Resources.MP.New%><%=Resources.MP.Supplier_No%>
                    <br />
                    <%=Resources.MP.New%><%=Resources.MP.Supplier_Short_Name%>
                </td>
                <td style="text-align: left; width: 15%;">
                    <input id="TB_CD_S_No" class="disabled" disabled="disabled" style="width: 100%;" />
                    <br />
                    <input id="TB_CD_S_SName" class="disabled" disabled="disabled" style="width: 100%;" />
                </td>
            </tr>
        </table>
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
    <div id="Div_DT_View" style="margin: auto;width:98%;overflow:auto;display:none;height:45vh;">
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
        <input type="button" class="V_BT" style="display:none;" value="<%=Resources.MP.Image%>" onclick="$('.Div_D').css('display','none');$('#Div_Image').css('display','');" />
        <input type="button" class="V_BT" style="display:none;" value="<%=Resources.MP.Sample%>" onclick="$('.Div_D').css('display','none');$('#Div_More').css('display','');" />
    </div>
    <div style="width: 100%;" id="Div_Detail_Form">
        <div id="Div_M2" class="Div_D">
            <table style="font-size: 15px; border-collapse: separate; border-spacing: 0px 8px;">
                <tr style="display:none;" class="M2_For_V">
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.SEQ%></td>
                    <td style="text-align: left; width: 15%;" colspan="3">
                        <input id="TB_M2_SEQ" class="disabled" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Developing%></td>
                    <td style="text-align: left; width: 15%;">
                        <select id="DDL_M2_DVN" disabled="disabled" style="width: 100%;" >
                            <option selected="selected">Y</option>
                            <option>N</option>
                        </select>
                    </td>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Trademark%></td>
                    <td style="text-align: left; width: 15%;">
                        <select id="DDL_M2_TM" disabled="disabled" style="width: 100%;" >
                        </select>
                    </td>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Last_Price_Day%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M2_LSPD" disabled="disabled" type="date" style="width: 100%;" />
                    </td>
                    <td class="M2_For_V" style="text-align: right; text-wrap: none; width: 10%; display: none;"><%=Resources.MP.Stop_Date%></td>
                    <td class="M2_For_V" style="text-align: left; width: 15%; display: none;">
                        <input id="TB_M2_SD" autocomplete="off" disabled="disabled" type="date" style="width: 100%;" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Customer_Model%></td>
                    <td style="text-align: left; width: 15%;" colspan="3">
                        <input id="TB_M2_CM" autocomplete="off" required="required" disabled="disabled" style="width: 100%;" />
                    </td>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Unit%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M2_Unit" autocomplete="off" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Customer_No%></td>
                    <td style="text-align: left; width: 15%;" colspan="3">
                        <div style="width: 90%; float: left; z-index: -10;">
                            <input id="TB_M2_C_No" class="disabled" required="required" disabled="disabled" style="width: 100%;" />
                        </div>
                        <div class="M2_For_N" style="width: 10%; float: right; z-index: 10;display: none;">
                            <input id="BT_M2_Customer_Selector" type="button" value="…" disabled="disabled" style="float: right; z-index: 10;width:100%;" />
                        </div>
                    </td>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Customer_Short_Name%></td>
                    <td style="text-align: left; width: 15%;" colspan="3">
                        <input id="TB_M2_C_SName" class="disabled" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Ivan_Model%></td>
                    <td style="text-align: left; width: 15%;" colspan="3">
                        <div style="width: 90%; float: left; z-index: -10;">
                            <input id="TB_M2_IM" class="disabled" required="required" disabled="disabled" style="width: 100%;" />
                            <input type="hidden" id="HDN_M2_SUPLU_SEQ" />
                        </div>
                        <div class="M2_For_N" style="width: 10%; float: right; z-index: 10;display: none;">
                            <input id="BT_M2_Product_Selector" type="button" value="…" disabled="disabled" style="float: right; z-index: 10;width:100%;" />
                        </div>
                    </td>
                    <td style="text-align: right; text-wrap: none; width: 10%;">
                        <%=Resources.MP.Supplier_No%>
                        <br />
                        <%=Resources.MP.Supplier_Short_Name%>
                    </td>
                    <td style="text-align: left; width: 15%;" colspan="3">
                        <input id="TB_M2_S_No" class="disabled" disabled="disabled" style="width: 100%;" />
                        <br />
                        <input id="TB_M2_S_SName" class="disabled" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;">
                        <%=Resources.MP.TWD_Price%>
                        <br />
                        <%=Resources.MP.USD_Price%>
                    </td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M2_TWD_1" autocomplete="off" disabled="disabled" type="number" value="0" style="width: 100%;text-align:right;" />
                        <br />
                        <input id="TB_M2_USD_1" autocomplete="off" disabled="disabled" type="number" value="0" style="width: 100%;text-align:right;" />
                    </td>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Price_T%>_2</td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M2_P_2" autocomplete="off" disabled="disabled" type="number" value="0" style="width: 100%;text-align:right;" />
                    </td>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Price_T%>_3</td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M2_P_3" autocomplete="off" disabled="disabled" type="number" value="0" style="width: 100%;text-align:right;" />
                    </td>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Price_T%>_4</td>
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
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Price_Information%></td>
                    <td style="text-align: left; width: 15%;" colspan="7">
                        <input id="TB_M2_PRI" autocomplete="off" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Remark%></td>
                    <td style="text-align: left; width: 15%;" colspan="7">
                        <textarea id="TB_M2_Remark" style="width: 100%; height: 100px;" maxlength="560" disabled="disabled"></textarea>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Change_Log%></td>
                    <td style="text-align: left; width: 15%;" colspan="7">
                        <textarea id="TB_M2_Change_Log" style="width: 100%; height: 100px;" maxlength="560" disabled="disabled"></textarea>
                    </td>
                </tr>
                <tr class="M2_For_V" style="display:none;">
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Update_User%></td>
                    <td style="text-align: left; width: 15%;" colspan="3">
                        <input id="TB_M2_Update_User" class="disabled" disabled="disabled" style="width: 100%;" />
                    </td>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Update_Date%></td>
                    <td style="text-align: left; width: 15%;" colspan="3">
                        <input id="TB_M2_Update_Date" class="disabled" disabled="disabled" style="width: 100%;" />
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
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Ivan_Model%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_I_IM" class="disabled" disabled="disabled" style="width: 100%;" />
                    </td>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Supplier_No%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_I_S_No" class="disabled" disabled="disabled" style="width: 100%;" />
                    </td>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Supplier_Short_Name%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_I_S_SName" class="disabled" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Price_Information%></td>
                    <td style="text-align: left; width: 15%;" colspan="7">
                        <input id="TB_I_PRI" class="disabled" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align:center; width: 15%;" colspan="8">
                        <img id="IMG_I_IMG" src=""  />
                        <span id="IMG_I_IMG_Hint" style="display:none;"><%=Resources.MP.Image_NotExists%></span>
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

