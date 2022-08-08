<%@ Page Title="庫存查詢" Language="C#" MasterPageFile="~/MP.master" AutoEventWireup="true" CodeFile="Stock_Search.aspx.cs" Inherits="Stock_Search" %>
<%@ Register TagPrefix="uc2" TagName="uc2" Src="~/User_Control/Dia_Product_ALL.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="/css/dataTables.bootstrap4.min.css" rel="stylesheet" />
    <script src="/js/jquery.dataTables.min.js"></script>
    <script src="/js/dataTables.bootstrap4.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            var Edit_Mode = "Base";
            var apiUrl = "/Stock/Ashx/Stock_Search.ashx";
            //隱藏滾動卷軸
            document.body.style.overflow = 'hidden';

            //init CONTROLER
            Form_Mode_Change("Base");

            //DDL
            DDL_Bind();
            function DDL_Bind() {
                $.ajax({
                    url: "/Web_Service/DDL_DataBind.asmx/ProdStatusDDL",
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
                        $('#Q_PROD_STATUS').html(DDL_Option);
                    },
                    error: function (response) {
                        alert(response.responseText);
                    },
                });
            };

            window.document.body.onbeforeunload = function () {
                if (Edit_Mode === "Insert" || Edit_Mode === "Edit") {
                    return '您尚未將編輯過的表單資料送出，請問您確定要離開網頁嗎？';
                }
            }

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
                        $('#BT_E_CANCEL').css('display', 'none');

                        V_BT_CHG($('#BT_S_BASE'));
                        break;
                    case "IMG":
                        if ($('#Table_Search_Data > tbody tr.tableClick').length == 0) {
                            alert('請先查詢!');
                            return;
                        }

                        $('.Div_D').css('display', 'none');
                        $('#Div_DT_View').css('width', '60%');
                        $('#Div_IMG_DETAIL').css('display', '');

                        //設定DEFAULT Click
                        if ($('#Table_Search_Data > tbody tr[role=row]').length != 0 && $('#Table_Search_Data > tbody tr.tableClick').length == 0) {
                            ClickToEdit($('#Table_Search_Data > tbody > tr:nth(0)'));
                        }

                        V_BT_CHG($('#BT_S_IMG'));
                        break;
                    case "COLOR":
                        $('.Div_D').css('display', 'none');
                        $('#Div_DT_View').css('width', '60%');
                        $('#Div_COLOR').css('display', '');
                        if ($('#Table_Search_Data > tbody tr[role=row]').length != 0) {
                            $('#Table_Search_Data').DataTable().draw();
                        }

                        V_BT_CHG($('#BT_S_COLOR'));
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
                //點擊賦予顏色
                $('#Table_Search_Data > tbody tr').removeClass("tableClick");
                click_tr.addClass("tableClick");
                var clickData = $('#Table_Search_Data').DataTable().row(click_tr).data();

                //IMG page
                $('#I_IVAN_TYPE').val(clickData['頤坊型號']);
                $('#I_FACT_NO').val(clickData['廠商編號']);
                $('#I_FACT_S_NAME').val(clickData['廠商簡稱']);
                $('#I_PROD_DESC').val(clickData['產品說明']);
                $('#I_RPT_REMARK').val(clickData['大備註']);
                Search_IMG(clickData['序號']);
            }

            function V_BT_CHG(buttonChs) {
                $('.V_BT').attr('disabled', false);
                buttonChs.attr('disabled', 'disabled');
            }

            //ajax function
            function Search_Data() {
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
                                "order": [1, "asc"], //根據 頤坊型號 排序
                                "scrollX": true,
                                "scrollY": "62vh",
                                "searching": false,
                                "paging": false,
                                "bInfo": false, //顯示幾筆隱藏
                                "autoWidth": false //欄位小於VIEW 長度，自動擴展
                            });

                            //不顯示拿來判斷的欄位
                            //$('#Table_Search_Data').DataTable().column(-1).visible(false);
                            //$('#Table_Search_Data').DataTable().column(-2).visible(false);

                            //顏色設定
                            var seqIndex = $('#Table_Search_Data').find('thead th:contains(序號)').index() + 1;
                            var ivanIndex = $('#Table_Search_Data').find('thead th:contains(頤坊型號)').index() + 1;
                            var imgIndex = $('#Table_Search_Data').find('thead th:contains(Has_IMG)').index() + 1;
                            var devIndex = $('#Table_Search_Data').find('thead th:contains(開發中)').index() + 1;
                            var unitIndex = $('#Table_Search_Data').find('thead th:contains(單位)').index() + 1;
                            var custTypeIndex = $('#Table_Search_Data').find('thead th:contains(銷售型號)').index() + 1;
                            var stockIndex = $('#Table_Search_Data').find('thead th:contains(大貨庫存數)').index() + 1;
                            var stockReplaceIndex = $('#Table_Search_Data').find('thead th:contains(替代庫存數)').index() + 1;
                            var ispIndex = $('#Table_Search_Data').find('thead th:contains(ISP上架)').index() + 1;
                            var stopDateIndex = $('#Table_Search_Data').find('thead th:contains(停用日期)').index() + 1;
                            var taipeiIndex = $('#Table_Search_Data').find('thead th:contains(台北庫存數)').index() + 1;
                            var taiChIndex = $('#Table_Search_Data').find('thead th:contains(台中庫存數)').index() + 1;
                            var kaoShungIndex = $('#Table_Search_Data').find('thead th:contains(高雄庫存數)').index() + 1;
                            $('#Table_Search_Data').find('tbody tr[role=row]').each(function () {

                                var rowData = $('#Table_Search_Data').DataTable().row($(this)).data();

                                var $columnSeq = $(this).find('td:nth-child(' + seqIndex + ')');
                                var $columnIvan = $(this).find('td:nth-child(' + ivanIndex + ')');
                                var $columnImg = $(this).find('td:nth-child(' + imgIndex + ')');
                                var $custTypeColumn = $(this).find('td:nth-child(' + custTypeIndex + ')');
                                var $devColumn = $(this).find('td:nth-child(' + devIndex + ')');
                                var $unitColumn = $(this).find('td:nth-child(' + unitIndex + ')');
                                var $stopDateColumn = $(this).find('td:nth-child(' + stopDateIndex + ')');
                                var $stockColumn = $(this).find('td:nth-child(' + stockIndex + ')');
                                var $ispColumn = $(this).find('td:nth-child(' + ispIndex + ')');
                                var $taipeiColumn = $(this).find('td:nth-child(' + taipeiIndex + ')');
                                var $taiChColumn = $(this).find('td:nth-child(' + taiChIndex + ')');
                                var $kaoShungColumn = $(this).find('td:nth-child(' + kaoShungIndex + ')');

                                //開發
                                if ($.trim($stopDateColumn.text()) != '') {
                                    $devColumn.css("background-color", "gainsboro");
                                    $stopDateColumn.css("background-color", "gainsboro");
                                    $unitColumn.css("background-color", "gainsboro");
                                }
                                else if ($.trim($devColumn.text()) == 'Y') {
                                    $devColumn.css("background-color", "pink");
                                    $unitColumn.css("background-color", "pink");
                                }

                                //銷售型號
                                if ($.trim($custTypeColumn.text()) != '' && $.trim($custTypeColumn.text()) != $.trim($columnIvan.text())) {
                                    $custTypeColumn.css("background-color", "cyan");
                                }

                                //大貨庫存
                                var $stockColumn = $(this).find('td:nth-child(' + stockIndex + ')');
                                if ($.trim(rowData["安全數不足"]) == 'Y') {
                                    $stockColumn.css("background-color", "yellow");
                                }

                                //替代庫存
                                var $stockReplaceColumn = $(this).find('td:nth-child(' + stockReplaceIndex + ')');
                                if ($.trim($stockReplaceColumn.text()) != '0' && $.trim($stockReplaceColumn.text()) != '') {
                                    $stockReplaceColumn.css("background-color", "mistyRose");
                                }

                                //ISP上架
                                switch ($.trim($ispColumn.text())) {
                                    case "售完":
                                        $ispColumn.css("background-color", "fuchsia");
                                        break;
                                    case "草稿":
                                        $ispColumn.css("background-color", "thistle");
                                        break;
                                    case "封存":
                                        $ispColumn.css("background-color", "dimGray");
                                        break;
                                }

                                //所屬門市
                                switch (  '<%=Session["DEFAULT_STORE"]%>') {
                                    case "台北":
                                        $taipeiColumn.css("background-color", "peachPuff");
                                        break;
                                    case "台中":
                                        $taiChColumn.css("background-color", "peachPuff");
                                        break;
                                    case "高雄":
                                        $kaoShungColumn.css("background-color", "peachPuff");
                                        break;
                                    case "ISP":
                                        $ispColumn.css("background-color", "peachPuff");
                                        break;
                                }

                                //button
                                var ivanStyle = '<input class="Call_Product_Tool" SUPLU_SEQ = "' + ($columnSeq.text() ?? "")
                                    + '" type="button" value="' + ($columnIvan.text() ?? "")
                                    + '" style="text-align:left;width:100%;z-index:1000;' + (($columnImg.text() == 'Y') ? 'background: #90ee90;' : '') + '" />';
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
                if ($.trim($('#Q_STOCK_LOC').val()) != '') {
                    if ($.trim($('#Q_STOCK_POS').val()) == '') {
                        alert('庫位搜尋，倉位不可為不限!');
                        return;
                    }
                }

                Form_Mode_Change("Search");
                Search_Data();
            });

            $('#BT_Cancel').on('click', function () {
                Edit_Mode = "Base";

                var Confirm_Check = confirm("<%=Resources.MP.Cancel_Alert%>");
                if (Confirm_Check) {
                    $('#Table_Search_Data').DataTable().clear().draw();
                    Form_Mode_Change("Base");
                }
            });

            //功能選單
            $('#BT_S_BASE').on('click', function () {
                if ($('#Table_Search_Data > tbody tr[role=row]').length > 0) {
                    Form_Mode_Change('Search');
                }
                else {
                    Form_Mode_Change("Base");
                }
            });

            $('#BT_S_IMG').on('click', function () {
                Form_Mode_Change("IMG");
            });

            $('#BT_S_COLOR').on('click', function () {
                Form_Mode_Change("COLOR");
            });

        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <uc2:uc2 ID="uc2" runat="server" /> 
    <div style="width:98%;margin:0 auto; ">
        <div class="search_section_all">
            <table class="search_section_control">
            <tr class="trstyle">
                <td class="tdhstyle">頤坊型號</td>
                <td class="tdbstyle">
                    <input id="Q_IVAN_TYPE" DT_Query_Name="頤坊型號" class="textbox_char" />
                </td>
                <td class="tdhstyle">頤坊條碼</td>
                <td class="tdbstyle">
                    <input id="Q_IVAN_BARCODE" DT_Query_Name="頤坊條碼"  class="textbox_char" />
                </td>
                <td class="tdhstyle">暫時型號</td>
                <td class="tdbstyle">
                    <input id="Q_TMP_TYPE" DT_Query_Name="暫時型號" class="textbox_char" />
                </td>
                <td class="tdhstyle">倉位</td>
                <td class="tdbstyle">
                    <select id="Q_STOCK_POS" DT_Query_Name="倉位" >
                        <option selected="selected"value="">不限</option>
                        <option value="大貨">大貨</option>
                        <option value="分配">分配</option>
                        <option value="內湖">內湖</option>
                        <option value="ISP">ISP</option>
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
                 <td class="tdhstyle">廠商型號</td>
                <td class="tdbstyle">
                    <input id="Q_FACT_TYPE" DT_Query_Name="廠商型號" class="textbox_char" />
                </td>
                  <td class="tdhstyle"></td>
                <td class="tdbstyle">
                    <input id="Q_ONLY_STORE" type="checkbox" DT_Query_Name="限門市" class="textbox_char" />
                    限門市
                    <input id="Q_ZERO_STOCK" type="checkbox" DT_Query_Name="售完" class="textbox_char" />
                    售完
                </td>
            </tr>
            <tr class="trstyle">
                <td class="tdhstyle">產品說明</td>
                <td class="tdbstyle">
                    <input id="Q_PROD_DESC" DT_Query_Name="產品說明" class="textbox_char" />
                </td>
                <td class="tdhstyle">銷售型號</td>
                <td class="tdbstyle">
                    <input id="Q_CUST_TYPE" DT_Query_Name="銷售型號" class="textbox_char" />
                </td>
                <td class="tdhstyle">庫位</td>
                <td class="tdbstyle">
                    <input id="Q_STOCK_LOC" DT_Query_Name="庫位" class="textbox_char" />
                </td>
                <td class="tdhstyle"></td>
                <td class="tdbstyle">
                    <input id="Q_DRAFT" type="checkbox" DT_Query_Name="草稿" class="textbox_char" />
                    草稿
                    <input id="Q_STOCK_SAVE" type="checkbox" DT_Query_Name="封存" class="textbox_char" />
                    封存
                </td>
            </tr>
            <tr class="trstyle">
                <td class="tdhstyle">產品狀態</td>
                <td class="tdbstyle">
                    <select id="Q_PROD_STATUS" DT_Query_Name="產品狀態" >
                        <option selected="selected" value=""></option>
                    </select>
                </td>
            </tr>
            <tr class="trstyle">
                <td class="tdtstyleRight" colspan="8">
                    <input type="button" id="BT_Search" class="buttonStyle" value="<%=Resources.MP.Search%>" />
                    <input type="button" id="BT_Cancel" class="buttonStyle" value="<%=Resources.MP.Cancel%>" style="display: none;" />
                </td>
            </tr>
        </table>
        </div>
        <div class="button_change_section">
            &nbsp;
            <input type="button" id="BT_S_BASE" class="V_BT" value="主檔"  disabled="disabled" />
            <input type="button" id="BT_S_IMG" class="V_BT" value="圖型" />
            <input type="button" id="BT_S_COLOR" class="V_BT" value="圖例" />
        </div>

        <div id="Div_DT">
            <div id="Div_DT_View" style=" width:60%;height:71vh; border-style:solid;border-width:1px; float:left;">
                <div class="dataTables_info" id="Table_Search_Data_info" role="status" aria-live="polite"></div>
                <table id="Table_Search_Data" class="Table_Search table table-striped table-bordered">
                    <thead style="white-space:nowrap"></thead>
                    <tbody style="white-space:nowrap"></tbody>
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
            <div id="Div_COLOR" class=" Div_D" style="width:35%;height:71vh; border-style:solid;border-width:1px; float:right; overflow:auto ">
                <table class="edit_section_control" style="width:70%">
                     <tr class="trstyle"> 
                        <td class="tdbstyle" style="height: 10vh; font-size: smaller;" >&nbsp</td>
                    </tr>
                    <tr class="trstyle">
                        <td style="background-color:#90ee90;width:10%"></td>
                        <td>有圖檔</td>
                        <td style="background-color:pink;width:10%"></td>
                        <td>開發中</td>
                    </tr>
                    <tr class="trstyle">
                        <td style="background-color:gainsboro;width:10%"></td>
                        <td>停用</td>
                        <td style="background-color:cyan;width:10%"></td>
                        <td>銷售型號</td>
                    </tr>
                    <tr class="trstyle">
                        <td style="background-color:peachpuff;width:10%"></td>
                        <td>所屬門市</td>
                        <td style="background-color:yellow;width:10%"></td>
                        <td>大貨安全數不足</td>
                    </tr>
                    <tr class="trstyle">
                        <td style="background-color:mistyrose;width:10%"></td>
                        <td>替代庫存</td>
                        <td style="background-color:fuchsia;width:10%"></td>
                        <td>售完</td>
                    </tr>
                    <tr class="trstyle">
                        <td style="background-color:thistle;width:10%"></td>
                        <td>Shopify草稿</td>
                        <td style="background-color:dimgray;width:10%"></td>
                        <td>Shopify封存</td>
                    </tr>
                    <tr class="trstyle"> 
                        <td class="tdbstyle" style="height: 5vh; font-size: smaller;" >&nbsp</td>
                    </tr>
                     <tr class="trstyle">
                        <td colspan="4">PS1. 庫存在途:庫存採購未點收(X/WR)</td>
                    </tr>
                    <tr class="trstyle">
                        <td colspan="4">PS2. 在途數:全部採購未點收(含訂單採購)</td>
                    </tr>
                    <tr class="trstyle">
                        <td colspan="4">PS3. 快取區: 位於汐止舊廠4F</td>
                    </tr>
                    <tr class="trstyle">
                        <td colspan="4">PS4. 大貨庫存已含下腳庫存 (皮革碎皮)</td>
                    </tr>
                    <tr class="trstyle">
                        <td colspan="4">PS5. 替代庫存:相同頤坊型號與產品二階</td>
                    </tr>
                </table>
            </div> 
        </div>
    </div>

</asp:Content>
