<%@ Page Title="BOM Maintenance" Language="C#" MasterPageFile="~/MP.master" AutoEventWireup="true" CodeFile="Model_Search.aspx.cs" Inherits="Base_Model_Search" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <link href="/css/dataTables.bootstrap4.min.css" rel="stylesheet" />
    <script src="/js/jquery.dataTables.min.js"></script>
    <script src="/js/dataTables.bootstrap4.min.js"></script>


    <script type="text/javascript">
        $(document).ready(function () {
            document.body.style.overflow = 'hidden';

            function Search_Product() {

                //$('#Table_Product').DataTable().fnDestroy();
                $('#Div_Basic').html('<table id="Table_Product" style="width: 100%" class="table table-striped table-bordered"><thead></thead><tbody></tbody></table>');

                switch ($('#DDL_Data_Souce').val()) {
                    case "Cost":
                        $.ajax({
                            url: "/Base/Base_Search.ashx",
                            data: {
                                "Call_Type": "Base_C_Search"
                            },
                            cache: false,
                            type: "POST",
                            datatype: "json",
                            contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                            success: function (response) {
                                $('#Table_Product').DataTable({
                                    "data": response,
                                    "destroy": true,
                                    "processing": true,
                                    "order": [[1, "asc"]],
                                    "lengthMenu": [
                                        [-1, 5, 10, 20],
                                        ["All", 5, 10, 20],
                                    ],
                                    "columns": [
                                        { data: "S_SName", title: "<%=Resources.Cost.Supplier_Short_Name%>" },
                                        { data: "IM", title: "<%=Resources.Cost.Ivan_Model%>" },
                                        { data: "CPI", title: "<%=Resources.Cost.Product_Information%>" },
                                        { data: "Unit", title: "<%=Resources.Cost.Unit%>" },
                                        { data: "SupM", title: "<%=Resources.Cost.Supplier_Model%>" },
                                        { data: "SaleM", title: "<%=Resources.Cost.Sale_Model%>" },
                                        { data: "SampleM", title: "<%=Resources.Cost.Sample_Product_No%>" },
                                        { data: "PS", title: "<%=Resources.Cost.Product_Status%>" },
                                        { data: "PC1", title: "<%=Resources.MP.Product_Class%>1" },
                                        { data: "PC2", title: "<%=Resources.MP.Product_Class%>2" },
                                        { data: "PC3", title: "<%=Resources.MP.Product_Class%>3" },
                                        { data: "IN", title: "<%=Resources.MP.International_No%>" },
                                        { data: "S_No", title: "<%=Resources.Supplier.Supplier_NO%>" },
                                        { data: "SD", title: "<%=Resources.Cost.Stop_Date%>" },
                                        { data: "DVN", title: "<%=Resources.Cost.Developing%>" },
                                        { data: "SEQ", title: "<%=Resources.Cost.SEQ%>" },
                                        { data: "Update_User", title: "<%=Resources.Cost.Update_User%>" },
                                        { data: "Update_Date", title: "<%=Resources.Cost.Update_Date%>" },
                                    ],
                                    "language": {
                                        "lengthMenu": "&nbsp;Show _MENU_ entries"
                                    },
                                });
                            },
                            error: function (ex) {
                                alert(ex);
                            }
                        });
                        break;
                    case "Price":
                        $.ajax({
                            url: "/Base/Base_Search.ashx",
                            data: {
                                "Call_Type": "Base_P_Search"
                            },
                            cache: false,
                            type: "POST",
                            datatype: "json",
                            contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                            success: function (response) {
                                $('#Table_Product').DataTable({
                                    "data": response,
                                    "destroy": true,
                                    "processing": true,
                                    "order": [[1, "asc"]],
                                    "lengthMenu": [
                                        [-1, 5, 10, 20],
                                        ["All", 5, 10, 20],
                                    ],
                                    "columns": [
                                        { data: "C_SName", title: "<%=Resources.Price.Customer_Short_Name%>" },
                                        { data: "IM", title: "<%=Resources.Cost.Ivan_Model%>" },
                                        { data: "PPI", title: "<%=Resources.Price.Price_Information%>" },
                                        { data: "Unit", title: "<%=Resources.Price.Unit%>" },
                                        { data: "CM", title: "<%=Resources.Price.Customer_Model%>" },
                                        { data: "S_SName", title: "<%=Resources.Cost.Supplier_Short_Name%>" },
                                        { data: "S_No", title: "<%=Resources.Cost.Supplier_No%>" },
                                        { data: "PS", title: "<%=Resources.Cost.Product_Status%>" },
                                        { data: "PC1", title: "<%=Resources.MP.Product_Class%>1" },
                                        { data: "PC2", title: "<%=Resources.MP.Product_Class%>2" },
                                        { data: "PC3", title: "<%=Resources.MP.Product_Class%>3" },
                                        { data: "IN", title: "<%=Resources.MP.International_No%>" },
                                        { data: "SD", title: "<%=Resources.Cost.Stop_Date%>" },
                                        { data: "C_No", title: "<%=Resources.Price.Customer_No%>" },
                                        { data: "Marks", title: "<%=Resources.Customer.Marks%>" },
                                        { data: "DVN", title: "<%=Resources.Cost.Developing%>" },
                                        { data: "SEQ", title: "<%=Resources.Cost.SEQ%>" },
                                        { data: "Update_User", title: "<%=Resources.Cost.Update_User%>" },
                                        { data: "Update_Date", title: "<%=Resources.Cost.Update_Date%>" },
                                        { data: "Cost_SEQ", title: "<%=Resources.Cost.SEQ%>" },
                                    ],
                                    "language": {
                                        "lengthMenu": "&nbsp;Show _MENU_ entries"
                                    },
                                });
                            },
                            error: function (ex) {
                                alert(ex);
                            }
                        });
                        break;
                }

                $('#Table_Product').attr('style', 'white-space:nowrap;');
                $('#Table_Product thead th').attr('style', 'text-align:center;');
            };

            $('#BT_Search').on('click', function () {
                Search_Product();
            });

            $('#Table_Product').on('click', 'tbody tr', function () {
                $(this).parent().find('tr').css('background-color', '');
                $(this).parent().find('tr').css('color', 'black');
                $(this).css('background-color', '#5a1400');
                $(this).css('color', 'white');

                var C_No = $(this).find('td:nth-child(1)').text().toString().trim();

                $.ajax({
                    url: "/Customer/Customer_Search.ashx",
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
                    },
                    error: function (ex) {
                        alert(ex);
                    }
                });
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
                    Search_Product();
                },
            });
            $('#DDL_Data_Souce').on('change', function () {
                switch ($(this).val()) {
                    case "Cost":
                        $('.Cost').css('display', '');
                        $('.Price').css('display', 'none');
                        break;
                    case "Price":
                        $('.Cost').css('display', 'none');
                        $('.Price').css('display', '');
                        break;
                }
            });
        });
    </script>

    <table class="table_th" style="width:98%">
        <tr>
            <td style="height: 10px; font-size: smaller;" colspan="8">&nbsp</td>
        </tr>
        <tr>
            <td rowspan="3" style="width:5%">
                <span>Data Source</span>
                <br />
                <select id="DDL_Data_Souce" style="width:100%;">
                    <option selected="selected">Cost</option>
                    <option>Price</option>
                </select>
            </td>
            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Ivan_Model%></td>
            <td style="text-align: left; width: 15%;">
                <input id="TB_IM" style="width:100%;" />
            </td>
            <td style="text-align: right; text-wrap: none; width: 10%;" class="Cost"><%=Resources.Cost.Sample_Product_No%></td>
            <td style="text-align: left; width: 15%;" class="Cost">
                <input id="TB_Sample_Model" style="width:100%;" />
            </td>
            <td style="display:none;" class="Price"></td>
            <td style="display:none;" class="Price"></td>
            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Product_Class%></td>
            <td style="text-align: left; width: 15%;">
                <select id="DDL_PC" style="width:100%;"></select>
            </td>

            <td rowspan="3" style="text-align: center;">
                <div style="display: flex; justify-content: center; align-items: center;">
                    <input id="BT_Search" class="BTN" type="button" value="<%=Resources.MP.Search%>" />
                </div>
            </td>
        </tr>
        <tr>
            <td style="text-align: right; text-wrap: none; width: 10%;" class="Cost"><%=Resources.Supplier.Supplier_NO%></td>
            <td style="text-align: left; width: 15%;" class="Cost">
                <input id="TB_S_No" placeholder="<%=Resources.MP.S_No_ATC_Hint%>" style="width: 100%;" />
            </td>
            <td style="text-align: right; text-wrap: none; width: 10%;" class="Cost"><%=Resources.Supplier.Supplier_Short_Name%></td>
            <td style="text-align: left; width: 15%;" class="Cost">
                <input id="TB_S_SName" style="width: 100%;" disabled="disabled" />
            </td>

            <td style="text-align: right; text-wrap: none; width: 10%;display:none;" class="Price"><%=Resources.Customer.Customer_No%></td>
            <td style="text-align: left; width: 15%;display:none;" class="Price">
                <input id="TB_Search_C_No" name="TB_Search_C_No" placeholder="<%=Resources.MP.C_No_ATC_Hint%>" style="width: 100%;" />
            </td>
            <td style="text-align: right; text-wrap: none; width: 10%;display:none;" class="Price"><%=Resources.Customer.Customer_Short_Name%></td>
            <td style="text-align: left; width: 15%;display:none;" class="Price">
                <input id="TB_Search_C_SName" style="width: 100%;" disabled="disabled" />
            </td>
            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.International_No%></td>
            <td style="text-align: left; width: 15%;">
                <input id="TB_I_No" style="width: 100%;" />
            </td>
        </tr>
        <tr>
            <td style="text-align: right; text-wrap: none; width: 10%;" class="Cost"><%=Resources.Cost.Supplier_Model%></td>
            <td style="text-align: left; width: 15%;" class="Cost">
                <input id="TB_SM" style="width: 100%;" class="Cost" />
            </td>
            <td style="text-align: right; text-wrap: none; width: 10%;" class="Cost"><%=Resources.Cost.Product_Information%></td>
            <td style="text-align: left; width: 15%;" class="Cost">
                <input id="TB_CPI" style="width: 100%;" class="Cost" />
            </td>

            <td style="text-align: right; text-wrap: none; width: 10%;display:none;" class="Price"><%=Resources.Price.Customer_Model%></td>
            <td style="text-align: left; width: 15%;display:none;" class="Price">
                <input id="TB_CM" style="width: 100%;display:none;" class="Price" />
            </td>
            <td style="text-align: right; text-wrap: none; width: 10%;display:none;" class="Price"><%=Resources.Price.Price_Information%></td>
            <td style="text-align: left; width: 15%;display:none;" class="Price">
                <input id="TB_PPI" style="width: 100%;display:none;" class="Price" />
            </td>
            
            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Sale_Model%></td>
            <td style="text-align: left; width: 15%;">
                <input id="TB_SaleM" style="width: 100%;" />
            </td>
        </tr>
        <tr>
            <td style="height: 10px; font-size: smaller;" colspan="8">&nbsp</td>
        </tr>
    </table>

    <div style="width: 99%; margin: 0 auto; background-color: white;">
        &nbsp;
        <input type="button" class="V_BT" value="<%=Resources.Customer.Basic%>" onclick="$('.Div_D').css('display','none');$('#Div_Basic2').css('display','');" disabled="disabled" />
        <input type="button" class="V_BT" value="<%=Resources.Cost.Image%>" onclick="$('.Div_D').css('display','none');$('#Div_Remark').css('display','');" />
        <%--<input type="button" class="V_BT" value="Title" onclick="$('.Div_D').css('display','none');$('#Div_Title').css('display','');" />--%>
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

        #Table_Product tbody tr:hover {
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
        <div id="Div_Basic" style="float:left;overflow:auto;width:100%;height:70vh;">
            <table id="Table_Product" style="width: 100%" class="table table-striped table-bordered">
                <thead></thead>
                <tbody></tbody>
            </table>
        </div>
        
        <div id="Div_Basic2" class="Div_D" style="height:70vh;display:none;">
            <table style="font-size: 15px;border-collapse:separate; border-spacing:0px 8px;">
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Customer.Customer_No%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_B2_C_No" disabled="disabled" style="width: 100%;" />
                    </td>
                    <td style="text-align: right; text-wrap: none; width: 10%;"></td>
                    <td style="text-align: left; width: 15%;">
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Customer.Customer_Short_Name%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_B2_C_SName" disabled="disabled" style="width: 100%;" />
                    </td>

                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Customer.Tel%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_B2_C_Tel" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Customer.Customer_Name%></td>
                    <td style="text-align: left; width: 40%;" colspan="3">
                        <input id="TB_B2_C_Name" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Customer.Nation%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_B2_C_Nation" disabled="disabled" style="width: 100%;" />
                    </td>

                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Customer.Principal%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_B2_Principal" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Customer.Person_Commodity%></td>
                    <td style="text-align: left; width: 40%;" colspan="3">
                        <input id="TB_B2_Person_Commodity" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Customer.Person_Sample%></td>
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
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Customer.Web%></td>
                    <td style="text-align: left; width: 40%;" colspan="3">
                        <input id="TB_B2_Web" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Customer.Costomer_Source%></td>
                    <td style="text-align: left; width: 40%;" colspan="3">
                        <input id="TB_B2_Costomer_Source" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Customer.Mail_Group%></td>
                    <td style="text-align: left; width: 40%;" colspan="3">
                        <input id="TB_B2_Mail_Group" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Customer.Company_Address%></td>
                    <td colspan="3" style="text-align: left; width: 15%;">
                        <textarea id="TB_B2_Company_Address" style="width: 100%;" disabled="disabled"></textarea>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Customer.Factory_Address%></td>
                    <td colspan="3" style="text-align: left; width: 15%;">
                        <textarea id="TB_B2_Factory_Address" style="width: 100%;" disabled="disabled"></textarea>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Customer.Delivery_Address%></td>
                    <td colspan="3" style="text-align: left; width: 15%;">
                        <textarea id="TB_B2_Delivery_Address" style="width: 100%;" disabled="disabled"></textarea>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Customer.Update_User%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_B2_Update_User" disabled="disabled" style="width: 100%;" />
                    </td>

                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Supplier.Update_Date%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_B2_Update_Date" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
            </table>
        </div>

        <div id="Div_Image" class="Div_D" style="display:none;overflow:auto;">
            <table style="font-size: 15px;border-collapse:separate;border-spacing:0px 20px;">
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Customer.Customer_Short_Name%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_R_C_NO" disabled="disabled" style="width: 100%; " />
                    </td>
                    <td style="width: 10%;"></td>
                    <td style="width: 15%;"></td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Customer.Remark%></td>
                    <td style="text-align: left;" colspan="3">
                        <textarea id="TB_R_Remark" style="width: 100%; height: 500px;" disabled="disabled"></textarea>
                    </td>
                </tr>
            </table>
        </div>
        
        <%--<div id="Div_Title" class="Div_D" style="display:none;overflow:auto;">
            Title_Test
        </div>--%>
    </div>

    <br />
    <br />


</asp:Content>

