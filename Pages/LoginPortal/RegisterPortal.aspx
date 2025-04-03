<%@ Page Language="VB" AutoEventWireup="false" CodeFile="RegisterPortal.aspx.vb" Inherits="Pages_Customer_RegisterPortal" %>

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
            <div class="right">
                <img src="./../../Assets/Images/logo.png" alt="Alternate Text" />
            </div>
       </div>

       <div class="main-container">
            <div class="left-side-background" style="background-image:url('./../../Assets/Images/backgrounds/signup_background.png')"></div>

            <div class="main-auth-container signup">
                <div class="head">
                    <h1>
                        SIGN UP
                    </h1>
                </div>
                <div class="body">
                    <div class="form-group">
                        <label for="displayName">Display Name</label>
                        <asp:TextBox ID="displayNameTxt" runat="server"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label for="username">Username</label>
                        <asp:TextBox ID="usernameTxt" runat="server"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label for="username">Password</label>
                         <asp:TextBox ID="passwordTxt" type="password"  runat="server"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label for="username">Confirm Password</label>
                         <asp:TextBox ID="confirmPasswordTxt" type="password"  runat="server"></asp:TextBox>
                    </div>

                      <div class="form-group">
                          <asp:Button ID="Button1" Text="Submit" runat="server" UseSubmitBehavior="false" />
                    </div>

                    <div class="form-group">
                        <p>
                        Already have an account? <a href="./../LoginPortal/CustomerLoginPortal.aspx">Log In</a>
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
