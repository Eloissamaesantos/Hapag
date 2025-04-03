﻿<%@ Page Language="VB" AutoEventWireup="false" CodeFile="AdminPromotions.aspx.vb" Inherits="Pages_Admin_AdminPromotions" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Manage Promotions</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link href="./../../StyleSheets/Layout.css" rel="stylesheet" type="text/css" />
    <link href="./../../StyleSheets/Admin.css" rel="stylesheet" type="text/css" />
    <script src="../../Scripts/jquery-3.6.0.min.js" type="text/javascript"></script>
    <link href="../../Scripts/jquery-ui.css" rel="stylesheet" type="text/css" />
    <script src="../../Scripts/jquery-ui.min.js" type="text/javascript"></script>
    <style type="text/css">
        /* Dropdown styles */
        .dropdown-container {
            position: relative;
        }
        
        .dropdown-menu {
            display: none;
            position: absolute;
            left: 100%;
            top: 0;
            background-color: #f9f9f9;
            min-width: 160px;
            box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
            z-index: 1;
            border-radius: 4px;
        }
        
        .dropdown-container:hover .dropdown-menu {
            display: block;
        }
        
        .dropdown-menu a {
            color: #333;
            padding: 12px 16px;
            text-decoration: none;
            display: block;
            transition: background-color 0.3s;
        }
        
        .dropdown-menu a:hover {
            background-color: #f1f1f1;
            color: #000;
        }
        
        /* Mobile dropdown */
        @media screen and (max-width: 768px) {
            .dropdown-menu {
                position: static;
                box-shadow: none;
                width: 100%;
                padding-left: 30px;
            }
            
            .dropdown-container:hover .dropdown-menu {
                display: none;
            }
            
            .dropdown-container.active .dropdown-menu {
                display: block;
            }
            
            .dropdown-toggle {
                cursor: pointer;
            }
        }
        
        .image-panel {
            width: 200px;
            height: 200px;
            border: 1px solid #ddd;
            border-radius: 4px;
            padding: 5px;
            margin-top: 10px;
            background-color: #f8f8f8;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
        }
        
        .image-panel img {
            max-width: 100%;
            max-height: 100%;
        }
    </style>
