<%@ Page Language="VB" Debug="TRUE" %>
<%@ Register TagPrefix="IBuySpy" TagName="Header" Src="_Header.ascx" %>
<%@ import Namespace="System.data" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.configuration" %>
<%@ import Namespace="System.data.sqlclient" %>
<%@ import Namespace="System.Collections" %>
<%@ import Namespace="System.Text" %>
<%@ import Namespace="System.Web.UI.WebControls" %>
<script runat="server">

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        if page.ispostback = false then
        End if
    End Sub
    
    SUb Dissql(ByVal strSql As String,FValue as string, FText as string,Obj as Object)
        Dim ReqExeDataReader as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
        Dim ResExeDataReader as SQLDataReader = ReqExeDataReader.ExeDataReader(StrSql)
    
        with obj
            .items.clear
            .DataSource = ResExeDataReader
            .DataValueField = FValue
            .DataTextField = FText
            .DataBind()
        end with
        ResExeDataReader.close()
    End Sub
    
    Sub cmdUpdate_Click(sender As Object, e As EventArgs)
    End Sub
    
    Sub cmdMain_Click(sender As Object, e As EventArgs)
        response.redirect("Main.aspx")
    End Sub
    
    Sub cmdFinish_Click(sender As Object, e As EventArgs)
        response.redirect("Default.aspx")
    End Sub
    
    Sub cmdGO_Click(sender As Object, e As EventArgs)
        Dim rs as SQLDataReader
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
        Dim TotalIssuedIncAlt as long
    
        ReqCOM.ExecuteNonQuery("TRUNCATE TABLE MAT_ISSUING_LIST")
        ''ReqCOM.ExecuteNonQuery("INSERT INTO MAT_ISSUING_LIST(JO_NO,P_LEVEL,PART_NO,MAIN_PART,TOTAL_ISSUED) SELECT '" & trim(txtJONo.text) & "','" & trim(cmbLevel.selecteditem.value) & "',PART_NO,MAIN_PART,SUM(QTY_ISSUED) FROM MAT_ISSUING_D WHERE ISSUING_NO IN (SELECT ISSUING_NO FROM MAT_ISSUING_M WHERE JO_NO = '" & trim(txtJONo.text) & "' AND P_LEVEL = '" & trim(cmbLevel.selecteditem.value) & "') GROUP BY PART_NO,MAIN_PART")
        'ReqCOM.ExecuteNonQuery("INSERT INTO MAT_ISSUING_LIST(JO_NO,P_LEVEL,PART_NO,MAIN_PART,TOTAL_ISSUED) SELECT '" & trim(txtJONo.text) & "',P_LEVEL,PART_NO,MAIN_PART,SUM(QTY_ISSUED) FROM MAT_ISSUING_D WHERE ISSUING_NO IN (SELECT ISSUING_NO FROM MAT_ISSUING_M WHERE JO_NO = '" & trim(txtJONo.text) & "') GROUP BY PART_NO,MAIN_PART,P_LEVEL")
        ReqCOM.ExecuteNonQuery("INSERT INTO MAT_ISSUING_LIST(JO_NO,P_LEVEL,PART_NO,MAIN_PART,TOTAL_ISSUED,p_usage) SELECT '" & trim(txtJONo.text) & "',P_LEVEL,PART_NO,MAIN_PART,QTY_ISSUED,p_usage FROM MAT_ISSUING_D WHERE ISSUING_NO IN (SELECT ISSUING_NO FROM MAT_ISSUING_M WHERE JO_NO = '" & trim(txtJONo.text) & "')")
    
    
        ReqCOM.ExecuteNonQuery("UPDATE MAT_ISSUING_LIST SET MAT_ISSUING_LIST.STORE_BAL = PART_MASTER.BAL_QTY FROM MAT_ISSUING_LIST, PART_MASTER WHERE PART_MASTER.PART_NO = MAT_ISSUING_LIST.PART_NO")
        ReqCOM.ExecuteNonQuery("UPDATE MAT_ISSUING_LIST SET MODEL_NO = '" & trim(lblModelNo.text) & "';")
        ReqCOM.ExecuteNonQuery("UPDATE MAT_ISSUING_LIST SET LOT_SIZE = " & clng(lblJOSize.text) & ";")
        ReqCOM.ExecuteNonQuery("UPDATE MAT_ISSUING_LIST SET MAT_ISSUING_LIST.P_USAGE = BOM_D.P_USAGE FROM MAT_ISSUING_LIST, BOM_D WHERE MAT_ISSUING_LIST.PART_NO = BOM_D.PART_NO AND MAT_ISSUING_LIST.MODEL_NO = BOM_D.MODEL_NO AND MAT_ISSUING_LIST.P_LEVEL = BOM_D.P_LEVEL")
        ReqCOM.ExecuteNonQuery("UPDATE MAT_ISSUING_LIST SET TOTAL_USAGE = LOT_SIZE * P_USAGE")
        ReqCOM.ExecuteNonQuery("Update Mat_Issuing_List set Extra_Req = 0")
        ReqCOM.ExecuteNonQUery("Update Mat_Issuing_List set Type = 'M' where Main_Part = Part_No")
        ReqCOM.ExecuteNonQUery("Update Mat_Issuing_List set Type = 'A' where Main_Part <> Part_No")
    
        UpdateMRFQty()
        UpdateMERFQty()
    
        myConnection.Open()
    
        Dim myCommand As SqlCommand = New SqlCommand("Select * from MAT_ISSUING_LIST where type = 'M' and main_part in (Select Main_Part from Mat_Issuing_LIst where Type = 'A')", myConnection)
        rs = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
    
        do while rs.read
            'ReqCOM.ExecuteNonQuery("Update MAT_ISSUING_LIST set p_uSAGE = " & rs("P_Usage") & ",Total_Usage = " & rs("Total_Usage") & " WHERE mAIN_pART = '" & TRIM(rs("Main_Part")) & "' AND tYPE = 'A'")
            TotalIssuedIncAlt = ReqCOM.GetFieldVal("Select sum(Total_Issued) as [TotalIssued] from MAT_ISSUING_LIST where Main_Part = '" & trim(rs("Main_Part")) & "';","TotalIssued")
            ReqCOM.ExecuteNonQuery("Update Mat_Issuing_LIst set Total_Issued_Inc_Alt = " & TotalIssuedIncAlt & " where Main_Part = '" & trim(rs("Main_Part")) & "';")
        loop
    
        myCommand.dispose()
        rs.close()
        myConnection.Close()
        myConnection.Dispose()
    
        ReqCOM.ExecuteNonQuery("Update MAT_ISSUING_LIST set Total_Issued_Inc_Alt = Total_Issued where Total_Issued_Inc_Alt is null")
        ReqCOM.ExecuteNonQuery("UPDATE MAT_ISSUING_LIST SET BAL_TO_ISSUE = TOTAL_USAGE - TOTAL_ISSUED_Inc_Alt")
    
        ReqCOM.ExecuteNonQuery("Update Mat_Issuing_List set Extra_Issued = TOTAL_ISSUED_Inc_Alt - TOTAL_USAGE")
    
        ReqCOM.ExecuteNonQuery("Update Mat_Issuing_List set Main_Alt = 'Main' where main_part = part_no")
        ReqCOM.ExecuteNonQuery("Update Mat_Issuing_List set Main_Alt = 'Alt.' where main_part <> part_no")
    
        ReqCOM.executeNonquery("Delete from mat_issuing_list where p_usage = 0")
        ShowReport("PopupReportViewer.aspx?RptName=MaterialIssuingJOLevel&LotNo=" & trim(lblLotNo.text) & "&LotSize=" & clng(lblLotSize.text) & "&JONo=" & trim(txtJONo.text) & "&JOSize=" & clng(lblJoSize.text) & "&Level=&ModelDet=" & trim(lblModelNo.text) & "-" & trim(lblModelDesc.text))
    
        redirectPage("MaterialIssuingTrackingTemp.aspx")
    End Sub
    
    Sub UpdateMRFQty()
        Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
        Dim rs as SQLDataReader
        myConnection.Open()
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
    
        'Dim myCommand As SqlCommand = New SqlCommand("SELECT distinct(Main_Part) as [MainPart],part_no,sum(qty_return) as [QtyReturn] FROM MRF_D WHERE MRF_No IN (SELECT MRF_No FROM MRF_M WHERE MRF_STATUS = 'APPROVED' AND JO_NO = '" & trim(txtJONo.text) & "' AND P_LEVEL = '" & trim(cmbLevel.selecteditem.value) & "') group by part_no,main_part", myConnection)
        Dim myCommand As SqlCommand = New SqlCommand("SELECT distinct(Main_Part) as [MainPart],part_no,sum(qty_return) as [QtyReturn] FROM MRF_D WHERE MRF_No IN (SELECT MRF_No FROM MRF_M WHERE MRF_STATUS = 'APPROVED' AND JO_NO = '" & trim(txtJONo.text) & "') group by part_no,main_part", myConnection)
    
        rs = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
    
        do while rs.read
            ReqCOM.ExecuteNonQUery("Update Mat_Issuing_List set Total_Issued = Total_Issued - " & rs("QtyReturn") & " where Main_Part = '" & trim(rs("MainPart")) & "' and Part_NO = '" & trim(rs("Part_No")) & "';")
        loop
    
        myCommand.dispose()
        rs.close()
        myConnection.Close()
        myConnection.Dispose()
    End sub
    
    Sub UpdateMERFQty()
        Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
        Dim rs as SQLDataReader
        myConnection.Open()
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
    
        'Dim myCommand As SqlCommand = New SqlCommand("SELECT Main_Part as [MainPart],part_no,Qty_Req as [QtyReq] FROM MERF_D WHERE MERF_No IN (SELECT MERF_No FROM MERF_M WHERE MERF_STATUS = 'APPROVED' AND JO_NO = '" & trim(txtJONo.text) & "' AND P_LEVEL = '" & trim(cmbLevel.selecteditem.value) & "')", myConnection)
        Dim myCommand As SqlCommand = New SqlCommand("SELECT Main_Part as [MainPart],part_no,Qty_Req as [QtyReq] FROM MERF_D WHERE MERF_No IN (SELECT MERF_No FROM MERF_M WHERE MERF_STATUS = 'APPROVED' AND JO_NO = '" & trim(txtJONo.text) & "')", myConnection)
    
        rs = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
    
        do while rs.read
            ReqCOM.ExecuteNonQUery("Update Mat_Issuing_List set Extra_Req = Extra_Req + " & rs("QtyReq") & " where Main_Part = '" & trim(rs("MainPart")) & "' and Part_NO = '" & trim(rs("Part_No")) & "';")
        loop
    
        myCommand.dispose()
        rs.close()
        myConnection.Close()
        myConnection.Dispose()
    End sub
    
    Sub redirectPage(ReturnURL as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>window.location=""" & ReturnURL & """;</script" & ">"
        If (Not IsStartupScriptRegistered("ClientRedirect")) Then Page.RegisterStartupScript("ClientRedirect", strScript)
    End sub
    
    Sub ShowReport(ReturnURL as string)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=250');")
        Script.Append("</script" & ">")
        RegisterStartupScript("ShowExistingSupplier", Script.ToString())
    End sub
    
    Sub Button1_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
    
        'if cmbLevel.selectedindex = -1 then
        '    ShowAlert("You don't seem to have supplied a valid J/O No.")
        'elseif cmbLevel.selectedindex = 0 then
            lblJoSize.text = ReqCOM.GetFieldVal("Select top 1 Prod_Qty from Job_Order_M where JO_No = '" & trim(txtJONo.text) & "';","Prod_Qty")
            lblLotNo.text = ReqCOM.GetFieldVal("Select top 1 Lot_No from Job_Order_M where JO_No = '" & trim(txtJONo.text) & "';","Lot_No")
            lblLotSize.text = ReqCOM.GetFieldVal("Select Order_Qty from SO_Models_M where Lot_No = '" & trim(lblLotNo.text) & "';","Order_Qty")
            lblModelNo.text = ReqCOM.GetFieldVal("Select Model_No from So_Models_M where Lot_No = '" & trim(lblLotNo.text) & "';","Model_No")
            lblModelDesc.text = ReqCOM.GetFieldVal("Select Model_Desc from Model_Master where Model_Code = '" & trim(lblModelNo.text) & "';","model_Desc")
        'end if
     End Sub
    
     Sub ShowAlert(Msg as string)
         Dim strScript as string
         strScript = "<" & "script language=JavaScript>alert(""" & Msg & """)</script" & ">"
         If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
     End sub
    
     Sub cmbLevel_SelectedIndexChanged(sender As Object, e As EventArgs)
     End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form runat="server">
        <p>
            <table style="HEIGHT: 8px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <IBUYSPY:HEADER id="UserControl2" runat="server"></IBUYSPY:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div align="center"><asp:Label id="Label3" runat="server" cssclass="FormDesc" width="100%">MATERIAL
                                ISSUING TRACKING</asp:Label>
                            </div>
                            <p>
                                <table style="HEIGHT: 6px" cellspacing="0" cellpadding="0" width="80%" align="center">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                </p>
                                                <p>
                                                </p>
                                                <p>
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td width="25%" bgcolor="silver">
                                                                    <asp:Label id="Label1" runat="server" width="100%">Job Order No</asp:Label></td>
                                                                <td width="75%">
                                                                    <asp:TextBox id="txtJONo" runat="server" Width="254px" CssClass="OutputText"></asp:TextBox>
                                                                    &nbsp; 
                                                                    <asp:Button id="Button1" onclick="Button1_Click" runat="server" Width="64px" CssClass="OutputText" Text="GO"></asp:Button>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label8" runat="server" width="100%">J/O Size</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblJOSize" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label7" runat="server" width="100%">Model No / Desc</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblModelNo" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblModelDesc" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label4" runat="server" width="100%">Lot No</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblLotNo" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label5" runat="server" width="100%">Lot Size</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblLotSize" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 13px" cellspacing="0" cellpadding="0" width="100%" align="center">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p>
                                                                        <asp:Button id="cmdGO" onclick="cmdGO_Click" runat="server" Width="120px" Text="View Report"></asp:Button>
                                                                    </p>
                                                                </td>
                                                                <td>
                                                                    <p align="right">
                                                                        <asp:Button id="cmdFinish" onclick="cmdFinish_Click" runat="server" Width="120px" Text="Back"></asp:Button>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </p>
                        </td>
                    </tr>
                </tbody>
            </table>
        </p>
    </form>
</body>
</html>
