Imports System.Data

Public Class Pages_Customer_RegisterPortal
    Inherits System.Web.UI.Page

    Dim Connect As New Connection()

    Protected Sub Button1_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles Button1.Click
        Try
            ' Get form values
            Dim username As String = usernameTxt.Text.Trim()
            Dim password As String = passwordTxt.Text
            Dim displayName As String = displayNameTxt.Text.Trim()

            ' Validate username doesn't exist
            Dim checkQuery As String = "SELECT COUNT(*) FROM users WHERE username = @username"
            Connect.AddParam("@username", username)
            Connect.Query(checkQuery)

            If Connect.Data.Tables(0).Rows(0)(0) > 0 Then
                ShowAlert("Username already exists. Please choose a different username.", False)
                Return
            End If

            ' Create new connection for insert
            Connect = New Connection()

            ' Insert new user (always as customer with user_type = 3)
            Dim insertQuery As String = "INSERT INTO users (username, password, display_name, user_type) VALUES (@username, @password, @display_name, @user_type)"
            
            With Connect
                .AddParam("@username", username)
                .AddParam("@password", password)
                .AddParam("@display_name", displayName)
                .AddParam("@user_type", 3) ' 3 = customer
                .Query(insertQuery)
            End With

            ' Show success message and redirect
            ShowAlert("Registration successful! Please log in.", True)
            Response.Redirect("CustomerLoginPortal.aspx")

        Catch ex As Exception
            ShowAlert("Registration failed: " & ex.Message, False)
        End Try
    End Sub

    Private Sub ShowAlert(ByVal message As String, ByVal isSuccess As Boolean)
        Dim script As String = String.Format("alert('{0}');", message.Replace("'", "\'"))
        If isSuccess Then
            script &= String.Format("window.location = '{0}';", ResolveUrl("CustomerLoginPortal.aspx"))
        End If
        ClientScript.RegisterStartupScript(Me.GetType(), "ShowAlert", script, True)
    End Sub
End Class