</head>
<body>
    <form id="Form1" runat="server">
        <div class="page-container">
            <!-- Admin Sidebar -->
            <div class="admin-sidebar">
                <div class="logo">
                    <img src="../../Assets/Images/logo-removebg-preview.png" alt="Logo" />
                </div>
                <div class="nav-links">
                    <a href="AdminDashboard.aspx">
                        <img src="../../Assets/Images/icons/dashboard icon black.png" class="black" />
                        <img src="../../Assets/Images/icons/dasboard icon white.png" class="white" />
                        <span>Dashboard</span>
                    </a>

                    <a href="AdminMenu.aspx">
                        <img src="../../Assets/Images/icons/menu-black.png" class="black" />
                        <img src="../../Assets/Images/icons/menu-white.png" class="white" />
                        <span>Menu</span>
                    </a> 
                    
                    <a href="AdminMenuCategories.aspx">
                        <img src="../../Assets/Images/icons/menu-black.png" class="black" />
                        <img src="../../Assets/Images/icons/menu-white.png" class="white" />
                        <span>Categories</span>
                    </a>

                    <a href="AdminMenuTypes.aspx">
                        <img src="../../Assets/Images/icons/menu-black.png" class="black" />
                        <img src="../../Assets/Images/icons/menu-white.png" class="white" />
                        <span>Types</span>
                    </a>

                    <a href="AdminOrders.aspx">
                        <img src="../../Assets/Images/icons/order-black.png" class="black" />
                        <img src="../../Assets/Images/icons/order-white.png" class="white" />
                        <span>Orders</span>
                    </a>

                    <a href="AdminAccounts.aspx">
                        <img src="../../Assets/Images/icons/account-black.png" class="black" />
                        <img src="../../Assets/Images/icons/account-white.png" class="white" />
                        <span>Accounts</span>
                    </a>

                    <div class="dropdown-container">
                        <a href="javascript:void(0);" class="dropdown-toggle">
                            <img src="../../Assets/Images/icons/administrator-black.png" class="black" />
                            <img src="../../Assets/Images/icons/administrator-white.png" class="white" />
                            <span>Administrator</span>
                        </a>
                        <div class="dropdown-menu">
                            <a href="AdminDeals.aspx">Deals</a>
                            <a href="AdminPromotions.aspx" class="active">Promotions</a>
                            <a href="AdminDiscounts.aspx">Discounts</a>
                        </div>
                    </div>

                    <a href="Admin Transaction.aspx">
                        <img src="../../Assets/Images/icons/transaction-black.png" class="black" />
                        <img src="../../Assets/Images/icons/transaction-white.png" class="white" />
                        <span>Transactions</span>
                    </a>
                </div>
            </div>
            
            <!-- Main Content -->
            <div class="main-content">
                <!-- Mobile Menu Toggle -->
                <button class="menu-toggle" id="menuToggle">
                    <i class="fa fa-bars"></i> Menu
                </button>
                
                <!-- Content Container -->
                <div class="content-container">
                    <!-- Content Header -->
                    <div class="content-header">
                        <h1>Manage Promotions</h1>
                        <p>Add, edit, or remove promotional campaigns</p>
                    </div>
                    
                    <!-- Alert Message -->
                    <div class="alert-message" id="alertMessage" runat="server" visible="false">
                        <asp:Literal ID="AlertLiteral" runat="server"></asp:Literal>
                    </div>
                    
                    <!-- Form Container -->
                    <div class="form-container">
                        <asp:TextBox ID="PromotionIdTxt" runat="server" Width="282px" RequiredFieldValidator1="true" hidden></asp:TextBox>
                        
                        <div class="form-row">
                            <div class="form-group-half">
                                <h3>Promotion Name:</h3>
                                <asp:TextBox ID="NameTxt" runat="server" CssClass="form-control"></asp:TextBox>
                            </div>
                            <div class="form-group-half">
                                <h3>Promotion Code:</h3>
                                <asp:TextBox ID="CodeTxt" runat="server" CssClass="form-control"></asp:TextBox>
                            </div>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group-half">
                                <h3>Discount Amount:</h3>
                                <asp:TextBox ID="DiscountAmountTxt" runat="server" CssClass="form-control"></asp:TextBox>
                            </div>
                            <div class="form-group-half">
                                <h3>Discount Type:</h3>
                                <asp:DropDownList ID="DiscountTypeDdl" runat="server" CssClass="form-control">
                                    <asp:ListItem Text="Percentage" Value="1"></asp:ListItem>
                                    <asp:ListItem Text="Fixed Amount" Value="2"></asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group-half">
                                <h3>Start Date:</h3>
                                <asp:TextBox ID="StartDateTxt" runat="server" CssClass="form-control date-picker1"></asp:TextBox>
                            </div>
                            <div class="form-group-half">
                                <h3>End Date:</h3>
                                <asp:TextBox ID="EndDateTxt" runat="server" CssClass="form-control date-picker2"></asp:TextBox>
                            </div>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group-half">
                                <h3>Minimum Purchase:</h3>
                                <asp:TextBox ID="MinPurchaseTxt" runat="server" CssClass="form-control"></asp:TextBox>
                            </div>
                            <div class="form-group-half">
                                <h3>Status:</h3>
                                <asp:DropDownList ID="StatusDdl" runat="server" CssClass="form-control">
                                    <asp:ListItem Text="Active" Value="1"></asp:ListItem>
                                    <asp:ListItem Text="Inactive" Value="0"></asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <h3>Description:</h3>
                                <asp:TextBox ID="DescriptionTxt" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="4"></asp:TextBox>
                            </div>
                        </div>
                        
                        <div class="form-actions">
                            <asp:Button ID="AddBtn" runat="server" Text="ADD" CssClass="btn btn-primary" />
                            <asp:Button ID="EditBtn" runat="server" Text="EDIT" CssClass="btn btn-secondary" />
                            <asp:Button ID="RemoveBtn" runat="server" Text="REMOVE" CssClass="btn btn-danger" />
                            <asp:Button ID="ClearBtn" runat="server" Text="CLEAR" CssClass="btn btn-info" />
                        </div>
                    </div>
                </div>
                
                <!-- Table Container -->
                <div class="content-container">
                    <div class="content-header">
                        <h1>Active Promotions</h1>
                        <p>Click on a row to select and edit a promotion</p>
                    </div>
                    <div class="table-responsive">
                        <asp:Table ID="Table1" runat="server" CssClass="table table-striped table-hover">
                        </asp:Table>
                    </div>
                </div>
                
                <!-- Footer -->
                <div class="footer">
                    <p>&copy; <%= DateTime.Now.Year %> Food Ordering System. All rights reserved.</p>
                </div>
            </div>
    </div>
    </form>

    <script type="text/javascript">
        // Mobile menu toggle
        document.getElementById('menuToggle').addEventListener('click', function() {
            var sidebar = document.querySelector('.admin-sidebar');
            var mainContent = document.querySelector('.main-content');
            
            if (sidebar.style.width === '250px' || sidebar.style.width === '') {
                sidebar.style.width = '0';
                mainContent.style.marginLeft = '0';
            } else {
                sidebar.style.width = '250px';
                mainContent.style.marginLeft = '250px';
            }
        });
        
        // Dropdown toggle
        document.addEventListener('DOMContentLoaded', function() {
            var dropdownToggles = document.querySelectorAll('.dropdown-toggle');
            
            dropdownToggles.forEach(function(toggle) {
                toggle.addEventListener('click', function(e) {
                    e.preventDefault();
                    this.parentElement.classList.toggle('active');
                });
            });
            
            // Set active class based on current page
            var currentPage = window.location.pathname.split('/').pop();
            var navLinks = document.querySelectorAll('.nav-links a');
            var dropdownLinks = document.querySelectorAll('.dropdown-menu a');
            
            navLinks.forEach(function(link) {
                var href = link.getAttribute('href');
                if (href === currentPage) {
                    link.classList.add('active');
                }
            });
            
            dropdownLinks.forEach(function(link) {
                var href = link.getAttribute('href');
                if (href === currentPage) {
                    link.classList.add('active');
                    link.parentElement.parentElement.classList.add('active');
                }
            });
            
            // Initialize date pickers
            $(".date-picker1, .date-picker2").datepicker({
                dateFormat: 'mm/dd/yy'
            });
        });
    
        function UnHighlight(rows) {
            for (var row of rows) {
                row.classList.remove("active");
            }
        }

        function Highlight(rows, row) {
            UnHighlight(rows);
            row.classList.add("active");
        }

        function ListenTable() {
            var table = document.getElementById("Table1");
            var rows = table.querySelectorAll("tr");

            for(const row of rows) {
                row.addEventListener("click", function() {
                    Highlight(rows, row);
                    Display(row);
                });
            }
        }
        
        function Display(row) {
            const pidTxt = document.getElementById("PromotionIdTxt");
            const nTxt = document.getElementById("NameTxt");
            const cTxt = document.getElementById("CodeTxt");
            const daTxt = document.getElementById("DiscountAmountTxt");
            const dtTxt = document.getElementById("DiscountTypeDdl");
            const sdTxt = document.getElementById("StartDateTxt");
            const edTxt = document.getElementById("EndDateTxt");
            const mpTxt = document.getElementById("MinPurchaseTxt");
            const sTxt = document.getElementById("StatusDdl");
            const descTxt = document.getElementById("DescriptionTxt");
            const cols = row.querySelectorAll("td");

            pidTxt.value = row.getAttribute("data-promotion_id");
            nTxt.value = cols[0].innerText;
            cTxt.value = cols[1].innerText;
            daTxt.value = cols[2].innerText;
            dtTxt.value = cols[3].innerText === "Percentage" ? "1" : "2";
            sdTxt.value = cols[4].innerText;
            edTxt.value = cols[5].innerText;
            mpTxt.value = cols[6].innerText;
            sTxt.value = cols[7].innerText === "Active" ? "1" : "0";
            descTxt.value = row.getAttribute("data-description");
        }

        function ListenToButtons() {
            const editBtn = document.getElementById("EditBtn");
            const removeBtn = document.getElementById("RemoveBtn");
            const promotionIdTxt = document.getElementById("PromotionIdTxt");

            editBtn.addEventListener("click", function(e) {
                if (promotionIdTxt.value.length == 0) {
                    showAlert("Please Select a Promotion!", "warning");
                    e.preventDefault();
                }
            });
            
            removeBtn.addEventListener("click", function(e) {
                if (promotionIdTxt.value.length == 0) {
                    showAlert("Please Select a Promotion!", "warning");
                    e.preventDefault();
                    return false;
                }
                
                if(!confirm("Do you really want to delete this promotion?")) {
                    e.preventDefault();
                    return false;
                }
            });
        }
        
        function showAlert(message, type) {
            const alertMessage = document.getElementById("alertMessage");
            
            alertMessage.className = "alert-message";
            alertMessage.classList.add("alert-" + type);
            alertMessage.innerHTML = message;
            alertMessage.style.display = "block";
        }

        ListenTable();
        ListenToButtons();
    </script>
</body>
</html>
