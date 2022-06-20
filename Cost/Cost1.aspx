<%@ Page Title="Product Maintenance" Language="C#" MasterPageFile="~/MP.master" AutoEventWireup="true" CodeFile="Cost1.aspx.cs" Inherits="Cost_Cost1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <link href="/css/dataTables.bootstrap4.min.css" rel="stylesheet" />
    <script src="/js/jquery.dataTables.min.js"></script>
    <script src="/js/dataTables.bootstrap4.min.js"></script>

    <script type="text/javascript">
        $(document).ready(function () {
            var From_Mode;
            ATC();
            DDL_Bind();
            Dialog();

            function Form_Mode_Change(Form_Mode) {
                switch (Form_Mode) {
                    case "Base":
                        $('#Div_Detail_Form table input, textarea').not('[type=button], #TB_Dia_Where, [type=number]').val('');
                        $('#Div_Detail_Form table input[type=number]').val(0);
                        $('#Div_Detail_Form input, #Div_Detail_Form textarea, #Div_Detail_Form select').css('background-color', '');
                        $('#Div_Detail_Form input, #Div_Detail_Form textarea, #Div_Detail_Form select').attr('disabled', 'disabled');
                        $('#BT_New, #BT_Search, #BT_Detail_Search').css('display', '');
                        $('#BT_New_Save, #BT_Cancel').css('display', 'none');
                        $('.ED_BT').css('display', 'none');
                        $('#Div_DT_View').css('display', 'none');
                        $('.V_BT').not($('#V_BT_Master')).css('display', 'none');
                        $('.V_BT').not($('#V_BT_Master')).attr('disabled', false);
                        $('#V_BT_Master').attr('disabled', 'disabled');
                        $('.Div_D').css('display', 'none');
                        $('#Div_M2').css('display', '');

                        $('#Div_Detail_Form table input[type=number]').val(0);

                        $('#BT_New, #BT_Search, #BT_Detail_Search').css('display', '');
                        $('.M2_For_U').css('display', 'none');
                        break;
                    case "New_M":
                        //$('.M_BT').not($('#BT_Cancel')).css('display', 'none');
                        //$('.M2_For_U').css('display', 'none');
                        //$('.ED_BT').css('display', 'none');
                        //$('#Div_Detail_Form input, #Div_Detail_Form textarea, #Div_Detail_Form select').attr('disabled', false);

                        $('input[required], select[required]').css('background-color', 'yellow');
                        $('.M2_For_U').css('display', 'none');
                        $('#BT_New, #BT_Search, #BT_Detail_Search').css('display', 'none');
                        $('#BT_Cancel, #BT_New_Save').css('display', '');
                        $('#Div_Detail_Form input, #Div_Detail_Form textarea, #Div_Detail_Form select').not('.S_Name').attr('disabled', false);

                        //By Copy Save
                                            //$('#BT_ED_Edit, #BT_Cancel, #Div_DT_View').css('display', '');
                                            //$('#BT_ED_Save, #BT_ED_Cancel').css('display', 'none');
                        break;
                    case "Search_M":
                        $('#BT_Cancel').css('display', '');
                        $('.M_BT').not($('#BT_Cancel')).css('display', 'none');
                        $('#Div_DT_View').css('display', '');
                        $('.V_BT').not($('#V_BT_Master')).css('display', '');

                        $('#Div_Detail_Form input, #Div_Detail_Form textarea, #Div_Detail_Form select').attr('disabled', 'disabled');
                        $('#BT_ED_Edit, #BT_Cancel, #Div_DT_View').css('display', '');
                        $('#BT_ED_Save, #BT_ED_Cancel').css('display', 'none');

                        $('#BT_Cancel').css('display', '');
                        $('.M_BT').not($('#BT_Cancel')).css('display', 'none');
                        $('#Div_DT_View').css('display', '');
                        $('.V_BT').not($('#V_BT_Master')).css('display', '');




                        $('#BT_Cancel').css('display', '');
                        $('.M_BT').not($('#BT_Cancel')).css('display', 'none');
                        $('#Div_DT_View').css('display', '');
                        $('.V_BT').not($('#V_BT_Master')).css('display', '');
                        break;
                    case "Search_D":
                        $('#Div_Detail_Form input, #Div_Detail_Form textarea, #Div_Detail_Form select').attr('disabled', 'disabled');
                        $('#BT_ED_Edit, #BT_Cancel, #Div_DT_View').css('display', '');
                        $('#BT_ED_Save, #BT_ED_Cancel').css('display', 'none');

                        $('.M2_For_U').css('display', '');
                        $('#Div_Detail_Form input, #Div_Detail_Form textarea, #Div_Detail_Form select').attr('disabled', 'disabled');
                        $('#BT_ED_Edit').css('display', '');
                        $('#BT_ED_Save, #BT_ED_Cancel').css('display', 'none');
                        break;
                    case "Edit_M":
                        $('#BT_ED_Edit, #BT_Cancel, #Div_DT_View').css('display', 'none');
                        $('#BT_ED_Save, #BT_ED_Cancel').css('display', '');
                        $('#Div_Detail_Form input, #Div_Detail_Form textarea, #Div_Detail_Form select').not('#TB_M2_Update_User, #TB_M2_Update_Date, #TB_M2_SEQ').attr('disabled', false);
                        break;
                }
            }

            $('#BT_New').on('click', function () {
                From_Mode = "New";
                Form_Mode_Change("New_M");
            });

            $('#BT_New_Save').on('click', function () {
                if (confirm("<%=Resources.MP.Save_Alert%>")) {
                    if (Save_Check()) {
                        $.ajax({
                            url: "/Cost/Cost_Save.ashx",
                            data: {
                                "IM": $('#TB_M2_IM').val(),
                                "SM": $('#TB_M2_SM').val(),
                                "S_No": $('#TB_M2_S_No').val(),
                                "S_SName": $('#TB_M2_S_SName').val(),
                                "Sample_PN": $('#TB_M2_Sample_P_No').val(),
                                "Unit": $('#TB_M2_Unit').val(),
                                "PI": $('#TB_M2_P_IM').val(),
                                "P_TWD": parseInt($('#TB_M2_TWD_1').val()),
                                "P_USD": parseInt($('#TB_M2_USD').val()),
                                "P_TWD_2": parseInt($('#TB_M2_TWD_2').val()),
                                "P_TWD_3": parseInt($('#TB_M2_TWD_2').val()),
                                "MIN_1": parseInt($('#TB_M2_MIN_1').val()),
                                "MIN_2": parseInt($('#TB_M2_MIN_2').val()),
                                "MIN_3": parseInt($('#TB_M2_MIN_3').val()),
                                "Curr": $('#TB_M2_Currency').val(),
                                "P_Curr": parseInt($('#TB_M2_PC_1').val()),
                                "P_Curr_2": parseInt($('#TB_M2_PC_2').val()),
                                "P_Curr_3": parseInt($('#TB_M2_PC_3').val()),
                                "DS_P": $('#DDL_M2_DP').val(),
                                "DS_IM": $('#TB_M2_DI').val(),
                                "RP": $('#TB_M2_RP').val(),
                                "RD": $('#TB_M2_RD').val(),
                                "Call_Type": "Cost_New"
                            },
                            cache: false,
                            type: "POST",
                            datatype: "json",
                            contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                            success: function (response) {
                                console.warn(response);
                                if (String(response).indexOf("UNIQUE KEY") > 0) {
                                    alert(response);
                                }
                                else {
                                    alert("<%=Resources.MP.Add_Success%>");
                                    Form_Mode_Change("Base");
                                }
                            },
                            error: function (ex) {
                                alert(ex);
                                return false;
                            }
                        });
                    }
                }
            });

            $('#BT_Search').on('click', function () {
                Search_Cost();
                From_Mode = "Search";
                Form_Mode_Change("Search_M");
            });

            $('#BT_Detail_Search').on('click', function () {
                $("#dialog").dialog('open');
            });

            $('#BT_ED_Copy').on('click', function () {
                $('#TB_CD_IM, #TB_CD_S_No').css('background-color', '');
                $("#Copy_Dialog").dialog('open');
            });

            $('#BT_Cancel').on('click', function () {
                var Confirm_Check = true;
                if (From_Mode == "New") {
                    Confirm_Check = confirm("<%=Resources.MP.Cancel_Alert%>");
                }
                if (Confirm_Check) {
                    From_Mode = "Cancel";
                    Form_Mode_Change("Base");
                }
            });

            $('#BT_ED_Edit').on('click', function () {
                //Edit_M
                $('#BT_ED_Edit, #BT_ED_Copy, #BT_Cancel, #Div_DT_View').css('display', 'none');
                $('#BT_ED_Save, #BT_ED_Cancel').css('display', '');
                $('#Div_Detail_Form input, #Div_Detail_Form textarea, #Div_Detail_Form select').not('#TB_M2_Update_User, #TB_M2_Update_Date, #TB_M2_SEQ, .S_Name').attr('disabled', false);
            });

            $('#BT_ED_Save').on('click', function () {
                if (confirm("<%=Resources.MP.Edit_Alert%>")) {
                    if (Save_Check()) {
                        $.ajax({
                            url: "/Cost/Cost_Save.ashx",
                            data: {
                                "SEQ": $('#TB_M2_SEQ').val(),
                                "IM": $('#TB_M2_IM').val(),
                                "SM": $('#TB_M2_SM').val(),
                                "S_No": $('#TB_M2_S_No').val(),
                                "S_SName": $('#TB_M2_S_SName').val(),
                                "Sample_PN": $('#TB_M2_Sample_P_No').val(),
                                "Unit": $('#TB_M2_Unit').val(),
                                "PI": $('#TB_M2_P_IM').val(),
                                "PID": $('#TB_M2_P_ID').val(),
                                "P_TWD": parseInt($('#TB_M2_TWD_1').val()),
                                "P_USD": parseInt($('#TB_M2_USD').val()),
                                "P_TWD_2": parseInt($('#TB_M2_TWD_2').val()),
                                "P_TWD_3": parseInt($('#TB_M2_TWD_2').val()),
                                "MIN_1": parseInt($('#TB_M2_MIN_1').val()),
                                "MIN_2": parseInt($('#TB_M2_MIN_2').val()),
                                "MIN_3": parseInt($('#TB_M2_MIN_3').val()),
                                "Curr": $('#TB_M2_Currency').val(),
                                "P_Curr": parseInt($('#TB_M2_PC_1').val()),
                                "P_Curr_2": parseInt($('#TB_M2_PC_2').val()),
                                "P_Curr_3": parseInt($('#TB_M2_PC_3').val()),
                                "DS_P": $('#DDL_M2_DP').val(),
                                "DS_IM": $('#TB_M2_DI').val(),
                                "DPN": $('#TB_M2_DPN').val(),
                                "PS": $('#DDL_M2_PS').val(),
                                "RP": $('#TB_M2_RP').val(),
                                "RD": $('#TB_M2_RD').val(),

                                "MS": $('#TB_MR_MS').val(),
                                "WH": parseInt($('#TB_P_WH').val()),
                                "IBC": parseInt($('#TB_P_IBC').val()),
                                "OBNo": parseInt($('#TB_P_OBNo').val()),
                                "NW": parseInt($('#TB_P_NW').val()),
                                "OBL": parseInt($('#TB_P_OBL').val()),
                                "GW": parseInt($('#TB_P_GW').val()),
                                "IA": parseInt($('#TB_P_IA').val()),
                                "OBW": parseInt($('#TB_P_OBW').val()),
                                "OBH": parseInt($('#TB_P_OBH').val()),
                                "IA2": parseInt($('#TB_P_IA2').val()),
                                "P_NW": parseInt($('#TB_P_P_NW').val()),
                                "P_GW": parseInt($('#TB_P_P_GW').val()),
                                "PL": parseInt($('#TB_P_PL').val()),
                                "PW": parseInt($('#TB_P_PW').val()),
                                "PH": parseInt($('#TB_P_PH').val()),
                                "PGL": parseInt($('#TB_P_PGL').val()),
                                "PGW": parseInt($('#TB_P_PGW').val()),
                                "PGH": parseInt($('#TB_P_PGH').val()),
                                "Call_Type": "Cost_Update"
                            },
                            cache: false,
                            type: "POST",
                            datatype: "json",
                            contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                            success: function (response) {
                                console.warn(response);
                                if (String(response).indexOf("UNIQUE KEY") > 0) {
                                    alert(response);
                                }
                                else {
                                    alert("<%=Resources.MP.Update_Success%>");
                                    //Search_M?
                                    $('#Div_Detail_Form input, #Div_Detail_Form textarea, #Div_Detail_Form select').attr('disabled', 'disabled');
                                    $('#BT_ED_Edit, #BT_Cancel, #Div_DT_View').css('display', '');
                                    $('#BT_ED_Save, #BT_ED_Cancel').css('display', 'none');
                                    Search_Cost();
                                }
                            },
                            error: function (ex) {
                                if (ex != null) {
                                    alert(ex);
                                }
                            }
                        });
                    }
                }
            });

            $('#BT_ED_Cancel').on('click', function () {
                //Search_D
                $('#Div_Detail_Form input, #Div_Detail_Form textarea, #Div_Detail_Form select').attr('disabled', 'disabled');
                $('#BT_ED_Edit, #BT_ED_Copy, #BT_Cancel, #Div_DT_View').css('display', '');
                $('#BT_ED_Save, #BT_ED_Cancel').css('display', 'none');
            });

            function Save_Check() {
                var Check_Item = true;
                var Alert_Message = "";
                //if ($('#TB_M2_S_No').val().length < 4 || $('#TB_M2_S_No').val().length > 8) {
                //    Alert_Message += "請輸入4~8碼廠商編號";
                //    $('#TB_M2_S_No').css('background-color', 'red');
                //    Check_Item = false;
                //}
                //if ($('#TB_M2_S_SName').val().length === 0) {
                //    Alert_Message += "\r\n請輸入廠商簡稱";
                //    $('#TB_M2_S_SName').css('background-color', 'red');
                //    Check_Item = false;
                //}
                //if ($('#TB_M2_S_Nation').val().length === 0) {
                //    Alert_Message += "\r\n請輸入國名";
                //    $('#TB_M2_S_Nation').css('background-color', 'red');
                //    Check_Item = false;
                //}
                //if (!Check_Item) {
                //    alert(Alert_Message);
                //}
                return Check_Item;
            };
            function Copy_Check() {
                var Check_Item = true;
                var Alert_Message = "";
                if ($('#TB_CD_IM').val().length === 0) {
                    Alert_Message += "請輸入頤坊型號";
                    $('#TB_CD_IM').css('background-color', 'red');
                    Check_Item = false;
                }
                else {
                    $('#TB_CD_IM').css('background-color', '');
                }

                if ($('#TB_CD_S_No').val().length === 0) {
                    Alert_Message += "\r\n請輸入廠商編號";
                    $('#TB_CD_S_No').css('background-color', 'red');
                    Check_Item = false;
                }
                if (Check_Item){
                    $.ajax({
                        url: "/Cost/Cost_Search.ashx",
                        data: {
                            "S_No": $('#TB_CD_S_No').val(),
                            "Call_Type": "Supplier_No_Check"
                        },
                        cache: false,
                        async: false,
                        type: "POST",
                        datatype: "json",
                        contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                        success: function (response) {
                            if (response.length === 0) {
                                Alert_Message += "\r\n廠商編號不存在";
                                $('#TB_CD_S_No').css('background-color', 'red');
                                Check_Item = false;
                            }
                            else {
                                $.ajax({
                                    url: "/Cost/Cost_Search.ashx",
                                    data: {
                                        "IM": $('#TB_CD_IM').val(),
                                        "S_No": $('#TB_CD_S_No').val(),
                                        "Call_Type": "Copy_ALL_Check"
                                    },
                                    cache: false,
                                    async: false,
                                    type: "POST",
                                    datatype: "json",
                                    contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                                    success: function (response) {
                                        if (response.length > 0) {
                                            Alert_Message += "\r\n已存在相同頤坊型號&廠商編號";
                                            $('#TB_CD_IM').css('background-color', 'red');
                                            $('#TB_CD_S_No').css('background-color', 'red');
                                            Check_Item = false;
                                        }
                                        else {
                                            $('#TB_CD_IM').css('background-color', '');
                                            $('#TB_CD_S_No').css('background-color', '');
                                        }
                                    },
                                    error: function (ex) {
                                        alert(ex);
                                    }
                                });

                            }
                        },
                        error: function (ex) {
                            alert(ex);
                        }
                    });
                }

                if (!Check_Item) {
                    alert(Alert_Message);
                }
                // 1. 型號 or 編號 不為空, 2.編號需存在DB 3. 型號+編號 不可重複DB,
                return Check_Item;
            };

            $('.V_BT').on('click', function () {
                $(this).attr('disabled', 'disabled');
                $('.V_BT').not($(this)).attr('disabled', false);
            });

            $('#TB_M2_IM, #TB_I_IM, #TB_CL_IM, #TB_MR_IM').on('change', function () {
                $('#TB_M2_IM, #TB_I_IM, #TB_CL_IM, #TB_MR_IM').val($(this).val());
            });
            $('#TB_M2_S_No, #TB_I_S_No, #TB_CL_S_No, #TB_MR_S_No').on('change', function () {
                $('#TB_M2_S_No, #TB_I_S_No, #TB_CL_S_No, #TB_MR_S_No').val($(this).val());
            });
            $('#TB_M2_P_IM, #TB_I_P_IM, #TB_CL_P_IM, #TB_MR_P_IM').on('change', function () {
                $('#TB_M2_P_IM, #TB_I_P_IM, #TB_CL_P_IM, #TB_MR_P_IM').val($(this).val());
            });

            $('#Table_Search_Customer').on('click', 'tbody tr', function () {
                Table_Tr_Click($(this));
            });
            function Table_Tr_Click(Click_tr) {
                $(Click_tr).parent().find('tr').css('background-color', '');
                $(Click_tr).parent().find('tr').css('color', 'black');
                $(Click_tr).css('background-color', '#5a1400');
                $(Click_tr).css('color', 'white');

                var SEQ = $(Click_tr).find('td:nth-child(1)').text().toString().trim();

                $('.M2_For_U').css('display', '');
                $('#Div_Detail_Form input, #Div_Detail_Form textarea, #Div_Detail_Form select').attr('disabled', 'disabled');
                $('#BT_ED_Edit, #BT_ED_Copy').css('display', '');
                $('#BT_ED_Save, #BT_ED_Cancel').css('display', 'none');

                $.ajax({
                    url: "/Cost/Cost_Search.ashx",
                    data: {
                        "SEQ": SEQ,
                        "Call_Type": "Cost1_Selected"
                    },
                    cache: false,
                    type: "POST",
                    datatype: "json",
                    contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                    success: function (response) {
                        $('#TB_M2_IM').val(String(response[0].IM ?? ""));
                        $('#TB_M2_SM').val(String(response[0].SM ?? ""));
                        $('#TB_M2_S_No').val(String(response[0].S_No ?? ""));
                        $('#TB_M2_S_SName').val(String(response[0].S_SName ?? ""));
                        $('#TB_M2_Sample_P_No').val(String(response[0].Sample_PN ?? ""));
                        $('#TB_M2_Unit').val(String(response[0].Unit ?? ""));
                        $('#TB_M2_P_IM').val(String(response[0].PI ?? ""));

                        $('#LB_CD_IM').text(String(response[0].IM ?? ""));
                        $('#LB_M2_SM').text(String(response[0].SM ?? ""));
                        $('#LB_CD_S_No').text(String(response[0].S_No ?? ""));
                        $('#LB_CD_S_SName').text(String(response[0].S_SName ?? ""));
                        $('#LB_CD_P_IM').text(String(response[0].PI ?? ""));

                        $('#TB_M2_P_ID').val(String(response[0].PID ?? ""));
                        $('#TB_M2_TWD_1').val(String(response[0].P_TWD ?? ""));
                        $('#TB_M2_USD').val(String(response[0].P_USD ?? ""));
                        $('#TB_M2_TWD_2').val(String(response[0].P_TWD_2 ?? ""));
                        $('#TB_M2_TWD_3').val(String(response[0].P_TWD_3 ?? ""));
                        $('#TB_M2_MIN_1').val(String(response[0].MIN_1 ?? ""));
                        $('#TB_M2_MIN_2').val(String(response[0].MIN_2 ?? ""));
                        $('#TB_M2_MIN_3').val(String(response[0].MIN_3 ?? ""));
                        $('#TB_M2_Currency').val(String(response[0].Curr ?? ""));
                        $('#TB_M2_PC_1').val(String(response[0].P_Curr ?? ""));
                        $('#TB_M2_PC_2').val(String(response[0].P_Curr_2 ?? ""));
                        $('#TB_M2_PC_3').val(String(response[0].P_Curr_3 ?? ""));
                        $('#DDL_M2_DP').val(String(response[0].DS_P ?? ""));
                        $('#TB_M2_DI').val(String(response[0].DS_IM ?? ""));
                        $('#TB_M2_RP').val(String(response[0].RP ?? ""));
                        $('#TB_M2_RD').val(String(response[0].RD ?? ""));
                        $('#TB_M2_DPN').val(String(response[0].DPN ?? ""));
                        $('#DDL_M2_PS').val(String(response[0].PS ?? ""));
                        $('#TB_M2_SD').val(String(response[0].SDate ?? ""));
                        $('#TB_M2_SEQ').val(String(response[0].SEQ ?? ""));
                        $('#TB_M2_Update_User').val(String(response[0].Update_User ?? ""));
                        $('#TB_M2_Update_Date').val(String(response[0].Update_Date ?? ""));

                        $('#TB_I_IM').val(String(response[0].IM ?? ""));
                        $('#TB_I_S_No').val(String(response[0].S_No ?? ""));
                        $('#TB_I_S_SName').val(String(response[0].S_SName ?? ""));
                        $('#TB_I_P_IM').val(String(response[0].PI ?? ""));

                        var IMG_View = (response[0].IMG == null);
                        $('#IMG_I_IMG').css('display', (IMG_View) ? 'none' : '');
                        $('#IMG_I_IMG_Hint').css('display', (IMG_View) ? '' : 'none');
                        var binary = '';
                        var bytes = new Uint8Array(response[0].IMG);
                        var len = bytes.byteLength;
                        for (var i = 0; i < len; i++) {
                            binary += String.fromCharCode(bytes[i]);
                        }
                        $('#IMG_I_IMG').attr('src', 'data:image/png;base64,' + window.btoa(binary));

                        $('#TB_CL_IM').val(String(response[0].IM ?? ""));
                        $('#TB_CL_S_No').val(String(response[0].S_No ?? ""));
                        $('#TB_CL_S_SName').val(String(response[0].S_SName ?? ""));
                        $('#TB_CL_P_IM').val(String(response[0].PI ?? ""));
                        $('#TB_CL_CL').val(String(response[0].CL ?? ""));

                        $('#TB_MR_IM').val(String(response[0].IM ?? ""));
                        $('#TB_MR_S_No').val(String(response[0].S_No ?? ""));
                        $('#TB_MR_S_SName').val(String(response[0].S_SName ?? ""));
                        $('#TB_MR_P_IM').val(String(response[0].PI ?? ""));
                        $('#TB_MR_DPN').prop('checked', Boolean(String(response[0].DPN ?? "") == "Y"));
                        $('#TB_MR_MS').val(String(response[0].MS ?? ""));

                        $('#TB_P_IM').val(String(response[0].IM ?? ""));
                        $('#TB_P_S_No').val(String(response[0].S_No ?? ""));
                        $('#TB_P_S_SName').val(String(response[0].S_SName ?? ""));
                        $('#TB_P_P_IM').val(String(response[0].PI ?? ""));
                        $('#TB_P_WH').val(String(response[0].WH ?? ""));
                        $('#TB_P_Unit').val(String(response[0].Unit ?? ""));
                        $('#TB_P_IBC').val(String(response[0].IBC ?? ""));
                        $('#TB_P_OBNo').val(String(response[0].OBNo ?? ""));
                        $('#TB_P_NW').val(String(response[0].NW ?? ""));
                        $('#TB_P_OBL').val(String(response[0].OBL ?? ""));
                        $('#TB_P_GW').val(String(response[0].GW ?? ""));
                        $('#TB_P_IA').val(String(response[0].IA ?? ""));
                        $('#TB_P_OBW').val(String(response[0].OBW ?? ""));
                        $('#TB_P_OBH').val(String(response[0].OBH ?? ""));
                        $('#TB_P_IA2').val(String(response[0].IA2 ?? ""));
                        $('#TB_P_P_NW').val(String(response[0].P_NW ?? ""));
                        $('#TB_P_P_GW').val(String(response[0].P_GW ?? ""));
                        $('#TB_P_PL').val(String(response[0].PL ?? ""));
                        $('#TB_P_PW').val(String(response[0].PW ?? ""));
                        $('#TB_P_PH').val(String(response[0].PH ?? ""));
                        $('#TB_P_PGL').val(String(response[0].PGL ?? ""));
                        $('#TB_P_PGW').val(String(response[0].PGW ?? ""));
                        $('#TB_P_PGH').val(String(response[0].PGH ?? ""));
                    },
                    error: function (ex) {
                        alert(ex);
                    }
                });
            };

            function Search_Cost(Search_Where) {
                $.ajax({
                    url: "/Cost/Cost_Search.ashx",
                    data: {
                        "Call_Type": "Cost1_Search",
                        "Search_Where": Search_Where ?? ""
                    },
                    cache: false,
                    type: "POST",
                    datatype: "json",
                    contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                    success: function (response) {
                        $('#Table_Search_Customer').DataTable({
                            "data": response,
                            "destroy": true,
                            "order": [[17, "desc"]],
                            "lengthMenu": [
                                [5, 10, 20, -1],
                                [5, 10, 20, "All"],
                            ],
                            "columns": [
                                { data: "SEQ", title: "<%=Resources.Cost.SEQ%>" },
                                { data: "IM", title: "<%=Resources.Cost.Ivan_Model%>" },
                                { data: "SM", title: "<%=Resources.Cost.Supplier_Model%>" },
                                { data: "S_No", title: "<%=Resources.Cost.Supplier_Short_Name%>" },
                                { data: "S_SName", title: "<%=Resources.Cost.Supplier_Short_Name%>" },
                                { data: "Sample_PN", title: "<%=Resources.Cost.Sample_Product_No%>" },
                                { data: "Unit", title: "<%=Resources.Cost.Unit%>" },
                                { data: "TWD_P", title: "<%=Resources.Cost.Price_TWD%>" },
                                { data: "USD_P", title: "<%=Resources.Cost.Price_USD%>" },
                                { data: "Curr", title: "<%=Resources.Cost.Currency%>" },
                                { data: "Curr_P", title: "<%=Resources.Cost.Price_Curr%>" },
                                { data: "MIN_1", title: "MIN_1" },
                                { data: "LSTP_Day", title: "<%=Resources.Cost.Last_Price_Day%>" },
                                { data: "PI", title: "<%=Resources.Cost.Product_Information%>" },
                                { data: "Create_Date", title: "<%=Resources.Cost.Create_Date%>" },
                                { data: "IMG_Enabele", title: "<%=Resources.Cost.IMG_Enable%>" },
                                { data: "S_Update_User", title: "<%=Resources.Cost.Update_User%>" },
                                { data: "S_Update_Date", title: "<%=Resources.Cost.Update_Date%>" }
                            ],
                        });

                        $('#Table_Search_Customer').css('white-space','nowrap');
                        $('#Table_Search_Customer thead th').css('text-align','center');
                    },
                    error: function (ex) {
                        alert(ex);
                    }
                });
            };

            $('#TB_Search_C_No').on('change', function () {
                if ($.trim($(this).val()) == "") {
                    $('#TB_Search_C_SName').val('');
                }
            });

            $('#TB_M2_S_No').on('change', function () {
                if ($.trim($(this).val()) == "") {
                    $('#Search_TB_S_Name').val('');
                }
            });

            function Dialog() {
                $("#dialog").dialog({
                    autoOpen: false,
                    modal: true,
                    title: "<%=Resources.MP.Search_Confition%>",
                    width: 800,//=Div寬度$
                    overlay: 0.5,
                    focus: true,
                    buttons: {
                        "Search": function () {
                            $("#dialog").dialog('close');
                            var Where_Text = "";

                            switch ($('#Dia_BT_Simple_Change').prop('disabled')) {
                                case true://Simple
                                    switch ($('#Dia_TB1_Operator1').val()) {
                                        case "%LIKE%":
                                            Where_Text += " [頤坊型號] LIKE '%" + $('#Dia_TB1_IM').val() + "%'";
                                            break;
                                        case "LIKE%":
                                            Where_Text += " [頤坊型號] LIKE '" + $('#Dia_TB1_IM').val() + "%'";;
                                            break;
                                        case "%LIKE":
                                            Where_Text += " [頤坊型號] LIKE '%" + $('#Dia_TB1_IM').val() + "'";;
                                            break;
                                        default:
                                            Where_Text += " [頤坊型號] " + $('#Dia_TB1_Operator1').val() + " '" + $('#Dia_TB1_IM').val() + "'";
                                            break;
                                    }
                                    switch ($('#Dia_TB1_Operator2').val()) {
                                        case "%LIKE%":
                                            Where_Text += " AND [廠商編號] LIKE '%" + $('#Dia_TB1_S_No').val() + "%'";
                                            break;
                                        case "LIKE%":
                                            Where_Text += " AND [廠商編號] LIKE '" + $('#Dia_TB1_S_No').val() + "%'";;
                                            break;
                                        case "%LIKE":
                                            Where_Text += " AND [廠商編號] LIKE '%" + $('#Dia_TB1_S_No').val() + "'";;
                                            break;
                                        default:
                                            Where_Text += " AND [廠商編號] " + $('#Dia_TB1_Operator2').val() + " '" + $('#Dia_TB1_S_No').val() + "'";
                                            break;
                                    }
                                    console.warn(Where_Text);
                                    Search_Cost(Where_Text);
                                    break;
                                case false://Multiple
                                    Where_Text += $('#TB_Dia_Where').val();
                                    console.warn(Where_Text);
                                    Search_Cost(Where_Text);
                                    break;
                            }

                            From_Mode = "Detail_Search";
                            Form_Mode_Change("Search_M");
                        },
                        "Cancel": function () {
                            $("#dialog").dialog('close');
                        }
                    }
                });

                $("#Copy_Dialog").dialog({
                    autoOpen: false,
                    modal: true,
                    title: "<%=Resources.MP.Copy_Condition%>",
                    width: 800,
                    overlay: 0.5,
                    buttons: {
                        "Copy": function () {
                            if (Copy_Check()) {
                                $("#Copy_Dialog").dialog('close');
                                $.ajax({
                                    url: "/Cost/Cost_Save.ashx",
                                    data: {
                                        "IM": $('#TB_CD_IM').val(),
                                        "SM": $('#TB_M2_SM').val(),
                                        "S_No": $('#TB_CD_S_No').val(),
                                        "S_SName": $('#HDN_CD_S_SName').val(),
                                        "Sample_PN": $('#TB_M2_Sample_P_No').val(),
                                        "Unit": $('#TB_M2_Unit').val(),
                                        "PI": $('#TB_M2_P_IM').val(),
                                        "P_TWD": parseInt($('#TB_M2_TWD_1').val()),
                                        "P_USD": parseInt($('#TB_M2_USD').val()),
                                        "P_TWD_2": parseInt($('#TB_M2_TWD_2').val()),
                                        "P_TWD_3": parseInt($('#TB_M2_TWD_2').val()),
                                        "MIN_1": parseInt($('#TB_M2_MIN_1').val()),
                                        "MIN_2": parseInt($('#TB_M2_MIN_2').val()),
                                        "MIN_3": parseInt($('#TB_M2_MIN_3').val()),
                                        "Curr": $('#TB_M2_Currency').val(),
                                        "P_Curr": parseInt($('#TB_M2_PC_1').val()),
                                        "P_Curr_2": parseInt($('#TB_M2_PC_2').val()),
                                        "P_Curr_3": parseInt($('#TB_M2_PC_3').val()),
                                        "DS_P": $('#DDL_M2_DP').val(),
                                        "DS_IM": $('#TB_M2_DI').val(),
                                        "RP": $('#TB_M2_RP').val(),
                                        "RD": $('#TB_M2_RD').val(),
                                        "Call_Type": "Cost_New"
                                    },
                                    cache: false,
                                    type: "POST",
                                    datatype: "json",
                                    contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                                    success: function (response) {
                                        console.warn(response);
                                        if (String(response).indexOf("UNIQUE KEY") > 0) {
                                            alert(response);
                                        }
                                        else {
                                            alert("<%=Resources.MP.Copy_Success%>");
                                            Search_Cost();
                                            Form_Mode_Change("Search_M");
                                        }
                                    },
                                    error: function (ex) {
                                        alert(ex);
                                        return false;
                                    }
                                });
                            }
                        },
                        "Cancel": function () {
                            $("#Copy_Dialog").dialog('close');
                        }
                    }
                });
            };

            function ATC() {
                $('#Dia_TB1_S_No, #TB_CD_S_No').autocomplete({
                    autoFocus: true,
                    source: function (request, response) {
                        $.ajax({
                            url: "/Web_Service/AutoComplete.asmx/Serach_Supplier_No_Name",
                            cache: false,
                            data: "{'S_No': '" + request.term + "'}",
                            dataType: "json",
                            type: "POST",
                            contentType: "application/json; charset=utf-8",
                            success: function (data) {
                                //$('[style*="z-index: 2147483647"]').css('z-index')
                                $('.ui-autocomplete').css('z-index', $('#Copy_Dialog').parent().css('z-index') + 1);
                                var Json_Response = JSON.parse(data.d);
                                response($.map(Json_Response, function (item) { return { label: item.S_No + " - " + item.S_Name, value: item.S_No, name: item.S_Name } }));
                            },
                            error: function (response) {
                                alert(response.responseText);
                            },
                        });
                    },
                    select: function (event, ui) {
                        $('#TB_CD_S_No').val(ui.item.value);
                        $('#HDN_CD_S_SName').val(ui.item.name)
                    },
                });

                $('#TB_M2_S_No, #TB_I_S_No, #TB_CL_S_No, #TB_MR_S_No, #TB_P_S_No').autocomplete({
                    autoFocus: true,
                    source: function (request, response) {
                        $.ajax({
                            url: "/Web_Service/AutoComplete.asmx/Serach_Supplier_No_Name",
                            cache: false,
                            data: "{'S_No': '" + request.term + "'}",
                            dataType: "json",
                            type: "POST",
                            contentType: "application/json; charset=utf-8",
                            success: function (data) {
                                var Json_Response = JSON.parse(data.d);
                                response($.map(Json_Response, function (item) { return { label: item.S_No + " - " + item.S_Name, value: item.S_No, name: item.S_Name } }));
                                //will add just select ddl item check
                            },
                            error: function (response) {
                                alert(response.responseText);
                            },
                        });
                    },
                    select: function (event, ui) {
                        $('#TB_M2_S_No,     #TB_I_S_No,     #TB_CL_S_No,    #TB_MR_S_No,    #TB_P_S_No').val(ui.item.value);
                        $('#TB_M2_S_SName,  #TB_I_S_SName,  #TB_CL_S_SName, #TB_MR_S_SName, #TB_P_S_SName').val(ui.item.name);
                    },
                });
            };
            function DDL_Bind() {
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
                        $('#DDL_M2_PS').html(DDL_Option);
                    },
                    error: function (response) {
                        alert(response.responseText);
                    },
                });
                $.ajax({
                    url: "/Web_Service/DDL_DataBind.asmx/Design_Person",
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
                        $('#DDL_M2_DP').html(DDL_Option);
                    },
                    error: function (response) {
                        alert(response.responseText);
                    },
                });
            };
        });
    </script>
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

            
        .ED_BT {
            background-color:aqua;
            font-weight: bold;
            border: none;
            cursor: pointer;
            font-size: large;
            text-align: center;
            text-decoration: none;
        }

            .ED_BT:hover {
                background-color: #f8981d;
                color: white;
            }

        #Table_Search_Customer tbody tr:hover {
            background-color: #f8981d;
            color: white;
        }
    </style>

    <div id="dialog" style="display: none;">
        <div style="width: 100%; text-align: center;">
            <input type="button" id="Dia_BT_Simple_Change" value="Simple" style="width: 20%" disabled="disabled" />
            <input type="button" id="Dia_BT_Multiple_Change" value="Multiple" style="width: 20%" />
        </div>
        <br />
        <table border="0" style="margin: 0 auto;" id="Dia_Table_Simple">
            <tr style="text-align: right;">
                <td style="width: 20%;"><%=Resources.Cost.Ivan_Model%></td>
                <td style="width: 30%;">
                    <select style="width: 90%; height: 25px;" id="Dia_TB1_Operator1">
                        <option>=</option>
                        <option selected="selected">%LIKE%</option>
                        <option>LIKE%</option>
                        <option>%LIKE</option>
                    </select>
                </td>
                <td style="width: 50%;">
                    <input style="width: 90%; height: 25px;" id="Dia_TB1_IM" />
                </td>
            </tr>
            <tr style="text-align: right;">
                <td style="width: 20%;"><%=Resources.Cost.Supplier_No%></td>
                <td style="width: 30%;">
                    <select style="width: 90%; height: 25px;" id="Dia_TB1_Operator2">
                        <option>=</option>
                        <option selected="selected">%LIKE%</option>
                        <option>LIKE%</option>
                        <option>%LIKE</option>
                    </select>
                </td>
                <td style="width: 50%;">
                    <input style="width: 90%; height: 25px;" id="Dia_TB1_S_No" placeholder="<%=Resources.MP.S_No_ATC_Hint%>" />
                </td>
            </tr>
        </table>
        <table border="1" style="margin: 0 auto; display: none;" id="Dia_Table_Multiple">
            <tr style="text-align: center;">
                <td style="width: 40%;">
                    <%--Where Column--%>
                    <select style="width: 90%; height: 25px;" id="DDL_Dia_Filter">
                        <option value="[頤坊型號]" selected="selected"><%=Resources.Cost.Ivan_Model%></option>
                        <option value="[廠商編號]"><%=Resources.Cost.Supplier_No%></option>
                        <option value="[廠商型號]"><%=Resources.Cost.Supplier_Model%></option>
                        <option value="[暫時型號]"><%=Resources.Cost.Sample_Product_No%></option>
                        <option value="[廠商簡稱]"><%=Resources.Cost.Supplier_Short_Name%></option>
                        <option value="[最後價日]"><%=Resources.Cost.Last_Price_Day%></option>
                        <option value="[產品說明]"><%=Resources.Cost.Product_Information%></option>
                        <option value="[新增日期]"><%=Resources.Cost.Add_Date%></option>
                        <option value="[序號]"><%=Resources.Cost.SEQ%></option>
                        <option value="[更新人員]"><%=Resources.Cost.Update_User%></option>
                        <option value="[更新日期]"><%=Resources.Cost.Update_Date%></option>
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
                                    Where_Text = "\r\n" + $('input[name=R_Filter_Group]:checked').val() + " " + Where_Text;
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
    
    <div id="Copy_Dialog" style="display:none;">
        <table border="0" style="margin: 0 auto;" id="CD_Table">
            <tr style="background-color:lightgray;">
                <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Old%><%=Resources.Cost.Ivan_Model%></td>
                <td style="text-align: left; width: 15%;">
                    <span id="LB_CD_IM"></span>
                </td>
                <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Old%><%=Resources.Cost.Supplier_Model%></td>
                <td style="text-align: left; width: 15%;">
                    <span id="LB_M2_SM"></span>
                </td>
            </tr>
            <tr style="background-color:lightgray;">
                <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Old%><%=Resources.Cost.Supplier_No%></td>
                <td style="text-align: left; width: 15%;">
                    <span id="LB_CD_S_No"></span>
                </td>
                <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Old%><%=Resources.Cost.Supplier_Short_Name%></td>
                <td style="text-align: left; width: 15%;">
                    <span id="LB_CD_S_SName"></span>
                </td>
            </tr>
            <tr style="background-color:lightgray;">
                <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Old%><%=Resources.Cost.Product_Information%></td>
                <td style="text-align: left; width: 15%;" colspan="3">
                    <span id="LB_CD_P_IM"></span>
                </td>
            </tr>

            <tr>
                <td style="text-align:right;"><%=Resources.Cost.New%><%=Resources.Cost.Ivan_Model%></td>
                <td style="text-align:left;" colspan="3">
                    <input style="width: 90%; height: 25px;" id="TB_CD_IM" />
                </td>
            </tr>
            <tr>
                <td style="text-align:right;"><%=Resources.Cost.New%><%=Resources.Cost.Supplier_No%></td>
                <td style="text-align:left;" colspan="3">
                    <input style="width: 90%; height: 25px;" id="TB_CD_S_No" placeholder="<%=Resources.MP.S_No_ATC_Hint%>" />
                    <input type="hidden" id="HDN_CD_S_SName" />
                </td>
            </tr>
        </table>
    </div>

    <table class="table_th" style="text-align:left;">
        <tr>
            <td style="height: 10px; font-size: smaller;" colspan="8">&nbsp</td>
        </tr>
        <tr>
            <td style="width: 10%;"></td>
            <td style="width:10%;">
                <input type="button" id="BT_New" class="M_BT" value="<%=Resources.MP.Insert%>" />
            </td>
            <td style="width:10%;">
                <input type="button" id="BT_Search" class="M_BT" value="<%=Resources.MP.Search%>" />
            </td>
            <td style="width:10%;">
                <input type="button" id="BT_Detail_Search" class="M_BT" value="<%=Resources.MP.Detail_Search%>" />
            </td>
            <td style="width:10%;">
                <input type="button" id="BT_Cancel" class="M_BT" value="<%=Resources.MP.Cancel%>" style="display:none;" />
            </td>
            <td style="width:80%;">
            </td>
        </tr>
        <tr>
            <td style="height: 10px; font-size: smaller;" colspan="8">&nbsp</td>
        </tr>
    </table>

    <div id="Div_DT_View" style="margin: auto;width:98%;overflow:auto;display:none;">
        <table id="Table_Search_Customer" style="width:100%;" class="table table-striped table-bordered">
            <thead></thead>
            <tbody></tbody>
        </table>
    </div> 
    <div id="Div_Edit_Area" style="width: 99%; margin: 0 auto; background-color: white;">
        &nbsp;
        <input type="button" id="BT_ED_Edit" class="ED_BT" value="<%=Resources.MP.Edit%>" style="display:none;" />
        <input type="button" id="BT_ED_Copy" class="ED_BT" value="<%=Resources.MP.Copy%>" style="display:none;" />
        <input type="button" id="BT_ED_Save" class="ED_BT" value="<%=Resources.MP.Save%>" style="display:none;" />
        <input type="button" id="BT_ED_Cancel" class="ED_BT" value="<%=Resources.MP.Cancel%>" style="display:none;" />
    </div>
    <div style="width: 99%; margin: 0 auto; background-color: white;">
        &nbsp;
        <input id="V_BT_Master" type="button" class="V_BT" value="<%=Resources.Cost.Master%>" onclick="$('.Div_D').css('display','none');$('#Div_M2').css('display','');" disabled="disabled" />
        <input type="button" class="V_BT" style="display:none;" value="<%=Resources.Cost.Image%>" onclick="$('.Div_D').css('display','none');$('#Div_Image').css('display','');" />
        <input type="button" class="V_BT" style="display:none;" value="<%=Resources.Cost.Change_Log%>" onclick="$('.Div_D').css('display','none');$('#Div_Change_Log').css('display','');" />
        <input type="button" class="V_BT" style="display:none;" value="<%=Resources.Cost.More%>" onclick="$('.Div_D').css('display','none');$('#Div_More').css('display','');" />
        <input type="button" class="V_BT" style="display:none;" value="<%=Resources.Cost.Package%>" onclick="$('.Div_D').css('display','none');$('#Div_Package').css('display','');" />
        <input type="button" class="V_BT" style="display:none;" value="<%=Resources.Cost.Report%>" onclick="$('.Div_D').css('display','none');$('#Div_Report').css('display','');" />
    </div>
    <div style="width: 100%;" id="Div_Detail_Form">
        <div id="Div_M2" class="Div_D">
            <table style="font-size: 15px; border-collapse: separate; border-spacing: 0px 8px;">
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;" ><%=Resources.Cost.Ivan_Model%></td>
                    <td style="text-align: left; width: 15%;" colspan="3">
                        <input id="TB_M2_IM" autocomplete="off" required="required" disabled="disabled" style="width: 100%;" />
                    </td>

                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Supplier_Model%></td>
                    <td style="text-align: left; width: 15%;" colspan="3">
                        <input id="TB_M2_SM" autocomplete="off" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Supplier_No%></td>
                    <td style="text-align: left; width: 15%;" colspan="3">
                        <input id="TB_M2_S_No" autocomplete="off" required="required" disabled="disabled" style="width: 100%;" placeholder="<%=Resources.MP.S_No_ATC_Hint%>" />
                    </td>

                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Supplier_Short_Name%></td>
                    <td style="text-align: left; width: 15%;" colspan="3">
                        <input id="TB_M2_S_SName" class="S_Name" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Sample_Product_No%></td>
                    <td style="text-align: left; width: 15%;" colspan="3">
                        <input id="TB_M2_Sample_P_No" autocomplete="off" disabled="disabled" style="width: 100%;" />
                    </td>

                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Unit%></td>
                    <td style="text-align: left; width: 15%;" colspan="3">
                        <input id="TB_M2_Unit" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Product_Information%></td>
                    <td style="text-align: left; width: 15%;" colspan="7">
                        <input id="TB_M2_P_IM" autocomplete="off" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
                <tr class="M2_For_U" style="display:none;">
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Product_Information_Detail%></td>
                    <td style="text-align: left; width: 15%;" colspan="7">
                        <textarea id="TB_M2_P_ID" style="width: 100%; height: 250px;" maxlength="560" disabled="disabled"></textarea>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Price_TWD%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M2_TWD_1" disabled="disabled" type="number" value="0" style="width: 100%;text-align:right;" />
                    </td>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Price_USD%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M2_USD" disabled="disabled" type="number" value="0" style="width: 100%;text-align:right;" />
                    </td>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Price_TWD%>_2</td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M2_TWD_2" disabled="disabled" type="number" value="0" style="width: 100%;text-align:right;" />
                    </td>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Price_TWD%>_3</td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M2_TWD_3" disabled="disabled" type="number" value="0" style="width: 100%;text-align:right;" />
                    </td>
                </tr>
                <tr>
                    <td></td>
                    <td></td>
                    <td style="text-align: right; text-wrap: none; width: 10%;">MIN_1</td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M2_MIN_1" disabled="disabled" type="number" value="0" style="width: 100%;text-align:right;" />
                    </td>
                    <td style="text-align: right; text-wrap: none; width: 10%;">MIN_2</td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M2_MIN_2" disabled="disabled" type="number" value="0" style="width: 100%;text-align:right;" />
                    </td>
                    <td style="text-align: right; text-wrap: none; width: 10%;">MIN_3</td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M2_MIN_3" disabled="disabled" type="number" value="0" style="width: 100%;text-align:right;" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Currency%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M2_Currency" disabled="disabled" style="width: 100%;" />
                    </td>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Price_Curr%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M2_PC_1" disabled="disabled" type="number" value="0" style="width: 100%;text-align:right;" />
                    </td>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Price_Curr%>_2</td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M2_PC_2" disabled="disabled" type="number" value="0" style="width: 100%;text-align:right;" />
                    </td>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Price_Curr%>_3</td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M2_PC_3" disabled="disabled" type="number" value="0" style="width: 100%;text-align:right;" />
                    </td>
                </tr>
                
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Design_Person%></td>
                    <td style="text-align: left; width: 15%;" colspan="3">
                        <select id="DDL_M2_DP" disabled="disabled" style="width: 100%;" >

                        </select>
                    </td>
                    
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Design_Image%></td>
                    <td style="text-align: left; width: 15%;" colspan="3">
                        <input id="TB_M2_DI" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
                
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Remark_Purchase%></td>
                    <td style="text-align: left; width: 15%;" colspan="7">
                        <input id="TB_M2_RP" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
                
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Remark_Develop%></td>
                    <td style="text-align: left; width: 15%;" colspan="7">
                        <input id="TB_M2_RD" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>


                <tr class="M2_For_U" style="display:none;">
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Developing%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M2_DPN" disabled="disabled" style="width: 100%;" />
                    </td>
                    
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Combination%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M2_COM" disabled="disabled" style="width: 100%;" />
                    </td>

                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Product_Status%></td>
                    <td style="text-align: left; width: 15%;">
                        <select id="DDL_M2_PS" disabled="disabled" style="width: 100%;" >
                        </select>
                    </td>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Stop_Date%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M2_SD" type="datetime" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>                
                <tr class="M2_For_U" style="display:none;">
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.SEQ%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M2_SEQ" disabled="disabled" style="width: 100%;" />
                    </td>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Update_User%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M2_Update_User" disabled="disabled" style="width: 100%;" />
                    </td>

                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Update_Date%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_M2_Update_Date" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>

                <tr>
                    <td colspan="8" style="margin: auto;">
                        <div style="display: flex; justify-content: center; align-items: center;">
                            <input id="BT_New_Save" class="BTN" style="display:none;" type="button" value="<%=Resources.MP.Save%>" />
                        </div>
                    </td>
                </tr>
            </table>
        </div>

        <div id="Div_Image" class="Div_D" style="display: none; overflow: auto;">
            <table style="font-size: 15px; border-collapse: separate; border-spacing: 0px 8px;">
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Ivan_Model%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_I_IM" autocomplete="off" disabled="disabled" style="width: 100%;" />
                    </td>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Supplier_No%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_I_S_No" autocomplete="off" disabled="disabled" style="width: 100%;" placeholder="<%=Resources.MP.S_No_ATC_Hint%>" />
                    </td>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Supplier_Short_Name%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_I_S_SName" class="S_Name" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Product_Information%></td>
                    <td style="text-align: left; width: 15%;" colspan="7">
                        <input id="TB_I_P_IM" autocomplete="off" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align:center; width: 15%;" colspan="8">
                        <img id="IMG_I_IMG" src=""  />
                        <span id="IMG_I_IMG_Hint" style="display:none;"><%=Resources.Cost.Image_NotExists%></span>
                    </td>
                </tr>
            </table>
        </div>

        <div id="Div_Change_Log" class="Div_D" style="display: none; overflow: auto;">
            <table style="font-size: 15px; border-collapse: separate; border-spacing: 0px 10px;">
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Ivan_Model%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_CL_IM" autocomplete="off" disabled="disabled" style="width: 100%;" />
                    </td>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Supplier_No%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_CL_S_No" autocomplete="off" disabled="disabled" style="width: 100%;" placeholder="<%=Resources.MP.S_No_ATC_Hint%>" />
                    </td>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Supplier_Short_Name%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_CL_S_SName" class="S_Name" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Product_Information%></td>
                    <td style="text-align: left; width: 15%;" colspan="7">
                        <input id="TB_CL_P_IM" autocomplete="off" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Change_Log%></td>
                    <td style="text-align: left; width: 15%;" colspan="7">
                        <textarea id="TB_CL_CL" style="width: 100%; height: 250px;" maxlength="560" disabled="disabled"></textarea>
                    </td>
                </tr>
            </table>
        </div>

        <div id="Div_More" class="Div_D" style="display: none; overflow: auto">
            <table style="font-size: 15px; border-collapse: separate; border-spacing: 0px 10px;">
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Ivan_Model%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_MR_IM" autocomplete="off" disabled="disabled" style="width: 100%;" />
                    </td>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Supplier_No%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_MR_S_No" autocomplete="off" disabled="disabled" style="width: 100%;" placeholder="<%=Resources.MP.S_No_ATC_Hint%>" />
                    </td>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Supplier_Short_Name%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_MR_S_SName" class="S_Name" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Product_Information%></td>
                    <td style="text-align: left; width: 15%;" colspan="7">
                        <input id="TB_MR_P_IM" autocomplete="off" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Manufacture_Spec%></td>
                    <td style="text-align: left; width: 15%;" colspan="7">
                        <textarea id="TB_MR_MS" style="width: 100%; height: 250px;" maxlength="560" disabled="disabled"></textarea>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Add_Date%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_MR_Add_Date" type="datetime" disabled="disabled" style="width: 100%;" />
                    </td>
                    <td style="text-align: center; width: 25%;text-wrap: none;" colspan="2">
                        <input id="TB_MR_DPN" type="checkbox" disabled="disabled" />
                        <label for="TB_MR_DPN"><%=Resources.Cost.Developing%></label>
                    </td>
                </tr>
            </table>
        </div>
        
        <div id="Div_Package" class="Div_D" style="display: none; overflow: auto;">
            <table style="font-size: 15px; border-collapse: separate; border-spacing: 0px 10px;">
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Ivan_Model%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_P_IM" autocomplete="off" disabled="disabled" style="width: 100%;" />
                    </td>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Supplier_No%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_P_S_No" autocomplete="off" disabled="disabled" style="width: 100%;" placeholder="<%=Resources.MP.S_No_ATC_Hint%>" />
                    </td>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Supplier_Short_Name%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_P_S_SName" class="S_Name" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Product_Information%></td>
                    <td style="text-align: left; width: 15%;" colspan="7">
                        <input id="TB_P_P_IM" autocomplete="off" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Working_Hours%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_P_WH" type="number" value="0" autocomplete="off" disabled="disabled" style="width: 100%;" />
                    </td>
                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Unit%></td>
                    <td style="text-align: left; width: 15%;">
                        <input id="TB_P_Unit" autocomplete="off" disabled="disabled" style="width: 100%;" />
                    </td>
                </tr>
                <tr>
                    <td></td>
                    <td colspan="8">
                        <div style="position: relative; border: 1px solid #111111; padding: 20px; box-sizing: border-box; margin: 30px auto; width: 100%;">
                            <span style="position: absolute; top: -1em; left: 10%; line-height: 2em; padding: 0 1em; background-color: #fff;">貨到汐止發貨中心維護/ 貨到貨櫃場與香港採購維護</span>
                            <table style="font-size: 15px; border-collapse: separate; border-spacing: 0px 10px;">
                                <tr>
                                    <td style="text-align: right; text-wrap: none; width: 10%;" rowspan="2">
                                        <%=Resources.Cost.Innerbox_Capacity%>
                                        <br />
                                        <span style="font-size:small;color:orange;">單位/內盒</span>
                                    </td>
                                    <td style="text-align: left; width: 15%;" rowspan="2">
                                        <input id="TB_P_IBC" type="number" value="0" autocomplete="off" disabled="disabled" style="width: 100%;" />
                                    </td>
                                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Outerbox_No%></td>
                                    <td style="text-align: left; width: 15%;">
                                        <input id="TB_P_OBNo" type="number" value="0" autocomplete="off" disabled="disabled" style="width: 100%;" />
                                    </td>
                                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Net_Weight%></td>
                                    <td style="text-align: left; width: 15%;">
                                        <input id="TB_P_NW" type="number" value="0" autocomplete="off" disabled="disabled" style="width: 100%;" />
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Outerbox_Lenght%></td>
                                    <td style="text-align: left; width: 15%;">
                                        <input id="TB_P_OBL" type="number" value="0" autocomplete="off" disabled="disabled" style="width: 100%;" />
                                    </td>
                                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Gross_Weight%></td>
                                    <td style="text-align: left; width: 15%;">
                                        <input id="TB_P_GW" type="number" value="0" autocomplete="off" disabled="disabled" style="width: 100%;" />
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: right; text-wrap: none; width: 10%;">
                                        <%=Resources.Cost.Innerbox_Amount%>
                                        <br />
                                        <span style="font-size:small;color:orange;">內盒/內箱</span>
                                    </td>
                                    <td style="text-align: left; width: 15%;">
                                        <input id="TB_P_IA" type="number" value="0" autocomplete="off" disabled="disabled" style="width: 100%;" />
                                    </td>
                                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Outerbox_Weight%></td>
                                    <td style="text-align: left; width: 15%;">
                                        <input id="TB_P_OBW" type="number" value="0" autocomplete="off" disabled="disabled" style="width: 100%;" />
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: right; text-wrap: none; width: 10%;">
                                        <%=Resources.Cost.Innerbox_Amount_2%>
                                        <br />
                                        <span style="font-size:small;color:orange;">內箱/外箱</span>
                                    </td>
                                    <td style="text-align: left; width: 15%;">
                                        <input id="TB_P_IA2" type="number" value="0" autocomplete="off" disabled="disabled" style="width: 100%;" />
                                    </td>
                                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Outerbox_Height%></td>
                                    <td style="text-align: left; width: 15%;">
                                        <input id="TB_P_OBH" type="number" value="0" autocomplete="off" disabled="disabled" style="width: 100%;" />
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td></td>
                    <td colspan="8">
                        <div style="position: relative; border: 1px solid #111111; padding: 20px; box-sizing: border-box; margin: 30px auto; width: 100%;">
                            <span style="position: absolute; top: -1em; left: 10%; line-height: 2em; padding: 0 1em; background-color: #fff;">理樣中心維護 單位:重量(g)#長寬高(mm)</span>
                            <table style="font-size: 15px; border-collapse: separate; border-spacing: 0px 10px;">
                                <tr>
                                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Net_Weight%></td>
                                    <td style="text-align: left; width: 15%;">
                                        <input id="TB_P_P_NW" type="number" value="0" autocomplete="off" disabled="disabled" style="width: 100%;" />
                                    </td>
                                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Gross_Weight%></td>
                                    <td style="text-align: left; width: 15%;">
                                        <input id="TB_P_P_GW" type="number" value="0" autocomplete="off" disabled="disabled" style="width: 100%;" />
                                    </td>
                                    <td></td>
                                    <td style="text-align: left; text-wrap: none; width: 10%;" colspan="2">
                                        <span style="font-size:small;color:orange;">淨重：開發用(不含螺絲)</span>
                                        <br />
                                        <span style="font-size:small;color:orange;">毛重：出貨用(含包裝與配件)</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Product_Length%></td>
                                    <td style="text-align: left; width: 15%;">
                                        <input id="TB_P_PL" type="number" value="0" autocomplete="off" disabled="disabled" style="width: 100%;" />
                                    </td>
                                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Product_Weight%></td>
                                    <td style="text-align: left; width: 15%;">
                                        <input id="TB_P_PW" type="number" value="0" autocomplete="off" disabled="disabled" style="width: 100%;" />
                                    </td>
                                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Product_Height%></td>
                                    <td style="text-align: left; width: 15%;">
                                        <input id="TB_P_PH" type="number" value="0" autocomplete="off" disabled="disabled" style="width: 100%;" />
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Package_Length%></td>
                                    <td style="text-align: left; width: 15%;">
                                        <input id="TB_P_PGL" type="number" value="0" autocomplete="off" disabled="disabled" style="width: 100%;" />
                                    </td>
                                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Package_Weight%></td>
                                    <td style="text-align: left; width: 15%;">
                                        <input id="TB_P_PGW" type="number" value="0" autocomplete="off" disabled="disabled" style="width: 100%;" />
                                    </td>
                                    <td style="text-align: right; text-wrap: none; width: 10%;"><%=Resources.Cost.Package_Height%></td>
                                    <td style="text-align: left; width: 15%;">
                                        <input id="TB_P_PGH" type="number" value="0" autocomplete="off" disabled="disabled" style="width: 100%;" />
                                    </td>
                                </tr>

                            </table>
                            
                        </div>
                    </td>
                </tr>
            </table>
        </div>
        <div id="Div_Report" class="Div_D" style="display: none; overflow: auto">
        </div>

    </div>
    <br />
    <br />

</asp:Content>

