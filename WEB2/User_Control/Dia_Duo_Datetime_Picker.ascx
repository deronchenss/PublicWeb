<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Dia_Duo_Datetime_Picker.ascx.cs" Inherits="User_Control_Dia_Duo_Datetime_Picker" %>

<script type="text/javascript">
    $(document).ready(function () {
        $('#DDPB_TB_DS, #DDPB_TB_DE').val($.datepicker.formatDate('yy-mm-dd', new Date()));
        $("#Duo_Datetime_Picker_Dialog").dialog({
            autoOpen: false,
            modal: true,
            title: "<%=Resources.MP.Search_Confition%>",
            width: screen.width * 0.3,
            overlay: 0.5,
            position: { my: "center", at: "top" },
            focus: true,
            buttons: {
                "Confirm": function () {
                    $('.TB_DS[type=date]').val($('#DDPB_TB_DS').val());
                    $('.TB_DE[type=date]').val($('#DDPB_TB_DE').val());
                    $("#Duo_Datetime_Picker_Dialog").dialog('close');
                },
                "Clear": function () {
                    $('.TB_DS[type=date]').val('');
                    $('.TB_DE[type=date]').val('');
                    $("#Duo_Datetime_Picker_Dialog").dialog('close');
                }
            }
        });
        $('input[type=radio][name=DDPD_RB]').on('change', function () {
            //console.warn($(this).prop('id'));
            switch ($(this).prop('id')) {
                case "DDPD_RB_This_Day":
                    $('#DDPB_TB_DS, #DDPB_TB_DE').val($.datepicker.formatDate('yy-mm-dd', new Date()));
                    $('.TB_DS[type=date]').val($('#DDPB_TB_DS').val());
                    $('.TB_DE[type=date]').val($('#DDPB_TB_DE').val());
                    $("#Duo_Datetime_Picker_Dialog").dialog('close');
                    break;
                case "DDPD_RB_Two_Day":
                    $('#DDPB_TB_DS').val($.datepicker.formatDate('yy-mm-dd', new Date(new Date().setDate(new Date().getDate() - 2))));
                    $('#DDPB_TB_DE').val($.datepicker.formatDate('yy-mm-dd', new Date()));
                    $('.TB_DS[type=date]').val($('#DDPB_TB_DS').val());
                    $('.TB_DE[type=date]').val($('#DDPB_TB_DE').val());
                    $("#Duo_Datetime_Picker_Dialog").dialog('close');
                    break;
                case "DDPD_RB_This_Month":
                    $('#DDPB_TB_DS').val($.datepicker.formatDate('yy-mm', new Date()) + '-01');
                    $('#DDPB_TB_DE').val($.datepicker.formatDate('yy-mm-dd', new Date()));
                    $('.TB_DS[type=date]').val($('#DDPB_TB_DS').val());
                    $('.TB_DE[type=date]').val($('#DDPB_TB_DE').val());
                    $("#Duo_Datetime_Picker_Dialog").dialog('close');
                    break;
                case "DDPD_RB_Three_Day":
                    $('#DDPB_TB_DS').val($.datepicker.formatDate('yy-mm-dd', new Date(new Date().setDate(new Date().getDate() - 3))));
                    $('#DDPB_TB_DE').val($.datepicker.formatDate('yy-mm-dd', new Date()));
                    $('.TB_DS[type=date]').val($('#DDPB_TB_DS').val());
                    $('.TB_DE[type=date]').val($('#DDPB_TB_DE').val());
                    $("#Duo_Datetime_Picker_Dialog").dialog('close');
                    break;
                case "DDPD_RB_This_Year":
                    $('#DDPB_TB_DS').val($.datepicker.formatDate('yy', new Date()) + '-01-01');
                    $('#DDPB_TB_DE').val($.datepicker.formatDate('yy-mm-dd', new Date()));
                    $('.TB_DS[type=date]').val($('#DDPB_TB_DS').val());
                    $('.TB_DE[type=date]').val($('#DDPB_TB_DE').val());
                    $("#Duo_Datetime_Picker_Dialog").dialog('close');
                    break;
                case "DDPD_RB_Seven_Day":
                    $('#DDPB_TB_DS').val($.datepicker.formatDate('yy-mm-dd', new Date(new Date().setDate(new Date().getDate() - 7))));
                    $('#DDPB_TB_DE').val($.datepicker.formatDate('yy-mm-dd', new Date()));
                    $('.TB_DS[type=date]').val($('#DDPB_TB_DS').val());
                    $('.TB_DE[type=date]').val($('#DDPB_TB_DE').val());
                    $("#Duo_Datetime_Picker_Dialog").dialog('close');
                    break;
                case "DDPD_RB_Last_Year":
                    $('#DDPB_TB_DS').val($.datepicker.formatDate('yy-mm-dd', new Date(new Date().setDate(new Date().getDate() - 365))));
                    $('#DDPB_TB_DE').val($.datepicker.formatDate('yy-mm-dd', new Date()));
                    $('.TB_DS[type=date]').val($('#DDPB_TB_DS').val());
                    $('.TB_DE[type=date]').val($('#DDPB_TB_DE').val());
                    $("#Duo_Datetime_Picker_Dialog").dialog('close');
                    break;
                case "DDPD_RB_Last_Month":
                    $('#DDPB_TB_DS').val($.datepicker.formatDate('yy-mm-dd', new Date(new Date().setDate(new Date().getDate() - 30))));
                    $('#DDPB_TB_DE').val($.datepicker.formatDate('yy-mm-dd', new Date()));
                    $('.TB_DS[type=date]').val($('#DDPB_TB_DS').val());
                    $('.TB_DE[type=date]').val($('#DDPB_TB_DE').val());
                    $("#Duo_Datetime_Picker_Dialog").dialog('close');
                    break;
            };

        });
    });
