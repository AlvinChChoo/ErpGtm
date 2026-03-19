<%@ Page Language="VB" %>
<script runat="server">

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        Button1.Attributes.Add("onclick","javascript:if(confirm('Are you sure everything is correct?')== false) return false;")
        'Button1.attributes.add("onClick","javascript:GetConfirmation")
    end sub
    
    Sub Button1_Click(sender As Object, e As EventArgs)
        Message.Text = "You entered your name as: " + txtName.Text
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body>
    <form runat="server">
        <p>
        </p>
        <p>
            <asp:Button id="Button1" onclick="Button1_Click" runat="server" Text="Button"></asp:Button>
        </p>
        <p>
            <asp:Label id="Message" runat="server" width="">Label</asp:Label>
        </p>
        <p>
            <asp:TextBox id="txtName" runat="server"></asp:TextBox>
        </p>
    </form>
</body>
</html>
