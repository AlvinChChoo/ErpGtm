Imports System
Imports System.Configuration
Imports System.Data
Imports System.Data.SqlClient

Namespace ERP_GTM
   Public Class ERP_GTM
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

            'CUST_NAME
            'Dim paramCUST_NAME As SqlParameter = New SqlParameter("@CUST_NAME", SqlDbType.nvarchar, 30)
            'paramCUST_NAME.Value = CUST_NAME
            'myCommand.Parameters.Add(paramCUST_NAME)

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
            myConnection.Close()
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

            ''CREATE_DATE
            'Dim paramCREATE_DATE As SqlParameter = New SqlParameter("@CREATE_DATE", SqlDbType.datetime)
            'paramCREATE_DATE.Value = CREATE_DATE
            'myCommand.Parameters.Add(paramCREATE_DATE)

            'MODIFY_BY
            'Dim paramMODIFY_BY As SqlParameter = New SqlParameter("@MODIFY_BY", SqlDbType.nvarchar, 20)
            'paramMODIFY_BY.Value = MODIFY_BY
            'myCommand.Parameters.Add(paramMODIFY_BY)

            ''MODIFY_DATE
            'Dim paramMODIFY_DATE As SqlParameter = New SqlParameter("@MODIFY_DATE", SqlDbType.datetime)
            'paramMODIFY_DATE.Value = MODIFY_DATE
            'myCommand.Parameters.Add(paramMODIFY_DATE)

            myConnection.Open()
            myCommand.ExecuteNonQuery()
            myConnection.Close()
        End Sub

    End Class
End Namespace
