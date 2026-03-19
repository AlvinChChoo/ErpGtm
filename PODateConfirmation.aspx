<%@ Page Language="VB" %>
<%@ Register TagPrefix="IBuySpy" TagName="Header" Src="_Header.ascx" %>
<%@ import Namespace="System.data" %>
<script runat="server">

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
    
    End Sub
    
    Sub cmdBack_Click_1(sender As Object, e As EventArgs)
        Response.redirect("Default.aspx")
    End Sub

</script>
<html>
<head>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0">
    <%@ import Namespace="System" %>
    <%@ import Namespace="System.configuration" %>
    <%@ import Namespace="System.data.sqlclient" %>
    <%@ import Namespace="System.Collections" %>
    <%@ import Namespace="System.Text" %>
    <%@ import Namespace="System.Web.UI.WebControls" %>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
    <form enctype="multipart/form-data" runat="server">
        <p>
            <table style="HEIGHT: 15px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <IBUYSPY:HEADER id="UserControl2" runat="server"></IBUYSPY:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label2" runat="server" width="100%" cssclass="FormDesc">Purchase Order
                                Details.</asp:Label>
                            </p>
                            <p align="center">
                                <asp:Label id="Label1" runat="server" cssclass="Instruction">P/O delivery date has
                                been updated successfully.</asp:Label>
                            </p>
                            <p align="center">
                                <asp:Button id="cmdBack" onclick="cmdBack_Click_1" runat="server" Text="Back" Width="77px"></asp:Button>
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
