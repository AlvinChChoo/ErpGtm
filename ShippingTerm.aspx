<%@ Page Language="VB" %>
<%@ Register TagPrefix="ERP" TagName="Content" Src="_ShippingTerm.ascx" %>
<%@ Register TagPrefix="ERP" TagName="Header" Src="_Header.ascx" %>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form enctype="multipart/form-data" runat="server">
        <table style="HEIGHT: 29px" cellspacing="0" cellpadding="0" width="100%">
            <tbody>
                <tr>
                    <td>
                        <erp:HEADER id="UserControl2" runat="server"></erp:HEADER>
                    </td>
                </tr>
                <tr>
                    <td>
                        <ERP:CONTENT id="UCContent" runat="server"></ERP:CONTENT>
                    </td>
                </tr>
            </tbody>
        </table>
    </form>
</body>
</html>
