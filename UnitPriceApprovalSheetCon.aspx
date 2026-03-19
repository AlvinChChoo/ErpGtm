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
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        if request.params("Act") = "Sub" then
            Label1.text = "Selected Approval Sheet have been submitted for approval"
            label2.text = ""
        else
            Label1.text = "New revision of Approval Sheet have need generated."
            label2.text = "The new approval sheet no is " & ReqCOM.GetFieldVal("select UPAS_No from upas_m where seq_no = '" & trim(request.params("ID")) & "';","UPAS_No")
        end if
    End Sub
    
    Sub LinkButton1_Click(sender As Object, e As EventArgs)
        Response.redirect("UnitPriceApprovalSheet.aspx")
    End Sub

</script>
<! Customer.aspx ><html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form enctype="multipart/form-data" runat="server">
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
                                APPROVAL SHEET</asp:Label>
                            </p>
                            <p align="center">
                                <asp:Label id="Label1" runat="server" cssclass="Instruction">Selected Approval Sheet
                                have been submitted for approval</asp:Label>
                            </p>
                            <p align="center">
                                <asp:Label id="Label2" runat="server" cssclass="Instruction"></asp:Label>
                            </p>
                            <p align="center">
                                <asp:LinkButton id="LinkButton1" onclick="LinkButton1_Click" runat="server">Check for new Approval Sheet</asp:LinkButton>
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
