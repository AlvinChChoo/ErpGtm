Imports System
Imports System.Configuration
Imports System.Data
Imports System.Data.SqlClient
Imports System.DateTime
imports System.String

Namespace ERP_GTM

   Public Class ERP_GTM
        Public MRPNo as integer
        Public Function GetDocumentNo(FieldName as string)
            Dim ToDay as System.DateTime = System.DateTime.now
            DIm CurrYear as String = ToDay.year
            DIm CurrMonth as String = Convert.ToInt32(ToDay.month)
            Dim SeqNo as String

            CurrYear = CurrYear.subString(0,1) & CurrYear.subString(3,1)

            if Convert.ToInt32(CurrMonth) <= 9 then CurrMonth = "0" & CurrMonth

            Dim strSql as string = "Select " & FieldName & " from Main"
            Dim Result as string
            Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
            myConnection.Open()
            Dim myCommand As SqlCommand = New SqlCommand(StrSql, myConnection)
            Dim drGetFieldVal As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)

            do while drGetFieldVal.read
                SeqNo = drGetFieldVal(FieldName).tostring
            loop
                if SeqNo.length = 1 then Result = CurrYear & CurrMonth & "000" & SeqNo
                if SeqNo.length = 2 then  Result = CurrYear & CurrMonth & "00" &  SeqNo
                if SeqNo.length = 3 then  Result = CurrYear & CurrMonth & "0" &  SeqNo
                if SeqNo.length = 4 then  Result = CurrYear & CurrMonth & SeqNo
            Return result
            drGetFieldVal.close()
            myCommand.dispose()
            myConnection.Close()
            myConnection.Dispose()

        End Function

        Public Function funcCheckDuplicate(ByVal strSql As String,FName as string) As boolean
            Dim Result as string = false
            Dim CurrVal as string
            Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
            myConnection.Open()
            Dim myCommand As SqlCommand = New SqlCommand(StrSql, myConnection)
            Dim drGetFieldVal As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)

            do while drGetFieldVal.read
                CurrVal = drGetFieldVal(FName).tostring
            loop
            if CurrVal <> "" then result = true else result = false
            Return result
            drGetFieldVal.close()
            myCommand.dispose()
            myConnection.Close()
            myConnection.Dispose()

        End Function

        Public Function GetUsername(ByVal U_ID as string) as string
            Dim strSql as string = "Select Mod_Name from Mod_Reg_M where U_ID = '" & U_ID & "' order By Mod_Name asc"
            Dim Result as string
            Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
            myConnection.Open()
            Dim myCommand As SqlCommand = New SqlCommand(StrSql, myConnection)
            Dim drGetFieldVal As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)

            do while drGetFieldVal.read
                Result = drGetFieldVal(U_ID).tostring
            loop
            Return result
            drGetFieldVal.close()
            myCommand.dispose()
            myConnection.Close()
            myConnection.Dispose()
        end function

        Public Function Dissql(ByVal strSql As String) As SqlDataReader
            Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
            myConnection.Open()
            Dim myCommand As SqlCommand = New SqlCommand(StrSql, myConnection)
            Dim result As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
            Return result

            myCommand.dispose()
            myConnection.Close()
            myConnection.Dispose()
            result.close()
        End Function

        Public Function GetFieldVal(ByVal strSql As String,FName as string) As string
            Dim Result as string
            Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
            myConnection.Open()
            Dim myCommand As SqlCommand = New SqlCommand(StrSql, myConnection)
            Dim drGetFieldVal As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)

            do while drGetFieldVal.read
                Result = drGetFieldVal(FName).tostring
            loop

            Return result
            myCommand.dispose()
            drGetFieldVal.close()
            myConnection.Close()
            myConnection.Dispose()

        End Function

        Public Function ExeDataReader(ByVal strSql As String) As SqlDataReader
            Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
            myConnection.Open()
            Dim myCommand As SqlCommand = New SqlCommand(StrSql, myConnection)
            Dim result As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)

            Return result
            myCommand.dispose()
            myConnection.Close()
            myConnection.Dispose()

        End Function

        Sub ExecuteNonQuery(ByVal SQL As String)
            Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
            myConnection.Open()
            Dim myCommand As New sqlCommand
            myCommand.Connection = myConnection
            myCommand.CommandText = SQL
            myCommand.CommandType = CommandType.Text
            myCommand.ExecuteNonQuery()

            myConnection.Close()
            myCommand.Dispose()
            myConnection.Dispose()
        End Sub



        Public Sub TariffUpdate(ByVal TARIFF_CODE As STRING,ByVal TARIFF_DESC AS STRING)
            Dim myConnection As SqlConnection
            Dim myCommand As SqlCommand
            Dim paramTariffCode As SqlParameter
            Dim paramTariffDesc As SqlParameter

            myConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
            myCommand= New SqlCommand("TARIFF_UPDATE", myConnection)
            myCommand.CommandType = CommandType.StoredProcedure

            paramTariffCode = New SqlParameter("@TARIFF_CODE", SqlDbType.nvarchar, 20)
            paramTariffCode.Value = TARIFF_CODE
            myCommand.Parameters.Add(paramTariffCode)

            paramTariffDesc = New SqlParameter("@TARIFF_DESC", SqlDbType.nvarchar, 30)
            paramTariffDesc.Value = TARIFF_DESC
            myCommand.Parameters.Add(paramTariffDesc)

            myConnection.Open()
            myCommand.ExecuteNonQuery()
            myCommand.dispose()
            myConnection.Close()
            myConnection.dispose()
        End Sub

        Public Sub TariffRemove(ByVal TARIFF_CODE As STRING)
            Dim myConnection As SqlConnection
            Dim myCommand As SqlCommand
            Dim paramTariffCode As SqlParameter

            myConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
            myCommand = New SqlCommand("TARIFF_REMOVE", myConnection)
            myCommand.CommandType = CommandType.StoredProcedure

            paramTariffCode = New SqlParameter("@TARIFF_CODE", SqlDbType.nvarchar, 20)
            paramTariffCode.Value = TARIFF_CODE
            myCommand.Parameters.Add(paramTariffCode)

            myConnection.Open()
            myCommand.ExecuteNonQuery()
            myCommand.dispose()
            myConnection.Close()

            myConnection.Dispose()
        End Sub

        Public Sub TariffAdd(ByVal TARIFF_CODE As STRING,ByVal TARIFF_DESC AS STRING)
            Dim myConnection As SqlConnection
            Dim myCommand As SqlCommand
            Dim paramTariffCode As SqlParameter
            Dim paramTariffDesc As SqlParameter

            myConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
            myCommand= New SqlCommand("TARIFF_ADD", myConnection)
            myCommand.CommandType = CommandType.StoredProcedure

            paramTariffCode = New SqlParameter("@TARIFF_CODE", SqlDbType.nvarchar, 20)
            paramTariffCode.Value = TARIFF_CODE
            myCommand.Parameters.Add(paramTariffCode)

            paramTariffDesc = New SqlParameter("@TARIFF_DESC", SqlDbType.nvarchar, 30)
            paramTariffDesc.Value = TARIFF_CODE
            myCommand.Parameters.Add(paramTariffDesc)

            myConnection.Open()
            myCommand.ExecuteNonQuery()
            myCommand.dispose()

            myConnection.Close()
            myConnection.Dispose()
        End Sub

        Public Sub CurrAdd(ByVal Curr_Code As STRING,ByVal Curr_Desc As STRING,ByVal UNIT_CONV As decimal,ByVal RATE As decimal,ByVal US_DLR As decimal)
            Dim myConnection As SqlConnection
            Dim myCommand As SqlCommand
            Dim paramCurrCode As SqlParameter
            Dim paramCurrDesc As SqlParameter
            Dim paramUnitConv As SqlParameter
            Dim paramRate As SqlParameter
            Dim paramUsDlr As SqlParameter

            myConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
            myCommand= New SqlCommand("Currency_ADD", myConnection)
            myCommand.CommandType = CommandType.StoredProcedure

            paramCurrCode = New SqlParameter("@CURR_CODE", SqlDbType.nvarchar, 10)
            paramCurrCode.Value = Curr_Code
            myCommand.Parameters.Add(paramCurrCode)

            paramCurrDesc = New SqlParameter("@CURR_DESC", SqlDbType.nvarchar, 30)
            paramCurrDesc.Value = Curr_Desc
            myCommand.Parameters.Add(paramCurrDesc)

            paramUnitConv = New SqlParameter("@UNIT_CONV", SqlDbType.money)
            paramUnitConv.Value = Unit_Conv
            myCommand.Parameters.Add(paramUnitConv)

            paramRate = New SqlParameter("@RATE", SqlDbType.money)
            paramRate.Value = Rate
            myCommand.Parameters.Add(paramRate)

            paramUsDlr = New SqlParameter("@US_DLR", SqlDbType.money)
            paramUsDlr.Value = US_DLR
            myCommand.Parameters.Add(paramUsDlr)

            myConnection.Open()
            myCommand.ExecuteNonQuery()
            myCommand.dispose()
            myConnection.Close()
            myConnection.Dispose()
        End Sub

        Public Sub UserProfileAdd(ByVal U_NAME As STRING,ByVal U_ID As STRING,ByVal PWD As STRING,ByVal USER_TYPE As STRING,ByVal ACTIVE As STRING,ByVal COSTING As STRING,ByVal DEPT_CODE As STRING,ByVal USER_POST As STRING,ByVal CONTACT_NO As STRING,ByVal EMAIL As STRING)
            Dim myConnection As SqlConnection
            Dim myCommand As SqlCommand
            Dim paramUsDlr As SqlParameter

            myConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
            myCommand= New SqlCommand("USER_PROFILE_ADD", myConnection)
            myCommand.CommandType = CommandType.StoredProcedure

            Dim paramUName As SqlParameter = New SqlParameter("@U_NAME", SqlDbType.nvarchar, 30)
            paramUName.Value = U_NAME
            myCommand.Parameters.Add(paramUName)

            Dim paramUID As SqlParameter = New SqlParameter("@U_ID", SqlDbType.nvarchar, 20)
            paramUID.Value = U_ID
            myCommand.Parameters.Add(paramUID)

            Dim paramPwd As SqlParameter  = New SqlParameter("@PWD", SqlDbType.nvarchar, 20)
            paramPwd.Value = PWD
            myCommand.Parameters.Add(paramPwd)

            Dim paramUserType As SqlParameter = New SqlParameter("@USER_TYPE", SqlDbType.nvarchar, 5)
            paramUserType.Value = USER_TYPE
            myCommand.Parameters.Add(paramUserType)

            Dim paramActive As SqlParameter = New SqlParameter("@ACTIVE", SqlDbType.nvarchar, 3)
            paramActive.Value = ACTIVE
            myCommand.Parameters.Add(paramActive)

            Dim paramCosting As SqlParameter = New SqlParameter("@COSTING", SqlDbType.nvarchar, 3)
            paramCosting.Value = COSTING
            myCommand.Parameters.Add(paramCosting)

            Dim paramDeptCode As SqlParameter  = New SqlParameter("@DEPT_CODE", SqlDbType.nvarchar, 20)
            paramDeptCode.Value = DEPT_CODE
            myCommand.Parameters.Add(paramDeptCode)

            Dim paramUserPost As SqlParameter = New SqlParameter("@USER_POST", SqlDbType.nvarchar, 50)
            paramUserPost.Value = USER_POST
            myCommand.Parameters.Add(paramUserPost)

            Dim paramContactNo As SqlParameter = New SqlParameter("@CONTACT_NO", SqlDbType.nvarchar, 50)
            paramContactNo.Value = CONTACT_NO
            myCommand.Parameters.Add(paramContactNo)

            Dim paramEMail As SqlParameter = New SqlParameter("@EMAIL", SqlDbType.nvarchar, 50)
            paramEMail.Value = EMAIL
            myCommand.Parameters.Add(paramEMail)

            myConnection.Open()
            myCommand.ExecuteNonQuery()
            myCommand.dispose()
            myConnection.Close()
            myConnection.Dispose()
        End Sub

        Public function ExePagedDataset(ByVal strSql as string,ByVal TableName as string) as dataset
            Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
            dim ds as DataSet = new DataSet()
            dim adapter as SqlDataAdapter = new SqlDataAdapter(strSql, myConnection)
            adapter.Fill(ds,tablename)
            return ds
            ds.dispose()
            adapter.dispose()
            myConnection.Close()
            myConnection.Dispose()

        end function

        Public Sub DeptAdd(ByVal DEPT As STRING,ByVal HOD As STRING)
            Dim myConnection As SqlConnection
            Dim myCommand As SqlCommand

            myConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
            myCommand= New SqlCommand("DEPT_ADD", myConnection)
            myCommand.CommandType = CommandType.StoredProcedure

            Dim paramDept As SqlParameter = New SqlParameter("@DEPT", SqlDbType.nvarchar, 30)
            paramDept.Value = DEPT
            myCommand.Parameters.Add(paramDept)

            Dim paramHOD As SqlParameter = New SqlParameter("@HOD", SqlDbType.nvarchar, 20)
            paramHOD.Value = HOD
            myCommand.Parameters.Add(paramHOD)

            myConnection.Open()
            myCommand.ExecuteNonQuery()
            myCommand.dispose()
            myConnection.Close()
            myConnection.Dispose()
        End Sub



        Public Sub DeptRemove(ByVal DEPT As STRING)
            Dim myConnection As SqlConnection
            Dim myCommand As SqlCommand
            Dim paramDept As SqlParameter

            myConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
            myCommand = New SqlCommand("DEPT_REMOVE", myConnection)
            myCommand.CommandType = CommandType.StoredProcedure

            paramDept = New SqlParameter("@DEPT", SqlDbType.nvarchar, 30)
            paramDept.Value = DEPT
            myCommand.Parameters.Add(paramDept)

            myConnection.Open()
            myCommand.ExecuteNonQuery()
            myCommand.dispose()
            myConnection.Close()
            myConnection.Dispose()
        End Sub



        Public Sub PayTermUpdate(ByVal NoOfDays As Integer,ByVal ModifyBy AS STRING, ByVal SEQNo as integer)
            Dim myConnection As SqlConnection
            Dim myCommand As SqlCommand

            myConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
            myCommand= New SqlCommand("PAYTERM_UPDATE", myConnection)
            myCommand.CommandType = CommandType.StoredProcedure

            Dim paramNoOfDays As SqlParameter
            paramNoOfDays = New SqlParameter("@No_Of_Days", SqlDbType.int)
            paramNoOfDays.Value = NoOfDays
            myCommand.Parameters.Add(paramNoOfDays)

            Dim paramUModifyBy As SqlParameter
            paramUModifyBy = New SqlParameter("@Modify_By", SqlDbType.nvarchar, 20)
            paramUModifyBy.Value = ModifyBy
            myCommand.Parameters.Add(paramUModifyBy)

            Dim paramSEQNo As SqlParameter
            paramSEQNo = New SqlParameter("@SEQ_No", SqlDbType.int)
            paramSEQNo.Value = SEQNo
            myCommand.Parameters.Add(paramSEQNo)


            myConnection.Open()
            myCommand.ExecuteNonQuery()
            myCommand.dispose()
            myConnection.Close()
            myConnection.Dispose()
        End Sub

        Public Sub PaytermAdd(ByVal Payterm_desc As STRING,ByVal No_Of_Days As integer,ByVal Create_By as string)
            Dim myConnection As SqlConnection
            Dim myCommand As SqlCommand

            myConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
            myCommand= New SqlCommand("PAYTERM_ADD", myConnection)
            myCommand.CommandType = CommandType.StoredProcedure

            Dim paramPayterm_desc As SqlParameter = New SqlParameter("@Payterm_desc", SqlDbType.nvarchar, 30)
            paramPayterm_desc.Value = Payterm_desc
            myCommand.Parameters.Add(paramPayterm_desc)

            Dim paramNo_Of_Days As SqlParameter = New SqlParameter("@No_Of_Days", SqlDbType.INT)
            paramNo_Of_Days.Value = No_Of_Days
            myCommand.Parameters.Add(paramNo_Of_Days)

            Dim paramCreate_By As SqlParameter = New SqlParameter("@Create_By", SqlDbType.nvarchar, 30)
            paramCreate_By.Value = Create_By
            myCommand.Parameters.Add(paramCreate_By)

            myConnection.Open()
            myCommand.ExecuteNonQuery()
            myCommand.dispose()
            myConnection.Close()
            myConnection.Dispose()
        End Sub

        Public Sub CustUpdate(BYVAL CUST_CODE AS STRING,ByVal CREDIT_LIMIT as decimal,ByVal WEB_SITE As STRING,ByVal CONSIGNEE As STRING,ByVal PAY_TERM As STRING,ByVal REQ_CQA As STRING,ByVal Cust_REM As STRING,ByVal CURR_CODE As STRING,ByVal NOTIFY_PARTY As STRING,ByVal FORWARDER As STRING,ByVal SHIP_TERM As STRING,ByVal BILL_CO As STRING,ByVal BILL_ATT As STRING,ByVal BILL_ADD1 As STRING,ByVal BILL_ADD2 As STRING,ByVal BILL_ADD3 As STRING,ByVal BILL_COUNTRY As STRING,ByVal BILL_STATE As STRING,ByVal BILL_TEL As STRING,ByVal BILL_EXT As STRING,ByVal BILL_FAX As STRING,ByVal P1_TITLE As STRING,ByVal P1_NAME As STRING,ByVal P1_EMAIL As STRING,ByVal P1_TEL As STRING,ByVal P1_EXT As STRING,ByVal P1_FAX As STRING,ByVal P2_TITLE As STRING,ByVal P2_NAME As STRING,ByVal P2_EMAIL As STRING,ByVal P2_TEL As STRING,ByVal P2_EXT As STRING,ByVal P2_FAX As STRING,ByVal A1_TITLE As STRING,ByVal A1_NAME As STRING,ByVal A1_EMAIL As STRING,ByVal A1_TEL As STRING,ByVal A1_EXT As STRING,ByVal A1_FAX As STRING,ByVal A2_TITLE As STRING,ByVal A2_NAME As STRING,ByVal A2_EMAIL As STRING,ByVal A2_TEL As STRING,ByVal A2_EXT As STRING,ByVal A2_FAX As STRING,ByVal O1_TITLE As STRING,ByVal O1_NAME As STRING,ByVal O1_EMAIL As STRING,ByVal O1_TEL As STRING,ByVal O1_EXT As STRING,ByVal O1_FAX As STRING,ByVal O2_TITLE As STRING,ByVal O2_NAME As STRING,ByVal O2_EMAIL As STRING,ByVal O2_TEL As STRING,ByVal O2_EXT As STRING,ByVal O2_FAX As STRING,ByVal MODIFY_BY  As STRING)
            Dim myConnection As SqlConnection
            Dim myCommand As SqlCommand
            myConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
            myCommand= New SqlCommand("Cust_UPDATE", myConnection)
            myCommand.CommandType = CommandType.StoredProcedure



            'CUST_CODE
            Dim paramCUST_CODE As SqlParameter = New SqlParameter("@CUST_CODE", SqlDbType.nvarchar, 30)
            paramCUST_CODE.Value = CUST_CODE
            myCommand.Parameters.Add(paramCUST_CODE)

            'CREDIT_LIMIT
            Dim paramCREDIT_LIMIT As SqlParameter = New SqlParameter("@CREDIT_LIMIT", SqlDbType.decimal)
            paramCREDIT_LIMIT.Value = CREDIT_LIMIT
            myCommand.Parameters.Add(paramCREDIT_LIMIT)

            'WEB_SITE
            Dim paramWEB_SITE As SqlParameter = New SqlParameter("@WEB_SITE", SqlDbType.nvarchar, 50)
            paramWEB_SITE.Value = WEB_SITE
            myCommand.Parameters.Add(paramWEB_SITE)

            'CONSIGNEE
            Dim paramCONSIGNEE As SqlParameter = New SqlParameter("@CONSIGNEE", SqlDbType.nvarchar, 50)
            paramCONSIGNEE.Value = CONSIGNEE
            myCommand.Parameters.Add(paramCONSIGNEE)

            'PAY_TERM
            Dim paramPAY_TERM As SqlParameter = New SqlParameter("@PAY_TERM", SqlDbType.nvarchar, 10)
            paramPAY_TERM.Value = PAY_TERM
            myCommand.Parameters.Add(paramPAY_TERM)

            'REQ_CQA
            Dim paramREQ_CQA As SqlParameter = New SqlParameter("@REQ_CQA", SqlDbType.nvarchar, 3)
            paramREQ_CQA.Value = REQ_CQA
            myCommand.Parameters.Add(paramREQ_CQA)

            'REM
            Dim paramREM As SqlParameter = New SqlParameter("@CUST_REM", SqlDbType.nvarchar, 200)
            paramREM.Value = CUST_REM
            myCommand.Parameters.Add(paramREM)

            'CURR_CODE
            Dim paramCURR_CODE As SqlParameter = New SqlParameter("@CURR_CODE", SqlDbType.nvarchar, 10)
            paramCURR_CODE.Value = CURR_CODE
            myCommand.Parameters.Add(paramCURR_CODE)

            'NOTIFY_PARTY
            Dim paramNOTIFY_PARTY As SqlParameter = New SqlParameter("@NOTIFY_PARTY", SqlDbType.nvarchar, 50)
            paramNOTIFY_PARTY.Value = NOTIFY_PARTY
            myCommand.Parameters.Add(paramNOTIFY_PARTY)

            'FORWARDER
            Dim paramFORWARDER As SqlParameter = New SqlParameter("@FORWARDER", SqlDbType.nvarchar, 50)
            paramFORWARDER.Value = FORWARDER
            myCommand.Parameters.Add(paramFORWARDER)

            'SHIP_TERM
            Dim paramSHIP_TERM As SqlParameter = New SqlParameter("@SHIP_TERM", SqlDbType.nvarchar, 10)
            paramSHIP_TERM.Value = SHIP_TERM
            myCommand.Parameters.Add(paramSHIP_TERM)

            'BILL_CO
            Dim paramBILL_CO As SqlParameter = New SqlParameter("@BILL_CO", SqlDbType.nvarchar, 50)
            paramBILL_CO.Value = BILL_CO
            myCommand.Parameters.Add(paramBILL_CO)

            'BILL_ATT
            Dim paramBILL_ATT As SqlParameter = New SqlParameter("@BILL_ATT", SqlDbType.nvarchar, 30)
            paramBILL_ATT.Value = BILL_ATT
            myCommand.Parameters.Add(paramBILL_ATT)

            'BILL_ADD1
            Dim paramBILL_ADD1 As SqlParameter = New SqlParameter("@BILL_ADD1", SqlDbType.nvarchar, 50)
            paramBILL_ADD1.Value = BILL_ADD1
            myCommand.Parameters.Add(paramBILL_ADD1)

            'BILL_ADD2
            Dim paramBILL_ADD2 As SqlParameter = New SqlParameter("@BILL_ADD2", SqlDbType.nvarchar, 50)
            paramBILL_ADD2.Value = BILL_ADD2
            myCommand.Parameters.Add(paramBILL_ADD2)

            'BILL_ADD3
            Dim paramBILL_ADD3 As SqlParameter = New SqlParameter("@BILL_ADD3", SqlDbType.nvarchar, 50)
            paramBILL_ADD3.Value = BILL_ADD3
            myCommand.Parameters.Add(paramBILL_ADD3)

            'BILL_COUNTRY
            Dim paramBILL_COUNTRY As SqlParameter = New SqlParameter("@BILL_COUNTRY", SqlDbType.nvarchar, 10)
            paramBILL_COUNTRY.Value = BILL_COUNTRY
            myCommand.Parameters.Add(paramBILL_COUNTRY)

            'BILL_STATE
            Dim paramBILL_STATE As SqlParameter = New SqlParameter("@BILL_STATE", SqlDbType.nvarchar, 10)
            paramBILL_STATE.Value = BILL_STATE
            myCommand.Parameters.Add(paramBILL_STATE)

            'BILL_TEL
            Dim paramBILL_TEL As SqlParameter = New SqlParameter("@BILL_TEL", SqlDbType.nvarchar, 20)
            paramBILL_TEL.Value = BILL_TEL
            myCommand.Parameters.Add(paramBILL_TEL)

            'BILL_EXT
            Dim paramBILL_EXT As SqlParameter = New SqlParameter("@BILL_EXT", SqlDbType.nvarchar, 10)
            paramBILL_EXT.Value = BILL_EXT
            myCommand.Parameters.Add(paramBILL_EXT)

            'BILL_FAX
            Dim paramBILL_FAX As SqlParameter = New SqlParameter("@BILL_FAX", SqlDbType.nvarchar, 20)
            paramBILL_FAX.Value = BILL_FAX
            myCommand.Parameters.Add(paramBILL_FAX)

            'P1_TITLE
            Dim paramP1_TITLE As SqlParameter = New SqlParameter("@P1_TITLE", SqlDbType.nvarchar, 20)
            paramP1_TITLE.Value = P1_TITLE
            myCommand.Parameters.Add(paramP1_TITLE)

            'P1_NAME
            Dim paramP1_NAME As SqlParameter = New SqlParameter("@P1_NAME", SqlDbType.nvarchar, 20)
            paramP1_NAME.Value = P1_NAME
            myCommand.Parameters.Add(paramP1_NAME)

            'P1_EMAIL
            Dim paramP1_EMAIL As SqlParameter = New SqlParameter("@P1_EMAIL", SqlDbType.nvarchar, 30)
            paramP1_EMAIL.Value = P1_EMAIL
            myCommand.Parameters.Add(paramP1_EMAIL)

            'P1_TEL
            Dim paramP1_TEL As SqlParameter = New SqlParameter("@P1_TEL", SqlDbType.nvarchar, 20)
            paramP1_TEL.Value = P1_TEL
            myCommand.Parameters.Add(paramP1_TEL)

            'P1_EXT
            Dim paramP1_EXT As SqlParameter = New SqlParameter("@P1_EXT", SqlDbType.nvarchar, 10)
            paramP1_EXT.Value = P1_EXT
            myCommand.Parameters.Add(paramP1_EXT)

            'P1_FAX
            Dim paramP1_FAX As SqlParameter = New SqlParameter("@P1_FAX", SqlDbType.nvarchar, 20)
            paramP1_FAX.Value = P1_FAX
            myCommand.Parameters.Add(paramP1_FAX)

            'P2_TITLE
            Dim paramP2_TITLE As SqlParameter = New SqlParameter("@P2_TITLE", SqlDbType.nvarchar, 20)
            paramP2_TITLE.Value = P2_TITLE
            myCommand.Parameters.Add(paramP2_TITLE)

            'P2_NAME
            Dim paramP2_NAME As SqlParameter = New SqlParameter("@P2_NAME", SqlDbType.nvarchar, 20)
            paramP2_NAME.Value = P2_NAME
            myCommand.Parameters.Add(paramP2_NAME)

            'P2_EMAIL
            Dim paramP2_EMAIL As SqlParameter = New SqlParameter("@P2_EMAIL", SqlDbType.nvarchar, 30)
            paramP2_EMAIL.Value = P2_EMAIL
            myCommand.Parameters.Add(paramP2_EMAIL)

            'P2_TEL
            Dim paramP2_TEL As SqlParameter = New SqlParameter("@P2_TEL", SqlDbType.nvarchar, 20)
            paramP2_TEL.Value = P2_TEL
            myCommand.Parameters.Add(paramP2_TEL)

            'P2_EXT
            Dim paramP2_EXT As SqlParameter = New SqlParameter("@P2_EXT", SqlDbType.nvarchar, 10)
            paramP2_EXT.Value = P2_EXT
            myCommand.Parameters.Add(paramP2_EXT)

            'P2_FAX
            Dim paramP2_FAX As SqlParameter = New SqlParameter("@P2_FAX", SqlDbType.nvarchar, 20)
            paramP2_FAX.Value = P2_FAX
            myCommand.Parameters.Add(paramP2_FAX)

            'A1_TITLE
            Dim paramA1_TITLE As SqlParameter = New SqlParameter("@A1_TITLE", SqlDbType.nvarchar, 20)
            paramA1_TITLE.Value = A1_TITLE
            myCommand.Parameters.Add(paramA1_TITLE)

            'A1_NAME
            Dim paramA1_NAME As SqlParameter = New SqlParameter("@A1_NAME", SqlDbType.nvarchar, 20)
            paramA1_NAME.Value = A1_NAME
            myCommand.Parameters.Add(paramA1_NAME)

            'A1_EMAIL
            Dim paramA1_EMAIL As SqlParameter = New SqlParameter("@A1_EMAIL", SqlDbType.nvarchar, 30)
            paramA1_EMAIL.Value = A1_EMAIL
            myCommand.Parameters.Add(paramA1_EMAIL)

            'A1_TEL
            Dim paramA1_TEL As SqlParameter = New SqlParameter("@A1_TEL", SqlDbType.nvarchar, 20)
            paramA1_TEL.Value = A1_TEL
            myCommand.Parameters.Add(paramA1_TEL)

            'A1_EXT
            Dim paramA1_EXT As SqlParameter = New SqlParameter("@A1_EXT", SqlDbType.nvarchar, 10)
            paramA1_EXT.Value = A1_EXT
            myCommand.Parameters.Add(paramA1_EXT)

            'A1_FAX
            Dim paramA1_FAX As SqlParameter = New SqlParameter("@A1_FAX", SqlDbType.nvarchar, 20)
            paramA1_FAX.Value = A1_FAX
            myCommand.Parameters.Add(paramA1_FAX)

            'A2_TITLE
            Dim paramA2_TITLE As SqlParameter = New SqlParameter("@A2_TITLE", SqlDbType.nvarchar, 20)
            paramA2_TITLE.Value = A2_TITLE
            myCommand.Parameters.Add(paramA2_TITLE)

            'A2_NAME
            Dim paramA2_NAME As SqlParameter = New SqlParameter("@A2_NAME", SqlDbType.nvarchar, 20)
            paramA2_NAME.Value = A2_NAME
            myCommand.Parameters.Add(paramA2_NAME)

            'A2_EMAIL
            Dim paramA2_EMAIL As SqlParameter = New SqlParameter("@A2_EMAIL", SqlDbType.nvarchar, 30)
            paramA2_EMAIL.Value = A2_EMAIL
            myCommand.Parameters.Add(paramA2_EMAIL)

            'A2_TEL
            Dim paramA2_TEL As SqlParameter = New SqlParameter("@A2_TEL", SqlDbType.nvarchar, 20)
            paramA2_TEL.Value = A2_TEL
            myCommand.Parameters.Add(paramA2_TEL)

            'A2_EXT
            Dim paramA2_EXT As SqlParameter = New SqlParameter("@A2_EXT", SqlDbType.nvarchar, 10)
            paramA2_EXT.Value = A2_EXT
            myCommand.Parameters.Add(paramA2_EXT)

            'A2_FAX
            Dim paramA2_FAX As SqlParameter = New SqlParameter("@A2_FAX", SqlDbType.nvarchar, 20)
            paramA2_FAX.Value = A2_FAX
            myCommand.Parameters.Add(paramA2_FAX)

            'O1_TITLE
            Dim paramO1_TITLE As SqlParameter = New SqlParameter("@O1_TITLE", SqlDbType.nvarchar, 20)
            paramO1_TITLE.Value = O1_TITLE
            myCommand.Parameters.Add(paramO1_TITLE)

            'O1_NAME
            Dim paramO1_NAME As SqlParameter = New SqlParameter("@O1_NAME", SqlDbType.nvarchar, 20)
            paramO1_NAME.Value = O1_NAME
            myCommand.Parameters.Add(paramO1_NAME)

            'O1_EMAIL
            Dim paramO1_EMAIL As SqlParameter = New SqlParameter("@O1_EMAIL", SqlDbType.nvarchar, 30)
            paramO1_EMAIL.Value = O1_EMAIL
            myCommand.Parameters.Add(paramO1_EMAIL)

            'O1_TEL
            Dim paramO1_TEL As SqlParameter = New SqlParameter("@O1_TEL", SqlDbType.nvarchar, 20)
            paramO1_TEL.Value = O1_TEL
            myCommand.Parameters.Add(paramO1_TEL)

            'O1_EXT
            Dim paramO1_EXT As SqlParameter = New SqlParameter("@O1_EXT", SqlDbType.nvarchar, 10)
            paramO1_EXT.Value = O1_EXT
            myCommand.Parameters.Add(paramO1_EXT)

            'O1_FAX
            Dim paramO1_FAX As SqlParameter = New SqlParameter("@O1_FAX", SqlDbType.nvarchar, 20)
            paramO1_FAX.Value = O1_FAX
            myCommand.Parameters.Add(paramO1_FAX)

            'O2_TITLE
            Dim paramO2_TITLE As SqlParameter = New SqlParameter("@O2_TITLE", SqlDbType.nvarchar, 20)
            paramO2_TITLE.Value = O2_TITLE
            myCommand.Parameters.Add(paramO2_TITLE)

            'O2_NAME
            Dim paramO2_NAME As SqlParameter = New SqlParameter("@O2_NAME", SqlDbType.nvarchar, 20)
            paramO2_NAME.Value = O2_NAME
            myCommand.Parameters.Add(paramO2_NAME)

            'O2_EMAIL
            Dim paramO2_EMAIL As SqlParameter = New SqlParameter("@O2_EMAIL", SqlDbType.nvarchar, 30)
            paramO2_EMAIL.Value = O2_EMAIL
            myCommand.Parameters.Add(paramO2_EMAIL)

            'O2_TEL
            Dim paramO2_TEL As SqlParameter = New SqlParameter("@O2_TEL", SqlDbType.nvarchar, 20)
            paramO2_TEL.Value = O2_TEL
            myCommand.Parameters.Add(paramO2_TEL)

            'O2_EXT
            Dim paramO2_EXT As SqlParameter = New SqlParameter("@O2_EXT", SqlDbType.nvarchar, 10)
            paramO2_EXT.Value = O2_EXT
            myCommand.Parameters.Add(paramO2_EXT)

            'O2_FAX
            Dim paramO2_FAX As SqlParameter = New SqlParameter("@O2_FAX", SqlDbType.nvarchar, 20)
            paramO2_FAX.Value = O2_FAX
            myCommand.Parameters.Add(paramO2_FAX)

            ''CREATE_BY
            'Dim paramCREATE_BY As SqlParameter = New SqlParameter("@CREATE_BY", SqlDbType.nvarchar, 20)
            'paramCREATE_BY.Value = CREATE_BY
            'myCommand.Parameters.Add(paramCREATE_BY)

            ''CREATE_DATE
            'Dim paramCREATE_DATE As SqlParameter = New SqlParameter("@CREATE_DATE", SqlDbType.datetime)
            'paramCREATE_DATE.Value = CREATE_DATE
            'myCommand.Parameters.Add(paramCREATE_DATE)

            'MODIFY_BY
            Dim paramMODIFY_BY As SqlParameter = New SqlParameter("@MODIFY_BY", SqlDbType.nvarchar, 20)
            paramMODIFY_BY.Value = MODIFY_BY
            myCommand.Parameters.Add(paramMODIFY_BY)

            ''MODIFY_DATE
            'Dim paramMODIFY_DATE As SqlParameter = New SqlParameter("@MODIFY_DATE", SqlDbType.datetime)
            'paramMODIFY_DATE.Value = MODIFY_DATE
            'myCommand.Parameters.Add(paramMODIFY_DATE)

            myConnection.Open()
            myCommand.ExecuteNonQuery()
            myCommand.dispose()
            myConnection.Close()
            myConnection.Dispose()
        End Sub

        Public Sub CustAdd(BYVAL CUST_CODE AS STRING,BYVAL CUST_NAME AS STRING,ByVal CREDIT_LIMIT as decimal,ByVal WEB_SITE As STRING,ByVal CONSIGNEE As STRING,ByVal PAY_TERM As STRING,ByVal REQ_CQA As STRING,ByVal Cust_REM As STRING,ByVal CURR_CODE As STRING,ByVal NOTIFY_PARTY As STRING,ByVal FORWARDER As STRING,ByVal SHIP_TERM As STRING,ByVal BILL_CO As STRING,ByVal BILL_ATT As STRING,ByVal BILL_ADD1 As STRING,ByVal BILL_ADD2 As STRING,ByVal BILL_ADD3 As STRING,ByVal BILL_COUNTRY As STRING,ByVal BILL_STATE As STRING,ByVal BILL_TEL As STRING,ByVal BILL_EXT As STRING,ByVal BILL_FAX As STRING,ByVal P1_TITLE As STRING,ByVal P1_NAME As STRING,ByVal P1_EMAIL As STRING,ByVal P1_TEL As STRING,ByVal P1_EXT As STRING,ByVal P1_FAX As STRING,ByVal P2_TITLE As STRING,ByVal P2_NAME As STRING,ByVal P2_EMAIL As STRING,ByVal P2_TEL As STRING,ByVal P2_EXT As STRING,ByVal P2_FAX As STRING,ByVal A1_TITLE As STRING,ByVal A1_NAME As STRING,ByVal A1_EMAIL As STRING,ByVal A1_TEL As STRING,ByVal A1_EXT As STRING,ByVal A1_FAX As STRING,ByVal A2_TITLE As STRING,ByVal A2_NAME As STRING,ByVal A2_EMAIL As STRING,ByVal A2_TEL As STRING,ByVal A2_EXT As STRING,ByVal A2_FAX As STRING,ByVal O1_TITLE As STRING,ByVal O1_NAME As STRING,ByVal O1_EMAIL As STRING,ByVal O1_TEL As STRING,ByVal O1_EXT As STRING,ByVal O1_FAX As STRING,ByVal O2_TITLE As STRING,ByVal O2_NAME As STRING,ByVal O2_EMAIL As STRING,ByVal O2_TEL As STRING,ByVal O2_EXT As STRING,ByVal O2_FAX As STRING,ByVal Create_BY  As STRING)
            Dim myConnection As SqlConnection
            Dim myCommand As SqlCommand
            myConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
            myCommand= New SqlCommand("Cust_ADD", myConnection)
            myCommand.CommandType = CommandType.StoredProcedure

            'CUST_CODE
            Dim paramCUST_CODE As SqlParameter = New SqlParameter("@CUST_CODE", SqlDbType.nvarchar, 30)
            paramCUST_CODE.Value = CUST_CODE
            myCommand.Parameters.Add(paramCUST_CODE)

            'CUST_NAME
            Dim paramCUST_NAME As SqlParameter = New SqlParameter("@CUST_NAME", SqlDbType.nvarchar, 30)
            paramCUST_NAME.Value = CUST_NAME
            myCommand.Parameters.Add(paramCUST_NAME)

            'CREDIT_LIMIT
            Dim paramCREDIT_LIMIT As SqlParameter = New SqlParameter("@CREDIT_LIMIT", SqlDbType.decimal)
            paramCREDIT_LIMIT.Value = CREDIT_LIMIT
            myCommand.Parameters.Add(paramCREDIT_LIMIT)

            'WEB_SITE
            Dim paramWEB_SITE As SqlParameter = New SqlParameter("@WEB_SITE", SqlDbType.nvarchar, 50)
            paramWEB_SITE.Value = WEB_SITE
            myCommand.Parameters.Add(paramWEB_SITE)

            'CONSIGNEE
            Dim paramCONSIGNEE As SqlParameter = New SqlParameter("@CONSIGNEE", SqlDbType.nvarchar, 50)
            paramCONSIGNEE.Value = CONSIGNEE
            myCommand.Parameters.Add(paramCONSIGNEE)

            'PAY_TERM
            Dim paramPAY_TERM As SqlParameter = New SqlParameter("@PAY_TERM", SqlDbType.nvarchar, 10)
            paramPAY_TERM.Value = PAY_TERM
            myCommand.Parameters.Add(paramPAY_TERM)

            'REQ_CQA
            Dim paramREQ_CQA As SqlParameter = New SqlParameter("@REQ_CQA", SqlDbType.nvarchar, 3)
            paramREQ_CQA.Value = REQ_CQA
            myCommand.Parameters.Add(paramREQ_CQA)

            'REM
            Dim paramREM As SqlParameter = New SqlParameter("@CUST_REM", SqlDbType.nvarchar, 200)
            paramREM.Value = CUST_REM
            myCommand.Parameters.Add(paramREM)

            'CURR_CODE
            Dim paramCURR_CODE As SqlParameter = New SqlParameter("@CURR_CODE", SqlDbType.nvarchar, 10)
            paramCURR_CODE.Value = CURR_CODE
            myCommand.Parameters.Add(paramCURR_CODE)

            'NOTIFY_PARTY
            Dim paramNOTIFY_PARTY As SqlParameter = New SqlParameter("@NOTIFY_PARTY", SqlDbType.nvarchar, 50)
            paramNOTIFY_PARTY.Value = NOTIFY_PARTY
            myCommand.Parameters.Add(paramNOTIFY_PARTY)

            'FORWARDER
            Dim paramFORWARDER As SqlParameter = New SqlParameter("@FORWARDER", SqlDbType.nvarchar, 50)
            paramFORWARDER.Value = FORWARDER
            myCommand.Parameters.Add(paramFORWARDER)

            'SHIP_TERM
            Dim paramSHIP_TERM As SqlParameter = New SqlParameter("@SHIP_TERM", SqlDbType.nvarchar, 10)
            paramSHIP_TERM.Value = SHIP_TERM
            myCommand.Parameters.Add(paramSHIP_TERM)

            'BILL_CO
            Dim paramBILL_CO As SqlParameter = New SqlParameter("@BILL_CO", SqlDbType.nvarchar, 50)
            paramBILL_CO.Value = BILL_CO
            myCommand.Parameters.Add(paramBILL_CO)

            'BILL_ATT
            Dim paramBILL_ATT As SqlParameter = New SqlParameter("@BILL_ATT", SqlDbType.nvarchar, 30)
            paramBILL_ATT.Value = BILL_ATT
            myCommand.Parameters.Add(paramBILL_ATT)

            'BILL_ADD1
            Dim paramBILL_ADD1 As SqlParameter = New SqlParameter("@BILL_ADD1", SqlDbType.nvarchar, 50)
            paramBILL_ADD1.Value = BILL_ADD1
            myCommand.Parameters.Add(paramBILL_ADD1)

            'BILL_ADD2
            Dim paramBILL_ADD2 As SqlParameter = New SqlParameter("@BILL_ADD2", SqlDbType.nvarchar, 50)
            paramBILL_ADD2.Value = BILL_ADD2
            myCommand.Parameters.Add(paramBILL_ADD2)

            'BILL_ADD3
            Dim paramBILL_ADD3 As SqlParameter = New SqlParameter("@BILL_ADD3", SqlDbType.nvarchar, 50)
            paramBILL_ADD3.Value = BILL_ADD3
            myCommand.Parameters.Add(paramBILL_ADD3)

            'BILL_COUNTRY
            Dim paramBILL_COUNTRY As SqlParameter = New SqlParameter("@BILL_COUNTRY", SqlDbType.nvarchar, 10)
            paramBILL_COUNTRY.Value = BILL_COUNTRY
            myCommand.Parameters.Add(paramBILL_COUNTRY)

            'BILL_STATE
            Dim paramBILL_STATE As SqlParameter = New SqlParameter("@BILL_STATE", SqlDbType.nvarchar, 10)
            paramBILL_STATE.Value = BILL_STATE
            myCommand.Parameters.Add(paramBILL_STATE)

            'BILL_TEL
            Dim paramBILL_TEL As SqlParameter = New SqlParameter("@BILL_TEL", SqlDbType.nvarchar, 20)
            paramBILL_TEL.Value = BILL_TEL
            myCommand.Parameters.Add(paramBILL_TEL)

            'BILL_EXT
            Dim paramBILL_EXT As SqlParameter = New SqlParameter("@BILL_EXT", SqlDbType.nvarchar, 10)
            paramBILL_EXT.Value = BILL_EXT
            myCommand.Parameters.Add(paramBILL_EXT)

            'BILL_FAX
            Dim paramBILL_FAX As SqlParameter = New SqlParameter("@BILL_FAX", SqlDbType.nvarchar, 20)
            paramBILL_FAX.Value = BILL_FAX
            myCommand.Parameters.Add(paramBILL_FAX)

            'P1_TITLE
            Dim paramP1_TITLE As SqlParameter = New SqlParameter("@P1_TITLE", SqlDbType.nvarchar, 20)
            paramP1_TITLE.Value = P1_TITLE
            myCommand.Parameters.Add(paramP1_TITLE)

            'P1_NAME
            Dim paramP1_NAME As SqlParameter = New SqlParameter("@P1_NAME", SqlDbType.nvarchar, 20)
            paramP1_NAME.Value = P1_NAME
            myCommand.Parameters.Add(paramP1_NAME)

            'P1_EMAIL
            Dim paramP1_EMAIL As SqlParameter = New SqlParameter("@P1_EMAIL", SqlDbType.nvarchar, 30)
            paramP1_EMAIL.Value = P1_EMAIL
            myCommand.Parameters.Add(paramP1_EMAIL)

            'P1_TEL
            Dim paramP1_TEL As SqlParameter = New SqlParameter("@P1_TEL", SqlDbType.nvarchar, 20)
            paramP1_TEL.Value = P1_TEL
            myCommand.Parameters.Add(paramP1_TEL)

            'P1_EXT
            Dim paramP1_EXT As SqlParameter = New SqlParameter("@P1_EXT", SqlDbType.nvarchar, 10)
            paramP1_EXT.Value = P1_EXT
            myCommand.Parameters.Add(paramP1_EXT)

            'P1_FAX
            Dim paramP1_FAX As SqlParameter = New SqlParameter("@P1_FAX", SqlDbType.nvarchar, 20)
            paramP1_FAX.Value = P1_FAX
            myCommand.Parameters.Add(paramP1_FAX)

            'P2_TITLE
            Dim paramP2_TITLE As SqlParameter = New SqlParameter("@P2_TITLE", SqlDbType.nvarchar, 20)
            paramP2_TITLE.Value = P2_TITLE
            myCommand.Parameters.Add(paramP2_TITLE)

            'P2_NAME
            Dim paramP2_NAME As SqlParameter = New SqlParameter("@P2_NAME", SqlDbType.nvarchar, 20)
            paramP2_NAME.Value = P2_NAME
            myCommand.Parameters.Add(paramP2_NAME)

            'P2_EMAIL
            Dim paramP2_EMAIL As SqlParameter = New SqlParameter("@P2_EMAIL", SqlDbType.nvarchar, 30)
            paramP2_EMAIL.Value = P2_EMAIL
            myCommand.Parameters.Add(paramP2_EMAIL)

            'P2_TEL
            Dim paramP2_TEL As SqlParameter = New SqlParameter("@P2_TEL", SqlDbType.nvarchar, 20)
            paramP2_TEL.Value = P2_TEL
            myCommand.Parameters.Add(paramP2_TEL)

            'P2_EXT
            Dim paramP2_EXT As SqlParameter = New SqlParameter("@P2_EXT", SqlDbType.nvarchar, 10)
            paramP2_EXT.Value = P2_EXT
            myCommand.Parameters.Add(paramP2_EXT)

            'P2_FAX
            Dim paramP2_FAX As SqlParameter = New SqlParameter("@P2_FAX", SqlDbType.nvarchar, 20)
            paramP2_FAX.Value = P2_FAX
            myCommand.Parameters.Add(paramP2_FAX)

            'A1_TITLE
            Dim paramA1_TITLE As SqlParameter = New SqlParameter("@A1_TITLE", SqlDbType.nvarchar, 20)
            paramA1_TITLE.Value = A1_TITLE
            myCommand.Parameters.Add(paramA1_TITLE)

            'A1_NAME
            Dim paramA1_NAME As SqlParameter = New SqlParameter("@A1_NAME", SqlDbType.nvarchar, 20)
            paramA1_NAME.Value = A1_NAME
            myCommand.Parameters.Add(paramA1_NAME)

            'A1_EMAIL
            Dim paramA1_EMAIL As SqlParameter = New SqlParameter("@A1_EMAIL", SqlDbType.nvarchar, 30)
            paramA1_EMAIL.Value = A1_EMAIL
            myCommand.Parameters.Add(paramA1_EMAIL)

            'A1_TEL
            Dim paramA1_TEL As SqlParameter = New SqlParameter("@A1_TEL", SqlDbType.nvarchar, 20)
            paramA1_TEL.Value = A1_TEL
            myCommand.Parameters.Add(paramA1_TEL)

            'A1_EXT
            Dim paramA1_EXT As SqlParameter = New SqlParameter("@A1_EXT", SqlDbType.nvarchar, 10)
            paramA1_EXT.Value = A1_EXT
            myCommand.Parameters.Add(paramA1_EXT)

            'A1_FAX
            Dim paramA1_FAX As SqlParameter = New SqlParameter("@A1_FAX", SqlDbType.nvarchar, 20)
            paramA1_FAX.Value = A1_FAX
            myCommand.Parameters.Add(paramA1_FAX)

            'A2_TITLE
            Dim paramA2_TITLE As SqlParameter = New SqlParameter("@A2_TITLE", SqlDbType.nvarchar, 20)
            paramA2_TITLE.Value = A2_TITLE
            myCommand.Parameters.Add(paramA2_TITLE)

            'A2_NAME
            Dim paramA2_NAME As SqlParameter = New SqlParameter("@A2_NAME", SqlDbType.nvarchar, 20)
            paramA2_NAME.Value = A2_NAME
            myCommand.Parameters.Add(paramA2_NAME)

            'A2_EMAIL
            Dim paramA2_EMAIL As SqlParameter = New SqlParameter("@A2_EMAIL", SqlDbType.nvarchar, 30)
            paramA2_EMAIL.Value = A2_EMAIL
            myCommand.Parameters.Add(paramA2_EMAIL)

            'A2_TEL
            Dim paramA2_TEL As SqlParameter = New SqlParameter("@A2_TEL", SqlDbType.nvarchar, 20)
            paramA2_TEL.Value = A2_TEL
            myCommand.Parameters.Add(paramA2_TEL)

            'A2_EXT
            Dim paramA2_EXT As SqlParameter = New SqlParameter("@A2_EXT", SqlDbType.nvarchar, 10)
            paramA2_EXT.Value = A2_EXT
            myCommand.Parameters.Add(paramA2_EXT)

            'A2_FAX
            Dim paramA2_FAX As SqlParameter = New SqlParameter("@A2_FAX", SqlDbType.nvarchar, 20)
            paramA2_FAX.Value = A2_FAX
            myCommand.Parameters.Add(paramA2_FAX)

            'O1_TITLE
            Dim paramO1_TITLE As SqlParameter = New SqlParameter("@O1_TITLE", SqlDbType.nvarchar, 20)
            paramO1_TITLE.Value = O1_TITLE
            myCommand.Parameters.Add(paramO1_TITLE)

            'O1_NAME
            Dim paramO1_NAME As SqlParameter = New SqlParameter("@O1_NAME", SqlDbType.nvarchar, 20)
            paramO1_NAME.Value = O1_NAME
            myCommand.Parameters.Add(paramO1_NAME)

            'O1_EMAIL
            Dim paramO1_EMAIL As SqlParameter = New SqlParameter("@O1_EMAIL", SqlDbType.nvarchar, 30)
            paramO1_EMAIL.Value = O1_EMAIL
            myCommand.Parameters.Add(paramO1_EMAIL)

            'O1_TEL
            Dim paramO1_TEL As SqlParameter = New SqlParameter("@O1_TEL", SqlDbType.nvarchar, 20)
            paramO1_TEL.Value = O1_TEL
            myCommand.Parameters.Add(paramO1_TEL)

            'O1_EXT
            Dim paramO1_EXT As SqlParameter = New SqlParameter("@O1_EXT", SqlDbType.nvarchar, 10)
            paramO1_EXT.Value = O1_EXT
            myCommand.Parameters.Add(paramO1_EXT)

            'O1_FAX
            Dim paramO1_FAX As SqlParameter = New SqlParameter("@O1_FAX", SqlDbType.nvarchar, 20)
            paramO1_FAX.Value = O1_FAX
            myCommand.Parameters.Add(paramO1_FAX)

            'O2_TITLE
            Dim paramO2_TITLE As SqlParameter = New SqlParameter("@O2_TITLE", SqlDbType.nvarchar, 20)
            paramO2_TITLE.Value = O2_TITLE
            myCommand.Parameters.Add(paramO2_TITLE)

            'O2_NAME
            Dim paramO2_NAME As SqlParameter = New SqlParameter("@O2_NAME", SqlDbType.nvarchar, 20)
            paramO2_NAME.Value = O2_NAME
            myCommand.Parameters.Add(paramO2_NAME)

            'O2_EMAIL
            Dim paramO2_EMAIL As SqlParameter = New SqlParameter("@O2_EMAIL", SqlDbType.nvarchar, 30)
            paramO2_EMAIL.Value = O2_EMAIL
            myCommand.Parameters.Add(paramO2_EMAIL)

            'O2_TEL
            Dim paramO2_TEL As SqlParameter = New SqlParameter("@O2_TEL", SqlDbType.nvarchar, 20)
            paramO2_TEL.Value = O2_TEL
            myCommand.Parameters.Add(paramO2_TEL)

            'O2_EXT
            Dim paramO2_EXT As SqlParameter = New SqlParameter("@O2_EXT", SqlDbType.nvarchar, 10)
            paramO2_EXT.Value = O2_EXT
            myCommand.Parameters.Add(paramO2_EXT)

            'O2_FAX
            Dim paramO2_FAX As SqlParameter = New SqlParameter("@O2_FAX", SqlDbType.nvarchar, 20)
            paramO2_FAX.Value = O2_FAX
            myCommand.Parameters.Add(paramO2_FAX)

            'CREATE_BY
            Dim paramCREATE_BY As SqlParameter = New SqlParameter("@CREATE_BY", SqlDbType.nvarchar, 20)
            paramCREATE_BY.Value = CREATE_BY
            myCommand.Parameters.Add(paramCREATE_BY)

            myConnection.Open()
            myCommand.ExecuteNonQuery()
            myCommand.dispose()
            myConnection.Close()
            myConnection.Dispose()
        End Sub

        Public Function FuncGetRptID() As integer
            Dim RptID as integer = GetFieldVal("Select top 1 Rpt_ID from Main ","Rpt_ID")
            ExecuteNonQuery ("Update Main set Rpt_ID = RPT_ID + 1")
            Return RptID
        End Function

        Public Function FuncGetPicID() As integer
            Dim PicID as integer = GetFieldVal("Select top 1 PIC_ID from Main ","PIC_ID")
            ExecuteNonQuery ("Update Main set PIC_ID = PIC_ID + 1")
            Return PicID
        End Function

        Public Function MRPExplosion(UserID as string) as integer

                    Dim RSSOByModel as SQLDataReader
                    Dim RSSOByPart as SQLDataReader
                    Dim RSPR as SQLDataReader
                    Dim CurrUP as decimal
                    Dim CurrVendor as string
                    Dim ETADate as Date
                    Dim sngLeak As Single

                    executeNonQuery("Delete from mrp_m")
                    executeNonQuery("Delete from mrp_d")
                    executeNonQuery("Delete from PR_M")
                    executeNonQuery("Delete from PR_D")

                    'Clear off temp table
                        ExecuteNonQuery("Delete from BOM_Temp")
                    'Get Current MRP No
                        MRPNo = GetFieldVal("Select MRP_NO from Main","MRP_NO")
                    'Register new MRP Explosion
                        ExecuteNonQuery("Insert into MRP_M(MRP_NO,Create_by,Create_Date,STATUS) select " & MRPNo & ",'" & UserID.Trim() & "','" & now & "','OPEN';")

                    'Get Part's net qty (StoreBal = Open S/O + open P/O)
                        'ExeDataReader("Select * from SO_MODEL_M where BOM_Date is not null and LOT_CLOSE = 'N'")
                        ExecuteNonQuery("Update Part_Master set Net_Bal = Bal_Qty + Open_PO")

                    'Processing Sales Order by Model
                        RSSOByModel = ExeDataReader("Select * from SO_MODEL_M where BOM_DATE is not null and LOT_CLOSE = 'N'")
                        Do while RSSOByModel.read
                            GetBOMList(RSSOByModel("Lot_No"),RSSOByModel("Model_No"),RSSOByModel("BOM_Date"),RSSOByModel("Order_Qty"),RSSOByModel("Color_Desc"),RSSOByModel("Pack_Code"))
                        loop
                        ExecuteNonQuery("Update SO_Model_M set MRP = 'Y' where SEL = 'Y';")
                        RSSOByModel.close()

                    'Processing Sales Order by Part
                        RSSOByPart = ExeDataReader("Select * from SO_PART_M where ((SEL = 'Y') or (MRP='Y')) and Lot_Close = 'N'")
                        Do while RSSOByPart.read
                            ExecutenonQuery("Delete from BOM_Temp")
                            ExecuteNonQuery("Insert into BOM_Temp(LOT_NO,PART_NO,PART_QTY) Select LOT_NO,PART_NO,PART_QTY FROM SO_PART_D WHERE LOT_NO = '" & RSSOByPart("LOT_NO").trim() & "';")
                            CalculateMRPPart()
                        loop
                        RSSOByPart.close()
                    'Update S/O after MRP explosion
                        ExecuteNonQuery("Update SO_Part_M set MRP = 'Y' where SEL = 'Y';")

                    'Update PC Sch Days for each level
                        ExecuteNonQuery("Update MRP_D set MRP_D.sch_days = P_Level.PC_Sch_Days from P_Level,MRP_D where P_Level.Level_Code = MRP_D.P_Level")

                    'Get Production Date for Sales Order (By Model only)
                        ExecuteNonQuery("Update MRP_D set MRP_D.BOM_Date=SO.Prod_Date from MRP_D,SO_Model_M SO where MRP_D.Lot_No = SO.Lot_NO and MRP_D.MRP_NO = " & MRPNO & ";")

                    'Get Earliest Date for all Part(MRP_NO)
                        executenonquery("Update MRP_D set MRP_D.BOM_DATE = SO.Req_Date from MRP_D, SO_PART_M so where MRP_D.LOT_NO = so.lot_no")
                        DIM RsBOMDate as SQLDataReader= ExeDataReader("Select * from MRP_D where MRP_No = " & MrpNo & ";")
                        Do while RsBOMDate.read
                            ETADate = GetFieldVal("Select min(BOM_Date) AS [BOM_DATE] from MRP_D where MRP_No = " & MRPNO & " and Part_No = '" & rsBOMDate("Part_No").trim() & "';","BOM_Date")
                            ExecuteNonQUery("Update MRP_D set ETA_Date = '" & ETADate & "' where MRP_No = " & MRPNO & " and Part_No = '" & rsBOMDate("Part_No").trim() & "';")
                        loop

                    executeNonQuery("Update MRP_D set On_Hold = Qty")

                    'Update Lead Time for model
                        ExecuteNonQuery("Update MAIN set MRP_No = MRP_No + 1")
                        Return MRPNo
        End Function

        Public Sub CalculateMRPPart()

            Dim RSBOMTemp as SQLDataReader = ExeDataReader("Select * from BOM_Temp where Part_Qty is not null order by Seq_No asc")
            Dim NetQtyReq as decimal
            Dim StoreNetBal as decimal
            Dim StrSql as string
            Dim QtyDed as decimal

            Do while RSBOMTemp.read
                NetQtyReq = rsBOMTemp("Part_Qty")
                StoreNetBal = GetFieldVal("Select Net_Bal from Part_Master where Part_No = '" & RSBOMTemp("Part_No").trim() & "';","Net_Bal")
                Select case StoreNetBal
                    Case <= 0
                        StrSQL = "Insert into MRP_D(LOT_NO,MRP_NO,PART_NO,QTY,ON_HOLD,SO_TYPE) "
                        StrSQL = StrSQl + "Select '" & RSBomTemp("LOT_NO").trim() & "'," & MRPNo & ",'" & RSBomTemp("PART_NO").trim() & "'," & NetQtyReq & "," & NetQtyReq & ",'PART';"
                        ExecuteNonQuery(StrSQL)
                    case > 0
                        'QtyDed = iif((StoreNetBal > NetQtyReq),NetQtyReq,StoreNetBal)

                        if StoreNetBal > NetQtyReq then
                            QtyDed = NetQtyReq
                        Else
                            QtyDed = StoreNetBal
                        End if

                        NetQtyReq = NetQtyReq - QtyDed
                        if netQtyReq > 0 then
                            StrSQL = "Insert into MRP_D(LOT_NO,MRP_NO,PART_NO,QTY,ON_HOLD,SO_TYPE) "
                            StrSql = StrSql + "Select '" & RSBOMTEmp("Lot_No").trim() & "',"
                            StrSql = StrSql + "" & MRPNo & ",'" & RSBOMTEmp("Part_No").trim() & "',"
                            StrSql = StrSql + "" & NetQtyReq & "," & NetQtyReq & ","
                            StrSql = StrSql + "'Part';"
                            ExecuteNonQuery(StrSQL)
                        end if
                end select
            loop
            RSBOMTemp.close()
        end sub

        Public Sub CalculateMRP(QtyReq as decimal)

            Dim RSBOMTemp as SQLDataReader = ExeDataReader("Select * from BOM_Temp order by Seq_No asc")
            Dim NetQtyReq as decimal = QtyReq
            Dim StoreNetBal,QtyDed as decimal
            Dim StrSql as string


            Do while RSBOMTemp.read
                if NetQtyReq <= 0 then exit Do
                    StoreNetBal = GetFieldVal("Select Net_Bal from Part_Master where Part_No = '" & RSBOMTemp("Part_No").trim() & "';","Net_Bal")

                    Select case StoreNetBal
                        Case <= 0
                            NetQtyReq = NetQtyReq
                        case >= NetQtyReq
                            NetQtyReq = 0
                            exit do
                        case < NetQtyReq
                            'QtyDed = iif((StoreNetBal > NetQtyReq),NetQtyReq,StoreNetBal)


                            if StoreNetBal > NetQtyReq then
                                QtyDed = NetQtyReq
                            Else
                                QtyDed = StoreNetBal
                            end if


                            NetQtyReq = NetQtyReq - QtyDed
                    end select
            loop

            If NetQtyReq > 0 then
                StrSQL = "Insert into MRP_D(MODEL_NO,MRP_NO,LOT_NO,PART_NO,MAIN,QTY,MAIN_PART,P_Level,SO_TYPE)"
                StrSQL = StrSQl + "Select MODEL_NO," & MRPNo & ",LOT_NO,PART_NO,MAIN," & NetQtyReq & ",MAIN_PART,P_Level,'MODEL' from BOM_Temp where MAIN = 'MAIN';"
                ExecuteNonQuery(StrSQL)
            end if
            RSBOMTemp.close()
        end sub

        Public Sub GetBOMList(LotNo as string,ModelNo as string,BOMDate as date,OrderQty as decimal,Color as string,Packing as string)

            Dim RevNo as decimal = GetFieldVal("Select top 1 Revision from BOM_M where Effective_Date < '" & cdate(BOMDate) & "' order by Effective_Date desc","Revision")
            Dim QtyIssued as decimal
            Dim RSBomAlt as SQLDataReader = ExeDataReader("Select * from BOM_D where Model_No = '" & ModelNo.trim() & "' and Revision = " & RevNo & " order by Part_No asc")
            Dim strSql as string
            Dim QtyReq as decimal

            Do While RSBOMAlt.read
                ExecuteNonQuery ("Delete from BOM_TEMP")
                ExecuteNonQuery ("Insert into BOM_Temp(LOT_NO,P_LEVEL,MODEL_NO,MAIN_PART,PART_NO,MAIN,P_Color,Packing) Select '" & LotNo.trim() & "','" & RSBOMALT("P_Level").trim() & "','" & ModelNo.trim() & "','" & RSBOMALT("Part_No").trim() & "','" & RSBOMALT("Part_No").trim() & "','MAIN','" & RSBOMALT("P_Color").trim() & "','" & RSBOMALT("Packing").trim() & "';")
                ExecuteNonQuery ("Insert into BOM_Temp2(LOT_NO,P_LEVEL,MODEL_NO,MAIN_PART,PART_NO,MAIN,P_Color,Packing) Select '" & LotNo.trim() & "','" & RSBOMALT("P_Level").trim() & "','" & ModelNo.trim() & "','" & RSBOMALT("Part_No").trim() & "','" & RSBOMALT("Part_No").trim() & "','MAIN','" & RSBOMALT("P_Color").trim() & "','" & RSBOMALT("Packing").trim() & "';")

                ExecuteNonQuery ("Insert into BOM_TEMP(LOT_NO,P_LEVEL,MODEL_NO,MAIN_PART,PART_NO,MAIN,P_Color,Packing) Select '" & LotNo.trim() & "','" & RSBOMALT("P_Level").trim() & "','" & ModelNo.trim() & "',MAIN_PART,Part_No,'ALT','" & RSBOMALT("P_Color").trim() & "','" & RSBOMALT("Packing").trim() & "' from BOM_ALT where MAIN_PART = '" & RSBOMALT("Part_No").trim() & "' and Model_No = '" & ModelNo.trim() & "';")
                ExecuteNonQuery ("Insert into BOM_TEMP2(LOT_NO,P_LEVEL,MODEL_NO,MAIN_PART,PART_NO,MAIN,P_Color,Packing) Select '" & LotNo.trim() & "','" & RSBOMALT("P_Level").trim() & "','" & ModelNo.trim() & "',MAIN_PART,Part_No,'ALT','" & RSBOMALT("P_Color").trim() & "','" & RSBOMALT("Packing").trim() & "' from BOM_ALT where MAIN_PART = '" & RSBOMALT("Part_No").trim() & "' and Model_No = '" & ModelNo.trim() & "';")

                ExecuteNonQuery ("Delete from BOM_TEMP where P_Color <> '-' and P_Color <> '" & Color.trim() & "';")
                ExecuteNonQuery ("Delete from BOM_TEMP2 where P_Color <> '-' and P_Color <> '" & Color.trim() & "';")

                ExecuteNonQuery ("Delete from BOM_TEMP where Packing <> '-' and Packing <> '" & Packing.trim() & "';")
                ExecuteNonQuery ("Delete from BOM_TEMP2 where Packing <> '-' and Packing <> '" & Packing.trim() & "';")

                ExecuteNonQuery ("Insert into BOM_Temp2(LOT_NO,PART_NO) Select '---','---'")

                if funcCheckDuplicate("Select top 1 Lot_No from Issuing_D where Lot_No = '" & LotNo & "' and Part_No = '" & RSBOMALT("Part_No").trim() & "';","Lot_No") = true then
                    QtyIssued = getFieldVal("Select sum(QTY_ISSUED) as [QTY] from ISSUING_D where LOT_NO = '" & LotNo & "' and Part_No = '" & RSBOMALT("Part_No").trim() & "';","Qty")
                else
                    QtyIssued = 0
                End if

                QtyReq = (OrderQty * RSBOMAlt("P_Usage")) - QtyIssued

                CalculateMRP (QtyReq)
            loop

            ExecuteNonQuery("Update SO_Model_M set BOM_Rev = " & RevNo & " where Lot_No = '" & LotNo & "';")
            RSBomAlt.close()
        end sub
    End Class
End Namespace
