<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Ivan_Login</title>
    <link rel="shortcut icon" type="image/jpg" href="/images/ivan_logo.ico"/>
    <style>
        body {
            font-family: Arial, Helvetica, sans-serif;
        }

        form {
            border: 3px solid #f1f1f1;
            
            width: 100%;
            margin: auto;
            max-width: 525px;
            min-height: 670px;
            position: relative;
            box-shadow: 0 12px 15px 0 rgba(0,0,0,.24),0 17px 50px 0 rgba(0,0,0,.19);
        }
        
        input[type=text], input[type=password] {
            width: 100%;
            padding: 12px 20px;
            margin: 8px 0;
            display: inline-block;
            border: 1px solid #ccc;
            box-sizing: border-box;
        }

        .button {
            background-color: #04AA6D;
            color: white;
            padding: 14px 20px;
            margin: 8px 0;
            border: none;
            cursor: pointer;
            width: 100%;
        }

            .button:hover {
                opacity: 0.8;
            }

        .cancelbtn {
            width: auto;
            padding: 10px 18px;
            background-color: #f44336;
        }

        .imgcontainer {
            text-align: center;
            margin: 24px 0 12px 0;
        }

        img.avatar {
            width: 40%;
            border-radius: 50%;
        }

        .container {
            padding: 16px;
        }

        span.psw {
            float: right;
            padding-top: 16px;
        }

        /* Change styles for span and cancel button on extra small screens */
        @media screen and (max-width: 300px) {
            span.psw {
                display: block;
                float: none;
            }

            .cancelbtn {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    
    <script src="/js/jquery-3.6.0.min.js"></script>

    <br />
    <div style="text-align:center;"><h2 style="margin:0 auto;">Login_Demo_1</h2></div>
    <br />

    <form><%--method="post"--%>
        <div class="imgcontainer">
            <img src="\images/IVAN_250x150.jpeg" />
        </div>

        <div class="container">
            <label for="uname"><b>Username</b></label>
            <input type="text" placeholder="Enter Username" name="uname" id="user" required="required" />

            <label for="psw"><b>Password</b></label>
            <input type="password" placeholder="Enter Password" name="psw" id="pass" required="required" />
            
            <input type="button" class="button" value="Login" onclick="Login_Ajax()" />

            <%--<button type="submit">Login</button>--%>
            <label>
                <input type="checkbox" checked="checked" name="remember"  />
                Remember me
            </label>
        </div>

        <div class="container" style="background-color: #f1f1f1">
            <%--<button type="button" class="cancelbtn">Cancel</button>--%>
            <span class="psw">Forgot <a href="#">password?</a></span>
        </div>
        
    <script type="text/javascript">
        function Check_FN() {
            if ($('#user').val() === "") {
                alert('Please input UserName.');
                return false;
            }
            if ($('#pass').val() === "") {
                //Add 例外
                if (String($('#user').val()).toUpperCase() === "ERIC") {
                    return true;
                }
                alert('Please input Password.');
                return false;
            }
            return true;
        };

        function Login_Ajax() {
            if (Check_FN()) {
                var Account = $('#user').val();
                var Password = $('#pass').val();

                $.ajax({
                    url: "/Web_Service/Login_Call.asmx/Login_FN",
                    cache: false,
                    data: "{'Login_Account': '" + Account + "', 'Login_Password' : '" + Password + "'}",
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (data) {
                        switch (data.d) {
                            case "Account_Not_Exists":
                                alert("User Name Error!");
                                return false;
                                break;
                            case "Password_Error":
                                alert("Password Error!");
                                return false;
                                break;
                        }
                        
                        var Json_Response = JSON.parse(data.d);
                        //console.warn(data.d);
                        alert(Json_Response[0].Response_Account + " - Login");
                        //window.open("IDX1.aspx");
                        window.location.assign("IDX1.aspx");

                    },
                    error: function (response) {
                        alert(response.responseText);
                    },
                });
            }
        };
    </script>
    </form>

</body>
</html>
