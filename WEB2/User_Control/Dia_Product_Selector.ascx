<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Dia_Product_Selector.ascx.cs" Inherits="User_Control_Dia_Product_Selector" %>

<script type="text/javascript">
    $(document).ready(function () {
        $("#Search_Product_Dialog").dialog({
            autoOpen: false,
            modal: true,
            title: "<%=Resources.MP.Search_Confition%>",
            width: screen.width * 0.8,
            overlay: 0.5,
            position: { my: "center", at: "top" },
            focus: true,
            buttons: {
                "Cancel": function () {
                    $("#Search_Product_Dialog").dialog('close');
                    $('#SPD_Div_DT').toggle(false);
                }
            }
        });

        $('#SPD_BT_Search').on('click', function () {
            $('#SPD_Div_DT').css('display', '');
            $.ajax({
                url: "/Web_Service/Dialog_DataBind.asmx/Product_Search",
                data: {
                    "IM": $('#SPD_TB_IM').val(),
                    "SaleM": $('#SPD_TB_SaleM').val(),
                    "S_No": $('#SPD_TB_S_No').val()
                },
                cache: false,
                type: "POST",
                datatype: "json",
                contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                success: function (R) {
                    $('#SPD_Table_Product').DataTable({
                        "data": R,
                        "destroy": true,
                        "order": [[2, "desc"]],
                        "lengthMenu": [
                            [5, 10, 20, -1],
                            [5, 10, 20, "All"],
                        ],
                        "columns": [
                            {
                                data: null, title: "", orderable: false,
                                render: function (data, type, row) {
                                    return '<input type="button" class="PROD_SEL" value="' + '<%=Resources.MP.Select%>' + '" />'
                                }
                            },
                            { data: "序號", title: "<%=Resources.MP.SUPLU_SEQ%>" },
                            { data: "開發中", title: "<%=Resources.MP.Developing%>" },
                            { data: "頤坊型號", title: "<%=Resources.MP.Ivan_Model%>" },
                            { data: "廠商編號", title: "<%=Resources.MP.Supplier_No%>" },
                            { data: "廠商簡稱", title: "<%=Resources.MP.Supplier_Short_Name%>" },
                            { data: "單位", title: "<%=Resources.MP.Unit%>" },
                            { data: "產品說明", title: "<%=Resources.MP.Product_Information%>" },
                            { data: "暫時型號", title: "<%=Resources.MP.Sample_Product_No%>" },
                            { data: "廠商型號", title: "<%=Resources.MP.Supplier_Model%>" },
                            { data: "銷售型號", title: "<%=Resources.MP.Sale_Model%>" },
                            { data: "英文ISP", title: "英文ISP" }
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

        });
    });
</script>
<style>
    .PROD_SEL {
        color: white;
        border-radius: 4px;
        border: 5px blue none;
        text-shadow: 0 1px 1px rgba(0, 0, 0, 0.2);
        background: rgb(28, 184, 65);
    }
        .PROD_SEL:hover {
            opacity: 0.8;
        }
</style>

<div id="Search_Product_Dialog" style="display: none;">
    <table border="0" style="margin: 0 auto;" id="SPD_Table">
        <tr style="text-align: right;">
            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Ivan_Model%></td>
            <td style="text-align: left; width: 15%;">
                <input style="width: 90%; height: 25px;" id="SPD_TB_IM" />
            </td>
            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Sale_Model%></td>
            <td style="text-align: left; width: 15%;">
                <input style="width: 90%; height: 25px;" id="SPD_TB_SaleM" />
            </td>
            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Supplier_No%></td>
            <td style="text-align: left; width: 15%;">
                <input style="width: 90%; height: 25px;" id="SPD_TB_S_No" />
            </td>
        </tr>
        <tr>
            <td>
                <br />
            </td>
        </tr>
        <tr>
            <td style="text-align: center;" colspan="4">
                <div style="display: flex; justify-content: center; align-items: center;">
                    <input id="SPD_BT_Search" class="BTN" type="button" value="<%=Resources.MP.Search%>" style="width: 10%;" />
                </div>
            </td>
        </tr>
    </table>
    <div id="SPD_Div_DT" style="margin: auto; width: 98%; overflow: auto; display: none;height:50vh;">
        <br />
        <table id="SPD_Table_Product" style="width: 100%;" class="table table-striped table-bordered dt-responsive">
            <thead></thead>
            <tbody></tbody>
        </table>
    </div>
</div>
