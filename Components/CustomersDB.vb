Imports System
Imports System.Configuration
Imports System.Data
Imports System.Data.SqlClient

Namespace IBuySpy

    '*******************************************************
    '
    ' CustomerDetails Class
    '
    ' A simple data class that encapsulates details about
    ' a particular customer inside the IBuySpy Customer
    ' database.
    '
    '*******************************************************

    Public Class CustomerDetails

        Public FullName As String
        Public Email As String
        Public Password As String

    End Class

    '*******************************************************
    '
    ' CustomersDB Class
    '
    ' Business/Data Logic Class that encapsulates all data
    ' logic necessary to add/login/query customers within
    ' the IBuySpy Customer database.
    '
    '*******************************************************

    Public Class CustomersDB

        '*******************************************************
        '
        ' CustomersDB.GetCustomerDetails() Method <a name="GetCustomerDetails"></a>
        '
        ' The GetCustomerDetails method returns a CustomerDetails
        ' struct that contains information about a specific
        ' customer (name, email, password, etc).
        '
        ' Other relevant sources:
        '     + <a href="CustomerDetail.htm" style="color:green">CustomerDetail Stored Procedure</a>
        '
        '*******************************************************

        Public Function GetCustomerDetails(ByVal customerID As String) As CustomerDetails


            ' Create Instance of Connection and Command Object
            Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
            Dim myCommand As SqlCommand = New SqlCommand("CustomerDetail", myConnection)

            ' Mark the Command as a SPROC
            myCommand.CommandType = CommandType.StoredProcedure

            ' Add Parameters to SPROC
            Dim parameterCustomerID As SqlParameter = New SqlParameter("@CustomerID", SqlDbType.Int, 4)
            parameterCustomerID.Value = CInt(customerID)
            myCommand.Parameters.Add(parameterCustomerID)

            Dim parameterFullName As SqlParameter = New SqlParameter("@FullName", SqlDbType.NVarChar, 50)
            parameterFullName.Direction = ParameterDirection.Output
            myCommand.Parameters.Add(parameterFullName)

            Dim parameterEmail As SqlParameter = New SqlParameter("@Email", SqlDbType.NVarChar, 50)
            parameterEmail.Direction = ParameterDirection.Output
            myCommand.Parameters.Add(parameterEmail)

'

            Dim parameterPassword As SqlParameter = New SqlParameter("@Password", SqlDbType.NVarChar, 50)
            parameterPassword.Direction = ParameterDirection.Output
            myCommand.Parameters.Add(parameterPassword)

            myConnection.Open()
            myCommand.ExecuteNonQuery()
            myConnection.Close()

            ' Create CustomerDetails Struct
            Dim myCustomerDetails As CustomerDetails = New CustomerDetails()

            ' Populate Struct using Output Params from SPROC
            myCustomerDetails.FullName = CStr(parameterFullName.Value)
            myCustomerDetails.Password = CStr(parameterPassword.Value)
            myCustomerDetails.Email = CStr(parameterEmail.Value)

            Return myCustomerDetails

        End Function


        '*******************************************************
        '
        ' CustomersDB.AddCustomer() Method <a name="AddCustomer"></a>
        '
        ' The AddCustomer method inserts a new customer record
        ' into the customers database.  A unique "CustomerId"
        ' key is then returned from the method.  This can be
        ' used later to place orders, track shopping carts,
        ' etc within the ecommerce system.
        '
        ' Other relevant sources:
        '     + <a href="CustomerAdd.htm" style="color:green">CustomerAdd Stored Procedure</a>
        '
        '*******************************************************

        Public Function AddCustomer(fullName As String, email As String,Add1 as string ,Add2 as string,password As String,Country1 As String,State1 As String,Type1 As String,ZipCode1 As String,Tel1 As String,Tel2 As String) As String

            ' Create Instance of Connection and Command Object
            Dim myConnection As New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
            Dim myCommand As New SqlCommand("CustomerAdd", myConnection)

            ' Mark the Command as a SPROC
            myCommand.CommandType = CommandType.StoredProcedure

            ' Add Parameters to SPROC
            Dim parameterFullName As New SqlParameter("@FullName", SqlDbType.NVarChar, 50)
            parameterFullName.Value = fullName
            myCommand.Parameters.Add(parameterFullName)

            Dim parameterEmail As New SqlParameter("@Email", SqlDbType.NVarChar, 50)
            parameterEmail.Value = email
            myCommand.Parameters.Add(parameterEmail)


            Dim parameterAdd1 As New SqlParameter("@Add1", SqlDbType.NVarChar, 100)
            parameterAdd1.Value = Add1
            myCommand.Parameters.Add(parameterAdd1)

            Dim parameterAdd2 As New SqlParameter("@Add2", SqlDbType.NVarChar, 100)
            parameterAdd2.Value = Add2
            myCommand.Parameters.Add(parameterAdd2)

            Dim parameterPassword As New SqlParameter("@Password", SqlDbType.NVarChar, 50)
            parameterPassword.Value = password
            myCommand.Parameters.Add(parameterPassword)

            Dim parameterCustomerID As New SqlParameter("@CustomerID", SqlDbType.Int, 4)
            parameterCustomerID.Direction = ParameterDirection.Output
            myCommand.Parameters.Add(parameterCustomerID)
