<%@ Page Language="VB" %>
<%@ Register TagPrefix="IBuySpy" TagName="Header" Src="_Header.ascx" %>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form runat="server">
        <p>
            <table style="HEIGHT: 15px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <IBuySpy:Header id="Header1" runat="server"></IBuySpy:Header>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p>
                            </p>
                            <p align="center">
                            </p>
                            <p align="center">
                                &nbsp;
                            </p>
                            <p align="center">
                                <asp:Label id="Label1" runat="server" width="100%" cssclass="Instruction">We are sorry,
                                you are not authorised to view this page.</asp:Label>
                            </p>
                            <p align="center">
                            </p>
                        </td>
                    </tr>
                </tbody>
            </table>
        </p>
        <p>
        </p>
    </form>
</body>
</html>
