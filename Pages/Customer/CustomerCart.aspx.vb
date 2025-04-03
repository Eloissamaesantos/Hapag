Imports System.Data
Imports System.Web.Services
Imports System.Web.Script.Serialization
Imports System.Data.SqlClient
Imports Newtonsoft.Json

' Define the Discount class
Public Class Discount
    Public Property DiscountId As Integer
    Public Property Name As String
    Public Property DiscountType As Integer
    Public Property Value As Decimal
    Public Property Description As String

    Public Sub New(id As Integer, name As String, type As Integer, value As Decimal, description As String)
        DiscountId = id
        Name = name
        DiscountType = type
        Value = value
        Description = description
    End Sub
End Class

Partial Class Pages_Customer_CustomerCart
    Inherits System.Web.UI.Page
    Dim Connect As New Connection()

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            If Not IsPostBack Then
                ' Check if user is logged in
                If Session("CURRENT_SESSION") Is Nothing Then
                    Response.Redirect("~/Pages/LoginPortal/CustomerLoginPortal.aspx")
                End If

                ' Check if remove discount parameter exists
                If Not String.IsNullOrEmpty(Request.QueryString("removeDiscount")) Then
                    Session("SelectedDiscountId") = Nothing
                    Response.Redirect("CustomerCart.aspx")
                    Return
                End If

                ' Initialize hidden fields and panels
                DeliveryOptionsPanel.Visible = False
                NewAddressPanel.Visible = False

                ' Load cart items
                LoadCartItems()
                
                ' Load available discounts
                LoadAvailableDiscounts()
                
                ' Load promotions and deals
                LoadPromotions()
                LoadDeals()
                
                ApplySelectedDiscount()
                
                ' Update the order summary
                UpdateOrderSummary()
            End If
        Catch ex As Exception
            ' Log the error but continue
            System.Diagnostics.Debug.WriteLine("Error on Page_Load: " & ex.Message)
        End Try
    End Sub

    Private Sub UpdateOrderSummary()
        Try
            Dim subtotal As Decimal = GetCartTotal()
            Dim selectedDiscount As Discount = Session("SelectedDiscount")
            
            ' Set the values in the UI
            CartSummarySubtotalLiteral.Text = Format(subtotal, "0.00")
            CartSummaryItemsLiteral.Text = GetTotalItems().ToString()
            
            ' Update discount row if a discount is applied
            If selectedDiscount IsNot Nothing Then
                DiscountRow.Visible = True
                DiscountAmountLiteral.Text = Format(selectedDiscount.Value, "0.00")
                DiscountNameLiteral.Text = selectedDiscount.Name
                DiscountDescriptionLiteral.Text = selectedDiscount.Description
                DiscountValueLiteral.Text = If(selectedDiscount.DiscountType = 1, 
                    selectedDiscount.Value & "%", 
                    "PHP " & Format(selectedDiscount.Value, "0.00"))
                DiscountInfo.Visible = True
                
                ' Store discount information in hidden fields
                DiscountIdHidden.Value = selectedDiscount.DiscountId.ToString()
                DiscountValueHidden.Value = selectedDiscount.Value.ToString()
            Else
                DiscountRow.Visible = False
                DiscountInfo.Visible = False
                DiscountIdHidden.Value = "0"
                DiscountValueHidden.Value = "0"
            End If
            
            ' Update promotion row if a promotion is applied
            Dim promotionAmount As Decimal = GetAppliedPromotionAmount(subtotal)
            If promotionAmount > 0 Then
                PromotionRow.Visible = True
                PromotionAmountLiteral.Text = Format(promotionAmount, "0.00")
            Else
                PromotionRow.Visible = False
            End If
            
            ' Update deal row if a deal is applied
            Dim dealAmount As Decimal = GetAppliedDealAmount(subtotal)
            If dealAmount > 0 Then
                DealRow.Visible = True
                DealAmountLiteral.Text = Format(dealAmount, "0.00")
            Else
                DealRow.Visible = False
            End If
            
            ' Calculate and display grand total
            Dim grandTotal As Decimal = subtotal
            If selectedDiscount IsNot Nothing Then
                grandTotal -= selectedDiscount.Value
            End If
            grandTotal -= promotionAmount
            grandTotal -= dealAmount
            grandTotal += Convert.ToDecimal(DeliveryFeeHidden.Value)
            
            CartSummaryTotalLiteral.Text = Format(grandTotal, "0.00")
            
        Catch ex As Exception
            ShowAlert("Error updating order summary: " & ex.Message, False)
        End Try
    End Sub

    Private Sub LoadAvailableDiscounts()
        Try
            ' Clear any existing items
            DiscountDropDown.Items.Clear()
            ' Add the default option
            DiscountDropDown.Items.Add(New ListItem("-- Select a Discount --", "0"))
            
            ' Get the cart total to check against min_order_amount
            Dim cartTotal As Decimal = GetCartTotal()
            
            ' Get active discounts where current date is between start_date and end_date
            ' and min_order_amount is met by the cart total
            Dim query As String = "SELECT discount_id, name, discount_type, value, description " & _
                                 "FROM discounts " & _
                                 "WHERE status = 1 " & _
                                 "AND GETDATE() BETWEEN start_date AND end_date " & _
                                 "AND (min_order_amount IS NULL OR min_order_amount <= @cart_total) " & _
                                 "ORDER BY value DESC"
            
            Connect.ClearParams()
            Connect.AddParam("@cart_total", cartTotal)
            Connect.Query(query)
            
            If Connect.DataCount > 0 Then
                For Each row As DataRow In Connect.Data.Tables(0).Rows
                    Dim discountId As Integer = Convert.ToInt32(row("discount_id"))
                    Dim discountName As String = row("name").ToString()
                    Dim discountType As Integer = Convert.ToInt32(row("discount_type"))
                    Dim discountValue As Decimal = Convert.ToDecimal(row("value"))
                    
                    ' Format the display text
                    Dim displayText As String = discountName
                    If discountType = 1 Then ' Percentage discount
                        displayText &= " (" & discountValue & "%)"
                    Else ' Fixed amount discount
                        displayText &= " (PHP " & Format(discountValue, "0.00") & ")"
                    End If
                    
                    DiscountDropDown.Items.Add(New ListItem(displayText, discountId.ToString()))
                Next
            End If
            
            ' Restore selected discount if it exists in the session
            If Session("SelectedDiscountId") IsNot Nothing Then
                Dim selectedDiscountId As String = Session("SelectedDiscountId").ToString()
                Dim foundItem As ListItem = DiscountDropDown.Items.FindByValue(selectedDiscountId)
                If foundItem IsNot Nothing Then
                    foundItem.Selected = True
                    DiscountIdHidden.Value = selectedDiscountId
                End If
            End If
            
        Catch ex As Exception
            ShowAlert("Error loading discounts: " & ex.Message, False)
        End Try
    End Sub
    
    Protected Sub DiscountDropDown_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Dim selectedDiscountId As Integer = Convert.ToInt32(DiscountDropDown.SelectedValue)
            
            If selectedDiscountId > 0 Then
                ' Store the selected discount in the session
                Session("SelectedDiscountId") = selectedDiscountId
                DiscountIdHidden.Value = selectedDiscountId.ToString()
                
                ' Apply the selected discount
                ApplySelectedDiscount()
            Else
                ' No discount selected
                Session("SelectedDiscountId") = Nothing
                DiscountIdHidden.Value = "0"
                DiscountInfo.Visible = False
            End If
            
            UpdateOrderSummary()
            
        Catch ex As Exception
            ShowAlert("Error applying discount: " & ex.Message, False)
        End Try
    End Sub
    
    Private Sub ApplySelectedDiscount()
        Try
            ' Check if a discount is selected
            If Session("SelectedDiscountId") IsNot Nothing Then
                Dim discountId As Integer = Convert.ToInt32(Session("SelectedDiscountId"))
                
                If discountId > 0 Then
                    ' Get the discount details
                    Dim query As String = "SELECT name, discount_type, value, description " & _
                                         "FROM discounts " & _
                                         "WHERE discount_id = @discount_id"
                    
                    Connect.ClearParams()
                    Connect.AddParam("@discount_id", discountId)
                    Connect.Query(query)
                    
                    If Connect.DataCount > 0 Then
                        Dim discountName As String = Connect.Data.Tables(0).Rows(0)("name").ToString()
                        Dim discountType As Integer = Convert.ToInt32(Connect.Data.Tables(0).Rows(0)("discount_type"))
                        Dim discountValue As Decimal = Convert.ToDecimal(Connect.Data.Tables(0).Rows(0)("value"))
                        Dim discountDescription As String = Connect.Data.Tables(0).Rows(0)("description").ToString()
                        
                        ' Set the discount information
                        DiscountNameLiteral.Text = discountName
                        DiscountDescriptionLiteral.Text = discountDescription
                        
                        ' Format the discount value display
                        If discountType = 1 Then ' Percentage discount
                            DiscountValueLiteral.Text = discountValue & "% off the subtotal"
                        Else ' Fixed amount discount
                            DiscountValueLiteral.Text = "PHP " & Format(discountValue, "0.00") & " off the subtotal"
                        End If
                        
                        ' Show the discount info section
                        DiscountInfo.Visible = True
                        
                        ' Store the discount details
                        DiscountIdHidden.Value = discountId.ToString()
                        
                        ' Store the discount in the session
                        Session("SelectedDiscount") = New Discount(discountId, discountName, discountType, discountValue, discountDescription)
                        
                        Return
                    End If
                End If
            End If
            
            ' If we get here, no valid discount was found
            DiscountInfo.Visible = False
            DiscountIdHidden.Value = "0"
            
        Catch ex As Exception
            ShowAlert("Error applying discount: " & ex.Message, False)
        End Try
    End Sub
    
    Private Function GetAppliedDiscountAmount(ByVal subtotal As Decimal) As Decimal
        Try
            ' Check if a discount is selected
            If Session("SelectedDiscountId") IsNot Nothing Then
                Dim discountId As Integer = Convert.ToInt32(Session("SelectedDiscountId"))
                
                If discountId > 0 Then
                    ' Get the discount details
                    Dim query As String = "SELECT discount_type, value " & _
                                         "FROM discounts " & _
                                         "WHERE discount_id = @discount_id"
                    
                    Connect.ClearParams()
                    Connect.AddParam("@discount_id", discountId)
                    Connect.Query(query)
                    
                    If Connect.DataCount > 0 Then
                        Dim discountType As Integer = Convert.ToInt32(Connect.Data.Tables(0).Rows(0)("discount_type"))
                        Dim discountValue As Decimal = Convert.ToDecimal(Connect.Data.Tables(0).Rows(0)("value"))
                        
                        ' Calculate the discount amount
                        If discountType = 1 Then ' Percentage discount
                            Return Math.Round((subtotal * discountValue) / 100, 2)
                        Else ' Fixed amount discount
                            Return Math.Min(discountValue, subtotal) ' Ensure discount doesn't exceed subtotal
                        End If
                    End If
                End If
            End If
            
            ' No valid discount
            Return 0
            
        Catch ex As Exception
            ' Log the error but don't interrupt the user experience
            System.Diagnostics.Debug.WriteLine("Error calculating discount: " & ex.Message)
            Return 0
        End Try
    End Function

    Private Sub LoadPromotions()
        Try
            ' Get active promotions where current date is between start_date and end_date
            Dim query As String = "SELECT promotion_id, name, description, promotion_type, value, end_date " & _
                                 "FROM promotions " & _
                                 "WHERE status = 1 " & _
                                 "AND GETDATE() BETWEEN start_date AND end_date " & _
                                 "ORDER BY value DESC"
            
            Connect.ClearParams()
            Connect.Query(query)
            
            If Connect.DataCount > 0 Then
                PromotionsRepeater.DataSource = Connect.Data
                PromotionsRepeater.DataBind()
            End If
        Catch ex As Exception
            ShowAlert("Error loading promotions: " & ex.Message, False)
        End Try
    End Sub

    Private Sub LoadDeals()
        Try
            ' Get active deals where current date is between start_date and end_date
            Dim query As String = "SELECT deal_id, name, description, deal_type, value, end_date " & _
                                 "FROM deals " & _
                                 "WHERE status = 1 " & _
                                 "AND GETDATE() BETWEEN start_date AND end_date " & _
                                 "ORDER BY value DESC"
            
            Connect.ClearParams()
            Connect.Query(query)
            
            If Connect.DataCount > 0 Then
                DealsRepeater.DataSource = Connect.Data
                DealsRepeater.DataBind()
            End If
        Catch ex As Exception
            ShowAlert("Error loading deals: " & ex.Message, False)
        End Try
    End Sub

    Private Function GetAppliedPromotionAmount(ByVal subtotal As Decimal) As Decimal
        Try
            ' Get active promotions
            Dim query As String = "SELECT promotion_type, value " & _
                                 "FROM promotions " & _
                                 "WHERE status = 1 " & _
                                 "AND GETDATE() BETWEEN start_date AND end_date " & _
                                 "ORDER BY value DESC"
            
            Connect.ClearParams()
            Connect.Query(query)
            
            If Connect.DataCount > 0 Then
                ' Apply the highest value promotion
                Dim promotionType As Integer = Convert.ToInt32(Connect.Data.Tables(0).Rows(0)("promotion_type"))
                Dim promotionValue As Decimal = Convert.ToDecimal(Connect.Data.Tables(0).Rows(0)("value"))
                
                If promotionType = 1 Then ' Percentage promotion
                    Return Math.Round((subtotal * promotionValue) / 100, 2)
                Else ' Fixed amount promotion
                    Return Math.Min(promotionValue, subtotal) ' Ensure promotion doesn't exceed subtotal
                End If
            End If
            
            Return 0
        Catch ex As Exception
            Return 0
        End Try
    End Function

    Private Function GetAppliedDealAmount(ByVal subtotal As Decimal) As Decimal
        Try
            ' Get active deals
            Dim query As String = "SELECT deal_type, value " & _
                                 "FROM deals " & _
                                 "WHERE status = 1 " & _
                                 "AND GETDATE() BETWEEN start_date AND end_date " & _
                                 "ORDER BY value DESC"
            
            Connect.ClearParams()
            Connect.Query(query)
            
            If Connect.DataCount > 0 Then
                ' Apply the highest value deal
                Dim dealType As Integer = Convert.ToInt32(Connect.Data.Tables(0).Rows(0)("deal_type"))
                Dim dealValue As Decimal = Convert.ToDecimal(Connect.Data.Tables(0).Rows(0)("value"))
                
                If dealType = 1 Then ' Percentage deal
                    Return Math.Round((subtotal * dealValue) / 100, 2)
                Else ' Fixed amount deal
                    Return Math.Min(dealValue, subtotal) ' Ensure deal doesn't exceed subtotal
                End If
            End If
            
            Return 0
        Catch ex As Exception
            Return 0
        End Try
    End Function

    <WebMethod()> _
    Public Shared Function ProcessPayment(ByVal paymentDataJson As String) As String
        Try
            System.Diagnostics.Debug.WriteLine("ProcessPayment called with data: " & paymentDataJson)
            
            ' Check if user is logged in
            Dim currentUser As Object = HttpContext.Current.Session("CURRENT_SESSION")
            If currentUser Is Nothing Then
                Return "Error: User not logged in"
            End If
            
            System.Diagnostics.Debug.WriteLine("Processing payment for user: " & currentUser.user_id)
            
            Dim Connect As New Connection()

            ' Parse payment data
            Dim serializer As New JavaScriptSerializer()
            Dim paymentData As Dictionary(Of String, Object) = serializer.Deserialize(Of Dictionary(Of String, Object))(paymentDataJson)
            
            ' Fix: Check if the method key exists and is a string
            If Not paymentData.ContainsKey("method") Then
                Return "Error: Payment method not specified"
            End If
            
            Dim paymentMethod As String = paymentData("method").ToString()
            
            ' Calculate total amount from cart
            Dim totalQuery As String = "SELECT SUM(m.price * c.quantity) as total FROM cart c " & _
                                     "JOIN menu m ON c.item_id = m.item_id " & _
                                     "WHERE c.user_id = @user_id"
            
            Connect.AddParam("@user_id", CInt(currentUser.user_id))
            Connect.Query(totalQuery)

            If Connect.DataCount = 0 Then
                System.Diagnostics.Debug.WriteLine("Error: Cart is empty")
                Return "Error: Cart is empty"
            End If

            Dim subtotalAmount As Decimal = 0
            ' Fix: Handle null or invalid values in the total
            If Not IsDBNull(Connect.Data.Tables(0).Rows(0)("total")) Then
                subtotalAmount = Convert.ToDecimal(Connect.Data.Tables(0).Rows(0)("total"))
                System.Diagnostics.Debug.WriteLine("Cart subtotal amount: " & subtotalAmount)
            Else
                System.Diagnostics.Debug.WriteLine("Error: Invalid cart total")
                Return "Error: Invalid cart total"
            End If
            
            ' Apply discount if available
            Dim discountAmount As Decimal = 0
            Dim discountId As Integer = 0
            If paymentData.ContainsKey("discountId") AndAlso Convert.ToInt32(paymentData("discountId")) > 0 Then
                discountId = Convert.ToInt32(paymentData("discountId"))
                
                ' Get discount details
                Dim discountQuery As String = "SELECT discount_type, value FROM discounts WHERE discount_id = @discount_id"
                Connect = New Connection()
                Connect.AddParam("@discount_id", discountId)
                Connect.Query(discountQuery)
                
                If Connect.DataCount > 0 Then
                    Dim discountType As Integer = Convert.ToInt32(Connect.Data.Tables(0).Rows(0)("discount_type"))
                    Dim discountValue As Decimal = Convert.ToDecimal(Connect.Data.Tables(0).Rows(0)("value"))
                    
                    ' Calculate discount amount
                    If discountType = 1 Then ' Percentage
                        discountAmount = Math.Round((subtotalAmount * discountValue) / 100, 2)
                    Else ' Fixed amount
                        discountAmount = Math.Min(discountValue, subtotalAmount)
                    End If
                    
                    System.Diagnostics.Debug.WriteLine("Applied discount: " & discountAmount)
                End If
            End If
            
            ' Add delivery fee if applicable
            Dim deliveryFee As Decimal = 0
            Dim deliveryType As String = "standard"
            Dim scheduledTime As String = Nothing
            
            If paymentData.ContainsKey("deliveryType") Then
                deliveryType = paymentData("deliveryType").ToString()
                
                ' Apply delivery fee based on type
                If deliveryType = "priority" AndAlso paymentData.ContainsKey("deliveryFee") Then
                    deliveryFee = Convert.ToDecimal(paymentData("deliveryFee"))
                    System.Diagnostics.Debug.WriteLine("Applied delivery fee: " & deliveryFee)
                End If
                
                ' Store scheduled time if applicable
                If deliveryType = "scheduled" AndAlso paymentData.ContainsKey("scheduledTime") AndAlso 
                   paymentData("scheduledTime") IsNot Nothing AndAlso 
                   Not String.IsNullOrEmpty(paymentData("scheduledTime").ToString()) Then
                    scheduledTime = paymentData("scheduledTime").ToString()
                    System.Diagnostics.Debug.WriteLine("Scheduled delivery time: " & scheduledTime)
                End If
            End If
            
            ' Calculate final total amount
            Dim totalAmount As Decimal = subtotalAmount - discountAmount + deliveryFee
            System.Diagnostics.Debug.WriteLine("Final total amount: " & totalAmount)

            ' Start transaction
            Dim transactionQuery As String = "INSERT INTO transactions (user_id, payment_method, subtotal, discount, " & _
                                           "delivery_fee, total_amount, status, delivery_type"
            
            If Not String.IsNullOrEmpty(scheduledTime) Then
                transactionQuery &= ", scheduled_time"
            End If

            If discountId > 0 Then
                transactionQuery &= ", discount_id"
            End If

            If paymentMethod = "gcash" Then
                transactionQuery &= ", reference_number, sender_name, sender_number"
            End If

            transactionQuery &= ") VALUES (@user_id, @payment_method, @subtotal, @discount, " & _
                               "@delivery_fee, @total_amount, 'Pending', @delivery_type"

            If Not String.IsNullOrEmpty(scheduledTime) Then
                transactionQuery &= ", @scheduled_time"
            End If

            If discountId > 0 Then
                transactionQuery &= ", @discount_id"
            End If

            If paymentMethod = "gcash" Then
                transactionQuery &= ", @reference_number, @sender_name, @sender_number"
            End If

            transactionQuery &= ")"

            ' Insert transaction
            Connect = New Connection()
            Connect.AddParam("@user_id", CInt(currentUser.user_id))
            Connect.AddParam("@payment_method", paymentMethod)
            Connect.AddParam("@subtotal", subtotalAmount)
            Connect.AddParam("@discount", discountAmount)
            Connect.AddParam("@delivery_fee", deliveryFee)
            Connect.AddParam("@total_amount", totalAmount)
            Connect.AddParam("@delivery_type", deliveryType)
            
            If Not String.IsNullOrEmpty(scheduledTime) Then
                Connect.AddParam("@scheduled_time", scheduledTime)
            End If
            
            If discountId > 0 Then
                Connect.AddParam("@discount_id", discountId)
            End If

            If paymentMethod = "gcash" Then
                ' Fix: Check if required GCash fields exist
                If Not (paymentData.ContainsKey("referenceNumber") AndAlso 
                        paymentData.ContainsKey("senderName") AndAlso 
                        paymentData.ContainsKey("senderNumber")) Then
                    System.Diagnostics.Debug.WriteLine("Error: Missing GCash payment details")
                    Return "Error: Missing GCash payment details"
                End If
                
                Connect.AddParam("@reference_number", paymentData("referenceNumber").ToString())
                Connect.AddParam("@sender_name", paymentData("senderName").ToString())
                Connect.AddParam("@sender_number", paymentData("senderNumber").ToString())
            End If

            Dim success As Boolean = Connect.Query(transactionQuery)
            If Not success Then
                System.Diagnostics.Debug.WriteLine("Error: Failed to process payment")
                Return "Error: Failed to process payment"
            End If

            ' Get the transaction ID using a separate query
            Connect = New Connection()
            Dim getTransactionIdQuery As String = "SELECT MAX(transaction_id) FROM transactions WHERE user_id = @user_id"
            Connect.AddParam("@user_id", CInt(currentUser.user_id))
            Connect.Query(getTransactionIdQuery)

            Dim transactionId As Integer = 0
            If Connect.DataCount > 0 AndAlso Connect.Data.Tables(0).Rows.Count > 0 Then
                transactionId = Convert.ToInt32(Connect.Data.Tables(0).Rows(0)(0))
                System.Diagnostics.Debug.WriteLine("Transaction created with ID: " & transactionId)
            Else
                System.Diagnostics.Debug.WriteLine("Error: Failed to retrieve transaction ID")
                Return "Error: Failed to retrieve transaction ID"
            End If

            ' Create an order in the orders table
            Connect = New Connection()
            Dim createOrderQuery As String = "INSERT INTO orders (user_id, order_date, status, subtotal, discount, " & _
                                           "delivery_fee, total_amount, transaction_id, delivery_type"
            
            If Not String.IsNullOrEmpty(scheduledTime) Then
                createOrderQuery &= ", scheduled_time"
            End If
            
            createOrderQuery &= ") VALUES (@user_id, GETDATE(), 'pending', @subtotal, @discount, " & _
                              "@delivery_fee, @total_amount, @transaction_id, @delivery_type"
            
            If Not String.IsNullOrEmpty(scheduledTime) Then
                createOrderQuery &= ", @scheduled_time"
            End If
            
            createOrderQuery &= ")"
            
            Connect.AddParam("@user_id", CInt(currentUser.user_id))
            Connect.AddParam("@subtotal", subtotalAmount)
            Connect.AddParam("@discount", discountAmount)
            Connect.AddParam("@delivery_fee", deliveryFee)
            Connect.AddParam("@total_amount", totalAmount)
            Connect.AddParam("@transaction_id", transactionId)
            Connect.AddParam("@delivery_type", deliveryType)
            
            If Not String.IsNullOrEmpty(scheduledTime) Then
                Connect.AddParam("@scheduled_time", scheduledTime)
            End If
            
            Dim orderCreated As Boolean = Connect.Query(createOrderQuery)
            If Not orderCreated Then
                System.Diagnostics.Debug.WriteLine("Error: Failed to create order")
                Return "Error: Failed to create order"
            End If
            
            ' Get the order ID
            Connect = New Connection()
            Dim getOrderIdQuery As String = "SELECT MAX(order_id) FROM orders WHERE user_id = @user_id"
            Connect.AddParam("@user_id", CInt(currentUser.user_id))
            Connect.Query(getOrderIdQuery)
            
            Dim orderId As Integer = 0
            If Connect.DataCount > 0 AndAlso Connect.Data.Tables(0).Rows.Count > 0 Then
                orderId = Convert.ToInt32(Connect.Data.Tables(0).Rows(0)(0))
                System.Diagnostics.Debug.WriteLine("Order created with ID: " & orderId)
            Else
                System.Diagnostics.Debug.WriteLine("Error: Failed to retrieve order ID")
                Return "Error: Failed to retrieve order ID"
            End If

            ' Move items from cart to order_items
            Connect = New Connection()
            Dim moveItemsQuery As String = "INSERT INTO order_items (order_id, item_id, quantity, price, transaction_id) " & _
                                         "SELECT @order_id, c.item_id, c.quantity, m.price, @transaction_id " & _
                                         "FROM cart c JOIN menu m ON c.item_id = m.item_id " & _
                                         "WHERE c.user_id = @user_id"

            Connect.AddParam("@order_id", orderId)
            Connect.AddParam("@transaction_id", transactionId)
            Connect.AddParam("@user_id", CInt(currentUser.user_id))
            success = Connect.Query(moveItemsQuery)

            If Not success Then
                System.Diagnostics.Debug.WriteLine("Error: Failed to process order items")
                Return "Error: Failed to process order items"
            End If

            ' Clear the cart
            Connect = New Connection()
            Dim clearCartQuery As String = "DELETE FROM cart WHERE user_id = @user_id"
            Connect.AddParam("@user_id", CInt(currentUser.user_id))
            Connect.Query(clearCartQuery)
            
            ' Clear any applied discount
            HttpContext.Current.Session("SelectedDiscountId") = Nothing

            System.Diagnostics.Debug.WriteLine("Payment processed successfully for order: " & orderId)
            Return "Success: Payment processed successfully! Order ID: " & orderId & " Redirecting to orders page..."
        Catch ex As Exception
            System.Diagnostics.Debug.WriteLine("Error in ProcessPayment: " & ex.Message)
            Return "Error: " & ex.Message
        End Try
    End Function

    Private Sub LoadCartItems()
        Try
            Dim currentUser As User = DirectCast(Session("CURRENT_SESSION"), User)
            
            ' Get cart items with menu details
            Dim query As String = "SELECT c.cart_id, c.quantity, m.* " & _
                                "FROM cart c " & _
                                "INNER JOIN menu m ON c.item_id = m.item_id " & _
                                "WHERE c.user_id = @user_id"
            
            Connect.AddParam("@user_id", currentUser.user_id)
            Connect.Query(query)

            If Connect.DataCount > 0 Then
                CartRepeater.DataSource = Connect.Data
                CartRepeater.DataBind()
                EmptyCartPanel.Visible = False
                CartItemsPanel.Visible = True
            Else
                EmptyCartPanel.Visible = True
                CartItemsPanel.Visible = False
            End If
        Catch ex As Exception
            ShowAlert("Error loading cart items: " & ex.Message, False)
        End Try
    End Sub

    Protected Function GetCartTotal() As Decimal
        Try
            Dim currentUser As User = DirectCast(Session("CURRENT_SESSION"), User)
            
            Dim query As String = "SELECT SUM(m.price * c.quantity) as total " & _
                                "FROM cart c " & _
                                "INNER JOIN menu m ON c.item_id = m.item_id " & _
                                "WHERE c.user_id = @user_id"
            
            Connect.AddParam("@user_id", currentUser.user_id)
            Connect.Query(query)

            If Connect.DataCount > 0 AndAlso Not IsDBNull(Connect.Data.Tables(0).Rows(0)("total")) Then
                Return CDec(Connect.Data.Tables(0).Rows(0)("total"))
            End If

            Return 0
        Catch ex As Exception
            Return 0
        End Try
    End Function

    Protected Function GetTotalItems() As Integer
        Try
            Dim currentUser As User = DirectCast(Session("CURRENT_SESSION"), User)
            
            Dim query As String = "SELECT SUM(quantity) as total_items " & _
                                "FROM cart " & _
                                "WHERE user_id = @user_id"
            
            Connect.AddParam("@user_id", currentUser.user_id)
            Connect.Query(query)

            If Connect.DataCount > 0 AndAlso Not IsDBNull(Connect.Data.Tables(0).Rows(0)("total_items")) Then
                Return CInt(Connect.Data.Tables(0).Rows(0)("total_items"))
            End If

            Return 0
        Catch ex As Exception
            Return 0
        End Try
    End Function

    <System.Web.Services.WebMethod()> _
    Public Shared Function UpdateCartQuantity(ByVal cartId As Integer, ByVal quantity As Integer) As String
        Try
            ' Validate quantity
            If quantity < 1 Or quantity > 99 Then
                Return "Error: Invalid quantity. Please enter a value between 1 and 99."
            End If

            ' Update cart item quantity
            Dim Connect As New Connection()
            Dim updateQuery As String = "UPDATE cart SET quantity = @quantity WHERE cart_id = @cart_id"
            Connect.AddParam("@cart_id", cartId)
            Connect.AddParam("@quantity", quantity)
            Connect.Query(updateQuery)

            Return "Success: Quantity updated successfully!"
        Catch ex As Exception
            Return "Error: " & ex.Message
        End Try
    End Function

    <System.Web.Services.WebMethod()> _
    Public Shared Function RemoveCartItem(ByVal cartId As Integer) As String
        Try
            ' Remove cart item
            Dim Connect As New Connection()
            Dim deleteQuery As String = "DELETE FROM cart WHERE cart_id = @cart_id"
            Connect.AddParam("@cart_id", cartId)
            Connect.Query(deleteQuery)

            Return "Success: Item removed from cart!"
        Catch ex As Exception
            Return "Error: " & ex.Message
        End Try
    End Function

    Protected Sub ClearCartButton_Click(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Dim currentUser As User = DirectCast(Session("CURRENT_SESSION"), User)
            
            ' Clear all items from cart
            Dim deleteQuery As String = "DELETE FROM cart WHERE user_id = @user_id"
            Connect.AddParam("@user_id", currentUser.user_id)
            Connect.Query(deleteQuery)

            ShowAlert("Cart cleared successfully!", True)
            LoadCartItems()
        Catch ex As Exception
            ShowAlert("Error clearing cart: " & ex.Message, False)
        End Try
    End Sub

    Protected Sub CheckoutButton_Click(sender As Object, e As EventArgs)
        ' Show delivery options panel
        DeliveryOptionsPanel.Visible = True
        
        ' Make sure new address panel is hidden
        HideNewAddressForm()
        
        ' Load customer's saved addresses
        LoadCustomerAddresses()
        
        ' Update order summary with delivery fee
        UpdateOrderSummary()
    End Sub

    Private Sub LoadCustomerAddresses()
        Try
            Dim currentUser As User = DirectCast(Session("CURRENT_SESSION"), User)
            Dim userId As Integer = currentUser.user_id
            
            ' Only hide new address panel if it's not meant to be shown
            If Not NewAddressPanel.Visible Then
                NewAddressPanel.Attributes("style") = "display: none;"
            Else
                ' If panel should be visible, make sure any hiding style is removed
                NewAddressPanel.Attributes.Remove("style")
            End If
            
            If userId > 0 Then
                ' Query to get all customer addresses
                Dim query As String = "SELECT address_id, address_name, recipient_name, contact_number, " & _
                                     "address_line, city, postal_code, is_default " & _
                                     "FROM customer_addresses " & _
                                     "WHERE user_id = @UserId " & _
                                     "ORDER BY is_default DESC, date_added DESC"
                
                Connect.ClearParams()
                Connect.AddParam("@UserId", userId)
                Connect.Query(query)
                
                If Connect.DataCount > 0 AndAlso Connect.Data.Tables(0).Rows.Count > 0 Then
                    ' Clear any existing items
                    AddressRadioList.Items.Clear()
                    
                    ' Add addresses to the radio button list
                    For Each row As DataRow In Connect.Data.Tables(0).Rows
                        Dim addressId As Integer = Convert.ToInt32(row("address_id"))
                        Dim addressName As String = If(IsDBNull(row("address_name")), "", row("address_name").ToString())
                        Dim recipientName As String = row("recipient_name").ToString()
                        Dim contactNumber As String = row("contact_number").ToString()
                        Dim addressLine As String = row("address_line").ToString()
                        Dim city As String = row("city").ToString()
                        Dim postalCode As String = If(IsDBNull(row("postal_code")), "", row("postal_code").ToString())
                        Dim isDefault As Boolean = Convert.ToBoolean(row("is_default"))
                        
                        ' Format the address text
                        Dim addressText As String = String.Format("{0}<br />{1}<br />{2}, {3} {4}", 
                                                                recipientName, 
                                                                addressLine, 
                                                                city, 
                                                                postalCode,
                                                                contactNumber)
                        
                        ' Add a label for default or address name
                        If isDefault Then
                            addressText = "<strong>Default Address</strong><br />" & addressText
                        ElseIf Not String.IsNullOrEmpty(addressName) Then
                            addressText = "<strong>" & addressName & "</strong><br />" & addressText
                        End If
                        
                        ' Add to radio button list
                        Dim item As New ListItem(addressText, addressId.ToString())
                        item.Selected = isDefault
                        AddressRadioList.Items.Add(item)
                    Next
                    
                    ' Show addresses and hide no address message
                    AddressRadioList.Visible = True
                    NoAddressPanel.Visible = False
                    
                    ' Set the selected address to the delivery address hidden field
                    If AddressRadioList.SelectedItem IsNot Nothing Then
                        Dim selectedAddressId As Integer = Convert.ToInt32(AddressRadioList.SelectedValue)
                        DeliveryAddressHidden.Value = selectedAddressId.ToString()
                    End If
                Else
                    ' No addresses found
                    AddressRadioList.Visible = False
                    NoAddressPanel.Visible = True
                End If
            End If
        Catch ex As Exception
            ' Log error and show message to user
            Response.Write("Error loading addresses: " & ex.Message)
        End Try
    End Sub
    
    Protected Sub AddressRadioList_SelectedIndexChanged(sender As Object, e As EventArgs)
        ' Update the selected address ID
        If AddressRadioList.SelectedItem IsNot Nothing Then
            Dim selectedAddressId As Integer = Convert.ToInt32(AddressRadioList.SelectedValue)
            DeliveryAddressHidden.Value = selectedAddressId.ToString()
        End If
    End Sub
    
    Protected Sub SaveAddressButton_Click(sender As Object, e As EventArgs)
        Try
            Dim currentUser As User = DirectCast(Session("CURRENT_SESSION"), User)
            Dim userId As Integer = currentUser.user_id
            
            ' Get address details from form
            Dim addressName As String = AddressNameTextBox.Text.Trim()
            Dim recipientName As String = RecipientNameTextBox.Text.Trim()
            Dim contactNumber As String = ContactNumberTextBox.Text.Trim()
            Dim addressLine As String = AddressLineTextBox.Text.Trim()
            Dim city As String = CityTextBox.Text.Trim()
            Dim postalCode As String = PostalCodeTextBox.Text.Trim()
            Dim isDefault As Boolean = DefaultAddressCheckBox.Checked
            
            ' Validate required fields
            If String.IsNullOrEmpty(recipientName) OrElse 
               String.IsNullOrEmpty(contactNumber) OrElse 
               String.IsNullOrEmpty(addressLine) OrElse 
               String.IsNullOrEmpty(city) Then
                ShowAlert("Please fill in all required fields", False)
                Return
            End If
            
            ' If setting as default, update existing addresses to not be default
            If isDefault Then
                Dim updateDefaultQuery As String = "UPDATE customer_addresses SET is_default = 0 WHERE user_id = @UserId"
                Connect.ClearParams()
                Connect.AddParam("@UserId", userId)
                Connect.Query(updateDefaultQuery)
            End If
            
            ' Insert new address
            Dim insertQuery As String = "INSERT INTO customer_addresses (" & _
                                       "user_id, address_name, recipient_name, contact_number, " & _
                                       "address_line, city, postal_code, is_default) " & _
                                       "VALUES (@UserId, @AddressName, @RecipientName, @ContactNumber, " & _
                                       "@AddressLine, @City, @PostalCode, @IsDefault)"
            
            Connect.ClearParams()
            Connect.AddParam("@UserId", userId)
            Connect.AddParam("@AddressName", If(String.IsNullOrEmpty(addressName), DBNull.Value, addressName))
            Connect.AddParam("@RecipientName", recipientName)
            Connect.AddParam("@ContactNumber", contactNumber)
            Connect.AddParam("@AddressLine", addressLine)
            Connect.AddParam("@City", city)
            Connect.AddParam("@PostalCode", If(String.IsNullOrEmpty(postalCode), DBNull.Value, postalCode))
            Connect.AddParam("@IsDefault", If(isDefault, 1, 0)) ' Convert boolean to integer
            
            Dim success As Boolean = Connect.Query(insertQuery)
            
            If success Then
                ' Get the new address ID
                Dim getIdQuery As String = "SELECT MAX(address_id) FROM customer_addresses WHERE user_id = @UserId"
                Connect.ClearParams()
                Connect.AddParam("@UserId", userId)
                Connect.Query(getIdQuery)
                
                Dim newAddressId As Integer = Convert.ToInt32(Connect.Data.Tables(0).Rows(0)(0))
                
                ' Set as selected address
                DeliveryAddressHidden.Value = newAddressId.ToString()
                
                ' Clear the form
                AddressNameTextBox.Text = ""
                RecipientNameTextBox.Text = ""
                ContactNumberTextBox.Text = ""
                AddressLineTextBox.Text = ""
                CityTextBox.Text = ""
                PostalCodeTextBox.Text = ""
                DefaultAddressCheckBox.Checked = False
                
                ' Hide the form
                HideNewAddressForm()
                
                ' Reload addresses
                LoadCustomerAddresses()
                
                ShowAlert("Address saved successfully", True)
            Else
                ShowAlert("Error saving address", False)
            End If
        Catch ex As Exception
            ShowAlert("Error saving address: " & ex.Message, False)
        End Try
    End Sub

    Protected Sub PlaceOrderButton_Click(sender As Object, e As EventArgs)
        Try
            ' Get selected address ID
            Dim selectedAddressId As Integer = 0
            If Not String.IsNullOrEmpty(DeliveryAddressHidden.Value) Then
                selectedAddressId = Convert.ToInt32(DeliveryAddressHidden.Value)
            ElseIf AddressRadioList.SelectedItem IsNot Nothing Then
                selectedAddressId = Convert.ToInt32(AddressRadioList.SelectedValue)
            End If
            
            If selectedAddressId <= 0 Then
                ShowAlert("Please select a delivery address", False)
                Return
            End If

            ' Get delivery type and fee
            Dim deliveryType As String = Request.Form("deliveryOption")
            Dim deliveryFee As Decimal = 0
            If deliveryType = "priority" Then
                deliveryFee = 50
            End If

            ' Get scheduled time if applicable
            Dim scheduledTime As String = ""
            If deliveryType = "scheduled" Then
                scheduledTime = Request.Form("scheduledTime")
                If String.IsNullOrEmpty(scheduledTime) Then
                    ShowAlert("Please select a delivery time", False)
                    Return
                End If
            End If

            ' Get payment method and details
            Dim paymentMethod As String = Request.Form("paymentMethod")
            Dim gcashDetails As New Dictionary(Of String, String)
            If paymentMethod = "gcash" Then
                gcashDetails.Add("referenceNumber", Request.Form("referenceNumber"))
                gcashDetails.Add("senderName", Request.Form("senderName"))
                gcashDetails.Add("senderNumber", Request.Form("senderNumber"))
                
                ' Validate GCash details
                If String.IsNullOrEmpty(gcashDetails("referenceNumber")) OrElse
                   String.IsNullOrEmpty(gcashDetails("senderName")) OrElse
                   String.IsNullOrEmpty(gcashDetails("senderNumber")) Then
                    ShowAlert("Please fill in all GCash payment details", False)
                    Return
                End If
            End If

            ' Get the current user
            Dim currentUser As User = DirectCast(Session("CURRENT_SESSION"), User)
            Dim userId As Integer = currentUser.user_id

            ' Get the address details
            Dim addressQuery As String = "SELECT recipient_name, contact_number, address_line, city, postal_code " & _
                                        "FROM customer_addresses WHERE address_id = @AddressId AND user_id = @UserId"
            Connect.ClearParams()
            Connect.AddParam("@AddressId", selectedAddressId)
            Connect.AddParam("@UserId", userId)
            Connect.Query(addressQuery)
            
            If Connect.DataCount <= 0 OrElse Connect.Data.Tables(0).Rows.Count <= 0 Then
                ShowAlert("Selected address not found", False)
                Return
            End If
            
            Dim addressRow As DataRow = Connect.Data.Tables(0).Rows(0)
            Dim recipientName As String = addressRow("recipient_name").ToString()
            Dim contactNumber As String = addressRow("contact_number").ToString()
            Dim addressLine As String = addressRow("address_line").ToString()
            Dim city As String = addressRow("city").ToString()
            Dim postalCode As String = If(IsDBNull(addressRow("postal_code")), "", addressRow("postal_code").ToString())
            
            ' Format the full address
            Dim fullAddress As String = String.Format("{0}, {1}, {2} {3}", 
                                                    recipientName, 
                                                    addressLine, 
                                                    city, 
                                                    postalCode)

            ' Create order in database
            Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings("MyDB").ConnectionString)
                conn.Open()
                
                ' Start transaction
                Dim transaction As SqlTransaction = conn.BeginTransaction()
                Try
                    ' Insert order
                    Dim orderCmd As New SqlCommand("INSERT INTO orders (user_id, total_amount, delivery_address, recipient_name, contact_number, delivery_type, delivery_fee, scheduled_time, payment_method, payment_details, status) " & _
                                                 "VALUES (@UserId, @TotalAmount, @DeliveryAddress, @RecipientName, @ContactNumber, @DeliveryType, @DeliveryFee, @ScheduledTime, @PaymentMethod, @PaymentDetails, 'pending')", conn, transaction)
                    orderCmd.Parameters.AddWithValue("@UserId", userId)
                    orderCmd.Parameters.AddWithValue("@TotalAmount", GetGrandTotal())
                    orderCmd.Parameters.AddWithValue("@DeliveryAddress", fullAddress)
                    orderCmd.Parameters.AddWithValue("@RecipientName", recipientName)
                    orderCmd.Parameters.AddWithValue("@ContactNumber", contactNumber)
                    orderCmd.Parameters.AddWithValue("@DeliveryType", deliveryType)
                    orderCmd.Parameters.AddWithValue("@DeliveryFee", deliveryFee)
                    orderCmd.Parameters.AddWithValue("@ScheduledTime", If(String.IsNullOrEmpty(scheduledTime), DBNull.Value, scheduledTime))
                    orderCmd.Parameters.AddWithValue("@PaymentMethod", paymentMethod)
                    
                    ' Use JavaScriptSerializer instead of JsonConvert
                    Dim serializer As New JavaScriptSerializer()
                    orderCmd.Parameters.AddWithValue("@PaymentDetails", If(paymentMethod = "gcash", serializer.Serialize(gcashDetails), DBNull.Value))
                    
                    orderCmd.ExecuteNonQuery()
                    
                    ' Get the new order ID
                    Dim orderId As Integer = 0
                    Dim orderIdCmd As New SqlCommand("SELECT SCOPE_IDENTITY()", conn, transaction)
                    orderId = Convert.ToInt32(orderIdCmd.ExecuteScalar())
                    
                    ' Insert order items
                    For Each item As RepeaterItem In CartRepeater.Items
                        Dim productId As Integer = Convert.ToInt32(CType(item.FindControl("ProductIdHidden"), HiddenField).Value)
                        Dim quantity As Integer = Convert.ToInt32(CType(item.FindControl("QuantityTextBox"), TextBox).Text)
                        Dim price As Decimal = Convert.ToDecimal(CType(item.FindControl("PriceHidden"), HiddenField).Value)
                        
                        Dim itemCmd As New SqlCommand("INSERT INTO order_items (order_id, product_id, quantity, price) VALUES (@OrderId, @ProductId, @Quantity, @Price)", conn, transaction)
                        itemCmd.Parameters.AddWithValue("@OrderId", orderId)
                        itemCmd.Parameters.AddWithValue("@ProductId", productId)
                        itemCmd.Parameters.AddWithValue("@Quantity", quantity)
                        itemCmd.Parameters.AddWithValue("@Price", price)
                        
                        itemCmd.ExecuteNonQuery()
                    Next
                    
                    ' Commit transaction
                    transaction.Commit()
                    
                    ' Clear cart and redirect to order confirmation
                    ClearCart()
                    Response.Redirect("OrderConfirmation.aspx?orderId=" & orderId)
                    
                Catch ex As Exception
                    ' Rollback transaction on error
                    transaction.Rollback()
                    Throw
                End Try
            End Using
            
        Catch ex As Exception
            ' Log error and show message to user
            ShowAlert("Error placing order: " & ex.Message, False)
        End Try
    End Sub

    Private Function GetGrandTotal() As Decimal
        Dim subtotal As Decimal = Convert.ToDecimal(CartSummarySubtotalLiteral.Text)
        Dim discount As Decimal = 0
        If DiscountRow.Visible Then
            discount = Convert.ToDecimal(DiscountAmountLiteral.Text)
        End If
        Dim deliveryFee As Decimal = Convert.ToDecimal(DeliveryFeeHidden.Value)
        
        Return subtotal - discount + deliveryFee
    End Function

    Protected Function GetImageUrl(ByVal imagePath As String) As String
        If String.IsNullOrEmpty(imagePath) Then
            Return ResolveUrl("~/Assets/Images/default-food.jpg")
        End If

        ' Check if the path already contains the full URL
        If imagePath.StartsWith("http") Then
            Return imagePath
        End If

        ' Check if the path starts with ~/ or /
        If Not imagePath.StartsWith("~/") AndAlso Not imagePath.StartsWith("/") Then
            imagePath = "~/Assets/Images/Menu/" & imagePath
        End If

        Return ResolveUrl(imagePath)
    End Function

    ' Helper method to show alert messages
    Protected Sub ShowAlert(ByVal message As String, Optional ByVal isSuccess As Boolean = True)
        Dim masterPage As Pages_Customer_CustomerTemplate = DirectCast(Me.Master, Pages_Customer_CustomerTemplate)
        masterPage.ShowAlert(message, isSuccess)
    End Sub

    Private Sub ClearCart()
        Try
            Dim currentUser As User = DirectCast(Session("CURRENT_SESSION"), User)
            
            ' Clear all items from cart
            Dim deleteQuery As String = "DELETE FROM cart WHERE user_id = @user_id"
            Connect.ClearParams()
            Connect.AddParam("@user_id", currentUser.user_id)
            Connect.Query(deleteQuery)
            
            ' Clear the cart repeater
            CartRepeater.DataSource = Nothing
            CartRepeater.DataBind()
            
            ' Show empty cart panel
            EmptyCartPanel.Visible = True
            CartItemsPanel.Visible = False
            
            ' Clear session discount data
            Session("SelectedDiscountId") = Nothing
            Session("SelectedDiscount") = Nothing
        Catch ex As Exception
            ' Log error but continue
            System.Diagnostics.Debug.WriteLine("Error clearing cart: " & ex.Message)
        End Try
    End Sub

    Protected Sub ShowNewAddressButton_Click(sender As Object, e As EventArgs)
        ' Show delivery options panel and address form
        DeliveryOptionsPanel.Visible = True
        NewAddressPanel.Visible = True
        
        ' Force the form to be visible by removing any inline style
        NewAddressPanel.Attributes.Remove("style")
        
        ' Reload addresses to ensure the form is correctly displayed
        LoadCustomerAddresses()
        
        ' Update the UI
        UpdateOrderSummary()
    End Sub

    Protected Sub CancelAddressButton_Click(sender As Object, e As EventArgs)
        ' Hide the new address form
        NewAddressPanel.Visible = False
        
        ' Apply CSS to ensure it's hidden
        NewAddressPanel.Attributes("style") = "display: none;"
        
        ' Update the UI
        LoadCustomerAddresses() ' Reload the addresses
        UpdateOrderSummary()
    End Sub

    Private Sub HideNewAddressForm()
        NewAddressPanel.Visible = False
        NewAddressPanel.Attributes("style") = "display: none;"
    End Sub

    Private Sub ShowNewAddressForm()
        NewAddressPanel.Visible = True
        NewAddressPanel.Attributes.Remove("style")
    End Sub
End Class
