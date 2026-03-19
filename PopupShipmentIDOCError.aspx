<%@ Page Language="vb" autoeventwireup="false" codebehind="PopupShipmentIDOCError.aspx.vb" Inherits="bbraun.WebForm2" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
    <title>Shipment IDOC Error Messasge List</title>
    <meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR" />
    <meta content="Visual Basic .NET 7.1" name="CODE_LANGUAGE" />
    <meta content="JavaScript" name="vs_defaultClientScript" />
    <meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema" />
    <link href="../../bax.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="/BBraun/Scripts/Application.js"></script>
</head>
<body ms_positioning="GridLayout">
    <form id="Form1" method="post" runat="server">
        <asp:DataGrid id="DgOrderStatus" style="Z-INDEX: 100; LEFT: 8px; POSITION: absolute; TOP: 104px" Width="592px" AllowSorting="True" Runat="server" AutoGenerateColumns="False">
            <SelectedItemStyle cssclass="select"></SelectedItemStyle>
            <AlternatingItemStyle cssclass="alternate"></AlternatingItemStyle>
            <ItemStyle cssclass="body"></ItemStyle>
            <HeaderStyle cssclass="header"></HeaderStyle>
            <Columns>
                <asp:BoundColumn DataField="ERR_MESSAGE" SortExpression="Status" HeaderText="Error Message(s)">
                    <HeaderStyle horizontalalign="Left" verticalalign="Top"></HeaderStyle>
                    <ItemStyle wrap="False" horizontalalign="Left" verticalalign="Top"></ItemStyle>
                </asp:BoundColumn>
                <asp:BoundColumn DataField="EDIT_DATE" SortExpression="Status" HeaderText="Import Date">
                    <HeaderStyle horizontalalign="Left" verticalalign="Top"></HeaderStyle>
                    <ItemStyle wrap="False"></ItemStyle>
                </asp:BoundColumn>
            </Columns>
            <PagerStyle position="TopAndBottom" cssclass="pagearea" mode="NumericPages"></PagerStyle>
        </asp:DataGrid>
        <asp:Label id="lblRemarks" style="Z-INDEX: 108; LEFT: 8px; POSITION: absolute; TOP: 104px" runat="server" forecolor="Black" height="32px" font-size="Medium" width="584px">No
        record found !!!</asp:Label>
        <asp:Button id="cmdResend" visible = "false" style="Z-INDEX: 107; LEFT: 232px; POSITION: absolute; TOP: 208px" runat="server" Width="96px" Height="24px" Text="Resend"></asp:Button>
        <asp:Label id="lblMPPNo" style="Z-INDEX: 104; LEFT: 136px; POSITION: absolute; TOP: 64px" runat="server" forecolor="#0000C0" height="32px" font-size="Medium" width="160px"></asp:Label><asp:Label id="Label2" style="Z-INDEX: 102; LEFT: 8px; POSITION: absolute; TOP: 64px" runat="server" forecolor="#0000C0" height="32px" font-size="Medium" width="120px">MPP
        No : </asp:Label><asp:Label id="Label1" style="Z-INDEX: 101; LEFT: 8px; POSITION: absolute; TOP: 8px" runat="server" height="32px" font-size="X-Large" width="608px">SHIPMENT
        IDOC ERROR MESSAGE</asp:Label>
        <asp:Button id="cmdClose" style="Z-INDEX: 105; LEFT: 8px; POSITION: absolute; TOP: 208px" runat="server" Width="96px" Height="24px" Text="Close"></asp:Button>
        <asp:Button id="cmdPrint" style="Z-INDEX: 106; LEFT: 120px; POSITION: absolute; TOP: 208px" runat="server" Width="96px" Height="24px" Text="Print"></asp:Button>
    </form>
</body>
</html>
