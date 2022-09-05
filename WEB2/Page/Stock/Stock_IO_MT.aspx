<%@ Page Title="待入出庫核銷" Language="C#" MasterPageFile="~/MP.master" AutoEventWireup="true" CodeFile="Stock_IO_MT.aspx.cs" Inherits="Stock_IO_MT" %>
<%@ Register TagPrefix="uc1" TagName="uc1" Src="~/User_Control/Dia_Product_Selector.ascx" %>
<%@ Register TagPrefix="uc2" TagName="uc2" Src="~/User_Control/Dia_Product_ALL.ascx" %>
<%@ Register TagPrefix="uc3" TagName="uc3" Src="~/User_Control/Dia_Duo_Datetime_Picker.ascx" %>
<%@ Register TagPrefix="uc4" TagName="uc4" Src="~/User_Control/Dia_Customer_Selector.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="/css/dataTables.bootstrap4.min.css" rel="stylesheet" />
    <script src="/js/jquery.dataTables.min.js"></script>
    <script src="/js/dataTables.bootstrap4.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            var Edit_Mode;
            var apiUrl = "/Page/Stock/Ashx/Stock_IO_MT.ashx";
            //隱藏滾動卷軸
            document.body.style.overflow = 'hidden';

            //init CONTROLER
            Form_Mode_Change("Base");

            window.document.body.onbeforeunload = function () {
                if (Edit_Mode === "Insert" || Edit_Mode === "Edit") {
                    return '您尚未將編輯過的表單資料送出，請問您確定要離開網頁嗎？';
                }
            }

            //DDL
            DDL_Bind();
            function DDL_Bind() {
                $.ajax({
                    url: "/CommonAshx/Common.ashx",
                    data: {
                        "Call_Type": "GET_DATA_FROM_REFDATA",
                        "CODE": '出入庫帳項'
                    },
                    cache: false,
                    contentType: "application/x-www-form-urlencoded; charset=UTF-8",
                    type: "POST",
                    dataType: "json",
                    success: function (data) {
                        var DDL_Option = "<option></option>";
                        $.each(data, function (i, value) {
                            DDL_Option += '<option value="' + value.內容.substring(0, 1) + '">' + value.內容 + '</option>';
                        });
                        $('#E_BILL_TYPE').html(DDL_Option);
                    },
                    error: function (response) {
                        alert(response.responseText);
                    },
                });
            };

            //Dialog
            $('#BT_CUST_CHS').on('click', function () {
                $("#Search_Customer_Dialog").dialog('open');
            });

            $('#SCD_Table_Customer').on('click', '.CUST_SEL', function () {
                $('#E_CUST_NO').val($(this).parent().parent().find('td:nth(2)').text());
                $('#E_CUST_S_NAME').val($(this).parent().parent().find('td:nth(3)').text());
                $("#Search_Customer_Dialog").dialog('close');
            });

            $('#BT_E_IVAN_TYPE').on('click', function () {
                $("#Search_Product_Dialog").dialog('open');
            });

            $('#SPD_Table_Product').on('click', '.PROD_SEL', function () {
                $('#E_SUPLU_SEQ').val($(this).parent().parent().find('td:nth(1)').text());
                $('#E_IVAN_TYPE').val($(this).parent().parent().find('td:nth(3)').text());
                $('#E_FACT_NO').val($(this).parent().parent().find('td:nth(4)').text());
                $('#E_FACT_S_NAME').val($(this).parent().parent().find('td:nth(5)').text());
                $('#E_UNIT').val($(this).parent().parent().find('td:nth(5)').text());
                $('#E_PROD_DESC').val($(this).parent().parent().find('td:nth(7)').text());
                $('#E_TMP_TYPE').val($(this).parent().parent().find('td:nth(8)').text());

                $("#Search_Product_Dialog").dialog('close');
            });

            //上下移功能 根據每個頁面客製
            $(document).keydown(function (event) {
                var key = (event.keyCode ? event.keyCode : event.which);
                var clickIndex = $('#Table_Search_Data > tbody > tr.tableClick').index();
                if (key == '40') {
                    if (clickIndex < $('#Table_Search_Data tbody tr').length - 1) {
                        clickIndex++;
                        ClickToEdit($('#Table_Search_Data > tbody > tr:nth(' + clickIndex + ')'));
                    }
                }
                else if (key == '38') {
                    if (clickIndex > 0) {
                        clickIndex--;
                        ClickToEdit($('#Table_Search_Data > tbody > tr:nth(' + clickIndex + ')'));
                    }
                }
            });

            //function region
            function Form_Mode_Change(Form_Mode) {
                switch (Form_Mode) {
                    case "Base":
                        $('.Div_D').css('display', 'none');
                        $('#Div_DT_View').css('display', 'none');
                        $('#BT_Cancel').css('display', 'none');
                        $('#BT_Search').css('display', '');
                        $('#BT_Update').css('display', 'none');

                        V_BT_CHG($('#BT_S_BASE'));
                        break;
                    case "Search":
                        $('.Div_D').css('display', 'none');
                        $('#Div_DT_View').css('width', '100%');
                        $('#Div_DT_View').css('display', '');

                        $('#BT_Cancel').css('display', '');
                        $('.modeButton').css('display', 'none')
                        if (Edit_Mode == "Edit") {
                            $('#Div_EDIT_Data').css('display', '');
                            $('#Div_DT_View').css('width', '60%');

                            $('#BT_DELETE').css('display', 'inline-block');
                            $('#BT_EDIT_SAVE').css('display', 'inline-block');
                            $('#BT_INSERT_CANCEL').css('display', 'inline-block');
                        }
                        else if (Edit_Mode == "Insert") {
                            $('#Div_EDIT_Data').css('display', '');
                            $('#Div_DT_View').css('width', '60%');

                            $('#BT_INSERT_SAVE').css('display', 'inline-block');
                            $('#BT_INSERT_CLEAR').css('display', 'inline-block');
                            $('#BT_INSERT_CANCEL').css('display', 'inline-block');
                            $('#E_SEQ').val('');
                            $('#E_UPD_USER').val('');
                            $('#E_UPD_DATE').val('');
                            $("[DT_Fill_Name]").val('');
                        }
                        else {
                            $("[DT_Fill_Name]").val('');
                        }

                        V_BT_CHG($('#BT_S_BASE'));
                        break;
                    case "IMG":
                        $('.Div_D').css('display', 'none');
                        $('#Div_DT_View').css('width', '60%');
                        $('#Div_IMG_DETAIL').css('display', '');

                        //設定DEFAULT Click
                        if ($('#Table_Search_Data > tbody tr[role=row]').length != 0 && $('#Table_Search_Data > tbody tr.tableClick').length == 0) {
                            ClickToEdit($('#Table_Search_Data > tbody > tr:nth(0)'));
                        }

                        V_BT_CHG($('#BT_S_IMG'));
                        break;       
                }
            }

            function Re_Bind_Inner_JS() {
                $('.Call_Product_Tool').off('click');
                $('.Call_Product_Tool').on('click', function (e) {
                    e.stopPropagation();
                    $('#PAD_HDN_SUPLU_SEQ').val($(this).attr('SUPLU_SEQ'));
                    $("#Product_ALL_Dialog").dialog('open');
                });
            };

            function ClickToEdit(click_tr) {
                $('#BT_Update').css('display', '');

                //點擊賦予顏色
                $('#Table_Search_Data > tbody tr').removeClass("tableClick");
                click_tr.addClass("tableClick");
                var clickData = $('#Table_Search_Data').DataTable().row(click_tr).data();

                //Edit page
                for (var i = 0; i < $('#Table_Search_Data').DataTable().columns().header().length; i++) {
                    var titleName = $($('#Table_Search_Data').DataTable().column(i).header()).text();

                    if (!(Edit_Mode == "Insert" && (titleName == "序號" || titleName == "更新人員" || titleName == "更新日期"))) {
                        if ($("[DT_Fill_Name='" + titleName + "']").attr('type') == 'checkbox') {
                            $("[DT_Fill_Name='" + titleName + "']").prop('checked', clickData[titleName] == 1 || clickData[titleName] == '是');
                        }
                        else {
                            $("[DT_Fill_Name='" + titleName + "']").val(clickData[titleName]);
                        }
                    }
                }

                //IMG page
                $('#I_IVAN_TYPE').val(clickData['頤坊型號']);
                $('#I_FACT_NO').val(clickData['廠商編號']);
                $('#I_FACT_S_NAME').val(clickData['廠商簡稱']);
                $('#I_PROD_DESC').val(clickData['產品說明']);
                $('#I_RPT_REMARK').val(clickData['大備註']);
                Search_IMG($('#E_SUPLU_SEQ').val());
            }

            function V_BT_CHG(buttonChs) {
                $('.V_BT').attr('disabled', false);
                buttonChs.attr('disabled', 'disabled');
            }

            //ajax function
            function Search() {
                var dataReq = {};
                dataReq['Call_Type'] = 'SEARCH';

                //組json data
                $("[DT_Query_Name]").each(function () {
                    if ($(this).attr('type') == 'checkbox') {
                        dataReq[$(this).attr('DT_Query_Name')] = ($(this).is(':checked') ? '1' : '0');
                    }
                    else {
                        dataReq[$(this).attr('DT_Query_Name')] = $(this).val();
                    }
                });

                $.ajax({
                    url: apiUrl,
                    data: dataReq,
                    cache: false,
                    type: "POST",
                    datatype: "json",
                    contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                    success: function (response) {
                        if (response.length === 0) {
                            alert('<%=Resources.MP.Data_Not_Exists_Alert%>');
                            Edit_Mode = "Base";
                            Form_Mode_Change("Base");
                            $('#Table_Search_Data').empty();
                        }
                        else {
                            var columns = [];
                            columnNames = Object.keys(response[0]);
                            for (var i in columnNames) {
                                columns.push({
                                    data: columnNames[i],
                                    title: columnNames[i]
                                });
                            }
                            $('#Table_Search_Data').DataTable({
                                "data": response,
                                "destroy": true,
                                //維持scroll bar 位置
                                "preDrawCallback": function (settings) {
                                    pageScrollPos = $('div.dataTables_scrollBody').scrollTop();
                                },
                                "drawCallback": function (settings) {
                                    $('div.dataTables_scrollBody').scrollTop(pageScrollPos);
                                    Re_Bind_Inner_JS();
                                },
                                "columns": columns,
                                "columnDefs": [
                                    {
                                        className: 'text-right', targets: [8, 9, 10] //數字靠右
                                    },
                                ],
                                "order": [1, "asc"], //根據 頤坊型號 排序
                                "scrollX": true,
                                "scrollY": "62vh",
                                "searching": false,
                                "paging": false,
                                "bInfo": false, //顯示幾筆隱藏
                                "autoWidth": false //欄位小於VIEW 長度，自動擴展
                            });

                            //不顯示拿來判斷的欄位
                            $('#Table_Search_Data').DataTable().column(-1).visible(false);
                            $('#Table_Search_Data').DataTable().column(-2).visible(false);

                            //顏色設定
                            var ivanIndex = $('#Table_Search_Data').find('thead th:contains(頤坊型號)').index() + 1;
                            $('#Table_Search_Data').find('tbody tr[role=row]').each(function () {
                                var rowData = $('#Table_Search_Data').DataTable().row($(this)).data();
                                var $columnIvan = $(this).find('td:nth-child(' + ivanIndex + ')');

                                //button
                                var ivanStyle = '<input class="Call_Product_Tool" SUPLU_SEQ = "' + (rowData.SUPLU_SEQ ?? "")
                                    + '" type="button" value="' + (rowData.頤坊型號 ?? "")
                                    + '" style="text-align:left;width:100%;z-index:1000;' + ((rowData.Has_IMG == 'Y') ? 'background: #90ee90;' : '') + '" />';
                                $columnIvan.html(ivanStyle);
                            });

                            $('#Table_Search_Data').DataTable().draw();
                            $('#Table_Search_Data_info').text('Showing ' + $('#Table_Search_Data > tbody tr[role=row]').length + ' entries');
                        }
                    },
                    error: function (ex) {
                        console.log(ex.responseText);
                        alert('查詢有誤請通知資訊人員');
                    }
                });
            };

            //寫入DB
            function Insert() {
                var dataReq = {};
                dataReq['已刪除'] = 0;
                dataReq['SOURCE_TABLE'] = 'stkio';
                dataReq['SOURCE_SEQ'] = 0;
                dataReq['更新人員'] = "<%=(Session["Account"] == null) ? "IVAN10" : Session["Account"].ToString().Trim() %>";

                //組json data
                $('.updColumn').each(function () {
                    if ($(this).attr('type') == 'checkbox') {
                        dataReq[$(this).attr('DT_Fill_Name')] = ($(this).is(':checked') ? '1' : '0');
                    }
                    else if ($(this).attr('type') == 'number') {
                        dataReq[$(this).attr('DT_Fill_Name')] = ($.trim($(this).val()) == '' ? 0 : $(this).val());
                    }
                    else {
                        dataReq[$(this).attr('DT_Fill_Name')] = $(this).val();
                    }
                });

                //先將數字空白調整為0
                if ($.trim($('#E_STOCK_I_CNT').val()) == '') {
                    $('#E_STOCK_I_CNT').val(0);
                }
                if ($.trim($('#E_STOCK_O_CNT').val()) == '') {
                    $('#E_STOCK_O_CNT').val(0);
                }

                //檢核開始
                if ($.trim($('#E_ORDER_NO').val()) == '') {
                    alert('訂單號碼不可空白!');
                }
                else if ($.trim($('#E_IVAN_TYPE').val()) == '') {
                    alert('頤坊型號不可空白!');
                }
                else if ($.trim($('#E_PROD_DESC').val()) == '') {
                    alert('產品說明不可空白!');
                }
                else if ($.trim($('#E_STOCK_I_CNT').val()) == 0 && $.trim($('#E_STOCK_O_CNT').val()) == 0) {
                    alert('入庫數與出庫數不可同時為0!');
                }
                else if ($.trim($('#E_STOCK_I_CNT').val()) != 0 && $.trim($('#E_STOCK_O_CNT').val()) != 0) {
                    alert('入庫數與出庫數不可同時建檔!');
                }
                else if ($.trim($('#E_STOCK_POS').val()) == '') {
                    alert('庫區不可為空白!');
                }
                else if ($.trim($('#E_BILL_TYPE').val()) == '') {
                    alert('帳項不可為空白!');
                }
                else {
                    $.ajax({
                        url: apiUrl,
                        data: {
                            "Call_Type": "INSERT",
                            "EXEC_DATA": JSON.stringify(dataReq)
                        },
                        cache: false,
                        type: "POST",
                        datatype: "json",
                        contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                        success: function (response, status) {
                            console.log(status);
                            if (status === 'success') {
                                alert('訂單號碼:' + $('#E_ORDER_NO').val() + '已新增完成');

                                Search();
                            }
                            else {
                                alert('新增資料有誤請通知資訊人員');
                            }
                        },
                        error: function (ex) {
                            console.log(ex.responseText);
                            alert('新增資料有誤請通知資訊人員');
                            return;
                        }
                    });
                }
            };           

            //更新DB
            function Update() {
                var dataReq = {};
                dataReq['Call_Type'] = 'UPDATE';
                dataReq['SEQ'] = $('#E_SEQ').val();
                dataReq['UPD_USER'] = "<%=(Session["Account"] == null) ? "IVAN10" : Session["Account"].ToString().Trim() %>";

                //組json data
                $('.updColumn').each(function () {
                    if ($(this).attr('type') == 'checkbox') {
                        dataReq[$(this).attr('DT_Fill_Name')] = ($(this).is(':checked') ? '1' : '0');
                    }
                    else if ($(this).attr('type') == 'number') {
                        dataReq[$(this).attr('DT_Fill_Name')] = ($.trim($(this).val()) == '' ? 0 : $(this).val());
                    }
                    else {
                        dataReq[$(this).attr('DT_Fill_Name')] = $(this).val();
                    }
                });

                //先將數字空白調整為0
                if ($.trim($('#E_STOCK_I_CNT').val()) == '') {
                    $('#E_STOCK_I_CNT').val(0);
                }
                if ($.trim($('#E_STOCK_O_CNT').val()) == '') {
                    $('#E_STOCK_O_CNT').val(0);
                }

                //檢核開始
                if ($('#E_SEQ').val() === '') {
                    alert('請選擇要修改的資料');
                }
                else if ($.trim($('#E_ORDER_NO').val()) == '') {
                    alert('訂單號碼不可空白!');
                }
                else if ($.trim($('#E_IVAN_TYPE').val()) == '') {
                    alert('頤坊型號不可空白!');
                }
                else if ($.trim($('#E_PROD_DESC').val()) == '') {
                    alert('產品說明不可空白!');
                }
                else if ($.trim($('#E_STOCK_I_CNT').val()) == 0 && $.trim($('#E_STOCK_O_CNT').val()) == 0) {
                    alert('入庫數與出庫數不可同時為0!');
                }
                else if ($.trim($('#E_STOCK_I_CNT').val()) != 0 && $.trim($('#E_STOCK_O_CNT').val()) != 0) {
                    alert('入庫數與出庫數不可同時建檔!');
                }
                else if ($.trim($('#E_STOCK_POS').val()) == '') {
                    alert('庫區不可為空白!');
                }
                else if ($.trim($('#E_BILL_TYPE').val()) == '') {
                    alert('帳項不可為空白!');
                }
                else{
                    $.ajax({
                        url: apiUrl,
                        data: dataReq,
                        cache: false,
                        type: "POST",
                        datatype: "json",
                        contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                        success: function (response, status) {
                            console.log(status);
                            if (status === 'success') {
                                alert('序號:' + $('#E_SEQ').val() + '已修改完成');

                                Search();
                            }
                            else {
                                alert('修改資料有誤請通知資訊人員');
                            }
                        },
                        error: function (ex) {
                            console.log(ex.responseText);
                            alert('修改資料有誤請通知資訊人員');
                            return;
                        }
                    });
                }
            };           

            //刪除單筆資料
            function Delete() {
                if ($('#E_SEQ').val() === '') {
                    alert('請選擇要刪除的資料');
                }
                else {
                    $.ajax({
                        url: apiUrl,
                        data: {
                            "Call_Type": "DELETE",
                            "SEQ": $('#E_SEQ').val(),
                            "UPD_USER" : "<%=(Session["Account"] == null) ? "IVAN10" : Session["Account"].ToString().Trim() %>"
                        },
                        cache: false,
                        type: "POST",
                        datatype: "json",
                        contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                        success: function (response, status) {
                            console.log(status);
                            if (status === 'success') {
                                alert('序號:' + $('#E_SEQ').val() + '已刪除完成');
                                Search();
                            }
                            else {
                                alert('刪除資料有誤請通知資訊人員');
                            }
                        },
                        error: function (ex) {
                            console.log(ex.responseText);
                            alert('刪除資料有誤請通知資訊人員');
                            return;
                        }
                    });
                }
            };           

            function Search_IMG(supluSeq) {
                $.ajax({
                    url: "/CommonAshx/Common.ashx",
                    data: {
                        "Call_Type": "GET_IMG_BY_SUPLU_SEQ",
                        "SEQ": supluSeq
                    },
                    cache: false,
                    async: false,
                    type: "POST",
                    datatype: "json",
                    contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                    success: function (RR) {
                        if (RR != null && RR.length > 0) {
                            $('#I_NO_IMG').css('display', 'none');
                            $('#I_IMG').css('display', '');

                            var SRC = 'data:image/png;base64,' + RR[0].P_IMG;
                            $('#I_IMG').attr('src', SRC);
                        }
                        else {
                            $('#I_NO_IMG').css('display', '');
                            $('#I_IMG').css('display', 'none');
                        }
                    }
                });
            };             

            //TABLE 功能設定
            $('#Table_Search_Data').on('click', 'tbody tr', function () {
                ClickToEdit($(this));
            });

            //BUTTON CLICK EVENT BASE 頁
            $('#BT_Search').on('click', function () {
                Search();
                Form_Mode_Change("Search");
            });

            $('#BT_Cancel').on('click', function () {
                Edit_Mode = "Base";

                var Confirm_Check = confirm("<%=Resources.MP.Cancel_Alert%>");
                if (Confirm_Check) {
                    $('#Table_Search_Data').DataTable().clear().draw();
                    Form_Mode_Change("Base");
                }
            });

            $('#BT_EDIT_SAVE').on('click', function () {
                Update();
            });

            $('#BT_Insert').on('click', function () {
                Edit_Mode = "Insert";
                Form_Mode_Change("Search");
            });

            $('#BT_INSERT_SAVE').on('click', function () {
                Insert();
            });

            $('#BT_INSERT_CLEAR').on('click', function () {
                $('[DT_Fill_Name]').val('');
            });

            $('#BT_INSERT_CANCEL').on('click', function () {
                Edit_Mode = "Search";
                Form_Mode_Change("Search");
            });

            $('#BT_Update').on('click', function () {
                Edit_Mode = "Edit";
                Form_Mode_Change("Search");

                if ($('#Table_Search_Data > tbody tr.tableClick').length == 0) {
                    ClickToEdit($('#Table_Search_Data > tbody > tr:nth(0)'));
                }
            });

            $('#BT_EDIT_CANCEL').on('click', function () {
                Edit_Mode = "Search";
                Form_Mode_Change("Search");
            });

            $('#BT_DELETE').on('click', function () {
                var Confirm_Check = confirm("確認刪除嗎? 序號:" + $('#E_SEQ').val());
                if (Confirm_Check) {
                    Delete();
                }
            });

            //功能選單
            $('#BT_S_BASE').on('click', function () {
                if ($('#Table_Search_Data > tbody tr[role=row]').length > 0 || $('#Table_CHS_Data > tbody tr[role=row]').length > 0)
                {
                    Form_Mode_Change('Search');
                }
                else {
                    Form_Mode_Change("Base");
                }
            });    

            $('#BT_S_IMG').on('click', function () {
                Form_Mode_Change("IMG");
            });   
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <uc1:uc1 ID="uc1" runat="server" /> 
    <uc2:uc2 ID="uc2" runat="server" /> 
    <uc3:uc3 ID="uc3" runat="server" /> 
    <uc4:uc4 ID="uc4" runat="server" /> 
    <div style="width:98%;margin:0 auto; ">
        <div class="search_section_all">
           <table class="search_section_control">
            <tr class="trstyle">
                <td class="tdhstyle">頤坊型號</td>
                <td class="tdbstyle">
                    <input id="Q_IVAN_TYPE" DT_Query_Name="頤坊型號" class="textbox_char" />
                </td>
                 <td class="tdhstyle">更新日期</td>
                <td class="tdbstyle">
                    <input id="Q_UPD_DATE_S" type="date" DT_Query_Name="更新日期_S" class="date_S_style TB_DS" /><input id="Q_UPD_DATE_E" DT_Query_Name="更新日期_E" type="date" class="date_E_style TB_DE" />
                    <input id="BT_Duo_Datetime_Picker" type="button" value="…" onclick="$('#Duo_Datetime_Picker_Dialog').dialog('open');" />
                </td>
                 <td class="tdhstyle">訂單號碼</td>
                <td class="tdbstyle">
                    <input id="Q_ORDER_NO" DT_Query_Name="訂單號碼" class="textbox_char" />
                </td>
            </tr>
             <tr class="trstyle">
                <td class="tdhstyle">廠商編號</td>
                <td class="tdbstyle"> 
                    <input id="Q_FACT_NO" DT_Query_Name="廠商編號" class="textbox_char" />
                </td>
                <td class="tdhstyle">廠商簡稱</td>
                <td class="tdbstyle">
                    <input id="Q_FACT_S_NAME" DT_Query_Name="廠商簡稱" class="textbox_char" />
                </td>
                  <td class="tdhstyle">單據編號</td>
                <td class="tdbstyle">
                    <input id="Q_DOCUMENT_NO" DT_Query_Name="單據編號" class="textbox_char" />
                </td>
            </tr>
            <tr class="trstyle">
                <td class="tdhstyle">庫區</td>
                        <td class="tdbstyle">
                             <select id="Q_STOCK_POS" DT_Query_Name="庫區" >
                                <option selected="selected"value=""></option>
                                <option value="大貨">大貨</option>
                                <option value="分配">分配</option>
                                <option value="內湖">內湖</option>
                                <option value="新竹">新竹</option>
                                <option value="樣品">樣品</option>
                                <option value="展場">展場</option>
                                <option value="託管">託管</option>
                                <option value="留底">留底</option>
                                <option value="展示">展示</option>
                                <option value="設計">設計</option>
                                <option value="廠商">廠商</option>
                                <option value="台北">台北</option>
                                <option value="台中">台中</option>
                                <option value="高雄">高雄</option>
                            </select>
                        </td>
                 <td class="tdhstyle">備註</td>
                <td class="tdbstyle">
                    <input id="Q_REMARK" DT_Query_Name="備註" class="textbox_char" />
                </td>
            </tr>
            <tr class="trstyle">
                <td class="tdtstyleRight" colspan="7">
                    <input type="button" id="BT_Search" class="buttonStyle" value="<%=Resources.MP.Search%>" />
                    <input type="button" id="BT_Insert" class="buttonStyle" value="<%=Resources.MP.Insert%>" />
                    <input type="button" id="BT_Update" class="buttonStyle" value="修改" />
                    <input type="reset" id="BT_Cancel" class="buttonStyle" value="<%=Resources.MP.Cancel%>" style="display: none;" />
                </td>
            </tr>
        </table>
        </div>
        <div class="button_change_section">
            &nbsp;
            <input type="button" id="BT_S_BASE" class="V_BT" value="主檔"  disabled="disabled" />
            <input type="button" id="BT_S_IMG" class="V_BT" value="圖型" />
        </div>

        <div id="Div_DT">
            <div id="Div_DT_View" style=" width:60%;height:71vh; border-style:solid;border-width:1px; float:left;">
                <div class="dataTables_info" id="Table_Search_Data_info" role="status" aria-live="polite"></div>
                <table id="Table_Search_Data" class="Table_Search table table-striped table-bordered">
                    <thead style="white-space:nowrap"></thead>
                    <tbody style="white-space:nowrap"></tbody>
                </table>
            </div>
    
            <div id="Div_EDIT_Data" class=" Div_D" style="width:35%; height:71vh;white-space:nowrap; border-style:solid; border-width:1px;  float:right; overflow:auto">
                <table class="edit_section_control">
                    <tr class="trstyle"> 
                        <td class="tdbstyle" style="height: 2vh; font-size: smaller;" >&nbsp</td>
                    </tr>
                    <tr class="trstyle" >
                         <td class="tdEditstyle">訂單號碼</td>
                        <td class="tdbstyle">
                            <input id="E_ORDER_NO" DT_Fill_Name="訂單號碼" class="textbox_char updColumn" />
                        </td>
                        <td class="tdEditstyle">序號</td>
                        <td class="tdbstyle">
                            <input id="E_SEQ" DT_Fill_Name="序號" class="textbox_char" disabled="disabled" />
                            <input id="E_SUPLU_SEQ" type="hidden" DT_Fill_Name="SUPLU_SEQ" class="textbox_char updColumn" />
                        </td>
                    </tr>
                     <tr class="trstyle">
                        <td class="tdEditstyle">頤坊型號</td>
                        <td class="tdbstyle">
                            <input id="E_IVAN_TYPE" DT_Fill_Name="頤坊型號"  class="textbox_char updColumn" disabled="disabled" />
                            <input id="BT_E_IVAN_TYPE" style="font-size:15px" type="button" value="..." />
                        </td>
                         <td class="tdEditstyle">暫時型號</td>
                        <td class="tdbstyle">
                            <input id="E_TMP_TYPE" DT_Fill_Name="暫時型號"  class="textbox_char updColumn" disabled="disabled" />
                        </td>
                    </tr>
                     <tr class="trstyle">
                        <td class="tdEditstyle">廠商編號</td>
                        <td class="tdbstyle">
                            <input id="E_FACT_NO" DT_Fill_Name="廠商編號"  class="textbox_char updColumn" disabled="disabled" />
                        </td>
                        <td class="tdEditstyle">廠商簡稱</td>
                        <td class="tdbstyle">
                            <input id="E_FACT_S_NAME" DT_Fill_Name="廠商編號"  class="textbox_char updColumn" disabled="disabled" />
                        </td>
                    </tr>
                     <tr class="trstyle">
                        <td class="tdEditstyle">單位</td>
                        <td class="tdbstyle">
                            <input id="E_UNIT" DT_Fill_Name="單位"  class="textbox_char updColumn" disabled="disabled" />
                        </td>
                        <td class="tdEditstyle">產品說明</td>
                        <td class="tdbstyle">
                            <input id="E_PROD_DESC" DT_Fill_Name="產品說明"  class="textbox_char" disabled="disabled" />
                        </td>
                    </tr>
                    <tr class="trstyle">
                        <td class="tdEditstyle">客戶編號</td>
                        <td class="tdbstyle">
                            <input id="E_CUST_NO" DT_Fill_Name="客戶編號"  class="textbox_char updColumn" disabled="disabled" />
                            <input id="BT_CUST_CHS" style="font-size:15px" type="button" value="..." />
                        </td>
                        <td class="tdEditstyle">客戶簡稱</td>
                        <td class="tdbstyle">
                            <input id="E_CUST_S_NAME" DT_Fill_Name="客戶簡稱"  class="textbox_char updColumn" disabled="disabled" />
                        </td>
                    </tr>
                    <tr class="trstyle">
                        <td class="tdEditstyle">庫區</td>
                        <td class="tdbstyle">
                             <select id="E_STOCK_POS" DT_Fill_Name="庫區" class="updColumn" >
                                <option selected="selected" value="大貨">大貨</option>
                                <option value="分配">分配</option>
                                <option value="內湖">內湖</option>
                                <option value="新竹">新竹</option>
                                <option value="樣品">樣品</option>
                                <option value="展場">展場</option>
                                <option value="託管">託管</option>
                                <option value="留底">留底</option>
                                <option value="展示">展示</option>
                                <option value="設計">設計</option>
                                <option value="廠商">廠商</option>
                                <option value="台北">台北</option>
                                <option value="台中">台中</option>
                                <option value="高雄">高雄</option>
                            </select>
                        </td>
                        <td class="tdEditstyle">單據編號</td>
                        <td class="tdbstyle">
                            <input id="E_DOCUMENT_NO" DT_Fill_Name="單據編號"  class="textbox_char updColumn" />
                        </td>
                    </tr>
                    <tr class="trstyle">
                        <td class="tdEditstyle"></td>
                        <td class="tdbstyle">
                        </td>
                        <td colspan="2" style="color:orange">不輸入庫位時 預設為原庫位</td>
                    </tr>
                    <tr class="trstyle">
                        <td class="tdEditstyle">入庫數</td>
                        <td class="tdbstyle">
                            <input id="E_STOCK_I_CNT" type="number" DT_Fill_Name="入庫數" class="textbox_char updColumn"  />
                        </td>
                        <td class="tdEditstyle">庫位</td>
                        <td class="tdbstyle">
                            <input id="E_STOCK_LOC" DT_Fill_Name="庫位" class="textbox_char updColumn"  />
                        </td>
                    </tr>
                     <tr class="trstyle">
                        <td class="tdEditstyle">出庫數</td>
                        <td class="tdbstyle">
                            <input id="E_STOCK_O_CNT" type="number" DT_Fill_Name="出庫數" class="textbox_char updColumn"  />
                        </td>
                        <td class="tdEditstyle">核銷數</td>
                        <td class="tdbstyle">
                             <input id="E_STOCK_CNT" type="number" DT_Fill_Name="核銷數" class="textbox_char"  disabled="disabled" />
                        </td>
                    </tr>
                     <tr class="trstyle">
                         <td class="tdEditstyle">帳項</td>
                        <td class="tdbstyle">
                            <select id="E_BILL_TYPE" DT_Fill_Name="帳項" class="textbox_char updColumn" >
                                <option selected="selected" value=""></option>
                            </select>
                        </td>
                        <td class="tdEditstyle">備註</td>
                        <td class="tdbstyle" >
                            <input id="E_REMARK" DT_Fill_Name="備註" class="textbox_char updColumn" maxlength="30"  />
                        </td>
                    </tr>
                    <tr class="trstyle">
                        <td class="tdEditstyle">更新人員</td>
                        <td class="tdbstyle">
                            <input id="E_UPD_USER" DT_Fill_Name="更新人員" class="textbox_char " disabled="disabled" />
                        </td>
                        <td class="tdEditstyle">更新日期</td>
                        <td class="tdbstyle">
                            <input id="E_UPD_DATE" type="date" DT_Fill_Name="更新日期" class="date_S_style " disabled="disabled" />
                        </td>
                    </tr>
                    <tr class="trstyle"> 
                        <td class="tdbstyle" style="height: 8vh; font-size: smaller;" >&nbsp</td>
                    </tr>
                     <tr class="trCenterstyle"> 
                         <td colspan="4" style="text-align:center" >
                            <input type="button" id="BT_DELETE" style="display:inline-block" class="BTN modeButton" value="刪除"  />
                            <input type="button" id="BT_INSERT_SAVE" style="display:inline-block" class="BTN modeButton" value="新增儲存"  />
                            <input type="button" id="BT_EDIT_SAVE" style="display:inline-block" class="BTN modeButton" value="修改儲存"  />
                            <input type="button" id="BT_INSERT_CLEAR" style="display:inline-block" class="BTN modeButton" value="清空"  />
                            <input type="button" id="BT_INSERT_CANCEL" style="display:inline-block" class="BTN modeButton" value="返回"  />
                         </td>
                    </tr>
                </table>
            </div>
            <div id="Div_IMG_DETAIL" class=" Div_D" style="width:35%;height:71vh; border-style:solid;border-width:1px; float:right; overflow:auto ">
                <table class="edit_section_control">
                     <tr class="trstyle"> 
                        <td class="tdbstyle" style="height: 5vh; font-size: smaller;" >&nbsp</td>
                    </tr>
                    <tr class="trstyle">
                        <td class="tdEditstyle">頤坊型號</td>
                        <td class="tdbstyle">
                            <input id="I_IVAN_TYPE" class="textbox_char" disabled="disabled" style="width:100%"  />
                        </td>
                        <td class="tdEditstyle">廠商編號</td>
                        <td class="tdbstyle">
                            <input id="I_FACT_NO"  class="textbox_char" disabled="disabled"  style="width:100%" />
                        </td>
                    </tr>
                    <tr class="trstyle">
                        <td class="tdEditstyle"></td>
                        <td class="tdbstyle"></td>
                        <td class="tdEditstyle">廠商簡稱</td>
                        <td class="tdbstyle" >
                            <input id="I_FACT_S_NAME" class="textbox_char" disabled="disabled" style="width:100%"  />
                        </td>
                    </tr>
                    <tr class="trstyle">
                        <td class="tdEditstyle">產品說明</td>
                        <td class="tdbstyle" colspan="4">
                            <input id="I_PROD_DESC" class="textbox_char" style="width:80%" disabled="disabled"  />
                        </td>
                    </tr>

                    <tr class="trstyle">
                        <td style="text-align:center" colspan="4">
                            <img id="I_IMG" src="#" style="max-width:100%; max-height:100%;display:none" />
                            <span id="I_NO_IMG" >查無圖檔</span>
                        </td>
                    </tr>

                </table>
            </div> 
        </div>
    </div>

</asp:Content>
