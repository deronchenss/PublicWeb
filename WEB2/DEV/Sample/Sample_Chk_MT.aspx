<%@ Page Title="樣品點收維護" Language="C#" MasterPageFile="~/MP.master" AutoEventWireup="true" CodeFile="Sample_Chk_MT.aspx.cs" Inherits="Sample_Chk_MT" %>
<%@ Register TagPrefix="uc" TagName="uc1" Src="~/User_Control/Dia_Transfer_Selector.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="/css/dataTables.bootstrap4.min.css" rel="stylesheet" />
    <script src="/js/jquery.dataTables.min.js"></script>
    <script src="/js/dataTables.bootstrap4.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            var Edit_Mode;
            var apiUrl = "/DEV/Sample/Ashx/Sample_Chk_MT.ashx";
            //隱藏滾動卷軸
            document.body.style.overflow = 'hidden';

            //init CONTROLER
            Form_Mode_Change("Base");

            //$('#Q_QUAH_DATE_S').val($.datepicker.formatDate('yy-mm-dd', new Date()));
            //$('#Q_QUAH_DATE_E').val($.datepicker.formatDate('yy-mm-dd', new Date()));          

            //Dialog
            $('#BT_TRANS_WAY').on('click', function () {
                $("#Search_Transfer_Dialog").dialog('open');
            });

            $('#SSD_Table_Transfer').on('click', '.SUP_SEL', function () {
                $('#E_TRANS_NO').val($(this).parent().parent().find('td:nth(1)').text());
                $('#E_TRANS_S_NAME').val($(this).parent().parent().find('td:nth(2)').text());
                $("#Search_Transfer_Dialog").dialog('close');
            });

            window.document.body.onbeforeunload = function () {
                if (Edit_Mode === "Insert" || Edit_Mode === "Edit") {
                    return '您尚未將編輯過的表單資料送出，請問您確定要離開網頁嗎？';
                }
            }

            //上下移功能 根據每個頁面客製
            $(document).keydown(function (event) {
                var key = (event.keyCode ? event.keyCode : event.which);
                var clickIndex = $('#Table_Search_Recua > tbody > tr.tableClick').index();
                if (key == '40') {
                    if (clickIndex < $('#Table_Search_Recua tbody tr').length - 1) {
                        clickIndex++;
                        ClickToEdit($('#Table_Search_Recua > tbody > tr:nth(' + clickIndex + ')'));
                    }
                }
                else if (key == '38') {
                    clickIndex--;
                    ClickToEdit($('#Table_Search_Recua > tbody > tr:nth(' + clickIndex + ')'));
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

                        if (Edit_Mode == "Edit") {
                            $('.modeButton').css('display', 'none')
                            $('#Div_EDIT_Data').css('display', '');
                            $('#Div_DT_View').css('width', '60%');
                            $('#Table_Search_Recua').DataTable().draw();

                            $('#BT_DELETE').css('display', 'inline-block');
                            $('#BT_EDIT_SAVE').css('display', 'inline-block');
                            $('#BT_E_CANCEL').css('display', 'inline-block');

                        }
                       
                        V_BT_CHG($('#BT_S_BASE'));
                        break;
                    case "IMG":
                        $('.Div_D').css('display', 'none');
                        $('#Div_DT_View').css('width', '60%');
                        $('#Div_IMG_DETAIL').css('display', '');

                        V_BT_CHG($('#BT_S_IMG'));
                        break;       
                }
            }

            function ClickToEdit(click_tr) {
                $('#BT_Update').css('display', '');

                //點擊賦予顏色
                $('#Table_Search_Recua > tbody tr').removeClass("tableClick");
                click_tr.addClass("tableClick");

                var clickData = $('#Table_Search_Recua').DataTable().row(click_tr).data();

                //Edit page
                $('#E_CHK_BATCH_NO').val(clickData['點收批號']);
                $('#E_SEQ').val(clickData['序號']);
                $('#E_SUPLU_SEQ').val(clickData['SUPLU_SEQ']);
                $('#E_IVAN_TYPE').val(clickData['頤坊型號']);
                $('#E_FACT_NO').val(clickData['廠商編號']);
                $('#E_FACT_S_NAME').val(clickData['廠商簡稱']);
                $('#E_TMP_TYPE').val(clickData['暫時型號']);
                $('#E_FACT_TYPE').val(clickData['廠商型號']);
                $('#E_PROD_DESC').val(clickData['產品說明']);
                $('#E_UNIT').val(clickData['單位']);
                $('#E_PUDU_NO').val(clickData['採購單號']);
                $('#E_SAMPLE_NO').val(clickData['樣品號碼']);
                $('#E_CHECK_DATE').val(clickData['點收日期']);
                $('#E_CHECK_CNT').val(clickData['點收數量']);
                $('#E_APPROVE_CNT').val(clickData['核銷數量']);
                $('#E_TRANS_NO').val(clickData['運輸編號']);
                $('#E_TRANS_S_NAME').val(clickData['運輸簡稱']);
                $('#E_UPD_USER').val(clickData['更新人員']);
                $('#E_UPD_DATE').val(clickData['更新日期']);

                //IMG page
                $('#I_IVAN_TYPE').val(clickData['頤坊型號']);
                $('#I_FACT_NO').val(clickData['廠商編號']);
                $('#I_FACT_S_NAME').val(clickData['廠商簡稱']);
                $('#I_PROD_DESC').val(clickData['產品說明']);
                $('#I_RPT_REMARK').val(clickData['大備註']);
                Search_IMG(clickData['SUPLU_SEQ']);
            }
            
            function V_BT_CHG(buttonChs) {
                $('.V_BT').attr('disabled', false);
                buttonChs.attr('disabled', 'disabled');
            }

            //ajax function
            function Search_Recua() {
                $.ajax({
                    url: apiUrl,
                    data: {
                        "Call_Type": "Search_Recua", 
                        "點收批號": $('#Q_CHK_BATCH_NO').val(),
                        "樣品號碼": $('#Q_SAMPLE_NO').val(),
                        "頤坊型號": $('#Q_IVAN_TYPE').val(),
                        "點收日期_S": $('#Q_CHK_DATE_S').val(),
                        "點收日期_E": $('#Q_CHK_DATE_E').val(),
                        "採購單號": $('#Q_PUDU_NO').val(),
                        "廠商編號": $('#Q_FACT_NO').val(),
                        "廠商簡稱": $('#Q_FACT_S_NAME').val()
                    },
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
                            $('#Table_Search_Recua').DataTable({
                                "data": response,
                                "destroy": true,
                                //維持scroll bar 位置
                                "preDrawCallback": function (settings) {
                                    pageScrollPos = $('div.dataTables_scrollBody').scrollTop();
                                },
                                "drawCallback": function (settings) {
                                    $('div.dataTables_scrollBody').scrollTop(pageScrollPos);
                                },
                                "columns": [
                                    { data: "序號", title: "序號" },
                                    { data: "點收批號", title: "點收批號" },
                                    { data: "採購單號", title: "採購單號" },
                                    { data: "點收日期", title: "點收日期" },
                                    { data: "廠商簡稱", title: "廠商簡稱" },
                                    { data: "頤坊型號", title: "頤坊型號" },
                                    { data: "單位", title: "單位" },
                                    { data: "點收數量", title: "點收數量" },
                                    { data: "樣品號碼", title: "樣品號碼" },
                                    { data: "更新人員", title: "<%=Resources.MP.Update_User%>" },
                                    { data: "更新日期", title: "<%=Resources.MP.Update_Date%>" },
                                    { data: "核銷數量", title: "核銷數量", visible: false },
                                    { data: "運輸編號", title: "運輸編號", visible: false },
                                    { data: "運輸簡稱", title: "運輸簡稱", visible: false },
                                    { data: "SUPLU_SEQ", title: "SUPLU_SEQ", visible: false }
                                ],
                                "order": [[2, "asc"]], //根據 採購單號 排序
                                "scrollX": true,
                                "scrollY": "62vh",
                                "searching": false,
                                "paging": false,
                                "bInfo": false, //顯示幾筆隱藏
                                "autoWidth": false //欄位小於VIEW 長度，自動擴展
                            });

                            $('#Table_Search_Recua').DataTable().draw();
                            $('#Table_Search_Recu_info').text('Showing ' + $('#Table_Search_Recua > tbody tr[role=row]').length + ' entries');
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

            //更新DB
            function UPD_RECUA() {
                if ($('#E_SEQ').val() === '') {
                    alert('請選擇要修改的資料');
                }
                else{
                    $.ajax({
                        url: apiUrl,
                        data: {
                            "Call_Type": "UPD_RECUA",
                            "SEQ": $('#E_SEQ').val(),
                            "點收批號": $('#E_CHK_BATCH_NO').val(),
                            "點收日期": $('#E_CHK_DATE').val(),
                            "運輸編號": $('#E_TRANS_NO').val(),
                            "運輸簡稱": $('#E_TRANS_S_NAME').val()
                        },
                        cache: false,
                        type: "POST",
                        datatype: "json",
                        contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                        success: function (response, status) {
                            console.log(status);
                            if (status === 'success') {
                                alert('序號:' + $('#E_SEQ').val() + '已修改完成');

                                Search_Recua();
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
            function DELETE_RECUA() {
                if ($('#E_SEQ').val() === '') {
                    alert('請選擇要刪除的資料');
                }
                else {
                    $.ajax({
                        url: apiUrl,
                        data: {
                            "Call_Type": "DELETE_RECUA",
                            "SEQ": $('#E_SEQ').val()
                        },
                        cache: false,
                        type: "POST",
                        datatype: "json",
                        contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                        success: function (response, status) {
                            console.log(status);
                            if (status === 'success') {
                                alert('序號:' + $('#E_SEQ').val() + '已刪除完成');
                                Search_Recua();
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

            //TABLE 功能設定
            $('#Table_Search_Recua').on('click', 'tbody tr', function () {
                ClickToEdit($(this));
            });

            //BUTTON CLICK EVENT BASE 頁
            $('#BT_Search').on('click', function () {
                Form_Mode_Change("Search");
                Search_Recua();
            });

            $('#BT_Cancel').on('click', function () {
                Edit_Mode = "Base";

                var Confirm_Check = confirm("<%=Resources.MP.Cancel_Alert%>");
                if (Confirm_Check) {
                    $('#Table_Search_Recua').DataTable().clear().draw();
                    Form_Mode_Change("Base");
                }
            });

            $('#BT_EDIT_SAVE').on('click', function () {
                UPD_RECUA();
            });

            $('#BT_DELETE').on('click', function () {
                var Confirm_Check = confirm("確認刪除嗎? 序號:" + $('#E_SEQ').val());
                if (Confirm_Check) {
                    DELETE_RECUA();
                }
            });

            $('#BT_Update').on('click', function () {
                Edit_Mode = "Edit";
                Form_Mode_Change("Search");
            });

            $('#BT_E_CANCEL').on('click', function () {
                Edit_Mode = "Search";
                Form_Mode_Change("Search");
                $('#Table_Search_Recua').DataTable().draw();
            });

            //功能選單
            $('#BT_S_BASE').on('click', function () {
                if($('#Table_Search_Recua > tbody tr[role=row]').length > 0)
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
    <uc:uc1 ID="uc1" runat="server" /> 
    <div style="width:98%;margin:0 auto; ">
        <div class="search_section_all">
            <table class="search_section_control">
            <tr class="trstyle"> 
                <td style="height: 10px; font-size: smaller;" colspan="8">&nbsp
                </td>
            </tr>
            <tr class="trstyle">
                <td class="tdhstyle">點收批號</td>
                <td class="tdbstyle">
                    <input id="Q_CHK_BATCH_NO" class="textbox_char" />
                </td>
                <td class="tdhstyle">採購單號</td>
                <td class="tdbstyle">
                    <input id="Q_PUDU_NO"  class="textbox_char" />
                </td>
                <td class="tdhstyle">點收日期</td>
                <td class="tdbstyle">
                    <input id="Q_CHK_DATE_S" type="date" class="date_S_style" />~<input id="Q_CHK_DATE_E" type="date" class="date_E_style" />
                </td>
            </tr>
            <tr class="trstyle">
                <td class="tdhstyle">頤坊型號</td>
                <td class="tdbstyle">
                    <input id="Q_IVAN_TYPE"  class="textbox_char" />
                </td>
                <td class="tdhstyle">樣品號碼</td>
                <td class="tdbstyle">
                    <input id="Q_SAMPLE_NO"  class="textbox_char" />
                </td>
            </tr>
             <tr class="trstyle">
                <td class="tdhstyle">廠商編號</td>
                <td class="tdbstyle">
                    <input id="Q_FACT_NO"  class="textbox_char" />
                </td>
                <td class="tdhstyle">廠商簡稱</td>
                <td class="tdbstyle">
                    <input id="Q_FACT_S_NAME" class="textbox_char" />
                </td>
            </tr>
            <tr>
                <td style="height: 5px; font-size: smaller;" colspan="8">&nbsp</td>
            </tr>
            <tr class="trstyle">
                <td class="tdtstyleRight" colspan="8">
                    <input type="button" id="BT_Search" class="buttonStyle" value="<%=Resources.MP.Search%>" />
                    <input type="button" id="BT_Update" class="buttonStyle" value="修改" />
                    <input type="button" id="BT_Cancel" class="buttonStyle" value="<%=Resources.MP.Cancel%>" style="display: none;" />
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
                <div class="dataTables_info" id="Table_Search_Recu_info" role="status" aria-live="polite"></div>
                <table id="Table_Search_Recua" class="Table_Search table table-striped table-bordered">
                    <thead style="white-space:nowrap"></thead>
                    <tbody style="white-space:nowrap"></tbody>
                </table>
            </div>
    
            <div id="Div_EDIT_Data" class=" Div_D" style="width:35%; height:71vh;white-space:nowrap; border-style:solid; border-width:1px;  float:right; overflow:auto">
                <table class="edit_section_control">
                    <tr> 
                        <td style="height: 10vh; font-size: smaller;" >&nbsp</td>
                    </tr>
                    <tr class="trstyle" >
                        <td class="tdhstyle">點收批號</td>
                        <td class="tdbstyle">
                            <input id="E_CHK_BATCH_NO"  class="textbox_char" />
                        </td>
                        <td class="tdhstyle">序號</td>
                        <td class="tdbstyle">
                            <input id="E_SEQ"  class="textbox_char" disabled="disabled" />
                            <input id="E_SUPLU_SEQ" type="hidden" class="textbox_char" />
                        </td>
                    </tr>
                    <tr class="trstyle">
                        <td class="tdhstyle">頤坊型號</td>
                        <td class="tdbstyle">
                            <input id="E_IVAN_TYPE"  class="textbox_char" disabled="disabled" />
                        </td>
                    </tr>
                    <tr class="trstyle">
                        <td class="tdhstyle">廠商編號</td>
                        <td class="tdbstyle">
                            <input id="E_FACT_NO"  class="textbox_char" disabled="disabled" />
                        </td>
                        <td class="tdhstyle">廠商簡稱</td>
                        <td class="tdbstyle">
                            <input id="E_FACT_S_NAME" class="textbox_char" disabled="disabled"  />
                        </td>
                    </tr>
                    <tr class="trstyle">
                        <td class="tdhstyle">暫時型號</td>
                        <td class="tdbstyle">
                            <input id="E_TMP_TYPE"  class="textbox_char" disabled="disabled" />
                        </td>
                        <td class="tdhstyle">廠商型號</td>
                        <td class="tdbstyle">
                            <input id="E_FACT_TYPE" class="textbox_char" disabled="disabled"  />
                        </td>
                    </tr>
                    <tr class="trstyle">
                        <td class="tdhstyle">產品說明</td>
                        <td class="tdbstyle" colspan ="4">
                            <input id="E_PROD_DESC" class="textbox_char " style="width:80%" disabled="disabled"  />
                        </td>
                    </tr>     
                    <tr class="trstyle ">
                        <td class="tdhstyle">採購單號</td>
                        <td class="tdbstyle">
                            <input id="E_PUDU_NO"  class="textbox_char" disabled="disabled"  />
                        </td>
                        <td class="tdhstyle ">樣品號碼</td>
                        <td class="tdbstyle">
                            <input id="E_SAMPLE_NO"  class="textbox_char" disabled="disabled" />
                        </td>
                    </tr>
                    <tr class="trstyle ">
                        <td class="tdhstyle">點收日期</td>
                        <td class="tdbstyle">
                            <input id="E_CHECK_DATE" type="date" class="date_S_style"  />
                        </td>
                        <td class="tdhstyle">點收數量</td>
                        <td class="tdbstyle">
                            <input id="E_CHECK_CNT" class="textbox_char" type="number" disabled="disabled" />
                        </td>
                    </tr>
                    <tr class="trstyle ">
                        <td class="tdhstyle">單位</td>
                        <td class="tdbstyle">
                            <input id="E_UNIT"  class="textbox_char" disabled="disabled" />
                        </td>
                        <td class="tdhstyle">核銷數量</td>
                        <td class="tdbstyle">
                            <input id="E_APPROVE_CNT" class="textbox_char " type="number" disabled="disabled" />
                        </td>
                    </tr>
                    <tr class="trCenterstyle">
                        <td class="tdhstyle" >運輸編號</td>
                        <td class="tdbstyle">
                            <input id="E_TRANS_NO"  class="textbox_char" disabled="disabled"  />
                            <input id="BT_TRANS_WAY"  type="button" value="..." />
                        </td>
                        <td class="tdhstyle">運輸簡稱</td>
                        <td class="tdbstyle" >
                            <input id="E_TRANS_S_NAME"  class="textbox_char" disabled="disabled"  />
                        </td>
                    </tr>
                    <tr class="trstyle ">
                        <td class="tdhstyle">更新人員</td>
                        <td class="tdbstyle">
                            <input id="E_UPD_USER"  class="textbox_char " disabled="disabled" />
                        </td>
                        <td class="tdhstyle">更新日期</td>
                        <td class="tdbstyle">
                            <input id="E_UPD_DATE" type="date" class="date_S_style " disabled="disabled" />
                        </td>
                    </tr>
                    <tr> 
                        <td style="height: 5vh; font-size: smaller;" >&nbsp</td>
                    </tr>
                     <tr class="trCenterstyle"> 
                         <td colspan="4" style="text-align:center" >
                            <input type="button" id="BT_DELETE" style="display:inline-block" class="BTN modeButton" value="刪除"  />
                            <input type="button" id="BT_EDIT_SAVE" style="display:inline-block" class="BTN modeButton" value="修改儲存"  />
                            <input type="button" id="BT_E_CANCEL" style="display:inline-block" class="BTN modeButton" value="返回"  />
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
                            <input id="I_IVAN_TYPE" class="textbox_char" disabled="disabled"   />
                        </td>
                        <td class="tdEditstyle">廠商編號</td>
                        <td class="tdbstyle">
                            <input id="I_FACT_NO"  class="textbox_char" disabled="disabled"   />
                        </td>
                    </tr>
                    <tr class="trstyle">
                        <td class="tdEditstyle"></td>
                        <td class="tdbstyle"></td>
                        <td class="tdEditstyle">廠商簡稱</td>
                        <td class="tdbstyle" >
                            <input id="I_FACT_S_NAME" class="textbox_char" disabled="disabled"   />
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
