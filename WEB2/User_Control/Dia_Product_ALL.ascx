<%@ Control Language="C#" AutoEventWireup="true" %>

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
            width: "80vw",
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
            switch (Target) {
                case "PAD_Div_Price":
                    Loading_Price();
                    break;
            }
        });

        function Loading_Price() {
            if ($('#PAD_HDN_SUPLU_SEQ').val().length > 0) {
                $.ajax({
                    url: "/Web_Service/Dialog_DataBind.asmx/PAS_Price",
                    data: {
                        "SUPLU_SEQ": $('#PAD_HDN_SUPLU_SEQ').val()
                    },
                    cache: false,
                    type: "POST",
                    datatype: "json",
                    contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                    success: function (R) {
                        if (R.length > 0) {

                            var Price_Table_HTML =
                                '<thead>\
                                <tr>\
                                    <th>' + '<%=Resources.MP.Developing%>' + '</th>\
                                    <th>' + '<%=Resources.MP.Customer_Short_Name%>' + '</th>\
                                    <th>' + '<%=Resources.MP.Ivan_Model%>' + '</th>\
                                    <th>' + '<%=Resources.MP.Customer_Model%>' + '</th>\
                                    <th>' + '<%=Resources.MP.Product_Status%>' + '</th>\
                                    <th>' + '<%=Resources.MP.Sale_Model%>' + '</th>\
                                    <th>' + '<%=Resources.MP.Unit%>' + '</th>\
                                    <th>' + '<%=Resources.MP.Price_USD%>' + '</th>\
                                    <th>' + '<%=Resources.MP.Price_TWD%>' + '</th>\
                                    <th>' + '<%=Resources.MP.Currency%>' + '</th>\
                                    <th>' + '<%=Resources.MP.Price_Curr%>' + '</th>\
                                    <th>MIN_1</th>\
                                    <th>' + '<%=Resources.MP.Last_Price_Day%>' + '</th>\
                                    <th>' + '<%=Resources.MP.Price_Information%>' + '</th>\
                                    <th>' + '<%=Resources.MP.Supplier_Short_Name%>' + '</th>\
                                    <th>' + '<%=Resources.MP.Supplier_No%>' + '</th>\
                                    <th>' + '<%=Resources.MP.Customer_No%>' + '</th>\
                                    <th>' + '<%=Resources.MP.SEQ%>' + '</th>\
                                    <th>' + '<%=Resources.MP.Update_User%>' + '</th>\
                                    <th>' + '<%=Resources.MP.Update_Date%>' + '</th>\
                                </tr>\
                            </thead><tbody>';
                            $(R).each(function (i) {
                                Price_Table_HTML +=
                                    '<tr>\
                                    <td>' + String(R[i].開發中 ?? "") + '</td>\
                                    <td>' + String(R[i].客戶簡稱 ?? "") + '</td>\
                                    <td>' + String(R[i].頤坊型號 ?? "") + '</td>\
                                    <td>' + String(R[i].客戶型號 ?? "") + '</td>\
                                    <td>' + String(R[i].產品狀態 ?? "") + '</td>\
                                    <td>' + String(R[i].銷售型號 ?? "") + '</td>\
                                    <td>' + String(R[i].單位 ?? "") + '</td>\
                                    <td style="text-align:right;">' + String(R[i].美元單價 ?? "") + '</td>\
                                    <td style="text-align:right;">' + String(R[i].台幣單價 ?? "") + '</td>\
                                    <td>' + String(R[i].外幣幣別 ?? "") + '</td>\
                                    <td style="text-align:right;">' + String(R[i].外幣單價 ?? "") + '</td>\
                                    <td style="text-align:right;">' + String(R[i].MIN_1 ?? "") + '</td>\
                                    <td>' + String(R[i].最後單價日 ?? "") + '</td>\
                                    <td>' + String(R[i].產品說明 ?? "") + '</td>\
                                    <td>' + String(R[i].廠商簡稱 ?? "") + '</td>\
                                    <td>' + String(R[i].廠商編號 ?? "") + '</td>\
                                    <td>' + String(R[i].客戶編號 ?? "") + '</td>\
                                    <td>' + String(R[i].序號 ?? "") + '</td>\
                                    <td>' + String(R[i].更新人員 ?? "") + '</td>\
                                    <td>' + String(R[i].更新日期 ?? "") + '</td>\
                                </tr>';
                            });
                            Price_Table_HTML += '</tbody>';
                            $('#PAD_DP_Table').html(Price_Table_HTML);

                            $('#PAD_DP_Table').css('white-space', 'nowrap');
                            $('#PAD_DP_Table thead th').css({
                                'text-align': 'center',
                                'background-color': 'white',
                                'position': 'sticky',
                                'top': '0'
                            });
                            $('#PAD_DP_Table tbody td').css('vertical-align', 'middle');
                        }
                        else {
                            $('#PAD_DP_Table').html('<span style="text-align:center;">無Price</span>');
                        }

                    }
                });
            }
            else {
                alert('Please re-search or notify IT.');
            }
        };

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

    .Call_Product_Tool{
            border-radius: 4px;
            border:5px blue none;
            text-shadow: 0 1px 1px rgba(0, 0, 0, 0.2);
            background: Gainsboro;
        }
        .Call_Product_Tool:hover {
            opacity: 0.8;
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

    <div id="PAD_Div_Basic" class="PAD_Div_D" style="height:70vh;overflow: auto;">
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
                    <select id="PAD_DDL_M2_PS" PAD_DT_Fill_Name="產品狀態" disabled="disabled" style="width: 100%;height:28.5px;">
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
                <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Remark_Develop%></td>
                <td style="text-align: left; width: 15%;" colspan="3">
                    <input id="PAD_TB_M2_Remark_D" PAD_DT_Fill_Name="備註給開發" disabled="disabled" style="width: 100%;" />
                </td>
                <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Remark_Purchase%></td>
                <td style="text-align: left; width: 15%;" colspan="3">
                    <input id="PAD_TB_M2_Remark_P" PAD_DT_Fill_Name="備註給採購" disabled="disabled" style="width: 100%;" />
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

    <div id="PAD_Div_Supplier" class="PAD_Div_D" style="display: none;">
        <table style="font-size: 15px; border-collapse: separate; border-spacing: 0px 8px;width:100%;">
            <tr>
                <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Supplier_No%></td>
                <td style="text-align: left; width: 15%;">
                    <input id="PAD_DS_TB_S_No" PAD_DT_Fill_Name="廠商編號" disabled="disabled" style="width: 100%;" />
                </td>
                <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Supplier_Short_Name%></td>
                <td style="text-align: left; width: 15%;">
                    <input id="PAD_DS_TB_S_SName" PAD_DT_Fill_Name="廠商簡稱" disabled="disabled" style="width: 100%;" />
                </td>
                <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Nation%></td>
                <td style="text-align: left; width: 15%;">
                    <input id="PAD_DS_TB_Nation" PAD_DT_Fill_Name="國名" disabled="disabled" style="width: 100%;" />
                </td>
                <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Account_Class%></td>
                <td style="text-align: left; width: 15%;">
                    <input id="PAD_DS_TB_AC" PAD_DT_Fill_Name="帳務分類" disabled="disabled" style="width: 100%;" />
                </td>
            </tr>
            <tr>
                <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Supplier_Name%></td>
                <td style="text-align: left; width: 15%;" colspan="5">
                    <input id="PAD_DS_TB_S_Name" PAD_DT_Fill_Name="廠商名稱" disabled="disabled" style="width: 100%;" />
                </td>
                <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Z%></td>
                <td style="text-align: left; width: 15%;">
                    <input id="PAD_DS_TB_Pin" PAD_DT_Fill_Name="注音" disabled="disabled" style="width: 100%;" />
                </td>
            </tr>
            <tr>
                <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Purchase_Person%></td>
                <td style="text-align: left; width: 15%;">
                    <input id="PAD_DS_TB_PP" PAD_DT_Fill_Name="連絡人採購" disabled="disabled" style="width: 100%;" />
                </td>
                <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Payment_Terms%></td>
                <td style="text-align: left; width: 15%;">
                    <input id="PAD_DS_TB_PT" PAD_DT_Fill_Name="付款條件" disabled="disabled" style="width: 100%;" />
                </td>
                <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Develop_Person%></td>
                <td style="text-align: left; width: 15%;">
                    <input id="PAD_DS_TB_DP" PAD_DT_Fill_Name="連絡人開發" disabled="disabled" style="width: 100%;" />
                </td>
                <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Assembly%></td>
                <td style="text-align: left; width: 15%;">
                    <input id="PAD_DS_TB_PC" PAD_DT_Fill_Name="連絡人裝配" disabled="disabled" style="width: 100%;" />
                </td>
            </tr>
            <tr>
                <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Tel%></td>
                <td style="text-align: left; width: 15%;">
                    <input id="PAD_DS_TB_Tel" PAD_DT_Fill_Name="電話" disabled="disabled" style="width: 100%;" />
                </td>
                <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Fax%></td>
                <td style="text-align: left; width: 15%;">
                    <input id="PAD_DS_TB_Fax" PAD_DT_Fill_Name="傳真" disabled="disabled" style="width: 100%;" />
                </td>
                <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Phone%></td>
                <td style="text-align: left; width: 15%;">
                    <input id="PAD_DS_TB_Phone" PAD_DT_Fill_Name="行動電話" disabled="disabled" style="width: 100%;" />
                </td>
                <td style="text-align: right; text-wrap: none; width: 10%;">Mail</td>
                <td style="text-align: left; width: 15%;">
                    <input id="PAD_DS_TB_Mail" PAD_DT_Fill_Name="email採購" disabled="disabled" style="width: 100%;" />
                </td>
            </tr>
            <tr>
                <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Company_Address%></td>
                <td style="text-align: left; width: 15%;" colspan="3">
                    <input id="PAD_DS_TB_CA" PAD_DT_Fill_Name="公司地址" disabled="disabled" style="width: 100%;" />
                </td>
                <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Factory_Address%></td>
                <td style="text-align: left; width: 15%;" colspan="3">
                    <input id="PAD_DS_TB_FA" PAD_DT_Fill_Name="工廠地址" disabled="disabled" style="width: 100%;" />
                </td>
            </tr>
        </table>
    </div>
    
    <div id="PAD_Div_Cost" class="PAD_Div_D" style="display: none;height:70vh; overflow: auto;">
        Cost
    </div>

    <div id="PAD_Div_Price" class="PAD_Div_D" style="display: none;height:70vh; overflow: auto;">
        <table id="PAD_DP_Table" style="width: 99%;" class="table table-striped table-bordered">
            <thead></thead>
            <tbody></tbody>
        </table>
    </div>
</div>
