<%@ Page Language="VB" Debug="true" %>
<%@ Register TagPrefix="IBuySpy" TagName="Header" Src="_Header.ascx" %>
<%@ import Namespace="System.data.OleDb" %>
<%@ import Namespace="System.data" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.configuration" %>
<%@ import Namespace="System.data.sqlclient" %>
<%@ import Namespace="System.Collections" %>
<%@ import Namespace="System.Text" %>
<%@ import Namespace="System.Web.UI.WebControls" %>
<script runat="server">

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        if page.isPostBack = false then
            'Dim dbConnection As New OleDb.OleDbConnection   'FAMS Connection
    
            'Dim dbConnection As OleDb.OleDbConnection = New OleDb.OleDbConnection("Provider=IBMDA400.DataSource.1;User ID=MYPGINTEL;Password=MYPGINTEL;Data Source=SinAS400;Connect Timeout=30;SSL=DEFAULT;Transport Product=Client Access")
    
            'Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
    
    
            'Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
    
            'dbConnection = (New DbCon).GetConnection(strDbCon)
    
    
    
            'Dim HAWB As String
            'Dim strSQL As String
            'Dim CN_NAME As String
            'Dim BT_NAME As String
            'Dim MyCommand As New OleDb.OleDbCommand 'FAMS Command
            'Dim MyCommand1 As New OleDb.OleDbCommand 'Invoice_POD Command
            'Dim MyCommand2 As New OleDb.OleDbCommand    'Change duplicate data
            'Dim MyCommand3 As New OleDb.OleDbCommand
            'Dim MyReader As OleDb.OleDbDataReader   'FAMS DATA
            'Dim MyReader1 As OleDb.OleDbDataReader  'Change duplicate data
            'Dim MyReader2 As OleDb.OleDbDataReader
            'Dim MyReader3 As OleDb.OleDbDataReader
            'Dim strDbString As String   'Connection string
            'Dim dbConnection1 As New OleDb.OleDbConnection  'Ebilling Connection
            'Dim dbConnection2 As New OleDb.OleDbConnection
            'Dim dbConnection3 As New OleDb.OleDbConnection
    
            'strSQL = "SELECT T02.JOBNO,T01.INVNO, T01.INVTYPE, T01.TRANDATE, T01.BILLAMT, T02.HAWBNO, T02.FRGTPPD, T02.CLIENT, " & _
            '    "T02.CLIENTNAME, T05.CMPYADDR1, T05.CMPYADDR2, T05.CMPYADDR3, T07.CITY ,T05.POSTCODE,T02.HAWBORGCTR,T02.HAWBDSTCTR, T02.CONSGN, T02.CONSIGNNAM, T02.BILLTO, T03.PICKUPDATE, T03.PICKUPTIME, T03.GOODSDESC1, T03.GOODSDESC2," & _
            '    "T02.HOUSEORIG, T02.HAWBDEST, T02.ACTWGTEXPC, T02.PCSEXPECTD, T02.CHGWGTEXPC, T02.SERVLEVEL, " & _
            '    "T02.SERVTYPE, T01.CURR, T08.BKRATE,T03.BILLTOCODE, T01.AFOI, T01.ATFB, T01.AWDB, T01.AWBI, T01.BBB, T01.COU, " & _
            '    "T01.BLOE, T01.CAFB, T01.CCIE, T01.CEAI, T01.STG,T01.SVT, T01.DFAI, T01.DFOI, T01.EIOI, T01.FRTB, " & _
            '    "T01.FRTD, T01.FRTE, T01.FRTO, T01.HDOE, T01.LDOE, T01.MCOE, T01.SFOE, T01.TCAI, T01.TPAI, T01.TPOE, " & _
            '    "T01.DFAE, T01.SEC, T01.HDAE, T01.TPWH, T01.FRTA, T01.MCAI, T01.AFTA, T01.AFTB, T01.FZAI, T01.CAFA, " & _
            '    "T01.HDWH, T01.MCWH, T01.BBA , T01.HDAI, T01.ATFA, T01.TCAE, T01.TPAE, T01.OTAI, T01.ODTD, T01.EXIF, " & _
            '    "T01.ONFR, T01.CHRGCD1, T01.CHRGAMT1, T01.CHRGCD2, T01.CHRGAMT2, T01.CHRGCD3, T01.CHRGAMT3, T01.CHRGCD4, T01.CHRGAMT4, T01.CHRGCD5, T01.CHRGAMT5, " & _
            '    "T01.CHRGCD6, T01.CHRGAMT6 ,T01.CHRGCD7,T01.CHRGAMT7, T01.CHRGCD8, T01.CHRGAMT8, T01.CHRGCD9, T01.CHRGAMT9 ,T01.CHRGCD10, T01.CHRGAMT10, " & _
            '    "T01.CHRGCD11, T01.CHRGAMT11,T01.CHRGCD12 ,T01.CHRGAMT12,T01.CHRGCD13  ,T01.CHRGAMT13 ,T01.CHRGCD14  ,T01.CHRGAMT14 ,T01.CHRGCD15  ,T01.CHRGAMT15 , " & _
            '    "T01.CHRGCD16, T01.CHRGAMT16, T01.CHRGCD17, T01.CHRGAMT17, T01.CHRGCD18, T01.CHRGAMT18, T01.CHRGCD19, T01.CHRGAMT19, T01.CHRGCD20, T01.CHRGAMT20 " & _
            '    "FROM BMBAXEIS.BCUMINV T01, BMBAXEIS.BEXPAIRDTL T02, BMOBJ.F001P04 T03, BMOBJ.V001P01 T05, BMOBJ.A011P01 T06, BMOBJ.V001P08 T07, BMOBJ.F002P83 T08 " & _
            '    "WHERE T01.JOBNO = T02.JOBNO " & _
            '    "AND T01.JOBNO = T03.JOBNO " & _
            '    "AND T02.CLIENT = T05.COMPANY " & _
            '    "AND T01.BRANCH = 'P' " & _
            '    "AND T02.BILLTO = 'INTECO' " & _
            '    "AND T01.JOBNO LIKE 'PEA%' " & _
            '    "AND T01.CURR = T06.CURRCODE " & _
            '    "AND T02.CLIENT = T07.COMPANY " & _
            '    "AND SUBSTRING(T01.JOBNO,4,6) = T08.JOBNO"
    
            'StrSql = "select * from BMBAXEIS.BCUMINV  where BRANCH = 'P'"
    
                'MyCommand.Connection = dbConnection
                'MyCommand.CommandType = CommandType.Text
                'MyCommand.CommandText = strSQL
                'dbConnection.Open()
                'MyReader = MyCommand.ExecuteReader
    
    
                'Do While (MyReader.Read)
                '    response.write(MyReader("JOBNO"))
                '
                'Loop
    
                'GridControl1.DataSource=MyReader
    
                'myOleDbAdapter =New OleDbDataAdapter(sqlStr,myConn)
                'myOleDbAdapter.Fill(myDataSet,"dtProducts")
                'GridControl1.DataSource=myDataSet.Tables("dtProducts")
    
                'GridControl1.DataBind()
    
    
    
                'bindListControl
                'DownloadArgus
    
    
    
        end if
    End Sub
    
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        response.redirect("Default.aspx")
    End Sub
    
    Sub cmdAdd_Click(sender As Object, e As EventArgs)
        response.redirect("FECNAddNew.aspx")
    End Sub
    
    
    Sub cmdGo_Click(sender As Object, e As EventArgs)
    
    End Sub
    
    Sub ShowDet(sender as Object,e as DataGridCommandEventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim SeqNo As Label = CType(e.Item.FindControl("SeqNo"), Label)
        Dim ModelNo as string
        Dim Revision as decimal
    
        Try
            ModelNo = ReqCOM.GetFieldVal("Select Model_No from FECN_M where Seq_No = " & clng(SeqNo.text) & ";","Model_No")
            if trim(ModelNo) = "COMMON" and trim(ucase(e.commandArgument)) = "COST" then exit sub
            Revision = ReqCOM.GetFieldVal("Select top 1 Revision as [Revision] from BOM_M where model_no = '" & trim(ModelNo) & "' order by revision desc;","Revision")
        Catch
        Finally
            if trim(ucase(e.commandArgument)) = "COST" then
                ShowReport("PopupReportViewer.aspx?RptName=FECNPartWithoutStdCost&ModelNo=" & trim(ModelNo) & "&Revision=" & cdec(Revision))
            Elseif trim(ucase(e.commandArgument)) = "VIEW" then
                Response.redirect("FECNDet.aspx?ID=" & clng(SeqNo.text))
            end if
        end try
    End sub
    
    Sub ShowReport(ReturnURL as string)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=0,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=250');")
        Script.Append("</script" & ">")
        RegisterStartupScript("ShowExistingSupplier", Script.ToString())
    End sub
    
    
    Sub DownloadFams()
        Dim myConn As OleDbConnection
        Dim myOleDbAdapter As OleDbDataAdapter
        Dim connStr, sqlStr As String
        Dim myDataSet As New Dataset
    
        connStr="Provider=IBMDA400.DataSource.1;User ID=MYPGINTEL;Password=MYPGINTEL;Data Source=SinAS400;Connect Timeout=30;SSL=DEFAULT;Transport Product=Client Access"
    
        sqlStr = "Select T02.JOBNO,T01.TRANDATE,T01.INVTYPE,T02.servlevel,T02.HAWBNO,T02.CONSGN, T02.CONSIGNNAM, T02.BILLTO,'BILL Date',T02.HOUSEORIG, T02.HAWBDEST, T03.PICKUPDATE, T03.PICKUPTIME,T02.etaetd,T02.ataatd,T02.ACTWGTEXPC,T02.CHGWGTEXPC,T06.CURRCODE, T01.BILLAMT,'QTY(pcs)',T02.SERVTYPE,T03.GOODSDESC2,'Frt Terms','POD DateTime' " & _
        "FROM BMBAXEIS.BCUMINV T01, BMBAXEIS.BEXPAIRDTL T02, BMOBJ.F001P04 T03, BMOBJ.V001P01 T05, BMOBJ.A011P01 T06, BMOBJ.V001P08 T07, BMOBJ.F002P83 T08 " & _
        "WHERE T01.JOBNO = T02.JOBNO " & _
        "AND T01.JOBNO = T03.JOBNO " & _
        "AND T02.CLIENT = T05.COMPANY " & _
        "AND T01.BRANCH = 'P' " & _
        "AND T01.JOBNO LIKE 'PEA%' " & _
        "AND T01.CURR = T06.CURRCODE " & _
        "AND T02.CLIENT = T07.COMPANY " & _
        "AND T01.TRANDATE >= '20061101' " & _
        "AND T01.TRANDATE <= '20061115' " & _
        "AND T02.BILLTO in ('KOMUSA','MOMMAL') " & _
        "AND SUBSTRING(T01.JOBNO,4,6) = T08.JOBNO"
    
    
        sqlStr = "Select T02.JOBNO,T01.TRANDATE,T01.INVTYPE,T02.servlevel,T02.HAWBNO,T02.CONSGN, T02.CONSIGNNAM, T02.BILLTO,'BILL Date',T02.HOUSEORIG, T02.HAWBDEST, T03.PICKUPDATE, T03.PICKUPTIME,T02.etaetd,T02.ataatd,T02.ACTWGTEXPC,T02.CHGWGTEXPC,T06.CURRCODE, T01.BILLAMT,'QTY(pcs)',T02.SERVTYPE,T03.GOODSDESC2,'Frt Terms','POD DateTime' " & _
        "FROM BMBAXEIS.BCUMINV T01, BMBAXEIS.BEXPAIRDTL T02, BMOBJ.F001P04 T03, BMOBJ.V001P01 T05, BMOBJ.A011P01 T06, BMOBJ.V001P08 T07, BMOBJ.F002P83 T08 " & _
        "WHERE T01.JOBNO = T02.JOBNO " & _
        "AND T01.JOBNO = T03.JOBNO " & _
        "AND T02.CLIENT = T05.COMPANY " & _
        "AND T01.BRANCH = 'P' " & _
        "AND T01.JOBNO LIKE 'PEA%' " & _
        "AND T01.CURR = T06.CURRCODE " & _
        "AND T02.CLIENT = T07.COMPANY " & _
        "AND T02.HAWBNO = 'PEA312954' " & _
        "AND T02.BILLTO in ('KOMUSA','MOMMAL') " & _
        "AND SUBSTRING(T01.JOBNO,4,6) = T08.JOBNO"
    
    
        sqlStr = "select * from BMBAXEIS.BEXPAIRDTL where HAWBNO = 'PEA312954'"
    
        'PEA312954
    
        myConn= New OleDbConnection(connStr)
        myConn.Open()
        myOleDbAdapter =New OleDbDataAdapter(sqlStr,myConn)
        myOleDbAdapter.Fill(myDataSet,"dtProducts")
        dataGrid1.DataSource=myDataSet.Tables("dtProducts")
        dataGrid1.DataBind()
        myConn.Close()
    End Sub
    
    Sub DownloadArgus()
        Dim myConn As OleDbConnection
        Dim myOleDbAdapter As OleDbDataAdapter
        Dim connStr, sqlStr As String
        Dim myDataSet As New Dataset
    
        connStr="Provider=MSDAORA;Password=penygw1;User ID=penygw1;Data Source=Argus"
    
        'sqlStr="SELECT AL2.ORIGINAL_HOUSE_AIRWAY_BILL_NB, AL1.LN_DEL_FULL_DATE_ID, AL2.DELIVERY_SIGNATURE_TX, AL3.TWENTY_FOUR_HOUR_MINUTE_NM FROM DWSINF1.V_DIM_LANE_DELIVERY_DATE AL1, DWSINF1.V_GT_LANE_FACT_B AL2, DWSINF1.V_DIM_HOUR_MINUTE AL3 WHERE ORIGINAL_HOUSE_AIRWAY_BILL_NB = 'PEA124747' AND (AL2.FINAL_DELIVERY_DATE_KE=AL1.LN_DELIVERY_DATE_KE) and AL2.DELIVERY_DATE_HOUR_MINUTE_KE = AL3.HOUR_MINUTE_KE"
    
        'sqlStr="SELECT AL2.ORIGINAL_HOUSE_AIRWAY_BILL_NB, AL1.LN_DEL_FULL_DATE_ID, AL2.DELIVERY_SIGNATURE_TX, AL3.TWENTY_FOUR_HOUR_MINUTE_NM FROM DWSINF1.V_DIM_LANE_DELIVERY_DATE AL1, DWSINF1.V_GT_LANE_FACT_B AL2, DWSINF1.V_DIM_HOUR_MINUTE AL3 WHERE (AL2.FINAL_DELIVERY_DATE_KE=AL1.LN_DELIVERY_DATE_KE) and AL2.DELIVERY_DATE_HOUR_MINUTE_KE = AL3.HOUR_MINUTE_KE"
    
        'sqlStr="SELECT ORIGINAL_HOUSE_AIRWAY_BILL_NB FROM DWSINF1.V_GT_LANE_FACT_B where ORIGINAL_HOUSE_AIRWAY_BILL_NB = 'PEA317957'"
    
    '    sqlStr="SELECT ORIGINAL_HOUSE_AIRWAY_BILL_NB FROM DWSINF1.V_GT_LANE_FACT_B where ORIGINAL_HOUSE_AIRWAY_BILL_NB = '317957'"
    
        'sqlStr="SELECT ORIGINAL_HOUSE_AIRWAY_BILL_NB FROM DWSINF1.V_GT_LANE_FACT_B where ORIGINAL_HOUSE_AIRWAY_BILL_NB = 'PEA609343'"
    
        sqlStr="SELECT AL2.ORIGINAL_HOUSE_AIRWAY_BILL_NB, AL1.LN_DEL_FULL_DATE_ID, AL2.DELIVERY_SIGNATURE_TX, AL3.TWENTY_FOUR_HOUR_MINUTE_NM FROM DWSINF1.V_DIM_LANE_DELIVERY_DATE AL1, DWSINF1.V_GT_LANE_FACT_B AL2, DWSINF1.V_DIM_HOUR_MINUTE AL3 WHERE ORIGINAL_HOUSE_AIRWAY_BILL_NB = 'PEA609343' AND (AL2.FINAL_DELIVERY_DATE_KE=AL1.LN_DELIVERY_DATE_KE) and AL2.DELIVERY_DATE_HOUR_MINUTE_KE = AL3.HOUR_MINUTE_KE"
    
        'PEA609343
    
        myConn= New OleDbConnection(connStr)
        myConn.Open()
        myOleDbAdapter =New OleDbDataAdapter(sqlStr,myConn)
        myOleDbAdapter.Fill(myDataSet,"dtProducts")
        DataGrid2.DataSource=myDataSet.Tables("dtProducts")
        DataGrid2.DataBind()
        myConn.Close()
    End Sub
    
    Sub Button1_Click(sender As Object, e As EventArgs)
        DownloadFams
    End Sub
    
    Sub Button2_Click(sender As Object, e As EventArgs)
        DownloadArgus
    End Sub
    
    Sub Button3_Click(sender As Object, e As EventArgs)
        InsertToDB
    End Sub
    
    Sub InsertToDB
            Dim SqlStr as string
            Dim connStr as string
            Dim dbConnection As OleDbConnection
    
            connStr="Provider=IBMDA400.DataSource.1;User ID=MYPGINTEL;Password=MYPGINTEL;Data Source=SinAS400;Connect Timeout=30;SSL=DEFAULT;Transport Product=Client Access"
            dbConnection = New OleDbConnection(connStr)
    
            Dim HAWB As String
            Dim strSQL As String
            Dim CN_NAME As String
            Dim BT_NAME As String
            Dim MyCommand As New OleDb.OleDbCommand 'FAMS Command
            Dim MyReader As OleDb.OleDbDataReader   'FAMS DATA
            Dim strDbString As String   'Connection string
            Dim ErrFlag As Boolean = True
            Dim PickUpTime,TransDate,PickUpDate,ETA,ATD as string
    
    
            sqlStr = "Select T02.JOBNO,T01.TRANDATE,T01.INVTYPE,T02.servlevel,T02.HAWBNO,T02.CONSGN, T02.CONSIGNNAM, T02.BILLTO,'BILL Date',T02.HOUSEORIG, T02.HAWBDEST, T03.PICKUPDATE, T03.PICKUPTIME,T02.etaetd,T02.ataatd,T02.ACTWGTEXPC,T02.CHGWGTEXPC,T06.CURRCODE, T01.BILLAMT,T02.Pieces01,T02.SERVTYPE,T03.GOODSDESC2,'Frt Terms','POD DateTime' " & _
            "FROM BMBAXEIS.BCUMINV T01, BMBAXEIS.BEXPAIRDTL T02, BMOBJ.F001P04 T03, BMOBJ.V001P01 T05, BMOBJ.A011P01 T06, BMOBJ.V001P08 T07, BMOBJ.F002P83 T08 " & _
            "WHERE T01.JOBNO = T02.JOBNO " & _
            "AND T01.JOBNO = T03.JOBNO " & _
            "AND T02.CLIENT = T05.COMPANY " & _
            "AND T01.BRANCH = 'P' " & _
            "AND T01.JOBNO LIKE 'PEA%' " & _
            "AND T01.CURR = T06.CURRCODE " & _
            "AND T02.CLIENT = T07.COMPANY " & _
            "AND T01.TRANDATE >= '20061101' " & _
            "AND T01.TRANDATE <= '20061115' " & _
            "AND T02.BILLTO in ('KOMUSA','MOMMAL') " & _
            "AND SUBSTRING(T01.JOBNO,4,6) = T08.JOBNO"
    
            MyCommand.Connection = dbConnection
            MyCommand.CommandType = CommandType.Text
            MyCommand.CommandText = sqlStr
            dbConnection.Open()
            MyReader = MyCommand.ExecuteReader
    
            ExecuteNonQuery("Truncate table komagEBilling")
    
            Do While (MyReader.Read)
    
                PickUpTime = mid(MyReader.Item("PickUpTime"),1,2) & ":" & mid(MyReader.Item("PickUpTime"),3,2)
    
                if trim(MyReader.Item("TRANDATE")) = "" then transDate = "NULL" else TransDate = mid(trim(MyReader.Item("TranDate")),5,2) & "/" & mid(trim(MyReader.Item("TranDate")),7,2) & "/" & mid(trim(MyReader.Item("TranDate")),1,4)
                if trim(MyReader.Item("PICKUPDATE")) <> "" then PickUpDate = mid(trim(MyReader.Item("PICKUPDATE")),5,2) & "/" & mid(trim(MyReader.Item("PICKUPDATE")),7,2) & "/" & mid(trim(MyReader.Item("PICKUPDATE")),1,4)
    
                if trim(MyReader.Item("etaetd")) = "" then ETA = "NULL" else ETA = mid(trim(MyReader.Item("etaetd")),5,2) & "/" & mid(trim(MyReader.Item("etaetd")),7,2) & "/" & mid(trim(MyReader.Item("etaetd")),1,4)
                if trim(MyReader.Item("ataatd")) = "" then ATD = "NULL" else ATD = mid(trim(MyReader.Item("ataatd")),5,2) & "/" & mid(trim(MyReader.Item("ataatd")),7,2) & "/" & mid(trim(MyReader.Item("ataatd")),1,4)
    
                ExecuteNonQuery("Insert into komagEBilling(JobNo,TransDate,InvType,HAWBNo,consign,ConsignName,billto,houseOri,HouseDest,CurrCode,ServType,PickUpDate,eta,atd,actualWeight,ChargeWeight,BillAmt,GoodsDesc,PickUpTime,FrtTerms,BillDate,Qty) select '" & trim(MyReader.Item("jobno")) & "','" & TransDate & "','" & trim(MyReader.Item("InvType")) & "','" & trim(MyReader.Item("HAWBNo")) & "','" & trim(MyReader.Item("consgn")) & "','" & trim(MyReader.Item("consignnam")) & "','" & trim(MyReader.Item("BillTo")) & "','" & trim(MyReader.Item("HOUSEORIG")) & "','" & trim(MyReader.Item("HAWBDEST")) & "','" & trim(MyReader.Item("CurrCode")) & "','" & trim(MyReader.Item("ServType")) & "','" & trim(PickUpdate) & "','" & eta & "','" & atd & "'," & MyReader.Item("ACTWGTEXPC") & "," & MyReader.Item("CHGWGTEXPC") & "," & MyReader.Item("BillAmt") & ",'" & MyReader.Item("GOODSDESC2") & "','" & pickuptime & "','" & MyReader.Item("ServLevel") & "','" & TransDate & "'," & MyReader.Item("Pieces01") & ";")
                hawb = hawb + "'" & Trim(MyReader.Item("HAWBNO")) & "'" + ","
            Loop
    
            TextBox1.text = "(" & trim(mid(hawb,1,len(hawb)-1)) & ")"
    End sub
    
    Sub Button4_Click(sender As Object, e As EventArgs)
    
        Dim dbConnection As New OleDb.OleDbConnection
        Dim strSQL As String
        Dim connStr As String
        Dim MyCommand As New OleDb.OleDbCommand
        Dim MyCommand1 As New OleDb.OleDbCommand
        Dim MyCommand2 As New OleDb.OleDbCommand
        Dim MyReader As OleDb.OleDbDataReader
        Dim MyReader1 As OleDb.OleDbDataReader
        Dim MyReader2 As OleDb.OleDbDataReader
        Dim ErrFlag As Boolean = True
    
    
        connStr="Provider=MSDAORA;Password=penygw1;User ID=penygw1;Data Source=Argus"
        dbConnection = New OleDbConnection(connStr)
    
        MyCommand1.Connection = dbConnection
        MyCommand1.CommandType = CommandType.Text
    
        MyCommand1.CommandText = "SELECT AL2.ORIGINAL_HOUSE_AIRWAY_BILL_NB, AL1.LN_DEL_FULL_DATE_ID, AL2.DELIVERY_SIGNATURE_TX, AL3.TWENTY_FOUR_HOUR_MINUTE_NM FROM DWSINF1.V_DIM_LANE_DELIVERY_DATE AL1, DWSINF1.V_GT_LANE_FACT_B AL2, DWSINF1.V_DIM_HOUR_MINUTE AL3 WHERE ORIGINAL_HOUSE_AIRWAY_BILL_NB in " & trim(TextBox1.text) & " AND (AL2.FINAL_DELIVERY_DATE_KE=AL1.LN_DELIVERY_DATE_KE) and AL2.DELIVERY_DATE_HOUR_MINUTE_KE = AL3.HOUR_MINUTE_KE"
    
    
        dbConnection.Open()
        MyReader1 = MyCommand1.ExecuteReader
        Do While (MyReader1.Read)
            ExecuteNonQuery("Update komagEBilling set PODDate = '" & MyReader1.Item("LN_DEL_FULL_DATE_ID") & "', PODTime = '" & MyReader1.Item("TWENTY_FOUR_HOUR_MINUTE_NM") & "' where HAWBNo = '" & trim(MyReader1.Item("ORIGINAL_HOUSE_AIRWAY_BILL_NB")) & "';")
        Loop
    
        If Not MyReader1 Is Nothing Then MyReader1 = Nothing
        If Not MyCommand1 Is Nothing Then MyCommand1 = Nothing
    
        If Not dbConnection Is Nothing Then dbConnection = Nothing
        If Not MyCommand Is Nothing Then MyCommand = Nothing
        If Not MyCommand1 Is Nothing Then MyCommand = Nothing
        If Not MyCommand2 Is Nothing Then MyCommand = Nothing
        If Not MyReader Is Nothing Then MyReader = Nothing
    End Sub
    
    Sub GetDataFromArgus
        Dim myConn As OleDbConnection
        Dim myOleDbAdapter As OleDbDataAdapter
        Dim connStr, sqlStr As String
        Dim myDataSet As New Dataset
        connStr="Provider=MSDAORA;Password=penygw1;User ID=penygw1;Data Source=Argus"
        sqlStr="SELECT AL2.ORIGINAL_HOUSE_AIRWAY_BILL_NB, AL1.LN_DEL_FULL_DATE_ID, AL2.DELIVERY_SIGNATURE_TX, AL3.TWENTY_FOUR_HOUR_MINUTE_NM FROM DWSINF1.V_DIM_LANE_DELIVERY_DATE AL1, DWSINF1.V_GT_LANE_FACT_B AL2, DWSINF1.V_DIM_HOUR_MINUTE AL3 WHERE ORIGINAL_HOUSE_AIRWAY_BILL_NB in " & trim(TextBox1.text) & " AND (AL2.FINAL_DELIVERY_DATE_KE=AL1.LN_DELIVERY_DATE_KE) and AL2.DELIVERY_DATE_HOUR_MINUTE_KE = AL3.HOUR_MINUTE_KE"
        myConn= New OleDbConnection(connStr)
        myConn.Open()
        myOleDbAdapter =New OleDbDataAdapter(sqlStr,myConn)
        myOleDbAdapter.Fill(myDataSet,"dtProducts")
        DataGrid2.DataSource=myDataSet.Tables("dtProducts")
        DataGrid2.DataBind()
        myConn.Close()
    End Sub
    
    Sub ExecuteNonQuery(ByVal SQL As String)
        Dim cnnExecuteNonQuery As SqlConnection = New SqlConnection("server=pen4202;user id=sa;password=sql;database=komagebilling;pooling=false")
        cnnExecuteNonQuery.Open()
        Dim myCommand As New sqlCommand
        myCommand.Connection = cnnExecuteNonQuery
        myCommand.CommandText = SQL
        myCommand.CommandType = CommandType.Text
        myCommand.ExecuteNonQuery()
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <script>

</script>
    <form runat="server">
        <p>
            <asp:DataGrid id="GridControl1" runat="server" AutoGenerateColumns="False" ShowFooter="True" cellpadding="4" BorderColor="Gray" PageSize="20" PagerStyle-NextPageText="Next" PagerStyle-PrevPageText="Prev" PagerStyle-HorizontalAligh="Right" OnItemCommand="ShowDet" width="100%">
                <FooterStyle cssclass="GridFooter"></FooterStyle>
                <HeaderStyle bordercolor="White" cssclass="GridHeaderSmall"></HeaderStyle>
                <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                <ItemStyle cssclass="GridItem"></ItemStyle>
                <Columns></Columns>
            </asp:DataGrid>
        </p>
        <p>
        </p>
        <p>
            <asp:DataGrid id="dataGrid1" runat="server">
                <HeaderStyle font-size="XX-Small" font-names="Verdana" font-bold="True" forecolor="White" backcolor="Silver"></HeaderStyle>
                <ItemStyle font-size="XX-Small" font-names="Verdana"></ItemStyle>
            </asp:DataGrid>
            <asp:DataGrid id="DataGrid2" runat="server">
                <HeaderStyle font-size="XX-Small" font-names="Verdana" font-bold="True" forecolor="White" backcolor="Silver"></HeaderStyle>
                <ItemStyle font-size="XX-Small" font-names="Verdana"></ItemStyle>
            </asp:DataGrid>
            <asp:Button id="Button1" onclick="Button1_Click" runat="server" Text="Download FAMS"></asp:Button>
            <asp:Button id="Button2" onclick="Button2_Click" runat="server" Text="Button"></asp:Button>
        </p>
        <p>
            <asp:Button id="Button3" onclick="Button3_Click" runat="server" Text="FAMS Insert to DB"></asp:Button>
            <asp:Button id="Button4" onclick="Button4_Click" runat="server" Text="Insert into DB from FAMS and ARGUS" Width="275px"></asp:Button>
        </p>
        <!-- Insert content here -->
        <p>
            <asp:TextBox id="TextBox1" runat="server"></asp:TextBox>
        </p>
    </form>
</body>
</html>
