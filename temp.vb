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

    Protected WithEvents AddressRadioList As RadioButtonList
    Protected WithEvents calculatedDistanceDisplay As HtmlGenericControl
