<%@ Control Language="VB" %>
<script runat="server">

    Sub SignOff(sender As Object, e As EventArgs)
        response.redirect("SignIn.aspx")
    End Sub
    
    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        if request.cookies("U_ID") is nothing then response.redirect("SignIn.aspx")
        lblUser.text = "Current User : " + request.cookies("U_ID").value
    end sub
    
    Sub cmdHome_Click(sender As Object, e As EventArgs)
        response.redirect("Default.aspx")
    End Sub
    
    Sub cmdSignOff_Click(sender As Object, e As EventArgs)
        response.redirect("SignIn.aspx")
    End Sub
    
    Sub cmdContactMe_Click(sender As Object, e As EventArgs)
        response.redirect("ContactMe.aspx")
    End Sub

</script>
<table style="HEIGHT: 30px" width="100%" bgcolor="black">
    <tbody>
        <tr>
            <td rowspan="2">
                <asp:Image id="Image1" runat="server" Width="61px" ImageUrl="logo.jpg" Height="66px"></asp:Image>
            </td>
            <td colspan="4">
                <p>
                    <asp:Label id="Label1" runat="server" width="510px" font-size="Medium" font-names="Comic Sans MS" font-bold="True" forecolor="White" height="16px">G-Tek
                    Electronics Sdn. Bhd.</asp:Label>
                </p>
            </td>
        </tr>
        <tr>
            <td>
                <p>
                    <asp:Label id="lblUser" runat="server" width="300px" font-names="Comic Sans MS" forecolor="White" height="8px">Label</asp:Label>
                </p>
            </td>
            <td width="10">
                <div align="right">
                    <asp:Button id="cmdContactMe" onclick="cmdContactMe_Click" runat="server" Width="75px" CausesValidation="False" Text="Contact" CssClass="Submit_Button"></asp:Button>
                </div>
            </td>
            <td width="10">
                <div align="right">
                    <asp:Button id="cmdHome" onclick="cmdHome_Click" runat="server" Width="75px" CausesValidation="False" Text="Home" CssClass="Submit_Button"></asp:Button>
                </div>
            </td>
            <td width="10">
                <div align="right">
                    <asp:Button id="cmdSignOff" onclick="cmdSignOff_Click" runat="server" Width="75px" CausesValidation="False" Text="Sign Off" CssClass="Submit_Button"></asp:Button>
                </div>
            </td>
        </tr>
    </tbody>
</table>