<%@ Page Language="VB" %>
<%@ Register TagPrefix="ERP" TagName="Header" Src="_Header.ascx" %>
<%@ Register TagPrefix="FECNAttachment" TagName="FECNAttachment" Src="_FECNAttachment_.ascx" %>
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
        cmdSubmit.attributes.add("onClick","javascript:if(confirm('You will not be able to make any changes after the submission.\nAre you sure you want to submit this FECN ?')==false) return false;")
        If Page.IsPostBack = false Then
            LoadFECNMain()
            ProcLoadAtt()
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
            lblModelNo.text= result("MODEL_NO") & " (" & trim(ReqCOM.GetFieldVal("Select Model_Desc from Model_Master where Model_Code = '" & trim(lblModelNo.text) & "';","Model_Desc") & ")")
            lblPartListNo.text= result("PARTLIST_NO")
            lblBOMRev.text= result("BOM_REV")
            lblECNNo.text= result("ECN_NO")
            lblCustECNNo.text = result("CUST_ECN_NO")
            lblFECNNo.text = result("FECN_NO")
            lblFECNStatus.text = result("FECN_Status").toupper()
            lblSubmitRem.text = result("Submit_Rem").tostring
            lblPCBRevFrom.text = result("PCB_Rev_From").tostring
            lblPCBRevTo.text = result("PCB_Rev_To").tostring
    
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
    
    
            if trim(result("Cust_Req").tostring) = "Y" then chkCustReq.checked = true
            if trim(result("DESIGN_cHANGE").tostring) = "Y" then chkDesignChange.checked = true
            if trim(result("COST_DOWN").tostring) = "Y" then chkCostDown.checked = true
            if trim(result("NO_SOURCE").tostring) = "Y" then chkNoSource.checked = true
            if trim(result("SIMPLIFY_PROCESS").tostring) = "Y" then chkSimplifyProcess.checked = true
            if trim(result("Others1").tostring) = "Y" then chkOthers.checked = true
            if trim(result("Lead_Free").tostring) = "Y" then chkLeadFree.checked = true
            txtOthers.text = result("others").tostring
    
    
            if isdbnull(result("App3_Date")) = true then
                cmdSubmit.visible = true
                lblRem.visible = true
                txtRem.visible = true
                rbApprove.visible = true
                rbReject.visible = true
                lnkAttachment.enabled = true
            elseif isdbnull(result("App3_Date")) = false then
                cmdSubmit.visible = false
                lblRem.visible = false
                txtRem.visible = false
                rbApprove.visible = false
                rbReject.visible = false
                lnkAttachment.enabled = false
            end if
        loop
    end sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        Response.redirect("FECNApp3.aspx")
    End Sub
    
    Sub cmdSubmit_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim MReceiverName,MReceiver,MSender,CC as string
    
            if rbApprove.checked = true then
                ReqCOM.ExecuteNonQuery("Update FECN_M set App3_By = '" & trim(request.cookies("U_ID").value) & "',App3_Date = '" & now & "',App3_Rem = '" & trim(replace(txtRem.text,"'","`")) & "',App3_Status = 'Y' where fecn_no = '" & trim(lblFECNNo.text) & "';")
    
                MSender = trim(request.cookies("U_ID").value)
                MReceiver = "Cindy,Tancy"
    
                GeneratePendingEmailList(MSender, MReceiver,CC ,trim(lblFECNNo.text),"Y")
    
                ShowAlert ("FECN sumbitted for further approval.")
                redirectPage("FECNApp3Det.aspx?ID=" & Request.params("ID"))
            elseif rbReject.checked = true then
                ReqCOM.ExecuteNonQuery("Update FECN_M set App3_By = '" & trim(request.cookies("U_ID").value) & "',App3_Date = '" & now & "',App3_Rem = '" & trim(replace(txtRem.text,"'","`")) & "',App3_Status = 'N',FECN_Status = 'REJECTED' where fecn_no = '" & trim(lblFECNNo.text) & "';")
                MReceiver = trim(lblSubmitBy.text)
                MSender = trim(request.cookies("U_ID").value)
    
                if trim(lblApp1by.text) <> "N/A" then
                    CC = ReqCOM.GetFieldVal("Select EMail from User_Profile where U_ID = '" & trim(lblApp1By.text) & "';","Email")
                    if trim(lblApp2by.text) <> "N/A" then
                    CC = CC & ";" & ReqCOM.GetFieldVal("Select EMail from User_Profile where U_ID = '" & trim(lblApp2By.text) & "';","Email")
                    end if
                elseif trim(lblApp1by.text) = "N/A" then
                    CC = ReqCOM.GetFieldVal("Select EMail from User_Profile where U_ID = '" & trim(lblApp2By.text) & "';","Email")
                End if
    
                GeneratePendingEmailList(MSender, MReceiver,CC ,trim(lblFECNNo.text),"Y")
    
                ShowAlert ("Selected FECN has been rejected.")
                redirectPage("FECNApp3Det.aspx?ID=" & Request.params("ID"))
            end if
        end if
    End Sub
    
        Sub GeneratePendingEmailList(Sender as string, Receiver as string,CC as string,DOcNo as string,SSERStat as string)
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim FromEmail,ToEmail,EmailSubject,EmailContent as string
    
            if SSERStat = "Y" then
                EmailContent = "Dear " & trim(Receiver) & vblf & vblf & vblf
                EmailContent = EmailContent + "There is a New FECN pending for your approval." & vblf & vblf & vblf
                EmailContent = EmailContent + "FECN Reference no is " & trim(DOcNo) & ". Please use this reference for future reference." & vblf & vblf & vblf
                EmailContent = EmailContent + "Click on http://gtekapp/erp/signin.aspx?ReturnURL=FECNApp5Det.aspx?ID=" & ReqCOM.GetFieldVal("Select Seq_No from FECN_M where FECN_NO = '" & trim(DOcNo) & "';","Seq_No") & " to view the details."   & vblf & vblf
                EmailContent = EmailContent + "For assistance, please contact " & ReqCOM.GetFieldval("Select U_Name from User_Profile where EMail = '" & trim(Sender) & "';","U_Name") & vblf  & vblf & vblf
                EmailContent = EmailContent + "Regards," & vblf & vblf
                EmailContent = EmailContent + ReqCOM.GetFieldval("Select U_Name from User_Profile where EMail = '" & trim(Sender) & "';","U_Name") & vblf & vblf
    
                EmailSubject = "FECN Approval : " & trim(DOcNo) & " (Model No : " & trim(lblModelNo.text) & ")"
    
                FromEmail = ReqCOM.GetFieldVal("Select Email from User_Profile where U_ID = '" & trim(Sender) & "';","Email")
                ToEmail = "AngSN@g-tek.com.my;tancy@g-tek.com.my"
    
                ReqCOM.ExecuteNonQuery("Insert into pending_email(FROM_EMAIL,FROM_NAME,TO_NAME,TO_EMAIL,EMAIL_SUBJECT,EMAIL_CONTENT,MODULE_NAME,ADD_ATT,REF_NO,CC) select '" & trim(FromEmail) & "','" & trim(Sender) & "','" & trim(Receiver) & "','" & trim(ToEmail) & "','" & trim(EmailSubject) & "','" & trim(EmailContent) & "','FECN','N','" & trim(DOcNo) & "','" & trim(CC) & "'")
            Elseif SSERStat = "N" then
                EmailContent = "Dear " & trim(Receiver) & vblf & vblf & vblf
                EmailContent = EmailContent + "There is rejected FECN." & vblf & vblf & vblf
                EmailContent = EmailContent + "FECN Reference no is " & trim(DOcNo) & ". Please use this reference for future reference." & vblf & vblf & vblf
                EmailContent = EmailContent + "For assistance, please contact " & ReqCOM.GetFieldval("Select U_Name from User_Profile where EMail = '" & trim(Sender) & "';","U_Name") & vblf  & vblf & vblf
                EmailContent = EmailContent + "Regards," & vblf & vblf
                EmailContent = EmailContent + ReqCOM.GetFieldval("Select U_Name from User_Profile where EMail = '" & trim(Sender) & "';","U_Name") & vblf & vblf
    
                EmailSubject  = "FECN Rejected : " & DOcNo
    
                FromEmail = ReqCOM.GetFieldVal("Select Email from User_Profile where U_ID = '" & trim(Sender) & "';","Email")
                ToEmail = ReqCOM.GetFieldVal("Select Email from User_Profile where U_ID = '" & trim(Receiver) & "';","Email")
    
                ReqCOM.ExecuteNonQuery("Insert into pending_email(FROM_EMAIL,FROM_NAME,TO_NAME,TO_EMAIL,EMAIL_SUBJECT,EMAIL_CONTENT,MODULE_NAME,ADD_ATT,REF_NO,CC) select '" & trim(FromEmail) & "','" & trim(Sender) & "','" & trim(Receiver) & "','" & trim(ToEmail) & "','" & trim(EmailSubject) & "','" & trim(EmailContent) & "','FECN','N','" & trim(DOcNo) & "','" & trim(CC) & "'")
            end if
        End sub
    
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
    
    
    
    Sub ShowPopup(ReturnURL as string)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=0,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=500');")
        Script.Append("</script" & ">")
        RegisterStartupScript("ShowAttachmentPopup", Script.ToString())
    End sub
    
    Sub dtgUPASAttachment_SelectedIndexChanged(sender As Object, e As EventArgs)
    
    End Sub
    
    Sub ProcLoadAtt()
        Dim StrSql as string = "Select * from fecn_ATTACHMENT where fecn_NO = '" & trim(lblfecnNo.text) & "';"
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"fecn_ATTACHMENT")
        dtgUPASAttachment.DataSource=resExePagedDataSet.Tables("fecn_ATTACHMENT").DefaultView
        dtgUPASAttachment.DataBind()
    end sub
    
    Sub lnkAttachment_Click(sender As Object, e As EventArgs)
        ShowPopup("popupFECNAtt.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Sub cmdRefresh_Click(sender As Object, e As EventArgs)
        ProcLoadAtt
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
                                                                                    <asp:CheckBox id="chkToGTT" runat="server" Enabled="False" CssClass="OutputText" Text="E-Mail to GTT Document Control (Chien@gtek.com.tw,sandy@gtek.com.tw,doc@gtek.com.tw)"></asp:CheckBox>
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
                                                                                    <asp:Label id="Label12" runat="server" cssclass="LabelNormal" width="116px">PCBA Rev.
                                                                                    From</asp:Label></td>
                                                                                <td>
                                                                                    <asp:Label id="lblPCBRevFrom" runat="server" cssclass="OutputText" width="423px"></asp:Label></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver">
                                                                                    <asp:Label id="Label13" runat="server" cssclass="LabelNormal" width="116px">PCBA Rev.
                                                                                    To</asp:Label></td>
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
                                                                                    <asp:Label id="Label8" runat="server" cssclass="LabelNormal" width="124px">BOM Rev. </asp:Label></td>
                                                                                <td>
                                                                                    <div align="left"><asp:Label id="lblBOMRev" runat="server" cssclass="OutputText" width="299px"></asp:Label>
                                                                                    </div>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver">
                                                                                    <asp:Label id="Label4" runat="server" cssclass="LabelNormal" width="124px">Reason
                                                                                    of change</asp:Label></td>
                                                                                <td>
                                                                                    <asp:CheckBox id="chkCustReq" runat="server" Enabled="False" CssClass="OutputText" Text="Customer Request"></asp:CheckBox>
                                                                                    <asp:CheckBox id="chkDesignChange" runat="server" Enabled="False" CssClass="OutputText" Text="Design Change"></asp:CheckBox>
                                                                                    <asp:CheckBox id="chkCostDown" runat="server" Enabled="False" CssClass="OutputText" Text="Cost Down"></asp:CheckBox>
                                                                                    <asp:CheckBox id="chkNoSource" runat="server" Enabled="False" CssClass="OutputText" Text="No Source"></asp:CheckBox>
                                                                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
                                                                                    <asp:CheckBox id="chkLeadFree" runat="server" Enabled="False" CssClass="OutputText" Text="Lead Free"></asp:CheckBox>
                                                                                    <asp:CheckBox id="chkSimplifyProcess" runat="server" Enabled="False" CssClass="OutputText" Text="Simplify Process"></asp:CheckBox>
                                                                                    <asp:CheckBox id="chkOthers" runat="server" Enabled="False" CssClass="OutputText" Text="Others, pls specify"></asp:CheckBox>
                                                                                    <asp:TextBox id="txtOthers" runat="server" Enabled="False" CssClass="OutputText" Width="152px"></asp:TextBox>
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
                                                <p align="center">
                                                    <table style="HEIGHT: 22px" cellspacing="0" cellpadding="0" width="98%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <div align="center"><asp:Label id="Label11" runat="server" cssclass="SectionHeader" width="100%">FECN
                                                                        ATTACHMENT</asp:Label>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <table class="sideboxnotop" style="HEIGHT: 9px" width="100%">
                                                                        <tbody>
                                                                            <tr>
                                                                                <td>
                                                                                    <p>
                                                                                        <table style="HEIGHT: 15px" cellspacing="0" cellpadding="0" width="100%">
                                                                                            <tbody>
                                                                                                <tr>
                                                                                                    <td width="70%">
                                                                                                        <p>
                                                                                                            <asp:LinkButton id="lnkAttachment" onclick="lnkAttachment_Click" runat="server">Add / Edit FECN Attachment</asp:LinkButton>
                                                                                                        </p>
                                                                                                    </td>
                                                                                                    <td width="30%">
                                                                                                        <div align="right">
                                                                                                            <asp:Button id="cmdRefresh" onclick="cmdRefresh_Click" runat="server" Text="Refresh Attachment List" Width="177px"></asp:Button>
                                                                                                        </div>
                                                                                                    </td>
                                                                                                </tr>
                                                                                            </tbody>
                                                                                        </table>
                                                                                    </p>
                                                                                    <p>
                                                                                        <asp:DataGrid id="dtgUPASAttachment" runat="server" width="100%" OnSelectedIndexChanged="dtgUPASAttachment_SelectedIndexChanged" HeaderStyle-CssClass="CartListHead" ItemStyle-CssClass="CartListItem" AlternatingItemStyle-CssClass="CartListItemAlt" AutoGenerateColumns="False" cellpadding="4" GridLines="Vertical" BorderColor="Black" PageSize="50">
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
