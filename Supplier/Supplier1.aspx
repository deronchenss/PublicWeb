<%@ Page Title="Supplier Search" Language="C#" MasterPageFile="~/MP.master" AutoEventWireup="true" CodeFile="Supplier1.aspx.cs" Inherits="Supplier1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <link href="/css/dataTables.bootstrap4.min.css" rel="stylesheet" />
    <script src="/js/jquery.dataTables.min.js"></script>
    <script src="/js/dataTables.bootstrap4.min.js"></script>

    <table class="table_th">
        <tr>
            <td style="height: 10px; font-size: smaller;" colspan="8">&nbsp</td>
        </tr>
        <tr>
            <td style="text-align: right; text-wrap: none; width: 10%;"><%--廠商編號--%><%=Resources.Supplier.Supplier_NO%></td>
            <td style="text-align: left; width: 15%;">
                <input id="TB_Search_S_NO" name="TB_Search_S_NO" placeholder="<%=Resources.MP.S_No_ATC_Hint%>" type="text" style="width: 100%;" />
                <input id="BT_DIA_Search" type="button" value="…" style="float: right; width: 20%; display: none;" />

                <div id="dialog" style="display: none;">
                    <div style="width: 100%; text-align: center;">
                        <input type="button" id="Dia_BT_Simple_Change" value="Simple" style="width: 20%" disabled="disabled" />
                        <input type="button" id="Dia_BT_Multiple_Change" value="Multiple" style="width: 20%" />
                    </div>
                    <br />
                    <table border="0" style="margin: 0 auto;" id="Dia_Table_Simple">
                        <tr style="text-align: right;">
                            <td style="width: 20%;">廠商編號</td>
                            <td style="width: 30%;">
                                <select style="width: 90%; height: 25px;" id="Dia_TB1_Operator1">
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
                            <td style="width: 50%;">
                                <input style="width: 90%; height: 25px;" id="Dia_TB1_TB1" />
                            </td>
                        </tr>
                        <tr style="text-align: right;">
                            <td style="width: 20%;">廠商簡稱</td>
                            <td style="width: 30%;">
                                <select style="width: 90%; height: 25px;" id="Dia_TB1_Operator2">
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
                            <td style="width: 50%;">
                                <input style="width: 90%; height: 25px;" id="Dia_TB1_TB2" />
                            </td>
                        </tr>
                    </table>
                    <table border="1" style="margin: 0 auto; display: none;" id="Dia_Table_Multiple">
                        <tr style="text-align: center;">
                            <td style="width: 40%;">
                                <%--Where Column--%>
                                <select style="width: 90%; height: 25px;" id="DDL_Dia_Filter">
                                    <option selected="selected">廠商編號</option>
                                    <option>廠商簡稱</option>
                                    <option>電話</option>
                                    <option>地址</option>
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
                                                Where_Text = $('input[name=R_Filter_Group]:checked').val() + " " + Where_Text;
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
            </td>
            <script type="text/javascript">
                //Dialog_Function
                $(function () {
                    $('#BT_DIA_Search').on('click', function () {
                        $("#dialog").dialog({
                            modal: true,
                            title: "查詢條件",
                            width: 700,//=Div寬度$
                            overlay: 0.5,
                            focus: true,
                            buttons: {
                                "Search": function () {
                                    //var name = el("txtGroupName").value;
                                    //var description = el("txtDescription").value;
                                    //var b = $("#fgroup").valid();
                                    //if (b) {
                                    //    createGroupJson();
                                    //    $("#dialog").dialog('close');
                                    //} else {
                                    showError(lmslang.formValidate_Error);
                                    //}
                                }
                                , "Cancel": function () {
                                    $("#dialog").dialog('close');
                                }
                            }
                        });
                    });
                });
            </script>
             
            <script type="text/javascript">
                $(document).ready(function () {
                    Search_Supplier();
                    //$('#GV_Supplier tbody tr').on('click', function () {
                    function GV_Row_Click(Click_tr) {
                        //$(this).parent().find('tr:not(:first-child)').css('background-color', '');
                        $(Click_tr).parent().find('tr').css('background-color', '');
                        $(Click_tr).parent().find('tr').css('color', 'black');
                        $(Click_tr).css('background-color', '#5a1400');
                        $(Click_tr).css('color', 'white');

                        var S_NO = $(Click_tr).find('td:nth-child(1)').text().toString().trim();
                        $.ajax({
                            url: "/Supplier/Sup_Search.ashx",
                            data: {
                                "S_NO": S_NO,
                                "Call_Type": "GV_Selected"
                            },
                            cache: false,
                            type: "POST",
                            datatype: "json",
                            //contentType: "application/json",
                            contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                            success: function (response) {
                                $('#TB_S_No').val(S_NO);
                                $('#TB_S_Tel').val(String(response[0].S_Tel ?? ""));
                                $('#TB_S_Name').val(String(response[0].S_Name ?? ""));
                                $('#TB_S_FAX').val(String(response[0].S_FAX ?? ""));
                                $('#TB_S_Full_Name').val(String(response[0].S_Full_Name ?? ""));

                                $('#TB_S_Phone').val(String(response[0].S_Phone ?? ""));
                                $('#TB_S_SEQ').val(String(response[0].S_SEQ ?? ""));
                                $('#TB_S_Area').val(String(response[0].S_Area ?? ""));
                                $('#TB_S_Phone').val(String(response[0].S_Phone ?? ""));
                                $('#TB_S_EIN').val(String(response[0].S_EIN ?? ""));

                                $('#TB_S_Pay').val(String(response[0].S_Pay ?? ""));
                                $('#TB_S_Principal').val(String(response[0].S_Principal ?? ""));
                                $('#TB_S_Site').val(String(response[0].S_Site ?? ""));
                                $('#TB_S_P_Develop').val(String(response[0].S_P_Develop ?? ""));
                                $('#TB_S_Mail_Develop').val(String(response[0].S_Mail_Develop ?? ""));

                                $('#TB_S_P_Purchase').val(String(response[0].S_P_Purchase ?? ""));
                                $('#TB_S_Mail_Purchase').val(String(response[0].S_Mail_Purchase ?? ""));
                                $('#TB_S_Company_Address').val(String(response[0].S_Company_Address ?? ""));
                                $('#TB_S_Factory_Address').val(String(response[0].S_Factory_Address ?? ""));
                                $('#TB_S_Send_Address').val(String(response[0].S_Send_Address ?? ""));

                                $('#TB_S_Update_User').val(String(response[0].S_Update_User ?? ""));
                                $('#TB_S_Update_Date').val(String(response[0].S_Update_Date ?? ""));

                                $('#TB_R_S_NO').val(S_NO);
                                $('#TB_R_S_Name').val(String(response[0].S_Name ?? ""));

                                $('#TB_R_Remark_Develop').val(String(response[0].S_Remark_Develop ?? ""));
                                $('#TB_R_Remark_Purchase').val(String(response[0].S_Remark_Purchase ?? ""));

                                $('#TB_B_S_NO').val(S_NO);
                                $('#TB_B_S_Name').val(String(response[0].S_Name ?? ""));
                                $('#TB_B_Company_Address').val(String(response[0].S_Company_Address ?? ""));
                                $('#TB_B_Factory_Address').val(String(response[0].S_Factory_Address ?? ""));

                                $('#TB_B_Account_Head').val(String(response[0].B_Account_Head ?? ""));
                                $('#TB_B_Bank_Name').val(String(response[0].B_Bank_Name ?? ""));
                                $('#TB_B_Bank_Address').val(String(response[0].B_Bank_Address ?? ""));
                                $('#TB_B_Bank_Account').val(String(response[0].B_Bank_Account ?? ""));
                                $('#TB_B_Swift').val(String(response[0].B_Swift ?? ""));


                            },
                            error: function (ex) {
                                alert(ex);
                            }
                        });
                    };

                    function Search_Supplier() {
                        $.ajax({
                            url: "/Supplier/Sup_Search.ashx",
                            data: {
                                "S_NO": $('#TB_Search_S_NO').val(),
                                "S_Tel": $('#TB_Search_S_Tel').val(),
                                "Nation": $('#TB_Search_Nation').val(),
                                "FAX": $('#TB_Search_FAX').val(),
                                "Address": $('#TB_Search_Address').val(),
                                "Call_Type": "BT_Search"
                            },
                            cache: false,
                            type: "POST",
                            datatype: "json",
                            //contentType: "application/json",
                            contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                            success: function (response) {
                                //console.warn(response);
                                var Table_HTML =
                                    //<tr style="color:White;background-color:#507CD1;font-weight:bold;white-space:nowrap;text-align:center;">\
                                    '<thead><tr><th>' + '<%=Resources.Supplier.Supplier_NO%>'
                                    + '</th><th>' + '<%=Resources.Supplier.Supplier_Short_Name%>'
                                    + '</th><th>' + '<%=Resources.MP.Tel%>'
                                    + '</th><th>' + '<%=Resources.MP.Fax%>'
                                    + '</th><th>' + '<%=Resources.Supplier.Purchase_Person%>'
                                    + '</th><th>' + '<%=Resources.Supplier.Develop_Person%>'
                                    + '</th><th>' + '<%=Resources.Supplier.Principal%>'
                                    + '</th><th>' + '<%=Resources.Supplier.Area%>'
                                    + '</th><th>' + '<%=Resources.MP.Nation%>'
                                    + '</th><th>' + '<%=Resources.Supplier.Z%>'
                                    + '</th><th>' + '<%=Resources.Supplier.Phone%>'
                                    + '</th><th>' + '<%=Resources.Supplier.Company_Address%>'
                                    + '</th><th>' + '<%=Resources.Supplier.Factory_Address%>'
                                    + '</th><th>' + '<%=Resources.Supplier.SEQ%>'
                                    + '</th><th>' + '<%=Resources.Supplier.Update_User%>'
                                    + '</th><th>' + '<%=Resources.Supplier.Update_Date%>'
                                    + '</th></tr></thead><tbody>';

                                $(response).each(function (i) {
                                    Table_HTML +=
                                        '<tr><td>' + String(response[i].S_NO) +
                                        '</td><td>' + String(response[i].S_Name ?? "") +
                                        '</td><td>' + String(response[i].S_Tel ?? "") +
                                        '</td><td>' + String(response[i].S_FAX ?? "") +
                                        '</td><td>' + String(response[i].S_P_Purchase ?? "") +
                                        '</td><td>' + String(response[i].S_P_Develop ?? "") +
                                        '</td><td>' + String(response[i].S_Principal ?? "") +
                                        '</td><td>' + String(response[i].S_Area ?? "") +
                                        '</td><td>' + String(response[i].S_Nation ?? "") +
                                        '</td><td>' + String(response[i].S_Z ?? "") +
                                        '</td><td>' + String(response[i].S_Phone ?? "") +
                                        '</td><td>' + String(response[i].S_Company_Address ?? "") +
                                        '</td><td>' + String(response[i].S_Factory_Address ?? "") +
                                        '</td><td>' + String(response[i].S_SEQ ?? "") +
                                        '</td><td>' + String(response[i].S_Update_User ?? "") +
                                        '</td><td>' + String(response[i].S_Update_Date ?? "") +
                                        '</td></tr>';
                                });
                                Table_HTML += '</tbody>';
                                //$('#GV_Supplier').html(Table_HTML);

                                $('#GV_Supplier').DataTable({
                                    //scrollY: "800px",
                                    "data": response,
                                    //fixedHeader: true,
                                    //fixedColumns: {
                                    //    left: 1,
                                    //    //right: 1
                                    //},
                                    "destroy": true,
                                    "columns": [
                                        //{data: datarow,title : title_Name}
                                        //{
                                        //    data: "S_NO",
                                        //    title: "廠商編號",
                                        //    render: function (data, type, row) {
                                        //        return '<a href="#">' + data + '</a>';
                                        //    }
                                        //},
                                        { data: "S_NO", title: "<%=Resources.Supplier.Supplier_NO%>" },
                                        { data: "S_Name", title: "<%=Resources.Supplier.Supplier_Short_Name%>" },
                                        { data: "S_Tel", title: "<%=Resources.MP.Tel%>" },
                                        { data: "S_FAX", title: "<%=Resources.MP.Fax%>" },
                                        { data: "S_P_Purchase", title: "<%=Resources.Supplier.Purchase_Person%>" },
                                        { data: "S_P_Develop", title: "<%=Resources.Supplier.Develop_Person%>" },
                                        { data: "S_Principal", title: "<%=Resources.Supplier.Principal%>" },
                                        { data: "S_Area", title: "<%=Resources.Supplier.Area%>" },
                                        { data: "S_Nation", title: "<%=Resources.MP.Nation%>" },
                                        { data: "S_Z", title: "<%=Resources.Supplier.Z%>" },
                                        { data: "S_Phone", title: "<%=Resources.Supplier.Phone%>" },
                                        { data: "S_Company_Address", title: "<%=Resources.Supplier.Company_Address%>" },
                                        { data: "S_Factory_Address", title: "<%=Resources.Supplier.Factory_Address%>" },
                                        { data: "S_SEQ", title: "<%=Resources.Supplier.SEQ%>" },
                                        { data: "S_Update_User", title: "<%=Resources.Supplier.Update_User%>" },
                                        { data: "S_Update_Date", title: "<%=Resources.Supplier.Update_Date%>" }

                                    ],
                                    "language": {
                                        "lengthMenu": "&nbsp;Show _MENU_ entries"
                                        //"lengthMenu": "&nbsp Every page show _MENU_ data"
                                    },
                                    //"columndefs": [
                                    //    {
                                    //        targets: '_all'
                                    //    },
                                    //]
                                    //"rowCallback": [
                                    //    {
                                    //        targets: 0,
                                    //        createdCell: function (th, cellData, rowData, row, col) {
                                    //            $(th).css("text-center");
                                    //        },
                                    //    },
                                    //]
                                });
                                //$('#GV_Supplier thead th').css('text-algin', 'center');
                                $('#GV_Supplier thead th').attr('style', 'text-align:center;');
                                $('#GV_Supplier').attr('style', 'white-space:nowrap;');
                                $('#GV_Supplier').on('click', 'tbody tr', function () {
                                    GV_Row_Click($(this));
                                });

                            },
                            error: function (ex) {
                                alert(ex);
                            }
                        });
                    };


                    $('#BT_Search').on('click', function () {
                        Search_Supplier();

                        //$('#GV_Supplier').DataTable({
                        //    "searching": false, // 預設為true 搜尋功能，若要開啟不用特別設定
                        //    "paging": false, // 預設為true 分頁功能，若要開啟不用特別設定
                        //    "ordering": false, // 預設為true 排序功能，若要開啟不用特別設定
                        //    "sPaginationType": "full_numbers", // 分頁樣式 預設為"full_numbers"，若需其他樣式才需設定
                        //    "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]], //顯示筆數設定 預設為[10, 25, 50, 100]
                        //    "pageLength": '50',// 預設為'10'，若需更改初始每頁顯示筆數，才需設定
                        //    "processing": true, // 預設為false 是否要顯示當前資料處理狀態資訊
                        //    "serverSide": false, // 預設為false 是否透過Server端處理分頁…等
                        //    "stateSave": true, // 預設為false 在頁面刷新時，是否要保存當前表格資料與狀態
                        //    "destroy": true, // 預設為false 是否銷毀當前暫存資料
                        //    "info": true, // 預設為true　是否要顯示"目前有 x  筆資料"
                        //    "autoWidth": false, // 預設為true　設置是否要自動調整表格寬度(false代表不要自適應)　　　　
                        //    "scrollCollapse": true, // 預設為false 是否開始滾軸功能控制X、Y軸
                        //    "scrollY": "200px", // 若有設置為Y軸(垂直)最大高度
                        //    "dom": 'lrtip',// 設置搜尋div、頁碼div...等基本位置/外觀..等，詳細可看官網
                        //});
                    });
                    $('#TB_Search_S_NO').on('change', function () {
                        if ($.trim($(this).val()) == "") {
                            $('#Search_TB_S_Name').val('');
                        }
                    });
                    $('#TB_Search_S_NO').autocomplete({
                        autoFocus: true,
                        source: function (request, response) {
                            $.ajax({
                                url: "/Web_Service/AutoComplete.asmx/Serach_Supplier_No_Name",
                                cache: false,
                                data: "{'S_No': '" + request.term + "'}",
                                dataType: "json",
                                type: "POST",
                                //contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                                contentType: "application/json; charset=utf-8",
                                success: function (data) {
                                    var Json_Response = JSON.parse(data.d);
                                    //console.warn(Json_Response);
                                    //console.warn(Json_Response[0].S_NO);
                                    //console.warn(JSON.parse('{ "1C": 1, "2C":3 }'));

                                    //response($.map(data.d, function (item) { return { label: item, value: 11 } }));
                                    response($.map(Json_Response, function (item) { return { label: item.S_No + " - " + item.S_Name, value: item.S_No, name: item.S_Name } }));
                                },
                                error: function (response) {
                                    alert(response.responseText);
                                },
                            });
                        },
                        select: function (event, ui) {
                            //console.warn(ui.item.label);
                            //console.warn(ui.item.value);
                            //console.warn(ui.item.name);

                            $('#TB_Search_S_NO').val(ui.item.value);
                            $('#Search_TB_S_Name').val(ui.item.name);
                            Search_Supplier();
                        },
                    });
                });
            </script>
            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Tel%></td>
            <td style="text-align: left; width: 15%;">
                <input id="TB_Search_S_Tel" style="width: 100%;" /></td>

            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Nation%></td>
            <td style="text-align: left; width: 15%;">
                <input id="TB_Search_Nation" style="width: 100%;" /></td>

            <td style="width: 10%;"></td>
            <td rowspan="4" style="text-align: center;">
                <div style="display: flex; justify-content: center; align-items: center;">
                    <%--<input id="BT_Search" class="BTN" type="button" value="查詢" />--%>
                    <%--<asp:Button ID="BT_Search" CssClass="BTN" runat="server" style="font-size:medium;" Text="查詢" OnClick="BT_Search_Click" />--%>
                    <input id="BT_Search" class="BTN" type="button" value="<%=Resources.MP.Search%>" />
                </div>
            </td>
        </tr>
        <tr>
            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Supplier.Supplier_Short_Name%></td>
            <td style="text-align: left; width: 15%;">
                <input id="Search_TB_S_Name" style="width: 100%;" disabled="disabled" /></td>

            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Fax%></td>
            <td style="text-align: left; width: 15%;">
                <input id="TB_Search_FAX" style="width: 100%;" /></td>
        </tr>
        <tr>
            <td style="text-align: right; text-wrap: none;"><%=Resources.MP.Address%></td>
            <td colspan="3" style="text-align: left;">
                <input id="TB_Search_Address" style="width: 100%;" /></td>
        </tr>
        <tr>
            <td style="height: 10px; font-size: smaller;" colspan="8">&nbsp</td>
        </tr>
    </table>


    <div style="width: 99%; margin: 0 auto; background-color: white;">
        &nbsp;
        <input type="button" class="V_BT" value="<%=Resources.MP.Supplier%>" onclick="$('#<%=P_Supplier.ClientID%>').css('width','100%');" disabled="disabled" />
        <input type="button" class="V_BT" value="<%=Resources.MP.Detail%>" onclick="$('#<%=P_Supplier.ClientID%>').css('width','60%');$('.P_D').css('display','none');$('#<%=P_Detail.ClientID%>').css('display','')" />
        <input type="button" class="V_BT" value="<%=Resources.MP.Remark%>" onclick="$('#<%=P_Supplier.ClientID%>').css('width','60%');$('.P_D').css('display','none');$('#<%=P_Reamark.ClientID%>').css('display','')" />
        <input type="button" class="V_BT" value="<%=Resources.MP.Bank%>" onclick="$('#<%=P_Supplier.ClientID%>').css('width','60%');$('.P_D').css('display','none');$('#<%=P_Bank.ClientID%>').css('display','')" />
        <input type="button" class="V_BT" value="Title" onclick="$('#<%=P_Supplier.ClientID%>').css('width','60%');$('.P_D').css('display','none');$('#<%=P_Title.ClientID%>').css('display','')" />
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
        <asp:Panel ID="P_Supplier" runat="server" ScrollBars="Auto" Style="float: left;" Width="100%">
            <%--<table id="GV_Supplier" class="table_grid" cellspacing="0" align="Left" rules="all" border="1" style="font-size: 15px; width: 100%; border-collapse: collapse;">--%>

            <table id="GV_Supplier" style="width: 100%" class="table table-striped table-bordered">
                <thead></thead>
                <tbody></tbody>
            </table>

            <style type="text/css">
                #GV_Supplier tbody tr:hover {
                    background-color: #f8981d;
                    color: white;
                }
            </style>
        </asp:Panel>

        <asp:Panel ID="P_Detail" CssClass="P_D" runat="server" ScrollBars="Auto" Style="display: none;">
            <table style="font-size: 15px;">
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Supplier.Supplier_NO%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_S_No" placeholder="" disabled="disabled" style="width: 100%;" />
                    </td>

                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Tel%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_S_Tel" placeholder="" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Supplier.Supplier_Short_Name%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_S_Name" placeholder="" disabled="disabled" style="width: 100%;" />
                    </td>

                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Supplier.Supplier_Name%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_S_Full_Name" placeholder="" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Fax%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_S_FAX" placeholder="" disabled="disabled" style="width: 100%;" />
                    </td>

                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Supplier.Phone%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_S_Phone " placeholder="" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Supplier.SEQ%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_S_SEQ" placeholder="" disabled="disabled" style="width: 100%;" />
                    </td>

                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Supplier.Area%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_S_Area" placeholder="" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Supplier.EIN%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_S_EIN" placeholder="" disabled="disabled" style="width: 100%;" />
                    </td>

                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Supplier.Payment_Terms%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_S_Pay" placeholder="" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Supplier.Principal%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_S_Principal" placeholder="" disabled="disabled" style="width: 100%;" />
                    </td>

                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Supplier.Web%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_S_Site" placeholder="" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Supplier.Develop_Person%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_S_P_Develop" placeholder="" disabled="disabled" style="width: 100%;" />
                    </td>

                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Supplier.Develop_Mail%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_S_Mail_Develop" placeholder="" type="email" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>

                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Supplier.Purchase_Person%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_S_P_Purchase" placeholder="" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Supplier.Purchase_Mail%></td>
                    <td colspan="3" style="text-align: left; width: 15%;">
                        <input id="TB_S_Mail_Purchase" placeholder="" style="width: 100%;" type="email" disabled="disabled" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Supplier.Company_Address%></td>
                    <td colspan="3" style="text-align: left; width: 15%;">
                        <textarea id="TB_S_Company_Address" placeholder="" style="width: 100%;" disabled="disabled"></textarea>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Supplier.Factory_Address%></td>
                    <td colspan="3" style="text-align: left; width: 15%;">
                        <textarea id="TB_S_Factory_Address" placeholder="" style="width: 100%;" disabled="disabled"></textarea>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Supplier.Delivery_Address%></td>
                    <td colspan="3" style="text-align: left; width: 15%;">
                        <textarea id="TB_S_Send_Address" placeholder="" style="width: 100%;" disabled="disabled"></textarea>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Supplier.Update_User%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_S_Update_User" placeholder="" disabled="disabled" style="width: 100%;" />
                    </td>

                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Supplier.Update_Date%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_S_Update_Date" placeholder="" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
            </table>
        </asp:Panel>

        <asp:Panel ID="P_Reamark" CssClass="P_D" runat="server" ScrollBars="Auto" Style="display: none;">
            <table style="font-size: 15px;">
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Supplier.Supplier_NO%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_R_S_NO" placeholder="" disabled="disabled" style="width: 100%; background-color: gold;" />
                    </td>

                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Supplier.Supplier_Short_Name%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_R_S_Name" placeholder="" disabled="disabled" style="width: 100%; background-color: gold;" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Supplier.Develop_Remark%></td>
                    <td colspan="3" style="text-align: left; width: 15%;">
                        <textarea id="TB_R_Remark_Develop" placeholder="" style="width: 100%; height: 250px; background-color: gold;" dizsabled="disabled"></textarea>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Supplier.Purchase_Remark%></td>
                    <td colspan="3" style="text-align: left; width: 15%;">
                        <textarea id="TB_R_Remark_Purchase " placeholder="" style="width: 100%; height: 250px;" disabled="disabled"></textarea>
                    </td>
                </tr>
            </table>
        </asp:Panel>

        <asp:Panel ID="P_Bank" CssClass="P_D" runat="server" ScrollBars="Auto" Style="display: none;">
            <table style="font-size: 15px;border-collapse:separate; border-spacing:0px 10px;">
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Supplier.Supplier_NO%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_B_S_NO" placeholder="" disabled="disabled" style="width: 100%; background-color: gold;" />
                    </td>

                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Supplier.Supplier_Short_Name%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_B_S_Name" placeholder="" disabled="disabled" style="width: 100%; background-color: gold;" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Supplier.Company_Address%></td>
                    <td colspan="3" style="text-align: left; width: 15%;">
                        <input id="TB_B_Company_Address" placeholder="" style="width: 100%;" type="email" disabled="disabled" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Supplier.Factory_Address%></td>
                    <td colspan="3" style="text-align: left; width: 15%;">
                        <input id="TB_B_Factory_Address" placeholder="" style="width: 100%;" type="email" disabled="disabled" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Supplier.Bank_Name%></td>
                    <td colspan="3" style="text-align: left; width: 15%;">
                        <input id="TB_B_Account_Head" placeholder="" style="width: 100%;" type="email" disabled="disabled" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Supplier.Bank_Account_Header%></td>
                    <td colspan="3" style="text-align: left; width: 15%;">
                        <input id="TB_B_Bank_Name" placeholder="" style="width: 100%;" type="email" disabled="disabled" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Supplier.Bank_Address%></td>
                    <td colspan="3" style="text-align: left; width: 15%;">
                        <input id="TB_B_Bank_Address" placeholder="" style="width: 100%;" type="email" disabled="disabled" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Supplier.Bank_Account%></td>
                    <td colspan="3" style="text-align: left; width: 15%;">
                        <input id="TB_B_Bank_Account" placeholder="" style="width: 100%;" type="email" disabled="disabled" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;">SWIFT Code</td>
                    <td colspan="3" style="text-align: left; width: 15%;">
                        <input id="TB_B_Swift" placeholder="" style="width: 100%;" type="email" disabled="disabled" />
                    </td>
                </tr>
            </table>
        </asp:Panel>
        <asp:Panel ID="P_Title" CssClass="P_D" runat="server" ScrollBars="Auto" Style="display: none;">
            <table>
                <tr>
                    <td>Title_Test</td>
                </tr>
            </table>
        </asp:Panel>
    </div>

    <br />
    <br />


</asp:Content>

