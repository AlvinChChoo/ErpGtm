<%@ Page Language="VB" Debug="true" %>
<%@ Register TagPrefix="IBuySpy" TagName="Header" Src="_Header.ascx" %>
<%@ import Namespace="System.data" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.configuration" %>
<%@ import Namespace="System.data.sqlclient" %>
<%@ import Namespace="System.Collections" %>
<%@ import Namespace="System.Text" %>
<%@ import Namespace="System.Web.Mail" %>
<%@ import Namespace="System.Web.UI.WebControls" %>
<script runat="server">

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        cmdYes.attributes.add("onClick","javascript:if(confirm('You will not be able to undo the changes after reject.\nAre you sure you want to reject this Unit Price Approval Sheet ?')==false) return false;")
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

    Sub cmdNo_Click(sender As Object, e As EventArgs)
        response.redirect("UPAAcc2AppDet.aspx?ID=" & Request.params("ID"))
    End Sub

    Sub cmdYes_Click(sender As Object, e As EventArgs)
        Dim ReqCOM AS erp_gtm.erp_gtm = NEW erp_gtm.erp_gtm
        Dim ReturnURL,RSender,Receiver,CC as string

        ReqCOM.executenonquery("Update UPAS_M set upas_statUS = 'REJECTED', ACC2_STATUS = 'REJECTED', ACC2_BY='" & TRIM(request.cookies("U_ID").value) & "',ACC2_date = '" & now & "',ACC2_REM = '" & TRIM(txtReason.text) & "' where seq_no = " & cint(request.params("ID")) & ";")

        RSender = trim(request.cookies("U_ID").value)
        Receiver = ReqCOM.GetFieldVal("select Submit_By from UPAS_M where UPAS_NO = '" & trim(lblUPASNo.text) & "';","Submit_By")
        CC = ReqCOM.GetFieldVal("Select Email from User_Profile where U_ID in (Select Purc_By from upas_m where upas_no = '" & trim(lblUPASNo.text) & "')","Email")
        CC = CC & ";" & ReqCOM.GetFieldVal("Select Email from User_Profile where U_ID in (select ACC1_By from UPAS_M where UPAS_No = '" & trim(lblUPASNo.text) & "')","EMail")

        GeneratePendingEmailList(RSender, Receiver ,CC ,trim(lblUPASNo.text) ,"N")

        ReturnURL = "UPAAcc2App.aspx"
        ShowAlert ("The selected Unit Price Approval Sheet have been rejected successfully.")
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

    Sub GeneratePendingEmailList(Sender as string, Receiver as string,CC as string,DOcNo as string,SSERStat as string)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim FromEmail,ToEmail,EmailSubject,EmailContent as string

        EmailContent = "Dear " & Receiver & vblf & vblf & vblf
        EmailContent = EmailContent + "There is a Rejected UPA." & vblf & vblf
        EmailContent = EmailContent + "The UPA Reference no. is " & trim(lblUPASNo.text) & ". Please use this reference for future reference." & vblf & vblf
        EmailContent = EmailContent + "For assistance, please contact " & Sender & vblf  & vblf
        EmailContent = EmailContent + "Regards," & vblf
        EmailContent = EmailContent + Sender & vblf & vblf

        EmailSubject = "REJECTED UNIT PRICE APPROVAL SHEET : " & lblUPASNo.text

        FromEmail = ReqCOM.GetFieldVal("Select Email from User_Profile where U_ID = '" & trim(Sender) & "';","Email")
        ToEmail = ReqCOM.GetFieldVal("Select Email from User_Profile where U_ID = '" & trim(Receiver) & "';","Email")

        ReqCOM.ExecuteNonQuery("Insert into pending_email(FROM_EMAIL,FROM_NAME,TO_NAME,TO_EMAIL,EMAIL_SUBJECT,EMAIL_CONTENT,MODULE_NAME,ADD_ATT,REF_NO,CC) select '" & trim(FromEmail) & "','" & trim(Sender) & "','" & trim(Receiver) & "','" & trim(ToEmail) & "','" & trim(EmailSubject) & "','" & trim(EmailContent) & "','UPA','N','" & trim(DOcNo) & "','" & trim(CC) & "'")
    End sub

</script>
<! Customer.aspx ><html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
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
                                APPROVAL SHEET REJECT</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 14px" cellspacing="0" cellpadding="0" width="80%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p align="center">
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" CssClass="ErrorText" ErrorMessage="You don't seem to have supplied a valid reason for reject." ForeColor=" " Display="Dynamic" ControlToValidate="txtReason"></asp:RequiredFieldValidator>
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
                                                                    <asp:Label id="Label4" runat="server" width="128px" cssclass="LabelNormal">Reject
                                                                    By</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblRejBy" runat="server" width="356px" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label1" runat="server" width="128px" cssclass="LabelNormal">Reason
                                                                    for reject</asp:Label></td>
                                                                <td>
                                                                    <div align="left">
                                                                        <asp:TextBox id="txtReason" runat="server" CssClass="OutputText" MaxLength="600" Width="100%"></asp:TextBox>
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
                                                                        <asp:Button id="cmdYes" onclick="cmdYes_Click" runat="server" Width="148px" Text="Submit"></asp:Button>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdNo" onclick="cmdNo_Click" runat="server" Width="148px" Text="Cancel" CausesValidation="False"></asp:Button>
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
