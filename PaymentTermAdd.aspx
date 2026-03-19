<%@ Page Language="VB" %>
<%@ Register TagPrefix="ERP" TagName="Header" Src="_Header.ascx" %>
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
    
        end if
    End Sub
    
    Sub cmdAddNew_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim reqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
            Dim StrSql as string
    
            StrSQL = "Insert into Payterm(Payterm_Desc,No_Of_Days,Create_By,Create_Date) "
            StrSQL = StrSQl + "Select '" & trim(txtDesc.text) & "',"
            StrSQL = StrSQl + "" & txtNoOfDays.text & ","
            StrSQL = StrSQl + "'" & trim(request.cookies("U_ID").value) & "',"
            StrSQL = StrSQl + "'" & now & "';"
    
            ReqCOM.ExecuteNonQuery(StrSQL)
            Response.redirect("PaymentTermCon.aspx")
        End if
    End Sub
    
    Sub ValDuplicateColor(sender As Object, e As ServerValidateEventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTm
        If ReqCOM.FuncCheckDuplicate("Select Payterm_Desc from payterm where payterm_Desc = '" & trim(txtDesc.text) & "';","Payterm_Desc") = true then
            e.isvalid = false
        else
            e.isvalid = true
        end if
    End Sub
    
    Sub cmdNo_Click(sender As Object, e As EventArgs)
        response.redirect("PaymentTerm.aspx")
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form enctype="multipart/form-data" runat="server">
        <p>
            <table style="HEIGHT: 10px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <erp:HEADER id="UserControl2" runat="server"></erp:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label1" runat="server" width="100%" forecolor="" backcolor="" cssclass="FormDesc">PAYMENT
                                TERM LIST</asp:Label>
                            </p>
                            <p align="center">
                                <asp:CustomValidator id="CustomValidator1" runat="server" CssClass="ErrorText" ForeColor=" " Display="Dynamic" ControlToValidate="txtDesc" OnServerValidate="ValDuplicateColor" EnableClientScript="False">
                                    'Payment Term' already exist.
                                </asp:CustomValidator>
                            </p>
                            <p align="center">
                                <asp:RequiredFieldValidator id="valFeature" runat="server" CssClass="ErrorText" ForeColor=" " Display="Dynamic" ControlToValidate="txtDesc" ErrorMessage="You don't seem to have supplied a valid payment Term." EnableClientScript="False"></asp:RequiredFieldValidator>
                            </p>
                            <p align="center">
                                <asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" CssClass="ErrorText" ForeColor=" " Display="Dynamic" ControlToValidate="txtNoOfDays" ErrorMessage="You don't seem to have supplied a valid No Of Days value." EnableClientScript="False"></asp:RequiredFieldValidator>
                            </p>
                            <p align="center">
                                <asp:comparevalidator id="ValOrderQtyFormat" runat="server" CssClass="ErrorText" Width="100%" ForeColor=" " Display="Dynamic" ControlToValidate="txtNoOfDays" ErrorMessage="You don't seem to have supplied a valid No Of Days value." EnableClientScript="False" Type="Integer" Operator="DataTypeCheck"></asp:comparevalidator>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 30px" width="100%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p align="center">
                                                    <asp:Label id="Label9" runat="server" width="94px" cssclass="LabelNormal">Payment
                                                    Term</asp:Label>&nbsp;&nbsp;&nbsp;&nbsp; 
                                                    <asp:TextBox id="txtDesc" runat="server" CssClass="OutputText" Width="263px" MaxLength="100"></asp:TextBox>
                                                </p>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <p align="center">
                                                    <asp:Label id="Label8" runat="server" width="94px" cssclass="LabelNormal">No of Days</asp:Label>&nbsp;&nbsp;&nbsp;&nbsp; 
                                                    <asp:TextBox id="txtNoOfDays" runat="server" CssClass="OutputText" Width="263px" MaxLength="100"></asp:TextBox>
                                                </p>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </p>
                            <p align="center">
                                <asp:Label id="Label2" runat="server" cssclass="Instruction">Are you sure to add the
                                above Payment Term ?</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 12px" width="100%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <div align="right">
                                                    <asp:Button id="cmdNew" onclick="cmdAddNew_Click" runat="server" Width="53px" Text="Yes"></asp:Button>
                                                    &nbsp;&nbsp;&nbsp;&nbsp; 
                                                </div>
                                            </td>
                                            <td>
                                                &nbsp;&nbsp;&nbsp;&nbsp; 
                                                <asp:Button id="cmdNo" onclick="cmdNo_Click" runat="server" Width="53px" Text="No" CausesValidation="False"></asp:Button>
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
