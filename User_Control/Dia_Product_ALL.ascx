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
                    $('#PAD_Div_DT').css('display', 'none');
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
                        var JR = JSON.parse(R);
                        if (JR[0].IMG != null) {
                            $('#PAD_IM_IMG_HINT').css('display', 'none');
                            $('#PAD_IM_IMG').css('display', '');
                            var binary = '';
                            var bytes = new Uint8Array(JR[0].IMG);
                            var len = bytes.byteLength;
                            for (var j = 0; j < len; j++) {
                                binary += String.fromCharCode(bytes[j]);
                            }
                            var SRC = 'data:image/png;base64,' + window.btoa(binary);
                            $('#PAD_IM_IMG').attr('src', SRC);
                        }
                        else {
                            $('#PAD_IM_IMG').css('display', 'none');
                            $('#PAD_IM_IMG_HINT').css('display', '');
                        }
                        $('#PAD_TB_M2_IM').val(JR[0].IM);
                        $('#PAD_TB_M2_SupM').val(JR[0].SupM);
                        $('#PAD_TB_M2_S_No').val(JR[0].S_No);
                        $('#PAD_TB_M2_S_SName').val(JR[0].S_SName);
                        $('#PAD_TB_M2_TempM').val(JR[0].TempM);
                        $('#PAD_TB_M2_SaleM').val(JR[0].SaleM);
                        $('#PAD_TB_M2_Unit').val(JR[0].Unit);
                        $('#PAD_TB_M2_DVN').val(JR[0].DVN);
                        $('#PAD_DDL_M2_PS').val(JR[0].PST);
                        $('#PAD_TB_M2_AC_Class').val(JR[0].ACC);
                        $('#PAD_TB_M2_PI').val(JR[0].PI);
                        $('#PAD_TB_M2_PID').val(JR[0].PID);
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
            $('.PAD_Div_D').css('display', 'none');
            var Target = $(this).attr('target');
            $('#' + Target).css('display', '');
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
                    <input id="PAD_TB_M2_IM" disabled="disabled" style="width: 100%;" />
                </td>
                <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Supplier_Model%></td>
                <td style="text-align: left; width: 15%;">
                    <input id="PAD_TB_M2_SupM" disabled="disabled" style="width: 100%;" />
                </td>
                <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Supplier_No%></td>
                <td style="text-align: left; width: 15%;">
                    <input id="PAD_TB_M2_S_No" disabled="disabled" style="width: 100%;" />
                </td>
                <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Supplier_Short_Name%></td>
                <td style="text-align: left; width: 15%;">
                    <input id="PAD_TB_M2_S_SName" disabled="disabled" style="width: 100%;" />
                </td>
                <%--<td rowspan="6" style="text-align:center;">
                    <img id="PAD_IM_IMG" src="#" />
                    <span id="PAD_IM_IMG_HINT" style="display:none;">查無圖片</span>
                </td>--%>
            </tr>
            <tr>
                <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Sample_Product_No%></td>
                <td style="text-align: left; width: 15%;">
                    <input id="PAD_TB_M2_TempM" disabled="disabled" style="width: 100%;" />
                </td>
                <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Sale_Model%></td>
                <td style="text-align: left; width: 15%;">
                    <input id="PAD_TB_M2_SaleM" disabled="disabled" style="width: 100%;" />
                </td>
                <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Unit%></td>
                <td style="text-align: left; width: 15%;">
                    <input id="PAD_TB_M2_Unit" disabled="disabled" style="width: 100%;" />
                </td>
                <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Developing%></td>
                <td style="text-align: left; width: 15%;">
                    <input id="PAD_TB_M2_DVN" disabled="disabled" style="width: 100%;" />
                </td>
            </tr>
            <tr>
                <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Product_Status%></td>
                <td style="text-align: left; width: 15%;">
                    <select id="PAD_DDL_M2_PS" disabled="disabled" style="width: 100%;">
                    </select>
                </td>
                <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Stop_Date%></td>
                <td style="text-align: left; width: 15%;">
                    <input id="PAD_TB_M2_SD" type="datetime" disabled="disabled" style="width: 100%;" />
                </td>
                <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Account_Class%></td>
                <td style="text-align: left; width: 15%;">
                    <input id="PAD_TB_M2_AC_Class" disabled="disabled" style="width: 100%;" />
                </td>
            </tr>
            <tr>
                <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Product_Information%></td>
                <td style="text-align: left; width: 15%;" colspan="7">
                    <input id="PAD_TB_M2_PI" autocomplete="off" disabled="disabled" style="width: 100%;" />
                </td>
            </tr>
            <tr>
                <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Product_Information_Detail%></td>
                <td style="text-align: left; width: 15%;" colspan="7">
                    <textarea id="PAD_TB_M2_PID" style="width: 100%; height: 100px;" maxlength="560" disabled="disabled"></textarea>
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
