<%@ Page Language="VB" %>
<%@ Register TagPrefix="IBuySpy" TagName="Header" Src="_Header.ascx" %>
<%@ import Namespace="System.data" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.configuration" %>
<%@ import Namespace="System.data.sqlclient" %>
<%@ import Namespace="System.Collections" %>
<%@ import Namespace="System.Web.Mail" %>
<%@ import Namespace="System.Text" %>
<%@ import Namespace="System.Web.UI.WebControls" %>
<script runat="server">

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        cmdYes.attributes.add("onClick","javascript:if(confirm('You will not be able to undo the changes after approval.\nAre you sure you want to Approve this Unit Price Approval Sheet ?')==false) return false;")
        IF page.ispostback=false then
            Dim ReqCOm as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
            Dim RsUPASM as SqlDataReader = ReqCOm.ExeDataReader("Select * from UPAS_M where Seq_No = '" & trim(request.params("ID")) & "';")
    
            Do while RsUPASM.read
                lblUPASNo.text = RsUPASM("UPAS_NO").tostring
                lblAppBy.text = trim(Request.cookies("U_ID").value)
    
            loop
            RsUPASM.Close
    
        end if
    End Sub
    
    
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub cmdNo_Click(sender As Object, e As EventArgs)
        response.redirect("UPAAcc1AppDet.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Sub cmdYes_Click(sender As Object, e As EventArgs)
        Dim ReqCOM AS erp_gtm.erp_gtm = NEW erp_gtm.erp_gtm
        Dim ReturnURL as string
        ReqCOM.executenonquery("Update UPAS_M set ACC1_STATUS = 'APPROVED', ACC1_BY='" & TRIM(request.cookies("U_ID").value) & "',ACC1_date = '" & now & "',ACC1_REM = '" & TRIM(txtReason.text) & "' where seq_no = " & cint(request.params("ID")) & ";")
        'GenerateMail()
        ReturnURL = "UPAAcc1AppDet.aspx?ID=" & Request.params("ID")
        ShowAlert ("The selected Unit Price Approval Sheet have been approved successfully.")
        redirectPage(ReturnURl)
    End Sub
    
    
    Sub redirectPage(ReturnURL as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>window.location=""" & ReturnURL & """;</script" & ">"
        If (Not IsStartupScriptRegistered("ClientRedirect")) Then Page.RegisterStartupScript("ClientRedirect", strScript)
    End sub
    
    Sub ShowAlert(Msg as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>alert(""" & Msg & """)</script" & ">"
        If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
    End sub
    
    Sub GenerateMail()
        Dim objEmail as New MailMessage()
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim StrMsg as string
        Dim TotalQty as decimal
        Dim TotalAmt as Decimal
        Dim POTotal as Decimal
        Dim ObjAttachment as MailAttachment
        Dim Sender,Receiver as string
    
        Sender = trim(request.cookies("U_ID").value)
        Receiver = ReqCOm.GetFieldVal("Select U_ID from Authority where module_name = 'UPA' and APP_TYPE = 'APP2.2'","U_ID")
    
        StrMsg = "Dear " & Receiver & vblf & vblf & vblf
        StrMsg = StrMsg + "There is a Unit Price Approval Sheet pending for your approval." & vblf & vblf
        StrMsg = StrMsg + "The UPA Reference no is " & trim(lblUPASNo.text) & ". Please use this reference for future reference." & vblf & vblf
        StrMsg = StrMsg + "Click on http://gtekapp/erp/signin.aspx?ReturnURL=UPAMgtAppDet.aspx?ID=" & Request.params("ID") & " to view the details."   & vblf & vblf
        StrMsg = StrMsg + "For assistance, please contact " & Sender & vblf  & vblf
        StrMsg = StrMsg + "Regards," & vblf
        StrMsg = StrMsg + Sender & vblf & vblf
    
        objEmail.To       = trim(Receiver)
        objEmail.From     = trim(Sender)
        objEmail.Subject  = "UPA No : " & lblUPASNo.text
        objEmail.Body     = StrMsg
        objEmail.Priority = MailPriority.High
        SmtpMail.SmtpServer  = "192.168.42.111"
        SmtpMail.Send(objEmail)
    End sub

</script>
<! Customer.aspx ><html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body onkeypress="KeyPress()" bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form runat="server">
        <p>
            <table style="HEIGHT: 28px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td colspan="2">
                            <IBUYSPY:HEADER id="UserControl2" runat="server"></IBUYSPY:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top" nowrap="nowrap" align="left" width="100%">
                            <p align="center">
                                <asp:Label id="Label5" runat="server" width="100%" cssclass="FormDesc">UNIT PRICE
                                APPROVAL SHEET APPROVAL</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 14px" cellspacing="0" cellpadding="0" width="80%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" ControlToValidate="txtReason" Display="Dynamic" ForeColor=" " ErrorMessage="You don't seem to have supplied a valid Approval Remarks" CssClass="ErrorText" Width="100%"></asp:RequiredFieldValidator>
                                                </p>
                                                <p>
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: white; BORDER-BOTTOM-COLOR: white; WIDTH: 100%; BORDER-TOP-COLOR: white; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: white" width="100%" align="center" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td width="25%" bgcolor="silver">
                                                                    <asp:Label id="Label3" runat="server" width="128px" cssclass="LabelNormal">Approval
                                                                    Sheet No</asp:Label></td>
                                                                <td>
                                                                    <div align="left"><asp:Label id="lblUPASNo" runat="server" width="480px" cssclass="OutputText"></asp:Label>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label4" runat="server" width="128px" cssclass="LabelNormal">Approved
                                                                    By</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblAppBy" runat="server" width="356px" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label1" runat="server" width="128px" cssclass="LabelNormal">Reason
                                                                    for approval</asp:Label></td>
                                                                <td>
                                                                    <div align="left">
                                                                        <asp:TextBox id="txtReason" runat="server" CssClass="OutputText" Width="100%" MaxLength="600"></asp:TextBox>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p align="center">
                                                    <table style="HEIGHT: 21px" width="100%" align="right">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <div align="left">
                                                                        <asp:Button id="cmdYes" onclick="cmdYes_Click" runat="server" Width="121px" Text="Submit"></asp:Button>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdNo" onclick="cmdNo_Click" runat="server" Width="130px" Text="Cancel"></asp:Button>
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
        <td>
        </td>
    </form>
    <!-- Insert content here -->
</body>
</html>
