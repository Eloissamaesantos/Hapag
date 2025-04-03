<%@ Page Language="VB" AutoEventWireup="false" CodeFile="CustomerLoginPortal.aspx.vb" Inherits="CustomerLoginPortal" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>

     <link href="./../../StyleSheets/StyleSheet.css" rel="stylesheet" type="text/css" />
</head>
<body>
       <form id="Form1" runat="server">
        <div class="root-container">
       <div class="top-navbar">
            <div class="left">
                <img src="./../../Assets/Images/logo.png" alt="Alternate Text" />
            </div>
       </div>

       <div class="register-main-container">
            <div class="right-side-background" 
                style="background-image:url('http://localhost:58936/FOS/Assets/Images/backgrounds/login_background.png')"></div>

            <div class="register-main-auth-container login">
                <div class="left-head">
                    <h1>
                        LOG IN
                    </h1>
                </div>
                <div class="left-body">
                    <div class="left-form-group">
                        <label for="username">Username</label>
                        <asp:TextBox ID="usernameTxt" runat="server"></asp:TextBox>
                    </div>
                    <div class="left-form-group">
                        <label for="username">Password</label>
                         <asp:TextBox ID="passwordTxt" type="password"  runat="server"></asp:TextBox>
                    </div>

                      <div class="left-form-group">
                          <asp:Button ID="Button1" Text="Submit" runat="server" UseSubmitBehavior="false" />
                    </div>

                    <div class="left-form-group">
                        <p>
                        Don't have an account? <a href="./../LoginPortal/RegisterPortal.aspx">Register</a>
                        </p>
                    </div>
                </div>
            </div>
       </div>
    </div>
    </form>

  <script type="text/javascript">
      document.getElementById('Button1').addEventListener('click', function (event) {
          event.preventDefault(); // Prevents form submission if button is inside a form
      });
</script>


</body>
</html>
