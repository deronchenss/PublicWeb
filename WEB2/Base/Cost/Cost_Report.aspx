<%@ Page Title="Cost Report" Language="C#" MasterPageFile="~/MP.master" AutoEventWireup="true" CodeFile="Cost_Report.aspx.cs" Inherits="Cost_Cost_Report" %>
<%@ Register TagPrefix="uc1" TagName="uc1" Src="~/User_Control/Dia_Supplier_Selector.ascx" %>
<%@ Register TagPrefix="uc2" TagName="uc2" Src="~/User_Control/Dia_Product_ALL.ascx" %>

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
            document.body.style.overflow = 'hidden';
            Form_Mode_Change("Search");//WD
            Search_Cost();//WD

            $('#BT_Product_Selector').on('click', function () {
                $("#Search_Supplier_Dialog").dialog('open');
            });

            $('#DDL_Data_Souce').on('change', function () {
                switch ($(this).val()) {
                    case "Cost":
                        $('.Cost').toggle(true);
                        $('.Price').toggle(false);
                        break;
                    case "Price":
                        $('.Cost').toggle(false);
                        $('.Price').toggle(true);
                        break;
                }
            });

            $('#BT_RP_Print').on('click', function () {
                $("body").loading(); // 遮罩開始
                $.ajax({
                    url: "/Base/Cost/New_Cost_Search.ashx",
                    data: {
                        "Call_Type": "Cost_Report_Print",
                        "CB_MSRP": $('#R1_CB_MSRP').prop('checked'),
                        "CB_Print_PW": $('#R1_CB_Print_PW').prop('checked'),
                        "Session_Name": "<%=(Session["Name"] == null) ? "Ivan10" : Session["Name"].ToString().Trim() %>",
                    },
                    cache: false,
                    type: "POST",
                    datatype: "json",
                    contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                    xhr: function () {// Seems like the only way to get access to the xhr object
                        var xhr = new XMLHttpRequest();
                        xhr.responseType = 'blob'
                        return xhr;
                    },
                    success: function (response, status) {
                        //if (status === 'nocontent') {
                        //    alert('採購單號查無資料');
                        //}
                        //else if (status !== 'success') {
                        //    alert(response);
                        //}
                        //else {
                            var blob = new Blob([response], { type: "application/pdf" });
                            var url = window.URL || window.webkitURL;
                            link = url.createObjectURL(blob);
                            var a = $("<a />");
                            //switch ($('#R_RPT_TYPE').val()) {
                            //    case "0":
                            //        a.attr("download", "開發單.pdf");
                            //        break;
                            //    case "1":
                            //        a.attr("download", "詢價單.pdf");
                            //        break;
                            //    case "2":
                            //        a.attr("download", "索樣單.pdf");
                            //        break;
                            //    case "3":
                            //        a.attr("download", "樣品到貨核對表.pdf");
                            //        break;
                            //}
                            a.attr("download", "成本分析.pdf");

                            a.attr("href", link);
                            $("body").append(a);

                            a[0].click();
                            $("body").remove(a);
                        //}
                        $("body").loading("stop") // 遮罩停止
                    },
                    error: function (ex) {
                        console.log(ex.responseText);
                        $("body").loading("stop") // 遮罩停止
                        alert('下載報表有誤，請通知資訊人員');
                        return;
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

            $('#SSD_Table_Supplier').on('click', '.SUP_SEL', function () {
                $('#TB_S_No').val($(this).parent().parent().find('td:nth(2)').text());
                $('#TB_S_SName').val($(this).parent().parent().find('td:nth(3)').text());
                $("#Search_Supplier_Dialog").dialog('close');
            });

            //window.document.body.onbeforeunload = function () {
            //    if (Edit_Mode === "Edit") {
            //        return '您尚未將編輯過的表單資料送出，請問您確定要離開網頁嗎？';
            //    }
            //}
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
                        $('#Div_Edit_Area').toggle(false);
                        $('#RB_DV_DIMG').prop('checked', true);
                        $('input[type=radio][name=DIMG]').attr('disabled', false);
                        $('#Div_DT_View').css('width', '60%');
                        $('#Div_Exec_Data').css('width', '35%');
                        $('#Div_Exec_Data').css('float', 'Right');
                        break;
                    case "Review_Data":
                        Edit_Mode = "Edit";
                        $('.V_BT').attr('disabled', false);
                        $('#V_BT_Review').attr('disabled', 'disabled');
                        $('#Div_DT_View, #Div_Data_Control, #Div_Edit_Area').toggle(false);
                        $('#Div_Exec_Data').css('width', '100%');
                        $('#Div_Exec_Data').css('float', 'Right');
                        break;
                    case "Edit_Data":
                        Edit_Mode = "Edit";
                        //$('.V_BT').attr('disabled', false);
                        //$('#V_BT_Review').attr('disabled', 'disabled');
                        $('#Div_DT_View, #Div_Data_Control').toggle(false);
                        $('#Div_Edit_Area').toggle(true);
                        $('#Div_Exec_Data').css('width', '60%');
                        $('#Div_Exec_Data').css('float', 'left');
                        $('#Div_Edit_Area').css('width', '39%');
                        break;
                }
            }

            $('#BT_Search').on('click', function () {
                Form_Mode_Change("Search");
                switch ($('#DDL_Data_Souce').val()) {
                    case "Cost":
                        Search_Cost();
                        break;
                    case "Price":
                        Search_Price();
                        break;
                }
            });

            var O_Data_Source;
            $("#DDL_Data_Souce").on('focus', function () {
                O_Data_Source = $(this).val();
            }).change(function () {
                if ($('#Table_Search_CP tbody tr,#Table_Exec_Data tbody tr').length > 0) {
                    if (confirm('切換來源將會清空資料，確定執行？')) {
                        $('#Table_Search_CP_info, #Table_Exec_Data_info').text('');
                        $('#Table_Search_CP, #Table_Exec_Data').html('');
                        $('.Exist_Select, .For_Cost, .For_Price').toggle(false);
                        Form_Mode_Change("Search");
                    }
                    else {
                        $(this).val(O_Data_Source);
                    }
                };
            });

            $('.V_BT').on('click', function () {
                $('.V_BT').attr('disabled', false);
                $(this).attr('disabled', 'disabled');
            });

            $('.V_Report').on('click', function () {
                Form_Mode_Change("Edit_Data");
                $('[Control_By]').toggle(false);
                $('[Control_By=' + $(this).prop('id') + ']').toggle(true);
                //$(this).attr()
            });

            function Search_Cost() {
                $.ajax({
                    url: "/Base/Cost/New_Cost_Search.ashx",
                    data: {
                        "Call_Type": "Cost_Report_C_Search",
                        "IM": $('#TB_IM').val()
                        //"SampleM": $('#TB_SampleM').val(),
                        //"Purchase_No": $('#TB_Purchase_No').val(),
                        //"S_No": $('#TB_S_No').val(),
                        //"S_SName": $('#TB_S_SName').val()
                    },
                    cache: false,
                    async: false,
                    type: "POST",
                    datatype: "json",
                    contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                    success: function (R) {
                        if (R.length === 0) {
                            alert('<%=Resources.MP.Data_Not_Exists_Alert%>');
                            Form_Mode_Change("Base");
                        }
                        else {
                            var Table_HTML =
                                '<thead><tr>'
                                + '</th><th>' + '<%=Resources.MP.Developing%>'
                                + '</th><th>' + '<%=Resources.MP.Ivan_Model%>'
                                + '</th><th>' + '<%=Resources.MP.Supplier_Short_Name%>'
                                + '</th><th>' + '<%=Resources.MP.Sale_Model%>'
                                + '</th><th>' + '<%=Resources.MP.Sample_Product_No%>'
                                + '</th><th class="DIMG">' + '<%=Resources.MP.Image%>'
                                + '</th><th>' + '<%=Resources.MP.Product_Information%>'
                                + '</th><th>' + '<%=Resources.MP.Unit%>'
                                + '</th><th>' + '<%=Resources.MP.Big_Stock%>'
                                + '</th><th>' + '<%=Resources.MP.Add_Date%>'
                                + '</th><th>' + '<%=Resources.MP.Last_Check_And_Accept_Day%>'
                                + '</th><th>' + '<%=Resources.MP.Last_Price_Day%>'
                                + '</th><th>' + '<%=Resources.MP.Supplier_No%>'
                                + '</th><th>Source'
                                + '</th><th>' + '<%=Resources.MP.SEQ%>'
                                + '</th><th>' + '<%=Resources.MP.Update_User%>'
                                + '</th><th>' + '<%=Resources.MP.Update_Date%>'
                                + '</th></tr></thead><tbody>';
                            $(R).each(function (i) {
                                Table_HTML +=
                                    '<tr><td>' + String(R[i].開發中 ?? "") +
                                    '</td><td><input class="Call_Product_Tool" SUPLU_SEQ = "' + String(R[i].序號 ?? "")
                                    + '" type="button" value="' + String(R[i].頤坊型號 ?? "")
                                    + '" style="text-align:left;width:100%;z-index:1000;' + ((R[i].Has_IMG) ? 'background: #90ee90;' : '') + '" />' +
                                    '</td><td>' + String(R[i].廠商簡稱 ?? "") +
                                    '</td><td>' + String(R[i].銷售型號 ?? "") +
                                    '</td><td>' + String(R[i].暫時型號 ?? "") +
                                    '</td><td class="DIMG" style="text-align:center;">' +
                                    ((R[i].Has_IMG) ? ('<img type="Product" SEQ="' + String(R[i].序號 ?? "") + '" />') : ('<%=Resources.MP.Image_NotExists%>')) +
                                    '</td><td>' + String(R[i].產品說明 ?? "") +
                                    '</td><td>' + String(R[i].單位 ?? "") +
                                    '</td><td>' + String(R[i].大貨庫存數 ?? "") +
                                    '</td><td>' + String(R[i].新增日期 ?? "") +
                                    '</td><td>' + String(R[i].最後點收日 ?? "") +
                                    '</td><td>' + String(R[i].最後單價日 ?? "") +
                                    '</td><td>' + String(R[i].廠商編號 ?? "") +
                                    '</td><td>' + String(R[i].來源 ?? "") +
                                    '</td><td class="SEQ">' + String(R[i].序號 ?? "") +
                                    '</td><td>' + String(R[i].更新人員 ?? "") +
                                    '</td><td>' + String(R[i].更新日期 ?? "") +
                                    '</td></tr>';
                            });

                            Table_HTML += '</tbody>';
                            $('#Table_Search_CP').html(Table_HTML);

                            $('.DIMG').toggle(!$('#RB_DV_DIMG').prop('checked'));
                            $('#Table_Search_CP_info').text('Showing ' + $('#Table_Search_CP > tbody tr').length + ' entries');
                            IMG_Has_Read = false;//初始化IMG讀取

                            $('#Table_Search_CP').css('white-space', 'nowrap');
                            $('#Table_Search_CP thead th').css('text-align', 'center');

                            Re_Bind_Inner_JS();
                        }
                    },
                    error: function (ex) {
                        alert(ex);
                    }
                });
            };
            function Search_Price() {
                $.ajax({
                    url: "/Base/Cost/New_Cost_Search.ashx",
                    data: {
                        "Call_Type": "Cost_Report_P_Search",
                        "IM": $('#TB_IM').val()
                        //"SampleM": $('#TB_SampleM').val(),
                        //"Purchase_No": $('#TB_Purchase_No').val(),
                        //"S_No": $('#TB_S_No').val(),
                        //"S_SName": $('#TB_S_SName').val()
                    },
                    cache: false,
                    async: false,
                    type: "POST",
                    datatype: "json",
                    contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                    success: function (R) {
                        if (R.length === 0) {
                            alert('<%=Resources.MP.Data_Not_Exists_Alert%>');
                                Form_Mode_Change("Base");
                            }
                            else {
                                var Table_HTML =
                                    '<thead><tr>'
                                + '</th><th>' + '<%=Resources.MP.Developing%>'
                                + '</th><th>' + '<%=Resources.MP.Ivan_Model%>'
                                + '</th><th>' + '<%=Resources.MP.Customer_Short_Name%>'
                                + '</th><th>' + '<%=Resources.MP.Customer_Model%>'
                                + '</th><th>' + '<%=Resources.MP.Sale_Model%>'
                                + '</th><th class="DIMG">' + '<%=Resources.MP.Image%>'
                                + '</th><th>' + '<%=Resources.MP.Parent_Product_Information%>'
                                + '</th><th>' + '<%=Resources.MP.Unit%>'
                                + '</th><th>' + '<%=Resources.MP.Supplier_No%>'
                                + '</th><th>' + '<%=Resources.MP.Supplier_Short_Name%>'
                                + '</th><th>' + '<%=Resources.MP.Customer_Short_Name%>'
                                + '</th><th>Source'
                                + '</th><th>' + '<%=Resources.MP.SEQ%>'
                                + '</th><th>' + '<%=Resources.MP.Update_User%>'
                                + '</th><th>' + '<%=Resources.MP.Update_Date%>'
                                + '</th></tr></thead><tbody>';
                            $(R).each(function (i) {
                                Table_HTML +=
                                    '<tr><td>' + String(R[i].開發中 ?? "") +
                                    '</td><td><input class="Call_Product_Tool" SUPLU_SEQ = "' + String(R[i].序號 ?? "")
                                    + '" type="button" value="' + String(R[i].頤坊型號 ?? "")
                                    + '" style="text-align:left;width:100%;z-index:1000;' + ((R[i].Has_IMG) ? 'background: #90ee90;' : '') + '" />' +
                                    '</td><td>' + String(R[i].客戶簡稱 ?? "") +
                                    '</td><td>' + String(R[i].客戶型號 ?? "") +
                                    '</td><td>' + String(R[i].銷售型號 ?? "") +
                                    '</td><td class="DIMG" style="text-align:center;">' +
                                    ((R[i].Has_IMG) ? ('<img type="Product" SEQ="' + String(R[i].SUPLU_SEQ ?? "") + '" />') : ('<%=Resources.MP.Image_NotExists%>')) +
                                    '</td><td>' + String(R[i].產品說明 ?? "") +
                                    '</td><td>' + String(R[i].單位 ?? "") +
                                    '</td><td>' + String(R[i].廠商編號 ?? "") +
                                    '</td><td>' + String(R[i].廠商簡稱 ?? "") +
                                    '</td><td>' + String(R[i].客戶編號 ?? "") +
                                    '</td><td>' + String(R[i].來源 ?? "") +
                                    '</td><td class="SEQ">' + String(R[i].序號 ?? "") +
                                    '</td><td>' + String(R[i].更新人員 ?? "") +
                                    '</td><td>' + String(R[i].更新日期 ?? "") +
                                    '</td></tr>';
                            });
                                Table_HTML += '</tbody>';
                                $('#Table_Search_CP').html(Table_HTML);
                                $('.DIMG').toggle(!$('#RB_DV_DIMG').prop('checked'));
                                $('#Table_Search_CP_info').text('Showing ' + $('#Table_Search_CP > tbody tr').length + ' entries');
                                IMG_Has_Read = false;//初始化IMG讀取
                                $('#Table_Search_CP').css('white-space', 'nowrap');
                                $('#Table_Search_CP thead th').css('text-align', 'center');
                                Re_Bind_Inner_JS();
                            }
                        },
                        error: function (ex) {
                            alert(ex);
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
                        $('.DIMG img').css({ 'height': '', 'width': '' });
                        break;
                    case "RB_SM_DIMG":
                        Show_IMG = true;
                        $('.DIMG img').css({ 'height': '100px', 'width': '100px' });
                        break;
                }
                if (Show_IMG && !IMG_Has_Read) {
                    FN_GET_IMG($('#Table_Exec_Data img[type=Product]'));
                    FN_GET_IMG($('#Table_Search_CP img[type=Product]'));
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

            $('#BT_Next, #V_BT_Review').on('click', function () {
                Form_Mode_Change("Review_Data");
            });

            $('#V_BT_Master').on('click', function () {
                Form_Mode_Change("Search");
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
                    $('#Table_Search_CP_info').text('Showing ' + $('#Table_Search_CP > tbody tr').length + ' entries');

                    $('.Exist_Select').toggle(Boolean($('#Table_Exec_Data').find('tbody tr').length > 0));
                    $('.For_Cost').toggle(Boolean($('#DDL_Data_Souce').val() == 'Cost'));
                    $('.For_Price').toggle(Boolean($('#DDL_Data_Souce').val() == 'Price'));

                    Re_Bind_Inner_JS();
                }
            }

            $('#Table_Search_CP').on('click', 'tbody tr', function () {
                Item_Move($(this), $('#Table_Exec_Data'), $('#Table_Search_CP'), false);
            });
            $('#Table_Exec_Data').on('click', 'tbody tr', function () {
                Item_Move($(this), $('#Table_Search_CP'), $('#Table_Exec_Data'), false);
            });
            $('#BT_ATR').on('click', function () {
                Item_Move($(this), $('#Table_Exec_Data'), $('#Table_Search_CP'), true);
            });
            $('#BT_ATL').on('click', function () {
                Item_Move($(this), $('#Table_Search_CP'), $('#Table_Exec_Data'), true);
            });
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
        #Table_Search_CP tbody tr:hover, #Table_Exec_Data tbody tr:hover{
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
            top: 0; /* 列首永遠固定於上 */
        }
    </style>
    <uc1:uc1 ID="uc1" runat="server" /> 
    <uc2:uc2 ID="uc2" runat="server" /> 

    <table class="table_th" style="text-align: left;">
        <tr>
            <td rowspan="5" style="width:5%">
                <span>Data Source</span>
                <br />
                <select id="DDL_Data_Souce" style="width:100%;">
                    <option selected="selected">Cost</option>
                    <option>Price</option>
                </select>
            </td>
            <td style="height: 10px; font-size: smaller;" colspan="8">&nbsp</td>
        </tr>
        <tr>
            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Ivan_Model%></td>
            <td style="text-align: left; width: 15%;">
                <input id="TB_IM" autocomplete="off" style="width: 100%;" />
            </td>
            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Sample_Product_No%></td>
            <td style="text-align: left; width: 15%;">
                <input id="TB_SampleM" autocomplete="off" style="width: 100%;" />
            </td>
            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Purchase_No%></td>
            <td style="text-align: left; width: 15%;">
                <input id="TB_Purchase_No" autocomplete="off" style="width: 100%;" />
            </td>
            <td></td><td></td>
        </tr>
        <tr>
            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Supplier_No%></td>
            <td style="text-align: left; width: 15%;">
                <div style="width: 90%; float: left; z-index: -10;">
                    <input id="TB_S_No" style="width: 100%; z-index: -10;" />
                </div>
                <div style="width: 10%; float: right; z-index: 10;">
                    <input id="BT_Product_Selector" type="button" value="…" style="float: right; z-index: 10; width: 100%;" />
                </div>
            </td>
            <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.MP.Supplier_Short_Name%></td>
            <td style="text-align: left; width: 15%;">
                <input id="TB_S_SName" style="width: 100%;" />
            </td>
        </tr>
        <tr>
            <td class="tdtstyleRight" colspan="7">
                <input type="button" id="BT_Search" class="M_BT" value="<%=Resources.MP.Search%>" />
                <%--<input type="button" id="BT_Cancel" class="M_BT" value="<%=Resources.MP.Cancel%>" style="display: none;" />--%>
                <%--<input type="button" id="BT_Re_Select" class="M_BT" value="<%=Resources.MP.Re_Selet%>" style="display:none;" />--%>
                <%--<input type="button" id="BT_Save" class="M_BT" value="<%=Resources.MP.Save%>" style="display:none;" />--%>
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
        <input id="V_BT_Review" type="button" class="V_BT Exist_Select" style="display:none;" value="預覽資料" />
        <input id="V_BT_Report_1" type="button" class="V_BT Exist_Select V_Report For_Cost" style="display:none;" value="成本分析" />
        <input id="V_BT_Report_2" type="button" class="V_BT Exist_Select V_Report For_Cost" style="display:none;" value="簡易型錄" />
        <input id="V_BT_Report_3" type="button" class="V_BT Exist_Select V_Report For_Price" style="display:none;" value="簡易型錄2" />
        <%--<input type="button" class="V_BT" value="<%=Resources.MP.Sample%>" onclick="$('.Div_D').css('display','none');$('#Div_More').css('display','');" />--%>
    </div>
    <div>&nbsp;&nbsp;&nbsp;&nbsp;
        <input id="RB_DV_DIMG" type="radio" name="DIMG" disabled="disabled" checked="checked" />
        <label for="RB_DV_DIMG"><%=Resources.MP.Not_Show_Image%></label>
        <input id="RB_V_DIMG" type="radio" name="DIMG" disabled="disabled" />
        <label for="RB_V_DIMG"><%=Resources.MP.Show_Original_Image%></label>
        <input id="RB_SM_DIMG" type="radio" name="DIMG" disabled="disabled" />
        <label for="RB_SM_DIMG"><%=Resources.MP.Show_Small_Image%></label>
    </div>
    <div style="width: 98%; margin: 0 auto;">
        <div id="Div_DT_View" style="width: 60%; height: 65vh; overflow: auto; display: none; float: left;border-style:solid;border-width:1px; ">
            <span class="dataTables_info" id="Table_Search_CP_info" role="status" aria-live="polite"></span>
            <table id="Table_Search_CP" style="width: 99%;" class="table table-striped table-bordered">
                <thead></thead>
                <tbody></tbody>
            </table>
        </div>

        <div id="Div_Data_Control" style="width: 5%; margin: 0 auto; text-align: center; height: 65vh; float: left; display: none;">
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

        <div id="Div_Exec_Data" style="width: 35%; height: 65vh; overflow: auto; display: none; float: right;border-style:solid;border-width:1px; ">
            <span class="dataTables_info" id="Table_Exec_Data_info" role="status" aria-live="polite"></span>
            <table id="Table_Exec_Data" style="width: 100%;" class="table table-striped table-bordered">
                <thead></thead>
                <tbody></tbody>
            </table>
        </div>

        <div id="Div_Edit_Area" style="width: 35%; height: 65vh; overflow: auto; display: none; float: right;border-style:solid;border-width:1px; ">
            <div class="search_section_control" control_by="V_BT_Report_1" style="display: none;">
                <div style="position: relative; border: 1px solid #111111; padding: 20px; box-sizing: border-box; margin: 30px auto; width: 80%;">
                    <span style="position: absolute; top: -1em; left: 10%; line-height: 2em; padding: 0 1em; background-color: #fff;">報表類型</span>
                    <input type="radio" value="成本分析" checked />
                    <span>成本分析表(附圖)</span>
                </div>
                <div style="position: relative; border: 1px solid #111111; padding: 20px; box-sizing: border-box; margin: 30px auto; width: 80%;">
                    <span style="position: absolute; top: -1em; left: 10%; line-height: 2em; padding: 0 1em; background-color: #fff;">報表內容</span>
                    <input type="checkbox" id="R1_CB_MSRP" checked />
                    <label for="R1_CB_MSRP">門市與MSRP</label>
                    <br />
                    <input type="checkbox" id="R1_CB_Print_PW" />
                    <label for="R1_CB_Print_PW">印價格填寫欄</label>
                </div>
            </div>
            <div class="search_section_control" control_by="V_BT_Report_2" style="display: none;">
                <div style="position: relative; border: 1px solid #111111; padding: 20px; box-sizing: border-box; margin: 30px auto; width: 80%;">
                    <span style="position: absolute; top: -1em; left: 10%; line-height: 2em; padding: 0 1em; background-color: #fff;">報表類型</span>
                    <input type="radio" value="簡易型錄C" name="R2_Report_Type" id="R2_RB_Report_TypeC" checked />
                    <label for="R2_RB_Report_TypeC">簡易型錄C(皮帶單排)</label>
                    <br />
                    <input type="radio" value="簡易型錄D" name="R2_Report_Type" id="R2_RB_Report_TypeD" />
                    <label for="R2_RB_Report_TypeD">簡易型錄D(帶扣單排)</label>
                </div>
                <div style="display: flex; justify-content: flex-start; align-items: flex-start;width:80%;margin:0 auto;">
                    <%--border: 1px solid #111111; padding: 10px; box-sizing: border-box;--%>
                    <div style="position: relative; border: 1px solid #111111; padding: 20px; box-sizing: border-box; margin: 30px auto; width: 40%;float:left;">
                        <span style="position: absolute; top: -1em; left: 10%; line-height: 2em; padding: 0 1em; background-color: #fff;">排列</span>
                        <input type="radio" value="IM_SN" name="R2_Report_Sort" id="R2_RS_1" checked />
                        <label for="R2_RS_1">頤坊型號,廠商編號</label>
                        <br />
                        <input type="radio" value="SN_IM" name="R2_Report_Sort" id="R2_RS_2" />
                        <label for="R2_RS_2">廠商編號,頤坊型號</label>
                        <br />
                        <input type="radio" value="SampleM_SN" name="R2_Report_Sort" id="R2_RS_3" />
                        <label for="R2_RS_3">暫時編號,頤坊型號</label>
                    </div>
                    <div style="position: relative; border: 1px solid #111111; padding: 20px; box-sizing: border-box; margin: 30px auto; width: 59%;float:right;">
                        <span style="position: absolute; top: -1em; left: 10%; line-height: 2em; padding: 0 1em; background-color: #fff;">報表內容</span>
                        <div style="text-align:left;float:left;width:50%;">
                            <input type="checkbox" name="R2_Report_Select_Column" id="R2_RSC_CB_IM" checked />
                            <label for="R2_RSC_CB_IM">頤坊型號</label>
                            <br />
                            <input type="checkbox" name="R2_Report_Select_Column" id="R2_RSC_CB_S_No" />
                            <label for="R2_RSC_CB_S_No">廠商編號</label>
                            <br />
                            <input type="checkbox" name="R2_Report_Select_Column" id="R2_RSC_CB_SampleM" />
                            <label for="R2_RSC_CB_SampleM">暫時型號</label>
                            <br />
                            <input type="checkbox" name="R2_Report_Select_Column" id="R2_RSC_CB_SupM" />
                            <label for="R2_RSC_CB_SupM">廠商型號</label>
                            <br />
                            <input type="checkbox" name="R2_Report_Select_Column" id="R2_RSC_CB_Unit" />
                            <label for="R2_RSC_CB_Unit">單位</label>
                        </div>
                        <div style="text-align:left;float:right;width:50%;">
                            <input type="checkbox" name="R2_Report_Select_Column" id="R2_RSC_CB_SaleM" />
                            <label for="R2_RSC_CB_SaleM">銷售型號</label>
                            <br />
                            <input type="checkbox" name="R2_Report_Select_Column" id="R2_RSC_CB_S_PI" checked />
                            <label for="R2_RSC_CB_S_PI">產品說明</label>
                            <br />
                            <input type="checkbox" name="R2_Report_Select_Column" id="R2_RSC_CB_UW" />
                            <label for="R2_RSC_CB_UW">單位重量</label>
                            <br />
                            <input type="checkbox" name="R2_Report_Select_Column" id="R2_RSC_CB_BS" />
                            <label for="R2_RSC_CB_BS">大貨庫存</label>
                            <br />
                            <input type="checkbox" name="R2_Report_Select_Column" id="R2_RSC_CB_UP" />
                            <label for="R2_RSC_CB_UP">單價</label>
                        </div>
                    </div>
                </div>
            </div>
            <div class="search_section_control" control_by="V_BT_Report_3" style="display: none;">
                <div style="position: relative; border: 1px solid #111111; padding: 20px; box-sizing: border-box; margin: 30px auto; width: 80%;">
                    <span style="position: absolute; top: -1em; left: 10%; line-height: 2em; padding: 0 1em; background-color: #fff;">報表類型</span>
                    <input type="radio" value="簡易型錄2C" name="R3_Report_Type" id="R3_RB_Report_Type2C" checked />
                    <label for="R3_RB_Report_TypeC">簡易型錄2C(皮帶單排)</label>
                    <br />
                    <input type="radio" value="簡易型錄2D" name="R3_Report_Type" id="R3_RB_Report_Type2D" />
                    <label for="R3_RB_Report_TypeD">簡易型錄2D(帶扣單排)</label>
                </div>
                <div style="display: flex; justify-content: flex-start; align-items: flex-start;width:80%;margin:0 auto;">
                    <div style="position: relative; border: 1px solid #111111; padding: 20px; box-sizing: border-box; margin: 30px auto; width: 40%;float:left;">
                        <span style="position: absolute; top: -1em; left: 10%; line-height: 2em; padding: 0 1em; background-color: #fff;">排列</span>
                        <input type="radio" value="IM_SN" name="R3_Report_Sort" id="R3_RS_1" checked />
                        <label for="R3_RS_1">頤坊型號</label>
                        <br />
                        <input type="radio" value="SN_IM" name="R3_Report_Sort" id="R3_RS_2" />
                        <label for="R3_RS_2">客戶型號</label>
                    </div>
                    <div style="position: relative; border: 1px solid #111111; padding: 20px; box-sizing: border-box; margin: 30px auto; width: 59%;float:right;">
                        <span style="position: absolute; top: -1em; left: 10%; line-height: 2em; padding: 0 1em; background-color: #fff;">報表內容</span>
                        <div style="text-align:left;float:left;width:50%;">
                            <input type="checkbox" name="R3_Report_Select_Column" id="R3_RSC_CB_IM" checked />
                            <label for="R3_RSC_CB_IM">頤坊型號</label>
                            <br />
                            <input type="checkbox" name="R3_Report_Select_Column" id="R3_RSC_CB_CustM" />
                            <label for="R3_RSC_CB_CustM">客戶型號</label>
                            <br />
                            <input type="checkbox" name="R3_Report_Select_Column" id="R3_RSC_CB_S_No" />
                            <label for="R3_RSC_CB_S_No">廠商編號</label>
                        </div>
                        <div style="text-align:left;float:right;width:50%;">
                            <input type="checkbox" name="R3_Report_Select_Column" id="R3_RSC_CB_S_PI" checked />
                            <label for="R3_RSC_CB_S_PI">產品說明</label>
                            <br />
                            <input type="checkbox" name="R3_Report_Select_Column" id="R3_RSC_CB_BS" />
                            <label for="R3_RSC_CB_BS">大貨庫存</label>
                        </div>
                    </div>
                </div>
            </div>
            <br />
            <div style="width: 100%; text-align: center;">
                <input id="BT_RP_Print" type="button" class="BTN" style="display:inline-block;" value="列印" />
            </div>
        </div>

    </div>

    <br />
    <br />
</asp:Content>
