<%@ Page Language="VB" Debug="true" %>
<%@ Register TagPrefix="IBuySpy" TagName="Header" Src="_Header.ascx" %>
<%@ Register TagPrefix="BuyerSRDet" TagName="BuyerSRDet" Src="_BuyerSRDet_.ascx" %>
<%@ Register TagPrefix="BuyerSRAttachment" TagName="BuyerSRAttachment" Src="_BuyerSRAttachment_.ascx" %>
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
        if page.isPostBack = false then
            loadGridData
        End if
    End Sub
    
    Sub loadGridData()
        Dim strSql as string = "SELECT * FROM Buyer_SR_M where SEQ_NO = " & request.params("ID") & ";"
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
    
            if isdbnull(ResExeDataReader("App1_By")) = false then
                label1.visible = false
                txtrem.visible =false
                rbapprove.visible =false
                rbReject.visible = false
                cmdApprove.enabled = false
            else
                label1.visible = true
                txtrem.visible =true
                rbapprove.visible =true
                rbReject.visible = true
                cmdApprove.enabled = true
            end if
        loop
    end sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        Response.redirect("BuyerSRApp1.aspx")
    End Sub
    
    Sub cmdApprove_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim StrSql as string
        Dim MReceiver,MSender,cc as string
    
        if rbApprove.checked = true then
            ReqCOM.ExecuteNonQuery("Update Buyer_SR_M set App1_By = '" & trim(request.cookies("U_ID").value) & "',App1_Date = '" & now & "',App1_Rem = '" & trim(txtRem.text) & "',App1_Status='Y' where SR_No = '" & trim(lblSRNo.text) & "';")
            MReceiver = ReqCOM.GetFieldVal("Select EMail from User_Profile where U_ID in (Select U_ID from authority where app_type = 'APP2' and module_name = 'BUYERSR')","Email")
            MSender = ReqCOM.GetFieldVal("Select EMail from User_Profile where U_ID = '" & trim(request.cookies("U_ID").value) & "';","Email")
            GenerateMail(MSender,MReceiver,CC,trim(lblSRNo.text),"Y")
            ShowAlert ("SR sumbitted for further approval.")
        elseif rbReject.checked = true then
            ReqCOM.ExecuteNonQuery("Update Buyer_SR_M set App1_By = '" & trim(request.cookies("U_ID").value) & "',App1_Date = '" & now & "',App1_Rem = '" & trim(txtRem.text) & "',App1_Status='N',sr_status = 'REJECTED' where SR_No = '" & trim(lblSRNo.text) & "';")
        end if
        redirectPage("BuyerSRApp1Det.aspx?ID=" & Request.params("ID"))
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
            StrMsg = StrMsg + "There is a New Special Request (from Buyer) pending for your approval." & vblf & vblf & vblf
            StrMsg = StrMsg + "The special request reference no is " & trim(DOcNo) & ". Please use this reference for future reference." & vblf & vblf & vblf
            StrMsg = StrMsg + "Click on http://gtekapp/erp/signin.aspx?ReturnURL=BuyerSRApp2Det.aspx?ID=" & ReqCOM.GetFieldVal("Select Seq_No from Buyer_SR_M where SR_NO = '" & trim(DOcNo) & "';","Seq_No") & " to view the details."   & vblf & vblf
            StrMsg = StrMsg + "For assistance, please contact " & ReqCOM.GetFieldval("Select U_Name from User_Profile where EMail = '" & trim(Sender) & "';","U_Name") & vblf  & vblf & vblf
            StrMsg = StrMsg + "Regards," & vblf & vblf
            StrMsg = StrMsg + ReqCOM.GetFieldval("Select U_Name from User_Profile where EMail = '" & trim(Sender) & "';","U_Name") & vblf & vblf
            objEmail.Subject  = "Special Request Pending Approval : " & DOcNo
        Elseif SRStatus = "N" then
        end if
        objEmail.To       = trim(Receiver)
        objEmail.From     = trim(Sender)
        objEmail.CC       = trim(CC)
        objEmail.Body     = StrMsg
        objEmail.Priority = MailPriority.High
        SmtpMail.SmtpServer  = "192.168.42.111"
        SmtpMail.Send(objEmail)
    End sub
    
    Sub cmdAmountSummary_Click(sender As Object, e As EventArgs)
        ShowReport("PopupSRAmtSummary.aspx?SRNo=" & trim(lblSRNo.text))
        redirectPage("BuyerSRApp1Det.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Sub ShowReport(ReturnURL as string)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=500,height=250');")
        Script.Append("</script" & ">")
        RegisterStartupScript("ShowExistingSupplier", Script.ToString())
    End sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form runat="server">
        <p>
            <table style="HEIGHT: 5px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <IBUYSPY:HEADER id="UserControl2" runat="server"></IBUYSPY:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label2" runat="server" cssclass="FormDesc" width="100%">SPECIAL REQUEST
                                DETAILS</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 12px" cellspacing="0" cellpadding="0" width="90%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 70%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" align="center" border="1">
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
                                                                <asp:Label id="lblRemarks" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver" rowspan="2">
                                                                <asp:Label id="Label6" runat="server" cssclass="LabelNormal">App1 By/Date</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblApp1By" runat="server" cssclass="OutputText" width=""></asp:Label>&nbsp;- <asp:Label id="lblApp1Date" runat="server" cssclass="OutputText" width=""></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="lblApp1Rem" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver" rowspan="2">
                                                                <asp:Label id="Label7" runat="server" cssclass="LabelNormal">App2 By/Date</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblApp2By" runat="server" cssclass="OutputText" width=""></asp:Label>&nbsp;- <asp:Label id="lblApp2Date" runat="server" cssclass="OutputText" width=""></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="lblApp2Rem" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver" rowspan="2">
                                                                <asp:Label id="Label8" runat="server" cssclass="LabelNormal">App3 By/Date</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblApp3By" runat="server" cssclass="OutputText" width=""></asp:Label>&nbsp;- <asp:Label id="lblApp3Date" runat="server" cssclass="OutputText" width=""></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="lblApp3Rem" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                <p>
                                                    <table style="HEIGHT: 77px" cellspacing="0" cellpadding="0" width="100%" align="center">
                                                        <tbody>
                                                            <tr>
                                                                <td valign="top">
                                                                    <p>
                                                                        <BuyerSRAttachment:BuyerSRAttachment id="BuyerSRAttachment" runat="server"></BuyerSRAttachment:BuyerSRAttachment>
                                                                    </p>
                                                                    <p>
                                                                        <BuyerSRDet:BuyerSRDet id="BuyerSRDet" runat="server"></BuyerSRDet:BuyerSRDet>
                                                                    </p>
                                                                    <p>
                                                                        <table id="table" style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td width="25%">
                                                                                        <asp:Label id="Label1" runat="server" cssclass="OutputText">Remarks</asp:Label></td>
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
                                                                    <div align="center">
                                                                        <asp:Button id="cmdAmountSummary" onclick="cmdAmountSummary_Click" runat="server" Width="171px" Text="Total Amount Summary"></asp:Button>
                                                                    </div>
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
