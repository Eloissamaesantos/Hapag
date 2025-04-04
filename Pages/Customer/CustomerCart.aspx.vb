Imports System.Data
Imports System.Web.Services
Imports System.Web.Script.Serialization
Imports System.Data.SqlClient
Imports Newtonsoft.Json
Imports System.Web.UI.WebControls
Imports System.Web.UI.HtmlControls

' Define the Discount class
Public Class Discount
    Public Property DiscountId As Integer
    Public Property Name As String
    Public Property DiscountType As Integer
    Public Property Value As Decimal
    Public Property Description As String

    Public Sub New(ByVal id As Integer, ByVal name As String, ByVal type As Integer, ByVal value As Decimal, ByVal description As String)
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
                ' Initialize page
                If Session("CURRENT_SESSION") Is Nothing Then
                    Response.Redirect("~/Default.aspx")
                    Return
                End If

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

    Protected Sub DiscountDropDown_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim selectedDiscountId As String = DiscountDropDown.SelectedValue
        
        If selectedDiscountId = "0" Then
            ' No discount selected
            Session("SelectedDiscountId") = Nothing
            Session("SelectedDiscount") = Nothing
            DiscountInfo.Visible = False
        Else
            ' Apply the selected discount
            Dim discount As Discount = GetDiscountById(selectedDiscountId)
            
            If discount IsNot Nothing Then
                ' Store the discount in session
                Session("SelectedDiscountId") = selectedDiscountId
                Session("SelectedDiscount") = discount
                
                ' Show discount info
                DiscountNameLiteral.Text = discount.Name
                DiscountDescriptionLiteral.Text = discount.Description
                
                ' Format the discount value
                Dim valueText As String = ""
                If discount.DiscountType = 1 Then
                    valueText = discount.Value & "% off"
                Else
                    valueText = "PHP " & discount.Value.ToString("0.00") & " off"
                End If
                
                DiscountValueLiteral.Text = valueText
                DiscountInfo.Visible = True
            End If
        End If
        
        ' Update cart summary with the discount applied
        UpdateCartSummary()
    End Sub

    Private Function GetDiscountById(ByVal discountId As String) As Discount
        Try
            ' Get the cart total to check against min_order_amount
            Dim cartTotal As Decimal = GetCartTotal()

            ' Get active discounts where current date is between start_date and end_date
            ' and min_order_amount is met by the cart total
            Dim query As String = "SELECT discount_id, name, discount_type, value, description " & _
                                 "FROM discounts " & _
                                 "WHERE status = 1 " & _
                                 "AND GETDATE() BETWEEN start_date AND end_date " & _
                                 "AND (min_order_amount IS NULL OR min_order_amount <= @cart_total) " & _
                                 "AND discount_id = @discount_id"

            Connect.ClearParams()
            Connect.AddParam("@cart_total", cartTotal)
            Connect.AddParam("@discount_id", discountId)
            Connect.Query(query)

            If Connect.DataCount > 0 Then
                Dim row As DataRow = Connect.Data.Tables(0).Rows(0)
                Dim discountIdValue As Integer = Convert.ToInt32(row("discount_id"))
                Dim discountName As String = row("name").ToString()
                Dim discountType As Integer = Convert.ToInt32(row("discount_type"))
                Dim discountValue As Decimal = Convert.ToDecimal(row("value"))
                Dim discountDescription As String = row("description").ToString()

                Return New Discount(discountIdValue, discountName, discountType, discountValue, discountDescription)
            End If

            Return Nothing
        Catch ex As Exception
            ShowAlert("Error loading discount: " & ex.Message, False)
            Return Nothing
        End Try
    End Function

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
            
            ' Get cart items with product details
            Dim query As String = "SELECT c.cart_id, c.item_id, c.quantity, " & _
                                  "m.name, m.price, m.category, m.type, m.description, m.image " & _
                                  "FROM cart c " & _
                                  "INNER JOIN menu m ON c.item_id = m.item_id " & _
                                  "WHERE c.user_id = @user_id " & _
                                  "ORDER BY c.cart_id DESC"
            Connect.ClearParams()
            Connect.AddParam("@user_id", currentUser.user_id)
            Connect.Query(query)
            
            If Connect.DataCount > 0 AndAlso Connect.Data.Tables(0).Rows.Count > 0 Then
                CartRepeater.DataSource = Connect.Data
                CartRepeater.DataBind()
                
                EmptyCartPanel.Visible = False
                CartItemsPanel.Visible = True
                
                ' Update cart summary
                UpdateCartSummary()
            Else
                ' No items in cart
                EmptyCartPanel.Visible = True
                CartItemsPanel.Visible = False
            End If
        Catch ex As Exception
            ' Log error and show message
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
    Public Shared Function UpdateCartQuantity(ByVal cartId As String, ByVal quantity As Integer) As String
        Try
            ' Validate inputs
            If String.IsNullOrEmpty(cartId) Then
                Return "Error: Invalid cart item"
            End If
            
            If quantity < 1 Then
                Return "Error: Quantity must be at least 1"
            End If
            
            ' Create instance to access non-static methods
            Dim instance As New Pages_Customer_CustomerCart()
            
            ' Check if user is logged in
            If HttpContext.Current.Session("CURRENT_SESSION") Is Nothing Then
                Return "Error: Please log in to update cart"
            End If
            
            Dim currentUser As User = DirectCast(HttpContext.Current.Session("CURRENT_SESSION"), User)
            
            ' Create connection
            Dim Connect As New Connection()
            
            ' Update cart item quantity
            Dim updateQuery As String = "UPDATE cart SET quantity = @quantity WHERE cart_id = @cart_id AND user_id = @user_id"
            Connect.AddParam("@cart_id", cartId)
            Connect.AddParam("@quantity", quantity)
            Connect.AddParam("@user_id", currentUser.user_id)
            Connect.Query(updateQuery)
            
            ' Check if the update was successful
            If Connect.DataCount > 0 Then
                ' Call UpdateCartSummary via page method to reflect the changes
                instance.UpdateCartSummary()
                Return "Success: Cart updated"
            Else
                Return "Error: Failed to update cart"
            End If
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
            Connect.ClearParams()
            Connect.AddParam("@user_id", currentUser.user_id)
            Connect.Query(deleteQuery)

            ShowAlert("Cart cleared successfully!", True)
            LoadCartItems()
        Catch ex As Exception
            ShowAlert("Error clearing cart: " & ex.Message, False)
        End Try
    End Sub

    Protected Sub CheckoutButton_Click(ByVal sender As Object, ByVal e As EventArgs)
        ' Process checkout steps - simplified version
        System.Diagnostics.Debug.WriteLine("CheckoutButton_Click called")
        
        ' Update order summary
        UpdateOrderSummary()
        
        ' Show success message
        ShowAlert("Ready to proceed with checkout. Please click 'Place Order' to complete your purchase.", True)
    End Sub

    Protected Sub PlaceOrderButton_Click(ByVal sender As Object, ByVal e As EventArgs)
        Try
            ' Get the current user
            Dim currentUser As User = DirectCast(Session("CURRENT_SESSION"), User)
            
            ' Process the order using the cart items
            Dim cartTotal As Decimal = GetCartTotal()
            
            If cartTotal <= 0 Then
                ShowAlert("Your cart is empty. Please add items before placing an order.", False)
                Return
            End If

            ' Get payment method (defaulting to cash if not specified)
            Dim paymentMethod As String = "cash"
            If Request.Form("paymentMethod") IsNot Nothing Then
                paymentMethod = Request.Form("paymentMethod").ToString()
            End If

            ' Get delivery fee from hidden field
            Dim deliveryFee As Decimal = 0
            If Not String.IsNullOrEmpty(DeliveryFeeHidden.Value) Then
                deliveryFee = Convert.ToDecimal(DeliveryFeeHidden.Value)
            End If
            
            ' Calculate grand total
            Dim discount As Decimal = 0
            Dim selectedDiscount As Discount = TryCast(Session("SelectedDiscount"), Discount)
            If selectedDiscount IsNot Nothing Then
                If selectedDiscount.DiscountType = 1 Then
                    ' Percentage discount
                    discount = Math.Floor(cartTotal * (selectedDiscount.Value / 100))
                Else
                    ' Fixed amount discount
                    discount = selectedDiscount.Value
                End If
            End If

            Dim grandTotal As Decimal = cartTotal - discount + deliveryFee
            
            ' Insert a basic order record
            Dim orderQuery As String = "INSERT INTO orders (user_id, order_date, status, subtotal, discount, " & _
                                     "delivery_fee, total_amount, payment_method) " & _
                                     "VALUES (@user_id, GETDATE(), 'pending', @subtotal, @discount, " & _
                                     "@delivery_fee, @total_amount, @payment_method)"
            
            Connect.ClearParams()
            Connect.AddParam("@user_id", currentUser.user_id)
            Connect.AddParam("@subtotal", cartTotal)
            Connect.AddParam("@discount", discount)
            Connect.AddParam("@delivery_fee", deliveryFee)
            Connect.AddParam("@total_amount", grandTotal)
            Connect.AddParam("@payment_method", paymentMethod)
            Connect.Query(orderQuery)
            
            ' Get the new order ID
            Dim orderIdQuery As String = "SELECT MAX(order_id) FROM orders WHERE user_id = @user_id"
            Connect.ClearParams()
            Connect.AddParam("@user_id", currentUser.user_id)
            Connect.Query(orderIdQuery)
            
            Dim orderId As Integer = 0
            If Connect.DataCount > 0 AndAlso Connect.Data.Tables(0).Rows.Count > 0 Then
                orderId = Convert.ToInt32(Connect.Data.Tables(0).Rows(0)(0))
            End If

            If orderId > 0 Then
                ' Copy cart items to order_items
                Dim orderItemsQuery As String = "INSERT INTO order_items (order_id, item_id, quantity, price) " & _
                                             "SELECT @order_id, c.item_id, c.quantity, m.price " & _
                                             "FROM cart c " & _
                                             "JOIN menu m ON c.item_id = m.item_id " & _
                                             "WHERE c.user_id = @user_id"
                
                Connect.ClearParams()
                Connect.AddParam("@order_id", orderId)
                Connect.AddParam("@user_id", currentUser.user_id)
                Connect.Query(orderItemsQuery)
                
                ' Clear the cart
                Dim clearCartQuery As String = "DELETE FROM cart WHERE user_id = @user_id"
                Connect.ClearParams()
                Connect.AddParam("@user_id", currentUser.user_id)
                Connect.Query(clearCartQuery)
                
                ' Clear session discount
                Session("SelectedDiscountId") = Nothing
                Session("SelectedDiscount") = Nothing
                
                ' Show success message and redirect
                ShowAlert("Order placed successfully! Your order ID is " & orderId, True)
                Response.Redirect("~/Pages/Customer/CustomerOrders.aspx")
            Else
                ShowAlert("Failed to create order. Please try again.", False)
            End If

                Catch ex As Exception
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

    Protected Sub ShowNewAddressButton_Click(ByVal sender As Object, ByVal e As EventArgs)
        ' Show delivery options panel and address form
        '
        '

        ' Force the form to be visible by removing any inline style
        '

        ' Reload addresses to ensure the form is correctly displayed
        LoadCustomerAddresses()

        ' Update the UI
        UpdateOrderSummary()
    End Sub

    Protected Sub CancelAddressButton_Click(ByVal sender As Object, ByVal e As EventArgs)
        ' Hide the new address form
        '

        ' Apply CSS to ensure it's hidden
        ' = "display: none;"

        ' Update the UI
        LoadCustomerAddresses() ' Reload the addresses
        UpdateOrderSummary()
    End Sub

    Private Sub HideNewAddressForm()
        ' Method simplified to avoid errors with missing controls
        System.Diagnostics.Debug.WriteLine("HideNewAddressForm called")
    End Sub

    Private Sub ShowNewAddressForm()
        ' Method simplified to avoid errors with missing controls
        System.Diagnostics.Debug.WriteLine("ShowNewAddressForm called")
    End Sub

    Private Sub UpdateCartSummary()
        Try
            Dim currentUser As User = DirectCast(Session("CURRENT_SESSION"), User)
            
            ' Get cart items
            Dim query As String = "SELECT SUM(m.price * c.quantity) AS subtotal, COUNT(c.cart_id) AS item_count " & _
                                  "FROM cart c " & _
                                  "INNER JOIN menu m ON c.item_id = m.item_id " & _
                                  "WHERE c.user_id = @user_id"
            Connect.ClearParams()
            Connect.AddParam("@user_id", currentUser.user_id)
            Connect.Query(query)
            
            If Connect.DataCount > 0 AndAlso Connect.Data.Tables(0).Rows.Count > 0 Then
                Dim row As DataRow = Connect.Data.Tables(0).Rows(0)
                Dim subtotal As Decimal = If(DBNull.Value.Equals(row("subtotal")), 0, Convert.ToDecimal(row("subtotal")))
                Dim itemCount As Integer = If(DBNull.Value.Equals(row("item_count")), 0, Convert.ToInt32(row("item_count")))
                
                ' Set subtotal
                CartSummarySubtotalLiteral.Text = subtotal.ToString("0.00")
                ' Also set it in the Order Summary section
                OrderSummarySubtotalLiteral.Text = subtotal.ToString("0.00")
                
                ' Set item count
                CartSummaryItemsLiteral.Text = itemCount.ToString()
                
                ' Calculate any applicable discounts
                Dim totalDiscount As Decimal = 0
                
                ' 1. Apply selected discount if any
                Dim selectedDiscount As Discount = TryCast(Session("SelectedDiscount"), Discount)
                If selectedDiscount IsNot Nothing Then
                    Dim discountAmount As Decimal = If(selectedDiscount.DiscountType = 1, 
                                                       Math.Floor(subtotal * (selectedDiscount.Value / 100)), 
                                                       selectedDiscount.Value)
                    
                    DiscountAmountLiteral.Text = discountAmount.ToString("0.00")
                    OrderSummaryDiscountLiteral.Text = discountAmount.ToString("0.00")
                    DiscountRow.Visible = True
                    OrderSummaryDiscountRow.Visible = True
                    totalDiscount += discountAmount
                Else
                    DiscountRow.Visible = False
                    OrderSummaryDiscountRow.Visible = False
                End If
                
                ' 2. Apply any active promotions
                ' (Promotion handling code would go here)
                
                ' 3. Apply any applicable deals
                ' (Deal handling code would go here)
                
                ' Calculate grand total (subtotal - discounts)
                Dim grandTotal As Decimal = subtotal - totalDiscount
                
                ' Add delivery fee if applicable
                If Not String.IsNullOrEmpty(DeliveryFeeHidden.Value) Then
                    grandTotal += Convert.ToDecimal(DeliveryFeeHidden.Value)
                End If
                
                ' Update totals
                CartSummaryTotalLiteral.Text = grandTotal.ToString("0.00")
                OrderSummaryTotalLiteral.Text = grandTotal.ToString("0.00")
            Else
                ' No items in cart
                CartSummarySubtotalLiteral.Text = "0.00"
                OrderSummarySubtotalLiteral.Text = "0.00"
                CartSummaryItemsLiteral.Text = "0"
                CartSummaryTotalLiteral.Text = "0.00"
                OrderSummaryTotalLiteral.Text = "0.00"
                DiscountRow.Visible = False
                OrderSummaryDiscountRow.Visible = False
            End If
        Catch ex As Exception
            ' Log error and show message
            ShowAlert("Error updating cart summary: " & ex.Message, False)
        End Try
    End Sub

    ' Add the missing ApplySelectedDiscount method
    Private Sub ApplySelectedDiscount()
        Try
            ' Check if a discount is selected in the session
            If Session("SelectedDiscountId") IsNot Nothing Then
                Dim selectedDiscountId As String = Session("SelectedDiscountId").ToString()
                
                ' Find and select the discount in the dropdown
                Dim foundItem As ListItem = DiscountDropDown.Items.FindByValue(selectedDiscountId)
                If foundItem IsNot Nothing Then
                    foundItem.Selected = True
                    
                    ' Get the discount details
                    Dim discount As Discount = GetDiscountById(selectedDiscountId)
                    
                    If discount IsNot Nothing Then
                        ' Store the discount in session
                        Session("SelectedDiscount") = discount
                        
                        ' Show discount info
                        DiscountNameLiteral.Text = discount.Name
                        DiscountDescriptionLiteral.Text = discount.Description
                        
                        ' Format the discount value
                        Dim valueText As String = ""
                        If discount.DiscountType = 1 Then
                            valueText = discount.Value & "% off"
                        Else
                            valueText = "PHP " & discount.Value.ToString("0.00") & " off"
                        End If
                        
                        DiscountValueLiteral.Text = valueText
                        DiscountInfo.Visible = True
                        
                        ' Update hidden fields
                        DiscountIdHidden.Value = selectedDiscountId
                        DiscountValueHidden.Value = discount.Value.ToString()
                    End If
                End If
            End If
        Catch ex As Exception
            ' Log error but continue
            System.Diagnostics.Debug.WriteLine("Error applying selected discount: " & ex.Message)
        End Try
    End Sub

    Private Sub LoadCustomerAddresses()
        Try
            Dim currentUser As User = DirectCast(Session("CURRENT_SESSION"), User)
            Dim userId As Integer = currentUser.user_id

            ' Query to get all customer addresses
            Dim query As String = "SELECT address_id, address_name, recipient_name, contact_number, " & _
                                 "address_line, city, postal_code, is_default, coordinates " & _
                                 "FROM customer_addresses " & _
                                 "WHERE user_id = @UserId " & _
                                 "ORDER BY is_default DESC, date_added DESC"

            Connect.ClearParams()
            Connect.AddParam("@UserId", userId)
            Connect.Query(query)

            If Connect.DataCount > 0 AndAlso Connect.Data.Tables(0).Rows.Count > 0 Then
                ' Found addresses for this user
                System.Diagnostics.Debug.WriteLine("Found " & Connect.Data.Tables(0).Rows.Count & " addresses for user " & userId)
            Else
                ' No addresses found
                System.Diagnostics.Debug.WriteLine("No addresses found for user " & userId)
            End If
        Catch ex As Exception
            ' Log error and show message to user
            System.Diagnostics.Debug.WriteLine("Error loading addresses: " & ex.Message)
        End Try
    End Sub

    Protected Sub AddressRadioList_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs)
        ' Method simplified to avoid errors with missing controls
        System.Diagnostics.Debug.WriteLine("AddressRadioList_SelectedIndexChanged called")
    End Sub

    Protected Sub SaveAddressButton_Click(ByVal sender As Object, ByVal e As EventArgs)
        ' Method simplified to avoid errors with missing controls
        System.Diagnostics.Debug.WriteLine("SaveAddressButton_Click called - address functionality will be implemented later")
        ShowAlert("Address functionality is not yet implemented", False)
    End Sub
End Class
