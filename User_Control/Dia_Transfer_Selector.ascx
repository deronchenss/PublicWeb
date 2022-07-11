<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Dia_Transfer_Selector.ascx.cs" Inherits="User_Control_Dia_Transfer_Selector" %>

<script type="text/javascript">
    $(document).ready(function () {
        $("#Search_Transfer_Dialog").dialog({
            autoOpen: false,
            modal: true,
            title: "<%=Resources.MP.Search_Confition%>",
            width: screen.width * 0.8,
            overlay: 0.5,
            focus: true,
            buttons: {
                "Cancel": function () {
                    $("#Search_Transfer_Dialog").dialog('close');
                    $('#SSD_Div_DT').css('display', 'none');
                }
            }
        });
        $('#SSD_BT_Search').on('click', function () {
            $('#SSD_Div_DT').css('display', '');

            $.ajax({
                url: "/Web_Service/Dialog_DataBind.asmx/Transfer_Search",
                data: {
                    "S_No": $('#SSD_Transfer_No').val(),
                    "S_Type": $('#SSD_Transfer_Type').val()
                },
                cache: false,
                type: "POST",
                datatype: "json",
                contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                success: function (response) {
                    
                    $('#SSD_Table_Transfer').DataTable({
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
                                    return '<input type="button" class="SUP_SEL" value="' + '<%=Resources.MP.Select%>' + '">'
                                }
                            },
                            { data: "S_No", title: "<%=Resources.MP.Transfer_No%>" },
                            { data: "S_S_Name", title: "<%=Resources.MP.Transfer_Short_Name%>" }
                        ],
                        "columnDefs": [{
                            targets: [0],
                            className: "text-center"
                        }],
                    });

                    $('#SSD_Table_Transfer').css('white-space', 'nowrap');
                    $('#SSD_Table_Transfer thead th').css('text-align', 'center');
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

<div id="Search_Transfer_Dialog" style="display: none;">
    <table border="0" style="margin: 0 auto;" id="SSD_Table">
        <tr style="text-align: right;">
            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Transfer_No%></td>
            <td style="text-align: left; width: 15%;">
                <input style="width: 90%; height: 25px;" id="SSD_Transfer_No" />
            </td>
            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Transfer_Type%></td>
            <td style="text-align: left; width: 15%;">
                <select style="width: 90%;" id="SSD_Transfer_Type" >
                        <option selected="selected" value="郵局">郵局</option>
                        <option value="國內快遞">國內快遞</option>
                        <option value="港陸快遞">港陸快遞</option>
                        <option value="國際快遞">國際快遞</option>
                        <option value="貨運行">貨運行</option>
                        <option value="其他">其他</option>
                </select>
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
        <table id="SSD_Table_Transfer" style="width: 100%;" class="table table-striped table-bordered dt-responsive">
            <thead></thead>
            <tbody></tbody>
        </table>
    </div>
</div>
