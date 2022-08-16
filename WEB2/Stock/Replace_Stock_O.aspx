<%@ Page Title="替代庫存出庫" Language="C#" MasterPageFile="~/MP.master" AutoEventWireup="true" CodeFile="Replace_Stock_O.aspx.cs" Inherits="Replace_Stock_O" %>
<%@ Register TagPrefix="uc1" TagName="uc1" Src="~/User_Control/Dia_Product_Selector.ascx" %>
<%@ Register TagPrefix="uc2" TagName="uc2" Src="~/User_Control/Dia_Product_ALL.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="/css/dataTables.bootstrap4.min.css" rel="stylesheet" />
    <script src="/js/jquery.dataTables.min.js"></script>
    <script src="/js/dataTables.bootstrap4.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            var Edit_Mode;
            var apiUrl = "/Stock/Ashx/Replace_Stock_O.ashx";
            //隱藏滾動卷軸
            document.body.style.overflow = 'hidden';

            //init CONTROLER
            Form_Mode_Change("Base");

            window.document.body.onbeforeunload = function () {
                if (Edit_Mode === "Insert" || Edit_Mode === "Edit") {
                    return '您尚未將編輯過的表單資料送出，請問您確定要離開網頁嗎？';
                }
            }

            //Dialog
            $('#BT_E_FACT_NO').on('click', function () {
                $("#SPD_TB_IM").val($("#E_IVAN_TYPE").val());
                $("#SPD_TB_IM").attr('disabled', 'disabled');
                $("#Search_Product_Dialog").dialog('open');
                $("#SPD_BT_Search").trigger("click");
            });

            $('#SPD_Table_Product').on('click', '.PROD_SEL', function () {
                $('#E_SEQ_I').val($(this).parent().parent().find('td:nth(1)').text());
                $('#E_FACT_NO_I').val($(this).parent().parent().find('td:nth(4)').text());
                $('#E_FACT_S_NAME_I').val($(this).parent().parent().find('td:nth(5)').text());

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
                    case "EXEC":
                        $('.Div_D').css('display', 'none');
                        $('#Div_DT_View').css('display', '');
                        $('#Div_DT_View').css('width', '60%');
                        $('#BT_Cancel').css('display', '');
                        $('#Div_EXEC_Data').css('display', '');

                        V_BT_CHG($('#BT_S_EXEC'));
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
                Search_IMG(clickData['序號']);
            }

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
                            $('#Table_Search_Data').DataTable().clear().draw();
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
                                var ivanStyle = '<input class="Call_Product_Tool" SUPLU_SEQ = "' + (rowData.序號 ?? "")
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
                //先將數字空白調整為0
                if ($.trim($('#E_STOCK_O_CNT').val()) == '') {
                    $('#E_STOCK_O_CNT').val(0);
                }

                //檢核開始
                if ($.trim($('#E_ORDER_NO').val()) == '') {
                    alert('訂單號碼不可空白!');
                }
                else if ($.trim($('#E_IVAN_TYPE').val()) == '') {
                    alert('請至少選擇一筆資料!');
                }
                else if ($.trim($('#E_STOCK_O_CNT').val()) == 0) {
                    alert('出庫數不可為0!');
                }
                else if ($.trim($('#E_FACT_NO_I').val()) == '') {
                    alert('入庫廠商不可空白!');
                }
                else {
                    var liSeq = [];
                    var liStockIOCnt = [];
                    var liStockPos = [];
                    var liStockIO = [];
                    var liBillType = [];

                    //待出庫
                    liSeq.push($('#E_SEQ_O').val());
                    liStockIOCnt.push($('#E_STOCK_O_CNT').val());
                    liStockPos.push('大貨');
                    liStockIO.push('出庫');
                    liBillType.push('G');

                    //待入庫
                    liSeq.push($('#E_SEQ_I').val());
                    liStockIOCnt.push($('#E_STOCK_O_CNT').val());
                    liStockPos.push('大貨');
                    liStockIO.push('入庫');
                    liBillType.push('5');

                    var dataReq = {};
                    dataReq['Call_Type'] = 'EXEC';
                    dataReq['SEQ'] = liSeq;
                    dataReq['STOCK_POS'] = liStockPos;
                    dataReq['STOCK_IO_CNT'] = liStockIOCnt;
                    dataReq['STOCK_IO'] = liStockIO;
                    dataReq['BILL_TYPE'] = liBillType;
                    dataReq['訂單號碼'] = $('#E_ORDER_NO').val();
                    dataReq['單據編號'] = '替代庫存出庫';
                    dataReq['客戶編號'] = '';
                    dataReq['客戶簡稱'] = '';
                    dataReq['廠商編號'] = $('#E_FACT_NO_I').val();
                    dataReq['廠商簡稱'] = $('#E_FACT_S_NAME_I').val();
                    dataReq['備註'] = $('#E_REMARK').val();

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
                                alert('訂單號碼:' + $('#E_ORDER_NO').val() + '已新增完成');
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

            //TABLE 功能設定
            $('#Table_Search_Data').on('click', 'tbody tr', function () {
                ClickToEdit($(this));
            });

            //BUTTON CLICK EVENT BASE 頁
            $('#BT_Search').on('click', function () {
                Search();
                Form_Mode_Change("EXEC");
            });

            $('#BT_Cancel').on('click', function () {
                Edit_Mode = "Base";

                var Confirm_Check = confirm("<%=Resources.MP.Cancel_Alert%>");
                if (Confirm_Check) {
                    $('#Table_Search_Data').DataTable().clear().draw();
                    Form_Mode_Change("Base");
                }
            });

            //BUTTON CLICK EVENT 執行頁
            $('#BT_EXECUTE').on('click', function () {
                Insert();
            });

            $('#Table_EXEC_Data').on('click', 'tbody tr', function () {
                ClickToEdit($(this));
            });

            $('#BT_EXECUTE_CANCEL').on('click', function () {
                Edit_Mode = "Base";
                Form_Mode_Change("Search");
            });

            //功能選單
            $('#BT_S_EXEC').on('click', function () {
                Form_Mode_Change("EXEC");
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
    <div style="width:98%;margin:0 auto; ">
        <div class="search_section_all">
           <table class="search_section_control">
            <tr class="trstyle">
                <td class="tdhstyle">頤坊型號</td>
                <td class="tdbstyle">
                    <input id="Q_IVAN_TYPE" DT_Query_Name="頤坊型號" class="textbox_char" />
                </td>
            </tr>
            <tr class="trstyle">
                <td class="tdtstyleRight" colspan="8">
                    <input type="button" id="BT_Search" class="buttonStyle" value="<%=Resources.MP.Search%>" />
                    <input type="reset" id="BT_Cancel" class="buttonStyle" value="<%=Resources.MP.Cancel%>" style="display: none;" />
                </td>
            </tr>
        </table>
        </div>
        <div class="button_change_section">
            &nbsp;
            <input type="button" id="BT_S_EXEC" class="V_BT" value="出庫" disabled="disabled" />
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
    
            <div id="Div_EXEC_Data" class=" Div_D" style="width:35%; height:71vh;white-space:nowrap; border-style:solid; border-width:1px;  float:right; overflow:auto">
                <table class="edit_section_control">
                    <tr class="trstyle"> 
                        <td class="tdbstyle" style="height: 2vh; font-size: smaller;" >&nbsp</td>
                    </tr>
                     <tr class="trstyle">
                        <td class="tdEditstyle">頤坊型號</td>
                        <td class="tdbstyle">
                            <input id="E_SEQ_O" type="hidden" DT_Fill_Name="序號"  class="textbox_char" disabled="disabled" />
                            <input id="E_IVAN_TYPE" DT_Fill_Name="頤坊型號"  class="textbox_char" disabled="disabled" />
                        </td>
                         <td class="tdEditstyle">暫時型號</td>
                        <td class="tdbstyle">
                            <input id="E_TMP_TYPE" DT_Fill_Name="暫時型號"  class="textbox_char" disabled="disabled" />
                        </td>
                    </tr>
                     <tr class="trstyle">
                        <td class="tdEditstyle">出庫廠商</td>
                        <td class="tdbstyle">
                            <input id="E_SEQ_I" type="hidden"  class="textbox_char" disabled="disabled" />
                            <input id="E_FACT_NO_O" DT_Fill_Name="廠商編號"  class="textbox_char" disabled="disabled" />
                        </td>
                        <td class="tdEditstyle">出庫廠商簡稱</td>
                        <td class="tdbstyle">
                            <input id="E_FACT_S_NAME_O" DT_Fill_Name="廠商簡稱"  class="textbox_char" disabled="disabled" />
                        </td>
                    </tr>
                     <tr class="trstyle">
                        <td class="tdEditstyle">單位</td>
                        <td class="tdbstyle">
                            <input id="E_UNIT" DT_Fill_Name="單位"  class="textbox_char" disabled="disabled" />
                        </td>
                        <td class="tdEditstyle">產品說明</td>
                        <td class="tdbstyle">
                            <input id="E_PROD_DESC" DT_Fill_Name="產品說明"  class="textbox_char" disabled="disabled" />
                        </td>
                    </tr>
                    <tr class="trstyle">
                        <td class="tdEditstyle">訂單號碼</td>
                        <td class="tdbstyle">
                            <input id="E_ORDER_NO" class="textbox_char" />
                        </td>
                        <td class="tdEditstyle">出庫數量</td>
                        <td class="tdbstyle">
                            <input id="E_STOCK_O_CNT" type="number" class="textbox_char" value="0" />
                        </td>
                    </tr>
                    <tr class="trstyle">
                        <td class="tdEditstyle">入庫廠商</td>
                        <td class="tdbstyle">
                            <input id="E_FACT_NO_I" class="textbox_char" disabled="disabled" />
                            <input id="BT_E_FACT_NO" style="font-size:15px" type="button" value="..." />
                        </td>
                        <td class="tdEditstyle">入庫廠商簡稱</td>
                        <td class="tdbstyle">
                            <input id="E_FACT_S_NAME_I" class="textbox_char" disabled="disabled" />
                        </td>
                    </tr>
                     <tr class="trstyle" >
                        <td class="tdEditstyle">備註</td>
                        <td class="tdbstyle" colspan="3">
                            <input id="E_REMARK" class="textbox_char" style="width:80%" />
                        </td>
                    </tr>
                </table>
                <div style="height: 10vh; font-size: smaller;" >&nbsp</div>
                <div style="text-align:center">
                     <input id="BT_EXECUTE" style="font-size:20px" type="button" value="執行"  />
                     <input id="BT_EXECUTE_CANCEL" style="font-size:20px" type="button" value="返回" />
                </div>
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
