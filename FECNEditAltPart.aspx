<%@ Page Language="VB" %>
<%@ Register TagPrefix="ERP" TagName="Content" Src="_FECNEditAltPart.ascx" %>
<%@ Register TagPrefix="ERP" TagName="Header" Src="_Header.ascx" %>
<html>
<head>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form enctype="multipart/form-data" runat="server">
        <table style="HEIGHT: 27px" cellspacing="0" cellpadding="0" width="100%">
            <tbody>
                <tr>
                    <td>
                        <ERP:HEADER id="UserControl2" runat="server"></ERP:HEADER>
                    </td>
                </tr>
                <tr>
                    <td>
                        <ERP:Content id="UserControl1" runat="server"></ERP:Content>
                    </td>
                </tr>
            </tbody>
        </table>
    </form>
</body>
</html>
