<%@ Page Language="VB" %>
<%@ import Namespace="System.data" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.configuration" %>
<%@ import Namespace="System.data.sqlclient" %>
<script runat="server">

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        If Not Page.IsPostBack Then
            Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
            myConnection.Open()
            Dim myCommand As SqlCommand = New SqlCommand("select * from FECN_M", myConnection)
            Dim result As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
            GridControl1.DataSource = result
            GridControl1.DataBind()
        end if
    End Sub
    
    Sub Button1_Click(sender As Object, e As EventArgs)
    
    End Sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    
    End Sub
    
    Sub Button1_Click_1(sender As Object, e As EventArgs)
        Response.Redirect("FECN_D.aspx?Prodid=101")
    End Sub

</script>
<form runat="server">
    <p>
        &nbsp;<asp:DataGrid id="GridControl1" runat="server" BorderColor="black" width="90%" GridLines="Vertical" cellpadding="4" cellspacing="0" Font-Name="Verdana" Font-Size="8pt" ShowFooter="true" HeaderStyle-CssClass="CartListHead" FooterStyle-CssClass="cartlistfooter" ItemStyle-CssClass="CartListItem" AlternatingItemStyle-CssClass="CartListItemAlt" AutoGenerateColumns="false">
            <FooterStyle cssclass="cartlistfooter"></FooterStyle>
            <HeaderStyle cssclass="CartListHead"></HeaderStyle>
            <AlternatingItemStyle cssclass="CartListItemAlt" backcolor="#E0E0E0"></AlternatingItemStyle>
            <ItemStyle cssclass="CartListItem"></ItemStyle>
            <Columns>
                <asp:hyperlinkcolumn HeaderText="FECN No" DataNavigateurlformatstring="FECN2.aspx?FECN_No={0}" DataNavigateUrlField="FECN_No" Datatextfield="FECN_No" />
                <asp:BoundColumn DataField="FECN_NO" HeaderText="FECN No"></asp:BoundColumn>
                <asp:BoundColumn DataField="Model_No" HeaderText="Model No"></asp:BoundColumn>
                <asp:BoundColumn DataField="ECN_No" HeaderText="ECN No"></asp:BoundColumn>
                <asp:BoundColumn DataField="FECN_Date" HeaderText="FECN Date"></asp:BoundColumn>
                <asp:BoundColumn DataField="Cust_ECN_No" HeaderText="Cust. ECN No"></asp:BoundColumn>
            </Columns>
        </asp:DataGrid>
    </p>
</form>