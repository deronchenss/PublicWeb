<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Dia_Supplier_Selector.ascx.cs" Inherits="User_Control_Dia_Supplier_Selector" %>

<script type="text/javascript">
    $(document).ready(function () {
        $("#Search_Supplier_Dialog").dialog({
            autoOpen: false,
            modal: true,
            title: "<%=Resources.MP.Search_Confition%>",
            width: screen.width * 0.8,
            overlay: 0.5,
            focus: true,
            buttons: {
                "Cancel": function () {
                    $("#Search_Supplier_Dialog").dialog('close');
                    $('#SSD_Div_DT').css('display', 'none');
                }
            }
        });
        $('#SSD_BT_Search').on('click', function () {
            $('#SSD_Div_DT').css('display', '');

            $.ajax({
                //url: "/User_Control/UC_Search.ashx",
                url: "/Web_Service/Dialog_DataBind.asmx/Supplier_Search",
                data: {
                    "S_No": $('#SSD_TB_S_No').val(),
                    "S_SName": $('#SSD_TB_S_SName').val(),
                },
                cache: false,
                type: "POST",
                datatype: "json",
                contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                //contentType: "application/json; charset=utf-8",
                //success: function (response) {
                success: function (response) {
                    //console.warn(JSON.parse(response));
                    $('#SSD_Table_Supplier').DataTable({
                        "data": JSON.parse(response),
                        "destroy": true,
                        "order": [[2, "asc"]],
                        "lengthMenu": [
                            [5, 10, 20, -1],
                            [5, 10, 20, "All"],
                        ],
                        "columns": [
                            {
                                data: null, title: "",
                                render: function (data, type, row) {
                                    return '<input type="button" class="SUP_SEL" value="' + '<%=Resources.MP.Select%>' + '" />'
                                }
                            },
                            { data: "SEQ", title: "<%=Resources.MP.SUPLU_SEQ%>" },
                            <%--{ data: "DVN", title: "<%=Resources.MP.Developing%>" },--%>
                            { data: "S_No", title: "<%=Resources.MP.Supplier_No%>" },
                            { data: "S_SName", title: "<%=Resources.MP.Supplier_Short_Name%>" },
                            { data: "Purchase_Person", title: "<%=Resources.MP.Purchase_Person%>" },
                            { data: "TEL", title: "<%=Resources.MP.Tel%>" },
                            { data: "Address", title: "<%=Resources.MP.Company_Address%>" }
                        ],
                        "columnDefs": [{
                            targets: [0],
                            className: "text-center"
                        }],
                    });

                    $('#SSD_Table_Supplier').css('white-space', 'nowrap');
                    $('#SSD_Table_Supplier thead th').css('text-align', 'center');
                },
                error: function (ex) {
                    alert(ex);
                }
            });
        });
    });
</script>
<style>
    .SUP_SEL {
        color: white;
        border-radius: 4px;
        border: 5px blue none;
        text-shadow: 0 1px 1px rgba(0, 0, 0, 0.2);
        background: rgb(28, 184, 65);
    }
        .SUP_SEL:hover {
            opacity: 0.8;
        }
</style>

<div id="Search_Supplier_Dialog" style="display: none;">
    <table border="0" style="margin: 0 auto;" id="SSD_Table">
        <tr style="text-align: right;">
            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Supplier_No%></td>
            <td style="text-align: left; width: 15%;">
                <input style="width: 90%; height: 25px;" id="SSD_TB_S_No" />
            </td>
            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Supplier_Short_Name%></td>
            <td style="text-align: left; width: 15%;">
                <input style="width: 90%; height: 25px;" id="SSD_TB_S_SName" />
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
                    <input id="SSD_BT_Search" class="BTN" type="button" value="<%=Resources.MP.Search%>" style="width: 10%;" />
                </div>
            </td>
        </tr>
    </table>
    <div id="SSD_Div_DT" style="margin: auto; width: 98%; overflow: auto; display: none;">
        <br />
        <table id="SSD_Table_Supplier" style="width: 100%;" class="table table-striped table-bordered dt-responsive">
            <thead></thead>
            <tbody></tbody>
        </table>
    </div>
</div>
