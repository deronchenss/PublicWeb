<%@ Page Title="Customer Search" Language="C#" MasterPageFile="~/MP.master" AutoEventWireup="true" CodeFile="Customer1.aspx.cs" Inherits="Customer1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <link href="/css/dataTables.bootstrap4.min.css" rel="stylesheet" />
    <script src="/js/jquery.dataTables.min.js"></script>
    <script src="/js/dataTables.bootstrap4.min.js"></script>

    <table class="table_th" style="width:98%">
        <tr>
            <td style="height: 10px; font-size: smaller;" colspan="8">&nbsp</td>
        </tr>
        <tr>
            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Customer_No%></td>
            <td style="text-align: left; width: 15%;">
                <input id="TB_Search_C_No" name="TB_Search_C_No" placeholder="<%=Resources.MP.C_No_ATC_Hint%>" type="text" style="width: 100%;" />
            </td>
            <script type="text/javascript">
                $(document).ready(function () {
                    Search_Customer();

                    
                    <%--let IVMD_PERMISSIONS = String("<%= Session["IVMD_PERMISSIONS"] %>");
                    let D_PERMISSIONS_ALL = IVMD_PERMISSIONS.split(',');
                    $('[IVMD_PERMISSIONS]').css('display', 'none');
                    //console.warn(D_PERMISSIONS_ALL);

                    D_PERMISSIONS_ALL.forEach(function (j) {
                        //console.warn(j.trim());
                        $('[IVMD_PERMISSIONS=' + j.trim() + ']').css('display', '');
                    })--%>



                    /*
                    let Cookie_ALL = document.cookie.split(';');
                    var PERMISSIONS;
                    Cookie_ALL.forEach(function (i) {
                        if (i.indexOf("IVMD_PERMISSIONS=") > 0) {
                            PERMISSIONS = i.trim().substr("IVMD_PERMISSIONS=".length, i.length);
                        }
                    });
                    console.warn(PERMISSIONS);

                    let PERMISSIONS_ALL = PERMISSIONS.split(',');
                    $('[IVMD_PERMISSIONS]').css('display', 'none');

                    PERMISSIONS_ALL.forEach(function (j) {
                        console.warn(j.trim());
                        $('[IVMD_PERMISSIONS=' + j.trim() + ']').css('display', '');
                    })
                    */
                    

                    function Table_Tr_Click(Click_tr) {
                        $(Click_tr).parent().find('tr').css('background-color', '');
                        $(Click_tr).parent().find('tr').css('color', 'black');
                        $(Click_tr).css('background-color', '#5a1400');
                        $(Click_tr).css('color', 'white');

                        var C_No = $(Click_tr).find('td:nth-child(1)').text().toString().trim();

                        $.ajax({
                            url: "/Page/Base/Customer/Customer_Search.ashx",
                            data: {
                                "C_No": C_No,
                                "Call_Type": "Table_Selected"
                            },
                            cache: false,
                            type: "POST",
                            datatype: "json",
                            contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                            success: function (response) {
                                $('#TB_B2_C_No').val(C_No);
                                $('#TB_B2_C_SName').val(String(response[0].C_SName ?? ""));
                                $('#TB_B2_C_Tel').val(String(response[0].C_Tel ?? ""));
                                $('#TB_B2_C_Name').val(String(response[0].C_Name ?? ""));
                                $('#TB_B2_C_Nation').val(String(response[0].C_Nation ?? ""));
                                $('#TB_B2_Principal').val(String(response[0].C_Principal ?? ""));
                                $('#TB_B2_Person_Commodity').val(String(response[0].C_Person_Commodity ?? ""));
                                $('#TB_B2_Person_Sample').val(String(response[0].C_Person_Sample ?? ""));
                                $('#TB_B2_Mail').val(String(response[0].C_Mail ?? ""));
                                $('#TB_B2_Web').val(String(response[0].C_Web ?? ""));
                                $('#TB_B2_Costomer_Source').val(String(response[0].C_Source ?? ""));
                                $('#TB_B2_Mail_Group').val(String(response[0].C_Mail_Group ?? ""));
                                $('#TB_B2_Company_Address').val(String(response[0].C_Company_Address ?? ""));
                                $('#TB_B2_Factory_Address').val(String(response[0].C_Factory_Address ?? ""));
                                $('#TB_B2_Delivery_Address').val(String(response[0].C_Delivery_Address ?? ""));
                                $('#TB_B2_Update_User').val(String(response[0].C_Update_User ?? ""));
                                $('#TB_B2_Update_Date').val(String(response[0].C_Update_Date ?? ""));

                                $('#TB_TW_C_NO').val(String(response[0].C_SName ?? ""));
                                $('#TB_TW_Customs_Broker').val(String(response[0].C_Customs_Broker ?? ""));
                                $('#TB_TW_Air_Shipping_Agent').val(String(response[0].C_TW_Air_Shipping_Agent ?? ""));
                                $('#TB_TW_Shipping_Agent').val(String(response[0].C_TW_Shipping_Agent ?? ""));
                                $('#TB_TW_Shipping_Schedule').val(String(response[0].C_TW_Shipping_Schedule ?? ""));
                                $('#TB_TW_Shipping_Notes').val(String(response[0].C_Shipping_Notes ?? ""));

                                $('#TB_HK_C_NO').val(String(response[0].C_SName ?? ""));
                                $('#TB_HK_Air_Shipping_Agent').val(String(response[0].C_HK_Air_Shipping_Agent ?? ""));
                                $('#TB_HK_Shipping_Agent').val(String(response[0].C_HK_Shipping_Agent ?? ""));
                                $('#TB_HK_Shipping_Schedule').val(String(response[0].C_HK_Shipping_Schedule ?? ""));

                                $('#TB_M_C_SName').val(String(response[0].C_SName ?? ""));
                                $('#TB_M_Port').val(String(response[0].C_Port ?? ""));
                                $('#TB_M_Marks1').val(String(response[0].C_Marks_1 ?? ""));
                                $('#TB_M_Marks2').val(String(response[0].C_Marks_2 ?? ""));
                                $('#TB_M_Marks_Shape').val(String(response[0].C_Marks_Shape ?? ""));
                                $('#TB_M_Marks_Word').val(String(response[0].C_Marks_Word ?? ""));
                                $('#TB_M_Special_Document').val(String(response[0].C_Special_Document ?? ""));
                                $('#TB_M_Express_Delivery_Account').val(String(response[0].C_Express_Delivery_Account ?? ""));
                                $('#TB_M_EIN').val(String(response[0].C_EIN ?? ""));

                                $('#TB_R_C_NO').val(String(response[0].C_SName ?? ""));
                                $('#TB_R_Remark').val(String(response[0].C_Remark ?? ""));

                            },
                            error: function (ex) {
                                alert(ex);
                            }
                        });
                    };

                    function Search_Customer() {
                        $.ajax({
                            url: "/Page/Base/Customer/Customer_Search.ashx",
                            data: {
                                "C_No": $('#TB_Search_C_No').val(),
                                "C_Address": $('#TB_Search_C_Address').val(),
                                "C_Tel": $('#TB_Search_Tel').val(),
                                "Nation": $('#TB_Search_Nation').val(),
                                "C_Source": $('#TB_Search_C_Source').val(),
                                "C_Mail_Group": $('#TB_Search_Mail_Group').val(),
                                "C_Update_Date": $('#TB_Search_Update_Date').val(),
                                "C_Mail": $('#TB_Search_Mail').val(),
                                "Call_Type": "BT_Search"
                            },
                            cache: false,
                            type: "POST",
                            datatype: "json",
                            contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                            success: function (response) {
                                var Table_HTML =
                                    '<thead><tr><th>' + '<%=Resources.MP.Customer_No%>'
                                    + '</th><th>' + '<%=Resources.MP.Customer_Short_Name%>'
                                    + '</th><th>' + '<%=Resources.MP.Customer_Source%>'
                                    + '</th><th>' + '<%=Resources.MP.Quote_Class%>'
                                    + '</th><th>' + '<%=Resources.MP.Tel%>'
                                    + '</th><th>' + '<%=Resources.MP.Fax%>'
                                    + '</th><th>' + '<%=Resources.MP.Person_Commodity%>'
                                    + '</th><th>' + '<%=Resources.MP.Person_Sample%>'
                                    + '</th><th>' + '<%=Resources.MP.Nation%>'
                                    + '</th><th>' + 'Mail'
                                    + '</th><th>' + '<%=Resources.MP.SEQ%>'
                                    + '</th><th>' + '<%=Resources.MP.Update_User%>'
                                    + '</th><th>' + '<%=Resources.MP.Update_Date%>'
                                    + '</th></tr></thead><tbody>';

                                $(response).each(function (i) {
                                    Table_HTML +=
                                        '<tr><td>' + String(response[i].C_No) +
                                        '</td><td>' + String(response[i].C_SName ?? "") +
                                        '</td><td>' + String(response[i].C_Source ?? "") +
                                        '</td><td>' + String(response[i].C_Quote ?? "") +
                                        '</td><td>' + String(response[i].C_Tel ?? "") +
                                        '</td><td>' + String(response[i].C_Fax ?? "") +
                                        '</td><td>' + String(response[i].C_Person_Commodity ?? "") +
                                        '</td><td>' + String(response[i].C_Person_Sample ?? "") +
                                        '</td><td>' + String(response[i].C_Nation ?? "") +
                                        '</td><td>' + String(response[i].C_Mail ?? "") +
                                        '</td><td>' + String(response[i].C_SEQ ?? "") +
                                        '</td><td>' + String(response[i].C_Update_User ?? "") +
                                        '</td><td>' + String(response[i].C_Update_Date ?? "") +
                                        '</td></tr>';
                                });
                                Table_HTML += '</tbody>';
                                //$('#Table_Customer').html(Table_HTML);
                                
                                $('#Table_Customer').DataTable({
                                    "data": response,
                                    "destroy": true,
                                    "columns": [
                                        { data: "C_No", title: "<%=Resources.MP.Customer_No%>" },
                                        { data: "C_SName", title: "<%=Resources.MP.Customer_Short_Name%>" },
                                        { data: "C_Source", title: "<%=Resources.MP.Customer_Source%>" },
                                        { data: "C_Quote", title: "<%=Resources.MP.Quote_Class%>" },
                                        { data: "C_Tel", title: "<%=Resources.MP.Tel%>" },
                                        { data: "C_Fax", title: "<%=Resources.MP.Fax%>" },
                                        { data: "C_Person_Commodity", title: "<%=Resources.MP.Person_Commodity%>" },
                                        { data: "C_Person_Sample", title: "<%=Resources.MP.Person_Sample%>" },
                                        { data: "C_Nation", title: "<%=Resources.MP.Nation%>" },
                                        { data: "C_Mail", title: "Mail" },
                                        { data: "C_SEQ", title: "<%=Resources.MP.SEQ%>" },
                                        { data: "C_Update_User", title: "<%=Resources.MP.Update_User%>" },
                                        { data: "C_Update_Date", title: "<%=Resources.MP.Update_Date%>" }
                                    ],
                                    "language": {
                                        "lengthMenu": "&nbsp;Show _MENU_ entries"
                                    },
                                });

                                $('#Table_Customer').attr('style', 'white-space:nowrap;');
                                $('#Table_Customer thead th').attr('style', 'text-align:center;');
                                $('#Table_Customer').on('click', 'tbody tr', function () {
                                    Table_Tr_Click($(this));
                                });

                            },
                            error: function (ex) {
                                alert(ex);
                            }
                        });
                    };


                    $('#BT_Search').on('click', function () {
                        Search_Customer();
                    });

                    $('#TB_Search_C_No').on('change', function () {
                        if ($.trim($(this).val()) == "") {
                            $('#TB_Search_C_SName').val('');
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

            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Update_Date%></td>
            <td style="text-align: left; width: 15%;">
                <input id="TB_Search_Update_Date" style="width: 100%;" type="date" /></td>

            <td></td>
            <td></td>
            <td style="width: 10%;"></td>
            <td rowspan="4" style="text-align: center;">
                <div style="display: flex; justify-content: center; align-items: center;">
                    <input id="BT_Search" class="BTN" type="button" value="<%=Resources.MP.Search%>" />
                </div>
            </td>
        </tr>
        <tr>
            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Customer_Short_Name%></td>
            <td style="text-align: left; width: 15%;">
                <input id="TB_Search_C_SName" style="width: 100%;" disabled="disabled" /></td>

            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Nation%></td>
            <td style="text-align: left; width: 15%;">
                <input id="TB_Search_Nation" style="width: 100%;" /></td>

            <td style="text-align: right; text-wrap: none; width: 10%;">E-Mail</td>
            <td style="text-align: left; width: 15%;">
                <input id="TB_Search_Mail" type="email" style="width: 100%;"  /></td>
        </tr>
        <tr>
            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Company_Address%></td>
            <td style="text-align: left; width: 15%;">
                <input id="TB_Search_C_Address" style="width: 100%;" /></td>

            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Customer_Source%></td>
            <td style="text-align: left; width: 15%;">
                <input id="TB_Search_C_Source" style="width: 100%;" /></td>
        </tr>
        <tr>
            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Tel%></td>
            <td style="text-align: left; width: 15%;">
                <input id="TB_Search_Tel" style="width: 100%;"/></td>

            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Mail_Group%></td>
            <td style="text-align: left; width: 15%;">
                <input id="TB_Search_Mail_Group" style="width: 100%;" /></td>
        </tr>
        <tr>
            <td style="height: 10px; font-size: smaller;" colspan="8">&nbsp</td>
        </tr>
    </table>

    <div style="width: 99%; margin: 0 auto; background-color: white;">
        &nbsp;
        <input type="button" class="V_BT" value="<%=Resources.MP.Basic%>" onclick="$('.Div_D').css('display','none');$('#Div_Basic2').css('display','');" disabled="disabled" />
        <input type="button" class="V_BT" IVMD_PERMISSIONS="1" value="<%=Resources.MP.TW_Customs_Clearance%>" onclick="$('.Div_D').css('display','none');$('#Div_TW_Customs_Clearance').css('display','');" />
        <input type="button" class="V_BT" IVMD_PERMISSIONS="2" value="<%=Resources.MP.HK_Customs_Clearance%>" onclick="$('.Div_D').css('display','none');$('#Div_HK_Customs_Clearance').css('display','');" />
        <input type="button" class="V_BT" value="<%=Resources.MP.Marks%>" onclick="$('.Div_D').css('display','none');$('#Div_Marks').css('display','');" />
        <input type="button" class="V_BT" value="<%=Resources.MP.Remark%>" onclick="$('.Div_D').css('display','none');$('#Div_Remark').css('display','');" />
        <input type="button" class="V_BT" value="Title" onclick="$('.Div_D').css('display','none');$('#Div_Title').css('display','');" />
    </div>
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
    </style>
    <script type="text/javascript">
        $(document).ready(function () {
            $('.V_BT').on('click', function () {
                $(this).attr('disabled', 'disabled');
                $('.V_BT').not($(this)).attr('disabled', false);
            });
        });
    </script>
    <div style="width: 98%; margin: 0 auto;">
        <div id="Div_Basic" style="float:left;overflow:auto;width:50%;">
            <table id="Table_Customer" style="width: 100%" class="table table-striped table-bordered">
                <thead></thead>
                <tbody></tbody>
            </table>
            <style type="text/css">
                #Table_Customer tbody tr:hover {
                    background-color: #f8981d;
                    color: white;
                }
            </style>
        </div>
        
        <div id="Div_Basic2" class="Div_D">
            <table style="font-size: 15px;border-collapse:separate; border-spacing:0px 8px;">
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Customer_No%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_B2_C_No" disabled="disabled" style="width: 100%;" />
                    </td>

                    <td style="text-align: right; text-wrap: none; width: 10%;"></td>
                    <td style="text-align: left; width: 15%;">
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Customer_Short_Name%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_B2_C_SName" disabled="disabled" style="width: 100%;" />
                    </td>

                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Tel%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_B2_C_Tel" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Customer_Name%></td>
                    <td style="text-align: left; width: 40%;" colspan="3">
                        <input id="TB_B2_C_Name" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Nation%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_B2_C_Nation" disabled="disabled" style="width: 100%;" />
                    </td>

                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Principal%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_B2_Principal" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Person_Commodity%></td>
                    <td style="text-align: left; width: 40%;" colspan="3">
                        <input id="TB_B2_Person_Commodity" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Person_Sample%></td>
                    <td style="text-align: left; width: 40%;" colspan="3">
                        <input id="TB_B2_Person_Sample" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;">E-Mail</td>
                    <td style="text-align: left; width: 40%;" colspan="3">
                        <input id="TB_B2_Mail" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Web%></td>
                    <td style="text-align: left; width: 40%;" colspan="3">
                        <input id="TB_B2_Web" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Customer_Source%></td>
                    <td style="text-align: left; width: 40%;" colspan="3">
                        <input id="TB_B2_Costomer_Source" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Mail_Group%></td>
                    <td style="text-align: left; width: 40%;" colspan="3">
                        <input id="TB_B2_Mail_Group" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Company_Address%></td>
                    <td colspan="3" style="text-align: left; width: 15%;">
                        <textarea id="TB_B2_Company_Address" style="width: 100%;" disabled="disabled"></textarea>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Factory_Address%></td>
                    <td colspan="3" style="text-align: left; width: 15%;">
                        <textarea id="TB_B2_Factory_Address" style="width: 100%;" disabled="disabled"></textarea>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Delivery_Address%></td>
                    <td colspan="3" style="text-align: left; width: 15%;">
                        <textarea id="TB_B2_Delivery_Address" style="width: 100%;" disabled="disabled"></textarea>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Update_User%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_B2_Update_User" disabled="disabled" style="width: 100%;" />
                    </td>

                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Update_Date%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_B2_Update_Date" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
            </table>
        </div>

        <div id="Div_TW_Customs_Clearance" class="Div_D" style="display:none;overflow:auto;">
            <table style="font-size: 15px;">
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Customer_Short_Name%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_TW_C_NO" disabled="disabled" style="width: 100%; " />
                    </td>
                    <td style="width: 10%;"></td>
                    <td style="width: 15%;"></td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Customs_Broker%></td>
                    <td style="text-align: left;" colspan="3">
                        <textarea id="TB_TW_Customs_Broker" style="width: 100%; height: 150px;" disabled="disabled"></textarea>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Air_Shipping_Agent%></td>
                    <td style="text-align: left;" colspan="3">
                        <textarea id="TB_TW_Air_Shipping_Agent" style="width: 100%; height: 150px;" disabled="disabled"></textarea>
                    </td>
                </tr>
                
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Shipping_Agent%></td>
                    <td style="text-align: left;" colspan="3">
                        <textarea id="TB_TW_Shipping_Agent" style="width: 100%; height: 150px;" disabled="disabled"></textarea>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Shipping_Schedule%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_TW_Shipping_Schedule" disabled="disabled" style="width: 100%; " />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Shipping_Notes%></td>
                    <td style="text-align: left;" colspan="3">
                        <textarea id="TB_TW_Shipping_Notes" style="width: 100%; height: 150px;" disabled="disabled"></textarea>
                    </td>
                </tr>
            </table>
        </div>

        <div id="Div_HK_Customs_Clearance" class="Div_D" style="display:none;overflow:auto;">
            <table style="font-size: 15px;">
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Customer_Short_Name%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_HK_C_NO" disabled="disabled" style="width: 100%; " />
                    </td>
                    <td style="width: 10%;"></td>
                    <td style="width: 15%;"></td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Air_Shipping_Agent%></td>
                    <td style="text-align: left;" colspan="3">
                        <textarea id="TB_HK_Air_Shipping_Agent" style="width: 100%; height: 150px;" disabled="disabled"></textarea>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Shipping_Agent%></td>
                    <td style="text-align: left;" colspan="3">
                        <textarea id="TB_HK_Shipping_Agent" style="width: 100%; height: 150px;" disabled="disabled"></textarea>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Shipping_Schedule%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_HK_Shipping_Schedule" disabled="disabled" style="width: 100%; " />
                    </td>
                </tr>
            </table>
        </div>

        <div id="Div_Marks" class="Div_D" style="display:none;overflow:auto;">
            <table style="font-size: 15px;border-collapse:separate; border-spacing:0px 10px;">
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Customer_Short_Name%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M_C_SName" disabled="disabled" style="width: 100%; " />
                    </td>
                    <td style="width: 5%;"></td>
                    <td style="width: 15%;"></td>
                    <td style="width: 5%;"></td>
                    <td style="width: 15%;"></td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Port%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M_Port" disabled="disabled" style="width: 100%; " />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Marks%>-1</td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M_Marks1" disabled="disabled" style="width: 100%; " />
                    </td>

                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Marks%>-2</td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M_Marks2" disabled="disabled" style="width: 100%; " />
                    </td>
                    <td></td>
                    <td rowspan="3">
                        <textarea style="width: 100%; height: 150px;" disabled="disabled"></textarea>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Marks_Shape%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M_Marks_Shape" disabled="disabled" style="width: 100%; " />
                    </td>

                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Marks_Word%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M_Marks_Word" disabled="disabled" style="width: 100%; " />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Special_Document%></td>
                    <td style="text-align: left;" colspan="3">
                        <textarea id="TB_M_Special_Document" style="width: 100%; height: 150px;" disabled="disabled"></textarea>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Express_Delivery_Account%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M_Express_Delivery_Account" disabled="disabled" style="width: 100%; " />
                    </td>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.EIN%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M_EIN" disabled="disabled" style="width: 100%; " />
                    </td>
                </tr>
            </table>
        </div>

        <div id="Div_Remark" class="Div_D" style="display:none;overflow:auto;">
            <table style="font-size: 15px;border-collapse:separate;border-spacing:0px 20px;">
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Customer_Short_Name%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_R_C_NO" disabled="disabled" style="width: 100%; " />
                    </td>
                    <td style="width: 10%;"></td>
                    <td style="width: 15%;"></td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Remark%></td>
                    <td style="text-align: left;" colspan="3">
                        <textarea id="TB_R_Remark" style="width: 100%; height: 500px;" disabled="disabled"></textarea>
                    </td>
                </tr>
            </table>
        </div>
        
        <div id="Div_Title" class="Div_D" style="display:none;overflow:auto;">
            Title_Test
        </div>
    </div>

    <br />
    <br />


</asp:Content>

