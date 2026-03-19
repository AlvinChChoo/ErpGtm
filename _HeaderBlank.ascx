<%@ Control Language="VB" %>
<script runat="server">

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
    
    end sub

</script>
<table style="WIDTH: 100%; HEIGHT: 30px" bgcolor="black">
    <tbody>
        <tr>
            <td rowspan="2">
                <asp:Image id="Image1" runat="server" Width="61px" ImageUrl="logo.jpg" Height="66px"></asp:Image>
            </td>
            <td colspan="3">
                <p>
                    <asp:Label id="Label1" runat="server" width="510px" font-size="Medium" font-names="Comic Sans MS" font-bold="True" forecolor="White" height="16px">G-Tek
                    Electronics Sdn. Bhd.</asp:Label>
                </p>
            </td>
        </tr>
        <tr>
            <td>
                <p>
                    &nbsp;
                </p>
            </td>
            <td>
                <div align="right">&nbsp;
                </div>
            </td>
            <td>
                <div align="right">&nbsp;
                </div>
            </td>
        </tr>
    </tbody>
</table>