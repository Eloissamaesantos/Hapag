Partial Class CustomerLoginPortal
    Inherits System.Web.UI.Page

    Dim Util As New DBUtils()

    Protected Sub Button1_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles Button1.Click
        Dim username As String = usernameTxt.Text
        Dim password As String = passwordTxt.Text

        Dim login = Util.LoginUser(username, password)

        If login IsNot Nothing Then
            ' Create User object and store in session
            Dim currentUser As New User()
            currentUser.user_id = Convert.ToInt32(login("user_id"))
            currentUser.username = login("username").ToString() 
            currentUser.display_name = login("display_name").ToString()
            
            ' Handle user_type conversion properly
            Try
                ' Try to convert user_type to integer
                currentUser.user_type = Convert.ToInt32(login("user_type"))
            Catch ex As Exception
                currentUser.user_type = 3 ' Default to customer
            End Try

            Session("CURRENT_SESSION") = currentUser

            Dim message As String = "Successfully Login!"
            Dim script As String = "alert('" & message.Replace("'", "\'") & "'); location.replace('../Customer/CustomerDashboard.aspx');"
            ClientScript.RegisterStartupScript(Me.GetType(), "ShowAlert", script, True)
        Else
            Dim message As String = "Failed to Login"
            Dim script As String = "alert('" & message.Replace("'", "\'") & "');"
            ClientScript.RegisterStartupScript(Me.GetType(), "ShowAlert", script, True)
        End If
    End Sub
End Class
