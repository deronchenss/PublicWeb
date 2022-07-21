<%@ Page Title="Supplier Maintenance" Language="C#" MasterPageFile="~/MP.master" AutoEventWireup="true" CodeFile="Supplier_MT.aspx.cs" Inherits="Supplier_Supplier_MT" %>

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
            $('#BT_New').on('click', function () {
                From_Mode = "New";
                $('input[required], select[required]').css('background-color', 'yellow');
                $('#BT_Cancel, #BT_New_Save').css('display', '');
                $('.M2_For_U').css('display', 'none');
                $('.M_BT').not($('#BT_Cancel')).css('display', 'none');
                $('#Div_Detail_Form input, #Div_Detail_Form textarea, #Div_Detail_Form select').attr('disabled', false);
                //CS && RF_NO
            });

            $('#BT_New_Save').on('click', function () {
                if (confirm("<%=Resources.MP.Save_Alert%>")) {
                    if (Save_Check()) {
                        $.ajax({
                            url: "/Base/Supplier/Supplier_Save.ashx",
                            data: {
                                "S_No": $('#TB_M2_S_No').val(),
                                "S_SName": $('#TB_M2_S_SName').val(),
                                "S_Name": $('#TB_M2_S_Name').val(),
                                "Area": $('#DDL_M2_Area').val(),
                                "Currency": $('#DDL_M2_Currency').val(),
                                "Payment_Terms": $('#TB_M2_Payment_Terms').val(),
                                "Purchase_Person": $('#TB_M2_Purchase_Person').val(),
                                "Develop_Person": $('#TB_M2_Develop_Person').val(),
                                "Tel": $('#TB_M2_S_Tel').val(),
                                "Fax": $('#TB_M2_Fax').val(),
                                "Phone": $('#TB_M2_Phone').val(),
                                "EIN": $('#TB_M2_EIN').val(),
                                "Web": $('#TB_M2_Web').val(),
                                "Purchase_Mail": $('#TB_M2_Purchase_Mail').val(),
                                "Develop_Mail": $('#TB_M2_Develop_Mail').val(),

                                "Company_Address": $('#TB_M2_Company_Address').val(),
                                "Factory_Address": $('#TB_M2_Factory_Address').val(),
                                "Delivery_Address": $('#TB_M2_Delivery_Address').val(),
                                "Principal": $('#TB_M2_Principal').val(),
                                "Account_Class": $('#DDL_M2_Account_Class').val(),
                                "Nation": $('#TB_M2_S_Nation').val(),
                                "Call_Type": "Supplier_MT_New"
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
                                    $('#Div_Detail_Form table input,textarea').not('[type=button], #TB_E_Example, #TB_Dia_Where').val('');

                                    $('#Div_Detail_Form input, #Div_Detail_Form textarea, #Div_Detail_Form select').not('#TB_E_Example').css('background-color', '');
                                    $('#Div_Detail_Form input, #Div_Detail_Form textarea, #Div_Detail_Form select').attr('disabled', 'disabled');
                                    $('#BT_New, #BT_Search, #BT_Detail_Search').css('display', '');
                                    $('#BT_New_Save, #BT_Cancel').css('display', 'none');
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
                From_Mode = "Search";
                $('#BT_Cancel').css('display', '');
                $('.M_BT').not($('#BT_Cancel')).css('display', 'none');
                Search_Supplier();
                $('#Div_DT_View').css('display', '');
                $('.V_BT').not($('#V_BT_Master')).css('display', '');
            });

            function Dialog_Close_FN() {
                $('#BT_New_Save, #BT_Cancel').css('display', 'none');
                $('.M2_For_U').css('display', 'none');
                $('.M_BT').not($('#BT_Cancel')).css('display', '');
                $('#Div_DT_View').css('display', 'none');
                $('.V_BT').not($('#V_BT_Master')).css('display', 'none');

                $('.Div_D').css('display', 'none');
                $('#Div_M2').css('display', '')

                $('#Div_Detail_Form input, #Div_Detail_Form textarea, #Div_Detail_Form select').not('#TB_E_Example').css('background-color', '');
                $('#Div_Detail_Form input, #Div_Detail_Form textarea, #Div_Detail_Form select').attr('disabled', 'disabled');
                $('#Div_Detail_Form table input,textarea').not('[type=button], #TB_E_Example, #TB_Dia_Where').val('');
                $('.ED_BT').css('display', 'none');
                From_Mode = "Cancel";
            };

            $('#BT_Detail_Search').on('click', function () {
                $('.M_BT').css('display', 'none');

                $("#dialog").dialog({
                    modal: true,
                    title: "查詢條件",
                    width: 800,//=Div寬度$
                    overlay: 0.5,
                    focus: true,
                    close: function () {
                        Dialog_Close_FN();
                    },
                    buttons: {
                        "Search": function () {
                            $("#dialog").dialog('close');
                            var Where_Text = "";

                            switch ($('#Dia_BT_Simple_Change').prop('disabled')) {
                                case true://Simple
                                    switch ($('#Dia_TB1_Operator1').val()) {
                                        case "%LIKE%":
                                            Where_Text += " [廠商編號] LIKE '%" + $('#Dia_TB1_S_No').val() + "%'";
                                            break;
                                        case "LIKE%":
                                            Where_Text += " [廠商編號] LIKE '" + $('#Dia_TB1_S_No').val() + "%'";;
                                            break;
                                        case "%LIKE":
                                            Where_Text += " [廠商編號] LIKE '%" + $('#Dia_TB1_S_No').val() + "'";;
                                            break;
                                        default:
                                            Where_Text += " [廠商編號] " + $('#Dia_TB1_Operator1').val() + " '" + $('#Dia_TB1_S_No').val() + "'";
                                            break;
                                    }
                                    switch ($('#Dia_TB1_Operator2').val()) {
                                        case "%LIKE%":
                                            Where_Text += " AND [廠商簡稱] LIKE '%" + $('#Dia_TB1_S_SName').val() + "%'";
                                            break;
                                        case "LIKE%":
                                            Where_Text += " AND [廠商簡稱] LIKE '" + $('#Dia_TB1_S_SName').val() + "%'";;
                                            break;
                                        case "%LIKE":
                                            Where_Text += " AND [廠商簡稱] LIKE '%" + $('#Dia_TB1_S_SName').val() + "'";;
                                            break;
                                        default:
                                            Where_Text += " AND [廠商簡稱] " + $('#Dia_TB1_Operator2').val() + " '" + $('#Dia_TB1_S_SName').val() + "'";
                                            break;
                                    }
                                    console.warn(Where_Text);
                                    Search_Supplier(Where_Text);
                                    break;
                                case false://Multiple
                                    Where_Text += $('#TB_Dia_Where').val();
                                    console.warn(Where_Text);
                                    Search_Supplier(Where_Text);
                                    break;
                            }

                            From_Mode = "Detail_Search";
                            $('#BT_Cancel').css('display', '');
                            $('.M_BT').not($('#BT_Cancel')).css('display', 'none');
                            //Search_Supplier();

                            $('#Div_DT_View').css('display', '');
                            $('.V_BT').not($('#V_BT_Master')).css('display', '');
                        },
                        "Cancel": function () {
                            $("#dialog").dialog('close');
                        }
                    }
                });
            });

            $('#BT_Cancel').on('click', function () {
                var Confirm_Check = true;
                if (From_Mode == "New") {
                    Confirm_Check = confirm("<%=Resources.MP.Cancel_Alert%>");
                }

                if (Confirm_Check) {
                    $('#BT_New_Save, #BT_Cancel').css('display', 'none');
                    $('.M2_For_U').css('display', 'none');
                    $('.M_BT').not($('#BT_Cancel')).css('display', '');
                    $('#Div_DT_View').css('display', 'none');
                    $('.V_BT').not($('#V_BT_Master')).css('display', 'none');
                    $('#V_BT_Master').attr('disabled', 'disabled');
                    $('.V_BT').not($('#V_BT_Master')).attr('disabled', false);

                    $('.Div_D').css('display', 'none');
                    $('#Div_M2').css('display', '')

                    $('#Div_Detail_Form input, #Div_Detail_Form textarea, #Div_Detail_Form select').not('#TB_E_Example').css('background-color', '');
                    $('#Div_Detail_Form input, #Div_Detail_Form textarea, #Div_Detail_Form select').attr('disabled', 'disabled');
                    $('#Div_Detail_Form table input,textarea').not('[type=button], #TB_E_Example, #TB_Dia_Where').val('');
                    $('.ED_BT').css('display', 'none');
                    From_Mode = "Cancel";
                }
            });

            $('#BT_ED_Edit').on('click', function () {
                $('#BT_ED_Edit, #BT_Cancel, #Div_DT_View').css('display', 'none');
                $('#BT_ED_Save, #BT_ED_Cancel').css('display', '');
                $('#Div_Detail_Form input, #Div_Detail_Form textarea, #Div_Detail_Form select').not('#TB_M2_Update_User, #TB_M2_Update_Date, #TB_M2_SEQ, #TB_E_Example').attr('disabled', false);
            });

            $('#BT_ED_Save').on('click', function () {
                if (confirm("<%=Resources.MP.Edit_Alert%>")) {
                    if (Save_Check()) {
                        //Save
                        $.ajax({
                            url: "/Base/Supplier/Supplier_Save.ashx",
                            data: {
                                "SEQ": $('#TB_M2_SEQ').val(),
                                "S_No": $('#TB_M2_S_No').val(),
                                "S_Tel": $('#TB_M2_S_Tel').val(),
                                "S_SName": $('#TB_M2_S_SName').val(),
                                "Fax": $('#TB_M2_Fax').val(),
                                "S_Name": $('#TB_M2_S_Name').val(),
                                "Area": $('#DDL_M2_Area').val(),
                                "EIN": $('#TB_M2_EIN').val(),
                                "Account_Class": $('#DDL_M2_Account_Class').val(),
                                "Nation": $('#TB_M2_S_Nation').val(),
                                "Principal": $('#TB_M2_Principal').val(),
                                "Currency": $('#DDL_M2_Currency').val(),
                                "Phone": $('#TB_M2_Phone').val(),
                                "Payment_Terms": $('#TB_M2_Payment_Terms').val(),
                                "Web": $('#TB_M2_Web').val(),
                                "Develop_Person": $('#TB_M2_Develop_Person').val(),
                                "Develop_Mail": $('#TB_M2_Develop_Mail').val(),
                                "Purchase_Person": $('#TB_M2_Purchase_Person').val(),
                                "Purchase_Mail": $('#TB_M2_Purchase_Mail').val(),
                                "Company_Address": $('#TB_M2_Company_Address').val(),
                                "Factory_Address": $('#TB_M2_Factory_Address').val(),
                                "Delivery_Address": $('#TB_M2_Delivery_Address').val(),
                                "Update_User": $('#TB_M2_Update_User').val(),
                                "Purchase": $('#TB_RM_Purchase').val(),
                                "Develop": $('#TB_RM_Develop').val(),
                                "Payment_Mode": $('#TB_DP_Payment_Mode').val(),
                                "Bank_Head_Code": $('#TB_DP_Bank_Head_Code').val(),
                                "Bank_Branch_Code": $('#TB_DP_Bank_Branch_Code').val(),
                                "Collect_Account": $('#TB_DP_Collect_Account').val(),
                                "Collect_Name": $('#TB_DP_Collect_Name').val(),
                                "Collect_EIN": $('#TB_DP_Collect_EIN').val(),
                                "Collect_Mail": $('#TB_DP_Collect_Mail').val(),
                                "OP_Payment_Mode": $('#TB_OP_Payment_Mode').val(),
                                "OP_Collect_Nation": $('#TB_OP_Collect_Nation').val(),
                                "OP_Currency": $('#TB_OP_Currency').val(),
                                "OP_Collect_Name": $('#TB_OP_Collect_Name').val(),
                                "OP_Collect_Address": $('#TB_OP_Collect_Address').val(),
                                "OP_Collect_Account": $('#TB_OP_Collect_Account').val(),
                                "OP_SWIFT": $('#TB_OP_SWIFT').val(),
                                "OP_Collect_Bank_Name": $('#TB_OP_Collect_Bank_Name').val(),
                                "OP_Bank_Address": $('#TB_OP_Collect_Bank_Address').val(),
                                "Call_Type": "Supplier_MT_Update"

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
                                    $('#Div_Detail_Form input, #Div_Detail_Form textarea, #Div_Detail_Form select').attr('disabled', 'disabled');
                                    $('#BT_ED_Edit, #BT_Cancel, #Div_DT_View').css('display', '');
                                    $('#BT_ED_Save, #BT_ED_Cancel').css('display', 'none');
                                    Search_Supplier();
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
                $('#Div_Detail_Form input, #Div_Detail_Form textarea, #Div_Detail_Form select').attr('disabled', 'disabled');
                $('#BT_ED_Edit, #BT_Cancel, #Div_DT_View').css('display', '');
                $('#BT_ED_Save, #BT_ED_Cancel').css('display', 'none');
                //Re_Select Data Again
            });

            //Add show V_BT_Other_Function//$('.V_BT').not($('#V_BT_Master')).css('display', 'none');
            //Add After Save function
            function Save_Check() {
                var Check_Item = true;
                var Alert_Message = "";
                if ($('#TB_M2_S_No').val().length < 4 || $('#TB_M2_S_No').val().length > 8) {
                    Alert_Message += "請輸入4~8碼廠商編號";
                    $('#TB_M2_S_No').css('background-color', 'red');
                    Check_Item = false;
                }
                if ($('#TB_M2_S_SName').val().length === 0) {
                    Alert_Message += "\r\n請輸入廠商簡稱";
                    $('#TB_M2_S_SName').css('background-color', 'red');
                    Check_Item = false;
                }
                if ($('#TB_M2_S_Nation').val().length === 0) {
                    Alert_Message += "\r\n請輸入國名";
                    $('#TB_M2_S_Nation').css('background-color', 'red');
                    Check_Item = false;
                }
                if (!Check_Item) {
                    alert(Alert_Message);
                }
                return Check_Item;
            };

            $('.V_BT').on('click', function () {
                $(this).attr('disabled', 'disabled');
                $('.V_BT').not($(this)).attr('disabled', false);
            });

            $('#TB_M2_S_Name, #TB_DP_Supplier_Name ,#TB_OP_Supplier_Name').on('change', function () {
                $('#TB_M2_S_Name, #TB_DP_Supplier_Name ,#TB_OP_Supplier_Name').val($(this).val());
            });

            function Table_Tr_Click(Click_tr) {
                $(Click_tr).parent().find('tr').css('background-color', '');
                $(Click_tr).parent().find('tr').css('color', 'black');
                $(Click_tr).css('background-color', '#5a1400');
                $(Click_tr).css('color', 'white');

                var S_No = $(Click_tr).find('td:nth-child(1)').text().toString().trim();
                //初始化BT操作

                $('.M2_For_U').css('display', '');
                $('#Div_Detail_Form input, #Div_Detail_Form textarea, #Div_Detail_Form select').attr('disabled', 'disabled');
                $('#BT_ED_Edit').css('display', '');
                $('#BT_ED_Save, #BT_ED_Cancel').css('display', 'none');

                $.ajax({
                    url: "/Base/Supplier/Sup_Search.ashx",
                    data: {
                        "S_No": S_No,
                        "Call_Type": "Supplier_MT_Selected"
                    },
                    cache: false,
                    type: "POST",
                    datatype: "json",
                    contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                    success: function (response) {
                        $('#TB_M2_SEQ').val(String(response[0].SEQ ?? ""));
                        $('#TB_M2_S_No').val(S_No);
                        $('#TB_M2_S_Tel').val(String(response[0].S_Tel ?? ""));
                        $('#TB_M2_S_SName').val(String(response[0].S_SName ?? ""));
                        $('#TB_M2_Fax').val(String(response[0].S_FAX ?? ""));

                        $('#TB_M2_S_Name').val(String(response[0].S_Name ?? ""));
                        $('#TB_DP_Supplier_Name').val(String(response[0].S_Name ?? ""));
                        $('#TB_OP_Supplier_Name').val(String(response[0].S_Name ?? ""));

                        $('#DDL_M2_Area').val(String(response[0].S_Area ?? ""));
                        $('#TB_M2_EIN').val(String(response[0].S_EIN ?? ""));
                        $('#DDL_M2_Account_Class').val(String(response[0].S_Account_Class ?? ""));
                        $('#TB_M2_S_Nation').val(String(response[0].S_Nation ?? ""));
                        $('#TB_M2_Principal').val(String(response[0].S_Principal ?? ""));
                        $('#DDL_M2_Currency').val(String(response[0].S_Currency ?? ""));
                        $('#TB_M2_Phone').val(String(response[0].S_Phone ?? ""));
                        $('#TB_M2_Payment_Terms').val(String(response[0].S_Payment_Terms ?? ""));
                        $('#TB_M2_Web').val(String(response[0].S_Web ?? ""));
                        $('#TB_M2_Develop_Person').val(String(response[0].S_P_Develop ?? ""));
                        $('#TB_M2_Develop_Mail').val(String(response[0].S_Mail_Develop ?? ""));
                        $('#TB_M2_Purchase_Person').val(String(response[0].S_P_Purchase ?? ""));
                        $('#TB_M2_Purchase_Mail').val(String(response[0].S_Mail_Purchase ?? ""));
                        $('#TB_M2_Company_Address').val(String(response[0].S_Company_Address ?? ""));
                        $('#TB_M2_Factory_Address').val(String(response[0].S_Factory_Address ?? ""));
                        $('#TB_M2_Delivery_Address').val(String(response[0].S_Send_Address ?? ""));

                        $('#TB_M2_Update_User').val(String(response[0].S_Update_User ?? ""));
                        $('#TB_M2_Update_User').val(String(response[0].S_Update_User ?? ""));
                        $('#TB_DP_Update_User').val(String(response[0].S_Update_User ?? ""));
                        $('#TB_M2_Update_Date').val(String(response[0].S_Update_Date ?? ""));
                        $('#TB_DP_Update_Date').val(String(response[0].S_Update_Date ?? ""));
                        $('#TB_OP_Update_Date').val(String(response[0].S_Update_Date ?? ""));

                        $('#TB_RM_Purchase').val(String(response[0].S_Remark_Purchase ?? ""));
                        $('#TB_RM_Develop').val(String(response[0].S_Remark_Develop ?? ""));
                        $('#TB_DP_Payment_Mode').val(String(response[0].S_Payment_Mode ?? ""));
                        $('#TB_DP_Bank_Head_Code').val(String(response[0].S_Bank_Head_Code ?? ""));
                        $('#TB_DP_Bank_Branch_Code').val(String(response[0].S_Bank_Branch_Code ?? ""));
                        $('#TB_DP_Collect_Account').val(String(response[0].S_Collect_Account ?? ""));
                        $('#TB_DP_Collect_Name').val(String(response[0].S_Collect_Name ?? ""));
                        $('#TB_DP_Collect_EIN').val(String(response[0].S_Collect_EIN ?? ""));
                        $('#TB_DP_Collect_Mail').val(String(response[0].S_Collect_Mail ?? ""));
                        $('#TB_OP_Payment_Mode').val(String(response[0].S_OP_Payment_Mode ?? ""));
                        $('#TB_OP_Collect_Nation').val(String(response[0].S_OP_Collect_Nation ?? ""));
                        $('#TB_OP_Currency').val(String(response[0].S_OP_Currency ?? ""));
                        $('#TB_OP_Collect_Name').val(String(response[0].S_OP_Collect_Name ?? ""));
                        $('#TB_OP_Collect_Address').val(String(response[0].S_OP_Collect_Address ?? ""));
                        $('#TB_OP_Collect_Account').val(String(response[0].S_OP_Collect_Account ?? ""));
                        $('#TB_OP_SWIFT').val(String(response[0].S_OP_SWIFT ?? ""));
                        $('#TB_OP_Collect_Bank_Name').val(String(response[0].S_OP_Collect_Bank_Name ?? ""));
                        $('#TB_OP_Collect_Bank_Address').val(String(response[0].S_OP_Collect_Bank_Address ?? ""));
                    },
                    error: function (ex) {
                        alert(ex);
                    }
                });
            };

             function Search_Supplier(Search_Where) {
                 Click_tr_IDX = null;
                $.ajax({
                    url: "/Base/Supplier/Sup_Search.ashx",
                    data: {
                        "S_No": "",//$('#TB_Search_S_No').val(),
                        "Call_Type": "Supplier_MT_Search",
                        "Search_Where": Search_Where ?? ""
                    },
                    cache: false,
                    type: "POST",
                    datatype: "json",
                    contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                    success: function (response) {
                        var Table_HTML =

                            '<thead><tr><th>' + '<%=Resources.MP.Supplier_No%>'
                            + '</th><th>' + '<%=Resources.MP.Supplier_Short_Name%>'
                            + '</th><th>' + '<%=Resources.MP.Tel%>'
                            + '</th><th>' + '<%=Resources.MP.Fax%>'
                            + '</th><th>' + '<%=Resources.MP.Purchase_Person%>'
                            + '</th><th>' + '<%=Resources.MP.Develop_Person%>'
                            + '</th><th>' + '<%=Resources.MP.Principal%>'
                            + '</th><th>' + '<%=Resources.MP.EIN%>'
                            + '</th><th>' + '<%=Resources.MP.SEQ%>'
                            + '</th><th>' + '<%=Resources.MP.Update_User%>'
                            + '</th><th>' + '<%=Resources.MP.Update_Date%>'
                            + '</th></tr></thead><tbody>';

                        $(response).each(function (i) {
                            Table_HTML +=
                                '<tr><td>' + String(response[i].S_No) +
                                '</td><td>' + String(response[i].S_SName ?? "") +
                                '</td><td>' + String(response[i].S_Tel ?? "") +
                                '</td><td>' + String(response[i].S_FAX ?? "") +
                                '</td><td>' + String(response[i].S_P_Purchase ?? "") +
                                '</td><td>' + String(response[i].S_P_Develop ?? "") +
                                '</td><td>' + String(response[i].S_Principal ?? "") +
                                '</td><td>' + String(response[i].S_EIN ?? "") +
                                '</td><td>' + String(response[i].S_SEQ ?? "") +
                                '</td><td>' + String(response[i].S_Update_User ?? "") +
                                '</td><td>' + String(response[i].S_Update_Date ?? "") +
                                '</td></tr>';
                        });
                        Table_HTML += '</tbody>';
                        //$('#Table_Search_Customer').html(Table_HTML);
                        $('#Table_Search_Customer').DataTable({
                            "data": response,
                            "destroy": true,
                            "order": [[10, "desc"]],
                            "lengthMenu": [
                                [5, 10, 20, -1],
                                [5, 10, 20, "All"],
                            ],
                            
                            "columns": [
                                { data: "S_No", title: "<%=Resources.MP.Supplier_No%>" },
                                { data: "S_SName", title:"<%=Resources.MP.Supplier_Short_Name%>" },
                                { data: "S_Tel", title: "<%=Resources.MP.Tel%>" },
                                { data: "S_FAX", title: "<%=Resources.MP.Fax%>" },
                                { data: "S_P_Purchase", title: "<%=Resources.MP.Purchase_Person%>" },
                                { data: "S_P_Develop", title: "<%=Resources.MP.Develop_Person%>" },
                                { data: "S_Principal", title: "<%=Resources.MP.Principal%>" },
                                { data: "S_EIN", title: "<%=Resources.MP.EIN%>" },
                                { data: "S_SEQ", title: "<%=Resources.MP.SEQ%>" },
                                { data: "S_Update_User", title: "<%=Resources.MP.Update_User%>" },
                                { data: "S_Update_Date", title: "<%=Resources.MP.Update_Date%>" }
                            ],
                        });


                        $('#Table_Search_Customer').attr('style', 'white-space:nowrap;');
                        $('#Table_Search_Customer thead th').attr('style', 'text-align:center;');
                        $('#Table_Search_Customer').on('click', 'tbody tr', function () {
                            Click_tr_IDX = $(this).index();
                            Table_Tr_Click($(this));
                        });

                    },
                    error: function (ex) {
                        alert(ex);
                    }
                });
            };

            
            $(window).keydown(function (e) {
                if (Click_tr_IDX != null) {
                    switch (e.keyCode) {
                        case 38://^
                            if (Click_tr_IDX > 0) {
                                Click_tr_IDX -= 1;
                            }
                            Table_Tr_Click($('#Table_Search_Customer tbody tr:nth(' + Click_tr_IDX + ')'));
                            break;
                        case 40://v
                            if (Click_tr_IDX < ($('#Table_Search_Customer tbody tr').length - 1)) {
                                Click_tr_IDX += 1;
                            }
                            Table_Tr_Click($('#Table_Search_Customer tbody tr:nth(' + Click_tr_IDX + ')'));
                            break;
                    }
                }
            });
            //will Update
            $('#TB_Search_C_No').on('change', function () {
                if ($.trim($(this).val()) == "") {
                    $('#TB_Search_C_SName').val('');
                }
            });
            

            $('#TB_M2_S_Nation').autocomplete({
                autoFocus: true,
                source: function (request, response) {
                    $.ajax({
                        url: "/Web_Service/AutoComplete.asmx/Serach_Nation",
                        cache: false,
                        data: "{'Nation': '" + request.term + "'}",
                        dataType: "json",
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        success: function (data) {
                            var Json_Response = JSON.parse(data.d);
                            response($.map(Json_Response, function (item) { return { label: item.Nation } }));
                        },
                        error: function (response) {
                            alert(response.responseText);
                        },
                    });
                }
            });
            $('#TB_Search_C_No').autocomplete({
                autoFocus: true,
                source: function (request, response) {
                    $.ajax({
                        url: "/Web_Service/AutoComplete.asmx/Serach_Customer_No_Name",
                        cache: false,
                        data: "{'C_No': '" + request.term + "'}",
                        dataType: "json",
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        success: function (data) {
                            var Json_Response = JSON.parse(data.d);
                            response($.map(Json_Response, function (item) { return { label: item.C_No + " - " + item.C_Name, value: item.C_No, name: item.C_Name } }));
                        },
                        error: function (response) {
                            alert(response.responseText);
                        },
                    });
                },
                select: function (event, ui) {
                    $('#TB_Search_C_No').val(ui.item.value);
                    $('#TB_Search_C_SName').val(ui.item.name);
                    Search_Supplier();
                },
            });
            $('#DDL_M2_Area').on('change', function () {
                var ACC;
                switch ($('#DDL_M2_Area').val()) {
                    case "台灣":
                        ACC = 1;
                        break;
                    case "中國":
                        ACC = 3;
                        break;
                    case "國外":
                        ACC = 5;
                        break;
                    case "東亞":
                        ACC = 6;
                        break;
                }
                $('#DDL_M2_Account_Class').val(ACC);
            });
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

        #Table_Search_Customer tbody tr:hover {
            background-color: #f8981d;
            color: white;
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
                <td style="width: 20%;"><%=Resources.MP.Supplier_No%></td>
                <td style="width: 30%;">
                    <select style="width: 90%; height: 25px;" id="Dia_TB1_Operator1">
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
            <tr style="text-align: right;">
                <td style="width: 20%;"><%=Resources.MP.Supplier_Short_Name%></td>
                <td style="width: 30%;">
                    <select style="width: 90%; height: 25px;" id="Dia_TB1_Operator2">
                        <option>=</option>
                        <option selected="selected">%LIKE%</option>
                        <option>LIKE%</option>
                        <option>%LIKE</option>
                    </select>
                </td>
                <td style="width: 50%;">
                    <input style="width: 90%; height: 25px;" id="Dia_TB1_S_SName" />
                </td>
            </tr>
        </table>
        <table border="1" style="margin: 0 auto; display: none;" id="Dia_Table_Multiple">
            <tr style="text-align: center;">
                <td style="width: 40%;">
                    <%--Where Column--%>
                    <select style="width: 90%; height: 25px;" id="DDL_Dia_Filter">
                        <option value="[廠商編號]" selected="selected"><%=Resources.MP.Supplier_No%></option>
                        <option value="[廠商簡稱]"><%=Resources.MP.Supplier_Short_Name%></option>
                        <option value="[電話]"><%=Resources.MP.Tel%></option>
                        <option value="[傳真]"><%=Resources.MP.Fax%></option>
                        <option value="[連絡人採購]"><%=Resources.MP.Purchase_Person%></option>
                        <option value="[連絡人開發]"><%=Resources.MP.Develop_Person%></option>
                        <option value="[負責人]"><%=Resources.MP.Principal%></option>
                        <option value="[統一編號]"><%=Resources.MP.EIN%></option>
                        <option value="[序號]"><%=Resources.MP.SEQ%></option>
                        <option value="[更新人員]"><%=Resources.MP.Update_User%></option>
                        <option value="[更新日期]"><%=Resources.MP.Update_Date%></option>
                        <option value="[公司地址]"><%=Resources.MP.Address%></option>
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

                        //權限辨別Demo
                        //var AA = ["10114D153", "23456", "45678"];
                        //alert(String(AA.includes("234756")));


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
        <table id="Table_Search_Customer" style="width:100%;" class="table table-striped table-bordered">
            <thead></thead>
            <tbody></tbody>
        </table>
    </div>
    <div id="Div_Edit_Area" style="width: 99%; margin: 0 auto; background-color: white;">
        &nbsp;
        <input type="button" id="BT_ED_Edit" class="ED_BT" value="<%=Resources.MP.Edit%>" style="display:none;" />
        <input type="button" id="BT_ED_Save" class="ED_BT" value="<%=Resources.MP.Save%>" style="display:none;" />
        <input type="button" id="BT_ED_Cancel" class="ED_BT" value="<%=Resources.MP.Cancel%>" style="display:none;" />
    </div>
    <div style="width: 99%; margin: 0 auto; background-color: white;">
        &nbsp;
        <input id="V_BT_Master" type="button" class="V_BT" value="<%=Resources.MP.Master%>" onclick="$('.Div_D').css('display','none');$('#Div_M2').css('display','');" disabled="disabled" />
        <input type="button" class="V_BT" style="display:none;" value="<%=Resources.MP.Remark%>" onclick="$('.Div_D').css('display','none');$('#Div_Remark').css('display','');" />
        <input type="button" class="V_BT" style="display:none;" value="<%=Resources.MP.Domestic_Payment%>" onclick="$('.Div_D').css('display','none');$('#Div_Domestic_Payment').css('display','');" />
        <input type="button" class="V_BT" style="display:none;" value="<%=Resources.MP.Overseas_Payment%>" onclick="$('.Div_D').css('display','none');$('#Div_Overseas_Payment').css('display','');" />
        <input type="button" class="V_BT" style="display:none;" value="<%=Resources.MP.Example%>" onclick="$('.Div_D').css('display','none');$('#Div_Example').css('display','');" />
    </div>
    <div style="width: 100%;" id="Div_Detail_Form">
        <div id="Div_M2" class="Div_D">
            <table style="font-size: 15px; border-collapse: separate; border-spacing: 0px 8px;">
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;">*<%=Resources.MP.Supplier_No%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M2_S_No" type="text" required="required" disabled="disabled" style="width: 100%;" pattern="^([a-zA-Z]+\d+|\d+[a-zA-Z]+)[a-zA-Z0-9]*$" minlength="4" maxlength="8" title="廠商編號僅能4至8碼" />
                    </td>

                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Tel%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M2_S_Tel" disabled="disabled" style="width: 100%;" maxlength="20" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;">*<%=Resources.MP.Supplier_Short_Name%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M2_S_SName" required="required" disabled="disabled" style="width: 100%;" maxlength="35" />
                    </td>

                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Fax%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M2_Fax" disabled="disabled" style="width: 100%;" maxlength="20" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Supplier_Name%></td>
                    <td style="text-align: left; width: 40%;" colspan="3">
                        <input id="TB_M2_S_Name" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Area%></td>
                    <td style="text-align: left; width: 15%;">
                        <select id="DDL_M2_Area" disabled="disabled" style="width: 100%;" >
                            <%--<option>香港</option>--%>
                            <option>台灣</option>
                            <option>中國</option>
                            <option>國外</option>
                            <option>東亞</option>
                        </select>
                    </td>
                    
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.EIN%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M2_EIN" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Account_Class%></td>
                    <td style="text-align: left; width: 15%;">
                        <select id="DDL_M2_Account_Class" disabled="disabled" style="width: 100%;" >
                            <option>1</option>
                            <option>3</option>
                            <option>5</option>
                            <option>6</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;">*<%=Resources.MP.Nation%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M2_S_Nation" disabled="disabled" required="required" style="width: 100%;" />
                    </td>
                    
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Principal%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M2_Principal" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Currency%></td>
                    <td style="text-align: left; width: 15%;">
                        <select id="DDL_M2_Currency" disabled="disabled" style="width: 100%;" >
                            <option>USD</option>
                            <option>THB</option>
                            <option>GBP</option>
                            <option>AUD</option>
                            <option>RMB</option>
                            <option>EUR</option>
                            <option>NTD</option>
                            <option>HKD</option>
                            <option>OT</option>
                            <option>YEN</option>
                        </select>
                    </td>

                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Phone%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M2_Phone" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Payment_Terms%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M2_Payment_Terms" disabled="disabled" style="width: 100%;" maxlength="12" />
                    </td>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Web%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M2_Web" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Develop_Person%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M2_Develop_Person" disabled="disabled" style="width: 100%;" />
                    </td>

                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Develop_Mail%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M2_Develop_Mail" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Purchase_Person%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M2_Purchase_Person" disabled="disabled" style="width: 100%;" />
                    </td>

                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Purchase_Mail%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M2_Purchase_Mail" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Company_Address%></td>
                    <td colspan="3" style="text-align: left; width: 15%;">
                        <textarea id="TB_M2_Company_Address" style="width: 100%;" disabled="disabled"></textarea>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Factory_Address%></td>
                    <td colspan="3" style="text-align: left; width: 15%;">
                        <textarea id="TB_M2_Factory_Address" style="width: 100%;" disabled="disabled"></textarea>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Delivery_Address%></td>
                    <td colspan="3" style="text-align: left; width: 15%;">
                        <textarea id="TB_M2_Delivery_Address" style="width: 100%;" disabled="disabled"></textarea>
                    </td>
                </tr>
                
                <tr class="M2_For_U" style="display:none;">
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Update_User%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M2_Update_User" disabled="disabled" style="width: 100%;" />
                    </td>

                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Update_Date%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M2_Update_Date" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
                <tr class="M2_For_U" style="display:none;">
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.SEQ%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M2_SEQ" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
                <tr>
                    <td colspan="5" style="margin: auto;">
                        <div style="display: flex; justify-content: center; align-items: center;">
                            <input id="BT_New_Save" class="BTN" style="display:none;" type="button" value="<%=Resources.MP.Save%>" />
                        </div>
                    </td>
                </tr>
            </table>
        </div>

        <div id="Div_Remark" class="Div_D" style="display: none; overflow: auto;">
            <table style="font-size: 15px;">
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;">&nbsp;</td>
                    <td style="text-align: left; width: 15%;">
                        &nbsp;
                    </td>
                    <td style="width: 10%;"></td>
                    <td style="width: 15%;"></td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Purchase%></td>
                    <td style="text-align: left;width:90%;">
                        <textarea id="TB_RM_Purchase" style="width: 100%; height: 250px;" disabled="disabled"></textarea>
                    </td>
                </tr>
                <tr><td><br /></td></tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Develop%></td>
                    <td style="text-align: left;width:90%;" colspan="3">
                        <textarea id="TB_RM_Develop" style="width: 100%; height: 250px;" disabled="disabled"></textarea>
                    </td>
                </tr>
            </table>
        </div>

        <div id="Div_Domestic_Payment" class="Div_D" style="display: none; overflow: auto;">
            <table style="font-size: 15px; border-collapse: separate; border-spacing: 0px 10px;">
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Supplier_Name%></td>
                    <td style="text-align: left; width: 15%;" colspan="3">
                        <input id="TB_DP_Supplier_Name" disabled="disabled" style="width: 100%; " />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Payment_Mode%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_DP_Payment_Mode" disabled="disabled" style="width: 100%; " />
                    </td>
                    <td style="width: 10%;"></td>
                    <td style="width: 15%;"></td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Bank_Head_Code%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_DP_Bank_Head_Code" disabled="disabled" style="width: 100%; " />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Bank_Branch_Code%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_DP_Bank_Branch_Code" disabled="disabled" style="width: 100%; " />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Collect_Account%></td>
                    <td style="text-align: left; width: 15%;" colspan="3">
                        <input id="TB_DP_Collect_Account" disabled="disabled" style="width: 100%; " />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Collect_Name%></td>
                    <td style="text-align: left; width: 15%;" colspan="3">
                        <input id="TB_DP_Collect_Name" disabled="disabled" style="width: 100%; " />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Collect_EIN%></td>
                    <td style="text-align: left; width: 15%;" colspan="3">
                        <input id="TB_DP_Collect_EIN" disabled="disabled" style="width: 100%; " />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Collect_Mail%></td>
                    <td style="text-align: left; width: 15%;" colspan="3">
                        <input id="TB_DP_Collect_Mail" disabled="disabled" style="width: 100%; " />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Update_User%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_DP_Update_User" disabled="disabled" style="width: 100%; " />
                    </td>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Update_Date%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_DP_Update_Date" disabled="disabled" style="width: 100%; " />
                    </td>
                </tr>
            </table>
        </div>

        <div id="Div_Overseas_Payment" class="Div_D" style="display: none; overflow: auto;">
            <table style="font-size: 15px; border-collapse: separate; border-spacing: 0px 10px;">
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Supplier_Name%></td>
                    <td style="text-align: left; width: 15%;" colspan="3">
                        <input id="TB_OP_Supplier_Name" disabled="disabled" style="width: 100%; " />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Payment_Mode%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_OP_Payment_Mode" disabled="disabled" style="width: 100%; " />
                    </td>
                    <td style="width: 10%;"></td>
                    <td style="width: 15%;"></td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Collect_Nation%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_OP_Collect_Nation" disabled="disabled" style="width: 100%; " />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Currency%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_OP_Currency" disabled="disabled" style="width: 100%; " />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Collect_Name%></td>
                    <td style="text-align: left;width:90%;" colspan="3">
                        <textarea id="TB_OP_Collect_Name" style="width: 100%; height: 50px;" disabled="disabled"></textarea>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Collect_Address%></td>
                    <td style="text-align: left;width:90%;" colspan="3">
                        <textarea id="TB_OP_Collect_Address" style="width: 100%; height: 50px;" disabled="disabled"></textarea>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Collect_Account%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_OP_Collect_Account" disabled="disabled" style="width: 100%; " />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;">SWIFT</td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_OP_SWIFT" disabled="disabled" style="width: 100%; " />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Collect_Bank_Name%></td>
                    <td style="text-align: left;width:90%;" colspan="3">
                        <textarea id="TB_OP_Collect_Bank_Name" style="width: 100%; height: 50px;" disabled="disabled"></textarea>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Collect_Bank_Address%></td>
                    <td style="text-align: left;width:90%;" colspan="3">
                        <textarea id="TB_OP_Collect_Bank_Address" style="width: 100%; height: 50px;" disabled="disabled"></textarea>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Update_User%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_OP_Update_User" disabled="disabled" style="width: 100%; " />
                    </td>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Update_Date%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_OP_Update_Date" disabled="disabled" style="width: 100%; " />
                    </td>
                </tr>

            </table>
        </div>
        <div id="Div_Example" class="Div_D" style="display: none; overflow: auto">
            <table style="font-size: 15px; width:80%;">
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"></td>
                    <td style="text-align: left; width: 15%;"></td>
                    <td style="width: 10%;"></td>
                    <td style="width: 15%;"></td>
                </tr>
                <tr>
                    <td style="width: 10%;">&nbsp;</td>
                    <td colspan="3">
                        <textarea id="TB_E_Example" style="width: 100%; height: 450px; background-color: yellowgreen;" disabled="disabled">
ＸＸ　Ｘ　ＸＸ     
──    ─    ──       
區類    筆     序           
別別    劃     號   
      
區別: 0/台灣  1/大陸  2/其它進口國 A/開發中

類別: 1.皮件          2.染料       3.工具        4.書籍 
          5.五金          6.帶扣       7.半成品    8.雜項 
          9.包裝材料   A.             B.珠系列        

筆劃: A/10 B/11 C/12 D/13 E/14 F/15 G/16 H/17 I/18   
           J/19 K/20 L/21 M/22 N/23
                        </textarea>
                        <br />
                        <span>帳務分類 (採購A: 負責1,5 採購B: 負責3,6)</span>
                        <br />
                        <span>1-台灣</span>
                        <br />
                        <span>3-香港</span>
                        <br />
                        <span>5-國外</span>
                        <br />
                        <span>6-東亞 : 目前限越南與印尼 (開單併入香港)</span>
                    </td>
                </tr>
            </table>
        </div>
    </div>

    <br />
    <br />


</asp:Content>

