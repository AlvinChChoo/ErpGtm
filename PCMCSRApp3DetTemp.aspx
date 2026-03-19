<%@ Page Language="VB" Debug="true" %>
<%@ Register TagPrefix="IBuySpy" TagName="Header" Src="_Header.ascx" %>
<%@ Register TagPrefix="cr" Namespace="CrystalDecisions.Web" Assembly="CrystalDecisions.Web, Version=10.0.3300.0, Culture=neutral, PublicKeyToken=692fbea5521e1304" %>
<%@ import Namespace="System.data" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.configuration" %>
<%@ import Namespace="System.data.sqlclient" %>
<%@ import Namespace="System.Collections" %>
<%@ import Namespace="System.Text" %>
<%@ import Namespace="System.Web.UI.WebControls" %>
<%@ import Namespace="System.Web.Mail" %>
<%@ import Namespace="CrystalDecisions.CrystalReports.Engine" %>
<%@ import Namespace="CrystalDecisions.Web" %>
<%@ import Namespace="CrystalDecisions.Shared" %>
<script runat="server">

    Private repDoc As New ReportDocument()
    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
            if page.isPostBack = false then
                loadGridData
                ProcLoadGridData
                ProcLoadAtt
                gridcontrol1.visible = true
                ShowReport
            End if
        End Sub
    
        Sub loadGridData()
            Dim strSql as string = "SELECT * FROM SR_M where SEQ_NO = " & request.params("ID") & ";"
            Dim ReqExeDataReader as Erp_Gtm.Erp_Gtm  = new Erp_Gtm.Erp_Gtm
            Dim ResExeDataReader as SQLDataReader = ReqExeDataReader.ExeDataReader(strSql)
                 do while ResExeDataReader.read
                     lblSRNo.text = ResExeDataReader("SR_NO")
                     lblRemarks.text = ResExeDataReader("Remarks").tostring
                     if isdbnull(ResExeDataReader("Submit_By")) = false then lblSubmitby.text = ucase(ResExeDataReader("Submit_By"))
                     if isdbnull(ResExeDataReader("Submit_Date")) = false then lblSubmitDate.text = format(cdate(ResExeDataReader("Submit_Date")),"dd/MMM/yy")
    
                    if isdbnull(ResExeDataReader("App1_By")) = false then lblApp1By.text = ucase(ResExeDataReader("App1_By"))
                    if isdbnull(ResExeDataReader("App1_Date")) = false then lblApp1Date.text = format(cdate(ResExeDataReader("App1_Date")),"dd/MMM/yy")
                    If isdbnull(ResExeDataReader("app1_Rem")) = true then lblApp1Rem.text = "-"
                    If isdbnull(ResExeDataReader("app1_Rem")) = false then lblApp1Rem.text = ResExeDataReader("App1_Rem").tostring
    
                    if isdbnull(ResExeDataReader("App2_By")) = false then lblApp2By.text = ucase(ResExeDataReader("App2_By"))
                    if isdbnull(ResExeDataReader("App2_Date")) = false then lblApp2Date.text = format(cdate(ResExeDataReader("App2_Date")),"dd/MMM/yy")
                    If isdbnull(ResExeDataReader("app2_Rem")) = true then lblApp2Rem.text = "-"
                    If isdbnull(ResExeDataReader("app2_Rem")) = false then lblApp2Rem.text = ResExeDataReader("App2_Rem").tostring
    
                    if isdbnull(ResExeDataReader("App3_By")) = false then lblApp3By.text = ucase(ResExeDataReader("App3_By"))
                    if isdbnull(ResExeDataReader("App3_Date")) = false then lblApp3Date.text = format(cdate(ResExeDataReader("App3_Date")),"dd/MMM/yy")
                    If isdbnull(ResExeDataReader("app3_Rem")) = true then lblApp3Rem.text = "-"
                    If isdbnull(ResExeDataReader("app3_Rem")) = false then lblApp3Rem.text = ResExeDataReader("App3_Rem").tostring
    
                    if isdbnull(ResExeDataReader("App3_By")) = false then
                        label1.visible = false
                        txtrem.visible =false
                        rbapprove.visible =false
                        rbReject.visible = false
                        cmdApprove.visible = false
                    else
                        if ResExeDataReader("SR_STATUS") = "REJECTED" then
                            label1.visible = false
                            txtrem.visible =false
                            rbapprove.visible =false
                            rbReject.visible = false
                            cmdApprove.visible = false
                        else
                            label1.visible = true
                            txtrem.visible =true
                            rbapprove.visible =true
                            rbReject.visible = true
                            cmdApprove.visible = true
                        end if
                    end if
                 loop
         end sub
    
         Sub ProcLoadGridData()
             Dim StrSql as string = "Select srd.std_pack_qty,srd.min_order_qty,srd.up,ven.ven_name,pm.part_spec,srd.qty_to_buy,srd.eta_date,srd.spare_qty,SRD.Lot_No, SRD.Seq_No,SRD.REQ_QTY,PM.Part_Desc as [Desc],PM.Part_No as Part_No,SRD.REQ_QTY + srd.spare_qty as [TotalQty] from SR_D SRD,Part_Master PM,vendor ven where srd.ven_code = ven.ven_Code and SRD.SR_No = '" & trim(lblSRNo.text) & "' and SRD.Part_No = PM.Part_No"
             Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
             Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"SR_D")
             GridControl1.DataSource=resExePagedDataSet.Tables("SR_D").DefaultView
             GridControl1.DataBind()
         end sub
    
         Sub Menu1_Load(sender As Object, e As EventArgs)
         End Sub
    
         Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
         End Sub
    
         Sub cmdMain_Click(sender As Object, e As EventArgs)
             response.redirect("Main.aspx")
         End Sub
    
         Sub Button2_Click(sender As Object, e As EventArgs)
         End Sub
    
         Sub cmdAddNew_Click(sender As Object, e As EventArgs)
             response.redirect("CustomerAddNew.aspx")
         End Sub
    
         Sub UserControl2_Load(sender As Object, e As EventArgs)
         End Sub
    
         Sub cmdBack_Click(sender As Object, e As EventArgs)
             Response.redirect("PCMCSRApp3.aspx")
         End Sub
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim ETADate As Label = CType(e.Item.FindControl("ETADate"), Label)
            Dim SpareQty As Label = CType(e.Item.FindControl("SpareQty"), Label)
            Dim ReqQty As Label = CType(e.Item.FindControl("ReqQty"), Label)
            Dim TotalQty As Label = CType(e.Item.FindControl("TotalQty"), Label)
            Dim QtyToBuy As Label = CType(e.Item.FindControl("QtyToBuy"), Label)
            Dim MOQ As Label = CType(e.Item.FindControl("MOQ"), Label)
            Dim SPQ As Label = CType(e.Item.FindControl("SPQ"), Label)
            Dim UP As Label = CType(e.Item.FindControl("UP"), Label)
            Dim Amt As Label = CType(e.Item.FindControl("Amt"), Label)
    
            moq.text = format(cdec(moq.text),"##,##0")
            SPQ.text = format(cdec(SPQ.text),"##,##0")
            ETADate.text = format(cdate(ETADate.text),"dd/MMM/yy")
            SpareQty.text = "0"
            QtyToBuy.text = format(cdec(QtyToBuy.text),"##,##0")
            TotalQty.text = format(cdec(ReqQty.text),"##,##0")
            TotalQty.text = cdec(QtyToBuy.text) - cdec(ReqQty.text)
            Amt.text = UP.text * QtyToBuy.text
            if cdec(TotalQty.text) <> 0 then e.Item.CssClass = "PartSource"
        End if
    End Sub
    
    Sub cmdApprove_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim MReceiver,MSender,cc,StrSql as string
    
        if rbApprove.checked = true then
            ReqCOM.ExecuteNonQuery("Update SR_M set App3_By = '" & trim(request.cookies("U_ID").value) & "',App3_Date = '" & now & "',App3_Rem = '" & trim(txtRem.text) & "',App3_Status='Y' where SR_No = '" & trim(lblSRNo.text) & "';")
            ReqCOM.ExecuteNonQuery("Update Buyer_SR_M set App1_By = '" & trim(request.cookies("U_ID").value) & "',App1_Date = '" & now & "',App1_Rem = '" & trim(txtRem.text) & "',App1_Status='Y' where SR_No = '" & trim(lblSRNo.text) & "';")
            MReceiver = ReqCOM.GetFieldVal("Select EMail from User_Profile where U_ID = '" & trim(lblApp1By.text) & "';","Email")
            MSender = ReqCOM.GetFieldVal("Select EMail from User_Profile where U_ID = '" & trim(request.cookies("U_ID").value) & "';","Email")
            GenerateMail(MSender,MReceiver,CC,trim(lblSRNo.text),"Y")
            ShowAlert ("SR sumbitted for further approval.")
        elseif rbReject.checked = true then
            ReqCOM.ExecuteNonQuery("Update SR_M set App3_By = '" & trim(request.cookies("U_ID").value) & "',App3_Date = '" & now & "',App3_Rem = '" & trim(txtRem.text) & "',App3_Status='N',sr_status = 'REJECTED' where SR_No = '" & trim(lblSRNo.text) & "';")
            MReceiver = ReqCOM.GetFieldVal("Select EMail from User_Profile where U_ID in (Select Submit_By from sr_m where sr_no = '" & trim(lblSRNo.text) & "')","Email")
            CC = ReqCOM.GetFieldVal("Select EMail from User_Profile where U_ID in (Select App1_By from SR_M where SR_NO = '" & trim(lblSRNo.text) & "')","Email")
            CC = CC & ";" & ReqCOM.GetFieldVal("Select EMail from User_Profile where U_ID in (Select App2_By from SR_M where SR_NO = '" & trim(lblSRNo.text) & "')","Email")
            MSender = ReqCOM.GetFieldVal("Select EMail from User_Profile where U_ID = '" & trim(request.cookies("U_ID").value) & "';","Email")
            GenerateMail(MSender,MReceiver,CC,trim(lblSRNo.text),"N")
            ShowAlert ("Selected SR has been rejected.")
        end if
        redirectPage("PCMCSRApp3Det.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Sub ShowAlert(Msg as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>alert(""" & Msg & """)</script" & ">"
        If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
    End sub
    
    Sub redirectPage(ReturnURL as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>window.location=""" & ReturnURL & """;</script" & ">"
        If (Not IsStartupScriptRegistered("ClientRedirect")) Then Page.RegisterStartupScript("ClientRedirect", strScript)
    End sub
    
    Sub GenerateMail(Sender as string, Receiver as string,CC as string,DOcNo as string,SRStatus as string)
        Dim objEmail as New MailMessage()
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim StrMsg as string
        Dim TotalQty as decimal
        Dim TotalAmt as Decimal
        Dim POTotal as Decimal
        Dim ObjAttachment as MailAttachment
    
        if SRStatus = "Y" then
            StrMsg = "Dear " & ReqCOM.GetFieldVal("Select U_Name from User_Profile where EMail = '" & trim(Receiver) & "';","U_Name")  & vblf & vblf & vblf
            StrMsg = StrMsg + "Special Request has been completed approval loop." & vblf & vblf
            StrMsg = StrMsg + "Please proceed with P/O explosion." & vblf & vblf
            StrMsg = StrMsg + "Click on http://gtekapp/erp/signin.aspx?ReturnURL=PCMCSRApp4Det.aspx?ID=" & ReqCOM.GetFieldVal("Select Seq_No from SR_M where SR_NO = '" & trim(DOcNo) & "';","Seq_No") & " to view the details."   & vblf & vblf
            StrMsg = StrMsg + "For assistance, please contact " & ReqCOM.GetFieldval("Select U_Name from User_Profile where EMail = '" & trim(Sender) & "';","U_Name") & vblf  & vblf & vblf
            StrMsg = StrMsg + "Regards," & vblf & vblf
            StrMsg = StrMsg + ReqCOM.GetFieldval("Select U_Name from User_Profile where EMail = '" & trim(Sender) & "';","U_Name") & vblf & vblf
            objEmail.Subject  = "Special Request Pending P/O Explosion : " & DOcNo
        Elseif SRStatus = "N" then
            StrMsg = "Dear " & ReqCOM.GetFieldVal("Select U_Name from User_Profile where EMail = '" & trim(Receiver) & "';","U_Name")  & vblf & vblf & vblf
            StrMsg = StrMsg + "There is a Special Request rejected by " & Request.cookies("U_ID").value & vblf & vblf & vblf
            StrMsg = StrMsg + "Special Request Reference no is " & trim(DOcNo) & ". Please use this reference for future reference." & vblf & vblf & vblf
            StrMsg = StrMsg + "For assistance, please contact " & ReqCOM.GetFieldval("Select U_Name from User_Profile where EMail = '" & trim(Sender) & "';","U_Name") & vblf  & vblf & vblf
            StrMsg = StrMsg + "Regards," & vblf & vblf
            StrMsg = StrMsg + ReqCOM.GetFieldval("Select U_Name from User_Profile where EMail = '" & trim(Sender) & "';","U_Name") & vblf & vblf
            objEmail.Subject  = "Special Request Rejected : " & DOcNo
        end if
    
        objEmail.To       = trim(Receiver)
        objEmail.From     = trim(Sender)
        objEmail.CC       = trim(CC)
    
        objEmail.Body     = StrMsg
        objEmail.Priority = MailPriority.High
    
        SmtpMail.SmtpServer  = "192.168.42.111"
        SmtpMail.Send(objEmail)
    End sub
    
    Sub dtgUPASAttachment_SelectedIndexChanged(sender As Object, e As EventArgs)
    
    End Sub
    
        Sub ProcLoadAtt()
             Dim StrSql as string = "Select * from SR_ATTACHMENT where SR_NO = '" & trim(lblSRNo.text) & "';"
             Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
             Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"SR_ATTACHMENT")
             dtgUPASAttachment.DataSource=resExePagedDataSet.Tables("SR_ATTACHMENT").DefaultView
             dtgUPASAttachment.DataBind()
         end sub
    
    Sub ShowReport()
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        'Dim RptnAME as string = TRIM(rEQUEST.PARAMS("RptName"))
        Dim RptnAME as string = "PCMCSRDOC"
    
        repDoc.Load(Mappath("") + "\Report\" & trim(RptName) & ".rpt")
        Dim subRepDoc As New ReportDocument()
        Dim myDBName as string = "erp_gtm"
        Dim myOwner as string = "dbo"
        Dim crSections As Sections
        Dim crSection As Section
        Dim crReportObjects As ReportObjects
        Dim crReportObject As ReportObject
        Dim crSubreportObject As SubreportObject
        Dim crDatabase As Database
        Dim crTables As Tables
        Dim crTable As CrystalDecisions.CrystalReports.Engine.Table
        Dim crFormulas as FormulaFieldDefinitions
        Dim RptTitle as string
        Dim crFormulaTextField1 as FormulaFieldDefinition
        Dim crFormulaTextField2 as FormulaFieldDefinition
    
        crFormulas = repDoc.DataDefinition.FormulaFields
        crFormulaTextField1 = crFormulas.Item("ReportTitle")
        'crFormulaTextField2 = crFormulas.Item("CompanyName")
    
        Dim CompanyName as string = ReqCOM.getFieldVal("Select Company_Name from Main","Company_Name")
    
        Dim crLogOnInfo As TableLogOnInfo
        Dim crConnInfo As New ConnectionInfo()
    
        crDatabase = repDoc.Database
        crTables = crDatabase.Tables
    
        For Each crTable In crTables
            With crConnInfo
                .ServerName = ConfigurationSettings.AppSettings("ServerName")
                .DatabaseName = ConfigurationSettings.AppSettings("DatabaseName")
                .UserID = ConfigurationSettings.AppSettings("UserID")
                .Password = ConfigurationSettings.AppSettings("Password")
            End With
    
            crLogOnInfo = crTable.LogOnInfo
            crLogOnInfo.ConnectionInfo = crConnInfo
            crTable.ApplyLogOnInfo(crLogOnInfo)
    
        Next
        crTable.Location = myDBName & "." & myOwner & "." & crTable.Location.Substring(crTable.Location.LastIndexOf(".") + 1)
        crSections = repDoc.ReportDefinition.Sections
    
        For Each crSection In crSections
            crReportObjects = crSection.ReportObjects
            For Each crReportObject In crReportObjects
                If crReportObject.Kind = ReportObjectKind.SubreportObject Then
                    crSubreportObject = CType(crReportObject, SubreportObject)
                    subRepDoc = crSubreportObject.OpenSubreport(crSubreportObject.SubreportName)
                    crDatabase = subRepDoc.Database
                    crTables = crDatabase.Tables
                        For Each crTable In crTables
                            With crConnInfo
                                .ServerName = ConfigurationSettings.AppSettings("ServerName")
                                .DatabaseName = ConfigurationSettings.AppSettings("DatabaseName")
                                .UserID = ConfigurationSettings.AppSettings("UserID")
                                .Password = ConfigurationSettings.AppSettings("Password")
                            End With
    
                            crLogOnInfo = crTable.LogOnInfo
                            crLogOnInfo.ConnectionInfo = crConnInfo
                            crTable.ApplyLogOnInfo(crLogOnInfo)
                        Next
                    crTable.Location = myDBName & "." & myOwner & "." & crTable.Location.Substring(crTable.Location.LastIndexOf(".") + 1)
                End If
            Next
        Next
        'select case ucase(RptnAME)
    
        '    Case "SSERREJECTRPT"
            RptTitle = ""
            crFormulaTextField1.text = "'" & RptTitle & "'"
            'crFormulaTextField2.text = "'" & CompanyName & "'"
            CrystalReportViewer1.SelectionFormula = "{SR_M.Seq_No} = " & trim(Request.params("ID")) & ";"
        'End select
        CrystalReportViewer1.ReportSource = repDoc
        CrystalReportViewer1.RefreshReport()
    End sub
    
    Sub CrystalReportViewer1_Init(sender As Object, e As EventArgs)
    
    End Sub

</script>
<! Customer.aspx ><html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form enctype="multipart/form-data" runat="server">
        <p>
            <table style="HEIGHT: 5px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <IBUYSPY:HEADER id="UserControl2" runat="server" OnLoad="UserControl2_Load"></IBUYSPY:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label2" runat="server" cssclass="FormDesc" width="100%">SPECIAL REQUEST
                                DETAILS</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 12px" cellspacing="0" cellpadding="0" width="96%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" align="center" border="1">
                                                    <tbody>
                                                        <tr>
                                                            <td width="25%" bgcolor="silver">
                                                                <asp:Label id="Label3" runat="server" cssclass="LabelNormal">SR No</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblSRNo" runat="server" cssclass="OutputText" width="315px"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver" rowspan="2">
                                                                <asp:Label id="Label4" runat="server" cssclass="LabelNormal">Submitted By / Date</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblSubmitBy" runat="server" cssclass="OutputText" width=""></asp:Label>&nbsp;- <asp:Label id="lblSubmitDate" runat="server" cssclass="OutputText" width=""></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="lblRemarks" runat="server" cssclass="OutputText" width=""></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver" rowspan="2">
                                                                <asp:Label id="Label6" runat="server" cssclass="LabelNormal">App1 By/Date</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblApp1By" runat="server" cssclass="OutputText" width=""></asp:Label>&nbsp;- <asp:Label id="lblApp1Date" runat="server" cssclass="OutputText" width=""></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="lblApp1Rem" runat="server" cssclass="OutputText" width=""></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver" rowspan="2">
                                                                <asp:Label id="Label7" runat="server" cssclass="LabelNormal">App2 By/Date</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblApp2By" runat="server" cssclass="OutputText" width=""></asp:Label>&nbsp;- <asp:Label id="lblApp2Date" runat="server" cssclass="OutputText" width=""></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="lblApp2Rem" runat="server" cssclass="OutputText" width=""></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver" rowspan="2">
                                                                <asp:Label id="Label8" runat="server" cssclass="LabelNormal">App3 By/Date</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblApp3By" runat="server" cssclass="OutputText" width=""></asp:Label>&nbsp;- <asp:Label id="lblApp3Date" runat="server" cssclass="OutputText" width=""></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="lblApp3Rem" runat="server" cssclass="OutputText" width=""></asp:Label></td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                <p>
                                                    <table style="HEIGHT: 77px" cellspacing="0" cellpadding="0" width="100%" align="center">
                                                        <tbody>
                                                            <tr>
                                                                <td valign="top">
                                                                    <p>
                                                                        <asp:DataGrid id="dtgUPASAttachment" runat="server" width="100%" AlternatingItemStyle-CssClass="CartListItemAlt" ItemStyle-CssClass="CartListItem" HeaderStyle-CssClass="CartListHead" AutoGenerateColumns="False" cellpadding="4" GridLines="Vertical" BorderColor="Black" PageSize="50" OnSelectedIndexChanged="dtgUPASAttachment_SelectedIndexChanged">
                                                                            <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                                            <ItemStyle cssclass="GridItem"></ItemStyle>
                                                                            <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                                            <Columns>
                                                                                <asp:TemplateColumn visible="false">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="lblSeqNo" visible="false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "SEQ_NO") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:BoundColumn DataField="File_Desc" HeaderText="Description"></asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="File_Name" HeaderText="File Name"></asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="File_Size" HeaderText="File Size (Byte)"></asp:BoundColumn>
                                                                                <asp:HyperLinkColumn Text="Download" DataNavigateUrlField="Seq_No" DataNavigateUrlFormatString="DownloadPCMCSRAttachment.aspx?ID={0}"></asp:HyperLinkColumn>
                                                                            </Columns>
                                                                        </asp:DataGrid>
                                                                    </p>
                                                                    <p>
                                                                        &nbsp;<CR:CRYSTALREPORTVIEWER id="CrystalReportViewer1" runat="server" HasZoomFactorList="False" HasViewList="False" HasPrintButton="False" HasExportButton="False" HasDrillUpButton="False" HasGotoPageButton="False" HasSearchButton="False" DisplayGroupTree="False" HasCrystalLogo="False" HasToggleGroupTreeButton="False" OnInit="CrystalReportViewer1_Init" EnableParameterPrompt="False" EnableDatabaseLogonPrompt="False" borderwidth="1px" borderstyle="Dotted" pagetotreeratio="4" BestFitPage="False"></CR:CRYSTALREPORTVIEWER>
                                                                    </p>
                                                                    <p>
                                                                        <asp:DataGrid id="GridControl1" runat="server" width="100%" AutoGenerateColumns="False" cellpadding="2" GridLines="Vertical" BorderColor="Black" PageSize="50" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" AllowPaging="false" Font-Names="Verdana" Font-Name="Verdana" Font-Size="XX-Small" Visible="False" OnItemDataBound="FormatRow">
                                                                            <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                                            <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                                            <ItemStyle cssclass="GridItem"></ItemStyle>
                                                                            <Columns>
                                                                                <asp:BoundColumn DataField="Part_No" HeaderText="Part No"></asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="Desc" HeaderText="Part Description"></asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="Part_Spec" HeaderText="Part Specification"></asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="Lot_No" HeaderText="lot No"></asp:BoundColumn>
                                                                                <asp:TemplateColumn HeaderText="ETA Date">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="ETADate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "ETA_DATE") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="Spare Qty">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="SpareQty" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "SPARE_QTY") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="Req Qty">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="ReqQty" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Req_Qty") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="Edit Qty">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="QtyToBuy" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Qty_To_Buy") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="Diff.">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="TotalQty" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "QTY_TO_BUY") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="U/P">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="UP" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "UP") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="Amount">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="Amt" runat="server" /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="Supplier">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="VenName" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Ven_Name") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="MOQ">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="MOQ" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Min_Order_Qty") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="Std. Pack">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="SPQ" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Std_Pack_Qty") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                            </Columns>
                                                                        </asp:DataGrid>
                                                                    </p>
                                                                    <p>
                                                                        <table id="table" style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td width="25%">
                                                                                        <asp:Label id="Label1" runat="server" cssclass="OutputText">Remarks</asp:Label></td>
                                                                                    <td width="55%">
                                                                                        <asp:TextBox id="txtRem" runat="server" Width="100%" Height="56px" CssClass="OutputText"></asp:TextBox>
                                                                                    </td>
                                                                                    <td width="20%">
                                                                                        <table style="HEIGHT: 14px" cellspacing="0" cellpadding="0" width="100%">
                                                                                            <tbody>
                                                                                                <tr>
                                                                                                    <td>
                                                                                                        <asp:RadioButton id="rbApprove" runat="server" CssClass="OutputText" Text="Approve" GroupName="Status"></asp:RadioButton>
                                                                                                    </td>
                                                                                                </tr>
                                                                                                <tr>
                                                                                                    <td>
                                                                                                        <asp:RadioButton id="rbReject" runat="server" CssClass="OutputText" Text="Reject" GroupName="Status"></asp:RadioButton>
                                                                                                    </td>
                                                                                                </tr>
                                                                                            </tbody>
                                                                                        </table>
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
                                                <p>
                                                    <table style="HEIGHT: 30px" width="100%" align="center">
                                                        <tbody>
                                                            <tr>
                                                                <td width="33%">
                                                                    <asp:Button id="cmdApprove" onclick="cmdApprove_Click" runat="server" Width="154px" Text="Submit"></asp:Button>
                                                                </td>
                                                                <td width="33%">
                                                                    <p align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="156px" Text="Back"></asp:Button>
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
