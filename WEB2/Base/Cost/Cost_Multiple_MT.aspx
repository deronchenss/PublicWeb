<%@ Page Title="Cost Multiple Maintenance" Language="C#" MasterPageFile="~/MP.master" AutoEventWireup="true" %>
<%@ Register TagPrefix="uc1" TagName="uc1" Src="~/User_Control/Dia_Supplier_Selector.ascx" %>
<%@ Register TagPrefix="uc2" TagName="uc2" Src="~/User_Control/Dia_Product_ALL.ascx" %>
<%@ Register TagPrefix="uc4" TagName="uc4" Src="~/User_Control/Dia_Duo_Datetime_Picker.ascx" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <link href="/css/dataTables.bootstrap4.min.css" rel="stylesheet" />
    <script src="/js/jquery.dataTables.min.js"></script>
    <script src="/js/dataTables.bootstrap4.min.js"></script>

    <script type="text/javascript">
        $(document).ready(function () {
            var Edit_Mode;
            var IMG_Has_Read = false;
            DDL_DataBind("寄送袋子", $('#RPAT_DDL_Bag'));
            DDL_DataBind("寄送吊卡I", $('#RPAT_DDL_Card'));
            DDL_DataBind("特殊包裝", $('#RPAT_DDL_SP_PKG'));
            //var Click_tr_IDX;
            document.body.style.overflow = 'hidden';
            //Search_Cost();//WD
            //Form_Mode_Change("Search");//WD

            $('#BT_Supplier_Selector').on('click', function () {
                $("#Search_Supplier_Dialog").dialog('open');
            });

            $('#SSD_Table_Supplier').on('click', '.SUP_SEL', function () {
                $('#TB_S_No').val($(this).parent().parent().find('td:nth(2)').text());
                $('#TB_S_SName').val($(this).parent().parent().find('td:nth(3)').text());
                $("#Search_Supplier_Dialog").dialog('close');
            });

            $('#BT_Search').on('click', function () {
                Form_Mode_Change("Search");
                Search_Cost();
            });

            $('#BT_Edit').on('click', function () {
                var E_Json = [];
                $('#Table_Exec_Data tbody tr').each(function (j) {
                    var Exec_Obj = {};
                    $(this).find('.Edit_Data').each(function (i) {
                        switch ($(this).attr('type')) {
                            case "checkbox":
                                Exec_Obj[$(this).attr('Column_Name')] = $(this).prop('checked');//($(this).prop('checked')) ? "1" : "0";
                                break;
                            case "number":
                                Exec_Obj[$(this).attr('Column_Name')] = parseFloat($(this).val()) || 0;
                                break;
                            default:
                                Exec_Obj[$(this).attr('Column_Name')] = $(this).val();
                                break;
                        }
                    })
                    Exec_Obj["更新人員"] = "<%=(Session["Account"] == null) ? "Ivan10" : Session["Name"].ToString().Trim() %>";
                    Exec_Obj["序號"] = $(this).find('.SEQ').text();
                    E_Json.push(Exec_Obj);
                    console.warn(Exec_Obj);
                });

                $.ajax({
                    url: "/Base/Cost/Ashx/Cost_MMT.ashx",
                    data: {
                        "Call_Type": "Cost_MMT_Update",
                        "Exec_Data": JSON.stringify(E_Json)
                    },
                    cache: false,
                    async: false,
                    type: "POST",
                    datatype: "json",
                    contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                    success: function (R) {
                        alert('儲存完成');
                        console.warn(R);
                        $('#Table_Exec_Data').html('');
                        $('#Div_Edit_Area input').not('[type=button]').val('');

                        $('#Table_Exec_Data_info').text('Showing 0 entries');
                        Form_Mode_Change("Search");
                        Search_Cost();
                    },
                    error: function (ex) {
                        alert(ex);
                    }
                });
            });

            function Re_Bind_Inner_JS() {
                $('.Call_Product_Tool').off('click');
                $('.Call_Product_Tool').on('click', function (e) {
                    e.stopPropagation();
                    $('#PAD_HDN_SUPLU_SEQ').val($(this).attr('SUPLU_SEQ'));
                    $("#Product_ALL_Dialog").dialog('open');
                });
            };

            function Form_Mode_Change(Form_Mode) {
                switch (Form_Mode) {
                    case "Base":
                        Edit_Mode = "Base";
                        $('.V_BT').attr('disabled', false);
                        $('#V_BT_Master').attr('disabled', 'disabled');
                        $('#Div_DT_View, #Div_Data_Control, #Div_Exec_Data, #Div_Edit_Area').toggle(false);
                        $('#RB_DV_DIMG').prop('checked', true);
                        $('input[type=radio][name=DIMG]').attr('disabled', 'disabled');
                        break;
                    case "Search":
                        Edit_Mode = "Can_Move";
                        $('.V_BT').attr('disabled', false);
                        $('#V_BT_Master').attr('disabled', 'disabled');
                        $('#Div_DT_View, #Div_Data_Control, #Div_Exec_Data').toggle(true);
                        $('.ED_CB').toggle(false);//動態TH_CB
                        $('#Div_Edit_Area').toggle(false);
                        $('#RB_DV_DIMG').prop('checked', true);
                        $('input[type=radio][name=DIMG]').attr('disabled', false);
                        $('#Div_DT_View').css('width', '60%');
                        $('#Div_Exec_Data').css('width', '35%');
                        $('#Div_Exec_Data').css('float', 'Right');
                        //Click_tr_IDX = null;
                        $('#Table_Exec_Data tbody tr').css('background-color', '');
                        $('#Table_Exec_Data tbody tr').css('color', 'black');
                        Restore_Element();
                        break;
                    case "Edit_Data":
                        Edit_Mode = "Edit";
                        $('.V_BT').attr('disabled', false);
                        $('#V_BT_Edit').attr('disabled', 'disabled');
                        $('#Div_DT_View, #Div_Data_Control').toggle(false);
                        $('.ED_CB').toggle(true);//動態TH_CB
                        $('#Div_Edit_Area').toggle(true);
                        $('#Div_Exec_Data').css('width', '60%');
                        $('#Div_Exec_Data').css('float', 'left');
                        $('#Div_Edit_Area').css('width', '39%');
                        Change_View_Element();
                        break;
                }
            }

            function Restore_Element() {
                $('#Div_Exec_Data tbody tr td[Original_Data]').each(function () {
                    $(this).html($(this).attr('Original_Data'));
                });
            };

            function Change_View_Element() {
                $('#Div_Exec_Data .Change_VE').each(function () {
                    $(this).attr('Original_Data', $(this).text());
                    switch ($(this).attr('colType')) {
                        case "CB":
                            $(this).html('<input class="Edit_Data" Column_Name="' + $(this).attr('colDB') + '" type="checkbox" style="width: 1.15em;height: 1.15em;border: 0.15em solid currentColor;" ' + (($(this).text() == "true") ? 'checked="checked"' : '') + '/>');
                            $(this).parent().css('text-align','center');
                            break;
                        case "DDL":
                            var DDL_HTML;
                            var O_Text = $(this).text();
                            switch ($(this).attr('colDB')) {
                                case "寄送袋子":
                                    DDL_HTML = $('#RPAT_DDL_Bag').html();
                                    break;
                                case "寄送吊卡":
                                    DDL_HTML = $('#RPAT_DDL_Card').html();
                                    break;
                                case "特殊包裝":
                                    DDL_HTML = $('#RPAT_DDL_SP_PKG').html();
                                    break;
                            }
                            $(this).html('<select class="Edit_Data" Column_Name="' + $(this).attr('colDB') + '">' + DDL_HTML + '</select>');
                            $(this).find('select').val(O_Text);
                            break;
                        case "DATE":
                            $(this).html('<input type="date" class="Edit_Data" Column_Name="' + $(this).attr('colDB') + '" value="' + $(this).text() + '"/>');
                            break;
                        case "MTTB":
                            $(this).html('<textarea class="Edit_Data" Column_Name="' + $(this).attr('colDB') + '">' + $(this).text() + '</textarea>');
                            break;
                        case "NUM":
                            $(this).html('<input type="number" style="text-align:right;width:80px;" min="0" step="0.1" class="Edit_Data" Column_Name="' + $(this).attr('colDB') + '" value="' + $(this).text().replace(',', '') + '"/>');
                            break;
                        case "NUM_INT":
                            $(this).html('<input type="number" style="text-align:right;width:80px;" min="0" step="1" class="Edit_Data" Column_Name="' + $(this).attr('colDB') + '" value="' + $(this).text().replace(',', '') + '"/>');
                            break;
                        default:
                            $(this).html('<input class="Edit_Data" Column_Name="' + $(this).attr('colDB') + '" value="' + $(this).text() + '"/>');
                            break;
                    }
                });
                $('#Div_Exec_Data .Edit_Data[Column_Name=單位]').css('width', '80px');
            };

            $('#V_BT_Master').on('click', function () {
                Form_Mode_Change("Search");
            });

            $('.V_BT').on('click', function () {
                $('.V_BT').attr('disabled', false);
                $(this).attr('disabled', 'disabled');
            });

            $('#BT_Next, #V_BT_Edit').on('click', function () {
                Form_Mode_Change("Edit_Data");
                //Click_tr_IDX = 0;
                //FN_Tr_Click($('#Table_Exec_Data tbody tr:nth(' + Click_tr_IDX + ')'));
            });
            //$('.V_Report').on('click', function () {
            //    Form_Mode_Change("Edit_Data");
            //    $('[Control_By]').toggle(false);
            //    $('[Control_By=' + $(this).prop('id') + ']').toggle(true);
            //});
            function Search_Cost() {
                $.ajax({
                    url: "/Base/Cost/Ashx/Cost_MMT.ashx",
                    data: {
                        "Call_Type": "Cost_MMT_Search",
                        "IM": $('#TB_IM').val(),
                        "SupM": $('#TB_SupM').val(),
                        "S_No": $('#TB_S_No').val(),
                        "S_SName": $('#TB_S_SName').val(),
                        "N_DS": $('#TB_Date_S1').val(),
                        "N_DE": $('#TB_Date_E1').val(),
                        "LCACD_DS": $('#TB_Date_S2').val(),
                        "LCACD_DE": $('#TB_Date_E2').val(),
                        "PI": $('#TB_PI').val()
                    },
                    cache: false,
                    async: false,
                    type: "POST",
                    datatype: "json",
                    contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                    success: function (R) {
                        //console.warn(R);
                        if (R.length === 0) {
                            alert('<%=Resources.MP.Data_Not_Exists_Alert%>');
                            Form_Mode_Change("Base");
                        }
                        else {
                            var Table_HTML =
                                '<thead>\
                                    <tr>\
                                        <th>' + '<%=Resources.MP.Developing%>' + '</th>\
                                        <th>' + '<%=Resources.MP.Product_Status%>' + '</th>\
                                        <th>' + '<%=Resources.MP.Ivan_Model%>' + '</th>\
                                        <th>' + '<%=Resources.MP.Sale_Model%>' + '</th>\
                                        <th>' + '<%=Resources.MP.Supplier_Model%>' + '</th>\
                                        <th>' + '<%=Resources.MP.Supplier_Short_Name%>' + '</th>\
                                        <th>' + '<%=Resources.MP.Unit%>' + '</th>\
                                        <th>' + '<%=Resources.MP.Price_TWD%>' + '</th>\
                                        <th>' + '<%=Resources.MP.Price_USD%>' + '</th>\
                                        <th>' + '<%=Resources.MP.Currency%>' + '</th>\
                                        <th>' + '<%=Resources.MP.Price_Curr%>' + '</th>\
                                        <th>' + '<%=Resources.MP.Last_Check_And_Accept_Day%>' + '</th>\
                                        <th>' + '<%=Resources.MP.Last_Price_Day%>' + '</th>\
                                        <th>' + '<%=Resources.MP.Price_T%>_2' + '</th>\
                                        <th>' + '<%=Resources.MP.Price_T%>_3' + '</th>\
                                        <th>MIN_1</th>\
                                        <th>MIN_2</th>\
                                        <th>MIN_3</th>\
                                        <th class="DIMG">' + '<%=Resources.MP.Image%>' + '</th>\
                                        <th>' + '<%=Resources.MP.Product_Information%>' + '</th>\
                                        <th>' + '<%=Resources.MP.Sample_Product_No%>' + '</th>\
                                        <th>' + '<%=Resources.MP.Remark_Develop%>' + '</th>\
                                        <th>' + '<%=Resources.MP.Remark_Purchase%>' + '</th>\
                                        <th>' + '<%=Resources.MP.Add_Date%>' + '</th>\
                                        <th>' + '<%=Resources.MP.Stop_Date%>' + '</th>\
                                        <th>UnActive</th>\
                                        <th>' + '<%=Resources.MP.Supplier_No%>' + '</th>\
                                        <th>' + '<%=Resources.MP.Net_Weight%>' + '</th>\
                                        <th>' + '<%=Resources.MP.Gross_Weight%>' + '</th>\
                                        <th>' + '<%=Resources.MP.Outerbox_No%>' + '</th>\
                                        <th>' + '<%=Resources.MP.Outerbox_Lenght%>' + '</th>\
                                        <th>' + '<%=Resources.MP.Outerbox_Weight%>' + '</th>\
                                        <th>' + '<%=Resources.MP.Outerbox_Height%>' + '</th>\
                                        <th>' + '<%=Resources.MP.Innerbox_Capacity%>' + '</th>\
                                        <th>' + '<%=Resources.MP.Innerbox_Amount%>' + '</th>\
                                        <th>' + '<%=Resources.MP.Innerbox_Amount_2%>' + '</th>\
                                        <th>' + '<%=Resources.MP.Unit%><%=Resources.MP.Speace%><%=Resources.MP.Net_Weight%>' + '</th>\
                                        <th>' + '<%=Resources.MP.Unit%><%=Resources.MP.Speace%><%=Resources.MP.Gross_Weight%>' + '</th>\
                                        <th>' + '<%=Resources.MP.Product_Length%>' + '</th>\
                                        <th>' + '<%=Resources.MP.Product_Weight%>' + '</th>\
                                        <th>' + '<%=Resources.MP.Product_Height%>' + '</th>\
                                        <th>' + '<%=Resources.MP.Package_Length%>' + '</th>\
                                        <th>' + '<%=Resources.MP.Package_Weight%>' + '</th>\
                                        <th>' + '<%=Resources.MP.Package_Height%>' + '</th>\
                                        <th>寄送袋子</th>\
                                        <th>寄送吊卡</th>\
                                        <th>特殊包裝</th>\
                                        <th>\
                                            <input class="ED_CB" style="display:none;" type="checkbox" onchange=$("input:checkbox").prop("checked",$(this).prop("checked")); />自有條碼\
                                        </th>\
                                        <th>' + '<%=Resources.MP.SEQ%>' + '</th>\
                                        <th>' + '<%=Resources.MP.Update_User%>' + '</th>\
                                        <th>' + '<%=Resources.MP.Update_Date%>' + '</th>\
                                   </tr>\
                            </thead>\
                            <tbody>';

                            $(R).each(function (i) {
                                Table_HTML +=
                                    '<tr>\
                                    <td>' + String(R[i].開發中 ?? "") + '</td>\
                                    <td>' + String(R[i].產品狀態 ?? "") + '</td>\
                                    <td>\
                                        <input class="Call_Product_Tool" SUPLU_SEQ = "' + String(R[i].序號 ?? "") + '" \
                                               type="button" value="' + String(R[i].頤坊型號 ?? "") + '" \
                                               style="text-align:left;width:100%;z-index:1000;' + ((R[i].Has_IMG) ? 'background: #90ee90;' : '') + '" />\
                                    </td>\
                                    <td>' + String(R[i].銷售型號 ?? "").trim() + '</td>\
                                    <td class="Change_VE" colDB="廠商型號">' + String(R[i].廠商型號 ?? "").trim() + '</td>\
                                    <td>' + String(R[i].廠商簡稱 ?? "").trim() + '</td>\
                                    <td class="Change_VE" colDB="單位">' + String(R[i].單位 ?? "").trim() + '</td>\
                                    <td class="Change_VE" colType="NUM" colDB="台幣單價" style="text-align:right;">' + String(R[i].台幣單價 ?? "").replace(/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ",") + '</td>\
                                    <td class="Change_VE" colType="NUM" colDB="美元單價" style="text-align:right;">' + String(R[i].美元單價 ?? "").replace(/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ",") + '</td>\
                                    <td>' + String(R[i].幣別 ?? "") + '</td>\
                                    <td class="Change_VE" colType="NUM" colDB="外幣單價" style="text-align:right;">' + String(R[i].外幣單價 ?? "").replace(/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ",") + '</td>\
                                    <td>' + String(R[i].最後點收日 ?? "") + '</td>\
                                    <td class="Change_VE" colType="DATE" colDB="最後單價日">' + String(R[i].最後單價日 ?? "") + '</td>\
                                    <td class="Change_VE" colType="NUM" colDB="單價_2" style="text-align:right;">' + String(R[i].單價_2 ?? "").replace(/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ",") + '</td>\
                                    <td class="Change_VE" colType="NUM" colDB="單價_3" style="text-align:right;">' + String(R[i].單價_3 ?? "").replace(/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ",") + '</td>\
                                    <td class="Change_VE" colType="NUM_INT" colDB="MIN_1" style="text-align:right;">' + String(R[i].MIN_1 ?? "").replace(/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ",") + '</td>\
                                    <td class="Change_VE" colType="NUM_INT" colDB="MIN_2" style="text-align:right;">' + String(R[i].MIN_2 ?? "").replace(/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ",")+ '</td>\
                                    <td class="Change_VE" colType="NUM_INT" colDB="MIN_3" style="text-align:right;">' + String(R[i].MIN_3 ?? "").replace(/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ",")+ '</td>\
                                    <td class="DIMG" style="text-align:center; height:100px; vertical-align:middle;">' +
                                    ((R[i].Has_IMG) ? ('<img type="Product" SEQ="' + String(R[i].序號 ?? "") + '" />') : ('<%=Resources.MP.Image_NotExists%>')) +
                                    '</td>\
                                    <td class="Change_VE" colType="MTTB" colDB="產品說明">' + String(R[i].產品說明 ?? "").trim() + '</td>\
                                    <td>' + String(R[i].暫時型號 ?? "") + '</td>\
                                    <td class="Change_VE" colType="MTTB" colDB="備註給開發">' + String(R[i].備註給開發 ?? "").trim() + '</td>\
                                    <td class="Change_VE" colType="MTTB" colDB="備註給採購">' + String(R[i].備註給採購 ?? "").trim() + '</td>\
                                    <td>' + String(R[i].新增日期 ?? "") + '</td>\
                                    <td>' + String(R[i].停用日期 ?? "") + '</td>\
                                    <td>' + String(R[i].UnActive ?? "") + '</td>\
                                    <td>' + String(R[i].廠商編號 ?? "") + '</td>\
                                    <td class="Change_VE" colType="NUM" style="text-align:right;" colDB="淨重">' + String(R[i].淨重 ?? "") + '</td>\
                                    <td class="Change_VE" colType="NUM" style="text-align:right;" colDB="毛重">' + String(R[i].毛重 ?? "") + '</td>\
                                    <td class="Change_VE" colDB="外箱編號">' + String(R[i].外箱編號 ?? "") + '</td>\
                                    <td class="Change_VE" colType="NUM" style="text-align:right;" colDB="外箱長度">' + String(R[i].外箱長度 ?? "") + '</td>\
                                    <td class="Change_VE" colType="NUM" style="text-align:right;" colDB="外箱寬度">' + String(R[i].外箱寬度 ?? "") + '</td>\
                                    <td class="Change_VE" colType="NUM" style="text-align:right;" colDB="外箱高度">' + String(R[i].外箱高度 ?? "") + '</td>\
                                    <td class="Change_VE" colType="NUM" style="text-align:right;" colDB="內盒容量">' + String(R[i].內盒容量 ?? "") + '</td>\
                                    <td class="Change_VE" colType="NUM_INT" style="text-align:right;" colDB="內盒數">' + String(R[i].內盒數 ?? "") + '</td>\
                                    <td class="Change_VE" colType="NUM_INT" style="text-align:right;" colDB="內箱數">' + String(R[i].內箱數 ?? "") + '</td>\
                                    <td class="Change_VE" colType="NUM" style="text-align:right;" colDB="單位淨重">' + String(R[i].單位淨重 ?? "") + '</td>\
                                    <td class="Change_VE" colType="NUM" style="text-align:right;" colDB="單位毛重">' + String(R[i].單位毛重 ?? "") + '</td>\
                                    <td class="Change_VE" colType="NUM" style="text-align:right;" colDB="產品長度">' + String(R[i].產品長度 ?? "") + '</td>\
                                    <td class="Change_VE" colType="NUM" style="text-align:right;" colDB="產品寬度">' + String(R[i].產品寬度 ?? "") + '</td>\
                                    <td class="Change_VE" colType="NUM" style="text-align:right;" colDB="產品高度">' + String(R[i].產品高度 ?? "") + '</td>\
                                    <td class="Change_VE" colType="NUM" style="text-align:right;" colDB="包裝長度">' + String(R[i].包裝長度 ?? "") + '</td>\
                                    <td class="Change_VE" colType="NUM" style="text-align:right;" colDB="包裝寬度">' + String(R[i].包裝寬度 ?? "") + '</td>\
                                    <td class="Change_VE" colType="NUM" style="text-align:right;" colDB="包裝高度">' + String(R[i].包裝高度 ?? "") + '</td>\
                                    <td class="Change_VE" colType="DDL" colDB="寄送袋子">' + String(R[i].寄送袋子 ?? "") + '</td>\
                                    <td class="Change_VE" colType="DDL" colDB="寄送吊卡">' + String(R[i].寄送吊卡 ?? "") + '</td>\
                                    <td class="Change_VE" colType="DDL" colDB="特殊包裝">' + String(R[i].特殊包裝 ?? "") + '</td>\
                                    <td class="Change_VE" colType="CB" colDB="自有條碼">' + String(R[i].自有條碼 ?? "") + '</td>\
                                    <td class="SEQ">' + String(R[i].序號 ?? "") + '</td>\
                                    <td>' + String(R[i].更新人員 ?? "") + '</td>\
                                    <td>' + String(R[i].更新日期 ?? "") + '</td>\
                                </tr>';
                            });

                            Table_HTML += '</tbody>';
                            $('#Table_Search_Cost').html(Table_HTML);

                            $('.DIMG').toggle(!$('#RB_DV_DIMG').prop('checked'));
                            $('#Table_Search_Cost_info').text('Showing ' + $('#Table_Search_Cost > tbody tr').length + ' entries');
                            IMG_Has_Read = false;//初始化IMG讀取

                            $('#Table_Search_Cost').css('white-space', 'nowrap');
                            $('#Table_Search_Cost thead th').css('text-align', 'center');
                            $('#Table_Search_Cost tbody td').css('vertical-align', 'middle');
                            $('#Table_Search_Cost tbody td').filter(function () { return parseFloat($(this).text()) === 0; }).text('');
                            Re_Bind_Inner_JS();
                        }
                    },
                    error: function (ex) {
                        //alert(ex);
                        console.warn(ex);
                    }
                });
            };

            $('input[type=radio][name=DIMG]').on('click', function () {
                var Show_IMG = false;
                $('.DIMG').toggle(!$('#RB_DV_DIMG').prop('checked'));

                switch ($(this).prop('id')) {
                    case "RB_DV_DIMG":
                        break;
                    case "RB_V_DIMG":
                        Show_IMG = true;
                        $('.DIMG img').css({ 'max-height': '', 'max-width': '' });
                        break;
                    case "RB_SM_DIMG":
                        Show_IMG = true;
                        $('.DIMG img').css({ 'max-height': '100px', 'max-width': '100px' });
                        break;
                }
                if (Show_IMG && !IMG_Has_Read) {
                    FN_GET_IMG($('#Table_Exec_Data img[type=Product]'));
                    FN_GET_IMG($('#Table_Search_Cost img[type=Product]'));
                }
                function FN_GET_IMG(IMG) {//取得順序調整，Exec優先
                    $(IMG).each(function (i) {
                        var IMG_SEL = $(this);
                        var binary = '';
                        $.ajax({
                            url: "/Base/BOM/BOM_Search.ashx",
                            data: {
                                "Call_Type": "GET_IMG",
                                "SUPLU_SEQ": $(this).attr('SEQ')
                            },
                            cache: false,
                            type: "POST",
                            datatype: "json",
                            contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                            success: function (RR) {
                                var bytes = new Uint8Array(RR[0].P_IMG);
                                var len = bytes.byteLength;
                                for (var j = 0; j < len; j++) {
                                    binary += String.fromCharCode(bytes[j]);
                                }
                                var SRC = 'data:image/png;base64,' + window.btoa(binary);
                                IMG_SEL.attr('src', SRC);
                            }
                        });
                    });
                    IMG_Has_Read = true;
                }
            });

            function Item_Move(click_tr, ToTable, FromTable, Full) {
                if (Edit_Mode == "Can_Move") {
                    if (ToTable.find('tbody tr').length === 0) {
                        ToTable.html(FromTable.find('thead').clone());
                        ToTable.append('<tbody></tbody>');
                        ToTable.find('thead th').css('text-align', 'center');
                        ToTable.css('white-space', 'nowrap');
                    }
                    if (Full) {
                        FromTable.find('.SEQ').each(function () {
                            var OT = $(this).text();
                            if (ToTable.find('.SEQ').filter(function () { return $(this).text() == OT; }).length === 0) {
                                ToTable.append($(this).parent().clone());
                            }
                            else {
                                console.warn($(this));
                            }
                            $(this).parent().remove();
                        });
                    }
                    else {
                        if (ToTable.find('.SEQ').filter(function () { return $(this).text() == click_tr.find('.SEQ').text(); }).length === 0) {
                            ToTable.append(click_tr.clone());
                        }
                        click_tr.remove();
                    }
                    if (FromTable.find('tbody tr').length === 0) {
                        FromTable.html('');
                    }
                    $('#Table_Exec_Data_info').text('Showing ' + $('#Table_Exec_Data > tbody tr').length + ' entries');
                    $('#Table_Search_Cost_info').text('Showing ' + $('#Table_Search_Cost > tbody tr').length + ' entries');

                    $('.Exist_Select').toggle(Boolean($('#Table_Exec_Data').find('tbody tr').length > 0));

                    Re_Bind_Inner_JS();
                }
            }

            $('#Table_Search_Cost').on('click', 'tbody tr', function () {
                Item_Move($(this), $('#Table_Exec_Data'), $('#Table_Search_Cost'), false);
            });
            $('#Table_Exec_Data').on('click', 'tbody tr', function () {
                switch (Edit_Mode) {
                    case "Can_Move":
                        Item_Move($(this), $('#Table_Search_Cost'), $('#Table_Exec_Data'), false);
                        break;
                    case "Edit":
                        //Click_tr_IDX = $(this).index();
                        //FN_Tr_Click($(this));
                        break;
                }
            });
            $('#BT_ATR').on('click', function () {
                Item_Move($(this), $('#Table_Exec_Data'), $('#Table_Search_Cost'), true);
            });
            $('#BT_ATL').on('click', function () {
                Item_Move($(this), $('#Table_Search_Cost'), $('#Table_Exec_Data'), true);
            });

            //$(window).keydown(function (e) {
            //    if (Click_tr_IDX != null) {
            //        switch (e.keyCode) {
            //            case 38://^
            //                if (Click_tr_IDX > 0) {
            //                    Click_tr_IDX -= 1;
            //                }
            //                FN_Tr_Click($('#Table_Exec_Data tbody tr:nth(' + Click_tr_IDX + ')'));
            //                break;
            //            case 40://v
            //                if (Click_tr_IDX < ($('#Table_Exec_Data tbody tr').length - 1)) {
            //                    Click_tr_IDX += 1;
            //                }
            //                FN_Tr_Click($('#Table_Exec_Data tbody tr:nth(' + Click_tr_IDX + ')'));
            //                break;
            //        }
            //    }
            //});

            //function FN_Tr_Click(Click_tr) {
            //    Click_tr.parent().find('tr').css('background-color', '');
            //    Click_tr.parent().find('tr').css('color', 'black');
            //    Click_tr.css('background-color', '#5a1400');
            //    Click_tr.css('color', 'white');

            //    $('#DOT_TB_IM').val(Click_tr.find('td').eq(1).find('input').val());
            //    $('#DDT_HDN_D_SUPLU_SEQ').val(Click_tr.find('td').eq(1).find('input').attr('SUPLU_SEQ'));
            //    $('#DOT_TB_S_ALL').val(Click_tr.find('td').eq(0).text());
            //    $('#DOT_TB_PI').val(Click_tr.find('td').eq(9).text());
            //};

            $('#Div_Edit_Area input[Replace_Target][Data_By]').on('click', function () {
                var Data_By_Element = "#" + $(this).attr('Data_By');
                $('[column_name=' + $(this).attr('Replace_Target') + ']').val($(Data_By_Element).val());
            });

            $('#Table_Search_Cost, #Table_Exec_Data').on('click', 'thead th', function () {//Sort
                $(this).siblings().removeClass('focus');
                $(this).addClass('focus');
                //$(this).siblings().text().replace('▲','').replace('▼', '');

                var Sort_Table = $(this).parents('table');
                var IDX = $(this).index();

                if ($(this).is('.asc')) {
                    $(this).removeClass('asc');
                    $(this).addClass('desc selected');
                    sortOrder = -1;
                } else {
                    $(this).addClass('asc selected');
                    $(this).removeClass('desc');
                    sortOrder = 1;
                }
                $(this).siblings().removeClass('asc selected desc selected');
                var arrData = Sort_Table.find('tbody>tr:has(td)').get();
                //console.warn($(this).text());

                arrData.sort(function (a, b) {
                    var val1 = $(a).children('td').eq(IDX).text().trim();
                    if (val1.length == 0) {
                        val1 = $(a).children('td').eq(IDX).find('input').val();
                    }

                    var val2 = $(b).children('td').eq(IDX).text().trim();
                    if (val2.length == 0) {
                        val2 = $(b).children('td').eq(IDX).find('input').val();
                    }

                    if ($.isNumeric(val1) && $.isNumeric(val2))
                        return sortOrder == 1 ? val1 - val2 : val2 - val1;
                    else
                        return (val1 < val2) ? -sortOrder : (val1 > val2) ? sortOrder : 0;
                });
                $.each(arrData, function (index, row) {
                    Sort_Table.find('tbody').append(row);
                });
            });

            function DDL_DataBind(Call_Code, Bind_Element) {
                //RPAT_DDL_Card
                $.ajax({
                    url: "/Web_Service/DDL_DataBind.asmx/REF_Data_Basic",
                    data: "{'Call_Code': '" + Call_Code + "'}",
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
                        Bind_Element.html(DDL_Option);
                    },
                    error: function (response) {
                        alert(response.responseText);
                    },
                });
            };
        });
    </script>

    <style type="text/css">
        .M_BT {
            background-color: azure;
            font-weight: bold;
            border: none;
            cursor: pointer;
            font-size: large;
            text-align: center;
            text-decoration: none;
        }
            .M_BT:hover {
                background-color: #f8981d;
                color: white;
            }
        #Table_Search_Cost tbody tr:hover, #Table_Exec_Data tbody tr:hover{
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
        .BTN_Green {
            color: white;
            border-radius: 4px;
            border:5px blue none;
            text-shadow: 0 1px 1px rgba(0, 0, 0, 0.2);
            background: rgb(28, 184, 65);
        }
        .BTN_Green:hover {
            opacity: 0.8;
        }
        .U_Element:hover {
            opacity: 0.8;
        }
        table thead tr th {
            background-color:white;
            position: sticky;
            top: 0; /* 凍結th */
        }
    </style>
    <uc1:uc1 ID="uc1" runat="server" /> 
    <uc2:uc2 ID="uc2" runat="server" /> 
    <uc4:uc4 ID="uc4" runat="server" /> 

    <table class="table_th" style="text-align: left;">
        <tr>
            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Ivan_Model%></td>
            <td style="text-align: left; width: 15%;">
                <input id="TB_IM" autocomplete="off" style="width: 100%;" />
            </td>
            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Supplier_Model%></td>
            <td style="text-align: left; width: 15%;">
                <input id="TB_SupM" autocomplete="off" style="width: 100%;" />
            </td>
            
            <td style="text-align: right; text-wrap: none; width: 10%;" rowspan="2">
                <%=Resources.MP.Supplier_No%>
                <br />
                <%=Resources.MP.Supplier_Short_Name%>
            </td>
            <td style="text-align: left; width: 15%;" rowspan="2">
                <div style="width: 90%; float: left; z-index: -10;">
                    <input id="TB_S_No" style="width: 100%; z-index: -10;" />
                    <br />
                    <input id="TB_S_SName" style="width: 111%; z-index: -10;" />
                </div>
                <div style="width: 10%; float: right; z-index: 10;">
                    <input id="BT_Supplier_Selector" type="button" value="…" style="float: right; z-index: 10; width: 100%;" />
                </div>
            </td>
            <td style="text-align: right; text-wrap: none; width: 10%;" rowspan="2">
                <%=Resources.MP.Add_Date%>
                <br />
                <%=Resources.MP.Last_Check_And_Accept_Day%>
            </td>
            <td style="text-align: left; width: 15%;" rowspan="2">
                <div style="width: 90%; float: left; z-index: -10;">
                    <input id="TB_Date_S1" class="TB_DS1" type="date" style="width: 50%;" /><input id="TB_Date_E1" type="date" class="TB_DE1" style="width: 50%;" />
                </div>
                <div style="width: 10%; float: right; z-index: 10;">
                    <input id="BT_Duo_Datetime_Picker" type="button" value="…" style="float: right; z-index: 10; width: 100%;" onclick="$('#DDPB_HDN_DP_Control').val(1);$('#Duo_Datetime_Picker_Dialog').dialog('open');" />
                </div>
                <br />
                <div style="width: 90%; float: left; z-index: -10;">
                    <input id="TB_Date_S2" class="TB_DS2" type="date" style="width: 50%;" /><input id="TB_Date_E2" type="date" class="TB_DE2" style="width: 50%;" />
                </div>
                <div style="width: 10%; float: right; z-index: 10;">
                    <input id="BT_Duo_Datetime_Picker2" type="button" value="…" style="float: right; z-index: 10; width: 100%;" onclick="$('#DDPB_HDN_DP_Control').val(2);$('#Duo_Datetime_Picker_Dialog').dialog('open');" />
                </div>
            </td>
        </tr>
        <tr>
            <td style="text-align: right; text-wrap: none; width: 10%;" ><%=Resources.MP.Product_Information%></td>
            <td style="text-align: left; width: 40%;" colspan="3">
                <input id="TB_PI" style="width: 100%;" />
            </td>
        </tr>
        <tr>
            <td class="tdtstyleRight" colspan="7">
                <input type="button" id="BT_Search" class="M_BT" value="<%=Resources.MP.Search%>" />
            </td>
        </tr>
        <tr>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
        </tr>
    </table>
    <div style="width: 99%; margin: 0 auto; background-color: white;">
        &nbsp;
        <input id="V_BT_Master" type="button" class="V_BT" value="<%=Resources.MP.Select%>" disabled="disabled" />
        <input id="V_BT_Edit" type="button" class="V_BT Exist_Select" style="display:none;" value="<%=Resources.MP.Edit%>" />
        <%--<input id="V_BT_Report_1" type="button" class="V_BT Exist_Select V_Report" style="display:none;" value="成本分析" />--%>
    </div>
    <div>&nbsp;&nbsp;&nbsp;&nbsp;
        <input id="RB_DV_DIMG" type="radio" name="DIMG" disabled="disabled" checked="checked" />
        <label for="RB_DV_DIMG"><%=Resources.MP.Not_Show_Image%></label>
        <%--<input id="RB_V_DIMG" type="radio" name="DIMG" disabled="disabled" />
        <label for="RB_V_DIMG"><%=Resources.MP.Show_Original_Image%></label>--%>
        <input id="RB_SM_DIMG" type="radio" name="DIMG" disabled="disabled" />
        <label for="RB_SM_DIMG"><%=Resources.MP.Show_Small_Image%></label>
    </div>
    <div style="width: 98%; margin: 0 auto;">
        <div id="Div_DT_View" style="width: 60%; height: 70vh; overflow: auto; display: none; float: left;border-style:solid;border-width:1px;">
            <span class="dataTables_info" id="Table_Search_Cost_info" role="status" aria-live="polite"></span>
            <table id="Table_Search_Cost" style="width: 99%;" class="table table-striped table-bordered">
                <thead></thead>
                <tbody></tbody>
            </table>
        </div>

        <div id="Div_Data_Control" style="width: 5%; margin: 0 auto; text-align: center; height: 70vh; float: left; display: none;">
            <table style="width: 100%; height: 100%;">
                <tr>
                    <td style="width: 100%; height: 100%; vertical-align: middle;">
                        <input id="BT_ATR" type="button" value=">>" class="BTN_Green" />
                        <br />
                        <br />
                        <input id="BT_ATL" type="button" value="<<" class="BTN_Green" />
                        <br />
                        <br />
                        <input id="BT_Next" type="button" value="Next" style="inline-size: 100%; display: none;" class="BTN Exist_Select" />
                    </td>
                </tr>
            </table>
        </div>

        <div id="Div_Exec_Data" style="width: 35%; height: 70vh; overflow: auto; display: none; float: right;border-style:solid;border-width:1px; ">
            <span class="dataTables_info" id="Table_Exec_Data_info" role="status" aria-live="polite"></span>
            <table id="Table_Exec_Data" style="width: 100%;" class="table table-striped table-bordered">
                <thead></thead>
                <tbody></tbody>
            </table>
        </div>

        <div id="Div_Edit_Area" style="width: 35%; height: 70vh; overflow: auto; display: none; float: right; border-style: solid; border-width: 1px;">
            <div style="position: relative; border: 1px solid #111111; padding: 20px; box-sizing: border-box; margin: 30px auto; width: 95%;">
                <span style="position: absolute; top: -1em; left: 10%; line-height: 2em; padding: 0 1em; background-color: #fff;">批次更新選取資料</span>
                <table style="margin: 0 auto; width: 100%;" id="Reset_Area_Table">
                    <tr>
                        <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Supplier_Model%></td>
                        <td style="text-align: left; width: 30%;">
                            <div style="width: 80%; float: left; z-index: -10;">
                                <input id="RAT_TB_SupM" autocomplete="off" style="width: 100%; z-index: -10;" />
                            </div>
                            <div style="width: 20%; float: left; z-index: 10;">
                                <input Replace_Target="廠商型號" Data_By="RAT_TB_SupM" type="button" value="Reset" style="float: left; z-index: 10;" />
                            </div>
                        </td>
                        <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Unit%></td>
                        <td style="text-align: left; width: 30%;">
                            <div style="width: 80%; float: left; z-index: -10;">
                                <input id="RAT_TB_Unit" autocomplete="off" style="width: 100%; z-index: -10;" />
                            </div>
                            <div style="width: 20%; float: right; z-index: 10;">
                                <input Replace_Target="單位" Data_By="RAT_TB_Unit" type="button" value="Reset" style="float: left; z-index: 10;" />
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Product_Information%></td>
                        <td style="text-align: left; width: 30%;" colspan="3">
                            <div style="width: 91.4%; float: left; z-index: -10;">
                                <input id="RAT_TB_PI" autocomplete="off" style="width: 100%; z-index: -10;" />
                            </div>
                            <div style="width: 8.6%; float: right; z-index: 10;">
                                <input Replace_Target="產品說明" Data_By="RAT_TB_PI" type="button" value="Reset" style="float: left; z-index: 10;" />
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Price_TWD%></td>
                        <td style="text-align: left; width: 30%;">
                            <div style="width: 80%; float: left; z-index: -10;">
                                <input id="RAT_TB_P_TWD" type="number" min="0" step="0.1" autocomplete="off" style="width: 100%; z-index: -10;" />
                            </div>
                            <div style="width: 20%; float: right; z-index: 10;">
                                <input Replace_Target="台幣單價" Data_By="RAT_TB_P_TWD" type="button" value="Reset" style="float: left; z-index: 10;" />
                            </div>
                        </td>
                        <td style="text-align: right; text-wrap: none; width: 10%;" rowspan="2">MIN_1</td>
                        <td style="text-align: left; width: 30%;" rowspan="2">
                            <div style="width: 80%; float: left; z-index: -10;">
                                <input id="RAT_TB_MIN_1" type="number" min="0" step="1" autocomplete="off" style="width: 100%; z-index: -10;" />
                            </div>
                            <div style="width: 20%; float: right; z-index: 10;">
                                <input Replace_Target="MIN_1" Data_By="RAT_TB_MIN_1" type="button" value="Reset" style="float: left; z-index: 10;" />
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Price_USD%></td>
                        <td style="text-align: left; width: 30%;">
                            <div style="width: 80%; float: left; z-index: -10;">
                                <input id="RAT_TB_P_USD" type="number" min="0" step="0.1" autocomplete="off" style="width: 100%; z-index: -10;" />
                            </div>
                            <div style="width: 20%; float: right; z-index: 10;">
                                <input Replace_Target="美元單價" Data_By="RAT_TB_P_USD" type="button" value="Reset" style="float: left; z-index: 10;" />
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Price_T%>_2</td>
                        <td style="text-align: left; width: 30%;">
                            <div style="width: 80%; float: left; z-index: -10;">
                                <input id="RAT_TB_P2" type="number" min="0" step="0.1" autocomplete="off" style="width: 100%; z-index: -10;" />
                            </div>
                            <div style="width: 20%; float: right; z-index: 10;">
                                <input Replace_Target="單價_2" Data_By="RAT_TB_P2" type="button" value="Reset" style="float: left; z-index: 10;" />
                            </div>
                        </td>
                        <td style="text-align: right; text-wrap: none; width: 10%;">MIN_2</td>
                        <td style="text-align: left; width: 30%;">
                            <div style="width: 80%; float: left; z-index: -10;">
                                <input id="RAT_TB_MIN_2" type="number" min="0" step="1" autocomplete="off" style="width: 100%; z-index: -10;" />
                            </div>
                            <div style="width: 20%; float: right; z-index: 10;">
                                <input Replace_Target="MIN_2" Data_By="RAT_TB_MIN_2" type="button" value="Reset" style="float: left; z-index: 10;" />
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Price_T%>_3</td>
                        <td style="text-align: left; width: 30%;">
                            <div style="width: 80%; float: left; z-index: -10;">
                                <input id="RAT_TB_P3" type="number" min="0" step="0.1" autocomplete="off" style="width: 100%; z-index: -10;" />
                            </div>
                            <div style="width: 20%; float: right; z-index: 10;">
                                <input Replace_Target="單價_3" Data_By="RAT_TB_P3" type="button" value="Reset" style="float: left; z-index: 10;" />
                            </div>
                        </td>
                        <td style="text-align: right; text-wrap: none; width: 10%;">MIN_3</td>
                        <td style="text-align: left; width: 30%;">
                            <div style="width: 80%; float: left; z-index: -10;">
                                <input id="RAT_TB_MIN_3" type="number" min="0" step="1" autocomplete="off" style="width: 100%; z-index: -10;" />
                            </div>
                            <div style="width: 20%; float: right; z-index: 10;">
                                <input Replace_Target="MIN_3" Data_By="RAT_TB_MIN_3" type="button" value="Reset" style="float: left; z-index: 10;" />
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Price_Curr%></td>
                        <td style="text-align: left; width: 30%;">
                            <div style="width: 80%; float: left; z-index: -10;">
                                <input id="RAT_TB_P_Curr" type="number" min="0" step="0.1" autocomplete="off" style="width: 100%; z-index: -10;" />
                            </div>
                            <div style="width: 20%; float: right; z-index: 10;">
                                <input Replace_Target="外幣單價" Data_By="RAT_TB_P_Curr" type="button" value="Reset" style="float: left; z-index: 10;" />
                            </div>
                        </td>
                        <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Last_Price_Day%></td>
                        <td style="text-align: left; width: 30%;">
                            <div style="width: 80%; float: left; z-index: -10;">
                                <input id="RAT_TB_LSPD" type="date" autocomplete="off" style="width: 100%; z-index: -10;" />
                            </div>
                            <div style="width: 20%; float: right; z-index: 10;">
                                <input Replace_Target="最後單價日" Data_By="RAT_TB_LSPD" type="button" value="Reset" style="float: left; z-index: 10;" />
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Develop_Remark%></td>
                        <td style="text-align: left; width: 30%;" colspan="3">
                            <div style="width: 91.4%; float: left; z-index: -10;">
                                <input id="RAT_TB_Remark_D" autocomplete="off" style="width: 100%; z-index: -10;" />
                            </div>
                            <div style="width: 8.6%; float: right; z-index: 10;">
                                <input Replace_Target="備註給開發" Data_By="RAT_TB_Remark_D" type="button" value="Reset" style="float: left; z-index: 10;" />
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Purchase_Remark%></td>
                        <td style="text-align: left; width: 30%;" colspan="3">
                            <div style="width: 91.4%; float: left; z-index: -10;">
                                <input id="RAT_TB_Remark_R" autocomplete="off" style="width: 100%; z-index: -10;" />
                            </div>
                            <div style="width: 8.6%; float: right; z-index: 10;">
                                <input Replace_Target="備註給採購" Data_By="RAT_TB_Remark_R" type="button" value="Reset" style="float: left; z-index: 10;" />
                            </div>
                        </td>
                    </tr>
                </table>

            </div>
                <div id="Div_Edit_Package" style="position: relative; border: 1px solid #111111; padding: 20px; box-sizing: border-box; margin: 30px auto; width: 95%;">
                    <span style="position: absolute; top: -1em; left: 10%; line-height: 2em; padding: 0 1em; background-color: #fff;">包裝維護</span>
                    <table style="margin: 0 auto; width: 100%;">
                        <tr>
                        <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Net_Weight%></td>
                        <td style="text-align: left; width: 30%;">
                            <div style="width: 80%; float: left; z-index: -10;">
                                <input id="RPAT_TB_WW" type="number" min="0" autocomplete="off" style="width: 100%; z-index: -10;" />
                            </div>
                            <div style="width: 20%; float: left; z-index: 10;">
                                <input Replace_Target="淨重" Data_By="RPAT_TB_WW" type="button" value="Reset" style="float: left; z-index: 10;" />
                            </div>
                        </td>
                        <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Gross_Weight%></td>
                        <td style="text-align: left; width: 30%;">
                            <div style="width: 80%; float: left; z-index: -10;">
                                <input id="RPAT_TB_GW" type="number" min="0" autocomplete="off" style="width: 100%; z-index: -10;" />
                            </div>
                            <div style="width: 20%; float: right; z-index: 10;">
                                <input Replace_Target="毛重" Data_By="RPAT_TB_GW" type="button" value="Reset" style="float: left; z-index: 10;" />
                            </div>
                        </td>
                    </tr>
                        <tr>
                            <td></td><td></td>
                            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Outerbox_No%></td>
                            <td style="text-align: left; width: 15%;">
                                <div style="width: 80%; float: left; z-index: -10;">
                                    <input id="RPAT_TB_P_OBNo" autocomplete="off" style="width: 100%; z-index: -10;" />
                                </div>
                                <div style="width: 20%; float: right; z-index: 10;">
                                    <input replace_target="外箱編號" data_by="RPAT_TB_P_OBNo" type="button" value="Reset" style="float: left; z-index: 10;" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right; text-wrap: none; width: 10%;" rowspan="2">
                                <%=Resources.MP.Innerbox_Capacity%>
                                <br />
                                <span style="font-size: small; color: orange;">單位/內盒</span>
                            </td>
                            <td style="text-align: left; width: 15%;" rowspan="2">
                                <div style="width: 80%; float: left; z-index: -10;">
                                    <input id="RPAT_TB_P_IBC" type="number" min="0" autocomplete="off" style="width: 100%; z-index: -10;" />
                                </div>
                                <div style="width: 20%; float: right; z-index: 10;">
                                    <input replace_target="內盒容量" data_by="RPAT_TB_P_IBC" type="button" value="Reset" style="float: left; z-index: 10;" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Outerbox_Lenght%></td>
                            <td style="text-align: left; width: 15%;">
                                <div style="width: 80%; float: left; z-index: -10;">
                                    <input id="RPAT_TB_P_OBL" type="number" min="0" autocomplete="off" style="width: 100%; z-index: -10;" />
                                </div>
                                <div style="width: 20%; float: right; z-index: 10;">
                                    <input replace_target="外箱長度" data_by="RPAT_TB_P_OBL" type="button" value="Reset" style="float: left; z-index: 10;" />
                                </div>
                            </td>

                        </tr>
                        <tr>
                            <td style="text-align: right; text-wrap: none; width: 10%;">
                                <%=Resources.MP.Innerbox_Amount%>
                                <br />
                                <span style="font-size: small; color: orange;">內盒/內箱</span>
                            </td>
                            <td style="text-align: left; width: 15%;">
                                <div style="width: 80%; float: left; z-index: -10;">
                                    <input id="RPAT_TB_P_IA" type="number" min="0" autocomplete="off" style="width: 100%; z-index: -10;" />
                                </div>
                                <div style="width: 20%; float: right; z-index: 10;">
                                    <input replace_target="內盒數" data_by="RPAT_TB_P_IA" type="button" value="Reset" style="float: left; z-index: 10;" />
                                </div>
                            </td>
                            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Outerbox_Weight%></td>
                            <td style="text-align: left; width: 15%;">
                                <div style="width: 80%; float: left; z-index: -10;">
                                    <input id="RPAT_TB_P_OBW" type="number" min="0" autocomplete="off" style="width: 100%; z-index: -10;" />
                                </div>
                                <div style="width: 20%; float: right; z-index: 10;">
                                    <input replace_target="外箱寬度" data_by="RPAT_TB_P_OBW" type="button" value="Reset" style="float: left; z-index: 10;" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right; text-wrap: none; width: 10%;">
                                <%=Resources.MP.Innerbox_Amount_2%>
                                <br />
                                <span style="font-size: small; color: orange;">內箱/外箱</span>
                            </td>
                            <td style="text-align: left; width: 15%;">
                                <div style="width: 80%; float: left; z-index: -10;">
                                    <input id="RPAT_TB_P_IA2" type="number" min="0" autocomplete="off" style="width: 100%; z-index: -10;" />
                                </div>
                                <div style="width: 20%; float: right; z-index: 10;">
                                    <input replace_target="內箱數" data_by="RPAT_TB_P_IA2" type="button" value="Reset" style="float: left; z-index: 10;" />
                                </div>
                            </td>
                            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Outerbox_Height%></td>
                            <td style="text-align: left; width: 15%;">
                                <div style="width: 80%; float: left; z-index: -10;">
                                    <input id="RPAT_TB_P_OBH" type="number" min="0" autocomplete="off" style="width: 100%; z-index: -10;" />
                                </div>
                                <div style="width: 20%; float: right; z-index: 10;">
                                    <input replace_target="外箱高度" data_by="RPAT_TB_P_OBH" type="button" value="Reset" style="float: left; z-index: 10;" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Unit%><%=Resources.MP.Speace%><%=Resources.MP.Net_Weight%></td>
                            <td style="text-align: left; width: 1%;">
                                <div style="width: 80%; float: left; z-index: -10;">
                                    <input id="RPAT_TB_P_Unit_NW" type="number" min="0" autocomplete="off" style="width: 100%; z-index: -10;" />
                                </div>
                                <div style="width: 20%; float: right; z-index: 10;">
                                    <input replace_target="單位淨重" data_by="RPAT_TB_P_Unit_NW" type="button" value="Reset" style="float: left; z-index: 10;" />
                                </div>
                            </td>
                            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Unit%><%=Resources.MP.Speace%><%=Resources.MP.Gross_Weight%></td>
                            <td style="text-align: left; width: 10%;">
                                <div style="width: 80%; float: left; z-index: -10;">
                                    <input id="RPAT_TB_P_Unit_GW" type="number" min="0" autocomplete="off" style="width: 100%; z-index: -10;" />
                                </div>
                                <div style="width: 20%; float: right; z-index: 10;">
                                    <input replace_target="單位淨重" data_by="RPAT_TB_P_Unit_GW" type="button" value="Reset" style="float: left; z-index: 10;" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td></td>
                            <td>
                                <span style="font-size: small; color: orange;">淨重：開發用(不含螺絲)</span>
                            </td>
                            <td></td>
                            <td>
                                <span style="font-size: small; color: orange;">毛重：出貨用(含包裝與配件)</span>
                            </td>
                        </tr>
                    </table>
                    <table style="margin: 0 auto; width: 100%;">
                        <tr>
                            <td style="text-align: right; text-wrap: none; width: 5%;"><%=Resources.MP.Product_Length%></td>
                            <td style="text-align: left; width: 8%;">
                                <div style="width: 80%; float: left; z-index: -10;">
                                    <input id="RPAT_TB_P_PL" type="number" min="0" autocomplete="off" style="width: 100%; z-index: -10;" />
                                </div>
                                <div style="width: 20%; float: right; z-index: 10;">
                                    <input replace_target="產品長度" data_by="RPAT_TB_P_PL" type="button" value="R" style="float: left; z-index: 10;" />
                                </div>
                            </td>
                            <td style="text-align: right; text-wrap: none; width: 5%;"><%=Resources.MP.Product_Weight%></td>
                            <td style="text-align: left; width: 8%;">
                                <div style="width: 80%; float: left; z-index: -10;">
                                    <input id="RPAT_TB_P_PW" type="number" min="0" autocomplete="off" style="width: 100%; z-index: -10;" />
                                </div>
                                <div style="width: 20%; float: right; z-index: 10;">
                                    <input replace_target="產品寬度" data_by="RPAT_TB_P_PW" type="button" value="R" style="float: left; z-index: 10;" />
                                </div>
                            </td>
                            <td style="text-align: right; text-wrap: none; width: 5%;"><%=Resources.MP.Product_Height%></td>
                            <td style="text-align: left; width: 8%;">
                                <div style="width: 80%; float: left; z-index: -10;">
                                    <input id="RPAT_TB_P_PH" type="number" min="0" autocomplete="off" style="width: 100%; z-index: -10;" />
                                </div>
                                <div style="width: 20%; float: right; z-index: 10;">
                                    <input replace_target="產品高度" data_by="RPAT_TB_P_PH" type="button" value="R" style="float: left; z-index: 10;" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right; text-wrap: none; width: 5%;"><%=Resources.MP.Package_Length%></td>
                            <td style="text-align: left; width: 8%;">
                                <div style="width: 80%; float: left; z-index: -10;">
                                    <input id="RPAT_TB_P_PGL" type="number" min="0" autocomplete="off" style="width: 100%; z-index: -10;" />
                                </div>
                                <div style="width: 20%; float: right; z-index: 10;">
                                    <input replace_target="包裝長度" data_by="RPAT_TB_P_PGL" type="button" value="R" style="float: left; z-index: 10;" />
                                </div>
                            </td>
                            <td style="text-align: right; text-wrap: none; width: 5%;"><%=Resources.MP.Package_Weight%></td>
                            <td style="text-align: left; width: 8%;">
                                <div style="width: 80%; float: left; z-index: -10;">
                                    <input id="RPAT_TB_P_PGW" type="number" min="0" autocomplete="off" style="width: 100%; z-index: -10;" />
                                </div>
                                <div style="width: 20%; float: right; z-index: 10;">
                                    <input replace_target="包裝寬度" data_by="RPAT_TB_P_PGW" type="button" value="R" style="float: left; z-index: 10;" />
                                </div>
                            </td>
                            <td style="text-align: right; text-wrap: none; width: 5%;"><%=Resources.MP.Package_Height%></td>
                            <td style="text-align: left; width: 8%;">
                                <div style="width: 80%; float: left; z-index: -10;">
                                    <input id="RPAT_TB_P_PGH" type="number" min="0" autocomplete="off" style="width: 100%; z-index: -10;" />
                                </div>
                                <div style="width: 20%; float: right; z-index: 10;">
                                    <input replace_target="包裝高度" data_by="RPAT_TB_P_PGH" type="button" value="R" style="float: left; z-index: 10;" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right; text-wrap: none; width: 5%;">寄送袋子</td>
                            <td style="text-align: left; width: 8%;">
                                <div style="width: 80%; float: left; z-index: -10;">
                                    <select id="RPAT_DDL_Bag" style="width: 100%; height: 28.5px;"></select>
                                </div>
                                <div style="width: 20%; float: left; z-index: 10;">
                                    <input replace_target="寄送袋子" data_by="RPAT_DDL_Bag" type="button" value="R" style="float: left; z-index: 10;" />
                                </div>
                            </td>
                            <td style="text-align: right; text-wrap: none; width: 5%;">寄送吊卡</td>
                            <td style="text-align: left; width: 8%;">
                                <div style="width: 80%; float: left; z-index: -10;">
                                    <select id="RPAT_DDL_Card" style="width: 100%; height: 28.5px;"></select>
                                </div>
                                <div style="width: 20%; float: right; z-index: 10;">
                                    <input replace_target="寄送吊卡" data_by="RPAT_DDL_Card" type="button" value="R" style="float: left; z-index: 10;" />
                                </div>
                            </td>
                            <td style="text-align: right; text-wrap: none; width: 5%;">特殊包裝</td>
                            <td style="text-align: left; width: 8%;">
                                <div style="width: 80%; float: left; z-index: -10;">
                                    <select id="RPAT_DDL_SP_PKG" style="width: 100%; height: 28.5px;"></select>
                                </div>
                                <div style="width: 20%; float: right; z-index: 10;">
                                    <input replace_target="特殊包裝" data_by="RPAT_DDL_SP_PKG" type="button" value="R" style="float: left; z-index: 10;" />
                                </div>
                            </td>
                        </tr>
                    </table>

                </div>
            <br />
            <div style="width: 100%; text-align: center;">
                <input id="BT_Edit" type="button" class="BTN" style="display:inline-block;" value="<%=Resources.MP.Edit%>" />
            </div>
        </div>
    </div>

    <br />
    <br />
</asp:Content>