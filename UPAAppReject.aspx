<%@ Page Language="VB" Debug="true" %>
<%@ Register TagPrefix="IBuySpy" TagName="Header" Src="_Header.ascx" %>
<%@ import Namespace="System.data" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.configuration" %>
<%@ import Namespace="System.data.sqlclient" %>
<%@ import Namespace="System.Web.Mail" %>
<%@ import Namespace="System.Collections" %>
<%@ import Namespace="System.Text" %>
<%@ import Namespace="System.Web.UI.WebControls" %>
<script runat="server">

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        IF page.ispostback=false then
            Dim ReqCOm as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
            Dim RsUPASM as SqlDataReader = ReqCOm.ExeDataReader("Select * from UPAS_M where Seq_No = '" & trim(request.params("ID")) & "';")
    
            Do while RsUPASM.read
                lblUPASNo.text = RsUPASM("UPAS_NO").tostring
                lblRejBy.text = trim(Request.cookies("U_ID").value)
            loop
            RsUPASM.Close
        end if
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
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub cmdNo_Click(sender As Object, e As EventArgs)
        response.redirect("UPAAppDet.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Sub cmdYes_Click(sender As Object, e As EventArgs)
        Dim ReqCOM AS erp_gtm.erp_gtm = NEW erp_gtm.erp_gtm
        Dim ReturnURl as string
        ReqCOM.executenonquery("Update UPAS_M set upas_statUS = 'REJECTED', PURC_STATUS = 'REJECTED', PURC_BY='" & TRIM(request.cookies("U_ID").value) & "',Purc_date = '" & now & "',PURC_REM = '" & TRIM(txtReason.text) & "' where seq_no = " & cint(request.params("ID")) & ";")
    
        GenerateMail()
        ReturnURL = "UPAApp.aspx?ID=" & Request.params("ID")
        ShowAlert ("The selected Unit Price Approval Sheet have been rejected.")
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
        Dim Sender,Receiver,CC as string
    
        Sender = trim(request.cookies("U_ID").value)
        Receiver = ReqCOM.GetFieldVal("select Submit_By from UPAS_M where UPAS_NO = '" & trim(lblUPASNo.text) & "';","Submit_By")
    
        StrMsg = "Dear " & Receiver & vblf & vblf & vblf
        StrMsg = StrMsg + "There is a Rejected UPA." & vblf & vblf
        StrMsg = StrMsg + "The UPA Reference no. is " & trim(lblUPASNo.text) & ". Please use this reference for future reference." & vblf & vblf
        StrMsg = StrMsg + "For assistance, please contact " & Sender & vblf  & vblf
        StrMsg = StrMsg + "Regards," & vblf
        StrMsg = StrMsg + Sender & vblf & vblf
        objEmail.To       = trim(ReqCOM.GetFieldVal("Select EMail from User_Profile where U_ID = '" & trim(Receiver) & "';","EMail"))
        objEmail.From     = trim(ReqCOM.GetFieldVal("Select EMail from User_Profile where U_ID = '" & trim(Sender) & "';","EMail"))
    
        objEmail.Subject  = "REJECTED UNIT PRICE APPROVAL SHEET : " & lblUPASNo.text
        objEmail.Body     = StrMsg
        objEmail.Priority = MailPriority.High
        SmtpMail.SmtpServer  = "192.168.42.111"
        SmtpMail.Send(objEmail)
    End sub
    
    Sub MyList_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub

</script>
<! Customer.aspx ><html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body onkeypress="KeyPress()" bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
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
                                <asp:Label id="Label5" runat="server" cssclass="FormDesc" width="100%">UNIT PRICE
                                APPROVAL SHEET REJECT</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 14px" cellspacing="0" cellpadding="0" width="98%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p align="center">
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" ControlToValidate="txtReason" Display="Dynamic" ForeColor=" " ErrorMessage="You don't seem to have supplied a valid reason for reject." CssClass="ErrorText"></asp:RequiredFieldValidator>
                                                </p>
                                                <p>
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: white; BORDER-BOTTOM-COLOR: white; BORDER-TOP-COLOR: white; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: white" width="80%" align="center" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td width="25%" bgcolor="silver">
                                                                    <asp:Label id="Label3" runat="server" cssclass="LabelNormal" width="128px">Approval
                                                                    Sheet No</asp:Label></td>
                                                                <td>
                                                                    <div align="left"><asp:Label id="lblUPASNo" runat="server" cssclass="OutputText" width="100%"></asp:Label>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label4" runat="server" cssclass="LabelNormal" width="128px">Reject
                                                                    By</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblRejBy" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label1" runat="server" cssclass="LabelNormal" width="128px">Reason
                                                                    for reject</asp:Label></td>
                                                                <td>
                                                                    <div align="left">
                                                                        <asp:TextBox id="txtReason" runat="server" CssClass="OutputText" Width="100%"></asp:TextBox>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p align="center">
                                                    <asp:Label id="Label2" runat="server" cssclass="Instruction">Are you sure to reject
                                                    this Approval Sheet ?</asp:Label>
                                                </p>
                                                <p align="center">
                                                    <table style="HEIGHT: 21px" width="100%" align="right">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdYes" onclick="cmdYes_Click" runat="server" Width="53px" Text="Yes"></asp:Button>
                                                                        &nbsp;&nbsp;&nbsp;&nbsp; 
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div align="left">&nbsp;&nbsp;&nbsp;&nbsp; 
                                                                        <asp:Button id="cmdNo" onclick="cmdNo_Click" runat="server" Width="53px" Text="No" CausesValidation="False"></asp:Button>
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
