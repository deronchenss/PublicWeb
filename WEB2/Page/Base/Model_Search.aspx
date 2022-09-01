<%@ Page Title="Model Search" Language="C#" MasterPageFile="~/MP.master" AutoEventWireup="true" CodeFile="Model_Search.aspx.cs" Inherits="Base_Model_Search" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <link href="/css/dataTables.bootstrap4.min.css" rel="stylesheet" />
    <script src="/js/jquery.dataTables.min.js"></script>
    <script src="/js/dataTables.bootstrap4.min.js"></script>

    
    <script type="text/javascript">
        $(document).ready(function () {
            var Click_tr_IDX;
            document.body.style.overflow = 'hidden';
            Search_Product();

            $('#BT_Search').on('click', function () {
                Search_Product();
            });

            function Search_Product() {
                Click_tr_IDX = null;
                $('#Div_Basic').html('<table id="Table_Product" style="width: 100%" class="table table-striped table-bordered"><thead></thead><tbody></tbody></table>');

                switch ($('#DDL_Data_Souce').val()) {
                    case "Cost":
                        $.ajax({
                            url: "/Page/Base/Base_Search.ashx",
                            data: {
                                "IM": $('#TB_IM').val(),
                                "SampleM": $('#TB_Sample_Model').val(),
                                "PC": $('#DDL_PC').val(),
                                "S_No": $('#TB_S_No').val(),
                                "IN": $('#TB_I_No').val(),
                                "SupM": $('#TB_SM').val(),
                                "SaleM": $('#TB_SaleM').val(),
                                "CPI": $('#TB_CPI').val(),
                                "Call_Type": "Base_C_Search"
                            },
                            cache: false,
                            type: "POST",
                            datatype: "json",
                            contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                            success: function (response) {
                                $('#Table_Product').DataTable({
                                    "scrollX": true,
                                    "scrollY": "60vh",
                                    "data": response,
                                    "destroy": true,
                                    "processing": true,
                                    "order": [[1, "asc"]],
                                    "lengthMenu": [
                                        [-1, 5, 10, 20],
                                        ["All", 5, 10, 20],
                                    ],
                                    "columns": [
                                        { data: "S_SName", title: "<%=Resources.MP.Supplier_Short_Name%>" },
                                        { data: "IM", title: "<%=Resources.MP.Ivan_Model%>" },
                                        { data: "CPI", title: "<%=Resources.MP.Product_Information%>" },
                                        { data: "Unit", title: "<%=Resources.MP.Unit%>" },
                                        { data: "SupM", title: "<%=Resources.MP.Supplier_Model%>" },
                                        { data: "SaleM", title: "<%=Resources.MP.Sale_Model%>" },
                                        { data: "SampleM", title: "<%=Resources.MP.Sample_Product_No%>" },
                                        { data: "PS", title: "<%=Resources.MP.Product_Status%>" },
                                        { data: "PC1", title: "<%=Resources.MP.Product_Class%>1" },
                                        { data: "PC2", title: "<%=Resources.MP.Product_Class%>2" },
                                        { data: "PC3", title: "<%=Resources.MP.Product_Class%>3" },
                                        { data: "IN", title: "<%=Resources.MP.International_No%>" },
                                        { data: "S_No", title: "<%=Resources.MP.Supplier_No%>" },
                                        { data: "SD", title: "<%=Resources.MP.Stop_Date%>" },
                                        { data: "DVN", title: "<%=Resources.MP.Developing%>" },
                                        <%--{ data: "SEQ", title: "<%=Resources.MP.SEQ%>" },--%>
                                        {
                                            data: "SEQ", title: "<%=Resources.MP.SUPLU_SEQ%>",
                                            render: function (data, type, row) {
                                                return '<span class="SUPLU_SEQ">' + data + '</span>';
                                            }
                                        },
                                        { data: "Update_User", title: "<%=Resources.MP.Update_User%>" },
                                        { data: "Update_Date", title: "<%=Resources.MP.Update_Date%>" },
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
                            url: "/Page/Base/Base_Search.ashx",
                            data: {
                                "IM": $('#TB_IM').val(),
                                "PC": $('#DDL_PC').val(),
                                "C_No": $('#TB_C_No').val(),
                                "IN": $('#TB_I_No').val(),
                                "CM": $('#TB_CM').val(),
                                "SaleM": $('#TB_SaleM').val(),
                                "PPI": $('#TB_PPI').val(),
                                "Call_Type": "Base_P_Search"
                            },
                            cache: false,
                            type: "POST",
                            datatype: "json",
                            contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                            success: function (response) {
                                $('#Table_Product').DataTable({
                                    "data": response,
                                    "scrollX": true,
                                    "scrollY": "60vh",
                                    "destroy": true,
                                    "processing": true,
                                    "order": [[1, "asc"]],
                                    "lengthMenu": [
                                        [-1, 5, 10, 20],
                                        ["All", 5, 10, 20],
                                    ],
                                    "columns": [
                                        { data: "C_SName", title: "<%=Resources.MP.Customer_Short_Name%>" },
                                        { data: "IM", title: "<%=Resources.MP.Ivan_Model%>" },
                                        { data: "PPI", title: "<%=Resources.MP.Price_Information%>" },
                                        { data: "Unit", title: "<%=Resources.MP.Unit%>" },
                                        { data: "CM", title: "<%=Resources.MP.Customer_Model%>" },
                                        { data: "S_SName", title: "<%=Resources.MP.Supplier_Short_Name%>" },
                                        { data: "S_No", title: "<%=Resources.MP.Supplier_No%>" },
                                        { data: "PS", title: "<%=Resources.MP.Product_Status%>" },
                                        { data: "PC1", title: "<%=Resources.MP.Product_Class%>1" },
                                        { data: "PC2", title: "<%=Resources.MP.Product_Class%>2" },
                                        { data: "PC3", title: "<%=Resources.MP.Product_Class%>3" },
                                        { data: "IN", title: "<%=Resources.MP.International_No%>" },
                                        { data: "SD", title: "<%=Resources.MP.Stop_Date%>" },
                                        { data: "C_No", title: "<%=Resources.MP.Customer_No%>" },
                                        { data: "Marks", title: "<%=Resources.MP.Marks%>" },
                                        { data: "DVN", title: "<%=Resources.MP.Developing%>" },
                                        { data: "SEQ", title: "<%=Resources.MP.SEQ%>" },
                                        { data: "Update_User", title: "<%=Resources.MP.Update_User%>" },
                                        { data: "Update_Date", title: "<%=Resources.MP.Update_Date%>" },
                                        <%--{ data: "SUPLU_SEQ", title: "<%=Resources.MP.SUPLU_SEQ%>" },--%>
                                        {
                                            data: "SUPLU_SEQ", title: "<%=Resources.MP.SUPLU_SEQ%>",
                                            render: function (data, type, row) {
                                                return '<span class="SUPLU_SEQ">' + data + '</span>';
                                            }
                                        },
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

                $('#Table_Product').css('white-space', 'nowrap');
                $('#Table_Product thead th').css('text-align', 'center');

                //$('#Table_Product thead th').css('background-color', 'white');
                //$('#Table_Product thead th').css('position', 'sticky');
                //$('#Table_Product thead th').css('top', '0');

                $('#Table_Product').on('click', 'tbody tr', function () {
                    Click_tr_IDX = $(this).index();
                    FN_Tr_Click($(this));
                    //console.warn($(this));
                });
            };

            $(window).keydown(function (e) {
                if (Click_tr_IDX != null) {
                    switch (e.keyCode) {
                        case 38://^
                            if (Click_tr_IDX > 0) {
                                Click_tr_IDX -= 1;
                            }
                            FN_Tr_Click($('#Table_Product tbody tr:nth(' + Click_tr_IDX + ')'));
                            break;
                        case 40://v
                            if (Click_tr_IDX < ($('#Table_Product tbody tr').length - 1)) {
                                Click_tr_IDX += 1;
                            }
                            FN_Tr_Click($('#Table_Product tbody tr:nth(' + Click_tr_IDX + ')'));
                            break;
                    }
                }
            });

            function FN_Tr_Click(Click_tr) {
                Click_tr.parent().find('tr').css('background-color', '');
                Click_tr.parent().find('tr').css('color', 'black');
                Click_tr.css('background-color', '#5a1400');
                Click_tr.css('color', 'white');

                var SEQ = Click_tr.find('.SUPLU_SEQ').text().toString().trim();

                $('.M2_For_U').css('display', '');
                $('#Div_Detail_Form input, #Div_Detail_Form textarea, #Div_Detail_Form select').attr('disabled', 'disabled');
                $('#BT_ED_Edit, #BT_ED_Copy').css('display', '');
                $('#BT_ED_Save, #BT_ED_Cancel').css('display', 'none');

                $.ajax({
                    url: "/Page/Base/BOM/BOM_Search.ashx",
                    data: {
                        "SUPLU_SEQ": SEQ,
                        "Call_Type": "GET_IMG"
                    },
                    cache: false,
                    type: "POST",
                    datatype: "json",
                    contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                    success: function (response) {
                        var IMG_View = !(response[0] == null);
                        $('#IMG_I_IMG').toggle(IMG_View);
                        $('#IMG_I_IMG_Hint').toggle(!IMG_View);
                        if (IMG_View) {
                            var binary = '';
                            var bytes = new Uint8Array(response[0].P_IMG);
                            var len = bytes.byteLength;
                            for (var i = 0; i < len; i++) {
                                binary += String.fromCharCode(bytes[i]);
                            }
                            $('#IMG_I_IMG').attr('src', 'data:image/png;base64,' + window.btoa(binary));
                        }
                    },
                    error: function (ex) {
                        alert(ex);
                    }
                });
            }

            $('#TB_S_No').autocomplete({
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
                            var Json_Response = JSON.parse(data.d);
                            response($.map(Json_Response, function (item) { return { label: item.S_No + " - " + item.S_Name, value: item.S_No, name: item.S_Name } }));
                        },
                        error: function (response) {
                            alert(response.responseText);
                        },
                    });
                },
                select: function (event, ui) {
                    $('#TB_S_No').val(ui.item.value);
                    $('#TB_S_SName').val(ui.item.name)
                },
            });

            $('#TB_C_No').on('change', function () {
                if ($.trim($(this).val()) == "") {
                    $('#TB_C_SName').val('');
                }
            });

            $('#TB_C_No').autocomplete({
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
                    $('#TB_C_No').val(ui.item.value);
                    $('#TB_C_SName').val(ui.item.name);
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
            //DDL
            $.ajax({
                url: "/Web_Service/DDL_DataBind.asmx/Product_Class",
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
                    $('#DDL_PC').html(DDL_Option);
                },
                error: function (response) {
                    alert(response.responseText);
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

        #Table_Product tbody tr:hover {
            background-color: #f8981d;
            color: white;
        }
        
        table thead tr th {
            background-color:white;
            position: sticky;
            top: 0; /* 列首永遠固定於上 */
        }
    </style>

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
            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Ivan_Model%></td>
            <td style="text-align: left; width: 15%;">
                <input id="TB_IM" style="width:100%;" />
            </td>
            <td style="text-align: right; text-wrap: none; width: 10%;" class="Cost"><%=Resources.MP.Sample_Product_No%></td>
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
            <td style="text-align: right; text-wrap: none; width: 10%;" class="Cost"><%=Resources.MP.Supplier_No%></td>
            <td style="text-align: left; width: 15%;" class="Cost">
                <input id="TB_S_No" placeholder="<%=Resources.MP.S_No_ATC_Hint%>" style="width: 100%;" />
            </td>
            <td style="text-align: right; text-wrap: none; width: 10%;" class="Cost"><%=Resources.MP.Supplier_Short_Name%></td>
            <td style="text-align: left; width: 15%;" class="Cost">
                <input id="TB_S_SName" style="width: 100%;" disabled="disabled" />
            </td>

            <td style="text-align: right; text-wrap: none; width: 10%;display:none;" class="Price"><%=Resources.MP.Customer_No%></td>
            <td style="text-align: left; width: 15%;display:none;" class="Price">
                <input id="TB_C_No" placeholder="<%=Resources.MP.C_No_ATC_Hint%>" style="width: 100%;" />
            </td>
            <td style="text-align: right; text-wrap: none; width: 10%;display:none;" class="Price"><%=Resources.MP.Customer_Short_Name%></td>
            <td style="text-align: left; width: 15%;display:none;" class="Price">
                <input id="TB_C_SName" style="width: 100%;" disabled="disabled" />
            </td>
            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.International_No%></td>
            <td style="text-align: left; width: 15%;">
                <input id="TB_I_No" style="width: 100%;" />
            </td>
        </tr>
        <tr>
            <td style="text-align: right; text-wrap: none; width: 10%;" class="Cost"><%=Resources.MP.Supplier_Model%></td>
            <td style="text-align: left; width: 15%;" class="Cost">
                <input id="TB_SM" style="width: 100%;" class="Cost" />
            </td>
            <td style="text-align: right; text-wrap: none; width: 10%;display:none;" class="Price"><%=Resources.MP.Customer_Model%></td>
            <td style="text-align: left; width: 15%;display:none;" class="Price">
                <input id="TB_CM" style="width: 100%;display:none;" class="Price" />
            </td>
            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Sale_Model%></td>
            <td style="text-align: left; width: 15%;">
                <input id="TB_SaleM" style="width: 100%;" />
            </td>
            <td style="text-align: right; text-wrap: none; width: 10%;" class="Cost"><%=Resources.MP.Product_Information%></td>
            <td style="text-align: left; width: 15%;" class="Cost">
                <input id="TB_CPI" style="width: 100%;" class="Cost" />
            </td>
            <td style="text-align: right; text-wrap: none; width: 10%;display:none;" class="Price"><%=Resources.MP.Price_Information%></td>
            <td style="text-align: left; width: 15%;display:none;" class="Price">
                <input id="TB_PPI" style="width: 100%;display:none;" class="Price" />
            </td>
        </tr>
        <tr>
            <td style="height: 10px; font-size: smaller;" colspan="8">&nbsp</td>
        </tr>
    </table>

    <div style="width: 99%; margin: 0 auto; background-color: white;">
        &nbsp;
        <input type="button" class="V_BT" value="<%=Resources.MP.Basic%>" onclick="$('.Div_D').css('display','none');$('#Div_Basic').css('width','100%');" disabled="disabled" />
        <input type="button" class="V_BT" value="<%=Resources.MP.Image%>" onclick="$('.Div_D').css('display','none');$('#Div_Image').css('display','');$('#Div_Basic').css('width','60%');$('#Div_Image').css('width','40%');" />
    </div>
    <script type="text/javascript">
        $(document).ready(function () {
            $('.V_BT').on('click', function () {
                $(this).attr('disabled', 'disabled');
                $('.V_BT').not($(this)).attr('disabled', false);
            });
        });
    </script>
    <div style="width: 98%; margin: 0 auto;">
        <div id="Div_Image" class="Div_D" style="float:left;display:none;overflow:auto;height:70vh;border-style:solid;border-width:1px;">
            <table style="font-size: 15px;border-collapse:separate;border-spacing:0px 20px;">
                <tr>
                    <td style="text-align:center; width: 15%;" colspan="8">
                        <img id="IMG_I_IMG" src="#"  />
                        <span id="IMG_I_IMG_Hint" style="display:none;"><%=Resources.MP.Image_NotExists%></span>
                    </td>
                </tr>
            </table>
        </div>
        <div id="Div_Basic" style="float:left;width:100%;height:70vh;border-style:solid;border-width:1px;">
            <table id="Table_Product" style="width: 100%" class="table table-striped table-bordered">
                <thead></thead>
                <tbody></tbody>
            </table>
        </div>
        
        <%--<div id="Div_Basic2" class="Div_D" style="height:70vh;display:none;">
        </div>--%>

        
        <%--<div id="Div_Title" class="Div_D" style="display:none;overflow:auto;">
            Title_Test
        </div>--%>
    </div>

    <br />
    <br />


</asp:Content>