</script>
<style>
</style>

<div id="Duo_Datetime_Picker_Dialog" style="display: none;">
        <table border="0" style="margin: 0 auto;" id="DDPD_Table">
            <tr style="text-align:center;">
                <td style="text-align: right; text-wrap: none; width: 20%;"><%=Resources.MP.Update_Date%></td>
                <td style="text-align: left; width: 50%;">
                    <input id="DDPB_TB_DS" type="date" style="width: 50%;" /><input id="DDPB_TB_DE" type="date" style="width: 50%;" />
                </td>
            </tr>
            <tr><td><br /></td></tr>
            <tr>
                <td></td>
                <td colspan="2">
                    <div style="position: relative; border: 1px solid #111111; padding: 20px; box-sizing: border-box; margin: 0 auto; width: 100%;">
                        <div style="width: 50%;float:left;">
                            <input id="DDPD_RB_This_Day" type="radio" name="DDPD_RB" checked="checked" />
                            <label for="DDPD_RB_This_Day">當日</label>
                        </div>
                        <div style="width: 50%;float:right;">
                            <input id="DDPD_RB_Two_Day" type="radio" name="DDPD_RB" />
                            <label for="DDPD_RB_Two_Day">2 Day</label>
                        </div>
                        <div style="width: 50%;float:left;">
                            <input id="DDPD_RB_This_Month" type="radio" name="DDPD_RB" />
                            <label for="DDPD_RB_This_Month">當月</label>
                        </div>
                        <div style="width: 50%;float:right;">
                            <input id="DDPD_RB_Three_Day" type="radio" name="DDPD_RB" />
                            <label for="DDPD_RB_Three_Day">3 Day</label>
                        </div>
                        <div style="width: 50%;float:left;">
                            <input id="DDPD_RB_This_Year" type="radio" name="DDPD_RB" />
                            <label for="DDPD_RB_This_Year">當年</label>
                        </div>
                        <div style="width: 50%;float:right;">
                            <input id="DDPD_RB_Seven_Day" type="radio" name="DDPD_RB" />
                            <label for="DDPD_RB_Seven_Day">7 Day</label>
                        </div>
                        <div style="width: 50%;float:left;">
                            <input id="DDPD_RB_Last_Year" type="radio" name="DDPD_RB" />
                            <label for="DDPD_RB_Last_Year">去年</label>
                        </div>
                        <div style="width: 50%;float:right;">
                            <input id="DDPD_RB_Last_Month" type="radio" name="DDPD_RB" />
                            <label for="DDPD_RB_Last_Month">上月</label>
                        </div>
                        <div>&nbsp;</div>
                    </div>
                </td>
            </tr>
        </table>
    </div>