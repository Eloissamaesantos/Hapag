<%@ Page Language="VB" AutoEventWireup="false" CodeFile="LandingPage.aspx.vb" Inherits="LandingPage" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 4.1 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>

    <link href="./../../StyleSheets/StyleSheet.css" rel="stylesheet" type="text/css" />
</head>

<body>
   <div class="root-container">
       <div class="top-navbar">
            <div class="left">
                <img src="./../../Assets/Images/logo.png" alt="Alternate Text" />
            </div>
            <div class="right">
                <ul>
                    <a href="#"><li class="active"><span>HOME</span></li></a>
                    <a href="#"><li><span>ABOUT</span></li></a>
                    <a href="#"><li><span>CONTACT US</span></li></a>
                </ul>
            </div>
       </div>

       <div class="main-container">
            <div class="main-background" style="background-image:url('./../../Assets/Images/backgrounds/land_page_bg.png')"></div>
            <div class="main-headline">
                <h1>
                Savor the taste of Home at Hapag
                </h1>
                <p>
                "Authentic Filipino flavors, handcrafted with love and tradition, bringing families together one meal at a time."
                </p>

                <div class="buttons">
                    <a href="./../LoginPortal/CustomerLoginPortal.aspx">
                    <div class="ui-button">
                        <span>LOG IN</span>
                    </div>
                    </a>
                    <a href="#">
                    <div class="ui-button">
                        <span>SIGN UP</span>
                    </div>
                    </a>
                </div>
            </div>
       </div>
   </div>
</body>
</html>

