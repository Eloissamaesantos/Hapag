﻿<%@ Page Language="VB" AutoEventWireup="false" CodeFile="StaffOrderManagement.aspx.vb" Inherits="Pages_Staff_StaffOrderManagement" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
<link href="./../../StyleSheets/Admin.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="Form1" runat="server">
        <div class="sidenav">
            <img src="../../Assets/Images/logo-removebg-preview.png" alt="Alternate Text" class="right" />
            <div class="icons">
                <a href="#">
                    <img src="../../Assets/Images/icons/dashboard icon black.png" class="black" />
                    <img src="../../Assets/Images/icons/dasboard icon white.png" class="white" />
                Dashboard</a>
      

                <a href="#">
                    <img src="../../Assets/Images/icons/order-black.png" class="black" />
                    <img src="../../Assets/Images/icons/order-white.png" class="white" />
                Orders</a>


                <a href="#">
                    <img src="../../Assets/Images/icons/message-black.png" class="black" />
                    <img src="../../Assets/Images/icons/message-white.png" class="white" />
                Messages</a> 

                <a href="#">
                    <img src="../../Assets/Images/icons/doc-black.png" class="black" />
                    <img src="../../Assets/Images/icons/doc-white.png" class="white" />
                Payments</a>
            </div>

        </div>
        <div class="menu">
               
          <div class="form-menu">
             <span class="dot" style="background-color: #D12929; margin-right:40px; margin-top:20px;"></span>
                <span class="dot" style="background-color: #FFC233; margin-top:20px;"></span>
                <span class="dot" style="background-color: #619F2B; margin-top:20px;"></span>
                <br />
                    <h2>Order Managment</h2>
                    
            </div>
            <br />

            <div class="crudbuttons">
              <asp:Button ID="AddBtn" runat="server" Text="ADD" class="green" />
              <asp:Button ID="EditBtn" runat="server" Text="EDIT" class="yellow" />
              <asp:Button ID="RemoveBtn" runat="server" Text="REMOVE" class="red" />
            </div>
        </div>
   </form>
</body>
</html>
