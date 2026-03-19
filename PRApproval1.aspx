<%@ Page Language="VB" %>
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
        if page.isPostBack = false then label3.text = "PR approval No : " & request.params("ID")
    End Sub
    
    Sub cmdCancel_Click(sender As Object, e As EventArgs)
        response.redirect("PRDet.aspx?ID=" & request.params("ID"))
    End Sub
    
    Sub LinkButton1_Click(sender As Object, e As EventArgs)
        response.redirect("TempPRHODPendingPRSubmission.aspx")
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
            <table style="HEIGHT: 9px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <IBUYSPY:HEADER id="UserControl2" runat="server"></IBUYSPY:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label2" runat="server" cssclass="FormDesc" width="100%">PART APPROVAL
                                LIST</asp:Label>
                            </p>
                            <p align="center">
                                <asp:Label id="Label1" runat="server" cssclass="Instruction" width="100%">Parts have
                                been sent for approval.</asp:Label>
                            </p>
                            <p align="center">
                                <asp:Label id="Label3" runat="server" cssclass="LabelNormal" width="100%"></asp:Label>
                            </p>
                            <p align="center">
                                <asp:LinkButton id="LinkButton1" onclick="LinkButton1_Click" runat="server">Check for new parts.</asp:LinkButton>
                            </p>
                        </td>
                    </tr>
                </tbody>
            </table>
        </p>
        <p>
        </p>
        <td>
        </td>
    </form>
</body>
</html>
