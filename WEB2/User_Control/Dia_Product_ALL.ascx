<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Dia_Product_ALL.ascx.cs" Inherits="User_Control_Dia_Product_ALL" %>

<script type="text/javascript">
    $(document).ready(function () {
        PAD_DDL_Bind();

        $("#Product_ALL_Dialog").dialog({
            autoOpen: false,
            open: function () {
                $('.PADV_BT').attr('disabled', false);
                $('#PAD_PADV_DEFAULT').attr('disabled', 'disabled');
                $('.PAD_Div_D').toggle(false);
                $('#PAD_Div_Basic').toggle(true);
                Search_Product_ALL();
            },
            modal: true,
            title: "Product ALL",
            width: screen.width * 0.8,
            height: screen.height * 0.8,
            overlay: 0.5,
            position: { my: "center", at: "top" },
            focus: true,
            buttons: {
                "Cancel": function () {
                    $("#Product_ALL_Dialog").dialog('close');
                    $('#PAD_Div_DT').toggle(false);
                }
            }
        });

        function Search_Product_ALL() {
            if ($('#PAD_HDN_SUPLU_SEQ').val().length > 0) {
                $.ajax({
                    url: "/Web_Service/Dialog_DataBind.asmx/Product_ALL_Search",
                    data: {
                        "SUPLU_SEQ": $('#PAD_HDN_SUPLU_SEQ').val()
                    },
                    cache: false,
                    type: "POST",
                    datatype: "json",
                    contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                    success: function (R) {
                        var Has_IMG = (R[0].IMG != null);
                        $('#PAD_IM_IMG').toggle(Has_IMG);
                        $('#PAD_IM_IMG_HINT').toggle(!Has_IMG);
                        if (Has_IMG) {
                            var SRC = 'data:image/png;base64,' + R[0].IMG;
                            $('#PAD_IM_IMG').attr('src', SRC);
                        }
                        $('[PAD_DT_Fill_Name]').each(function () {
                            var DF = $(this).attr('PAD_DT_Fill_Name');
                            $(this).val(R[0][DF]);
                        })
                    }
                });
            }
            else {
                alert('Please re-search or notify IT.');
            }
        }

        $('.PADV_BT').on('click', function () {
            $('.PADV_BT').attr('disabled', false);
            $(this).attr('disabled', 'disabled');
            $('.PAD_Div_D').toggle(false);
            var Target = $(this).attr('target');
            $('#' + Target).toggle(true);
        });

        function PAD_DDL_Bind() {
            $.ajax({
                url: "/Web_Service/DDL_DataBind.asmx/Product_Status",
                cache: false,
                dataType: "json",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    var Json_Response = JSON.parse(data.d);
                    var DDL_Option = "";

                    $.each(Json_Response, function (i, value) {
                        DDL_Option += '<option value="' + value.val + '">' + value.txt + '</option>';
                    });
                    $('#PAD_DDL_M2_PS').html(DDL_Option);
                },
                error: function (response) {
                    alert(response.responseText);
                },
            });
        }
    });
</script>
<style>
    .PADV_BT {
        background-color: azure;
        font-weight: bold;
        border: none;
        cursor: pointer;
        font-size: 15px;
        text-align: center;
        text-decoration: none;
    }
        .PADV_BT:hover {
            background-color: #f8981d;
            color: white;
        }
</style>
    
