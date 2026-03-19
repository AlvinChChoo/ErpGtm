<%@ Page Language="VB" %>
<%@ Register TagPrefix="ERP" TagName="Content" Src="_ProductType.ascx" %>
<%@ Register TagPrefix="ERP" TagName="Header" Src="_Header.ascx" %>
<html>
<head>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form runat="server">
        <table style="HEIGHT: 24px" cellspacing="0" cellpadding="0" width="100%">
            <tbody>
                <tr>
                    <td>
                        <ERP:HEADER id="UserControl2" runat="server"></ERP:HEADER>
                    </td>
                </tr>
                <tr>
                    <td>
                        <ERP:CONTENT id="UCControl" runat="server"></ERP:CONTENT>
                    </td>
                </tr>
            </tbody>
        </table>
    </form>
</body>
</html>
