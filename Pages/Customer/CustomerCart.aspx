<%@ Page Language="VB" AutoEventWireup="false" CodeFile="CustomerCart.aspx.vb" Inherits="Pages_Customer_CustomerCart" MasterPageFile="~/Pages/Customer/CustomerTemplate.master" %>
<%@ Register Assembly="System.Web.Extensions, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="content-container">
        <!-- Hidden Fields for JavaScript -->
        <asp:HiddenField ID="DeliveryFeeHidden" runat="server" Value="0" />
        <asp:HiddenField ID="DeliveryTypeHidden" runat="server" Value="standard" />
        <asp:HiddenField ID="ScheduledTimeHidden" runat="server" Value="" />
        <asp:HiddenField ID="DiscountIdHidden" runat="server" Value="0" />
        <asp:HiddenField ID="DiscountValueHidden" runat="server" Value="0" />
        <asp:HiddenField ID="DeliveryAddressHidden" runat="server" Value="" />
        <asp:HiddenField ID="RestaurantLocationHidden" runat="server" Value="14.651493,121.049888" />
        <asp:HiddenField ID="AddressCoordinatesHidden" runat="server" Value="" />
        <asp:HiddenField ID="DistanceHidden" runat="server" Value="0" />

        <!-- Content Header -->
        <div class="content-header">
            <h1><i class="fas fa-shopping-cart"></i> My Cart</h1>
            <p>Review and manage your selected items</p>
        </div>

        <!-- Alert Message -->
        <div class="alert-message" id="alertMessage" runat="server" visible="false">
            <asp:Literal ID="AlertLiteral" runat="server"></asp:Literal>
        </div>

        <!-- Empty Cart Panel -->
        <asp:Panel ID="EmptyCartPanel" runat="server" CssClass="cart-container" Visible="false">
            <div class="empty-cart">
                <i class="fas fa-shopping-cart"></i>
                <h2>Your cart is empty</h2>
                <p>Browse our menu and add some delicious items!</p>
                <a href="CustomerMenu.aspx" class="browse-menu-btn">Browse Menu</a>
            </div>
        </asp:Panel>

        <!-- Cart Items Panel -->
        <asp:Panel ID="CartItemsPanel" runat="server" CssClass="cart-container">
            <asp:Repeater ID="CartRepeater" runat="server">
                <HeaderTemplate>
                    <div class="cart-header">
                        <div class="cart-item-details">Item Details</div>
                        <div class="cart-item-price">Price</div>
                        <div class="cart-item-quantity">Quantity</div>
                        <div class="cart-item-total">Total</div>
                        <div class="cart-item-actions">Actions</div>
                    </div>
                </HeaderTemplate>
                <ItemTemplate>
                    <div class="cart-item">
                        <div class="cart-item-details">
                            <img src='<%# GetImageUrl(Eval("image").ToString()) %>' 
                                 alt='<%# Eval("name") %>' class="cart-item-image" 
                                 onerror="handleImageError(this)" />
                            <div class="cart-item-info">
                                <h3><%# Eval("name") %></h3>
                                <p class="item-description"><%# Eval("description") %></p>
                                <div class="item-meta">
                                    <span class="category-tag"><%# Eval("category") %></span>
                                    <span class="type-tag"><%# Eval("type") %></span>
                                </div>
                            </div>
                        </div>
                        <div class="cart-item-price">PHP <%# Format(CDec(Eval("price")), "0.00") %></div>
                        <div class="cart-item-quantity">
                            <div class="quantity-control">
                                <button type="button" class="quantity-btn minus" onclick="updateCartQuantity(this, '<%# Eval("cart_id") %>', -1)">-</button>
                                <input type="number" class="quantity-input" value='<%# Eval("quantity") %>' min="1" max="99" 
                                       onchange="updateCartQuantity(this, '<%# Eval("cart_id") %>', 0)" />
                                <button type="button" class="quantity-btn plus" onclick="updateCartQuantity(this, '<%# Eval("cart_id") %>', 1)">+</button>
                            </div>
                        </div>
                        <div class="cart-item-total">PHP <%# Format(CDec(Eval("price")) * CDec(Eval("quantity")), "0.00") %></div>
                        <div class="cart-item-actions">
                            <button type="button" class="remove-btn" onclick="removeCartItem('<%# Eval("cart_id") %>')">
                                <i class="fas fa-trash"></i>
                            </button>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

            <!-- Cart Summary Section -->
                    <div class="cart-footer">
                        <div class="cart-summary">
                            <div class="summary-row">
                                <span>Subtotal:</span>
                        <span class="summary-amount">PHP <asp:Literal ID="CartSummarySubtotalLiteral" runat="server"></asp:Literal></span>
                            </div>
                            <div class="summary-row">
                                <span>Total Items:</span>
                        <span class="summary-amount"><asp:Literal ID="CartSummaryItemsLiteral" runat="server"></asp:Literal></span>
                            </div>
                    <asp:Panel ID="DiscountRow" runat="server" Visible="false" CssClass="summary-row">
                        <span>Discount:</span>
                        <span class="summary-amount">-PHP <asp:Literal ID="DiscountAmountLiteral" runat="server"></asp:Literal></span>
                    </asp:Panel>
                    <asp:Panel ID="PromotionRow" runat="server" Visible="false" CssClass="summary-row">
                        <span>Promotion:</span>
                        <span class="summary-amount">-PHP <asp:Literal ID="PromotionAmountLiteral" runat="server"></asp:Literal></span>
                    </asp:Panel>
                    <asp:Panel ID="DealRow" runat="server" Visible="false" CssClass="summary-row">
                        <span>Deal:</span>
                        <span class="summary-amount">-PHP <asp:Literal ID="DealAmountLiteral" runat="server"></asp:Literal></span>
                    </asp:Panel>
                    <div class="summary-row total">
                        <span>Grand Total:</span>
                        <span class="summary-amount">PHP <asp:Literal ID="CartSummaryTotalLiteral" runat="server"></asp:Literal></span>
                        </div>
                    </div>
            </div>

            <!-- Options Container -->
            <div class="options-container">
                <!-- Order Summary Section -->
                <div class="order-summary-section">
                    <h4>Order Summary</h4>
                    <div class="order-summary">
                        <div class="summary-row">
                            <span>Subtotal:</span>
                            <span class="summary-amount">PHP <asp:Literal ID="OrderSummarySubtotalLiteral" runat="server"></asp:Literal></span>
                        </div>
                        <asp:Panel ID="OrderSummaryDiscountRow" runat="server" Visible="false" CssClass="summary-row">
                            <span>Discount:</span>
                            <span class="summary-amount">-PHP <asp:Literal ID="OrderSummaryDiscountLiteral" runat="server"></asp:Literal></span>
                        </asp:Panel>
                        <div class="summary-row">
                            <span>Delivery Fee:</span>
                            <span class="summary-amount delivery-fee">PHP <span id="deliveryFeeDisplay"><asp:Literal ID="DeliveryFeeLiteral" runat="server">0.00</asp:Literal></span></span>
                        </div>
                        <div class="summary-row delivery-info">
                            <span>Delivery Option:</span>
                            <span class="delivery-type" id="DeliveryTypeLiteral">Standard Delivery</span>
                        </div>
                        <div class="summary-row scheduled-time" id="ScheduledTimeRow" style="display: none;">
                            <span>Scheduled For:</span>
                            <span class="scheduled-time" id="ScheduledTimeLiteral"></span>
                        </div>
                        <div class="summary-row total">
                            <span>Total Amount:</span>
                            <span class="summary-amount">PHP <asp:Literal ID="OrderSummaryTotalLiteral" runat="server"></asp:Literal></span>
                        </div>
                    </div>
                </div>
                
                <!-- Promotions Section -->
                <div class="options-section promotions-section">
                    <h3>Active Promotions</h3>
                    <asp:Repeater ID="PromotionsRepeater" runat="server">
                        <ItemTemplate>
                            <div class="promotion-item">
                                <h4><%# Eval("name") %></h4>
                                <p><%# Eval("description") %></p>
                                <div class="promotion-details">
                                    <span class="promotion-value">
                                        <%# If(Convert.ToInt32(Eval("promotion_type")) = 1, 
                                            Eval("value") & "% off", 
                                            "PHP " & Format(Convert.ToDecimal(Eval("value")), "0.00") & " off") %>
                                    </span>
                                    <span class="promotion-period">
                                        Valid until <%# Format(Convert.ToDateTime(Eval("end_date")), "MMM dd, yyyy") %>
                                    </span>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>

                <!-- Deals Section -->
                <div class="options-section deals-section">
                    <h3>Special Deals</h3>
                    <asp:Repeater ID="DealsRepeater" runat="server">
                        <ItemTemplate>
                            <div class="deal-item">
                                <h4><%# Eval("name") %></h4>
                                <p><%# Eval("description") %></p>
                                <div class="deal-details">
                                    <span class="deal-value">
                                        <%# If(Convert.ToInt32(Eval("deal_type")) = 1, 
                                            Eval("value") & "% off", 
                                            "PHP " & Format(Convert.ToDecimal(Eval("value")), "0.00") & " off") %>
                                    </span>
                                    <span class="deal-period">
                                        Valid until <%# Format(Convert.ToDateTime(Eval("end_date")), "MMM dd, yyyy") %>
                                    </span>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>

                <!-- Discount Section -->
                <div class="options-section discount-section">
                    <h3>Apply Discount</h3>
                    <div class="discount-selector">
                        <asp:DropDownList ID="DiscountDropDown" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="DiscountDropDown_SelectedIndexChanged">
                            <asp:ListItem Text="-- Select a Discount --" Value="0" Selected="True"></asp:ListItem>
                        </asp:DropDownList>
                        <div class="discount-info" id="DiscountInfo" runat="server" visible="false">
                            <p><strong>Discount:</strong> <asp:Literal ID="DiscountNameLiteral" runat="server"></asp:Literal></p>
                            <p><asp:Literal ID="DiscountDescriptionLiteral" runat="server"></asp:Literal></p>
                            <p><strong>Value:</strong> <asp:Literal ID="DiscountValueLiteral" runat="server"></asp:Literal></p>
                            <button type="button" class="remove-discount-btn" onclick="removeDiscount()">Remove Discount</button>
                        </div>
                    </div>
                </div>
                
                <!-- Delivery Options Section -->
                <div class="options-section delivery-section">
                    <h3>Delivery Options</h3>
                    <div class="delivery-options">
                        <div class="delivery-option">
                            <input type="radio" id="standardDelivery" name="deliveryOption" value="standard" checked onclick="updateDeliveryOption('standard')" />
                            <label for="standardDelivery">
                                <span class="delivery-name">Standard Delivery</span>
                                <span class="delivery-info">Delivery within 45-60 minutes</span>
                                <span class="delivery-fee" id="standardFeeDisplay">Fee: PHP <strong><asp:Literal ID="StandardFeeLiteral" runat="server">50.00</asp:Literal></strong></span>
                            </label>
                        </div>
                        <div class="delivery-option">
                            <input type="radio" id="priorityDelivery" name="deliveryOption" value="priority" onclick="updateDeliveryOption('priority')" />
                            <label for="priorityDelivery">
                                <span class="delivery-name">Priority Delivery</span>
                                <span class="delivery-info">Express delivery within 25-30 minutes</span>
                                <span class="delivery-fee" id="priorityFeeDisplay">Fee: PHP <strong><asp:Literal ID="PriorityFeeLiteral" runat="server">75.00</asp:Literal></strong></span>
                            </label>
                        </div>
                        <div class="delivery-option">
                            <input type="radio" id="scheduledDelivery" name="deliveryOption" value="scheduled" onclick="updateDeliveryOption('scheduled')" />
                            <label for="scheduledDelivery">
                                <span class="delivery-name">Scheduled Delivery</span>
                                <span class="delivery-info">Choose your preferred delivery time</span>
                                <span class="delivery-fee" id="scheduledFeeDisplay">Fee: PHP <strong><asp:Literal ID="ScheduledFeeLiteral" runat="server">50.00</asp:Literal></strong></span>
                            </label>
                        </div>
                    </div>
                    
                    <!-- Scheduled Time Select (Initially Hidden) -->
                    <div id="scheduledTimeContainer" class="scheduled-time-container" style="display: none;">
                        <label for="scheduledTimeSelect">Select Delivery Time:</label>
                        <input type="datetime-local" id="scheduledTimeSelect" class="form-control" onchange="updateScheduledTime(this.value)" />
                        <p class="note">Note: Scheduled deliveries must be at least 2 hours in advance</p>
                    </div>
                    
                    <!-- Distance Display -->
                    <asp:Panel ID="calculatedDistanceDisplay" runat="server" Visible="false" CssClass="distance-display">
                        <p>Distance from restaurant: <span id="distanceText">calculating...</span></p>
                    </asp:Panel>
                </div>
                
                <!-- Payment Section -->
                <div class="payment-section">
                    <h4>Payment Method</h4>
                    <div class="payment-options">
                        <div class="payment-option">
                            <input type="radio" id="cashPayment" name="paymentMethod" value="cash" checked="checked" />
                            <label for="cashPayment">
                                <span class="payment-name">Cash on Delivery</span>
                            </label>
                        </div>
                        <div class="payment-option">
                            <input type="radio" id="gcashPayment" name="paymentMethod" value="gcash" />
                            <label for="gcashPayment">
                                <span class="payment-name">GCash</span>
                            </label>
                        </div>
                    </div>
                    
                    <!-- GCash Details (Initially Hidden) -->
                    <div id="gcashDetails" style="display: none;" class="gcash-details">
                        <div class="form-group">
                            <label for="referenceNumber">Reference Number:</label>
                            <input type="text" id="referenceNumber" class="form-control" />
                        </div>
                        <div class="form-group">
                            <label for="senderName">Sender Name:</label>
                            <input type="text" id="senderName" class="form-control" />
                        </div>
                        <div class="form-group">
                            <label for="senderNumber">Sender Number:</label>
                            <input type="text" id="senderNumber" class="form-control" />
                        </div>
                    </div>
                </div>
                
                <!-- Place Order Button -->
                <div class="place-order-section">
                    <asp:Button ID="PlaceOrderButton" runat="server" Text="Place Order" CssClass="btn btn-success" OnClick="PlaceOrderButton_Click" />
                </div>
            </div>

            <div class="cart-actions">
                <asp:Button ID="ClearCartButton" runat="server" Text="Clear Cart" CssClass="clear-cart-btn" OnClick="ClearCartButton_Click" OnClientClick="return confirm('Are you sure you want to clear your cart?');" />
            </div>
        </asp:Panel>
    </div>

    <!-- Loading Overlay -->
    <div class="loading-overlay">
        <div class="loading-spinner"></div>
    </div>

    <!-- Payment Dialog -->
    <div id="paymentDialog" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2>Select Payment Method</h2>
                <span class="close">&times;</span>
            </div>
            <div class="modal-body">
                <div class="payment-options">
                    <div class="payment-option">
                        <input type="radio" id="gcashOption" name="paymentMethod" value="gcash" onchange="toggleGcashFields()" />
                        <label for="gcashOption">
                            <img src="../../Assets/Images/gcash-logo.png" alt="GCash" class="payment-logo" onerror="handleImageError(this)" />
                            GCash
                        </label>
                    </div>
                    <div class="payment-option">
                        <input type="radio" id="cashOption" name="paymentMethod" value="cash" onchange="toggleGcashFields()" />
                        <label for="cashOption">
                            <img src="../../Assets/Images/cash-logo.png" alt="Cash" class="payment-logo" onerror="handleImageError(this)" />
                            Cash
                        </label>
                    </div>
                </div>

                <div id="gcashFields" style="display: none;">
                    <div class="form-group">
                        <label for="referenceNumber">Reference Number:</label>
                        <input type="text" id="referenceNumber" class="form-control" placeholder="Enter GCash reference number" />
                    </div>
                    <div class="form-group">
                        <label for="senderName">Sender Name:</label>
                        <input type="text" id="senderName" class="form-control" placeholder="Enter sender's name" />
                    </div>
                    <div class="form-group">
                        <label for="senderNumber">Sender Number:</label>
                        <input type="text" id="senderNumber" class="form-control" placeholder="Enter sender's number" />
                    </div>
                </div>

                <div class="order-summary">
                    <h3>Order Summary</h3>
                    <div class="summary-line">
                        <span>Subtotal:</span>
                        <span class="amount">PHP <asp:Literal ID="SubtotalLiteral" runat="server"></asp:Literal></span>
                    </div>
                    <div class="summary-line" id="PaymentDiscountRow" runat="server" visible="false">
                        <span>Discount:</span>
                        <span class="amount discount-amount">-PHP <asp:Literal ID="PaymentDiscountLiteral" runat="server"></asp:Literal></span>
                    </div>
                    <div class="summary-line">
                        <span>Delivery Fee:</span>
                        <span class="amount" id="PaymentDeliveryFeeLiteral">PHP 0.00</span>
                    </div>
                    <div class="summary-line">
                        <span>Total Items:</span>
                        <span class="amount"><asp:Literal ID="TotalItemsLiteral" runat="server"></asp:Literal></span>
                    </div>
                    <div class="summary-line delivery-info">
                        <span>Delivery Option:</span>
                        <span class="delivery-type" id="PaymentDeliveryTypeLiteral">Standard Delivery</span>
                    </div>
                    <div class="summary-line scheduled-time" id="PaymentScheduledTimeRow" style="display: none;">
                        <span>Scheduled For:</span>
                        <span class="scheduled-time" id="PaymentScheduledTimeLiteral"></span>
                    </div>
                    <div class="summary-line total">
                        <span>Total Amount:</span>
                        <span class="amount">PHP <asp:Literal ID="TotalAmountLiteral" runat="server"></asp:Literal></span>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn-secondary" onclick="closePaymentDialog()">Cancel</button>
                <button type="button" class="btn-primary" onclick="processPayment()">Confirm Payment</button>
            </div>
        </div>
    </div>

    <style type="text/css">
        .content-container {
            padding: 20px;
            max-width: 1200px;
            margin: 0 auto;
            width: 100%;
            box-sizing: border-box;
        }

        .content-header {
            margin-bottom: 30px;
            text-align: center;
        }

        .content-header h1 {
            color: #2C3E50;
            font-size: 32px;
            margin-bottom: 10px;
        }

        .content-header p {
            color: #666;
            font-size: 16px;
        }

        .cart-container {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }

        .cart-header {
            display: grid;
            grid-template-columns: 3fr 1fr 1fr 1fr 0.5fr;
            padding: 15px 20px;
            background: #f8f9fa;
            border-bottom: 1px solid #eee;
            font-weight: 600;
            color: #2C3E50;
        }

        .cart-item {
            display: grid;
            grid-template-columns: 3fr 1fr 1fr 1fr 0.5fr;
            padding: 20px;
            border-bottom: 1px solid #eee;
            align-items: center;
        }

        .cart-item-details {
            display: flex;
            gap: 20px;
        }

        .cart-item-image {
            width: 100px;
            height: 100px;
            object-fit: cover;
            border-radius: 8px;
        }

        .cart-item-info h3 {
            margin: 0 0 8px 0;
            color: #2C3E50;
            font-size: 18px;
        }

        .item-description {
            color: #666;
            font-size: 14px;
            margin-bottom: 8px;
        }

        .item-meta {
            display: flex;
            gap: 8px;
        }

        .category-tag, .type-tag {
            font-size: 12px;
            padding: 4px 8px;
            border-radius: 12px;
            background-color: #f0f0f0;
            color: #666;
        }

        .quantity-control {
            display: flex;
            align-items: center;
            gap: 8px;
            width: fit-content;
        }

        .quantity-btn {
            width: 32px;
            height: 32px;
            border: none;
            background-color: #619F2B;
            color: white;
            border-radius: 6px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
        }

        .quantity-btn:hover {
            background-color: #4F8022;
        }

        .quantity-input {
            width: 50px;
            height: 32px;
            text-align: center;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 14px;
        }

        .remove-btn {
            width: 32px;
            height: 32px;
            border: none;
            background-color: #dc3545;
            color: white;
            border-radius: 6px;
            cursor: pointer;
        }

        .remove-btn:hover {
            background-color: #c82333;
        }

        .cart-footer {
            padding: 20px;
            background: #f8f9fa;
        }

        .cart-summary {
            margin-bottom: 20px;
        }

        .summary-row {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            font-size: 16px;
            color: #2C3E50;
        }

        .summary-amount {
            font-weight: 600;
            color: #619F2B;
        }

        .cart-actions {
            display: flex;
            gap: 15px;
            justify-content: flex-end;
        }

        .clear-cart-btn, .checkout-btn {
            padding: 12px 24px;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .clear-cart-btn {
            background-color: #6c757d;
            color: white;
        }

        .clear-cart-btn:hover {
            background-color: #5a6268;
        }

        .checkout-btn {
            background-color: #619F2B;
            color: white;
        }

        .checkout-btn:hover {
            background-color: #4F8022;
        }

        .empty-cart {
            text-align: center;
            padding: 60px 20px;
            color: #666;
        }

        .empty-cart i {
            font-size: 64px;
            color: #ddd;
            margin-bottom: 20px;
        }

        .empty-cart h2 {
            margin-bottom: 10px;
            color: #2C3E50;
        }

        .browse-menu-btn {
            display: inline-block;
            margin-top: 20px;
            padding: 12px 24px;
            background-color: #619F2B;
            color: white;
            text-decoration: none;
            border-radius: 6px;
            transition: all 0.3s ease;
        }

        .browse-menu-btn:hover {
            background-color: #4F8022;
            transform: translateY(-2px);
        }

        .loading-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(255, 255, 255, 0.8);
            display: none;
            justify-content: center;
            align-items: center;
            z-index: 9999;
        }

        .loading-spinner {
            width: 50px;
            height: 50px;
            border: 4px solid #f3f3f3;
            border-top: 4px solid #619F2B;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        @media (max-width: 768px) {
            .cart-header {
                display: none;
            }

            .cart-item {
                grid-template-columns: 1fr;
                gap: 15px;
            }

            .cart-item-details {
                flex-direction: column;
            }

            .cart-item-image {
                width: 100%;
                height: 200px;
            }

            .cart-item-price,
            .cart-item-quantity,
            .cart-item-total {
                padding: 10px 0;
                border-top: 1px solid #eee;
            }

            .cart-item-actions {
                display: flex;
                justify-content: flex-end;
            }

            .cart-actions {
                flex-direction: column;
            }

            .clear-cart-btn,
            .checkout-btn {
                width: 100%;
            }
        }

        /* Payment Dialog Styles */
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            z-index: 1000;
        }

        .modal-content {
            position: relative;
            background-color: #fff;
            margin: 50px auto;
            padding: 0;
            width: 90%;
            max-width: 600px;
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .modal-header {
            padding: 20px;
            border-bottom: 1px solid #eee;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .modal-header h2 {
            margin: 0;
            color: #2C3E50;
            font-size: 24px;
        }

        .close {
            font-size: 28px;
            font-weight: bold;
            color: #666;
            cursor: pointer;
        }

        .close:hover {
            color: #000;
        }

        .modal-body {
            padding: 20px;
        }

        .payment-options {
            display: flex;
            gap: 20px;
            margin-bottom: 20px;
        }

        .payment-option {
            flex: 1;
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 15px;
            border: 2px solid #eee;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .payment-option:hover {
            border-color: #619F2B;
        }

        .payment-option input[type="radio"] {
            margin: 0;
        }

        .payment-option label {
            display: flex;
            align-items: center;
            gap: 10px;
            cursor: pointer;
            font-size: 16px;
            color: #2C3E50;
        }

        .payment-logo {
            width: 40px;
            height: 40px;
            object-fit: contain;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-group label {
            display: block;
            margin-bottom: 5px;
            color: #2C3E50;
            font-weight: 500;
        }

        .form-control {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 14px;
        }

        .form-control:focus {
            border-color: #619F2B;
            outline: none;
        }

        .order-summary {
            margin-top: 20px;
            padding: 15px;
            background-color: #f8f9fa;
            border-radius: 8px;
        }

        .order-summary h3 {
            margin: 0 0 15px 0;
            color: #2C3E50;
            font-size: 18px;
        }

        .summary-line {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
            color: #666;
        }

        .summary-line.total {
            margin-top: 15px;
            padding-top: 15px;
            border-top: 1px solid #ddd;
            font-weight: 600;
            color: #2C3E50;
        }

        .modal-footer {
            padding: 20px;
            border-top: 1px solid #eee;
            display: flex;
            justify-content: flex-end;
            gap: 10px;
        }

        .btn-primary, .btn-secondary {
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .btn-primary {
            background-color: #619F2B;
            color: white;
        }

        .btn-primary:hover {
            background-color: #4F8022;
        }

        .btn-secondary {
            background-color: #e9ecef;
            color: #2C3E50;
        }

        .btn-secondary:hover {
            background-color: #dde2e6;
        }

        @media (max-width: 768px) {
            .modal-content {
                margin: 20px;
                width: auto;
            }

            .payment-options {
                flex-direction: column;
            }

            .payment-option {
                width: 100%;
            }
        }

        /* Discount and Delivery Options Styles */
        .options-container {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            margin-top: 20px;
            margin-bottom: 20px;
        }

        .options-section {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            padding: 20px;
            flex: 1;
            min-width: 300px;
        }

        .options-section h3 {
            color: #2C3E50;
            margin-top: 0;
            margin-bottom: 15px;
            font-size: 18px;
            border-bottom: 1px solid #eee;
            padding-bottom: 10px;
        }

        /* Discount Styles */
        .discount-selector {
            margin-bottom: 15px;
        }

        .discount-info {
            background-color: #f8f9fa;
            border-radius: 6px;
            padding: 12px;
            margin-top: 10px;
        }

        .discount-info p {
            margin: 5px 0;
            font-size: 14px;
        }

        .remove-discount-btn {
            background-color: #e74c3c;
            color: white;
            border: none;
            padding: 6px 12px;
            border-radius: 4px;
            margin-top: 8px;
            cursor: pointer;
            font-size: 13px;
        }

        .remove-discount-btn:hover {
            background-color: #c0392b;
        }

        /* Delivery Options Styles */
        .delivery-options {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .delivery-option {
            display: flex;
            align-items: flex-start;
            border: 1px solid #e0e0e0;
            border-radius: 6px;
            padding: 12px;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .delivery-option:hover {
            border-color: #3498db;
            background-color: #f0f7fb;
        }

        .delivery-option input[type="radio"] {
            margin-top: 3px;
            margin-right: 10px;
        }

        .delivery-option label {
            display: flex;
            flex-direction: column;
            width: 100%;
            cursor: pointer;
        }

        .delivery-name {
            font-weight: bold;
            color: #2C3E50;
            margin-bottom: 4px;
        }

        .delivery-info {
            font-size: 13px;
            color: #7f8c8d;
            margin-bottom: 4px;
        }

        .delivery-fee {
            font-weight: bold;
            color: #e74c3c;
        }

        .scheduled-time-container {
            margin-top: 10px;
            padding: 10px;
            background-color: #f8f9fa;
            border-radius: 6px;
        }

        .scheduled-time-container input {
            margin: 10px 0;
        }

        .scheduled-time-container .note {
            font-size: 12px;
            color: #7f8c8d;
            font-style: italic;
        }

        /* Order Totals Styles */
        .order-totals {
            min-width: 300px;
        }

        .total-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 12px;
            font-size: 15px;
        }

        .grand-total {
            font-weight: bold;
            font-size: 18px;
            margin-top: 15px;
            padding-top: 15px;
            border-top: 1px solid #eee;
        }

        .discount-amount {
            color: #27ae60;
        }

        /* Responsive Styling */
        @media screen and (max-width: 768px) {
            .options-container {
                flex-direction: column;
            }
            
            .options-section {
                width: 100%;
            }
        }

        /* Address Selection Styles */
        .address-radio-list {
            margin-bottom: 20px;
        }
        
        .address-radio-list label {
            display: block;
            padding: 15px;
            margin-bottom: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .address-radio-list input[type="radio"] {
            margin-right: 10px;
        }
        
        .address-radio-list label:hover {
            border-color: #4CAF50;
            background-color: #f9f9f9;
        }
        
        .address-radio-list input[type="radio"]:checked + label {
            border-color: #4CAF50;
            background-color: #f0f9f0;
        }
        
        .address-actions {
            margin-top: 15px;
            margin-bottom: 20px;
        }
        
        /* New Address Form Styles */
        .new-address-form {
            background-color: #f9f9f9;
            padding: 20px;
            border-radius: 5px;
            margin-bottom: 20px;
            border: 1px solid #ddd;
        }
        
        .new-address-form h4 {
            margin-top: 0;
            margin-bottom: 15px;
            color: #4CAF50;
        }
        
        .form-group {
            margin-bottom: 15px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        
        .form-control {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        
        .default-address-checkbox {
            margin-top: 10px;
        }
        
        .address-form-actions {
            margin-top: 20px;
            display: flex;
            gap: 10px;
        }
        
        .text-danger {
            color: #ff0000;
            font-size: 12px;
            margin-top: 5px;
        }
    </style>

    <script type="text/javascript">
        function updateCartQuantity(element, cartId, change) {
            try {
                var input = element.tagName.toLowerCase() === 'input' ? element : element.parentElement.querySelector('.quantity-input');
                var currentValue = parseInt(input.value) || 1;
                var newValue = change === 0 ? currentValue : currentValue + change;
                
                // Ensure value is between 1 and 99
                newValue = Math.max(1, Math.min(99, newValue));
                
                // Show loading overlay
                document.querySelector('.loading-overlay').style.display = 'flex';

                // Call server-side method to update quantity
                PageMethods.UpdateCartQuantity(cartId, newValue, function(result) {
                    if (result.startsWith('Success')) {
                        // Refresh the page to show updated cart
                        location.reload();
                    } else {
                        // Show error message
                        showAlert(result, false);
                        // Reset the input value
                        input.value = currentValue;
                        // Hide loading overlay
                        document.querySelector('.loading-overlay').style.display = 'none';
                    }
                }, function(error) {
                    showAlert('Error updating quantity: ' + error.get_message(), false);
                    input.value = currentValue;
                    document.querySelector('.loading-overlay').style.display = 'none';
                });
            } catch (error) {
                console.error('Error updating quantity:', error);
                document.querySelector('.loading-overlay').style.display = 'none';
            }
        }

        function removeCartItem(cartId) {
            if (confirm('Are you sure you want to remove this item from your cart?')) {
                // Show loading overlay
                document.querySelector('.loading-overlay').style.display = 'flex';

                // Call server-side method to remove item
                PageMethods.RemoveCartItem(cartId, function(result) {
                    if (result.startsWith('Success')) {
                        // Refresh the page to show updated cart
                        location.reload();
                    } else {
                        // Show error message
                        showAlert(result, false);
                        // Hide loading overlay
                        document.querySelector('.loading-overlay').style.display = 'none';
                    }
                }, function(error) {
                    showAlert('Error removing item: ' + error.get_message(), false);
                    document.querySelector('.loading-overlay').style.display = 'none';
                });
            }
        }

        function showAlert(message, isSuccess) {
            var alertDiv = document.getElementById('<%= alertMessage.ClientID %>');
            var alertLiteral = document.getElementById('<%= AlertLiteral.ClientID %>');

            if (alertDiv && alertLiteral) {
                alertDiv.style.display = 'block';
                alertDiv.className = 'alert-message ' + (isSuccess ? 'alert-success' : 'alert-danger');
                alertLiteral.textContent = message;

                setTimeout(function() {
                    alertDiv.style.display = 'none';
                }, 3000);
            } else {
                alert(message);
            }
        }

        // Payment Dialog Functions
        function showPaymentDialog() {
            document.getElementById('paymentDialog').style.display = 'block';
            // Reset form
            document.getElementById('gcashOption').checked = false;
            document.getElementById('cashOption').checked = false;
            document.getElementById('gcashFields').style.display = 'none';
            if (document.getElementById('referenceNumber')) {
                document.getElementById('referenceNumber').value = '';
                document.getElementById('senderName').value = '';
                document.getElementById('senderNumber').value = '';
            }
        }

        function closePaymentDialog() {
            document.getElementById('paymentDialog').style.display = 'none';
        }

        function toggleGcashFields() {
            var gcashFields = document.getElementById('gcashFields');
            var isGcash = document.getElementById('gcashOption').checked;
            gcashFields.style.display = isGcash ? 'block' : 'none';
        }

        function updateDeliveryFee(fee) {
            document.getElementById('DeliveryFeeHidden').value = fee;
            document.getElementById('DeliveryFeeLiteral').textContent = 'PHP ' + fee.toFixed(2);
            updateGrandTotal();
        }
        
        function removeDiscount() {
            // Redirect to clear the discount
            window.location.href = '?removeDiscount=true';
        }
        
        // Override processPayment to include delivery and discount info
        function processPayment() {
            // Get selected payment method
            var paymentMethod = document.querySelector('input[name="paymentMethod"]:checked');
            if (!paymentMethod) {
                showAlert("Please select a payment method", "warning");
                return;
            }
            
            // Show loading spinner
            document.querySelector('.loading-overlay').style.display = 'flex';
            
            // Prepare payment data
            var paymentData = {
                method: paymentMethod.value,
                deliveryType: document.getElementById('<%= DeliveryTypeHidden.ClientID %>').value,
                deliveryFee: parseFloat(document.getElementById('<%= DeliveryFeeHidden.ClientID %>').value) || 0,
                discountId: parseInt(document.getElementById('<%= DiscountIdHidden.ClientID %>').value) || 0,
                scheduledTime: document.getElementById('<%= ScheduledTimeHidden.ClientID %>').value || null
            };
            
            // Add GCash details if selected
            if (paymentMethod.value === 'gcash') {
                var referenceNumber = document.getElementById('referenceNumber').value;
                var senderName = document.getElementById('senderName').value;
                var senderNumber = document.getElementById('senderNumber').value;
                
                if (!referenceNumber || !senderName || !senderNumber) {
                    document.querySelector('.loading-overlay').style.display = 'none';
                    showAlert("Please enter all GCash details", "warning");
                    return;
                }
                
                paymentData.referenceNumber = referenceNumber;
                paymentData.senderName = senderName;
                paymentData.senderNumber = senderNumber;
            }
            
            // Convert payment data to JSON
            var paymentDataJson = JSON.stringify(paymentData);
            
            // Call the server-side method using PageMethods
            PageMethods.ProcessPayment(paymentDataJson, processPaymentCallback, function(error) {
                document.querySelector('.loading-overlay').style.display = 'none';
                showAlert("Error processing payment: " + error.get_message(), "error");
            });
        }
        
        function processPaymentCallback(response) {
            // Hide loading spinner
            document.querySelector('.loading-overlay').style.display = 'none';
            
            if (response.startsWith("Success")) {
                showAlert(response, "success");
                closePaymentDialog();
                
                // Redirect to orders page after 3 seconds
                setTimeout(function() {
                    window.location.href = "CustomerOrders.aspx";
                }, 3000);
            } else {
                showAlert(response, "error");
            }
        }

        // Close modal when clicking outside
        window.onclick = function(event) {
            var modal = document.getElementById('paymentDialog');
            if (event.target == modal) {
                closePaymentDialog();
            }
        }

        // Delivery options functionality
        document.addEventListener('DOMContentLoaded', function() {
            // Initialize delivery options and totals
            updateDeliveryOption('standard');
            updateGrandTotal();
            
            // Load Google Maps API
            loadGoogleMaps();
            
            // Listen for delivery option changes
            document.querySelectorAll('input[name="deliveryOption"]').forEach(function(radio) {
                radio.addEventListener('change', function() {
                    updateDeliveryOption(this.value);
                });
            });

            // Listen for payment method changes
            document.querySelectorAll('input[name="paymentMethod"]').forEach(function(radio) {
                radio.addEventListener('change', function() {
                    if (this.value === 'gcash') {
                        toggleGCashDetails();
                    }
                });
            });
            
            // Address selection change listeners removed - functionality will be added later
        });
        
        function formatScheduledTime(dateTimeString) {
            const dateTime = new Date(dateTimeString);
            return dateTime.toLocaleString('en-US', { 
                weekday: 'short',
                month: 'short', 
                day: 'numeric', 
                year: 'numeric',
                hour: 'numeric', 
                minute: '2-digit',
                hour12: true
            });
        }

        function updateSelectedAddress(address) {
            document.getElementById('DeliveryAddressHidden').value = address;
        }

        function updateDeliveryOption(option) {
            try {
                console.log("==================== UPDATE DELIVERY OPTION ====================");
                console.log("Updating delivery option to: " + option);
                var deliveryType = option;
                var deliveryFee = 0;
                
                // Get the distance from hidden field
                var distance = parseFloat(document.getElementById('<%= DistanceHidden.ClientID %>').value) || 0;
                console.log("Distance from hidden field: " + distance);
                
                // Calculate base fee based on distance
                var baseFee = calculateBaseFee(distance);
                console.log("Base fee calculated: " + baseFee);
                
                // Set the fee based on the delivery type
                if (option === 'priority') {
                    deliveryFee = Math.ceil(baseFee * 1.5);
                    console.log("Setting priority fee (1.5x): " + deliveryFee);
                } else if (option === 'scheduled') {
                    deliveryFee = baseFee;
                    console.log("Setting scheduled fee: " + deliveryFee);
                    document.getElementById('scheduledTimeContainer').style.display = 'block';
                } else {
                    // Standard delivery
                    deliveryFee = baseFee;
                    console.log("Setting standard fee: " + deliveryFee);
                    document.getElementById('scheduledTimeContainer').style.display = 'none';
                }
                
                // Format the fee for display
                var formattedFee = deliveryFee.toFixed(2);
                console.log("Setting delivery fee to: " + formattedFee);
                
                // Update hidden field for delivery type
                document.getElementById('<%= DeliveryTypeHidden.ClientID %>').value = option;
                
                // Update delivery fee hidden field - CRITICAL PART
                var deliveryFeeHidden = document.getElementById('<%= DeliveryFeeHidden.ClientID %>');
                if (deliveryFeeHidden) {
                    // Store original value for comparison
                    var oldValue = deliveryFeeHidden.value;
                    
                    // Set the new value
                    deliveryFeeHidden.value = formattedFee;
                    
                    // Log the change for debugging
                    console.log("DeliveryFeeHidden value changed from: " + oldValue + " to: " + deliveryFeeHidden.value);
                    
                    // Display an alert for testing
                    alert("Delivery Fee Changed: " + oldValue + " → " + formattedFee + "\nCheck if this updates in your Order Summary.");
                } else {
                    console.error("Could not find DeliveryFeeHidden element!");
                    alert("ERROR: Could not find DeliveryFeeHidden element!");
                }
                
                // Directly update the delivery fee display text
                var deliveryFeeDisplay = document.getElementById('deliveryFeeDisplay');
                if (deliveryFeeDisplay) {
                    deliveryFeeDisplay.textContent = formattedFee;
                    console.log("Updated deliveryFeeDisplay to: " + formattedFee);
                } else {
                    console.error("Could not find deliveryFeeDisplay element!");
                }
                
                // Update delivery type in order summary
                var deliveryTypeName = '';
                switch(option) {
                    case 'priority':
                        deliveryTypeName = 'Priority Delivery';
                        break;
                    case 'scheduled':
                        deliveryTypeName = 'Scheduled Delivery';
                        break;
                    default:
                        deliveryTypeName = 'Standard Delivery';
                }
                
                var deliveryTypeElement = document.getElementById('DeliveryTypeLiteral');
                if (deliveryTypeElement) {
                    deliveryTypeElement.textContent = deliveryTypeName;
                    console.log("Updated DeliveryTypeLiteral to: " + deliveryTypeName);
                } else {
                    console.error("Could not find DeliveryTypeLiteral element!");
                }
                
                // Show/hide scheduled time row in order summary
                var scheduledTimeRow = document.getElementById('ScheduledTimeRow');
                if (scheduledTimeRow) {
                    scheduledTimeRow.style.display = option === 'scheduled' ? 'flex' : 'none';
                }
                
                // Update the total amount
                console.log("Calling updateGrandTotal to update the totals...");
                updateGrandTotal();
                
                console.log("Delivery option update complete");
                console.log("==================== END UPDATE DELIVERY OPTION ====================");
            } catch (error) {
                console.error("Error in updateDeliveryOption:", error);
                alert("Error in updateDeliveryOption: " + error.message);
            }
        }

        // Calculate base delivery fee based on distance
        function calculateBaseFee(distance) {
            // Base delivery fee calculation
            var baseFee = 50; // Minimum delivery fee
            
            if (distance > 0) {
                // Add additional fee based on distance
                if (distance <= 3) {
                    // Up to 3 km: base fee only
                    baseFee = 50;
                } else if (distance <= 5) {
                    // 3-5 km: base fee + 10 per km over 3
                    baseFee = 50 + (Math.ceil(distance - 3) * 10);
                } else if (distance <= 10) {
                    // 5-10 km: 70 + 15 per km over 5
                    baseFee = 70 + (Math.ceil(distance - 5) * 15);
                } else {
                    // Over 10 km: 145 + 20 per km over 10
                    baseFee = 145 + (Math.ceil(distance - 10) * 20);
                }
            }
            
            return baseFee;
        }

        function showNewAddressForm() {
            // This functionality will be implemented when the address system is added
            console.log("New address form functionality will be added later");
        }

        function hideNewAddressForm() {
            // This functionality will be implemented when the address system is added
            console.log("New address form functionality will be added later");
        }

        function toggleScheduledTime() {
            var scheduledDelivery = document.getElementById('scheduledDelivery');
            var container = document.getElementById('scheduledTimeContainer');
            container.style.display = scheduledDelivery.checked ? 'block' : 'none';
        }

        function toggleGCashDetails() {
            var gcashPayment = document.getElementById('gcashPayment');
            var details = document.getElementById('gcashDetails');
            details.style.display = gcashPayment.checked ? 'block' : 'none';
        }

        // Add a function to handle image loading errors
        function handleImageError(img) {
            // If the image fails to load, use a default image or hide it
            img.onerror = null; // Prevent infinite loop
            img.src = '<%=ResolveUrl("~/Assets/Images/default-food.jpg") %>'; // Use an existing default image
        }

        // Load Google Maps API asynchronously
        function loadGoogleMaps() {
            var script = document.createElement('script');
            script.src = 'https://maps.googleapis.com/maps/api/js?key=YOUR_API_KEY&callback=initializeGeocoder';
            script.async = true;
            script.defer = true;
            document.body.appendChild(script);
        }
        
        // Initialize geocoder when Google Maps API loads
        function initializeGeocoder() {
            window.geocoder = new google.maps.Geocoder();
            
            // Try to calculate distance when geocoder is initialized
            calculateDistanceFromSelectedAddress();
        }
        
        // Calculate distance when address is selected (modified to avoid errors)
        function calculateDistanceFromSelectedAddress() {
            // This function will be implemented when address selection is added
            console.log("Address selection functionality will be added later");
        }
        
        // Calculate distance from coordinates and update fees
        function calculateDistanceFromCoordinates(lat2, lng2) {
            try {
                // Get restaurant coordinates
                var restaurantCoords = document.getElementById('<%= RestaurantLocationHidden.ClientID %>').value.split(',');
                var lat1 = parseFloat(restaurantCoords[0]);
                var lng1 = parseFloat(restaurantCoords[1]);
                
                if (isNaN(lat1) || isNaN(lng1) || isNaN(lat2) || isNaN(lng2)) {
                    console.error("Invalid coordinates for distance calculation");
                    document.getElementById('distanceText').textContent = 'Invalid coordinates';
                    return;
                }
                
                // Calculate distance using Haversine formula
                var R = 6371; // Radius of the Earth in km
                var dLat = (lat2 - lat1) * Math.PI / 180;
                var dLng = (lng2 - lng1) * Math.PI / 180;
                var a = 
                    Math.sin(dLat/2) * Math.sin(dLat/2) +
                    Math.cos(lat1 * Math.PI / 180) * Math.cos(lat2 * Math.PI / 180) * 
                    Math.sin(dLng/2) * Math.sin(dLng/2);
                var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
                var distance = R * c; // Distance in km
                
                // Update distance display
                document.getElementById('distanceText').textContent = distance.toFixed(2) + ' km';
                document.getElementById('<%= calculatedDistanceDisplay.ClientID %>').style.display = 'block';
                
                // Update distance hidden field
                document.getElementById('<%= DistanceHidden.ClientID %>').value = distance.toFixed(2);
                
                // Calculate and update delivery fees
                updateDeliveryFees(distance);
                
                console.log("Distance calculated: " + distance.toFixed(2) + " km");
            } catch (e) {
                console.error("Error calculating distance: ", e);
                document.getElementById('distanceText').textContent = 'Error calculating distance';
            }
        }
        
        // Calculate distance based on coordinates
        function calculateDistance(lat2, lng2) {
            try {
                // Get restaurant coordinates
                var restaurantCoords = document.getElementById('<%= RestaurantLocationHidden.ClientID %>').value.split(',');
                var lat1 = parseFloat(restaurantCoords[0]);
                var lng1 = parseFloat(restaurantCoords[1]);
                
                if (isNaN(lat1) || isNaN(lng1) || isNaN(lat2) || isNaN(lng2)) {
                    console.error("Invalid coordinates for distance calculation");
                    document.getElementById('distanceText').textContent = 'Invalid coordinates';
                    return 0;
                }
                
                // Calculate distance using Haversine formula
                var R = 6371; // Radius of the Earth in km
                var dLat = (lat2 - lat1) * Math.PI / 180;
                var dLng = (lng2 - lng1) * Math.PI / 180;
                var a = 
                    Math.sin(dLat/2) * Math.sin(dLat/2) +
                    Math.cos(lat1 * Math.PI / 180) * Math.cos(lat2 * Math.PI / 180) * 
                    Math.sin(dLng/2) * Math.sin(dLng/2);
                var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
                var distance = R * c; // Distance in km
                
                // Show the calculated distance display
                document.getElementById('<%= calculatedDistanceDisplay.ClientID %>').style.display = 'block';
                document.getElementById('distanceText').textContent = distance.toFixed(2) + ' km';
                
                console.log("Distance calculated: " + distance.toFixed(2) + " km");
                return distance;
            } catch (e) {
                console.error("Error in calculateDistance: ", e);
                document.getElementById('distanceText').textContent = 'Error calculating distance';
                return 0;
            }
        }
        
        // Update all delivery fee options based on distance
        function updateDeliveryFees(distance) {
            try {
                // Base fee calculation
                var baseFee = calculateDeliveryFee(distance);
                
                // Priority delivery is 1.5x the standard fee
                var priorityFee = Math.ceil(baseFee * 1.5);
                
                // Update fee displays
                document.getElementById('<%= StandardFeeLiteral.ClientID %>').textContent = baseFee.toFixed(2);
                document.getElementById('standardFeeDisplay').innerHTML = 'Fee: PHP <strong>' + baseFee.toFixed(2) + '</strong>';
                
                document.getElementById('<%= PriorityFeeLiteral.ClientID %>').textContent = priorityFee.toFixed(2);
                document.getElementById('priorityFeeDisplay').innerHTML = 'Fee: PHP <strong>' + priorityFee.toFixed(2) + '</strong>';
                
                document.getElementById('<%= ScheduledFeeLiteral.ClientID %>').textContent = baseFee.toFixed(2);
                document.getElementById('scheduledFeeDisplay').innerHTML = 'Fee: PHP <strong>' + baseFee.toFixed(2) + '</strong>';
                
                // Update the currently selected option
                var selectedOption = document.querySelector('input[name="deliveryOption"]:checked');
                if (selectedOption) {
                    updateDeliveryOption(selectedOption.value);
                } else {
                    // Default to standard if none selected
                    document.getElementById('standardDelivery').checked = true;
                    updateDeliveryOption('standard');
                }
                
                console.log("Delivery fees updated based on distance: " + distance.toFixed(2) + " km");
            } catch (e) {
                console.error("Error updating delivery fees: ", e);
            }
        }
        
        // Calculate delivery fee based on distance
        function calculateDeliveryFee(distance) {
            var baseFee = 0;
            
            // For distances less than 1 km
            if (distance <= 1) {
                baseFee = 20;
            } 
            // For distances between 1-3 km
            else if (distance <= 3) {
                baseFee = 40;
            }
            // For distances between 3-5 km
            else if (distance <= 5) {
                baseFee = 60;
            }
            // For distances between 5-8 km
            else if (distance <= 8) {
                baseFee = 80;
            }
            // For distances over 8 km
            else {
                baseFee = 100 + Math.ceil(distance - 8) * 10; // Additional 10 pesos per km beyond 8 km
            }
            
            return baseFee;
        }
        
        // Update selected delivery option and fee
        function updateDeliveryOption(option) {
            console.log("==================== UPDATE DELIVERY OPTION ====================");
            console.log("Updating delivery option to: " + option);
            var deliveryType = option;
            var deliveryFee = 0;
            
            // Get the distance from hidden field
            var distance = parseFloat(document.getElementById('<%= DistanceHidden.ClientID %>').value) || 0;
            console.log("Distance from hidden field: " + distance);
            
            // Calculate base fee based on distance
            var baseFee = calculateBaseFee(distance);
            console.log("Base fee calculated: " + baseFee);
            
            // Set the fee based on the delivery type
            if (option === 'priority') {
                deliveryFee = Math.ceil(baseFee * 1.5);
                console.log("Setting priority fee (1.5x): " + deliveryFee);
            } else if (option === 'scheduled') {
                deliveryFee = baseFee;
                console.log("Setting scheduled fee: " + deliveryFee);
                document.getElementById('scheduledTimeContainer').style.display = 'block';
            } else {
                // Standard delivery
                deliveryFee = baseFee;
                console.log("Setting standard fee: " + deliveryFee);
                document.getElementById('scheduledTimeContainer').style.display = 'none';
            }
            
            // Format the fee for display
            var formattedFee = deliveryFee.toFixed(2);
            console.log("Setting delivery fee to: " + formattedFee);
            
            // Update hidden field for delivery type
            document.getElementById('<%= DeliveryTypeHidden.ClientID %>').value = option;
            
            // Update delivery fee hidden field - CRITICAL PART
            var deliveryFeeHidden = document.getElementById('<%= DeliveryFeeHidden.ClientID %>');
            if (deliveryFeeHidden) {
                // Store original value for comparison
                var oldValue = deliveryFeeHidden.value;
                
                // Set the new value
                deliveryFeeHidden.value = formattedFee;
                
                // Log the change for debugging
                console.log("DeliveryFeeHidden value changed from: " + oldValue + " to: " + deliveryFeeHidden.value);
                
                // Display an alert for testing
                alert("Delivery Fee Changed: " + oldValue + " → " + formattedFee + "\nCheck if this updates in your Order Summary.");
            } else {
                console.error("Could not find DeliveryFeeHidden element!");
                alert("ERROR: Could not find DeliveryFeeHidden element!");
            }
            
            // Directly update the delivery fee display text
            var deliveryFeeDisplay = document.getElementById('deliveryFeeDisplay');
            if (deliveryFeeDisplay) {
                deliveryFeeDisplay.textContent = formattedFee;
                console.log("Updated deliveryFeeDisplay to: " + formattedFee);
            } else {
                console.error("Could not find deliveryFeeDisplay element!");
            }
            
            // Update delivery type in order summary
            var deliveryTypeName = '';
            switch(option) {
                case 'priority':
                    deliveryTypeName = 'Priority Delivery';
                    break;
                case 'scheduled':
                    deliveryTypeName = 'Scheduled Delivery';
                    break;
                default:
                    deliveryTypeName = 'Standard Delivery';
            }
            
            var deliveryTypeElement = document.getElementById('DeliveryTypeLiteral');
            if (deliveryTypeElement) {
                deliveryTypeElement.textContent = deliveryTypeName;
                console.log("Updated DeliveryTypeLiteral to: " + deliveryTypeName);
            } else {
                console.error("Could not find DeliveryTypeLiteral element!");
            }
            
            // Show/hide scheduled time row in order summary
            var scheduledTimeRow = document.getElementById('ScheduledTimeRow');
            if (scheduledTimeRow) {
                scheduledTimeRow.style.display = option === 'scheduled' ? 'flex' : 'none';
            }
            
            // Update the total amount
            console.log("Calling updateGrandTotal to update the totals...");
            updateGrandTotal();
            
            console.log("Delivery option update complete");
            console.log("==================== END UPDATE DELIVERY OPTION ====================");
        }

        // New function to update address coordinates from city dropdown
        function updateAddressCoordinates() {
            // This functionality will be implemented when the address system is added
            console.log("City selection functionality will be added later");
        }

        // Update scheduled time
        function updateScheduledTime(timeValue) {
            // Store scheduled time in hidden field
            document.getElementById('<%= ScheduledTimeHidden.ClientID %>').value = timeValue;
            
            // Update the displayed scheduled time in order summary
            var formattedTime = formatScheduledTime(timeValue);
            document.getElementById('ScheduledTimeLiteral').innerText = formattedTime;
            
            // Make sure the scheduled time row is visible
            document.getElementById('ScheduledTimeRow').style.display = 'flex';
        }

        // Initialize delivery fee and order summary with stronger measures
        document.addEventListener("DOMContentLoaded", function() {
            console.log("DOM loaded - initializing delivery options");
            
            // Ensure the standard delivery option is selected
            var standardDelivery = document.getElementById('standardDelivery');
            if (standardDelivery) {
                standardDelivery.checked = true;
            }
            
            // Set default delivery fee
            var deliveryFeeHidden = document.getElementById('<%= DeliveryFeeHidden.ClientID %>');
            if (deliveryFeeHidden) {
                deliveryFeeHidden.value = "50.00";
                console.log("Set DeliveryFeeHidden value to 50.00");
            }
            
            // Update delivery fee display in order summary
            var deliveryFeeDisplay = document.getElementById('deliveryFeeDisplay');
            if (deliveryFeeDisplay) {
                deliveryFeeDisplay.textContent = "50.00";
                console.log("Set deliveryFeeDisplay text to 50.00");
            }
            
            // Make sure the delivery type is correctly set
            var deliveryTypeHidden = document.getElementById('<%= DeliveryTypeHidden.ClientID %>');
            if (deliveryTypeHidden) {
                deliveryTypeHidden.value = "standard";
            }
            
            // Force immediate update by calling the update function directly
            updateDeliveryOption('standard');
            
            // Make sure grand total is also updated
            setTimeout(function() {
                console.log("Running delayed updateGrandTotal");
                updateGrandTotal();
            }, 500);
        });

        function updateGrandTotal() {
            try {
                console.log("==================== UPDATE GRAND TOTAL ====================");
                console.log("updateGrandTotal called");
                
                // Get subtotal from the cart summary
                var subtotalElement = document.getElementById('<%= CartSummarySubtotalLiteral.ClientID %>');
                var subtotal = parseFloat(subtotalElement ? subtotalElement.textContent : 0);
                if (isNaN(subtotal)) subtotal = 0;
                console.log("Subtotal: " + subtotal);
                
                // Get discount if applicable
                var discount = 0;
                var discountRow = document.getElementById('<%= DiscountRow.ClientID %>');
                if (discountRow && window.getComputedStyle(discountRow).display !== 'none') {
                    var discountElement = document.getElementById('<%= DiscountAmountLiteral.ClientID %>');
                    var discountText = discountElement ? discountElement.textContent : '0';
                    discount = parseFloat(discountText);
                    if (isNaN(discount)) discount = 0;
                }
                console.log("Discount: " + discount);
                
                // Get promotion discount if applicable
                var promotionDiscount = 0;
                var promotionRow = document.getElementById('<%= PromotionRow.ClientID %>');
                if (promotionRow && window.getComputedStyle(promotionRow).display !== 'none') {
                    var promotionElement = document.getElementById('<%= PromotionAmountLiteral.ClientID %>');
                    var promotionText = promotionElement ? promotionElement.textContent : '0';
                    promotionDiscount = parseFloat(promotionText);
                    if (isNaN(promotionDiscount)) promotionDiscount = 0;
                }
                console.log("Promotion discount: " + promotionDiscount);
                
                // Get deal discount if applicable
                var dealDiscount = 0;
                var dealRow = document.getElementById('<%= DealRow.ClientID %>');
                if (dealRow && window.getComputedStyle(dealRow).display !== 'none') {
                    var dealElement = document.getElementById('<%= DealAmountLiteral.ClientID %>');
                    var dealText = dealElement ? dealElement.textContent : '0';
                    dealDiscount = parseFloat(dealText);
                    if (isNaN(dealDiscount)) dealDiscount = 0;
                }
                console.log("Deal discount: " + dealDiscount);
                
                // Get delivery fee from hidden field - THIS IS THE KEY CHANGE
                var deliveryFeeHidden = document.getElementById('<%= DeliveryFeeHidden.ClientID %>');
                
                // Debug the value of the hidden field
                console.log("DeliveryFeeHidden value (raw): " + (deliveryFeeHidden ? deliveryFeeHidden.value : "not found"));
                
                var deliveryFee = parseFloat(deliveryFeeHidden ? deliveryFeeHidden.value : 0);
                if (isNaN(deliveryFee)) {
                    console.log("DeliveryFeeHidden value is not a number, using default 50.00");
                    deliveryFee = 50.00;
                }
                console.log("Delivery fee (parsed): " + deliveryFee);
                
                // Make sure the delivery fee display is up to date
                var deliveryFeeDisplay = document.getElementById('deliveryFeeDisplay');
                if (deliveryFeeDisplay) {
                    deliveryFeeDisplay.textContent = deliveryFee.toFixed(2);
                    console.log("Updated deliveryFeeDisplay in updateGrandTotal: " + deliveryFee.toFixed(2));
            } else {
                    console.error("Could not find deliveryFeeDisplay element!");
                }
                
                // Calculate grand total with detailed logging
                console.log("Grand total calculation: " + subtotal + " - " + discount + " - " + promotionDiscount + " - " + dealDiscount + " + " + deliveryFee);
                var grandTotal = subtotal - discount - promotionDiscount - dealDiscount + deliveryFee;
                if (grandTotal < 0) grandTotal = 0; // Ensure the total isn't negative
                console.log("Grand total (calculated): " + grandTotal.toFixed(2));
                
                // Show calculation in alert for testing
                var calculationString = "Subtotal: " + subtotal.toFixed(2) + "\n" +
                                        "- Discount: " + discount.toFixed(2) + "\n" +
                                        "- Promotion: " + promotionDiscount.toFixed(2) + "\n" +
                                        "- Deal: " + dealDiscount.toFixed(2) + "\n" +
                                        "+ Delivery Fee: " + deliveryFee.toFixed(2) + "\n" +
                                        "= Grand Total: " + grandTotal.toFixed(2);
                alert("Order Summary Calculation:\n" + calculationString);
                
                // Update the cart summary total
                var cartSummaryTotal = document.getElementById('<%= CartSummaryTotalLiteral.ClientID %>');
                if (cartSummaryTotal) {
                    cartSummaryTotal.textContent = grandTotal.toFixed(2);
                    console.log("Updated CartSummaryTotalLiteral to: " + grandTotal.toFixed(2));
                } else {
                    console.error("Could not find CartSummaryTotalLiteral element!");
                }
                
                // Update the order summary fields
                var orderSummarySubtotal = document.getElementById('<%= OrderSummarySubtotalLiteral.ClientID %>');
                if (orderSummarySubtotal) {
                    orderSummarySubtotal.textContent = subtotal.toFixed(2);
                    console.log("Updated OrderSummarySubtotalLiteral to: " + subtotal.toFixed(2));
                } else {
                    console.error("Could not find OrderSummarySubtotalLiteral element!");
                }
                
                var orderSummaryDiscount = document.getElementById('<%= OrderSummaryDiscountLiteral.ClientID %>');
                if (orderSummaryDiscount) {
                    orderSummaryDiscount.textContent = discount.toFixed(2);
                    console.log("Updated OrderSummaryDiscountLiteral to: " + discount.toFixed(2));
                    // Show/hide the discount row
                    var orderDiscountRow = document.getElementById('<%= OrderSummaryDiscountRow.ClientID %>');
                    if (orderDiscountRow) {
                        orderDiscountRow.style.display = discount > 0 ? 'flex' : 'none';
                    }
                } else {
                    console.error("Could not find OrderSummaryDiscountLiteral element!");
                }
                
                // Update the total amount in order summary
                var orderSummaryTotal = document.getElementById('<%= OrderSummaryTotalLiteral.ClientID %>');
                if (orderSummaryTotal) {
                    orderSummaryTotal.textContent = grandTotal.toFixed(2);
                    console.log("Updated OrderSummaryTotalLiteral to: " + grandTotal.toFixed(2));
                } else {
                    console.error("Could not find OrderSummaryTotalLiteral element!");
                }
                
                console.log("Order summary updated successfully");
                console.log("==================== END UPDATE GRAND TOTAL ====================");
            } catch (e) {
                console.error("Error updating grand total: ", e);
                alert("Error in updateGrandTotal: " + e.message);
            }
        }
    </script>
</asp:Content>
