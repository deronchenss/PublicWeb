<%@ Page Title="Model Search" Language="C#" MasterPageFile="~/MP.master" AutoEventWireup="true" CodeFile="Test.aspx.cs" Inherits="Base_Test" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <link href="/css/dataTables.bootstrap4.min.css" rel="stylesheet" />
    <script src="/js/jquery.dataTables.min.js"></script>
    <script src="/js/dataTables.bootstrap4.min.js"></script>

    
    <script type="text/javascript">
        $(document).ready(function () {
            $('#T_BT').on('click', function () {
                $.ajax({
                    url: "//192.168.1.134/BarTender/Authenticate",
                    data: {
                        "libraryID": "9701eadb-7aec-43d5-97c7-7a9e0bd23ec6",
                        "relativePath": "Demo_BTW/MakerAid.btw",
                        "printer": "TSC TTP-2410M"
                    },
                    cache: false,
                    type: "POST",
                    datatype: "json",
                    //contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                    success: function (R) {
                        console.warn(R);
                    },
                    error: function (ex) {
                        console.warn(ex);
                    }
                });

            });

        });
    </script>
    
    <div style="width: 99%; margin: 0 auto; background-color: white;">
        &nbsp;
        <input type="button" class="V_BT" value="<%=Resources.MP.Basic%>" onclick="$('.Div_D').css('display','none');$('#Div_Basic').css('width','100%');" disabled="disabled" />
        <input type="button" class="V_BT" value="<%=Resources.MP.Image%>" onclick="$('.Div_D').css('display','none');$('#Div_Image').css('display','');$('#Div_Basic').css('width','60%');$('#Div_Image').css('width','40%');" />
    </div>
    <input id="T_BT" value="TEST_BT" type="button"  />

</asp:Content>

