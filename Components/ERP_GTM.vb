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

            drGetFieldVal.close()
            myCommand.dispose()
            myConnection.Close()
            myConnection.Dispose()
            Return result
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

            myCommand.dispose()
            drGetFieldVal.close()
            myConnection.Close()
            myConnection.Dispose()
            Return result
        End Function

        Public Function ExeDataReader(ByVal strSql As String) As SqlDataReader
            Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
            myConnection.Open()
            Dim myCommand As SqlCommand = New SqlCommand(StrSql, myConnection)
            Dim result As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
            Return result
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
            Dim myConnection1 As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
            myConnection1.Open()

            Dim myConnection2 As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
            myConnection2.Open()

            Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
            myConnection.Open()
            Dim myCommand As New sqlCommand
            myCommand.Connection = myConnection
            myCommand.CommandType = CommandType.Text

            Dim RSPR as SQLDataReader
            Dim CurrUP as decimal
            Dim CurrVendor as string
            Dim ETADate as Date
            Dim sngLeak As Single

            myCommand.CommandText = "Delete from mrp_m"
            myCommand.ExecuteNonQuery()

            myCommand.CommandText = "Update Part_Master set MRP_REQ_QTY = 0"
            myCommand.ExecuteNonQuery()

            myCommand.CommandText = "Delete from mrp_d"
            myCommand.ExecuteNonQuery()

            myCommand.CommandText = "Delete from mrp_d_rpt"
            myCommand.ExecuteNonQuery()

            myCommand.CommandText = "Delete from PR_M"
            myCommand.ExecuteNonQuery()

            myCommand.CommandText = "Delete from PR_D"
            myCommand.ExecuteNonQuery()

            myCommand.CommandText = "Delete from BOM_Temp"
            myCommand.ExecuteNonQuery()

            myConnection.Close()
            myConnection.Open()

            'Get Current MRP No
                MRPNo = GetFieldVal("Select MRP_NO from Main","MRP_NO")
            'Register new MRP Explosion
                myCommand.CommandText = "Insert into MRP_M(MRP_NO,Create_by,Create_Date,STATUS) select " & MRPNo & ",'" & UserID.Trim() & "','" & now & "','OPEN';"
                myCommand.ExecuteNonQuery()
                myConnection.Close()
                myConnection.Open()

            'Get Part's net qty (StoreBal = Open S/O + open P/O)
                myCommand.CommandText = "Update Part_Master set Net_Bal = Bal_Qty + Open_PO + mdo_bal + iqc_bal"
                myCommand.ExecuteNonQuery()
                myConnection.Close()
                myConnection.Open()

            'Processing Sales Order by Model
                Dim myCommand1 As SqlCommand = New SqlCommand("Select lot_no,model_no, bom_date, Order_Qty, Color_Desc,Pack_Code from SO_MODEL_M where BOM_DATE is not null and LOT_CLOSE = 'N'", myConnection1)
                Dim RSSOByModel As SqlDataReader = myCommand1.ExecuteReader(CommandBehavior.CloseConnection)

                Do while RSSOByModel.read
                    GetBOMList(RSSOByModel("Lot_No"),RSSOByModel("Model_No"),RSSOByModel("BOM_Date"),RSSOByModel("Order_Qty"),RSSOByModel("Color_Desc"),RSSOByModel("Pack_Code"))
                loop
                myCommand.CommandText = "Update SO_Model_M set MRP = 'Y' where SEL = 'Y';"
                myCommand.ExecuteNonQuery()
                myConnection.Close()
                myConnection.Open()


            'Processing Sales Order by Part
                Dim myCommand2 As SqlCommand = New SqlCommand("Select * from SO_PART_M where ((SEL = 'Y') or (MRP='Y')) and Lot_Close = 'N'", myConnection2)
                Dim RSSOByPart As SqlDataReader = myCommand2.ExecuteReader(CommandBehavior.CloseConnection)
                RSSOByPart = ExeDataReader("Select * from SO_PART_M where ((SEL = 'Y') or (MRP='Y')) and Lot_Close = 'N'")
                Do while RSSOByPart.read
                    myCommand.CommandText = "Delete from BOM_Temp"
                    myCommand.ExecuteNonQuery()

                    myCommand.CommandText = "Insert into BOM_Temp(LOT_NO,PART_NO,PART_QTY) Select LOT_NO,PART_NO,PART_QTY FROM SO_PART_D WHERE LOT_NO = '" & RSSOByPart("LOT_NO").trim() & "';"
                    myCommand.ExecuteNonQuery()
                    CalculateMRPPart()
                loop
                RSSOByPart.close()
            'Update S/O after MRP explosion
                myCommand.CommandText = "Update SO_Part_M set MRP = 'Y' where SEL = 'Y';"
                myCommand.ExecuteNonQuery()
                myConnection.Close()
                myConnection.Open()

            'Update PC Sch Days for each level
                myCommand.CommandText = "Update MRP_D set MRP_D.sch_days = P_Level.PC_Sch_Days from P_Level,MRP_D where P_Level.Level_Code = MRP_D.P_Level"
                myCommand.ExecuteNonQuery()
                myConnection.Close()
                myConnection.Open()

            'Get Production Date for Sales Order (By Model only)
                'myCommand.CommandText = "Update MRP_D set MRP_D.BOM_Date=SO.Prod_Date from MRP_D,SO_Model_M SO where MRP_D.Lot_No = SO.Lot_NO and MRP_D.MRP_NO = " & MRPNO & ";"
                myCommand.CommandText = "Update MRP_D set MRP_D.BOM_Date=SO.Prod_Date,MRP_D.ETA_DATE=SO.Prod_Date from MRP_D,SO_Model_M SO where MRP_D.Lot_No = SO.Lot_NO and MRP_D.MRP_NO = " & MRPNO & ";"
                myCommand.ExecuteNonQuery()
                myConnection.Close()
                myConnection.Open()
            'mINUS SCH DAYS
                'myCommand.CommandText = "Update MRP_D set MRP_D.BOM_Date=MRP_D.BOM_Date - sch_days from MRP_D,SO_Model_M SO where MRP_D.Lot_No = SO.Lot_NO and MRP_D.MRP_NO = " & MRPNO & ";"
                myCommand.CommandText = "Update MRP_D set MRP_D.ETA_Date=MRP_D.ETA_Date - sch_days from MRP_D,SO_Model_M SO where MRP_D.Lot_No = SO.Lot_NO and MRP_D.MRP_NO = " & MRPNO & ";"
                myCommand.ExecuteNonQuery()
                myConnection.Close()
                myConnection.Open()

            'Get Earliest Date for all Part(MRP_NO)
                'executenonquery("Update MRP_D set MRP_D.BOM_DATE = SO.Req_Date from MRP_D, SO_PART_M so where MRP_D.LOT_NO = so.lot_no")
                'myCommand.CommandText = "Update MRP_D set MRP_D.BOM_DATE = SO.Req_Date from MRP_D, SO_PART_M so where MRP_D.LOT_NO = so.lot_no"
                myCommand.CommandText = "Update MRP_D set MRP_D.ETA_DATE = SO.Req_Date from MRP_D, SO_PART_M so where MRP_D.LOT_NO = so.lot_no"
                myCommand.ExecuteNonQuery()
                myConnection.Close()
                myConnection.Open()

                'DIM RsBOMDate as SQLDataReader= ExeDataReader("Select distinct(Part_no) as [Part_No] from MRP_D where MRP_No = " & MrpNo & ";")
                DIM RsBOMDate as SQLDataReader= ExeDataReader("Select distinct(Part_no) as [Part_No],month(ETA_Date) as [ETA_MONTH] from MRP_D where MRP_No = " & MrpNo & " group by part_no, month(ETA_Date)")
                Do while RsBOMDate.read

                    'ETADate = GetFieldVal("Select min(ETA_Date) AS [BOM_DATE] from MRP_D where MRP_No = " & MRPNO & " and Part_No = '" & rsBOMDate("Part_No").trim() & "';","BOM_Date")
                    ETADate = GetFieldVal("Select top 1 ETA_Date AS [BOM_DATE] from MRP_D where MRP_No = " & MRPNO & " and Part_No = '" & rsBOMDate("Part_No").trim() & "' and month(ETA_DATE) = " & cint(rsBOMDate("ETA_MONTH")) & ";","BOM_DATE")
                    myCommand.CommandText = "Update MRP_D set ETA_Date = '" & ETADate & "' where MRP_No = " & MRPNO & " and Part_No = '" & rsBOMDate("Part_No").trim() & "' AND month(eta_DATE) = " & CINT(rsBOMDate("ETA_MONTH")) & ";"
                    myCommand.ExecuteNonQuery()
                    myConnection.Close()
                    myConnection.Open()
                loop

                myCommand.CommandText = "Update MRP_D set On_Hold = Qty"
                myCommand.ExecuteNonQuery()
                myConnection.Close()
                myConnection.Open()

                myCommand.CommandText = "INSERT INTO MRP_D_RPT(MRP_NO,MODEL_NO,LOT_NO,SO_TYPE,PART_NO,MAIN,MAIN_PART,P_LEVEL,BOM_DATE,ETA_DATE,EARLIEST_DATE,PROCESS_DAYS,SCH_DAYS,QTY,ON_HOLD,RELEASE,SOURCE_TEST,POST,RELEASE_TYPE_TEST) SELECT MRP_NO,MODEL_NO,LOT_NO,SO_TYPE,PART_NO,MAIN,MAIN_PART,P_LEVEL,BOM_DATE,ETA_DATE,EARLIEST_DATE,PROCESS_DAYS,SCH_DAYS,QTY,ON_HOLD,RELEASE,SOURCE_TEST,POST,RELEASE_TYPE_TEST FROM MRP_D"
                myCommand.ExecuteNonQuery()
                myConnection.Close()
                myConnection.Open()



            'Update Lead Time for model
                myCommand.CommandText = "Update MAIN set MRP_No = MRP_No + 1"
                myCommand.ExecuteNonQuery()

                RSSOByPart.close()
                RSSOByModel.close()
                myCommand.Dispose()
                myConnection.Close()
                myConnection.Dispose()
                myConnection1.Close()
                myConnection1.Dispose()
                myConnection2.Close()
                myConnection2.Dispose()
            Return MRPNo
        End Function

        Public Sub CalculateMRPPart()
            Dim myConnectionDR As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
            myConnectionDR.Open()
            Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
            myConnection.Open()
            Dim RSBOMTemp as SQLDataReader
            Dim myCommand As New sqlCommand
            myCommand.Connection = myConnection
            myCommand.CommandType = CommandType.Text

            Dim NetQtyReq as decimal
            Dim StoreNetBal as decimal
            Dim StrSql as string
            Dim QtyDed as decimal

            Dim myCommandDR As SqlCommand = New SqlCommand("Select * from BOM_Temp where Part_Qty is not null order by Seq_No asc", myConnectionDR)
            rsBOMTemp = myCommandDR.ExecuteReader(CommandBehavior.CloseConnection)

            Do while RSBOMTemp.read
                NetQtyReq = rsBOMTemp("Part_Qty")
                StoreNetBal = GetFieldVal("Select Net_Bal from Part_Master where Part_No = '" & RSBOMTemp("Part_No").trim() & "';","Net_Bal")
                Select case StoreNetBal
                    Case <= 0
                        StrSQL = "Insert into MRP_D(LOT_NO,MRP_NO,PART_NO,QTY,ON_HOLD,SO_TYPE) "
                        StrSQL = StrSQl + "Select '" & RSBomTemp("LOT_NO").trim() & "'," & MRPNo & ",'" & RSBomTemp("PART_NO").trim() & "'," & NetQtyReq & "," & NetQtyReq & ",'PART';"
                        myCommand.CommandText = StrSql
                        myCommand.ExecuteNonQuery()
                    case > 0
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
                            myCommand.CommandText = StrSql
                            myCommand.ExecuteNonQuery()
                        end if
                end select
            loop
            RSBOMTemp.close()

            myCommand.Dispose()
            myConnection.Close()
            myConnection.Dispose()
            myConnectionDR.Close()
            myConnectionDR.Dispose()
        end sub

        Public Sub CalculateMRP(QtyReq as decimal)

            Dim myConnectionDR As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
            myConnectionDR.Open()

            Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
            myConnection.Open()
            Dim myCommand As New sqlCommand
            myCommand.Connection = myConnection
            myCommand.CommandType = CommandType.Text

            Dim RSBOMTemp as SQLDataReader
            Dim NetQtyReq as decimal = QtyReq
            Dim StoreNetBal,QtyDed as decimal
            Dim StrSql as string

            Dim myCommandDR As SqlCommand = New SqlCommand("Select distinct(BT.Part_no), PM.Net_Bal from BOM_Temp BT,part_master PM where BT.Part_No = PM.Part_no", myConnectionDR)
            rsBOMTemp = myCommandDR.ExecuteReader(CommandBehavior.CloseConnection)
            Do while RSBOMTemp.read
                if NetQtyReq <= 0 then exit Do
                    StoreNetBal = RSBOMTemp("Net_Bal")
                    Select case StoreNetBal
                        Case <= 0 :NetQtyReq = NetQtyReq
                        case >= NetQtyReq : NetQtyReq = 0:exit do
                        case < NetQtyReq
                            if StoreNetBal > NetQtyReq then QtyDed = NetQtyReq else QtyDed = StoreNetBal
                            NetQtyReq = NetQtyReq - QtyDed
                    end select
            loop

            If NetQtyReq > 0 then
                StrSQL = "Insert into MRP_D(MODEL_NO,MRP_NO,LOT_NO,PART_NO,MAIN,QTY,MAIN_PART,P_Level,SO_TYPE)"
                StrSQL = StrSQl + "Select MODEL_NO," & MRPNo & ",LOT_NO,PART_NO,MAIN," & NetQtyReq & ",MAIN_PART,P_Level,'MODEL' from BOM_Temp where MAIN = 'MAIN';"
                myCommand.CommandText = StrSql
                myCommand.ExecuteNonQuery()
            end if
            RSBOMTemp.close()

            myConnection.Close()
            myCommand.Dispose()
            myConnection.Dispose()
            myConnectionDR.close
            myConnectionDR.Dispose()
        end sub

        Public Sub GetBOMList(LotNo as string,ModelNo as string,BOMDate as date,OrderQty as decimal,Color as string,Packing as string)
            Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
            Dim myConnectionDR As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
            myConnectionDR.Open()
            myConnection.Open()

            Dim myCommand As New sqlCommand
            myCommand.Connection = myConnection
            myCommand.CommandType = CommandType.Text

            Dim RevNo as decimal = GetFieldVal("Select top 1 Revision from BOM_M where Model_No = '" & ModelNo.trim() & "' and Effective_Date < '" & cdate(BOMDate) & "' order by Effective_Date desc","Revision")
            Dim QtyIssued as decimal
            Dim RSBomAlt as SQLDataReader
            Dim strSql as string
            Dim QtyReq as decimal


            Dim myCommandDR As SqlCommand = New SqlCommand("Select * from BOM_D where Model_No = '" & ModelNo.trim() & "' and Revision = " & RevNo & " order by Part_No asc", myConnectionDR)
            RSBOMAlt = myCommandDR.ExecuteReader(CommandBehavior.CloseConnection)
            Do While RSBOMAlt.read
                myCommand.CommandText = "Delete from BOM_TEMP"
                myCommand.ExecuteNonQuery()

                myCommand.CommandText = "Insert into BOM_Temp(LOT_NO,P_LEVEL,MODEL_NO,MAIN_PART,PART_NO,MAIN,P_Color,Packing) Select '" & LotNo.trim() & "','" & RSBOMALT("P_Level").trim() & "','" & ModelNo.trim() & "','" & RSBOMALT("Part_No").trim() & "','" & RSBOMALT("Part_No").trim() & "','MAIN','" & RSBOMALT("P_Color").trim() & "','" & RSBOMALT("Packing").trim() & "';"
                myCommand.ExecuteNonQuery()

                myCommand.CommandText = "Insert into BOM_Temp2(LOT_NO,P_LEVEL,MODEL_NO,MAIN_PART,PART_NO,MAIN,P_Color,Packing) Select '" & LotNo.trim() & "','" & RSBOMALT("P_Level").trim() & "','" & ModelNo.trim() & "','" & RSBOMALT("Part_No").trim() & "','" & RSBOMALT("Part_No").trim() & "','MAIN','" & RSBOMALT("P_Color").trim() & "','" & RSBOMALT("Packing").trim() & "';"
                myCommand.ExecuteNonQuery()

                myCommand.CommandText = "Insert into BOM_TEMP(LOT_NO,P_LEVEL,MODEL_NO,MAIN_PART,PART_NO,MAIN,P_Color,Packing) Select '" & LotNo.trim() & "','" & RSBOMALT("P_Level").trim() & "','" & ModelNo.trim() & "',MAIN_PART,Part_No,'ALT','" & RSBOMALT("P_Color").trim() & "','" & RSBOMALT("Packing").trim() & "' from BOM_ALT where MAIN_PART = '" & RSBOMALT("Part_No").trim() & "' and Model_No = '" & ModelNo.trim() & "';"
                myCommand.ExecuteNonQuery()

                myCommand.CommandText = "Insert into BOM_TEMP2(LOT_NO,P_LEVEL,MODEL_NO,MAIN_PART,PART_NO,MAIN,P_Color,Packing) Select '" & LotNo.trim() & "','" & RSBOMALT("P_Level").trim() & "','" & ModelNo.trim() & "',MAIN_PART,Part_No,'ALT','" & RSBOMALT("P_Color").trim() & "','" & RSBOMALT("Packing").trim() & "' from BOM_ALT where MAIN_PART = '" & RSBOMALT("Part_No").trim() & "' and Model_No = '" & ModelNo.trim() & "';"
                myCommand.ExecuteNonQuery()

                myCommand.CommandText = "Insert into BOM_Temp2(LOT_NO,PART_NO) Select '---','---'"
                myCommand.ExecuteNonQuery()

                myConnection.Close()
                myConnection.open()

                if funcCheckDuplicate("Select top 1 Lot_No from Issuing_D where Lot_No = '" & LotNo & "' and Part_No = '" & RSBOMALT("Part_No").trim() & "';","Lot_No") = true then
                    QtyIssued = getFieldVal("Select sum(QTY_ISSUED) as [QTY] from ISSUING_D where LOT_NO = '" & LotNo & "' and Part_No = '" & RSBOMALT("Part_No").trim() & "';","Qty")
                else
                    QtyIssued = 0
                End if

                'QtyReq = (OrderQty * RSBOMAlt("P_Usage")) - QtyIssued
                QtyReq = (OrderQty * RSBOMAlt("P_Usage"))

                '''''''''
                myCommand.CommandText = "UPDATE PART_MASTER SET MRP_REQ_QTY = MRP_REQ_QTY + " & QtyReq & " WHERE PART_NO = '" & RSBOMAlt("pART_nO").trim() & "';"
                myCommand.ExecuteNonQuery()
                'ExecuteNonQuery("UPDATE PART_MASTER SET MRP_REQ_QTY = " & QtyReq & " WHERE PART_NO = '" & RSBOMAlt("pART_nO").trim() & "';")
                '''''''''

                CalculateMRP (QtyReq)
            loop

            myCommand.CommandText = "Update SO_Model_M set BOM_Rev = " & RevNo & " where Lot_No = '" & LotNo & "';"
            myCommand.ExecuteNonQuery()

            RSBomAlt.close()
            myConnection.Close()
            myCommand.Dispose()
            myConnection.Dispose()
            myConnectionDR.Close()
            myConnectionDR.Dispose()
        end sub

    End Class
End Namespace
