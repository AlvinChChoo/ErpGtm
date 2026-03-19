<%@ Page Language="VB" %>
<%@ import Namespace="System.data" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.configuration" %>
<%@ import Namespace="System.data.sqlclient" %>
<%@ import Namespace="System.Collections" %>
<%@ import Namespace="System.Text" %>
<%@ import Namespace="System.Web.UI.WebControls" %>
<script runat="server">

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        if page.isPostBack = false then
            Dim ReqGetFieldVal as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
            procLoadGridData ()
        end if
    End Sub
    
    Sub ProcLoadGridData()
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
    
    
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet("select distinct(vendor.ven_name) as [Venname],sum(buyer_sr_d.Qty_To_Buy * buyer_sr_d.UP) as [TotalAmt] from buyer_sr_d,vendor where sr_no = '" & trim(request.params("SRNo")) & "' and buyer_sr_d.ven_code = vendor.ven_code group by vendor.ven_name","sr_d")
        GridControl1.DataSource=resExePagedDataSet.Tables("sr_d").DefaultView
        GridControl1.DataBind()
    end sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
        Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
            If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
    
                Dim TotalAmt As Label = CType(e.Item.FindControl("TotalAmt"), Label)
    
                TotalAmt.text = format(cdec(TotalAmt.text),"##,##0.00")
            End if
        End Sub

</script>
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
                            <p align="center">
                            </p>
                            <p align="center">
                            </p>
                            <p align="center">
                                &nbsp;
                            </p>
                            <p align="center">
                                <asp:DataGrid id="GridControl1" runat="server" AutoGenerateColumns="False" cellpadding="4" GridLines="Vertical" BorderColor="Black" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" PagerStyle-HorizontalAligh="Right" width="90%" OnItemDataBound="FormatRow">
                                    <FooterStyle cssclass="GridFooter"></FooterStyle>
                                    <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                    <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                    <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                    <ItemStyle cssclass="GridItem"></ItemStyle>
                                    <Columns>
                                        <asp:TemplateColumn HeaderText="Supplier">
                                            <ItemTemplate>
                                                <asp:Label id="Col1" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Venname") %>' /> 
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderText="Purchase Amt.">
                                            <ItemTemplate>
                                                <asp:Label id="TotalAmt" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "TotalAmt") %>' /> 
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                    </Columns>
                                </asp:DataGrid>
                            </p>
                        </td>
                    </tr>
                </tbody>
            </table>
        </p>
    </form>
</body>
</html>
