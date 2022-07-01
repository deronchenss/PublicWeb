<%@ Page Title="Customer Maintenance" Language="C#" MasterPageFile="~/MP.master" AutoEventWireup="true" CodeFile="Customer2.aspx.cs" Inherits="Customer_Customer2" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <link href="/css/dataTables.bootstrap4.min.css" rel="stylesheet" />
    <script src="/js/jquery.dataTables.min.js"></script>
    <script src="/js/dataTables.bootstrap4.min.js"></script>

    <script type="text/javascript">
        $(document).ready(function () {
            var From_Mode;

            function Form_Mode_Change(Form_Mode) {
                switch (Form_Mode) {
                    case "Base":
                        $('#Div_Detail_Form table input, textarea').not('[type=button], #TB_Dia_Where, #TB_E_Example, [type=number]').val('');
                        $('#Div_Detail_Form input, #Div_Detail_Form textarea, #Div_Detail_Form select').not('#TB_E_Example').css('background-color', '');
                        $('#Div_Detail_Form input, #Div_Detail_Form textarea, #Div_Detail_Form select').attr('disabled', 'disabled');

                        $('#BT_New, #BT_Search, #BT_Detail_Search').css('display', '');
                        $('#BT_New_Save, #BT_Cancel').css('display', 'none');
                        $('.ED_BT').css('display', 'none');

                        $('.M2_For_N, .M2_For_U').css('display', 'none');
                        $('#Div_DT_View').css('display', 'none');

                        $('.V_BT').not($('#V_BT_Master')).css('display', 'none');
                        $('.V_BT').not($('#V_BT_Master')).attr('disabled', false);
                        $('#V_BT_Master').attr('disabled', 'disabled');

                        $('.Div_D').css('display', 'none');
                        $('#Div_M2').css('display', '')

                        break;
                    case "New_M":
                        $('#BT_Cancel, #BT_New_Save').css('display', '');
                        $('.M_BT').not($('#BT_Cancel')).css('display', 'none');
                        $('.M2_For_N').css('display', '');
                        $('.M2_For_U').css('display', 'none');
                        $('.ED_BT').css('display', 'none');
                        $('#Div_Detail_Form input, #Div_Detail_Form textarea, #Div_Detail_Form select').attr('disabled', false);
                        break;
                    case "Search_M":
                        $('#BT_Cancel').css('display', '');
                        $('.M_BT').not($('#BT_Cancel')).css('display', 'none');
                        $('#Div_DT_View').css('display', '');
                        $('.V_BT').not($('#V_BT_Master')).css('display', '');

                        $('#Div_Detail_Form input, #Div_Detail_Form textarea, #Div_Detail_Form select').attr('disabled', 'disabled');
                        $('#BT_Cancel, #Div_DT_View').css('display', '');
                        $('#BT_ED_Edit, #BT_ED_Save, #BT_ED_Cancel').css('display', 'none');
                        break;
                    case "Search_D":
                        $('#Div_Detail_Form input, #Div_Detail_Form textarea, #Div_Detail_Form select').attr('disabled', 'disabled');
                        $('#BT_ED_Edit, #BT_Cancel, #Div_DT_View').css('display', '');
                        $('#BT_ED_Save, #BT_ED_Cancel').css('display', 'none');

                        $('.M2_For_N').css('display', 'none');
                        $('.M2_For_U').css('display', '');
                        $('#Div_Detail_Form input, #Div_Detail_Form textarea, #Div_Detail_Form select').attr('disabled', 'disabled');
                        $('#BT_ED_Edit').css('display', '');
                        $('#BT_ED_Save, #BT_ED_Cancel').css('display', 'none');
                        break;
                    case "Edit_M":
                        $('#BT_ED_Edit, #BT_Cancel, #Div_DT_View').css('display', 'none');
                        $('#BT_ED_Save, #BT_ED_Cancel').css('display', '');
                        $('#Div_Detail_Form input, #Div_Detail_Form textarea, #Div_Detail_Form select').not('#TB_M2_Update_User, #TB_M2_Update_Date, #TB_M2_SEQ, #TB_E_Example').attr('disabled', false);
                        break;
                }
            };

            $('#BT_New').on('click', function () {
                From_Mode = "New";
                Form_Mode_Change("New_M");
            });

            $('#BT_New_Save').on('click', function () {
                if (confirm("<%=Resources.MP.Save_Alert%>")) {
                    if (Save_Check()) {
                        $.ajax({
                            url: "/Customer/Customer_Save.ashx",
                            data: {
                                "C_No": $('#TB_M2_C_No').val(),
                                "C_SName": $('#TB_M2_C_SName').val(),
                                "C_Name": $('#TB_M2_C_Name').val(),
                                "Principal": $('#TB_M2_Principal').val(),
                                "Nation": $('#TB_M2_C_Nation').val(),
                                "Quote_Class": $('#DDL_M2_Quoted').val(),
                                "Payment_Terms": $('#TB_M2_Payment_Terms').val(),
                                "Price_Condition": $('#TB_M2_Price_condition').val(),
                                "Person_Commodity": $('#TB_M2_Person_Commodity').val(),
                                "Person_Sample": $('#TB_M2_Person_Sample').val(),
                                "Tel": $('#TB_M2_C_Tel').val(),
                                "Fax": $('#TB_M2_Fax').val(),
                                "Web": $('#TB_M2_Web').val(),
                                "Mail": $('#TB_M2_Mail').val(),
                                "MailEDM": $('#TB_M2_EDMMail').val(),
                                "Company_Address": $('#TB_M2_Company_Address').val(),
                                "Factory_Address": $('#TB_M2_Factory_Address').val(),
                                "Delivery_Address": $('#TB_M2_Delivery_Address').val(),
                                "Currency": $('#DDL_M2_Currency').val(),
                                "IV_Address": $('#DDL_IVPK').val(),
                                "Costomer_Source": $('#DDL_M2_C_Source').val(),
                                "Reference_Number": $('#TB_M2_RF_No').val(),
                                "Call_Type": "Customer2_New"
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

                        <%--alert("<%=Resources.Customer.Add_Success%>");
                        $('#Div_Detail_Form table input,textarea').not('[type=button], #TB_E_Example, #TB_Dia_Where').val('');
                        //Demo暫不清除

                        $('#Div_Detail_Form input, #Div_Detail_Form textarea, #Div_Detail_Form select').not('#TB_E_Example').css('background-color', '');
                        $('#Div_Detail_Form input, #Div_Detail_Form textarea, #Div_Detail_Form select').attr('disabled', 'disabled');
                        $('#BT_New, #BT_Search, #BT_Detail_Search').css('display', '');
                        $('#BT_New_Save, #BT_Cancel').css('display', 'none');--%>
                        //after complete change to search?
                    }
                }
            });

            $('#BT_Search').on('click', function () {
                Search_Customer();
                From_Mode = "Search";
                Form_Mode_Change("Search_M");
            });

            $('#BT_Detail_Search').on('click', function () {
                $("#dialog").dialog({
                    modal: true,
                    title: "查詢條件",
                    width: 800,//=Div寬度$
                    overlay: 0.5,
                    focus: true,
                    buttons: {
                        "Search": function () {
                            $("#dialog").dialog('close');
                            var Where_Text = "";

                            switch ($('#Dia_BT_Simple_Change').prop('disabled')) {
                                case true://Simple
                                    //console.warn(($('#Dia_TB1_C_No').val() == "") ? "A" : "B");

                                    switch ($('#Dia_TB1_Operator1').val()) {
                                        case "%LIKE%":
                                            Where_Text += " [客戶編號] LIKE '%" + $('#Dia_TB1_C_No').val() + "%'";
                                            break;
                                        case "LIKE%":
                                            Where_Text += " [客戶編號] LIKE '" + $('#Dia_TB1_C_No').val() + "%'";;
                                            break;
                                        case "%LIKE":
                                            Where_Text += " [客戶編號] LIKE '%" + $('#Dia_TB1_C_No').val() + "'";;
                                            break;
                                        default:
                                            Where_Text += " [客戶編號] " + $('#Dia_TB1_Operator1').val() + " '" + $('#Dia_TB1_C_No').val() + "'";
                                            break;
                                    }
                                    switch ($('#Dia_TB1_Operator2').val()) {
                                        case "%LIKE%":
                                            Where_Text += " AND [客戶簡稱] LIKE '%" + $('#Dia_TB1_C_SName').val() + "%'";
                                            break;
                                        case "LIKE%":
                                            Where_Text += " AND [客戶簡稱] LIKE '" + $('#Dia_TB1_C_SName').val() + "%'";;
                                            break;
                                        case "%LIKE":
                                            Where_Text += " AND [客戶簡稱] LIKE '%" + $('#Dia_TB1_C_SName').val() + "'";;
                                            break;
                                        default:
                                            Where_Text += " AND [客戶簡稱] " + $('#Dia_TB1_Operator2').val() + " '" + $('#Dia_TB1_C_SName').val() + "'";
                                            break;
                                    }
                                    console.warn(Where_Text);
                                    Search_Customer(Where_Text);
                                    break;
                                case false://Multiple
                                    Where_Text += $('#TB_Dia_Where').val();
                                    console.warn(Where_Text);
                                    Search_Customer(Where_Text);
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
                Form_Mode_Change("Edit_M");
            });

            $('#BT_ED_Save').on('click', function () {
                if (confirm("<%=Resources.MP.Edit_Alert%>")) {
                    if (Save_Check()) {
                        $.ajax({
                            url: "/Customer/Customer_Save.ashx",
                            data: {
                                "SEQ": $('#TB_M2_SEQ').val(),
                                "C_No": $('#TB_M2_C_No').val(),
                                "C_SName": $('#TB_M2_C_SName').val(),
                                "C_Name": $('#TB_M2_C_Name').val(),
                                "Nation": $('#TB_M2_C_Nation').val(),
                                "Quote_Class": $('#DDL_M2_Quoted').val(),
                                "Payment_Terms": $('#TB_M2_Payment_Terms').val(),
                                "Person_Commodity": $('#TB_M2_Person_Commodity').val(),
                                "Person_Sample": $('#TB_M2_Person_Sample').val(),
                                "Tel": $('#TB_M2_C_Tel').val(),
                                "Fax": $('#TB_M2_Fax').val(),
                                "EIN": $('#TB_M_EIN').val(),
                                "Web": $('#TB_M2_Web').val(),
                                "Mail": $('#TB_M2_Mail').val(),
                                "Price_Condition": $('#TB_M2_Price_condition').val(),
                                "Company_Address": $('#TB_M2_Company_Address').val(),
                                "Factory_Address": $('#TB_M2_Factory_Address').val(),
                                "Delivery_Address": $('#TB_M2_Delivery_Address').val(),
                                "Remark": $('#TB_RM_Remark').val(),
                                "Mail_Group": "",//$('#TB_M2_C_No').val(),
                                "Center_Use": "",//$('#TB_M2_C_No').val(),
                                "Currency": $('#DDL_M2_Currency').val(),
                                "Principal": $('#TB_M2_Principal').val(),
                                "MailEDM": $('#TB_M2_EDMMail').val(),
                                "IV_Address": $('#DDL_IVPK').val(),
                                "Shipping_Notes": $('#TB_CC_Shipping_Notes').val(),

                                "Call_Type": "Customer2_Update"
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
                                    Search_Customer();
                                    Form_Mode_Change("Search_M");
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
                if ($('#TB_M2_C_No').val().length < 4 || $('#TB_M2_C_No').val().length > 8) {
                    Alert_Message += "請輸入4~8碼客戶編號";
                    $('#TB_M2_C_No').css('background-color', 'red');
                    Check_Item = false;
                }
                if ($('#TB_M2_Mail').val().length === 0) {
                    Alert_Message += "\r\n請輸入Mail";
                    $('#TB_M2_Mail').css('background-color', 'red');
                    Check_Item = false;
                }
                if ($('#TB_M2_C_Nation').val().length === 0) {
                    Alert_Message += "\r\n請輸入國名";
                    $('#TB_M2_C_Nation').css('background-color', 'red');
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

            $('#TB_M2_C_SName ,#TB_RM_C_SName, #TB_CC_C_NO, #TB_M_C_SName, #TB_RF_C_SName').on('change', function () {
                $('#TB_M2_C_SName ,#TB_RM_C_SName, #TB_CC_C_NO, #TB_M_C_SName, #TB_RF_C_SName').val($(this).val());
            });

            //Will combine
            $('#Table_Search_Customer').on('click', 'tbody tr', function () {
                Table_Tr_Click($(this));
            });

            function Table_Tr_Click(Click_tr) {
                $(Click_tr).parent().find('tr').css('background-color', '');
                $(Click_tr).parent().find('tr').css('color', 'black');
                $(Click_tr).css('background-color', '#5a1400');
                $(Click_tr).css('color', 'white');

                var C_No = $(Click_tr).find('td:nth-child(1)').text().toString().trim();
                Form_Mode_Change("Search_D");
                $.ajax({
                    url: "/Customer/Customer_Search.ashx",
                    data: {
                        "C_No": C_No,
                        "Call_Type": "Customer2_Selected"
                    },
                    cache: false,
                    type: "POST",
                    datatype: "json",
                    contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                    success: function (response) {
                        $('#TB_M2_SEQ').val(String(response[0].C_SEQ ?? ""));
                        $('#TB_M2_C_No').val(C_No);
                        $('#TB_M2_C_SName').val(String(response[0].C_SName ?? ""));
                        $('#TB_M2_C_Name').val(String(response[0].C_Name ?? ""));
                        $('#TB_M2_C_Nation').val(String(response[0].C_Nation ?? ""));
                        $('#DDL_M2_Currency').val(String(response[0].C_Currency ?? ""));
                        $('#DDL_M2_Quoted').val(String(response[0].C_Quote ?? ""));
                        $('#TB_M2_Payment_Terms').val(String(response[0].C_Payment_Terms ?? ""));
                        $('#DDL_M2_Mail_Group').val(String(response[0].C_Mailgroup ?? ""));
                        $('#TB_M2_Principal').val(String(response[0].C_Principal ?? ""));
                        $('#TB_M2_Person_Commodity').val(String(response[0].C_Person_Commodity ?? ""));
                        $('#TB_M2_Person_Sample').val(String(response[0].C_Person_Sample ?? ""));
                        $('#TB_M2_C_Tel').val(String(response[0].C_Tel ?? ""));
                        $('#TB_M2_Fax').val(String(response[0].C_Fax ?? ""));
                        $('#TB_M2_Web').val(String(response[0].C_Web ?? ""));
                        $('#TB_M2_Mail').val(String(response[0].C_Mail ?? ""));
                        $('#TB_M2_EDMMail').val(String(response[0].C_MailEDM ?? ""));
                        $('TB_M2_Price_condition').val(String(response[0].C_Price_Condition ?? ""));
                        $('#DDL_IVPK').val(String(response[0].C_IV_Address ?? ""));
                        $('#TB_M2_Company_Address').val(String(response[0].C_Company_Address ?? ""));
                        $('#TB_M2_Factory_Address').val(String(response[0].C_Factory_Address ?? ""));
                        $('#TB_M2_Delivery_Address').val(String(response[0].C_Delivery_Address ?? ""));
                        $('#TB_M2_Update_User').val(String(response[0].C_Update_User ?? ""));
                        $('#TB_M2_Update_Date').val(String(response[0].C_Update_Date ?? ""));

                        $('#TB_RM_C_SName').val(String(response[0].C_SName ?? ""));
                        $('#TB_RM_Remark').val(String(response[0].C_Remark ?? ""));

                        $('#TB_CC_C_NO').val(String(response[0].C_SName ?? ""));
                        $('#TB_CC_Shipping_Notes').val(String(response[0].C_Shipping_Notes ?? ""));
                        $('#TB_CC_Customs_Broker').val(String(response[0].C_Customs_Broker ?? ""));
                        $('#TB_CC_TW_Air_Shipping_Agent').val(String(response[0].C_TW_Air_Shipping_Agent ?? ""));
                        $('#TB_CC_TW_Shipping_Agent').val(String(response[0].C_TW_Shipping_Agent ?? ""));
                        $('#TB_CC_TW_Shipping_Schedule').val(String(response[0].C_TW_Shipping_Schedule ?? ""));
                        $('#TB_CC_HK_Air_Shipping_Agent').val(String(response[0].C_HK_Air_Shipping_Agent ?? ""));
                        $('#TB_CC_HK_Shipping_Agent').val(String(response[0].C_HK_Shipping_Agent ?? ""));
                        $('#TB_CC_HK_Shipping_Schedule').val(String(response[0].C_HK_Shipping_Schedule ?? ""));

                        $('#TB_M_C_SName').val(String(response[0].C_SName ?? ""));
                        $('#TB_M_Port').val(String(response[0].C_Port ?? ""));
                        //C_Marks_File_Name = sdr["麥頭檔名"],
                        $('#DDL_M_Marks').val(String(response[0].C_Marks_File_Name ?? ""));
                        $('#IMG_M_MIMG').attr('src', "/MR/" + String(response[0].C_Marks_File_Name ?? "") + ".jpg");
                        //IMG_M_MIMG
                        //C_Marks_1 = sdr["麥頭_1"],
                        //C_Marks_2 = sdr["麥頭_2"],
                        //C_Marks_Shape = sdr["麥頭型狀"],
                        //C_Marks_Word = sdr["麥頭字"],
                        $('#TB_M_Packag_Request').val(String(response[0].C_Packag_Request ?? ""));
                        $('#TB_M_Special_Document').val(String(response[0].C_Special_Document ?? ""));
                        $('#TB_M_Express_Delivery_Account').val(String(response[0].C_Express_Delivery_Account ?? ""));
                        $('#TB_M_EIN').val(String(response[0].C_EIN ?? ""));

                        $('#TB_RF_C_SName').val(String(response[0].C_SName ?? ""));
                        $('#TB_RF_RF_No').val(String(response[0].C_Reference_Number ?? ""));
                        $('#DDL_RF_C_Source').val(String(response[0].C_Costomer_Source ?? ""));
                        $('#TB_RF_First_Contact').val(String(response[0].C_First_Contact ?? ""));
                        $('#TB_RF_Person_Purchase').val(String(response[0].C_Person_Purchase ?? ""));
                        $('#TB_RF_Person_Finance').val(String(response[0].C_Person_Finance ?? ""));
                        $('#TB_RF_Finance_Mail').val(String(response[0].C_Finance_Mail ?? ""));
                        $('#TB_RF_Aging_Shipping').val(String(response[0].C_Aging_Shipping ?? ""));
                        $('#TB_RF_Aging_Other').val(String(response[0].C_Aging_Other ?? ""));
                        $('#CB_RF_Stop_Date').prop('checked', (response[0].C_Stop_Date != null) ? true : false)
                        $('#TB_RF_Stop_Date').val(String(response[0].C_Stop_Date ?? ""));
                        $('#CB_RF_Center_Use').val(String(response[0].C_Center_Use ?? ""));

                    },
                    error: function (ex) {
                        alert(ex);
                    }
                });
            };

            function Search_Customer(Search_Where) {
                $.ajax({
                    url: "/Customer/Customer_Search.ashx",
                    data: {
                        "C_No": "",//$('#TB_Search_C_No').val(),
                        "Call_Type": "Customer2_Search",
                        "Search_Where": Search_Where ?? ""
                    },
                    cache: false,
                    type: "POST",
                    datatype: "json",
                    contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                    success: function (response) {
                        $('#Table_Search_Customer').DataTable({
                            "data": response,
                            "destroy": true,
                            "order": [[23, "desc"]],
                            "lengthMenu": [
                                [5, 10, 20, -1],
                                [5, 10, 20, "All"],
                            ],
                            "columns": [
                                { data: "C_No", title: "<%=Resources.Customer.Customer_No%>" },
                                { data: "C_Tel", title:"<%=Resources.Customer.Tel%>" },
                                { data: "C_SName", title: "<%=Resources.Customer.Customer_Short_Name%>" },
                                { data: "C_Fax", title: "<%=Resources.Customer.Fax%>" },
                                { data: "C_Name", title: "<%=Resources.Customer.Customer_Name%>" },
                                { data: "C_Nation", title: "<%=Resources.Customer.Nation%>" },
                                { data: "C_Principal", title: "<%=Resources.Customer.Principal%>" },
                                { data: "C_Payment_Terms", title: "<%=Resources.Customer.Payment_Terms%>" },
                                { data: "C_Person_Commodity", title: "<%=Resources.Customer.Person_Commodity%>" },
                                { data: "C_Quote", title: "<%=Resources.Customer.Quote_Class%>" },
                                { data: "C_Currency", title: "<%=Resources.Customer.Currency%>" },
                                { data: "C_Person_Sample", title: "<%=Resources.Customer.Person_Sample%>" },
                                { data: "C_Price_Condition", title: "<%=Resources.Customer.Price_Condition%>" },
                                { data: "C_Web", title: "<%=Resources.Customer.Web%>" },
                                { data: "C_Mail", title: "Mail" },
                                { data: "C_IV_Address", title: "<%=Resources.Customer.IV_Address%>" },
                                { data: "C_Costomer_Source", title: "<%=Resources.Customer.Costomer_Source%>" },
                                { data: "C_Reference_Number", title: "<%=Resources.Customer.Reference_Number%>" },
                                { data: "C_Company_Address", title: "<%=Resources.Customer.Company_Address%>" },
                                { data: "C_Factory_Address", title: "<%=Resources.Customer.Factory_Address%>" },
                                { data: "C_Delivery_Address", title: "<%=Resources.Customer.Delivery_Address%>" },
                                { data: "C_MailEDM", title: "MailEDM" },
                                { data: "C_Update_User", title: "<%=Resources.Customer.Update_User%>" },
                                { data: "C_Update_Date", title: "<%=Resources.Customer.Update_Date%>" },
                                { data: "C_SEQ", title: "<%=Resources.Customer.SEQ%>" }
                            ],
                        });
                        $('#Table_Search_Customer').css('white-space','nowrap');
                        $('#Table_Search_Customer thead th').css('text-align','center');
                    },
                    error: function (ex) {
                        alert(ex);
                    }
                });
            };

            $('#TB_Search_C_No').on('change', function () {
                if ($.trim($(this).val()) == "") {
                    $('#TB_Search_C_SName').val('');
                }
            });

            $('#TB_M2_C_Nation').autocomplete({
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
                    Search_Customer();
                },
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
                <td style="width: 20%;"><%=Resources.Customer.Customer_No%></td>
                <td style="width: 30%;">
                    <select style="width: 90%; height: 25px;" id="Dia_TB1_Operator1">
                        <option>=</option>
                        <option selected="selected">%LIKE%</option>
                        <option>LIKE%</option>
                        <option>%LIKE</option>
                    </select>
                </td>
                <td style="width: 50%;">
                    <input style="width: 90%; height: 25px;" id="Dia_TB1_C_No" />
                </td>
            </tr>
            <tr style="text-align: right;">
                <td style="width: 20%;"><%=Resources.Customer.Customer_Short_Name%></td>
                <td style="width: 30%;">
                    <select style="width: 90%; height: 25px;" id="Dia_TB1_Operator2">
                        <option>=</option>
                        <option selected="selected">%LIKE%</option>
                        <option>LIKE%</option>
                        <option>%LIKE</option>
                    </select>
                </td>
                <td style="width: 50%;">
                    <input style="width: 90%; height: 25px;" id="Dia_TB1_C_SName" />
                </td>
            </tr>
        </table>
        <table border="1" style="margin: 0 auto; display: none;" id="Dia_Table_Multiple">
            <tr style="text-align: center;">
                <td style="width: 40%;">
                    <%--Where Column--%>
                    <select style="width: 90%; height: 25px;" id="DDL_Dia_Filter">
                        <option value="[客戶編號]" selected="selected"><%=Resources.Customer.Customer_No%></option>
                        <option value="[客戶簡稱]"><%=Resources.Customer.Customer_Short_Name%></option>
                        <option value="[國名]"><%=Resources.Customer.Nation%></option>
                        <option value="[客戶來源]"><%=Resources.Customer.Costomer_Source%></option>
                        <option value="[報價等級]"><%=Resources.Customer.Quote_Class%></option>
                        <option value="[參考號碼]"><%=Resources.Customer.Reference_Number%></option>
                        <option value="[初接觸日]"><%=Resources.Customer.First_Contact%></option>
                        <option value="[電話]"><%=Resources.Customer.Tel%></option>
                        <option value="[傳真]"><%=Resources.Customer.Fax%></option>
                        <option value="[負責人]"><%=Resources.Customer.Principal%></option>
                        <option value="[連絡人大貨]"><%=Resources.Customer.Person_Commodity%></option>
                        <option value="[連絡人樣本]"><%=Resources.Customer.Person_Sample%></option>
                        <option value="[統一編號]"><%=Resources.Customer.EIN%></option>
                        <option value="[序號]"><%=Resources.Customer.SEQ%></option>
                        <option value="[更新人員]"><%=Resources.Customer.Update_User%></option>
                        <option value="[更新日期]"><%=Resources.Customer.Update_Date%></option>
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
        <tr style="display:none;">
            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Customer.Customer_No%></td>
            <td style="text-align: left; width: 15%;">
                <input id="TB_Search_C_No" name="TB_Search_C_No" placeholder="<%=Resources.MP.C_No_ATC_Hint%>" type="text" style="width: 100%;" />
            </td>

            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Customer.Update_Date%></td>
            <td style="text-align: left; width: 15%;">
                <input id="TB_Search_Update_Date" style="width: 100%;" type="date" /></td>
            <td></td>
            <td></td>
            <td style="width: 10%;"></td>
            <td rowspan="4" style="text-align: center;">
                <div style="display: flex; justify-content: center; align-items: center;">
                    <input id="" class="BTN" type="button" value="<%=Resources.MP.Search%>" />
                </div>
            </td>
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
                <input type="button" id="BT_Detail_Search" class="M_BT" value="<%=Resources.Customer.Detail_Search%>" />
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
        <input id="V_BT_Master" type="button" class="V_BT" value="<%=Resources.Customer.Master%>" onclick="$('.Div_D').css('display','none');$('#Div_M2').css('display','');" disabled="disabled" />
        <input type="button" class="V_BT" style="display:none;" value="<%=Resources.Customer.Remark%>" onclick="$('.Div_D').css('display','none');$('#Div_Remark').css('display','');" />
        <input type="button" class="V_BT" style="display:none;" value="<%=Resources.Customer.Customs_Clearance%>" onclick="$('.Div_D').css('display','none');$('#Div_Customs_Clearance').css('display','');" />
        <input type="button" class="V_BT" style="display:none;" value="<%=Resources.Customer.Marks%>" onclick="$('.Div_D').css('display','none');$('#Div_Marks').css('display','');" />
        <input type="button" class="V_BT" style="display:none;" value="<%=Resources.Customer.Reference%>" onclick="$('.Div_D').css('display','none');$('#Div_Reference').css('display','');" />
        <input type="button" class="V_BT" style="display:none;" value="<%=Resources.Customer.Example%>" onclick="$('.Div_D').css('display','none');$('#Div_Example').css('display','');" />
    </div>
    <div style="width: 100%;" id="Div_Detail_Form">
        <div id="Div_M2" class="Div_D">
            <table style="font-size: 15px; border-collapse: separate; border-spacing: 0px 8px;">
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Customer.Customer_No%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M2_C_No" type="text" disabled="disabled" style="width: 100%;" pattern="^([a-zA-Z]+\d+|\d+[a-zA-Z]+)[a-zA-Z0-9]*$" minlength="4" maxlength="8" title="客戶編號僅能4至8碼" />
                    </td>

                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Customer.Tel%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M2_C_Tel" disabled="disabled" style="width: 100%;" maxlength="20" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Customer.Customer_Short_Name%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M2_C_SName" disabled="disabled" style="width: 100%;" maxlength="35" />
                    </td>

                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Customer.Fax%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M2_Fax" disabled="disabled" style="width: 100%;" maxlength="20" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Customer.Customer_Name%></td>
                    <td style="text-align: left; width: 40%;" colspan="3">
                        <input id="TB_M2_C_Name" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Customer.Nation%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M2_C_Nation" disabled="disabled" style="width: 100%;" />

                        <%--<select id="DDL_M2_Nation" disabled="disabled" style="width: 100%;">
                            <option>大洋洲</option>
                            <option>ZIMBABWE</option>
                            <option>VIETNAM</option>
                            <option>USA</option>
                            <option>URUGUAY</option>
                            <option>UNITED ARAB EMIRATES</option>
                            <option>UKRAINE</option>
                            <option>U.K.</option>
                            <option>TW</option>
                        </select>--%>
                    </td>

                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Customer.Principal%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M2_Principal" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Customer.Currency%></td>
                    <td style="text-align: left; width: 15%;">
                        <select id="DDL_M2_Currency" disabled="disabled" style="width: 100%;" >
                            <option>USD</option>
                            <option>NTD</option>
                            <option>EUR</option>
                            <option>RMB</option>
                            <option>YEN</option>
                        </select>
                    </td>

                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Customer.Mail_Group%></td>
                    <td style="text-align: left; width: 15%;">
                        <select id="DDL_M2_Mail_Group" disabled="disabled" style="width: 100%;" >
                            <option>Test</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Customer.Payment_Terms%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M2_Payment_Terms" disabled="disabled" style="width: 100%;" maxlength="12" />
                    </td>

                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Customer.Person_Commodity%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M2_Person_Commodity" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Customer.Quote_Class%></td>
                    <td style="text-align: left; width: 15%;">
                        <select id="DDL_M2_Quoted" disabled="disabled" style="width: 100%;" >
                            <option value="R">R-Retail</option>
                            <option value="W">W-WholeSale</option>
                            <option value="B">B-Business</option>
                            <option value="D">D-Distributor</option>
                            <option value="MD">MD-M.Distributor</option>
                            <option value="G">G-成品客戶</option>
                            <option value="F">F-五階之外</option>
                        </select>
                    </td>

                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Customer.Person_Sample%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M2_Person_Sample" disabled="disabled" style="width: 100%;" maxlength="35" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Customer.Price_Condition%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M2_Price_condition" disabled="disabled" style="width: 100%;" maxlength="35" />
                    </td>

                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Customer.Web%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M2_Web" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;">E-Mail</td>
                    <td style="text-align: left; width: 40%;" colspan="3">
                        <input id="TB_M2_Mail" disabled="disabled" style="width: 100%;" maxlength="50" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;">EDM-Mail</td>
                    <td style="text-align: left; width: 40%;" colspan="3">
                        <textarea id="TB_M2_EDMMail" style="width: 100%;" disabled="disabled"></textarea>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Customer.IV_Address%></td>
                    <td style="text-align: left; width: 15%;">
                        <select id="DDL_IVPK" disabled="disabled" style="width: 100%;" >
                            <option>公司</option>
                            <option>工廠</option>
                            <option>送貨</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Customer.Company_Address%></td>
                    <td colspan="3" style="text-align: left; width: 15%;">
                        <textarea id="TB_M2_Company_Address" style="width: 100%;" disabled="disabled"></textarea>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Customer.Factory_Address%></td>
                    <td colspan="3" style="text-align: left; width: 15%;">
                        <textarea id="TB_M2_Factory_Address" style="width: 100%;" disabled="disabled"></textarea>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Customer.Delivery_Address%></td>
                    <td colspan="3" style="text-align: left; width: 15%;">
                        <textarea id="TB_M2_Delivery_Address" style="width: 100%;" disabled="disabled"></textarea>
                    </td>
                </tr>
                <tr class="M2_For_N" style="display:none;">
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Customer.Reference_Number%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M2_RF_No" disabled="disabled" style="width: 100%;" maxlength="20" />
                    </td>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Customer.Costomer_Source%></td>
                    <td style="text-align: left; width: 15%;">
                        <select id="DDL_M2_C_Source" disabled="disabled" style="width: 100%;">
                            <option>01-外銷網站</option>
                            <option>02-內銷網站</option>
                            <option>03-APLF</option>
                            <option>04-客戶介紹</option>
                            <option>05-日本雜誌</option>
                            <option value="06-BOSS EMAIL">06-Boss Email</option>
                            <option value="07-BOSS 拜訪">07-Boss 拜訪</option>
                            <option>08-禮品展</option>
                            <option>09-印尼展</option>
                            <option>10-越南展</option>
                            <option value="11-SHOPIFY">11-Shopify</option>
                            <option value="12-CRAFTPLUS">12-CraftPlus</option>
                            <option value="13-BUSINESS">13-Business</option>
                            <option>14-SP-Etsy</option>
                            <option>98-其他</option>
                            <option value="99-NONE">99-None</option>
                        </select>
                    </td>
                </tr>
                <tr class="M2_For_U" style="display:none;">
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Customer.Update_User%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M2_Update_User" disabled="disabled" style="width: 100%;" />
                    </td>

                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Customer.Update_Date%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M2_Update_Date" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
                <tr class="M2_For_U" style="display:none;">
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Customer.SEQ%></td>
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
            <table style="font-size: 15px; border-collapse: separate; border-spacing: 0px 10px;">
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Customer.Customer_Short_Name%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_RM_C_SName" disabled="disabled" style="width: 100%;" />
                    </td>
                    <td style="width: 10%;"></td>
                    <td style="width: 15%;"></td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Customer.Remark%></td>
                    <td style="text-align: left;" colspan="3">
                        <textarea id="TB_RM_Remark" style="width: 100%; height: 250px;" disabled="disabled"></textarea>
                    </td>
                </tr>
            </table>
        </div>

        <div id="Div_Customs_Clearance" class="Div_D" style="display: none; overflow: auto;">
            <table style="font-size: 15px; border-collapse: separate; border-spacing: 0px 10px;">
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Customer.Customer_Short_Name%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_CC_C_NO" disabled="disabled" style="width: 100%; " />
                    </td>
                    <td style="width: 10%;"></td>
                    <td style="width: 15%;"></td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Customer.Customs_Broker%></td>
                    <td style="text-align: left;" colspan="3">
                        <textarea id="TB_CC_Customs_Broker" style="width: 100%; height: 150px;" disabled="disabled"></textarea>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" style="text-align:center;">TW</td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Customer.Air_Shipping_Agent%></td>
                    <td style="text-align: left;" colspan="3">
                        <textarea id="TB_CC_TW_Air_Shipping_Agent" style="width: 100%; height: 150px;" disabled="disabled"></textarea>
                    </td>
                </tr>
                
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Customer.Shipping_Agent%></td>
                    <td style="text-align: left;" colspan="3">
                        <textarea id="TB_CC_TW_Shipping_Agent" style="width: 100%; height: 150px;" disabled="disabled"></textarea>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Customer.Shipping_Schedule%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_CC_TW_Shipping_Schedule" disabled="disabled" style="width: 100%; " />
                    </td>
                </tr>
                <tr>
                    <td colspan="2" style="text-align:center;">HK</td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Customer.Air_Shipping_Agent%></td>
                    <td style="text-align: left;" colspan="3">
                        <textarea id="TB_CC_HK_Air_Shipping_Agent" style="width: 100%; height: 150px;" disabled="disabled"></textarea>
                    </td>
                </tr>
                
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Customer.Shipping_Agent%></td>
                    <td style="text-align: left;" colspan="3">
                        <textarea id="TB_CC_HK_Shipping_Agent" style="width: 100%; height: 150px;" disabled="disabled"></textarea>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Customer.Shipping_Schedule%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_CC_HK_Shipping_Schedule" disabled="disabled" style="width: 100%; " />
                    </td>
                </tr>
                <tr><td><br /></td></tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Customer.Shipping_Notes%></td>
                    <td style="text-align: left;" colspan="3">
                        <textarea id="TB_CC_Shipping_Notes" style="width: 100%; height: 150px;" disabled="disabled"></textarea>
                    </td>
                </tr>
            </table>
        </div>

        <div id="Div_Marks" class="Div_D" style="display: none; overflow: auto;">
            <table style="font-size: 15px; border-collapse: separate; border-spacing: 0px 10px;">
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Customer.Customer_Short_Name%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M_C_SName" disabled="disabled" style="width: 100%;" />
                    </td>
                    <td style="width: 5%;"></td>
                    <td style="width: 15%;"></td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Customer.Port%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M_Port" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Customer.Marks%></td>
                    <td style="text-align: left; width: 15%;">
                        <select id="DDL_M_Marks" disabled="disabled" style="width: 100%;" >
                            <option value="M00">M00 空白</option>
                            <option value="M01">M01 IVAN三角</option>
                            <option value="M02">M02 IVAN菱形</option>
                            <option value="M03">M03 IVANT長方</option>
                            <option value="M99">M99 依客戶編號</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <%--<td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Customer.Marks%>-1</td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M_Marks1" disabled="disabled" style="width: 100%;" />
                    </td>

                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Customer.Marks%>-2</td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M_Marks2" disabled="disabled" style="width: 100%;" />
                    </td>
                    <td></td>--%>
                    <td></td>
                    <td colspan="3">
                        <img id="IMG_M_MIMG" src="" />
                    </td>
                </tr>
                <%--<tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Customer.Marks_Shape%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M_Marks_Shape" disabled="disabled" style="width: 100%;" />
                    </td>

                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Customer.Marks_Word%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M_Marks_Word" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>--%>
                
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Customer.Packag_Request%></td>
                    <td style="text-align: left;" colspan="3">
                        <textarea id="TB_M_Packag_Request" style="width: 100%; height: 150px;" disabled="disabled"></textarea>
                    </td>
                </tr>
                
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Customer.Special_Document%></td>
                    <td style="text-align: left;" colspan="3">
                        <textarea id="TB_M_Special_Document" style="width: 100%; height: 150px;" disabled="disabled"></textarea>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Customer.Express_Delivery_Account%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M_Express_Delivery_Account" disabled="disabled" style="width: 100%;" />
                    </td>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Customer.EIN%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M_EIN" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
            </table>
        </div>

        <div id="Div_Reference" class="Div_D" style="display: none; overflow: auto;">
            <table style="font-size: 15px; border-collapse: separate; border-spacing: 0px 20px;">
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Customer.Customer_Short_Name%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_RF_C_SName" disabled="disabled" style="width: 100%;" />
                    </td>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Customer.Reference_Number%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_RF_RF_No" disabled="disabled" style="width: 100%;" maxlength="20" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Customer.Costomer_Source%></td>
                    <td style="text-align: left; width: 15%;">
                        <select id="DDL_RF_C_Source" disabled="disabled" style="width: 100%;" >
                            <option>01-外銷網站</option>
                            <option>02-內銷網站</option>
                            <option>03-APLF</option>
                            <option>04-客戶介紹</option>
                            <option>05-日本雜誌</option>
                            <option value="06-BOSS EMAIL">06-Boss Email</option>
                            <option value="07-BOSS 拜訪">07-Boss 拜訪</option>
                            <option>08-禮品展</option>
                            <option>09-印尼展</option>
                            <option>10-越南展</option>
                            <option value="11-SHOPIFY">11-Shopify</option>
                            <option value="12-CRAFTPLUS">12-CraftPlus</option>
                            <option value="13-BUSINESS">13-Business</option>
                            <option>14-SP-Etsy</option>
                            <option>98-其他</option>
                            <option value="99-NONE">99-None</option>
                        </select>
                    </td>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Customer.First_Contact%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_RF_First_Contact" type="date" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Customer.Person_Finance%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_RF_Person_Finance" disabled="disabled" style="width: 100%;" />
                    </td>
                    <td style="text-align: right; text-wrap: none; width: 10%;color:red;"><%=Resources.Customer.Person_Purchase%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_RF_Person_Purchase" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>                
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Customer.Finance_Mail%></td>
                    <td style="text-align: left;" colspan="3">
                        <input id="TB_RF_Finance_Mail" type="email" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
                
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;color:red;">海運帳齡</td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_RF_Aging_Shipping" disabled="disabled" style="width: 100%;" />
                    </td>
                    <td style="text-align: right; text-wrap: none; width: 10%;color:red;">非海運帳齡</td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_RF_Aging_Other" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
                
                <tr>
                    <td></td>
                    <td style="text-align: left; text-wrap: none;">
                        <input id="CB_RF_Stop_Date" type="checkbox" />
                        <label for="CB_RF_Stop_Date">停用日期</label>
                        <br />
                        <input id="TB_RF_Stop_Date" type="date" disabled="disabled" style="width: 100%;" />
                        <br />
                        <span style="color:red;">會計維護(帳齡預設30天)</span>
                    </td>
                    <td></td>
                    <td style="text-align: left; text-wrap: none;">
                        <input type="checkbox" id="CB_RF_Center_Use" />
                        <label for="CB_RF_Center_Use">發貨中心使用</label>
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
                        <textarea id="TB_E_Example" style="width: 100%; height: 450px;background-color:yellowgreen;" disabled="disabled">
正式客戶編號 (5~6碼)

1XXXXy : 第1碼:1字頭  第2-5碼:區域+序號  第6碼:y部門
1AXXX ~ 1ZXXX 不分區(尚未開放)

**********************************************************

開發中客戶編號 (6碼)

CXXXXX : 來自外銷網站單號C 第1碼:C字頭  第2-6碼:流水序號 
MXXXXX : 開發中客戶需輸入訂單 第1碼:M字頭  第2-6碼:流水序號 
NXXXXX : Shopify專用客戶 第1碼:N字頭  第2-6碼:流水序號 

2000~9999 : 舊開發中客戶,需使用可變更成1XXXX,再建立訂單

**********************************************************
檔案關聯參考:
Be120/Be850/ColSetBC
                        </textarea>
                    </td>
                </tr>
            </table>
        </div>
    </div>
    <br />
    <br />

</asp:Content>

