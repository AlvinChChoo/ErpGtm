<%@ Page Language="VB" %>
<%@ Register TagPrefix="ERP" TagName="Header" Src="_Header.ascx" %>
<%@ Register TagPrefix="FECNDet" TagName="FECNDet" Src="_FECNDet_.ascx" %>
<%@ import Namespace="System.data" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.configuration" %>
<%@ import Namespace="System.data.sqlclient" %>
<%@ import Namespace="System.Collections" %>
<%@ import Namespace="System.Text" %>
<%@ import Namespace="System.Web.UI.WebControls" %>
<%@ import Namespace="System.Web.Mail" %>
<script runat="server">

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        If Page.IsPostBack = false Then
            cmdSubmit.attributes.add("onClick","javascript:if(confirm('You will not be able to make any changes after the submission.\nAre you sure you want to submit this FECN ?')==false) return false;")
            LoadFECNMain()
            ProcLoadGridData
        end if
    End Sub
    
    sub LoadFECNMain()
        Dim strSql as string
        strsql ="select * from FECN_M where Seq_no = '" & trim(request.params("ID")) & "';"
        Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
        Dim ReqCOm as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        myConnection.Open()
        Dim myCommand As SqlCommand = New SqlCommand(strsql, myConnection)
        Dim result As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
    
        do while result.read
            lblModelNo.text= result("MODEL_NO")
            lblModelNo.text= result("MODEL_NO") & " (" & ReqCOM.GetFieldVal("Select Model_Desc from Model_Master where Model_Code = '" & trim(lblModelNo.text) & "';","Model_Desc") & ")"
            lblPartListNo.text= result("PARTLIST_NO")
            lblBOMRev.text= result("BOM_REV")
            lblECNNo.text= result("ECN_NO")
            lblCustECNNo.text = result("CUST_ECN_NO")
            lblFECNNo.text = result("FECN_NO")
            lblFECNStatus.text = result("FECN_Status").toupper()
            lblPCBRevFrom.text = result("PCB_Rev_From").tostring
            lblPCBRevTo.text = result("PCB_Rev_To").tostring
            lblSubmitRem.text = result("Submit_Rem").tostring()
    
            if isdbnull(result("Submit_Date")) = false then
                lblSubmitBy.text= result("Submit_By").tostring
                lblSubmitDate.text= format(cdate(result("Submit_Date")),"dd/MM/yy")
            end if
    
            if isdbnull(result("App1_Date")) = false then
                lblApp1By.text= result("App1_By").tostring
                lblApp1Date.text= format(cdate(result("App1_Date")),"dd/MM/yy")
                lblApp1Rem.text = result("App1_Rem").tostring
            else
                lblapp1Rem.text = "-"
            end if
    
            if isdbnull(result("App2_Date")) = false then
                lblApp2By.text= result("App2_By").tostring
                lblApp2Date.text= format(cdate(result("App2_Date")),"dd/MM/yy")
                lblApp2Rem.text = result("App2_Rem").tostring
            else
                lblapp2Rem.text = "-"
            end if
    
            if isdbnull(result("App3_Date")) = false then
                lblApp3By.text= result("App3_By").tostring
                lblApp3Date.text= format(cdate(result("App3_Date")),"dd/MM/yy")
                lblApp3Rem.text = result("App3_Rem").tostring
            else
                lblapp3Rem.text = "-"
            end if
    
            if isdbnull(result("App4_Date")) = false then
                lblApp4By.text= result("App4_By").tostring
                lblApp4Date.text= format(cdate(result("App4_Date")),"dd/MM/yy")
                lblApp4Rem.text = result("App4_Rem").tostring
            else
                lblapp4Rem.text = "-"
            end if
    
            if isdbnull(result("App5_Date")) = false then
                lblApp5By.text= result("App5_By").tostring
                lblApp5Date.text= format(cdate(result("App5_Date")),"dd/MM/yy")
                lblApp5Rem.text = result("App5_Rem").tostring
            else
                lblapp5Rem.text = "-"
            end if
    
            if isdbnull(result("App6_Date")) = false then
                lblApp6By.text= result("App6_By").tostring
                lblApp6Date.text= format(cdate(result("App6_Date")),"dd/MM/yy")
                lblApp6Rem.text = result("App6_Rem").tostring
            else
                lblapp6Rem.text = "-"
            end if
    
            if result("TO_GTT").tostring = "Y" then chkToGtt.checked = true
            if result("TO_GTT").tostring = "N" then chkToGtt.checked = false
    
    
            if trim(result("Cust_Req")) = "Y" then chkCustReq.checked = true else chkCustReq.checked = false
            if trim(result("DESIGN_cHANGE").tostring) = "Y" then chkDesignChange.checked = true else chkDesignChange.checked = false
            if trim(result("COST_DOWN").tostring) = "Y" then chkCostDown.checked = true else chkCostDown.checked = false
            if trim(result("NO_SOURCE").tostring) = "Y" then chkNoSource.checked = true else chkNoSource.checked = false
            if trim(result("SIMPLIFY_PROCESS").tostring) = "Y" then chkSimplifyProcess.checked = true else chkSimplifyProcess.checked = false
            if trim(result("Lead_Free").tostring) = "Y" then chkLeadFree.checked = true
            if trim(result("Others1")) = "Y" then chkOthers.checked = true
    
            txtOthers.text = result("others").tostring
    
            if isdbnull(result("App2_Date")) = true then
                cmdSubmit.visible = true
                lblRem.visible = true
                txtRem.visible = true
                rbApprove.visible = true
                rbReject.visible = true
                cmdAddAtt.visible = true
            elseif isdbnull(result("App2_Date")) = false then
                cmdSubmit.visible = false
                lblRem.visible = false
                txtRem.visible = false
                rbApprove.visible = false
                rbReject.visible = false
                cmdAddAtt.visible = false
            end if
        loop
    end sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        Response.redirect("FECNApp2.aspx")
    End Sub
    
    Sub MyList_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub cmdSubmit_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim MReceiver,MSender,CC,FECNStatus as string
    
            FECNStatus = ReqCOM.GetFieldVal("select App1_Status from fecn_m where fecn_no = '" & trim(lblFECNNo.text) & "';","App1_Status")
    
            if rbApprove.checked = true then
                ReqCOM.ExecuteNonQuery("Update FECN_M set App2_By = '" & trim(request.cookies("U_ID").value) & "',App2_Date = '" & now & "',App2_Rem = '" & trim(replace(txtRem.text,"'","`")) & "',App2_Status = 'Y' where fecn_no = '" & trim(lblFECNNo.text) & "';")
            elseif rbReject.checked = true then
                ReqCOM.ExecuteNonQuery("Update FECN_M set App2_By = '" & trim(request.cookies("U_ID").value) & "',App2_Date = '" & now & "',App2_Rem = '" & trim(replace(txtRem.text,"'","`")) & "',App2_Status = 'N',FECN_Status = 'REJECTED' where fecn_no = '" & trim(lblFECNNo.text) & "';")
                MReceiver = ReqCOM.GetFieldVal("Select EMail from User_Profile where U_ID = '" & trim(lblSubmitBy.text) & "';","Email")
                MSender = ReqCOM.GetFieldVal("Select EMail from User_Profile where U_ID = '" & trim(request.cookies("U_ID").value) & "';","Email")
                'GenerateMail(MSender,MReceiver,CC,trim(lblFECNNo.text),"N")
                ShowAlert ("Selected FECN has been rejected.")
                redirectPage("FECNApp2Det.aspx?ID=" & Request.params("ID"))
            end if
    
            if trim(FECNStatus) = "Y" then
                MReceiver = ReqCOM.GetFieldVal("Select EMail from User_Profile where U_ID in (Select U_ID from authority where app_type = 'APP3' and module_name = 'FECN')","Email")
                MSender = ReqCOM.GetFieldVal("Select EMail from User_Profile where U_ID = '" & trim(request.cookies("U_ID").value) & "';","Email")
                'GenerateMail(MSender,MReceiver,CC,trim(lblFECNNo.text),"Y")
                ShowAlert ("FECN sumbitted for further approval.")
                redirectPage("FECNApp2Det.aspx?ID=" & Request.params("ID"))
            end if
        End if
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
    
    Sub GenerateMail(Sender as string, Receiver as string,CC as string,DOcNo as string,SSERStat as string)
        Dim objEmail as New MailMessage()
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim StrMsg as string
        Dim TotalQty,TotalAmt,POTotal as decimal
        Dim ObjAttachment as MailAttachment
    
        if SSERStat = "Y" then
            StrMsg = "Dear " & ReqCOM.GetFieldVal("Select U_Name from User_Profile where EMail = '" & trim(Receiver) & "';","U_Name")  & vblf & vblf & vblf
            StrMsg = StrMsg + "There is a New FECN pending for your approval." & vblf & vblf & vblf
            StrMsg = StrMsg + "FECN Reference no is " & trim(DOcNo) & ". Please use this reference for future reference." & vblf & vblf & vblf
            StrMsg = StrMsg + "Click on http://gtekapp/erp/signin.aspx?ReturnURL=FECNApp3Det.aspx?ID=" & ReqCOM.GetFieldVal("Select Seq_No from FECN_M where FECN_NO = '" & trim(DOcNo) & "';","Seq_No") & " to view the details."   & vblf & vblf
            StrMsg = StrMsg + "For assistance, please contact " & ReqCOM.GetFieldval("Select U_Name from User_Profile where EMail = '" & trim(Sender) & "';","U_Name") & vblf  & vblf & vblf
            StrMsg = StrMsg + "Regards," & vblf & vblf
            StrMsg = StrMsg + ReqCOM.GetFieldval("Select U_Name from User_Profile where EMail = '" & trim(Sender) & "';","U_Name") & vblf & vblf
            objEmail.Subject  = "FECN Approval : " & DOcNo
        Elseif SSERStat = "N" then
            StrMsg = "Dear " & ReqCOM.GetFieldVal("Select U_Name from User_Profile where EMail = '" & trim(Receiver) & "';","U_Name")  & vblf & vblf & vblf
            StrMsg = StrMsg + "There is rejected FECN." & vblf & vblf & vblf
            StrMsg = StrMsg + "FECN Reference no is " & trim(DOcNo) & ". Please use this reference for future reference." & vblf & vblf & vblf
            StrMsg = StrMsg + "For assistance, please contact " & ReqCOM.GetFieldval("Select U_Name from User_Profile where EMail = '" & trim(Sender) & "';","U_Name") & vblf  & vblf & vblf
            StrMsg = StrMsg + "Regards," & vblf & vblf
            StrMsg = StrMsg + ReqCOM.GetFieldval("Select U_Name from User_Profile where EMail = '" & trim(Sender) & "';","U_Name") & vblf & vblf
            objEmail.Subject  = "FECN Rejected : " & DOcNo
        end if
    
        objEmail.To       = trim(Receiver)
        objEmail.From     = trim(Sender)
        objEmail.CC       = trim(CC)
        objEmail.Body     = StrMsg
        objEmail.Priority = MailPriority.High
        SmtpMail.SmtpServer  = "192.168.42.111"
        SmtpMail.Send(objEmail)
    End sub
    
    Sub ShowSelection(s as object,e as DataListCommandEventArgs)
        Dim MainPartB4, MainPart as string
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
    
        MainPartB4 = ReqCOM.GetFieldVal("Select Main_Part_B4 from FECN_D where Seq_No = " & e.commandArgument & ";","Main_Part_B4")
        if mainPartB4 = "<NULL>" or mainPartB4 = "-"  then mainPartB4 = "-"
    
        MainPart = ReqCOM.GetFieldVal("Select Main_Part from FECN_D where Seq_No = " & e.commandArgument & ";","Main_Part")
        if MainPart = "<NULL>" or MainPart = "-"  then MainPart = "-"
        ShowReport("PopupFECNWUL.aspx?MainPartB4=" & trim(MainPartB4) & "&MainPart=" & trim(MainPart))
    end sub
    
    Sub ShowReport(ReturnURL as string)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=550,height=300');")
        Script.Append("</script" & ">")
        RegisterStartupScript("ShowExistingSupplier", Script.ToString())
    End sub
    
    Sub dtgUPASAttachment_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub lnkAttachment_Click(sender As Object, e As EventArgs)
        ShowPopup("popupFECNAtt.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Sub ShowPopup(ReturnURL as string)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=0,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=500');")
        Script.Append("</script" & ">")
        RegisterStartupScript("ShowAttachmentPopup", Script.ToString())
    End sub
    
    Sub ProcLoadGridData()
        Dim StrSql as string = "Select * from fecn_ATTACHMENT where fecn_NO = '" & trim(lblfecnNo.text) & "';"
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"fecn_ATTACHMENT")
        dtgUPASAttachment.DataSource=resExePagedDataSet.Tables("fecn_ATTACHMENT").DefaultView
        dtgUPASAttachment.DataBind()
    end sub
    
    Sub cmdAddAtt_Click(sender As Object, e As EventArgs)
        Response.redirect ("FECNAttachment.aspx?ID=" & request.params("ID") & "&ReturnURL=FECNApp2Det.aspx?ID=" & request.params("ID"))
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body onkeypress="KeyPress()" bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form runat="server">
        <p>
            <table style="HEIGHT: 3px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <ERP:HEADER id="UserControl2" runat="server"></ERP:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label1" runat="server" cssclass="FormDesc" width="100%">FECN DETAILS</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 11px" cellspacing="0" cellpadding="0" width="98%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <table style="HEIGHT: 11px" cellspacing="0" cellpadding="0" width="80%" align="center">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: white; BORDER-BOTTOM-COLOR: white; BORDER-TOP-COLOR: white; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: white" width="100%" align="center" border="1">
                                                                        <tbody>
                                                                            <tr>
                                                                                <td colspan="2">
                                                                                    <asp:CheckBox id="chkToGTT" runat="server" Text="E-Mail to GTT Document Control (Chien@gtek.com.tw,sandy@gtek.com.tw,doc@gtek.com.tw)" CssClass="OutputText" Enabled="False"></asp:CheckBox>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td width="25%" bgcolor="silver">
                                                                                    <asp:Label id="Label2" runat="server" cssclass="LabelNormal" width="126px">FECN No</asp:Label></td>
                                                                                <td>
                                                                                    <asp:Label id="lblFECNNo" runat="server" cssclass="OutputText" width="" font-size="Larger" font-bold="True"></asp:Label></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver">
                                                                                    <asp:Label id="Label6" runat="server" cssclass="LabelNormal" width="">Model No/Description</asp:Label></td>
                                                                                <td>
                                                                                    <p align="left">
                                                                                        <asp:Label id="lblModelNo" runat="server" cssclass="OutputText" width="423px" font-size="Larger" font-bold="True"></asp:Label>
                                                                                    </p>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver">
                                                                                    <asp:Label id="Label12" runat="server" cssclass="LabelNormal" width="">PCBA Rev. From</asp:Label></td>
                                                                                <td>
                                                                                    <asp:Label id="lblPCBRevFrom" runat="server" cssclass="OutputText" width="423px"></asp:Label></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver">
                                                                                    <asp:Label id="Label13" runat="server" cssclass="LabelNormal" width="">PCBA Rev. To</asp:Label></td>
                                                                                <td>
                                                                                    <asp:Label id="lblPCBRevTo" runat="server" cssclass="OutputText" width="423px"></asp:Label></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver">
                                                                                    <asp:Label id="Label9" runat="server" cssclass="LabelNormal" width="116px">ECN No</asp:Label></td>
                                                                                <td>
                                                                                    <div align="left"><asp:Label id="lblECNNo" runat="server" cssclass="OutputText" width="116px"></asp:Label>
                                                                                    </div>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver">
                                                                                    <asp:Label id="Label10" runat="server" cssclass="LabelNormal" width="">Cust. ECN No</asp:Label></td>
                                                                                <td>
                                                                                    <div align="left"><asp:Label id="lblCustECNNo" runat="server" cssclass="OutputText" width="116px"></asp:Label>
                                                                                    </div>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver">
                                                                                    <asp:Label id="Label7" runat="server" cssclass="LabelNormal" width="126px">Partlist
                                                                                    No</asp:Label></td>
                                                                                <td>
                                                                                    <div align="left"><asp:Label id="lblPartListNo" runat="server" cssclass="OutputText" width="116px"></asp:Label>
                                                                                    </div>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver">
                                                                                    <asp:Label id="Label4" runat="server" cssclass="LabelNormal" width="124px">Reason
                                                                                    of change</asp:Label></td>
                                                                                <td>
                                                                                    <asp:CheckBox id="chkCustReq" runat="server" Text="Customer Request" CssClass="OutputText" Enabled="False"></asp:CheckBox>
                                                                                    <asp:CheckBox id="chkDesignChange" runat="server" Text="Design Change" CssClass="OutputText" Enabled="False"></asp:CheckBox>
                                                                                    <asp:CheckBox id="chkCostDown" runat="server" Text="Cost Down" CssClass="OutputText" Enabled="False"></asp:CheckBox>
                                                                                    <asp:CheckBox id="chkNoSource" runat="server" Text="No Source" CssClass="OutputText" Enabled="False"></asp:CheckBox>
                                                                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
                                                                                    <asp:CheckBox id="chkLeadFree" runat="server" Text="Lead Free" CssClass="OutputText" Enabled="False"></asp:CheckBox>
                                                                                    <asp:CheckBox id="chkSimplifyProcess" runat="server" Text="Simplify Process" CssClass="OutputText" Enabled="False"></asp:CheckBox>
                                                                                    <asp:CheckBox id="chkOthers" runat="server" Text="Others, pls specify" CssClass="OutputText" Enabled="False"></asp:CheckBox>
                                                                                    <asp:TextBox id="txtOthers" runat="server" CssClass="OutputText" Enabled="False" Width="152px"></asp:TextBox>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver">
                                                                                    <asp:Label id="Label8" runat="server" cssclass="LabelNormal" width="124px">BOM Rev. </asp:Label></td>
                                                                                <td>
                                                                                    <div align="left"><asp:Label id="lblBOMRev" runat="server" cssclass="OutputText" width="299px"></asp:Label>
                                                                                    </div>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver">
                                                                                    <asp:Label id="Label5" runat="server" cssclass="LabelNormal" width="124px">FECN Status</asp:Label></td>
                                                                                <td>
                                                                                    <asp:Label id="lblFECNStatus" runat="server" cssclass="OutputText" width="260px"></asp:Label></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver" rowspan="2">
                                                                                    <asp:Label id="Label3" runat="server" cssclass="LabelNormal" width="124px">Submit
                                                                                    By/Date/Remarks</asp:Label></td>
                                                                                <td>
                                                                                    <asp:Label id="lblSubmitBy" runat="server" cssclass="OutputText"></asp:Label>&nbsp;
                                                                                    -&nbsp; <asp:Label id="lblSubmitDate" runat="server" cssclass="OutputText"></asp:Label></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td>
                                                                                    <asp:Label id="lblSubmitRem" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver" rowspan="2">
                                                                                    <asp:Label id="Label16" runat="server" cssclass="LabelNormal" width="126px">Verified(Electrical)</asp:Label></td>
                                                                                <td>
                                                                                    <asp:Label id="lblApp1By" runat="server" cssclass="OutputText"></asp:Label>&nbsp;
                                                                                    -&nbsp; <asp:Label id="lblApp1Date" runat="server" cssclass="OutputText"></asp:Label></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td>
                                                                                    <asp:Label id="lblApp1Rem" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver" rowspan="2">
                                                                                    <asp:Label id="Label17" runat="server" cssclass="LabelNormal" width="126px">Verified(Mechanical)</asp:Label></td>
                                                                                <td>
                                                                                    <asp:Label id="lblApp2By" runat="server" cssclass="OutputText"></asp:Label>&nbsp;
                                                                                    -&nbsp; <asp:Label id="lblApp2Date" runat="server" cssclass="OutputText"></asp:Label></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td>
                                                                                    <asp:Label id="lblApp2Rem" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver" rowspan="2">
                                                                                    <asp:Label id="Label18" runat="server" cssclass="LabelNormal" width="126px">R&D HOD
                                                                                    By</asp:Label></td>
                                                                                <td>
                                                                                    <asp:Label id="lblApp3By" runat="server" cssclass="OutputText"></asp:Label>&nbsp;
                                                                                    -&nbsp; <asp:Label id="lblApp3Date" runat="server" cssclass="OutputText"></asp:Label></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td>
                                                                                    <asp:Label id="lblApp3Rem" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver" rowspan="2">
                                                                                    <asp:Label id="Label19" runat="server" cssclass="LabelNormal" width="126px">PCMC</asp:Label></td>
                                                                                <td>
                                                                                    <asp:Label id="lblApp4By" runat="server" cssclass="OutputText"></asp:Label>&nbsp;
                                                                                    -&nbsp; <asp:Label id="lblApp4Date" runat="server" cssclass="OutputText"></asp:Label></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td>
                                                                                    <asp:Label id="lblApp4Rem" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver" rowspan="2">
                                                                                    <asp:Label id="Label20" runat="server" cssclass="LabelNormal" width="126px">Costing</asp:Label></td>
                                                                                <td>
                                                                                    <asp:Label id="lblApp5By" runat="server" cssclass="OutputText"></asp:Label>&nbsp;
                                                                                    -&nbsp; <asp:Label id="lblApp5Date" runat="server" cssclass="OutputText"></asp:Label></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td>
                                                                                    <asp:Label id="lblApp5Rem" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver" rowspan="2">
                                                                                    <asp:Label id="Label21" runat="server" cssclass="LabelNormal" width="126px">M.D.</asp:Label></td>
                                                                                <td>
                                                                                    <asp:Label id="lblApp6By" runat="server" cssclass="OutputText"></asp:Label>&nbsp;
                                                                                    -&nbsp; <asp:Label id="lblApp6Date" runat="server" cssclass="OutputText"></asp:Label></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td>
                                                                                    <asp:Label id="lblApp6Rem" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                                            </tr>
                                                                        </tbody>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 12px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td width="30%" bgcolor="#8080ff">
                                                                </td>
                                                                <td width="40%">
                                                                    <div align="center"><asp:Label id="Label11" runat="server" cssclass="SectionHeader" width="100%">FECN
                                                                        ATTACHMENT</asp:Label>
                                                                    </div>
                                                                </td>
                                                                <td bgcolor="#8080ff">
                                                                    <div align="right">
                                                                        <asp:Button id="cmdAddAtt" onclick="cmdAddAtt_Click" runat="server" Text="Add/Edit Attachment" CssClass="OutputText" CausesValidation="False"></asp:Button>
                                                                        &nbsp;&nbsp; 
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="3">
                                                                    <table class="sideboxnotop" style="HEIGHT: 11px" width="100%" border="1">
                                                                        <tbody>
                                                                            <tr>
                                                                                <td>
                                                                                    <p>
                                                                                        <asp:DataGrid id="dtgUPASAttachment" runat="server" width="100%" PageSize="50" AlternatingItemStyle-CssClass="CartListItemAlt" ItemStyle-CssClass="CartListItem" HeaderStyle-CssClass="CartListHead" AutoGenerateColumns="False" cellpadding="4" BorderColor="Gray" OnSelectedIndexChanged="dtgUPASAttachment_SelectedIndexChanged">
                                                                                            <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                                                            <ItemStyle cssclass="GridItem"></ItemStyle>
                                                                                            <HeaderStyle bordercolor="White" cssclass="GridHeaderSmall"></HeaderStyle>
                                                                                            <Columns>
                                                                                                <asp:TemplateColumn Visible="False">
                                                                                                    <ItemTemplate>
                                                                                                        <asp:Label id="lblSeqNo" visible="false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "SEQ_NO") %>' /> 
                                                                                                    </ItemTemplate>
                                                                                                </asp:TemplateColumn>
                                                                                                <asp:BoundColumn DataField="File_Desc" HeaderText="Description"></asp:BoundColumn>
                                                                                                <asp:BoundColumn DataField="File_Name" HeaderText="File Name"></asp:BoundColumn>
                                                                                                <asp:BoundColumn DataField="File_Size" HeaderText="File Size (Byte)"></asp:BoundColumn>
                                                                                                <asp:HyperLinkColumn Text="Download" DataNavigateUrlField="Seq_No" DataNavigateUrlFormatString="DownloadFECNAttachment.aspx?ID={0}"></asp:HyperLinkColumn>
                                                                                            </Columns>
                                                                                        </asp:DataGrid>
                                                                                    </p>
                                                                                </td>
                                                                            </tr>
                                                                        </tbody>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <FECNDet:FECNDet id="FECNDet" runat="server"></FECNDet:FECNDet>
                                                </p>
                                                <p align="center">
                                                    <table id="table" style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td width="25%">
                                                                    <asp:Label id="lblRem" runat="server" cssclass="OutputText">Remarks</asp:Label></td>
                                                                <td width="55%">
                                                                    <asp:TextBox id="txtRem" runat="server" CssClass="OutputText" Width="100%" Height="56px"></asp:TextBox>
                                                                </td>
                                                                <td width="20%">
                                                                    <table style="HEIGHT: 14px" cellspacing="0" cellpadding="0" width="100%">
                                                                        <tbody>
                                                                            <tr>
                                                                                <td>
                                                                                    <asp:RadioButton id="rbApprove" runat="server" Text="Approve" CssClass="OutputText" GroupName="Status"></asp:RadioButton>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td>
                                                                                    <asp:RadioButton id="rbReject" runat="server" Text="Reject" CssClass="OutputText" GroupName="Status"></asp:RadioButton>
                                                                                </td>
                                                                            </tr>
                                                                        </tbody>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p align="center">
                                                    <table style="HEIGHT: 11px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <div align="left">
                                                                        <asp:Button id="cmdSubmit" onclick="cmdSubmit_Click" runat="server" Text="Submit" Width="123px"></asp:Button>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Text="Back" Width="133px"></asp:Button>
                                                                    </div>
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
    <!-- Insert content here -->
</body>
</html>