<input id="PAD_HDN_SUPLU_SEQ" type="hidden" />
<div id="Product_ALL_Dialog" style="display: none;">
    <div style="width: 99%; margin: 0 auto; background-color: white;">
        <input type="button" id="PAD_PADV_DEFAULT" class="PADV_BT" target="PAD_Div_Basic" value="<%=Resources.MP.Basic%>" />
        <input type="button" class="PADV_BT" target="PAD_Div_Supplier" value="<%=Resources.MP.Supplier%>" />
        <input type="button" class="PADV_BT" target="PAD_Div_Cost" value="<%=Resources.MP.Product%>" />
        <input type="button" class="PADV_BT" target="PAD_Div_Price" value="Price" />
    </div>

    <div id="PAD_Div_Basic" class="PAD_Div_D">
        <table style="font-size: 15px; border-collapse: separate; border-spacing: 0px 8px;width:100%;">
            <tr>
                <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Ivan_Model%></td>
                <td style="text-align: left; width: 15%;">
                    <input id="PAD_TB_M2_IM" PAD_DT_Fill_Name="頤坊型號" disabled="disabled" style="width: 100%;" />
                </td>
                <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Supplier_Model%></td>
                <td style="text-align: left; width: 15%;">
                    <input id="PAD_TB_M2_SupM" PAD_DT_Fill_Name="廠商型號" disabled="disabled" style="width: 100%;" />
                </td>
                <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Supplier_No%></td>
                <td style="text-align: left; width: 15%;">
                    <input id="PAD_TB_M2_S_No" PAD_DT_Fill_Name="廠商編號" disabled="disabled" style="width: 100%;" />
                </td>
                <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Supplier_Short_Name%></td>
                <td style="text-align: left; width: 15%;">
                    <input id="PAD_TB_M2_S_SName" PAD_DT_Fill_Name="廠商簡稱" disabled="disabled" style="width: 100%;" />
                </td>
                <%--<td rowspan="6" style="text-align:center;">
                    <img id="PAD_IM_IMG" src="#" />
                    <span id="PAD_IM_IMG_HINT" style="display:none;">查無圖片</span>
                </td>--%>
            </tr>
            <tr>
                <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Sample_Product_No%></td>
                <td style="text-align: left; width: 15%;">
                    <input id="PAD_TB_M2_TempM" PAD_DT_Fill_Name="暫時型號" disabled="disabled" style="width: 100%;" />
                </td>
                <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Sale_Model%></td>
                <td style="text-align: left; width: 15%;">
                    <input id="PAD_TB_M2_SaleM" PAD_DT_Fill_Name="銷售型號" disabled="disabled" style="width: 100%;" />
                </td>
                <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Unit%></td>
                <td style="text-align: left; width: 15%;">
                    <input id="PAD_TB_M2_Unit" PAD_DT_Fill_Name="單位" disabled="disabled" style="width: 100%;" />
                </td>
                <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Developing%></td>
                <td style="text-align: left; width: 15%;">
                    <input id="PAD_TB_M2_DVN" PAD_DT_Fill_Name="開發中" disabled="disabled" style="width: 100%;" />
                </td>
            </tr>
            <tr>
                <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Product_Status%></td>
                <td style="text-align: left; width: 15%;">
                    <select id="PAD_DDL_M2_PS" PAD_DT_Fill_Name="產品狀態" disabled="disabled" style="width: 100%;">
                    </select>
                </td>
                <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Stop_Date%></td>
                <td style="text-align: left; width: 15%;">
                    <input id="PAD_TB_M2_SD" PAD_DT_Fill_Name="停用日期" type="datetime" disabled="disabled" style="width: 100%;" />
                </td>
                <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Account_Class%></td>
                <td style="text-align: left; width: 15%;">
                    <input id="PAD_TB_M2_AC_Class" PAD_DT_Fill_Name="帳務分類" disabled="disabled" style="width: 100%;" />
                </td>
            </tr>
            <tr>
                <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Product_Information%></td>
                <td style="text-align: left; width: 15%;" colspan="7">
                    <input id="PAD_TB_M2_PI" PAD_DT_Fill_Name="產品說明" disabled="disabled" style="width: 100%;" />
                </td>
            </tr>
            <tr>
                <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Product_Information_Detail%></td>
                <td style="text-align: left; width: 15%;" colspan="7">
                    <textarea id="PAD_TB_M2_PID" PAD_DT_Fill_Name="產品詳述" style="width: 100%; height: 100px;" maxlength="560" disabled="disabled"></textarea>
                </td>
            </tr>
            <tr>
                <td colspan="8" style="text-align:center;">
                    <img id="PAD_IM_IMG" src="#" />
                    <span id="PAD_IM_IMG_HINT" style="display:none;">查無圖片</span>
                </td>
            </tr>
        </table>
    </div>

    <div id="PAD_Div_Supplier" class="PAD_Div_D" style="display: none; overflow: auto;">
        <table style="font-size: 15px; border-collapse: separate; border-spacing: 0px 8px;width:100%;">

        </table>
    </div>
    
    <div id="PAD_Div_Cost" class="PAD_Div_D" style="display: none; overflow: auto;">
        Cost
    </div>
    
    <div id="PAD_Div_Price" class="PAD_Div_D" style="display: none; overflow: auto;">
        Price
    </div>
</div>
