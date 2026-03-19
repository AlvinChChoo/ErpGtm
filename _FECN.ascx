<%@ Control Language="VB" %>
<%@ import Namespace="System.data" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.configuration" %>
<%@ import Namespace="System.data.sqlclient" %>
<%@ import Namespace="System.Collections" %>
<%@ import Namespace="System.Text" %>
<%@ import Namespace="System.Web.UI.WebControls" %>
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
    
    Sub cmdNew_Click(sender As Object, e As EventArgs)
        Response.redirect("FECNAddNew.aspx")
    End Sub

</script>
<table style="HEIGHT: 5px" cellspacing="0" cellpadding="0" width="100%">
    <tbody>
        <tr>
            <td>
                <p align="center">
                    <asp:Label id="Label1" cssclass="FormDesc" backcolor="" width="100%" runat="server">FECN
                    LIST</asp:Label>
                </p>
                <p align="center">
                    <table style="WIDTH: 100%; HEIGHT: 51px" align="center" border="1">
                        <tbody>
                            <tr>
                                <td>
                                    <table style="WIDTH: 100%; HEIGHT: 7px">
                                        <tbody>
                                            <tr>
                                                <td colspan="3">
                                                    <asp:Label id="Label3" cssclass="LabelNormal" width="69px" runat="server">Search :</asp:Label>&nbsp;&nbsp;<asp:TextBox id="txtSearch" runat="server" CssClass="OutputText" Width="251px"></asp:TextBox>
                                                    &nbsp;&nbsp;<asp:Label id="Label4" cssclass="LabelNormal" width="145px" runat="server">By
                                                    Code , Description </asp:Label> 
                                                    <div align="right">
                                                    </div>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <table style="WIDTH: 100%; HEIGHT: 19px">
                                        <tbody>
                                            <tr valign="top">
                                                <td>
                                                    <asp:Label id="Label5" cssclass="LabelNormal" width="177px" runat="server">No of Records
                                                    to display </asp:Label>
                                                    <asp:TextBox id="txtNoOfRec" runat="server" CssClass="OutputText" Width="63px"></asp:TextBox>
                                                    &nbsp;&nbsp;<asp:Label id="Label6" cssclass="LabelNormal" width="42px" runat="server">(Max</asp:Label>&nbsp;<asp:Label id="lblMaxRec" runat="server"></asp:Label>&nbsp;<asp:Label id="Label7" cssclass="LabelNormal" width="69px" runat="server">records)</asp:Label></td>
                                                <td valign="top" colspan="2">
                                                    <div align="left">
                                                    </div>
                                                    <div align="right">
                                                        <asp:Button id="Button1" onclick="Button1_Click" runat="server" CausesValidation="False" Text="GO"></asp:Button>
                                                    </div>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </p>
                <p>
                    <asp:DataGrid id="GridControl1" width="100%" runat="server" AutoGenerateColumns="false" AlternatingItemStyle-CssClass="CartListItemAlt" ItemStyle-CssClass="CartListItem" FooterStyle-CssClass="cartlistfooter" HeaderStyle-CssClass="CartListHead" ShowFooter="true" Font-Size="8pt" Font-Name="Verdana" cellspacing="0" cellpadding="4" GridLines="Vertical" BorderColor="black">
                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                        <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                        <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                        <ItemStyle cssclass="GridItem"></ItemStyle>
                        <Columns>
                            <asp:HyperLinkColumn DataNavigateUrlField="SEQ_NO" DataNavigateUrlFormatString="FECNDet.aspx?ID={0}" Text="View" HeaderText=""></asp:HyperLinkColumn>
                            <asp:BoundColumn DataField="FECN_NO" HeaderText="FECN No"></asp:BoundColumn>
                            <asp:BoundColumn DataField="Model_No" HeaderText="Model No"></asp:BoundColumn>
                            <asp:BoundColumn DataField="ECN_No" HeaderText="ECN No"></asp:BoundColumn>
                            <asp:BoundColumn DataField="FECN_Date" HeaderText="FECN Date"></asp:BoundColumn>
                            <asp:BoundColumn DataField="Cust_ECN_No" HeaderText="Cust. ECN No"></asp:BoundColumn>
                        </Columns>
                    </asp:DataGrid>
                </p>
                <p>
                    <asp:Button id="cmdNew" onclick="cmdNew_Click" runat="server" CausesValidation="False" Text="Add New FECN"></asp:Button>
                </p>
            </td>
        </tr>
    </tbody>
</table>
<link href="IBuySpy.css" type="text/css" rel="stylesheet" />
<script language="javascript" src="script.js" type="text/javascript"></script>