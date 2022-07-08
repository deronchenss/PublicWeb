<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Dia_Customer_Selector.ascx.cs" Inherits="User_Control_Dia_Customer_Selector" %>

<script type="text/javascript">
    $(document).ready(function () {
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

        $('#SCD_BT_Search').on('click', function () {
            $('#SCD_Div_DT').css('display', '');
            $.ajax({
                url: "/Base/Customer/Customer_Search.ashx",
                data: {
                    "Call_Type": "Customer_Search",
                    "C_No": $('#SCD_TB_C_No').val(),
                    "C_SName": $('#SCD_TB_C_SName').val(),
                },
                cache: false,
                type: "POST",
                datatype: "json",
                contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                success: function (response) {
                    $('#SCD_Table_Customer').DataTable({
                        "data": response,
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
                                    return '<input type="button" class="CUST_SEL" value="' + '<%=Resources.MP.Select%>' + '">'
                                    }
                                },
                                { data: "SEQ", title: "<%=Resources.MP.SEQ%>" },
                                { data: "C_No", title: "<%=Resources.MP.Customer_No%>" },
                                { data: "C_SName", title: "<%=Resources.MP.Customer_Short_Name%>" },
                                { data: "C_Name", title: "<%=Resources.MP.Customer_Name%>" },
                                { data: "Principal", title: "<%=Resources.MP.Principal%>" },
                                { data: "Mail", title: "Mail" },
                                { data: "Remark", title: "<%=Resources.MP.Remark%>" }
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
         });
    });
</script>
<style>
    .CUST_SEL {
        color: white;
        border-radius: 4px;
        border: 5px blue none;
        text-shadow: 0 1px 1px rgba(0, 0, 0, 0.2);
        background: rgb(28, 184, 65);
    }
        .CUST_SEL:hover {
            opacity: 0.8;
        }
</style>

<div id="Search_Customer_Dialog" style="display: none;">
        <table border="0" style="margin: 0 auto;" id="SCD_Table">
            <tr style="text-align: right;">
                <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Customer_No%></td>
                <td style="text-align: left; width: 15%;">
                    <input style="width: 90%; height: 25px;" id="SCD_TB_C_No" />
                </td>
                <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Customer_Short_Name%></td>
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