'Add in
            Dim parameterState As New SqlParameter("@State1", SqlDbType.NVarChar, 100)
            parameterState.Value = State1
            myCommand.Parameters.Add(parameterState)
'Add in
            Dim parameterCountry As New SqlParameter("@Country1", SqlDbType.NVarChar, 100)
            parameterCountry.Value = Country1
            myCommand.Parameters.Add(parameterCountry)
'Add in
            Dim parameterUserType As New SqlParameter("@Type1", SqlDbType.NVarChar, 100)
            parameterUserType.Value = Type1
            myCommand.Parameters.Add(parameterUserType)

            Dim parameterZipCode As New SqlParameter("@ZipCode1", SqlDbType.NVarChar, 20)
            parameterZipCode.Value = ZipCode1
            myCommand.Parameters.Add(parameterZipCode)

            Dim parameterTel1 As New SqlParameter("@Tel1", SqlDbType.NVarChar, 20)
            parameterTel1.Value = Tel1
            myCommand.Parameters.Add(parameterTel1)

            Dim parameterTel2 As New SqlParameter("@Tel2", SqlDbType.NVarChar, 20)
            parameterTel2.Value = Tel2
            myCommand.Parameters.Add(parameterTel2)

            Try
                myConnection.Open()
                myCommand.ExecuteNonQuery()
                myConnection.Close()
                ' Calculate the CustomerID using Output Param from SPROC
                Dim customerId As Integer = CInt(parameterCustomerID.Value)
                Return customerId.ToString()
            Catch
                Return String.Empty
            End Try

        End Function


        '*******************************************************
        '
        ' CustomersDB.Login() Method <a name="Login"></a>
        '
        ' The Login method validates a email/password pair
        ' against credentials stored in the customers database.
        ' If the email/password pair is valid, the method returns
        ' the "CustomerId" number of the customer.  Otherwise
        ' it will throw an exception.
        '
        ' Other relevant sources:
        '     + <a href="CustomerLogin.htm" style="color:green">CustomerLogin Stored Procedure</a>
        '
        '*******************************************************

        Public Function Login(ByVal email As String, ByVal password As String) As String


            ' Create Instance of Connection and Command Object
            Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
            Dim myCommand As SqlCommand = New SqlCommand("CustomerLogin", myConnection)

            ' Mark the Command as a SPROC
            myCommand.CommandType = CommandType.StoredProcedure

            ' Add Parameters to SPROC
            Dim parameterEmail As SqlParameter = New SqlParameter("@Email", SqlDbType.NVarChar, 50)
            parameterEmail.Value = email
            myCommand.Parameters.Add(parameterEmail)

            Dim parameterPassword As SqlParameter = New SqlParameter("@Password", SqlDbType.NVarChar, 50)
            parameterPassword.Value = password
            myCommand.Parameters.Add(parameterPassword)

            Dim parameterCustomerID As SqlParameter = New SqlParameter("@CustomerID", SqlDbType.Int, 4)
            parameterCustomerID.Direction = ParameterDirection.Output
            myCommand.Parameters.Add(parameterCustomerID)

            Dim parameterType As SqlParameter = New SqlParameter("@Type", SqlDbType.nvarchar, 20)
            parameterType.Direction = ParameterDirection.Output
            myCommand.Parameters.Add(parameterType)

            ' Open the connection and execute the Command
            myConnection.Open()
            myCommand.ExecuteNonQuery()
            myConnection.Close()

            Dim customerId As Integer = CInt(parameterCustomerID.Value)

            If customerId = 0 Then
                Return Nothing
            Else
                Return customerId.ToString()
            End If

        End Function

Public Function CustomerType(ByVal customerID As String) As string
            Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
            Dim myCommand As SqlCommand = New SqlCommand("CustomerType", myConnection)

            myCommand.CommandType = CommandType.StoredProcedure

            Dim parameterCustomerID As SqlParameter = New SqlParameter("@CustomerID", SqlDbType.NVarChar, 50)
            parameterCustomerID.Value = customerID
            myCommand.Parameters.Add(parameterCustomerID)

            Dim parameterCustomerType As SqlParameter = New SqlParameter("@Type1", SqlDbType.NVarchar, 20)
            parameterCustomerType.Direction = ParameterDirection.Output
            myCommand.Parameters.Add(parameterCustomerType)

            myConnection.Open()
            myCommand.ExecuteNonQuery()
            myConnection.Close()

            ' Return the Total
            If parameterCustomerType.Value.ToString() <> "" Then
                Return CType(parameterCustomerType.Value, string)
            Else
                Return 0
            End If

        End Function

    End Class

End Namespace

